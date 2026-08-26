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
@NFQ = internal unnamed_addr constant [10 x i8] c"\02\04\02\06\02\02\02\02\06\04", align 1
@CGOFF = internal unnamed_addr constant [10 x i16] [i16 0, i16 9, i16 34, i16 43, i16 92, i16 101, i16 110, i16 119, i16 128, i16 177], align 2
@PBASE = internal unnamed_addr constant [10 x i8] c"\00\04\14\18<@DHLp", align 1
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
  %31 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537129732 to ptr), i32 %30
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

99:                                               ; preds = %26, %116
  %100 = phi i32 [ %117, %116 ], [ 0, %26 ]
  %101 = icmp eq i32 %100, 10
  br i1 %101, label %141, label %102

102:                                              ; preds = %99
  %103 = getelementptr inbounds nuw [10 x i8], ptr @NFQ, i32 0, i32 %100
  %104 = load i8, ptr %103, align 1, !tbaa !12
  %105 = zext i8 %104 to i32
  %106 = getelementptr inbounds nuw [10 x i16], ptr @CGOFF, i32 0, i32 %100
  %107 = load i16, ptr %106, align 2, !tbaa !14
  %108 = zext i16 %107 to i32
  %109 = add nuw nsw i32 %105, 1
  br label %110

110:                                              ; preds = %121, %102
  %111 = phi i32 [ 0, %102 ], [ %122, %121 ]
  %112 = icmp eq i32 %111, %109
  br i1 %112, label %116, label %113

113:                                              ; preds = %110
  %114 = mul nuw nsw i32 %111, %109
  %115 = add nuw nsw i32 %114, %108
  br label %118

116:                                              ; preds = %110
  %117 = add nuw nsw i32 %100, 1
  br label %99, !llvm.loop !16

118:                                              ; preds = %123, %113
  %119 = phi i32 [ %140, %123 ], [ 0, %113 ]
  %120 = icmp eq i32 %119, %109
  br i1 %120, label %121, label %123

121:                                              ; preds = %118
  %122 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !17

123:                                              ; preds = %118
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #12
  call fastcc void @face_point(i32 noundef %100, i32 noundef %119, i32 noundef %111, ptr noundef %11, ptr noundef %12, ptr noundef %13) #13
  %124 = load i32, ptr %13, align 4, !tbaa !3
  %125 = udiv i32 819200, %124
  %126 = load i32, ptr %11, align 4, !tbaa !3
  %127 = mul nsw i32 %126, %125
  %128 = lshr i32 %127, 12
  %129 = trunc i32 %128 to i8
  %130 = add i8 %129, 120
  %131 = add nuw nsw i32 %115, %119
  %132 = shl nuw nsw i32 %131, 1
  %133 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130942 to ptr), i32 %132
  store i8 %130, ptr %133, align 2, !tbaa !12
  %134 = load i32, ptr %12, align 4, !tbaa !3
  %135 = mul nsw i32 %134, %125
  %136 = lshr i32 %135, 12
  %137 = trunc i32 %136 to i8
  %138 = add i8 %137, 120
  %139 = getelementptr inbounds nuw i8, ptr %133, i32 1
  store i8 %138, ptr %139, align 1, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #12
  %140 = add nuw nsw i32 %119, 1
  br label %118, !llvm.loop !18

141:                                              ; preds = %99
  call void @llvm.lifetime.end.p0(i64 44, ptr nonnull %10) #12
  br label %142

142:                                              ; preds = %186, %141
  %143 = phi i32 [ 0, %141 ], [ %189, %186 ]
  %144 = icmp eq i32 %143, 500
  br i1 %144, label %190, label %145

145:                                              ; preds = %142
  %146 = trunc nuw i32 %143 to i16
  %147 = freeze i16 %146
  %148 = udiv i16 %147, 100
  %149 = urem i16 %146, 10
  %150 = mul i16 %148, 100
  %151 = sub i16 %147, %150
  %152 = trunc nuw nsw i16 %151 to i8
  %153 = udiv i8 %152, 10
  %154 = zext nneg i8 %153 to i32
  %155 = mul nuw nsw i16 %149, 24
  %156 = zext nneg i16 %155 to i32
  %157 = add nsw i32 %156, -108
  %158 = mul nuw nsw i32 %154, 24
  %159 = add nuw nsw i32 %158, 212
  switch i16 %148, label %181 [
    i16 0, label %160
    i16 1, label %166
    i16 2, label %171
    i16 3, label %176
  ]

160:                                              ; preds = %145
  %161 = trunc nsw i32 %157 to i16
  %162 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 %161, ptr %162, align 2, !tbaa !14
  %163 = trunc nuw nsw i32 %158 to i16
  %164 = add nsw i16 %163, -108
  %165 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %143
  store i16 %164, ptr %165, align 2, !tbaa !14
  br label %186

166:                                              ; preds = %145
  %167 = trunc nsw i32 %157 to i16
  %168 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 %167, ptr %168, align 2, !tbaa !14
  %169 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %143
  store i16 120, ptr %169, align 2, !tbaa !14
  %170 = trunc nuw nsw i32 %159 to i16
  br label %186

171:                                              ; preds = %145
  %172 = trunc nsw i32 %157 to i16
  %173 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 %172, ptr %173, align 2, !tbaa !14
  %174 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %143
  store i16 -120, ptr %174, align 2, !tbaa !14
  %175 = trunc nuw nsw i32 %159 to i16
  br label %186

176:                                              ; preds = %145
  %177 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 -120, ptr %177, align 2, !tbaa !14
  %178 = trunc nsw i32 %157 to i16
  %179 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %143
  store i16 %178, ptr %179, align 2, !tbaa !14
  %180 = trunc nuw nsw i32 %159 to i16
  br label %186

181:                                              ; preds = %145
  %182 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 120, ptr %182, align 2, !tbaa !14
  %183 = trunc nsw i32 %157 to i16
  %184 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %143
  store i16 %183, ptr %184, align 2, !tbaa !14
  %185 = trunc nuw nsw i32 %159 to i16
  br label %186

