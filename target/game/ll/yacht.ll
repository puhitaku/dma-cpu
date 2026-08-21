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

16:                                               ; preds = %276, %7
  %17 = phi i32 [ %277, %276 ], [ %12, %7 ]
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
  br label %269

48:                                               ; preds = %44
  call fastcc void @draw_cat(i32 noundef %45, i32 noundef 0) #7
  %49 = add nuw nsw i32 %45, 1
  br label %44, !llvm.loop !15

50:                                               ; preds = %209, %260
  %51 = phi i32 [ %261, %260 ], [ %210, %209 ]
  %52 = phi i32 [ %263, %260 ], [ %59, %209 ]
  %53 = phi i32 [ %264, %260 ], [ %100, %209 ]
  br i1 %275, label %54, label %276

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
  br label %287

62:                                               ; preds = %54
  %63 = icmp eq i32 %51, 0
  %64 = load i32, ptr @in_edge, align 4, !tbaa !3
  br i1 %63, label %65, label %216

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
  br i1 %102, label %202, label %103

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
  br label %202

110:                                              ; preds = %103
  %111 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %112 = icmp sgt i32 %111, 0
  br i1 %112, label %113, label %202

113:                                              ; preds = %110, %124
  %114 = phi i32 [ %125, %124 ], [ 0, %110 ]
  %115 = icmp eq i32 %114, 5
  br i1 %115, label %126, label %116

116:                                              ; preds = %113
  %117 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %114
  %118 = load i32, ptr %117, align 4, !tbaa !3
  %119 = icmp eq i32 %118, 0
  br i1 %119, label %120, label %124

120:                                              ; preds = %116
  %121 = call i32 @rng_below(i32 noundef 6) #6
  %122 = add nsw i32 %121, 1
  %123 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %114
  store i32 %122, ptr %123, align 4, !tbaa !3
  br label %124

124:                                              ; preds = %120, %116
  %125 = add nuw nsw i32 %114, 1
  br label %113, !llvm.loop !16

126:                                              ; preds = %113
  %127 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %128 = add nsw i32 %127, -1
  store i32 %128, ptr @rolls_left, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #8
  br label %129

129:                                              ; preds = %132, %126
  %130 = phi i32 [ 0, %126 ], [ %136, %132 ]
  %131 = icmp eq i32 %130, 5
  br i1 %131, label %137, label %132

132:                                              ; preds = %129
  %133 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %130
  %134 = load i32, ptr %133, align 4, !tbaa !3
  %135 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %130
  store i32 %134, ptr %135, align 4, !tbaa !3
  %136 = add nuw nsw i32 %130, 1
  br label %129, !llvm.loop !17

137:                                              ; preds = %129, %177
  %138 = phi i32 [ %179, %177 ], [ 0, %129 ]
  %139 = icmp eq i32 %138, 7
  br i1 %139, label %144, label %140

140:                                              ; preds = %137
  %141 = getelementptr inbounds nuw [7 x i8], ptr @roll_anim.pause, i32 0, i32 %138
  %142 = load i8, ptr %141, align 1, !tbaa !13
  %143 = zext i8 %142 to i32
  br label %145

144:                                              ; preds = %137
  call void @frame_sync(i32 noundef 33000) #6
  call void @led(i32 noundef 0, i32 noundef 0) #6
  br label %187

145:                                              ; preds = %153, %140
  %146 = phi i32 [ %154, %153 ], [ 0, %140 ]
  %147 = icmp eq i32 %146, %143
  br i1 %147, label %148, label %150

148:                                              ; preds = %145
  %149 = icmp eq i32 %138, 6
  br label %155

150:                                              ; preds = %145
  call void @frame_sync(i32 noundef 33000) #6
  %151 = icmp eq i32 %146, 0
  br i1 %151, label %152, label %153

152:                                              ; preds = %150
  call void @led(i32 noundef 0, i32 noundef 0) #6
  br label %153

153:                                              ; preds = %152, %150
  %154 = add nuw nsw i32 %146, 1
  br label %145, !llvm.loop !18

155:                                              ; preds = %172, %148
  %156 = phi i32 [ %173, %172 ], [ 0, %148 ]
  %157 = icmp eq i32 %156, 5
  br i1 %157, label %174, label %158

