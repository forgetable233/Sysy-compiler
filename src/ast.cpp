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
    std::cout << ", " << ident_ << ", ";
    block_->Dump();
    std::cout << " }";
}

void BlockAST::Dump() const {
    std::cout << "BaseAST: { ";
    stmt_->Dump();
    std::cout << " }";
}

void CompUnitAST::Dump() const {
    std::cout << "ComUnitAST: { ";
    func_def_->Dump();
    std::cout << " }";
}

void StmtAST::Dump() const {
    std::cout << "StmtAST: { ";
    std::cout << statement_ << " }";
}
