%code requires {
  #include <memory>
  #include <string>
  #include <vector>
  #include "../src/ast.h"
  #inclue <iostream>
}

%{
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#include "../src/ast.h"

// 声明 lexer 函数和错误处理函数
int yylex();
void yyerror(std::unique_ptr<BaseAST> &ast, const char *s);

using namespace std;

%}

// 定义 parser 函数和错误处理函数的附加参数
// 这里返回一个自己定义的Ast作为参数
// 解析完成后, 我们要手动修改这个参数, 把它设置成解析得到的字符串
// 这里是parser的输入参数类型
%parse-param { std::unique_ptr<BaseAST> &ast }

// yylval 的定义, 我们把它定义成了一个联合体 (union)
// 因为 token 的值有的是字符串指针, 有的是整数
// 之前我们在 lexer 中用到的 str_val 和 int_val 就是在这里被定义的
// 至于为什么要用字符串指针而不直接用 string 或者 unique_ptr<string>
%union {
  std::string *str_val;
  int int_val;
  BaseAST *ast_val;
  std::vector<std::unique_ptr<BaseAST>> *ast_list;
}

// lexer 返回的所有 token 种类的声明
// 新添加了ast_token
// 终结符类型定义
%token RETURN
%token <str_val> IDENT INT VOID DOUBLE FLOAT ADD SUB MUL DIV ASS STATIC CONTINUE BREAK CONST
%token <str_val> EQUAL NOT_EQUAL AND OR LESS LESS_EQUAL LARGER LARGER_EQUAL
%token <str_val> ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN NOT MOD
%token <str_val> IF WHILE ELSE TRUE FALSE AT
%token <int_val> INT_CONST
%token <str_val> L_PAREN R_PAREN L_BRACK R_BRACK L_BRACE R_BRACE

// 非终结符的类型定义
%type <ast_val> CompUnit FuncDef Type Block Stmt Expr Var
%type <int_val> Number
%type <ast_list> ParamList Params BlockItem Declare VarDef InitVal

%right AT
%left MUL_ASSIGN DIV_ASSIGN
%left ADD_ASSIGN SUB_ASSIGN
%left ASS
%left OR
%left AND
%left EQUAL NOT_EQUAL
%left LARGER LARGER_EQUAL LESS LESS_EQUAL
%left ADD SUB
%left MUL DIV MOD
%right NOT
%right AUTO_INCREASE AUTO_DECREASE
// %type <str_val> Number

%%

// 开始符, CompUnit ::= FuncDef, 大括号后声明了解析完成后 parser 要做的事情，这个整体是按照EBNF范式的形式组织的
// 之前我们定义了 FuncDef 会返回一个 str_val, 也就是字符串指针
// 而 parser 一旦解析完 CompUnit, 就说明所有的 token 都被解析了, 即解析结束了
// 此时我们应该把 FuncDef 返回的结果收集起来, 作为 AST 传给调用 parser 的函数
// $1 指代规则里第一个符号的返回值, 也就是 FuncDef 的返回值
CompUnit
  : FuncDef {
    auto comp_unit = make_unique<CompUnitAST>();
    comp_unit->func_stmt_defs_.emplace_back(unique_ptr<BaseAST>($1));
    $$ = ((BaseAST*)&(*comp_unit));
    ast = move(comp_unit);
  } | FuncDef CompUnit {
    auto comp_unit = make_unique<CompUnitAST>();
    comp_unit->func_stmt_defs_.emplace_back(unique_ptr<BaseAST>($1));

    auto temp_unit = $2;
    auto block = ((CompUnitAST*)&(*temp_unit));
    for (auto &item : block->func_stmt_defs_) {
    	comp_unit->func_stmt_defs_.emplace_back(move(item));
    }
    $$ = ((BaseAST*)&(*comp_unit));
    ast = move(comp_unit);
  }
  ;

