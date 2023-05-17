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
