; ModuleID = 'dma/ksd.c'
source_filename = "dma/ksd.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@sd_spi = dso_local local_unnamed_addr global i32 0, align 4
@sd_sectors = internal unnamed_addr global i32 0, align 4
@sd_slow = internal unnamed_addr global i1 false, align 4
@sd_burst_state = internal unnamed_addr global i32 0, align 4
@sd_hc = internal unnamed_addr global i32 0, align 4
@sd_csreg = dso_local local_unnamed_addr global i32 0, align 4
@sd_cs_hi = dso_local local_unnamed_addr global i32 0, align 4
@sd_cs_lo = dso_local local_unnamed_addr global i32 0, align 4
@sd_rxctrl = dso_local local_unnamed_addr global i32 0, align 4
@sd_txch = dso_local local_unnamed_addr global i32 0, align 4
@sd_txctrl = dso_local local_unnamed_addr global i32 0, align 4
@sd_ff = internal global i32 -1, align 4
@.str = private unnamed_addr constant [16 x i8] c"sd: burst left=\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c" -> polled\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"0123456789abcdef\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"sd: cmd0=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c" v2=\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c" a41=\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c" hc=\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c" cap=\00", align 1
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
define dso_local range(i32 -1, 1) i32 @ksd_read_run(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %48, label %6

6:                                                ; preds = %3
  %7 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %48, label %9

9:                                                ; preds = %6
  %10 = load i1, ptr @sd_slow, align 4
  br i1 %10, label %48, label %11

11:                                               ; preds = %9
  %12 = load i32, ptr @sd_burst_state, align 4, !tbaa !3
  %13 = icmp eq i32 %12, 2
  br i1 %13, label %48, label %14

14:                                               ; preds = %11
  tail call fastcc void @cs(i32 noundef 1) #6
  %15 = load i32, ptr @sd_hc, align 4
  %16 = icmp eq i32 %15, 0
  %17 = shl i32 %0, 9
  %18 = select i1 %16, i32 %17, i32 %0
  br label %19

19:                                               ; preds = %22, %14
  %20 = phi i32 [ 0, %14 ], [ %25, %22 ]
  %21 = icmp eq i32 %20, 4
  br i1 %21, label %26, label %22

22:                                               ; preds = %19
  tail call fastcc void @sd_wait_ready() #6
  %23 = tail call fastcc i32 @sd_cmd(i32 noundef 18, i32 noundef %18, i32 noundef 1) #6
  %24 = icmp eq i32 %23, 0
  %25 = add nuw nsw i32 %20, 1
  br i1 %24, label %27, label %19, !llvm.loop !7

26:                                               ; preds = %19
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %48

27:                                               ; preds = %22, %41
  %28 = phi i32 [ %44, %41 ], [ 0, %22 ]
  %29 = icmp eq i32 %28, %2
  br i1 %29, label %45, label %30

30:                                               ; preds = %27
  %31 = tail call fastcc i32 @sd_token_wait() #6
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %33, label %38

33:                                               ; preds = %30
  %34 = shl i32 %28, 9
  %35 = add i32 %34, %1
  %36 = tail call fastcc i32 @sd_payload(i32 noundef %35) #6
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %41, label %38

38:                                               ; preds = %33, %30
  %39 = tail call fastcc i32 @sd_cmd(i32 noundef 12, i32 noundef 0, i32 noundef 1) #6
  tail call fastcc void @sd_wait_ready() #6
  tail call fastcc void @cs(i32 noundef 0) #6
  %40 = tail call fastcc i32 @xf(i32 noundef 255) #6
  br label %48

41:                                               ; preds = %33
  %42 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %43 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %44 = add i32 %28, 1
  br label %27, !llvm.loop !10

45:                                               ; preds = %27
  %46 = tail call fastcc i32 @sd_cmd(i32 noundef 12, i32 noundef 0, i32 noundef 1) #6
  tail call fastcc void @sd_wait_ready() #6
  tail call fastcc void @cs(i32 noundef 0) #6
  %47 = tail call fastcc i32 @xf(i32 noundef 255) #6
  store i32 1, ptr @sd_burst_state, align 4, !tbaa !3
  br label %48

48:                                               ; preds = %38, %26, %45, %3, %6, %9, %11
  %49 = phi i32 [ -1, %11 ], [ -1, %9 ], [ -1, %6 ], [ -1, %3 ], [ -1, %26 ], [ 0, %45 ], [ -1, %38 ]
  ret i32 %49
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
  br i1 %6, label %8, label %1, !llvm.loop !11

8:                                                ; preds = %4, %1
  ret void
}

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
  br label %9, !llvm.loop !12

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
  br i1 %32, label %34, label %27, !llvm.loop !13

