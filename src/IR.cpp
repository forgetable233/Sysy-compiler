//
// Created by dcr on 23-5-15.
//

#include "IR.h"

IR::IR() {
    module_ = std::make_unique<llvm::Module>("default", *context_);
}

IR::IR(std::string &name) {
    module_ = std::make_unique<llvm::Module>(name, *context_);
}
