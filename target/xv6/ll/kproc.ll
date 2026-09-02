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
@__dma_timerawl = external dso_local global i32, align 4
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
@ntimed = internal unnamed_addr global i32 0, align 4
@next_us = internal unnamed_addr global i32 0, align 4

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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #17
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #17
  %5 = load i32, ptr @wall0_hi, align 4, !tbaa !6
  %6 = load i32, ptr @wall0_lo, align 4, !tbaa !6
  call fastcc void @wall_since(i32 noundef %5, i32 noundef %6, ptr noundef %1, ptr noundef %2) #18
  %7 = call fastcc i32 @us_div(ptr noundef %1, ptr noundef %2, i32 noundef 1000000) #18
  %8 = load i32, ptr %2, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %3) #17
  store i8 91, ptr %3, align 1, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %4) #17
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
  call void @kconswrite(ptr noundef nonnull %3, i32 noundef %55) #18
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %4) #17
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %3) #17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #17
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @wall_since(i32 noundef %0, i32 noundef %1, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %2, ptr noundef nonnull writeonly captures(none) initializes((0, 4)) %3) unnamed_addr #3 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #17
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #17
  call fastcc void @wall_now(ptr noundef nonnull %5, ptr noundef nonnull %6) #18
  %7 = load i32, ptr %6, align 4, !tbaa !6
  %8 = sub i32 %7, %1
  store i32 %8, ptr %3, align 4, !tbaa !6
  %9 = load i32, ptr %5, align 4, !tbaa !6
  %10 = sub i32 %9, %0
  %11 = icmp ult i32 %7, %1
  %12 = sext i1 %11 to i32
  %13 = add i32 %10, %12
  store i32 %13, ptr %2, align 4, !tbaa !6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #17
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
  tail call void @kfbcon_cursor() #19
  ret void

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %9 = load i8, ptr %8, align 1, !tbaa !3
  %10 = sext i8 %9 to i32
  tail call fastcc void @cputc(i32 noundef %10) #18
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
  tail call fastcc void @cputc_wire(i32 noundef 13) #18
  br label %4

4:                                                ; preds = %3, %1
  %5 = and i32 %0, 255
  tail call fastcc void @cputc_wire(i32 noundef %5) #18
  tail call void @kfbcon_putc(i32 noundef %0) #19
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_cursor() local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  tail call fastcc void @cons_poll() #18
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
  %8 = tail call i32 @kcons_rx() #19
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
  tail call fastcc void @cputc(i32 noundef 94) #18
  tail call fastcc void @cputc(i32 noundef 67) #18
  tail call fastcc void @cputc(i32 noundef 10) #18
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
  tail call fastcc void @terminate(ptr noundef nonnull %140, i32 noundef -1) #18
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
  tail call fastcc void @cputc(i32 noundef 8) #18
  tail call fastcc void @cputc(i32 noundef 32) #18
  tail call fastcc void @cputc(i32 noundef 8) #18
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
  tail call fastcc void @cputc(i32 noundef 94) #18
  %195 = or disjoint i32 %173, 64
  br label %196

196:                                              ; preds = %185, %194
  %197 = phi i32 [ %195, %194 ], [ %173, %185 ]
  tail call fastcc void @cputc(i32 noundef %197) #18
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
  tail call void @kfbcon_cursor() #19
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
define dso_local range(i32 9, 8) i32 @kfind_sleeper(i32 noundef %0) local_unnamed_addr #6 {
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
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #7 {
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
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #7 {
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
  tail call fastcc void @kenter() #18
  tail call fastcc void @fire_income() #18
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
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #18
  br label %17

17:                                               ; preds = %0, %9, %15, %16
  tail call fastcc void @swtch() #18
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kenter() unnamed_addr #1 {
  store i1 false, ptr @rearm, align 4
  store i1 false, ptr @tick_taken, align 4
  tail call void @kcons_aim(i32 noundef 0) #19
  %1 = load i32, ptr @fsready, align 4, !tbaa !6
  %2 = icmp eq i32 %1, 0
  %3 = load i32, ptr @dma_disk, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %2, i1 %4, i1 false
  br i1 %5, label %6, label %7

6:                                                ; preds = %0
  tail call fastcc void @kboot_init() #18
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
  tail call fastcc void @fire_income() #18
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
  tail call fastcc void @fire_income() #18
  br label %28

28:                                               ; preds = %27, %22
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fire_income() unnamed_addr #1 {
  %1 = tail call i32 @kcons_on() #19
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call fastcc void @tick_income() #18
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
  tail call fastcc void @tick_income() #18
  br label %13

13:                                               ; preds = %12, %10, %4
  %14 = load i32, ptr @fgpid, align 4, !tbaa !6
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %20, label %16

16:                                               ; preds = %13
  %17 = tail call i32 @kcons_pending() #19
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %20, label %19

19:                                               ; preds = %16
  tail call fastcc void @cons_poll() #18
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
  %14 = tail call i32 @kfb_owner() #19
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !17
  %17 = icmp eq i32 %14, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %13
  tail call void @kfb_setowner(i32 noundef 0) #19
  tail call void @kfbcon_reset() #19
  br label %19

19:                                               ; preds = %18, %13
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %20, align 4, !tbaa !44
  %21 = load i32, ptr @fsready, align 4, !tbaa !6
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %24, label %23

23:                                               ; preds = %19
  tail call void @kfs_exit(i32 noundef %5) #19
  br label %24

24:                                               ; preds = %23, %19
  tail call fastcc void @kfree_exec(i32 noundef %5) #18
  tail call fastcc void @vfork_release(ptr noundef nonnull %0) #18
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
  %2 = load i32, ptr @initpid, align 4
  br label %3

3:                                                ; preds = %17, %0
  %4 = phi i32 [ -1, %0 ], [ %18, %17 ]
  %5 = phi i32 [ 1, %0 ], [ %19, %17 ]
  %6 = icmp eq i32 %5, 9
  br i1 %6, label %20, label %7

7:                                                ; preds = %3
  %8 = add i32 %5, %1
  %9 = and i32 %8, 7
  %10 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %9
  %11 = load i32, ptr %10, align 4, !tbaa !15
  %12 = icmp eq i32 %11, 3
  br i1 %12, label %13, label %17

13:                                               ; preds = %7
  %14 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %15 = load i32, ptr %14, align 4, !tbaa !17
  %16 = icmp eq i32 %15, %2
  br i1 %16, label %17, label %72

17:                                               ; preds = %13, %7
  %18 = phi i32 [ %4, %7 ], [ %9, %13 ]
  %19 = add nuw nsw i32 %5, 1
  br label %3, !llvm.loop !47

20:                                               ; preds = %3
  %21 = icmp slt i32 %4, 0
  br i1 %21, label %22, label %72

22:                                               ; preds = %20
  %23 = load i32, ptr @entry_disp, align 4, !tbaa !6
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %31, label %25

25:                                               ; preds = %22
  %26 = inttoptr i32 %23 to ptr
  %27 = load volatile i32, ptr %26, align 4, !tbaa !6
  %28 = load i32, ptr @entry_thunk, align 4, !tbaa !6
  %29 = icmp eq i32 %27, %28
  br i1 %29, label %31, label %30

30:                                               ; preds = %25
  store volatile i32 %28, ptr %26, align 4, !tbaa !6
  tail call fastcc void @fire_income() #18
  br label %31

31:                                               ; preds = %30, %25, %22
  %32 = load volatile ptr, ptr @kw_park, align 4, !tbaa !40
  %33 = ptrtoint ptr %32 to i32
  %34 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  store i32 %33, ptr %34, align 4, !tbaa !6
  %35 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %36 = ptrtoint ptr %35 to i32
  %37 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !40
  store i32 %36, ptr %37, align 4, !tbaa !6
  %38 = load volatile ptr, ptr @kw_park, align 4, !tbaa !40
  %39 = ptrtoint ptr %38 to i32
  %40 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !40
  store i32 %39, ptr %40, align 4, !tbaa !6
  %41 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %42 = ptrtoint ptr %41 to i32
  %43 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !40
  store i32 %42, ptr %43, align 4, !tbaa !6
  %44 = load volatile ptr, ptr @kw_park, align 4, !tbaa !40
  %45 = ptrtoint ptr %44 to i32
  %46 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !40
  store i32 %45, ptr %46, align 4, !tbaa !6
  %47 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %48 = ptrtoint ptr %47 to i32
  %49 = load i32, ptr @inj_wreg, align 4, !tbaa !6
  %50 = inttoptr i32 %49 to ptr
  store volatile i32 %48, ptr %50, align 4, !tbaa !6
  store i1 true, ptr @parked, align 4
  %51 = load i32, ptr @tickpending, align 4, !tbaa !6
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %54, label %53

53:                                               ; preds = %31
  store i32 0, ptr @tickpending, align 4, !tbaa !6
  tail call fastcc void @fire_income() #18
  br label %54

54:                                               ; preds = %53, %31
  %55 = tail call i32 @kcons_on() #19
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %67, label %57

57:                                               ; preds = %54
  %58 = load i32, ptr @fgpid, align 4, !tbaa !6
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %64, label %60

60:                                               ; preds = %57
  %61 = tail call i32 @kcons_pending() #19
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %64, label %63

63:                                               ; preds = %60
  tail call fastcc void @cons_poll() #18
  br label %64

64:                                               ; preds = %63, %60, %57
  tail call void @kcons_kick() #19
  %65 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !40
  %66 = ptrtoint ptr %65 to i32
  tail call void @kcons_aim(i32 noundef %66) #19
  br label %67

67:                                               ; preds = %64, %54
  %68 = load i1, ptr @rearm, align 4
  br i1 %68, label %69, label %76

69:                                               ; preds = %67
  %70 = load i32, ptr @inj_treg, align 4, !tbaa !6
  %71 = inttoptr i32 %70 to ptr
  store volatile i32 1, ptr %71, align 4, !tbaa !6
  br label %76

72:                                               ; preds = %13, %20
  %73 = phi i32 [ %4, %20 ], [ %9, %13 ]
  %74 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %73, i32 10
  %75 = load i32, ptr %74, align 4, !tbaa !39
  tail call fastcc void @kexit(i32 noundef %73, i32 noundef %75) #18
  br label %76

76:                                               ; preds = %67, %69, %72
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #1 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %struct.kimg, align 4
  %4 = alloca [13 x i32], align 4
  %5 = alloca [64 x i32], align 4
  tail call fastcc void @kenter() #18
  %6 = load i32, ptr @curr, align 4, !tbaa !6
  %7 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %6
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 48
  %9 = load i32, ptr %8, align 4, !tbaa !33
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %12, label %11

11:                                               ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %7, i32 noundef -1) #18
  tail call fastcc void @swtch() #18
  br label %1099

12:                                               ; preds = %0
  %13 = getelementptr inbounds nuw i8, ptr %7, i32 44
  %14 = load i32, ptr %13, align 4, !tbaa !28
  %15 = inttoptr i32 %14 to ptr
  %16 = load volatile i32, ptr %15, align 4, !tbaa !48
  switch i32 %16, label %1069 [
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
    i32 34, label %309
    i32 3, label %19
    i32 1, label %412
    i32 7, label %444
    i32 2, label %793
    i32 26, label %796
    i32 27, label %805
    i32 25, label %812
    i32 35, label %900
    i32 28, label %943
    i32 29, label %952
    i32 30, label %960
    i32 31, label %966
    i32 32, label %993
    i32 23, label %1018
    i32 24, label %1023
    i32 6, label %17
  ]

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %1045

