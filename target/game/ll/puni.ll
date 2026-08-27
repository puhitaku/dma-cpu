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
@.str.6 = private unnamed_addr constant [19 x i8] c"press to try again\00", align 1
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

10:                                               ; preds = %1, %23
  %11 = phi i32 [ %24, %23 ], [ 0, %1 ]
  %12 = icmp eq i32 %11, 12
  br i1 %12, label %13, label %18

13:                                               ; preds = %10
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !13
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !14
  store i32 16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !15
  %14 = tail call i32 @rng_below(i32 noundef 4) #4
  %15 = add nsw i32 %14, 1
  store i32 %15, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  %16 = tail call i32 @rng_below(i32 noundef 4) #4
  %17 = add nsw i32 %16, 1
  store i32 %17, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  tail call void @gfx_clear(i16 noundef zeroext 6407) #4
  tail call void @gfx_rect(i32 noundef 8, i32 noundef 8, i32 noundef 116, i32 noundef 224, i32 noundef 2, i16 noundef zeroext 17005) #4
  tail call void @gfx_text2(i32 noundef 148, i32 noundef 4, ptr noundef nonnull @.str.1, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  br label %28

18:                                               ; preds = %10, %25
  %19 = phi i32 [ %27, %25 ], [ 0, %10 ]
  %20 = icmp eq i32 %19, 6
  br i1 %20, label %21, label %25

21:                                               ; preds = %18
  %22 = add nuw nsw i32 %11, 1
  br label %23

23:                                               ; preds = %21, %50
  %24 = phi i32 [ %22, %21 ], [ 0, %50 ]
  br label %10, !llvm.loop !18

25:                                               ; preds = %18
  %26 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %11, i32 %19
  store i8 0, ptr %26, align 1, !tbaa !19
  %27 = add nuw nsw i32 %19, 1
  br label %18, !llvm.loop !20

28:                                               ; preds = %35, %13
  %29 = phi i32 [ 0, %13 ], [ %36, %35 ]
  %30 = icmp eq i32 %29, 12
  br i1 %30, label %31, label %32

31:                                               ; preds = %28
  tail call fastcc void @score_draw() #5
  tail call fastcc void @pair_spawn() #5
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %39

32:                                               ; preds = %28, %37
  %33 = phi i32 [ %38, %37 ], [ 0, %28 ]
  %34 = icmp eq i32 %33, 6
  br i1 %34, label %35, label %37

35:                                               ; preds = %32
  %36 = add nuw nsw i32 %29, 1
  br label %28, !llvm.loop !21

37:                                               ; preds = %32
  tail call fastcc void @cell_draw(i32 noundef %33, i32 noundef %29, i32 noundef 0) #5
  %38 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !22

39:                                               ; preds = %49, %31
  %40 = tail call fastcc i32 @tick() #5
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %42, label %344

42:                                               ; preds = %39
  %43 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !13
  %44 = icmp eq i32 %43, 0
  br i1 %44, label %51, label %45

45:                                               ; preds = %42
  %46 = load i32, ptr @in_edge, align 4, !tbaa !23
  %47 = and i32 %46, 16
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %49, label %50

49:                                               ; preds = %126, %146, %163, %343, %45
  br label %39, !llvm.loop !24

50:                                               ; preds = %45
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  br label %23

51:                                               ; preds = %42
  %52 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %53 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !26
  %54 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %53
  %55 = load i8, ptr %54, align 1, !tbaa !19
  %56 = sext i8 %55 to i32
  %57 = add nsw i32 %52, %56
  %58 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %59 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %53
  %60 = load i8, ptr %59, align 1, !tbaa !19
  %61 = sext i8 %60 to i32
  %62 = add nsw i32 %58, %61
  %63 = load i32, ptr @in_edge, align 4, !tbaa !23
  %64 = and i32 %63, 4
  %65 = icmp eq i32 %64, 0
  br i1 %65, label %78, label %66

66:                                               ; preds = %51
  %67 = add nsw i32 %52, -1
  %68 = tail call fastcc i32 @freeat(i32 noundef %67, i32 noundef %58) #5
  %69 = icmp eq i32 %68, 0
  br i1 %69, label %78, label %70

70:                                               ; preds = %66
  %71 = add nsw i32 %57, -1
  %72 = tail call fastcc i32 @freeat(i32 noundef %71, i32 noundef %62) #5
  %73 = icmp eq i32 %72, 0
  br i1 %73, label %78, label %74

74:                                               ; preds = %70
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %75 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %76 = add nsw i32 %75, -1
  store i32 %76, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 500, i32 noundef 25, i32 noundef 1) #4
  %77 = load i32, ptr @in_edge, align 4, !tbaa !23
  br label %78

