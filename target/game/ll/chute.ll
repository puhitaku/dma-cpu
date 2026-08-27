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
  tail call void @gfx_cell_spans(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512), i32 noundef 16, i32 noundef 8, i16 noundef zeroext 2149, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024)) #4
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

21:                                               ; preds = %399, %17
  tail call void @gfx_present() #4
  br label %22

22:                                               ; preds = %21, %39
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
  br i1 %38, label %44, label %39

39:                                               ; preds = %36
  %40 = load i32, ptr @in_edge, align 4, !tbaa !3
  %41 = and i32 %40, 16
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %22, label %43, !llvm.loop !20

43:                                               ; preds = %39
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  br label %1

44:                                               ; preds = %36, %56
  %45 = phi i32 [ %57, %56 ], [ 0, %36 ]
  %46 = icmp eq i32 %45, 3
  br i1 %46, label %58, label %47

47:                                               ; preds = %44
  %48 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %45
  %49 = load i32, ptr %48, align 4, !tbaa !3
  %50 = icmp eq i32 %49, -999
  br i1 %50, label %56, label %51

51:                                               ; preds = %47
  %52 = add nsw i32 %49, -1
  %53 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %45
  %54 = load i32, ptr %53, align 4, !tbaa !3
  %55 = add nsw i32 %54, -1
  tail call fastcc void @sky(i32 noundef %52, i32 noundef %55, i32 noundef 4, i32 noundef 4) #5
  br label %56

56:                                               ; preds = %47, %51
  %57 = add nuw nsw i32 %45, 1
  br label %44, !llvm.loop !21

58:                                               ; preds = %44, %66
  %59 = phi i32 [ %67, %66 ], [ 0, %44 ]
  %60 = icmp eq i32 %59, 2
  br i1 %60, label %68, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %59
  %63 = load i32, ptr %62, align 4, !tbaa !3
  %64 = icmp eq i32 %63, -999
  br i1 %64, label %66, label %65

65:                                               ; preds = %61
  tail call fastcc void @heli_draw(i32 noundef %59, i32 noundef 1) #5
  br label %66

66:                                               ; preds = %61, %65
  %67 = add nuw nsw i32 %59, 1
  br label %58, !llvm.loop !22

68:                                               ; preds = %58, %97
  %69 = phi i32 [ %98, %97 ], [ 0, %58 ]
  %70 = icmp eq i32 %69, 6
  br i1 %70, label %71, label %87

71:                                               ; preds = %68
  %72 = load i32, ptr @in_edge, align 4, !tbaa !3
  %73 = and i32 %72, 4
  %74 = icmp ne i32 %73, 0
  %75 = load i32, ptr @arena_w, align 4
  %76 = icmp sgt i32 %75, 0
  %77 = select i1 %74, i1 %76, i1 false
  %78 = sext i1 %77 to i32
  %79 = add nsw i32 %75, %78
  %80 = and i32 %72, 8
  %81 = icmp ne i32 %80, 0
  %82 = icmp slt i32 %79, 4
  %83 = select i1 %81, i1 %82, i1 false
  %84 = zext i1 %83 to i32
  %85 = add nsw i32 %79, %84
  %86 = or i1 %77, %83
  br i1 %86, label %99, label %100

87:                                               ; preds = %68
  %88 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %69
  %89 = load i32, ptr %88, align 4, !tbaa !3
  switch i32 %89, label %90 [
    i32 0, label %97
    i32 4, label %97
  ]

90:                                               ; preds = %87
  %91 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %69
  %92 = load i32, ptr %91, align 4, !tbaa !3
  %93 = add nsw i32 %92, -8
  %94 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %69
  %95 = load i32, ptr %94, align 4, !tbaa !3
  %96 = add nsw i32 %95, -10
  tail call fastcc void @sky(i32 noundef %93, i32 noundef %96, i32 noundef 16, i32 noundef 24) #5
  br label %97

97:                                               ; preds = %87, %87, %90
  %98 = add nuw nsw i32 %69, 1
  br label %68, !llvm.loop !23

99:                                               ; preds = %71
  store i32 %85, ptr @arena_w, align 4, !tbaa !11
  br label %100

