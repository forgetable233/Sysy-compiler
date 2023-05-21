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

/**
 * 以一个module为标准构建一个IR
 */

enum VariableType {
    kAtom,
    kArray
};

class IR {
private:

public:
    llvm::IRBuilder<> *builder_ = nullptr;

    std::unique_ptr<llvm::LLVMContext> context_;

    std::unique_ptr<llvm::Module> module_;

    std::map<std::string, std::map<std::string, llvm::Value *>> name_values_;

    std::map<std::string, llvm::Value *> global_values_;

    IR();

    explicit IR(std::string &name);

    void push_value(llvm::Value *value, const std::string &block_name, const std::string &value_name);

    void push_global_value(llvm::Value *value, const std::string &value_name);

    llvm::Value *get_global_value(const std::string &value_name);

    llvm::Value *get_basic_block_value(const std::string &block_name, const std::string &value_name);

    llvm::Value *
    get_value_check_type(const std::string &value_name, llvm::BasicBlock *current_block, VariableType type);

    llvm::Value *
    get_value(const std::string &value_name, const llvm::BasicBlock *current_block);

    ~IR();
};


#endif //COMPILER_LLVM_H
