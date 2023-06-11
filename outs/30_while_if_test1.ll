; ModuleID = 'default'
source_filename = "default"

define i32 @whileIf() {
begin:
  %a = alloca i32
  store volatile i32 0, i32* %a
  %b = alloca i32
  store volatile i32 0, i32* %b
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %0 = load i32, i32* %a
  %less = icmp slt i32 %0, 100
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %b
  ret i32 %1

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* %a
  %equal = icmp eq i32 %2, 5
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body
  store volatile i32 25, i32* %b
  br label %merge_block

merge_block:                                      ; preds = %merge_block3, %true_block
  %3 = load i32, i32* %a
  %add = fadd i32 %3, 1
  store volatile i32 %add, i32* %a
  br label %loop_header

false_block:                                      ; preds = %loop_body
  %4 = load i32, i32* %a
  %equal1 = icmp eq i32 %4, 10
  br i1 %equal1, label %true_block2, label %false_block4

true_block2:                                      ; preds = %false_block
  store volatile i32 42, i32* %b
  br label %merge_block3

merge_block3:                                     ; preds = %false_block4, %true_block2
  br label %merge_block

false_block4:                                     ; preds = %false_block
  %5 = load i32, i32* %a
  %mul = mul i32 %5, 2
  store volatile i32 %mul, i32* %b
  br label %merge_block3
}

define i32 @main() {
begin:
  %call = call i32 @whileIf()
  ret i32 %call
}
