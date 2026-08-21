; ModuleID = 'input.c'
source_filename = "input.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@in_primed = internal unnamed_addr global i1 false, align 4
@joyA = internal constant [5 x i8] c"\03\04\02\05\06", align 1
@joyB = internal constant [5 x i8] c"\08\09\07\0A\0B", align 1
@in_prev = internal unnamed_addr global i32 0, align 4
@in_down = dso_local local_unnamed_addr global i32 0, align 4
@in_edge = dso_local local_unnamed_addr global i32 0, align 4
@rng_state = internal unnamed_addr global i32 -1640531527, align 4
@frame_sync.next = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local void @in_poll() local_unnamed_addr #0 {
  %1 = load i1, ptr @in_primed, align 4
  br i1 %1, label %13, label %2

2:                                                ; preds = %0, %5
  %3 = phi i32 [ %12, %5 ], [ 0, %0 ]
  %4 = icmp eq i32 %3, 5
  br i1 %4, label %13, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [5 x i8], ptr @joyA, i32 0, i32 %3
  %7 = load i8, ptr %6, align 1, !tbaa !3
  %8 = zext i8 %7 to i32
  tail call void @gpio_in_init(i32 noundef %8) #4
  %9 = getelementptr inbounds nuw [5 x i8], ptr @joyB, i32 0, i32 %3
  %10 = load i8, ptr %9, align 1, !tbaa !3
  %11 = zext i8 %10 to i32
  tail call void @gpio_in_init(i32 noundef %11) #4
  %12 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !6

13:                                               ; preds = %2, %0
  %14 = tail call fastcc i32 @stick(ptr noundef nonnull @joyA) #5
  %15 = tail call fastcc i32 @stick(ptr noundef nonnull @joyB) #5
  %16 = or i32 %15, %14
  %17 = load i1, ptr @in_primed, align 4
  br i1 %17, label %19, label %18

18:                                               ; preds = %13
  store i1 true, ptr @in_primed, align 4
  store i32 %16, ptr @in_prev, align 4, !tbaa !9
  store i32 %16, ptr @in_down, align 4, !tbaa !9
  store i32 0, ptr @in_edge, align 4, !tbaa !9
  br label %28

19:                                               ; preds = %13
  %20 = load i32, ptr @in_prev, align 4, !tbaa !9
  %21 = xor i32 %20, -1
  %22 = and i32 %16, %21
  store i32 %22, ptr @in_edge, align 4, !tbaa !9
  store i32 %16, ptr @in_down, align 4, !tbaa !9
  store i32 %16, ptr @in_prev, align 4, !tbaa !9
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %28, label %24

24:                                               ; preds = %19
  %25 = tail call i32 @now_us() #4
  %26 = load i32, ptr @rng_state, align 4, !tbaa !9
  %27 = xor i32 %26, %25
  store i32 %27, ptr @rng_state, align 4, !tbaa !9
  br label %28

28:                                               ; preds = %19, %24, %18
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gpio_in_init(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, -2147483648) i32 @stick(ptr noundef readonly captures(none) %0) unnamed_addr #0 {
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi i32 [ 0, %1 ], [ %15, %7 ]
  %4 = phi i32 [ 0, %1 ], [ %16, %7 ]
  %5 = icmp eq i32 %4, 5
  br i1 %5, label %6, label %7

6:                                                ; preds = %2
  ret i32 %3

7:                                                ; preds = %2
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %9 = load i8, ptr %8, align 1, !tbaa !3
  %10 = zext i8 %9 to i32
  %11 = tail call i32 @gpio_in(i32 noundef %10) #4
  %12 = icmp eq i32 %11, 0
  %13 = shl nuw nsw i32 1, %4
  %14 = select i1 %12, i32 %13, i32 0
  %15 = or i32 %14, %3
  %16 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !11
}

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local i32 @rng() local_unnamed_addr #2 {
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
define dso_local range(i32 0, -1) i32 @rng_below(i32 noundef %0) local_unnamed_addr #3 {
  %2 = tail call i32 @rng() #5
  %3 = urem i32 %2, %0
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local void @frame_sync(i32 noundef %0) local_unnamed_addr #0 {
  tail call void @snd_tick() #4
  tail call void @led_tick() #4
  %2 = tail call i32 @now_us() #4
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
  %15 = tail call i32 @now_us() #4
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
declare dso_local i32 @gpio_in(i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }

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
