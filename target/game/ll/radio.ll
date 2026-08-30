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
@rho = internal unnamed_addr constant [6 x [3 x i16]] [[3 x i16] [i16 192, i16 192, i16 192], [3 x i16] [i16 192, i16 192, i16 192], [3 x i16] [i16 192, i16 192, i16 192], [3 x i16] [i16 230, i16 45, i16 45], [3 x i16] [i16 45, i16 230, i16 45], [3 x i16] [i16 200, i16 195, i16 185]], align 2
@wnrm = internal unnamed_addr constant [5 x [3 x i16]] [[3 x i16] [i16 0, i16 0, i16 -256], [3 x i16] [i16 0, i16 -256, i16 0], [3 x i16] [i16 0, i16 256, i16 0], [3 x i16] [i16 256, i16 0, i16 0], [3 x i16] [i16 -256, i16 0, i16 0]], align 2
@PBASE = internal unnamed_addr constant [10 x i8] c"\00\04\14\18`dhlp\94", align 1
@dfrc = internal unnamed_addr global i8 0, align 1
@gfx_tile = external dso_local local_unnamed_addr global [4 x i16], align 2

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
  %10 = alloca [25 x i32], align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  tail call void @uputs(ptr noundef nonnull @.str) #8
  tail call void @aud_borrow() #8
  tail call void @led(i32 noundef 984577, i32 noundef 984577) #8
  tail call void @gfx_clear(i16 noundef zeroext 2114) #8
  call void @llvm.lifetime.start.p0(i64 100, ptr nonnull %10) #9
  br label %14

14:                                               ; preds = %20, %0
  %15 = phi i32 [ 0, %0 ], [ %25, %20 ]
  %16 = icmp eq i32 %15, 25
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %10, i32 96
  %19 = load i32, ptr %18, align 4
  br label %26

20:                                               ; preds = %14
  %21 = mul nuw nsw i32 %15, 10
  %22 = add nuw nsw i32 %21, 200
  %23 = udiv i32 819200, %22
  %24 = getelementptr inbounds nuw [25 x i32], ptr %10, i32 0, i32 %15
  store i32 %23, ptr %24, align 4, !tbaa !3
  %25 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !7

26:                                               ; preds = %43, %17
  %27 = phi i32 [ %44, %43 ], [ 0, %17 ]
  %28 = icmp eq i32 %27, 5
  br i1 %28, label %99, label %29

29:                                               ; preds = %26
  %30 = mul nuw nsw i32 %27, 625
  br label %31

31:                                               ; preds = %48, %29
  %32 = phi i32 [ %49, %48 ], [ 0, %29 ]
  %33 = icmp eq i32 %32, 25
  br i1 %33, label %43, label %34

34:                                               ; preds = %31
  %35 = mul nuw nsw i32 %32, 25
  %36 = add nuw nsw i32 %35, %30
  %37 = getelementptr inbounds nuw [25 x i32], ptr %10, i32 0, i32 %32
  %38 = mul nuw nsw i32 %32, 10
  %39 = add nsw i32 %38, -120
  %40 = mul nsw i32 %39, %19
  %41 = ashr i32 %40, 12
  %42 = add nsw i32 %41, 120
  br label %45

43:                                               ; preds = %31
  %44 = add nuw nsw i32 %27, 1
  br label %26, !llvm.loop !10

45:                                               ; preds = %89, %34
  %46 = phi i32 [ %98, %89 ], [ 0, %34 ]
  %47 = icmp eq i32 %46, 25
  br i1 %47, label %48, label %50

48:                                               ; preds = %45
  %49 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !11

50:                                               ; preds = %45
  %51 = mul nuw nsw i32 %46, 10
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
  %93 = add nuw nsw i32 %36, %46
  %94 = shl nuw nsw i32 %93, 1
  %95 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537133056 to ptr), i32 %94
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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #9
  call fastcc void @face_point(i32 noundef %100, i32 noundef %123, i32 noundef %115, ptr noundef %11, ptr noundef %12, ptr noundef %13) #10
  %128 = load i32, ptr %13, align 4, !tbaa !3
  %129 = udiv i32 819200, %128
  %130 = load i32, ptr %11, align 4, !tbaa !3
  %131 = mul nsw i32 %130, %129
  %132 = lshr i32 %131, 12
  %133 = trunc i32 %132 to i8
  %134 = add i8 %133, 120
  %135 = add nuw nsw i32 %119, %123
  %136 = shl nuw nsw i32 %135, 1
  %137 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %136
  store i8 %134, ptr %137, align 2, !tbaa !12
  %138 = load i32, ptr %12, align 4, !tbaa !3
  %139 = mul nsw i32 %138, %129
  %140 = lshr i32 %139, 12
  %141 = trunc i32 %140 to i8
  %142 = add i8 %141, 120
  %143 = getelementptr inbounds nuw i8, ptr %137, i32 1
  store i8 %142, ptr %143, align 1, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #9
  %144 = add nuw nsw i32 %123, 1
  br label %122, !llvm.loop !18

145:                                              ; preds = %99
  call void @llvm.lifetime.end.p0(i64 100, ptr nonnull %10) #9
  br label %146

146:                                              ; preds = %149, %145
  %147 = phi i32 [ 0, %145 ], [ %164, %149 ]
  %148 = icmp eq i32 %147, 16
  br i1 %148, label %165, label %149

149:                                              ; preds = %146
  %150 = icmp samesign ult i32 %147, 5
  %151 = icmp eq i32 %147, 15
  %152 = select i1 %151, i32 0, i32 5
  %153 = select i1 %150, i32 %147, i32 %152
  %154 = getelementptr inbounds nuw [6 x [3 x i16]], ptr @rho, i32 0, i32 %153
  %155 = load i16, ptr %154, align 2, !tbaa !14
  %156 = mul nuw nsw i32 %147, 6
  %157 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537140056 to ptr), i32 %156
  store i16 %155, ptr %157, align 2, !tbaa !14
  %158 = getelementptr inbounds nuw i8, ptr %154, i32 2
  %159 = load i16, ptr %158, align 2, !tbaa !14
  %160 = getelementptr inbounds nuw i8, ptr %157, i32 2
  store i16 %159, ptr %160, align 2, !tbaa !14
  %161 = getelementptr inbounds nuw i8, ptr %154, i32 4
  %162 = load i16, ptr %161, align 2, !tbaa !14
  %163 = getelementptr inbounds nuw i8, ptr %157, i32 4
  store i16 %162, ptr %163, align 2, !tbaa !14
  %164 = add nuw nsw i32 %147, 1
  br label %146, !llvm.loop !19

165:                                              ; preds = %146, %169
  %166 = phi i32 [ %181, %169 ], [ 0, %146 ]
  %167 = icmp eq i32 %166, 5
  br i1 %167, label %168, label %169

168:                                              ; preds = %165
  store i16 0, ptr inttoptr (i32 537140050 to ptr), align 2, !tbaa !14
  store i16 0, ptr inttoptr (i32 537140052 to ptr), align 4, !tbaa !14
  store i16 256, ptr inttoptr (i32 537140054 to ptr), align 2, !tbaa !14
  store i16 1600, ptr inttoptr (i32 537140182 to ptr), align 2, !tbaa !14
  br label %182

169:                                              ; preds = %165
  %170 = getelementptr inbounds nuw [5 x [3 x i16]], ptr @wnrm, i32 0, i32 %166
  %171 = load i16, ptr %170, align 2, !tbaa !14
  %172 = mul nuw nsw i32 %166, 6
  %173 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139960 to ptr), i32 %172
  store i16 %171, ptr %173, align 2, !tbaa !14
  %174 = getelementptr inbounds nuw i8, ptr %170, i32 2
  %175 = load i16, ptr %174, align 2, !tbaa !14
  %176 = getelementptr inbounds nuw i8, ptr %173, i32 2
  store i16 %175, ptr %176, align 2, !tbaa !14
  %177 = getelementptr inbounds nuw i8, ptr %170, i32 4
  %178 = load i16, ptr %177, align 2, !tbaa !14
  %179 = getelementptr inbounds nuw i8, ptr %173, i32 4
  store i16 %178, ptr %179, align 2, !tbaa !14
  %180 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537140152 to ptr), i32 %166
  store i16 100, ptr %180, align 2, !tbaa !14
  %181 = add nuw nsw i32 %166, 1
  br label %165, !llvm.loop !20

