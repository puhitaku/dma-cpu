; ModuleID = 'chute.c'
source_filename = "chute.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"chute: start\0A\00", align 1
@arena_w = external dso_local global [2304 x i32], align 4
@.str.1 = private unnamed_addr constant [27 x i8] c"chute: run table overflow\0A\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"shoot the chutes!\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.3 = private unnamed_addr constant [13 x i8] c"chute: quit\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.4 = private unnamed_addr constant [14 x i8] c"chute: again\0A\00", align 1
@adx = internal unnamed_addr constant [5 x i8] c"\FB\FD\00\03\05", align 1
@ady = internal unnamed_addr constant [5 x i8] c"\FC\FA\F9\FA\FC", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"OVERRUN!\00", align 1
@.str.6 = private unnamed_addr constant [19 x i8] c"press to try again\00", align 1
@.str.7 = private unnamed_addr constant [18 x i8] c"chute: game over\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @chute_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 263695, i32 noundef 263695) #4
  tail call void @gfx_disc_cell(i32 noundef 16, i32 noundef 8, i16 noundef zeroext -2146, i16 noundef zeroext 2149, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512)) #4
  %1 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512), i32 noundef 16, i32 noundef 8, i16 noundef zeroext 2149, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024), i32 noundef 40) #4
  %2 = icmp slt i32 %1, 0
  br i1 %2, label %3, label %5

3:                                                ; preds = %43, %0
  %4 = phi ptr [ @.str.1, %0 ], [ @.str.4, %43 ]
  tail call void @uputs(ptr noundef nonnull %4) #4
  br label %5

5:                                                ; preds = %3, %0
  tail call void @gfx_clear(i16 noundef zeroext 2149) #4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 226, i32 noundef 240, i32 noundef 14, i16 noundef zeroext 16870) #4
  br label %6

6:                                                ; preds = %9, %5
  %7 = phi i32 [ 0, %5 ], [ %11, %9 ]
  %8 = icmp eq i32 %7, 3
  br i1 %8, label %12, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %7
  store i32 -999, ptr %10, align 4, !tbaa !3
  %11 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !7

12:                                               ; preds = %6, %15
  %13 = phi i32 [ %17, %15 ], [ 0, %6 ]
  %14 = icmp eq i32 %13, 2
  br i1 %14, label %18, label %15

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %13
  store i32 -999, ptr %16, align 4, !tbaa !3
  %17 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !10

18:                                               ; preds = %12, %22
  %19 = phi i32 [ %24, %22 ], [ 0, %12 ]
  %20 = icmp eq i32 %19, 6
  br i1 %20, label %21, label %22

21:                                               ; preds = %18
  store i32 2, ptr @arena_w, align 4, !tbaa !11
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !16
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  tail call fastcc void @draw_turret() #5
  tail call fastcc void @draw_score() #5
  tail call void @gfx_text(i32 noundef 60, i32 noundef 110, ptr noundef nonnull @.str.2, i16 noundef zeroext -18950, i16 noundef zeroext 2149) #4
  br label %25

22:                                               ; preds = %18
  %23 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %19
  store i32 0, ptr %23, align 4, !tbaa !3
  %24 = add nuw nsw i32 %19, 1
  br label %18, !llvm.loop !19

25:                                               ; preds = %408, %21
  tail call void @gfx_present() #4
  br label %26

26:                                               ; preds = %25, %43
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %27 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %28 = add i32 %27, 1
  store i32 %28, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %29 = icmp eq i32 %28, 60
  br i1 %29, label %30, label %31

30:                                               ; preds = %26
  tail call void @gfx_fill(i32 noundef 60, i32 noundef 110, i32 noundef 136, i32 noundef 8, i16 noundef zeroext 2149) #4
  br label %31

31:                                               ; preds = %30, %26
  %32 = load i32, ptr @in_down, align 4, !tbaa !3
  %33 = and i32 %32, 16
  %34 = icmp eq i32 %33, 0
  %35 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4
  %36 = add nsw i32 %35, 1
  %37 = select i1 %34, i32 0, i32 %36
  store i32 %37, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !16
  %38 = icmp sgt i32 %37, 45
  br i1 %38, label %39, label %40