158:                                              ; preds = %155
  %159 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %156
  %160 = load i32, ptr %159, align 4, !tbaa !3
  %161 = icmp eq i32 %160, 0
  br i1 %161, label %162, label %172

162:                                              ; preds = %158
  br i1 %149, label %163, label %166

163:                                              ; preds = %162
  %164 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %156
  %165 = load i32, ptr %164, align 4, !tbaa !3
  br label %169

166:                                              ; preds = %162
  %167 = call i32 @rng_below(i32 noundef 6) #6
  %168 = add nsw i32 %167, 1
  br label %169

169:                                              ; preds = %166, %163
  %170 = phi i32 [ %165, %163 ], [ %168, %166 ]
  %171 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %156
  store i32 %170, ptr %171, align 4, !tbaa !3
  br label %172

172:                                              ; preds = %169, %158
  %173 = add nuw nsw i32 %156, 1
  br label %155, !llvm.loop !19

174:                                              ; preds = %155, %185
  %175 = phi i32 [ %186, %185 ], [ 0, %155 ]
  %176 = icmp eq i32 %175, 5
  br i1 %176, label %177, label %180

177:                                              ; preds = %174
  %178 = select i1 %149, i32 900, i32 1400
  call void @snd_play(i32 noundef %178, i32 noundef 25, i32 noundef 1) #6
  call void @led(i32 noundef 986895, i32 noundef 986895) #6
  call void @gfx_present() #6
  %179 = add nuw nsw i32 %138, 1
  br label %137, !llvm.loop !20

180:                                              ; preds = %174
  %181 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %175
  %182 = load i32, ptr %181, align 4, !tbaa !3
  %183 = icmp eq i32 %182, 0
  br i1 %183, label %184, label %185

184:                                              ; preds = %180
  call fastcc void @draw_die(i32 noundef %175, i32 noundef 0) #7
  br label %185

185:                                              ; preds = %184, %180
  %186 = add nuw nsw i32 %175, 1
  br label %174, !llvm.loop !21

187:                                              ; preds = %190, %144
  %188 = phi i32 [ 0, %144 ], [ %194, %190 ]
  %189 = icmp eq i32 %188, 5
  br i1 %189, label %195, label %190

190:                                              ; preds = %187
  %191 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %188
  %192 = load i32, ptr %191, align 4, !tbaa !3
  %193 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %188
  store i32 %192, ptr %193, align 4, !tbaa !3
  %194 = add nuw nsw i32 %188, 1
  br label %187, !llvm.loop !22

195:                                              ; preds = %187
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #8
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %196

196:                                              ; preds = %200, %195
  %197 = phi i32 [ 0, %195 ], [ %201, %200 ]
  %198 = icmp eq i32 %197, 12
  br i1 %198, label %199, label %200

199:                                              ; preds = %196
  call void @gfx_present() #6
  call void @uputs(ptr noundef nonnull @.str.3) #6
  br label %202

200:                                              ; preds = %196
  call fastcc void @draw_cat(i32 noundef %197, i32 noundef 0) #7
  %201 = add nuw nsw i32 %197, 1
  br label %196, !llvm.loop !23

202:                                              ; preds = %105, %199, %110, %98
  %203 = load i32, ptr @in_edge, align 4, !tbaa !3
  %204 = and i32 %203, 3
  %205 = icmp ne i32 %204, 0
  %206 = load i32, ptr @rolls_left, align 4
  %207 = icmp slt i32 %206, 3
  %208 = select i1 %205, i1 %207, i1 false
  br i1 %208, label %211, label %209

209:                                              ; preds = %202, %215
  %210 = phi i32 [ 1, %215 ], [ 0, %202 ]
  br label %50, !llvm.loop !24

211:                                              ; preds = %202
  %212 = icmp eq i32 %100, 5
  br i1 %212, label %213, label %214

213:                                              ; preds = %211
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %215

214:                                              ; preds = %211
  call fastcc void @draw_die(i32 noundef %100, i32 noundef 0) #7
  br label %215

