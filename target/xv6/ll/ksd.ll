; ModuleID = 'dma/ksd.c'
source_filename = "dma/ksd.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@sd_spi = dso_local local_unnamed_addr global i32 0, align 4
@sd_csreg = dso_local local_unnamed_addr global i32 0, align 4
@sd_cs_hi = dso_local local_unnamed_addr global i32 0, align 4
@sd_cs_lo = dso_local local_unnamed_addr global i32 0, align 4
@sd_rxctrl = dso_local local_unnamed_addr global i32 0, align 4
@sd_txch = dso_local local_unnamed_addr global i32 0, align 4
@sd_txctrl = dso_local local_unnamed_addr global i32 0, align 4
@sd_sectors = internal unnamed_addr global i32 0, align 4
@.str = private unnamed_addr constant [10 x i8] c"sd: cmd0=\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c" v2=\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c" a41=\00", align 1
@sd_hc = internal unnamed_addr global i32 0, align 4
@.str.4 = private unnamed_addr constant [5 x i8] c" hc=\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c" cap=\00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c"0123456789abcdef\00", align 1
@sd_burst_state = internal unnamed_addr global i32 0, align 4
@sd_ff = internal global i32 -1, align 4
@.str.7 = private unnamed_addr constant [16 x i8] c"sd: burst left=\00", align 1
@.str.8 = private unnamed_addr constant [12 x i8] c" -> polled\0A\00", align 1
@sd_slow = internal unnamed_addr global i1 false, align 4
@.str.9 = private unnamed_addr constant [8 x i8] c"sd: rd=\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c" -> slow\0A\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c" r1=\00", align 1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @ksd_on() local_unnamed_addr #0 {
  %1 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %2 = icmp ne i32 %1, 0
  %3 = zext i1 %2 to i32
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @ksd_op(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = alloca [16 x i8], align 1
  %5 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %338, label %7

7:                                                ; preds = %3
  switch i32 %0, label %338 [
    i32 5, label %8
    i32 4, label %181
  ]

8:                                                ; preds = %7
  store i32 0, ptr @sd_sectors, align 4, !tbaa !3
  %9 = inttoptr i32 %5 to ptr
  store volatile i32 263, ptr %9, align 4, !tbaa !3
  %10 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %11 = add i32 %10, 16
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 254, ptr %12, align 4, !tbaa !3
  %13 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %14 = add i32 %13, 4
  %15 = inttoptr i32 %14 to ptr
  store volatile i32 2, ptr %15, align 4, !tbaa !3
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %16

16:                                               ; preds = %20, %8
  %17 = phi i32 [ 0, %8 ], [ %22, %20 ]
  %18 = icmp eq i32 %17, 10
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  tail call fastcc void @cs(i32 noundef 1) #6
  br label %23

20:                                               ; preds = %16
  %21 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %22 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !7

23:                                               ; preds = %30, %19
  %24 = phi i32 [ 0, %19 ], [ %31, %30 ]
  %25 = phi i32 [ 255, %19 ], [ %28, %30 ]
  %26 = icmp eq i32 %24, 8
  br i1 %26, label %32, label %27

27:                                               ; preds = %23
  %28 = tail call fastcc i32 @sd_cmd(i32 noundef 0, i32 noundef 0, i32 noundef 149) #6
  %29 = icmp eq i32 %28, 1
  br i1 %29, label %32, label %30

30:                                               ; preds = %27
  tail call fastcc void @sd_wait_ready() #6
  %31 = add nuw nsw i32 %24, 1
  br label %23, !llvm.loop !10

32:                                               ; preds = %27, %23
  %33 = phi i32 [ %25, %23 ], [ 1, %27 ]
  tail call void @klogts() #7
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str, i32 noundef %33) #6
  %34 = icmp eq i32 %33, 1
  br i1 %34, label %36, label %35

35:                                               ; preds = %32
  tail call fastcc void @cs(i32 noundef 0) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 1) #7
  br label %338

36:                                               ; preds = %32
  %37 = tail call fastcc i32 @sd_cmd(i32 noundef 8, i32 noundef 426, i32 noundef 135) #6
  %38 = icmp eq i32 %37, 1
  br i1 %38, label %39, label %52

39:                                               ; preds = %36, %47
  %40 = phi i32 [ %50, %47 ], [ 0, %36 ]
  %41 = phi i32 [ %51, %47 ], [ 0, %36 ]
  %42 = icmp eq i32 %41, 4
  br i1 %42, label %43, label %47

