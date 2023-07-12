////
//// Created by dcr on 23-7-10.
////
//
//#include "SSABuilder.h"
////
////  SSABuilder.cpp
////  uscc
////
////  Implements SSABuilder class
////
////---------------------------------------------------------
////  Copyright (c) 2014, Sanjay Madhav
////  All rights reserved.
////
////  This file is distributed under the BSD license.
////  See LICENSE.TXT for details.
////---------------------------------------------------------
//
//#include "SSABuilder.h"
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wconversion"
//
//#include <llvm/IR/Value.h>
//#include <llvm/IR/Instructions.h>
//#include <llvm/IR/Function.h>
//#include <llvm/IR/DerivedTypes.h>
//#include <llvm/IR/Module.h>
//#include <llvm/IR/LLVMContext.h>
//#include <llvm/IR/BasicBlock.h>
//#include <llvm/IR/Constants.h>
//#include <llvm/IR/IRBuilder.h>
//#include <llvm/IR/CFG.h>
//#include <llvm/IR/Constants.h>
//
//#pragma clang diagnostic pop
//
//#include <list>
//
//using namespace uscc::opt;
//using namespace uscc::parse;
//using namespace llvm;
//
//// Called when a new function is started to clear out all the data
//void SSABuilder::reset() {
//    // PA4
//
//    // reset mVarDefs
//    for (auto varDef: mVarDefs) {
//        if (varDef.second) {
//            varDef.second->clear();
//        }
//    }
//    mVarDefs.clear();
//
//    // reset mIncompletePhis
//    for (auto incPhi: mIncompletePhis) {
//        if (incPhi.second) {
//            incPhi.second->clear();
//        }
//    }
//    mIncompletePhis.clear();
//
//    mSealedBlocks.clear();
//}
//
//// For a specific variable in a specific basic block, write its value
//void SSABuilder::writeVariable(Identifier *var, BasicBlock *block, Value *value) {
//    // PA4
//
//    (*(mVarDefs[block]))[var] = value;
//}
//
//// Read the value assigned to the variable in the requested basic block
//// Will recursively search predecessor blocks if it was not written in this block
//Value *SSABuilder::readVariable(Identifier *var, BasicBlock *block) {
//    // PA4
//
//    if (mVarDefs.find(block) != mVarDefs.end() && mVarDefs[block]->find(var) != mVarDefs[block]->end()) {
//        return (*(mVarDefs[block]))[var];
//    } else {
//        return readVariableRecursive(var, block);
//    }
//}
//
//// This is called to add a new block to the maps
//void SSABuilder::addBlock(BasicBlock *block, bool isSealed /* = false */) {
//    // PA4
//
//    mVarDefs[block] = new SubMap();
//    mIncompletePhis[block] = new SubPHI();
//    if (isSealed) {
//        sealBlock(block);
//    }
//}
//
//// This is called when a block is "sealed" which means it will not have any
//// further predecessors added. It will complete any PHI nodes (if necessary)
//void SSABuilder::sealBlock(llvm::BasicBlock *block) {
//    // PA4
//
//    for (auto &incPhi: *mIncompletePhis[block]) {
//        addPhiOperands(incPhi.first, incPhi.second);
//    }
//    mSealedBlocks.insert(block);
//}
//
//// Recursively search predecessor blocks for a variable
//Value *SSABuilder::readVariableRecursive(Identifier *var, BasicBlock *block) {
//    Value *retVal = nullptr;
//
//    // PA4
//
//    // if current block is not sealed, we create a phi node
//    if (mSealedBlocks.find(block) == mSealedBlocks.end()) {
//        PHINode *phiNode = nullptr;
//        if (block->empty()) {
//            phiNode = PHINode::Create(var->llvmType(), 0, "", block);
//        } else {
//            phiNode = PHINode::Create(var->llvmType(), 0, "", &(block->front()));
//        }
//
//        (*(mIncompletePhis[block]))[var] = phiNode;
//        retVal = phiNode;
//    }
//
//        // if sealed, and only one pred, we find it in pred
//    else if (block->getSinglePredecessor()) {
//        retVal = readVariable(var, block->getSinglePredecessor());
//    }
//
//        // if sealed, and multiple pred, we create a phi node using addPhiOperands
//    else {
//        PHINode *phiNode = nullptr;
//        if (block->empty()) {
//            phiNode = PHINode::Create(var->llvmType(), 0, "", block);
//        } else {
//            phiNode = PHINode::Create(var->llvmType(), 0, "", &(block->front()));
//        }
//        writeVariable(var, block, phiNode);
//        retVal = addPhiOperands(var, phiNode);
//    }
//
//    // write retVal and return
//    writeVariable(var, block, retVal);
//    return retVal;
//}
//
//// Adds phi operands based on predecessors of the containing block
//Value *SSABuilder::addPhiOperands(Identifier *var, PHINode *phi) {
//    // PA4
//
//    for (auto iter = pred_begin(phi->getParent()); iter != pred_end(phi->getParent()); iter++) {
//        phi->addIncoming(readVariable(var, *iter), *iter);
//    }
//
//    return tryRemoveTrivialPhi(phi);
//}
//
//// Removes trivial phi nodes
//Value *SSABuilder::tryRemoveTrivialPhi(llvm::PHINode *phi) {
//    Value *same = nullptr;
//
//    // PA4
//
//    // it is not trivial if it has different operands
//    for (int opIdx = 0; opIdx < phi->getNumIncomingValues(); opIdx++) {
//        auto op = phi->getIncomingValue(opIdx);
//        if (op == same || op == phi) {
//            continue;
//        }
//        if (same != nullptr) {
//            return phi;
//        }
//        same = op;
//    }
//
//    // The phi is unreachable or in the start block
//    if (same == nullptr) {
//        same = UndefValue::get(phi->getType());
//    }
//
//    // replace all uses of phi to same
//    phi->replaceAllUsesWith(same);
//    for (auto iter_vardef = mVarDefs.begin(); iter_vardef != mVarDefs.end(); iter_vardef++) {
//        auto submap = iter_vardef->second;
//        for (auto iter_submap = submap->begin(); iter_submap != submap->end(); iter_submap++) {
//            if (iter_submap->second == phi) {
//                iter_submap->second = same;
//            }
//        }
//    }
//
//    // remove phi inst from basic block
//    phi->eraseFromParent();
//
//    // recursively remove trivial phi inst
//    // in old version of LLVM, replaceAllUsesWith would not empty the use-def chain
//    for (auto use = phi->use_begin(); use != phi->use_end(); use++) {
//        if (isa<PHINode>(*use)) {
//            tryRemoveTrivialPhi(phi);
//        }
//    }
//
//    return same;
//}