186:                                              ; preds = %181, %176, %171, %166, %160
  %187 = phi i16 [ %185, %181 ], [ %180, %176 ], [ %175, %171 ], [ %170, %166 ], [ 440, %160 ]
  %188 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119284 to ptr), i32 %143
  store i16 %187, ptr %188, align 2, !tbaa !14
  %189 = add nuw nsw i32 %143, 1
  br label %142, !llvm.loop !19

190:                                              ; preds = %142, %237
  %191 = phi i32 [ %250, %237 ], [ 0, %142 ]
  %192 = icmp eq i32 %191, 10
  br i1 %192, label %289, label %193

193:                                              ; preds = %190
  %194 = add nsw i32 %191, -5
  %195 = icmp samesign ult i32 %191, 5
  %196 = select i1 %195, i32 %191, i32 %194
  %197 = select i1 %195, i32 245, i32 243
  %198 = select i1 %195, i32 75, i32 -79
  switch i32 %196, label %206 [
    i32 0, label %207
    i32 1, label %199
    i32 2, label %202
    i32 3, label %204
  ]

199:                                              ; preds = %193
  %200 = select i1 %195, i32 -75, i32 79
  %201 = select i1 %195, i32 -245, i32 -243
  br label %207

202:                                              ; preds = %193
  %203 = select i1 %195, i32 -75, i32 79
  br label %207

204:                                              ; preds = %193
  %205 = select i1 %195, i32 -245, i32 -243
  br label %207

206:                                              ; preds = %193
  br label %207

207:                                              ; preds = %206, %204, %202, %199, %193
  %208 = phi i32 [ 0, %206 ], [ %200, %199 ], [ %197, %202 ], [ %205, %204 ], [ %198, %193 ]
  %209 = phi i32 [ -256, %206 ], [ 0, %199 ], [ 0, %202 ], [ 0, %204 ], [ %196, %193 ]
  %210 = phi i32 [ 0, %206 ], [ %201, %199 ], [ %203, %202 ], [ %198, %204 ], [ %197, %193 ]
  %211 = trunc nsw i32 %210 to i16
  %212 = mul nuw nsw i32 %191, 6
  %213 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131602 to ptr), i32 %212
  store i16 %211, ptr %213, align 2, !tbaa !14
  %214 = trunc nsw i32 %209 to i16
  %215 = getelementptr inbounds nuw i8, ptr %213, i32 2
  store i16 %214, ptr %215, align 2, !tbaa !14
  %216 = trunc nsw i32 %208 to i16
  %217 = getelementptr inbounds nuw i8, ptr %213, i32 4
  store i16 %216, ptr %217, align 2, !tbaa !14
  %218 = getelementptr inbounds nuw [10 x i8], ptr @NFQ, i32 0, i32 %191
  %219 = load i8, ptr %218, align 1, !tbaa !12
  %220 = zext i8 %219 to i32
  %221 = icmp eq i32 %196, 4
  %222 = mul nuw nsw i32 %220, %220
  %223 = select i1 %195, i16 10800, i16 5184
  %224 = select i1 %221, i16 5184, i16 %223
  %225 = trunc nuw i32 %222 to i16
  %226 = udiv i16 %224, %225
  %227 = zext nneg i16 %226 to i32
  %228 = shl nuw nsw i32 %227, 8
  %229 = udiv i32 %228, 576
  %230 = trunc nuw nsw i32 %229 to i16
  %231 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131662 to ptr), i32 %191
  store i16 %230, ptr %231, align 2, !tbaa !14
  %232 = getelementptr inbounds nuw [10 x i8], ptr @PBASE, i32 0, i32 %191
  %233 = trunc nuw i32 %191 to i8
  br label %234

234:                                              ; preds = %251, %207
  %235 = phi i32 [ 0, %207 ], [ %288, %251 ]
  %236 = icmp eq i32 %235, %222
  br i1 %236, label %237, label %251

237:                                              ; preds = %234
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #12
  %238 = lshr i32 %220, 1
  call fastcc void @face_point(i32 noundef %191, i32 noundef %238, i32 noundef %238, ptr noundef %7, ptr noundef %8, ptr noundef %9) #13
  %239 = load i32, ptr %7, align 4, !tbaa !3
  %240 = mul nsw i32 %239, %210
  %241 = load i32, ptr %8, align 4, !tbaa !3
  %242 = mul nsw i32 %241, %209
  %243 = add nsw i32 %242, %240
  %244 = load i32, ptr %9, align 4, !tbaa !3
  %245 = mul nsw i32 %244, %208
  %246 = add nsw i32 %243, %245
  %247 = lshr i32 %246, 31
  %248 = trunc nuw nsw i32 %247 to i16
  %249 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131682 to ptr), i32 %191
  store i16 %248, ptr %249, align 2, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #12
  %250 = add nuw nsw i32 %191, 1
  br label %190, !llvm.loop !20

251:                                              ; preds = %234
  %252 = load i8, ptr %232, align 1, !tbaa !12
  %253 = zext i8 %252 to i32
  %254 = add nuw nsw i32 %235, 500
  %255 = add nuw nsw i32 %254, %253
  %256 = freeze i32 %235
  %257 = freeze i32 %220
  %258 = udiv i32 %256, %257
  %259 = mul i32 %258, %257
  %260 = sub i32 %256, %259
  %261 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131346 to ptr), i32 %235
  %262 = getelementptr inbounds nuw i8, ptr %261, i32 %253
  store i8 %233, ptr %262, align 1, !tbaa !12
  %263 = shl i32 %258, 4
  %264 = or i32 %263, %260
  %265 = trunc i32 %264 to i8
  %266 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131474 to ptr), i32 %235
  %267 = getelementptr inbounds nuw i8, ptr %266, i32 %253
  store i8 %265, ptr %267, align 1, !tbaa !12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #12
  call fastcc void @face_point(i32 noundef %191, i32 noundef %260, i32 noundef %258, ptr noundef %1, ptr noundef %2, ptr noundef %3) #13
  %268 = add nuw nsw i32 %260, 1
  %269 = add nuw nsw i32 %258, 1
  call fastcc void @face_point(i32 noundef %191, i32 noundef %268, i32 noundef %269, ptr noundef %4, ptr noundef %5, ptr noundef %6) #13
  %270 = load i32, ptr %1, align 4, !tbaa !3
  %271 = load i32, ptr %4, align 4, !tbaa !3
  %272 = add nsw i32 %271, %270
  %273 = sdiv i32 %272, 2
  %274 = trunc i32 %273 to i16
  %275 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %255
  store i16 %274, ptr %275, align 2, !tbaa !14
  %276 = load i32, ptr %2, align 4, !tbaa !3
  %277 = load i32, ptr %5, align 4, !tbaa !3
  %278 = add nsw i32 %277, %276
  %279 = sdiv i32 %278, 2
  %280 = trunc i32 %279 to i16
  %281 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %255
  store i16 %280, ptr %281, align 2, !tbaa !14
  %282 = load i32, ptr %3, align 4, !tbaa !3
  %283 = load i32, ptr %6, align 4, !tbaa !3
  %284 = add nsw i32 %283, %282
  %285 = sdiv i32 %284, 2
  %286 = trunc i32 %285 to i16
  %287 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119284 to ptr), i32 %255
  store i16 %286, ptr %287, align 2, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #12
  %288 = add nuw nsw i32 %235, 1
  br label %234, !llvm.loop !21

