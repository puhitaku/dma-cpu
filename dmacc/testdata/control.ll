; ModuleID = 'dmacc/testdata/control.c'
source_filename = "dmacc/testdata/control.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@__const.main.probes = private unnamed_addr constant [12 x i32] [i32 -2000000000, i32 -101, i32 -100, i32 -1, i32 0, i32 1, i32 41, i32 42, i32 43, i32 1000000000, i32 1000000001, i32 2147483647], align 4
@switch.table.main = private unnamed_addr constant [6 x i32] [i32 100, i32 900, i32 900, i32 300, i32 900, i32 500], align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local range(i32 1, 6) i32 @classify(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, -100
  br i1 %2, label %10, label %3

3:                                                ; preds = %1
  %4 = icmp slt i32 %0, 1
  br i1 %4, label %10, label %5

5:                                                ; preds = %3
  %6 = icmp eq i32 %0, 42
  br i1 %6, label %10, label %7

7:                                                ; preds = %5
  %8 = icmp samesign ugt i32 %0, 1000000000
  %9 = select i1 %8, i32 4, i32 5
  br label %10

10:                                               ; preds = %7, %5, %3, %1
  %11 = phi i32 [ 1, %1 ], [ 2, %3 ], [ 3, %5 ], [ %9, %7 ]
  ret i32 %11
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local range(i32 7, 11) i32 @uclass(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp ugt i32 %0, -2147483648
  br i1 %2, label %8, label %3

3:                                                ; preds = %1
  %4 = icmp ugt i32 %0, 268435455
  br i1 %4, label %8, label %5

5:                                                ; preds = %3
  %6 = icmp eq i32 %0, 0
  %7 = select i1 %6, i32 10, i32 9
  br label %8

8:                                                ; preds = %5, %3, %1
  %9 = phi i32 [ 7, %1 ], [ 8, %3 ], [ %7, %5 ]
  ret i32 %9
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %10, %5 ]
  %3 = phi i32 [ 0, %0 ], [ %11, %5 ]
  %4 = icmp eq i32 %3, 12
  br i1 %4, label %12, label %5

5:                                                ; preds = %1
  %6 = mul nsw i32 %2, 7
  %7 = getelementptr inbounds nuw [12 x i32], ptr @__const.main.probes, i32 0, i32 %3
  %8 = load i32, ptr %7, align 4, !tbaa !3
  %9 = tail call i32 @classify(i32 noundef %8) #2
  %10 = add nsw i32 %9, %6
  %11 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !7

12:                                               ; preds = %1, %28
  %13 = phi i32 [ %30, %28 ], [ %2, %1 ]
  %14 = phi i32 [ %31, %28 ], [ 0, %1 ]
  %15 = icmp eq i32 %14, 7
  br i1 %15, label %16, label %19

16:                                               ; preds = %12
  %17 = and i32 %13, 7
  %18 = icmp samesign ult i32 %17, 6
  br i1 %18, label %32, label %35

19:                                               ; preds = %12
  %20 = mul nsw i32 %13, 5
  switch i32 %14, label %21 [
    i32 4, label %28
    i32 2, label %28
  ]

21:                                               ; preds = %19
  %22 = shl nuw nsw i32 1, %14
  %23 = and i32 %22, 92
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %25, label %28

25:                                               ; preds = %21
  %26 = icmp eq i32 %14, 0
  %27 = select i1 %26, i32 10, i32 9
  br label %28

28:                                               ; preds = %19, %19, %21, %25
  %29 = phi i32 [ 7, %19 ], [ 8, %21 ], [ %27, %25 ], [ 7, %19 ]
  %30 = add nsw i32 %29, %20
  %31 = add nuw nsw i32 %14, 1
  br label %12, !llvm.loop !10

32:                                               ; preds = %16
  %33 = getelementptr inbounds nuw [6 x i32], ptr @switch.table.main, i32 0, i32 %17
  %34 = load i32, ptr %33, align 4
  br label %35

35:                                               ; preds = %16, %32
  %36 = phi i32 [ %34, %32 ], [ 900, %16 ]
  %37 = add nsw i32 %13, %36
  %38 = and i32 %37, 2147483647
  ret i32 %38
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nosync nounwind optsize memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
