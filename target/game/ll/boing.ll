; ModuleID = 'boing.c'
source_filename = "boing.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"boing: start\0A\00", align 1
@arena_w = external dso_local local_unnamed_addr global [2304 x i32], align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [13 x i8] c"boing: quit\0A\00", align 1
@ball_home = dso_local local_unnamed_addr global i32 0, align 4
@fb = external dso_local global [57600 x i16], align 2

; Function Attrs: minsize nounwind optsize
define dso_local void @boing_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #3
  tail call void @led(i32 noundef 983811, i32 noundef 986895) #3
  tail call fastcc void @bg_rect(i32 noundef 0, i32 noundef 0, i32 noundef 240, i32 noundef 240) #4
  tail call void @gfx_present() #3
  store i32 24, ptr @arena_w, align 4, !tbaa !3
  store i32 20, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  store i32 2, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !9
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !13
  br label %1

1:                                                ; preds = %90, %0
  tail call void @frame_sync(i32 noundef 33000) #3
  tail call void @in_poll() #3
  %2 = load i32, ptr @in_edge, align 4, !tbaa !14
  %3 = and i32 %2, 31
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %6, label %5

5:                                                ; preds = %1
  tail call void @uputs(ptr noundef nonnull @.str.1) #3
  tail call void @snd_off() #3
  ret void

6:                                                ; preds = %1
  %7 = load i32, ptr @arena_w, align 4, !tbaa !3
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %9 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  %10 = add nsw i32 %9, 1
  store i32 %10, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  %11 = add nsw i32 %10, %8
  store i32 %11, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %12 = icmp sgt i32 %11, 145
  br i1 %12, label %13, label %14

13:                                               ; preds = %6
  store i32 146, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  store i32 -17, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  store i32 6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  br label %14

14:                                               ; preds = %13, %6
  %15 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !9
  %16 = add nsw i32 %15, %7
  store i32 %16, ptr @arena_w, align 4, !tbaa !3
  %17 = icmp slt i32 %16, 1
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = icmp samesign ugt i32 %16, 151
  br i1 %19, label %20, label %24

20:                                               ; preds = %18, %14
  %21 = icmp sgt i32 %16, 0
  %22 = select i1 %21, i32 152, i32 0
  store i32 %22, ptr @arena_w, align 4, !tbaa !3
  %23 = sub nsw i32 0, %15
  store i32 %23, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !9
  store i32 4, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  br label %24

24:                                               ; preds = %20, %18
  %25 = phi i32 [ %23, %20 ], [ %15, %18 ]
  %26 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !13
  %27 = add nsw i32 %26, 1
  store i32 %27, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !13
  %28 = and i32 %26, 1
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %38

30:                                               ; preds = %24
  %31 = icmp slt i32 %25, 1
  %32 = select i1 %31, i32 7, i32 1
  %33 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  %34 = add nsw i32 %32, %33
  store i32 %34, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  %35 = icmp sgt i32 %34, 7
  br i1 %35, label %36, label %38

36:                                               ; preds = %30
  %37 = add nsw i32 %34, -8
  store i32 %37, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  br label %38

38:                                               ; preds = %30, %36, %24
  tail call fastcc void @bg_rect(i32 noundef %7, i32 noundef %8, i32 noundef 88, i32 noundef 88) #4
  %39 = load i32, ptr @arena_w, align 4, !tbaa !3
  %40 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %41 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  %42 = load i32, ptr @ball_home, align 4, !tbaa !14
  %43 = inttoptr i32 %42 to ptr
  %44 = mul i32 %41, 15488
  %45 = add i32 %44, 176
  %46 = add i32 %45, %42
  %47 = mul nsw i32 %40, 240
  %48 = add nsw i32 %47, %39
  %49 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %48
  %50 = ptrtoint ptr %49 to i32
  br label %51

51:                                               ; preds = %70, %38
  %52 = phi i32 [ 0, %38 ], [ %73, %70 ]
  %53 = phi i32 [ %50, %38 ], [ %71, %70 ]
  %54 = phi i32 [ %46, %38 ], [ %72, %70 ]
  %55 = icmp eq i32 %52, 88
  br i1 %55, label %74, label %56

56:                                               ; preds = %51
  %57 = shl nuw nsw i32 %52, 1
  %58 = getelementptr inbounds nuw i8, ptr %43, i32 %57
  %59 = getelementptr inbounds nuw i8, ptr %58, i32 1
  %60 = load i8, ptr %59, align 1, !tbaa !15
  %61 = icmp eq i8 %60, 0
  br i1 %61, label %70, label %62

62:                                               ; preds = %56
  %63 = zext i8 %60 to i32
  %64 = load i8, ptr %58, align 1, !tbaa !15
  %65 = zext i8 %64 to i32
  %66 = shl nuw nsw i32 %65, 1
  %67 = add i32 %66, %53
  %68 = add i32 %66, %54
  %69 = shl nuw nsw i32 %63, 1
  tail call void @gdma_copy(i32 noundef %67, i32 noundef %68, i32 noundef %69) #3
  br label %70

