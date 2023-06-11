; ModuleID = 'default'
source_filename = "default"

define i32 @func(i32 %a, i32 %b) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  store i32 %a, i32* %0
  store i32 %b, i32* %1
  %i = alloca i32
  %2 = load i32, i32* %0
  %3 = load i32, i32* %1
  %add = fadd i32 %2, %3
  store volatile i32 %add, i32* %i
  %c1 = alloca i32
  %c2 = alloca i32
  %c3 = alloca i32
  %c4 = alloca i32
  %d1 = alloca i32
  %d2 = alloca i32
  %d3 = alloca i32
  %d4 = alloca i32
  %e1 = alloca i32
  %e2 = alloca i32
  %e3 = alloca i32
  %e4 = alloca i32
  %f1 = alloca i32
  %f2 = alloca i32
  %f3 = alloca i32
  %f4 = alloca i32
  %g1 = alloca i32
  %g2 = alloca i32
  %g3 = alloca i32
  %g4 = alloca i32
  %h1 = alloca i32
  %h2 = alloca i32
  %h3 = alloca i32
  %h4 = alloca i32
  %i1 = alloca i32
  %i2 = alloca i32
  %i3 = alloca i32
  %i4 = alloca i32
  %j1 = alloca i32
  %j2 = alloca i32
  %j3 = alloca i32
  %j4 = alloca i32
  %k1 = alloca i32
  %k2 = alloca i32
  %k3 = alloca i32
  %k4 = alloca i32
  store volatile i32 1, i32* %c1
  store volatile i32 2, i32* %c2
  store volatile i32 3, i32* %c3
  store volatile i32 4, i32* %c4
  %4 = load i32, i32* %c1
  %add1 = fadd i32 1, %4
  store volatile i32 %add1, i32* %d1
  %5 = load i32, i32* %c2
  %add2 = fadd i32 2, %5
  store volatile i32 %add2, i32* %d2
  %6 = load i32, i32* %c3
  %add3 = fadd i32 3, %6
  store volatile i32 %add3, i32* %d3
  %7 = load i32, i32* %c4
  %add4 = fadd i32 4, %7
  store volatile i32 %add4, i32* %d4
  %8 = load i32, i32* %d1
  %add5 = fadd i32 1, %8
  store volatile i32 %add5, i32* %e1
  %9 = load i32, i32* %d2
  %add6 = fadd i32 2, %9
  store volatile i32 %add6, i32* %e2
  %10 = load i32, i32* %d3
  %add7 = fadd i32 3, %10
  store volatile i32 %add7, i32* %e3
  %11 = load i32, i32* %d4
  %add8 = fadd i32 4, %11
  store volatile i32 %add8, i32* %e4
  %12 = load i32, i32* %e1
  %add9 = fadd i32 1, %12
  store volatile i32 %add9, i32* %f1
  %13 = load i32, i32* %e2
  %add10 = fadd i32 2, %13
  store volatile i32 %add10, i32* %f2
  %14 = load i32, i32* %e3
  %add11 = fadd i32 3, %14
  store volatile i32 %add11, i32* %f3
  %15 = load i32, i32* %e4
  %add12 = fadd i32 4, %15
  store volatile i32 %add12, i32* %f4
  %16 = load i32, i32* %f1
  %add13 = fadd i32 1, %16
  store volatile i32 %add13, i32* %g1
  %17 = load i32, i32* %f2
  %add14 = fadd i32 2, %17
  store volatile i32 %add14, i32* %g2
  %18 = load i32, i32* %f3
  %add15 = fadd i32 3, %18
  store volatile i32 %add15, i32* %g3
  %19 = load i32, i32* %f4
  %add16 = fadd i32 4, %19
  store volatile i32 %add16, i32* %g4
  %20 = load i32, i32* %g1
  %add17 = fadd i32 1, %20
  store volatile i32 %add17, i32* %h1
  %21 = load i32, i32* %g2
  %add18 = fadd i32 2, %21
  store volatile i32 %add18, i32* %h2
  %22 = load i32, i32* %g3
  %add19 = fadd i32 3, %22
  store volatile i32 %add19, i32* %h3
  %23 = load i32, i32* %g4
  %add20 = fadd i32 4, %23
  store volatile i32 %add20, i32* %h4
  %24 = load i32, i32* %h1
  %add21 = fadd i32 1, %24
  store volatile i32 %add21, i32* %i1
  %25 = load i32, i32* %h2
  %add22 = fadd i32 2, %25
  store volatile i32 %add22, i32* %i2
  %26 = load i32, i32* %h3
  %add23 = fadd i32 3, %26
  store volatile i32 %add23, i32* %i3
  %27 = load i32, i32* %h4
  %add24 = fadd i32 4, %27
  store volatile i32 %add24, i32* %i4
  %28 = load i32, i32* %i1
  %add25 = fadd i32 1, %28
  store volatile i32 %add25, i32* %j1
  %29 = load i32, i32* %i2
  %add26 = fadd i32 2, %29
  store volatile i32 %add26, i32* %j2
  %30 = load i32, i32* %i3
  %add27 = fadd i32 3, %30
  store volatile i32 %add27, i32* %j3
  %31 = load i32, i32* %i4
  %add28 = fadd i32 4, %31
  store volatile i32 %add28, i32* %j4
  %32 = load i32, i32* %j1
  %add29 = fadd i32 1, %32
  store volatile i32 %add29, i32* %k1
  %33 = load i32, i32* %j2
  %add30 = fadd i32 2, %33
  store volatile i32 %add30, i32* %k2
  %34 = load i32, i32* %j3
  %add31 = fadd i32 3, %34
  store volatile i32 %add31, i32* %k3
  %35 = load i32, i32* %j4
  %add32 = fadd i32 4, %35
  store volatile i32 %add32, i32* %k4
  %36 = load i32, i32* %0
  %37 = load i32, i32* %1
  %sub = fsub i32 %36, %37
  %add33 = fadd i32 %sub, 10
  store volatile i32 %add33, i32* %i
  %38 = load i32, i32* %j1
  %add34 = fadd i32 1, %38
  store volatile i32 %add34, i32* %k1
  %39 = load i32, i32* %j2
  %add35 = fadd i32 2, %39
  store volatile i32 %add35, i32* %k2
  %40 = load i32, i32* %j3
  %add36 = fadd i32 3, %40
  store volatile i32 %add36, i32* %k3
  %41 = load i32, i32* %j4
  %add37 = fadd i32 4, %41
  store volatile i32 %add37, i32* %k4
  %42 = load i32, i32* %i1
  %add38 = fadd i32 1, %42
  store volatile i32 %add38, i32* %j1
  %43 = load i32, i32* %i2
  %add39 = fadd i32 2, %43
  store volatile i32 %add39, i32* %j2
  %44 = load i32, i32* %i3
  %add40 = fadd i32 3, %44
  store volatile i32 %add40, i32* %j3
  %45 = load i32, i32* %i4
  %add41 = fadd i32 4, %45
  store volatile i32 %add41, i32* %j4
  %46 = load i32, i32* %h1
  %add42 = fadd i32 1, %46
  store volatile i32 %add42, i32* %i1
  %47 = load i32, i32* %h2
  %add43 = fadd i32 2, %47
  store volatile i32 %add43, i32* %i2
  %48 = load i32, i32* %h3
  %add44 = fadd i32 3, %48
  store volatile i32 %add44, i32* %i3
  %49 = load i32, i32* %h4
  %add45 = fadd i32 4, %49
  store volatile i32 %add45, i32* %i4
  %50 = load i32, i32* %g1
  %add46 = fadd i32 1, %50
  store volatile i32 %add46, i32* %h1
  %51 = load i32, i32* %g2
  %add47 = fadd i32 2, %51
  store volatile i32 %add47, i32* %h2
  %52 = load i32, i32* %g3
  %add48 = fadd i32 3, %52
  store volatile i32 %add48, i32* %h3
  %53 = load i32, i32* %g4
  %add49 = fadd i32 4, %53
  store volatile i32 %add49, i32* %h4
  %54 = load i32, i32* %f1
  %add50 = fadd i32 1, %54
  store volatile i32 %add50, i32* %g1
  %55 = load i32, i32* %f2
  %add51 = fadd i32 2, %55
  store volatile i32 %add51, i32* %g2
  %56 = load i32, i32* %f3
  %add52 = fadd i32 3, %56
  store volatile i32 %add52, i32* %g3
  %57 = load i32, i32* %f4
  %add53 = fadd i32 4, %57
  store volatile i32 %add53, i32* %g4
  %58 = load i32, i32* %e1
  %add54 = fadd i32 1, %58
  store volatile i32 %add54, i32* %f1
  %59 = load i32, i32* %e2
  %add55 = fadd i32 2, %59
  store volatile i32 %add55, i32* %f2
  %60 = load i32, i32* %e3
  %add56 = fadd i32 3, %60
  store volatile i32 %add56, i32* %f3
  %61 = load i32, i32* %e4
  %add57 = fadd i32 4, %61
  store volatile i32 %add57, i32* %f4
  %62 = load i32, i32* %d1
  %add58 = fadd i32 1, %62
  store volatile i32 %add58, i32* %e1
  %63 = load i32, i32* %d2
  %add59 = fadd i32 2, %63
  store volatile i32 %add59, i32* %e2
  %64 = load i32, i32* %d3
  %add60 = fadd i32 3, %64
  store volatile i32 %add60, i32* %e3
  %65 = load i32, i32* %d4
  %add61 = fadd i32 4, %65
  store volatile i32 %add61, i32* %e4
  %66 = load i32, i32* %c1
  %add62 = fadd i32 1, %66
  store volatile i32 %add62, i32* %d1
  %67 = load i32, i32* %c2
  %add63 = fadd i32 2, %67
  store volatile i32 %add63, i32* %d2
  %68 = load i32, i32* %c3
  %add64 = fadd i32 3, %68
  store volatile i32 %add64, i32* %d3
  %69 = load i32, i32* %c4
  %add65 = fadd i32 4, %69
  store volatile i32 %add65, i32* %d4
  %70 = load i32, i32* %k1
  %add66 = fadd i32 1, %70
  store volatile i32 %add66, i32* %c1
  %71 = load i32, i32* %k2
  %add67 = fadd i32 2, %71
  store volatile i32 %add67, i32* %c2
  %72 = load i32, i32* %k3
  %add68 = fadd i32 3, %72
  store volatile i32 %add68, i32* %c3
  %73 = load i32, i32* %k4
  %add69 = fadd i32 4, %73
  store volatile i32 %add69, i32* %c4
  %74 = load i32, i32* %i
  %75 = load i32, i32* %c1
  %add70 = fadd i32 %74, %75
  %76 = load i32, i32* %c2
  %add71 = fadd i32 %add70, %76
  %77 = load i32, i32* %c3
  %add72 = fadd i32 %add71, %77
  %78 = load i32, i32* %c4
  %add73 = fadd i32 %add72, %78
  %79 = load i32, i32* %d1
  %sub74 = fsub i32 %add73, %79
  %80 = load i32, i32* %d2
  %sub75 = fsub i32 %sub74, %80
  %81 = load i32, i32* %d3
  %sub76 = fsub i32 %sub75, %81
  %82 = load i32, i32* %d4
  %sub77 = fsub i32 %sub76, %82
  %83 = load i32, i32* %e1
  %add78 = fadd i32 %sub77, %83
  %84 = load i32, i32* %e2
  %add79 = fadd i32 %add78, %84
  %85 = load i32, i32* %e3
  %add80 = fadd i32 %add79, %85
  %86 = load i32, i32* %e4
  %add81 = fadd i32 %add80, %86
  %87 = load i32, i32* %f1
  %sub82 = fsub i32 %add81, %87
  %88 = load i32, i32* %f2
  %sub83 = fsub i32 %sub82, %88
  %89 = load i32, i32* %f3
  %sub84 = fsub i32 %sub83, %89
  %90 = load i32, i32* %f4
  %sub85 = fsub i32 %sub84, %90
  %91 = load i32, i32* %g1
  %add86 = fadd i32 %sub85, %91
  %92 = load i32, i32* %g2
  %add87 = fadd i32 %add86, %92
  %93 = load i32, i32* %g3
  %add88 = fadd i32 %add87, %93
  %94 = load i32, i32* %g4
  %add89 = fadd i32 %add88, %94
  %95 = load i32, i32* %h1
  %sub90 = fsub i32 %add89, %95
  %96 = load i32, i32* %h2
  %sub91 = fsub i32 %sub90, %96
  %97 = load i32, i32* %h3
  %sub92 = fsub i32 %sub91, %97
  %98 = load i32, i32* %h4
  %sub93 = fsub i32 %sub92, %98
  %99 = load i32, i32* %i1
  %add94 = fadd i32 %sub93, %99
  %100 = load i32, i32* %i2
  %add95 = fadd i32 %add94, %100
  %101 = load i32, i32* %i3
  %add96 = fadd i32 %add95, %101
  %102 = load i32, i32* %i4
  %add97 = fadd i32 %add96, %102
  %103 = load i32, i32* %j1
  %sub98 = fsub i32 %add97, %103
  %104 = load i32, i32* %j2
  %sub99 = fsub i32 %sub98, %104
  %105 = load i32, i32* %j3
  %sub100 = fsub i32 %sub99, %105
  %106 = load i32, i32* %j4
  %sub101 = fsub i32 %sub100, %106
  %107 = load i32, i32* %k1
  %add102 = fadd i32 %sub101, %107
  %108 = load i32, i32* %k2
  %add103 = fadd i32 %add102, %108
  %109 = load i32, i32* %k3
  %add104 = fadd i32 %add103, %109
  %110 = load i32, i32* %k4
  %add105 = fadd i32 %add104, %110
  ret i32 %add105
}

define i32 @main() {
begin:
  %a = alloca i32
  %b = alloca i32
  store volatile i32 1, i32* %a
  %0 = load i32, i32* %a
  %add = fadd i32 %0, 18
  store volatile i32 %add, i32* %b
  %1 = load i32, i32* %a
  %2 = load i32, i32* %b
  %call = call i32 @func(i32 %1, i32 %2)
  ret i32 %call
}
