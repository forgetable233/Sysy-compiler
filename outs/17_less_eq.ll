; ModuleID = 'default'
source_filename = "default"

@a = global i32 5
@s = global [10 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]

define i32 @main() {
begin:
  %i = alloca i32
  store i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %i
  %1 = getelementptr [10 x i32], [10 x i32]* @s, i32 0, i32 %0
  %2 = load i32, i32* %1
  %3 = load i32, i32* @a
  %less_equal = icmp sle i32 %2, %3
  br i1 %less_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %4 = load i32, i32* %i
  ret i32 %4

loop_body:                                        ; preds = %loop_header
  %5 = load i32, i32* %i
  %add = fadd i32 %5, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
