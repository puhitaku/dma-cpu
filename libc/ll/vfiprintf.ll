; ModuleID = 'vfiprintf.c'
source_filename = "vfiprintf.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%union.anon = type { [11 x i8] }

@.str = private unnamed_addr constant [8 x i8] c"*float*\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"(null)\00", align 1

@__i_vfprintf = dso_local alias i32 (ptr, ptr, [1 x i32]), ptr @vfprintf

; Function Attrs: nounwind
define dso_local i32 @vfprintf(ptr noundef nonnull %0, ptr noundef readonly captures(none) %1, [1 x i32] %2) #0 {
  %4 = alloca %union.anon, align 1
  call void @llvm.lifetime.start.p0(i64 11, ptr nonnull %4) #6
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %6 = load ptr, ptr %5, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 2
  %8 = load i8, ptr %7, align 2, !tbaa !9
  %9 = and i8 %8, 2
  %10 = icmp eq i8 %9, 0
  br i1 %10, label %441, label %11

11:                                               ; preds = %3
  %12 = extractvalue [1 x i32] %2, 0
  %13 = inttoptr i32 %12 to ptr
  %14 = ptrtoint ptr %4 to i32
  br label %15

15:                                               ; preds = %437, %11
  %16 = phi ptr [ %1, %11 ], [ %432, %437 ]
  %17 = phi i32 [ 0, %11 ], [ %433, %437 ]
  %18 = phi ptr [ %13, %11 ], [ %434, %437 ]
  %19 = phi i32 [ undef, %11 ], [ %436, %437 ]
  br label %20

20:                                               ; preds = %29, %15
  %21 = phi ptr [ %16, %15 ], [ %30, %29 ]
  %22 = phi i32 [ %17, %15 ], [ %32, %29 ]
  %23 = getelementptr inbounds nuw i8, ptr %21, i32 1
  %24 = load i8, ptr %21, align 1, !tbaa !10
  switch i8 %24, label %29 [
    i8 0, label %441
    i8 37, label %25
  ]

25:                                               ; preds = %20
  %26 = getelementptr inbounds nuw i8, ptr %21, i32 2
  %27 = load i8, ptr %23, align 1, !tbaa !10
  %28 = icmp eq i8 %27, 37
  br i1 %28, label %29, label %35

29:                                               ; preds = %20, %25
  %30 = phi ptr [ %26, %25 ], [ %23, %20 ]
  %31 = phi i8 [ 37, %25 ], [ %24, %20 ]
  %32 = add nsw i32 %22, 1
  %33 = call i32 %6(i8 noundef signext %31, ptr noundef nonnull %0) #7
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %438, label %20, !llvm.loop !11

35:                                               ; preds = %25, %94
  %36 = phi ptr [ %99, %94 ], [ %26, %25 ]
  %37 = phi i8 [ %100, %94 ], [ %27, %25 ]
  %38 = phi i16 [ %95, %94 ], [ 0, %25 ]
  %39 = phi ptr [ %96, %94 ], [ %18, %25 ]
  %40 = phi i32 [ %97, %94 ], [ 0, %25 ]
  %41 = phi i32 [ %98, %94 ], [ 0, %25 ]
  %42 = sext i8 %37 to i32
  %43 = icmp ult i16 %38, 32
  br i1 %43, label %44, label %56

44:                                               ; preds = %35
  switch i8 %37, label %56 [
    i8 48, label %45
    i8 43, label %47
    i8 32, label %49
    i8 45, label %52
    i8 35, label %54
    i8 39, label %94
  ]

45:                                               ; preds = %44
  %46 = or i16 %38, 1
  br label %94

47:                                               ; preds = %44
  %48 = or i16 %38, 2
  br label %49

49:                                               ; preds = %44, %47
  %50 = phi i16 [ %48, %47 ], [ %38, %44 ]
  %51 = or i16 %50, 4
  br label %94

52:                                               ; preds = %44
  %53 = or i16 %38, 8
  br label %94

54:                                               ; preds = %44
  %55 = or i16 %38, 16
  br label %94

