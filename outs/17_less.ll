; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0

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
  store volatile i32 %call, i32* @a
  %call1 = call i32 @getint()
  store volatile i32 %call1, i32* @b
  %0 = load i32, i32* @a
  %1 = load i32, i32* @b
  %less = icmp slt i32 %0, %1
  br i1 %less, label %true_block, label %false_block

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %false_block, %true_block

false_block:                                      ; preds = %begin
  ret i32 0
  br label %merge_block
}
