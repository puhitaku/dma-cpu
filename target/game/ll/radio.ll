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
  %16 = alloca [11 x i32], align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  tail call void @uputs(ptr noundef nonnull @.str) #8
  tail call void @led(i32 noundef 984577, i32 noundef 984577) #8
  tail call void @gfx_clear(i16 noundef zeroext 2114) #8
  call void @llvm.lifetime.start.p0(i64 44, ptr nonnull %16) #9
  br label %20

20:                                               ; preds = %26, %0
  %21 = phi i32 [ 0, %0 ], [ %31, %26 ]
  %22 = icmp eq i32 %21, 11
  br i1 %22, label %23, label %26

23:                                               ; preds = %20
  %24 = getelementptr inbounds nuw i8, ptr %16, i32 40
  %25 = load i32, ptr %24, align 4
  br label %32

26:                                               ; preds = %20
  %27 = mul nuw nsw i32 %21, 24
  %28 = add nuw nsw i32 %27, 200
  %29 = udiv i32 819200, %28
  %30 = getelementptr inbounds nuw [11 x i32], ptr %16, i32 0, i32 %21
  store i32 %29, ptr %30, align 4, !tbaa !3
  %31 = add nuw nsw i32 %21, 1
  br label %20, !llvm.loop !7

32:                                               ; preds = %49, %23
  %33 = phi i32 [ %50, %49 ], [ 0, %23 ]
  %34 = icmp eq i32 %33, 5
  br i1 %34, label %105, label %35

35:                                               ; preds = %32
  %36 = mul nuw nsw i32 %33, 242
  %37 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537129872 to ptr), i32 %36
  br label %38

38:                                               ; preds = %54, %35
  %39 = phi i32 [ %55, %54 ], [ 0, %35 ]
  %40 = icmp eq i32 %39, 11
  br i1 %40, label %49, label %41

41:                                               ; preds = %38
  %42 = mul nuw nsw i32 %39, 11
  %43 = getelementptr inbounds nuw [11 x i32], ptr %16, i32 0, i32 %39
  %44 = mul nuw nsw i32 %39, 24
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
  %53 = icmp eq i32 %52, 11
  br i1 %53, label %54, label %56

54:                                               ; preds = %51
  %55 = add nuw nsw i32 %39, 1
  br label %38, !llvm.loop !11

56:                                               ; preds = %51
  %57 = mul nuw nsw i32 %52, 24
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
  %98 = trunc i32 %96 to i8
  %99 = add nuw nsw i32 %52, %42
  %100 = shl nuw nsw i32 %99, 1
  %101 = getelementptr inbounds nuw i8, ptr %37, i32 %100
  store i8 %98, ptr %101, align 2, !tbaa !12
  %102 = trunc i32 %97 to i8
  %103 = getelementptr inbounds nuw i8, ptr %101, i32 1
  store i8 %102, ptr %103, align 1, !tbaa !12
  %104 = add nuw nsw i32 %52, 1
  br label %51, !llvm.loop !13

105:                                              ; preds = %32, %116
  %106 = phi i32 [ %117, %116 ], [ 0, %32 ]
  %107 = icmp eq i32 %106, 10
  br i1 %107, label %141, label %108

108:                                              ; preds = %105
  %109 = mul nuw nsw i32 %106, 50
  %110 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131084 to ptr), i32 %109
  br label %111

111:                                              ; preds = %121, %108
  %112 = phi i32 [ %122, %121 ], [ 0, %108 ]
  %113 = icmp eq i32 %112, 5
  br i1 %113, label %116, label %114

114:                                              ; preds = %111
  %115 = mul nuw nsw i32 %112, 5
  br label %118

116:                                              ; preds = %111
  %117 = add nuw nsw i32 %106, 1
  br label %105, !llvm.loop !14

118:                                              ; preds = %123, %114
  %119 = phi i32 [ %140, %123 ], [ 0, %114 ]
  %120 = icmp eq i32 %119, 5
  br i1 %120, label %121, label %123

