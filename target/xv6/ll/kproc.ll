; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@inj_wreg = dso_local local_unnamed_addr global i32 1342177476, align 4
@inj_treg = dso_local local_unnamed_addr global i32 1342177500, align 4
@kimages = dso_local global [24 x %struct.kimg] zeroinitializer, align 4
@wall0_hi = internal global i32 0, align 4
@wall0_lo = internal global i32 0, align 4
@cons_r = internal unnamed_addr global i32 0, align 4
@cons_w = internal unnamed_addr global i32 0, align 4
@cons_buf = internal unnamed_addr global [128 x i8] zeroinitializer, align 1
@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@waspark = internal unnamed_addr global i32 0, align 4
@kw_curresume = dso_local global ptr null, align 4
@fsready = external dso_local local_unnamed_addr global i32, align 4
@ntimed = internal unnamed_addr global i32 0, align 4
@__dma_timerawl = external dso_local global i32, align 4
@ticks = dso_local global i32 0, align 4
@selwait_to = internal global i32 0, align 4
@selwait_inf = internal global i32 0, align 4
@procname = dso_local global [8 x [12 x i8]] zeroinitializer, align 1
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
@xv6_commit = dso_local local_unnamed_addr global i32 0, align 4
@__dma_timerawh = external dso_local global i32, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@tick_taken = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@parked = internal unnamed_addr global i1 false, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4
@.str = private unnamed_addr constant [17 x i8] c"xv6-dma version \00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"0123456789abcdef\00", align 1
@.str.2 = private unnamed_addr constant [49 x i8] c" based on xv6-riscv & xv6-ns (rp2dma-xv6-dmacc)\0A\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"fb: 640x480x8 on hstx-dvi\0A\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"fb: psram fail\0A\00", align 1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local ptr @kimg_name(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 0
  br i1 %2, label %10, label %3

3:                                                ; preds = %1
  %4 = icmp samesign ugt i32 %0, 23
  br i1 %4, label %10, label %5

5:                                                ; preds = %3
  %6 = getelementptr inbounds nuw [24 x %struct.kimg], ptr @kimages, i32 0, i32 %0
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
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca [20 x i8], align 1
  %4 = alloca [10 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #15
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #15
  %5 = load i32, ptr @wall0_hi, align 4, !tbaa !6
  %6 = load i32, ptr @wall0_lo, align 4, !tbaa !6
  call fastcc void @wall_since(i32 noundef %5, i32 noundef %6, ptr noundef %1, ptr noundef %2) #16
  %7 = call fastcc i32 @us_div(ptr noundef %1, ptr noundef %2, i32 noundef 1000000) #16
  %8 = load i32, ptr %2, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %3) #15
  store i8 91, ptr %3, align 1, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %4) #15
  br label %9

9:                                                ; preds = %9, %0
  %10 = phi i32 [ %8, %0 ], [ %13, %9 ]
  %11 = phi i32 [ 0, %0 ], [ %18, %9 ]
  %12 = freeze i32 %10
  %13 = udiv i32 %12, 10
  %14 = mul i32 %13, 10
  %15 = sub i32 %12, %14
  %16 = trunc nuw nsw i32 %15 to i8
  %17 = or disjoint i8 %16, 48
  %18 = add nuw nsw i32 %11, 1
  %19 = getelementptr inbounds nuw [10 x i8], ptr %4, i32 0, i32 %11
  store i8 %17, ptr %19, align 1, !tbaa !3
  %20 = icmp ugt i32 %10, 9
  %21 = icmp samesign ult i32 %11, 9
  %22 = select i1 %20, i1 %21, i1 false
  br i1 %22, label %9, label %23, !llvm.loop !8

23:                                               ; preds = %9, %27
  %24 = phi i32 [ %31, %27 ], [ 1, %9 ]
  %25 = phi i32 [ %28, %27 ], [ %18, %9 ]
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %33, label %27

27:                                               ; preds = %23
  %28 = add nsw i32 %25, -1
  %29 = getelementptr inbounds [10 x i8], ptr %4, i32 0, i32 %28
  %30 = load i8, ptr %29, align 1, !tbaa !3
  %31 = add nuw nsw i32 %24, 1
  %32 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %24
  store i8 %30, ptr %32, align 1, !tbaa !3
  br label %23, !llvm.loop !11

33:                                               ; preds = %23
  %34 = udiv i32 %7, 1000
  %35 = add nuw nsw i32 %24, 1
  %36 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %24
  store i8 46, ptr %36, align 1, !tbaa !3
  %37 = udiv i32 %7, 100000
  %38 = trunc i32 %37 to i8
  %39 = add i8 %38, 48
  %40 = add nuw nsw i32 %24, 2
  %41 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %35
  store i8 %39, ptr %41, align 1, !tbaa !3
  %42 = udiv i32 %7, 10000
  %43 = urem i32 %42, 10
  %44 = trunc nuw nsw i32 %43 to i8
  %45 = or disjoint i8 %44, 48
  %46 = add nuw nsw i32 %24, 3
  %47 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %40
  store i8 %45, ptr %47, align 1, !tbaa !3
  %48 = urem i32 %34, 10
  %49 = trunc nuw nsw i32 %48 to i8
  %50 = or disjoint i8 %49, 48
  %51 = add nuw nsw i32 %24, 4
  %52 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %46
  store i8 %50, ptr %52, align 1, !tbaa !3
  %53 = add nuw nsw i32 %24, 5
  %54 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %51
  store i8 93, ptr %54, align 1, !tbaa !3
  %55 = add nuw nsw i32 %24, 6
  %56 = getelementptr inbounds nuw [20 x i8], ptr %3, i32 0, i32 %53
  store i8 32, ptr %56, align 1, !tbaa !3
  call void @kconswrite(ptr noundef nonnull %3, i32 noundef %55) #16
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %4) #15
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %3) #15
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #15
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #15
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @wall_since(i32 noundef %0, i32 noundef %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #3 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #15
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #15
  call fastcc void @wall_now(ptr noundef nonnull %5, ptr noundef nonnull %6) #16
  %7 = load i32, ptr %6, align 4, !tbaa !6
  %8 = sub i32 %7, %1
  store i32 %8, ptr %3, align 4, !tbaa !6
  %9 = load i32, ptr %5, align 4, !tbaa !6
  %10 = sub i32 %9, %0
  %11 = icmp ult i32 %7, %1
  %12 = sext i1 %11 to i32
  %13 = add i32 %10, %12
  store i32 %13, ptr %2, align 4, !tbaa !6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #15
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #15
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc i32 @us_div(ptr noundef nonnull captures(none) %0, ptr noundef nonnull captures(none) %1, i32 noundef range(i32 100, 1000001) %2) unnamed_addr #4 {
  %4 = load i32, ptr %1, align 4, !tbaa !6
  %5 = load i32, ptr %0, align 4, !tbaa !6
  %6 = freeze i32 %5
  %7 = udiv i32 %6, %2
  %8 = mul i32 %7, %2
  %9 = sub i32 %6, %8
  br label %10

10:                                               ; preds = %16, %3
  %11 = phi i32 [ 0, %3 ], [ %25, %16 ]
  %12 = phi i32 [ %9, %3 ], [ %27, %16 ]
  %13 = phi i32 [ -2147483648, %3 ], [ %28, %16 ]
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %16

15:                                               ; preds = %10
  store i32 %7, ptr %0, align 4, !tbaa !6
  store i32 %11, ptr %1, align 4, !tbaa !6
  ret i32 %12

16:                                               ; preds = %10
  %17 = shl i32 %12, 1
  %18 = and i32 %13, %4
  %19 = icmp ne i32 %18, 0
  %20 = zext i1 %19 to i32
  %21 = or disjoint i32 %17, %20
  %22 = shl i32 %11, 1
  %23 = icmp uge i32 %21, %2
  %24 = zext i1 %23 to i32
  %25 = or disjoint i32 %22, %24
  %26 = select i1 %23, i32 %2, i32 0
  %27 = sub nuw i32 %21, %26
  %28 = lshr i32 %13, 1
  br label %10, !llvm.loop !12
}

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
  tail call fastcc void @cputc(i32 noundef %10) #16
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !13
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc(i32 noundef range(i32 -128, -2147483648) %0) unnamed_addr #1 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  tail call fastcc void @cputc_wire(i32 noundef 13) #16
  br label %4

4:                                                ; preds = %3, %1
  %5 = and i32 %0, 255
  tail call fastcc void @cputc_wire(i32 noundef %5) #16
  tail call void @kfbcon_putc(i32 noundef %0) #17
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  tail call fastcc void @cons_poll() #16
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
  %8 = tail call i32 @kcons_rx() #17
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
  br i1 %35, label %88, label %36, !llvm.loop !14

36:                                               ; preds = %33
  %37 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %34
  %38 = load i32, ptr %37, align 4, !tbaa !15
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %44, label %40

40:                                               ; preds = %36
  %41 = getelementptr inbounds nuw i8, ptr %37, i32 4
  %42 = load i32, ptr %41, align 4, !tbaa !17
  %43 = icmp eq i32 %42, %31
  br i1 %43, label %46, label %44

44:                                               ; preds = %40, %36
  %45 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !18

46:                                               ; preds = %40
  %47 = icmp eq i32 %38, 2
  br i1 %47, label %48, label %88

48:                                               ; preds = %46
  %49 = getelementptr inbounds nuw i8, ptr %37, i32 12
  %50 = load i32, ptr %49, align 4, !tbaa !19
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
  %60 = load i32, ptr %59, align 4, !tbaa !15
  switch i32 %60, label %61 [
    i32 0, label %70
    i32 5, label %70
  ]

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %59, i32 8
  %63 = load i32, ptr %62, align 4, !tbaa !20
  %64 = icmp eq i32 %63, %31
  br i1 %64, label %65, label %70

65:                                               ; preds = %61
  %66 = getelementptr inbounds nuw i8, ptr %59, i32 4
  %67 = load i32, ptr %66, align 4, !tbaa !17
  %68 = icmp ugt i32 %67, %55
  br i1 %68, label %69, label %70

69:                                               ; preds = %65
  br label %70

70:                                               ; preds = %69, %65, %61, %58, %58
  %71 = phi ptr [ %59, %69 ], [ %54, %65 ], [ %54, %61 ], [ %54, %58 ], [ %54, %58 ]
  %72 = phi i32 [ %67, %69 ], [ %55, %65 ], [ %55, %61 ], [ %55, %58 ], [ %55, %58 ]
  %73 = add nuw nsw i32 %56, 1
  br label %53, !llvm.loop !21

74:                                               ; preds = %48, %84
  %75 = phi i32 [ %85, %84 ], [ 0, %48 ]
  %76 = icmp eq i32 %75, 8
  br i1 %76, label %88, label %77, !llvm.loop !14

77:                                               ; preds = %74
  %78 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %75
  %79 = ptrtoint ptr %78 to i32
  %80 = icmp eq i32 %50, %79
  br i1 %80, label %81, label %84

81:                                               ; preds = %77
  %82 = load i32, ptr %78, align 4, !tbaa !15
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %84, label %89

84:                                               ; preds = %81, %77
  %85 = add nuw nsw i32 %75, 1
  br label %74, !llvm.loop !22

86:                                               ; preds = %53
  %87 = icmp eq ptr %54, null
  br i1 %87, label %88, label %89

88:                                               ; preds = %33, %74, %132, %86, %46, %30, %22, %178, %174, %200, %204, %180
  br label %2, !llvm.loop !14

89:                                               ; preds = %81, %86
  %90 = phi ptr [ %54, %86 ], [ %78, %81 ]
  tail call fastcc void @cputc(i32 noundef 94) #16
  tail call fastcc void @cputc(i32 noundef 67) #16
  tail call fastcc void @cputc(i32 noundef 10) #16
  br label %91

91:                                               ; preds = %129, %89
  %92 = phi i32 [ 0, %89 ], [ %130, %129 ]
  %93 = phi i32 [ 0, %89 ], [ %131, %129 ]
  %94 = icmp eq i32 %93, 8
  br i1 %94, label %132, label %95

95:                                               ; preds = %91
  %96 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %93
  %97 = load i32, ptr %96, align 4, !tbaa !15
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
  %108 = load i32, ptr %107, align 4, !tbaa !20
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %129, label %110

110:                                              ; preds = %106, %121
  %111 = phi i32 [ %122, %121 ], [ 0, %106 ]
  %112 = icmp eq i32 %111, 8
  br i1 %112, label %123, label %113

113:                                              ; preds = %110
  %114 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %111
  %115 = load i32, ptr %114, align 4, !tbaa !15
  %116 = icmp eq i32 %115, 0
  br i1 %116, label %121, label %117

117:                                              ; preds = %113
  %118 = getelementptr inbounds nuw i8, ptr %114, i32 4
  %119 = load i32, ptr %118, align 4, !tbaa !17
  %120 = icmp eq i32 %119, %108
  br i1 %120, label %123, label %121

121:                                              ; preds = %117, %113
  %122 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !23

123:                                              ; preds = %117, %110
  %124 = phi ptr [ null, %110 ], [ %114, %117 ]
  %125 = add nuw nsw i32 %100, 1
  br label %98, !llvm.loop !24

126:                                              ; preds = %104
  %127 = shl nuw nsw i32 1, %93
  %128 = or i32 %127, %92
  br label %129

129:                                              ; preds = %106, %98, %126, %95, %95
  %130 = phi i32 [ %128, %126 ], [ %92, %95 ], [ %92, %95 ], [ %92, %98 ], [ %92, %106 ]
  %131 = add nuw nsw i32 %93, 1
  br label %91, !llvm.loop !25

132:                                              ; preds = %91, %169
  %133 = phi i32 [ %170, %169 ], [ 0, %91 ]
  %134 = icmp eq i32 %133, 8
  br i1 %134, label %88, label %135, !llvm.loop !14

135:                                              ; preds = %132
  %136 = shl nuw nsw i32 1, %133
  %137 = and i32 %136, %92
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %169, label %139

139:                                              ; preds = %135
  %140 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %133
  %141 = getelementptr inbounds nuw i8, ptr %140, i32 64
  %142 = load i32, ptr %141, align 4, !tbaa !26
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %163, label %144

144:                                              ; preds = %139
  %145 = getelementptr inbounds nuw i8, ptr %140, i32 68
  %146 = load i32, ptr %145, align 4, !tbaa !27
  %147 = icmp eq i32 %146, 0
  br i1 %147, label %148, label %169

148:                                              ; preds = %144
  %149 = load i32, ptr %140, align 4, !tbaa !15
  %150 = icmp eq i32 %149, 2
  br i1 %150, label %151, label %162

151:                                              ; preds = %148
  %152 = getelementptr inbounds nuw i8, ptr %140, i32 44
  %153 = load i32, ptr %152, align 4, !tbaa !28
  %154 = inttoptr i32 %153 to ptr
  %155 = getelementptr inbounds nuw i8, ptr %154, i32 16
  store volatile i32 -1, ptr %155, align 4, !tbaa !29
  %156 = getelementptr inbounds nuw i8, ptr %154, i32 20
  store volatile i32 1, ptr %156, align 4, !tbaa !31
  %157 = getelementptr inbounds nuw i8, ptr %140, i32 24
  %158 = load i32, ptr %157, align 4, !tbaa !32
  %159 = add i32 %158, -84
  %160 = inttoptr i32 %159 to ptr
  store volatile i32 -1, ptr %160, align 4, !tbaa !6
  %161 = getelementptr inbounds nuw i8, ptr %140, i32 12
  store i32 0, ptr %161, align 4, !tbaa !19
  store i32 3, ptr %140, align 4, !tbaa !15
  br label %162

162:                                              ; preds = %151, %148
  store i32 1, ptr %145, align 4, !tbaa !27
  br label %169

163:                                              ; preds = %139
  %164 = load i32, ptr %140, align 4, !tbaa !15
  %165 = icmp eq i32 %164, 2
  br i1 %165, label %166, label %167

166:                                              ; preds = %163
  tail call fastcc void @terminate(ptr noundef nonnull %140, i32 noundef -1) #16
  br label %169

167:                                              ; preds = %163
  %168 = getelementptr inbounds nuw i8, ptr %140, i32 48
  store i32 1, ptr %168, align 4, !tbaa !33
  br label %169

169:                                              ; preds = %167, %166, %162, %144, %135
  %170 = add nuw nsw i32 %133, 1
  br label %132, !llvm.loop !34

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
  tail call fastcc void @cputc(i32 noundef 8) #16
  tail call fastcc void @cputc(i32 noundef 32) #16
  tail call fastcc void @cputc(i32 noundef 8) #16
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
  tail call fastcc void @cputc(i32 noundef 94) #16
  %195 = or disjoint i32 %173, 64
  br label %196

