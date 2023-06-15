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
  %a = alloca i32
  %b = alloca i32
  %c = alloca i32
  %d = alloca i32
  %result = alloca i32
  store volatile i32 5, i32* %a
  store volatile i32 5, i32* %b
  store volatile i32 1, i32* %c
  store volatile i32 -2, i32* %d
  store volatile i32 2, i32* %result
  %0 = load i32, i32* %d
  %mul = mul i32 %0, 1
  %div = fdiv i32 %mul, 2
  %less = icmp slt i32 %div, 0
  %1 = load i32, i32* %a
  %2 = load i32, i32* %b
  %sub = fsub i32 %1, %2
  %not_equal = icmp ne i32 %sub, 0
  %3 = load i32, i32* %c
  %add = fadd i32 %3, 3
  %mod = urem i32 %add, 2
  %not_equal1 = icmp ne i32 %mod, 0
  %and = and i1 %not_equal, %not_equal1
  %or = or i1 %less, %and
  br i1 %or, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  %4 = load i32, i32* %result
  %call = call void @putint(i32 %4)
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %5 = load i32, i32* %d
  %mod2 = urem i32 %5, 2
  %add3 = fadd i32 %mod2, 67
  %less4 = icmp slt i32 %add3, 0
  %6 = load i32, i32* %a
  %7 = load i32, i32* %b
  %sub5 = fsub i32 %6, %7
  %not_equal6 = icmp ne i32 %sub5, 0
  %8 = load i32, i32* %c
  %add7 = fadd i32 %8, 2
  %mod8 = urem i32 %add7, 2
  %not_equal9 = icmp ne i32 %mod8, 0
  %and10 = and i1 %not_equal6, %not_equal9
  %or11 = or i1 %less4, %and10
  br i1 %or11, label %true_block12, <null operand!>

true_block12:                                     ; preds = %merge_block
  store volatile i32 4, i32* %result
  %9 = load i32, i32* %result
  %call14 = call void @putint(i32 %9)
  br label %merge_block13

merge_block13:                                    ; preds = %true_block12
  ret i32 0
}
