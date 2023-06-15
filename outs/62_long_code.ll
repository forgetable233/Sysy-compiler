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

define i32 @bubblesort(i32* %arr) {
begin:
  %0 = alloca i32*
  store i32* %arr, i32** %0
  %i = alloca i32
  %j = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_exit2, %begin
  br label %begin
  %1 = load i32, i32* %i
  %2 = load i32, i32* @n
  %sub = fsub i32 %2, 1
  %less = icmp slt i32 %1, %sub
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header1, %loop_header
  store volatile i32 0, i32* %j
  br label %loop_header1

loop_header1:                                     ; preds = %merge_block, %loop_body
  br label %loop_body
  %3 = load i32, i32* %j
  %4 = load i32, i32* @n
  %5 = load i32, i32* %i
  %sub4 = fsub i32 %4, %5
  %sub5 = fsub i32 %sub4, 1
  %less6 = icmp slt i32 %3, %sub5
  br i1 %less6, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %6 = load i32, i32* %i
  %add10 = fadd i32 %6, 1
  store volatile i32 %add10, i32* %i
  br label %loop_header

loop_body3:                                       ; preds = %loop_header1
  %7 = load i32*, i32** %0
  %8 = load i32, i32* %j
  %9 = getelementptr i32, i32* %7, i32 %8
  %10 = load i32, i32* %9
  %11 = load i32*, i32** %0
  %12 = load i32, i32* %j
  %add = fadd i32 %12, 1
  %13 = getelementptr i32, i32* %11, i32 %add
  %14 = load i32, i32* %13
  %greater = icmp sgt i32 %10, %14
  br i1 %greater, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body3
  %tmp = alloca i32
  %15 = load i32*, i32** %0
  %16 = load i32, i32* %j
  %add7 = fadd i32 %16, 1
  %17 = getelementptr i32, i32* %15, i32 %add7
  %18 = load i32, i32* %17
  store volatile i32 %18, i32* %tmp
  %19 = load i32*, i32** %0
  %20 = load i32*, i32** %0
  %21 = load i32, i32* %j
  %22 = getelementptr i32, i32* %20, i32 %21
  %23 = load i32, i32* %22
  %24 = load i32, i32* %j
  %add8 = fadd i32 %24, 1
  %25 = getelementptr i32, i32* %19, i32 %add8
  store volatile i32 %23, i32* %25
  %26 = load i32*, i32** %0
  %27 = load i32, i32* %tmp
  %28 = load i32, i32* %j
  %29 = getelementptr i32, i32* %26, i32 %28
  store volatile i32 %27, i32* %29
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %30 = load i32, i32* %j
  %add9 = fadd i32 %30, 1
  store volatile i32 %add9, i32* %j
  br label %loop_header1
}

define i32 @insertsort(i32* %a) {
begin:
  %0 = alloca i32*
  store i32* %a, i32** %0
  %i = alloca i32
  store volatile i32 1, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_exit2, %begin
  br label %begin
  %1 = load i32, i32* %i
  %2 = load i32, i32* @n
  %less = icmp slt i32 %1, %2
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header1, %loop_header
  %temp = alloca i32
  %3 = load i32*, i32** %0
  %4 = load i32, i32* %i
  %5 = getelementptr i32, i32* %3, i32 %4
  %6 = load i32, i32* %5
  store volatile i32 %6, i32* %temp
  %j = alloca i32
  %7 = load i32, i32* %i
  %sub = fsub i32 %7, 1
  store volatile i32 %sub, i32* %j
  br label %loop_header1

loop_header1:                                     ; preds = %loop_body3, %loop_body
  br label %loop_body
  %8 = load i32, i32* %j
  %greater = icmp sgt i32 %8, -1
  %9 = load i32, i32* %temp
  %10 = load i32*, i32** %0
  %11 = load i32, i32* %j
  %12 = getelementptr i32, i32* %10, i32 %11
  %13 = load i32, i32* %12
  %less4 = icmp slt i32 %9, %13
  %and = and i1 %greater, %less4
  br i1 %and, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %temp
  %16 = load i32, i32* %j
  %add6 = fadd i32 %16, 1
  %17 = getelementptr i32, i32* %14, i32 %add6
  store volatile i32 %15, i32* %17
  %18 = load i32, i32* %i
  %add7 = fadd i32 %18, 1
  store volatile i32 %add7, i32* %i
  br label %loop_header

loop_body3:                                       ; preds = %loop_header1
  %19 = load i32*, i32** %0
  %20 = load i32*, i32** %0
  %21 = load i32, i32* %j
  %22 = getelementptr i32, i32* %20, i32 %21
  %23 = load i32, i32* %22
  %24 = load i32, i32* %j
  %add = fadd i32 %24, 1
  %25 = getelementptr i32, i32* %19, i32 %add
  store volatile i32 %23, i32* %25
  %26 = load i32, i32* %j
  %sub5 = fsub i32 %26, 1
  store volatile i32 %sub5, i32* %j
  br label %loop_header1
}