100:                                              ; preds = %71, %99
  %101 = and i32 %72, 17
  %102 = icmp eq i32 %101, 0
  br i1 %102, label %103, label %104

103:                                              ; preds = %104, %111, %100
  br label %123

104:                                              ; preds = %100, %121
  %105 = phi i32 [ %122, %121 ], [ 0, %100 ]
  %106 = icmp eq i32 %105, 3
  br i1 %106, label %103, label %107

107:                                              ; preds = %104
  %108 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %105
  %109 = load i32, ptr %108, align 4, !tbaa !3
  %110 = icmp eq i32 %109, -999
  br i1 %110, label %111, label %121

111:                                              ; preds = %107
  store i32 120, ptr %108, align 4, !tbaa !3
  %112 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %105
  store i32 202, ptr %112, align 4, !tbaa !3
  %113 = getelementptr inbounds [5 x i8], ptr @adx, i32 0, i32 %85
  %114 = load i8, ptr %113, align 1, !tbaa !24
  %115 = sext i8 %114 to i32
  %116 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 48), i32 0, i32 %105
  store i32 %115, ptr %116, align 4, !tbaa !3
  %117 = getelementptr inbounds [5 x i8], ptr @ady, i32 0, i32 %85
  %118 = load i8, ptr %117, align 1, !tbaa !24
  %119 = sext i8 %118 to i32
  %120 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 60), i32 0, i32 %105
  store i32 %119, ptr %120, align 4, !tbaa !3
  tail call void @snd_play(i32 noundef 900, i32 noundef 40, i32 noundef 2) #4
  br label %103

121:                                              ; preds = %107
  %122 = add nuw nsw i32 %105, 1
  br label %104, !llvm.loop !25

123:                                              ; preds = %103, %150
  %124 = phi i32 [ %151, %150 ], [ 0, %103 ]
  %125 = icmp eq i32 %124, 3
  br i1 %125, label %126, label %131

126:                                              ; preds = %123
  %127 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  %128 = add i32 %127, -1
  store i32 %128, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %152, label %130

130:                                              ; preds = %159, %166, %126
  br label %182

131:                                              ; preds = %123
  %132 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %124
  %133 = load i32, ptr %132, align 4, !tbaa !3
  %134 = icmp eq i32 %133, -999
  br i1 %134, label %150, label %135

135:                                              ; preds = %131
  %136 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 48), i32 0, i32 %124
  %137 = load i32, ptr %136, align 4, !tbaa !3
  %138 = add nsw i32 %137, %133
  store i32 %138, ptr %132, align 4, !tbaa !3
  %139 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 60), i32 0, i32 %124
  %140 = load i32, ptr %139, align 4, !tbaa !3
  %141 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %124
  %142 = load i32, ptr %141, align 4, !tbaa !3
  %143 = add nsw i32 %142, %140
  store i32 %143, ptr %141, align 4, !tbaa !3
  %144 = icmp slt i32 %143, 0
  br i1 %144, label %149, label %145

145:                                              ; preds = %135
  %146 = icmp slt i32 %138, 2
  br i1 %146, label %149, label %147

147:                                              ; preds = %145
  %148 = icmp samesign ugt i32 %138, 236
  br i1 %148, label %149, label %150

149:                                              ; preds = %147, %145, %135
  store i32 -999, ptr %132, align 4, !tbaa !3
  br label %150

150:                                              ; preds = %147, %149, %131
  %151 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !26

152:                                              ; preds = %126
  %153 = tail call i32 @rng_below(i32 noundef 90) #4
  %154 = add i32 %153, 90
  %155 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %156 = sdiv i32 %155, 20
  %157 = tail call i32 @llvm.smin.i32(i32 %156, i32 50)
  %158 = sub i32 %154, %157
  store i32 %158, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  br label %159

159:                                              ; preds = %180, %152
  %160 = phi i32 [ 0, %152 ], [ %181, %180 ]
  %161 = icmp eq i32 %160, 2
  br i1 %161, label %130, label %162

