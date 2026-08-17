; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@inj_wreg = dso_local local_unnamed_addr global i32 1342177476, align 4
@inj_treg = dso_local local_unnamed_addr global i32 1342177500, align 4
@cons_r = internal unnamed_addr global i32 0, align 4
@cons_w = internal unnamed_addr global i32 0, align 4
@cons_buf = internal unnamed_addr global [128 x i8] zeroinitializer, align 1
@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@kw_curresume = dso_local global ptr null, align 4
@ticks = dso_local global i32 0, align 4
@fsready = external dso_local local_unnamed_addr global i32, align 4
@nextpid = dso_local local_unnamed_addr global i32 0, align 4
@execmem = internal unnamed_addr global [8 x [3 x i32]] zeroinitializer, align 4
@k_sysentry = dso_local local_unnamed_addr global i32 0, align 4
@kw_pcurdisp = dso_local global ptr null, align 4
@kw_curthunk = dso_local global ptr null, align 4
@kw_pcurresume = dso_local global ptr null, align 4
@kw_nextresume = dso_local global ptr null, align 4
@kw_khalt = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@kimages = dso_local local_unnamed_addr global [4 x %struct.kimg] zeroinitializer, align 4
@arena = dso_local local_unnamed_addr global i32 0, align 4
@arena_end = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@cons_e = internal unnamed_addr global i32 0, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4
@kheap_init = internal unnamed_addr global i1 false, align 4
@kfreelist = internal unnamed_addr global ptr null, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kconswrite(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #0 {
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
  br label %3, !llvm.loop !6
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define internal fastcc void @cputc(i32 noundef range(i32 -128, 256) %0) unnamed_addr #2 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %8

3:                                                ; preds = %1, %3
  %4 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %5 = and i32 %4, 32
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !11

7:                                                ; preds = %3
  store volatile i32 13, ptr @__dma_uart_dr, align 4, !tbaa !9
  br label %8

8:                                                ; preds = %7, %1
  br label %9

9:                                                ; preds = %8, %9
  %10 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %11 = and i32 %10, 32
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %9, !llvm.loop !12

13:                                               ; preds = %9
  %14 = and i32 %0, 255
  store volatile i32 %14, ptr @__dma_uart_dr, align 4, !tbaa !9
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = load i32, ptr @cons_e, align 4
  %4 = load i32, ptr @cons_w, align 4
  %5 = load i32, ptr @cons_r, align 4
  br label %6

6:                                                ; preds = %39, %2
  %7 = phi i32 [ %32, %39 ], [ %4, %2 ]
  %8 = phi i32 [ %32, %39 ], [ %3, %2 ]
  br label %9

9:                                                ; preds = %37, %6
  %10 = phi i32 [ %8, %6 ], [ %38, %37 ]
  %11 = sub i32 %10, %5
  %12 = icmp ult i32 %11, 128
  br label %13

13:                                               ; preds = %9, %24
  %14 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %15 = and i32 %14, 16
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %40

17:                                               ; preds = %13
  %18 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !9
  %19 = trunc i32 %18 to i8
  switch i8 %19, label %24 [
    i8 8, label %20
    i8 127, label %20
  ]

20:                                               ; preds = %17, %17
  %21 = icmp eq i32 %10, %7
  br i1 %21, label %37, label %22

22:                                               ; preds = %20
  %23 = add i32 %10, -1
  store i32 %23, ptr @cons_e, align 4, !tbaa !9
  tail call fastcc void @cputc(i32 noundef 8) #12
  tail call fastcc void @cputc(i32 noundef 32) #12
  tail call fastcc void @cputc(i32 noundef 8) #12
  br label %37

24:                                               ; preds = %17
  br i1 %12, label %25, label %13

25:                                               ; preds = %24
  %26 = and i32 %18, 255
  %27 = icmp eq i32 %26, 13
  %28 = select i1 %27, i32 10, i32 %26
  %29 = trunc nuw i32 %28 to i8
  %30 = and i32 %10, 127
  %31 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %30
  store i8 %29, ptr %31, align 1, !tbaa !3
  %32 = add i32 %10, 1
  store i32 %32, ptr @cons_e, align 4, !tbaa !9
  tail call fastcc void @cputc(i32 noundef %28) #12
  %33 = icmp eq i32 %28, 10
  br i1 %33, label %39, label %34

34:                                               ; preds = %25
  %35 = sub i32 %32, %5
  %36 = icmp eq i32 %35, 128
  br i1 %36, label %39, label %37

37:                                               ; preds = %34, %20, %22
  %38 = phi i32 [ %23, %22 ], [ %7, %20 ], [ %32, %34 ]
  br label %9, !llvm.loop !13

39:                                               ; preds = %34, %25
  store i32 %32, ptr @cons_w, align 4, !tbaa !9
  br label %6

40:                                               ; preds = %13
  %41 = icmp eq i32 %5, %7
  br i1 %41, label %59, label %42

42:                                               ; preds = %40
  %43 = inttoptr i32 %0 to ptr
  br label %44

44:                                               ; preds = %51, %42
  %45 = phi i32 [ 0, %42 ], [ %56, %51 ]
  %46 = icmp slt i32 %45, %1
  %47 = load i32, ptr @cons_r, align 4
  %48 = load i32, ptr @cons_w, align 4
  %49 = icmp ne i32 %47, %48
  %50 = select i1 %46, i1 %49, i1 false
  br i1 %50, label %51, label %59

51:                                               ; preds = %44
  %52 = and i32 %47, 127
  %53 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %52
  %54 = load i8, ptr %53, align 1, !tbaa !3
  %55 = add i32 %47, 1
  store i32 %55, ptr @cons_r, align 4, !tbaa !9
  %56 = add nuw nsw i32 %45, 1
  %57 = getelementptr inbounds nuw i8, ptr %43, i32 %45
  store i8 %54, ptr %57, align 1, !tbaa !3
  %58 = icmp eq i8 %54, 10
  br i1 %58, label %59, label %44

59:                                               ; preds = %51, %44, %40
  %60 = phi i32 [ -2, %40 ], [ %45, %44 ], [ %56, %51 ]
  ret i32 %60
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
  %11 = load i32, ptr %10, align 4, !tbaa !16
  %12 = icmp eq i32 %11, %0
  br i1 %12, label %15, label %13

13:                                               ; preds = %5, %9
  %14 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !17

15:                                               ; preds = %9, %2
  %16 = phi i32 [ -1, %2 ], [ %3, %9 ]
  ret i32 %16
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #4 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %4 = load i32, ptr %3, align 4, !tbaa !18
  %5 = add i32 %1, -1
  %6 = icmp ult i32 %5, 4
  %7 = shl nsw i32 %5, 2
  %8 = add nsw i32 %7, 4
  %9 = select i1 %6, i32 %8, i32 20
  %10 = inttoptr i32 %4 to ptr
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 %9
  %12 = load volatile i32, ptr %11, align 4, !tbaa !9
  ret i32 %12
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kmail_set(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %5 = load i32, ptr %4, align 4, !tbaa !18
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
  store volatile i32 %2, ptr %11, align 4, !tbaa !9
  br label %12

12:                                               ; preds = %9, %3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kcomplete(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 44
  %5 = load i32, ptr %4, align 4, !tbaa !18
  %6 = inttoptr i32 %5 to ptr
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 16
  store volatile i32 %1, ptr %7, align 4, !tbaa !19
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store volatile i32 1, ptr %8, align 4, !tbaa !21
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 24
  %10 = load i32, ptr %9, align 4, !tbaa !22
  %11 = add i32 %10, -84
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 %1, ptr %12, align 4, !tbaa !9
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 0, ptr %13, align 4, !tbaa !16
  store i32 3, ptr %3, align 4, !tbaa !14
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kblock_self_slot() local_unnamed_addr #5 {
  %1 = load i32, ptr @curr, align 4, !tbaa !9
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #4 {
  %2 = load i32, ptr @curr, align 4, !tbaa !9
  %3 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %2
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 32
  %5 = load i32, ptr %4, align 4, !tbaa !23
  %6 = inttoptr i32 %5 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !9
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 40
  store i32 %7, ptr %8, align 4, !tbaa !24
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 %0, ptr %9, align 4, !tbaa !16
  store i32 2, ptr %3, align 4, !tbaa !14
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #6 {
  tail call fastcc void @kenter() #12
  tail call fastcc void @tick_income() #12
  %1 = load i32, ptr @curr, align 4, !tbaa !9
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !25
  %4 = load i32, ptr %3, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %4, ptr %5, align 4, !tbaa !24
  %6 = load i32, ptr %2, align 4, !tbaa !14
  %7 = icmp eq i32 %6, 4
  br i1 %7, label %8, label %9

8:                                                ; preds = %0
  store i32 3, ptr %2, align 4, !tbaa !14
  br label %9

9:                                                ; preds = %8, %0
  tail call fastcc void @swtch() #12
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kenter() unnamed_addr #6 {
  store i1 false, ptr @rearm, align 4
  %1 = load i32, ptr @fsready, align 4, !tbaa !9
  %2 = icmp eq i32 %1, 0
  %3 = load i32, ptr @dma_disk, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %2, i1 %4, i1 false
  br i1 %5, label %6, label %7

6:                                                ; preds = %0
  tail call void @kfs_start() #13
  br label %7

7:                                                ; preds = %6, %0
  %8 = load i32, ptr @curr, align 4, !tbaa !9
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %8
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %11 = load i32, ptr %10, align 4, !tbaa !22
  store i32 %11, ptr @entry_disp, align 4, !tbaa !9
  %12 = getelementptr inbounds nuw i8, ptr %9, i32 36
  %13 = load i32, ptr %12, align 4, !tbaa !28
  store i32 %13, ptr @entry_thunk, align 4, !tbaa !9
  %14 = inttoptr i32 %11 to ptr
  %15 = load volatile i32, ptr %14, align 4, !tbaa !9
  %16 = icmp eq i32 %15, %13
  br i1 %16, label %18, label %17

17:                                               ; preds = %7
  store volatile i32 %13, ptr %14, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %18

18:                                               ; preds = %17, %7
  %19 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %20 = inttoptr i32 %19 to ptr
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr %20, align 4, !tbaa !9
  %21 = load i32, ptr @tickpending, align 4, !tbaa !9
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %24, label %23

23:                                               ; preds = %18
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %24

24:                                               ; preds = %23, %18
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @tick_income() unnamed_addr #7 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !9
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !9
  store i1 true, ptr @rearm, align 4
  br label %3

3:                                                ; preds = %21, %0
  %4 = phi i32 [ 0, %0 ], [ %22, %21 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %9 = load i32, ptr %8, align 4, !tbaa !14
  %10 = icmp eq i32 %9, 2
  br i1 %10, label %11, label %21

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %13 = load i32, ptr %12, align 4, !tbaa !16
  %14 = icmp eq i32 %13, ptrtoint (ptr @ticks to i32)
  br i1 %14, label %15, label %21

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw i8, ptr %8, i32 16
  %17 = load i32, ptr %16, align 4, !tbaa !29
  %18 = sub i32 %2, %17
  %19 = icmp sgt i32 %18, -1
  br i1 %19, label %20, label %21

20:                                               ; preds = %15
  store i32 0, ptr %12, align 4, !tbaa !16
  store i32 3, ptr %8, align 4, !tbaa !14
  br label %21

21:                                               ; preds = %20, %15, %11, %7
  %22 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !30
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @swtch() unnamed_addr #0 {
  %1 = load i32, ptr @curr, align 4
  br label %2

2:                                                ; preds = %5, %0
  %3 = phi i32 [ 1, %0 ], [ %11, %5 ]
  %4 = icmp eq i32 %3, 9
  br i1 %4, label %14, label %5

5:                                                ; preds = %2
  %6 = add i32 %3, %1
  %7 = srem i32 %6, 8
  %8 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %7
  %9 = load i32, ptr %8, align 4, !tbaa !14
  %10 = icmp eq i32 %9, 3
  %11 = add nuw nsw i32 %3, 1
  br i1 %10, label %12, label %2, !llvm.loop !31

12:                                               ; preds = %5
  %13 = icmp slt i32 %7, 0
  br i1 %13, label %14, label %17

14:                                               ; preds = %2, %12
  %15 = load volatile ptr, ptr @kw_khalt, align 4, !tbaa !25
  %16 = ptrtoint ptr %15 to i32
  tail call fastcc void @kexit(i32 noundef %1, i32 noundef %16) #12
  br label %20

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %19 = load i32, ptr %18, align 4, !tbaa !24
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %19) #12
  br label %20

20:                                               ; preds = %17, %14
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #6 {
  %1 = alloca %struct.kimg, align 4
  %2 = alloca [13 x i32], align 4
  %3 = alloca [64 x i32], align 4
  tail call fastcc void @kenter() #12
  %4 = load i32, ptr @curr, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %7 = load i32, ptr %6, align 4, !tbaa !18
  %8 = inttoptr i32 %7 to ptr
  %9 = load volatile i32, ptr %8, align 4, !tbaa !32
  switch i32 %9, label %548 [
    i32 11, label %12
    i32 14, label %15
    i32 16, label %17
    i32 15, label %38
    i32 21, label %47
    i32 10, label %54
    i32 8, label %61
    i32 4, label %70
    i32 9, label %77
    i32 20, label %84
    i32 5, label %91
    i32 13, label %111
    i32 3, label %10
    i32 1, label %171
    i32 7, label %201
    i32 2, label %492
  ]

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %123

12:                                               ; preds = %0
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %14 = load i32, ptr %13, align 4, !tbaa !33
  br label %548

15:                                               ; preds = %0
  %16 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %548

17:                                               ; preds = %0
  %18 = load i32, ptr @fsready, align 4, !tbaa !9
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %28, label %20

20:                                               ; preds = %17
  %21 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %22 = load volatile i32, ptr %21, align 4, !tbaa !34
  %23 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %24 = load volatile i32, ptr %23, align 4, !tbaa !35
  %25 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %26 = load volatile i32, ptr %25, align 4, !tbaa !36
  %27 = tail call i32 @kfs_write(i32 noundef %22, i32 noundef %24, i32 noundef %26) #13
  br label %35

28:                                               ; preds = %17
  %29 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %30 = load volatile i32, ptr %29, align 4, !tbaa !35
  %31 = inttoptr i32 %30 to ptr
  %32 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %33 = load volatile i32, ptr %32, align 4, !tbaa !36
  tail call void @kconswrite(ptr noundef %31, i32 noundef %33) #12
  %34 = load volatile i32, ptr %32, align 4, !tbaa !36
  br label %35

35:                                               ; preds = %28, %20
  %36 = phi i32 [ %27, %20 ], [ %34, %28 ]
  %37 = icmp eq i32 %36, -3
  br i1 %37, label %563, label %548

38:                                               ; preds = %0
  %39 = load i32, ptr @fsready, align 4, !tbaa !9
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %548, label %41

41:                                               ; preds = %38
  %42 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %43 = load volatile i32, ptr %42, align 4, !tbaa !34
  %44 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %45 = load volatile i32, ptr %44, align 4, !tbaa !35
  %46 = tail call i32 @kfs_open(i32 noundef %43, i32 noundef %45) #13
  br label %548

47:                                               ; preds = %0
  %48 = load i32, ptr @fsready, align 4, !tbaa !9
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %548, label %50

50:                                               ; preds = %47
  %51 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %52 = load volatile i32, ptr %51, align 4, !tbaa !34
  %53 = tail call i32 @kfs_close(i32 noundef %52) #13
  br label %548

54:                                               ; preds = %0
  %55 = load i32, ptr @fsready, align 4, !tbaa !9
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %548, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !34
  %60 = tail call i32 @kfs_dup(i32 noundef %59) #13
  br label %548

61:                                               ; preds = %0
  %62 = load i32, ptr @fsready, align 4, !tbaa !9
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %548, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %66 = load volatile i32, ptr %65, align 4, !tbaa !34
  %67 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %68 = load volatile i32, ptr %67, align 4, !tbaa !35
  %69 = tail call i32 @kfs_fstat(i32 noundef %66, i32 noundef %68) #13
  br label %548

70:                                               ; preds = %0
  %71 = load i32, ptr @fsready, align 4, !tbaa !9
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %548, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %75 = load volatile i32, ptr %74, align 4, !tbaa !34
  %76 = tail call i32 @kfs_pipe(i32 noundef %75) #13
  br label %548

77:                                               ; preds = %0
  %78 = load i32, ptr @fsready, align 4, !tbaa !9
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %548, label %80

80:                                               ; preds = %77
  %81 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %82 = load volatile i32, ptr %81, align 4, !tbaa !34
  %83 = tail call i32 @kfs_chdir(i32 noundef %82) #13
  br label %548

84:                                               ; preds = %0
  %85 = load i32, ptr @fsready, align 4, !tbaa !9
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %548, label %87

87:                                               ; preds = %84
  %88 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %89 = load volatile i32, ptr %88, align 4, !tbaa !34
  %90 = tail call i32 @kfs_mkdir(i32 noundef %89) #13
  br label %548

91:                                               ; preds = %0
  %92 = load i32, ptr @fsready, align 4, !tbaa !9
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %102, label %94

94:                                               ; preds = %91
  %95 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %96 = load volatile i32, ptr %95, align 4, !tbaa !34
  %97 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %98 = load volatile i32, ptr %97, align 4, !tbaa !35
  %99 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %100 = load volatile i32, ptr %99, align 4, !tbaa !36
  %101 = tail call i32 @kfs_read(i32 noundef %96, i32 noundef %98, i32 noundef %100) #13
  br label %108

102:                                              ; preds = %91
  %103 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %104 = load volatile i32, ptr %103, align 4, !tbaa !35
  %105 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %106 = load volatile i32, ptr %105, align 4, !tbaa !36
  %107 = tail call i32 @kconsread(i32 noundef %104, i32 noundef %106) #12
  br label %108

108:                                              ; preds = %102, %94
  %109 = phi i32 [ %101, %94 ], [ %107, %102 ]
  %110 = icmp eq i32 %109, -3
  br i1 %110, label %563, label %548

111:                                              ; preds = %0
  %112 = load i32, ptr @ticks, align 4, !tbaa !9
  %113 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %114 = load volatile i32, ptr %113, align 4, !tbaa !34
  %115 = add i32 %114, %112
  %116 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %115, ptr %116, align 4, !tbaa !29
  %117 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %118 = load i32, ptr %117, align 4, !tbaa !23
  %119 = inttoptr i32 %118 to ptr
  %120 = load volatile i32, ptr %119, align 4, !tbaa !9
  %121 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %120, ptr %121, align 4, !tbaa !24
  %122 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %122, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %566

123:                                              ; preds = %10, %142
  %124 = phi i32 [ %145, %142 ], [ 0, %10 ]
  %125 = phi i32 [ %143, %142 ], [ -1, %10 ]
  %126 = phi i32 [ %144, %142 ], [ 0, %10 ]
  %127 = icmp eq i32 %124, 8
  br i1 %127, label %128, label %130

128:                                              ; preds = %123
  %129 = icmp sgt i32 %125, -1
  br i1 %129, label %146, label %159

130:                                              ; preds = %123
  %131 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %124
  %132 = load i32, ptr %131, align 4, !tbaa !14
  %133 = icmp eq i32 %132, 0
  br i1 %133, label %142, label %134

134:                                              ; preds = %130
  %135 = getelementptr inbounds nuw i8, ptr %131, i32 8
  %136 = load i32, ptr %135, align 4, !tbaa !37
  %137 = load i32, ptr %11, align 4, !tbaa !33
  %138 = icmp eq i32 %136, %137
  br i1 %138, label %139, label %142

139:                                              ; preds = %134
  %140 = icmp eq i32 %132, 5
  %141 = select i1 %140, i32 %124, i32 %125
  br label %142

142:                                              ; preds = %139, %130, %134
  %143 = phi i32 [ %125, %134 ], [ %125, %130 ], [ %141, %139 ]
  %144 = phi i32 [ %126, %134 ], [ %126, %130 ], [ 1, %139 ]
  %145 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !38

146:                                              ; preds = %128
  %147 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %148 = load volatile i32, ptr %147, align 4, !tbaa !34
  %149 = icmp eq i32 %148, 0
  br i1 %149, label %155, label %150

150:                                              ; preds = %146
  %151 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %125, i32 5
  %152 = load i32, ptr %151, align 4, !tbaa !39
  %153 = load volatile i32, ptr %147, align 4, !tbaa !34
  %154 = inttoptr i32 %153 to ptr
  store volatile i32 %152, ptr %154, align 4, !tbaa !9
  br label %155

155:                                              ; preds = %150, %146
  %156 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %125
  %157 = getelementptr inbounds nuw i8, ptr %156, i32 4
  %158 = load i32, ptr %157, align 4, !tbaa !33
  store i32 0, ptr %156, align 4, !tbaa !14
  br label %548

159:                                              ; preds = %128
  %160 = icmp eq i32 %126, 0
  br i1 %160, label %548, label %161

161:                                              ; preds = %159
  %162 = ptrtoint ptr %5 to i32
  %163 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %164 = load i32, ptr %163, align 4, !tbaa !23
  %165 = inttoptr i32 %164 to ptr
  %166 = load volatile i32, ptr %165, align 4, !tbaa !9
  %167 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %166, ptr %167, align 4, !tbaa !24
  %168 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %162, ptr %168, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  %169 = getelementptr inbounds nuw i8, ptr %8, i32 16
  %170 = load volatile i32, ptr %169, align 4, !tbaa !19
  br label %566

171:                                              ; preds = %0, %178
  %172 = phi i32 [ %179, %178 ], [ 0, %0 ]
  %173 = icmp eq i32 %172, 8
  br i1 %173, label %548, label %174

174:                                              ; preds = %171
  %175 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %172
  %176 = load i32, ptr %175, align 4, !tbaa !14
  %177 = icmp eq i32 %176, 0
  br i1 %177, label %180, label %178

178:                                              ; preds = %174
  %179 = add nuw nsw i32 %172, 1
  br label %171, !llvm.loop !40

180:                                              ; preds = %174
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(48) %175, ptr noundef nonnull align 4 dereferenceable(48) %5, i32 48, i1 false), !tbaa.struct !41
  %181 = load i32, ptr @fsready, align 4, !tbaa !9
  %182 = icmp eq i32 %181, 0
  br i1 %182, label %184, label %183

183:                                              ; preds = %180
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %172) #13
  br label %184

184:                                              ; preds = %183, %180
  %185 = load i32, ptr @nextpid, align 4, !tbaa !9
  %186 = add i32 %185, 1
  store i32 %186, ptr @nextpid, align 4, !tbaa !9
  %187 = getelementptr inbounds nuw i8, ptr %175, i32 4
  store i32 %185, ptr %187, align 4, !tbaa !33
  %188 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %189 = load i32, ptr %188, align 4, !tbaa !33
  %190 = getelementptr inbounds nuw i8, ptr %175, i32 8
  store i32 %189, ptr %190, align 4, !tbaa !37
  %191 = getelementptr inbounds nuw i8, ptr %175, i32 12
  store i32 0, ptr %191, align 4, !tbaa !16
  store i32 3, ptr %175, align 4, !tbaa !14
  %192 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %193 = load i32, ptr %192, align 4, !tbaa !23
  %194 = inttoptr i32 %193 to ptr
  %195 = load volatile i32, ptr %194, align 4, !tbaa !9
  %196 = getelementptr inbounds nuw i8, ptr %175, i32 40
  store i32 %195, ptr %196, align 4, !tbaa !24
  %197 = load volatile i32, ptr %194, align 4, !tbaa !9
  %198 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %197, ptr %198, align 4, !tbaa !24
  %199 = ptrtoint ptr %175 to i32
  %200 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %199, ptr %200, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %566

201:                                              ; preds = %0
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #14
  %202 = load i32, ptr @fsready, align 4, !tbaa !9
  %203 = icmp eq i32 %202, 0
  br i1 %203, label %299, label %204

204:                                              ; preds = %201
  %205 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %206 = load volatile i32, ptr %205, align 4, !tbaa !34
  %207 = inttoptr i32 %206 to ptr
  %208 = tail call i32 @kfs_iopen(ptr noundef %207) #13
  %209 = icmp eq i32 %208, 0
  br i1 %209, label %299, label %210

210:                                              ; preds = %204
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #14
  %211 = ptrtoint ptr %2 to i32
  %212 = call i32 @kfs_iread(i32 noundef %208, i32 noundef 0, i32 noundef %211, i32 noundef 52) #13
  %213 = icmp eq i32 %212, 52
  %214 = load i32, ptr %2, align 4
  %215 = icmp eq i32 %214, 1480674628
  %216 = select i1 %213, i1 %215, i1 false
  br i1 %216, label %217, label %297

217:                                              ; preds = %210
  %218 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %219 = load i32, ptr %218, align 4, !tbaa !9
  %220 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %221 = load i32, ptr %220, align 4, !tbaa !9
  %222 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %223 = load i32, ptr %222, align 4, !tbaa !9
  %224 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %225 = load i32, ptr %224, align 4, !tbaa !9
  %226 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %227 = load i32, ptr %226, align 4, !tbaa !9
  %228 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %229 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %230 = load i32, ptr %229, align 4, !tbaa !9
  %231 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %230, ptr %231, align 4, !tbaa !42
  %232 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %233 = load i32, ptr %232, align 4, !tbaa !9
  %234 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %233, ptr %234, align 4, !tbaa !44
  %235 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %236 = load i32, ptr %235, align 4, !tbaa !9
  %237 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %236, ptr %237, align 4, !tbaa !45
  %238 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %239 = load i32, ptr %238, align 4, !tbaa !9
  %240 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %239, ptr %240, align 4, !tbaa !46
  %241 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %242 = load i32, ptr %241, align 4, !tbaa !9
  %243 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %242, ptr %243, align 4, !tbaa !47
  %244 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %245 = load i32, ptr %244, align 4, !tbaa !9
  %246 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %245, ptr %246, align 4, !tbaa !48
  %247 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %248 = load i32, ptr %247, align 4, !tbaa !9
  %249 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %248, ptr %249, align 4, !tbaa !49
  %250 = call fastcc i32 @kalloc(i32 noundef %219) #12
  %251 = call fastcc i32 @kalloc(i32 noundef %221) #12
  %252 = add i32 %219, 52
  %253 = add i32 %221, %252
  %254 = icmp ne i32 %250, 0
  %255 = icmp ne i32 %251, 0
  %256 = select i1 %254, i1 %255, i1 false
  br i1 %256, label %257, label %263

257:                                              ; preds = %217
  %258 = call i32 @kfs_iread(i32 noundef %208, i32 noundef 52, i32 noundef %250, i32 noundef %219) #13
  %259 = icmp eq i32 %258, %219
  br i1 %259, label %260, label %263

260:                                              ; preds = %257
  %261 = call i32 @kfs_iread(i32 noundef %208, i32 noundef %252, i32 noundef %251, i32 noundef %221) #13
  %262 = icmp eq i32 %261, %221
  br i1 %262, label %264, label %263

263:                                              ; preds = %260, %257, %217
  call fastcc void @kfree(i32 noundef %250) #12
  call fastcc void @kfree(i32 noundef %251) #12
  br label %297

264:                                              ; preds = %260
  %265 = sub i32 %250, %223
  %266 = sub i32 %251, %225
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #14
  %267 = ptrtoint ptr %3 to i32
  br label %268

268:                                              ; preds = %294, %264
  %269 = phi i32 [ %253, %264 ], [ %296, %294 ]
  %270 = phi i32 [ %227, %264 ], [ %295, %294 ]
  %271 = icmp eq i32 %270, 0
  br i1 %271, label %298, label %272

272:                                              ; preds = %268
  %273 = call i32 @llvm.umin.i32(i32 %270, i32 64)
  %274 = shl nuw nsw i32 %273, 2
  %275 = call i32 @kfs_iread(i32 noundef %208, i32 noundef %269, i32 noundef %267, i32 noundef %274) #13
  %276 = icmp eq i32 %275, %274
  br i1 %276, label %277, label %298

277:                                              ; preds = %272, %280
  %278 = phi i32 [ %293, %280 ], [ 0, %272 ]
  %279 = icmp eq i32 %278, %273
  br i1 %279, label %294, label %280

280:                                              ; preds = %277
  %281 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %278
  %282 = load i32, ptr %281, align 4, !tbaa !9
  %283 = icmp slt i32 %282, 0
  %284 = select i1 %283, i32 %251, i32 %250
  %285 = and i32 %282, 1073741823
  %286 = add i32 %284, %285
  %287 = and i32 %282, 1073741824
  %288 = icmp eq i32 %287, 0
  %289 = select i1 %288, i32 %265, i32 %266
  %290 = inttoptr i32 %286 to ptr
  %291 = load volatile i32, ptr %290, align 4, !tbaa !9
  %292 = add i32 %289, %291
  store volatile i32 %292, ptr %290, align 4, !tbaa !9
  %293 = add nuw nsw i32 %278, 1
  br label %277, !llvm.loop !50

294:                                              ; preds = %277
  %295 = sub i32 %270, %273
  %296 = add i32 %274, %269
  br label %268

297:                                              ; preds = %210, %263
  call void @kfs_iclose(i32 noundef %208) #13
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %451

298:                                              ; preds = %272, %268
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #14
  call void @kfs_iclose(i32 noundef %208) #13
  store i32 0, ptr %228, align 4, !tbaa !51
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %376

299:                                              ; preds = %201, %204
  %300 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %301 = load volatile i32, ptr %300, align 4, !tbaa !34
  %302 = inttoptr i32 %301 to ptr
  br label %303

303:                                              ; preds = %322, %299
  %304 = phi i32 [ 0, %299 ], [ %323, %322 ]
  %305 = icmp eq i32 %304, 4
  br i1 %305, label %451, label %306

306:                                              ; preds = %303
  %307 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %304
  %308 = load i8, ptr %307, align 4, !tbaa !3
  %309 = icmp eq i8 %308, 0
  br i1 %309, label %451, label %310

310:                                              ; preds = %306, %319
  %311 = phi i32 [ %321, %319 ], [ 0, %306 ]
  %312 = icmp eq i32 %311, 12
  br i1 %312, label %324, label %313

313:                                              ; preds = %310
  %314 = getelementptr inbounds nuw [12 x i8], ptr %307, i32 0, i32 %311
  %315 = load i8, ptr %314, align 1, !tbaa !3
  %316 = getelementptr inbounds nuw i8, ptr %302, i32 %311
  %317 = load i8, ptr %316, align 1, !tbaa !3
  %318 = icmp eq i8 %315, %317
  br i1 %318, label %319, label %322

319:                                              ; preds = %313
  %320 = icmp eq i8 %315, 0
  %321 = add nuw nsw i32 %311, 1
  br i1 %320, label %324, label %310, !llvm.loop !52

322:                                              ; preds = %313
  %323 = add nuw nsw i32 %304, 1
  br label %303, !llvm.loop !53

324:                                              ; preds = %319, %310
  %325 = getelementptr inbounds nuw i8, ptr %307, i32 16
  %326 = load i32, ptr %325, align 4, !tbaa !54
  %327 = tail call fastcc i32 @kalloc(i32 noundef %326) #12
  %328 = getelementptr inbounds nuw i8, ptr %307, i32 24
  %329 = load i32, ptr %328, align 4, !tbaa !55
  %330 = tail call fastcc i32 @kalloc(i32 noundef %329) #12
  %331 = icmp ne i32 %327, 0
  %332 = icmp ne i32 %330, 0
  %333 = select i1 %331, i1 %332, i1 false
  br i1 %333, label %334, label %451

334:                                              ; preds = %324
  %335 = getelementptr inbounds nuw i8, ptr %307, i32 12
  %336 = load i32, ptr %335, align 4, !tbaa !56
  %337 = inttoptr i32 %336 to ptr
  %338 = inttoptr i32 %327 to ptr
  br label %339

339:                                              ; preds = %350, %334
  %340 = phi ptr [ %337, %334 ], [ %351, %350 ]
  %341 = phi ptr [ %338, %334 ], [ %353, %350 ]
  %342 = phi i32 [ 0, %334 ], [ %354, %350 ]
  %343 = load i32, ptr %325, align 4, !tbaa !54
  %344 = icmp ult i32 %342, %343
  br i1 %344, label %350, label %345

345:                                              ; preds = %339
  %346 = getelementptr inbounds nuw i8, ptr %307, i32 20
  %347 = load i32, ptr %346, align 4, !tbaa !57
  %348 = inttoptr i32 %347 to ptr
  %349 = inttoptr i32 %330 to ptr
  br label %355

350:                                              ; preds = %339
  %351 = getelementptr inbounds nuw i8, ptr %340, i32 4
  %352 = load i32, ptr %340, align 4, !tbaa !9
  %353 = getelementptr inbounds nuw i8, ptr %341, i32 4
  store i32 %352, ptr %341, align 4, !tbaa !9
  %354 = add i32 %342, 4
  br label %339, !llvm.loop !58

355:                                              ; preds = %361, %345
  %356 = phi ptr [ %348, %345 ], [ %362, %361 ]
  %357 = phi ptr [ %349, %345 ], [ %364, %361 ]
  %358 = phi i32 [ 0, %345 ], [ %365, %361 ]
  %359 = load i32, ptr %328, align 4, !tbaa !55
  %360 = icmp ult i32 %358, %359
  br i1 %360, label %361, label %366

361:                                              ; preds = %355
  %362 = getelementptr inbounds nuw i8, ptr %356, i32 4
  %363 = load i32, ptr %356, align 4, !tbaa !9
  %364 = getelementptr inbounds nuw i8, ptr %357, i32 4
  store i32 %363, ptr %357, align 4, !tbaa !9
  %365 = add i32 %358, 4
  br label %355, !llvm.loop !59

366:                                              ; preds = %355
  %367 = getelementptr inbounds nuw i8, ptr %307, i32 28
  %368 = load i32, ptr %367, align 4, !tbaa !60
  %369 = getelementptr inbounds nuw i8, ptr %307, i32 32
  %370 = load i32, ptr %369, align 4, !tbaa !61
  %371 = getelementptr inbounds nuw i8, ptr %307, i32 36
  %372 = load i32, ptr %371, align 4, !tbaa !62
  %373 = sub i32 %327, %368
  %374 = sub i32 %330, %370
  %375 = inttoptr i32 %372 to ptr
  br label %376

376:                                              ; preds = %366, %298
  %377 = phi i32 [ %374, %366 ], [ %266, %298 ]
  %378 = phi i32 [ %373, %366 ], [ %265, %298 ]
  %379 = phi ptr [ %375, %366 ], [ null, %298 ]
  %380 = phi i32 [ %330, %366 ], [ %251, %298 ]
  %381 = phi i32 [ %327, %366 ], [ %250, %298 ]
  %382 = phi ptr [ %307, %366 ], [ %1, %298 ]
  %383 = getelementptr inbounds nuw i8, ptr %382, i32 40
  br label %384

384:                                              ; preds = %396, %376
  %385 = phi i32 [ 0, %376 ], [ %409, %396 ]
  %386 = load i32, ptr %383, align 4, !tbaa !51
  %387 = icmp ult i32 %385, %386
  br i1 %387, label %396, label %388

388:                                              ; preds = %384
  %389 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %389) #12
  %390 = load i32, ptr @curr, align 4, !tbaa !9
  %391 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %390
  store i32 %381, ptr %391, align 4, !tbaa !9
  %392 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %390, i32 1
  store i32 %380, ptr %392, align 4, !tbaa !9
  %393 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %394 = load volatile i32, ptr %393, align 4, !tbaa !35
  %395 = icmp eq i32 %394, 0
  br i1 %395, label %452, label %410

