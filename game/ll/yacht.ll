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
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [13 x i8] c"yacht: roll\0A\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"yacht: cat=\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c" score=\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"FINISHED\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"total\00", align 1
@.str.8 = private unnamed_addr constant [12 x i8] c"press: menu\00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"yacht: total=\00", align 1
@pips = internal unnamed_addr constant [7 x i16] [i16 0, i16 16, i16 257, i16 273, i16 325, i16 341, i16 365], align 2
@.str.10 = private unnamed_addr constant [5 x i8] c"ROLL\00", align 1
@catname = internal unnamed_addr constant [12 x ptr] [ptr @.str.11, ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.22], align 4
@.str.11 = private unnamed_addr constant [5 x i8] c"Aces\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"Twos\00", align 1
@.str.13 = private unnamed_addr constant [7 x i8] c"Threes\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"Fours\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"Fives\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"Sixes\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c"Choice\00", align 1
@.str.18 = private unnamed_addr constant [10 x i8] c"Four Kind\00", align 1
@.str.19 = private unnamed_addr constant [11 x i8] c"Full House\00", align 1
@.str.20 = private unnamed_addr constant [15 x i8] c"Small Straight\00", align 1
@.str.21 = private unnamed_addr constant [13 x i8] c"Big Straight\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"Yacht\00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"TOTAL\00", align 1
@roll_anim.pause = internal unnamed_addr constant [7 x i8] c"\01\01\02\03\04\06\08", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @yacht_run() local_unnamed_addr #0 {
  %1 = alloca [5 x i32], align 4
  %2 = alloca [6 x i8], align 1
  %3 = alloca [4 x i8], align 1
  tail call void @uputs(ptr noundef nonnull @.str) #6
  tail call void @led(i32 noundef 1052680, i32 noundef 1052680) #6
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

16:                                               ; preds = %244, %7
  %17 = phi i32 [ %245, %244 ], [ %12, %7 ]
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

25:                                               ; preds = %19, %29
  %26 = phi i32 [ %31, %29 ], [ 0, %19 ]
  %27 = icmp eq i32 %26, 5
  br i1 %27, label %28, label %29

28:                                               ; preds = %25
  call fastcc void @roll_dice() #7
  br label %32

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %26
  store i32 0, ptr %30, align 4, !tbaa !3
  %31 = add nuw nsw i32 %26, 1
  br label %25, !llvm.loop !11

32:                                               ; preds = %32, %28
  %33 = phi i32 [ 0, %28 ], [ %37, %32 ]
  %34 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %33
  %35 = load i32, ptr %34, align 4, !tbaa !3
  %36 = icmp sgt i32 %35, -1
  %37 = add nuw nsw i32 %33, 1
  br i1 %36, label %32, label %38, !llvm.loop !12

38:                                               ; preds = %32, %43
  %39 = phi i32 [ %44, %43 ], [ 0, %32 ]
  %40 = icmp eq i32 %39, 5
  br i1 %40, label %41, label %43

41:                                               ; preds = %38
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %2) #8
  %42 = load i32, ptr @turn, align 4, !tbaa !3
  call void @numstr(ptr noundef nonnull %2, i32 noundef 2, i32 noundef %42) #6
  store i8 47, ptr %8, align 1, !tbaa !13
  store i8 49, ptr %9, align 1, !tbaa !13
  store i8 50, ptr %10, align 1, !tbaa !13
  store i8 0, ptr %11, align 1, !tbaa !13
  call void @gfx_text(i32 noundef 196, i32 noundef 4, ptr noundef nonnull %2, i16 noundef zeroext -12615, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %2) #8
  br label %45

43:                                               ; preds = %38
  call fastcc void @draw_die(i32 noundef %39, i32 noundef 0) #7
  %44 = add nuw nsw i32 %39, 1
  br label %38, !llvm.loop !14

45:                                               ; preds = %49, %41
  %46 = phi i32 [ 0, %41 ], [ %50, %49 ]
  %47 = icmp eq i32 %46, 12
  br i1 %47, label %48, label %49

48:                                               ; preds = %45
  call fastcc void @draw_total() #7
  call void @gfx_present() #6
  br label %238

