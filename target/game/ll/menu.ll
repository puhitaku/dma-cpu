; ModuleID = 'menu.c'
source_filename = "menu.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [9 x i8] c"DMA PICO\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Enjoy purely DMA-coded games\00", align 1
@.str.2 = private unnamed_addr constant [28 x i8] c"up/down: pick   press: play\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"menu up\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.4 = private unnamed_addr constant [7 x i8] c"menu: \00", align 1
@names = internal unnamed_addr constant [5 x ptr] [ptr @.str.9, ptr @.str.10, ptr @.str.11, ptr @.str.12, ptr @.str.13], align 4
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"start: \00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"beat \00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c">\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"Dinosaur\00", align 1
@.str.10 = private unnamed_addr constant [8 x i8] c"LANWalk\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"Yacht\00", align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"Sequencer\00", align 1
@.str.13 = private unnamed_addr constant [9 x i8] c"Arm info\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @menu_run() local_unnamed_addr #0 {
  tail call void @gfx_clear(i16 noundef zeroext 2181) #2
  tail call void @gfx_text2(i32 noundef 56, i32 noundef 24, ptr noundef nonnull @.str, i16 noundef zeroext -377, i16 noundef zeroext 2181) #2
  tail call void @gfx_fill(i32 noundef 56, i32 noundef 44, i32 noundef 128, i32 noundef 2, i16 noundef zeroext -377) #2
  tail call void @gfx_text(i32 noundef 8, i32 noundef 58, ptr noundef nonnull @.str.1, i16 noundef zeroext -18950, i16 noundef zeroext 2181) #2
  br label %1

1:                                                ; preds = %10, %0
  %2 = phi i32 [ 0, %0 ], [ %13, %10 ]
  %3 = icmp eq i32 %2, 5
  br i1 %3, label %4, label %10

4:                                                ; preds = %1
  tail call void @gfx_text(i32 noundef 12, i32 noundef 226, ptr noundef nonnull @.str.2, i16 noundef zeroext 23344, i16 noundef zeroext 2181) #2
  tail call void @gfx_present() #2
  tail call void @led(i32 noundef 1039, i32 noundef 1039) #2
  tail call void @uputs(ptr noundef nonnull @.str.3) #2
  %5 = tail call i32 @now_us() #2
  br label %6

6:                                                ; preds = %42, %4
  %7 = phi i32 [ %28, %42 ], [ 0, %4 ]
  %8 = phi i32 [ %44, %42 ], [ 0, %4 ]
  %9 = phi i32 [ %43, %42 ], [ %5, %4 ]
  br label %14

10:                                               ; preds = %1
  %11 = icmp eq i32 %2, 0
  %12 = zext i1 %11 to i32
  tail call fastcc void @draw_item(i32 noundef %2, i32 noundef %12) #3
  %13 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !3

14:                                               ; preds = %6, %38
  %15 = phi i32 [ %28, %38 ], [ %7, %6 ]
  tail call void @frame_sync(i32 noundef 33000) #2
  tail call void @in_poll() #2
  %16 = load i32, ptr @in_edge, align 4, !tbaa !6
  %17 = and i32 %16, 1
  %18 = icmp eq i32 %17, 0
  %19 = icmp eq i32 %15, 0
  %20 = add nsw i32 %15, -1
  %21 = select i1 %19, i32 4, i32 %20
  %22 = select i1 %18, i32 %15, i32 %21
  %23 = and i32 %16, 2
  %24 = icmp eq i32 %23, 0
  %25 = icmp eq i32 %22, 4
  %26 = add nsw i32 %22, 1
  %27 = select i1 %25, i32 0, i32 %26
  %28 = select i1 %24, i32 %22, i32 %27
  %29 = icmp eq i32 %28, %15
  br i1 %29, label %34, label %30

