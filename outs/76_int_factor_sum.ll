; ModuleID = 'default'
source_filename = "default"

@N = global i32 0
@newline = global i32 0

define i32 @factor(i32 %n) {
begin:
  %0 = alloca i32
  store i32 %n, i32* %0
  %i = alloca i32
  %sum = alloca i32
  store volatile i32 0, i32* %sum
  store volatile i32 1, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %1 = load i32, i32* %i
  %2 = load i32, i32* %0
  %add = fadd i32 %2, 1
  %less = icmp slt i32 %1, %add
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %3 = load i32, i32* %sum
  ret i32 %3

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %0
  %5 = load i32, i32* %i
  %mod = urem i32 %4, %5
  %equal = icmp eq i32 %mod, 0
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  %6 = load i32, i32* %sum
  %7 = load i32, i32* %i
  %add1 = fadd i32 %6, %7
  store volatile i32 %add1, i32* %sum
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %8 = load i32, i32* %i
  %add2 = fadd i32 %8, 1
  store volatile i32 %add2, i32* %i
  br label %loop_header
}

define i32 @main() {
begin:
  store volatile i32 4, i32* @N
  store volatile i32 10, i32* @newline
  %i = alloca i32
  %m = alloca i32
  store volatile i32 1478, i32* %m
  %t = alloca i32
  %0 = load i32, i32* %m
  %call = call i32 @factor(i32 %0)
  ret i32 %call
}
