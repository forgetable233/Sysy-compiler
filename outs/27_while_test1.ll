; ModuleID = 'default'
source_filename = "default"

define i32 @doubleWhile() {
begin:
  %i = alloca i32
  store volatile i32 5, i32* %i
  %j = alloca i32
  store volatile i32 7, i32* %j
  br label %loop_header

loop_header:                                      ; preds = %loop_exit2, %begin
  br label %begin
  %0 = load i32, i32* %i
  %less = icmp slt i32 %0, 100
  br i1 %less, label %loop_body, label %loop_exit

loop_exit:                                        ; preds = %loop_header
  %1 = load i32, i32* %j
  ret i32 %1

loop_body:                                        ; preds = %loop_header1, %loop_header
  %2 = load i32, i32* %i
  %add = fadd i32 %2, 30
  store volatile i32 %add, i32* %i
  br label %loop_header1

loop_header1:                                     ; preds = %loop_body3, %loop_body
  br label %loop_body
  %3 = load i32, i32* %j
  %less4 = icmp slt i32 %3, 100
  br i1 %less4, label %loop_body3, label %loop_exit2

loop_exit2:                                       ; preds = %loop_header1
  %4 = load i32, i32* %j
  %sub = fsub i32 %4, 100
  store volatile i32 %sub, i32* %j
  br label %loop_header

loop_body3:                                       ; preds = %loop_header1
  %5 = load i32, i32* %j
  %add5 = fadd i32 %5, 6
  store volatile i32 %add5, i32* %j
  br label %loop_header1
}

define i32 @main() {
begin:
  %call = call i32 @doubleWhile()
  ret i32 %call
}
