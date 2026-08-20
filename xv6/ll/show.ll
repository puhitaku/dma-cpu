; ModuleID = 'dma/show.c'
source_filename = "dma/show.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.fbinfo = type { i32, i32, i32, i32, i32 }
%struct.stat = type { i32, i32, i16, i16, i32 }
%struct.dirent = type { i16, [62 x i8] }

@.str = private unnamed_addr constant [13 x i8] c"show: no fb\0A\00", align 1
@nshow = internal unnamed_addr global i32 0, align 4
@deckfd = internal unnamed_addr global i32 -1, align 4
@.str.1 = private unnamed_addr constant [30 x i8] c"show: no such series in deck\0A\00", align 1
@.str.2 = private unnamed_addr constant [19 x i8] c"show: cannot open\0A\00", align 1
@shownames = internal global [32 x [64 x i8]] zeroinitializer, align 1
@.str.3 = private unnamed_addr constant [57 x i8] c"show: no slides (usage: show DIR|FILE...|DECK [series])\0A\00", align 1
@.str.4 = private unnamed_addr constant [15 x i8] c" slides found\0A\00", align 1
@.str.5 = private unnamed_addr constant [15 x i8] c"show: fb busy\0A\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"jump: \00", align 1
@obuf = internal global [256 x i8] zeroinitializer, align 1
@olen = internal unnamed_addr global i32 0, align 4
@.str.7 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.8 = private unnamed_addr constant [15 x i8] c"UART: jump -> \00", align 1
@.str.9 = private unnamed_addr constant [15 x i8] c"jump: invalid\0A\00", align 1
@.str.10 = private unnamed_addr constant [11 x i8] c"UART: quit\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"UART: right\00", align 1
@.str.12 = private unnamed_addr constant [11 x i8] c"UART: left\00", align 1
@.str.13 = private unnamed_addr constant [13 x i8] c"Joystick: up\00", align 1
@.str.14 = private unnamed_addr constant [15 x i8] c"Joystick: down\00", align 1
@.str.15 = private unnamed_addr constant [15 x i8] c"Joystick: left\00", align 1
@.str.16 = private unnamed_addr constant [16 x i8] c"Joystick: right\00", align 1
@.str.17 = private unnamed_addr constant [15 x i8] c"Joystick: push\00", align 1
@decksz = internal unnamed_addr global i32 0, align 4
@deckoff = internal unnamed_addr global i32 0, align 4
@.str.18 = private unnamed_addr constant [23 x i8] c" slides found (series \00", align 1
@.str.19 = private unnamed_addr constant [3 x i8] c")\0A\00", align 1
@.str.20 = private unnamed_addr constant [21 x i8] c"Start drawing slide \00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c" on FB\0A\00", align 1
@.str.22 = private unnamed_addr constant [20 x i8] c"Done drawing slide \00", align 1
@.str.23 = private unnamed_addr constant [19 x i8] c"show: cannot open \00", align 1
@.str.24 = private unnamed_addr constant [8 x i8] c"Opened \00", align 1
@.str.25 = private unnamed_addr constant [15 x i8] c"Start drawing \00", align 1
@.str.26 = private unnamed_addr constant [7 x i8] c" on FB\00", align 1
@.str.27 = private unnamed_addr constant [14 x i8] c"Done drawing \00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i32 @t_show(i32 noundef %0, ptr noundef %1) #9
  %4 = tail call i32 @exit(i32 noundef %3) #10
  unreachable
}

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_show(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #2 {
  %3 = alloca [16 x i8], align 1
  %4 = alloca [24 x i8], align 1
  %5 = alloca [13 x i8], align 1
  %6 = alloca %struct.fbinfo, align 4
  %7 = alloca %struct.stat, align 4
  %8 = alloca %struct.stat, align 4
  %9 = alloca %struct.dirent, align 2
  %10 = alloca [64 x i8], align 1
  %11 = alloca i8, align 1
  %12 = alloca i8, align 1
  %13 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %6) #11
  %14 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %6) #12
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %2
  %17 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str, i32 noundef 12) #12
  br label %544

18:                                               ; preds = %2
  store i32 0, ptr @nshow, align 4, !tbaa !3
  store i32 -1, ptr @deckfd, align 4, !tbaa !3
  %19 = icmp eq i32 %0, 2
  br i1 %19, label %22, label %20

20:                                               ; preds = %18
  %21 = icmp eq i32 %0, 3
  br i1 %21, label %22, label %326

22:                                               ; preds = %20, %18
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %7) #11
  %23 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %24 = load ptr, ptr %23, align 4, !tbaa !7
  %25 = call i32 @open(ptr noundef %24, i32 noundef 0) #12
  %26 = icmp sgt i32 %25, -1
  br i1 %26, label %27, label %200

27:                                               ; preds = %22
  %28 = call i32 @fstat(i32 noundef %25, ptr noundef nonnull %7) #12
  %29 = icmp eq i32 %28, 0
  %30 = getelementptr inbounds nuw i8, ptr %7, i32 8
  %31 = load i16, ptr %30, align 4
  %32 = icmp eq i16 %31, 2
  %33 = select i1 %29, i1 %32, i1 false
  br i1 %33, label %34, label %198

34:                                               ; preds = %27
  %35 = icmp eq i32 %0, 3
  br i1 %35, label %36, label %39

36:                                               ; preds = %34
  %37 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %38 = load ptr, ptr %37, align 4, !tbaa !7
  br label %39

39:                                               ; preds = %34, %36
  %40 = phi ptr [ %38, %36 ], [ null, %34 ]
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #11
  %41 = call i32 @seek(i32 noundef range(i32 0, -2147483648) %25, i32 noundef 0) #12
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %137, label %43

43:                                               ; preds = %39
  %44 = call i32 @read(i32 noundef range(i32 0, -2147483648) %25, ptr noundef nonnull %3, i32 noundef 16) #12
  %45 = icmp eq i32 %44, 16
  br i1 %45, label %46, label %137

46:                                               ; preds = %43
  %47 = load i8, ptr %3, align 1, !tbaa !10
  %48 = icmp eq i8 %47, 83
  %49 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %50 = load i8, ptr %49, align 1
  %51 = icmp eq i8 %50, 76
  %52 = select i1 %48, i1 %51, i1 false
  %53 = getelementptr inbounds nuw i8, ptr %3, i32 2
  %54 = load i8, ptr %53, align 1
  %55 = icmp eq i8 %54, 68
  %56 = select i1 %52, i1 %55, i1 false
  %57 = getelementptr inbounds nuw i8, ptr %3, i32 3
  %58 = load i8, ptr %57, align 1
  %59 = icmp eq i8 %58, 75
  %60 = select i1 %56, i1 %59, i1 false
  br i1 %60, label %61, label %137