182:                                              ; preds = %197, %168
  %183 = phi i32 [ 0, %168 ], [ %198, %197 ]
  %184 = phi i32 [ 0, %168 ], [ %190, %197 ]
  %185 = icmp eq i32 %183, 5
  br i1 %185, label %231, label %186

186:                                              ; preds = %182
  %187 = trunc nuw i32 %183 to i8
  br label %188

188:                                              ; preds = %203, %186
  %189 = phi i32 [ %204, %203 ], [ 0, %186 ]
  %190 = phi i32 [ %201, %203 ], [ %184, %186 ]
  %191 = icmp eq i32 %189, 24
  br i1 %191, label %197, label %192

192:                                              ; preds = %188
  %193 = trunc i32 %189 to i16
  %194 = mul i16 %193, 10
  %195 = add i16 %194, 205
  %196 = add nsw i16 %194, -115
  br label %199

197:                                              ; preds = %188
  %198 = add nuw nsw i32 %183, 1
  br label %182, !llvm.loop !21

199:                                              ; preds = %226, %192
  %200 = phi i32 [ %229, %226 ], [ 0, %192 ]
  %201 = phi i32 [ %230, %226 ], [ %190, %192 ]
  %202 = icmp eq i32 %200, 24
  br i1 %202, label %203, label %205

203:                                              ; preds = %199
  %204 = add nuw nsw i32 %189, 1
  br label %188, !llvm.loop !22

205:                                              ; preds = %199
  %206 = mul nuw nsw i32 %200, 10
  %207 = add nsw i32 %206, -115
  %208 = getelementptr inbounds i8, ptr inttoptr (i32 537120928 to ptr), i32 %201
  store i8 %187, ptr %208, align 1, !tbaa !12
  %209 = getelementptr inbounds i16, ptr inttoptr (i32 537065488 to ptr), i32 %201
  %210 = getelementptr inbounds i16, ptr inttoptr (i32 537071648 to ptr), i32 %201
  switch i32 %183, label %223 [
    i32 0, label %211
    i32 1, label %214
    i32 2, label %217
    i32 3, label %220
  ]

211:                                              ; preds = %205
  %212 = trunc nsw i32 %207 to i16
  %213 = getelementptr inbounds i16, ptr inttoptr (i32 537059328 to ptr), i32 %201
  store i16 %212, ptr %213, align 2, !tbaa !14
  br label %226

214:                                              ; preds = %205
  %215 = trunc nsw i32 %207 to i16
  %216 = getelementptr inbounds i16, ptr inttoptr (i32 537059328 to ptr), i32 %201
  store i16 %215, ptr %216, align 2, !tbaa !14
  br label %226

217:                                              ; preds = %205
  %218 = trunc nsw i32 %207 to i16
  %219 = getelementptr inbounds i16, ptr inttoptr (i32 537059328 to ptr), i32 %201
  store i16 %218, ptr %219, align 2, !tbaa !14
  br label %226

220:                                              ; preds = %205
  %221 = getelementptr inbounds i16, ptr inttoptr (i32 537059328 to ptr), i32 %201
  store i16 -120, ptr %221, align 2, !tbaa !14
  %222 = trunc nsw i32 %207 to i16
  br label %226

223:                                              ; preds = %205
  %224 = getelementptr inbounds i16, ptr inttoptr (i32 537059328 to ptr), i32 %201
  store i16 120, ptr %224, align 2, !tbaa !14
  %225 = trunc nsw i32 %207 to i16
  br label %226

226:                                              ; preds = %223, %220, %217, %214, %211
  %227 = phi i16 [ %225, %223 ], [ %222, %220 ], [ -120, %217 ], [ 120, %214 ], [ %196, %211 ]
  %228 = phi i16 [ %195, %223 ], [ %195, %220 ], [ %195, %217 ], [ %195, %214 ], [ 440, %211 ]
  store i16 %227, ptr %209, align 2, !tbaa !14
  store i16 %228, ptr %210, align 2, !tbaa !14
  %229 = add nuw nsw i32 %200, 1
  %230 = add nsw i32 %201, 1
  br label %199, !llvm.loop !23

231:                                              ; preds = %182, %284
  %232 = phi i32 [ %300, %284 ], [ 0, %182 ]
  %233 = icmp eq i32 %232, 10
  br i1 %233, label %333, label %234

234:                                              ; preds = %231
  %235 = add nsw i32 %232, -5
  %236 = icmp samesign ult i32 %232, 5
  %237 = select i1 %236, i32 %232, i32 %235
  %238 = select i1 %236, i32 245, i32 243
  %239 = select i1 %236, i32 75, i32 -79
  switch i32 %237, label %247 [
    i32 0, label %248
    i32 1, label %240
    i32 2, label %243
    i32 3, label %245
  ]

240:                                              ; preds = %234
  %241 = select i1 %236, i32 -75, i32 79
  %242 = select i1 %236, i32 -245, i32 -243
  br label %248

243:                                              ; preds = %234
  %244 = select i1 %236, i32 -75, i32 79
  br label %248

245:                                              ; preds = %234
  %246 = select i1 %236, i32 -245, i32 -243
  br label %248

247:                                              ; preds = %234
  br label %248

248:                                              ; preds = %247, %245, %243, %240, %234
  %249 = phi i32 [ 0, %247 ], [ %242, %240 ], [ %244, %243 ], [ %239, %245 ], [ %238, %234 ]
  %250 = phi i32 [ -256, %247 ], [ 0, %240 ], [ 0, %243 ], [ 0, %245 ], [ %237, %234 ]
  %251 = phi i32 [ 0, %247 ], [ %241, %240 ], [ %238, %243 ], [ %246, %245 ], [ %239, %234 ]
  %252 = trunc nsw i32 %249 to i16
  %253 = add nuw nsw i32 %232, 5
  %254 = mul nuw nsw i32 %253, 6
  %255 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139960 to ptr), i32 %254
  store i16 %252, ptr %255, align 2, !tbaa !14
  %256 = trunc nsw i32 %250 to i16
  %257 = getelementptr inbounds nuw i8, ptr %255, i32 2
  store i16 %256, ptr %257, align 2, !tbaa !14
  %258 = trunc nsw i32 %251 to i16
  %259 = getelementptr inbounds nuw i8, ptr %255, i32 4
  store i16 %258, ptr %259, align 2, !tbaa !14
  %260 = getelementptr inbounds nuw [10 x i8], ptr @NFI, i32 0, i32 %232
  %261 = load i8, ptr %260, align 1, !tbaa !12
  %262 = zext i8 %261 to i32
  %263 = getelementptr inbounds nuw [10 x i8], ptr @NFK, i32 0, i32 %232
  %264 = load i8, ptr %263, align 1, !tbaa !12
  %265 = zext i8 %264 to i32
  %266 = icmp eq i32 %237, 4
  %267 = mul nuw nsw i32 %265, %262
  %268 = select i1 %236, i16 10800, i16 5184
  %269 = select i1 %266, i16 5184, i16 %268
  %270 = trunc nuw i32 %267 to i16
  %271 = udiv i16 %269, %270
  %272 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537140152 to ptr), i32 %253
  store i16 %271, ptr %272, align 2, !tbaa !14
  %273 = getelementptr inbounds nuw [10 x i8], ptr @PBASE, i32 0, i32 %232
  %274 = trunc nuw i32 %253 to i8
  br label %275

275:                                              ; preds = %301, %248
  %276 = phi i32 [ 0, %248 ], [ %282, %301 ]
  %277 = icmp eq i32 %276, %265
  br i1 %277, label %284, label %278

278:                                              ; preds = %275
  %279 = mul nuw nsw i32 %276, %262
  %280 = add nuw nsw i32 %279, 2880
  %281 = shl i32 %276, 4
  %282 = add nuw nsw i32 %276, 1
  %283 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139794 to ptr), i32 %279
  br label %301

