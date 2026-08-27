; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr, ptr }
%struct.cld = type { i32, i32 }

@arena_w = external dso_local global [2304 x i32], align 4
@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 123731968, i32 7340032, i32 0], align 4
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@art_cloud = internal constant [5 x i32] [i32 130023424, i32 536051712, i32 1073725440, i32 2147475456, i32 1073709056], align 4
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@sfx_tab = external dso_local local_unnamed_addr global [4 x i32], align 4
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@fb = external dso_local global [57600 x i16], align 2
@sbuf = internal unnamed_addr global [6 x i8] zeroinitializer, align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  %1 = alloca [2 x %struct.cld], align 4
  %2 = alloca [2 x i32], align 4
  br label %3

3:                                                ; preds = %6, %0
  %4 = phi i32 [ 0, %0 ], [ %8, %6 ]
  %5 = icmp eq i32 %4, 264
  br i1 %5, label %9, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4496), i32 %4
  store i16 -1, ptr %7, align 2, !tbaa !3
  %8 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !7

9:                                                ; preds = %3, %17
  %10 = phi i32 [ %18, %17 ], [ 6, %3 ]
  %11 = icmp samesign ult i32 %10, 256
  br i1 %11, label %12, label %22

12:                                               ; preds = %9
  %13 = getelementptr inbounds nuw i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4496), i32 %10
  br label %14

14:                                               ; preds = %19, %12
  %15 = phi i32 [ %21, %19 ], [ 0, %12 ]
  %16 = icmp eq i32 %15, 8
  br i1 %16, label %17, label %19

17:                                               ; preds = %14
  %18 = add nuw nsw i32 %10, 24
  br label %9, !llvm.loop !10

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i16, ptr %13, i32 %15
  store i16 14823, ptr %20, align 2, !tbaa !3
  %21 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !11

22:                                               ; preds = %9, %29
  %23 = phi i32 [ %32, %29 ], [ 0, %9 ]
  %24 = icmp eq i32 %23, 10
  br i1 %24, label %25, label %29

25:                                               ; preds = %22
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull @arena_w) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 880)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1760)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2640)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3216)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cloud, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -16871, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296)) #5
  tail call void @gfx_cell_spans(ptr noundef nonnull @arena_w, i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6304)) #6
  tail call void @gfx_cell_spans(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 880), i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6348)) #6
  tail call void @gfx_cell_spans(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1760), i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6392)) #6
  tail call void @gfx_cell_spans(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2640), i32 noundef 12, i32 noundef 24, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6436)) #6
  tail call void @gfx_cell_spans(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3216), i32 noundef 18, i32 noundef 30, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6484)) #6
  tail call void @gfx_cell_spans(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6544)) #6
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %27 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %28 = getelementptr inbounds nuw i8, ptr %1, i32 12
  br label %33

29:                                               ; preds = %22
  %30 = or disjoint i32 %23, 48
  %31 = getelementptr inbounds nuw [64 x i16], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 5024), i32 %23
  tail call void @gfx_glyph_cell(i32 noundef %30, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull %31) #6
  %32 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !12

33:                                               ; preds = %320, %25
  tail call void @uputs(ptr noundef nonnull @.str) #6
  tail call void @led(i32 noundef 0, i32 noundef 0) #6
  tail call void @gfx_clear(i16 noundef zeroext -1) #6
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #6
  tail call fastcc void @draw_dashes(i32 noundef 0) #5
  br label %34

34:                                               ; preds = %37, %33
  %35 = phi i32 [ 0, %33 ], [ %39, %37 ]
  %36 = icmp eq i32 %35, 5
  br i1 %36, label %40, label %37

37:                                               ; preds = %34
  %38 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %35
  store i8 48, ptr %38, align 1, !tbaa !13
  %39 = add nuw nsw i32 %35, 1
  br label %34, !llvm.loop !14

40:                                               ; preds = %34
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @sbuf, i32 5), align 1, !tbaa !13
  tail call fastcc void @draw_score() #5
  tail call void @gfx_present() #6
  store i32 150, ptr %1, align 4, !tbaa !15
  store i32 40, ptr %26, align 4, !tbaa !18
  store i32 40, ptr %27, align 4, !tbaa !15
  store i32 64, ptr %28, align 4, !tbaa !18
  tail call void @gfx_blit_spans(i32 noundef 150, i32 noundef 40, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6544)) #6
  tail call void @gfx_blit_spans(i32 noundef 40, i32 noundef 64, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6544)) #6
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 20), align 4, !tbaa !19
  store i32 -1000, ptr @obs, align 4, !tbaa !19
  br label %42

