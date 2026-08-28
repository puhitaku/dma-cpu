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
@NFK = internal unnamed_addr constant [10 x i8] c"\02\04\02\0C\02\02\02\02\06\04", align 1
@NFI = internal unnamed_addr constant [10 x i8] c"\02\04\02\06\02\02\02\02\06\04", align 1
@CGOFF = internal unnamed_addr constant [10 x i16] [i16 0, i16 9, i16 34, i16 43, i16 134, i16 143, i16 152, i16 161, i16 170, i16 219], align 2
@PBASE = internal unnamed_addr constant [10 x i8] c"\00\04\14\18`dhlp\94", align 1
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
  tail call void @uputs(ptr noundef nonnull @.str) #10
  tail call void @led(i32 noundef 984577, i32 noundef 984577) #10
  tail call void @gfx_clear(i16 noundef zeroext 2114) #10
  call void @llvm.lifetime.start.p0(i64 44, ptr nonnull %10) #11
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
  %31 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537130272 to ptr), i32 %30
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

99:                                               ; preds = %26, %120
  %100 = phi i32 [ %121, %120 ], [ 0, %26 ]
  %101 = icmp eq i32 %100, 10
  br i1 %101, label %145, label %102

102:                                              ; preds = %99
  %103 = getelementptr inbounds nuw [10 x i8], ptr @NFK, i32 0, i32 %100
  %104 = load i8, ptr %103, align 1, !tbaa !12
  %105 = zext i8 %104 to i32
  %106 = getelementptr inbounds nuw [10 x i8], ptr @NFI, i32 0, i32 %100
  %107 = load i8, ptr %106, align 1, !tbaa !12
  %108 = zext i8 %107 to i32
  %109 = getelementptr inbounds nuw [10 x i16], ptr @CGOFF, i32 0, i32 %100
  %110 = load i16, ptr %109, align 2, !tbaa !14
  %111 = zext i16 %110 to i32
  %112 = add nuw nsw i32 %108, 1
  %113 = add nuw nsw i32 %105, 1
  br label %114

114:                                              ; preds = %125, %102
  %115 = phi i32 [ %126, %125 ], [ 0, %102 ]
  %116 = icmp eq i32 %115, %113
  br i1 %116, label %120, label %117

117:                                              ; preds = %114
  %118 = mul nuw nsw i32 %115, %112
  %119 = add nuw nsw i32 %118, %111
  br label %122

120:                                              ; preds = %114
  %121 = add nuw nsw i32 %100, 1
  br label %99, !llvm.loop !16

122:                                              ; preds = %127, %117
  %123 = phi i32 [ %144, %127 ], [ 0, %117 ]
  %124 = icmp eq i32 %123, %112
  br i1 %124, label %125, label %127

125:                                              ; preds = %122
  %126 = add nuw nsw i32 %115, 1
  br label %114, !llvm.loop !17

127:                                              ; preds = %122
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #11
  call fastcc void @face_point(i32 noundef %100, i32 noundef %123, i32 noundef %115, ptr noundef %11, ptr noundef %12, ptr noundef %13) #12
  %128 = load i32, ptr %13, align 4, !tbaa !3
  %129 = udiv i32 819200, %128
  %130 = load i32, ptr %11, align 4, !tbaa !3
  %131 = mul nsw i32 %130, %129
  %132 = lshr i32 %131, 12
  %133 = trunc i32 %132 to i8
  %134 = add i8 %133, 120
  %135 = add nuw nsw i32 %119, %123
  %136 = shl nuw nsw i32 %135, 1
  %137 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131482 to ptr), i32 %136
  store i8 %134, ptr %137, align 2, !tbaa !12
  %138 = load i32, ptr %12, align 4, !tbaa !3
  %139 = mul nsw i32 %138, %129
  %140 = lshr i32 %139, 12
  %141 = trunc i32 %140 to i8
  %142 = add i8 %141, 120
  %143 = getelementptr inbounds nuw i8, ptr %137, i32 1
  store i8 %142, ptr %143, align 1, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #11
  %144 = add nuw nsw i32 %123, 1
  br label %122, !llvm.loop !18

145:                                              ; preds = %99
  call void @llvm.lifetime.end.p0(i64 44, ptr nonnull %10) #11
  br label %146

146:                                              ; preds = %190, %145
  %147 = phi i32 [ 0, %145 ], [ %193, %190 ]
  %148 = icmp eq i32 %147, 500
  br i1 %148, label %194, label %149

149:                                              ; preds = %146
  %150 = trunc nuw i32 %147 to i16
  %151 = freeze i16 %150
  %152 = udiv i16 %151, 100
  %153 = urem i16 %150, 10
  %154 = mul i16 %152, 100
  %155 = sub i16 %151, %154
  %156 = trunc nuw nsw i16 %155 to i8
  %157 = udiv i8 %156, 10
  %158 = zext nneg i8 %157 to i32
  %159 = mul nuw nsw i16 %153, 24
  %160 = zext nneg i16 %159 to i32
  %161 = add nsw i32 %160, -108
  %162 = mul nuw nsw i32 %158, 24
  %163 = add nuw nsw i32 %162, 212
  switch i16 %152, label %185 [
    i16 0, label %164
    i16 1, label %170
    i16 2, label %175
    i16 3, label %180
  ]

164:                                              ; preds = %149
  %165 = trunc nsw i32 %161 to i16
  %166 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %147
  store i16 %165, ptr %166, align 2, !tbaa !14
  %167 = trunc nuw nsw i32 %162 to i16
  %168 = add nsw i16 %167, -108
  %169 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %147
  store i16 %168, ptr %169, align 2, !tbaa !14
  br label %190

170:                                              ; preds = %149
  %171 = trunc nsw i32 %161 to i16
  %172 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %147
  store i16 %171, ptr %172, align 2, !tbaa !14
  %173 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %147
  store i16 120, ptr %173, align 2, !tbaa !14
  %174 = trunc nuw nsw i32 %163 to i16
  br label %190

175:                                              ; preds = %149
  %176 = trunc nsw i32 %161 to i16
  %177 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %147
  store i16 %176, ptr %177, align 2, !tbaa !14
  %178 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %147
  store i16 -120, ptr %178, align 2, !tbaa !14
  %179 = trunc nuw nsw i32 %163 to i16
  br label %190

180:                                              ; preds = %149
  %181 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %147
  store i16 -120, ptr %181, align 2, !tbaa !14
  %182 = trunc nsw i32 %161 to i16
  %183 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %147
  store i16 %182, ptr %183, align 2, !tbaa !14
  %184 = trunc nuw nsw i32 %163 to i16
  br label %190

185:                                              ; preds = %149
  %186 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %147
  store i16 120, ptr %186, align 2, !tbaa !14
  %187 = trunc nsw i32 %161 to i16
  %188 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %147
  store i16 %187, ptr %188, align 2, !tbaa !14
  %189 = trunc nuw nsw i32 %163 to i16
  br label %190

190:                                              ; preds = %185, %180, %175, %170, %164
  %191 = phi i16 [ %189, %185 ], [ %184, %180 ], [ %179, %175 ], [ %174, %170 ], [ 440, %164 ]
  %192 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119392 to ptr), i32 %147
  store i16 %191, ptr %192, align 2, !tbaa !14
  %193 = add nuw nsw i32 %147, 1
  br label %146, !llvm.loop !19

194:                                              ; preds = %146, %244
  %195 = phi i32 [ %260, %244 ], [ 0, %146 ]
  %196 = icmp eq i32 %195, 10
  br i1 %196, label %299, label %197