284:                                              ; preds = %275
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #9
  %285 = lshr i8 %261, 1
  %286 = zext nneg i8 %285 to i32
  %287 = lshr i8 %264, 1
  %288 = zext nneg i8 %287 to i32
  call fastcc void @face_point(i32 noundef %232, i32 noundef %286, i32 noundef %288, ptr noundef %7, ptr noundef %8, ptr noundef %9) #10
  %289 = load i32, ptr %7, align 4, !tbaa !3
  %290 = mul nsw i32 %289, %249
  %291 = load i32, ptr %8, align 4, !tbaa !3
  %292 = mul nsw i32 %291, %250
  %293 = add nsw i32 %292, %290
  %294 = load i32, ptr %9, align 4, !tbaa !3
  %295 = mul nsw i32 %294, %251
  %296 = add nsw i32 %293, %295
  %297 = lshr i32 %296, 31
  %298 = trunc nuw nsw i32 %297 to i16
  %299 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537140184 to ptr), i32 %232
  store i16 %298, ptr %299, align 2, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #9
  %300 = add nuw nsw i32 %232, 1
  br label %231, !llvm.loop !24

301:                                              ; preds = %304, %278
  %302 = phi i32 [ %314, %304 ], [ 0, %278 ]
  %303 = icmp eq i32 %302, %262
  br i1 %303, label %275, label %304, !llvm.loop !25

304:                                              ; preds = %301
  %305 = load i8, ptr %273, align 1, !tbaa !12
  %306 = zext i8 %305 to i32
  %307 = add nuw nsw i32 %280, %302
  %308 = add nuw nsw i32 %307, %306
  %309 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %308
  store i8 %274, ptr %309, align 1, !tbaa !12
  %310 = or i32 %302, %281
  %311 = trunc i32 %310 to i8
  %312 = getelementptr inbounds nuw i8, ptr %283, i32 %302
  %313 = getelementptr inbounds nuw i8, ptr %312, i32 %306
  store i8 %311, ptr %313, align 1, !tbaa !12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #9
  call fastcc void @face_point(i32 noundef %232, i32 noundef %302, i32 noundef %276, ptr noundef %1, ptr noundef %2, ptr noundef %3) #10
  %314 = add nuw nsw i32 %302, 1
  call fastcc void @face_point(i32 noundef %232, i32 noundef %314, i32 noundef %282, ptr noundef %4, ptr noundef %5, ptr noundef %6) #10
  %315 = load i32, ptr %1, align 4, !tbaa !3
  %316 = load i32, ptr %4, align 4, !tbaa !3
  %317 = add nsw i32 %316, %315
  %318 = sdiv i32 %317, 2
  %319 = trunc i32 %318 to i16
  %320 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537059328 to ptr), i32 %308
  store i16 %319, ptr %320, align 2, !tbaa !14
  %321 = load i32, ptr %2, align 4, !tbaa !3
  %322 = load i32, ptr %5, align 4, !tbaa !3
  %323 = add nsw i32 %322, %321
  %324 = sdiv i32 %323, 2
  %325 = trunc i32 %324 to i16
  %326 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537065488 to ptr), i32 %308
  store i16 %325, ptr %326, align 2, !tbaa !14
  %327 = load i32, ptr %3, align 4, !tbaa !3
  %328 = load i32, ptr %6, align 4, !tbaa !3
  %329 = add nsw i32 %328, %327
  %330 = sdiv i32 %329, 2
  %331 = trunc i32 %330 to i16
  %332 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537071648 to ptr), i32 %308
  store i16 %331, ptr %332, align 2, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #9
  br label %301, !llvm.loop !26

333:                                              ; preds = %231, %345
  %334 = phi i32 [ %346, %345 ], [ 0, %231 ]
  %335 = icmp eq i32 %334, 6
  br i1 %335, label %357, label %336

336:                                              ; preds = %333
  %337 = mul nuw nsw i32 %334, 6
  %338 = add nuw nsw i32 %337, 3044
  %339 = trunc nuw i32 %334 to i16
  %340 = mul nuw nsw i16 %339, 40
  %341 = add nsw i16 %340, -100
  br label %342

342:                                              ; preds = %347, %336
  %343 = phi i32 [ %356, %347 ], [ 0, %336 ]
  %344 = icmp eq i32 %343, 6
  br i1 %344, label %345, label %347

345:                                              ; preds = %342
  %346 = add nuw nsw i32 %334, 1
  br label %333, !llvm.loop !27

347:                                              ; preds = %342
  %348 = add nuw nsw i32 %338, %343
  %349 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %348
  store i8 15, ptr %349, align 1, !tbaa !12
  %350 = trunc nuw nsw i32 %343 to i16
  %351 = mul nuw nsw i16 %350, 40
  %352 = add nsw i16 %351, -100
  %353 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537059328 to ptr), i32 %348
  store i16 %352, ptr %353, align 2, !tbaa !14
  %354 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537065488 to ptr), i32 %348
  store i16 %341, ptr %354, align 2, !tbaa !14
  %355 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537071648 to ptr), i32 %348
  store i16 200, ptr %355, align 2, !tbaa !14
  %356 = add nuw nsw i32 %343, 1
  br label %342, !llvm.loop !28

357:                                              ; preds = %333, %360
  %358 = phi i32 [ %369, %360 ], [ 0, %333 ]
  %359 = icmp eq i32 %358, 3080
  br i1 %359, label %370, label %360

360:                                              ; preds = %357
  %361 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537090128 to ptr), i32 %358
  store i16 0, ptr %361, align 2, !tbaa !14
  %362 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537083968 to ptr), i32 %358
  store i16 0, ptr %362, align 2, !tbaa !14
  %363 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537077808 to ptr), i32 %358
  store i16 0, ptr %363, align 2, !tbaa !14
  %364 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537108608 to ptr), i32 %358
  store i16 0, ptr %364, align 2, !tbaa !14
  %365 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537102448 to ptr), i32 %358
  store i16 0, ptr %365, align 2, !tbaa !14
  %366 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537096288 to ptr), i32 %358
  store i16 0, ptr %366, align 2, !tbaa !14
  %367 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %358
  store i16 -1, ptr %367, align 2, !tbaa !14
  %368 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537124008 to ptr), i32 %358
  store i8 -1, ptr %368, align 1, !tbaa !12
  %369 = add nuw nsw i32 %358, 1
  br label %357, !llvm.loop !29

370:                                              ; preds = %357, %379
  %371 = phi i32 [ %380, %379 ], [ 9, %357 ]
  %372 = icmp eq i32 %371, 14
  br i1 %372, label %387, label %373

373:                                              ; preds = %370
  %374 = mul nuw nsw i32 %371, 24
  %375 = add nuw nsw i32 %374, 1152
  br label %376

376:                                              ; preds = %381, %373
  %377 = phi i32 [ %386, %381 ], [ 9, %373 ]
  %378 = icmp eq i32 %377, 14
  br i1 %378, label %379, label %381

379:                                              ; preds = %376
  %380 = add nuw nsw i32 %371, 1
  br label %370, !llvm.loop !30

381:                                              ; preds = %376
  %382 = add nuw nsw i32 %375, %377
  %383 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537096288 to ptr), i32 %382
  store i16 -36, ptr %383, align 2, !tbaa !14
  %384 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537102448 to ptr), i32 %382
  store i16 -36, ptr %384, align 2, !tbaa !14
  %385 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537108608 to ptr), i32 %382
  store i16 -6586, ptr %385, align 2, !tbaa !14
  %386 = add nuw nsw i32 %377, 1
  br label %376, !llvm.loop !31

387:                                              ; preds = %370
  tail call fastcc void @repaint(i32 noundef 1) #10
  br label %388

388:                                              ; preds = %409, %387
  %389 = phi i32 [ 0, %387 ], [ %405, %409 ]
  br label %390

390:                                              ; preds = %388, %403
  %391 = phi i1 [ false, %403 ], [ true, %388 ]
  br label %392

392:                                              ; preds = %390, %399
  %393 = phi i1 [ false, %399 ], [ %391, %390 ]
  tail call void @in_poll() #8
  %394 = load i32, ptr @in_edge, align 4, !tbaa !3
  %395 = and i32 %394, 31
  %396 = icmp eq i32 %395, 0
  br i1 %396, label %398, label %397

397:                                              ; preds = %392
  tail call void @led(i32 noundef 0, i32 noundef 0) #8
  tail call void @aud_release() #8
  tail call void @uputs(ptr noundef nonnull @.str.1) #8
  ret void

398:                                              ; preds = %392
  br i1 %393, label %400, label %399

399:                                              ; preds = %398
  tail call void @frame_sync(i32 noundef 33000) #8
  br label %392, !llvm.loop !32

