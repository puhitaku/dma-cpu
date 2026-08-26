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
  %10 = alloca [11 x i32], align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  tail call void @uputs(ptr noundef nonnull @.str) #11
  tail call void @led(i32 noundef 984577, i32 noundef 984577) #11
  tail call void @gfx_clear(i16 noundef zeroext 2114) #11
  call void @llvm.lifetime.start.p0(i64 44, ptr nonnull %10) #12
  br label %14

14:                                               ; preds = %20, %0
  %15 = phi i32 [ 0, %0 ], [ %25, %20 ]
  %16 = icmp eq i32 %15, 11
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %10, i32 40
  %19 = load i32, ptr %18, align 4
  br label %26

20:                                               ; preds = %14
  %21 = mul nuw nsw i32 %15, 24
  %22 = add nuw nsw i32 %21, 200
  %23 = udiv i32 819200, %22
  %24 = getelementptr inbounds nuw [11 x i32], ptr %10, i32 0, i32 %15
  store i32 %23, ptr %24, align 4, !tbaa !3
  %25 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !7

26:                                               ; preds = %43, %17
  %27 = phi i32 [ %44, %43 ], [ 0, %17 ]
  %28 = icmp eq i32 %27, 5
  br i1 %28, label %99, label %29

29:                                               ; preds = %26
  %30 = mul nuw nsw i32 %27, 242
  %31 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537129872 to ptr), i32 %30
  br label %32

32:                                               ; preds = %48, %29
  %33 = phi i32 [ %49, %48 ], [ 0, %29 ]
  %34 = icmp eq i32 %33, 11
  br i1 %34, label %43, label %35

35:                                               ; preds = %32
  %36 = mul nuw nsw i32 %33, 11
  %37 = getelementptr inbounds nuw [11 x i32], ptr %10, i32 0, i32 %33
  %38 = mul nuw nsw i32 %33, 24
  %39 = add nsw i32 %38, -120
  %40 = mul nsw i32 %39, %19
  %41 = ashr i32 %40, 12
  %42 = add nsw i32 %41, 120
  br label %45

43:                                               ; preds = %32
  %44 = add nuw nsw i32 %27, 1
  br label %26, !llvm.loop !10

45:                                               ; preds = %89, %35
  %46 = phi i32 [ %98, %89 ], [ 0, %35 ]
  %47 = icmp eq i32 %46, 11
  br i1 %47, label %48, label %50

48:                                               ; preds = %45
  %49 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !11

50:                                               ; preds = %45
  %51 = mul nuw nsw i32 %46, 24
  %52 = add nsw i32 %51, -120
  switch i32 %27, label %81 [
    i32 0, label %53
    i32 1, label %57
    i32 2, label %65
    i32 3, label %73
  ]

53:                                               ; preds = %50
  %54 = mul nsw i32 %52, %19
  %55 = ashr i32 %54, 12
  %56 = add nsw i32 %55, 120
  br label %89

57:                                               ; preds = %50
  %58 = load i32, ptr %37, align 4, !tbaa !3
  %59 = mul nsw i32 %58, %52
  %60 = ashr i32 %59, 12
  %61 = add nsw i32 %60, 120
  %62 = mul nsw i32 %58, 120
  %63 = ashr i32 %62, 12
  %64 = add nsw i32 %63, 120
  br label %89

65:                                               ; preds = %50
  %66 = load i32, ptr %37, align 4, !tbaa !3
  %67 = mul nsw i32 %66, %52
  %68 = ashr i32 %67, 12
  %69 = add nsw i32 %68, 120
  %70 = mul nsw i32 %66, 120
  %71 = ashr i32 %70, 12
  %72 = sub nsw i32 120, %71
  br label %89

73:                                               ; preds = %50
  %74 = load i32, ptr %37, align 4, !tbaa !3
  %75 = mul nsw i32 %74, 120
  %76 = ashr i32 %75, 12
  %77 = sub nsw i32 120, %76
  %78 = mul nsw i32 %74, %52
  %79 = ashr i32 %78, 12
  %80 = add nsw i32 %79, 120
  br label %89

81:                                               ; preds = %50
  %82 = load i32, ptr %37, align 4, !tbaa !3
  %83 = mul nsw i32 %82, 120
  %84 = ashr i32 %83, 12
  %85 = add nsw i32 %84, 120
  %86 = mul nsw i32 %82, %52
  %87 = ashr i32 %86, 12
  %88 = add nsw i32 %87, 120
  br label %89

89:                                               ; preds = %81, %73, %65, %57, %53
  %90 = phi i32 [ %85, %81 ], [ %56, %53 ], [ %61, %57 ], [ %69, %65 ], [ %77, %73 ]
  %91 = phi i32 [ %88, %81 ], [ %42, %53 ], [ %64, %57 ], [ %72, %65 ], [ %80, %73 ]
  %92 = trunc i32 %90 to i8
  %93 = add nuw nsw i32 %46, %36
  %94 = shl nuw nsw i32 %93, 1
  %95 = getelementptr inbounds nuw i8, ptr %31, i32 %94
  store i8 %92, ptr %95, align 2, !tbaa !12
  %96 = trunc i32 %91 to i8
  %97 = getelementptr inbounds nuw i8, ptr %95, i32 1
  store i8 %96, ptr %97, align 1, !tbaa !12
  %98 = add nuw nsw i32 %46, 1
  br label %45, !llvm.loop !13

99:                                               ; preds = %26, %110
  %100 = phi i32 [ %111, %110 ], [ 0, %26 ]
  %101 = icmp eq i32 %100, 10
  br i1 %101, label %135, label %102

102:                                              ; preds = %99
  %103 = mul nuw nsw i32 %100, 50
  %104 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131084 to ptr), i32 %103
  br label %105

105:                                              ; preds = %115, %102
  %106 = phi i32 [ %116, %115 ], [ 0, %102 ]
  %107 = icmp eq i32 %106, 5
  br i1 %107, label %110, label %108

108:                                              ; preds = %105
  %109 = mul nuw nsw i32 %106, 5
  br label %112

110:                                              ; preds = %105
  %111 = add nuw nsw i32 %100, 1
  br label %99, !llvm.loop !14

112:                                              ; preds = %117, %108
  %113 = phi i32 [ %134, %117 ], [ 0, %108 ]
  %114 = icmp eq i32 %113, 5
  br i1 %114, label %115, label %117

115:                                              ; preds = %112
  %116 = add nuw nsw i32 %106, 1
  br label %105, !llvm.loop !15

117:                                              ; preds = %112
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #12
  call fastcc void @face_point(i32 noundef %100, i32 noundef %113, i32 noundef %106, ptr noundef %11, ptr noundef %12, ptr noundef %13) #13
  %118 = load i32, ptr %13, align 4, !tbaa !3
  %119 = udiv i32 819200, %118
  %120 = load i32, ptr %11, align 4, !tbaa !3
  %121 = mul nsw i32 %120, %119
  %122 = lshr i32 %121, 12
  %123 = trunc i32 %122 to i8
  %124 = add i8 %123, 120
  %125 = add nuw nsw i32 %113, %109
  %126 = shl nuw nsw i32 %125, 1
  %127 = getelementptr inbounds nuw i8, ptr %104, i32 %126
  store i8 %124, ptr %127, align 2, !tbaa !12
  %128 = load i32, ptr %12, align 4, !tbaa !3
  %129 = mul nsw i32 %128, %119
  %130 = lshr i32 %129, 12
  %131 = trunc i32 %130 to i8
  %132 = add i8 %131, 120
  %133 = getelementptr inbounds nuw i8, ptr %127, i32 1
  store i8 %132, ptr %133, align 1, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #12
  %134 = add nuw nsw i32 %113, 1
  br label %112, !llvm.loop !16

