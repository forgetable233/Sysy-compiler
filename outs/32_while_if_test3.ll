; ModuleID = 'default'
source_filename = "default"

define i32 @deepWhileBr(i32 %a, i32 %b) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  store i32 %a, i32* %0
  store i32 %b, i32* %1
  %c = alloca i32
  %2 = load i32, i32* %0
  %3 = load i32, i32* %1
  %add = fadd i32 %2, %3
  store volatile i32 %add, i32* %c
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %4 = load i32, i32* %c
  %less = icmp slt i32 %4, 75
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %5 = load i32, i32* %c
  ret i32 %5

loop_body:                                        ; preds = %loop_header
  %d = alloca i32
  store volatile i32 42, i32* %d
  %6 = load i32, i32* %c
  %less1 = icmp slt i32 %6, 100
  br i1 %less1, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  %7 = load i32, i32* %c
  %8 = load i32, i32* %d
  %add2 = fadd i32 %7, %8
  store volatile i32 %add2, i32* %c
  %9 = load i32, i32* %c
  %greater = icmp sgt i32 %9, 99
  br i1 %greater, label %true_block3, <null operand!>

merge_block:                                      ; preds = %merge_block4
  br label %loop_header

true_block3:                                      ; preds = %true_block
  %e = alloca i32
  %10 = load i32, i32* %d
  %mul = mul i32 %10, 2
  store volatile i32 %mul, i32* %e
  br i1 true, label %true_block5, <null operand!>

merge_block4:                                     ; preds = %merge_block6
  br label %merge_block

true_block5:                                      ; preds = %true_block3
  %11 = load i32, i32* %e
  %mul7 = mul i32 %11, 2
  store volatile i32 %mul7, i32* %c
  br label %merge_block6

merge_block6:                                     ; preds = %true_block5
  br label %merge_block4
}

define i32 @main() {
begin:
  %p = alloca i32
  store volatile i32 2, i32* %p
  %0 = load i32, i32* %p
  %1 = load i32, i32* %p
  %call = call i32 @deepWhileBr(i32 %0, i32 %1)
  ret i32 %call
}
