; ModuleID = 'default'
source_filename = "default"

define i32 @main() {
begin:
  %a = alloca i32
  store i32 10, i32* %a
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %true_block, %begin
  br label %begin
  %0 = load i32, i32* %a
  %greater = icmp sgt i32 %0, 0
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %a
  ret i32 %1

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* %a
  %greater2 = icmp sgt i32 %2, 5
  br i1 %greater2, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  %3 = load i32, i32* %a
  %sub = fsub i32 %3, 1
  store volatile i32 %sub, i32* %a
  br label %loop_header
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %4 = load i32, i32* %a
  ret i32 %4
  br label %loop_header
}
