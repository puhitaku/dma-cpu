; ModuleID = 'fputs.c'
source_filename = "fputs.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nounwind
define dso_local range(i32 -1, 1) i32 @fputs(ptr noundef readonly captures(none) %0, ptr noundef nonnull %1) local_unnamed_addr #0 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 2
  %4 = load i8, ptr %3, align 2, !tbaa !3
  %5 = and i8 %4, 2
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %21, label %7

7:                                                ; preds = %2
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %9 = load ptr, ptr %8, align 4, !tbaa !9
  br label %10

10:                                               ; preds = %14, %7
  %11 = phi ptr [ %0, %7 ], [ %15, %14 ]
  %12 = load i8, ptr %11, align 1, !tbaa !10
  %13 = icmp eq i8 %12, 0
  br i1 %13, label %21, label %14

14:                                               ; preds = %10
  %15 = getelementptr inbounds nuw i8, ptr %11, i32 1
  %16 = tail call i32 %9(i8 noundef signext %12, ptr noundef nonnull %1) #1
  %17 = icmp slt i32 %16, 0
  br i1 %17, label %18, label %10, !llvm.loop !11

18:                                               ; preds = %14
  %19 = load i8, ptr %3, align 2, !tbaa !3
  %20 = or i8 %19, 4
  store i8 %20, ptr %3, align 2, !tbaa !3
  br label %21

21:                                               ; preds = %10, %18, %2
  %22 = phi i32 [ -1, %2 ], [ -1, %18 ], [ 0, %10 ]
  ret i32 %22
}

attributes #0 = { nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { nobuiltin nounwind "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !6, i64 2}
!4 = !{!"__file", !5, i64 0, !6, i64 2, !8, i64 4, !8, i64 8, !8, i64 12}
!5 = !{!"short", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"any pointer", !6, i64 0}
!9 = !{!4, !8, i64 4}
!10 = !{!6, !6, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
