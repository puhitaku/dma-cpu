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
@.str.7 = private unnamed_addr constant [17 x i8] c"puni: game over\0A\00", align 1
@.str.8 = private unnamed_addr constant [11 x i8] c"puni: pop \00", align 1
@.str.9 = private unnamed_addr constant [8 x i8] c" chain \00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"NEXT\00", align 1
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

27:                                               ; preds = %25, %54
  %28 = phi i32 [ %26, %25 ], [ 0, %54 ]
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

43:                                               ; preds = %53, %35
  %44 = tail call fastcc i32 @tick() #5
  %45 = icmp eq i32 %44, 0
  br i1 %45, label %46, label %348

46:                                               ; preds = %43
  %47 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !13
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %55, label %49

49:                                               ; preds = %46
  %50 = load i32, ptr @in_edge, align 4, !tbaa !25
  %51 = and i32 %50, 16
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %53, label %54

53:                                               ; preds = %130, %150, %167, %347, %49
  br label %43, !llvm.loop !26

54:                                               ; preds = %49
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  br label %27

55:                                               ; preds = %46
  %56 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %57 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %58 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %57
  %59 = load i8, ptr %58, align 1, !tbaa !21
  %60 = sext i8 %59 to i32
  %61 = add nsw i32 %56, %60
  %62 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %63 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %57
  %64 = load i8, ptr %63, align 1, !tbaa !21
  %65 = sext i8 %64 to i32
  %66 = add nsw i32 %62, %65
  %67 = load i32, ptr @in_edge, align 4, !tbaa !25
  %68 = and i32 %67, 4
  %69 = icmp eq i32 %68, 0
  br i1 %69, label %82, label %70

70:                                               ; preds = %55
  %71 = add nsw i32 %56, -1
  %72 = tail call fastcc i32 @freeat(i32 noundef %71, i32 noundef %62) #5
  %73 = icmp eq i32 %72, 0
  br i1 %73, label %82, label %74

74:                                               ; preds = %70
  %75 = add nsw i32 %61, -1
  %76 = tail call fastcc i32 @freeat(i32 noundef %75, i32 noundef %66) #5
  %77 = icmp eq i32 %76, 0
  br i1 %77, label %82, label %78

78:                                               ; preds = %74
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %79 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %80 = add nsw i32 %79, -1
  store i32 %80, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 500, i32 noundef 25, i32 noundef 1) #4
  %81 = load i32, ptr @in_edge, align 4, !tbaa !25
  br label %82

82:                                               ; preds = %70, %74, %78, %55
  %83 = phi i32 [ %67, %70 ], [ %67, %74 ], [ %81, %78 ], [ %67, %55 ]
  %84 = and i32 %83, 8
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %100, label %86

86:                                               ; preds = %82
  %87 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %88 = add nsw i32 %87, 1
  %89 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %90 = tail call fastcc i32 @freeat(i32 noundef %88, i32 noundef %89) #5
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %100, label %92

92:                                               ; preds = %86
  %93 = add nsw i32 %61, 1
  %94 = tail call fastcc i32 @freeat(i32 noundef %93, i32 noundef %66) #5
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %100, label %96

96:                                               ; preds = %92
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %97 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %98 = add nsw i32 %97, 1
  store i32 %98, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 500, i32 noundef 25, i32 noundef 1) #4
  %99 = load i32, ptr @in_edge, align 4, !tbaa !25
  br label %100

100:                                              ; preds = %86, %92, %96, %82
  %101 = phi i32 [ %83, %86 ], [ %83, %92 ], [ %99, %96 ], [ %83, %82 ]
  %102 = and i32 %101, 17
  %103 = icmp eq i32 %102, 0
  br i1 %103, label %121, label %104