196:                                              ; preds = %185, %194
  %197 = phi i32 [ %195, %194 ], [ %173, %185 ]
  tail call fastcc void @cputc(i32 noundef %197) #16
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
  %213 = load i32, ptr %212, align 4, !tbaa !15
  %214 = icmp eq i32 %213, 2
  br i1 %214, label %215, label %233

215:                                              ; preds = %211
  %216 = getelementptr inbounds nuw i8, ptr %212, i32 12
  %217 = load i32, ptr %216, align 4, !tbaa !19
  %218 = icmp eq i32 %217, ptrtoint (ptr @selwait_inf to i32)
  br i1 %218, label %221, label %219

219:                                              ; preds = %215
  %220 = icmp eq i32 %217, ptrtoint (ptr @selwait_to to i32)
  br i1 %220, label %221, label %233

221:                                              ; preds = %219, %215
  %222 = getelementptr inbounds nuw i8, ptr %212, i32 44
  %223 = load i32, ptr %222, align 4, !tbaa !28
  %224 = inttoptr i32 %223 to ptr
  %225 = getelementptr inbounds nuw i8, ptr %224, i32 4
  %226 = load volatile i32, ptr %225, align 4, !tbaa !35
  %227 = getelementptr inbounds nuw i8, ptr %224, i32 16
  store volatile i32 %226, ptr %227, align 4, !tbaa !29
  %228 = getelementptr inbounds nuw i8, ptr %224, i32 20
  store volatile i32 1, ptr %228, align 4, !tbaa !31
  %229 = getelementptr inbounds nuw i8, ptr %212, i32 24
  %230 = load i32, ptr %229, align 4, !tbaa !32
  %231 = add i32 %230, -84
  %232 = inttoptr i32 %231 to ptr
  store volatile i32 %226, ptr %232, align 4, !tbaa !6
  store i32 0, ptr %216, align 4, !tbaa !19
  store i32 3, ptr %212, align 4, !tbaa !15
  br label %233

233:                                              ; preds = %221, %219, %211
  %234 = add nuw nsw i32 %209, 1
  br label %208, !llvm.loop !36

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
define dso_local range(i32 9, 8) i32 @kfind_sleeper(i32 noundef %0) local_unnamed_addr #5 {
  br label %2

2:                                                ; preds = %13, %1
  %3 = phi i32 [ 0, %1 ], [ %14, %13 ]
  %4 = icmp eq i32 %3, 8
  br i1 %4, label %15, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %3
  %7 = load i32, ptr %6, align 4, !tbaa !15
  %8 = icmp eq i32 %7, 2
  br i1 %8, label %9, label %13

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 12
  %11 = load i32, ptr %10, align 4, !tbaa !19
  %12 = icmp eq i32 %11, %0
  br i1 %12, label %15, label %13

13:                                               ; preds = %5, %9
  %14 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !37

15:                                               ; preds = %9, %2
  %16 = phi i32 [ -1, %2 ], [ %3, %9 ]
  ret i32 %16
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #6 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %4 = load i32, ptr %3, align 4, !tbaa !28
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
define dso_local void @kmail_set(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #3 {
  %4 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %5 = load i32, ptr %4, align 4, !tbaa !28
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
define dso_local void @kcomplete(i32 noundef %0, i32 noundef %1) local_unnamed_addr #3 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 44
  %5 = load i32, ptr %4, align 4, !tbaa !28
  %6 = inttoptr i32 %5 to ptr
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 16
  store volatile i32 %1, ptr %7, align 4, !tbaa !29
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store volatile i32 1, ptr %8, align 4, !tbaa !31
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 24
  %10 = load i32, ptr %9, align 4, !tbaa !32
  %11 = add i32 %10, -84
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 %1, ptr %12, align 4, !tbaa !6
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 0, ptr %13, align 4, !tbaa !19
  store i32 3, ptr %3, align 4, !tbaa !15
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kblock_self_slot() local_unnamed_addr #0 {
  %1 = load i32, ptr @curr, align 4, !tbaa !6
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #6 {
  %2 = load i32, ptr @curr, align 4, !tbaa !6
  %3 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %2
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 32
  %5 = load i32, ptr %4, align 4, !tbaa !38
  %6 = inttoptr i32 %5 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !6
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 40
  store i32 %7, ptr %8, align 4, !tbaa !39
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 %0, ptr %9, align 4, !tbaa !19
  store i32 2, ptr %3, align 4, !tbaa !15
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #1 {
  tail call fastcc void @kenter() #16
  tail call fastcc void @fire_income() #16
  %1 = load i32, ptr @waspark, align 4, !tbaa !6
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %17

3:                                                ; preds = %0
  %4 = load i32, ptr @curr, align 4, !tbaa !6
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !33
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %16

9:                                                ; preds = %3
  %10 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !40
  %11 = load i32, ptr %10, align 4, !tbaa !6
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %11, ptr %12, align 4, !tbaa !39
  %13 = load i32, ptr %5, align 4, !tbaa !15
  %14 = icmp eq i32 %13, 4
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  store i32 3, ptr %5, align 4, !tbaa !15
  br label %17

16:                                               ; preds = %3
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #16
  br label %17

17:                                               ; preds = %0, %9, %15, %16
  tail call fastcc void @swtch() #16
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kenter() unnamed_addr #1 {
  store i1 false, ptr @rearm, align 4
  store i1 false, ptr @tick_taken, align 4
  tail call void @kcons_aim(i32 noundef 0) #17
  %1 = load i32, ptr @fsready, align 4, !tbaa !6
  %2 = icmp eq i32 %1, 0
  %3 = load i32, ptr @dma_disk, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %2, i1 %4, i1 false
  br i1 %5, label %6, label %7

6:                                                ; preds = %0
  tail call fastcc void @kboot_init() #16
  br label %7

7:                                                ; preds = %6, %0
  %8 = load i1, ptr @parked, align 4
  %9 = zext i1 %8 to i32
  store i32 %9, ptr @waspark, align 4, !tbaa !6
  br i1 %8, label %10, label %11

10:                                               ; preds = %7
  store i1 false, ptr @parked, align 4
  store i32 0, ptr @entry_disp, align 4, !tbaa !6
  br label %22

11:                                               ; preds = %7
  %12 = load i32, ptr @curr, align 4, !tbaa !6
  %13 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %12
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 24
  %15 = load i32, ptr %14, align 4, !tbaa !32
  store i32 %15, ptr @entry_disp, align 4, !tbaa !6
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 36
  %17 = load i32, ptr %16, align 4, !tbaa !43
  store i32 %17, ptr @entry_thunk, align 4, !tbaa !6
  %18 = inttoptr i32 %15 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !6
  %20 = icmp eq i32 %19, %17
  br i1 %20, label %22, label %21

21:                                               ; preds = %11
  store volatile i32 %17, ptr %18, align 4, !tbaa !6
  tail call fastcc void @fire_income() #16
  br label %22

22:                                               ; preds = %11, %21, %10
  %23 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %24 = inttoptr i32 %23 to ptr
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr %24, align 4, !tbaa !6
  %25 = load i32, ptr @tickpending, align 4, !tbaa !6
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %28, label %27

27:                                               ; preds = %22
  store i32 0, ptr @tickpending, align 4, !tbaa !6
  tail call fastcc void @fire_income() #16
  br label %28

28:                                               ; preds = %27, %22
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fire_income() unnamed_addr #1 {
  %1 = tail call i32 @kcons_on() #17
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call fastcc void @tick_income() #16
  br label %20

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
  tail call fastcc void @tick_income() #16
  br label %13

13:                                               ; preds = %12, %10, %4
  %14 = load i32, ptr @fgpid, align 4, !tbaa !6
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %20, label %16

16:                                               ; preds = %13
  %17 = tail call i32 @kcons_pending() #17
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %20, label %19

19:                                               ; preds = %16
  tail call fastcc void @cons_poll() #16
  br label %20

20:                                               ; preds = %3, %19, %16, %13
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
  %10 = load i32, ptr %9, align 4, !tbaa !17
  %11 = icmp eq i32 %8, %10
  br i1 %11, label %12, label %13

12:                                               ; preds = %7
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !6
  br label %13

13:                                               ; preds = %12, %7, %2
  %14 = tail call i32 @kfb_owner() #17
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !17
  %17 = icmp eq i32 %14, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %13
  tail call void @kfb_setowner(i32 noundef 0) #17
  tail call void @kfbcon_reset() #17
  br label %19

19:                                               ; preds = %18, %13
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %20, align 4, !tbaa !44
  %21 = load i32, ptr @fsready, align 4, !tbaa !6
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %24, label %23

23:                                               ; preds = %19
  tail call void @kfs_exit(i32 noundef %5) #17
  br label %24

24:                                               ; preds = %23, %19
  tail call fastcc void @kfree_exec(i32 noundef %5) #16
  tail call fastcc void @vfork_release(ptr noundef nonnull %0) #16
  %25 = load i32, ptr @initpid, align 4, !tbaa !6
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %46, label %27

27:                                               ; preds = %24, %44
  %28 = phi i32 [ %45, %44 ], [ 0, %24 ]
  %29 = icmp eq i32 %28, 8
  br i1 %29, label %46, label %30

30:                                               ; preds = %27
  %31 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %28
  %32 = load i32, ptr %31, align 4, !tbaa !15
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %44, label %34

34:                                               ; preds = %30
  %35 = icmp eq ptr %31, %0
  br i1 %35, label %44, label %36

36:                                               ; preds = %34
  %37 = getelementptr inbounds nuw i8, ptr %31, i32 8
  %38 = load i32, ptr %37, align 4, !tbaa !20
  %39 = load i32, ptr %15, align 4, !tbaa !17
  %40 = icmp eq i32 %38, %39
  br i1 %40, label %41, label %44

41:                                               ; preds = %36
  store i32 %25, ptr %37, align 4, !tbaa !20
  %42 = icmp eq i32 %32, 5
  br i1 %42, label %43, label %44

43:                                               ; preds = %41
  store i32 0, ptr %31, align 4, !tbaa !15
  br label %44

44:                                               ; preds = %41, %43, %36, %34, %30
  %45 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !45

46:                                               ; preds = %27, %24
  %47 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %48 = load i32, ptr %47, align 4, !tbaa !20
  br label %49

49:                                               ; preds = %79, %46
  %50 = phi i32 [ 0, %46 ], [ %80, %79 ]
  %51 = icmp eq i32 %50, 8
  br i1 %51, label %90, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %50
  %54 = getelementptr inbounds nuw i8, ptr %53, i32 4
  %55 = load i32, ptr %54, align 4, !tbaa !17
  %56 = icmp eq i32 %55, %48
  br i1 %56, label %57, label %79

57:                                               ; preds = %52
  %58 = load i32, ptr %53, align 4, !tbaa !15
  %59 = icmp eq i32 %58, 2
  br i1 %59, label %60, label %79

60:                                               ; preds = %57
  %61 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %62 = load i32, ptr %61, align 4, !tbaa !19
  %63 = ptrtoint ptr %53 to i32
  %64 = icmp eq i32 %62, %63
  br i1 %64, label %65, label %79

65:                                               ; preds = %60
  %66 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %67 = getelementptr inbounds nuw i8, ptr %53, i32 44
  %68 = load i32, ptr %67, align 4, !tbaa !28
  %69 = inttoptr i32 %68 to ptr
  %70 = getelementptr inbounds nuw i8, ptr %69, i32 4
  %71 = load volatile i32, ptr %70, align 4, !tbaa !35
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %81, label %73

73:                                               ; preds = %65
  %74 = load i32, ptr %20, align 4, !tbaa !44
  %75 = load volatile i32, ptr %70, align 4, !tbaa !35
  %76 = inttoptr i32 %75 to ptr
  store volatile i32 %74, ptr %76, align 4, !tbaa !6
  %77 = load i32, ptr %67, align 4, !tbaa !28
  %78 = inttoptr i32 %77 to ptr
  br label %81

79:                                               ; preds = %60, %57, %52
  %80 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !46

81:                                               ; preds = %73, %65
  %82 = phi ptr [ %78, %73 ], [ %69, %65 ]
  %83 = load i32, ptr %15, align 4, !tbaa !17
  %84 = getelementptr inbounds nuw i8, ptr %82, i32 16
  store volatile i32 %83, ptr %84, align 4, !tbaa !29
  %85 = getelementptr inbounds nuw i8, ptr %82, i32 20
  store volatile i32 1, ptr %85, align 4, !tbaa !31
  %86 = getelementptr inbounds nuw i8, ptr %53, i32 24
  %87 = load i32, ptr %86, align 4, !tbaa !32
  %88 = add i32 %87, -84
  %89 = inttoptr i32 %88 to ptr
  store volatile i32 %83, ptr %89, align 4, !tbaa !6
  store i32 0, ptr %66, align 4, !tbaa !19
  store i32 3, ptr %53, align 4, !tbaa !15
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
  store i32 %95, ptr %0, align 4, !tbaa !15
  %96 = getelementptr inbounds nuw i8, ptr %0, i32 48
  store i32 0, ptr %96, align 4, !tbaa !33
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
  %9 = load i32, ptr %8, align 4, !tbaa !15
  %10 = icmp eq i32 %9, 3
  %11 = add nuw nsw i32 %3, 1
  br i1 %10, label %62, label %2, !llvm.loop !47

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
  tail call fastcc void @fire_income() #16
  br label %21

21:                                               ; preds = %20, %15, %12
  %22 = load volatile ptr, ptr @kw_park, align 4, !tbaa !40
  %23 = ptrtoint ptr %22 to i32
  %24 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  store i32 %23, ptr %24, align 4, !tbaa !6
  %25 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %26 = ptrtoint ptr %25 to i32
  %27 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !40
  store i32 %26, ptr %27, align 4, !tbaa !6
  %28 = load volatile ptr, ptr @kw_park, align 4, !tbaa !40
  %29 = ptrtoint ptr %28 to i32
  %30 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !40
  store i32 %29, ptr %30, align 4, !tbaa !6
  %31 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %32 = ptrtoint ptr %31 to i32
  %33 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !40
  store i32 %32, ptr %33, align 4, !tbaa !6
  %34 = load volatile ptr, ptr @kw_park, align 4, !tbaa !40
  %35 = ptrtoint ptr %34 to i32
  %36 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !40
  store i32 %35, ptr %36, align 4, !tbaa !6
  %37 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
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
  tail call fastcc void @fire_income() #16
  br label %44

44:                                               ; preds = %43, %21
  %45 = tail call i32 @kcons_on() #17
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %57, label %47

47:                                               ; preds = %44
  %48 = load i32, ptr @fgpid, align 4, !tbaa !6
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %54, label %50

50:                                               ; preds = %47
  %51 = tail call i32 @kcons_pending() #17
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %54, label %53

53:                                               ; preds = %50
  tail call fastcc void @cons_poll() #16
  br label %54

54:                                               ; preds = %53, %50, %47
  tail call void @kcons_kick() #17
  %55 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %56 = ptrtoint ptr %55 to i32
  tail call void @kcons_aim(i32 noundef %56) #17
  br label %57

57:                                               ; preds = %54, %44
  %58 = load i1, ptr @rearm, align 4
  br i1 %58, label %59, label %65

59:                                               ; preds = %57
  %60 = load i32, ptr @inj_treg, align 4, !tbaa !6
  %61 = inttoptr i32 %60 to ptr
  store volatile i32 1, ptr %61, align 4, !tbaa !6
  br label %65

62:                                               ; preds = %5
  %63 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %64 = load i32, ptr %63, align 4, !tbaa !39
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %64) #16
  br label %65

65:                                               ; preds = %57, %59, %62
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #1 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %struct.kimg, align 4
  %4 = alloca [13 x i32], align 4
  %5 = alloca [64 x i32], align 4
  tail call fastcc void @kenter() #16
  %6 = load i32, ptr @curr, align 4, !tbaa !6
  %7 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %6
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 48
  %9 = load i32, ptr %8, align 4, !tbaa !33
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %12, label %11

11:                                               ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %7, i32 noundef -1) #16
  tail call fastcc void @swtch() #16
  br label %1109