43:                                               ; preds = %39
  %44 = and i32 %40, 4095
  %45 = icmp eq i32 %44, 426
  %46 = zext i1 %45 to i32
  br label %52

47:                                               ; preds = %39
  %48 = shl i32 %40, 8
  %49 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %50 = or disjoint i32 %49, %48
  %51 = add nuw nsw i32 %41, 1
  br label %39, !llvm.loop !11

52:                                               ; preds = %43, %36
  %53 = phi i32 [ %46, %43 ], [ 0, %36 ]
  %54 = icmp eq i32 %53, 0
  %55 = select i1 %54, i32 0, i32 1073741824
  br label %56

56:                                               ; preds = %59, %52
  %57 = phi i32 [ 0, %52 ], [ %63, %59 ]
  %58 = icmp eq i32 %57, 20000
  br i1 %58, label %64, label %59

59:                                               ; preds = %56
  %60 = tail call fastcc i32 @sd_cmd(i32 noundef 55, i32 noundef 0, i32 noundef 1) #6
  %61 = tail call fastcc i32 @sd_cmd(i32 noundef 41, i32 noundef %55, i32 noundef 1) #6
  %62 = icmp eq i32 %61, 0
  %63 = add nuw nsw i32 %57, 1
  br i1 %62, label %65, label %56, !llvm.loop !12

64:                                               ; preds = %56
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.2, i32 noundef %53) #6
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.3, i32 noundef 0) #6
  tail call fastcc void @cs(i32 noundef 0) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 1) #7
  br label %338

65:                                               ; preds = %59
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.2, i32 noundef %53) #6
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.3, i32 noundef 1) #6
  store i32 0, ptr @sd_hc, align 4, !tbaa !3
  br i1 %54, label %83, label %66

66:                                               ; preds = %65
  %67 = tail call fastcc i32 @sd_cmd(i32 noundef 58, i32 noundef 0, i32 noundef 1) #6
  %68 = icmp eq i32 %67, 0
  br i1 %68, label %69, label %83

69:                                               ; preds = %66, %78
  %70 = phi i32 [ %81, %78 ], [ 0, %66 ]
  %71 = phi i32 [ %82, %78 ], [ 0, %66 ]
  %72 = icmp eq i32 %71, 4
  br i1 %72, label %73, label %78

73:                                               ; preds = %69
  %74 = lshr i32 %70, 30
  %75 = and i32 %74, 1
  store i32 %75, ptr @sd_hc, align 4, !tbaa !3
  %76 = icmp eq i32 %75, 0
  %77 = tail call fastcc i32 @sd_cmd(i32 noundef 59, i32 noundef 0, i32 noundef 1) #6
  br i1 %76, label %85, label %87

78:                                               ; preds = %69
  %79 = shl i32 %70, 8
  %80 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %81 = or disjoint i32 %80, %79
  %82 = add nuw nsw i32 %71, 1
  br label %69, !llvm.loop !13

83:                                               ; preds = %66, %65
  %84 = tail call fastcc i32 @sd_cmd(i32 noundef 59, i32 noundef 0, i32 noundef 1) #6
  br label %85

85:                                               ; preds = %83, %73
  %86 = tail call fastcc i32 @sd_cmd(i32 noundef 16, i32 noundef 512, i32 noundef 1) #6
  br label %87

87:                                               ; preds = %85, %73
  %88 = tail call fastcc i32 @sd_cmd(i32 noundef 9, i32 noundef 0, i32 noundef 1) #6
  %89 = icmp eq i32 %88, 0
  br i1 %89, label %90, label %163

90:                                               ; preds = %87, %93
  %91 = phi i32 [ %96, %93 ], [ 0, %87 ]
  %92 = icmp eq i32 %91, 200000
  br i1 %92, label %163, label %93

93:                                               ; preds = %90
  %94 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %95 = icmp eq i32 %94, 254
  %96 = add nuw nsw i32 %91, 1
  br i1 %95, label %97, label %90, !llvm.loop !14

97:                                               ; preds = %93
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #8
  br label %98

98:                                               ; preds = %107, %97
  %99 = phi i32 [ 0, %97 ], [ %110, %107 ]
  %100 = icmp eq i32 %99, 16
  %101 = tail call fastcc i32 @xf(i32 noundef 255) #6
  br i1 %100, label %102, label %107

102:                                              ; preds = %98
  %103 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %104 = load i8, ptr %4, align 1, !tbaa !15
  %105 = and i8 %104, -64
  %106 = icmp eq i8 %105, 64
  br i1 %106, label %111, label %127

