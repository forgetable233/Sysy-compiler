; ModuleID = 'default'
source_filename = "default"

define i32 @maxArea(i32* %height, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %height, i32** %0
  store i32 %n, i32* %1
  %i = alloca i32
  %j = alloca i32
  store volatile i32 0, i32* %i
  %2 = load i32, i32* %1
  %sub = fsub i32 %2, 1
  store volatile i32 %sub, i32* %j
  %max_val = alloca i32
  store volatile i32 -1, i32* %max_val
  br label %loop_header

loop_header:                                      ; preds = %merge_block9, %begin
  br label %begin
  %3 = load i32, i32* %i
  %4 = load i32, i32* %j
  %less = icmp slt i32 %3, %4
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %5 = load i32, i32* %max_val
  ret i32 %5

loop_body:                                        ; preds = %loop_header
  %area = alloca i32
  %6 = load i32*, i32** %0
  %7 = load i32, i32* %i
  %8 = getelementptr i32, i32* %6, i32 %7
  %9 = load i32, i32* %8
  %10 = load i32*, i32** %0
  %11 = load i32, i32* %j
  %12 = getelementptr i32, i32* %10, i32 %11
  %13 = load i32, i32* %12
  %less1 = icmp slt i32 %9, %13
  br i1 %less1, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body
  %14 = load i32, i32* %j
  %15 = load i32, i32* %i
  %sub2 = fsub i32 %14, %15
  %16 = load i32*, i32** %0
  %17 = load i32, i32* %i
  %18 = getelementptr i32, i32* %16, i32 %17
  %19 = load i32, i32* %18
  %mul = mul i32 %sub2, %19
  store volatile i32 %mul, i32* %area
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  %20 = load i32, i32* %area
  %21 = load i32, i32* %max_val
  %greater = icmp sgt i32 %20, %21
  br i1 %greater, label %true_block5, <null operand!>

false_block:                                      ; preds = %loop_body
  %22 = load i32, i32* %j
  %23 = load i32, i32* %i
  %sub3 = fsub i32 %22, %23
  %24 = load i32*, i32** %0
  %25 = load i32, i32* %j
  %26 = getelementptr i32, i32* %24, i32 %25
  %27 = load i32, i32* %26
  %mul4 = mul i32 %sub3, %27
  store volatile i32 %mul4, i32* %area
  br label %merge_block

true_block5:                                      ; preds = %merge_block
  %28 = load i32, i32* %area
  store volatile i32 %28, i32* %max_val
  br label %merge_block6

merge_block6:                                     ; preds = %true_block5
  %29 = load i32*, i32** %0
  %30 = load i32, i32* %i
  %31 = getelementptr i32, i32* %29, i32 %30
  %32 = load i32, i32* %31
  %33 = load i32*, i32** %0
  %34 = load i32, i32* %j
  %35 = getelementptr i32, i32* %33, i32 %34
  %36 = load i32, i32* %35
  %greater7 = icmp sgt i32 %32, %36
  br i1 %greater7, label %true_block8, label %false_block10

true_block8:                                      ; preds = %merge_block6
  %37 = load i32, i32* %j
  %sub11 = fsub i32 %37, 1
  store volatile i32 %sub11, i32* %j
  br label %merge_block9

merge_block9:                                     ; preds = %false_block10, %true_block8
  br label %loop_header

false_block10:                                    ; preds = %merge_block6
  %38 = load i32, i32* %i
  %add = fadd i32 %38, 1
  store volatile i32 %add, i32* %i
  br label %merge_block9
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
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* %res
  %call = call i32 @maxArea(i32* %10, i32 %11)
  store volatile i32 %call, i32* %res
  %12 = load i32, i32* %res
  ret i32 %12
}
