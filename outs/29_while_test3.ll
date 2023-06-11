; ModuleID = 'default'
source_filename = "default"

@g = global i32 0
@h = global i32 0
@f = global i32 0
@e = global i32 0

define i32 @EightWhile() {
begin:
  %a = alloca i32
  store volatile i32 5, i32* %a
  %b = alloca i32
  %c = alloca i32
  store volatile i32 6, i32* %b
  store volatile i32 7, i32* %c
  %d = alloca i32
  store volatile i32 10, i32* %d
  br label %loop_header

loop_header:                                      ; preds = %loop_exit2, %begin
  br label %begin
  %0 = load i32, i32* %a
  %less = icmp slt i32 %0, 20
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %a
  %2 = load i32, i32* %b
  %3 = load i32, i32* %d
  %add40 = fadd i32 %2, %3
  %add41 = fadd i32 %1, %add40
  %4 = load i32, i32* %c
  %add42 = fadd i32 %add41, %4
  %5 = load i32, i32* @e
  %6 = load i32, i32* %d
  %add43 = fadd i32 %5, %6
  %7 = load i32, i32* @g
  %sub44 = fsub i32 %add43, %7
  %8 = load i32, i32* @h
  %add45 = fadd i32 %sub44, %8
  %sub46 = fsub i32 %add42, %add45
  ret i32 %sub46

loop_body:                                        ; preds = %loop_header1, %loop_header
  %9 = load i32, i32* %a
  %add = fadd i32 %9, 3
  store volatile i32 %add, i32* %a
  br label %loop_header1

loop_header1:                                     ; preds = %loop_exit7, %loop_body
  br label %loop_body
  %10 = load i32, i32* %b
  %less4 = icmp slt i32 %10, 10
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %11 = load i32, i32* %b
  %sub39 = fsub i32 %11, 2
  store volatile i32 %sub39, i32* %b
  br label %loop_header

loop_body3:                                       ; preds = %loop_header6, %loop_header1
  %12 = load i32, i32* %b
  %add5 = fadd i32 %12, 1
  store volatile i32 %add5, i32* %b
  br label %loop_header6

loop_header6:                                     ; preds = %loop_exit10, %loop_body3
  br label %loop_body3
  %13 = load i32, i32* %c
  %equal = icmp eq i32 %13, 7
  br i1 %equal, label %loop_body8, label %loop_exit7

loop_exit7:                                       ; preds = %loop_header6
  %14 = load i32, i32* %c
  %add38 = fadd i32 %14, 1
  store volatile i32 %add38, i32* %c
  br label %loop_header1

loop_body8:                                       ; preds = %loop_header9, %loop_header6
  %15 = load i32, i32* %c
  %sub = fsub i32 %15, 1
  store volatile i32 %sub, i32* %c
  br label %loop_header9

loop_header9:                                     ; preds = %loop_exit15, %loop_body8
  br label %loop_body8
  %16 = load i32, i32* %d
  %less12 = icmp slt i32 %16, 20
  br i1 %less12, label %loop_body11, label %loop_exit10

loop_exit10:                                      ; preds = %loop_header9
  %17 = load i32, i32* %d
  %sub37 = fsub i32 %17, 1
  store volatile i32 %sub37, i32* %d
  br label %loop_header6

loop_body11:                                      ; preds = %loop_header14, %loop_header9
  %18 = load i32, i32* %d
  %add13 = fadd i32 %18, 3
  store volatile i32 %add13, i32* %d
  br label %loop_header14

loop_header14:                                    ; preds = %loop_exit19, %loop_body11
  br label %loop_body11
  %19 = load i32, i32* @e
  %greater = icmp sgt i32 %19, 1
  br i1 %greater, label %loop_body16, label %loop_exit15

loop_exit15:                                      ; preds = %loop_header14
  %20 = load i32, i32* @e
  %add36 = fadd i32 %20, 1
  store volatile i32 %add36, i32* @e
  br label %loop_header9

loop_body16:                                      ; preds = %loop_header18, %loop_header14
  %21 = load i32, i32* @e
  %sub17 = fsub i32 %21, 1
  store volatile i32 %sub17, i32* @e
  br label %loop_header18

loop_header18:                                    ; preds = %loop_exit24, %loop_body16
  br label %loop_body16
  %22 = load i32, i32* @f
  %greater21 = icmp sgt i32 %22, 2
  br i1 %greater21, label %loop_body20, label %loop_exit19

loop_exit19:                                      ; preds = %loop_header18
  %23 = load i32, i32* @f
  %add35 = fadd i32 %23, 1
  store volatile i32 %add35, i32* @f
  br label %loop_header14

loop_body20:                                      ; preds = %loop_header23, %loop_header18
  %24 = load i32, i32* @f
  %sub22 = fsub i32 %24, 2
  store volatile i32 %sub22, i32* @f
  br label %loop_header23

loop_header23:                                    ; preds = %loop_exit29, %loop_body20
  br label %loop_body20
  %25 = load i32, i32* @g
  %less26 = icmp slt i32 %25, 3
  br i1 %less26, label %loop_body25, label %loop_exit24

loop_exit24:                                      ; preds = %loop_header23
  %26 = load i32, i32* @g
  %sub34 = fsub i32 %26, 8
  store volatile i32 %sub34, i32* @g
  br label %loop_header18

loop_body25:                                      ; preds = %loop_header28, %loop_header23
  %27 = load i32, i32* @g
  %add27 = fadd i32 %27, 10
  store volatile i32 %add27, i32* @g
  br label %loop_header28

loop_header28:                                    ; preds = %loop_body30, %loop_body25
  br label %loop_body25
  %28 = load i32, i32* @h
  %less31 = icmp slt i32 %28, 10
  br i1 %less31, label %loop_body30, label %loop_exit29

loop_exit29:                                      ; preds = %loop_header28
  %29 = load i32, i32* @h
  %sub33 = fsub i32 %29, 1
  store volatile i32 %sub33, i32* @h
  br label %loop_header23

loop_body30:                                      ; preds = %loop_header28
  %30 = load i32, i32* @h
  %add32 = fadd i32 %30, 8
  store volatile i32 %add32, i32* @h
  br label %loop_header28
}

define i32 @main() {
begin:
  store volatile i32 1, i32* @g
  store volatile i32 2, i32* @h
  store volatile i32 4, i32* @e
  store volatile i32 6, i32* @f
  %call = call i32 @EightWhile()
  ret i32 %call
}
