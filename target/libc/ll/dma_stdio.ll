; ModuleID = 'libc/dma_stdio.c'
source_filename = "libc/dma_stdio.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@stdout = dso_local local_unnamed_addr constant ptr @__stdio, align 4
@stderr = dso_local local_unnamed_addr constant ptr @__stdio, align 4
@__stdio = internal global { i16, i8, i8, ptr, ptr, ptr } { i16 0, i8 2, i8 0, ptr @dma_uart_putc, ptr null, ptr null }, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define internal range(i32 0, 256) i32 @dma_uart_putc(i8 noundef signext %0, ptr readnone captures(none) %1) #0 {
  %3 = icmp eq i8 %0, 10
  br i1 %3, label %4, label %9

4:                                                ; preds = %2, %4
  %5 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %6 = and i32 %5, 32
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %4, !llvm.loop !7

8:                                                ; preds = %4
  store volatile i32 13, ptr @__dma_uart_dr, align 4, !tbaa !3
  br label %9

9:                                                ; preds = %8, %2
  br label %10

10:                                               ; preds = %9, %10
  %11 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %12 = and i32 %11, 32
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %10, !llvm.loop !10

14:                                               ; preds = %10
  %15 = zext i8 %0 to i32
  store volatile i32 %15, ptr @__dma_uart_dr, align 4, !tbaa !3
  ret i32 %15
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
!10 = distinct !{!10, !8, !9}
