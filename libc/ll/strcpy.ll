; ModuleID = 'strcpy.c'
source_filename = "strcpy.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local noundef ptr @strcpy(ptr noundef returned %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = ptrtoint ptr %1 to i32
  %4 = ptrtoint ptr %0 to i32
  %5 = or i32 %3, %4
  %6 = and i32 %5, 3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %25

8:                                                ; preds = %2
  %9 = load i32, ptr %1, align 4, !tbaa !3
  %10 = sub i32 16843008, %9
  %11 = or i32 %10, %9
  %12 = and i32 %11, -2139062144
  %13 = icmp eq i32 %12, -2139062144
  br i1 %13, label %14, label %25

14:                                               ; preds = %8, %14
  %15 = phi i32 [ %20, %14 ], [ %9, %8 ]
  %16 = phi ptr [ %18, %14 ], [ %1, %8 ]
  %17 = phi ptr [ %19, %14 ], [ %0, %8 ]
  %18 = getelementptr inbounds nuw i8, ptr %16, i32 4
  %19 = getelementptr inbounds nuw i8, ptr %17, i32 4
  store i32 %15, ptr %17, align 4, !tbaa !3
  %20 = load i32, ptr %18, align 4, !tbaa !3
  %21 = sub i32 16843008, %20
  %22 = or i32 %21, %20
  %23 = and i32 %22, -2139062144
  %24 = icmp eq i32 %23, -2139062144
  br i1 %24, label %14, label %25, !llvm.loop !7

25:                                               ; preds = %14, %8, %2
  %26 = phi ptr [ %0, %8 ], [ %0, %2 ], [ %19, %14 ]
  %27 = phi ptr [ %1, %8 ], [ %1, %2 ], [ %18, %14 ]
  br label %28

28:                                               ; preds = %25, %28
  %29 = phi ptr [ %33, %28 ], [ %26, %25 ]
  %30 = phi ptr [ %31, %28 ], [ %27, %25 ]
  %31 = getelementptr inbounds nuw i8, ptr %30, i32 1
  %32 = load i8, ptr %30, align 1, !tbaa !10
  %33 = getelementptr inbounds nuw i8, ptr %29, i32 1
  store i8 %32, ptr %29, align 1, !tbaa !10
  %34 = icmp eq i8 %32, 0
  br i1 %34, label %35, label %28, !llvm.loop !11

35:                                               ; preds = %28
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