56:                                               ; preds = %44, %35
  %57 = icmp ult i16 %38, 128
  br i1 %57, label %58, label %81

58:                                               ; preds = %56
  %59 = add nsw i32 %42, -48
  %60 = icmp ult i32 %59, 10
  br i1 %60, label %61, label %70

61:                                               ; preds = %58
  %62 = icmp ult i16 %38, 64
  br i1 %62, label %66, label %63

63:                                               ; preds = %61
  %64 = mul nsw i32 %41, 10
  %65 = add i32 %64, %59
  br label %94

66:                                               ; preds = %61
  %67 = mul nsw i32 %40, 10
  %68 = add i32 %67, %59
  %69 = or i16 %38, 32
  br label %94

70:                                               ; preds = %58
  switch i8 %37, label %102 [
    i8 42, label %71
    i8 46, label %77
    i8 108, label %82
    i8 104, label %87
    i8 76, label %92
  ]

71:                                               ; preds = %70
  %72 = icmp ult i16 %38, 64
  %73 = getelementptr inbounds nuw i8, ptr %39, i32 4
  %74 = load i32, ptr %39, align 4, !tbaa !13
  br i1 %72, label %75, label %94

75:                                               ; preds = %71
  %76 = or i16 %38, 32
  br label %94

77:                                               ; preds = %70
  %78 = icmp ult i16 %38, 64
  br i1 %78, label %79, label %431

79:                                               ; preds = %77
  %80 = or disjoint i16 %38, 64
  br label %94

81:                                               ; preds = %56
  switch i8 %37, label %102 [
    i8 108, label %82
    i8 104, label %87
    i8 76, label %92
  ]

82:                                               ; preds = %70, %81
  %83 = shl i16 %38, 2
  %84 = and i16 %83, 512
  %85 = or i16 %38, %84
  %86 = or i16 %85, 128
  br label %94

87:                                               ; preds = %70, %81
  %88 = shl i16 %38, 1
  %89 = and i16 %88, 512
  %90 = or i16 %38, %89
  %91 = or i16 %90, 256
  br label %94

92:                                               ; preds = %70, %81
  %93 = or i16 %38, 640
  br label %94

94:                                               ; preds = %71, %75, %63, %66, %44, %92, %87, %82, %79, %54, %52, %49, %45
  %95 = phi i16 [ %38, %63 ], [ %69, %66 ], [ %76, %75 ], [ %80, %79 ], [ %86, %82 ], [ %91, %87 ], [ %93, %92 ], [ %46, %45 ], [ %51, %49 ], [ %53, %52 ], [ %55, %54 ], [ %38, %44 ], [ %38, %71 ]
  %96 = phi ptr [ %39, %63 ], [ %39, %66 ], [ %73, %75 ], [ %39, %79 ], [ %39, %82 ], [ %39, %87 ], [ %39, %92 ], [ %39, %45 ], [ %39, %49 ], [ %39, %52 ], [ %39, %54 ], [ %39, %44 ], [ %73, %71 ]
  %97 = phi i32 [ %40, %63 ], [ %68, %66 ], [ %74, %75 ], [ %40, %79 ], [ %40, %82 ], [ %40, %87 ], [ %40, %92 ], [ %40, %45 ], [ %40, %49 ], [ %40, %52 ], [ %40, %54 ], [ %40, %44 ], [ %40, %71 ]
  %98 = phi i32 [ %65, %63 ], [ %41, %66 ], [ %41, %75 ], [ %41, %79 ], [ %41, %82 ], [ %41, %87 ], [ %41, %92 ], [ %41, %45 ], [ %41, %49 ], [ %41, %52 ], [ %41, %54 ], [ %41, %44 ], [ %74, %71 ]
  %99 = getelementptr inbounds nuw i8, ptr %36, i32 1
  %100 = load i8, ptr %36, align 1, !tbaa !10
  %101 = icmp eq i8 %100, 0
  br i1 %101, label %102, label %35, !llvm.loop !15