39:                                               ; preds = %31
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  tail call void @snd_off() #4
  ret void

40:                                               ; preds = %31
  %41 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %47, label %43

43:                                               ; preds = %40
  %44 = load i32, ptr @in_edge, align 4, !tbaa !3
  %45 = and i32 %44, 16
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %26, label %3, !llvm.loop !20

47:                                               ; preds = %40, %59
  %48 = phi i32 [ %60, %59 ], [ 0, %40 ]
  %49 = icmp eq i32 %48, 3
  br i1 %49, label %61, label %50

50:                                               ; preds = %47
  %51 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %48
  %52 = load i32, ptr %51, align 4, !tbaa !3
  %53 = icmp eq i32 %52, -999
  br i1 %53, label %59, label %54

54:                                               ; preds = %50
  %55 = add nsw i32 %52, -1
  %56 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %48
  %57 = load i32, ptr %56, align 4, !tbaa !3
  %58 = add nsw i32 %57, -1
  tail call fastcc void @sky(i32 noundef %55, i32 noundef %58, i32 noundef 4, i32 noundef 4) #5
  br label %59

59:                                               ; preds = %50, %54
  %60 = add nuw nsw i32 %48, 1
  br label %47, !llvm.loop !21

61:                                               ; preds = %47, %69
  %62 = phi i32 [ %70, %69 ], [ 0, %47 ]
  %63 = icmp eq i32 %62, 2
  br i1 %63, label %71, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %62
  %66 = load i32, ptr %65, align 4, !tbaa !3
  %67 = icmp eq i32 %66, -999
  br i1 %67, label %69, label %68

68:                                               ; preds = %64
  tail call fastcc void @heli_draw(i32 noundef %62, i32 noundef 1) #5
  br label %69

69:                                               ; preds = %64, %68
  %70 = add nuw nsw i32 %62, 1
  br label %61, !llvm.loop !22

71:                                               ; preds = %61, %91
  %72 = phi i32 [ %92, %91 ], [ 0, %61 ]
  %73 = icmp eq i32 %72, 6
  br i1 %73, label %74, label %81

74:                                               ; preds = %71
  %75 = load i32, ptr @in_edge, align 4, !tbaa !3
  %76 = and i32 %75, 4
  %77 = icmp ne i32 %76, 0
  %78 = load i32, ptr @arena_w, align 4
  %79 = icmp sgt i32 %78, 0
  %80 = select i1 %77, i1 %79, i1 false
  br i1 %80, label %93, label %97

81:                                               ; preds = %71
  %82 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %72
  %83 = load i32, ptr %82, align 4, !tbaa !3
  switch i32 %83, label %84 [
    i32 0, label %91
    i32 4, label %91
  ]

84:                                               ; preds = %81
  %85 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %72
  %86 = load i32, ptr %85, align 4, !tbaa !3
  %87 = add nsw i32 %86, -8
  %88 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %72
  %89 = load i32, ptr %88, align 4, !tbaa !3
  %90 = add nsw i32 %89, -10
  tail call fastcc void @sky(i32 noundef %87, i32 noundef %90, i32 noundef 16, i32 noundef 24) #5
  br label %91

91:                                               ; preds = %81, %81, %84
  %92 = add nuw nsw i32 %72, 1
  br label %71, !llvm.loop !23

93:                                               ; preds = %74
  %94 = add nsw i32 %78, -1
  store i32 %94, ptr @arena_w, align 4, !tbaa !11
  tail call fastcc void @turret_erase() #5
  %95 = load i32, ptr @in_edge, align 4, !tbaa !3
  %96 = load i32, ptr @arena_w, align 4
  br label %97

97:                                               ; preds = %93, %74
  %98 = phi i32 [ %96, %93 ], [ %78, %74 ]
  %99 = phi i32 [ %95, %93 ], [ %75, %74 ]
  %100 = and i32 %99, 8
  %101 = icmp ne i32 %100, 0
  %102 = icmp slt i32 %98, 4
  %103 = select i1 %101, i1 %102, i1 false
  br i1 %103, label %104, label %107

104:                                              ; preds = %97
  %105 = add nsw i32 %98, 1
  store i32 %105, ptr @arena_w, align 4, !tbaa !11
  tail call fastcc void @turret_erase() #5
  %106 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %107

