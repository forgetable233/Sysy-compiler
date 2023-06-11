; ModuleID = 'default'
source_filename = "default"

@a = constant [2 x i32] zeroinitializer

define i32 @func(i32* %array) {
begin:
  %0 = alloca i32*
  store i32* %array, i32** %0
  store volatile i32 1, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @a, i32 0, i32 0)
  %1 = load i32*, i32** %0
  %2 = load i32, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @a, i32 0, i32 0)
  %sub = fsub i32 3, %2
  %3 = getelementptr i32, i32* %1, i32 %sub
  %4 = load i32, i32* %3
  ret i32 %4
}

define i32 @main() {
begin:
  %a = alloca i32
  %array = alloca [3 x i32]
  %0 = getelementptr [3 x i32], [3 x i32]* %array, i32 0, i32 0
  store volatile i32 -1, i32* %0
  %1 = getelementptr [3 x i32], [3 x i32]* %array, i32 0, i32 1
  store volatile i32 4, i32* %1
  %2 = getelementptr [3 x i32], [3 x i32]* %array, i32 0, i32 2
  store volatile i32 8, i32* %2
  %3 = getelementptr [3 x i32], [3 x i32]* %array, i32 0, i32 0
  %call = call i32 @func(i32* %3)
  store volatile i32 %call, i32* %a
  %4 = load i32, i32* %a
  %5 = getelementptr [3 x i32], [3 x i32]* %array, i32 0, i32 1
  %6 = load i32, i32* %5
  %add = fadd i32 %4, %6
  ret i32 %add
}