19:                                               ; preds = %12
  %20 = getelementptr inbounds nuw i8, ptr %7, i32 4
  br label %364

21:                                               ; preds = %12
  %22 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %23 = load i32, ptr %22, align 4, !tbaa !17
  br label %1069

24:                                               ; preds = %12
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #17
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #17
  %25 = load i32, ptr @wall0_hi, align 4, !tbaa !6
  %26 = load i32, ptr @wall0_lo, align 4, !tbaa !6
  call fastcc void @wall_since(i32 noundef %25, i32 noundef %26, ptr noundef %1, ptr noundef %2) #18
  %27 = call fastcc i32 @us_div(ptr noundef %1, ptr noundef %2, i32 noundef 100) #18
  %28 = load i32, ptr %2, align 4, !tbaa !6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #17
  br label %1069

29:                                               ; preds = %12
  %30 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %31 = load volatile i32, ptr %30, align 4, !tbaa !49
  %32 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %33 = load volatile i32, ptr %32, align 4, !tbaa !50
  %34 = tail call fastcc i32 @badbuf(ptr noundef nonnull %7, i32 noundef %31, i32 noundef %33) #18
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %1069

36:                                               ; preds = %29
  %37 = load i32, ptr @fsready, align 4, !tbaa !6
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %45, label %39

39:                                               ; preds = %36
  %40 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %41 = load volatile i32, ptr %40, align 4, !tbaa !35
  %42 = load volatile i32, ptr %30, align 4, !tbaa !49
  %43 = load volatile i32, ptr %32, align 4, !tbaa !50
  %44 = tail call i32 @kfs_write(i32 noundef %41, i32 noundef %42, i32 noundef %43) #19
  br label %50

45:                                               ; preds = %36
  %46 = load volatile i32, ptr %30, align 4, !tbaa !49
  %47 = inttoptr i32 %46 to ptr
  %48 = load volatile i32, ptr %32, align 4, !tbaa !50
  tail call void @kconswrite(ptr noundef %47, i32 noundef %48) #18
  %49 = load volatile i32, ptr %32, align 4, !tbaa !50
  br label %50

50:                                               ; preds = %39, %45
  %51 = phi i32 [ %44, %39 ], [ %49, %45 ]
  %52 = freeze i32 %51
  %53 = icmp eq i32 %52, -3
  br i1 %53, label %1084, label %1069

54:                                               ; preds = %12
  %55 = load i32, ptr @fsready, align 4, !tbaa !6
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %1069, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !35
  %60 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %61 = load volatile i32, ptr %60, align 4, !tbaa !49
  %62 = tail call i32 @kfs_open(i32 noundef %59, i32 noundef %61) #19
  br label %1069

63:                                               ; preds = %12
  %64 = load i32, ptr @fsready, align 4, !tbaa !6
  %65 = icmp eq i32 %64, 0
  br i1 %65, label %1069, label %66

66:                                               ; preds = %63
  %67 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %68 = load volatile i32, ptr %67, align 4, !tbaa !35
  %69 = tail call i32 @kfs_close(i32 noundef %68) #19
  br label %1069

70:                                               ; preds = %12
  %71 = load i32, ptr @fsready, align 4, !tbaa !6
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %1069, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %75 = load volatile i32, ptr %74, align 4, !tbaa !35
  %76 = tail call i32 @kfs_dup(i32 noundef %75) #19
  br label %1069

77:                                               ; preds = %12
  %78 = load i32, ptr @fsready, align 4, !tbaa !6
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %1069, label %80

80:                                               ; preds = %77
  %81 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %82 = load volatile i32, ptr %81, align 4, !tbaa !35
  %83 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %84 = load volatile i32, ptr %83, align 4, !tbaa !49
  %85 = tail call i32 @kfs_fstat(i32 noundef %82, i32 noundef %84) #19
  br label %1069

86:                                               ; preds = %12
  %87 = load i32, ptr @fsready, align 4, !tbaa !6
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %1069, label %89

89:                                               ; preds = %86
  %90 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %91 = load volatile i32, ptr %90, align 4, !tbaa !35
  %92 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %93 = load volatile i32, ptr %92, align 4, !tbaa !49
  %94 = tail call i32 @kfs_seek(i32 noundef %91, i32 noundef %93) #19
  br label %1069

95:                                               ; preds = %12
  %96 = load i32, ptr @fsready, align 4, !tbaa !6
  %97 = icmp eq i32 %96, 0
  br i1 %97, label %1069, label %98

98:                                               ; preds = %95
  %99 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %100 = load volatile i32, ptr %99, align 4, !tbaa !35
  %101 = tail call i32 @kfs_pipe(i32 noundef %100) #19
  br label %1069

102:                                              ; preds = %12
  %103 = load i32, ptr @fsready, align 4, !tbaa !6
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %1069, label %105

105:                                              ; preds = %102
  %106 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %107 = load volatile i32, ptr %106, align 4, !tbaa !35
  %108 = tail call i32 @kfs_chdir(i32 noundef %107) #19
  br label %1069

109:                                              ; preds = %12
  %110 = load i32, ptr @fsready, align 4, !tbaa !6
  %111 = icmp eq i32 %110, 0
  br i1 %111, label %1069, label %112

112:                                              ; preds = %109
  %113 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %114 = load volatile i32, ptr %113, align 4, !tbaa !35
  %115 = tail call i32 @kfs_mkdir(i32 noundef %114) #19
  br label %1069

116:                                              ; preds = %12
  %117 = load i32, ptr @fsready, align 4, !tbaa !6
  %118 = icmp eq i32 %117, 0
  br i1 %118, label %1069, label %119

119:                                              ; preds = %116
  %120 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %121 = load volatile i32, ptr %120, align 4, !tbaa !35
  %122 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %123 = load volatile i32, ptr %122, align 4, !tbaa !49
  %124 = tail call i32 @kfs_link(i32 noundef %121, i32 noundef %123) #19
  br label %1069

125:                                              ; preds = %12
  %126 = load i32, ptr @fsready, align 4, !tbaa !6
  %127 = icmp eq i32 %126, 0
  br i1 %127, label %1069, label %128

128:                                              ; preds = %125
  %129 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %130 = load volatile i32, ptr %129, align 4, !tbaa !35
  %131 = tail call i32 @kfs_unlink(i32 noundef %130) #19
  br label %1069

132:                                              ; preds = %12
  tail call void @kfb_pause() #19
  %133 = load i32, ptr @fsready, align 4, !tbaa !6
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %137, label %135

135:                                              ; preds = %132
  %136 = tail call i32 @kflash_sync() #19
  br label %137

137:                                              ; preds = %132, %135
  %138 = phi i32 [ %136, %135 ], [ -1, %132 ]
  tail call void @kfb_resume() #19
  br label %1069

139:                                              ; preds = %12
  %140 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %141 = load volatile i32, ptr %140, align 4, !tbaa !49
  %142 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %143 = load volatile i32, ptr %142, align 4, !tbaa !50
  %144 = tail call fastcc i32 @badbuf(ptr noundef nonnull %7, i32 noundef %141, i32 noundef %143) #18
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %146, label %1069

146:                                              ; preds = %139
  %147 = load i32, ptr @fsready, align 4, !tbaa !6
  %148 = icmp eq i32 %147, 0
  br i1 %148, label %155, label %149

149:                                              ; preds = %146
  %150 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %151 = load volatile i32, ptr %150, align 4, !tbaa !35
  %152 = load volatile i32, ptr %140, align 4, !tbaa !49
  %153 = load volatile i32, ptr %142, align 4, !tbaa !50
  %154 = tail call i32 @kfs_read(i32 noundef %151, i32 noundef %152, i32 noundef %153) #19
  br label %159

155:                                              ; preds = %146
  %156 = load volatile i32, ptr %140, align 4, !tbaa !49
  %157 = load volatile i32, ptr %142, align 4, !tbaa !50
  %158 = tail call i32 @kconsread(i32 noundef %156, i32 noundef %157) #18
  br label %159

159:                                              ; preds = %149, %155
  %160 = phi i32 [ %154, %149 ], [ %158, %155 ]
  %161 = freeze i32 %160
  %162 = icmp eq i32 %161, -3
  br i1 %162, label %1084, label %1069

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
  br i1 %173, label %1069, label %174

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
  br i1 %222, label %1069, label %229

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
  br i1 %244, label %1069, label %245

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
  br i1 %258, label %1069, label %259

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
  br i1 %270, label %1069, label %271

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
  %299 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %300 = load volatile i32, ptr %299, align 4, !tbaa !35
  tail call fastcc void @arm_timed(ptr noundef nonnull %7, i32 noundef %300) #18
  %301 = load i32, ptr @curr, align 4, !tbaa !6
  %302 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %301
  %303 = getelementptr inbounds nuw i8, ptr %302, i32 32
  %304 = load i32, ptr %303, align 4, !tbaa !38
  %305 = inttoptr i32 %304 to ptr
  %306 = load volatile i32, ptr %305, align 4, !tbaa !6
  %307 = getelementptr inbounds nuw i8, ptr %302, i32 40
  store i32 %306, ptr %307, align 4, !tbaa !39
  %308 = getelementptr inbounds nuw i8, ptr %302, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %308, align 4, !tbaa !19
  store i32 2, ptr %302, align 4, !tbaa !15
  br label %1084

309:                                              ; preds = %12
  %310 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %311 = load volatile i32, ptr %310, align 4, !tbaa !35
  br label %312

312:                                              ; preds = %336, %309
  %313 = phi i32 [ 0, %309 ], [ %338, %336 ]
  %314 = phi i32 [ 0, %309 ], [ %337, %336 ]
  %315 = icmp eq i32 %313, 31
  br i1 %315, label %316, label %318

316:                                              ; preds = %312
  %317 = icmp eq i32 %314, 0
  br i1 %317, label %339, label %1069

318:                                              ; preds = %312
  %319 = shl nuw nsw i32 1, %313
  %320 = and i32 %319, %311
  %321 = icmp eq i32 %320, 0
  br i1 %321, label %336, label %322

322:                                              ; preds = %318
  %323 = load i32, ptr @fsready, align 4, !tbaa !6
  %324 = icmp eq i32 %323, 0
  br i1 %324, label %328, label %325

325:                                              ; preds = %322
  %326 = tail call i32 @kfs_selready(i32 noundef %313) #19
  %327 = icmp eq i32 %326, 0
  br label %332

328:                                              ; preds = %322
  %329 = load i32, ptr @cons_r, align 4, !tbaa !6
  %330 = load i32, ptr @cons_w, align 4, !tbaa !6
  %331 = icmp eq i32 %329, %330
  br label %332

332:                                              ; preds = %328, %325
  %333 = phi i1 [ %327, %325 ], [ %331, %328 ]
  %334 = select i1 %333, i32 0, i32 %319
  %335 = or i32 %334, %314
  br label %336

