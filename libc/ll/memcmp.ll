; ModuleID = 'memcmp.c'
source_filename = "memcmp.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @memcmp(ptr noundef %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp ult i32 %2, 4
  br i1 %4, label %23, label %5

5:                                                ; preds = %3
  %6 = ptrtoint ptr %0 to i32
  %7 = ptrtoint ptr %1 to i32
  %8 = or i32 %7, %6
  %9 = and i32 %8, 3
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %23

11:                                               ; preds = %5, %18
  %12 = phi ptr [ %20, %18 ], [ %1, %5 ]
  %13 = phi ptr [ %19, %18 ], [ %0, %5 ]
  %14 = phi i32 [ %21, %18 ], [ %2, %5 ]
  %15 = load i32, ptr %13, align 4, !tbaa !3
  %16 = load i32, ptr %12, align 4, !tbaa !3
  %17 = icmp eq i32 %15, %16
  br i1 %17, label %18, label %23

18:                                               ; preds = %11
  %19 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %20 = getelementptr inbounds nuw i8, ptr %12, i32 4
  %21 = add i32 %14, -4
  %22 = icmp ugt i32 %21, 3
  br i1 %22, label %11, label %23, !llvm.loop !7

23:                                               ; preds = %11, %18, %5, %3
  %24 = phi i32 [ %2, %3 ], [ %2, %5 ], [ %21, %18 ], [ %14, %11 ]
  %25 = phi ptr [ %0, %3 ], [ %0, %5 ], [ %19, %18 ], [ %13, %11 ]
  %26 = phi ptr [ %1, %3 ], [ %1, %5 ], [ %20, %18 ], [ %12, %11 ]
  %27 = icmp eq i32 %24, 0
  br i1 %27, label %44, label %28

28:                                               ; preds = %23, %39
  %29 = phi i32 [ %40, %39 ], [ %24, %23 ]
  %30 = phi ptr [ %42, %39 ], [ %26, %23 ]
  %31 = phi ptr [ %41, %39 ], [ %25, %23 ]
  %32 = load i8, ptr %31, align 1, !tbaa !10
  %33 = load i8, ptr %30, align 1, !tbaa !10
  %34 = icmp eq i8 %32, %33
  br i1 %34, label %39, label %35

35:                                               ; preds = %28
  %36 = zext i8 %33 to i32
  %37 = zext i8 %32 to i32
  %38 = sub nsw i32 %37, %36
  br label %44

39:                                               ; preds = %28
  %40 = add i32 %29, -1
  %41 = getelementptr inbounds nuw i8, ptr %31, i32 1
  %42 = getelementptr inbounds nuw i8, ptr %30, i32 1
  %43 = icmp eq i32 %40, 0
  br i1 %43, label %44, label %28, !llvm.loop !11

44:                                               ; preds = %39, %23, %35
  %45 = phi i32 [ %38, %35 ], [ 0, %23 ], [ 0, %39 ]
  ret i32 %45
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"long", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = !{!5, !5, i64 0}
!11 = distinct !{!11, !8, !9}