34:                                               ; preds = %27, %30
  %35 = phi i32 [ %31, %30 ], [ 255, %27 ]
  ret i32 %35
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 -1, 1) i32 @sd_token_wait() unnamed_addr #2 {
  br label %1

1:                                                ; preds = %9, %0
  %2 = phi i32 [ 0, %0 ], [ %10, %9 ]
  %3 = icmp eq i32 %2, 2000000
  br i1 %3, label %11, label %4

4:                                                ; preds = %1
  %5 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %6 = trunc nuw i32 %5 to i8
  switch i8 %6, label %7 [
    i8 -2, label %11
    i8 -1, label %9
    i8 0, label %9
  ]

7:                                                ; preds = %4
  %8 = icmp samesign ult i32 %5, 16
  br i1 %8, label %11, label %9

9:                                                ; preds = %4, %4, %7
  %10 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !14

11:                                               ; preds = %7, %4, %1
  %12 = phi i32 [ -1, %1 ], [ 0, %4 ], [ -1, %7 ]
  ret i32 %12
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -9, 1) i32 @sd_payload(i32 noundef %0) unnamed_addr #1 {
  %2 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %3 = add i32 %2, 12
  %4 = inttoptr i32 %3 to ptr
  %5 = add i32 %2, 8
  %6 = inttoptr i32 %5 to ptr
  br label %7

7:                                                ; preds = %11, %1
  %8 = load volatile i32, ptr %4, align 4, !tbaa !3
  %9 = and i32 %8, 4
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %13, label %11

11:                                               ; preds = %7
  %12 = load volatile i32, ptr %6, align 4, !tbaa !3
  br label %7, !llvm.loop !15

13:                                               ; preds = %7
  %14 = add i32 %2, 36
  %15 = inttoptr i32 %14 to ptr
  store volatile i32 3, ptr %15, align 4, !tbaa !3
  %16 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %17 = add i32 %16, 8
  store volatile i32 %17, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !3
  store volatile i32 %0, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !3
  store volatile i32 512, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %18 = load i32, ptr @sd_rxctrl, align 4, !tbaa !3
  store volatile i32 %18, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !3
  %19 = load i32, ptr @sd_txch, align 4, !tbaa !3
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %22

21:                                               ; preds = %22, %13
  br label %50

22:                                               ; preds = %13
  %23 = add i32 %19, 16
  %24 = inttoptr i32 %23 to ptr
  %25 = load volatile i32, ptr %24, align 4, !tbaa !3
  %26 = and i32 %25, 67108864
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %21

28:                                               ; preds = %22
  %29 = inttoptr i32 %19 to ptr
  %30 = load volatile i32, ptr %29, align 4, !tbaa !3
  %31 = add i32 %19, 4
  %32 = inttoptr i32 %31 to ptr
  %33 = load volatile i32, ptr %32, align 4, !tbaa !3
  %34 = load volatile i32, ptr %24, align 4, !tbaa !3
  store volatile i32 ptrtoint (ptr @sd_ff to i32), ptr %29, align 4, !tbaa !3
  %35 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %36 = add i32 %35, 8
  store volatile i32 %36, ptr %32, align 4, !tbaa !3
  %37 = load i32, ptr @sd_txctrl, align 4, !tbaa !3
  store volatile i32 %37, ptr %24, align 4, !tbaa !3
  %38 = add i32 %19, 28
  %39 = inttoptr i32 %38 to ptr
  store volatile i32 512, ptr %39, align 4, !tbaa !3
  br label %40

