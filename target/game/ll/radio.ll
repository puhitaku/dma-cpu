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
@gam = internal unnamed_addr constant [256 x i8] c"\00\15\1C\22'+.258;=@BDFHJLNPRTUWYZ\\]_`bcefgijkmnoprstuvwxz{|}~\7F\80\81\82\83\84\85\86\87\88\89\8A\8B\8C\8D\8E\8F\90\90\91\92\93\94\95\96\97\97\98\99\9A\9B\9C\9C\9D\9E\9F\A0\A0\A1\A2\A3\A4\A4\A5\A6\A7\A7\A8\A9\AA\AA\AB\AC\AD\AD\AE\AF\AF\B0\B1\B2\B2\B3\B4\B4\B5\B6\B6\B7\B8\B8\B9\BA\BA\BB\BC\BC\BD\BE\BE\BF\C0\C0\C1\C2\C2\C3\C3\C4\C5\C5\C6\C7\C7\C8\C8\C9\CA\CA\CB\CB\CC\CD\CD\CE\CE\CF\CF\D0\D1\D1\D2\D2\D3\D4\D4\D5\D5\D6\D6\D7\D7\D8\D9\D9\DA\DA\DB\DB\DC\DC\DD\DD\DE\DF\DF\E0\E0\E1\E1\E2\E2\E3\E3\E4\E4\E5\E5\E6\E6\E7\E7\E8\E8\E9\E9\EA\EA\EB\EB\EC\EC\ED\ED\EE\EE\EF\EF\F0\F0\F1\F1\F2\F2\F3\F3\F4\F4\F5\F5\F6\F6\F7\F7\F8\F8\F9\F9\F9\FA\FA\FB\FB\FC\FC\FD\FD\FE\FE\FF\FF", align 1

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
  tail call void @uputs(ptr noundef nonnull @.str) #9
  tail call void @aud_borrow() #9
  tail call void @led(i32 noundef 984577, i32 noundef 984577) #9
  tail call void @gfx_clear(i16 noundef zeroext 2114) #9
  call void @llvm.lifetime.start.p0(i64 100, ptr nonnull %10) #10
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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %12) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %13) #10
  call fastcc void @face_point(i32 noundef %100, i32 noundef %123, i32 noundef %115, ptr noundef %11, ptr noundef %12, ptr noundef %13) #11
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
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %13) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %12) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #10
  %144 = add nuw nsw i32 %123, 1
  br label %122, !llvm.loop !18

145:                                              ; preds = %99
  call void @llvm.lifetime.end.p0(i64 100, ptr nonnull %10) #10
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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #10
  %285 = lshr i8 %261, 1
  %286 = zext nneg i8 %285 to i32
  %287 = lshr i8 %264, 1
  %288 = zext nneg i8 %287 to i32
  call fastcc void @face_point(i32 noundef %232, i32 noundef %286, i32 noundef %288, ptr noundef %7, ptr noundef %8, ptr noundef %9) #11
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
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #10
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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #10
  call fastcc void @face_point(i32 noundef %232, i32 noundef %302, i32 noundef %276, ptr noundef %1, ptr noundef %2, ptr noundef %3) #11
  %314 = add nuw nsw i32 %302, 1
  call fastcc void @face_point(i32 noundef %232, i32 noundef %314, i32 noundef %282, ptr noundef %4, ptr noundef %5, ptr noundef %6) #11
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
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #10
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
  %358 = phi i32 [ %368, %360 ], [ 0, %333 ]
  %359 = icmp eq i32 %358, 3080
  br i1 %359, label %369, label %360

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
  %368 = add nuw nsw i32 %358, 1
  br label %357, !llvm.loop !29

369:                                              ; preds = %357, %378
  %370 = phi i32 [ %379, %378 ], [ 9, %357 ]
  %371 = icmp eq i32 %370, 14
  br i1 %371, label %386, label %372

372:                                              ; preds = %369
  %373 = mul nuw nsw i32 %370, 24
  %374 = add nuw nsw i32 %373, 1152
  br label %375

375:                                              ; preds = %380, %372
  %376 = phi i32 [ %385, %380 ], [ 9, %372 ]
  %377 = icmp eq i32 %376, 14
  br i1 %377, label %378, label %380

378:                                              ; preds = %375
  %379 = add nuw nsw i32 %370, 1
  br label %369, !llvm.loop !30