197:                                              ; preds = %194
  %198 = add nsw i32 %195, -5
  %199 = icmp samesign ult i32 %195, 5
  %200 = select i1 %199, i32 %195, i32 %198
  %201 = select i1 %199, i32 245, i32 243
  %202 = select i1 %199, i32 75, i32 -79
  switch i32 %200, label %210 [
    i32 0, label %211
    i32 1, label %203
    i32 2, label %206
    i32 3, label %208
  ]

203:                                              ; preds = %197
  %204 = select i1 %199, i32 -75, i32 79
  %205 = select i1 %199, i32 -245, i32 -243
  br label %211

206:                                              ; preds = %197
  %207 = select i1 %199, i32 -75, i32 79
  br label %211

208:                                              ; preds = %197
  %209 = select i1 %199, i32 -245, i32 -243
  br label %211

210:                                              ; preds = %197
  br label %211

211:                                              ; preds = %210, %208, %206, %203, %197
  %212 = phi i32 [ 0, %210 ], [ %204, %203 ], [ %201, %206 ], [ %209, %208 ], [ %202, %197 ]
  %213 = phi i32 [ -256, %210 ], [ 0, %203 ], [ 0, %206 ], [ 0, %208 ], [ %200, %197 ]
  %214 = phi i32 [ 0, %210 ], [ %205, %203 ], [ %207, %206 ], [ %202, %208 ], [ %201, %197 ]
  %215 = trunc nsw i32 %214 to i16
  %216 = mul nuw nsw i32 %195, 6
  %217 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537132298 to ptr), i32 %216
  store i16 %215, ptr %217, align 2, !tbaa !14
  %218 = trunc nsw i32 %213 to i16
  %219 = getelementptr inbounds nuw i8, ptr %217, i32 2
  store i16 %218, ptr %219, align 2, !tbaa !14
  %220 = trunc nsw i32 %212 to i16
  %221 = getelementptr inbounds nuw i8, ptr %217, i32 4
  store i16 %220, ptr %221, align 2, !tbaa !14
  %222 = getelementptr inbounds nuw [10 x i8], ptr @NFI, i32 0, i32 %195
  %223 = load i8, ptr %222, align 1, !tbaa !12
  %224 = zext i8 %223 to i32
  %225 = getelementptr inbounds nuw [10 x i8], ptr @NFK, i32 0, i32 %195
  %226 = load i8, ptr %225, align 1, !tbaa !12
  %227 = zext i8 %226 to i32
  %228 = icmp eq i32 %200, 4
  %229 = mul nuw nsw i32 %227, %224
  %230 = select i1 %199, i16 10800, i16 5184
  %231 = select i1 %228, i16 5184, i16 %230
  %232 = trunc nuw i32 %229 to i16
  %233 = udiv i16 %231, %232
  %234 = zext nneg i16 %233 to i32
  %235 = shl nuw nsw i32 %234, 8
  %236 = udiv i32 %235, 576
  %237 = trunc nuw nsw i32 %236 to i16
  %238 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537132358 to ptr), i32 %195
  store i16 %237, ptr %238, align 2, !tbaa !14
  %239 = getelementptr inbounds nuw [10 x i8], ptr @PBASE, i32 0, i32 %195
  %240 = trunc nuw i32 %195 to i8
  br label %241

241:                                              ; preds = %261, %211
  %242 = phi i32 [ 0, %211 ], [ %298, %261 ]
  %243 = icmp eq i32 %242, %229
  br i1 %243, label %244, label %261

244:                                              ; preds = %241
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #11
  %245 = lshr i8 %223, 1
  %246 = zext nneg i8 %245 to i32
  %247 = lshr i8 %226, 1
  %248 = zext nneg i8 %247 to i32
  call fastcc void @face_point(i32 noundef %195, i32 noundef %246, i32 noundef %248, ptr noundef %7, ptr noundef %8, ptr noundef %9) #12
  %249 = load i32, ptr %7, align 4, !tbaa !3
  %250 = mul nsw i32 %249, %214
  %251 = load i32, ptr %8, align 4, !tbaa !3
  %252 = mul nsw i32 %251, %213
  %253 = add nsw i32 %252, %250
  %254 = load i32, ptr %9, align 4, !tbaa !3
  %255 = mul nsw i32 %254, %212
  %256 = add nsw i32 %253, %255
  %257 = lshr i32 %256, 31
  %258 = trunc nuw nsw i32 %257 to i16
  %259 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537132378 to ptr), i32 %195
  store i16 %258, ptr %259, align 2, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #11
  %260 = add nuw nsw i32 %195, 1
  br label %194, !llvm.loop !20

261:                                              ; preds = %241
  %262 = load i8, ptr %239, align 1, !tbaa !12
  %263 = zext i8 %262 to i32
  %264 = add nuw nsw i32 %242, 500
  %265 = add nuw nsw i32 %264, %263
  %266 = freeze i32 %242
  %267 = freeze i32 %224
  %268 = udiv i32 %266, %267
  %269 = mul i32 %268, %267
  %270 = sub i32 %266, %269
  %271 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131970 to ptr), i32 %242
  %272 = getelementptr inbounds nuw i8, ptr %271, i32 %263
  store i8 %240, ptr %272, align 1, !tbaa !12
  %273 = shl i32 %268, 4
  %274 = or i32 %273, %270
  %275 = trunc i32 %274 to i8
  %276 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537132134 to ptr), i32 %242
  %277 = getelementptr inbounds nuw i8, ptr %276, i32 %263
  store i8 %275, ptr %277, align 1, !tbaa !12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #11
  call fastcc void @face_point(i32 noundef %195, i32 noundef %270, i32 noundef %268, ptr noundef %1, ptr noundef %2, ptr noundef %3) #12
  %278 = add nuw nsw i32 %270, 1
  %279 = add nuw nsw i32 %268, 1
  call fastcc void @face_point(i32 noundef %195, i32 noundef %278, i32 noundef %279, ptr noundef %4, ptr noundef %5, ptr noundef %6) #12
  %280 = load i32, ptr %1, align 4, !tbaa !3
  %281 = load i32, ptr %4, align 4, !tbaa !3
  %282 = add nsw i32 %281, %280
  %283 = sdiv i32 %282, 2
  %284 = trunc i32 %283 to i16
  %285 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %265
  store i16 %284, ptr %285, align 2, !tbaa !14
  %286 = load i32, ptr %2, align 4, !tbaa !3
  %287 = load i32, ptr %5, align 4, !tbaa !3
  %288 = add nsw i32 %287, %286
  %289 = sdiv i32 %288, 2
  %290 = trunc i32 %289 to i16
  %291 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %265
  store i16 %290, ptr %291, align 2, !tbaa !14
  %292 = load i32, ptr %3, align 4, !tbaa !3
  %293 = load i32, ptr %6, align 4, !tbaa !3
  %294 = add nsw i32 %293, %292
  %295 = sdiv i32 %294, 2
  %296 = trunc i32 %295 to i16
  %297 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119392 to ptr), i32 %265
  store i16 %296, ptr %297, align 2, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #11
  %298 = add nuw nsw i32 %242, 1
  br label %241, !llvm.loop !21

299:                                              ; preds = %194, %302
  %300 = phi i32 [ %315, %302 ], [ 0, %194 ]
  %301 = icmp eq i32 %300, 16
  br i1 %301, label %316, label %302

302:                                              ; preds = %299
  %303 = add nuw nsw i32 %300, 664
  %304 = lshr i32 %300, 2
  %305 = trunc nuw nsw i32 %300 to i16
  %306 = and i16 %305, 3
  %307 = mul nuw nsw i16 %306, 60
  %308 = add nsw i16 %307, -90
  %309 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %303
  store i16 %308, ptr %309, align 2, !tbaa !14
  %310 = trunc nuw nsw i32 %304 to i16
  %311 = mul nuw nsw i16 %310, 60
  %312 = add nsw i16 %311, -90
  %313 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %303
  store i16 %312, ptr %313, align 2, !tbaa !14
  %314 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119392 to ptr), i32 %303
  store i16 200, ptr %314, align 2, !tbaa !14
  %315 = add nuw nsw i32 %300, 1
  br label %299, !llvm.loop !22