12:                                               ; preds = %0
  %13 = getelementptr inbounds nuw i8, ptr %7, i32 44
  %14 = load i32, ptr %13, align 4, !tbaa !28
  %15 = inttoptr i32 %14 to ptr
  %16 = load volatile i32, ptr %15, align 4, !tbaa !48
  switch i32 %16, label %1079 [
    i32 11, label %21
    i32 14, label %24
    i32 16, label %29
    i32 15, label %54
    i32 21, label %63
    i32 10, label %70
    i32 8, label %77
    i32 33, label %86
    i32 4, label %95
    i32 9, label %102
    i32 20, label %109
    i32 19, label %116
    i32 18, label %125
    i32 22, label %132
    i32 5, label %139
    i32 12, label %163
    i32 13, label %298
    i32 34, label %313
    i32 3, label %19
    i32 1, label %422
    i32 7, label %454
    i32 2, label %803
    i32 26, label %806
    i32 27, label %815
    i32 25, label %822
    i32 35, label %910
    i32 28, label %953
    i32 29, label %962
    i32 30, label %970
    i32 31, label %976
    i32 32, label %1003
    i32 23, label %1028
    i32 24, label %1033
    i32 6, label %17
  ]

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %1055

19:                                               ; preds = %12
  %20 = getelementptr inbounds nuw i8, ptr %7, i32 4
  br label %374

21:                                               ; preds = %12
  %22 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %23 = load i32, ptr %22, align 4, !tbaa !17
  br label %1079

24:                                               ; preds = %12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #15
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #15
  %25 = load i32, ptr @wall0_hi, align 4, !tbaa !6
  %26 = load i32, ptr @wall0_lo, align 4, !tbaa !6
  call fastcc void @wall_since(i32 noundef %25, i32 noundef %26, ptr noundef %1, ptr noundef %2) #16
  %27 = call fastcc i32 @us_div(ptr noundef %1, ptr noundef %2, i32 noundef 100) #16
  %28 = load i32, ptr %2, align 4, !tbaa !6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #15
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #15
  br label %1079

29:                                               ; preds = %12
  %30 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %31 = load volatile i32, ptr %30, align 4, !tbaa !49
  %32 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %33 = load volatile i32, ptr %32, align 4, !tbaa !50
  %34 = tail call fastcc i32 @badbuf(ptr noundef nonnull %7, i32 noundef %31, i32 noundef %33) #16
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %1079

36:                                               ; preds = %29
  %37 = load i32, ptr @fsready, align 4, !tbaa !6
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %45, label %39

39:                                               ; preds = %36
  %40 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %41 = load volatile i32, ptr %40, align 4, !tbaa !35
  %42 = load volatile i32, ptr %30, align 4, !tbaa !49
  %43 = load volatile i32, ptr %32, align 4, !tbaa !50
  %44 = tail call i32 @kfs_write(i32 noundef %41, i32 noundef %42, i32 noundef %43) #17
  br label %50

45:                                               ; preds = %36
  %46 = load volatile i32, ptr %30, align 4, !tbaa !49
  %47 = inttoptr i32 %46 to ptr
  %48 = load volatile i32, ptr %32, align 4, !tbaa !50
  tail call void @kconswrite(ptr noundef %47, i32 noundef %48) #16
  %49 = load volatile i32, ptr %32, align 4, !tbaa !50
  br label %50

50:                                               ; preds = %39, %45
  %51 = phi i32 [ %44, %39 ], [ %49, %45 ]
  %52 = freeze i32 %51
  %53 = icmp eq i32 %52, -3
  br i1 %53, label %1094, label %1079

54:                                               ; preds = %12
  %55 = load i32, ptr @fsready, align 4, !tbaa !6
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %1079, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !35
  %60 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %61 = load volatile i32, ptr %60, align 4, !tbaa !49
  %62 = tail call i32 @kfs_open(i32 noundef %59, i32 noundef %61) #17
  br label %1079

63:                                               ; preds = %12
  %64 = load i32, ptr @fsready, align 4, !tbaa !6
  %65 = icmp eq i32 %64, 0
  br i1 %65, label %1079, label %66

66:                                               ; preds = %63
  %67 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %68 = load volatile i32, ptr %67, align 4, !tbaa !35
  %69 = tail call i32 @kfs_close(i32 noundef %68) #17
  br label %1079

70:                                               ; preds = %12
  %71 = load i32, ptr @fsready, align 4, !tbaa !6
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %1079, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %75 = load volatile i32, ptr %74, align 4, !tbaa !35
  %76 = tail call i32 @kfs_dup(i32 noundef %75) #17
  br label %1079

77:                                               ; preds = %12
  %78 = load i32, ptr @fsready, align 4, !tbaa !6
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %1079, label %80

80:                                               ; preds = %77
  %81 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %82 = load volatile i32, ptr %81, align 4, !tbaa !35
  %83 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %84 = load volatile i32, ptr %83, align 4, !tbaa !49
  %85 = tail call i32 @kfs_fstat(i32 noundef %82, i32 noundef %84) #17
  br label %1079

86:                                               ; preds = %12
  %87 = load i32, ptr @fsready, align 4, !tbaa !6
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %1079, label %89

89:                                               ; preds = %86
  %90 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %91 = load volatile i32, ptr %90, align 4, !tbaa !35
  %92 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %93 = load volatile i32, ptr %92, align 4, !tbaa !49
  %94 = tail call i32 @kfs_seek(i32 noundef %91, i32 noundef %93) #17
  br label %1079

95:                                               ; preds = %12
  %96 = load i32, ptr @fsready, align 4, !tbaa !6
  %97 = icmp eq i32 %96, 0
  br i1 %97, label %1079, label %98

98:                                               ; preds = %95
  %99 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %100 = load volatile i32, ptr %99, align 4, !tbaa !35
  %101 = tail call i32 @kfs_pipe(i32 noundef %100) #17
  br label %1079

102:                                              ; preds = %12
  %103 = load i32, ptr @fsready, align 4, !tbaa !6
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %1079, label %105

105:                                              ; preds = %102
  %106 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %107 = load volatile i32, ptr %106, align 4, !tbaa !35
  %108 = tail call i32 @kfs_chdir(i32 noundef %107) #17
  br label %1079

109:                                              ; preds = %12
  %110 = load i32, ptr @fsready, align 4, !tbaa !6
  %111 = icmp eq i32 %110, 0
  br i1 %111, label %1079, label %112

112:                                              ; preds = %109
  %113 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %114 = load volatile i32, ptr %113, align 4, !tbaa !35
  %115 = tail call i32 @kfs_mkdir(i32 noundef %114) #17
  br label %1079

116:                                              ; preds = %12
  %117 = load i32, ptr @fsready, align 4, !tbaa !6
  %118 = icmp eq i32 %117, 0
  br i1 %118, label %1079, label %119

119:                                              ; preds = %116
  %120 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %121 = load volatile i32, ptr %120, align 4, !tbaa !35
  %122 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %123 = load volatile i32, ptr %122, align 4, !tbaa !49
  %124 = tail call i32 @kfs_link(i32 noundef %121, i32 noundef %123) #17
  br label %1079

125:                                              ; preds = %12
  %126 = load i32, ptr @fsready, align 4, !tbaa !6
  %127 = icmp eq i32 %126, 0
  br i1 %127, label %1079, label %128

128:                                              ; preds = %125
  %129 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %130 = load volatile i32, ptr %129, align 4, !tbaa !35
  %131 = tail call i32 @kfs_unlink(i32 noundef %130) #17
  br label %1079

132:                                              ; preds = %12
  tail call void @kfb_pause() #17
  %133 = load i32, ptr @fsready, align 4, !tbaa !6
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %137, label %135

135:                                              ; preds = %132
  %136 = tail call i32 @kflash_sync() #17
  br label %137

137:                                              ; preds = %132, %135
  %138 = phi i32 [ %136, %135 ], [ -1, %132 ]
  tail call void @kfb_resume() #17
  br label %1079

139:                                              ; preds = %12
  %140 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %141 = load volatile i32, ptr %140, align 4, !tbaa !49
  %142 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %143 = load volatile i32, ptr %142, align 4, !tbaa !50
  %144 = tail call fastcc i32 @badbuf(ptr noundef nonnull %7, i32 noundef %141, i32 noundef %143) #16
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %146, label %1079

146:                                              ; preds = %139
  %147 = load i32, ptr @fsready, align 4, !tbaa !6
  %148 = icmp eq i32 %147, 0
  br i1 %148, label %155, label %149

149:                                              ; preds = %146
  %150 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %151 = load volatile i32, ptr %150, align 4, !tbaa !35
  %152 = load volatile i32, ptr %140, align 4, !tbaa !49
  %153 = load volatile i32, ptr %142, align 4, !tbaa !50
  %154 = tail call i32 @kfs_read(i32 noundef %151, i32 noundef %152, i32 noundef %153) #17
  br label %159

155:                                              ; preds = %146
  %156 = load volatile i32, ptr %140, align 4, !tbaa !49
  %157 = load volatile i32, ptr %142, align 4, !tbaa !50
  %158 = tail call i32 @kconsread(i32 noundef %156, i32 noundef %157) #16
  br label %159

159:                                              ; preds = %149, %155
  %160 = phi i32 [ %154, %149 ], [ %158, %155 ]
  %161 = freeze i32 %160
  %162 = icmp eq i32 %161, -3
  br i1 %162, label %1094, label %1079

163:                                              ; preds = %12
  %164 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %165 = load volatile i32, ptr %164, align 4, !tbaa !35
  %166 = getelementptr inbounds nuw i8, ptr %7, i32 52
  %167 = load i32, ptr %166, align 4, !tbaa !51
  %168 = icmp eq i32 %167, 0
  br i1 %168, label %172, label %169

169:                                              ; preds = %163
  %170 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %171 = load i32, ptr %170, align 4, !tbaa !52
  br label %235

172:                                              ; preds = %163
  %173 = icmp slt i32 %165, 0
  br i1 %173, label %1079, label %174

174:                                              ; preds = %172
  %175 = add nuw i32 %165, 255
  %176 = and i32 %175, -256
  %177 = icmp samesign ult i32 %165, 16129
  %178 = select i1 %177, i32 16384, i32 %176
  br label %179

179:                                              ; preds = %225, %174
  %180 = phi i32 [ %227, %225 ], [ %178, %174 ]
  %181 = load i1, ptr @kheap_init, align 4
  br i1 %181, label %188, label %182

182:                                              ; preds = %179
  store i1 true, ptr @kheap_init, align 4
  %183 = load i32, ptr @arena, align 4, !tbaa !6
  %184 = inttoptr i32 %183 to ptr
  store ptr %184, ptr @kfreelist, align 4, !tbaa !53
  %185 = load i32, ptr @arena_end, align 4, !tbaa !6
  %186 = sub i32 %185, %183
  store i32 %186, ptr %184, align 4, !tbaa !55
  %187 = getelementptr inbounds nuw i8, ptr %184, i32 4
  store ptr null, ptr %187, align 4, !tbaa !57
  br label %188

188:                                              ; preds = %182, %179
  %189 = add nuw i32 %180, 255
  %190 = and i32 %189, -256
  %191 = add nuw i32 %190, 256
  br label %192

192:                                              ; preds = %199, %188
  %193 = phi ptr [ @kfreelist, %188 ], [ %203, %199 ]
  %194 = phi ptr [ null, %188 ], [ %202, %199 ]
  %195 = load ptr, ptr %193, align 4, !tbaa !53
  %196 = icmp eq ptr %195, null
  br i1 %196, label %197, label %199

197:                                              ; preds = %192
  %198 = icmp eq ptr %194, null
  br i1 %198, label %220, label %204

199:                                              ; preds = %192
  %200 = load i32, ptr %195, align 4, !tbaa !55
  %201 = icmp ult i32 %200, %191
  %202 = select i1 %201, ptr %194, ptr %193
  %203 = getelementptr inbounds nuw i8, ptr %195, i32 4
  br label %192, !llvm.loop !58

204:                                              ; preds = %197
  %205 = load ptr, ptr %194, align 4, !tbaa !53
  %206 = load i32, ptr %205, align 4, !tbaa !55
  %207 = sub i32 %206, %191
  %208 = icmp ugt i32 %207, 511
  br i1 %208, label %209, label %213

209:                                              ; preds = %204
  store i32 %207, ptr %205, align 4, !tbaa !55
  %210 = ptrtoint ptr %205 to i32
  %211 = add i32 %207, %210
  %212 = inttoptr i32 %211 to ptr
  store i32 %191, ptr %212, align 4, !tbaa !55
  br label %217

213:                                              ; preds = %204
  %214 = getelementptr inbounds nuw i8, ptr %205, i32 4
  %215 = load ptr, ptr %214, align 4, !tbaa !57
  store ptr %215, ptr %194, align 4, !tbaa !53
  %216 = ptrtoint ptr %205 to i32
  br label %217

217:                                              ; preds = %213, %209
  %218 = phi i32 [ %211, %209 ], [ %216, %213 ]
  %219 = add i32 %218, 256
  br label %220

220:                                              ; preds = %197, %217
  %221 = phi i32 [ %219, %217 ], [ 0, %197 ]
  %222 = icmp eq i32 %221, 0
  %223 = icmp ugt i32 %180, %176
  %224 = select i1 %222, i1 %223, i1 false
  br i1 %224, label %225, label %228

225:                                              ; preds = %220
  %226 = lshr i32 %180, 1
  %227 = tail call i32 @llvm.umax.i32(i32 %226, i32 %176)
  br label %179, !llvm.loop !59

228:                                              ; preds = %220
  br i1 %222, label %1079, label %229

229:                                              ; preds = %228
  %230 = load i32, ptr @curr, align 4, !tbaa !6
  %231 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %230
  store i32 %221, ptr %231, align 4, !tbaa !6
  %232 = getelementptr inbounds nuw i8, ptr %7, i32 60
  store i32 %221, ptr %232, align 4, !tbaa !52
  store i32 %221, ptr %166, align 4, !tbaa !51
  %233 = add i32 %221, %180
  %234 = getelementptr inbounds nuw i8, ptr %7, i32 56
  store i32 %233, ptr %234, align 4, !tbaa !60
  br label %235

235:                                              ; preds = %229, %169
  %236 = phi i32 [ %167, %169 ], [ %221, %229 ]
  %237 = phi i32 [ %171, %169 ], [ %221, %229 ]
  %238 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %239 = icmp sgt i32 %165, -1
  br i1 %239, label %240, label %255

240:                                              ; preds = %235
  %241 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %242 = load i32, ptr %241, align 4, !tbaa !60
  %243 = sub i32 %242, %237
  %244 = icmp ugt i32 %165, %243
  br i1 %244, label %1079, label %245

245:                                              ; preds = %240
  %246 = add i32 %237, %165
  br label %247

247:                                              ; preds = %252, %245
  %248 = phi i32 [ %254, %252 ], [ %237, %245 ]
  %249 = icmp ult i32 %248, %246
  br i1 %249, label %252, label %250

250:                                              ; preds = %247
  %251 = load i32, ptr %238, align 4, !tbaa !52
  br label %259

252:                                              ; preds = %247
  %253 = inttoptr i32 %248 to ptr
  store volatile i8 0, ptr %253, align 1, !tbaa !3
  %254 = add nuw i32 %248, 1
  br label %247, !llvm.loop !61

255:                                              ; preds = %235
  %256 = sub nsw i32 0, %165
  %257 = sub i32 %237, %236
  %258 = icmp ult i32 %257, %256
  br i1 %258, label %1079, label %259

259:                                              ; preds = %255, %250
  %260 = phi i32 [ %251, %250 ], [ %237, %255 ]
  %261 = add i32 %260, %165
  store i32 %261, ptr %238, align 4, !tbaa !52
  %262 = getelementptr inbounds nuw i8, ptr %7, i32 56
  br label %263

263:                                              ; preds = %297, %259
  %264 = phi ptr [ %7, %259 ], [ %272, %297 ]
  %265 = ptrtoint ptr %264 to i32
  %266 = sub i32 %265, ptrtoint (ptr @proc to i32)
  %267 = sdiv exact i32 %266, 72
  br label %268

268:                                              ; preds = %279, %263
  %269 = phi i32 [ 0, %263 ], [ %280, %279 ]
  %270 = icmp eq i32 %269, 8
  br i1 %270, label %1079, label %271

271:                                              ; preds = %268
  %272 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %269
  %273 = load i32, ptr %272, align 4, !tbaa !15
  %274 = icmp eq i32 %273, 2
  br i1 %274, label %275, label %279

275:                                              ; preds = %271
  %276 = getelementptr inbounds nuw i8, ptr %272, i32 12
  %277 = load i32, ptr %276, align 4, !tbaa !19
  %278 = icmp eq i32 %277, %265
  br i1 %278, label %281, label %279

279:                                              ; preds = %275, %271
  %280 = add nuw nsw i32 %269, 1
  br label %268, !llvm.loop !62