Params
: Expr {
    vector<unique_ptr<BaseAST>> *params = new vector<unique_ptr<BaseAST>>();
    params->emplace_back(unique_ptr<BaseAST>($1));
    $$ = params;
} | Expr ',' Params {
    vector<unique_ptr<BaseAST>> *params = new vector<unique_ptr<BaseAST>>();
    params->emplace_back(unique_ptr<BaseAST>($1));
    auto list = $3;
    for (auto &item : *list) {
        params->emplace_back(move(item));
    }
    $$ = params;
}

ParamList
: Type IDENT {
    vector<unique_ptr<BaseAST>> *ident_list = new vector<unique_ptr<BaseAST>>();
    auto ast = new StmtAST();
    ast->type_ = kDeclare;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ident_list->emplace_back(unique_ptr<BaseAST>(ast));
    $$ = ident_list;
} | Type IDENT ',' ParamList {
    vector<unique_ptr<BaseAST>> *ident_list = new vector<unique_ptr<BaseAST>>();
    auto ast = new StmtAST();
    ast->type_ = kDeclare;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ident_list->emplace_back(unique_ptr<BaseAST>(ast));
    auto list = $4;
    for (auto &item : *list) {
    	ident_list->emplace_back(move(item));
    }
    $$ = ident_list;
} | Type IDENT L_BRACK Number R_BRACK {
    vector<unique_ptr<BaseAST>> *ident_list = new vector<unique_ptr<BaseAST>>();
    auto ast = new StmtAST();
    ast->type_ = kDeclareArray;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ast->array_size_ = $4;
    ident_list->emplace_back(unique_ptr<BaseAST>(ast));
    $$ = ident_list;
} | Type IDENT L_BRACK Number R_BRACK ',' ParamList {
    vector<unique_ptr<BaseAST>> *ident_list = new vector<unique_ptr<BaseAST>>();
    auto ast = new StmtAST();
    ast->type_ = kDeclareArray;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ast->array_size_ = $4;
    ident_list->emplace_back(unique_ptr<BaseAST>(ast));
    auto list = $7;
    for (auto &item : *list) {
    	ident_list->emplace_back(move(item));
    }
    $$ = ident_list;
} | Type IDENT L_BRACK R_BRACK {
    vector<unique_ptr<BaseAST>> *ident_list = new vector<unique_ptr<BaseAST>>();
    auto ast = new StmtAST();
    ast->type_ = kDeclareArray;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
//    ast->array_size_ = $4;
    ident_list->emplace_back(unique_ptr<BaseAST>(ast));
    $$ = ident_list;
} | Type IDENT L_BRACK R_BRACK ',' ParamList {
    vector<unique_ptr<BaseAST>> *ident_list = new vector<unique_ptr<BaseAST>>();
    auto ast = new StmtAST();
    ast->type_ = kDeclareArray;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
//    ast->array_size_ = $4;
    ident_list->emplace_back(unique_ptr<BaseAST>(ast));
    auto list = $6;
    for (auto &item : *list) {
    	ident_list->emplace_back(move(item));
    }
    $$ = ident_list;
}
;

// FuncDef ::= FuncType IDENT '(' ')' Block;
// 我们这里可以直接写 '(' 和 ')', 因为之前在 lexer 里已经处理了单个字符的情况
// 解析完成后, 把这些符号的结果收集起来, 然后拼成一个新的字符串, 作为结果返回
// $$ 表示非终结符的返回值, 我们可以通过给这个符号赋值的方法来返回结果
// 你可能会问, FuncType, IDENT 之类的结果已经是字符串指针了
// 为什么还要用 unique_ptr 接住它们, 然后再解引用, 把它们拼成另一个字符串指针呢
// 因为所有的字符串指针都是我们 new 出来的, new 出来的内存一定要 delete
// 否则会发生内存泄漏, 而 unique_ptr 这种智能指针可以自动帮我们 delete
// 虽然此处你看不出用 unique_ptr 和手动 delete 的区别, 但当我们定义了 AST 之后
// 这种写法会省下很多内存管理的负担
FuncDef
  : Type IDENT L_PAREN R_PAREN Block {
    auto ast = new FuncDefAST();
//    ast->type_ = kFunction;
    ast->func_type_ = unique_ptr<BaseAST>($1);
    ast->ident_ = *unique_ptr<string>($2);
    ast->block_ = unique_ptr<BaseAST>($5);
    $$ = ast;
  } | Type IDENT ';'{
    auto ast = new StmtAST();
    ast->type_ = kDeclare;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    $$ = ast;
  } | Type IDENT L_PAREN ParamList R_PAREN Block {
    auto ast = new FuncDefAST();
//    ast->type_ = kFunction;
    ast->func_type_ = unique_ptr<BaseAST>($1);
    ast->ident_ = *unique_ptr<string>($2);
    ast->block_ = unique_ptr<BaseAST>($6);
    auto list = $4;
    for (auto &item : *list) {
    	ast->param_lists_.emplace_back(move(item));
    }
    $$ = ast;
  } | Type IDENT L_BRACK Number R_BRACK ';' {
    auto ast = new StmtAST();
    ast->type_ = kDeclareArray;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ast->array_size_ = $4;
    $$ = ast;
  } | Type IDENT ASS Number ';' {
    auto ast = new StmtAST();
    ast->type_ = kDeclareAssign;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ast->array_size_ = $4;
    $$ = ast;
  }
  ;

