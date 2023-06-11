; ModuleID = 'default'
source_filename = "default"

define i32 @fact(i32 %n) {
begin:
  %0 = alloca i32
  store i32 %n, i32* %0
  %1 = load i32, i32* %0
  %equal = icmp eq i32 %1, 0
  br i1 %equal, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %nn = alloca i32
  %2 = load i32, i32* %0
  %sub = fsub i32 %2, 1
  store volatile i32 %sub, i32* %nn
  %3 = load i32, i32* %0
  %4 = load i32, i32* %nn
  %call = call i32 @fact(i32 %4)
  %mul = mul i32 %3, %call
  ret i32 %mul
}

define i32 @main() {
begin:
  %n = alloca i32
  store volatile i32 4, i32* %n
  %0 = load i32, i32* %n
  %call = call i32 @fact(i32 %0)
  ret i32 %call
}