define i32 @QuickSort(i32* %arr, i32 %low, i32 %high) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  %2 = alloca i32
  store i32* %arr, i32** %0
  store i32 %low, i32* %1
  store i32 %high, i32* %2
  %3 = load i32, i32* %1
  %4 = load i32, i32* %2
  %less = icmp slt i32 %3, %4
  br i1 %less, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_header, %begin
  %i = alloca i32
  %5 = load i32, i32* %1
  store volatile i32 %5, i32* %i
  %j = alloca i32
  %6 = load i32, i32* %2
  store volatile i32 %6, i32* %j
  %k = alloca i32
  %7 = load i32*, i32** %0
  %8 = load i32, i32* %1
  %9 = getelementptr i32, i32* %7, i32 %8
  %10 = load i32, i32* %9
  store volatile i32 %10, i32* %k
  br label %loop_header

merge_block:                                      ; preds = %loop_exit
  ret i32 0

loop_header:                                      ; preds = %merge_block19, %true_block
  br label %true_block
  %11 = load i32, i32* %i
  %12 = load i32, i32* %j
  %less1 = icmp slt i32 %11, %12
  br i1 %less1, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %13 = load i32*, i32** %0
  %14 = load i32, i32* %k
  %15 = load i32, i32* %i
  %16 = getelementptr i32, i32* %13, i32 %15
  store volatile i32 %14, i32* %16
  %tmp = alloca i32
  %17 = load i32, i32* %i
  %sub21 = fsub i32 %17, 1
  store volatile i32 %sub21, i32* %tmp
  %18 = load i32*, i32** %0
  %19 = load i32, i32* %1
  %20 = load i32, i32* %tmp
  %call = call i32 @QuickSort(i32* %18, i32 %19, i32 %20)
  store volatile i32 %call, i32* %tmp
  %21 = load i32, i32* %i
  %add22 = fadd i32 %21, 1
  store volatile i32 %add22, i32* %tmp
  %22 = load i32*, i32** %0
  %23 = load i32, i32* %tmp
  %24 = load i32, i32* %2
  %call23 = call i32 @QuickSort(i32* %22, i32 %23, i32 %24)
  store volatile i32 %call23, i32* %tmp
  br label %merge_block

loop_body:                                        ; preds = %loop_header2, %loop_header
  br label %loop_header2

loop_header2:                                     ; preds = %loop_body4, %loop_body
  br label %loop_body
  %25 = load i32, i32* %i
  %26 = load i32, i32* %j
  %less5 = icmp slt i32 %25, %26
  %27 = load i32*, i32** %0
  %28 = load i32, i32* %j
  %29 = getelementptr i32, i32* %27, i32 %28
  %30 = load i32, i32* %29
  %31 = load i32, i32* %k
  %sub = fsub i32 %31, 1
  %greater = icmp sgt i32 %30, %sub
  %and = and i1 %less5, %greater
  br i1 %and, label %loop_body4, label %loop_exit3

loop_exit3:                                       ; preds = %loop_header2
  %32 = load i32, i32* %i
  %33 = load i32, i32* %j
  %less7 = icmp slt i32 %32, %33
  br i1 %less7, label %true_block8, <null operand!>