316:                                              ; preds = %299, %328
  %317 = phi i32 [ %329, %328 ], [ 0, %299 ]
  %318 = icmp eq i32 %317, 680
  br i1 %318, label %330, label %319

319:                                              ; preds = %316
  %320 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123472 to ptr), i32 %317
  store i16 0, ptr %320, align 2, !tbaa !14
  %321 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537122112 to ptr), i32 %317
  store i16 0, ptr %321, align 2, !tbaa !14
  %322 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120752 to ptr), i32 %317
  store i16 0, ptr %322, align 2, !tbaa !14
  %323 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127552 to ptr), i32 %317
  store i16 0, ptr %323, align 2, !tbaa !14
  %324 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126192 to ptr), i32 %317
  store i16 0, ptr %324, align 2, !tbaa !14
  %325 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124832 to ptr), i32 %317
  store i16 0, ptr %325, align 2, !tbaa !14
  %326 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128912 to ptr), i32 %317
  store i16 -1, ptr %326, align 2, !tbaa !14
  switch i32 %317, label %328 [
    i32 244, label %327
    i32 245, label %327
    i32 254, label %327
    i32 255, label %327
  ]

327:                                              ; preds = %319, %319, %319, %319
  store i16 -36, ptr %325, align 2, !tbaa !14
  store i16 -36, ptr %324, align 2, !tbaa !14
  store i16 -6586, ptr %323, align 2, !tbaa !14
  br label %328

328:                                              ; preds = %327, %319
  %329 = add nuw nsw i32 %317, 1
  br label %316, !llvm.loop !23

330:                                              ; preds = %316
  tail call fastcc void @repaint(i32 noundef 1) #12
  br label %331

331:                                              ; preds = %352, %330
  %332 = phi i32 [ 0, %330 ], [ %348, %352 ]
  br label %333

333:                                              ; preds = %331, %346
  %334 = phi i1 [ false, %346 ], [ true, %331 ]
  br label %335

335:                                              ; preds = %333, %342
  %336 = phi i1 [ false, %342 ], [ %334, %333 ]
  tail call void @in_poll() #10
  %337 = load i32, ptr @in_edge, align 4, !tbaa !3
  %338 = and i32 %337, 31
  %339 = icmp eq i32 %338, 0
  br i1 %339, label %341, label %340

340:                                              ; preds = %335
  tail call void @led(i32 noundef 0, i32 noundef 0) #10
  tail call void @uputs(ptr noundef nonnull @.str.1) #10
  ret void

341:                                              ; preds = %335
  br i1 %336, label %343, label %342

342:                                              ; preds = %341
  tail call void @frame_sync(i32 noundef 33000) #10
  br label %335, !llvm.loop !24

343:                                              ; preds = %341
  %344 = tail call fastcc i32 @brightest() #12
  %345 = icmp slt i32 %344, 0
  br i1 %345, label %346, label %347

346:                                              ; preds = %343
  tail call void @uputs(ptr noundef nonnull @.str.2) #10
  tail call void @uputn(i32 noundef %332) #10
  tail call void @uputs(ptr noundef nonnull @.str.3) #10
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #10
  br label %333, !llvm.loop !24

347:                                              ; preds = %343
  tail call fastcc void @shoot(i32 noundef %344) #12
  %348 = add i32 %332, 1
  tail call fastcc void @repaint(i32 noundef 0) #12
  %349 = and i32 %348, 15
  %350 = icmp eq i32 %349, 0
  br i1 %350, label %351, label %352

351:                                              ; preds = %347
  tail call void @uputs(ptr noundef nonnull @.str.4) #10
  tail call void @uputn(i32 noundef %348) #10
  tail call void @uputs(ptr noundef nonnull @.str.5) #10
  br label %352

352:                                              ; preds = %351, %347
  br label %331
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

6:                                                ; preds = %135, %1
  %7 = phi i32 [ 0, %1 ], [ %136, %135 ]
  %8 = phi i32 [ 0, %1 ], [ %137, %135 ]
  %9 = phi i32 [ 0, %1 ], [ %139, %135 ]
  %10 = phi i32 [ 0, %1 ], [ %138, %135 ]
  %11 = phi i32 [ 0, %1 ], [ %128, %135 ]
  %12 = icmp eq i32 %9, 500
  br i1 %12, label %13, label %22

13:                                               ; preds = %6
  %14 = icmp eq i32 %11, 0
  %15 = select i1 %5, i1 %14, i1 false
  %16 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %17 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %18 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %19 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %20 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %21 = getelementptr inbounds nuw i8, ptr %4, i32 12
  br label %140

22:                                               ; preds = %6
  %23 = tail call fastcc zeroext i16 @patch_color(i32 noundef %9) #12
  br i1 %5, label %24, label %30

24:                                               ; preds = %22
  %25 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128912 to ptr), i32 %9
  %26 = load i16, ptr %25, align 2, !tbaa !14
  %27 = icmp eq i16 %23, %26
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = add nsw i32 %7, 1
  br label %126

30:                                               ; preds = %24, %22
  %31 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128912 to ptr), i32 %9
  store i16 %23, ptr %31, align 2, !tbaa !14
  %32 = mul nsw i32 %10, 242
  %33 = mul i32 %8, 11
  %34 = add nsw i32 %33, %7
  %35 = shl nsw i32 %34, 1
  %36 = getelementptr i8, ptr inttoptr (i32 537130272 to ptr), i32 %32
  %37 = getelementptr i8, ptr %36, i32 %35
  %38 = add nsw i32 %7, 1
  %39 = add nsw i32 %33, %38
  %40 = shl nsw i32 %39, 1
  %41 = getelementptr i8, ptr %36, i32 %40
  %42 = add i32 %33, 11
  %43 = add nsw i32 %42, %7
  %44 = shl nsw i32 %43, 1
  %45 = getelementptr i8, ptr %36, i32 %44
  %46 = add nsw i32 %42, %38
  %47 = shl nsw i32 %46, 1
  %48 = getelementptr i8, ptr %36, i32 %47
  switch i32 %10, label %109 [
    i32 0, label %49
    i32 1, label %62
    i32 2, label %77
    i32 3, label %92
  ]

49:                                               ; preds = %30
  %50 = load i8, ptr %37, align 2, !tbaa !12
  %51 = zext i8 %50 to i32
  %52 = getelementptr inbounds nuw i8, ptr %37, i32 1
  %53 = load i8, ptr %52, align 1, !tbaa !12
  %54 = zext i8 %53 to i32
  %55 = load i8, ptr %48, align 2, !tbaa !12
  %56 = zext i8 %55 to i32
  %57 = sub nsw i32 %56, %51
  %58 = getelementptr inbounds nuw i8, ptr %48, i32 1
  %59 = load i8, ptr %58, align 1, !tbaa !12
  %60 = zext i8 %59 to i32
  %61 = sub nsw i32 %60, %54
  tail call void @gfx_fill(i32 noundef %51, i32 noundef %54, i32 noundef %57, i32 noundef %61, i16 noundef zeroext %23) #10
  br label %126

