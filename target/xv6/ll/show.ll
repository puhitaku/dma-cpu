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
@.str.1 = private unnamed_addr constant [6 x i8] c"under\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"43\00", align 1
@.str.3 = private unnamed_addr constant [30 x i8] c"show: no such series in deck\0A\00", align 1
@.str.4 = private unnamed_addr constant [19 x i8] c"show: cannot open\0A\00", align 1
@shownames = internal global [32 x [64 x i8]] zeroinitializer, align 1
@.str.5 = private unnamed_addr constant [65 x i8] c"show: no slides (usage: show DIR|FILE...|DECK [43|169] [under])\0A\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c" slides found\0A\00", align 1
@.str.7 = private unnamed_addr constant [15 x i8] c"show: fb busy\0A\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"jump: \00", align 1
@obuf = internal global [256 x i8] zeroinitializer, align 1
@olen = internal unnamed_addr global i32 0, align 4
@.str.9 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"UART: jump -> \00", align 1
@.str.11 = private unnamed_addr constant [15 x i8] c"jump: invalid\0A\00", align 1
@.str.12 = private unnamed_addr constant [11 x i8] c"UART: quit\00", align 1
@.str.13 = private unnamed_addr constant [12 x i8] c"UART: right\00", align 1
@.str.14 = private unnamed_addr constant [11 x i8] c"UART: left\00", align 1
@.str.15 = private unnamed_addr constant [13 x i8] c"Joystick: up\00", align 1
@.str.16 = private unnamed_addr constant [15 x i8] c"Joystick: down\00", align 1
@.str.17 = private unnamed_addr constant [15 x i8] c"Joystick: left\00", align 1
@.str.18 = private unnamed_addr constant [16 x i8] c"Joystick: right\00", align 1
@.str.19 = private unnamed_addr constant [15 x i8] c"Joystick: push\00", align 1
@decksz = internal unnamed_addr global i32 0, align 4
@deckoff = internal unnamed_addr global i32 0, align 4
@.str.20 = private unnamed_addr constant [23 x i8] c" slides found (series \00", align 1
@.str.21 = private unnamed_addr constant [3 x i8] c")\0A\00", align 1
@.str.22 = private unnamed_addr constant [21 x i8] c"Start drawing slide \00", align 1
@.str.23 = private unnamed_addr constant [8 x i8] c" on FB\0A\00", align 1
@.str.24 = private unnamed_addr constant [20 x i8] c"Done drawing slide \00", align 1
@.str.25 = private unnamed_addr constant [19 x i8] c"show: cannot open \00", align 1
@.str.26 = private unnamed_addr constant [8 x i8] c"Opened \00", align 1
@.str.27 = private unnamed_addr constant [15 x i8] c"Start drawing \00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c" on FB\00", align 1
@.str.29 = private unnamed_addr constant [14 x i8] c"Done drawing \00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i32 @t_show(i32 noundef %0, ptr noundef %1) #10
  %4 = tail call i32 @exit(i32 noundef %3) #11
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
  %8 = alloca [13 x i8], align 1
  %9 = alloca %struct.stat, align 4
  %10 = alloca %struct.dirent, align 2
  %11 = alloca [64 x i8], align 1
  %12 = alloca i8, align 1
  %13 = alloca i8, align 1
  %14 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %6) #12
  %15 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %6) #13
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %17, label %19

17:                                               ; preds = %2
  %18 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str, i32 noundef 12) #13
  br label %580

19:                                               ; preds = %2
  store i32 0, ptr @nshow, align 4, !tbaa !3
  store i32 -1, ptr @deckfd, align 4, !tbaa !3
  %20 = add i32 %0, -2
  %21 = icmp ult i32 %20, 3
  br i1 %21, label %22, label %358

22:                                               ; preds = %19
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %7) #12
  %23 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %24 = load ptr, ptr %23, align 4, !tbaa !7
  %25 = call i32 @open(ptr noundef %24, i32 noundef 0) #13
  %26 = icmp sgt i32 %25, -1
  br i1 %26, label %27, label %228

27:                                               ; preds = %22
  %28 = call i32 @fstat(i32 noundef %25, ptr noundef nonnull %7) #13
  %29 = icmp eq i32 %28, 0
  %30 = getelementptr inbounds nuw i8, ptr %7, i32 8
  %31 = load i16, ptr %30, align 4
  %32 = icmp eq i16 %31, 2
  %33 = select i1 %29, i1 %32, i1 false
  br i1 %33, label %34, label %221

34:                                               ; preds = %27
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %8) #12
  br label %35

35:                                               ; preds = %42, %34
  %36 = phi i32 [ 0, %34 ], [ %47, %42 ]
  %37 = phi ptr [ null, %34 ], [ %48, %42 ]
  %38 = phi i32 [ 2, %34 ], [ %49, %42 ]
  %39 = icmp eq i32 %38, %0
  br i1 %39, label %40, label %42

40:                                               ; preds = %35
  %41 = icmp eq ptr %37, null
  br i1 %41, label %50, label %52

42:                                               ; preds = %35
  %43 = getelementptr inbounds nuw ptr, ptr %1, i32 %38
  %44 = load ptr, ptr %43, align 4, !tbaa !7
  %45 = call fastcc i32 @streq(ptr noundef %44, ptr noundef nonnull @.str.1) #10
  %46 = icmp eq i32 %45, 0
  %47 = select i1 %46, i32 %36, i32 1
  %48 = select i1 %46, ptr %44, ptr %37
  %49 = add nuw i32 %38, 1
  br label %35, !llvm.loop !10

50:                                               ; preds = %40
  %51 = icmp eq i32 %36, 0
  br i1 %51, label %72, label %52

52:                                               ; preds = %50, %40
  %53 = phi ptr [ @.str.2, %50 ], [ %37, %40 ]
  br label %54

54:                                               ; preds = %61, %52
  %55 = phi i32 [ 0, %52 ], [ %63, %61 ]
  %56 = getelementptr inbounds nuw i8, ptr %53, i32 %55
  %57 = load i8, ptr %56, align 1, !tbaa !13
  %58 = icmp ne i8 %57, 0
  %59 = icmp samesign ult i32 %55, 11
  %60 = select i1 %58, i1 %59, i1 false
  br i1 %60, label %61, label %64

61:                                               ; preds = %54
  %62 = getelementptr inbounds nuw [13 x i8], ptr %8, i32 0, i32 %55
  store i8 %57, ptr %62, align 1, !tbaa !13
  %63 = add nuw nsw i32 %55, 1
  br label %54, !llvm.loop !14

64:                                               ; preds = %54
  %65 = icmp eq i32 %36, 0
  br i1 %65, label %69, label %66

66:                                               ; preds = %64
  %67 = add nuw nsw i32 %55, 1
  %68 = getelementptr inbounds nuw [13 x i8], ptr %8, i32 0, i32 %55
  store i8 117, ptr %68, align 1, !tbaa !13
  br label %69

