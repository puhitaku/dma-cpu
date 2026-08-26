; ModuleID = 'dma/show.c'
source_filename = "dma/show.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.fbinfo = type { i32, i32, i32, i32, i32 }
%struct.stat = type { i32, i32, i16, i16, i32 }
%struct.dirent = type { i16, [62 x i8] }

@show_t0 = internal unnamed_addr global i32 0, align 4
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
@.str.22 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"] \00", align 1
@.str.25 = private unnamed_addr constant [21 x i8] c"Start drawing slide \00", align 1
@.str.26 = private unnamed_addr constant [8 x i8] c" on FB\0A\00", align 1
@.str.27 = private unnamed_addr constant [20 x i8] c"Done drawing slide \00", align 1
@.str.28 = private unnamed_addr constant [19 x i8] c"show: cannot open \00", align 1
@.str.29 = private unnamed_addr constant [8 x i8] c"Opened \00", align 1
@.str.30 = private unnamed_addr constant [15 x i8] c"Start drawing \00", align 1
@.str.31 = private unnamed_addr constant [7 x i8] c" on FB\00", align 1
@.str.32 = private unnamed_addr constant [14 x i8] c"Done drawing \00", align 1
@.str.33 = private unnamed_addr constant [3 x i8] c" (\00", align 1
@.str.34 = private unnamed_addr constant [3 x i8] c"s)\00", align 1

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
  %15 = tail call i32 @uptime() #13
  store i32 %15, ptr @show_t0, align 4, !tbaa !3
  %16 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %6) #13
  %17 = icmp slt i32 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %2
  %19 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str, i32 noundef 12) #13
  br label %582

20:                                               ; preds = %2
  store i32 0, ptr @nshow, align 4, !tbaa !3
  store i32 -1, ptr @deckfd, align 4, !tbaa !3
  %21 = add i32 %0, -2
  %22 = icmp ult i32 %21, 3
  br i1 %22, label %23, label %359

23:                                               ; preds = %20
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %7) #12
  %24 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %25 = load ptr, ptr %24, align 4, !tbaa !7
  %26 = call i32 @open(ptr noundef %25, i32 noundef 0) #13
  %27 = icmp sgt i32 %26, -1
  br i1 %27, label %28, label %229

28:                                               ; preds = %23
  %29 = call i32 @fstat(i32 noundef %26, ptr noundef nonnull %7) #13
  %30 = icmp eq i32 %29, 0
  %31 = getelementptr inbounds nuw i8, ptr %7, i32 8
  %32 = load i16, ptr %31, align 4
  %33 = icmp eq i16 %32, 2
  %34 = select i1 %30, i1 %33, i1 false
  br i1 %34, label %35, label %222

35:                                               ; preds = %28
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %8) #12
  br label %36

36:                                               ; preds = %43, %35
  %37 = phi i32 [ 0, %35 ], [ %48, %43 ]
  %38 = phi ptr [ null, %35 ], [ %49, %43 ]
  %39 = phi i32 [ 2, %35 ], [ %50, %43 ]
  %40 = icmp eq i32 %39, %0
  br i1 %40, label %41, label %43

41:                                               ; preds = %36
  %42 = icmp eq ptr %38, null
  br i1 %42, label %51, label %53

43:                                               ; preds = %36
  %44 = getelementptr inbounds nuw ptr, ptr %1, i32 %39
  %45 = load ptr, ptr %44, align 4, !tbaa !7
  %46 = call fastcc i32 @streq(ptr noundef %45, ptr noundef nonnull @.str.1) #10
  %47 = icmp eq i32 %46, 0
  %48 = select i1 %47, i32 %37, i32 1
  %49 = select i1 %47, ptr %45, ptr %38
  %50 = add nuw i32 %39, 1
  br label %36, !llvm.loop !10

51:                                               ; preds = %41
  %52 = icmp eq i32 %37, 0
  br i1 %52, label %73, label %53

53:                                               ; preds = %51, %41
  %54 = phi ptr [ @.str.2, %51 ], [ %38, %41 ]
  br label %55

55:                                               ; preds = %62, %53
  %56 = phi i32 [ 0, %53 ], [ %64, %62 ]
  %57 = getelementptr inbounds nuw i8, ptr %54, i32 %56
  %58 = load i8, ptr %57, align 1, !tbaa !13
  %59 = icmp ne i8 %58, 0
  %60 = icmp samesign ult i32 %56, 11
  %61 = select i1 %59, i1 %60, i1 false
  br i1 %61, label %62, label %65

62:                                               ; preds = %55
  %63 = getelementptr inbounds nuw [13 x i8], ptr %8, i32 0, i32 %56
  store i8 %58, ptr %63, align 1, !tbaa !13
  %64 = add nuw nsw i32 %56, 1
  br label %55, !llvm.loop !14

65:                                               ; preds = %55
  %66 = icmp eq i32 %37, 0
  br i1 %66, label %70, label %67

67:                                               ; preds = %65
  %68 = add nuw nsw i32 %56, 1
  %69 = getelementptr inbounds nuw [13 x i8], ptr %8, i32 0, i32 %56
  store i8 117, ptr %69, align 1, !tbaa !13
  br label %70

70:                                               ; preds = %67, %65
  %71 = phi i32 [ %68, %67 ], [ %56, %65 ]
  %72 = getelementptr inbounds [13 x i8], ptr %8, i32 0, i32 %71
  store i8 0, ptr %72, align 1, !tbaa !13
  br label %73

73:                                               ; preds = %70, %51
  %74 = phi ptr [ %8, %70 ], [ null, %51 ]
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #12
  %75 = call i32 @seek(i32 noundef range(i32 0, -2147483648) %26, i32 noundef 0) #13
  %76 = icmp slt i32 %75, 0
  br i1 %76, label %162, label %77

77:                                               ; preds = %73
  %78 = call i32 @read(i32 noundef range(i32 0, -2147483648) %26, ptr noundef nonnull %3, i32 noundef 16) #13
  %79 = icmp eq i32 %78, 16
  br i1 %79, label %80, label %162