62:                                               ; preds = %30
  %63 = getelementptr inbounds nuw i8, ptr %45, i32 1
  %64 = load i8, ptr %63, align 1, !tbaa !12
  %65 = zext i8 %64 to i32
  %66 = getelementptr inbounds nuw i8, ptr %37, i32 1
  %67 = load i8, ptr %66, align 1, !tbaa !12
  %68 = zext i8 %67 to i32
  %69 = load i8, ptr %45, align 2, !tbaa !12
  %70 = zext i8 %69 to i32
  %71 = load i8, ptr %37, align 2, !tbaa !12
  %72 = zext i8 %71 to i32
  %73 = load i8, ptr %48, align 2, !tbaa !12
  %74 = zext i8 %73 to i32
  %75 = load i8, ptr %41, align 2, !tbaa !12
  %76 = zext i8 %75 to i32
  tail call fastcc void @fill_htrap(i32 noundef %65, i32 noundef %68, i32 noundef %70, i32 noundef %72, i32 noundef %74, i32 noundef %76, i16 noundef zeroext %23) #12
  br label %126

77:                                               ; preds = %30
  %78 = getelementptr inbounds nuw i8, ptr %37, i32 1
  %79 = load i8, ptr %78, align 1, !tbaa !12
  %80 = zext i8 %79 to i32
  %81 = getelementptr inbounds nuw i8, ptr %45, i32 1
  %82 = load i8, ptr %81, align 1, !tbaa !12
  %83 = zext i8 %82 to i32
  %84 = load i8, ptr %37, align 2, !tbaa !12
  %85 = zext i8 %84 to i32
  %86 = load i8, ptr %45, align 2, !tbaa !12
  %87 = zext i8 %86 to i32
  %88 = load i8, ptr %41, align 2, !tbaa !12
  %89 = zext i8 %88 to i32
  %90 = load i8, ptr %48, align 2, !tbaa !12
  %91 = zext i8 %90 to i32
  tail call fastcc void @fill_htrap(i32 noundef %80, i32 noundef %83, i32 noundef %85, i32 noundef %87, i32 noundef %89, i32 noundef %91, i16 noundef zeroext %23) #12
  br label %126

92:                                               ; preds = %30
  %93 = load i8, ptr %37, align 2, !tbaa !12
  %94 = zext i8 %93 to i32
  %95 = load i8, ptr %45, align 2, !tbaa !12
  %96 = zext i8 %95 to i32
  %97 = getelementptr inbounds nuw i8, ptr %37, i32 1
  %98 = load i8, ptr %97, align 1, !tbaa !12
  %99 = zext i8 %98 to i32
  %100 = getelementptr inbounds nuw i8, ptr %45, i32 1
  %101 = load i8, ptr %100, align 1, !tbaa !12
  %102 = zext i8 %101 to i32
  %103 = getelementptr inbounds nuw i8, ptr %41, i32 1
  %104 = load i8, ptr %103, align 1, !tbaa !12
  %105 = zext i8 %104 to i32
  %106 = getelementptr inbounds nuw i8, ptr %48, i32 1
  %107 = load i8, ptr %106, align 1, !tbaa !12
  %108 = zext i8 %107 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %94, i32 noundef %96, i32 noundef %99, i32 noundef %102, i32 noundef %105, i32 noundef %108, i16 noundef zeroext %23) #12
  br label %126

109:                                              ; preds = %30
  %110 = load i8, ptr %45, align 2, !tbaa !12
  %111 = zext i8 %110 to i32
  %112 = load i8, ptr %37, align 2, !tbaa !12
  %113 = zext i8 %112 to i32
  %114 = getelementptr inbounds nuw i8, ptr %45, i32 1
  %115 = load i8, ptr %114, align 1, !tbaa !12
  %116 = zext i8 %115 to i32
  %117 = getelementptr inbounds nuw i8, ptr %37, i32 1
  %118 = load i8, ptr %117, align 1, !tbaa !12
  %119 = zext i8 %118 to i32
  %120 = getelementptr inbounds nuw i8, ptr %48, i32 1
  %121 = load i8, ptr %120, align 1, !tbaa !12
  %122 = zext i8 %121 to i32
  %123 = getelementptr inbounds nuw i8, ptr %41, i32 1
  %124 = load i8, ptr %123, align 1, !tbaa !12
  %125 = zext i8 %124 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %111, i32 noundef %113, i32 noundef %116, i32 noundef %119, i32 noundef %122, i32 noundef %125, i16 noundef zeroext %23) #12
  br label %126

126:                                              ; preds = %28, %109, %92, %77, %62, %49
  %127 = phi i32 [ %29, %28 ], [ %38, %109 ], [ %38, %92 ], [ %38, %77 ], [ %38, %62 ], [ %38, %49 ]
  %128 = phi i32 [ %11, %28 ], [ 1, %109 ], [ 1, %92 ], [ 1, %77 ], [ 1, %62 ], [ 1, %49 ]
  %129 = icmp eq i32 %127, 10
  br i1 %129, label %130, label %135

130:                                              ; preds = %126
  %131 = add nsw i32 %8, 1
  %132 = icmp eq i32 %131, 10
  br i1 %132, label %133, label %135

133:                                              ; preds = %130
  %134 = add nsw i32 %10, 1
  br label %135

135:                                              ; preds = %130, %133, %126
  %136 = phi i32 [ 0, %133 ], [ 0, %130 ], [ %127, %126 ]
  %137 = phi i32 [ 0, %133 ], [ %131, %130 ], [ %8, %126 ]
  %138 = phi i32 [ %134, %133 ], [ %10, %130 ], [ %10, %126 ]
  %139 = add nuw nsw i32 %9, 1
  br label %6, !llvm.loop !25

140:                                              ; preds = %13, %290
  %141 = phi i32 [ %291, %290 ], [ 500, %13 ]
  %142 = icmp eq i32 %141, 664
  br i1 %142, label %143, label %144

143:                                              ; preds = %140
  tail call void @gfx_present() #10
  ret void

144:                                              ; preds = %140
  %145 = tail call fastcc zeroext i16 @patch_color(i32 noundef %141) #12
  br i1 %15, label %146, label %150

146:                                              ; preds = %144
  %147 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128912 to ptr), i32 %141
  %148 = load i16, ptr %147, align 2, !tbaa !14
  %149 = icmp eq i16 %145, %148
  br i1 %149, label %290, label %150

150:                                              ; preds = %146, %144
  %151 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128912 to ptr), i32 %141
  store i16 %145, ptr %151, align 2, !tbaa !14
  %152 = add nsw i32 %141, -500
  %153 = getelementptr inbounds i8, ptr inttoptr (i32 537131970 to ptr), i32 %152
  %154 = load i8, ptr %153, align 1, !tbaa !12
  %155 = zext i8 %154 to i32
  %156 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537132378 to ptr), i32 %155
  %157 = load i16, ptr %156, align 2, !tbaa !14
  %158 = icmp eq i16 %157, 0
  br i1 %158, label %290, label %159