400:                                              ; preds = %398
  %401 = tail call fastcc i32 @brightest() #10
  %402 = icmp slt i32 %401, 0
  br i1 %402, label %403, label %404

403:                                              ; preds = %400
  tail call void @uputs(ptr noundef nonnull @.str.2) #8
  tail call void @uputn(i32 noundef %389) #8
  tail call void @uputs(ptr noundef nonnull @.str.3) #8
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #8
  br label %390, !llvm.loop !32

404:                                              ; preds = %400
  tail call fastcc void @shoot(i32 noundef %401) #10
  %405 = add i32 %389, 1
  tail call fastcc void @repaint(i32 noundef 0) #10
  %406 = and i32 %405, 15
  %407 = icmp eq i32 %406, 0
  br i1 %407, label %408, label %409

408:                                              ; preds = %404
  tail call void @uputs(ptr noundef nonnull @.str.4) #8
  tail call void @uputn(i32 noundef %405) #8
  tail call void @uputs(ptr noundef nonnull @.str.5) #8
  br label %409

409:                                              ; preds = %408, %404
  br label %388
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @aud_borrow() local_unnamed_addr #1

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

6:                                                ; preds = %153, %1
  %7 = phi i32 [ 0, %1 ], [ %154, %153 ]
  %8 = phi i32 [ 0, %1 ], [ %155, %153 ]
  %9 = phi i32 [ 0, %1 ], [ %157, %153 ]
  %10 = phi i32 [ 0, %1 ], [ %156, %153 ]
  %11 = phi i32 [ 0, %1 ], [ %146, %153 ]
  %12 = icmp eq i32 %9, 2880
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
  br label %158

22:                                               ; preds = %6
  %23 = icmp eq i32 %10, 2
  %24 = add i32 %7, -9
  %25 = icmp ult i32 %24, 5
  %26 = and i1 %25, %23
  %27 = icmp sgt i32 %8, 8
  %28 = and i1 %27, %26
  %29 = icmp samesign ult i32 %8, 14
  %30 = select i1 %28, i1 %29, i1 false
  %31 = zext i1 %30 to i32
  %32 = tail call fastcc zeroext i16 @patch_tone(i32 noundef %9, i32 noundef %31) #10
  br i1 %5, label %35, label %33

33:                                               ; preds = %22
  %34 = load i8, ptr @dfrc, align 1, !tbaa !12
  br label %46

35:                                               ; preds = %22
  %36 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %9
  %37 = load i16, ptr %36, align 2, !tbaa !14
  %38 = icmp eq i16 %32, %37
  %39 = load i8, ptr @dfrc, align 1, !tbaa !12
  br i1 %38, label %40, label %46

40:                                               ; preds = %35
  %41 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537124008 to ptr), i32 %9
  %42 = load i8, ptr %41, align 1, !tbaa !12
  %43 = icmp eq i8 %39, %42
  br i1 %43, label %44, label %46

44:                                               ; preds = %40
  %45 = add nsw i32 %7, 1
  br label %144

46:                                               ; preds = %33, %40, %35
  %47 = phi i8 [ %34, %33 ], [ %39, %40 ], [ %39, %35 ]
  %48 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %9
  store i16 %32, ptr %48, align 2, !tbaa !14
  %49 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537124008 to ptr), i32 %9
  store i8 %47, ptr %49, align 1, !tbaa !12
  %50 = mul nsw i32 %10, 625
  %51 = mul i32 %8, 25
  %52 = add i32 %50, %51
  %53 = add nsw i32 %52, %7
  %54 = shl nsw i32 %53, 1
  %55 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %54
  %56 = add nsw i32 %7, 1
  %57 = add nsw i32 %52, %56
  %58 = shl nsw i32 %57, 1
  %59 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %58
  %60 = add i32 %52, 25
  %61 = add nsw i32 %60, %7
  %62 = shl nsw i32 %61, 1
  %63 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %62
  %64 = add nsw i32 %60, %56
  %65 = shl nsw i32 %64, 1
  %66 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %65
  switch i32 %10, label %127 [
    i32 0, label %67
    i32 1, label %80
    i32 2, label %95
    i32 3, label %110
  ]

67:                                               ; preds = %46
  %68 = load i8, ptr %55, align 2, !tbaa !12
  %69 = zext i8 %68 to i32
  %70 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %71 = load i8, ptr %70, align 1, !tbaa !12
  %72 = zext i8 %71 to i32
  %73 = load i8, ptr %66, align 2, !tbaa !12
  %74 = zext i8 %73 to i32
  %75 = sub nsw i32 %74, %69
  %76 = getelementptr inbounds nuw i8, ptr %66, i32 1
  %77 = load i8, ptr %76, align 1, !tbaa !12
  %78 = zext i8 %77 to i32
  %79 = sub nsw i32 %78, %72
  tail call void @gfx_dfill(i32 noundef %69, i32 noundef %72, i32 noundef %75, i32 noundef %79) #8
  br label %144

80:                                               ; preds = %46
  %81 = getelementptr inbounds nuw i8, ptr %63, i32 1
  %82 = load i8, ptr %81, align 1, !tbaa !12
  %83 = zext i8 %82 to i32
  %84 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %85 = load i8, ptr %84, align 1, !tbaa !12
  %86 = zext i8 %85 to i32
  %87 = load i8, ptr %63, align 2, !tbaa !12
  %88 = zext i8 %87 to i32
  %89 = load i8, ptr %55, align 2, !tbaa !12
  %90 = zext i8 %89 to i32
  %91 = load i8, ptr %66, align 2, !tbaa !12
  %92 = zext i8 %91 to i32
  %93 = load i8, ptr %59, align 2, !tbaa !12
  %94 = zext i8 %93 to i32
  tail call fastcc void @fill_htrap(i32 noundef %83, i32 noundef %86, i32 noundef %88, i32 noundef %90, i32 noundef %92, i32 noundef %94) #10
  br label %144

95:                                               ; preds = %46
  %96 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %97 = load i8, ptr %96, align 1, !tbaa !12
  %98 = zext i8 %97 to i32
  %99 = getelementptr inbounds nuw i8, ptr %63, i32 1
  %100 = load i8, ptr %99, align 1, !tbaa !12
  %101 = zext i8 %100 to i32
  %102 = load i8, ptr %55, align 2, !tbaa !12
  %103 = zext i8 %102 to i32
  %104 = load i8, ptr %63, align 2, !tbaa !12
  %105 = zext i8 %104 to i32
  %106 = load i8, ptr %59, align 2, !tbaa !12
  %107 = zext i8 %106 to i32
  %108 = load i8, ptr %66, align 2, !tbaa !12
  %109 = zext i8 %108 to i32
  tail call fastcc void @fill_htrap(i32 noundef %98, i32 noundef %101, i32 noundef %103, i32 noundef %105, i32 noundef %107, i32 noundef %109) #10
  br label %144

110:                                              ; preds = %46
  %111 = load i8, ptr %55, align 2, !tbaa !12
  %112 = zext i8 %111 to i32
  %113 = load i8, ptr %63, align 2, !tbaa !12
  %114 = zext i8 %113 to i32
  %115 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %116 = load i8, ptr %115, align 1, !tbaa !12
  %117 = zext i8 %116 to i32
  %118 = getelementptr inbounds nuw i8, ptr %63, i32 1
  %119 = load i8, ptr %118, align 1, !tbaa !12
  %120 = zext i8 %119 to i32
  %121 = getelementptr inbounds nuw i8, ptr %59, i32 1
  %122 = load i8, ptr %121, align 1, !tbaa !12
  %123 = zext i8 %122 to i32
  %124 = getelementptr inbounds nuw i8, ptr %66, i32 1
  %125 = load i8, ptr %124, align 1, !tbaa !12
  %126 = zext i8 %125 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %112, i32 noundef %114, i32 noundef %117, i32 noundef %120, i32 noundef %123, i32 noundef %126) #10
  br label %144

