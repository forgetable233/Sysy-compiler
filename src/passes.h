//
// Created by dcr on 23-7-10.
//

#ifndef COMPILER_PASSES_H
#define COMPILER_PASSES_H
#pragma once
#include <llvm/Pass.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Analysis/LoopPass.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Dominators.h>
#include <llvm/Transforms/Scalar/LoopPassManager.h>
#include <llvm/Transforms/Scalar/DeadStoreElimination.h>
#include <llvm/Transforms/Scalar/DCE.h>
#include <llvm/Transforms/Scalar.h>
#include "IR.h"

class Passes {
public:
    Passes() = default;


    static void Optimizer(IR &ir);

    static void LoopOptimizer(IR &ir);

    static void DeadCodeDelete(IR &ir);

    static void InsCombine(IR &ir);
};

#endif //COMPILER_PASSES_H