49:                                               ; preds = %45
  call fastcc void @draw_cat(i32 noundef %46, i32 noundef 0) #7
  %50 = add nuw nsw i32 %46, 1
  br label %45, !llvm.loop !15

51:                                               ; preds = %179, %230
  %52 = phi i32 [ %231, %230 ], [ %180, %179 ]
  %53 = phi i32 [ %233, %230 ], [ %92, %179 ]
  br i1 %243, label %54, label %244

54:                                               ; preds = %51
  call void @frame_sync(i32 noundef 33000) #6
  call void @in_poll() #6
  %55 = icmp eq i32 %52, 0
  %56 = load i32, ptr @in_edge, align 4, !tbaa !3
  br i1 %55, label %57, label %186

57:                                               ; preds = %54
  %58 = and i32 %56, 4
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %73, label %60

60:                                               ; preds = %57
  %61 = icmp eq i32 %53, 0
  %62 = add nsw i32 %53, -1
  %63 = select i1 %61, i32 5, i32 %62
  %64 = icmp eq i32 %53, 5
  br i1 %64, label %65, label %66

65:                                               ; preds = %60
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %67

66:                                               ; preds = %60
  call fastcc void @draw_die(i32 noundef %53, i32 noundef 0) #7
  br label %67

67:                                               ; preds = %66, %65
  %68 = icmp eq i32 %63, 5
  br i1 %68, label %69, label %70

69:                                               ; preds = %67
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %71

70:                                               ; preds = %67
  call fastcc void @draw_die(i32 noundef %63, i32 noundef 1) #7
  br label %71

71:                                               ; preds = %70, %69
  call void @gfx_present() #6
  %72 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %73

73:                                               ; preds = %71, %57
  %74 = phi i32 [ %72, %71 ], [ %56, %57 ]
  %75 = phi i32 [ %63, %71 ], [ %53, %57 ]
  %76 = and i32 %74, 8
  %77 = icmp eq i32 %76, 0
  br i1 %77, label %90, label %78

78:                                               ; preds = %73
  %79 = icmp eq i32 %75, 5
  %80 = add nsw i32 %75, 1
  %81 = select i1 %79, i32 0, i32 %80
  br i1 %79, label %82, label %83

82:                                               ; preds = %78
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %84

83:                                               ; preds = %78
  call fastcc void @draw_die(i32 noundef %75, i32 noundef 0) #7
  br label %84

84:                                               ; preds = %83, %82
  %85 = icmp eq i32 %81, 5
  br i1 %85, label %86, label %87

86:                                               ; preds = %84
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %88

87:                                               ; preds = %84
  call fastcc void @draw_die(i32 noundef %81, i32 noundef 1) #7
  br label %88

88:                                               ; preds = %87, %86
  call void @gfx_present() #6
  %89 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %90

90:                                               ; preds = %88, %73
  %91 = phi i32 [ %89, %88 ], [ %74, %73 ]
  %92 = phi i32 [ %81, %88 ], [ %75, %73 ]
  %93 = and i32 %91, 16
  %94 = icmp eq i32 %93, 0
  br i1 %94, label %175, label %95

95:                                               ; preds = %90
  %96 = icmp slt i32 %92, 5
  br i1 %96, label %97, label %102

97:                                               ; preds = %95
  %98 = getelementptr inbounds [5 x i32], ptr @held, i32 0, i32 %92
  %99 = load i32, ptr %98, align 4, !tbaa !3
  %100 = icmp eq i32 %99, 0
  %101 = zext i1 %100 to i32
  store i32 %101, ptr %98, align 4, !tbaa !3
  call fastcc void @draw_die(i32 noundef %92, i32 noundef 1) #7
  call void @gfx_present() #6
  br label %175

102:                                              ; preds = %95
  %103 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %104 = icmp sgt i32 %103, 0
  br i1 %104, label %105, label %175

105:                                              ; preds = %102
  call void @led(i32 noundef 3158064, i32 noundef 3158064) #6
  call fastcc void @roll_dice() #7
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #8
  br label %106

106:                                              ; preds = %109, %105
  %107 = phi i32 [ 0, %105 ], [ %113, %109 ]
  %108 = icmp eq i32 %107, 5
  br i1 %108, label %114, label %109