102:                                              ; preds = %70, %81, %94
  %103 = phi ptr [ %99, %94 ], [ %36, %81 ], [ %36, %70 ]
  %104 = phi i32 [ 0, %94 ], [ %42, %81 ], [ %42, %70 ]
  %105 = phi i16 [ %95, %94 ], [ %38, %81 ], [ %38, %70 ]
  %106 = phi ptr [ %96, %94 ], [ %39, %81 ], [ %39, %70 ]
  %107 = phi i32 [ %97, %94 ], [ %40, %81 ], [ %40, %70 ]
  %108 = phi i32 [ %98, %94 ], [ %41, %81 ], [ %41, %70 ]
  %109 = icmp slt i32 %108, 0
  %110 = and i16 %105, -65
  %111 = select i1 %109, i16 %110, i16 %105
  %112 = call i32 @llvm.smax.i32(i32 %108, i32 0)
  %113 = icmp slt i32 %107, 0
  %114 = or i16 %111, 8
  %115 = select i1 %113, i16 %114, i16 %111
  %116 = call i32 @llvm.abs.i32(i32 %107, i1 true)
  %117 = or i32 %104, 32
  %118 = add nsw i32 %117, -101
  %119 = icmp ult i32 %118, 3
  br i1 %119, label %120, label %124

120:                                              ; preds = %102
  %121 = getelementptr inbounds nuw i8, ptr %106, i32 7
  %122 = call align 8 ptr @llvm.ptrmask.p0.i32(ptr nonnull %121, i32 -8)
  %123 = getelementptr inbounds nuw i8, ptr %122, i32 8
  br label %138

124:                                              ; preds = %102
  switch i32 %104, label %224 [
    i32 99, label %125
    i32 115, label %129
    i32 105, label %172
    i32 100, label %172
    i32 117, label %220
    i32 111, label %239
    i32 112, label %222
  ]

125:                                              ; preds = %124
  %126 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %127 = load i32, ptr %106, align 4, !tbaa !13
  %128 = trunc i32 %127 to i8
  store i8 %128, ptr %4, align 1, !tbaa !10
  br label %138

129:                                              ; preds = %124
  %130 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %131 = load ptr, ptr %106, align 4, !tbaa !17
  %132 = icmp eq ptr %131, null
  %133 = select i1 %132, ptr @.str.1, ptr %131
  %134 = and i16 %115, 64
  %135 = icmp eq i16 %134, 0
  %136 = select i1 %135, i32 -1, i32 %112
  %137 = call i32 @strnlen(ptr noundef nonnull %133, i32 noundef %136) #7
  br label %138

138:                                              ; preds = %129, %125, %120
  %139 = phi ptr [ @.str, %120 ], [ %4, %125 ], [ %133, %129 ]
  %140 = phi i32 [ 7, %120 ], [ 1, %125 ], [ %137, %129 ]
  %141 = phi ptr [ %123, %120 ], [ %126, %125 ], [ %130, %129 ]
  %142 = and i16 %115, 8
  %143 = icmp eq i16 %142, 0
  %144 = icmp ugt i32 %116, %140
  %145 = select i1 %143, i1 %144, i1 false
  br i1 %145, label %146, label %155

146:                                              ; preds = %138, %152
  %147 = phi i32 [ %153, %152 ], [ %116, %138 ]
  %148 = phi i32 [ %149, %152 ], [ %22, %138 ]
  %149 = add nsw i32 %148, 1
  %150 = call i32 %6(i8 noundef signext 32, ptr noundef nonnull %0) #7
  %151 = icmp slt i32 %150, 0
  br i1 %151, label %431, label %152

152:                                              ; preds = %146
  %153 = add nsw i32 %147, -1
  %154 = icmp ugt i32 %153, %140
  br i1 %154, label %146, label %155, !llvm.loop !19

155:                                              ; preds = %152, %138
  %156 = phi i32 [ %22, %138 ], [ %149, %152 ]
  %157 = phi i32 [ %116, %138 ], [ %140, %152 ]
  %158 = sub i32 %157, %140
  %159 = add i32 %140, %156
  br label %160

160:                                              ; preds = %165, %155
  %161 = phi ptr [ %139, %155 ], [ %168, %165 ]
  %162 = phi i32 [ %140, %155 ], [ %166, %165 ]
  %163 = phi i32 [ %156, %155 ], [ %167, %165 ]
  %164 = icmp eq i32 %162, 0
  br i1 %164, label %417, label %165