107:                                              ; preds = %104, %97
  %108 = phi i32 [ %106, %104 ], [ %99, %97 ]
  %109 = and i32 %108, 17
  %110 = icmp eq i32 %109, 0
  br i1 %110, label %111, label %112

111:                                              ; preds = %112, %119, %107
  br label %132

112:                                              ; preds = %107, %130
  %113 = phi i32 [ %131, %130 ], [ 0, %107 ]
  %114 = icmp eq i32 %113, 3
  br i1 %114, label %111, label %115

115:                                              ; preds = %112
  %116 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %113
  %117 = load i32, ptr %116, align 4, !tbaa !3
  %118 = icmp eq i32 %117, -999
  br i1 %118, label %119, label %130

119:                                              ; preds = %115
  store i32 120, ptr %116, align 4, !tbaa !3
  %120 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %113
  store i32 202, ptr %120, align 4, !tbaa !3
  %121 = load i32, ptr @arena_w, align 4, !tbaa !11
  %122 = getelementptr inbounds [5 x i8], ptr @adx, i32 0, i32 %121
  %123 = load i8, ptr %122, align 1, !tbaa !24
  %124 = sext i8 %123 to i32
  %125 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 48), i32 0, i32 %113
  store i32 %124, ptr %125, align 4, !tbaa !3
  %126 = getelementptr inbounds [5 x i8], ptr @ady, i32 0, i32 %121
  %127 = load i8, ptr %126, align 1, !tbaa !24
  %128 = sext i8 %127 to i32
  %129 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 60), i32 0, i32 %113
  store i32 %128, ptr %129, align 4, !tbaa !3
  tail call void @snd_play(i32 noundef 900, i32 noundef 40, i32 noundef 2) #4
  br label %111

130:                                              ; preds = %115
  %131 = add nuw nsw i32 %113, 1
  br label %112, !llvm.loop !25

132:                                              ; preds = %111, %159
  %133 = phi i32 [ %160, %159 ], [ 0, %111 ]
  %134 = icmp eq i32 %133, 3
  br i1 %134, label %135, label %140

135:                                              ; preds = %132
  %136 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  %137 = add i32 %136, -1
  store i32 %137, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %161, label %139

139:                                              ; preds = %168, %175, %135
  br label %191

140:                                              ; preds = %132
  %141 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %133
  %142 = load i32, ptr %141, align 4, !tbaa !3
  %143 = icmp eq i32 %142, -999
  br i1 %143, label %159, label %144

144:                                              ; preds = %140
  %145 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 48), i32 0, i32 %133
  %146 = load i32, ptr %145, align 4, !tbaa !3
  %147 = add nsw i32 %146, %142
  store i32 %147, ptr %141, align 4, !tbaa !3
  %148 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 60), i32 0, i32 %133
  %149 = load i32, ptr %148, align 4, !tbaa !3
  %150 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %133
  %151 = load i32, ptr %150, align 4, !tbaa !3
  %152 = add nsw i32 %151, %149
  store i32 %152, ptr %150, align 4, !tbaa !3
  %153 = icmp slt i32 %152, 0
  br i1 %153, label %158, label %154

154:                                              ; preds = %144
  %155 = icmp slt i32 %147, 2
  br i1 %155, label %158, label %156

156:                                              ; preds = %154
  %157 = icmp samesign ugt i32 %147, 236
  br i1 %157, label %158, label %159

158:                                              ; preds = %156, %154, %144
  store i32 -999, ptr %141, align 4, !tbaa !3
  br label %159

159:                                              ; preds = %156, %158, %140
  %160 = add nuw nsw i32 %133, 1
  br label %132, !llvm.loop !26

161:                                              ; preds = %135
  %162 = tail call i32 @rng_below(i32 noundef 90) #4
  %163 = add i32 %162, 90
  %164 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %165 = sdiv i32 %164, 20
  %166 = tail call i32 @llvm.smin.i32(i32 %165, i32 50)
  %167 = sub i32 %163, %166
  store i32 %167, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 176), align 4, !tbaa !17
  br label %168