// 同上, 不再解释
Type
  : INT {
    auto ast = new FuncTypeAST();
    ast->type_ = *make_unique<string>("int");
    $$ = ast;
  } | DOUBLE {
    auto ast = new FuncTypeAST();
    ast->type_ = *make_unique<string>("double");
    $$ = ast;
  } | VOID {
   auto ast = new FuncTypeAST();
   ast->type_ = *make_unique<string>("void");
   $$ = ast;
  } | FLOAT {
    auto ast = new FuncTypeAST();
    ast->type_ = *make_unique<string>("float");
    $$ = ast;
  }
  ;

Block
  : L_BRACE BlockItem R_BRACE {
    auto ast = new BlockAST();
    // auto temp_stmt = ;
    auto list = $2;
    for (auto &item : *list) {
    	ast->stmt_.emplace_back(std::move(item));
    }
    $$ = ast;
  }
  ;

BlockItem
  : Stmt {
    auto item_list = new vector<unique_ptr<BaseAST>>();
    item_list->emplace_back(unique_ptr<BaseAST>($1));
    $$ = item_list;
  } | Declare {
    auto item_list = new vector<unique_ptr<BaseAST>>();
    auto list = $1;
    for (auto &item : *list) {
    	item_list->emplace_back(std::move(item));
    }
    $$ = item_list;
  } | Stmt BlockItem {
    auto item_list = new vector<unique_ptr<BaseAST>>();
    item_list->emplace_back(unique_ptr<BaseAST>($1));
    auto list = $2;
    for (auto &item : *list) {
    	item_list->emplace_back(std::move(item));
    }
    $$ = item_list;
  } | Declare BlockItem {
    auto item_list = new vector<unique_ptr<BaseAST>>();
    auto declare_list = $1;
    for (auto &item : *declare_list){
    	item_list->emplace_back(std::move(item));
    }
    auto list = $2;
    for (auto &item : *list) {
    	item_list->emplace_back(std::move(item));
    }
    $$ = item_list;
  }
  ;

VarDef
  : Var {
    auto var_list = new vector<unique_ptr<BaseAST>>();
    var_list->emplace_back(unique_ptr<BaseAST>($1));
    $$ = var_list;
  }
  ;

Var
  : IDENT {
    auto ast = new StmtAST();
    ast->type_ = kDeclare;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($1);
    $$ = ast;
  } | IDENT ASS InitVal {
    auto ast = new StmtAST();
    ast->type_ = kDeclareAssign;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($1);
    auto list = $3;
    for (auto &item : *list) {
    	ast->assign_list_.emplace_back(std::move(item));
    }
    $$ = ast;
  } | IDENT L_BRACK Number R_BRACK {
    auto ast = new StmtAST();
    ast->type_ = kDeclareArray;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($1);
    ast->array_size_ = $3;
    $$ = ast;
  } | IDENT L_BRACK Number R_BRACK ASS InitVal {
    auto ast = new StmtAST();
    ast->type_ = kDeclareArrayAssign;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($1);
    ast->array_size_ = $3;
    auto list = $6;
    for (auto &item : *list) {
    	ast->assign_list_.emplace_back(std::move(item));
    }
    $$ = ast;
  }
  ;

