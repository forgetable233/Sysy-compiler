; ModuleID = 'hello.c'
source_filename = "hello.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ifElseElseIf() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 66, i32* %1, align 4
  store i32 8923, i32* %2, align 4
  %3 = load i32, i32* %1, align 4
  %4 = icmp eq i32 %3, 5
  br i1 %4, label %5, label %6

5:                                                ; preds = %0
  store i32 25, i32* %2, align 4
  br label %14

6:                                                ; preds = %0
  %7 = load i32, i32* %1, align 4
  %8 = icmp eq i32 %7, 10
  br i1 %8, label %9, label %10

9:                                                ; preds = %6
  store i32 42, i32* %2, align 4
  br label %13

10:                                               ; preds = %6
  %11 = load i32, i32* %1, align 4
  %12 = mul nsw i32 %11, 2
  store i32 %12, i32* %2, align 4
  br label %13

13:                                               ; preds = %10, %9
  br label %14

14:                                               ; preds = %13, %5
  %15 = load i32, i32* %2, align 4
  ret i32 %15
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ifElseElseIf()
  ret i32 %2
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