80:                                               ; preds = %77
  %81 = load i8, ptr %3, align 1, !tbaa !13
  %82 = icmp eq i8 %81, 83
  %83 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %84 = load i8, ptr %83, align 1
  %85 = icmp eq i8 %84, 76
  %86 = select i1 %82, i1 %85, i1 false
  %87 = getelementptr inbounds nuw i8, ptr %3, i32 2
  %88 = load i8, ptr %87, align 1
  %89 = icmp eq i8 %88, 68
  %90 = select i1 %86, i1 %89, i1 false
  %91 = getelementptr inbounds nuw i8, ptr %3, i32 3
  %92 = load i8, ptr %91, align 1
  %93 = icmp eq i8 %92, 75
  %94 = select i1 %90, i1 %93, i1 false
  br i1 %94, label %95, label %162

95:                                               ; preds = %80
  %96 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %97 = load i8, ptr %96, align 1, !tbaa !13
  %98 = zext i8 %97 to i32
  %99 = getelementptr inbounds nuw i8, ptr %3, i32 9
  %100 = load i8, ptr %99, align 1, !tbaa !13
  %101 = zext i8 %100 to i32
  %102 = shl nuw nsw i32 %101, 8
  %103 = getelementptr inbounds nuw i8, ptr %3, i32 10
  %104 = load i8, ptr %103, align 1, !tbaa !13
  %105 = zext i8 %104 to i32
  %106 = shl nuw nsw i32 %105, 16
  %107 = getelementptr inbounds nuw i8, ptr %3, i32 11
  %108 = load i8, ptr %107, align 1, !tbaa !13
  %109 = zext i8 %108 to i32
  %110 = shl nuw i32 %109, 24
  %111 = or disjoint i32 %102, %106
  %112 = or disjoint i32 %111, %110
  %113 = or disjoint i32 %112, %98
  %114 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %115 = load i8, ptr %114, align 1, !tbaa !13
  %116 = zext i8 %115 to i32
  %117 = getelementptr inbounds nuw i8, ptr %3, i32 13
  %118 = load i8, ptr %117, align 1, !tbaa !13
  %119 = zext i8 %118 to i32
  %120 = shl nuw nsw i32 %119, 8
  %121 = or disjoint i32 %120, %116
  %122 = getelementptr inbounds nuw i8, ptr %3, i32 14
  %123 = load i8, ptr %122, align 1, !tbaa !13
  %124 = zext i8 %123 to i32
  %125 = shl nuw nsw i32 %124, 16
  %126 = or disjoint i32 %121, %125
  %127 = getelementptr inbounds nuw i8, ptr %3, i32 15
  %128 = load i8, ptr %127, align 1, !tbaa !13
  %129 = zext i8 %128 to i32
  %130 = shl nuw i32 %129, 24
  %131 = or disjoint i32 %126, %130
  store i32 %131, ptr @decksz, align 4, !tbaa !3
  %132 = icmp eq i32 %131, 0
  br i1 %132, label %162, label %133

133:                                              ; preds = %95
  %134 = icmp eq i32 %113, 0
  br i1 %134, label %162, label %135

135:                                              ; preds = %133
  %136 = icmp ugt i32 %113, 16
  br i1 %136, label %162, label %137

137:                                              ; preds = %135
  %138 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %139 = icmp eq ptr %74, null
  br label %140

140:                                              ; preds = %160, %137
  %141 = phi i32 [ %161, %160 ], [ 0, %137 ]
  %142 = icmp eq i32 %141, %98
  br i1 %142, label %162, label %143

143:                                              ; preds = %140
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %4) #12
  %144 = call i32 @read(i32 noundef range(i32 0, -2147483648) %26, ptr noundef nonnull %4, i32 noundef 24) #13
  %145 = icmp eq i32 %144, 24
  br i1 %145, label %147, label %146

146:                                              ; preds = %143
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %226

147:                                              ; preds = %143
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %5) #12
  br label %148

148:                                              ; preds = %152, %147
  %149 = phi i32 [ 0, %147 ], [ %156, %152 ]
  %150 = icmp eq i32 %149, 12
  br i1 %150, label %151, label %152

151:                                              ; preds = %148
  store i8 0, ptr %138, align 1, !tbaa !13
  br i1 %139, label %164, label %157

152:                                              ; preds = %148
  %153 = getelementptr inbounds nuw [24 x i8], ptr %4, i32 0, i32 %149
  %154 = load i8, ptr %153, align 1, !tbaa !13
  %155 = getelementptr inbounds nuw [13 x i8], ptr %5, i32 0, i32 %149
  store i8 %154, ptr %155, align 1, !tbaa !13
  %156 = add nuw nsw i32 %149, 1
  br label %148, !llvm.loop !15

157:                                              ; preds = %151
  %158 = call fastcc i32 @streq(ptr noundef nonnull %5, ptr noundef nonnull readonly %74) #10
  %159 = icmp eq i32 %158, 0
  br i1 %159, label %160, label %164

160:                                              ; preds = %157
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  %161 = add nuw nsw i32 %141, 1
  br label %140, !llvm.loop !16

