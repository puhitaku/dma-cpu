; ModuleID = 'yacht.c'
source_filename = "yacht.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"yacht: start\0A\00", align 1
@scores = internal unnamed_addr global [12 x i32] zeroinitializer, align 4
@turn = internal unnamed_addr global i32 0, align 4
@.str.1 = private unnamed_addr constant [6 x i8] c"YACHT\00", align 1
@rolls_left = internal unnamed_addr global i32 0, align 4
@held = internal unnamed_addr global [5 x i32] zeroinitializer, align 4
@dice = internal unnamed_addr global [5 x i32] zeroinitializer, align 4
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [13 x i8] c"yacht: quit\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.3 = private unnamed_addr constant [13 x i8] c"yacht: roll\0A\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"yacht: cat=\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c" score=\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"FINISHED\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"total\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"press: menu\00", align 1
@.str.10 = private unnamed_addr constant [14 x i8] c"yacht: total=\00", align 1
@pips = internal unnamed_addr constant [7 x i16] [i16 0, i16 16, i16 257, i16 273, i16 325, i16 341, i16 365], align 2
@.str.11 = private unnamed_addr constant [5 x i8] c"ROLL\00", align 1
@catname = internal unnamed_addr constant [12 x ptr] [ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.22, ptr @.str.23], align 4
@.str.12 = private unnamed_addr constant [5 x i8] c"Aces\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"Twos\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c"Threes\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"Fours\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"Fives\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"Sixes\00", align 1
@.str.18 = private unnamed_addr constant [7 x i8] c"Choice\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"Four Kind\00", align 1
@.str.20 = private unnamed_addr constant [11 x i8] c"Full House\00", align 1
@.str.21 = private unnamed_addr constant [15 x i8] c"Small Straight\00", align 1
@.str.22 = private unnamed_addr constant [13 x i8] c"Big Straight\00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"Yacht\00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"TOTAL\00", align 1
@.str.25 = private unnamed_addr constant [17 x i8] c"hold press: quit\00", align 1
@roll_anim.pause = internal unnamed_addr constant [7 x i8] c"\01\01\02\03\04\06\08", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @yacht_run() local_unnamed_addr #0 {
  %1 = alloca [5 x i32], align 4
  %2 = alloca [6 x i8], align 1
  %3 = alloca [4 x i8], align 1
  tail call void @uputs(ptr noundef nonnull @.str) #6
  tail call void @led(i32 noundef 986888, i32 noundef 986888) #6
  br label %4

4:                                                ; preds = %13, %0
  %5 = phi i32 [ 0, %0 ], [ %15, %13 ]
  %6 = icmp eq i32 %5, 12
  br i1 %6, label %7, label %13

7:                                                ; preds = %4
  store i32 0, ptr @turn, align 4, !tbaa !3
  tail call void @gfx_clear(i16 noundef zeroext 2371) #6
  tail call void @gfx_text(i32 noundef 6, i32 noundef 4, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 2371) #6
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 2
  %9 = getelementptr inbounds nuw i8, ptr %2, i32 3
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %11 = getelementptr inbounds nuw i8, ptr %2, i32 5
  %12 = load i32, ptr @turn, align 4, !tbaa !3
  br label %16

13:                                               ; preds = %4
  %14 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %5
  store i32 -1, ptr %14, align 4, !tbaa !3
  %15 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !7

16:                                               ; preds = %273, %7
  %17 = phi i32 [ %274, %273 ], [ %12, %7 ]
  %18 = add nsw i32 %17, 1
  store i32 %18, ptr @turn, align 4, !tbaa !3
  store i32 3, ptr @rolls_left, align 4, !tbaa !3
  br label %19

19:                                               ; preds = %22, %16
  %20 = phi i32 [ 0, %16 ], [ %24, %22 ]
  %21 = icmp eq i32 %20, 5
  br i1 %21, label %25, label %22

22:                                               ; preds = %19
  %23 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %20
  store i32 0, ptr %23, align 4, !tbaa !3
  %24 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !10

25:                                               ; preds = %19, %28
  %26 = phi i32 [ %30, %28 ], [ 0, %19 ]
  %27 = icmp eq i32 %26, 5
  br i1 %27, label %31, label %28

28:                                               ; preds = %25
  %29 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %26
  store i32 0, ptr %29, align 4, !tbaa !3
  %30 = add nuw nsw i32 %26, 1
  br label %25, !llvm.loop !11

31:                                               ; preds = %25, %31
  %32 = phi i32 [ %36, %31 ], [ 0, %25 ]
  %33 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %32
  %34 = load i32, ptr %33, align 4, !tbaa !3
  %35 = icmp sgt i32 %34, -1
  %36 = add nuw nsw i32 %32, 1
  br i1 %35, label %31, label %37, !llvm.loop !12

37:                                               ; preds = %31, %42
  %38 = phi i32 [ %43, %42 ], [ 0, %31 ]
  %39 = icmp eq i32 %38, 5
  br i1 %39, label %40, label %42