162:                                              ; preds = %159
  %163 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %160
  %164 = load i32, ptr %163, align 4, !tbaa !3
  %165 = icmp eq i32 %164, -999
  br i1 %165, label %166, label %180

166:                                              ; preds = %162
  %167 = tail call i32 @rng() #4
  %168 = and i32 %167, 1
  %169 = icmp eq i32 %168, 0
  %170 = select i1 %169, i32 252, i32 -12
  store i32 %170, ptr %163, align 4, !tbaa !3
  %171 = select i1 %169, i32 -2, i32 2
  %172 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %160
  store i32 %171, ptr %172, align 4, !tbaa !3
  %173 = tail call i32 @rng_below(i32 noundef 2) #4
  %174 = shl nsw i32 %173, 4
  %175 = add nsw i32 %174, 22
  %176 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %160
  store i32 %175, ptr %176, align 4, !tbaa !3
  %177 = tail call i32 @rng_below(i32 noundef 60) #4
  %178 = add nsw i32 %177, 20
  %179 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %160
  store i32 %178, ptr %179, align 4, !tbaa !3
  br label %130

180:                                              ; preds = %162
  %181 = add nuw nsw i32 %160, 1
  br label %159, !llvm.loop !27

182:                                              ; preds = %130, %222
  %183 = phi i32 [ %223, %222 ], [ 0, %130 ]
  %184 = icmp eq i32 %183, 2
  br i1 %184, label %224, label %185

185:                                              ; preds = %182
  %186 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %183
  %187 = load i32, ptr %186, align 4, !tbaa !3
  %188 = icmp eq i32 %187, -999
  br i1 %188, label %222, label %189

189:                                              ; preds = %185
  %190 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %183
  %191 = load i32, ptr %190, align 4, !tbaa !3
  %192 = add nsw i32 %191, %187
  store i32 %192, ptr %186, align 4, !tbaa !3
  %193 = icmp slt i32 %192, -13
  br i1 %193, label %196, label %194

194:                                              ; preds = %189
  %195 = icmp sgt i32 %192, 253
  br i1 %195, label %196, label %197

196:                                              ; preds = %194, %189
  store i32 -999, ptr %186, align 4, !tbaa !3
  br label %222

197:                                              ; preds = %194
  %198 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %183
  %199 = load i32, ptr %198, align 4, !tbaa !3
  %200 = add nsw i32 %199, -1
  store i32 %200, ptr %198, align 4, !tbaa !3
  %201 = icmp eq i32 %200, 0
  %202 = add nsw i32 %192, -31
  %203 = icmp ult i32 %202, 179
  %204 = and i1 %203, %201
  br i1 %204, label %205, label %222

205:                                              ; preds = %197, %212
  %206 = phi i32 [ %213, %212 ], [ 0, %197 ]
  %207 = icmp eq i32 %206, 6
  br i1 %207, label %222, label %208

208:                                              ; preds = %205
  %209 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %206
  %210 = load i32, ptr %209, align 4, !tbaa !3
  %211 = icmp eq i32 %210, 0
  br i1 %211, label %214, label %212

212:                                              ; preds = %208
  %213 = add nuw nsw i32 %206, 1
  br label %205, !llvm.loop !28

214:                                              ; preds = %208
  store i32 1, ptr %209, align 4, !tbaa !3
  %215 = load i32, ptr %186, align 4, !tbaa !3
  %216 = and i32 %215, -2
  %217 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %206
  store i32 %216, ptr %217, align 4, !tbaa !3
  %218 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %183
  %219 = load i32, ptr %218, align 4, !tbaa !3
  %220 = add nsw i32 %219, 14
  %221 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %206
  store i32 %220, ptr %221, align 4, !tbaa !3
  br label %222

222:                                              ; preds = %205, %214, %197, %185, %196
  %223 = add nuw nsw i32 %183, 1
  br label %182, !llvm.loop !29

224:                                              ; preds = %182, %269
  %225 = phi i32 [ %270, %269 ], [ 0, %182 ]
  %226 = icmp eq i32 %225, 6
  br i1 %226, label %271, label %227

