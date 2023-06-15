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

define i32 @Merge(i32* %array, i32 %low, i32 %middle, i32 %high) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i32
  store i32* %array, i32** %0
  store i32 %low, i32* %1
  store i32 %middle, i32* %2
  store i32 %high, i32* %3
  %n1 = alloca i32
  %4 = load i32, i32* %2
  %5 = load i32, i32* %1
  %sub = fsub i32 %4, %5
  %add = fadd i32 %sub, 1
  store volatile i32 %add, i32* %n1
  %n2 = alloca i32
  %6 = load i32, i32* %3
  %7 = load i32, i32* %2
  %sub1 = fsub i32 %6, %7
  store volatile i32 %sub1, i32* %n2
  %L = alloca [10 x i32]
  %R = alloca [10 x i32]
  %i = alloca i32
  store volatile i32 0, i32* %i
  %j = alloca i32
  store volatile i32 0, i32* %j
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %8 = load i32, i32* %i
  %9 = load i32, i32* %n1
  %less = icmp slt i32 %8, %9
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header4, %loop_header
  br label %loop_header4

loop_body:                                        ; preds = %loop_header
  %10 = load i32*, i32** %0
  %11 = load i32, i32* %i
  %12 = load i32, i32* %1
  %add2 = fadd i32 %11, %12
  %13 = getelementptr i32, i32* %10, i32 %add2
  %14 = load i32, i32* %13
  %15 = load i32, i32* %i
  %16 = getelementptr [10 x i32], [10 x i32]* %L, i32 0, i32 %15
  store volatile i32 %14, i32* %16
  %17 = load i32, i32* %i
  %add3 = fadd i32 %17, 1
  store volatile i32 %add3, i32* %i
  br label %loop_header

loop_header4:                                     ; preds = %loop_body6, %loop_exit
  br label %loop_exit
  %18 = load i32, i32* %j
  %19 = load i32, i32* %n2
  %less7 = icmp slt i32 %18, %19
  br i1 %less7, label %loop_body6, label %loop_exit5

loop_exit5:                                       ; preds = %loop_header11, %loop_header4
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %j
  %k = alloca i32
  %20 = load i32, i32* %1
  store volatile i32 %20, i32* %k
  br label %loop_header11

loop_body6:                                       ; preds = %loop_header4
  %21 = load i32*, i32** %0
  %22 = load i32, i32* %j
  %23 = load i32, i32* %2
  %add8 = fadd i32 %22, %23
  %add9 = fadd i32 %add8, 1
  %24 = getelementptr i32, i32* %21, i32 %add9
  %25 = load i32, i32* %24
  %26 = load i32, i32* %j
  %27 = getelementptr [10 x i32], [10 x i32]* %R, i32 0, i32 %26
  store volatile i32 %25, i32* %27
  %28 = load i32, i32* %j
  %add10 = fadd i32 %28, 1
  store volatile i32 %add10, i32* %j
  br label %loop_header4

loop_header11:                                    ; preds = %merge_block, %loop_exit5
  br label %loop_exit5
  %29 = load i32, i32* %i
  %30 = load i32, i32* %n1
  %not_equal = icmp ne i32 %29, %30
  %31 = load i32, i32* %j
  %32 = load i32, i32* %n2
  %not_equal14 = icmp ne i32 %31, %32
  %and = and i1 %not_equal, %not_equal14
  br i1 %and, label %loop_body13, label %loop_exit12

loop_exit12:                                      ; preds = %loop_header21, %loop_header11
  br label %loop_header21

loop_body13:                                      ; preds = %loop_header11
  %33 = load i32, i32* %i
  %34 = getelementptr [10 x i32], [10 x i32]* %L, i32 0, i32 %33
  %35 = load i32, i32* %34
  %36 = load i32, i32* %j
  %37 = getelementptr [10 x i32], [10 x i32]* %R, i32 0, i32 %36
  %38 = load i32, i32* %37
  %add15 = fadd i32 %38, 1
  %less16 = icmp slt i32 %35, %add15
  br i1 %less16, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body13
  %39 = load i32*, i32** %0
  %40 = load i32, i32* %i
  %41 = getelementptr [10 x i32], [10 x i32]* %L, i32 0, i32 %40
  %42 = load i32, i32* %41
  %43 = load i32, i32* %k
  %44 = getelementptr i32, i32* %39, i32 %43
  store volatile i32 %42, i32* %44
  %45 = load i32, i32* %k
  %add17 = fadd i32 %45, 1
  store volatile i32 %add17, i32* %k
  %46 = load i32, i32* %i
  %add18 = fadd i32 %46, 1
  store volatile i32 %add18, i32* %i
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  br label %loop_header11

