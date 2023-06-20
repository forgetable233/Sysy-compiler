#include <cassert>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include <llvm/Support/raw_ostream.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Linker/Linker.h>
#include <iostream>
#include <fstream>

#include "ast.h"

// TODO 完成多个变量的声明以及定义
// TODO 重新组织param_list
using namespace std;

// 声明 lexer 的输入, 以及 parser 函数
// 为什么不引用 sysy.tab.hpp 呢? 因为首先里面没有 yyin 的定义
// 其次, 因为这个文件不是我们自己写的, 而是被 Bison 生成出来的
// 你的代码编辑器/IDE 很可能找不到这个文件, 然后会给你报错 (虽然编译不会出错)
// 看起来会很烦人, 于是干脆采用这种看起来 dirty 但实际很有效的手段
extern FILE *yyin;

extern int yyparse(unique_ptr<BaseAST> &ast);

bool store_file(IR &ir, std::string &file_name) {
    std::string ll_file_path = "../outs/ll/";
    std::string file(file_name, 0, file_name.length() - 2);
    file += "ll";
    ll_file_path += file;
    std::error_code EC;
    llvm::raw_fd_ostream output(llvm::StringRef(ll_file_path), EC);

    if (EC) {
        llvm::errs() << "unable to open the tar file: " << EC.message() << '\n';
        exit(-1);
    }
    ir.module_->print(output, nullptr);
    output.flush();
    output.close();
    ir.module_->print(llvm::outs(), nullptr);
    exit(0);
}

void InitSylib(IR &ir) {
    std::string path = "../lib/sylib.ll";
    llvm::SMDiagnostic error;
    ir.module_ = llvm::parseIRFile(path, error, *ir.context_);
    if (!ir.module_) {
        llvm::errs() << "Unable to find the target file\n";
        error.print("IR Reader", llvm::errs());
        exit(-1);
    }
}

int main(int argc, const char *argv[]) {
    std::string ir_name = "top";
    IR ir(ir_name);
    InitSylib(ir);
    auto input = "../tests/10_if_else.sy";
//    auto input = argv[1];
    std::string test_hello = "../hello.c";
    std::string file_path = input;
//    std::string file_path = "../hello.c";
    std::string input_file_name(file_path, 9, file_path.length());

    // 打开文件
//    yyin = fopen(file_path.c_str(), "r");
    yyin = fopen(test_hello.c_str(), "r");
    assert(yyin);

    unique_ptr<BaseAST> ast;
    auto ret = yyparse(ast);
    if (ret) {
        return -1;
    }
    ast->BuildAstTree();
    ast->CodeGen(ir);
    ir.module_->print(llvm::outs(), nullptr);
//    store_file(ir, input_file_name);
}
