; ModuleID = 'strncmp.c'
source_filename = "strncmp.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @strncmp(ptr noundef %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %60, label %5

5:                                                ; preds = %3
  %6 = ptrtoint ptr %0 to i32
  %7 = ptrtoint ptr %1 to i32
  %8 = or i32 %7, %6
  %9 = and i32 %8, 3
  %10 = icmp eq i32 %9, 0
  %11 = icmp ugt i32 %2, 3
  %12 = and i1 %10, %11
  br i1 %12, label %13, label %32

13:                                               ; preds = %5, %28
  %14 = phi ptr [ %30, %28 ], [ %1, %5 ]
  %15 = phi ptr [ %29, %28 ], [ %0, %5 ]
  %16 = phi i32 [ %21, %28 ], [ %2, %5 ]
  %17 = load i32, ptr %15, align 4, !tbaa !3
  %18 = load i32, ptr %14, align 4, !tbaa !3
  %19 = icmp eq i32 %17, %18
  br i1 %19, label %20, label %32

20:                                               ; preds = %13
  %21 = add i32 %16, -4
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %60, label %23

23:                                               ; preds = %20
  %24 = sub i32 16843008, %17
  %25 = or i32 %24, %17
  %26 = and i32 %25, -2139062144
  %27 = icmp eq i32 %26, -2139062144
  br i1 %27, label %28, label %60

28:                                               ; preds = %23
  %29 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %30 = getelementptr inbounds nuw i8, ptr %14, i32 4
  %31 = icmp ugt i32 %21, 3
  br i1 %31, label %13, label %32, !llvm.loop !7

32:                                               ; preds = %28, %13, %5
  %33 = phi ptr [ %0, %5 ], [ %15, %13 ], [ %29, %28 ]
  %34 = phi ptr [ %1, %5 ], [ %14, %13 ], [ %30, %28 ]
  %35 = phi i32 [ %2, %5 ], [ %16, %13 ], [ %21, %28 ]
  %36 = load i8, ptr %33, align 1, !tbaa !10
  %37 = load i8, ptr %34, align 1, !tbaa !10
  %38 = icmp eq i8 %36, %37
  br i1 %38, label %39, label %54

39:                                               ; preds = %32, %48
  %40 = phi i8 [ %51, %48 ], [ %36, %32 ]
  %41 = phi i32 [ %44, %48 ], [ %35, %32 ]
  %42 = phi ptr [ %50, %48 ], [ %34, %32 ]
  %43 = phi ptr [ %49, %48 ], [ %33, %32 ]
  %44 = add i32 %41, -1
  %45 = icmp eq i32 %44, 0
  %46 = icmp eq i8 %40, 0
  %47 = or i1 %45, %46
  br i1 %47, label %60, label %48

48:                                               ; preds = %39
  %49 = getelementptr inbounds nuw i8, ptr %43, i32 1
  %50 = getelementptr inbounds nuw i8, ptr %42, i32 1
  %51 = load i8, ptr %49, align 1, !tbaa !10
  %52 = load i8, ptr %50, align 1, !tbaa !10
  %53 = icmp eq i8 %51, %52
  br i1 %53, label %39, label %54, !llvm.loop !11

54:                                               ; preds = %48, %32
  %55 = phi i8 [ %36, %32 ], [ %51, %48 ]
  %56 = phi i8 [ %37, %32 ], [ %52, %48 ]
  %57 = zext i8 %55 to i32
  %58 = zext i8 %56 to i32
  %59 = sub nsw i32 %57, %58
  br label %60

60:                                               ; preds = %20, %23, %39, %3, %54
  %61 = phi i32 [ %59, %54 ], [ 0, %3 ], [ 0, %39 ], [ 0, %23 ], [ 0, %20 ]
  ret i32 %61
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
