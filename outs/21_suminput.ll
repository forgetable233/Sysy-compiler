; ModuleID = 'default'
source_filename = "default"

@n = global i32 0
@a = global [10 x i32] zeroinitializer

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
  store volatile i32 %call, i32* @n
  %0 = load i32, i32* @n
  %greater = icmp sgt i32 %0, 10
  br i1 %greater, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  %s = alloca i32
  %i = alloca i32
  store volatile i32 0, i32* %i
  %1 = load i32, i32* %i
  store volatile i32 %1, i32* %s
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %2 = load i32, i32* %i
  %3 = load i32, i32* @n
  %less = icmp slt i32 %2, %3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %4 = load i32, i32* %s
  %call3 = call void @putint(i32 %4)
  %newline = alloca i32
  store volatile i32 10, i32* %newline
  %5 = load i32, i32* %newline
  %call4 = call void @putch(i32 %5)
  %6 = load i32, i32* %s
  ret i32 %6

loop_body:                                        ; preds = %loop_header
  %call1 = call i32 @getint()
  %7 = load i32, i32* %i
  %8 = getelementptr [10 x i32], [10 x i32]* @a, i32 0, i32 %7
  store volatile i32 %call1, i32* %8
  %9 = load i32, i32* %s
  %10 = load i32, i32* %i
  %11 = getelementptr [10 x i32], [10 x i32]* @a, i32 0, i32 %10
  %12 = load i32, i32* %11
  %add = fadd i32 %9, %12
  store volatile i32 %add, i32* %s
  %13 = load i32, i32* %i
  %add2 = fadd i32 %13, 1
  store volatile i32 %add2, i32* %i
  br label %loop_header
}
