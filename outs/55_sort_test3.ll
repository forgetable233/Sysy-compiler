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
  %tmp = alloca i32
  store volatile i32 9, i32* %tmp
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* %i
  %12 = load i32, i32* %tmp
  %call = call i32 @QuickSort(i32* %10, i32 %11, i32 %12)
  store volatile i32 %call, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %13 = load i32, i32* %i
  %14 = load i32, i32* @n
  %less = icmp slt i32 %13, %14
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %tmp1 = alloca i32
  %15 = load i32, i32* %i
  %16 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %15
  %17 = load i32, i32* %16
  store volatile i32 %17, i32* %tmp1
  %18 = load i32, i32* %tmp1
  %call2 = call void @putint(i32 %18)
  store volatile i32 10, i32* %tmp1
  %19 = load i32, i32* %tmp1
  %call3 = call void @putch(i32 %19)
  %20 = load i32, i32* %i
  %add = fadd i32 %20, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
