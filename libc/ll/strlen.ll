; ModuleID = 'strlen.c'
source_filename = "strlen.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @strlen(ptr noundef %0) local_unnamed_addr #0 {
  %2 = ptrtoint ptr %0 to i32
  %3 = and i32 %2, 3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %17, label %5

5:                                                ; preds = %1
  %6 = load i8, ptr %0, align 1, !tbaa !3
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %34, label %11

8:                                                ; preds = %11
  %9 = load i8, ptr %13, align 1, !tbaa !3
  %10 = icmp eq i8 %9, 0
  br i1 %10, label %34, label %11, !llvm.loop !6

11:                                               ; preds = %5, %8
  %12 = phi ptr [ %13, %8 ], [ %0, %5 ]
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 1
  %14 = ptrtoint ptr %13 to i32
  %15 = and i32 %14, 3
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %8, !llvm.loop !6

17:                                               ; preds = %11, %1
  %18 = phi ptr [ %0, %1 ], [ %13, %11 ]
  br label %19

19:                                               ; preds = %17, %19
  %20 = phi ptr [ %26, %19 ], [ %18, %17 ]
  %21 = load i32, ptr %20, align 4, !tbaa !9
  %22 = sub i32 16843008, %21
  %23 = or i32 %22, %21
  %24 = and i32 %23, -2139062144
  %25 = icmp eq i32 %24, -2139062144
  %26 = getelementptr inbounds nuw i8, ptr %20, i32 4
  br i1 %25, label %19, label %27, !llvm.loop !11

27:                                               ; preds = %19, %27
  %28 = phi ptr [ %31, %27 ], [ %20, %19 ]
  %29 = load i8, ptr %28, align 1, !tbaa !3
  %30 = icmp eq i8 %29, 0
  %31 = getelementptr inbounds nuw i8, ptr %28, i32 1
  br i1 %30, label %32, label %27, !llvm.loop !12

32:                                               ; preds = %27
  %33 = ptrtoint ptr %28 to i32
  br label %34

34:                                               ; preds = %8, %5, %32
  %35 = phi i32 [ %33, %32 ], [ %2, %5 ], [ %14, %8 ]
  %36 = sub i32 %35, %2
  ret i32 %36
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
