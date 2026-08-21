; ModuleID = 'cpumon.c'
source_filename = "cpumon.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [12 x i8] c"cpumon: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"CPU ASLEEP\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"CORE 0\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"wfi\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"CORE 1\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"reset\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"Idle for:\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"CPU program:\00", align 1
@.str.8 = private unnamed_addr constant [22 x i8] c"  cpsid i; wfi; b .-1\00", align 1
@.str.9 = private unnamed_addr constant [25 x i8] c"3 instructions, forever.\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"press: back\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.11 = private unnamed_addr constant [14 x i8] c"cpumon: back\0A\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"Z\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @cpumon_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #3
  tail call void @led(i32 noundef 1039, i32 noundef 1039) #3
  tail call void @gfx_clear(i16 noundef zeroext 2147) #3
  tail call void @gfx_text2(i32 noundef 32, i32 noundef 6, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 2147) #3
  tail call fastcc void @draw_chip(i32 noundef 24) #4
  tail call fastcc void @draw_chip(i32 noundef 140) #4
  tail call void @gfx_text(i32 noundef 38, i32 noundef 118, ptr noundef nonnull @.str.2, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 48, i32 noundef 130, ptr noundef nonnull @.str.3, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 154, i32 noundef 118, ptr noundef nonnull @.str.4, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 158, i32 noundef 130, ptr noundef nonnull @.str.5, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 150, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 174, ptr noundef nonnull @.str.7, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 186, ptr noundef nonnull @.str.8, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 198, ptr noundef nonnull @.str.9, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 220, ptr noundef nonnull @.str.10, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #3
  %1 = tail call i32 @now_us() #3
  %2 = load volatile i32, ptr inttoptr (i32 537120768 to ptr), align 4096, !tbaa !3
  %3 = icmp eq i32 %2, 1374590208
  br i1 %3, label %4, label %9

4:                                                ; preds = %0
  %5 = tail call i32 @now_us() #3
  %6 = load volatile i32, ptr inttoptr (i32 537120772 to ptr), align 4, !tbaa !3
  %7 = sub i32 %5, %6
  %8 = udiv i32 %7, 1000000
  br label %9

9:                                                ; preds = %4, %0
  %10 = phi i32 [ 0, %0 ], [ %8, %4 ]
  br label %11

11:                                               ; preds = %9, %35
  %12 = phi i32 [ %37, %35 ], [ %10, %9 ]
  %13 = phi i32 [ %36, %35 ], [ 0, %9 ]
  %14 = phi i32 [ %31, %35 ], [ %1, %9 ]
  %15 = phi i32 [ %25, %35 ], [ 0, %9 ]
  tail call fastcc void @draw_idle(i32 noundef %12) #4
  tail call void @gfx_present() #3
  br label %16

16:                                               ; preds = %11, %30
  %17 = phi i32 [ %33, %30 ], [ %13, %11 ]
  %18 = phi i32 [ %31, %30 ], [ %14, %11 ]
  %19 = phi i32 [ %25, %30 ], [ %15, %11 ]
  tail call void @frame_sync(i32 noundef 33000) #3
  tail call void @in_poll() #3
  %20 = load i32, ptr @in_edge, align 4, !tbaa !3
  %21 = and i32 %20, 31
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %24, label %23

23:                                               ; preds = %16
  tail call void @led(i32 noundef 0, i32 noundef 0) #3
  tail call void @uputs(ptr noundef nonnull @.str.11) #3
  ret void

24:                                               ; preds = %16
  %25 = add i32 %19, 1
  %26 = and i32 %25, 3
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  tail call fastcc void @draw_zzz(i32 noundef 70, i32 noundef %25) #4
  %29 = add i32 %19, 17
  tail call fastcc void @draw_zzz(i32 noundef 182, i32 noundef %29) #4
  tail call void @gfx_present() #3
  br label %30

30:                                               ; preds = %28, %24
  %31 = tail call i32 @now_us() #3
  %32 = sub i32 %31, %18
  %33 = add i32 %32, %17
  %34 = icmp ugt i32 %33, 999999
  br i1 %34, label %35, label %16, !llvm.loop !7

35:                                               ; preds = %30
  %36 = add i32 %33, -1000000
  %37 = add i32 %12, 1
  br label %11, !llvm.loop !7
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_chip(i32 noundef range(i32 24, 141) %0) unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef %0, i32 noundef 52, i32 noundef 76, i32 noundef 60, i16 noundef zeroext 10601) #3
  tail call void @gfx_rect(i32 noundef %0, i32 noundef 52, i32 noundef 76, i32 noundef 60, i32 noundef 2, i16 noundef zeroext 23346) #3
  %2 = add nsw i32 %0, -5
  %3 = add nuw nsw i32 %0, 76
  br label %4

4:                                                ; preds = %9, %1
  %5 = phi i32 [ 0, %1 ], [ %12, %9 ]
  %6 = icmp eq i32 %5, 4
  br i1 %6, label %7, label %9

7:                                                ; preds = %4
  %8 = add nuw nsw i32 %0, 18
  br label %13