69:                                               ; preds = %66, %64
  %70 = phi i32 [ %67, %66 ], [ %55, %64 ]
  %71 = getelementptr inbounds [13 x i8], ptr %8, i32 0, i32 %70
  store i8 0, ptr %71, align 1, !tbaa !13
  br label %72

72:                                               ; preds = %69, %50
  %73 = phi ptr [ %8, %69 ], [ null, %50 ]
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #12
  %74 = call i32 @seek(i32 noundef range(i32 0, -2147483648) %25, i32 noundef 0) #13
  %75 = icmp slt i32 %74, 0
  br i1 %75, label %161, label %76

76:                                               ; preds = %72
  %77 = call i32 @read(i32 noundef range(i32 0, -2147483648) %25, ptr noundef nonnull %3, i32 noundef 16) #13
  %78 = icmp eq i32 %77, 16
  br i1 %78, label %79, label %161

79:                                               ; preds = %76
  %80 = load i8, ptr %3, align 1, !tbaa !13
  %81 = icmp eq i8 %80, 83
  %82 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %83 = load i8, ptr %82, align 1
  %84 = icmp eq i8 %83, 76
  %85 = select i1 %81, i1 %84, i1 false
  %86 = getelementptr inbounds nuw i8, ptr %3, i32 2
  %87 = load i8, ptr %86, align 1
  %88 = icmp eq i8 %87, 68
  %89 = select i1 %85, i1 %88, i1 false
  %90 = getelementptr inbounds nuw i8, ptr %3, i32 3
  %91 = load i8, ptr %90, align 1
  %92 = icmp eq i8 %91, 75
  %93 = select i1 %89, i1 %92, i1 false
  br i1 %93, label %94, label %161

94:                                               ; preds = %79
  %95 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %96 = load i8, ptr %95, align 1, !tbaa !13
  %97 = zext i8 %96 to i32
  %98 = getelementptr inbounds nuw i8, ptr %3, i32 9
  %99 = load i8, ptr %98, align 1, !tbaa !13
  %100 = zext i8 %99 to i32
  %101 = shl nuw nsw i32 %100, 8
  %102 = getelementptr inbounds nuw i8, ptr %3, i32 10
  %103 = load i8, ptr %102, align 1, !tbaa !13
  %104 = zext i8 %103 to i32
  %105 = shl nuw nsw i32 %104, 16
  %106 = getelementptr inbounds nuw i8, ptr %3, i32 11
  %107 = load i8, ptr %106, align 1, !tbaa !13
  %108 = zext i8 %107 to i32
  %109 = shl nuw i32 %108, 24
  %110 = or disjoint i32 %101, %105
  %111 = or disjoint i32 %110, %109
  %112 = or disjoint i32 %111, %97
  %113 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %114 = load i8, ptr %113, align 1, !tbaa !13
  %115 = zext i8 %114 to i32
  %116 = getelementptr inbounds nuw i8, ptr %3, i32 13
  %117 = load i8, ptr %116, align 1, !tbaa !13
  %118 = zext i8 %117 to i32
  %119 = shl nuw nsw i32 %118, 8
  %120 = or disjoint i32 %119, %115
  %121 = getelementptr inbounds nuw i8, ptr %3, i32 14
  %122 = load i8, ptr %121, align 1, !tbaa !13
  %123 = zext i8 %122 to i32
  %124 = shl nuw nsw i32 %123, 16
  %125 = or disjoint i32 %120, %124
  %126 = getelementptr inbounds nuw i8, ptr %3, i32 15
  %127 = load i8, ptr %126, align 1, !tbaa !13
  %128 = zext i8 %127 to i32
  %129 = shl nuw i32 %128, 24
  %130 = or disjoint i32 %125, %129
  store i32 %130, ptr @decksz, align 4, !tbaa !3
  %131 = icmp eq i32 %130, 0
  br i1 %131, label %161, label %132

132:                                              ; preds = %94
  %133 = icmp eq i32 %112, 0
  br i1 %133, label %161, label %134

134:                                              ; preds = %132
  %135 = icmp ugt i32 %112, 16
  br i1 %135, label %161, label %136

136:                                              ; preds = %134
  %137 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %138 = icmp eq ptr %73, null
  br label %139

139:                                              ; preds = %159, %136
  %140 = phi i32 [ %160, %159 ], [ 0, %136 ]
  %141 = icmp eq i32 %140, %97
  br i1 %141, label %161, label %142

142:                                              ; preds = %139
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %4) #12
  %143 = call i32 @read(i32 noundef range(i32 0, -2147483648) %25, ptr noundef nonnull %4, i32 noundef 24) #13
  %144 = icmp eq i32 %143, 24
  br i1 %144, label %146, label %145

145:                                              ; preds = %142
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %225

146:                                              ; preds = %142
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %5) #12
  br label %147

147:                                              ; preds = %151, %146
  %148 = phi i32 [ 0, %146 ], [ %155, %151 ]
  %149 = icmp eq i32 %148, 12
  br i1 %149, label %150, label %151

150:                                              ; preds = %147
  store i8 0, ptr %137, align 1, !tbaa !13
  br i1 %138, label %163, label %156

151:                                              ; preds = %147
  %152 = getelementptr inbounds nuw [24 x i8], ptr %4, i32 0, i32 %148
  %153 = load i8, ptr %152, align 1, !tbaa !13
  %154 = getelementptr inbounds nuw [13 x i8], ptr %5, i32 0, i32 %148
  store i8 %153, ptr %154, align 1, !tbaa !13
  %155 = add nuw nsw i32 %148, 1
  br label %147, !llvm.loop !15

156:                                              ; preds = %150
  %157 = call fastcc i32 @streq(ptr noundef nonnull %5, ptr noundef nonnull readonly %73) #10
  %158 = icmp eq i32 %157, 0
  br i1 %158, label %159, label %163

159:                                              ; preds = %156
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  %160 = add nuw nsw i32 %140, 1
  br label %139, !llvm.loop !16

