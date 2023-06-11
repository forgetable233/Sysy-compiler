; ModuleID = 'default'
source_filename = "default"

define i32 @defn() {
begin:
  ret i32 4
}

define i32 @main() {
begin:
  %a = alloca i32
  %call = call i32 @defn()
  store i32 %call, i32* %a
  %0 = load i32, i32* %a
  ret i32 %0
}
