; ModuleID = 'grad.c'
source_filename = "grad.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [10 x i8] c"grad: up\0A\00", align 1
@lo = internal unnamed_addr global i32 0, align 4
@q = internal unnamed_addr global i32 0, align 4
@lbl = internal global [3 x i8] zeroinitializer, align 1
@hdr = internal global [26 x i8] c"press: back  8bit 000-000\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [12 x i8] c"grad: back\0A\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"grad: view \00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @grad_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 1039, i32 noundef 1039) #4
  store i32 0, ptr @lo, align 4, !tbaa !3
  store i32 16, ptr @q, align 4, !tbaa !3
  tail call void @gfx_clear(i16 noundef zeroext 0) #4
  tail call fastcc void @redraw() #5
  br label %1

1:                                                ; preds = %1, %0
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %2 = tail call fastcc i32 @grad_frame() #5
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %1, label %4, !llvm.loop !7

4:                                                ; preds = %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @redraw() unnamed_addr #0 {
  %1 = load i32, ptr @q, align 4, !tbaa !3
  %2 = udiv i32 3932160, %1
  %3 = load i32, ptr @lo, align 4, !tbaa !3
  %4 = lshr i32 %3, 2
  %5 = lshr i32 %3, 3
  %6 = icmp ult i32 %1, 4
  %7 = icmp ult i32 %1, 7
  br label %8

8:                                                ; preds = %36, %0
  %9 = phi i32 [ 0, %0 ], [ %16, %36 ]
  %10 = phi i32 [ 0, %0 ], [ %15, %36 ]
  %11 = phi i32 [ %5, %0 ], [ %39, %36 ]
  %12 = phi i32 [ %4, %0 ], [ %38, %36 ]
  %13 = icmp samesign ult i32 %9, 240
  br i1 %13, label %14, label %40

14:                                               ; preds = %8
  %15 = add i32 %10, %2
  %16 = lshr i32 %15, 16
  %17 = trunc i32 %11 to i16
  %18 = shl i16 %17, 11
  %19 = trunc i32 %12 to i16
  %20 = shl i16 %19, 5
  %21 = sub nsw i32 %16, %9
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 16, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %18) #4
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 72, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %20) #4
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 128, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %17) #4
  %22 = or i16 %18, %17
  %23 = or i16 %22, %20
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 184, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %23) #4
  %24 = icmp samesign ult i32 %9, 223
  %25 = select i1 %7, i1 %24, i1 false
  br i1 %25, label %28, label %26

26:                                               ; preds = %14
  %27 = and i32 %12, 1
  br label %36

28:                                               ; preds = %14
  br i1 %6, label %29, label %31

29:                                               ; preds = %28
  tail call void @numsp(ptr noundef nonnull @lbl, i32 noundef 2, i32 noundef %12) #4
  %30 = add nuw nsw i32 %9, 2
  tail call void @gfx_text(i32 noundef %30, i32 noundef 116, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #4
  br label %31

31:                                               ; preds = %29, %28
  %32 = and i32 %12, 1
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %31
  tail call void @numsp(ptr noundef nonnull @lbl, i32 noundef 2, i32 noundef %11) #4
  %35 = add nuw nsw i32 %9, 2
  tail call void @gfx_text(i32 noundef %35, i32 noundef 60, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #4
  tail call void @gfx_text(i32 noundef %35, i32 noundef 172, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #4
  br label %36

36:                                               ; preds = %26, %31, %34
  %37 = phi i32 [ %27, %26 ], [ 1, %31 ], [ 0, %34 ]
  %38 = add i32 %12, 1
  %39 = add i32 %37, %11
  br label %8, !llvm.loop !9

40:                                               ; preds = %8
  %41 = load i32, ptr @lo, align 4, !tbaa !3
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 18), i32 noundef 3, i32 noundef %41) #4
  store i8 45, ptr getelementptr inbounds nuw (i8, ptr @hdr, i32 21), align 1, !tbaa !11
  %42 = load i32, ptr @lo, align 4, !tbaa !3
  %43 = load i32, ptr @q, align 4, !tbaa !3
  %44 = shl nuw nsw i32 %43, 4
  %45 = add i32 %42, -1
  %46 = add i32 %45, %44
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 22), i32 noundef 3, i32 noundef %46) #4
  tail call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull @hdr, i16 noundef zeroext -16870, i16 noundef zeroext 0) #4
  tail call void @gfx_present() #4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc range(i32 0, 2) i32 @grad_frame() unnamed_addr #2 {
  %1 = load i32, ptr @in_edge, align 4, !tbaa !3
  %2 = and i32 %1, 16
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %0
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  br label %49