135:                                              ; preds = %99
  call void @llvm.lifetime.end.p0(i64 44, ptr nonnull %10) #12
  br label %136

136:                                              ; preds = %180, %135
  %137 = phi i32 [ 0, %135 ], [ %183, %180 ]
  %138 = icmp eq i32 %137, 500
  br i1 %138, label %184, label %139

139:                                              ; preds = %136
  %140 = trunc nuw i32 %137 to i16
  %141 = freeze i16 %140
  %142 = udiv i16 %141, 100
  %143 = urem i16 %140, 10
  %144 = mul i16 %142, 100
  %145 = sub i16 %141, %144
  %146 = trunc nuw nsw i16 %145 to i8
  %147 = udiv i8 %146, 10
  %148 = zext nneg i8 %147 to i32
  %149 = mul nuw nsw i16 %143, 24
  %150 = zext nneg i16 %149 to i32
  %151 = add nsw i32 %150, -108
  %152 = mul nuw nsw i32 %148, 24
  %153 = add nuw nsw i32 %152, 212
  switch i16 %142, label %175 [
    i16 0, label %154
    i16 1, label %160
    i16 2, label %165
    i16 3, label %170
  ]

154:                                              ; preds = %139
  %155 = trunc nsw i32 %151 to i16
  %156 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %137
  store i16 %155, ptr %156, align 2, !tbaa !17
  %157 = trunc nuw nsw i32 %152 to i16
  %158 = add nsw i16 %157, -108
  %159 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %137
  store i16 %158, ptr %159, align 2, !tbaa !17
  br label %180

160:                                              ; preds = %139
  %161 = trunc nsw i32 %151 to i16
  %162 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %137
  store i16 %161, ptr %162, align 2, !tbaa !17
  %163 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %137
  store i16 120, ptr %163, align 2, !tbaa !17
  %164 = trunc nuw nsw i32 %153 to i16
  br label %180

165:                                              ; preds = %139
  %166 = trunc nsw i32 %151 to i16
  %167 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %137
  store i16 %166, ptr %167, align 2, !tbaa !17
  %168 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %137
  store i16 -120, ptr %168, align 2, !tbaa !17
  %169 = trunc nuw nsw i32 %153 to i16
  br label %180

170:                                              ; preds = %139
  %171 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %137
  store i16 -120, ptr %171, align 2, !tbaa !17
  %172 = trunc nsw i32 %151 to i16
  %173 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %137
  store i16 %172, ptr %173, align 2, !tbaa !17
  %174 = trunc nuw nsw i32 %153 to i16
  br label %180

175:                                              ; preds = %139
  %176 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %137
  store i16 120, ptr %176, align 2, !tbaa !17
  %177 = trunc nsw i32 %151 to i16
  %178 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %137
  store i16 %177, ptr %178, align 2, !tbaa !17
  %179 = trunc nuw nsw i32 %153 to i16
  br label %180

180:                                              ; preds = %175, %170, %165, %160, %154
  %181 = phi i16 [ %179, %175 ], [ %174, %170 ], [ %169, %165 ], [ %164, %160 ], [ 440, %154 ]
  %182 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %137
  store i16 %181, ptr %182, align 2, !tbaa !17
  %183 = add nuw nsw i32 %137, 1
  br label %136, !llvm.loop !19

184:                                              ; preds = %136, %221
  %185 = phi i32 [ %233, %221 ], [ 0, %136 ]
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
  %207 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131584 to ptr), i32 %206
  store i16 %205, ptr %207, align 2, !tbaa !17
  %208 = trunc nsw i32 %203 to i16
  %209 = getelementptr inbounds nuw i8, ptr %207, i32 2
  store i16 %208, ptr %209, align 2, !tbaa !17
  %210 = trunc nsw i32 %202 to i16
  %211 = getelementptr inbounds nuw i8, ptr %207, i32 4
  store i16 %210, ptr %211, align 2, !tbaa !17
  %212 = icmp eq i32 %190, 4
  %213 = select i1 %189, i16 300, i16 144
  %214 = select i1 %212, i16 144, i16 %213
  %215 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131644 to ptr), i32 %185
  store i16 %214, ptr %215, align 2, !tbaa !17
  %216 = shl nuw nsw i32 %185, 4
  %217 = add nuw nsw i32 %216, 500
  br label %218

218:                                              ; preds = %234, %201
  %219 = phi i32 [ 0, %201 ], [ %258, %234 ]
  %220 = icmp eq i32 %219, 16
  br i1 %220, label %221, label %234

221:                                              ; preds = %218
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #12
  call fastcc void @face_point(i32 noundef %185, i32 noundef 1, i32 noundef 1, ptr noundef %7, ptr noundef %8, ptr noundef %9) #13
  %222 = load i32, ptr %7, align 4, !tbaa !3
  %223 = mul nsw i32 %222, %204
  %224 = load i32, ptr %8, align 4, !tbaa !3
  %225 = mul nsw i32 %224, %203
  %226 = add nsw i32 %225, %223
  %227 = load i32, ptr %9, align 4, !tbaa !3
  %228 = mul nsw i32 %227, %202
  %229 = add nsw i32 %226, %228
  %230 = lshr i32 %229, 31
  %231 = trunc nuw nsw i32 %230 to i16
  %232 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131664 to ptr), i32 %185
  store i16 %231, ptr %232, align 2, !tbaa !17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #12
  %233 = add nuw nsw i32 %185, 1
  br label %184, !llvm.loop !20

234:                                              ; preds = %218
  %235 = add nuw nsw i32 %217, %219
  %236 = and i32 %219, 3
  %237 = lshr i32 %219, 2
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #12
  call fastcc void @face_point(i32 noundef %185, i32 noundef %236, i32 noundef %237, ptr noundef %1, ptr noundef %2, ptr noundef %3) #13
  %238 = add nuw nsw i32 %236, 1
  %239 = add nuw nsw i32 %237, 1
  call fastcc void @face_point(i32 noundef %185, i32 noundef %238, i32 noundef %239, ptr noundef %4, ptr noundef %5, ptr noundef %6) #13
  %240 = load i32, ptr %1, align 4, !tbaa !3
  %241 = load i32, ptr %4, align 4, !tbaa !3
  %242 = add nsw i32 %241, %240
  %243 = sdiv i32 %242, 2
  %244 = trunc i32 %243 to i16
  %245 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %235
  store i16 %244, ptr %245, align 2, !tbaa !17
  %246 = load i32, ptr %2, align 4, !tbaa !3
  %247 = load i32, ptr %5, align 4, !tbaa !3
  %248 = add nsw i32 %247, %246
  %249 = sdiv i32 %248, 2
  %250 = trunc i32 %249 to i16
  %251 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %235
  store i16 %250, ptr %251, align 2, !tbaa !17
  %252 = load i32, ptr %3, align 4, !tbaa !3
  %253 = load i32, ptr %6, align 4, !tbaa !3
  %254 = add nsw i32 %253, %252
  %255 = sdiv i32 %254, 2
  %256 = trunc i32 %255 to i16
  %257 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %235
  store i16 %256, ptr %257, align 2, !tbaa !17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #12
  %258 = add nuw nsw i32 %219, 1
  br label %218, !llvm.loop !21

