//
// Created by dcr on 23-5-15.
//

#ifndef COMPILER_LLVM_H
#define COMPILER_LLVM_H

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
    BasicBlock(llvm::BasicBlock *_pre, llvm::BasicBlock *_curr) {
        pre = _pre;
        current = _curr;
    }

    llvm::BasicBlock *pre;
    llvm::BasicBlock *current;
};

class IR {
private:

public:
    bool is_function_call = false;

    llvm::IRBuilder<> *builder_ = nullptr;

    std::unique_ptr<llvm::LLVMContext> context_;

    std::unique_ptr<llvm::Module> module_;

    std::map<std::string, std::map<std::string, llvm::Value *>> name_values_;

    std::map<std::string, llvm::Value *> global_values_;

    std::vector<BasicBlock> blocks_;

    IR();

    explicit IR(std::string &name);

    void push_value(llvm::Value *value, const std::string &block_name, const std::string &value_name);

    void push_global_value(llvm::Value *value, const std::string &value_name);

    llvm::Value *get_global_value(const std::string &value_name);

    llvm::Value *get_basic_block_value(const std::string &block_name, const std::string &value_name);

    llvm::Value *
    get_value(const std::string &value_name, const llvm::BasicBlock *current_block);

    BasicBlock *
    get_block(const std::string &block_name);

    ~IR();
};


#endif //COMPILER_LLVM_H
