; ModuleID = 'fx.c'
source_filename = "fx.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@pioprog = internal unnamed_addr constant [12 x i16] [i16 28673, i16 6208, i16 24577, i16 -6098, i16 24577, i16 2116, i16 28673, i16 -2002, i16 25121, i16 4395, i16 5128, i16 -23486], align 2
@sndctrl = dso_local local_unnamed_addr global i32 0, align 4
@sw_step = internal unnamed_addr global i32 0, align 4
@snd_frames = internal unnamed_addr global i32 0, align 4
@sw_hz = internal unnamed_addr global i32 0, align 4
@sw_vol = internal unnamed_addr global i32 0, align 4
@spictrl = external dso_local local_unnamed_addr global i32, align 4
@pcm_active = internal unnamed_addr global i1 false, align 4
@led_base0 = internal unnamed_addr global i32 0, align 4
@led_base1 = internal unnamed_addr global i32 0, align 4
@leda_mode = internal unnamed_addr global i32 0, align 4
@leda_n = internal unnamed_addr global i32 0, align 4
@leda_hue = internal unnamed_addr global i32 0, align 4
@leda_rgb = internal unnamed_addr global i32 0, align 4
@leda_phase = internal unnamed_addr global i32 0, align 4
@sfx_tab = dso_local local_unnamed_addr global [4 x i32] zeroinitializer, align 4

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
  tail call void @gpio_fn(i32 noundef %2, i32 noundef 12294) #7
  %5 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !7

6:                                                ; preds = %1, %11
  %7 = phi i32 [ %18, %11 ], [ 0, %1 ]
  %8 = icmp eq i32 %7, 12
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  store volatile i32 5804800, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  store volatile i32 28672, ptr inttoptr (i32 1344274636 to ptr), align 4, !tbaa !3
  store volatile i32 131072, ptr inttoptr (i32 1344274640 to ptr), align 16, !tbaa !3
  store volatile i32 1074803727, ptr inttoptr (i32 1344274652 to ptr), align 4, !tbaa !3
  store volatile i32 7, ptr inttoptr (i32 1344274648 to ptr), align 8, !tbaa !3
  store volatile i32 2048000, ptr inttoptr (i32 1344274656 to ptr), align 32, !tbaa !3
  store volatile i32 46080, ptr inttoptr (i32 1344274660 to ptr), align 4, !tbaa !3
  store volatile i32 805437440, ptr inttoptr (i32 1344274664 to ptr), align 8, !tbaa !3
  store volatile i32 536883200, ptr inttoptr (i32 1344274676 to ptr), align 4, !tbaa !3
  store volatile i32 8, ptr inttoptr (i32 1344274672 to ptr), align 16, !tbaa !3
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #7
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
  store i32 0, ptr @sw_step, align 4, !tbaa !3
  tail call fastcc void @tone_set(i32 noundef %0, i32 noundef %1) #8
  store i32 %2, ptr @snd_frames, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tone_set(i32 noundef %0, i32 noundef %1) unnamed_addr #1 {
  %3 = icmp ult i32 %0, 217
  br i1 %3, label %14, label %4

4:                                                ; preds = %2
  %5 = icmp ult i32 %0, 433
  br i1 %5, label %14, label %6

6:                                                ; preds = %4
  %7 = icmp ult i32 %0, 865
  br i1 %7, label %14, label %8

8:                                                ; preds = %6
  %9 = icmp ult i32 %0, 1728
  br i1 %9, label %14, label %10

10:                                               ; preds = %8
  %11 = icmp ult i32 %0, 3455
  %12 = select i1 %11, i32 4, i32 3
  %13 = select i1 %11, i32 8, i32 4
  br label %14

