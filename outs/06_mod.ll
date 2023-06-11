; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0

define i32 @main() {
begin:
  store volatile i32 10, i32* @a
  store volatile i32 3, i32* @b
  %c = alloca i32
  %0 = load i32, i32* @a
  %1 = load i32, i32* @b
  %mod = urem i32 %0, %1
  store volatile i32 %mod, i32* %c
  %2 = load i32, i32* %c
  ret i32 %2
}
