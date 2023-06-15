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
  store volatile i32 10, i32* %a
  store volatile i32 6, i32* %b
  store volatile i32 4, i32* %c
  store volatile i32 5, i32* %d
  %t = alloca i32
  %0 = load i32, i32* %b
  %1 = load i32, i32* %c
  %add = fadd i32 %0, %1
  %2 = load i32, i32* %a
  %equal = icmp eq i32 %add, %2
  %3 = load i32, i32* %d
  %4 = load i32, i32* %a
  %div = fdiv i32 %4, 2
  %not_equal = icmp ne i32 %3, %div
  %and = and i1 %equal, %not_equal
  br i1 %and, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  %5 = load i32, i32* %b
  %6 = load i32, i32* %c
  %7 = load i32, i32* %d
  %div1 = fdiv i32 %6, %7
  %mul = mul i32 %div1, 2
  %add2 = fadd i32 %5, %mul
  store volatile i32 %add2, i32* %t
  %8 = load i32, i32* %t
  %call = call void @putint(i32 %8)
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %9 = load i32, i32* %c
  %less = icmp slt i32 %9, 0
  %10 = load i32, i32* %a
  %11 = load i32, i32* %c
  %sub = fsub i32 %10, %11
  %12 = load i32, i32* %b
  %equal3 = icmp eq i32 %sub, %12
  %13 = load i32, i32* %a
  %14 = load i32, i32* %d
  %mul4 = mul i32 %14, 2
  %not_equal5 = icmp ne i32 %13, %mul4
  %and6 = and i1 %equal3, %not_equal5
  %or = or i1 %less, %and6
  br i1 %or, label %true_block7, <null operand!>

true_block7:                                      ; preds = %merge_block
  store volatile i32 1, i32* %t
  %15 = load i32, i32* %t
  %call9 = call void @putint(i32 %15)
  br label %merge_block8

merge_block8:                                     ; preds = %true_block7
  ret i32 0
}
