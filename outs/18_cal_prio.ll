; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0
@c = global i32 0

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
  %call = call i32 @getint()
  store volatile i32 %call, i32* @a
  %call1 = call i32 @getint()
  store volatile i32 %call1, i32* @b
  %call2 = call i32 @getint()
  store volatile i32 %call2, i32* @c
  %d = alloca i32
  %0 = load i32, i32* @a
  %1 = load i32, i32* @b
  %2 = load i32, i32* @c
  %mul = mul i32 %1, %2
  %add = fadd i32 %0, %mul
  store volatile i32 %add, i32* %d
  %3 = load i32, i32* %d
  ret i32 %3
}
