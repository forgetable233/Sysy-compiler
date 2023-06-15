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

define i32 @_getMaxOfAll(i32* %result, i32 %size) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %result, i32** %0
  store i32 %size, i32* %1
  %maxNum = alloca i32
  store volatile i32 -999999, i32* %maxNum
  %2 = load i32, i32* %1
  %sub = fsub i32 %2, 1
  store volatile i32 %sub, i32* %1
  br label %loop_header

loop_header:                                      ; preds = %merge_block, %begin
  br label %begin
  %3 = load i32, i32* %1
  %greater = icmp sgt i32 %3, -1
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %4 = load i32, i32* %maxNum
  ret i32 %4

loop_body:                                        ; preds = %loop_header
  %5 = load i32*, i32** %0
  %6 = load i32, i32* %1
  %7 = getelementptr i32, i32* %5, i32 %6
  %8 = load i32, i32* %7
  %9 = load i32, i32* %maxNum
  %greater1 = icmp sgt i32 %8, %9
  br i1 %greater1, label %true_block, <null operand!>

true_block:                                       ; preds = %loop_body
  %10 = load i32*, i32** %0
  %11 = load i32, i32* %1
  %12 = getelementptr i32, i32* %10, i32 %11
  %13 = load i32, i32* %12
  store volatile i32 %13, i32* %maxNum
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %14 = load i32, i32* %1
  %sub2 = fsub i32 %14, 1
  store volatile i32 %sub2, i32* %1
  br label %loop_header
}

define i32 @main() {
begin:
  %result = alloca [3 x i32]
  %0 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 0
  store volatile i32 -2, i32* %0
  %1 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 1
  store volatile i32 2, i32* %1
  %2 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 2
  store volatile i32 -7, i32* %2
  %x = alloca i32
  %3 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 0
  %call = call i32 @_getMaxOfAll(i32* %3, i32 3)
  %4 = getelementptr [3 x i32], [3 x i32]* %result, i32 0, i32 %call
  %5 = load i32, i32* %4
  store volatile i32 %5, i32* %x
  %6 = load i32, i32* %x
  %call1 = call void @putint(i32 %6)
  ret i32 0
}