78:                                               ; preds = %66, %70, %74, %51
  %79 = phi i32 [ %63, %66 ], [ %63, %70 ], [ %77, %74 ], [ %63, %51 ]
  %80 = and i32 %79, 8
  %81 = icmp eq i32 %80, 0
  br i1 %81, label %96, label %82

82:                                               ; preds = %78
  %83 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %84 = add nsw i32 %83, 1
  %85 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %86 = tail call fastcc i32 @freeat(i32 noundef %84, i32 noundef %85) #5
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %96, label %88

88:                                               ; preds = %82
  %89 = add nsw i32 %57, 1
  %90 = tail call fastcc i32 @freeat(i32 noundef %89, i32 noundef %62) #5
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %96, label %92

92:                                               ; preds = %88
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %93 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %94 = add nsw i32 %93, 1
  store i32 %94, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 500, i32 noundef 25, i32 noundef 1) #4
  %95 = load i32, ptr @in_edge, align 4, !tbaa !23
  br label %96

96:                                               ; preds = %82, %88, %92, %78
  %97 = phi i32 [ %79, %82 ], [ %79, %88 ], [ %95, %92 ], [ %79, %78 ]
  %98 = and i32 %97, 17
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %117, label %100

100:                                              ; preds = %96
  %101 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !26
  %102 = add nsw i32 %101, 1
  %103 = and i32 %102, 3
  %104 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %105 = getelementptr inbounds nuw [4 x i8], ptr @sdx, i32 0, i32 %103
  %106 = load i8, ptr %105, align 1, !tbaa !19
  %107 = sext i8 %106 to i32
  %108 = add nsw i32 %104, %107
  %109 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %110 = getelementptr inbounds nuw [4 x i8], ptr @sdy, i32 0, i32 %103
  %111 = load i8, ptr %110, align 1, !tbaa !19
  %112 = sext i8 %111 to i32
  %113 = add nsw i32 %109, %112
  %114 = tail call fastcc i32 @freeat(i32 noundef %108, i32 noundef %113) #5
  %115 = icmp eq i32 %114, 0
  br i1 %115, label %117, label %116

116:                                              ; preds = %100
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  store i32 %103, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !26
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @snd_play(i32 noundef 700, i32 noundef 25, i32 noundef 1) #4
  br label %117

117:                                              ; preds = %100, %116, %96
  %118 = load i32, ptr @in_down, align 4, !tbaa !23
  %119 = and i32 %118, 2
  %120 = icmp eq i32 %119, 0
  %121 = select i1 %120, i32 1, i32 8
  %122 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !28
  %123 = add nsw i32 %121, %122
  store i32 %123, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !28
  %124 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !15
  %125 = icmp slt i32 %123, %124
  br i1 %125, label %126, label %127

126:                                              ; preds = %117
  tail call void @gfx_present() #4
  br label %49, !llvm.loop !24

127:                                              ; preds = %117
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !28
  %128 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %129 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !26
  %130 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %129
  %131 = load i8, ptr %130, align 1, !tbaa !19
  %132 = sext i8 %131 to i32
  %133 = add nsw i32 %128, %132
  %134 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %135 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %129
  %136 = load i8, ptr %135, align 1, !tbaa !19
  %137 = sext i8 %136 to i32
  %138 = add nsw i32 %134, %137
  %139 = add nsw i32 %134, 1
  %140 = tail call fastcc i32 @freeat(i32 noundef %128, i32 noundef %139) #5
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %149, label %142

142:                                              ; preds = %127
  %143 = add nsw i32 %138, 1
  %144 = tail call fastcc i32 @freeat(i32 noundef %133, i32 noundef %143) #5
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %149, label %146

146:                                              ; preds = %142
  tail call fastcc void @pair_draw(i32 noundef 0) #5
  %147 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %148 = add nsw i32 %147, 1
  store i32 %148, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %49, !llvm.loop !24

149:                                              ; preds = %142, %127
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  %150 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %151 = icmp sgt i32 %150, -1
  br i1 %151, label %152, label %157

152:                                              ; preds = %149
  %153 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 300), align 4, !tbaa !29
  %154 = trunc i32 %153 to i8
  %155 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %156 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %150, i32 %155
  store i8 %154, ptr %156, align 1, !tbaa !19
  br label %157

