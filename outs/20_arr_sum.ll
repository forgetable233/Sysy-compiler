; ModuleID = 'default'
source_filename = "default"

@a = global [5 x i32] zeroinitializer

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
  %call = call i32 @getint()
  store volatile i32 %call, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 0)
  %call1 = call i32 @getint()
  store volatile i32 %call1, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 1)
  %call2 = call i32 @getint()
  store volatile i32 %call2, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 2)
  %call3 = call i32 @getint()
  store volatile i32 %call3, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 3)
  %call4 = call i32 @getint()
  store volatile i32 %call4, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 4)
  %cnt = alloca i32
  store volatile i32 4, i32* %cnt
  %sum = alloca i32
  store volatile i32 0, i32* %sum
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %cnt
  %greater = icmp sgt i32 %0, 1
  br i1 %greater, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %sum
  ret i32 %1

loop_body:                                        ; preds = %loop_header
  %2 = load i32, i32* %sum
  %3 = load i32, i32* %cnt
  %4 = getelementptr [5 x i32], [5 x i32]* @a, i32 0, i32 %3
  %5 = load i32, i32* %4
  %add = fadd i32 %2, %5
  store volatile i32 %add, i32* %sum
  %6 = load i32, i32* %cnt
  %sub = fsub i32 %6, 1
  store volatile i32 %sub, i32* %cnt
  br label %loop_header
}
