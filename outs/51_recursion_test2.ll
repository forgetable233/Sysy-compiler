; ModuleID = 'default'
source_filename = "default"

define i32 @fib(i32 %n) {
begin:
  %0 = alloca i32
  store i32 %n, i32* %0
  %1 = load i32, i32* %0
  %equal = icmp eq i32 %1, 0
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 0
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %2 = load i32, i32* %0
  %equal1 = icmp eq i32 %2, 1
  br i1 %equal1, label %true_block2, <null operand!>

true_block2:                                      ; preds = %merge_block
  ret i32 1
  br label %merge_block3

merge_block3:                                     ; preds = %true_block2
  %p = alloca i32
  %3 = load i32, i32* %0
  %sub = fsub i32 %3, 1
  store volatile i32 %sub, i32* %p
  %q = alloca i32
  %4 = load i32, i32* %0
  %sub4 = fsub i32 %4, 2
  store volatile i32 %sub4, i32* %q
  %5 = load i32, i32* %p
  %call = call i32 @fib(i32 %5)
  %6 = load i32, i32* %q
  %call5 = call i32 @fib(i32 %6)
  %add = fadd i32 %call, %call5
  ret i32 %add
}

define i32 @main() {
begin:
  %tmp = alloca i32
  store volatile i32 10, i32* %tmp
  %0 = load i32, i32* %tmp
  %call = call i32 @fib(i32 %0)
  ret i32 %call
}
