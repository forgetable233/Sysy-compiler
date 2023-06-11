; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@r = global i32 0

define i32 @fac(i32 %x) {
begin:
  %0 = alloca i32
  store i32 %x, i32* %0
  %1 = load i32, i32* %0
  %less = icmp slt i32 %1, 2
  br i1 %less, label %true_block, <null operand!>

true_block:                                       ; preds = %begin
  ret i32 1
  br label %merge_block

merge_block:                                      ; preds = %true_block
  %2 = load i32, i32* %0
  %sub = fsub i32 %2, 1
  store volatile i32 %sub, i32* @a
  %3 = load i32, i32* @a
  %call = call i32 @fac(i32 %3)
  store volatile i32 %call, i32* @r
  %4 = load i32, i32* %0
  %5 = load i32, i32* @r
  %mul = mul i32 %4, %5
  store volatile i32 %mul, i32* @r
  %6 = load i32, i32* @r
  ret i32 %6
}

define i32 @main() {
begin:
  %a = alloca i32
  store volatile i32 5, i32* %a
  %0 = load i32, i32* %a
  %call = call i32 @fac(i32 %0)
  ret i32 %call
}
