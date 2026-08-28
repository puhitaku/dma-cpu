; ModuleID = 'puni.c'
source_filename = "puni.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [13 x i8] c"puni: start\0A\00", align 1
@puni_run.pc = internal unnamed_addr constant [5 x i16] [i16 -5590, i16 15947, i16 17374, i16 -2489, i16 -1], align 2
@arena_w = external dso_local global [2304 x i32], align 4
@.str.1 = private unnamed_addr constant [5 x i8] c"PUNI\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"puni: quit\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.3 = private unnamed_addr constant [13 x i8] c"puni: again\0A\00", align 1
@sdx = internal unnamed_addr constant [4 x i8] c"\00\01\00\FF", align 1
@sdy = internal unnamed_addr constant [4 x i8] c"\FF\00\01\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.4 = private unnamed_addr constant [12 x i8] c"puni: lock\0A\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.6 = private unnamed_addr constant [19 x i8] c"Press to try again\00", align 1
@.str.7 = private unnamed_addr constant [19 x i8] c"Down: back to menu\00", align 1
@.str.8 = private unnamed_addr constant [17 x i8] c"puni: game over\0A\00", align 1
@.str.9 = private unnamed_addr constant [11 x i8] c"puni: pop \00", align 1
@.str.10 = private unnamed_addr constant [8 x i8] c" chain \00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"NEXT\00", align 1
@groups.ddx = internal unnamed_addr constant [4 x i8] c"\00\00\01\FF", align 1
@groups.ddy = internal unnamed_addr constant [4 x i8] c"\01\FF\00\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @puni_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 984076, i32 noundef 265996) #4
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %9, %4 ]
  %3 = icmp eq i32 %2, 5
  br i1 %3, label %10, label %4

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw [5 x i16], ptr @puni_run.pc, i32 0, i32 %2
  %6 = load i16, ptr %5, align 2, !tbaa !3
  %7 = mul nuw nsw i32 %2, 648
  %8 = getelementptr inbounds nuw i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %7
  tail call void @gfx_disc_cell(i32 noundef 18, i32 noundef 8, i16 noundef zeroext %6, i16 noundef zeroext 4228, ptr noundef nonnull %8) #4
  %9 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !7

10:                                               ; preds = %1, %27
  %11 = phi i32 [ %28, %27 ], [ 0, %1 ]
  %12 = icmp eq i32 %11, 12
  br i1 %12, label %13, label %22

