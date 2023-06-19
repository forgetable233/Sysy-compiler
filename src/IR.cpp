//
// Created by dcr on 23-5-15.
//

#include "IR.h"

IR::IR() {
    context_ = new llvm::LLVMContext();
//    module_ =  new llvm::Module("default", *context_);
}

IR::IR(std::string &name) {
    context_ = new llvm::LLVMContext();
//    module_ =  new llvm::Module(name, *context_);
    builder_ = new llvm::IRBuilder<>(*context_);
}

IR::~IR() {
    delete builder_;
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
//    for (auto &item: name_values_) {
//        for (auto &value: item.second) {
//            value.second->getType()->print(llvm::outs(), true);
//            llvm::outs() << '\n';
//        }
//    }

    auto tar_value = global_values_.find(value_name);
    if (tar_value == global_values_.end()) {
        return nullptr;
    }
    return tar_value->second;
}

llvm::Value *
IR::get_value(const std::string &value_name, const BasicBlock *current_block) {
    llvm::Value *value = nullptr;
    std::string block_name;
    if (current_block) {
        // 先从各个block中寻找
        for (auto temp = current_block; temp; temp = temp->pre_) {
            block_name = temp->current_->getParent()->getName().str();
            block_name += temp->current_->getName().str();
            value = this->get_basic_block_value(block_name, value_name);
            if (value) {
                return value;
            }
        }
        int i = 0;
//        llvm::outs() << '\n';

        // 从函数列表中寻找
        for (auto arg = current_block->current_->getParent()->arg_begin();
             arg != current_block->current_->getParent()->arg_end(); ++arg, ++i) {
            if (strcmp(arg->getName().str().c_str(), value_name.c_str()) == 0) {
                for (auto temp = current_block; temp; temp = temp->pre_) {
                    block_name = temp->current_->getParent()->getName().str();
                    block_name += temp->current_->getName().str();
                    value = this->get_basic_block_value(block_name, std::to_string(i));
                    if (value) {
                        return value;
                    }
                }
            }
        }
    }
    value = this->get_global_value(value_name);
    return value;
}

BasicBlock *IR::GetCurrentBlock() {
    return current_block_;
}

void IR::SetCurrentBlock(BasicBlock *current_block) {
    current_block_ = current_block;
    builder_->SetInsertPoint(current_block->current_);
}