61:                                               ; preds = %46
  %62 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %63 = load i8, ptr %62, align 1, !tbaa !10
  %64 = zext i8 %63 to i32
  %65 = getelementptr inbounds nuw i8, ptr %3, i32 9
  %66 = load i8, ptr %65, align 1, !tbaa !10
  %67 = zext i8 %66 to i32
  %68 = shl nuw nsw i32 %67, 8
  %69 = getelementptr inbounds nuw i8, ptr %3, i32 10
  %70 = load i8, ptr %69, align 1, !tbaa !10
  %71 = zext i8 %70 to i32
  %72 = shl nuw nsw i32 %71, 16
  %73 = getelementptr inbounds nuw i8, ptr %3, i32 11
  %74 = load i8, ptr %73, align 1, !tbaa !10
  %75 = zext i8 %74 to i32
  %76 = shl nuw i32 %75, 24
  %77 = or disjoint i32 %68, %72
  %78 = or disjoint i32 %77, %76
  %79 = or disjoint i32 %78, %64
  %80 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %81 = load i8, ptr %80, align 1, !tbaa !10
  %82 = zext i8 %81 to i32
  %83 = getelementptr inbounds nuw i8, ptr %3, i32 13
  %84 = load i8, ptr %83, align 1, !tbaa !10
  %85 = zext i8 %84 to i32
  %86 = shl nuw nsw i32 %85, 8
  %87 = or disjoint i32 %86, %82
  %88 = getelementptr inbounds nuw i8, ptr %3, i32 14
  %89 = load i8, ptr %88, align 1, !tbaa !10
  %90 = zext i8 %89 to i32
  %91 = shl nuw nsw i32 %90, 16
  %92 = or disjoint i32 %87, %91
  %93 = getelementptr inbounds nuw i8, ptr %3, i32 15
  %94 = load i8, ptr %93, align 1, !tbaa !10
  %95 = zext i8 %94 to i32
  %96 = shl nuw i32 %95, 24
  %97 = or disjoint i32 %92, %96
  store i32 %97, ptr @decksz, align 4, !tbaa !3
  %98 = icmp eq i32 %97, 0
  br i1 %98, label %137, label %99

99:                                               ; preds = %61
  %100 = icmp eq i32 %79, 0
  br i1 %100, label %137, label %101

101:                                              ; preds = %99
  %102 = icmp ugt i32 %79, 16
  br i1 %102, label %137, label %103

103:                                              ; preds = %101
  %104 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %105 = icmp eq ptr %40, null
  br label %106

106:                                              ; preds = %135, %103
  %107 = phi i32 [ %136, %135 ], [ 0, %103 ]
  %108 = icmp eq i32 %107, %64
  br i1 %108, label %137, label %109

109:                                              ; preds = %106
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %4) #11
  %110 = call i32 @read(i32 noundef range(i32 0, -2147483648) %25, ptr noundef nonnull %4, i32 noundef 24) #12
  %111 = icmp eq i32 %110, 24
  br i1 %111, label %113, label %112

112:                                              ; preds = %109
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #11
  br label %195

113:                                              ; preds = %109
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %5) #11
  br label %114

114:                                              ; preds = %118, %113
  %115 = phi i32 [ 0, %113 ], [ %122, %118 ]
  %116 = icmp eq i32 %115, 12
  br i1 %116, label %117, label %118

117:                                              ; preds = %114
  store i8 0, ptr %104, align 1, !tbaa !10
  br i1 %105, label %139, label %123

118:                                              ; preds = %114
  %119 = getelementptr inbounds nuw [24 x i8], ptr %4, i32 0, i32 %115
  %120 = load i8, ptr %119, align 1, !tbaa !10
  %121 = getelementptr inbounds nuw [13 x i8], ptr %5, i32 0, i32 %115
  store i8 %120, ptr %121, align 1, !tbaa !10
  %122 = add nuw nsw i32 %115, 1
  br label %114, !llvm.loop !11

123:                                              ; preds = %117, %131
  %124 = phi ptr [ %132, %131 ], [ %5, %117 ]
  %125 = phi ptr [ %133, %131 ], [ %40, %117 ]
  %126 = load i8, ptr %124, align 1, !tbaa !10
  %127 = icmp ne i8 %126, 0
  %128 = load i8, ptr %125, align 1, !tbaa !10
  %129 = icmp eq i8 %126, %128
  %130 = select i1 %127, i1 %129, i1 false
  br i1 %130, label %131, label %134

131:                                              ; preds = %123
  %132 = getelementptr inbounds nuw i8, ptr %124, i32 1
  %133 = getelementptr inbounds nuw i8, ptr %125, i32 1
  br label %123, !llvm.loop !14

134:                                              ; preds = %123
  br i1 %129, label %139, label %135

135:                                              ; preds = %134
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #11
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #11
  %136 = add nuw nsw i32 %107, 1
  br label %106, !llvm.loop !15

137:                                              ; preds = %106, %43, %39, %46, %101, %99, %61
  %138 = phi i32 [ 0, %61 ], [ 0, %99 ], [ 0, %101 ], [ 0, %46 ], [ 0, %39 ], [ 0, %43 ], [ -1, %106 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #11
  br label %192

139:                                              ; preds = %117, %134
  %140 = getelementptr inbounds nuw i8, ptr %4, i32 16
  %141 = load i8, ptr %140, align 1, !tbaa !10
  %142 = zext i8 %141 to i32
  %143 = getelementptr inbounds nuw i8, ptr %4, i32 17
  %144 = load i8, ptr %143, align 1, !tbaa !10
  %145 = zext i8 %144 to i32
  %146 = shl nuw nsw i32 %145, 8
  %147 = or disjoint i32 %146, %142
  %148 = getelementptr inbounds nuw i8, ptr %4, i32 18
  %149 = load i8, ptr %148, align 1, !tbaa !10
  %150 = zext i8 %149 to i32
  %151 = shl nuw nsw i32 %150, 16
  %152 = or disjoint i32 %147, %151
  %153 = getelementptr inbounds nuw i8, ptr %4, i32 19
  %154 = load i8, ptr %153, align 1, !tbaa !10
  %155 = zext i8 %154 to i32
  %156 = shl nuw i32 %155, 24
  %157 = or disjoint i32 %152, %156
  store i32 %157, ptr @deckoff, align 4, !tbaa !3
  store i32 %25, ptr @deckfd, align 4, !tbaa !3
  store i32 0, ptr @olen, align 4, !tbaa !3
  %158 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %159 = load i8, ptr %158, align 1, !tbaa !10
  %160 = zext i8 %159 to i32
  %161 = getelementptr inbounds nuw i8, ptr %4, i32 13
  %162 = load i8, ptr %161, align 1, !tbaa !10
  %163 = zext i8 %162 to i32
  %164 = shl nuw nsw i32 %163, 8
  %165 = or disjoint i32 %164, %160
  %166 = getelementptr inbounds nuw i8, ptr %4, i32 14
  %167 = load i8, ptr %166, align 1, !tbaa !10
  %168 = zext i8 %167 to i32
  %169 = shl nuw nsw i32 %168, 16
  %170 = or disjoint i32 %165, %169
  %171 = getelementptr inbounds nuw i8, ptr %4, i32 15
  %172 = load i8, ptr %171, align 1, !tbaa !10
  %173 = zext i8 %172 to i32
  %174 = shl nuw i32 %173, 24
  %175 = or disjoint i32 %170, %174
  call fastcc void @emitn(i32 noundef %175) #9
  call fastcc void @emit(ptr noundef nonnull @.str.18) #9
  call fastcc void @emit(ptr noundef nonnull %5) #9
  call fastcc void @emit(ptr noundef nonnull @.str.19) #9
  call fastcc void @flush() #9
  %176 = load i8, ptr %158, align 1, !tbaa !10
  %177 = zext i8 %176 to i32
  %178 = load i8, ptr %161, align 1, !tbaa !10
  %179 = zext i8 %178 to i32
  %180 = shl nuw nsw i32 %179, 8
  %181 = or disjoint i32 %180, %177
  %182 = load i8, ptr %166, align 1, !tbaa !10
  %183 = zext i8 %182 to i32
  %184 = shl nuw nsw i32 %183, 16
  %185 = or disjoint i32 %181, %184
  %186 = load i8, ptr %171, align 1, !tbaa !10
  %187 = zext i8 %186 to i32
  %188 = shl nuw i32 %187, 24
  %189 = or disjoint i32 %185, %188
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #11
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #11
  %190 = icmp sgt i32 %189, 0
  br i1 %190, label %191, label %192

191:                                              ; preds = %139
  store i32 %189, ptr @nshow, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #11
  br label %358

192:                                              ; preds = %137, %139
  %193 = phi i32 [ %138, %137 ], [ %189, %139 ]
  %194 = icmp slt i32 %193, 0
  br i1 %194, label %195, label %198

195:                                              ; preds = %112, %192
  %196 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.1, i32 noundef 29) #12
  %197 = call i32 @close(i32 noundef %25) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #11
  br label %544