157:                                              ; preds = %152, %149
  %158 = icmp sgt i32 %138, -1
  br i1 %158, label %159, label %163

159:                                              ; preds = %157
  %160 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 304), align 4, !tbaa !30
  %161 = trunc i32 %160 to i8
  %162 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %138, i32 %133
  store i8 %161, ptr %162, align 1, !tbaa !19
  br label %164

163:                                              ; preds = %157
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !13
  tail call void @gfx_text2(i32 noundef 40, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -7705, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 56, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @uputs(ptr noundef nonnull @.str.7) #4
  br label %49, !llvm.loop !24

164:                                              ; preds = %315, %159
  %165 = phi i32 [ 0, %159 ], [ %288, %315 ]
  br label %166

166:                                              ; preds = %173, %164
  %167 = phi i32 [ 0, %164 ], [ %174, %173 ]
  %168 = icmp eq i32 %167, 6
  br i1 %168, label %189, label %169

169:                                              ; preds = %166, %186
  %170 = phi i32 [ %187, %186 ], [ 11, %166 ]
  %171 = phi i32 [ %188, %186 ], [ 11, %166 ]
  %172 = icmp sgt i32 %171, -1
  br i1 %172, label %175, label %173

173:                                              ; preds = %169
  %174 = add nuw nsw i32 %167, 1
  br label %166, !llvm.loop !31

175:                                              ; preds = %169
  %176 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %171, i32 %167
  %177 = load i8, ptr %176, align 1, !tbaa !19
  %178 = icmp eq i8 %177, 0
  br i1 %178, label %186, label %179

179:                                              ; preds = %175
  %180 = icmp eq i32 %170, %171
  br i1 %180, label %184, label %181

181:                                              ; preds = %179
  %182 = zext i8 %177 to i32
  %183 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %170, i32 %167
  store i8 %177, ptr %183, align 1, !tbaa !19
  store i8 0, ptr %176, align 1, !tbaa !19
  tail call fastcc void @cell_draw(i32 noundef %167, i32 noundef %170, i32 noundef %182) #5
  tail call fastcc void @cell_draw(i32 noundef %167, i32 noundef %171, i32 noundef 0) #5
  br label %184

184:                                              ; preds = %181, %179
  %185 = add nsw i32 %170, -1
  br label %186

186:                                              ; preds = %184, %175
  %187 = phi i32 [ %185, %184 ], [ %170, %175 ]
  %188 = add nsw i32 %171, -1
  br label %169, !llvm.loop !32

189:                                              ; preds = %166
  tail call void @gfx_present() #4
  br label %190

190:                                              ; preds = %196, %189
  %191 = phi i32 [ 0, %189 ], [ %197, %196 ]
  %192 = icmp eq i32 %191, 12
  br i1 %192, label %201, label %193

193:                                              ; preds = %190, %198
  %194 = phi i32 [ %200, %198 ], [ 0, %190 ]
  %195 = icmp eq i32 %194, 6
  br i1 %195, label %196, label %198

196:                                              ; preds = %193
  %197 = add nuw nsw i32 %191, 1
  br label %190, !llvm.loop !33

198:                                              ; preds = %193
  %199 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %191, i32 %194
  store i8 0, ptr %199, align 1, !tbaa !19
  %200 = add nuw nsw i32 %194, 1
  br label %193, !llvm.loop !34

201:                                              ; preds = %190, %211
  %202 = phi i32 [ %212, %211 ], [ 0, %190 ]
  %203 = phi i32 [ %209, %211 ], [ 0, %190 ]
  %204 = icmp eq i32 %202, 12
  br i1 %204, label %285, label %205

205:                                              ; preds = %201
  %206 = mul nuw nsw i32 %202, 6
  br label %207

207:                                              ; preds = %282, %205
  %208 = phi i32 [ %284, %282 ], [ 0, %205 ]
  %209 = phi i32 [ %283, %282 ], [ %203, %205 ]
  %210 = icmp eq i32 %208, 6
  br i1 %210, label %211, label %213

211:                                              ; preds = %207
  %212 = add nuw nsw i32 %202, 1
  br label %201, !llvm.loop !35

213:                                              ; preds = %207
  %214 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %202, i32 %208
  %215 = load i8, ptr %214, align 1, !tbaa !19
  %216 = icmp eq i8 %215, 0
  br i1 %216, label %282, label %217

217:                                              ; preds = %213
  %218 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %202, i32 %208
  %219 = load i8, ptr %218, align 1, !tbaa !19
  %220 = icmp eq i8 %219, 0
  br i1 %220, label %221, label %282

221:                                              ; preds = %217
  %222 = add nuw nsw i32 %208, %206
  %223 = trunc nuw i32 %222 to i8
  store i8 %223, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), align 4, !tbaa !19
  store i8 1, ptr %218, align 1, !tbaa !19
  br label %226

