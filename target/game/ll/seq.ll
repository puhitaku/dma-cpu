; ModuleID = 'seq.c'
source_filename = "seq.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [9 x i8] c"seq: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"SEQUENCER\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"tempo\00", align 1
@.str.3 = private unnamed_addr constant [24 x i8] c"K kick   S snare  T tom\00", align 1
@.str.4 = private unnamed_addr constant [18 x i8] c"H hat    C cymbal\00", align 1
@.str.5 = private unnamed_addr constant [25 x i8] c"l/r: step  press: change\00", align 1
@.str.6 = private unnamed_addr constant [27 x i8] c"hold: exit  up/down: tempo\00", align 1
@seq_run.tdiv = internal unnamed_addr constant [8 x i32] [i32 32875, i32 31000, i32 28750, i32 26500, i32 22675, i32 21250, i32 20500, i32 19875], align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@pattern = internal unnamed_addr global [16 x i8] c"\01\00\04\00\02\00\04\04\01\00\04\01\02\00\05\00", align 1
@.str.7 = private unnamed_addr constant [15 x i8] c"seq: step set\0A\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.8 = private unnamed_addr constant [11 x i8] c"seq: exit\0A\00", align 1
@dlen = internal unnamed_addr constant [6 x i32] [i32 0, i32 2800, i32 1900, i32 2000, i32 800, i32 2700], align 4
@daddr = dso_local local_unnamed_addr global [6 x i32] zeroinitializer, align 4
@dcol = internal unnamed_addr constant [6 x i16] [i16 8390, i16 -1339, i16 -377, i16 16111, i16 18012, i16 -17537], align 2
@dletter = internal unnamed_addr constant [6 x i8] c".KSTHC", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @seq_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #3
  tail call void @gfx_clear(i16 noundef zeroext 4163) #3
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 8, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 4163) #3
  tail call void @gfx_text(i32 noundef 72, i32 noundef 40, ptr noundef nonnull @.str.2, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #3
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %8, %5 ]
  %3 = icmp eq i32 %2, 16
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  tail call void @gfx_text(i32 noundef 6, i32 noundef 150, ptr noundef nonnull @.str.3, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #3
  tail call void @gfx_text(i32 noundef 6, i32 noundef 162, ptr noundef nonnull @.str.4, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #3
  tail call void @gfx_text(i32 noundef 6, i32 noundef 200, ptr noundef nonnull @.str.5, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #3
  tail call void @gfx_text(i32 noundef 6, i32 noundef 212, ptr noundef nonnull @.str.6, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #3
  tail call void @snd_rate(i32 noundef 22675) #3
  tail call fastcc void @draw_tempo(i32 noundef 4) #4
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #3
  br label %9

5:                                                ; preds = %1
  %6 = icmp eq i32 %2, 0
  %7 = zext i1 %6 to i32
  tail call fastcc void @draw_step(i32 noundef %2, i32 noundef %7) #4
  %8 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !3

9:                                                ; preds = %117, %4
  %10 = phi i32 [ -1, %4 ], [ %87, %117 ]
  %11 = phi i32 [ 0, %4 ], [ %79, %117 ]
  %12 = phi i32 [ 0, %4 ], [ %83, %117 ]
  %13 = phi i32 [ 0, %4 ], [ %40, %117 ]
  %14 = phi i32 [ 4, %4 ], [ %74, %117 ]
  tail call void @gfx_present() #3
  br label %15

15:                                               ; preds = %9, %82
  %16 = phi i32 [ %79, %82 ], [ %11, %9 ]
  %17 = phi i32 [ %83, %82 ], [ %12, %9 ]
  %18 = phi i32 [ %40, %82 ], [ %13, %9 ]
  %19 = phi i32 [ %74, %82 ], [ %14, %9 ]
  tail call void @frame_sync(i32 noundef 4000) #3
  tail call void @in_poll() #3
  %20 = load i32, ptr @in_edge, align 4, !tbaa !6
  %21 = and i32 %20, 4
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %28, label %23

23:                                               ; preds = %15
  tail call fastcc void @draw_step(i32 noundef %18, i32 noundef 0) #4
  %24 = icmp eq i32 %18, 0
  %25 = add nsw i32 %18, -1
  %26 = select i1 %24, i32 15, i32 %25
  tail call fastcc void @draw_step(i32 noundef %26, i32 noundef 1) #4
  tail call void @gfx_present() #3
  %27 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %28

28:                                               ; preds = %23, %15
  %29 = phi i32 [ %27, %23 ], [ %20, %15 ]
  %30 = phi i32 [ %26, %23 ], [ %18, %15 ]
  %31 = and i32 %29, 8
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %38, label %33

33:                                               ; preds = %28
  tail call fastcc void @draw_step(i32 noundef %30, i32 noundef 0) #4
  %34 = icmp eq i32 %30, 15
  %35 = add nsw i32 %30, 1
  %36 = select i1 %34, i32 0, i32 %35
  tail call fastcc void @draw_step(i32 noundef %36, i32 noundef 1) #4
  tail call void @gfx_present() #3
  %37 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %38

38:                                               ; preds = %33, %28
  %39 = phi i32 [ %37, %33 ], [ %29, %28 ]
  %40 = phi i32 [ %36, %33 ], [ %30, %28 ]
  %41 = and i32 %39, 16
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %51, label %43

43:                                               ; preds = %38
  %44 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %40
  %45 = load i8, ptr %44, align 1, !tbaa !10
  %46 = zext i8 %45 to i16
  %47 = add nuw nsw i16 %46, 1
  %48 = urem i16 %47, 6
  %49 = trunc nuw nsw i16 %48 to i8
  store i8 %49, ptr %44, align 1, !tbaa !10
  tail call fastcc void @draw_step(i32 noundef %40, i32 noundef 1) #4
  tail call void @gfx_present() #3
  tail call void @uputs(ptr noundef nonnull @.str.7) #3
  %50 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %51

51:                                               ; preds = %43, %38
  %52 = phi i32 [ %50, %43 ], [ %39, %38 ]
  %53 = and i32 %52, 1
  %54 = icmp ne i32 %53, 0
  %55 = icmp slt i32 %19, 7
  %56 = select i1 %54, i1 %55, i1 false
  br i1 %56, label %57, label %62

57:                                               ; preds = %51
  %58 = add nsw i32 %19, 1
  %59 = getelementptr inbounds [8 x i32], ptr @seq_run.tdiv, i32 0, i32 %58
  %60 = load i32, ptr %59, align 4, !tbaa !6
  tail call void @snd_rate(i32 noundef %60) #3
  tail call fastcc void @draw_tempo(i32 noundef %58) #4
  tail call void @gfx_present() #3
  %61 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %62

62:                                               ; preds = %57, %51
  %63 = phi i32 [ %61, %57 ], [ %52, %51 ]
  %64 = phi i32 [ %58, %57 ], [ %19, %51 ]
  %65 = and i32 %63, 2
  %66 = icmp ne i32 %65, 0
  %67 = icmp sgt i32 %64, 0
  %68 = select i1 %66, i1 %67, i1 false
  br i1 %68, label %69, label %73

69:                                               ; preds = %62
  %70 = add nsw i32 %64, -1
  %71 = getelementptr inbounds nuw [8 x i32], ptr @seq_run.tdiv, i32 0, i32 %70
  %72 = load i32, ptr %71, align 4, !tbaa !6
  tail call void @snd_rate(i32 noundef %72) #3
  tail call fastcc void @draw_tempo(i32 noundef %70) #4
  tail call void @gfx_present() #3
  br label %73

73:                                               ; preds = %69, %62
  %74 = phi i32 [ %70, %69 ], [ %64, %62 ]
  %75 = load i32, ptr @in_down, align 4, !tbaa !6
  %76 = and i32 %75, 16
  %77 = icmp eq i32 %76, 0
  %78 = add nuw nsw i32 %16, 1
  %79 = select i1 %77, i32 0, i32 %78
  %80 = icmp samesign ugt i32 %79, 300
  br i1 %80, label %81, label %82

81:                                               ; preds = %73
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #3
  tail call void @snd_rate(i32 noundef 22675) #3
  tail call void @led(i32 noundef 0, i32 noundef 0) #3
  tail call void @uputs(ptr noundef nonnull @.str.8) #3
  ret void

82:                                               ; preds = %73
  %83 = load volatile i32, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !6
  %84 = icmp ult i32 %83, %17
  br i1 %84, label %85, label %15, !llvm.loop !11

85:                                               ; preds = %82
  %86 = add nsw i32 %10, 1
  %87 = and i32 %86, 15
  %88 = getelementptr inbounds nuw [16 x i8], ptr @pattern, i32 0, i32 %87
  %89 = load i8, ptr %88, align 1, !tbaa !10
  %90 = icmp eq i8 %89, 0
  br i1 %90, label %100, label %91

91:                                               ; preds = %85
  %92 = zext i8 %89 to i32
  %93 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %92
  %94 = load i32, ptr %93, align 4, !tbaa !6
  %95 = shl i32 %94, 2
  %96 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %92
  %97 = load i32, ptr %96, align 4, !tbaa !6
  tail call void @gdma_copy(i32 noundef 537100288, i32 noundef %97, i32 noundef %95) #3
  %98 = add i32 %95, 537100288
  %99 = sub i32 16384, %95
  tail call void @gdma_fill(i32 noundef %98, i32 noundef 0, i32 noundef %99) #3
  br label %101

100:                                              ; preds = %85
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #3
  br label %101

101:                                              ; preds = %100, %91
  %102 = icmp sgt i32 %10, -1
  br i1 %102, label %103, label %109

103:                                              ; preds = %101
  %104 = and i32 %10, 7
  %105 = mul nuw nsw i32 %104, 29
  %106 = add nuw nsw i32 %105, 6
  %107 = icmp samesign ult i32 %10, 8
  %108 = select i1 %107, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %106, i32 noundef %108, i32 noundef 26, i32 noundef 3, i16 noundef zeroext 4163) #3
  br label %109

109:                                              ; preds = %101, %103
  %110 = and i32 %86, 7
  %111 = mul nuw nsw i32 %110, 29
  %112 = add nuw nsw i32 %111, 6
  %113 = icmp samesign ult i32 %87, 8
  %114 = select i1 %113, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %112, i32 noundef %114, i32 noundef 26, i32 noundef 3, i16 noundef zeroext -377) #3
  switch i8 %89, label %118 [
    i8 1, label %115
    i8 2, label %116
  ]

115:                                              ; preds = %109
  tail call void @led(i32 noundef 4132864, i32 noundef 0) #3
  br label %117

116:                                              ; preds = %109
  tail call void @led(i32 noundef 0, i32 noundef 4144912) #3
  br label %117

117:                                              ; preds = %116, %120, %119, %115
  br label %9, !llvm.loop !11

118:                                              ; preds = %109
  br i1 %90, label %120, label %119

119:                                              ; preds = %118
  tail call void @led(i32 noundef 3855, i32 noundef 3855) #3
  br label %117

120:                                              ; preds = %118
  tail call void @led(i32 noundef 0, i32 noundef 0) #3
  br label %117
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_step(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = alloca [2 x i8], align 1
  %4 = and i32 %0, 7
  %5 = mul nuw nsw i32 %4, 29
  %6 = add nuw nsw i32 %5, 6
  %7 = icmp slt i32 %0, 8
  %8 = select i1 %7, i32 64, i32 104
  %9 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %0
  %10 = load i8, ptr %9, align 1, !tbaa !10
  %11 = zext i8 %10 to i32
  %12 = getelementptr inbounds nuw [6 x i16], ptr @dcol, i32 0, i32 %11
  %13 = load i16, ptr %12, align 2, !tbaa !12
  tail call void @gfx_fill(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i16 noundef zeroext %13) #3
  %14 = icmp eq i8 %10, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %3) #5
  %16 = getelementptr inbounds nuw [6 x i8], ptr @dletter, i32 0, i32 %11
  %17 = load i8, ptr %16, align 1, !tbaa !10
  store i8 %17, ptr %3, align 1, !tbaa !10
  %18 = getelementptr inbounds nuw i8, ptr %3, i32 1
  store i8 0, ptr %18, align 1, !tbaa !10
  %19 = add nuw nsw i32 %5, 15
  %20 = add nuw nsw i32 %8, 9
  call void @gfx_text(i32 noundef %19, i32 noundef %20, ptr noundef nonnull %3, i16 noundef zeroext 2114, i16 noundef zeroext %13) #3
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %3) #5
  br label %21

21:                                               ; preds = %15, %2
  %22 = icmp eq i32 %1, 0
  %23 = select i1 %22, i32 1, i32 2
  %24 = select i1 %22, i16 14730, i16 -1
  call void @gfx_rect(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i32 noundef %23, i16 noundef zeroext %24) #3
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @snd_rate(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_tempo(i32 noundef range(i32 -2147483647, 2147483647) %0) unnamed_addr #0 {
  %2 = alloca [2 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %2) #5
  %3 = trunc i32 %0 to i8
  %4 = add i8 %3, 49
  store i8 %4, ptr %2, align 1, !tbaa !10
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 0, ptr %5, align 1, !tbaa !10
  call void @gfx_text(i32 noundef 140, i32 noundef 40, ptr noundef nonnull %2, i16 noundef zeroext -1, i16 noundef zeroext 4163) #3
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %2) #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

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
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!8, !8, i64 0}
!11 = distinct !{!11, !5}
!12 = !{!13, !13, i64 0}
!13 = !{!"short", !8, i64 0}
