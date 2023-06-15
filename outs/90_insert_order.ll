; ModuleID = 'default'
source_filename = "default"

@N = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @insert(i32* %a, i32 %x) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %a, i32** %0
  store i32 %x, i32* %1
  %p = alloca i32
  %i = alloca i32
  store volatile i32 0, i32* %p
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %2 = load i32, i32* %1
  %3 = load i32*, i32** %0
  %4 = load i32, i32* %p
  %5 = getelementptr i32, i32* %3, i32 %4
  %6 = load i32, i32* %5
  %greater = icmp sgt i32 %2, %6
  %7 = load i32, i32* %p
  %8 = load i32, i32* @N
  %less = icmp slt i32 %7, %8
  %and = and i1 %greater, %less
  br i1 %and, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  %9 = load i32, i32* @N
  store volatile i32 %9, i32* %i
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %10 = load i32, i32* %p
  %add = fadd i32 %10, 1
  store volatile i32 %add, i32* %p
  br label %loop_header

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %11 = load i32, i32* %i
  %12 = load i32, i32* %p
  %greater4 = icmp sgt i32 %11, %12
  br i1 %greater4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  ret i32 0

loop_body3:                                       ; preds = %loop_header1
  %13 = load i32*, i32** %0
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %i
  %sub = fsub i32 %15, 1
  %16 = getelementptr i32, i32* %14, i32 %sub
  %17 = load i32, i32* %16
  %18 = load i32, i32* %i
  %19 = getelementptr i32, i32* %13, i32 %18
  store volatile i32 %17, i32* %19
  %20 = load i32*, i32** %0
  %21 = load i32, i32* %1
  %22 = load i32, i32* %p
  %23 = getelementptr i32, i32* %20, i32 %22
  store volatile i32 %21, i32* %23
  %24 = load i32, i32* %i
  %sub5 = fsub i32 %24, 1
  store volatile i32 %sub5, i32* %i
  br label %loop_header1
}

define i32 @main() {
begin:
  store volatile i32 10, i32* @N
  %a = alloca [11 x i32]
  %0 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 0
  store volatile i32 1, i32* %0
  %1 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 1
  store volatile i32 3, i32* %1
  %2 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 2
  store volatile i32 4, i32* %2
  %3 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 3
  store volatile i32 7, i32* %3
  %4 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 4
  store volatile i32 8, i32* %4
  %5 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 5
  store volatile i32 11, i32* %5
  %6 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 6
  store volatile i32 13, i32* %6
  %7 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 7
  store volatile i32 18, i32* %7
  %8 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 8
  store volatile i32 56, i32* %8
  %9 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 9
  store volatile i32 78, i32* %9
  %x = alloca i32
  %i = alloca i32
  store volatile i32 0, i32* %i
  %call = call i32 @getint()
  store volatile i32 %call, i32* %x
  %10 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* %x
  %call1 = call i32 @insert(i32* %10, i32 %11)
  store volatile i32 %call1, i32* %x
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %12 = load i32, i32* %i
  %13 = load i32, i32* @N
  %less = icmp slt i32 %12, %13
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %14 = load i32, i32* %i
  %15 = getelementptr [11 x i32], [11 x i32]* %a, i32 0, i32 %14
  %16 = load i32, i32* %15
  store volatile i32 %16, i32* %x
  %17 = load i32, i32* %x
  %call2 = call void @putint(i32 %17)
  store volatile i32 10, i32* %x
  %18 = load i32, i32* %x
  %call3 = call void @putch(i32 %18)
  %19 = load i32, i32* %i
  %add = fadd i32 %19, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
