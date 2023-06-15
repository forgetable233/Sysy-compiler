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

define i32 @f(i32 %x) {
begin:
  %0 = alloca i32
  store i32 %x, i32* %0
  %1 = load i32, i32* %0
  %equal = icmp eq i32 %1, 1
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %2 = load i32, i32* %0
  %equal1 = icmp eq i32 %2, 2
  br i1 %equal1, label %true_block2, <null operand!>

true_block2:                                      ; preds = %merge_block
  ret i32 1
  br label %merge_block3

merge_block3:                                     ; preds = %true_block2
  %a = alloca i32
  %b = alloca i32
  %3 = load i32, i32* %0
  %sub = fsub i32 %3, 1
  store volatile i32 %sub, i32* %a
  %4 = load i32, i32* %0
  %sub4 = fsub i32 %4, 2
  store volatile i32 %sub4, i32* %b
  %c = alloca i32
  %5 = load i32, i32* %a
  %call = call i32 @f(i32 %5)
  %6 = load i32, i32* %b
  %call5 = call i32 @f(i32 %6)
  %add = fadd i32 %call, %call5
  store volatile i32 %add, i32* %c
  %7 = load i32, i32* %c
  ret i32 %7
}

define i32 @main() {
begin:
  %call = call i32 @getint()
  store volatile i32 %call, i32* @n
  %t = alloca i32
  %xx = alloca i32
  %0 = load i32, i32* @n
  %call1 = call i32 @f(i32 %0)
  store volatile i32 %call1, i32* %t
  %1 = load i32, i32* %t
  %call2 = call void @putint(i32 %1)
  %newline = alloca i32
  store volatile i32 10, i32* %newline
  %2 = load i32, i32* %newline
  %call3 = call void @putch(i32 %2)
  %3 = load i32, i32* %t
  ret i32 %3
}
