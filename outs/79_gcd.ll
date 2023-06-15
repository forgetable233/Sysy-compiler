; ModuleID = 'default'
source_filename = "default"

@n = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @gcd(i32 %m, i32 %n) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  store i32 %m, i32* %0
  store i32 %n, i32* %1
  %t = alloca i32
  %r = alloca i32
  %2 = load i32, i32* %0
  %3 = load i32, i32* %1
  %less = icmp slt i32 %2, %3
  br i1 %less, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  %4 = load i32, i32* %0
  store volatile i32 %4, i32* %t
  %5 = load i32, i32* %1
  store volatile i32 %5, i32* %0
  %6 = load i32, i32* %t
  store volatile i32 %6, i32* %1
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  %7 = load i32, i32* %0
  %8 = load i32, i32* %1
  %mod = urem i32 %7, %8
  store volatile i32 %mod, i32* %r
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %9 = load i32, i32* %r
  %not_equal = icmp ne i32 %9, 0
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %10 = load i32, i32* %1
  ret i32 %10

loop_body:                                        ; preds = %loop_header
  %11 = load i32, i32* %1
  store volatile i32 %11, i32* %0
  %12 = load i32, i32* %r
  store volatile i32 %12, i32* %1
  %13 = load i32, i32* %0
  %14 = load i32, i32* %1
  %mod1 = urem i32 %13, %14
  store volatile i32 %mod1, i32* %r
  br label %loop_header
}

define i32 @main() {
begin:
  %i = alloca i32
  %m = alloca i32
  %call = call i32 @getint()
  store volatile i32 %call, i32* %i
  %call1 = call i32 @getint()
  store volatile i32 %call1, i32* %m
  %0 = load i32, i32* %i
  %1 = load i32, i32* %m
  %call2 = call i32 @gcd(i32 %0, i32 %1)
  ret i32 %call2
}