127:                                              ; preds = %46
  %128 = load i8, ptr %63, align 2, !tbaa !12
  %129 = zext i8 %128 to i32
  %130 = load i8, ptr %55, align 2, !tbaa !12
  %131 = zext i8 %130 to i32
  %132 = getelementptr inbounds nuw i8, ptr %63, i32 1
  %133 = load i8, ptr %132, align 1, !tbaa !12
  %134 = zext i8 %133 to i32
  %135 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %136 = load i8, ptr %135, align 1, !tbaa !12
  %137 = zext i8 %136 to i32
  %138 = getelementptr inbounds nuw i8, ptr %66, i32 1
  %139 = load i8, ptr %138, align 1, !tbaa !12
  %140 = zext i8 %139 to i32
  %141 = getelementptr inbounds nuw i8, ptr %59, i32 1
  %142 = load i8, ptr %141, align 1, !tbaa !12
  %143 = zext i8 %142 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %129, i32 noundef %131, i32 noundef %134, i32 noundef %137, i32 noundef %140, i32 noundef %143) #10
  br label %144

144:                                              ; preds = %44, %127, %110, %95, %80, %67
  %145 = phi i32 [ %45, %44 ], [ %56, %127 ], [ %56, %110 ], [ %56, %95 ], [ %56, %80 ], [ %56, %67 ]
  %146 = phi i32 [ %11, %44 ], [ 1, %127 ], [ 1, %110 ], [ 1, %95 ], [ 1, %80 ], [ 1, %67 ]
  %147 = icmp eq i32 %145, 24
  br i1 %147, label %148, label %153

148:                                              ; preds = %144
  %149 = add nsw i32 %8, 1
  %150 = icmp eq i32 %149, 24
  br i1 %150, label %151, label %153

151:                                              ; preds = %148
  %152 = add nsw i32 %10, 1
  br label %153

153:                                              ; preds = %148, %151, %144
  %154 = phi i32 [ 0, %151 ], [ 0, %148 ], [ %145, %144 ]
  %155 = phi i32 [ 0, %151 ], [ %149, %148 ], [ %8, %144 ]
  %156 = phi i32 [ %152, %151 ], [ %10, %148 ], [ %10, %144 ]
  %157 = add nuw nsw i32 %9, 1
  br label %6, !llvm.loop !33

158:                                              ; preds = %13, %317
  %159 = phi i32 [ %318, %317 ], [ 2880, %13 ]
  %160 = icmp eq i32 %159, 3044
  br i1 %160, label %161, label %162

161:                                              ; preds = %158
  tail call void @gfx_present() #8
  ret void

162:                                              ; preds = %158
  %163 = tail call fastcc zeroext i16 @patch_tone(i32 noundef %159, i32 noundef 0) #10
  br i1 %15, label %166, label %164

164:                                              ; preds = %162
  %165 = load i8, ptr @dfrc, align 1, !tbaa !12
  br label %175

166:                                              ; preds = %162
  %167 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %159
  %168 = load i16, ptr %167, align 2, !tbaa !14
  %169 = icmp eq i16 %163, %168
  %170 = load i8, ptr @dfrc, align 1, !tbaa !12
  br i1 %169, label %171, label %175

171:                                              ; preds = %166
  %172 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537124008 to ptr), i32 %159
  %173 = load i8, ptr %172, align 1, !tbaa !12
  %174 = icmp eq i8 %170, %173
  br i1 %174, label %317, label %175

175:                                              ; preds = %164, %171, %166
  %176 = phi i8 [ %165, %164 ], [ %170, %171 ], [ %170, %166 ]
  %177 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %159
  store i16 %163, ptr %177, align 2, !tbaa !14
  %178 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537124008 to ptr), i32 %159
  store i8 %176, ptr %178, align 1, !tbaa !12
  %179 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %159
  %180 = load i8, ptr %179, align 1, !tbaa !12
  %181 = zext i8 %180 to i32
  %182 = add nsw i32 %181, -5
  %183 = getelementptr inbounds i16, ptr inttoptr (i32 537140184 to ptr), i32 %182
  %184 = load i16, ptr %183, align 2, !tbaa !14
  %185 = icmp eq i16 %184, 0
  br i1 %185, label %317, label %186

186:                                              ; preds = %175
  %187 = getelementptr i8, ptr inttoptr (i32 537136914 to ptr), i32 %159
  %188 = load i8, ptr %187, align 1, !tbaa !12
  %189 = zext i8 %188 to i32
  %190 = and i32 %189, 15
  %191 = lshr i32 %189, 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #9
  %192 = getelementptr inbounds [10 x i16], ptr @CGOFF, i32 0, i32 %182
  %193 = load i16, ptr %192, align 2, !tbaa !14
  %194 = zext i16 %193 to i32
  %195 = getelementptr inbounds [10 x i8], ptr @NFI, i32 0, i32 %182
  %196 = load i8, ptr %195, align 1, !tbaa !12
  %197 = zext i8 %196 to i32
  %198 = add nuw nsw i32 %197, 1
  %199 = mul nuw nsw i32 %198, %191
  %200 = add nuw nsw i32 %199, %194
  %201 = add nuw nsw i32 %200, %190
  %202 = shl nuw nsw i32 %201, 1
  %203 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %202
  %204 = add nuw nsw i32 %190, 1
  %205 = add nuw nsw i32 %200, %204
  %206 = shl nuw nsw i32 %205, 1
  %207 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %206
  %208 = add nuw nsw i32 %191, 1
  %209 = mul nuw nsw i32 %198, %208
  %210 = add nuw nsw i32 %209, %194
  %211 = add nuw nsw i32 %210, %204
  %212 = shl nuw nsw i32 %211, 1
  %213 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %212
  %214 = add nuw nsw i32 %210, %190
  %215 = shl nuw nsw i32 %214, 1
  %216 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %215
  %217 = load i8, ptr %203, align 2, !tbaa !12
  %218 = zext i8 %217 to i32
  store i32 %218, ptr %3, align 4, !tbaa !3
  %219 = getelementptr inbounds nuw i8, ptr %203, i32 1
  %220 = load i8, ptr %219, align 1, !tbaa !12
  %221 = zext i8 %220 to i32
  store i32 %221, ptr %4, align 4, !tbaa !3
  %222 = load i8, ptr %207, align 2, !tbaa !12
  %223 = zext i8 %222 to i32
  store i32 %223, ptr %16, align 4, !tbaa !3
  %224 = getelementptr inbounds nuw i8, ptr %207, i32 1
  %225 = load i8, ptr %224, align 1, !tbaa !12
  %226 = zext i8 %225 to i32
  store i32 %226, ptr %17, align 4, !tbaa !3
  %227 = load i8, ptr %213, align 2, !tbaa !12
  %228 = zext i8 %227 to i32
  store i32 %228, ptr %18, align 4, !tbaa !3
  %229 = getelementptr inbounds nuw i8, ptr %213, i32 1
  %230 = load i8, ptr %229, align 1, !tbaa !12
  %231 = zext i8 %230 to i32
  store i32 %231, ptr %19, align 4, !tbaa !3
  %232 = load i8, ptr %216, align 2, !tbaa !12
  %233 = zext i8 %232 to i32
  store i32 %233, ptr %20, align 4, !tbaa !3
  %234 = getelementptr inbounds nuw i8, ptr %216, i32 1
  %235 = load i8, ptr %234, align 1, !tbaa !12
  %236 = zext i8 %235 to i32
  store i32 %236, ptr %21, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #9
  br label %237

237:                                              ; preds = %261, %186
  %238 = phi i32 [ 0, %186 ], [ %247, %261 ]
  %239 = phi i32 [ %218, %186 ], [ %246, %261 ]
  %240 = phi i32 [ %218, %186 ], [ %245, %261 ]
  %241 = icmp eq i32 %238, 4
  br i1 %241, label %264, label %242

242:                                              ; preds = %237
  %243 = getelementptr inbounds nuw i32, ptr %3, i32 %238
  %244 = load i32, ptr %243, align 4, !tbaa !3
  %245 = tail call i32 @llvm.smin.i32(i32 %244, i32 %240)
  %246 = tail call i32 @llvm.smax.i32(i32 %244, i32 %239)
  %247 = add nuw nsw i32 %238, 1
  %248 = and i32 %247, 3
  %249 = getelementptr inbounds nuw i32, ptr %3, i32 %248
  %250 = load i32, ptr %249, align 4, !tbaa !3
  %251 = icmp eq i32 %250, %244
  br i1 %251, label %261, label %252

