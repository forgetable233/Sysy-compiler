//
// Created by dcr on 23-5-6.
//

#ifndef COMPILER_AST_H
#define COMPILER_AST_H

#include <memory>
#include <iostream>
#include <vector>
#include <map>
#include <llvm/IR/Value.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/GlobalIFunc.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/raw_ostream.h>

#include "IR.h"

enum ExpType {
    kAdd,
    kSub,
    kMul,
    kDiv,
    kAtomIdent,
    kAtomNum,
    kAssign
};

enum StmtType {
    kReturn,
    kDeclare,
    kExpression,
    kIf,
    kWhile
};

// 所有AST的基础类
class BaseAST {
private:

public:
    BaseAST() = default;

    virtual ~BaseAST() = default;

    virtual void Dump(int tab_num) const = 0;

    virtual llvm::Value *CodeGen(IR &ir);

    virtual llvm::Value *ErrorValue(const char *str);
};

class ExprAST : public BaseAST {
public:
    ExpType type_;

    std::string ident_;

    std::string num_;

    std::unique_ptr<BaseAST> lExp_ = nullptr;

    std::unique_ptr<BaseAST> rExp_ = nullptr;

    ExprAST() = default;

    ~ExprAST() override = default;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *CodeGen(llvm::BasicBlock *entry_block, IR &ir);

    llvm::Value *ErrorValue(const char *str) override;
};

/**
 * 代码段的AST
 */
class StmtAST : public BaseAST {
public:
    StmtType type_;

    std::string key_word_;

    std::string ident_;

    std::unique_ptr<BaseAST> exp_ = nullptr;

    std::unique_ptr<BaseAST> block_ = nullptr;

    StmtAST() = default;

    ~StmtAST() override = default;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *CodeGen(llvm::BasicBlock *entry_block, IR &ir);


    llvm::Value *ErrorValue(const char *str) override;
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

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *ErrorValue(const char *str) override;
};

/**
 * 代码段AST
 */
class BlockAST : public BaseAST {
public:
    std::vector<std::unique_ptr<BaseAST>> stmt_;

    std::vector<std::unique_ptr<BaseAST>> blocks_;

//    std::unique_ptr<BaseAST> stmt_ = nullptr;

//    std::unique_ptr<BaseAST> block_ = nullptr;

    BlockAST() = default;

    ~BlockAST() override = default;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *CodeGen(llvm::BasicBlock *entry_block, IR &ir);

    llvm::Value *ErrorValue(const char *str) override;
};

/**
 * 函数类型AST
 */
class FuncTypeAST : public BaseAST {
public:
    std::string type_;

    FuncTypeAST() = default;

    ~FuncTypeAST() override = default;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *ErrorValue(const char *str) override;
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

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *ErrorValue(const char *str) override;
};

#endif //COMPILER_AST_H
