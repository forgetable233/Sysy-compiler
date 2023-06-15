; ModuleID = 'default'
source_filename = "default"

@a = global [5 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4]

define i32 @main() {
begin:
  %0 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 4)
  ret i32 %0
}