165:                                              ; preds = %160
  %166 = add i32 %162, -1
  %167 = add nsw i32 %163, 1
  %168 = getelementptr inbounds nuw i8, ptr %161, i32 1
  %169 = load i8, ptr %161, align 1, !tbaa !10
  %170 = call i32 %6(i8 noundef signext %169, ptr noundef nonnull %0) #7
  %171 = icmp slt i32 %170, 0
  br i1 %171, label %431, label %160, !llvm.loop !20

172:                                              ; preds = %124, %124
  %173 = zext i16 %115 to i32
  %174 = and i32 %173, 128
  %175 = icmp eq i32 %174, 0
  br i1 %175, label %188, label %176

176:                                              ; preds = %172
  %177 = and i32 %173, 512
  %178 = icmp eq i32 %177, 0
  br i1 %178, label %185, label %179

179:                                              ; preds = %176
  %180 = getelementptr inbounds nuw i8, ptr %106, i32 7
  %181 = call align 8 ptr @llvm.ptrmask.p0.i32(ptr nonnull %180, i32 -8)
  %182 = getelementptr inbounds nuw i8, ptr %181, i32 8
  %183 = load i64, ptr %181, align 8, !tbaa !21
  %184 = trunc i64 %183 to i32
  br label %202

185:                                              ; preds = %176
  %186 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %187 = load i32, ptr %106, align 4, !tbaa !23
  br label %202

188:                                              ; preds = %172
  %189 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %190 = load i32, ptr %106, align 4, !tbaa !13
  %191 = and i32 %173, 256
  %192 = icmp eq i32 %191, 0
  br i1 %192, label %202, label %193

193:                                              ; preds = %188
  %194 = and i32 %173, 512
  %195 = icmp eq i32 %194, 0
  br i1 %195, label %199, label %196

196:                                              ; preds = %193
  %197 = shl i32 %190, 24
  %198 = ashr exact i32 %197, 24
  br label %202

199:                                              ; preds = %193
  %200 = shl i32 %190, 16
  %201 = ashr exact i32 %200, 16
  br label %202

202:                                              ; preds = %188, %199, %196, %179, %185
  %203 = phi ptr [ %182, %179 ], [ %186, %185 ], [ %189, %196 ], [ %189, %199 ], [ %189, %188 ]
  %204 = phi i32 [ %184, %179 ], [ %187, %185 ], [ %198, %196 ], [ %201, %199 ], [ %190, %188 ]
  %205 = icmp slt i32 %204, 0
  %206 = or i16 %115, 1024
  %207 = select i1 %205, i16 %206, i16 %115
  %208 = call i32 @llvm.abs.i32(i32 %204, i1 false)
  %209 = and i16 %207, -17
  %210 = icmp eq i32 %204, 0
  br i1 %210, label %211, label %216

211:                                              ; preds = %202
  %212 = and i16 %207, 64
  %213 = icmp ne i16 %212, 0
  %214 = icmp slt i32 %108, 1
  %215 = and i1 %214, %213
  br i1 %215, label %294, label %216

216:                                              ; preds = %211, %202
  %217 = call fastcc ptr @__ultoa_invert(i32 noundef %208, ptr noundef %4, i32 noundef 10) #8
  %218 = ptrtoint ptr %217 to i32
  %219 = sub i32 %218, %14
  br label %294

220:                                              ; preds = %124
  %221 = and i16 %115, -17
  br label %239

222:                                              ; preds = %124
  %223 = or i16 %115, 16
  br label %239

224:                                              ; preds = %124
  %225 = icmp eq i32 %117, 120
  br i1 %225, label %226, label %228

226:                                              ; preds = %224
  %227 = sub nuw nsw i32 136, %104
  br label %239

228:                                              ; preds = %224
  %229 = call i32 %6(i8 noundef signext 37, ptr noundef nonnull %0) #7
  %230 = icmp slt i32 %229, 0
  br i1 %230, label %231, label %233