162:                                              ; preds = %140, %77, %73, %80, %135, %133, %95
  %163 = phi i32 [ 0, %95 ], [ 0, %133 ], [ 0, %135 ], [ 0, %80 ], [ 0, %73 ], [ 0, %77 ], [ -1, %140 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %217

164:                                              ; preds = %151, %157
  %165 = getelementptr inbounds nuw i8, ptr %4, i32 16
  %166 = load i8, ptr %165, align 1, !tbaa !13
  %167 = zext i8 %166 to i32
  %168 = getelementptr inbounds nuw i8, ptr %4, i32 17
  %169 = load i8, ptr %168, align 1, !tbaa !13
  %170 = zext i8 %169 to i32
  %171 = shl nuw nsw i32 %170, 8
  %172 = or disjoint i32 %171, %167
  %173 = getelementptr inbounds nuw i8, ptr %4, i32 18
  %174 = load i8, ptr %173, align 1, !tbaa !13
  %175 = zext i8 %174 to i32
  %176 = shl nuw nsw i32 %175, 16
  %177 = or disjoint i32 %172, %176
  %178 = getelementptr inbounds nuw i8, ptr %4, i32 19
  %179 = load i8, ptr %178, align 1, !tbaa !13
  %180 = zext i8 %179 to i32
  %181 = shl nuw i32 %180, 24
  %182 = or disjoint i32 %177, %181
  store i32 %182, ptr @deckoff, align 4, !tbaa !3
  store i32 %26, ptr @deckfd, align 4, !tbaa !3
  store i32 0, ptr @olen, align 4, !tbaa !3
  call fastcc void @emit_ts() #10
  %183 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %184 = load i8, ptr %183, align 1, !tbaa !13
  %185 = zext i8 %184 to i32
  %186 = getelementptr inbounds nuw i8, ptr %4, i32 13
  %187 = load i8, ptr %186, align 1, !tbaa !13
  %188 = zext i8 %187 to i32
  %189 = shl nuw nsw i32 %188, 8
  %190 = or disjoint i32 %189, %185
  %191 = getelementptr inbounds nuw i8, ptr %4, i32 14
  %192 = load i8, ptr %191, align 1, !tbaa !13
  %193 = zext i8 %192 to i32
  %194 = shl nuw nsw i32 %193, 16
  %195 = or disjoint i32 %190, %194
  %196 = getelementptr inbounds nuw i8, ptr %4, i32 15
  %197 = load i8, ptr %196, align 1, !tbaa !13
  %198 = zext i8 %197 to i32
  %199 = shl nuw i32 %198, 24
  %200 = or disjoint i32 %195, %199
  call fastcc void @emitn(i32 noundef %200) #10
  call fastcc void @emit(ptr noundef nonnull @.str.20) #10
  call fastcc void @emit(ptr noundef nonnull %5) #10
  call fastcc void @emit(ptr noundef nonnull @.str.21) #10
  call fastcc void @flush() #10
  %201 = load i8, ptr %183, align 1, !tbaa !13
  %202 = zext i8 %201 to i32
  %203 = load i8, ptr %186, align 1, !tbaa !13
  %204 = zext i8 %203 to i32
  %205 = shl nuw nsw i32 %204, 8
  %206 = or disjoint i32 %205, %202
  %207 = load i8, ptr %191, align 1, !tbaa !13
  %208 = zext i8 %207 to i32
  %209 = shl nuw nsw i32 %208, 16
  %210 = or disjoint i32 %206, %209
  %211 = load i8, ptr %196, align 1, !tbaa !13
  %212 = zext i8 %211 to i32
  %213 = shl nuw i32 %212, 24
  %214 = or disjoint i32 %210, %213
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  %215 = icmp sgt i32 %214, 0
  br i1 %215, label %216, label %217

216:                                              ; preds = %164
  store i32 %214, ptr @nshow, align 4, !tbaa !3
  br label %224

217:                                              ; preds = %162, %164
  %218 = phi i32 [ %163, %162 ], [ %214, %164 ]
  %219 = icmp slt i32 %218, 0
  br i1 %219, label %226, label %220

220:                                              ; preds = %217
  %221 = call i32 @close(i32 noundef %26) #13
  br label %224

222:                                              ; preds = %28
  %223 = call i32 @close(i32 noundef %26) #13
  br label %229

224:                                              ; preds = %220, %216
  %225 = phi i32 [ 0, %220 ], [ 1, %216 ]
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %8) #12
  br label %229

226:                                              ; preds = %146, %217
  %227 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.3, i32 noundef 29) #13
  %228 = call i32 @close(i32 noundef %26) #13
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %8) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  br label %582

229:                                              ; preds = %23, %222, %224
  %230 = phi i32 [ %225, %224 ], [ 0, %23 ], [ 0, %222 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  %231 = icmp eq i32 %230, 0
  %232 = icmp eq i32 %0, 2
  %233 = and i1 %232, %231
  br i1 %233, label %236, label %234

234:                                              ; preds = %229
  %235 = load i32, ptr @nshow, align 4, !tbaa !3
  br label %359

236:                                              ; preds = %229
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %9) #12
  %237 = load ptr, ptr %24, align 4, !tbaa !7
  %238 = call i32 @open(ptr noundef %237, i32 noundef 0) #13
  %239 = icmp slt i32 %238, 0
  br i1 %239, label %357, label %240

240:                                              ; preds = %236
  %241 = call i32 @fstat(i32 noundef %238, ptr noundef nonnull %9) #13
  %242 = icmp slt i32 %241, 0
  br i1 %242, label %357, label %243

243:                                              ; preds = %240
  %244 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %245 = load i16, ptr %244, align 4, !tbaa !17
  %246 = icmp eq i16 %245, 1
  br i1 %246, label %247, label %340

247:                                              ; preds = %243
  %248 = load ptr, ptr %24, align 4, !tbaa !7
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #12
  %249 = getelementptr inbounds nuw i8, ptr %10, i32 2
  br label %250

250:                                              ; preds = %284, %247
  %251 = call i32 @read(i32 noundef %238, ptr noundef nonnull %10, i32 noundef 64) #13
  %252 = icmp eq i32 %251, 64
  br i1 %252, label %253, label %296

253:                                              ; preds = %250
  %254 = load i16, ptr %10, align 2, !tbaa !21
  %255 = icmp eq i16 %254, 0
  br i1 %255, label %284, label %256

256:                                              ; preds = %253, %256
  %257 = phi i32 [ %261, %256 ], [ 0, %253 ]
  %258 = getelementptr inbounds nuw i8, ptr %249, i32 %257
  %259 = load i8, ptr %258, align 1, !tbaa !13
  %260 = icmp eq i8 %259, 0
  %261 = add nuw nsw i32 %257, 1
  br i1 %260, label %262, label %256, !llvm.loop !23

262:                                              ; preds = %256
  %263 = getelementptr inbounds nuw i8, ptr %249, i32 %257
  %264 = icmp samesign ult i32 %257, 4
  br i1 %264, label %284, label %265

265:                                              ; preds = %262
  %266 = getelementptr inbounds i8, ptr %263, i32 -4
  %267 = load i8, ptr %266, align 1, !tbaa !13
  %268 = icmp eq i8 %267, 46
  br i1 %268, label %269, label %284

269:                                              ; preds = %265
  %270 = getelementptr inbounds i8, ptr %263, i32 -3
  %271 = load i8, ptr %270, align 1, !tbaa !13
  switch i8 %271, label %284 [
    i8 115, label %272
    i8 83, label %272
  ]

