; ModuleID = 'default'
source_filename = "default"

define i32 @ifWhile() {
begin:
  %a = alloca i32
  store volatile i32 0, i32* %a
  %b = alloca i32
  store volatile i32 3, i32* %b
  %0 = load i32, i32* %a
  %equal = icmp eq i32 %0, 5
  br i1 %equal, label %true_block, label %false_block

true_block:                                       ; preds = %loop_header, %begin
  br label %loop_header

merge_block:                                      ; preds = %loop_exit4, %loop_exit
  %1 = load i32, i32* %b
  ret i32 %1

false_block:                                      ; preds = %loop_header3, %begin
  br label %loop_header3

loop_header:                                      ; preds = %loop_body, %true_block
  br label %true_block
  %2 = load i32, i32* %b
  %equal1 = icmp eq i32 %2, 2
  br i1 %equal1, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %3 = load i32, i32* %b
  %add2 = fadd i32 %3, 25
  store volatile i32 %add2, i32* %b
  br label %merge_block

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %b
  %add = fadd i32 %4, 2
  store volatile i32 %add, i32* %b
  br label %loop_header

loop_header3:                                     ; preds = %loop_body5, %false_block
  br label %false_block
  %5 = load i32, i32* %a
  %less = icmp slt i32 %5, 5
  br i1 %less, label %loop_body5, label %loop_exit4

loop_exit4:                                       ; preds = %loop_header3
  br label %merge_block

loop_body5:                                       ; preds = %loop_header3
  %6 = load i32, i32* %b
  %mul = mul i32 %6, 2
  store volatile i32 %mul, i32* %b
  %7 = load i32, i32* %a
  %add6 = fadd i32 %7, 1
  store volatile i32 %add6, i32* %a
  br label %loop_header3
}

define i32 @main() {
begin:
  %call = call i32 @ifWhile()
  ret i32 %call
}
