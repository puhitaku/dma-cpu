; ModuleID = 'vfiprintf.c'
source_filename = "vfiprintf.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%union.anon = type { [11 x i8] }

@.str = private unnamed_addr constant [8 x i8] c"*float*\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"(null)\00", align 1

@__i_vfprintf = dso_local alias i32 (ptr, ptr, [1 x i32]), ptr @vfprintf

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vfprintf(ptr noundef nonnull %0, ptr noundef readonly captures(none) %1, [1 x i32] %2) #0 {
  %4 = alloca %union.anon, align 1
  call void @llvm.lifetime.start.p0(i64 11, ptr nonnull %4) #6
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %6 = load ptr, ptr %5, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 2
  %8 = load i8, ptr %7, align 2, !tbaa !9
  %9 = and i8 %8, 2
  %10 = icmp eq i8 %9, 0
  br i1 %10, label %401, label %11

11:                                               ; preds = %3
  %12 = extractvalue [1 x i32] %2, 0
  %13 = inttoptr i32 %12 to ptr
  %14 = ptrtoint ptr %4 to i32
  br label %15

15:                                               ; preds = %231, %11
  %16 = phi ptr [ %1, %11 ], [ %101, %231 ]
  %17 = phi i32 [ 0, %11 ], [ %232, %231 ]
  %18 = phi ptr [ %13, %11 ], [ %233, %231 ]
  br label %19

19:                                               ; preds = %28, %15
  %20 = phi ptr [ %16, %15 ], [ %29, %28 ]
  %21 = phi i32 [ %17, %15 ], [ %30, %28 ]
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 1
  %23 = load i8, ptr %20, align 1, !tbaa !10
  switch i8 %23, label %28 [
    i8 0, label %401
    i8 37, label %24
  ]

24:                                               ; preds = %19
  %25 = getelementptr inbounds nuw i8, ptr %20, i32 2
  %26 = load i8, ptr %22, align 1, !tbaa !10
  %27 = icmp eq i8 %26, 37
  br i1 %27, label %28, label %33

28:                                               ; preds = %19, %24
  %29 = phi ptr [ %25, %24 ], [ %22, %19 ]
  %30 = add nsw i32 %21, 1
  %31 = call i32 %6(i8 noundef signext %23, ptr noundef nonnull %0) #7
  %32 = icmp slt i32 %31, 0
  br i1 %32, label %398, label %19, !llvm.loop !11

33:                                               ; preds = %24, %92
  %34 = phi ptr [ %97, %92 ], [ %25, %24 ]
  %35 = phi i8 [ %98, %92 ], [ %26, %24 ]
  %36 = phi i16 [ %93, %92 ], [ 0, %24 ]
  %37 = phi ptr [ %94, %92 ], [ %18, %24 ]
  %38 = phi i32 [ %95, %92 ], [ 0, %24 ]
  %39 = phi i32 [ %96, %92 ], [ 0, %24 ]
  %40 = sext i8 %35 to i32
  %41 = icmp ult i16 %36, 32
  br i1 %41, label %42, label %54

42:                                               ; preds = %33
  switch i8 %35, label %56 [
    i8 48, label %43
    i8 43, label %45
    i8 32, label %47
    i8 45, label %50
    i8 35, label %52
    i8 39, label %92
  ]

43:                                               ; preds = %42
  %44 = or i16 %36, 1
  br label %92

45:                                               ; preds = %42
  %46 = or i16 %36, 2
  br label %47

47:                                               ; preds = %42, %45
  %48 = phi i16 [ %46, %45 ], [ %36, %42 ]
  %49 = or i16 %48, 4
  br label %92

50:                                               ; preds = %42
  %51 = or i16 %36, 8
  br label %92

52:                                               ; preds = %42
  %53 = or i16 %36, 16
  br label %92

54:                                               ; preds = %33
  %55 = icmp ult i16 %36, 128
  br i1 %55, label %56, label %79