259:                                              ; preds = %184, %273
  %260 = phi i32 [ %274, %273 ], [ 0, %184 ]
  %261 = icmp eq i32 %260, 660
  br i1 %261, label %275, label %262

262:                                              ; preds = %259
  %263 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123272 to ptr), i32 %260
  store i16 0, ptr %263, align 2, !tbaa !17
  %264 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121952 to ptr), i32 %260
  store i16 0, ptr %264, align 2, !tbaa !17
  %265 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120632 to ptr), i32 %260
  store i16 0, ptr %265, align 2, !tbaa !17
  %266 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %260
  store i16 0, ptr %266, align 2, !tbaa !17
  %267 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %260
  store i16 0, ptr %267, align 2, !tbaa !17
  %268 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %260
  store i16 0, ptr %268, align 2, !tbaa !17
  %269 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128552 to ptr), i32 %260
  store i16 -1, ptr %269, align 2, !tbaa !17
  %270 = tail call fastcc i32 @is_light(i32 noundef %260) #13
  %271 = icmp eq i32 %270, 0
  br i1 %271, label %273, label %272

272:                                              ; preds = %262
  store i16 -36, ptr %268, align 2, !tbaa !17
  store i16 -36, ptr %267, align 2, !tbaa !17
  store i16 -6586, ptr %266, align 2, !tbaa !17
  br label %273

273:                                              ; preds = %272, %262
  %274 = add nuw nsw i32 %260, 1
  br label %259, !llvm.loop !22

275:                                              ; preds = %259
  tail call fastcc void @repaint(i32 noundef 1) #13
  br label %276

276:                                              ; preds = %297, %275
  %277 = phi i32 [ 0, %275 ], [ %293, %297 ]
  br label %278

278:                                              ; preds = %276, %291
  %279 = phi i1 [ false, %291 ], [ true, %276 ]
  br label %280

280:                                              ; preds = %278, %287
  %281 = phi i1 [ false, %287 ], [ %279, %278 ]
  tail call void @in_poll() #11
  %282 = load i32, ptr @in_edge, align 4, !tbaa !3
  %283 = and i32 %282, 31
  %284 = icmp eq i32 %283, 0
  br i1 %284, label %286, label %285

285:                                              ; preds = %280
  tail call void @led(i32 noundef 0, i32 noundef 0) #11
  tail call void @uputs(ptr noundef nonnull @.str.1) #11
  ret void

286:                                              ; preds = %280
  br i1 %281, label %288, label %287

287:                                              ; preds = %286
  tail call void @frame_sync(i32 noundef 33000) #11
  br label %280, !llvm.loop !23

288:                                              ; preds = %286
  %289 = tail call fastcc i32 @brightest() #13
  %290 = icmp slt i32 %289, 0
  br i1 %290, label %291, label %292

291:                                              ; preds = %288
  tail call void @uputs(ptr noundef nonnull @.str.2) #11
  tail call void @uputn(i32 noundef %277) #11
  tail call void @uputs(ptr noundef nonnull @.str.3) #11
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #11
  br label %278, !llvm.loop !23

292:                                              ; preds = %288
  tail call fastcc void @shoot(i32 noundef %289) #13
  %293 = add i32 %277, 1
  tail call fastcc void @repaint(i32 noundef 0) #13
  %294 = and i32 %293, 15
  %295 = icmp eq i32 %294, 0
  br i1 %295, label %296, label %297

296:                                              ; preds = %292
  tail call void @uputs(ptr noundef nonnull @.str.4) #11
  tail call void @uputn(i32 noundef %293) #11
  tail call void @uputs(ptr noundef nonnull @.str.5) #11
  br label %297

297:                                              ; preds = %296, %292
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

6:                                                ; preds = %132, %1
  %7 = phi i32 [ 0, %1 ], [ %134, %132 ]
  %8 = phi i32 [ 0, %1 ], [ %133, %132 ]
  %9 = icmp eq i32 %7, 500
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
  br label %135

19:                                               ; preds = %6
  %20 = tail call fastcc zeroext i16 @patch_color(i32 noundef %7) #13
  br i1 %5, label %21, label %25

21:                                               ; preds = %19
  %22 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128552 to ptr), i32 %7
  %23 = load i16, ptr %22, align 2, !tbaa !17
  %24 = icmp eq i16 %20, %23
  br i1 %24, label %132, label %25

25:                                               ; preds = %21, %19
  %26 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128552 to ptr), i32 %7
  store i16 %20, ptr %26, align 2, !tbaa !17
  %27 = trunc nuw i32 %7 to i16
  %28 = freeze i16 %27
  %29 = udiv i16 %28, 100
  %30 = urem i16 %27, 10
  %31 = zext nneg i16 %30 to i32
  %32 = mul i16 %29, 100
  %33 = sub i16 %28, %32
  %34 = trunc nuw nsw i16 %33 to i8
  %35 = udiv i8 %34, 10
  %36 = mul nuw nsw i16 %29, 242
  %37 = zext nneg i16 %36 to i32
  %38 = mul nuw nsw i8 %35, 11
  %39 = zext nneg i8 %38 to i32
  %40 = add nuw nsw i32 %39, %31
  %41 = shl nuw nsw i32 %40, 1
  %42 = getelementptr i8, ptr inttoptr (i32 537129872 to ptr), i32 %37
  %43 = getelementptr i8, ptr %42, i32 %41
  %44 = add nuw nsw i32 %31, 1
  %45 = add nuw nsw i32 %44, %39
  %46 = shl nuw nsw i32 %45, 1
  %47 = getelementptr i8, ptr %42, i32 %46
  %48 = add nuw nsw i32 %39, 11
  %49 = add nuw nsw i32 %48, %31
  %50 = shl nuw nsw i32 %49, 1
  %51 = getelementptr i8, ptr %42, i32 %50
  %52 = add nuw nsw i32 %48, %44
  %53 = shl nuw nsw i32 %52, 1
  %54 = getelementptr i8, ptr %42, i32 %53
  switch i16 %29, label %115 [
    i16 0, label %55
    i16 1, label %68
    i16 2, label %83
    i16 3, label %98
  ]

55:                                               ; preds = %25
  %56 = load i8, ptr %43, align 2, !tbaa !12
  %57 = zext i8 %56 to i32
  %58 = getelementptr inbounds nuw i8, ptr %43, i32 1
  %59 = load i8, ptr %58, align 1, !tbaa !12
  %60 = zext i8 %59 to i32
  %61 = load i8, ptr %54, align 2, !tbaa !12
  %62 = zext i8 %61 to i32
  %63 = sub nsw i32 %62, %57
  %64 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %65 = load i8, ptr %64, align 1, !tbaa !12
  %66 = zext i8 %65 to i32
  %67 = sub nsw i32 %66, %60
  tail call void @gfx_fill(i32 noundef %57, i32 noundef %60, i32 noundef %63, i32 noundef %67, i16 noundef zeroext %20) #11
  br label %132

