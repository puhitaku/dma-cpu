; ModuleID = 'fx.c'
source_filename = "fx.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@pioprog = internal unnamed_addr constant [12 x i16] [i16 28673, i16 6208, i16 24577, i16 -6098, i16 24577, i16 2116, i16 28673, i16 -2002, i16 25121, i16 4395, i16 5128, i16 -23486], align 2
@sndctrl = dso_local local_unnamed_addr global i32 0, align 4
@snd_frames = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @snd_rate(i32 noundef %0) local_unnamed_addr #0 {
  %2 = shl i32 %0, 8
  store volatile i32 %2, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fx_init() local_unnamed_addr #1 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 12, %0 ], [ %5, %4 ]
  %3 = icmp eq i32 %2, 16
  br i1 %3, label %6, label %4

4:                                                ; preds = %1
  tail call void @gpio_fn(i32 noundef %2, i32 noundef 12294) #5
  %5 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !7

6:                                                ; preds = %1, %11
  %7 = phi i32 [ %18, %11 ], [ 0, %1 ]
  %8 = icmp eq i32 %7, 12
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  store volatile i32 4643840, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  store volatile i32 28672, ptr inttoptr (i32 1344274636 to ptr), align 4, !tbaa !3
  store volatile i32 131072, ptr inttoptr (i32 1344274640 to ptr), align 16, !tbaa !3
  store volatile i32 1074803727, ptr inttoptr (i32 1344274652 to ptr), align 4, !tbaa !3
  store volatile i32 7, ptr inttoptr (i32 1344274648 to ptr), align 8, !tbaa !3
  store volatile i32 1638400, ptr inttoptr (i32 1344274656 to ptr), align 32, !tbaa !3
  store volatile i32 46080, ptr inttoptr (i32 1344274660 to ptr), align 4, !tbaa !3
  store volatile i32 805437440, ptr inttoptr (i32 1344274664 to ptr), align 8, !tbaa !3
  store volatile i32 536883200, ptr inttoptr (i32 1344274676 to ptr), align 4, !tbaa !3
  store volatile i32 8, ptr inttoptr (i32 1344274672 to ptr), align 16, !tbaa !3
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #5
  store volatile i32 537100288, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !3
  store volatile i32 1344274448, ptr inttoptr (i32 1342177860 to ptr), align 4, !tbaa !3
  store volatile i32 -1, ptr inttoptr (i32 1342177864 to ptr), align 8, !tbaa !3
  %10 = load i32, ptr @sndctrl, align 4, !tbaa !3
  store volatile i32 %10, ptr inttoptr (i32 1342177868 to ptr), align 4, !tbaa !3
  store volatile i32 3, ptr inttoptr (i32 1344274432 to ptr), align 2097152, !tbaa !3
  ret void

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw [12 x i16], ptr @pioprog, i32 0, i32 %7
  %13 = load i16, ptr %12, align 2, !tbaa !10
  %14 = zext i16 %13 to i32
  %15 = shl nuw nsw i32 %7, 2
  %16 = add nuw nsw i32 %15, 1344274504
  %17 = inttoptr i32 %16 to ptr
  store volatile i32 %14, ptr %17, align 4, !tbaa !3
  %18 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !12
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gpio_fn(i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_play(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = icmp ult i32 %0, 217
  br i1 %4, label %15, label %5

5:                                                ; preds = %3
  %6 = icmp ult i32 %0, 433
  br i1 %6, label %15, label %7

7:                                                ; preds = %5
  %8 = icmp ult i32 %0, 865
  br i1 %8, label %15, label %9

9:                                                ; preds = %7
  %10 = icmp ult i32 %0, 1728
  br i1 %10, label %15, label %11

11:                                               ; preds = %9
  %12 = icmp ult i32 %0, 3455
  %13 = select i1 %12, i32 4, i32 3
  %14 = select i1 %12, i32 8, i32 4
  br label %15

15:                                               ; preds = %11, %9, %7, %5, %3
  %16 = phi i32 [ 8, %3 ], [ 7, %5 ], [ 6, %7 ], [ 5, %9 ], [ %13, %11 ]
  %17 = phi i32 [ 128, %3 ], [ 64, %5 ], [ 32, %7 ], [ 16, %9 ], [ %14, %11 ]
  %18 = lshr i32 800000000, %16
  %19 = udiv i32 %18, %0
  %20 = tail call i32 @llvm.umax.i32(i32 %19, i32 15900)
  %21 = tail call i32 @llvm.umin.i32(i32 %20, i32 26300)
  %22 = shl nuw nsw i32 %21, 8
  store volatile i32 %22, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  %23 = shl i32 %1, 6
  %24 = and i32 %23, 65472
  %25 = mul nuw i32 %24, 65537
  br label %26

26:                                               ; preds = %34, %15
  %27 = phi i32 [ 0, %15 ], [ %36, %34 ]
  %28 = icmp eq i32 %27, %17
  br i1 %28, label %29, label %34

29:                                               ; preds = %26
  %30 = sub i32 0, %23
  %31 = and i32 %30, 65472
  %32 = mul nuw i32 %31, 65537
  %33 = shl nuw nsw i32 %17, 1
  br label %37

34:                                               ; preds = %26
  %35 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537100288 to ptr), i32 %27
  store volatile i32 %25, ptr %35, align 4, !tbaa !3
  %36 = add nuw nsw i32 %27, 1
  br label %26, !llvm.loop !13

37:                                               ; preds = %29, %42
  %38 = phi i32 [ %44, %42 ], [ %17, %29 ]
  %39 = icmp samesign ult i32 %38, %33
  br i1 %39, label %42, label %40

40:                                               ; preds = %37
  %41 = shl nuw nsw i32 %17, 3
  br label %45

42:                                               ; preds = %37
  %43 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537100288 to ptr), i32 %38
  store volatile i32 %32, ptr %43, align 4, !tbaa !3
  %44 = add nuw nsw i32 %38, 1
  br label %37, !llvm.loop !14

