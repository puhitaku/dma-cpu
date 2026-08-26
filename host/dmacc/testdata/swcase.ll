; Hand-written (not a clang golden; excluded from `make llgen`):
; sub-32-bit switch case values with the sign bit set. LLVM prints an
; i8 case for 0xFE as `i8 -2`, and the parser sign-extends it — while
; the switch operand arrives as a zero-extended truncation (0x000000FE).
; dmacc must canonicalize the case values to the scrutinee's width or
; the compare can never match (found on silicon: the SD driver's 0xFE
; data token fell through its dispatch at every clock rate).
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

define dso_local i32 @sw8(i32 noundef %0) local_unnamed_addr {
  %2 = trunc i32 %0 to i8
  switch i8 %2, label %def [
    i8 -2, label %a
    i8 -128, label %b
    i8 7, label %c
  ]

a:
  ret i32 1

b:
  ret i32 2

c:
  ret i32 3

def:
  ret i32 0
}

define dso_local i32 @sw16(i32 noundef %0) local_unnamed_addr {
  %2 = trunc i32 %0 to i16
  switch i16 %2, label %def [
    i16 -2, label %a
    i16 258, label %b
  ]

a:
  ret i32 4

b:
  ret i32 5

def:
  ret i32 0
}

define dso_local i32 @main() local_unnamed_addr {
  %1 = call i32 @sw8(i32 254)
  %2 = call i32 @sw8(i32 128)
  %3 = call i32 @sw8(i32 7)
  %4 = call i32 @sw8(i32 9)
  %5 = call i32 @sw16(i32 65534)
  %6 = call i32 @sw16(i32 258)
  %7 = mul i32 %1, 10
  %8 = add i32 %7, %2
  %9 = mul i32 %8, 10
  %10 = add i32 %9, %3
  %11 = mul i32 %10, 10
  %12 = add i32 %11, %4
  %13 = mul i32 %12, 10
  %14 = add i32 %13, %5
  %15 = mul i32 %14, 10
  %16 = add i32 %15, %6
  ret i32 %16
}
