; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@inj_wreg = dso_local local_unnamed_addr global i32 1342177476, align 4
@inj_treg = dso_local local_unnamed_addr global i32 1342177500, align 4
@kimages = dso_local global [20 x %struct.kimg] zeroinitializer, align 4
@ticks = dso_local global i32 0, align 4
@cons_r = internal unnamed_addr global i32 0, align 4
@cons_w = internal unnamed_addr global i32 0, align 4
@cons_buf = internal unnamed_addr global [128 x i8] zeroinitializer, align 1
@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@waspark = internal unnamed_addr global i32 0, align 4
@kw_curresume = dso_local global ptr null, align 4
@fsready = external dso_local local_unnamed_addr global i32, align 4
@selwait_to = internal global i32 0, align 4
@selwait_inf = internal global i32 0, align 4
@nextpid = dso_local local_unnamed_addr global i32 0, align 4
@execmem = internal unnamed_addr global [8 x [3 x i32]] zeroinitializer, align 4
@k_sysentry = dso_local local_unnamed_addr global i32 0, align 4
@arena_end = dso_local local_unnamed_addr global i32 0, align 4
@arena = dso_local local_unnamed_addr global i32 0, align 4
@kheap_init = internal unnamed_addr global i1 false, align 4
@kfreelist = internal global ptr null, align 4
@heapmem = internal unnamed_addr global [8 x i32] zeroinitializer, align 4
@cons_raw = internal unnamed_addr global i1 false, align 4
@cons_raw_pid = internal unnamed_addr global i32 0, align 4
@cons_e = internal unnamed_addr global i32 0, align 4
@kw_pcurdisp = dso_local global ptr null, align 4
@kw_curthunk = dso_local global ptr null, align 4
@kw_pcurresume = dso_local global ptr null, align 4
@kw_nextresume = dso_local global ptr null, align 4
@kw_park = dso_local global ptr null, align 4
@kw_parkvec = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@initpid = dso_local local_unnamed_addr global i32 0, align 4
@fgpid = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@tick_taken = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@.str = private unnamed_addr constant [27 x i8] c"fb: 640x480x8 on hstx-dvi\0A\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"fb: psram fail\0A\00", align 1
@parked = internal unnamed_addr global i1 false, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local ptr @kimg_name(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 0
  br i1 %2, label %10, label %3

3:                                                ; preds = %1
  %4 = icmp samesign ugt i32 %0, 19
  br i1 %4, label %10, label %5

5:                                                ; preds = %3
  %6 = getelementptr inbounds nuw [20 x %struct.kimg], ptr @kimages, i32 0, i32 %0
  %7 = load i8, ptr %6, align 4, !tbaa !3
  %8 = icmp eq i8 %7, 0
  %9 = select i1 %8, ptr null, ptr %6
  br label %10

10:                                               ; preds = %5, %1, %3
  %11 = phi ptr [ null, %3 ], [ null, %1 ], [ %9, %5 ]
  ret ptr %11
}

; Function Attrs: minsize nounwind optsize
define dso_local void @klogts() local_unnamed_addr #1 {
  %1 = alloca [20 x i8], align 1
  %2 = alloca [10 x i8], align 1
  %3 = load i32, ptr @ticks, align 4, !tbaa !6
  %4 = freeze i32 %3
  %5 = udiv i32 %4, 10000
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #11
  store i8 91, ptr %1, align 1, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %2) #11
  br label %6

6:                                                ; preds = %6, %0
  %7 = phi i32 [ %5, %0 ], [ %10, %6 ]
  %8 = phi i32 [ 0, %0 ], [ %15, %6 ]
  %9 = freeze i32 %7
  %10 = udiv i32 %9, 10
  %11 = mul i32 %10, 10
  %12 = sub i32 %9, %11
  %13 = trunc nuw nsw i32 %12 to i8
  %14 = or disjoint i8 %13, 48
  %15 = add nuw nsw i32 %8, 1
  %16 = getelementptr inbounds nuw [10 x i8], ptr %2, i32 0, i32 %8
  store i8 %14, ptr %16, align 1, !tbaa !3
  %17 = icmp samesign ugt i32 %7, 9
  %18 = icmp samesign ult i32 %8, 9
  %19 = select i1 %17, i1 %18, i1 false
  br i1 %19, label %6, label %20, !llvm.loop !8

20:                                               ; preds = %6, %26
  %21 = phi i32 [ %24, %26 ], [ 1, %6 ]
  %22 = phi i32 [ %27, %26 ], [ %15, %6 ]
  %23 = icmp eq i32 %22, 0
  %24 = add nuw nsw i32 %21, 1
  %25 = getelementptr inbounds nuw [20 x i8], ptr %1, i32 0, i32 %21
  br i1 %23, label %30, label %26

26:                                               ; preds = %20
  %27 = add nsw i32 %22, -1
  %28 = getelementptr inbounds [10 x i8], ptr %2, i32 0, i32 %27
  %29 = load i8, ptr %28, align 1, !tbaa !3
  store i8 %29, ptr %25, align 1, !tbaa !3
  br label %20, !llvm.loop !11

30:                                               ; preds = %20
  %31 = mul i32 %5, 10000
  %32 = sub i32 %4, %31
  %33 = trunc nuw nsw i32 %32 to i16
  %34 = udiv i16 %33, 10
  store i8 46, ptr %25, align 1, !tbaa !3
  %35 = udiv i16 %33, 1000
  %36 = trunc nuw nsw i16 %35 to i8
  %37 = add nuw nsw i8 %36, 48
  %38 = add nuw nsw i32 %21, 2
  %39 = getelementptr inbounds nuw [20 x i8], ptr %1, i32 0, i32 %24
  store i8 %37, ptr %39, align 1, !tbaa !3
  %40 = udiv i16 %33, 100
  %41 = trunc nuw nsw i16 %40 to i8
  %42 = urem i8 %41, 10
  %43 = or disjoint i8 %42, 48
  %44 = add nuw nsw i32 %21, 3
  %45 = getelementptr inbounds nuw [20 x i8], ptr %1, i32 0, i32 %38
  store i8 %43, ptr %45, align 1, !tbaa !3
  %46 = urem i16 %34, 10
  %47 = trunc nuw nsw i16 %46 to i8
  %48 = or disjoint i8 %47, 48
  %49 = add nuw nsw i32 %21, 4
  %50 = getelementptr inbounds nuw [20 x i8], ptr %1, i32 0, i32 %44
  store i8 %48, ptr %50, align 1, !tbaa !3
  %51 = add nuw nsw i32 %21, 5
  %52 = getelementptr inbounds nuw [20 x i8], ptr %1, i32 0, i32 %49
  store i8 93, ptr %52, align 1, !tbaa !3
  %53 = add nuw nsw i32 %21, 6
  %54 = getelementptr inbounds nuw [20 x i8], ptr %1, i32 0, i32 %51
  store i8 32, ptr %54, align 1, !tbaa !3
  call void @kconswrite(ptr noundef nonnull %1, i32 noundef %53) #12
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %2) #11
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #11
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define dso_local void @kconswrite(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #1 {
  br label %3

3:                                                ; preds = %7, %2
  %4 = phi i32 [ 0, %2 ], [ %11, %7 ]
  %5 = icmp slt i32 %4, %1
  br i1 %5, label %7, label %6

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %9 = load i8, ptr %8, align 1, !tbaa !3
  %10 = sext i8 %9 to i32
  tail call fastcc void @cputc(i32 noundef %10) #12
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !12
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc(i32 noundef range(i32 -128, -2147483648) %0) unnamed_addr #1 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  tail call fastcc void @cputc_wire(i32 noundef 13) #12
  br label %4

4:                                                ; preds = %3, %1
  %5 = and i32 %0, 255
  tail call fastcc void @cputc_wire(i32 noundef %5) #12
  tail call void @kfbcon_putc(i32 noundef %0) #13
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  tail call fastcc void @cons_poll() #12
  %3 = load i32, ptr @cons_r, align 4, !tbaa !6
  %4 = load i32, ptr @cons_w, align 4, !tbaa !6
  %5 = icmp eq i32 %3, %4
  br i1 %5, label %23, label %6

6:                                                ; preds = %2
  %7 = inttoptr i32 %0 to ptr
  br label %8

8:                                                ; preds = %15, %6
  %9 = phi i32 [ 0, %6 ], [ %20, %15 ]
  %10 = icmp slt i32 %9, %1
  %11 = load i32, ptr @cons_r, align 4
  %12 = load i32, ptr @cons_w, align 4
  %13 = icmp ne i32 %11, %12
  %14 = select i1 %10, i1 %13, i1 false
  br i1 %14, label %15, label %23

15:                                               ; preds = %8
  %16 = and i32 %11, 127
  %17 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3
  %19 = add i32 %11, 1
  store i32 %19, ptr @cons_r, align 4, !tbaa !6
  %20 = add nuw nsw i32 %9, 1
  %21 = getelementptr inbounds nuw i8, ptr %7, i32 %9
  store i8 %18, ptr %21, align 1, !tbaa !3
  %22 = icmp eq i8 %18, 10
  br i1 %22, label %23, label %8

23:                                               ; preds = %15, %8, %2
  %24 = phi i32 [ -2, %2 ], [ %9, %8 ], [ %20, %15 ]
  ret i32 %24
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cons_poll() unnamed_addr #1 {
  %1 = load i32, ptr @cons_w, align 4, !tbaa !6
  br label %2

2:                                                ; preds = %88, %0
  %3 = load i32, ptr @cons_e, align 4, !tbaa !6
  %4 = load i32, ptr @cons_r, align 4, !tbaa !6
  %5 = sub i32 %3, %4
  %6 = icmp ult i32 %5, 128
  br i1 %6, label %7, label %205

7:                                                ; preds = %2
  %8 = tail call i32 @kcons_rx() #13
  %9 = icmp eq i32 %8, -2
  br i1 %9, label %10, label %17

10:                                               ; preds = %7
  %11 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !6
  %12 = and i32 %11, 16
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %205

14:                                               ; preds = %10
  %15 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !6
  %16 = and i32 %15, 255
  br label %19

17:                                               ; preds = %7
  %18 = icmp slt i32 %8, 0
  br i1 %18, label %205, label %19

19:                                               ; preds = %14, %17
  %20 = phi i32 [ %16, %14 ], [ %8, %17 ]
  %21 = load i1, ptr @cons_raw, align 4
  br i1 %21, label %22, label %28

22:                                               ; preds = %19
  %23 = trunc i32 %20 to i8
  %24 = load i32, ptr @cons_e, align 4, !tbaa !6
  %25 = and i32 %24, 127
  %26 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %25
  store i8 %23, ptr %26, align 1, !tbaa !3
  %27 = add i32 %24, 1
  store i32 %27, ptr @cons_e, align 4, !tbaa !6
  store i32 %27, ptr @cons_w, align 4, !tbaa !6
  br label %88

28:                                               ; preds = %19
  %29 = icmp eq i32 %20, 3
  br i1 %29, label %30, label %171

30:                                               ; preds = %28
  %31 = load i32, ptr @fgpid, align 4, !tbaa !6
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %88, label %33

33:                                               ; preds = %30, %44
  %34 = phi i32 [ %45, %44 ], [ 0, %30 ]
  %35 = icmp eq i32 %34, 8
  br i1 %35, label %88, label %36, !llvm.loop !13

36:                                               ; preds = %33
  %37 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %34
  %38 = load i32, ptr %37, align 4, !tbaa !14
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %44, label %40

40:                                               ; preds = %36
  %41 = getelementptr inbounds nuw i8, ptr %37, i32 4
  %42 = load i32, ptr %41, align 4, !tbaa !16
  %43 = icmp eq i32 %42, %31
  br i1 %43, label %46, label %44

44:                                               ; preds = %40, %36
  %45 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !17

46:                                               ; preds = %40
  %47 = icmp eq i32 %38, 2
  br i1 %47, label %48, label %88

48:                                               ; preds = %46
  %49 = getelementptr inbounds nuw i8, ptr %37, i32 12
  %50 = load i32, ptr %49, align 4, !tbaa !18
  %51 = ptrtoint ptr %37 to i32
  %52 = icmp eq i32 %50, %51
  br i1 %52, label %53, label %74

53:                                               ; preds = %48, %70
  %54 = phi ptr [ %71, %70 ], [ null, %48 ]
  %55 = phi i32 [ %72, %70 ], [ 0, %48 ]
  %56 = phi i32 [ %73, %70 ], [ 0, %48 ]
  %57 = icmp eq i32 %56, 8
  br i1 %57, label %86, label %58

58:                                               ; preds = %53
  %59 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %56
  %60 = load i32, ptr %59, align 4, !tbaa !14
  switch i32 %60, label %61 [
    i32 0, label %70
    i32 5, label %70
  ]

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %59, i32 8
  %63 = load i32, ptr %62, align 4, !tbaa !19
  %64 = icmp eq i32 %63, %31
  br i1 %64, label %65, label %70

65:                                               ; preds = %61
  %66 = getelementptr inbounds nuw i8, ptr %59, i32 4
  %67 = load i32, ptr %66, align 4, !tbaa !16
  %68 = icmp ugt i32 %67, %55
  br i1 %68, label %69, label %70

69:                                               ; preds = %65
  br label %70

70:                                               ; preds = %69, %65, %61, %58, %58
  %71 = phi ptr [ %59, %69 ], [ %54, %65 ], [ %54, %61 ], [ %54, %58 ], [ %54, %58 ]
  %72 = phi i32 [ %67, %69 ], [ %55, %65 ], [ %55, %61 ], [ %55, %58 ], [ %55, %58 ]
  %73 = add nuw nsw i32 %56, 1
  br label %53, !llvm.loop !20

74:                                               ; preds = %48, %84
  %75 = phi i32 [ %85, %84 ], [ 0, %48 ]
  %76 = icmp eq i32 %75, 8
  br i1 %76, label %88, label %77, !llvm.loop !13

77:                                               ; preds = %74
  %78 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %75
  %79 = ptrtoint ptr %78 to i32
  %80 = icmp eq i32 %50, %79
  br i1 %80, label %81, label %84

81:                                               ; preds = %77
  %82 = load i32, ptr %78, align 4, !tbaa !14
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %84, label %89

84:                                               ; preds = %81, %77
  %85 = add nuw nsw i32 %75, 1
  br label %74, !llvm.loop !21

86:                                               ; preds = %53
  %87 = icmp eq ptr %54, null
  br i1 %87, label %88, label %89

88:                                               ; preds = %33, %74, %132, %86, %46, %30, %22, %178, %174, %200, %204, %180
  br label %2, !llvm.loop !13

89:                                               ; preds = %81, %86
  %90 = phi ptr [ %54, %86 ], [ %78, %81 ]
  tail call fastcc void @cputc(i32 noundef 94) #12
  tail call fastcc void @cputc(i32 noundef 67) #12
  tail call fastcc void @cputc(i32 noundef 10) #12
  br label %91

91:                                               ; preds = %129, %89
  %92 = phi i32 [ 0, %89 ], [ %130, %129 ]
  %93 = phi i32 [ 0, %89 ], [ %131, %129 ]
  %94 = icmp eq i32 %93, 8
  br i1 %94, label %132, label %95

95:                                               ; preds = %91
  %96 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %93
  %97 = load i32, ptr %96, align 4, !tbaa !14
  switch i32 %97, label %98 [
    i32 0, label %129
    i32 5, label %129
  ]

98:                                               ; preds = %95, %123
  %99 = phi ptr [ %124, %123 ], [ %96, %95 ]
  %100 = phi i32 [ %125, %123 ], [ 0, %95 ]
  %101 = icmp eq ptr %99, null
  %102 = icmp samesign ugt i32 %100, 7
  %103 = select i1 %101, i1 true, i1 %102
  br i1 %103, label %129, label %104

104:                                              ; preds = %98
  %105 = icmp eq ptr %99, %90
  br i1 %105, label %126, label %106

106:                                              ; preds = %104
  %107 = getelementptr inbounds nuw i8, ptr %99, i32 8
  %108 = load i32, ptr %107, align 4, !tbaa !19
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %129, label %110

110:                                              ; preds = %106, %121
  %111 = phi i32 [ %122, %121 ], [ 0, %106 ]
  %112 = icmp eq i32 %111, 8
  br i1 %112, label %123, label %113

113:                                              ; preds = %110
  %114 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %111
  %115 = load i32, ptr %114, align 4, !tbaa !14
  %116 = icmp eq i32 %115, 0
  br i1 %116, label %121, label %117

117:                                              ; preds = %113
  %118 = getelementptr inbounds nuw i8, ptr %114, i32 4
  %119 = load i32, ptr %118, align 4, !tbaa !16
  %120 = icmp eq i32 %119, %108
  br i1 %120, label %123, label %121

121:                                              ; preds = %117, %113
  %122 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !22

123:                                              ; preds = %117, %110
  %124 = phi ptr [ null, %110 ], [ %114, %117 ]
  %125 = add nuw nsw i32 %100, 1
  br label %98, !llvm.loop !23

126:                                              ; preds = %104
  %127 = shl nuw nsw i32 1, %93
  %128 = or i32 %127, %92
  br label %129

129:                                              ; preds = %106, %98, %126, %95, %95
  %130 = phi i32 [ %128, %126 ], [ %92, %95 ], [ %92, %95 ], [ %92, %98 ], [ %92, %106 ]
  %131 = add nuw nsw i32 %93, 1
  br label %91, !llvm.loop !24

132:                                              ; preds = %91, %169
  %133 = phi i32 [ %170, %169 ], [ 0, %91 ]
  %134 = icmp eq i32 %133, 8
  br i1 %134, label %88, label %135, !llvm.loop !13

135:                                              ; preds = %132
  %136 = shl nuw nsw i32 1, %133
  %137 = and i32 %136, %92
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %169, label %139

139:                                              ; preds = %135
  %140 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %133
  %141 = getelementptr inbounds nuw i8, ptr %140, i32 64
  %142 = load i32, ptr %141, align 4, !tbaa !25
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %163, label %144

144:                                              ; preds = %139
  %145 = getelementptr inbounds nuw i8, ptr %140, i32 68
  %146 = load i32, ptr %145, align 4, !tbaa !26
  %147 = icmp eq i32 %146, 0
  br i1 %147, label %148, label %169

148:                                              ; preds = %144
  %149 = load i32, ptr %140, align 4, !tbaa !14
  %150 = icmp eq i32 %149, 2
  br i1 %150, label %151, label %162

151:                                              ; preds = %148
  %152 = getelementptr inbounds nuw i8, ptr %140, i32 44
  %153 = load i32, ptr %152, align 4, !tbaa !27
  %154 = inttoptr i32 %153 to ptr
  %155 = getelementptr inbounds nuw i8, ptr %154, i32 16
  store volatile i32 -1, ptr %155, align 4, !tbaa !28
  %156 = getelementptr inbounds nuw i8, ptr %154, i32 20
  store volatile i32 1, ptr %156, align 4, !tbaa !30
  %157 = getelementptr inbounds nuw i8, ptr %140, i32 24
  %158 = load i32, ptr %157, align 4, !tbaa !31
  %159 = add i32 %158, -84
  %160 = inttoptr i32 %159 to ptr
  store volatile i32 -1, ptr %160, align 4, !tbaa !6
  %161 = getelementptr inbounds nuw i8, ptr %140, i32 12
  store i32 0, ptr %161, align 4, !tbaa !18
  store i32 3, ptr %140, align 4, !tbaa !14
  br label %162

162:                                              ; preds = %151, %148
  store i32 1, ptr %145, align 4, !tbaa !26
  br label %169

163:                                              ; preds = %139
  %164 = load i32, ptr %140, align 4, !tbaa !14
  %165 = icmp eq i32 %164, 2
  br i1 %165, label %166, label %167

166:                                              ; preds = %163
  tail call fastcc void @terminate(ptr noundef nonnull %140, i32 noundef -1) #12
  br label %169

167:                                              ; preds = %163
  %168 = getelementptr inbounds nuw i8, ptr %140, i32 48
  store i32 1, ptr %168, align 4, !tbaa !32
  br label %169

169:                                              ; preds = %167, %166, %162, %144, %135
  %170 = add nuw nsw i32 %133, 1
  br label %132, !llvm.loop !33

171:                                              ; preds = %28
  %172 = icmp eq i32 %20, 13
  %173 = select i1 %172, i32 10, i32 %20
  switch i32 %20, label %180 [
    i32 8, label %174
    i32 127, label %174
  ]

174:                                              ; preds = %171, %171
  %175 = load i32, ptr @cons_e, align 4, !tbaa !6
  %176 = load i32, ptr @cons_w, align 4, !tbaa !6
  %177 = icmp eq i32 %175, %176
  br i1 %177, label %88, label %178

178:                                              ; preds = %174
  %179 = add i32 %175, -1
  store i32 %179, ptr @cons_e, align 4, !tbaa !6
  tail call fastcc void @cputc(i32 noundef 8) #12
  tail call fastcc void @cputc(i32 noundef 32) #12
  tail call fastcc void @cputc(i32 noundef 8) #12
  br label %88

180:                                              ; preds = %171
  %181 = load i32, ptr @cons_e, align 4, !tbaa !6
  %182 = load i32, ptr @cons_r, align 4, !tbaa !6
  %183 = sub i32 %181, %182
  %184 = icmp ult i32 %183, 128
  br i1 %184, label %185, label %88

185:                                              ; preds = %180
  %186 = trunc i32 %173 to i8
  %187 = and i32 %181, 127
  %188 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %187
  store i8 %186, ptr %188, align 1, !tbaa !3
  %189 = add i32 %181, 1
  store i32 %189, ptr @cons_e, align 4, !tbaa !6
  %190 = icmp samesign ult i32 %173, 32
  %191 = add nsw i32 %173, -11
  %192 = icmp ult i32 %191, -2
  %193 = and i1 %190, %192
  br i1 %193, label %194, label %196

194:                                              ; preds = %185
  tail call fastcc void @cputc(i32 noundef 94) #12
  %195 = or disjoint i32 %173, 64
  br label %196

196:                                              ; preds = %185, %194
  %197 = phi i32 [ %195, %194 ], [ %173, %185 ]
  tail call fastcc void @cputc(i32 noundef %197) #12
  %198 = icmp eq i32 %173, 10
  %199 = load i32, ptr @cons_e, align 4, !tbaa !6
  br i1 %198, label %204, label %200

200:                                              ; preds = %196
  %201 = load i32, ptr @cons_r, align 4, !tbaa !6
  %202 = sub i32 %199, %201
  %203 = icmp eq i32 %202, 128
  br i1 %203, label %204, label %88

204:                                              ; preds = %200, %196
  store i32 %199, ptr @cons_w, align 4, !tbaa !6
  br label %88

205:                                              ; preds = %10, %17, %2
  %206 = load i32, ptr @cons_w, align 4, !tbaa !6
  %207 = icmp eq i32 %206, %1
  br i1 %207, label %235, label %208

208:                                              ; preds = %205, %233
  %209 = phi i32 [ %234, %233 ], [ 0, %205 ]
  %210 = icmp eq i32 %209, 8
  br i1 %210, label %235, label %211

211:                                              ; preds = %208
  %212 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %209
  %213 = load i32, ptr %212, align 4, !tbaa !14
  %214 = icmp eq i32 %213, 2
  br i1 %214, label %215, label %233

215:                                              ; preds = %211
  %216 = getelementptr inbounds nuw i8, ptr %212, i32 12
  %217 = load i32, ptr %216, align 4, !tbaa !18
  %218 = icmp eq i32 %217, ptrtoint (ptr @selwait_inf to i32)
  br i1 %218, label %221, label %219

219:                                              ; preds = %215
  %220 = icmp eq i32 %217, ptrtoint (ptr @selwait_to to i32)
  br i1 %220, label %221, label %233

221:                                              ; preds = %219, %215
  %222 = getelementptr inbounds nuw i8, ptr %212, i32 44
  %223 = load i32, ptr %222, align 4, !tbaa !27
  %224 = inttoptr i32 %223 to ptr
  %225 = getelementptr inbounds nuw i8, ptr %224, i32 4
  %226 = load volatile i32, ptr %225, align 4, !tbaa !34
  %227 = getelementptr inbounds nuw i8, ptr %224, i32 16
  store volatile i32 %226, ptr %227, align 4, !tbaa !28
  %228 = getelementptr inbounds nuw i8, ptr %224, i32 20
  store volatile i32 1, ptr %228, align 4, !tbaa !30
  %229 = getelementptr inbounds nuw i8, ptr %212, i32 24
  %230 = load i32, ptr %229, align 4, !tbaa !31
  %231 = add i32 %230, -84
  %232 = inttoptr i32 %231 to ptr
  store volatile i32 %226, ptr %232, align 4, !tbaa !6
  store i32 0, ptr %216, align 4, !tbaa !18
  store i32 3, ptr %212, align 4, !tbaa !14
  br label %233

233:                                              ; preds = %221, %219, %211
  %234 = add nuw nsw i32 %209, 1
  br label %208, !llvm.loop !35

235:                                              ; preds = %208, %205
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @kcons_ready() local_unnamed_addr #0 {
  %1 = load i32, ptr @cons_r, align 4, !tbaa !6
  %2 = load i32, ptr @cons_w, align 4, !tbaa !6
  %3 = icmp ne i32 %1, %2
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 9, 8) i32 @kfind_sleeper(i32 noundef %0) local_unnamed_addr #3 {
  br label %2

