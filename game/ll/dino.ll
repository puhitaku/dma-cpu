; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr }

@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 103809024, i32 119275520, i32 0], align 4
@cell_run_a = internal global [440 x i16] zeroinitializer, align 2
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 108003328, i32 117440512, i32 125829120, i32 0], align 4
@cell_run_b = internal global [440 x i16] zeroinitializer, align 2
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 103809024, i32 119275520, i32 0], align 4
@cell_dead = internal global [440 x i16] zeroinitializer, align 2
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@cell_cact_s = internal global [288 x i16] zeroinitializer, align 2
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@cell_cact_l = internal global [540 x i16] zeroinitializer, align 2
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_a) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_b) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_dead) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_s) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_l) #4
  br label %1

1:                                                ; preds = %147, %0
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 1064976, i32 noundef 0) #4
  tail call void @gfx_clear(i16 noundef zeroext -1) #4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #4
  br label %2

2:                                                ; preds = %5, %1
  %3 = phi i32 [ 6, %1 ], [ %6, %5 ]
  %4 = icmp samesign ult i32 %3, 240
  br i1 %4, label %5, label %7

5:                                                ; preds = %2
  tail call void @gfx_fill(i32 noundef %3, i32 noundef 195, i32 noundef 8, i32 noundef 1, i16 noundef zeroext 14823) #4
  %6 = add nuw nsw i32 %3, 24
  br label %2, !llvm.loop !3

7:                                                ; preds = %2
  tail call fastcc void @draw_score(i32 noundef 0) #5
  tail call void @gfx_present() #4
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 16), align 4, !tbaa !6
  store i32 -1000, ptr @obs, align 4, !tbaa !6
  br label %8

8:                                                ; preds = %126, %7
  %9 = phi i32 [ 45, %7 ], [ %41, %126 ]
  %10 = phi i32 [ 4, %7 ], [ %95, %126 ]
  %11 = phi i32 [ 0, %7 ], [ %15, %126 ]
  %12 = phi i32 [ 0, %7 ], [ %85, %126 ]
  %13 = phi i32 [ 0, %7 ], [ %32, %126 ]
  %14 = phi i32 [ 0, %7 ], [ %33, %126 ]
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %15 = add i32 %11, 1
  %16 = load i32, ptr @in_edge, align 4, !tbaa !13
  %17 = and i32 %16, 17
  %18 = icmp ne i32 %17, 0
  %19 = icmp eq i32 %14, 0
  %20 = and i1 %18, %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %8
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 3) #4
  br label %25

22:                                               ; preds = %8
  br i1 %19, label %23, label %25

23:                                               ; preds = %22
  %24 = icmp sgt i32 %13, 0
  br i1 %24, label %25, label %31

25:                                               ; preds = %21, %23, %22
  %26 = phi i32 [ %13, %23 ], [ %13, %22 ], [ 2400, %21 ]
  %27 = add nsw i32 %26, %14
  %28 = add nsw i32 %26, -256
  %29 = icmp slt i32 %27, 1
  br i1 %29, label %30, label %31

30:                                               ; preds = %25
  br label %31

31:                                               ; preds = %25, %30, %23
  %32 = phi i32 [ 0, %30 ], [ %28, %25 ], [ %13, %23 ]
  %33 = phi i32 [ 0, %30 ], [ %27, %25 ], [ 0, %23 ]
  %34 = icmp sgt i32 %9, 0
  %35 = sext i1 %34 to i32
  %36 = add nsw i32 %9, %35
  %37 = icmp ugt i32 %12, 100
  %38 = shl i32 %10, 1
  br label %39

39:                                               ; preds = %76, %31
  %40 = phi i32 [ 0, %31 ], [ %78, %76 ]
  %41 = phi i32 [ %36, %31 ], [ %77, %76 ]
  %42 = icmp eq i32 %40, 2
  br i1 %42, label %43, label %46

43:                                               ; preds = %39
  %44 = and i32 %11, 1
  %45 = icmp eq i32 %44, 0
  br i1 %45, label %84, label %79

46:                                               ; preds = %39
  %47 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %40
  %48 = load i32, ptr %47, align 4, !tbaa !6
  %49 = icmp slt i32 %48, -100
  br i1 %49, label %50, label %69