159:                                              ; preds = %150
  %160 = getelementptr inbounds i8, ptr inttoptr (i32 537132134 to ptr), i32 %152
  %161 = load i8, ptr %160, align 1, !tbaa !12
  %162 = zext i8 %161 to i32
  %163 = and i32 %162, 15
  %164 = lshr i32 %162, 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #11
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #11
  %165 = getelementptr inbounds nuw [10 x i16], ptr @CGOFF, i32 0, i32 %155
  %166 = load i16, ptr %165, align 2, !tbaa !14
  %167 = zext i16 %166 to i32
  %168 = getelementptr inbounds nuw [10 x i8], ptr @NFI, i32 0, i32 %155
  %169 = load i8, ptr %168, align 1, !tbaa !12
  %170 = zext i8 %169 to i32
  %171 = add nuw nsw i32 %170, 1
  %172 = mul nuw nsw i32 %171, %164
  %173 = add nuw nsw i32 %172, %167
  %174 = add nuw nsw i32 %173, %163
  %175 = shl nuw nsw i32 %174, 1
  %176 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131482 to ptr), i32 %175
  %177 = add nuw nsw i32 %163, 1
  %178 = add nuw nsw i32 %173, %177
  %179 = shl nuw nsw i32 %178, 1
  %180 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131482 to ptr), i32 %179
  %181 = add nuw nsw i32 %164, 1
  %182 = mul nuw nsw i32 %171, %181
  %183 = add nuw nsw i32 %182, %167
  %184 = add nuw nsw i32 %183, %177
  %185 = shl nuw nsw i32 %184, 1
  %186 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131482 to ptr), i32 %185
  %187 = add nuw nsw i32 %183, %163
  %188 = shl nuw nsw i32 %187, 1
  %189 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131482 to ptr), i32 %188
  %190 = load i8, ptr %176, align 2, !tbaa !12
  %191 = zext i8 %190 to i32
  store i32 %191, ptr %3, align 4, !tbaa !3
  %192 = getelementptr inbounds nuw i8, ptr %176, i32 1
  %193 = load i8, ptr %192, align 1, !tbaa !12
  %194 = zext i8 %193 to i32
  store i32 %194, ptr %4, align 4, !tbaa !3
  %195 = load i8, ptr %180, align 2, !tbaa !12
  %196 = zext i8 %195 to i32
  store i32 %196, ptr %16, align 4, !tbaa !3
  %197 = getelementptr inbounds nuw i8, ptr %180, i32 1
  %198 = load i8, ptr %197, align 1, !tbaa !12
  %199 = zext i8 %198 to i32
  store i32 %199, ptr %17, align 4, !tbaa !3
  %200 = load i8, ptr %186, align 2, !tbaa !12
  %201 = zext i8 %200 to i32
  store i32 %201, ptr %18, align 4, !tbaa !3
  %202 = getelementptr inbounds nuw i8, ptr %186, i32 1
  %203 = load i8, ptr %202, align 1, !tbaa !12
  %204 = zext i8 %203 to i32
  store i32 %204, ptr %19, align 4, !tbaa !3
  %205 = load i8, ptr %189, align 2, !tbaa !12
  %206 = zext i8 %205 to i32
  store i32 %206, ptr %20, align 4, !tbaa !3
  %207 = getelementptr inbounds nuw i8, ptr %189, i32 1
  %208 = load i8, ptr %207, align 1, !tbaa !12
  %209 = zext i8 %208 to i32
  store i32 %209, ptr %21, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #11
  br label %210

210:                                              ; preds = %234, %159
  %211 = phi i32 [ 0, %159 ], [ %220, %234 ]
  %212 = phi i32 [ %191, %159 ], [ %219, %234 ]
  %213 = phi i32 [ %191, %159 ], [ %218, %234 ]
  %214 = icmp eq i32 %211, 4
  br i1 %214, label %237, label %215

215:                                              ; preds = %210
  %216 = getelementptr inbounds nuw i32, ptr %3, i32 %211
  %217 = load i32, ptr %216, align 4, !tbaa !3
  %218 = tail call i32 @llvm.smin.i32(i32 %217, i32 %213)
  %219 = tail call i32 @llvm.smax.i32(i32 %217, i32 %212)
  %220 = add nuw nsw i32 %211, 1
  %221 = and i32 %220, 3
  %222 = getelementptr inbounds nuw i32, ptr %3, i32 %221
  %223 = load i32, ptr %222, align 4, !tbaa !3
  %224 = icmp eq i32 %223, %217
  br i1 %224, label %234, label %225

225:                                              ; preds = %215
  %226 = sub nsw i32 %223, %217
  %227 = getelementptr inbounds nuw i32, ptr %4, i32 %221
  %228 = load i32, ptr %227, align 4, !tbaa !3
  %229 = getelementptr inbounds nuw i32, ptr %4, i32 %211
  %230 = load i32, ptr %229, align 4, !tbaa !3
  %231 = sub nsw i32 %228, %230
  %232 = shl i32 %231, 12
  %233 = sdiv i32 %232, %226
  br label %234

234:                                              ; preds = %225, %215
  %235 = phi i32 [ %233, %225 ], [ 0, %215 ]
  %236 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %211
  store i32 %235, ptr %236, align 4, !tbaa !3
  br label %210, !llvm.loop !26

237:                                              ; preds = %210, %287
  %238 = phi i32 [ %288, %287 ], [ %213, %210 ]
  %239 = icmp sgt i32 %238, %212
  br i1 %239, label %289, label %240

240:                                              ; preds = %237, %273
  %241 = phi i32 [ %274, %273 ], [ 32767, %237 ]
  %242 = phi i32 [ %275, %273 ], [ -32768, %237 ]
  %243 = phi i32 [ %252, %273 ], [ 0, %237 ]
  br label %244

244:                                              ; preds = %261, %240
  %245 = phi i32 [ %243, %240 ], [ %252, %261 ]
  %246 = icmp eq i32 %245, 4
  br i1 %246, label %247, label %249

247:                                              ; preds = %244
  %248 = icmp sgt i32 %242, %241
  br i1 %248, label %285, label %287

249:                                              ; preds = %244
  %250 = getelementptr inbounds nuw i32, ptr %3, i32 %245
  %251 = load i32, ptr %250, align 4, !tbaa !3
  %252 = add nuw nsw i32 %245, 1
  %253 = and i32 %252, 3
  %254 = getelementptr inbounds nuw i32, ptr %3, i32 %253
  %255 = load i32, ptr %254, align 4, !tbaa !3
  %256 = tail call i32 @llvm.smin.i32(i32 %251, i32 %255)
  %257 = icmp slt i32 %238, %256
  br i1 %257, label %261, label %258

258:                                              ; preds = %249
  %259 = tail call i32 @llvm.smax.i32(i32 %251, i32 %255)
  %260 = icmp sgt i32 %238, %259
  br i1 %260, label %261, label %262

261:                                              ; preds = %258, %249
  br label %244, !llvm.loop !27

262:                                              ; preds = %258
  %263 = icmp eq i32 %251, %255
  %264 = getelementptr inbounds nuw i32, ptr %4, i32 %245
  %265 = load i32, ptr %264, align 4, !tbaa !3
  br i1 %263, label %266, label %276

266:                                              ; preds = %262
  %267 = getelementptr inbounds nuw i32, ptr %4, i32 %253
  %268 = load i32, ptr %267, align 4, !tbaa !3
  %269 = tail call i32 @llvm.smin.i32(i32 %268, i32 %265)
  %270 = tail call i32 @llvm.smax.i32(i32 %268, i32 %265)
  %271 = tail call i32 @llvm.smin.i32(i32 %269, i32 %241)
  %272 = tail call i32 @llvm.smax.i32(i32 %270, i32 %242)
  br label %273

273:                                              ; preds = %266, %276
  %274 = phi i32 [ %283, %276 ], [ %271, %266 ]
  %275 = phi i32 [ %284, %276 ], [ %272, %266 ]
  br label %240, !llvm.loop !27

276:                                              ; preds = %262
  %277 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %245
  %278 = load i32, ptr %277, align 4, !tbaa !3
  %279 = sub nsw i32 %238, %251
  %280 = mul nsw i32 %278, %279
  %281 = ashr i32 %280, 12
  %282 = add nsw i32 %281, %265
  %283 = tail call i32 @llvm.smin.i32(i32 %282, i32 %241)
  %284 = tail call i32 @llvm.smax.i32(i32 %282, i32 %242)
  br label %273