380:                                              ; preds = %375
  %381 = add nuw nsw i32 %374, %376
  %382 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537096288 to ptr), i32 %381
  store i16 -36, ptr %382, align 2, !tbaa !14
  %383 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537102448 to ptr), i32 %381
  store i16 -36, ptr %383, align 2, !tbaa !14
  %384 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537108608 to ptr), i32 %381
  store i16 -6586, ptr %384, align 2, !tbaa !14
  %385 = add nuw nsw i32 %376, 1
  br label %375, !llvm.loop !31

386:                                              ; preds = %369
  tail call fastcc void @repaint(i32 noundef 1) #11
  br label %387

387:                                              ; preds = %408, %386
  %388 = phi i32 [ 0, %386 ], [ %404, %408 ]
  br label %389

389:                                              ; preds = %387, %402
  %390 = phi i1 [ false, %402 ], [ true, %387 ]
  br label %391

391:                                              ; preds = %389, %398
  %392 = phi i1 [ false, %398 ], [ %390, %389 ]
  tail call void @in_poll() #9
  %393 = load i32, ptr @in_edge, align 4, !tbaa !3
  %394 = and i32 %393, 31
  %395 = icmp eq i32 %394, 0
  br i1 %395, label %397, label %396

396:                                              ; preds = %391
  tail call void @led(i32 noundef 0, i32 noundef 0) #9
  tail call void @aud_release() #9
  tail call void @uputs(ptr noundef nonnull @.str.1) #9
  ret void

397:                                              ; preds = %391
  br i1 %392, label %399, label %398

398:                                              ; preds = %397
  tail call void @frame_sync(i32 noundef 33000) #9
  br label %391, !llvm.loop !32

399:                                              ; preds = %397
  %400 = tail call fastcc i32 @brightest() #11
  %401 = icmp slt i32 %400, 0
  br i1 %401, label %402, label %403

402:                                              ; preds = %399
  tail call void @uputs(ptr noundef nonnull @.str.2) #9
  tail call void @uputn(i32 noundef %388) #9
  tail call void @uputs(ptr noundef nonnull @.str.3) #9
  tail call void @led(i32 noundef 265988, i32 noundef 265988) #9
  br label %389, !llvm.loop !32

403:                                              ; preds = %399
  tail call fastcc void @shoot(i32 noundef %400) #11
  %404 = add i32 %388, 1
  tail call fastcc void @repaint(i32 noundef 0) #11
  %405 = and i32 %404, 15
  %406 = icmp eq i32 %405, 0
  br i1 %406, label %407, label %408

407:                                              ; preds = %403
  tail call void @uputs(ptr noundef nonnull @.str.4) #9
  tail call void @uputn(i32 noundef %404) #9
  tail call void @uputs(ptr noundef nonnull @.str.5) #9
  br label %408

408:                                              ; preds = %407, %403
  br label %387
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

6:                                                ; preds = %144, %1
  %7 = phi i32 [ 0, %1 ], [ %145, %144 ]
  %8 = phi i32 [ 0, %1 ], [ %146, %144 ]
  %9 = phi i32 [ 0, %1 ], [ %148, %144 ]
  %10 = phi i32 [ 0, %1 ], [ %147, %144 ]
  %11 = phi i32 [ 0, %1 ], [ %137, %144 ]
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
  br label %149

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
  %32 = tail call fastcc zeroext i16 @patch_color(i32 noundef %9, i32 noundef %31) #11
  br i1 %5, label %33, label %39

33:                                               ; preds = %22
  %34 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %9
  %35 = load i16, ptr %34, align 2, !tbaa !14
  %36 = icmp eq i16 %32, %35
  br i1 %36, label %37, label %39

37:                                               ; preds = %33
  %38 = add nsw i32 %7, 1
  br label %135

39:                                               ; preds = %33, %22
  %40 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %9
  store i16 %32, ptr %40, align 2, !tbaa !14
  %41 = mul nsw i32 %10, 625
  %42 = mul i32 %8, 25
  %43 = add i32 %41, %42
  %44 = add nsw i32 %43, %7
  %45 = shl nsw i32 %44, 1
  %46 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %45
  %47 = add nsw i32 %7, 1
  %48 = add nsw i32 %43, %47
  %49 = shl nsw i32 %48, 1
  %50 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %49
  %51 = add i32 %43, 25
  %52 = add nsw i32 %51, %7
  %53 = shl nsw i32 %52, 1
  %54 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %53
  %55 = add nsw i32 %51, %47
  %56 = shl nsw i32 %55, 1
  %57 = getelementptr inbounds i8, ptr inttoptr (i32 537133056 to ptr), i32 %56
  switch i32 %10, label %118 [
    i32 0, label %58
    i32 1, label %71
    i32 2, label %86
    i32 3, label %101
  ]

