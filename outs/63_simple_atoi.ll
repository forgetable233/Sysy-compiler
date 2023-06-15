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

define i32 @atoi_(i32* %src) {
begin:
  %0 = alloca i32*
  store i32* %src, i32** %0
  %s = alloca i32
  store volatile i32 0, i32* %s
  %isMinus = alloca i32
  store volatile i32 1, i32* %isMinus
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %1 = load i32*, i32** %0
  %2 = load i32, i32* %i
  %3 = getelementptr i32, i32* %1, i32 %2
  %4 = load i32, i32* %3
  %equal = icmp eq i32 %4, 32
  br i1 %equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %5 = load i32*, i32** %0
  %6 = load i32, i32* %i
  %7 = getelementptr i32, i32* %5, i32 %6
  %8 = load i32, i32* %7
  %equal1 = icmp eq i32 %8, 43
  %9 = load i32*, i32** %0
  %10 = load i32, i32* %i
  %11 = getelementptr i32, i32* %9, i32 %10
  %12 = load i32, i32* %11
  %equal2 = icmp eq i32 %12, 45
  %or = or i1 %equal1, %equal2
  br i1 %or, label %true_block, label %false_block

loop_body:                                        ; preds = %loop_header
  %13 = load i32, i32* %i
  %add = fadd i32 %13, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

true_block:                                       ; preds = %loop_exit
  %14 = load i32*, i32** %0
  %15 = load i32, i32* %i
  %16 = getelementptr i32, i32* %14, i32 %15
  %17 = load i32, i32* %16
  %equal3 = icmp eq i32 %17, 45
  br i1 %equal3, label %true_block4, <null operand!>

merge_block:                                      ; preds = %loop_header10, %merge_block9, %merge_block5
  br label %loop_header10

false_block:                                      ; preds = %loop_exit
  %18 = load i32*, i32** %0
  %19 = load i32, i32* %i
  %20 = getelementptr i32, i32* %18, i32 %19
  %21 = load i32, i32* %20
  %less = icmp slt i32 %21, 48
  %22 = load i32*, i32** %0
  %23 = load i32, i32* %i
  %24 = getelementptr i32, i32* %22, i32 %23
  %25 = load i32, i32* %24
  %greater = icmp sgt i32 %25, 57
  %or7 = or i1 %less, %greater
  br i1 %or7, label %true_block8, <null operand!>

true_block4:                                      ; preds = %true_block
  store volatile i32 -1, i32* %isMinus
  br label %merge_block5

merge_block5:                                     ; preds = %true_block4
  %26 = load i32, i32* %i
  %add6 = fadd i32 %26, 1
  store volatile i32 %add6, i32* %i
  br label %merge_block

true_block8:                                      ; preds = %false_block
  store volatile i32 2147483647, i32* %s
  %27 = load i32, i32* %s
  ret i32 %27
  br label %merge_block9

merge_block9:                                     ; preds = %true_block8
  br label %merge_block

loop_header10:                                    ; preds = %loop_body12, %merge_block
  br label %merge_block
  %28 = load i32*, i32** %0
  %29 = load i32, i32* %i
  %30 = getelementptr i32, i32* %28, i32 %29
  %31 = load i32, i32* %30
  %not_equal = icmp ne i32 %31, 0
  %32 = load i32*, i32** %0
  %33 = load i32, i32* %i
  %34 = getelementptr i32, i32* %32, i32 %33
  %35 = load i32, i32* %34
  %greater13 = icmp sgt i32 %35, 47
  %and = and i1 %not_equal, %greater13
  %36 = load i32*, i32** %0
  %37 = load i32, i32* %i
  %38 = getelementptr i32, i32* %36, i32 %37
  %39 = load i32, i32* %38
  %less14 = icmp slt i32 %39, 58
  %and15 = and i1 %and, %less14
  br i1 %and15, label %loop_body12, label %loop_exit11

loop_exit11:                                      ; preds = %loop_header10
  %40 = load i32, i32* %s
  %41 = load i32, i32* %isMinus
  %mul18 = mul i32 %40, %41
  ret i32 %mul18

loop_body12:                                      ; preds = %loop_header10
  %42 = load i32, i32* %s
  %mul = mul i32 %42, 10
  %43 = load i32*, i32** %0
  %44 = load i32, i32* %i
  %45 = getelementptr i32, i32* %43, i32 %44
  %46 = load i32, i32* %45
  %add16 = fadd i32 %mul, %46
  %sub = fsub i32 %add16, 48
  store volatile i32 %sub, i32* %s
  %47 = load i32, i32* %i
  %add17 = fadd i32 %47, 1
  store volatile i32 %add17, i32* %i
  br label %loop_header10
}

define i32 @main() {
begin:
  %string = alloca [500 x i32]
  %temp = alloca i32
  store volatile i32 0, i32* %temp
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %temp
  %not_equal = icmp ne i32 %0, 10
  br i1 %not_equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %i
  %2 = getelementptr [500 x i32], [500 x i32]* %string, i32 0, i32 %1
  store volatile i32 0, i32* %2
  %3 = getelementptr [500 x i32], [500 x i32]* %string, i32 0, i32 0
  %call1 = call i32 @atoi_(i32* %3)
  store volatile i32 %call1, i32* %i
  %4 = load i32, i32* %i
  %call2 = call void @putint(i32 %4)
  ret i32 0

loop_body:                                        ; preds = %loop_header
  %call = call i32 @getch()
  store volatile i32 %call, i32* %temp
  %5 = load i32, i32* %temp
  %6 = load i32, i32* %i
  %7 = getelementptr [500 x i32], [500 x i32]* %string, i32 0, i32 %6
  store volatile i32 %5, i32* %7
  %8 = load i32, i32* %i
  %add = fadd i32 %8, 1
  store volatile i32 %add, i32* %i
  br label %loop_header
}
