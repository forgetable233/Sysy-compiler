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
//    for (const auto& item1 : name_values_) {
//        for (const auto& item2 : item1.second) {
//            llvm::outs() << item2.second << '\n';
//        }
//    }
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
IR::get_value(const std::string &value_name, const BasicBlock *current_block) {
    llvm::Value *value = nullptr;
    if (current_block) {
        // 先从各个block中寻找
        for (auto temp = current_block; temp; temp = temp->pre) {
            auto block = temp->current;
            llvm::outs() << block->getName() << '\n';
            value = this->get_basic_block_value(block->getName().str(), value_name);
            if (value) {
                return value;
            }
        }
        int i = 0;
        llvm::outs() << '\n';

        // 从函数列表中寻找
        for (auto arg = current_block->current->getParent()->arg_begin();
             arg != current_block->current->getParent()->arg_end(); ++arg, ++i) {
            if (strcmp(arg->getName().str().c_str(), value_name.c_str()) == 0) {
                value = (llvm::Value *) arg;
                return value;
            }
        }
    }
    value = this->get_global_value(value_name);
    return value;
}

