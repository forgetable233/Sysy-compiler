//
// Created by dcr on 23-5-6.
//

// TODO 支持函数调用
// TODO 实现数组，以及数组的调用
// TODO 编译过程中能够抛出错误
#include "ast.h"

void OutTab(int num) {
    for (int i = 0; i < num; ++i) {
        std::cout << "    ";
    }
}

void FuncTypeAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "FuncType: { " << std::endl;
    OutTab(tab_num + 1);
    std::cout << "Type: " << this->type_ << std::endl;
    OutTab(tab_num);
    std::cout << "}";
}

llvm::Value *FuncTypeAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

void FuncDefAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "FuncDefAST: { " << std::endl;

    if (type_ == kFunction) {
        func_type_->Dump(tab_num + 1);
        std::cout << "," << std::endl;
    }
    OutTab(tab_num + 1);
    std::cout << "FuncName: " << ident_ << std::endl;
//    OutTab(tab_num + 1);
//    std::cout << "Name: " << ident_ << std::endl;
    OutTab(tab_num + 1);
    std::cout << "}," << std::endl;
//    std::cout << ", FuncName: { " << ident_ << " }, ";
    if (type_ == kFunction) {
        block_->Dump(tab_num + 1);
        std::cout << std::endl;
        for (auto &item: this->param_lists_) {
            item->Dump(tab_num + 1);
            std::cout << std::endl;
        }
    }

    OutTab(tab_num);
    std::cout << "}";
}

llvm::Value *FuncDefAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

void BlockAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "BlockAST: { " << std::endl;
    for (long unsigned int i = 0; i < stmt_.size() - 1; ++i) {
        stmt_[i]->Dump(tab_num + 1);
        std::cout << "," << std::endl;
    }
    stmt_.back()->Dump(tab_num + 1);
    std::cout << std::endl;
    OutTab(tab_num);
    std::cout << "}";
}

llvm::Value *BlockAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

void CompUnitAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "ComUnitAST: { " << std::endl;
    for (auto &item: this->func_stmt_defs_) {
        item->Dump(tab_num + 1);
        std::cout << "}," << std::endl;
    }
//    func_def_->Dump(tab_num + 1);
//    std::cout << std::endl;
    OutTab(tab_num);
    std::cout << "}";
}

llvm::Value *CompUnitAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

void StmtAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "StmtAST: { " << std::endl;
    switch (type_) {
        case kDeclare:
            OutTab(tab_num + 1);
            std::cout << "Type: " << this->key_word_ << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Ident: " << this->ident_;
            break;
        case kDeclareArray:
            OutTab(tab_num + 1);
            std::cout << "Type: " << this->key_word_ << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Ident: " << this->ident_ << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Size: " << this->array_size_;
            break;
        case kExpression:
            OutTab(tab_num + 1);
            std::cout << "Type: " << this->key_word_ << ',' << std::endl;
            this->exp_->Dump(tab_num + 1);
            break;
        case kReturn:
            OutTab(tab_num + 1);
            std::cout << "Type: " << "Return" << ',' << std::endl;
            this->exp_->Dump(tab_num + 1);
            break;
        case kIf:
            OutTab(tab_num + 1);
            std::cout << "Type : " << "If" << "," << std::endl;
            OutTab(tab_num + 1);
            std::cout << "The Expression is :" << std::endl;
            this->exp_->Dump(tab_num + 1);
            std::cout << std::endl;
            OutTab(tab_num + 1);
            std::cout << std::endl << "The true_block is :" << std::endl;
            this->true_block_->Dump(tab_num + 1);

            if (this->false_block_) {
                OutTab(tab_num + 1);
                std::cout << std::endl << "The false_block is :" << std::endl;
                this->false_block_->Dump(tab_num + 1);
            }
            break;
        case kWhile:
            OutTab(tab_num + 1);
            std::cout << "Type : " << "While" << "," << std::endl;
            OutTab(tab_num + 1);
            std::cout << "The Expression is :" << std::endl;
            this->exp_->Dump(tab_num + 1);
            std::cout << std::endl;
            OutTab(tab_num + 1);
            std::cout << std::endl << "The Block is :" << std::endl;
            this->block_->Dump(tab_num + 1);
            break;
        case kDeclareAssign:
            OutTab(tab_num + 1);
            std::cout << "Type: " << this->key_word_ << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Ident: " << this->ident_;
            OutTab(tab_num + 1);
            std::cout << "The initial number is " << this->array_size_ << std::endl;
            break;
        default:
            llvm::report_fatal_error("Undefined type in Stmt Dump");
    }
    std::cout << std::endl;
    OutTab(tab_num);
    std::cout << "} ";
}