198:                                              ; preds = %27, %192
  %199 = call i32 @close(i32 noundef %25) #12
  br label %200

200:                                              ; preds = %198, %22
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #11
  br i1 %19, label %203, label %201

201:                                              ; preds = %200
  %202 = load i32, ptr @nshow, align 4, !tbaa !3
  br label %326

203:                                              ; preds = %200
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %8) #11
  %204 = load ptr, ptr %23, align 4, !tbaa !7
  %205 = call i32 @open(ptr noundef %204, i32 noundef 0) #12
  %206 = icmp slt i32 %205, 0
  br i1 %206, label %324, label %207

207:                                              ; preds = %203
  %208 = call i32 @fstat(i32 noundef %205, ptr noundef nonnull %8) #12
  %209 = icmp slt i32 %208, 0
  br i1 %209, label %324, label %210

210:                                              ; preds = %207
  %211 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %212 = load i16, ptr %211, align 4, !tbaa !16
  %213 = icmp eq i16 %212, 1
  br i1 %213, label %214, label %307

214:                                              ; preds = %210
  %215 = load ptr, ptr %23, align 4, !tbaa !7
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %9) #11
  %216 = getelementptr inbounds nuw i8, ptr %9, i32 2
  br label %217

217:                                              ; preds = %251, %214
  %218 = call i32 @read(i32 noundef %205, ptr noundef nonnull %9, i32 noundef 64) #12
  %219 = icmp eq i32 %218, 64
  br i1 %219, label %220, label %263

220:                                              ; preds = %217
  %221 = load i16, ptr %9, align 2, !tbaa !20
  %222 = icmp eq i16 %221, 0
  br i1 %222, label %251, label %223

223:                                              ; preds = %220, %223
  %224 = phi i32 [ %228, %223 ], [ 0, %220 ]
  %225 = getelementptr inbounds nuw i8, ptr %216, i32 %224
  %226 = load i8, ptr %225, align 1, !tbaa !10
  %227 = icmp eq i8 %226, 0
  %228 = add nuw nsw i32 %224, 1
  br i1 %227, label %229, label %223, !llvm.loop !22

229:                                              ; preds = %223
  %230 = getelementptr inbounds nuw i8, ptr %216, i32 %224
  %231 = icmp samesign ult i32 %224, 4
  br i1 %231, label %251, label %232

232:                                              ; preds = %229
  %233 = getelementptr inbounds i8, ptr %230, i32 -4
  %234 = load i8, ptr %233, align 1, !tbaa !10
  %235 = icmp eq i8 %234, 46
  br i1 %235, label %236, label %251

236:                                              ; preds = %232
  %237 = getelementptr inbounds i8, ptr %230, i32 -3
  %238 = load i8, ptr %237, align 1, !tbaa !10
  switch i8 %238, label %251 [
    i8 115, label %239
    i8 83, label %239
  ]

239:                                              ; preds = %236, %236
  %240 = getelementptr inbounds i8, ptr %230, i32 -2
  %241 = load i8, ptr %240, align 1, !tbaa !10
  switch i8 %241, label %251 [
    i8 108, label %242
    i8 76, label %242
  ]

242:                                              ; preds = %239, %239
  %243 = getelementptr inbounds i8, ptr %230, i32 -1
  %244 = load i8, ptr %243, align 1, !tbaa !10
  switch i8 %244, label %251 [
    i8 100, label %245
    i8 68, label %245
  ]

245:                                              ; preds = %242, %242
  %246 = load i8, ptr %216, align 2, !tbaa !10
  %247 = icmp eq i8 %246, 46
  br i1 %247, label %251, label %248

248:                                              ; preds = %245
  %249 = load i32, ptr @nshow, align 4, !tbaa !3
  %250 = icmp slt i32 %249, 32
  br i1 %250, label %252, label %251

251:                                              ; preds = %248, %255, %220, %229, %232, %236, %239, %242, %245
  br label %217, !llvm.loop !23

252:                                              ; preds = %248, %258
  %253 = phi i32 [ %262, %258 ], [ 0, %248 ]
  %254 = icmp eq i32 %253, 62
  br i1 %254, label %255, label %258

255:                                              ; preds = %252
  %256 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %249, i32 62
  store i8 0, ptr %256, align 1, !tbaa !10
  %257 = add nsw i32 %249, 1
  store i32 %257, ptr @nshow, align 4, !tbaa !3
  br label %251

258:                                              ; preds = %252
  %259 = getelementptr inbounds nuw [62 x i8], ptr %216, i32 0, i32 %253
  %260 = load i8, ptr %259, align 1, !tbaa !10
  %261 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %249, i32 %253
  store i8 %260, ptr %261, align 1, !tbaa !10
  %262 = add nuw nsw i32 %253, 1
  br label %252, !llvm.loop !24

263:                                              ; preds = %217
  %264 = call i32 @close(i32 noundef %205) #12
  br label %265

265:                                              ; preds = %300, %263
  %266 = phi i32 [ 1, %263 ], [ %301, %300 ]
  %267 = load i32, ptr @nshow, align 4, !tbaa !3
  %268 = icmp slt i32 %266, %267
  br i1 %268, label %270, label %269