285:                                              ; preds = %247
  %286 = sub nsw i32 %242, %241
  tail call void @gfx_fill(i32 noundef %238, i32 noundef %241, i32 noundef 1, i32 noundef %286, i16 noundef zeroext %145) #10
  br label %287

287:                                              ; preds = %285, %247
  %288 = add nsw i32 %238, 1
  br label %237, !llvm.loop !28

289:                                              ; preds = %237
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #11
  br label %290

290:                                              ; preds = %289, %150, %146
  %291 = add nuw nsw i32 %141, 1
  br label %140, !llvm.loop !29
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
  %5 = icmp eq i32 %3, 680
  br i1 %5, label %6, label %9

6:                                                ; preds = %1
  %7 = icmp samesign ugt i32 %4, 95
  %8 = select i1 %7, i32 %2, i32 -1
  ret i32 %8

9:                                                ; preds = %1
  %10 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124832 to ptr), i32 %3
  %11 = load i16, ptr %10, align 2, !tbaa !14
  %12 = zext i16 %11 to i32
  %13 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126192 to ptr), i32 %3
  %14 = load i16, ptr %13, align 2, !tbaa !14
  %15 = zext i16 %14 to i32
  %16 = add nuw nsw i32 %15, %12
  %17 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127552 to ptr), i32 %3
  %18 = load i16, ptr %17, align 2, !tbaa !14
  %19 = zext i16 %18 to i32
  %20 = add nuw nsw i32 %16, %19
  %21 = icmp samesign ult i32 %3, 500
  br i1 %21, label %31, label %22

22:                                               ; preds = %9
  %23 = icmp samesign ugt i32 %3, 663
  br i1 %23, label %31, label %24

24:                                               ; preds = %22
  %25 = getelementptr i8, ptr inttoptr (i32 537131470 to ptr), i32 %3
  %26 = load i8, ptr %25, align 1, !tbaa !12
  %27 = zext i8 %26 to i32
  %28 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537132358 to ptr), i32 %27
  %29 = load i16, ptr %28, align 2, !tbaa !14
  %30 = sext i16 %29 to i32
  br label %31

31:                                               ; preds = %9, %22, %24
  %32 = phi i32 [ %30, %24 ], [ 256, %9 ], [ 1600, %22 ]
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
  %10 = icmp samesign ugt i32 %0, 663
  br i1 %10, label %19, label %11

11:                                               ; preds = %9
  %12 = getelementptr i8, ptr inttoptr (i32 537131970 to ptr), i32 %0
  %13 = getelementptr i8, ptr %12, i32 -500
  %14 = load i8, ptr %13, align 1, !tbaa !12
  %15 = zext i8 %14 to i32
  %16 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537132358 to ptr), i32 %15
  %17 = load i16, ptr %16, align 2, !tbaa !14
  %18 = sext i16 %17 to i32
  br label %19

19:                                               ; preds = %1, %9, %11
  %20 = phi i32 [ %18, %11 ], [ 256, %1 ], [ 1600, %9 ]
  %21 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124832 to ptr), i32 %0
  %22 = load i16, ptr %21, align 2, !tbaa !14
  %23 = zext i16 %22 to i32
  %24 = mul nsw i32 %20, %23
  %25 = lshr i32 %24, 8
  %26 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126192 to ptr), i32 %0
  %27 = load i16, ptr %26, align 2, !tbaa !14
  %28 = zext i16 %27 to i32
  %29 = mul nsw i32 %20, %28
  %30 = lshr i32 %29, 8
  %31 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127552 to ptr), i32 %0
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
  %39 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %0
  %40 = load i16, ptr %39, align 2, !tbaa !14
  %41 = sext i16 %40 to i32
  %42 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119392 to ptr), i32 %0
  %43 = load i16, ptr %42, align 2, !tbaa !14
  %44 = sext i16 %43 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #11
  call fastcc void @normal_of(i32 noundef %0, ptr noundef %2, ptr noundef %3, ptr noundef %4) #12
  %45 = load i32, ptr %2, align 4
  %46 = load i32, ptr %3, align 4
  %47 = load i32, ptr %4, align 4
  br label %48

48:                                               ; preds = %178, %19
  %49 = phi i32 [ 0, %19 ], [ %179, %178 ]
  %50 = icmp eq i32 %49, 680
  br i1 %50, label %51, label %52

51:                                               ; preds = %48
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #11
  ret void

52:                                               ; preds = %48
  %53 = icmp eq i32 %49, %0
  br i1 %53, label %178, label %54

54:                                               ; preds = %52
  %55 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %49
  %56 = load i16, ptr %55, align 2, !tbaa !14
  %57 = sext i16 %56 to i32
  %58 = sub nsw i32 %57, %38
  %59 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %49
  %60 = load i16, ptr %59, align 2, !tbaa !14
  %61 = sext i16 %60 to i32
  %62 = sub nsw i32 %61, %41
  %63 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119392 to ptr), i32 %49
  %64 = load i16, ptr %63, align 2, !tbaa !14
  %65 = sext i16 %64 to i32
  %66 = sub nsw i32 %65, %44
  %67 = mul nsw i32 %45, %58
  %68 = mul nsw i32 %46, %62
  %69 = mul nsw i32 %47, %66
  %70 = add i32 %67, 134217728
  %71 = add i32 %70, %68
  %72 = add i32 %71, %69
  %73 = icmp ult i32 %72, 134217984
  br i1 %73, label %178, label %74

74:                                               ; preds = %54
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #11
  call fastcc void @normal_of(i32 noundef %49, ptr noundef %5, ptr noundef %6, ptr noundef %7) #12
  %75 = load i32, ptr %5, align 4, !tbaa !3
  %76 = mul nsw i32 %75, %58
  %77 = load i32, ptr %6, align 4, !tbaa !3
  %78 = mul nsw i32 %77, %62
  %79 = add nsw i32 %78, %76
  %80 = load i32, ptr %7, align 4, !tbaa !3
  %81 = mul nsw i32 %80, %66
  %82 = add nsw i32 %79, %81
  %83 = add nsw i32 %82, 134217728
  %84 = lshr i32 %83, 8
  %85 = add nuw nsw i32 %84, 3670016
  %86 = icmp ult i32 %82, -134217728
  br i1 %86, label %177, label %87

87:                                               ; preds = %74
  %88 = mul nsw i32 %58, %58
  %89 = mul nsw i32 %62, %62
  %90 = add nuw i32 %89, %88
  %91 = mul nsw i32 %66, %66
  %92 = add i32 %90, %91
  %93 = icmp ult i32 %92, 64
  br i1 %93, label %177, label %94

94:                                               ; preds = %87
  %95 = tail call fastcc i32 @clearance(i32 noundef %0, i32 noundef %49) #12
  %96 = icmp eq i32 %95, 0
  br i1 %96, label %177, label %97

97:                                               ; preds = %94
  %98 = shl i32 %72, 2
  %99 = and i32 %98, -1024
  %100 = sub i32 536870912, %99
  %101 = mul i32 %100, %85
  %102 = udiv i32 %101, %92
  %103 = udiv i32 589824, %92
  %104 = tail call i32 @llvm.umin.i32(i32 %103, i32 4096)
  %105 = mul nuw i32 %102, 41
  %106 = mul i32 %105, %104
  %107 = lshr i32 %106, 15
  %108 = mul nuw nsw i32 %95, 51
  %109 = mul nuw nsw i32 %108, %107
  %110 = icmp samesign ult i32 %109, 256
  br i1 %110, label %177, label %111

