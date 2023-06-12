%option noyywrap
%option nounput
%option noinput

%{

#include <cstdlib>
#include <string>
#include <vector>

// 因为 Flex 会用到 Bison 中关于 token 的定义
// 所以需要 include Bison 生成的头文件
#include "sysy.tab.hpp"
// #include "/home/dcr/codes/CLionProjects/compiler/src/base_ast.h"

using namespace std;

%}

/* 空白符和注释 */
WhiteSpace          [ \t\n\r]*
LineComment         "//".*

/* 标识符 */
Identifier    [a-zA-Z_][a-zA-Z0-9_]*

/* 整数字面量 */
Decimal       [1-9][0-9]*
Octal         0[0-7]*
Hexadecimal   0[xX][0-9a-fA-F]+

/* 运算符 */

%%

{WhiteSpace}            { /* 忽略, 不做任何操作 */ }
{LineComment}           { /* 忽略, 不做任何操作 */ }

"continue"      { return CONTINUE; }
"break"         { return BREAK; }
"if"            { return IF; }
"while"         { return WHILE; }
"int"           { return INT; }
"return"        { return RETURN; }
"double"        { return DOUBLE; }
"void"          { return VOID; }
"float"         { return FLOAT; }
"else"          { return ELSE; }
"true"          { return TRUE; }
"false"         { return FALSE; }
"static"        { return STATIC; }
"+"             { return ADD; }
"-"             { return SUB; }
"*"             { return MUL; }
"/"             { return DIV; }
"="             { return ASS; }
"=="            { return EQUAL; }
"&&"            { return AND; }
"!="            { return NOT_EQUAL; }
"||"            { return OR; }
">"             { return LARGER; }
">="            { return LARGER_EQUAL; }
"<"             { return LESS; }
"<="            { return LESS_EQUAL; }
"+="            { return ADD_ASSIGN; }
"-="            { return SUB_ASSIGN; }
"*="            { return MUL_ASSIGN; }
"/="            { return DIV_ASSIGN; }
"!"             { return NOT; }
"&"             { return AT; }
"%"             { return MOD; }

"("			    { return L_PAREN; }
")"			    { return R_PAREN; }
"["             { return L_BRACK; }
"]"             { return R_BRACK; }
"{"             { return L_BRACE; }
"}"             { return R_BRACE; }



{Identifier}    { yylval.str_val = new string(yytext); return IDENT; }

{Decimal}       { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }
{Octal}         { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }
{Hexadecimal}   { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }

.               { return yytext[0]; }

%%
