; ModuleID = 'dmacc/testdata/bits.c'
source_filename = "dmacc/testdata/bits.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@init = dso_local global i32 0, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #0 {
  %1 = load volatile i32, ptr @init, align 4, !tbaa !3
  %2 = add i32 %1, -100
  %3 = load volatile i32, ptr @init, align 4, !tbaa !3
  %4 = add i32 %3, 200
  %5 = load volatile i32, ptr @init, align 4, !tbaa !3
  %6 = add i32 %5, -30000
  %7 = load volatile i32, ptr @init, align 4, !tbaa !3
  %8 = add i32 %7, 60000
  br label %9

9:                                                ; preds = %19, %0
  %10 = phi i32 [ %2, %0 ], [ %22, %19 ]
  %11 = phi i32 [ %4, %0 ], [ %24, %19 ]
  %12 = phi i32 [ %6, %0 ], [ %27, %19 ]
  %13 = phi i32 [ %8, %0 ], [ %29, %19 ]
  %14 = phi i32 [ 0, %0 ], [ %50, %19 ]
  %15 = phi i32 [ 0, %0 ], [ %51, %19 ]
  %16 = icmp eq i32 %15, 10
  br i1 %16, label %17, label %19

17:                                               ; preds = %9
  %18 = and i32 %14, 2147483647
  ret i32 %18

19:                                               ; preds = %9
  %20 = shl i32 %10, 24
  %21 = ashr exact i32 %20, 24
  %22 = add nsw i32 %21, 37
  %23 = mul i32 %11, 3
  %24 = add i32 %23, 1
  %25 = shl i32 %12, 16
  %26 = ashr exact i32 %25, 16
  %27 = add nsw i32 %26, 12345
  %28 = mul i32 %13, 5
  %29 = add i32 %28, 7
  %30 = shl i32 %22, 24
  %31 = ashr exact i32 %30, 24
  %32 = shl i32 %27, 16
  %33 = ashr exact i32 %32, 16
  %34 = mul nsw i32 %33, %31
  %35 = and i32 %24, 255
  %36 = and i32 %29, 65535
  %37 = mul nuw nsw i32 %36, %35
  %38 = add i32 %34, %14
  %39 = sub i32 %38, %37
  %40 = lshr i32 %31, 31
  %41 = icmp sgt i32 %33, 0
  %42 = zext i1 %41 to i32
  %43 = icmp samesign ugt i32 %35, 128
  %44 = zext i1 %43 to i32
  %45 = icmp samesign ult i32 %36, 30000
  %46 = zext i1 %45 to i32
  %47 = add nuw nsw i32 %40, %44
  %48 = add nuw nsw i32 %47, %42
  %49 = add nuw nsw i32 %48, %46
  %50 = xor i32 %49, %39
  %51 = add nuw nsw i32 %15, 1
  br label %9, !llvm.loop !7
}

attributes #0 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