161:                                              ; preds = %139, %76, %72, %79, %134, %132, %94
  %162 = phi i32 [ 0, %94 ], [ 0, %132 ], [ 0, %134 ], [ 0, %79 ], [ 0, %72 ], [ 0, %76 ], [ -1, %139 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %216

163:                                              ; preds = %150, %156
  %164 = getelementptr inbounds nuw i8, ptr %4, i32 16
  %165 = load i8, ptr %164, align 1, !tbaa !13
  %166 = zext i8 %165 to i32
  %167 = getelementptr inbounds nuw i8, ptr %4, i32 17
  %168 = load i8, ptr %167, align 1, !tbaa !13
  %169 = zext i8 %168 to i32
  %170 = shl nuw nsw i32 %169, 8
  %171 = or disjoint i32 %170, %166
  %172 = getelementptr inbounds nuw i8, ptr %4, i32 18
  %173 = load i8, ptr %172, align 1, !tbaa !13
  %174 = zext i8 %173 to i32
  %175 = shl nuw nsw i32 %174, 16
  %176 = or disjoint i32 %171, %175
  %177 = getelementptr inbounds nuw i8, ptr %4, i32 19
  %178 = load i8, ptr %177, align 1, !tbaa !13
  %179 = zext i8 %178 to i32
  %180 = shl nuw i32 %179, 24
  %181 = or disjoint i32 %176, %180
  store i32 %181, ptr @deckoff, align 4, !tbaa !3
  store i32 %25, ptr @deckfd, align 4, !tbaa !3
  store i32 0, ptr @olen, align 4, !tbaa !3
  %182 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %183 = load i8, ptr %182, align 1, !tbaa !13
  %184 = zext i8 %183 to i32
  %185 = getelementptr inbounds nuw i8, ptr %4, i32 13
  %186 = load i8, ptr %185, align 1, !tbaa !13
  %187 = zext i8 %186 to i32
  %188 = shl nuw nsw i32 %187, 8
  %189 = or disjoint i32 %188, %184
  %190 = getelementptr inbounds nuw i8, ptr %4, i32 14
  %191 = load i8, ptr %190, align 1, !tbaa !13
  %192 = zext i8 %191 to i32
  %193 = shl nuw nsw i32 %192, 16
  %194 = or disjoint i32 %189, %193
  %195 = getelementptr inbounds nuw i8, ptr %4, i32 15
  %196 = load i8, ptr %195, align 1, !tbaa !13
  %197 = zext i8 %196 to i32
  %198 = shl nuw i32 %197, 24
  %199 = or disjoint i32 %194, %198
  call fastcc void @emitn(i32 noundef %199) #10
  call fastcc void @emit(ptr noundef nonnull @.str.20) #10
  call fastcc void @emit(ptr noundef nonnull %5) #10
  call fastcc void @emit(ptr noundef nonnull @.str.21) #10
  call fastcc void @flush() #10
  %200 = load i8, ptr %182, align 1, !tbaa !13
  %201 = zext i8 %200 to i32
  %202 = load i8, ptr %185, align 1, !tbaa !13
  %203 = zext i8 %202 to i32
  %204 = shl nuw nsw i32 %203, 8
  %205 = or disjoint i32 %204, %201
  %206 = load i8, ptr %190, align 1, !tbaa !13
  %207 = zext i8 %206 to i32
  %208 = shl nuw nsw i32 %207, 16
  %209 = or disjoint i32 %205, %208
  %210 = load i8, ptr %195, align 1, !tbaa !13
  %211 = zext i8 %210 to i32
  %212 = shl nuw i32 %211, 24
  %213 = or disjoint i32 %209, %212
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  %214 = icmp sgt i32 %213, 0
  br i1 %214, label %215, label %216

215:                                              ; preds = %163
  store i32 %213, ptr @nshow, align 4, !tbaa !3
  br label %223

216:                                              ; preds = %161, %163
  %217 = phi i32 [ %162, %161 ], [ %213, %163 ]
  %218 = icmp slt i32 %217, 0
  br i1 %218, label %225, label %219

219:                                              ; preds = %216
  %220 = call i32 @close(i32 noundef %25) #13
  br label %223

221:                                              ; preds = %27
  %222 = call i32 @close(i32 noundef %25) #13
  br label %228

223:                                              ; preds = %219, %215
  %224 = phi i32 [ 0, %219 ], [ 1, %215 ]
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %8) #12
  br label %228

225:                                              ; preds = %145, %216
  %226 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.3, i32 noundef 29) #13
  %227 = call i32 @close(i32 noundef %25) #13
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %8) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  br label %580

228:                                              ; preds = %22, %221, %223
  %229 = phi i32 [ %224, %223 ], [ 0, %22 ], [ 0, %221 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  %230 = icmp eq i32 %229, 0
  %231 = icmp eq i32 %0, 2
  %232 = and i1 %231, %230
  br i1 %232, label %235, label %233

233:                                              ; preds = %228
  %234 = load i32, ptr @nshow, align 4, !tbaa !3
  br label %358

235:                                              ; preds = %228
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %9) #12
  %236 = load ptr, ptr %23, align 4, !tbaa !7
  %237 = call i32 @open(ptr noundef %236, i32 noundef 0) #13
  %238 = icmp slt i32 %237, 0
  br i1 %238, label %356, label %239

239:                                              ; preds = %235
  %240 = call i32 @fstat(i32 noundef %237, ptr noundef nonnull %9) #13
  %241 = icmp slt i32 %240, 0
  br i1 %241, label %356, label %242

242:                                              ; preds = %239
  %243 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %244 = load i16, ptr %243, align 4, !tbaa !17
  %245 = icmp eq i16 %244, 1
  br i1 %245, label %246, label %339

246:                                              ; preds = %242
  %247 = load ptr, ptr %23, align 4, !tbaa !7
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #12
  %248 = getelementptr inbounds nuw i8, ptr %10, i32 2
  br label %249

249:                                              ; preds = %283, %246
  %250 = call i32 @read(i32 noundef %237, ptr noundef nonnull %10, i32 noundef 64) #13
  %251 = icmp eq i32 %250, 64
  br i1 %251, label %252, label %295

252:                                              ; preds = %249
  %253 = load i16, ptr %10, align 2, !tbaa !21
  %254 = icmp eq i16 %253, 0
  br i1 %254, label %283, label %255

255:                                              ; preds = %252, %255
  %256 = phi i32 [ %260, %255 ], [ 0, %252 ]
  %257 = getelementptr inbounds nuw i8, ptr %248, i32 %256
  %258 = load i8, ptr %257, align 1, !tbaa !13
  %259 = icmp eq i8 %258, 0
  %260 = add nuw nsw i32 %256, 1
  br i1 %259, label %261, label %255, !llvm.loop !23

261:                                              ; preds = %255
  %262 = getelementptr inbounds nuw i8, ptr %248, i32 %256
  %263 = icmp samesign ult i32 %256, 4
  br i1 %263, label %283, label %264

264:                                              ; preds = %261
  %265 = getelementptr inbounds i8, ptr %262, i32 -4
  %266 = load i8, ptr %265, align 1, !tbaa !13
  %267 = icmp eq i8 %266, 46
  br i1 %267, label %268, label %283

268:                                              ; preds = %264
  %269 = getelementptr inbounds i8, ptr %262, i32 -3
  %270 = load i8, ptr %269, align 1, !tbaa !13
  switch i8 %270, label %283 [
    i8 115, label %271
    i8 83, label %271
  ]

271:                                              ; preds = %268, %268
  %272 = getelementptr inbounds i8, ptr %262, i32 -2
  %273 = load i8, ptr %272, align 1, !tbaa !13
  switch i8 %273, label %283 [
    i8 108, label %274
    i8 76, label %274
  ]

