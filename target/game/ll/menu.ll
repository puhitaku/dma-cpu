; ModuleID = 'menu.c'
source_filename = "menu.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [9 x i8] c"DMA PICO\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Enjoy purely DMA-coded games\00", align 1
@top = internal unnamed_addr global i32 0, align 4
@.str.2 = private unnamed_addr constant [28 x i8] c"up/down: pick   press: play\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"menu up\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.4 = private unnamed_addr constant [7 x i8] c"menu: \00", align 1
@names = internal unnamed_addr constant [10 x ptr] [ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21], align 4
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"start: \00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"beat \00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"^\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"v\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c">\00", align 1
@.str.12 = private unnamed_addr constant [9 x i8] c"Dinosaur\00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"LANWalk\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"Yacht\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"Sequencer\00", align 1
@.str.16 = private unnamed_addr constant [10 x i8] c"Benchmark\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c"Radiosity\00", align 1
@.str.18 = private unnamed_addr constant [9 x i8] c"Arm info\00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"Boing\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"Parachute\00", align 1
@.str.21 = private unnamed_addr constant [10 x i8] c"Puni Puni\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @menu_run() local_unnamed_addr #0 {
  tail call void @gfx_clear(i16 noundef zeroext 2181) #3
  tail call void @gfx_text2(i32 noundef 56, i32 noundef 24, ptr noundef nonnull @.str, i16 noundef zeroext -377, i16 noundef zeroext 2181) #3
  tail call void @gfx_fill(i32 noundef 56, i32 noundef 44, i32 noundef 128, i32 noundef 2, i16 noundef zeroext -377) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 58, ptr noundef nonnull @.str.1, i16 noundef zeroext -18950, i16 noundef zeroext 2181) #3
  store i32 0, ptr @top, align 4, !tbaa !3
  tail call fastcc void @draw_window(i32 noundef 0) #4
  tail call void @gfx_text(i32 noundef 12, i32 noundef 226, ptr noundef nonnull @.str.2, i16 noundef zeroext 23344, i16 noundef zeroext 2181) #3
  tail call void @gfx_present() #3
  tail call void @led(i32 noundef 1039, i32 noundef 1039) #3
  tail call void @uputs(ptr noundef nonnull @.str.3) #3
  %1 = tail call i32 @now_us() #3
  br label %2

2:                                                ; preds = %44, %0
  %3 = phi i32 [ %20, %44 ], [ 0, %0 ]
  %4 = phi i32 [ %46, %44 ], [ 0, %0 ]
  %5 = phi i32 [ %45, %44 ], [ %1, %0 ]
  br label %6

6:                                                ; preds = %2, %40
  %7 = phi i32 [ %20, %40 ], [ %3, %2 ]
  tail call void @frame_sync(i32 noundef 33000) #3
  tail call void @in_poll() #3
  %8 = load i32, ptr @in_edge, align 4, !tbaa !3
  %9 = and i32 %8, 1
  %10 = icmp eq i32 %9, 0
  %11 = icmp eq i32 %7, 0
  %12 = add nsw i32 %7, -1
  %13 = select i1 %11, i32 9, i32 %12
  %14 = select i1 %10, i32 %7, i32 %13
  %15 = and i32 %8, 2
  %16 = icmp eq i32 %15, 0
  %17 = icmp eq i32 %14, 9
  %18 = add nsw i32 %14, 1
  %19 = select i1 %17, i32 0, i32 %18
  %20 = select i1 %16, i32 %14, i32 %19
  %21 = icmp eq i32 %20, %7
  br i1 %21, label %36, label %22

22:                                               ; preds = %6
  %23 = load i32, ptr @top, align 4, !tbaa !3
  %24 = tail call i32 @llvm.smin.i32(i32 %20, i32 %23)
  %25 = add nsw i32 %24, 5
  %26 = icmp sgt i32 %20, %25
  %27 = add nsw i32 %20, -5
  %28 = select i1 %26, i32 %27, i32 %24
  %29 = icmp eq i32 %28, %23
  br i1 %29, label %31, label %30

30:                                               ; preds = %22
  store i32 %28, ptr @top, align 4, !tbaa !3
  tail call fastcc void @draw_window(i32 noundef %20) #4
  br label %32

31:                                               ; preds = %22
  tail call fastcc void @draw_row(i32 noundef %7, i32 noundef 0) #4
  tail call fastcc void @draw_row(i32 noundef %20, i32 noundef 1) #4
  br label %32

32:                                               ; preds = %31, %30
  tail call void @gfx_present() #3
  tail call void @snd_play(i32 noundef 700, i32 noundef 40, i32 noundef 2) #3
  tail call void @uputs(ptr noundef nonnull @.str.4) #3
  %33 = getelementptr inbounds [10 x ptr], ptr @names, i32 0, i32 %20
  %34 = load ptr, ptr %33, align 4, !tbaa !7
  tail call void @uputs(ptr noundef %34) #3
  tail call void @uputs(ptr noundef nonnull @.str.5) #3
  %35 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %36