loop_body4:                                       ; preds = %loop_header2
  %34 = load i32, i32* %j
  %sub6 = fsub i32 %34, 1
  store volatile i32 %sub6, i32* %j
  br label %loop_header2

true_block8:                                      ; preds = %loop_exit3
  %35 = load i32*, i32** %0
  %36 = load i32*, i32** %0
  %37 = load i32, i32* %j
  %38 = getelementptr i32, i32* %36, i32 %37
  %39 = load i32, i32* %38
  %40 = load i32, i32* %i
  %41 = getelementptr i32, i32* %35, i32 %40
  store volatile i32 %39, i32* %41
  %42 = load i32, i32* %i
  %add = fadd i32 %42, 1
  store volatile i32 %add, i32* %i
  br label %merge_block9

merge_block9:                                     ; preds = %loop_header10, %true_block8
  br label %loop_header10

loop_header10:                                    ; preds = %loop_body12, %merge_block9
  br label %merge_block9
  %43 = load i32, i32* %i
  %44 = load i32, i32* %j
  %less13 = icmp slt i32 %43, %44
  %45 = load i32*, i32** %0
  %46 = load i32, i32* %i
  %47 = getelementptr i32, i32* %45, i32 %46
  %48 = load i32, i32* %47
  %49 = load i32, i32* %k
  %less14 = icmp slt i32 %48, %49
  %and15 = and i1 %less13, %less14
  br i1 %and15, label %loop_body12, label %loop_exit11

loop_exit11:                                      ; preds = %loop_header10
  %50 = load i32, i32* %i
  %51 = load i32, i32* %j
  %less17 = icmp slt i32 %50, %51
  br i1 %less17, label %true_block18, <null operand!>

loop_body12:                                      ; preds = %loop_header10
  %52 = load i32, i32* %i
  %add16 = fadd i32 %52, 1
  store volatile i32 %add16, i32* %i
  br label %loop_header10

true_block18:                                     ; preds = %loop_exit11
  %53 = load i32*, i32** %0
  %54 = load i32*, i32** %0
  %55 = load i32, i32* %i
  %56 = getelementptr i32, i32* %54, i32 %55
  %57 = load i32, i32* %56
  %58 = load i32, i32* %j
  %59 = getelementptr i32, i32* %53, i32 %58
  store volatile i32 %57, i32* %59
  %60 = load i32, i32* %j
  %sub20 = fsub i32 %60, 1
  store volatile i32 %sub20, i32* %j
  br label %merge_block19

merge_block19:                                    ; preds = %true_block18
  br label %loop_header
}

define i32 @getMid(i32* %arr) {
begin:
  %0 = alloca i32*
  store i32* %arr, i32** %0
  %mid = alloca i32
  %1 = load i32, i32* @n
  %mod = urem i32 %1, 2
  %equal = icmp eq i32 %mod, 0
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  %2 = load i32, i32* @n
  %div = fdiv i32 %2, 2
  store volatile i32 %div, i32* %mid
  %3 = load i32*, i32** %0
  %4 = load i32, i32* %mid
  %5 = getelementptr i32, i32* %3, i32 %4
  %6 = load i32, i32* %5
  %7 = load i32*, i32** %0
  %8 = load i32, i32* %mid
  %sub = fsub i32 %8, 1
  %9 = getelementptr i32, i32* %7, i32 %sub
  %10 = load i32, i32* %9
  %add = fadd i32 %6, %10
  %div1 = fdiv i32 %add, 2
  ret i32 %div1
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block

false_block:                                      ; preds = %begin
  %11 = load i32, i32* @n
  %div2 = fdiv i32 %11, 2
  store volatile i32 %div2, i32* %mid
  %12 = load i32*, i32** %0
  %13 = load i32, i32* %mid
  %14 = getelementptr i32, i32* %12, i32 %13
  %15 = load i32, i32* %14
  ret i32 %15
  br label %merge_block
}

