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
  %j = alloca i32
  %k = alloca i32
  %t = alloca i32
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %j
  store volatile i32 0, i32* %k
  br label %loop_header

loop_header:                                      ; preds = %loop_exit2, %begin
  br label %begin
  %0 = load i32, i32* %i
  %less = icmp slt i32 %0, 21
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header1, %loop_header
  br label %loop_header1

loop_header1:                                     ; preds = %merge_block, %loop_body
  br label %loop_body
  %1 = load i32, i32* %j
  %2 = load i32, i32* %i
  %sub = fsub i32 101, %2
  %less4 = icmp slt i32 %1, %sub
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %3 = load i32, i32* %i
  %add13 = fadd i32 %3, 1
  store volatile i32 %add13, i32* %i
  br label %loop_header

loop_body3:                                       ; preds = %loop_header1
  %4 = load i32, i32* %i
  %sub5 = fsub i32 100, %4
  %5 = load i32, i32* %j
  %sub6 = fsub i32 %sub5, %5
  store volatile i32 %sub6, i32* %k
  %6 = load i32, i32* %i
  %mul = mul i32 5, %6
  %7 = load i32, i32* %j
  %mul7 = mul i32 1, %7
  %add = fadd i32 %mul, %mul7
  %8 = load i32, i32* %k
  %div = fdiv i32 %8, 2
  %add8 = fadd i32 %add, %div
  %equal = icmp eq i32 %add8, 100
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body3
  %9 = load i32, i32* %i
  %call = call void @putint(i32 %9)
  %10 = load i32, i32* %j
  %call9 = call void @putint(i32 %10)
  %11 = load i32, i32* %k
  %call10 = call void @putint(i32 %11)
  store volatile i32 10, i32* %t
  %12 = load i32, i32* %t
  %call11 = call void @putch(i32 %12)
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %13 = load i32, i32* %j
  %add12 = fadd i32 %13, 1
  store volatile i32 %add12, i32* %j
  br label %loop_header1
}
