//
// Created by dcr on 23-5-15.
//

#include "IR.h"

IR::IR() {
    context_ = std::make_shared<llvm::LLVMContext>();
    module_ = std::make_shared<llvm::Module>("default", *context_);
}

IR::IR(std::string &name) {
    context_ = std::make_shared<llvm::LLVMContext>();
    module_ = std::make_shared<llvm::Module>(name, *context_);
}

IR::~IR() {
    module_.reset();
    context_.reset();
}