281:                                              ; preds = %275
  %282 = getelementptr inbounds nuw i8, ptr %272, i32 52
  %283 = load i32, ptr %282, align 4, !tbaa !51
  %284 = load i32, ptr %166, align 4, !tbaa !51
  %285 = icmp eq i32 %283, %284
  br i1 %285, label %291, label %286

286:                                              ; preds = %281
  store i32 %284, ptr %282, align 4, !tbaa !51
  %287 = load i32, ptr %262, align 4, !tbaa !60
  %288 = getelementptr inbounds nuw i8, ptr %272, i32 56
  store i32 %287, ptr %288, align 4, !tbaa !60
  %289 = load i32, ptr %166, align 4, !tbaa !51
  %290 = getelementptr inbounds nuw i8, ptr %272, i32 60
  store i32 %289, ptr %290, align 4, !tbaa !52
  br label %291

291:                                              ; preds = %286, %281
  %292 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %267
  %293 = load i32, ptr %292, align 4, !tbaa !6
  %294 = icmp eq i32 %293, 0
  br i1 %294, label %297, label %295

295:                                              ; preds = %291
  %296 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %269
  store i32 %293, ptr %296, align 4, !tbaa !6
  store i32 0, ptr %292, align 4, !tbaa !6
  br label %297

297:                                              ; preds = %295, %291
  br label %263, !llvm.loop !63

298:                                              ; preds = %12
  %299 = load i32, ptr @ntimed, align 4, !tbaa !6
  %300 = add i32 %299, 1
  store i32 %300, ptr @ntimed, align 4, !tbaa !6
  %301 = load volatile i32, ptr @__dma_timerawl, align 4, !tbaa !6
  %302 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %303 = load volatile i32, ptr %302, align 4, !tbaa !35
  %304 = mul i32 %303, 100
  %305 = add i32 %304, %301
  %306 = getelementptr inbounds nuw i8, ptr %7, i32 16
  store i32 %305, ptr %306, align 4, !tbaa !64
  %307 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %308 = load i32, ptr %307, align 4, !tbaa !38
  %309 = inttoptr i32 %308 to ptr
  %310 = load volatile i32, ptr %309, align 4, !tbaa !6
  %311 = getelementptr inbounds nuw i8, ptr %7, i32 40
  store i32 %310, ptr %311, align 4, !tbaa !39
  %312 = getelementptr inbounds nuw i8, ptr %7, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %312, align 4, !tbaa !19
  store i32 2, ptr %7, align 4, !tbaa !15
  br label %1098

313:                                              ; preds = %12
  %314 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %315 = load volatile i32, ptr %314, align 4, !tbaa !35
  br label %316

316:                                              ; preds = %340, %313
  %317 = phi i32 [ 0, %313 ], [ %342, %340 ]
  %318 = phi i32 [ 0, %313 ], [ %341, %340 ]
  %319 = icmp eq i32 %317, 31
  br i1 %319, label %320, label %322

320:                                              ; preds = %316
  %321 = icmp eq i32 %318, 0
  br i1 %321, label %343, label %1079

322:                                              ; preds = %316
  %323 = shl nuw nsw i32 1, %317
  %324 = and i32 %323, %315
  %325 = icmp eq i32 %324, 0
  br i1 %325, label %340, label %326

326:                                              ; preds = %322
  %327 = load i32, ptr @fsready, align 4, !tbaa !6
  %328 = icmp eq i32 %327, 0
  br i1 %328, label %332, label %329

329:                                              ; preds = %326
  %330 = tail call i32 @kfs_selready(i32 noundef %317) #17
  %331 = icmp eq i32 %330, 0
  br label %336

332:                                              ; preds = %326
  %333 = load i32, ptr @cons_r, align 4, !tbaa !6
  %334 = load i32, ptr @cons_w, align 4, !tbaa !6
  %335 = icmp eq i32 %333, %334
  br label %336

336:                                              ; preds = %332, %329
  %337 = phi i1 [ %331, %329 ], [ %335, %332 ]
  %338 = select i1 %337, i32 0, i32 %323
  %339 = or i32 %338, %318
  br label %340

340:                                              ; preds = %322, %336
  %341 = phi i32 [ %339, %336 ], [ %318, %322 ]
  %342 = add nuw nsw i32 %317, 1
  br label %316, !llvm.loop !65

343:                                              ; preds = %320
  %344 = icmp eq i32 %315, 0
  br i1 %344, label %1079, label %345

345:                                              ; preds = %343
  %346 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %347 = load volatile i32, ptr %346, align 4, !tbaa !49
  %348 = icmp eq i32 %347, 0
  br i1 %348, label %365, label %349

349:                                              ; preds = %345
  %350 = load i32, ptr @ntimed, align 4, !tbaa !6
  %351 = add i32 %350, 1
  store i32 %351, ptr @ntimed, align 4, !tbaa !6
  %352 = load volatile i32, ptr @__dma_timerawl, align 4, !tbaa !6
  %353 = load volatile i32, ptr %346, align 4, !tbaa !49
  %354 = mul i32 %353, 100
  %355 = add i32 %354, %352
  %356 = getelementptr inbounds nuw i8, ptr %7, i32 16
  store i32 %355, ptr %356, align 4, !tbaa !64
  %357 = load i32, ptr @curr, align 4, !tbaa !6
  %358 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %357
  %359 = getelementptr inbounds nuw i8, ptr %358, i32 32
  %360 = load i32, ptr %359, align 4, !tbaa !38
  %361 = inttoptr i32 %360 to ptr
  %362 = load volatile i32, ptr %361, align 4, !tbaa !6
  %363 = getelementptr inbounds nuw i8, ptr %358, i32 40
  store i32 %362, ptr %363, align 4, !tbaa !39
  %364 = getelementptr inbounds nuw i8, ptr %358, i32 12
  store i32 ptrtoint (ptr @selwait_to to i32), ptr %364, align 4, !tbaa !19
  store i32 2, ptr %358, align 4, !tbaa !15
  br label %1094

365:                                              ; preds = %345
  %366 = load i32, ptr @curr, align 4, !tbaa !6
  %367 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %366
  %368 = getelementptr inbounds nuw i8, ptr %367, i32 32
  %369 = load i32, ptr %368, align 4, !tbaa !38
  %370 = inttoptr i32 %369 to ptr
  %371 = load volatile i32, ptr %370, align 4, !tbaa !6
  %372 = getelementptr inbounds nuw i8, ptr %367, i32 40
  store i32 %371, ptr %372, align 4, !tbaa !39
  %373 = getelementptr inbounds nuw i8, ptr %367, i32 12
  store i32 ptrtoint (ptr @selwait_inf to i32), ptr %373, align 4, !tbaa !19
  store i32 2, ptr %367, align 4, !tbaa !15
  br label %1094

374:                                              ; preds = %19, %393
  %375 = phi i32 [ %396, %393 ], [ 0, %19 ]
  %376 = phi i32 [ %394, %393 ], [ -1, %19 ]
  %377 = phi i32 [ %395, %393 ], [ 0, %19 ]
  %378 = icmp eq i32 %375, 8
  br i1 %378, label %379, label %381

379:                                              ; preds = %374
  %380 = icmp sgt i32 %376, -1
  br i1 %380, label %397, label %410

381:                                              ; preds = %374
  %382 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %375
  %383 = load i32, ptr %382, align 4, !tbaa !15
  %384 = icmp eq i32 %383, 0
  br i1 %384, label %393, label %385

385:                                              ; preds = %381
  %386 = getelementptr inbounds nuw i8, ptr %382, i32 8
  %387 = load i32, ptr %386, align 4, !tbaa !20
  %388 = load i32, ptr %20, align 4, !tbaa !17
  %389 = icmp eq i32 %387, %388
  br i1 %389, label %390, label %393

390:                                              ; preds = %385
  %391 = icmp eq i32 %383, 5
  %392 = select i1 %391, i32 %375, i32 %376
  br label %393

393:                                              ; preds = %390, %381, %385
  %394 = phi i32 [ %376, %385 ], [ %376, %381 ], [ %392, %390 ]
  %395 = phi i32 [ %377, %385 ], [ %377, %381 ], [ 1, %390 ]
  %396 = add nuw nsw i32 %375, 1
  br label %374, !llvm.loop !66

397:                                              ; preds = %379
  %398 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %399 = load volatile i32, ptr %398, align 4, !tbaa !35
  %400 = icmp eq i32 %399, 0
  br i1 %400, label %406, label %401

401:                                              ; preds = %397
  %402 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %376, i32 5
  %403 = load i32, ptr %402, align 4, !tbaa !44
  %404 = load volatile i32, ptr %398, align 4, !tbaa !35
  %405 = inttoptr i32 %404 to ptr
  store volatile i32 %403, ptr %405, align 4, !tbaa !6
  br label %406

406:                                              ; preds = %401, %397
  %407 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %376
  %408 = getelementptr inbounds nuw i8, ptr %407, i32 4
  %409 = load i32, ptr %408, align 4, !tbaa !17
  store i32 0, ptr %407, align 4, !tbaa !15
  br label %1079

410:                                              ; preds = %379
  %411 = icmp eq i32 %377, 0
  br i1 %411, label %1079, label %412

412:                                              ; preds = %410
  %413 = ptrtoint ptr %7 to i32
  %414 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %415 = load i32, ptr %414, align 4, !tbaa !38
  %416 = inttoptr i32 %415 to ptr
  %417 = load volatile i32, ptr %416, align 4, !tbaa !6
  %418 = getelementptr inbounds nuw i8, ptr %7, i32 40
  store i32 %417, ptr %418, align 4, !tbaa !39
  %419 = getelementptr inbounds nuw i8, ptr %7, i32 12
  store i32 %413, ptr %419, align 4, !tbaa !19
  store i32 2, ptr %7, align 4, !tbaa !15
  %420 = getelementptr inbounds nuw i8, ptr %15, i32 16
  %421 = load volatile i32, ptr %420, align 4, !tbaa !29
  br label %1098

422:                                              ; preds = %12, %429
  %423 = phi i32 [ %430, %429 ], [ 0, %12 ]
  %424 = icmp eq i32 %423, 8
  br i1 %424, label %1079, label %425

425:                                              ; preds = %422
  %426 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %423
  %427 = load i32, ptr %426, align 4, !tbaa !15
  %428 = icmp eq i32 %427, 0
  br i1 %428, label %431, label %429

429:                                              ; preds = %425
  %430 = add nuw nsw i32 %423, 1
  br label %422, !llvm.loop !67

431:                                              ; preds = %425
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %426, ptr noundef nonnull align 4 dereferenceable(72) %7, i32 72, i1 false), !tbaa.struct !68
  %432 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %423
  %433 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %6
  tail call fastcc void @namecpy(ptr noundef nonnull %432, ptr noundef nonnull %433) #16
  %434 = load i32, ptr @fsready, align 4, !tbaa !6
  %435 = icmp eq i32 %434, 0
  br i1 %435, label %437, label %436

436:                                              ; preds = %431
  tail call void @kfs_forkcopy(i32 noundef %6, i32 noundef %423) #17
  br label %437

437:                                              ; preds = %436, %431
  %438 = load i32, ptr @nextpid, align 4, !tbaa !6
  %439 = add i32 %438, 1
  store i32 %439, ptr @nextpid, align 4, !tbaa !6
  %440 = getelementptr inbounds nuw i8, ptr %426, i32 4
  store i32 %438, ptr %440, align 4, !tbaa !17
  %441 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %442 = load i32, ptr %441, align 4, !tbaa !17
  %443 = getelementptr inbounds nuw i8, ptr %426, i32 8
  store i32 %442, ptr %443, align 4, !tbaa !20
  %444 = getelementptr inbounds nuw i8, ptr %426, i32 12
  store i32 0, ptr %444, align 4, !tbaa !19
  store i32 3, ptr %426, align 4, !tbaa !15
  %445 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %446 = load i32, ptr %445, align 4, !tbaa !38
  %447 = inttoptr i32 %446 to ptr
  %448 = load volatile i32, ptr %447, align 4, !tbaa !6
  %449 = getelementptr inbounds nuw i8, ptr %426, i32 40
  store i32 %448, ptr %449, align 4, !tbaa !39
  %450 = load volatile i32, ptr %447, align 4, !tbaa !6
  %451 = getelementptr inbounds nuw i8, ptr %7, i32 40
  store i32 %450, ptr %451, align 4, !tbaa !39
  %452 = ptrtoint ptr %426 to i32
  %453 = getelementptr inbounds nuw i8, ptr %7, i32 12
  store i32 %452, ptr %453, align 4, !tbaa !19
  store i32 2, ptr %7, align 4, !tbaa !15
  br label %1098

454:                                              ; preds = %12
  call void @llvm.lifetime.start.p0(i64 84, ptr nonnull %3) #15
  %455 = load i32, ptr @fsready, align 4, !tbaa !6
  %456 = icmp eq i32 %455, 0
  br i1 %456, label %556, label %457

457:                                              ; preds = %454
  %458 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %459 = load volatile i32, ptr %458, align 4, !tbaa !35
  %460 = inttoptr i32 %459 to ptr
  %461 = tail call i32 @kfs_iopen(ptr noundef %460) #17
  %462 = icmp eq i32 %461, 0
  br i1 %462, label %556, label %463

463:                                              ; preds = %457
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %4) #15
  %464 = ptrtoint ptr %4 to i32
  %465 = call i32 @kfs_iread(i32 noundef %461, i32 noundef 0, i32 noundef %464, i32 noundef 52) #17
  %466 = icmp eq i32 %465, 52
  %467 = load i32, ptr %4, align 4
  %468 = icmp eq i32 %467, 1480674628
  %469 = select i1 %466, i1 %468, i1 false
  br i1 %469, label %470, label %552

470:                                              ; preds = %463
  %471 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %472 = load i32, ptr %471, align 4, !tbaa !6
  %473 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %474 = load i32, ptr %473, align 4, !tbaa !6
  %475 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %476 = load i32, ptr %475, align 4, !tbaa !6
  %477 = getelementptr inbounds nuw i8, ptr %3, i32 28
  store i32 %476, ptr %477, align 4, !tbaa !69
  %478 = getelementptr inbounds nuw i8, ptr %4, i32 16
  %479 = load i32, ptr %478, align 4, !tbaa !6
  %480 = getelementptr inbounds nuw i8, ptr %3, i32 32
  store i32 %479, ptr %480, align 4, !tbaa !71
  %481 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %482 = load i32, ptr %481, align 4, !tbaa !6
  %483 = getelementptr inbounds nuw i8, ptr %3, i32 40
  %484 = getelementptr inbounds nuw i8, ptr %4, i32 24
  %485 = load i32, ptr %484, align 4, !tbaa !6
  %486 = getelementptr inbounds nuw i8, ptr %3, i32 44
  store i32 %485, ptr %486, align 4, !tbaa !72
  %487 = getelementptr inbounds nuw i8, ptr %4, i32 28
  %488 = load i32, ptr %487, align 4, !tbaa !6
  %489 = getelementptr inbounds nuw i8, ptr %3, i32 48
  store i32 %488, ptr %489, align 4, !tbaa !73
  %490 = getelementptr inbounds nuw i8, ptr %4, i32 32
  %491 = load i32, ptr %490, align 4, !tbaa !6
  %492 = getelementptr inbounds nuw i8, ptr %3, i32 52
  store i32 %491, ptr %492, align 4, !tbaa !74
  %493 = getelementptr inbounds nuw i8, ptr %4, i32 36
  %494 = load i32, ptr %493, align 4, !tbaa !6
  %495 = getelementptr inbounds nuw i8, ptr %3, i32 56
  store i32 %494, ptr %495, align 4, !tbaa !75
  %496 = getelementptr inbounds nuw i8, ptr %4, i32 40
  %497 = load i32, ptr %496, align 4, !tbaa !6
  %498 = getelementptr inbounds nuw i8, ptr %3, i32 60
  store i32 %497, ptr %498, align 4, !tbaa !76
  %499 = getelementptr inbounds nuw i8, ptr %4, i32 44
  %500 = load i32, ptr %499, align 4, !tbaa !6
  %501 = getelementptr inbounds nuw i8, ptr %3, i32 64
  store i32 %500, ptr %501, align 4, !tbaa !77
  %502 = getelementptr inbounds nuw i8, ptr %4, i32 48
  %503 = load i32, ptr %502, align 4, !tbaa !6
  %504 = getelementptr inbounds nuw i8, ptr %3, i32 68
  store i32 %503, ptr %504, align 4, !tbaa !78
  %505 = call fastcc i32 @kalloc(i32 noundef %472) #16
  %506 = call fastcc i32 @kalloc(i32 noundef %474) #16
  %507 = add i32 %472, 52
  %508 = add i32 %474, %507
  %509 = icmp ne i32 %505, 0
  %510 = icmp ne i32 %506, 0
  %511 = select i1 %509, i1 %510, i1 false
  br i1 %511, label %512, label %518

