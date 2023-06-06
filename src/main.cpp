#include <cassert>
#include <cstdio>
#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include <llvm/Support/raw_ostream.h>

#include "ast.h"


using namespace std;

// 声明 lexer 的输入, 以及 parser 函数
// 为什么不引用 sysy.tab.hpp 呢? 因为首先里面没有 yyin 的定义
// 其次, 因为这个文件不是我们自己写的, 而是被 Bison 生成出来的
// 你的代码编辑器/IDE 很可能找不到这个文件, 然后会给你报错 (虽然编译不会出错)
// 看起来会很烦人, 于是干脆采用这种看起来 dirty 但实际很有效的手段
extern FILE *yyin;
extern int yyparse(unique_ptr<BaseAST> &ast);

int main(int argc, const char *argv[]) {
    std::string ir_name = "top";
    IR ir(ir_name);
//    assert(argc == 5);
//    auto mode = argv[1];
//    auto input = argv[2];
    auto input = "../hello.c";
//    auto output = argv[4];
    // 打开输入文件, 并且指定 lexer 在解析的时候读取这个文件
    yyin = fopen(input, "r");
    assert(yyin);

    // 调用 parser 函数, parser 函数会进一步调用 lexer 解析输入文件的
    // 下面为测试模块
    unique_ptr<BaseAST> ast;
//    auto unit = (CompUnitAST*)(&(*ast));
    auto ret = yyparse(ast);
    assert(!ret);
//    ast->Dump(0);
    ast->BuildAstTree();

    ast->CodeGen(ir);
    std::cout << std::endl <<  "finish CodeGen" << std::endl;
    ir.module_->print(llvm::outs(), nullptr);
    return 0;
}