252:                                              ; preds = %242
  %253 = sub nsw i32 %250, %244
  %254 = getelementptr inbounds nuw i32, ptr %4, i32 %248
  %255 = load i32, ptr %254, align 4, !tbaa !3
  %256 = getelementptr inbounds nuw i32, ptr %4, i32 %238
  %257 = load i32, ptr %256, align 4, !tbaa !3
  %258 = sub nsw i32 %255, %257
  %259 = shl i32 %258, 12
  %260 = sdiv i32 %259, %253
  br label %261

261:                                              ; preds = %252, %242
  %262 = phi i32 [ %260, %252 ], [ 0, %242 ]
  %263 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %238
  store i32 %262, ptr %263, align 4, !tbaa !3
  br label %237, !llvm.loop !34

264:                                              ; preds = %237, %314
  %265 = phi i32 [ %315, %314 ], [ %240, %237 ]
  %266 = icmp sgt i32 %265, %239
  br i1 %266, label %316, label %267

267:                                              ; preds = %264, %300
  %268 = phi i32 [ %301, %300 ], [ 32767, %264 ]
  %269 = phi i32 [ %302, %300 ], [ -32768, %264 ]
  %270 = phi i32 [ %279, %300 ], [ 0, %264 ]
  br label %271

271:                                              ; preds = %288, %267
  %272 = phi i32 [ %270, %267 ], [ %279, %288 ]
  %273 = icmp eq i32 %272, 4
  br i1 %273, label %274, label %276

274:                                              ; preds = %271
  %275 = icmp sgt i32 %269, %268
  br i1 %275, label %312, label %314

276:                                              ; preds = %271
  %277 = getelementptr inbounds nuw i32, ptr %3, i32 %272
  %278 = load i32, ptr %277, align 4, !tbaa !3
  %279 = add nuw nsw i32 %272, 1
  %280 = and i32 %279, 3
  %281 = getelementptr inbounds nuw i32, ptr %3, i32 %280
  %282 = load i32, ptr %281, align 4, !tbaa !3
  %283 = tail call i32 @llvm.smin.i32(i32 %278, i32 %282)
  %284 = icmp slt i32 %265, %283
  br i1 %284, label %288, label %285

285:                                              ; preds = %276
  %286 = tail call i32 @llvm.smax.i32(i32 %278, i32 %282)
  %287 = icmp sgt i32 %265, %286
  br i1 %287, label %288, label %289

288:                                              ; preds = %285, %276
  br label %271, !llvm.loop !35

289:                                              ; preds = %285
  %290 = icmp eq i32 %278, %282
  %291 = getelementptr inbounds nuw i32, ptr %4, i32 %272
  %292 = load i32, ptr %291, align 4, !tbaa !3
  br i1 %290, label %293, label %303

293:                                              ; preds = %289
  %294 = getelementptr inbounds nuw i32, ptr %4, i32 %280
  %295 = load i32, ptr %294, align 4, !tbaa !3
  %296 = tail call i32 @llvm.smin.i32(i32 %295, i32 %292)
  %297 = tail call i32 @llvm.smax.i32(i32 %295, i32 %292)
  %298 = tail call i32 @llvm.smin.i32(i32 %296, i32 %268)
  %299 = tail call i32 @llvm.smax.i32(i32 %297, i32 %269)
  br label %300

300:                                              ; preds = %293, %303
  %301 = phi i32 [ %310, %303 ], [ %298, %293 ]
  %302 = phi i32 [ %311, %303 ], [ %299, %293 ]
  br label %267, !llvm.loop !35

303:                                              ; preds = %289
  %304 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %272
  %305 = load i32, ptr %304, align 4, !tbaa !3
  %306 = sub nsw i32 %265, %278
  %307 = mul nsw i32 %305, %306
  %308 = ashr i32 %307, 12
  %309 = add nsw i32 %308, %292
  %310 = tail call i32 @llvm.smin.i32(i32 %309, i32 %268)
  %311 = tail call i32 @llvm.smax.i32(i32 %309, i32 %269)
  br label %300

312:                                              ; preds = %274
  %313 = sub nsw i32 %269, %268
  tail call void @gfx_dfill(i32 noundef %265, i32 noundef %268, i32 noundef 1, i32 noundef %313) #8
  br label %314

314:                                              ; preds = %312, %274
  %315 = add nsw i32 %265, 1
  br label %264, !llvm.loop !36

316:                                              ; preds = %264
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #9
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #9
  br label %317

317:                                              ; preds = %316, %175, %171
  %318 = add nuw nsw i32 %159, 1
  br label %158, !llvm.loop !37
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @aud_release() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc i32 @brightest() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %9, %0
  %2 = phi i32 [ -1, %0 ], [ %29, %9 ]
  %3 = phi i32 [ 0, %0 ], [ %31, %9 ]
  %4 = phi i32 [ 0, %0 ], [ %30, %9 ]
  %5 = icmp eq i32 %3, 3080
  br i1 %5, label %6, label %9

6:                                                ; preds = %1
  %7 = icmp ugt i32 %4, 9599
  %8 = select i1 %7, i32 %2, i32 -1
  ret i32 %8

9:                                                ; preds = %1
  %10 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537096288 to ptr), i32 %3
  %11 = load i16, ptr %10, align 2, !tbaa !14
  %12 = zext i16 %11 to i32
  %13 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537102448 to ptr), i32 %3
  %14 = load i16, ptr %13, align 2, !tbaa !14
  %15 = zext i16 %14 to i32
  %16 = add nuw nsw i32 %15, %12
  %17 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537108608 to ptr), i32 %3
  %18 = load i16, ptr %17, align 2, !tbaa !14
  %19 = zext i16 %18 to i32
  %20 = add nuw nsw i32 %16, %19
  %21 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %3
  %22 = load i8, ptr %21, align 1, !tbaa !12
  %23 = zext i8 %22 to i32
  %24 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537140152 to ptr), i32 %23
  %25 = load i16, ptr %24, align 2, !tbaa !14
  %26 = zext i16 %25 to i32
  %27 = mul i32 %20, %26
  %28 = icmp ugt i32 %27, %4
  %29 = select i1 %28, i32 %3, i32 %2
  %30 = tail call i32 @llvm.umax.i32(i32 %27, i32 %4)
  %31 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !38
}

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @shoot(i32 noundef range(i32 0, -2147483648) %0) unnamed_addr #4 {
  %2 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %0
  %3 = load i8, ptr %2, align 1, !tbaa !12
  %4 = zext i8 %3 to i32
  %5 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537140152 to ptr), i32 %4
  %6 = load i16, ptr %5, align 2, !tbaa !14
  %7 = zext i16 %6 to i32
  %8 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537096288 to ptr), i32 %0
  %9 = load i16, ptr %8, align 2, !tbaa !14
  %10 = zext i16 %9 to i32
  %11 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537102448 to ptr), i32 %0
  %12 = load i16, ptr %11, align 2, !tbaa !14
  %13 = zext i16 %12 to i32
  %14 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537108608 to ptr), i32 %0
  %15 = load i16, ptr %14, align 2, !tbaa !14
  %16 = zext i16 %15 to i32
  store i16 0, ptr %14, align 2, !tbaa !14
  store i16 0, ptr %11, align 2, !tbaa !14
  store i16 0, ptr %8, align 2, !tbaa !14
  %17 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537059328 to ptr), i32 %0
  %18 = load i16, ptr %17, align 2, !tbaa !14
  %19 = sext i16 %18 to i32
  %20 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537065488 to ptr), i32 %0
  %21 = load i16, ptr %20, align 2, !tbaa !14
  %22 = sext i16 %21 to i32
  %23 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537071648 to ptr), i32 %0
  %24 = load i16, ptr %23, align 2, !tbaa !14
  %25 = sext i16 %24 to i32
  %26 = mul nuw nsw i32 %4, 6
  %27 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139960 to ptr), i32 %26
  %28 = load i16, ptr %27, align 2, !tbaa !14
  %29 = sext i16 %28 to i32
  %30 = getelementptr inbounds nuw i8, ptr %27, i32 2
  %31 = load i16, ptr %30, align 2, !tbaa !14
  %32 = sext i16 %31 to i32
  %33 = getelementptr inbounds nuw i8, ptr %27, i32 4
  %34 = load i16, ptr %33, align 2, !tbaa !14
  %35 = sext i16 %34 to i32
  %36 = shl nuw nsw i32 %7, 14
  br label %37