58:                                               ; preds = %39
  %59 = load i8, ptr %46, align 2, !tbaa !12
  %60 = zext i8 %59 to i32
  %61 = getelementptr inbounds nuw i8, ptr %46, i32 1
  %62 = load i8, ptr %61, align 1, !tbaa !12
  %63 = zext i8 %62 to i32
  %64 = load i8, ptr %57, align 2, !tbaa !12
  %65 = zext i8 %64 to i32
  %66 = sub nsw i32 %65, %60
  %67 = getelementptr inbounds nuw i8, ptr %57, i32 1
  %68 = load i8, ptr %67, align 1, !tbaa !12
  %69 = zext i8 %68 to i32
  %70 = sub nsw i32 %69, %63
  tail call void @gfx_fill(i32 noundef %60, i32 noundef %63, i32 noundef %66, i32 noundef %70, i16 noundef zeroext %32) #9
  br label %135

71:                                               ; preds = %39
  %72 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %73 = load i8, ptr %72, align 1, !tbaa !12
  %74 = zext i8 %73 to i32
  %75 = getelementptr inbounds nuw i8, ptr %46, i32 1
  %76 = load i8, ptr %75, align 1, !tbaa !12
  %77 = zext i8 %76 to i32
  %78 = load i8, ptr %54, align 2, !tbaa !12
  %79 = zext i8 %78 to i32
  %80 = load i8, ptr %46, align 2, !tbaa !12
  %81 = zext i8 %80 to i32
  %82 = load i8, ptr %57, align 2, !tbaa !12
  %83 = zext i8 %82 to i32
  %84 = load i8, ptr %50, align 2, !tbaa !12
  %85 = zext i8 %84 to i32
  tail call fastcc void @fill_htrap(i32 noundef %74, i32 noundef %77, i32 noundef %79, i32 noundef %81, i32 noundef %83, i32 noundef %85, i16 noundef zeroext %32) #11
  br label %135

86:                                               ; preds = %39
  %87 = getelementptr inbounds nuw i8, ptr %46, i32 1
  %88 = load i8, ptr %87, align 1, !tbaa !12
  %89 = zext i8 %88 to i32
  %90 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %91 = load i8, ptr %90, align 1, !tbaa !12
  %92 = zext i8 %91 to i32
  %93 = load i8, ptr %46, align 2, !tbaa !12
  %94 = zext i8 %93 to i32
  %95 = load i8, ptr %54, align 2, !tbaa !12
  %96 = zext i8 %95 to i32
  %97 = load i8, ptr %50, align 2, !tbaa !12
  %98 = zext i8 %97 to i32
  %99 = load i8, ptr %57, align 2, !tbaa !12
  %100 = zext i8 %99 to i32
  tail call fastcc void @fill_htrap(i32 noundef %89, i32 noundef %92, i32 noundef %94, i32 noundef %96, i32 noundef %98, i32 noundef %100, i16 noundef zeroext %32) #11
  br label %135

101:                                              ; preds = %39
  %102 = load i8, ptr %46, align 2, !tbaa !12
  %103 = zext i8 %102 to i32
  %104 = load i8, ptr %54, align 2, !tbaa !12
  %105 = zext i8 %104 to i32
  %106 = getelementptr inbounds nuw i8, ptr %46, i32 1
  %107 = load i8, ptr %106, align 1, !tbaa !12
  %108 = zext i8 %107 to i32
  %109 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %110 = load i8, ptr %109, align 1, !tbaa !12
  %111 = zext i8 %110 to i32
  %112 = getelementptr inbounds nuw i8, ptr %50, i32 1
  %113 = load i8, ptr %112, align 1, !tbaa !12
  %114 = zext i8 %113 to i32
  %115 = getelementptr inbounds nuw i8, ptr %57, i32 1
  %116 = load i8, ptr %115, align 1, !tbaa !12
  %117 = zext i8 %116 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %103, i32 noundef %105, i32 noundef %108, i32 noundef %111, i32 noundef %114, i32 noundef %117, i16 noundef zeroext %32) #11
  br label %135

