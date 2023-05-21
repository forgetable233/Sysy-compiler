//
// Created by dcr on 23-5-15.
//

#include "IR.h"

IR::IR() {
    context_ = std::make_unique<llvm::LLVMContext>();
    module_ = std::make_unique<llvm::Module>("default", *context_);
}

IR::IR(std::string &name) {
    context_ = std::make_unique<llvm::LLVMContext>();
    module_ = std::make_unique<llvm::Module>(name, *context_);
    builder_ = new llvm::IRBuilder<>(module_->getContext());
}

IR::~IR() {
    context_.reset();
    module_.reset();
}

void IR::push_value(llvm::Value *value, const std::string &block_name, const std::string &value_name) {
    auto tar_block = name_values_.find(block_name);
    if (tar_block == name_values_.end()) {
        std::map<std::string, llvm::Value *> tar_value;
        tar_value.insert(std::pair<std::string, llvm::Value *>(value_name, value));
        name_values_.insert(std::pair<std::string, std::map<std::string, llvm::Value *>>(block_name, tar_value));
    } else {
        tar_block->second.insert(std::pair<std::string, llvm::Value *>(value_name, value));
    }
}

llvm::Value *IR::get_basic_block_value(const std::string &block_name, const std::string &value_name) {
    auto block = name_values_.find(block_name);
    if (block == name_values_.end()) {
        return nullptr;
    }
    auto value = block->second.find(value_name);
    if (value == block->second.end()) {
        return nullptr;
    }
    return value->second;
}

void IR::push_global_value(llvm::Value *value, const std::string &value_name) {
    global_values_.insert(std::pair<std::string, llvm::Value *>(value_name, value));
}

llvm::Value *IR::get_global_value(const std::string &value_name) {
    auto tar_value = global_values_.find(value_name);
    if (tar_value == global_values_.end()) {
        return nullptr;
    }
    return tar_value->second;
}


llvm::Value *
IR::get_value(const std::string &value_name, const llvm::BasicBlock *current_block) {
    llvm::Value *value = nullptr;
    if (current_block) {
        for (auto temp_block = current_block; temp_block; temp_block = current_block->getPrevNode()) {
            value = this->get_basic_block_value(temp_block->getName().str(), value_name);
            if (value) {
                return value;
            }
        }
        for (auto arg = current_block->getParent()->arg_begin(); arg != current_block->getParent()->arg_end(); ++arg) {
            if (strcmp(arg->getName().str().c_str(), value_name.c_str()) == 0) {
                value = (llvm::Value * ) & (*arg);
                return value;
            }
        }
    }
    return this->get_global_value(value_name);
}

llvm::Value *
IR::get_value_check_type(const std::string &value_name, llvm::BasicBlock *current_block, VariableType type) {
    llvm::Value *value = this->get_value(value_name, current_block);
    if (!value) {
        llvm::report_fatal_error("The variable has not been declared\n");
    }
    if (llvm::dyn_cast<llvm::ArrayType>(value->getType()->getPointerElementType()) && type == kAtom) {
        llvm::report_fatal_error("The type of the input variable dose not match\n");
    }
    return value;
}