68:                                               ; preds = %25
  %69 = getelementptr inbounds nuw i8, ptr %51, i32 1
  %70 = load i8, ptr %69, align 1, !tbaa !12
  %71 = zext i8 %70 to i32
  %72 = getelementptr inbounds nuw i8, ptr %43, i32 1
  %73 = load i8, ptr %72, align 1, !tbaa !12
  %74 = zext i8 %73 to i32
  %75 = load i8, ptr %51, align 2, !tbaa !12
  %76 = zext i8 %75 to i32
  %77 = load i8, ptr %43, align 2, !tbaa !12
  %78 = zext i8 %77 to i32
  %79 = load i8, ptr %54, align 2, !tbaa !12
  %80 = zext i8 %79 to i32
  %81 = load i8, ptr %47, align 2, !tbaa !12
  %82 = zext i8 %81 to i32
  tail call fastcc void @fill_htrap(i32 noundef %71, i32 noundef %74, i32 noundef %76, i32 noundef %78, i32 noundef %80, i32 noundef %82, i16 noundef zeroext %20) #13
  br label %132

83:                                               ; preds = %25
  %84 = getelementptr inbounds nuw i8, ptr %43, i32 1
  %85 = load i8, ptr %84, align 1, !tbaa !12
  %86 = zext i8 %85 to i32
  %87 = getelementptr inbounds nuw i8, ptr %51, i32 1
  %88 = load i8, ptr %87, align 1, !tbaa !12
  %89 = zext i8 %88 to i32
  %90 = load i8, ptr %43, align 2, !tbaa !12
  %91 = zext i8 %90 to i32
  %92 = load i8, ptr %51, align 2, !tbaa !12
  %93 = zext i8 %92 to i32
  %94 = load i8, ptr %47, align 2, !tbaa !12
  %95 = zext i8 %94 to i32
  %96 = load i8, ptr %54, align 2, !tbaa !12
  %97 = zext i8 %96 to i32
  tail call fastcc void @fill_htrap(i32 noundef %86, i32 noundef %89, i32 noundef %91, i32 noundef %93, i32 noundef %95, i32 noundef %97, i16 noundef zeroext %20) #13
  br label %132

98:                                               ; preds = %25
  %99 = load i8, ptr %43, align 2, !tbaa !12
  %100 = zext i8 %99 to i32
  %101 = load i8, ptr %51, align 2, !tbaa !12
  %102 = zext i8 %101 to i32
  %103 = getelementptr inbounds nuw i8, ptr %43, i32 1
  %104 = load i8, ptr %103, align 1, !tbaa !12
  %105 = zext i8 %104 to i32
  %106 = getelementptr inbounds nuw i8, ptr %51, i32 1
  %107 = load i8, ptr %106, align 1, !tbaa !12
  %108 = zext i8 %107 to i32
  %109 = getelementptr inbounds nuw i8, ptr %47, i32 1
  %110 = load i8, ptr %109, align 1, !tbaa !12
  %111 = zext i8 %110 to i32
  %112 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %113 = load i8, ptr %112, align 1, !tbaa !12
  %114 = zext i8 %113 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %100, i32 noundef %102, i32 noundef %105, i32 noundef %108, i32 noundef %111, i32 noundef %114, i16 noundef zeroext %20) #13
  br label %132

115:                                              ; preds = %25
  %116 = load i8, ptr %51, align 2, !tbaa !12
  %117 = zext i8 %116 to i32
  %118 = load i8, ptr %43, align 2, !tbaa !12
  %119 = zext i8 %118 to i32
  %120 = getelementptr inbounds nuw i8, ptr %51, i32 1
  %121 = load i8, ptr %120, align 1, !tbaa !12
  %122 = zext i8 %121 to i32
  %123 = getelementptr inbounds nuw i8, ptr %43, i32 1
  %124 = load i8, ptr %123, align 1, !tbaa !12
  %125 = zext i8 %124 to i32
  %126 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %127 = load i8, ptr %126, align 1, !tbaa !12
  %128 = zext i8 %127 to i32
  %129 = getelementptr inbounds nuw i8, ptr %47, i32 1
  %130 = load i8, ptr %129, align 1, !tbaa !12
  %131 = zext i8 %130 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %117, i32 noundef %119, i32 noundef %122, i32 noundef %125, i32 noundef %128, i32 noundef %131, i16 noundef zeroext %20) #13
  br label %132

132:                                              ; preds = %115, %98, %83, %68, %55, %21
  %133 = phi i32 [ %8, %21 ], [ 1, %55 ], [ 1, %68 ], [ 1, %83 ], [ 1, %98 ], [ 1, %115 ]
  %134 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !24

135:                                              ; preds = %10, %278
  %136 = phi i32 [ %279, %278 ], [ 500, %10 ]
  %137 = icmp eq i32 %136, 660
  br i1 %137, label %138, label %139

138:                                              ; preds = %135
  tail call void @gfx_present() #11
  ret void

139:                                              ; preds = %135
  %140 = tail call fastcc zeroext i16 @patch_color(i32 noundef %136) #13
  br i1 %12, label %141, label %145

141:                                              ; preds = %139
  %142 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128552 to ptr), i32 %136
  %143 = load i16, ptr %142, align 2, !tbaa !17
  %144 = icmp eq i16 %140, %143
  br i1 %144, label %278, label %145

145:                                              ; preds = %141, %139
  %146 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128552 to ptr), i32 %136
  store i16 %140, ptr %146, align 2, !tbaa !17
  %147 = trunc i32 %136 to i16
  %148 = add i16 %147, -500
  %149 = freeze i16 %148
  %150 = sdiv i16 %149, 16
  %151 = sext i16 %150 to i32
  %152 = getelementptr inbounds i16, ptr inttoptr (i32 537131664 to ptr), i32 %151
  %153 = load i16, ptr %152, align 2, !tbaa !17
  %154 = icmp eq i16 %153, 0
  br i1 %154, label %278, label %155

155:                                              ; preds = %145
  %156 = mul i16 %150, 16
  %157 = sub i16 %149, %156
  %158 = sext i16 %157 to i32
  %159 = and i32 %158, 3
  %160 = ashr i32 %158, 2
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #12
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #12
  %161 = mul nsw i32 %151, 50
  %162 = mul nsw i32 %160, 5
  %163 = add nsw i32 %162, %159
  %164 = shl nsw i32 %163, 1
  %165 = getelementptr i8, ptr inttoptr (i32 537131084 to ptr), i32 %161
  %166 = getelementptr i8, ptr %165, i32 %164
  %167 = add nuw nsw i32 %159, 1
  %168 = add nsw i32 %162, %167
  %169 = shl nsw i32 %168, 1
  %170 = getelementptr i8, ptr %165, i32 %169
  %171 = add nsw i32 %162, 5
  %172 = add nsw i32 %171, %167
  %173 = shl nsw i32 %172, 1
  %174 = getelementptr i8, ptr %165, i32 %173
  %175 = add nsw i32 %171, %159
  %176 = shl nsw i32 %175, 1
  %177 = getelementptr i8, ptr %165, i32 %176
  %178 = load i8, ptr %166, align 2, !tbaa !12
  %179 = zext i8 %178 to i32
  store i32 %179, ptr %3, align 4, !tbaa !3
  %180 = getelementptr inbounds nuw i8, ptr %166, i32 1
  %181 = load i8, ptr %180, align 1, !tbaa !12
  %182 = zext i8 %181 to i32
  store i32 %182, ptr %4, align 4, !tbaa !3
  %183 = load i8, ptr %170, align 2, !tbaa !12
  %184 = zext i8 %183 to i32
  store i32 %184, ptr %13, align 4, !tbaa !3
  %185 = getelementptr inbounds nuw i8, ptr %170, i32 1
  %186 = load i8, ptr %185, align 1, !tbaa !12
  %187 = zext i8 %186 to i32
  store i32 %187, ptr %14, align 4, !tbaa !3
  %188 = load i8, ptr %174, align 2, !tbaa !12
  %189 = zext i8 %188 to i32
  store i32 %189, ptr %15, align 4, !tbaa !3
  %190 = getelementptr inbounds nuw i8, ptr %174, i32 1
  %191 = load i8, ptr %190, align 1, !tbaa !12
  %192 = zext i8 %191 to i32
  store i32 %192, ptr %16, align 4, !tbaa !3
  %193 = load i8, ptr %177, align 2, !tbaa !12
  %194 = zext i8 %193 to i32
  store i32 %194, ptr %17, align 4, !tbaa !3
  %195 = getelementptr inbounds nuw i8, ptr %177, i32 1
  %196 = load i8, ptr %195, align 1, !tbaa !12
  %197 = zext i8 %196 to i32
  store i32 %197, ptr %18, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #12
  br label %198