2:                                                ; preds = %13, %1
  %3 = phi i32 [ 0, %1 ], [ %14, %13 ]
  %4 = icmp eq i32 %3, 8
  br i1 %4, label %15, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %3
  %7 = load i32, ptr %6, align 4, !tbaa !14
  %8 = icmp eq i32 %7, 2
  br i1 %8, label %9, label %13

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 12
  %11 = load i32, ptr %10, align 4, !tbaa !18
  %12 = icmp eq i32 %11, %0
  br i1 %12, label %15, label %13

13:                                               ; preds = %5, %9
  %14 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !36

15:                                               ; preds = %9, %2
  %16 = phi i32 [ -1, %2 ], [ %3, %9 ]
  ret i32 %16
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #4 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %4 = load i32, ptr %3, align 4, !tbaa !27
  %5 = add i32 %1, -1
  %6 = icmp ult i32 %5, 4
  %7 = shl nsw i32 %5, 2
  %8 = add nsw i32 %7, 4
  %9 = select i1 %6, i32 %8, i32 20
  %10 = inttoptr i32 %4 to ptr
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 %9
  %12 = load volatile i32, ptr %11, align 4, !tbaa !6
  ret i32 %12
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kmail_set(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #5 {
  %4 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %5 = load i32, ptr %4, align 4, !tbaa !27
  %6 = inttoptr i32 %5 to ptr
  switch i32 %1, label %12 [
    i32 2, label %9
    i32 3, label %7
    i32 5, label %8
  ]

7:                                                ; preds = %3
  br label %9

8:                                                ; preds = %3
  br label %9

9:                                                ; preds = %3, %7, %8
  %10 = phi i32 [ 20, %8 ], [ 12, %7 ], [ 8, %3 ]
  %11 = getelementptr inbounds nuw i8, ptr %6, i32 %10
  store volatile i32 %2, ptr %11, align 4, !tbaa !6
  br label %12

12:                                               ; preds = %9, %3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kcomplete(i32 noundef %0, i32 noundef %1) local_unnamed_addr #5 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 44
  %5 = load i32, ptr %4, align 4, !tbaa !27
  %6 = inttoptr i32 %5 to ptr
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 16
  store volatile i32 %1, ptr %7, align 4, !tbaa !28
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store volatile i32 1, ptr %8, align 4, !tbaa !30
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 24
  %10 = load i32, ptr %9, align 4, !tbaa !31
  %11 = add i32 %10, -84
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 %1, ptr %12, align 4, !tbaa !6
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 0, ptr %13, align 4, !tbaa !18
  store i32 3, ptr %3, align 4, !tbaa !14
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kblock_self_slot() local_unnamed_addr #0 {
  %1 = load i32, ptr @curr, align 4, !tbaa !6
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #4 {
  %2 = load i32, ptr @curr, align 4, !tbaa !6
  %3 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %2
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 32
  %5 = load i32, ptr %4, align 4, !tbaa !37
  %6 = inttoptr i32 %5 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !6
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 40
  store i32 %7, ptr %8, align 4, !tbaa !38
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 %0, ptr %9, align 4, !tbaa !18
  store i32 2, ptr %3, align 4, !tbaa !14
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #1 {
  tail call fastcc void @kenter() #12
  tail call fastcc void @fire_income() #12
  %1 = load i32, ptr @waspark, align 4, !tbaa !6
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %17

3:                                                ; preds = %0
  %4 = load i32, ptr @curr, align 4, !tbaa !6
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !32
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %16

9:                                                ; preds = %3
  %10 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !39
  %11 = load i32, ptr %10, align 4, !tbaa !6
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %11, ptr %12, align 4, !tbaa !38
  %13 = load i32, ptr %5, align 4, !tbaa !14
  %14 = icmp eq i32 %13, 4
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  store i32 3, ptr %5, align 4, !tbaa !14
  br label %17

16:                                               ; preds = %3
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #12
  br label %17

17:                                               ; preds = %0, %9, %15, %16
  tail call fastcc void @swtch() #12
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kenter() unnamed_addr #1 {
  store i1 false, ptr @rearm, align 4
  store i1 false, ptr @tick_taken, align 4
  tail call void @kcons_aim(i32 noundef 0) #13
  %1 = load i32, ptr @fsready, align 4, !tbaa !6
  %2 = icmp eq i32 %1, 0
  %3 = load i32, ptr @dma_disk, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %2, i1 %4, i1 false
  br i1 %5, label %6, label %14

6:                                                ; preds = %0
  %7 = tail call i32 @kfb_init() #13
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %6
  tail call void @kfbcon_reset() #13
  tail call void @klogts() #12
  tail call void @kconswrite(ptr noundef nonnull @.str, i32 noundef 26) #12
  br label %13

10:                                               ; preds = %6
  %11 = icmp slt i32 %7, 0
  br i1 %11, label %12, label %13

12:                                               ; preds = %10
  tail call void @klogts() #12
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 15) #12
  br label %13

13:                                               ; preds = %10, %12, %9
  tail call void @kfs_start() #13
  tail call void @kflash_init() #13
  br label %14

14:                                               ; preds = %13, %0
  %15 = load i1, ptr @parked, align 4
  %16 = zext i1 %15 to i32
  store i32 %16, ptr @waspark, align 4, !tbaa !6
  br i1 %15, label %17, label %18

17:                                               ; preds = %14
  store i1 false, ptr @parked, align 4
  store i32 0, ptr @entry_disp, align 4, !tbaa !6
  br label %29

18:                                               ; preds = %14
  %19 = load i32, ptr @curr, align 4, !tbaa !6
  %20 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %19
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !31
  store i32 %22, ptr @entry_disp, align 4, !tbaa !6
  %23 = getelementptr inbounds nuw i8, ptr %20, i32 36
  %24 = load i32, ptr %23, align 4, !tbaa !42
  store i32 %24, ptr @entry_thunk, align 4, !tbaa !6
  %25 = inttoptr i32 %22 to ptr
  %26 = load volatile i32, ptr %25, align 4, !tbaa !6
  %27 = icmp eq i32 %26, %24
  br i1 %27, label %29, label %28

28:                                               ; preds = %18
  store volatile i32 %24, ptr %25, align 4, !tbaa !6
  tail call fastcc void @fire_income() #12
  br label %29

29:                                               ; preds = %18, %28, %17
  %30 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %31 = inttoptr i32 %30 to ptr
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr %31, align 4, !tbaa !6
  %32 = load i32, ptr @tickpending, align 4, !tbaa !6
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %35, label %34

34:                                               ; preds = %29
  store i32 0, ptr @tickpending, align 4, !tbaa !6
  tail call fastcc void @fire_income() #12
  br label %35

35:                                               ; preds = %34, %29
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fire_income() unnamed_addr #1 {
  %1 = tail call i32 @kcons_on() #13
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call fastcc void @tick_income() #12
  br label %17

4:                                                ; preds = %0
  %5 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %6 = add i32 %5, 4
  %7 = inttoptr i32 %6 to ptr
  %8 = load volatile i32, ptr %7, align 4, !tbaa !6
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %13

10:                                               ; preds = %4
  %11 = load i1, ptr @tick_taken, align 4
  br i1 %11, label %13, label %12

