; ModuleID = 'default'
source_filename = "default"

@a0 = global i32 0
@a1 = global i32 0
@a2 = global i32 0
@a3 = global i32 0
@a4 = global i32 0
@a5 = global i32 0
@a6 = global i32 0
@a7 = global i32 0
@a8 = global i32 0
@a9 = global i32 0
@a10 = global i32 0
@a11 = global i32 0
@a12 = global i32 0
@a13 = global i32 0
@a14 = global i32 0
@a15 = global i32 0
@a16 = global i32 0
@a17 = global i32 0
@a18 = global i32 0
@a19 = global i32 0
@a20 = global i32 0
@a21 = global i32 0
@a22 = global i32 0
@a23 = global i32 0
@a24 = global i32 0
@a25 = global i32 0
@a26 = global i32 0
@a27 = global i32 0
@a28 = global i32 0
@a29 = global i32 0
@a30 = global i32 0
@a31 = global i32 0
@a32 = global i32 0
@a33 = global i32 0
@a34 = global i32 0
@a35 = global i32 0
@a36 = global i32 0
@a37 = global i32 0
@a38 = global i32 0
@a39 = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @testParam8(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  %6 = alloca i32
  %7 = alloca i32
  store i32 %a0, i32* %0
  store i32 %a1, i32* %1
  store i32 %a2, i32* %2
  store i32 %a3, i32* %3
  store i32 %a4, i32* %4
  store i32 %a5, i32* %5
  store i32 %a6, i32* %6
  store i32 %a7, i32* %7
  %8 = load i32, i32* %0
  %9 = load i32, i32* %1
  %add = fadd i32 %8, %9
  %10 = load i32, i32* %2
  %add1 = fadd i32 %add, %10
  %11 = load i32, i32* %3
  %add2 = fadd i32 %add1, %11
  %12 = load i32, i32* %4
  %add3 = fadd i32 %add2, %12
  %13 = load i32, i32* %5
  %add4 = fadd i32 %add3, %13
  %14 = load i32, i32* %6
  %add5 = fadd i32 %add4, %14
  %15 = load i32, i32* %7
  %add6 = fadd i32 %add5, %15
  ret i32 %add6
}

define i32 @testParam16(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8, i32 %a9, i32 %a10, i32 %a11, i32 %a12, i32 %a13, i32 %a14, i32 %a15) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  %6 = alloca i32
  %7 = alloca i32
  %8 = alloca i32
  %9 = alloca i32
  %10 = alloca i32
  %11 = alloca i32
  %12 = alloca i32
  %13 = alloca i32
  %14 = alloca i32
  %15 = alloca i32
  store i32 %a0, i32* %0
  store i32 %a1, i32* %1
  store i32 %a2, i32* %2
  store i32 %a3, i32* %3
  store i32 %a4, i32* %4
  store i32 %a5, i32* %5
  store i32 %a6, i32* %6
  store i32 %a7, i32* %7
  store i32 %a8, i32* %8
  store i32 %a9, i32* %9
  store i32 %a10, i32* %10
  store i32 %a11, i32* %11
  store i32 %a12, i32* %12
  store i32 %a13, i32* %13
  store i32 %a14, i32* %14
  store i32 %a15, i32* %15
  %16 = load i32, i32* %0
  %17 = load i32, i32* %1
  %add = fadd i32 %16, %17
  %18 = load i32, i32* %2
  %add1 = fadd i32 %add, %18
  %19 = load i32, i32* %3
  %sub = fsub i32 %add1, %19
  %20 = load i32, i32* %4
  %sub2 = fsub i32 %sub, %20
  %21 = load i32, i32* %5
  %sub3 = fsub i32 %sub2, %21
  %22 = load i32, i32* %6
  %sub4 = fsub i32 %sub3, %22
  %23 = load i32, i32* %7
  %sub5 = fsub i32 %sub4, %23
  %24 = load i32, i32* %8
  %add6 = fadd i32 %sub5, %24
  %25 = load i32, i32* %9
  %add7 = fadd i32 %add6, %25
  %26 = load i32, i32* %10
  %add8 = fadd i32 %add7, %26
  %27 = load i32, i32* %11
  %add9 = fadd i32 %add8, %27
  %28 = load i32, i32* %12
  %add10 = fadd i32 %add9, %28
  %29 = load i32, i32* %13
  %add11 = fadd i32 %add10, %29
  %30 = load i32, i32* %14
  %add12 = fadd i32 %add11, %30
  %31 = load i32, i32* %15
  %add13 = fadd i32 %add12, %31
  ret i32 %add13
}