231:                                              ; preds = %228
  %232 = add nsw i32 %22, 1
  br label %286

233:                                              ; preds = %228
  %234 = add nsw i32 %22, 2
  %235 = trunc nsw i32 %104 to i8
  %236 = call i32 %6(i8 noundef signext %235, ptr noundef nonnull %0) #7
  %237 = icmp slt i32 %236, 0
  %238 = select i1 %237, i32 11, i32 5
  br label %286

239:                                              ; preds = %124, %226, %222, %220
  %240 = phi i32 [ 117, %220 ], [ 120, %222 ], [ %104, %226 ], [ 0, %124 ]
  %241 = phi i16 [ %221, %220 ], [ %223, %222 ], [ %115, %226 ], [ %115, %124 ]
  %242 = phi i32 [ 10, %220 ], [ 16, %222 ], [ %227, %226 ], [ 8, %124 ]
  %243 = and i16 %241, -7
  %244 = zext i16 %243 to i32
  %245 = and i32 %244, 128
  %246 = icmp eq i32 %245, 0
  br i1 %246, label %259, label %247

247:                                              ; preds = %239
  %248 = and i32 %244, 512
  %249 = icmp eq i32 %248, 0
  br i1 %249, label %256, label %250

250:                                              ; preds = %247
  %251 = getelementptr inbounds nuw i8, ptr %106, i32 7
  %252 = call align 8 ptr @llvm.ptrmask.p0.i32(ptr nonnull %251, i32 -8)
  %253 = getelementptr inbounds nuw i8, ptr %252, i32 8
  %254 = load i64, ptr %252, align 8, !tbaa !21
  %255 = trunc i64 %254 to i32
  br label %271

256:                                              ; preds = %247
  %257 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %258 = load i32, ptr %106, align 4, !tbaa !23
  br label %271

259:                                              ; preds = %239
  %260 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %261 = load i32, ptr %106, align 4, !tbaa !13
  %262 = and i32 %244, 256
  %263 = icmp eq i32 %262, 0
  br i1 %263, label %271, label %264

264:                                              ; preds = %259
  %265 = and i32 %244, 512
  %266 = icmp eq i32 %265, 0
  br i1 %266, label %269, label %267

267:                                              ; preds = %264
  %268 = and i32 %261, 255
  br label %271

269:                                              ; preds = %264
  %270 = and i32 %261, 65535
  br label %271

271:                                              ; preds = %259, %269, %267, %250, %256
  %272 = phi ptr [ %253, %250 ], [ %257, %256 ], [ %260, %267 ], [ %260, %269 ], [ %260, %259 ]
  %273 = phi i32 [ %255, %250 ], [ %258, %256 ], [ %268, %267 ], [ %270, %269 ], [ %261, %259 ]
  %274 = icmp eq i32 %273, 0
  %275 = and i16 %241, -23
  %276 = select i1 %274, i16 %275, i16 %243
  br i1 %274, label %277, label %282

277:                                              ; preds = %271
  %278 = and i16 %276, 64
  %279 = icmp ne i16 %278, 0
  %280 = icmp slt i32 %108, 1
  %281 = and i1 %280, %279
  br i1 %281, label %286, label %282

282:                                              ; preds = %277, %271
  %283 = call fastcc ptr @__ultoa_invert(i32 noundef %273, ptr noundef %4, i32 noundef %242) #8
  %284 = ptrtoint ptr %283 to i32
  %285 = sub i32 %284, %14
  br label %286

286:                                              ; preds = %282, %277, %233, %231
  %287 = phi i32 [ %104, %231 ], [ %104, %233 ], [ %240, %277 ], [ %240, %282 ]
  %288 = phi i16 [ %115, %231 ], [ %115, %233 ], [ %276, %277 ], [ %276, %282 ]
  %289 = phi i32 [ %232, %231 ], [ %234, %233 ], [ %22, %277 ], [ %22, %282 ]
  %290 = phi ptr [ %106, %231 ], [ %106, %233 ], [ %272, %277 ], [ %272, %282 ]
  %291 = phi i1 [ false, %231 ], [ false, %233 ], [ true, %277 ], [ true, %282 ]
  %292 = phi i32 [ 11, %231 ], [ %238, %233 ], [ 0, %277 ], [ 0, %282 ]
  %293 = phi i32 [ %19, %231 ], [ %19, %233 ], [ 0, %277 ], [ %285, %282 ]
  br i1 %291, label %294, label %431