41:                                               ; preds = %292
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  br label %42

42:                                               ; preds = %41, %40
  %43 = phi i32 [ 168, %40 ], [ %249, %41 ]
  %44 = phi i32 [ 0, %40 ], [ %253, %41 ]
  %45 = phi i32 [ 0, %40 ], [ %110, %41 ]
  %46 = phi i32 [ 32, %40 ], [ %283, %41 ]
  %47 = phi i32 [ 512, %40 ], [ %284, %41 ]
  %48 = phi i32 [ 90, %40 ], [ %126, %41 ]
  %49 = phi i32 [ 0, %40 ], [ %273, %41 ]
  %50 = phi i32 [ 0, %40 ], [ %55, %41 ]
  %51 = phi i32 [ 0, %40 ], [ %274, %41 ]
  %52 = phi i32 [ 0, %40 ], [ %99, %41 ]
  %53 = phi i32 [ 0, %40 ], [ %100, %41 ]
  %54 = phi i32 [ 0, %40 ], [ %101, %41 ]
  tail call void @frame_sync(i32 noundef 16667) #6
  tail call void @in_poll() #6
  %55 = add i32 %50, 1
  %56 = load i32, ptr @in_edge, align 4, !tbaa !24
  %57 = and i32 %56, 17
  %58 = icmp ne i32 %57, 0
  %59 = icmp eq i32 %54, 0
  %60 = and i1 %58, %59
  %61 = icmp eq i32 %53, 0
  %62 = select i1 %60, i1 %61, i1 false
  br i1 %62, label %63, label %64

63:                                               ; preds = %42
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 6) #6
  br label %70

64:                                               ; preds = %42
  %65 = icmp sgt i32 %54, 0
  br i1 %65, label %70, label %66

66:                                               ; preds = %64
  %67 = icmp sgt i32 %53, 0
  br i1 %67, label %70, label %68

68:                                               ; preds = %66
  %69 = icmp sgt i32 %52, 0
  br i1 %69, label %70, label %98

70:                                               ; preds = %63, %68, %66, %64
  %71 = phi i32 [ %52, %68 ], [ %52, %66 ], [ %52, %64 ], [ 1200, %63 ]
  %72 = add i32 %71, %53
  %73 = add i32 %71, 255
  %74 = add i32 %73, %53
  %75 = tail call i32 @llvm.smin.i32(i32 %72, i32 255)
  %76 = sub i32 %74, %75
  %77 = lshr i32 %76, 8
  %78 = and i32 %76, -256
  %79 = sub i32 %72, %78
  %80 = add i32 %54, %77
  %81 = add nsw i32 %71, -64
  %82 = tail call i32 @llvm.smin.i32(i32 %80, i32 0)
  %83 = sub i32 %80, %82
  %84 = freeze i32 %83
  %85 = tail call i32 @llvm.smax.i32(i32 %79, i32 0)
  %86 = add nuw i32 %85, 255
  %87 = sub i32 %86, %79
  %88 = lshr i32 %87, 8
  %89 = tail call i32 @llvm.umin.i32(i32 %84, i32 %88)
  %90 = shl nuw i32 %89, 8
  %91 = add i32 %72, %90
  %92 = sub i32 %91, %78
  %93 = sub i32 %80, %89
  %94 = icmp eq i32 %93, 0
  %95 = icmp slt i32 %92, 1
  %96 = and i1 %95, %94
  br i1 %96, label %97, label %98

97:                                               ; preds = %70
  br label %98

