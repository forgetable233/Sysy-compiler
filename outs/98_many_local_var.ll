; ModuleID = 'default'
source_filename = "default"

@n = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @main() {
begin:
  %a0 = alloca i32
  %a1 = alloca i32
  %a2 = alloca i32
  %a3 = alloca i32
  %a4 = alloca i32
  %a5 = alloca i32
  %a6 = alloca i32
  %a7 = alloca i32
  %a8 = alloca i32
  %a9 = alloca i32
  %a10 = alloca i32
  %a11 = alloca i32
  %a12 = alloca i32
  %a13 = alloca i32
  %a14 = alloca i32
  %a15 = alloca i32
  %a16 = alloca i32
  %a17 = alloca i32
  %a18 = alloca i32
  %a19 = alloca i32
  %a20 = alloca i32
  %a21 = alloca i32
  %a22 = alloca i32
  %a23 = alloca i32
  %a24 = alloca i32
  %a25 = alloca i32
  %a26 = alloca i32
  %a27 = alloca i32
  %a28 = alloca i32
  %a29 = alloca i32
  %b = alloca i32
  %call = call i32 @getint()
  store volatile i32 %call, i32* %b
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %b
  %equal = icmp eq i32 %0, 5
  br i1 %equal, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  store volatile i32 0, i32* %a0
  %1 = load i32, i32* %a0
  %add1 = fadd i32 %1, 1
  store volatile i32 %add1, i32* %a1
  %2 = load i32, i32* %a1
  %add2 = fadd i32 %2, 1
  store volatile i32 %add2, i32* %a2
  %3 = load i32, i32* %a2
  %add3 = fadd i32 %3, 1
  store volatile i32 %add3, i32* %a3
  %4 = load i32, i32* %a3
  %add4 = fadd i32 %4, 1
  store volatile i32 %add4, i32* %a4
  %5 = load i32, i32* %a4
  %add5 = fadd i32 %5, 1
  store volatile i32 %add5, i32* %a5
  %6 = load i32, i32* %a5
  %add6 = fadd i32 %6, 1
  store volatile i32 %add6, i32* %a6
  %7 = load i32, i32* %a6
  %add7 = fadd i32 %7, 1
  store volatile i32 %add7, i32* %a7
  %8 = load i32, i32* %a7
  %add8 = fadd i32 %8, 1
  store volatile i32 %add8, i32* %a8
  %9 = load i32, i32* %a8
  %add9 = fadd i32 %9, 1
  store volatile i32 %add9, i32* %a9
  %10 = load i32, i32* %a9
  %add10 = fadd i32 %10, 1
  store volatile i32 %add10, i32* %a10
  %11 = load i32, i32* %a10
  %add11 = fadd i32 %11, 1
  store volatile i32 %add11, i32* %a11
  %12 = load i32, i32* %a11
  %add12 = fadd i32 %12, 1
  store volatile i32 %add12, i32* %a12
  %13 = load i32, i32* %a12
  %add13 = fadd i32 %13, 1
  store volatile i32 %add13, i32* %a13
  %14 = load i32, i32* %a13
  %add14 = fadd i32 %14, 1
  store volatile i32 %add14, i32* %a14
  %15 = load i32, i32* %a14
  %add15 = fadd i32 %15, 1
  store volatile i32 %add15, i32* %a15
  %16 = load i32, i32* %a15
  %add16 = fadd i32 %16, 1
  store volatile i32 %add16, i32* %a16
  %17 = load i32, i32* %a16
  %add17 = fadd i32 %17, 1
  store volatile i32 %add17, i32* %a17
  %18 = load i32, i32* %a17
  %add18 = fadd i32 %18, 1
  store volatile i32 %add18, i32* %a18
  %19 = load i32, i32* %a18
  %add19 = fadd i32 %19, 1
  store volatile i32 %add19, i32* %a19
  %20 = load i32, i32* %a19
  %add20 = fadd i32 %20, 1
  store volatile i32 %add20, i32* %a20
  %21 = load i32, i32* %a20
  %add21 = fadd i32 %21, 1
  store volatile i32 %add21, i32* %a21
  %22 = load i32, i32* %a21
  %add22 = fadd i32 %22, 1
  store volatile i32 %add22, i32* %a22
  %23 = load i32, i32* %a22
  %add23 = fadd i32 %23, 1
  store volatile i32 %add23, i32* %a23
  %24 = load i32, i32* %a23
  %add24 = fadd i32 %24, 1
  store volatile i32 %add24, i32* %a24
  %25 = load i32, i32* %a24
  %add25 = fadd i32 %25, 1
  store volatile i32 %add25, i32* %a25
  %26 = load i32, i32* %a25
  %add26 = fadd i32 %26, 1
  store volatile i32 %add26, i32* %a26
  %27 = load i32, i32* %a26
  %add27 = fadd i32 %27, 1
  store volatile i32 %add27, i32* %a27
  %28 = load i32, i32* %a27
  %add28 = fadd i32 %28, 1
  store volatile i32 %add28, i32* %a28
  %29 = load i32, i32* %a28
  %add29 = fadd i32 %29, 1
  store volatile i32 %add29, i32* %a29
  %t = alloca i32
  %30 = load i32, i32* %a0
  %call30 = call void @putint(i32 %30)
  %31 = load i32, i32* %a1
  %call31 = call void @putint(i32 %31)
  %32 = load i32, i32* %a2
  %call32 = call void @putint(i32 %32)
  %33 = load i32, i32* %a3
  %call33 = call void @putint(i32 %33)
  %34 = load i32, i32* %a4
  %call34 = call void @putint(i32 %34)
  %35 = load i32, i32* %a5
  %call35 = call void @putint(i32 %35)
  %36 = load i32, i32* %a6
  %call36 = call void @putint(i32 %36)
  %37 = load i32, i32* %a7
  %call37 = call void @putint(i32 %37)
  %38 = load i32, i32* %a8
  %call38 = call void @putint(i32 %38)
  %39 = load i32, i32* %a9
  %call39 = call void @putint(i32 %39)
  %40 = load i32, i32* %a10
  %call40 = call void @putint(i32 %40)
  %41 = load i32, i32* %a11
  %call41 = call void @putint(i32 %41)
  %42 = load i32, i32* %a12
  %call42 = call void @putint(i32 %42)
  %43 = load i32, i32* %a13
  %call43 = call void @putint(i32 %43)
  %44 = load i32, i32* %a14
  %call44 = call void @putint(i32 %44)
  %45 = load i32, i32* %a15
  %call45 = call void @putint(i32 %45)
  %46 = load i32, i32* %a16
  %call46 = call void @putint(i32 %46)
  %47 = load i32, i32* %a17
  %call47 = call void @putint(i32 %47)
  %48 = load i32, i32* %a18
  %call48 = call void @putint(i32 %48)
  %49 = load i32, i32* %a19
  %call49 = call void @putint(i32 %49)
  %50 = load i32, i32* %a20
  %call50 = call void @putint(i32 %50)
  %51 = load i32, i32* %a21
  %call51 = call void @putint(i32 %51)
  %52 = load i32, i32* %a22
  %call52 = call void @putint(i32 %52)
  %53 = load i32, i32* %a23
  %call53 = call void @putint(i32 %53)
  %54 = load i32, i32* %a24
  %call54 = call void @putint(i32 %54)
  %55 = load i32, i32* %a25
  %call55 = call void @putint(i32 %55)
  %56 = load i32, i32* %a26
  %call56 = call void @putint(i32 %56)
  %57 = load i32, i32* %a27
  %call57 = call void @putint(i32 %57)
  %58 = load i32, i32* %a28
  %call58 = call void @putint(i32 %58)
  %59 = load i32, i32* %a29
  %call59 = call void @putint(i32 %59)
  %newline = alloca i32
  store volatile i32 10, i32* %newline
  %60 = load i32, i32* %newline
  %call60 = call void @putch(i32 %60)
  %61 = load i32, i32* %b
  %call61 = call void @putint(i32 %61)
  %62 = load i32, i32* %newline
  %call62 = call void @putch(i32 %62)
  %63 = load i32, i32* %a25
  ret i32 %63

loop_body:                                        ; preds = %loop_header
  %64 = load i32, i32* %b
  %add = fadd i32 %64, 1
  store volatile i32 %add, i32* %b
  br label %loop_header
}
