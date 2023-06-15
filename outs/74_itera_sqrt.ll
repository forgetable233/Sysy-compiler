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

define i32 @fsqrt(i32 %a) {
begin:
  %0 = alloca i32
  store i32 %a, i32* %0
  %x0 = alloca i32
  store i32 0, i32* %x0
  %x1 = alloca i32
  %1 = load i32, i32* %0
  %div = fdiv i32 %1, 2
  store volatile i32 %div, i32* %x1
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %2 = load i32, i32* %x0
  %3 = load i32, i32* %x1
  %sub = fsub i32 %2, %3
  %not_equal = icmp ne i32 %sub, 0
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %4 = load i32, i32* %x1
  ret i32 %4

loop_body:                                        ; preds = %loop_header
  %5 = load i32, i32* %x1
  store volatile i32 %5, i32* %x0
  %6 = load i32, i32* %x0
  %7 = load i32, i32* %0
  %8 = load i32, i32* %x0
  %div2 = fdiv i32 %7, %8
  %add = fadd i32 %6, %div2
  store volatile i32 %add, i32* %x1
  %9 = load i32, i32* %x1
  %div3 = fdiv i32 %9, 2
  store volatile i32 %div3, i32* %x1
  br label %loop_header
}

define i32 @main() {
begin:
  %a = alloca i32
  store volatile i32 400, i32* %a
  %res = alloca i32
  %0 = load i32, i32* %a
  %call = call i32 @fsqrt(i32 %0)
  store volatile i32 %call, i32* %res
  %1 = load i32, i32* %res
  %call1 = call void @putint(i32 %1)
  store volatile i32 10, i32* %res
  %2 = load i32, i32* %res
  %call2 = call void @putch(i32 %2)
  ret i32 0
}