56:                                               ; preds = %42, %54
  %57 = add nsw i32 %40, -48
  %58 = icmp ult i32 %57, 10
  br i1 %58, label %59, label %68

59:                                               ; preds = %56
  %60 = icmp samesign ult i16 %36, 64
  br i1 %60, label %64, label %61

61:                                               ; preds = %59
  %62 = mul nsw i32 %39, 10
  %63 = add i32 %62, %57
  br label %92

64:                                               ; preds = %59
  %65 = mul nsw i32 %38, 10
  %66 = add i32 %65, %57
  %67 = or i16 %36, 32
  br label %92

68:                                               ; preds = %56
  switch i8 %35, label %100 [
    i8 42, label %69
    i8 46, label %75
    i8 108, label %80
    i8 104, label %85
    i8 76, label %90
  ]

69:                                               ; preds = %68
  %70 = icmp samesign ult i16 %36, 64
  %71 = getelementptr inbounds nuw i8, ptr %37, i32 4
  %72 = load i32, ptr %37, align 4, !tbaa !13
  br i1 %70, label %73, label %92

73:                                               ; preds = %69
  %74 = or i16 %36, 32
  br label %92

75:                                               ; preds = %68
  %76 = icmp samesign ult i16 %36, 64
  br i1 %76, label %77, label %401

77:                                               ; preds = %75
  %78 = or disjoint i16 %36, 64
  br label %92

79:                                               ; preds = %54
  switch i8 %35, label %100 [
    i8 108, label %80
    i8 104, label %85
    i8 76, label %90
  ]

80:                                               ; preds = %68, %79
  %81 = shl i16 %36, 2
  %82 = and i16 %81, 512
  %83 = or i16 %36, %82
  %84 = or i16 %83, 128
  br label %92

85:                                               ; preds = %68, %79
  %86 = shl i16 %36, 1
  %87 = and i16 %86, 512
  %88 = or i16 %36, %87
  %89 = or i16 %88, 256
  br label %92

90:                                               ; preds = %68, %79
  %91 = or i16 %36, 640
  br label %92

92:                                               ; preds = %69, %73, %61, %64, %42, %90, %85, %80, %77, %52, %50, %47, %43
  %93 = phi i16 [ %36, %61 ], [ %67, %64 ], [ %74, %73 ], [ %78, %77 ], [ %84, %80 ], [ %89, %85 ], [ %91, %90 ], [ %44, %43 ], [ %49, %47 ], [ %51, %50 ], [ %53, %52 ], [ %36, %42 ], [ %36, %69 ]
  %94 = phi ptr [ %37, %61 ], [ %37, %64 ], [ %71, %73 ], [ %37, %77 ], [ %37, %80 ], [ %37, %85 ], [ %37, %90 ], [ %37, %43 ], [ %37, %47 ], [ %37, %50 ], [ %37, %52 ], [ %37, %42 ], [ %71, %69 ]
  %95 = phi i32 [ %38, %61 ], [ %66, %64 ], [ %72, %73 ], [ %38, %77 ], [ %38, %80 ], [ %38, %85 ], [ %38, %90 ], [ %38, %43 ], [ %38, %47 ], [ %38, %50 ], [ %38, %52 ], [ %38, %42 ], [ %38, %69 ]
  %96 = phi i32 [ %63, %61 ], [ %39, %64 ], [ %39, %73 ], [ %39, %77 ], [ %39, %80 ], [ %39, %85 ], [ %39, %90 ], [ %39, %43 ], [ %39, %47 ], [ %39, %50 ], [ %39, %52 ], [ %39, %42 ], [ %72, %69 ]
  %97 = getelementptr inbounds nuw i8, ptr %34, i32 1
  %98 = load i8, ptr %34, align 1, !tbaa !10
  %99 = icmp eq i8 %98, 0
  br i1 %99, label %100, label %33, !llvm.loop !15