define i32 @getMost(i32* %arr) {
begin:
  %0 = alloca i32*
  store i32* %arr, i32** %0
  %count = alloca [1000 x i32]
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %1 = load i32, i32* %i
  %less = icmp slt i32 %1, 1000
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  store volatile i32 0, i32* %i
  %max = alloca i32
  %number = alloca i32
  store volatile i32 0, i32* %max
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* %i
  %3 = getelementptr [1000 x i32], [1000 x i32]* %count, i32 0, i32 %2
  store volatile i32 0, i32* %3
  %4 = load i32, i32* %i
  %add = fadd i32 %4, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header1:                                     ; preds = %merge_block, %loop_exit
  br label %loop_exit
  %5 = load i32, i32* %i
  %6 = load i32, i32* @n
  %less4 = icmp slt i32 %5, %6
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %7 = load i32, i32* %number
  ret i32 %7

loop_body3:                                       ; preds = %loop_header1
  %num = alloca i32
  %8 = load i32*, i32** %0
  %9 = load i32, i32* %i
  %10 = getelementptr i32, i32* %8, i32 %9
  %11 = load i32, i32* %10
  store volatile i32 %11, i32* %num
  %12 = load i32, i32* %num
  %13 = getelementptr [1000 x i32], [1000 x i32]* %count, i32 0, i32 %12
  %14 = load i32, i32* %13
  %add5 = fadd i32 %14, 1
  %15 = load i32, i32* %num
  %16 = getelementptr [1000 x i32], [1000 x i32]* %count, i32 0, i32 %15
  store volatile i32 %add5, i32* %16
  %17 = load i32, i32* %num
  %18 = getelementptr [1000 x i32], [1000 x i32]* %count, i32 0, i32 %17
  %19 = load i32, i32* %18
  %20 = load i32, i32* %max
  %greater = icmp sgt i32 %19, %20
  br i1 %greater, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body3
  %21 = load i32, i32* %num
  %22 = getelementptr [1000 x i32], [1000 x i32]* %count, i32 0, i32 %21
  %23 = load i32, i32* %22
  store volatile i32 %23, i32* %max
  %24 = load i32, i32* %num
  store volatile i32 %24, i32* %number
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %25 = load i32, i32* %i
  %add6 = fadd i32 %25, 1
  store volatile i32 %add6, i32* %i
  br label %loop_header1
}

define i32 @revert(i32* %arr) {
begin:
  %0 = alloca i32*
  store i32* %arr, i32** %0
  %temp = alloca i32
  %i = alloca i32
  %j = alloca i32
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %j
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %1 = load i32, i32* %i
  %2 = load i32, i32* %j
  %less = icmp slt i32 %1, %2
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %3 = load i32*, i32** %0
  %4 = load i32, i32* %i
  %5 = getelementptr i32, i32* %3, i32 %4
  %6 = load i32, i32* %5
  store volatile i32 %6, i32* %temp
  %7 = load i32*, i32** %0
  %8 = load i32*, i32** %0
  %9 = load i32, i32* %j
  %10 = getelementptr i32, i32* %8, i32 %9
  %11 = load i32, i32* %10
  %12 = load i32, i32* %i
  %13 = getelementptr i32, i32* %7, i32 %12
  store volatile i32 %11, i32* %13
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %temp
  %16 = load i32, i32* %j
  %17 = getelementptr i32, i32* %14, i32 %16
  store volatile i32 %15, i32* %17
  %18 = load i32, i32* %i
  %add = fadd i32 %18, 1
  store volatile i32 %add, i32* %i
  %19 = load i32, i32* %j
  %sub = fsub i32 %19, 1
  store volatile i32 %sub, i32* %j
  br label %loop_header
}