336:                                              ; preds = %318, %332
  %337 = phi i32 [ %335, %332 ], [ %314, %318 ]
  %338 = add nuw nsw i32 %313, 1
  br label %312, !llvm.loop !64

339:                                              ; preds = %316
  %340 = icmp eq i32 %311, 0
  br i1 %340, label %1069, label %341

341:                                              ; preds = %339
  %342 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %343 = load volatile i32, ptr %342, align 4, !tbaa !49
  %344 = icmp eq i32 %343, 0
  br i1 %344, label %355, label %345

345:                                              ; preds = %341
  %346 = load volatile i32, ptr %342, align 4, !tbaa !49
  tail call fastcc void @arm_timed(ptr noundef nonnull %7, i32 noundef %346) #18
  %347 = load i32, ptr @curr, align 4, !tbaa !6
  %348 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %347
  %349 = getelementptr inbounds nuw i8, ptr %348, i32 32
  %350 = load i32, ptr %349, align 4, !tbaa !38
  %351 = inttoptr i32 %350 to ptr
  %352 = load volatile i32, ptr %351, align 4, !tbaa !6
  %353 = getelementptr inbounds nuw i8, ptr %348, i32 40
  store i32 %352, ptr %353, align 4, !tbaa !39
  %354 = getelementptr inbounds nuw i8, ptr %348, i32 12
  store i32 ptrtoint (ptr @selwait_to to i32), ptr %354, align 4, !tbaa !19
  store i32 2, ptr %348, align 4, !tbaa !15
  br label %1084

355:                                              ; preds = %341
  %356 = load i32, ptr @curr, align 4, !tbaa !6
  %357 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %356
  %358 = getelementptr inbounds nuw i8, ptr %357, i32 32
  %359 = load i32, ptr %358, align 4, !tbaa !38
  %360 = inttoptr i32 %359 to ptr
  %361 = load volatile i32, ptr %360, align 4, !tbaa !6
  %362 = getelementptr inbounds nuw i8, ptr %357, i32 40
  store i32 %361, ptr %362, align 4, !tbaa !39
  %363 = getelementptr inbounds nuw i8, ptr %357, i32 12
  store i32 ptrtoint (ptr @selwait_inf to i32), ptr %363, align 4, !tbaa !19
  store i32 2, ptr %357, align 4, !tbaa !15
  br label %1084

364:                                              ; preds = %19, %383
  %365 = phi i32 [ %386, %383 ], [ 0, %19 ]
  %366 = phi i32 [ %384, %383 ], [ -1, %19 ]
  %367 = phi i32 [ %385, %383 ], [ 0, %19 ]
  %368 = icmp eq i32 %365, 8
  br i1 %368, label %369, label %371

369:                                              ; preds = %364
  %370 = icmp sgt i32 %366, -1
  br i1 %370, label %387, label %400

371:                                              ; preds = %364
  %372 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %365
  %373 = load i32, ptr %372, align 4, !tbaa !15
  %374 = icmp eq i32 %373, 0
  br i1 %374, label %383, label %375

375:                                              ; preds = %371
  %376 = getelementptr inbounds nuw i8, ptr %372, i32 8
  %377 = load i32, ptr %376, align 4, !tbaa !20
  %378 = load i32, ptr %20, align 4, !tbaa !17
  %379 = icmp eq i32 %377, %378
  br i1 %379, label %380, label %383

380:                                              ; preds = %375
  %381 = icmp eq i32 %373, 5
  %382 = select i1 %381, i32 %365, i32 %366
  br label %383

383:                                              ; preds = %380, %371, %375
  %384 = phi i32 [ %366, %375 ], [ %366, %371 ], [ %382, %380 ]
  %385 = phi i32 [ %367, %375 ], [ %367, %371 ], [ 1, %380 ]
  %386 = add nuw nsw i32 %365, 1
  br label %364, !llvm.loop !65

387:                                              ; preds = %369
  %388 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %389 = load volatile i32, ptr %388, align 4, !tbaa !35
  %390 = icmp eq i32 %389, 0
  br i1 %390, label %396, label %391

391:                                              ; preds = %387
  %392 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %366, i32 5
  %393 = load i32, ptr %392, align 4, !tbaa !44
  %394 = load volatile i32, ptr %388, align 4, !tbaa !35
  %395 = inttoptr i32 %394 to ptr
  store volatile i32 %393, ptr %395, align 4, !tbaa !6
  br label %396

396:                                              ; preds = %391, %387
  %397 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %366
  %398 = getelementptr inbounds nuw i8, ptr %397, i32 4
  %399 = load i32, ptr %398, align 4, !tbaa !17
  store i32 0, ptr %397, align 4, !tbaa !15
  br label %1069

400:                                              ; preds = %369
  %401 = icmp eq i32 %367, 0
  br i1 %401, label %1069, label %402

402:                                              ; preds = %400
  %403 = ptrtoint ptr %7 to i32
  %404 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %405 = load i32, ptr %404, align 4, !tbaa !38
  %406 = inttoptr i32 %405 to ptr
  %407 = load volatile i32, ptr %406, align 4, !tbaa !6
  %408 = getelementptr inbounds nuw i8, ptr %7, i32 40
  store i32 %407, ptr %408, align 4, !tbaa !39
  %409 = getelementptr inbounds nuw i8, ptr %7, i32 12
  store i32 %403, ptr %409, align 4, !tbaa !19
  store i32 2, ptr %7, align 4, !tbaa !15
  %410 = getelementptr inbounds nuw i8, ptr %15, i32 16
  %411 = load volatile i32, ptr %410, align 4, !tbaa !29
  br label %1088

412:                                              ; preds = %12, %419
  %413 = phi i32 [ %420, %419 ], [ 0, %12 ]
  %414 = icmp eq i32 %413, 8
  br i1 %414, label %1069, label %415

415:                                              ; preds = %412
  %416 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %413
  %417 = load i32, ptr %416, align 4, !tbaa !15
  %418 = icmp eq i32 %417, 0
  br i1 %418, label %421, label %419

419:                                              ; preds = %415
  %420 = add nuw nsw i32 %413, 1
  br label %412, !llvm.loop !66

421:                                              ; preds = %415
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %416, ptr noundef nonnull align 4 dereferenceable(72) %7, i32 72, i1 false), !tbaa.struct !67
  %422 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %413
  %423 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %6
  tail call fastcc void @namecpy(ptr noundef nonnull %422, ptr noundef nonnull %423) #18
  %424 = load i32, ptr @fsready, align 4, !tbaa !6
  %425 = icmp eq i32 %424, 0
  br i1 %425, label %427, label %426

426:                                              ; preds = %421
  tail call void @kfs_forkcopy(i32 noundef %6, i32 noundef %413) #19
  br label %427

427:                                              ; preds = %426, %421
  %428 = load i32, ptr @nextpid, align 4, !tbaa !6
  %429 = add i32 %428, 1
  store i32 %429, ptr @nextpid, align 4, !tbaa !6
  %430 = getelementptr inbounds nuw i8, ptr %416, i32 4
  store i32 %428, ptr %430, align 4, !tbaa !17
  %431 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %432 = load i32, ptr %431, align 4, !tbaa !17
  %433 = getelementptr inbounds nuw i8, ptr %416, i32 8
  store i32 %432, ptr %433, align 4, !tbaa !20
  %434 = getelementptr inbounds nuw i8, ptr %416, i32 12
  store i32 0, ptr %434, align 4, !tbaa !19
  store i32 3, ptr %416, align 4, !tbaa !15
  %435 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %436 = load i32, ptr %435, align 4, !tbaa !38
  %437 = inttoptr i32 %436 to ptr
  %438 = load volatile i32, ptr %437, align 4, !tbaa !6
  %439 = getelementptr inbounds nuw i8, ptr %416, i32 40
  store i32 %438, ptr %439, align 4, !tbaa !39
  %440 = load volatile i32, ptr %437, align 4, !tbaa !6
  %441 = getelementptr inbounds nuw i8, ptr %7, i32 40
  store i32 %440, ptr %441, align 4, !tbaa !39
  %442 = ptrtoint ptr %416 to i32
  %443 = getelementptr inbounds nuw i8, ptr %7, i32 12
  store i32 %442, ptr %443, align 4, !tbaa !19
  store i32 2, ptr %7, align 4, !tbaa !15
  br label %1088

444:                                              ; preds = %12
  call void @llvm.lifetime.start.p0(i64 84, ptr nonnull %3) #17
  %445 = load i32, ptr @fsready, align 4, !tbaa !6
  %446 = icmp eq i32 %445, 0
  br i1 %446, label %546, label %447

447:                                              ; preds = %444
  %448 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %449 = load volatile i32, ptr %448, align 4, !tbaa !35
  %450 = inttoptr i32 %449 to ptr
  %451 = tail call i32 @kfs_iopen(ptr noundef %450) #19
  %452 = icmp eq i32 %451, 0
  br i1 %452, label %546, label %453

453:                                              ; preds = %447
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %4) #17
  %454 = ptrtoint ptr %4 to i32
  %455 = call i32 @kfs_iread(i32 noundef %451, i32 noundef 0, i32 noundef %454, i32 noundef 52) #19
  %456 = icmp eq i32 %455, 52
  %457 = load i32, ptr %4, align 4
  %458 = icmp eq i32 %457, 1480674628
  %459 = select i1 %456, i1 %458, i1 false
  br i1 %459, label %460, label %542

460:                                              ; preds = %453
  %461 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %462 = load i32, ptr %461, align 4, !tbaa !6
  %463 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %464 = load i32, ptr %463, align 4, !tbaa !6
  %465 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %466 = load i32, ptr %465, align 4, !tbaa !6
  %467 = getelementptr inbounds nuw i8, ptr %3, i32 28
  store i32 %466, ptr %467, align 4, !tbaa !68
  %468 = getelementptr inbounds nuw i8, ptr %4, i32 16
  %469 = load i32, ptr %468, align 4, !tbaa !6
  %470 = getelementptr inbounds nuw i8, ptr %3, i32 32
  store i32 %469, ptr %470, align 4, !tbaa !70
  %471 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %472 = load i32, ptr %471, align 4, !tbaa !6
  %473 = getelementptr inbounds nuw i8, ptr %3, i32 40
  %474 = getelementptr inbounds nuw i8, ptr %4, i32 24
  %475 = load i32, ptr %474, align 4, !tbaa !6
  %476 = getelementptr inbounds nuw i8, ptr %3, i32 44
  store i32 %475, ptr %476, align 4, !tbaa !71
  %477 = getelementptr inbounds nuw i8, ptr %4, i32 28
  %478 = load i32, ptr %477, align 4, !tbaa !6
  %479 = getelementptr inbounds nuw i8, ptr %3, i32 48
  store i32 %478, ptr %479, align 4, !tbaa !72
  %480 = getelementptr inbounds nuw i8, ptr %4, i32 32
  %481 = load i32, ptr %480, align 4, !tbaa !6
  %482 = getelementptr inbounds nuw i8, ptr %3, i32 52
  store i32 %481, ptr %482, align 4, !tbaa !73
  %483 = getelementptr inbounds nuw i8, ptr %4, i32 36
  %484 = load i32, ptr %483, align 4, !tbaa !6
  %485 = getelementptr inbounds nuw i8, ptr %3, i32 56
  store i32 %484, ptr %485, align 4, !tbaa !74
  %486 = getelementptr inbounds nuw i8, ptr %4, i32 40
  %487 = load i32, ptr %486, align 4, !tbaa !6
  %488 = getelementptr inbounds nuw i8, ptr %3, i32 60
  store i32 %487, ptr %488, align 4, !tbaa !75
  %489 = getelementptr inbounds nuw i8, ptr %4, i32 44
  %490 = load i32, ptr %489, align 4, !tbaa !6
  %491 = getelementptr inbounds nuw i8, ptr %3, i32 64
  store i32 %490, ptr %491, align 4, !tbaa !76
  %492 = getelementptr inbounds nuw i8, ptr %4, i32 48
  %493 = load i32, ptr %492, align 4, !tbaa !6
  %494 = getelementptr inbounds nuw i8, ptr %3, i32 68
  store i32 %493, ptr %494, align 4, !tbaa !77
  %495 = call fastcc i32 @kalloc(i32 noundef %462) #18
  %496 = call fastcc i32 @kalloc(i32 noundef %464) #18
  %497 = add i32 %462, 52
  %498 = add i32 %464, %497
  %499 = icmp ne i32 %495, 0
  %500 = icmp ne i32 %496, 0
  %501 = select i1 %499, i1 %500, i1 false
  br i1 %501, label %502, label %508