12:                                               ; preds = %10
  store i1 true, ptr @tick_taken, align 4
  tail call fastcc void @tick_income() #12
  br label %13

13:                                               ; preds = %12, %10, %4
  %14 = load i32, ptr @fgpid, align 4, !tbaa !6
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %17, label %16

16:                                               ; preds = %13
  tail call fastcc void @cons_poll() #12
  br label %17

17:                                               ; preds = %3, %16, %13
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @terminate(ptr noundef %0, i32 noundef %1) unnamed_addr #1 {
  %3 = ptrtoint ptr %0 to i32
  %4 = sub i32 %3, ptrtoint (ptr @proc to i32)
  %5 = sdiv exact i32 %4, 72
  %6 = load i1, ptr @cons_raw, align 4
  br i1 %6, label %7, label %13

7:                                                ; preds = %2
  %8 = load i32, ptr @cons_raw_pid, align 4, !tbaa !6
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %10 = load i32, ptr %9, align 4, !tbaa !16
  %11 = icmp eq i32 %8, %10
  br i1 %11, label %12, label %13

12:                                               ; preds = %7
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !6
  br label %13

13:                                               ; preds = %12, %7, %2
  %14 = tail call i32 @kfb_owner() #13
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !16
  %17 = icmp eq i32 %14, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %13
  tail call void @kfb_setowner(i32 noundef 0) #13
  tail call void @kfbcon_reset() #13
  br label %19

19:                                               ; preds = %18, %13
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %20, align 4, !tbaa !43
  %21 = load i32, ptr @fsready, align 4, !tbaa !6
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %24, label %23

23:                                               ; preds = %19
  tail call void @kfs_exit(i32 noundef %5) #13
  br label %24

24:                                               ; preds = %23, %19
  tail call fastcc void @kfree_exec(i32 noundef %5) #12
  tail call fastcc void @vfork_release(ptr noundef nonnull %0) #12
  %25 = load i32, ptr @initpid, align 4, !tbaa !6
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %46, label %27

27:                                               ; preds = %24, %44
  %28 = phi i32 [ %45, %44 ], [ 0, %24 ]
  %29 = icmp eq i32 %28, 8
  br i1 %29, label %46, label %30

30:                                               ; preds = %27
  %31 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %28
  %32 = load i32, ptr %31, align 4, !tbaa !14
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %44, label %34

34:                                               ; preds = %30
  %35 = icmp eq ptr %31, %0
  br i1 %35, label %44, label %36

36:                                               ; preds = %34
  %37 = getelementptr inbounds nuw i8, ptr %31, i32 8
  %38 = load i32, ptr %37, align 4, !tbaa !19
  %39 = load i32, ptr %15, align 4, !tbaa !16
  %40 = icmp eq i32 %38, %39
  br i1 %40, label %41, label %44

41:                                               ; preds = %36
  store i32 %25, ptr %37, align 4, !tbaa !19
  %42 = icmp eq i32 %32, 5
  br i1 %42, label %43, label %44

43:                                               ; preds = %41
  store i32 0, ptr %31, align 4, !tbaa !14
  br label %44

44:                                               ; preds = %41, %43, %36, %34, %30
  %45 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !44

46:                                               ; preds = %27, %24
  %47 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %48 = load i32, ptr %47, align 4, !tbaa !19
  br label %49

49:                                               ; preds = %79, %46
  %50 = phi i32 [ 0, %46 ], [ %80, %79 ]
  %51 = icmp eq i32 %50, 8
  br i1 %51, label %90, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %50
  %54 = getelementptr inbounds nuw i8, ptr %53, i32 4
  %55 = load i32, ptr %54, align 4, !tbaa !16
  %56 = icmp eq i32 %55, %48
  br i1 %56, label %57, label %79

57:                                               ; preds = %52
  %58 = load i32, ptr %53, align 4, !tbaa !14
  %59 = icmp eq i32 %58, 2
  br i1 %59, label %60, label %79

60:                                               ; preds = %57
  %61 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %62 = load i32, ptr %61, align 4, !tbaa !18
  %63 = ptrtoint ptr %53 to i32
  %64 = icmp eq i32 %62, %63
  br i1 %64, label %65, label %79

65:                                               ; preds = %60
  %66 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %67 = getelementptr inbounds nuw i8, ptr %53, i32 44
  %68 = load i32, ptr %67, align 4, !tbaa !27
  %69 = inttoptr i32 %68 to ptr
  %70 = getelementptr inbounds nuw i8, ptr %69, i32 4
  %71 = load volatile i32, ptr %70, align 4, !tbaa !34
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %81, label %73

73:                                               ; preds = %65
  %74 = load i32, ptr %20, align 4, !tbaa !43
  %75 = load volatile i32, ptr %70, align 4, !tbaa !34
  %76 = inttoptr i32 %75 to ptr
  store volatile i32 %74, ptr %76, align 4, !tbaa !6
  %77 = load i32, ptr %67, align 4, !tbaa !27
  %78 = inttoptr i32 %77 to ptr
  br label %81

79:                                               ; preds = %60, %57, %52
  %80 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !45

81:                                               ; preds = %73, %65
  %82 = phi ptr [ %78, %73 ], [ %69, %65 ]
  %83 = load i32, ptr %15, align 4, !tbaa !16
  %84 = getelementptr inbounds nuw i8, ptr %82, i32 16
  store volatile i32 %83, ptr %84, align 4, !tbaa !28
  %85 = getelementptr inbounds nuw i8, ptr %82, i32 20
  store volatile i32 1, ptr %85, align 4, !tbaa !30
  %86 = getelementptr inbounds nuw i8, ptr %53, i32 24
  %87 = load i32, ptr %86, align 4, !tbaa !31
  %88 = add i32 %87, -84
  %89 = inttoptr i32 %88 to ptr
  store volatile i32 %83, ptr %89, align 4, !tbaa !6
  store i32 0, ptr %66, align 4, !tbaa !18
  store i32 3, ptr %53, align 4, !tbaa !14
  br label %94

90:                                               ; preds = %49
  br i1 %26, label %93, label %91

91:                                               ; preds = %90
  %92 = icmp eq i32 %48, %25
  br i1 %92, label %94, label %93

93:                                               ; preds = %91, %90
  br label %94

94:                                               ; preds = %81, %91, %93
  %95 = phi i32 [ 5, %93 ], [ 0, %91 ], [ 0, %81 ]
  store i32 %95, ptr %0, align 4, !tbaa !14
  %96 = getelementptr inbounds nuw i8, ptr %0, i32 48
  store i32 0, ptr %96, align 4, !tbaa !32
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @swtch() unnamed_addr #1 {
  %1 = load i32, ptr @curr, align 4
  br label %2

2:                                                ; preds = %5, %0
  %3 = phi i32 [ 1, %0 ], [ %11, %5 ]
  %4 = icmp eq i32 %3, 9
  br i1 %4, label %12, label %5

5:                                                ; preds = %2
  %6 = add i32 %3, %1
  %7 = and i32 %6, 7
  %8 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7
  %9 = load i32, ptr %8, align 4, !tbaa !14
  %10 = icmp eq i32 %9, 3
  %11 = add nuw nsw i32 %3, 1
  br i1 %10, label %59, label %2, !llvm.loop !46

12:                                               ; preds = %2
  %13 = load i32, ptr @entry_disp, align 4, !tbaa !6
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %12
  %16 = inttoptr i32 %13 to ptr
  %17 = load volatile i32, ptr %16, align 4, !tbaa !6
  %18 = load i32, ptr @entry_thunk, align 4, !tbaa !6
  %19 = icmp eq i32 %17, %18
  br i1 %19, label %21, label %20

20:                                               ; preds = %15
  store volatile i32 %18, ptr %16, align 4, !tbaa !6
  tail call fastcc void @fire_income() #12
  br label %21

21:                                               ; preds = %20, %15, %12
  %22 = load volatile ptr, ptr @kw_park, align 4, !tbaa !39
  %23 = ptrtoint ptr %22 to i32
  %24 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !39
  store i32 %23, ptr %24, align 4, !tbaa !6
  %25 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !39
  %26 = ptrtoint ptr %25 to i32
  %27 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !39
  store i32 %26, ptr %27, align 4, !tbaa !6
  %28 = load volatile ptr, ptr @kw_park, align 4, !tbaa !39
  %29 = ptrtoint ptr %28 to i32
  %30 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !39
  store i32 %29, ptr %30, align 4, !tbaa !6
  %31 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !39
  %32 = ptrtoint ptr %31 to i32
  %33 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !39
  store i32 %32, ptr %33, align 4, !tbaa !6
  %34 = load volatile ptr, ptr @kw_park, align 4, !tbaa !39
  %35 = ptrtoint ptr %34 to i32
  %36 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !39
  store i32 %35, ptr %36, align 4, !tbaa !6
  %37 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !39
  %38 = ptrtoint ptr %37 to i32
  %39 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %40 = inttoptr i32 %39 to ptr
  store volatile i32 %38, ptr %40, align 4, !tbaa !6
  store i1 true, ptr @parked, align 4
  %41 = load i32, ptr @tickpending, align 4, !tbaa !6
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %44, label %43

43:                                               ; preds = %21
  store i32 0, ptr @tickpending, align 4, !tbaa !6
  tail call fastcc void @fire_income() #12
  br label %44

44:                                               ; preds = %43, %21
  %45 = tail call i32 @kcons_on() #13
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %54, label %47

47:                                               ; preds = %44
  %48 = load i32, ptr @fgpid, align 4, !tbaa !6
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %51, label %50

50:                                               ; preds = %47
  tail call fastcc void @cons_poll() #12
  br label %51

51:                                               ; preds = %50, %47
  tail call void @kcons_kick() #13
  %52 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !39
  %53 = ptrtoint ptr %52 to i32
  tail call void @kcons_aim(i32 noundef %53) #13
  br label %54

54:                                               ; preds = %51, %44
  %55 = load i1, ptr @rearm, align 4
  br i1 %55, label %56, label %62

56:                                               ; preds = %54
  %57 = load i32, ptr @inj_treg, align 4, !tbaa !6
  %58 = inttoptr i32 %57 to ptr
  store volatile i32 1, ptr %58, align 4, !tbaa !6
  br label %62

59:                                               ; preds = %5
  %60 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %61 = load i32, ptr %60, align 4, !tbaa !38
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %61) #12
  br label %62

62:                                               ; preds = %54, %56, %59
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #1 {
  %1 = alloca %struct.kimg, align 4
  %2 = alloca [13 x i32], align 4
  %3 = alloca [64 x i32], align 4
  tail call fastcc void @kenter() #12
  %4 = load i32, ptr @curr, align 4, !tbaa !6
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !32
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #12
  tail call fastcc void @swtch() #12
  br label %1034

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %12 = load i32, ptr %11, align 4, !tbaa !27
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !47
  switch i32 %14, label %1004 [
    i32 11, label %19
    i32 14, label %22
    i32 16, label %24
    i32 15, label %49
    i32 21, label %58
    i32 10, label %65
    i32 8, label %72
    i32 33, label %81
    i32 4, label %90
    i32 9, label %97
    i32 20, label %104
    i32 19, label %111
    i32 18, label %120
    i32 22, label %127
    i32 5, label %134
    i32 12, label %158
    i32 13, label %293
    i32 34, label %305
    i32 3, label %17
    i32 1, label %411
    i32 7, label %441
    i32 2, label %771
    i32 26, label %774
    i32 27, label %783
    i32 25, label %790
    i32 28, label %878
    i32 29, label %887
    i32 30, label %895
    i32 31, label %901
    i32 32, label %928
    i32 23, label %953
    i32 24, label %958
    i32 6, label %15
  ]

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 4
  br label %980

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %363

19:                                               ; preds = %10
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !16
  br label %1004

22:                                               ; preds = %10
  %23 = load i32, ptr @ticks, align 4, !tbaa !6
  br label %1004

24:                                               ; preds = %10
  %25 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %26 = load volatile i32, ptr %25, align 4, !tbaa !48
  %27 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %28 = load volatile i32, ptr %27, align 4, !tbaa !49
  %29 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %26, i32 noundef %28) #12
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %1004

31:                                               ; preds = %24
  %32 = load i32, ptr @fsready, align 4, !tbaa !6
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %40, label %34

34:                                               ; preds = %31
  %35 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %36 = load volatile i32, ptr %35, align 4, !tbaa !34
  %37 = load volatile i32, ptr %25, align 4, !tbaa !48
  %38 = load volatile i32, ptr %27, align 4, !tbaa !49
  %39 = tail call i32 @kfs_write(i32 noundef %36, i32 noundef %37, i32 noundef %38) #13
  br label %45

40:                                               ; preds = %31
  %41 = load volatile i32, ptr %25, align 4, !tbaa !48
  %42 = inttoptr i32 %41 to ptr
  %43 = load volatile i32, ptr %27, align 4, !tbaa !49
  tail call void @kconswrite(ptr noundef %42, i32 noundef %43) #12
  %44 = load volatile i32, ptr %27, align 4, !tbaa !49
  br label %45

45:                                               ; preds = %34, %40
  %46 = phi i32 [ %39, %34 ], [ %44, %40 ]
  %47 = freeze i32 %46
  %48 = icmp eq i32 %47, -3
  br i1 %48, label %1019, label %1004

49:                                               ; preds = %10
  %50 = load i32, ptr @fsready, align 4, !tbaa !6
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %1004, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %54 = load volatile i32, ptr %53, align 4, !tbaa !34
  %55 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %56 = load volatile i32, ptr %55, align 4, !tbaa !48
  %57 = tail call i32 @kfs_open(i32 noundef %54, i32 noundef %56) #13
  br label %1004

58:                                               ; preds = %10
  %59 = load i32, ptr @fsready, align 4, !tbaa !6
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %1004, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %63 = load volatile i32, ptr %62, align 4, !tbaa !34
  %64 = tail call i32 @kfs_close(i32 noundef %63) #13
  br label %1004

65:                                               ; preds = %10
  %66 = load i32, ptr @fsready, align 4, !tbaa !6
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %1004, label %68

68:                                               ; preds = %65
  %69 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %70 = load volatile i32, ptr %69, align 4, !tbaa !34
  %71 = tail call i32 @kfs_dup(i32 noundef %70) #13
  br label %1004

72:                                               ; preds = %10
  %73 = load i32, ptr @fsready, align 4, !tbaa !6
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %1004, label %75

75:                                               ; preds = %72
  %76 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %77 = load volatile i32, ptr %76, align 4, !tbaa !34
  %78 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %79 = load volatile i32, ptr %78, align 4, !tbaa !48
  %80 = tail call i32 @kfs_fstat(i32 noundef %77, i32 noundef %79) #13
  br label %1004

81:                                               ; preds = %10
  %82 = load i32, ptr @fsready, align 4, !tbaa !6
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %1004, label %84

84:                                               ; preds = %81
  %85 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %86 = load volatile i32, ptr %85, align 4, !tbaa !34
  %87 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %88 = load volatile i32, ptr %87, align 4, !tbaa !48
  %89 = tail call i32 @kfs_seek(i32 noundef %86, i32 noundef %88) #13
  br label %1004

90:                                               ; preds = %10
  %91 = load i32, ptr @fsready, align 4, !tbaa !6
  %92 = icmp eq i32 %91, 0
  br i1 %92, label %1004, label %93

93:                                               ; preds = %90
  %94 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %95 = load volatile i32, ptr %94, align 4, !tbaa !34
  %96 = tail call i32 @kfs_pipe(i32 noundef %95) #13
  br label %1004

97:                                               ; preds = %10
  %98 = load i32, ptr @fsready, align 4, !tbaa !6
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %1004, label %100

100:                                              ; preds = %97
  %101 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %102 = load volatile i32, ptr %101, align 4, !tbaa !34
  %103 = tail call i32 @kfs_chdir(i32 noundef %102) #13
  br label %1004

104:                                              ; preds = %10
  %105 = load i32, ptr @fsready, align 4, !tbaa !6
  %106 = icmp eq i32 %105, 0
  br i1 %106, label %1004, label %107

107:                                              ; preds = %104
  %108 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %109 = load volatile i32, ptr %108, align 4, !tbaa !34
  %110 = tail call i32 @kfs_mkdir(i32 noundef %109) #13
  br label %1004

