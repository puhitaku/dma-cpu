; ModuleID = 'dmacc/testdata/arith.c'
source_filename = "dmacc/testdata/arith.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@seed0 = dso_local global i32 12345, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local i32 @lcg(ptr noundef captures(none) %0) local_unnamed_addr #0 {
  %2 = load i32, ptr %0, align 4, !tbaa !3
  %3 = mul i32 %2, 1664525
  %4 = add i32 %3, 1013904223
  store i32 %4, ptr %0, align 4, !tbaa !3
  ret i32 %4
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #1 {
  %1 = load volatile i32, ptr @seed0, align 4, !tbaa !3
  br label %2

2:                                                ; preds = %9, %0
  %3 = phi i32 [ %1, %0 ], [ %13, %9 ]
  %4 = phi i32 [ 0, %0 ], [ %39, %9 ]
  %5 = phi i32 [ 0, %0 ], [ %38, %9 ]
  %6 = icmp eq i32 %4, 20
  br i1 %6, label %7, label %9

7:                                                ; preds = %2
  %8 = and i32 %5, 2147483647
  ret i32 %8

9:                                                ; preds = %2
  %10 = mul i32 %3, 1664525
  %11 = add i32 %10, 1013904223
  %12 = mul i32 %11, 1664525
  %13 = add i32 %12, 1013904223
  %14 = or i32 %13, 1
  %15 = add i32 %5, %11
  %16 = add i32 %15, %14
  %17 = sub i32 %11, %14
  %18 = xor i32 %16, %17
  %19 = and i32 %14, %11
  %20 = add i32 %18, %19
  %21 = or i32 %14, %11
  %22 = xor i32 %20, %21
  %23 = freeze i32 %11
  %24 = freeze i32 %14
  %25 = udiv i32 %23, %24
  %26 = mul i32 %25, %24
  %27 = sub i32 %23, %26
  %28 = add i32 %27, %22
  %29 = xor i32 %28, %25
  %30 = ashr i32 %11, 3
  %31 = and i32 %14, 31
  %32 = lshr i32 %11, %31
  %33 = shl i32 %11, %31
  %34 = mul i32 %14, %11
  %35 = add i32 %34, %30
  %36 = add i32 %35, %32
  %37 = add i32 %36, %33
  %38 = add i32 %37, %29
  %39 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !7
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
