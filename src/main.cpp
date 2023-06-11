#include <cassert>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include <llvm/Support/raw_ostream.h>
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
    std::string file(file_name, 0, file_name.length() - 2);
    file += "ll";
    std::error_code EC;
    llvm::raw_fd_ostream output(llvm::StringRef(file), EC);

    if (EC) {
        llvm::errs() << "unable to open the tar file: " << EC.message() << '\n';
        return false;
    }
    ir.module_->print(output, nullptr);
    output.flush();
    output.close();
    return true;
}

int main(int argc, const char *argv[]) {
    std::string test_folder_name = "../function_test2020/";
    std::string ir_name = "top";
    IR ir(ir_name);
    auto input = argv[1];
//    auto input = "../tests/10_break.sy";
    std::string test_hello = "../hello.c";
    std::string file_path = input;
    std::string input_file_name(file_path, 9, file_path.length());
    std::cout << input_file_name;
    // 打开输入文件, 并且指定 lexer 在解析的时候读取这个文件
    yyin = fopen(file_path.c_str(), "r");
//    yyin = fopen(test_hello.c_str(), "r");
//    std::cout << test_hello << endl;
    std::cout << "open succeed\n";
    assert(yyin);

    // 调用 parser 函数, parser 函数会进一步调用 lexer 解析输入文件的
    // 下面为测试模块
    unique_ptr<BaseAST> ast;
    auto ret = yyparse(ast);
    if (ret) {
        return -1;
    }
    assert(!ret);
//    ast->Dump(0);
    ast->BuildAstTree();
    std::cout << "Finish AST Tree build\n";
    ast->CodeGen(ir);
    std::cout << std::endl <<  "finish CodeGen" << std::endl;

    if (store_file(ir, input_file_name)) {
        std::cout << "successfully store a file\n";
    } else {
        std::cerr << "unable to store the target file\n";
    }
//    ir.module_->print(llvm::outs(), nullptr);
    return 0;
}