13:                                               ; preds = %10
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !13
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 340), align 4, !tbaa !14
  store i32 16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  %14 = tail call i32 @rng_below(i32 noundef 4) #4
  %15 = add nsw i32 %14, 1
  store i32 %15, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  %16 = tail call i32 @rng_below(i32 noundef 4) #4
  %17 = add nsw i32 %16, 1
  store i32 %17, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  %18 = tail call i32 @rng_below(i32 noundef 4) #4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !18
  %20 = tail call i32 @rng_below(i32 noundef 4) #4
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !19
  tail call void @gfx_clear(i16 noundef zeroext 6407) #4
  tail call void @gfx_rect(i32 noundef 8, i32 noundef 8, i32 noundef 116, i32 noundef 224, i32 noundef 2, i16 noundef zeroext 17005) #4
  tail call void @gfx_text2(i32 noundef 150, i32 noundef 12, ptr noundef nonnull @.str.1, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  tail call void @gfx_text2(i32 noundef 150, i32 noundef 30, ptr noundef nonnull @.str.1, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  br label %32

22:                                               ; preds = %10, %29
  %23 = phi i32 [ %31, %29 ], [ 0, %10 ]
  %24 = icmp eq i32 %23, 6
  br i1 %24, label %25, label %29

25:                                               ; preds = %22
  %26 = add nuw nsw i32 %11, 1
  br label %27

27:                                               ; preds = %25, %53
  %28 = phi i32 [ %26, %25 ], [ 0, %53 ]
  br label %10, !llvm.loop !20

29:                                               ; preds = %22
  %30 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %11, i32 %23
  store i8 0, ptr %30, align 1, !tbaa !21
  %31 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !22

32:                                               ; preds = %39, %13
  %33 = phi i32 [ 0, %13 ], [ %40, %39 ]
  %34 = icmp eq i32 %33, 12
  br i1 %34, label %35, label %36

35:                                               ; preds = %32
  tail call fastcc void @score_draw() #5
  tail call fastcc void @pair_spawn() #5
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %43

36:                                               ; preds = %32, %41
  %37 = phi i32 [ %42, %41 ], [ 0, %32 ]
  %38 = icmp eq i32 %37, 6
  br i1 %38, label %39, label %41

39:                                               ; preds = %36
  %40 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !23

41:                                               ; preds = %36
  tail call fastcc void @cell_draw(i32 noundef %37, i32 noundef %33, i32 noundef 0) #5
  %42 = add nuw nsw i32 %37, 1
  br label %36, !llvm.loop !24

43:                                               ; preds = %57, %35
  %44 = tail call fastcc i32 @tick() #5
  %45 = icmp eq i32 %44, 0
  br i1 %45, label %46, label %359

46:                                               ; preds = %43
  %47 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !13
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %58, label %49

49:                                               ; preds = %46
  %50 = load i32, ptr @in_edge, align 4, !tbaa !25
  %51 = and i32 %50, 16
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %54, label %53

53:                                               ; preds = %49
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  br label %27

54:                                               ; preds = %49
  %55 = and i32 %50, 2
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %57, label %359

57:                                               ; preds = %133, %153, %170, %358, %54
  br label %43, !llvm.loop !26

58:                                               ; preds = %46
  %59 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %60 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %61 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %60
  %62 = load i8, ptr %61, align 1, !tbaa !21
  %63 = sext i8 %62 to i32
  %64 = add nsw i32 %59, %63
  %65 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %66 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %60
  %67 = load i8, ptr %66, align 1, !tbaa !21
  %68 = sext i8 %67 to i32
  %69 = add nsw i32 %65, %68
  %70 = load i32, ptr @in_edge, align 4, !tbaa !25
  %71 = and i32 %70, 4
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %85, label %73

73:                                               ; preds = %58
  %74 = add nsw i32 %59, -1
  %75 = tail call fastcc i32 @freeat(i32 noundef %74, i32 noundef %65) #5
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %85, label %77

77:                                               ; preds = %73
  %78 = add nsw i32 %64, -1
  %79 = tail call fastcc i32 @freeat(i32 noundef %78, i32 noundef %69) #5
  %80 = icmp eq i32 %79, 0
  br i1 %80, label %85, label %81

81:                                               ; preds = %77
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %82 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %83 = add nsw i32 %82, -1
  store i32 %83, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 500, i32 noundef 25, i32 noundef 1) #4
  %84 = load i32, ptr @in_edge, align 4, !tbaa !25
  br label %85

85:                                               ; preds = %73, %77, %81, %58
  %86 = phi i32 [ %70, %73 ], [ %70, %77 ], [ %84, %81 ], [ %70, %58 ]
  %87 = and i32 %86, 8
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %103, label %89

89:                                               ; preds = %85
  %90 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %91 = add nsw i32 %90, 1
  %92 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %93 = tail call fastcc i32 @freeat(i32 noundef %91, i32 noundef %92) #5
  %94 = icmp eq i32 %93, 0
  br i1 %94, label %103, label %95

95:                                               ; preds = %89
  %96 = add nsw i32 %64, 1
  %97 = tail call fastcc i32 @freeat(i32 noundef %96, i32 noundef %69) #5
  %98 = icmp eq i32 %97, 0
  br i1 %98, label %103, label %99

99:                                               ; preds = %95
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %100 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %101 = add nsw i32 %100, 1
  store i32 %101, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 500, i32 noundef 25, i32 noundef 1) #4
  %102 = load i32, ptr @in_edge, align 4, !tbaa !25
  br label %103