274:                                              ; preds = %271, %271
  %275 = getelementptr inbounds i8, ptr %262, i32 -1
  %276 = load i8, ptr %275, align 1, !tbaa !13
  switch i8 %276, label %283 [
    i8 100, label %277
    i8 68, label %277
  ]

277:                                              ; preds = %274, %274
  %278 = load i8, ptr %248, align 2, !tbaa !13
  %279 = icmp eq i8 %278, 46
  br i1 %279, label %283, label %280

280:                                              ; preds = %277
  %281 = load i32, ptr @nshow, align 4, !tbaa !3
  %282 = icmp slt i32 %281, 32
  br i1 %282, label %284, label %283

283:                                              ; preds = %280, %287, %252, %261, %264, %268, %271, %274, %277
  br label %249, !llvm.loop !24

284:                                              ; preds = %280, %290
  %285 = phi i32 [ %294, %290 ], [ 0, %280 ]
  %286 = icmp eq i32 %285, 62
  br i1 %286, label %287, label %290

287:                                              ; preds = %284
  %288 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %281, i32 62
  store i8 0, ptr %288, align 1, !tbaa !13
  %289 = add nsw i32 %281, 1
  store i32 %289, ptr @nshow, align 4, !tbaa !3
  br label %283

290:                                              ; preds = %284
  %291 = getelementptr inbounds nuw [62 x i8], ptr %248, i32 0, i32 %285
  %292 = load i8, ptr %291, align 1, !tbaa !13
  %293 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %281, i32 %285
  store i8 %292, ptr %293, align 1, !tbaa !13
  %294 = add nuw nsw i32 %285, 1
  br label %284, !llvm.loop !25

295:                                              ; preds = %249
  %296 = call i32 @close(i32 noundef %237) #13
  br label %297

297:                                              ; preds = %332, %295
  %298 = phi i32 [ 1, %295 ], [ %333, %332 ]
  %299 = load i32, ptr @nshow, align 4, !tbaa !3
  %300 = icmp slt i32 %298, %299
  br i1 %300, label %302, label %301

301:                                              ; preds = %297
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #12
  br label %353

302:                                              ; preds = %297
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %11) #12
  br label %303

303:                                              ; preds = %306, %302
  %304 = phi i32 [ 0, %302 ], [ %310, %306 ]
  %305 = icmp eq i32 %304, 64
  br i1 %305, label %311, label %306

306:                                              ; preds = %303
  %307 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %298, i32 %304
  %308 = load i8, ptr %307, align 1, !tbaa !13
  %309 = getelementptr inbounds nuw [64 x i8], ptr %11, i32 0, i32 %304
  store i8 %308, ptr %309, align 1, !tbaa !13
  %310 = add nuw nsw i32 %304, 1
  br label %303, !llvm.loop !26

311:                                              ; preds = %319, %303
  %312 = phi i32 [ %298, %303 ], [ %313, %319 ]
  %313 = add nsw i32 %312, -1
  %314 = icmp sgt i32 %312, 0
  br i1 %314, label %315, label %327

315:                                              ; preds = %311
  %316 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %313
  %317 = call i32 @strcmp(ptr noundef nonnull %316, ptr noundef nonnull %11) #13
  %318 = icmp sgt i32 %317, 0
  br i1 %318, label %319, label %327

319:                                              ; preds = %315, %322
  %320 = phi i32 [ %326, %322 ], [ 0, %315 ]
  %321 = icmp eq i32 %320, 64
  br i1 %321, label %311, label %322, !llvm.loop !27

322:                                              ; preds = %319
  %323 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %313, i32 %320
  %324 = load i8, ptr %323, align 1, !tbaa !13
  %325 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %312, i32 %320
  store i8 %324, ptr %325, align 1, !tbaa !13
  %326 = add nuw nsw i32 %320, 1
  br label %319, !llvm.loop !28

327:                                              ; preds = %311, %315
  %328 = phi i32 [ 0, %311 ], [ %312, %315 ]
  br label %329

329:                                              ; preds = %334, %327
  %330 = phi i32 [ 0, %327 ], [ %338, %334 ]
  %331 = icmp eq i32 %330, 64
  br i1 %331, label %332, label %334

332:                                              ; preds = %329
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %11) #12
  %333 = add nuw nsw i32 %298, 1
  br label %297, !llvm.loop !29

334:                                              ; preds = %329
  %335 = getelementptr inbounds nuw [64 x i8], ptr %11, i32 0, i32 %330
  %336 = load i8, ptr %335, align 1, !tbaa !13
  %337 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %328, i32 %330
  store i8 %336, ptr %337, align 1, !tbaa !13
  %338 = add nuw nsw i32 %330, 1
  br label %329, !llvm.loop !30

339:                                              ; preds = %242
  %340 = call i32 @close(i32 noundef %237) #13
  br label %341

341:                                              ; preds = %350, %339
  %342 = phi i32 [ 0, %339 ], [ %352, %350 ]
  %343 = load ptr, ptr %23, align 4, !tbaa !7
  %344 = getelementptr inbounds nuw i8, ptr %343, i32 %342
  %345 = load i8, ptr %344, align 1, !tbaa !13
  %346 = icmp ne i8 %345, 0
  %347 = icmp samesign ult i32 %342, 63
  %348 = select i1 %346, i1 %347, i1 false
  br i1 %348, label %350, label %349

349:                                              ; preds = %341
  store i32 1, ptr @nshow, align 4, !tbaa !3
  br label %353

350:                                              ; preds = %341
  %351 = getelementptr inbounds nuw [64 x i8], ptr @shownames, i32 0, i32 %342
  store i8 %345, ptr %351, align 1, !tbaa !13
  %352 = add nuw nsw i32 %342, 1
  br label %341, !llvm.loop !31

353:                                              ; preds = %349, %301
  %354 = phi i32 [ 1, %349 ], [ %299, %301 ]
  %355 = phi ptr [ null, %349 ], [ %247, %301 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %9) #12
  br label %386

356:                                              ; preds = %235, %239
  %357 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.4, i32 noundef 18) #13
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %9) #12
  br label %580

358:                                              ; preds = %233, %19
  %359 = phi i32 [ %234, %233 ], [ 0, %19 ]
  %360 = phi i1 [ %230, %233 ], [ true, %19 ]
  %361 = phi i32 [ %229, %233 ], [ 0, %19 ]
  %362 = icmp sgt i32 %0, 2
  %363 = and i1 %362, %360
  br i1 %363, label %364, label %386

364:                                              ; preds = %358, %383
  %365 = phi i32 [ %384, %383 ], [ %359, %358 ]
  %366 = phi i32 [ %385, %383 ], [ 1, %358 ]
  %367 = icmp slt i32 %366, %0
  %368 = icmp slt i32 %365, 32
  %369 = select i1 %367, i1 %368, i1 false
  br i1 %369, label %370, label %386

370:                                              ; preds = %364
  %371 = getelementptr inbounds nuw ptr, ptr %1, i32 %366
  br label %372