36:                                               ; preds = %32, %6
  %37 = phi i32 [ %35, %32 ], [ %8, %6 ]
  %38 = and i32 %37, 16
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %40, label %47

40:                                               ; preds = %36
  %41 = tail call i32 @now_us() #3
  %42 = sub i32 %41, %5
  %43 = icmp ugt i32 %42, 999999
  br i1 %43, label %44, label %6, !llvm.loop !10

44:                                               ; preds = %40
  %45 = add i32 %5, 1000000
  %46 = add i32 %4, 1
  tail call void @uputs(ptr noundef nonnull @.str.7) #3
  tail call void @uputn(i32 noundef %46) #3
  tail call void @uputs(ptr noundef nonnull @.str.5) #3
  br label %2, !llvm.loop !10

47:                                               ; preds = %36
  tail call void @led(i32 noundef 16144, i32 noundef 16144) #3
  tail call void @uputs(ptr noundef nonnull @.str.6) #3
  %48 = getelementptr inbounds [10 x ptr], ptr @names, i32 0, i32 %20
  %49 = load ptr, ptr %48, align 4, !tbaa !7
  tail call void @uputs(ptr noundef %49) #3
  tail call void @uputs(ptr noundef nonnull @.str.5) #3
  tail call void @snd_play(i32 noundef 523, i32 noundef 55, i32 noundef 255) #3
  tail call void @delay_us(i32 noundef 55000) #3
  tail call void @snd_play(i32 noundef 659, i32 noundef 55, i32 noundef 255) #3
  tail call void @delay_us(i32 noundef 55000) #3
  tail call void @snd_play(i32 noundef 784, i32 noundef 55, i32 noundef 255) #3
  tail call void @delay_us(i32 noundef 90000) #3
  tail call void @snd_off() #3
  ret i32 %20
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_window(i32 noundef %0) unnamed_addr #0 {
  %2 = load i32, ptr @top, align 4, !tbaa !3
  br label %3

3:                                                ; preds = %14, %1
  %4 = phi i32 [ %2, %1 ], [ %18, %14 ]
  %5 = phi i32 [ %2, %1 ], [ %17, %14 ]
  %6 = add nsw i32 %4, 6
  %7 = icmp slt i32 %5, %6
  br i1 %7, label %14, label %8

8:                                                ; preds = %3
  %9 = icmp sgt i32 %4, 0
  %10 = select i1 %9, ptr @.str.8, ptr @.str.9
  tail call void @gfx_text(i32 noundef 216, i32 noundef 80, ptr noundef nonnull %10, i16 noundef zeroext 23344, i16 noundef zeroext 2181) #3
  %11 = load i32, ptr @top, align 4, !tbaa !3
  %12 = icmp slt i32 %11, 4
  %13 = select i1 %12, ptr @.str.10, ptr @.str.9
  tail call void @gfx_text(i32 noundef 216, i32 noundef 190, ptr noundef nonnull %13, i16 noundef zeroext 23344, i16 noundef zeroext 2181) #3
  ret void

14:                                               ; preds = %3
  %15 = icmp eq i32 %5, %0
  %16 = zext i1 %15 to i32
  tail call fastcc void @draw_row(i32 noundef %5, i32 noundef %16) #4
  %17 = add nsw i32 %5, 1
  %18 = load i32, ptr @top, align 4, !tbaa !3
  br label %3, !llvm.loop !12
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_row(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = load i32, ptr @top, align 4, !tbaa !3
  %4 = sub nsw i32 %0, %3
  %5 = mul nsw i32 %4, 24
  %6 = add nsw i32 %5, 76
  %7 = icmp eq i32 %1, 0
  %8 = select i1 %7, i16 2181, i16 10801
  tail call void @gfx_fill(i32 noundef 32, i32 noundef %6, i32 noundef 176, i32 noundef 22, i16 noundef zeroext %8) #3
  br i1 %7, label %11, label %9

9:                                                ; preds = %2
  %10 = add nsw i32 %5, 83
  tail call void @gfx_text(i32 noundef 44, i32 noundef %10, ptr noundef nonnull @.str.11, i16 noundef zeroext -377, i16 noundef zeroext 10801) #3
  br label %11

11:                                               ; preds = %9, %2
  %12 = phi i16 [ -1, %9 ], [ -18950, %2 ]
  %13 = add nsw i32 %5, 79
  %14 = getelementptr inbounds [10 x ptr], ptr @names, i32 0, i32 %0
  %15 = load ptr, ptr %14, align 4, !tbaa !7
  tail call void @gfx_text2(i32 noundef 60, i32 noundef %13, ptr noundef %15, i16 noundef zeroext %12, i16 noundef zeroext %8) #3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @delay_us(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #2

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"p1 omnipotent char", !9, i64 0}
!9 = !{!"any pointer", !5, i64 0}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !13, !11}
!13 = !{!"llvm.loop.mustprogress"}
