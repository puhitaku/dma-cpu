; ModuleID = 'chute.c'
source_filename = "chute.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"chute: start\0A\00", align 1
@arena_w = external dso_local global [2304 x i32], align 4
@.str.1 = private unnamed_addr constant [18 x i8] c"shoot the chutes!\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [13 x i8] c"chute: quit\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.3 = private unnamed_addr constant [14 x i8] c"chute: again\0A\00", align 1
@adx = internal unnamed_addr constant [5 x i8] c"\FB\FD\00\03\05", align 1
@ady = internal unnamed_addr constant [5 x i8] c"\FC\FA\F9\FA\FC", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"OVERRUN!\00", align 1
@.str.5 = private unnamed_addr constant [19 x i8] c"press to try again\00", align 1
@.str.6 = private unnamed_addr constant [18 x i8] c"chute: game over\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @chute_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 263695, i32 noundef 263695) #4
  tail call void @gfx_disc_cell(i32 noundef 16, i32 noundef 8, i16 noundef zeroext -2146, i16 noundef zeroext 2149, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512)) #4
  br label %1

1:                                                ; preds = %43, %0
  tail call void @gfx_clear(i16 noundef zeroext 2149) #4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 226, i32 noundef 240, i32 noundef 14, i16 noundef zeroext 16870) #4
  br label %2

2:                                                ; preds = %5, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %5 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %8, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %3
  store i32 -999, ptr %6, align 4, !tbaa !3
  %7 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !7

8:                                                ; preds = %2, %11
  %9 = phi i32 [ %13, %11 ], [ 0, %2 ]
  %10 = icmp eq i32 %9, 2
  br i1 %10, label %14, label %11

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %9
  store i32 -999, ptr %12, align 4, !tbaa !3
  %13 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !10

14:                                               ; preds = %8, %18
  %15 = phi i32 [ %20, %18 ], [ 0, %8 ]
  %16 = icmp eq i32 %15, 6
  br i1 %16, label %17, label %18

17:                                               ; preds = %14
  store i32 2, ptr @arena_w, align 4, !tbaa !11
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !16
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  tail call fastcc void @draw_turret() #5
  tail call fastcc void @draw_score() #5
  tail call void @gfx_text(i32 noundef 60, i32 noundef 110, ptr noundef nonnull @.str.1, i16 noundef zeroext -18950, i16 noundef zeroext 2149) #4
  br label %21

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %15
  store i32 0, ptr %19, align 4, !tbaa !3
  %20 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !19

21:                                               ; preds = %325, %17
  tail call void @gfx_present() #4
  br label %22

22:                                               ; preds = %21, %40
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %23 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %24 = add i32 %23, 1
  store i32 %24, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %25 = icmp eq i32 %24, 60
  br i1 %25, label %26, label %27

26:                                               ; preds = %22
  tail call void @gfx_fill(i32 noundef 60, i32 noundef 110, i32 noundef 136, i32 noundef 8, i16 noundef zeroext 2149) #4
  br label %27

27:                                               ; preds = %26, %22
  %28 = load i32, ptr @in_down, align 4, !tbaa !3
  %29 = and i32 %28, 16
  %30 = icmp eq i32 %29, 0
  %31 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4
  %32 = add nsw i32 %31, 1
  %33 = select i1 %30, i32 0, i32 %32
  store i32 %33, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !16
  %34 = icmp sgt i32 %33, 45
  br i1 %34, label %35, label %36

35:                                               ; preds = %27
  tail call void @uputs(ptr noundef nonnull @.str.2) #4
  tail call void @snd_off() #4
  ret void

36:                                               ; preds = %27
  %37 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  %38 = icmp eq i32 %37, 0
  %39 = load i32, ptr @in_edge, align 4, !tbaa !3
  br i1 %38, label %44, label %40

40:                                               ; preds = %36
  %41 = and i32 %39, 16
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %22, label %43, !llvm.loop !20

