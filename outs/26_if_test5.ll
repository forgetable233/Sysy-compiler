; ModuleID = 'default'
source_filename = "default"

define i32 @if_if_Else() {
begin:
  %a = alloca i32
  store volatile i32 5, i32* %a
  %b = alloca i32
  store volatile i32 10, i32* %b
  %0 = load i32, i32* %a
  %equal = icmp eq i32 %0, 5
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  %1 = load i32, i32* %b
  %equal1 = icmp eq i32 %1, 10
  br i1 %equal1, label %true_block2, <null operand!>

merge_block:                                      ; preds = %false_block, %merge_block3
  %2 = load i32, i32* %a
  ret i32 %2

false_block:                                      ; preds = %begin
  %3 = load i32, i32* %a
  %add = fadd i32 %3, 15
  store volatile i32 %add, i32* %a
  br label %merge_block

true_block2:                                      ; preds = %true_block
  store volatile i32 25, i32* %a
  br label %merge_block3

merge_block3:                                     ; preds = %true_block2
  br label %merge_block
}

define i32 @main() {
begin:
  %call = call i32 @if_if_Else()
  ret i32 %call
}
