//
// Created by dcr on 23-5-6.
//

// TODO CompUnit中支持多个函数，同时函数支持变量表
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
        default:
            llvm::report_fatal_error("Undefined type");
    }
    std::cout << std::endl;
    OutTab(tab_num);
    std::cout << "} ";
}

llvm::Value *StmtAST::CodeGen(IR &ir) {
    llvm::Value *tamp_value = ir.get_global_value(this->ident_);
    if (tamp_value) {
        llvm::report_fatal_error("The variable has been declared");
        return nullptr;
    }
    llvm::IntegerType *int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
    llvm::GlobalVariable *var;
    var = new llvm::GlobalVariable(*ir.module_,
                                   int_type,
                                   false,
                                   llvm::GlobalVariable::ExternalLinkage,
                                   nullptr, this->ident_);
    ir.push_global_value(var, this->ident_);
    return var;
}

llvm::Value *StmtAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
//    auto builder = std::make_unique<llvm::IRBuilder<>>(ir.module_->getContext());
//    builder->SetInsertPoint(entry_block);
    ir.builder_->SetInsertPoint(entry_block);
    llvm::Type *int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
    llvm::Value *value;
    llvm::BasicBlock *true_block = nullptr;
    llvm::BasicBlock *false_block = nullptr;
    llvm::BasicBlock *merge_block = nullptr;

    llvm::BasicBlock *loop_header = nullptr;
    llvm::BasicBlock *loop_body = nullptr;
    llvm::BasicBlock *loop_exit = nullptr;

//    llvm::Instruction *first_ins = &entry_block->front();
    llvm::GlobalVariable *var;
//    llvm::AllocaInst *alloca_inst = builder->CreateAlloca(int_type, nullptr, this->ident_);
    auto exp = (ExprAST *) (&(*this->exp_));
    switch (type_) {
        case kDeclare:
            if (ir.get_value(entry_block->getName().str(), this->ident_)) {
                llvm::report_fatal_error("The variable has been declared");
                return nullptr;
            }
            for (auto &args: entry_block->getParent()->args()) {
                std::cout << args.getName().str() << std::endl;
                if (strcmp(this->ident_.c_str(), args.getName().str().c_str()) == 0) {
                    llvm::report_fatal_error("The variable has been declared");
                    return nullptr;
                }
            }
            value = ir.builder_->Insert(ir.builder_->CreateAlloca(int_type, nullptr, this->ident_));
            value->setName(this->ident_);
            ir.push_value(value,
                          entry_block->getName().str(),
                          this->ident_);
            return value;
        case kExpression:
            exp->CodeGen(entry_block, ir);
            break;
        case kReturn:
            return ir.builder_->CreateRet(exp->CodeGen(entry_block, ir));
            break;
        case kIf:
            value = ((ExprAST *) &(*this->exp_))->CodeGen(entry_block, ir);
            //            std::cout << entry_block->getParent()->getName().str() << std::endl;
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
//            llvm::BranchInst::Create(entry_block, merge_block);
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
//            llvm::BranchInst::Create(entry_block, loop_header);

            // loop_body
            ((BlockAST *) &(*this->block_))->CodeGen(loop_body, ir);
            ir.builder_->SetInsertPoint(loop_body);
            llvm::BranchInst::Create(loop_header, loop_body);

            // loop_exit
            ir.builder_->SetInsertPoint(loop_exit);
//            first_ins = entry_block->front().getNextNode();
//            llvm::outs() << first_ins->getOpcodeName() << "\n";
            llvm::BranchInst::Create(entry_block, loop_exit);
            break;
        case kStatic:
            var = new llvm::GlobalVariable(*ir.module_,
                                           int_type,
                                           false,
                                           llvm::GlobalVariable::ExternalLinkage,
                                           nullptr, this->ident_);
            return var;
        default:
            llvm::report_fatal_error("The variable has been declared");
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
    param_types.reserve(param_size);
    for (int i = 0; i < param_size; ++i) {
        StmtAST *stmt_ast_i = ((StmtAST*)&(*param_lists_[i]));
        for (int j = i + 1; j < param_size; ++j) {
            StmtAST *stmt_ast_j = ((StmtAST*)&(*param_lists_[j]));
            if (std::strcmp(stmt_ast_i->ident_.c_str(), stmt_ast_j->ident_.c_str()) == 0) {
                llvm::report_fatal_error("The variable has been declared");
                return nullptr;
            }
        }
    }
    for (int i = 0; i < param_size; ++i) {
        param_types.emplace_back(llvm::IntegerType::get(ir.module_->getContext(), 32));
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
    auto tar_block = (BlockAST *) (&(*block_));
    tar_block->CodeGen(entry, ir);
    return func;
}

FuncDefAST::~FuncDefAST() {
    block_.reset(nullptr);
}

llvm::Value *BlockAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
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
    switch (type_) {
        case kAtomNum:
            return llvm::ConstantFP::get(context, llvm::APFloat(strtod(num_.c_str(), nullptr)));
        case kAtomIdent:
            for (auto current_block = entry_block; current_block; current_block = current_block->getPrevNode()) {
                value = ir.get_value(current_block->getName(), this->ident_);
                if (value) {
                    break;
                }
            }
            if (value == nullptr) {
                value = ir.module_->getGlobalVariable(this->ident_);
                if (!value) {
                    llvm::errs() << "Error variable " << ident_ << " not declared";
                    return nullptr;
                }
            }
            return ir.builder_->CreateLoad(value, this->ident_);
        case kAssign:
            for (auto current_block = entry_block; current_block; current_block = current_block->getPrevNode()) {
                value = ir.get_value(current_block->getName(), this->ident_);
                if (value) {
                    break;
                }
            }
            if (value == nullptr) {
                value = ir.module_->getGlobalVariable(this->ident_);
                if (!value) {
                    llvm::errs() << "Error variable " << ident_ << " not declared";
                    return nullptr;
                }
            }
            r_exp = (ExprAST *) (&(*rExp_));
            r_exp_value = r_exp->CodeGen(entry_block, ir);
            return ir.builder_->CreateStore(value, r_exp_value, "store");
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
                    throw std::runtime_error("invalid binary operator");
//                    return ErrorValue("invalid binary operator");
            }
    }
//    return nullptr;
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
