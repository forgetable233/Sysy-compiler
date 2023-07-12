////
//// Created by dcr on 23-7-12.
////
//
//#ifndef COMPILER_MYDCE_H
//#define COMPILER_MYDCE_H
//
//#include <llvm/Pass.h>
//#include <llvm/IR/Function.h>
//#include <llvm/Support/raw_os_ostream.h>
//
//#include <llvm/IR/LegacyPassManager.h>
//#include <llvm/Transforms/IPO.h>
//#include <llvm/Transforms/IPO/PassManagerBuilder.h>
//
//namespace {
//    struct MyDeadCodeEliminationPass : public llvm::FunctionPass {
//        static char ID;
//
//        MyDeadCodeEliminationPass() : llvm::FunctionPass(ID) {}
//
//        bool isInstructionDead(llvm::Instruction *I) {
//            return I->use_empty();
//        }
//
//        bool runOnFunction(llvm::Function &F) override {
//            bool modified = false;
//            for (auto &BB: F) {
//                for (auto &ins: BB) {
//                    if (isInstructionDead(&ins)) {
//                        ins.eraseFromParent();
//                        modified = true;
//                    }
//                }
//            }
//            return modified;
//        }
//    };
//}
//
//char MyDeadCodeEliminationPass::ID = 0;
//static llvm::RegisterPass<MyDeadCodeEliminationPass> X("MyDCEPass", "Hello My Pass", false, false);
//static llvm::RegisterStandardPasses Y(
//        llvm::PassManagerBuilder::EP_EarlyAsPossible,
//        [](const llvm::PassManagerBuilder &builder,
//           llvm::legacy::PassManagerBase &PM) {
//            PM.add(new MyDeadCodeEliminationPass());
//        }
//);
//
//#endif //COMPILER_MYDCE_H