198:                                              ; preds = %222, %155
  %199 = phi i32 [ 0, %155 ], [ %208, %222 ]
  %200 = phi i32 [ %179, %155 ], [ %207, %222 ]
  %201 = phi i32 [ %179, %155 ], [ %206, %222 ]
  %202 = icmp eq i32 %199, 4
  br i1 %202, label %225, label %203

203:                                              ; preds = %198
  %204 = getelementptr inbounds nuw i32, ptr %3, i32 %199
  %205 = load i32, ptr %204, align 4, !tbaa !3
  %206 = tail call i32 @llvm.smin.i32(i32 %205, i32 %201)
  %207 = tail call i32 @llvm.smax.i32(i32 %205, i32 %200)
  %208 = add nuw nsw i32 %199, 1
  %209 = and i32 %208, 3
  %210 = getelementptr inbounds nuw i32, ptr %3, i32 %209
  %211 = load i32, ptr %210, align 4, !tbaa !3
  %212 = icmp eq i32 %211, %205
  br i1 %212, label %222, label %213

213:                                              ; preds = %203
  %214 = sub nsw i32 %211, %205
  %215 = getelementptr inbounds nuw i32, ptr %4, i32 %209
  %216 = load i32, ptr %215, align 4, !tbaa !3
  %217 = getelementptr inbounds nuw i32, ptr %4, i32 %199
  %218 = load i32, ptr %217, align 4, !tbaa !3
  %219 = sub nsw i32 %216, %218
  %220 = shl i32 %219, 12
  %221 = sdiv i32 %220, %214
  br label %222

222:                                              ; preds = %213, %203
  %223 = phi i32 [ %221, %213 ], [ 0, %203 ]
  %224 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %199
  store i32 %223, ptr %224, align 4, !tbaa !3
  br label %198, !llvm.loop !25

225:                                              ; preds = %198, %275
  %226 = phi i32 [ %276, %275 ], [ %201, %198 ]
  %227 = icmp sgt i32 %226, %200
  br i1 %227, label %277, label %228

228:                                              ; preds = %225, %261
  %229 = phi i32 [ %262, %261 ], [ 32767, %225 ]
  %230 = phi i32 [ %263, %261 ], [ -32768, %225 ]
  %231 = phi i32 [ %240, %261 ], [ 0, %225 ]
  br label %232

232:                                              ; preds = %249, %228
  %233 = phi i32 [ %231, %228 ], [ %240, %249 ]
  %234 = icmp eq i32 %233, 4
  br i1 %234, label %235, label %237

235:                                              ; preds = %232
  %236 = icmp sgt i32 %230, %229
  br i1 %236, label %273, label %275

237:                                              ; preds = %232
  %238 = getelementptr inbounds nuw i32, ptr %3, i32 %233
  %239 = load i32, ptr %238, align 4, !tbaa !3
  %240 = add nuw nsw i32 %233, 1
  %241 = and i32 %240, 3
  %242 = getelementptr inbounds nuw i32, ptr %3, i32 %241
  %243 = load i32, ptr %242, align 4, !tbaa !3
  %244 = tail call i32 @llvm.smin.i32(i32 %239, i32 %243)
  %245 = icmp slt i32 %226, %244
  br i1 %245, label %249, label %246

246:                                              ; preds = %237
  %247 = tail call i32 @llvm.smax.i32(i32 %239, i32 %243)
  %248 = icmp sgt i32 %226, %247
  br i1 %248, label %249, label %250

249:                                              ; preds = %246, %237
  br label %232, !llvm.loop !26

250:                                              ; preds = %246
  %251 = icmp eq i32 %239, %243
  %252 = getelementptr inbounds nuw i32, ptr %4, i32 %233
  %253 = load i32, ptr %252, align 4, !tbaa !3
  br i1 %251, label %254, label %264

254:                                              ; preds = %250
  %255 = getelementptr inbounds nuw i32, ptr %4, i32 %241
  %256 = load i32, ptr %255, align 4, !tbaa !3
  %257 = tail call i32 @llvm.smin.i32(i32 %256, i32 %253)
  %258 = tail call i32 @llvm.smax.i32(i32 %256, i32 %253)
  %259 = tail call i32 @llvm.smin.i32(i32 %257, i32 %229)
  %260 = tail call i32 @llvm.smax.i32(i32 %258, i32 %230)
  br label %261

261:                                              ; preds = %254, %264
  %262 = phi i32 [ %271, %264 ], [ %259, %254 ]
  %263 = phi i32 [ %272, %264 ], [ %260, %254 ]
  br label %228, !llvm.loop !26

264:                                              ; preds = %250
  %265 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %233
  %266 = load i32, ptr %265, align 4, !tbaa !3
  %267 = sub nsw i32 %226, %239
  %268 = mul nsw i32 %266, %267
  %269 = ashr i32 %268, 12
  %270 = add nsw i32 %269, %253
  %271 = tail call i32 @llvm.smin.i32(i32 %270, i32 %229)
  %272 = tail call i32 @llvm.smax.i32(i32 %270, i32 %230)
  br label %261

273:                                              ; preds = %235
  %274 = sub nsw i32 %230, %229
  tail call void @gfx_fill(i32 noundef %226, i32 noundef %229, i32 noundef 1, i32 noundef %274, i16 noundef zeroext %140) #11
  br label %275

275:                                              ; preds = %273, %235
  %276 = add nsw i32 %226, 1
  br label %225, !llvm.loop !27

277:                                              ; preds = %225
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %278

278:                                              ; preds = %277, %145, %141
  %279 = add nuw nsw i32 %136, 1
  br label %135, !llvm.loop !28
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc i32 @brightest() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %28, %0
  %2 = phi i32 [ -1, %0 ], [ %33, %28 ]
  %3 = phi i32 [ 0, %0 ], [ %35, %28 ]
  %4 = phi i32 [ 0, %0 ], [ %34, %28 ]
  %5 = icmp eq i32 %3, 660
  br i1 %5, label %6, label %9

6:                                                ; preds = %1
  %7 = icmp samesign ugt i32 %4, 95
  %8 = select i1 %7, i32 %2, i32 -1
  ret i32 %8