103:                                              ; preds = %89, %95, %99, %85
  %104 = phi i32 [ %86, %89 ], [ %86, %95 ], [ %102, %99 ], [ %86, %85 ]
  %105 = and i32 %104, 17
  %106 = icmp eq i32 %105, 0
  br i1 %106, label %124, label %107

107:                                              ; preds = %103
  %108 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %109 = add nsw i32 %108, 1
  %110 = and i32 %109, 3
  %111 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %112 = getelementptr inbounds nuw [4 x i8], ptr @sdx, i32 0, i32 %110
  %113 = load i8, ptr %112, align 1, !tbaa !21
  %114 = sext i8 %113 to i32
  %115 = add nsw i32 %111, %114
  %116 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %117 = getelementptr inbounds nuw [4 x i8], ptr @sdy, i32 0, i32 %110
  %118 = load i8, ptr %117, align 1, !tbaa !21
  %119 = sext i8 %118 to i32
  %120 = add nsw i32 %116, %119
  %121 = tail call fastcc i32 @freeat(i32 noundef %115, i32 noundef %120) #5
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %124, label %123

123:                                              ; preds = %107
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  store i32 %110, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 700, i32 noundef 25, i32 noundef 1) #4
  br label %124

124:                                              ; preds = %107, %123, %103
  %125 = load i32, ptr @in_down, align 4, !tbaa !25
  %126 = and i32 %125, 2
  %127 = icmp eq i32 %126, 0
  %128 = select i1 %127, i32 1, i32 8
  %129 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  %130 = add nsw i32 %128, %129
  store i32 %130, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  %131 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  %132 = icmp slt i32 %130, %131
  br i1 %132, label %133, label %134

133:                                              ; preds = %124
  tail call void @gfx_present() #4
  br label %57, !llvm.loop !26

134:                                              ; preds = %124
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  %135 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %136 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %137 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %136
  %138 = load i8, ptr %137, align 1, !tbaa !21
  %139 = sext i8 %138 to i32
  %140 = add nsw i32 %135, %139
  %141 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %142 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %136
  %143 = load i8, ptr %142, align 1, !tbaa !21
  %144 = sext i8 %143 to i32
  %145 = add nsw i32 %141, %144
  %146 = add nsw i32 %141, 1
  %147 = tail call fastcc i32 @freeat(i32 noundef %135, i32 noundef %146) #5
  %148 = icmp eq i32 %147, 0
  br i1 %148, label %156, label %149

149:                                              ; preds = %134
  %150 = add nsw i32 %145, 1
  %151 = tail call fastcc i32 @freeat(i32 noundef %140, i32 noundef %150) #5
  %152 = icmp eq i32 %151, 0
  br i1 %152, label %156, label %153

153:                                              ; preds = %149
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %154 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %155 = add nsw i32 %154, 1
  store i32 %155, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %57, !llvm.loop !26

156:                                              ; preds = %149, %134
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  %157 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %158 = icmp sgt i32 %157, -1
  br i1 %158, label %159, label %164

159:                                              ; preds = %156
  %160 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 300), align 4, !tbaa !31
  %161 = trunc i32 %160 to i8
  %162 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %163 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %157, i32 %162
  store i8 %161, ptr %163, align 1, !tbaa !21
  br label %164

164:                                              ; preds = %159, %156
  %165 = icmp sgt i32 %145, -1
  br i1 %165, label %166, label %170

166:                                              ; preds = %164
  %167 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 304), align 4, !tbaa !32
  %168 = trunc i32 %167 to i8
  %169 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %145, i32 %140
  store i8 %168, ptr %169, align 1, !tbaa !21
  br label %171

170:                                              ; preds = %164
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !13
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -7705, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 48, i32 noundef 140, ptr noundef nonnull @.str.7, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  br label %57, !llvm.loop !26

171:                                              ; preds = %336, %166
  %172 = phi i32 [ 0, %166 ], [ %295, %336 ]
  br label %173

173:                                              ; preds = %180, %171
  %174 = phi i32 [ 0, %171 ], [ %181, %180 ]
  %175 = icmp eq i32 %174, 6
  br i1 %175, label %196, label %176