45:                                               ; preds = %49, %40
  %46 = phi i32 [ %41, %40 ], [ %51, %49 ]
  %47 = icmp ult i32 %46, 16384
  br i1 %47, label %49, label %48

48:                                               ; preds = %45
  store i32 %2, ptr @snd_frames, align 4, !tbaa !3
  ret void

49:                                               ; preds = %45
  %50 = or disjoint i32 %46, 537100288
  tail call void @gdma_copy(i32 noundef %50, i32 noundef 537100288, i32 noundef %46) #5
  %51 = shl nuw nsw i32 %46, 1
  br label %45, !llvm.loop !15
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_tick() local_unnamed_addr #1 {
  %1 = load i32, ptr @snd_frames, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %7, label %3

3:                                                ; preds = %0
  %4 = add i32 %1, -1
  store i32 %4, ptr @snd_frames, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #5
  br label %7

7:                                                ; preds = %6, %3, %0
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @led(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = alloca [2 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #6
  store i32 %0, ptr %3, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store i32 %1, ptr %4, align 4, !tbaa !3
  br label %5

5:                                                ; preds = %16, %2
  %6 = phi i32 [ 0, %2 ], [ %25, %16 ]
  %7 = icmp eq i32 %6, 2
  br i1 %7, label %8, label %9

8:                                                ; preds = %5
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #6
  ret void

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw [2 x i32], ptr %3, i32 0, i32 %6
  %11 = load i32, ptr %10, align 4, !tbaa !3
  br label %12

12:                                               ; preds = %12, %9
  %13 = load volatile i32, ptr inttoptr (i32 1344274436 to ptr), align 4, !tbaa !3
  %14 = and i32 %13, 131072
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %12, !llvm.loop !16

16:                                               ; preds = %12
  %17 = shl i32 %11, 8
  %18 = and i32 %17, 16711680
  %19 = lshr i32 %11, 8
  %20 = and i32 %19, 65280
  %21 = or disjoint i32 %18, %20
  %22 = and i32 %11, 255
  %23 = or disjoint i32 %21, %22
  %24 = shl nuw i32 %23, 8
  store volatile i32 %24, ptr inttoptr (i32 1344274452 to ptr), align 4, !tbaa !3
  %25 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !17
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #4

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { nounwind }

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
!10 = !{!11, !11, i64 0}
!11 = !{!"short", !5, i64 0}
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