215:                                              ; preds = %214, %213
  call fastcc void @draw_cat(i32 noundef %262, i32 noundef 1) #7
  call void @gfx_present() #6
  br label %209

216:                                              ; preds = %62
  %217 = and i32 %64, 12
  %218 = icmp eq i32 %217, 0
  br i1 %218, label %225, label %219

219:                                              ; preds = %216
  call fastcc void @draw_cat(i32 noundef %262, i32 noundef 0) #7
  %220 = icmp eq i32 %53, 5
  br i1 %220, label %221, label %222

221:                                              ; preds = %219
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %223

222:                                              ; preds = %219
  call fastcc void @draw_die(i32 noundef %53, i32 noundef 1) #7
  br label %223

223:                                              ; preds = %222, %221
  call void @gfx_present() #6
  %224 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %225

225:                                              ; preds = %223, %216
  %226 = phi i32 [ %224, %223 ], [ %64, %216 ]
  %227 = phi i32 [ 0, %223 ], [ 1, %216 ]
  %228 = and i32 %226, 1
  %229 = icmp eq i32 %228, 0
  br i1 %229, label %240, label %230

230:                                              ; preds = %225, %230
  %231 = phi i32 [ %234, %230 ], [ %262, %225 ]
  %232 = icmp eq i32 %231, 0
  %233 = add nsw i32 %231, -1
  %234 = select i1 %232, i32 11, i32 %233
  %235 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %234
  %236 = load i32, ptr %235, align 4, !tbaa !3
  %237 = icmp sgt i32 %236, -1
  br i1 %237, label %230, label %238, !llvm.loop !25

238:                                              ; preds = %230
  call fastcc void @draw_cat(i32 noundef %262, i32 noundef 0) #7
  call fastcc void @draw_cat(i32 noundef %234, i32 noundef 1) #7
  call void @gfx_present() #6
  %239 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %240

240:                                              ; preds = %238, %225
  %241 = phi i32 [ %239, %238 ], [ %226, %225 ]
  %242 = phi i32 [ %234, %238 ], [ %262, %225 ]
  %243 = and i32 %241, 2
  %244 = icmp eq i32 %243, 0
  br i1 %244, label %255, label %245

245:                                              ; preds = %240, %245
  %246 = phi i32 [ %249, %245 ], [ %242, %240 ]
  %247 = icmp eq i32 %246, 11
  %248 = add nsw i32 %246, 1
  %249 = select i1 %247, i32 0, i32 %248
  %250 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %249
  %251 = load i32, ptr %250, align 4, !tbaa !3
  %252 = icmp sgt i32 %251, -1
  br i1 %252, label %245, label %253, !llvm.loop !26

253:                                              ; preds = %245
  call fastcc void @draw_cat(i32 noundef %242, i32 noundef 0) #7
  call fastcc void @draw_cat(i32 noundef %249, i32 noundef 1) #7
  call void @gfx_present() #6
  %254 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %255

255:                                              ; preds = %253, %240
  %256 = phi i32 [ %254, %253 ], [ %241, %240 ]
  %257 = phi i32 [ %249, %253 ], [ %242, %240 ]
  %258 = and i32 %256, 16
  %259 = icmp eq i32 %258, 0
  br i1 %259, label %260, label %265, !llvm.loop !24

260:                                              ; preds = %269, %255
  %261 = phi i32 [ %227, %255 ], [ %270, %269 ]
  %262 = phi i32 [ %257, %255 ], [ %271, %269 ]
  %263 = phi i32 [ %59, %255 ], [ %273, %269 ]
  %264 = phi i32 [ %53, %255 ], [ %274, %269 ]
  br label %50

265:                                              ; preds = %255
  call void @snd_play(i32 noundef 800, i32 noundef 45, i32 noundef 4) #6
  %266 = call fastcc i32 @cat_score(i32 noundef %257) #7
  %267 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %257
  store i32 %266, ptr %267, align 4, !tbaa !3
  call void @uputs(ptr noundef nonnull @.str.4) #6
  call void @uputn(i32 noundef %257) #6
  call void @uputs(ptr noundef nonnull @.str.5) #6
  %268 = load i32, ptr %267, align 4, !tbaa !3
  call void @uputn(i32 noundef %268) #6
  call void @uputs(ptr noundef nonnull @.str.6) #6
  br label %269, !llvm.loop !24

