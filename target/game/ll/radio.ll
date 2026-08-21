; ModuleID = 'radio.c'
source_filename = "radio.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [11 x i8] c"radio: up\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [13 x i8] c"radio: back\0A\00", align 1
@.str.2 = private unnamed_addr constant [24 x i8] c"radio: converged after \00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c" shots\0A\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"radio: shot \00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@rho = internal unnamed_addr constant [6 x [3 x i16]] [[3 x i16] [i16 192, i16 192, i16 192], [3 x i16] [i16 192, i16 192, i16 192], [3 x i16] [i16 192, i16 192, i16 192], [3 x i16] [i16 230, i16 45, i16 45], [3 x i16] [i16 45, i16 230, i16 45], [3 x i16] [i16 200, i16 195, i16 185]], align 2

; Function Attrs: minsize nounwind optsize
define dso_local void @radio_run() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca [9 x i32], align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  tail call void @uputs(ptr noundef nonnull @.str) #8
  tail call void @led(i32 noundef 984577, i32 noundef 984577) #8
  tail call void @gfx_clear(i16 noundef zeroext 2114) #8
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %16) #9
  br label %20

20:                                               ; preds = %26, %0
  %21 = phi i32 [ 0, %0 ], [ %31, %26 ]
  %22 = icmp eq i32 %21, 9
  br i1 %22, label %23, label %26

23:                                               ; preds = %20
  %24 = getelementptr inbounds nuw i8, ptr %16, i32 32
  %25 = load i32, ptr %24, align 4
  br label %32

26:                                               ; preds = %20
  %27 = mul nuw nsw i32 %21, 30
  %28 = add nuw nsw i32 %27, 200
  %29 = udiv i32 819200, %28
  %30 = getelementptr inbounds nuw [9 x i32], ptr %16, i32 0, i32 %21
  store i32 %29, ptr %30, align 4, !tbaa !3
  %31 = add nuw nsw i32 %21, 1
  br label %20, !llvm.loop !7

32:                                               ; preds = %49, %23
  %33 = phi i32 [ %50, %49 ], [ 0, %23 ]
  %34 = icmp eq i32 %33, 5
  br i1 %34, label %105, label %35

35:                                               ; preds = %32
  %36 = mul nuw nsw i32 %33, 324
  %37 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537128224 to ptr), i32 %36
  br label %38

38:                                               ; preds = %54, %35
  %39 = phi i32 [ %55, %54 ], [ 0, %35 ]
  %40 = icmp eq i32 %39, 9
  br i1 %40, label %49, label %41

41:                                               ; preds = %38
  %42 = mul nuw nsw i32 %39, 9
  %43 = getelementptr inbounds nuw [9 x i32], ptr %16, i32 0, i32 %39
  %44 = mul nuw nsw i32 %39, 30
  %45 = add nsw i32 %44, -120
  %46 = mul nsw i32 %45, %25
  %47 = ashr i32 %46, 12
  %48 = add nsw i32 %47, 120
  br label %51

49:                                               ; preds = %38
  %50 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !10

51:                                               ; preds = %95, %41
  %52 = phi i32 [ %104, %95 ], [ 0, %41 ]
  %53 = icmp eq i32 %52, 9
  br i1 %53, label %54, label %56

54:                                               ; preds = %51
  %55 = add nuw nsw i32 %39, 1
  br label %38, !llvm.loop !11

56:                                               ; preds = %51
  %57 = mul nuw nsw i32 %52, 30
  %58 = add nsw i32 %57, -120
  switch i32 %33, label %87 [
    i32 0, label %59
    i32 1, label %63
    i32 2, label %71
    i32 3, label %79
  ]

59:                                               ; preds = %56
  %60 = mul nsw i32 %58, %25
  %61 = ashr i32 %60, 12
  %62 = add nsw i32 %61, 120
  br label %95

63:                                               ; preds = %56
  %64 = load i32, ptr %43, align 4, !tbaa !3
  %65 = mul nsw i32 %64, %58
  %66 = ashr i32 %65, 12
  %67 = add nsw i32 %66, 120
  %68 = mul nsw i32 %64, 120
  %69 = ashr i32 %68, 12
  %70 = add nsw i32 %69, 120
  br label %95

71:                                               ; preds = %56
  %72 = load i32, ptr %43, align 4, !tbaa !3
  %73 = mul nsw i32 %72, %58
  %74 = ashr i32 %73, 12
  %75 = add nsw i32 %74, 120
  %76 = mul nsw i32 %72, 120
  %77 = ashr i32 %76, 12
  %78 = sub nsw i32 120, %77
  br label %95

79:                                               ; preds = %56
  %80 = load i32, ptr %43, align 4, !tbaa !3
  %81 = mul nsw i32 %80, 120
  %82 = ashr i32 %81, 12
  %83 = sub nsw i32 120, %82
  %84 = mul nsw i32 %80, %58
  %85 = ashr i32 %84, 12
  %86 = add nsw i32 %85, 120
  br label %95

87:                                               ; preds = %56
  %88 = load i32, ptr %43, align 4, !tbaa !3
  %89 = mul nsw i32 %88, 120
  %90 = ashr i32 %89, 12
  %91 = add nsw i32 %90, 120
  %92 = mul nsw i32 %88, %58
  %93 = ashr i32 %92, 12
  %94 = add nsw i32 %93, 120
  br label %95

95:                                               ; preds = %87, %79, %71, %63, %59
  %96 = phi i32 [ %91, %87 ], [ %62, %59 ], [ %67, %63 ], [ %75, %71 ], [ %83, %79 ]
  %97 = phi i32 [ %94, %87 ], [ %48, %59 ], [ %70, %63 ], [ %78, %71 ], [ %86, %79 ]
  %98 = trunc i32 %96 to i16
  %99 = add nuw nsw i32 %52, %42
  %100 = shl nuw nsw i32 %99, 2
  %101 = getelementptr inbounds nuw i8, ptr %37, i32 %100
  store i16 %98, ptr %101, align 4, !tbaa !12
  %102 = trunc i32 %97 to i16
  %103 = getelementptr inbounds nuw i8, ptr %101, i32 2
  store i16 %102, ptr %103, align 2, !tbaa !12
  %104 = add nuw nsw i32 %52, 1
  br label %51, !llvm.loop !14

105:                                              ; preds = %32, %116
  %106 = phi i32 [ %117, %116 ], [ 0, %32 ]
  %107 = icmp eq i32 %106, 10
  br i1 %107, label %141, label %108

108:                                              ; preds = %105
  %109 = mul nuw nsw i32 %106, 36
  %110 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537129904 to ptr), i32 %109
  br label %111

111:                                              ; preds = %121, %108
  %112 = phi i32 [ %122, %121 ], [ 0, %108 ]
  %113 = icmp eq i32 %112, 3
  br i1 %113, label %116, label %114

114:                                              ; preds = %111
  %115 = mul nuw nsw i32 %112, 3
  br label %118

116:                                              ; preds = %111
  %117 = add nuw nsw i32 %106, 1
  br label %105, !llvm.loop !15

118:                                              ; preds = %123, %114
  %119 = phi i32 [ %140, %123 ], [ 0, %114 ]
  %120 = icmp eq i32 %119, 3
  br i1 %120, label %121, label %123

121:                                              ; preds = %118
  %122 = add nuw nsw i32 %112, 1
  br label %111, !llvm.loop !16

123:                                              ; preds = %118
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %17) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %18) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %19) #9
  call fastcc void @face_point(i32 noundef %106, i32 noundef %119, i32 noundef %112, ptr noundef %17, ptr noundef %18, ptr noundef %19) #10
  %124 = load i32, ptr %19, align 4, !tbaa !3
  %125 = udiv i32 819200, %124
  %126 = load i32, ptr %17, align 4, !tbaa !3
  %127 = mul nsw i32 %126, %125
  %128 = lshr i32 %127, 12
  %129 = trunc i32 %128 to i16
  %130 = add i16 %129, 120
  %131 = add nuw nsw i32 %119, %115
  %132 = shl nuw nsw i32 %131, 2
  %133 = getelementptr inbounds nuw i8, ptr %110, i32 %132
  store i16 %130, ptr %133, align 4, !tbaa !12
  %134 = load i32, ptr %18, align 4, !tbaa !3
  %135 = mul nsw i32 %134, %125
  %136 = lshr i32 %135, 12
  %137 = trunc i32 %136 to i16
  %138 = add i16 %137, 120
  %139 = getelementptr inbounds nuw i8, ptr %133, i32 2
  store i16 %138, ptr %139, align 2, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %19) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %18) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %17) #9
  %140 = add nuw nsw i32 %119, 1
  br label %118, !llvm.loop !17

