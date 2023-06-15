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
  store volatile i32 20, i32* %a
  %b = alloca i32
  store volatile i32 5, i32* %b
  %c = alloca i32
  store volatile i32 6, i32* %c
  %d = alloca i32
  store volatile i32 -4, i32* %d
  %0 = load i32, i32* %a
  %1 = load i32, i32* %c
  %2 = load i32, i32* %d
  %mul = mul i32 %1, %2
  %add = fadd i32 %0, %mul
  %3 = load i32, i32* %b
  %4 = load i32, i32* %a
  %5 = load i32, i32* %d
  %add1 = fadd i32 %4, %5
  %mod = urem i32 %3, %add1
  %6 = load i32, i32* %a
  %div = fdiv i32 %mod, %6
  %sub = fsub i32 %add, %div
  store volatile i32 %sub, i32* %a
  %7 = load i32, i32* %a
  %call = call void @putint(i32 %7)
  ret i32 0
}
