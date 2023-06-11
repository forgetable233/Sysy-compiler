; ModuleID = 'default'
source_filename = "default"

define i32 @removeElement(i32* %nums, i32 %n, i32 %val) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  %2 = alloca i32
  store i32* %nums, i32** %0
  store i32 %n, i32* %1
  store i32 %val, i32* %2
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %3 = load i32, i32* %i
  %4 = load i32, i32* %1
  %less = icmp slt i32 %3, %4
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %5 = load i32, i32* %1
  ret i32 %5

loop_body:                                        ; preds = %loop_header
  %6 = load i32*, i32** %0
  %7 = load i32, i32* %i
  %8 = getelementptr i32, i32* %6, i32 %7
  %9 = load i32, i32* %8
  %10 = load i32, i32* %2
  %equal = icmp eq i32 %9, %10
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body
  %11 = load i32*, i32** %0
  %12 = load i32*, i32** %0
  %13 = load i32, i32* %1
  %sub = fsub i32 %13, 1
  %14 = getelementptr i32, i32* %12, i32 %sub
  %15 = load i32, i32* %14
  %16 = load i32, i32* %i
  %17 = getelementptr i32, i32* %11, i32 %16
  store volatile i32 %15, i32* %17
  %18 = load i32, i32* %1
  %sub1 = fsub i32 %18, 1
  store volatile i32 %sub1, i32* %1
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  br label %loop_header

false_block:                                      ; preds = %loop_body
  %19 = load i32, i32* %i
  %add = fadd i32 %19, 1
  store volatile i32 %add, i32* %i
  br label %merge_block
}

define i32 @main() {
begin:
  %res = alloca i32
  %a = alloca [10 x i32]
  %0 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  store volatile i32 3, i32* %0
  %1 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 1
  store volatile i32 3, i32* %1
  %2 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 2
  store volatile i32 9, i32* %2
  %3 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 3
  store volatile i32 0, i32* %3
  %4 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 4
  store volatile i32 0, i32* %4
  %5 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 5
  store volatile i32 1, i32* %5
  %6 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 6
  store volatile i32 1, i32* %6
  %7 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 7
  store volatile i32 5, i32* %7
  %8 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 8
  store volatile i32 7, i32* %8
  %9 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 9
  store volatile i32 8, i32* %9
  store volatile i32 10, i32* %res
  %val = alloca i32
  store volatile i32 3, i32* %val
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* %res
  %12 = load i32, i32* %val
  %call = call i32 @removeElement(i32* %10, i32 %11, i32 %12)
  store volatile i32 %call, i32* %res
  %13 = load i32, i32* %res
  ret i32 %13
}