30:                                               ; preds = %14
  tail call fastcc void @draw_item(i32 noundef %15, i32 noundef 0) #3
  tail call fastcc void @draw_item(i32 noundef %28, i32 noundef 1) #3
  tail call void @gfx_present() #2
  tail call void @snd_play(i32 noundef 700, i32 noundef 40, i32 noundef 2) #2
  tail call void @uputs(ptr noundef nonnull @.str.4) #2
  %31 = getelementptr inbounds [5 x ptr], ptr @names, i32 0, i32 %28
  %32 = load ptr, ptr %31, align 4, !tbaa !10
  tail call void @uputs(ptr noundef %32) #2
  tail call void @uputs(ptr noundef nonnull @.str.5) #2
  %33 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %34

34:                                               ; preds = %30, %14
  %35 = phi i32 [ %33, %30 ], [ %16, %14 ]
  %36 = and i32 %35, 16
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %45

38:                                               ; preds = %34
  %39 = tail call i32 @now_us() #2
  %40 = sub i32 %39, %9
  %41 = icmp ugt i32 %40, 999999
  br i1 %41, label %42, label %14, !llvm.loop !13

42:                                               ; preds = %38
  %43 = add i32 %9, 1000000
  %44 = add i32 %8, 1
  tail call void @uputs(ptr noundef nonnull @.str.7) #2
  tail call void @uputn(i32 noundef %44) #2
  tail call void @uputs(ptr noundef nonnull @.str.5) #2
  br label %6, !llvm.loop !13

45:                                               ; preds = %34
  tail call void @led(i32 noundef 16144, i32 noundef 16144) #2
  tail call void @uputs(ptr noundef nonnull @.str.6) #2
  %46 = getelementptr inbounds [5 x ptr], ptr @names, i32 0, i32 %28
  %47 = load ptr, ptr %46, align 4, !tbaa !10
  tail call void @uputs(ptr noundef %47) #2
  tail call void @uputs(ptr noundef nonnull @.str.5) #2
  tail call void @snd_play(i32 noundef 523, i32 noundef 55, i32 noundef 255) #2
  tail call void @delay_us(i32 noundef 55000) #2
  tail call void @snd_play(i32 noundef 659, i32 noundef 55, i32 noundef 255) #2
  tail call void @delay_us(i32 noundef 55000) #2
  tail call void @snd_play(i32 noundef 784, i32 noundef 55, i32 noundef 255) #2
  tail call void @delay_us(i32 noundef 90000) #2
  tail call void @snd_off() #2
  ret i32 %28
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
define internal fastcc void @draw_item(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = mul nsw i32 %0, 27
  %4 = add nsw i32 %3, 84
  %5 = icmp eq i32 %1, 0
  %6 = select i1 %5, i16 2181, i16 10801
  tail call void @gfx_fill(i32 noundef 32, i32 noundef %4, i32 noundef 176, i32 noundef 24, i16 noundef zeroext %6) #2
  br i1 %5, label %9, label %7

7:                                                ; preds = %2
  %8 = add nsw i32 %3, 92
  tail call void @gfx_text(i32 noundef 44, i32 noundef %8, ptr noundef nonnull @.str.8, i16 noundef zeroext -377, i16 noundef zeroext 10801) #2
  br label %9

9:                                                ; preds = %7, %2
  %10 = phi i16 [ -1, %7 ], [ -18950, %2 ]
  %11 = add nsw i32 %3, 88
  %12 = getelementptr inbounds [5 x ptr], ptr @names, i32 0, i32 %0
  %13 = load ptr, ptr %12, align 4, !tbaa !10
  tail call void @gfx_text2(i32 noundef 60, i32 noundef %11, ptr noundef %13, i16 noundef zeroext %10, i16 noundef zeroext %6) #2
  ret void
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

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @delay_us(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #3 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !11, i64 0}
!11 = !{!"p1 omnipotent char", !12, i64 0}
!12 = !{!"any pointer", !8, i64 0}
!13 = distinct !{!13, !5}
