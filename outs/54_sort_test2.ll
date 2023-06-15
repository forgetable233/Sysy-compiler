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
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %call = call i32 @insertsort(i32* %10)
  store volatile i32 %call, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %11 = load i32, i32* %i
  %12 = load i32, i32* @n
  %less = icmp slt i32 %11, %12
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %tmp = alloca i32
  %13 = load i32, i32* %i
  %14 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %13
  %15 = load i32, i32* %14
  store volatile i32 %15, i32* %tmp
  %16 = load i32, i32* %tmp
  %call1 = call void @putint(i32 %16)
  store volatile i32 10, i32* %tmp
  %17 = load i32, i32* %tmp
  %call2 = call void @putch(i32 %17)
  %18 = load i32, i32* %i
  %add = fadd i32 %18, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