512:                                              ; preds = %470
  %513 = call i32 @kfs_iread(i32 noundef %461, i32 noundef 52, i32 noundef %505, i32 noundef %472) #17
  %514 = icmp eq i32 %513, %472
  br i1 %514, label %515, label %518

515:                                              ; preds = %512
  %516 = call i32 @kfs_iread(i32 noundef %461, i32 noundef %507, i32 noundef %506, i32 noundef %474) #17
  %517 = icmp eq i32 %516, %474
  br i1 %517, label %519, label %518

518:                                              ; preds = %515, %512, %470
  call fastcc void @kfree(i32 noundef %505) #16
  call fastcc void @kfree(i32 noundef %506) #16
  br label %552

519:                                              ; preds = %515
  %520 = sub i32 %505, %476
  %521 = sub i32 %506, %479
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %5) #15
  %522 = ptrtoint ptr %5 to i32
  br label %523

523:                                              ; preds = %549, %519
  %524 = phi i32 [ %508, %519 ], [ %551, %549 ]
  %525 = phi i32 [ %482, %519 ], [ %550, %549 ]
  %526 = icmp eq i32 %525, 0
  br i1 %526, label %553, label %527

527:                                              ; preds = %523
  %528 = call i32 @llvm.umin.i32(i32 %525, i32 64)
  %529 = shl nuw nsw i32 %528, 2
  %530 = call i32 @kfs_iread(i32 noundef %461, i32 noundef %524, i32 noundef %522, i32 noundef %529) #17
  %531 = icmp eq i32 %530, %529
  br i1 %531, label %532, label %553

532:                                              ; preds = %527, %535
  %533 = phi i32 [ %548, %535 ], [ 0, %527 ]
  %534 = icmp eq i32 %533, %528
  br i1 %534, label %549, label %535

535:                                              ; preds = %532
  %536 = getelementptr inbounds nuw [64 x i32], ptr %5, i32 0, i32 %533
  %537 = load i32, ptr %536, align 4, !tbaa !6
  %538 = icmp slt i32 %537, 0
  %539 = select i1 %538, i32 %506, i32 %505
  %540 = and i32 %537, 1073741823
  %541 = add i32 %539, %540
  %542 = and i32 %537, 1073741824
  %543 = icmp eq i32 %542, 0
  %544 = select i1 %543, i32 %520, i32 %521
  %545 = inttoptr i32 %541 to ptr
  %546 = load volatile i32, ptr %545, align 4, !tbaa !6
  %547 = add i32 %544, %546
  store volatile i32 %547, ptr %545, align 4, !tbaa !6
  %548 = add nuw nsw i32 %533, 1
  br label %532, !llvm.loop !79

549:                                              ; preds = %532
  %550 = sub i32 %525, %528
  %551 = add i32 %529, %524
  br label %523

552:                                              ; preds = %463, %518
  call void @kfs_iclose(i32 noundef %461) #17
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %4) #15
  br label %796

553:                                              ; preds = %527, %523
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %5) #15
  call void @kfs_iclose(i32 noundef %461) #17
  store i32 0, ptr %483, align 4, !tbaa !80
  %554 = getelementptr inbounds nuw i8, ptr %3, i32 36
  store i32 0, ptr %554, align 4, !tbaa !81
  %555 = getelementptr inbounds nuw i8, ptr %3, i32 72
  store i32 0, ptr %555, align 4, !tbaa !82
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %4) #15
  br label %630

556:                                              ; preds = %454, %457
  %557 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %558 = load volatile i32, ptr %557, align 4, !tbaa !35
  %559 = inttoptr i32 %558 to ptr
  br label %560

560:                                              ; preds = %579, %556
  %561 = phi i32 [ 0, %556 ], [ %580, %579 ]
  %562 = icmp eq i32 %561, 24
  br i1 %562, label %796, label %563

563:                                              ; preds = %560
  %564 = getelementptr inbounds nuw [24 x %struct.kimg], ptr @kimages, i32 0, i32 %561
  %565 = load i8, ptr %564, align 4, !tbaa !3
  %566 = icmp eq i8 %565, 0
  br i1 %566, label %796, label %567

567:                                              ; preds = %563, %576
  %568 = phi i32 [ %578, %576 ], [ 0, %563 ]
  %569 = icmp eq i32 %568, 12
  br i1 %569, label %581, label %570

570:                                              ; preds = %567
  %571 = getelementptr inbounds nuw [12 x i8], ptr %564, i32 0, i32 %568
  %572 = load i8, ptr %571, align 1, !tbaa !3
  %573 = getelementptr inbounds nuw i8, ptr %559, i32 %568
  %574 = load i8, ptr %573, align 1, !tbaa !3
  %575 = icmp eq i8 %572, %574
  br i1 %575, label %576, label %579

576:                                              ; preds = %570
  %577 = icmp eq i8 %572, 0
  %578 = add nuw nsw i32 %568, 1
  br i1 %577, label %581, label %567, !llvm.loop !83

579:                                              ; preds = %570
  %580 = add nuw nsw i32 %561, 1
  br label %560, !llvm.loop !84

581:                                              ; preds = %576, %567
  %582 = getelementptr inbounds nuw i8, ptr %564, i32 72
  %583 = load i32, ptr %582, align 4, !tbaa !82
  %584 = icmp eq i32 %583, 0
  br i1 %584, label %608, label %585

585:                                              ; preds = %581
  %586 = getelementptr inbounds nuw i8, ptr %564, i32 80
  %587 = load i32, ptr %586, align 4, !tbaa !85
  %588 = add i32 %587, 7
  %589 = and i32 %588, -8
  %590 = getelementptr inbounds nuw i8, ptr %564, i32 24
  %591 = load i32, ptr %590, align 4, !tbaa !86
  %592 = add i32 %589, %591
  %593 = tail call fastcc i32 @kalloc(i32 noundef %592) #16
  %594 = load i32, ptr %582, align 4, !tbaa !82
  %595 = icmp eq i32 %593, %594
  br i1 %595, label %596, label %607

596:                                              ; preds = %585
  %597 = getelementptr inbounds nuw i8, ptr %564, i32 76
  %598 = load i32, ptr %597, align 4, !tbaa !87
  tail call void @kdmacpy(i32 noundef %593, i32 noundef %598, i32 noundef %589) #17
  %599 = add i32 %593, %589
  %600 = getelementptr inbounds nuw i8, ptr %564, i32 20
  %601 = load i32, ptr %600, align 4, !tbaa !88
  %602 = load i32, ptr %590, align 4, !tbaa !86
  %603 = add i32 %602, 3
  %604 = and i32 %603, -4
  tail call void @kdmacpy(i32 noundef %599, i32 noundef %601, i32 noundef %604) #17
  %605 = getelementptr inbounds nuw i8, ptr %564, i32 12
  %606 = load i32, ptr %605, align 4, !tbaa !89
  br label %630

607:                                              ; preds = %585
  tail call fastcc void @kfree(i32 noundef %593) #16
  br label %796

608:                                              ; preds = %581
  %609 = getelementptr inbounds nuw i8, ptr %564, i32 16
  %610 = load i32, ptr %609, align 4, !tbaa !90
  %611 = tail call fastcc i32 @kalloc(i32 noundef %610) #16
  %612 = getelementptr inbounds nuw i8, ptr %564, i32 24
  %613 = load i32, ptr %612, align 4, !tbaa !86
  %614 = tail call fastcc i32 @kalloc(i32 noundef %613) #16
  %615 = icmp ne i32 %611, 0
  %616 = icmp ne i32 %614, 0
  %617 = select i1 %615, i1 %616, i1 false
  br i1 %617, label %619, label %618

618:                                              ; preds = %608
  tail call fastcc void @kfree(i32 noundef %611) #16
  tail call fastcc void @kfree(i32 noundef %614) #16
  br label %796

619:                                              ; preds = %608
  %620 = getelementptr inbounds nuw i8, ptr %564, i32 12
  %621 = load i32, ptr %620, align 4, !tbaa !89
  %622 = load i32, ptr %609, align 4, !tbaa !90
  %623 = add i32 %622, 3
  %624 = and i32 %623, -4
  tail call void @kdmacpy(i32 noundef %611, i32 noundef %621, i32 noundef %624) #17
  %625 = getelementptr inbounds nuw i8, ptr %564, i32 20
  %626 = load i32, ptr %625, align 4, !tbaa !88
  %627 = load i32, ptr %612, align 4, !tbaa !86
  %628 = add i32 %627, 3
  %629 = and i32 %628, -4
  tail call void @kdmacpy(i32 noundef %614, i32 noundef %626, i32 noundef %629) #17
  br label %630

630:                                              ; preds = %596, %553, %619
  %631 = phi i32 [ %506, %553 ], [ %614, %619 ], [ %599, %596 ]
  %632 = phi i32 [ %505, %553 ], [ %611, %619 ], [ %606, %596 ]
  %633 = phi ptr [ %3, %553 ], [ %564, %619 ], [ %564, %596 ]
  %634 = getelementptr inbounds nuw i8, ptr %633, i32 28
  %635 = load i32, ptr %634, align 4, !tbaa !69
  %636 = sub i32 %632, %635
  %637 = getelementptr inbounds nuw i8, ptr %633, i32 32
  %638 = load i32, ptr %637, align 4, !tbaa !71
  %639 = sub i32 %631, %638
  %640 = getelementptr inbounds nuw i8, ptr %633, i32 36
  %641 = load i32, ptr %640, align 4, !tbaa !81
  %642 = inttoptr i32 %641 to ptr
  %643 = getelementptr inbounds nuw i8, ptr %633, i32 40
  br label %644

644:                                              ; preds = %688, %630
  %645 = phi i32 [ 0, %630 ], [ %701, %688 ]
  %646 = load i32, ptr %643, align 4, !tbaa !80
  %647 = icmp ult i32 %645, %646
  br i1 %647, label %688, label %648

648:                                              ; preds = %644
  %649 = getelementptr inbounds nuw i8, ptr %7, i32 52
  %650 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %651 = getelementptr inbounds nuw i8, ptr %7, i32 60
  br label %652

652:                                              ; preds = %668, %648
  %653 = phi ptr [ %7, %648 ], [ %659, %668 ]
  %654 = ptrtoint ptr %653 to i32
  br label %655

655:                                              ; preds = %666, %652
  %656 = phi i32 [ 0, %652 ], [ %667, %666 ]
  %657 = icmp eq i32 %656, 8
  br i1 %657, label %675, label %658

658:                                              ; preds = %655
  %659 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %656
  %660 = load i32, ptr %659, align 4, !tbaa !15
  %661 = icmp eq i32 %660, 2
  br i1 %661, label %662, label %666

662:                                              ; preds = %658
  %663 = getelementptr inbounds nuw i8, ptr %659, i32 12
  %664 = load i32, ptr %663, align 4, !tbaa !19
  %665 = icmp eq i32 %664, %654
  br i1 %665, label %668, label %666

666:                                              ; preds = %662, %658
  %667 = add nuw nsw i32 %656, 1
  br label %655, !llvm.loop !91

668:                                              ; preds = %662
  %669 = load i32, ptr %649, align 4, !tbaa !51
  %670 = getelementptr inbounds nuw i8, ptr %659, i32 52
  store i32 %669, ptr %670, align 4, !tbaa !51
  %671 = load i32, ptr %650, align 4, !tbaa !60
  %672 = getelementptr inbounds nuw i8, ptr %659, i32 56
  store i32 %671, ptr %672, align 4, !tbaa !60
  %673 = load i32, ptr %651, align 4, !tbaa !52
  %674 = getelementptr inbounds nuw i8, ptr %659, i32 60
  store i32 %673, ptr %674, align 4, !tbaa !52
  br label %652, !llvm.loop !92

675:                                              ; preds = %655
  %676 = load i32, ptr @curr, align 4, !tbaa !6
  call fastcc void @kfree_exec(i32 noundef %676) #16
  %677 = getelementptr inbounds nuw i8, ptr %633, i32 72
  %678 = load i32, ptr %677, align 4, !tbaa !82
  %679 = icmp eq i32 %678, 0
  %680 = load i32, ptr @curr, align 4, !tbaa !6
  %681 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %680
  %682 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %680, i32 1
  %683 = select i1 %679, i32 %632, i32 0
  %684 = select i1 %679, i32 %631, i32 %678
  store i32 %683, ptr %681, align 4, !tbaa !6
  store i32 %684, ptr %682, align 4, !tbaa !6
  %685 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %686 = load volatile i32, ptr %685, align 4, !tbaa !49
  %687 = icmp eq i32 %686, 0
  br i1 %687, label %743, label %702

688:                                              ; preds = %644
  %689 = getelementptr inbounds nuw i32, ptr %642, i32 %645
  %690 = load i32, ptr %689, align 4, !tbaa !6
  %691 = icmp slt i32 %690, 0
  %692 = select i1 %691, i32 %631, i32 %632
  %693 = and i32 %690, 1073741823
  %694 = add i32 %692, %693
  %695 = and i32 %690, 1073741824
  %696 = icmp eq i32 %695, 0
  %697 = select i1 %696, i32 %636, i32 %639
  %698 = inttoptr i32 %694 to ptr
  %699 = load volatile i32, ptr %698, align 4, !tbaa !6
  %700 = add i32 %697, %699
  store volatile i32 %700, ptr %698, align 4, !tbaa !6
  %701 = add nuw i32 %645, 1
  br label %644, !llvm.loop !93

702:                                              ; preds = %675
  %703 = call fastcc i32 @kalloc(i32 noundef 256) #16
  %704 = icmp eq i32 %703, 0
  br i1 %704, label %743, label %705

705:                                              ; preds = %702
  %706 = load volatile i32, ptr %685, align 4, !tbaa !49
  %707 = inttoptr i32 %706 to ptr
  %708 = inttoptr i32 %703 to ptr
  %709 = add i32 %703, 64
  %710 = inttoptr i32 %709 to ptr
  %711 = add i32 %703, 256
  %712 = inttoptr i32 %711 to ptr
  %713 = getelementptr inbounds i8, ptr %712, i32 -1
  br label %714

714:                                              ; preds = %736, %705
  %715 = phi i32 [ 0, %705 ], [ %738, %736 ]
  %716 = phi ptr [ %710, %705 ], [ %737, %736 ]
  %717 = icmp eq i32 %715, 15
  br i1 %717, label %739, label %718

718:                                              ; preds = %714
  %719 = getelementptr inbounds nuw i32, ptr %707, i32 %715
  %720 = load i32, ptr %719, align 4, !tbaa !6
  %721 = icmp eq i32 %720, 0
  br i1 %721, label %739, label %722

722:                                              ; preds = %718
  %723 = inttoptr i32 %720 to ptr
  %724 = ptrtoint ptr %716 to i32
  %725 = getelementptr inbounds nuw i32, ptr %708, i32 %715
  store i32 %724, ptr %725, align 4, !tbaa !6
  br label %726

726:                                              ; preds = %733, %722
  %727 = phi ptr [ %716, %722 ], [ %735, %733 ]
  %728 = phi ptr [ %723, %722 ], [ %734, %733 ]
  %729 = load i8, ptr %728, align 1, !tbaa !3
  %730 = icmp ne i8 %729, 0
  %731 = icmp ult ptr %727, %713
  %732 = select i1 %730, i1 %731, i1 false
  br i1 %732, label %733, label %736

733:                                              ; preds = %726
  %734 = getelementptr inbounds nuw i8, ptr %728, i32 1
  %735 = getelementptr inbounds nuw i8, ptr %727, i32 1
  store i8 %729, ptr %727, align 1, !tbaa !3
  br label %726, !llvm.loop !94

736:                                              ; preds = %726
  %737 = getelementptr inbounds nuw i8, ptr %727, i32 1
  store i8 0, ptr %727, align 1, !tbaa !3
  %738 = add nuw nsw i32 %715, 1
  br label %714, !llvm.loop !95

739:                                              ; preds = %714, %718
  %740 = getelementptr inbounds nuw i32, ptr %708, i32 %715
  store i32 0, ptr %740, align 4, !tbaa !6
  %741 = load i32, ptr @curr, align 4, !tbaa !6
  %742 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %741, i32 2
  store i32 %703, ptr %742, align 4, !tbaa !6
  br label %743