372:                                              ; preds = %370, %381
  %373 = phi i32 [ %382, %381 ], [ 0, %370 ]
  %374 = load ptr, ptr %371, align 4, !tbaa !7
  %375 = getelementptr inbounds nuw i8, ptr %374, i32 %373
  %376 = load i8, ptr %375, align 1, !tbaa !13
  %377 = icmp ne i8 %376, 0
  %378 = icmp samesign ult i32 %373, 63
  %379 = select i1 %377, i1 %378, i1 false
  %380 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %365, i32 %373
  br i1 %379, label %381, label %383

381:                                              ; preds = %372
  store i8 %376, ptr %380, align 1, !tbaa !13
  %382 = add nuw nsw i32 %373, 1
  br label %372, !llvm.loop !32

383:                                              ; preds = %372
  store i8 0, ptr %380, align 1, !tbaa !13
  %384 = add nsw i32 %365, 1
  store i32 %384, ptr @nshow, align 4, !tbaa !3
  %385 = add nuw nsw i32 %366, 1
  br label %364, !llvm.loop !33

386:                                              ; preds = %364, %353, %358
  %387 = phi i32 [ %354, %353 ], [ %359, %358 ], [ %365, %364 ]
  %388 = phi i1 [ true, %353 ], [ %360, %358 ], [ true, %364 ]
  %389 = phi i32 [ 0, %353 ], [ %361, %358 ], [ %361, %364 ]
  %390 = phi ptr [ %355, %353 ], [ null, %358 ], [ null, %364 ]
  %391 = icmp eq i32 %387, 0
  br i1 %391, label %392, label %394

392:                                              ; preds = %386
  %393 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.5, i32 noundef 64) #13
  br label %580

394:                                              ; preds = %386
  br i1 %388, label %395, label %396

395:                                              ; preds = %394
  call fastcc void @emitn(i32 noundef %387) #10
  call fastcc void @emit(ptr noundef nonnull @.str.6) #10
  call fastcc void @flush() #10
  br label %396

396:                                              ; preds = %395, %394
  %397 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #13
  %398 = icmp slt i32 %397, 0
  br i1 %398, label %399, label %401

399:                                              ; preds = %396
  %400 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.7, i32 noundef 14) #13
  br label %580

401:                                              ; preds = %396
  %402 = call i32 @ttyraw(i32 noundef 1) #13
  %403 = getelementptr inbounds nuw i8, ptr %6, i32 8
  %404 = load i32, ptr %403, align 4, !tbaa !34
  %405 = getelementptr inbounds nuw i8, ptr %6, i32 16
  %406 = load i32, ptr %405, align 4, !tbaa !36
  %407 = mul i32 %406, %404
  %408 = load i32, ptr %6, align 4, !tbaa !37
  call fastcc void @show_slide(i32 noundef %389, ptr noundef %390, i32 noundef 0, i32 noundef %408, i32 noundef %407) #10
  br label %409

409:                                              ; preds = %570, %401
  %410 = phi i32 [ 0, %401 ], [ %571, %570 ]
  %411 = phi i32 [ 31, %401 ], [ %519, %570 ]
  %412 = phi i32 [ -1, %401 ], [ %425, %570 ]
  %413 = phi i32 [ 0, %401 ], [ %430, %570 ]
  %414 = phi i32 [ 0, %401 ], [ %419, %570 ]
  %415 = phi i32 [ -1, %401 ], [ %558, %570 ]
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %12) #12
  br label %416

416:                                              ; preds = %409, %459
  %417 = phi i32 [ %412, %409 ], [ %464, %459 ]
  %418 = phi i32 [ %413, %409 ], [ %463, %459 ]
  %419 = phi i32 [ %414, %409 ], [ %465, %459 ]
  %420 = phi i32 [ %415, %409 ], [ %427, %459 ]
  %421 = phi i32 [ 0, %409 ], [ %460, %459 ]
  %422 = phi i32 [ 0, %409 ], [ %461, %459 ]
  %423 = call i32 @llvm.usub.sat.i32(i32 %419, i32 1)
  br label %424

424:                                              ; preds = %416, %479
  %425 = phi i32 [ -1, %479 ], [ %417, %416 ]
  %426 = phi i32 [ %430, %479 ], [ %418, %416 ]
  %427 = phi i32 [ %481, %479 ], [ %420, %416 ]
  %428 = icmp sgt i32 %425, -1
  br label %429

429:                                              ; preds = %424, %469
  %430 = phi i32 [ %426, %424 ], [ 1, %469 ]
  br label %431

431:                                              ; preds = %429, %503
  %432 = phi i32 [ %421, %429 ], [ %504, %503 ]
  %433 = phi i32 [ %422, %429 ], [ %505, %503 ]
  br label %434

434:                                              ; preds = %483, %431
  %435 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %12, i32 noundef 1) #13
  %436 = icmp eq i32 %435, 1
  br i1 %436, label %437, label %506

437:                                              ; preds = %434
  %438 = load i8, ptr %12, align 1, !tbaa !13
  %439 = add i8 %438, -48
  %440 = icmp ult i8 %439, 10
  br i1 %428, label %442, label %441

441:                                              ; preds = %437
  br i1 %440, label %443, label %482

442:                                              ; preds = %437
  br i1 %440, label %445, label %469

443:                                              ; preds = %441
  call fastcc void @emit(ptr noundef nonnull @.str.8) #10
  call fastcc void @flush() #10
  %444 = load i8, ptr %12, align 1, !tbaa !13
  br label %447

445:                                              ; preds = %442
  %446 = icmp samesign ult i32 %425, 6
  br i1 %446, label %447, label %459

447:                                              ; preds = %443, %445
  %448 = phi i32 [ %432, %443 ], [ %421, %445 ]
  %449 = phi i32 [ %433, %443 ], [ %422, %445 ]
  %450 = phi i8 [ %444, %443 ], [ %438, %445 ]
  %451 = phi i32 [ 0, %443 ], [ %419, %445 ]
  %452 = phi i32 [ 0, %443 ], [ %430, %445 ]
  %453 = phi i32 [ 0, %443 ], [ %425, %445 ]
  %454 = add nuw nsw i32 %453, 1
  %455 = mul i32 %451, 10
  %456 = sext i8 %450 to i32
  %457 = add i32 %455, -48
  %458 = add i32 %457, %456
  br label %459

459:                                              ; preds = %447, %445
  %460 = phi i32 [ %448, %447 ], [ %421, %445 ]
  %461 = phi i32 [ %449, %447 ], [ %422, %445 ]
  %462 = phi i8 [ %450, %447 ], [ %438, %445 ]
  %463 = phi i32 [ %452, %447 ], [ %430, %445 ]
  %464 = phi i32 [ %454, %447 ], [ %425, %445 ]
  %465 = phi i32 [ %458, %447 ], [ %419, %445 ]
  %466 = load i32, ptr @olen, align 4, !tbaa !3
  %467 = add nsw i32 %466, 1
  store i32 %467, ptr @olen, align 4, !tbaa !3
  %468 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %466
  store i8 %462, ptr %468, align 1, !tbaa !13
  call fastcc void @flush() #10
  br label %416, !llvm.loop !38

