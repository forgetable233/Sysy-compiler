; ModuleID = 'default'
source_filename = "default"

define i32 @canJump(i32* %nums, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %nums, i32** %0
  store i32 %n, i32* %1
  %2 = load i32, i32* %1
  %equal = icmp eq i32 %2, 1
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %3 = load i32*, i32** %0
  %4 = getelementptr i32, i32* %3, i32 0
  %5 = load i32, i32* %4
  %6 = load i32, i32* %1
  %sub = fsub i32 %6, 2
  %greater = icmp sgt i32 %5, %sub
  br i1 %greater, label %true_block1, <null operand!>

true_block1:                                      ; preds = %merge_block
  ret i32 1
  br label %merge_block2

merge_block2:                                     ; preds = %loop_header, %true_block1
  %dp = alloca [10 x i32]
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block2
  br label %merge_block2
  %7 = load i32, i32* %i
  %8 = load i32, i32* %1
  %sub3 = fsub i32 %8, 1
  %less = icmp slt i32 %7, %sub3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header6, %loop_header
  %9 = load i32, i32* %1
  %sub4 = fsub i32 %9, 1
  %10 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %sub4
  store volatile i32 1, i32* %10
  %11 = load i32, i32* %1
  %sub5 = fsub i32 %11, 2
  store volatile i32 %sub5, i32* %i
  br label %loop_header6

loop_body:                                        ; preds = %loop_header
  %12 = load i32, i32* %i
  %13 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %12
  store volatile i32 0, i32* %13
  %14 = load i32, i32* %i
  %add = fadd i32 %14, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header6:                                     ; preds = %loop_exit18, %loop_exit
  br label %loop_exit
  %15 = load i32, i32* %i
  %greater9 = icmp sgt i32 %15, -1
  br i1 %greater9, label %loop_body8, label %loop_exit7

loop_exit7:                                       ; preds = %loop_header6
  %16 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 0
  %17 = load i32, i32* %16
  ret i32 %17

loop_body8:                                       ; preds = %loop_header6
  %j = alloca i32
  %18 = load i32*, i32** %0
  %19 = load i32, i32* %i
  %20 = getelementptr i32, i32* %18, i32 %19
  %21 = load i32, i32* %20
  %22 = load i32, i32* %1
  %sub10 = fsub i32 %22, 1
  %23 = load i32, i32* %i
  %sub11 = fsub i32 %sub10, %23
  %less12 = icmp slt i32 %21, %sub11
  br i1 %less12, label %true_block13, label %false_block

true_block13:                                     ; preds = %loop_body8
  %24 = load i32*, i32** %0
  %25 = load i32, i32* %i
  %26 = getelementptr i32, i32* %24, i32 %25
  %27 = load i32, i32* %26
  store volatile i32 %27, i32* %j
  br label %merge_block14

merge_block14:                                    ; preds = %loop_header17, %false_block, %true_block13
  br label %loop_header17

false_block:                                      ; preds = %loop_body8
  %28 = load i32, i32* %1
  %sub15 = fsub i32 %28, 1
  %29 = load i32, i32* %i
  %sub16 = fsub i32 %sub15, %29
  store volatile i32 %sub16, i32* %j
  br label %merge_block14

loop_header17:                                    ; preds = %merge_block23, %merge_block14
  br label %merge_block14
  %30 = load i32, i32* %j
  %greater20 = icmp sgt i32 %30, -1
  br i1 %greater20, label %loop_body19, label %loop_exit18

loop_exit18:                                      ; preds = %loop_header17
  %31 = load i32, i32* %i
  %sub25 = fsub i32 %31, 1
  store volatile i32 %sub25, i32* %i
  br label %loop_header6

loop_body19:                                      ; preds = %loop_header17
  %32 = load i32, i32* %i
  %33 = load i32, i32* %j
  %add21 = fadd i32 %32, %33
  %34 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %add21
  %35 = load i32, i32* %34
  %not_equal = icmp ne i32 %35, 0
  br i1 %not_equal, label %true_block22, <null operand!>

true_block22:                                     ; preds = %loop_body19
  %36 = load i32, i32* %i
  %37 = getelementptr [10 x i32], [10 x i32]* %dp, i32 0, i32 %36
  store volatile i32 1, i32* %37
  br label %merge_block23

merge_block23:                                    ; preds = %true_block22
  %38 = load i32, i32* %j
  %sub24 = fsub i32 %38, 1
  store volatile i32 %sub24, i32* %j
  br label %loop_header17
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
  %call = call i32 @canJump(i32* %10, i32 %11)
  store volatile i32 %call, i32* %res
  %12 = load i32, i32* %res
  ret i32 %12
}