176:                                              ; preds = %173, %193
  %177 = phi i32 [ %194, %193 ], [ 11, %173 ]
  %178 = phi i32 [ %195, %193 ], [ 11, %173 ]
  %179 = icmp sgt i32 %178, -1
  br i1 %179, label %182, label %180

180:                                              ; preds = %176
  %181 = add nuw nsw i32 %174, 1
  br label %173, !llvm.loop !33

182:                                              ; preds = %176
  %183 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %178, i32 %174
  %184 = load i8, ptr %183, align 1, !tbaa !21
  %185 = icmp eq i8 %184, 0
  br i1 %185, label %193, label %186

186:                                              ; preds = %182
  %187 = icmp eq i32 %177, %178
  br i1 %187, label %191, label %188

188:                                              ; preds = %186
  %189 = zext i8 %184 to i32
  %190 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %177, i32 %174
  store i8 %184, ptr %190, align 1, !tbaa !21
  store i8 0, ptr %183, align 1, !tbaa !21
  tail call fastcc void @cell_draw(i32 noundef %174, i32 noundef %177, i32 noundef %189) #5
  tail call fastcc void @cell_draw(i32 noundef %174, i32 noundef %178, i32 noundef 0) #5
  br label %191

191:                                              ; preds = %188, %186
  %192 = add nsw i32 %177, -1
  br label %193

193:                                              ; preds = %191, %182
  %194 = phi i32 [ %192, %191 ], [ %177, %182 ]
  %195 = add nsw i32 %178, -1
  br label %176, !llvm.loop !34

196:                                              ; preds = %173
  tail call void @gfx_present() #4
  br label %197

197:                                              ; preds = %203, %196
  %198 = phi i32 [ 0, %196 ], [ %204, %203 ]
  %199 = icmp eq i32 %198, 12
  br i1 %199, label %208, label %200

200:                                              ; preds = %197, %205
  %201 = phi i32 [ %207, %205 ], [ 0, %197 ]
  %202 = icmp eq i32 %201, 6
  br i1 %202, label %203, label %205

203:                                              ; preds = %200
  %204 = add nuw nsw i32 %198, 1
  br label %197, !llvm.loop !35

205:                                              ; preds = %200
  %206 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %198, i32 %201
  store i8 0, ptr %206, align 1, !tbaa !21
  %207 = add nuw nsw i32 %201, 1
  br label %200, !llvm.loop !36

208:                                              ; preds = %197, %218
  %209 = phi i32 [ %219, %218 ], [ 0, %197 ]
  %210 = phi i32 [ %216, %218 ], [ 0, %197 ]
  %211 = icmp eq i32 %209, 12
  br i1 %211, label %292, label %212

212:                                              ; preds = %208
  %213 = mul nuw nsw i32 %209, 6
  br label %214

214:                                              ; preds = %289, %212
  %215 = phi i32 [ %291, %289 ], [ 0, %212 ]
  %216 = phi i32 [ %290, %289 ], [ %210, %212 ]
  %217 = icmp eq i32 %215, 6
  br i1 %217, label %218, label %220

218:                                              ; preds = %214
  %219 = add nuw nsw i32 %209, 1
  br label %208, !llvm.loop !37

220:                                              ; preds = %214
  %221 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %209, i32 %215
  %222 = load i8, ptr %221, align 1, !tbaa !21
  %223 = icmp eq i8 %222, 0
  br i1 %223, label %289, label %224

224:                                              ; preds = %220
  %225 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %209, i32 %215
  %226 = load i8, ptr %225, align 1, !tbaa !21
  %227 = icmp eq i8 %226, 0
  br i1 %227, label %228, label %289

228:                                              ; preds = %224
  %229 = add nuw nsw i32 %215, %213
  %230 = trunc nuw i32 %229 to i8
  store i8 %230, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), align 4, !tbaa !21
  store i8 1, ptr %225, align 1, !tbaa !21
  br label %233

231:                                              ; preds = %248
  %232 = add nuw nsw i32 %235, 1
  br label %233, !llvm.loop !38