289:                                              ; preds = %190, %292
  %290 = phi i32 [ %308, %292 ], [ 0, %190 ]
  %291 = icmp eq i32 %290, 25
  br i1 %291, label %309, label %292

292:                                              ; preds = %289
  %293 = add nuw nsw i32 %290, 628
  %294 = trunc nuw i32 %290 to i8
  %295 = freeze i8 %294
  %296 = udiv i8 %295, 5
  %297 = mul i8 %296, 5
  %298 = sub i8 %295, %297
  %299 = zext nneg i8 %298 to i16
  %300 = mul nuw nsw i16 %299, 48
  %301 = add nsw i16 %300, -96
  %302 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %293
  store i16 %301, ptr %302, align 2, !tbaa !14
  %303 = zext nneg i8 %296 to i16
  %304 = mul nuw nsw i16 %303, 48
  %305 = add nsw i16 %304, -96
  %306 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %293
  store i16 %305, ptr %306, align 2, !tbaa !14
  %307 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119284 to ptr), i32 %293
  store i16 200, ptr %307, align 2, !tbaa !14
  %308 = add nuw nsw i32 %290, 1
  br label %289, !llvm.loop !22

309:                                              ; preds = %289, %323
  %310 = phi i32 [ %324, %323 ], [ 0, %289 ]
  %311 = icmp eq i32 %310, 653
  br i1 %311, label %325, label %312

312:                                              ; preds = %309
  %313 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123202 to ptr), i32 %310
  store i16 0, ptr %313, align 2, !tbaa !14
  %314 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121896 to ptr), i32 %310
  store i16 0, ptr %314, align 2, !tbaa !14
  %315 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120590 to ptr), i32 %310
  store i16 0, ptr %315, align 2, !tbaa !14
  %316 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127120 to ptr), i32 %310
  store i16 0, ptr %316, align 2, !tbaa !14
  %317 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125814 to ptr), i32 %310
  store i16 0, ptr %317, align 2, !tbaa !14
  %318 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124508 to ptr), i32 %310
  store i16 0, ptr %318, align 2, !tbaa !14
  %319 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128426 to ptr), i32 %310
  store i16 -1, ptr %319, align 2, !tbaa !14
  %320 = tail call fastcc i32 @is_light(i32 noundef %310) #13
  %321 = icmp eq i32 %320, 0
  br i1 %321, label %323, label %322

322:                                              ; preds = %312
  store i16 -36, ptr %318, align 2, !tbaa !14
  store i16 -36, ptr %317, align 2, !tbaa !14
  store i16 -6586, ptr %316, align 2, !tbaa !14
  br label %323

323:                                              ; preds = %322, %312
  %324 = add nuw nsw i32 %310, 1
  br label %309, !llvm.loop !23

325:                                              ; preds = %309
  tail call fastcc void @repaint(i32 noundef 1) #13
  br label %326

326:                                              ; preds = %347, %325
  %327 = phi i32 [ 0, %325 ], [ %343, %347 ]
  br label %328

328:                                              ; preds = %326, %341
  %329 = phi i1 [ false, %341 ], [ true, %326 ]
  br label %330

330:                                              ; preds = %328, %337
  %331 = phi i1 [ false, %337 ], [ %329, %328 ]
  tail call void @in_poll() #11
  %332 = load i32, ptr @in_edge, align 4, !tbaa !3
  %333 = and i32 %332, 31
  %334 = icmp eq i32 %333, 0
  br i1 %334, label %336, label %335

335:                                              ; preds = %330
  tail call void @led(i32 noundef 0, i32 noundef 0) #11
  tail call void @uputs(ptr noundef nonnull @.str.1) #11
  ret void

336:                                              ; preds = %330
  br i1 %331, label %338, label %337

337:                                              ; preds = %336
  tail call void @frame_sync(i32 noundef 33000) #11
  br label %330, !llvm.loop !24

338:                                              ; preds = %336
  %339 = tail call fastcc i32 @brightest() #13
  %340 = icmp slt i32 %339, 0
  br i1 %340, label %341, label %342

341:                                              ; preds = %338
  tail call void @uputs(ptr noundef nonnull @.str.2) #11
  tail call void @uputn(i32 noundef %327) #11
  tail call void @uputs(ptr noundef nonnull @.str.3) #11
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #11
  br label %328, !llvm.loop !24

342:                                              ; preds = %338
  tail call fastcc void @shoot(i32 noundef %339) #13
  %343 = add i32 %327, 1
  tail call fastcc void @repaint(i32 noundef 0) #13
  %344 = and i32 %343, 15
  %345 = icmp eq i32 %344, 0
  br i1 %345, label %346, label %347

346:                                              ; preds = %342
  tail call void @uputs(ptr noundef nonnull @.str.4) #11
  tail call void @uputn(i32 noundef %343) #11
  tail call void @uputs(ptr noundef nonnull @.str.5) #11
  br label %347

347:                                              ; preds = %346, %342
  br label %326
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
  %22 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128426 to ptr), i32 %7
  %23 = load i16, ptr %22, align 2, !tbaa !14
  %24 = icmp eq i16 %20, %23
  br i1 %24, label %132, label %25