false_block:                                      ; preds = %loop_body13
  %47 = load i32*, i32** %0
  %48 = load i32, i32* %j
  %49 = getelementptr [10 x i32], [10 x i32]* %R, i32 0, i32 %48
  %50 = load i32, i32* %49
  %51 = load i32, i32* %k
  %52 = getelementptr i32, i32* %47, i32 %51
  store volatile i32 %50, i32* %52
  %53 = load i32, i32* %k
  %add19 = fadd i32 %53, 1
  store volatile i32 %add19, i32* %k
  %54 = load i32, i32* %j
  %add20 = fadd i32 %54, 1
  store volatile i32 %add20, i32* %j
  br label %merge_block

loop_header21:                                    ; preds = %loop_body23, %loop_exit12
  br label %loop_exit12
  %55 = load i32, i32* %i
  %56 = load i32, i32* %n1
  %less24 = icmp slt i32 %55, %56
  br i1 %less24, label %loop_body23, label %loop_exit22

loop_exit22:                                      ; preds = %loop_header27, %loop_header21
  br label %loop_header27

loop_body23:                                      ; preds = %loop_header21
  %57 = load i32*, i32** %0
  %58 = load i32, i32* %i
  %59 = getelementptr [10 x i32], [10 x i32]* %L, i32 0, i32 %58
  %60 = load i32, i32* %59
  %61 = load i32, i32* %k
  %62 = getelementptr i32, i32* %57, i32 %61
  store volatile i32 %60, i32* %62
  %63 = load i32, i32* %k
  %add25 = fadd i32 %63, 1
  store volatile i32 %add25, i32* %k
  %64 = load i32, i32* %i
  %add26 = fadd i32 %64, 1
  store volatile i32 %add26, i32* %i
  br label %loop_header21

loop_header27:                                    ; preds = %loop_body29, %loop_exit22
  br label %loop_exit22
  %65 = load i32, i32* %j
  %66 = load i32, i32* %n2
  %less30 = icmp slt i32 %65, %66
  br i1 %less30, label %loop_body29, label %loop_exit28

loop_exit28:                                      ; preds = %loop_header27
  ret i32 0

loop_body29:                                      ; preds = %loop_header27
  %67 = load i32*, i32** %0
  %68 = load i32, i32* %j
  %69 = getelementptr [10 x i32], [10 x i32]* %R, i32 0, i32 %68
  %70 = load i32, i32* %69
  %71 = load i32, i32* %k
  %72 = getelementptr i32, i32* %67, i32 %71
  store volatile i32 %70, i32* %72
  %73 = load i32, i32* %k
  %add31 = fadd i32 %73, 1
  store volatile i32 %add31, i32* %k
  %74 = load i32, i32* %j
  %add32 = fadd i32 %74, 1
  store volatile i32 %add32, i32* %j
  br label %loop_header27
}

define i32 @MergeSort(i32* %array, i32 %p, i32 %q) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  %2 = alloca i32
  store i32* %array, i32** %0
  store i32 %p, i32* %1
  store i32 %q, i32* %2
  %3 = load i32, i32* %1
  %4 = load i32, i32* %2
  %less = icmp slt i32 %3, %4
  br i1 %less, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  %mid = alloca i32
  %5 = load i32, i32* %1
  %6 = load i32, i32* %2
  %add = fadd i32 %5, %6
  %div = fdiv i32 %add, 2
  store volatile i32 %div, i32* %mid
  %tmp = alloca i32
  %7 = load i32*, i32** %0
  %8 = load i32, i32* %1
  %9 = load i32, i32* %mid
  %call = call i32 @MergeSort(i32* %7, i32 %8, i32 %9)
  store volatile i32 %call, i32* %tmp
  %10 = load i32, i32* %mid
  %add1 = fadd i32 %10, 1
  store volatile i32 %add1, i32* %tmp
  %11 = load i32*, i32** %0
  %12 = load i32, i32* %tmp
  %13 = load i32, i32* %2
  %call2 = call i32 @MergeSort(i32* %11, i32 %12, i32 %13)
  store volatile i32 %call2, i32* %tmp
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %1
  %16 = load i32, i32* %mid
  %17 = load i32, i32* %2
  %call3 = call i32 @Merge(i32* %14, i32 %15, i32 %16, i32 %17)
  store volatile i32 %call3, i32* %tmp
  br label %merge_block

merge_block:                                      ; preds = %true_block
  ret i32 0
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
  %10 = load i32, i32* @n
  %sub = fsub i32 %10, 1
  store volatile i32 %sub, i32* %tmp
  %11 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %12 = load i32, i32* %i
  %13 = load i32, i32* %tmp
  %call = call i32 @MergeSort(i32* %11, i32 %12, i32 %13)
  store volatile i32 %call, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %14 = load i32, i32* %i
  %15 = load i32, i32* @n
  %less = icmp slt i32 %14, %15
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %16 = load i32, i32* %i
  %17 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %16
  %18 = load i32, i32* %17
  store volatile i32 %18, i32* %tmp
  %19 = load i32, i32* %tmp
  %call1 = call void @putint(i32 %19)
  store volatile i32 10, i32* %tmp
  %20 = load i32, i32* %tmp
  %call2 = call void @putch(i32 %20)
  %21 = load i32, i32* %i
  %add = fadd i32 %21, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