121:                                              ; preds = %118
  %122 = add nuw nsw i32 %112, 1
  br label %111, !llvm.loop !15

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
  %129 = trunc i32 %128 to i8
  %130 = add i8 %129, 120
  %131 = add nuw nsw i32 %119, %115
  %132 = shl nuw nsw i32 %131, 1
  %133 = getelementptr inbounds nuw i8, ptr %110, i32 %132
  store i8 %130, ptr %133, align 2, !tbaa !12
  %134 = load i32, ptr %18, align 4, !tbaa !3
  %135 = mul nsw i32 %134, %125
  %136 = lshr i32 %135, 12
  %137 = trunc i32 %136 to i8
  %138 = add i8 %137, 120
  %139 = getelementptr inbounds nuw i8, ptr %133, i32 1
  store i8 %138, ptr %139, align 1, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %19) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %18) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %17) #9
  %140 = add nuw nsw i32 %119, 1
  br label %118, !llvm.loop !16

141:                                              ; preds = %105
  call void @llvm.lifetime.end.p0(i64 44, ptr nonnull %16) #9
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
  store i16 %161, ptr %162, align 2, !tbaa !17
  %163 = trunc nuw nsw i32 %158 to i16
  %164 = add nsw i16 %163, -108
  %165 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %143
  store i16 %164, ptr %165, align 2, !tbaa !17
  br label %186

166:                                              ; preds = %145
  %167 = trunc nsw i32 %157 to i16
  %168 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 %167, ptr %168, align 2, !tbaa !17
  %169 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %143
  store i16 120, ptr %169, align 2, !tbaa !17
  %170 = trunc nuw nsw i32 %159 to i16
  br label %186

171:                                              ; preds = %145
  %172 = trunc nsw i32 %157 to i16
  %173 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 %172, ptr %173, align 2, !tbaa !17
  %174 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %143
  store i16 -120, ptr %174, align 2, !tbaa !17
  %175 = trunc nuw nsw i32 %159 to i16
  br label %186

176:                                              ; preds = %145
  %177 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 -120, ptr %177, align 2, !tbaa !17
  %178 = trunc nsw i32 %157 to i16
  %179 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %143
  store i16 %178, ptr %179, align 2, !tbaa !17
  %180 = trunc nuw nsw i32 %159 to i16
  br label %186

181:                                              ; preds = %145
  %182 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %143
  store i16 120, ptr %182, align 2, !tbaa !17
  %183 = trunc nsw i32 %157 to i16
  %184 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %143
  store i16 %183, ptr %184, align 2, !tbaa !17
  %185 = trunc nuw nsw i32 %159 to i16
  br label %186

186:                                              ; preds = %181, %176, %171, %166, %160
  %187 = phi i16 [ %185, %181 ], [ %180, %176 ], [ %175, %171 ], [ %170, %166 ], [ 440, %160 ]
  %188 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %143
  store i16 %187, ptr %188, align 2, !tbaa !17
  %189 = add nuw nsw i32 %143, 1
  br label %142, !llvm.loop !19

190:                                              ; preds = %142, %227
  %191 = phi i32 [ %239, %227 ], [ 0, %142 ]
  %192 = icmp eq i32 %191, 10
  br i1 %192, label %265, label %193

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
  %213 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537131584 to ptr), i32 %212
  store i16 %211, ptr %213, align 2, !tbaa !17
  %214 = trunc nsw i32 %209 to i16
  %215 = getelementptr inbounds nuw i8, ptr %213, i32 2
  store i16 %214, ptr %215, align 2, !tbaa !17
  %216 = trunc nsw i32 %208 to i16
  %217 = getelementptr inbounds nuw i8, ptr %213, i32 4
  store i16 %216, ptr %217, align 2, !tbaa !17
  %218 = icmp eq i32 %196, 4
  %219 = select i1 %195, i16 300, i16 144
  %220 = select i1 %218, i16 144, i16 %219
  %221 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131644 to ptr), i32 %191
  store i16 %220, ptr %221, align 2, !tbaa !17
  %222 = shl nuw nsw i32 %191, 4
  %223 = add nuw nsw i32 %222, 500
  br label %224

224:                                              ; preds = %240, %207
  %225 = phi i32 [ 0, %207 ], [ %264, %240 ]
  %226 = icmp eq i32 %225, 16
  br i1 %226, label %227, label %240

