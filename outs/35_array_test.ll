; ModuleID = 'default'
source_filename = "default"

@field = constant [2 x i32] zeroinitializer

define i32 @func(i32* %array) {
begin:
  %0 = alloca i32*
  store i32* %array, i32** %0
  %1 = load i32*, i32** %0
  %2 = load i32, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @field, i32 0, i32 0)
  %sub = fsub i32 3, %2
  %3 = getelementptr i32, i32* %1, i32 %sub
  %4 = load i32, i32* %3
  ret i32 %4
}

define i32 @main() {
begin:
  %i = alloca [1 x i32]
  %j = alloca [3 x i32]
  %k = alloca i32
  store volatile i32 1, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @field, i32 0, i32 0)
  store volatile i32 2, i32* getelementptr inbounds ([2 x i32], [2 x i32]* @field, i32 0, i32 1)
  %0 = getelementptr [3 x i32], [3 x i32]* %j, i32 0, i32 fadd (i32 0, i32 0)
  store volatile i32 -1, i32* %0
  %1 = getelementptr [3 x i32], [3 x i32]* %j, i32 0, i32 0
  %2 = load i32, i32* %1
  %sub = fsub i32 %2, 2
  %3 = getelementptr [3 x i32], [3 x i32]* %j, i32 0, i32 1
  store volatile i32 %sub, i32* %3
  %4 = getelementptr [3 x i32], [3 x i32]* %j, i32 0, i32 1
  %5 = load i32, i32* %4
  store volatile i32 %5, i32* %k
  %6 = getelementptr [3 x i32], [3 x i32]* %j, i32 0, i32 2
  store volatile i32 16, i32* %6
  %7 = getelementptr [3 x i32], [3 x i32]* %j, i32 0, i32 0
  %call = call i32 @func(i32* %7)
  %add = fadd i32 %call, 2
  %8 = load i32, i32* %k
  %add1 = fadd i32 %add, %8
  ret i32 %add1
}