233:                                              ; preds = %231, %228
  %234 = phi i32 [ 1, %228 ], [ %249, %231 ]
  %235 = phi i32 [ 0, %228 ], [ %232, %231 ]
  %236 = icmp eq i32 %234, 0
  br i1 %236, label %285, label %237

237:                                              ; preds = %233
  %238 = add nsw i32 %234, -1
  %239 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), i32 0, i32 %238
  %240 = load i8, ptr %239, align 1, !tbaa !21
  %241 = zext i8 %240 to i32
  %242 = udiv i8 %240, 6
  %243 = zext nneg i8 %242 to i32
  %244 = mul nsw i32 %243, -6
  %245 = add nsw i32 %244, %241
  %246 = add nsw i32 %235, %216
  %247 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %246
  store i8 %240, ptr %247, align 1, !tbaa !21
  br label %248

248:                                              ; preds = %282, %237
  %249 = phi i32 [ %238, %237 ], [ %283, %282 ]
  %250 = phi i32 [ 0, %237 ], [ %284, %282 ]
  %251 = icmp eq i32 %250, 4
  br i1 %251, label %231, label %252

252:                                              ; preds = %248
  %253 = getelementptr inbounds nuw [4 x i8], ptr @groups.ddx, i32 0, i32 %250
  %254 = load i8, ptr %253, align 1, !tbaa !21
  %255 = sext i8 %254 to i32
  %256 = add nsw i32 %245, %255
  %257 = getelementptr inbounds nuw [4 x i8], ptr @groups.ddy, i32 0, i32 %250
  %258 = load i8, ptr %257, align 1, !tbaa !21
  %259 = sext i8 %258 to i32
  %260 = add nsw i32 %259, %243
  %261 = icmp slt i32 %256, 0
  br i1 %261, label %282, label %262

262:                                              ; preds = %252
  %263 = icmp samesign ugt i32 %256, 5
  br i1 %263, label %282, label %264

264:                                              ; preds = %262
  %265 = icmp slt i32 %260, 0
  br i1 %265, label %282, label %266

266:                                              ; preds = %264
  %267 = icmp samesign ugt i32 %260, 11
  br i1 %267, label %282, label %268

268:                                              ; preds = %266
  %269 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %260, i32 %256
  %270 = load i8, ptr %269, align 1, !tbaa !21
  %271 = icmp eq i8 %270, 0
  br i1 %271, label %272, label %282

272:                                              ; preds = %268
  %273 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %260, i32 %256
  %274 = load i8, ptr %273, align 1, !tbaa !21
  %275 = icmp eq i8 %274, %222
  br i1 %275, label %276, label %282

276:                                              ; preds = %272
  store i8 1, ptr %269, align 1, !tbaa !21
  %277 = mul nuw nsw i32 %260, 6
  %278 = add nuw nsw i32 %277, %256
  %279 = trunc nuw nsw i32 %278 to i8
  %280 = add nsw i32 %249, 1
  %281 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), i32 0, i32 %249
  store i8 %279, ptr %281, align 1, !tbaa !21
  br label %282

282:                                              ; preds = %276, %272, %268, %266, %264, %262, %252
  %283 = phi i32 [ %280, %276 ], [ %249, %266 ], [ %249, %264 ], [ %249, %262 ], [ %249, %252 ], [ %249, %272 ], [ %249, %268 ]
  %284 = add nuw nsw i32 %250, 1
  br label %248, !llvm.loop !39

285:                                              ; preds = %233
  %286 = icmp samesign ugt i32 %235, 3
  %287 = select i1 %286, i32 %235, i32 0
  %288 = add nuw nsw i32 %287, %216
  br label %289

289:                                              ; preds = %285, %224, %220
  %290 = phi i32 [ %288, %285 ], [ %216, %224 ], [ %216, %220 ]
  %291 = add nuw nsw i32 %215, 1
  br label %214, !llvm.loop !40

292:                                              ; preds = %208
  %293 = icmp eq i32 %210, 0
  br i1 %293, label %343, label %294

