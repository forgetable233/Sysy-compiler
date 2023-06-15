; ModuleID = 'default'
source_filename = "default"

@N = global i32 0
@newline = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @split(i32 %n, i32* %a) {
begin:
  %0 = alloca i32
  %1 = alloca i32*
  store i32 %n, i32* %0
  store i32* %a, i32** %1
  %i = alloca i32
  %2 = load i32, i32* @N
  %sub = fsub i32 %2, 1
  store volatile i32 %sub, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %3 = load i32, i32* %i
  %not_equal = icmp ne i32 %3, -1
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %4 = load i32*, i32** %1
  %5 = load i32, i32* %0
  %mod = urem i32 %5, 10
  %6 = load i32, i32* %i
  %7 = getelementptr i32, i32* %4, i32 %6
  store volatile i32 %mod, i32* %7
  %8 = load i32, i32* %0
  %div = fdiv i32 %8, 10
  store volatile i32 %div, i32* %0
  %9 = load i32, i32* %i
  %sub1 = fsub i32 %9, 1
  store volatile i32 %sub1, i32* %i
  br label %loop_header
}

define i32 @main() {
begin:
  store volatile i32 4, i32* @N
  store volatile i32 10, i32* @newline
  %i = alloca i32
  %m = alloca i32
  %b = alloca [4 x i32]
  store volatile i32 1478, i32* %m
  %0 = load i32, i32* %m
  %1 = getelementptr [4 x i32], [4 x i32]* %b, i32 0, i32 0
  %call = call i32 @split(i32 %0, i32* %1)
  store volatile i32 %call, i32* %m
  %t = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %2 = load i32, i32* %i
  %less = icmp slt i32 %2, 4
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %3 = load i32, i32* %i
  %4 = getelementptr [4 x i32], [4 x i32]* %b, i32 0, i32 %3
  %5 = load i32, i32* %4
  store volatile i32 %5, i32* %t
  %6 = load i32, i32* %t
  %call1 = call void @putint(i32 %6)
  %7 = load i32, i32* @newline
  %call2 = call void @putch(i32 %7)
  %8 = load i32, i32* %i
  %add = fadd i32 %8, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