109:                                              ; preds = %106
  %110 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %107
  %111 = load i32, ptr %110, align 4, !tbaa !3
  %112 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %107
  store i32 %111, ptr %112, align 4, !tbaa !3
  %113 = add nuw nsw i32 %107, 1
  br label %106, !llvm.loop !16

114:                                              ; preds = %106, %150
  %115 = phi i32 [ %152, %150 ], [ 0, %106 ]
  %116 = icmp eq i32 %115, 7
  br i1 %116, label %160, label %117

117:                                              ; preds = %114
  %118 = getelementptr inbounds nuw [7 x i8], ptr @roll_anim.pause, i32 0, i32 %115
  %119 = load i8, ptr %118, align 1, !tbaa !13
  %120 = zext i8 %119 to i32
  br label %121

121:                                              ; preds = %126, %117
  %122 = phi i32 [ %127, %126 ], [ 0, %117 ]
  %123 = icmp eq i32 %122, %120
  br i1 %123, label %124, label %126

124:                                              ; preds = %121
  %125 = icmp eq i32 %115, 6
  br label %128

126:                                              ; preds = %121
  call void @frame_sync(i32 noundef 33000) #6
  %127 = add nuw nsw i32 %122, 1
  br label %121, !llvm.loop !17

128:                                              ; preds = %145, %124
  %129 = phi i32 [ %146, %145 ], [ 0, %124 ]
  %130 = icmp eq i32 %129, 5
  br i1 %130, label %147, label %131

131:                                              ; preds = %128
  %132 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %129
  %133 = load i32, ptr %132, align 4, !tbaa !3
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %135, label %145

135:                                              ; preds = %131
  br i1 %125, label %136, label %139

136:                                              ; preds = %135
  %137 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %129
  %138 = load i32, ptr %137, align 4, !tbaa !3
  br label %142

139:                                              ; preds = %135
  %140 = call i32 @rng_below(i32 noundef 6) #6
  %141 = add nsw i32 %140, 1
  br label %142

142:                                              ; preds = %139, %136
  %143 = phi i32 [ %138, %136 ], [ %141, %139 ]
  %144 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %129
  store i32 %143, ptr %144, align 4, !tbaa !3
  br label %145

145:                                              ; preds = %142, %131
  %146 = add nuw nsw i32 %129, 1
  br label %128, !llvm.loop !18

147:                                              ; preds = %128, %158
  %148 = phi i32 [ %159, %158 ], [ 0, %128 ]
  %149 = icmp eq i32 %148, 5
  br i1 %149, label %150, label %153

150:                                              ; preds = %147
  %151 = select i1 %125, i32 900, i32 1400
  call void @snd_play(i32 noundef %151, i32 noundef 25, i32 noundef 1) #6
  call void @gfx_present() #6
  %152 = add nuw nsw i32 %115, 1
  br label %114, !llvm.loop !19

153:                                              ; preds = %147
  %154 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %148
  %155 = load i32, ptr %154, align 4, !tbaa !3
  %156 = icmp eq i32 %155, 0
  br i1 %156, label %157, label %158

157:                                              ; preds = %153
  call fastcc void @draw_die(i32 noundef %148, i32 noundef 0) #7
  br label %158

158:                                              ; preds = %157, %153
  %159 = add nuw nsw i32 %148, 1
  br label %147, !llvm.loop !20

160:                                              ; preds = %114, %163
  %161 = phi i32 [ %167, %163 ], [ 0, %114 ]
  %162 = icmp eq i32 %161, 5
  br i1 %162, label %168, label %163

163:                                              ; preds = %160
  %164 = getelementptr inbounds nuw [5 x i32], ptr %1, i32 0, i32 %161
  %165 = load i32, ptr %164, align 4, !tbaa !3
  %166 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %161
  store i32 %165, ptr %166, align 4, !tbaa !3
  %167 = add nuw nsw i32 %161, 1
  br label %160, !llvm.loop !21

168:                                              ; preds = %160
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #8
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %169

169:                                              ; preds = %173, %168
  %170 = phi i32 [ 0, %168 ], [ %174, %173 ]
  %171 = icmp eq i32 %170, 12
  br i1 %171, label %172, label %173

