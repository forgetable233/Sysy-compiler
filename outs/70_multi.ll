; ModuleID = 'default'
source_filename = "default"

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @main() {
begin:
  %i = alloca i32
  %sum = alloca i32
  store volatile i32 0, i32* %sum
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %i
  %less = icmp slt i32 %0, 21
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %sum
  %call = call void @putint(i32 %1)
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* %sum
  %3 = load i32, i32* %i
  %mul = mul i32 %2, %3
  store volatile i32 %mul, i32* %sum
  %4 = load i32, i32* %i
  %add = fadd i32 %4, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
