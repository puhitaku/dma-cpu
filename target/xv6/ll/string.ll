; ModuleID = 'kernel/string.c'
source_filename = "kernel/string.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local noundef ptr @memset(ptr noundef returned writeonly captures(ret: address, provenance) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = trunc i32 %1 to i8
  br label %5

5:                                                ; preds = %8, %3
  %6 = phi i32 [ 0, %3 ], [ %10, %8 ]
  %7 = icmp eq i32 %6, %2
  br i1 %7, label %11, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 %6
  store i8 %4, ptr %9, align 1, !tbaa !3
  %10 = add nuw i32 %6, 1
  br label %5, !llvm.loop !6

11:                                               ; preds = %5
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
  br label %4, !llvm.loop !9

21:                                               ; preds = %4, %14
  %22 = phi i32 [ %17, %14 ], [ 0, %4 ]
  ret i32 %22
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memmove(ptr noundef returned writeonly captures(address, ret: address, provenance) %0, ptr noundef readonly captures(address) %1, i32 noundef %2) local_unnamed_addr #2 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %33, label %5

5:                                                ; preds = %3
  %6 = icmp ult ptr %1, %0
  br i1 %6, label %8, label %7

7:                                                ; preds = %8, %5
  br label %23

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 %2
  %10 = icmp ugt ptr %9, %0
  br i1 %10, label %11, label %7

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i8, ptr %0, i32 %2
  br label %13

13:                                               ; preds = %18, %11
  %14 = phi i32 [ %2, %11 ], [ %19, %18 ]
  %15 = phi ptr [ %9, %11 ], [ %20, %18 ]
  %16 = phi ptr [ %12, %11 ], [ %22, %18 ]
  %17 = icmp eq i32 %14, 0
  br i1 %17, label %33, label %18

18:                                               ; preds = %13
  %19 = add i32 %14, -1
  %20 = getelementptr inbounds i8, ptr %15, i32 -1
  %21 = load i8, ptr %20, align 1, !tbaa !3
  %22 = getelementptr inbounds i8, ptr %16, i32 -1
  store i8 %21, ptr %22, align 1, !tbaa !3
  br label %13, !llvm.loop !10

23:                                               ; preds = %7, %28
  %24 = phi i32 [ %29, %28 ], [ %2, %7 ]
  %25 = phi ptr [ %30, %28 ], [ %1, %7 ]
  %26 = phi ptr [ %32, %28 ], [ %0, %7 ]
  %27 = icmp eq i32 %24, 0
  br i1 %27, label %33, label %28

28:                                               ; preds = %23
  %29 = add i32 %24, -1
  %30 = getelementptr inbounds nuw i8, ptr %25, i32 1
  %31 = load i8, ptr %25, align 1, !tbaa !3
  %32 = getelementptr inbounds nuw i8, ptr %26, i32 1
  store i8 %31, ptr %26, align 1, !tbaa !3
  br label %23, !llvm.loop !11

33:                                               ; preds = %23, %13, %3
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memcpy(ptr noundef returned captures(address, ret: address, provenance) %0, ptr noundef readonly captures(address) %1, i32 noundef %2) local_unnamed_addr #2 {
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
  br label %4, !llvm.loop !12

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
  br i1 %14, label %15, label %4, !llvm.loop !13

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
  br label %17, !llvm.loop !14

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
  br i1 %15, label %16, label %5, !llvm.loop !15

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
  br i1 %6, label %8, label %2, !llvm.loop !16

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
!9 = distinct !{!9, !7, !8}
!10 = distinct !{!10, !7, !8}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !7, !8}