100:                                              ; preds = %68, %79, %92
  %101 = phi ptr [ %97, %92 ], [ %34, %79 ], [ %34, %68 ]
  %102 = phi i32 [ 0, %92 ], [ %40, %79 ], [ %40, %68 ]
  %103 = phi i16 [ %93, %92 ], [ %36, %79 ], [ %36, %68 ]
  %104 = phi ptr [ %94, %92 ], [ %37, %79 ], [ %37, %68 ]
  %105 = phi i32 [ %95, %92 ], [ %38, %79 ], [ %38, %68 ]
  %106 = phi i32 [ %96, %92 ], [ %39, %79 ], [ %39, %68 ]
  %107 = icmp slt i32 %106, 0
  %108 = and i16 %103, -65
  %109 = select i1 %107, i16 %108, i16 %103
  %110 = call i32 @llvm.smax.i32(i32 %106, i32 0)
  %111 = icmp slt i32 %105, 0
  %112 = or i16 %109, 8
  %113 = select i1 %111, i16 %112, i16 %109
  %114 = call i32 @llvm.abs.i32(i32 %105, i1 true)
  %115 = or i32 %102, 32
  %116 = add nsw i32 %115, -101
  %117 = icmp ult i32 %116, 3
  br i1 %117, label %118, label %122

118:                                              ; preds = %100
  %119 = getelementptr inbounds nuw i8, ptr %104, i32 7
  %120 = call align 8 ptr @llvm.ptrmask.p0.i32(ptr nonnull %119, i32 -8)
  %121 = getelementptr inbounds nuw i8, ptr %120, i32 8
  br label %136

122:                                              ; preds = %100
  switch i32 %102, label %219 [
    i32 99, label %123
    i32 115, label %127
    i32 100, label %167
    i32 105, label %167
    i32 117, label %215
    i32 111, label %234
    i32 112, label %217
  ]

123:                                              ; preds = %122
  %124 = getelementptr inbounds nuw i8, ptr %104, i32 4
  %125 = load i32, ptr %104, align 4, !tbaa !13
  %126 = trunc i32 %125 to i8
  store i8 %126, ptr %4, align 1, !tbaa !10
  br label %136

127:                                              ; preds = %122
  %128 = getelementptr inbounds nuw i8, ptr %104, i32 4
  %129 = load ptr, ptr %104, align 4, !tbaa !17
  %130 = icmp eq ptr %129, null
  %131 = select i1 %130, ptr @.str.1, ptr %129
  %132 = and i16 %113, 64
  %133 = icmp eq i16 %132, 0
  %134 = select i1 %133, i32 -1, i32 %110
  %135 = call i32 @strnlen(ptr noundef nonnull %131, i32 noundef %134) #7
  br label %136

136:                                              ; preds = %127, %123, %118
  %137 = phi ptr [ @.str, %118 ], [ %4, %123 ], [ %131, %127 ]
  %138 = phi i32 [ 7, %118 ], [ 1, %123 ], [ %135, %127 ]
  %139 = phi ptr [ %121, %118 ], [ %124, %123 ], [ %128, %127 ]
  %140 = and i16 %113, 8
  %141 = icmp eq i16 %140, 0
  br i1 %141, label %142, label %152

142:                                              ; preds = %136, %149
  %143 = phi i32 [ %150, %149 ], [ %21, %136 ]
  %144 = phi i32 [ %151, %149 ], [ %114, %136 ]
  %145 = icmp ugt i32 %144, %138
  br i1 %145, label %146, label %152

146:                                              ; preds = %142
  %147 = call i32 %6(i8 noundef signext 32, ptr noundef nonnull %0) #7
  %148 = icmp slt i32 %147, 0
  br i1 %148, label %398, label %149

149:                                              ; preds = %146
  %150 = add nsw i32 %143, 1
  %151 = add nsw i32 %144, -1
  br label %142, !llvm.loop !19