396:                                              ; preds = %384
  %397 = getelementptr inbounds nuw i32, ptr %379, i32 %385
  %398 = load i32, ptr %397, align 4, !tbaa !9
  %399 = icmp slt i32 %398, 0
  %400 = select i1 %399, i32 %380, i32 %381
  %401 = and i32 %398, 1073741823
  %402 = add i32 %400, %401
  %403 = and i32 %398, 1073741824
  %404 = icmp eq i32 %403, 0
  %405 = select i1 %404, i32 %378, i32 %377
  %406 = inttoptr i32 %402 to ptr
  %407 = load volatile i32, ptr %406, align 4, !tbaa !9
  %408 = add i32 %405, %407
  store volatile i32 %408, ptr %406, align 4, !tbaa !9
  %409 = add nuw i32 %385, 1
  br label %384, !llvm.loop !63

410:                                              ; preds = %388
  %411 = call fastcc i32 @kalloc(i32 noundef 256) #12
  %412 = icmp eq i32 %411, 0
  br i1 %412, label %452, label %413

413:                                              ; preds = %410
  %414 = load volatile i32, ptr %393, align 4, !tbaa !35
  %415 = inttoptr i32 %414 to ptr
  %416 = inttoptr i32 %411 to ptr
  %417 = add i32 %411, 64
  %418 = inttoptr i32 %417 to ptr
  %419 = add i32 %411, 256
  %420 = inttoptr i32 %419 to ptr
  %421 = getelementptr inbounds i8, ptr %420, i32 -1
  br label %422

