//
// Created by dcr on 23-5-6.
//

#ifndef COMPILER_BASE_AST_H
#define COMPILER_BASE_AST_H

#include <memory>
#include <iostream>

// 定义一个基础类
class BaseAST {
private:

public:
    BaseAST() = default;

    virtual ~BaseAST() = default;

    virtual void Dump() const = 0;
};

class CompUnitAST : public BaseAST {
public:
    CompUnitAST() = default;

    ~CompUnitAST() override = default;

    std::unique_ptr<BaseAST> func_def_;
};

class FuncDefAST : public BaseAST {
public:
    FuncDefAST() = default;

    ~FuncDefAST() override = default;

    void Dump() const override {
        std::cout << "FuncDefAST { ";
        func_type_->Dump();
        std::cout << ", " << ident_ << ", ";
        block_->Dump();
        std::cout << " }";
    }

    std::unique_ptr<BaseAST> func_type_;
    std::string ident_;
    std::unique_ptr<BaseAST> block_;
};

#endif //COMPILER_BASE_AST_H