40:                                               ; preds = %40, %28
  %41 = phi i32 [ 0, %28 ], [ %47, %40 ]
  %42 = load volatile i32, ptr %24, align 4, !tbaa !3
  %43 = and i32 %42, 67108864
  %44 = icmp ne i32 %43, 0
  %45 = icmp samesign ult i32 %41, 4000000
  %46 = select i1 %44, i1 %45, i1 false
  %47 = add nuw nsw i32 %41, 1
  br i1 %46, label %40, label %48, !llvm.loop !16

48:                                               ; preds = %40
  store volatile i32 %30, ptr %29, align 4, !tbaa !3
  store volatile i32 %33, ptr %32, align 4, !tbaa !3
  store volatile i32 %34, ptr %24, align 4, !tbaa !3
  br label %49

49:                                               ; preds = %50, %48
  br label %104

50:                                               ; preds = %21, %100
  %51 = phi i32 [ %102, %100 ], [ 0, %21 ]
  %52 = phi i32 [ %103, %100 ], [ 0, %21 ]
  %53 = icmp ult i32 %51, 512
  %54 = icmp samesign ult i32 %52, 4000000
  %55 = select i1 %53, i1 %54, i1 false
  br i1 %55, label %56, label %49

56:                                               ; preds = %50
  %57 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %58 = or disjoint i32 %51, -512
  %59 = add i32 %58, %57
  %60 = icmp eq i32 %59, 0
  %61 = icmp samesign ult i32 %51, 505
  %62 = and i1 %61, %60
  br i1 %62, label %63, label %88

63:                                               ; preds = %56
  %64 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %65 = add i32 %64, 8
  %66 = inttoptr i32 %65 to ptr
  store volatile i32 255, ptr %66, align 4, !tbaa !3
  %67 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %68 = add i32 %67, 8
  %69 = inttoptr i32 %68 to ptr
  store volatile i32 255, ptr %69, align 4, !tbaa !3
  %70 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %71 = add i32 %70, 8
  %72 = inttoptr i32 %71 to ptr
  store volatile i32 255, ptr %72, align 4, !tbaa !3
  %73 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %74 = add i32 %73, 8
  %75 = inttoptr i32 %74 to ptr
  store volatile i32 255, ptr %75, align 4, !tbaa !3
  %76 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %77 = add i32 %76, 8
  %78 = inttoptr i32 %77 to ptr
  store volatile i32 255, ptr %78, align 4, !tbaa !3
  %79 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %80 = add i32 %79, 8
  %81 = inttoptr i32 %80 to ptr
  store volatile i32 255, ptr %81, align 4, !tbaa !3
  %82 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %83 = add i32 %82, 8
  %84 = inttoptr i32 %83 to ptr
  store volatile i32 255, ptr %84, align 4, !tbaa !3
  %85 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %86 = add i32 %85, 8
  %87 = inttoptr i32 %86 to ptr
  store volatile i32 255, ptr %87, align 4, !tbaa !3
  br label %100

88:                                               ; preds = %56
  %89 = tail call i32 @llvm.usub.sat.i32(i32 8, i32 %59)
  %90 = sub nuw nsw i32 512, %51
  %91 = tail call i32 @llvm.umin.i32(i32 %89, i32 %90)
  br label %92

92:                                               ; preds = %95, %88
  %93 = phi i32 [ 0, %88 ], [ %99, %95 ]
  %94 = icmp eq i32 %93, %91
  br i1 %94, label %100, label %95

95:                                               ; preds = %92
  %96 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %97 = add i32 %96, 8
  %98 = inttoptr i32 %97 to ptr
  store volatile i32 255, ptr %98, align 4, !tbaa !3
  %99 = add nuw nsw i32 %93, 1
  br label %92, !llvm.loop !17

100:                                              ; preds = %92, %63
  %101 = phi i32 [ 8, %63 ], [ %91, %92 ]
  %102 = add nuw nsw i32 %51, %101
  %103 = add nuw nsw i32 %52, 1
  br label %50, !llvm.loop !18

104:                                              ; preds = %49, %104
  %105 = phi i32 [ %110, %104 ], [ 0, %49 ]
  %106 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %107 = icmp ne i32 %106, 0
  %108 = icmp samesign ult i32 %105, 4000000
  %109 = select i1 %107, i1 %108, i1 false
  %110 = add nuw nsw i32 %105, 1
  br i1 %109, label %104, label %111, !llvm.loop !19

