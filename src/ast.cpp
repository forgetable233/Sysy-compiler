//
// Created by dcr on 23-5-6.
//

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

    func_type_->Dump(tab_num + 1);
    std::cout << "," << std::endl;
    OutTab(tab_num + 1);
    std::cout << "FuncName: " << ident_ << std::endl;
//    OutTab(tab_num + 1);
//    std::cout << "Name: " << ident_ << std::endl;
    OutTab(tab_num + 1);
    std::cout << "}," << std::endl;
//    std::cout << ", FuncName: { " << ident_ << " }, ";
    block_->Dump(tab_num + 1);
    std::cout << std::endl;
    for (auto &item: this->param_lists_) {
        item->Dump(tab_num + 1);
        std::cout << std::endl;
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
    BasicBlock *current_block = ir.GetCurrentBlock();
    switch (type_) {
        case kDeclare: {
            if (!current_block) {
                var = new llvm::GlobalVariable(*ir.module_,
                                               int_type,
                                               false,
                                               llvm::GlobalVariable::ExternalLinkage,
                                               nullptr,
                                               this->ident_);
                var->setInitializer(llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0));
                ir.push_global_value(var, this->ident_);
                return var;
            } else {
                if (ir.get_value(this->ident_, current_block)) {
                    llvm::report_fatal_error("The param has been declared\n");
                }
                value = ir.builder_->CreateAlloca(int_type, nullptr, this->ident_);
                ir.push_value(value,
                              current_block->current_->getName().str(),
                              this->ident_);
                return value;
            }
        }
        case kDeclareAssign:
            if (!current_block) {
                var = new llvm::GlobalVariable(*ir.module_,
                                               int_type,
                                               false,
                                               llvm::GlobalVariable::ExternalLinkage,
                                               llvm::ConstantInt::get(int_type, this->array_size_),
                                               this->ident_);
                ir.push_global_value(var, this->ident_);
                break;
            } else {
                ir.get_value(this->ident_, current_block);
                value = ir.builder_->Insert(ir.builder_->CreateAlloca(int_type, nullptr, this->ident_));
                value->setName(this->ident_);
                ir.builder_->CreateStore(exp_->CodeGen(ir), value);
                ir.push_value(value, current_block->current_->getName().str(), this->ident_);
                return value;
            }
        case kDeclareArray: {
            if (!current_block) {
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
                ir.push_global_value(var, this->ident_);
                break;
            } else {
                if (this->array_size_ <= 0) {
                    llvm::report_fatal_error("The size of the array must be positive");
                }
                if (ir.get_value(this->ident_, current_block)) {
                    llvm::report_fatal_error("The param has been declared\n");
                }
                int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
                value = ir.builder_->CreateAlloca(llvm::ArrayType::get(int_type, this->array_size_),
                                                  nullptr,
                                                  this->ident_);
                ir.push_value(value,
                              current_block->current_->getName().str(),
                              this->ident_);
                break;
            }
        }
        case kExpression: {
            exp_->CodeGen(ir);
            break;
        }
        case kReturn: {
            return ir.builder_->CreateRet(exp_->CodeGen(ir));
        }
        case kIf: {
            // get condition code
            value = exp_->CodeGen(ir);
            // get true block
            auto true_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                       "true_block",
                                                       current_block->current_->getParent());
            auto merge_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                        "merge_block",
                                                        current_block->current_->getParent());

            auto _merge = new BasicBlock(current_block, merge_block);
            auto _true = new BasicBlock(current_block, true_block);

            if (false_block_) {
                // 存在false block的情况
                auto false_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                            "false_block",
                                                            current_block->current_->getParent());
                auto _false = new BasicBlock(current_block, false_block);
                llvm::BranchInst::Create(true_block, false_block, value, current_block->current_);

