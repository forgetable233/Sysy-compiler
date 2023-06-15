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

define i32 @enc(i32 %a) {
begin:
  %0 = alloca i32
  store i32 %a, i32* %0
  %1 = load i32, i32* %0
  %greater = icmp sgt i32 %1, 25
  br i1 %greater, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  %2 = load i32, i32* %0
  %add = fadd i32 %2, 60
  store volatile i32 %add, i32* %0
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  %3 = load i32, i32* %0
  ret i32 %3

false_block:                                      ; preds = %begin
  %4 = load i32, i32* %0
  %sub = fsub i32 %4, 15
  store volatile i32 %sub, i32* %0
  br label %merge_block
}

define i32 @dec(i32 %a) {
begin:
  %0 = alloca i32
  store i32 %a, i32* %0
  %1 = load i32, i32* %0
  %greater = icmp sgt i32 %1, 85
  br i1 %greater, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  %2 = load i32, i32* %0
  %sub = fsub i32 %2, 59
  store volatile i32 %sub, i32* %0
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block
  %3 = load i32, i32* %0
  ret i32 %3

false_block:                                      ; preds = %begin
  %4 = load i32, i32* %0
  %add = fadd i32 %4, 14
  store volatile i32 %add, i32* %0
  br label %merge_block
}

define i32 @main() {
begin:
  %a = alloca i32
  store volatile i32 400, i32* %a
  %res = alloca i32
  %0 = load i32, i32* %a
  %call = call i32 @enc(i32 %0)
  store volatile i32 %call, i32* %res
  %1 = load i32, i32* %res
  %call1 = call i32 @dec(i32 %1)
  store volatile i32 %call1, i32* %res
  %2 = load i32, i32* %res
  %call2 = call void @putint(i32 %2)
  store volatile i32 10, i32* %res
  %3 = load i32, i32* %res
  %call3 = call void @putch(i32 %3)
  ret i32 0
}