269:                                              ; preds = %47, %265
  %270 = phi i32 [ 0, %47 ], [ %227, %265 ]
  %271 = phi i32 [ %32, %47 ], [ %257, %265 ]
  %272 = phi i32 [ -1, %47 ], [ %257, %265 ]
  %273 = phi i32 [ 0, %47 ], [ %59, %265 ]
  %274 = phi i32 [ 5, %47 ], [ %53, %265 ]
  %275 = icmp slt i32 %272, 0
  br label %260

276:                                              ; preds = %50
  call fastcc void @draw_cat(i32 noundef %272, i32 noundef 0) #7
  call fastcc void @draw_total() #7
  call void @gfx_present() #6
  %277 = load i32, ptr @turn, align 4, !tbaa !3
  %278 = icmp eq i32 %277, 12
  br i1 %278, label %279, label %16

279:                                              ; preds = %276
  call void @gfx_fill(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i16 noundef zeroext 2532) #6
  call void @gfx_rect(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i32 noundef 2, i16 noundef zeroext -377) #6
  call void @gfx_text2(i32 noundef 52, i32 noundef 104, ptr noundef nonnull @.str.7, i16 noundef zeroext -377, i16 noundef zeroext 2532) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #8
  %280 = call fastcc i32 @total() #7
  call void @numsp(ptr noundef nonnull %3, i32 noundef 3, i32 noundef %280) #6
  call void @gfx_text(i32 noundef 76, i32 noundef 124, ptr noundef nonnull @.str.8, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 124, i32 noundef 124, ptr noundef nonnull %3, i16 noundef zeroext -1, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 74, i32 noundef 136, ptr noundef nonnull @.str.9, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_present() #6
  call void @snd_play(i32 noundef 990, i32 noundef 60, i32 noundef 30) #6
  call void @led(i32 noundef 540424, i32 noundef 540424) #6
  call void @uputs(ptr noundef nonnull @.str.10) #6
  %281 = call fastcc i32 @total() #7
  call void @uputn(i32 noundef %281) #6
  call void @uputs(ptr noundef nonnull @.str.6) #6
  br label %282

282:                                              ; preds = %282, %279
  call void @frame_sync(i32 noundef 33000) #6
  call void @in_poll() #6
  %283 = load i32, ptr @in_edge, align 4, !tbaa !3
  %284 = and i32 %283, 16
  %285 = icmp eq i32 %284, 0
  br i1 %285, label %282, label %286, !llvm.loop !27

286:                                              ; preds = %282
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #8
  br label %287

287:                                              ; preds = %61, %286
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
  %14 = phi i32 [ 1, %2 ], [ %37, %35 ]
  %15 = icmp eq i32 %13, 9
  br i1 %15, label %16, label %20

16:                                               ; preds = %12
  %17 = getelementptr inbounds [5 x i32], ptr @held, i32 0, i32 %0
  %18 = load i32, ptr %17, align 4, !tbaa !3
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %40, label %38

20:                                               ; preds = %12
  %21 = and i32 %14, %10
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %35, label %23

23:                                               ; preds = %20
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

35:                                               ; preds = %20, %23
  %36 = add nuw nsw i32 %13, 1
  %37 = shl i32 %14, 1
  br label %12, !llvm.loop !30

38:                                               ; preds = %16
  %39 = add nsw i32 %3, 8
  tail call void @gfx_fill(i32 noundef %39, i32 noundef 49, i32 noundef 24, i32 noundef 4, i16 noundef zeroext -377) #6
  br label %40

40:                                               ; preds = %38, %16
  %41 = icmp eq i32 %1, 0
  br i1 %41, label %43, label %42

42:                                               ; preds = %40
  tail call void @gfx_rect(i32 noundef %5, i32 noundef 16, i32 noundef 32, i32 noundef 40, i32 noundef 2, i16 noundef zeroext -1337) #6
  br label %43

43:                                               ; preds = %42, %40
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
  %24 = phi i16 [ 32500, %20 ], [ 27662, %2 ]
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