502:                                              ; preds = %460
  %503 = call i32 @kfs_iread(i32 noundef %451, i32 noundef 52, i32 noundef %495, i32 noundef %462) #19
  %504 = icmp eq i32 %503, %462
  br i1 %504, label %505, label %508

505:                                              ; preds = %502
  %506 = call i32 @kfs_iread(i32 noundef %451, i32 noundef %497, i32 noundef %496, i32 noundef %464) #19
  %507 = icmp eq i32 %506, %464
  br i1 %507, label %509, label %508

508:                                              ; preds = %505, %502, %460
  call fastcc void @kfree(i32 noundef %495) #18
  call fastcc void @kfree(i32 noundef %496) #18
  br label %542

509:                                              ; preds = %505
  %510 = sub i32 %495, %466
  %511 = sub i32 %496, %469
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %5) #17
  %512 = ptrtoint ptr %5 to i32
  br label %513

513:                                              ; preds = %539, %509
  %514 = phi i32 [ %498, %509 ], [ %541, %539 ]
  %515 = phi i32 [ %472, %509 ], [ %540, %539 ]
  %516 = icmp eq i32 %515, 0
  br i1 %516, label %543, label %517

517:                                              ; preds = %513
  %518 = call i32 @llvm.umin.i32(i32 %515, i32 64)
  %519 = shl nuw nsw i32 %518, 2
  %520 = call i32 @kfs_iread(i32 noundef %451, i32 noundef %514, i32 noundef %512, i32 noundef %519) #19
  %521 = icmp eq i32 %520, %519
  br i1 %521, label %522, label %543

522:                                              ; preds = %517, %525
  %523 = phi i32 [ %538, %525 ], [ 0, %517 ]
  %524 = icmp eq i32 %523, %518
  br i1 %524, label %539, label %525

525:                                              ; preds = %522
  %526 = getelementptr inbounds nuw [64 x i32], ptr %5, i32 0, i32 %523
  %527 = load i32, ptr %526, align 4, !tbaa !6
  %528 = icmp slt i32 %527, 0
  %529 = select i1 %528, i32 %496, i32 %495
  %530 = and i32 %527, 1073741823
  %531 = add i32 %529, %530
  %532 = and i32 %527, 1073741824
  %533 = icmp eq i32 %532, 0
  %534 = select i1 %533, i32 %510, i32 %511
  %535 = inttoptr i32 %531 to ptr
  %536 = load volatile i32, ptr %535, align 4, !tbaa !6
  %537 = add i32 %534, %536
  store volatile i32 %537, ptr %535, align 4, !tbaa !6
  %538 = add nuw nsw i32 %523, 1
  br label %522, !llvm.loop !78

539:                                              ; preds = %522
  %540 = sub i32 %515, %518
  %541 = add i32 %519, %514
  br label %513

542:                                              ; preds = %453, %508
  call void @kfs_iclose(i32 noundef %451) #19
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %4) #17
  br label %786

543:                                              ; preds = %517, %513
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %5) #17
  call void @kfs_iclose(i32 noundef %451) #19
  store i32 0, ptr %473, align 4, !tbaa !79
  %544 = getelementptr inbounds nuw i8, ptr %3, i32 36
  store i32 0, ptr %544, align 4, !tbaa !80
  %545 = getelementptr inbounds nuw i8, ptr %3, i32 72
  store i32 0, ptr %545, align 4, !tbaa !81
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %4) #17
  br label %620

546:                                              ; preds = %444, %447
  %547 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %548 = load volatile i32, ptr %547, align 4, !tbaa !35
  %549 = inttoptr i32 %548 to ptr
  br label %550

550:                                              ; preds = %569, %546
  %551 = phi i32 [ 0, %546 ], [ %570, %569 ]
  %552 = icmp eq i32 %551, 24
  br i1 %552, label %786, label %553

553:                                              ; preds = %550
  %554 = getelementptr inbounds nuw [24 x %struct.kimg], ptr @kimages, i32 0, i32 %551
  %555 = load i8, ptr %554, align 4, !tbaa !3
  %556 = icmp eq i8 %555, 0
  br i1 %556, label %786, label %557

557:                                              ; preds = %553, %566
  %558 = phi i32 [ %568, %566 ], [ 0, %553 ]
  %559 = icmp eq i32 %558, 12
  br i1 %559, label %571, label %560

560:                                              ; preds = %557
  %561 = getelementptr inbounds nuw [12 x i8], ptr %554, i32 0, i32 %558
  %562 = load i8, ptr %561, align 1, !tbaa !3
  %563 = getelementptr inbounds nuw i8, ptr %549, i32 %558
  %564 = load i8, ptr %563, align 1, !tbaa !3
  %565 = icmp eq i8 %562, %564
  br i1 %565, label %566, label %569

566:                                              ; preds = %560
  %567 = icmp eq i8 %562, 0
  %568 = add nuw nsw i32 %558, 1
  br i1 %567, label %571, label %557, !llvm.loop !82

569:                                              ; preds = %560
  %570 = add nuw nsw i32 %551, 1
  br label %550, !llvm.loop !83

571:                                              ; preds = %566, %557
  %572 = getelementptr inbounds nuw i8, ptr %554, i32 72
  %573 = load i32, ptr %572, align 4, !tbaa !81
  %574 = icmp eq i32 %573, 0
  br i1 %574, label %598, label %575

575:                                              ; preds = %571
  %576 = getelementptr inbounds nuw i8, ptr %554, i32 80
  %577 = load i32, ptr %576, align 4, !tbaa !84
  %578 = add i32 %577, 7
  %579 = and i32 %578, -8
  %580 = getelementptr inbounds nuw i8, ptr %554, i32 24
  %581 = load i32, ptr %580, align 4, !tbaa !85
  %582 = add i32 %579, %581
  %583 = tail call fastcc i32 @kalloc(i32 noundef %582) #18
  %584 = load i32, ptr %572, align 4, !tbaa !81
  %585 = icmp eq i32 %583, %584
  br i1 %585, label %586, label %597

586:                                              ; preds = %575
  %587 = getelementptr inbounds nuw i8, ptr %554, i32 76
  %588 = load i32, ptr %587, align 4, !tbaa !86
  tail call void @kdmacpy(i32 noundef %583, i32 noundef %588, i32 noundef %579) #19
  %589 = add i32 %583, %579
  %590 = getelementptr inbounds nuw i8, ptr %554, i32 20
  %591 = load i32, ptr %590, align 4, !tbaa !87
  %592 = load i32, ptr %580, align 4, !tbaa !85
  %593 = add i32 %592, 3
  %594 = and i32 %593, -4
  tail call void @kdmacpy(i32 noundef %589, i32 noundef %591, i32 noundef %594) #19
  %595 = getelementptr inbounds nuw i8, ptr %554, i32 12
  %596 = load i32, ptr %595, align 4, !tbaa !88
  br label %620

597:                                              ; preds = %575
  tail call fastcc void @kfree(i32 noundef %583) #18
  br label %786

598:                                              ; preds = %571
  %599 = getelementptr inbounds nuw i8, ptr %554, i32 16
  %600 = load i32, ptr %599, align 4, !tbaa !89
  %601 = tail call fastcc i32 @kalloc(i32 noundef %600) #18
  %602 = getelementptr inbounds nuw i8, ptr %554, i32 24
  %603 = load i32, ptr %602, align 4, !tbaa !85
  %604 = tail call fastcc i32 @kalloc(i32 noundef %603) #18
  %605 = icmp ne i32 %601, 0
  %606 = icmp ne i32 %604, 0
  %607 = select i1 %605, i1 %606, i1 false
  br i1 %607, label %609, label %608

608:                                              ; preds = %598
  tail call fastcc void @kfree(i32 noundef %601) #18
  tail call fastcc void @kfree(i32 noundef %604) #18
  br label %786

609:                                              ; preds = %598
  %610 = getelementptr inbounds nuw i8, ptr %554, i32 12
  %611 = load i32, ptr %610, align 4, !tbaa !88
  %612 = load i32, ptr %599, align 4, !tbaa !89
  %613 = add i32 %612, 3
  %614 = and i32 %613, -4
  tail call void @kdmacpy(i32 noundef %601, i32 noundef %611, i32 noundef %614) #19
  %615 = getelementptr inbounds nuw i8, ptr %554, i32 20
  %616 = load i32, ptr %615, align 4, !tbaa !87
  %617 = load i32, ptr %602, align 4, !tbaa !85
  %618 = add i32 %617, 3
  %619 = and i32 %618, -4
  tail call void @kdmacpy(i32 noundef %604, i32 noundef %616, i32 noundef %619) #19
  br label %620

620:                                              ; preds = %586, %543, %609
  %621 = phi i32 [ %496, %543 ], [ %604, %609 ], [ %589, %586 ]
  %622 = phi i32 [ %495, %543 ], [ %601, %609 ], [ %596, %586 ]
  %623 = phi ptr [ %3, %543 ], [ %554, %609 ], [ %554, %586 ]
  %624 = getelementptr inbounds nuw i8, ptr %623, i32 28
  %625 = load i32, ptr %624, align 4, !tbaa !68
  %626 = sub i32 %622, %625
  %627 = getelementptr inbounds nuw i8, ptr %623, i32 32
  %628 = load i32, ptr %627, align 4, !tbaa !70
  %629 = sub i32 %621, %628
  %630 = getelementptr inbounds nuw i8, ptr %623, i32 36
  %631 = load i32, ptr %630, align 4, !tbaa !80
  %632 = inttoptr i32 %631 to ptr
  %633 = getelementptr inbounds nuw i8, ptr %623, i32 40
  br label %634