43:                                               ; preds = %40
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  br label %1

44:                                               ; preds = %36
  %45 = and i32 %39, 4
  %46 = icmp ne i32 %45, 0
  %47 = load i32, ptr @arena_w, align 4
  %48 = icmp sgt i32 %47, 0
  %49 = select i1 %46, i1 %48, i1 false
  br i1 %49, label %50, label %54

50:                                               ; preds = %44
  %51 = add nsw i32 %47, -1
  store i32 %51, ptr @arena_w, align 4, !tbaa !11
  tail call fastcc void @draw_turret() #5
  %52 = load i32, ptr @in_edge, align 4, !tbaa !3
  %53 = load i32, ptr @arena_w, align 4
  br label %54

54:                                               ; preds = %50, %44
  %55 = phi i32 [ %53, %50 ], [ %47, %44 ]
  %56 = phi i32 [ %52, %50 ], [ %39, %44 ]
  %57 = and i32 %56, 8
  %58 = icmp ne i32 %57, 0
  %59 = icmp slt i32 %55, 4
  %60 = select i1 %58, i1 %59, i1 false
  br i1 %60, label %61, label %64

61:                                               ; preds = %54
  %62 = add nsw i32 %55, 1
  store i32 %62, ptr @arena_w, align 4, !tbaa !11
  tail call fastcc void @draw_turret() #5
  %63 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %64

64:                                               ; preds = %61, %54
  %65 = phi i32 [ %63, %61 ], [ %56, %54 ]
  %66 = and i32 %65, 17
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %68, label %69

68:                                               ; preds = %69, %76, %64
  br label %89

69:                                               ; preds = %64, %87
  %70 = phi i32 [ %88, %87 ], [ 0, %64 ]
  %71 = icmp eq i32 %70, 3
  br i1 %71, label %68, label %72

72:                                               ; preds = %69
  %73 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %70
  %74 = load i32, ptr %73, align 4, !tbaa !3
  %75 = icmp eq i32 %74, -999
  br i1 %75, label %76, label %87

76:                                               ; preds = %72
  store i32 120, ptr %73, align 4, !tbaa !3
  %77 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %70
  store i32 202, ptr %77, align 4, !tbaa !3
  %78 = load i32, ptr @arena_w, align 4, !tbaa !11
  %79 = getelementptr inbounds [5 x i8], ptr @adx, i32 0, i32 %78
  %80 = load i8, ptr %79, align 1, !tbaa !21
  %81 = sext i8 %80 to i32
  %82 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 48), i32 0, i32 %70
  store i32 %81, ptr %82, align 4, !tbaa !3
  %83 = getelementptr inbounds [5 x i8], ptr @ady, i32 0, i32 %78
  %84 = load i8, ptr %83, align 1, !tbaa !21
  %85 = sext i8 %84 to i32
  %86 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 60), i32 0, i32 %70
  store i32 %85, ptr %86, align 4, !tbaa !3
  tail call void @snd_play(i32 noundef 900, i32 noundef 40, i32 noundef 2) #4
  br label %68

87:                                               ; preds = %72
  %88 = add nuw nsw i32 %70, 1
  br label %69, !llvm.loop !22

89:                                               ; preds = %68, %129
  %90 = phi i32 [ %130, %129 ], [ 0, %68 ]
  %91 = icmp eq i32 %90, 3
  br i1 %91, label %92, label %97

92:                                               ; preds = %89
  %93 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  %94 = add i32 %93, -1
  store i32 %94, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %131, label %96

96:                                               ; preds = %138, %145, %92
  br label %161

97:                                               ; preds = %89
  %98 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %90
  %99 = load i32, ptr %98, align 4, !tbaa !3
  %100 = icmp eq i32 %99, -999
  br i1 %100, label %129, label %101

