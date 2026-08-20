; ModuleID = 'input.c'
source_filename = "input.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@in_primed = internal unnamed_addr global i1 false, align 4
@in_prev = internal unnamed_addr global i32 0, align 4
@in_down = dso_local local_unnamed_addr global i32 0, align 4
@in_edge = dso_local local_unnamed_addr global i32 0, align 4
@rng_state = internal unnamed_addr global i32 -1640531527, align 4
@frame_sync.next = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local void @in_poll() local_unnamed_addr #0 {
  %1 = tail call fastcc i32 @stick(i32 noundef 2) #4
  %2 = tail call fastcc i32 @stick(i32 noundef 7) #4
  %3 = or i32 %2, %1
  %4 = load i1, ptr @in_primed, align 4
  br i1 %4, label %6, label %5

5:                                                ; preds = %0
  store i1 true, ptr @in_primed, align 4
  store i32 %3, ptr @in_prev, align 4, !tbaa !3
  store i32 %3, ptr @in_down, align 4, !tbaa !3
  store i32 0, ptr @in_edge, align 4, !tbaa !3
  br label %15

6:                                                ; preds = %0
  %7 = load i32, ptr @in_prev, align 4, !tbaa !3
  %8 = xor i32 %7, -1
  %9 = and i32 %3, %8
  store i32 %9, ptr @in_edge, align 4, !tbaa !3
  store i32 %3, ptr @in_down, align 4, !tbaa !3
  store i32 %3, ptr @in_prev, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %15, label %11

11:                                               ; preds = %6
  %12 = tail call i32 @now_us() #5
  %13 = load i32, ptr @rng_state, align 4, !tbaa !3
  %14 = xor i32 %13, %12
  store i32 %14, ptr @rng_state, align 4, !tbaa !3
  br label %15

15:                                               ; preds = %6, %11, %5
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, -2147483648) i32 @stick(i32 noundef range(i32 2, 8) %0) unnamed_addr #0 {
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi i32 [ 0, %1 ], [ %13, %7 ]
  %4 = phi i32 [ 0, %1 ], [ %14, %7 ]
  %5 = icmp eq i32 %4, 5
  br i1 %5, label %6, label %7

6:                                                ; preds = %2
  ret i32 %3

7:                                                ; preds = %2
  %8 = add nuw nsw i32 %4, %0
  %9 = tail call i32 @gpio_in_pu(i32 noundef %8) #5
  %10 = icmp eq i32 %9, 0
  %11 = shl nuw nsw i32 1, %4
  %12 = select i1 %10, i32 %11, i32 0
  %13 = or i32 %12, %3
  %14 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !7
}

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local i32 @rng() local_unnamed_addr #2 {
  %1 = load i32, ptr @rng_state, align 4, !tbaa !3
  %2 = shl i32 %1, 13
  %3 = xor i32 %2, %1
  %4 = lshr i32 %3, 17
  %5 = xor i32 %4, %3
  %6 = shl i32 %5, 5
  %7 = xor i32 %6, %5
  store i32 %7, ptr @rng_state, align 4, !tbaa !3
  ret i32 %7
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define dso_local range(i32 0, -1) i32 @rng_below(i32 noundef %0) local_unnamed_addr #3 {
  %2 = tail call i32 @rng() #4
  %3 = urem i32 %2, %0
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local void @frame_sync(i32 noundef %0) local_unnamed_addr #0 {
  %2 = tail call i32 @now_us() #5
  %3 = load i32, ptr @frame_sync.next, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %9, label %5

5:                                                ; preds = %1
  %6 = sub i32 %2, %3
  %7 = shl i32 %0, 3
  %8 = icmp ugt i32 %6, %7
  br i1 %8, label %9, label %10

9:                                                ; preds = %5, %1
  br label %10

10:                                               ; preds = %9, %5
  %11 = phi i32 [ %2, %9 ], [ %3, %5 ]
  %12 = add i32 %11, %0
  store i32 %12, ptr @frame_sync.next, align 4, !tbaa !3
  br label %13

13:                                               ; preds = %13, %10
  %14 = load i32, ptr @frame_sync.next, align 4, !tbaa !3
  %15 = tail call i32 @now_us() #5
  %16 = sub i32 %14, %15
  %17 = icmp sgt i32 %16, 0
  br i1 %17, label %13, label %18, !llvm.loop !10

18:                                               ; preds = %13
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @gpio_in_pu(i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