111:                                              ; preds = %97
  %112 = lshr i32 %109, 8
  %113 = icmp samesign ugt i32 %49, 663
  %114 = icmp samesign ult i32 %49, 500
  %115 = trunc nuw i32 %49 to i16
  %116 = udiv i16 %115, 100
  %117 = zext nneg i16 %116 to i32
  %118 = select i1 %114, i32 %117, i32 5
  %119 = select i1 %113, i32 0, i32 %118
  %120 = getelementptr inbounds nuw [6 x [3 x i16]], ptr @rho, i32 0, i32 %119
  %121 = mul i32 %112, %25
  %122 = lshr i32 %121, 12
  %123 = load i16, ptr %120, align 2, !tbaa !14
  %124 = zext i16 %123 to i32
  %125 = mul i32 %122, %124
  %126 = lshr i32 %125, 8
  %127 = mul i32 %112, %30
  %128 = lshr i32 %127, 12
  %129 = getelementptr inbounds nuw i8, ptr %120, i32 2
  %130 = load i16, ptr %129, align 2, !tbaa !14
  %131 = zext i16 %130 to i32
  %132 = mul i32 %128, %131
  %133 = lshr i32 %132, 8
  %134 = mul i32 %112, %35
  %135 = lshr i32 %134, 12
  %136 = getelementptr inbounds nuw i8, ptr %120, i32 4
  %137 = load i16, ptr %136, align 2, !tbaa !14
  %138 = zext i16 %137 to i32
  %139 = mul i32 %135, %138
  %140 = lshr i32 %139, 8
  %141 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120752 to ptr), i32 %49
  %142 = load i16, ptr %141, align 2, !tbaa !14
  %143 = zext i16 %142 to i32
  %144 = add nuw nsw i32 %126, %143
  %145 = tail call i32 @llvm.umin.i32(i32 %144, i32 65535)
  %146 = trunc nuw i32 %145 to i16
  store i16 %146, ptr %141, align 2, !tbaa !14
  %147 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537122112 to ptr), i32 %49
  %148 = load i16, ptr %147, align 2, !tbaa !14
  %149 = zext i16 %148 to i32
  %150 = add nuw nsw i32 %133, %149
  %151 = tail call i32 @llvm.umin.i32(i32 %150, i32 65535)
  %152 = trunc nuw i32 %151 to i16
  store i16 %152, ptr %147, align 2, !tbaa !14
  %153 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123472 to ptr), i32 %49
  %154 = load i16, ptr %153, align 2, !tbaa !14
  %155 = zext i16 %154 to i32
  %156 = add nuw nsw i32 %140, %155
  %157 = tail call i32 @llvm.umin.i32(i32 %156, i32 65535)
  %158 = trunc nuw i32 %157 to i16
  store i16 %158, ptr %153, align 2, !tbaa !14
  %159 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124832 to ptr), i32 %49
  %160 = load i16, ptr %159, align 2, !tbaa !14
  %161 = zext i16 %160 to i32
  %162 = add nuw nsw i32 %126, %161
  %163 = tail call i32 @llvm.umin.i32(i32 %162, i32 65535)
  %164 = trunc nuw i32 %163 to i16
  store i16 %164, ptr %159, align 2, !tbaa !14
  %165 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537126192 to ptr), i32 %49
  %166 = load i16, ptr %165, align 2, !tbaa !14
  %167 = zext i16 %166 to i32
  %168 = add nuw nsw i32 %133, %167
  %169 = tail call i32 @llvm.umin.i32(i32 %168, i32 65535)
  %170 = trunc nuw i32 %169 to i16
  store i16 %170, ptr %165, align 2, !tbaa !14
  %171 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127552 to ptr), i32 %49
  %172 = load i16, ptr %171, align 2, !tbaa !14
  %173 = zext i16 %172 to i32
  %174 = add nuw nsw i32 %140, %173
  %175 = tail call i32 @llvm.umin.i32(i32 %174, i32 65535)
  %176 = trunc nuw i32 %175 to i16
  store i16 %176, ptr %171, align 2, !tbaa !14
  br label %177

177:                                              ; preds = %87, %111, %97, %94, %74
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #11
  br label %178

178:                                              ; preds = %177, %54, %52
  %179 = add nuw nsw i32 %49, 1
  br label %48, !llvm.loop !31
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write)
define internal fastcc void @face_point(i32 noundef range(i32 -2147483648, 10) %0, i32 noundef range(i32 -2147483648, 256) %1, i32 noundef range(i32 -2147483648, 65026) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %4, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %5) unnamed_addr #5 {
  %7 = srem i32 %0, 5
  %8 = mul nsw i32 %1, 72
  %9 = getelementptr inbounds [10 x i8], ptr @NFI, i32 0, i32 %0
  %10 = load i8, ptr %9, align 1, !tbaa !12
  %11 = zext i8 %10 to i32
  %12 = sdiv i32 %8, %11
  %13 = add nsw i32 %12, -36
  %14 = getelementptr inbounds [10 x i8], ptr @NFK, i32 0, i32 %0
  %15 = load i8, ptr %14, align 1, !tbaa !12
  %16 = zext i8 %15 to i32
  switch i32 %7, label %20 [
    i32 0, label %24
    i32 1, label %17
    i32 2, label %18
    i32 3, label %19
  ]

17:                                               ; preds = %6
  br label %24

18:                                               ; preds = %6
  br label %24

19:                                               ; preds = %6
  br label %24

20:                                               ; preds = %6
  %21 = mul nsw i32 %2, 72
  %22 = sdiv i32 %21, %16
  %23 = add nsw i32 %22, -36
  br label %24

24:                                               ; preds = %6, %20, %19, %18, %17
  %25 = phi i32 [ %13, %20 ], [ -36, %17 ], [ %13, %18 ], [ %13, %19 ], [ 36, %6 ]
  %26 = phi i32 [ %23, %20 ], [ %13, %17 ], [ 36, %18 ], [ -36, %19 ], [ %13, %6 ]
  %27 = add nsw i32 %0, 4
  %28 = icmp ult i32 %27, 9
  %29 = select i1 %28, i32 -30, i32 48
  %30 = sub nsw i32 120, %29
  %31 = mul nsw i32 %30, %2
  %32 = sdiv i32 %31, %16
  %33 = select i1 %28, i32 245, i32 243
  %34 = select i1 %28, i32 -75, i32 79
  %35 = select i1 %28, i32 -42, i32 45
  %36 = select i1 %28, i32 75, i32 -79
  %37 = select i1 %28, i32 330, i32 268
  %38 = mul nsw i32 %25, %33
  %39 = mul i32 %26, %34
  %40 = add i32 %39, %38
  %41 = ashr i32 %40, 8
  %42 = add nsw i32 %41, %35
  %43 = mul nsw i32 %25, %36
  %44 = mul nsw i32 %26, %33
  %45 = add nsw i32 %44, %43
  %46 = ashr i32 %45, 8
  %47 = add nsw i32 %46, %37
  store i32 %42, ptr %3, align 4, !tbaa !3
  store i32 %47, ptr %5, align 4, !tbaa !3
  %48 = icmp eq i32 %7, 4
  %49 = select i1 %48, i32 0, i32 %32
  %50 = add nsw i32 %49, %29
  store i32 %50, ptr %4, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc zeroext i16 @patch_color(i32 noundef range(i32 -2147483648, 664) %0) unnamed_addr #6 {
  switch i32 %0, label %2 [
    i32 244, label %22
    i32 245, label %22
    i32 254, label %22
    i32 255, label %22
  ]