141:                                              ; preds = %105
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %16) #9
  br label %142

142:                                              ; preds = %180, %141
  %143 = phi i32 [ 0, %141 ], [ %183, %180 ]
  %144 = icmp eq i32 %143, 320
  br i1 %144, label %184, label %145

145:                                              ; preds = %142
  %146 = lshr i32 %143, 6
  %147 = and i32 %143, 7
  %148 = lshr i32 %143, 3
  %149 = and i32 %148, 7
  %150 = mul nuw nsw i32 %147, 30
  %151 = add nsw i32 %150, -105
  %152 = mul nuw nsw i32 %149, 30
  %153 = add nuw nsw i32 %152, 215
  switch i32 %146, label %175 [
    i32 0, label %154
    i32 1, label %160
    i32 2, label %165
    i32 3, label %170
  ]

154:                                              ; preds = %145
  %155 = trunc nsw i32 %151 to i16
  %156 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %143
  store i16 %155, ptr %156, align 2, !tbaa !12
  %157 = trunc nuw nsw i32 %152 to i16
  %158 = add nsw i16 %157, -105
  %159 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %143
  store i16 %158, ptr %159, align 2, !tbaa !12
  br label %180

160:                                              ; preds = %145
  %161 = trunc nsw i32 %151 to i16
  %162 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %143
  store i16 %161, ptr %162, align 2, !tbaa !12
  %163 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %143
  store i16 120, ptr %163, align 2, !tbaa !12
  %164 = trunc nuw nsw i32 %153 to i16
  br label %180

165:                                              ; preds = %145
  %166 = trunc nsw i32 %151 to i16
  %167 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %143
  store i16 %166, ptr %167, align 2, !tbaa !12
  %168 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %143
  store i16 -120, ptr %168, align 2, !tbaa !12
  %169 = trunc nuw nsw i32 %153 to i16
  br label %180

170:                                              ; preds = %145
  %171 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %143
  store i16 -120, ptr %171, align 2, !tbaa !12
  %172 = trunc nsw i32 %151 to i16
  %173 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %143
  store i16 %172, ptr %173, align 2, !tbaa !12
  %174 = trunc nuw nsw i32 %153 to i16
  br label %180

175:                                              ; preds = %145
  %176 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %143
  store i16 120, ptr %176, align 2, !tbaa !12
  %177 = trunc nsw i32 %151 to i16
  %178 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %143
  store i16 %177, ptr %178, align 2, !tbaa !12
  %179 = trunc nuw nsw i32 %153 to i16
  br label %180

180:                                              ; preds = %175, %170, %165, %160, %154
  %181 = phi i16 [ %179, %175 ], [ %174, %170 ], [ %169, %165 ], [ %164, %160 ], [ 440, %154 ]
  %182 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537122464 to ptr), i32 %143
  store i16 %181, ptr %182, align 2, !tbaa !12
  %183 = add nuw nsw i32 %143, 1
  br label %142, !llvm.loop !18

184:                                              ; preds = %142, %221
  %185 = phi i32 [ %233, %221 ], [ 0, %142 ]
  %186 = icmp eq i32 %185, 10
  br i1 %186, label %259, label %187

187:                                              ; preds = %184
  %188 = add nsw i32 %185, -5
  %189 = icmp samesign ult i32 %185, 5
  %190 = select i1 %189, i32 %185, i32 %188
  %191 = select i1 %189, i32 245, i32 243
  %192 = select i1 %189, i32 75, i32 -79
  switch i32 %190, label %200 [
    i32 0, label %201
    i32 1, label %193
    i32 2, label %196
    i32 3, label %198
  ]

193:                                              ; preds = %187
  %194 = select i1 %189, i32 -75, i32 79
  %195 = select i1 %189, i32 -245, i32 -243
  br label %201

196:                                              ; preds = %187
  %197 = select i1 %189, i32 -75, i32 79
  br label %201

198:                                              ; preds = %187
  %199 = select i1 %189, i32 -245, i32 -243
  br label %201

200:                                              ; preds = %187
  br label %201

201:                                              ; preds = %200, %198, %196, %193, %187
  %202 = phi i32 [ 0, %200 ], [ %194, %193 ], [ %191, %196 ], [ %199, %198 ], [ %192, %187 ]
  %203 = phi i32 [ -256, %200 ], [ 0, %193 ], [ 0, %196 ], [ 0, %198 ], [ %190, %187 ]
  %204 = phi i32 [ 0, %200 ], [ %195, %193 ], [ %197, %196 ], [ %192, %198 ], [ %191, %187 ]
  %205 = trunc nsw i32 %204 to i16
  %206 = mul nuw nsw i32 %185, 6
  %207 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130264 to ptr), i32 %206
  store i16 %205, ptr %207, align 2, !tbaa !12
  %208 = trunc nsw i32 %203 to i16
  %209 = getelementptr inbounds nuw i8, ptr %207, i32 2
  store i16 %208, ptr %209, align 2, !tbaa !12
  %210 = trunc nsw i32 %202 to i16
  %211 = getelementptr inbounds nuw i8, ptr %207, i32 4
  store i16 %210, ptr %211, align 2, !tbaa !12
  %212 = icmp eq i32 %190, 4
  %213 = select i1 %189, i16 768, i16 368
  %214 = select i1 %212, i16 368, i16 %213
  %215 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537130324 to ptr), i32 %185
  store i16 %214, ptr %215, align 2, !tbaa !12
  %216 = shl nuw nsw i32 %185, 2
  %217 = add nuw nsw i32 %216, 320
  br label %218

218:                                              ; preds = %234, %201
  %219 = phi i32 [ 0, %201 ], [ %258, %234 ]
  %220 = icmp eq i32 %219, 4
  br i1 %220, label %221, label %234

221:                                              ; preds = %218
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %14) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %15) #9
  call fastcc void @face_point(i32 noundef %185, i32 noundef 1, i32 noundef 1, ptr noundef %13, ptr noundef %14, ptr noundef %15) #10
  %222 = load i32, ptr %13, align 4, !tbaa !3
  %223 = mul nsw i32 %222, %204
  %224 = load i32, ptr %14, align 4, !tbaa !3
  %225 = mul nsw i32 %224, %203
  %226 = add nsw i32 %225, %223
  %227 = load i32, ptr %15, align 4, !tbaa !3
  %228 = mul nsw i32 %227, %202
  %229 = add nsw i32 %226, %228
  %230 = lshr i32 %229, 31
  %231 = trunc nuw nsw i32 %230 to i16
  %232 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537130344 to ptr), i32 %185
  store i16 %231, ptr %232, align 2, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %15) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %14) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #9
  %233 = add nuw nsw i32 %185, 1
  br label %184, !llvm.loop !19

234:                                              ; preds = %218
  %235 = add nuw nsw i32 %219, %217
  %236 = and i32 %219, 1
  %237 = lshr i32 %219, 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %10) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #9
  call fastcc void @face_point(i32 noundef %185, i32 noundef %236, i32 noundef %237, ptr noundef %7, ptr noundef %8, ptr noundef %9) #10
  %238 = add nuw nsw i32 %236, 1
  %239 = add nuw nsw i32 %237, 1
  call fastcc void @face_point(i32 noundef %185, i32 noundef %238, i32 noundef %239, ptr noundef %10, ptr noundef %11, ptr noundef %12) #10
  %240 = load i32, ptr %7, align 4, !tbaa !3
  %241 = load i32, ptr %10, align 4, !tbaa !3
  %242 = add nsw i32 %241, %240
  %243 = sdiv i32 %242, 2
  %244 = trunc i32 %243 to i16
  %245 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %235
  store i16 %244, ptr %245, align 2, !tbaa !12
  %246 = load i32, ptr %8, align 4, !tbaa !3
  %247 = load i32, ptr %11, align 4, !tbaa !3
  %248 = add nsw i32 %247, %246
  %249 = sdiv i32 %248, 2
  %250 = trunc i32 %249 to i16
  %251 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %235
  store i16 %250, ptr %251, align 2, !tbaa !12
  %252 = load i32, ptr %9, align 4, !tbaa !3
  %253 = load i32, ptr %12, align 4, !tbaa !3
  %254 = add nsw i32 %253, %252
  %255 = sdiv i32 %254, 2
  %256 = trunc i32 %255 to i16
  %257 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537122464 to ptr), i32 %235
  store i16 %256, ptr %257, align 2, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %10) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #9
  %258 = add nuw nsw i32 %219, 1
  br label %218, !llvm.loop !20