14:                                               ; preds = %10, %8, %6, %4, %2
  %15 = phi i32 [ 8, %2 ], [ 7, %4 ], [ 6, %6 ], [ 5, %8 ], [ %12, %10 ]
  %16 = phi i32 [ 128, %2 ], [ 64, %4 ], [ 32, %6 ], [ 16, %8 ], [ %13, %10 ]
  %17 = lshr i32 1000000000, %15
  %18 = udiv i32 %17, %0
  %19 = tail call i32 @llvm.umax.i32(i32 %18, i32 19875)
  %20 = tail call i32 @llvm.umin.i32(i32 %19, i32 32875)
  %21 = shl nuw nsw i32 %20, 8
  store volatile i32 %21, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  %22 = shl i32 %1, 6
  %23 = and i32 %22, 65472
  %24 = mul nuw i32 %23, 65537
  br label %25

25:                                               ; preds = %33, %14
  %26 = phi i32 [ 0, %14 ], [ %35, %33 ]
  %27 = icmp eq i32 %26, %16
  br i1 %27, label %28, label %33

28:                                               ; preds = %25
  %29 = sub i32 0, %22
  %30 = and i32 %29, 65472
  %31 = mul nuw i32 %30, 65537
  %32 = shl nuw nsw i32 %16, 1
  br label %36

33:                                               ; preds = %25
  %34 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537100288 to ptr), i32 %26
  store volatile i32 %24, ptr %34, align 4, !tbaa !3
  %35 = add nuw nsw i32 %26, 1
  br label %25, !llvm.loop !13

36:                                               ; preds = %28, %41
  %37 = phi i32 [ %43, %41 ], [ %16, %28 ]
  %38 = icmp samesign ult i32 %37, %32
  br i1 %38, label %41, label %39

39:                                               ; preds = %36
  %40 = shl nuw nsw i32 %16, 3
  br label %44

41:                                               ; preds = %36
  %42 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537100288 to ptr), i32 %37
  store volatile i32 %31, ptr %42, align 4, !tbaa !3
  %43 = add nuw nsw i32 %37, 1
  br label %36, !llvm.loop !14

44:                                               ; preds = %48, %39
  %45 = phi i32 [ %40, %39 ], [ %50, %48 ]
  %46 = icmp ult i32 %45, 16384
  br i1 %46, label %48, label %47

47:                                               ; preds = %44
  ret void