5:                                                ; preds = %0
  %6 = load i32, ptr @lo, align 4, !tbaa !3
  %7 = load i32, ptr @q, align 4, !tbaa !3
  %8 = and i32 %1, 1
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %16, label %10

10:                                               ; preds = %5
  %11 = icmp ugt i32 %7, 1
  br i1 %11, label %12, label %37

12:                                               ; preds = %10
  %13 = shl nuw nsw i32 %7, 2
  %14 = add nsw i32 %13, %6
  %15 = lshr i32 %7, 1
  br label %37

16:                                               ; preds = %5
  %17 = and i32 %1, 2
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %25, label %19

19:                                               ; preds = %16
  %20 = icmp ult i32 %7, 16
  br i1 %20, label %21, label %37

21:                                               ; preds = %19
  %22 = shl nuw nsw i32 %7, 3
  %23 = sub nsw i32 %6, %22
  %24 = shl nuw nsw i32 %7, 1
  br label %37

25:                                               ; preds = %16
  %26 = and i32 %1, 4
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %31, label %28

28:                                               ; preds = %25
  %29 = shl nuw nsw i32 %7, 2
  %30 = sub nsw i32 %6, %29
  br label %37

31:                                               ; preds = %25
  %32 = and i32 %1, 8
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %52, label %34

34:                                               ; preds = %31
  %35 = shl nuw nsw i32 %7, 2
  %36 = add nsw i32 %35, %6
  br label %37

37:                                               ; preds = %21, %19, %34, %28, %10, %12
  %38 = phi i32 [ %14, %12 ], [ %6, %10 ], [ %23, %21 ], [ %6, %19 ], [ %30, %28 ], [ %36, %34 ]
  %39 = phi i32 [ %15, %12 ], [ %7, %10 ], [ %24, %21 ], [ %7, %19 ], [ %7, %28 ], [ %7, %34 ]
  %40 = shl nuw nsw i32 %39, 4
  %41 = sub nsw i32 256, %40
  %42 = icmp slt i32 %38, 0
  %43 = tail call i32 @llvm.smin.i32(i32 %38, i32 %41)
  %44 = select i1 %42, i32 0, i32 %43
  %45 = icmp eq i32 %44, %6
  %46 = icmp eq i32 %39, %7
  %47 = select i1 %45, i1 %46, i1 false
  br i1 %47, label %52, label %48

48:                                               ; preds = %37
  store i32 %44, ptr @lo, align 4, !tbaa !3
  store i32 %39, ptr @q, align 4, !tbaa !3
  tail call fastcc void @redraw() #5
  tail call void @uputs(ptr noundef nonnull @.str.2) #4
  tail call void @uputs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 18)) #4
  br label %49

49:                                               ; preds = %4, %48
  %50 = phi ptr [ @.str.3, %48 ], [ @.str.1, %4 ]
  %51 = phi i32 [ 0, %48 ], [ 1, %4 ]
  tail call void @uputs(ptr noundef nonnull %50) #4
  br label %52

52:                                               ; preds = %49, %31, %37
  %53 = phi i32 [ 0, %37 ], [ 0, %31 ], [ %51, %49 ]
  ret i32 %53
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numsp(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize noinline nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }

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
!11 = !{!5, !5, i64 0}