422:                                              ; preds = %444, %413
  %423 = phi i32 [ 0, %413 ], [ %446, %444 ]
  %424 = phi ptr [ %418, %413 ], [ %445, %444 ]
  %425 = icmp eq i32 %423, 15
  br i1 %425, label %447, label %426

426:                                              ; preds = %422
  %427 = getelementptr inbounds nuw i32, ptr %415, i32 %423
  %428 = load i32, ptr %427, align 4, !tbaa !9
  %429 = icmp eq i32 %428, 0
  br i1 %429, label %447, label %430

430:                                              ; preds = %426
  %431 = inttoptr i32 %428 to ptr
  %432 = ptrtoint ptr %424 to i32
  %433 = getelementptr inbounds nuw i32, ptr %416, i32 %423
  store i32 %432, ptr %433, align 4, !tbaa !9
  br label %434

434:                                              ; preds = %441, %430
  %435 = phi ptr [ %424, %430 ], [ %443, %441 ]
  %436 = phi ptr [ %431, %430 ], [ %442, %441 ]
  %437 = load i8, ptr %436, align 1, !tbaa !3
  %438 = icmp ne i8 %437, 0
  %439 = icmp ult ptr %435, %421
  %440 = select i1 %438, i1 %439, i1 false
  br i1 %440, label %441, label %444