llvm::Value *StmtAST::CodeGen(IR &ir) {
    llvm::Value *value;
    llvm::IntegerType *int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
    llvm::GlobalVariable *var;
    llvm::Value *tamp_value = ir.get_global_value(this->ident_);
    std::vector<llvm::Constant *> const_array_elems;
    if (tamp_value) {
        llvm::report_fatal_error("The variable has been declared in global declare");
    }
    switch (type_) {
        case kDeclare:
            var = new llvm::GlobalVariable(*ir.module_,
                                           int_type,
                                           false,
                                           llvm::GlobalVariable::ExternalLinkage,
                                           nullptr,
                                           this->ident_);
            var->setInitializer(llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0));
            ir.push_global_value(var, this->ident_);
            return var;
        case kDeclareAssign:
            var = new llvm::GlobalVariable(*ir.module_,
                                           int_type,
                                           false,
                                           llvm::GlobalVariable::ExternalLinkage,
                                           llvm::ConstantInt::get(int_type, this->array_size_),
                                           this->ident_);
            ir.push_global_value(var, this->ident_);
            break;
        case kDeclareArray: {
            if (this->array_size_ <= 0) {
                llvm::report_fatal_error("The size of the value must be positive");
            }
            var = new llvm::GlobalVariable(*ir.module_,
                                           llvm::ArrayType::get(int_type, this->array_size_),
                                           true,
                                           llvm::GlobalVariable::ExternalLinkage,
                                           nullptr,
                                           this->ident_);
            const_array_elems.resize(this->array_size_);
            for (int i = 0; i < this->array_size_; ++i) {
                const_array_elems[i] = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
            }
            var->setInitializer(
                    llvm::ConstantArray::get(llvm::ArrayType::get(llvm::Type::getInt32Ty(ir.module_->getContext()),
                                                                  this->array_size_),
                                             const_array_elems));
            var->setAlignment(4 * this->array_size_);
            ir.push_global_value(var, this->ident_);
            break;
        }
        default:
            llvm::report_fatal_error("Undefined statement");
    }
}

llvm::Value *StmtAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
    ir.builder_->SetInsertPoint(entry_block);
    llvm::Type *int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
    llvm::Value *value;
    llvm::BasicBlock *true_block = nullptr;
    llvm::BasicBlock *false_block = nullptr;
    llvm::BasicBlock *merge_block = nullptr;

    llvm::BasicBlock *loop_header = nullptr;
    llvm::BasicBlock *loop_body = nullptr;
    llvm::BasicBlock *loop_exit = nullptr;

    llvm::GlobalVariable *var;
    auto exp = (ExprAST *) (&(*this->exp_));
    switch (type_) {
        case kDeclare:
            ir.get_value(this->ident_, entry_block, kAtom, nullptr);
            value = ir.builder_->CreateAlloca(int_type, nullptr, this->ident_);
            ir.push_value(value,
                          entry_block->getName().str(),
                          this->ident_);
            return value;
        case kDeclareArray:
            if (this->array_size_ <= 0) {
                llvm::report_fatal_error("The size of the array must be positive");
            }
            ir.get_value(this->ident_, entry_block, kArray, nullptr);
            int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
            value = ir.builder_->CreateAlloca(llvm::ArrayType::get(int_type, this->array_size_),
                                              nullptr,
                                              this->ident_);
            ir.push_value(value,
                          entry_block->getName().str(),
                          this->ident_);
            break;
        case kExpression:
            exp->CodeGen(entry_block, ir);
            break;
        case kReturn:
            return ir.builder_->CreateRet(exp->CodeGen(entry_block, ir));
        case kIf:
            value = ((ExprAST *) &(*this->exp_))->CodeGen(entry_block, ir);
            true_block = llvm::BasicBlock::Create(ir.module_->getContext(), "true_block", entry_block->getParent());
            merge_block = llvm::BasicBlock::Create(ir.module_->getContext(), "merge_block", entry_block->getParent());
            if (false_block_) {
                false_block = llvm::BasicBlock::Create(ir.module_->getContext(), "false_block",
                                                       entry_block->getParent());
            }
            llvm::BranchInst::Create(true_block, false_block, value, entry_block);
            ((BlockAST *) &(*this->true_block_))->CodeGen(true_block, ir);
            ir.builder_->SetInsertPoint(true_block);
            llvm::BranchInst::Create(merge_block, true_block);
            if (false_block_) {
                ((BlockAST *) &(*this->false_block_))->CodeGen(false_block, ir);
                ir.builder_->SetInsertPoint(false_block);
                llvm::BranchInst::Create(merge_block, false_block);
            }
            ir.builder_->SetInsertPoint(merge_block);
            break;
        case kWhile:
            /** 首先生成对应的loop_header **/
            loop_header = llvm::BasicBlock::Create(ir.module_->getContext(), "loop_header", entry_block->getParent());
            loop_body = llvm::BasicBlock::Create(ir.module_->getContext(), "loop_body", entry_block->getParent());
            loop_exit = llvm::BasicBlock::Create(ir.module_->getContext(), "loop_exit", entry_block->getParent());
            llvm::BranchInst::Create(loop_header, entry_block);

            // loop_header
            ir.builder_->SetInsertPoint(loop_header);
            value = ((ExprAST *) &(*this->exp_))->CodeGen(entry_block, ir);
            llvm::BranchInst::Create(loop_body, loop_exit, value, loop_header);
            // loop_body
            ((BlockAST *) &(*this->block_))->CodeGen(loop_body, ir);
            ir.builder_->SetInsertPoint(loop_body);
            llvm::BranchInst::Create(loop_header, loop_body);

            // loop_exit
            ir.builder_->SetInsertPoint(loop_exit);
            llvm::BranchInst::Create(entry_block, loop_exit);
            break;
        case kStatic:
            var = new llvm::GlobalVariable(*ir.module_,
                                           int_type,
                                           false,
                                           llvm::GlobalVariable::ExternalLinkage,
                                           nullptr, this->ident_);
            return var;
        case kDeclareAssign:
            ir.get_value(this->ident_, entry_block, kArray, nullptr);
            value = ir.builder_->Insert(ir.builder_->CreateAlloca(int_type, nullptr, this->ident_));
            value->setName(this->ident_);
            ir.builder_->CreateStore(exp->CodeGen(entry_block, ir), value);
            ir.push_value(value, entry_block->getName().str(), this->ident_);
            return value;
        default:
            llvm::report_fatal_error("Undefined type in stmt CodeGen");
    }
    return nullptr;
}