111:                                              ; preds = %10
  %112 = load i32, ptr @fsready, align 4, !tbaa !6
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %1004, label %114

114:                                              ; preds = %111
  %115 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %116 = load volatile i32, ptr %115, align 4, !tbaa !34
  %117 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %118 = load volatile i32, ptr %117, align 4, !tbaa !48
  %119 = tail call i32 @kfs_link(i32 noundef %116, i32 noundef %118) #13
  br label %1004

120:                                              ; preds = %10
  %121 = load i32, ptr @fsready, align 4, !tbaa !6
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %1004, label %123

123:                                              ; preds = %120
  %124 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %125 = load volatile i32, ptr %124, align 4, !tbaa !34
  %126 = tail call i32 @kfs_unlink(i32 noundef %125) #13
  br label %1004

127:                                              ; preds = %10
  tail call void @kfb_pause() #13
  %128 = load i32, ptr @fsready, align 4, !tbaa !6
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %132, label %130

130:                                              ; preds = %127
  %131 = tail call i32 @kflash_sync() #13
  br label %132

132:                                              ; preds = %127, %130
  %133 = phi i32 [ %131, %130 ], [ -1, %127 ]
  tail call void @kfb_resume() #13
  br label %1004

134:                                              ; preds = %10
  %135 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %136 = load volatile i32, ptr %135, align 4, !tbaa !48
  %137 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %138 = load volatile i32, ptr %137, align 4, !tbaa !49
  %139 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %136, i32 noundef %138) #12
  %140 = icmp eq i32 %139, 0
  br i1 %140, label %141, label %1004

141:                                              ; preds = %134
  %142 = load i32, ptr @fsready, align 4, !tbaa !6
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %150, label %144

144:                                              ; preds = %141
  %145 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %146 = load volatile i32, ptr %145, align 4, !tbaa !34
  %147 = load volatile i32, ptr %135, align 4, !tbaa !48
  %148 = load volatile i32, ptr %137, align 4, !tbaa !49
  %149 = tail call i32 @kfs_read(i32 noundef %146, i32 noundef %147, i32 noundef %148) #13
  br label %154

150:                                              ; preds = %141
  %151 = load volatile i32, ptr %135, align 4, !tbaa !48
  %152 = load volatile i32, ptr %137, align 4, !tbaa !49
  %153 = tail call i32 @kconsread(i32 noundef %151, i32 noundef %152) #12
  br label %154

154:                                              ; preds = %144, %150
  %155 = phi i32 [ %149, %144 ], [ %153, %150 ]
  %156 = freeze i32 %155
  %157 = icmp eq i32 %156, -3
  br i1 %157, label %1019, label %1004

158:                                              ; preds = %10
  %159 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %160 = load volatile i32, ptr %159, align 4, !tbaa !34
  %161 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %162 = load i32, ptr %161, align 4, !tbaa !50
  %163 = icmp eq i32 %162, 0
  br i1 %163, label %167, label %164

164:                                              ; preds = %158
  %165 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %166 = load i32, ptr %165, align 4, !tbaa !51
  br label %230

167:                                              ; preds = %158
  %168 = icmp slt i32 %160, 0
  br i1 %168, label %1004, label %169

169:                                              ; preds = %167
  %170 = add nuw i32 %160, 255
  %171 = and i32 %170, -256
  %172 = icmp samesign ult i32 %160, 16129
  %173 = select i1 %172, i32 16384, i32 %171
  br label %174

174:                                              ; preds = %220, %169
  %175 = phi i32 [ %222, %220 ], [ %173, %169 ]
  %176 = load i1, ptr @kheap_init, align 4
  br i1 %176, label %183, label %177

177:                                              ; preds = %174
  store i1 true, ptr @kheap_init, align 4
  %178 = load i32, ptr @arena, align 4, !tbaa !6
  %179 = inttoptr i32 %178 to ptr
  store ptr %179, ptr @kfreelist, align 4, !tbaa !52
  %180 = load i32, ptr @arena_end, align 4, !tbaa !6
  %181 = sub i32 %180, %178
  store i32 %181, ptr %179, align 4, !tbaa !54
  %182 = getelementptr inbounds nuw i8, ptr %179, i32 4
  store ptr null, ptr %182, align 4, !tbaa !56
  br label %183

183:                                              ; preds = %177, %174
  %184 = add nuw i32 %175, 255
  %185 = and i32 %184, -256
  %186 = add nuw i32 %185, 256
  br label %187

187:                                              ; preds = %194, %183
  %188 = phi ptr [ @kfreelist, %183 ], [ %198, %194 ]
  %189 = phi ptr [ null, %183 ], [ %197, %194 ]
  %190 = load ptr, ptr %188, align 4, !tbaa !52
  %191 = icmp eq ptr %190, null
  br i1 %191, label %192, label %194

192:                                              ; preds = %187
  %193 = icmp eq ptr %189, null
  br i1 %193, label %215, label %199

194:                                              ; preds = %187
  %195 = load i32, ptr %190, align 4, !tbaa !54
  %196 = icmp ult i32 %195, %186
  %197 = select i1 %196, ptr %189, ptr %188
  %198 = getelementptr inbounds nuw i8, ptr %190, i32 4
  br label %187, !llvm.loop !57

199:                                              ; preds = %192
  %200 = load ptr, ptr %189, align 4, !tbaa !52
  %201 = load i32, ptr %200, align 4, !tbaa !54
  %202 = sub i32 %201, %186
  %203 = icmp ugt i32 %202, 511
  br i1 %203, label %204, label %208

204:                                              ; preds = %199
  store i32 %202, ptr %200, align 4, !tbaa !54
  %205 = ptrtoint ptr %200 to i32
  %206 = add i32 %202, %205
  %207 = inttoptr i32 %206 to ptr
  store i32 %186, ptr %207, align 4, !tbaa !54
  br label %212

208:                                              ; preds = %199
  %209 = getelementptr inbounds nuw i8, ptr %200, i32 4
  %210 = load ptr, ptr %209, align 4, !tbaa !56
  store ptr %210, ptr %189, align 4, !tbaa !52
  %211 = ptrtoint ptr %200 to i32
  br label %212

212:                                              ; preds = %208, %204
  %213 = phi i32 [ %206, %204 ], [ %211, %208 ]
  %214 = add i32 %213, 256
  br label %215

215:                                              ; preds = %192, %212
  %216 = phi i32 [ %214, %212 ], [ 0, %192 ]
  %217 = icmp eq i32 %216, 0
  %218 = icmp ugt i32 %175, %171
  %219 = select i1 %217, i1 %218, i1 false
  br i1 %219, label %220, label %223

220:                                              ; preds = %215
  %221 = lshr i32 %175, 1
  %222 = tail call i32 @llvm.umax.i32(i32 %221, i32 %171)
  br label %174, !llvm.loop !58

223:                                              ; preds = %215
  br i1 %217, label %1004, label %224

224:                                              ; preds = %223
  %225 = load i32, ptr @curr, align 4, !tbaa !6
  %226 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %225
  store i32 %216, ptr %226, align 4, !tbaa !6
  %227 = getelementptr inbounds nuw i8, ptr %5, i32 60
  store i32 %216, ptr %227, align 4, !tbaa !51
  store i32 %216, ptr %161, align 4, !tbaa !50
  %228 = add i32 %216, %175
  %229 = getelementptr inbounds nuw i8, ptr %5, i32 56
  store i32 %228, ptr %229, align 4, !tbaa !59
  br label %230

230:                                              ; preds = %224, %164
  %231 = phi i32 [ %162, %164 ], [ %216, %224 ]
  %232 = phi i32 [ %166, %164 ], [ %216, %224 ]
  %233 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %234 = icmp sgt i32 %160, -1
  br i1 %234, label %235, label %250

235:                                              ; preds = %230
  %236 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %237 = load i32, ptr %236, align 4, !tbaa !59
  %238 = sub i32 %237, %232
  %239 = icmp ugt i32 %160, %238
  br i1 %239, label %1004, label %240

240:                                              ; preds = %235
  %241 = add i32 %232, %160
  br label %242

242:                                              ; preds = %247, %240
  %243 = phi i32 [ %249, %247 ], [ %232, %240 ]
  %244 = icmp ult i32 %243, %241
  br i1 %244, label %247, label %245

245:                                              ; preds = %242
  %246 = load i32, ptr %233, align 4, !tbaa !51
  br label %254

247:                                              ; preds = %242
  %248 = inttoptr i32 %243 to ptr
  store volatile i8 0, ptr %248, align 1, !tbaa !3
  %249 = add nuw i32 %243, 1
  br label %242, !llvm.loop !60

250:                                              ; preds = %230
  %251 = sub nsw i32 0, %160
  %252 = sub i32 %232, %231
  %253 = icmp ult i32 %252, %251
  br i1 %253, label %1004, label %254

254:                                              ; preds = %250, %245
  %255 = phi i32 [ %246, %245 ], [ %232, %250 ]
  %256 = add i32 %255, %160
  store i32 %256, ptr %233, align 4, !tbaa !51
  %257 = getelementptr inbounds nuw i8, ptr %5, i32 56
  br label %258

258:                                              ; preds = %292, %254
  %259 = phi ptr [ %5, %254 ], [ %267, %292 ]
  %260 = ptrtoint ptr %259 to i32
  %261 = sub i32 %260, ptrtoint (ptr @proc to i32)
  %262 = sdiv exact i32 %261, 72
  br label %263

263:                                              ; preds = %274, %258
  %264 = phi i32 [ 0, %258 ], [ %275, %274 ]
  %265 = icmp eq i32 %264, 8
  br i1 %265, label %1004, label %266

266:                                              ; preds = %263
  %267 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %264
  %268 = load i32, ptr %267, align 4, !tbaa !14
  %269 = icmp eq i32 %268, 2
  br i1 %269, label %270, label %274

270:                                              ; preds = %266
  %271 = getelementptr inbounds nuw i8, ptr %267, i32 12
  %272 = load i32, ptr %271, align 4, !tbaa !18
  %273 = icmp eq i32 %272, %260
  br i1 %273, label %276, label %274

274:                                              ; preds = %270, %266
  %275 = add nuw nsw i32 %264, 1
  br label %263, !llvm.loop !61

276:                                              ; preds = %270
  %277 = getelementptr inbounds nuw i8, ptr %267, i32 52
  %278 = load i32, ptr %277, align 4, !tbaa !50
  %279 = load i32, ptr %161, align 4, !tbaa !50
  %280 = icmp eq i32 %278, %279
  br i1 %280, label %286, label %281

281:                                              ; preds = %276
  store i32 %279, ptr %277, align 4, !tbaa !50
  %282 = load i32, ptr %257, align 4, !tbaa !59
  %283 = getelementptr inbounds nuw i8, ptr %267, i32 56
  store i32 %282, ptr %283, align 4, !tbaa !59
  %284 = load i32, ptr %161, align 4, !tbaa !50
  %285 = getelementptr inbounds nuw i8, ptr %267, i32 60
  store i32 %284, ptr %285, align 4, !tbaa !51
  br label %286

286:                                              ; preds = %281, %276
  %287 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %262
  %288 = load i32, ptr %287, align 4, !tbaa !6
  %289 = icmp eq i32 %288, 0
  br i1 %289, label %292, label %290

290:                                              ; preds = %286
  %291 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %264
  store i32 %288, ptr %291, align 4, !tbaa !6
  store i32 0, ptr %287, align 4, !tbaa !6
  br label %292

292:                                              ; preds = %290, %286
  br label %258, !llvm.loop !62

293:                                              ; preds = %10
  %294 = load i32, ptr @ticks, align 4, !tbaa !6
  %295 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %296 = load volatile i32, ptr %295, align 4, !tbaa !34
  %297 = add i32 %296, %294
  %298 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %297, ptr %298, align 4, !tbaa !63
  %299 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %300 = load i32, ptr %299, align 4, !tbaa !37
  %301 = inttoptr i32 %300 to ptr
  %302 = load volatile i32, ptr %301, align 4, !tbaa !6
  %303 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %302, ptr %303, align 4, !tbaa !38
  %304 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %304, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %1023

305:                                              ; preds = %10
  %306 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %307 = load volatile i32, ptr %306, align 4, !tbaa !34
  br label %308

308:                                              ; preds = %332, %305
  %309 = phi i32 [ 0, %305 ], [ %334, %332 ]
  %310 = phi i32 [ 0, %305 ], [ %333, %332 ]
  %311 = icmp eq i32 %309, 31
  br i1 %311, label %312, label %314

312:                                              ; preds = %308
  %313 = icmp eq i32 %310, 0
  br i1 %313, label %335, label %1004

314:                                              ; preds = %308
  %315 = shl nuw nsw i32 1, %309
  %316 = and i32 %315, %307
  %317 = icmp eq i32 %316, 0
  br i1 %317, label %332, label %318

318:                                              ; preds = %314
  %319 = load i32, ptr @fsready, align 4, !tbaa !6
  %320 = icmp eq i32 %319, 0
  br i1 %320, label %324, label %321

321:                                              ; preds = %318
  %322 = tail call i32 @kfs_selready(i32 noundef %309) #13
  %323 = icmp eq i32 %322, 0
  br label %328

324:                                              ; preds = %318
  %325 = load i32, ptr @cons_r, align 4, !tbaa !6
  %326 = load i32, ptr @cons_w, align 4, !tbaa !6
  %327 = icmp eq i32 %325, %326
  br label %328

328:                                              ; preds = %324, %321
  %329 = phi i1 [ %323, %321 ], [ %327, %324 ]
  %330 = select i1 %329, i32 0, i32 %315
  %331 = or i32 %330, %310
  br label %332

332:                                              ; preds = %314, %328
  %333 = phi i32 [ %331, %328 ], [ %310, %314 ]
  %334 = add nuw nsw i32 %309, 1
  br label %308, !llvm.loop !64

335:                                              ; preds = %312
  %336 = icmp eq i32 %307, 0
  br i1 %336, label %1004, label %337

337:                                              ; preds = %335
  %338 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %339 = load volatile i32, ptr %338, align 4, !tbaa !48
  %340 = icmp eq i32 %339, 0
  br i1 %340, label %354, label %341

341:                                              ; preds = %337
  %342 = load i32, ptr @ticks, align 4, !tbaa !6
  %343 = load volatile i32, ptr %338, align 4, !tbaa !48
  %344 = add i32 %343, %342
  %345 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %344, ptr %345, align 4, !tbaa !63
  %346 = load i32, ptr @curr, align 4, !tbaa !6
  %347 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %346
  %348 = getelementptr inbounds nuw i8, ptr %347, i32 32
  %349 = load i32, ptr %348, align 4, !tbaa !37
  %350 = inttoptr i32 %349 to ptr
  %351 = load volatile i32, ptr %350, align 4, !tbaa !6
  %352 = getelementptr inbounds nuw i8, ptr %347, i32 40
  store i32 %351, ptr %352, align 4, !tbaa !38
  %353 = getelementptr inbounds nuw i8, ptr %347, i32 12
  store i32 ptrtoint (ptr @selwait_to to i32), ptr %353, align 4, !tbaa !18
  store i32 2, ptr %347, align 4, !tbaa !14
  br label %1019

354:                                              ; preds = %337
  %355 = load i32, ptr @curr, align 4, !tbaa !6
  %356 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %355
  %357 = getelementptr inbounds nuw i8, ptr %356, i32 32
  %358 = load i32, ptr %357, align 4, !tbaa !37
  %359 = inttoptr i32 %358 to ptr
  %360 = load volatile i32, ptr %359, align 4, !tbaa !6
  %361 = getelementptr inbounds nuw i8, ptr %356, i32 40
  store i32 %360, ptr %361, align 4, !tbaa !38
  %362 = getelementptr inbounds nuw i8, ptr %356, i32 12
  store i32 ptrtoint (ptr @selwait_inf to i32), ptr %362, align 4, !tbaa !18
  store i32 2, ptr %356, align 4, !tbaa !14
  br label %1019

363:                                              ; preds = %17, %382
  %364 = phi i32 [ %385, %382 ], [ 0, %17 ]
  %365 = phi i32 [ %383, %382 ], [ -1, %17 ]
  %366 = phi i32 [ %384, %382 ], [ 0, %17 ]
  %367 = icmp eq i32 %364, 8
  br i1 %367, label %368, label %370

