; ModuleID = 'default'
source_filename = "default"

define i32 @ifElseElseIf() {
begin:
  %a = alloca i32
  store volatile i32 66, i32* %a
  %b = alloca i32
  store volatile i32 8923, i32* %b
  %0 = load i32, i32* %a
  %equal = icmp eq i32 %0, 5
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  store volatile i32 25, i32* %b
  br label %merge_block

merge_block:                                      ; preds = %merge_block3, %true_block
  %1 = load i32, i32* %b
  ret i32 %1

false_block:                                      ; preds = %begin
  %2 = load i32, i32* %a
  %equal1 = icmp eq i32 %2, 10
  br i1 %equal1, label %true_block2, label %false_block4

true_block2:                                      ; preds = %false_block
  store volatile i32 42, i32* %b
  br label %merge_block3

merge_block3:                                     ; preds = %false_block4, %true_block2
  br label %merge_block

false_block4:                                     ; preds = %false_block
  %3 = load i32, i32* %a
  %mul = mul i32 %3, 2
  store volatile i32 %mul, i32* %b
  br label %merge_block3
}

define i32 @main() {
begin:
  %call = call i32 @ifElseElseIf()
  ret i32 %call
}