272:                                              ; preds = %269, %269
  %273 = getelementptr inbounds i8, ptr %263, i32 -2
  %274 = load i8, ptr %273, align 1, !tbaa !13
  switch i8 %274, label %284 [
    i8 108, label %275
    i8 76, label %275
  ]

275:                                              ; preds = %272, %272
  %276 = getelementptr inbounds i8, ptr %263, i32 -1
  %277 = load i8, ptr %276, align 1, !tbaa !13
  switch i8 %277, label %284 [
    i8 100, label %278
    i8 68, label %278
  ]

278:                                              ; preds = %275, %275
  %279 = load i8, ptr %249, align 2, !tbaa !13
  %280 = icmp eq i8 %279, 46
  br i1 %280, label %284, label %281

281:                                              ; preds = %278
  %282 = load i32, ptr @nshow, align 4, !tbaa !3
  %283 = icmp slt i32 %282, 32
  br i1 %283, label %285, label %284

284:                                              ; preds = %281, %288, %253, %262, %265, %269, %272, %275, %278
  br label %250, !llvm.loop !24

285:                                              ; preds = %281, %291
  %286 = phi i32 [ %295, %291 ], [ 0, %281 ]
  %287 = icmp eq i32 %286, 62
  br i1 %287, label %288, label %291

288:                                              ; preds = %285
  %289 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %282, i32 62
  store i8 0, ptr %289, align 1, !tbaa !13
  %290 = add nsw i32 %282, 1
  store i32 %290, ptr @nshow, align 4, !tbaa !3
  br label %284

291:                                              ; preds = %285
  %292 = getelementptr inbounds nuw [62 x i8], ptr %249, i32 0, i32 %286
  %293 = load i8, ptr %292, align 1, !tbaa !13
  %294 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %282, i32 %286
  store i8 %293, ptr %294, align 1, !tbaa !13
  %295 = add nuw nsw i32 %286, 1
  br label %285, !llvm.loop !25

296:                                              ; preds = %250
  %297 = call i32 @close(i32 noundef %238) #13
  br label %298

298:                                              ; preds = %333, %296
  %299 = phi i32 [ 1, %296 ], [ %334, %333 ]
  %300 = load i32, ptr @nshow, align 4, !tbaa !3
  %301 = icmp slt i32 %299, %300
  br i1 %301, label %303, label %302

302:                                              ; preds = %298
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #12
  br label %354

303:                                              ; preds = %298
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %11) #12
  br label %304

304:                                              ; preds = %307, %303
  %305 = phi i32 [ 0, %303 ], [ %311, %307 ]
  %306 = icmp eq i32 %305, 64
  br i1 %306, label %312, label %307

307:                                              ; preds = %304
  %308 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %299, i32 %305
  %309 = load i8, ptr %308, align 1, !tbaa !13
  %310 = getelementptr inbounds nuw [64 x i8], ptr %11, i32 0, i32 %305
  store i8 %309, ptr %310, align 1, !tbaa !13
  %311 = add nuw nsw i32 %305, 1
  br label %304, !llvm.loop !26

312:                                              ; preds = %320, %304
  %313 = phi i32 [ %299, %304 ], [ %314, %320 ]
  %314 = add nsw i32 %313, -1
  %315 = icmp sgt i32 %313, 0
  br i1 %315, label %316, label %328

316:                                              ; preds = %312
  %317 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %314
  %318 = call i32 @strcmp(ptr noundef nonnull %317, ptr noundef nonnull %11) #13
  %319 = icmp sgt i32 %318, 0
  br i1 %319, label %320, label %328

320:                                              ; preds = %316, %323
  %321 = phi i32 [ %327, %323 ], [ 0, %316 ]
  %322 = icmp eq i32 %321, 64
  br i1 %322, label %312, label %323, !llvm.loop !27

323:                                              ; preds = %320
  %324 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %314, i32 %321
  %325 = load i8, ptr %324, align 1, !tbaa !13
  %326 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %313, i32 %321
  store i8 %325, ptr %326, align 1, !tbaa !13
  %327 = add nuw nsw i32 %321, 1
  br label %320, !llvm.loop !28

328:                                              ; preds = %312, %316
  %329 = phi i32 [ 0, %312 ], [ %313, %316 ]
  br label %330

330:                                              ; preds = %335, %328
  %331 = phi i32 [ 0, %328 ], [ %339, %335 ]
  %332 = icmp eq i32 %331, 64
  br i1 %332, label %333, label %335

333:                                              ; preds = %330
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %11) #12
  %334 = add nuw nsw i32 %299, 1
  br label %298, !llvm.loop !29

335:                                              ; preds = %330
  %336 = getelementptr inbounds nuw [64 x i8], ptr %11, i32 0, i32 %331
  %337 = load i8, ptr %336, align 1, !tbaa !13
  %338 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %329, i32 %331
  store i8 %337, ptr %338, align 1, !tbaa !13
  %339 = add nuw nsw i32 %331, 1
  br label %330, !llvm.loop !30

340:                                              ; preds = %243
  %341 = call i32 @close(i32 noundef %238) #13
  br label %342

342:                                              ; preds = %351, %340
  %343 = phi i32 [ 0, %340 ], [ %353, %351 ]
  %344 = load ptr, ptr %24, align 4, !tbaa !7
  %345 = getelementptr inbounds nuw i8, ptr %344, i32 %343
  %346 = load i8, ptr %345, align 1, !tbaa !13
  %347 = icmp ne i8 %346, 0
  %348 = icmp samesign ult i32 %343, 63
  %349 = select i1 %347, i1 %348, i1 false
  br i1 %349, label %351, label %350

350:                                              ; preds = %342
  store i32 1, ptr @nshow, align 4, !tbaa !3
  br label %354

351:                                              ; preds = %342
  %352 = getelementptr inbounds nuw [64 x i8], ptr @shownames, i32 0, i32 %343
  store i8 %346, ptr %352, align 1, !tbaa !13
  %353 = add nuw nsw i32 %343, 1
  br label %342, !llvm.loop !31