172:                                              ; preds = %169
  call void @gfx_present() #6
  call void @uputs(ptr noundef nonnull @.str.2) #6
  br label %175

173:                                              ; preds = %169
  call fastcc void @draw_cat(i32 noundef %170, i32 noundef 0) #7
  %174 = add nuw nsw i32 %170, 1
  br label %169, !llvm.loop !22

175:                                              ; preds = %97, %172, %102, %90
  %176 = load i32, ptr @in_edge, align 4, !tbaa !3
  %177 = and i32 %176, 3
  %178 = icmp eq i32 %177, 0
  br i1 %178, label %179, label %181

179:                                              ; preds = %175, %185
  %180 = phi i32 [ 1, %185 ], [ 0, %175 ]
  br label %51, !llvm.loop !23

181:                                              ; preds = %175
  %182 = icmp eq i32 %92, 5
  br i1 %182, label %183, label %184

183:                                              ; preds = %181
  call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %185

184:                                              ; preds = %181
  call fastcc void @draw_die(i32 noundef %92, i32 noundef 0) #7
  br label %185

185:                                              ; preds = %184, %183
  call fastcc void @draw_cat(i32 noundef %232, i32 noundef 1) #7
  call void @gfx_present() #6
  br label %179

186:                                              ; preds = %54
  %187 = and i32 %56, 12
  %188 = icmp eq i32 %187, 0
  br i1 %188, label %195, label %189

189:                                              ; preds = %186
  call fastcc void @draw_cat(i32 noundef %232, i32 noundef 0) #7
  %190 = icmp eq i32 %53, 5
  br i1 %190, label %191, label %192

191:                                              ; preds = %189
  call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %193

192:                                              ; preds = %189
  call fastcc void @draw_die(i32 noundef %53, i32 noundef 1) #7
  br label %193

193:                                              ; preds = %192, %191
  call void @gfx_present() #6
  %194 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %195

195:                                              ; preds = %193, %186
  %196 = phi i32 [ %194, %193 ], [ %56, %186 ]
  %197 = phi i32 [ 0, %193 ], [ 1, %186 ]
  %198 = and i32 %196, 1
  %199 = icmp eq i32 %198, 0
  br i1 %199, label %210, label %200

200:                                              ; preds = %195, %200
  %201 = phi i32 [ %204, %200 ], [ %232, %195 ]
  %202 = icmp eq i32 %201, 0
  %203 = add nsw i32 %201, -1
  %204 = select i1 %202, i32 11, i32 %203
  %205 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %204
  %206 = load i32, ptr %205, align 4, !tbaa !3
  %207 = icmp sgt i32 %206, -1
  br i1 %207, label %200, label %208, !llvm.loop !24

208:                                              ; preds = %200
  call fastcc void @draw_cat(i32 noundef %232, i32 noundef 0) #7
  call fastcc void @draw_cat(i32 noundef %204, i32 noundef 1) #7
  call void @gfx_present() #6
  %209 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %210

210:                                              ; preds = %208, %195
  %211 = phi i32 [ %209, %208 ], [ %196, %195 ]
  %212 = phi i32 [ %204, %208 ], [ %232, %195 ]
  %213 = and i32 %211, 2
  %214 = icmp eq i32 %213, 0
  br i1 %214, label %225, label %215

215:                                              ; preds = %210, %215
  %216 = phi i32 [ %219, %215 ], [ %212, %210 ]
  %217 = icmp eq i32 %216, 11
  %218 = add nsw i32 %216, 1
  %219 = select i1 %217, i32 0, i32 %218
  %220 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %219
  %221 = load i32, ptr %220, align 4, !tbaa !3
  %222 = icmp sgt i32 %221, -1
  br i1 %222, label %215, label %223, !llvm.loop !25

223:                                              ; preds = %215
  call fastcc void @draw_cat(i32 noundef %212, i32 noundef 0) #7
  call fastcc void @draw_cat(i32 noundef %219, i32 noundef 1) #7
  call void @gfx_present() #6
  %224 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %225

225:                                              ; preds = %223, %210
  %226 = phi i32 [ %224, %223 ], [ %211, %210 ]
  %227 = phi i32 [ %219, %223 ], [ %212, %210 ]
  %228 = and i32 %226, 16
  %229 = icmp eq i32 %228, 0
  br i1 %229, label %230, label %234, !llvm.loop !23