104:                                              ; preds = %100
  %105 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %106 = add nsw i32 %105, 1
  %107 = and i32 %106, 3
  %108 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %109 = getelementptr inbounds nuw [4 x i8], ptr @sdx, i32 0, i32 %107
  %110 = load i8, ptr %109, align 1, !tbaa !21
  %111 = sext i8 %110 to i32
  %112 = add nsw i32 %108, %111
  %113 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %114 = getelementptr inbounds nuw [4 x i8], ptr @sdy, i32 0, i32 %107
  %115 = load i8, ptr %114, align 1, !tbaa !21
  %116 = sext i8 %115 to i32
  %117 = add nsw i32 %113, %116
  %118 = tail call fastcc i32 @freeat(i32 noundef %112, i32 noundef %117) #5
  %119 = icmp eq i32 %118, 0
  br i1 %119, label %121, label %120

120:                                              ; preds = %104
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  store i32 %107, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 700, i32 noundef 25, i32 noundef 1) #4
  br label %121

121:                                              ; preds = %104, %120, %100
  %122 = load i32, ptr @in_down, align 4, !tbaa !25
  %123 = and i32 %122, 2
  %124 = icmp eq i32 %123, 0
  %125 = select i1 %124, i32 1, i32 8
  %126 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  %127 = add nsw i32 %125, %126
  store i32 %127, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  %128 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  %129 = icmp slt i32 %127, %128
  br i1 %129, label %130, label %131

130:                                              ; preds = %121
  tail call void @gfx_present() #4
  br label %53, !llvm.loop !26

131:                                              ; preds = %121
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !30
  %132 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %133 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !28
  %134 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %133
  %135 = load i8, ptr %134, align 1, !tbaa !21
  %136 = sext i8 %135 to i32
  %137 = add nsw i32 %132, %136
  %138 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %139 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %133
  %140 = load i8, ptr %139, align 1, !tbaa !21
  %141 = sext i8 %140 to i32
  %142 = add nsw i32 %138, %141
  %143 = add nsw i32 %138, 1
  %144 = tail call fastcc i32 @freeat(i32 noundef %132, i32 noundef %143) #5
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %153, label %146

146:                                              ; preds = %131
  %147 = add nsw i32 %142, 1
  %148 = tail call fastcc i32 @freeat(i32 noundef %137, i32 noundef %147) #5
  %149 = icmp eq i32 %148, 0
  br i1 %149, label %153, label %150

150:                                              ; preds = %146
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %151 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %152 = add nsw i32 %151, 1
  store i32 %152, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %53, !llvm.loop !26

153:                                              ; preds = %146, %131
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  %154 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !29
  %155 = icmp sgt i32 %154, -1
  br i1 %155, label %156, label %161

156:                                              ; preds = %153
  %157 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 300), align 4, !tbaa !31
  %158 = trunc i32 %157 to i8
  %159 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !27
  %160 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %154, i32 %159
  store i8 %158, ptr %160, align 1, !tbaa !21
  br label %161

161:                                              ; preds = %156, %153
  %162 = icmp sgt i32 %142, -1
  br i1 %162, label %163, label %167

163:                                              ; preds = %161
  %164 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 304), align 4, !tbaa !32
  %165 = trunc i32 %164 to i8
  %166 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %142, i32 %137
  store i8 %165, ptr %166, align 1, !tbaa !21
  br label %168

167:                                              ; preds = %161
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !13
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -7705, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @uputs(ptr noundef nonnull @.str.7) #4
  br label %53, !llvm.loop !26

168:                                              ; preds = %319, %163
  %169 = phi i32 [ 0, %163 ], [ %292, %319 ]
  br label %170

170:                                              ; preds = %177, %168
  %171 = phi i32 [ 0, %168 ], [ %178, %177 ]
  %172 = icmp eq i32 %171, 6
  br i1 %172, label %193, label %173

173:                                              ; preds = %170, %190
  %174 = phi i32 [ %191, %190 ], [ 11, %170 ]
  %175 = phi i32 [ %192, %190 ], [ 11, %170 ]
  %176 = icmp sgt i32 %175, -1
  br i1 %176, label %179, label %177

177:                                              ; preds = %173
  %178 = add nuw nsw i32 %171, 1
  br label %170, !llvm.loop !33