25:                                               ; preds = %21, %19
  %26 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128426 to ptr), i32 %7
  store i16 %20, ptr %26, align 2, !tbaa !14
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
  %42 = getelementptr i8, ptr inttoptr (i32 537129732 to ptr), i32 %37
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
  br label %6, !llvm.loop !25

135:                                              ; preds = %10, %285
  %136 = phi i32 [ %286, %285 ], [ 500, %10 ]
  %137 = icmp eq i32 %136, 628
  br i1 %137, label %138, label %139

138:                                              ; preds = %135
  tail call void @gfx_present() #11
  ret void

139:                                              ; preds = %135
  %140 = tail call fastcc zeroext i16 @patch_color(i32 noundef %136) #13
  br i1 %12, label %141, label %145

141:                                              ; preds = %139
  %142 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128426 to ptr), i32 %136
  %143 = load i16, ptr %142, align 2, !tbaa !14
  %144 = icmp eq i16 %140, %143
  br i1 %144, label %285, label %145

145:                                              ; preds = %141, %139
  %146 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128426 to ptr), i32 %136
  store i16 %140, ptr %146, align 2, !tbaa !14
  %147 = add nsw i32 %136, -500
  %148 = getelementptr inbounds i8, ptr inttoptr (i32 537131346 to ptr), i32 %147
  %149 = load i8, ptr %148, align 1, !tbaa !12
  %150 = zext i8 %149 to i32
  %151 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131682 to ptr), i32 %150
  %152 = load i16, ptr %151, align 2, !tbaa !14
  %153 = icmp eq i16 %152, 0
  br i1 %153, label %285, label %154

154:                                              ; preds = %145
  %155 = getelementptr inbounds i8, ptr inttoptr (i32 537131474 to ptr), i32 %147
  %156 = load i8, ptr %155, align 1, !tbaa !12
  %157 = zext i8 %156 to i32
  %158 = and i32 %157, 15
  %159 = lshr i32 %157, 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #12
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #12
  %160 = getelementptr inbounds nuw [10 x i16], ptr @CGOFF, i32 0, i32 %150
  %161 = load i16, ptr %160, align 2, !tbaa !14
  %162 = zext i16 %161 to i32
  %163 = getelementptr inbounds nuw [10 x i8], ptr @NFQ, i32 0, i32 %150
  %164 = load i8, ptr %163, align 1, !tbaa !12
  %165 = zext i8 %164 to i32
  %166 = add nuw nsw i32 %165, 1
  %167 = mul nuw nsw i32 %166, %159
  %168 = add nuw nsw i32 %167, %162
  %169 = add nuw nsw i32 %168, %158
  %170 = shl nuw nsw i32 %169, 1
  %171 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130942 to ptr), i32 %170
  %172 = add nuw nsw i32 %158, 1
  %173 = add nuw nsw i32 %168, %172
  %174 = shl nuw nsw i32 %173, 1
  %175 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130942 to ptr), i32 %174
  %176 = add nuw nsw i32 %159, 1
  %177 = mul nuw nsw i32 %166, %176
  %178 = add nuw nsw i32 %177, %162
  %179 = add nuw nsw i32 %178, %172
  %180 = shl nuw nsw i32 %179, 1
  %181 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130942 to ptr), i32 %180
  %182 = add nuw nsw i32 %178, %158
  %183 = shl nuw nsw i32 %182, 1
  %184 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130942 to ptr), i32 %183
  %185 = load i8, ptr %171, align 2, !tbaa !12
  %186 = zext i8 %185 to i32
  store i32 %186, ptr %3, align 4, !tbaa !3
  %187 = getelementptr inbounds nuw i8, ptr %171, i32 1
  %188 = load i8, ptr %187, align 1, !tbaa !12
  %189 = zext i8 %188 to i32
  store i32 %189, ptr %4, align 4, !tbaa !3
  %190 = load i8, ptr %175, align 2, !tbaa !12
  %191 = zext i8 %190 to i32
  store i32 %191, ptr %13, align 4, !tbaa !3
  %192 = getelementptr inbounds nuw i8, ptr %175, i32 1
  %193 = load i8, ptr %192, align 1, !tbaa !12
  %194 = zext i8 %193 to i32
  store i32 %194, ptr %14, align 4, !tbaa !3
  %195 = load i8, ptr %181, align 2, !tbaa !12
  %196 = zext i8 %195 to i32
  store i32 %196, ptr %15, align 4, !tbaa !3
  %197 = getelementptr inbounds nuw i8, ptr %181, i32 1
  %198 = load i8, ptr %197, align 1, !tbaa !12
  %199 = zext i8 %198 to i32
  store i32 %199, ptr %16, align 4, !tbaa !3
  %200 = load i8, ptr %184, align 2, !tbaa !12
  %201 = zext i8 %200 to i32
  store i32 %201, ptr %17, align 4, !tbaa !3
  %202 = getelementptr inbounds nuw i8, ptr %184, i32 1
  %203 = load i8, ptr %202, align 1, !tbaa !12
  %204 = zext i8 %203 to i32
  store i32 %204, ptr %18, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #12
  br label %205

205:                                              ; preds = %229, %154
  %206 = phi i32 [ 0, %154 ], [ %215, %229 ]
  %207 = phi i32 [ %186, %154 ], [ %214, %229 ]
  %208 = phi i32 [ %186, %154 ], [ %213, %229 ]
  %209 = icmp eq i32 %206, 4
  br i1 %209, label %232, label %210

210:                                              ; preds = %205
  %211 = getelementptr inbounds nuw i32, ptr %3, i32 %206
  %212 = load i32, ptr %211, align 4, !tbaa !3
  %213 = tail call i32 @llvm.smin.i32(i32 %212, i32 %208)
  %214 = tail call i32 @llvm.smax.i32(i32 %212, i32 %207)
  %215 = add nuw nsw i32 %206, 1
  %216 = and i32 %215, 3
  %217 = getelementptr inbounds nuw i32, ptr %3, i32 %216
  %218 = load i32, ptr %217, align 4, !tbaa !3
  %219 = icmp eq i32 %218, %212
  br i1 %219, label %229, label %220