111:                                              ; preds = %104
  %112 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %113 = add i32 %112, 36
  %114 = inttoptr i32 %113 to ptr
  store volatile i32 0, ptr %114, align 4, !tbaa !3
  %115 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  %116 = icmp eq i32 %115, 0
  br i1 %116, label %131, label %117

117:                                              ; preds = %111
  %118 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !3
  store volatile i32 2048, ptr inttoptr (i32 1342178404 to ptr), align 4, !tbaa !3
  br label %119

119:                                              ; preds = %119, %117
  %120 = phi i32 [ 0, %117 ], [ %126, %119 ]
  %121 = load volatile i32, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !3
  %122 = and i32 %121, 67108864
  %123 = icmp ne i32 %122, 0
  %124 = icmp samesign ult i32 %120, 100000
  %125 = select i1 %123, i1 %124, i1 false
  %126 = add nuw nsw i32 %120, 1
  br i1 %125, label %119, label %127, !llvm.loop !20

127:                                              ; preds = %119
  store volatile i32 0, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !3
  %128 = load i32, ptr @sd_burst_state, align 4, !tbaa !3
  %129 = icmp eq i32 %128, 2
  br i1 %129, label %131, label %130

130:                                              ; preds = %127
  store i32 2, ptr @sd_burst_state, align 4, !tbaa !3
  tail call void @klogts() #7
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str, i32 noundef %118) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 11) #7
  br label %131

131:                                              ; preds = %111, %127, %130
  %132 = phi i32 [ -9, %130 ], [ -9, %127 ], [ 0, %111 ]
  ret i32 %132
}

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
  br i1 %14, label %8, label %16, !llvm.loop !21

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

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @ksd_op(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = alloca [16 x i8], align 1
  %5 = load i32, ptr @sd_spi, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %210, label %7

7:                                                ; preds = %3
  switch i32 %0, label %210 [
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
  br label %16, !llvm.loop !22

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
  br label %23, !llvm.loop !23

32:                                               ; preds = %27, %23
  %33 = phi i32 [ %25, %23 ], [ 1, %27 ]
  tail call void @klogts() #7
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.3, i32 noundef %33) #6
  %34 = icmp eq i32 %33, 1
  br i1 %34, label %36, label %35

35:                                               ; preds = %32
  tail call fastcc void @cs(i32 noundef 0) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.4, i32 noundef 1) #7
  br label %210

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
  br label %39, !llvm.loop !24

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
  br i1 %62, label %65, label %56, !llvm.loop !25

64:                                               ; preds = %56
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.5, i32 noundef %53) #6
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.6, i32 noundef 0) #6
  tail call fastcc void @cs(i32 noundef 0) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.4, i32 noundef 1) #7
  br label %210

65:                                               ; preds = %59
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.5, i32 noundef %53) #6
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.6, i32 noundef 1) #6
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
  br label %69, !llvm.loop !26

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
  br i1 %95, label %97, label %90, !llvm.loop !27

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
  %104 = load i8, ptr %4, align 1, !tbaa !28
  %105 = and i8 %104, -64
  %106 = icmp eq i8 %105, 64
  br i1 %106, label %111, label %127

107:                                              ; preds = %98
  %108 = trunc nuw i32 %101 to i8
  %109 = getelementptr inbounds nuw [16 x i8], ptr %4, i32 0, i32 %99
  store i8 %108, ptr %109, align 1, !tbaa !28
  %110 = add nuw nsw i32 %99, 1
  br label %98, !llvm.loop !29

111:                                              ; preds = %102
  %112 = getelementptr inbounds nuw i8, ptr %4, i32 7
  %113 = load i8, ptr %112, align 1, !tbaa !28
  %114 = zext i8 %113 to i32
  %115 = shl nuw nsw i32 %114, 16
  %116 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %117 = load i8, ptr %116, align 1, !tbaa !28
  %118 = zext i8 %117 to i32
  %119 = shl nuw nsw i32 %118, 8
  %120 = or disjoint i32 %119, %115
  %121 = getelementptr inbounds nuw i8, ptr %4, i32 9
  %122 = load i8, ptr %121, align 1, !tbaa !28
  %123 = zext i8 %122 to i32
  %124 = or disjoint i32 %120, %123
  %125 = shl i32 %124, 10
  %126 = add i32 %125, 1024
  br label %161