101:                                              ; preds = %97
  %102 = add nsw i32 %99, -1
  %103 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %90
  %104 = load i32, ptr %103, align 4, !tbaa !3
  %105 = add nsw i32 %104, -1
  tail call fastcc void @sky(i32 noundef %102, i32 noundef %105, i32 noundef 4, i32 noundef 4) #5
  %106 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 48), i32 0, i32 %90
  %107 = load i32, ptr %106, align 4, !tbaa !3
  %108 = load i32, ptr %98, align 4, !tbaa !3
  %109 = add nsw i32 %108, %107
  store i32 %109, ptr %98, align 4, !tbaa !3
  %110 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 60), i32 0, i32 %90
  %111 = load i32, ptr %110, align 4, !tbaa !3
  %112 = load i32, ptr %103, align 4, !tbaa !3
  %113 = add nsw i32 %112, %111
  store i32 %113, ptr %103, align 4, !tbaa !3
  %114 = icmp slt i32 %113, 0
  br i1 %114, label %119, label %115

115:                                              ; preds = %101
  %116 = icmp slt i32 %109, 2
  br i1 %116, label %119, label %117

117:                                              ; preds = %115
  %118 = icmp samesign ugt i32 %109, 236
  br i1 %118, label %119, label %120

119:                                              ; preds = %117, %115, %101
  store i32 -999, ptr %98, align 4, !tbaa !3
  br label %129

120:                                              ; preds = %117
  %121 = add nsw i32 %109, -1
  %122 = add nsw i32 %113, -1
  tail call void @gfx_fill(i32 noundef %121, i32 noundef %122, i32 noundef 3, i32 noundef 3, i16 noundef zeroext -278) #4
  %123 = load i32, ptr %98, align 4, !tbaa !3
  %124 = add nsw i32 %123, -4
  %125 = load i32, ptr %103, align 4, !tbaa !3
  %126 = add nsw i32 %125, -4
  %127 = add nsw i32 %123, 6
  %128 = add nsw i32 %125, 8
  tail call void @gfx_damage(i32 noundef %124, i32 noundef %126, i32 noundef %127, i32 noundef %128) #4
  br label %129

129:                                              ; preds = %97, %120, %119
  %130 = add nuw nsw i32 %90, 1
  br label %89, !llvm.loop !23

131:                                              ; preds = %92
  %132 = tail call i32 @rng_below(i32 noundef 90) #4
  %133 = add i32 %132, 90
  %134 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %135 = sdiv i32 %134, 20
  %136 = tail call i32 @llvm.smin.i32(i32 %135, i32 50)
  %137 = sub i32 %133, %136
  store i32 %137, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  br label %138

138:                                              ; preds = %159, %131
  %139 = phi i32 [ 0, %131 ], [ %160, %159 ]
  %140 = icmp eq i32 %139, 2
  br i1 %140, label %96, label %141

141:                                              ; preds = %138
  %142 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %139
  %143 = load i32, ptr %142, align 4, !tbaa !3
  %144 = icmp eq i32 %143, -999
  br i1 %144, label %145, label %159

145:                                              ; preds = %141
  %146 = tail call i32 @rng() #4
  %147 = and i32 %146, 1
  %148 = icmp eq i32 %147, 0
  %149 = select i1 %148, i32 252, i32 -12
  store i32 %149, ptr %142, align 4, !tbaa !3
  %150 = select i1 %148, i32 -2, i32 2
  %151 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %139
  store i32 %150, ptr %151, align 4, !tbaa !3
  %152 = tail call i32 @rng_below(i32 noundef 2) #4
  %153 = shl nsw i32 %152, 4
  %154 = add nsw i32 %153, 22
  %155 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %139
  store i32 %154, ptr %155, align 4, !tbaa !3
  %156 = tail call i32 @rng_below(i32 noundef 60) #4
  %157 = add nsw i32 %156, 20
  %158 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %139
  store i32 %157, ptr %158, align 4, !tbaa !3
  br label %96

159:                                              ; preds = %141
  %160 = add nuw nsw i32 %139, 1
  br label %138, !llvm.loop !24