354:                                              ; preds = %350, %302
  %355 = phi i32 [ 1, %350 ], [ %300, %302 ]
  %356 = phi ptr [ null, %350 ], [ %248, %302 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %9) #12
  br label %387

357:                                              ; preds = %236, %240
  %358 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.4, i32 noundef 18) #13
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %9) #12
  br label %582

359:                                              ; preds = %234, %20
  %360 = phi i32 [ %235, %234 ], [ 0, %20 ]
  %361 = phi i1 [ %231, %234 ], [ true, %20 ]
  %362 = phi i32 [ %230, %234 ], [ 0, %20 ]
  %363 = icmp sgt i32 %0, 2
  %364 = and i1 %363, %361
  br i1 %364, label %365, label %387

365:                                              ; preds = %359, %384
  %366 = phi i32 [ %385, %384 ], [ %360, %359 ]
  %367 = phi i32 [ %386, %384 ], [ 1, %359 ]
  %368 = icmp slt i32 %367, %0
  %369 = icmp slt i32 %366, 32
  %370 = select i1 %368, i1 %369, i1 false
  br i1 %370, label %371, label %387

371:                                              ; preds = %365
  %372 = getelementptr inbounds nuw ptr, ptr %1, i32 %367
  br label %373

373:                                              ; preds = %371, %382
  %374 = phi i32 [ %383, %382 ], [ 0, %371 ]
  %375 = load ptr, ptr %372, align 4, !tbaa !7
  %376 = getelementptr inbounds nuw i8, ptr %375, i32 %374
  %377 = load i8, ptr %376, align 1, !tbaa !13
  %378 = icmp ne i8 %377, 0
  %379 = icmp samesign ult i32 %374, 63
  %380 = select i1 %378, i1 %379, i1 false
  %381 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %366, i32 %374
  br i1 %380, label %382, label %384

382:                                              ; preds = %373
  store i8 %377, ptr %381, align 1, !tbaa !13
  %383 = add nuw nsw i32 %374, 1
  br label %373, !llvm.loop !32

384:                                              ; preds = %373
  store i8 0, ptr %381, align 1, !tbaa !13
  %385 = add nsw i32 %366, 1
  store i32 %385, ptr @nshow, align 4, !tbaa !3
  %386 = add nuw nsw i32 %367, 1
  br label %365, !llvm.loop !33

387:                                              ; preds = %365, %354, %359
  %388 = phi i32 [ %355, %354 ], [ %360, %359 ], [ %366, %365 ]
  %389 = phi i1 [ true, %354 ], [ %361, %359 ], [ true, %365 ]
  %390 = phi i32 [ 0, %354 ], [ %362, %359 ], [ %362, %365 ]
  %391 = phi ptr [ %356, %354 ], [ null, %359 ], [ null, %365 ]
  %392 = icmp eq i32 %388, 0
  br i1 %392, label %393, label %395

393:                                              ; preds = %387
  %394 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.5, i32 noundef 64) #13
  br label %582

395:                                              ; preds = %387
  br i1 %389, label %396, label %398

396:                                              ; preds = %395
  call fastcc void @emit_ts() #10
  %397 = load i32, ptr @nshow, align 4, !tbaa !3
  call fastcc void @emitn(i32 noundef %397) #10
  call fastcc void @emit(ptr noundef nonnull @.str.6) #10
  call fastcc void @flush() #10
  br label %398

398:                                              ; preds = %396, %395
  %399 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #13
  %400 = icmp slt i32 %399, 0
  br i1 %400, label %401, label %403

401:                                              ; preds = %398
  %402 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.7, i32 noundef 14) #13
  br label %582

403:                                              ; preds = %398
  %404 = call i32 @ttyraw(i32 noundef 1) #13
  %405 = getelementptr inbounds nuw i8, ptr %6, i32 8
  %406 = load i32, ptr %405, align 4, !tbaa !34
  %407 = getelementptr inbounds nuw i8, ptr %6, i32 16
  %408 = load i32, ptr %407, align 4, !tbaa !36
  %409 = mul i32 %408, %406
  %410 = load i32, ptr %6, align 4, !tbaa !37
  call fastcc void @show_slide(i32 noundef %390, ptr noundef %391, i32 noundef 0, i32 noundef %410, i32 noundef %409) #10
  br label %411

411:                                              ; preds = %572, %403
  %412 = phi i32 [ 0, %403 ], [ %573, %572 ]
  %413 = phi i32 [ 31, %403 ], [ %521, %572 ]
  %414 = phi i32 [ -1, %403 ], [ %427, %572 ]
  %415 = phi i32 [ 0, %403 ], [ %432, %572 ]
  %416 = phi i32 [ 0, %403 ], [ %421, %572 ]
  %417 = phi i32 [ -1, %403 ], [ %560, %572 ]
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %12) #12
  br label %418

418:                                              ; preds = %411, %461
  %419 = phi i32 [ %414, %411 ], [ %466, %461 ]
  %420 = phi i32 [ %415, %411 ], [ %465, %461 ]
  %421 = phi i32 [ %416, %411 ], [ %467, %461 ]
  %422 = phi i32 [ %417, %411 ], [ %429, %461 ]
  %423 = phi i32 [ 0, %411 ], [ %462, %461 ]
  %424 = phi i32 [ 0, %411 ], [ %463, %461 ]
  %425 = call i32 @llvm.usub.sat.i32(i32 %421, i32 1)
  br label %426

426:                                              ; preds = %418, %481
  %427 = phi i32 [ -1, %481 ], [ %419, %418 ]
  %428 = phi i32 [ %432, %481 ], [ %420, %418 ]
  %429 = phi i32 [ %483, %481 ], [ %422, %418 ]
  %430 = icmp sgt i32 %427, -1
  br label %431

431:                                              ; preds = %426, %471
  %432 = phi i32 [ %428, %426 ], [ 1, %471 ]
  br label %433

433:                                              ; preds = %431, %505
  %434 = phi i32 [ %423, %431 ], [ %506, %505 ]
  %435 = phi i32 [ %424, %431 ], [ %507, %505 ]
  br label %436

436:                                              ; preds = %485, %433
  %437 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %12, i32 noundef 1) #13
  %438 = icmp eq i32 %437, 1
  br i1 %438, label %439, label %508