259:                                              ; preds = %184, %273
  %260 = phi i32 [ %274, %273 ], [ 0, %184 ]
  %261 = icmp eq i32 %260, 360
  br i1 %261, label %275, label %262

262:                                              ; preds = %259
  %263 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124624 to ptr), i32 %260
  store i16 0, ptr %263, align 2, !tbaa !12
  %264 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123904 to ptr), i32 %260
  store i16 0, ptr %264, align 2, !tbaa !12
  %265 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123184 to ptr), i32 %260
  store i16 0, ptr %265, align 2, !tbaa !12
  %266 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126784 to ptr), i32 %260
  store i16 0, ptr %266, align 2, !tbaa !12
  %267 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126064 to ptr), i32 %260
  store i16 0, ptr %267, align 2, !tbaa !12
  %268 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125344 to ptr), i32 %260
  store i16 0, ptr %268, align 2, !tbaa !12
  %269 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127504 to ptr), i32 %260
  store i16 -1, ptr %269, align 2, !tbaa !12
  %270 = tail call fastcc i32 @is_light(i32 noundef %260) #10
  %271 = icmp eq i32 %270, 0
  br i1 %271, label %273, label %272

272:                                              ; preds = %262
  store i16 -5536, ptr %268, align 2, !tbaa !12
  store i16 -5536, ptr %267, align 2, !tbaa !12
  store i16 -11536, ptr %266, align 2, !tbaa !12
  br label %273

273:                                              ; preds = %272, %262
  %274 = add nuw nsw i32 %260, 1
  br label %259, !llvm.loop !21

275:                                              ; preds = %259
  tail call fastcc void @repaint(i32 noundef 1) #10
  br label %276

276:                                              ; preds = %549, %275
  %277 = phi i32 [ 0, %275 ], [ %545, %549 ]
  br label %278

278:                                              ; preds = %276, %324
  %279 = phi i1 [ false, %324 ], [ true, %276 ]
  br label %280

280:                                              ; preds = %278, %287
  %281 = phi i1 [ false, %287 ], [ %279, %278 ]
  tail call void @in_poll() #8
  %282 = load i32, ptr @in_edge, align 4, !tbaa !3
  %283 = and i32 %282, 31
  %284 = icmp eq i32 %283, 0
  br i1 %284, label %286, label %285

285:                                              ; preds = %280
  tail call void @led(i32 noundef 0, i32 noundef 0) #8
  tail call void @uputs(ptr noundef nonnull @.str.1) #8
  ret void

286:                                              ; preds = %280
  br i1 %281, label %288, label %287

287:                                              ; preds = %286
  tail call void @frame_sync(i32 noundef 33000) #8
  br label %280, !llvm.loop !22

288:                                              ; preds = %286, %312
  %289 = phi i32 [ %317, %312 ], [ -1, %286 ]
  %290 = phi i32 [ %319, %312 ], [ 0, %286 ]
  %291 = phi i32 [ %318, %312 ], [ 0, %286 ]
  %292 = icmp eq i32 %290, 360
  br i1 %292, label %320, label %293

293:                                              ; preds = %288
  %294 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125344 to ptr), i32 %290
  %295 = load i16, ptr %294, align 2, !tbaa !12
  %296 = zext i16 %295 to i32
  %297 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126064 to ptr), i32 %290
  %298 = load i16, ptr %297, align 2, !tbaa !12
  %299 = zext i16 %298 to i32
  %300 = add nuw nsw i32 %299, %296
  %301 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126784 to ptr), i32 %290
  %302 = load i16, ptr %301, align 2, !tbaa !12
  %303 = zext i16 %302 to i32
  %304 = add nuw nsw i32 %300, %303
  %305 = icmp samesign ult i32 %290, 320
  br i1 %305, label %312, label %306

306:                                              ; preds = %293
  %307 = add nsw i32 %290, -320
  %308 = lshr i32 %307, 2
  %309 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537130324 to ptr), i32 %308
  %310 = load i16, ptr %309, align 2, !tbaa !12
  %311 = sext i16 %310 to i32
  br label %312

312:                                              ; preds = %306, %293
  %313 = phi i32 [ %311, %306 ], [ 256, %293 ]
  %314 = mul i32 %313, %304
  %315 = lshr i32 %314, 8
  %316 = icmp samesign ugt i32 %315, %291
  %317 = select i1 %316, i32 %290, i32 %289
  %318 = tail call i32 @llvm.umax.i32(i32 %315, i32 %291)
  %319 = add nuw nsw i32 %290, 1
  br label %288, !llvm.loop !23

320:                                              ; preds = %288
  %321 = icmp samesign ugt i32 %291, 95
  %322 = select i1 %321, i32 %289, i32 -1
  %323 = icmp slt i32 %322, 0
  br i1 %323, label %324, label %325

324:                                              ; preds = %320
  tail call void @uputs(ptr noundef nonnull @.str.2) #8
  tail call void @uputn(i32 noundef %277) #8
  tail call void @uputs(ptr noundef nonnull @.str.3) #8
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #8
  br label %278, !llvm.loop !22

325:                                              ; preds = %320
  %326 = icmp samesign ult i32 %322, 320
  br i1 %326, label %333, label %327

327:                                              ; preds = %325
  %328 = add nsw i32 %322, -320
  %329 = lshr i32 %328, 2
  %330 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537130324 to ptr), i32 %329
  %331 = load i16, ptr %330, align 2, !tbaa !12
  %332 = sext i16 %331 to i32
  br label %333

333:                                              ; preds = %327, %325
  %334 = phi i32 [ %332, %327 ], [ 256, %325 ]
  %335 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125344 to ptr), i32 %322
  %336 = load i16, ptr %335, align 2, !tbaa !12
  %337 = zext i16 %336 to i32
  %338 = mul nsw i32 %334, %337
  %339 = lshr i32 %338, 8
  %340 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126064 to ptr), i32 %322
  %341 = load i16, ptr %340, align 2, !tbaa !12
  %342 = zext i16 %341 to i32
  %343 = mul nsw i32 %334, %342
  %344 = lshr i32 %343, 8
  %345 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126784 to ptr), i32 %322
  %346 = load i16, ptr %345, align 2, !tbaa !12
  %347 = zext i16 %346 to i32
  %348 = mul nsw i32 %334, %347
  %349 = lshr i32 %348, 8
  store i16 0, ptr %345, align 2, !tbaa !12
  store i16 0, ptr %340, align 2, !tbaa !12
  store i16 0, ptr %335, align 2, !tbaa !12
  %350 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %322
  %351 = load i16, ptr %350, align 2, !tbaa !12
  %352 = sext i16 %351 to i32
  %353 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %322
  %354 = load i16, ptr %353, align 2, !tbaa !12
  %355 = sext i16 %354 to i32
  %356 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537122464 to ptr), i32 %322
  %357 = load i16, ptr %356, align 2, !tbaa !12
  %358 = sext i16 %357 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  call fastcc void @normal_of(i32 noundef range(i32 0, -2147483648) %322, ptr noundef %1, ptr noundef %2, ptr noundef %3) #10
  %359 = load i32, ptr %1, align 4
  %360 = load i32, ptr %2, align 4
  %361 = load i32, ptr %3, align 4
  br label %362

362:                                              ; preds = %542, %333
  %363 = phi i32 [ 0, %333 ], [ %543, %542 ]
  %364 = icmp eq i32 %363, 360
  br i1 %364, label %544, label %365

365:                                              ; preds = %362
  %366 = icmp eq i32 %363, %322
  br i1 %366, label %542, label %367

