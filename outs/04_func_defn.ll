; ModuleID = 'default'
source_filename = "default"

@a = global i32 0

define i32 @func(i32 %p) {
begin:
  %0 = alloca i32
  store i32 %p, i32* %0
  %1 = load i32, i32* %0
  %sub = fsub i32 %1, 1
  store volatile i32 %sub, i32* %0
  %2 = load i32, i32* %0
  ret i32 %2
}

define i32 @main() {
begin:
  %b = alloca i32
  store volatile i32 10, i32* @a
  %0 = load i32, i32* @a
  %call = call i32 @func(i32 %0)
  store volatile i32 %call, i32* %b
  %1 = load i32, i32* %b
  ret i32 %1
}