224:                                              ; preds = %241
  %225 = add nuw nsw i32 %228, 1
  br label %226, !llvm.loop !36

226:                                              ; preds = %224, %221
  %227 = phi i32 [ 1, %221 ], [ %242, %224 ]
  %228 = phi i32 [ 0, %221 ], [ %225, %224 ]
  %229 = icmp eq i32 %227, 0
  br i1 %229, label %278, label %230

230:                                              ; preds = %226
  %231 = add nsw i32 %227, -1
  %232 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), i32 0, i32 %231
  %233 = load i8, ptr %232, align 1, !tbaa !19
  %234 = zext i8 %233 to i32
  %235 = udiv i8 %233, 6
  %236 = zext nneg i8 %235 to i32
  %237 = mul nsw i32 %236, -6
  %238 = add nsw i32 %237, %234
  %239 = add nsw i32 %228, %209
  %240 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %239
  store i8 %233, ptr %240, align 1, !tbaa !19
  br label %241

241:                                              ; preds = %275, %230
  %242 = phi i32 [ %231, %230 ], [ %276, %275 ]
  %243 = phi i32 [ 0, %230 ], [ %277, %275 ]
  %244 = icmp eq i32 %243, 4
  br i1 %244, label %224, label %245

245:                                              ; preds = %241
  %246 = getelementptr inbounds nuw [4 x i8], ptr @groups.ddx, i32 0, i32 %243
  %247 = load i8, ptr %246, align 1, !tbaa !19
  %248 = sext i8 %247 to i32
  %249 = add nsw i32 %238, %248
  %250 = getelementptr inbounds nuw [4 x i8], ptr @groups.ddy, i32 0, i32 %243
  %251 = load i8, ptr %250, align 1, !tbaa !19
  %252 = sext i8 %251 to i32
  %253 = add nsw i32 %252, %236
  %254 = icmp slt i32 %249, 0
  br i1 %254, label %275, label %255

255:                                              ; preds = %245
  %256 = icmp samesign ugt i32 %249, 5
  br i1 %256, label %275, label %257

257:                                              ; preds = %255
  %258 = icmp slt i32 %253, 0
  br i1 %258, label %275, label %259

259:                                              ; preds = %257
  %260 = icmp samesign ugt i32 %253, 11
  br i1 %260, label %275, label %261

261:                                              ; preds = %259
  %262 = getelementptr inbounds nuw [12 x [6 x i8]], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %253, i32 %249
  %263 = load i8, ptr %262, align 1, !tbaa !19
  %264 = icmp eq i8 %263, 0
  br i1 %264, label %265, label %275

