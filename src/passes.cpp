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
    passManager.run(*ir.module_);
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
    passManager.run(*ir.module_);
}

void Passes::InsCombine(IR &ir) {
    llvm::legacy::PassManager passManager;

}

void Passes::ConvertToSSA(IR &ir) {
    llvm::legacy::PassManager passManager;
    passManager.add(llvm::createPromoteMemoryToRegisterPass());
    passManager.run(*ir.module_);
}

void Passes::MyDCE(IR &ir) {
    bool modified = false;
    std::stack<llvm::Instruction*> deadIns;
    for (auto &F : ir.module_->getFunctionList()) {
        for (auto &block : F.getBasicBlockList()) {
            for (auto &ins : block.getInstList()) {
                if (isDeadIns(ins)) {
                    deadIns.push(&ins);
                    modified = true;
                }
            }
        }
        while (!deadIns.empty()) {
            auto ins = deadIns.top();
            ins->eraseFromParent();
            deadIns.pop();
        }
    }
    if (modified) {
        llvm::outs() << "modified\n";
    } else {
        llvm::outs() << "not modified\n";
    }
}

bool Passes::isDeadIns(llvm::Instruction &ins) {
    if (!ins.hasNUses(0)) {
        return false;
    }
    if (ins.mayHaveSideEffects()) {
        return false;
    }
    if (llvm::isa<llvm::BranchInst>(ins) || llvm::isa<llvm::SwitchInst>(ins)) {
        return false;
    }
    if (llvm::isa<llvm::StoreInst>(ins)) {
        return false;
    }
    return ins.isEHPad() || ins.isTerminator();
}

void Passes::isLiveIns(IR &ir) {

//    llvm::LibFunc.
}