161:                                              ; preds = %96, %203
  %162 = phi i32 [ %204, %203 ], [ 0, %96 ]
  %163 = icmp eq i32 %162, 2
  br i1 %163, label %205, label %164

164:                                              ; preds = %161
  %165 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %162
  %166 = load i32, ptr %165, align 4, !tbaa !3
  %167 = icmp eq i32 %166, -999
  br i1 %167, label %203, label %168

168:                                              ; preds = %164
  tail call fastcc void @heli_draw(i32 noundef %162, i32 noundef 1) #5
  %169 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %162
  %170 = load i32, ptr %169, align 4, !tbaa !3
  %171 = load i32, ptr %165, align 4, !tbaa !3
  %172 = add nsw i32 %171, %170
  store i32 %172, ptr %165, align 4, !tbaa !3
  %173 = icmp slt i32 %172, -13
  br i1 %173, label %176, label %174

174:                                              ; preds = %168
  %175 = icmp sgt i32 %172, 253
  br i1 %175, label %176, label %177

176:                                              ; preds = %174, %168
  store i32 -999, ptr %165, align 4, !tbaa !3
  br label %203

177:                                              ; preds = %174
  %178 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %162
  %179 = load i32, ptr %178, align 4, !tbaa !3
  %180 = add nsw i32 %179, -1
  store i32 %180, ptr %178, align 4, !tbaa !3
  %181 = icmp eq i32 %180, 0
  %182 = add nsw i32 %172, -31
  %183 = icmp ult i32 %182, 179
  %184 = and i1 %183, %181
  br i1 %184, label %185, label %202

185:                                              ; preds = %177, %192
  %186 = phi i32 [ %193, %192 ], [ 0, %177 ]
  %187 = icmp eq i32 %186, 6
  br i1 %187, label %202, label %188

188:                                              ; preds = %185
  %189 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %186
  %190 = load i32, ptr %189, align 4, !tbaa !3
  %191 = icmp eq i32 %190, 0
  br i1 %191, label %194, label %192

192:                                              ; preds = %188
  %193 = add nuw nsw i32 %186, 1
  br label %185, !llvm.loop !25

194:                                              ; preds = %188
  store i32 1, ptr %189, align 4, !tbaa !3
  %195 = load i32, ptr %165, align 4, !tbaa !3
  %196 = and i32 %195, -2
  %197 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %186
  store i32 %196, ptr %197, align 4, !tbaa !3
  %198 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %162
  %199 = load i32, ptr %198, align 4, !tbaa !3
  %200 = add nsw i32 %199, 14
  %201 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %186
  store i32 %200, ptr %201, align 4, !tbaa !3
  br label %202

202:                                              ; preds = %185, %194, %177
  tail call fastcc void @heli_draw(i32 noundef %162, i32 noundef 0) #5
  br label %203

203:                                              ; preds = %164, %202, %176
  %204 = add nuw nsw i32 %162, 1
  br label %161, !llvm.loop !26

205:                                              ; preds = %161, %247
  %206 = phi i32 [ %248, %247 ], [ 0, %161 ]
  %207 = icmp eq i32 %206, 6
  br i1 %207, label %249, label %208

208:                                              ; preds = %205
  %209 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %206
  %210 = load i32, ptr %209, align 4, !tbaa !3
  switch i32 %210, label %211 [
    i32 0, label %247
    i32 4, label %247
  ]

211:                                              ; preds = %208
  tail call fastcc void @troop_erase(i32 noundef %206) #5
  %212 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %206
  %213 = load i32, ptr %212, align 4, !tbaa !3
  switch i32 %210, label %230 [
    i32 1, label %214
    i32 2, label %218
  ]

214:                                              ; preds = %211
  %215 = add nsw i32 %213, 3
  store i32 %215, ptr %212, align 4, !tbaa !3
  %216 = icmp sgt i32 %213, 67
  br i1 %216, label %217, label %246