127:                                              ; preds = %102
  %128 = getelementptr inbounds nuw i8, ptr %4, i32 6
  %129 = load i8, ptr %128, align 1, !tbaa !28
  %130 = and i8 %129, 3
  %131 = zext nneg i8 %130 to i32
  %132 = shl nuw nsw i32 %131, 10
  %133 = getelementptr inbounds nuw i8, ptr %4, i32 7
  %134 = load i8, ptr %133, align 1, !tbaa !28
  %135 = zext i8 %134 to i32
  %136 = shl nuw nsw i32 %135, 2
  %137 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %138 = load i8, ptr %137, align 1, !tbaa !28
  %139 = lshr i8 %138, 6
  %140 = zext nneg i8 %139 to i32
  %141 = getelementptr inbounds nuw i8, ptr %4, i32 9
  %142 = load i8, ptr %141, align 1, !tbaa !28
  %143 = shl i8 %142, 1
  %144 = and i8 %143, 6
  %145 = getelementptr inbounds nuw i8, ptr %4, i32 10
  %146 = load i8, ptr %145, align 1, !tbaa !28
  %147 = lshr i8 %146, 7
  %148 = getelementptr inbounds nuw i8, ptr %4, i32 5
  %149 = load i8, ptr %148, align 1, !tbaa !28
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
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.7, i32 noundef %172) #6
  %173 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.8, i32 noundef %173) #6
  tail call void @kconswrite(ptr noundef nonnull @.str.4, i32 noundef 1) #7
  %174 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %175 = icmp eq i32 %174, 0
  %176 = sext i1 %175 to i32
  %177 = inttoptr i32 %2 to ptr
  store volatile i32 %176, ptr %177, align 4, !tbaa !3
  %178 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %179 = add i32 %2, 4
  %180 = inttoptr i32 %179 to ptr
  store volatile i32 %178, ptr %180, align 4, !tbaa !3
  br label %210

181:                                              ; preds = %7
  %182 = load i32, ptr @sd_sectors, align 4, !tbaa !3
  %183 = icmp eq i32 %182, 0
  br i1 %183, label %206, label %184

184:                                              ; preds = %181
  %185 = load i32, ptr @sd_burst_state, align 4, !tbaa !3
  %186 = icmp eq i32 %185, 2
  br i1 %186, label %187, label %189

187:                                              ; preds = %184
  %188 = tail call fastcc i32 @sd_read_polled(i32 noundef %1, i32 noundef %2) #6
  br label %206

189:                                              ; preds = %184
  %190 = tail call fastcc i32 @sd_begin_read_any(i32 noundef %1) #6
  %191 = icmp eq i32 %190, 0
  br i1 %191, label %192, label %206

192:                                              ; preds = %189
  %193 = tail call fastcc i32 @sd_payload(i32 noundef %2) #6
  switch i32 %193, label %206 [
    i32 -9, label %194
    i32 0, label %203
  ]

194:                                              ; preds = %192
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %195

195:                                              ; preds = %200, %194
  %196 = phi i32 [ 0, %194 ], [ %202, %200 ]
  %197 = icmp eq i32 %196, 4
  br i1 %197, label %198, label %200

198:                                              ; preds = %195
  %199 = tail call fastcc i32 @sd_read_polled(i32 noundef %1, i32 noundef %2) #6
  br label %206

200:                                              ; preds = %195
  %201 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %202 = add nuw nsw i32 %196, 1
  br label %195, !llvm.loop !30

203:                                              ; preds = %192
  store i32 1, ptr @sd_burst_state, align 4, !tbaa !3
  %204 = tail call fastcc i32 @xf(i32 noundef 255) #6
  %205 = tail call fastcc i32 @xf(i32 noundef 255) #6
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %206

206:                                              ; preds = %181, %187, %189, %192, %198, %203
  %207 = phi i32 [ %188, %187 ], [ -1, %181 ], [ %199, %198 ], [ 0, %203 ], [ %190, %189 ], [ %193, %192 ]
  %208 = icmp ne i32 %207, 0
  %209 = sext i1 %208 to i32
  br label %210