9:                                                ; preds = %1
  %10 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %3
  %11 = load i16, ptr %10, align 2, !tbaa !17
  %12 = zext i16 %11 to i32
  %13 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %3
  %14 = load i16, ptr %13, align 2, !tbaa !17
  %15 = zext i16 %14 to i32
  %16 = add nuw nsw i32 %15, %12
  %17 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %3
  %18 = load i16, ptr %17, align 2, !tbaa !17
  %19 = zext i16 %18 to i32
  %20 = add nuw nsw i32 %16, %19
  %21 = icmp samesign ult i32 %3, 500
  br i1 %21, label %28, label %22

22:                                               ; preds = %9
  %23 = add nsw i32 %3, -500
  %24 = lshr i32 %23, 4
  %25 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131644 to ptr), i32 %24
  %26 = load i16, ptr %25, align 2, !tbaa !17
  %27 = sext i16 %26 to i32
  br label %28

28:                                               ; preds = %9, %22
  %29 = phi i32 [ %27, %22 ], [ 256, %9 ]
  %30 = mul i32 %29, %20
  %31 = lshr i32 %30, 8
  %32 = icmp samesign ugt i32 %31, %4
  %33 = select i1 %32, i32 %3, i32 %2
  %34 = tail call i32 @llvm.umax.i32(i32 %31, i32 %4)
  %35 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !29
}

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @shoot(i32 noundef range(i32 0, -2147483648) %0) unnamed_addr #4 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = icmp samesign ult i32 %0, 500
  br i1 %8, label %15, label %9

9:                                                ; preds = %1
  %10 = add nsw i32 %0, -500
  %11 = lshr i32 %10, 4
  %12 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131644 to ptr), i32 %11
  %13 = load i16, ptr %12, align 2, !tbaa !17
  %14 = sext i16 %13 to i32
  br label %15

15:                                               ; preds = %1, %9
  %16 = phi i32 [ %14, %9 ], [ 256, %1 ]
  %17 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %0
  %18 = load i16, ptr %17, align 2, !tbaa !17
  %19 = zext i16 %18 to i32
  %20 = mul nsw i32 %16, %19
  %21 = lshr i32 %20, 8
  %22 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %0
  %23 = load i16, ptr %22, align 2, !tbaa !17
  %24 = zext i16 %23 to i32
  %25 = mul nsw i32 %16, %24
  %26 = lshr i32 %25, 8
  %27 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %0
  %28 = load i16, ptr %27, align 2, !tbaa !17
  %29 = zext i16 %28 to i32
  %30 = mul nsw i32 %16, %29
  %31 = lshr i32 %30, 8
  store i16 0, ptr %27, align 2, !tbaa !17
  store i16 0, ptr %22, align 2, !tbaa !17
  store i16 0, ptr %17, align 2, !tbaa !17
  %32 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %0
  %33 = load i16, ptr %32, align 2, !tbaa !17
  %34 = sext i16 %33 to i32
  %35 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %0
  %36 = load i16, ptr %35, align 2, !tbaa !17
  %37 = sext i16 %36 to i32
  %38 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %0
  %39 = load i16, ptr %38, align 2, !tbaa !17
  %40 = sext i16 %39 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #12
  call fastcc void @normal_of(i32 noundef %0, ptr noundef %2, ptr noundef %3, ptr noundef %4) #13
  %41 = load i32, ptr %2, align 4
  %42 = load i32, ptr %3, align 4
  %43 = load i32, ptr %4, align 4
  br label %44

44:                                               ; preds = %168, %15
  %45 = phi i32 [ 0, %15 ], [ %169, %168 ]
  %46 = icmp eq i32 %45, 660
  br i1 %46, label %47, label %48

47:                                               ; preds = %44
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #12
  ret void

48:                                               ; preds = %44
  %49 = icmp eq i32 %45, %0
  br i1 %49, label %168, label %50

50:                                               ; preds = %48
  %51 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %45
  %52 = load i16, ptr %51, align 2, !tbaa !17
  %53 = sext i16 %52 to i32
  %54 = sub nsw i32 %53, %34
  %55 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %45
  %56 = load i16, ptr %55, align 2, !tbaa !17
  %57 = sext i16 %56 to i32
  %58 = sub nsw i32 %57, %37
  %59 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %45
  %60 = load i16, ptr %59, align 2, !tbaa !17
  %61 = sext i16 %60 to i32
  %62 = sub nsw i32 %61, %40
  %63 = mul nsw i32 %41, %54
  %64 = mul nsw i32 %42, %58
  %65 = add nsw i32 %64, %63
  %66 = mul nsw i32 %43, %62
  %67 = add nsw i32 %65, %66
  %68 = ashr i32 %67, 8
  %69 = icmp slt i32 %68, 1
  br i1 %69, label %168, label %70

70:                                               ; preds = %50
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #12
  call fastcc void @normal_of(i32 noundef %45, ptr noundef %5, ptr noundef %6, ptr noundef %7) #13
  %71 = load i32, ptr %5, align 4, !tbaa !3
  %72 = mul nsw i32 %71, %54
  %73 = load i32, ptr %6, align 4, !tbaa !3
  %74 = mul nsw i32 %73, %58
  %75 = add nsw i32 %74, %72
  %76 = load i32, ptr %7, align 4, !tbaa !3
  %77 = mul nsw i32 %76, %62
  %78 = add nsw i32 %75, %77
  %79 = ashr i32 %78, 8
  %80 = icmp sgt i32 %79, -1
  br i1 %80, label %167, label %81

81:                                               ; preds = %70
  %82 = mul nsw i32 %54, %54
  %83 = mul nsw i32 %58, %58
  %84 = add nuw i32 %83, %82
  %85 = mul nsw i32 %62, %62
  %86 = add i32 %84, %85
  %87 = icmp ult i32 %86, 64
  br i1 %87, label %167, label %88

88:                                               ; preds = %81
  %89 = tail call fastcc i32 @clearance(i32 noundef %0, i32 noundef %45) #13
  %90 = icmp eq i32 %89, 0
  br i1 %90, label %167, label %91

91:                                               ; preds = %88
  %92 = mul i32 %68, -1024
  %93 = mul i32 %92, %79
  %94 = udiv i32 %93, %86
  %95 = udiv i32 589824, %86
  %96 = tail call i32 @llvm.umin.i32(i32 %95, i32 4096)
  %97 = mul nuw i32 %94, 41
  %98 = mul i32 %97, %96
  %99 = lshr i32 %98, 15
  %100 = mul nsw i32 %89, 51
  %101 = mul i32 %100, %99
  %102 = icmp ult i32 %101, 256
  br i1 %102, label %167, label %103