439:                                              ; preds = %436
  %440 = load i8, ptr %12, align 1, !tbaa !13
  %441 = add i8 %440, -48
  %442 = icmp ult i8 %441, 10
  br i1 %430, label %444, label %443

443:                                              ; preds = %439
  br i1 %442, label %445, label %484

444:                                              ; preds = %439
  br i1 %442, label %447, label %471

445:                                              ; preds = %443
  call fastcc void @emit(ptr noundef nonnull @.str.8) #10
  call fastcc void @flush() #10
  %446 = load i8, ptr %12, align 1, !tbaa !13
  br label %449

447:                                              ; preds = %444
  %448 = icmp samesign ult i32 %427, 6
  br i1 %448, label %449, label %461

449:                                              ; preds = %445, %447
  %450 = phi i32 [ %434, %445 ], [ %423, %447 ]
  %451 = phi i32 [ %435, %445 ], [ %424, %447 ]
  %452 = phi i8 [ %446, %445 ], [ %440, %447 ]
  %453 = phi i32 [ 0, %445 ], [ %421, %447 ]
  %454 = phi i32 [ 0, %445 ], [ %432, %447 ]
  %455 = phi i32 [ 0, %445 ], [ %427, %447 ]
  %456 = add nuw nsw i32 %455, 1
  %457 = mul i32 %453, 10
  %458 = sext i8 %452 to i32
  %459 = add i32 %457, -48
  %460 = add i32 %459, %458
  br label %461

461:                                              ; preds = %449, %447
  %462 = phi i32 [ %450, %449 ], [ %423, %447 ]
  %463 = phi i32 [ %451, %449 ], [ %424, %447 ]
  %464 = phi i8 [ %452, %449 ], [ %440, %447 ]
  %465 = phi i32 [ %454, %449 ], [ %432, %447 ]
  %466 = phi i32 [ %456, %449 ], [ %427, %447 ]
  %467 = phi i32 [ %460, %449 ], [ %421, %447 ]
  %468 = load i32, ptr @olen, align 4, !tbaa !3
  %469 = add nsw i32 %468, 1
  store i32 %469, ptr @olen, align 4, !tbaa !3
  %470 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %468
  store i8 %464, ptr %470, align 1, !tbaa !13
  call fastcc void @flush() #10
  br label %418, !llvm.loop !38

471:                                              ; preds = %444
  switch i8 %440, label %431 [
    i8 13, label %472
    i8 10, label %472
  ], !llvm.loop !38

472:                                              ; preds = %471, %471
  call fastcc void @emit(ptr noundef nonnull @.str.9) #10
  %473 = icmp eq i32 %432, 0
  %474 = icmp ne i32 %427, 0
  %475 = select i1 %473, i1 %474, i1 false
  br i1 %475, label %476, label %481

476:                                              ; preds = %472
  %477 = load i32, ptr @nshow, align 4, !tbaa !3
  %478 = add nsw i32 %477, -1
  %479 = call i32 @llvm.smin.i32(i32 %425, i32 %478)
  call fastcc void @emit(ptr noundef nonnull @.str.10) #10
  %480 = add nsw i32 %479, 1
  call fastcc void @emitn(i32 noundef %480) #10
  br label %481

481:                                              ; preds = %472, %476
  %482 = phi ptr [ @.str.9, %476 ], [ @.str.11, %472 ]
  %483 = phi i32 [ %479, %476 ], [ %429, %472 ]
  call fastcc void @emit(ptr noundef nonnull %482) #10
  call fastcc void @flush() #10
  br label %426, !llvm.loop !38

484:                                              ; preds = %443
  switch i8 %440, label %505 [
    i8 13, label %485
    i8 10, label %485
    i8 113, label %486
    i8 3, label %486
    i8 110, label %487
    i8 32, label %487
    i8 108, label %487
    i8 112, label %488
    i8 104, label %488
    i8 27, label %489
  ]

485:                                              ; preds = %484, %484
  br label %436, !llvm.loop !38

486:                                              ; preds = %484, %484
  call fastcc void @show_log(ptr noundef nonnull @.str.12, ptr noundef null, ptr noundef null) #10
  br label %505

487:                                              ; preds = %484, %484, %484
  call fastcc void @show_log(ptr noundef nonnull @.str.13, ptr noundef null, ptr noundef null) #10
  br label %505

488:                                              ; preds = %484, %484
  call fastcc void @show_log(ptr noundef nonnull @.str.14, ptr noundef null, ptr noundef null) #10
  br label %505

489:                                              ; preds = %484
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %13) #12
  store i8 0, ptr %13, align 1, !tbaa !13
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %14) #12
  store i8 0, ptr %14, align 1, !tbaa !13
  %490 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %13, i32 noundef 1) #13
  %491 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %14, i32 noundef 1) #13
  %492 = load i8, ptr %13, align 1, !tbaa !13
  %493 = icmp eq i8 %492, 91
  %494 = load i8, ptr %14, align 1
  %495 = icmp eq i8 %494, 67
  %496 = select i1 %493, i1 %495, i1 false
  br i1 %496, label %500, label %497

497:                                              ; preds = %489
  %498 = icmp eq i8 %494, 68
  %499 = select i1 %493, i1 %498, i1 false
  br i1 %499, label %500, label %503

500:                                              ; preds = %497, %489
  %501 = phi ptr [ @.str.13, %489 ], [ @.str.14, %497 ]
  %502 = phi i32 [ 1, %489 ], [ -1, %497 ]
  call fastcc void @show_log(ptr noundef nonnull %501, ptr noundef null, ptr noundef null) #10
  br label %503

503:                                              ; preds = %500, %497
  %504 = phi i32 [ %434, %497 ], [ %502, %500 ]
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %14) #12
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %13) #12
  br label %505

505:                                              ; preds = %484, %487, %503, %488, %486
  %506 = phi i32 [ %434, %486 ], [ 1, %487 ], [ -1, %488 ], [ %504, %503 ], [ %434, %484 ]
  %507 = phi i32 [ 1, %486 ], [ %435, %487 ], [ %435, %488 ], [ %435, %503 ], [ %435, %484 ]
  br label %433, !llvm.loop !38

