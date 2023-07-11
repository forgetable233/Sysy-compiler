//
// Created by dcr on 23-7-10.
//

#include "passes.h"

void Passes::Optimizer(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createDeadInstEliminationPass());
    passManager.add(llvm::createMergeICmpsLegacyPass());
    passManager.add(llvm::createSCCPPass());
    passManager.add(llvm::createDeadCodeEliminationPass());
}

void Passes::LoopOptimizer(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createLoopUnrollPass());
    passManager.add(llvm::createLoopVersioningLICMPass());
    passManager.run(*ir.module_);
}

void Passes::DeadCodeDelete(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createCFGSimplificationPass());
    passManager.add(llvm::createDeadInstEliminationPass());
    bool changed = passManager.run(*ir.module_);
//    if (changed) {
//        llvm::outs() << "changed!!!\n";
//    } else {
//        llvm::outs() << "not changed???\n";
//    }
}

void Passes::InsCombine(IR &ir) {
    llvm::legacy::PassManager passManager;

}

void Passes::ConvertToSSA(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createPromoteMemoryToRegisterPass());
    passManager.run(*ir.module_);
}
