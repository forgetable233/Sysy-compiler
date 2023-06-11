; ModuleID = 'default'
source_filename = "default"

@a = global i32 0

define i32 @myFunc(i32 %a, i32 %b, i32 %c) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  store i32 %a, i32* %0
  store i32 %b, i32* %1
  store i32 %c, i32* %2
  store volatile i32 2, i32* %0
  %c1 = alloca i32
  store volatile i32 0, i32* %c1
  %3 = load i32, i32* %c1
  %not_equal = icmp ne i32 %3, 0
  br i1 %not_equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 0
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %4 = load i32, i32* %1
  %greater = icmp sgt i32 %4, 0
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %5 = load i32, i32* %0
  %6 = load i32, i32* %1
  %add = fadd i32 %5, %6
  ret i32 %add

loop_body:                                        ; preds = %loop_header
  %7 = load i32, i32* %1
  %sub = fsub i32 %7, 1
  store volatile i32 %sub, i32* %1
  br label %loop_header
}

define i32 @main() {
begin:
  store volatile i32 3, i32* @a
  %b = alloca i32
  %call = call i32 @myFunc(i32 1, i32 2, i32 1)
  store volatile i32 %call, i32* %b
  %0 = load i32, i32* @a
  %1 = load i32, i32* %b
  %add = fadd i32 %0, %1
  ret i32 %add
}