265:                                              ; preds = %261
  %266 = getelementptr inbounds nuw [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %253, i32 %249
  %267 = load i8, ptr %266, align 1, !tbaa !19
  %268 = icmp eq i8 %267, %215
  br i1 %268, label %269, label %275

269:                                              ; preds = %265
  store i8 1, ptr %262, align 1, !tbaa !19
  %270 = mul nuw nsw i32 %253, 6
  %271 = add nuw nsw i32 %270, %249
  %272 = trunc nuw nsw i32 %271 to i8
  %273 = add nsw i32 %242, 1
  %274 = getelementptr inbounds [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 144), i32 0, i32 %242
  store i8 %272, ptr %274, align 1, !tbaa !19
  br label %275

275:                                              ; preds = %269, %265, %261, %259, %257, %255, %245
  %276 = phi i32 [ %273, %269 ], [ %242, %259 ], [ %242, %257 ], [ %242, %255 ], [ %242, %245 ], [ %242, %265 ], [ %242, %261 ]
  %277 = add nuw nsw i32 %243, 1
  br label %241, !llvm.loop !37

278:                                              ; preds = %226
  %279 = icmp samesign ugt i32 %228, 3
  %280 = select i1 %279, i32 %228, i32 0
  %281 = add nuw nsw i32 %280, %209
  br label %282

282:                                              ; preds = %278, %217, %213
  %283 = phi i32 [ %281, %278 ], [ %209, %217 ], [ %209, %213 ]
  %284 = add nuw nsw i32 %208, 1
  br label %207, !llvm.loop !38

285:                                              ; preds = %201
  %286 = icmp eq i32 %203, 0
  br i1 %286, label %328, label %287

287:                                              ; preds = %285
  %288 = add nuw nsw i32 %165, 1
  %289 = mul i32 %288, 10
  %290 = mul i32 %289, %203
  %291 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  %292 = add nsw i32 %291, %290
  store i32 %292, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  tail call void @uputn(i32 noundef %203) #4
  tail call void @uputs(ptr noundef nonnull @.str.9) #4
  tail call void @uputn(i32 noundef %288) #4
  tail call void @uputs(ptr noundef nonnull @.str.10) #4
  %293 = mul i32 %288, 150
  %294 = add i32 %293, 300
  tail call void @snd_play(i32 noundef %294, i32 noundef 60, i32 noundef 6) #4
  tail call void @led_blink(i32 noundef 1064736, i32 noundef 2) #4
  br label %295

295:                                              ; preds = %299, %287
  %296 = phi i32 [ 0, %287 ], [ %307, %299 ]
  %297 = icmp eq i32 %296, %203
  br i1 %297, label %298, label %299

298:                                              ; preds = %295
  tail call void @gfx_present() #4
  br label %308

299:                                              ; preds = %295
  %300 = getelementptr inbounds nuw [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %296
  %301 = load i8, ptr %300, align 1, !tbaa !19
  %302 = zext i8 %301 to i32
  %303 = udiv i8 %301, 6
  %304 = zext nneg i8 %303 to i32
  %305 = mul nsw i32 %304, -6
  %306 = add nsw i32 %305, %302
  tail call fastcc void @cell_draw(i32 noundef %306, i32 noundef %304, i32 noundef 5) #5
  %307 = add nuw i32 %296, 1
  br label %295, !llvm.loop !39

308:                                              ; preds = %311, %298
  %309 = phi i32 [ 0, %298 ], [ %314, %311 ]
  %310 = icmp eq i32 %309, 5
  br i1 %310, label %315, label %311

311:                                              ; preds = %308
  %312 = tail call fastcc i32 @tick() #5
  %313 = icmp eq i32 %312, 0
  %314 = add nuw nsw i32 %309, 1
  br i1 %313, label %308, label %344, !llvm.loop !40

315:                                              ; preds = %308, %318
  %316 = phi i32 [ %327, %318 ], [ 0, %308 ]
  %317 = icmp eq i32 %316, %203
  br i1 %317, label %164, label %318

318:                                              ; preds = %315
  %319 = getelementptr inbounds nuw [72 x i8], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 216), i32 0, i32 %316
  %320 = load i8, ptr %319, align 1, !tbaa !19
  %321 = zext i8 %320 to i32
  %322 = udiv i8 %320, 6
  %323 = zext nneg i8 %322 to i32
  %324 = mul nsw i32 %323, -6
  %325 = add nsw i32 %324, %321
  %326 = getelementptr inbounds [12 x [6 x i8]], ptr @arena_w, i32 0, i32 %323, i32 %325
  store i8 0, ptr %326, align 1, !tbaa !19
  tail call fastcc void @cell_draw(i32 noundef %325, i32 noundef %323, i32 noundef 0) #5
  %327 = add nuw i32 %316, 1
  br label %315, !llvm.loop !41

328:                                              ; preds = %285
  %329 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  %330 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !42
  %331 = icmp eq i32 %329, %330
  br i1 %331, label %343, label %332

332:                                              ; preds = %328
  tail call fastcc void @score_draw() #5
  %333 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !15
  %334 = icmp sgt i32 %333, 6
  br i1 %334, label %335, label %339

335:                                              ; preds = %332
  %336 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  %337 = sdiv i32 %336, -400
  %338 = add nsw i32 %337, 16
  store i32 %338, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !15
  br label %339

339:                                              ; preds = %335, %332
  %340 = phi i32 [ %338, %335 ], [ %333, %332 ]
  %341 = icmp slt i32 %340, 6
  br i1 %341, label %342, label %343

342:                                              ; preds = %339
  store i32 6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), align 4, !tbaa !15
  br label %343

343:                                              ; preds = %339, %342, %328
  tail call fastcc void @pair_spawn() #5
  tail call fastcc void @pair_draw(i32 noundef 1) #5
  tail call void @gfx_present() #4
  br label %49