define i32 @arrCopy(i32* %src, i32* %target) {
begin:
  %0 = alloca i32*
  %1 = alloca i32*
  store i32* %src, i32** %0
  store i32* %target, i32** %1
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %2 = load i32, i32* %i
  %3 = load i32, i32* @n
  %less = icmp slt i32 %2, %3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %4 = load i32*, i32** %1
  %5 = load i32*, i32** %0
  %6 = load i32, i32* %i
  %7 = getelementptr i32, i32* %5, i32 %6
  %8 = load i32, i32* %7
  %9 = load i32, i32* %i
  %10 = getelementptr i32, i32* %4, i32 %9
  store volatile i32 %8, i32* %10
  %11 = load i32, i32* %i
  %add = fadd i32 %11, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}

define i32 @calSum(i32* %arr, i32 %stride) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %arr, i32** %0
  store i32 %stride, i32* %1
  %sum = alloca i32
  store volatile i32 0, i32* %sum
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %2 = load i32, i32* %i
  %3 = load i32, i32* @n
  %less = icmp slt i32 %2, %3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %sum
  %5 = load i32*, i32** %0
  %6 = load i32, i32* %i
  %7 = getelementptr i32, i32* %5, i32 %6
  %8 = load i32, i32* %7
  %add = fadd i32 %4, %8
  store volatile i32 %add, i32* %sum
  %9 = load i32, i32* %i
  %10 = load i32, i32* %1
  %mod = urem i32 %9, %10
  %11 = load i32, i32* %1
  %sub = fsub i32 %11, 1
  %not_equal = icmp ne i32 %mod, %sub
  br i1 %not_equal, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body
  %12 = load i32*, i32** %0
  %13 = load i32, i32* %i
  %14 = getelementptr i32, i32* %12, i32 %13
  store volatile i32 0, i32* %14
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  %15 = load i32, i32* %i
  %add1 = fadd i32 %15, 1
  store volatile i32 %add1, i32* %i
  br label %loop_header

false_block:                                      ; preds = %loop_body
  %16 = load i32*, i32** %0
  %17 = load i32, i32* %sum
  %18 = load i32, i32* %i
  %19 = getelementptr i32, i32* %16, i32 %18
  store volatile i32 %17, i32* %19
  store volatile i32 0, i32* %sum
  br label %merge_block
}

define i32 @avgPooling(i32* %arr, i32 %stride) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %arr, i32** %0
  store i32 %stride, i32* %1
  %sum = alloca i32
  %i = alloca i32
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %sum
  %lastnum = alloca i32
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %2 = load i32, i32* %i
  %3 = load i32, i32* @n
  %less = icmp slt i32 %2, %3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header16, %loop_header
  %4 = load i32, i32* @n
  %5 = load i32, i32* %1
  %sub14 = fsub i32 %4, %5
  %add15 = fadd i32 %sub14, 1
  store volatile i32 %add15, i32* %i
  br label %loop_header16

loop_body:                                        ; preds = %loop_header
  %6 = load i32, i32* %i
  %7 = load i32, i32* %1
  %sub = fsub i32 %7, 1
  %less1 = icmp slt i32 %6, %sub
  br i1 %less1, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body
  %8 = load i32, i32* %sum
  %9 = load i32*, i32** %0
  %10 = load i32, i32* %i
  %11 = getelementptr i32, i32* %9, i32 %10
  %12 = load i32, i32* %11
  %add = fadd i32 %8, %12
  store volatile i32 %add, i32* %sum
  br label %merge_block

merge_block:                                      ; preds = %merge_block4, %true_block
  %13 = load i32, i32* %i
  %add13 = fadd i32 %13, 1
  store volatile i32 %add13, i32* %i
  br label %loop_header

false_block:                                      ; preds = %loop_body
  %14 = load i32, i32* %i
  %15 = load i32, i32* %1
  %sub2 = fsub i32 %15, 1
  %equal = icmp eq i32 %14, %sub2
  br i1 %equal, label %true_block3, label %false_block5

true_block3:                                      ; preds = %false_block
  %16 = load i32*, i32** %0
  %17 = getelementptr i32, i32* %16, i32 0
  %18 = load i32, i32* %17
  store volatile i32 %18, i32* %lastnum
  %19 = load i32*, i32** %0
  %20 = load i32, i32* %sum
  %21 = load i32, i32* %1
  %div = fdiv i32 %20, %21
  %22 = getelementptr i32, i32* %19, i32 0
  store volatile i32 %div, i32* %22
  br label %merge_block4

