; ModuleID = 'dmacc/testdata/collatz.c'
source_filename = "dmacc/testdata/collatz.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(none)
define dso_local i32 @steps(i32 noundef %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i32 [ %0, %1 ], [ %12, %6 ]
  %4 = phi i32 [ 0, %1 ], [ %13, %6 ]
  %5 = icmp eq i32 %3, 1
  br i1 %5, label %14, label %6

6:                                                ; preds = %2
  %7 = and i32 %3, 1
  %8 = icmp eq i32 %7, 0
  %9 = mul i32 %3, 3
  %10 = add i32 %9, 1
  %11 = lshr exact i32 %3, 1
  %12 = select i1 %8, i32 %11, i32 %10
  %13 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !3

14:                                               ; preds = %2
  ret i32 %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(none)
define dso_local i32 @main() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %6, %0
  %2 = phi i32 [ 0, %0 ], [ %8, %6 ]
  %3 = phi i32 [ 1, %0 ], [ %9, %6 ]
  %4 = icmp eq i32 %3, 31
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  ret i32 %2

6:                                                ; preds = %1
  %7 = tail call i32 @steps(i32 noundef %3) #1
  %8 = add nsw i32 %7, %2
  %9 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !6
}

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = distinct !{!6, !4, !5}
