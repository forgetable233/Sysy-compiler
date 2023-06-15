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
  %a = alloca [10 x i32]
  store volatile i32 0, i32* %sum
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %i
  %less = icmp slt i32 %0, 10
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header3, %loop_header
  %x = alloca i32
  %high = alloca i32
  %low = alloca i32
  %mid = alloca i32
  %n = alloca i32
  store volatile i32 10, i32* %n
  %call = call i32 @getint()
  store volatile i32 %call, i32* %x
  %1 = load i32, i32* %n
  %sub = fsub i32 %1, 1
  store volatile i32 %sub, i32* %high
  store volatile i32 0, i32* %low
  %2 = load i32, i32* %high
  %3 = load i32, i32* %low
  %add2 = fadd i32 %2, %3
  %div = fdiv i32 %add2, 2
  store volatile i32 %div, i32* %mid
  br label %loop_header3

loop_body:                                        ; preds = %loop_header
  %4 = load i32, i32* %i
  %add = fadd i32 %4, 1
  %5 = load i32, i32* %i
  %6 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %5
  store volatile i32 %add, i32* %6
  %7 = load i32, i32* %i
  %add1 = fadd i32 %7, 1
  store volatile i32 %add1, i32* %i
  br label %loop_header

loop_header3:                                     ; preds = %merge_block, %loop_exit
  br label %loop_exit
  %8 = load i32, i32* %mid
  %9 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %8
  %10 = load i32, i32* %9
  %11 = load i32, i32* %x
  %not_equal = icmp ne i32 %10, %11
  %12 = load i32, i32* %low
  %13 = load i32, i32* %high
  %less6 = icmp slt i32 %12, %13
  %and = and i1 %not_equal, %less6
  br i1 %and, label %loop_body5, label %loop_exit4

loop_exit4:                                       ; preds = %loop_header3
  %14 = load i32, i32* %x
  %15 = load i32, i32* %mid
  %16 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %15
  %17 = load i32, i32* %16
  %equal = icmp eq i32 %14, %17
  br i1 %equal, label %true_block12, label %false_block14

loop_body5:                                       ; preds = %loop_header3
  %18 = load i32, i32* %high
  %19 = load i32, i32* %low
  %add7 = fadd i32 %18, %19
  %div8 = fdiv i32 %add7, 2
  store volatile i32 %div8, i32* %mid
  %20 = load i32, i32* %x
  %21 = load i32, i32* %mid
  %22 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 %21
  %23 = load i32, i32* %22
  %less9 = icmp slt i32 %20, %23
  br i1 %less9, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body5
  %24 = load i32, i32* %mid
  %sub10 = fsub i32 %24, 1
  store volatile i32 %sub10, i32* %high
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  br label %loop_header3

false_block:                                      ; preds = %loop_body5
  %25 = load i32, i32* %mid
  %add11 = fadd i32 %25, 1
  store volatile i32 %add11, i32* %low
  br label %merge_block

true_block12:                                     ; preds = %loop_exit4
  %26 = load i32, i32* %x
  %call15 = call void @putint(i32 %26)
  br label %merge_block13

merge_block13:                                    ; preds = %false_block14, %true_block12
  store volatile i32 10, i32* %x
  %27 = load i32, i32* %x
  %call17 = call void @putch(i32 %27)
  ret i32 0

false_block14:                                    ; preds = %loop_exit4
  store volatile i32 0, i32* %x
  %28 = load i32, i32* %x
  %call16 = call void @putint(i32 %28)
  br label %merge_block13
}
