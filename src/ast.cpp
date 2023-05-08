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
    std::cout << "BlockAST: { ";
    for (const auto &temp: stmt_) {
        temp->Dump();
    }
    std::cout << " }";
}

void CompUnitAST::Dump() const {
    std::cout << "ComUnitAST: { ";
    func_def_->Dump();
    std::cout << " }";
}

void StmtAST::Dump() const {
    std::cout << "StmtAST: { ";
    switch (type_) {
        case kReturn:
            std::cout << key_word_ << " " << rNum_;
            break;
        case kDeclare:
            std::cout << key_word_ << " " << lIdent_;
            break;
        default:
            std::cerr << "error";
    }
    std::cout << " } ";
}