llvm::Value *StmtAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

StmtAST::~StmtAST() {
    if (!exp_) {
        exp_.reset(nullptr);
    }
    if (!block_) {
        block_.reset(nullptr);
    }
}

void ExprAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "ExprAST: {" << std::endl;
    switch (type_) {
        case kAtomIdent:
            OutTab(tab_num + 1);
            std::cout << "Ident: " << ident_;
            break;
        case kAtomNum:
            OutTab(tab_num + 1);
            std::cout << "Num: " << num_;
            break;
        case kAdd:
            lExp_->Dump(tab_num + 1);
            std::cout << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Operator: " << "+ ," << std::endl;
            rExp_->Dump(tab_num + 1);
            break;
        case kSub:
            lExp_->Dump(tab_num + 1);
            std::cout << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Operator: " << "- ," << std::endl;
            rExp_->Dump(tab_num + 1);
            break;
        case kMul:
            lExp_->Dump(tab_num + 1);
            std::cout << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Operator: " << "* ," << std::endl;
            rExp_->Dump(tab_num + 1);
            break;
        case kDiv:
            lExp_->Dump(tab_num + 1);
            std::cout << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Operator: " << "/ ," << std::endl;
            rExp_->Dump(tab_num + 1);
            break;
        case kAssign:
            OutTab(tab_num + 1);
            std::cout << "Ident: " << ident_ << ',' << std::endl;
            OutTab(tab_num + 1);
            std::cout << "Operator: " << "= ," << std::endl;
            rExp_->Dump(tab_num + 1);
    }

    std::cout << std::endl;
    OutTab(tab_num);
    std::cout << "}";
}

llvm::Value *ExprAST::CodeGen(IR &ir) {
    return nullptr;
}

llvm::Value *ExprAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

llvm::Value *FuncTypeAST::CodeGen(IR &ir) {
    return nullptr;
}

FuncTypeAST::~FuncTypeAST() {

}

/**
 * 函数声明的AST
 * 目前只有INT类型的函数，没有进一步细化
 * 留下了接口以后进行更新
 * @param module
 * @return
 */