40:                                               ; preds = %37
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %2) #8
  %41 = load i32, ptr @turn, align 4, !tbaa !3
  call void @numstr(ptr noundef nonnull %2, i32 noundef 2, i32 noundef %41) #6
  store i8 47, ptr %8, align 1, !tbaa !13
  store i8 49, ptr %9, align 1, !tbaa !13
  store i8 50, ptr %10, align 1, !tbaa !13
  store i8 0, ptr %11, align 1, !tbaa !13
  call void @gfx_text(i32 noundef 196, i32 noundef 4, ptr noundef nonnull %2, i16 noundef zeroext -12615, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %2) #8
  br label %44

42:                                               ; preds = %37
  call fastcc void @draw_die(i32 noundef %38, i32 noundef 0) #7
  %43 = add nuw nsw i32 %38, 1
  br label %37, !llvm.loop !14

44:                                               ; preds = %48, %40
  %45 = phi i32 [ 0, %40 ], [ %49, %48 ]
  %46 = icmp eq i32 %45, 12
  br i1 %46, label %47, label %48

47:                                               ; preds = %44
  call fastcc void @draw_total() #7
  call void @gfx_present() #6
  br label %266

48:                                               ; preds = %44
  call fastcc void @draw_cat(i32 noundef %45, i32 noundef 0) #7
  %49 = add nuw nsw i32 %45, 1
  br label %44, !llvm.loop !15

50:                                               ; preds = %206, %257
  %51 = phi i32 [ %258, %257 ], [ %207, %206 ]
  %52 = phi i32 [ %260, %257 ], [ %59, %206 ]
  %53 = phi i32 [ %261, %257 ], [ %100, %206 ]
  br i1 %272, label %54, label %273

54:                                               ; preds = %50
  call void @frame_sync(i32 noundef 33000) #6
  call void @in_poll() #6
  %55 = load i32, ptr @in_down, align 4, !tbaa !3
  %56 = and i32 %55, 16
  %57 = icmp eq i32 %56, 0
  %58 = add i32 %52, 1
  %59 = select i1 %57, i32 0, i32 %58
  %60 = icmp ugt i32 %59, 45
  br i1 %60, label %61, label %62

61:                                               ; preds = %54
  call void @uputs(ptr noundef nonnull @.str.2) #6
  br label %284

62:                                               ; preds = %54
  %63 = icmp eq i32 %51, 0
  %64 = load i32, ptr @in_edge, align 4, !tbaa !3
  br i1 %63, label %65, label %213

65:                                               ; preds = %62
  %66 = and i32 %64, 4
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %81, label %68

68:                                               ; preds = %65
  %69 = icmp eq i32 %53, 0
  %70 = add nsw i32 %53, -1
  %71 = select i1 %69, i32 5, i32 %70
  %72 = icmp eq i32 %53, 5
  br i1 %72, label %73, label %74

73:                                               ; preds = %68
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %75

74:                                               ; preds = %68
  call fastcc void @draw_die(i32 noundef %53, i32 noundef 0) #7
  br label %75

75:                                               ; preds = %74, %73
  %76 = icmp eq i32 %71, 5
  br i1 %76, label %77, label %78

77:                                               ; preds = %75
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %79

78:                                               ; preds = %75
  call fastcc void @draw_die(i32 noundef %71, i32 noundef 1) #7
  br label %79

79:                                               ; preds = %78, %77
  call void @gfx_present() #6
  %80 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %81

81:                                               ; preds = %79, %65
  %82 = phi i32 [ %80, %79 ], [ %64, %65 ]
  %83 = phi i32 [ %71, %79 ], [ %53, %65 ]
  %84 = and i32 %82, 8
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %98, label %86

86:                                               ; preds = %81
  %87 = icmp eq i32 %83, 5
  %88 = add nsw i32 %83, 1
  %89 = select i1 %87, i32 0, i32 %88
  br i1 %87, label %90, label %91

90:                                               ; preds = %86
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %92

91:                                               ; preds = %86
  call fastcc void @draw_die(i32 noundef %83, i32 noundef 0) #7
  br label %92

92:                                               ; preds = %91, %90
  %93 = icmp eq i32 %89, 5
  br i1 %93, label %94, label %95

94:                                               ; preds = %92
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %96

95:                                               ; preds = %92
  call fastcc void @draw_die(i32 noundef %89, i32 noundef 1) #7
  br label %96

96:                                               ; preds = %95, %94
  call void @gfx_present() #6
  %97 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %98

98:                                               ; preds = %96, %81
  %99 = phi i32 [ %97, %96 ], [ %82, %81 ]
  %100 = phi i32 [ %89, %96 ], [ %83, %81 ]
  %101 = and i32 %99, 16
  %102 = icmp eq i32 %101, 0
  br i1 %102, label %199, label %103

103:                                              ; preds = %98
  %104 = icmp slt i32 %100, 5
  br i1 %104, label %105, label %110