220:                                              ; preds = %210
  %221 = sub nsw i32 %218, %212
  %222 = getelementptr inbounds nuw i32, ptr %4, i32 %216
  %223 = load i32, ptr %222, align 4, !tbaa !3
  %224 = getelementptr inbounds nuw i32, ptr %4, i32 %206
  %225 = load i32, ptr %224, align 4, !tbaa !3
  %226 = sub nsw i32 %223, %225
  %227 = shl i32 %226, 12
  %228 = sdiv i32 %227, %221
  br label %229

229:                                              ; preds = %220, %210
  %230 = phi i32 [ %228, %220 ], [ 0, %210 ]
  %231 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %206
  store i32 %230, ptr %231, align 4, !tbaa !3
  br label %205, !llvm.loop !26

232:                                              ; preds = %205, %282
  %233 = phi i32 [ %283, %282 ], [ %208, %205 ]
  %234 = icmp sgt i32 %233, %207
  br i1 %234, label %284, label %235

235:                                              ; preds = %232, %268
  %236 = phi i32 [ %269, %268 ], [ 32767, %232 ]
  %237 = phi i32 [ %270, %268 ], [ -32768, %232 ]
  %238 = phi i32 [ %247, %268 ], [ 0, %232 ]
  br label %239

239:                                              ; preds = %256, %235
  %240 = phi i32 [ %238, %235 ], [ %247, %256 ]
  %241 = icmp eq i32 %240, 4
  br i1 %241, label %242, label %244

242:                                              ; preds = %239
  %243 = icmp sgt i32 %237, %236
  br i1 %243, label %280, label %282

244:                                              ; preds = %239
  %245 = getelementptr inbounds nuw i32, ptr %3, i32 %240
  %246 = load i32, ptr %245, align 4, !tbaa !3
  %247 = add nuw nsw i32 %240, 1
  %248 = and i32 %247, 3
  %249 = getelementptr inbounds nuw i32, ptr %3, i32 %248
  %250 = load i32, ptr %249, align 4, !tbaa !3
  %251 = tail call i32 @llvm.smin.i32(i32 %246, i32 %250)
  %252 = icmp slt i32 %233, %251
  br i1 %252, label %256, label %253

253:                                              ; preds = %244
  %254 = tail call i32 @llvm.smax.i32(i32 %246, i32 %250)
  %255 = icmp sgt i32 %233, %254
  br i1 %255, label %256, label %257

256:                                              ; preds = %253, %244
  br label %239, !llvm.loop !27

257:                                              ; preds = %253
  %258 = icmp eq i32 %246, %250
  %259 = getelementptr inbounds nuw i32, ptr %4, i32 %240
  %260 = load i32, ptr %259, align 4, !tbaa !3
  br i1 %258, label %261, label %271

261:                                              ; preds = %257
  %262 = getelementptr inbounds nuw i32, ptr %4, i32 %248
  %263 = load i32, ptr %262, align 4, !tbaa !3
  %264 = tail call i32 @llvm.smin.i32(i32 %263, i32 %260)
  %265 = tail call i32 @llvm.smax.i32(i32 %263, i32 %260)
  %266 = tail call i32 @llvm.smin.i32(i32 %264, i32 %236)
  %267 = tail call i32 @llvm.smax.i32(i32 %265, i32 %237)
  br label %268

268:                                              ; preds = %261, %271
  %269 = phi i32 [ %278, %271 ], [ %266, %261 ]
  %270 = phi i32 [ %279, %271 ], [ %267, %261 ]
  br label %235, !llvm.loop !27

271:                                              ; preds = %257
  %272 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %240
  %273 = load i32, ptr %272, align 4, !tbaa !3
  %274 = sub nsw i32 %233, %246
  %275 = mul nsw i32 %273, %274
  %276 = ashr i32 %275, 12
  %277 = add nsw i32 %276, %260
  %278 = tail call i32 @llvm.smin.i32(i32 %277, i32 %236)
  %279 = tail call i32 @llvm.smax.i32(i32 %277, i32 %237)
  br label %268

280:                                              ; preds = %242
  %281 = sub nsw i32 %237, %236
  tail call void @gfx_fill(i32 noundef %233, i32 noundef %236, i32 noundef 1, i32 noundef %281, i16 noundef zeroext %140) #11
  br label %282

282:                                              ; preds = %280, %242
  %283 = add nsw i32 %233, 1
  br label %232, !llvm.loop !28

284:                                              ; preds = %232
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %285

285:                                              ; preds = %284, %145, %141
  %286 = add nuw nsw i32 %136, 1
  br label %135, !llvm.loop !29
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

1:                                                ; preds = %31, %0
  %2 = phi i32 [ -1, %0 ], [ %36, %31 ]
  %3 = phi i32 [ 0, %0 ], [ %38, %31 ]
  %4 = phi i32 [ 0, %0 ], [ %37, %31 ]
  %5 = icmp eq i32 %3, 653
  br i1 %5, label %6, label %9

6:                                                ; preds = %1
  %7 = icmp samesign ugt i32 %4, 95
  %8 = select i1 %7, i32 %2, i32 -1
  ret i32 %8

9:                                                ; preds = %1
  %10 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124508 to ptr), i32 %3
  %11 = load i16, ptr %10, align 2, !tbaa !14
  %12 = zext i16 %11 to i32
  %13 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125814 to ptr), i32 %3
  %14 = load i16, ptr %13, align 2, !tbaa !14
  %15 = zext i16 %14 to i32
  %16 = add nuw nsw i32 %15, %12
  %17 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127120 to ptr), i32 %3
  %18 = load i16, ptr %17, align 2, !tbaa !14
  %19 = zext i16 %18 to i32
  %20 = add nuw nsw i32 %16, %19
  %21 = icmp samesign ult i32 %3, 500
  br i1 %21, label %31, label %22

22:                                               ; preds = %9
  %23 = icmp samesign ugt i32 %3, 627
  br i1 %23, label %31, label %24

24:                                               ; preds = %22
  %25 = getelementptr i8, ptr inttoptr (i32 537130846 to ptr), i32 %3
  %26 = load i8, ptr %25, align 1, !tbaa !12
  %27 = zext i8 %26 to i32
  %28 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131662 to ptr), i32 %27
  %29 = load i16, ptr %28, align 2, !tbaa !14
  %30 = sext i16 %29 to i32
  br label %31