227:                                              ; preds = %224
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %14) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %15) #9
  call fastcc void @face_point(i32 noundef %191, i32 noundef 1, i32 noundef 1, ptr noundef %13, ptr noundef %14, ptr noundef %15) #10
  %228 = load i32, ptr %13, align 4, !tbaa !3
  %229 = mul nsw i32 %228, %210
  %230 = load i32, ptr %14, align 4, !tbaa !3
  %231 = mul nsw i32 %230, %209
  %232 = add nsw i32 %231, %229
  %233 = load i32, ptr %15, align 4, !tbaa !3
  %234 = mul nsw i32 %233, %208
  %235 = add nsw i32 %232, %234
  %236 = lshr i32 %235, 31
  %237 = trunc nuw nsw i32 %236 to i16
  %238 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131664 to ptr), i32 %191
  store i16 %237, ptr %238, align 2, !tbaa !17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %15) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %14) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #9
  %239 = add nuw nsw i32 %191, 1
  br label %190, !llvm.loop !20

240:                                              ; preds = %224
  %241 = add nuw nsw i32 %223, %225
  %242 = and i32 %225, 3
  %243 = lshr i32 %225, 2
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %10) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #9
  call fastcc void @face_point(i32 noundef %191, i32 noundef %242, i32 noundef %243, ptr noundef %7, ptr noundef %8, ptr noundef %9) #10
  %244 = add nuw nsw i32 %242, 1
  %245 = add nuw nsw i32 %243, 1
  call fastcc void @face_point(i32 noundef %191, i32 noundef %244, i32 noundef %245, ptr noundef %10, ptr noundef %11, ptr noundef %12) #10
  %246 = load i32, ptr %7, align 4, !tbaa !3
  %247 = load i32, ptr %10, align 4, !tbaa !3
  %248 = add nsw i32 %247, %246
  %249 = sdiv i32 %248, 2
  %250 = trunc i32 %249 to i16
  %251 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %241
  store i16 %250, ptr %251, align 2, !tbaa !17
  %252 = load i32, ptr %8, align 4, !tbaa !3
  %253 = load i32, ptr %11, align 4, !tbaa !3
  %254 = add nsw i32 %253, %252
  %255 = sdiv i32 %254, 2
  %256 = trunc i32 %255 to i16
  %257 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %241
  store i16 %256, ptr %257, align 2, !tbaa !17
  %258 = load i32, ptr %9, align 4, !tbaa !3
  %259 = load i32, ptr %12, align 4, !tbaa !3
  %260 = add nsw i32 %259, %258
  %261 = sdiv i32 %260, 2
  %262 = trunc i32 %261 to i16
  %263 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %241
  store i16 %262, ptr %263, align 2, !tbaa !17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %10) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #9
  %264 = add nuw nsw i32 %225, 1
  br label %224, !llvm.loop !21

265:                                              ; preds = %190, %279
  %266 = phi i32 [ %280, %279 ], [ 0, %190 ]
  %267 = icmp eq i32 %266, 660
  br i1 %267, label %281, label %268

268:                                              ; preds = %265
  %269 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123272 to ptr), i32 %266
  store i16 0, ptr %269, align 2, !tbaa !17
  %270 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121952 to ptr), i32 %266
  store i16 0, ptr %270, align 2, !tbaa !17
  %271 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120632 to ptr), i32 %266
  store i16 0, ptr %271, align 2, !tbaa !17
  %272 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %266
  store i16 0, ptr %272, align 2, !tbaa !17
  %273 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %266
  store i16 0, ptr %273, align 2, !tbaa !17
  %274 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %266
  store i16 0, ptr %274, align 2, !tbaa !17
  %275 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537128552 to ptr), i32 %266
  store i16 -1, ptr %275, align 2, !tbaa !17
  %276 = tail call fastcc i32 @is_light(i32 noundef %266) #10
  %277 = icmp eq i32 %276, 0
  br i1 %277, label %279, label %278

278:                                              ; preds = %268
  store i16 -36, ptr %274, align 2, !tbaa !17
  store i16 -36, ptr %273, align 2, !tbaa !17
  store i16 -6586, ptr %272, align 2, !tbaa !17
  br label %279

