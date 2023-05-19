# compiler

## AST介绍

此处介绍所有定义的AST以及其封装层次，最终的作用

`BaseAST` : 所有AST的父类，定义了基础的函数以及性能

`CompUnitAST` ：一个编译模板，其中有多个函数，`FuncDefAST`

`FuncDefAST` ：一个函数的定义，其中包括一个基础块，`BlockAST`

`BlockAST`：一个基础块的定义，其中包括多个声明，`StmtAST`

`StmtAST`：一个声明的定义，其可以为一句话，也可能包括一个`BlockAST`，取决于这个声明是不是`if` `while`等类型

| Stmt {
  auto comp_unit = make_unique<CompUnitAST>();
  comp_unit->func_stmt_defs_.emplace_back(unique_ptr<BaseAST>($1));
  $$ = ((BaseAST*)&(*comp_unit));
  ast = move(comp_unit);
} | Stmt CompUnit {
  auto comp_unit = make_unique<CompUnitAST>();
  comp_unit->func_stmt_defs_.emplace_back(unique_ptr<BaseAST>($1));

  auto temp_unit = $2;
  auto block = ((CompUnitAST*)&(*temp_unit));
  for (auto &item : block->func_stmt_defs_) {
        comp_unit->func_stmt_defs_.emplace_back(move(item));
  }
  ast = move(comp_unit);
  $$ = ((BaseAST*)&(*comp_unit));
}