168:                                              ; preds = %189, %161
  %169 = phi i32 [ 0, %161 ], [ %190, %189 ]
  %170 = icmp eq i32 %169, 2
  br i1 %170, label %139, label %171

171:                                              ; preds = %168
  %172 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %169
  %173 = load i32, ptr %172, align 4, !tbaa !3
  %174 = icmp eq i32 %173, -999
  br i1 %174, label %175, label %189

175:                                              ; preds = %171
  %176 = tail call i32 @rng() #4
  %177 = and i32 %176, 1
  %178 = icmp eq i32 %177, 0
  %179 = select i1 %178, i32 252, i32 -12
  store i32 %179, ptr %172, align 4, !tbaa !3
  %180 = select i1 %178, i32 -2, i32 2
  %181 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %169
  store i32 %180, ptr %181, align 4, !tbaa !3
  %182 = tail call i32 @rng_below(i32 noundef 2) #4
  %183 = shl nsw i32 %182, 4
  %184 = add nsw i32 %183, 22
  %185 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %169
  store i32 %184, ptr %185, align 4, !tbaa !3
  %186 = tail call i32 @rng_below(i32 noundef 60) #4
  %187 = add nsw i32 %186, 20
  %188 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %169
  store i32 %187, ptr %188, align 4, !tbaa !3
  br label %139

189:                                              ; preds = %171
  %190 = add nuw nsw i32 %169, 1
  br label %168, !llvm.loop !27

191:                                              ; preds = %139, %231
  %192 = phi i32 [ %232, %231 ], [ 0, %139 ]
  %193 = icmp eq i32 %192, 2
  br i1 %193, label %233, label %194

194:                                              ; preds = %191
  %195 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %192
  %196 = load i32, ptr %195, align 4, !tbaa !3
  %197 = icmp eq i32 %196, -999
  br i1 %197, label %231, label %198

198:                                              ; preds = %194
  %199 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %192
  %200 = load i32, ptr %199, align 4, !tbaa !3
  %201 = add nsw i32 %200, %196
  store i32 %201, ptr %195, align 4, !tbaa !3
  %202 = icmp slt i32 %201, -13
  br i1 %202, label %205, label %203

203:                                              ; preds = %198
  %204 = icmp sgt i32 %201, 253
  br i1 %204, label %205, label %206

205:                                              ; preds = %203, %198
  store i32 -999, ptr %195, align 4, !tbaa !3
  br label %231

206:                                              ; preds = %203
  %207 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %192
  %208 = load i32, ptr %207, align 4, !tbaa !3
  %209 = add nsw i32 %208, -1
  store i32 %209, ptr %207, align 4, !tbaa !3
  %210 = icmp eq i32 %209, 0
  %211 = add nsw i32 %201, -31
  %212 = icmp ult i32 %211, 179
  %213 = and i1 %212, %210
  br i1 %213, label %214, label %231

214:                                              ; preds = %206, %221
  %215 = phi i32 [ %222, %221 ], [ 0, %206 ]
  %216 = icmp eq i32 %215, 6
  br i1 %216, label %231, label %217

217:                                              ; preds = %214
  %218 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %215
  %219 = load i32, ptr %218, align 4, !tbaa !3
  %220 = icmp eq i32 %219, 0
  br i1 %220, label %223, label %221

221:                                              ; preds = %217
  %222 = add nuw nsw i32 %215, 1
  br label %214, !llvm.loop !28

223:                                              ; preds = %217
  store i32 1, ptr %218, align 4, !tbaa !3
  %224 = load i32, ptr %195, align 4, !tbaa !3
  %225 = and i32 %224, -2
  %226 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %215
  store i32 %225, ptr %226, align 4, !tbaa !3
  %227 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %192
  %228 = load i32, ptr %227, align 4, !tbaa !3
  %229 = add nsw i32 %228, 14
  %230 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %215
  store i32 %229, ptr %230, align 4, !tbaa !3
  br label %231

231:                                              ; preds = %214, %223, %206, %194, %205
  %232 = add nuw nsw i32 %192, 1
  br label %191, !llvm.loop !29

233:                                              ; preds = %191, %278
  %234 = phi i32 [ %279, %278 ], [ 0, %191 ]
  %235 = icmp eq i32 %234, 6
  br i1 %235, label %280, label %236