294:                                              ; preds = %292
  %295 = add nuw nsw i32 %172, 1
  %296 = mul i32 %295, 10
  %297 = mul i32 %296, %210
  %298 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  %299 = add nsw i32 %298, %297
  store i32 %299, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  tail call void @uputs(ptr noundef nonnull @.str.9) #4
  tail call void @uputn(i32 noundef %210) #4
  tail call void @uputs(ptr noundef nonnull @.str.10) #4
  tail call void @uputn(i32 noundef %295) #4
  tail call void @uputs(ptr noundef nonnull @.str.11) #4
  %300 = mul i32 %295, 150
  %301 = add i32 %300, 300
  tail call void @snd_play(i32 noundef %301, i32 noundef 60, i32 noundef 6) #4
  tail call void @led_blink(i32 noundef 1064736, i32 noundef 2) #4
  br label %302

302:                                              ; preds = %306, %294
  %303 = phi i32 [ 0, %294 ], [ %314, %306 ]
  %304 = icmp eq i32 %303, %210
  br i1 %304, label %305, label %306

305:                                              ; preds = %302
  tail call void @gfx_present() #4
  br label %315

306:                                              ; preds = %302
  %307 = getelementptr inbounds nuw [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %303
  %308 = load i8, ptr %307, align 1, !tbaa !21
  %309 = zext i8 %308 to i32
  %310 = udiv i8 %308, 6
  %311 = zext nneg i8 %310 to i32
  %312 = mul nsw i32 %311, -6
  %313 = add nsw i32 %312, %309
  tail call fastcc void @cell_draw(i32 noundef %313, i32 noundef %311, i32 noundef 5) #5
  %314 = add nuw i32 %303, 1
  br label %302, !llvm.loop !41

315:                                              ; preds = %318, %305
  %316 = phi i32 [ 0, %305 ], [ %321, %318 ]
  %317 = icmp eq i32 %316, 10
  br i1 %317, label %322, label %318

318:                                              ; preds = %315
  %319 = tail call fastcc i32 @tick() #5
  %320 = icmp eq i32 %319, 0
  %321 = add nuw nsw i32 %316, 1
  br i1 %320, label %315, label %359, !llvm.loop !42

322:                                              ; preds = %315, %326
  %323 = phi i32 [ %335, %326 ], [ 0, %315 ]
  %324 = icmp eq i32 %323, %210
  br i1 %324, label %325, label %326

325:                                              ; preds = %322
  tail call void @gfx_present() #4
  br label %336

326:                                              ; preds = %322
  %327 = getelementptr inbounds nuw [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %323
  %328 = load i8, ptr %327, align 1, !tbaa !21
  %329 = zext i8 %328 to i32
  %330 = udiv i8 %328, 6
  %331 = zext nneg i8 %330 to i32
  %332 = mul nsw i32 %331, -6
  %333 = add nsw i32 %332, %329
  %334 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %331, i32 %333
  store i8 0, ptr %334, align 1, !tbaa !21
  tail call fastcc void @cell_draw(i32 noundef %333, i32 noundef %331, i32 noundef 0) #5
  %335 = add nuw i32 %323, 1
  br label %322, !llvm.loop !43

336:                                              ; preds = %339, %325
  %337 = phi i32 [ 0, %325 ], [ %342, %339 ]
  %338 = icmp eq i32 %337, 6
  br i1 %338, label %171, label %339

339:                                              ; preds = %336
  %340 = tail call fastcc i32 @tick() #5
  %341 = icmp eq i32 %340, 0
  %342 = add nuw nsw i32 %337, 1
  br i1 %341, label %336, label %359, !llvm.loop !44

343:                                              ; preds = %292
  %344 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  %345 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), align 4, !tbaa !45
  %346 = icmp eq i32 %344, %345
  br i1 %346, label %358, label %347

347:                                              ; preds = %343
  tail call fastcc void @score_draw() #5
  %348 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  %349 = icmp sgt i32 %348, 6
  br i1 %349, label %350, label %354

350:                                              ; preds = %347
  %351 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  %352 = sdiv i32 %351, -400
  %353 = add nsw i32 %352, 16
  store i32 %353, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  br label %354

354:                                              ; preds = %350, %347
  %355 = phi i32 [ %353, %350 ], [ %348, %347 ]
  %356 = icmp slt i32 %355, 6
  br i1 %356, label %357, label %358

357:                                              ; preds = %354
  store i32 6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  br label %358

358:                                              ; preds = %354, %357, %343
  tail call fastcc void @pair_spawn() #5
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %57

359:                                              ; preds = %54, %43, %318, %339
  tail call void @uputs(ptr noundef nonnull @.str.2) #4
  tail call void @snd_off() #4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_disc_cell(i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cell_draw(i32 noundef %0, i32 noundef %1, i32 noundef %2) unnamed_addr #0 {
  %4 = icmp slt i32 %1, 0
  br i1 %4, label %16, label %5

5:                                                ; preds = %3
  %6 = icmp eq i32 %2, 0
  %7 = mul nsw i32 %0, 18
  %8 = add nsw i32 %7, 12
  %9 = mul nuw nsw i32 %1, 18
  %10 = add nuw nsw i32 %9, 12
  br i1 %6, label %11, label %12

11:                                               ; preds = %5
  tail call void @gfx_fill(i32 noundef %8, i32 noundef %10, i32 noundef 18, i32 noundef 18, i16 noundef zeroext 4228) #4
  br label %16

12:                                               ; preds = %5
  %13 = mul i32 %2, 648
  %14 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %13
  %15 = getelementptr i8, ptr %14, i32 -648
  tail call void @gfx_blit(i32 noundef %8, i32 noundef %10, ptr noundef %15, i32 noundef 18, i32 noundef 18) #4
  br label %16

16:                                               ; preds = %3, %12, %11
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @score_draw() unnamed_addr #0 {
  %1 = alloca [7 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %1) #6
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  call void @numstr(ptr noundef nonnull %1, i32 noundef 6, i32 noundef %2) #4
  call void @gfx_text(i32 noundef 150, i32 noundef 176, ptr noundef nonnull %1, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  %3 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  store i32 %3, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), align 4, !tbaa !45
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %1) #6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @pair_spawn() unnamed_addr #0 {
  store i32 2, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %1 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  store i32 %1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 300), align 4, !tbaa !31
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  store i32 %2, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 304), align 4, !tbaa !32
  %3 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !18
  store i32 %3, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  %4 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !19
  store i32 %4, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  %5 = tail call i32 @rng_below(i32 noundef 4) #4
  %6 = add nsw i32 %5, 1
  store i32 %6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !18
  %7 = tail call i32 @rng_below(i32 noundef 4) #4
  %8 = add nsw i32 %7, 1
  store i32 %8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !19
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  tail call void @gfx_text(i32 noundef 150, i32 noundef 62, ptr noundef nonnull @.str.12, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  %9 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  %10 = mul i32 %9, 648
  %11 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %10
  %12 = getelementptr i8, ptr %11, i32 -648
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 74, ptr noundef %12, i32 noundef 18, i32 noundef 18) #4
  %13 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  %14 = mul i32 %13, 648
  %15 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %14
  %16 = getelementptr i8, ptr %15, i32 -648
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 92, ptr noundef %16, i32 noundef 18, i32 noundef 18) #4
  %17 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !19
  %18 = mul i32 %17, 648
  %19 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %18
  %20 = getelementptr i8, ptr %19, i32 -648
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 122, ptr noundef %20, i32 noundef 18, i32 noundef 18) #4
  %21 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !18
  %22 = mul i32 %21, 648
  %23 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %22
  %24 = getelementptr i8, ptr %23, i32 -648
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 140, ptr noundef %24, i32 noundef 18, i32 noundef 18) #4
  %25 = load i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 2), align 2, !tbaa !21
  %26 = icmp eq i8 %25, 0
  br i1 %26, label %28, label %27

