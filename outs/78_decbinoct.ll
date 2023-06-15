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

define i32 @dec2bin(i32 %a) {
begin:
  %0 = alloca i32
  store i32 %a, i32* %0
  %res = alloca i32
  %k = alloca i32
  %i = alloca i32
  %temp = alloca i32
  store volatile i32 0, i32* %res
  store volatile i32 1, i32* %k
  %1 = load i32, i32* %0
  store volatile i32 %1, i32* %temp
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %2 = load i32, i32* %temp
  %not_equal = icmp ne i32 %2, 0
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %3 = load i32, i32* %res
  ret i32 %3

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %temp
  %mod = urem i32 %4, 2
  store volatile i32 %mod, i32* %i
  %5 = load i32, i32* %k
  %6 = load i32, i32* %i
  %mul = mul i32 %5, %6
  %7 = load i32, i32* %res
  %add = fadd i32 %mul, %7
  store volatile i32 %add, i32* %res
  %8 = load i32, i32* %k
  %mul1 = mul i32 %8, 10
  store volatile i32 %mul1, i32* %k
  %9 = load i32, i32* %temp
  %div = fdiv i32 %9, 2
  store volatile i32 %div, i32* %temp
  br label %loop_header
}

define i32 @main() {
begin:
  %a = alloca i32
  store volatile i32 400, i32* %a
  %res = alloca i32
  %0 = load i32, i32* %a
  %call = call i32 @dec2bin(i32 %0)
  store volatile i32 %call, i32* %res
  %1 = load i32, i32* %res
  %call1 = call void @putint(i32 %1)
  store volatile i32 10, i32* %res
  %2 = load i32, i32* %res
  %call2 = call void @putch(i32 %2)
  ret i32 0
}
