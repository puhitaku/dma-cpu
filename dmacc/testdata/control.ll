; ModuleID = 'dmacc/testdata/control.c'
source_filename = "dmacc/testdata/control.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@switch.table.main = private unnamed_addr constant [6 x i32] [i32 100, i32 900, i32 900, i32 300, i32 900, i32 500], align 4

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
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
  %8 = icmp sgt i32 %0, 1000000000
  %9 = select i1 %8, i32 4, i32 5
  br label %10

10:                                               ; preds = %7, %5, %3, %1
  %11 = phi i32 [ 1, %1 ], [ 2, %3 ], [ 3, %5 ], [ %9, %7 ]
  ret i32 %11
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
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

; Function Attrs: nofree norecurse nosync nounwind memory(none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %0, %14
  %2 = phi i32 [ 0, %0 ], [ %17, %14 ]
  %3 = phi i32 [ 0, %0 ], [ %16, %14 ]
  %4 = mul nsw i32 %3, 7
  %5 = icmp samesign ult i32 %2, 2
  br i1 %5, label %14, label %6

6:                                                ; preds = %1
  %7 = icmp samesign ult i32 %2, 5
  br i1 %7, label %14, label %8

8:                                                ; preds = %6
  %9 = icmp eq i32 %2, 7
  br i1 %9, label %14, label %10

10:                                               ; preds = %8
  %11 = and i32 %2, 14
  %12 = icmp eq i32 %11, 10
  %13 = select i1 %12, i32 4, i32 5
  br label %14

14:                                               ; preds = %1, %6, %8, %10
  %15 = phi i32 [ 1, %1 ], [ 2, %6 ], [ 3, %8 ], [ %13, %10 ]
  %16 = add nsw i32 %15, %4
  %17 = add nuw nsw i32 %2, 1
  %18 = icmp eq i32 %17, 12
  br i1 %18, label %22, label %1, !llvm.loop !3

19:                                               ; preds = %33
  %20 = and i32 %35, 7
  %21 = icmp samesign ult i32 %20, 6
  br i1 %21, label %38, label %41

22:                                               ; preds = %14, %33
  %23 = phi i32 [ %36, %33 ], [ 0, %14 ]
  %24 = phi i32 [ %35, %33 ], [ %16, %14 ]
  %25 = mul nsw i32 %24, 5
  switch i32 %23, label %26 [
    i32 4, label %33
    i32 2, label %33
  ]

26:                                               ; preds = %22
  %27 = shl nuw nsw i32 1, %23
  %28 = and i32 %27, 92
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %33

30:                                               ; preds = %26
  %31 = icmp eq i32 %23, 0
  %32 = select i1 %31, i32 10, i32 9
  br label %33

33:                                               ; preds = %22, %22, %26, %30
  %34 = phi i32 [ 7, %22 ], [ 8, %26 ], [ %32, %30 ], [ 7, %22 ]
  %35 = add nsw i32 %34, %25
  %36 = add nuw nsw i32 %23, 1
  %37 = icmp eq i32 %36, 7
  br i1 %37, label %19, label %22, !llvm.loop !6

38:                                               ; preds = %19
  %39 = getelementptr inbounds nuw [6 x i32], ptr @switch.table.main, i32 0, i32 %20
  %40 = load i32, ptr %39, align 4
  br label %41

41:                                               ; preds = %19, %38
  %42 = phi i32 [ %40, %38 ], [ 900, %19 ]
  %43 = add nsw i32 %35, %42
  %44 = and i32 %43, 2147483647
  ret i32 %44
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { nofree norecurse nosync nounwind memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = distinct !{!6, !4, !5}