50:                                               ; preds = %46
  %51 = icmp eq i32 %41, 0
  br i1 %51, label %52, label %76

52:                                               ; preds = %50
  br i1 %37, label %53, label %57

53:                                               ; preds = %52
  %54 = tail call i32 @rng() #4
  %55 = and i32 %54, 3
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %58, label %57

57:                                               ; preds = %53, %52
  br label %58

58:                                               ; preds = %53, %57
  %59 = phi i32 [ 12, %57 ], [ 18, %53 ]
  %60 = phi i32 [ 24, %57 ], [ 30, %53 ]
  %61 = phi ptr [ @cell_cact_s, %57 ], [ @cell_cact_l, %53 ]
  %62 = getelementptr inbounds nuw i8, ptr %47, i32 4
  store i32 %59, ptr %62, align 4, !tbaa !14
  %63 = getelementptr inbounds nuw i8, ptr %47, i32 8
  store i32 %60, ptr %63, align 4, !tbaa !15
  %64 = getelementptr inbounds nuw i8, ptr %47, i32 12
  store ptr %61, ptr %64, align 4, !tbaa !16
  store i32 240, ptr %47, align 4, !tbaa !6
  %65 = tail call i32 @rng_below(i32 noundef 40) #4
  %66 = sub i32 %65, %38
  %67 = add i32 %66, 30
  %68 = tail call i32 @llvm.smax.i32(i32 %67, i32 18)
  br label %76

69:                                               ; preds = %46
  %70 = sub nsw i32 %48, %10
  %71 = getelementptr inbounds nuw i8, ptr %47, i32 4
  %72 = load i32, ptr %71, align 4, !tbaa !14
  %73 = add nsw i32 %72, %70
  %74 = icmp slt i32 %73, 1
  %75 = select i1 %74, i32 -1000, i32 %70
  store i32 %75, ptr %47, align 4
  br label %76

76:                                               ; preds = %50, %58, %69
  %77 = phi i32 [ %41, %69 ], [ %68, %58 ], [ %41, %50 ]
  %78 = add nuw nsw i32 %40, 1
  br label %39, !llvm.loop !17

79:                                               ; preds = %43
  %80 = add i32 %12, 1
  %81 = urem i32 %80, 100
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %83, label %84

83:                                               ; preds = %79
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 3) #4
  tail call void @led(i32 noundef 4210752, i32 noundef 1064976) #4
  br label %84

84:                                               ; preds = %79, %83, %43
  %85 = phi i32 [ %80, %83 ], [ %80, %79 ], [ %12, %43 ]
  switch i32 %85, label %86 [
    i32 150, label %90
    i32 400, label %90
  ]

86:                                               ; preds = %84
  %87 = icmp eq i32 %85, 800
  %88 = icmp slt i32 %10, 10
  %89 = select i1 %87, i1 %88, i1 false
  br i1 %89, label %92, label %94

90:                                               ; preds = %84, %84
  %91 = icmp slt i32 %10, 10
  br i1 %91, label %92, label %94

92:                                               ; preds = %86, %90
  %93 = add nsw i32 %10, 2
  br label %94

94:                                               ; preds = %90, %92, %86
  %95 = phi i32 [ %93, %92 ], [ %10, %90 ], [ %10, %86 ]
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 100, i32 noundef 240, i32 noundef 90, i16 noundef zeroext -1) #4
  %96 = lshr i32 %33, 8
  %97 = sub nsw i32 168, %96
  %98 = and i32 %15, 4
  %99 = icmp eq i32 %98, 0
  %100 = icmp eq i32 %33, 0
  %101 = select i1 %100, i1 %99, i1 false
  %102 = select i1 %101, ptr @cell_run_b, ptr @cell_run_a
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %97, ptr noundef nonnull %102, i32 noundef 20, i32 noundef 22) #4
  br label %103

103:                                              ; preds = %121, %94
  %104 = phi i32 [ 0, %94 ], [ %122, %121 ]
  %105 = icmp eq i32 %104, 2
  br i1 %105, label %106, label %109

106:                                              ; preds = %103
  %107 = and i32 %15, 7
  %108 = icmp eq i32 %107, 0
  br i1 %108, label %123, label %124

