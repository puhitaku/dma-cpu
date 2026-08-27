; ModuleID = 'boing.c'
source_filename = "boing.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"boing: start\0A\00", align 1
@arena_w = external dso_local local_unnamed_addr global [2304 x i32], align 4
@in_down = external dso_local local_unnamed_addr global i32, align 4
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

1:                                                ; preds = %88, %0
  tail call void @frame_sync(i32 noundef 33000) #3
  tail call void @in_poll() #3
  %2 = load i32, ptr @in_down, align 4, !tbaa !14
  %3 = and i32 %2, 16
  %4 = icmp eq i32 %3, 0
  %5 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4
  %6 = add nsw i32 %5, 1
  %7 = select i1 %4, i32 0, i32 %6
  store i32 %7, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !13
  %8 = icmp sgt i32 %7, 45
  br i1 %8, label %9, label %10

9:                                                ; preds = %1
  tail call void @uputs(ptr noundef nonnull @.str.1) #3
  tail call void @snd_off() #3
  ret void

10:                                               ; preds = %1
  %11 = load i32, ptr @arena_w, align 4, !tbaa !3
  %12 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %13 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  %15 = add nsw i32 %14, %12
  store i32 %15, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %16 = icmp sgt i32 %15, 137
  br i1 %16, label %17, label %18

17:                                               ; preds = %10
  store i32 138, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  store i32 -17, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !10
  store i32 6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  br label %18

18:                                               ; preds = %17, %10
  %19 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !9
  %20 = add nsw i32 %19, %11
  store i32 %20, ptr @arena_w, align 4, !tbaa !3
  %21 = icmp slt i32 %20, 1
  br i1 %21, label %24, label %22

22:                                               ; preds = %18
  %23 = icmp samesign ugt i32 %20, 143
  br i1 %23, label %24, label %28

24:                                               ; preds = %22, %18
  %25 = icmp sgt i32 %20, 0
  %26 = select i1 %25, i32 144, i32 0
  store i32 %26, ptr @arena_w, align 4, !tbaa !3
  %27 = sub nsw i32 0, %19
  store i32 %27, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !9
  store i32 4, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  br label %28

28:                                               ; preds = %24, %22
  %29 = phi i32 [ %27, %24 ], [ %19, %22 ]
  %30 = icmp slt i32 %29, 1
  %31 = select i1 %30, i32 5, i32 1
  %32 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  %33 = add nsw i32 %31, %32
  %34 = icmp sgt i32 %33, 5
  %35 = add nsw i32 %33, -6
  %36 = select i1 %34, i32 %35, i32 %33
  store i32 %36, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  tail call fastcc void @bg_rect(i32 noundef %11, i32 noundef %12, i32 noundef 96, i32 noundef 96) #4
  %37 = load i32, ptr @arena_w, align 4, !tbaa !3
  %38 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %39 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !11
  %40 = load i32, ptr @ball_home, align 4, !tbaa !14
  %41 = inttoptr i32 %40 to ptr
  %42 = mul i32 %39, 18432
  %43 = or disjoint i32 %42, 192
  %44 = add i32 %43, %40
  %45 = mul nsw i32 %38, 240
  %46 = add nsw i32 %45, %37
  %47 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %46
  %48 = ptrtoint ptr %47 to i32
  br label %49

49:                                               ; preds = %68, %28
  %50 = phi i32 [ 0, %28 ], [ %71, %68 ]
  %51 = phi i32 [ %48, %28 ], [ %69, %68 ]
  %52 = phi i32 [ %44, %28 ], [ %70, %68 ]
  %53 = icmp eq i32 %50, 96
  br i1 %53, label %72, label %54

54:                                               ; preds = %49
  %55 = shl nuw nsw i32 %50, 1
  %56 = getelementptr inbounds nuw i8, ptr %41, i32 %55
  %57 = getelementptr inbounds nuw i8, ptr %56, i32 1
  %58 = load i8, ptr %57, align 1, !tbaa !15
  %59 = icmp eq i8 %58, 0
  br i1 %59, label %68, label %60

60:                                               ; preds = %54
  %61 = zext i8 %58 to i32
  %62 = load i8, ptr %56, align 1, !tbaa !15
  %63 = zext i8 %62 to i32
  %64 = shl nuw nsw i32 %63, 1
  %65 = add i32 %64, %51
  %66 = add i32 %64, %52
  %67 = shl nuw nsw i32 %61, 1
  tail call void @gdma_copy(i32 noundef %65, i32 noundef %66, i32 noundef %67) #3
  br label %68

68:                                               ; preds = %60, %54
  %69 = add i32 %51, 480
  %70 = add i32 %52, 192
  %71 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !16

72:                                               ; preds = %49
  %73 = load i32, ptr @arena_w, align 4, !tbaa !3
  %74 = tail call i32 @llvm.smin.i32(i32 %11, i32 %73)
  %75 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !8
  %76 = tail call i32 @llvm.smin.i32(i32 %12, i32 %75)
  %77 = tail call i32 @llvm.smax.i32(i32 %11, i32 %73)
  %78 = add nsw i32 %77, 95
  %79 = tail call i32 @llvm.smax.i32(i32 %12, i32 %75)
  %80 = add nsw i32 %79, 95
  tail call void @gfx_damage(i32 noundef %74, i32 noundef %76, i32 noundef %78, i32 noundef %80) #3
  tail call void @gfx_present() #3
  %81 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %88, label %83

83:                                               ; preds = %72
  %84 = mul i32 %81, 30
  %85 = add i32 %84, 80
  tail call void @snd_play(i32 noundef %85, i32 noundef 60, i32 noundef 2) #3
  %86 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  %87 = add nsw i32 %86, -1
  store i32 %87, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !12
  br label %88

88:                                               ; preds = %83, %72
  br label %1, !llvm.loop !19
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @bg_rect(i32 noundef %0, i32 noundef %1, i32 noundef range(i32 96, 241) %2, i32 noundef range(i32 96, 241) %3) unnamed_addr #0 {
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