743:                                              ; preds = %702, %739, %675
  %744 = phi i32 [ 0, %675 ], [ %715, %739 ], [ 0, %702 ]
  %745 = phi i32 [ 0, %675 ], [ %703, %739 ], [ 0, %702 ]
  %746 = getelementptr inbounds nuw i8, ptr %633, i32 52
  %747 = load i32, ptr %746, align 4, !tbaa !74
  %748 = add i32 %747, %631
  %749 = getelementptr inbounds nuw i8, ptr %7, i32 24
  store i32 %748, ptr %749, align 4, !tbaa !32
  %750 = getelementptr inbounds nuw i8, ptr %633, i32 56
  %751 = load i32, ptr %750, align 4, !tbaa !75
  %752 = add i32 %751, %631
  %753 = getelementptr inbounds nuw i8, ptr %7, i32 28
  store i32 %752, ptr %753, align 4, !tbaa !96
  %754 = getelementptr inbounds nuw i8, ptr %633, i32 60
  %755 = load i32, ptr %754, align 4, !tbaa !76
  %756 = add i32 %755, %631
  %757 = getelementptr inbounds nuw i8, ptr %7, i32 32
  store i32 %756, ptr %757, align 4, !tbaa !38
  %758 = getelementptr inbounds nuw i8, ptr %633, i32 48
  %759 = load i32, ptr %758, align 4, !tbaa !73
  %760 = add i32 %759, %632
  %761 = getelementptr inbounds nuw i8, ptr %7, i32 36
  store i32 %760, ptr %761, align 4, !tbaa !43
  %762 = getelementptr inbounds nuw i8, ptr %633, i32 64
  %763 = load i32, ptr %762, align 4, !tbaa !77
  %764 = add i32 %763, %631
  store i32 %764, ptr %13, align 4, !tbaa !28
  %765 = load i32, ptr @k_sysentry, align 4, !tbaa !6
  %766 = getelementptr inbounds nuw i8, ptr %633, i32 68
  %767 = load i32, ptr %766, align 4, !tbaa !78
  %768 = add i32 %767, %631
  %769 = inttoptr i32 %768 to ptr
  store volatile i32 %765, ptr %769, align 4, !tbaa !6
  %770 = load i32, ptr %761, align 4, !tbaa !43
  %771 = load i32, ptr %749, align 4, !tbaa !32
  %772 = inttoptr i32 %771 to ptr
  store volatile i32 %770, ptr %772, align 4, !tbaa !6
  %773 = load i32, ptr %746, align 4, !tbaa !74
  %774 = add i32 %773, %631
  %775 = add i32 %774, -84
  %776 = inttoptr i32 %775 to ptr
  store volatile i32 %744, ptr %776, align 4, !tbaa !6
  %777 = add i32 %774, -80
  %778 = inttoptr i32 %777 to ptr
  store volatile i32 %745, ptr %778, align 4, !tbaa !6
  %779 = load i32, ptr @curr, align 4, !tbaa !6
  %780 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %779
  %781 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %782 = load volatile i32, ptr %781, align 4, !tbaa !35
  %783 = inttoptr i32 %782 to ptr
  br label %784

784:                                              ; preds = %793, %743
  %785 = phi i32 [ 0, %743 ], [ %794, %793 ]
  %786 = phi ptr [ %783, %743 ], [ %795, %793 ]
  %787 = load i8, ptr %786, align 1, !tbaa !3
  switch i8 %787, label %788 [
    i8 0, label %797
    i8 47, label %793
  ]

788:                                              ; preds = %784
  %789 = icmp slt i32 %785, 11
  br i1 %789, label %790, label %793

790:                                              ; preds = %788
  %791 = add nsw i32 %785, 1
  %792 = getelementptr inbounds i8, ptr %780, i32 %785
  store i8 %787, ptr %792, align 1, !tbaa !3
  br label %793

793:                                              ; preds = %784, %790, %788
  %794 = phi i32 [ %791, %790 ], [ %785, %788 ], [ 0, %784 ]
  %795 = getelementptr inbounds nuw i8, ptr %786, i32 1
  br label %784, !llvm.loop !97

796:                                              ; preds = %560, %563, %607, %618, %552
  call void @llvm.lifetime.end.p0(i64 84, ptr nonnull %3) #15
  br label %1079

797:                                              ; preds = %784
  %798 = getelementptr inbounds i8, ptr %780, i32 %785
  store i8 0, ptr %798, align 1, !tbaa !3
  call fastcc void @vfork_release(ptr noundef nonnull %7) #16
  store i32 4, ptr %7, align 4, !tbaa !15
  %799 = load i32, ptr @curr, align 4, !tbaa !6
  %800 = getelementptr inbounds nuw i8, ptr %633, i32 44
  %801 = load i32, ptr %800, align 4, !tbaa !72
  %802 = add i32 %801, %632
  call fastcc void @kexit(i32 noundef %799, i32 noundef %802) #16
  call void @llvm.lifetime.end.p0(i64 84, ptr nonnull %3) #15
  br label %1109

803:                                              ; preds = %12
  %804 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %805 = load volatile i32, ptr %804, align 4, !tbaa !35
  tail call fastcc void @terminate(ptr noundef nonnull %7, i32 noundef %805) #16
  br label %1094

806:                                              ; preds = %12
  %807 = load i32, ptr @fsready, align 4, !tbaa !6
  %808 = icmp eq i32 %807, 0
  br i1 %808, label %1079, label %809

809:                                              ; preds = %806
  %810 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %811 = load volatile i32, ptr %810, align 4, !tbaa !35
  %812 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %813 = load volatile i32, ptr %812, align 4, !tbaa !49
  %814 = tail call i32 @kfs_mount(i32 noundef %811, i32 noundef %813) #17
  br label %1079

815:                                              ; preds = %12
  %816 = load i32, ptr @fsready, align 4, !tbaa !6
  %817 = icmp eq i32 %816, 0
  br i1 %817, label %1079, label %818

818:                                              ; preds = %815
  %819 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %820 = load volatile i32, ptr %819, align 4, !tbaa !35
  %821 = tail call i32 @kfs_umount(i32 noundef %820) #17
  br label %1079

822:                                              ; preds = %12
  %823 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %824 = load volatile i32, ptr %823, align 4, !tbaa !35
  %825 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %826 = load i32, ptr %825, align 4, !tbaa !60
  %827 = icmp ult i32 %824, %826
  br i1 %827, label %828, label %835

828:                                              ; preds = %822
  %829 = add i32 %824, 32
  %830 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %831 = load i32, ptr %830, align 4, !tbaa !52
  %832 = icmp ugt i32 %829, %831
  br i1 %832, label %833, label %835

833:                                              ; preds = %828
  %834 = icmp ugt i32 %824, -33
  br i1 %834, label %835, label %1079

835:                                              ; preds = %822, %828, %833
  %836 = load volatile i32, ptr %823, align 4, !tbaa !35
  %837 = inttoptr i32 %836 to ptr
  %838 = load i32, ptr @arena_end, align 4, !tbaa !6
  %839 = load i32, ptr @arena, align 4, !tbaa !6
  %840 = sub i32 %838, %839
  store i32 %840, ptr %837, align 4, !tbaa !6
  %841 = getelementptr inbounds nuw i8, ptr %837, i32 4
  store i32 0, ptr %841, align 4, !tbaa !6
  %842 = getelementptr inbounds nuw i8, ptr %837, i32 8
  store i32 0, ptr %842, align 4, !tbaa !6
  %843 = load i1, ptr @kheap_init, align 4
  br i1 %843, label %845, label %844

844:                                              ; preds = %835
  store i32 %840, ptr %842, align 4, !tbaa !6
  store i32 %840, ptr %841, align 4, !tbaa !6
  br label %860

845:                                              ; preds = %835, %857
  %846 = phi i32 [ %858, %857 ], [ 0, %835 ]
  %847 = phi i32 [ %853, %857 ], [ 0, %835 ]
  %848 = phi ptr [ %859, %857 ], [ @kfreelist, %835 ]
  %849 = load ptr, ptr %848, align 4, !tbaa !53
  %850 = icmp eq ptr %849, null
  br i1 %850, label %860, label %851

851:                                              ; preds = %845
  %852 = load i32, ptr %849, align 4, !tbaa !55
  %853 = add i32 %847, %852
  store i32 %853, ptr %841, align 4, !tbaa !6
  %854 = load i32, ptr %849, align 4, !tbaa !55
  %855 = icmp ugt i32 %854, %846
  br i1 %855, label %856, label %857

856:                                              ; preds = %851
  store i32 %854, ptr %842, align 4, !tbaa !6
  br label %857

857:                                              ; preds = %851, %856
  %858 = phi i32 [ %846, %851 ], [ %854, %856 ]
  %859 = getelementptr inbounds nuw i8, ptr %849, i32 4
  br label %845, !llvm.loop !98

860:                                              ; preds = %845, %844
  %861 = getelementptr inbounds nuw i8, ptr %837, i32 20
  store i32 0, ptr %861, align 4, !tbaa !6
  %862 = getelementptr inbounds nuw i8, ptr %837, i32 16
  store i32 0, ptr %862, align 4, !tbaa !6
  %863 = getelementptr inbounds nuw i8, ptr %837, i32 12
  store i32 0, ptr %863, align 4, !tbaa !6
  br label %864

864:                                              ; preds = %907, %860
  %865 = phi i32 [ 0, %860 ], [ %886, %907 ]
  %866 = phi i32 [ 0, %860 ], [ %908, %907 ]
  %867 = phi i32 [ 0, %860 ], [ %884, %907 ]
  %868 = phi i32 [ 0, %860 ], [ %909, %907 ]
  %869 = icmp eq i32 %868, 8
  br i1 %869, label %870, label %874

870:                                              ; preds = %864
  %871 = getelementptr inbounds nuw i8, ptr %837, i32 24
  store i32 8, ptr %871, align 4, !tbaa !6
  %872 = load i32, ptr @ticks, align 4, !tbaa !6
  %873 = getelementptr inbounds nuw i8, ptr %837, i32 28
  store i32 %872, ptr %873, align 4, !tbaa !6
  br label %1079

874:                                              ; preds = %864
  %875 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %868
  %876 = load i32, ptr %875, align 4, !tbaa !6
  %877 = icmp eq i32 %876, 0
  br i1 %877, label %883, label %878

878:                                              ; preds = %874
  %879 = add i32 %876, -256
  %880 = inttoptr i32 %879 to ptr
  %881 = load volatile i32, ptr %880, align 4, !tbaa !6
  %882 = add i32 %867, %881
  store i32 %882, ptr %863, align 4, !tbaa !6
  br label %883

883:                                              ; preds = %878, %874
  %884 = phi i32 [ %882, %878 ], [ %867, %874 ]
  br label %885

885:                                              ; preds = %902, %883
  %886 = phi i32 [ %865, %883 ], [ %903, %902 ]
  %887 = phi i32 [ 0, %883 ], [ %904, %902 ]
  %888 = icmp eq i32 %887, 3
  br i1 %888, label %889, label %893

889:                                              ; preds = %885
  %890 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %868
  %891 = load i32, ptr %890, align 4, !tbaa !15
  %892 = icmp eq i32 %891, 0
  br i1 %892, label %907, label %905

893:                                              ; preds = %885
  %894 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %868, i32 %887
  %895 = load i32, ptr %894, align 4, !tbaa !6
  %896 = icmp eq i32 %895, 0
  br i1 %896, label %902, label %897

897:                                              ; preds = %893
  %898 = add i32 %895, -256
  %899 = inttoptr i32 %898 to ptr
  %900 = load volatile i32, ptr %899, align 4, !tbaa !6
  %901 = add i32 %886, %900
  store i32 %901, ptr %862, align 4, !tbaa !6
  br label %902

902:                                              ; preds = %893, %897
  %903 = phi i32 [ %886, %893 ], [ %901, %897 ]
  %904 = add nuw nsw i32 %887, 1
  br label %885, !llvm.loop !99

905:                                              ; preds = %889
  %906 = add i32 %866, 1
  store i32 %906, ptr %861, align 4, !tbaa !6
  br label %907

907:                                              ; preds = %889, %905
  %908 = phi i32 [ %866, %889 ], [ %906, %905 ]
  %909 = add nuw nsw i32 %868, 1
  br label %864, !llvm.loop !100

910:                                              ; preds = %12
  %911 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %912 = load volatile i32, ptr %911, align 4, !tbaa !49
  %913 = icmp ugt i32 %912, 8
  br i1 %913, label %916, label %914

914:                                              ; preds = %910
  %915 = load volatile i32, ptr %911, align 4, !tbaa !49
  br label %916

916:                                              ; preds = %910, %914
  %917 = phi i32 [ %915, %914 ], [ 8, %910 ]
  %918 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %919 = load volatile i32, ptr %918, align 4, !tbaa !35
  %920 = mul i32 %917, 24
  %921 = tail call fastcc i32 @badbuf(ptr noundef nonnull %7, i32 noundef %919, i32 noundef %920) #16
  %922 = icmp eq i32 %921, 0
  br i1 %922, label %923, label %1079

923:                                              ; preds = %916
  %924 = load volatile i32, ptr %918, align 4, !tbaa !35
  %925 = inttoptr i32 %924 to ptr
  br label %926

926:                                              ; preds = %949, %923
  %927 = phi ptr [ %925, %923 ], [ %950, %949 ]
  %928 = phi i32 [ 0, %923 ], [ %951, %949 ]
  %929 = phi i32 [ 0, %923 ], [ %952, %949 ]
  %930 = icmp samesign ult i32 %929, 8
  %931 = icmp ult i32 %928, %917
  %932 = select i1 %930, i1 %931, i1 false
  br i1 %932, label %933, label %1079

933:                                              ; preds = %926
  %934 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %929
  %935 = load i32, ptr %934, align 4, !tbaa !15
  %936 = icmp eq i32 %935, 0
  br i1 %936, label %949, label %937

937:                                              ; preds = %933
  %938 = getelementptr inbounds nuw i8, ptr %934, i32 4
  %939 = load i32, ptr %938, align 4, !tbaa !17
  store i32 %939, ptr %927, align 4, !tbaa !6
  %940 = getelementptr inbounds nuw i8, ptr %934, i32 8
  %941 = load i32, ptr %940, align 4, !tbaa !20
  %942 = getelementptr inbounds nuw i8, ptr %927, i32 4
  store i32 %941, ptr %942, align 4, !tbaa !6
  %943 = load i32, ptr %934, align 4, !tbaa !15
  %944 = getelementptr inbounds nuw i8, ptr %927, i32 8
  store i32 %943, ptr %944, align 4, !tbaa !6
  %945 = getelementptr inbounds nuw i8, ptr %927, i32 12
  %946 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %929
  tail call fastcc void @namecpy(ptr noundef nonnull %945, ptr noundef nonnull %946) #16
  %947 = getelementptr inbounds nuw i8, ptr %927, i32 24
  %948 = add nuw i32 %928, 1
  br label %949

949:                                              ; preds = %933, %937
  %950 = phi ptr [ %927, %933 ], [ %947, %937 ]
  %951 = phi i32 [ %928, %933 ], [ %948, %937 ]
  %952 = add nuw nsw i32 %929, 1
  br label %926, !llvm.loop !101

953:                                              ; preds = %12
  %954 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %955 = load volatile i32, ptr %954, align 4, !tbaa !35
  %956 = icmp eq i32 %955, 0
  br i1 %956, label %961, label %957

957:                                              ; preds = %953
  store i1 true, ptr @cons_raw, align 4
  %958 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %959 = load i32, ptr %958, align 4, !tbaa !17
  store i32 %959, ptr @cons_raw_pid, align 4, !tbaa !6
  %960 = load i32, ptr @cons_e, align 4, !tbaa !6
  store i32 %960, ptr @cons_w, align 4, !tbaa !6
  br label %1079

961:                                              ; preds = %953
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !6
  br label %1079

962:                                              ; preds = %12
  %963 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %964 = load volatile i32, ptr %963, align 4, !tbaa !35
  %965 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %966 = load volatile i32, ptr %965, align 4, !tbaa !49
  %967 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %968 = load volatile i32, ptr %967, align 4, !tbaa !50
  %969 = tail call i32 @kgpio(i32 noundef %964, i32 noundef %966, i32 noundef %968) #17
  br label %1079

970:                                              ; preds = %12
  %971 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %972 = load volatile i32, ptr %971, align 4, !tbaa !35
  %973 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %974 = load volatile i32, ptr %973, align 4, !tbaa !49
  %975 = tail call i32 @kpinmux(i32 noundef %972, i32 noundef %974) #17
  br label %1079

976:                                              ; preds = %12
  %977 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %978 = load volatile i32, ptr %977, align 4, !tbaa !35
  %979 = icmp eq i32 %978, 0
  br i1 %979, label %983, label %980