634:                                              ; preds = %678, %620
  %635 = phi i32 [ 0, %620 ], [ %691, %678 ]
  %636 = load i32, ptr %633, align 4, !tbaa !79
  %637 = icmp ult i32 %635, %636
  br i1 %637, label %678, label %638

638:                                              ; preds = %634
  %639 = getelementptr inbounds nuw i8, ptr %7, i32 52
  %640 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %641 = getelementptr inbounds nuw i8, ptr %7, i32 60
  br label %642

642:                                              ; preds = %658, %638
  %643 = phi ptr [ %7, %638 ], [ %649, %658 ]
  %644 = ptrtoint ptr %643 to i32
  br label %645

645:                                              ; preds = %656, %642
  %646 = phi i32 [ 0, %642 ], [ %657, %656 ]
  %647 = icmp eq i32 %646, 8
  br i1 %647, label %665, label %648

648:                                              ; preds = %645
  %649 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %646
  %650 = load i32, ptr %649, align 4, !tbaa !15
  %651 = icmp eq i32 %650, 2
  br i1 %651, label %652, label %656

652:                                              ; preds = %648
  %653 = getelementptr inbounds nuw i8, ptr %649, i32 12
  %654 = load i32, ptr %653, align 4, !tbaa !19
  %655 = icmp eq i32 %654, %644
  br i1 %655, label %658, label %656

656:                                              ; preds = %652, %648
  %657 = add nuw nsw i32 %646, 1
  br label %645, !llvm.loop !90

658:                                              ; preds = %652
  %659 = load i32, ptr %639, align 4, !tbaa !51
  %660 = getelementptr inbounds nuw i8, ptr %649, i32 52
  store i32 %659, ptr %660, align 4, !tbaa !51
  %661 = load i32, ptr %640, align 4, !tbaa !60
  %662 = getelementptr inbounds nuw i8, ptr %649, i32 56
  store i32 %661, ptr %662, align 4, !tbaa !60
  %663 = load i32, ptr %641, align 4, !tbaa !52
  %664 = getelementptr inbounds nuw i8, ptr %649, i32 60
  store i32 %663, ptr %664, align 4, !tbaa !52
  br label %642, !llvm.loop !91

665:                                              ; preds = %645
  %666 = load i32, ptr @curr, align 4, !tbaa !6
  call fastcc void @kfree_exec(i32 noundef %666) #18
  %667 = getelementptr inbounds nuw i8, ptr %623, i32 72
  %668 = load i32, ptr %667, align 4, !tbaa !81
  %669 = icmp eq i32 %668, 0
  %670 = load i32, ptr @curr, align 4, !tbaa !6
  %671 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %670
  %672 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %670, i32 1
  %673 = select i1 %669, i32 %622, i32 0
  %674 = select i1 %669, i32 %621, i32 %668
  store i32 %673, ptr %671, align 4, !tbaa !6
  store i32 %674, ptr %672, align 4, !tbaa !6
  %675 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %676 = load volatile i32, ptr %675, align 4, !tbaa !49
  %677 = icmp eq i32 %676, 0
  br i1 %677, label %733, label %692

678:                                              ; preds = %634
  %679 = getelementptr inbounds nuw i32, ptr %632, i32 %635
  %680 = load i32, ptr %679, align 4, !tbaa !6
  %681 = icmp slt i32 %680, 0
  %682 = select i1 %681, i32 %621, i32 %622
  %683 = and i32 %680, 1073741823
  %684 = add i32 %682, %683
  %685 = and i32 %680, 1073741824
  %686 = icmp eq i32 %685, 0
  %687 = select i1 %686, i32 %626, i32 %629
  %688 = inttoptr i32 %684 to ptr
  %689 = load volatile i32, ptr %688, align 4, !tbaa !6
  %690 = add i32 %687, %689
  store volatile i32 %690, ptr %688, align 4, !tbaa !6
  %691 = add nuw i32 %635, 1
  br label %634, !llvm.loop !92

692:                                              ; preds = %665
  %693 = call fastcc i32 @kalloc(i32 noundef 256) #18
  %694 = icmp eq i32 %693, 0
  br i1 %694, label %733, label %695

695:                                              ; preds = %692
  %696 = load volatile i32, ptr %675, align 4, !tbaa !49
  %697 = inttoptr i32 %696 to ptr
  %698 = inttoptr i32 %693 to ptr
  %699 = add i32 %693, 64
  %700 = inttoptr i32 %699 to ptr
  %701 = add i32 %693, 256
  %702 = inttoptr i32 %701 to ptr
  %703 = getelementptr inbounds i8, ptr %702, i32 -1
  br label %704

704:                                              ; preds = %726, %695
  %705 = phi i32 [ 0, %695 ], [ %728, %726 ]
  %706 = phi ptr [ %700, %695 ], [ %727, %726 ]
  %707 = icmp eq i32 %705, 15
  br i1 %707, label %729, label %708

708:                                              ; preds = %704
  %709 = getelementptr inbounds nuw i32, ptr %697, i32 %705
  %710 = load i32, ptr %709, align 4, !tbaa !6
  %711 = icmp eq i32 %710, 0
  br i1 %711, label %729, label %712

712:                                              ; preds = %708
  %713 = inttoptr i32 %710 to ptr
  %714 = ptrtoint ptr %706 to i32
  %715 = getelementptr inbounds nuw i32, ptr %698, i32 %705
  store i32 %714, ptr %715, align 4, !tbaa !6
  br label %716

716:                                              ; preds = %723, %712
  %717 = phi ptr [ %706, %712 ], [ %725, %723 ]
  %718 = phi ptr [ %713, %712 ], [ %724, %723 ]
  %719 = load i8, ptr %718, align 1, !tbaa !3
  %720 = icmp ne i8 %719, 0
  %721 = icmp ult ptr %717, %703
  %722 = select i1 %720, i1 %721, i1 false
  br i1 %722, label %723, label %726

723:                                              ; preds = %716
  %724 = getelementptr inbounds nuw i8, ptr %718, i32 1
  %725 = getelementptr inbounds nuw i8, ptr %717, i32 1
  store i8 %719, ptr %717, align 1, !tbaa !3
  br label %716, !llvm.loop !93

726:                                              ; preds = %716
  %727 = getelementptr inbounds nuw i8, ptr %717, i32 1
  store i8 0, ptr %717, align 1, !tbaa !3
  %728 = add nuw nsw i32 %705, 1
  br label %704, !llvm.loop !94

729:                                              ; preds = %704, %708
  %730 = getelementptr inbounds nuw i32, ptr %698, i32 %705
  store i32 0, ptr %730, align 4, !tbaa !6
  %731 = load i32, ptr @curr, align 4, !tbaa !6
  %732 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %731, i32 2
  store i32 %693, ptr %732, align 4, !tbaa !6
  br label %733

733:                                              ; preds = %692, %729, %665
  %734 = phi i32 [ 0, %665 ], [ %705, %729 ], [ 0, %692 ]
  %735 = phi i32 [ 0, %665 ], [ %693, %729 ], [ 0, %692 ]
  %736 = getelementptr inbounds nuw i8, ptr %623, i32 52
  %737 = load i32, ptr %736, align 4, !tbaa !73
  %738 = add i32 %737, %621
  %739 = getelementptr inbounds nuw i8, ptr %7, i32 24
  store i32 %738, ptr %739, align 4, !tbaa !32
  %740 = getelementptr inbounds nuw i8, ptr %623, i32 56
  %741 = load i32, ptr %740, align 4, !tbaa !74
  %742 = add i32 %741, %621
  %743 = getelementptr inbounds nuw i8, ptr %7, i32 28
  store i32 %742, ptr %743, align 4, !tbaa !95
  %744 = getelementptr inbounds nuw i8, ptr %623, i32 60
  %745 = load i32, ptr %744, align 4, !tbaa !75
  %746 = add i32 %745, %621
  %747 = getelementptr inbounds nuw i8, ptr %7, i32 32
  store i32 %746, ptr %747, align 4, !tbaa !38
  %748 = getelementptr inbounds nuw i8, ptr %623, i32 48
  %749 = load i32, ptr %748, align 4, !tbaa !72
  %750 = add i32 %749, %622
  %751 = getelementptr inbounds nuw i8, ptr %7, i32 36
  store i32 %750, ptr %751, align 4, !tbaa !43
  %752 = getelementptr inbounds nuw i8, ptr %623, i32 64
  %753 = load i32, ptr %752, align 4, !tbaa !76
  %754 = add i32 %753, %621
  store i32 %754, ptr %13, align 4, !tbaa !28
  %755 = load i32, ptr @k_sysentry, align 4, !tbaa !6
  %756 = getelementptr inbounds nuw i8, ptr %623, i32 68
  %757 = load i32, ptr %756, align 4, !tbaa !77
  %758 = add i32 %757, %621
  %759 = inttoptr i32 %758 to ptr
  store volatile i32 %755, ptr %759, align 4, !tbaa !6
  %760 = load i32, ptr %751, align 4, !tbaa !43
  %761 = load i32, ptr %739, align 4, !tbaa !32
  %762 = inttoptr i32 %761 to ptr
  store volatile i32 %760, ptr %762, align 4, !tbaa !6
  %763 = load i32, ptr %736, align 4, !tbaa !73
  %764 = add i32 %763, %621
  %765 = add i32 %764, -84
  %766 = inttoptr i32 %765 to ptr
  store volatile i32 %734, ptr %766, align 4, !tbaa !6
  %767 = add i32 %764, -80
  %768 = inttoptr i32 %767 to ptr
  store volatile i32 %735, ptr %768, align 4, !tbaa !6
  %769 = load i32, ptr @curr, align 4, !tbaa !6
  %770 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %769
  %771 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %772 = load volatile i32, ptr %771, align 4, !tbaa !35
  %773 = inttoptr i32 %772 to ptr
  br label %774

774:                                              ; preds = %783, %733
  %775 = phi i32 [ 0, %733 ], [ %784, %783 ]
  %776 = phi ptr [ %773, %733 ], [ %785, %783 ]
  %777 = load i8, ptr %776, align 1, !tbaa !3
  switch i8 %777, label %778 [
    i8 0, label %787
    i8 47, label %783
  ]

778:                                              ; preds = %774
  %779 = icmp slt i32 %775, 11
  br i1 %779, label %780, label %783

780:                                              ; preds = %778
  %781 = add nsw i32 %775, 1
  %782 = getelementptr inbounds i8, ptr %770, i32 %775
  store i8 %777, ptr %782, align 1, !tbaa !3
  br label %783

783:                                              ; preds = %774, %780, %778
  %784 = phi i32 [ %781, %780 ], [ %775, %778 ], [ 0, %774 ]
  %785 = getelementptr inbounds nuw i8, ptr %776, i32 1
  br label %774, !llvm.loop !96

786:                                              ; preds = %550, %553, %597, %608, %542
  call void @llvm.lifetime.end.p0(i64 84, ptr nonnull %3) #17
  br label %1069

