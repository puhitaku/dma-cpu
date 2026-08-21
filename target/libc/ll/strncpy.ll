; ModuleID = 'strncpy.c'
source_filename = "strncpy.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @strncpy(ptr noalias noundef returned writeonly captures(ret: address, provenance) %0, ptr noalias noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %16, label %5

5:                                                ; preds = %3, %5
  %6 = phi i32 [ %9, %5 ], [ %2, %3 ]
  %7 = phi ptr [ %12, %5 ], [ %0, %3 ]
  %8 = phi ptr [ %10, %5 ], [ %1, %3 ]
  %9 = add i32 %6, -1
  %10 = getelementptr inbounds nuw i8, ptr %8, i32 1
  %11 = load i8, ptr %8, align 1, !tbaa !3
  %12 = getelementptr inbounds nuw i8, ptr %7, i32 1
  store i8 %11, ptr %7, align 1, !tbaa !3
  %13 = icmp ne i8 %11, 0
  %14 = icmp ne i32 %9, 0
  %15 = select i1 %13, i1 %14, i1 false
  br i1 %15, label %5, label %16, !llvm.loop !6

16:                                               ; preds = %5, %3
  %17 = phi i32 [ 0, %3 ], [ %9, %5 ]
  %18 = phi ptr [ %0, %3 ], [ %12, %5 ]
  br label %19

19:                                               ; preds = %16, %23
  %20 = phi i32 [ %24, %23 ], [ %17, %16 ]
  %21 = phi ptr [ %25, %23 ], [ %18, %16 ]
  %22 = icmp eq i32 %20, 0
  br i1 %22, label %26, label %23

23:                                               ; preds = %19
  %24 = add i32 %20, -1
  %25 = getelementptr inbounds nuw i8, ptr %21, i32 1
  store i8 0, ptr %21, align 1, !tbaa !3
  br label %19, !llvm.loop !9

26:                                               ; preds = %19
  ret ptr %0
}

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
!9 = distinct !{!9, !7, !8}