48:                                               ; preds = %44
  %49 = or disjoint i32 %45, 537100288
  tail call void @gdma_copy(i32 noundef %49, i32 noundef 537100288, i32 noundef %45) #7
  %50 = shl nuw nsw i32 %45, 1
  br label %44, !llvm.loop !15
}

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_sweep(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  store i32 %0, ptr @sw_hz, align 4, !tbaa !3
  store i32 %1, ptr @sw_vol, align 4, !tbaa !3
  store i32 %3, ptr @sw_step, align 4, !tbaa !3
  tail call fastcc void @tone_set(i32 noundef %0, i32 noundef %1) #8
  store i32 %2, ptr @snd_frames, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_noise(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  store i32 0, ptr @sw_step, align 4, !tbaa !3
  store volatile i32 8416000, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  %3 = shl i32 %0, 6
  %4 = sub i32 0, %3
  br label %5

5:                                                ; preds = %18, %2
  %6 = phi i32 [ 0, %2 ], [ %30, %18 ]
  %7 = phi i32 [ 48879, %2 ], [ %29, %18 ]
  %8 = icmp samesign ult i32 %6, 1024
  br i1 %8, label %9, label %34

9:                                                ; preds = %5
  %10 = icmp samesign ult i32 %7, 32768
  %11 = select i1 %10, i32 %4, i32 %3
  %12 = and i32 %11, 65472
  %13 = mul nuw i32 %12, 65537
  %14 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537100288 to ptr), i32 %6
  br label %15

15:                                               ; preds = %31, %9
  %16 = phi i32 [ 0, %9 ], [ %33, %31 ]
  %17 = icmp eq i32 %16, 16
  br i1 %17, label %18, label %31

18:                                               ; preds = %15
  %19 = shl nuw nsw i32 %7, 2
  %20 = shl nuw nsw i32 %7, 3
  %21 = shl nuw nsw i32 %7, 5
  %22 = xor i32 %20, %19
  %23 = xor i32 %22, %21
  %24 = xor i32 %23, %7
  %25 = shl nuw nsw i32 %7, 1
  %26 = lshr i32 %24, 15
  %27 = and i32 %26, 1
  %28 = and i32 %25, 65534
  %29 = or disjoint i32 %27, %28
  %30 = add nuw nsw i32 %6, 16
  br label %5, !llvm.loop !16

31:                                               ; preds = %15
  %32 = getelementptr inbounds nuw i32, ptr %14, i32 %16
  store volatile i32 %13, ptr %32, align 4, !tbaa !3
  %33 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !17

34:                                               ; preds = %5, %38
  %35 = phi i32 [ %40, %38 ], [ 4096, %5 ]
  %36 = icmp ult i32 %35, 16384
  br i1 %36, label %38, label %37

37:                                               ; preds = %34
  store i32 %1, ptr @snd_frames, align 4, !tbaa !3
  ret void

38:                                               ; preds = %34
  %39 = or disjoint i32 %35, 537100288
  tail call void @gdma_copy(i32 noundef %39, i32 noundef 537100288, i32 noundef %35) #7
  %40 = shl nuw nsw i32 %35, 1
  br label %34, !llvm.loop !18
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @pcm_play(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  tail call void @gd_wait() #7
  tail call void @snd_off() #8
  store volatile i32 5804800, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !3
  %3 = load i32, ptr @sndctrl, align 4, !tbaa !3
  %4 = and i32 %3, -2
  store volatile i32 %4, ptr inttoptr (i32 1342177872 to ptr), align 16, !tbaa !3
  store volatile i32 %0, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 1344274448, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  store volatile i32 %1, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %5 = load i32, ptr @spictrl, align 4, !tbaa !3
  %6 = and i32 %5, -2064385
  store volatile i32 %6, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  store i1 true, ptr @pcm_active, align 4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gd_wait() local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_off() local_unnamed_addr #1 {
  store i32 0, ptr @snd_frames, align 4, !tbaa !3
  store i32 0, ptr @sw_step, align 4, !tbaa !3
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #7
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @pcm_stop() local_unnamed_addr #0 {
  %1 = load i1, ptr @pcm_active, align 4
  br i1 %1, label %2, label %9

2:                                                ; preds = %0
  store volatile i32 0, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !3
  store volatile i32 2048, ptr inttoptr (i32 1342178372 to ptr), align 4, !tbaa !3
  br label %3

3:                                                ; preds = %3, %2
  %4 = load volatile i32, ptr inttoptr (i32 1342178372 to ptr), align 4, !tbaa !3
  %5 = and i32 %4, 2048
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !19

7:                                                ; preds = %3
  %8 = load i32, ptr @sndctrl, align 4, !tbaa !3
  store volatile i32 %8, ptr inttoptr (i32 1342177872 to ptr), align 16, !tbaa !3
  store i1 false, ptr @pcm_active, align 4
  br label %9

9:                                                ; preds = %0, %7
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @pcm_tick() local_unnamed_addr #0 {
  %1 = load i1, ptr @pcm_active, align 4
  br i1 %1, label %2, label %6

2:                                                ; preds = %0
  %3 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  tail call void @pcm_stop() #8
  br label %6

6:                                                ; preds = %5, %2, %0
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_tick() local_unnamed_addr #1 {
  %1 = load i32, ptr @snd_frames, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %17, label %3

3:                                                ; preds = %0
  %4 = add i32 %1, -1
  store i32 %4, ptr @snd_frames, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  store i32 0, ptr @sw_step, align 4, !tbaa !3
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #7
  br label %17

7:                                                ; preds = %3
  %8 = load i32, ptr @sw_step, align 4, !tbaa !3
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %17, label %10

10:                                               ; preds = %7
  %11 = load i32, ptr @sw_hz, align 4, !tbaa !3
  %12 = add i32 %8, 60
  %13 = icmp ugt i32 %11, %12
  %14 = sub i32 %11, %8
  %15 = select i1 %13, i32 %14, i32 60
  store i32 %15, ptr @sw_hz, align 4, !tbaa !3
  %16 = load i32, ptr @sw_vol, align 4, !tbaa !3
  tail call fastcc void @tone_set(i32 noundef %15, i32 noundef %16) #8
  br label %17

17:                                               ; preds = %7, %10, %0, %6
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @led(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  store i32 %0, ptr @led_base0, align 4, !tbaa !3
  store i32 %1, ptr @led_base1, align 4, !tbaa !3
  %3 = load i32, ptr @leda_mode, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  tail call fastcc void @led_raw(i32 noundef %0, i32 noundef %1) #8
  br label %6

6:                                                ; preds = %5, %2
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @led_raw(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = alloca [2 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #9
  %4 = tail call fastcc i32 @led_capc(i32 noundef %0) #8
  store i32 %4, ptr %3, align 4, !tbaa !3
  %5 = tail call fastcc i32 @led_capc(i32 noundef %1) #8
  %6 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store i32 %5, ptr %6, align 4, !tbaa !3
  br label %7

7:                                                ; preds = %18, %2
  %8 = phi i32 [ 0, %2 ], [ %27, %18 ]
  %9 = icmp eq i32 %8, 2
  br i1 %9, label %10, label %11

10:                                               ; preds = %7
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #9
  ret void

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw [2 x i32], ptr %3, i32 0, i32 %8
  %13 = load i32, ptr %12, align 4, !tbaa !3
  br label %14

14:                                               ; preds = %14, %11
  %15 = load volatile i32, ptr inttoptr (i32 1344274436 to ptr), align 4, !tbaa !3
  %16 = and i32 %15, 131072
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %14, !llvm.loop !20

18:                                               ; preds = %14
  %19 = shl i32 %13, 8
  %20 = and i32 %19, 16711680
  %21 = lshr i32 %13, 8
  %22 = and i32 %21, 65280
  %23 = or disjoint i32 %20, %22
  %24 = and i32 %13, 255
  %25 = or disjoint i32 %23, %24
  %26 = shl nuw i32 %25, 8
  store volatile i32 %26, ptr inttoptr (i32 1344274452 to ptr), align 4, !tbaa !3
  %27 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !21
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
define dso_local void @led_rainbow(i32 noundef %0) local_unnamed_addr #4 {
  store i32 1, ptr @leda_mode, align 4, !tbaa !3
  store i32 %0, ptr @leda_n, align 4, !tbaa !3
  store i32 0, ptr @leda_hue, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
define dso_local void @led_blink(i32 noundef %0, i32 noundef %1) local_unnamed_addr #4 {
  store i32 2, ptr @leda_mode, align 4, !tbaa !3
  store i32 %0, ptr @leda_rgb, align 4, !tbaa !3
  %3 = shl i32 %1, 3
  store i32 %3, ptr @leda_n, align 4, !tbaa !3
  store i32 0, ptr @leda_phase, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @led_tick() local_unnamed_addr #0 {
  %1 = load i32, ptr @leda_mode, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %48, label %3

3:                                                ; preds = %0
  %4 = load i32, ptr @leda_n, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  store i32 0, ptr @leda_mode, align 4, !tbaa !3
  %7 = load i32, ptr @led_base0, align 4, !tbaa !3
  %8 = load i32, ptr @led_base1, align 4, !tbaa !3
  tail call fastcc void @led_raw(i32 noundef %7, i32 noundef %8) #8
  br label %48

9:                                                ; preds = %3
  %10 = add i32 %4, -1
  store i32 %10, ptr @leda_n, align 4, !tbaa !3
  %11 = icmp eq i32 %1, 1
  br i1 %11, label %12, label %22

12:                                               ; preds = %9
  %13 = load i32, ptr @leda_hue, align 4, !tbaa !3
  %14 = add i32 %13, 17
  store i32 %14, ptr @leda_hue, align 4, !tbaa !3
  %15 = tail call fastcc i32 @wheel(i32 noundef %14) #8
  %16 = lshr i32 %15, 2
  %17 = and i32 %16, 4144959
  %18 = add i32 %13, 145
  %19 = tail call fastcc i32 @wheel(i32 noundef %18) #8
  %20 = lshr i32 %19, 2
  %21 = and i32 %20, 4144959
  tail call fastcc void @led_raw(i32 noundef %17, i32 noundef %21) #8
  br label %48

22:                                               ; preds = %9
  %23 = load i32, ptr @leda_phase, align 4, !tbaa !3
  %24 = icmp eq i32 %23, 7
  %25 = add i32 %23, 1
  %26 = select i1 %24, i32 0, i32 %25
  store i32 %26, ptr @leda_phase, align 4, !tbaa !3
  %27 = icmp ult i32 %23, 4
  %28 = sub i32 8, %23
  %29 = select i1 %27, i32 %23, i32 %28
  %30 = load i32, ptr @leda_rgb, align 4, !tbaa !3
  switch i32 %29, label %43 [
    i32 0, label %46
    i32 1, label %31
    i32 2, label %34
    i32 3, label %37
  ]

31:                                               ; preds = %22
  %32 = lshr i32 %30, 4
  %33 = and i32 %32, 986895
  br label %46

34:                                               ; preds = %22
  %35 = lshr i32 %30, 3
  %36 = and i32 %35, 2039583
  br label %46

37:                                               ; preds = %22
  %38 = lshr i32 %30, 3
  %39 = and i32 %38, 2039583
  %40 = lshr i32 %30, 4
  %41 = and i32 %40, 986895
  %42 = add nuw nsw i32 %39, %41
  br label %46

43:                                               ; preds = %22
  %44 = lshr i32 %30, 2
  %45 = and i32 %44, 4144959
  br label %46

46:                                               ; preds = %22, %31, %34, %37, %43
  %47 = phi i32 [ %33, %31 ], [ %36, %34 ], [ %42, %37 ], [ %45, %43 ], [ %29, %22 ]
  tail call fastcc void @led_raw(i32 noundef %47, i32 noundef %47) #8
  br label %48

48:                                               ; preds = %0, %6, %46, %12
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 16711680) i32 @wheel(i32 noundef %0) unnamed_addr #5 {
  %2 = and i32 %0, 255
  %3 = icmp samesign ult i32 %2, 128
  %4 = shl nuw nsw i32 %2, 17
  %5 = xor i32 %4, 33423360
  %6 = select i1 %3, i32 %4, i32 %5
  %7 = add i32 %0, 85
  %8 = and i32 %7, 255
  %9 = icmp samesign ult i32 %8, 128
  %10 = shl nuw nsw i32 %8, 9
  %11 = xor i32 %10, 130560
  %12 = select i1 %9, i32 %10, i32 %11
  %13 = or disjoint i32 %12, %6
  %14 = add i32 %0, 170
  %15 = and i32 %14, 255
  %16 = icmp samesign ult i32 %15, 128
  %17 = shl nuw nsw i32 %15, 1
  %18 = xor i32 %17, 510
  %19 = select i1 %16, i32 %17, i32 %18
  %20 = or disjoint i32 %13, %19
  ret i32 %20
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 6324224) i32 @led_capc(i32 noundef %0) unnamed_addr #5 {
  %2 = lshr i32 %0, 16
  %3 = and i32 %2, 255
  %4 = lshr i32 %0, 8
  %5 = and i32 %4, 255
  %6 = and i32 %0, 255
  %7 = tail call i32 @llvm.umin.i32(i32 %3, i32 96)
  %8 = tail call i32 @llvm.umin.i32(i32 %5, i32 96)
  %9 = tail call i32 @llvm.umin.i32(i32 %6, i32 96)
  %10 = shl nuw nsw i32 %7, 16
  %11 = shl nuw nsw i32 %8, 8
  %12 = or disjoint i32 %10, %11
  %13 = or disjoint i32 %12, %9
  ret i32 %13
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #6

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #6

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }
attributes #9 = { nounwind }

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
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
