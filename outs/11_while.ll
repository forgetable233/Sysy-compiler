; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0

define i32 @main() {
begin:
  store volatile i32 0, i32* @b
  store volatile i32 3, i32* @a
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* @a
  %greater = icmp sgt i32 %0, 0
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* @b
  ret i32 %1

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* @b
  %3 = load i32, i32* @a
  %add = fadd i32 %2, %3
  store volatile i32 %add, i32* @b
  %4 = load i32, i32* @a
  %sub = fsub i32 %4, 1
  store volatile i32 %sub, i32* @a
  br label %loop_header
}