152:                                              ; preds = %142, %136
  %153 = phi i32 [ %21, %136 ], [ %143, %142 ]
  %154 = phi i32 [ %114, %136 ], [ %144, %142 ]
  %155 = sub i32 %154, %138
  %156 = add i32 %138, %153
  br label %157

157:                                              ; preds = %161, %152
  %158 = phi ptr [ %137, %152 ], [ %163, %161 ]
  %159 = phi i32 [ %138, %152 ], [ %162, %161 ]
  %160 = icmp eq i32 %159, 0
  br i1 %160, label %385, label %161

161:                                              ; preds = %157
  %162 = add i32 %159, -1
  %163 = getelementptr inbounds nuw i8, ptr %158, i32 1
  %164 = load i8, ptr %158, align 1, !tbaa !10
  %165 = call i32 %6(i8 noundef signext %164, ptr noundef nonnull %0) #7
  %166 = icmp slt i32 %165, 0
  br i1 %166, label %398, label %157, !llvm.loop !20

167:                                              ; preds = %122, %122
  %168 = zext i16 %113 to i32
  %169 = and i32 %168, 128
  %170 = icmp eq i32 %169, 0
  br i1 %170, label %183, label %171

171:                                              ; preds = %167
  %172 = and i32 %168, 512
  %173 = icmp eq i32 %172, 0
  br i1 %173, label %180, label %174

174:                                              ; preds = %171
  %175 = getelementptr inbounds nuw i8, ptr %104, i32 7
  %176 = call align 8 ptr @llvm.ptrmask.p0.i32(ptr nonnull %175, i32 -8)
  %177 = getelementptr inbounds nuw i8, ptr %176, i32 8
  %178 = load i64, ptr %176, align 8, !tbaa !21
  %179 = trunc i64 %178 to i32
  br label %197

180:                                              ; preds = %171
  %181 = getelementptr inbounds nuw i8, ptr %104, i32 4
  %182 = load i32, ptr %104, align 4, !tbaa !23
  br label %197

183:                                              ; preds = %167
  %184 = getelementptr inbounds nuw i8, ptr %104, i32 4
  %185 = load i32, ptr %104, align 4, !tbaa !13
  %186 = and i32 %168, 256
  %187 = icmp eq i32 %186, 0
  br i1 %187, label %197, label %188

188:                                              ; preds = %183
  %189 = and i32 %168, 512
  %190 = icmp eq i32 %189, 0
  br i1 %190, label %194, label %191

191:                                              ; preds = %188
  %192 = shl i32 %185, 24
  %193 = ashr exact i32 %192, 24
  br label %197

194:                                              ; preds = %188
  %195 = shl i32 %185, 16
  %196 = ashr exact i32 %195, 16
  br label %197

197:                                              ; preds = %183, %194, %191, %174, %180
  %198 = phi ptr [ %177, %174 ], [ %181, %180 ], [ %184, %191 ], [ %184, %194 ], [ %184, %183 ]
  %199 = phi i32 [ %179, %174 ], [ %182, %180 ], [ %193, %191 ], [ %196, %194 ], [ %185, %183 ]
  %200 = icmp slt i32 %199, 0
  %201 = or i16 %113, 1024
  %202 = select i1 %200, i16 %201, i16 %113
  %203 = call i32 @llvm.abs.i32(i32 %199, i1 false)
  %204 = and i16 %202, -17
  %205 = icmp eq i32 %199, 0
  br i1 %205, label %206, label %211

206:                                              ; preds = %197
  %207 = and i16 %113, 64
  %208 = icmp ne i16 %207, 0
  %209 = icmp slt i32 %106, 1
  %210 = and i1 %209, %208
  br i1 %210, label %281, label %211