367:                                              ; preds = %365
  %368 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121024 to ptr), i32 %363
  %369 = load i16, ptr %368, align 2, !tbaa !12
  %370 = sext i16 %369 to i32
  %371 = sub nsw i32 %370, %352
  %372 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121744 to ptr), i32 %363
  %373 = load i16, ptr %372, align 2, !tbaa !12
  %374 = sext i16 %373 to i32
  %375 = sub nsw i32 %374, %355
  %376 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537122464 to ptr), i32 %363
  %377 = load i16, ptr %376, align 2, !tbaa !12
  %378 = sext i16 %377 to i32
  %379 = sub nsw i32 %378, %358
  %380 = mul nsw i32 %371, %359
  %381 = mul nsw i32 %375, %360
  %382 = add nsw i32 %381, %380
  %383 = mul nsw i32 %379, %361
  %384 = add nsw i32 %382, %383
  %385 = ashr i32 %384, 8
  %386 = icmp slt i32 %385, 1
  br i1 %386, label %542, label %387

387:                                              ; preds = %367
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #9
  call fastcc void @normal_of(i32 noundef %363, ptr noundef %4, ptr noundef %5, ptr noundef %6) #10
  %388 = load i32, ptr %4, align 4, !tbaa !3
  %389 = mul nsw i32 %388, %371
  %390 = load i32, ptr %5, align 4, !tbaa !3
  %391 = mul nsw i32 %390, %375
  %392 = add nsw i32 %391, %389
  %393 = load i32, ptr %6, align 4, !tbaa !3
  %394 = mul nsw i32 %393, %379
  %395 = add nsw i32 %392, %394
  %396 = ashr i32 %395, 8
  %397 = icmp sgt i32 %396, -1
  br i1 %397, label %541, label %398

398:                                              ; preds = %387
  %399 = mul nsw i32 %371, %371
  %400 = mul nsw i32 %375, %375
  %401 = add nuw i32 %400, %399
  %402 = mul nsw i32 %379, %379
  %403 = add i32 %401, %402
  %404 = icmp ult i32 %403, 64
  br i1 %404, label %541, label %405

405:                                              ; preds = %398
  %406 = load i16, ptr %350, align 2, !tbaa !12
  %407 = sext i16 %406 to i32
  %408 = load i16, ptr %353, align 2, !tbaa !12
  %409 = sext i16 %408 to i32
  %410 = load i16, ptr %356, align 2, !tbaa !12
  %411 = sext i16 %410 to i32
  %412 = sub nsw i32 %370, %407
  %413 = sub nsw i32 %374, %409
  %414 = sub nsw i32 %378, %411
  %415 = tail call i16 @llvm.smin.i16(i16 %406, i16 %369)
  %416 = sext i16 %415 to i32
  %417 = add nsw i32 %407, %370
  %418 = sub nsw i32 %417, %416
  %419 = tail call i16 @llvm.smin.i16(i16 %410, i16 %377)
  %420 = sext i16 %419 to i32
  %421 = add nsw i32 %411, %378
  %422 = sub nsw i32 %421, %420
  %423 = icmp sgt i32 %418, -89
  %424 = icmp slt i16 %415, 5
  %425 = and i1 %424, %423
  %426 = icmp sgt i32 %422, 283
  %427 = icmp slt i16 %419, 377
  %428 = and i1 %427, %426
  %429 = select i1 %425, i1 %428, i1 false
  %430 = icmp sgt i32 %418, -2
  %431 = icmp slt i16 %415, 92
  %432 = and i1 %431, %430
  %433 = icmp sgt i32 %422, 221
  %434 = icmp slt i16 %419, 315
  %435 = and i1 %434, %433
  %436 = select i1 %432, i1 %435, i1 false
  %437 = select i1 %429, i1 true, i1 %436
  br i1 %437, label %438, label %467

438:                                              ; preds = %405, %462
  %439 = phi i32 [ %463, %462 ], [ 0, %405 ]
  %440 = phi i32 [ %464, %462 ], [ 1, %405 ]
  %441 = icmp eq i32 %440, 6
  br i1 %441, label %465, label %442

442:                                              ; preds = %438
  %443 = mul nuw nsw i32 %440, 43
  %444 = mul nsw i32 %443, %412
  %445 = ashr i32 %444, 8
  %446 = add nsw i32 %445, %407
  %447 = mul nsw i32 %443, %413
  %448 = ashr i32 %447, 8
  %449 = add nsw i32 %448, %409
  %450 = mul nsw i32 %443, %414
  %451 = ashr i32 %450, 8
  %452 = add nsw i32 %451, %411
  br i1 %429, label %453, label %456

453:                                              ; preds = %442
  %454 = tail call fastcc i32 @in_box(i32 noundef 0, i32 noundef %446, i32 noundef %449, i32 noundef %452) #10
  %455 = icmp eq i32 %454, 0
  br i1 %455, label %456, label %462

456:                                              ; preds = %453, %442
  br i1 %436, label %457, label %460

457:                                              ; preds = %456
  %458 = tail call fastcc i32 @in_box(i32 noundef 1, i32 noundef %446, i32 noundef %449, i32 noundef %452) #10
  %459 = icmp eq i32 %458, 0
  br i1 %459, label %460, label %462

460:                                              ; preds = %457, %456
  %461 = add nsw i32 %439, 1
  br label %462

462:                                              ; preds = %460, %457, %453
  %463 = phi i32 [ %461, %460 ], [ %439, %457 ], [ %439, %453 ]
  %464 = add nuw nsw i32 %440, 1
  br label %438, !llvm.loop !24

465:                                              ; preds = %438
  %466 = icmp eq i32 %439, 0
  br i1 %466, label %541, label %467

467:                                              ; preds = %465, %405
  %468 = phi i32 [ %439, %465 ], [ 5, %405 ]
  %469 = mul i32 %385, -1024
  %470 = mul i32 %469, %396
  %471 = udiv i32 %470, %403
  %472 = udiv i32 921600, %403
  %473 = tail call i32 @llvm.umin.i32(i32 %472, i32 4096)
  %474 = mul i32 %471, 41
  %475 = mul i32 %474, %473
  %476 = lshr i32 %475, 15
  %477 = mul nsw i32 %468, 51
  %478 = mul i32 %477, %476
  %479 = icmp ult i32 %478, 256
  br i1 %479, label %541, label %480

480:                                              ; preds = %467
  %481 = lshr i32 %478, 8
  %482 = tail call i32 @llvm.umin.i32(i32 %363, i32 320)
  %483 = lshr i32 %482, 6
  %484 = getelementptr inbounds nuw [6 x [3 x i16]], ptr @rho, i32 0, i32 %483
  %485 = mul i32 %481, %339
  %486 = lshr i32 %485, 12
  %487 = load i16, ptr %484, align 2, !tbaa !12
  %488 = zext i16 %487 to i32
  %489 = mul i32 %486, %488
  %490 = lshr i32 %489, 8
  %491 = mul i32 %481, %344
  %492 = lshr i32 %491, 12
  %493 = getelementptr inbounds nuw i8, ptr %484, i32 2
  %494 = load i16, ptr %493, align 2, !tbaa !12
  %495 = zext i16 %494 to i32
  %496 = mul i32 %492, %495
  %497 = lshr i32 %496, 8
  %498 = mul i32 %481, %349
  %499 = lshr i32 %498, 12
  %500 = getelementptr inbounds nuw i8, ptr %484, i32 4
  %501 = load i16, ptr %500, align 2, !tbaa !12
  %502 = zext i16 %501 to i32
  %503 = mul i32 %499, %502
  %504 = lshr i32 %503, 8
  %505 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123184 to ptr), i32 %363
  %506 = load i16, ptr %505, align 2, !tbaa !12
  %507 = zext i16 %506 to i32
  %508 = add nuw nsw i32 %490, %507
  %509 = tail call i32 @llvm.umin.i32(i32 %508, i32 65535)
  %510 = trunc nuw i32 %509 to i16
  store i16 %510, ptr %505, align 2, !tbaa !12
  %511 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123904 to ptr), i32 %363
  %512 = load i16, ptr %511, align 2, !tbaa !12
  %513 = zext i16 %512 to i32
  %514 = add nuw nsw i32 %497, %513
  %515 = tail call i32 @llvm.umin.i32(i32 %514, i32 65535)
  %516 = trunc nuw i32 %515 to i16
  store i16 %516, ptr %511, align 2, !tbaa !12
  %517 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124624 to ptr), i32 %363
  %518 = load i16, ptr %517, align 2, !tbaa !12
  %519 = zext i16 %518 to i32
  %520 = add nuw nsw i32 %504, %519
  %521 = tail call i32 @llvm.umin.i32(i32 %520, i32 65535)
  %522 = trunc nuw i32 %521 to i16
  store i16 %522, ptr %517, align 2, !tbaa !12
  %523 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125344 to ptr), i32 %363
  %524 = load i16, ptr %523, align 2, !tbaa !12
  %525 = zext i16 %524 to i32
  %526 = add nuw nsw i32 %490, %525
  %527 = tail call i32 @llvm.umin.i32(i32 %526, i32 65535)
  %528 = trunc nuw i32 %527 to i16
  store i16 %528, ptr %523, align 2, !tbaa !12
  %529 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126064 to ptr), i32 %363
  %530 = load i16, ptr %529, align 2, !tbaa !12
  %531 = zext i16 %530 to i32
  %532 = add nuw nsw i32 %497, %531
  %533 = tail call i32 @llvm.umin.i32(i32 %532, i32 65535)
  %534 = trunc nuw i32 %533 to i16
  store i16 %534, ptr %529, align 2, !tbaa !12
  %535 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126784 to ptr), i32 %363
  %536 = load i16, ptr %535, align 2, !tbaa !12
  %537 = zext i16 %536 to i32
  %538 = add nuw nsw i32 %504, %537
  %539 = tail call i32 @llvm.umin.i32(i32 %538, i32 65535)
  %540 = trunc nuw i32 %539 to i16
  store i16 %540, ptr %535, align 2, !tbaa !12
  br label %541

