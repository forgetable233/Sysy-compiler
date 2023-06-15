; ModuleID = 'default'
source_filename = "default"

@a = global [5 x [5 x i32]] [i32 1, i32 2, i32 3, i32 4, i32 5, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @func([5 x i32]* %a) {
begin:
  %0 = alloca [5 x i32]*
  store [5 x i32]* %a, [5 x i32]** %0
  %i = alloca i32
  store i32 0, i32* %i
  %j = alloca i32
  store i32 0, i32* %j
  %sum = alloca i32
  store i32 0, i32* %sum
  br label %loop_header

loop_header:                                      ; preds = %loop_exit5, %begin
  br label %begin
  %1 = load i32, i32* %i
  %less = icmp slt i32 %1, 5
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %2 = load i32, i32* %sum
  ret i32 %2

loop_body:                                        ; preds = %loop_header4, %loop_header
  br label %loop_header4

loop_header4:                                     ; preds = %loop_body6, %loop_body
  br label %loop_body
  %3 = load i32, i32* %j
  %less7 = icmp slt i32 %3, 5
  br i1 %less7, label %loop_body6, label %loop_exit5

loop_exit5:                                       ; preds = %loop_header4
  %4 = load i32, i32* %i
  %add9 = fadd i32 %4, 1
  store volatile i32 %add9, i32* %i
  br label %loop_header

loop_body6:                                       ; preds = %loop_header4
  %5 = load i32, i32* %sum
  %6 = load [5 x i32]*, [5 x i32]** %0
  %7 = load i32, i32* %i
  %8 = getelementptr [5 x i32], [5 x i32]* %6, i32 %7
  %9 = load i32, i32* %j
  %10 = getelementptr [5 x i32], [5 x i32]* %8, i32 0, i32 %9
  %11 = load i32, i32* %10
  %add = fadd i32 %5, %11
  store volatile i32 %add, i32* %sum
  %12 = load i32, i32* %j
  %add8 = fadd i32 %12, 1
  store volatile i32 %add8, i32* %j
  br label %loop_header4
}

define i32 @main() {
begin:
  %call = call i32 @func([5 x i32]* getelementptr inbounds ([5 x [5 x i32]], [5 x [5 x i32]]* @a, i32 0, i32 0))
  %call1 = call void @putint(i32 %call)
  ret i32 0
}