merge_block4:                                     ; preds = %false_block5, %true_block3
  br label %merge_block

false_block5:                                     ; preds = %false_block
  %23 = load i32, i32* %sum
  %24 = load i32*, i32** %0
  %25 = load i32, i32* %i
  %26 = getelementptr i32, i32* %24, i32 %25
  %27 = load i32, i32* %26
  %add6 = fadd i32 %23, %27
  %28 = load i32, i32* %lastnum
  %sub7 = fsub i32 %add6, %28
  store volatile i32 %sub7, i32* %sum
  %29 = load i32*, i32** %0
  %30 = load i32, i32* %i
  %31 = load i32, i32* %1
  %sub8 = fsub i32 %30, %31
  %add9 = fadd i32 %sub8, 1
  %32 = getelementptr i32, i32* %29, i32 %add9
  %33 = load i32, i32* %32
  store volatile i32 %33, i32* %lastnum
  %34 = load i32*, i32** %0
  %35 = load i32, i32* %sum
  %36 = load i32, i32* %1
  %div10 = fdiv i32 %35, %36
  %37 = load i32, i32* %i
  %38 = load i32, i32* %1
  %sub11 = fsub i32 %37, %38
  %add12 = fadd i32 %sub11, 1
  %39 = getelementptr i32, i32* %34, i32 %add12
  store volatile i32 %div10, i32* %39
  br label %merge_block4

loop_header16:                                    ; preds = %loop_body18, %loop_exit
  br label %loop_exit
  %40 = load i32, i32* %i
  %41 = load i32, i32* @n
  %less19 = icmp slt i32 %40, %41
  br i1 %less19, label %loop_body18, label %loop_exit17

loop_exit17:                                      ; preds = %loop_header16
  ret i32 0

loop_body18:                                      ; preds = %loop_header16
  %42 = load i32*, i32** %0
  %43 = load i32, i32* %i
  %44 = getelementptr i32, i32* %42, i32 %43
  store volatile i32 0, i32* %44
  %45 = load i32, i32* %i
  %add20 = fadd i32 %45, 1
  store volatile i32 %add20, i32* %i
  br label %loop_header16
}