368:                                              ; preds = %363
  %369 = icmp sgt i32 %365, -1
  br i1 %369, label %386, label %399

370:                                              ; preds = %363
  %371 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %364
  %372 = load i32, ptr %371, align 4, !tbaa !14
  %373 = icmp eq i32 %372, 0
  br i1 %373, label %382, label %374

374:                                              ; preds = %370
  %375 = getelementptr inbounds nuw i8, ptr %371, i32 8
  %376 = load i32, ptr %375, align 4, !tbaa !19
  %377 = load i32, ptr %18, align 4, !tbaa !16
  %378 = icmp eq i32 %376, %377
  br i1 %378, label %379, label %382

379:                                              ; preds = %374
  %380 = icmp eq i32 %372, 5
  %381 = select i1 %380, i32 %364, i32 %365
  br label %382

382:                                              ; preds = %379, %370, %374
  %383 = phi i32 [ %365, %374 ], [ %365, %370 ], [ %381, %379 ]
  %384 = phi i32 [ %366, %374 ], [ %366, %370 ], [ 1, %379 ]
  %385 = add nuw nsw i32 %364, 1
  br label %363, !llvm.loop !65

386:                                              ; preds = %368
  %387 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %388 = load volatile i32, ptr %387, align 4, !tbaa !34
  %389 = icmp eq i32 %388, 0
  br i1 %389, label %395, label %390

390:                                              ; preds = %386
  %391 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %365, i32 5
  %392 = load i32, ptr %391, align 4, !tbaa !43
  %393 = load volatile i32, ptr %387, align 4, !tbaa !34
  %394 = inttoptr i32 %393 to ptr
  store volatile i32 %392, ptr %394, align 4, !tbaa !6
  br label %395

395:                                              ; preds = %390, %386
  %396 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %365
  %397 = getelementptr inbounds nuw i8, ptr %396, i32 4
  %398 = load i32, ptr %397, align 4, !tbaa !16
  store i32 0, ptr %396, align 4, !tbaa !14
  br label %1004

399:                                              ; preds = %368
  %400 = icmp eq i32 %366, 0
  br i1 %400, label %1004, label %401

401:                                              ; preds = %399
  %402 = ptrtoint ptr %5 to i32
  %403 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %404 = load i32, ptr %403, align 4, !tbaa !37
  %405 = inttoptr i32 %404 to ptr
  %406 = load volatile i32, ptr %405, align 4, !tbaa !6
  %407 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %406, ptr %407, align 4, !tbaa !38
  %408 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %402, ptr %408, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  %409 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %410 = load volatile i32, ptr %409, align 4, !tbaa !28
  br label %1023

411:                                              ; preds = %10, %418
  %412 = phi i32 [ %419, %418 ], [ 0, %10 ]
  %413 = icmp eq i32 %412, 8
  br i1 %413, label %1004, label %414

414:                                              ; preds = %411
  %415 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %412
  %416 = load i32, ptr %415, align 4, !tbaa !14
  %417 = icmp eq i32 %416, 0
  br i1 %417, label %420, label %418

418:                                              ; preds = %414
  %419 = add nuw nsw i32 %412, 1
  br label %411, !llvm.loop !66

420:                                              ; preds = %414
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %415, ptr noundef nonnull align 4 dereferenceable(72) %5, i32 72, i1 false), !tbaa.struct !67
  %421 = load i32, ptr @fsready, align 4, !tbaa !6
  %422 = icmp eq i32 %421, 0
  br i1 %422, label %424, label %423

423:                                              ; preds = %420
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %412) #13
  br label %424

424:                                              ; preds = %423, %420
  %425 = load i32, ptr @nextpid, align 4, !tbaa !6
  %426 = add i32 %425, 1
  store i32 %426, ptr @nextpid, align 4, !tbaa !6
  %427 = getelementptr inbounds nuw i8, ptr %415, i32 4
  store i32 %425, ptr %427, align 4, !tbaa !16
  %428 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %429 = load i32, ptr %428, align 4, !tbaa !16
  %430 = getelementptr inbounds nuw i8, ptr %415, i32 8
  store i32 %429, ptr %430, align 4, !tbaa !19
  %431 = getelementptr inbounds nuw i8, ptr %415, i32 12
  store i32 0, ptr %431, align 4, !tbaa !18
  store i32 3, ptr %415, align 4, !tbaa !14
  %432 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %433 = load i32, ptr %432, align 4, !tbaa !37
  %434 = inttoptr i32 %433 to ptr
  %435 = load volatile i32, ptr %434, align 4, !tbaa !6
  %436 = getelementptr inbounds nuw i8, ptr %415, i32 40
  store i32 %435, ptr %436, align 4, !tbaa !38
  %437 = load volatile i32, ptr %434, align 4, !tbaa !6
  %438 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %437, ptr %438, align 4, !tbaa !38
  %439 = ptrtoint ptr %415 to i32
  %440 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %439, ptr %440, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %1023

441:                                              ; preds = %10
  call void @llvm.lifetime.start.p0(i64 84, ptr nonnull %1) #11
  %442 = load i32, ptr @fsready, align 4, !tbaa !6
  %443 = icmp eq i32 %442, 0
  br i1 %443, label %543, label %444

444:                                              ; preds = %441
  %445 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %446 = load volatile i32, ptr %445, align 4, !tbaa !34
  %447 = inttoptr i32 %446 to ptr
  %448 = tail call i32 @kfs_iopen(ptr noundef %447) #13
  %449 = icmp eq i32 %448, 0
  br i1 %449, label %543, label %450

450:                                              ; preds = %444
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #11
  %451 = ptrtoint ptr %2 to i32
  %452 = call i32 @kfs_iread(i32 noundef %448, i32 noundef 0, i32 noundef %451, i32 noundef 52) #13
  %453 = icmp eq i32 %452, 52
  %454 = load i32, ptr %2, align 4
  %455 = icmp eq i32 %454, 1480674628
  %456 = select i1 %453, i1 %455, i1 false
  br i1 %456, label %457, label %539

457:                                              ; preds = %450
  %458 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %459 = load i32, ptr %458, align 4, !tbaa !6
  %460 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %461 = load i32, ptr %460, align 4, !tbaa !6
  %462 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %463 = load i32, ptr %462, align 4, !tbaa !6
  %464 = getelementptr inbounds nuw i8, ptr %1, i32 28
  store i32 %463, ptr %464, align 4, !tbaa !68
  %465 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %466 = load i32, ptr %465, align 4, !tbaa !6
  %467 = getelementptr inbounds nuw i8, ptr %1, i32 32
  store i32 %466, ptr %467, align 4, !tbaa !70
  %468 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %469 = load i32, ptr %468, align 4, !tbaa !6
  %470 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %471 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %472 = load i32, ptr %471, align 4, !tbaa !6
  %473 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %472, ptr %473, align 4, !tbaa !71
  %474 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %475 = load i32, ptr %474, align 4, !tbaa !6
  %476 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %475, ptr %476, align 4, !tbaa !72
  %477 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %478 = load i32, ptr %477, align 4, !tbaa !6
  %479 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %478, ptr %479, align 4, !tbaa !73
  %480 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %481 = load i32, ptr %480, align 4, !tbaa !6
  %482 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %481, ptr %482, align 4, !tbaa !74
  %483 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %484 = load i32, ptr %483, align 4, !tbaa !6
  %485 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %484, ptr %485, align 4, !tbaa !75
  %486 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %487 = load i32, ptr %486, align 4, !tbaa !6
  %488 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %487, ptr %488, align 4, !tbaa !76
  %489 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %490 = load i32, ptr %489, align 4, !tbaa !6
  %491 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %490, ptr %491, align 4, !tbaa !77
  %492 = call fastcc i32 @kalloc(i32 noundef %459) #12
  %493 = call fastcc i32 @kalloc(i32 noundef %461) #12
  %494 = add i32 %459, 52
  %495 = add i32 %461, %494
  %496 = icmp ne i32 %492, 0
  %497 = icmp ne i32 %493, 0
  %498 = select i1 %496, i1 %497, i1 false
  br i1 %498, label %499, label %505

499:                                              ; preds = %457
  %500 = call i32 @kfs_iread(i32 noundef %448, i32 noundef 52, i32 noundef %492, i32 noundef %459) #13
  %501 = icmp eq i32 %500, %459
  br i1 %501, label %502, label %505

502:                                              ; preds = %499
  %503 = call i32 @kfs_iread(i32 noundef %448, i32 noundef %494, i32 noundef %493, i32 noundef %461) #13
  %504 = icmp eq i32 %503, %461
  br i1 %504, label %506, label %505

505:                                              ; preds = %502, %499, %457
  call fastcc void @kfree(i32 noundef %492) #12
  call fastcc void @kfree(i32 noundef %493) #12
  br label %539

506:                                              ; preds = %502
  %507 = sub i32 %492, %463
  %508 = sub i32 %493, %466
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #11
  %509 = ptrtoint ptr %3 to i32
  br label %510

510:                                              ; preds = %536, %506
  %511 = phi i32 [ %495, %506 ], [ %538, %536 ]
  %512 = phi i32 [ %469, %506 ], [ %537, %536 ]
  %513 = icmp eq i32 %512, 0
  br i1 %513, label %540, label %514

514:                                              ; preds = %510
  %515 = call i32 @llvm.umin.i32(i32 %512, i32 64)
  %516 = shl nuw nsw i32 %515, 2
  %517 = call i32 @kfs_iread(i32 noundef %448, i32 noundef %511, i32 noundef %509, i32 noundef %516) #13
  %518 = icmp eq i32 %517, %516
  br i1 %518, label %519, label %540

519:                                              ; preds = %514, %522
  %520 = phi i32 [ %535, %522 ], [ 0, %514 ]
  %521 = icmp eq i32 %520, %515
  br i1 %521, label %536, label %522

522:                                              ; preds = %519
  %523 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %520
  %524 = load i32, ptr %523, align 4, !tbaa !6
  %525 = icmp slt i32 %524, 0
  %526 = select i1 %525, i32 %493, i32 %492
  %527 = and i32 %524, 1073741823
  %528 = add i32 %526, %527
  %529 = and i32 %524, 1073741824
  %530 = icmp eq i32 %529, 0
  %531 = select i1 %530, i32 %507, i32 %508
  %532 = inttoptr i32 %528 to ptr
  %533 = load volatile i32, ptr %532, align 4, !tbaa !6
  %534 = add i32 %531, %533
  store volatile i32 %534, ptr %532, align 4, !tbaa !6
  %535 = add nuw nsw i32 %520, 1
  br label %519, !llvm.loop !78

536:                                              ; preds = %519
  %537 = sub i32 %512, %515
  %538 = add i32 %516, %511
  br label %510

539:                                              ; preds = %450, %505
  call void @kfs_iclose(i32 noundef %448) #13
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #11
  br label %730

540:                                              ; preds = %514, %510
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #11
  call void @kfs_iclose(i32 noundef %448) #13
  store i32 0, ptr %470, align 4, !tbaa !79
  %541 = getelementptr inbounds nuw i8, ptr %1, i32 36
  store i32 0, ptr %541, align 4, !tbaa !80
  %542 = getelementptr inbounds nuw i8, ptr %1, i32 72
  store i32 0, ptr %542, align 4, !tbaa !81
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #11
  br label %617

543:                                              ; preds = %441, %444
  %544 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %545 = load volatile i32, ptr %544, align 4, !tbaa !34
  %546 = inttoptr i32 %545 to ptr
  br label %547

547:                                              ; preds = %566, %543
  %548 = phi i32 [ 0, %543 ], [ %567, %566 ]
  %549 = icmp eq i32 %548, 20
  br i1 %549, label %730, label %550

550:                                              ; preds = %547
  %551 = getelementptr inbounds nuw [20 x %struct.kimg], ptr @kimages, i32 0, i32 %548
  %552 = load i8, ptr %551, align 4, !tbaa !3
  %553 = icmp eq i8 %552, 0
  br i1 %553, label %730, label %554

554:                                              ; preds = %550, %563
  %555 = phi i32 [ %565, %563 ], [ 0, %550 ]
  %556 = icmp eq i32 %555, 12
  br i1 %556, label %568, label %557

557:                                              ; preds = %554
  %558 = getelementptr inbounds nuw [12 x i8], ptr %551, i32 0, i32 %555
  %559 = load i8, ptr %558, align 1, !tbaa !3
  %560 = getelementptr inbounds nuw i8, ptr %546, i32 %555
  %561 = load i8, ptr %560, align 1, !tbaa !3
  %562 = icmp eq i8 %559, %561
  br i1 %562, label %563, label %566

563:                                              ; preds = %557
  %564 = icmp eq i8 %559, 0
  %565 = add nuw nsw i32 %555, 1
  br i1 %564, label %568, label %554, !llvm.loop !82

566:                                              ; preds = %557
  %567 = add nuw nsw i32 %548, 1
  br label %547, !llvm.loop !83

568:                                              ; preds = %563, %554
  %569 = getelementptr inbounds nuw i8, ptr %551, i32 72
  %570 = load i32, ptr %569, align 4, !tbaa !81
  %571 = icmp eq i32 %570, 0
  br i1 %571, label %595, label %572

572:                                              ; preds = %568
  %573 = getelementptr inbounds nuw i8, ptr %551, i32 80
  %574 = load i32, ptr %573, align 4, !tbaa !84
  %575 = add i32 %574, 7
  %576 = and i32 %575, -8
  %577 = getelementptr inbounds nuw i8, ptr %551, i32 24
  %578 = load i32, ptr %577, align 4, !tbaa !85
  %579 = add i32 %576, %578
  %580 = tail call fastcc i32 @kalloc(i32 noundef %579) #12
  %581 = load i32, ptr %569, align 4, !tbaa !81
  %582 = icmp eq i32 %580, %581
  br i1 %582, label %583, label %594

583:                                              ; preds = %572
  %584 = getelementptr inbounds nuw i8, ptr %551, i32 76
  %585 = load i32, ptr %584, align 4, !tbaa !86
  tail call void @kdmacpy(i32 noundef %580, i32 noundef %585, i32 noundef %576) #13
  %586 = add i32 %580, %576
  %587 = getelementptr inbounds nuw i8, ptr %551, i32 20
  %588 = load i32, ptr %587, align 4, !tbaa !87
  %589 = load i32, ptr %577, align 4, !tbaa !85
  %590 = add i32 %589, 3
  %591 = and i32 %590, -4
  tail call void @kdmacpy(i32 noundef %586, i32 noundef %588, i32 noundef %591) #13
  %592 = getelementptr inbounds nuw i8, ptr %551, i32 12
  %593 = load i32, ptr %592, align 4, !tbaa !88
  br label %617

594:                                              ; preds = %572
  tail call fastcc void @kfree(i32 noundef %580) #12
  br label %730

595:                                              ; preds = %568
  %596 = getelementptr inbounds nuw i8, ptr %551, i32 16
  %597 = load i32, ptr %596, align 4, !tbaa !89
  %598 = tail call fastcc i32 @kalloc(i32 noundef %597) #12
  %599 = getelementptr inbounds nuw i8, ptr %551, i32 24
  %600 = load i32, ptr %599, align 4, !tbaa !85
  %601 = tail call fastcc i32 @kalloc(i32 noundef %600) #12
  %602 = icmp ne i32 %598, 0
  %603 = icmp ne i32 %601, 0
  %604 = select i1 %602, i1 %603, i1 false
  br i1 %604, label %606, label %605

605:                                              ; preds = %595
  tail call fastcc void @kfree(i32 noundef %598) #12
  tail call fastcc void @kfree(i32 noundef %601) #12
  br label %730

606:                                              ; preds = %595
  %607 = getelementptr inbounds nuw i8, ptr %551, i32 12
  %608 = load i32, ptr %607, align 4, !tbaa !88
  %609 = load i32, ptr %596, align 4, !tbaa !89
  %610 = add i32 %609, 3
  %611 = and i32 %610, -4
  tail call void @kdmacpy(i32 noundef %598, i32 noundef %608, i32 noundef %611) #13
  %612 = getelementptr inbounds nuw i8, ptr %551, i32 20
  %613 = load i32, ptr %612, align 4, !tbaa !87
  %614 = load i32, ptr %599, align 4, !tbaa !85
  %615 = add i32 %614, 3
  %616 = and i32 %615, -4
  tail call void @kdmacpy(i32 noundef %601, i32 noundef %613, i32 noundef %616) #13
  br label %617