llvm::Value *FuncDefAST::CodeGen(IR &ir) {
    unsigned long int param_size = param_lists_.size();
    std::vector<llvm::Type *> param_types;
    for (int i = 0; i < param_size; ++i) {
        StmtAST *stmt_ast_i = ((StmtAST *) &(*param_lists_[i]));
        for (int j = i + 1; j < param_size; ++j) {
            StmtAST *stmt_ast_j = ((StmtAST *) &(*param_lists_[j]));
            if (std::strcmp(stmt_ast_i->ident_.c_str(), stmt_ast_j->ident_.c_str()) == 0) {
                llvm::report_fatal_error("The variable has been declared in function params");
            }
        }
    }
    param_types.reserve(param_size);
    for (int i = 0; i < param_size; ++i) {
        StmtAST *ast = ((StmtAST *) &(*this->param_lists_[i]));
        if (ast->type_ == kDeclare) {
            param_types.emplace_back(ir.builder_->getInt32Ty());
        } else if (ast->type_ == kDeclareArray) {
            if (ast->array_size_ <= 0) {
                llvm::report_fatal_error("The size of the array must be positive\n");
            }
            llvm::IntegerType *int_type = ir.builder_->getInt32Ty();
            llvm::ArrayType *array_type = llvm::ArrayType::get(int_type, ast->array_size_);
            param_types.emplace_back(array_type->getPointerTo(0));
        } else {
            llvm::report_fatal_error("Undefined type\n");
        }
    }
    if (ir.get_global_value(this->ident_)) {
        llvm::report_fatal_error("The function has been used in functions or params");
    }
    llvm::IntegerType *return_type = llvm::IntegerType::get(ir.module_->getContext(), 32);
    llvm::FunctionType *func_type = llvm::FunctionType::get(return_type, param_types, false);
    llvm::Function *func = llvm::Function::Create(func_type,
                                                  llvm::GlobalValue::ExternalLinkage,
                                                  this->ident_,
                                                  *ir.module_);
    int i = 0;
    StmtAST *stmt_ast;
    for (auto arg = func->arg_begin(); arg != func->arg_end(); arg++) {
        stmt_ast = ((StmtAST *) &(*param_lists_[i++]));
        arg->setName(stmt_ast->ident_);
    }
    llvm::BasicBlock *entry = llvm::BasicBlock::Create(ir.module_->getContext(), "begin", func);
    ir.push_global_value(func, this->ident_);
    auto tar_block = (BlockAST *) (&(*block_));
    ir.builder_->SetInsertPoint(entry);
    tar_block->CodeGen(entry, ir);
    return func;
}

FuncDefAST::~FuncDefAST() {
    block_.reset(nullptr);
}

llvm::Value *BlockAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
    ir.builder_->SetInsertPoint(entry_block);
    auto args = entry_block->getParent()->arg_begin();
//    for (int i = 0; i < entry_block->getParent()->arg_size(); ++i, ++args) {
//        llvm::AllocaInst *alloc = nullptr;
//        if (args->getType()->isIntegerTy()) {
//            alloc = ir.builder_->CreateAlloca(args->getType(), nullptr);
//        } else {
//            llvm::IntegerType *int_type = llvm::IntegerType::get(ir.module_->getContext(), 32);
//            alloc = ir.builder_->CreateAlloca(llvm::PointerType::get(int_type, 0));
//        }
//        ir.push_value(alloc, entry_block->getName().str(), std::to_string(i));
//        ir.builder_->CreateStore(args, alloc);
//    }
    for (auto &item: this->stmt_) {
        ((StmtAST *) (&(*item)))->CodeGen(entry_block, ir);
    }
    return nullptr;
}

llvm::Value *BlockAST::CodeGen(IR &ir) {
    for (auto &it: this->stmt_) {
        it->CodeGen(ir);
    }
    return BaseAST::CodeGen(ir);
}

BlockAST::~BlockAST() {
    for (auto &item: stmt_) {
        item.reset(nullptr);
    }
}

/**
 * 一个编译模块的代码生成
 * 以后可以增加函数的数量，目前只添加了一个
 * @param ir
 * @return
 */
llvm::Value *CompUnitAST::CodeGen(IR &ir) {
    for (auto &item: this->func_stmt_defs_) {
        item->CodeGen(ir);
    }
    return nullptr;
//    auto temp_func = (FuncDefAST *) (&(*func_def_));
//    return temp_func->CodeGen(ir);
//    return BaseAST::CodeGen(builder, module);
}

CompUnitAST::~CompUnitAST() {
    for (auto &item: func_stmt_defs_) {
        item.reset(nullptr);
    }
}