236:                                              ; preds = %233
  %237 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %234
  %238 = load i32, ptr %237, align 4, !tbaa !3
  switch i32 %238, label %259 [
    i32 0, label %278
    i32 4, label %278
    i32 1, label %239
    i32 2, label %245
  ]

239:                                              ; preds = %236
  %240 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %234
  %241 = load i32, ptr %240, align 4, !tbaa !3
  %242 = add nsw i32 %241, 3
  store i32 %242, ptr %240, align 4, !tbaa !3
  %243 = icmp sgt i32 %241, 67
  br i1 %243, label %244, label %278

244:                                              ; preds = %239
  store i32 2, ptr %237, align 4, !tbaa !3
  br label %263

245:                                              ; preds = %236
  %246 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %234
  %247 = load i32, ptr %246, align 4, !tbaa !3
  %248 = add nsw i32 %247, 1
  store i32 %248, ptr %246, align 4, !tbaa !3
  %249 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 180), align 4, !tbaa !18
  %250 = and i32 %249, 7
  %251 = icmp eq i32 %250, 0
  br i1 %251, label %252, label %263

252:                                              ; preds = %245
  %253 = and i32 %249, 8
  %254 = icmp eq i32 %253, 0
  %255 = select i1 %254, i32 -2, i32 2
  %256 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %234
  %257 = load i32, ptr %256, align 4, !tbaa !3
  %258 = add nsw i32 %257, %255
  store i32 %258, ptr %256, align 4, !tbaa !3
  br label %263

259:                                              ; preds = %236
  %260 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %234
  %261 = load i32, ptr %260, align 4, !tbaa !3
  %262 = add nsw i32 %261, 5
  store i32 %262, ptr %260, align 4, !tbaa !3
  br label %263

263:                                              ; preds = %259, %252, %245, %244
  %264 = phi i32 [ %262, %259 ], [ %248, %252 ], [ %248, %245 ], [ %242, %244 ]
  %265 = icmp sgt i32 %264, 213
  br i1 %265, label %266, label %278

266:                                              ; preds = %263
  %267 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %234
  store i32 214, ptr %267, align 4, !tbaa !3
  %268 = icmp eq i32 %238, 3
  br i1 %268, label %269, label %272

269:                                              ; preds = %266
  store i32 0, ptr %237, align 4, !tbaa !3
  %270 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %271 = add nsw i32 %270, 2
  store i32 %271, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #4
  br label %278

272:                                              ; preds = %266
  store i32 4, ptr %237, align 4, !tbaa !3
  %273 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %274 = add nsw i32 %273, 1
  store i32 %274, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #4
  tail call fastcc void @draw_score() #5
  %275 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !14
  %276 = icmp sgt i32 %275, 3
  br i1 %276, label %277, label %278

277:                                              ; preds = %272
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !15
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -7705, i16 noundef zeroext 2149) #4
  tail call void @gfx_text(i32 noundef 58, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext -18950, i16 noundef zeroext 2149) #4
  tail call void @uputs(ptr noundef nonnull @.str.7) #4
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #4
  tail call void @snd_play(i32 noundef 110, i32 noundef 70, i32 noundef 20) #4
  br label %278

278:                                              ; preds = %239, %263, %277, %272, %236, %236, %269
  %279 = add nuw nsw i32 %234, 1
  br label %233, !llvm.loop !30

280:                                              ; preds = %233, %345
  %281 = phi i32 [ %346, %345 ], [ 0, %233 ]
  %282 = icmp eq i32 %281, 3
  br i1 %282, label %347, label %283

283:                                              ; preds = %280
  %284 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %281
  %285 = load i32, ptr %284, align 4, !tbaa !3
  %286 = icmp eq i32 %285, -999
  br i1 %286, label %345, label %287

287:                                              ; preds = %283
  %288 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %281
  %289 = load i32, ptr %288, align 4, !tbaa !3
  %290 = add i32 %285, 8
  br label %291

291:                                              ; preds = %320, %287
  %292 = phi i32 [ 0, %287 ], [ %321, %320 ]
  %293 = icmp eq i32 %292, 6
  br i1 %293, label %322, label %294