118:                                              ; preds = %39
  %119 = load i8, ptr %54, align 2, !tbaa !12
  %120 = zext i8 %119 to i32
  %121 = load i8, ptr %46, align 2, !tbaa !12
  %122 = zext i8 %121 to i32
  %123 = getelementptr inbounds nuw i8, ptr %54, i32 1
  %124 = load i8, ptr %123, align 1, !tbaa !12
  %125 = zext i8 %124 to i32
  %126 = getelementptr inbounds nuw i8, ptr %46, i32 1
  %127 = load i8, ptr %126, align 1, !tbaa !12
  %128 = zext i8 %127 to i32
  %129 = getelementptr inbounds nuw i8, ptr %57, i32 1
  %130 = load i8, ptr %129, align 1, !tbaa !12
  %131 = zext i8 %130 to i32
  %132 = getelementptr inbounds nuw i8, ptr %50, i32 1
  %133 = load i8, ptr %132, align 1, !tbaa !12
  %134 = zext i8 %133 to i32
  tail call fastcc void @fill_vtrap(i32 noundef %120, i32 noundef %122, i32 noundef %125, i32 noundef %128, i32 noundef %131, i32 noundef %134, i16 noundef zeroext %32) #11
  br label %135

135:                                              ; preds = %37, %118, %101, %86, %71, %58
  %136 = phi i32 [ %38, %37 ], [ %47, %118 ], [ %47, %101 ], [ %47, %86 ], [ %47, %71 ], [ %47, %58 ]
  %137 = phi i32 [ %11, %37 ], [ 1, %118 ], [ 1, %101 ], [ 1, %86 ], [ 1, %71 ], [ 1, %58 ]
  %138 = icmp eq i32 %136, 24
  br i1 %138, label %139, label %144

139:                                              ; preds = %135
  %140 = add nsw i32 %8, 1
  %141 = icmp eq i32 %140, 24
  br i1 %141, label %142, label %144

142:                                              ; preds = %139
  %143 = add nsw i32 %10, 1
  br label %144

144:                                              ; preds = %139, %142, %135
  %145 = phi i32 [ 0, %142 ], [ 0, %139 ], [ %136, %135 ]
  %146 = phi i32 [ 0, %142 ], [ %140, %139 ], [ %8, %135 ]
  %147 = phi i32 [ %143, %142 ], [ %10, %139 ], [ %10, %135 ]
  %148 = add nuw nsw i32 %9, 1
  br label %6, !llvm.loop !33

149:                                              ; preds = %13, %299
  %150 = phi i32 [ %300, %299 ], [ 2880, %13 ]
  %151 = icmp eq i32 %150, 3044
  br i1 %151, label %152, label %153

152:                                              ; preds = %149
  tail call void @gfx_present() #9
  ret void

153:                                              ; preds = %149
  %154 = tail call fastcc zeroext i16 @patch_color(i32 noundef %150, i32 noundef 0) #11
  br i1 %15, label %155, label %159

155:                                              ; preds = %153
  %156 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %150
  %157 = load i16, ptr %156, align 2, !tbaa !14
  %158 = icmp eq i16 %154, %157
  br i1 %158, label %299, label %159

159:                                              ; preds = %155, %153
  %160 = getelementptr inbounds nuw i16, ptr inttoptr (i32 537114768 to ptr), i32 %150
  store i16 %154, ptr %160, align 2, !tbaa !14
  %161 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537120928 to ptr), i32 %150
  %162 = load i8, ptr %161, align 1, !tbaa !12
  %163 = zext i8 %162 to i32
  %164 = add nsw i32 %163, -5
  %165 = getelementptr inbounds i16, ptr inttoptr (i32 537140184 to ptr), i32 %164
  %166 = load i16, ptr %165, align 2, !tbaa !14
  %167 = icmp eq i16 %166, 0
  br i1 %167, label %299, label %168

