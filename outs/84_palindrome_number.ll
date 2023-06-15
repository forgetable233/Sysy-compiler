; ModuleID = 'default'
source_filename = "default"

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @palindrome(i32 %n) {
begin:
  %0 = alloca i32
  store i32 %n, i32* %0
  %a = alloca [4 x i32]
  %j = alloca i32
  %flag = alloca i32
  store volatile i32 0, i32* %j
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %1 = load i32, i32* %j
  %less = icmp slt i32 %1, 4
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %2 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 0
  %3 = load i32, i32* %2
  %4 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 3
  %5 = load i32, i32* %4
  %equal = icmp eq i32 %3, %5
  %6 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 1
  %7 = load i32, i32* %6
  %8 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 2
  %9 = load i32, i32* %8
  %equal1 = icmp eq i32 %7, %9
  %and = and i1 %equal, %equal1
  br i1 %and, label %true_block, label %false_block

loop_body:                                        ; preds = %loop_header
  %10 = load i32, i32* %0
  %mod = urem i32 %10, 10
  %11 = load i32, i32* %j
  %12 = getelementptr [4 x i32], [4 x i32]* %a, i32 0, i32 %11
  store volatile i32 %mod, i32* %12
  %13 = load i32, i32* %0
  %div = fdiv i32 %13, 10
  store volatile i32 %div, i32* %0
  %14 = load i32, i32* %j
  %add = fadd i32 %14, 1
  store volatile i32 %add, i32* %j
  br label %loop_header

true_block:                                       ; preds = %loop_exit
  store volatile i32 1, i32* %flag
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  %15 = load i32, i32* %flag
  ret i32 %15

false_block:                                      ; preds = %loop_exit
  store volatile i32 0, i32* %flag
  br label %merge_block
}

define i32 @main() {
begin:
  %test = alloca i32
  store volatile i32 1221, i32* %test
  %flag = alloca i32
  %0 = load i32, i32* %test
  %call = call i32 @palindrome(i32 %0)
  store volatile i32 %call, i32* %flag
  %1 = load i32, i32* %flag
  %equal = icmp eq i32 %1, 1
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  %2 = load i32, i32* %test
  %call1 = call void @putint(i32 %2)
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  store volatile i32 10, i32* %flag
  %3 = load i32, i32* %flag
  %call3 = call void @putch(i32 %3)
  ret i32 0

false_block:                                      ; preds = %begin
  store volatile i32 0, i32* %flag
  %4 = load i32, i32* %flag
  %call2 = call void @putint(i32 %4)
  br label %merge_block
}
