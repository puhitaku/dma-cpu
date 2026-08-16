; ModuleID = 'fputc.c'
source_filename = "fputc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@putc_unlocked = dso_local alias i32 (i32, ptr), ptr @putc
@fputc = dso_local alias i32 (i32, ptr), ptr @putc

; Function Attrs: nounwind
define dso_local range(i32 -1, 256) i32 @putc(i32 noundef %0, ptr noundef nonnull %1) #0 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 2
  %4 = load i8, ptr %3, align 2, !tbaa !3
  %5 = and i8 %4, 2
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %18, label %7

7:                                                ; preds = %2
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %9 = load ptr, ptr %8, align 4, !tbaa !9
  %10 = trunc i32 %0 to i8
  %11 = tail call i32 %9(i8 noundef signext %10, ptr noundef nonnull %1) #1
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %13, label %16

13:                                               ; preds = %7
  %14 = load i8, ptr %3, align 2, !tbaa !3
  %15 = or i8 %14, 4
  store i8 %15, ptr %3, align 2, !tbaa !3
  br label %18

16:                                               ; preds = %7
  %17 = and i32 %0, 255
  br label %18

18:                                               ; preds = %2, %16, %13
  %19 = phi i32 [ -1, %13 ], [ %17, %16 ], [ -1, %2 ]
  ret i32 %19
}

attributes #0 = { nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { nobuiltin nounwind "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !6, i64 2}
!4 = !{!"__file", !5, i64 0, !6, i64 2, !8, i64 4, !8, i64 8, !8, i64 12}
!5 = !{!"short", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"any pointer", !6, i64 0}
!9 = !{!4, !8, i64 4}
