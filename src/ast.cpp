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
    OutTab(tab_num);
    std::cout << "}";
}

llvm::Value *FuncDefAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
}

void BlockAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "BlockAST: { " << std::endl;
    for (int i = 0; i < stmt_.size() - 1; ++i) {
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

llvm::Value *BlockAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
    return nullptr;
}

void CompUnitAST::Dump(int tab_num) const {
    OutTab(tab_num);
    std::cout << "ComUnitAST: { " << std::endl;
    func_def_->Dump(tab_num + 1);
    std::cout << std::endl;
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
    }
    std::cout << std::endl;
    OutTab(tab_num);
    std::cout << "} ";
}

llvm::Value *StmtAST::CodeGen(IR &ir) {
    return nullptr;
}

llvm::Value *StmtAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
    auto builder = std::make_unique<llvm::IRBuilder<>>(ir.module_->getContext());
    builder->SetInsertPoint(entry_block);
    llvm::Type *int_type = llvm::Type::getInt32Ty(ir.module_->getContext());
    llvm::AllocaInst *alloca_inst = builder->CreateAlloca(int_type, nullptr, this->ident_);
    auto exp = (ExprAST *) (&(this->exp_));
    switch (type_) {
        case kDeclare:
            entry_block->getInstList().push_back(alloca_inst);
            break;
        case kExpression:
            exp->CodeGen(entry_block, ir);
            break;
        case kReturn:
            builder->CreateRet(exp->CodeGen(entry_block, ir));

            break;
        default:
            std::cerr << "UNDEFINED TYPE" << std::endl;
    }
    return nullptr;
}

llvm::Value *StmtAST::ErrorValue(const char *str) {
    return BaseAST::ErrorValue(str);
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

/**
 * 函数声明的AST
 * 目前只有INT类型的函数，没有进一步细化
 * 留下了接口以后进行更新
 * @param module
 * @return
 */
llvm::Value *FuncDefAST::CodeGen(IR &ir) {
    llvm::IntegerType *return_type = llvm::IntegerType::get(ir.module_->getContext(), 32);
    llvm::FunctionType *func_type = llvm::FunctionType::get(return_type, false);
    llvm::Function *func = llvm::Function::Create(func_type,
                                                  llvm::GlobalValue::ExternalLinkage,
                                                  this->ident_,
                                                  *ir.module_);
    llvm::BasicBlock *entry = llvm::BasicBlock::Create(ir.module_->getContext(), "entry", func);

    auto tar_block = (BlockAST *) (&(*block_));
//    func->getBasicBlockList().push_back(entry);
    ir.module_->getFunctionList().push_back(func);
    std::cout << "Enter func" << std::endl;
    return tar_block->CodeGen(entry, ir);
//    return BaseAST::CodeGen(module);
}

llvm::Value *BlockAST::CodeGen(IR &ir) {
    for (auto &it: this->stmt_) {
        it->CodeGen(ir);
    }
    return BaseAST::CodeGen(ir);
}

llvm::Value *CompUnitAST::CodeGen(IR &ir) {
    auto temp_func = (FuncDefAST *) (&(*func_def_));
    return temp_func->CodeGen(ir);
//    return BaseAST::CodeGen(builder, module);
}

llvm::Value *ExprAST::CodeGen(llvm::BasicBlock *entry_block, IR &ir) {
    auto builder = std::make_unique<llvm::IRBuilder<>>(*ir.context_);
    builder->SetInsertPoint(entry_block);
    llvm::LLVMContext &context = *ir.context_;
    auto l_exp = (ExprAST *) (&(*lExp_));
    auto r_exp = (ExprAST *) (&(*rExp_));
    llvm::Value *l_exp_value = nullptr;
    llvm::Value *r_exp_value = nullptr;
    if (type_ != kAtomIdent && type_ != kAtomNum) {
        l_exp_value = l_exp->CodeGen(entry_block, ir);
        r_exp_value = r_exp->CodeGen(entry_block, ir);
        if (!l_exp_value || !r_exp_value) {
            return nullptr;
        }
    }
    switch (type_) {
        case kAtomNum:
            return llvm::ConstantFP::get(context, llvm::APFloat(strtod(num_.c_str(), nullptr)));
        case kAtomIdent:

            break;
        case kAdd:
            return builder->CreateFAdd(l_exp_value, r_exp_value, "add");
        case kSub:
            return builder->CreateFSub(l_exp_value, r_exp_value, "sub");
        case kMul:
            return builder->CreateFMul(l_exp_value, r_exp_value, "mul");
        case kDiv:
            return builder->CreateFDiv(l_exp_value, r_exp_value, "div");
        case kAssign:
            return builder->CreateStore(l_exp_value, r_exp_value, "store");
        default:
            throw std::runtime_error("invalid binary operator");
            return ErrorValue("invalid binary operator");
    }
    return nullptr;
}

llvm::Value *BaseAST::CodeGen(IR &ir) {

    return nullptr;
}

llvm::Value *BaseAST::ErrorValue(const char *str) {
    return nullptr;
}
