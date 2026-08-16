; ModuleID = 'memchr.c'
source_filename = "memchr.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local ptr @memchr(ptr noundef readonly captures(ret: address, provenance) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = trunc i32 %1 to i8
  br label %5

5:                                                ; preds = %13, %3
  %6 = phi i32 [ %2, %3 ], [ %8, %13 ]
  %7 = phi ptr [ %0, %3 ], [ %14, %13 ]
  %8 = add i32 %6, -1
  %9 = icmp eq i32 %6, 0
  br i1 %9, label %15, label %10

10:                                               ; preds = %5
  %11 = load i8, ptr %7, align 1, !tbaa !3
  %12 = icmp eq i8 %11, %4
  br i1 %12, label %15, label %13

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %5, !llvm.loop !6

15:                                               ; preds = %5, %10
  %16 = phi ptr [ %7, %10 ], [ null, %5 ]
  ret ptr %16
}

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
