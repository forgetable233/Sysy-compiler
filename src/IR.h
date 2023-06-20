//
// Created by dcr on 23-5-15.
//

#ifndef COMPILER_IR_H
#define COMPILER_IR_H

#include <llvm/IR/Value.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/GlobalIFunc.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <memory>
#include <string>
#include <map>
#include <vector>
#include <llvm/Support/raw_os_ostream.h>
#include <llvm/IR/CFG.h>

/**
 * 以一个module为标准构建一个IR
 */

enum VariableType {
    kAtom,
    kArray
};

struct BasicBlock {
    BasicBlock(BasicBlock *_pre, llvm::BasicBlock *_curr) {
        pre_ = _pre;
        current_ = _curr;
    }

    BasicBlock() {
        pre_ = nullptr;
        current_ = nullptr;
    }

    BasicBlock *pre_ = nullptr;

    llvm::BasicBlock *current_ = nullptr;
};

class IR {
private:
    BasicBlock *current_block_ = nullptr;
public:
    BasicBlock *continue_block_ = nullptr;
    BasicBlock *break_block_ = nullptr;
    BasicBlock *exit_block_ = nullptr;
    BasicBlock *return_block_ = nullptr;

    bool is_function_call = false;

    llvm::IRBuilder<> *builder_ = nullptr;

    llvm::LLVMContext* context_;

    std::unique_ptr<llvm::Module> module_;

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

    llvm::Value *
    get_value(const std::string &value_name, const BasicBlock *current_block);

    ~IR();

    void SetCurrentBlock(BasicBlock *current_block);

    void DeleteUnusedIns();

    BasicBlock * GetCurrentBlock();
};


#endif //COMPILER_IR_H
