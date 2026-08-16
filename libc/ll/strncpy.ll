; ModuleID = 'strncpy.c'
source_filename = "strncpy.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local noundef ptr @strncpy(ptr noalias noundef returned %0, ptr noalias noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = ptrtoint ptr %1 to i32
  %5 = ptrtoint ptr %0 to i32
  %6 = or i32 %4, %5
  %7 = and i32 %6, 3
  %8 = icmp ne i32 %7, 0
  %9 = icmp ult i32 %2, 4
  %10 = or i1 %9, %8
  br i1 %10, label %25, label %11

11:                                               ; preds = %3, %20
  %12 = phi ptr [ %22, %20 ], [ %1, %3 ]
  %13 = phi ptr [ %23, %20 ], [ %0, %3 ]
  %14 = phi i32 [ %21, %20 ], [ %2, %3 ]
  %15 = load i32, ptr %12, align 4, !tbaa !3
  %16 = sub i32 16843008, %15
  %17 = or i32 %16, %15
  %18 = and i32 %17, -2139062144
  %19 = icmp eq i32 %18, -2139062144
  br i1 %19, label %20, label %25

20:                                               ; preds = %11
  %21 = add i32 %14, -4
  %22 = getelementptr inbounds nuw i8, ptr %12, i32 4
  %23 = getelementptr inbounds nuw i8, ptr %13, i32 4
  store i32 %15, ptr %13, align 4, !tbaa !3
  %24 = icmp ult i32 %21, 4
  br i1 %24, label %25, label %11, !llvm.loop !7

25:                                               ; preds = %11, %20, %3
  %26 = phi i32 [ %2, %3 ], [ %14, %11 ], [ %21, %20 ]
  %27 = phi ptr [ %0, %3 ], [ %13, %11 ], [ %23, %20 ]
  %28 = phi ptr [ %1, %3 ], [ %12, %11 ], [ %22, %20 ]
  %29 = icmp eq i32 %26, 0
  br i1 %29, label %41, label %30

30:                                               ; preds = %25, %30
  %31 = phi i32 [ %34, %30 ], [ %26, %25 ]
  %32 = phi ptr [ %37, %30 ], [ %27, %25 ]
  %33 = phi ptr [ %35, %30 ], [ %28, %25 ]
  %34 = add i32 %31, -1
  %35 = getelementptr inbounds nuw i8, ptr %33, i32 1
  %36 = load i8, ptr %33, align 1, !tbaa !10
  %37 = getelementptr inbounds nuw i8, ptr %32, i32 1
  store i8 %36, ptr %32, align 1, !tbaa !10
  %38 = icmp ne i8 %36, 0
  %39 = icmp ne i32 %34, 0
  %40 = select i1 %38, i1 %39, i1 false
  br i1 %40, label %30, label %41, !llvm.loop !11

41:                                               ; preds = %30, %25
  %42 = phi i32 [ 0, %25 ], [ %34, %30 ]
  %43 = phi ptr [ %27, %25 ], [ %37, %30 ]
  %44 = icmp eq i32 %42, 0
  br i1 %44, label %51, label %45

45:                                               ; preds = %41, %45
  %46 = phi ptr [ %49, %45 ], [ %43, %41 ]
  %47 = phi i32 [ %48, %45 ], [ %42, %41 ]
  %48 = add i32 %47, -1
  %49 = getelementptr inbounds nuw i8, ptr %46, i32 1
  store i8 0, ptr %46, align 1, !tbaa !10
  %50 = icmp eq i32 %48, 0
  br i1 %50, label %51, label %45, !llvm.loop !12

51:                                               ; preds = %45, %41
  ret ptr %0
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
!12 = distinct !{!12, !8, !9}