230:                                              ; preds = %238, %225
  %231 = phi i32 [ %197, %225 ], [ %239, %238 ]
  %232 = phi i32 [ %227, %225 ], [ %240, %238 ]
  %233 = phi i32 [ %53, %225 ], [ %242, %238 ]
  br label %51

234:                                              ; preds = %225
  call void @snd_play(i32 noundef 800, i32 noundef 45, i32 noundef 4) #6
  %235 = call fastcc i32 @cat_score(i32 noundef %227) #7
  %236 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %227
  store i32 %235, ptr %236, align 4, !tbaa !3
  call void @uputs(ptr noundef nonnull @.str.3) #6
  call void @uputn(i32 noundef %227) #6
  call void @uputs(ptr noundef nonnull @.str.4) #6
  %237 = load i32, ptr %236, align 4, !tbaa !3
  call void @uputn(i32 noundef %237) #6
  call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %238, !llvm.loop !23

238:                                              ; preds = %48, %234
  %239 = phi i32 [ 0, %48 ], [ %197, %234 ]
  %240 = phi i32 [ %33, %48 ], [ %227, %234 ]
  %241 = phi i32 [ -1, %48 ], [ %227, %234 ]
  %242 = phi i32 [ 5, %48 ], [ %53, %234 ]
  %243 = icmp slt i32 %241, 0
  br label %230

244:                                              ; preds = %51
  call fastcc void @draw_cat(i32 noundef %241, i32 noundef 0) #7
  call fastcc void @draw_total() #7
  call void @gfx_present() #6
  %245 = load i32, ptr @turn, align 4, !tbaa !3
  %246 = icmp eq i32 %245, 12
  br i1 %246, label %247, label %16

247:                                              ; preds = %244
  call void @gfx_fill(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i16 noundef zeroext 2532) #6
  call void @gfx_rect(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i32 noundef 2, i16 noundef zeroext -377) #6
  call void @gfx_text2(i32 noundef 52, i32 noundef 104, ptr noundef nonnull @.str.6, i16 noundef zeroext -377, i16 noundef zeroext 2532) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #8
  %248 = call fastcc i32 @total() #7
  call void @numstr(ptr noundef nonnull %3, i32 noundef 3, i32 noundef %248) #6
  call void @gfx_text(i32 noundef 76, i32 noundef 124, ptr noundef nonnull @.str.7, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 124, i32 noundef 124, ptr noundef nonnull %3, i16 noundef zeroext -1, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 74, i32 noundef 136, ptr noundef nonnull @.str.8, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_present() #6
  call void @snd_play(i32 noundef 990, i32 noundef 60, i32 noundef 30) #6
  call void @led(i32 noundef 2162464, i32 noundef 2162464) #6
  call void @uputs(ptr noundef nonnull @.str.9) #6
  %249 = call fastcc i32 @total() #7
  call void @uputn(i32 noundef %249) #6
  call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %250

250:                                              ; preds = %250, %247
  call void @frame_sync(i32 noundef 33000) #6
  call void @in_poll() #6
  %251 = load i32, ptr @in_edge, align 4, !tbaa !3
  %252 = and i32 %251, 16
  %253 = icmp eq i32 %252, 0
  br i1 %253, label %250, label %254, !llvm.loop !26

254:                                              ; preds = %250
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #8
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
define internal fastcc void @roll_dice() unnamed_addr #0 {
  br label %1

1:                                                ; preds = %15, %0
  %2 = phi i32 [ 0, %0 ], [ %16, %15 ]
  %3 = icmp eq i32 %2, 5
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %6 = add nsw i32 %5, -1
  store i32 %6, ptr @rolls_left, align 4, !tbaa !3
  ret void

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %2
  %9 = load i32, ptr %8, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %15

11:                                               ; preds = %7
  %12 = tail call i32 @rng_below(i32 noundef 6) #6
  %13 = add nsw i32 %12, 1
  %14 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %2
  store i32 %13, ptr %14, align 4, !tbaa !3
  br label %15

15:                                               ; preds = %7, %11
  %16 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !27
}

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
  tail call void @gfx_text(i32 noundef 189, i32 noundef 25, ptr noundef nonnull @.str.10, i16 noundef zeroext %11, i16 noundef zeroext %12) #6
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
  br i1 %16, label %19, label %17

