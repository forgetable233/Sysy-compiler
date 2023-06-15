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
  %string = alloca [500 x i32]
  %temp = alloca i32
  %i = alloca i32
  %count = alloca i32
  store volatile i32 0, i32* %count
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %temp
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %0 = load i32, i32* %temp
  %not_equal = icmp ne i32 %0, 10
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %count
  %call5 = call void @putint(i32 %1)
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %call = call i32 @getch()
  store volatile i32 %call, i32* %temp
  %2 = load i32, i32* %temp
  %greater = icmp sgt i32 %2, 40
  %3 = load i32, i32* %temp
  %less = icmp slt i32 %3, 91
  %and = and i1 %greater, %less
  %4 = load i32, i32* %temp
  %greater1 = icmp sgt i32 %4, 96
  %5 = load i32, i32* %temp
  %less2 = icmp slt i32 %5, 123
  %and3 = and i1 %greater1, %less2
  %or = or i1 %and, %and3
  br i1 %or, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  %6 = load i32, i32* %count
  %add = fadd i32 %6, 1
  store volatile i32 %add, i32* %count
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %7 = load i32, i32* %i
  %add4 = fadd i32 %7, 1
  store volatile i32 %add4, i32* %i
  br label %loop_header
}
