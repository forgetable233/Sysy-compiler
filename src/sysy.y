%code requires {
  #include <iostream>
  #include <memory>
  #include <string>
  #include <vector>
  #include "../src/ast.h"
}

%{
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#include "../src/ast.h"

int yylex();
void yyerror(std::unique_ptr<BaseAST> &ast, const char *s);

using namespace std;

%}

%parse-param { std::unique_ptr<BaseAST> &ast }

%union {
  std::string *str_val;
  int int_val;
  BaseAST *ast_val;
  std::vector<std::unique_ptr<BaseAST>> *ast_list;
}

%token RETURN
%token <str_val> IDENT INT VOID DOUBLE FLOAT ADD SUB MUL DIV ASS STATIC CONTINUE BREAK
%token <str_val> EQUAL NOT_EQUAL AND OR LESS LESS_EQUAL LARGER LARGER_EQUAL
%token <str_val> ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN NOT MOD
%token <str_val> IF WHILE ELSE TRUE FALSE AT
%token <int_val> INT_CONST
%token <str_val> L_PAREN R_PAREN L_BRACK R_BRACK L_BRACE R_BRACE

%type <ast_val> CompUnit FuncDef Type Block Stmt Expr Declare
%type <int_val> Number
%type <ast_list> ParamList Params BlockItem

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


%%

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
  : L_BRACE BlockItem R_BRACE{
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
    item_list->emplace_back(unique_ptr<BaseAST>($1));
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
    item_list->emplace_back(unique_ptr<BaseAST>($1));
    auto list = $2;
    for (auto &item : *list) {
    	item_list->emplace_back(std::move(item));
    }
    $$ = item_list;
  }
  ;

Declare
  : INT IDENT ';' {
    auto ast = new StmtAST();
    ast->type_ = kDeclare;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    $$ = ast;
  } | INT IDENT ASS Expr ';' {
    auto ast = new StmtAST();
    ast->type_ = kDeclareAssign;
    ast->key_word_ = *make_unique<string>("int");
    ast->ident_ = *unique_ptr<string>($2);
    ast->exp_ = unique_ptr<BaseAST>($4);
    $$ = ast;
  } | INT IDENT L_BRACK Number R_BRACK ';' {
     auto ast = new StmtAST();
     ast->type_ = kDeclareArray;
     ast->key_word_ = *make_unique<string>("int");
     ast->ident_ = *unique_ptr<string>($2);
     ast->array_size_ = $4;
     $$ = ast;
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

void yyerror(unique_ptr<BaseAST> &ast, const char *s) {
  cerr << "error: " << s << endl;
}
