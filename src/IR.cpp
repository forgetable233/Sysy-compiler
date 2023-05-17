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
}

IR::~IR() {
    context_.reset();
    module_.reset();
}

void IR::push_value(llvm::Value *value, std::string block_name) {
    auto tar_block = name_values_.find(block_name);
    if (tar_block == name_values_.end()) {
        std::map<std::string, llvm::Value*> tar_value;
        tar_value.insert(std::pair<std::string, llvm::Value*>(value->getName(), value));
        name_values_.insert(std::pair<std::string, std::map<std::string, llvm::Value*>>(block_name, tar_value));
    } else {
        tar_block->second.insert(std::pair<std::string, llvm::Value*>(value->getName(), value));
    }
}

llvm::Value *IR::get_value(std::string block_name, std::string value_name) {
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
