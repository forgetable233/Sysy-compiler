; ModuleID = 'hello.c'
source_filename = "hello.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = common dso_local global [10 x [10 x i32]] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @test2([10 x i32]* %0) #0 {
  %2 = alloca [10 x i32]*, align 8
  store [10 x i32]* %0, [10 x i32]** %2, align 8
  %3 = load [10 x i32]*, [10 x i32]** %2, align 8
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %3, i64 0
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %4, i64 0, i64 10
  store i32 1, i32* %5, align 4
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @test([10 x i32]* %0) #0 {
  %2 = alloca [10 x i32]*, align 8
  %3 = alloca [10 x [10 x i32]], align 16
  %4 = alloca i32, align 4
  store [10 x i32]* %0, [10 x i32]** %2, align 8
  %5 = call i32 @test2([10 x i32]* getelementptr inbounds ([10 x [10 x i32]], [10 x [10 x i32]]* @a, i64 0, i64 0))
  store i32 %5, i32* %4, align 4
  %6 = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* %3, i64 0, i64 0
  %7 = call i32 @test2([10 x i32]* %6)
  store i32 %7, i32* %4, align 4
  %8 = load [10 x i32]*, [10 x i32]** %2, align 8
  %9 = call i32 @test2([10 x i32]* %8)
  store i32 %9, i32* %4, align 4
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