37:                                               ; preds = %169, %1
  %38 = phi i32 [ 0, %1 ], [ %170, %169 ]
  %39 = icmp eq i32 %38, 3080
  br i1 %39, label %40, label %41

40:                                               ; preds = %37
  ret void

41:                                               ; preds = %37
  %42 = icmp eq i32 %38, %0
  br i1 %42, label %169, label %43

43:                                               ; preds = %41
  %44 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537059328 to ptr), i32 %38
  %45 = load i16, ptr %44, align 2, !tbaa !14
  %46 = sext i16 %45 to i32
  %47 = sub nsw i32 %46, %19
  %48 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537065488 to ptr), i32 %38
  %49 = load i16, ptr %48, align 2, !tbaa !14
  %50 = sext i16 %49 to i32
  %51 = sub nsw i32 %50, %22
  %52 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537071648 to ptr), i32 %38
  %53 = load i16, ptr %52, align 2, !tbaa !14
  %54 = sext i16 %53 to i32
  %55 = sub nsw i32 %54, %25
  %56 = mul nsw i32 %47, %29
  %57 = mul nsw i32 %51, %32
  %58 = mul nsw i32 %55, %35
  %59 = add i32 %56, 134217728
  %60 = add i32 %59, %57
  %61 = add i32 %60, %58
  %62 = icmp ult i32 %61, 134217984
  br i1 %62, label %169, label %63

63:                                               ; preds = %43
  %64 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %38
  %65 = load i8, ptr %64, align 1, !tbaa !12
  %66 = zext i8 %65 to i32
  %67 = mul nuw nsw i32 %66, 3
  %68 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537139960 to ptr), i32 %67
  %69 = load i16, ptr %68, align 2, !tbaa !14
  %70 = sext i16 %69 to i32
  %71 = mul nsw i32 %47, %70
  %72 = getelementptr inbounds nuw i8, ptr %68, i32 2
  %73 = load i16, ptr %72, align 2, !tbaa !14
  %74 = sext i16 %73 to i32
  %75 = mul nsw i32 %51, %74
  %76 = add nsw i32 %75, %71
  %77 = getelementptr inbounds nuw i8, ptr %68, i32 4
  %78 = load i16, ptr %77, align 2, !tbaa !14
  %79 = sext i16 %78 to i32
  %80 = mul nsw i32 %55, %79
  %81 = add nsw i32 %76, %80
  %82 = add nsw i32 %81, 134217728
  %83 = lshr i32 %82, 8
  %84 = add nuw nsw i32 %83, 3670016
  %85 = icmp ult i32 %81, -134217728
  br i1 %85, label %169, label %86

86:                                               ; preds = %63
  %87 = mul nsw i32 %47, %47
  %88 = mul nsw i32 %51, %51
  %89 = add nuw i32 %88, %87
  %90 = mul nsw i32 %55, %55
  %91 = add i32 %89, %90
  %92 = icmp ult i32 %91, 64
  br i1 %92, label %169, label %93

93:                                               ; preds = %86
  %94 = tail call fastcc i32 @clearance(i32 noundef %0, i32 noundef %38) #10
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %169, label %96

96:                                               ; preds = %93
  %97 = shl i32 %61, 2
  %98 = and i32 %97, -1024
  %99 = sub i32 536870912, %98
  %100 = mul i32 %99, %84
  %101 = udiv i32 %100, %91
  %102 = udiv i32 %36, %91
  %103 = tail call i32 @llvm.umin.i32(i32 %102, i32 16384)
  %104 = mul nuw i32 %101, 41
  %105 = mul i32 %104, %103
  %106 = lshr i32 %105, 15
  %107 = mul nuw nsw i32 %94, 51
  %108 = mul nuw nsw i32 %107, %106
  %109 = icmp samesign ult i32 %108, 256
  br i1 %109, label %169, label %110

110:                                              ; preds = %96
  %111 = lshr i32 %108, 8
  %112 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537140056 to ptr), i32 %67
  %113 = mul i32 %111, %10
  %114 = lshr i32 %113, 16
  %115 = load i16, ptr %112, align 2, !tbaa !14
  %116 = zext i16 %115 to i32
  %117 = mul nuw i32 %114, %116
  %118 = lshr i32 %117, 8
  %119 = mul i32 %111, %13
  %120 = lshr i32 %119, 16
  %121 = getelementptr inbounds nuw i8, ptr %112, i32 2
  %122 = load i16, ptr %121, align 2, !tbaa !14
  %123 = zext i16 %122 to i32
  %124 = mul nuw i32 %120, %123
  %125 = lshr i32 %124, 8
  %126 = mul i32 %111, %16
  %127 = lshr i32 %126, 16
  %128 = getelementptr inbounds nuw i8, ptr %112, i32 4
  %129 = load i16, ptr %128, align 2, !tbaa !14
  %130 = zext i16 %129 to i32
  %131 = mul nuw i32 %127, %130
  %132 = lshr i32 %131, 8
  %133 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537077808 to ptr), i32 %38
  %134 = load i16, ptr %133, align 2, !tbaa !14
  %135 = zext i16 %134 to i32
  %136 = add nuw nsw i32 %118, %135
  %137 = tail call i32 @llvm.umin.i32(i32 %136, i32 65535)
  %138 = trunc nuw i32 %137 to i16
  store i16 %138, ptr %133, align 2, !tbaa !14
  %139 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537083968 to ptr), i32 %38
  %140 = load i16, ptr %139, align 2, !tbaa !14
  %141 = zext i16 %140 to i32
  %142 = add nuw nsw i32 %125, %141
  %143 = tail call i32 @llvm.umin.i32(i32 %142, i32 65535)
  %144 = trunc nuw i32 %143 to i16
  store i16 %144, ptr %139, align 2, !tbaa !14
  %145 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537090128 to ptr), i32 %38
  %146 = load i16, ptr %145, align 2, !tbaa !14
  %147 = zext i16 %146 to i32
  %148 = add nuw nsw i32 %132, %147
  %149 = tail call i32 @llvm.umin.i32(i32 %148, i32 65535)
  %150 = trunc nuw i32 %149 to i16
  store i16 %150, ptr %145, align 2, !tbaa !14
  %151 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537096288 to ptr), i32 %38
  %152 = load i16, ptr %151, align 2, !tbaa !14
  %153 = zext i16 %152 to i32
  %154 = add nuw nsw i32 %118, %153
  %155 = tail call i32 @llvm.umin.i32(i32 %154, i32 65535)
  %156 = trunc nuw i32 %155 to i16
  store i16 %156, ptr %151, align 2, !tbaa !14
  %157 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537102448 to ptr), i32 %38
  %158 = load i16, ptr %157, align 2, !tbaa !14
  %159 = zext i16 %158 to i32
  %160 = add nuw nsw i32 %125, %159
  %161 = tail call i32 @llvm.umin.i32(i32 %160, i32 65535)
  %162 = trunc nuw i32 %161 to i16
  store i16 %162, ptr %157, align 2, !tbaa !14
  %163 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537108608 to ptr), i32 %38
  %164 = load i16, ptr %163, align 2, !tbaa !14
  %165 = zext i16 %164 to i32
  %166 = add nuw nsw i32 %132, %165
  %167 = tail call i32 @llvm.umin.i32(i32 %166, i32 65535)
  %168 = trunc nuw i32 %167 to i16
  store i16 %168, ptr %163, align 2, !tbaa !14
  br label %169

169:                                              ; preds = %43, %86, %110, %96, %93, %63, %41
  %170 = add nuw nsw i32 %38, 1
  br label %37, !llvm.loop !39
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write)
define internal fastcc void @face_point(i32 noundef range(i32 -2147483648, 10) %0, i32 noundef range(i32 -2147483648, 256) %1, i32 noundef range(i32 -2147483648, 256) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %4, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %5) unnamed_addr #5 {
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

