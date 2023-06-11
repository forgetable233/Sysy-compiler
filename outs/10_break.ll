; ModuleID = 'default'
source_filename = "default"

define i32 @main() {
begin:
  %a = alloca i32
  store i32 10, i32* %a
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %0 = load i32, i32* %a
  %greater = icmp sgt i32 %0, 0
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %true_block, %loop_header
  %1 = load i32, i32* %a
  ret i32 %1

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* %a
  %sub = fsub i32 %2, 1
  store volatile i32 %sub, i32* %a
  %3 = load i32, i32* %a
  %equal = icmp eq i32 %3, 5
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  br label %loop_exit
  br label %merge_block

merge_block:                                      ; preds = %true_block
  br label %loop_header
}