441:                                              ; preds = %434
  %442 = getelementptr inbounds nuw i8, ptr %436, i32 1
  %443 = getelementptr inbounds nuw i8, ptr %435, i32 1
  store i8 %437, ptr %435, align 1, !tbaa !3
  br label %434, !llvm.loop !64

444:                                              ; preds = %434
  %445 = getelementptr inbounds nuw i8, ptr %435, i32 1
  store i8 0, ptr %435, align 1, !tbaa !3
  %446 = add nuw nsw i32 %423, 1
  br label %422, !llvm.loop !65

447:                                              ; preds = %422, %426
  %448 = getelementptr inbounds nuw i32, ptr %416, i32 %423
  store i32 0, ptr %448, align 4, !tbaa !9
  %449 = load i32, ptr @curr, align 4, !tbaa !9
  %450 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %449, i32 2
  store i32 %411, ptr %450, align 4, !tbaa !9
  br label %452

451:                                              ; preds = %303, %306, %324, %297
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %548

452:                                              ; preds = %388, %447, %410
  %453 = phi i32 [ 0, %388 ], [ %423, %447 ], [ 0, %410 ]
  %454 = phi i32 [ 0, %388 ], [ %411, %447 ], [ 0, %410 ]
  %455 = getelementptr inbounds nuw i8, ptr %382, i32 52
  %456 = load i32, ptr %455, align 4, !tbaa !45
  %457 = add i32 %456, %380
  %458 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %457, ptr %458, align 4, !tbaa !22
  %459 = getelementptr inbounds nuw i8, ptr %382, i32 56
  %460 = load i32, ptr %459, align 4, !tbaa !46
  %461 = add i32 %460, %380
  %462 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %461, ptr %462, align 4, !tbaa !66
  %463 = getelementptr inbounds nuw i8, ptr %382, i32 60
  %464 = load i32, ptr %463, align 4, !tbaa !47
  %465 = add i32 %464, %380
  %466 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %465, ptr %466, align 4, !tbaa !23
  %467 = getelementptr inbounds nuw i8, ptr %382, i32 48
  %468 = load i32, ptr %467, align 4, !tbaa !44
  %469 = add i32 %468, %381
  %470 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %469, ptr %470, align 4, !tbaa !28
  %471 = getelementptr inbounds nuw i8, ptr %382, i32 64
  %472 = load i32, ptr %471, align 4, !tbaa !48
  %473 = add i32 %472, %380
  store i32 %473, ptr %6, align 4, !tbaa !18
  %474 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %475 = getelementptr inbounds nuw i8, ptr %382, i32 68
  %476 = load i32, ptr %475, align 4, !tbaa !49
  %477 = add i32 %476, %380
  %478 = inttoptr i32 %477 to ptr
  store volatile i32 %474, ptr %478, align 4, !tbaa !9
  %479 = load i32, ptr %470, align 4, !tbaa !28
  %480 = load i32, ptr %458, align 4, !tbaa !22
  %481 = inttoptr i32 %480 to ptr
  store volatile i32 %479, ptr %481, align 4, !tbaa !9
  %482 = load i32, ptr %455, align 4, !tbaa !45
  %483 = add i32 %482, %380
  %484 = add i32 %483, -84
  %485 = inttoptr i32 %484 to ptr
  store volatile i32 %453, ptr %485, align 4, !tbaa !9
  %486 = add i32 %483, -80
  %487 = inttoptr i32 %486 to ptr
  store volatile i32 %454, ptr %487, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  store i32 4, ptr %5, align 4, !tbaa !14
  %488 = load i32, ptr @curr, align 4, !tbaa !9
  %489 = getelementptr inbounds nuw i8, ptr %382, i32 44
  %490 = load i32, ptr %489, align 4, !tbaa !42
  %491 = add i32 %490, %381
  call fastcc void @kexit(i32 noundef %488, i32 noundef %491) #12
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %577

