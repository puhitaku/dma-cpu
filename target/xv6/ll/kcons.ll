; ModuleID = 'dma/kcons.c'
source_filename = "dma/kcons.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@cons_on = internal unnamed_addr global i1 false, align 4
@ctx_base = dso_local local_unnamed_addr global i32 0, align 4
@ctx_prog = internal unnamed_addr global i32 0, align 4
@ctx_tail = internal unnamed_addr global i32 0, align 4
@ctx_head = internal unnamed_addr global i32 0, align 4
@ctx_ctrl = dso_local local_unnamed_addr global i32 0, align 4
@ctx_ring = dso_local local_unnamed_addr global i32 0, align 4
@crx_base = dso_local local_unnamed_addr global i32 0, align 4
@crx_tail = internal unnamed_addr global i32 0, align 4
@crx_ring = dso_local local_unnamed_addr global i32 0, align 4
@cwk_scrap = internal global i32 0, align 4
@cwk_base = dso_local local_unnamed_addr global i32 0, align 4
@crx_ctrl = dso_local local_unnamed_addr global i32 0, align 4
@cwk_ctrl = dso_local local_unnamed_addr global i32 0, align 4
@cuart_dr = dso_local local_unnamed_addr global i32 0, align 4
@inj_wreg = external dso_local local_unnamed_addr global i32, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @kcons_on() local_unnamed_addr #0 {
  %1 = load i1, ptr @cons_on, align 4
  %2 = zext i1 %1 to i32
  ret i32 %2
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kcons_kick() local_unnamed_addr #1 {
  %1 = load i1, ptr @cons_on, align 4
  br i1 %1, label %2, label %18

2:                                                ; preds = %0
  %3 = load i32, ptr @ctx_base, align 4, !tbaa !3
  %4 = add i32 %3, 8
  %5 = inttoptr i32 %4 to ptr
  %6 = load volatile i32, ptr %5, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %18

8:                                                ; preds = %2
  %9 = load i32, ptr @ctx_prog, align 4, !tbaa !3
  %10 = load i32, ptr @ctx_tail, align 4, !tbaa !3
  %11 = add i32 %10, %9
  store i32 %11, ptr @ctx_tail, align 4, !tbaa !3
  %12 = load i32, ptr @ctx_head, align 4, !tbaa !3
  %13 = sub i32 %12, %11
  store i32 %13, ptr @ctx_prog, align 4, !tbaa !3
  %14 = icmp eq i32 %12, %11
  br i1 %14, label %18, label %15

15:                                               ; preds = %8
  %16 = add i32 %3, 28
  %17 = inttoptr i32 %16 to ptr
  store volatile i32 %13, ptr %17, align 4, !tbaa !3
  br label %18