179:                                              ; preds = %173
  %180 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %175, i32 %171
  %181 = load i8, ptr %180, align 1, !tbaa !21
  %182 = icmp eq i8 %181, 0
  br i1 %182, label %190, label %183

183:                                              ; preds = %179
  %184 = icmp eq i32 %174, %175
  br i1 %184, label %188, label %185

185:                                              ; preds = %183
  %186 = zext i8 %181 to i32
  %187 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %174, i32 %171
  store i8 %181, ptr %187, align 1, !tbaa !21
  store i8 0, ptr %180, align 1, !tbaa !21
  tail call fastcc void @cell_draw(i32 noundef %171, i32 noundef %174, i32 noundef %186) #5
  tail call fastcc void @cell_draw(i32 noundef %171, i32 noundef %175, i32 noundef 0) #5
  br label %188

188:                                              ; preds = %185, %183
  %189 = add nsw i32 %174, -1
  br label %190

190:                                              ; preds = %188, %179
  %191 = phi i32 [ %189, %188 ], [ %174, %179 ]
  %192 = add nsw i32 %175, -1
  br label %173, !llvm.loop !34

193:                                              ; preds = %170
  tail call void @gfx_present() #4
  br label %194

194:                                              ; preds = %200, %193
  %195 = phi i32 [ 0, %193 ], [ %201, %200 ]
  %196 = icmp eq i32 %195, 12
  br i1 %196, label %205, label %197

197:                                              ; preds = %194, %202
  %198 = phi i32 [ %204, %202 ], [ 0, %194 ]
  %199 = icmp eq i32 %198, 6
  br i1 %199, label %200, label %202

200:                                              ; preds = %197
  %201 = add nuw nsw i32 %195, 1
  br label %194, !llvm.loop !35

202:                                              ; preds = %197
  %203 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %195, i32 %198
  store i8 0, ptr %203, align 1, !tbaa !21
  %204 = add nuw nsw i32 %198, 1
  br label %197, !llvm.loop !36

205:                                              ; preds = %194, %215
  %206 = phi i32 [ %216, %215 ], [ 0, %194 ]
  %207 = phi i32 [ %213, %215 ], [ 0, %194 ]
  %208 = icmp eq i32 %206, 12
  br i1 %208, label %289, label %209

209:                                              ; preds = %205
  %210 = mul nuw nsw i32 %206, 6
  br label %211

211:                                              ; preds = %286, %209
  %212 = phi i32 [ %288, %286 ], [ 0, %209 ]
  %213 = phi i32 [ %287, %286 ], [ %207, %209 ]
  %214 = icmp eq i32 %212, 6
  br i1 %214, label %215, label %217

215:                                              ; preds = %211
  %216 = add nuw nsw i32 %206, 1
  br label %205, !llvm.loop !37

217:                                              ; preds = %211
  %218 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %206, i32 %212
  %219 = load i8, ptr %218, align 1, !tbaa !21
  %220 = icmp eq i8 %219, 0
  br i1 %220, label %286, label %221

221:                                              ; preds = %217
  %222 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %206, i32 %212
  %223 = load i8, ptr %222, align 1, !tbaa !21
  %224 = icmp eq i8 %223, 0
  br i1 %224, label %225, label %286

225:                                              ; preds = %221
  %226 = add nuw nsw i32 %212, %210
  %227 = trunc nuw i32 %226 to i8
  store i8 %227, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), align 4, !tbaa !21
  store i8 1, ptr %222, align 1, !tbaa !21
  br label %230

228:                                              ; preds = %245
  %229 = add nuw nsw i32 %232, 1
  br label %230, !llvm.loop !38

230:                                              ; preds = %228, %225
  %231 = phi i32 [ 1, %225 ], [ %246, %228 ]
  %232 = phi i32 [ 0, %225 ], [ %229, %228 ]
  %233 = icmp eq i32 %231, 0
  br i1 %233, label %282, label %234