469:                                              ; preds = %442
  switch i8 %438, label %429 [
    i8 13, label %470
    i8 10, label %470
  ], !llvm.loop !38

470:                                              ; preds = %469, %469
  call fastcc void @emit(ptr noundef nonnull @.str.9) #10
  %471 = icmp eq i32 %430, 0
  %472 = icmp ne i32 %425, 0
  %473 = select i1 %471, i1 %472, i1 false
  br i1 %473, label %474, label %479

474:                                              ; preds = %470
  %475 = load i32, ptr @nshow, align 4, !tbaa !3
  %476 = add nsw i32 %475, -1
  %477 = call i32 @llvm.smin.i32(i32 %423, i32 %476)
  call fastcc void @emit(ptr noundef nonnull @.str.10) #10
  %478 = add nsw i32 %477, 1
  call fastcc void @emitn(i32 noundef %478) #10
  br label %479

479:                                              ; preds = %470, %474
  %480 = phi ptr [ @.str.9, %474 ], [ @.str.11, %470 ]
  %481 = phi i32 [ %477, %474 ], [ %427, %470 ]
  call fastcc void @emit(ptr noundef nonnull %480) #10
  call fastcc void @flush() #10
  br label %424, !llvm.loop !38

482:                                              ; preds = %441
  switch i8 %438, label %503 [
    i8 13, label %483
    i8 10, label %483
    i8 113, label %484
    i8 3, label %484
    i8 110, label %485
    i8 32, label %485
    i8 108, label %485
    i8 112, label %486
    i8 104, label %486
    i8 27, label %487
  ]

483:                                              ; preds = %482, %482
  br label %434, !llvm.loop !38

484:                                              ; preds = %482, %482
  call fastcc void @show_log(ptr noundef nonnull @.str.12, ptr noundef null, ptr noundef null) #10
  br label %503

485:                                              ; preds = %482, %482, %482
  call fastcc void @show_log(ptr noundef nonnull @.str.13, ptr noundef null, ptr noundef null) #10
  br label %503

486:                                              ; preds = %482, %482
  call fastcc void @show_log(ptr noundef nonnull @.str.14, ptr noundef null, ptr noundef null) #10
  br label %503

487:                                              ; preds = %482
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %13) #12
  store i8 0, ptr %13, align 1, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %14) #12
  store i8 0, ptr %14, align 1, !tbaa !13
  %488 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %13, i32 noundef 1) #13
  %489 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %14, i32 noundef 1) #13
  %490 = load i8, ptr %13, align 1, !tbaa !13
  %491 = icmp eq i8 %490, 91
  %492 = load i8, ptr %14, align 1
  %493 = icmp eq i8 %492, 67
  %494 = select i1 %491, i1 %493, i1 false
  br i1 %494, label %498, label %495

495:                                              ; preds = %487
  %496 = icmp eq i8 %492, 68
  %497 = select i1 %491, i1 %496, i1 false
  br i1 %497, label %498, label %501

498:                                              ; preds = %495, %487
  %499 = phi ptr [ @.str.13, %487 ], [ @.str.14, %495 ]
  %500 = phi i32 [ 1, %487 ], [ -1, %495 ]
  call fastcc void @show_log(ptr noundef nonnull %499, ptr noundef null, ptr noundef null) #10
  br label %501

501:                                              ; preds = %498, %495
  %502 = phi i32 [ %432, %495 ], [ %500, %498 ]
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %14) #12
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %13) #12
  br label %503

503:                                              ; preds = %482, %485, %501, %486, %484
  %504 = phi i32 [ %432, %484 ], [ 1, %485 ], [ -1, %486 ], [ %502, %501 ], [ %432, %482 ]
  %505 = phi i32 [ 1, %484 ], [ %433, %485 ], [ %433, %486 ], [ %433, %501 ], [ %433, %482 ]
  br label %431, !llvm.loop !38

506:                                              ; preds = %434
  %507 = call i32 @gpioctl(i32 noundef 2, i32 noundef 26, i32 noundef 0) #13
  %508 = call i32 @gpioctl(i32 noundef 2, i32 noundef 27, i32 noundef 0) #13
  %509 = shl i32 %508, 1
  %510 = or i32 %509, %507
  %511 = call i32 @gpioctl(i32 noundef 2, i32 noundef 28, i32 noundef 0) #13
  %512 = shl i32 %511, 2
  %513 = or i32 %510, %512
  %514 = call i32 @gpioctl(i32 noundef 2, i32 noundef 29, i32 noundef 0) #13
  %515 = shl i32 %514, 3
  %516 = or i32 %513, %515
  %517 = call i32 @gpioctl(i32 noundef 2, i32 noundef 24, i32 noundef 0) #13
  %518 = shl i32 %517, 4
  %519 = or i32 %516, %518
  %520 = xor i32 %519, -1
  %521 = and i32 %411, %520
  %522 = and i32 %521, 1
  %523 = icmp eq i32 %522, 0
  br i1 %523, label %525, label %524

524:                                              ; preds = %506
  call fastcc void @show_log(ptr noundef nonnull @.str.15, ptr noundef null, ptr noundef null) #10
  br label %525

525:                                              ; preds = %524, %506
  %526 = and i32 %521, 2
  %527 = icmp eq i32 %526, 0
  br i1 %527, label %529, label %528

528:                                              ; preds = %525
  call fastcc void @show_log(ptr noundef nonnull @.str.16, ptr noundef null, ptr noundef null) #10
  br label %529

529:                                              ; preds = %528, %525
  %530 = and i32 %521, 4
  %531 = icmp eq i32 %530, 0
  br i1 %531, label %533, label %532

532:                                              ; preds = %529
  call fastcc void @show_log(ptr noundef nonnull @.str.17, ptr noundef null, ptr noundef null) #10
  br label %533

533:                                              ; preds = %532, %529
  %534 = and i32 %521, 8
  %535 = icmp eq i32 %534, 0
  br i1 %535, label %537, label %536

536:                                              ; preds = %533
  call fastcc void @show_log(ptr noundef nonnull @.str.18, ptr noundef null, ptr noundef null) #10
  br label %537

537:                                              ; preds = %536, %533
  %538 = and i32 %521, 16
  %539 = icmp eq i32 %538, 0
  br i1 %539, label %541, label %540

540:                                              ; preds = %537
  call fastcc void @show_log(ptr noundef nonnull @.str.19, ptr noundef null, ptr noundef null) #10
  br label %541