217:                                              ; preds = %214
  store i32 2, ptr %209, align 4, !tbaa !3
  br label %232

218:                                              ; preds = %211
  %219 = add nsw i32 %213, 1
  store i32 %219, ptr %212, align 4, !tbaa !3
  %220 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %221 = and i32 %220, 4
  %222 = icmp eq i32 %221, 0
  br i1 %222, label %232, label %223

223:                                              ; preds = %218
  %224 = and i32 %220, 8
  %225 = icmp eq i32 %224, 0
  %226 = select i1 %225, i32 -1, i32 1
  %227 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %206
  %228 = load i32, ptr %227, align 4, !tbaa !3
  %229 = add nsw i32 %228, %226
  store i32 %229, ptr %227, align 4, !tbaa !3
  br label %232

230:                                              ; preds = %211
  %231 = add nsw i32 %213, 5
  store i32 %231, ptr %212, align 4, !tbaa !3
  br label %232

232:                                              ; preds = %230, %223, %218, %217
  %233 = phi i32 [ %231, %230 ], [ %219, %223 ], [ %219, %218 ], [ %215, %217 ]
  %234 = icmp sgt i32 %233, 213
  br i1 %234, label %235, label %246

235:                                              ; preds = %232
  store i32 214, ptr %212, align 4, !tbaa !3
  %236 = icmp eq i32 %210, 3
  br i1 %236, label %237, label %240

237:                                              ; preds = %235
  store i32 0, ptr %209, align 4, !tbaa !3
  %238 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %239 = add nsw i32 %238, 2
  store i32 %239, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #4
  tail call fastcc void @troop_erase(i32 noundef %206) #5
  br label %247

240:                                              ; preds = %235
  store i32 4, ptr %209, align 4, !tbaa !3
  %241 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %242 = add nsw i32 %241, 1
  store i32 %242, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #4
  tail call fastcc void @troop_draw(i32 noundef %206) #5
  tail call fastcc void @draw_score() #5
  %243 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %244 = icmp sgt i32 %243, 3
  br i1 %244, label %245, label %247

245:                                              ; preds = %240
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 104, ptr noundef nonnull @.str.4, i16 noundef zeroext -7705, i16 noundef zeroext 2149) #4
  tail call void @gfx_text(i32 noundef 58, i32 noundef 128, ptr noundef nonnull @.str.5, i16 noundef zeroext -18950, i16 noundef zeroext 2149) #4
  tail call void @uputs(ptr noundef nonnull @.str.6) #4
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #4
  tail call void @snd_play(i32 noundef 110, i32 noundef 70, i32 noundef 20) #4
  br label %247

246:                                              ; preds = %214, %232
  tail call fastcc void @troop_draw(i32 noundef %206) #5
  br label %247

247:                                              ; preds = %240, %245, %208, %208, %246, %237
  %248 = add nuw nsw i32 %206, 1
  br label %205, !llvm.loop !27

249:                                              ; preds = %205, %322
  %250 = phi i32 [ %323, %322 ], [ 0, %205 ]
  %251 = icmp eq i32 %250, 3
  br i1 %251, label %252, label %256

252:                                              ; preds = %249
  %253 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %254 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !28
  %255 = icmp eq i32 %253, %254
  br i1 %255, label %325, label %324

256:                                              ; preds = %249
  %257 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %250
  %258 = load i32, ptr %257, align 4, !tbaa !3
  %259 = icmp eq i32 %258, -999
  br i1 %259, label %322, label %260

260:                                              ; preds = %256
  %261 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %250
  %262 = load i32, ptr %261, align 4, !tbaa !3
  %263 = add i32 %258, 8
  br label %264

264:                                              ; preds = %295, %260
  %265 = phi i32 [ 0, %260 ], [ %296, %295 ]
  %266 = icmp eq i32 %265, 6
  br i1 %266, label %297, label %267

