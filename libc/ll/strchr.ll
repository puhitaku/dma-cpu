; ModuleID = 'strchr.c'
source_filename = "strchr.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local ptr @strchr(ptr noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = and i32 %1, 255
  %4 = icmp eq i32 %3, 0
  %5 = ptrtoint ptr %0 to i32
  %6 = and i32 %5, 3
  %7 = icmp eq i32 %6, 0
  br i1 %4, label %11, label %8

8:                                                ; preds = %2
  br i1 %7, label %36, label %9

9:                                                ; preds = %8
  %10 = trunc i32 %1 to i8
  br label %38

11:                                               ; preds = %2
  br i1 %7, label %21, label %12

12:                                               ; preds = %11, %16
  %13 = phi ptr [ %17, %16 ], [ %0, %11 ]
  %14 = load i8, ptr %13, align 1, !tbaa !3
  %15 = icmp eq i8 %14, 0
  br i1 %15, label %89, label %16

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw i8, ptr %13, i32 1
  %18 = ptrtoint ptr %17 to i32
  %19 = and i32 %18, 3
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %12, !llvm.loop !6

21:                                               ; preds = %16, %11
  %22 = phi ptr [ %0, %11 ], [ %17, %16 ]
  br label %23

23:                                               ; preds = %21, %23
  %24 = phi ptr [ %30, %23 ], [ %22, %21 ]
  %25 = load i32, ptr %24, align 4, !tbaa !9
  %26 = sub i32 16843008, %25
  %27 = or i32 %26, %25
  %28 = and i32 %27, -2139062144
  %29 = icmp eq i32 %28, -2139062144
  %30 = getelementptr inbounds nuw i8, ptr %24, i32 4
  br i1 %29, label %23, label %31, !llvm.loop !11

31:                                               ; preds = %23, %31
  %32 = phi ptr [ %35, %31 ], [ %24, %23 ]
  %33 = load i8, ptr %32, align 1, !tbaa !3
  %34 = icmp eq i8 %33, 0
  %35 = getelementptr inbounds nuw i8, ptr %32, i32 1
  br i1 %34, label %89, label %31, !llvm.loop !12

36:                                               ; preds = %44, %8
  %37 = phi ptr [ %0, %8 ], [ %45, %44 ]
  br label %55

38:                                               ; preds = %9, %44
  %39 = phi ptr [ %0, %9 ], [ %45, %44 ]
  %40 = load i8, ptr %39, align 1, !tbaa !3
  %41 = icmp eq i8 %40, 0
  br i1 %41, label %89, label %42

42:                                               ; preds = %38
  %43 = icmp eq i8 %40, %10
  br i1 %43, label %89, label %44

44:                                               ; preds = %42
  %45 = getelementptr inbounds nuw i8, ptr %39, i32 1
  %46 = ptrtoint ptr %45 to i32
  %47 = and i32 %46, 3
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %36, label %38, !llvm.loop !13

49:                                               ; preds = %55
  %50 = load i32, ptr %37, align 4, !tbaa !9
  %51 = sub i32 16843008, %50
  %52 = or i32 %51, %50
  %53 = and i32 %52, -2139062144
  %54 = icmp eq i32 %53, -2139062144
  br i1 %54, label %62, label %77

55:                                               ; preds = %36, %55
  %56 = phi i32 [ 8, %36 ], [ %60, %55 ]
  %57 = phi i32 [ %3, %36 ], [ %59, %55 ]
  %58 = shl i32 %57, %56
  %59 = or i32 %58, %57
  %60 = shl nuw nsw i32 %56, 1
  %61 = icmp ult i32 %56, 16
  br i1 %61, label %55, label %49, !llvm.loop !14

62:                                               ; preds = %49, %70
  %63 = phi i32 [ %72, %70 ], [ %50, %49 ]
  %64 = phi ptr [ %71, %70 ], [ %37, %49 ]
  %65 = xor i32 %63, %59
  %66 = sub i32 16843008, %65
  %67 = or i32 %66, %65
  %68 = and i32 %67, -2139062144
  %69 = icmp eq i32 %68, -2139062144
  br i1 %69, label %70, label %77

70:                                               ; preds = %62
  %71 = getelementptr inbounds nuw i8, ptr %64, i32 4
  %72 = load i32, ptr %71, align 4, !tbaa !9
  %73 = sub i32 16843008, %72
  %74 = or i32 %73, %72
  %75 = and i32 %74, -2139062144
  %76 = icmp eq i32 %75, -2139062144
  br i1 %76, label %62, label %77, !llvm.loop !15

77:                                               ; preds = %62, %70, %49
  %78 = phi ptr [ %37, %49 ], [ %64, %62 ], [ %71, %70 ]
  %79 = trunc i32 %1 to i8
  br label %80

80:                                               ; preds = %80, %77
  %81 = phi ptr [ %78, %77 ], [ %86, %80 ]
  %82 = load i8, ptr %81, align 1, !tbaa !3
  %83 = icmp eq i8 %82, 0
  %84 = icmp eq i8 %82, %79
  %85 = or i1 %83, %84
  %86 = getelementptr inbounds nuw i8, ptr %81, i32 1
  br i1 %85, label %87, label %80, !llvm.loop !16

87:                                               ; preds = %80
  %88 = select i1 %84, ptr %81, ptr null
  br label %89

89:                                               ; preds = %42, %38, %12, %31, %87
  %90 = phi ptr [ %88, %87 ], [ %32, %31 ], [ %13, %12 ], [ null, %38 ], [ %39, %42 ]
  ret ptr %90
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
!10 = !{!"long", !4, i64 0}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !7, !8}