787:                                              ; preds = %774
  %788 = getelementptr inbounds i8, ptr %770, i32 %775
  store i8 0, ptr %788, align 1, !tbaa !3
  call fastcc void @vfork_release(ptr noundef nonnull %7) #18
  store i32 4, ptr %7, align 4, !tbaa !15
  %789 = load i32, ptr @curr, align 4, !tbaa !6
  %790 = getelementptr inbounds nuw i8, ptr %623, i32 44
  %791 = load i32, ptr %790, align 4, !tbaa !71
  %792 = add i32 %791, %622
  call fastcc void @kexit(i32 noundef %789, i32 noundef %792) #18
  call void @llvm.lifetime.end.p0(i64 84, ptr nonnull %3) #17
  br label %1099

793:                                              ; preds = %12
  %794 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %795 = load volatile i32, ptr %794, align 4, !tbaa !35
  tail call fastcc void @terminate(ptr noundef nonnull %7, i32 noundef %795) #18
  br label %1084

796:                                              ; preds = %12
  %797 = load i32, ptr @fsready, align 4, !tbaa !6
  %798 = icmp eq i32 %797, 0
  br i1 %798, label %1069, label %799

799:                                              ; preds = %796
  %800 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %801 = load volatile i32, ptr %800, align 4, !tbaa !35
  %802 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %803 = load volatile i32, ptr %802, align 4, !tbaa !49
  %804 = tail call i32 @kfs_mount(i32 noundef %801, i32 noundef %803) #19
  br label %1069

805:                                              ; preds = %12
  %806 = load i32, ptr @fsready, align 4, !tbaa !6
  %807 = icmp eq i32 %806, 0
  br i1 %807, label %1069, label %808

808:                                              ; preds = %805
  %809 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %810 = load volatile i32, ptr %809, align 4, !tbaa !35
  %811 = tail call i32 @kfs_umount(i32 noundef %810) #19
  br label %1069

812:                                              ; preds = %12
  %813 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %814 = load volatile i32, ptr %813, align 4, !tbaa !35
  %815 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %816 = load i32, ptr %815, align 4, !tbaa !60
  %817 = icmp ult i32 %814, %816
  br i1 %817, label %818, label %825

818:                                              ; preds = %812
  %819 = add i32 %814, 32
  %820 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %821 = load i32, ptr %820, align 4, !tbaa !52
  %822 = icmp ugt i32 %819, %821
  br i1 %822, label %823, label %825

823:                                              ; preds = %818
  %824 = icmp ugt i32 %814, -33
  br i1 %824, label %825, label %1069

825:                                              ; preds = %812, %818, %823
  %826 = load volatile i32, ptr %813, align 4, !tbaa !35
  %827 = inttoptr i32 %826 to ptr
  %828 = load i32, ptr @arena_end, align 4, !tbaa !6
  %829 = load i32, ptr @arena, align 4, !tbaa !6
  %830 = sub i32 %828, %829
  store i32 %830, ptr %827, align 4, !tbaa !6
  %831 = getelementptr inbounds nuw i8, ptr %827, i32 4
  store i32 0, ptr %831, align 4, !tbaa !6
  %832 = getelementptr inbounds nuw i8, ptr %827, i32 8
  store i32 0, ptr %832, align 4, !tbaa !6
  %833 = load i1, ptr @kheap_init, align 4
  br i1 %833, label %835, label %834

834:                                              ; preds = %825
  store i32 %830, ptr %832, align 4, !tbaa !6
  store i32 %830, ptr %831, align 4, !tbaa !6
  br label %850

835:                                              ; preds = %825, %847
  %836 = phi i32 [ %848, %847 ], [ 0, %825 ]
  %837 = phi i32 [ %843, %847 ], [ 0, %825 ]
  %838 = phi ptr [ %849, %847 ], [ @kfreelist, %825 ]
  %839 = load ptr, ptr %838, align 4, !tbaa !53
  %840 = icmp eq ptr %839, null
  br i1 %840, label %850, label %841

841:                                              ; preds = %835
  %842 = load i32, ptr %839, align 4, !tbaa !55
  %843 = add i32 %837, %842
  store i32 %843, ptr %831, align 4, !tbaa !6
  %844 = load i32, ptr %839, align 4, !tbaa !55
  %845 = icmp ugt i32 %844, %836
  br i1 %845, label %846, label %847

846:                                              ; preds = %841
  store i32 %844, ptr %832, align 4, !tbaa !6
  br label %847

847:                                              ; preds = %841, %846
  %848 = phi i32 [ %836, %841 ], [ %844, %846 ]
  %849 = getelementptr inbounds nuw i8, ptr %839, i32 4
  br label %835, !llvm.loop !97

850:                                              ; preds = %835, %834
  %851 = getelementptr inbounds nuw i8, ptr %827, i32 20
  store i32 0, ptr %851, align 4, !tbaa !6
  %852 = getelementptr inbounds nuw i8, ptr %827, i32 16
  store i32 0, ptr %852, align 4, !tbaa !6
  %853 = getelementptr inbounds nuw i8, ptr %827, i32 12
  store i32 0, ptr %853, align 4, !tbaa !6
  br label %854

854:                                              ; preds = %897, %850
  %855 = phi i32 [ 0, %850 ], [ %876, %897 ]
  %856 = phi i32 [ 0, %850 ], [ %898, %897 ]
  %857 = phi i32 [ 0, %850 ], [ %874, %897 ]
  %858 = phi i32 [ 0, %850 ], [ %899, %897 ]
  %859 = icmp eq i32 %858, 8
  br i1 %859, label %860, label %864

860:                                              ; preds = %854
  %861 = getelementptr inbounds nuw i8, ptr %827, i32 24
  store i32 8, ptr %861, align 4, !tbaa !6
  %862 = load i32, ptr @ticks, align 4, !tbaa !6
  %863 = getelementptr inbounds nuw i8, ptr %827, i32 28
  store i32 %862, ptr %863, align 4, !tbaa !6
  br label %1069

864:                                              ; preds = %854
  %865 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %858
  %866 = load i32, ptr %865, align 4, !tbaa !6
  %867 = icmp eq i32 %866, 0
  br i1 %867, label %873, label %868

868:                                              ; preds = %864
  %869 = add i32 %866, -256
  %870 = inttoptr i32 %869 to ptr
  %871 = load volatile i32, ptr %870, align 4, !tbaa !6
  %872 = add i32 %857, %871
  store i32 %872, ptr %853, align 4, !tbaa !6
  br label %873

873:                                              ; preds = %868, %864
  %874 = phi i32 [ %872, %868 ], [ %857, %864 ]
  br label %875

875:                                              ; preds = %892, %873
  %876 = phi i32 [ %855, %873 ], [ %893, %892 ]
  %877 = phi i32 [ 0, %873 ], [ %894, %892 ]
  %878 = icmp eq i32 %877, 3
  br i1 %878, label %879, label %883

879:                                              ; preds = %875
  %880 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %858
  %881 = load i32, ptr %880, align 4, !tbaa !15
  %882 = icmp eq i32 %881, 0
  br i1 %882, label %897, label %895

883:                                              ; preds = %875
  %884 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %858, i32 %877
  %885 = load i32, ptr %884, align 4, !tbaa !6
  %886 = icmp eq i32 %885, 0
  br i1 %886, label %892, label %887

887:                                              ; preds = %883
  %888 = add i32 %885, -256
  %889 = inttoptr i32 %888 to ptr
  %890 = load volatile i32, ptr %889, align 4, !tbaa !6
  %891 = add i32 %876, %890
  store i32 %891, ptr %852, align 4, !tbaa !6
  br label %892

892:                                              ; preds = %883, %887
  %893 = phi i32 [ %876, %883 ], [ %891, %887 ]
  %894 = add nuw nsw i32 %877, 1
  br label %875, !llvm.loop !98

895:                                              ; preds = %879
  %896 = add i32 %856, 1
  store i32 %896, ptr %851, align 4, !tbaa !6
  br label %897

897:                                              ; preds = %879, %895
  %898 = phi i32 [ %856, %879 ], [ %896, %895 ]
  %899 = add nuw nsw i32 %858, 1
  br label %854, !llvm.loop !99

900:                                              ; preds = %12
  %901 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %902 = load volatile i32, ptr %901, align 4, !tbaa !49
  %903 = icmp ugt i32 %902, 8
  br i1 %903, label %906, label %904

904:                                              ; preds = %900
  %905 = load volatile i32, ptr %901, align 4, !tbaa !49
  br label %906

906:                                              ; preds = %900, %904
  %907 = phi i32 [ %905, %904 ], [ 8, %900 ]
  %908 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %909 = load volatile i32, ptr %908, align 4, !tbaa !35
  %910 = mul i32 %907, 24
  %911 = tail call fastcc i32 @badbuf(ptr noundef nonnull %7, i32 noundef %909, i32 noundef %910) #18
  %912 = icmp eq i32 %911, 0
  br i1 %912, label %913, label %1069

913:                                              ; preds = %906
  %914 = load volatile i32, ptr %908, align 4, !tbaa !35
  %915 = inttoptr i32 %914 to ptr
  br label %916

916:                                              ; preds = %939, %913
  %917 = phi ptr [ %915, %913 ], [ %940, %939 ]
  %918 = phi i32 [ 0, %913 ], [ %941, %939 ]
  %919 = phi i32 [ 0, %913 ], [ %942, %939 ]
  %920 = icmp samesign ult i32 %919, 8
  %921 = icmp ult i32 %918, %907
  %922 = select i1 %920, i1 %921, i1 false
  br i1 %922, label %923, label %1069

923:                                              ; preds = %916
  %924 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %919
  %925 = load i32, ptr %924, align 4, !tbaa !15
  %926 = icmp eq i32 %925, 0
  br i1 %926, label %939, label %927

927:                                              ; preds = %923
  %928 = getelementptr inbounds nuw i8, ptr %924, i32 4
  %929 = load i32, ptr %928, align 4, !tbaa !17
  store i32 %929, ptr %917, align 4, !tbaa !6
  %930 = getelementptr inbounds nuw i8, ptr %924, i32 8
  %931 = load i32, ptr %930, align 4, !tbaa !20
  %932 = getelementptr inbounds nuw i8, ptr %917, i32 4
  store i32 %931, ptr %932, align 4, !tbaa !6
  %933 = load i32, ptr %924, align 4, !tbaa !15
  %934 = getelementptr inbounds nuw i8, ptr %917, i32 8
  store i32 %933, ptr %934, align 4, !tbaa !6
  %935 = getelementptr inbounds nuw i8, ptr %917, i32 12
  %936 = getelementptr inbounds nuw [8 x [12 x i8]], ptr @procname, i32 0, i32 %919
  tail call fastcc void @namecpy(ptr noundef nonnull %935, ptr noundef nonnull %936) #18
  %937 = getelementptr inbounds nuw i8, ptr %917, i32 24
  %938 = add nuw i32 %918, 1
  br label %939

939:                                              ; preds = %923, %927
  %940 = phi ptr [ %917, %923 ], [ %937, %927 ]
  %941 = phi i32 [ %918, %923 ], [ %938, %927 ]
  %942 = add nuw nsw i32 %919, 1
  br label %916, !llvm.loop !100

943:                                              ; preds = %12
  %944 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %945 = load volatile i32, ptr %944, align 4, !tbaa !35
  %946 = icmp eq i32 %945, 0
  br i1 %946, label %951, label %947

