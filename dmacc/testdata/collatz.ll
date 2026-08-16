; ModuleID = 'dmacc/testdata/collatz.c'
source_filename = "dmacc/testdata/collatz.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(none)
define dso_local i32 @steps(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp eq i32 %0, 1
  br i1 %2, label %14, label %3

3:                                                ; preds = %1, %3
  %4 = phi i32 [ %12, %3 ], [ 0, %1 ]
  %5 = phi i32 [ %11, %3 ], [ %0, %1 ]
  %6 = and i32 %5, 1
  %7 = icmp eq i32 %6, 0
  %8 = mul i32 %5, 3
  %9 = add i32 %8, 1
  %10 = lshr exact i32 %5, 1
  %11 = select i1 %7, i32 %10, i32 %9
  %12 = add nuw nsw i32 %4, 1
  %13 = icmp eq i32 %11, 1
  br i1 %13, label %14, label %3, !llvm.loop !3

14:                                               ; preds = %3, %1
  %15 = phi i32 [ 0, %1 ], [ %12, %3 ]
  ret i32 %15
}

; Function Attrs: nofree norecurse nosync nounwind memory(none)
define dso_local i32 @main() local_unnamed_addr #0 {
  br label %2

1:                                                ; preds = %17
  ret i32 %19

2:                                                ; preds = %0, %17
  %3 = phi i32 [ 1, %0 ], [ %20, %17 ]
  %4 = phi i32 [ 0, %0 ], [ %19, %17 ]
  %5 = icmp eq i32 %3, 1
  br i1 %5, label %17, label %6

6:                                                ; preds = %2, %6
  %7 = phi i32 [ %15, %6 ], [ 0, %2 ]
  %8 = phi i32 [ %14, %6 ], [ %3, %2 ]
  %9 = and i32 %8, 1
  %10 = icmp eq i32 %9, 0
  %11 = mul i32 %8, 3
  %12 = add i32 %11, 1
  %13 = lshr exact i32 %8, 1
  %14 = select i1 %10, i32 %13, i32 %12
  %15 = add nuw nsw i32 %7, 1
  %16 = icmp eq i32 %14, 1
  br i1 %16, label %17, label %6, !llvm.loop !3

17:                                               ; preds = %6, %2
  %18 = phi i32 [ 0, %2 ], [ %15, %6 ]
  %19 = add nsw i32 %18, %4
  %20 = add nuw nsw i32 %3, 1
  %21 = icmp eq i32 %20, 31
  br i1 %21, label %1, label %2, !llvm.loop !6
}

attributes #0 = { nofree norecurse nosync nounwind memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = distinct !{!6, !4, !5}
