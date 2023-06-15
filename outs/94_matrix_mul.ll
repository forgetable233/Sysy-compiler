; ModuleID = 'default'
source_filename = "default"

@M = global i32 0
@L = global i32 0
@N = global i32 0

declare i32 @getint()

declare i32 @getch()

declare i32 @getarray(i32*)

declare void @putint(i32)

declare void @putch(i32)

declare void @putarray(i32, i32*)

declare void @starttime()

declare void @stoptime()

define i32 @mul(i32* %a0, i32* %a1, i32* %a2, i32* %b0, i32* %b1, i32* %b2, i32* %c0, i32* %c1, i32* %c2) {
begin:
  %0 = alloca i32*
  %1 = alloca i32*
  %2 = alloca i32*
  %3 = alloca i32*
  %4 = alloca i32*
  %5 = alloca i32*
  %6 = alloca i32*
  %7 = alloca i32*
  %8 = alloca i32*
  store i32* %a0, i32** %0
  store i32* %a1, i32** %1
  store i32* %a2, i32** %2
  store i32* %b0, i32** %3
  store i32* %b1, i32** %4
  store i32* %b2, i32** %5
  store i32* %c0, i32** %6
  store i32* %c1, i32** %7
  store i32* %c2, i32** %8
  %i = alloca i32
  store volatile i32 0, i32* %i
  %9 = load i32*, i32** %6
  %10 = load i32*, i32** %0
  %11 = getelementptr i32, i32* %10, i32 0
  %12 = load i32, i32* %11
  %13 = load i32*, i32** %3
  %14 = getelementptr i32, i32* %13, i32 0
  %15 = load i32, i32* %14
  %mul = mul i32 %12, %15
  %16 = load i32*, i32** %0
  %17 = getelementptr i32, i32* %16, i32 1
  %18 = load i32, i32* %17
  %19 = load i32*, i32** %4
  %20 = getelementptr i32, i32* %19, i32 0
  %21 = load i32, i32* %20
  %mul1 = mul i32 %18, %21
  %add = fadd i32 %mul, %mul1
  %22 = load i32*, i32** %0
  %23 = getelementptr i32, i32* %22, i32 2
  %24 = load i32, i32* %23
  %25 = load i32*, i32** %5
  %26 = getelementptr i32, i32* %25, i32 0
  %27 = load i32, i32* %26
  %mul2 = mul i32 %24, %27
  %add3 = fadd i32 %add, %mul2
  %28 = getelementptr i32, i32* %9, i32 0
  store volatile i32 %add3, i32* %28
  %29 = load i32*, i32** %6
  %30 = load i32*, i32** %0
  %31 = getelementptr i32, i32* %30, i32 0
  %32 = load i32, i32* %31
  %33 = load i32*, i32** %3
  %34 = getelementptr i32, i32* %33, i32 1
  %35 = load i32, i32* %34
  %mul4 = mul i32 %32, %35
  %36 = load i32*, i32** %0
  %37 = getelementptr i32, i32* %36, i32 1
  %38 = load i32, i32* %37
  %39 = load i32*, i32** %4
  %40 = getelementptr i32, i32* %39, i32 1
  %41 = load i32, i32* %40
  %mul5 = mul i32 %38, %41
  %add6 = fadd i32 %mul4, %mul5
  %42 = load i32*, i32** %0
  %43 = getelementptr i32, i32* %42, i32 2
  %44 = load i32, i32* %43
  %45 = load i32*, i32** %5
  %46 = getelementptr i32, i32* %45, i32 1
  %47 = load i32, i32* %46
  %mul7 = mul i32 %44, %47
  %add8 = fadd i32 %add6, %mul7
  %48 = getelementptr i32, i32* %29, i32 1
  store volatile i32 %add8, i32* %48
  %49 = load i32*, i32** %6
  %50 = load i32*, i32** %0
  %51 = getelementptr i32, i32* %50, i32 0
  %52 = load i32, i32* %51
  %53 = load i32*, i32** %3
  %54 = getelementptr i32, i32* %53, i32 2
  %55 = load i32, i32* %54
  %mul9 = mul i32 %52, %55
  %56 = load i32*, i32** %0
  %57 = getelementptr i32, i32* %56, i32 1
  %58 = load i32, i32* %57
  %59 = load i32*, i32** %4
  %60 = getelementptr i32, i32* %59, i32 2
  %61 = load i32, i32* %60
  %mul10 = mul i32 %58, %61
  %add11 = fadd i32 %mul9, %mul10
  %62 = load i32*, i32** %0
  %63 = getelementptr i32, i32* %62, i32 2
  %64 = load i32, i32* %63
  %65 = load i32*, i32** %5
  %66 = getelementptr i32, i32* %65, i32 2
  %67 = load i32, i32* %66
  %mul12 = mul i32 %64, %67
  %add13 = fadd i32 %add11, %mul12
  %68 = getelementptr i32, i32* %49, i32 2
  store volatile i32 %add13, i32* %68
  %69 = load i32*, i32** %7
  %70 = load i32*, i32** %1
  %71 = getelementptr i32, i32* %70, i32 0
  %72 = load i32, i32* %71
  %73 = load i32*, i32** %3
  %74 = getelementptr i32, i32* %73, i32 0
  %75 = load i32, i32* %74
  %mul14 = mul i32 %72, %75
  %76 = load i32*, i32** %1
  %77 = getelementptr i32, i32* %76, i32 1
  %78 = load i32, i32* %77
  %79 = load i32*, i32** %4
  %80 = getelementptr i32, i32* %79, i32 0
  %81 = load i32, i32* %80
  %mul15 = mul i32 %78, %81
  %add16 = fadd i32 %mul14, %mul15
  %82 = load i32*, i32** %1
  %83 = getelementptr i32, i32* %82, i32 2
  %84 = load i32, i32* %83
  %85 = load i32*, i32** %5
  %86 = getelementptr i32, i32* %85, i32 0
  %87 = load i32, i32* %86
  %mul17 = mul i32 %84, %87
  %add18 = fadd i32 %add16, %mul17
  %88 = getelementptr i32, i32* %69, i32 0
  store volatile i32 %add18, i32* %88
  %89 = load i32*, i32** %7
  %90 = load i32*, i32** %1
  %91 = getelementptr i32, i32* %90, i32 0
  %92 = load i32, i32* %91
  %93 = load i32*, i32** %3
  %94 = getelementptr i32, i32* %93, i32 1
  %95 = load i32, i32* %94
  %mul19 = mul i32 %92, %95
  %96 = load i32*, i32** %1
  %97 = getelementptr i32, i32* %96, i32 1
  %98 = load i32, i32* %97
  %99 = load i32*, i32** %4
  %100 = getelementptr i32, i32* %99, i32 1
  %101 = load i32, i32* %100
  %mul20 = mul i32 %98, %101
  %add21 = fadd i32 %mul19, %mul20
  %102 = load i32*, i32** %1
  %103 = getelementptr i32, i32* %102, i32 2
  %104 = load i32, i32* %103
  %105 = load i32*, i32** %5
  %106 = getelementptr i32, i32* %105, i32 1
  %107 = load i32, i32* %106
  %mul22 = mul i32 %104, %107
  %add23 = fadd i32 %add21, %mul22
  %108 = getelementptr i32, i32* %89, i32 1
  store volatile i32 %add23, i32* %108
  %109 = load i32*, i32** %7
  %110 = load i32*, i32** %1
  %111 = getelementptr i32, i32* %110, i32 0
  %112 = load i32, i32* %111
  %113 = load i32*, i32** %3
  %114 = getelementptr i32, i32* %113, i32 2
  %115 = load i32, i32* %114
  %mul24 = mul i32 %112, %115
  %116 = load i32*, i32** %1
  %117 = getelementptr i32, i32* %116, i32 1
  %118 = load i32, i32* %117
  %119 = load i32*, i32** %4
  %120 = getelementptr i32, i32* %119, i32 2
  %121 = load i32, i32* %120
  %mul25 = mul i32 %118, %121
  %add26 = fadd i32 %mul24, %mul25
  %122 = load i32*, i32** %1
  %123 = getelementptr i32, i32* %122, i32 2
  %124 = load i32, i32* %123
  %125 = load i32*, i32** %5
  %126 = getelementptr i32, i32* %125, i32 2
  %127 = load i32, i32* %126
  %mul27 = mul i32 %124, %127
  %add28 = fadd i32 %add26, %mul27
  %128 = getelementptr i32, i32* %109, i32 2
  store volatile i32 %add28, i32* %128
  %129 = load i32*, i32** %8
  %130 = load i32*, i32** %2
  %131 = getelementptr i32, i32* %130, i32 0
  %132 = load i32, i32* %131
  %133 = load i32*, i32** %3
  %134 = getelementptr i32, i32* %133, i32 0
  %135 = load i32, i32* %134
  %mul29 = mul i32 %132, %135
  %136 = load i32*, i32** %2
  %137 = getelementptr i32, i32* %136, i32 1
  %138 = load i32, i32* %137
  %139 = load i32*, i32** %4
  %140 = getelementptr i32, i32* %139, i32 0
  %141 = load i32, i32* %140
  %mul30 = mul i32 %138, %141
  %add31 = fadd i32 %mul29, %mul30
  %142 = load i32*, i32** %2
  %143 = getelementptr i32, i32* %142, i32 2
  %144 = load i32, i32* %143
  %145 = load i32*, i32** %5
  %146 = getelementptr i32, i32* %145, i32 0
  %147 = load i32, i32* %146
  %mul32 = mul i32 %144, %147
  %add33 = fadd i32 %add31, %mul32
  %148 = getelementptr i32, i32* %129, i32 0
  store volatile i32 %add33, i32* %148
  %149 = load i32*, i32** %8
  %150 = load i32*, i32** %2
  %151 = getelementptr i32, i32* %150, i32 0
  %152 = load i32, i32* %151
  %153 = load i32*, i32** %3
  %154 = getelementptr i32, i32* %153, i32 1
  %155 = load i32, i32* %154
  %mul34 = mul i32 %152, %155
  %156 = load i32*, i32** %2
  %157 = getelementptr i32, i32* %156, i32 1
  %158 = load i32, i32* %157
  %159 = load i32*, i32** %4
  %160 = getelementptr i32, i32* %159, i32 1
  %161 = load i32, i32* %160
  %mul35 = mul i32 %158, %161
  %add36 = fadd i32 %mul34, %mul35
  %162 = load i32*, i32** %2
  %163 = getelementptr i32, i32* %162, i32 2
  %164 = load i32, i32* %163
  %165 = load i32*, i32** %5
  %166 = getelementptr i32, i32* %165, i32 1
  %167 = load i32, i32* %166
  %mul37 = mul i32 %164, %167
  %add38 = fadd i32 %add36, %mul37
  %168 = getelementptr i32, i32* %149, i32 1
  store volatile i32 %add38, i32* %168
  %169 = load i32*, i32** %8
  %170 = load i32*, i32** %2
  %171 = getelementptr i32, i32* %170, i32 0
  %172 = load i32, i32* %171
  %173 = load i32*, i32** %3
  %174 = getelementptr i32, i32* %173, i32 2
  %175 = load i32, i32* %174
  %mul39 = mul i32 %172, %175
  %176 = load i32*, i32** %2
  %177 = getelementptr i32, i32* %176, i32 1
  %178 = load i32, i32* %177
  %179 = load i32*, i32** %4
  %180 = getelementptr i32, i32* %179, i32 2
  %181 = load i32, i32* %180
  %mul40 = mul i32 %178, %181
  %add41 = fadd i32 %mul39, %mul40
  %182 = load i32*, i32** %2
  %183 = getelementptr i32, i32* %182, i32 2
  %184 = load i32, i32* %183
  %185 = load i32*, i32** %5
  %186 = getelementptr i32, i32* %185, i32 2
  %187 = load i32, i32* %186
  %mul42 = mul i32 %184, %187
  %add43 = fadd i32 %add41, %mul42
  %188 = getelementptr i32, i32* %169, i32 2
  store volatile i32 %add43, i32* %188
  ret i32 0
}

