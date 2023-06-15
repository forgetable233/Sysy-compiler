; ModuleID = 'default'
source_filename = "default"

@M = global i32 0
@L = global i32 0
@N = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @tran(i32* %a0, i32* %a1, i32* %a2, i32* %b0, i32* %b1, i32* %b2, i32* %c0, i32* %c1, i32* %c2) {
begin:
  %0 = alloca i32*
  %1 = alloca i32*
  %2 = alloca i32*
  %3 = alloca i32*
  %4 = alloca i32*
  %5 = alloca i32*
  %6 = alloca i32*
  %7 = alloca i32*
  %8 = alloca i32*
  store i32* %a0, i32** %0
  store i32* %a1, i32** %1
  store i32* %a2, i32** %2
  store i32* %b0, i32** %3
  store i32* %b1, i32** %4
  store i32* %b2, i32** %5
  store i32* %c0, i32** %6
  store i32* %c1, i32** %7
  store i32* %c2, i32** %8
  %i = alloca i32
  store volatile i32 0, i32* %i
  %9 = load i32*, i32** %7
  %10 = load i32*, i32** %2
  %11 = getelementptr i32, i32* %10, i32 1
  %12 = load i32, i32* %11
  %13 = getelementptr i32, i32* %9, i32 2
  store volatile i32 %12, i32* %13
  %14 = load i32*, i32** %8
  %15 = load i32*, i32** %1
  %16 = getelementptr i32, i32* %15, i32 2
  %17 = load i32, i32* %16
  %18 = getelementptr i32, i32* %14, i32 1
  store volatile i32 %17, i32* %18
  %19 = load i32*, i32** %6
  %20 = load i32*, i32** %1
  %21 = getelementptr i32, i32* %20, i32 0
  %22 = load i32, i32* %21
  %23 = getelementptr i32, i32* %19, i32 1
  store volatile i32 %22, i32* %23
  %24 = load i32*, i32** %6
  %25 = load i32*, i32** %2
  %26 = getelementptr i32, i32* %25, i32 0
  %27 = load i32, i32* %26
  %28 = getelementptr i32, i32* %24, i32 2
  store volatile i32 %27, i32* %28
  %29 = load i32*, i32** %7
  %30 = load i32*, i32** %0
  %31 = getelementptr i32, i32* %30, i32 1
  %32 = load i32, i32* %31
  %33 = getelementptr i32, i32* %29, i32 0
  store volatile i32 %32, i32* %33
  %34 = load i32*, i32** %8
  %35 = load i32*, i32** %0
  %36 = getelementptr i32, i32* %35, i32 2
  %37 = load i32, i32* %36
  %38 = getelementptr i32, i32* %34, i32 0
  store volatile i32 %37, i32* %38
  %39 = load i32*, i32** %7
  %40 = load i32*, i32** %1
  %41 = getelementptr i32, i32* %40, i32 1
  %42 = load i32, i32* %41
  %43 = getelementptr i32, i32* %39, i32 1
  store volatile i32 %42, i32* %43
  %44 = load i32*, i32** %8
  %45 = load i32*, i32** %2
  %46 = getelementptr i32, i32* %45, i32 2
  %47 = load i32, i32* %46
  %48 = getelementptr i32, i32* %44, i32 2
  store volatile i32 %47, i32* %48
  %49 = load i32*, i32** %6
  %50 = load i32*, i32** %0
  %51 = getelementptr i32, i32* %50, i32 0
  %52 = load i32, i32* %51
  %53 = getelementptr i32, i32* %49, i32 0
  store volatile i32 %52, i32* %53
  ret i32 0
}

