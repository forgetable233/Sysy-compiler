; ModuleID = 'default'
source_filename = "default"

define i32 @maxSubArray(i32* %nums, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %nums, i32** %0
  store i32 %n, i32* %1
  %2 = load i32, i32* %1
  %equal = icmp eq i32 %2, 0
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 0
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %3 = load i32, i32* %1
  %equal1 = icmp eq i32 %3, 1
  br i1 %equal1, label %true_block2, <null operand!>

true_block2:                                      ; preds = %merge_block
  %4 = load i32*, i32** %0
  %5 = getelementptr i32, i32* %4, i32 0
  %6 = load i32, i32* %5
  ret i32 %6
  br label %merge_block3

merge_block3:                                     ; preds = %loop_header, %true_block2
  %sum = alloca i32
  %7 = load i32*, i32** %0
  %8 = getelementptr i32, i32* %7, i32 0
  %9 = load i32, i32* %8
  store volatile i32 %9, i32* %sum
  %max = alloca i32
  %10 = load i32, i32* %sum
  store volatile i32 %10, i32* %max
  %i = alloca i32
  store volatile i32 1, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %merge_block9, %merge_block3
  br label %merge_block3
  %11 = load i32, i32* %i
  %12 = load i32, i32* %1
  %less = icmp slt i32 %11, %12
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %13 = load i32, i32* %max
  ret i32 %13

loop_body:                                        ; preds = %loop_header
  %14 = load i32, i32* %sum
  %less4 = icmp slt i32 %14, 0
  br i1 %less4, label %true_block5, <null operand!>

true_block5:                                      ; preds = %loop_body
  store volatile i32 0, i32* %sum
  br label %merge_block6

merge_block6:                                     ; preds = %true_block5
  %15 = load i32, i32* %sum
  %16 = load i32*, i32** %0
  %17 = load i32, i32* %i
  %18 = getelementptr i32, i32* %16, i32 %17
  %19 = load i32, i32* %18
  %add = fadd i32 %15, %19
  store volatile i32 %add, i32* %sum
  %20 = load i32, i32* %max
  %21 = load i32, i32* %sum
  %less7 = icmp slt i32 %20, %21
  br i1 %less7, label %true_block8, <null operand!>

true_block8:                                      ; preds = %merge_block6
  %22 = load i32, i32* %sum
  store volatile i32 %22, i32* %max
  br label %merge_block9

merge_block9:                                     ; preds = %true_block8
  %23 = load i32, i32* %i
  %add10 = fadd i32 %23, 1
  store volatile i32 %add10, i32* %i
  br label %loop_header
}

define i32 @main() {
begin:
  %res = alloca i32
  %a = alloca [10 x i32]
  %0 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  store volatile i32 -4, i32* %0
  %1 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 1
  store volatile i32 3, i32* %1
  %2 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 2
  store volatile i32 9, i32* %2
  %3 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 3
  store volatile i32 -2, i32* %3
  %4 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 4
  store volatile i32 0, i32* %4
  %5 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 5
  store volatile i32 1, i32* %5
  %6 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 6
  store volatile i32 -6, i32* %6
  %7 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 7
  store volatile i32 5, i32* %7
  %8 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 8
  store volatile i32 7, i32* %8
  %9 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 9
  store volatile i32 8, i32* %9
  store volatile i32 10, i32* %res
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* %res
  %call = call i32 @maxSubArray(i32* %10, i32 %11)
  store volatile i32 %call, i32* %res
  %12 = load i32, i32* %res
  ret i32 %12
}