107:                                              ; preds = %98
  %108 = trunc nuw i32 %101 to i8
  %109 = getelementptr inbounds nuw [16 x i8], ptr %4, i32 0, i32 %99
  store i8 %108, ptr %109, align 1, !tbaa !15
  %110 = add nuw nsw i32 %99, 1
  br label %98, !llvm.loop !16

111:                                              ; preds = %102
  %112 = getelementptr inbounds nuw i8, ptr %4, i32 7
  %113 = load i8, ptr %112, align 1, !tbaa !15
  %114 = zext i8 %113 to i32
  %115 = shl nuw nsw i32 %114, 16
  %116 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %117 = load i8, ptr %116, align 1, !tbaa !15
  %118 = zext i8 %117 to i32
  %119 = shl nuw nsw i32 %118, 8
  %120 = or disjoint i32 %119, %115
  %121 = getelementptr inbounds nuw i8, ptr %4, i32 9
  %122 = load i8, ptr %121, align 1, !tbaa !15
  %123 = zext i8 %122 to i32
  %124 = or disjoint i32 %120, %123
  %125 = shl i32 %124, 10
  %126 = add i32 %125, 1024
  br label %161

127:                                              ; preds = %102
  %128 = getelementptr inbounds nuw i8, ptr %4, i32 6
  %129 = load i8, ptr %128, align 1, !tbaa !15
  %130 = and i8 %129, 3
  %131 = zext nneg i8 %130 to i32
  %132 = shl nuw nsw i32 %131, 10
  %133 = getelementptr inbounds nuw i8, ptr %4, i32 7
  %134 = load i8, ptr %133, align 1, !tbaa !15
  %135 = zext i8 %134 to i32
  %136 = shl nuw nsw i32 %135, 2
  %137 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %138 = load i8, ptr %137, align 1, !tbaa !15
  %139 = lshr i8 %138, 6
  %140 = zext nneg i8 %139 to i32
  %141 = getelementptr inbounds nuw i8, ptr %4, i32 9
  %142 = load i8, ptr %141, align 1, !tbaa !15
  %143 = shl i8 %142, 1
  %144 = and i8 %143, 6
  %145 = getelementptr inbounds nuw i8, ptr %4, i32 10
  %146 = load i8, ptr %145, align 1, !tbaa !15
  %147 = lshr i8 %146, 7
  %148 = getelementptr inbounds nuw i8, ptr %4, i32 5
  %149 = load i8, ptr %148, align 1, !tbaa !15
  %150 = and i8 %149, 15
  %151 = zext nneg i8 %150 to i32
  %152 = or disjoint i32 %132, %136
  %153 = or disjoint i32 %152, 1
  %154 = add nuw nsw i32 %153, %140
  %155 = or disjoint i8 %147, 2
  %156 = add nuw nsw i8 %155, %144
  %157 = zext nneg i8 %156 to i32
  %158 = shl nuw nsw i32 %154, %157
  %159 = shl i32 %158, %151
  %160 = lshr i32 %159, 9
  br label %161

161:                                              ; preds = %127, %111
  %162 = phi i32 [ %160, %127 ], [ %126, %111 ]
  store i32 %162, ptr @sd_sectors, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #8
  br label %163

163:                                              ; preds = %90, %161, %87
  tail call fastcc void @cs(i32 noundef 0) #6
  %164 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %165 = inttoptr i32 %164 to ptr
  store volatile i32 7, ptr %165, align 4, !tbaa !3
  %166 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %167 = add i32 %166, 16
  %168 = inttoptr i32 %167 to ptr
  store volatile i32 6, ptr %168, align 4, !tbaa !3
  %169 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %170 = add i32 %169, 4
  %171 = inttoptr i32 %170 to ptr
  store volatile i32 2, ptr %171, align 4, !tbaa !3
  %172 = load i32, ptr @sd_hc, align 4, !tbaa !3
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.4, i32 noundef %172) #6
  %173 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.5, i32 noundef %173) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 1) #7
  %174 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %175 = icmp eq i32 %174, 0
  %176 = sext i1 %175 to i32
  %177 = inttoptr i32 %2 to ptr
  store volatile i32 %176, ptr %177, align 4, !tbaa !3
  %178 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %179 = add i32 %2, 4
  %180 = inttoptr i32 %179 to ptr
  store volatile i32 %178, ptr %180, align 4, !tbaa !3
  br label %338