492:                                              ; preds = %0
  %493 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %494 = load volatile i32, ptr %493, align 4, !tbaa !34
  %495 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store i32 %494, ptr %495, align 4, !tbaa !39
  %496 = load i32, ptr @fsready, align 4, !tbaa !9
  %497 = icmp eq i32 %496, 0
  br i1 %497, label %500, label %498

498:                                              ; preds = %492
  tail call void @kfs_exit(i32 noundef %4) #13
  %499 = load i32, ptr @curr, align 4, !tbaa !9
  br label %500

500:                                              ; preds = %498, %492
  %501 = phi i32 [ %499, %498 ], [ %4, %492 ]
  tail call fastcc void @kfree_exec(i32 noundef %501) #12
  tail call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  %502 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %503 = load i32, ptr %502, align 4, !tbaa !37
  br label %504

504:                                              ; preds = %534, %500
  %505 = phi i32 [ 0, %500 ], [ %535, %534 ]
  %506 = icmp eq i32 %505, 8
  br i1 %506, label %546, label %507

507:                                              ; preds = %504
  %508 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %505
  %509 = getelementptr inbounds nuw i8, ptr %508, i32 4
  %510 = load i32, ptr %509, align 4, !tbaa !33
  %511 = icmp eq i32 %510, %503
  br i1 %511, label %512, label %534