541:                                              ; preds = %540, %537
  %542 = phi i32 [ 1, %540 ], [ %433, %537 ]
  %543 = and i32 %521, 10
  %544 = icmp eq i32 %543, 0
  %545 = and i32 %521, 5
  %546 = icmp eq i32 %545, 0
  %547 = select i1 %546, i32 %432, i32 -1
  %548 = select i1 %544, i32 %547, i32 1
  %549 = icmp eq i32 %542, 0
  br i1 %549, label %550, label %573

550:                                              ; preds = %541
  %551 = icmp sgt i32 %427, -1
  br i1 %551, label %552, label %556

552:                                              ; preds = %550
  %553 = icmp eq i32 %427, %410
  br i1 %553, label %556, label %554

554:                                              ; preds = %552
  %555 = load i32, ptr %6, align 4, !tbaa !37
  call fastcc void @show_slide(i32 noundef %389, ptr noundef %390, i32 noundef %427, i32 noundef %555, i32 noundef %407) #10
  br label %556

556:                                              ; preds = %552, %554, %550
  %557 = phi i32 [ %410, %550 ], [ %427, %554 ], [ %410, %552 ]
  %558 = phi i32 [ %427, %550 ], [ -1, %554 ], [ -1, %552 ]
  %559 = icmp eq i32 %548, 0
  br i1 %559, label %570, label %560

560:                                              ; preds = %556
  %561 = add nsw i32 %557, %548
  %562 = icmp slt i32 %561, 0
  %563 = load i32, ptr @nshow, align 4
  %564 = add nsw i32 %563, -1
  %565 = select i1 %562, i32 %564, i32 %561
  %566 = icmp slt i32 %565, %563
  %567 = select i1 %566, i32 %565, i32 0
  %568 = load i32, ptr %6, align 4, !tbaa !37
  call fastcc void @show_slide(i32 noundef %389, ptr noundef %390, i32 noundef %567, i32 noundef %568, i32 noundef %407) #10
  %569 = call i32 @pause(i32 noundef 8) #13
  br label %570

570:                                              ; preds = %556, %560
  %571 = phi i32 [ %567, %560 ], [ %557, %556 ]
  %572 = call i32 @pause(i32 noundef 2) #13
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %12) #12
  br label %409

573:                                              ; preds = %541
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %12) #12
  %574 = call i32 @ttyraw(i32 noundef 0) #13
  %575 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #13
  %576 = load i32, ptr @deckfd, align 4, !tbaa !3
  %577 = icmp sgt i32 %576, -1
  br i1 %577, label %578, label %580

578:                                              ; preds = %573
  %579 = call i32 @close(i32 noundef %576) #13
  store i32 -1, ptr @deckfd, align 4, !tbaa !3
  br label %580

580:                                              ; preds = %356, %225, %392, %399, %578, %573, %17
  %581 = phi i32 [ 1, %17 ], [ 1, %392 ], [ 1, %399 ], [ 1, %356 ], [ 1, %225 ], [ 0, %578 ], [ 0, %573 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %6) #12
  ret i32 %581
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

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @streq(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #5 {
  br label %3

3:                                                ; preds = %11, %2
  %4 = phi ptr [ %0, %2 ], [ %12, %11 ]
  %5 = phi ptr [ %1, %2 ], [ %13, %11 ]
  %6 = load i8, ptr %4, align 1, !tbaa !13
  %7 = icmp ne i8 %6, 0
  %8 = load i8, ptr %5, align 1, !tbaa !13
  %9 = icmp eq i8 %6, %8
  %10 = select i1 %7, i1 %9, i1 false
  br i1 %10, label %11, label %14

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !39

14:                                               ; preds = %3
  %15 = zext i1 %9 to i32
  ret i32 %15
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @emitn(i32 noundef %0) unnamed_addr #6 {
  %2 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %2) #12
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
  store i8 %11, ptr %13, align 1, !tbaa !13
  %14 = icmp ult i32 %4, 10
  br i1 %14, label %15, label %3, !llvm.loop !40

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
  %24 = load i8, ptr %23, align 1, !tbaa !13
  %25 = add nsw i32 %18, 1
  %26 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %18
  store i8 %24, ptr %26, align 1, !tbaa !13
  br label %17, !llvm.loop !41

27:                                               ; preds = %17
  store i32 %18, ptr @olen, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %2) #12
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none)
define internal fastcc void @emit(ptr noundef readonly captures(none) %0) unnamed_addr #7 {
  %2 = load i32, ptr @olen, align 4
  br label %3

3:                                                ; preds = %8, %1
  %4 = phi i32 [ %2, %1 ], [ %10, %8 ]
  %5 = phi ptr [ %0, %1 ], [ %9, %8 ]
  %6 = load i8, ptr %5, align 1, !tbaa !13
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %12, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %10 = add nsw i32 %4, 1
  store i32 %10, ptr @olen, align 4, !tbaa !3
  %11 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %4
  store i8 %6, ptr %11, align 1, !tbaa !13
  br label %3, !llvm.loop !42

12:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @flush() unnamed_addr #2 {
  %1 = load i32, ptr @olen, align 4, !tbaa !3
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @obuf, i32 noundef %1) #13
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
  call void @llvm.lifetime.start.p0(i64 96, ptr nonnull %6) #12
  %10 = icmp eq ptr %1, null
  br i1 %10, label %29, label %11

11:                                               ; preds = %8, %18
  %12 = phi i32 [ %19, %18 ], [ 0, %8 ]
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 %12
  %14 = load i8, ptr %13, align 1, !tbaa !13
  %15 = icmp eq i8 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %11
  %17 = icmp eq i32 %12, 0
  br i1 %17, label %29, label %21

18:                                               ; preds = %11
  %19 = add nuw nsw i32 %12, 1
  %20 = getelementptr inbounds nuw [96 x i8], ptr %6, i32 0, i32 %12
  store i8 %14, ptr %20, align 1, !tbaa !13
  br label %11, !llvm.loop !43

21:                                               ; preds = %16
  %22 = add nsw i32 %12, -1
  %23 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %22
  %24 = load i8, ptr %23, align 1, !tbaa !13
  %25 = icmp eq i8 %24, 47
  br i1 %25, label %29, label %26

26:                                               ; preds = %21
  %27 = add nuw nsw i32 %12, 1
  %28 = getelementptr inbounds nuw [96 x i8], ptr %6, i32 0, i32 %12
  store i8 47, ptr %28, align 1, !tbaa !13
  br label %29

29:                                               ; preds = %26, %21, %16, %8
  %30 = phi i32 [ 0, %8 ], [ 0, %16 ], [ %12, %21 ], [ %27, %26 ]
  br label %31

31:                                               ; preds = %29, %43
  %32 = phi i32 [ %46, %43 ], [ 0, %29 ]
  %33 = phi i32 [ %44, %43 ], [ %30, %29 ]
  %34 = getelementptr inbounds nuw i8, ptr %9, i32 %32
  %35 = load i8, ptr %34, align 1, !tbaa !13
  %36 = icmp ne i8 %35, 0
  %37 = icmp slt i32 %33, 94
  %38 = select i1 %36, i1 %37, i1 false
  br i1 %38, label %43, label %39