181:                                              ; preds = %7
  %182 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %183 = icmp eq i32 %182, 0
  br i1 %183, label %334, label %184

184:                                              ; preds = %181
  %185 = load i32, ptr @sd_burst_state, align 4, !tbaa !3
  %186 = icmp eq i32 %185, 2
  br i1 %186, label %187, label %189

187:                                              ; preds = %184
  %188 = tail call fastcc i32 @sd_read_polled(i32 noundef %1, i32 noundef %2) #6
  br label %334

189:                                              ; preds = %184
  %190 = tail call fastcc i32 @sd_begin_read_any(i32 noundef %1) #6
  %191 = icmp eq i32 %190, 0
  br i1 %191, label %192, label %334

192:                                              ; preds = %189
  %193 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %194 = add i32 %193, 12
  %195 = inttoptr i32 %194 to ptr
  %196 = add i32 %193, 8
  %197 = inttoptr i32 %196 to ptr
  br label %198

198:                                              ; preds = %202, %192
  %199 = load volatile i32, ptr %195, align 4, !tbaa !3
  %200 = and i32 %199, 4
  %201 = icmp eq i32 %200, 0
  br i1 %201, label %204, label %202

202:                                              ; preds = %198
  %203 = load volatile i32, ptr %197, align 4, !tbaa !3
  br label %198, !llvm.loop !17

204:                                              ; preds = %198
  %205 = add i32 %193, 36
  %206 = inttoptr i32 %205 to ptr
  store volatile i32 3, ptr %206, align 4, !tbaa !3
  %207 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %208 = add i32 %207, 8
  store volatile i32 %208, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 %2, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  store volatile i32 512, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %209 = load i32, ptr @sd_rxctrl, align 4, !tbaa !3
  store volatile i32 %209, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  %210 = load i32, ptr @sd_txch, align 4, !tbaa !3
  %211 = icmp eq i32 %210, 0
  br i1 %211, label %212, label %213

212:                                              ; preds = %213, %204
  br label %241

213:                                              ; preds = %204
  %214 = add i32 %210, 16
  %215 = inttoptr i32 %214 to ptr
  %216 = load volatile i32, ptr %215, align 4, !tbaa !3
  %217 = and i32 %216, 67108864
  %218 = icmp eq i32 %217, 0
  br i1 %218, label %219, label %212

219:                                              ; preds = %213
  %220 = inttoptr i32 %210 to ptr
  %221 = load volatile i32, ptr %220, align 4, !tbaa !3
  %222 = add i32 %210, 4
  %223 = inttoptr i32 %222 to ptr
  %224 = load volatile i32, ptr %223, align 4, !tbaa !3
  %225 = load volatile i32, ptr %215, align 4, !tbaa !3
  store volatile i32 ptrtoint (ptr @sd_ff to i32), ptr %220, align 4, !tbaa !3
  %226 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %227 = add i32 %226, 8
  store volatile i32 %227, ptr %223, align 4, !tbaa !3
  %228 = load i32, ptr @sd_txctrl, align 4, !tbaa !3
  store volatile i32 %228, ptr %215, align 4, !tbaa !3
  %229 = add i32 %210, 28
  %230 = inttoptr i32 %229 to ptr
  store volatile i32 512, ptr %230, align 4, !tbaa !3
  br label %231

231:                                              ; preds = %231, %219
  %232 = phi i32 [ 0, %219 ], [ %238, %231 ]
  %233 = load volatile i32, ptr %215, align 4, !tbaa !3
  %234 = and i32 %233, 67108864
  %235 = icmp ne i32 %234, 0
  %236 = icmp samesign ult i32 %232, 4000000
  %237 = select i1 %235, i1 %236, i1 false
  %238 = add nuw nsw i32 %232, 1
  br i1 %237, label %231, label %239, !llvm.loop !18

239:                                              ; preds = %231
  store volatile i32 %221, ptr %220, align 4, !tbaa !3
  store volatile i32 %224, ptr %223, align 4, !tbaa !3
  store volatile i32 %225, ptr %215, align 4, !tbaa !3
  br label %240

240:                                              ; preds = %241, %239
  br label %295

241:                                              ; preds = %212, %291
  %242 = phi i32 [ %293, %291 ], [ 0, %212 ]
  %243 = phi i32 [ %294, %291 ], [ 0, %212 ]
  %244 = icmp ult i32 %242, 512
  %245 = icmp samesign ult i32 %243, 4000000
  %246 = select i1 %244, i1 %245, i1 false
  br i1 %246, label %247, label %240