541:                                              ; preds = %480, %467, %465, %398, %387
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #9
  br label %542

542:                                              ; preds = %541, %367, %365
  %543 = add nuw nsw i32 %363, 1
  br label %362, !llvm.loop !25

544:                                              ; preds = %362
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #9
  %545 = add i32 %277, 1
  tail call fastcc void @repaint(i32 noundef 0) #10
  %546 = and i32 %545, 15
  %547 = icmp eq i32 %546, 0
  br i1 %547, label %548, label %549

548:                                              ; preds = %544
  tail call void @uputs(ptr noundef nonnull @.str.4) #8
  tail call void @uputn(i32 noundef %545) #8
  tail call void @uputs(ptr noundef nonnull @.str.5) #8
  br label %549

549:                                              ; preds = %548, %544
  br label %276
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @repaint(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = alloca [4 x i32], align 4
  %3 = alloca [4 x i32], align 4
  %4 = alloca [4 x i32], align 4
  %5 = icmp eq i32 %0, 0
  br label %6

6:                                                ; preds = %125, %1
  %7 = phi i32 [ 0, %1 ], [ %127, %125 ]
  %8 = phi i32 [ 0, %1 ], [ %126, %125 ]
  %9 = icmp eq i32 %7, 320
  br i1 %9, label %10, label %19

10:                                               ; preds = %6
  %11 = icmp eq i32 %8, 0
  %12 = select i1 %5, i1 %11, i1 false
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %14 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %15 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %16 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %17 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %18 = getelementptr inbounds nuw i8, ptr %4, i32 12
  br label %128

19:                                               ; preds = %6
  %20 = tail call fastcc zeroext i16 @patch_color(i32 noundef %7) #10
  br i1 %5, label %21, label %25

21:                                               ; preds = %19
  %22 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127504 to ptr), i32 %7
  %23 = load i16, ptr %22, align 2, !tbaa !12
  %24 = icmp eq i16 %20, %23
  br i1 %24, label %125, label %25

25:                                               ; preds = %21, %19
  %26 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127504 to ptr), i32 %7
  store i16 %20, ptr %26, align 2, !tbaa !12
  %27 = lshr i32 %7, 6
  %28 = and i32 %7, 7
  %29 = lshr i32 %7, 3
  %30 = and i32 %29, 7
  %31 = mul nuw nsw i32 %30, 9
  %32 = add nuw nsw i32 %31, %28
  %33 = mul nuw nsw i32 %27, 324
  %34 = getelementptr i8, ptr inttoptr (i32 537128224 to ptr), i32 %33
  %35 = shl nuw nsw i32 %32, 2
  %36 = getelementptr i8, ptr %34, i32 %35
  %37 = add nuw nsw i32 %28, 1
  %38 = add nuw nsw i32 %31, %37
  %39 = shl nuw nsw i32 %38, 2
  %40 = getelementptr i8, ptr %34, i32 %39
  %41 = add nuw nsw i32 %31, 9
  %42 = add nuw nsw i32 %41, %28
  %43 = shl nuw nsw i32 %42, 2
  %44 = getelementptr i8, ptr %34, i32 %43
  %45 = add nuw nsw i32 %41, %37
  %46 = shl nuw nsw i32 %45, 2
  %47 = getelementptr i8, ptr %34, i32 %46
  switch i32 %27, label %108 [
    i32 0, label %48
    i32 1, label %61
    i32 2, label %76
    i32 3, label %91
  ]

48:                                               ; preds = %25
  %49 = load i16, ptr %36, align 4, !tbaa !12
  %50 = sext i16 %49 to i32
  %51 = getelementptr inbounds nuw i8, ptr %36, i32 2
  %52 = load i16, ptr %51, align 2, !tbaa !12
  %53 = sext i16 %52 to i32
  %54 = load i16, ptr %47, align 4, !tbaa !12
  %55 = sext i16 %54 to i32
  %56 = sub nsw i32 %55, %50
  %57 = getelementptr inbounds nuw i8, ptr %47, i32 2
  %58 = load i16, ptr %57, align 2, !tbaa !12
  %59 = sext i16 %58 to i32
  %60 = sub nsw i32 %59, %53
  tail call void @gfx_fill(i32 noundef %50, i32 noundef %53, i32 noundef %56, i32 noundef %60, i16 noundef zeroext %20) #8
  br label %125

61:                                               ; preds = %25
  %62 = getelementptr inbounds nuw i8, ptr %44, i32 2
  %63 = load i16, ptr %62, align 2, !tbaa !12
  %64 = sext i16 %63 to i32
  %65 = getelementptr inbounds nuw i8, ptr %36, i32 2
  %66 = load i16, ptr %65, align 2, !tbaa !12
  %67 = sext i16 %66 to i32
  %68 = load i16, ptr %44, align 4, !tbaa !12
  %69 = sext i16 %68 to i32
  %70 = load i16, ptr %36, align 4, !tbaa !12
  %71 = sext i16 %70 to i32
  %72 = load i16, ptr %47, align 4, !tbaa !12
  %73 = sext i16 %72 to i32
  %74 = load i16, ptr %40, align 4, !tbaa !12
  %75 = sext i16 %74 to i32
  tail call fastcc void @fill_htrap(i32 noundef %64, i32 noundef %67, i32 noundef %69, i32 noundef %71, i32 noundef %73, i32 noundef %75, i16 noundef zeroext %20) #10
  br label %125

76:                                               ; preds = %25
  %77 = getelementptr inbounds nuw i8, ptr %36, i32 2
  %78 = load i16, ptr %77, align 2, !tbaa !12
  %79 = sext i16 %78 to i32
  %80 = getelementptr inbounds nuw i8, ptr %44, i32 2
  %81 = load i16, ptr %80, align 2, !tbaa !12
  %82 = sext i16 %81 to i32
  %83 = load i16, ptr %36, align 4, !tbaa !12
  %84 = sext i16 %83 to i32
  %85 = load i16, ptr %44, align 4, !tbaa !12
  %86 = sext i16 %85 to i32
  %87 = load i16, ptr %40, align 4, !tbaa !12
  %88 = sext i16 %87 to i32
  %89 = load i16, ptr %47, align 4, !tbaa !12
  %90 = sext i16 %89 to i32
  tail call fastcc void @fill_htrap(i32 noundef %79, i32 noundef %82, i32 noundef %84, i32 noundef %86, i32 noundef %88, i32 noundef %90, i16 noundef zeroext %20) #10
  br label %125

