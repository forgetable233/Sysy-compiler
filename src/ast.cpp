//
// Created by dcr on 23-5-6.
//

#include "ast.h"

void FuncTypeAST::Dump() const {
    std::cout << "FuncType: { " << this->type_ << " }";
}

void FuncDefAST::Dump() const {
    std::cout << "FuncDefAST: { ";
    func_type_->Dump();
    std::cout << ", FuncName: { " << ident_ << " }, ";
    block_->Dump();
    std::cout << " }";
}

void BlockAST::Dump() const {
    std::cout << "BaseAST: { ";
    stmt_->Dump();
    if (block_ != nullptr) {
        block_->Dump();
    }
//    stmt_.emplace_back()
    std::cout << " }";
}

void CompUnitAST::Dump() const {
    std::cout << "ComUnitAST: { ";
    func_def_->Dump();
    std::cout << " }";
}

void StmtAST::Dump() const {
    std::cout << "StmtAST: { ";
    expression_->Dump();
    std::cout << " } ";
}

void ExpressionAST::Dump() const {
    std::cout << "Expression: { ";
    std::cout << state_ << ' ' << num_ << " } ";
}
