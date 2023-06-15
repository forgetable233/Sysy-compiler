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

define i32 @wc(i32* %string, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %string, i32** %0
  store i32 %n, i32* %1
  %inWord = alloca i32
  %i = alloca i32
  %count = alloca i32
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %inWord
  store volatile i32 0, i32* %count
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %2 = load i32, i32* %i
  %3 = load i32, i32* %1
  %less = icmp slt i32 %2, %3
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %4 = load i32, i32* %count
  ret i32 %4

loop_body:                                        ; preds = %loop_header
  %5 = load i32*, i32** %0
  %6 = load i32, i32* %i
  %7 = getelementptr i32, i32* %5, i32 %6
  %8 = load i32, i32* %7
  %not_equal = icmp ne i32 %8, 32
  br i1 %not_equal, label %true_block, label %false_block

true_block:                                       ; preds = %loop_body
  %9 = load i32, i32* %inWord
  %equal = icmp eq i32 %9, 0
  br i1 %equal, label %true_block1, <null operand!>

merge_block:                                      ; preds = %false_block, %merge_block2
  %10 = load i32, i32* %i
  %add3 = fadd i32 %10, 1
  store volatile i32 %add3, i32* %i
  br label %loop_header

false_block:                                      ; preds = %loop_body
  store volatile i32 0, i32* %inWord
  br label %merge_block

true_block1:                                      ; preds = %true_block
  %11 = load i32, i32* %count
  %add = fadd i32 %11, 1
  store volatile i32 %add, i32* %count
  store volatile i32 1, i32* %inWord
  br label %merge_block2

merge_block2:                                     ; preds = %true_block1
  br label %merge_block
}

define i32 @main() {
begin:
  %string = alloca [500 x i32]
  %temp = alloca i32
  %i = alloca i32
  store volatile i32 0, i32* %i
  store volatile i32 0, i32* %temp
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %temp
  %not_equal = icmp ne i32 %0, 10
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = getelementptr [500 x i32], [500 x i32]* %string, i32 0, i32 0
  %2 = load i32, i32* %i
  %call1 = call i32 @wc(i32* %1, i32 %2)
  store volatile i32 %call1, i32* %temp
  %3 = load i32, i32* %temp
  %call2 = call void @putint(i32 %3)
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %call = call i32 @getch()
  store volatile i32 %call, i32* %temp
  %4 = load i32, i32* %temp
  %5 = load i32, i32* %i
  %6 = getelementptr [500 x i32], [500 x i32]* %string, i32 0, i32 %5
  store volatile i32 %4, i32* %6
  %7 = load i32, i32* %i
  %add = fadd i32 %7, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
