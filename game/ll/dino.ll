; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr }
%struct.cld = type { i32, i32 }

@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@cell_run_a = internal global [440 x i16] zeroinitializer, align 2
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 123731968, i32 7340032, i32 0], align 4
@cell_run_b = internal global [440 x i16] zeroinitializer, align 2
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@cell_dead = internal global [440 x i16] zeroinitializer, align 2
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@cell_cact_s = internal global [288 x i16] zeroinitializer, align 2
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@cell_cact_l = internal global [540 x i16] zeroinitializer, align 2
@art_cloud = internal constant [5 x i32] [i32 130023424, i32 536051712, i32 1073725440, i32 2147475456, i32 1073709056], align 4
@cell_cloud = internal global [100 x i16] zeroinitializer, align 2
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  %1 = alloca [2 x %struct.cld], align 4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_a) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_b) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_dead) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_s) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_l) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cloud, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -16871, i16 noundef zeroext -1, ptr noundef nonnull @cell_cloud) #4
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 12
  br label %5

5:                                                ; preds = %199, %0
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  tail call void @gfx_clear(i16 noundef zeroext -1) #4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #4
  tail call fastcc void @draw_dashes(i32 noundef 0) #5
  tail call fastcc void @draw_score(i32 noundef 0) #5
  tail call void @gfx_present() #4
  store i32 150, ptr %1, align 4, !tbaa !3
  store i32 40, ptr %2, align 4, !tbaa !8
  store i32 40, ptr %3, align 4, !tbaa !3
  store i32 64, ptr %4, align 4, !tbaa !8
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 40, ptr noundef nonnull @cell_cloud, i32 noundef 20, i32 noundef 5) #4
  tail call void @gfx_blit(i32 noundef 40, i32 noundef 64, ptr noundef nonnull @cell_cloud, i32 noundef 20, i32 noundef 5) #4
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 16), align 4, !tbaa !9
  store i32 -1000, ptr @obs, align 4, !tbaa !9
  br label %6

6:                                                ; preds = %178, %5
  %7 = phi i32 [ 168, %5 ], [ %172, %178 ]
  %8 = phi i32 [ 0, %5 ], [ %54, %178 ]
  %9 = phi i32 [ 0, %5 ], [ %50, %178 ]
  %10 = phi i32 [ 512, %5 ], [ %154, %178 ]
  %11 = phi i32 [ 90, %5 ], [ %46, %178 ]
  %12 = phi i32 [ 0, %5 ], [ %16, %178 ]
  %13 = phi i32 [ 0, %5 ], [ %148, %178 ]
  %14 = phi i32 [ 0, %5 ], [ %33, %178 ]
  %15 = phi i32 [ 0, %5 ], [ %34, %178 ]
  tail call void @frame_sync(i32 noundef 16667) #4
  tail call void @in_poll() #4
  %16 = add i32 %12, 1
  %17 = load i32, ptr @in_edge, align 4, !tbaa !13
  %18 = and i32 %17, 17
  %19 = icmp ne i32 %18, 0
  %20 = icmp eq i32 %15, 0
  %21 = and i1 %19, %20
  br i1 %21, label %22, label %23

22:                                               ; preds = %6
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 6) #4
  br label %26

23:                                               ; preds = %6
  br i1 %20, label %24, label %26

24:                                               ; preds = %23
  %25 = icmp sgt i32 %14, 0
  br i1 %25, label %26, label %32

26:                                               ; preds = %22, %24, %23
  %27 = phi i32 [ %14, %24 ], [ %14, %23 ], [ 1200, %22 ]
  %28 = add nsw i32 %27, %15
  %29 = add nsw i32 %27, -64
  %30 = icmp slt i32 %28, 1
  br i1 %30, label %31, label %32

31:                                               ; preds = %26
  br label %32

