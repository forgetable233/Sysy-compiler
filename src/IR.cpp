//
// Created by dcr on 23-5-15.
//

#include <llvm/IR/Verifier.h>
#include <llvm/Target/TargetOptions.h>
#include <llvm/IR/LegacyPassManager.h>
#include "IR.h"

IR::IR() {
    context_ = new llvm::LLVMContext();
//    module_ =  new llvm::Module("default", *context_);
}

IR::IR(std::string &name) {
    context_ = new llvm::LLVMContext();
//    module_ =  new llvm::Module(name, *context_);
    builder_ = new llvm::IRBuilder<>(*context_);
}

IR::~IR() {
    module_.reset(nullptr);
//    delete builder_;
}

void IR::push_value(llvm::Value *value, const std::string &block_name, const std::string &ident) {
    auto tar_block = name_values_.find(block_name);
    if (tar_block == name_values_.end()) {
        std::map<std::string, llvm::Value *> tar_value;
        tar_value.insert(std::pair<std::string, llvm::Value *>(ident, value));
        name_values_.insert(std::pair<std::string, std::map<std::string, llvm::Value *>>(block_name, tar_value));
    } else {
        tar_block->second.insert(std::pair<std::string, llvm::Value *>(ident, value));
    }
}

llvm::Value *IR::get_basic_block_value(const std::string &block_name, const std::string &value_name) {
    auto block = name_values_.find(block_name);
    if (block == name_values_.end()) {
        return nullptr;
    }
    auto value = block->second.find(value_name);
    if (value == block->second.end()) {
        return nullptr;
    }
    return value->second;
}

void IR::push_global_value(llvm::Value *value, const std::string &value_name) {
    global_values_.insert(std::pair<std::string, llvm::Value *>(value_name, value));
}

llvm::Value *IR::get_global_value(const std::string &value_name) {
//    for (auto &item: name_values_) {
//        for (auto &value: item.second) {
//            value.second->getType()->print(llvm::outs(), true);
//            llvm::outs() << '\n';
//        }
//    }

    auto tar_value = global_values_.find(value_name);
    if (tar_value == global_values_.end()) {
        return nullptr;
    }
    return tar_value->second;
}

llvm::Value *
IR::get_value(const std::string &value_name, const BasicBlock *current_block) {
    llvm::Value *value = nullptr;
    std::string block_name;
    if (current_block) {
        // 先从各个block中寻找
        for (auto temp = current_block; temp; temp = temp->pre_) {
            block_name = temp->current_->getParent()->getName().str();
            block_name += temp->current_->getName().str();
            value = this->get_basic_block_value(block_name, value_name);
            if (value) {
                return value;
            }
        }
        int i = 0;
//        llvm::outs() << '\n';

        // 从函数列表中寻找
        for (auto arg = current_block->current_->getParent()->arg_begin();
             arg != current_block->current_->getParent()->arg_end(); ++arg, ++i) {
            if (strcmp(arg->getName().str().c_str(), value_name.c_str()) == 0) {
                for (auto temp = current_block; temp; temp = temp->pre_) {
                    block_name = temp->current_->getParent()->getName().str();
                    block_name += temp->current_->getName().str();
                    value = this->get_basic_block_value(block_name, std::to_string(i));
                    if (value) {
                        return value;
                    }
                }
            }
        }
    }
    value = this->get_global_value(value_name);
    return value;
}

BasicBlock *IR::GetCurrentBlock() {
    return current_block_;
}

void IR::SetCurrentBlock(BasicBlock *current_block) {
    current_block_ = current_block;
    builder_->SetInsertPoint(current_block->current_);
}

void IR::DeleteUnusedIns() {
    bool haveEnd = false;
    for (llvm::Function &function: module_->getFunctionList()) {
        for (llvm::BasicBlock &basicBlock: function.getBasicBlockList()) {
            haveEnd = false;
            for (llvm::Instruction &instruction: basicBlock.getInstList()) {
                if (haveEnd) {
                    basicBlock.getInstList().erase(instruction);
                }
                if (instruction.getOpcode() == llvm::Instruction::Ret ||
                    instruction.getOpcode() == llvm::Instruction::Br) {
                    haveEnd = true;
                }
            }
        }
    }
}

//void IR::GenObj(std::string &input_file_name) {
//    if (llvm::verifyModule(*module_, &llvm::errs())) {
//        llvm::errs() << "Error: Invalid module\n";
//        exit(2);
//    }
//    llvm::InitializeAllTargetInfos();
//    llvm::InitializeAllTargets();
//    llvm::InitializeAllTargetMCs();
//    llvm::InitializeAllAsmParsers();
//    llvm::InitializeAllAsmPrinters();
//    std::string obj_file = "../outs/objs/";
//    obj_file += input_file_name;
//
//    std::string targetTriple = llvm::sys::getHostCPUName();
//    std::string errorString;
//    const llvm::Target *target = llvm::TargetRegistry::lookupTarget(targetTriple, errorString);
//    if (!target) {
//        llvm::errs() << "failed to lookup target: " << errorString << '\n';
//        exit(2);
//    }
//
//    llvm::TargetOptions targetOptions;
//    llvm::TargetMachine *targetMachine = target->createTargetMachine(targetTriple, "", "", targetOptions, llvm::None);
//
//    llvm::MCContext mcContext = llvm::MCContext(nullptr, nullptr, nullptr);
//    llvm::MCSubtargetInfo *subtargetInfo = target->createMCSubtargetInfo(targetTriple, "x86_64", "");
//    llvm::MCRegisterInfo *registerInfo = target->createMCRegInfo("");
//    llvm::MCTargetOptions *options = new llvm::MCTargetOptions();
//
//    //    llvm::MCStreamer *mcStreamer = llvm::MCStreamer::c
//    std::error_code errorCode;
//    llvm::raw_fd_ostream outputFile(obj_file, errorCode, llvm::sys::fs::OF_None);
//    if (errorCode) {
//        llvm::errs() << "Failed to open output file: " << errorCode.message() << '\n';
//        exit(2);
//    }
//
//    const llvm::MCAsmInfo *asmInfo = targetMachine->getMCAsmInfo();
//    const llvm::MCAsmBackend *asmBackend = target->createMCAsmBackend(*subtargetInfo, *registerInfo, *options);
//    llvm::MCStreamer *mcStreamer = llvm::createAsmStreamer(mcContext, outputFile, nullptr, false, false);
//
//
//    llvm::legacy::PassManager passManager;
//    targetMachine->addPassesToEmitFile(passManager, mcStreamer, nullptr, llvm::CGFT_ObjectFile);
//    passManager.run(*module_);
//    mcStreamer.Finish();
//
//    outputFile.flush();
//    outputFile.close();
//}