//                ir.builder_->CreateCondBr(value, true_block, false_block);
                // true block
                ir.SetCurrentBlock(_true);
                true_block_->CodeGen(ir);
                ir.builder_->CreateBr(merge_block);

                // false block
                ir.SetCurrentBlock(_false);
                false_block_->CodeGen(ir);
                ir.builder_->CreateBr(merge_block);
            } else {
                // 不存在false block的情况
                ir.builder_->CreateCondBr(value, true_block, nullptr);

                // true block
                ir.SetCurrentBlock(_true);
                true_block_->CodeGen(ir);
                ir.builder_->CreateBr(merge_block);
            }
            // 更改当前控制流
            ir.SetCurrentBlock(_merge);
            break;
            // 下面需要进行控制流的转换，需要在IR中进行更改，需要进行大改
            // TODO 完成控制流的更改
        }
        case kWhile: {
            /** 首先生成对应的loop_header **/
            auto loop_header = llvm::BasicBlock::Create(ir.module_->getContext(), "loop_header",
                                                        current_block->current_->getParent());
            auto loop_exit = llvm::BasicBlock::Create(ir.module_->getContext(), "loop_exit",
                                                      current_block->current_->getParent());
            auto loop_body = llvm::BasicBlock::Create(ir.module_->getContext(), "loop_body",
                                                      current_block->current_->getParent());

            auto header = new BasicBlock(current_block, loop_header);
            auto body = new BasicBlock(current_block, loop_body);
            auto exit = new BasicBlock(current_block, loop_exit);
            ir.continue_block_ = header;
            ir.break_block_ = current_block;

            BasicBlock *temp_continue = ir.continue_block_;
            BasicBlock *temp_break = ir.break_block_;

            // 首先进入header
            ir.builder_->CreateBr(loop_header);

            // loop_header
            ir.SetCurrentBlock(header);
            ir.builder_->CreateBr(current_block->current_);
            value = exp_->CodeGen(ir);
            ir.builder_->CreateCondBr(value, loop_body, loop_exit);

            // loop_body
            ir.SetCurrentBlock(body);
            block_->CodeGen(ir);
            ir.builder_->CreateBr(loop_header);

            // loop_exit
            ir.SetCurrentBlock(exit);

            ir.continue_block_ = temp_continue;
            ir.break_block_ = temp_break;

            break;
        }
        case kStatic: {
            var = new llvm::GlobalVariable(*ir.module_,
                                           int_type,
                                           false,
                                           llvm::GlobalVariable::ExternalLinkage,
                                           nullptr, this->ident_);
            return var;
        }
        case kBreak: {
            if (!ir.break_block_) {
                llvm::report_fatal_error("unable to ues break in this place");
            }
            ir.builder_->SetInsertPoint(current_block->current_);
            ir.builder_->CreateBr(ir.break_block_->current_);
            break;
        }
        case kContinue: {
            if (!ir.continue_block_) {
                llvm::report_fatal_error("unable to use continue in this place");
            }
            ir.builder_->SetInsertPoint(current_block->current_);
            ir.builder_->CreateBr(ir.continue_block_->current_);
            break;
        }
        default:
            llvm::report_fatal_error("Undefined statement");
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

