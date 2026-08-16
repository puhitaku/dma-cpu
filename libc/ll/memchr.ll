; ModuleID = 'memchr.c'
source_filename = "memchr.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local ptr @memchr(ptr noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = ptrtoint ptr %0 to i32
  %5 = and i32 %4, 3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %22, label %7

7:                                                ; preds = %3
  %8 = trunc i32 %1 to i8
  br label %9

9:                                                ; preds = %7, %17
  %10 = phi ptr [ %0, %7 ], [ %18, %17 ]
  %11 = phi i32 [ %2, %7 ], [ %12, %17 ]
  %12 = add i32 %11, -1
  %13 = icmp eq i32 %11, 0
  br i1 %13, label %57, label %14

14:                                               ; preds = %9
  %15 = load i8, ptr %10, align 1, !tbaa !3
  %16 = icmp eq i8 %15, %8
  br i1 %16, label %57, label %17

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %10, i32 1
  %19 = ptrtoint ptr %18 to i32
  %20 = and i32 %19, 3
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %22, label %9, !llvm.loop !6

22:                                               ; preds = %17, %3
  %23 = phi i32 [ %2, %3 ], [ %12, %17 ]
  %24 = phi ptr [ %0, %3 ], [ %18, %17 ]
  %25 = icmp ult i32 %23, 4
  br i1 %25, label %42, label %26

26:                                               ; preds = %22
  %27 = and i32 %1, 255
  %28 = mul nuw i32 %27, 16843009
  br label %29

29:                                               ; preds = %26, %38
  %30 = phi ptr [ %24, %26 ], [ %40, %38 ]
  %31 = phi i32 [ %23, %26 ], [ %39, %38 ]
  %32 = load i32, ptr %30, align 4, !tbaa !9
  %33 = xor i32 %32, %28
  %34 = sub i32 16843008, %33
  %35 = or i32 %34, %33
  %36 = and i32 %35, -2139062144
  %37 = icmp eq i32 %36, -2139062144
  br i1 %37, label %38, label %42

38:                                               ; preds = %29
  %39 = add i32 %31, -4
  %40 = getelementptr inbounds nuw i8, ptr %30, i32 4
  %41 = icmp ugt i32 %39, 3
  br i1 %41, label %29, label %42, !llvm.loop !11

42:                                               ; preds = %38, %29, %22
  %43 = phi i32 [ %23, %22 ], [ %39, %38 ], [ %31, %29 ]
  %44 = phi ptr [ %24, %22 ], [ %40, %38 ], [ %30, %29 ]
  %45 = icmp eq i32 %43, 0
  br i1 %45, label %57, label %46

46:                                               ; preds = %42
  %47 = trunc i32 %1 to i8
  br label %48

48:                                               ; preds = %46, %53
  %49 = phi i32 [ %43, %46 ], [ %54, %53 ]
  %50 = phi ptr [ %44, %46 ], [ %55, %53 ]
  %51 = load i8, ptr %50, align 1, !tbaa !3
  %52 = icmp eq i8 %51, %47
  br i1 %52, label %57, label %53

53:                                               ; preds = %48
  %54 = add i32 %49, -1
  %55 = getelementptr inbounds nuw i8, ptr %50, i32 1
  %56 = icmp eq i32 %54, 0
  br i1 %56, label %57, label %48, !llvm.loop !12

57:                                               ; preds = %14, %9, %48, %53, %42
  %58 = phi ptr [ null, %42 ], [ null, %53 ], [ %50, %48 ], [ null, %9 ], [ %10, %14 ]
  ret ptr %58
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