508:                                              ; preds = %436
  %509 = call i32 @gpioctl(i32 noundef 2, i32 noundef 26, i32 noundef 0) #13
  %510 = call i32 @gpioctl(i32 noundef 2, i32 noundef 27, i32 noundef 0) #13
  %511 = shl i32 %510, 1
  %512 = or i32 %511, %509
  %513 = call i32 @gpioctl(i32 noundef 2, i32 noundef 28, i32 noundef 0) #13
  %514 = shl i32 %513, 2
  %515 = or i32 %512, %514
  %516 = call i32 @gpioctl(i32 noundef 2, i32 noundef 29, i32 noundef 0) #13
  %517 = shl i32 %516, 3
  %518 = or i32 %515, %517
  %519 = call i32 @gpioctl(i32 noundef 2, i32 noundef 24, i32 noundef 0) #13
  %520 = shl i32 %519, 4
  %521 = or i32 %518, %520
  %522 = xor i32 %521, -1
  %523 = and i32 %413, %522
  %524 = and i32 %523, 1
  %525 = icmp eq i32 %524, 0
  br i1 %525, label %527, label %526

526:                                              ; preds = %508
  call fastcc void @show_log(ptr noundef nonnull @.str.15, ptr noundef null, ptr noundef null) #10
  br label %527

527:                                              ; preds = %526, %508
  %528 = and i32 %523, 2
  %529 = icmp eq i32 %528, 0
  br i1 %529, label %531, label %530

530:                                              ; preds = %527
  call fastcc void @show_log(ptr noundef nonnull @.str.16, ptr noundef null, ptr noundef null) #10
  br label %531

531:                                              ; preds = %530, %527
  %532 = and i32 %523, 4
  %533 = icmp eq i32 %532, 0
  br i1 %533, label %535, label %534

534:                                              ; preds = %531
  call fastcc void @show_log(ptr noundef nonnull @.str.17, ptr noundef null, ptr noundef null) #10
  br label %535

535:                                              ; preds = %534, %531
  %536 = and i32 %523, 8
  %537 = icmp eq i32 %536, 0
  br i1 %537, label %539, label %538

538:                                              ; preds = %535
  call fastcc void @show_log(ptr noundef nonnull @.str.18, ptr noundef null, ptr noundef null) #10
  br label %539

539:                                              ; preds = %538, %535
  %540 = and i32 %523, 16
  %541 = icmp eq i32 %540, 0
  br i1 %541, label %543, label %542

542:                                              ; preds = %539
  call fastcc void @show_log(ptr noundef nonnull @.str.19, ptr noundef null, ptr noundef null) #10
  br label %543

543:                                              ; preds = %542, %539
  %544 = phi i32 [ 1, %542 ], [ %435, %539 ]
  %545 = and i32 %523, 10
  %546 = icmp eq i32 %545, 0
  %547 = and i32 %523, 5
  %548 = icmp eq i32 %547, 0
  %549 = select i1 %548, i32 %434, i32 -1
  %550 = select i1 %546, i32 %549, i32 1
  %551 = icmp eq i32 %544, 0
  br i1 %551, label %552, label %575

552:                                              ; preds = %543
  %553 = icmp sgt i32 %429, -1
  br i1 %553, label %554, label %558

554:                                              ; preds = %552
  %555 = icmp eq i32 %429, %412
  br i1 %555, label %558, label %556

556:                                              ; preds = %554
  %557 = load i32, ptr %6, align 4, !tbaa !37
  call fastcc void @show_slide(i32 noundef %390, ptr noundef %391, i32 noundef %429, i32 noundef %557, i32 noundef %409) #10
  br label %558

558:                                              ; preds = %554, %556, %552
  %559 = phi i32 [ %412, %552 ], [ %429, %556 ], [ %412, %554 ]
  %560 = phi i32 [ %429, %552 ], [ -1, %556 ], [ -1, %554 ]
  %561 = icmp eq i32 %550, 0
  br i1 %561, label %572, label %562

562:                                              ; preds = %558
  %563 = add nsw i32 %559, %550
  %564 = icmp slt i32 %563, 0
  %565 = load i32, ptr @nshow, align 4
  %566 = add nsw i32 %565, -1
  %567 = select i1 %564, i32 %566, i32 %563
  %568 = icmp slt i32 %567, %565
  %569 = select i1 %568, i32 %567, i32 0
  %570 = load i32, ptr %6, align 4, !tbaa !37
  call fastcc void @show_slide(i32 noundef %390, ptr noundef %391, i32 noundef %569, i32 noundef %570, i32 noundef %409) #10
  %571 = call i32 @pause(i32 noundef 8) #13
  br label %572

572:                                              ; preds = %558, %562
  %573 = phi i32 [ %569, %562 ], [ %559, %558 ]
  %574 = call i32 @pause(i32 noundef 2) #13
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %12) #12
  br label %411

575:                                              ; preds = %543
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %12) #12
  %576 = call i32 @ttyraw(i32 noundef 0) #13
  %577 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #13
  %578 = load i32, ptr @deckfd, align 4, !tbaa !3
  %579 = icmp sgt i32 %578, -1
  br i1 %579, label %580, label %582

580:                                              ; preds = %575
  %581 = call i32 @close(i32 noundef %578) #13
  store i32 -1, ptr @deckfd, align 4, !tbaa !3
  br label %582

582:                                              ; preds = %357, %226, %393, %401, %580, %575, %18
  %583 = phi i32 [ 1, %18 ], [ 1, %393 ], [ 1, %401 ], [ 1, %357 ], [ 1, %226 ], [ 0, %580 ], [ 0, %575 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %6) #12
  ret i32 %583
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @uptime() local_unnamed_addr #4

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

