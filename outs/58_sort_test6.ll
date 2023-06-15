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

define i32 @counting_sort(i32* %ini_arr, i32* %sorted_arr, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32*
  %2 = alloca i32
  store i32* %ini_arr, i32** %0
  store i32* %sorted_arr, i32** %1
  store i32 %n, i32* %2
  %count_arr = alloca [10 x i32]
  %i = alloca i32
  %j = alloca i32
  %k = alloca i32
  store volatile i32 0, i32* %k
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %j
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %3 = load i32, i32* %k
  %less = icmp slt i32 %3, 10
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %k
  %5 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %4
  store volatile i32 0, i32* %5
  %6 = load i32, i32* %k
  %add = fadd i32 %6, 1
  store volatile i32 %add, i32* %k
  br label %loop_header

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %7 = load i32, i32* %i
  %8 = load i32, i32* %2
  %less4 = icmp slt i32 %7, %8
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header7, %loop_header1
  store volatile i32 1, i32* %k
  br label %loop_header7

loop_body3:                                       ; preds = %loop_header1
  %9 = load i32*, i32** %0
  %10 = load i32, i32* %i
  %11 = getelementptr i32, i32* %9, i32 %10
  %12 = load i32, i32* %11
  %13 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %12
  %14 = load i32, i32* %13
  %add5 = fadd i32 %14, 1
  %15 = load i32*, i32** %0
  %16 = load i32, i32* %i
  %17 = getelementptr i32, i32* %15, i32 %16
  %18 = load i32, i32* %17
  %19 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %18
  store volatile i32 %add5, i32* %19
  %20 = load i32, i32* %i
  %add6 = fadd i32 %20, 1
  store volatile i32 %add6, i32* %i
  br label %loop_header1

loop_header7:                                     ; preds = %loop_body9, %loop_exit2
  br label %loop_exit2
  %21 = load i32, i32* %k
  %less10 = icmp slt i32 %21, 10
  br i1 %less10, label %loop_body9, label %loop_exit8

loop_exit8:                                       ; preds = %loop_header13, %loop_header7
  %22 = load i32, i32* %2
  store volatile i32 %22, i32* %j
  br label %loop_header13

loop_body9:                                       ; preds = %loop_header7
  %23 = load i32, i32* %k
  %24 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %23
  %25 = load i32, i32* %24
  %26 = load i32, i32* %k
  %sub = fsub i32 %26, 1
  %27 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %sub
  %28 = load i32, i32* %27
  %add11 = fadd i32 %25, %28
  %29 = load i32, i32* %k
  %30 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %29
  store volatile i32 %add11, i32* %30
  %31 = load i32, i32* %k
  %add12 = fadd i32 %31, 1
  store volatile i32 %add12, i32* %k
  br label %loop_header7

loop_header13:                                    ; preds = %loop_body15, %loop_exit8
  br label %loop_exit8
  %32 = load i32, i32* %j
  %greater = icmp sgt i32 %32, 0
  br i1 %greater, label %loop_body15, label %loop_exit14

loop_exit14:                                      ; preds = %loop_header13
  ret i32 0

loop_body15:                                      ; preds = %loop_header13
  %33 = load i32*, i32** %0
  %34 = load i32, i32* %j
  %sub16 = fsub i32 %34, 1
  %35 = getelementptr i32, i32* %33, i32 %sub16
  %36 = load i32, i32* %35
  %37 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %36
  %38 = load i32, i32* %37
  %sub17 = fsub i32 %38, 1
  %39 = load i32*, i32** %0
  %40 = load i32, i32* %j
  %sub18 = fsub i32 %40, 1
  %41 = getelementptr i32, i32* %39, i32 %sub18
  %42 = load i32, i32* %41
  %43 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %42
  store volatile i32 %sub17, i32* %43
  %44 = load i32*, i32** %1
  %45 = load i32*, i32** %0
  %46 = load i32, i32* %j
  %sub19 = fsub i32 %46, 1
  %47 = getelementptr i32, i32* %45, i32 %sub19
  %48 = load i32, i32* %47
  %49 = load i32*, i32** %0
  %50 = load i32, i32* %j
  %sub20 = fsub i32 %50, 1
  %51 = getelementptr i32, i32* %49, i32 %sub20
  %52 = load i32, i32* %51
  %53 = getelementptr [10 x i32], [10 x i32]* %count_arr, i32 0, i32 %52
  %54 = load i32, i32* %53
  %55 = getelementptr i32, i32* %44, i32 %54
  store volatile i32 %48, i32* %55
  %56 = load i32, i32* %j
  %sub21 = fsub i32 %56, 1
  store volatile i32 %sub21, i32* %j
  br label %loop_header13
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
  %b = alloca [10 x i32]
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = getelementptr [10 x i32], [10 x i32]* %b, i32 0, i32 0
  %12 = load i32, i32* @n
  %call = call i32 @counting_sort(i32* %10, i32* %11, i32 %12)
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
  %tmp = alloca i32
  %15 = load i32, i32* %i
  %16 = getelementptr [10 x i32], [10 x i32]* %b, i32 0, i32 %15
  %17 = load i32, i32* %16
  store volatile i32 %17, i32* %tmp
  %18 = load i32, i32* %tmp
  %call1 = call void @putint(i32 %18)
  store volatile i32 10, i32* %tmp
  %19 = load i32, i32* %tmp
  %call2 = call void @putch(i32 %19)
  %20 = load i32, i32* %i
  %add = fadd i32 %20, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