227:                                              ; preds = %224
  %228 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %225
  %229 = load i32, ptr %228, align 4, !tbaa !3
  switch i32 %229, label %250 [
    i32 0, label %269
    i32 4, label %269
    i32 1, label %230
    i32 2, label %236
  ]

230:                                              ; preds = %227
  %231 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %225
  %232 = load i32, ptr %231, align 4, !tbaa !3
  %233 = add nsw i32 %232, 3
  store i32 %233, ptr %231, align 4, !tbaa !3
  %234 = icmp sgt i32 %232, 67
  br i1 %234, label %235, label %269

235:                                              ; preds = %230
  store i32 2, ptr %228, align 4, !tbaa !3
  br label %254

236:                                              ; preds = %227
  %237 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %225
  %238 = load i32, ptr %237, align 4, !tbaa !3
  %239 = add nsw i32 %238, 1
  store i32 %239, ptr %237, align 4, !tbaa !3
  %240 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %241 = and i32 %240, 7
  %242 = icmp eq i32 %241, 0
  br i1 %242, label %243, label %254

243:                                              ; preds = %236
  %244 = and i32 %240, 8
  %245 = icmp eq i32 %244, 0
  %246 = select i1 %245, i32 -2, i32 2
  %247 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %225
  %248 = load i32, ptr %247, align 4, !tbaa !3
  %249 = add nsw i32 %248, %246
  store i32 %249, ptr %247, align 4, !tbaa !3
  br label %254

250:                                              ; preds = %227
  %251 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %225
  %252 = load i32, ptr %251, align 4, !tbaa !3
  %253 = add nsw i32 %252, 5
  store i32 %253, ptr %251, align 4, !tbaa !3
  br label %254

254:                                              ; preds = %250, %243, %236, %235
  %255 = phi i32 [ %253, %250 ], [ %239, %243 ], [ %239, %236 ], [ %233, %235 ]
  %256 = icmp sgt i32 %255, 213
  br i1 %256, label %257, label %269

257:                                              ; preds = %254
  %258 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %225
  store i32 214, ptr %258, align 4, !tbaa !3
  %259 = icmp eq i32 %229, 3
  br i1 %259, label %260, label %263

260:                                              ; preds = %257
  store i32 0, ptr %228, align 4, !tbaa !3
  %261 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %262 = add nsw i32 %261, 2
  store i32 %262, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #4
  br label %269

263:                                              ; preds = %257
  store i32 4, ptr %228, align 4, !tbaa !3
  %264 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %265 = add nsw i32 %264, 1
  store i32 %265, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #4
  tail call fastcc void @draw_score() #5
  %266 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %267 = icmp sgt i32 %266, 3
  br i1 %267, label %268, label %269

268:                                              ; preds = %263
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 104, ptr noundef nonnull @.str.4, i16 noundef zeroext -7705, i16 noundef zeroext 2149) #4
  tail call void @gfx_text(i32 noundef 58, i32 noundef 128, ptr noundef nonnull @.str.5, i16 noundef zeroext -18950, i16 noundef zeroext 2149) #4
  tail call void @uputs(ptr noundef nonnull @.str.6) #4
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #4
  tail call void @snd_play(i32 noundef 110, i32 noundef 70, i32 noundef 20) #4
  br label %269

269:                                              ; preds = %230, %254, %268, %263, %227, %227, %260
  %270 = add nuw nsw i32 %225, 1
  br label %224, !llvm.loop !30

271:                                              ; preds = %224, %336
  %272 = phi i32 [ %337, %336 ], [ 0, %224 ]
  %273 = icmp eq i32 %272, 3
  br i1 %273, label %338, label %274

274:                                              ; preds = %271
  %275 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %272
  %276 = load i32, ptr %275, align 4, !tbaa !3
  %277 = icmp eq i32 %276, -999
  br i1 %277, label %336, label %278

278:                                              ; preds = %274
  %279 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %272
  %280 = load i32, ptr %279, align 4, !tbaa !3
  %281 = add i32 %276, 8
  br label %282

282:                                              ; preds = %311, %278
  %283 = phi i32 [ 0, %278 ], [ %312, %311 ]
  %284 = icmp eq i32 %283, 6
  br i1 %284, label %313, label %285

