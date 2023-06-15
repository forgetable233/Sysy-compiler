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

define i32 @swap(i32* %array, i32 %i, i32 %j) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  %2 = alloca i32
  store i32* %array, i32** %0
  store i32 %i, i32* %1
  store i32 %j, i32* %2
  %temp = alloca i32
  %3 = load i32*, i32** %0
  %4 = load i32, i32* %1
  %5 = getelementptr i32, i32* %3, i32 %4
  %6 = load i32, i32* %5
  store volatile i32 %6, i32* %temp
  %7 = load i32*, i32** %0
  %8 = load i32*, i32** %0
  %9 = load i32, i32* %2
  %10 = getelementptr i32, i32* %8, i32 %9
  %11 = load i32, i32* %10
  %12 = load i32, i32* %1
  %13 = getelementptr i32, i32* %7, i32 %12
  store volatile i32 %11, i32* %13
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %temp
  %16 = load i32, i32* %2
  %17 = getelementptr i32, i32* %14, i32 %16
  store volatile i32 %15, i32* %17
  ret i32 0
}

define i32 @heap_ajust(i32* %arr, i32 %start, i32 %end) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  %2 = alloca i32
  store i32* %arr, i32** %0
  store i32 %start, i32* %1
  store i32 %end, i32* %2
  %dad = alloca i32
  %3 = load i32, i32* %1
  store volatile i32 %3, i32* %dad
  %son = alloca i32
  %4 = load i32, i32* %dad
  %mul = mul i32 %4, 2
  %add = fadd i32 %mul, 1
  store volatile i32 %add, i32* %son
  br label %loop_header

loop_header:                                      ; preds = %merge_block7, %begin
  br label %begin
  %5 = load i32, i32* %son
  %6 = load i32, i32* %2
  %add1 = fadd i32 %6, 1
  %less = icmp slt i32 %5, %add1
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %7 = load i32, i32* %son
  %8 = load i32, i32* %2
  %less2 = icmp slt i32 %7, %8
  %9 = load i32*, i32** %0
  %10 = load i32, i32* %son
  %11 = getelementptr i32, i32* %9, i32 %10
  %12 = load i32, i32* %11
  %13 = load i32*, i32** %0
  %14 = load i32, i32* %son
  %add3 = fadd i32 %14, 1
  %15 = getelementptr i32, i32* %13, i32 %add3
  %16 = load i32, i32* %15
  %less4 = icmp slt i32 %12, %16
  %and = and i1 %less2, %less4
  br i1 %and, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  %17 = load i32, i32* %son
  %add5 = fadd i32 %17, 1
  store volatile i32 %add5, i32* %son
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %18 = load i32*, i32** %0
  %19 = load i32, i32* %dad
  %20 = getelementptr i32, i32* %18, i32 %19
  %21 = load i32, i32* %20
  %22 = load i32*, i32** %0
  %23 = load i32, i32* %son
  %24 = getelementptr i32, i32* %22, i32 %23
  %25 = load i32, i32* %24
  %greater = icmp sgt i32 %21, %25
  br i1 %greater, label %true_block6, label %false_block

true_block6:                                      ; preds = %merge_block
  ret i32 0
  br label %merge_block7

merge_block7:                                     ; preds = %false_block, %true_block6
  br label %loop_header

false_block:                                      ; preds = %merge_block
  %26 = load i32*, i32** %0
  %27 = load i32, i32* %dad
  %28 = load i32, i32* %son
  %call = call i32 @swap(i32* %26, i32 %27, i32 %28)
  store volatile i32 %call, i32* %dad
  %29 = load i32, i32* %son
  store volatile i32 %29, i32* %dad
  %30 = load i32, i32* %dad
  %mul8 = mul i32 %30, 2
  %add9 = fadd i32 %mul8, 1
  store volatile i32 %add9, i32* %son
  br label %merge_block7
}

define i32 @heap_sort(i32* %arr, i32 %len) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %arr, i32** %0
  store i32 %len, i32* %1
  %i = alloca i32
  %tmp = alloca i32
  %2 = load i32, i32* %1
  %div = fdiv i32 %2, 2
  %sub = fsub i32 %div, 1
  store volatile i32 %sub, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %3 = load i32, i32* %i
  %greater = icmp sgt i32 %3, -1
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header4, %loop_header
  %4 = load i32, i32* %1
  %sub3 = fsub i32 %4, 1
  store volatile i32 %sub3, i32* %i
  br label %loop_header4

loop_body:                                        ; preds = %loop_header
  %5 = load i32, i32* %1
  %sub1 = fsub i32 %5, 1
  store volatile i32 %sub1, i32* %tmp
  %6 = load i32*, i32** %0
  %7 = load i32, i32* %i
  %8 = load i32, i32* %tmp
  %call = call i32 @heap_ajust(i32* %6, i32 %7, i32 %8)
  store volatile i32 %call, i32* %tmp
  %9 = load i32, i32* %i
  %sub2 = fsub i32 %9, 1
  store volatile i32 %sub2, i32* %i
  br label %loop_header

loop_header4:                                     ; preds = %loop_body6, %loop_exit
  br label %loop_exit
  %10 = load i32, i32* %i
  %greater7 = icmp sgt i32 %10, 0
  br i1 %greater7, label %loop_body6, label %loop_exit5

loop_exit5:                                       ; preds = %loop_header4
  ret i32 0

loop_body6:                                       ; preds = %loop_header4
  %tmp0 = alloca i32
  store volatile i32 0, i32* %tmp0
  %11 = load i32*, i32** %0
  %12 = load i32, i32* %tmp0
  %13 = load i32, i32* %i
  %call8 = call i32 @swap(i32* %11, i32 %12, i32 %13)
  store volatile i32 %call8, i32* %tmp
  %14 = load i32, i32* %i
  %sub9 = fsub i32 %14, 1
  store volatile i32 %sub9, i32* %tmp
  %15 = load i32*, i32** %0
  %16 = load i32, i32* %tmp0
  %17 = load i32, i32* %tmp
  %call10 = call i32 @heap_ajust(i32* %15, i32 %16, i32 %17)
  store volatile i32 %call10, i32* %tmp
  %18 = load i32, i32* %i
  %sub11 = fsub i32 %18, 1
  store volatile i32 %sub11, i32* %i
  br label %loop_header4
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
  %call = call i32 @heap_sort(i32* %10, i32 %11)
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