247:                                              ; preds = %241
  %248 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %249 = or disjoint i32 %242, -512
  %250 = add i32 %248, %249
  %251 = icmp eq i32 %250, 0
  %252 = icmp samesign ult i32 %242, 505
  %253 = and i1 %252, %251
  br i1 %253, label %254, label %279

254:                                              ; preds = %247
  %255 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %256 = add i32 %255, 8
  %257 = inttoptr i32 %256 to ptr
  store volatile i32 255, ptr %257, align 4, !tbaa !3
  %258 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %259 = add i32 %258, 8
  %260 = inttoptr i32 %259 to ptr
  store volatile i32 255, ptr %260, align 4, !tbaa !3
  %261 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %262 = add i32 %261, 8
  %263 = inttoptr i32 %262 to ptr
  store volatile i32 255, ptr %263, align 4, !tbaa !3
  %264 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %265 = add i32 %264, 8
  %266 = inttoptr i32 %265 to ptr
  store volatile i32 255, ptr %266, align 4, !tbaa !3
  %267 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %268 = add i32 %267, 8
  %269 = inttoptr i32 %268 to ptr
  store volatile i32 255, ptr %269, align 4, !tbaa !3
  %270 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %271 = add i32 %270, 8
  %272 = inttoptr i32 %271 to ptr
  store volatile i32 255, ptr %272, align 4, !tbaa !3
  %273 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %274 = add i32 %273, 8
  %275 = inttoptr i32 %274 to ptr
  store volatile i32 255, ptr %275, align 4, !tbaa !3
  %276 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %277 = add i32 %276, 8
  %278 = inttoptr i32 %277 to ptr
  store volatile i32 255, ptr %278, align 4, !tbaa !3
  br label %291

279:                                              ; preds = %247
  %280 = tail call i32 @llvm.usub.sat.i32(i32 8, i32 %250)
  %281 = sub nuw nsw i32 512, %242
  %282 = tail call i32 @llvm.umin.i32(i32 %280, i32 %281)
  br label %283

283:                                              ; preds = %286, %279
  %284 = phi i32 [ 0, %279 ], [ %290, %286 ]
  %285 = icmp eq i32 %284, %282
  br i1 %285, label %291, label %286

286:                                              ; preds = %283
  %287 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %288 = add i32 %287, 8
  %289 = inttoptr i32 %288 to ptr
  store volatile i32 255, ptr %289, align 4, !tbaa !3
  %290 = add nuw nsw i32 %284, 1
  br label %283, !llvm.loop !19

291:                                              ; preds = %283, %254
  %292 = phi i32 [ 8, %254 ], [ %282, %283 ]
  %293 = add nuw nsw i32 %292, %242
  %294 = add nuw nsw i32 %243, 1
  br label %241, !llvm.loop !20

295:                                              ; preds = %240, %295
  %296 = phi i32 [ %301, %295 ], [ 0, %240 ]
  %297 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %298 = icmp ne i32 %297, 0
  %299 = icmp samesign ult i32 %296, 4000000
  %300 = select i1 %298, i1 %299, i1 false
  %301 = add nuw nsw i32 %296, 1
  br i1 %300, label %295, label %302, !llvm.loop !21

302:                                              ; preds = %295
  %303 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %304 = add i32 %303, 36
  %305 = inttoptr i32 %304 to ptr
  store volatile i32 0, ptr %305, align 4, !tbaa !3
  %306 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %307 = icmp eq i32 %306, 0
  br i1 %307, label %331, label %308

308:                                              ; preds = %302
  %309 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  store volatile i32 2048, ptr inttoptr (i32 1342178404 to ptr), align 4, !tbaa !3
  br label %310

310:                                              ; preds = %310, %308
  %311 = phi i32 [ 0, %308 ], [ %317, %310 ]
  %312 = load volatile i32, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !3
  %313 = and i32 %312, 67108864
  %314 = icmp ne i32 %313, 0
  %315 = icmp samesign ult i32 %311, 100000
  %316 = select i1 %314, i1 %315, i1 false
  %317 = add nuw nsw i32 %311, 1
  br i1 %316, label %310, label %318, !llvm.loop !22

318:                                              ; preds = %310
  store volatile i32 0, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !3
  %319 = load i32, ptr @sd_burst_state, align 4, !tbaa !3
  %320 = icmp eq i32 %319, 2
  br i1 %320, label %322, label %321

321:                                              ; preds = %318
  store i32 2, ptr @sd_burst_state, align 4, !tbaa !3
  tail call void @klogts() #7
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.7, i32 noundef %309) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.8, i32 noundef 11) #7
  br label %322