define i32 @testParam32(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8, i32 %a9, i32 %a10, i32 %a11, i32 %a12, i32 %a13, i32 %a14, i32 %a15, i32 %a16, i32 %a17, i32 %a18, i32 %a19, i32 %a20, i32 %a21, i32 %a22, i32 %a23, i32 %a24, i32 %a25, i32 %a26, i32 %a27, i32 %a28, i32 %a29, i32 %a30, i32 %a31) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  %6 = alloca i32
  %7 = alloca i32
  %8 = alloca i32
  %9 = alloca i32
  %10 = alloca i32
  %11 = alloca i32
  %12 = alloca i32
  %13 = alloca i32
  %14 = alloca i32
  %15 = alloca i32
  %16 = alloca i32
  %17 = alloca i32
  %18 = alloca i32
  %19 = alloca i32
  %20 = alloca i32
  %21 = alloca i32
  %22 = alloca i32
  %23 = alloca i32
  %24 = alloca i32
  %25 = alloca i32
  %26 = alloca i32
  %27 = alloca i32
  %28 = alloca i32
  %29 = alloca i32
  %30 = alloca i32
  %31 = alloca i32
  store i32 %a0, i32* %0
  store i32 %a1, i32* %1
  store i32 %a2, i32* %2
  store i32 %a3, i32* %3
  store i32 %a4, i32* %4
  store i32 %a5, i32* %5
  store i32 %a6, i32* %6
  store i32 %a7, i32* %7
  store i32 %a8, i32* %8
  store i32 %a9, i32* %9
  store i32 %a10, i32* %10
  store i32 %a11, i32* %11
  store i32 %a12, i32* %12
  store i32 %a13, i32* %13
  store i32 %a14, i32* %14
  store i32 %a15, i32* %15
  store i32 %a16, i32* %16
  store i32 %a17, i32* %17
  store i32 %a18, i32* %18
  store i32 %a19, i32* %19
  store i32 %a20, i32* %20
  store i32 %a21, i32* %21
  store i32 %a22, i32* %22
  store i32 %a23, i32* %23
  store i32 %a24, i32* %24
  store i32 %a25, i32* %25
  store i32 %a26, i32* %26
  store i32 %a27, i32* %27
  store i32 %a28, i32* %28
  store i32 %a29, i32* %29
  store i32 %a30, i32* %30
  store i32 %a31, i32* %31
  %32 = load i32, i32* %0
  %33 = load i32, i32* %1
  %add = fadd i32 %32, %33
  %34 = load i32, i32* %2
  %add1 = fadd i32 %add, %34
  %35 = load i32, i32* %3
  %add2 = fadd i32 %add1, %35
  %36 = load i32, i32* %4
  %add3 = fadd i32 %add2, %36
  %37 = load i32, i32* %5
  %add4 = fadd i32 %add3, %37
  %38 = load i32, i32* %6
  %add5 = fadd i32 %add4, %38
  %39 = load i32, i32* %7
  %add6 = fadd i32 %add5, %39
  %40 = load i32, i32* %8
  %add7 = fadd i32 %add6, %40
  %41 = load i32, i32* %9
  %add8 = fadd i32 %add7, %41
  %42 = load i32, i32* %10
  %add9 = fadd i32 %add8, %42
  %43 = load i32, i32* %11
  %add10 = fadd i32 %add9, %43
  %44 = load i32, i32* %12
  %add11 = fadd i32 %add10, %44
  %45 = load i32, i32* %13
  %add12 = fadd i32 %add11, %45
  %46 = load i32, i32* %14
  %add13 = fadd i32 %add12, %46
  %47 = load i32, i32* %15
  %add14 = fadd i32 %add13, %47
  %48 = load i32, i32* %16
  %add15 = fadd i32 %add14, %48
  %49 = load i32, i32* %17
  %add16 = fadd i32 %add15, %49
  %50 = load i32, i32* %18
  %sub = fsub i32 %add16, %50
  %51 = load i32, i32* %19
  %sub17 = fsub i32 %sub, %51
  %52 = load i32, i32* %20
  %sub18 = fsub i32 %sub17, %52
  %53 = load i32, i32* %21
  %sub19 = fsub i32 %sub18, %53
  %54 = load i32, i32* %22
  %sub20 = fsub i32 %sub19, %54
  %55 = load i32, i32* %23
  %add21 = fadd i32 %sub20, %55
  %56 = load i32, i32* %24
  %add22 = fadd i32 %add21, %56
  %57 = load i32, i32* %25
  %add23 = fadd i32 %add22, %57
  %58 = load i32, i32* %26
  %add24 = fadd i32 %add23, %58
  %59 = load i32, i32* %27
  %add25 = fadd i32 %add24, %59
  %60 = load i32, i32* %28
  %add26 = fadd i32 %add25, %60
  %61 = load i32, i32* %29
  %add27 = fadd i32 %add26, %61
  %62 = load i32, i32* %30
  %add28 = fadd i32 %add27, %62
  %63 = load i32, i32* %31
  %add29 = fadd i32 %add28, %63
  ret i32 %add29
}

