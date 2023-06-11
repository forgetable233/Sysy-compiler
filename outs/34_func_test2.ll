; ModuleID = 'default'
source_filename = "default"

define i32 @func1() {
begin:
  %a = alloca i32
  store volatile i32 1, i32* %a
  %0 = load i32, i32* %a
  ret i32 %0
}

define i32 @func2() {
begin:
  %a = alloca i32
  store volatile i32 2, i32* %a
  %0 = load i32, i32* %a
  ret i32 %0
}

define i32 @func3() {
begin:
  %a = alloca i32
  store volatile i32 4, i32* %a
  %0 = load i32, i32* %a
  ret i32 %0
}

define i32 @func4() {
begin:
  %a = alloca i32
  %b = alloca i32
  store volatile i32 8, i32* %b
  %0 = load i32, i32* %b
  store volatile i32 %0, i32* %a
  %b1 = alloca i32
  store volatile i32 16, i32* %b
  %1 = load i32, i32* %a
  %2 = load i32, i32* %b
  %add = fadd i32 %1, %2
  store volatile i32 %add, i32* %a
  %3 = load i32, i32* %a
  ret i32 %3
}

define i32 @main() {
begin:
  %a = alloca i32
  %b = alloca i32
  %c = alloca i32
  store volatile i32 32, i32* %a
  store volatile i32 32, i32* %b
  store volatile i32 32, i32* %c
  %call = call i32 @func1()
  %call1 = call i32 @func2()
  %add = fadd i32 %call, %call1
  %call2 = call i32 @func3()
  %add3 = fadd i32 %add, %call2
  %call4 = call i32 @func4()
  %add5 = fadd i32 %add3, %call4
  %0 = load i32, i32* %a
  %add6 = fadd i32 %add5, %0
  %1 = load i32, i32* %b
  %add7 = fadd i32 %add6, %1
  %2 = load i32, i32* %c
  %add8 = fadd i32 %add7, %2
  ret i32 %add8
}