105:                                              ; preds = %103
  %106 = getelementptr inbounds [5 x i32], ptr @held, i32 0, i32 %100
  %107 = load i32, ptr %106, align 4, !tbaa !3
  %108 = icmp eq i32 %107, 0
  %109 = zext i1 %108 to i32
  store i32 %109, ptr %106, align 4, !tbaa !3
  call fastcc void @draw_die(i32 noundef %100, i32 noundef 1) #7
  call void @gfx_present() #6
  br label %199

110:                                              ; preds = %103
  %111 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %112 = icmp sgt i32 %111, 0
  br i1 %112, label %113, label %199

113:                                              ; preds = %110
  call void @led(i32 noundef 4144959, i32 noundef 4144959) #6
  br label %114

114:                                              ; preds = %125, %113
  %115 = phi i32 [ 0, %113 ], [ %126, %125 ]
  %116 = icmp eq i32 %115, 5
  br i1 %116, label %127, label %117

117:                                              ; preds = %114
  %118 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %115
  %119 = load i32, ptr %118, align 4, !tbaa !3
  %120 = icmp eq i32 %119, 0
  br i1 %120, label %121, label %125

121:                                              ; preds = %117
  %122 = call i32 @rng_below(i32 noundef 6) #6
  %123 = add nsw i32 %122, 1
  %124 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %115
  store i32 %123, ptr %124, align 4, !tbaa !3
  br label %125

125:                                              ; preds = %121, %117
  %126 = add nuw nsw i32 %115, 1
  br label %114, !llvm.loop !16

127:                                              ; preds = %114
  %128 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %129 = add nsw i32 %128, -1
  store i32 %129, ptr @rolls_left, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #8
  br label %130

130:                                              ; preds = %133, %127
  %131 = phi i32 [ 0, %127 ], [ %137, %133 ]
  %132 = icmp eq i32 %131, 5
  br i1 %132, label %138, label %133

133:                                              ; preds = %130
  %134 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %131
  %135 = load i32, ptr %134, align 4, !tbaa !3
  %136 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %131
  store i32 %135, ptr %136, align 4, !tbaa !3
  %137 = add nuw nsw i32 %131, 1
  br label %130, !llvm.loop !17

138:                                              ; preds = %130, %174
  %139 = phi i32 [ %176, %174 ], [ 0, %130 ]
  %140 = icmp eq i32 %139, 7
  br i1 %140, label %184, label %141

141:                                              ; preds = %138
  %142 = getelementptr inbounds nuw [7 x i8], ptr @roll_anim.pause, i32 0, i32 %139
  %143 = load i8, ptr %142, align 1, !tbaa !13
  %144 = zext i8 %143 to i32
  br label %145

145:                                              ; preds = %150, %141
  %146 = phi i32 [ %151, %150 ], [ 0, %141 ]
  %147 = icmp eq i32 %146, %144
  br i1 %147, label %148, label %150

148:                                              ; preds = %145
  %149 = icmp eq i32 %139, 6
  br label %152

150:                                              ; preds = %145
  call void @frame_sync(i32 noundef 33000) #6
  %151 = add nuw nsw i32 %146, 1
  br label %145, !llvm.loop !18

152:                                              ; preds = %169, %148
  %153 = phi i32 [ %170, %169 ], [ 0, %148 ]
  %154 = icmp eq i32 %153, 5
  br i1 %154, label %171, label %155

155:                                              ; preds = %152
  %156 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %153
  %157 = load i32, ptr %156, align 4, !tbaa !3
  %158 = icmp eq i32 %157, 0
  br i1 %158, label %159, label %169

159:                                              ; preds = %155
  br i1 %149, label %160, label %163

160:                                              ; preds = %159
  %161 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %153
  %162 = load i32, ptr %161, align 4, !tbaa !3
  br label %166

163:                                              ; preds = %159
  %164 = call i32 @rng_below(i32 noundef 6) #6
  %165 = add nsw i32 %164, 1
  br label %166

166:                                              ; preds = %163, %160
  %167 = phi i32 [ %162, %160 ], [ %165, %163 ]
  %168 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %153
  store i32 %167, ptr %168, align 4, !tbaa !3
  br label %169

169:                                              ; preds = %166, %155
  %170 = add nuw nsw i32 %153, 1
  br label %152, !llvm.loop !19

171:                                              ; preds = %152, %182
  %172 = phi i32 [ %183, %182 ], [ 0, %152 ]
  %173 = icmp eq i32 %172, 5
  br i1 %173, label %174, label %177

174:                                              ; preds = %171
  %175 = select i1 %149, i32 900, i32 1400
  call void @snd_play(i32 noundef %175, i32 noundef 25, i32 noundef 1) #6
  call void @gfx_present() #6
  %176 = add nuw nsw i32 %139, 1
  br label %138, !llvm.loop !20

177:                                              ; preds = %171
  %178 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %172
  %179 = load i32, ptr %178, align 4, !tbaa !3
  %180 = icmp eq i32 %179, 0
  br i1 %180, label %181, label %182

