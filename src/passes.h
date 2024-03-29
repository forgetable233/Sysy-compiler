//
// Created by dcr on 23-7-10.
//

#ifndef COMPILER_PASSES_H
#define COMPILER_PASSES_H
#pragma once

#include <map>
#include <llvm/ADT/DenseMap.h>
#include <algorithm>
#include <llvm/Pass.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/MemorySSA.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IR/IRPrintingPasses.h>
#include <llvm/PassRegistry.h>
#include <llvm/Pass.h>
#include <llvm/IR/CFG.h>
#include <llvm/Transforms/Scalar/LoopPassManager.h>
#include <llvm/Transforms/Scalar/DeadStoreElimination.h>
#include <llvm/Transforms/Scalar/DCE.h>
#include <llvm/Transforms/Scalar/MemCpyOptimizer.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils/PromoteMemToReg.h>
#include <llvm/Transforms/Utils/Mem2Reg.h>
#include <llvm/Transforms/Utils.h>
#include <llvm/Transforms/Utils/SSAUpdater.h>
#include <llvm/Transforms/Utils/SSAUpdaterBulk.h>
#include <llvm/Transforms/Utils/SSAUpdaterImpl.h>
#include <llvm/ADT/SmallPtrSet.h>

#include "IR.h"
//#include "MyDCE.h"

struct OpTreeNode {
    OpTreeNode(llvm::Value *_op, llvm::Instruction *_ins) {
        op = _op;
        ins = _ins;
        preNode = nullptr;
    }

    llvm::Value *op;

    llvm::Instruction *ins;

    OpTreeNode *preNode;
};

struct New_Value {
    New_Value(llvm::Value *_value, llvm::BasicBlock *_block) {
        value_ = _value;
        block_ = _block;
    }

    New_Value() {
        value_ = nullptr;

        block_ = nullptr;
    }

    llvm::Value *value_;

    llvm::BasicBlock *block_;
};

class Passes {
public:
    Passes() = default;

    static void Optimizer(IR &ir);

    static void LoopOptimizer(IR &ir);

    static void DeadCodeDelete(IR &ir);

    static void InsCombine(IR &ir);

    static void ConvertToSSA(IR &ir);

    static void MyDCE(IR &ir);

    static bool isDeadIns(llvm::Instruction &ins);

    static void isLiveIns(IR &ir);

    static void Constant(IR &ir);

    static void StrengthReduction(IR &ir);

    static void DEC(IR &ir);

    static void MySSA(IR &ir);
};


#endif //COMPILER_PASSES_H