617:                                              ; preds = %583, %540, %606
  %618 = phi i32 [ %493, %540 ], [ %601, %606 ], [ %586, %583 ]
  %619 = phi i32 [ %492, %540 ], [ %598, %606 ], [ %593, %583 ]
  %620 = phi ptr [ %1, %540 ], [ %551, %606 ], [ %551, %583 ]
  %621 = getelementptr inbounds nuw i8, ptr %620, i32 28
  %622 = load i32, ptr %621, align 4, !tbaa !68
  %623 = sub i32 %619, %622
  %624 = getelementptr inbounds nuw i8, ptr %620, i32 32
  %625 = load i32, ptr %624, align 4, !tbaa !70
  %626 = sub i32 %618, %625
  %627 = getelementptr inbounds nuw i8, ptr %620, i32 36
  %628 = load i32, ptr %627, align 4, !tbaa !80
  %629 = inttoptr i32 %628 to ptr
  %630 = getelementptr inbounds nuw i8, ptr %620, i32 40
  br label %631

631:                                              ; preds = %675, %617
  %632 = phi i32 [ 0, %617 ], [ %688, %675 ]
  %633 = load i32, ptr %630, align 4, !tbaa !79
  %634 = icmp ult i32 %632, %633
  br i1 %634, label %675, label %635

635:                                              ; preds = %631
  %636 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %637 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %638 = getelementptr inbounds nuw i8, ptr %5, i32 60
  br label %639

639:                                              ; preds = %655, %635
  %640 = phi ptr [ %5, %635 ], [ %646, %655 ]
  %641 = ptrtoint ptr %640 to i32
  br label %642

642:                                              ; preds = %653, %639
  %643 = phi i32 [ 0, %639 ], [ %654, %653 ]
  %644 = icmp eq i32 %643, 8
  br i1 %644, label %662, label %645

645:                                              ; preds = %642
  %646 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %643
  %647 = load i32, ptr %646, align 4, !tbaa !14
  %648 = icmp eq i32 %647, 2
  br i1 %648, label %649, label %653

649:                                              ; preds = %645
  %650 = getelementptr inbounds nuw i8, ptr %646, i32 12
  %651 = load i32, ptr %650, align 4, !tbaa !18
  %652 = icmp eq i32 %651, %641
  br i1 %652, label %655, label %653

653:                                              ; preds = %649, %645
  %654 = add nuw nsw i32 %643, 1
  br label %642, !llvm.loop !90

655:                                              ; preds = %649
  %656 = load i32, ptr %636, align 4, !tbaa !50
  %657 = getelementptr inbounds nuw i8, ptr %646, i32 52
  store i32 %656, ptr %657, align 4, !tbaa !50
  %658 = load i32, ptr %637, align 4, !tbaa !59
  %659 = getelementptr inbounds nuw i8, ptr %646, i32 56
  store i32 %658, ptr %659, align 4, !tbaa !59
  %660 = load i32, ptr %638, align 4, !tbaa !51
  %661 = getelementptr inbounds nuw i8, ptr %646, i32 60
  store i32 %660, ptr %661, align 4, !tbaa !51
  br label %639, !llvm.loop !91

662:                                              ; preds = %642
  %663 = load i32, ptr @curr, align 4, !tbaa !6
  call fastcc void @kfree_exec(i32 noundef %663) #12
  %664 = getelementptr inbounds nuw i8, ptr %620, i32 72
  %665 = load i32, ptr %664, align 4, !tbaa !81
  %666 = icmp eq i32 %665, 0
  %667 = load i32, ptr @curr, align 4, !tbaa !6
  %668 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %667
  %669 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %667, i32 1
  %670 = select i1 %666, i32 %619, i32 0
  %671 = select i1 %666, i32 %618, i32 %665
  store i32 %670, ptr %668, align 4, !tbaa !6
  store i32 %671, ptr %669, align 4, !tbaa !6
  %672 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %673 = load volatile i32, ptr %672, align 4, !tbaa !48
  %674 = icmp eq i32 %673, 0
  br i1 %674, label %731, label %689

675:                                              ; preds = %631
  %676 = getelementptr inbounds nuw i32, ptr %629, i32 %632
  %677 = load i32, ptr %676, align 4, !tbaa !6
  %678 = icmp slt i32 %677, 0
  %679 = select i1 %678, i32 %618, i32 %619
  %680 = and i32 %677, 1073741823
  %681 = add i32 %679, %680
  %682 = and i32 %677, 1073741824
  %683 = icmp eq i32 %682, 0
  %684 = select i1 %683, i32 %623, i32 %626
  %685 = inttoptr i32 %681 to ptr
  %686 = load volatile i32, ptr %685, align 4, !tbaa !6
  %687 = add i32 %684, %686
  store volatile i32 %687, ptr %685, align 4, !tbaa !6
  %688 = add nuw i32 %632, 1
  br label %631, !llvm.loop !92

689:                                              ; preds = %662
  %690 = call fastcc i32 @kalloc(i32 noundef 256) #12
  %691 = icmp eq i32 %690, 0
  br i1 %691, label %731, label %692

692:                                              ; preds = %689
  %693 = load volatile i32, ptr %672, align 4, !tbaa !48
  %694 = inttoptr i32 %693 to ptr
  %695 = inttoptr i32 %690 to ptr
  %696 = add i32 %690, 64
  %697 = inttoptr i32 %696 to ptr
  %698 = add i32 %690, 256
  %699 = inttoptr i32 %698 to ptr
  %700 = getelementptr inbounds i8, ptr %699, i32 -1
  br label %701

701:                                              ; preds = %723, %692
  %702 = phi i32 [ 0, %692 ], [ %725, %723 ]
  %703 = phi ptr [ %697, %692 ], [ %724, %723 ]
  %704 = icmp eq i32 %702, 15
  br i1 %704, label %726, label %705

705:                                              ; preds = %701
  %706 = getelementptr inbounds nuw i32, ptr %694, i32 %702
  %707 = load i32, ptr %706, align 4, !tbaa !6
  %708 = icmp eq i32 %707, 0
  br i1 %708, label %726, label %709

709:                                              ; preds = %705
  %710 = inttoptr i32 %707 to ptr
  %711 = ptrtoint ptr %703 to i32
  %712 = getelementptr inbounds nuw i32, ptr %695, i32 %702
  store i32 %711, ptr %712, align 4, !tbaa !6
  br label %713

713:                                              ; preds = %720, %709
  %714 = phi ptr [ %703, %709 ], [ %722, %720 ]
  %715 = phi ptr [ %710, %709 ], [ %721, %720 ]
  %716 = load i8, ptr %715, align 1, !tbaa !3
  %717 = icmp ne i8 %716, 0
  %718 = icmp ult ptr %714, %700
  %719 = select i1 %717, i1 %718, i1 false
  br i1 %719, label %720, label %723

720:                                              ; preds = %713
  %721 = getelementptr inbounds nuw i8, ptr %715, i32 1
  %722 = getelementptr inbounds nuw i8, ptr %714, i32 1
  store i8 %716, ptr %714, align 1, !tbaa !3
  br label %713, !llvm.loop !93

723:                                              ; preds = %713
  %724 = getelementptr inbounds nuw i8, ptr %714, i32 1
  store i8 0, ptr %714, align 1, !tbaa !3
  %725 = add nuw nsw i32 %702, 1
  br label %701, !llvm.loop !94

726:                                              ; preds = %701, %705
  %727 = getelementptr inbounds nuw i32, ptr %695, i32 %702
  store i32 0, ptr %727, align 4, !tbaa !6
  %728 = load i32, ptr @curr, align 4, !tbaa !6
  %729 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %728, i32 2
  store i32 %690, ptr %729, align 4, !tbaa !6
  br label %731

730:                                              ; preds = %547, %550, %594, %605, %539
  call void @llvm.lifetime.end.p0(i64 84, ptr nonnull %1) #11
  br label %1004

731:                                              ; preds = %662, %726, %689
  %732 = phi i32 [ 0, %662 ], [ %702, %726 ], [ 0, %689 ]
  %733 = phi i32 [ 0, %662 ], [ %690, %726 ], [ 0, %689 ]
  %734 = getelementptr inbounds nuw i8, ptr %620, i32 52
  %735 = load i32, ptr %734, align 4, !tbaa !73
  %736 = add i32 %735, %618
  %737 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %736, ptr %737, align 4, !tbaa !31
  %738 = getelementptr inbounds nuw i8, ptr %620, i32 56
  %739 = load i32, ptr %738, align 4, !tbaa !74
  %740 = add i32 %739, %618
  %741 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %740, ptr %741, align 4, !tbaa !95
  %742 = getelementptr inbounds nuw i8, ptr %620, i32 60
  %743 = load i32, ptr %742, align 4, !tbaa !75
  %744 = add i32 %743, %618
  %745 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %744, ptr %745, align 4, !tbaa !37
  %746 = getelementptr inbounds nuw i8, ptr %620, i32 48
  %747 = load i32, ptr %746, align 4, !tbaa !72
  %748 = add i32 %747, %619
  %749 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %748, ptr %749, align 4, !tbaa !42
  %750 = getelementptr inbounds nuw i8, ptr %620, i32 64
  %751 = load i32, ptr %750, align 4, !tbaa !76
  %752 = add i32 %751, %618
  store i32 %752, ptr %11, align 4, !tbaa !27
  %753 = load i32, ptr @k_sysentry, align 4, !tbaa !6
  %754 = getelementptr inbounds nuw i8, ptr %620, i32 68
  %755 = load i32, ptr %754, align 4, !tbaa !77
  %756 = add i32 %755, %618
  %757 = inttoptr i32 %756 to ptr
  store volatile i32 %753, ptr %757, align 4, !tbaa !6
  %758 = load i32, ptr %749, align 4, !tbaa !42
  %759 = load i32, ptr %737, align 4, !tbaa !31
  %760 = inttoptr i32 %759 to ptr
  store volatile i32 %758, ptr %760, align 4, !tbaa !6
  %761 = load i32, ptr %734, align 4, !tbaa !73
  %762 = add i32 %761, %618
  %763 = add i32 %762, -84
  %764 = inttoptr i32 %763 to ptr
  store volatile i32 %732, ptr %764, align 4, !tbaa !6
  %765 = add i32 %762, -80
  %766 = inttoptr i32 %765 to ptr
  store volatile i32 %733, ptr %766, align 4, !tbaa !6
  call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  store i32 4, ptr %5, align 4, !tbaa !14
  %767 = load i32, ptr @curr, align 4, !tbaa !6
  %768 = getelementptr inbounds nuw i8, ptr %620, i32 44
  %769 = load i32, ptr %768, align 4, !tbaa !71
  %770 = add i32 %769, %619
  call fastcc void @kexit(i32 noundef %767, i32 noundef %770) #12
  call void @llvm.lifetime.end.p0(i64 84, ptr nonnull %1) #11
  br label %1034

771:                                              ; preds = %10
  %772 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %773 = load volatile i32, ptr %772, align 4, !tbaa !34
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef %773) #12
  br label %1019

774:                                              ; preds = %10
  %775 = load i32, ptr @fsready, align 4, !tbaa !6
  %776 = icmp eq i32 %775, 0
  br i1 %776, label %1004, label %777

777:                                              ; preds = %774
  %778 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %779 = load volatile i32, ptr %778, align 4, !tbaa !34
  %780 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %781 = load volatile i32, ptr %780, align 4, !tbaa !48
  %782 = tail call i32 @kfs_mount(i32 noundef %779, i32 noundef %781) #13
  br label %1004

783:                                              ; preds = %10
  %784 = load i32, ptr @fsready, align 4, !tbaa !6
  %785 = icmp eq i32 %784, 0
  br i1 %785, label %1004, label %786

786:                                              ; preds = %783
  %787 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %788 = load volatile i32, ptr %787, align 4, !tbaa !34
  %789 = tail call i32 @kfs_umount(i32 noundef %788) #13
  br label %1004

790:                                              ; preds = %10
  %791 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %792 = load volatile i32, ptr %791, align 4, !tbaa !34
  %793 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %794 = load i32, ptr %793, align 4, !tbaa !59
  %795 = icmp ult i32 %792, %794
  br i1 %795, label %796, label %803

796:                                              ; preds = %790
  %797 = add i32 %792, 32
  %798 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %799 = load i32, ptr %798, align 4, !tbaa !51
  %800 = icmp ugt i32 %797, %799
  br i1 %800, label %801, label %803

801:                                              ; preds = %796
  %802 = icmp ugt i32 %792, -33
  br i1 %802, label %803, label %1004

803:                                              ; preds = %790, %796, %801
  %804 = load volatile i32, ptr %791, align 4, !tbaa !34
  %805 = inttoptr i32 %804 to ptr
  %806 = load i32, ptr @arena_end, align 4, !tbaa !6
  %807 = load i32, ptr @arena, align 4, !tbaa !6
  %808 = sub i32 %806, %807
  store i32 %808, ptr %805, align 4, !tbaa !6
  %809 = getelementptr inbounds nuw i8, ptr %805, i32 4
  store i32 0, ptr %809, align 4, !tbaa !6
  %810 = getelementptr inbounds nuw i8, ptr %805, i32 8
  store i32 0, ptr %810, align 4, !tbaa !6
  %811 = load i1, ptr @kheap_init, align 4
  br i1 %811, label %813, label %812

812:                                              ; preds = %803
  store i32 %808, ptr %810, align 4, !tbaa !6
  store i32 %808, ptr %809, align 4, !tbaa !6
  br label %828

813:                                              ; preds = %803, %825
  %814 = phi i32 [ %826, %825 ], [ 0, %803 ]
  %815 = phi i32 [ %821, %825 ], [ 0, %803 ]
  %816 = phi ptr [ %827, %825 ], [ @kfreelist, %803 ]
  %817 = load ptr, ptr %816, align 4, !tbaa !52
  %818 = icmp eq ptr %817, null
  br i1 %818, label %828, label %819

819:                                              ; preds = %813
  %820 = load i32, ptr %817, align 4, !tbaa !54
  %821 = add i32 %815, %820
  store i32 %821, ptr %809, align 4, !tbaa !6
  %822 = load i32, ptr %817, align 4, !tbaa !54
  %823 = icmp ugt i32 %822, %814
  br i1 %823, label %824, label %825

824:                                              ; preds = %819
  store i32 %822, ptr %810, align 4, !tbaa !6
  br label %825

825:                                              ; preds = %819, %824
  %826 = phi i32 [ %814, %819 ], [ %822, %824 ]
  %827 = getelementptr inbounds nuw i8, ptr %817, i32 4
  br label %813, !llvm.loop !96

828:                                              ; preds = %813, %812
  %829 = getelementptr inbounds nuw i8, ptr %805, i32 20
  store i32 0, ptr %829, align 4, !tbaa !6
  %830 = getelementptr inbounds nuw i8, ptr %805, i32 16
  store i32 0, ptr %830, align 4, !tbaa !6
  %831 = getelementptr inbounds nuw i8, ptr %805, i32 12
  store i32 0, ptr %831, align 4, !tbaa !6
  br label %832

832:                                              ; preds = %875, %828
  %833 = phi i32 [ 0, %828 ], [ %854, %875 ]
  %834 = phi i32 [ 0, %828 ], [ %876, %875 ]
  %835 = phi i32 [ 0, %828 ], [ %852, %875 ]
  %836 = phi i32 [ 0, %828 ], [ %877, %875 ]
  %837 = icmp eq i32 %836, 8
  br i1 %837, label %838, label %842

838:                                              ; preds = %832
  %839 = getelementptr inbounds nuw i8, ptr %805, i32 24
  store i32 8, ptr %839, align 4, !tbaa !6
  %840 = load i32, ptr @ticks, align 4, !tbaa !6
  %841 = getelementptr inbounds nuw i8, ptr %805, i32 28
  store i32 %840, ptr %841, align 4, !tbaa !6
  br label %1004

842:                                              ; preds = %832
  %843 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %836
  %844 = load i32, ptr %843, align 4, !tbaa !6
  %845 = icmp eq i32 %844, 0
  br i1 %845, label %851, label %846

