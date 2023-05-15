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

/**
 * 以一个module为标准构建一个IR
 */
class IR {

public:
    std::unique_ptr<llvm::LLVMContext> context_;

    std::unique_ptr<llvm::Module> module_;

    std::map<std::string, llvm::Value*> name_values_;

    IR();

    IR(std::string &name);

    ~IR() = default;
};


#endif //COMPILER_LLVM_H