98:                                               ; preds = %70, %97, %68
  %99 = phi i32 [ 0, %97 ], [ %81, %70 ], [ %52, %68 ]
  %100 = phi i32 [ 0, %97 ], [ %92, %70 ], [ %53, %68 ]
  %101 = phi i32 [ 0, %97 ], [ %93, %70 ], [ %54, %68 ]
  %102 = add i32 %47, %45
  %103 = add i32 %47, 511
  %104 = add i32 %103, %45
  %105 = tail call i32 @llvm.smin.i32(i32 %102, i32 511)
  %106 = sub i32 %104, %105
  %107 = lshr i32 %106, 8
  %108 = and i32 %107, 16777214
  %109 = and i32 %106, -512
  %110 = sub i32 %102, %109
  %111 = sub nsw i32 168, %101
  %112 = icmp ne i32 %111, %43
  %113 = and i32 %55, 7
  %114 = icmp eq i32 %113, 0
  %115 = select i1 %112, i1 true, i1 %114
  %116 = and i32 %55, 15
  %117 = icmp eq i32 %116, 0
  br i1 %115, label %118, label %119

118:                                              ; preds = %98
  tail call void @gfx_fill(i32 noundef 30, i32 noundef %43, i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1) #6
  br label %119

119:                                              ; preds = %118, %98
  %120 = icmp sgt i32 %48, 0
  %121 = sext i1 %120 to i32
  %122 = add nsw i32 %48, %121
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #7
  %123 = icmp ugt i32 %51, 100
  br label %124

124:                                              ; preds = %175, %119
  %125 = phi i32 [ 0, %119 ], [ %177, %175 ]
  %126 = phi i32 [ %122, %119 ], [ %176, %175 ]
  %127 = icmp eq i32 %125, 2
  br i1 %127, label %128, label %130

128:                                              ; preds = %124
  br i1 %117, label %178, label %129

129:                                              ; preds = %190, %128
  br label %207

130:                                              ; preds = %124
  %131 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %125
  %132 = load i32, ptr %131, align 4, !tbaa !19
  %133 = getelementptr inbounds nuw [2 x i32], ptr %2, i32 0, i32 %125
  store i32 %132, ptr %133, align 4, !tbaa !24
  %134 = icmp slt i32 %132, -100
  br i1 %134, label %135, label %156

135:                                              ; preds = %130
  %136 = icmp eq i32 %126, 0
  br i1 %136, label %137, label %175

137:                                              ; preds = %135
  br i1 %123, label %138, label %142

138:                                              ; preds = %137
  %139 = tail call i32 @rng() #6
  %140 = and i32 %139, 3
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %143, label %142

142:                                              ; preds = %138, %137
  br label %143

143:                                              ; preds = %138, %142
  %144 = phi i32 [ 12, %142 ], [ 18, %138 ]
  %145 = phi i32 [ 24, %142 ], [ 30, %138 ]
  %146 = phi ptr [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 2640), %142 ], [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 3216), %138 ]
  %147 = phi ptr [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 6436), %142 ], [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 6484), %138 ]
  %148 = getelementptr inbounds nuw i8, ptr %131, i32 4
  store i32 %144, ptr %148, align 4, !tbaa !25
  %149 = getelementptr inbounds nuw i8, ptr %131, i32 8
  store i32 %145, ptr %149, align 4, !tbaa !26
  %150 = getelementptr inbounds nuw i8, ptr %131, i32 12
  store ptr %146, ptr %150, align 4, !tbaa !27
  %151 = getelementptr inbounds nuw i8, ptr %131, i32 16
  store ptr %147, ptr %151, align 4, !tbaa !28
  store i32 240, ptr %131, align 4, !tbaa !19
  %152 = tail call i32 @rng_below(i32 noundef 80) #6
  %153 = sub i32 %152, %46
  %154 = add i32 %153, 70
  %155 = tail call i32 @llvm.smax.i32(i32 %154, i32 50)
  br label %175

156:                                              ; preds = %130
  %157 = getelementptr inbounds nuw i8, ptr %131, i32 8
  %158 = load i32, ptr %157, align 4, !tbaa !26
  %159 = sub nsw i32 190, %158
  %160 = getelementptr inbounds nuw i8, ptr %131, i32 4
  %161 = load i32, ptr %160, align 4, !tbaa !25
  tail call void @gfx_fill(i32 noundef %132, i32 noundef %159, i32 noundef %161, i32 noundef %158, i16 noundef zeroext -1) #6
  %162 = load i32, ptr %131, align 4, !tbaa !19
  %163 = sub nsw i32 %162, %108
  store i32 %163, ptr %131, align 4, !tbaa !19
  %164 = load i32, ptr %160, align 4, !tbaa !25
  %165 = add nsw i32 %164, %163
  %166 = icmp slt i32 %165, 1
  br i1 %166, label %167, label %175

