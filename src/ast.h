//
// Created by dcr on 23-5-6.
//

#ifndef COMPILER_AST_H
#define COMPILER_AST_H

// TODO 控制流图的生成，在if和while中，是不是要将current改为引用
// TODO 后端生成最后的RISC-V
#include <memory>
#include <iostream>
#include <vector>
#include <map>
#include <string>
#include <cstring>
#include <llvm/IR/Value.h>
#include <llvm/IR/GlobalIFunc.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/ADT/APFloat.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Target/TargetMachine.h>
#include <llvm/Transforms/InstCombine/InstCombine.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Scalar/GVN.h>
#include <llvm/Support/ErrorHandling.h>
#include <llvm/IR/CFG.h>

#include "IR.h"

class BlockAST;

class CompUnitAST;

enum ExpType {
    kAdd,
    kSub,
    kMul,
    kDiv,
    kAtomIdent,
    kAtomNum,
    kAtomArray,
    kAssign,
    kAssignArray,
    kFunction,
    kEqual,
    kNotEqual,
    kAnd,
    kOr,
    kMod,
    kLarger,
    kLargerEqual,
    kLess,
    kLessEqual,
    kMulAssign,
    kDivAssign,
    kAddAssign,
    kSubAssign,
    kNot,
    kAutoIncreaseLeft,
    kAutoIncreaseRight,
    kAutoDecreaseLeft,
    kAutoDecreaseRight,
    kAt,
    kParen,
    kNegative
};

enum StmtType {
    kReturn,
    kDeclare,
    kDeclareAssign,
    kDeclareArray,
    kDeclareArrayAssign,
    kDeclareMat,
    kDeclareMatAssign,
    kExpression,
    kIf,
    kStatic,
    kWhile,
    kContinue,
    kBreak
};

enum FuncType {
    kInt,
    kVoid
};

// 所有AST的基础类
class BaseAST {
private:

public:
    bool isConst = false;

    BaseAST *parent_ = nullptr;

    static bool is_array(llvm::Value *value);

    BaseAST() = default;

    virtual ~BaseAST() = default;

    virtual void Dump(int tab_num) const = 0;

    virtual llvm::Value *CodeGen(IR &ir);

    virtual llvm::Value *ErrorValue(const char *str);

    void SetParent(BaseAST *tar);

    BaseAST *GetParent();

    virtual void BuildAstTree();

    static llvm::Value *GetOffsetPointer(llvm::Value *tar_pointer, BaseAST *offset, IR &ir);

    static llvm::Value *GetOffsetPointer(llvm::Value *tar_pointer, int offset, IR &ir);

    static llvm::Value *GetOffset(BaseAST *offset, IR &ir);

    static llvm::Value *GetOffset(int tar, IR &ir);

    static bool isMultiArray(llvm::Value *value);
};

class ExprAST : public BaseAST {
private:
    bool get_params(BasicBlock *entry_block, llvm::Function *func, IR &ir,
                    std::vector<llvm::Value *> &temp_args);

public:
    ExpType type_;

    std::string ident_;

    int num_;

    std::unique_ptr<BaseAST> array_offset_ = nullptr;
    std::unique_ptr<BaseAST> array_offset2_ = nullptr;

    std::vector<std::unique_ptr<BaseAST>> param_lists_;

    std::unique_ptr<BaseAST> lExp_ = nullptr;

    std::unique_ptr<BaseAST> rExp_ = nullptr;

    ExprAST() = default;

    ~ExprAST() override;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

//    llvm::Value *CodeGen(BasicBlock *entry_block, IR &ir);

    llvm::Value *ErrorValue(const char *str) override;

    void BuildAstTree() override;
};

/**
 * 代码段的AST
 */
class StmtAST : public BaseAST {
public:
    StmtType type_;

    std::string key_word_;

    std::string ident_;

    std::vector<std::unique_ptr<BaseAST>> assign_list_;

    std::unique_ptr<BaseAST> exp_ = nullptr;
    std::unique_ptr<BaseAST> block_ = nullptr;
    std::unique_ptr<BaseAST> true_block_ = nullptr;
    std::unique_ptr<BaseAST> false_block_ = nullptr;

    int array_size_ = 0;

    int array_size2_ = 0;

    bool isEnd = false;

    StmtAST() = default;

    ~StmtAST() override;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

//    llvm::Value *CodeGen(BasicBlock *entry_block, IR &ir);

    llvm::Value *ErrorValue(const char *str) override;

    void BuildAstTree() override;

    void ResetAssignSize(int size);
};

/**
 * 编译单元AST
 * 可能包含多个函数等
 */
class CompUnitAST : public BaseAST {
public:
    std::vector<std::unique_ptr<BaseAST>> func_stmt_defs_;

    CompUnitAST() = default;

    ~CompUnitAST() override;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *ErrorValue(const char *str) override;

    void BuildAstTree() override;
};

/**
 * 代码段AST
 */
class BlockAST : public BaseAST {
public:
    std::vector<std::unique_ptr<BaseAST>> stmt_;

    BlockAST() = default;

    ~BlockAST() override;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

//    llvm::Value *CodeGen(BasicBlock *entry_block, IR &ir);

    llvm::Value *ErrorValue(const char *str) override;

    void BuildAstTree() override;
};

/**
 * 函数类型AST
 */
class FuncTypeAST : public BaseAST {
public:
    std::string type_;

    FuncTypeAST() = default;

    ~FuncTypeAST() override;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *ErrorValue(const char *str) override;

    void BuildAstTree() override;
};

/**
 * 函数定义AST
 */
class FuncDefAST : public BaseAST {
public:
//    UnitTpye type_;

    FuncType type_;

    std::string ident_;

    std::unique_ptr<BaseAST> func_type_;

    std::unique_ptr<BaseAST> block_;

    std::vector<std::unique_ptr<BaseAST>> param_lists_;

    FuncDefAST() = default;

    ~FuncDefAST() override;

    void Dump(int tab_num) const override;

    llvm::Value *CodeGen(IR &ir) override;

    llvm::Value *ErrorValue(const char *str) override;

    void AddParams(IR &ir, std::vector<std::string> &name_list);

    void BuildAstTree() override;
};

#endif //COMPILER_AST_H