211:                                              ; preds = %206, %197
  %212 = call fastcc ptr @__ultoa_invert(i32 noundef %203, ptr noundef %4, i32 noundef 10) #8
  %213 = ptrtoint ptr %212 to i32
  %214 = sub i32 %213, %14
  br label %281

215:                                              ; preds = %122
  %216 = and i16 %113, -17
  br label %234

217:                                              ; preds = %122
  %218 = or i16 %113, 16
  br label %234

219:                                              ; preds = %122
  %220 = icmp eq i32 %115, 120
  br i1 %220, label %221, label %223

221:                                              ; preds = %219
  %222 = sub nuw nsw i32 136, %102
  br label %234

223:                                              ; preds = %219
  %224 = call i32 %6(i8 noundef signext 37, ptr noundef nonnull %0) #7
  %225 = icmp slt i32 %224, 0
  br i1 %225, label %398, label %226

226:                                              ; preds = %223
  %227 = add nsw i32 %21, 2
  %228 = trunc nsw i32 %102 to i8
  %229 = call i32 %6(i8 noundef signext %228, ptr noundef nonnull %0) #7
  %230 = icmp slt i32 %229, 0
  br i1 %230, label %398, label %231

231:                                              ; preds = %389, %226
  %232 = phi i32 [ %227, %226 ], [ %390, %389 ]
  %233 = phi ptr [ %104, %226 ], [ %387, %389 ]
  br label %15, !llvm.loop !25

234:                                              ; preds = %122, %221, %217, %215
  %235 = phi i32 [ 117, %215 ], [ 120, %217 ], [ %102, %221 ], [ 0, %122 ]
  %236 = phi i16 [ %216, %215 ], [ %218, %217 ], [ %113, %221 ], [ %113, %122 ]
  %237 = phi i32 [ 10, %215 ], [ 16, %217 ], [ %222, %221 ], [ 8, %122 ]
  %238 = and i16 %236, -7
  %239 = zext i16 %238 to i32
  %240 = and i32 %239, 128
  %241 = icmp eq i32 %240, 0
  br i1 %241, label %254, label %242

242:                                              ; preds = %234
  %243 = and i32 %239, 512
  %244 = icmp eq i32 %243, 0
  br i1 %244, label %251, label %245

245:                                              ; preds = %242
  %246 = getelementptr inbounds nuw i8, ptr %104, i32 7
  %247 = call align 8 ptr @llvm.ptrmask.p0.i32(ptr nonnull %246, i32 -8)
  %248 = getelementptr inbounds nuw i8, ptr %247, i32 8
  %249 = load i64, ptr %247, align 8, !tbaa !21
  %250 = trunc i64 %249 to i32
  br label %266

251:                                              ; preds = %242
  %252 = getelementptr inbounds nuw i8, ptr %104, i32 4
  %253 = load i32, ptr %104, align 4, !tbaa !23
  br label %266

254:                                              ; preds = %234
  %255 = getelementptr inbounds nuw i8, ptr %104, i32 4
  %256 = load i32, ptr %104, align 4, !tbaa !13
  %257 = and i32 %239, 256
  %258 = icmp eq i32 %257, 0
  br i1 %258, label %266, label %259

259:                                              ; preds = %254
  %260 = and i32 %239, 512
  %261 = icmp eq i32 %260, 0
  br i1 %261, label %264, label %262

262:                                              ; preds = %259
  %263 = and i32 %256, 255
  br label %266

264:                                              ; preds = %259
  %265 = and i32 %256, 65535
  br label %266

266:                                              ; preds = %254, %264, %262, %245, %251
  %267 = phi ptr [ %248, %245 ], [ %252, %251 ], [ %255, %262 ], [ %255, %264 ], [ %255, %254 ]
  %268 = phi i32 [ %250, %245 ], [ %253, %251 ], [ %263, %262 ], [ %265, %264 ], [ %256, %254 ]
  %269 = icmp eq i32 %268, 0
  %270 = and i16 %236, -23
  %271 = select i1 %269, i16 %270, i16 %238
  br i1 %269, label %272, label %277