269:                                              ; preds = %265
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %9) #11
  br label %321

270:                                              ; preds = %265
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #11
  br label %271

271:                                              ; preds = %274, %270
  %272 = phi i32 [ 0, %270 ], [ %278, %274 ]
  %273 = icmp eq i32 %272, 64
  br i1 %273, label %279, label %274

274:                                              ; preds = %271
  %275 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %266, i32 %272
  %276 = load i8, ptr %275, align 1, !tbaa !10
  %277 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %272
  store i8 %276, ptr %277, align 1, !tbaa !10
  %278 = add nuw nsw i32 %272, 1
  br label %271, !llvm.loop !25

279:                                              ; preds = %287, %271
  %280 = phi i32 [ %266, %271 ], [ %281, %287 ]
  %281 = add nsw i32 %280, -1
  %282 = icmp sgt i32 %280, 0
  br i1 %282, label %283, label %295

283:                                              ; preds = %279
  %284 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %281
  %285 = call i32 @strcmp(ptr noundef nonnull %284, ptr noundef nonnull %10) #12
  %286 = icmp sgt i32 %285, 0
  br i1 %286, label %287, label %295

287:                                              ; preds = %283, %290
  %288 = phi i32 [ %294, %290 ], [ 0, %283 ]
  %289 = icmp eq i32 %288, 64
  br i1 %289, label %279, label %290, !llvm.loop !26

290:                                              ; preds = %287
  %291 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %281, i32 %288
  %292 = load i8, ptr %291, align 1, !tbaa !10
  %293 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %280, i32 %288
  store i8 %292, ptr %293, align 1, !tbaa !10
  %294 = add nuw nsw i32 %288, 1
  br label %287, !llvm.loop !27

295:                                              ; preds = %279, %283
  %296 = phi i32 [ 0, %279 ], [ %280, %283 ]
  br label %297

297:                                              ; preds = %302, %295
  %298 = phi i32 [ 0, %295 ], [ %306, %302 ]
  %299 = icmp eq i32 %298, 64
  br i1 %299, label %300, label %302

300:                                              ; preds = %297
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #11
  %301 = add nuw nsw i32 %266, 1
  br label %265, !llvm.loop !28

302:                                              ; preds = %297
  %303 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %298
  %304 = load i8, ptr %303, align 1, !tbaa !10
  %305 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %296, i32 %298
  store i8 %304, ptr %305, align 1, !tbaa !10
  %306 = add nuw nsw i32 %298, 1
  br label %297, !llvm.loop !29

307:                                              ; preds = %210
  %308 = call i32 @close(i32 noundef %205) #12
  br label %309

309:                                              ; preds = %318, %307
  %310 = phi i32 [ 0, %307 ], [ %320, %318 ]
  %311 = load ptr, ptr %23, align 4, !tbaa !7
  %312 = getelementptr inbounds nuw i8, ptr %311, i32 %310
  %313 = load i8, ptr %312, align 1, !tbaa !10
  %314 = icmp ne i8 %313, 0
  %315 = icmp samesign ult i32 %310, 63
  %316 = select i1 %314, i1 %315, i1 false
  br i1 %316, label %318, label %317

317:                                              ; preds = %309
  store i32 1, ptr @nshow, align 4, !tbaa !3
  br label %321

318:                                              ; preds = %309
  %319 = getelementptr inbounds nuw [64 x i8], ptr @shownames, i32 0, i32 %310
  store i8 %313, ptr %319, align 1, !tbaa !10
  %320 = add nuw nsw i32 %310, 1
  br label %309, !llvm.loop !30

321:                                              ; preds = %317, %269
  %322 = phi i32 [ 1, %317 ], [ %267, %269 ]
  %323 = phi ptr [ null, %317 ], [ %215, %269 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #11
  br label %351

324:                                              ; preds = %203, %207
  %325 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.2, i32 noundef 18) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #11
  br label %544

326:                                              ; preds = %201, %20
  %327 = phi i32 [ %202, %201 ], [ 0, %20 ]
  %328 = icmp sgt i32 %0, 2
  br i1 %328, label %329, label %351

329:                                              ; preds = %326, %348
  %330 = phi i32 [ %349, %348 ], [ %327, %326 ]
  %331 = phi i32 [ %350, %348 ], [ 1, %326 ]
  %332 = icmp slt i32 %331, %0
  %333 = icmp slt i32 %330, 32
  %334 = select i1 %332, i1 %333, i1 false
  br i1 %334, label %335, label %351

335:                                              ; preds = %329
  %336 = getelementptr inbounds nuw ptr, ptr %1, i32 %331
  br label %337

337:                                              ; preds = %335, %346
  %338 = phi i32 [ %347, %346 ], [ 0, %335 ]
  %339 = load ptr, ptr %336, align 4, !tbaa !7
  %340 = getelementptr inbounds nuw i8, ptr %339, i32 %338
  %341 = load i8, ptr %340, align 1, !tbaa !10
  %342 = icmp ne i8 %341, 0
  %343 = icmp samesign ult i32 %338, 63
  %344 = select i1 %342, i1 %343, i1 false
  %345 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %330, i32 %338
  br i1 %344, label %346, label %348

346:                                              ; preds = %337
  store i8 %341, ptr %345, align 1, !tbaa !10
  %347 = add nuw nsw i32 %338, 1
  br label %337, !llvm.loop !31

348:                                              ; preds = %337
  store i8 0, ptr %345, align 1, !tbaa !10
  %349 = add nsw i32 %330, 1
  store i32 %349, ptr @nshow, align 4, !tbaa !3
  %350 = add nuw nsw i32 %331, 1
  br label %329, !llvm.loop !32

351:                                              ; preds = %329, %321, %326
  %352 = phi i32 [ %322, %321 ], [ %327, %326 ], [ %330, %329 ]
  %353 = phi ptr [ %323, %321 ], [ null, %326 ], [ null, %329 ]
  %354 = icmp eq i32 %352, 0
  br i1 %354, label %355, label %357

355:                                              ; preds = %351
  %356 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.3, i32 noundef 56) #12
  br label %544

357:                                              ; preds = %351
  call fastcc void @emitn(i32 noundef %352) #9
  call fastcc void @emit(ptr noundef nonnull @.str.4) #9
  call fastcc void @flush() #9
  br label %358

358:                                              ; preds = %191, %357
  %359 = phi i32 [ 1, %191 ], [ 0, %357 ]
  %360 = phi ptr [ null, %191 ], [ %353, %357 ]
  %361 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #12
  %362 = icmp slt i32 %361, 0
  br i1 %362, label %363, label %365

363:                                              ; preds = %358
  %364 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.5, i32 noundef 14) #12
  br label %544