168:                                              ; preds = %159
  %169 = getelementptr i8, ptr inttoptr (i32 537136914 to ptr), i32 %150
  %170 = load i8, ptr %169, align 1, !tbaa !12
  %171 = zext i8 %170 to i32
  %172 = and i32 %171, 15
  %173 = lshr i32 %171, 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #10
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #10
  %174 = getelementptr inbounds [10 x i16], ptr @CGOFF, i32 0, i32 %164
  %175 = load i16, ptr %174, align 2, !tbaa !14
  %176 = zext i16 %175 to i32
  %177 = getelementptr inbounds [10 x i8], ptr @NFI, i32 0, i32 %164
  %178 = load i8, ptr %177, align 1, !tbaa !12
  %179 = zext i8 %178 to i32
  %180 = add nuw nsw i32 %179, 1
  %181 = mul nuw nsw i32 %180, %173
  %182 = add nuw nsw i32 %181, %176
  %183 = add nuw nsw i32 %182, %172
  %184 = shl nuw nsw i32 %183, 1
  %185 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %184
  %186 = add nuw nsw i32 %172, 1
  %187 = add nuw nsw i32 %182, %186
  %188 = shl nuw nsw i32 %187, 1
  %189 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %188
  %190 = add nuw nsw i32 %173, 1
  %191 = mul nuw nsw i32 %180, %190
  %192 = add nuw nsw i32 %191, %176
  %193 = add nuw nsw i32 %192, %186
  %194 = shl nuw nsw i32 %193, 1
  %195 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %194
  %196 = add nuw nsw i32 %192, %172
  %197 = shl nuw nsw i32 %196, 1
  %198 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537139306 to ptr), i32 %197
  %199 = load i8, ptr %185, align 2, !tbaa !12
  %200 = zext i8 %199 to i32
  store i32 %200, ptr %3, align 4, !tbaa !3
  %201 = getelementptr inbounds nuw i8, ptr %185, i32 1
  %202 = load i8, ptr %201, align 1, !tbaa !12
  %203 = zext i8 %202 to i32
  store i32 %203, ptr %4, align 4, !tbaa !3
  %204 = load i8, ptr %189, align 2, !tbaa !12
  %205 = zext i8 %204 to i32
  store i32 %205, ptr %16, align 4, !tbaa !3
  %206 = getelementptr inbounds nuw i8, ptr %189, i32 1
  %207 = load i8, ptr %206, align 1, !tbaa !12
  %208 = zext i8 %207 to i32
  store i32 %208, ptr %17, align 4, !tbaa !3
  %209 = load i8, ptr %195, align 2, !tbaa !12
  %210 = zext i8 %209 to i32
  store i32 %210, ptr %18, align 4, !tbaa !3
  %211 = getelementptr inbounds nuw i8, ptr %195, i32 1
  %212 = load i8, ptr %211, align 1, !tbaa !12
  %213 = zext i8 %212 to i32
  store i32 %213, ptr %19, align 4, !tbaa !3
  %214 = load i8, ptr %198, align 2, !tbaa !12
  %215 = zext i8 %214 to i32
  store i32 %215, ptr %20, align 4, !tbaa !3
  %216 = getelementptr inbounds nuw i8, ptr %198, i32 1
  %217 = load i8, ptr %216, align 1, !tbaa !12
  %218 = zext i8 %217 to i32
  store i32 %218, ptr %21, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #10
  br label %219

219:                                              ; preds = %243, %168
  %220 = phi i32 [ 0, %168 ], [ %229, %243 ]
  %221 = phi i32 [ %200, %168 ], [ %228, %243 ]
  %222 = phi i32 [ %200, %168 ], [ %227, %243 ]
  %223 = icmp eq i32 %220, 4
  br i1 %223, label %246, label %224

224:                                              ; preds = %219
  %225 = getelementptr inbounds nuw i32, ptr %3, i32 %220
  %226 = load i32, ptr %225, align 4, !tbaa !3
  %227 = tail call i32 @llvm.smin.i32(i32 %226, i32 %222)
  %228 = tail call i32 @llvm.smax.i32(i32 %226, i32 %221)
  %229 = add nuw nsw i32 %220, 1
  %230 = and i32 %229, 3
  %231 = getelementptr inbounds nuw i32, ptr %3, i32 %230
  %232 = load i32, ptr %231, align 4, !tbaa !3
  %233 = icmp eq i32 %232, %226
  br i1 %233, label %243, label %234

234:                                              ; preds = %224
  %235 = sub nsw i32 %232, %226
  %236 = getelementptr inbounds nuw i32, ptr %4, i32 %230
  %237 = load i32, ptr %236, align 4, !tbaa !3
  %238 = getelementptr inbounds nuw i32, ptr %4, i32 %220
  %239 = load i32, ptr %238, align 4, !tbaa !3
  %240 = sub nsw i32 %237, %239
  %241 = shl i32 %240, 12
  %242 = sdiv i32 %241, %235
  br label %243