91:                                               ; preds = %25
  %92 = load i16, ptr %36, align 4, !tbaa !12
  %93 = sext i16 %92 to i32
  %94 = load i16, ptr %44, align 4, !tbaa !12
  %95 = sext i16 %94 to i32
  %96 = getelementptr inbounds nuw i8, ptr %36, i32 2
  %97 = load i16, ptr %96, align 2, !tbaa !12
  %98 = sext i16 %97 to i32
  %99 = getelementptr inbounds nuw i8, ptr %44, i32 2
  %100 = load i16, ptr %99, align 2, !tbaa !12
  %101 = sext i16 %100 to i32
  %102 = getelementptr inbounds nuw i8, ptr %40, i32 2
  %103 = load i16, ptr %102, align 2, !tbaa !12
  %104 = sext i16 %103 to i32
  %105 = getelementptr inbounds nuw i8, ptr %47, i32 2
  %106 = load i16, ptr %105, align 2, !tbaa !12
  %107 = sext i16 %106 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %93, i32 noundef %95, i32 noundef %98, i32 noundef %101, i32 noundef %104, i32 noundef %107, i16 noundef zeroext %20) #10
  br label %125

108:                                              ; preds = %25
  %109 = load i16, ptr %44, align 4, !tbaa !12
  %110 = sext i16 %109 to i32
  %111 = load i16, ptr %36, align 4, !tbaa !12
  %112 = sext i16 %111 to i32
  %113 = getelementptr inbounds nuw i8, ptr %44, i32 2
  %114 = load i16, ptr %113, align 2, !tbaa !12
  %115 = sext i16 %114 to i32
  %116 = getelementptr inbounds nuw i8, ptr %36, i32 2
  %117 = load i16, ptr %116, align 2, !tbaa !12
  %118 = sext i16 %117 to i32
  %119 = getelementptr inbounds nuw i8, ptr %47, i32 2
  %120 = load i16, ptr %119, align 2, !tbaa !12
  %121 = sext i16 %120 to i32
  %122 = getelementptr inbounds nuw i8, ptr %40, i32 2
  %123 = load i16, ptr %122, align 2, !tbaa !12
  %124 = sext i16 %123 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %110, i32 noundef %112, i32 noundef %115, i32 noundef %118, i32 noundef %121, i32 noundef %124, i16 noundef zeroext %20) #10
  br label %125

125:                                              ; preds = %108, %91, %76, %61, %48, %21
  %126 = phi i32 [ %8, %21 ], [ 1, %48 ], [ 1, %61 ], [ 1, %76 ], [ 1, %91 ], [ 1, %108 ]
  %127 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !26

128:                                              ; preds = %10, %271
  %129 = phi i32 [ %272, %271 ], [ 320, %10 ]
  %130 = icmp eq i32 %129, 360
  br i1 %130, label %131, label %132

131:                                              ; preds = %128
  tail call void @gfx_present() #8
  ret void

132:                                              ; preds = %128
  %133 = tail call fastcc zeroext i16 @patch_color(i32 noundef %129) #10
  br i1 %12, label %134, label %138

134:                                              ; preds = %132
  %135 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127504 to ptr), i32 %129
  %136 = load i16, ptr %135, align 2, !tbaa !12
  %137 = icmp eq i16 %133, %136
  br i1 %137, label %271, label %138

138:                                              ; preds = %134, %132
  %139 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127504 to ptr), i32 %129
  store i16 %133, ptr %139, align 2, !tbaa !12
  %140 = trunc i32 %129 to i16
  %141 = add i16 %140, -320
  %142 = freeze i16 %141
  %143 = sdiv i16 %142, 4
  %144 = sext i16 %143 to i32
  %145 = getelementptr inbounds i16, ptr inttoptr (i32 537130344 to ptr), i32 %144
  %146 = load i16, ptr %145, align 2, !tbaa !12
  %147 = icmp eq i16 %146, 0
  br i1 %147, label %271, label %148

148:                                              ; preds = %138
  %149 = mul i16 %143, 4
  %150 = sub i16 %142, %149
  %151 = sext i16 %150 to i32
  %152 = and i32 %151, 1
  %153 = ashr i32 %151, 1
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #9
  %154 = mul nsw i32 %153, 3
  %155 = add nsw i32 %154, %152
  %156 = mul nsw i32 %144, 36
  %157 = getelementptr i8, ptr inttoptr (i32 537129904 to ptr), i32 %156
  %158 = shl nsw i32 %155, 2
  %159 = getelementptr i8, ptr %157, i32 %158
  %160 = add nuw nsw i32 %152, 1
  %161 = add nsw i32 %154, %160
  %162 = shl nsw i32 %161, 2
  %163 = getelementptr i8, ptr %157, i32 %162
  %164 = add nsw i32 %154, 3
  %165 = add nsw i32 %164, %160
  %166 = shl nsw i32 %165, 2
  %167 = getelementptr i8, ptr %157, i32 %166
  %168 = add nsw i32 %164, %152
  %169 = shl nsw i32 %168, 2
  %170 = getelementptr i8, ptr %157, i32 %169
  %171 = load i16, ptr %159, align 4, !tbaa !12
  %172 = sext i16 %171 to i32
  store i32 %172, ptr %3, align 4, !tbaa !3
  %173 = getelementptr inbounds nuw i8, ptr %159, i32 2
  %174 = load i16, ptr %173, align 2, !tbaa !12
  %175 = sext i16 %174 to i32
  store i32 %175, ptr %4, align 4, !tbaa !3
  %176 = load i16, ptr %163, align 4, !tbaa !12
  %177 = sext i16 %176 to i32
  store i32 %177, ptr %13, align 4, !tbaa !3
  %178 = getelementptr inbounds nuw i8, ptr %163, i32 2
  %179 = load i16, ptr %178, align 2, !tbaa !12
  %180 = sext i16 %179 to i32
  store i32 %180, ptr %14, align 4, !tbaa !3
  %181 = load i16, ptr %167, align 4, !tbaa !12
  %182 = sext i16 %181 to i32
  store i32 %182, ptr %15, align 4, !tbaa !3
  %183 = getelementptr inbounds nuw i8, ptr %167, i32 2
  %184 = load i16, ptr %183, align 2, !tbaa !12
  %185 = sext i16 %184 to i32
  store i32 %185, ptr %16, align 4, !tbaa !3
  %186 = load i16, ptr %170, align 4, !tbaa !12
  %187 = sext i16 %186 to i32
  store i32 %187, ptr %17, align 4, !tbaa !3
  %188 = getelementptr inbounds nuw i8, ptr %170, i32 2
  %189 = load i16, ptr %188, align 2, !tbaa !12
  %190 = sext i16 %189 to i32
  store i32 %190, ptr %18, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #9
  br label %191

191:                                              ; preds = %215, %148
  %192 = phi i32 [ 0, %148 ], [ %201, %215 ]
  %193 = phi i32 [ %172, %148 ], [ %200, %215 ]
  %194 = phi i32 [ %172, %148 ], [ %199, %215 ]
  %195 = icmp eq i32 %192, 4
  br i1 %195, label %218, label %196

196:                                              ; preds = %191
  %197 = getelementptr inbounds nuw i32, ptr %3, i32 %192
  %198 = load i32, ptr %197, align 4, !tbaa !3
  %199 = tail call i32 @llvm.smin.i32(i32 %198, i32 %194)
  %200 = tail call i32 @llvm.smax.i32(i32 %198, i32 %193)
  %201 = add nuw nsw i32 %192, 1
  %202 = and i32 %201, 3
  %203 = getelementptr inbounds nuw i32, ptr %3, i32 %202
  %204 = load i32, ptr %203, align 4, !tbaa !3
  %205 = icmp eq i32 %204, %198
  br i1 %205, label %215, label %206

206:                                              ; preds = %196
  %207 = sub nsw i32 %204, %198
  %208 = getelementptr inbounds nuw i32, ptr %4, i32 %202
  %209 = load i32, ptr %208, align 4, !tbaa !3
  %210 = getelementptr inbounds nuw i32, ptr %4, i32 %192
  %211 = load i32, ptr %210, align 4, !tbaa !3
  %212 = sub nsw i32 %209, %211
  %213 = shl i32 %212, 12
  %214 = sdiv i32 %213, %207
  br label %215