27:                                               ; preds = %0
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !13
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -7705, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 48, i32 noundef 140, ptr noundef nonnull @.str.7, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #4
  tail call void @snd_play(i32 noundef 110, i32 noundef 70, i32 noundef 20) #4
  br label %28

28:                                               ; preds = %27, %0
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @pair_draw(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %3 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %4 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !21
  %6 = sext i8 %5 to i32
  %7 = add nsw i32 %2, %6
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %9 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %3
  %10 = load i8, ptr %9, align 1, !tbaa !21
  %11 = sext i8 %10 to i32
  %12 = add nsw i32 %8, %11
  %13 = icmp eq i32 %0, 0
  %14 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 300), align 4
  %15 = select i1 %13, i32 0, i32 %14
  tail call fastcc void @cell_draw(i32 noundef %2, i32 noundef %8, i32 noundef %15) #5
  %16 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 304), align 4
  %17 = select i1 %13, i32 0, i32 %16
  tail call fastcc void @cell_draw(i32 noundef %7, i32 noundef %12, i32 noundef %17) #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @tick() unnamed_addr #0 {
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %1 = load i32, ptr @in_down, align 4, !tbaa !25
  %2 = and i32 %1, 16
  %3 = icmp eq i32 %2, 0
  %4 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 340), align 4
  %5 = add nsw i32 %4, 1
  %6 = select i1 %3, i32 0, i32 %5
  store i32 %6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 340), align 4, !tbaa !14
  %7 = icmp sgt i32 %6, 45
  %8 = zext i1 %7 to i32
  ret i32 %8
}

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc range(i32 0, 2) i32 @freeat(i32 noundef %0, i32 noundef %1) unnamed_addr #3 {
  %3 = icmp ult i32 %0, 6
  %4 = icmp slt i32 %1, 12
  %5 = and i1 %3, %4
  br i1 %5, label %6, label %13