define i32 @main() {
begin:
  store volatile i32 3, i32* @N
  store volatile i32 3, i32* @M
  store volatile i32 3, i32* @L
  %a0 = alloca [3 x i32]
  %a1 = alloca [3 x i32]
  %a2 = alloca [3 x i32]
  %b0 = alloca [3 x i32]
  %b1 = alloca [3 x i32]
  %b2 = alloca [3 x i32]
  %c0 = alloca [6 x i32]
  %c1 = alloca [3 x i32]
  %c2 = alloca [3 x i32]
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %i
  %1 = load i32, i32* @M
  %less = icmp slt i32 %0, %1
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  %2 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 0
  %3 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 0
  %4 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 0
  %5 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 0
  %6 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 0
  %7 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 0
  %8 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 0
  %9 = getelementptr [3 x i32], [3 x i32]* %c1, i32 0, i32 0
  %10 = getelementptr [3 x i32], [3 x i32]* %c2, i32 0, i32 0
  %call = call i32 @tran(i32* %2, i32* %3, i32* %4, i32* %5, i32* %6, i32* %7, i32* %8, i32* %9, i32* %10)
  store volatile i32 %call, i32* %i
  %x = alloca i32
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %11 = load i32, i32* %i
  %12 = load i32, i32* %i
  %13 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 %12
  store volatile i32 %11, i32* %13
  %14 = load i32, i32* %i
  %15 = load i32, i32* %i
  %16 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 %15
  store volatile i32 %14, i32* %16
  %17 = load i32, i32* %i
  %18 = load i32, i32* %i
  %19 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 %18
  store volatile i32 %17, i32* %19
  %20 = load i32, i32* %i
  %21 = load i32, i32* %i
  %22 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 %21
  store volatile i32 %20, i32* %22
  %23 = load i32, i32* %i
  %24 = load i32, i32* %i
  %25 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 %24
  store volatile i32 %23, i32* %25
  %26 = load i32, i32* %i
  %27 = load i32, i32* %i
  %28 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 %27
  store volatile i32 %26, i32* %28
  %29 = load i32, i32* %i
  %add = fadd i32 %29, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %30 = load i32, i32* %i
  %31 = load i32, i32* @N
  %less4 = icmp slt i32 %30, %31
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header8, %loop_header1
  store volatile i32 10, i32* %x
  %32 = load i32, i32* %x
  %call7 = call void @putch(i32 %32)
  store volatile i32 0, i32* %i
  br label %loop_header8

loop_body3:                                       ; preds = %loop_header1
  %33 = load i32, i32* %i
  %34 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 %33
  %35 = load i32, i32* %34
  store volatile i32 %35, i32* %x
  %36 = load i32, i32* %x
  %call5 = call void @putint(i32 %36)
  %37 = load i32, i32* %i
  %add6 = fadd i32 %37, 1
  store volatile i32 %add6, i32* %i
  br label %loop_header1

loop_header8:                                     ; preds = %loop_body10, %loop_exit2
  br label %loop_exit2
  %38 = load i32, i32* %i
  %39 = load i32, i32* @N
  %less11 = icmp slt i32 %38, %39
  br i1 %less11, label %loop_body10, label %loop_exit9

loop_exit9:                                       ; preds = %loop_header15, %loop_header8
  store volatile i32 10, i32* %x
  store volatile i32 0, i32* %i
  %40 = load i32, i32* %x
  %call14 = call void @putch(i32 %40)
  br label %loop_header15

loop_body10:                                      ; preds = %loop_header8
  %41 = load i32, i32* %i
  %42 = getelementptr [3 x i32], [3 x i32]* %c1, i32 0, i32 %41
  %43 = load i32, i32* %42
  store volatile i32 %43, i32* %x
  %44 = load i32, i32* %x
  %call12 = call void @putint(i32 %44)
  %45 = load i32, i32* %i
  %add13 = fadd i32 %45, 1
  store volatile i32 %add13, i32* %i
  br label %loop_header8

loop_header15:                                    ; preds = %loop_body17, %loop_exit9
  br label %loop_exit9
  %46 = load i32, i32* %i
  %47 = load i32, i32* @N
  %less18 = icmp slt i32 %46, %47
  br i1 %less18, label %loop_body17, label %loop_exit16

loop_exit16:                                      ; preds = %loop_header15
  store volatile i32 10, i32* %x
  %48 = load i32, i32* %x
  %call21 = call void @putch(i32 %48)
  ret i32 0

loop_body17:                                      ; preds = %loop_header15
  %49 = load i32, i32* %i
  %50 = getelementptr [3 x i32], [3 x i32]* %c2, i32 0, i32 %49
  %51 = load i32, i32* %50
  store volatile i32 %51, i32* %x
  %52 = load i32, i32* %x
  %call19 = call void @putint(i32 %52)
  %53 = load i32, i32* %i
  %add20 = fadd i32 %53, 1
  store volatile i32 %add20, i32* %i
  br label %loop_header15
}