215:                                              ; preds = %206, %196
  %216 = phi i32 [ %214, %206 ], [ 0, %196 ]
  %217 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %192
  store i32 %216, ptr %217, align 4, !tbaa !3
  br label %191, !llvm.loop !27

218:                                              ; preds = %191, %268
  %219 = phi i32 [ %269, %268 ], [ %194, %191 ]
  %220 = icmp sgt i32 %219, %193
  br i1 %220, label %270, label %221

221:                                              ; preds = %218, %254
  %222 = phi i32 [ %255, %254 ], [ 32767, %218 ]
  %223 = phi i32 [ %256, %254 ], [ -32768, %218 ]
  %224 = phi i32 [ %233, %254 ], [ 0, %218 ]
  br label %225

225:                                              ; preds = %242, %221
  %226 = phi i32 [ %224, %221 ], [ %233, %242 ]
  %227 = icmp eq i32 %226, 4
  br i1 %227, label %228, label %230

228:                                              ; preds = %225
  %229 = icmp sgt i32 %223, %222
  br i1 %229, label %266, label %268

230:                                              ; preds = %225
  %231 = getelementptr inbounds nuw i32, ptr %3, i32 %226
  %232 = load i32, ptr %231, align 4, !tbaa !3
  %233 = add nuw nsw i32 %226, 1
  %234 = and i32 %233, 3
  %235 = getelementptr inbounds nuw i32, ptr %3, i32 %234
  %236 = load i32, ptr %235, align 4, !tbaa !3
  %237 = tail call i32 @llvm.smin.i32(i32 %232, i32 %236)
  %238 = icmp slt i32 %219, %237
  br i1 %238, label %242, label %239

239:                                              ; preds = %230
  %240 = tail call i32 @llvm.smax.i32(i32 %232, i32 %236)
  %241 = icmp sgt i32 %219, %240
  br i1 %241, label %242, label %243

242:                                              ; preds = %239, %230
  br label %225, !llvm.loop !28

243:                                              ; preds = %239
  %244 = icmp eq i32 %232, %236
  %245 = getelementptr inbounds nuw i32, ptr %4, i32 %226
  %246 = load i32, ptr %245, align 4, !tbaa !3
  br i1 %244, label %247, label %257

247:                                              ; preds = %243
  %248 = getelementptr inbounds nuw i32, ptr %4, i32 %234
  %249 = load i32, ptr %248, align 4, !tbaa !3
  %250 = tail call i32 @llvm.smin.i32(i32 %249, i32 %246)
  %251 = tail call i32 @llvm.smax.i32(i32 %249, i32 %246)
  %252 = tail call i32 @llvm.smin.i32(i32 %250, i32 %222)
  %253 = tail call i32 @llvm.smax.i32(i32 %251, i32 %223)
  br label %254

254:                                              ; preds = %247, %257
  %255 = phi i32 [ %264, %257 ], [ %252, %247 ]
  %256 = phi i32 [ %265, %257 ], [ %253, %247 ]
  br label %221, !llvm.loop !28

257:                                              ; preds = %243
  %258 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %226
  %259 = load i32, ptr %258, align 4, !tbaa !3
  %260 = sub nsw i32 %219, %232
  %261 = mul nsw i32 %259, %260
  %262 = ashr i32 %261, 12
  %263 = add nsw i32 %262, %246
  %264 = tail call i32 @llvm.smin.i32(i32 %263, i32 %222)
  %265 = tail call i32 @llvm.smax.i32(i32 %263, i32 %223)
  br label %254

266:                                              ; preds = %228
  %267 = sub nsw i32 %223, %222
  tail call void @gfx_fill(i32 noundef %219, i32 noundef %222, i32 noundef 1, i32 noundef %267, i16 noundef zeroext %133) #8
  br label %268

268:                                              ; preds = %266, %228
  %269 = add nsw i32 %219, 1
  br label %218, !llvm.loop !29

270:                                              ; preds = %218
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #9
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #9
  br label %271

271:                                              ; preds = %270, %138, %134
  %272 = add nuw nsw i32 %129, 1
  br label %128, !llvm.loop !30
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write)
define internal fastcc void @face_point(i32 noundef range(i32 -2147483648, 10) %0, i32 noundef range(i32 -2147483648, 3) %1, i32 noundef range(i32 -2147483648, 3) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %4, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %5) unnamed_addr #3 {
  %7 = srem i32 %0, 5
  %8 = mul nsw i32 %1, 36
  %9 = add nsw i32 %8, -36
  switch i32 %7, label %13 [
    i32 0, label %16
    i32 1, label %10
    i32 2, label %11
    i32 3, label %12
  ]

10:                                               ; preds = %6
  br label %16

11:                                               ; preds = %6
  br label %16

12:                                               ; preds = %6
  br label %16

13:                                               ; preds = %6
  %14 = mul nsw i32 %2, 36
  %15 = add nsw i32 %14, -36
  br label %16

16:                                               ; preds = %6, %13, %12, %11, %10
  %17 = phi i32 [ %9, %13 ], [ -36, %10 ], [ %9, %11 ], [ %9, %12 ], [ 36, %6 ]
  %18 = phi i32 [ %15, %13 ], [ %9, %10 ], [ 36, %11 ], [ -36, %12 ], [ %9, %6 ]
  %19 = add nsw i32 %0, 4
  %20 = icmp ult i32 %19, 9
  %21 = select i1 %20, i32 -30, i32 48
  %22 = sub nsw i32 120, %21
  %23 = mul nsw i32 %22, %2
  %24 = ashr exact i32 %23, 1
  %25 = select i1 %20, i32 245, i32 243
  %26 = select i1 %20, i32 -75, i32 79
  %27 = select i1 %20, i32 -42, i32 45
  %28 = select i1 %20, i32 75, i32 -79
  %29 = select i1 %20, i32 330, i32 268
  %30 = mul nsw i32 %17, %25
  %31 = mul i32 %18, %26
  %32 = add i32 %31, %30
  %33 = ashr i32 %32, 8
  %34 = add nsw i32 %33, %27
  %35 = mul nsw i32 %17, %28
  %36 = mul nsw i32 %18, %25
  %37 = add nsw i32 %36, %35
  %38 = ashr i32 %37, 8
  %39 = add nsw i32 %38, %29
  store i32 %34, ptr %3, align 4, !tbaa !3
  store i32 %39, ptr %5, align 4, !tbaa !3
  %40 = icmp eq i32 %7, 4
  %41 = select i1 %40, i32 0, i32 %24
  %42 = add nsw i32 %41, %21
  store i32 %42, ptr %4, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @is_light(i32 noundef range(i32 -2147483648, 360) %0) unnamed_addr #4 {
  %2 = and i32 %0, -64
  %3 = icmp eq i32 %2, 128
  br i1 %3, label %4, label %14

4:                                                ; preds = %1
  %5 = and i32 %0, 7
  %6 = add nsw i32 %5, -3
  %7 = icmp ult i32 %6, 2
  br i1 %7, label %8, label %14

8:                                                ; preds = %4
  %9 = lshr i32 %0, 3
  %10 = and i32 %9, 7
  %11 = add nsw i32 %10, -3
  %12 = icmp ult i32 %11, 2
  %13 = zext i1 %12 to i32
  br label %14

14:                                               ; preds = %4, %8, %1
  %15 = phi i32 [ 0, %1 ], [ %13, %8 ], [ 0, %4 ]
  ret i32 %15
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc zeroext i16 @patch_color(i32 noundef range(i32 -2147483648, 360) %0) unnamed_addr #5 {
  %2 = tail call fastcc i32 @is_light(i32 noundef %0) #10
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %24

4:                                                ; preds = %1
  %5 = getelementptr inbounds i16, ptr inttoptr (i32 537123184 to ptr), i32 %0
  %6 = load i16, ptr %5, align 2, !tbaa !12
  %7 = lshr i16 %6, 3
  %8 = tail call i16 @llvm.umin.i16(i16 %7, i16 255)
  %9 = shl nuw i16 %8, 8
  %10 = and i16 %9, -2048
  %11 = getelementptr inbounds i16, ptr inttoptr (i32 537123904 to ptr), i32 %0
  %12 = load i16, ptr %11, align 2, !tbaa !12
  %13 = lshr i16 %12, 3
  %14 = tail call i16 @llvm.umin.i16(i16 %13, i16 255)
  %15 = shl nuw nsw i16 %14, 3
  %16 = and i16 %15, 2016
  %17 = or disjoint i16 %16, %10
  %18 = getelementptr inbounds i16, ptr inttoptr (i32 537124624 to ptr), i32 %0
  %19 = load i16, ptr %18, align 2, !tbaa !12
  %20 = lshr i16 %19, 3
  %21 = tail call i16 @llvm.umin.i16(i16 %20, i16 255)
  %22 = lshr i16 %21, 3
  %23 = or disjoint i16 %17, %22
  br label %24

