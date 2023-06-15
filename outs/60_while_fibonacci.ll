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

define i32 @fib(i32 %p) {
begin:
  %0 = alloca i32
  store i32 %p, i32* %0
  %a = alloca i32
  %b = alloca i32
  %c = alloca i32
  store volatile i32 0, i32* %a
  store volatile i32 1, i32* %b
  %1 = load i32, i32* %0
  %equal = icmp eq i32 %1, 0
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 0
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %2 = load i32, i32* %0
  %equal1 = icmp eq i32 %2, 1
  br i1 %equal1, label %true_block2, <null operand!>

true_block2:                                      ; preds = %merge_block
  ret i32 1
  br label %merge_block3

merge_block3:                                     ; preds = %loop_header, %true_block2
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block3
  br label %merge_block3
  %3 = load i32, i32* %0
  %greater = icmp sgt i32 %3, 1
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %4 = load i32, i32* %c
  ret i32 %4

loop_body:                                        ; preds = %loop_header
  %5 = load i32, i32* %a
  %6 = load i32, i32* %b
  %add = fadd i32 %5, %6
  store volatile i32 %add, i32* %c
  %7 = load i32, i32* %b
  store volatile i32 %7, i32* %a
  %8 = load i32, i32* %c
  store volatile i32 %8, i32* %b
  %9 = load i32, i32* %0
  %sub = fsub i32 %9, 1
  store volatile i32 %sub, i32* %0
  br label %loop_header
}

define i32 @main() {
begin:
  %call = call i32 @getint()
  store volatile i32 %call, i32* @n
  %res = alloca i32
  %0 = load i32, i32* @n
  %call1 = call i32 @fib(i32 %0)
  store volatile i32 %call1, i32* %res
  %1 = load i32, i32* %res
  ret i32 %1
}