210:                                              ; preds = %163, %64, %35, %7, %3, %206
  %211 = phi i32 [ %209, %206 ], [ -1, %3 ], [ -1, %7 ], [ 0, %35 ], [ 0, %64 ], [ 0, %163 ]
  ret i32 %211
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
  %7 = load i8, ptr %6, align 1, !tbaa !28
  %8 = icmp eq i8 %7, 0
  br i1 %8, label %13, label %9

9:                                                ; preds = %4
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %11 = add nuw nsw i32 %5, 1
  %12 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %5
  store i8 %7, ptr %12, align 1, !tbaa !28
  br label %4, !llvm.loop !31

13:                                               ; preds = %4
  %14 = lshr i32 %1, 28
  %15 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %14
  %16 = load i8, ptr %15, align 1, !tbaa !28
  %17 = add nuw nsw i32 %5, 1
  %18 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %5
  store i8 %16, ptr %18, align 1, !tbaa !28
  %19 = lshr i32 %1, 24
  %20 = and i32 %19, 15
  %21 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %20
  %22 = load i8, ptr %21, align 1, !tbaa !28
  %23 = add nuw nsw i32 %5, 2
  %24 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %17
  store i8 %22, ptr %24, align 1, !tbaa !28
  %25 = lshr i32 %1, 20
  %26 = and i32 %25, 15
  %27 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %26
  %28 = load i8, ptr %27, align 1, !tbaa !28
  %29 = add nuw nsw i32 %5, 3
  %30 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %23
  store i8 %28, ptr %30, align 1, !tbaa !28
  %31 = lshr i32 %1, 16
  %32 = and i32 %31, 15
  %33 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %32
  %34 = load i8, ptr %33, align 1, !tbaa !28
  %35 = add nuw nsw i32 %5, 4
  %36 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %29
  store i8 %34, ptr %36, align 1, !tbaa !28
  %37 = lshr i32 %1, 12
  %38 = and i32 %37, 15
  %39 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %38
  %40 = load i8, ptr %39, align 1, !tbaa !28
  %41 = add nuw nsw i32 %5, 5
  %42 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %35
  store i8 %40, ptr %42, align 1, !tbaa !28
  %43 = lshr i32 %1, 8
  %44 = and i32 %43, 15
  %45 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %44
  %46 = load i8, ptr %45, align 1, !tbaa !28
  %47 = add nuw nsw i32 %5, 6
  %48 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %41
  store i8 %46, ptr %48, align 1, !tbaa !28
  %49 = lshr i32 %1, 4
  %50 = and i32 %49, 15
  %51 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %50
  %52 = load i8, ptr %51, align 1, !tbaa !28
  %53 = add nuw nsw i32 %5, 7
  %54 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %47
  store i8 %52, ptr %54, align 1, !tbaa !28
  %55 = and i32 %1, 15
  %56 = getelementptr inbounds nuw i8, ptr @.str.2, i32 %55
  %57 = load i8, ptr %56, align 1, !tbaa !28
  %58 = add nuw nsw i32 %5, 8
  %59 = getelementptr inbounds nuw [16 x i8], ptr %3, i32 0, i32 %53
  store i8 %57, ptr %59, align 1, !tbaa !28
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
  store volatile i8 %12, ptr %14, align 1, !tbaa !28
  %15 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !32

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
  br i1 %12, label %15, label %6, !llvm.loop !33

14:                                               ; preds = %6
  tail call fastcc void @cs(i32 noundef 0) #6
  tail call fastcc void @sd_diag(ptr noundef nonnull @.str.11, i32 noundef %7) #6
  br label %19

15:                                               ; preds = %10
  %16 = tail call fastcc i32 @sd_token_wait() #6
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %19, label %18

18:                                               ; preds = %15
  tail call fastcc void @cs(i32 noundef 0) #6
  br label %19

19:                                               ; preds = %15, %18, %14
  %20 = phi i32 [ -2, %14 ], [ -3, %18 ], [ 0, %15 ]
  ret i32 %20
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
!15 = distinct !{!15, !8, !9}
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
!28 = !{!5, !5, i64 0}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