167:                                              ; preds = %156
  %168 = add nsw i32 %164, %132
  %169 = icmp sgt i32 %168, 0
  br i1 %169, label %170, label %174

170:                                              ; preds = %167
  %171 = load i32, ptr %157, align 4, !tbaa !26
  %172 = sub nsw i32 190, %171
  %173 = add nsw i32 %168, -1
  tail call void @lcd_flush(i32 noundef 0, i32 noundef %172, i32 noundef %173, i32 noundef 189) #6
  br label %174

174:                                              ; preds = %170, %167
  store i32 -1000, ptr %131, align 4, !tbaa !19
  br label %175

175:                                              ; preds = %156, %174, %135, %143
  %176 = phi i32 [ %155, %143 ], [ %126, %135 ], [ %126, %174 ], [ %126, %156 ]
  %177 = add nuw nsw i32 %125, 1
  br label %124, !llvm.loop !29

178:                                              ; preds = %128, %181
  %179 = phi i32 [ %189, %181 ], [ 0, %128 ]
  %180 = icmp eq i32 %179, 2
  br i1 %180, label %190, label %181

181:                                              ; preds = %178
  %182 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %179
  %183 = load i32, ptr %182, align 4, !tbaa !15
  %184 = getelementptr inbounds nuw i8, ptr %182, i32 4
  %185 = load i32, ptr %184, align 4, !tbaa !18
  tail call void @gfx_fill(i32 noundef %183, i32 noundef %185, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -1) #6
  %186 = add nsw i32 %183, -2
  %187 = icmp slt i32 %183, -18
  %188 = select i1 %187, i32 240, i32 %186
  store i32 %188, ptr %182, align 4, !tbaa !15
  %189 = add nuw nsw i32 %179, 1
  br label %178, !llvm.loop !30

190:                                              ; preds = %178, %205
  %191 = phi i32 [ %206, %205 ], [ 0, %178 ]
  %192 = icmp eq i32 %191, 2
  br i1 %192, label %129, label %193

193:                                              ; preds = %190
  %194 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %191
  %195 = load i32, ptr %194, align 4, !tbaa !15
  %196 = getelementptr inbounds nuw i8, ptr %194, i32 4
  %197 = load i32, ptr %196, align 4, !tbaa !18
  tail call void @gfx_blit_spans(i32 noundef %195, i32 noundef %197, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6544)) #6
  %198 = tail call i32 @llvm.smax.i32(i32 %195, i32 0)
  %199 = tail call i32 @llvm.smin.i32(i32 %195, i32 218)
  %200 = add nsw i32 %199, 22
  %201 = icmp sgt i32 %200, %198
  br i1 %201, label %202, label %205

202:                                              ; preds = %193
  %203 = add nsw i32 %199, 21
  %204 = add nsw i32 %197, 4
  tail call void @lcd_flush(i32 noundef %198, i32 noundef %197, i32 noundef %203, i32 noundef %204) #6
  br label %205

205:                                              ; preds = %202, %193
  %206 = add nuw nsw i32 %191, 1
  br label %190, !llvm.loop !31

207:                                              ; preds = %129, %235
  %208 = phi i32 [ %236, %235 ], [ 0, %129 ]
  %209 = icmp eq i32 %208, 2
  br i1 %209, label %210, label %211

210:                                              ; preds = %207
  br i1 %115, label %237, label %248

211:                                              ; preds = %207
  %212 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %208
  %213 = load i32, ptr %212, align 4, !tbaa !19
  %214 = icmp slt i32 %213, -100
  br i1 %214, label %235, label %215

