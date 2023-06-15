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
  %i = alloca i32
  %sum = alloca i32
  %a = alloca [10 x i32]
  store volatile i32 0, i32* %sum
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %i
  %less = icmp slt i32 %0, 10
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header3, %loop_header
  %x = alloca i32
  %high = alloca i32
  %low = alloca i32
  %mid = alloca i32
  %n = alloca i32
  store volatile i32 10, i32* %n
  %call = call i32 @getint()
  store volatile i32 %call, i32* %x
  %1 = load i32, i32* %n
  %sub = fsub i32 %1, 1
  store volatile i32 %sub, i32* %high
  store volatile i32 0, i32* %low
  %2 = load i32, i32* %high
  %3 = load i32, i32* %low
  %add2 = fadd i32 %2, %3
  %div = fdiv i32 %add2, 2
  store volatile i32 %div, i32* %mid
  %flag = alloca i32
  store volatile i32 0, i32* %flag
  store volatile i32 0, i32* %i
  %j = alloca i32
  store volatile i32 0, i32* %j
  br label %loop_header3

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %i
  %add = fadd i32 %4, 1
  %5 = load i32, i32* %i
  %6 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %5
  store volatile i32 %add, i32* %6
  %7 = load i32, i32* %i
  %add1 = fadd i32 %7, 1
  store volatile i32 %add1, i32* %i
  br label %loop_header

loop_header3:                                     ; preds = %merge_block, %loop_exit
  br label %loop_exit
  %8 = load i32, i32* %i
  %less6 = icmp slt i32 %8, 10
  %9 = load i32, i32* %flag
  %equal = icmp eq i32 %9, 0
  %and = and i1 %less6, %equal
  br i1 %and, label %loop_body5, label %loop_exit4

loop_exit4:                                       ; preds = %loop_header3
  %10 = load i32, i32* %flag
  %equal9 = icmp eq i32 %10, 1
  br i1 %equal9, label %true_block10, label %false_block

loop_body5:                                       ; preds = %loop_header3
  %11 = load i32, i32* %i
  %12 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %11
  %13 = load i32, i32* %12
  %14 = load i32, i32* %x
  %equal7 = icmp eq i32 %13, %14
  br i1 %equal7, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body5
  store volatile i32 1, i32* %flag
  %15 = load i32, i32* %i
  store volatile i32 %15, i32* %j
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %16 = load i32, i32* %i
  %add8 = fadd i32 %16, 1
  store volatile i32 %add8, i32* %i
  br label %loop_header3

true_block10:                                     ; preds = %loop_exit4
  %17 = load i32, i32* %j
  %call12 = call void @putint(i32 %17)
  br label %merge_block11

merge_block11:                                    ; preds = %false_block, %true_block10
  store volatile i32 10, i32* %x
  %18 = load i32, i32* %x
  %call14 = call void @putch(i32 %18)
  ret i32 0

false_block:                                      ; preds = %loop_exit4
  store volatile i32 0, i32* %x
  %19 = load i32, i32* %x
  %call13 = call void @putint(i32 %19)
  br label %merge_block11
}