279:                                              ; preds = %278, %268
  %280 = add nuw nsw i32 %266, 1
  br label %265, !llvm.loop !22

281:                                              ; preds = %265
  tail call fastcc void @repaint(i32 noundef 1) #10
  br label %282

282:                                              ; preds = %556, %281
  %283 = phi i32 [ 0, %281 ], [ %552, %556 ]
  br label %284

284:                                              ; preds = %282, %330
  %285 = phi i1 [ false, %330 ], [ true, %282 ]
  br label %286

286:                                              ; preds = %284, %293
  %287 = phi i1 [ false, %293 ], [ %285, %284 ]
  tail call void @in_poll() #8
  %288 = load i32, ptr @in_edge, align 4, !tbaa !3
  %289 = and i32 %288, 31
  %290 = icmp eq i32 %289, 0
  br i1 %290, label %292, label %291

291:                                              ; preds = %286
  tail call void @led(i32 noundef 0, i32 noundef 0) #8
  tail call void @uputs(ptr noundef nonnull @.str.1) #8
  ret void

292:                                              ; preds = %286
  br i1 %287, label %294, label %293

293:                                              ; preds = %292
  tail call void @frame_sync(i32 noundef 33000) #8
  br label %286, !llvm.loop !23

294:                                              ; preds = %292, %318
  %295 = phi i32 [ %323, %318 ], [ -1, %292 ]
  %296 = phi i32 [ %325, %318 ], [ 0, %292 ]
  %297 = phi i32 [ %324, %318 ], [ 0, %292 ]
  %298 = icmp eq i32 %296, 660
  br i1 %298, label %326, label %299

299:                                              ; preds = %294
  %300 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %296
  %301 = load i16, ptr %300, align 2, !tbaa !17
  %302 = zext i16 %301 to i32
  %303 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %296
  %304 = load i16, ptr %303, align 2, !tbaa !17
  %305 = zext i16 %304 to i32
  %306 = add nuw nsw i32 %305, %302
  %307 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %296
  %308 = load i16, ptr %307, align 2, !tbaa !17
  %309 = zext i16 %308 to i32
  %310 = add nuw nsw i32 %306, %309
  %311 = icmp samesign ult i32 %296, 500
  br i1 %311, label %318, label %312

312:                                              ; preds = %299
  %313 = add nsw i32 %296, -500
  %314 = lshr i32 %313, 4
  %315 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131644 to ptr), i32 %314
  %316 = load i16, ptr %315, align 2, !tbaa !17
  %317 = sext i16 %316 to i32
  br label %318

318:                                              ; preds = %312, %299
  %319 = phi i32 [ %317, %312 ], [ 256, %299 ]
  %320 = mul i32 %319, %310
  %321 = lshr i32 %320, 8
  %322 = icmp samesign ugt i32 %321, %297
  %323 = select i1 %322, i32 %296, i32 %295
  %324 = tail call i32 @llvm.umax.i32(i32 %321, i32 %297)
  %325 = add nuw nsw i32 %296, 1
  br label %294, !llvm.loop !24

326:                                              ; preds = %294
  %327 = icmp samesign ugt i32 %297, 95
  %328 = select i1 %327, i32 %295, i32 -1
  %329 = icmp slt i32 %328, 0
  br i1 %329, label %330, label %331

330:                                              ; preds = %326
  tail call void @uputs(ptr noundef nonnull @.str.2) #8
  tail call void @uputn(i32 noundef %283) #8
  tail call void @uputs(ptr noundef nonnull @.str.3) #8
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #8
  br label %284, !llvm.loop !23

331:                                              ; preds = %326
  %332 = icmp samesign ult i32 %328, 500
  br i1 %332, label %339, label %333

333:                                              ; preds = %331
  %334 = add nsw i32 %328, -500
  %335 = lshr i32 %334, 4
  %336 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537131644 to ptr), i32 %335
  %337 = load i16, ptr %336, align 2, !tbaa !17
  %338 = sext i16 %337 to i32
  br label %339

