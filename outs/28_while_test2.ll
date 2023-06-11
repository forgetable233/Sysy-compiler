; ModuleID = 'default'
source_filename = "default"

define i32 @FourWhile() {
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
  %add17 = fadd i32 %2, %3
  %add18 = fadd i32 %1, %add17
  %4 = load i32, i32* %c
  %add19 = fadd i32 %add18, %4
  ret i32 %add19

loop_body:                                        ; preds = %loop_header1, %loop_header
  %5 = load i32, i32* %a
  %add = fadd i32 %5, 3
  store volatile i32 %add, i32* %a
  br label %loop_header1

loop_header1:                                     ; preds = %loop_exit7, %loop_body
  br label %loop_body
  %6 = load i32, i32* %b
  %less4 = icmp slt i32 %6, 10
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %7 = load i32, i32* %b
  %sub16 = fsub i32 %7, 2
  store volatile i32 %sub16, i32* %b
  br label %loop_header

loop_body3:                                       ; preds = %loop_header6, %loop_header1
  %8 = load i32, i32* %b
  %add5 = fadd i32 %8, 1
  store volatile i32 %add5, i32* %b
  br label %loop_header6

loop_header6:                                     ; preds = %loop_exit10, %loop_body3
  br label %loop_body3
  %9 = load i32, i32* %c
  %equal = icmp eq i32 %9, 7
  br i1 %equal, label %loop_body8, label %loop_exit7

loop_exit7:                                       ; preds = %loop_header6
  %10 = load i32, i32* %c
  %add15 = fadd i32 %10, 1
  store volatile i32 %add15, i32* %c
  br label %loop_header1

loop_body8:                                       ; preds = %loop_header9, %loop_header6
  %11 = load i32, i32* %c
  %sub = fsub i32 %11, 1
  store volatile i32 %sub, i32* %c
  br label %loop_header9

loop_header9:                                     ; preds = %loop_body11, %loop_body8
  br label %loop_body8
  %12 = load i32, i32* %d
  %less12 = icmp slt i32 %12, 20
  br i1 %less12, label %loop_body11, label %loop_exit10

loop_exit10:                                      ; preds = %loop_header9
  %13 = load i32, i32* %d
  %sub14 = fsub i32 %13, 1
  store volatile i32 %sub14, i32* %d
  br label %loop_header6

loop_body11:                                      ; preds = %loop_header9
  %14 = load i32, i32* %d
  %add13 = fadd i32 %14, 3
  store volatile i32 %add13, i32* %d
  br label %loop_header9
}

define i32 @main() {
begin:
  %call = call i32 @FourWhile()
  ret i32 %call
}