344:                                              ; preds = %39, %311
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
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  call void @numstr(ptr noundef nonnull %1, i32 noundef 6, i32 noundef %2) #4
  call void @gfx_text(i32 noundef 150, i32 noundef 88, ptr noundef nonnull %1, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  %3 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 324), align 4, !tbaa !10
  store i32 %3, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 336), align 4, !tbaa !42
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %1) #6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @pair_spawn() unnamed_addr #0 {
  store i32 2, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !26
  %1 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  store i32 %1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 300), align 4, !tbaa !29
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  store i32 %2, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 304), align 4, !tbaa !30
  %3 = tail call i32 @rng_below(i32 noundef 4) #4
  %4 = add nsw i32 %3, 1
  store i32 %4, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  %5 = tail call i32 @rng_below(i32 noundef 4) #4
  %6 = add nsw i32 %5, 1
  store i32 %6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 316), align 4, !tbaa !28
  tail call void @gfx_text(i32 noundef 150, i32 noundef 24, ptr noundef nonnull @.str.11, i16 noundef zeroext -18950, i16 noundef zeroext 6407) #4
  %7 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 312), align 4, !tbaa !17
  %8 = mul i32 %7, 648
  %9 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %8
  %10 = getelementptr i8, ptr %9, i32 -648
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 36, ptr noundef %10, i32 noundef 18, i32 noundef 18) #4
  %11 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 308), align 4, !tbaa !16
  %12 = mul i32 %11, 648
  %13 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 %12
  %14 = getelementptr i8, ptr %13, i32 -648
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 54, ptr noundef %14, i32 noundef 18, i32 noundef 18) #4
  %15 = load i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 2), align 2, !tbaa !19
  %16 = icmp eq i8 %15, 0
  br i1 %16, label %18, label %17

17:                                               ; preds = %0
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 328), align 4, !tbaa !13
  tail call void @gfx_text2(i32 noundef 40, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -7705, i16 noundef zeroext 4228) #4
  tail call void @gfx_text(i32 noundef 56, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 4228) #4
  tail call void @uputs(ptr noundef nonnull @.str.7) #4
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #4
  tail call void @snd_play(i32 noundef 110, i32 noundef 70, i32 noundef 20) #4
  br label %18

18:                                               ; preds = %17, %0
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @pair_draw(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 288), align 4, !tbaa !25
  %3 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), align 4, !tbaa !26
  %4 = getelementptr inbounds [4 x i8], ptr @sdx, i32 0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !19
  %6 = sext i8 %5 to i32
  %7 = add nsw i32 %2, %6
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 292), align 4, !tbaa !27
  %9 = getelementptr inbounds [4 x i8], ptr @sdy, i32 0, i32 %3
  %10 = load i8, ptr %9, align 1, !tbaa !19
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
  %1 = load i32, ptr @in_down, align 4, !tbaa !23
  %2 = and i32 %1, 16
  %3 = icmp eq i32 %2, 0
  %4 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4
  %5 = add nsw i32 %4, 1
  %6 = select i1 %3, i32 0, i32 %5
  store i32 %6, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 332), align 4, !tbaa !14
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
  %10 = load i8, ptr %9, align 1, !tbaa !19
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
!10 = !{!11, !12, i64 324}
!11 = !{!"pst", !5, i64 0, !5, i64 72, !5, i64 144, !5, i64 216, !12, i64 288, !12, i64 292, !12, i64 296, !12, i64 300, !12, i64 304, !12, i64 308, !12, i64 312, !12, i64 316, !12, i64 320, !12, i64 324, !12, i64 328, !12, i64 332, !12, i64 336}
!12 = !{!"int", !5, i64 0}
!13 = !{!11, !12, i64 328}
!14 = !{!11, !12, i64 332}
!15 = !{!11, !12, i64 320}
!16 = !{!11, !12, i64 308}
!17 = !{!11, !12, i64 312}
!18 = distinct !{!18, !8, !9}
!19 = !{!5, !5, i64 0}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
!23 = !{!12, !12, i64 0}
!24 = distinct !{!24, !9}
!25 = !{!11, !12, i64 288}
!26 = !{!11, !12, i64 296}
!27 = !{!11, !12, i64 292}
!28 = !{!11, !12, i64 316}
!29 = !{!11, !12, i64 300}
!30 = !{!11, !12, i64 304}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !8, !9}
!37 = distinct !{!37, !8, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
!40 = distinct !{!40, !8, !9}
!41 = distinct !{!41, !8, !9}
!42 = !{!11, !12, i64 336}
