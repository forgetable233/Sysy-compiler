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
  %a = alloca i32
  %b = alloca i32
  %2 = load i32, i32* %0
  store volatile i32 %2, i32* %a
  %3 = load i32, i32* %1
  store volatile i32 %3, i32* %b
  %t = alloca i32
  %r = alloca i32
  %4 = load i32, i32* %0
  %5 = load i32, i32* %1
  %less = icmp slt i32 %4, %5
  br i1 %less, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  %6 = load i32, i32* %0
  store volatile i32 %6, i32* %t
  %7 = load i32, i32* %1
  store volatile i32 %7, i32* %0
  %8 = load i32, i32* %t
  store volatile i32 %8, i32* %1
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  %9 = load i32, i32* %0
  %10 = load i32, i32* %1
  %mod = urem i32 %9, %10
  store volatile i32 %mod, i32* %r
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %11 = load i32, i32* %r
  %not_equal = icmp ne i32 %11, 0
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %12 = load i32, i32* %a
  %13 = load i32, i32* %b
  %mul = mul i32 %12, %13
  %14 = load i32, i32* %1
  %div = fdiv i32 %mul, %14
  ret i32 %div

loop_body:                                        ; preds = %loop_header
  %15 = load i32, i32* %1
  store volatile i32 %15, i32* %0
  %16 = load i32, i32* %r
  store volatile i32 %16, i32* %1
  %17 = load i32, i32* %0
  %18 = load i32, i32* %1
  %mod1 = urem i32 %17, %18
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