215:                                              ; preds = %211
  %216 = getelementptr inbounds nuw i8, ptr %212, i32 8
  %217 = load i32, ptr %216, align 4, !tbaa !26
  %218 = sub nsw i32 190, %217
  %219 = getelementptr inbounds nuw i8, ptr %212, i32 12
  %220 = load ptr, ptr %219, align 4, !tbaa !27
  %221 = getelementptr inbounds nuw i8, ptr %212, i32 4
  %222 = load i32, ptr %221, align 4, !tbaa !25
  %223 = getelementptr inbounds nuw i8, ptr %212, i32 16
  %224 = load ptr, ptr %223, align 4, !tbaa !28
  tail call void @gfx_blit_spans(i32 noundef %213, i32 noundef %218, ptr noundef %220, i32 noundef %222, i32 noundef %217, ptr noundef %224) #6
  %225 = load i32, ptr %212, align 4, !tbaa !19
  %226 = tail call i32 @llvm.smax.i32(i32 %225, i32 0)
  %227 = getelementptr inbounds nuw [2 x i32], ptr %2, i32 0, i32 %208
  %228 = load i32, ptr %227, align 4, !tbaa !24
  %229 = load i32, ptr %221, align 4, !tbaa !25
  %230 = add nsw i32 %229, %228
  %231 = tail call i32 @llvm.smin.i32(i32 %230, i32 240)
  %232 = load i32, ptr %216, align 4, !tbaa !26
  %233 = sub nsw i32 190, %232
  %234 = add nsw i32 %231, -1
  tail call void @lcd_flush(i32 noundef %226, i32 noundef %233, i32 noundef %234, i32 noundef 189) #6
  br label %235

235:                                              ; preds = %211, %215
  %236 = add nuw nsw i32 %208, 1
  br label %207, !llvm.loop !32

237:                                              ; preds = %210
  %238 = and i32 %55, 8
  %239 = icmp eq i32 %238, 0
  %240 = select i1 %239, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 880), ptr @arena_w
  %241 = select i1 %239, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 6348), ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 6304)
  %242 = icmp sgt i32 %101, 0
  %243 = select i1 %242, ptr @arena_w, ptr %240
  %244 = select i1 %242, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 6304), ptr %241
  tail call void @gfx_blit_spans(i32 noundef 30, i32 noundef %111, ptr noundef nonnull %243, i32 noundef 20, i32 noundef 22, ptr noundef nonnull %244) #6
  %245 = tail call i32 @llvm.smin.i32(i32 %111, i32 %43)
  %246 = tail call i32 @llvm.smax.i32(i32 %111, i32 %43)
  %247 = add nsw i32 %246, 21
  tail call void @lcd_flush(i32 noundef 30, i32 noundef %245, i32 noundef 49, i32 noundef %247) #6
  br label %248

248:                                              ; preds = %237, %210
  %249 = phi i32 [ %111, %237 ], [ %43, %210 ]
  %250 = add nsw i32 %108, %44
  %251 = icmp sgt i32 %250, 23
  %252 = add nsw i32 %250, -24
  %253 = select i1 %251, i32 %252, i32 %250
  tail call fastcc void @draw_dashes(i32 noundef %253) #5
  tail call void @lcd_flush(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #6
  %254 = and i32 %55, 3
  %255 = icmp eq i32 %254, 0
  br i1 %255, label %256, label %272

256:                                              ; preds = %248
  %257 = add i32 %51, 1
  br label %258

258:                                              ; preds = %266, %256
  %259 = phi i32 [ 4, %256 ], [ %267, %266 ]
  %260 = icmp sgt i32 %259, -1
  br i1 %260, label %261, label %268

261:                                              ; preds = %258
  %262 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %259
  %263 = load i8, ptr %262, align 1, !tbaa !13
  %264 = add i8 %263, 1
  store i8 %264, ptr %262, align 1, !tbaa !13
  %265 = icmp slt i8 %264, 58
  br i1 %265, label %268, label %266

266:                                              ; preds = %261
  store i8 48, ptr %262, align 1, !tbaa !13
  %267 = add nsw i32 %259, -1
  br label %258, !llvm.loop !33

268:                                              ; preds = %258, %261
  %269 = add i32 %49, 1
  %270 = icmp eq i32 %269, 100
  br i1 %270, label %271, label %272

271:                                              ; preds = %268
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 6) #6
  tail call void @led_rainbow(i32 noundef 30) #6
  br label %272