267:                                              ; preds = %264
  %268 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %265
  %269 = load i32, ptr %268, align 4, !tbaa !3
  %270 = add i32 %269, -3
  %271 = icmp ult i32 %270, -2
  br i1 %271, label %295, label %272

272:                                              ; preds = %267
  %273 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %265
  %274 = load i32, ptr %273, align 4, !tbaa !3
  %275 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %265
  %276 = load i32, ptr %275, align 4, !tbaa !3
  %277 = sub nsw i32 %262, %276
  %278 = sub i32 %263, %274
  %279 = icmp ult i32 %278, 17
  %280 = add i32 %277, 10
  %281 = icmp ult i32 %280, 23
  %282 = select i1 %279, i1 %281, i1 false
  br i1 %282, label %283, label %295

283:                                              ; preds = %272
  tail call fastcc void @troop_erase(i32 noundef %265) #5
  %284 = icmp eq i32 %269, 2
  %285 = icmp slt i32 %277, 0
  %286 = select i1 %284, i1 %285, i1 false
  %287 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %288 = select i1 %286, i32 5, i32 10
  %289 = select i1 %286, i32 3, i32 0
  %290 = add nsw i32 %287, %288
  store i32 %289, ptr %268, align 4, !tbaa !3
  store i32 %290, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %291 = add nsw i32 %258, -1
  %292 = add nsw i32 %262, -1
  tail call fastcc void @sky(i32 noundef %291, i32 noundef %292, i32 noundef 4, i32 noundef 4) #5
  store i32 -999, ptr %257, align 4, !tbaa !3
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #4
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #4
  %293 = load i32, ptr %257, align 4, !tbaa !3
  %294 = icmp eq i32 %293, -999
  br i1 %294, label %322, label %297

295:                                              ; preds = %267, %272
  %296 = add nuw nsw i32 %265, 1
  br label %264, !llvm.loop !29

297:                                              ; preds = %264, %283
  %298 = add i32 %258, -13
  %299 = add i32 %262, -9
  br label %300

300:                                              ; preds = %297, %320
  %301 = phi i32 [ %321, %320 ], [ 0, %297 ]
  %302 = icmp eq i32 %301, 2
  br i1 %302, label %322, label %303

303:                                              ; preds = %300
  %304 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %301
  %305 = load i32, ptr %304, align 4, !tbaa !3
  %306 = icmp eq i32 %305, -999
  br i1 %306, label %320, label %307

307:                                              ; preds = %303
  %308 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %301
  %309 = load i32, ptr %308, align 4, !tbaa !3
  %310 = sub i32 %298, %305
  %311 = icmp ult i32 %310, -25
  %312 = sub i32 %299, %309
  %313 = icmp ult i32 %312, -13
  %314 = select i1 %311, i1 true, i1 %313
  br i1 %314, label %320, label %315

315:                                              ; preds = %307
  tail call fastcc void @heli_draw(i32 noundef %301, i32 noundef 1) #5
  store i32 -999, ptr %304, align 4, !tbaa !3
  %316 = add nsw i32 %258, -1
  %317 = add nsw i32 %262, -1
  tail call fastcc void @sky(i32 noundef %316, i32 noundef %317, i32 noundef 4, i32 noundef 4) #5
  store i32 -999, ptr %257, align 4, !tbaa !3
  %318 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %319 = add nsw i32 %318, 20
  store i32 %319, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 5) #4
  tail call void @led_blink(i32 noundef 4134912, i32 noundef 2) #4
  br label %322

320:                                              ; preds = %307, %303
  %321 = add nuw nsw i32 %301, 1
  br label %300, !llvm.loop !30

322:                                              ; preds = %300, %315, %283, %256
  %323 = add nuw nsw i32 %250, 1
  br label %249, !llvm.loop !31

324:                                              ; preds = %252
  tail call fastcc void @draw_score() #5
  br label %325