512:                                              ; preds = %507
  %513 = load i32, ptr %508, align 4, !tbaa !14
  %514 = icmp eq i32 %513, 2
  br i1 %514, label %515, label %534

515:                                              ; preds = %512
  %516 = getelementptr inbounds nuw i8, ptr %508, i32 12
  %517 = load i32, ptr %516, align 4, !tbaa !16
  %518 = ptrtoint ptr %508 to i32
  %519 = icmp eq i32 %517, %518
  br i1 %519, label %520, label %534

520:                                              ; preds = %515
  %521 = getelementptr inbounds nuw i8, ptr %508, i32 12
  %522 = getelementptr inbounds nuw i8, ptr %508, i32 44
  %523 = load i32, ptr %522, align 4, !tbaa !18
  %524 = inttoptr i32 %523 to ptr
  %525 = getelementptr inbounds nuw i8, ptr %524, i32 4
  %526 = load volatile i32, ptr %525, align 4, !tbaa !34
  %527 = icmp eq i32 %526, 0
  br i1 %527, label %536, label %528

528:                                              ; preds = %520
  %529 = load i32, ptr %495, align 4, !tbaa !39
  %530 = load volatile i32, ptr %525, align 4, !tbaa !34
  %531 = inttoptr i32 %530 to ptr
  store volatile i32 %529, ptr %531, align 4, !tbaa !9
  %532 = load i32, ptr %522, align 4, !tbaa !18
  %533 = inttoptr i32 %532 to ptr
  br label %536