272:                                              ; preds = %266
  %273 = and i16 %236, 64
  %274 = icmp ne i16 %273, 0
  %275 = icmp slt i32 %106, 1
  %276 = and i1 %275, %274
  br i1 %276, label %281, label %277

277:                                              ; preds = %272, %266
  %278 = call fastcc ptr @__ultoa_invert(i32 noundef %268, ptr noundef %4, i32 noundef %237) #8
  %279 = ptrtoint ptr %278 to i32
  %280 = sub i32 %279, %14
  br label %281

281:                                              ; preds = %277, %272, %211, %206
  %282 = phi i32 [ %102, %206 ], [ %102, %211 ], [ %235, %272 ], [ %235, %277 ]
  %283 = phi i16 [ %204, %206 ], [ %204, %211 ], [ %270, %272 ], [ %271, %277 ]
  %284 = phi ptr [ %198, %206 ], [ %198, %211 ], [ %267, %272 ], [ %267, %277 ]
  %285 = phi i32 [ 0, %206 ], [ %214, %211 ], [ 0, %272 ], [ %280, %277 ]
  %286 = and i16 %283, 64
  %287 = icmp eq i16 %286, 0
  br i1 %287, label %295, label %288

288:                                              ; preds = %281
  %289 = and i16 %283, -2
  %290 = icmp slt i32 %285, %110
  br i1 %290, label %291, label %295

291:                                              ; preds = %288
  %292 = icmp eq i32 %282, 0
  %293 = and i16 %283, -18
  %294 = select i1 %292, i16 %293, i16 %289
  br label %295

295:                                              ; preds = %291, %288, %281
  %296 = phi i16 [ %289, %288 ], [ %283, %281 ], [ %294, %291 ]
  %297 = phi i32 [ %285, %288 ], [ %285, %281 ], [ %110, %291 ]
  %298 = zext i16 %296 to i32
  %299 = and i32 %298, 16
  %300 = icmp eq i32 %299, 0
  br i1 %300, label %304, label %301

301:                                              ; preds = %295
  %302 = icmp eq i32 %282, 0
  %303 = select i1 %302, i32 1, i32 2
  br label %308

304:                                              ; preds = %295
  %305 = and i32 %298, 1030
  %306 = icmp ne i32 %305, 0
  %307 = zext i1 %306 to i32
  br label %308

308:                                              ; preds = %304, %301
  %309 = phi i32 [ %303, %301 ], [ %307, %304 ]
  %310 = add nsw i32 %309, %297
  %311 = and i32 %298, 8
  %312 = icmp eq i32 %311, 0
  br i1 %312, label %313, label %334

313:                                              ; preds = %308
  %314 = and i32 %298, 1
  %315 = icmp eq i32 %314, 0
  br i1 %315, label %321, label %316

316:                                              ; preds = %313
  %317 = icmp slt i32 %310, %114
  br i1 %317, label %318, label %321

318:                                              ; preds = %316
  %319 = add i32 %285, %114
  %320 = sub i32 %319, %310
  br label %321

321:                                              ; preds = %316, %318, %313
  %322 = phi i32 [ %320, %318 ], [ %285, %316 ], [ %110, %313 ]
  %323 = phi i32 [ %114, %318 ], [ %310, %316 ], [ %310, %313 ]
  br label %324

324:                                              ; preds = %331, %321
  %325 = phi i32 [ %21, %321 ], [ %332, %331 ]
  %326 = phi i32 [ %323, %321 ], [ %333, %331 ]
  %327 = icmp slt i32 %326, %114
  br i1 %327, label %328, label %334

328:                                              ; preds = %324
  %329 = call i32 %6(i8 noundef signext 32, ptr noundef nonnull %0) #7
  %330 = icmp slt i32 %329, 0
  br i1 %330, label %398, label %331

