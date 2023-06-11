; ModuleID = 'default'
source_filename = "default"

@a = global i32 0

define i32 @main() {
begin:
  store volatile i32 10, i32* @a
  %0 = load i32, i32* @a
  ret i32 %0
}