InitVal
  : Expr {
    auto list = new vector<unique_ptr<BaseAST>>();
    list->emplace_back(unique_ptr<BaseAST>($1));
    $$ = list;
  } | L_BRACE InitVal R_BRACE {
    auto list = new vector<unique_ptr<BaseAST>>();
    auto temp_list = $2;
    for (auto &item : *temp_list) {
    	list->emplace_back(std::move(item));
    }
    $$ = list;
  } | Expr ',' InitVal {
     auto list = new vector<unique_ptr<BaseAST>>();
     list->emplace_back(unique_ptr<BaseAST>($1));
     auto temp_list = $3;
     for (auto &item : *temp_list) {
     	list->emplace_back(std::move(item));
     }
     $$ = list;
  } | L_BRACE InitVal R_BRACE ',' InitVal {
      auto list = new vector<unique_ptr<BaseAST>>();
      auto list_1 = $2;
      auto list_2 = $5;
      for (auto &item : *list_1) {
      	list->emplace_back(std::move(item));
      }
      for (auto &item : *list_2) {
      	list->emplace_back(std::move(item));
      }
      $$ = list;
  }
  ;

Declare
  : INT VarDef  ';' {
    auto list = $2;
    $$ = list;
  } | CONST INT VarDef ';' {
    auto list = $3;
    for (auto &item : *list) {
	item->isConst = true;
    }
    $$ = list;
  }
  ;

Stmt
  : RETURN Expr ';' {
    auto ast = new StmtAST();
    ast->type_ = kReturn;
    ast->exp_ = unique_ptr<BaseAST>($2);
    $$ = ast;
  } | Expr ';' {
    auto ast = new StmtAST();
    ast->type_ = kExpression;
    ast->exp_ = unique_ptr<BaseAST>($1);
    $$ = ast;
  } | IF L_PAREN Expr R_PAREN Stmt {
    auto ast = new StmtAST();
    ast->type_ = kIf;
    ast->exp_ = unique_ptr<BaseAST>($3);
    ast->true_block_ = unique_ptr<BaseAST>($5);
    $$ = ast;
  } | WHILE L_PAREN Expr R_PAREN Stmt {
    auto ast = new StmtAST();
    ast->type_ = kWhile;
    ast->exp_ = unique_ptr<BaseAST>($3);
    ast->block_ = unique_ptr<BaseAST>($5);
    $$ = ast;
  } | IF L_PAREN Expr R_PAREN Stmt ELSE Stmt {
    auto ast = new StmtAST();
    ast->type_ = kIf;
    ast->exp_ = unique_ptr<BaseAST>($3);
    ast->true_block_ = unique_ptr<BaseAST>($5);
    ast->false_block_ = unique_ptr<BaseAST>($7);
    $$ = ast;
  } | STATIC INT IDENT ';' {
     auto ast = new StmtAST();
     ast->type_ = kStatic;
     ast->key_word_ = *make_unique<string>("int");
     ast->ident_ = *unique_ptr<string>($3);
     $$ = ast;
  } | CONTINUE ';' {
     auto ast = new StmtAST();
     ast->type_ = kContinue;
     $$ = ast;
  } | BREAK ';' {
     auto ast = new StmtAST();
     ast->type_ = kBreak;
     $$ = ast;
  } | Block {
     auto ast = $1;
     $$ = ast;
  }
  ;

