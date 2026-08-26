; ModuleID = 'dma/ksd.c'
source_filename = "dma/ksd.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@sd_spi = dso_local local_unnamed_addr global i32 0, align 4
@sd_csreg = dso_local local_unnamed_addr global i32 0, align 4
@sd_cs_hi = dso_local local_unnamed_addr global i32 0, align 4
@sd_cs_lo = dso_local local_unnamed_addr global i32 0, align 4
@sd_rxctrl = dso_local local_unnamed_addr global i32 0, align 4
@sd_sectors = internal unnamed_addr global i32 0, align 4
@sd_hc = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @ksd_on() local_unnamed_addr #0 {
  %1 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %2 = icmp ne i32 %1, 0
  %3 = zext i1 %2 to i32
  ret i32 %3
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 1) i32 @ksd_op(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = alloca [16 x i8], align 1
  %5 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %228, label %7

7:                                                ; preds = %3
  switch i32 %0, label %228 [
    i32 5, label %8
    i32 4, label %151
  ]

8:                                                ; preds = %7
  store i32 0, ptr @sd_sectors, align 4, !tbaa !3
  tail call fastcc void @sd_clock(i32 noundef 254, i32 noundef 1) #3
  tail call fastcc void @cs(i32 noundef 0) #3
  br label %9

9:                                                ; preds = %15, %8
  %10 = phi i32 [ 0, %8 ], [ %17, %15 ]
  %11 = icmp eq i32 %10, 10
  br i1 %11, label %12, label %15

12:                                               ; preds = %9
  tail call fastcc void @cs(i32 noundef 1) #3
  %13 = tail call fastcc i32 @sd_cmd(i32 noundef 0, i32 noundef 0, i32 noundef 149) #3
  %14 = icmp eq i32 %13, 1
  br i1 %14, label %19, label %18

15:                                               ; preds = %9
  %16 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %17 = add nuw nsw i32 %10, 1
  br label %9, !llvm.loop !7

18:                                               ; preds = %12
  tail call fastcc void @cs(i32 noundef 0) #3
  br label %228

19:                                               ; preds = %12
  %20 = tail call fastcc i32 @sd_cmd(i32 noundef 8, i32 noundef 426, i32 noundef 135) #3
  %21 = icmp eq i32 %20, 1
  br i1 %21, label %22, label %36

22:                                               ; preds = %19, %27
  %23 = phi i32 [ %31, %27 ], [ 0, %19 ]
  %24 = phi i32 [ %30, %27 ], [ 0, %19 ]
  %25 = freeze i32 %24
  %26 = icmp eq i32 %23, 4
  br i1 %26, label %32, label %27

27:                                               ; preds = %22
  %28 = shl i32 %25, 8
  %29 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %30 = or disjoint i32 %29, %28
  %31 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !10

32:                                               ; preds = %22
  %33 = and i32 %25, 4095
  %34 = icmp ne i32 %33, 426
  %35 = select i1 %34, i32 0, i32 1073741824
  br label %36

36:                                               ; preds = %32, %19
  %37 = phi i1 [ true, %19 ], [ %34, %32 ]
  %38 = phi i32 [ 0, %19 ], [ %35, %32 ]
  br label %39

39:                                               ; preds = %42, %36
  %40 = phi i32 [ 0, %36 ], [ %46, %42 ]
  %41 = icmp eq i32 %40, 20000
  br i1 %41, label %47, label %42

42:                                               ; preds = %39
  %43 = tail call fastcc i32 @sd_cmd(i32 noundef 55, i32 noundef 0, i32 noundef 1) #3
  %44 = tail call fastcc i32 @sd_cmd(i32 noundef 41, i32 noundef %38, i32 noundef 1) #3
  %45 = icmp eq i32 %44, 0
  %46 = add nuw nsw i32 %40, 1
  br i1 %45, label %48, label %39, !llvm.loop !11

47:                                               ; preds = %39
  tail call fastcc void @cs(i32 noundef 0) #3
  br label %228

48:                                               ; preds = %42
  store i32 0, ptr @sd_hc, align 4, !tbaa !3
  br i1 %37, label %65, label %49

49:                                               ; preds = %48
  %50 = tail call fastcc i32 @sd_cmd(i32 noundef 58, i32 noundef 0, i32 noundef 1) #3
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %52, label %65

52:                                               ; preds = %49, %56
  %53 = phi i32 [ %59, %56 ], [ 0, %49 ]
  %54 = phi i32 [ %60, %56 ], [ 0, %49 ]
  %55 = icmp eq i32 %54, 4
  br i1 %55, label %61, label %56

56:                                               ; preds = %52
  %57 = shl i32 %53, 8
  %58 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %59 = or disjoint i32 %58, %57
  %60 = add nuw nsw i32 %54, 1
  br label %52, !llvm.loop !12

61:                                               ; preds = %52
  %62 = lshr i32 %53, 30
  %63 = and i32 %62, 1
  store i32 %63, ptr @sd_hc, align 4, !tbaa !3
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %65, label %67

65:                                               ; preds = %61, %49, %48
  %66 = tail call fastcc i32 @sd_cmd(i32 noundef 16, i32 noundef 512, i32 noundef 1) #3
  br label %67

67:                                               ; preds = %65, %61
  %68 = tail call fastcc i32 @sd_cmd(i32 noundef 9, i32 noundef 0, i32 noundef 1) #3
  %69 = icmp eq i32 %68, 0
  br i1 %69, label %70, label %145

70:                                               ; preds = %67, %73
  %71 = phi i32 [ %76, %73 ], [ 0, %67 ]
  %72 = icmp eq i32 %71, 200000
  br i1 %72, label %145, label %73

73:                                               ; preds = %70
  %74 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %75 = icmp eq i32 %74, 254
  %76 = add nuw nsw i32 %71, 1
  br i1 %75, label %77, label %70, !llvm.loop !13

77:                                               ; preds = %73
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #4
  br label %78

78:                                               ; preds = %87, %77
  %79 = phi i32 [ 0, %77 ], [ %90, %87 ]
  %80 = icmp eq i32 %79, 16
  %81 = tail call fastcc i32 @xf(i32 noundef 255) #3
  br i1 %80, label %82, label %87

82:                                               ; preds = %78
  %83 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %84 = load i8, ptr %4, align 1, !tbaa !14
  %85 = and i8 %84, -64
  %86 = icmp eq i8 %85, 64
  br i1 %86, label %91, label %107

87:                                               ; preds = %78
  %88 = trunc nuw i32 %81 to i8
  %89 = getelementptr inbounds nuw [16 x i8], ptr %4, i32 0, i32 %79
  store i8 %88, ptr %89, align 1, !tbaa !14
  %90 = add nuw nsw i32 %79, 1
  br label %78, !llvm.loop !15

91:                                               ; preds = %82
  %92 = getelementptr inbounds nuw i8, ptr %4, i32 7
  %93 = load i8, ptr %92, align 1, !tbaa !14
  %94 = zext i8 %93 to i32
  %95 = shl nuw nsw i32 %94, 16
  %96 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %97 = load i8, ptr %96, align 1, !tbaa !14
  %98 = zext i8 %97 to i32
  %99 = shl nuw nsw i32 %98, 8
  %100 = or disjoint i32 %99, %95
  %101 = getelementptr inbounds nuw i8, ptr %4, i32 9
  %102 = load i8, ptr %101, align 1, !tbaa !14
  %103 = zext i8 %102 to i32
  %104 = or disjoint i32 %100, %103
  %105 = shl i32 %104, 10
  %106 = add i32 %105, 1024
  br label %141

107:                                              ; preds = %82
  %108 = getelementptr inbounds nuw i8, ptr %4, i32 6
  %109 = load i8, ptr %108, align 1, !tbaa !14
  %110 = and i8 %109, 3
  %111 = zext nneg i8 %110 to i32
  %112 = shl nuw nsw i32 %111, 10
  %113 = getelementptr inbounds nuw i8, ptr %4, i32 7
  %114 = load i8, ptr %113, align 1, !tbaa !14
  %115 = zext i8 %114 to i32
  %116 = shl nuw nsw i32 %115, 2
  %117 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %118 = load i8, ptr %117, align 1, !tbaa !14
  %119 = lshr i8 %118, 6
  %120 = zext nneg i8 %119 to i32
  %121 = getelementptr inbounds nuw i8, ptr %4, i32 9
  %122 = load i8, ptr %121, align 1, !tbaa !14
  %123 = shl i8 %122, 1
  %124 = and i8 %123, 6
  %125 = getelementptr inbounds nuw i8, ptr %4, i32 10
  %126 = load i8, ptr %125, align 1, !tbaa !14
  %127 = lshr i8 %126, 7
  %128 = getelementptr inbounds nuw i8, ptr %4, i32 5
  %129 = load i8, ptr %128, align 1, !tbaa !14
  %130 = and i8 %129, 15
  %131 = zext nneg i8 %130 to i32
  %132 = or disjoint i32 %112, %116
  %133 = or disjoint i32 %132, 1
  %134 = add nuw nsw i32 %133, %120
  %135 = or disjoint i8 %127, 2
  %136 = add nuw nsw i8 %135, %124
  %137 = zext nneg i8 %136 to i32
  %138 = shl nuw nsw i32 %134, %137
  %139 = shl i32 %138, %131
  %140 = lshr i32 %139, 9
  br label %141

141:                                              ; preds = %107, %91
  %142 = phi i32 [ %140, %107 ], [ %106, %91 ]
  store i32 %142, ptr @sd_sectors, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #4
  %143 = icmp eq i32 %142, 0
  %144 = sext i1 %143 to i32
  br label %145

145:                                              ; preds = %70, %141, %67
  %146 = phi i32 [ %144, %141 ], [ -1, %67 ], [ -1, %70 ]
  tail call fastcc void @cs(i32 noundef 0) #3
  tail call fastcc void @sd_clock(i32 noundef 6, i32 noundef 0) #3
  %147 = inttoptr i32 %2 to ptr
  store volatile i32 %146, ptr %147, align 4, !tbaa !3
  %148 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %149 = add i32 %2, 4
  %150 = inttoptr i32 %149 to ptr
  store volatile i32 %148, ptr %150, align 4, !tbaa !3
  br label %228

151:                                              ; preds = %7
  %152 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %153 = icmp eq i32 %152, 0
  br i1 %153, label %228, label %154

154:                                              ; preds = %151
  tail call fastcc void @cs(i32 noundef 1) #3
  %155 = load i32, ptr @sd_hc, align 4, !tbaa !3
  %156 = icmp eq i32 %155, 0
  %157 = shl i32 %1, 9
  %158 = select i1 %156, i32 %157, i32 %1
  %159 = tail call fastcc i32 @sd_cmd(i32 noundef 17, i32 noundef %158, i32 noundef 1) #3
  %160 = icmp eq i32 %159, 0
  br i1 %160, label %161, label %226

161:                                              ; preds = %154, %175
  %162 = phi i32 [ %176, %175 ], [ 0, %154 ]
  %163 = icmp eq i32 %162, 200000
  br i1 %163, label %226, label %164

164:                                              ; preds = %161
  %165 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %166 = trunc nuw i32 %165 to i8
  switch i8 %166, label %173 [
    i8 -2, label %167
    i8 -1, label %175
  ]

167:                                              ; preds = %164
  %168 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %169 = add i32 %168, 12
  %170 = inttoptr i32 %169 to ptr
  %171 = add i32 %168, 8
  %172 = inttoptr i32 %171 to ptr
  br label %177

173:                                              ; preds = %164
  %174 = icmp samesign ult i32 %165, 16
  br i1 %174, label %226, label %175

175:                                              ; preds = %173, %164
  %176 = add nuw nsw i32 %162, 1
  br label %161, !llvm.loop !16

177:                                              ; preds = %181, %167
  %178 = load volatile i32, ptr %170, align 4, !tbaa !3
  %179 = and i32 %178, 4
  %180 = icmp eq i32 %179, 0
  br i1 %180, label %183, label %181

181:                                              ; preds = %177
  %182 = load volatile i32, ptr %172, align 4, !tbaa !3
  br label %177, !llvm.loop !17

183:                                              ; preds = %177
  %184 = add i32 %168, 36
  %185 = inttoptr i32 %184 to ptr
  store volatile i32 1, ptr %185, align 4, !tbaa !3
  %186 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %187 = add i32 %186, 8
  store volatile i32 %187, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 %2, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  store volatile i32 512, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %188 = load i32, ptr @sd_rxctrl, align 4, !tbaa !3
  store volatile i32 %188, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  br label %189

189:                                              ; preds = %206, %183
  %190 = phi i32 [ 0, %183 ], [ %207, %206 ]
  %191 = phi i32 [ 0, %183 ], [ %208, %206 ]
  %192 = icmp ult i32 %190, 512
  %193 = icmp samesign ult i32 %191, 4000000
  %194 = select i1 %192, i1 %193, i1 false
  br i1 %194, label %195, label %209

195:                                              ; preds = %189
  %196 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %197 = add i32 %196, 12
  %198 = inttoptr i32 %197 to ptr
  %199 = load volatile i32, ptr %198, align 4, !tbaa !3
  %200 = and i32 %199, 2
  %201 = icmp eq i32 %200, 0
  br i1 %201, label %206, label %202

202:                                              ; preds = %195
  %203 = add i32 %196, 8
  %204 = inttoptr i32 %203 to ptr
  store volatile i32 255, ptr %204, align 4, !tbaa !3
  %205 = add nuw nsw i32 %190, 1
  br label %206

206:                                              ; preds = %202, %195
  %207 = phi i32 [ %205, %202 ], [ %190, %195 ]
  %208 = add nuw nsw i32 %191, 1
  br label %189, !llvm.loop !18

209:                                              ; preds = %189, %209
  %210 = phi i32 [ %215, %209 ], [ 0, %189 ]
  %211 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %212 = icmp ne i32 %211, 0
  %213 = icmp samesign ult i32 %210, 4000000
  %214 = select i1 %212, i1 %213, i1 false
  %215 = add nuw nsw i32 %210, 1
  br i1 %214, label %209, label %216, !llvm.loop !19

216:                                              ; preds = %209
  %217 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %218 = add i32 %217, 36
  %219 = inttoptr i32 %218 to ptr
  store volatile i32 0, ptr %219, align 4, !tbaa !3
  %220 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %221 = icmp eq i32 %220, 0
  br i1 %221, label %223, label %222

222:                                              ; preds = %216
  store volatile i32 2048, ptr inttoptr (i32 1342178404 to ptr), align 4, !tbaa !3
  br label %226

223:                                              ; preds = %216
  %224 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %225 = tail call fastcc i32 @xf(i32 noundef 255) #3
  br label %226

226:                                              ; preds = %173, %161, %223, %222, %154
  %227 = phi i32 [ 0, %223 ], [ -1, %222 ], [ -1, %154 ], [ -1, %161 ], [ -1, %173 ]
  tail call fastcc void @cs(i32 noundef 0) #3
  br label %228

228:                                              ; preds = %226, %151, %145, %47, %18, %7, %3
  %229 = phi i32 [ -1, %3 ], [ -1, %7 ], [ 0, %18 ], [ 0, %47 ], [ 0, %145 ], [ -1, %151 ], [ %227, %226 ]
  ret i32 %229
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @sd_clock(i32 noundef range(i32 6, 255) %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #1 {
  %3 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %4 = add i32 %3, 4
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 0, ptr %5, align 4, !tbaa !3
  %6 = shl nuw nsw i32 %1, 8
  %7 = or disjoint i32 %6, 7
  %8 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %9 = inttoptr i32 %8 to ptr
  store volatile i32 %7, ptr %9, align 4, !tbaa !3
  %10 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %11 = add i32 %10, 16
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 %0, ptr %12, align 4, !tbaa !3
  %13 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %14 = add i32 %13, 36
  %15 = inttoptr i32 %14 to ptr
  store volatile i32 0, ptr %15, align 4, !tbaa !3
  %16 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %17 = add i32 %16, 4
  %18 = inttoptr i32 %17 to ptr
  store volatile i32 2, ptr %18, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @cs(i32 noundef range(i32 0, 2) %0) unnamed_addr #1 {
  %2 = icmp eq i32 %0, 0
  %3 = load i32, ptr @sd_cs_lo, align 4
  %4 = load i32, ptr @sd_cs_hi, align 4
  %5 = select i1 %2, i32 %4, i32 %3
  %6 = load i32, ptr @sd_csreg, align 4, !tbaa !3
  %7 = inttoptr i32 %6 to ptr
  store volatile i32 %5, ptr %7, align 4, !tbaa !3
  %8 = tail call fastcc i32 @xf(i32 noundef 255) #3
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 0, 256) i32 @xf(i32 noundef %0) unnamed_addr #1 {
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
  br i1 %14, label %8, label %16, !llvm.loop !20

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
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 0, 256) i32 @sd_cmd(i32 noundef range(i32 0, 59) %0, i32 noundef %1, i32 noundef range(i32 1, 150) %2) unnamed_addr #1 {
  %4 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %5 = or disjoint i32 %0, 64
  %6 = tail call fastcc i32 @xf(i32 noundef %5) #3
  %7 = lshr i32 %1, 24
  %8 = tail call fastcc i32 @xf(i32 noundef %7) #3
  %9 = lshr i32 %1, 16
  %10 = tail call fastcc i32 @xf(i32 noundef %9) #3
  %11 = lshr i32 %1, 8
  %12 = tail call fastcc i32 @xf(i32 noundef %11) #3
  %13 = tail call fastcc i32 @xf(i32 noundef %1) #3
  %14 = tail call fastcc i32 @xf(i32 noundef %2) #3
  br label %15

15:                                               ; preds = %18, %3
  %16 = phi i32 [ 0, %3 ], [ %21, %18 ]
  %17 = icmp eq i32 %16, 9
  br i1 %17, label %22, label %18

18:                                               ; preds = %15
  %19 = tail call fastcc i32 @xf(i32 noundef 255) #3
  %20 = icmp samesign ult i32 %19, 128
  %21 = add nuw nsw i32 %16, 1
  br i1 %20, label %22, label %15, !llvm.loop !21

22:                                               ; preds = %15, %18
  %23 = phi i32 [ %19, %18 ], [ 255, %15 ]
  ret i32 %23
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nobuiltin optsize "no-builtins" }
attributes #4 = { nounwind }

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
!14 = !{!5, !5, i64 0}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