285:                                              ; preds = %282
  %286 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %283
  %287 = load i32, ptr %286, align 4, !tbaa !3
  %288 = add i32 %287, -3
  %289 = icmp ult i32 %288, -2
  br i1 %289, label %311, label %290

290:                                              ; preds = %285
  %291 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %283
  %292 = load i32, ptr %291, align 4, !tbaa !3
  %293 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %283
  %294 = load i32, ptr %293, align 4, !tbaa !3
  %295 = sub nsw i32 %280, %294
  %296 = sub i32 %281, %292
  %297 = icmp ult i32 %296, 17
  %298 = add i32 %295, 10
  %299 = icmp ult i32 %298, 23
  %300 = select i1 %297, i1 %299, i1 false
  br i1 %300, label %301, label %311

301:                                              ; preds = %290
  %302 = icmp eq i32 %287, 2
  %303 = icmp slt i32 %295, 0
  %304 = select i1 %302, i1 %303, i1 false
  %305 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %306 = select i1 %304, i32 5, i32 10
  %307 = select i1 %304, i32 3, i32 0
  %308 = add nsw i32 %305, %306
  store i32 %307, ptr %286, align 4, !tbaa !3
  store i32 %308, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  store i32 -999, ptr %275, align 4, !tbaa !3
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #4
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #4
  %309 = load i32, ptr %275, align 4, !tbaa !3
  %310 = icmp eq i32 %309, -999
  br i1 %310, label %336, label %313

311:                                              ; preds = %285, %290
  %312 = add nuw nsw i32 %283, 1
  br label %282, !llvm.loop !31

313:                                              ; preds = %282, %301
  %314 = add i32 %276, -13
  %315 = add i32 %280, -9
  br label %316

316:                                              ; preds = %313, %334
  %317 = phi i32 [ %335, %334 ], [ 0, %313 ]
  %318 = icmp eq i32 %317, 2
  br i1 %318, label %336, label %319

319:                                              ; preds = %316
  %320 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %317
  %321 = load i32, ptr %320, align 4, !tbaa !3
  %322 = icmp eq i32 %321, -999
  br i1 %322, label %334, label %323

323:                                              ; preds = %319
  %324 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %317
  %325 = load i32, ptr %324, align 4, !tbaa !3
  %326 = sub i32 %314, %321
  %327 = icmp ult i32 %326, -25
  %328 = sub i32 %315, %325
  %329 = icmp ult i32 %328, -13
  %330 = select i1 %327, i1 true, i1 %329
  br i1 %330, label %334, label %331

331:                                              ; preds = %323
  store i32 -999, ptr %320, align 4, !tbaa !3
  store i32 -999, ptr %275, align 4, !tbaa !3
  %332 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %333 = add nsw i32 %332, 20
  store i32 %333, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 5) #4
  tail call void @led_blink(i32 noundef 4134912, i32 noundef 2) #4
  br label %336

334:                                              ; preds = %323, %319
  %335 = add nuw nsw i32 %317, 1
  br label %316, !llvm.loop !32

336:                                              ; preds = %316, %331, %301, %274
  %337 = add nuw nsw i32 %272, 1
  br label %271, !llvm.loop !33

338:                                              ; preds = %271, %361
  %339 = phi i32 [ %362, %361 ], [ 0, %271 ]
  %340 = icmp eq i32 %339, 6
  br i1 %340, label %363, label %341

341:                                              ; preds = %338
  %342 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %339
  %343 = load i32, ptr %342, align 4, !tbaa !3
  %344 = icmp eq i32 %343, 0
  br i1 %344, label %361, label %345

345:                                              ; preds = %341
  %346 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %339
  %347 = load i32, ptr %346, align 4, !tbaa !3
  %348 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %339
  %349 = load i32, ptr %348, align 4, !tbaa !3
  %350 = icmp eq i32 %343, 2
  %351 = add nsw i32 %347, -8
  %352 = add nsw i32 %349, -10
  br i1 %350, label %353, label %354

