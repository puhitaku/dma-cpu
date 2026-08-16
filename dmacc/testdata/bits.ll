; ModuleID = 'dmacc/testdata/bits.c'
source_filename = "dmacc/testdata/bits.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@init = dso_local global i32 0, align 4

; Function Attrs: nofree norecurse nounwind memory(readwrite, argmem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #0 {
  %1 = load volatile i32, ptr @init, align 4, !tbaa !3
  %2 = add i32 %1, -100
  %3 = load volatile i32, ptr @init, align 4, !tbaa !3
  %4 = add i32 %3, 200
  %5 = load volatile i32, ptr @init, align 4, !tbaa !3
  %6 = add i32 %5, -30000
  %7 = load volatile i32, ptr @init, align 4, !tbaa !3
  %8 = add i32 %7, 60000
  br label %11

9:                                                ; preds = %11
  %10 = and i32 %48, 2147483647
  ret i32 %10

11:                                               ; preds = %0, %11
  %12 = phi i32 [ 0, %0 ], [ %49, %11 ]
  %13 = phi i32 [ 0, %0 ], [ %48, %11 ]
  %14 = phi i32 [ %8, %0 ], [ %27, %11 ]
  %15 = phi i32 [ %6, %0 ], [ %25, %11 ]
  %16 = phi i32 [ %4, %0 ], [ %22, %11 ]
  %17 = phi i32 [ %2, %0 ], [ %20, %11 ]
  %18 = shl i32 %17, 24
  %19 = ashr exact i32 %18, 24
  %20 = add nsw i32 %19, 37
  %21 = mul i32 %16, 3
  %22 = add i32 %21, 1
  %23 = shl i32 %15, 16
  %24 = ashr exact i32 %23, 16
  %25 = add nsw i32 %24, 12345
  %26 = mul i32 %14, 5
  %27 = add i32 %26, 7
  %28 = shl i32 %20, 24
  %29 = ashr exact i32 %28, 24
  %30 = shl i32 %25, 16
  %31 = ashr exact i32 %30, 16
  %32 = mul nsw i32 %31, %29
  %33 = and i32 %22, 255
  %34 = and i32 %27, 65535
  %35 = mul nuw nsw i32 %34, %33
  %36 = add i32 %32, %13
  %37 = sub i32 %36, %35
  %38 = lshr i32 %29, 31
  %39 = icmp sgt i32 %31, 0
  %40 = zext i1 %39 to i32
  %41 = icmp samesign ugt i32 %33, 128
  %42 = zext i1 %41 to i32
  %43 = icmp samesign ult i32 %34, 30000
  %44 = zext i1 %43 to i32
  %45 = add nuw nsw i32 %38, %42
  %46 = add nuw nsw i32 %45, %40
  %47 = add nuw nsw i32 %46, %44
  %48 = xor i32 %47, %37
  %49 = add nuw nsw i32 %12, 1
  %50 = icmp eq i32 %49, 10
  br i1 %50, label %9, label %11, !llvm.loop !7
}

attributes #0 = { nofree norecurse nounwind memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

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