109:                                              ; preds = %103
  %110 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %104
  %111 = load i32, ptr %110, align 4, !tbaa !6
  %112 = icmp sgt i32 %111, -100
  br i1 %112, label %113, label %121

113:                                              ; preds = %109
  %114 = getelementptr inbounds nuw i8, ptr %110, i32 8
  %115 = load i32, ptr %114, align 4, !tbaa !15
  %116 = sub nsw i32 190, %115
  %117 = getelementptr inbounds nuw i8, ptr %110, i32 12
  %118 = load ptr, ptr %117, align 4, !tbaa !16
  %119 = getelementptr inbounds nuw i8, ptr %110, i32 4
  %120 = load i32, ptr %119, align 4, !tbaa !14
  tail call void @gfx_blit(i32 noundef %111, i32 noundef %116, ptr noundef %118, i32 noundef %120, i32 noundef %115) #4
  br label %121

121:                                              ; preds = %109, %113
  %122 = add nuw nsw i32 %104, 1
  br label %103, !llvm.loop !18

123:                                              ; preds = %106
  tail call fastcc void @draw_score(i32 noundef %85) #5
  br label %124

124:                                              ; preds = %123, %106
  tail call void @gfx_present() #4
  %125 = sub nsw i32 189, %96
  br label %126

126:                                              ; preds = %144, %124
  %127 = phi i32 [ 0, %124 ], [ %145, %144 ]
  %128 = icmp eq i32 %127, 2
  br i1 %128, label %8, label %129, !llvm.loop !19

129:                                              ; preds = %126
  %130 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %127
  %131 = load i32, ptr %130, align 4, !tbaa !6
  %132 = add i32 %131, 100
  %133 = icmp ult i32 %132, 145
  br i1 %133, label %134, label %144

134:                                              ; preds = %129
  %135 = getelementptr inbounds nuw i8, ptr %130, i32 8
  %136 = load i32, ptr %135, align 4, !tbaa !15
  %137 = sub i32 192, %136
  %138 = getelementptr inbounds nuw i8, ptr %130, i32 4
  %139 = load i32, ptr %138, align 4, !tbaa !14
  %140 = add nsw i32 %139, %131
  %141 = icmp sgt i32 %140, 35
  %142 = icmp sgt i32 %125, %137
  %143 = select i1 %141, i1 %142, i1 false
  br i1 %143, label %146, label %144

144:                                              ; preds = %134, %129
  %145 = add nuw nsw i32 %127, 1
  br label %126, !llvm.loop !20

146:                                              ; preds = %134
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 18) #4
  tail call void @led(i32 noundef 6291456, i32 noundef 6291456) #4
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %97, ptr noundef nonnull @cell_dead, i32 noundef 20, i32 noundef 22) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 130, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #4
  tail call void @gfx_text(i32 noundef 24, i32 noundef 154, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #4
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  tail call void @uputn(i32 noundef %85) #4
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  br label %147

147:                                              ; preds = %151, %146
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %148 = load i32, ptr @in_edge, align 4, !tbaa !13
  %149 = and i32 %148, 17
  %150 = icmp eq i32 %149, 0
  br i1 %150, label %151, label %1

151:                                              ; preds = %147
  %152 = and i32 %148, 2
  %153 = icmp eq i32 %152, 0
  br i1 %153, label %147, label %154, !llvm.loop !21

154:                                              ; preds = %151
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_sprite(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score(i32 noundef %0) unnamed_addr #0 {
  %2 = alloca [6 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %2) #6
  call void @numstr(ptr noundef nonnull %2, i32 noundef 5, i32 noundef %0) #4
  call void @gfx_text(i32 noundef 192, i32 noundef 8, ptr noundef nonnull %2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #4
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !8, i64 0}
!7 = !{!"obst", !8, i64 0, !8, i64 4, !8, i64 8, !11, i64 12}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!"p1 short", !12, i64 0}
!12 = !{!"any pointer", !9, i64 0}
!13 = !{!8, !8, i64 0}
!14 = !{!7, !8, i64 4}
!15 = !{!7, !8, i64 8}
!16 = !{!7, !11, i64 12}
!17 = distinct !{!17, !4, !5}
!18 = distinct !{!18, !4, !5}
!19 = distinct !{!19, !5}
!20 = distinct !{!20, !4, !5}
!21 = distinct !{!21, !5}