846:                                              ; preds = %842
  %847 = add i32 %844, -256
  %848 = inttoptr i32 %847 to ptr
  %849 = load volatile i32, ptr %848, align 4, !tbaa !6
  %850 = add i32 %835, %849
  store i32 %850, ptr %831, align 4, !tbaa !6
  br label %851

851:                                              ; preds = %846, %842
  %852 = phi i32 [ %850, %846 ], [ %835, %842 ]
  br label %853

853:                                              ; preds = %870, %851
  %854 = phi i32 [ %833, %851 ], [ %871, %870 ]
  %855 = phi i32 [ 0, %851 ], [ %872, %870 ]
  %856 = icmp eq i32 %855, 3
  br i1 %856, label %857, label %861

857:                                              ; preds = %853
  %858 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %836
  %859 = load i32, ptr %858, align 4, !tbaa !14
  %860 = icmp eq i32 %859, 0
  br i1 %860, label %875, label %873

861:                                              ; preds = %853
  %862 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %836, i32 %855
  %863 = load i32, ptr %862, align 4, !tbaa !6
  %864 = icmp eq i32 %863, 0
  br i1 %864, label %870, label %865

865:                                              ; preds = %861
  %866 = add i32 %863, -256
  %867 = inttoptr i32 %866 to ptr
  %868 = load volatile i32, ptr %867, align 4, !tbaa !6
  %869 = add i32 %854, %868
  store i32 %869, ptr %830, align 4, !tbaa !6
  br label %870

870:                                              ; preds = %861, %865
  %871 = phi i32 [ %854, %861 ], [ %869, %865 ]
  %872 = add nuw nsw i32 %855, 1
  br label %853, !llvm.loop !97

873:                                              ; preds = %857
  %874 = add i32 %834, 1
  store i32 %874, ptr %829, align 4, !tbaa !6
  br label %875

875:                                              ; preds = %857, %873
  %876 = phi i32 [ %834, %857 ], [ %874, %873 ]
  %877 = add nuw nsw i32 %836, 1
  br label %832, !llvm.loop !98

878:                                              ; preds = %10
  %879 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %880 = load volatile i32, ptr %879, align 4, !tbaa !34
  %881 = icmp eq i32 %880, 0
  br i1 %881, label %886, label %882

882:                                              ; preds = %878
  store i1 true, ptr @cons_raw, align 4
  %883 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %884 = load i32, ptr %883, align 4, !tbaa !16
  store i32 %884, ptr @cons_raw_pid, align 4, !tbaa !6
  %885 = load i32, ptr @cons_e, align 4, !tbaa !6
  store i32 %885, ptr @cons_w, align 4, !tbaa !6
  br label %1004

886:                                              ; preds = %878
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !6
  br label %1004

887:                                              ; preds = %10
  %888 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %889 = load volatile i32, ptr %888, align 4, !tbaa !34
  %890 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %891 = load volatile i32, ptr %890, align 4, !tbaa !48
  %892 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %893 = load volatile i32, ptr %892, align 4, !tbaa !49
  %894 = tail call i32 @kgpio(i32 noundef %889, i32 noundef %891, i32 noundef %893) #13
  br label %1004

895:                                              ; preds = %10
  %896 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %897 = load volatile i32, ptr %896, align 4, !tbaa !34
  %898 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %899 = load volatile i32, ptr %898, align 4, !tbaa !48
  %900 = tail call i32 @kpinmux(i32 noundef %897, i32 noundef %899) #13
  br label %1004

901:                                              ; preds = %10
  %902 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %903 = load volatile i32, ptr %902, align 4, !tbaa !34
  %904 = icmp eq i32 %903, 0
  br i1 %904, label %908, label %905

905:                                              ; preds = %901
  %906 = load volatile i32, ptr %902, align 4, !tbaa !34
  %907 = icmp eq i32 %906, 1
  br i1 %907, label %908, label %921

908:                                              ; preds = %905, %901
  %909 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %910 = load volatile i32, ptr %909, align 4, !tbaa !48
  %911 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %912 = load i32, ptr %911, align 4, !tbaa !59
  %913 = icmp ult i32 %910, %912
  br i1 %913, label %914, label %921

914:                                              ; preds = %908
  %915 = add i32 %910, 28
  %916 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %917 = load i32, ptr %916, align 4, !tbaa !51
  %918 = icmp ugt i32 %915, %917
  br i1 %918, label %919, label %921

919:                                              ; preds = %914
  %920 = icmp ugt i32 %910, -29
  br i1 %920, label %921, label %1004

921:                                              ; preds = %908, %914, %919, %905
  %922 = load volatile i32, ptr %902, align 4, !tbaa !34
  %923 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %924 = load volatile i32, ptr %923, align 4, !tbaa !48
  %925 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %926 = load volatile i32, ptr %925, align 4, !tbaa !49
  %927 = tail call i32 @kpio(i32 noundef %922, i32 noundef %924, i32 noundef %926) #13
  br label %1004

928:                                              ; preds = %10
  %929 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %930 = load volatile i32, ptr %929, align 4, !tbaa !34
  %931 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %932 = load volatile i32, ptr %931, align 4, !tbaa !48
  %933 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %934 = load i32, ptr %933, align 4, !tbaa !16
  %935 = load volatile i32, ptr %929, align 4, !tbaa !34
  %936 = icmp eq i32 %935, 0
  br i1 %936, label %937, label %950

937:                                              ; preds = %928
  %938 = load volatile i32, ptr %931, align 4, !tbaa !48
  %939 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %940 = load i32, ptr %939, align 4, !tbaa !59
  %941 = icmp ult i32 %938, %940
  br i1 %941, label %942, label %950

942:                                              ; preds = %937
  %943 = add i32 %938, 20
  %944 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %945 = load i32, ptr %944, align 4, !tbaa !51
  %946 = icmp ugt i32 %943, %945
  br i1 %946, label %947, label %950

947:                                              ; preds = %942
  %948 = icmp ult i32 %938, -20
  %949 = zext i1 %948 to i32
  br label %950

950:                                              ; preds = %947, %942, %937, %928
  %951 = phi i32 [ 0, %928 ], [ 0, %942 ], [ 0, %937 ], [ %949, %947 ]
  %952 = tail call i32 @kfb_syscall(i32 noundef %930, i32 noundef %932, i32 noundef %934, i32 noundef %951) #13
  br label %1004

953:                                              ; preds = %10
  %954 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %955 = load volatile i32, ptr %954, align 4, !tbaa !49
  %956 = getelementptr inbounds nuw i8, ptr %5, i32 64
  store i32 %955, ptr %956, align 4, !tbaa !25
  %957 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %957, align 4, !tbaa !26
  br label %1004

958:                                              ; preds = %10
  %959 = getelementptr inbounds nuw i8, ptr %5, i32 64
  %960 = load i32, ptr %959, align 4, !tbaa !25
  %961 = icmp eq i32 %960, 0
  br i1 %961, label %1004, label %962

962:                                              ; preds = %958
  %963 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %964 = load i32, ptr %963, align 4, !tbaa !31
  %965 = add i32 %964, -84
  %966 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %966, align 4, !tbaa !26
  %967 = add i32 %960, 8
  %968 = inttoptr i32 %967 to ptr
  %969 = load volatile i32, ptr %968, align 4, !tbaa !6
  %970 = inttoptr i32 %965 to ptr
  store volatile i32 %969, ptr %970, align 4, !tbaa !6
  %971 = add i32 %960, 12
  %972 = inttoptr i32 %971 to ptr
  %973 = load volatile i32, ptr %972, align 4, !tbaa !6
  %974 = add i32 %964, -80
  %975 = inttoptr i32 %974 to ptr
  store volatile i32 %973, ptr %975, align 4, !tbaa !6
  store i32 4, ptr %5, align 4, !tbaa !14
  %976 = load i32, ptr @curr, align 4, !tbaa !6
  %977 = add i32 %960, 4
  %978 = inttoptr i32 %977 to ptr
  %979 = load volatile i32, ptr %978, align 4, !tbaa !6
  tail call fastcc void @kexit(i32 noundef %976, i32 noundef %979) #12
  br label %1034

980:                                              ; preds = %15, %992
  %981 = phi i32 [ %993, %992 ], [ 0, %15 ]
  %982 = icmp eq i32 %981, 8
  br i1 %982, label %1004, label %983

983:                                              ; preds = %980
  %984 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %981
  %985 = load i32, ptr %984, align 4, !tbaa !14
  %986 = icmp eq i32 %985, 0
  br i1 %986, label %992, label %987

987:                                              ; preds = %983
  %988 = getelementptr inbounds nuw i8, ptr %984, i32 4
  %989 = load i32, ptr %988, align 4, !tbaa !16
  %990 = load volatile i32, ptr %16, align 4, !tbaa !34
  %991 = icmp eq i32 %989, %990
  br i1 %991, label %994, label %992

992:                                              ; preds = %983, %987
  %993 = add nuw nsw i32 %981, 1
  br label %980, !llvm.loop !99

994:                                              ; preds = %987
  %995 = icmp eq i32 %985, 5
  br i1 %995, label %1004, label %996

996:                                              ; preds = %994
  %997 = icmp eq i32 %981, %4
  br i1 %997, label %998, label %999

998:                                              ; preds = %996
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #12
  br label %1019

999:                                              ; preds = %996
  %1000 = icmp eq i32 %985, 2
  br i1 %1000, label %1001, label %1002

1001:                                             ; preds = %999
  tail call fastcc void @terminate(ptr noundef nonnull %984, i32 noundef -1) #12
  br label %1004

1002:                                             ; preds = %999
  %1003 = getelementptr inbounds nuw i8, ptr %984, i32 48
  store i32 1, ptr %1003, align 4, !tbaa !32
  br label %1004

1004:                                             ; preds = %980, %411, %263, %134, %24, %10, %19, %22, %132, %801, %838, %887, %895, %921, %950, %953, %49, %52, %58, %61, %65, %68, %72, %75, %81, %84, %90, %93, %97, %100, %104, %107, %111, %114, %120, %123, %335, %312, %395, %399, %774, %777, %783, %786, %886, %882, %919, %994, %1002, %1001, %958, %45, %154, %167, %223, %235, %250, %730
  %1005 = phi i32 [ -1, %730 ], [ -1, %223 ], [ -1, %250 ], [ -1, %235 ], [ -1, %167 ], [ %156, %154 ], [ %47, %45 ], [ -1, %958 ], [ 0, %1001 ], [ 0, %1002 ], [ -1, %994 ], [ -1, %919 ], [ 0, %882 ], [ 0, %886 ], [ -1, %783 ], [ %789, %786 ], [ -1, %774 ], [ %782, %777 ], [ -1, %399 ], [ %398, %395 ], [ %310, %312 ], [ 0, %335 ], [ -1, %120 ], [ %126, %123 ], [ -1, %111 ], [ %119, %114 ], [ -1, %104 ], [ %110, %107 ], [ -1, %97 ], [ %103, %100 ], [ -1, %90 ], [ %96, %93 ], [ -1, %81 ], [ %89, %84 ], [ -1, %72 ], [ %80, %75 ], [ -1, %65 ], [ %71, %68 ], [ -1, %58 ], [ %64, %61 ], [ -1, %49 ], [ %57, %52 ], [ 0, %953 ], [ %952, %950 ], [ %927, %921 ], [ %900, %895 ], [ %894, %887 ], [ 0, %838 ], [ -1, %801 ], [ %133, %132 ], [ %23, %22 ], [ %21, %19 ], [ -1, %10 ], [ -1, %24 ], [ -1, %134 ], [ %232, %263 ], [ -1, %411 ], [ -1, %980 ]
  %1006 = load i32, ptr %11, align 4, !tbaa !27
  %1007 = inttoptr i32 %1006 to ptr
  %1008 = getelementptr inbounds nuw i8, ptr %1007, i32 16
  store volatile i32 %1005, ptr %1008, align 4, !tbaa !28
  %1009 = getelementptr inbounds nuw i8, ptr %1007, i32 20
  store volatile i32 1, ptr %1009, align 4, !tbaa !30
  %1010 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %1011 = load i32, ptr %1010, align 4, !tbaa !31
  %1012 = add i32 %1011, -84
  %1013 = inttoptr i32 %1012 to ptr
  store volatile i32 %1005, ptr %1013, align 4, !tbaa !6
  store i32 4, ptr %5, align 4, !tbaa !14
  %1014 = load i32, ptr @curr, align 4, !tbaa !6
  %1015 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %1016 = load i32, ptr %1015, align 4, !tbaa !37
  %1017 = inttoptr i32 %1016 to ptr
  %1018 = load volatile i32, ptr %1017, align 4, !tbaa !6
  call fastcc void @kexit(i32 noundef %1014, i32 noundef %1018) #12
  br label %1034

1019:                                             ; preds = %154, %45, %771, %341, %354, %998
  %1020 = phi i32 [ -1, %998 ], [ 0, %341 ], [ 0, %354 ], [ -1, %771 ], [ -3, %45 ], [ -3, %154 ]
  %1021 = load i32, ptr %5, align 4, !tbaa !14
  %1022 = icmp eq i32 %1021, 2
  br i1 %1022, label %1023, label %1033

1023:                                             ; preds = %424, %401, %293, %1019
  %1024 = phi i32 [ %1020, %1019 ], [ 0, %424 ], [ %410, %401 ], [ 0, %293 ]
  %1025 = load i32, ptr %11, align 4, !tbaa !27
  %1026 = inttoptr i32 %1025 to ptr
  %1027 = getelementptr inbounds nuw i8, ptr %1026, i32 16
  store volatile i32 %1024, ptr %1027, align 4, !tbaa !28
  %1028 = getelementptr inbounds nuw i8, ptr %1026, i32 20
  store volatile i32 1, ptr %1028, align 4, !tbaa !30
  %1029 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %1030 = load i32, ptr %1029, align 4, !tbaa !31
  %1031 = add i32 %1030, -84
  %1032 = inttoptr i32 %1031 to ptr
  store volatile i32 %1024, ptr %1032, align 4, !tbaa !6
  br label %1033

1033:                                             ; preds = %1023, %1019
  tail call fastcc void @swtch() #12
  br label %1034