243:                                              ; preds = %234, %224
  %244 = phi i32 [ %242, %234 ], [ 0, %224 ]
  %245 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %220
  store i32 %244, ptr %245, align 4, !tbaa !3
  br label %219, !llvm.loop !34

246:                                              ; preds = %219, %296
  %247 = phi i32 [ %297, %296 ], [ %222, %219 ]
  %248 = icmp sgt i32 %247, %221
  br i1 %248, label %298, label %249

249:                                              ; preds = %246, %282
  %250 = phi i32 [ %283, %282 ], [ 32767, %246 ]
  %251 = phi i32 [ %284, %282 ], [ -32768, %246 ]
  %252 = phi i32 [ %261, %282 ], [ 0, %246 ]
  br label %253

253:                                              ; preds = %270, %249
  %254 = phi i32 [ %252, %249 ], [ %261, %270 ]
  %255 = icmp eq i32 %254, 4
  br i1 %255, label %256, label %258

256:                                              ; preds = %253
  %257 = icmp sgt i32 %251, %250
  br i1 %257, label %294, label %296

258:                                              ; preds = %253
  %259 = getelementptr inbounds nuw i32, ptr %3, i32 %254
  %260 = load i32, ptr %259, align 4, !tbaa !3
  %261 = add nuw nsw i32 %254, 1
  %262 = and i32 %261, 3
  %263 = getelementptr inbounds nuw i32, ptr %3, i32 %262
  %264 = load i32, ptr %263, align 4, !tbaa !3
  %265 = tail call i32 @llvm.smin.i32(i32 %260, i32 %264)
  %266 = icmp slt i32 %247, %265
  br i1 %266, label %270, label %267

267:                                              ; preds = %258
  %268 = tail call i32 @llvm.smax.i32(i32 %260, i32 %264)
  %269 = icmp sgt i32 %247, %268
  br i1 %269, label %270, label %271

270:                                              ; preds = %267, %258
  br label %253, !llvm.loop !35

271:                                              ; preds = %267
  %272 = icmp eq i32 %260, %264
  %273 = getelementptr inbounds nuw i32, ptr %4, i32 %254
  %274 = load i32, ptr %273, align 4, !tbaa !3
  br i1 %272, label %275, label %285

275:                                              ; preds = %271
  %276 = getelementptr inbounds nuw i32, ptr %4, i32 %262
  %277 = load i32, ptr %276, align 4, !tbaa !3
  %278 = tail call i32 @llvm.smin.i32(i32 %277, i32 %274)
  %279 = tail call i32 @llvm.smax.i32(i32 %277, i32 %274)
  %280 = tail call i32 @llvm.smin.i32(i32 %278, i32 %250)
  %281 = tail call i32 @llvm.smax.i32(i32 %279, i32 %251)
  br label %282

282:                                              ; preds = %275, %285
  %283 = phi i32 [ %292, %285 ], [ %280, %275 ]
  %284 = phi i32 [ %293, %285 ], [ %281, %275 ]
  br label %249, !llvm.loop !35

285:                                              ; preds = %271
  %286 = getelementptr inbounds nuw [4 x i32], ptr %2, i32 0, i32 %254
  %287 = load i32, ptr %286, align 4, !tbaa !3
  %288 = sub nsw i32 %247, %260
  %289 = mul nsw i32 %287, %288
  %290 = ashr i32 %289, 12
  %291 = add nsw i32 %290, %274
  %292 = tail call i32 @llvm.smin.i32(i32 %291, i32 %250)
  %293 = tail call i32 @llvm.smax.i32(i32 %291, i32 %251)
  br label %282

294:                                              ; preds = %256
  %295 = sub nsw i32 %251, %250
  tail call void @gfx_fill(i32 noundef %247, i32 noundef %250, i32 noundef 1, i32 noundef %295, i16 noundef zeroext %154) #9
  br label %296

296:                                              ; preds = %294, %256
  %297 = add nsw i32 %247, 1
  br label %246, !llvm.loop !36

298:                                              ; preds = %246
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #10
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #10
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #10
  br label %299