353:                                              ; preds = %345
  tail call void @gfx_blit_spans(i32 noundef %351, i32 noundef %352, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512), i32 noundef 16, i32 noundef 8, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024)) #4
  br label %354

354:                                              ; preds = %345, %353
  %355 = add nsw i32 %347, -2
  tail call void @gfx_fill(i32 noundef %355, i32 noundef %349, i32 noundef 4, i32 noundef 4, i16 noundef zeroext -6574) #4
  %356 = add nsw i32 %349, 4
  %357 = icmp eq i32 %343, 3
  %358 = select i1 %357, i16 -7705, i16 -6574
  tail call void @gfx_fill(i32 noundef %355, i32 noundef %356, i32 noundef 4, i32 noundef 8, i16 noundef zeroext %358) #4
  %359 = add nsw i32 %347, 7
  %360 = add nsw i32 %349, 13
  tail call void @gfx_damage(i32 noundef %351, i32 noundef %352, i32 noundef %359, i32 noundef %360) #4
  br label %361

361:                                              ; preds = %341, %354
  %362 = add nuw nsw i32 %339, 1
  br label %338, !llvm.loop !34

363:                                              ; preds = %338, %372
  %364 = phi i32 [ %373, %372 ], [ 0, %338 ]
  %365 = icmp eq i32 %364, 2
  br i1 %365, label %366, label %367

366:                                              ; preds = %363
  tail call fastcc void @draw_turret() #5
  br label %374

367:                                              ; preds = %363
  %368 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %364
  %369 = load i32, ptr %368, align 4, !tbaa !3
  %370 = icmp eq i32 %369, -999
  br i1 %370, label %372, label %371

371:                                              ; preds = %367
  tail call fastcc void @heli_draw(i32 noundef %364, i32 noundef 0) #5
  br label %372

372:                                              ; preds = %367, %371
  %373 = add nuw nsw i32 %364, 1
  br label %363, !llvm.loop !35

374:                                              ; preds = %396, %366
  %375 = phi i32 [ 0, %366 ], [ %397, %396 ]
  %376 = icmp eq i32 %375, 3
  br i1 %376, label %377, label %381

377:                                              ; preds = %374
  %378 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %379 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !36
  %380 = icmp eq i32 %378, %379
  br i1 %380, label %399, label %398

381:                                              ; preds = %374
  %382 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %375
  %383 = load i32, ptr %382, align 4, !tbaa !3
  %384 = icmp eq i32 %383, -999
  br i1 %384, label %396, label %385

385:                                              ; preds = %381
  %386 = add nsw i32 %383, -1
  %387 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %375
  %388 = load i32, ptr %387, align 4, !tbaa !3
  %389 = add nsw i32 %388, -1
  tail call void @gfx_fill(i32 noundef %386, i32 noundef %389, i32 noundef 3, i32 noundef 3, i16 noundef zeroext -278) #4
  %390 = load i32, ptr %382, align 4, !tbaa !3
  %391 = add nsw i32 %390, -4
  %392 = load i32, ptr %387, align 4, !tbaa !3
  %393 = add nsw i32 %392, -4
  %394 = add nsw i32 %390, 6
  %395 = add nsw i32 %392, 8
  tail call void @gfx_damage(i32 noundef %391, i32 noundef %393, i32 noundef %394, i32 noundef %395) #4
  br label %396

396:                                              ; preds = %381, %385
  %397 = add nuw nsw i32 %375, 1
  br label %374, !llvm.loop !37

398:                                              ; preds = %377
  tail call fastcc void @draw_score() #5
  br label %399

399:                                              ; preds = %398, %377
  br label %21, !llvm.loop !20
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_disc_cell(i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_cell_spans(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

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
  %3 = load i8, ptr %2, align 1, !tbaa !24
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
  br label %5, !llvm.loop !38
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
  store i32 %7, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !36
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
  br label %3, !llvm.loop !39
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

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit_spans(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) local_unnamed_addr #1

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
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = !{!5, !5, i64 0}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !8, !9}
!28 = distinct !{!28, !8, !9}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
!36 = !{!12, !4, i64 20}
!37 = distinct !{!37, !8, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
