; ModuleID = 'dma/kdma.c'
source_filename = "dma/kdma.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@dmacpy_ctrl = dso_local local_unnamed_addr global i32 0, align 4
@dmacpy_sctrl = dso_local local_unnamed_addr global i32 0, align 4
@xip_stream = dso_local local_unnamed_addr global i32 0, align 4
@xip_aux = dso_local local_unnamed_addr global i32 0, align 4
@kdmaset.fill = internal global i32 0, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kdmacpy(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %61, label %5

5:                                                ; preds = %3
  %6 = load i32, ptr @dmacpy_ctrl, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  %8 = or i32 %1, %0
  %9 = or i32 %8, %2
  %10 = and i32 %9, 3
  %11 = icmp eq i32 %10, 0
  br i1 %7, label %13, label %12

12:                                               ; preds = %5
  br i1 %11, label %37, label %26

13:                                               ; preds = %5
  br i1 %11, label %14, label %26

14:                                               ; preds = %13
  %15 = inttoptr i32 %1 to ptr
  %16 = inttoptr i32 %0 to ptr
  %17 = lshr i32 %2, 2
  br label %18

18:                                               ; preds = %21, %14
  %19 = phi i32 [ 0, %14 ], [ %25, %21 ]
  %20 = icmp eq i32 %19, %17
  br i1 %20, label %61, label %21

21:                                               ; preds = %18
  %22 = getelementptr inbounds nuw i32, ptr %15, i32 %19
  %23 = load i32, ptr %22, align 4, !tbaa !3
  %24 = getelementptr inbounds nuw i32, ptr %16, i32 %19
  store i32 %23, ptr %24, align 4, !tbaa !3
  %25 = add nuw nsw i32 %19, 1
  br label %18, !llvm.loop !7

26:                                               ; preds = %12, %13
  %27 = inttoptr i32 %1 to ptr
  %28 = inttoptr i32 %0 to ptr
  br label %29

29:                                               ; preds = %32, %26
  %30 = phi i32 [ 0, %26 ], [ %36, %32 ]
  %31 = icmp eq i32 %30, %2
  br i1 %31, label %61, label %32

32:                                               ; preds = %29
  %33 = getelementptr inbounds nuw i8, ptr %27, i32 %30
  %34 = load i8, ptr %33, align 1, !tbaa !10
  %35 = getelementptr inbounds nuw i8, ptr %28, i32 %30
  store i8 %34, ptr %35, align 1, !tbaa !10
  %36 = add i32 %30, 1
  br label %29, !llvm.loop !11

37:                                               ; preds = %12
  %38 = load i32, ptr @dmacpy_sctrl, align 4, !tbaa !3
  %39 = icmp ne i32 %38, 0
  %40 = and i32 %1, -268435456
  %41 = icmp eq i32 %40, 268435456
  %42 = and i1 %41, %39
  br i1 %42, label %43, label %55

43:                                               ; preds = %37
  %44 = load i32, ptr @xip_stream, align 4, !tbaa !3
  %45 = inttoptr i32 %44 to ptr
  store volatile i32 %1, ptr %45, align 4, !tbaa !3
  %46 = lshr i32 %2, 2
  %47 = load i32, ptr @xip_stream, align 4, !tbaa !3
  %48 = add i32 %47, 4
  %49 = inttoptr i32 %48 to ptr
  store volatile i32 %46, ptr %49, align 4, !tbaa !3
  %50 = load i32, ptr @xip_aux, align 4, !tbaa !3
  store volatile i32 %50, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 %0, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  store volatile i32 %46, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %51 = load i32, ptr @dmacpy_sctrl, align 4, !tbaa !3
  store volatile i32 %51, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  br label %52

52:                                               ; preds = %52, %43
  %53 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %54 = icmp eq i32 %53, 0
  br i1 %54, label %61, label %52, !llvm.loop !12

55:                                               ; preds = %37
  store volatile i32 %1, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 %0, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  %56 = lshr i32 %2, 2
  store volatile i32 %56, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %57 = load i32, ptr @dmacpy_ctrl, align 4, !tbaa !3
  store volatile i32 %57, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  br label %58

58:                                               ; preds = %58, %55
  %59 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %61, label %58, !llvm.loop !13

61:                                               ; preds = %58, %52, %29, %18, %3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kdmaset(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %27, label %5

5:                                                ; preds = %3
  %6 = load i32, ptr @dmacpy_ctrl, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %12, label %8

8:                                                ; preds = %5
  %9 = or i32 %2, %0
  %10 = and i32 %9, 3
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %20, label %12

12:                                               ; preds = %8, %5
  %13 = add i32 %2, %0
  br label %14

14:                                               ; preds = %17, %12
  %15 = phi i32 [ %0, %12 ], [ %19, %17 ]
  %16 = icmp ult i32 %15, %13
  br i1 %16, label %17, label %27

17:                                               ; preds = %14
  %18 = inttoptr i32 %15 to ptr
  store volatile i32 %1, ptr %18, align 4, !tbaa !3
  %19 = add i32 %15, 4
  br label %14, !llvm.loop !14

20:                                               ; preds = %8
  store i32 %1, ptr @kdmaset.fill, align 4, !tbaa !3
  store volatile i32 ptrtoint (ptr @kdmaset.fill to i32), ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 %0, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  %21 = lshr i32 %2, 2
  store volatile i32 %21, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %22 = load i32, ptr @dmacpy_ctrl, align 4, !tbaa !3
  %23 = and i32 %22, -17
  store volatile i32 %23, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  br label %24

24:                                               ; preds = %24, %20
  %25 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %27, label %24, !llvm.loop !15

27:                                               ; preds = %24, %14, %3
  ret void
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
!10 = !{!5, !5, i64 0}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
