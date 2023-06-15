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

define i32 @main() {
begin:
  %i = alloca i32
  %j = alloca i32
  %call = call i32 @getint()
  store volatile i32 %call, i32* %i
  %call1 = call i32 @getint()
  store volatile i32 %call1, i32* %j
  %temp = alloca i32
  %0 = load i32, i32* %i
  store volatile i32 %0, i32* %temp
  %1 = load i32, i32* %j
  store volatile i32 %1, i32* %i
  %2 = load i32, i32* %temp
  store volatile i32 %2, i32* %j
  %3 = load i32, i32* %i
  %call2 = call void @putint(i32 %3)
  store volatile i32 10, i32* %temp
  %4 = load i32, i32* %temp
  %call3 = call void @putch(i32 %4)
  %5 = load i32, i32* %j
  %call4 = call void @putint(i32 %5)
  store volatile i32 10, i32* %temp
  %6 = load i32, i32* %temp
  %call5 = call void @putch(i32 %6)
  ret i32 0
}