39:                                               ; preds = %31
  %40 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 0, ptr %40, align 1, !tbaa !13
  %41 = call i32 @open(ptr noundef nonnull %6, i32 noundef 0) #13
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %60, label %47

43:                                               ; preds = %31
  %44 = add nsw i32 %33, 1
  %45 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 %35, ptr %45, align 1, !tbaa !13
  %46 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !44

47:                                               ; preds = %39
  call fastcc void @show_log(ptr noundef nonnull @.str.26, ptr noundef nonnull %6, ptr noundef null) #10
  call fastcc void @show_log(ptr noundef nonnull @.str.27, ptr noundef nonnull %6, ptr noundef nonnull @.str.28) #10
  br label %48

48:                                               ; preds = %51, %47
  %49 = phi i32 [ 0, %47 ], [ %57, %51 ]
  %50 = icmp ult i32 %49, %4
  br i1 %50, label %51, label %58

51:                                               ; preds = %48
  %52 = add i32 %49, %3
  %53 = inttoptr i32 %52 to ptr
  %54 = sub nuw i32 %4, %49
  %55 = call i32 @read(i32 noundef %41, ptr noundef %53, i32 noundef %54) #13
  %56 = icmp slt i32 %55, 1
  %57 = add i32 %55, %49
  br i1 %56, label %58, label %48

58:                                               ; preds = %51, %48
  %59 = call i32 @close(i32 noundef %41) #13
  call fastcc void @show_expand2x(i32 noundef %3, i32 noundef %4, i32 noundef %49) #10
  br label %60

60:                                               ; preds = %39, %58
  %61 = phi ptr [ @.str.29, %58 ], [ @.str.25, %39 ]
  call fastcc void @show_log(ptr noundef nonnull %61, ptr noundef nonnull %6, ptr noundef null) #10
  call void @llvm.lifetime.end.p0(i64 96, ptr nonnull %6) #12
  br label %84

62:                                               ; preds = %5
  store i32 0, ptr @olen, align 4, !tbaa !3
  tail call fastcc void @emit(ptr noundef nonnull @.str.22) #10
  %63 = add i32 %2, 1
  tail call fastcc void @emitn(i32 noundef %63) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.23) #10
  tail call fastcc void @flush() #10
  %64 = load i32, ptr @deckfd, align 4, !tbaa !3
  %65 = load i32, ptr @deckoff, align 4, !tbaa !3
  %66 = load i32, ptr @decksz, align 4, !tbaa !3
  %67 = mul i32 %66, %2
  %68 = add i32 %67, %65
  %69 = tail call i32 @seek(i32 noundef %64, i32 noundef %68) #13
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
  %80 = tail call i32 @read(i32 noundef %76, ptr noundef %78, i32 noundef %79) #13
  %81 = icmp slt i32 %80, 1
  %82 = add i32 %80, %73
  br i1 %81, label %83, label %72

83:                                               ; preds = %75, %72
  tail call fastcc void @show_expand2x(i32 noundef %3, i32 noundef %4, i32 noundef %73) #10
  store i32 0, ptr @olen, align 4, !tbaa !3
  tail call fastcc void @emit(ptr noundef nonnull @.str.24) #10
  tail call fastcc void @emitn(i32 noundef %63) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.9) #10
  tail call fastcc void @flush() #10
  br label %84

84:                                               ; preds = %83, %60
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read_nb(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_log(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(address_is_null) %1, ptr noundef readonly captures(address_is_null) %2) unnamed_addr #2 {
  tail call fastcc void @emit(ptr noundef %0) #10
  %4 = icmp eq ptr %1, null
  br i1 %4, label %6, label %5

5:                                                ; preds = %3
  tail call fastcc void @emit(ptr noundef nonnull %1) #10
  br label %6

6:                                                ; preds = %5, %3
  %7 = icmp eq ptr %2, null
  br i1 %7, label %9, label %8

8:                                                ; preds = %6
  tail call fastcc void @emit(ptr noundef nonnull %2) #10
  br label %9

9:                                                ; preds = %8, %6
  tail call fastcc void @emit(ptr noundef nonnull @.str.9) #10
  tail call fastcc void @flush() #10
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @gpioctl(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @seek(i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @show_expand2x(i32 noundef %0, i32 noundef %1, i32 noundef %2) unnamed_addr #8 {
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
  br i1 %24, label %25, label %9, !llvm.loop !45

25:                                               ; preds = %22
  %26 = getelementptr inbounds nuw i32, ptr %16, i32 %23
  %27 = load i32, ptr %26, align 4, !tbaa !3
  %28 = getelementptr inbounds nuw i32, ptr %21, i32 %23
  store i32 %27, ptr %28, align 4, !tbaa !3
  %29 = getelementptr inbounds nuw i32, ptr %19, i32 %23
  store i32 %27, ptr %29, align 4, !tbaa !3
  %30 = add nsw i32 %23, -1
  br label %22, !llvm.loop !46

31:                                               ; preds = %9, %3
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.usub.sat.i32(i32, i32) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #9

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #9

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { minsize nobuiltin optsize "no-builtins" }
attributes #11 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #12 = { nounwind }
attributes #13 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = !{!5, !5, i64 0}
!14 = distinct !{!14, !11, !12}
!15 = distinct !{!15, !11, !12}
!16 = distinct !{!16, !11, !12}
!17 = !{!18, !19, i64 8}
!18 = !{!"stat", !4, i64 0, !4, i64 4, !19, i64 8, !19, i64 10, !20, i64 12}
!19 = !{!"short", !5, i64 0}
!20 = !{!"long", !5, i64 0}
!21 = !{!22, !19, i64 0}
!22 = !{!"dirent", !19, i64 0, !5, i64 2}
!23 = distinct !{!23, !11, !12}
!24 = distinct !{!24, !11, !12}
!25 = distinct !{!25, !11, !12}
!26 = distinct !{!26, !11, !12}
!27 = distinct !{!27, !11, !12}
!28 = distinct !{!28, !11, !12}
!29 = distinct !{!29, !11, !12}
!30 = distinct !{!30, !11, !12}
!31 = distinct !{!31, !11, !12}
!32 = distinct !{!32, !11, !12}
!33 = distinct !{!33, !11, !12}
!34 = !{!35, !4, i64 8}
!35 = !{!"fbinfo", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!36 = !{!35, !4, i64 16}
!37 = !{!35, !4, i64 0}
!38 = distinct !{!38, !11, !12}
!39 = distinct !{!39, !11, !12}
!40 = distinct !{!40, !11, !12}
!41 = distinct !{!41, !11, !12}
!42 = distinct !{!42, !11, !12}
!43 = distinct !{!43, !11, !12}
!44 = distinct !{!44, !11, !12}
!45 = distinct !{!45, !11, !12}
!46 = distinct !{!46, !11, !12}