31:                                               ; preds = %9, %22, %24
  %32 = phi i32 [ %30, %24 ], [ 256, %9 ], [ 1024, %22 ]
  %33 = mul i32 %32, %20
  %34 = lshr i32 %33, 8
  %35 = icmp samesign ugt i32 %34, %4
  %36 = select i1 %35, i32 %3, i32 %2
  %37 = tail call i32 @llvm.umax.i32(i32 %34, i32 %4)
  %38 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !30
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
  br i1 %8, label %19, label %9

9:                                                ; preds = %1
  %10 = icmp samesign ugt i32 %0, 627
  br i1 %10, label %19, label %11

11:                                               ; preds = %9
  %12 = getelementptr i8, ptr inttoptr (i32 537131346 to ptr), i32 %0
  %13 = getelementptr i8, ptr %12, i32 -500
  %14 = load i8, ptr %13, align 1, !tbaa !12
  %15 = zext i8 %14 to i32
  %16 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131662 to ptr), i32 %15
  %17 = load i16, ptr %16, align 2, !tbaa !14
  %18 = sext i16 %17 to i32
  br label %19

19:                                               ; preds = %1, %9, %11
  %20 = phi i32 [ %18, %11 ], [ 256, %1 ], [ 1024, %9 ]
  %21 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124508 to ptr), i32 %0
  %22 = load i16, ptr %21, align 2, !tbaa !14
  %23 = zext i16 %22 to i32
  %24 = mul nsw i32 %20, %23
  %25 = lshr i32 %24, 8
  %26 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125814 to ptr), i32 %0
  %27 = load i16, ptr %26, align 2, !tbaa !14
  %28 = zext i16 %27 to i32
  %29 = mul nsw i32 %20, %28
  %30 = lshr i32 %29, 8
  %31 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127120 to ptr), i32 %0
  %32 = load i16, ptr %31, align 2, !tbaa !14
  %33 = zext i16 %32 to i32
  %34 = mul nsw i32 %20, %33
  %35 = lshr i32 %34, 8
  store i16 0, ptr %31, align 2, !tbaa !14
  store i16 0, ptr %26, align 2, !tbaa !14
  store i16 0, ptr %21, align 2, !tbaa !14
  %36 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %0
  %37 = load i16, ptr %36, align 2, !tbaa !14
  %38 = sext i16 %37 to i32
  %39 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %0
  %40 = load i16, ptr %39, align 2, !tbaa !14
  %41 = sext i16 %40 to i32
  %42 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119284 to ptr), i32 %0
  %43 = load i16, ptr %42, align 2, !tbaa !14
  %44 = sext i16 %43 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #12
  call fastcc void @normal_of(i32 noundef %0, ptr noundef %2, ptr noundef %3, ptr noundef %4) #13
  %45 = load i32, ptr %2, align 4
  %46 = load i32, ptr %3, align 4
  %47 = load i32, ptr %4, align 4
  br label %48

48:                                               ; preds = %174, %19
  %49 = phi i32 [ 0, %19 ], [ %175, %174 ]
  %50 = icmp eq i32 %49, 653
  br i1 %50, label %51, label %52

51:                                               ; preds = %48
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #12
  ret void

52:                                               ; preds = %48
  %53 = icmp eq i32 %49, %0
  br i1 %53, label %174, label %54

54:                                               ; preds = %52
  %55 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %49
  %56 = load i16, ptr %55, align 2, !tbaa !14
  %57 = sext i16 %56 to i32
  %58 = sub nsw i32 %57, %38
  %59 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %49
  %60 = load i16, ptr %59, align 2, !tbaa !14
  %61 = sext i16 %60 to i32
  %62 = sub nsw i32 %61, %41
  %63 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119284 to ptr), i32 %49
  %64 = load i16, ptr %63, align 2, !tbaa !14
  %65 = sext i16 %64 to i32
  %66 = sub nsw i32 %65, %44
  %67 = mul nsw i32 %45, %58
  %68 = mul nsw i32 %46, %62
  %69 = add nsw i32 %68, %67
  %70 = mul nsw i32 %47, %66
  %71 = add nsw i32 %69, %70
  %72 = ashr i32 %71, 8
  %73 = icmp slt i32 %72, 1
  br i1 %73, label %174, label %74

74:                                               ; preds = %54
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #12
  call fastcc void @normal_of(i32 noundef %49, ptr noundef %5, ptr noundef %6, ptr noundef %7) #13
  %75 = load i32, ptr %5, align 4, !tbaa !3
  %76 = mul nsw i32 %75, %58
  %77 = load i32, ptr %6, align 4, !tbaa !3
  %78 = mul nsw i32 %77, %62
  %79 = add nsw i32 %78, %76
  %80 = load i32, ptr %7, align 4, !tbaa !3
  %81 = mul nsw i32 %80, %66
  %82 = add nsw i32 %79, %81
  %83 = ashr i32 %82, 8
  %84 = icmp sgt i32 %83, -1
  br i1 %84, label %173, label %85

85:                                               ; preds = %74
  %86 = mul nsw i32 %58, %58
  %87 = mul nsw i32 %62, %62
  %88 = add nuw i32 %87, %86
  %89 = mul nsw i32 %66, %66
  %90 = add i32 %88, %89
  %91 = icmp ult i32 %90, 64
  br i1 %91, label %173, label %92

92:                                               ; preds = %85
  %93 = tail call fastcc i32 @clearance(i32 noundef %0, i32 noundef %49) #13
  %94 = icmp eq i32 %93, 0
  br i1 %94, label %173, label %95

95:                                               ; preds = %92
  %96 = mul i32 %72, -1024
  %97 = mul i32 %96, %83
  %98 = udiv i32 %97, %90
  %99 = udiv i32 589824, %90
  %100 = tail call i32 @llvm.umin.i32(i32 %99, i32 4096)
  %101 = mul nuw i32 %98, 41
  %102 = mul i32 %101, %100
  %103 = lshr i32 %102, 15
  %104 = mul nsw i32 %93, 51
  %105 = mul i32 %104, %103
  %106 = icmp ult i32 %105, 256
  br i1 %106, label %173, label %107