9:                                                ; preds = %4
  %10 = mul nuw nsw i32 %5, 12
  %11 = add nuw nsw i32 %10, 62
  tail call void @gfx_fill(i32 noundef %2, i32 noundef %11, i32 noundef 5, i32 noundef 6, i16 noundef zeroext -27441) #3
  tail call void @gfx_fill(i32 noundef %3, i32 noundef %11, i32 noundef 5, i32 noundef 6, i16 noundef zeroext -27441) #3
  %12 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !9

13:                                               ; preds = %7, %18
  %14 = phi i32 [ %23, %18 ], [ 0, %7 ]
  %15 = icmp eq i32 %14, 2
  br i1 %15, label %16, label %18

16:                                               ; preds = %13
  %17 = add nuw nsw i32 %0, 33
  tail call void @gfx_fill(i32 noundef %17, i32 noundef 92, i32 noundef 10, i32 noundef 7, i16 noundef zeroext 4261) #3
  tail call void @gfx_rect(i32 noundef %17, i32 noundef 92, i32 noundef 10, i32 noundef 7, i32 noundef 1, i16 noundef zeroext -8418) #3
  ret void

18:                                               ; preds = %13
  %19 = mul nuw nsw i32 %14, 30
  %20 = add nuw nsw i32 %8, %19
  tail call void @gfx_fill(i32 noundef %20, i32 noundef 78, i32 noundef 3, i32 noundef 2, i16 noundef zeroext -8418) #3
  %21 = add nuw nsw i32 %20, 3
  tail call void @gfx_fill(i32 noundef %21, i32 noundef 80, i32 noundef 6, i32 noundef 2, i16 noundef zeroext -8418) #3
  %22 = add nuw nsw i32 %20, 9
  tail call void @gfx_fill(i32 noundef %22, i32 noundef 78, i32 noundef 3, i32 noundef 2, i16 noundef zeroext -8418) #3
  %23 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !11
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_idle(i32 noundef %0) unnamed_addr #0 {
  %2 = alloca [6 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %2) #5
  %3 = udiv i32 %0, 60
  %4 = mul i32 %3, 60
  %5 = sub i32 %0, %4
  %6 = udiv i32 %0, 600
  %7 = urem i32 %6, 10
  %8 = trunc nuw nsw i32 %7 to i8
  %9 = or disjoint i8 %8, 48
  store i8 %9, ptr %2, align 1, !tbaa !12
  %10 = urem i32 %3, 10
  %11 = trunc nuw nsw i32 %10 to i8
  %12 = or disjoint i8 %11, 48
  %13 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 %12, ptr %13, align 1, !tbaa !12
  %14 = getelementptr inbounds nuw i8, ptr %2, i32 2
  store i8 58, ptr %14, align 1, !tbaa !12
  %15 = trunc nuw nsw i32 %5 to i8
  %16 = udiv i8 %15, 10
  %17 = or disjoint i8 %16, 48
  %18 = getelementptr inbounds nuw i8, ptr %2, i32 3
  store i8 %17, ptr %18, align 1, !tbaa !12
  %19 = mul i8 %16, 10
  %20 = sub i8 %15, %19
  %21 = or disjoint i8 %20, 48
  %22 = getelementptr inbounds nuw i8, ptr %2, i32 4
  store i8 %21, ptr %22, align 1, !tbaa !12
  %23 = getelementptr inbounds nuw i8, ptr %2, i32 5
  store i8 0, ptr %23, align 1, !tbaa !12
  tail call void @gfx_fill(i32 noundef 100, i32 noundef 146, i32 noundef 80, i32 noundef 16, i16 noundef zeroext 2147) #3
  call void @gfx_text2(i32 noundef 100, i32 noundef 146, ptr noundef nonnull %2, i16 noundef zeroext 24465, i16 noundef zeroext 2147) #3
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %2) #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_zzz(i32 noundef range(i32 70, 183) %0, i32 noundef %1) unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef %0, i32 noundef 24, i32 noundef 40, i32 noundef 27, i16 noundef zeroext 2147) #3
  %3 = lshr i32 %1, 3
  %4 = and i32 %3, 3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %13, label %6

6:                                                ; preds = %2
  tail call void @gfx_text(i32 noundef %0, i32 noundef 42, ptr noundef nonnull @.str.12, i16 noundef zeroext 32351, i16 noundef zeroext 2147) #3
  %7 = icmp eq i32 %4, 1
  br i1 %7, label %13, label %8

8:                                                ; preds = %6
  %9 = add nuw nsw i32 %0, 11
  tail call void @gfx_text(i32 noundef %9, i32 noundef 33, ptr noundef nonnull @.str.13, i16 noundef zeroext 32351, i16 noundef zeroext 2147) #3
  %10 = icmp eq i32 %4, 3
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  %12 = add nuw nsw i32 %0, 22
  tail call void @gfx_text2(i32 noundef %12, i32 noundef 24, ptr noundef nonnull @.str.13, i16 noundef zeroext 32351, i16 noundef zeroext 2147) #3
  br label %13

13:                                               ; preds = %2, %6, %11, %8
  %14 = add nuw nsw i32 %0, 39
  tail call void @gfx_damage(i32 noundef %0, i32 noundef 24, i32 noundef %14, i32 noundef 50) #3
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = distinct !{!9, !10, !8}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10, !8}
!12 = !{!5, !5, i64 0}
