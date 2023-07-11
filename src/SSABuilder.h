////
//// Created by dcr on 23-7-10.
////
//
//#ifndef COMPILER_SSABUILDER_H
//#define COMPILER_SSABUILDER_H
//
//
////
////  SSABuilder.h
////  uscc
////
////  Declares SSABuilder which manages construction
////  of SSA form
////
////---------------------------------------------------------
////  Copyright (c) 2014, Sanjay Madhav
////  All rights reserved.
////
////  This file is distributed under the BSD license.
////  See LICENSE.TXT for details.
////---------------------------------------------------------
//
//#pragma once
//
//#include <unordered_map>
//#include <unordered_set>
//
//// LLVM forward-declarations
//namespace llvm {
//    class BasicBlock;
//
//    class Value;
//
//    class PHINode;
//}
//
//namespace uscc {
//    namespace parse {
//        class Identifier;
//    }
//
//    namespace opt {
//
//// This class implements the algorithm outlined in
//// "Simple and Efficient Construction of SSA Form"
//// (Braun et. al.)
//
//        class SSABuilder {
//        public:
//            // Called when a new function is started to clear out all the data
//            void reset();
//
//            // For a specific variable in a specific basic block, write its value
//            void writeVariable(parse::Identifier *var, llvm::BasicBlock *block, llvm::Value *value);
//
//            // Read the value assigned to the variable in the requested basic block
//            // Will recursively search predecessor blocks if it was not written in this block
//            llvm::Value *readVariable(parse::Identifier *var, llvm::BasicBlock *block);
//
//            // This is called to add a new block to the maps
//            // If the block is sealed, will automatically call "seal block" on it
//            void addBlock(llvm::BasicBlock *block, bool isSealed = false);
//
//            // This is called when a block is "sealed" which means it will not have any
//            // further predecessors added. It will complete any PHI nodes (if necessary)
//            void sealBlock(llvm::BasicBlock *block);
//
//        private:
//            // Helper functions
//
//            // Recursively search predecessor blocks for a variable
//            llvm::Value *readVariableRecursive(parse::Identifier *var, llvm::BasicBlock *block);
//
//            // Adds phi operands based on predecessors of the containing block
//            llvm::Value *addPhiOperands(parse::Identifier *var, llvm::PHINode *phi);
//
//            // Removes trivial phi nodes
//            llvm::Value *tryRemoveTrivialPhi(llvm::PHINode *phi);
//
//            typedef std::unordered_map<parse::Identifier *, llvm::Value *> SubMap;
//            typedef std::unordered_map<parse::Identifier *, llvm::PHINode *> SubPHI;
//
//            // This stores the variable definitions for a particular basic block
//            std::unordered_map<llvm::BasicBlock *, SubMap *> mVarDefs;
//
//            // This stores any incomplete PHI nodes
//            std::unordered_map<llvm::BasicBlock *, SubPHI *> mIncompletePhis;
//
//            // Set of all the sealed blocks in the current function
//            std::unordered_set<llvm::BasicBlock *> mSealedBlocks;
//        };
//
//    } // opt
//} // uscc
//
//#endif //COMPILER_SSABUILDER_H