947:                                              ; preds = %943
  store i1 true, ptr @cons_raw, align 4
  %948 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %949 = load i32, ptr %948, align 4, !tbaa !17
  store i32 %949, ptr @cons_raw_pid, align 4, !tbaa !6
  %950 = load i32, ptr @cons_e, align 4, !tbaa !6
  store i32 %950, ptr @cons_w, align 4, !tbaa !6
  br label %1069

951:                                              ; preds = %943
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !6
  br label %1069

952:                                              ; preds = %12
  %953 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %954 = load volatile i32, ptr %953, align 4, !tbaa !35
  %955 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %956 = load volatile i32, ptr %955, align 4, !tbaa !49
  %957 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %958 = load volatile i32, ptr %957, align 4, !tbaa !50
  %959 = tail call i32 @kgpio(i32 noundef %954, i32 noundef %956, i32 noundef %958) #19
  br label %1069

960:                                              ; preds = %12
  %961 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %962 = load volatile i32, ptr %961, align 4, !tbaa !35
  %963 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %964 = load volatile i32, ptr %963, align 4, !tbaa !49
  %965 = tail call i32 @kpinmux(i32 noundef %962, i32 noundef %964) #19
  br label %1069

966:                                              ; preds = %12
  %967 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %968 = load volatile i32, ptr %967, align 4, !tbaa !35
  %969 = icmp eq i32 %968, 0
  br i1 %969, label %973, label %970

970:                                              ; preds = %966
  %971 = load volatile i32, ptr %967, align 4, !tbaa !35
  %972 = icmp eq i32 %971, 1
  br i1 %972, label %973, label %986

973:                                              ; preds = %970, %966
  %974 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %975 = load volatile i32, ptr %974, align 4, !tbaa !49
  %976 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %977 = load i32, ptr %976, align 4, !tbaa !60
  %978 = icmp ult i32 %975, %977
  br i1 %978, label %979, label %986

979:                                              ; preds = %973
  %980 = add i32 %975, 28
  %981 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %982 = load i32, ptr %981, align 4, !tbaa !52
  %983 = icmp ugt i32 %980, %982
  br i1 %983, label %984, label %986

984:                                              ; preds = %979
  %985 = icmp ugt i32 %975, -29
  br i1 %985, label %986, label %1069

986:                                              ; preds = %973, %979, %984, %970
  %987 = load volatile i32, ptr %967, align 4, !tbaa !35
  %988 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %989 = load volatile i32, ptr %988, align 4, !tbaa !49
  %990 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %991 = load volatile i32, ptr %990, align 4, !tbaa !50
  %992 = tail call i32 @kpio(i32 noundef %987, i32 noundef %989, i32 noundef %991) #19
  br label %1069

993:                                              ; preds = %12
  %994 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %995 = load volatile i32, ptr %994, align 4, !tbaa !35
  %996 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %997 = load volatile i32, ptr %996, align 4, !tbaa !49
  %998 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %999 = load i32, ptr %998, align 4, !tbaa !17
  %1000 = load volatile i32, ptr %994, align 4, !tbaa !35
  %1001 = icmp eq i32 %1000, 0
  br i1 %1001, label %1002, label %1015

1002:                                             ; preds = %993
  %1003 = load volatile i32, ptr %996, align 4, !tbaa !49
  %1004 = getelementptr inbounds nuw i8, ptr %7, i32 56
  %1005 = load i32, ptr %1004, align 4, !tbaa !60
  %1006 = icmp ult i32 %1003, %1005
  br i1 %1006, label %1007, label %1015

1007:                                             ; preds = %1002
  %1008 = add i32 %1003, 20
  %1009 = getelementptr inbounds nuw i8, ptr %7, i32 60
  %1010 = load i32, ptr %1009, align 4, !tbaa !52
  %1011 = icmp ugt i32 %1008, %1010
  br i1 %1011, label %1012, label %1015

1012:                                             ; preds = %1007
  %1013 = icmp ult i32 %1003, -20
  %1014 = zext i1 %1013 to i32
  br label %1015

1015:                                             ; preds = %1012, %1007, %1002, %993
  %1016 = phi i32 [ 0, %993 ], [ 0, %1007 ], [ 0, %1002 ], [ %1014, %1012 ]
  %1017 = tail call i32 @kfb_syscall(i32 noundef %995, i32 noundef %997, i32 noundef %999, i32 noundef %1016) #19
  br label %1069

1018:                                             ; preds = %12
  %1019 = getelementptr inbounds nuw i8, ptr %15, i32 12
  %1020 = load volatile i32, ptr %1019, align 4, !tbaa !50
  %1021 = getelementptr inbounds nuw i8, ptr %7, i32 64
  store i32 %1020, ptr %1021, align 4, !tbaa !26
  %1022 = getelementptr inbounds nuw i8, ptr %7, i32 68
  store i32 0, ptr %1022, align 4, !tbaa !27
  br label %1069

1023:                                             ; preds = %12
  %1024 = getelementptr inbounds nuw i8, ptr %7, i32 64
  %1025 = load i32, ptr %1024, align 4, !tbaa !26
  %1026 = icmp eq i32 %1025, 0
  br i1 %1026, label %1069, label %1027

1027:                                             ; preds = %1023
  %1028 = getelementptr inbounds nuw i8, ptr %7, i32 24
  %1029 = load i32, ptr %1028, align 4, !tbaa !32
  %1030 = add i32 %1029, -84
  %1031 = getelementptr inbounds nuw i8, ptr %7, i32 68
  store i32 0, ptr %1031, align 4, !tbaa !27
  %1032 = add i32 %1025, 8
  %1033 = inttoptr i32 %1032 to ptr
  %1034 = load volatile i32, ptr %1033, align 4, !tbaa !6
  %1035 = inttoptr i32 %1030 to ptr
  store volatile i32 %1034, ptr %1035, align 4, !tbaa !6
  %1036 = add i32 %1025, 12
  %1037 = inttoptr i32 %1036 to ptr
  %1038 = load volatile i32, ptr %1037, align 4, !tbaa !6
  %1039 = add i32 %1029, -80
  %1040 = inttoptr i32 %1039 to ptr
  store volatile i32 %1038, ptr %1040, align 4, !tbaa !6
  store i32 4, ptr %7, align 4, !tbaa !15
  %1041 = load i32, ptr @curr, align 4, !tbaa !6
  %1042 = add i32 %1025, 4
  %1043 = inttoptr i32 %1042 to ptr
  %1044 = load volatile i32, ptr %1043, align 4, !tbaa !6
  tail call fastcc void @kexit(i32 noundef %1041, i32 noundef %1044) #18
  br label %1099

1045:                                             ; preds = %17, %1057
  %1046 = phi i32 [ %1058, %1057 ], [ 0, %17 ]
  %1047 = icmp eq i32 %1046, 8
  br i1 %1047, label %1069, label %1048

1048:                                             ; preds = %1045
  %1049 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1046
  %1050 = load i32, ptr %1049, align 4, !tbaa !15
  %1051 = icmp eq i32 %1050, 0
  br i1 %1051, label %1057, label %1052

1052:                                             ; preds = %1048
  %1053 = getelementptr inbounds nuw i8, ptr %1049, i32 4
  %1054 = load i32, ptr %1053, align 4, !tbaa !17
  %1055 = load volatile i32, ptr %18, align 4, !tbaa !35
  %1056 = icmp eq i32 %1054, %1055
  br i1 %1056, label %1059, label %1057

1057:                                             ; preds = %1048, %1052
  %1058 = add nuw nsw i32 %1046, 1
  br label %1045, !llvm.loop !101

1059:                                             ; preds = %1052
  %1060 = icmp eq i32 %1050, 5
  br i1 %1060, label %1069, label %1061

1061:                                             ; preds = %1059
  %1062 = icmp eq i32 %1046, %6
  br i1 %1062, label %1063, label %1064

1063:                                             ; preds = %1061
  tail call fastcc void @terminate(ptr noundef nonnull %7, i32 noundef -1) #18
  br label %1084

1064:                                             ; preds = %1061
  %1065 = icmp eq i32 %1050, 2
  br i1 %1065, label %1066, label %1067

1066:                                             ; preds = %1064
  tail call fastcc void @terminate(ptr noundef nonnull %1049, i32 noundef -1) #18
  br label %1069

1067:                                             ; preds = %1064
  %1068 = getelementptr inbounds nuw i8, ptr %1049, i32 48
  store i32 1, ptr %1068, align 4, !tbaa !33
  br label %1069

1069:                                             ; preds = %1045, %916, %412, %268, %139, %29, %12, %21, %24, %137, %823, %860, %952, %960, %986, %1015, %1018, %54, %57, %63, %66, %70, %73, %77, %80, %86, %89, %95, %98, %102, %105, %109, %112, %116, %119, %125, %128, %339, %316, %396, %400, %796, %799, %805, %808, %906, %951, %947, %984, %1059, %1067, %1066, %1023, %50, %159, %172, %228, %240, %255, %786
  %1070 = phi i32 [ -1, %786 ], [ -1, %228 ], [ -1, %255 ], [ -1, %240 ], [ -1, %172 ], [ %161, %159 ], [ %52, %50 ], [ -1, %1023 ], [ 0, %1066 ], [ 0, %1067 ], [ -1, %1059 ], [ -1, %984 ], [ 0, %947 ], [ 0, %951 ], [ -1, %906 ], [ -1, %805 ], [ %811, %808 ], [ -1, %796 ], [ %804, %799 ], [ -1, %400 ], [ %399, %396 ], [ %314, %316 ], [ 0, %339 ], [ -1, %125 ], [ %131, %128 ], [ -1, %116 ], [ %124, %119 ], [ -1, %109 ], [ %115, %112 ], [ -1, %102 ], [ %108, %105 ], [ -1, %95 ], [ %101, %98 ], [ -1, %86 ], [ %94, %89 ], [ -1, %77 ], [ %85, %80 ], [ -1, %70 ], [ %76, %73 ], [ -1, %63 ], [ %69, %66 ], [ -1, %54 ], [ %62, %57 ], [ 0, %1018 ], [ %1017, %1015 ], [ %992, %986 ], [ %965, %960 ], [ %959, %952 ], [ 0, %860 ], [ -1, %823 ], [ %138, %137 ], [ %28, %24 ], [ %23, %21 ], [ -1, %12 ], [ -1, %29 ], [ -1, %139 ], [ %237, %268 ], [ -1, %412 ], [ %918, %916 ], [ -1, %1045 ]
  %1071 = load i32, ptr %13, align 4, !tbaa !28
  %1072 = inttoptr i32 %1071 to ptr
  %1073 = getelementptr inbounds nuw i8, ptr %1072, i32 16
  store volatile i32 %1070, ptr %1073, align 4, !tbaa !29
  %1074 = getelementptr inbounds nuw i8, ptr %1072, i32 20
  store volatile i32 1, ptr %1074, align 4, !tbaa !31
  %1075 = getelementptr inbounds nuw i8, ptr %7, i32 24
  %1076 = load i32, ptr %1075, align 4, !tbaa !32
  %1077 = add i32 %1076, -84
  %1078 = inttoptr i32 %1077 to ptr
  store volatile i32 %1070, ptr %1078, align 4, !tbaa !6
  store i32 4, ptr %7, align 4, !tbaa !15
  %1079 = load i32, ptr @curr, align 4, !tbaa !6
  %1080 = getelementptr inbounds nuw i8, ptr %7, i32 32
  %1081 = load i32, ptr %1080, align 4, !tbaa !38
  %1082 = inttoptr i32 %1081 to ptr
  %1083 = load volatile i32, ptr %1082, align 4, !tbaa !6
  call fastcc void @kexit(i32 noundef %1079, i32 noundef %1083) #18
  br label %1099

