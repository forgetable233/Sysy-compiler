; ModuleID = 'default'
source_filename = "default"

@a = constant [10 x i32] zeroinitializer

define i32 @main() {
begin:
  store volatile i32 1, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @a, i32 0, i32 0)
  ret i32 0
}