322:                                              ; preds = %321, %318
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %323

323:                                              ; preds = %328, %322
  %324 = phi i32 [ 0, %322 ], [ %330, %328 ]
  %325 = icmp eq i32 %324, 4
  br i1 %325, label %326, label %328

326:                                              ; preds = %323
  %327 = tail call fastcc i32 @sd_read_polled(i32 noundef %1, i32 noundef %2) #6
  br label %334

328:                                              ; preds = %323
  %329 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %330 = add nuw nsw i32 %324, 1
  br label %323, !llvm.loop !23

331:                                              ; preds = %302
  store i32 1, ptr @sd_burst_state, align 4, !tbaa !3
  %332 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %333 = tail call fastcc i32 @xf(i32 noundef 255) #6
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %334

334:                                              ; preds = %181, %187, %189, %326, %331
  %335 = phi i32 [ %188, %187 ], [ -1, %181 ], [ %190, %189 ], [ %327, %326 ], [ 0, %331 ]
  %336 = icmp ne i32 %335, 0
  %337 = sext i1 %336 to i32
  br label %338

338:                                              ; preds = %163, %64, %35, %7, %3, %334
  %339 = phi i32 [ %337, %334 ], [ -1, %3 ], [ -1, %7 ], [ 0, %35 ], [ 0, %64 ], [ 0, %163 ]
  ret i32 %339
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @cs(i32 noundef range(i32 0, 2) %0) unnamed_addr #2 {
  %2 = icmp eq i32 %0, 0
  %3 = load i32, ptr @sd_cs_lo, align 4
  %4 = load i32, ptr @sd_cs_hi, align 4
  %5 = select i1 %2, i32 %4, i32 %3
  %6 = load i32, ptr @sd_csreg, align 4, !tbaa !3
  %7 = inttoptr i32 %6 to ptr
  store volatile i32 %5, ptr %7, align 4, !tbaa !3
  %8 = tail call fastcc i32 @xf(i32 noundef 255) #6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 0, 256) i32 @xf(i32 noundef %0) unnamed_addr #2 {
  %2 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %3 = add i32 %2, 8
  %4 = inttoptr i32 %3 to ptr
  store volatile i32 %0, ptr %4, align 4, !tbaa !3
  %5 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %6 = add i32 %5, 12
  %7 = inttoptr i32 %6 to ptr
  br label %8

8:                                                ; preds = %11, %1
  %9 = phi i32 [ 0, %1 ], [ %15, %11 ]
  %10 = icmp eq i32 %9, 100000
  br i1 %10, label %21, label %11

11:                                               ; preds = %8
  %12 = load volatile i32, ptr %7, align 4, !tbaa !3
  %13 = and i32 %12, 4
  %14 = icmp eq i32 %13, 0
  %15 = add nuw nsw i32 %9, 1
  br i1 %14, label %8, label %16, !llvm.loop !24

16:                                               ; preds = %11
  %17 = add i32 %5, 8
  %18 = inttoptr i32 %17 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !3
  %20 = and i32 %19, 255
  br label %21

21:                                               ; preds = %8, %16
  %22 = phi i32 [ %20, %16 ], [ 255, %8 ]
  ret i32 %22
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 0, 256) i32 @sd_cmd(i32 noundef range(i32 0, 60) %0, i32 noundef %1, i32 noundef range(i32 1, 150) %2) unnamed_addr #2 {
  %4 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %5 = add i32 %4, 12
  %6 = inttoptr i32 %5 to ptr
  %7 = add i32 %4, 8
  %8 = inttoptr i32 %7 to ptr
  br label %9

9:                                                ; preds = %13, %3
  %10 = load volatile i32, ptr %6, align 4, !tbaa !3
  %11 = and i32 %10, 4
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %15, label %13

13:                                               ; preds = %9
  %14 = load volatile i32, ptr %8, align 4, !tbaa !3
  br label %9, !llvm.loop !25

15:                                               ; preds = %9
  %16 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %17 = or disjoint i32 %0, 64
  %18 = tail call fastcc i32 @xf(i32 noundef %17) #6
  %19 = lshr i32 %1, 24
  %20 = tail call fastcc i32 @xf(i32 noundef %19) #6
  %21 = lshr i32 %1, 16
  %22 = tail call fastcc i32 @xf(i32 noundef %21) #6
  %23 = lshr i32 %1, 8
  %24 = tail call fastcc i32 @xf(i32 noundef %23) #6
  %25 = tail call fastcc i32 @xf(i32 noundef %1) #6
  %26 = tail call fastcc i32 @xf(i32 noundef %2) #6
  br label %27

