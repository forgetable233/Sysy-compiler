; ModuleID = 'default'
source_filename = "default"

@a = global i32 0
@b = global i32 0
@c = global i32 0

define i32 @add(i32 %a, i32 %b) {
begin:
  %0 = alloca i32
  %1 = alloca i32
  store i32 %a, i32* %0
  store i32 %b, i32* %1
  %2 = load i32, i32* %0
  %3 = load i32, i32* %1
  %add = fadd i32 %2, %3
  store volatile i32 %add, i32* @c
  ret void
}

define i32 @main() {
begin:
  store volatile i32 3, i32* @a
  store volatile i32 2, i32* @b
  %0 = load i32, i32* @a
  %1 = load i32, i32* @b
  %call = call i32 @add(i32 %0, i32 %1)
  %2 = load i32, i32* @c
  ret i32 %2
}
