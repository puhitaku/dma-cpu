; ModuleID = 'kernel/string.c'
source_filename = "kernel/string.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local noundef ptr @memset(ptr noundef returned %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = trunc i32 %1 to i8
  br label %5

5:                                                ; preds = %13, %3
  %6 = phi i32 [ %2, %3 ], [ %15, %13 ]
  %7 = phi ptr [ %0, %3 ], [ %14, %13 ]
  %8 = icmp ne i32 %6, 0
  %9 = ptrtoint ptr %7 to i32
  %10 = and i32 %9, 3
  %11 = icmp ne i32 %10, 0
  %12 = select i1 %8, i1 %11, i1 false
  br i1 %12, label %13, label %16

13:                                               ; preds = %5
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 1
  store i8 %4, ptr %7, align 1, !tbaa !3
  %15 = add i32 %6, -1
  br label %5, !llvm.loop !6

16:                                               ; preds = %5
  %17 = and i32 %1, 255
  %18 = mul nuw i32 %17, 16843009
  br label %19

19:                                               ; preds = %23, %16
  %20 = phi i32 [ %6, %16 ], [ %25, %23 ]
  %21 = phi ptr [ %7, %16 ], [ %24, %23 ]
  %22 = icmp ugt i32 %20, 3
  br i1 %22, label %23, label %26

23:                                               ; preds = %19
  store i32 %18, ptr %21, align 4, !tbaa !9
  %24 = getelementptr inbounds nuw i8, ptr %21, i32 4
  %25 = add i32 %20, -4
  br label %19, !llvm.loop !11

26:                                               ; preds = %19, %30
  %27 = phi i32 [ %31, %30 ], [ %20, %19 ]
  %28 = phi ptr [ %32, %30 ], [ %21, %19 ]
  %29 = icmp eq i32 %27, 0
  br i1 %29, label %33, label %30

30:                                               ; preds = %26
  %31 = add i32 %27, -1
  %32 = getelementptr inbounds nuw i8, ptr %28, i32 1
  store i8 %4, ptr %28, align 1, !tbaa !3
  br label %26, !llvm.loop !12

33:                                               ; preds = %26
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @memcmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #1 {
  br label %4

4:                                                ; preds = %18, %3
  %5 = phi i32 [ %2, %3 ], [ %8, %18 ]
  %6 = phi ptr [ %0, %3 ], [ %19, %18 ]
  %7 = phi ptr [ %1, %3 ], [ %20, %18 ]
  %8 = add i32 %5, -1
  %9 = icmp eq i32 %5, 0
  br i1 %9, label %21, label %10

10:                                               ; preds = %4
  %11 = load i8, ptr %6, align 1, !tbaa !3
  %12 = load i8, ptr %7, align 1, !tbaa !3
  %13 = icmp eq i8 %11, %12
  br i1 %13, label %18, label %14

14:                                               ; preds = %10
  %15 = zext i8 %12 to i32
  %16 = zext i8 %11 to i32
  %17 = sub nsw i32 %16, %15
  br label %21

18:                                               ; preds = %10
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %20 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %4, !llvm.loop !13