272:                                              ; preds = %268, %271, %248
  %273 = phi i32 [ 0, %271 ], [ %269, %268 ], [ %49, %248 ]
  %274 = phi i32 [ %257, %271 ], [ %257, %268 ], [ %51, %248 ]
  %275 = icmp slt i32 %47, 1280
  %276 = and i32 %55, 63
  %277 = icmp eq i32 %276, 0
  %278 = select i1 %275, i1 %277, i1 false
  %279 = add nsw i32 %47, 8
  %280 = lshr exact i32 %55, 6
  %281 = and i32 %280, 1
  %282 = select i1 %278, i32 %281, i32 0
  %283 = add nuw nsw i32 %46, %282
  %284 = select i1 %278, i32 %279, i32 %47
  %285 = and i32 %50, 1
  %286 = icmp eq i32 %285, 0
  br i1 %286, label %288, label %287

287:                                              ; preds = %272
  tail call fastcc void @draw_score() #5
  tail call void @lcd_flush(i32 noundef 192, i32 noundef 8, i32 noundef 231, i32 noundef 15) #6
  br label %288

288:                                              ; preds = %287, %272
  %289 = sub i32 189, %101
  %290 = add i32 %101, -172
  %291 = icmp sgt i32 %290, -191
  br label %292

292:                                              ; preds = %311, %288
  %293 = phi i32 [ 0, %288 ], [ %312, %311 ]
  %294 = icmp eq i32 %293, 2
  br i1 %294, label %41, label %295, !llvm.loop !34

295:                                              ; preds = %292
  %296 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %293
  %297 = load i32, ptr %296, align 4, !tbaa !19
  %298 = add i32 %297, 100
  %299 = icmp ult i32 %298, 145
  br i1 %299, label %300, label %311

300:                                              ; preds = %295
  %301 = getelementptr inbounds nuw i8, ptr %296, i32 8
  %302 = load i32, ptr %301, align 4, !tbaa !26
  %303 = sub i32 192, %302
  %304 = getelementptr inbounds nuw i8, ptr %296, i32 4
  %305 = load i32, ptr %304, align 4, !tbaa !25
  %306 = add nsw i32 %305, %297
  %307 = icmp sgt i32 %306, 35
  %308 = icmp sgt i32 %289, %303
  %309 = and i1 %291, %308
  %310 = select i1 %307, i1 %309, i1 false
  br i1 %310, label %313, label %311

311:                                              ; preds = %300, %295
  %312 = add nuw nsw i32 %293, 1
  br label %292, !llvm.loop !35

313:                                              ; preds = %300
  tail call void @led_blink(i32 noundef 16711680, i32 noundef 3) #6
  tail call void @gfx_fill(i32 noundef 30, i32 noundef %111, i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1) #6
  tail call void @gfx_blit_spans(i32 noundef 30, i32 noundef %111, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1760), i32 noundef 20, i32 noundef 22, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6392)) #6
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 56, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #6
  tail call void @gfx_text(i32 noundef 24, i32 noundef 80, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #6
  tail call void @gfx_present() #6
  %314 = load i32, ptr @sfx_tab, align 4, !tbaa !24
  %315 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sfx_tab, i32 4), align 4, !tbaa !24
  tail call void @pcm_play(i32 noundef %314, i32 noundef %315) #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  tail call void @uputn(i32 noundef %274) #6
  tail call void @uputs(ptr noundef nonnull @.str.4) #6
  br label %316

316:                                              ; preds = %321, %313
  tail call void @frame_sync(i32 noundef 16667) #6
  tail call void @in_poll() #6
  %317 = load i32, ptr @in_edge, align 4, !tbaa !24
  %318 = and i32 %317, 17
  %319 = icmp eq i32 %318, 0
  br i1 %319, label %321, label %320

320:                                              ; preds = %316
  tail call void @pcm_stop() #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  br label %33

321:                                              ; preds = %316
  %322 = and i32 %317, 2
  %323 = icmp eq i32 %322, 0
  br i1 %323, label %316, label %324, !llvm.loop !36

