; ModuleID = 'dmacc/testdata/func.c'
source_filename = "dmacc/testdata/func.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@start = dso_local global i32 -3, align 4

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local i32 @f6(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %5) local_unnamed_addr #0 {
  %7 = shl nsw i32 %1, 1
  %8 = add nsw i32 %7, %0
  %9 = mul nsw i32 %2, 3
  %10 = add nsw i32 %8, %9
  %11 = shl nsw i32 %3, 2
  %12 = add nsw i32 %10, %11
  %13 = mul nsw i32 %4, 5
  %14 = add nsw i32 %12, %13
  %15 = mul nsw i32 %5, 6
  %16 = add nsw i32 %14, %15
  ret i32 %16
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local i32 @g2(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = xor i32 %1, %0
  %4 = sub nsw i32 %0, %1
  %5 = add nsw i32 %1, %0
  %6 = mul nsw i32 %3, 3
  %7 = shl nsw i32 %4, 2
  %8 = mul nsw i32 %5, 5
  %9 = mul i32 %0, 6
  %10 = add i32 %9, 2
  %11 = mul i32 %10, %1
  %12 = add i32 %6, %0
  %13 = add i32 %12, %7
  %14 = add i32 %13, %8
  %15 = add i32 %14, %11
  ret i32 %15
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local i32 @h(i32 noundef %0) local_unnamed_addr #0 {
  %2 = add nsw i32 %0, 1
  %3 = xor i32 %2, %0
  %4 = mul i32 %0, 6
  %5 = add i32 %4, 2
  %6 = mul i32 %5, %2
  %7 = sub nsw i32 0, %0
  %8 = xor i32 %7, 3
  %9 = mul i32 %0, -18
  %10 = add i32 %3, %8
  %11 = mul i32 %10, 3
  %12 = add i32 %0, -10
  %13 = add i32 %12, %9
  %14 = add i32 %13, %6
  %15 = add i32 %14, %11
  %16 = add i32 %15, 20
  ret i32 %16
}

; Function Attrs: nofree norecurse nounwind memory(readwrite, argmem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #1 {
  %1 = load volatile i32, ptr @start, align 4, !tbaa !3
  %2 = icmp slt i32 %1, 4
  br i1 %2, label %7, label %5

3:                                                ; preds = %7
  %4 = and i32 %25, 2147483647
  br label %5

5:                                                ; preds = %3, %0
  %6 = phi i32 [ 0, %0 ], [ %4, %3 ]
  ret i32 %6

7:                                                ; preds = %0, %7
  %8 = phi i32 [ %11, %7 ], [ %1, %0 ]
  %9 = phi i32 [ %25, %7 ], [ 0, %0 ]
  %10 = mul nsw i32 %9, 13
  %11 = add nsw i32 %8, 1
  %12 = xor i32 %11, %8
  %13 = mul i32 %8, 6
  %14 = add i32 %13, 2
  %15 = mul i32 %14, %11
  %16 = sub nsw i32 0, %8
  %17 = xor i32 %16, 3
  %18 = mul i32 %8, -18
  %19 = add i32 %12, %17
  %20 = mul i32 %19, 3
  %21 = add nsw i32 %8, 10
  %22 = add i32 %21, %10
  %23 = add i32 %22, %18
  %24 = add i32 %23, %15
  %25 = add i32 %24, %20
  %26 = icmp eq i32 %11, 4
  br i1 %26, label %3, label %7, !llvm.loop !7
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