181:                                              ; preds = %177
  call fastcc void @draw_die(i32 noundef %172, i32 noundef 0) #7
  br label %182

182:                                              ; preds = %181, %177
  %183 = add nuw nsw i32 %172, 1
  br label %171, !llvm.loop !21

184:                                              ; preds = %138, %187
  %185 = phi i32 [ %191, %187 ], [ 0, %138 ]
  %186 = icmp eq i32 %185, 5
  br i1 %186, label %192, label %187

187:                                              ; preds = %184
  %188 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %185
  %189 = load i32, ptr %188, align 4, !tbaa !3
  %190 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %185
  store i32 %189, ptr %190, align 4, !tbaa !3
  %191 = add nuw nsw i32 %185, 1
  br label %184, !llvm.loop !22

192:                                              ; preds = %184
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #8
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %193

193:                                              ; preds = %197, %192
  %194 = phi i32 [ 0, %192 ], [ %198, %197 ]
  %195 = icmp eq i32 %194, 12
  br i1 %195, label %196, label %197

196:                                              ; preds = %193
  call void @gfx_present() #6
  call void @uputs(ptr noundef nonnull @.str.3) #6
  br label %199

197:                                              ; preds = %193
  call fastcc void @draw_cat(i32 noundef %194, i32 noundef 0) #7
  %198 = add nuw nsw i32 %194, 1
  br label %193, !llvm.loop !23

199:                                              ; preds = %105, %196, %110, %98
  %200 = load i32, ptr @in_edge, align 4, !tbaa !3
  %201 = and i32 %200, 3
  %202 = icmp ne i32 %201, 0
  %203 = load i32, ptr @rolls_left, align 4
  %204 = icmp slt i32 %203, 3
  %205 = select i1 %202, i1 %204, i1 false
  br i1 %205, label %208, label %206

206:                                              ; preds = %199, %212
  %207 = phi i32 [ 1, %212 ], [ 0, %199 ]
  br label %50, !llvm.loop !24

208:                                              ; preds = %199
  %209 = icmp eq i32 %100, 5
  br i1 %209, label %210, label %211

210:                                              ; preds = %208
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %212

211:                                              ; preds = %208
  call fastcc void @draw_die(i32 noundef %100, i32 noundef 0) #7
  br label %212

212:                                              ; preds = %211, %210
  call fastcc void @draw_cat(i32 noundef %259, i32 noundef 1) #7
  call void @gfx_present() #6
  br label %206

213:                                              ; preds = %62
  %214 = and i32 %64, 12
  %215 = icmp eq i32 %214, 0
  br i1 %215, label %222, label %216

216:                                              ; preds = %213
  call fastcc void @draw_cat(i32 noundef %259, i32 noundef 0) #7
  %217 = icmp eq i32 %53, 5
  br i1 %217, label %218, label %219

218:                                              ; preds = %216
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %220

219:                                              ; preds = %216
  call fastcc void @draw_die(i32 noundef %53, i32 noundef 1) #7
  br label %220

220:                                              ; preds = %219, %218
  call void @gfx_present() #6
  %221 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %222

222:                                              ; preds = %220, %213
  %223 = phi i32 [ %221, %220 ], [ %64, %213 ]
  %224 = phi i32 [ 0, %220 ], [ 1, %213 ]
  %225 = and i32 %223, 1
  %226 = icmp eq i32 %225, 0
  br i1 %226, label %237, label %227

227:                                              ; preds = %222, %227
  %228 = phi i32 [ %231, %227 ], [ %259, %222 ]
  %229 = icmp eq i32 %228, 0
  %230 = add nsw i32 %228, -1
  %231 = select i1 %229, i32 11, i32 %230
  %232 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %231
  %233 = load i32, ptr %232, align 4, !tbaa !3
  %234 = icmp sgt i32 %233, -1
  br i1 %234, label %227, label %235, !llvm.loop !25

235:                                              ; preds = %227
  call fastcc void @draw_cat(i32 noundef %259, i32 noundef 0) #7
  call fastcc void @draw_cat(i32 noundef %231, i32 noundef 1) #7
  call void @gfx_present() #6
  %236 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %237

237:                                              ; preds = %235, %222
  %238 = phi i32 [ %236, %235 ], [ %223, %222 ]
  %239 = phi i32 [ %231, %235 ], [ %259, %222 ]
  %240 = and i32 %238, 2
  %241 = icmp eq i32 %240, 0
  br i1 %241, label %252, label %242

242:                                              ; preds = %237, %242
  %243 = phi i32 [ %246, %242 ], [ %239, %237 ]
  %244 = icmp eq i32 %243, 11
  %245 = add nsw i32 %243, 1
  %246 = select i1 %244, i32 0, i32 %245
  %247 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %246
  %248 = load i32, ptr %247, align 4, !tbaa !3
  %249 = icmp sgt i32 %248, -1
  br i1 %249, label %242, label %250, !llvm.loop !26

250:                                              ; preds = %242
  call fastcc void @draw_cat(i32 noundef %239, i32 noundef 0) #7
  call fastcc void @draw_cat(i32 noundef %246, i32 noundef 1) #7
  call void @gfx_present() #6
  %251 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %252

