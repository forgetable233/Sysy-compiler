; ModuleID = 'default'
source_filename = "default"

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @concat(i32* %a0, i32* %b0, i32* %c0) {
begin:
  %0 = alloca i32*
  %1 = alloca i32*
  %2 = alloca i32*
  store i32* %a0, i32** %0
  store i32* %b0, i32** %1
  store i32* %c0, i32** %2
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %3 = load i32, i32* %i
  %less = icmp slt i32 %3, 3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  %j = alloca i32
  store volatile i32 0, i32* %j
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %4 = load i32*, i32** %2
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

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %12 = load i32, i32* %j
  %less4 = icmp slt i32 %12, 3
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  ret i32 0

loop_body3:                                       ; preds = %loop_header1
  %13 = load i32*, i32** %2
  %14 = load i32*, i32** %1
  %15 = load i32, i32* %j
  %16 = getelementptr i32, i32* %14, i32 %15
  %17 = load i32, i32* %16
  %18 = load i32, i32* %i
  %19 = getelementptr i32, i32* %13, i32 %18
  store volatile i32 %17, i32* %19
  %20 = load i32, i32* %i
  %add5 = fadd i32 %20, 1
  store volatile i32 %add5, i32* %i
  %21 = load i32, i32* %j
  %add6 = fadd i32 %21, 1
  store volatile i32 %add6, i32* %j
  br label %loop_header1
}

define i32 @main() {
begin:
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
  %2 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 0
  %3 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 0
  %call = call i32 @concat(i32* %1, i32* %2, i32* %3)
  store volatile i32 %call, i32* %i
  %x = alloca i32
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %i
  %5 = load i32, i32* %i
  %6 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 %5
  store volatile i32 %4, i32* %6
  %7 = load i32, i32* %i
  %8 = load i32, i32* %i
  %9 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 %8
  store volatile i32 %7, i32* %9
  %10 = load i32, i32* %i
  %11 = load i32, i32* %i
  %12 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 %11
  store volatile i32 %10, i32* %12
  %13 = load i32, i32* %i
  %14 = load i32, i32* %i
  %15 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 %14
  store volatile i32 %13, i32* %15
  %16 = load i32, i32* %i
  %17 = load i32, i32* %i
  %18 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 %17
  store volatile i32 %16, i32* %18
  %19 = load i32, i32* %i
  %20 = load i32, i32* %i
  %21 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 %20
  store volatile i32 %19, i32* %21
  %22 = load i32, i32* %i
  %add = fadd i32 %22, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %23 = load i32, i32* %i
  %less4 = icmp slt i32 %23, 6
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  store volatile i32 10, i32* %x
  %24 = load i32, i32* %x
  %call7 = call void @putch(i32 %24)
  ret i32 0

loop_body3:                                       ; preds = %loop_header1
  %25 = load i32, i32* %i
  %26 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 %25
  %27 = load i32, i32* %26
  store volatile i32 %27, i32* %x
  %28 = load i32, i32* %x
  %call5 = call void @putint(i32 %28)
  %29 = load i32, i32* %i
  %add6 = fadd i32 %29, 1
  store volatile i32 %add6, i32* %i
  br label %loop_header1
}
