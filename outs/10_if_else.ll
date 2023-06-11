; ModuleID = 'default'
source_filename = "default"

@a = global i32 0

define i32 @main() {
begin:
  store volatile i32 10, i32* @a
  %0 = load i32, i32* @a
  %greater = icmp sgt i32 %0, 0
  br i1 %greater, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block

false_block:                                      ; preds = %begin
  ret i32 0
  br label %merge_block
}