365:                                              ; preds = %358
  %366 = call i32 @ttyraw(i32 noundef 1) #12
  %367 = getelementptr inbounds nuw i8, ptr %6, i32 8
  %368 = load i32, ptr %367, align 4, !tbaa !33
  %369 = getelementptr inbounds nuw i8, ptr %6, i32 16
  %370 = load i32, ptr %369, align 4, !tbaa !35
  %371 = mul i32 %370, %368
  %372 = load i32, ptr %6, align 4, !tbaa !36
  call fastcc void @show_slide(i32 noundef %359, ptr noundef %360, i32 noundef 0, i32 noundef %372, i32 noundef %371) #9
  br label %373

373:                                              ; preds = %534, %365
  %374 = phi i32 [ 0, %365 ], [ %535, %534 ]
  %375 = phi i32 [ 31, %365 ], [ %483, %534 ]
  %376 = phi i32 [ -1, %365 ], [ %389, %534 ]
  %377 = phi i32 [ 0, %365 ], [ %394, %534 ]
  %378 = phi i32 [ 0, %365 ], [ %383, %534 ]
  %379 = phi i32 [ -1, %365 ], [ %522, %534 ]
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %11) #11
  br label %380

380:                                              ; preds = %373, %423
  %381 = phi i32 [ %376, %373 ], [ %428, %423 ]
  %382 = phi i32 [ %377, %373 ], [ %427, %423 ]
  %383 = phi i32 [ %378, %373 ], [ %429, %423 ]
  %384 = phi i32 [ %379, %373 ], [ %391, %423 ]
  %385 = phi i32 [ 0, %373 ], [ %424, %423 ]
  %386 = phi i32 [ 0, %373 ], [ %425, %423 ]
  %387 = call i32 @llvm.usub.sat.i32(i32 %383, i32 1)
  br label %388

388:                                              ; preds = %380, %443
  %389 = phi i32 [ -1, %443 ], [ %381, %380 ]
  %390 = phi i32 [ %394, %443 ], [ %382, %380 ]
  %391 = phi i32 [ %445, %443 ], [ %384, %380 ]
  %392 = icmp sgt i32 %389, -1
  br label %393

393:                                              ; preds = %388, %433
  %394 = phi i32 [ %390, %388 ], [ 1, %433 ]
  br label %395

395:                                              ; preds = %393, %467
  %396 = phi i32 [ %385, %393 ], [ %468, %467 ]
  %397 = phi i32 [ %386, %393 ], [ %469, %467 ]
  br label %398

398:                                              ; preds = %447, %395
  %399 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %11, i32 noundef 1) #12
  %400 = icmp eq i32 %399, 1
  br i1 %400, label %401, label %470

401:                                              ; preds = %398
  %402 = load i8, ptr %11, align 1, !tbaa !10
  %403 = add i8 %402, -48
  %404 = icmp ult i8 %403, 10
  br i1 %392, label %406, label %405

405:                                              ; preds = %401
  br i1 %404, label %407, label %446

406:                                              ; preds = %401
  br i1 %404, label %409, label %433

407:                                              ; preds = %405
  call fastcc void @emit(ptr noundef nonnull @.str.6) #9
  call fastcc void @flush() #9
  %408 = load i8, ptr %11, align 1, !tbaa !10
  br label %411

409:                                              ; preds = %406
  %410 = icmp samesign ult i32 %389, 6
  br i1 %410, label %411, label %423

411:                                              ; preds = %407, %409
  %412 = phi i32 [ %396, %407 ], [ %385, %409 ]
  %413 = phi i32 [ %397, %407 ], [ %386, %409 ]
  %414 = phi i8 [ %408, %407 ], [ %402, %409 ]
  %415 = phi i32 [ 0, %407 ], [ %383, %409 ]
  %416 = phi i32 [ 0, %407 ], [ %394, %409 ]
  %417 = phi i32 [ 0, %407 ], [ %389, %409 ]
  %418 = add nuw nsw i32 %417, 1
  %419 = mul i32 %415, 10
  %420 = sext i8 %414 to i32
  %421 = add i32 %419, -48
  %422 = add i32 %421, %420
  br label %423

423:                                              ; preds = %411, %409
  %424 = phi i32 [ %412, %411 ], [ %385, %409 ]
  %425 = phi i32 [ %413, %411 ], [ %386, %409 ]
  %426 = phi i8 [ %414, %411 ], [ %402, %409 ]
  %427 = phi i32 [ %416, %411 ], [ %394, %409 ]
  %428 = phi i32 [ %418, %411 ], [ %389, %409 ]
  %429 = phi i32 [ %422, %411 ], [ %383, %409 ]
  %430 = load i32, ptr @olen, align 4, !tbaa !3
  %431 = add nsw i32 %430, 1
  store i32 %431, ptr @olen, align 4, !tbaa !3
  %432 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %430
  store i8 %426, ptr %432, align 1, !tbaa !10
  call fastcc void @flush() #9
  br label %380, !llvm.loop !37

433:                                              ; preds = %406
  switch i8 %402, label %393 [
    i8 13, label %434
    i8 10, label %434
  ], !llvm.loop !37

434:                                              ; preds = %433, %433
  call fastcc void @emit(ptr noundef nonnull @.str.7) #9
  %435 = icmp eq i32 %394, 0
  %436 = icmp ne i32 %389, 0
  %437 = select i1 %435, i1 %436, i1 false
  br i1 %437, label %438, label %443

438:                                              ; preds = %434
  %439 = load i32, ptr @nshow, align 4, !tbaa !3
  %440 = add nsw i32 %439, -1
  %441 = call i32 @llvm.smin.i32(i32 %387, i32 %440)
  call fastcc void @emit(ptr noundef nonnull @.str.8) #9
  %442 = add nsw i32 %441, 1
  call fastcc void @emitn(i32 noundef %442) #9
  br label %443

443:                                              ; preds = %434, %438
  %444 = phi ptr [ @.str.7, %438 ], [ @.str.9, %434 ]
  %445 = phi i32 [ %441, %438 ], [ %391, %434 ]
  call fastcc void @emit(ptr noundef nonnull %444) #9
  call fastcc void @flush() #9
  br label %388, !llvm.loop !37

446:                                              ; preds = %405
  switch i8 %402, label %467 [
    i8 13, label %447
    i8 10, label %447
    i8 113, label %448
    i8 3, label %448
    i8 110, label %449
    i8 32, label %449
    i8 108, label %449
    i8 112, label %450
    i8 104, label %450
    i8 27, label %451
  ]

447:                                              ; preds = %446, %446
  br label %398, !llvm.loop !37

448:                                              ; preds = %446, %446
  call fastcc void @show_log(ptr noundef nonnull @.str.10, ptr noundef null, ptr noundef null) #9
  br label %467

449:                                              ; preds = %446, %446, %446
  call fastcc void @show_log(ptr noundef nonnull @.str.11, ptr noundef null, ptr noundef null) #9
  br label %467

450:                                              ; preds = %446, %446
  call fastcc void @show_log(ptr noundef nonnull @.str.12, ptr noundef null, ptr noundef null) #9
  br label %467