1084:                                             ; preds = %159, %50, %298, %793, %345, %355, %1063
  %1085 = phi i32 [ -1, %1063 ], [ 0, %345 ], [ 0, %355 ], [ -1, %793 ], [ 0, %298 ], [ -3, %50 ], [ -3, %159 ]
  %1086 = load i32, ptr %7, align 4, !tbaa !15
  %1087 = icmp eq i32 %1086, 2
  br i1 %1087, label %1088, label %1098

1088:                                             ; preds = %427, %402, %1084
  %1089 = phi i32 [ %1085, %1084 ], [ 0, %427 ], [ %411, %402 ]
  %1090 = load i32, ptr %13, align 4, !tbaa !28
  %1091 = inttoptr i32 %1090 to ptr
  %1092 = getelementptr inbounds nuw i8, ptr %1091, i32 16
  store volatile i32 %1089, ptr %1092, align 4, !tbaa !29
  %1093 = getelementptr inbounds nuw i8, ptr %1091, i32 20
  store volatile i32 1, ptr %1093, align 4, !tbaa !31
  %1094 = getelementptr inbounds nuw i8, ptr %7, i32 24
  %1095 = load i32, ptr %1094, align 4, !tbaa !32
  %1096 = add i32 %1095, -84
  %1097 = inttoptr i32 %1096 to ptr
  store volatile i32 %1089, ptr %1097, align 4, !tbaa !6
  br label %1098

1098:                                             ; preds = %1088, %1084
  tail call fastcc void @swtch() #18
  br label %1099

1099:                                             ; preds = %787, %1027, %1069, %1098, %11
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @badbuf(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #8 {
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
declare dso_local i32 @kfs_write(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_open(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_close(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_dup(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_fstat(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_seek(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_pipe(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_chdir(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mkdir(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_link(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_unlink(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfb_pause() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sync() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfb_resume() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_read(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn memory(readwrite, argmem: write)
define internal fastcc void @arm_timed(ptr noundef writeonly captures(none) initializes((16, 20)) %0, i32 noundef %1) unnamed_addr #9 {
  %3 = load volatile i32, ptr @__dma_timerawl, align 4, !tbaa !6
  %4 = mul i32 %1, 100
  %5 = add i32 %3, %4
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 16
  store i32 %5, ptr %6, align 4, !tbaa !102
  %7 = load i32, ptr @ntimed, align 4, !tbaa !6
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %13, label %9

9:                                                ; preds = %2
  %10 = load i32, ptr @next_us, align 4, !tbaa !6
  %11 = sub i32 %5, %10
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %13, label %14

13:                                               ; preds = %9, %2
  store i32 %5, ptr @next_us, align 4, !tbaa !6
  br label %14

14:                                               ; preds = %13, %9
  %15 = add i32 %7, 1
  store i32 %15, ptr @ntimed, align 4, !tbaa !6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_selready(i32 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #10

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @namecpy(ptr noundef writeonly captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #11 {
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
declare dso_local void @kfs_forkcopy(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iopen(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iread(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfs_iclose(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #12 {
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
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #12 {
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
declare dso_local void @kdmacpy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree_exec(i32 noundef %0) unnamed_addr #12 {
  br label %2

2:                                                ; preds = %14, %1
  %3 = phi i32 [ 0, %1 ], [ %17, %14 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %5, label %14

5:                                                ; preds = %2
  %6 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !6
  tail call fastcc void @kfree(i32 noundef %7) #18
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
  tail call fastcc void @kfree(i32 noundef %16) #18
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
  tail call fastcc void @fire_income() #18
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
  %49 = load i32, ptr %48, align 4, !tbaa !95
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
  tail call fastcc void @fire_income() #18
  br label %58

58:                                               ; preds = %57, %40
  %59 = tail call i32 @kcons_on() #19
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %70, label %61

61:                                               ; preds = %58
  %62 = load i32, ptr @fgpid, align 4, !tbaa !6
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %68, label %64

64:                                               ; preds = %61
  %65 = tail call i32 @kcons_pending() #19
  %66 = icmp eq i32 %65, 0
  br i1 %66, label %68, label %67

67:                                               ; preds = %64
  tail call fastcc void @cons_poll() #18
  br label %68

68:                                               ; preds = %67, %64, %61
  tail call void @kcons_kick() #19
  %69 = load i32, ptr %42, align 4, !tbaa !32
  tail call void @kcons_aim(i32 noundef %69) #19
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
declare dso_local i32 @kfs_mount(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_umount(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kgpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kpinmux(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_syscall(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #1 {
  tail call void @dma_ktick() #18
  tail call void @dma_ksyscall() #18
  ret i32 0
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: write)
define internal fastcc void @wall_now(ptr noundef writeonly captures(none) %0, ptr noundef writeonly captures(none) %1) unnamed_addr #13 {
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
  %2 = tail call i32 @kcons_tx(i32 noundef %0) #19
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
declare dso_local void @kfbcon_putc(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_tx(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_rx() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kcons_aim(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc void @kboot_init() unnamed_addr #14 {
  %1 = alloca [8 x i8], align 1
  tail call fastcc void @wall_now(ptr noundef nonnull @wall0_hi, ptr noundef nonnull @wall0_lo) #18
  tail call void @klogts() #18
  tail call void @kconswrite(ptr noundef nonnull @.str, i32 noundef 16) #18
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %1) #17
  %2 = load i32, ptr @xv6_commit, align 4, !tbaa !6
  br label %3

3:                                                ; preds = %9, %0
  %4 = phi i32 [ 0, %0 ], [ %17, %9 ]
  %5 = icmp eq i32 %4, 7
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  call void @kconswrite(ptr noundef nonnull %1, i32 noundef 7) #18
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %1) #17
  tail call void @kconswrite(ptr noundef nonnull @.str.2, i32 noundef 48) #18
  %7 = tail call i32 @kfb_init() #19
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
  tail call void @kfbcon_reset() #19
  tail call void @klogts() #18
  tail call void @kconswrite(ptr noundef nonnull @.str.3, i32 noundef 26) #18
  br label %22

19:                                               ; preds = %6
  %20 = icmp slt i32 %7, 0
  br i1 %20, label %21, label %22

21:                                               ; preds = %19
  tail call void @klogts() #18
  tail call void @kconswrite(ptr noundef nonnull @.str.4, i32 noundef 15) #18
  br label %22

22:                                               ; preds = %19, %21, %18
  tail call void @kfs_start() #19
  tail call void @kflash_init() #19
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_init() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_on() local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tick_income() unnamed_addr #1 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !6
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !6
  store i1 true, ptr @rearm, align 4
  %3 = load i32, ptr @ntimed, align 4, !tbaa !6
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %11, label %5

5:                                                ; preds = %0
  %6 = load volatile i32, ptr @__dma_timerawl, align 4, !tbaa !6
  %7 = load i32, ptr @next_us, align 4, !tbaa !6
  %8 = sub i32 %6, %7
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %10, label %11

10:                                               ; preds = %5
  tail call fastcc void @tick_wake(i32 noundef %6) #18
  br label %11

11:                                               ; preds = %5, %10, %0
  %12 = load i32, ptr @fgpid, align 4, !tbaa !6
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %18, label %14

14:                                               ; preds = %11
  %15 = tail call i32 @kcons_pending() #19
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %18, label %17

17:                                               ; preds = %14
  tail call fastcc void @cons_poll() #18
  br label %18

18:                                               ; preds = %17, %14, %11
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_pending() local_unnamed_addr #5

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @tick_wake(i32 noundef %0) unnamed_addr #15 {
  br label %2

2:                                                ; preds = %30, %1
  %3 = phi i32 [ 0, %1 ], [ %31, %30 ]
  %4 = phi i32 [ 0, %1 ], [ %33, %30 ]
  %5 = phi i32 [ 0, %1 ], [ %32, %30 ]
  %6 = icmp eq i32 %4, 8
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  store i32 %5, ptr @ntimed, align 4, !tbaa !6
  store i32 %3, ptr @next_us, align 4, !tbaa !6
  ret void

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %10 = load i32, ptr %9, align 4, !tbaa !15
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %30

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !19
  %15 = icmp eq i32 %14, ptrtoint (ptr @ticks to i32)
  br i1 %15, label %18, label %16

16:                                               ; preds = %12
  %17 = icmp eq i32 %14, ptrtoint (ptr @selwait_to to i32)
  br i1 %17, label %18, label %30

18:                                               ; preds = %16, %12
  %19 = getelementptr inbounds nuw i8, ptr %9, i32 16
  %20 = load i32, ptr %19, align 4, !tbaa !102
  %21 = sub i32 %0, %20
  %22 = icmp sgt i32 %21, -1
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  store i32 0, ptr %13, align 4, !tbaa !19
  store i32 3, ptr %9, align 4, !tbaa !15
  br label %30

24:                                               ; preds = %18
  %25 = icmp eq i32 %5, 0
  br i1 %25, label %29, label %26

26:                                               ; preds = %24
  %27 = sub i32 %20, %3
  %28 = icmp slt i32 %27, 0
  br i1 %28, label %29, label %30

29:                                               ; preds = %26, %24
  br label %30

30:                                               ; preds = %26, %29, %16, %8, %23
  %31 = phi i32 [ %3, %23 ], [ %3, %8 ], [ %3, %16 ], [ %20, %29 ], [ %3, %26 ]
  %32 = phi i32 [ %5, %23 ], [ %5, %8 ], [ %5, %16 ], [ 1, %29 ], [ 1, %26 ]
  %33 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !110
}

; Function Attrs: minsize optsize
declare dso_local void @kcons_kick() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_owner() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfb_setowner(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #16

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #16

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { minsize mustprogress nofree norecurse nounwind optsize willreturn memory(readwrite, argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #11 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #12 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #13 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #14 = { minsize noinline nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #15 = { minsize nofree noinline norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #16 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #17 = { nounwind }
attributes #18 = { minsize nobuiltin optsize "no-builtins" }
attributes #19 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
!95 = !{!16, !7, i64 28}
!96 = distinct !{!96, !9, !10}
!97 = distinct !{!97, !9, !10}
!98 = distinct !{!98, !9, !10}
!99 = distinct !{!99, !9, !10}
!100 = distinct !{!100, !9, !10}
!101 = distinct !{!101, !9, !10}
!102 = !{!16, !7, i64 16}
!103 = distinct !{!103, !9, !10}
!104 = distinct !{!104, !9, !10}
!105 = distinct !{!105, !9, !10}
!106 = distinct !{!106, !9, !10}
!107 = distinct !{!107, !9, !10}
!108 = distinct !{!108, !9, !10}
!109 = distinct !{!109, !9, !10}
!110 = distinct !{!110, !9, !10}
