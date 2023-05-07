//
// Created by dcr on 23-5-6.
//

#ifndef COMPILER_AST_H
#define COMPILER_AST_H

#include <memory>
#include <iostream>
#include <vector>

// 所有AST的基础类
class BaseAST {
private:

public:
    BaseAST() = default;

    virtual ~BaseAST() = default;

    virtual void Dump() const = 0;
};

class ExpressionAST : public BaseAST {
public:
    std::string func_;

    std::string lNum_;

    std::string rNum_;

    std::string state_;

    std::string num_;

    std::unique_ptr<BaseAST> lExp_ = nullptr;

    std::unique_ptr<BaseAST> rExp_ = nullptr;

    ExpressionAST() = default;

    ~ExpressionAST() override = default;

    void Dump() const override;
};

/**
 * 代码段的AST
 */
class StmtAST : public BaseAST {
public:
//    std::string statement_;
//
//    std::string name_;
//
//    std::string type_;
//
//    std::string func_;
    std::unique_ptr<BaseAST> expression_ = nullptr;

    StmtAST() = default;

    ~StmtAST() override = default;

    void Dump() const override;
};

/**
 * 编译单元AST
 * 可能包含多个函数等
 */
class CompUnitAST : public BaseAST {
public:
    std::unique_ptr<BaseAST> func_def_;

    CompUnitAST() = default;

    ~CompUnitAST() override = default;

    void Dump() const override;
};

/**
 * 代码段AST
 */
class BlockAST : public BaseAST {
public:
    std::unique_ptr<BaseAST> stmt_ = nullptr;

    std::unique_ptr<BaseAST> block_ = nullptr;

    BlockAST() = default;

    ~BlockAST() override = default;

    void Dump() const override;
};

/**
 * 函数类型AST
 */
class FuncTypeAST : public BaseAST {
public:
    std::string type_;

    FuncTypeAST() = default;

    ~FuncTypeAST() override = default;

    void Dump() const override;
};

/**
 * 函数定义AST
 */
class FuncDefAST : public BaseAST {
public:
    std::string ident_;

    std::unique_ptr<BaseAST> func_type_;

    std::unique_ptr<BaseAST> block_;

    FuncDefAST() = default;

    ~FuncDefAST() override = default;


    void Dump() const override;
};

#endif //COMPILER_AST_H
