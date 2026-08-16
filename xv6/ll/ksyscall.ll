; ModuleID = 'dma/ksyscall.c'
source_filename = "dma/ksyscall.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@dma_mail = dso_local global [2 x ptr] zeroinitializer, align 4
@dma_wsw = dso_local global ptr null, align 4
@dma_ticks = dso_local global ptr null, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@dma_exit_status = dso_local local_unnamed_addr global [2 x i32] zeroinitializer, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local noundef i32 @dma_ksyscall(i32 noundef %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds [2 x ptr], ptr @dma_mail, i32 0, i32 %0
  %3 = load volatile ptr, ptr %2, align 4, !tbaa !3
  %4 = load volatile ptr, ptr @dma_wsw, align 4, !tbaa !8
  store i32 0, ptr %4, align 4, !tbaa !10
  %5 = load volatile i32, ptr %3, align 4, !tbaa !12
  switch i32 %5, label %42 [
    i32 11, label %6
    i32 14, label %8
    i32 16, label %11
    i32 13, label %31
    i32 2, label %35
  ]

6:                                                ; preds = %1
  %7 = add i32 %0, 1
  br label %42

8:                                                ; preds = %1
  %9 = load volatile ptr, ptr @dma_ticks, align 4, !tbaa !8
  %10 = load i32, ptr %9, align 4, !tbaa !10
  br label %42

11:                                               ; preds = %1
  %12 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %13 = load volatile i32, ptr %12, align 4, !tbaa !14
  %14 = inttoptr i32 %13 to ptr
  %15 = getelementptr inbounds nuw i8, ptr %3, i32 12
  br label %16

16:                                               ; preds = %26, %11
  %17 = phi i32 [ 0, %11 ], [ %30, %26 ]
  %18 = load volatile i32, ptr %15, align 4, !tbaa !15
  %19 = icmp ult i32 %17, %18
  br i1 %19, label %22, label %20

20:                                               ; preds = %16
  %21 = load volatile i32, ptr %15, align 4, !tbaa !15
  br label %42

22:                                               ; preds = %16, %22
  %23 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !10
  %24 = and i32 %23, 32
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %22, !llvm.loop !16

26:                                               ; preds = %22
  %27 = getelementptr inbounds nuw i8, ptr %14, i32 %17
  %28 = load i8, ptr %27, align 1, !tbaa !19
  %29 = zext i8 %28 to i32
  store volatile i32 %29, ptr @__dma_uart_dr, align 4, !tbaa !10
  %30 = add nuw i32 %17, 1
  br label %16, !llvm.loop !20

31:                                               ; preds = %1
  %32 = getelementptr inbounds nuw i8, ptr %3, i32 16
  store volatile i32 0, ptr %32, align 4, !tbaa !21
  %33 = getelementptr inbounds nuw i8, ptr %3, i32 20
  store volatile i32 1, ptr %33, align 4, !tbaa !22
  %34 = load volatile ptr, ptr @dma_wsw, align 4, !tbaa !8
  store i32 1, ptr %34, align 4, !tbaa !10
  br label %46

35:                                               ; preds = %1
  %36 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %37 = load volatile i32, ptr %36, align 4, !tbaa !23
  %38 = getelementptr inbounds [2 x i32], ptr @dma_exit_status, i32 0, i32 %0
  store i32 %37, ptr %38, align 4, !tbaa !10
  %39 = getelementptr inbounds nuw i8, ptr %3, i32 16
  store volatile i32 0, ptr %39, align 4, !tbaa !21
  %40 = getelementptr inbounds nuw i8, ptr %3, i32 20
  store volatile i32 1, ptr %40, align 4, !tbaa !22
  %41 = load volatile ptr, ptr @dma_wsw, align 4, !tbaa !8
  store i32 1, ptr %41, align 4, !tbaa !10
  br label %46

42:                                               ; preds = %1, %20, %8, %6
  %43 = phi i32 [ -1, %1 ], [ %7, %6 ], [ %10, %8 ], [ %21, %20 ]
  %44 = getelementptr inbounds nuw i8, ptr %3, i32 16
  store volatile i32 %43, ptr %44, align 4, !tbaa !21
  %45 = getelementptr inbounds nuw i8, ptr %3, i32 20
  store volatile i32 1, ptr %45, align 4, !tbaa !22
  br label %46

46:                                               ; preds = %42, %35, %31
  ret i32 0
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"p1 _ZTS11dma_sysmail", !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"p1 int", !5, i64 0}
!10 = !{!11, !11, i64 0}
!11 = !{!"int", !6, i64 0}
!12 = !{!13, !11, i64 0}
!13 = !{!"dma_sysmail", !11, i64 0, !11, i64 4, !11, i64 8, !11, i64 12, !11, i64 16, !11, i64 20}
!14 = !{!13, !11, i64 8}
!15 = !{!13, !11, i64 12}
!16 = distinct !{!16, !17, !18}
!17 = !{!"llvm.loop.mustprogress"}
!18 = !{!"llvm.loop.unroll.disable"}
!19 = !{!6, !6, i64 0}
!20 = distinct !{!20, !17, !18}
!21 = !{!13, !11, i64 16}
!22 = !{!13, !11, i64 20}
!23 = !{!13, !11, i64 4}