980:                                              ; preds = %976
  %981 = load volatile i32, ptr %977, align 4, !tbaa !35
  %982 = icmp eq i32 %981, 1
  br i1 %982, label %983, label %996

983:                                              ; preds = %980, %976
  %984 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %985 = load volatile i32, ptr %984, align 4, !tbaa !49
  %986 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %987 = load i32, ptr %986, align 4, !tbaa !60
  %988 = icmp ult i32 %985, %987
  br i1 %988, label %989, label %996

989:                                              ; preds = %983
  %990 = add i32 %985, 28
  %991 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %992 = load i32, ptr %991, align 4, !tbaa !52
  %993 = icmp ugt i32 %990, %992
  br i1 %993, label %994, label %996

994:                                              ; preds = %989
  %995 = icmp ugt i32 %985, -29
  br i1 %995, label %996, label %1079

996:                                              ; preds = %983, %989, %994, %980
  %997 = load volatile i32, ptr %977, align 4, !tbaa !35
  %998 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %999 = load volatile i32, ptr %998, align 4, !tbaa !49
  %1000 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %1001 = load volatile i32, ptr %1000, align 4, !tbaa !50
  %1002 = tail call i32 @kpio(i32 noundef %997, i32 noundef %999, i32 noundef %1001) #17
  br label %1079

1003:                                             ; preds = %12
  %1004 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %1005 = load volatile i32, ptr %1004, align 4, !tbaa !35
  %1006 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %1007 = load volatile i32, ptr %1006, align 4, !tbaa !49
  %1008 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %1009 = load i32, ptr %1008, align 4, !tbaa !17
  %1010 = load volatile i32, ptr %1004, align 4, !tbaa !35
  %1011 = icmp eq i32 %1010, 0
  br i1 %1011, label %1012, label %1025

1012:                                             ; preds = %1003
  %1013 = load volatile i32, ptr %1006, align 4, !tbaa !49
  %1014 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %1015 = load i32, ptr %1014, align 4, !tbaa !60
  %1016 = icmp ult i32 %1013, %1015
  br i1 %1016, label %1017, label %1025

1017:                                             ; preds = %1012
  %1018 = add i32 %1013, 20
  %1019 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %1020 = load i32, ptr %1019, align 4, !tbaa !52
  %1021 = icmp ugt i32 %1018, %1020
  br i1 %1021, label %1022, label %1025

1022:                                             ; preds = %1017
  %1023 = icmp ult i32 %1013, -20
  %1024 = zext i1 %1023 to i32
  br label %1025

1025:                                             ; preds = %1022, %1017, %1012, %1003
  %1026 = phi i32 [ 0, %1003 ], [ 0, %1017 ], [ 0, %1012 ], [ %1024, %1022 ]
  %1027 = tail call i32 @kfb_syscall(i32 noundef %1005, i32 noundef %1007, i32 noundef %1009, i32 noundef %1026) #17
  br label %1079

1028:                                             ; preds = %12
  %1029 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %1030 = load volatile i32, ptr %1029, align 4, !tbaa !50
  %1031 = getelementptr inbounds nuw i8, ptr %7, i32 64
  store i32 %1030, ptr %1031, align 4, !tbaa !26
  %1032 = getelementptr inbounds nuw i8, ptr %7, i32 68
  store i32 0, ptr %1032, align 4, !tbaa !27
  br label %1079

1033:                                             ; preds = %12
  %1034 = getelementptr inbounds nuw i8, ptr %7, i32 64
  %1035 = load i32, ptr %1034, align 4, !tbaa !26
  %1036 = icmp eq i32 %1035, 0
  br i1 %1036, label %1079, label %1037

1037:                                             ; preds = %1033
  %1038 = getelementptr inbounds nuw i8, ptr %7, i32 24
  %1039 = load i32, ptr %1038, align 4, !tbaa !32
  %1040 = add i32 %1039, -84
  %1041 = getelementptr inbounds nuw i8, ptr %7, i32 68
  store i32 0, ptr %1041, align 4, !tbaa !27
  %1042 = add i32 %1035, 8
  %1043 = inttoptr i32 %1042 to ptr
  %1044 = load volatile i32, ptr %1043, align 4, !tbaa !6
  %1045 = inttoptr i32 %1040 to ptr
  store volatile i32 %1044, ptr %1045, align 4, !tbaa !6
  %1046 = add i32 %1035, 12
  %1047 = inttoptr i32 %1046 to ptr
  %1048 = load volatile i32, ptr %1047, align 4, !tbaa !6
  %1049 = add i32 %1039, -80
  %1050 = inttoptr i32 %1049 to ptr
  store volatile i32 %1048, ptr %1050, align 4, !tbaa !6
  store i32 4, ptr %7, align 4, !tbaa !15
  %1051 = load i32, ptr @curr, align 4, !tbaa !6
  %1052 = add i32 %1035, 4
  %1053 = inttoptr i32 %1052 to ptr
  %1054 = load volatile i32, ptr %1053, align 4, !tbaa !6
  tail call fastcc void @kexit(i32 noundef %1051, i32 noundef %1054) #16
  br label %1109

1055:                                             ; preds = %17, %1067
  %1056 = phi i32 [ %1068, %1067 ], [ 0, %17 ]
  %1057 = icmp eq i32 %1056, 8
  br i1 %1057, label %1079, label %1058

1058:                                             ; preds = %1055
  %1059 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1056
  %1060 = load i32, ptr %1059, align 4, !tbaa !15
  %1061 = icmp eq i32 %1060, 0
  br i1 %1061, label %1067, label %1062

1062:                                             ; preds = %1058
  %1063 = getelementptr inbounds nuw i8, ptr %1059, i32 4
  %1064 = load i32, ptr %1063, align 4, !tbaa !17
  %1065 = load volatile i32, ptr %18, align 4, !tbaa !35
  %1066 = icmp eq i32 %1064, %1065
  br i1 %1066, label %1069, label %1067

1067:                                             ; preds = %1058, %1062
  %1068 = add nuw nsw i32 %1056, 1
  br label %1055, !llvm.loop !102

1069:                                             ; preds = %1062
  %1070 = icmp eq i32 %1060, 5
  br i1 %1070, label %1079, label %1071

1071:                                             ; preds = %1069
  %1072 = icmp eq i32 %1056, %6
  br i1 %1072, label %1073, label %1074

1073:                                             ; preds = %1071
  tail call fastcc void @terminate(ptr noundef nonnull %7, i32 noundef -1) #16
  br label %1094

1074:                                             ; preds = %1071
  %1075 = icmp eq i32 %1060, 2
  br i1 %1075, label %1076, label %1077

1076:                                             ; preds = %1074
  tail call fastcc void @terminate(ptr noundef nonnull %1059, i32 noundef -1) #16
  br label %1079

1077:                                             ; preds = %1074
  %1078 = getelementptr inbounds nuw i8, ptr %1059, i32 48
  store i32 1, ptr %1078, align 4, !tbaa !33
  br label %1079

1079:                                             ; preds = %1055, %926, %422, %268, %139, %29, %12, %21, %24, %137, %833, %870, %962, %970, %996, %1025, %1028, %54, %57, %63, %66, %70, %73, %77, %80, %86, %89, %95, %98, %102, %105, %109, %112, %116, %119, %125, %128, %343, %320, %406, %410, %806, %809, %815, %818, %916, %961, %957, %994, %1069, %1077, %1076, %1033, %50, %159, %172, %228, %240, %255, %796
  %1080 = phi i32 [ -1, %796 ], [ -1, %228 ], [ -1, %255 ], [ -1, %240 ], [ -1, %172 ], [ %161, %159 ], [ %52, %50 ], [ -1, %1033 ], [ 0, %1076 ], [ 0, %1077 ], [ -1, %1069 ], [ -1, %994 ], [ 0, %957 ], [ 0, %961 ], [ -1, %916 ], [ -1, %815 ], [ %821, %818 ], [ -1, %806 ], [ %814, %809 ], [ -1, %410 ], [ %409, %406 ], [ %318, %320 ], [ 0, %343 ], [ -1, %125 ], [ %131, %128 ], [ -1, %116 ], [ %124, %119 ], [ -1, %109 ], [ %115, %112 ], [ -1, %102 ], [ %108, %105 ], [ -1, %95 ], [ %101, %98 ], [ -1, %86 ], [ %94, %89 ], [ -1, %77 ], [ %85, %80 ], [ -1, %70 ], [ %76, %73 ], [ -1, %63 ], [ %69, %66 ], [ -1, %54 ], [ %62, %57 ], [ 0, %1028 ], [ %1027, %1025 ], [ %1002, %996 ], [ %975, %970 ], [ %969, %962 ], [ 0, %870 ], [ -1, %833 ], [ %138, %137 ], [ %28, %24 ], [ %23, %21 ], [ -1, %12 ], [ -1, %29 ], [ -1, %139 ], [ %237, %268 ], [ -1, %422 ], [ %928, %926 ], [ -1, %1055 ]
  %1081 = load i32, ptr %13, align 4, !tbaa !28
  %1082 = inttoptr i32 %1081 to ptr
  %1083 = getelementptr inbounds nuw i8, ptr %1082, i32 16
  store volatile i32 %1080, ptr %1083, align 4, !tbaa !29
  %1084 = getelementptr inbounds nuw i8, ptr %1082, i32 20
  store volatile i32 1, ptr %1084, align 4, !tbaa !31
  %1085 = getelementptr inbounds nuw i8, ptr %7, i32 24
  %1086 = load i32, ptr %1085, align 4, !tbaa !32
  %1087 = add i32 %1086, -84
  %1088 = inttoptr i32 %1087 to ptr
  store volatile i32 %1080, ptr %1088, align 4, !tbaa !6
  store i32 4, ptr %7, align 4, !tbaa !15
  %1089 = load i32, ptr @curr, align 4, !tbaa !6
  %1090 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %1091 = load i32, ptr %1090, align 4, !tbaa !38
  %1092 = inttoptr i32 %1091 to ptr
  %1093 = load volatile i32, ptr %1092, align 4, !tbaa !6
  call fastcc void @kexit(i32 noundef %1089, i32 noundef %1093) #16
  br label %1109

1094:                                             ; preds = %159, %50, %803, %349, %365, %1073
  %1095 = phi i32 [ -1, %1073 ], [ 0, %349 ], [ 0, %365 ], [ -1, %803 ], [ -3, %50 ], [ -3, %159 ]
  %1096 = load i32, ptr %7, align 4, !tbaa !15
  %1097 = icmp eq i32 %1096, 2
  br i1 %1097, label %1098, label %1108

1098:                                             ; preds = %437, %412, %298, %1094
  %1099 = phi i32 [ %1095, %1094 ], [ 0, %437 ], [ %421, %412 ], [ 0, %298 ]
  %1100 = load i32, ptr %13, align 4, !tbaa !28
  %1101 = inttoptr i32 %1100 to ptr
  %1102 = getelementptr inbounds nuw i8, ptr %1101, i32 16
  store volatile i32 %1099, ptr %1102, align 4, !tbaa !29
  %1103 = getelementptr inbounds nuw i8, ptr %1101, i32 20
  store volatile i32 1, ptr %1103, align 4, !tbaa !31
  %1104 = getelementptr inbounds nuw i8, ptr %7, i32 24
  %1105 = load i32, ptr %1104, align 4, !tbaa !32
  %1106 = add i32 %1105, -84
  %1107 = inttoptr i32 %1106 to ptr
  store volatile i32 %1099, ptr %1107, align 4, !tbaa !6
  br label %1108

1108:                                             ; preds = %1098, %1094
  tail call fastcc void @swtch() #16
  br label %1109