1034:                                             ; preds = %731, %962, %1004, %1033, %9
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @badbuf(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #6 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 56
  %5 = load i32, ptr %4, align 4, !tbaa !59
  %6 = icmp ne i32 %2, 0
  %7 = icmp ult i32 %1, %5
  %8 = and i1 %6, %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = add i32 %2, %1
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 60
  %12 = load i32, ptr %11, align 4, !tbaa !51
  %13 = icmp ugt i32 %10, %12
  br i1 %13, label %14, label %17

14:                                               ; preds = %9
  %15 = icmp uge i32 %10, %1
  %16 = zext i1 %15 to i32
  br label %17

17:                                               ; preds = %14, %9, %3
  %18 = phi i32 [ 0, %9 ], [ 0, %3 ], [ %16, %14 ]
  ret i32 %18
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_write(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_open(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_close(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_dup(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_fstat(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_seek(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_pipe(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_chdir(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mkdir(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_link(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_unlink(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfb_pause() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sync() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfb_resume() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_read(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_selready(i32 noundef) local_unnamed_addr #7

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_forkcopy(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iopen(ptr noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iread(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_iclose(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #9 {
  %2 = load i1, ptr @kheap_init, align 4
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  store i1 true, ptr @kheap_init, align 4
  %4 = load i32, ptr @arena, align 4, !tbaa !6
  %5 = inttoptr i32 %4 to ptr
  store ptr %5, ptr @kfreelist, align 4, !tbaa !52
  %6 = load i32, ptr @arena_end, align 4, !tbaa !6
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !54
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr null, ptr %8, align 4, !tbaa !56
  br label %9

9:                                                ; preds = %3, %1
  %10 = add i32 %0, 255
  %11 = and i32 %10, -256
  %12 = add i32 %11, 256
  br label %13

13:                                               ; preds = %38, %9
  %14 = phi ptr [ @kfreelist, %9 ], [ %39, %38 ]
  %15 = load ptr, ptr %14, align 4, !tbaa !52
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !54
  %19 = icmp ult i32 %18, %12
  br i1 %19, label %38, label %20

20:                                               ; preds = %17
  %21 = sub nuw i32 %18, %12
  %22 = icmp ugt i32 %21, 511
  br i1 %22, label %23, label %30

23:                                               ; preds = %20
  %24 = ptrtoint ptr %15 to i32
  %25 = add i32 %12, %24
  %26 = inttoptr i32 %25 to ptr
  store i32 %21, ptr %26, align 4, !tbaa !54
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !56
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !56
  store i32 %12, ptr %15, align 4, !tbaa !54
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !56
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !52
  %37 = add i32 %35, 256
  br label %40

38:                                               ; preds = %17
  %39 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %13, !llvm.loop !100

40:                                               ; preds = %13, %34
  %41 = phi i32 [ %37, %34 ], [ 0, %13 ]
  ret i32 %41
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #9 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %41, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -256
  br label %5

5:                                                ; preds = %5, %3
  %6 = phi ptr [ null, %3 ], [ %8, %5 ]
  %7 = phi ptr [ @kfreelist, %3 ], [ %13, %5 ]
  %8 = load ptr, ptr %7, align 4, !tbaa !52
  %9 = icmp ne ptr %8, null
  %10 = ptrtoint ptr %8 to i32
  %11 = icmp ugt i32 %4, %10
  %12 = and i1 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 4
  br i1 %12, label %5, label %14, !llvm.loop !101

14:                                               ; preds = %5
  %15 = inttoptr i32 %4 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  store ptr %8, ptr %16, align 4, !tbaa !56
  %17 = icmp eq ptr %6, null
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %15, ptr %19, align 4, !tbaa !56
  br label %21

20:                                               ; preds = %14
  store ptr %15, ptr @kfreelist, align 4, !tbaa !52
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !54
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !54
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !54
  %29 = load ptr, ptr %13, align 4, !tbaa !56
  store ptr %29, ptr %16, align 4, !tbaa !56
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !54
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !54
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !54
  %39 = load ptr, ptr %16, align 4, !tbaa !56
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !56
  br label %41

41:                                               ; preds = %30, %31, %36, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kdmacpy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree_exec(i32 noundef %0) unnamed_addr #9 {
  br label %2

2:                                                ; preds = %14, %1
  %3 = phi i32 [ 0, %1 ], [ %17, %14 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %5, label %14

5:                                                ; preds = %2
  %6 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !6
  tail call fastcc void @kfree(i32 noundef %7) #12
  store i32 0, ptr %6, align 4, !tbaa !6
  %8 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 60
  store i32 0, ptr %9, align 4, !tbaa !51
  %10 = getelementptr inbounds nuw i8, ptr %8, i32 56
  store i32 0, ptr %10, align 4, !tbaa !59
  %11 = getelementptr inbounds nuw i8, ptr %8, i32 52
  store i32 0, ptr %11, align 4, !tbaa !50
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 68
  store i32 0, ptr %12, align 4, !tbaa !26
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 64
  store i32 0, ptr %13, align 4, !tbaa !25
  ret void

14:                                               ; preds = %2
  %15 = getelementptr inbounds [8 x [3 x i32]], ptr @execmem, i32 0, i32 %0, i32 %3
  %16 = load i32, ptr %15, align 4, !tbaa !6
  tail call fastcc void @kfree(i32 noundef %16) #12
  store i32 0, ptr %15, align 4, !tbaa !6
  %17 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !102
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @vfork_release(ptr noundef %0) unnamed_addr #5 {
  %2 = ptrtoint ptr %0 to i32
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  br label %4

4:                                                ; preds = %27, %1
  %5 = phi i32 [ 0, %1 ], [ %28, %27 ]
  %6 = icmp eq i32 %5, 8
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %5
  %10 = load i32, ptr %9, align 4, !tbaa !14
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %27

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !18
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr %3, align 4, !tbaa !16
  %18 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %19 = load i32, ptr %18, align 4, !tbaa !27
  %20 = inttoptr i32 %19 to ptr
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store volatile i32 %17, ptr %21, align 4, !tbaa !28
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 20
  store volatile i32 1, ptr %22, align 4, !tbaa !30
  %23 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %24 = load i32, ptr %23, align 4, !tbaa !31
  %25 = add i32 %24, -84
  %26 = inttoptr i32 %25 to ptr
  store volatile i32 %17, ptr %26, align 4, !tbaa !6
  store i32 0, ptr %13, align 4, !tbaa !18
  store i32 3, ptr %9, align 4, !tbaa !14
  br label %27

27:                                               ; preds = %16, %12, %8
  %28 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !103
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #1 {
  %3 = load i32, ptr @entry_disp, align 4, !tbaa !6
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %11, label %5

5:                                                ; preds = %2
  %6 = inttoptr i32 %3 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !6
  %8 = load i32, ptr @entry_thunk, align 4, !tbaa !6
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store volatile i32 %8, ptr %6, align 4, !tbaa !6
  tail call fastcc void @fire_income() #12
  br label %11

11:                                               ; preds = %10, %5, %2
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 68
  %14 = load i32, ptr %13, align 4, !tbaa !26
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %40

16:                                               ; preds = %11
  %17 = getelementptr inbounds nuw i8, ptr %12, i32 64
  %18 = load i32, ptr %17, align 4, !tbaa !25
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %40, label %20

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !31
  %23 = add i32 %22, -84
  %24 = add i32 %18, 4
  %25 = inttoptr i32 %24 to ptr
  store volatile i32 %1, ptr %25, align 4, !tbaa !6
  %26 = inttoptr i32 %23 to ptr
  %27 = load volatile i32, ptr %26, align 4, !tbaa !6
  %28 = load i32, ptr %17, align 4, !tbaa !25
  %29 = add i32 %28, 8
  %30 = inttoptr i32 %29 to ptr
  store volatile i32 %27, ptr %30, align 4, !tbaa !6
  %31 = add i32 %22, -80
  %32 = inttoptr i32 %31 to ptr
  %33 = load volatile i32, ptr %32, align 4, !tbaa !6
  %34 = load i32, ptr %17, align 4, !tbaa !25
  %35 = add i32 %34, 12
  %36 = inttoptr i32 %35 to ptr
  store volatile i32 %33, ptr %36, align 4, !tbaa !6
  %37 = load i32, ptr %17, align 4, !tbaa !25
  %38 = inttoptr i32 %37 to ptr
  %39 = load volatile i32, ptr %38, align 4, !tbaa !6
  store i32 2, ptr %13, align 4, !tbaa !26
  br label %40

40:                                               ; preds = %20, %16, %11
  %41 = phi i32 [ %39, %20 ], [ %1, %16 ], [ %1, %11 ]
  store i32 %0, ptr @curr, align 4, !tbaa !6
  %42 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %43 = load i32, ptr %42, align 4, !tbaa !31
  %44 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !39
  store i32 %43, ptr %44, align 4, !tbaa !6
  %45 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %46 = load i32, ptr %45, align 4, !tbaa !42
  %47 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !39
  store i32 %46, ptr %47, align 4, !tbaa !6
  %48 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %49 = load i32, ptr %48, align 4, !tbaa !95
  %50 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !39
  store i32 %49, ptr %50, align 4, !tbaa !6
  %51 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !39
  store i32 %41, ptr %51, align 4, !tbaa !6
  %52 = load i32, ptr %42, align 4, !tbaa !31
  %53 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %54 = inttoptr i32 %53 to ptr
  store volatile i32 %52, ptr %54, align 4, !tbaa !6
  %55 = load i32, ptr @tickpending, align 4, !tbaa !6
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %58, label %57

57:                                               ; preds = %40
  store i32 0, ptr @tickpending, align 4, !tbaa !6
  tail call fastcc void @fire_income() #12
  br label %58

58:                                               ; preds = %57, %40
  %59 = tail call i32 @kcons_on() #13
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %67, label %61

61:                                               ; preds = %58
  %62 = load i32, ptr @fgpid, align 4, !tbaa !6
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %65, label %64

64:                                               ; preds = %61
  tail call fastcc void @cons_poll() #12
  br label %65

65:                                               ; preds = %64, %61
  tail call void @kcons_kick() #13
  %66 = load i32, ptr %42, align 4, !tbaa !31
  tail call void @kcons_aim(i32 noundef %66) #13
  br label %67

67:                                               ; preds = %65, %58
  %68 = load i1, ptr @rearm, align 4
  br i1 %68, label %69, label %72

69:                                               ; preds = %67
  %70 = load i32, ptr @inj_treg, align 4, !tbaa !6
  %71 = inttoptr i32 %70 to ptr
  store volatile i32 1, ptr %71, align 4, !tbaa !6
  br label %72

72:                                               ; preds = %69, %67
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mount(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_umount(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kgpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kpinmux(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_syscall(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #1 {
  tail call void @dma_ktick() #12
  tail call void @dma_ksyscall() #12
  ret i32 0
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc_wire(i32 noundef range(i32 0, 256) %0) unnamed_addr #1 {
  %2 = tail call i32 @kcons_tx(i32 noundef %0) #13
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %9

4:                                                ; preds = %1, %4
  %5 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !6
  %6 = and i32 %5, 32
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %4, !llvm.loop !104

8:                                                ; preds = %4
  store volatile i32 %0, ptr @__dma_uart_dr, align 4, !tbaa !6
  br label %9

9:                                                ; preds = %1, %8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_putc(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_tx(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_rx() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kcons_aim(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_init() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_on() local_unnamed_addr #7

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tick_income() unnamed_addr #1 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !6
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !6
  store i1 true, ptr @rearm, align 4
  br label %3

3:                                                ; preds = %25, %0
  %4 = phi i32 [ 0, %0 ], [ %26, %25 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  %7 = load i32, ptr @fgpid, align 4, !tbaa !6
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %28, label %27

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %11 = load i32, ptr %10, align 4, !tbaa !14
  %12 = icmp eq i32 %11, 2
  br i1 %12, label %13, label %25

13:                                               ; preds = %9
  %14 = getelementptr inbounds nuw i8, ptr %10, i32 12
  %15 = load i32, ptr %14, align 4, !tbaa !18
  %16 = icmp eq i32 %15, ptrtoint (ptr @ticks to i32)
  br i1 %16, label %19, label %17

17:                                               ; preds = %13
  %18 = icmp eq i32 %15, ptrtoint (ptr @selwait_to to i32)
  br i1 %18, label %19, label %25

19:                                               ; preds = %17, %13
  %20 = getelementptr inbounds nuw i8, ptr %10, i32 16
  %21 = load i32, ptr %20, align 4, !tbaa !63
  %22 = sub i32 %2, %21
  %23 = icmp sgt i32 %22, -1
  br i1 %23, label %24, label %25

24:                                               ; preds = %19
  store i32 0, ptr %14, align 4, !tbaa !18
  store i32 3, ptr %10, align 4, !tbaa !14
  br label %25

25:                                               ; preds = %24, %19, %17, %9
  %26 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !105

27:                                               ; preds = %6
  tail call fastcc void @cons_poll() #12
  br label %28

28:                                               ; preds = %27, %6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kcons_kick() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_owner() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfb_setowner(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #10

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #10

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #11 = { nounwind }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }
attributes #13 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !4, i64 0}
!8 = distinct !{!8, !9, !10}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{!"llvm.loop.unroll.disable"}
!11 = distinct !{!11, !9, !10}
!12 = distinct !{!12, !9, !10}
!13 = distinct !{!13, !9, !10}
!14 = !{!15, !7, i64 0}
!15 = !{!"proc", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !7, i64 32, !7, i64 36, !7, i64 40, !7, i64 44, !7, i64 48, !7, i64 52, !7, i64 56, !7, i64 60, !7, i64 64, !7, i64 68}
!16 = !{!15, !7, i64 4}
!17 = distinct !{!17, !9, !10}
!18 = !{!15, !7, i64 12}
!19 = !{!15, !7, i64 8}
!20 = distinct !{!20, !9, !10}
!21 = distinct !{!21, !9, !10}
!22 = distinct !{!22, !9, !10}
!23 = distinct !{!23, !9, !10}
!24 = distinct !{!24, !9, !10}
!25 = !{!15, !7, i64 64}
!26 = !{!15, !7, i64 68}
!27 = !{!15, !7, i64 44}
!28 = !{!29, !7, i64 16}
!29 = !{!"dma_sysmail", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20}
!30 = !{!29, !7, i64 20}
!31 = !{!15, !7, i64 24}
!32 = !{!15, !7, i64 48}
!33 = distinct !{!33, !9, !10}
!34 = !{!29, !7, i64 4}
!35 = distinct !{!35, !9, !10}
!36 = distinct !{!36, !9, !10}
!37 = !{!15, !7, i64 32}
!38 = !{!15, !7, i64 40}
!39 = !{!40, !40, i64 0}
!40 = !{!"p1 int", !41, i64 0}
!41 = !{!"any pointer", !4, i64 0}
!42 = !{!15, !7, i64 36}
!43 = !{!15, !7, i64 20}
!44 = distinct !{!44, !9, !10}
!45 = distinct !{!45, !9, !10}
!46 = distinct !{!46, !9, !10}
!47 = !{!29, !7, i64 0}
!48 = !{!29, !7, i64 8}
!49 = !{!29, !7, i64 12}
!50 = !{!15, !7, i64 52}
!51 = !{!15, !7, i64 60}
!52 = !{!53, !53, i64 0}
!53 = !{!"p1 _ZTS4khdr", !41, i64 0}
!54 = !{!55, !7, i64 0}
!55 = !{!"khdr", !7, i64 0, !53, i64 4}
!56 = !{!55, !53, i64 4}
!57 = distinct !{!57, !9, !10}
!58 = distinct !{!58, !9, !10}
!59 = !{!15, !7, i64 56}
!60 = distinct !{!60, !9, !10}
!61 = distinct !{!61, !9, !10}
!62 = distinct !{!62, !10}
!63 = !{!15, !7, i64 16}
!64 = distinct !{!64, !9, !10}
!65 = distinct !{!65, !9, !10}
!66 = distinct !{!66, !9, !10}
!67 = !{i64 0, i64 4, !6, i64 4, i64 4, !6, i64 8, i64 4, !6, i64 12, i64 4, !6, i64 16, i64 4, !6, i64 20, i64 4, !6, i64 24, i64 4, !6, i64 28, i64 4, !6, i64 32, i64 4, !6, i64 36, i64 4, !6, i64 40, i64 4, !6, i64 44, i64 4, !6, i64 48, i64 4, !6, i64 52, i64 4, !6, i64 56, i64 4, !6, i64 60, i64 4, !6, i64 64, i64 4, !6, i64 68, i64 4, !6}
!68 = !{!69, !7, i64 28}
!69 = !{!"kimg", !4, i64 0, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !7, i64 32, !7, i64 36, !7, i64 40, !7, i64 44, !7, i64 48, !7, i64 52, !7, i64 56, !7, i64 60, !7, i64 64, !7, i64 68, !7, i64 72, !7, i64 76, !7, i64 80}
!70 = !{!69, !7, i64 32}
!71 = !{!69, !7, i64 44}
!72 = !{!69, !7, i64 48}
!73 = !{!69, !7, i64 52}
!74 = !{!69, !7, i64 56}
!75 = !{!69, !7, i64 60}
!76 = !{!69, !7, i64 64}
!77 = !{!69, !7, i64 68}
!78 = distinct !{!78, !9, !10}
!79 = !{!69, !7, i64 40}
!80 = !{!69, !7, i64 36}
!81 = !{!69, !7, i64 72}
!82 = distinct !{!82, !9, !10}
!83 = distinct !{!83, !9, !10}
!84 = !{!69, !7, i64 80}
!85 = !{!69, !7, i64 24}
!86 = !{!69, !7, i64 76}
!87 = !{!69, !7, i64 20}
!88 = !{!69, !7, i64 12}
!89 = !{!69, !7, i64 16}
!90 = distinct !{!90, !9, !10}
!91 = distinct !{!91, !10}
!92 = distinct !{!92, !9, !10}
!93 = distinct !{!93, !9, !10}
!94 = distinct !{!94, !9, !10}
!95 = !{!15, !7, i64 28}
!96 = distinct !{!96, !9, !10}
!97 = distinct !{!97, !9, !10}
!98 = distinct !{!98, !9, !10}
!99 = distinct !{!99, !9, !10}
!100 = distinct !{!100, !9, !10}
!101 = distinct !{!101, !9, !10}
!102 = distinct !{!102, !9, !10}
!103 = distinct !{!103, !9, !10}
!104 = distinct !{!104, !9, !10}
!105 = distinct !{!105, !9, !10}