24:                                               ; preds = %1, %4
  %25 = phi i16 [ %23, %4 ], [ -2, %1 ]
  ret i16 %25
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fill_htrap(i32 noundef range(i32 -32768, 32768) %0, i32 noundef range(i32 -32768, 32768) %1, i32 noundef range(i32 -32768, 32768) %2, i32 noundef range(i32 -32768, 32768) %3, i32 noundef range(i32 -32768, 32768) %4, i32 noundef range(i32 -32768, 32768) %5, i16 noundef zeroext %6) unnamed_addr #0 {
  %8 = sub nsw i32 %1, %0
  %9 = icmp slt i32 %8, 1
  br i1 %9, label %34, label %10

10:                                               ; preds = %7
  %11 = shl nsw i32 %2, 12
  %12 = shl nsw i32 %4, 12
  %13 = sub nsw i32 %3, %2
  %14 = shl nsw i32 %13, 12
  %15 = sdiv i32 %14, %8
  %16 = sub nsw i32 %5, %4
  %17 = shl nsw i32 %16, 12
  %18 = sdiv i32 %17, %8
  br label %19

19:                                               ; preds = %30, %10
  %20 = phi i32 [ %12, %10 ], [ %32, %30 ]
  %21 = phi i32 [ %0, %10 ], [ %33, %30 ]
  %22 = phi i32 [ %11, %10 ], [ %31, %30 ]
  %23 = icmp slt i32 %21, %1
  br i1 %23, label %24, label %34

24:                                               ; preds = %19
  %25 = ashr i32 %22, 12
  %26 = ashr i32 %20, 12
  %27 = icmp sgt i32 %26, %25
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = sub nsw i32 %26, %25
  tail call void @gfx_fill(i32 noundef %25, i32 noundef %21, i32 noundef %29, i32 noundef 1, i16 noundef zeroext %6) #8
  br label %30

30:                                               ; preds = %28, %24
  %31 = add nsw i32 %22, %15
  %32 = add nsw i32 %20, %18
  %33 = add nsw i32 %21, 1
  br label %19, !llvm.loop !31

34:                                               ; preds = %19, %7
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fill_vtrap(i32 noundef range(i32 -32768, 32768) %0, i32 noundef range(i32 -32768, 32768) %1, i32 noundef range(i32 -32768, 32768) %2, i32 noundef range(i32 -32768, 32768) %3, i32 noundef range(i32 -32768, 32768) %4, i32 noundef range(i32 -32768, 32768) %5, i16 noundef zeroext %6) unnamed_addr #0 {
  %8 = sub nsw i32 %1, %0
  %9 = icmp slt i32 %8, 1
  br i1 %9, label %34, label %10

10:                                               ; preds = %7
  %11 = shl nsw i32 %2, 12
  %12 = shl nsw i32 %4, 12
  %13 = sub nsw i32 %3, %2
  %14 = shl nsw i32 %13, 12
  %15 = sdiv i32 %14, %8
  %16 = sub nsw i32 %5, %4
  %17 = shl nsw i32 %16, 12
  %18 = sdiv i32 %17, %8
  br label %19

19:                                               ; preds = %30, %10
  %20 = phi i32 [ %12, %10 ], [ %32, %30 ]
  %21 = phi i32 [ %0, %10 ], [ %33, %30 ]
  %22 = phi i32 [ %11, %10 ], [ %31, %30 ]
  %23 = icmp slt i32 %21, %1
  br i1 %23, label %24, label %34

24:                                               ; preds = %19
  %25 = ashr i32 %22, 12
  %26 = ashr i32 %20, 12
  %27 = icmp sgt i32 %26, %25
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = sub nsw i32 %26, %25
  tail call void @gfx_fill(i32 noundef %21, i32 noundef %25, i32 noundef 1, i32 noundef %29, i16 noundef zeroext %6) #8
  br label %30

30:                                               ; preds = %28, %24
  %31 = add nsw i32 %22, %15
  %32 = add nsw i32 %20, %18
  %33 = add nsw i32 %21, 1
  br label %19, !llvm.loop !32

34:                                               ; preds = %19, %7
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: readwrite, inaccessiblemem: none)
define internal fastcc void @normal_of(i32 noundef %0, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #6 {
  %5 = icmp sgt i32 %0, 319
  br i1 %5, label %6, label %19

6:                                                ; preds = %4
  %7 = add nsw i32 %0, -320
  %8 = lshr i32 %7, 2
  %9 = mul nuw nsw i32 %8, 6
  %10 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130264 to ptr), i32 %9
  %11 = load i16, ptr %10, align 2, !tbaa !12
  %12 = sext i16 %11 to i32
  store i32 %12, ptr %1, align 4, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 2
  %14 = load i16, ptr %13, align 2, !tbaa !12
  %15 = sext i16 %14 to i32
  store i32 %15, ptr %2, align 4, !tbaa !3
  %16 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %17 = load i16, ptr %16, align 2, !tbaa !12
  %18 = sext i16 %17 to i32
  br label %26

19:                                               ; preds = %4
  %20 = sdiv i32 %0, 64
  switch i32 %20, label %25 [
    i32 0, label %21
    i32 1, label %22
    i32 2, label %23
    i32 3, label %24
  ]

21:                                               ; preds = %19
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %26

22:                                               ; preds = %19
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 -256, ptr %2, align 4, !tbaa !3
  br label %26

23:                                               ; preds = %19
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 256, ptr %2, align 4, !tbaa !3
  br label %26

24:                                               ; preds = %19
  store i32 256, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %26

25:                                               ; preds = %19
  store i32 -256, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %26

26:                                               ; preds = %6, %25, %24, %23, %22, %21
  %27 = phi i32 [ %18, %6 ], [ 0, %25 ], [ 0, %24 ], [ 0, %23 ], [ 0, %22 ], [ -256, %21 ]
  store i32 %27, ptr %3, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @in_box(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 -8421376, 8421375) %1, i32 noundef range(i32 -8421376, 8421375) %2, i32 noundef range(i32 -8421376, 8421375) %3) unnamed_addr #4 {
  %5 = icmp eq i32 %0, 0
  %6 = select i1 %5, i32 -30, i32 48
  %7 = icmp sgt i32 %2, %6
  br i1 %7, label %8, label %29

8:                                                ; preds = %4
  %9 = select i1 %5, i32 42, i32 -45
  %10 = select i1 %5, i32 75, i32 -79
  %11 = select i1 %5, i32 245, i32 243
  %12 = select i1 %5, i32 -330, i32 -268
  %13 = add nsw i32 %9, %1
  %14 = add nsw i32 %3, %12
  %15 = mul nsw i32 %13, %11
  %16 = mul nsw i32 %14, %10
  %17 = add nsw i32 %16, %15
  %18 = ashr i32 %17, 8
  %19 = mul nsw i32 %14, %11
  %20 = mul nsw i32 %13, %10
  %21 = sub nsw i32 %19, %20
  %22 = ashr i32 %21, 8
  %23 = add nsw i32 %18, 35
  %24 = icmp ult i32 %23, 71
  %25 = add nsw i32 %22, 35
  %26 = icmp ult i32 %25, 71
  %27 = select i1 %24, i1 %26, i1 false
  %28 = zext i1 %27 to i32
  br label %29

29:                                               ; preds = %4, %8
  %30 = phi i32 [ %28, %8 ], [ 0, %4 ]
  ret i32 %30
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.umin.i16(i16, i16) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #7

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #9 = { nounwind }
attributes #10 = { minsize nobuiltin optsize "no-builtins" }

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
!12 = !{!13, !13, i64 0}
!13 = !{!"short", !5, i64 0}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !8, !9}
!28 = distinct !{!28, !8, !9}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
