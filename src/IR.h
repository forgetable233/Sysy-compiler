//
// Created by dcr on 23-5-15.
//

#ifndef COMPILER_IR_H
#define COMPILER_IR_H


#include <memory>
#include <string>
#include <map>
#include <utility>
#include <vector>
#include <stack>
#include <queue>
#include <deque>
#include <llvm/IR/Value.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/GlobalIFunc.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/CFG.h>
#include <llvm/IR/Verifier.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/Support/raw_os_ostream.h>
#include <llvm/Support/TargetRegistry.h>
#include <llvm/Support/TarWriter.h>
#include <llvm/Support/TargetParser.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/FileCheck.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/raw_os_ostream.h>
#include <llvm/Support/CodeGen.h>
#include <llvm/ADT/Triple.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/ExecutionEngine/GenericValue.h>

/**
 * 以一个module为标准构建一个IR
 */

enum VariableType {
    kAtom,
    kArray
};

struct BasicBlock {
    BasicBlock(BasicBlock *_pre, llvm::BasicBlock *_curr, int block_id) {
        pre_ = _pre;
        current_ = _curr;
        block_id_ = block_id;
    }

    BasicBlock() {
        pre_ = nullptr;
        current_ = nullptr;
        block_id_ = -1;
    }

    BasicBlock *pre_ = nullptr;

    llvm::BasicBlock *current_ = nullptr;

    int block_id_ = -1;
};

struct Value {
    Value(llvm::Value *_value, int id, std::string value_name) {
        value_ = _value;
        block_id_ = id;
        value_name_ = std::move(value_name);
    }

    Value() {
        value_ = nullptr;
        block_id_ = -1;
        value_name_ = "";
    }
    llvm::Value *value_;

    int block_id_;

    std::string value_name_;
};

struct FuncParams {
    explicit FuncParams(std::string func_name) {
        func_name_ = std::move(func_name);
    }

    FuncParams() {
        func_name_ = "";
    }

    std::deque<Value> values_;
    std::string func_name_;
};

class IR {
private:
    BasicBlock *current_block_ = nullptr;

    std::vector<FuncParams> params_;
public:
    BasicBlock *continue_block_ = nullptr;
    BasicBlock *break_block_ = nullptr;
    BasicBlock *exit_block_ = nullptr;
    BasicBlock *return_block_ = nullptr;

    bool is_function_call = false;

    llvm::IRBuilder<> *builder_ = nullptr;

    llvm::LLVMContext *context_;

    std::unique_ptr<llvm::Module> module_;

//    std::stack<>

    std::map<std::string, std::map<std::string, llvm::Value *>> name_values_;

    std::map<std::string, std::map<std::string, std::string>> name_ident_;

    std::map<std::string, llvm::Value *> global_values_;

    std::vector<BasicBlock> blocks_;

    IR();

    explicit IR(std::string &name);

    void push_value(llvm::Value *value, const std::string &block_name, const std::string &ident);

    void push_global_value(llvm::Value *value, const std::string &value_name);

    llvm::Value *get_global_value(const std::string &value_name);

    llvm::Value *get_basic_block_value(const std::string &block_name, const std::string &value_name);

//    llvm::Value *
//    get_value(const std::string &value_name, const BasicBlock *current_block);

    ~IR();

    void SetCurrentBlock(BasicBlock *current_block);

    void DeleteUnusedIns();

    BasicBlock *GetCurrentBlock();

    void GenObj(std::string &input_file_name);

    void push_value(llvm::Value *value, std::string &value_name, std::string &func_name, int block_id);

    void pop_value(std::string &func_name, int block_id);

    llvm::Value *get_value(std::string &func_name, std::string &ident_name);
};


#endif //COMPILER_IR_H