1109:                                             ; preds = %797, %1037, %1079, %1108, %11
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @badbuf(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #7 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 56
  %5 = load i32, ptr %4, align 4, !tbaa !60
  %6 = icmp ne i32 %2, 0
  %7 = icmp ult i32 %1, %5
  %8 = and i1 %6, %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = add i32 %2, %1
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 60
  %12 = load i32, ptr %11, align 4, !tbaa !52
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
declare dso_local i32 @kfs_write(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_open(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_close(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_dup(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_fstat(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_seek(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_pipe(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_chdir(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mkdir(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_link(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_unlink(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfb_pause() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sync() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfb_resume() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_read(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_selready(i32 noundef) local_unnamed_addr #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #9

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @namecpy(ptr noundef writeonly captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #10 {
  br label %3

3:                                                ; preds = %7, %2
  %4 = phi i32 [ 0, %2 ], [ %11, %7 ]
  %5 = icmp eq i32 %4, 12
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 %4
  %9 = load i8, ptr %8, align 1, !tbaa !3
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  store i8 %9, ptr %10, align 1, !tbaa !3
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !103
}

; Function Attrs: minsize optsize
declare dso_local void @kfs_forkcopy(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iopen(ptr noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iread(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_iclose(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #11 {
  %2 = load i1, ptr @kheap_init, align 4
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  store i1 true, ptr @kheap_init, align 4
  %4 = load i32, ptr @arena, align 4, !tbaa !6
  %5 = inttoptr i32 %4 to ptr
  store ptr %5, ptr @kfreelist, align 4, !tbaa !53
  %6 = load i32, ptr @arena_end, align 4, !tbaa !6
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !55
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr null, ptr %8, align 4, !tbaa !57
  br label %9

9:                                                ; preds = %3, %1
  %10 = add i32 %0, 255
  %11 = and i32 %10, -256
  %12 = add i32 %11, 256
  br label %13

13:                                               ; preds = %38, %9
  %14 = phi ptr [ @kfreelist, %9 ], [ %39, %38 ]
  %15 = load ptr, ptr %14, align 4, !tbaa !53
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !55
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
  store i32 %21, ptr %26, align 4, !tbaa !55
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !57
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !57
  store i32 %12, ptr %15, align 4, !tbaa !55
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !57
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !53
  %37 = add i32 %35, 256
  br label %40

38:                                               ; preds = %17
  %39 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %13, !llvm.loop !104

40:                                               ; preds = %13, %34
  %41 = phi i32 [ %37, %34 ], [ 0, %13 ]
  ret i32 %41
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #11 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %41, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -256
  br label %5

5:                                                ; preds = %5, %3
  %6 = phi ptr [ null, %3 ], [ %8, %5 ]
  %7 = phi ptr [ @kfreelist, %3 ], [ %13, %5 ]
  %8 = load ptr, ptr %7, align 4, !tbaa !53
  %9 = icmp ne ptr %8, null
  %10 = ptrtoint ptr %8 to i32
  %11 = icmp ugt i32 %4, %10
  %12 = and i1 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 4
  br i1 %12, label %5, label %14, !llvm.loop !105

14:                                               ; preds = %5
  %15 = inttoptr i32 %4 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  store ptr %8, ptr %16, align 4, !tbaa !57
  %17 = icmp eq ptr %6, null
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %15, ptr %19, align 4, !tbaa !57
  br label %21

20:                                               ; preds = %14
  store ptr %15, ptr @kfreelist, align 4, !tbaa !53
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !55
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !55
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !55
  %29 = load ptr, ptr %13, align 4, !tbaa !57
  store ptr %29, ptr %16, align 4, !tbaa !57
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !55
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !55
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !55
  %39 = load ptr, ptr %16, align 4, !tbaa !57
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !57
  br label %41

41:                                               ; preds = %30, %31, %36, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kdmacpy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree_exec(i32 noundef %0) unnamed_addr #11 {
  br label %2

2:                                                ; preds = %14, %1
  %3 = phi i32 [ 0, %1 ], [ %17, %14 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %5, label %14

5:                                                ; preds = %2
  %6 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !6
  tail call fastcc void @kfree(i32 noundef %7) #16
  store i32 0, ptr %6, align 4, !tbaa !6
  %8 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 60
  store i32 0, ptr %9, align 4, !tbaa !52
  %10 = getelementptr inbounds nuw i8, ptr %8, i32 56
  store i32 0, ptr %10, align 4, !tbaa !60
  %11 = getelementptr inbounds nuw i8, ptr %8, i32 52
  store i32 0, ptr %11, align 4, !tbaa !51
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 68
  store i32 0, ptr %12, align 4, !tbaa !27
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 64
  store i32 0, ptr %13, align 4, !tbaa !26
  ret void

14:                                               ; preds = %2
  %15 = getelementptr inbounds [8 x [3 x i32]], ptr @execmem, i32 0, i32 %0, i32 %3
  %16 = load i32, ptr %15, align 4, !tbaa !6
  tail call fastcc void @kfree(i32 noundef %16) #16
  store i32 0, ptr %15, align 4, !tbaa !6
  %17 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !106
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @vfork_release(ptr noundef %0) unnamed_addr #3 {
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
  %10 = load i32, ptr %9, align 4, !tbaa !15
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %27

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !19
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr %3, align 4, !tbaa !17
  %18 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %19 = load i32, ptr %18, align 4, !tbaa !28
  %20 = inttoptr i32 %19 to ptr
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store volatile i32 %17, ptr %21, align 4, !tbaa !29
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 20
  store volatile i32 1, ptr %22, align 4, !tbaa !31
  %23 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %24 = load i32, ptr %23, align 4, !tbaa !32
  %25 = add i32 %24, -84
  %26 = inttoptr i32 %25 to ptr
  store volatile i32 %17, ptr %26, align 4, !tbaa !6
  store i32 0, ptr %13, align 4, !tbaa !19
  store i32 3, ptr %9, align 4, !tbaa !15
  br label %27

27:                                               ; preds = %16, %12, %8
  %28 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !107
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
  tail call fastcc void @fire_income() #16
  br label %11

11:                                               ; preds = %10, %5, %2
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 68
  %14 = load i32, ptr %13, align 4, !tbaa !27
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %40

16:                                               ; preds = %11
  %17 = getelementptr inbounds nuw i8, ptr %12, i32 64
  %18 = load i32, ptr %17, align 4, !tbaa !26
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %40, label %20

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !32
  %23 = add i32 %22, -84
  %24 = add i32 %18, 4
  %25 = inttoptr i32 %24 to ptr
  store volatile i32 %1, ptr %25, align 4, !tbaa !6
  %26 = inttoptr i32 %23 to ptr
  %27 = load volatile i32, ptr %26, align 4, !tbaa !6
  %28 = load i32, ptr %17, align 4, !tbaa !26
  %29 = add i32 %28, 8
  %30 = inttoptr i32 %29 to ptr
  store volatile i32 %27, ptr %30, align 4, !tbaa !6
  %31 = add i32 %22, -80
  %32 = inttoptr i32 %31 to ptr
  %33 = load volatile i32, ptr %32, align 4, !tbaa !6
  %34 = load i32, ptr %17, align 4, !tbaa !26
  %35 = add i32 %34, 12
  %36 = inttoptr i32 %35 to ptr
  store volatile i32 %33, ptr %36, align 4, !tbaa !6
  %37 = load i32, ptr %17, align 4, !tbaa !26
  %38 = inttoptr i32 %37 to ptr
  %39 = load volatile i32, ptr %38, align 4, !tbaa !6
  store i32 2, ptr %13, align 4, !tbaa !27
  br label %40

40:                                               ; preds = %20, %16, %11
  %41 = phi i32 [ %39, %20 ], [ %1, %16 ], [ %1, %11 ]
  store i32 %0, ptr @curr, align 4, !tbaa !6
  %42 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %43 = load i32, ptr %42, align 4, !tbaa !32
  %44 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !40
  store i32 %43, ptr %44, align 4, !tbaa !6
  %45 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %46 = load i32, ptr %45, align 4, !tbaa !43
  %47 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !40
  store i32 %46, ptr %47, align 4, !tbaa !6
  %48 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %49 = load i32, ptr %48, align 4, !tbaa !96
  %50 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !40
  store i32 %49, ptr %50, align 4, !tbaa !6
  %51 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !40
  store i32 %41, ptr %51, align 4, !tbaa !6
  %52 = load i32, ptr %42, align 4, !tbaa !32
  %53 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %54 = inttoptr i32 %53 to ptr
  store volatile i32 %52, ptr %54, align 4, !tbaa !6
  %55 = load i32, ptr @tickpending, align 4, !tbaa !6
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %58, label %57

57:                                               ; preds = %40
  store i32 0, ptr @tickpending, align 4, !tbaa !6
  tail call fastcc void @fire_income() #16
  br label %58

58:                                               ; preds = %57, %40
  %59 = tail call i32 @kcons_on() #17
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %70, label %61

61:                                               ; preds = %58
  %62 = load i32, ptr @fgpid, align 4, !tbaa !6
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %68, label %64

64:                                               ; preds = %61
  %65 = tail call i32 @kcons_pending() #17
  %66 = icmp eq i32 %65, 0
  br i1 %66, label %68, label %67

67:                                               ; preds = %64
  tail call fastcc void @cons_poll() #16
  br label %68

68:                                               ; preds = %67, %64, %61
  tail call void @kcons_kick() #17
  %69 = load i32, ptr %42, align 4, !tbaa !32
  tail call void @kcons_aim(i32 noundef %69) #17
  br label %70

70:                                               ; preds = %68, %58
  %71 = load i1, ptr @rearm, align 4
  br i1 %71, label %72, label %75

72:                                               ; preds = %70
  %73 = load i32, ptr @inj_treg, align 4, !tbaa !6
  %74 = inttoptr i32 %73 to ptr
  store volatile i32 1, ptr %74, align 4, !tbaa !6
  br label %75

75:                                               ; preds = %72, %70
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mount(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_umount(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kgpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kpinmux(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_syscall(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #1 {
  tail call void @dma_ktick() #16
  tail call void @dma_ksyscall() #16
  ret i32 0
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: write)
define internal fastcc void @wall_now(ptr noundef writeonly captures(none) %0, ptr noundef writeonly captures(none) %1) unnamed_addr #12 {
  %3 = load volatile i32, ptr @__dma_timerawh, align 4, !tbaa !6
  br label %4

4:                                                ; preds = %4, %2
  %5 = phi i32 [ %3, %2 ], [ %7, %4 ]
  %6 = load volatile i32, ptr @__dma_timerawl, align 4, !tbaa !6
  %7 = load volatile i32, ptr @__dma_timerawh, align 4, !tbaa !6
  %8 = icmp eq i32 %7, %5
  br i1 %8, label %9, label %4

9:                                                ; preds = %4
  store i32 %5, ptr %0, align 4, !tbaa !6
  store i32 %6, ptr %1, align 4, !tbaa !6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc_wire(i32 noundef range(i32 0, 256) %0) unnamed_addr #1 {
  %2 = tail call i32 @kcons_tx(i32 noundef %0) #17
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %9

4:                                                ; preds = %1, %4
  %5 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !6
  %6 = and i32 %5, 32
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %4, !llvm.loop !108

8:                                                ; preds = %4
  store volatile i32 %0, ptr @__dma_uart_dr, align 4, !tbaa !6
  br label %9

9:                                                ; preds = %1, %8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_putc(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_tx(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_rx() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kcons_aim(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc void @kboot_init() unnamed_addr #13 {
  %1 = alloca [8 x i8], align 1
  tail call fastcc void @wall_now(ptr noundef nonnull @wall0_hi, ptr noundef nonnull @wall0_lo) #16
  tail call void @klogts() #16
  tail call void @kconswrite(ptr noundef nonnull @.str, i32 noundef 16) #16
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %1) #15
  %2 = load i32, ptr @xv6_commit, align 4, !tbaa !6
  br label %3

3:                                                ; preds = %9, %0
  %4 = phi i32 [ 0, %0 ], [ %17, %9 ]
  %5 = icmp eq i32 %4, 7
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  call void @kconswrite(ptr noundef nonnull %1, i32 noundef 7) #16
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %1) #15
  tail call void @kconswrite(ptr noundef nonnull @.str.2, i32 noundef 48) #16
  %7 = tail call i32 @kfb_init() #17
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %18, label %19

9:                                                ; preds = %3
  %10 = shl nuw nsw i32 %4, 2
  %11 = sub nuw nsw i32 24, %10
  %12 = lshr i32 %2, %11
  %13 = and i32 %12, 15
  %14 = getelementptr inbounds nuw i8, ptr @.str.1, i32 %13
  %15 = load i8, ptr %14, align 1, !tbaa !3
  %16 = getelementptr inbounds nuw [8 x i8], ptr %1, i32 0, i32 %4
  store i8 %15, ptr %16, align 1, !tbaa !3
  %17 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !109

18:                                               ; preds = %6
  tail call void @kfbcon_reset() #17
  tail call void @klogts() #16
  tail call void @kconswrite(ptr noundef nonnull @.str.3, i32 noundef 26) #16
  br label %22

19:                                               ; preds = %6
  %20 = icmp slt i32 %7, 0
  br i1 %20, label %21, label %22

21:                                               ; preds = %19
  tail call void @klogts() #16
  tail call void @kconswrite(ptr noundef nonnull @.str.4, i32 noundef 15) #16
  br label %22

22:                                               ; preds = %19, %21, %18
  tail call void @kfs_start() #17
  tail call void @kflash_init() #17
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_init() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_on() local_unnamed_addr #8

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tick_income() unnamed_addr #1 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !6
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !6
  store i1 true, ptr @rearm, align 4
  %3 = load i32, ptr @ntimed, align 4, !tbaa !6
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %31, label %5

5:                                                ; preds = %0
  %6 = load volatile i32, ptr @__dma_timerawl, align 4, !tbaa !6
  br label %7

7:                                                ; preds = %28, %5
  %8 = phi i32 [ 0, %5 ], [ %30, %28 ]
  %9 = phi i32 [ 0, %5 ], [ %29, %28 ]
  %10 = icmp eq i32 %8, 8
  br i1 %10, label %11, label %12

11:                                               ; preds = %7
  store i32 %9, ptr @ntimed, align 4, !tbaa !6
  br label %31

12:                                               ; preds = %7
  %13 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %8
  %14 = load i32, ptr %13, align 4, !tbaa !15
  %15 = icmp eq i32 %14, 2
  br i1 %15, label %16, label %28

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %18 = load i32, ptr %17, align 4, !tbaa !19
  %19 = icmp eq i32 %18, ptrtoint (ptr @ticks to i32)
  br i1 %19, label %22, label %20

20:                                               ; preds = %16
  %21 = icmp eq i32 %18, ptrtoint (ptr @selwait_to to i32)
  br i1 %21, label %22, label %28

22:                                               ; preds = %20, %16
  %23 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %24 = load i32, ptr %23, align 4, !tbaa !64
  %25 = sub i32 %6, %24
  %26 = icmp sgt i32 %25, -1
  br i1 %26, label %27, label %28

27:                                               ; preds = %22
  store i32 0, ptr %17, align 4, !tbaa !19
  store i32 3, ptr %13, align 4, !tbaa !15
  br label %28

28:                                               ; preds = %22, %20, %12, %27
  %29 = phi i32 [ %9, %27 ], [ %9, %12 ], [ %9, %20 ], [ 1, %22 ]
  %30 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !110

31:                                               ; preds = %11, %0
  %32 = load i32, ptr @fgpid, align 4, !tbaa !6
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %38, label %34

34:                                               ; preds = %31
  %35 = tail call i32 @kcons_pending() #17
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %38, label %37

37:                                               ; preds = %34
  tail call fastcc void @cons_poll() #16
  br label %38

38:                                               ; preds = %37, %34, %31
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_pending() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kcons_kick() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_owner() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfb_setowner(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #14

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #14

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #11 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #12 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #13 = { minsize noinline nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #14 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #15 = { nounwind }
attributes #16 = { minsize nobuiltin optsize "no-builtins" }
attributes #17 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
!14 = distinct !{!14, !9, !10}
!15 = !{!16, !7, i64 0}
!16 = !{!"proc", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !7, i64 32, !7, i64 36, !7, i64 40, !7, i64 44, !7, i64 48, !7, i64 52, !7, i64 56, !7, i64 60, !7, i64 64, !7, i64 68}
!17 = !{!16, !7, i64 4}
!18 = distinct !{!18, !9, !10}
!19 = !{!16, !7, i64 12}
!20 = !{!16, !7, i64 8}
!21 = distinct !{!21, !9, !10}
!22 = distinct !{!22, !9, !10}
!23 = distinct !{!23, !9, !10}
!24 = distinct !{!24, !9, !10}
!25 = distinct !{!25, !9, !10}
!26 = !{!16, !7, i64 64}
!27 = !{!16, !7, i64 68}
!28 = !{!16, !7, i64 44}
!29 = !{!30, !7, i64 16}
!30 = !{!"dma_sysmail", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20}
!31 = !{!30, !7, i64 20}
!32 = !{!16, !7, i64 24}
!33 = !{!16, !7, i64 48}
!34 = distinct !{!34, !9, !10}
!35 = !{!30, !7, i64 4}
!36 = distinct !{!36, !9, !10}
!37 = distinct !{!37, !9, !10}
!38 = !{!16, !7, i64 32}
!39 = !{!16, !7, i64 40}
!40 = !{!41, !41, i64 0}
!41 = !{!"p1 int", !42, i64 0}
!42 = !{!"any pointer", !4, i64 0}
!43 = !{!16, !7, i64 36}
!44 = !{!16, !7, i64 20}
!45 = distinct !{!45, !9, !10}
!46 = distinct !{!46, !9, !10}
!47 = distinct !{!47, !9, !10}
!48 = !{!30, !7, i64 0}
!49 = !{!30, !7, i64 8}
!50 = !{!30, !7, i64 12}
!51 = !{!16, !7, i64 52}
!52 = !{!16, !7, i64 60}
!53 = !{!54, !54, i64 0}
!54 = !{!"p1 _ZTS4khdr", !42, i64 0}
!55 = !{!56, !7, i64 0}
!56 = !{!"khdr", !7, i64 0, !54, i64 4}
!57 = !{!56, !54, i64 4}
!58 = distinct !{!58, !9, !10}
!59 = distinct !{!59, !9, !10}
!60 = !{!16, !7, i64 56}
!61 = distinct !{!61, !9, !10}
!62 = distinct !{!62, !9, !10}
!63 = distinct !{!63, !10}
!64 = !{!16, !7, i64 16}
!65 = distinct !{!65, !9, !10}
!66 = distinct !{!66, !9, !10}
!67 = distinct !{!67, !9, !10}
!68 = !{i64 0, i64 4, !6, i64 4, i64 4, !6, i64 8, i64 4, !6, i64 12, i64 4, !6, i64 16, i64 4, !6, i64 20, i64 4, !6, i64 24, i64 4, !6, i64 28, i64 4, !6, i64 32, i64 4, !6, i64 36, i64 4, !6, i64 40, i64 4, !6, i64 44, i64 4, !6, i64 48, i64 4, !6, i64 52, i64 4, !6, i64 56, i64 4, !6, i64 60, i64 4, !6, i64 64, i64 4, !6, i64 68, i64 4, !6}
!69 = !{!70, !7, i64 28}
!70 = !{!"kimg", !4, i64 0, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !7, i64 32, !7, i64 36, !7, i64 40, !7, i64 44, !7, i64 48, !7, i64 52, !7, i64 56, !7, i64 60, !7, i64 64, !7, i64 68, !7, i64 72, !7, i64 76, !7, i64 80}
!71 = !{!70, !7, i64 32}
!72 = !{!70, !7, i64 44}
!73 = !{!70, !7, i64 48}
!74 = !{!70, !7, i64 52}
!75 = !{!70, !7, i64 56}
!76 = !{!70, !7, i64 60}
!77 = !{!70, !7, i64 64}
!78 = !{!70, !7, i64 68}
!79 = distinct !{!79, !9, !10}
!80 = !{!70, !7, i64 40}
!81 = !{!70, !7, i64 36}
!82 = !{!70, !7, i64 72}
!83 = distinct !{!83, !9, !10}
!84 = distinct !{!84, !9, !10}
!85 = !{!70, !7, i64 80}
!86 = !{!70, !7, i64 24}
!87 = !{!70, !7, i64 76}
!88 = !{!70, !7, i64 20}
!89 = !{!70, !7, i64 12}
!90 = !{!70, !7, i64 16}
!91 = distinct !{!91, !9, !10}
!92 = distinct !{!92, !10}
!93 = distinct !{!93, !9, !10}
!94 = distinct !{!94, !9, !10}
!95 = distinct !{!95, !9, !10}
!96 = !{!16, !7, i64 28}
!97 = distinct !{!97, !9, !10}
!98 = distinct !{!98, !9, !10}
!99 = distinct !{!99, !9, !10}
!100 = distinct !{!100, !9, !10}
!101 = distinct !{!101, !9, !10}
!102 = distinct !{!102, !9, !10}
!103 = distinct !{!103, !9, !10}
!104 = distinct !{!104, !9, !10}
!105 = distinct !{!105, !9, !10}
!106 = distinct !{!106, !9, !10}
!107 = distinct !{!107, !9, !10}
!108 = distinct !{!108, !9, !10}
!109 = distinct !{!109, !9, !10}
!110 = distinct !{!110, !9, !10}