339:                                              ; preds = %333, %331
  %340 = phi i32 [ %338, %333 ], [ 256, %331 ]
  %341 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %328
  %342 = load i16, ptr %341, align 2, !tbaa !17
  %343 = zext i16 %342 to i32
  %344 = mul nsw i32 %340, %343
  %345 = lshr i32 %344, 8
  %346 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %328
  %347 = load i16, ptr %346, align 2, !tbaa !17
  %348 = zext i16 %347 to i32
  %349 = mul nsw i32 %340, %348
  %350 = lshr i32 %349, 8
  %351 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %328
  %352 = load i16, ptr %351, align 2, !tbaa !17
  %353 = zext i16 %352 to i32
  %354 = mul nsw i32 %340, %353
  %355 = lshr i32 %354, 8
  store i16 0, ptr %351, align 2, !tbaa !17
  store i16 0, ptr %346, align 2, !tbaa !17
  store i16 0, ptr %341, align 2, !tbaa !17
  %356 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %328
  %357 = load i16, ptr %356, align 2, !tbaa !17
  %358 = sext i16 %357 to i32
  %359 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %328
  %360 = load i16, ptr %359, align 2, !tbaa !17
  %361 = sext i16 %360 to i32
  %362 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %328
  %363 = load i16, ptr %362, align 2, !tbaa !17
  %364 = sext i16 %363 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  call fastcc void @normal_of(i32 noundef range(i32 0, -2147483648) %328, ptr noundef %1, ptr noundef %2, ptr noundef %3) #10
  %365 = load i32, ptr %1, align 4
  %366 = load i32, ptr %2, align 4
  %367 = load i32, ptr %3, align 4
  br label %368

368:                                              ; preds = %549, %339
  %369 = phi i32 [ 0, %339 ], [ %550, %549 ]
  %370 = icmp eq i32 %369, 660
  br i1 %370, label %551, label %371

371:                                              ; preds = %368
  %372 = icmp eq i32 %369, %328
  br i1 %372, label %549, label %373

373:                                              ; preds = %371
  %374 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537116672 to ptr), i32 %369
  %375 = load i16, ptr %374, align 2, !tbaa !17
  %376 = sext i16 %375 to i32
  %377 = sub nsw i32 %376, %358
  %378 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537117992 to ptr), i32 %369
  %379 = load i16, ptr %378, align 2, !tbaa !17
  %380 = sext i16 %379 to i32
  %381 = sub nsw i32 %380, %361
  %382 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537119312 to ptr), i32 %369
  %383 = load i16, ptr %382, align 2, !tbaa !17
  %384 = sext i16 %383 to i32
  %385 = sub nsw i32 %384, %364
  %386 = mul nsw i32 %377, %365
  %387 = mul nsw i32 %381, %366
  %388 = add nsw i32 %387, %386
  %389 = mul nsw i32 %385, %367
  %390 = add nsw i32 %388, %389
  %391 = ashr i32 %390, 8
  %392 = icmp slt i32 %391, 1
  br i1 %392, label %549, label %393

393:                                              ; preds = %373
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #9
  call fastcc void @normal_of(i32 noundef %369, ptr noundef %4, ptr noundef %5, ptr noundef %6) #10
  %394 = load i32, ptr %4, align 4, !tbaa !3
  %395 = mul nsw i32 %394, %377
  %396 = load i32, ptr %5, align 4, !tbaa !3
  %397 = mul nsw i32 %396, %381
  %398 = add nsw i32 %397, %395
  %399 = load i32, ptr %6, align 4, !tbaa !3
  %400 = mul nsw i32 %399, %385
  %401 = add nsw i32 %398, %400
  %402 = ashr i32 %401, 8
  %403 = icmp sgt i32 %402, -1
  br i1 %403, label %548, label %404

404:                                              ; preds = %393
  %405 = mul nsw i32 %377, %377
  %406 = mul nsw i32 %381, %381
  %407 = add nuw i32 %406, %405
  %408 = mul nsw i32 %385, %385
  %409 = add i32 %407, %408
  %410 = icmp ult i32 %409, 64
  br i1 %410, label %548, label %411

