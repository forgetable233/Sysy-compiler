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
    std::vector<llvm::Constant *> const_array_elems;
    BasicBlock *current_block = ir.GetCurrentBlock();
    std::string block_name;
    switch (type_) {
        case kDeclare: {
            if (!current_block) {
                var = new llvm::GlobalVariable(*ir.module_,
                                               int_type,
                                               false,
                                               llvm::GlobalVariable::ExternalLinkage,
                                               llvm::ConstantInt::get(
                                                       llvm::IntegerType::getInt32Ty(ir.module_->getContext()), 32),
                                               this->ident_);
                var->setInitializer(llvm::ConstantInt::get(llvm::Type::getInt32Ty(ir.module_->getContext()), 0));
                ir.push_global_value(var, this->ident_);
                return var;
            } else {
                block_name = current_block->current_->getParent()->getName().str();
                block_name += current_block->current_->getName().str();
                value = ir.builder_->CreateAlloca(int_type);
                ir.push_value(value,
                              block_name,
                              this->ident_);
                return value;
            }
        }
        case kDeclareAssign:
            if (!current_block) {
                auto assign = (ExprAST *) &(*this->assign_list_.back());
                var = new llvm::GlobalVariable(*ir.module_,
                                               int_type,
                                               false,
                                               llvm::GlobalVariable::ExternalLinkage,
                                               llvm::dyn_cast<llvm::Constant>(assign->CodeGen(ir)),
                                               this->ident_);
                ir.push_global_value(var, this->ident_);
                break;
            } else {
                ir.get_value(this->ident_, current_block);
                value = ir.builder_->CreateAlloca(int_type);
                auto &assign = assign_list_.back();
                ir.builder_->CreateStore(assign->CodeGen(ir), value);
                block_name = current_block->current_->getParent()->getName().str();
                block_name += current_block->current_->getName().str();
                ir.push_value(value, block_name, this->ident_);
                return value;
            }
        case kDeclareArray: {
            if (!current_block) {
                int size = 0;
                if (this->array_size_ <= 0) {
                    llvm::report_fatal_error("The size of the value must be positive");
                }
                if (this->array_size2_ > 0) {
                    if (this->array_size2_ < 0) {
                        llvm::report_fatal_error("The size of the value must be positive");
                    }
                    var = new llvm::GlobalVariable(*ir.module_,
                                                   llvm::ArrayType::get(
                                                           llvm::ArrayType::get(int_type, this->array_size2_),
                                                           this->array_size_),
                                                   false,
                                                   llvm::GlobalVariable::ExternalLinkage,
                                                   nullptr,
                                                   this->ident_);
                    size = this->array_size_ * this->array_size2_;
                } else {
                    var = new llvm::GlobalVariable(*ir.module_,
                                                   llvm::ArrayType::get(int_type, this->array_size_),
                                                   false,
                                                   llvm::GlobalVariable::ExternalLinkage,
                                                   nullptr,
                                                   this->ident_);
                    size = this->array_size_;
                }
                const_array_elems.resize(size);
                for (int i = 0; i < size; ++i) {
                    const_array_elems[i] = llvm::ConstantInt::get(
                            llvm::Type::getInt32Ty(ir.module_->getContext()), 0);
                }
                var->setInitializer(
                        llvm::ConstantArray::get(
                                llvm::ArrayType::get(llvm::Type::getInt32Ty(ir.module_->getContext()),
                                                     this->array_size_),
                                const_array_elems));
//                var->getType()->print(llvm::outs(), true);
                ir.push_global_value(var, this->ident_);
                break;
            } else {
                if (this->array_size_ <= 0 || this->array_size2_ < 0) {
                    llvm::report_fatal_error("The size of the array must be positive");
                }
                int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
                if (this->array_size2_ > 0) {
                    value = ir.builder_->CreateAlloca(
                            llvm::ArrayType::get(llvm::ArrayType::get(int_type, this->array_size2_),
                                                 this->array_size_),
                            nullptr);
                } else {
                    value = ir.builder_->CreateAlloca(llvm::ArrayType::get(int_type, this->array_size_),
                                                      nullptr);
                }
                block_name = current_block->current_->getParent()->getName().str();
                block_name += current_block->current_->getName().str();
                ir.push_value(value,
                              block_name,
                              this->ident_);
                break;
            }
        }
        case kDeclareArrayAssign: {
            if (!current_block) {
                if (this->array_size2_ != 0) {
                    // 2-dim
                    int size;
                    if (array_size_ == 0) {
                        size = ceil((double) assign_list_.size() / array_size2_);
                    } else {
                        size = array_size_;
                    }
                    ResetAssignSize(size * array_size2_);
                    std::vector<llvm::Constant *> list;
                    for (int i = (int) assign_list_.size() - size * array_size2_; i < assign_list_.size(); ++i) {
                        list.emplace_back(llvm::dyn_cast<llvm::Constant>(assign_list_[i]->CodeGen(ir)));
                    }
                    var = new llvm::GlobalVariable(*ir.module_,
                                                   llvm::ArrayType::get(llvm::ArrayType::get(int_type, array_size2_),
                                                                        size),
                                                   false,
                                                   llvm::GlobalVariable::ExternalLinkage,
                                                   nullptr,
                                                   ident_);
                    llvm::Constant *array = llvm::ConstantArray::get(
                            llvm::ArrayType::get(llvm::ArrayType::get(int_type, array_size2_), size), list);
                    var->setInitializer(array);
                } else {
                    // 1-dim
                    int size;
                    if (array_size_ == 0) {
                        size = (int) assign_list_.size();
                    } else {
                        size = array_size_;
                    }
                    ResetAssignSize(size);
                    std::vector<llvm::Constant *> list;
                    for (int i = (int) assign_list_.size() - size; i < assign_list_.size(); ++i) {
                        list.emplace_back(llvm::dyn_cast<llvm::Constant>(assign_list_[i]->CodeGen(ir)));
                    }
                    var = new llvm::GlobalVariable(*ir.module_,
                                                   llvm::ArrayType::get(int_type, size),
                                                   false,
                                                   llvm::GlobalVariable::ExternalLinkage,
                                                   nullptr,
                                                   ident_);
                    var->setInitializer(llvm::ConstantArray::get(llvm::ArrayType::get(int_type, size), list));
                }
                ir.push_global_value(var, ident_);
            } else {
                if (this->array_size2_ != 0) {
                    // 2-dim array
                    int size;
                    if (array_size_ == 0) {
                        size = ceil(static_cast<double>(assign_list_.size()) / array_size2_);
                    } else {
                        size = array_size_;
                    }
                    ResetAssignSize(size * array_size2_);
                    int begin = (int) assign_list_.size() - size * array_size2_;
                    value = ir.builder_->CreateAlloca(
                            llvm::ArrayType::get(llvm::ArrayType::get(int_type, size), array_size2_),
                            nullptr);
                    for (int i = 0; i < size; ++i) {
                        auto pointer_1 = BaseAST::GetOffsetPointer(value, i, ir);
                        for (int j = 0; j < array_size2_; ++j) {
                            auto pointer_2 = BaseAST::GetOffsetPointer(pointer_1, j, ir);
                            auto assign_value = assign_list_[begin++]->CodeGen(ir);
                            ir.builder_->CreateStore(assign_value, pointer_2);
                        }
                    }
                } else {
                    // 1-dim array
                    int size;
                    if (array_size_ != 0) {
                        size = array_size_;
                    } else {
                        size = (int) assign_list_.size();
                    }
                    ResetAssignSize(size);
                    int begin = (int) assign_list_.size() - size;
                    value = ir.builder_->CreateAlloca(llvm::ArrayType::get(int_type, size), nullptr);
                    for (int i = 0; i < size; ++i) {
                        auto pointer = BaseAST::GetOffsetPointer(value, i, ir);
                        auto assign_value = assign_list_[begin++]->CodeGen(ir);
                        ir.builder_->CreateStore(assign_value, pointer);
                    }
                }
                block_name = current_block->current_->getParent()->getName().str();
                block_name += current_block->current_->getName().str();
                ir.push_value(value, block_name, value->getName().str());
            }
            break;
        }
        case kExpression: {
            exp_->CodeGen(ir);
            break;
        }
        case kReturn: {
            if (!exp_) {
                break;
            } else {
                llvm::Value *returnValue = exp_->CodeGen(ir);
                value = ir.get_value("1", current_block);
                ir.builder_->CreateStore(returnValue, value);
                ir.builder_->CreateBr(ir.return_block_->current_);
                break;
            }
        }
        case kIf: {
            // get condition code
            value = exp_->CodeGen(ir);
            if (value->getType()->isIntegerTy() && value->getType()->getIntegerBitWidth() == 32) {
                llvm::Value *zero = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()), 0);
                value = ir.builder_->CreateICmpSGT(value, zero);
                value = ir.builder_->CreateZExtOrTrunc(value, llvm::Type::getInt1Ty(ir.module_->getContext()));
            }
            // get true block
            auto true_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                       "",
                                                       current_block->current_->getParent());


            auto _true = new BasicBlock(current_block, true_block);

            if (false_block_) {
                // 存在false block的情况
                auto false_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                            "",
                                                            current_block->current_->getParent());
                auto merge_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                            "",
                                                            current_block->current_->getParent());

                auto _false = new BasicBlock(current_block, false_block);
                auto _merge = new BasicBlock(current_block, merge_block);

                llvm::BranchInst::Create(true_block, false_block, value, current_block->current_);
                auto current_exit = ir.exit_block_;
                ir.exit_block_ = _merge;
                // true block
                ir.SetCurrentBlock(_true);
                true_block_->CodeGen(ir);

                // false block
                ir.SetCurrentBlock(_false);
                false_block_->CodeGen(ir);

                if (!llvm::predecessors(_merge->current_).empty()) {
                    ir.SetCurrentBlock(_merge);
                } else {
                    _merge->current_->eraseFromParent();
                    ir.SetCurrentBlock(current_exit);
                }
                ir.exit_block_ = current_exit;
                break;
            } else {
                auto merge_block = llvm::BasicBlock::Create(ir.module_->getContext(),
                                                            "",
                                                            current_block->current_->getParent());
                auto _merge = new BasicBlock(current_block, merge_block);

                // 不存在false block的情况
                ir.builder_->CreateCondBr(value, true_block, merge_block);
                auto current_exit = ir.exit_block_;
                ir.exit_block_ = _merge;

                // true block
                ir.SetCurrentBlock(_true);
                true_block_->CodeGen(ir);

                if (!llvm::predecessors(_merge->current_).empty()) {
                    ir.SetCurrentBlock(_merge);
                } else {
                    _merge->current_->eraseFromParent();
                    ir.SetCurrentBlock(current_exit);
                }
                break;
            }
            // 更改当前控制流
        }
        case kWhile: {
            /** 首先生成对应的loop_header **/
            auto loop_header = llvm::BasicBlock::Create(ir.module_->getContext(), "",
                                                        current_block->current_->getParent());
            auto loop_exit = llvm::BasicBlock::Create(ir.module_->getContext(), "",
                                                                   current_block->current_->getParent());
            auto loop_body = llvm::BasicBlock::Create(ir.module_->getContext(), "",
                                                      current_block->current_->getParent());


            auto header = new BasicBlock(current_block, loop_header);
            auto body = new BasicBlock(current_block, loop_body);
            auto exit = new BasicBlock(current_block, loop_exit);
            auto current_continue = ir.continue_block_;
            auto current_break = ir.break_block_;
            auto current_exit = ir.exit_block_;
            ir.continue_block_ = header;
            ir.break_block_ = exit;
            ir.exit_block_ = header;

            // 首先进入header
            ir.builder_->CreateBr(loop_header);

            // loop_header
            ir.SetCurrentBlock(header);
            value = exp_->CodeGen(ir);
            if (value->getType()->isIntegerTy() && value->getType()->getIntegerBitWidth() == 32) {
                llvm::Value *zero = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()), 0);
                value = ir.builder_->CreateICmpSGT(value, zero);
                value = ir.builder_->CreateZExtOrTrunc(value, llvm::Type::getInt1Ty(ir.module_->getContext()));
            }
            ir.builder_->CreateCondBr(value, loop_body, loop_exit);

            // loop_body
            ir.SetCurrentBlock(body);
            block_->CodeGen(ir);

            // loop_exit
            ir.SetCurrentBlock(exit);

            ir.continue_block_ = current_continue;
            ir.break_block_ = current_break;
            ir.exit_block_ = current_exit;
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
            ir.builder_->CreateBr(ir.break_block_->current_);
            break;
        }
        case kContinue: {
            if (!ir.continue_block_) {
                llvm::report_fatal_error("unable to use continue in this place");
            }
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

void StmtAST::ResetAssignSize(int size) {
    if (size > assign_list_.size()) {
        int dis = (size) - (int) assign_list_.size();
        for (int i = 0; i < dis; ++i) {
            auto temp_assign = new ExprAST();
            temp_assign->type_ = kAtomNum;
            temp_assign->num_ = 0;
            assign_list_.emplace_back(std::unique_ptr<BaseAST>(temp_assign));
        }
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
            if (value->getType()->isPointerTy() && value->getType()->getPointerElementType()->isArrayTy()) {
                auto temp_value = BaseAST::GetOffsetPointer(value, 0, ir);
                return temp_value;
            }
            return ir.builder_->CreateLoad(value);
        }
        case kNegative: {
            return ir.builder_->CreateNeg(rExp_->CodeGen(ir));
        }
        case kAtomArray: {
            auto offset = &(*array_offset_);
            value = ir.get_value(this->ident_, current_block);
            if (!BaseAST::is_array(value)) {
                llvm::report_fatal_error("The type of the param does not match, requires array but input ident");
            }
            if (!isMultiArray(value)) {
                // 1-dim or [i32 * n]**
                if (value->getType()->getPointerElementType()->isPointerTy()) {
                    llvm::PointerType *pointerType = llvm::PointerType::getInt32PtrTy(ir.module_->getContext());
                    value = ir.builder_->CreateLoad(pointerType, value);
                }
                auto *global_value = llvm::dyn_cast<llvm::GlobalVariable>(value);
                if (!global_value) {
                    llvm::Value *array_i = BaseAST::GetOffsetPointer(value, offset, ir);
                    return ir.builder_->CreateLoad(array_i);
                } else {
                    llvm::Value *array_i = BaseAST::GetOffsetPointer(global_value, offset, ir);
                    return ir.builder_->CreateLoad(array_i);
                }
            } else {
                // 2-dim
                int size;
                if (value->getType()->getPointerElementType()->isPointerTy()) {
                    size = (int) value->getType()->getPointerElementType()->getPointerElementType()->getArrayNumElements();
                    llvm::ArrayType *array_type = llvm::ArrayType::get(
                            llvm::IntegerType::getInt32Ty(ir.module_->getContext()), size);
                    llvm::PointerType *pointer = llvm::PointerType::get(array_type, 0);
                    value = ir.builder_->CreateLoad(pointer, value);
                }
                auto global_value = llvm::dyn_cast<llvm::GlobalVariable>(value);
                llvm::Value *array_1;
                llvm::Value *array_2;
                llvm::Value *tar_value;
                if (!global_value) {
                    if (value->getType()->getPointerElementType()->isArrayTy() &&
                        !value->getType()->getPointerElementType()->getArrayElementType()->isArrayTy()) {
                        llvm::Value *const_i;
                        llvm::ArrayType *array_type = llvm::ArrayType::get(
                                llvm::IntegerType::getInt32Ty(ir.module_->getContext()), size);
                        const_i = BaseAST::GetOffset(&*array_offset_, ir);
                        array_1 = ir.builder_->CreateGEP(value, const_i);
                    } else {
                        array_1 = BaseAST::GetOffsetPointer(value, &*array_offset_, ir);
                    }
                    if (!array_offset2_) {
                        array_2 = BaseAST::GetOffsetPointer(array_1, 0, ir);
                        return array_2;
                    } else {
                        array_2 = BaseAST::GetOffsetPointer(array_1, &*array_offset2_, ir);
                        return ir.builder_->CreateLoad(array_2);
                    }
                } else {
                    array_1 = BaseAST::GetOffsetPointer(value, &*array_offset_, ir);
                    if (array_offset2_) {
                        array_2 = BaseAST::GetOffsetPointer(array_1, &*array_offset2_, ir);
                    } else {
                        array_2 = BaseAST::GetOffsetPointer(array_1, 0, ir);
                        return array_2;
                    }
                    return ir.builder_->CreateLoad(array_2);
                }
            }
        }
        case kAssign:
            value = ir.get_value(this->ident_, current_block);
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(ir);
            ir.builder_->CreateStore(r_exp_value, value, "store");
            return r_exp_value;
        case kAssignArray: {
            value = ir.get_value(this->ident_, current_block);
            // check the type of the value
            if (!BaseAST::is_array(value)) {
                llvm::report_fatal_error("The type of the param does not match, requires array but input ident");
            }
            if (!array_offset2_) {
                // 1-dim
                if (value->getType()->getPointerElementType()->isPointerTy()) {
                    llvm::PointerType *pointerType = llvm::PointerType::getInt32PtrTy(ir.module_->getContext());
                    value = ir.builder_->CreateLoad(pointerType, value);
                }
                auto offset = &(*array_offset_);
                r_exp = (ExprAST *) (&(*rExp_));
                r_exp_value = r_exp->CodeGen(ir);

                // consider the value is a global value
                auto *global_value = llvm::dyn_cast<llvm::GlobalVariable>(value);
                if (!global_value) {
                    llvm::Value *array_i = BaseAST::GetOffsetPointer(value, offset, ir);
                    ir.builder_->CreateStore(r_exp_value, array_i, "store");
                    return r_exp_value;
                } else {
                    llvm::Value *array_i = BaseAST::GetOffsetPointer(global_value, offset, ir);
                    ir.builder_->CreateStore(r_exp_value, array_i, "store");
                    return r_exp_value;
                }
            } else {
                int size;
                r_exp_value = rExp_->CodeGen(ir);
                if (value->getType()->getPointerElementType()->isPointerTy()) {
                    size = (int) value->getType()->getPointerElementType()->getPointerElementType()->getArrayNumElements();
                    llvm::ArrayType *array_type = llvm::ArrayType::get(
                            llvm::IntegerType::getInt32Ty(ir.module_->getContext()), size);
                    llvm::PointerType *pointer = llvm::PointerType::get(array_type, 0);
                    value = ir.builder_->CreateLoad(pointer, value);
                }
                auto global_value = llvm::dyn_cast<llvm::GlobalVariable>(value);
                llvm::Value *array_1;
                llvm::Value *array_2;
                if (!global_value) {
                    if (value->getType()->getPointerElementType()->isArrayTy() &&
                        !value->getType()->getPointerElementType()->getArrayElementType()->isArrayTy()) {
                        llvm::Value *const_i;
                        llvm::ArrayType *array_type = llvm::ArrayType::get(
                                llvm::IntegerType::getInt32Ty(ir.module_->getContext()), size);
                        const_i = BaseAST::GetOffset(&*array_offset_, ir);
                        array_1 = ir.builder_->CreateGEP(value, const_i);
                    } else {
                        array_1 = BaseAST::GetOffsetPointer(value, &*array_offset_, ir);
                    }
                    array_2 = BaseAST::GetOffsetPointer(array_1, &*array_offset2_, ir);
                    ir.builder_->CreateStore(r_exp_value, array_2, "store");
                    return r_exp_value;
                } else {
                    array_1 = BaseAST::GetOffsetPointer(value, &*array_offset_, ir);
                    array_2 = BaseAST::GetOffsetPointer(array_1, &*array_offset2_, ir);
                    ir.builder_->CreateStore(r_exp_value, array_2, "store");
                    return r_exp_value;
                }
            }

        }
        case kFunction: {
            llvm::Function *func = ir.module_->getFunction(this->ident_);
            if (!func) {
                llvm::report_fatal_error("unable to find the target function\n");
            }
            std::vector<llvm::Value *> temp_args;
            if (!get_params(current_block, func, ir, temp_args)) {
                llvm::report_fatal_error("param error\n");
            }
            llvm::ArrayRef<llvm::Value *> params(temp_args);
            return ir.builder_->CreateCall(func, params);
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
        default: {
            bool is_pointer = false;
            bool is_pointer_2 = false;
            l_exp_value = lExp_->CodeGen(ir);
            auto &instruction = current_block->current_->getInstList().back();
            if (instruction.getOpcode() == llvm::Instruction::GetElementPtr) {
                is_pointer = true;
            }
            r_exp_value = rExp_->CodeGen(ir);
            auto &instruction2 = current_block->current_->getInstList().back();
            if (instruction2.getOpcode() == llvm::Instruction::GetElementPtr) {
                is_pointer_2 = true;
            }
            switch (type_) {
                case kAdd: {
                    if (is_pointer) {
                        return BaseAST::GetOffsetPointer(l_exp_value, &*rExp_, ir);
                    }
                    if (is_pointer_2) {
                        return BaseAST::GetOffsetPointer(r_exp_value, &*lExp_, ir);
                    }
                    return ir.builder_->CreateAdd(l_exp_value, r_exp_value);
                }
                case kSub: {
                    if (is_pointer) {
                        r_exp = (ExprAST *) &*rExp_;
                        if (r_exp->type_ == kAtomNum) {
                            r_exp->num_ = -r_exp->num_;
                        }
                        return BaseAST::GetOffsetPointer(l_exp_value, &*rExp_, ir);
                    }
                    if (is_pointer_2) {
                        llvm::report_fatal_error("pointer error");
                    }
                    return ir.builder_->CreateSub(l_exp_value, r_exp_value);
                }
                case kMul:
                    return ir.builder_->CreateMul(l_exp_value, r_exp_value);
                case kDiv:
                    return ir.builder_->CreateSDiv(l_exp_value, r_exp_value);
                case kEqual:
                    return ir.builder_->CreateICmpEQ(l_exp_value, r_exp_value);
                case kNotEqual:
                    return ir.builder_->CreateICmpNE(l_exp_value, r_exp_value);
                case kAnd:
                    return ir.builder_->CreateAnd(l_exp_value, r_exp_value);
                case kMod:
                    return ir.builder_->CreateURem(l_exp_value, r_exp_value);
                case kOr:
                    return ir.builder_->CreateOr(l_exp_value, r_exp_value);
                case kLarger:
                    return ir.builder_->CreateICmpSGT(l_exp_value, r_exp_value);
                case kLargerEqual:
                    return ir.builder_->CreateICmpSGE(l_exp_value, r_exp_value);
                case kLess:
                    return ir.builder_->CreateICmpSLT(l_exp_value, r_exp_value);
                case kLessEqual:
                    return ir.builder_->CreateICmpSLE(l_exp_value, r_exp_value);
                default: {
                    llvm::Value *op_result = nullptr;
                    switch (type_) {
                        case kAddAssign: {
                            op_result = ir.builder_->CreateAdd(l_exp_value, r_exp_value);
                            return ir.builder_->CreateStore(op_result, l_exp_value);
                        }
                        case kSubAssign: {
                            op_result = ir.builder_->CreateSub(l_exp_value, r_exp_value);
                            return ir.builder_->CreateStore(op_result, l_exp_value);
                        }
                        case kMulAssign: {
                            op_result = ir.builder_->CreateMul(l_exp_value, r_exp_value);
                            return ir.builder_->CreateStore(op_result, l_exp_value);
                        }
                        case kDivAssign: {
                            op_result = ir.builder_->CreateUDiv(l_exp_value, r_exp_value);
                            return ir.builder_->CreateStore(op_result, l_exp_value);
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
            if (ast->array_size2_ == 0) {
                // 1-dims
                llvm::IntegerType *int_type = llvm::IntegerType::get(ir.module_->getContext(), 32);
                llvm::PointerType *pointer = llvm::PointerType::get(int_type, 0);
                param_types.emplace_back(pointer);
            } else {
                // 2-dim
                llvm::IntegerType *int_type = llvm::IntegerType::getInt32Ty(ir.module_->getContext());
                llvm::ArrayType *array_type = llvm::ArrayType::get(int_type, ast->array_size2_);
                llvm::PointerType *pointer = llvm::PointerType::get(array_type, 0);
                param_types.emplace_back(pointer);
            }
        } else {
            llvm::report_fatal_error("Undefined type\n");
        }
    }
    if (ir.get_global_value(this->ident_)) {
        llvm::report_fatal_error("The function has been used in functions or params");
    }
    llvm::IntegerType *return_type = llvm::IntegerType::get(ir.module_->getContext(), 32);
    llvm::FunctionType *func_type;
    llvm::Function *func;
    std::vector<std::string> name_list;
    if (type_ == kInt) {
        func_type = llvm::FunctionType::get(return_type, param_types, false);
        func = llvm::Function::Create(func_type,
                                      llvm::GlobalValue::ExternalLinkage,
                                      this->ident_,
                                      *ir.module_);
    } else {
        func_type = llvm::FunctionType::get(llvm::Type::getVoidTy(ir.module_->getContext()), param_types, false);
        func = llvm::Function::Create(func_type,
                                      llvm::GlobalValue::ExternalLinkage,
                                      this->ident_,
                                      *ir.module_);
    }
    int i = 0;
    StmtAST *stmt_ast;
    for (auto arg = func->arg_begin(); arg != func->arg_end(); arg++) {
        stmt_ast = ((StmtAST *) &(*param_lists_[i++]));
        name_list.emplace_back(stmt_ast->ident_);
    }
    if (block_) {
        llvm::BasicBlock *entry = llvm::BasicBlock::Create(ir.module_->getContext(), "", func);
        llvm::BasicBlock *returnBlock = llvm::BasicBlock::Create(ir.module_->getContext(), "", func);
        auto current_block = new BasicBlock(nullptr, entry);
        auto return_block = new BasicBlock(current_block, returnBlock);
        ir.return_block_ = return_block;
        ir.push_global_value(func, this->ident_);
        ir.SetCurrentBlock(current_block);

        auto value = ir.builder_->CreateAlloca(llvm::IntegerType::getInt32Ty(ir.module_->getContext()));
        auto zero = llvm::ConstantInt::get(llvm::IntegerType::getInt32Ty(ir.module_->getContext()), 0);
        std::string block_name = current_block->current_->getParent()->getName().str();
        block_name += current_block->current_->getName().str();
        ir.push_value(value, block_name, "1");
        ir.builder_->CreateStore(zero, value);

        this->AddParams(ir, name_list);

        block_->CodeGen(ir);

        ir.SetCurrentBlock(return_block);
        if (type_ != kVoid) {
            llvm::Value *returnValue = ir.get_value("1", current_block);
            llvm::Value* return_value = ir.builder_->CreateLoad(returnValue);
            ir.builder_->CreateRet(return_value);
        } else {
            ir.builder_->CreateRetVoid();
        }
    }
    return func;
}

void FuncDefAST::AddParams(IR &ir, std::vector<std::string> &name_list) {
    auto current_block = ir.GetCurrentBlock();
    int i = 0;
    std::string block_name = current_block->current_->getParent()->getName().str();
    block_name += current_block->current_->getName().str();
    for (auto &item: current_block->current_->getParent()->args()) {
        if (item.getType()->isIntegerTy()) {
            llvm::IntegerType *integerType = llvm::IntegerType::get(ir.module_->getContext(), 32);
            auto value = ir.builder_->CreateAlloca(integerType);
            ir.push_value(value, block_name, name_list[i]);
        } else {
            if (item.getType()->getPointerElementType()->isArrayTy()) {
                int size = (int) item.getType()->getPointerElementType()->getArrayNumElements();
                llvm::IntegerType *inter_type = llvm::IntegerType::getInt32Ty(ir.module_->getContext());
                llvm::PointerType *pointer = llvm::PointerType::get(llvm::ArrayType::get(inter_type, size), 0);
                auto value = ir.builder_->CreateAlloca(pointer);
                ir.push_value(value, block_name, name_list[i]);
            } else {
                llvm::PointerType *pointerType = llvm::PointerType::getInt32PtrTy(ir.module_->getContext());
                auto value = ir.builder_->CreateAlloca(pointerType);
                ir.push_value(value, block_name, name_list[i]);
            }
        }
        i++;
    }
    i = 0;
    for (auto &item: current_block->current_->getParent()->args()) {
        auto value = ir.get_value(name_list[i++], current_block);
        ir.builder_->CreateStore(&item, value);
    }
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
    auto current_block = ir.GetCurrentBlock();
    auto args = current_block->current_->getParent()->arg_begin();
    for (auto &item: this->stmt_) {
        current_block = ir.GetCurrentBlock();
        auto &final_ins = current_block->current_->back();
        if (llvm::dyn_cast<llvm::BranchInst>(&final_ins)) {
            break;
        }
        item->CodeGen(ir);
    }
//    if (llvm::succ_begin(current_block->current_) == llvm::succ_end(current_block->current_) && !ir.exit_block_) {
//        llvm::Function *currentFunction = current_block->current_->getParent();
//        if (currentFunction->getReturnType()->isIntegerTy()) {
//            llvm::Value *returnValue = ir.get_value("1", current_block);
//            returnValue = ir.builder_->CreateLoad(returnValue);
//            ir.builder_->CreateRet(returnValue);
//            return nullptr;
//        }
//    }
    current_block = ir.GetCurrentBlock();
    auto &final_ins = current_block->current_->back();

    llvm::outs() << final_ins.getOpcode() << ' ' << llvm::Instruction::Br << '\n';
    if (!llvm::dyn_cast<llvm::BranchInst>(&final_ins) || final_ins.getOpcode() != llvm::Instruction::Br) {
        if (ir.exit_block_) {
            ir.builder_->CreateBr(ir.exit_block_->current_);
        }
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
    for (auto &item: param_lists_) {
        auto value = item->CodeGen(ir);
//        value->getType()->print(llvm::outs(), true);
//        llvm::outs() << '\n';
//        if ((arg->getType()->isPointerTy() && !value->getType()->isPointerTy()) ||
//            (arg->getType()->isIntegerTy() && !value->getType()->isIntegerTy()) ||
//            (arg->getType()->isPointerTy() && !value->getType()->isArrayTy())) {
//            return false;
//        }
        temp_args.emplace_back(value);
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
        } else if (value->getType()->getPointerElementType()->isPointerTy()) {
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
}

BaseAST *BaseAST::GetParent() {
    return parent_;
}

void BaseAST::SetParent(BaseAST *tar) {
    parent_ = tar;
}

void BaseAST::BuildAstTree() {

}

llvm::Value *BaseAST::GetOffsetPointer(llvm::Value *tar_pointer, BaseAST *offset, IR &ir) {
    if (!tar_pointer->getType()->isPointerTy()) {
        llvm::report_fatal_error("input type error");
    }
    llvm::Value *const_0 = nullptr;
    llvm::Value *const_i = nullptr;
    llvm::Value *array_i = nullptr;
    llvm::IntegerType *integerType = llvm::IntegerType::getInt32Ty(ir.module_->getContext());

    const_0 = BaseAST::GetOffset(0, ir);
    const_i = BaseAST::GetOffset(offset, ir);
    llvm::Value *idx[] = {const_0, const_i};
    if (tar_pointer->getType()->getPointerElementType()->isArrayTy()) {
        array_i = ir.builder_->CreateGEP(tar_pointer, idx);
    } else {
        array_i = ir.builder_->CreateGEP(tar_pointer, const_i);
    }
    return array_i;
}

llvm::Value *BaseAST::GetOffset(BaseAST *offset, IR &ir) {
    auto exp = (ExprAST *) &(*offset);
    if (exp->type_ == kAtomNum) {
        return BaseAST::GetOffset(exp->num_, ir);
    }
    return offset->CodeGen(ir);
}

llvm::Value *BaseAST::GetOffset(int tar, IR &ir) {
    llvm::IntegerType *integerType = llvm::IntegerType::getInt32Ty(ir.module_->getContext());
    return llvm::ConstantInt::get(integerType, tar);
}

llvm::Value *BaseAST::GetOffsetPointer(llvm::Value *tar_pointer, int offset, IR &ir) {
    if (!tar_pointer->getType()->isPointerTy()) {
        llvm::report_fatal_error("input type error");
    }
    llvm::Value *const_0 = nullptr;
    llvm::Value *const_i = nullptr;
    llvm::Value *array_i = nullptr;
    llvm::IntegerType *integerType = llvm::IntegerType::getInt32Ty(ir.module_->getContext());

    const_0 = BaseAST::GetOffset(0, ir);
    const_i = BaseAST::GetOffset(offset, ir);
    llvm::Value *idx[] = {const_0, const_i};
    if (tar_pointer->getType()->getPointerElementType()->isArrayTy()) {
        array_i = ir.builder_->CreateGEP(tar_pointer, idx);
    } else {
        array_i = ir.builder_->CreateGEP(tar_pointer, const_i);
    }
    return array_i;
}

bool BaseAST::isMultiArray(llvm::Value *value) {
    if (value->getType()->getPointerElementType()->isPointerTy() &&
        value->getType()->getPointerElementType()->getPointerElementType()->isArrayTy()) {
        return true;
    }
    if (value->getType()->getPointerElementType()->isArrayTy() &&
        value->getType()->getPointerElementType()->getArrayElementType()->isArrayTy()) {
        return true;
    }
    return false;
}