32:                                               ; preds = %26, %31, %24
  %33 = phi i32 [ 0, %31 ], [ %29, %26 ], [ %14, %24 ]
  %34 = phi i32 [ 0, %31 ], [ %28, %26 ], [ 0, %24 ]
  %35 = add nsw i32 %10, %9
  %36 = ashr i32 %35, 8
  %37 = and i32 %36, -2
  %38 = icmp sgt i32 %11, 0
  %39 = sext i1 %38 to i32
  %40 = add nsw i32 %11, %39
  %41 = icmp ugt i32 %13, 100
  %42 = ashr i32 %10, 4
  %43 = and i32 %42, -16
  br label %44

44:                                               ; preds = %115, %32
  %45 = phi i32 [ 0, %32 ], [ %117, %115 ]
  %46 = phi i32 [ %40, %32 ], [ %116, %115 ]
  %47 = icmp eq i32 %45, 2
  br i1 %47, label %48, label %57

48:                                               ; preds = %44
  %49 = shl nsw i32 %37, 8
  %50 = sub nsw i32 %35, %49
  %51 = add nsw i32 %37, %8
  %52 = icmp sgt i32 %51, 23
  %53 = add nsw i32 %51, -24
  %54 = select i1 %52, i32 %53, i32 %51
  tail call fastcc void @draw_dashes(i32 noundef %54) #5
  tail call void @lcd_flush(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #4
  %55 = and i32 %16, 15
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %118, label %139

57:                                               ; preds = %44
  %58 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %45
  %59 = getelementptr inbounds nuw i8, ptr %58, i32 8
  %60 = load i32, ptr %59, align 4, !tbaa !14
  %61 = sub nsw i32 190, %60
  %62 = load i32, ptr %58, align 4, !tbaa !9
  %63 = icmp slt i32 %62, -100
  br i1 %63, label %64, label %82

64:                                               ; preds = %57
  %65 = icmp eq i32 %46, 0
  br i1 %65, label %66, label %115

66:                                               ; preds = %64
  br i1 %41, label %67, label %71

67:                                               ; preds = %66
  %68 = tail call i32 @rng() #4
  %69 = and i32 %68, 3
  %70 = icmp eq i32 %69, 0
  br i1 %70, label %72, label %71

71:                                               ; preds = %67, %66
  br label %72

72:                                               ; preds = %67, %71
  %73 = phi i32 [ 12, %71 ], [ 18, %67 ]
  %74 = phi i32 [ 24, %71 ], [ 30, %67 ]
  %75 = phi ptr [ @cell_cact_s, %71 ], [ @cell_cact_l, %67 ]
  %76 = getelementptr inbounds nuw i8, ptr %58, i32 4
  store i32 %73, ptr %76, align 4, !tbaa !15
  store i32 %74, ptr %59, align 4, !tbaa !14
  %77 = getelementptr inbounds nuw i8, ptr %58, i32 12
  store ptr %75, ptr %77, align 4, !tbaa !16
  store i32 240, ptr %58, align 4, !tbaa !9
  %78 = tail call i32 @rng_below(i32 noundef 80) #4
  %79 = sub i32 %78, %43
  %80 = add i32 %79, 60
  %81 = tail call i32 @llvm.smax.i32(i32 %80, i32 36)
  br label %115

82:                                               ; preds = %57
  %83 = tail call i32 @llvm.smax.i32(i32 %62, i32 0)
  %84 = getelementptr inbounds nuw i8, ptr %58, i32 4
  %85 = load i32, ptr %84, align 4, !tbaa !15
  %86 = tail call i32 @llvm.smin.i32(i32 %62, i32 0)
  %87 = add nsw i32 %85, %86
  tail call void @gfx_fill(i32 noundef %83, i32 noundef %61, i32 noundef %87, i32 noundef %60, i16 noundef zeroext -1) #4
  %88 = load i32, ptr %58, align 4, !tbaa !9
  %89 = sub nsw i32 %88, %37
  store i32 %89, ptr %58, align 4, !tbaa !9
  %90 = load i32, ptr %84, align 4, !tbaa !15
  %91 = add nsw i32 %90, %89
  %92 = icmp slt i32 %91, 1
  br i1 %92, label %93, label %105

93:                                               ; preds = %82
  %94 = add nsw i32 %90, %62
  %95 = load i32, ptr %59, align 4, !tbaa !14
  %96 = tail call i32 @llvm.smin.i32(i32 %94, i32 240)
  %97 = icmp slt i32 %94, 1
  br i1 %97, label %104, label %98

98:                                               ; preds = %93
  %99 = icmp slt i32 %95, 1
  br i1 %99, label %104, label %100

100:                                              ; preds = %98
  tail call void @gfx_fill(i32 noundef 0, i32 noundef range(i32 -2147483457, -2147483648) %61, i32 noundef %96, i32 noundef %95, i16 noundef zeroext -1) #4
  %101 = add nsw i32 %96, -1
  %102 = sub i32 %95, %60
  %103 = add i32 %102, 189
  tail call void @lcd_flush(i32 noundef 0, i32 noundef range(i32 -2147483457, -2147483648) %61, i32 noundef %101, i32 noundef %103) #4
  br label %104

104:                                              ; preds = %93, %98, %100
  store i32 -1000, ptr %58, align 4, !tbaa !9
  br label %115

105:                                              ; preds = %82
  %106 = getelementptr inbounds nuw i8, ptr %58, i32 12
  %107 = load ptr, ptr %106, align 4, !tbaa !16
  %108 = load i32, ptr %59, align 4, !tbaa !14
  tail call void @gfx_blit(i32 noundef %89, i32 noundef %61, ptr noundef %107, i32 noundef %90, i32 noundef %108) #4
  %109 = load i32, ptr %58, align 4, !tbaa !9
  %110 = tail call i32 @llvm.smax.i32(i32 %109, i32 0)
  %111 = load i32, ptr %84, align 4, !tbaa !15
  %112 = add nsw i32 %111, %62
  %113 = tail call i32 @llvm.smin.i32(i32 %112, i32 240)
  %114 = add nsw i32 %113, -1
  tail call void @lcd_flush(i32 noundef %110, i32 noundef %61, i32 noundef %114, i32 noundef 189) #4
  br label %115

115:                                              ; preds = %104, %105, %64, %72
  %116 = phi i32 [ %81, %72 ], [ %46, %64 ], [ %46, %105 ], [ %46, %104 ]
  %117 = add nuw nsw i32 %45, 1
  br label %44, !llvm.loop !17

118:                                              ; preds = %48, %137
  %119 = phi i32 [ %138, %137 ], [ 0, %48 ]
  %120 = icmp eq i32 %119, 2
  br i1 %120, label %139, label %121

121:                                              ; preds = %118
  %122 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %119
  %123 = load i32, ptr %122, align 4, !tbaa !3
  %124 = tail call i32 @llvm.smax.i32(i32 %123, i32 0)
  %125 = getelementptr inbounds nuw i8, ptr %122, i32 4
  %126 = load i32, ptr %125, align 4, !tbaa !8
  tail call void @gfx_fill(i32 noundef %124, i32 noundef %126, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -1) #4
  %127 = add nsw i32 %123, -2
  %128 = icmp slt i32 %123, -18
  %129 = select i1 %128, i32 240, i32 %127
  store i32 %129, ptr %122, align 4, !tbaa !3
  tail call void @gfx_blit(i32 noundef %129, i32 noundef %126, ptr noundef nonnull @cell_cloud, i32 noundef 20, i32 noundef 5) #4
  %130 = tail call i32 @llvm.smax.i32(i32 %129, i32 0)
  %131 = tail call i32 @llvm.smin.i32(i32 %123, i32 220)
  %132 = add nsw i32 %131, 20
  %133 = icmp sgt i32 %132, %130
  br i1 %133, label %134, label %137

134:                                              ; preds = %121
  %135 = add nsw i32 %131, 19
  %136 = add nsw i32 %126, 4
  tail call void @lcd_flush(i32 noundef %130, i32 noundef %126, i32 noundef %135, i32 noundef %136) #4
  br label %137

137:                                              ; preds = %134, %121
  %138 = add nuw nsw i32 %119, 1
  br label %118, !llvm.loop !20

139:                                              ; preds = %118, %48
  %140 = and i32 %16, 3
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %142, label %147

142:                                              ; preds = %139
  %143 = add i32 %13, 1
  %144 = urem i32 %143, 100
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %146, label %147

146:                                              ; preds = %142
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 6) #4
  tail call void @led_rainbow(i32 noundef 30) #4
  br label %147

