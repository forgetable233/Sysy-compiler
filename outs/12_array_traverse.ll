; ModuleID = 'default'
source_filename = "default"

@a = global [3 x [4 x i32]] zeroinitializer

define i32 @main() {
begin:
  %i = alloca i32
  store i32 0, i32* %i
  %cnt = alloca i32
  store i32 0, i32* %cnt
  br label %loop_header

loop_header:                                      ; preds = %loop_exit5, %begin
  br label %begin
  %0 = load i32, i32* %i
  %less_equal = icmp sle i32 %0, fsub (i32 fadd (i32 3, i32 4), i32 2)
  br i1 %less_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  ret i32 0

loop_body:                                        ; preds = %loop_header4, %loop_header
  %j = alloca i32
  %1 = load i32, i32* %i
  store i32 %1, i32* %j
  br label %loop_header4

loop_header4:                                     ; preds = %merge_block, %loop_body
  br label %loop_body
  %2 = load i32, i32* %j
  %greater_equal = icmp sge i32 %2, 0
  br i1 %greater_equal, label %loop_body6, label %loop_exit5

loop_exit5:                                       ; preds = %loop_header4
  %3 = load i32, i32* %i
  %add = fadd i32 %3, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_body6:                                       ; preds = %loop_header4
  %4 = load i32, i32* %j
  %less = icmp slt i32 %4, 4
  %5 = load i32, i32* %i
  %6 = load i32, i32* %j
  %sub = fsub i32 %5, %6
  %less7 = icmp slt i32 %sub, 3
  %and = and i1 %less, %less7
  br i1 %and, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body6
  %7 = load i32, i32* %cnt
  %8 = load i32, i32* %i
  %9 = load i32, i32* %j
  %sub8 = fsub i32 %8, %9
  %10 = getelementptr [3 x [4 x i32]], [3 x [4 x i32]]* @a, i32 0, i32 %sub8
  %11 = load i32, i32* %j
  %12 = getelementptr [4 x i32], [4 x i32]* %10, i32 0, i32 %11
  store volatile i32 %7, i32* %12
  store volatile i32 1, i32* %cnt
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %13 = load i32, i32* %j
  %sub9 = fsub i32 %13, 1
  store volatile i32 %sub9, i32* %j
  br label %loop_header4
}
