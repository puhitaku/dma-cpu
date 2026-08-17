; ModuleID = 'dma/sbrk.c'
source_filename = "dma/sbrk.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@dma_brk = internal unnamed_addr global i32 0, align 4
@dma_heap = internal global [36864 x i8] zeroinitializer, align 1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local nonnull ptr @sys_sbrk(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp slt i32 %0, 0
  br i1 %3, label %10, label %4

4:                                                ; preds = %2
  %5 = load i32, ptr @dma_brk, align 4, !tbaa !3
  %6 = add nuw i32 %5, %0
  %7 = icmp ugt i32 %6, 36864
  br i1 %7, label %10, label %8

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw i8, ptr @dma_heap, i32 %5
  store i32 %6, ptr @dma_brk, align 4, !tbaa !3
  br label %10

10:                                               ; preds = %2, %4, %8
  %11 = phi ptr [ %9, %8 ], [ inttoptr (i32 -1 to ptr), %4 ], [ inttoptr (i32 -1 to ptr), %2 ]
  ret ptr %11
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