define i32 @main() {
begin:
  store volatile i32 3, i32* @N
  store volatile i32 3, i32* @M
  store volatile i32 3, i32* @L
  %a0 = alloca [3 x i32]
  %a1 = alloca [3 x i32]
  %a2 = alloca [3 x i32]
  %b0 = alloca [3 x i32]
  %b1 = alloca [3 x i32]
  %b2 = alloca [3 x i32]
  %c0 = alloca [6 x i32]
  %c1 = alloca [3 x i32]
  %c2 = alloca [3 x i32]
  %i = alloca i32
  store volatile i32 0, i32* %i
  br label %loop_header

loop_header:                                      ; preds = %loop_body, %begin
  br label %begin
  %0 = load i32, i32* %i
  %1 = load i32, i32* @M
  %less = icmp slt i32 %0, %1
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header1, %loop_header
  %2 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 0
  %3 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 0
  %4 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 0
  %5 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 0
  %6 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 0
  %7 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 0
  %8 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 0
  %9 = getelementptr [3 x i32], [3 x i32]* %c1, i32 0, i32 0
  %10 = getelementptr [3 x i32], [3 x i32]* %c2, i32 0, i32 0
  %call = call i32 @mul(i32* %2, i32* %3, i32* %4, i32* %5, i32* %6, i32* %7, i32* %8, i32* %9, i32* %10)
  store volatile i32 %call, i32* %i
  %x = alloca i32
  br label %loop_header1

loop_body:                                        ; preds = %loop_header
  %11 = load i32, i32* %i
  %12 = load i32, i32* %i
  %13 = getelementptr [3 x i32], [3 x i32]* %a0, i32 0, i32 %12
  store volatile i32 %11, i32* %13
  %14 = load i32, i32* %i
  %15 = load i32, i32* %i
  %16 = getelementptr [3 x i32], [3 x i32]* %a1, i32 0, i32 %15
  store volatile i32 %14, i32* %16
  %17 = load i32, i32* %i
  %18 = load i32, i32* %i
  %19 = getelementptr [3 x i32], [3 x i32]* %a2, i32 0, i32 %18
  store volatile i32 %17, i32* %19
  %20 = load i32, i32* %i
  %21 = load i32, i32* %i
  %22 = getelementptr [3 x i32], [3 x i32]* %b0, i32 0, i32 %21
  store volatile i32 %20, i32* %22
  %23 = load i32, i32* %i
  %24 = load i32, i32* %i
  %25 = getelementptr [3 x i32], [3 x i32]* %b1, i32 0, i32 %24
  store volatile i32 %23, i32* %25
  %26 = load i32, i32* %i
  %27 = load i32, i32* %i
  %28 = getelementptr [3 x i32], [3 x i32]* %b2, i32 0, i32 %27
  store volatile i32 %26, i32* %28
  %29 = load i32, i32* %i
  %add = fadd i32 %29, 1
  store volatile i32 %add, i32* %i
  br label %loop_header

loop_header1:                                     ; preds = %loop_body3, %loop_exit
  br label %loop_exit
  %30 = load i32, i32* %i
  %31 = load i32, i32* @N
  %less4 = icmp slt i32 %30, %31
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header8, %loop_header1
  store volatile i32 10, i32* %x
  store volatile i32 0, i32* %i
  %32 = load i32, i32* %x
  %call7 = call void @putch(i32 %32)
  br label %loop_header8

loop_body3:                                       ; preds = %loop_header1
  %33 = load i32, i32* %i
  %34 = getelementptr [6 x i32], [6 x i32]* %c0, i32 0, i32 %33
  %35 = load i32, i32* %34
  store volatile i32 %35, i32* %x
  %36 = load i32, i32* %x
  %call5 = call void @putint(i32 %36)
  %37 = load i32, i32* %i
  %add6 = fadd i32 %37, 1
  store volatile i32 %add6, i32* %i
  br label %loop_header1

loop_header8:                                     ; preds = %loop_body10, %loop_exit2
  br label %loop_exit2
  %38 = load i32, i32* %i
  %39 = load i32, i32* @N
  %less11 = icmp slt i32 %38, %39
  br i1 %less11, label %loop_body10, label %loop_exit9

loop_exit9:                                       ; preds = %loop_header15, %loop_header8
  store volatile i32 10, i32* %x
  store volatile i32 0, i32* %i
  %40 = load i32, i32* %x
  %call14 = call void @putch(i32 %40)
  br label %loop_header15

loop_body10:                                      ; preds = %loop_header8
  %41 = load i32, i32* %i
  %42 = getelementptr [3 x i32], [3 x i32]* %c1, i32 0, i32 %41
  %43 = load i32, i32* %42
  store volatile i32 %43, i32* %x
  %44 = load i32, i32* %x
  %call12 = call void @putint(i32 %44)
  %45 = load i32, i32* %i
  %add13 = fadd i32 %45, 1
  store volatile i32 %add13, i32* %i
  br label %loop_header8

loop_header15:                                    ; preds = %loop_body17, %loop_exit9
  br label %loop_exit9
  %46 = load i32, i32* %i
  %47 = load i32, i32* @N
  %less18 = icmp slt i32 %46, %47
  br i1 %less18, label %loop_body17, label %loop_exit16

loop_exit16:                                      ; preds = %loop_header15
  store volatile i32 10, i32* %x
  %48 = load i32, i32* %x
  %call21 = call void @putch(i32 %48)
  ret i32 0

loop_body17:                                      ; preds = %loop_header15
  %49 = load i32, i32* %i
  %50 = getelementptr [3 x i32], [3 x i32]* %c2, i32 0, i32 %49
  %51 = load i32, i32* %50
  store volatile i32 %51, i32* %x
  %52 = load i32, i32* %x
  %call19 = call void @putint(i32 %52)
  %53 = load i32, i32* %i
  %add20 = fadd i32 %53, 1
  store volatile i32 %add20, i32* %i
  br label %loop_header15
}