234:                                              ; preds = %230
  %235 = add nsw i32 %231, -1
  %236 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), i32 0, i32 %235
  %237 = load i8, ptr %236, align 1, !tbaa !21
  %238 = zext i8 %237 to i32
  %239 = udiv i8 %237, 6
  %240 = zext nneg i8 %239 to i32
  %241 = mul nsw i32 %240, -6
  %242 = add nsw i32 %241, %238
  %243 = add nsw i32 %232, %213
  %244 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %243
  store i8 %237, ptr %244, align 1, !tbaa !21
  br label %245

245:                                              ; preds = %279, %234
  %246 = phi i32 [ %235, %234 ], [ %280, %279 ]
  %247 = phi i32 [ 0, %234 ], [ %281, %279 ]
  %248 = icmp eq i32 %247, 4
  br i1 %248, label %228, label %249

249:                                              ; preds = %245
  %250 = getelementptr inbounds nuw [4 x i8], ptr @groups.ddx, i32 0, i32 %247
  %251 = load i8, ptr %250, align 1, !tbaa !21
  %252 = sext i8 %251 to i32
  %253 = add nsw i32 %242, %252
  %254 = getelementptr inbounds nuw [4 x i8], ptr @groups.ddy, i32 0, i32 %247
  %255 = load i8, ptr %254, align 1, !tbaa !21
  %256 = sext i8 %255 to i32
  %257 = add nsw i32 %256, %240
  %258 = icmp slt i32 %253, 0
  br i1 %258, label %279, label %259

259:                                              ; preds = %249
  %260 = icmp samesign ugt i32 %253, 5
  br i1 %260, label %279, label %261

261:                                              ; preds = %259
  %262 = icmp slt i32 %257, 0
  br i1 %262, label %279, label %263

263:                                              ; preds = %261
  %264 = icmp samesign ugt i32 %257, 11
  br i1 %264, label %279, label %265

265:                                              ; preds = %263
  %266 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %257, i32 %253
  %267 = load i8, ptr %266, align 1, !tbaa !21
  %268 = icmp eq i8 %267, 0
  br i1 %268, label %269, label %279

269:                                              ; preds = %265
  %270 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %257, i32 %253
  %271 = load i8, ptr %270, align 1, !tbaa !21
  %272 = icmp eq i8 %271, %219
  br i1 %272, label %273, label %279

273:                                              ; preds = %269
  store i8 1, ptr %266, align 1, !tbaa !21
  %274 = mul nuw nsw i32 %257, 6
  %275 = add nuw nsw i32 %274, %253
  %276 = trunc nuw nsw i32 %275 to i8
  %277 = add nsw i32 %246, 1
  %278 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), i32 0, i32 %246
  store i8 %276, ptr %278, align 1, !tbaa !21
  br label %279

279:                                              ; preds = %273, %269, %265, %263, %261, %259, %249
  %280 = phi i32 [ %277, %273 ], [ %246, %263 ], [ %246, %261 ], [ %246, %259 ], [ %246, %249 ], [ %246, %269 ], [ %246, %265 ]
  %281 = add nuw nsw i32 %247, 1
  br label %245, !llvm.loop !39

282:                                              ; preds = %230
  %283 = icmp samesign ugt i32 %232, 3
  %284 = select i1 %283, i32 %232, i32 0
  %285 = add nuw nsw i32 %284, %213
  br label %286

286:                                              ; preds = %282, %221, %217
  %287 = phi i32 [ %285, %282 ], [ %213, %221 ], [ %213, %217 ]
  %288 = add nuw nsw i32 %212, 1
  br label %211, !llvm.loop !40

289:                                              ; preds = %205
  %290 = icmp eq i32 %207, 0
  br i1 %290, label %332, label %291