17:                                               ; preds = %2
  %18 = tail call fastcc i32 @cat_score(i32 noundef %0) #7
  br label %19

19:                                               ; preds = %2, %17
  %20 = phi i32 [ %18, %17 ], [ %15, %2 ]
  %21 = phi i16 [ 32500, %17 ], [ -1, %2 ]
  call void @numstr(ptr noundef nonnull %3, i32 noundef 3, i32 noundef %20) #6
  call void @gfx_text(i32 noundef 200, i32 noundef %5, ptr noundef nonnull %3, i16 noundef zeroext %21, i16 noundef zeroext %8) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_total() unnamed_addr #0 {
  %1 = alloca [4 x i8], align 1
  tail call void @gfx_fill(i32 noundef 4, i32 noundef 212, i32 noundef 232, i32 noundef 20, i16 noundef zeroext 2371) #6
  tail call void @gfx_text(i32 noundef 10, i32 noundef 218, ptr noundef nonnull @.str.23, i16 noundef zeroext -12615, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #8
  %2 = tail call fastcc i32 @total() #7
  call void @numstr(ptr noundef nonnull %1, i32 noundef 3, i32 noundef %2) #6
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
  br label %78

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
  switch i32 %0, label %70 [
    i32 6, label %78
    i32 7, label %24
    i32 8, label %35
    i32 9, label %54
    i32 10, label %62
  ]

24:                                               ; preds = %23, %33
  %25 = phi i32 [ %34, %33 ], [ 1, %23 ]
  %26 = icmp eq i32 %25, 7
  br i1 %26, label %78, label %27

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %25
  %29 = load i32, ptr %28, align 4, !tbaa !3
  %30 = icmp sgt i32 %29, 3
  br i1 %30, label %31, label %33

31:                                               ; preds = %27
  %32 = shl nuw nsw i32 %25, 2
  br label %78

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
  br label %78

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

54:                                               ; preds = %23, %57
  %55 = phi i32 [ %61, %57 ], [ 1, %23 ]
  %56 = icmp eq i32 %55, 6
  br i1 %56, label %78, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %55
  %59 = load i32, ptr %58, align 4, !tbaa !3
  %60 = icmp eq i32 %59, 1
  %61 = add nuw nsw i32 %55, 1
  br i1 %60, label %54, label %78, !llvm.loop !37

62:                                               ; preds = %23, %65
  %63 = phi i32 [ %69, %65 ], [ 2, %23 ]
  %64 = icmp eq i32 %63, 7
  br i1 %64, label %78, label %65

65:                                               ; preds = %62
  %66 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %63
  %67 = load i32, ptr %66, align 4, !tbaa !3
  %68 = icmp eq i32 %67, 1
  %69 = add nuw nsw i32 %63, 1
  br i1 %68, label %62, label %78, !llvm.loop !38

70:                                               ; preds = %23, %73
  %71 = phi i32 [ %77, %73 ], [ 1, %23 ]
  %72 = icmp eq i32 %71, 7
  br i1 %72, label %78, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %71
  %75 = load i32, ptr %74, align 4, !tbaa !3
  %76 = icmp eq i32 %75, 5
  %77 = add nuw nsw i32 %71, 1
  br i1 %76, label %78, label %70, !llvm.loop !39

78:                                               ; preds = %62, %65, %54, %57, %24, %70, %73, %9, %31, %23, %40
  %79 = phi i32 [ %44, %40 ], [ %4, %23 ], [ %32, %31 ], [ %14, %9 ], [ 0, %70 ], [ 50, %73 ], [ 0, %24 ], [ 30, %54 ], [ 0, %57 ], [ 30, %62 ], [ 0, %65 ]
  call void @llvm.lifetime.end.p0(i64 28, ptr nonnull %2) #8
  ret i32 %79
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
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

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
  br label %1, !llvm.loop !40
}

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
!26 = distinct !{!26, !9}
!27 = distinct !{!27, !8, !9}
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