325:                                              ; preds = %324, %252
  br label %21, !llvm.loop !20
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_disc_cell(i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_turret() unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef 104, i32 noundef 200, i32 noundef 32, i32 noundef 14, i16 noundef zeroext 2149) #4
  tail call void @gfx_fill(i32 noundef 108, i32 noundef 214, i32 noundef 24, i32 noundef 8, i16 noundef zeroext -23275) #4
  tail call void @gfx_fill(i32 noundef 114, i32 noundef 210, i32 noundef 12, i32 noundef 4, i16 noundef zeroext -23275) #4
  %1 = load i32, ptr @arena_w, align 4, !tbaa !11
  %2 = getelementptr inbounds [5 x i8], ptr @adx, i32 0, i32 %1
  %3 = load i8, ptr %2, align 1, !tbaa !21
  %4 = sext i8 %3 to i32
  br label %5

5:                                                ; preds = %9, %0
  %6 = phi i32 [ 1, %0 ], [ %17, %9 ]
  %7 = icmp eq i32 %6, 4
  br i1 %7, label %8, label %9

8:                                                ; preds = %5
  tail call void @gfx_damage(i32 noundef 104, i32 noundef 200, i32 noundef 135, i32 noundef 221) #4
  ret void

9:                                                ; preds = %5
  %10 = mul nsw i32 %6, %4
  %11 = trunc i32 %10 to i16
  %12 = sdiv i16 %11, 2
  %13 = add nsw i16 %12, 118
  %14 = sext i16 %13 to i32
  %15 = mul nsw i32 %6, -3
  %16 = add nsw i32 %15, 210
  tail call void @gfx_fill(i32 noundef %14, i32 noundef %16, i32 noundef 4, i32 noundef 4, i16 noundef zeroext -8452) #4
  %17 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !32
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score() unnamed_addr #0 {
  %1 = alloca [6 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %1) #6
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  call void @numstr(ptr noundef nonnull %1, i32 noundef 5, i32 noundef %2) #4
  call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull %1, i16 noundef zeroext -18950, i16 noundef zeroext 2149) #4
  br label %3

3:                                                ; preds = %8, %0
  %4 = phi i32 [ 0, %0 ], [ %14, %8 ]
  %5 = icmp eq i32 %4, 4
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  call void @gfx_damage(i32 noundef 180, i32 noundef 4, i32 noundef 233, i32 noundef 13) #4
  %7 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  store i32 %7, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !28
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %1) #6
  ret void

8:                                                ; preds = %3
  %9 = mul nsw i32 %4, -10
  %10 = add nsw i32 %9, 220
  %11 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %12 = icmp slt i32 %4, %11
  %13 = select i1 %12, i16 -7705, i16 14859
  call void @gfx_fill(i32 noundef %10, i32 noundef 6, i32 noundef 6, i32 noundef 6, i16 noundef zeroext %13) #4
  %14 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !33
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @sky(i32 noundef range(i32 -2147483648, 2147483647) %0, i32 noundef range(i32 -2147483648, 2147483647) %1, i32 noundef range(i32 4, 29) %2, i32 noundef range(i32 4, 25) %3) unnamed_addr #0 {
  %5 = add nsw i32 %3, %1
  %6 = icmp sgt i32 %5, 226
  %7 = sub nsw i32 226, %1
  %8 = select i1 %6, i32 %7, i32 %3
  %9 = icmp sgt i32 %8, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %4
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %8, i16 noundef zeroext 2149) #4
  br label %11