299:                                              ; preds = %298, %159, %155
  %300 = add nuw nsw i32 %150, 1
  br label %149, !llvm.loop !37
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
  %94 = tail call fastcc i32 @clearance(i32 noundef %0, i32 noundef %38) #11
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

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc zeroext i16 @patch_color(i32 noundef range(i32 -2147483648, 3044) %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #6 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %4, label %36

4:                                                ; preds = %2
  %5 = getelementptr inbounds i16, ptr inttoptr (i32 537077808 to ptr), i32 %0
  %6 = load i16, ptr %5, align 2, !tbaa !14
  %7 = lshr i16 %6, 3
  %8 = tail call i16 @llvm.umin.i16(i16 %7, i16 255)
  %9 = zext nneg i16 %8 to i32
  %10 = getelementptr inbounds nuw [256 x i8], ptr @gam, i32 0, i32 %9
  %11 = load i8, ptr %10, align 1, !tbaa !12
  %12 = zext i8 %11 to i16
  %13 = shl nuw i16 %12, 8
  %14 = and i16 %13, -2048
  %15 = getelementptr inbounds i16, ptr inttoptr (i32 537083968 to ptr), i32 %0
  %16 = load i16, ptr %15, align 2, !tbaa !14
  %17 = lshr i16 %16, 3
  %18 = tail call i16 @llvm.umin.i16(i16 %17, i16 255)
  %19 = zext nneg i16 %18 to i32
  %20 = getelementptr inbounds nuw [256 x i8], ptr @gam, i32 0, i32 %19
  %21 = load i8, ptr %20, align 1, !tbaa !12
  %22 = zext i8 %21 to i16
  %23 = shl nuw nsw i16 %22, 3
  %24 = and i16 %23, 2016
  %25 = or disjoint i16 %24, %14
  %26 = getelementptr inbounds i16, ptr inttoptr (i32 537090128 to ptr), i32 %0
  %27 = load i16, ptr %26, align 2, !tbaa !14
  %28 = lshr i16 %27, 3
  %29 = tail call i16 @llvm.umin.i16(i16 %28, i16 255)
  %30 = zext nneg i16 %29 to i32
  %31 = getelementptr inbounds nuw [256 x i8], ptr @gam, i32 0, i32 %30
  %32 = load i8, ptr %31, align 1, !tbaa !12
  %33 = lshr i8 %32, 3
  %34 = zext nneg i8 %33 to i16
  %35 = or disjoint i16 %25, %34
  br label %36

36:                                               ; preds = %2, %4
  %37 = phi i16 [ %35, %4 ], [ -2, %2 ]
  ret i16 %37
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
  tail call void @gfx_fill(i32 noundef %25, i32 noundef %21, i32 noundef %29, i32 noundef 1, i16 noundef zeroext %6) #9
  br label %30

30:                                               ; preds = %28, %24
  %31 = add nsw i32 %22, %15
  %32 = add nsw i32 %20, %18
  %33 = add nuw nsw i32 %21, 1
  br label %19, !llvm.loop !40

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
  tail call void @gfx_fill(i32 noundef %21, i32 noundef %25, i32 noundef 1, i32 noundef %29, i16 noundef zeroext %6) #9
  br label %30

30:                                               ; preds = %28, %24
  %31 = add nsw i32 %22, %15
  %32 = add nsw i32 %20, %18
  %33 = add nuw nsw i32 %21, 1
  br label %19, !llvm.loop !41

34:                                               ; preds = %19, %7
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
  %75 = tail call fastcc i32 @in_box(i32 noundef 0, i32 noundef %65, i32 noundef %69, i32 noundef %73) #11
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %77, label %81

77:                                               ; preds = %74, %60
  br i1 %45, label %78, label %83

78:                                               ; preds = %77
  %79 = tail call fastcc i32 @in_box(i32 noundef 1, i32 noundef %65, i32 noundef %69, i32 noundef %73) #11
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
define internal fastcc range(i32 0, 2) i32 @in_box(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 -557056, 16285695) %1, i32 noundef range(i32 -557056, 16285695) %2, i32 noundef range(i32 -557056, 16285695) %3) unnamed_addr #7 {
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
declare i32 @llvm.umin.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.umin.i16(i16, i16) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #8

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree noinline norecurse nosync nounwind optsize memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #10 = { nounwind }
attributes #11 = { minsize nobuiltin optsize "no-builtins" }

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
