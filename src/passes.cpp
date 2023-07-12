//
// Created by dcr on 23-7-10.
//

#include "passes.h"

void Passes::Optimizer(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createDeadInstEliminationPass());
    passManager.add(llvm::createMergeICmpsLegacyPass());
    passManager.add(llvm::createSCCPPass());
    passManager.add(llvm::createDeadCodeEliminationPass());
    passManager.run(*ir.module_);
}

void Passes::LoopOptimizer(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createLoopUnrollPass());
    passManager.add(llvm::createLoopVersioningLICMPass());
    passManager.run(*ir.module_);
}

void Passes::DeadCodeDelete(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createCFGSimplificationPass());
    passManager.add(llvm::createDeadInstEliminationPass());
    passManager.run(*ir.module_);
}

void Passes::InsCombine(IR &ir) {
    llvm::legacy::PassManager passManager;

}

void Passes::ConvertToSSA(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createPromoteMemoryToRegisterPass());
    passManager.run(*ir.module_);
}

void Passes::MyDCE(IR &ir) {
    bool modified = false;
    std::stack<llvm::Instruction *> deadIns;
    for (auto &F: ir.module_->getFunctionList()) {
        for (auto &block: F.getBasicBlockList()) {
            for (auto &ins: block.getInstList()) {
                if (isDeadIns(ins)) {
                    deadIns.push(&ins);
                    modified = true;
                }
            }
        }
        while (!deadIns.empty()) {
            auto ins = deadIns.top();
            ins->eraseFromParent();
            deadIns.pop();
        }
    }
    if (modified) {
        llvm::outs() << "modified\n";
    } else {
        llvm::outs() << "not modified\n";
    }
}

bool Passes::isDeadIns(llvm::Instruction &ins) {
    if (!ins.hasNUses(0)) {
        return false;
    }
    if (ins.mayHaveSideEffects()) {
        return false;
    }
    if (llvm::isa<llvm::BranchInst>(ins) || llvm::isa<llvm::SwitchInst>(ins)) {
        return false;
    }
    if (llvm::isa<llvm::StoreInst>(ins)) {
        return false;
    }
    return ins.isEHPad() || ins.isTerminator();
}

void Passes::isLiveIns(IR &ir) {

//    llvm::LibFunc.
}

llvm::Value *isConstant(llvm::Value *operands, IR &ir) {
    if (auto ins = llvm::dyn_cast<llvm::Instruction>(operands)) {
        if (!llvm::dyn_cast<llvm::AllocaInst>(ins) &&
            !llvm::dyn_cast<llvm::BranchInst>(ins) &&
            !llvm::dyn_cast<llvm::ReturnInst>(ins)) {
            if (llvm::dyn_cast<llvm::StoreInst>(ins)) {
                // 检查store指令的操作数是否是正常的
                if (auto constant = isConstant(ins->getOperand(0), ir)) {
                    ins->replaceAllUsesWith(constant);
                    return constant;
                }
                return nullptr;
            }
            if (llvm::dyn_cast<llvm::LoadInst>(ins)) {
                if (auto constant = isConstant(ins->getOperand(0), ir)) {
                    ins->replaceAllUsesWith(constant);
                    return constant;
                }
                return nullptr;
            }
            auto temp_ins = llvm::dyn_cast<llvm::Instruction>(ins->getOperand(0));
            temp_ins = llvm::dyn_cast<llvm::Instruction>(temp_ins->getOperand(0));
            temp_ins->print(llvm::outs());
            llvm::outs() << '\n';
            // 纯算数指令
            auto op1 = isConstant(ins->getOperand(0), ir);
            auto op2 = isConstant(ins->getOperand(1), ir);
            if (op1) {
                llvm::outs() << "op1 is not nullptr\n";
            }
            if (op2) {
                llvm::outs() << "op2 is not nullptr\n";
            }
            if (op1 && op2) {
                auto const_op1 = llvm::dyn_cast<llvm::ConstantInt>(op1);
                auto const_op2 = llvm::dyn_cast<llvm::ConstantInt>(op2);
                llvm::outs() << "enter\n";
                int re = std::stoi(const_op1->getValue().toString(10, true)) +
                         std::stoi(const_op2->getValue().toString(10, true));
                if (llvm::isa<llvm::AddOperator>(ins)) {
                    llvm::ConstantInt *add_result = llvm::ConstantInt::get(ir.module_->getContext(),
                                                                           llvm::APInt(re, 32));
                    ins->replaceAllUsesWith(add_result);
                    return add_result;
                }
            }
        }
    } else if (auto constant = llvm::dyn_cast<llvm::ConstantInt>(operands)) {
        return constant;
    } else {
        return nullptr;
    }
}