70:                                               ; preds = %62, %56
  %71 = add i32 %53, 480
  %72 = add i32 %54, 176
  %73 = add nuw nsw i32 %52, 1
  br label %51, !llvm.loop !16

74:                                               ; preds = %51
  %75 = load i32, ptr @arena_w, align 4, !tbaa !3
  %76 = tail call i32 @llvm.smin.i32(i32 %7, i32 %75)
  %77 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %78 = tail call i32 @llvm.smin.i32(i32 %8, i32 %77)
  %79 = tail call i32 @llvm.smax.i32(i32 %7, i32 %75)
  %80 = add nsw i32 %79, 87
  %81 = tail call i32 @llvm.smax.i32(i32 %8, i32 %77)
  %82 = add nsw i32 %81, 87
  tail call void @gfx_damage(i32 noundef %76, i32 noundef %78, i32 noundef %80, i32 noundef %82) #3
  tail call void @gfx_present() #3
  %83 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  %84 = icmp eq i32 %83, 0
  br i1 %84, label %90, label %85

85:                                               ; preds = %74
  %86 = mul i32 %83, 30
  %87 = add i32 %86, 80
  tail call void @snd_play(i32 noundef %87, i32 noundef 60, i32 noundef 2) #3
  %88 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  %89 = add nsw i32 %88, -1
  store i32 %89, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  br label %90

90:                                               ; preds = %85, %74
  br label %1, !llvm.loop !19
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @bg_rect(i32 noundef %0, i32 noundef %1, i32 noundef range(i32 88, 241) %2, i32 noundef range(i32 88, 241) %3) unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i16 noundef zeroext -21163) #3
  %5 = add nsw i32 %2, %0
  br label %6

6:                                                ; preds = %20, %4
  %7 = phi i32 [ 0, %4 ], [ %21, %20 ]
  %8 = icmp samesign ult i32 %7, 240
  br i1 %8, label %11, label %9

9:                                                ; preds = %6
  %10 = add nsw i32 %3, %1
  br label %22

11:                                               ; preds = %6
  %12 = or disjoint i32 %7, 2
  %13 = icmp sgt i32 %12, %0
  %14 = icmp slt i32 %7, %5
  %15 = select i1 %13, i1 %14, i1 false
  br i1 %15, label %16, label %20

16:                                               ; preds = %11
  %17 = tail call i32 @llvm.smax.i32(i32 %7, i32 %0)
  %18 = tail call i32 @llvm.umin.i32(i32 %12, i32 %5)
  %19 = sub nsw i32 %18, %17
  tail call void @gfx_fill(i32 noundef %17, i32 noundef %1, i32 noundef %19, i32 noundef %3, i16 noundef zeroext -30213) #3
  br label %20

20:                                               ; preds = %11, %16
  %21 = add nuw nsw i32 %7, 24
  br label %6, !llvm.loop !20

22:                                               ; preds = %9, %35
  %23 = phi i32 [ %36, %35 ], [ 0, %9 ]
  %24 = icmp samesign ult i32 %23, 240
  br i1 %24, label %26, label %25

25:                                               ; preds = %22
  ret void

26:                                               ; preds = %22
  %27 = or disjoint i32 %23, 2
  %28 = icmp sgt i32 %27, %1
  %29 = icmp slt i32 %23, %10
  %30 = select i1 %28, i1 %29, i1 false
  br i1 %30, label %31, label %35

31:                                               ; preds = %26
  %32 = tail call i32 @llvm.smax.i32(i32 %23, i32 %1)
  %33 = tail call i32 @llvm.umin.i32(i32 %27, i32 %10)
  %34 = sub nsw i32 %33, %32
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %32, i32 noundef %2, i32 noundef %34, i16 noundef zeroext -30213) #3
  br label %35

35:                                               ; preds = %26, %31
  %36 = add nuw nsw i32 %23, 24
  br label %22, !llvm.loop !21
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #2

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
!3 = !{!4, !5, i64 0}
!4 = !{!"bstate", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16, !5, i64 20, !5, i64 24}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!4, !5, i64 4}
!9 = !{!4, !5, i64 8}
!10 = !{!4, !5, i64 12}
!11 = !{!4, !5, i64 16}
!12 = !{!4, !5, i64 20}
!13 = !{!4, !5, i64 24}
!14 = !{!5, !5, i64 0}
!15 = !{!6, !6, i64 0}
!16 = distinct !{!16, !17, !18}
!17 = !{!"llvm.loop.mustprogress"}
!18 = !{!"llvm.loop.unroll.disable"}
!19 = distinct !{!19, !18}
!20 = distinct !{!20, !17, !18}
!21 = distinct !{!21, !17, !18}