534:                                              ; preds = %515, %512, %507
  %535 = add nuw nsw i32 %505, 1
  br label %504, !llvm.loop !67

536:                                              ; preds = %528, %520
  %537 = phi ptr [ %533, %528 ], [ %524, %520 ]
  %538 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %539 = load i32, ptr %538, align 4, !tbaa !33
  %540 = getelementptr inbounds nuw i8, ptr %537, i32 16
  store volatile i32 %539, ptr %540, align 4, !tbaa !19
  %541 = getelementptr inbounds nuw i8, ptr %537, i32 20
  store volatile i32 1, ptr %541, align 4, !tbaa !21
  %542 = getelementptr inbounds nuw i8, ptr %508, i32 24
  %543 = load i32, ptr %542, align 4, !tbaa !22
  %544 = add i32 %543, -84
  %545 = inttoptr i32 %544 to ptr
  store volatile i32 %539, ptr %545, align 4, !tbaa !9
  store i32 0, ptr %521, align 4, !tbaa !16
  store i32 3, ptr %508, align 4, !tbaa !14
  br label %546

546:                                              ; preds = %504, %536
  %547 = phi i32 [ 0, %536 ], [ 5, %504 ]
  store i32 %547, ptr %5, align 4, !tbaa !14
  br label %576

548:                                              ; preds = %171, %0, %12, %15, %35, %108, %38, %41, %47, %50, %54, %57, %61, %64, %70, %73, %77, %80, %84, %87, %155, %159, %451
  %549 = phi i32 [ -1, %451 ], [ -1, %159 ], [ %158, %155 ], [ -1, %84 ], [ %90, %87 ], [ -1, %77 ], [ %83, %80 ], [ -1, %70 ], [ %76, %73 ], [ -1, %61 ], [ %69, %64 ], [ -1, %54 ], [ %60, %57 ], [ -1, %47 ], [ %53, %50 ], [ -1, %38 ], [ %46, %41 ], [ %109, %108 ], [ %36, %35 ], [ %16, %15 ], [ %14, %12 ], [ -1, %0 ], [ -1, %171 ]
  %550 = load i32, ptr %6, align 4, !tbaa !18
  %551 = inttoptr i32 %550 to ptr
  %552 = getelementptr inbounds nuw i8, ptr %551, i32 16
  store volatile i32 %549, ptr %552, align 4, !tbaa !19
  %553 = getelementptr inbounds nuw i8, ptr %551, i32 20
  store volatile i32 1, ptr %553, align 4, !tbaa !21
  %554 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %555 = load i32, ptr %554, align 4, !tbaa !22
  %556 = add i32 %555, -84
  %557 = inttoptr i32 %556 to ptr
  store volatile i32 %549, ptr %557, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %558 = load i32, ptr @curr, align 4, !tbaa !9
  %559 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %560 = load i32, ptr %559, align 4, !tbaa !23
  %561 = inttoptr i32 %560 to ptr
  %562 = load volatile i32, ptr %561, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %558, i32 noundef %562) #12
  br label %577

563:                                              ; preds = %108, %35
  %564 = load i32, ptr %5, align 4, !tbaa !14
  %565 = icmp eq i32 %564, 2
  br i1 %565, label %566, label %576

566:                                              ; preds = %184, %161, %111, %563
  %567 = phi i32 [ -3, %563 ], [ 0, %184 ], [ %170, %161 ], [ 0, %111 ]
  %568 = load i32, ptr %6, align 4, !tbaa !18
  %569 = inttoptr i32 %568 to ptr
  %570 = getelementptr inbounds nuw i8, ptr %569, i32 16
  store volatile i32 %567, ptr %570, align 4, !tbaa !19
  %571 = getelementptr inbounds nuw i8, ptr %569, i32 20
  store volatile i32 1, ptr %571, align 4, !tbaa !21
  %572 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %573 = load i32, ptr %572, align 4, !tbaa !22
  %574 = add i32 %573, -84
  %575 = inttoptr i32 %574 to ptr
  store volatile i32 %567, ptr %575, align 4, !tbaa !9
  br label %576

576:                                              ; preds = %546, %566, %563
  tail call fastcc void @swtch() #12
  br label %577

