; ModuleID = 'strcmp.c'
source_filename = "strcmp.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @strcmp(ptr noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = ptrtoint ptr %0 to i32
  %4 = ptrtoint ptr %1 to i32
  %5 = or i32 %4, %3
  %6 = and i32 %5, 3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %26

8:                                                ; preds = %2
  %9 = load i32, ptr %0, align 4, !tbaa !3
  %10 = load i32, ptr %1, align 4, !tbaa !3
  %11 = icmp eq i32 %9, %10
  br i1 %11, label %12, label %26

12:                                               ; preds = %8, %20
  %13 = phi i32 [ %23, %20 ], [ %9, %8 ]
  %14 = phi ptr [ %22, %20 ], [ %1, %8 ]
  %15 = phi ptr [ %21, %20 ], [ %0, %8 ]
  %16 = sub i32 16843008, %13
  %17 = or i32 %16, %13
  %18 = and i32 %17, -2139062144
  %19 = icmp eq i32 %18, -2139062144
  br i1 %19, label %20, label %49

20:                                               ; preds = %12
  %21 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %22 = getelementptr inbounds nuw i8, ptr %14, i32 4
  %23 = load i32, ptr %21, align 4, !tbaa !3
  %24 = load i32, ptr %22, align 4, !tbaa !3
  %25 = icmp eq i32 %23, %24
  br i1 %25, label %12, label %26, !llvm.loop !7

26:                                               ; preds = %20, %8, %2
  %27 = phi ptr [ %0, %2 ], [ %0, %8 ], [ %21, %20 ]
  %28 = phi ptr [ %1, %2 ], [ %1, %8 ], [ %22, %20 ]
  %29 = load i8, ptr %27, align 1, !tbaa !10
  %30 = icmp eq i8 %29, 0
  br i1 %30, label %42, label %31

31:                                               ; preds = %26, %37
  %32 = phi i8 [ %40, %37 ], [ %29, %26 ]
  %33 = phi ptr [ %39, %37 ], [ %28, %26 ]
  %34 = phi ptr [ %38, %37 ], [ %27, %26 ]
  %35 = load i8, ptr %33, align 1, !tbaa !10
  %36 = icmp eq i8 %32, %35
  br i1 %36, label %37, label %42

37:                                               ; preds = %31
  %38 = getelementptr inbounds nuw i8, ptr %34, i32 1
  %39 = getelementptr inbounds nuw i8, ptr %33, i32 1
  %40 = load i8, ptr %38, align 1, !tbaa !10
  %41 = icmp eq i8 %40, 0
  br i1 %41, label %42, label %31, !llvm.loop !11

42:                                               ; preds = %31, %37, %26
  %43 = phi ptr [ %28, %26 ], [ %33, %31 ], [ %39, %37 ]
  %44 = phi i8 [ %29, %26 ], [ %32, %31 ], [ %40, %37 ]
  %45 = zext i8 %44 to i32
  %46 = load i8, ptr %43, align 1, !tbaa !10
  %47 = zext i8 %46 to i32
  %48 = sub nsw i32 %45, %47
  br label %49

49:                                               ; preds = %12, %42
  %50 = phi i32 [ %48, %42 ], [ 0, %12 ]
  ret i32 %50
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
