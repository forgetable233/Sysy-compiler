; ModuleID = 'default'
source_filename = "default"

define i32 @climbStairs(i32 %n) {
begin:
  %0 = alloca i32
  store i32 %n, i32* %0
  %1 = load i32, i32* %0
  %less = icmp slt i32 %1, 4
  br i1 %less, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  %2 = load i32, i32* %0
  ret i32 %2
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  %dp = alloca [10 x i32]
  %3 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 0
  store volatile i32 0, i32* %3
  %4 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 1
  store volatile i32 1, i32* %4
  %5 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 2
  store volatile i32 2, i32* %5
  %i = alloca i32
  store volatile i32 3, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %6 = load i32, i32* %i
  %7 = load i32, i32* %0
  %add = fadd i32 %7, 1
  %less1 = icmp slt i32 %6, %add
  br i1 %less1, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %8 = load i32, i32* %0
  %9 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %8
  %10 = load i32, i32* %9
  ret i32 %10

loop_body:                                        ; preds = %loop_header
  %11 = load i32, i32* %i
  %sub = fsub i32 %11, 1
  %12 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %sub
  %13 = load i32, i32* %12
  %14 = load i32, i32* %i
  %sub2 = fsub i32 %14, 2
  %15 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %sub2
  %16 = load i32, i32* %15
  %add3 = fadd i32 %13, %16
  %17 = load i32, i32* %i
  %18 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %17
  store volatile i32 %add3, i32* %18
  %19 = load i32, i32* %i
  %add4 = fadd i32 %19, 1
  store volatile i32 %add4, i32* %i
  br label %loop_header
}

define i32 @main() {
begin:
  %res = alloca i32
  %n = alloca i32
  store volatile i32 5, i32* %n
  %0 = load i32, i32* %n
  %call = call i32 @climbStairs(i32 %0)
  store volatile i32 %call, i32* %res
  %1 = load i32, i32* %res
  ret i32 %1
}
