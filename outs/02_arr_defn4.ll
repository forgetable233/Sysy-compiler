; ModuleID = 'default'
source_filename = "default"

define i32 @main() {
begin:
  %a = alloca [2 x [4 x i32]]
  %0 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %a, i32 0, i32 0
  %1 = getelementptr [4 x i32], [4 x i32]* %0, i32 0, i32 0
  store i32 1, i32* %1
  %2 = getelementptr [4 x i32], [4 x i32]* %0, i32 0, i32 1
  store i32 2, i32* %2
  %3 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %a, i32 0, i32 1
  %4 = getelementptr [4 x i32], [4 x i32]* %3, i32 0, i32 0
  store i32 3, i32* %4
  %5 = getelementptr [4 x i32], [4 x i32]* %3, i32 0, i32 1
  store i32 4, i32* %5
  %6 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %a, i32 0, i32 2
  %7 = getelementptr [4 x i32], [4 x i32]* %6, i32 0, i32 0
  store i32 5, i32* %7
  %8 = getelementptr [4 x i32], [4 x i32]* %6, i32 0, i32 1
  store i32 6, i32* %8
  %9 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %a, i32 0, i32 3
  %10 = getelementptr [4 x i32], [4 x i32]* %9, i32 0, i32 0
  store i32 7, i32* %10
  %11 = getelementptr [4 x i32], [4 x i32]* %9, i32 0, i32 1
  store i32 8, i32* %11
  %b = alloca [2 x [4 x i32]]
  %12 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %b, i32 0, i32 0
  %13 = getelementptr [4 x i32], [4 x i32]* %12, i32 0, i32 0
  %14 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %a, i32 0, i32 0
  %15 = getelementptr [4 x i32], [4 x i32]* %14, i32 0, i32 0
  %16 = load i32, i32* %15
  store i32 %16, i32* %13
  %17 = getelementptr [4 x i32], [4 x i32]* %12, i32 0, i32 1
  %18 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %a, i32 0, i32 0
  %19 = getelementptr [4 x i32], [4 x i32]* %18, i32 0, i32 1
  %20 = load i32, i32* %19
  store i32 %20, i32* %17
  %21 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %b, i32 0, i32 1
  %22 = getelementptr [4 x i32], [4 x i32]* %21, i32 0, i32 0
  store i32 3, i32* %22
  %23 = getelementptr [4 x i32], [4 x i32]* %21, i32 0, i32 1
  store i32 4, i32* %23
  %24 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %b, i32 0, i32 2
  %25 = getelementptr [4 x i32], [4 x i32]* %24, i32 0, i32 0
  store i32 5, i32* %25
  %26 = getelementptr [4 x i32], [4 x i32]* %24, i32 0, i32 1
  store i32 6, i32* %26
  %27 = getelementptr [2 x [4 x i32]], [2 x [4 x i32]]* %b, i32 0, i32 3
  %28 = getelementptr [4 x i32], [4 x i32]* %27, i32 0, i32 0
  store i32 7, i32* %28
  %29 = getelementptr [4 x i32], [4 x i32]* %27, i32 0, i32 1
  store i32 8, i32* %29
  ret i32 0
}
