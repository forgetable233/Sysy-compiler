; ModuleID = 'default'
source_filename = "default"

@N = global i32 0
@M = global i32 0
@L = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @sub(i32* %a0, i32* %a1, i32* %a2, i32* %b0, i32* %b1, i32* %b2, i32* %c0, i32* %c1, i32* %c2) {
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
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %9 = load i32, i32* %i
  %less = icmp slt i32 %9, 3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %10 = load i32*, i32** %6
  %11 = load i32*, i32** %0
  %12 = load i32, i32* %i
  %13 = getelementptr i32, i32* %11, i32 %12
  %14 = load i32, i32* %13
  %15 = load i32*, i32** %3
  %16 = load i32, i32* %i
  %17 = getelementptr i32, i32* %15, i32 %16
  %18 = load i32, i32* %17
  %sub = fsub i32 %14, %18
  %19 = load i32, i32* %i
  %20 = getelementptr i32, i32* %10, i32 %19
  store volatile i32 %sub, i32* %20
  %21 = load i32*, i32** %7
  %22 = load i32*, i32** %1
  %23 = load i32, i32* %i
  %24 = getelementptr i32, i32* %22, i32 %23
  %25 = load i32, i32* %24
  %26 = load i32*, i32** %4
  %27 = load i32, i32* %i
  %28 = getelementptr i32, i32* %26, i32 %27
  %29 = load i32, i32* %28
  %sub1 = fsub i32 %25, %29
  %30 = load i32, i32* %i
  %31 = getelementptr i32, i32* %21, i32 %30
  store volatile i32 %sub1, i32* %31
  %32 = load i32*, i32** %8
  %33 = load i32*, i32** %2
  %34 = load i32, i32* %i
  %35 = getelementptr i32, i32* %33, i32 %34
  %36 = load i32, i32* %35
  %37 = load i32*, i32** %5
  %38 = load i32, i32* %i
  %39 = getelementptr i32, i32* %37, i32 %38
  %40 = load i32, i32* %39
  %sub2 = fsub i32 %36, %40
  %41 = load i32, i32* %i
  %42 = getelementptr i32, i32* %32, i32 %41
  store volatile i32 %sub2, i32* %42
  %43 = load i32, i32* %i
  %add = fadd i32 %43, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
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
  %less = icmp slt i32 %0, 3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  %1 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 0
  %2 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 0
  %3 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 0
  %4 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 0
  %5 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 0
  %6 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 0
  %7 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 0
  %8 = getelementptr [3 x i32], [3 x i32]* %c1, i32 0, i32 0
  %9 = getelementptr [3 x i32], [3 x i32]* %c2, i32 0, i32 0
  %call = call i32 @sub(i32* %1, i32* %2, i32* %3, i32* %4, i32* %5, i32* %6, i32* %7, i32* %8, i32* %9)
  store volatile i32 %call, i32* %i
  %x = alloca i32
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %10 = load i32, i32* %i
  %11 = load i32, i32* %i
  %12 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 %11
  store volatile i32 %10, i32* %12
  %13 = load i32, i32* %i
  %14 = load i32, i32* %i
  %15 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 %14
  store volatile i32 %13, i32* %15
  %16 = load i32, i32* %i
  %17 = load i32, i32* %i
  %18 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 %17
  store volatile i32 %16, i32* %18
  %19 = load i32, i32* %i
  %20 = load i32, i32* %i
  %21 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 %20
  store volatile i32 %19, i32* %21
  %22 = load i32, i32* %i
  %23 = load i32, i32* %i
  %24 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 %23
  store volatile i32 %22, i32* %24
  %25 = load i32, i32* %i
  %26 = load i32, i32* %i
  %27 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 %26
  store volatile i32 %25, i32* %27
  %28 = load i32, i32* %i
  %add = fadd i32 %28, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %29 = load i32, i32* %i
  %less4 = icmp slt i32 %29, 3
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header8, %loop_header1
  store volatile i32 10, i32* %x
  store volatile i32 0, i32* %i
  %30 = load i32, i32* %x
  %call7 = call void @putch(i32 %30)
  br label %loop_header8

loop_body3:                                       ; preds = %loop_header1
  %31 = load i32, i32* %i
  %32 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 %31
  %33 = load i32, i32* %32
  store volatile i32 %33, i32* %x
  %34 = load i32, i32* %x
  %call5 = call void @putint(i32 %34)
  %35 = load i32, i32* %i
  %add6 = fadd i32 %35, 1
  store volatile i32 %add6, i32* %i
  br label %loop_header1

loop_header8:                                     ; preds = %loop_body10, %loop_exit2
  br label %loop_exit2
  %36 = load i32, i32* %i
  %less11 = icmp slt i32 %36, 3
  br i1 %less11, label %loop_body10, label %loop_exit9

loop_exit9:                                       ; preds = %loop_header15, %loop_header8
  store volatile i32 10, i32* %x
  store volatile i32 0, i32* %i
  %37 = load i32, i32* %x
  %call14 = call void @putch(i32 %37)
  br label %loop_header15

loop_body10:                                      ; preds = %loop_header8
  %38 = load i32, i32* %i
  %39 = getelementptr [3 x i32], [3 x i32]* %c1, i32 0, i32 %38
  %40 = load i32, i32* %39
  store volatile i32 %40, i32* %x
  %41 = load i32, i32* %x
  %call12 = call void @putint(i32 %41)
  %42 = load i32, i32* %i
  %add13 = fadd i32 %42, 1
  store volatile i32 %add13, i32* %i
  br label %loop_header8

loop_header15:                                    ; preds = %loop_body17, %loop_exit9
  br label %loop_exit9
  %43 = load i32, i32* %i
  %less18 = icmp slt i32 %43, 3
  br i1 %less18, label %loop_body17, label %loop_exit16

loop_exit16:                                      ; preds = %loop_header15
  store volatile i32 10, i32* %x
  %44 = load i32, i32* %x
  %call21 = call void @putch(i32 %44)
  ret i32 0

loop_body17:                                      ; preds = %loop_header15
  %45 = load i32, i32* %i
  %46 = getelementptr [3 x i32], [3 x i32]* %c2, i32 0, i32 %45
  %47 = load i32, i32* %46
  store volatile i32 %47, i32* %x
  %48 = load i32, i32* %x
  %call19 = call void @putint(i32 %48)
  %49 = load i32, i32* %i
  %add20 = fadd i32 %49, 1
  store volatile i32 %add20, i32* %i
  br label %loop_header15
}