577:                                              ; preds = %452, %576, %548
  ret void
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
declare dso_local i32 @kfs_pipe(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_chdir(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mkdir(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_read(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #9

; Function Attrs: minsize optsize
declare dso_local void @kfs_forkcopy(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iopen(ptr noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iread(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_iclose(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #10 {
  %2 = load i1, ptr @kheap_init, align 4
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  store i1 true, ptr @kheap_init, align 4
  %4 = load i32, ptr @arena, align 4, !tbaa !9
  %5 = inttoptr i32 %4 to ptr
  store ptr %5, ptr @kfreelist, align 4, !tbaa !68
  %6 = load i32, ptr @arena_end, align 4, !tbaa !9
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !70
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr null, ptr %8, align 4, !tbaa !72
  br label %9

9:                                                ; preds = %3, %1
  %10 = add i32 %0, 255
  %11 = and i32 %10, -256
  %12 = add i32 %11, 256
  br label %13

13:                                               ; preds = %38, %9
  %14 = phi ptr [ @kfreelist, %9 ], [ %39, %38 ]
  %15 = load ptr, ptr %14, align 4, !tbaa !68
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !70
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
  store i32 %21, ptr %26, align 4, !tbaa !70
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !72
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !72
  store i32 %12, ptr %15, align 4, !tbaa !70
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !72
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !68
  %37 = add i32 %35, 256
  br label %40

38:                                               ; preds = %17
  %39 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %13, !llvm.loop !73

40:                                               ; preds = %13, %34
  %41 = phi i32 [ %37, %34 ], [ 0, %13 ]
  ret i32 %41
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #10 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %41, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -256
  br label %5

5:                                                ; preds = %5, %3
  %6 = phi ptr [ null, %3 ], [ %8, %5 ]
  %7 = phi ptr [ @kfreelist, %3 ], [ %13, %5 ]
  %8 = load ptr, ptr %7, align 4, !tbaa !68
  %9 = icmp ne ptr %8, null
  %10 = ptrtoint ptr %8 to i32
  %11 = icmp ugt i32 %4, %10
  %12 = and i1 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 4
  br i1 %12, label %5, label %14, !llvm.loop !74

14:                                               ; preds = %5
  %15 = inttoptr i32 %4 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  store ptr %8, ptr %16, align 4, !tbaa !72
  %17 = icmp eq ptr %6, null
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %15, ptr %19, align 4, !tbaa !72
  br label %21

20:                                               ; preds = %14
  store ptr %15, ptr @kfreelist, align 4, !tbaa !68
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !70
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !70
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !70
  %29 = load ptr, ptr %13, align 4, !tbaa !72
  store ptr %29, ptr %16, align 4, !tbaa !72
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !70
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !70
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !70
  %39 = load ptr, ptr %16, align 4, !tbaa !72
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !72
  br label %41

41:                                               ; preds = %30, %31, %36, %1
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree_exec(i32 noundef %0) unnamed_addr #10 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i32 [ 0, %1 ], [ %9, %6 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  ret void

6:                                                ; preds = %2
  %7 = getelementptr inbounds [8 x [3 x i32]], ptr @execmem, i32 0, i32 %0, i32 %3
  %8 = load i32, ptr %7, align 4, !tbaa !9
  tail call fastcc void @kfree(i32 noundef %8) #12
  store i32 0, ptr %7, align 4, !tbaa !9
  %9 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !75
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @vfork_release(ptr noundef %0) unnamed_addr #0 {
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
  %14 = load i32, ptr %13, align 4, !tbaa !16
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr %3, align 4, !tbaa !33
  %18 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %19 = load i32, ptr %18, align 4, !tbaa !18
  %20 = inttoptr i32 %19 to ptr
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store volatile i32 %17, ptr %21, align 4, !tbaa !19
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 20
  store volatile i32 1, ptr %22, align 4, !tbaa !21
  %23 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %24 = load i32, ptr %23, align 4, !tbaa !22
  %25 = add i32 %24, -84
  %26 = inttoptr i32 %25 to ptr
  store volatile i32 %17, ptr %26, align 4, !tbaa !9
  store i32 0, ptr %13, align 4, !tbaa !16
  store i32 3, ptr %9, align 4, !tbaa !14
  br label %27

27:                                               ; preds = %16, %12, %8
  %28 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !76
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = load i32, ptr @entry_disp, align 4, !tbaa !9
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %11, label %5

5:                                                ; preds = %2
  %6 = inttoptr i32 %3 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !9
  %8 = load i32, ptr @entry_thunk, align 4, !tbaa !9
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store volatile i32 %8, ptr %6, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %11

11:                                               ; preds = %10, %5, %2
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  store i32 %0, ptr @curr, align 4, !tbaa !9
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %14 = load i32, ptr %13, align 4, !tbaa !22
  %15 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !25
  store i32 %14, ptr %15, align 4, !tbaa !9
  %16 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %17 = load i32, ptr %16, align 4, !tbaa !28
  %18 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !25
  store i32 %17, ptr %18, align 4, !tbaa !9
  %19 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %20 = load i32, ptr %19, align 4, !tbaa !66
  %21 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !25
  store i32 %20, ptr %21, align 4, !tbaa !9
  %22 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !25
  store i32 %1, ptr %22, align 4, !tbaa !9
  %23 = load i32, ptr %13, align 4, !tbaa !22
  %24 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %25 = inttoptr i32 %24 to ptr
  store volatile i32 %23, ptr %25, align 4, !tbaa !9
  %26 = load i32, ptr @tickpending, align 4, !tbaa !9
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %29, label %28

28:                                               ; preds = %11
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %29

29:                                               ; preds = %28, %11
  %30 = load i1, ptr @rearm, align 4
  br i1 %30, label %31, label %34

31:                                               ; preds = %29
  %32 = load i32, ptr @inj_treg, align 4, !tbaa !9
  %33 = inttoptr i32 %32 to ptr
  store volatile i32 1, ptr %33, align 4, !tbaa !9
  br label %34

34:                                               ; preds = %31, %29
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #6 {
  tail call void @dma_ktick() #12
  tail call void @dma_ksyscall() #12
  ret i32 0
}

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #11

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #11 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }
attributes #13 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #14 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !4, i64 0}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = !{!15, !10, i64 0}
!15 = !{!"proc", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44}
!16 = !{!15, !10, i64 12}
!17 = distinct !{!17, !7, !8}
!18 = !{!15, !10, i64 44}
!19 = !{!20, !10, i64 16}
!20 = !{!"dma_sysmail", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20}
!21 = !{!20, !10, i64 20}
!22 = !{!15, !10, i64 24}
!23 = !{!15, !10, i64 32}
!24 = !{!15, !10, i64 40}
!25 = !{!26, !26, i64 0}
!26 = !{!"p1 int", !27, i64 0}
!27 = !{!"any pointer", !4, i64 0}
!28 = !{!15, !10, i64 36}
!29 = !{!15, !10, i64 16}
!30 = distinct !{!30, !7, !8}
!31 = distinct !{!31, !7, !8}
!32 = !{!20, !10, i64 0}
!33 = !{!15, !10, i64 4}
!34 = !{!20, !10, i64 4}
!35 = !{!20, !10, i64 8}
!36 = !{!20, !10, i64 12}
!37 = !{!15, !10, i64 8}
!38 = distinct !{!38, !7, !8}
!39 = !{!15, !10, i64 20}
!40 = distinct !{!40, !7, !8}
!41 = !{i64 0, i64 4, !9, i64 4, i64 4, !9, i64 8, i64 4, !9, i64 12, i64 4, !9, i64 16, i64 4, !9, i64 20, i64 4, !9, i64 24, i64 4, !9, i64 28, i64 4, !9, i64 32, i64 4, !9, i64 36, i64 4, !9, i64 40, i64 4, !9, i64 44, i64 4, !9}
!42 = !{!43, !10, i64 44}
!43 = !{!"kimg", !4, i64 0, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48, !10, i64 52, !10, i64 56, !10, i64 60, !10, i64 64, !10, i64 68}
!44 = !{!43, !10, i64 48}
!45 = !{!43, !10, i64 52}
!46 = !{!43, !10, i64 56}
!47 = !{!43, !10, i64 60}
!48 = !{!43, !10, i64 64}
!49 = !{!43, !10, i64 68}
!50 = distinct !{!50, !7, !8}
!51 = !{!43, !10, i64 40}
!52 = distinct !{!52, !7, !8}
!53 = distinct !{!53, !7, !8}
!54 = !{!43, !10, i64 16}
!55 = !{!43, !10, i64 24}
!56 = !{!43, !10, i64 12}
!57 = !{!43, !10, i64 20}
!58 = distinct !{!58, !7, !8}
!59 = distinct !{!59, !7, !8}
!60 = !{!43, !10, i64 28}
!61 = !{!43, !10, i64 32}
!62 = !{!43, !10, i64 36}
!63 = distinct !{!63, !7, !8}
!64 = distinct !{!64, !7, !8}
!65 = distinct !{!65, !7, !8}
!66 = !{!15, !10, i64 28}
!67 = distinct !{!67, !7, !8}
!68 = !{!69, !69, i64 0}
!69 = !{!"p1 _ZTS4khdr", !27, i64 0}
!70 = !{!71, !10, i64 0}
!71 = !{!"khdr", !10, i64 0, !69, i64 4}
!72 = !{!71, !69, i64 4}
!73 = distinct !{!73, !7, !8}
!74 = distinct !{!74, !7, !8}
!75 = distinct !{!75, !7, !8}
!76 = distinct !{!76, !7, !8}