103:                                              ; preds = %91
  %104 = lshr i32 %101, 8
  %105 = icmp samesign ult i32 %45, 500
  %106 = trunc nuw i32 %45 to i16
  %107 = udiv i16 %106, 100
  %108 = zext nneg i16 %107 to i32
  %109 = select i1 %105, i32 %108, i32 5
  %110 = getelementptr inbounds nuw [6 x [3 x i16]], ptr @rho, i32 0, i32 %109
  %111 = mul i32 %104, %21
  %112 = lshr i32 %111, 12
  %113 = load i16, ptr %110, align 2, !tbaa !17
  %114 = zext i16 %113 to i32
  %115 = mul i32 %112, %114
  %116 = lshr i32 %115, 8
  %117 = mul i32 %104, %26
  %118 = lshr i32 %117, 12
  %119 = getelementptr inbounds nuw i8, ptr %110, i32 2
  %120 = load i16, ptr %119, align 2, !tbaa !17
  %121 = zext i16 %120 to i32
  %122 = mul i32 %118, %121
  %123 = lshr i32 %122, 8
  %124 = mul i32 %104, %31
  %125 = lshr i32 %124, 12
  %126 = getelementptr inbounds nuw i8, ptr %110, i32 4
  %127 = load i16, ptr %126, align 2, !tbaa !17
  %128 = zext i16 %127 to i32
  %129 = mul i32 %125, %128
  %130 = lshr i32 %129, 8
  %131 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120632 to ptr), i32 %45
  %132 = load i16, ptr %131, align 2, !tbaa !17
  %133 = zext i16 %132 to i32
  %134 = add nuw nsw i32 %116, %133
  %135 = tail call i32 @llvm.umin.i32(i32 %134, i32 65535)
  %136 = trunc nuw i32 %135 to i16
  store i16 %136, ptr %131, align 2, !tbaa !17
  %137 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121952 to ptr), i32 %45
  %138 = load i16, ptr %137, align 2, !tbaa !17
  %139 = zext i16 %138 to i32
  %140 = add nuw nsw i32 %123, %139
  %141 = tail call i32 @llvm.umin.i32(i32 %140, i32 65535)
  %142 = trunc nuw i32 %141 to i16
  store i16 %142, ptr %137, align 2, !tbaa !17
  %143 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123272 to ptr), i32 %45
  %144 = load i16, ptr %143, align 2, !tbaa !17
  %145 = zext i16 %144 to i32
  %146 = add nuw nsw i32 %130, %145
  %147 = tail call i32 @llvm.umin.i32(i32 %146, i32 65535)
  %148 = trunc nuw i32 %147 to i16
  store i16 %148, ptr %143, align 2, !tbaa !17
  %149 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %45
  %150 = load i16, ptr %149, align 2, !tbaa !17
  %151 = zext i16 %150 to i32
  %152 = add nuw nsw i32 %116, %151
  %153 = tail call i32 @llvm.umin.i32(i32 %152, i32 65535)
  %154 = trunc nuw i32 %153 to i16
  store i16 %154, ptr %149, align 2, !tbaa !17
  %155 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %45
  %156 = load i16, ptr %155, align 2, !tbaa !17
  %157 = zext i16 %156 to i32
  %158 = add nuw nsw i32 %123, %157
  %159 = tail call i32 @llvm.umin.i32(i32 %158, i32 65535)
  %160 = trunc nuw i32 %159 to i16
  store i16 %160, ptr %155, align 2, !tbaa !17
  %161 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %45
  %162 = load i16, ptr %161, align 2, !tbaa !17
  %163 = zext i16 %162 to i32
  %164 = add nuw nsw i32 %130, %163
  %165 = tail call i32 @llvm.umin.i32(i32 %164, i32 65535)
  %166 = trunc nuw i32 %165 to i16
  store i16 %166, ptr %161, align 2, !tbaa !17
  br label %167

167:                                              ; preds = %81, %103, %91, %88, %70
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #12
  br label %168

168:                                              ; preds = %167, %50, %48
  %169 = add nuw nsw i32 %45, 1
  br label %44, !llvm.loop !30
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write)
define internal fastcc void @face_point(i32 noundef range(i32 -2147483648, 10) %0, i32 noundef range(i32 -2147483648, 5) %1, i32 noundef range(i32 -2147483648, 5) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %4, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %5) unnamed_addr #5 {
  %7 = srem i32 %0, 5
  %8 = mul nsw i32 %1, 18
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
  %14 = mul nsw i32 %2, 18
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
  %24 = sdiv i32 %23, 4
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
define internal fastcc range(i32 0, 2) i32 @is_light(i32 noundef range(i32 -2147483648, 660) %0) unnamed_addr #6 {
  %2 = add i32 %0, -200
  %3 = icmp ult i32 %2, 100
  br i1 %3, label %4, label %14

4:                                                ; preds = %1
  %5 = trunc nuw nsw i32 %0 to i16
  %6 = urem i16 %5, 10
  %7 = and i16 %6, 14
  %8 = icmp eq i16 %7, 4
  br i1 %8, label %9, label %14

9:                                                ; preds = %4
  %10 = urem i16 %5, 100
  %11 = add nsw i16 %10, -40
  %12 = icmp ult i16 %11, 20
  %13 = zext i1 %12 to i32
  br label %14

14:                                               ; preds = %4, %9, %1
  %15 = phi i32 [ 0, %1 ], [ %13, %9 ], [ 0, %4 ]
  ret i32 %15
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc zeroext i16 @patch_color(i32 noundef range(i32 -2147483648, 660) %0) unnamed_addr #7 {
  %2 = tail call fastcc i32 @is_light(i32 noundef %0) #13
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %24

4:                                                ; preds = %1
  %5 = getelementptr inbounds i16, ptr inttoptr (i32 537120632 to ptr), i32 %0
  %6 = load i16, ptr %5, align 2, !tbaa !17
  %7 = lshr i16 %6, 3
  %8 = tail call i16 @llvm.umin.i16(i16 %7, i16 255)
  %9 = shl nuw i16 %8, 8
  %10 = and i16 %9, -2048
  %11 = getelementptr inbounds i16, ptr inttoptr (i32 537121952 to ptr), i32 %0
  %12 = load i16, ptr %11, align 2, !tbaa !17
  %13 = lshr i16 %12, 3
  %14 = tail call i16 @llvm.umin.i16(i16 %13, i16 255)
  %15 = shl nuw nsw i16 %14, 3
  %16 = and i16 %15, 2016
  %17 = or disjoint i16 %16, %10
  %18 = getelementptr inbounds i16, ptr inttoptr (i32 537123272 to ptr), i32 %0
  %19 = load i16, ptr %18, align 2, !tbaa !17
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
define internal fastcc void @fill_htrap(i32 noundef range(i32 0, 256) %0, i32 noundef range(i32 0, 256) %1, i32 noundef range(i32 0, 256) %2, i32 noundef range(i32 0, 256) %3, i32 noundef range(i32 0, 256) %4, i32 noundef range(i32 0, 256) %5, i16 noundef zeroext %6) unnamed_addr #0 {
  %8 = sub nsw i32 %1, %0
  %9 = icmp slt i32 %8, 1
  br i1 %9, label %34, label %10

10:                                               ; preds = %7
  %11 = shl nuw nsw i32 %2, 12
  %12 = shl nuw nsw i32 %4, 12
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
  %23 = icmp samesign ult i32 %21, %1
  br i1 %23, label %24, label %34

24:                                               ; preds = %19
  %25 = ashr i32 %22, 12
  %26 = ashr i32 %20, 12
  %27 = icmp sgt i32 %26, %25
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = sub nsw i32 %26, %25
  tail call void @gfx_fill(i32 noundef %25, i32 noundef %21, i32 noundef %29, i32 noundef 1, i16 noundef zeroext %6) #11
  br label %30

30:                                               ; preds = %28, %24
  %31 = add nsw i32 %22, %15
  %32 = add nsw i32 %20, %18
  %33 = add nuw nsw i32 %21, 1
  br label %19, !llvm.loop !31