147:                                              ; preds = %142, %146, %139
  %148 = phi i32 [ %143, %146 ], [ %143, %142 ], [ %13, %139 ]
  %149 = icmp slt i32 %10, 1280
  %150 = and i32 %16, 63
  %151 = icmp eq i32 %150, 0
  %152 = select i1 %149, i1 %151, i1 false
  %153 = add nsw i32 %10, 8
  %154 = select i1 %152, i32 %153, i32 %10
  %155 = lshr i32 %34, 8
  %156 = sub nsw i32 168, %155
  %157 = icmp eq i32 %156, %7
  br i1 %157, label %158, label %161

158:                                              ; preds = %147
  %159 = and i32 %16, 7
  %160 = icmp eq i32 %159, 0
  br i1 %160, label %161, label %171

161:                                              ; preds = %158, %147
  %162 = tail call i32 @llvm.smin.i32(i32 %156, i32 %7)
  %163 = add nsw i32 %7, 22
  %164 = sub i32 %163, %162
  tail call void @gfx_fill(i32 noundef 30, i32 noundef %162, i32 noundef 20, i32 noundef %164, i16 noundef zeroext -1) #4
  %165 = and i32 %16, 8
  %166 = icmp eq i32 %165, 0
  %167 = icmp eq i32 %34, 0
  %168 = select i1 %167, i1 %166, i1 false
  %169 = select i1 %168, ptr @cell_run_b, ptr @cell_run_a
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %156, ptr noundef nonnull %169, i32 noundef 20, i32 noundef 22) #4
  %170 = add nsw i32 %7, 21
  tail call void @lcd_flush(i32 noundef 30, i32 noundef %162, i32 noundef 49, i32 noundef %170) #4
  br label %171