252:                                              ; preds = %250, %237
  %253 = phi i32 [ %251, %250 ], [ %238, %237 ]
  %254 = phi i32 [ %246, %250 ], [ %239, %237 ]
  %255 = and i32 %253, 16
  %256 = icmp eq i32 %255, 0
  br i1 %256, label %257, label %262, !llvm.loop !24

257:                                              ; preds = %266, %252
  %258 = phi i32 [ %224, %252 ], [ %267, %266 ]
  %259 = phi i32 [ %254, %252 ], [ %268, %266 ]
  %260 = phi i32 [ %59, %252 ], [ %270, %266 ]
  %261 = phi i32 [ %53, %252 ], [ %271, %266 ]
  br label %50

262:                                              ; preds = %252
  call void @snd_play(i32 noundef 800, i32 noundef 45, i32 noundef 4) #6
  %263 = call fastcc i32 @cat_score(i32 noundef %254) #7
  %264 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %254
  store i32 %263, ptr %264, align 4, !tbaa !3
  call void @uputs(ptr noundef nonnull @.str.4) #6
  call void @uputn(i32 noundef %254) #6
  call void @uputs(ptr noundef nonnull @.str.5) #6
  %265 = load i32, ptr %264, align 4, !tbaa !3
  call void @uputn(i32 noundef %265) #6
  call void @uputs(ptr noundef nonnull @.str.6) #6
  br label %266, !llvm.loop !24

266:                                              ; preds = %47, %262
  %267 = phi i32 [ 0, %47 ], [ %224, %262 ]
  %268 = phi i32 [ %32, %47 ], [ %254, %262 ]
  %269 = phi i32 [ -1, %47 ], [ %254, %262 ]
  %270 = phi i32 [ 0, %47 ], [ %59, %262 ]
  %271 = phi i32 [ 5, %47 ], [ %53, %262 ]
  %272 = icmp slt i32 %269, 0
  br label %257

273:                                              ; preds = %50
  call fastcc void @draw_cat(i32 noundef %269, i32 noundef 0) #7
  call fastcc void @draw_total() #7
  call void @gfx_present() #6
  %274 = load i32, ptr @turn, align 4, !tbaa !3
  %275 = icmp eq i32 %274, 12
  br i1 %275, label %276, label %16

