; ModuleID = 'dmacc/testdata/arith.c'
source_filename = "dmacc/testdata/arith.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@seed0 = dso_local global i32 12345, align 4

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local i32 @lcg(ptr noundef captures(none) %0) local_unnamed_addr #0 {
  %2 = load i32, ptr %0, align 4, !tbaa !3
  %3 = mul i32 %2, 1664525
  %4 = add i32 %3, 1013904223
  store i32 %4, ptr %0, align 4, !tbaa !3
  ret i32 %4
}

; Function Attrs: nofree norecurse nounwind memory(readwrite, argmem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #1 {
  %1 = load volatile i32, ptr @seed0, align 4, !tbaa !3
  br label %4

2:                                                ; preds = %4
  %3 = and i32 %36, 2147483647
  ret i32 %3

4:                                                ; preds = %0, %4
  %5 = phi i32 [ 0, %0 ], [ %36, %4 ]
  %6 = phi i32 [ 0, %0 ], [ %37, %4 ]
  %7 = phi i32 [ %1, %0 ], [ %11, %4 ]
  %8 = mul i32 %7, 1664525
  %9 = add i32 %8, 1013904223
  %10 = mul i32 %9, 1664525
  %11 = add i32 %10, 1013904223
  %12 = or i32 %11, 1
  %13 = add i32 %5, %9
  %14 = add i32 %13, %12
  %15 = sub i32 %9, %12
  %16 = xor i32 %14, %15
  %17 = and i32 %12, %9
  %18 = add i32 %16, %17
  %19 = or i32 %12, %9
  %20 = xor i32 %18, %19
  %21 = freeze i32 %9
  %22 = freeze i32 %12
  %23 = udiv i32 %21, %22
  %24 = mul i32 %23, %22
  %25 = sub i32 %21, %24
  %26 = add i32 %25, %20
  %27 = xor i32 %26, %23
  %28 = ashr i32 %9, 3
  %29 = and i32 %12, 31
  %30 = lshr i32 %9, %29
  %31 = shl i32 %9, %29
  %32 = mul i32 %12, %9
  %33 = add i32 %32, %28
  %34 = add i32 %33, %30
  %35 = add i32 %34, %31
  %36 = add i32 %35, %27
  %37 = add nuw nsw i32 %6, 1
  %38 = icmp eq i32 %37, 20
  br i1 %38, label %2, label %4, !llvm.loop !7
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { nofree norecurse nounwind memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