27:                                               ; preds = %30, %15
  %28 = phi i32 [ 0, %15 ], [ %33, %30 ]
  %29 = icmp eq i32 %28, 9
  br i1 %29, label %34, label %30

30:                                               ; preds = %27
  %31 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %32 = icmp samesign ult i32 %31, 128
  %33 = add nuw nsw i32 %28, 1
  br i1 %32, label %34, label %27, !llvm.loop !26

34:                                               ; preds = %27, %30
  %35 = phi i32 [ %31, %30 ], [ 255, %27 ]
  ret i32 %35
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @sd_wait_ready() unnamed_addr #2 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %7, %4 ]
  %3 = icmp eq i32 %2, 500000
  br i1 %3, label %8, label %4

4:                                                ; preds = %1
  %5 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %6 = icmp eq i32 %5, 255
  %7 = add nuw nsw i32 %2, 1
  br i1 %6, label %8, label %1, !llvm.loop !27

8:                                                ; preds = %4, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @klogts() local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @sd_diag(ptr noundef readonly captures(none) %0, i32 noundef %1) unnamed_addr #1 {
  %3 = alloca [16 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #8
  br label %4

4:                                                ; preds = %9, %2
  %5 = phi i32 [ 0, %2 ], [ %11, %9 ]
  %6 = phi ptr [ %0, %2 ], [ %10, %9 ]
  %7 = load i8, ptr %6, align 1, !tbaa !15
  %8 = icmp eq i8 %7, 0
  br i1 %8, label %13, label %9

9:                                                ; preds = %4
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %11 = add nuw nsw i32 %5, 1
  %12 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %5
  store i8 %7, ptr %12, align 1, !tbaa !15
  br label %4, !llvm.loop !28

13:                                               ; preds = %4
  %14 = lshr i32 %1, 28
  %15 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %14
  %16 = load i8, ptr %15, align 1, !tbaa !15
  %17 = add nuw nsw i32 %5, 1
  %18 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %5
  store i8 %16, ptr %18, align 1, !tbaa !15
  %19 = lshr i32 %1, 24
  %20 = and i32 %19, 15
  %21 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %20
  %22 = load i8, ptr %21, align 1, !tbaa !15
  %23 = add nuw nsw i32 %5, 2
  %24 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %17
  store i8 %22, ptr %24, align 1, !tbaa !15
  %25 = lshr i32 %1, 20
  %26 = and i32 %25, 15
  %27 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %26
  %28 = load i8, ptr %27, align 1, !tbaa !15
  %29 = add nuw nsw i32 %5, 3
  %30 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %23
  store i8 %28, ptr %30, align 1, !tbaa !15
  %31 = lshr i32 %1, 16
  %32 = and i32 %31, 15
  %33 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %32
  %34 = load i8, ptr %33, align 1, !tbaa !15
  %35 = add nuw nsw i32 %5, 4
  %36 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %29
  store i8 %34, ptr %36, align 1, !tbaa !15
  %37 = lshr i32 %1, 12
  %38 = and i32 %37, 15
  %39 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %38
  %40 = load i8, ptr %39, align 1, !tbaa !15
  %41 = add nuw nsw i32 %5, 5
  %42 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %35
  store i8 %40, ptr %42, align 1, !tbaa !15
  %43 = lshr i32 %1, 8
  %44 = and i32 %43, 15
  %45 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %44
  %46 = load i8, ptr %45, align 1, !tbaa !15
  %47 = add nuw nsw i32 %5, 6
  %48 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %41
  store i8 %46, ptr %48, align 1, !tbaa !15
  %49 = lshr i32 %1, 4
  %50 = and i32 %49, 15
  %51 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %50
  %52 = load i8, ptr %51, align 1, !tbaa !15
  %53 = add nuw nsw i32 %5, 7
  %54 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %47
  store i8 %52, ptr %54, align 1, !tbaa !15
  %55 = and i32 %1, 15
  %56 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %55
  %57 = load i8, ptr %56, align 1, !tbaa !15
  %58 = add nuw nsw i32 %5, 8
  %59 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %53
  store i8 %57, ptr %59, align 1, !tbaa !15
  call void @kconswrite(ptr noundef nonnull %3, i32 noundef %58) #7
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kconswrite(ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -3, 1) i32 @sd_read_polled(i32 noundef %0, i32 noundef %1) unnamed_addr #1 {
  %3 = tail call fastcc i32 @sd_begin_read_any(i32 noundef %0) #6
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %16

5:                                                ; preds = %2, %11
  %6 = phi i32 [ %15, %11 ], [ 0, %2 ]
  %7 = icmp eq i32 %6, 512
  %8 = tail call fastcc i32 @xf(i32 noundef 255) #6
  br i1 %7, label %9, label %11

9:                                                ; preds = %5
  %10 = tail call fastcc i32 @xf(i32 noundef 255) #6
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %16

11:                                               ; preds = %5
  %12 = trunc nuw i32 %8 to i8
  %13 = add i32 %6, %1
  %14 = inttoptr i32 %13 to ptr
  store volatile i8 %12, ptr %14, align 1, !tbaa !15
  %15 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !29

16:                                               ; preds = %2, %9
  %17 = phi i32 [ 0, %9 ], [ %3, %2 ]
  ret i32 %17
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -3, 1) i32 @sd_begin_read_any(i32 noundef %0) unnamed_addr #1 {
  %2 = tail call fastcc i32 @sd_begin_read(i32 noundef %0) #6
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %17, label %4