11:                                               ; preds = %10, %4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @heli_draw(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %0
  %4 = load i32, ptr %3, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %0
  %6 = load i32, ptr %5, align 4, !tbaa !3
  %7 = icmp eq i32 %1, 0
  br i1 %7, label %11, label %8

8:                                                ; preds = %2
  %9 = add nsw i32 %4, -14
  %10 = add nsw i32 %6, -4
  tail call fastcc void @sky(i32 noundef %9, i32 noundef %10, i32 noundef 28, i32 noundef 14) #5
  br label %27

11:                                               ; preds = %2
  %12 = add nsw i32 %4, -10
  tail call void @gfx_fill(i32 noundef %12, i32 noundef %6, i32 noundef 20, i32 noundef 8, i16 noundef zeroext 31762) #4
  %13 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %0
  %14 = load i32, ptr %13, align 4, !tbaa !3
  %15 = icmp sgt i32 %14, 0
  %16 = select i1 %15, i32 -14, i32 10
  %17 = add nsw i32 %16, %4
  %18 = add nsw i32 %6, 2
  tail call void @gfx_fill(i32 noundef %17, i32 noundef %18, i32 noundef 4, i32 noundef 4, i16 noundef zeroext 31762) #4
  %19 = add nsw i32 %4, -12
  %20 = add nsw i32 %6, -4
  %21 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %22 = and i32 %21, 2
  %23 = add nsw i32 %22, %20
  tail call void @gfx_fill(i32 noundef %19, i32 noundef %23, i32 noundef 24, i32 noundef 2, i16 noundef zeroext -12710) #4
  %24 = add nsw i32 %4, -14
  %25 = add nsw i32 %4, 13
  %26 = add nsw i32 %6, 9
  tail call void @gfx_damage(i32 noundef %24, i32 noundef %20, i32 noundef %25, i32 noundef %26) #4
  br label %27

27:                                               ; preds = %11, %8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @troop_erase(i32 noundef range(i32 -2147483648, 6) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %0
  %3 = load i32, ptr %2, align 4, !tbaa !3
  %4 = add nsw i32 %3, -8
  %5 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %0
  %6 = load i32, ptr %5, align 4, !tbaa !3
  %7 = add nsw i32 %6, -10
  tail call fastcc void @sky(i32 noundef %4, i32 noundef %7, i32 noundef 16, i32 noundef 24) #5
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @troop_draw(i32 noundef range(i32 -2147483648, 6) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %0
  %3 = load i32, ptr %2, align 4, !tbaa !3
  %4 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %0
  %5 = load i32, ptr %4, align 4, !tbaa !3
  %6 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !3
  %8 = icmp eq i32 %7, 2
  %9 = add nsw i32 %3, -8
  %10 = add nsw i32 %5, -10
  br i1 %8, label %11, label %12

11:                                               ; preds = %1
  tail call void @gfx_blit(i32 noundef %9, i32 noundef %10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512), i32 noundef 16, i32 noundef 8) #4
  br label %12

12:                                               ; preds = %1, %11
  %13 = add nsw i32 %3, -2
  tail call void @gfx_fill(i32 noundef %13, i32 noundef %5, i32 noundef 4, i32 noundef 4, i16 noundef zeroext -6574) #4
  %14 = add nsw i32 %5, 4
  %15 = icmp eq i32 %7, 3
  %16 = select i1 %15, i16 -7705, i16 -6574
  tail call void @gfx_fill(i32 noundef %13, i32 noundef %14, i32 noundef 4, i32 noundef 8, i16 noundef zeroext %16) #4
  %17 = add nsw i32 %3, 7
  %18 = add nsw i32 %5, 13
  tail call void @gfx_damage(i32 noundef %9, i32 noundef %10, i32 noundef %17, i32 noundef %18) #4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #3

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
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = !{!12, !4, i64 0}
!12 = !{!"cst", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16, !4, i64 20, !5, i64 24, !5, i64 36, !5, i64 48, !5, i64 60, !5, i64 72, !5, i64 80, !5, i64 88, !5, i64 96, !5, i64 104, !5, i64 128, !5, i64 152, !4, i64 176, !4, i64 180}
!13 = !{!12, !4, i64 4}
!14 = !{!12, !4, i64 8}
!15 = !{!12, !4, i64 12}
!16 = !{!12, !4, i64 16}
!17 = !{!12, !4, i64 176}
!18 = !{!12, !4, i64 180}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !9}
!21 = !{!5, !5, i64 0}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !8, !9}
!28 = !{!12, !4, i64 20}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