411:                                              ; preds = %404
  %412 = load i16, ptr %356, align 2, !tbaa !17
  %413 = sext i16 %412 to i32
  %414 = load i16, ptr %359, align 2, !tbaa !17
  %415 = sext i16 %414 to i32
  %416 = load i16, ptr %362, align 2, !tbaa !17
  %417 = sext i16 %416 to i32
  %418 = sub nsw i32 %376, %413
  %419 = sub nsw i32 %380, %415
  %420 = sub nsw i32 %384, %417
  %421 = tail call i16 @llvm.smin.i16(i16 %412, i16 %375)
  %422 = sext i16 %421 to i32
  %423 = add nsw i32 %413, %376
  %424 = sub nsw i32 %423, %422
  %425 = tail call i16 @llvm.smin.i16(i16 %416, i16 %383)
  %426 = sext i16 %425 to i32
  %427 = add nsw i32 %417, %384
  %428 = sub nsw i32 %427, %426
  %429 = icmp sgt i32 %424, -89
  %430 = icmp slt i16 %421, 5
  %431 = and i1 %430, %429
  %432 = icmp sgt i32 %428, 283
  %433 = icmp slt i16 %425, 377
  %434 = and i1 %433, %432
  %435 = select i1 %431, i1 %434, i1 false
  %436 = icmp sgt i32 %424, -2
  %437 = icmp slt i16 %421, 92
  %438 = and i1 %437, %436
  %439 = icmp sgt i32 %428, 221
  %440 = icmp slt i16 %425, 315
  %441 = and i1 %440, %439
  %442 = select i1 %438, i1 %441, i1 false
  %443 = select i1 %435, i1 true, i1 %442
  br i1 %443, label %444, label %473

444:                                              ; preds = %411, %468
  %445 = phi i32 [ %469, %468 ], [ 0, %411 ]
  %446 = phi i32 [ %470, %468 ], [ 1, %411 ]
  %447 = icmp eq i32 %446, 6
  br i1 %447, label %471, label %448

448:                                              ; preds = %444
  %449 = mul nuw nsw i32 %446, 43
  %450 = mul nsw i32 %449, %418
  %451 = ashr i32 %450, 8
  %452 = add nsw i32 %451, %413
  %453 = mul nsw i32 %449, %419
  %454 = ashr i32 %453, 8
  %455 = add nsw i32 %454, %415
  %456 = mul nsw i32 %449, %420
  %457 = ashr i32 %456, 8
  %458 = add nsw i32 %457, %417
  br i1 %435, label %459, label %462

459:                                              ; preds = %448
  %460 = tail call fastcc i32 @in_box(i32 noundef 0, i32 noundef %452, i32 noundef %455, i32 noundef %458) #10
  %461 = icmp eq i32 %460, 0
  br i1 %461, label %462, label %468

462:                                              ; preds = %459, %448
  br i1 %442, label %463, label %466

463:                                              ; preds = %462
  %464 = tail call fastcc i32 @in_box(i32 noundef 1, i32 noundef %452, i32 noundef %455, i32 noundef %458) #10
  %465 = icmp eq i32 %464, 0
  br i1 %465, label %466, label %468

466:                                              ; preds = %463, %462
  %467 = add nsw i32 %445, 1
  br label %468

468:                                              ; preds = %466, %463, %459
  %469 = phi i32 [ %467, %466 ], [ %445, %463 ], [ %445, %459 ]
  %470 = add nuw nsw i32 %446, 1
  br label %444, !llvm.loop !25

471:                                              ; preds = %444
  %472 = icmp eq i32 %445, 0
  br i1 %472, label %548, label %473

473:                                              ; preds = %471, %411
  %474 = phi i32 [ %445, %471 ], [ 5, %411 ]
  %475 = mul i32 %391, -1024
  %476 = mul i32 %475, %402
  %477 = udiv i32 %476, %409
  %478 = udiv i32 589824, %409
  %479 = tail call i32 @llvm.umin.i32(i32 %478, i32 4096)
  %480 = mul i32 %477, 41
  %481 = mul i32 %480, %479
  %482 = lshr i32 %481, 15
  %483 = mul nsw i32 %474, 51
  %484 = mul i32 %483, %482
  %485 = icmp ult i32 %484, 256
  br i1 %485, label %548, label %486