324:                                              ; preds = %321
  tail call void @pcm_stop() #6
  tail call void @led(i32 noundef 0, i32 noundef 0) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_glyph_cell(i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @cell_render(ptr noundef readonly captures(none) %0, i32 noundef range(i32 12, 21) %1, i32 noundef range(i32 5, 31) %2, i16 noundef zeroext range(i16 -16871, 14824) %3, ptr noundef writeonly captures(none) %4) unnamed_addr #3 {
  %6 = mul nuw nsw i32 %2, %1
  br label %7

7:                                                ; preds = %13, %5
  %8 = phi i32 [ 0, %5 ], [ %15, %13 ]
  %9 = icmp eq i32 %8, %6
  br i1 %9, label %10, label %13

10:                                               ; preds = %7
  %11 = sub nuw nsw i32 32, %1
  %12 = shl nuw nsw i32 1, %11
  br label %16

13:                                               ; preds = %7
  %14 = getelementptr inbounds nuw i16, ptr %4, i32 %8
  store i16 -1, ptr %14, align 2, !tbaa !3
  %15 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !37

16:                                               ; preds = %10, %30
  %17 = phi i32 [ %31, %30 ], [ 0, %10 ]
  %18 = icmp eq i32 %17, %2
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  ret void

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i32, ptr %0, i32 %17
  %22 = load i32, ptr %21, align 4, !tbaa !24
  %23 = mul nuw nsw i32 %17, %1
  %24 = getelementptr inbounds nuw i16, ptr %4, i32 %23
  br label %25

25:                                               ; preds = %37, %20
  %26 = phi i32 [ %12, %20 ], [ %38, %37 ]
  %27 = phi i32 [ %1, %20 ], [ %28, %37 ]
  %28 = add nsw i32 %27, -1
  %29 = icmp sgt i32 %27, 0
  br i1 %29, label %32, label %30

30:                                               ; preds = %25
  %31 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !38

32:                                               ; preds = %25
  %33 = and i32 %26, %22
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %37, label %35

35:                                               ; preds = %32
  %36 = getelementptr inbounds nuw i16, ptr %24, i32 %28
  store i16 %3, ptr %36, align 2, !tbaa !3
  br label %37

37:                                               ; preds = %32, %35
  %38 = shl i32 %26, 1
  br label %25, !llvm.loop !39
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_cell_spans(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_dashes(i32 noundef range(i32 -2147483648, 2147483624) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4496), i32 %0
  %3 = ptrtoint ptr %2 to i32
  tail call void @gdma_rows(i32 noundef ptrtoint (ptr getelementptr inbounds nuw (i8, ptr @fb, i32 93600) to i32), i32 noundef %3, i32 noundef 120, i32 noundef 1, i32 noundef 0, i32 noundef 480) #6
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score() unnamed_addr #0 {
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %15, %5 ]
  %3 = icmp eq i32 %2, 5
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  ret void

5:                                                ; preds = %1
  %6 = shl nuw nsw i32 %2, 3
  %7 = or disjoint i32 %6, 2112
  %8 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %7
  %9 = ptrtoint ptr %8 to i32
  %10 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %2
  %11 = load i8, ptr %10, align 1, !tbaa !13
  %12 = sext i8 %11 to i32
  %13 = getelementptr [64 x i16], ptr getelementptr (i8, ptr @arena_w, i32 -1120), i32 %12
  %14 = ptrtoint ptr %13 to i32
  tail call void @gdma_rows(i32 noundef %9, i32 noundef %14, i32 noundef 4, i32 noundef 8, i32 noundef 480, i32 noundef 16) #6
  %15 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !40
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit_spans(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @lcd_flush(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @led_rainbow(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @pcm_play(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @pcm_stop() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gdma_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #4

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"short", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = !{!5, !5, i64 0}
!14 = distinct !{!14, !8, !9}
!15 = !{!16, !17, i64 0}
!16 = !{!"cld", !17, i64 0, !17, i64 4}
!17 = !{!"int", !5, i64 0}
!18 = !{!16, !17, i64 4}
!19 = !{!20, !17, i64 0}
!20 = !{!"obst", !17, i64 0, !17, i64 4, !17, i64 8, !21, i64 12, !23, i64 16}
!21 = !{!"p1 short", !22, i64 0}
!22 = !{!"any pointer", !5, i64 0}
!23 = !{!"p1 omnipotent char", !22, i64 0}
!24 = !{!17, !17, i64 0}
!25 = !{!20, !17, i64 4}
!26 = !{!20, !17, i64 8}
!27 = !{!20, !21, i64 12}
!28 = !{!20, !23, i64 16}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !9}
!37 = distinct !{!37, !8, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
!40 = distinct !{!40, !8, !9}