294:                                              ; preds = %216, %211, %286
  %295 = phi i32 [ %287, %286 ], [ %104, %211 ], [ %104, %216 ]
  %296 = phi i16 [ %288, %286 ], [ %209, %211 ], [ %209, %216 ]
  %297 = phi i32 [ %289, %286 ], [ %22, %211 ], [ %22, %216 ]
  %298 = phi ptr [ %290, %286 ], [ %203, %211 ], [ %203, %216 ]
  %299 = phi i32 [ %293, %286 ], [ 0, %211 ], [ %219, %216 ]
  %300 = and i16 %296, 64
  %301 = icmp eq i16 %300, 0
  br i1 %301, label %309, label %302

302:                                              ; preds = %294
  %303 = and i16 %296, -2
  %304 = icmp slt i32 %299, %112
  br i1 %304, label %305, label %309

305:                                              ; preds = %302
  %306 = icmp eq i32 %295, 0
  %307 = and i16 %296, -18
  %308 = select i1 %306, i16 %307, i16 %303
  br label %309

309:                                              ; preds = %305, %302, %294
  %310 = phi i16 [ %303, %302 ], [ %296, %294 ], [ %308, %305 ]
  %311 = phi i32 [ %299, %302 ], [ %299, %294 ], [ %112, %305 ]
  %312 = zext i16 %310 to i32
  %313 = and i32 %312, 16
  %314 = icmp eq i32 %313, 0
  br i1 %314, label %318, label %315

315:                                              ; preds = %309
  %316 = icmp eq i32 %295, 0
  %317 = select i1 %316, i32 1, i32 2
  br label %322

318:                                              ; preds = %309
  %319 = and i32 %312, 1030
  %320 = icmp ne i32 %319, 0
  %321 = zext i1 %320 to i32
  br label %322

322:                                              ; preds = %318, %315
  %323 = phi i32 [ %317, %315 ], [ %321, %318 ]
  %324 = add nsw i32 %323, %311
  %325 = and i32 %312, 8
  %326 = icmp eq i32 %325, 0
  br i1 %326, label %327, label %351

327:                                              ; preds = %322
  %328 = and i32 %312, 1
  %329 = icmp eq i32 %328, 0
  br i1 %329, label %335, label %330

330:                                              ; preds = %327
  %331 = icmp slt i32 %324, %116
  br i1 %331, label %332, label %335

332:                                              ; preds = %330
  %333 = add i32 %299, %116
  %334 = sub i32 %333, %324
  br label %335

335:                                              ; preds = %330, %332, %327
  %336 = phi i32 [ %334, %332 ], [ %299, %330 ], [ %112, %327 ]
  %337 = phi i32 [ %116, %332 ], [ %324, %330 ], [ %324, %327 ]
  %338 = icmp slt i32 %337, %116
  br i1 %338, label %339, label %351

339:                                              ; preds = %335
  %340 = add i32 %297, %116
  %341 = sub i32 %340, %337
  br label %342

342:                                              ; preds = %339, %348
  %343 = phi i32 [ %349, %348 ], [ %337, %339 ]
  %344 = phi i32 [ %345, %348 ], [ %297, %339 ]
  %345 = add nsw i32 %344, 1
  %346 = call i32 %6(i8 noundef signext 32, ptr noundef nonnull %0) #7
  %347 = icmp slt i32 %346, 0
  br i1 %347, label %411, label %348

348:                                              ; preds = %342
  %349 = add i32 %343, 1
  %350 = icmp eq i32 %349, %116
  br i1 %350, label %351, label %342, !llvm.loop !25

