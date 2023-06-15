; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0

define i32 @main() {
begin:
  store volatile i32 10, i32* @a
  store volatile i32 5, i32* @b
  %c = alloca i32
  %0 = load i32, i32* @a
  %mul = mul i32 %0, 2
  %1 = load i32, i32* @b
  %add = fadd i32 %mul, %1
  %add2 = fadd i32 %add, 3
  store i32 %add2, i32* %c
  %2 = load i32, i32* %c
  ret i32 %2
}