451:                                              ; preds = %446
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %12) #11
  store i8 0, ptr %12, align 1, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %13) #11
  store i8 0, ptr %13, align 1, !tbaa !10
  %452 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %12, i32 noundef 1) #12
  %453 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %13, i32 noundef 1) #12
  %454 = load i8, ptr %12, align 1, !tbaa !10
  %455 = icmp eq i8 %454, 91
  %456 = load i8, ptr %13, align 1
  %457 = icmp eq i8 %456, 67
  %458 = select i1 %455, i1 %457, i1 false
  br i1 %458, label %462, label %459

459:                                              ; preds = %451
  %460 = icmp eq i8 %456, 68
  %461 = select i1 %455, i1 %460, i1 false
  br i1 %461, label %462, label %465

462:                                              ; preds = %459, %451
  %463 = phi ptr [ @.str.11, %451 ], [ @.str.12, %459 ]
  %464 = phi i32 [ 1, %451 ], [ -1, %459 ]
  call fastcc void @show_log(ptr noundef nonnull %463, ptr noundef null, ptr noundef null) #9
  br label %465

465:                                              ; preds = %462, %459
  %466 = phi i32 [ %396, %459 ], [ %464, %462 ]
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %13) #11
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %12) #11
  br label %467

467:                                              ; preds = %446, %449, %465, %450, %448
  %468 = phi i32 [ %396, %448 ], [ 1, %449 ], [ -1, %450 ], [ %466, %465 ], [ %396, %446 ]
  %469 = phi i32 [ 1, %448 ], [ %397, %449 ], [ %397, %450 ], [ %397, %465 ], [ %397, %446 ]
  br label %395, !llvm.loop !37

470:                                              ; preds = %398
  %471 = call i32 @gpioctl(i32 noundef 2, i32 noundef 26, i32 noundef 0) #12
  %472 = call i32 @gpioctl(i32 noundef 2, i32 noundef 27, i32 noundef 0) #12
  %473 = shl i32 %472, 1
  %474 = or i32 %473, %471
  %475 = call i32 @gpioctl(i32 noundef 2, i32 noundef 28, i32 noundef 0) #12
  %476 = shl i32 %475, 2
  %477 = or i32 %474, %476
  %478 = call i32 @gpioctl(i32 noundef 2, i32 noundef 29, i32 noundef 0) #12
  %479 = shl i32 %478, 3
  %480 = or i32 %477, %479
  %481 = call i32 @gpioctl(i32 noundef 2, i32 noundef 24, i32 noundef 0) #12
  %482 = shl i32 %481, 4
  %483 = or i32 %480, %482
  %484 = xor i32 %483, -1
  %485 = and i32 %375, %484
  %486 = and i32 %485, 1
  %487 = icmp eq i32 %486, 0
  br i1 %487, label %489, label %488

488:                                              ; preds = %470
  call fastcc void @show_log(ptr noundef nonnull @.str.13, ptr noundef null, ptr noundef null) #9
  br label %489

489:                                              ; preds = %488, %470
  %490 = and i32 %485, 2
  %491 = icmp eq i32 %490, 0
  br i1 %491, label %493, label %492

492:                                              ; preds = %489
  call fastcc void @show_log(ptr noundef nonnull @.str.14, ptr noundef null, ptr noundef null) #9
  br label %493

493:                                              ; preds = %492, %489
  %494 = and i32 %485, 4
  %495 = icmp eq i32 %494, 0
  br i1 %495, label %497, label %496

496:                                              ; preds = %493
  call fastcc void @show_log(ptr noundef nonnull @.str.15, ptr noundef null, ptr noundef null) #9
  br label %497

497:                                              ; preds = %496, %493
  %498 = and i32 %485, 8
  %499 = icmp eq i32 %498, 0
  br i1 %499, label %501, label %500

500:                                              ; preds = %497
  call fastcc void @show_log(ptr noundef nonnull @.str.16, ptr noundef null, ptr noundef null) #9
  br label %501

501:                                              ; preds = %500, %497
  %502 = and i32 %485, 16
  %503 = icmp eq i32 %502, 0
  br i1 %503, label %505, label %504

504:                                              ; preds = %501
  call fastcc void @show_log(ptr noundef nonnull @.str.17, ptr noundef null, ptr noundef null) #9
  br label %505

505:                                              ; preds = %504, %501
  %506 = phi i32 [ 1, %504 ], [ %397, %501 ]
  %507 = and i32 %485, 10
  %508 = icmp eq i32 %507, 0
  %509 = and i32 %485, 5
  %510 = icmp eq i32 %509, 0
  %511 = select i1 %510, i32 %396, i32 -1
  %512 = select i1 %508, i32 %511, i32 1
  %513 = icmp eq i32 %506, 0
  br i1 %513, label %514, label %537

514:                                              ; preds = %505
  %515 = icmp sgt i32 %391, -1
  br i1 %515, label %516, label %520

516:                                              ; preds = %514
  %517 = icmp eq i32 %391, %374
  br i1 %517, label %520, label %518

518:                                              ; preds = %516
  %519 = load i32, ptr %6, align 4, !tbaa !36
  call fastcc void @show_slide(i32 noundef %359, ptr noundef %360, i32 noundef %391, i32 noundef %519, i32 noundef %371) #9
  br label %520

520:                                              ; preds = %516, %518, %514
  %521 = phi i32 [ %374, %514 ], [ %391, %518 ], [ %374, %516 ]
  %522 = phi i32 [ %391, %514 ], [ -1, %518 ], [ -1, %516 ]
  %523 = icmp eq i32 %512, 0
  br i1 %523, label %534, label %524

524:                                              ; preds = %520
  %525 = add nsw i32 %521, %512
  %526 = icmp slt i32 %525, 0
  %527 = load i32, ptr @nshow, align 4
  %528 = add nsw i32 %527, -1
  %529 = select i1 %526, i32 %528, i32 %525
  %530 = icmp slt i32 %529, %527
  %531 = select i1 %530, i32 %529, i32 0
  %532 = load i32, ptr %6, align 4, !tbaa !36
  call fastcc void @show_slide(i32 noundef %359, ptr noundef %360, i32 noundef %531, i32 noundef %532, i32 noundef %371) #9
  %533 = call i32 @pause(i32 noundef 8) #12
  br label %534

534:                                              ; preds = %520, %524
  %535 = phi i32 [ %531, %524 ], [ %521, %520 ]
  %536 = call i32 @pause(i32 noundef 2) #12
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %11) #11
  br label %373

537:                                              ; preds = %505
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %11) #11
  %538 = call i32 @ttyraw(i32 noundef 0) #12
  %539 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #12
  %540 = load i32, ptr @deckfd, align 4, !tbaa !3
  %541 = icmp sgt i32 %540, -1
  br i1 %541, label %542, label %544

542:                                              ; preds = %537
  %543 = call i32 @close(i32 noundef %540) #12
  store i32 -1, ptr @deckfd, align 4, !tbaa !3
  br label %544