define i32 @main() {
begin:
  store volatile i32 0, i32* @a0
  store volatile i32 1, i32* @a1
  store volatile i32 2, i32* @a2
  store volatile i32 3, i32* @a3
  store volatile i32 4, i32* @a4
  store volatile i32 5, i32* @a5
  store volatile i32 6, i32* @a6
  store volatile i32 7, i32* @a7
  store volatile i32 8, i32* @a8
  store volatile i32 9, i32* @a9
  store volatile i32 0, i32* @a10
  store volatile i32 1, i32* @a11
  store volatile i32 2, i32* @a12
  store volatile i32 3, i32* @a13
  store volatile i32 4, i32* @a14
  store volatile i32 5, i32* @a15
  store volatile i32 6, i32* @a16
  store volatile i32 7, i32* @a17
  store volatile i32 8, i32* @a18
  store volatile i32 9, i32* @a19
  store volatile i32 0, i32* @a20
  store volatile i32 1, i32* @a21
  store volatile i32 2, i32* @a22
  store volatile i32 3, i32* @a23
  store volatile i32 4, i32* @a24
  store volatile i32 5, i32* @a25
  store volatile i32 6, i32* @a26
  store volatile i32 7, i32* @a27
  store volatile i32 8, i32* @a28
  store volatile i32 9, i32* @a29
  store volatile i32 0, i32* @a30
  store volatile i32 1, i32* @a31
  store volatile i32 4, i32* @a32
  store volatile i32 5, i32* @a33
  store volatile i32 6, i32* @a34
  store volatile i32 7, i32* @a35
  store volatile i32 8, i32* @a36
  store volatile i32 9, i32* @a37
  store volatile i32 0, i32* @a38
  store volatile i32 1, i32* @a39
  %0 = load i32, i32* @a0
  %1 = load i32, i32* @a1
  %2 = load i32, i32* @a2
  %3 = load i32, i32* @a3
  %4 = load i32, i32* @a4
  %5 = load i32, i32* @a5
  %6 = load i32, i32* @a6
  %7 = load i32, i32* @a7
  %call = call i32 @testParam8(i32 %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7)
  store volatile i32 %call, i32* @a0
  %8 = load i32, i32* @a0
  %call1 = call void @putint(i32 %8)
  %9 = load i32, i32* @a32
  %10 = load i32, i32* @a33
  %11 = load i32, i32* @a34
  %12 = load i32, i32* @a35
  %13 = load i32, i32* @a36
  %14 = load i32, i32* @a37
  %15 = load i32, i32* @a38
  %16 = load i32, i32* @a39
  %17 = load i32, i32* @a8
  %18 = load i32, i32* @a9
  %19 = load i32, i32* @a10
  %20 = load i32, i32* @a11
  %21 = load i32, i32* @a12
  %22 = load i32, i32* @a13
  %23 = load i32, i32* @a14
  %24 = load i32, i32* @a15
  %call2 = call i32 @testParam16(i32 %9, i32 %10, i32 %11, i32 %12, i32 %13, i32 %14, i32 %15, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23, i32 %24)
  store volatile i32 %call2, i32* @a0
  %25 = load i32, i32* @a0
  %call3 = call void @putint(i32 %25)
  %26 = load i32, i32* @a0
  %27 = load i32, i32* @a1
  %28 = load i32, i32* @a2
  %29 = load i32, i32* @a3
  %30 = load i32, i32* @a4
  %31 = load i32, i32* @a5
  %32 = load i32, i32* @a6
  %33 = load i32, i32* @a7
  %34 = load i32, i32* @a8
  %35 = load i32, i32* @a9
  %36 = load i32, i32* @a10
  %37 = load i32, i32* @a11
  %38 = load i32, i32* @a12
  %39 = load i32, i32* @a13
  %40 = load i32, i32* @a14
  %41 = load i32, i32* @a15
  %42 = load i32, i32* @a16
  %43 = load i32, i32* @a17
  %44 = load i32, i32* @a18
  %45 = load i32, i32* @a19
  %46 = load i32, i32* @a20
  %47 = load i32, i32* @a21
  %48 = load i32, i32* @a22
  %49 = load i32, i32* @a23
  %50 = load i32, i32* @a24
  %51 = load i32, i32* @a25
  %52 = load i32, i32* @a26
  %53 = load i32, i32* @a27
  %54 = load i32, i32* @a28
  %55 = load i32, i32* @a29
  %56 = load i32, i32* @a30
  %57 = load i32, i32* @a31
  %call4 = call i32 @testParam32(i32 %26, i32 %27, i32 %28, i32 %29, i32 %30, i32 %31, i32 %32, i32 %33, i32 %34, i32 %35, i32 %36, i32 %37, i32 %38, i32 %39, i32 %40, i32 %41, i32 %42, i32 %43, i32 %44, i32 %45, i32 %46, i32 %47, i32 %48, i32 %49, i32 %50, i32 %51, i32 %52, i32 %53, i32 %54, i32 %55, i32 %56, i32 %57)
  store volatile i32 %call4, i32* @a0
  %58 = load i32, i32* @a0
  %call5 = call void @putint(i32 %58)
  ret i32 0
}