486:                                              ; preds = %473
  %487 = lshr i32 %484, 8
  %488 = icmp samesign ult i32 %369, 500
  %489 = udiv i32 %369, 100
  %490 = select i1 %488, i32 %489, i32 5
  %491 = getelementptr inbounds nuw [6 x [3 x i16]], ptr @rho, i32 0, i32 %490
  %492 = mul i32 %487, %345
  %493 = lshr i32 %492, 12
  %494 = load i16, ptr %491, align 2, !tbaa !17
  %495 = zext i16 %494 to i32
  %496 = mul i32 %493, %495
  %497 = lshr i32 %496, 8
  %498 = mul i32 %487, %350
  %499 = lshr i32 %498, 12
  %500 = getelementptr inbounds nuw i8, ptr %491, i32 2
  %501 = load i16, ptr %500, align 2, !tbaa !17
  %502 = zext i16 %501 to i32
  %503 = mul i32 %499, %502
  %504 = lshr i32 %503, 8
  %505 = mul i32 %487, %355
  %506 = lshr i32 %505, 12
  %507 = getelementptr inbounds nuw i8, ptr %491, i32 4
  %508 = load i16, ptr %507, align 2, !tbaa !17
  %509 = zext i16 %508 to i32
  %510 = mul i32 %506, %509
  %511 = lshr i32 %510, 8
  %512 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537120632 to ptr), i32 %369
  %513 = load i16, ptr %512, align 2, !tbaa !17
  %514 = zext i16 %513 to i32
  %515 = add nuw nsw i32 %497, %514
  %516 = tail call i32 @llvm.umin.i32(i32 %515, i32 65535)
  %517 = trunc nuw i32 %516 to i16
  store i16 %517, ptr %512, align 2, !tbaa !17
  %518 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537121952 to ptr), i32 %369
  %519 = load i16, ptr %518, align 2, !tbaa !17
  %520 = zext i16 %519 to i32
  %521 = add nuw nsw i32 %504, %520
  %522 = tail call i32 @llvm.umin.i32(i32 %521, i32 65535)
  %523 = trunc nuw i32 %522 to i16
  store i16 %523, ptr %518, align 2, !tbaa !17
  %524 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537123272 to ptr), i32 %369
  %525 = load i16, ptr %524, align 2, !tbaa !17
  %526 = zext i16 %525 to i32
  %527 = add nuw nsw i32 %511, %526
  %528 = tail call i32 @llvm.umin.i32(i32 %527, i32 65535)
  %529 = trunc nuw i32 %528 to i16
  store i16 %529, ptr %524, align 2, !tbaa !17
  %530 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537124592 to ptr), i32 %369
  %531 = load i16, ptr %530, align 2, !tbaa !17
  %532 = zext i16 %531 to i32
  %533 = add nuw nsw i32 %497, %532
  %534 = tail call i32 @llvm.umin.i32(i32 %533, i32 65535)
  %535 = trunc nuw i32 %534 to i16
  store i16 %535, ptr %530, align 2, !tbaa !17
  %536 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537125912 to ptr), i32 %369
  %537 = load i16, ptr %536, align 2, !tbaa !17
  %538 = zext i16 %537 to i32
  %539 = add nuw nsw i32 %504, %538
  %540 = tail call i32 @llvm.umin.i32(i32 %539, i32 65535)
  %541 = trunc nuw i32 %540 to i16
  store i16 %541, ptr %536, align 2, !tbaa !17
  %542 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537127232 to ptr), i32 %369
  %543 = load i16, ptr %542, align 2, !tbaa !17
  %544 = zext i16 %543 to i32
  %545 = add nuw nsw i32 %511, %544
  %546 = tail call i32 @llvm.umin.i32(i32 %545, i32 65535)
  %547 = trunc nuw i32 %546 to i16
  store i16 %547, ptr %542, align 2, !tbaa !17
  br label %548

548:                                              ; preds = %486, %473, %471, %404, %393
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #9
  br label %549

549:                                              ; preds = %548, %373, %371
  %550 = add nuw nsw i32 %369, 1
  br label %368, !llvm.loop !26