107:                                              ; preds = %95
  %108 = lshr i32 %105, 8
  %109 = icmp samesign ugt i32 %49, 627
  %110 = icmp samesign ult i32 %49, 500
  %111 = trunc nuw i32 %49 to i16
  %112 = udiv i16 %111, 100
  %113 = zext nneg i16 %112 to i32
  %114 = select i1 %110, i32 %113, i32 5
  %115 = select i1 %109, i32 0, i32 %114
  %116 = getelementptr inbounds nuw [6 x [3 x i16]], ptr @rho, i32 0, i32 %115
  %117 = mul i32 %108, %25
  %118 = lshr i32 %117, 12
  %119 = load i16, ptr %116, align 2, !tbaa !14
  %120 = zext i16 %119 to i32
  %121 = mul i32 %118, %120
  %122 = lshr i32 %121, 8
  %123 = mul i32 %108, %30
  %124 = lshr i32 %123, 12
  %125 = getelementptr inbounds nuw i8, ptr %116, i32 2
  %126 = load i16, ptr %125, align 2, !tbaa !14
  %127 = zext i16 %126 to i32
  %128 = mul i32 %124, %127
  %129 = lshr i32 %128, 8
  %130 = mul i32 %108, %35
  %131 = lshr i32 %130, 12
  %132 = getelementptr inbounds nuw i8, ptr %116, i32 4
  %133 = load i16, ptr %132, align 2, !tbaa !14
  %134 = zext i16 %133 to i32
  %135 = mul i32 %131, %134
  %136 = lshr i32 %135, 8
  %137 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120590 to ptr), i32 %49
  %138 = load i16, ptr %137, align 2, !tbaa !14
  %139 = zext i16 %138 to i32
  %140 = add nuw nsw i32 %122, %139
  %141 = tail call i32 @llvm.umin.i32(i32 %140, i32 65535)
  %142 = trunc nuw i32 %141 to i16
  store i16 %142, ptr %137, align 2, !tbaa !14
  %143 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121896 to ptr), i32 %49
  %144 = load i16, ptr %143, align 2, !tbaa !14
  %145 = zext i16 %144 to i32
  %146 = add nuw nsw i32 %129, %145
  %147 = tail call i32 @llvm.umin.i32(i32 %146, i32 65535)
  %148 = trunc nuw i32 %147 to i16
  store i16 %148, ptr %143, align 2, !tbaa !14
  %149 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123202 to ptr), i32 %49
  %150 = load i16, ptr %149, align 2, !tbaa !14
  %151 = zext i16 %150 to i32
  %152 = add nuw nsw i32 %136, %151
  %153 = tail call i32 @llvm.umin.i32(i32 %152, i32 65535)
  %154 = trunc nuw i32 %153 to i16
  store i16 %154, ptr %149, align 2, !tbaa !14
  %155 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124508 to ptr), i32 %49
  %156 = load i16, ptr %155, align 2, !tbaa !14
  %157 = zext i16 %156 to i32
  %158 = add nuw nsw i32 %122, %157
  %159 = tail call i32 @llvm.umin.i32(i32 %158, i32 65535)
  %160 = trunc nuw i32 %159 to i16
  store i16 %160, ptr %155, align 2, !tbaa !14
  %161 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125814 to ptr), i32 %49
  %162 = load i16, ptr %161, align 2, !tbaa !14
  %163 = zext i16 %162 to i32
  %164 = add nuw nsw i32 %129, %163
  %165 = tail call i32 @llvm.umin.i32(i32 %164, i32 65535)
  %166 = trunc nuw i32 %165 to i16
  store i16 %166, ptr %161, align 2, !tbaa !14
  %167 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127120 to ptr), i32 %49
  %168 = load i16, ptr %167, align 2, !tbaa !14
  %169 = zext i16 %168 to i32
  %170 = add nuw nsw i32 %136, %169
  %171 = tail call i32 @llvm.umin.i32(i32 %170, i32 65535)
  %172 = trunc nuw i32 %171 to i16
  store i16 %172, ptr %167, align 2, !tbaa !14
  br label %173

173:                                              ; preds = %85, %107, %95, %92, %74
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #12
  br label %174

174:                                              ; preds = %173, %54, %52
  %175 = add nuw nsw i32 %49, 1
  br label %48, !llvm.loop !31
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write)
define internal fastcc void @face_point(i32 noundef range(i32 -2147483648, 10) %0, i32 noundef range(i32 -2147483648, 256) %1, i32 noundef range(i32 -2147483648, 65026) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %4, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %5) unnamed_addr #5 {
  %7 = srem i32 %0, 5
  %8 = getelementptr inbounds [10 x i8], ptr @NFQ, i32 0, i32 %0
  %9 = load i8, ptr %8, align 1, !tbaa !12
  %10 = zext i8 %9 to i32
  %11 = mul nsw i32 %1, 72
  %12 = sdiv i32 %11, %10
  %13 = add nsw i32 %12, -36
  switch i32 %7, label %17 [
    i32 0, label %21
    i32 1, label %14
    i32 2, label %15
    i32 3, label %16
  ]

14:                                               ; preds = %6
  br label %21

15:                                               ; preds = %6
  br label %21

16:                                               ; preds = %6
  br label %21

17:                                               ; preds = %6
  %18 = mul nsw i32 %2, 72
  %19 = sdiv i32 %18, %10
  %20 = add nsw i32 %19, -36
  br label %21