171:                                              ; preds = %161, %158
  %172 = phi i32 [ %156, %161 ], [ %7, %158 ]
  %173 = and i32 %12, 1
  %174 = icmp eq i32 %173, 0
  br i1 %174, label %176, label %175

175:                                              ; preds = %171
  tail call fastcc void @draw_score(i32 noundef %148) #5
  tail call void @lcd_flush(i32 noundef 192, i32 noundef 8, i32 noundef 231, i32 noundef 15) #4
  br label %176

176:                                              ; preds = %175, %171
  %177 = sub nsw i32 189, %155
  br label %178

178:                                              ; preds = %196, %176
  %179 = phi i32 [ 0, %176 ], [ %197, %196 ]
  %180 = icmp eq i32 %179, 2
  br i1 %180, label %6, label %181, !llvm.loop !21

181:                                              ; preds = %178
  %182 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %179
  %183 = load i32, ptr %182, align 4, !tbaa !9
  %184 = add i32 %183, 100
  %185 = icmp ult i32 %184, 145
  br i1 %185, label %186, label %196

186:                                              ; preds = %181
  %187 = getelementptr inbounds nuw i8, ptr %182, i32 8
  %188 = load i32, ptr %187, align 4, !tbaa !14
  %189 = sub i32 192, %188
  %190 = getelementptr inbounds nuw i8, ptr %182, i32 4
  %191 = load i32, ptr %190, align 4, !tbaa !15
  %192 = add nsw i32 %191, %183
  %193 = icmp sgt i32 %192, 35
  %194 = icmp sgt i32 %177, %189
  %195 = select i1 %193, i1 %194, i1 false
  br i1 %195, label %198, label %196

