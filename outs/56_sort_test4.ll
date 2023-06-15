; ModuleID = 'default'
source_filename = "default"

@n = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @select_sort(i32* %A, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %A, i32** %0
  store i32 %n, i32* %1
  %i = alloca i32
  %j = alloca i32
  %min = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %merge_block7, %begin
  br label %begin
  %2 = load i32, i32* %i
  %3 = load i32, i32* %1
  %sub = fsub i32 %3, 1
  %less = icmp slt i32 %2, %sub
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header1, %loop_header
  %4 = load i32, i32* %i
  store volatile i32 %4, i32* %min
  %5 = load i32, i32* %i
  %add = fadd i32 %5, 1
  store volatile i32 %add, i32* %j
  br label %loop_header1

loop_header1:                                     ; preds = %merge_block, %loop_body
  br label %loop_body
  %6 = load i32, i32* %j
  %7 = load i32, i32* %1
  %less4 = icmp slt i32 %6, %7
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %8 = load i32, i32* %min
  %9 = load i32, i32* %i
  %not_equal = icmp ne i32 %8, %9
  br i1 %not_equal, label %true_block6, <null operand!>

loop_body3:                                       ; preds = %loop_header1
  %10 = load i32*, i32** %0
  %11 = load i32, i32* %min
  %12 = getelementptr i32, i32* %10, i32 %11
  %13 = load i32, i32* %12
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %j
  %16 = getelementptr i32, i32* %14, i32 %15
  %17 = load i32, i32* %16
  %greater = icmp sgt i32 %13, %17
  br i1 %greater, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body3
  %18 = load i32, i32* %j
  store volatile i32 %18, i32* %min
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %19 = load i32, i32* %j
  %add5 = fadd i32 %19, 1
  store volatile i32 %add5, i32* %j
  br label %loop_header1

true_block6:                                      ; preds = %loop_exit2
  %tmp = alloca i32
  %20 = load i32*, i32** %0
  %21 = load i32, i32* %min
  %22 = getelementptr i32, i32* %20, i32 %21
  %23 = load i32, i32* %22
  store volatile i32 %23, i32* %tmp
  %24 = load i32*, i32** %0
  %25 = load i32*, i32** %0
  %26 = load i32, i32* %i
  %27 = getelementptr i32, i32* %25, i32 %26
  %28 = load i32, i32* %27
  %29 = load i32, i32* %min
  %30 = getelementptr i32, i32* %24, i32 %29
  store volatile i32 %28, i32* %30
  %31 = load i32*, i32** %0
  %32 = load i32, i32* %tmp
  %33 = load i32, i32* %i
  %34 = getelementptr i32, i32* %31, i32 %33
  store volatile i32 %32, i32* %34
  br label %merge_block7

merge_block7:                                     ; preds = %true_block6
  %35 = load i32, i32* %i
  %add8 = fadd i32 %35, 1
  store volatile i32 %add8, i32* %i
  br label %loop_header
}

define i32 @main() {
begin:
  store volatile i32 10, i32* @n
  %a = alloca [10 x i32]
  %0 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  store volatile i32 4, i32* %0
  %1 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 1
  store volatile i32 3, i32* %1
  %2 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 2
  store volatile i32 9, i32* %2
  %3 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 3
  store volatile i32 2, i32* %3
  %4 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 4
  store volatile i32 0, i32* %4
  %5 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 5
  store volatile i32 1, i32* %5
  %6 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 6
  store volatile i32 6, i32* %6
  %7 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 7
  store volatile i32 5, i32* %7
  %8 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 8
  store volatile i32 7, i32* %8
  %9 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 9
  store volatile i32 8, i32* %9
  %i = alloca i32
  store volatile i32 0, i32* %i
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* @n
  %call = call i32 @select_sort(i32* %10, i32 %11)
  store volatile i32 %call, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %12 = load i32, i32* %i
  %13 = load i32, i32* @n
  %less = icmp slt i32 %12, %13
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %tmp = alloca i32
  %14 = load i32, i32* %i
  %15 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %14
  %16 = load i32, i32* %15
  store volatile i32 %16, i32* %tmp
  %17 = load i32, i32* %tmp
  %call1 = call void @putint(i32 %17)
  store volatile i32 10, i32* %tmp
  %18 = load i32, i32* %tmp
  %call2 = call void @putch(i32 %18)
  %19 = load i32, i32* %i
  %add = fadd i32 %19, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