21:                                               ; preds = %4, %14
  %22 = phi i32 [ %17, %14 ], [ 0, %4 ]
  ret i32 %22
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memmove(ptr noundef returned %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #2 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %99, label %5

5:                                                ; preds = %3
  %6 = icmp ult ptr %1, %0
  br i1 %6, label %7, label %55

7:                                                ; preds = %5
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 %2
  %9 = icmp ugt ptr %8, %0
  br i1 %9, label %10, label %55

10:                                               ; preds = %7
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 %2
  %12 = ptrtoint ptr %8 to i32
  %13 = ptrtoint ptr %11 to i32
  %14 = xor i32 %12, %13
  %15 = and i32 %14, 3
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %21, label %17

17:                                               ; preds = %35, %10
  %18 = phi i32 [ %2, %10 ], [ %36, %35 ]
  %19 = phi ptr [ %8, %10 ], [ %37, %35 ]
  %20 = phi ptr [ %11, %10 ], [ %38, %35 ]
  br label %45

21:                                               ; preds = %10, %30
  %22 = phi i32 [ %34, %30 ], [ %2, %10 ]
  %23 = phi ptr [ %31, %30 ], [ %8, %10 ]
  %24 = phi ptr [ %33, %30 ], [ %11, %10 ]
  %25 = icmp ne i32 %22, 0
  %26 = ptrtoint ptr %24 to i32
  %27 = and i32 %26, 3
  %28 = icmp ne i32 %27, 0
  %29 = and i1 %25, %28
  br i1 %29, label %30, label %35

30:                                               ; preds = %21
  %31 = getelementptr inbounds i8, ptr %23, i32 -1
  %32 = load i8, ptr %31, align 1, !tbaa !3
  %33 = getelementptr inbounds i8, ptr %24, i32 -1
  store i8 %32, ptr %33, align 1, !tbaa !3
  %34 = add i32 %22, -1
  br label %21, !llvm.loop !14

35:                                               ; preds = %21, %40
  %36 = phi i32 [ %44, %40 ], [ %22, %21 ]
  %37 = phi ptr [ %42, %40 ], [ %23, %21 ]
  %38 = phi ptr [ %41, %40 ], [ %24, %21 ]
  %39 = icmp ugt i32 %36, 3
  br i1 %39, label %40, label %17

40:                                               ; preds = %35
  %41 = getelementptr inbounds i8, ptr %38, i32 -4
  %42 = getelementptr inbounds i8, ptr %37, i32 -4
  %43 = load i32, ptr %42, align 4, !tbaa !9
  store i32 %43, ptr %41, align 4, !tbaa !9
  %44 = add i32 %36, -4
  br label %35, !llvm.loop !15

45:                                               ; preds = %17, %50
  %46 = phi i32 [ %51, %50 ], [ %18, %17 ]
  %47 = phi ptr [ %52, %50 ], [ %19, %17 ]
  %48 = phi ptr [ %54, %50 ], [ %20, %17 ]
  %49 = icmp eq i32 %46, 0
  br i1 %49, label %99, label %50

50:                                               ; preds = %45
  %51 = add i32 %46, -1
  %52 = getelementptr inbounds i8, ptr %47, i32 -1
  %53 = load i8, ptr %52, align 1, !tbaa !3
  %54 = getelementptr inbounds i8, ptr %48, i32 -1
  store i8 %53, ptr %54, align 1, !tbaa !3
  br label %45, !llvm.loop !16

55:                                               ; preds = %7, %5
  %56 = ptrtoint ptr %1 to i32
  %57 = ptrtoint ptr %0 to i32
  %58 = xor i32 %56, %57
  %59 = and i32 %58, 3
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %65, label %61

61:                                               ; preds = %79, %55
  %62 = phi i32 [ %2, %55 ], [ %80, %79 ]
  %63 = phi ptr [ %1, %55 ], [ %81, %79 ]
  %64 = phi ptr [ %0, %55 ], [ %82, %79 ]
  br label %89

65:                                               ; preds = %55, %74
  %66 = phi i32 [ %78, %74 ], [ %2, %55 ]
  %67 = phi ptr [ %75, %74 ], [ %1, %55 ]
  %68 = phi ptr [ %77, %74 ], [ %0, %55 ]
  %69 = icmp ne i32 %66, 0
  %70 = ptrtoint ptr %68 to i32
  %71 = and i32 %70, 3
  %72 = icmp ne i32 %71, 0
  %73 = select i1 %69, i1 %72, i1 false
  br i1 %73, label %74, label %79

74:                                               ; preds = %65
  %75 = getelementptr inbounds nuw i8, ptr %67, i32 1
  %76 = load i8, ptr %67, align 1, !tbaa !3
  %77 = getelementptr inbounds nuw i8, ptr %68, i32 1
  store i8 %76, ptr %68, align 1, !tbaa !3
  %78 = add i32 %66, -1
  br label %65, !llvm.loop !17

79:                                               ; preds = %65, %84
  %80 = phi i32 [ %88, %84 ], [ %66, %65 ]
  %81 = phi ptr [ %87, %84 ], [ %67, %65 ]
  %82 = phi ptr [ %86, %84 ], [ %68, %65 ]
  %83 = icmp ugt i32 %80, 3
  br i1 %83, label %84, label %61

84:                                               ; preds = %79
  %85 = load i32, ptr %81, align 4, !tbaa !9
  store i32 %85, ptr %82, align 4, !tbaa !9
  %86 = getelementptr inbounds nuw i8, ptr %82, i32 4
  %87 = getelementptr inbounds nuw i8, ptr %81, i32 4
  %88 = add i32 %80, -4
  br label %79, !llvm.loop !18

89:                                               ; preds = %61, %94
  %90 = phi i32 [ %95, %94 ], [ %62, %61 ]
  %91 = phi ptr [ %96, %94 ], [ %63, %61 ]
  %92 = phi ptr [ %98, %94 ], [ %64, %61 ]
  %93 = icmp eq i32 %90, 0
  br i1 %93, label %99, label %94

94:                                               ; preds = %89
  %95 = add i32 %90, -1
  %96 = getelementptr inbounds nuw i8, ptr %91, i32 1
  %97 = load i8, ptr %91, align 1, !tbaa !3
  %98 = getelementptr inbounds nuw i8, ptr %92, i32 1
  store i8 %97, ptr %92, align 1, !tbaa !3
  br label %89, !llvm.loop !19

99:                                               ; preds = %89, %45, %3
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memcpy(ptr noundef returned %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #2 {
  %4 = tail call ptr @memmove(ptr noundef %0, ptr noundef %1, i32 noundef %2) #3
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @strncmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #1 {
  br label %4

4:                                                ; preds = %15, %3
  %5 = phi ptr [ %0, %3 ], [ %17, %15 ]
  %6 = phi ptr [ %1, %3 ], [ %18, %15 ]
  %7 = phi i32 [ %2, %3 ], [ %16, %15 ]
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %23, label %9

9:                                                ; preds = %4
  %10 = load i8, ptr %5, align 1, !tbaa !3
  %11 = icmp ne i8 %10, 0
  %12 = load i8, ptr %6, align 1, !tbaa !3
  %13 = icmp eq i8 %10, %12
  %14 = select i1 %11, i1 %13, i1 false
  br i1 %14, label %15, label %19

15:                                               ; preds = %9
  %16 = add i32 %7, -1
  %17 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %18 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %4, !llvm.loop !20

19:                                               ; preds = %9
  %20 = zext i8 %10 to i32
  %21 = zext i8 %12 to i32
  %22 = sub nsw i32 %20, %21
  br label %23

23:                                               ; preds = %4, %19
  %24 = phi i32 [ %22, %19 ], [ 0, %4 ]
  ret i32 %24
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @strncpy(ptr noundef returned writeonly captures(ret: address, provenance) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #2 {
  br label %4

4:                                                ; preds = %10, %3
  %5 = phi ptr [ %1, %3 ], [ %11, %10 ]
  %6 = phi i32 [ %2, %3 ], [ %8, %10 ]
  %7 = phi ptr [ %0, %3 ], [ %13, %10 ]
  %8 = add nsw i32 %6, -1
  %9 = icmp sgt i32 %6, 0
  br i1 %9, label %10, label %15

10:                                               ; preds = %4
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %12 = load i8, ptr %5, align 1, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %7, i32 1
  store i8 %12, ptr %7, align 1, !tbaa !3
  %14 = icmp eq i8 %12, 0
  br i1 %14, label %15, label %4, !llvm.loop !21

15:                                               ; preds = %4, %10
  %16 = phi ptr [ %13, %10 ], [ %7, %4 ]
  br label %17

17:                                               ; preds = %15, %21
  %18 = phi i32 [ %22, %21 ], [ %8, %15 ]
  %19 = phi ptr [ %23, %21 ], [ %16, %15 ]
  %20 = icmp sgt i32 %18, 0
  br i1 %20, label %21, label %24

21:                                               ; preds = %17
  %22 = add nsw i32 %18, -1
  %23 = getelementptr inbounds nuw i8, ptr %19, i32 1
  store i8 0, ptr %19, align 1, !tbaa !3
  br label %17, !llvm.loop !22

24:                                               ; preds = %17
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @safestrcpy(ptr noundef returned writeonly captures(ret: address, provenance) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #2 {
  %4 = icmp slt i32 %2, 1
  br i1 %4, label %18, label %5

5:                                                ; preds = %3, %10
  %6 = phi ptr [ %14, %10 ], [ %0, %3 ]
  %7 = phi ptr [ %12, %10 ], [ %1, %3 ]
  %8 = phi i32 [ %11, %10 ], [ %2, %3 ]
  %9 = icmp sgt i32 %8, 1
  br i1 %9, label %10, label %16

10:                                               ; preds = %5
  %11 = add nsw i32 %8, -1
  %12 = getelementptr inbounds nuw i8, ptr %7, i32 1
  %13 = load i8, ptr %7, align 1, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %6, i32 1
  store i8 %13, ptr %6, align 1, !tbaa !3
  %15 = icmp eq i8 %13, 0
  br i1 %15, label %16, label %5, !llvm.loop !23

16:                                               ; preds = %5, %10
  %17 = phi ptr [ %14, %10 ], [ %6, %5 ]
  store i8 0, ptr %17, align 1, !tbaa !3
  br label %18

18:                                               ; preds = %3, %16
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local i32 @strlen(ptr noundef readonly captures(none) %0) local_unnamed_addr #1 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  %7 = add nuw nsw i32 %3, 1
  br i1 %6, label %8, label %2, !llvm.loop !24

8:                                                ; preds = %2
  ret i32 %3
}

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nobuiltin optsize "no-builtins" }

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
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !4, i64 0}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !7, !8}
!17 = distinct !{!17, !7, !8}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !7, !8}
!23 = distinct !{!23, !7, !8}
!24 = distinct !{!24, !7, !8}