196:                                              ; preds = %186, %181
  %197 = add nuw nsw i32 %179, 1
  br label %178, !llvm.loop !22

198:                                              ; preds = %186
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 36) #4
  tail call void @led_blink(i32 noundef 16711680, i32 noundef 3) #4
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %156, ptr noundef nonnull @cell_dead, i32 noundef 20, i32 noundef 22) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 56, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #4
  tail call void @gfx_text(i32 noundef 24, i32 noundef 80, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #4
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  tail call void @uputn(i32 noundef %148) #4
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  br label %199

199:                                              ; preds = %203, %198
  tail call void @frame_sync(i32 noundef 16667) #4
  tail call void @in_poll() #4
  %200 = load i32, ptr @in_edge, align 4, !tbaa !13
  %201 = and i32 %200, 17
  %202 = icmp eq i32 %201, 0
  br i1 %202, label %203, label %5

203:                                              ; preds = %199
  %204 = and i32 %200, 2
  %205 = icmp eq i32 %204, 0
  br i1 %205, label %199, label %206, !llvm.loop !23

206:                                              ; preds = %203
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
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
define internal fastcc void @draw_dashes(i32 noundef %0) unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 195, i32 noundef 240, i32 noundef 1, i16 noundef zeroext -1) #4
  %2 = sub nsw i32 6, %0
  br label %3

3:                                                ; preds = %17, %1
  %4 = phi i32 [ %2, %1 ], [ %18, %17 ]
  %5 = icmp slt i32 %4, 240
  br i1 %5, label %7, label %6

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = tail call i32 @llvm.smax.i32(i32 %4, i32 0)
  %9 = tail call i32 @llvm.smin.i32(i32 %4, i32 0)
  %10 = add nsw i32 %9, 8
  %11 = add nsw i32 %10, %8
  %12 = icmp sgt i32 %11, 240
  %13 = sub nuw nsw i32 240, %8
  %14 = select i1 %12, i32 %13, i32 %10
  %15 = icmp sgt i32 %14, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %7
  tail call void @gfx_fill(i32 noundef %8, i32 noundef 195, i32 noundef %14, i32 noundef 1, i16 noundef zeroext 14823) #4
  br label %17

17:                                               ; preds = %16, %7
  %18 = add nsw i32 %4, 24
  br label %3, !llvm.loop !24
}

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
declare dso_local void @gfx_blit(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

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

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @lcd_flush(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @led_rainbow(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #1

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
declare i32 @llvm.smin.i32(i32, i32) #3

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
!3 = !{!4, !5, i64 0}
!4 = !{!"cld", !5, i64 0, !5, i64 4}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!4, !5, i64 4}
!9 = !{!10, !5, i64 0}
!10 = !{!"obst", !5, i64 0, !5, i64 4, !5, i64 8, !11, i64 12}
!11 = !{!"p1 short", !12, i64 0}
!12 = !{!"any pointer", !6, i64 0}
!13 = !{!5, !5, i64 0}
!14 = !{!10, !5, i64 8}
!15 = !{!10, !5, i64 4}
!16 = !{!10, !11, i64 12}
!17 = distinct !{!17, !18, !19}
!18 = !{!"llvm.loop.mustprogress"}
!19 = !{!"llvm.loop.unroll.disable"}
!20 = distinct !{!20, !18, !19}
!21 = distinct !{!21, !19}
!22 = distinct !{!22, !18, !19}
!23 = distinct !{!23, !19}
!24 = distinct !{!24, !18, !19}