351:                                              ; preds = %348, %335, %322
  %352 = phi i32 [ %297, %322 ], [ %297, %335 ], [ %341, %348 ]
  %353 = phi i32 [ %112, %322 ], [ %336, %335 ], [ %336, %348 ]
  %354 = phi i32 [ %324, %322 ], [ %337, %335 ], [ %116, %348 ]
  %355 = sub nsw i32 %116, %354
  br i1 %314, label %367, label %356

356:                                              ; preds = %351
  %357 = add nsw i32 %352, 1
  %358 = call i32 %6(i8 noundef signext 48, ptr noundef nonnull %0) #7
  %359 = icmp slt i32 %358, 0
  br i1 %359, label %411, label %360

360:                                              ; preds = %356
  %361 = icmp eq i32 %295, 0
  br i1 %361, label %381, label %362

362:                                              ; preds = %360
  %363 = add nsw i32 %352, 2
  %364 = trunc nsw i32 %295 to i8
  %365 = call i32 %6(i8 noundef signext %364, ptr noundef nonnull %0) #7
  %366 = icmp slt i32 %365, 0
  br i1 %366, label %411, label %381

367:                                              ; preds = %351
  %368 = and i32 %312, 1030
  %369 = icmp eq i32 %368, 0
  br i1 %369, label %381, label %370

370:                                              ; preds = %367
  %371 = and i32 %312, 2
  %372 = icmp eq i32 %371, 0
  %373 = select i1 %372, i8 32, i8 43
  %374 = and i32 %312, 1024
  %375 = icmp eq i32 %374, 0
  %376 = select i1 %375, i8 %373, i8 45
  %377 = add nsw i32 %352, 1
  %378 = call i32 %6(i8 noundef signext %376, ptr noundef nonnull %0) #7
  %379 = icmp sgt i32 %378, -1
  %380 = select i1 %379, i32 0, i32 11
  br i1 %379, label %381, label %411

381:                                              ; preds = %367, %370, %360, %362
  %382 = phi i32 [ %363, %362 ], [ %357, %360 ], [ %377, %370 ], [ %352, %367 ]
  %383 = icmp sgt i32 %353, %299
  br i1 %383, label %384, label %390

384:                                              ; preds = %381
  %385 = add i32 %382, %353
  %386 = sub i32 %385, %299
  br label %394

387:                                              ; preds = %394
  %388 = add nsw i32 %395, -1
  %389 = icmp sgt i32 %388, %299
  br i1 %389, label %394, label %390, !llvm.loop !26

390:                                              ; preds = %387, %381
  %391 = phi i32 [ %382, %381 ], [ %386, %387 ]
  %392 = call i32 @llvm.smax.i32(i32 %353, i32 %299)
  %393 = add i32 %382, %392
  br label %400

394:                                              ; preds = %384, %387
  %395 = phi i32 [ %388, %387 ], [ %353, %384 ]
  %396 = phi i32 [ %397, %387 ], [ %382, %384 ]
  %397 = add nsw i32 %396, 1
  %398 = call i32 %6(i8 noundef signext 48, ptr noundef nonnull %0) #7
  %399 = icmp slt i32 %398, 0
  br i1 %399, label %411, label %387

400:                                              ; preds = %390, %404
  %401 = phi i32 [ %405, %404 ], [ %391, %390 ]
  %402 = phi i32 [ %406, %404 ], [ %299, %390 ]
  %403 = icmp eq i32 %402, 0
  br i1 %403, label %411, label %404

404:                                              ; preds = %400
  %405 = add nsw i32 %401, 1
  %406 = add nsw i32 %402, -1
  %407 = getelementptr inbounds [11 x i8], ptr %4, i32 0, i32 %406
  %408 = load i8, ptr %407, align 1, !tbaa !10
  %409 = call i32 %6(i8 noundef signext %408, ptr noundef nonnull %0) #7
  %410 = icmp slt i32 %409, 0
  br i1 %410, label %411, label %400, !llvm.loop !27