331:                                              ; preds = %328
  %332 = add nsw i32 %325, 1
  %333 = add nsw i32 %326, 1
  br label %324, !llvm.loop !26

334:                                              ; preds = %324, %308
  %335 = phi i32 [ %21, %308 ], [ %325, %324 ]
  %336 = phi i32 [ %110, %308 ], [ %322, %324 ]
  %337 = phi i32 [ %310, %308 ], [ %326, %324 ]
  %338 = sub nsw i32 %114, %337
  br i1 %300, label %350, label %339

339:                                              ; preds = %334
  %340 = call i32 %6(i8 noundef signext 48, ptr noundef nonnull %0) #7
  %341 = icmp slt i32 %340, 0
  br i1 %341, label %398, label %342

342:                                              ; preds = %339
  %343 = add nsw i32 %335, 1
  %344 = icmp eq i32 %282, 0
  br i1 %344, label %363, label %345

345:                                              ; preds = %342
  %346 = add nsw i32 %335, 2
  %347 = trunc nsw i32 %282 to i8
  %348 = call i32 %6(i8 noundef signext %347, ptr noundef nonnull %0) #7
  %349 = icmp slt i32 %348, 0
  br i1 %349, label %398, label %363

350:                                              ; preds = %334
  %351 = and i32 %298, 1030
  %352 = icmp eq i32 %351, 0
  br i1 %352, label %363, label %353

353:                                              ; preds = %350
  %354 = and i32 %298, 2
  %355 = icmp eq i32 %354, 0
  %356 = select i1 %355, i8 32, i8 43
  %357 = and i32 %298, 1024
  %358 = icmp eq i32 %357, 0
  %359 = select i1 %358, i8 %356, i8 45
  %360 = add nsw i32 %335, 1
  %361 = call i32 %6(i8 noundef signext %359, ptr noundef nonnull %0) #7
  %362 = icmp sgt i32 %361, -1
  br i1 %362, label %363, label %398

363:                                              ; preds = %350, %353, %342, %345
  %364 = phi i32 [ %346, %345 ], [ %343, %342 ], [ %360, %353 ], [ %335, %350 ]
  %365 = add i32 %364, %285
  br label %366

366:                                              ; preds = %373, %363
  %367 = phi i32 [ %375, %373 ], [ %365, %363 ]
  %368 = phi i32 [ %374, %373 ], [ %336, %363 ]
  %369 = icmp sgt i32 %368, %285
  br i1 %369, label %370, label %376

370:                                              ; preds = %366
  %371 = call i32 %6(i8 noundef signext 48, ptr noundef nonnull %0) #7
  %372 = icmp slt i32 %371, 0
  br i1 %372, label %398, label %373

373:                                              ; preds = %370
  %374 = add nsw i32 %368, -1
  %375 = add i32 %367, 1
  br label %366, !llvm.loop !27

376:                                              ; preds = %366, %379
  %377 = phi i32 [ %380, %379 ], [ %285, %366 ]
  %378 = icmp eq i32 %377, 0
  br i1 %378, label %385, label %379

379:                                              ; preds = %376
  %380 = add nsw i32 %377, -1
  %381 = getelementptr inbounds [11 x i8], ptr %4, i32 0, i32 %380
  %382 = load i8, ptr %381, align 1, !tbaa !10
  %383 = call i32 %6(i8 noundef signext %382, ptr noundef nonnull %0) #7
  %384 = icmp slt i32 %383, 0
  br i1 %384, label %398, label %376, !llvm.loop !28

385:                                              ; preds = %376, %157
  %386 = phi i32 [ %156, %157 ], [ %367, %376 ]
  %387 = phi ptr [ %139, %157 ], [ %284, %376 ]
  %388 = phi i32 [ %155, %157 ], [ %338, %376 ]
  br label %389

