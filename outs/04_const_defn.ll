; ModuleID = 'default'
source_filename = "default"

@x = global i32 4

define i32 @main() {
begin:
  %0 = load i32, i32* @x
  ret i32 %0
}