6:                                                ; preds = %2
  %7 = icmp slt i32 %1, 0
  br i1 %7, label %13, label %8

8:                                                ; preds = %6
  %9 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %1, i32 %0
  %10 = load i8, ptr %9, align 1, !tbaa !21
  %11 = icmp eq i8 %10, 0
  %12 = zext i1 %11 to i32
  br label %13

13:                                               ; preds = %6, %8, %2
  %14 = phi i32 [ 0, %2 ], [ 1, %6 ], [ %12, %8 ]
  ret i32 %14
}

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { nounwind }

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
!10 = !{!11, !12, i64 332}
!11 = !{!"pst", !5, i64 0, !5, i64 72, !5, i64 144, !5, i64 216, !12, i64 288, !12, i64 292, !12, i64 296, !12, i64 300, !12, i64 304, !12, i64 308, !12, i64 312, !12, i64 316, !12, i64 320, !12, i64 324, !12, i64 328, !12, i64 332, !12, i64 336, !12, i64 340, !12, i64 344}
!12 = !{!"int", !5, i64 0}
!13 = !{!11, !12, i64 336}
!14 = !{!11, !12, i64 340}
!15 = !{!11, !12, i64 328}
!16 = !{!11, !12, i64 308}
!17 = !{!11, !12, i64 312}
!18 = !{!11, !12, i64 316}
!19 = !{!11, !12, i64 320}
!20 = distinct !{!20, !8, !9}
!21 = !{!5, !5, i64 0}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !8, !9}
!25 = !{!12, !12, i64 0}
!26 = distinct !{!26, !9}
!27 = !{!11, !12, i64 288}
!28 = !{!11, !12, i64 296}
!29 = !{!11, !12, i64 292}
!30 = !{!11, !12, i64 324}
!31 = !{!11, !12, i64 300}
!32 = !{!11, !12, i64 304}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !8, !9}
!37 = distinct !{!37, !8, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
!40 = distinct !{!40, !8, !9}
!41 = distinct !{!41, !8, !9}
!42 = distinct !{!42, !8, !9}
!43 = distinct !{!43, !8, !9}
!44 = distinct !{!44, !8, !9}
!45 = !{!11, !12, i64 344}