389:                                              ; preds = %393, %385
  %390 = phi i32 [ %386, %385 ], [ %395, %393 ]
  %391 = phi i32 [ %388, %385 ], [ %394, %393 ]
  %392 = icmp sgt i32 %391, 0
  br i1 %392, label %393, label %231, !llvm.loop !25

393:                                              ; preds = %389
  %394 = add nsw i32 %391, -1
  %395 = add nsw i32 %390, 1
  %396 = call i32 %6(i8 noundef signext 32, ptr noundef nonnull %0) #7
  %397 = icmp slt i32 %396, 0
  br i1 %397, label %398, label %389, !llvm.loop !29

398:                                              ; preds = %353, %226, %345, %339, %223, %28, %328, %370, %379, %146, %161, %393
  %399 = load i8, ptr %7, align 2, !tbaa !9
  %400 = or i8 %399, 4
  store i8 %400, ptr %7, align 2, !tbaa !9
  br label %401

401:                                              ; preds = %19, %75, %398, %3
  %402 = phi i32 [ -1, %3 ], [ -1, %398 ], [ %21, %75 ], [ %21, %19 ]
  call void @llvm.lifetime.end.p0(i64 11, ptr nonnull %4) #6
  ret i32 %402
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare ptr @llvm.ptrmask.p0.i32(ptr, i32) #2

; Function Attrs: minsize optsize
declare dso_local i32 @strnlen(ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: write)
define internal fastcc nonnull ptr @__ultoa_invert(i32 noundef %0, ptr noundef nonnull writeonly captures(ret: address, provenance) %1, i32 noundef range(i32 8, 0) %2) unnamed_addr #4 {
  %4 = and i32 %2, 31
  %5 = shl i32 %2, 24
  %6 = sub i32 922746880, %5
  %7 = lshr exact i32 %6, 24
  br label %8

8:                                                ; preds = %8, %3
  %9 = phi ptr [ %1, %3 ], [ %20, %8 ]
  %10 = phi i32 [ %0, %3 ], [ %12, %8 ]
  %11 = freeze i32 %10
  %12 = udiv i32 %11, %4
  %13 = mul i32 %12, %4
  %14 = sub i32 %11, %13
  %15 = icmp samesign ugt i32 %14, 9
  %16 = select i1 %15, i32 %7, i32 0
  %17 = add nuw nsw i32 %16, %14
  %18 = trunc i32 %17 to i8
  %19 = add i8 %18, 48
  %20 = getelementptr inbounds nuw i8, ptr %9, i32 1
  store i8 %19, ptr %9, align 1, !tbaa !10
  %21 = icmp ugt i32 %4, %10
  br i1 %21, label %22, label %8, !llvm.loop !30

22:                                               ; preds = %8
  ret ptr %20
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.abs.i32(i32, i1 immarg) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { nounwind }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !8, i64 4}
!4 = !{!"__file", !5, i64 0, !6, i64 2, !8, i64 4, !8, i64 8, !8, i64 12}
!5 = !{!"short", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"any pointer", !6, i64 0}
!9 = !{!4, !6, i64 2}
!10 = !{!6, !6, i64 0}
!11 = distinct !{!11, !12}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = !{!14, !14, i64 0}
!14 = !{!"int", !6, i64 0}
!15 = distinct !{!15, !16, !12}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!18, !18, i64 0}
!18 = !{!"p1 omnipotent char", !8, i64 0}
!19 = distinct !{!19, !16, !12}
!20 = distinct !{!20, !16, !12}
!21 = !{!22, !22, i64 0}
!22 = !{!"long long", !6, i64 0}
!23 = !{!24, !24, i64 0}
!24 = !{!"long", !6, i64 0}
!25 = distinct !{!25, !12}
!26 = distinct !{!26, !16, !12}
!27 = distinct !{!27, !16, !12}
!28 = distinct !{!28, !16, !12}
!29 = distinct !{!29, !16, !12}
!30 = distinct !{!30, !16, !12}
