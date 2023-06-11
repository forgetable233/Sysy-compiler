; ModuleID = 'default'
source_filename = "default"

define i32 @ifElse() {
begin:
  %a = alloca i32
  store volatile i32 5, i32* %a
  %0 = load i32, i32* %a
  %equal = icmp eq i32 %0, 5
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  store volatile i32 25, i32* %a
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  %1 = load i32, i32* %a
  ret i32 %1

false_block:                                      ; preds = %begin
  %2 = load i32, i32* %a
  %mul = mul i32 %2, 2
  store volatile i32 %mul, i32* %a
  br label %merge_block
}

define i32 @main() {
begin:
  %call = call i32 @ifElse()
  ret i32 %call
}