Expr
  : IDENT ASS Expr {
    auto ast = new ExprAST();
    ast->type_ = kAssign;
    ast->ident_ = *unique_ptr<string>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | L_PAREN Expr R_PAREN {
    auto ast = new ExprAST();
    ast->type_ = kParen;
    ast->lExp_ = unique_ptr<BaseAST>($2);
    $$ = ast;
  } | Expr ADD Expr {
    auto ast = new ExprAST();
    ast->type_ = kAdd;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr SUB Expr {
    auto ast = new ExprAST();
    ast->type_ = kSub;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr MUL Expr {
    auto ast = new ExprAST();
    ast->type_ = kMul;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr DIV Expr {
    auto ast = new ExprAST();
    ast->type_ = kDiv;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr MOD Expr {
    auto ast = new ExprAST();
    ast->type_ = kMod ;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr EQUAL Expr {
    auto ast = new ExprAST();
    ast->type_ = kEqual;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr NOT_EQUAL Expr {
    auto ast = new ExprAST();
    ast->type_ = kNotEqual;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr AND Expr {
    auto ast = new ExprAST();
    ast->type_ = kAnd;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr OR Expr {
    auto ast = new ExprAST();
    ast->type_ = kOr;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr LARGER Expr {
    auto ast = new ExprAST();
    ast->type_ = kLarger;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr LARGER_EQUAL Expr {
    auto ast = new ExprAST();
    ast->type_ = kLargerEqual;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr LESS Expr {
    auto ast = new ExprAST();
    ast->type_ = kLess;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr LESS_EQUAL Expr {
    auto ast = new ExprAST();
    ast->type_ = kLessEqual;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr MUL_ASSIGN Expr {
    auto ast = new ExprAST();
    ast->type_ = kMulAssign;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr DIV_ASSIGN Expr {
    auto ast = new ExprAST();
    ast->type_ = kDivAssign;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr ADD_ASSIGN Expr {
    auto ast = new ExprAST();
    ast->type_ = kAddAssign;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | Expr SUB_ASSIGN Expr {
    auto ast = new ExprAST();
    ast->type_ = kSubAssign;
    ast->lExp_ = unique_ptr<BaseAST>($1);
    ast->rExp_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | NOT Expr {
    auto ast = new ExprAST();
    ast->type_ = kNot;
    ast->rExp_ = unique_ptr<BaseAST>($2);
    $$ = ast;
  } | IDENT {
    auto ast = new ExprAST();
    ast->type_ = kAtomIdent;
    ast->ident_ = *unique_ptr<string>($1);
    $$ = ast;
  } | Number {
    auto ast = new ExprAST();
    ast->type_ = kAtomNum;
    ast->num_ = $1;
    $$ = ast;
  } | IDENT L_PAREN Params R_PAREN {
    auto ast = new ExprAST();
    ast->type_ = kFunction;
    ast->ident_ = *unique_ptr<string>($1);
    auto list = $3;
    for (auto &item : *list) {
    	ast->param_lists_.emplace_back(std::move(item));
    }
    $$ = ast;
  } | IDENT L_PAREN R_PAREN {
    auto ast = new ExprAST();
    ast->type_ = kFunction;
    ast->ident_ = *unique_ptr<string>($1);
    $$ = ast;
  } | IDENT L_BRACK Expr R_BRACK {
    auto ast = new ExprAST();
    ast->type_ = kAtomArray;
    ast->ident_ = *unique_ptr<string>($1);
    ast->array_offset_ = unique_ptr<BaseAST>($3);
    $$ = ast;
  } | IDENT L_BRACK Expr R_BRACK ASS Expr {
    auto ast = new ExprAST();
    ast->type_ = kAssignArray;
    ast->array_offset_ = unique_ptr<BaseAST>($3);
    ast->ident_ = *unique_ptr<string>($1);
    ast->rExp_ = unique_ptr<BaseAST>($6);
    $$ = ast;
  } | AT Expr {
    auto ast = new ExprAST();
    ast->type_ = kAt;
    ast->rExp_ = unique_ptr<BaseAST>($2);
    $$ = ast;
  }
  ;

Number
  : INT_CONST {
    $$ = $1;
  } | SUB INT_CONST {
    $$ = -$2;
  }
  ;

%%

// 定义错误处理函数, 其中第二个参数是错误信息
// parser 如果发生错误 (例如输入的程序出现了语法错误), 就会调用这个函数
void yyerror(unique_ptr<BaseAST> &ast, const char *s) {
  cerr << "error: " << s << endl;
}
