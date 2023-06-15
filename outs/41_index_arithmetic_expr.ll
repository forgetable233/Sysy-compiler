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

define i32 @main() {
begin:
  %a = alloca i32
  %b = alloca i32
  %result = alloca [3 x i32]
  store volatile i32 56, i32* %a
  store volatile i32 12, i32* %b
  %0 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 0
  store volatile i32 1, i32* %0
  %1 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 1
  store volatile i32 2, i32* %1
  %2 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 2
  store volatile i32 3, i32* %2
  %t = alloca i32
  %3 = load i32, i32* %a
  %4 = load i32, i32* %b
  %mod = urem i32 %3, %4
  %5 = load i32, i32* %b
  %add = fadd i32 %mod, %5
  %div = fdiv i32 %add, 5
  %sub = fsub i32 %div, 2
  %6 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 %sub
  %7 = load i32, i32* %6
  store volatile i32 %7, i32* %t
  %8 = load i32, i32* %t
  %call = call void @putint(i32 %8)
  ret i32 0
}