21:                                               ; preds = %6, %17, %16, %15, %14
  %22 = phi i32 [ %13, %17 ], [ -36, %14 ], [ %13, %15 ], [ %13, %16 ], [ 36, %6 ]
  %23 = phi i32 [ %20, %17 ], [ %13, %14 ], [ 36, %15 ], [ -36, %16 ], [ %13, %6 ]
  %24 = add nsw i32 %0, 4
  %25 = icmp ult i32 %24, 9
  %26 = select i1 %25, i32 -30, i32 48
  %27 = sub nsw i32 120, %26
  %28 = mul nsw i32 %27, %2
  %29 = sdiv i32 %28, %10
  %30 = select i1 %25, i32 245, i32 243
  %31 = select i1 %25, i32 -75, i32 79
  %32 = select i1 %25, i32 -42, i32 45
  %33 = select i1 %25, i32 75, i32 -79
  %34 = select i1 %25, i32 330, i32 268
  %35 = mul nsw i32 %22, %30
  %36 = mul i32 %23, %31
  %37 = add i32 %36, %35
  %38 = ashr i32 %37, 8
  %39 = add nsw i32 %38, %32
  %40 = mul nsw i32 %22, %33
  %41 = mul nsw i32 %23, %30
  %42 = add nsw i32 %41, %40
  %43 = ashr i32 %42, 8
  %44 = add nsw i32 %43, %34
  store i32 %39, ptr %3, align 4, !tbaa !3
  store i32 %44, ptr %5, align 4, !tbaa !3
  %45 = icmp eq i32 %7, 4
  %46 = select i1 %45, i32 0, i32 %29
  %47 = add nsw i32 %46, %26
  store i32 %47, ptr %4, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @is_light(i32 noundef range(i32 -2147483648, 653) %0) unnamed_addr #6 {
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
define internal fastcc zeroext i16 @patch_color(i32 noundef range(i32 -2147483648, 628) %0) unnamed_addr #7 {
  %2 = tail call fastcc i32 @is_light(i32 noundef %0) #13
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %24

4:                                                ; preds = %1
  %5 = getelementptr inbounds i16, ptr inttoptr (i32 537120590 to ptr), i32 %0
  %6 = load i16, ptr %5, align 2, !tbaa !14
  %7 = lshr i16 %6, 3
  %8 = tail call i16 @llvm.umin.i16(i16 %7, i16 255)
  %9 = shl nuw i16 %8, 8
  %10 = and i16 %9, -2048
  %11 = getelementptr inbounds i16, ptr inttoptr (i32 537121896 to ptr), i32 %0
  %12 = load i16, ptr %11, align 2, !tbaa !14
  %13 = lshr i16 %12, 3
  %14 = tail call i16 @llvm.umin.i16(i16 %13, i16 255)
  %15 = shl nuw nsw i16 %14, 3
  %16 = and i16 %15, 2016
  %17 = or disjoint i16 %16, %10
  %18 = getelementptr inbounds i16, ptr inttoptr (i32 537123202 to ptr), i32 %0
  %19 = load i16, ptr %18, align 2, !tbaa !14
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
  br label %19, !llvm.loop !32

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
  br label %19, !llvm.loop !33

34:                                               ; preds = %19, %7
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: readwrite, inaccessiblemem: none)
define internal fastcc void @normal_of(i32 noundef %0, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #8 {
  %5 = icmp sgt i32 %0, 627
  br i1 %5, label %6, label %7

6:                                                ; preds = %4
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %31

7:                                                ; preds = %4
  %8 = icmp sgt i32 %0, 499
  br i1 %8, label %9, label %24

9:                                                ; preds = %7
  %10 = getelementptr i8, ptr inttoptr (i32 537131346 to ptr), i32 %0
  %11 = getelementptr i8, ptr %10, i32 -500
  %12 = load i8, ptr %11, align 1, !tbaa !12
  %13 = zext i8 %12 to i32
  %14 = mul nuw nsw i32 %13, 6
  %15 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131602 to ptr), i32 %14
  %16 = load i16, ptr %15, align 2, !tbaa !14
  %17 = sext i16 %16 to i32
  store i32 %17, ptr %1, align 4, !tbaa !3
  %18 = getelementptr inbounds nuw i8, ptr %15, i32 2
  %19 = load i16, ptr %18, align 2, !tbaa !14
  %20 = sext i16 %19 to i32
  store i32 %20, ptr %2, align 4, !tbaa !3
  %21 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %22 = load i16, ptr %21, align 2, !tbaa !14
  %23 = sext i16 %22 to i32
  br label %31

24:                                               ; preds = %7
  %25 = sdiv i32 %0, 100
  switch i32 %25, label %30 [
    i32 0, label %26
    i32 1, label %27
    i32 2, label %28
    i32 3, label %29
  ]

26:                                               ; preds = %24
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %31

27:                                               ; preds = %24
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 -256, ptr %2, align 4, !tbaa !3
  br label %31

28:                                               ; preds = %24
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 256, ptr %2, align 4, !tbaa !3
  br label %31

29:                                               ; preds = %24
  store i32 256, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %31

30:                                               ; preds = %24
  store i32 -256, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %31

31:                                               ; preds = %6, %9, %30, %29, %28, %27, %26
  %32 = phi i32 [ 256, %6 ], [ %23, %9 ], [ 0, %30 ], [ 0, %29 ], [ 0, %28 ], [ 0, %27 ], [ -256, %26 ]
  store i32 %32, ptr %3, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc i32 @clearance(i32 noundef range(i32 0, -2147483648) %0, i32 noundef range(i32 -2147483648, 653) %1) unnamed_addr #3 {
  %3 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %0
  %4 = load i16, ptr %3, align 2, !tbaa !14
  %5 = sext i16 %4 to i32
  %6 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117978 to ptr), i32 %0
  %7 = load i16, ptr %6, align 2, !tbaa !14
  %8 = sext i16 %7 to i32
  %9 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119284 to ptr), i32 %0
  %10 = load i16, ptr %9, align 2, !tbaa !14
  %11 = sext i16 %10 to i32
  %12 = getelementptr inbounds i16, ptr inttoptr (i32 537116672 to ptr), i32 %1
  %13 = load i16, ptr %12, align 2, !tbaa !14
  %14 = sext i16 %13 to i32
  %15 = sub nsw i32 %14, %5
  %16 = getelementptr inbounds i16, ptr inttoptr (i32 537117978 to ptr), i32 %1
  %17 = load i16, ptr %16, align 2, !tbaa !14
  %18 = sext i16 %17 to i32
  %19 = sub nsw i32 %18, %8
  %20 = getelementptr inbounds i16, ptr inttoptr (i32 537119284 to ptr), i32 %1
  %21 = load i16, ptr %20, align 2, !tbaa !14
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
  br label %47, !llvm.loop !34

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
!14 = !{!15, !15, i64 0}
!15 = !{!"short", !5, i64 0}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !9}
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