2:                                                ; preds = %1
  %3 = getelementptr inbounds i16, ptr inttoptr (i32 537120752 to ptr), i32 %0
  %4 = load i16, ptr %3, align 2, !tbaa !14
  %5 = lshr i16 %4, 3
  %6 = tail call i16 @llvm.umin.i16(i16 %5, i16 255)
  %7 = shl nuw i16 %6, 8
  %8 = and i16 %7, -2048
  %9 = getelementptr inbounds i16, ptr inttoptr (i32 537122112 to ptr), i32 %0
  %10 = load i16, ptr %9, align 2, !tbaa !14
  %11 = lshr i16 %10, 3
  %12 = tail call i16 @llvm.umin.i16(i16 %11, i16 255)
  %13 = shl nuw nsw i16 %12, 3
  %14 = and i16 %13, 2016
  %15 = or disjoint i16 %14, %8
  %16 = getelementptr inbounds i16, ptr inttoptr (i32 537123472 to ptr), i32 %0
  %17 = load i16, ptr %16, align 2, !tbaa !14
  %18 = lshr i16 %17, 3
  %19 = tail call i16 @llvm.umin.i16(i16 %18, i16 255)
  %20 = lshr i16 %19, 3
  %21 = or disjoint i16 %15, %20
  br label %22

22:                                               ; preds = %1, %1, %1, %1, %2
  %23 = phi i16 [ %21, %2 ], [ -2, %1 ], [ -2, %1 ], [ -2, %1 ], [ -2, %1 ]
  ret i16 %23
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
  tail call void @gfx_fill(i32 noundef %25, i32 noundef %21, i32 noundef %29, i32 noundef 1, i16 noundef zeroext %6) #10
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
  tail call void @gfx_fill(i32 noundef %21, i32 noundef %25, i32 noundef 1, i32 noundef %29, i16 noundef zeroext %6) #10
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
define internal fastcc void @normal_of(i32 noundef %0, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #7 {
  %5 = icmp sgt i32 %0, 663
  br i1 %5, label %6, label %7

6:                                                ; preds = %4
  store i32 0, ptr %1, align 4, !tbaa !3
  store i32 0, ptr %2, align 4, !tbaa !3
  br label %31

7:                                                ; preds = %4
  %8 = icmp sgt i32 %0, 499
  br i1 %8, label %9, label %24

9:                                                ; preds = %7
  %10 = getelementptr i8, ptr inttoptr (i32 537131970 to ptr), i32 %0
  %11 = getelementptr i8, ptr %10, i32 -500
  %12 = load i8, ptr %11, align 1, !tbaa !12
  %13 = zext i8 %12 to i32
  %14 = mul nuw nsw i32 %13, 6
  %15 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537132298 to ptr), i32 %14
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
define internal fastcc range(i32 0, 6) i32 @clearance(i32 noundef range(i32 0, -2147483648) %0, i32 noundef range(i32 -2147483648, 680) %1) unnamed_addr #3 {
  %3 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %0
  %4 = load i16, ptr %3, align 2, !tbaa !14
  %5 = sext i16 %4 to i32
  %6 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537118032 to ptr), i32 %0
  %7 = load i16, ptr %6, align 2, !tbaa !14
  %8 = sext i16 %7 to i32
  %9 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119392 to ptr), i32 %0
  %10 = load i16, ptr %9, align 2, !tbaa !14
  %11 = sext i16 %10 to i32
  %12 = getelementptr inbounds i16, ptr inttoptr (i32 537116672 to ptr), i32 %1
  %13 = load i16, ptr %12, align 2, !tbaa !14
  %14 = sext i16 %13 to i32
  %15 = sub nsw i32 %14, %5
  %16 = getelementptr inbounds i16, ptr inttoptr (i32 537118032 to ptr), i32 %1
  %17 = load i16, ptr %16, align 2, !tbaa !14
  %18 = sext i16 %17 to i32
  %19 = sub nsw i32 %18, %8
  %20 = getelementptr inbounds i16, ptr inttoptr (i32 537119392 to ptr), i32 %1
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
  br i1 %46, label %47, label %86

47:                                               ; preds = %2
  %48 = add nsw i32 %5, -524288
  %49 = add nsw i32 %8, -524288
  %50 = add nsw i32 %11, -524288
  br label %51

51:                                               ; preds = %47, %83
  %52 = phi i32 [ %84, %83 ], [ 0, %47 ]
  %53 = phi i32 [ %85, %83 ], [ 1, %47 ]
  %54 = icmp eq i32 %53, 6
  br i1 %54, label %55, label %60

55:                                               ; preds = %51
  %56 = icmp sgt i32 %52, 1
  %57 = icmp eq i32 %52, 1
  %58 = select i1 %57, i32 2, i32 5
  %59 = select i1 %56, i32 0, i32 %58
  br label %86

60:                                               ; preds = %51
  %61 = mul nuw nsw i32 %53, 43
  %62 = mul nsw i32 %61, %15
  %63 = add nsw i32 %62, 134217728
  %64 = lshr i32 %63, 8
  %65 = add nsw i32 %48, %64
  %66 = mul nsw i32 %61, %19
  %67 = add nsw i32 %66, 134217728
  %68 = lshr i32 %67, 8
  %69 = add nsw i32 %49, %68
  %70 = mul nsw i32 %61, %23
  %71 = add nsw i32 %70, 134217728
  %72 = lshr i32 %71, 8
  %73 = add nsw i32 %50, %72
  br i1 %38, label %74, label %77

74:                                               ; preds = %60
  %75 = tail call fastcc i32 @in_box(i32 noundef 0, i32 noundef %65, i32 noundef %69, i32 noundef %73) #12
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %77, label %81

77:                                               ; preds = %74, %60
  br i1 %45, label %78, label %83

78:                                               ; preds = %77
  %79 = tail call fastcc i32 @in_box(i32 noundef 1, i32 noundef %65, i32 noundef %69, i32 noundef %73) #12
  %80 = icmp eq i32 %79, 0
  br i1 %80, label %83, label %81

81:                                               ; preds = %78, %74
  %82 = add nsw i32 %52, 1
  br label %83

83:                                               ; preds = %81, %78, %77
  %84 = phi i32 [ %82, %81 ], [ %52, %78 ], [ %52, %77 ]
  %85 = add nuw nsw i32 %53, 1
  br label %51, !llvm.loop !34

86:                                               ; preds = %2, %55
  %87 = phi i32 [ %59, %55 ], [ 5, %2 ]
  ret i32 %87
}

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @in_box(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 -557056, 16285695) %1, i32 noundef range(i32 -557056, 16285695) %2, i32 noundef range(i32 -557056, 16285695) %3) unnamed_addr #8 {
  %5 = icmp eq i32 %0, 0
  %6 = select i1 %5, i32 -30, i32 48
  %7 = icmp sgt i32 %2, %6
  br i1 %7, label %8, label %28

8:                                                ; preds = %4
  %9 = select i1 %5, i32 42, i32 -45
  %10 = select i1 %5, i32 -75, i32 79
  %11 = select i1 %5, i32 75, i32 -79
  %12 = select i1 %5, i32 245, i32 243
  %13 = select i1 %5, i32 -330, i32 -268
  %14 = add nsw i32 %9, %1
  %15 = add nsw i32 %3, %13
  %16 = mul nsw i32 %14, %12
  %17 = mul nsw i32 %15, %11
  %18 = mul nsw i32 %15, %12
  %19 = mul nsw i32 %10, %14
  %20 = add i32 %16, 8960
  %21 = add i32 %20, %17
  %22 = icmp ult i32 %21, 18176
  %23 = add nsw i32 %19, 8960
  %24 = add i32 %23, %18
  %25 = icmp ult i32 %24, 18176
  %26 = select i1 %22, i1 %25, i1 false
  %27 = zext i1 %26 to i32
  br label %28

28:                                               ; preds = %4, %8
  %29 = phi i32 [ %27, %8 ], [ 0, %4 ]
  ret i32 %29
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.umin.i16(i16, i16) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #9

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #11 = { nounwind }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }

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