define i32 @main() {
begin:
  store volatile i32 32, i32* @n
  %arr = alloca [32 x i32]
  %result = alloca [32 x i32]
  %0 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  store volatile i32 7, i32* %0
  %1 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 1
  store volatile i32 23, i32* %1
  %2 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 2
  store volatile i32 89, i32* %2
  %3 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 3
  store volatile i32 26, i32* %3
  %4 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 4
  store volatile i32 282, i32* %4
  %5 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 5
  store volatile i32 254, i32* %5
  %6 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 6
  store volatile i32 27, i32* %6
  %7 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 7
  store volatile i32 5, i32* %7
  %8 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 8
  store volatile i32 83, i32* %8
  %9 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 9
  store volatile i32 273, i32* %9
  %10 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 10
  store volatile i32 574, i32* %10
  %11 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 11
  store volatile i32 905, i32* %11
  %12 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 12
  store volatile i32 354, i32* %12
  %13 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 13
  store volatile i32 657, i32* %13
  %14 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 14
  store volatile i32 935, i32* %14
  %15 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 15
  store volatile i32 264, i32* %15
  %16 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 16
  store volatile i32 639, i32* %16
  %17 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 17
  store volatile i32 459, i32* %17
  %18 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 18
  store volatile i32 29, i32* %18
  %19 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 19
  store volatile i32 68, i32* %19
  %20 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 20
  store volatile i32 929, i32* %20
  %21 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 21
  store volatile i32 756, i32* %21
  %22 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 22
  store volatile i32 452, i32* %22
  %23 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 23
  store volatile i32 279, i32* %23
  %24 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 24
  store volatile i32 58, i32* %24
  %25 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 25
  store volatile i32 87, i32* %25
  %26 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 26
  store volatile i32 96, i32* %26
  %27 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 27
  store volatile i32 36, i32* %27
  %28 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 28
  store volatile i32 39, i32* %28
  %29 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 29
  store volatile i32 28, i32* %29
  %30 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 30
  store volatile i32 1, i32* %30
  %31 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 31
  store volatile i32 290, i32* %31
  %t = alloca i32
  %32 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  %33 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call = call i32 @arrCopy(i32* %32, i32* %33)
  store volatile i32 %call, i32* %t
  %34 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call1 = call i32 @revert(i32* %34)
  store volatile i32 %call1, i32* %t
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %35 = load i32, i32* %i
  %less = icmp slt i32 %35, 32
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header4, %loop_header
  %36 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call3 = call i32 @bubblesort(i32* %36)
  store volatile i32 %call3, i32* %t
  store volatile i32 0, i32* %i
  br label %loop_header4

loop_body:                                        ; preds = %loop_header
  %37 = load i32, i32* %i
  %38 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %37
  %39 = load i32, i32* %38
  store volatile i32 %39, i32* %t
  %40 = load i32, i32* %t
  %call2 = call void @putint(i32 %40)
  %41 = load i32, i32* %i
  %add = fadd i32 %41, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header4:                                     ; preds = %loop_body6, %loop_exit
  br label %loop_exit
  %42 = load i32, i32* %i
  %less7 = icmp slt i32 %42, 32
  br i1 %less7, label %loop_body6, label %loop_exit5

loop_exit5:                                       ; preds = %loop_header16, %loop_header4
  %43 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call10 = call i32 @getMid(i32* %43)
  store volatile i32 %call10, i32* %t
  %44 = load i32, i32* %t
  %call11 = call void @putint(i32 %44)
  %45 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call12 = call i32 @getMost(i32* %45)
  store volatile i32 %call12, i32* %t
  %46 = load i32, i32* %t
  %call13 = call void @putint(i32 %46)
  %47 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  %48 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call14 = call i32 @arrCopy(i32* %47, i32* %48)
  store volatile i32 %call14, i32* %t
  %49 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call15 = call i32 @bubblesort(i32* %49)
  store volatile i32 %call15, i32* %t
  store volatile i32 0, i32* %i
  br label %loop_header16

loop_body6:                                       ; preds = %loop_header4
  %50 = load i32, i32* %i
  %51 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %50
  %52 = load i32, i32* %51
  store volatile i32 %52, i32* %t
  %53 = load i32, i32* %t
  %call8 = call void @putint(i32 %53)
  %54 = load i32, i32* %i
  %add9 = fadd i32 %54, 1
  store volatile i32 %add9, i32* %i
  br label %loop_header4

loop_header16:                                    ; preds = %loop_body18, %loop_exit5
  br label %loop_exit5
  %55 = load i32, i32* %i
  %less19 = icmp slt i32 %55, 32
  br i1 %less19, label %loop_body18, label %loop_exit17

loop_exit17:                                      ; preds = %loop_header24, %loop_header16
  %56 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  %57 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call22 = call i32 @arrCopy(i32* %56, i32* %57)
  store volatile i32 %call22, i32* %t
  %58 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call23 = call i32 @insertsort(i32* %58)
  store volatile i32 %call23, i32* %t
  store volatile i32 0, i32* %i
  br label %loop_header24

loop_body18:                                      ; preds = %loop_header16
  %59 = load i32, i32* %i
  %60 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %59
  %61 = load i32, i32* %60
  store volatile i32 %61, i32* %t
  %62 = load i32, i32* %t
  %call20 = call void @putint(i32 %62)
  %63 = load i32, i32* %i
  %add21 = fadd i32 %63, 1
  store volatile i32 %add21, i32* %i
  br label %loop_header16

loop_header24:                                    ; preds = %loop_body26, %loop_exit17
  br label %loop_exit17
  %64 = load i32, i32* %i
  %less27 = icmp slt i32 %64, 32
  br i1 %less27, label %loop_body26, label %loop_exit25

loop_exit25:                                      ; preds = %loop_header32, %loop_header24
  %65 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  %66 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call30 = call i32 @arrCopy(i32* %65, i32* %66)
  store volatile i32 %call30, i32* %t
  store volatile i32 0, i32* %i
  store volatile i32 31, i32* %t
  %67 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %68 = load i32, i32* %i
  %69 = load i32, i32* %t
  %call31 = call i32 @QuickSort(i32* %67, i32 %68, i32 %69)
  store volatile i32 %call31, i32* %t
  br label %loop_header32

loop_body26:                                      ; preds = %loop_header24
  %70 = load i32, i32* %i
  %71 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %70
  %72 = load i32, i32* %71
  store volatile i32 %72, i32* %t
  %73 = load i32, i32* %t
  %call28 = call void @putint(i32 %73)
  %74 = load i32, i32* %i
  %add29 = fadd i32 %74, 1
  store volatile i32 %add29, i32* %i
  br label %loop_header24

loop_header32:                                    ; preds = %loop_body34, %loop_exit25
  br label %loop_exit25
  %75 = load i32, i32* %i
  %less35 = icmp slt i32 %75, 32
  br i1 %less35, label %loop_body34, label %loop_exit33

loop_exit33:                                      ; preds = %loop_header40, %loop_header32
  %76 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  %77 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call38 = call i32 @arrCopy(i32* %76, i32* %77)
  store volatile i32 %call38, i32* %t
  %78 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call39 = call i32 @calSum(i32* %78, i32 4)
  store volatile i32 %call39, i32* %t
  store volatile i32 0, i32* %i
  br label %loop_header40

loop_body34:                                      ; preds = %loop_header32
  %79 = load i32, i32* %i
  %80 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %79
  %81 = load i32, i32* %80
  store volatile i32 %81, i32* %t
  %82 = load i32, i32* %t
  %call36 = call void @putint(i32 %82)
  %83 = load i32, i32* %i
  %add37 = fadd i32 %83, 1
  store volatile i32 %add37, i32* %i
  br label %loop_header32

loop_header40:                                    ; preds = %loop_body42, %loop_exit33
  br label %loop_exit33
  %84 = load i32, i32* %i
  %less43 = icmp slt i32 %84, 32
  br i1 %less43, label %loop_body42, label %loop_exit41

loop_exit41:                                      ; preds = %loop_header48, %loop_header40
  %85 = getelementptr [32 x i32], [32 x i32]* %arr, i32 0, i32 0
  %86 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call46 = call i32 @arrCopy(i32* %85, i32* %86)
  store volatile i32 %call46, i32* %t
  %87 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 0
  %call47 = call i32 @avgPooling(i32* %87, i32 3)
  store volatile i32 %call47, i32* %t
  store volatile i32 0, i32* %i
  br label %loop_header48

loop_body42:                                      ; preds = %loop_header40
  %88 = load i32, i32* %i
  %89 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %88
  %90 = load i32, i32* %89
  store volatile i32 %90, i32* %t
  %91 = load i32, i32* %t
  %call44 = call void @putint(i32 %91)
  %92 = load i32, i32* %i
  %add45 = fadd i32 %92, 1
  store volatile i32 %add45, i32* %i
  br label %loop_header40

loop_header48:                                    ; preds = %loop_body50, %loop_exit41
  br label %loop_exit41
  %93 = load i32, i32* %i
  %less51 = icmp slt i32 %93, 32
  br i1 %less51, label %loop_body50, label %loop_exit49

loop_exit49:                                      ; preds = %loop_header48
  ret i32 0

loop_body50:                                      ; preds = %loop_header48
  %94 = load i32, i32* %i
  %95 = getelementptr [32 x i32], [32 x i32]* %result, i32 0, i32 %94
  %96 = load i32, i32* %95
  store volatile i32 %96, i32* %t
  %97 = load i32, i32* %t
  %call52 = call void @putint(i32 %97)
  %98 = load i32, i32* %i
  %add53 = fadd i32 %98, 1
  store volatile i32 %add53, i32* %i
  br label %loop_header48
}