; Function Attrs: minsize nounwind optsize
define internal fastcc zeroext i16 @patch_tone(i32 noundef range(i32 -2147483648, 3044) %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %4, label %17

4:                                                ; preds = %2
  %5 = getelementptr inbounds i16, ptr inttoptr (i32 537077808 to ptr), i32 %0
  %6 = load i16, ptr %5, align 2, !tbaa !14
  %7 = zext i16 %6 to i32
  %8 = tail call fastcc i32 @tone(i32 noundef %7) #10
  %9 = getelementptr inbounds i16, ptr inttoptr (i32 537083968 to ptr), i32 %0
  %10 = load i16, ptr %9, align 2, !tbaa !14
  %11 = zext i16 %10 to i32
  %12 = tail call fastcc i32 @tone(i32 noundef %11) #10
  %13 = getelementptr inbounds i16, ptr inttoptr (i32 537090128 to ptr), i32 %0
  %14 = load i16, ptr %13, align 2, !tbaa !14
  %15 = zext i16 %14 to i32
  %16 = tail call fastcc i32 @tone(i32 noundef %15) #10
  br label %17

17:                                               ; preds = %4, %2
  %18 = phi i32 [ 248, %2 ], [ %8, %4 ]
  %19 = phi i32 [ 252, %2 ], [ %12, %4 ]
  %20 = phi i32 [ 240, %2 ], [ %16, %4 ]
  %21 = tail call i32 @gfx_dither(i32 noundef %18, i32 noundef %19, i32 noundef %20) #8
  %22 = trunc i32 %21 to i8
  store i8 %22, ptr @dfrc, align 1, !tbaa !12
  %23 = load i16, ptr getelementptr inbounds nuw (i8, ptr @gfx_tile, i32 4), align 2, !tbaa !14
  ret i16 %23
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc noundef range(i32 0, 256) i32 @tone(i32 noundef range(i32 0, 65536) %0) unnamed_addr #6 {
  %2 = lshr i32 %0, 3
  %3 = tail call i32 @llvm.umin.i32(i32 %2, i32 255)
  ret i32 %3
}

; Function Attrs: minsize optsize
declare dso_local i32 @gfx_dither(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_dfill(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fill_htrap(i32 noundef range(i32 0, 256) %0, i32 noundef range(i32 0, 256) %1, i32 noundef range(i32 0, 256) %2, i32 noundef range(i32 0, 256) %3, i32 noundef range(i32 0, 256) %4, i32 noundef range(i32 0, 256) %5) unnamed_addr #0 {
  %7 = sub nsw i32 %1, %0
  %8 = icmp slt i32 %7, 1
  br i1 %8, label %33, label %9

9:                                                ; preds = %6
  %10 = shl nuw nsw i32 %2, 12
  %11 = shl nuw nsw i32 %4, 12
  %12 = sub nsw i32 %3, %2
  %13 = shl nsw i32 %12, 12
  %14 = sdiv i32 %13, %7
  %15 = sub nsw i32 %5, %4
  %16 = shl nsw i32 %15, 12
  %17 = sdiv i32 %16, %7
  br label %18

18:                                               ; preds = %29, %9
  %19 = phi i32 [ %11, %9 ], [ %31, %29 ]
  %20 = phi i32 [ %0, %9 ], [ %32, %29 ]
  %21 = phi i32 [ %10, %9 ], [ %30, %29 ]
  %22 = icmp samesign ult i32 %20, %1
  br i1 %22, label %23, label %33

23:                                               ; preds = %18
  %24 = ashr i32 %21, 12
  %25 = ashr i32 %19, 12
  %26 = icmp sgt i32 %25, %24
  br i1 %26, label %27, label %29

27:                                               ; preds = %23
  %28 = sub nsw i32 %25, %24
  tail call void @gfx_dfill(i32 noundef %24, i32 noundef %20, i32 noundef %28, i32 noundef 1) #8
  br label %29

29:                                               ; preds = %27, %23
  %30 = add nsw i32 %21, %14
  %31 = add nsw i32 %19, %17
  %32 = add nuw nsw i32 %20, 1
  br label %18, !llvm.loop !40

33:                                               ; preds = %18, %6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fill_vtrap(i32 noundef range(i32 0, 256) %0, i32 noundef range(i32 0, 256) %1, i32 noundef range(i32 0, 256) %2, i32 noundef range(i32 0, 256) %3, i32 noundef range(i32 0, 256) %4, i32 noundef range(i32 0, 256) %5) unnamed_addr #0 {
  %7 = sub nsw i32 %1, %0
  %8 = icmp slt i32 %7, 1
  br i1 %8, label %33, label %9

9:                                                ; preds = %6
  %10 = shl nuw nsw i32 %2, 12
  %11 = shl nuw nsw i32 %4, 12
  %12 = sub nsw i32 %3, %2
  %13 = shl nsw i32 %12, 12
  %14 = sdiv i32 %13, %7
  %15 = sub nsw i32 %5, %4
  %16 = shl nsw i32 %15, 12
  %17 = sdiv i32 %16, %7
  br label %18

18:                                               ; preds = %29, %9
  %19 = phi i32 [ %11, %9 ], [ %31, %29 ]
  %20 = phi i32 [ %0, %9 ], [ %32, %29 ]
  %21 = phi i32 [ %10, %9 ], [ %30, %29 ]
  %22 = icmp samesign ult i32 %20, %1
  br i1 %22, label %23, label %33

23:                                               ; preds = %18
  %24 = ashr i32 %21, 12
  %25 = ashr i32 %19, 12
  %26 = icmp sgt i32 %25, %24
  br i1 %26, label %27, label %29

27:                                               ; preds = %23
  %28 = sub nsw i32 %25, %24
  tail call void @gfx_dfill(i32 noundef %20, i32 noundef %24, i32 noundef 1, i32 noundef %28) #8
  br label %29

29:                                               ; preds = %27, %23
  %30 = add nsw i32 %21, %14
  %31 = add nsw i32 %19, %17
  %32 = add nuw nsw i32 %20, 1
  br label %18, !llvm.loop !41

33:                                               ; preds = %18, %6
  ret void
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc range(i32 0, 6) i32 @clearance(i32 noundef range(i32 0, -2147483648) %0, i32 noundef range(i32 -2147483648, 3080) %1) unnamed_addr #3 {
  %3 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537059328 to ptr), i32 %0
  %4 = load i16, ptr %3, align 2, !tbaa !14
  %5 = sext i16 %4 to i32
  %6 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537065488 to ptr), i32 %0
  %7 = load i16, ptr %6, align 2, !tbaa !14
  %8 = sext i16 %7 to i32
  %9 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537071648 to ptr), i32 %0
  %10 = load i16, ptr %9, align 2, !tbaa !14
  %11 = sext i16 %10 to i32
  %12 = getelementptr inbounds i16, ptr inttoptr (i32 537059328 to ptr), i32 %1
  %13 = load i16, ptr %12, align 2, !tbaa !14
  %14 = sext i16 %13 to i32
  %15 = sub nsw i32 %14, %5
  %16 = getelementptr inbounds i16, ptr inttoptr (i32 537065488 to ptr), i32 %1
  %17 = load i16, ptr %16, align 2, !tbaa !14
  %18 = sext i16 %17 to i32
  %19 = sub nsw i32 %18, %8
  %20 = getelementptr inbounds i16, ptr inttoptr (i32 537071648 to ptr), i32 %1
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
  %75 = tail call fastcc i32 @in_box(i32 noundef 0, i32 noundef %65, i32 noundef %69, i32 noundef %73) #10
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %77, label %81

77:                                               ; preds = %74, %60
  br i1 %45, label %78, label %83

78:                                               ; preds = %77
  %79 = tail call fastcc i32 @in_box(i32 noundef 1, i32 noundef %65, i32 noundef %69, i32 noundef %73) #10
  %80 = icmp eq i32 %79, 0
  br i1 %80, label %83, label %81

81:                                               ; preds = %78, %74
  %82 = add nsw i32 %52, 1
  br label %83

83:                                               ; preds = %81, %78, %77
  %84 = phi i32 [ %82, %81 ], [ %52, %78 ], [ %52, %77 ]
  %85 = add nuw nsw i32 %53, 1
  br label %51, !llvm.loop !42

86:                                               ; preds = %2, %55
  %87 = phi i32 [ %59, %55 ], [ 5, %2 ]
  ret i32 %87
}

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @in_box(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 -557056, 16285695) %1, i32 noundef range(i32 -557056, 16285695) %2, i32 noundef range(i32 -557056, 16285695) %3) unnamed_addr #6 {
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
declare i32 @llvm.umin.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #7

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !8, !9}
!28 = distinct !{!28, !8, !9}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !8, !9}
!37 = distinct !{!37, !8, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
!40 = distinct !{!40, !8, !9}
!41 = distinct !{!41, !8, !9}
!42 = distinct !{!42, !8, !9}
