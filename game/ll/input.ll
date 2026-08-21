; ModuleID = 'input.c'
source_filename = "input.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@in_primed = internal unnamed_addr global i1 false, align 4
@joyA = internal unnamed_addr constant [5 x i8] c"\03\04\02\05\06", align 1
@joyB = internal unnamed_addr constant [5 x i8] c"\08\09\07\0A\0B", align 1
@joyAaddr = internal constant [5 x i32] [i32 1073823768, i32 1073823776, i32 1073823760, i32 1073823784, i32 1073823792], align 4
@joyBaddr = internal constant [5 x i32] [i32 1073823808, i32 1073823816, i32 1073823800, i32 1073823824, i32 1073823832], align 4
@in_prev = internal unnamed_addr global i32 0, align 4
@in_down = dso_local local_unnamed_addr global i32 0, align 4
@in_edge = dso_local local_unnamed_addr global i32 0, align 4
@rng_state = internal unnamed_addr global i32 -1640531527, align 4
@frame_sync.next = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local void @in_poll() local_unnamed_addr #0 {
  %1 = load i1, ptr @in_primed, align 4
  br i1 %1, label %15, label %2

2:                                                ; preds = %0, %5
  %3 = phi i32 [ %12, %5 ], [ 0, %0 ]
  %4 = icmp eq i32 %3, 5
  br i1 %4, label %13, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [5 x i8], ptr @joyA, i32 0, i32 %3
  %7 = load i8, ptr %6, align 1, !tbaa !3
  %8 = zext i8 %7 to i32
  tail call void @gpio_in_init(i32 noundef %8) #5
  %9 = getelementptr inbounds nuw [5 x i8], ptr @joyB, i32 0, i32 %3
  %10 = load i8, ptr %9, align 1, !tbaa !3
  %11 = zext i8 %10 to i32
  tail call void @gpio_in_init(i32 noundef %11) #5
  %12 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !6

13:                                               ; preds = %2
  %14 = load i1, ptr @in_primed, align 4
  br label %15

15:                                               ; preds = %13, %0
  %16 = phi i1 [ %14, %13 ], [ true, %0 ]
  %17 = tail call fastcc i32 @stick(ptr noundef nonnull @joyAaddr) #6
  %18 = tail call fastcc i32 @stick(ptr noundef nonnull @joyBaddr) #6
  %19 = or i32 %18, %17
  br i1 %16, label %21, label %20

20:                                               ; preds = %15
  store i1 true, ptr @in_primed, align 4
  store i32 %19, ptr @in_prev, align 4, !tbaa !9
  store i32 %19, ptr @in_down, align 4, !tbaa !9
  store i32 0, ptr @in_edge, align 4, !tbaa !9
  br label %30

21:                                               ; preds = %15
  %22 = load i32, ptr @in_prev, align 4, !tbaa !9
  %23 = xor i32 %22, -1
  %24 = and i32 %19, %23
  store i32 %24, ptr @in_edge, align 4, !tbaa !9
  store i32 %19, ptr @in_down, align 4, !tbaa !9
  store i32 %19, ptr @in_prev, align 4, !tbaa !9
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %30, label %26

26:                                               ; preds = %21
  %27 = tail call i32 @now_us() #5
  %28 = load i32, ptr @rng_state, align 4, !tbaa !9
  %29 = xor i32 %28, %27
  store i32 %29, ptr @rng_state, align 4, !tbaa !9
  br label %30

30:                                               ; preds = %21, %26, %20
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gpio_in_init(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc i32 @stick(ptr noundef readonly captures(none) %0) unnamed_addr #2 {
  br label %2

2:                                                ; preds = %8, %1
  %3 = phi i32 [ 0, %1 ], [ %16, %8 ]
  %4 = phi i32 [ 1, %1 ], [ %18, %8 ]
  %5 = phi i32 [ 0, %1 ], [ %17, %8 ]
  %6 = icmp eq i32 %5, 5
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  ret i32 %3

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw i32, ptr %0, i32 %5
  %10 = load i32, ptr %9, align 4, !tbaa !9
  %11 = inttoptr i32 %10 to ptr
  %12 = load volatile i32, ptr %11, align 4, !tbaa !9
  %13 = and i32 %12, 131072
  %14 = icmp eq i32 %13, 0
  %15 = select i1 %14, i32 %4, i32 0
  %16 = or i32 %15, %3
  %17 = add nuw nsw i32 %5, 1
  %18 = shl i32 %4, 1
  br label %2, !llvm.loop !11
}

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local i32 @rng() local_unnamed_addr #3 {
  %1 = load i32, ptr @rng_state, align 4, !tbaa !9
  %2 = shl i32 %1, 13
  %3 = xor i32 %2, %1
  %4 = lshr i32 %3, 17
  %5 = xor i32 %4, %3
  %6 = shl i32 %5, 5
  %7 = xor i32 %6, %5
  store i32 %7, ptr @rng_state, align 4, !tbaa !9
  ret i32 %7
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define dso_local range(i32 0, -1) i32 @rng_below(i32 noundef %0) local_unnamed_addr #4 {
  %2 = tail call i32 @rng() #6
  %3 = urem i32 %2, %0
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local void @frame_sync(i32 noundef %0) local_unnamed_addr #0 {
  tail call void @snd_tick() #5
  tail call void @led_tick() #5
  tail call void @pcm_tick() #5
  %2 = tail call i32 @now_us() #5
  %3 = load i32, ptr @frame_sync.next, align 4, !tbaa !9
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
  store i32 %12, ptr @frame_sync.next, align 4, !tbaa !9
  br label %13

13:                                               ; preds = %13, %10
  %14 = load i32, ptr @frame_sync.next, align 4, !tbaa !9
  %15 = tail call i32 @now_us() #5
  %16 = sub i32 %14, %15
  %17 = icmp sgt i32 %16, 0
  br i1 %17, label %13, label %18, !llvm.loop !12

18:                                               ; preds = %13
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @snd_tick() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_tick() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @pcm_tick() local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !4, i64 0}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