; Function Attrs: minsize nounwind optsize
define internal fastcc void @emit_ts() unnamed_addr #2 {
  %1 = tail call i32 @uptime() #13
  %2 = load i32, ptr @show_t0, align 4, !tbaa !3
  %3 = sub i32 %1, %2
  %4 = freeze i32 %3
  %5 = udiv i32 %4, 10000
  %6 = mul i32 %5, 10000
  %7 = sub i32 %4, %6
  %8 = trunc nuw nsw i32 %7 to i16
  %9 = udiv i16 %8, 100
  tail call fastcc void @emit(ptr noundef nonnull @.str.22) #10
  tail call fastcc void @emitn(i32 noundef %5) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.23) #10
  %10 = udiv i16 %8, 1000
  %11 = zext nneg i16 %10 to i32
  tail call fastcc void @emitn(i32 noundef %11) #10
  %12 = trunc nuw nsw i16 %9 to i8
  %13 = urem i8 %12, 10
  %14 = zext nneg i8 %13 to i32
  tail call fastcc void @emitn(i32 noundef %14) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.24) #10
  ret void
}

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
  br i1 %7, label %8, label %65

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
  br i1 %42, label %47, label %48

43:                                               ; preds = %31
  %44 = add nsw i32 %33, 1
  %45 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 %35, ptr %45, align 1, !tbaa !13
  %46 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !44

47:                                               ; preds = %39
  call fastcc void @show_log(ptr noundef nonnull @.str.28, ptr noundef nonnull %6, ptr noundef null) #10
  br label %64

48:                                               ; preds = %39
  call fastcc void @show_log(ptr noundef nonnull @.str.29, ptr noundef nonnull %6, ptr noundef null) #10
  call fastcc void @show_log(ptr noundef nonnull @.str.30, ptr noundef nonnull %6, ptr noundef nonnull @.str.31) #10
  %49 = call i32 @uptime() #13
  br label %50

50:                                               ; preds = %53, %48
  %51 = phi i32 [ 0, %48 ], [ %59, %53 ]
  %52 = icmp ult i32 %51, %4
  br i1 %52, label %53, label %60

53:                                               ; preds = %50
  %54 = add i32 %51, %3
  %55 = inttoptr i32 %54 to ptr
  %56 = sub nuw i32 %4, %51
  %57 = call i32 @read(i32 noundef %41, ptr noundef %55, i32 noundef %56) #13
  %58 = icmp slt i32 %57, 1
  %59 = add i32 %57, %51
  br i1 %58, label %60, label %50

60:                                               ; preds = %53, %50
  %61 = call i32 @close(i32 noundef %41) #13
  call fastcc void @show_expand2x(i32 noundef %3, i32 noundef %4, i32 noundef %51) #10
  %62 = call i32 @uptime() #13
  %63 = sub i32 %62, %49
  store i32 0, ptr @olen, align 4, !tbaa !3
  call fastcc void @emit_ts() #10
  call fastcc void @emit(ptr noundef nonnull @.str.32) #10
  call fastcc void @emit(ptr noundef nonnull %6) #10
  call fastcc void @emit_dur(i32 noundef %63) #10
  call fastcc void @emit(ptr noundef nonnull @.str.9) #10
  call fastcc void @flush() #10
  br label %64

64:                                               ; preds = %47, %60
  call void @llvm.lifetime.end.p0(i64 96, ptr nonnull %6) #12
  br label %90

65:                                               ; preds = %5
  store i32 0, ptr @olen, align 4, !tbaa !3
  tail call fastcc void @emit_ts() #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.25) #10
  %66 = add i32 %2, 1
  tail call fastcc void @emitn(i32 noundef %66) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.26) #10
  tail call fastcc void @flush() #10
  %67 = tail call i32 @uptime() #13
  %68 = load i32, ptr @deckfd, align 4, !tbaa !3
  %69 = load i32, ptr @deckoff, align 4, !tbaa !3
  %70 = load i32, ptr @decksz, align 4, !tbaa !3
  %71 = mul i32 %70, %2
  %72 = add i32 %71, %69
  %73 = tail call i32 @seek(i32 noundef %68, i32 noundef %72) #13
  %74 = load i32, ptr @decksz, align 4, !tbaa !3
  %75 = tail call i32 @llvm.umin.i32(i32 %74, i32 %4)
  br label %76

76:                                               ; preds = %79, %65
  %77 = phi i32 [ 0, %65 ], [ %86, %79 ]
  %78 = icmp ult i32 %77, %75
  br i1 %78, label %79, label %87

79:                                               ; preds = %76
  %80 = load i32, ptr @deckfd, align 4, !tbaa !3
  %81 = add i32 %77, %3
  %82 = inttoptr i32 %81 to ptr
  %83 = sub nuw i32 %75, %77
  %84 = tail call i32 @read(i32 noundef %80, ptr noundef %82, i32 noundef %83) #13
  %85 = icmp slt i32 %84, 1
  %86 = add i32 %84, %77
  br i1 %85, label %87, label %76

87:                                               ; preds = %79, %76
  tail call fastcc void @show_expand2x(i32 noundef %3, i32 noundef %4, i32 noundef %77) #10
  %88 = tail call i32 @uptime() #13
  %89 = sub i32 %88, %67
  store i32 0, ptr @olen, align 4, !tbaa !3
  tail call fastcc void @emit_ts() #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.27) #10
  tail call fastcc void @emitn(i32 noundef %66) #10
  tail call fastcc void @emit_dur(i32 noundef %89) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.9) #10
  tail call fastcc void @flush() #10
  br label %90

90:                                               ; preds = %87, %64
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read_nb(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_log(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(address_is_null) %1, ptr noundef readonly captures(address_is_null) %2) unnamed_addr #2 {
  tail call fastcc void @emit_ts() #10
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

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @emit_dur(i32 noundef %0) unnamed_addr #8 {
  %2 = udiv i32 %0, 10000
  %3 = mul i32 %2, 10000
  %4 = sub i32 %0, %3
  %5 = trunc nuw nsw i32 %4 to i16
  %6 = udiv i16 %5, 100
  tail call fastcc void @emit(ptr noundef nonnull @.str.33) #10
  tail call fastcc void @emitn(i32 noundef %2) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.23) #10
  %7 = udiv i16 %5, 1000
  %8 = zext nneg i16 %7 to i32
  tail call fastcc void @emitn(i32 noundef %8) #10
  %9 = trunc nuw nsw i16 %6 to i8
  %10 = urem i8 %9, 10
  %11 = zext nneg i8 %10 to i32
  tail call fastcc void @emitn(i32 noundef %11) #10
  tail call fastcc void @emit(ptr noundef nonnull @.str.34) #10
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