34:                                               ; preds = %19, %7
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fill_vtrap(i32 noundef range(i32 0, 256) %0, i32 noundef range(i32 0, 256) %1, i32 noundef range(i32 0, 256) %2, i32 noundef range(i32 0, 256) %3, i32 noundef range(i32 0, 256) %4, i32 noundef range(i32 0, 256) %5, i16 noundef zeroext %6) unnamed_addr #0 {
  %8 = sub nsw i32 %1, %0
  %9 = icmp slt i32 %8, 1
  br i1 %9, label %34, label %10

10:                                               ; preds = %7
  %11 = shl nuw nsw i32 %2, 12
  %12 = shl nuw nsw i32 %4, 12
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
  %23 = icmp samesign ult i32 %21, %1
  br i1 %23, label %24, label %34

24:                                               ; preds = %19
  %25 = ashr i32 %22, 12
  %26 = ashr i32 %20, 12
  %27 = icmp sgt i32 %26, %25
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = sub nsw i32 %26, %25
  tail call void @gfx_fill(i32 noundef %21, i32 noundef %25, i32 noundef 1, i32 noundef %29, i16 noundef zeroext %6) #11
  br label %30

30:                                               ; preds = %28, %24
  %31 = add nsw i32 %22, %15
  %32 = add nsw i32 %20, %18
  %33 = add nuw nsw i32 %21, 1
  br label %19, !llvm.loop !32

34:                                               ; preds = %19, %7
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: readwrite, inaccessiblemem: none)
define internal fastcc void @normal_of(i32 noundef %0, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #8 {
  %5 = icmp sgt i32 %0, 499
  br i1 %5, label %6, label %19

6:                                                ; preds = %4
  %7 = add nsw i32 %0, -500
  %8 = lshr i32 %7, 4
  %9 = mul nuw nsw i32 %8, 6
  %10 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131584 to ptr), i32 %9
  %11 = load i16, ptr %10, align 2, !tbaa !17
  %12 = sext i16 %11 to i32
  store i32 %12, ptr %1, align 4, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 2
  %14 = load i16, ptr %13, align 2, !tbaa !17
  %15 = sext i16 %14 to i32
  store i32 %15, ptr %2, align 4, !tbaa !3
  %16 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %17 = load i16, ptr %16, align 2, !tbaa !17
  %18 = sext i16 %17 to i32
  br label %26

19:                                               ; preds = %4
  %20 = sdiv i32 %0, 100
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

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc i32 @clearance(i32 noundef range(i32 0, -2147483648) %0, i32 noundef range(i32 -2147483648, 660) %1) unnamed_addr #3 {
  %3 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %0
  %4 = load i16, ptr %3, align 2, !tbaa !17
  %5 = sext i16 %4 to i32
  %6 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %0
  %7 = load i16, ptr %6, align 2, !tbaa !17
  %8 = sext i16 %7 to i32
  %9 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %0
  %10 = load i16, ptr %9, align 2, !tbaa !17
  %11 = sext i16 %10 to i32
  %12 = getelementptr inbounds i16, ptr inttoptr (i32 537116672 to ptr), i32 %1
  %13 = load i16, ptr %12, align 2, !tbaa !17
  %14 = sext i16 %13 to i32
  %15 = sub nsw i32 %14, %5
  %16 = getelementptr inbounds i16, ptr inttoptr (i32 537117992 to ptr), i32 %1
  %17 = load i16, ptr %16, align 2, !tbaa !17
  %18 = sext i16 %17 to i32
  %19 = sub nsw i32 %18, %8
  %20 = getelementptr inbounds i16, ptr inttoptr (i32 537119312 to ptr), i32 %1
  %21 = load i16, ptr %20, align 2, !tbaa !17
  %22 = sext i16 %21 to i32
  %23 = sub nsw i32 %22, %11
  %24 = tail call i16 @llvm.smin.i16(i16 %4, i16 %13)
  %25 = sext i16 %24 to i32
  %26 = add nsw i32 %14, %5
  %27 = sub nsw i32 %26, %25
  %28 = tail call i16 @llvm.smin.i16(i16 %10, i16 %21)
  %29 = sext i16 %28 to i32
  %30 = add nsw i32 %22, %11
  %31 = sub nsw i32 %30, %29
  %32 = icmp sgt i32 %27, -89
  %33 = icmp slt i16 %24, 5
  %34 = and i1 %33, %32
  %35 = icmp sgt i32 %31, 283
  %36 = icmp slt i16 %28, 377
  %37 = and i1 %36, %35
  %38 = select i1 %34, i1 %37, i1 false
  %39 = icmp sgt i32 %27, -2
  %40 = icmp slt i16 %24, 92
  %41 = and i1 %40, %39
  %42 = icmp sgt i32 %31, 221
  %43 = icmp slt i16 %28, 315
  %44 = and i1 %43, %42
  %45 = select i1 %41, i1 %44, i1 false
  %46 = select i1 %38, i1 true, i1 %45
  br i1 %46, label %47, label %74

47:                                               ; preds = %2, %71
  %48 = phi i32 [ %72, %71 ], [ 0, %2 ]
  %49 = phi i32 [ %73, %71 ], [ 1, %2 ]
  %50 = icmp eq i32 %49, 6
  br i1 %50, label %74, label %51

51:                                               ; preds = %47
  %52 = mul nuw nsw i32 %49, 43
  %53 = mul nsw i32 %52, %15
  %54 = ashr i32 %53, 8
  %55 = add nsw i32 %54, %5
  %56 = mul nsw i32 %52, %19
  %57 = ashr i32 %56, 8
  %58 = add nsw i32 %57, %8
  %59 = mul nsw i32 %52, %23
  %60 = ashr i32 %59, 8
  %61 = add nsw i32 %60, %11
  br i1 %38, label %62, label %65

62:                                               ; preds = %51
  %63 = tail call fastcc i32 @in_box(i32 noundef 0, i32 noundef %55, i32 noundef %58, i32 noundef %61) #13
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %65, label %71

65:                                               ; preds = %62, %51
  br i1 %45, label %66, label %69

66:                                               ; preds = %65
  %67 = tail call fastcc i32 @in_box(i32 noundef 1, i32 noundef %55, i32 noundef %58, i32 noundef %61) #13
  %68 = icmp eq i32 %67, 0
  br i1 %68, label %69, label %71

69:                                               ; preds = %66, %65
  %70 = add nsw i32 %48, 1
  br label %71

71:                                               ; preds = %62, %66, %69
  %72 = phi i32 [ %70, %69 ], [ %48, %66 ], [ %48, %62 ]
  %73 = add nuw nsw i32 %49, 1
  br label %47, !llvm.loop !33

74:                                               ; preds = %47, %2
  %75 = phi i32 [ 5, %2 ], [ %48, %47 ]
  ret i32 %75
}

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @in_box(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 -8421376, 8421375) %1, i32 noundef range(i32 -8421376, 8421375) %2, i32 noundef range(i32 -8421376, 8421375) %3) unnamed_addr #9 {
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
declare i32 @llvm.umin.i32(i32, i32) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.umin.i16(i16, i16) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #10

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #11 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #12 = { nounwind }
attributes #13 = { minsize nobuiltin optsize "no-builtins" }

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
!12 = !{!5, !5, i64 0}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = !{!18, !18, i64 0}
!18 = !{!"short", !5, i64 0}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !9}
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !8, !9}
!28 = distinct !{!28, !8, !9}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
