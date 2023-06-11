; ModuleID = 'default'
source_filename = "default"

define i32 @lengthOfLastWord(i32* %s, i32 %n) {
begin:
  %0 = alloca i32*
  %1 = alloca i32
  store i32* %s, i32** %0
  store i32 %n, i32* %1
  %2 = load i32, i32* %1
  %equal = icmp eq i32 %2, 0
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 0
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  %c = alloca i32
  %3 = load i32, i32* %1
  %sub = fsub i32 %3, 1
  store volatile i32 %sub, i32* %c
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %4 = load i32, i32* %c
  %greater = icmp sgt i32 %4, -1
  %5 = load i32*, i32** %0
  %6 = load i32, i32* %c
  %7 = getelementptr i32, i32* %5, i32 %6
  %8 = load i32, i32* %7
  %equal1 = icmp eq i32 %8, 0
  %and = and i1 %greater, %equal1
  br i1 %and, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %9 = load i32, i32* %c
  %equal3 = icmp eq i32 %9, -1
  br i1 %equal3, label %true_block4, <null operand!>

loop_body:                                        ; preds = %loop_header
  %10 = load i32, i32* %c
  %sub2 = fsub i32 %10, 1
  store volatile i32 %sub2, i32* %c
  br label %loop_header

true_block4:                                      ; preds = %loop_exit
  ret i32 0
  br label %merge_block5

merge_block5:                                     ; preds = %loop_header6, %true_block4
  %i = alloca i32
  %11 = load i32, i32* %c
  store volatile i32 %11, i32* %i
  br label %loop_header6

loop_header6:                                     ; preds = %merge_block12, %merge_block5
  br label %merge_block5
  %12 = load i32, i32* %i
  %greater9 = icmp sgt i32 %12, -1
  br i1 %greater9, label %loop_body8, label %loop_exit7

loop_exit7:                                       ; preds = %loop_header6
  %13 = load i32, i32* %c
  %14 = load i32, i32* %i
  %sub19 = fsub i32 %13, %14
  ret i32 %sub19

loop_body8:                                       ; preds = %loop_header6
  %15 = load i32*, i32** %0
  %16 = load i32, i32* %i
  %17 = getelementptr i32, i32* %15, i32 %16
  %18 = load i32, i32* %17
  %equal10 = icmp eq i32 %18, 0
  br i1 %equal10, label %true_block11, <null operand!>

true_block11:                                     ; preds = %loop_body8
  %19 = load i32, i32* %1
  %20 = load i32, i32* %i
  %sub13 = fsub i32 %19, %20
  %sub14 = fsub i32 %sub13, 1
  %21 = load i32, i32* %1
  %sub15 = fsub i32 %21, 1
  %22 = load i32, i32* %c
  %sub16 = fsub i32 %sub15, %22
  %sub17 = fsub i32 %sub14, %sub16
  ret i32 %sub17
  br label %merge_block12

merge_block12:                                    ; preds = %true_block11
  %23 = load i32, i32* %i
  %sub18 = fsub i32 %23, 1
  store volatile i32 %sub18, i32* %i
  br label %loop_header6
}

define i32 @main() {
begin:
  %res = alloca i32
  %a = alloca [10 x i32]
  %0 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  store volatile i32 -4, i32* %0
  %1 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 1
  store volatile i32 3, i32* %1
  %2 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 2
  store volatile i32 9, i32* %2
  %3 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 3
  store volatile i32 -2, i32* %3
  %4 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 4
  store volatile i32 0, i32* %4
  %5 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 5
  store volatile i32 1, i32* %5
  %6 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 6
  store volatile i32 -6, i32* %6
  %7 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 7
  store volatile i32 5, i32* %7
  %8 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 8
  store volatile i32 7, i32* %8
  %9 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 9
  store volatile i32 8, i32* %9
  store volatile i32 10, i32* %res
  %10 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  %11 = load i32, i32* %res
  %call = call i32 @lengthOfLastWord(i32* %10, i32 %11)
  store volatile i32 %call, i32* %res
  %12 = load i32, i32* %res
  ret i32 %12
}
