; ModuleID = 'puts.c'
source_filename = "puts.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@stdout = external dso_local local_unnamed_addr constant ptr, align 4

; Function Attrs: nounwind
define dso_local range(i32 -1, 1) i32 @puts(ptr noundef readonly captures(none) %0) local_unnamed_addr #0 {
  %2 = load ptr, ptr @stdout, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 2
  %4 = load i8, ptr %3, align 2, !tbaa !8
  %5 = and i8 %4, 2
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %24, label %7

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %9 = load ptr, ptr %8, align 4, !tbaa !11
  br label %10

10:                                               ; preds = %14, %7
  %11 = phi ptr [ %0, %7 ], [ %15, %14 ]
  %12 = load i8, ptr %11, align 1, !tbaa !12
  %13 = icmp eq i8 %12, 0
  br i1 %13, label %18, label %14

14:                                               ; preds = %10
  %15 = getelementptr inbounds nuw i8, ptr %11, i32 1
  %16 = tail call i32 %9(i8 noundef signext %12, ptr noundef %2) #1
  %17 = icmp slt i32 %16, 0
  br i1 %17, label %21, label %10, !llvm.loop !13

18:                                               ; preds = %10
  %19 = tail call i32 %9(i8 noundef signext 10, ptr noundef %2) #1
  %20 = icmp slt i32 %19, 0
  br i1 %20, label %21, label %24

21:                                               ; preds = %14, %18
  %22 = load i8, ptr %3, align 2, !tbaa !8
  %23 = or i8 %22, 4
  store i8 %23, ptr %3, align 2, !tbaa !8
  br label %24

24:                                               ; preds = %18, %1, %21
  %25 = phi i32 [ -1, %1 ], [ -1, %21 ], [ 0, %18 ]
  ret i32 %25
}

attributes #0 = { nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { nobuiltin nounwind "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"p1 _ZTS6__file", !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !6, i64 2}
!9 = !{!"__file", !10, i64 0, !6, i64 2, !5, i64 4, !5, i64 8, !5, i64 12}
!10 = !{!"short", !6, i64 0}
!11 = !{!9, !5, i64 4}
!12 = !{!6, !6, i64 0}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
