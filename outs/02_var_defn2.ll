; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0

define i32 @main() {
begin:
  store volatile i32 10, i32* @a
  %c = alloca i32
  store volatile i32 10, i32* %c
  ret i32 0
}