18:                                               ; preds = %8, %15, %0, %2
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 0, 2) i32 @kcons_tx(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i1, ptr @cons_on, align 4
  br i1 %2, label %52, label %3

3:                                                ; preds = %1
  %4 = load i32, ptr @ctx_ctrl, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %73, label %6

6:                                                ; preds = %3
  %7 = load i32, ptr @cuart_dr, align 4, !tbaa !3
  %8 = add i32 %7, 72
  %9 = inttoptr i32 %8 to ptr
  store volatile i32 3, ptr %9, align 4, !tbaa !3
  %10 = load i32, ptr @ctx_ring, align 4, !tbaa !3
  %11 = load i32, ptr @ctx_base, align 4, !tbaa !3
  %12 = add i32 %11, 20
  %13 = inttoptr i32 %12 to ptr
  store volatile i32 %10, ptr %13, align 4, !tbaa !3
  %14 = load i32, ptr @ctx_base, align 4, !tbaa !3
  %15 = add i32 %14, 24
  %16 = inttoptr i32 %15 to ptr
  store volatile i32 %7, ptr %16, align 4, !tbaa !3
  %17 = load i32, ptr @ctx_ctrl, align 4, !tbaa !3
  %18 = load i32, ptr @ctx_base, align 4, !tbaa !3
  %19 = add i32 %18, 16
  %20 = inttoptr i32 %19 to ptr
  store volatile i32 %17, ptr %20, align 4, !tbaa !3
  %21 = load i32, ptr @inj_wreg, align 4, !tbaa !3
  %22 = add i32 %21, -4
  %23 = inttoptr i32 %22 to ptr
  %24 = load volatile i32, ptr %23, align 4, !tbaa !3
  %25 = load i32, ptr @cwk_base, align 4, !tbaa !3
  %26 = add i32 %25, 20
  %27 = inttoptr i32 %26 to ptr
  store volatile i32 %24, ptr %27, align 4, !tbaa !3
  %28 = load i32, ptr @cwk_base, align 4, !tbaa !3
  %29 = add i32 %28, 24
  %30 = inttoptr i32 %29 to ptr
  store volatile i32 ptrtoint (ptr @cwk_scrap to i32), ptr %30, align 4, !tbaa !3
  %31 = load i32, ptr @cwk_base, align 4, !tbaa !3
  %32 = add i32 %31, 36
  %33 = inttoptr i32 %32 to ptr
  store volatile i32 1, ptr %33, align 4, !tbaa !3
  %34 = load i32, ptr @cwk_ctrl, align 4, !tbaa !3
  %35 = load i32, ptr @cwk_base, align 4, !tbaa !3
  %36 = add i32 %35, 16
  %37 = inttoptr i32 %36 to ptr
  store volatile i32 %34, ptr %37, align 4, !tbaa !3
  %38 = load i32, ptr @crx_base, align 4, !tbaa !3
  %39 = inttoptr i32 %38 to ptr
  store volatile i32 %7, ptr %39, align 4, !tbaa !3
  %40 = load i32, ptr @crx_ring, align 4, !tbaa !3
  %41 = load i32, ptr @crx_base, align 4, !tbaa !3
  %42 = add i32 %41, 4
  %43 = inttoptr i32 %42 to ptr
  store volatile i32 %40, ptr %43, align 4, !tbaa !3
  %44 = load i32, ptr @crx_base, align 4, !tbaa !3
  %45 = add i32 %44, 8
  %46 = inttoptr i32 %45 to ptr
  store volatile i32 1, ptr %46, align 4, !tbaa !3
  store i32 0, ptr @ctx_tail, align 4, !tbaa !3
  store i32 0, ptr @ctx_head, align 4, !tbaa !3
  store i32 0, ptr @ctx_prog, align 4, !tbaa !3
  %47 = load i32, ptr @crx_ring, align 4, !tbaa !3
  store i32 %47, ptr @crx_tail, align 4, !tbaa !3
  store i1 true, ptr @cons_on, align 4
  %48 = load i32, ptr @crx_ctrl, align 4, !tbaa !3
  %49 = load i32, ptr @crx_base, align 4, !tbaa !3
  %50 = add i32 %49, 12
  %51 = inttoptr i32 %50 to ptr
  store volatile i32 %48, ptr %51, align 4, !tbaa !3
  br label %52

52:                                               ; preds = %6, %1
  %53 = load i32, ptr @ctx_head, align 4
  br label %54

54:                                               ; preds = %54, %52
  tail call void @kcons_kick() #3
  %55 = load i32, ptr @ctx_prog, align 4, !tbaa !3
  %56 = load i32, ptr @ctx_base, align 4, !tbaa !3
  %57 = add i32 %56, 8
  %58 = inttoptr i32 %57 to ptr
  %59 = load volatile i32, ptr %58, align 4, !tbaa !3
  %60 = load i32, ptr @ctx_tail, align 4, !tbaa !3
  %61 = add i32 %59, %53
  %62 = add i32 %55, %60
  %63 = sub i32 %61, %62
  %64 = icmp ult i32 %63, 512
  br i1 %64, label %65, label %54

65:                                               ; preds = %54
  %66 = trunc i32 %0 to i8
  %67 = load i32, ptr @ctx_ring, align 4, !tbaa !3
  %68 = and i32 %53, 511
  %69 = add i32 %67, %68
  %70 = inttoptr i32 %69 to ptr
  store volatile i8 %66, ptr %70, align 1, !tbaa !7
  %71 = load i32, ptr @ctx_head, align 4, !tbaa !3
  %72 = add i32 %71, 1
  store i32 %72, ptr @ctx_head, align 4, !tbaa !3
  br label %73

73:                                               ; preds = %3, %65
  %74 = phi i32 [ 1, %65 ], [ 0, %3 ]
  ret i32 %74
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local range(i32 -2, 256) i32 @kcons_rx() local_unnamed_addr #2 {
  %1 = load i1, ptr @cons_on, align 4
  br i1 %1, label %2, label %18

2:                                                ; preds = %0
  %3 = load i32, ptr @crx_base, align 4, !tbaa !3
  %4 = add i32 %3, 4
  %5 = inttoptr i32 %4 to ptr
  %6 = load volatile i32, ptr %5, align 4, !tbaa !3
  %7 = load i32, ptr @crx_tail, align 4, !tbaa !3
  %8 = icmp eq i32 %6, %7
  br i1 %8, label %18, label %9

9:                                                ; preds = %2
  %10 = inttoptr i32 %7 to ptr
  %11 = load volatile i8, ptr %10, align 1, !tbaa !7
  %12 = zext i8 %11 to i32
  %13 = load i32, ptr @crx_ring, align 4, !tbaa !3
  %14 = add i32 %7, 1
  %15 = sub i32 %14, %13
  %16 = and i32 %15, 1023
  %17 = add i32 %16, %13
  store i32 %17, ptr @crx_tail, align 4, !tbaa !3
  br label %18

18:                                               ; preds = %2, %0, %9
  %19 = phi i32 [ %12, %9 ], [ -2, %0 ], [ -1, %2 ]
  ret i32 %19
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kcons_aim(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i1, ptr @cons_on, align 4
  br i1 %2, label %3, label %9

3:                                                ; preds = %1
  %4 = icmp eq i32 %0, 0
  %5 = select i1 %4, i32 ptrtoint (ptr @cwk_scrap to i32), i32 %0
  %6 = load i32, ptr @cwk_base, align 4, !tbaa !3
  %7 = add i32 %6, 4
  %8 = inttoptr i32 %7 to ptr
  store volatile i32 %5, ptr %8, align 4, !tbaa !3
  br label %9

9:                                                ; preds = %1, %3
  ret void
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!5, !5, i64 0}