291:                                              ; preds = %289
  %292 = add nuw nsw i32 %169, 1
  %293 = mul i32 %292, 10
  %294 = mul i32 %293, %207
  %295 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  %296 = add nsw i32 %295, %294
  store i32 %296, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  tail call void @uputn(i32 noundef %207) #4
  tail call void @uputs(ptr noundef nonnull @.str.9) #4
  tail call void @uputn(i32 noundef %292) #4
  tail call void @uputs(ptr noundef nonnull @.str.10) #4
  %297 = mul i32 %292, 150
  %298 = add i32 %297, 300
  tail call void @snd_play(i32 noundef %298, i32 noundef 60, i32 noundef 6) #4
  tail call void @led_blink(i32 noundef 1064736, i32 noundef 2) #4
  br label %299

299:                                              ; preds = %303, %291
  %300 = phi i32 [ 0, %291 ], [ %311, %303 ]
  %301 = icmp eq i32 %300, %207
  br i1 %301, label %302, label %303

302:                                              ; preds = %299
  tail call void @gfx_present() #4
  br label %312

303:                                              ; preds = %299
  %304 = getelementptr inbounds nuw [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %300
  %305 = load i8, ptr %304, align 1, !tbaa !21
  %306 = zext i8 %305 to i32
  %307 = udiv i8 %305, 6
  %308 = zext nneg i8 %307 to i32
  %309 = mul nsw i32 %308, -6
  %310 = add nsw i32 %309, %306
  tail call fastcc void @cell_draw(i32 noundef %310, i32 noundef %308, i32 noundef 5) #5
  %311 = add nuw i32 %300, 1
  br label %299, !llvm.loop !41

312:                                              ; preds = %315, %302
  %313 = phi i32 [ 0, %302 ], [ %318, %315 ]
  %314 = icmp eq i32 %313, 5
  br i1 %314, label %319, label %315

315:                                              ; preds = %312
  %316 = tail call fastcc i32 @tick() #5
  %317 = icmp eq i32 %316, 0
  %318 = add nuw nsw i32 %313, 1
  br i1 %317, label %312, label %348, !llvm.loop !42

319:                                              ; preds = %312, %322
  %320 = phi i32 [ %331, %322 ], [ 0, %312 ]
  %321 = icmp eq i32 %320, %207
  br i1 %321, label %168, label %322

322:                                              ; preds = %319
  %323 = getelementptr inbounds nuw [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %320
  %324 = load i8, ptr %323, align 1, !tbaa !21
  %325 = zext i8 %324 to i32
  %326 = udiv i8 %324, 6
  %327 = zext nneg i8 %326 to i32
  %328 = mul nsw i32 %327, -6
  %329 = add nsw i32 %328, %325
  %330 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %327, i32 %329
  store i8 0, ptr %330, align 1, !tbaa !21
  tail call fastcc void @cell_draw(i32 noundef %329, i32 noundef %327, i32 noundef 0) #5
  %331 = add nuw i32 %320, 1
  br label %319, !llvm.loop !43

332:                                              ; preds = %289
  %333 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  %334 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), align 4, !tbaa !44
  %335 = icmp eq i32 %333, %334
  br i1 %335, label %347, label %336

336:                                              ; preds = %332
  tail call fastcc void @score_draw() #5
  %337 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  %338 = icmp sgt i32 %337, 6
  br i1 %338, label %339, label %343

339:                                              ; preds = %336
  %340 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !10
  %341 = sdiv i32 %340, -400
  %342 = add nsw i32 %341, 16
  store i32 %342, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  br label %343

343:                                              ; preds = %339, %336
  %344 = phi i32 [ %342, %339 ], [ %337, %336 ]
  %345 = icmp slt i32 %344, 6
  br i1 %345, label %346, label %347

346:                                              ; preds = %343
  store i32 6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !15
  br label %347

347:                                              ; preds = %343, %346, %332
  tail call fastcc void @pair_spawn() #5
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %53

348:                                              ; preds = %43, %315
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
  store i32 %3, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), align 4, !tbaa !44
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
  tail call void @gfx_text(i32 noundef 150, i32 noundef 62, ptr noundef nonnull @.str.11, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
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
  tail call void @uputs(ptr noundef nonnull @.str.7) #4
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
!44 = !{!11, !12, i64 344}
