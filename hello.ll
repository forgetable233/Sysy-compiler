; ModuleID = 'hello.c'
source_filename = "hello.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = common dso_local global [10 x [10 x i32]] zeroinitializer, align 16
@q = common dso_local global [10 x i32] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @test2(i32* %0) #0 {
  %2 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  %3 = load i32*, i32** %2, align 8
  %4 = getelementptr inbounds i32, i32* %3, i64 0
  store i32 1, i32* %4, align 4
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @test3([10 x i32]* %0) #0 {
  %2 = alloca [10 x i32]*, align 8
  store [10 x i32]* %0, [10 x i32]** %2, align 8
  %3 = load [10 x i32]*, [10 x i32]** %2, align 8
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %3, i64 0
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %4, i64 0, i64 0
  store i32 1, i32* %5, align 4
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @test([10 x i32]* %0, i32* %1) #0 {
  %3 = alloca [10 x i32]*, align 8
  %4 = alloca i32*, align 8
  %5 = alloca [10 x [10 x i32]], align 16
  %6 = alloca [10 x i32], align 16
  %7 = alloca i32, align 4
  %8 = alloca [10 x i32], align 16
  store [10 x i32]* %0, [10 x i32]** %3, align 8
  store i32* %1, i32** %4, align 8
  %9 = call i32 @test2(i32* getelementptr inbounds ([10 x [10 x i32]], [10 x [10 x i32]]* @a, i64 0, i64 0, i64 1))
  store i32 %9, i32* %7, align 4
  %10 = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* %5, i64 0, i64 0
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %10, i64 0, i64 0
  %12 = getelementptr inbounds i32, i32* %11, i64 1
  %13 = call i32 @test2(i32* %12)
  store i32 %13, i32* %7, align 4
  %14 = load [10 x i32]*, [10 x i32]** %3, align 8
  %15 = getelementptr inbounds [10 x i32], [10 x i32]* %14, i64 0
  %16 = getelementptr inbounds [10 x i32], [10 x i32]* %15, i64 0, i64 0
  %17 = getelementptr inbounds i32, i32* %16, i64 1
  %18 = getelementptr inbounds i32, i32* %17, i64 -1
  %19 = call i32 @test2(i32* %18)
  store i32 %19, i32* %7, align 4
  %20 = getelementptr inbounds [10 x i32], [10 x i32]* %6, i64 0, i64 0
  %21 = getelementptr inbounds i32, i32* %20, i64 1
  %22 = call i32 @test2(i32* %21)
  store i32 %22, i32* %7, align 4
  %23 = call i32 @test2(i32* getelementptr inbounds ([10 x i32], [10 x i32]* @q, i64 0, i64 1))
  store i32 %23, i32* %7, align 4
  %24 = load i32*, i32** %4, align 8
  %25 = getelementptr inbounds i32, i32* %24, i64 1
  %26 = call i32 @test2(i32* %25)
  store i32 %26, i32* %7, align 4
  %27 = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* %5, i64 0, i64 0
  %28 = call i32 @test3([10 x i32]* %27)
  store i32 %28, i32* %7, align 4
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