544:                                              ; preds = %324, %195, %355, %363, %542, %537, %16
  %545 = phi i32 [ 1, %16 ], [ 1, %355 ], [ 1, %363 ], [ 1, %324 ], [ 1, %195 ], [ 0, %542 ], [ 0, %537 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %6) #11
  ret i32 %545
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @fbctl(i32 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @emitn(i32 noundef %0) unnamed_addr #5 {
  %2 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %2) #11
  br label %3

3:                                                ; preds = %3, %1
  %4 = phi i32 [ %0, %1 ], [ %7, %3 ]
  %5 = phi i32 [ 0, %1 ], [ %12, %3 ]
  %6 = freeze i32 %4
  %7 = udiv i32 %6, 10
  %8 = mul i32 %7, 10
  %9 = sub i32 %6, %8
  %10 = trunc nuw nsw i32 %9 to i8
  %11 = or disjoint i8 %10, 48
  %12 = add nuw nsw i32 %5, 1
  %13 = getelementptr inbounds nuw [12 x i8], ptr %2, i32 0, i32 %5
  store i8 %11, ptr %13, align 1, !tbaa !10
  %14 = icmp ult i32 %4, 10
  br i1 %14, label %15, label %3, !llvm.loop !38

15:                                               ; preds = %3
  %16 = load i32, ptr @olen, align 4, !tbaa !3
  br label %17

17:                                               ; preds = %15, %21
  %18 = phi i32 [ %25, %21 ], [ %16, %15 ]
  %19 = phi i32 [ %22, %21 ], [ %12, %15 ]
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %27, label %21

21:                                               ; preds = %17
  %22 = add nsw i32 %19, -1
  %23 = getelementptr inbounds [12 x i8], ptr %2, i32 0, i32 %22
  %24 = load i8, ptr %23, align 1, !tbaa !10
  %25 = add nsw i32 %18, 1
  %26 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %18
  store i8 %24, ptr %26, align 1, !tbaa !10
  br label %17, !llvm.loop !39

27:                                               ; preds = %17
  store i32 %18, ptr @olen, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %2) #11
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none)
define internal fastcc void @emit(ptr noundef readonly captures(none) %0) unnamed_addr #6 {
  %2 = load i32, ptr @olen, align 4
  br label %3

3:                                                ; preds = %8, %1
  %4 = phi i32 [ %2, %1 ], [ %10, %8 ]
  %5 = phi ptr [ %0, %1 ], [ %9, %8 ]
  %6 = load i8, ptr %5, align 1, !tbaa !10
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %12, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %10 = add nsw i32 %4, 1
  store i32 %10, ptr @olen, align 4, !tbaa !3
  %11 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %4
  store i8 %6, ptr %11, align 1, !tbaa !10
  br label %3, !llvm.loop !40

12:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @flush() unnamed_addr #2 {
  %1 = load i32, ptr @olen, align 4, !tbaa !3
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @obuf, i32 noundef %1) #12
  store i32 0, ptr @olen, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @ttyraw(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_slide(i32 noundef range(i32 0, 2) %0, ptr noundef readonly captures(address_is_null) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) unnamed_addr #2 {
  %6 = alloca [96 x i8], align 1
  %7 = icmp eq i32 %0, 0
  br i1 %7, label %8, label %62

8:                                                ; preds = %5
  %9 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %2
  call void @llvm.lifetime.start.p0(i64 96, ptr nonnull %6) #11
  %10 = icmp eq ptr %1, null
  br i1 %10, label %29, label %11

11:                                               ; preds = %8, %18
  %12 = phi i32 [ %19, %18 ], [ 0, %8 ]
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 %12
  %14 = load i8, ptr %13, align 1, !tbaa !10
  %15 = icmp eq i8 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %11
  %17 = icmp eq i32 %12, 0
  br i1 %17, label %29, label %21

18:                                               ; preds = %11
  %19 = add nuw nsw i32 %12, 1
  %20 = getelementptr inbounds nuw [96 x i8], ptr %6, i32 0, i32 %12
  store i8 %14, ptr %20, align 1, !tbaa !10
  br label %11, !llvm.loop !41

21:                                               ; preds = %16
  %22 = add nsw i32 %12, -1
  %23 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %22
  %24 = load i8, ptr %23, align 1, !tbaa !10
  %25 = icmp eq i8 %24, 47
  br i1 %25, label %29, label %26

26:                                               ; preds = %21
  %27 = add nuw nsw i32 %12, 1
  %28 = getelementptr inbounds nuw [96 x i8], ptr %6, i32 0, i32 %12
  store i8 47, ptr %28, align 1, !tbaa !10
  br label %29

29:                                               ; preds = %26, %21, %16, %8
  %30 = phi i32 [ 0, %8 ], [ 0, %16 ], [ %12, %21 ], [ %27, %26 ]
  br label %31

31:                                               ; preds = %29, %43
  %32 = phi i32 [ %46, %43 ], [ 0, %29 ]
  %33 = phi i32 [ %44, %43 ], [ %30, %29 ]
  %34 = getelementptr inbounds nuw i8, ptr %9, i32 %32
  %35 = load i8, ptr %34, align 1, !tbaa !10
  %36 = icmp ne i8 %35, 0
  %37 = icmp slt i32 %33, 94
  %38 = select i1 %36, i1 %37, i1 false
  br i1 %38, label %43, label %39

39:                                               ; preds = %31
  %40 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 0, ptr %40, align 1, !tbaa !10
  %41 = call i32 @open(ptr noundef nonnull %6, i32 noundef 0) #12
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %60, label %47

43:                                               ; preds = %31
  %44 = add nsw i32 %33, 1
  %45 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 %35, ptr %45, align 1, !tbaa !10
  %46 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !42

47:                                               ; preds = %39
  call fastcc void @show_log(ptr noundef nonnull @.str.24, ptr noundef nonnull %6, ptr noundef null) #9
  call fastcc void @show_log(ptr noundef nonnull @.str.25, ptr noundef nonnull %6, ptr noundef nonnull @.str.26) #9
  br label %48

48:                                               ; preds = %51, %47
  %49 = phi i32 [ 0, %47 ], [ %57, %51 ]
  %50 = icmp ult i32 %49, %4
  br i1 %50, label %51, label %58

51:                                               ; preds = %48
  %52 = add i32 %49, %3
  %53 = inttoptr i32 %52 to ptr
  %54 = sub nuw i32 %4, %49
  %55 = call i32 @read(i32 noundef %41, ptr noundef %53, i32 noundef %54) #12
  %56 = icmp slt i32 %55, 1
  %57 = add i32 %55, %49
  br i1 %56, label %58, label %48

58:                                               ; preds = %51, %48
  %59 = call i32 @close(i32 noundef %41) #12
  call fastcc void @show_expand2x(i32 noundef %3, i32 noundef %4, i32 noundef %49) #9
  br label %60

60:                                               ; preds = %39, %58
  %61 = phi ptr [ @.str.27, %58 ], [ @.str.23, %39 ]
  call fastcc void @show_log(ptr noundef nonnull %61, ptr noundef nonnull %6, ptr noundef null) #9
  call void @llvm.lifetime.end.p0(i64 96, ptr nonnull %6) #11
  br label %84

62:                                               ; preds = %5
  store i32 0, ptr @olen, align 4, !tbaa !3
  tail call fastcc void @emit(ptr noundef nonnull @.str.20) #9
  %63 = add i32 %2, 1
  tail call fastcc void @emitn(i32 noundef %63) #9
  tail call fastcc void @emit(ptr noundef nonnull @.str.21) #9
  tail call fastcc void @flush() #9
  %64 = load i32, ptr @deckfd, align 4, !tbaa !3
  %65 = load i32, ptr @deckoff, align 4, !tbaa !3
  %66 = load i32, ptr @decksz, align 4, !tbaa !3
  %67 = mul i32 %66, %2
  %68 = add i32 %67, %65
  %69 = tail call i32 @seek(i32 noundef %64, i32 noundef %68) #12
  %70 = load i32, ptr @decksz, align 4, !tbaa !3
  %71 = tail call i32 @llvm.umin.i32(i32 %70, i32 %4)
  br label %72

72:                                               ; preds = %75, %62
  %73 = phi i32 [ 0, %62 ], [ %82, %75 ]
  %74 = icmp ult i32 %73, %71
  br i1 %74, label %75, label %83

75:                                               ; preds = %72
  %76 = load i32, ptr @deckfd, align 4, !tbaa !3
  %77 = add i32 %73, %3
  %78 = inttoptr i32 %77 to ptr
  %79 = sub nuw i32 %71, %73
  %80 = tail call i32 @read(i32 noundef %76, ptr noundef %78, i32 noundef %79) #12
  %81 = icmp slt i32 %80, 1
  %82 = add i32 %80, %73
  br i1 %81, label %83, label %72

83:                                               ; preds = %75, %72
  tail call fastcc void @show_expand2x(i32 noundef %3, i32 noundef %4, i32 noundef %73) #9
  store i32 0, ptr @olen, align 4, !tbaa !3
  tail call fastcc void @emit(ptr noundef nonnull @.str.22) #9
  tail call fastcc void @emitn(i32 noundef %63) #9
  tail call fastcc void @emit(ptr noundef nonnull @.str.7) #9
  tail call fastcc void @flush() #9
  br label %84

84:                                               ; preds = %83, %60
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read_nb(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_log(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(address_is_null) %1, ptr noundef readonly captures(address_is_null) %2) unnamed_addr #2 {
  tail call fastcc void @emit(ptr noundef %0) #9
  %4 = icmp eq ptr %1, null
  br i1 %4, label %6, label %5

5:                                                ; preds = %3
  tail call fastcc void @emit(ptr noundef nonnull %1) #9
  br label %6

6:                                                ; preds = %5, %3
  %7 = icmp eq ptr %2, null
  br i1 %7, label %9, label %8

8:                                                ; preds = %6
  tail call fastcc void @emit(ptr noundef nonnull %2) #9
  br label %9

9:                                                ; preds = %8, %6
  tail call fastcc void @emit(ptr noundef nonnull @.str.7) #9
  tail call fastcc void @flush() #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @gpioctl(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @seek(i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @show_expand2x(i32 noundef %0, i32 noundef %1, i32 noundef %2) unnamed_addr #7 {
  %4 = shl i32 %2, 1
  %5 = icmp eq i32 %4, %1
  br i1 %5, label %6, label %31

6:                                                ; preds = %3
  %7 = udiv i32 %2, 640
  %8 = add i32 %0, 640
  br label %9

9:                                                ; preds = %22, %6
  %10 = phi i32 [ %7, %6 ], [ %11, %22 ]
  %11 = add nsw i32 %10, -1
  %12 = icmp sgt i32 %10, 0
  br i1 %12, label %13, label %31

13:                                               ; preds = %9
  %14 = mul nuw i32 %11, 640
  %15 = add i32 %14, %0
  %16 = inttoptr i32 %15 to ptr
  %17 = mul i32 %11, 1280
  %18 = add i32 %17, %0
  %19 = inttoptr i32 %18 to ptr
  %20 = add i32 %8, %17
  %21 = inttoptr i32 %20 to ptr
  br label %22

22:                                               ; preds = %25, %13
  %23 = phi i32 [ 159, %13 ], [ %30, %25 ]
  %24 = icmp sgt i32 %23, -1
  br i1 %24, label %25, label %9, !llvm.loop !43

25:                                               ; preds = %22
  %26 = getelementptr inbounds nuw i32, ptr %16, i32 %23
  %27 = load i32, ptr %26, align 4, !tbaa !3
  %28 = getelementptr inbounds nuw i32, ptr %21, i32 %23
  store i32 %27, ptr %28, align 4, !tbaa !3
  %29 = getelementptr inbounds nuw i32, ptr %19, i32 %23
  store i32 %27, ptr %29, align 4, !tbaa !3
  %30 = add nsw i32 %23, -1
  br label %22, !llvm.loop !44

31:                                               ; preds = %9, %3
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.usub.sat.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #8

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { minsize nobuiltin optsize "no-builtins" }
attributes #10 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #11 = { nounwind }
attributes #12 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"p1 omnipotent char", !9, i64 0}
!9 = !{!"any pointer", !5, i64 0}
!10 = !{!5, !5, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = distinct !{!14, !12, !13}
!15 = distinct !{!15, !12, !13}
!16 = !{!17, !18, i64 8}
!17 = !{!"stat", !4, i64 0, !4, i64 4, !18, i64 8, !18, i64 10, !19, i64 12}
!18 = !{!"short", !5, i64 0}
!19 = !{!"long", !5, i64 0}
!20 = !{!21, !18, i64 0}
!21 = !{!"dirent", !18, i64 0, !5, i64 2}
!22 = distinct !{!22, !12, !13}
!23 = distinct !{!23, !12, !13}
!24 = distinct !{!24, !12, !13}
!25 = distinct !{!25, !12, !13}
!26 = distinct !{!26, !12, !13}
!27 = distinct !{!27, !12, !13}
!28 = distinct !{!28, !12, !13}
!29 = distinct !{!29, !12, !13}
!30 = distinct !{!30, !12, !13}
!31 = distinct !{!31, !12, !13}
!32 = distinct !{!32, !12, !13}
!33 = !{!34, !4, i64 8}
!34 = !{!"fbinfo", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!35 = !{!34, !4, i64 16}
!36 = !{!34, !4, i64 0}
!37 = distinct !{!37, !12, !13}
!38 = distinct !{!38, !12, !13}
!39 = distinct !{!39, !12, !13}
!40 = distinct !{!40, !12, !13}
!41 = distinct !{!41, !12, !13}
!42 = distinct !{!42, !12, !13}
!43 = distinct !{!43, !12, !13}
!44 = distinct !{!44, !12, !13}