llvm::Value *ExprAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
    ir.builder_->SetInsertPoint(entry_block);
    llvm::LLVMContext &context = *ir.context_;
    llvm::Value *value;
    ExprAST *l_exp;
    ExprAST *r_exp;
    llvm::Value *l_exp_value;
    llvm::Value *r_exp_value;
    int array_size = 0;
    switch (type_) {
        case kAtomNum:
            return llvm::ConstantInt::get(context, llvm::APInt(32, num_));
        case kAtomIdent:
            // TODO 这里不确定使用函数中的数据时是否会报错
            value = ir.get_value_check_type(this->ident_, entry_block, kAtom, nullptr);
            return ir.builder_->CreateLoad(value, this->ident_);
        case kAtomArray: {
            // TODO 处理函数偏移量为变量的情况
            auto offset = (ExprAST *) &(*array_offset_);
            llvm::Constant *const_0 = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
            llvm::Constant *const_i = nullptr;
            llvm::Value *idx[2];
            idx[0] = const_0;
            value = ir.get_value_check_type(this->ident_, entry_block, kArray, &array_size);
            if (offset->type_ == kAtomNum) {
                if (offset->num_ < 0) {
                    llvm::report_fatal_error("The offset must be positive");
                }
//                if (offset->num_ >= array_size) {
//                    llvm::report_fatal_error("Out of range!!!" + this->ident_);
//                }
                const_i = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()),
                                                 offset->num_);
                idx[1] = const_i;
            } else {
                idx[1] = offset->CodeGen(entry_block, ir);
            }
            auto *global_value = llvm::dyn_cast<llvm::GlobalVariable>(value);
            if (!global_value) {
                if (llvm::isa<llvm::PointerType>(value->getType())) {
                    llvm::Value *array_i = ir.builder_->CreateGEP(value->getType()->getPointerElementType(), value,
                                                                  idx);
                    return ir.builder_->CreateLoad(array_i);
                } else {
                    llvm::Value *array_i = ir.builder_->CreateGEP(value->getType(), value,
                                                                  idx);
                    return ir.builder_->CreateLoad(array_i);
                }
            } else {
                llvm::Value *global_i = ir.builder_->CreateGEP(global_value->getType()->getPointerElementType(),
                                                               global_value, idx);
                return ir.builder_->CreateLoad(global_i);
            }
        }
        case kAssign:
            value = ir.get_value_check_type(this->ident_, entry_block, kAtom, nullptr);
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(entry_block, ir);
            return ir.builder_->CreateStore(r_exp_value, value, "store");
        case kAssignArray: {
            auto offset = (ExprAST *) &(*array_offset_);
            llvm::Constant *const_0 = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
            llvm::Constant *const_i = nullptr;
            llvm::Value *idx[2];
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(entry_block, ir);
            idx[0] = const_0;
            value = ir.get_value_check_type(this->ident_, entry_block, kArray, &array_size);
            if (offset->type_ == kAtomNum) {
                if (offset->num_ < 0) {
                    llvm::report_fatal_error("The offset must be positive");
                }
                const_i = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()),
                                                 offset->num_);
                idx[1] = const_i;
            } else {
                idx[1] = offset->CodeGen(entry_block, ir);
            }
            auto *global_value = llvm::dyn_cast<llvm::GlobalVariable>(value);
            if (!global_value) {
                llvm::Value *array_i;
                array_i = ir.builder_->CreateGEP(value, idx);
                return ir.builder_->CreateStore(r_exp_value, array_i, "store");
            } else {
                llvm::Value *global_i = ir.builder_->CreateGEP(global_value, idx);
                return ir.builder_->CreateStore(r_exp_value, global_i, "store");
            }
        }
        default:
            l_exp = (ExprAST *) (&(*lExp_));
            r_exp = (ExprAST *) (&(*rExp_));
            l_exp_value = l_exp->CodeGen(entry_block, ir);
            r_exp_value = r_exp->CodeGen(entry_block, ir);
            switch (type_) {
                case kAdd:
                    return ir.builder_->CreateFAdd(l_exp_value, r_exp_value, "add");
                case kSub:
                    return ir.builder_->CreateFSub(l_exp_value, r_exp_value, "sub");
                case kMul:
                    return ir.builder_->CreateFMul(l_exp_value, r_exp_value, "mul");
                case kDiv:
                    return ir.builder_->CreateFDiv(l_exp_value, r_exp_value, "div");
                default:
                    llvm::report_fatal_error("invalid binary operator");
            }
    }
}

ExprAST::~ExprAST() {
    if (!lExp_) {
        lExp_.reset(nullptr);
    }
    if (!rExp_) {
        rExp_.reset(nullptr);
    }
}

llvm::Value *BaseAST::CodeGen(IR &ir) {

    return nullptr;
}

llvm::Value *BaseAST::ErrorValue(const char *str) {
    return nullptr;
}