294:                                              ; preds = %291
  %295 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %292
  %296 = load i32, ptr %295, align 4, !tbaa !3
  %297 = add i32 %296, -3
  %298 = icmp ult i32 %297, -2
  br i1 %298, label %320, label %299

299:                                              ; preds = %294
  %300 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %292
  %301 = load i32, ptr %300, align 4, !tbaa !3
  %302 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %292
  %303 = load i32, ptr %302, align 4, !tbaa !3
  %304 = sub nsw i32 %289, %303
  %305 = sub i32 %290, %301
  %306 = icmp ult i32 %305, 17
  %307 = add i32 %304, 10
  %308 = icmp ult i32 %307, 23
  %309 = select i1 %306, i1 %308, i1 false
  br i1 %309, label %310, label %320

310:                                              ; preds = %299
  %311 = icmp eq i32 %296, 2
  %312 = icmp slt i32 %304, 0
  %313 = select i1 %311, i1 %312, i1 false
  %314 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %315 = select i1 %313, i32 5, i32 10
  %316 = select i1 %313, i32 3, i32 0
  %317 = add nsw i32 %314, %315
  store i32 %316, ptr %295, align 4, !tbaa !3
  store i32 %317, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  store i32 -999, ptr %284, align 4, !tbaa !3
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #4
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #4
  %318 = load i32, ptr %284, align 4, !tbaa !3
  %319 = icmp eq i32 %318, -999
  br i1 %319, label %345, label %322

320:                                              ; preds = %294, %299
  %321 = add nuw nsw i32 %292, 1
  br label %291, !llvm.loop !31

322:                                              ; preds = %291, %310
  %323 = add i32 %285, -13
  %324 = add i32 %289, -9
  br label %325

325:                                              ; preds = %322, %343
  %326 = phi i32 [ %344, %343 ], [ 0, %322 ]
  %327 = icmp eq i32 %326, 2
  br i1 %327, label %345, label %328

328:                                              ; preds = %325
  %329 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %326
  %330 = load i32, ptr %329, align 4, !tbaa !3
  %331 = icmp eq i32 %330, -999
  br i1 %331, label %343, label %332

332:                                              ; preds = %328
  %333 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %326
  %334 = load i32, ptr %333, align 4, !tbaa !3
  %335 = sub i32 %323, %330
  %336 = icmp ult i32 %335, -25
  %337 = sub i32 %324, %334
  %338 = icmp ult i32 %337, -13
  %339 = select i1 %336, i1 true, i1 %338
  br i1 %339, label %343, label %340

340:                                              ; preds = %332
  store i32 -999, ptr %329, align 4, !tbaa !3
  store i32 -999, ptr %284, align 4, !tbaa !3
  %341 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %342 = add nsw i32 %341, 20
  store i32 %342, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 5) #4
  tail call void @led_blink(i32 noundef 4134912, i32 noundef 2) #4
  br label %345

343:                                              ; preds = %332, %328
  %344 = add nuw nsw i32 %326, 1
  br label %325, !llvm.loop !32

345:                                              ; preds = %325, %340, %310, %283
  %346 = add nuw nsw i32 %281, 1
  br label %280, !llvm.loop !33

347:                                              ; preds = %280, %370
  %348 = phi i32 [ %371, %370 ], [ 0, %280 ]
  %349 = icmp eq i32 %348, 6
  br i1 %349, label %372, label %350

350:                                              ; preds = %347
  %351 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 152), i32 0, i32 %348
  %352 = load i32, ptr %351, align 4, !tbaa !3
  %353 = icmp eq i32 %352, 0
  br i1 %353, label %370, label %354

354:                                              ; preds = %350
  %355 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %348
  %356 = load i32, ptr %355, align 4, !tbaa !3
  %357 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %348
  %358 = load i32, ptr %357, align 4, !tbaa !3
  %359 = icmp eq i32 %352, 2
  %360 = add nsw i32 %356, -8
  %361 = add nsw i32 %358, -10
  br i1 %359, label %362, label %363

362:                                              ; preds = %354
  tail call void @gfx_blit_runs(i32 noundef %360, i32 noundef %361, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 512), i32 noundef 16, i32 noundef 8, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1024)) #4
  br label %363