void BuildOpTree(llvm::BasicBlock &block, std::map<llvm::Value *, OpTreeNode *> &tree) {
    for (auto &ins: llvm::reverse(block.getInstList())) {
        for (int i = 0; i < ins.getNumOperands(); ++i) {
            if (tree.find(ins.getOperand(i)) == tree.end()) {
                tree.insert(std::pair<llvm::Value *, OpTreeNode *>(ins.getOperand(i),
                                                                   new OpTreeNode(ins.getOperand(i), &ins)));
            } else {
                auto node = tree.find(ins.getOperand(i))->second;
                while (node->preNode != nullptr) {
                    node = node->preNode;
                }
                node->preNode = new OpTreeNode(ins.getOperand(i), &ins);
            }
        }
    }
}

// 首先清掉全部的无效的Load
bool DeleteLoad(llvm::Function &F) {
    bool modified = false;
    for (auto &block: F.getBasicBlockList()) {
        std::map<llvm::Value *, llvm::Value *> value_map;
        for (auto ins = block.getInstList().begin();
             ins != block.getInstList().end();
             ++ins) {
            if (llvm::isa<llvm::StoreInst>(ins)) {
                auto LOP = ins->getOperand(1);
                auto ROP = ins->getOperand(0);
                value_map[LOP] = ROP;
            } else if (llvm::isa<llvm::LoadInst>(ins)) {
                auto tar = ins->getOperand(0);
                if (value_map.find(tar) != value_map.end()) {
                    ins->replaceAllUsesWith(value_map[tar]);
                    ins = ins->eraseFromParent();
                    modified = true;
                }
            }
        }
    }
    return modified;
}

// 下面删掉能在编译阶段能完成的运算
bool DeleteOp(llvm::Function &F, IR &ir) {
    bool modified = false;
    for (auto &block: F.getBasicBlockList()) {
        for (auto ins = block.getInstList().begin();
             ins != block.getInstList().end();
             ++ins) {
            if (!llvm::isa<llvm::StoreInst>(ins) &&
                !llvm::isa<llvm::LoadInst>(ins) &&
                !llvm::isa<llvm::AllocaInst>(ins) &&
                !llvm::isa<llvm::BranchInst>(ins) &&
                !llvm::isa<llvm::ReturnInst>(ins) &&
                ins->getNumOperands() == 2) {
                auto op1 = ins->getOperand(0);
                auto op2 = ins->getOperand(1);
                auto const_op1 = llvm::dyn_cast<llvm::ConstantInt>(op1);
                auto const_op2 = llvm::dyn_cast<llvm::ConstantInt>(op2);
                if (const_op1 && const_op2) {
                    modified = true;
                    int num1 = std::stoi(const_op1->getValue().toString(10, true));
                    int num2 = std::stoi(const_op2->getValue().toString(10, true));
                    int re;
                    llvm::Constant *const_re;
                    if (llvm::isa<llvm::AddOperator>(ins)) {
                        re = num1 + num2;
                        const_re = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()),
                                                          llvm::APInt(32, re));
                    } else if (llvm::isa<llvm::SubOperator>(ins)) {
                        re = num1 - num2;
                        const_re = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()),
                                                          llvm::APInt(32, re));
                    } else if (llvm::isa<llvm::MulOperator>(ins)) {
                        re = num1 * num2;
                        const_re = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()),
                                                          llvm::APInt(32, re));
                    } else if (llvm::isa<llvm::SDivOperator>(ins)) {
                        re = num1 / num2;
                        const_re = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()),
                                                          llvm::APInt(32, re));
                    } else if (auto comp = llvm::dyn_cast<llvm::CmpInst>(ins)){
                        bool comp_re = false;
                        auto pre = comp->getPredicate();
                        if (pre == llvm::CmpInst::ICMP_EQ) {
                            re = num1 == num2;
                        } else if (pre == llvm::CmpInst::ICMP_NE) {
                            re = num2 != num1;
                        } else if (pre == llvm::CmpInst::ICMP_SGE) {
                            re = num1 >= num2;
                        } else if (pre == llvm::CmpInst::ICMP_SGT) {
                            re = num1 > num2;
                        } else if (pre == llvm::CmpInst::ICMP_SLE) {
                            re = num1 <= num2;
                        } else if (pre == llvm::CmpInst::ICMP_SLT) {
                            re = num1 < num2;
                        }
                        const_re = llvm::ConstantInt::get(ir.module_->getContext(),
                                                          llvm::APInt(1, re));
                    } else {
                        return false;
                    }
                    ins->replaceAllUsesWith(const_re);
                    ins = ins->eraseFromParent();
                }
            }
        }
    }
    return modified;
}

