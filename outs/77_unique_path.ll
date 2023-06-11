; ModuleID = 'default'
source_filename = "default"

define i32 @uniquePaths(i32 %m, i32 %n) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  store i32 %m, i32* %0
  store i32 %n, i32* %1
  %2 = load i32, i32* %0
  %equal = icmp eq i32 %2, 1
  %3 = load i32, i32* %1
  %equal1 = icmp eq i32 %3, 1
  %or = or i1 %equal, %equal1
  br i1 %or, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %loop_header, %true_block
  %dp = alloca [9 x i32]
  %i = alloca i32
  %j = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %merge_block
  br label %merge_block
  %4 = load i32, i32* %i
  %5 = load i32, i32* %0
  %less = icmp slt i32 %4, %5
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header3, %loop_header
  store volatile i32 0, i32* %i
  br label %loop_header3

loop_body:                                        ; preds = %loop_header
  %6 = load i32, i32* %i
  %mul = mul i32 %6, 3
  %7 = load i32, i32* %1
  %add = fadd i32 %mul, %7
  %sub = fsub i32 %add, 1
  %8 = getelementptr [9 x i32], [9 x i32]* %dp, i32 0, i32 %sub
  store volatile i32 1, i32* %8
  %9 = load i32, i32* %i
  %add2 = fadd i32 %9, 1
  store volatile i32 %add2, i32* %i
  br label %loop_header

loop_header3:                                     ; preds = %loop_body5, %loop_exit
  br label %loop_exit
  %10 = load i32, i32* %i
  %11 = load i32, i32* %1
  %less6 = icmp slt i32 %10, %11
  br i1 %less6, label %loop_body5, label %loop_exit4

loop_exit4:                                       ; preds = %loop_header12, %loop_header3
  %12 = load i32, i32* %0
  %sub11 = fsub i32 %12, 2
  store volatile i32 %sub11, i32* %i
  br label %loop_header12

loop_body5:                                       ; preds = %loop_header3
  %13 = load i32, i32* %0
  %sub7 = fsub i32 %13, 1
  %mul8 = mul i32 %sub7, 3
  %14 = load i32, i32* %i
  %add9 = fadd i32 %mul8, %14
  %15 = getelementptr [9 x i32], [9 x i32]* %dp, i32 0, i32 %add9
  store volatile i32 1, i32* %15
  %16 = load i32, i32* %i
  %add10 = fadd i32 %16, 1
  store volatile i32 %add10, i32* %i
  br label %loop_header3

loop_header12:                                    ; preds = %loop_exit17, %loop_exit4
  br label %loop_exit4
  %17 = load i32, i32* %i
  %greater = icmp sgt i32 %17, -1
  br i1 %greater, label %loop_body14, label %loop_exit13

loop_exit13:                                      ; preds = %loop_header12
  %18 = getelementptr [9 x i32], [9 x i32]* %dp, i32 0, i32 0
  %19 = load i32, i32* %18
  ret i32 %19

loop_body14:                                      ; preds = %loop_header16, %loop_header12
  %20 = load i32, i32* %1
  %sub15 = fsub i32 %20, 2
  store volatile i32 %sub15, i32* %j
  br label %loop_header16

loop_header16:                                    ; preds = %loop_body18, %loop_body14
  br label %loop_body14
  %21 = load i32, i32* %j
  %greater19 = icmp sgt i32 %21, -1
  br i1 %greater19, label %loop_body18, label %loop_exit17

loop_exit17:                                      ; preds = %loop_header16
  %22 = load i32, i32* %i
  %sub30 = fsub i32 %22, 1
  store volatile i32 %sub30, i32* %i
  br label %loop_header12

loop_body18:                                      ; preds = %loop_header16
  %23 = load i32, i32* %i
  %add20 = fadd i32 %23, 1
  %mul21 = mul i32 %add20, 3
  %24 = load i32, i32* %j
  %add22 = fadd i32 %mul21, %24
  %25 = getelementptr [9 x i32], [9 x i32]* %dp, i32 0, i32 %add22
  %26 = load i32, i32* %25
  %27 = load i32, i32* %i
  %mul23 = mul i32 %27, 3
  %28 = load i32, i32* %j
  %add24 = fadd i32 %mul23, %28
  %add25 = fadd i32 %add24, 1
  %29 = getelementptr [9 x i32], [9 x i32]* %dp, i32 0, i32 %add25
  %30 = load i32, i32* %29
  %add26 = fadd i32 %26, %30
  %31 = load i32, i32* %i
  %mul27 = mul i32 %31, 3
  %32 = load i32, i32* %j
  %add28 = fadd i32 %mul27, %32
  %33 = getelementptr [9 x i32], [9 x i32]* %dp, i32 0, i32 %add28
  store volatile i32 %add26, i32* %33
  %34 = load i32, i32* %j
  %sub29 = fsub i32 %34, 1
  store volatile i32 %sub29, i32* %j
  br label %loop_header16
}

define i32 @main() {
begin:
  %res = alloca i32
  %n = alloca i32
  store volatile i32 3, i32* %n
  %0 = load i32, i32* %n
  %1 = load i32, i32* %n
  %call = call i32 @uniquePaths(i32 %0, i32 %1)
  store volatile i32 %call, i32* %res
  %2 = load i32, i32* %res
  ret i32 %2
}
