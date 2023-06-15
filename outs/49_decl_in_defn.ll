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
  store volatile i32 12, i32* %a
  %t = alloca i32
  %0 = load i32, i32* %a
  %call = call void @putint(i32 %0)
  ret i32 0
}