void Passes::Constant(IR &ir) {
    bool begin = false;
    for (auto &F: ir.module_->getFunctionList()) {
        if (F.getName().str() == "_sysy_stoptime") {
            begin = true;
            continue;
        }
        if (begin) {
            while (DeleteLoad(F) || DeleteOp(F, ir)) {
                DeleteLoad(F);
                DeleteOp(F, ir);
            }
//            for (auto &block: F.getBasicBlockList()) {
//                std::map<llvm::Value *, OpTreeNode *> tree;
//                for (auto &ins: block.getInstList()) {
//                    for (auto u : ins.users()) {
//                        u->print(llvm::outs());
//                        llvm::outs() << '\n';
//                    }
//                    if (!llvm::dyn_cast<llvm::AllocaInst>(&ins) &&
//                        !llvm::dyn_cast<llvm::BranchInst>(&ins) &&
//                        !llvm::dyn_cast<llvm::ReturnInst>(&ins)) {
////                         无论是计算指令还是分配指令，其中的操作数都可以进行判断是否是常量
//                        for (int i = 0; i < ins.getNumOperands(); ++i) {
//                            isConstant(ins.getOperand(i), ir);
//                        }
//                    }
//                }
//            }
        }
    }
}

bool is2Times(int tar) {
    if (tar == 1) {
        return false;
    }
    while (tar != 1) {
        if (tar % 2 != 0) {
            return false;
        }
        tar = tar / 2;
    }
    return true;
}

void Passes::StrengthReduction(IR &ir) {
    bool begin = false;
    for (auto &F: ir.module_->getFunctionList()) {
        if (F.getName().str() == "_sysy_stoptime") {
            begin = true;
            continue;
        }
        if (begin) {
            for (auto &block: F.getBasicBlockList()) {
                for (auto ins = block.getInstList().begin();
                     ins != block.getInstList().end();
                     ++ins) {
                    if (llvm::isa<llvm::MulOperator>(ins)) {
                        auto op1 = ins->getOperand(0);
                        auto op2 = ins->getOperand(1);
                        auto const_1 = llvm::dyn_cast<llvm::ConstantInt>(op1);
                        auto const_2 = llvm::dyn_cast<llvm::ConstantInt>(op2);
                        if (const_1) {
                            int num = std::stoi(const_1->getValue().toString(10, true));
                            if (num == 0) {
                                llvm::Constant *constantInt = llvm::ConstantInt::get(ir.module_->getContext(),
                                                                                        llvm::APInt(32, 0));
                                ins->replaceAllUsesWith(constantInt);
                                ins = ins->eraseFromParent();
                                continue;
                            } else if (num == 1) {
                                ins->replaceAllUsesWith(op2);
                                ins = ins->eraseFromParent();
                                continue;
                            } else if (is2Times(num)) {
                                llvm::IRBuilder<> builder(ins->getParent());
                                builder.SetInsertPoint(&*ins);
                                auto new_ins = builder.CreateShl(op2, num / 2);
                                ins->replaceAllUsesWith(new_ins);
                                ins = ins->eraseFromParent();
                                continue;
                            }
                        } else if (const_2) {
                            int num = std::stoi(const_2->getValue().toString(10, true));
                            if (num == 0) {
                                llvm::Constant *constantInt = llvm::ConstantInt::get(ir.module_->getContext(),
                                                                                     llvm::APInt(32, 0));
                                ins->replaceAllUsesWith(constantInt);
                                ins = ins->eraseFromParent();
                                continue;
                            } else if (num == 1) {
                                ins->replaceAllUsesWith(op1);
                                ins = ins->eraseFromParent();
                                continue;
                            } else if (is2Times(num)) {
                                llvm::IRBuilder<> builder(ins->getParent());
                                builder.SetInsertPoint(&*ins);
                                auto new_ins = builder.CreateShl(op1, num / 2);
                                ins->replaceAllUsesWith(new_ins);
                                ins = ins->eraseFromParent();
                                continue;
                            }
                        }
                    } else if (llvm::isa<llvm::SDivOperator>(ins)) {
                        auto op = ins->getOperand(1);
                        if (auto constant = llvm::dyn_cast<llvm::ConstantInt>(op)) {
                            int num = std::stoi(constant->getValue().toString(10, true));
                            if (num == 1){
                                ins->replaceAllUsesWith(ins->getOperand(0));
                                ins = ins->eraseFromParent();
                            } else if (is2Times(num)) {
                                llvm::IRBuilder<> builder(ins->getParent());
                                builder.SetInsertPoint(&*ins);
                                auto new_ins = builder.CreateLShr(ins->getOperand(0), num / 2);
                                ins->replaceAllUsesWith(new_ins);
                                ins = ins->eraseFromParent();
                            }
                            continue;
                        }
                    }
                }
            }
        }
    }
//    Passes::Constant(ir);
}

void Passes::DEC(IR &ir) {
    bool begin = false;
    for (auto &F : ir.module_->getFunctionList()) {
        if (F.getName().str() == "_sysy_stoptime") {
            begin = true;
            continue;
        }
        if (begin) {
            for (auto &block : F.getBasicBlockList()) {
                for (auto &ins : block.getInstList()) {
                    auto condition = llvm::dyn_cast<llvm::BranchInst>(&ins);
                    if (condition && condition->isConditional()) {
                        if (auto constant = llvm::dyn_cast<llvm::ConstantInt>(condition->getCondition())) {
                            constant->print(llvm::outs());
                        }
                    }
                }
            }
        }
    }
}
