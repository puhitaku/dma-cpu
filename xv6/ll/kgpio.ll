; ModuleID = 'dma/kgpio.c'
source_filename = "dma/kgpio.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@gpio_hi = dso_local local_unnamed_addr global i32 0, align 4
@gpio_lo = dso_local local_unnamed_addr global i32 0, align 4
@iobank0 = dso_local local_unnamed_addr global i32 0, align 4
@padsbank0 = dso_local local_unnamed_addr global i32 0, align 4
@pio0base = dso_local local_unnamed_addr global i32 0, align 4
@gpiopins = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 2) i32 @kgpio(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = load i32, ptr @iobank0, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  %6 = load i32, ptr @gpiopins, align 4
  %7 = icmp uge i32 %1, %6
  %8 = select i1 %5, i1 true, i1 %7
  br i1 %8, label %44, label %9

9:                                                ; preds = %3
  %10 = load i32, ptr @padsbank0, align 4, !tbaa !3
  %11 = shl i32 %1, 2
  %12 = add i32 %11, 4
  %13 = add i32 %12, %10
  %14 = inttoptr i32 %13 to ptr
  store volatile i32 82, ptr %14, align 4, !tbaa !3
  switch i32 %0, label %44 [
    i32 0, label %15
    i32 1, label %25
    i32 2, label %33
  ]

15:                                               ; preds = %9
  %16 = icmp eq i32 %2, 0
  %17 = load i32, ptr @gpio_hi, align 4
  %18 = load i32, ptr @gpio_lo, align 4
  %19 = select i1 %16, i32 %18, i32 %17
  %20 = load i32, ptr @iobank0, align 4, !tbaa !3
  %21 = shl i32 %1, 3
  %22 = or disjoint i32 %21, 4
  %23 = add i32 %22, %20
  %24 = inttoptr i32 %23 to ptr
  store volatile i32 %19, ptr %24, align 4, !tbaa !3
  br label %44

25:                                               ; preds = %9
  %26 = load i32, ptr @iobank0, align 4, !tbaa !3
  %27 = shl i32 %1, 3
  %28 = add i32 %26, %27
  %29 = inttoptr i32 %28 to ptr
  %30 = load volatile i32, ptr %29, align 4, !tbaa !3
  %31 = lshr i32 %30, 17
  %32 = and i32 %31, 1
  br label %44

33:                                               ; preds = %9
  %34 = load i32, ptr @padsbank0, align 4, !tbaa !3
  %35 = add i32 %12, %34
  %36 = inttoptr i32 %35 to ptr
  store volatile i32 90, ptr %36, align 4, !tbaa !3
  %37 = load i32, ptr @iobank0, align 4, !tbaa !3
  %38 = shl i32 %1, 3
  %39 = add i32 %37, %38
  %40 = inttoptr i32 %39 to ptr
  %41 = load volatile i32, ptr %40, align 4, !tbaa !3
  %42 = lshr i32 %41, 17
  %43 = and i32 %42, 1
  br label %44

44:                                               ; preds = %9, %3, %33, %25, %15
  %45 = phi i32 [ 0, %15 ], [ %32, %25 ], [ %43, %33 ], [ -1, %3 ], [ -1, %9 ]
  ret i32 %45
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 1) i32 @kpinmux(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = load i32, ptr @iobank0, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  %5 = load i32, ptr @gpiopins, align 4
  %6 = icmp uge i32 %0, %5
  %7 = select i1 %4, i1 true, i1 %6
  br i1 %7, label %21, label %8

8:                                                ; preds = %2
  %9 = icmp ugt i32 %1, 31
  br i1 %9, label %21, label %10

10:                                               ; preds = %8
  %11 = load i32, ptr @padsbank0, align 4, !tbaa !3
  %12 = shl i32 %0, 2
  %13 = add i32 %12, 4
  %14 = add i32 %13, %11
  %15 = inttoptr i32 %14 to ptr
  store volatile i32 82, ptr %15, align 4, !tbaa !3
  %16 = load i32, ptr @iobank0, align 4, !tbaa !3
  %17 = shl i32 %0, 3
  %18 = or disjoint i32 %17, 4
  %19 = add i32 %18, %16
  %20 = inttoptr i32 %19 to ptr
  store volatile i32 %1, ptr %20, align 4, !tbaa !3
  br label %21

21:                                               ; preds = %2, %8, %10
  %22 = phi i32 [ 0, %10 ], [ -1, %8 ], [ -1, %2 ]
  ret i32 %22
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 1) i32 @kpio(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = load i32, ptr @pio0base, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %105, label %6

6:                                                ; preds = %3
  switch i32 %0, label %105 [
    i32 0, label %7
    i32 1, label %42
    i32 2, label %88
  ]

7:                                                ; preds = %6
  %8 = inttoptr i32 %1 to ptr
  %9 = load i32, ptr %8, align 4, !tbaa !7
  %10 = icmp ugt i32 %9, 2
  br i1 %10, label %105, label %11

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %13 = load i32, ptr %12, align 4, !tbaa !9
  %14 = icmp ugt i32 %13, 31
  br i1 %14, label %105, label %15

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %17 = load i32, ptr %16, align 4, !tbaa !10
  %18 = icmp ugt i32 %17, 32
  br i1 %18, label %105, label %19

19:                                               ; preds = %15
  %20 = add nuw nsw i32 %17, %13
  %21 = icmp samesign ugt i32 %20, 32
  br i1 %21, label %105, label %22

22:                                               ; preds = %19
  %23 = shl nuw nsw i32 %9, 20
  %24 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %25 = add i32 %4, 72
  %26 = add i32 %25, %23
  br label %27

27:                                               ; preds = %31, %22
  %28 = phi i32 [ %17, %22 ], [ %41, %31 ]
  %29 = phi i32 [ 0, %22 ], [ %40, %31 ]
  %30 = icmp ult i32 %29, %28
  br i1 %30, label %31, label %105

31:                                               ; preds = %27
  %32 = getelementptr inbounds nuw [32 x i32], ptr %24, i32 0, i32 %29
  %33 = load i32, ptr %32, align 4, !tbaa !3
  %34 = and i32 %33, 65535
  %35 = load i32, ptr %12, align 4, !tbaa !9
  %36 = add i32 %35, %29
  %37 = shl i32 %36, 2
  %38 = add i32 %26, %37
  %39 = inttoptr i32 %38 to ptr
  store volatile i32 %34, ptr %39, align 4, !tbaa !3
  %40 = add nuw i32 %29, 1
  %41 = load i32, ptr %16, align 4, !tbaa !10
  br label %27, !llvm.loop !11

42:                                               ; preds = %6
  %43 = inttoptr i32 %1 to ptr
  %44 = load i32, ptr %43, align 4, !tbaa !14
  %45 = icmp ugt i32 %44, 2
  br i1 %45, label %105, label %46

46:                                               ; preds = %42
  %47 = getelementptr inbounds nuw i8, ptr %43, i32 4
  %48 = load i32, ptr %47, align 4, !tbaa !16
  %49 = icmp ugt i32 %48, 3
  br i1 %49, label %105, label %50

50:                                               ; preds = %46
  %51 = getelementptr inbounds nuw i8, ptr %43, i32 8
  %52 = load i32, ptr %51, align 4, !tbaa !17
  %53 = icmp ugt i32 %52, 31
  br i1 %53, label %105, label %54

54:                                               ; preds = %50
  %55 = shl nuw nsw i32 %44, 20
  %56 = add i32 %55, %4
  %57 = add i32 %56, 200
  %58 = mul nuw nsw i32 %48, 24
  %59 = add i32 %57, %58
  %60 = shl nuw nsw i32 1, %48
  %61 = add i32 %56, 12288
  %62 = inttoptr i32 %61 to ptr
  store volatile i32 %60, ptr %62, align 4, !tbaa !3
  %63 = getelementptr inbounds nuw i8, ptr %43, i32 12
  %64 = load i32, ptr %63, align 4, !tbaa !18
  %65 = inttoptr i32 %59 to ptr
  store volatile i32 %64, ptr %65, align 4, !tbaa !3
  %66 = getelementptr inbounds nuw i8, ptr %43, i32 16
  %67 = load i32, ptr %66, align 4, !tbaa !19
  %68 = add i32 %59, 4
  %69 = inttoptr i32 %68 to ptr
  store volatile i32 %67, ptr %69, align 4, !tbaa !3
  %70 = getelementptr inbounds nuw i8, ptr %43, i32 20
  %71 = load i32, ptr %70, align 4, !tbaa !20
  %72 = add i32 %59, 8
  %73 = inttoptr i32 %72 to ptr
  store volatile i32 %71, ptr %73, align 4, !tbaa !3
  %74 = getelementptr inbounds nuw i8, ptr %43, i32 24
  %75 = load i32, ptr %74, align 4, !tbaa !21
  %76 = add i32 %59, 20
  %77 = inttoptr i32 %76 to ptr
  store volatile i32 %75, ptr %77, align 4, !tbaa !3
  %78 = load i32, ptr %47, align 4, !tbaa !16
  %79 = add i32 %78, 4
  %80 = shl nuw i32 1, %79
  %81 = add i32 %56, 8192
  %82 = inttoptr i32 %81 to ptr
  store volatile i32 %80, ptr %82, align 4, !tbaa !3
  %83 = load i32, ptr %47, align 4, !tbaa !16
  %84 = add i32 %83, 8
  %85 = shl nuw i32 1, %84
  store volatile i32 %85, ptr %82, align 4, !tbaa !3
  %86 = load i32, ptr %51, align 4, !tbaa !17
  %87 = add i32 %59, 16
  br label %101

88:                                               ; preds = %6
  %89 = and i32 %1, 255
  %90 = icmp ugt i32 %1, 767
  br i1 %90, label %105, label %91

91:                                               ; preds = %88
  %92 = icmp samesign ugt i32 %89, 3
  br i1 %92, label %105, label %93

93:                                               ; preds = %91
  %94 = shl nuw nsw i32 1, %89
  %95 = shl nuw nsw i32 %1, 12
  %96 = and i32 %95, 3145728
  %97 = icmp eq i32 %2, 0
  %98 = select i1 %97, i32 12288, i32 8192
  %99 = or disjoint i32 %98, %96
  %100 = add i32 %99, %4
  br label %101

101:                                              ; preds = %54, %93
  %102 = phi i32 [ %100, %93 ], [ %87, %54 ]
  %103 = phi i32 [ %94, %93 ], [ %86, %54 ]
  %104 = inttoptr i32 %102 to ptr
  store volatile i32 %103, ptr %104, align 4, !tbaa !3
  br label %105

105:                                              ; preds = %27, %101, %6, %91, %88, %50, %46, %42, %19, %15, %11, %7, %3
  %106 = phi i32 [ -1, %3 ], [ -1, %19 ], [ -1, %15 ], [ -1, %11 ], [ -1, %7 ], [ -1, %50 ], [ -1, %46 ], [ -1, %42 ], [ -1, %91 ], [ -1, %88 ], [ -1, %6 ], [ 0, %101 ], [ 0, %27 ]
  ret i32 %106
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local range(i32 0, 2) i32 @kgpio_peek(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i32, ptr @iobank0, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  %4 = load i32, ptr @gpiopins, align 4
  %5 = icmp uge i32 %0, %4
  %6 = select i1 %3, i1 true, i1 %5
  br i1 %6, label %14, label %7

7:                                                ; preds = %1
  %8 = shl i32 %0, 3
  %9 = add i32 %2, %8
  %10 = inttoptr i32 %9 to ptr
  %11 = load volatile i32, ptr %10, align 4, !tbaa !3
  %12 = lshr i32 %11, 17
  %13 = and i32 %12, 1
  br label %14

14:                                               ; preds = %1, %7
  %15 = phi i32 [ %13, %7 ], [ 0, %1 ]
  ret i32 %15
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local range(i32 0, 16) i32 @kpio_ctrl(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i32, ptr @pio0base, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %12, label %4

4:                                                ; preds = %1
  %5 = icmp ugt i32 %0, 2
  br i1 %5, label %12, label %6

6:                                                ; preds = %4
  %7 = shl nuw nsw i32 %0, 20
  %8 = add i32 %2, %7
  %9 = inttoptr i32 %8 to ptr
  %10 = load volatile i32, ptr %9, align 4, !tbaa !3
  %11 = and i32 %10, 15
  br label %12

12:                                               ; preds = %1, %4, %6
  %13 = phi i32 [ %11, %6 ], [ 0, %4 ], [ 0, %1 ]
  ret i32 %13
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !4, i64 0}
!8 = !{!"pio_prog", !4, i64 0, !4, i64 4, !4, i64 8, !5, i64 12}
!9 = !{!8, !4, i64 4}
!10 = !{!8, !4, i64 8}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = !{!15, !4, i64 0}
!15 = !{!"pio_smcfg", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16, !4, i64 20, !4, i64 24}
!16 = !{!15, !4, i64 4}
!17 = !{!15, !4, i64 8}
!18 = !{!15, !4, i64 12}
!19 = !{!15, !4, i64 16}
!20 = !{!15, !4, i64 20}
!21 = !{!15, !4, i64 24}