363:                                              ; preds = %354, %362
  %364 = add nsw i32 %356, -2
  tail call void @gfx_fill(i32 noundef %364, i32 noundef %358, i32 noundef 4, i32 noundef 4, i16 noundef zeroext -6574) #4
  %365 = add nsw i32 %358, 4
  %366 = icmp eq i32 %352, 3
  %367 = select i1 %366, i16 -7705, i16 -6574
  tail call void @gfx_fill(i32 noundef %364, i32 noundef %365, i32 noundef 4, i32 noundef 8, i16 noundef zeroext %367) #4
  %368 = add nsw i32 %356, 7
  %369 = add nsw i32 %358, 13
  tail call void @gfx_damage(i32 noundef %360, i32 noundef %361, i32 noundef %368, i32 noundef %369) #4
  br label %370

370:                                              ; preds = %350, %363
  %371 = add nuw nsw i32 %348, 1
  br label %347, !llvm.loop !34

372:                                              ; preds = %347, %381
  %373 = phi i32 [ %382, %381 ], [ 0, %347 ]
  %374 = icmp eq i32 %373, 2
  br i1 %374, label %375, label %376

375:                                              ; preds = %372
  tail call fastcc void @draw_turret() #5
  br label %383

376:                                              ; preds = %372
  %377 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 72), i32 0, i32 %373
  %378 = load i32, ptr %377, align 4, !tbaa !3
  %379 = icmp eq i32 %378, -999
  br i1 %379, label %381, label %380

380:                                              ; preds = %376
  tail call fastcc void @heli_draw(i32 noundef %373, i32 noundef 0) #5
  br label %381

381:                                              ; preds = %376, %380
  %382 = add nuw nsw i32 %373, 1
  br label %372, !llvm.loop !35

383:                                              ; preds = %405, %375
  %384 = phi i32 [ 0, %375 ], [ %406, %405 ]
  %385 = icmp eq i32 %384, 3
  br i1 %385, label %386, label %390

386:                                              ; preds = %383
  %387 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !13
  %388 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !36
  %389 = icmp eq i32 %387, %388
  br i1 %389, label %408, label %407

390:                                              ; preds = %383
  %391 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), i32 0, i32 %384
  %392 = load i32, ptr %391, align 4, !tbaa !3
  %393 = icmp eq i32 %392, -999
  br i1 %393, label %405, label %394

394:                                              ; preds = %390
  %395 = add nsw i32 %392, -1
  %396 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 36), i32 0, i32 %384
  %397 = load i32, ptr %396, align 4, !tbaa !3
  %398 = add nsw i32 %397, -1
  tail call void @gfx_fill(i32 noundef %395, i32 noundef %398, i32 noundef 3, i32 noundef 3, i16 noundef zeroext -278) #4
  %399 = load i32, ptr %391, align 4, !tbaa !3
  %400 = add nsw i32 %399, -4
  %401 = load i32, ptr %396, align 4, !tbaa !3
  %402 = add nsw i32 %401, -4
  %403 = add nsw i32 %399, 6
  %404 = add nsw i32 %401, 8
  tail call void @gfx_damage(i32 noundef %400, i32 noundef %402, i32 noundef %403, i32 noundef %404) #4
  br label %405

405:                                              ; preds = %390, %394
  %406 = add nuw nsw i32 %384, 1
  br label %383, !llvm.loop !37

407:                                              ; preds = %386
  tail call fastcc void @draw_score() #5
  br label %408

408:                                              ; preds = %407, %386
  br label %25, !llvm.loop !20
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_disc_cell(i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @gfx_cell_runs(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, ptr noundef, i32 noundef) local_unnamed_addr #1

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

; Function Attrs: minsize nounwind optsize
define internal fastcc void @turret_erase() unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef 104, i32 noundef 200, i32 noundef 32, i32 noundef 14, i16 noundef zeroext 2149) #4
  tail call void @gfx_damage(i32 noundef 104, i32 noundef 200, i32 noundef 135, i32 noundef 213) #4
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
declare dso_local void @gfx_blit_runs(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) local_unnamed_addr #1

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