276:                                              ; preds = %273
  call void @gfx_fill(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i16 noundef zeroext 2532) #6
  call void @gfx_rect(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i32 noundef 2, i16 noundef zeroext -377) #6
  call void @gfx_text2(i32 noundef 52, i32 noundef 104, ptr noundef nonnull @.str.7, i16 noundef zeroext -377, i16 noundef zeroext 2532) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #8
  %277 = call fastcc i32 @total() #7
  call void @numsp(ptr noundef nonnull %3, i32 noundef 3, i32 noundef %277) #6
  call void @gfx_text(i32 noundef 76, i32 noundef 124, ptr noundef nonnull @.str.8, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 124, i32 noundef 124, ptr noundef nonnull %3, i16 noundef zeroext -1, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 74, i32 noundef 136, ptr noundef nonnull @.str.9, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_present() #6
  call void @snd_play(i32 noundef 990, i32 noundef 60, i32 noundef 30) #6
  call void @led(i32 noundef 540424, i32 noundef 540424) #6
  call void @uputs(ptr noundef nonnull @.str.10) #6
  %278 = call fastcc i32 @total() #7
  call void @uputn(i32 noundef %278) #6
  call void @uputs(ptr noundef nonnull @.str.6) #6
  br label %279

279:                                              ; preds = %279, %276
  call void @frame_sync(i32 noundef 33000) #6
  call void @in_poll() #6
  %280 = load i32, ptr @in_edge, align 4, !tbaa !3
  %281 = and i32 %280, 16
  %282 = icmp eq i32 %281, 0
  br i1 %282, label %279, label %283, !llvm.loop !27

283:                                              ; preds = %279
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #8
  br label %284

284:                                              ; preds = %61, %283
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_die(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = mul nsw i32 %0, 34
  %4 = add nsw i32 %3, 6
  %5 = add nsw i32 %3, 4
  tail call void @gfx_fill(i32 noundef %5, i32 noundef 16, i32 noundef 32, i32 noundef 40, i16 noundef zeroext 2371) #6
  tail call void @gfx_fill(i32 noundef %4, i32 noundef 18, i32 noundef 28, i32 noundef 28, i16 noundef zeroext -2115) #6
  tail call void @gfx_rect(i32 noundef %4, i32 noundef 18, i32 noundef 28, i32 noundef 28, i32 noundef 1, i16 noundef zeroext 4259) #6
  %6 = getelementptr inbounds [5 x i32], ptr @dice, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !3
  %8 = getelementptr inbounds [7 x i16], ptr @pips, i32 0, i32 %7
  %9 = load i16, ptr %8, align 2, !tbaa !28
  %10 = zext i16 %9 to i32
  %11 = add nsw i32 %3, 10
  br label %12

12:                                               ; preds = %35, %2
  %13 = phi i32 [ 0, %2 ], [ %36, %35 ]
  %14 = icmp eq i32 %13, 9
  br i1 %14, label %15, label %19

15:                                               ; preds = %12
  %16 = getelementptr inbounds [5 x i32], ptr @held, i32 0, i32 %0
  %17 = load i32, ptr %16, align 4, !tbaa !3
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %39, label %37

19:                                               ; preds = %12
  %20 = shl nuw nsw i32 1, %13
  %21 = and i32 %20, %10
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %35, label %23

23:                                               ; preds = %19
  %24 = trunc nuw i32 %13 to i8
  %25 = freeze i8 %24
  %26 = udiv i8 %25, 3
  %27 = mul i8 %26, 3
  %28 = sub i8 %25, %27
  %29 = shl nuw nsw i8 %28, 3
  %30 = zext nneg i8 %29 to i32
  %31 = add nsw i32 %11, %30
  %32 = shl nuw nsw i8 %26, 3
  %33 = add nuw nsw i8 %32, 22
  %34 = zext nneg i8 %33 to i32
  tail call void @gfx_fill(i32 noundef %31, i32 noundef %34, i32 noundef 4, i32 noundef 4, i16 noundef zeroext 4259) #6
  br label %35

35:                                               ; preds = %19, %23
  %36 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !30

37:                                               ; preds = %15
  %38 = add nsw i32 %3, 8
  tail call void @gfx_fill(i32 noundef %38, i32 noundef 49, i32 noundef 24, i32 noundef 4, i16 noundef zeroext -377) #6
  br label %39

39:                                               ; preds = %37, %15
  %40 = icmp eq i32 %1, 0
  br i1 %40, label %42, label %41

41:                                               ; preds = %39
  tail call void @gfx_rect(i32 noundef %5, i32 noundef 16, i32 noundef 32, i32 noundef 40, i32 noundef 2, i16 noundef zeroext -1337) #6
  br label %42

42:                                               ; preds = %41, %39
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_roll_btn(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = alloca [2 x i8], align 1
  tail call void @gfx_fill(i32 noundef 176, i32 noundef 16, i32 noundef 58, i32 noundef 40, i16 noundef zeroext 2371) #6
  %3 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i16 2371, i16 2532
  tail call void @gfx_fill(i32 noundef 178, i32 noundef 18, i32 noundef 54, i32 noundef 22, i16 noundef zeroext %5) #6
  %6 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %7, i16 27662, i16 -12615
  tail call void @gfx_rect(i32 noundef 178, i32 noundef 18, i32 noundef 54, i32 noundef 22, i32 noundef 1, i16 noundef zeroext %8) #6
  %9 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  %11 = select i1 %10, i16 27662, i16 -1
  %12 = select i1 %10, i16 2371, i16 2532
  tail call void @gfx_text(i32 noundef 189, i32 noundef 25, ptr noundef nonnull @.str.11, i16 noundef zeroext %11, i16 noundef zeroext %12) #6
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %2) #8
  %13 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %14 = trunc i32 %13 to i8
  %15 = add i8 %14, 48
  store i8 %15, ptr %2, align 1, !tbaa !13
  %16 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 0, ptr %16, align 1, !tbaa !13
  call void @gfx_text(i32 noundef 202, i32 noundef 44, ptr noundef nonnull %2, i16 noundef zeroext 27662, i16 noundef zeroext 2371) #6
  %17 = icmp eq i32 %0, 0
  br i1 %17, label %19, label %18

18:                                               ; preds = %1
  call void @gfx_rect(i32 noundef 176, i32 noundef 16, i32 noundef 58, i32 noundef 40, i32 noundef 2, i16 noundef zeroext -1337) #6
  br label %19

19:                                               ; preds = %18, %1
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %2) #8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_cat(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = alloca [4 x i8], align 1
  %4 = mul nsw i32 %0, 12
  %5 = add nsw i32 %4, 66
  %6 = add nsw i32 %4, 65
  %7 = icmp eq i32 %1, 0
  %8 = select i1 %7, i16 2371, i16 2532
  tail call void @gfx_fill(i32 noundef 4, i32 noundef %6, i32 noundef 232, i32 noundef 11, i16 noundef zeroext %8) #6
  %9 = getelementptr inbounds [12 x ptr], ptr @catname, i32 0, i32 %0
  %10 = load ptr, ptr %9, align 4, !tbaa !31
  %11 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %0
  %12 = load i32, ptr %11, align 4, !tbaa !3
  %13 = icmp sgt i32 %12, -1
  %14 = select i1 %13, i16 27662, i16 -12615
  tail call void @gfx_text(i32 noundef 10, i32 noundef %5, ptr noundef %10, i16 noundef zeroext %14, i16 noundef zeroext %8) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #8
  %15 = load i32, ptr %11, align 4, !tbaa !3
  %16 = icmp sgt i32 %15, -1
  br i1 %16, label %22, label %17

17:                                               ; preds = %2
  %18 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %19 = icmp slt i32 %18, 3
  br i1 %19, label %20, label %25

20:                                               ; preds = %17
  %21 = tail call fastcc i32 @cat_score(i32 noundef %0) #7
  br label %22

22:                                               ; preds = %2, %20
  %23 = phi i32 [ %21, %20 ], [ %15, %2 ]
  %24 = phi i16 [ 32500, %20 ], [ -1, %2 ]
  call void @numsp(ptr noundef nonnull %3, i32 noundef 3, i32 noundef %23) #6
  call void @gfx_text(i32 noundef 200, i32 noundef %5, ptr noundef nonnull %3, i16 noundef zeroext %24, i16 noundef zeroext %8) #6
  br label %25

25:                                               ; preds = %22, %17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_total() unnamed_addr #0 {
  %1 = alloca [4 x i8], align 1
  tail call void @gfx_fill(i32 noundef 4, i32 noundef 212, i32 noundef 232, i32 noundef 20, i16 noundef zeroext 2371) #6
  tail call void @gfx_text(i32 noundef 10, i32 noundef 218, ptr noundef nonnull @.str.24, i16 noundef zeroext -12615, i16 noundef zeroext 2371) #6
  tail call void @gfx_text(i32 noundef 64, i32 noundef 218, ptr noundef nonnull @.str.25, i16 noundef zeroext 27662, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #8
  %2 = tail call fastcc i32 @total() #7
  call void @numsp(ptr noundef nonnull %1, i32 noundef 3, i32 noundef %2) #6
  call void @gfx_text(i32 noundef 200, i32 noundef 218, ptr noundef nonnull %1, i16 noundef zeroext -1, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #8
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

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @cat_score(i32 noundef %0) unnamed_addr #3 {
  %2 = alloca [7 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 28, ptr nonnull %2) #8
  call void @llvm.memset.p0.i32(ptr noundef nonnull align 4 dereferenceable(28) %2, i8 0, i32 28, i1 false)
  br label %3

3:                                                ; preds = %15, %1
  %4 = phi i32 [ 0, %1 ], [ %21, %15 ]
  %5 = phi i32 [ 0, %1 ], [ %22, %15 ]
  %6 = icmp eq i32 %5, 5
  br i1 %6, label %7, label %15

7:                                                ; preds = %3
  %8 = icmp slt i32 %0, 6
  br i1 %8, label %9, label %23

9:                                                ; preds = %7
  %10 = add nsw i32 %0, 1
  %11 = getelementptr inbounds [7 x i32], ptr %2, i32 0, i32 %10
  %12 = load i32, ptr %11, align 4, !tbaa !3
  %13 = tail call i32 @llvm.smax.i32(i32 %12, i32 0)
  %14 = mul i32 %13, %10
  br label %98

15:                                               ; preds = %3
  %16 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %5
  %17 = load i32, ptr %16, align 4, !tbaa !3
  %18 = getelementptr inbounds [7 x i32], ptr %2, i32 0, i32 %17
  %19 = load i32, ptr %18, align 4, !tbaa !3
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr %18, align 4, !tbaa !3
  %21 = add nsw i32 %17, %4
  %22 = add nuw nsw i32 %5, 1
  br label %3, !llvm.loop !34

23:                                               ; preds = %7
  switch i32 %0, label %90 [
    i32 6, label %98
    i32 7, label %24
    i32 8, label %35
    i32 9, label %54
    i32 10, label %72
  ]

24:                                               ; preds = %23, %33
  %25 = phi i32 [ %34, %33 ], [ 1, %23 ]
  %26 = icmp eq i32 %25, 7
  br i1 %26, label %98, label %27

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %25
  %29 = load i32, ptr %28, align 4, !tbaa !3
  %30 = icmp sgt i32 %29, 3
  br i1 %30, label %31, label %33

31:                                               ; preds = %27
  %32 = shl nuw nsw i32 %25, 2
  br label %98

33:                                               ; preds = %27
  %34 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !35

35:                                               ; preds = %23, %50
  %36 = phi i32 [ %51, %50 ], [ 0, %23 ]
  %37 = phi i32 [ %52, %50 ], [ 0, %23 ]
  %38 = phi i32 [ %53, %50 ], [ 1, %23 ]
  %39 = icmp eq i32 %38, 7
  br i1 %39, label %40, label %45

40:                                               ; preds = %35
  %41 = icmp ne i32 %36, 0
  %42 = icmp ne i32 %37, 0
  %43 = select i1 %41, i1 %42, i1 false
  %44 = select i1 %43, i32 %4, i32 0
  br label %98

45:                                               ; preds = %35
  %46 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %38
  %47 = load i32, ptr %46, align 4, !tbaa !3
  switch i32 %47, label %49 [
    i32 3, label %50
    i32 2, label %48
  ]

48:                                               ; preds = %45
  br label %50

49:                                               ; preds = %45
  br label %50

50:                                               ; preds = %45, %49, %48
  %51 = phi i32 [ %36, %48 ], [ 1, %45 ], [ %36, %49 ]
  %52 = phi i32 [ 1, %48 ], [ %37, %45 ], [ %37, %49 ]
  %53 = add nuw nsw i32 %38, 1
  br label %35, !llvm.loop !36

54:                                               ; preds = %23, %62
  %55 = phi i32 [ %65, %62 ], [ 5, %23 ]
  %56 = phi i32 [ %64, %62 ], [ 1, %23 ]
  %57 = icmp eq i32 %55, 8
  br i1 %57, label %98, label %58

58:                                               ; preds = %54, %66
  %59 = phi i32 [ %70, %66 ], [ 1, %54 ]
  %60 = phi i32 [ %71, %66 ], [ %56, %54 ]
  %61 = icmp eq i32 %60, %55
  br i1 %61, label %62, label %66

62:                                               ; preds = %58
  %63 = icmp eq i32 %59, 0
  %64 = add nuw nsw i32 %56, 1
  %65 = add nuw nsw i32 %55, 1
  br i1 %63, label %54, label %98, !llvm.loop !37

66:                                               ; preds = %58
  %67 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %60
  %68 = load i32, ptr %67, align 4, !tbaa !3
  %69 = icmp eq i32 %68, 0
  %70 = select i1 %69, i32 0, i32 %59
  %71 = add nuw nsw i32 %60, 1
  br label %58, !llvm.loop !38

72:                                               ; preds = %23, %80
  %73 = phi i32 [ %83, %80 ], [ 6, %23 ]
  %74 = phi i32 [ %82, %80 ], [ 1, %23 ]
  %75 = icmp eq i32 %73, 8
  br i1 %75, label %98, label %76

76:                                               ; preds = %72, %84
  %77 = phi i32 [ %88, %84 ], [ 1, %72 ]
  %78 = phi i32 [ %89, %84 ], [ %74, %72 ]
  %79 = icmp eq i32 %78, %73
  br i1 %79, label %80, label %84

80:                                               ; preds = %76
  %81 = icmp eq i32 %77, 0
  %82 = add nuw nsw i32 %74, 1
  %83 = add nuw nsw i32 %73, 1
  br i1 %81, label %72, label %98, !llvm.loop !39

84:                                               ; preds = %76
  %85 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %78
  %86 = load i32, ptr %85, align 4, !tbaa !3
  %87 = icmp eq i32 %86, 0
  %88 = select i1 %87, i32 0, i32 %77
  %89 = add nuw nsw i32 %78, 1
  br label %76, !llvm.loop !40

90:                                               ; preds = %23, %93
  %91 = phi i32 [ %97, %93 ], [ 1, %23 ]
  %92 = icmp eq i32 %91, 7
  br i1 %92, label %98, label %93

93:                                               ; preds = %90
  %94 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %91
  %95 = load i32, ptr %94, align 4, !tbaa !3
  %96 = icmp eq i32 %95, 5
  %97 = add nuw nsw i32 %91, 1
  br i1 %96, label %98, label %90, !llvm.loop !41

98:                                               ; preds = %80, %72, %62, %54, %24, %90, %93, %9, %31, %23, %40
  %99 = phi i32 [ %44, %40 ], [ %4, %23 ], [ %32, %31 ], [ %14, %9 ], [ 0, %90 ], [ 50, %93 ], [ 0, %24 ], [ 30, %62 ], [ 0, %54 ], [ 30, %80 ], [ 0, %72 ]
  call void @llvm.lifetime.end.p0(i64 28, ptr nonnull %2) #8
  ret i32 %99
}

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numsp(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc range(i32 0, -2147483648) i32 @total() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %6, %0
  %2 = phi i32 [ 0, %0 ], [ %10, %6 ]
  %3 = phi i32 [ 0, %0 ], [ %11, %6 ]
  %4 = icmp eq i32 %3, 12
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  ret i32 %2

6:                                                ; preds = %1
  %7 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %3
  %8 = load i32, ptr %7, align 4, !tbaa !3
  %9 = tail call i32 @llvm.smax.i32(i32 %8, i32 0)
  %10 = add nuw nsw i32 %9, %2
  %11 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !42
}

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i32(ptr writeonly captures(none), i8, i32, i1 immarg) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { minsize nobuiltin optsize "no-builtins" }
attributes #8 = { nounwind }

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
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = !{!5, !5, i64 0}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !9}
!28 = !{!29, !29, i64 0}
!29 = !{!"short", !5, i64 0}
!30 = distinct !{!30, !8, !9}
!31 = !{!32, !32, i64 0}
!32 = !{!"p1 omnipotent char", !33, i64 0}
!33 = !{!"any pointer", !5, i64 0}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !8, !9}
!37 = distinct !{!37, !8, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
!40 = distinct !{!40, !8, !9}
!41 = distinct !{!41, !8, !9}
!42 = distinct !{!42, !8, !9}