551:                                              ; preds = %368
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #9
  %552 = add i32 %283, 1
  tail call fastcc void @repaint(i32 noundef 0) #10
  %553 = and i32 %552, 15
  %554 = icmp eq i32 %553, 0
  br i1 %554, label %555, label %556

555:                                              ; preds = %551
  tail call void @uputs(ptr noundef nonnull @.str.4) #8
  tail call void @uputn(i32 noundef %552) #8
  tail call void @uputs(ptr noundef nonnull @.str.5) #8
  br label %556

556:                                              ; preds = %555, %551
  br label %282
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
  %20 = tail call fastcc zeroext i16 @patch_color(i32 noundef %7) #10
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
  tail call void @gfx_fill(i32 noundef %57, i32 noundef %60, i32 noundef %63, i32 noundef %67, i16 noundef zeroext %20) #8
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
  tail call fastcc void @fill_htrap(i32 noundef %71, i32 noundef %74, i32 noundef %76, i32 noundef %78, i32 noundef %80, i32 noundef %82, i16 noundef zeroext %20) #10
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
  tail call fastcc void @fill_htrap(i32 noundef %86, i32 noundef %89, i32 noundef %91, i32 noundef %93, i32 noundef %95, i32 noundef %97, i16 noundef zeroext %20) #10
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
  tail call fastcc void @fill_vtrap(i32 noundef %100, i32 noundef %102, i32 noundef %105, i32 noundef %108, i32 noundef %111, i32 noundef %114, i16 noundef zeroext %20) #10
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
  tail call fastcc void @fill_vtrap(i32 noundef %117, i32 noundef %119, i32 noundef %122, i32 noundef %125, i32 noundef %128, i32 noundef %131, i16 noundef zeroext %20) #10
  br label %132

132:                                              ; preds = %115, %98, %83, %68, %55, %21
  %133 = phi i32 [ %8, %21 ], [ 1, %55 ], [ 1, %68 ], [ 1, %83 ], [ 1, %98 ], [ 1, %115 ]
  %134 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !27

135:                                              ; preds = %10, %278
  %136 = phi i32 [ %279, %278 ], [ 500, %10 ]
  %137 = icmp eq i32 %136, 660
  br i1 %137, label %138, label %139

138:                                              ; preds = %135
  tail call void @gfx_present() #8
  ret void

139:                                              ; preds = %135
  %140 = tail call fastcc zeroext i16 @patch_color(i32 noundef %136) #10
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
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #9
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
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #9
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
  br label %198, !llvm.loop !28

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
  br label %232, !llvm.loop !29

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
  br label %228, !llvm.loop !29

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
  tail call void @gfx_fill(i32 noundef %226, i32 noundef %229, i32 noundef 1, i32 noundef %274, i16 noundef zeroext %140) #8
  br label %275

275:                                              ; preds = %273, %235
  %276 = add nsw i32 %226, 1
  br label %225, !llvm.loop !30

277:                                              ; preds = %225
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #9
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #9
  br label %278

278:                                              ; preds = %277, %145, %141
  %279 = add nuw nsw i32 %136, 1
  br label %135, !llvm.loop !31
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
define internal fastcc void @face_point(i32 noundef range(i32 -2147483648, 10) %0, i32 noundef range(i32 -2147483648, 5) %1, i32 noundef range(i32 -2147483648, 5) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %4, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %5) unnamed_addr #3 {
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
define internal fastcc range(i32 0, 2) i32 @is_light(i32 noundef range(i32 -2147483648, 660) %0) unnamed_addr #4 {
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
define internal fastcc zeroext i16 @patch_color(i32 noundef range(i32 -2147483648, 660) %0) unnamed_addr #5 {
  %2 = tail call fastcc i32 @is_light(i32 noundef %0) #10
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
  tail call void @gfx_fill(i32 noundef %25, i32 noundef %21, i32 noundef %29, i32 noundef 1, i16 noundef zeroext %6) #8
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
  tail call void @gfx_fill(i32 noundef %21, i32 noundef %25, i32 noundef 1, i32 noundef %29, i16 noundef zeroext %6) #8
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
define internal fastcc void @normal_of(i32 noundef %0, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #6 {
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