void StmtAST::BuildAstTree() {
    if (exp_) {
        exp_->SetParent(this);
        exp_->BuildAstTree();
    }
    if (block_) {
        block_->SetParent(this);
        block_->BuildAstTree();
    }
    if (true_block_) {
        true_block_->SetParent(this);
        true_block_->BuildAstTree();
    }
    if (false_block_) {
        false_block_->SetParent(this);
        false_block_->BuildAstTree();
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
    auto current_block = ir.GetCurrentBlock();
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
        case kAtomIdent: {
            value = ir.get_value(this->ident_, current_block);
            if (!value) {
                llvm::outs() << current_block->current_->getName() << '\n';
                llvm::outs() << this->ident_ << '\n';
                llvm::report_fatal_error("unable to find the target variable");
            }
            if (BaseAST::is_array(value)) {
                llvm::report_fatal_error("The type of the param does not match, requires ident but input array");
            }
            llvm::Value *tar_value = value;
            if (!llvm::dyn_cast<llvm::PointerType>(tar_value->getType())) {
                llvm::PointerType *pointer_type =
                        llvm::PointerType::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
                tar_value = ir.builder_->CreateIntToPtr(tar_value, pointer_type);
            }
            return ir.builder_->CreateLoad(tar_value, this->ident_);
        }
        case kAtomArray: {
            auto offset = (ExprAST *) &(*array_offset_);
            llvm::Constant *const_0 = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
            llvm::Constant *const_i = nullptr;
            llvm::Value *idx[2];
            idx[0] = const_0;
            value = ir.get_value(this->ident_, current_block);
            if (!BaseAST::is_array(value)) {
                llvm::report_fatal_error("The type of the param does not match, requires array but input ident");
            }
            if (offset->type_ == kAtomNum) {
                if (offset->num_ < 0) {
                    llvm::report_fatal_error("The offset must be positive");
                }
                const_i = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()),
                                                 offset->num_);
                idx[1] = const_i;
            } else {
                idx[1] = offset->CodeGen(ir);
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
            value = ir.get_value(this->ident_, current_block);
            if (BaseAST::is_array(value)) {
                llvm::report_fatal_error("The type of the param does not match, requires ident but input array");
            }
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(ir);
            return ir.builder_->CreateStore(r_exp_value, value, "store");
        case kAssignArray: {
            auto offset = (ExprAST *) &(*array_offset_);
            llvm::Constant *const_0 = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
            llvm::Constant *const_i = nullptr;
            llvm::Value *idx[2];
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(ir);
            idx[0] = const_0;
            value = ir.get_value(this->ident_, current_block);
            if (!BaseAST::is_array(value)) {
                llvm::report_fatal_error("The type of the param does not match, requires array but input ident");
            }
            if (offset->type_ == kAtomNum) {
                if (offset->num_ < 0) {
                    llvm::report_fatal_error("The offset must be positive");
                }
                const_i = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()),
                                                 offset->num_);
                idx[1] = const_i;
            } else {
                idx[1] = offset->CodeGen(ir);
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
        case kFunction: {
            // TODO 函数调用添加参数数量检查，类型检查先没写
            llvm::Function *func = ir.module_->getFunction(this->ident_);
            if (!func) {
                llvm::report_fatal_error("unable to find the target function\n");
            }
            std::vector<llvm::Value *> temp_args;
            if (!get_params(current_block, func, ir, temp_args)) {
                llvm::report_fatal_error("param error\n");
            }
            llvm::ArrayRef<llvm::Value *> params(temp_args);
            return ir.builder_->CreateCall(func, params, "call");
        }
        case kNot: {
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(ir);
            return ir.builder_->CreateNot(r_exp_value, "not");
        }
        case kAt: {
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(ir);
            llvm::IntegerType *type = llvm::IntegerType::getInt32Ty(ir.module_->getContext());
            llvm::Value *ptr = ir.builder_->CreateIntToPtr(r_exp_value, type);
            return ptr;
        }
        case kParen: {
            return lExp_->CodeGen(ir);
        }
        default:
            l_exp_value = lExp_->CodeGen(ir);
            r_exp_value = rExp_->CodeGen(ir);
            switch (type_) {
                case kAdd:
                    return ir.builder_->CreateFAdd(l_exp_value, r_exp_value, "add");
                case kSub:
                    return ir.builder_->CreateFSub(l_exp_value, r_exp_value, "sub");
                case kMul:
                    return ir.builder_->CreateMul(l_exp_value, r_exp_value, "mul");
                case kDiv:
                    return ir.builder_->CreateFDiv(l_exp_value, r_exp_value, "div");
                case kEqual:
                    return ir.builder_->CreateICmpEQ(l_exp_value, r_exp_value, "equal");
                case kNotEqual:
                    return ir.builder_->CreateICmpNE(l_exp_value, r_exp_value, "not_equal");
                case kAnd:
                    return ir.builder_->CreateAnd(l_exp_value, r_exp_value, "and");
                case kOr:
                    return ir.builder_->CreateOr(l_exp_value, r_exp_value, "or");
                case kLarger:
                    return ir.builder_->CreateICmpSGT(l_exp_value, r_exp_value, "greater");
                case kLargerEqual:
                    return ir.builder_->CreateICmpSGE(l_exp_value, r_exp_value, "greater_equal");
                case kLess:
                    return ir.builder_->CreateICmpSLT(l_exp_value, r_exp_value, "less");
                case kLessEqual:
                    return ir.builder_->CreateICmpSLE(l_exp_value, r_exp_value, "less_equal");
                default: {
                    llvm::Value *op_result = nullptr;
                    switch (type_) {
                        case kAddAssign: {
                            op_result = ir.builder_->CreateAdd(l_exp_value, r_exp_value);
                            break;
                        }
                        case kSubAssign: {
                            op_result = ir.builder_->CreateSub(l_exp_value, r_exp_value);
                            break;
                        }
                        case kMulAssign: {
                            op_result = ir.builder_->CreateMul(l_exp_value, r_exp_value);
                            break;
                        }
                        case kDivAssign: {
                            op_result = ir.builder_->CreateUDiv(l_exp_value, r_exp_value);
                            break;
                        }
                        default:
                            llvm::report_fatal_error("undefined type");
                    }
                    if (!llvm::dyn_cast<llvm::PointerType>(l_exp_value->getType())) {
                        llvm::IntegerType *type = llvm::IntegerType::getInt32Ty(ir.module_->getContext());
                        llvm::PointerType *pointer_type = llvm::PointerType::get(type, 0);
                        l_exp_value = ir.builder_->CreateIntToPtr(l_exp_value, pointer_type);
                    }
                    return ir.builder_->CreateStore(op_result, l_exp_value, "store");
                }
            }
    }
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

void FuncTypeAST::BuildAstTree() {
    BaseAST::BuildAstTree();
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
    auto current_block = new BasicBlock(nullptr, entry);
    ir.push_global_value(func, this->ident_);
    ir.SetCurrentBlock(current_block);
    block_->CodeGen(ir);
    return func;
}

FuncDefAST::~FuncDefAST() {
    block_.reset(nullptr);
}

void FuncDefAST::BuildAstTree() {
    if (block_) {
        block_->SetParent(this);
        block_->BuildAstTree();
    }
    for (auto &param: param_lists_) {
        param->SetParent(this);
        param->BuildAstTree();
    }
}

llvm::Value *BlockAST::CodeGen(IR &ir) {
//    for (auto &it: this->stmt_) {
//        it->CodeGen(ir);
//    }
//    return BaseAST::CodeGen(ir);
    auto current_block = ir.GetCurrentBlock();
//    llvm::outs() << '\n';
//    for (auto it = llvm::pred_begin(entry_block); it != llvm::pred_end(entry_block); ++it) {
//        llvm::outs() << (*it)->getName() << '\n';
//    }
//    llvm::outs() << '\n';
    auto args = current_block->current_->getParent()->arg_begin();
    for (auto &item: this->stmt_) {
        item->CodeGen(ir);
    }
    return nullptr;
}

BlockAST::~BlockAST() {
    for (auto &item: stmt_) {
        item.reset(nullptr);
    }
}

void BlockAST::BuildAstTree() {
    for (auto &item: stmt_) {
        item->SetParent(this);
        item->BuildAstTree();
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
}

CompUnitAST::~CompUnitAST() {
    for (auto &item: func_stmt_defs_) {
        item.reset(nullptr);
    }
}

void CompUnitAST::BuildAstTree() {
    for (auto &func: func_stmt_defs_) {
        func->SetParent(this);
        func->BuildAstTree();
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

bool ExprAST::get_params(BasicBlock *entry_block,
                         llvm::Function *func,
                         IR &ir,
                         std::vector<llvm::Value *> &temp_args) {
    if (param_lists_.size() != func->arg_size()) {
        return false;
    }
    auto arg = func->arg_begin();
    int i = 0;
    for (auto &item: param_lists_) {
        auto param = (ExprAST *) &(*item);
        if (arg->getType()->isPointerTy()) {
            if (param->type_ == kAtomArray) {
                return false;
            }
            if (param->type_ == kAtomIdent) {
                llvm::Value *value = ir.get_value(this->ident_, entry_block);
                if (value->getType()->isPointerTy()) {
                    temp_args.push_back(value);
                } else {
                    return false;
                }
            } else {
                temp_args.push_back(param->CodeGen(ir));
            }
        } else {
            if (param->type_ == kAtomIdent) {
                llvm::Value *value = ir.get_value(this->ident_, entry_block);
                if (value->getType()->isPointerTy()) {
                    return false;
                }
                temp_args.push_back(value);
            } else {
                temp_args.push_back(param->CodeGen(ir));
            }
        }
        arg++;
    }
    return true;
}

void ExprAST::BuildAstTree() {
    if (array_offset_) {
        array_offset_->SetParent(this);
        array_offset_->BuildAstTree();
    }
    if (lExp_) {
        lExp_->SetParent(this);
        lExp_->BuildAstTree();
    }
    if (rExp_) {
        rExp_->SetParent(this);
        rExp_->BuildAstTree();
    }
    for (auto &item: param_lists_) {
        item->SetParent(this);
        item->BuildAstTree();
    }
}

llvm::Value *BaseAST::CodeGen(IR &ir) {
    return nullptr;
}

llvm::Value *BaseAST::ErrorValue(const char *str) {
    return nullptr;
}

bool BaseAST::is_array(llvm::Value *value) {
    if (value->getType()->isPointerTy()) {
        if (llvm::dyn_cast<llvm::ArrayType>(value->getType()->getPointerElementType())) {
            return true;
        } else {
            return false;
        }
    } else {
        if (llvm::dyn_cast<llvm::ArrayType>(value->getType())) {
            return true;
        } else {
            return false;
        }
    }
    return false;
}

BaseAST *BaseAST::GetParent() {
    return parent_;
}

void BaseAST::SetParent(BaseAST *tar) {
    parent_ = tar;
}

void BaseAST::BuildAstTree() {

}