411:                                              ; preds = %342, %394, %400, %404, %362, %356, %370
  %412 = phi i32 [ %377, %370 ], [ %357, %356 ], [ %363, %362 ], [ %405, %404 ], [ %393, %400 ], [ %397, %394 ], [ %345, %342 ]
  %413 = phi i32 [ %380, %370 ], [ 11, %356 ], [ 11, %362 ], [ 11, %404 ], [ 0, %400 ], [ 11, %394 ], [ 11, %342 ]
  %414 = phi i32 [ %355, %370 ], [ %355, %356 ], [ %355, %362 ], [ %355, %404 ], [ %355, %400 ], [ %355, %394 ], [ %116, %342 ]
  %415 = phi i32 [ %299, %370 ], [ %299, %356 ], [ %299, %362 ], [ %406, %404 ], [ 0, %400 ], [ %299, %394 ], [ %299, %342 ]
  %416 = icmp eq i32 %413, 0
  br i1 %416, label %417, label %431

417:                                              ; preds = %160, %411
  %418 = phi i32 [ %412, %411 ], [ %159, %160 ]
  %419 = phi ptr [ %298, %411 ], [ %141, %160 ]
  %420 = phi i32 [ %414, %411 ], [ %158, %160 ]
  %421 = phi i32 [ %415, %411 ], [ %19, %160 ]
  br label %422

422:                                              ; preds = %426, %417
  %423 = phi i32 [ %418, %417 ], [ %428, %426 ]
  %424 = phi i32 [ %420, %417 ], [ %427, %426 ]
  %425 = icmp sgt i32 %424, 0
  br i1 %425, label %426, label %431

426:                                              ; preds = %422
  %427 = add nsw i32 %424, -1
  %428 = add nsw i32 %423, 1
  %429 = call i32 %6(i8 noundef signext 32, ptr noundef nonnull %0) #7
  %430 = icmp slt i32 %429, 0
  br i1 %430, label %431, label %422, !llvm.loop !28

431:                                              ; preds = %77, %146, %165, %422, %426, %411, %286
  %432 = phi ptr [ %103, %411 ], [ %103, %286 ], [ %103, %426 ], [ %103, %422 ], [ %103, %165 ], [ %103, %146 ], [ %36, %77 ]
  %433 = phi i32 [ %412, %411 ], [ %289, %286 ], [ %423, %422 ], [ %428, %426 ], [ %167, %165 ], [ %149, %146 ], [ %22, %77 ]
  %434 = phi ptr [ %298, %411 ], [ %290, %286 ], [ %419, %426 ], [ %419, %422 ], [ %141, %165 ], [ %141, %146 ], [ %39, %77 ]
  %435 = phi i32 [ %413, %411 ], [ %292, %286 ], [ 0, %422 ], [ 11, %426 ], [ 11, %165 ], [ 11, %146 ], [ 8, %77 ]
  %436 = phi i32 [ %415, %411 ], [ %293, %286 ], [ %421, %426 ], [ %421, %422 ], [ %19, %165 ], [ %19, %146 ], [ %19, %77 ]
  switch i32 %435, label %441 [
    i32 0, label %437
    i32 5, label %437
    i32 11, label %438
  ]

437:                                              ; preds = %431, %431
  br label %15, !llvm.loop !29

438:                                              ; preds = %431, %29
  %439 = load i8, ptr %7, align 2, !tbaa !9
  %440 = or i8 %439, 4
  store i8 %440, ptr %7, align 2, !tbaa !9
  br label %441

441:                                              ; preds = %431, %20, %438, %3
  %442 = phi i32 [ -1, %3 ], [ -1, %438 ], [ %22, %20 ], [ %433, %431 ]
  call void @llvm.lifetime.end.p0(i64 11, ptr nonnull %4) #6
  ret i32 %442
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare ptr @llvm.ptrmask.p0.i32(ptr, i32) #2

declare dso_local i32 @strnlen(ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: write)
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

attributes #0 = { nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nofree noinline norecurse nosync nounwind memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { nounwind }
attributes #7 = { nobuiltin nounwind "no-builtins" }
attributes #8 = { nobuiltin "no-builtins" }

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
!25 = distinct !{!25, !16, !12}
!26 = distinct !{!26, !16, !12}
!27 = distinct !{!27, !16, !12}
!28 = distinct !{!28, !16, !12}
!29 = distinct !{!29, !12}
!30 = distinct !{!30, !16, !12}
