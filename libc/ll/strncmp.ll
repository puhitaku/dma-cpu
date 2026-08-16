; ModuleID = 'strncmp.c'
source_filename = "strncmp.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @strncmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %24, label %5

5:                                                ; preds = %3, %17
  %6 = phi ptr [ %18, %17 ], [ %0, %3 ]
  %7 = phi ptr [ %19, %17 ], [ %1, %3 ]
  %8 = phi i32 [ %9, %17 ], [ %2, %3 ]
  %9 = add i32 %8, -1
  %10 = load i8, ptr %6, align 1, !tbaa !3
  %11 = load i8, ptr %7, align 1, !tbaa !3
  %12 = icmp ne i8 %10, %11
  %13 = icmp eq i32 %9, 0
  %14 = select i1 %12, i1 true, i1 %13
  %15 = icmp eq i8 %10, 0
  %16 = or i1 %14, %15
  br i1 %16, label %20, label %17

17:                                               ; preds = %5
  %18 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %19 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %5, !llvm.loop !6

20:                                               ; preds = %5
  %21 = zext i8 %10 to i32
  %22 = zext i8 %11 to i32
  %23 = sub nsw i32 %21, %22
  br label %24

24:                                               ; preds = %3, %20
  %25 = phi i32 [ %23, %20 ], [ 0, %3 ]
  ret i32 %25
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