4:                                                ; preds = %1
  %5 = load i1, ptr @sd_slow, align 4
  br i1 %5, label %17, label %6

6:                                                ; preds = %4
  store i1 true, ptr @sd_slow, align 4
  %7 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %8 = inttoptr i32 %7 to ptr
  store volatile i32 263, ptr %8, align 4, !tbaa !3
  %9 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %10 = add i32 %9, 16
  %11 = inttoptr i32 %10 to ptr
  store volatile i32 254, ptr %11, align 4, !tbaa !3
  %12 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %13 = add i32 %12, 4
  %14 = inttoptr i32 %13 to ptr
  store volatile i32 2, ptr %14, align 4, !tbaa !3
  tail call void @klogts() #7
  %15 = sub nsw i32 0, %2
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.9, i32 noundef %15) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.10, i32 noundef 9) #7
  %16 = tail call fastcc i32 @sd_begin_read(i32 noundef %0) #6
  br label %17

17:                                               ; preds = %1, %4, %6
  %18 = phi i32 [ %16, %6 ], [ %2, %4 ], [ 0, %1 ]
  ret i32 %18
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -3, 1) i32 @sd_begin_read(i32 noundef %0) unnamed_addr #1 {
  tail call fastcc void @cs(i32 noundef 1) #6
  %2 = load i32, ptr @sd_hc, align 4
  %3 = icmp eq i32 %2, 0
  %4 = shl i32 %0, 9
  %5 = select i1 %3, i32 %4, i32 %0
  br label %6

6:                                                ; preds = %10, %1
  %7 = phi i32 [ 255, %1 ], [ %11, %10 ]
  %8 = phi i32 [ 0, %1 ], [ %13, %10 ]
  %9 = icmp eq i32 %8, 4
  br i1 %9, label %14, label %10

10:                                               ; preds = %6
  tail call fastcc void @sd_wait_ready() #6
  %11 = tail call fastcc i32 @sd_cmd(i32 noundef 17, i32 noundef %5, i32 noundef 1) #6
  %12 = icmp eq i32 %11, 0
  %13 = add nuw nsw i32 %8, 1
  br i1 %12, label %15, label %6, !llvm.loop !30

14:                                               ; preds = %6
  tail call fastcc void @cs(i32 noundef 0) #6
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.11, i32 noundef %7) #6
  br label %26

15:                                               ; preds = %10, %23
  %16 = phi i32 [ %24, %23 ], [ 0, %10 ]
  %17 = icmp eq i32 %16, 2000000
  br i1 %17, label %25, label %18

18:                                               ; preds = %15
  %19 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %20 = trunc nuw i32 %19 to i8
  switch i8 %20, label %21 [
    i8 -2, label %26
    i8 -1, label %23
    i8 0, label %23
  ]

21:                                               ; preds = %18
  %22 = icmp samesign ult i32 %19, 16
  br i1 %22, label %25, label %23

23:                                               ; preds = %18, %18, %21
  %24 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !31

25:                                               ; preds = %21, %15
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %26

26:                                               ; preds = %18, %25, %14
  %27 = phi i32 [ -2, %14 ], [ -3, %25 ], [ 0, %18 ]
  ret i32 %27
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.usub.sat.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #5

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { nounwind }

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
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = !{!5, !5, i64 0}
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
