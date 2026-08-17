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
  tail call void @kflash_init() #13
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
  switch i32 %9, label %569 [
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
    i32 19, label %91
    i32 18, label %100
    i32 22, label %107
    i32 5, label %112
    i32 13, label %132
    i32 3, label %10
    i32 1, label %192
    i32 7, label %222
    i32 2, label %513
  ]

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %144

12:                                               ; preds = %0
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %14 = load i32, ptr %13, align 4, !tbaa !33
  br label %569

15:                                               ; preds = %0
  %16 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %569

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
  br i1 %37, label %584, label %569

38:                                               ; preds = %0
  %39 = load i32, ptr @fsready, align 4, !tbaa !9
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %569, label %41

41:                                               ; preds = %38
  %42 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %43 = load volatile i32, ptr %42, align 4, !tbaa !34
  %44 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %45 = load volatile i32, ptr %44, align 4, !tbaa !35
  %46 = tail call i32 @kfs_open(i32 noundef %43, i32 noundef %45) #13
  br label %569

47:                                               ; preds = %0
  %48 = load i32, ptr @fsready, align 4, !tbaa !9
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %569, label %50

50:                                               ; preds = %47
  %51 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %52 = load volatile i32, ptr %51, align 4, !tbaa !34
  %53 = tail call i32 @kfs_close(i32 noundef %52) #13
  br label %569

54:                                               ; preds = %0
  %55 = load i32, ptr @fsready, align 4, !tbaa !9
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %569, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !34
  %60 = tail call i32 @kfs_dup(i32 noundef %59) #13
  br label %569

61:                                               ; preds = %0
  %62 = load i32, ptr @fsready, align 4, !tbaa !9
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %569, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %66 = load volatile i32, ptr %65, align 4, !tbaa !34
  %67 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %68 = load volatile i32, ptr %67, align 4, !tbaa !35
  %69 = tail call i32 @kfs_fstat(i32 noundef %66, i32 noundef %68) #13
  br label %569

70:                                               ; preds = %0
  %71 = load i32, ptr @fsready, align 4, !tbaa !9
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %569, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %75 = load volatile i32, ptr %74, align 4, !tbaa !34
  %76 = tail call i32 @kfs_pipe(i32 noundef %75) #13
  br label %569

77:                                               ; preds = %0
  %78 = load i32, ptr @fsready, align 4, !tbaa !9
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %569, label %80

80:                                               ; preds = %77
  %81 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %82 = load volatile i32, ptr %81, align 4, !tbaa !34
  %83 = tail call i32 @kfs_chdir(i32 noundef %82) #13
  br label %569

84:                                               ; preds = %0
  %85 = load i32, ptr @fsready, align 4, !tbaa !9
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %569, label %87

87:                                               ; preds = %84
  %88 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %89 = load volatile i32, ptr %88, align 4, !tbaa !34
  %90 = tail call i32 @kfs_mkdir(i32 noundef %89) #13
  br label %569

91:                                               ; preds = %0
  %92 = load i32, ptr @fsready, align 4, !tbaa !9
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %569, label %94

94:                                               ; preds = %91
  %95 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %96 = load volatile i32, ptr %95, align 4, !tbaa !34
  %97 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %98 = load volatile i32, ptr %97, align 4, !tbaa !35
  %99 = tail call i32 @kfs_link(i32 noundef %96, i32 noundef %98) #13
  br label %569

100:                                              ; preds = %0
  %101 = load i32, ptr @fsready, align 4, !tbaa !9
  %102 = icmp eq i32 %101, 0
  br i1 %102, label %569, label %103

103:                                              ; preds = %100
  %104 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %105 = load volatile i32, ptr %104, align 4, !tbaa !34
  %106 = tail call i32 @kfs_unlink(i32 noundef %105) #13
  br label %569

107:                                              ; preds = %0
  %108 = load i32, ptr @fsready, align 4, !tbaa !9
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %569, label %110

110:                                              ; preds = %107
  %111 = tail call i32 @kflash_sync() #13
  br label %569

112:                                              ; preds = %0
  %113 = load i32, ptr @fsready, align 4, !tbaa !9
  %114 = icmp eq i32 %113, 0
  br i1 %114, label %123, label %115

115:                                              ; preds = %112
  %116 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %117 = load volatile i32, ptr %116, align 4, !tbaa !34
  %118 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %119 = load volatile i32, ptr %118, align 4, !tbaa !35
  %120 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %121 = load volatile i32, ptr %120, align 4, !tbaa !36
  %122 = tail call i32 @kfs_read(i32 noundef %117, i32 noundef %119, i32 noundef %121) #13
  br label %129

123:                                              ; preds = %112
  %124 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %125 = load volatile i32, ptr %124, align 4, !tbaa !35
  %126 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %127 = load volatile i32, ptr %126, align 4, !tbaa !36
  %128 = tail call i32 @kconsread(i32 noundef %125, i32 noundef %127) #12
  br label %129

129:                                              ; preds = %123, %115
  %130 = phi i32 [ %122, %115 ], [ %128, %123 ]
  %131 = icmp eq i32 %130, -3
  br i1 %131, label %584, label %569

132:                                              ; preds = %0
  %133 = load i32, ptr @ticks, align 4, !tbaa !9
  %134 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %135 = load volatile i32, ptr %134, align 4, !tbaa !34
  %136 = add i32 %135, %133
  %137 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %136, ptr %137, align 4, !tbaa !29
  %138 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %139 = load i32, ptr %138, align 4, !tbaa !23
  %140 = inttoptr i32 %139 to ptr
  %141 = load volatile i32, ptr %140, align 4, !tbaa !9
  %142 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %141, ptr %142, align 4, !tbaa !24
  %143 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %143, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %587

144:                                              ; preds = %10, %163
  %145 = phi i32 [ %166, %163 ], [ 0, %10 ]
  %146 = phi i32 [ %164, %163 ], [ -1, %10 ]
  %147 = phi i32 [ %165, %163 ], [ 0, %10 ]
  %148 = icmp eq i32 %145, 8
  br i1 %148, label %149, label %151

149:                                              ; preds = %144
  %150 = icmp sgt i32 %146, -1
  br i1 %150, label %167, label %180

151:                                              ; preds = %144
  %152 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %145
  %153 = load i32, ptr %152, align 4, !tbaa !14
  %154 = icmp eq i32 %153, 0
  br i1 %154, label %163, label %155

155:                                              ; preds = %151
  %156 = getelementptr inbounds nuw i8, ptr %152, i32 8
  %157 = load i32, ptr %156, align 4, !tbaa !37
  %158 = load i32, ptr %11, align 4, !tbaa !33
  %159 = icmp eq i32 %157, %158
  br i1 %159, label %160, label %163

160:                                              ; preds = %155
  %161 = icmp eq i32 %153, 5
  %162 = select i1 %161, i32 %145, i32 %146
  br label %163

163:                                              ; preds = %160, %151, %155
  %164 = phi i32 [ %146, %155 ], [ %146, %151 ], [ %162, %160 ]
  %165 = phi i32 [ %147, %155 ], [ %147, %151 ], [ 1, %160 ]
  %166 = add nuw nsw i32 %145, 1
  br label %144, !llvm.loop !38

167:                                              ; preds = %149
  %168 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %169 = load volatile i32, ptr %168, align 4, !tbaa !34
  %170 = icmp eq i32 %169, 0
  br i1 %170, label %176, label %171

171:                                              ; preds = %167
  %172 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %146, i32 5
  %173 = load i32, ptr %172, align 4, !tbaa !39
  %174 = load volatile i32, ptr %168, align 4, !tbaa !34
  %175 = inttoptr i32 %174 to ptr
  store volatile i32 %173, ptr %175, align 4, !tbaa !9
  br label %176

176:                                              ; preds = %171, %167
  %177 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %146
  %178 = getelementptr inbounds nuw i8, ptr %177, i32 4
  %179 = load i32, ptr %178, align 4, !tbaa !33
  store i32 0, ptr %177, align 4, !tbaa !14
  br label %569

180:                                              ; preds = %149
  %181 = icmp eq i32 %147, 0
  br i1 %181, label %569, label %182

182:                                              ; preds = %180
  %183 = ptrtoint ptr %5 to i32
  %184 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %185 = load i32, ptr %184, align 4, !tbaa !23
  %186 = inttoptr i32 %185 to ptr
  %187 = load volatile i32, ptr %186, align 4, !tbaa !9
  %188 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %187, ptr %188, align 4, !tbaa !24
  %189 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %183, ptr %189, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  %190 = getelementptr inbounds nuw i8, ptr %8, i32 16
  %191 = load volatile i32, ptr %190, align 4, !tbaa !19
  br label %587

192:                                              ; preds = %0, %199
  %193 = phi i32 [ %200, %199 ], [ 0, %0 ]
  %194 = icmp eq i32 %193, 8
  br i1 %194, label %569, label %195

195:                                              ; preds = %192
  %196 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %193
  %197 = load i32, ptr %196, align 4, !tbaa !14
  %198 = icmp eq i32 %197, 0
  br i1 %198, label %201, label %199

199:                                              ; preds = %195
  %200 = add nuw nsw i32 %193, 1
  br label %192, !llvm.loop !40

201:                                              ; preds = %195
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(48) %196, ptr noundef nonnull align 4 dereferenceable(48) %5, i32 48, i1 false), !tbaa.struct !41
  %202 = load i32, ptr @fsready, align 4, !tbaa !9
  %203 = icmp eq i32 %202, 0
  br i1 %203, label %205, label %204

204:                                              ; preds = %201
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %193) #13
  br label %205

205:                                              ; preds = %204, %201
  %206 = load i32, ptr @nextpid, align 4, !tbaa !9
  %207 = add i32 %206, 1
  store i32 %207, ptr @nextpid, align 4, !tbaa !9
  %208 = getelementptr inbounds nuw i8, ptr %196, i32 4
  store i32 %206, ptr %208, align 4, !tbaa !33
  %209 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %210 = load i32, ptr %209, align 4, !tbaa !33
  %211 = getelementptr inbounds nuw i8, ptr %196, i32 8
  store i32 %210, ptr %211, align 4, !tbaa !37
  %212 = getelementptr inbounds nuw i8, ptr %196, i32 12
  store i32 0, ptr %212, align 4, !tbaa !16
  store i32 3, ptr %196, align 4, !tbaa !14
  %213 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %214 = load i32, ptr %213, align 4, !tbaa !23
  %215 = inttoptr i32 %214 to ptr
  %216 = load volatile i32, ptr %215, align 4, !tbaa !9
  %217 = getelementptr inbounds nuw i8, ptr %196, i32 40
  store i32 %216, ptr %217, align 4, !tbaa !24
  %218 = load volatile i32, ptr %215, align 4, !tbaa !9
  %219 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %218, ptr %219, align 4, !tbaa !24
  %220 = ptrtoint ptr %196 to i32
  %221 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %220, ptr %221, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %587

222:                                              ; preds = %0
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #14
  %223 = load i32, ptr @fsready, align 4, !tbaa !9
  %224 = icmp eq i32 %223, 0
  br i1 %224, label %320, label %225

225:                                              ; preds = %222
  %226 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %227 = load volatile i32, ptr %226, align 4, !tbaa !34
  %228 = inttoptr i32 %227 to ptr
  %229 = tail call i32 @kfs_iopen(ptr noundef %228) #13
  %230 = icmp eq i32 %229, 0
  br i1 %230, label %320, label %231

231:                                              ; preds = %225
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #14
  %232 = ptrtoint ptr %2 to i32
  %233 = call i32 @kfs_iread(i32 noundef %229, i32 noundef 0, i32 noundef %232, i32 noundef 52) #13
  %234 = icmp eq i32 %233, 52
  %235 = load i32, ptr %2, align 4
  %236 = icmp eq i32 %235, 1480674628
  %237 = select i1 %234, i1 %236, i1 false
  br i1 %237, label %238, label %318

238:                                              ; preds = %231
  %239 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %240 = load i32, ptr %239, align 4, !tbaa !9
  %241 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %242 = load i32, ptr %241, align 4, !tbaa !9
  %243 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %244 = load i32, ptr %243, align 4, !tbaa !9
  %245 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %246 = load i32, ptr %245, align 4, !tbaa !9
  %247 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %248 = load i32, ptr %247, align 4, !tbaa !9
  %249 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %250 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %251 = load i32, ptr %250, align 4, !tbaa !9
  %252 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %251, ptr %252, align 4, !tbaa !42
  %253 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %254 = load i32, ptr %253, align 4, !tbaa !9
  %255 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %254, ptr %255, align 4, !tbaa !44
  %256 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %257 = load i32, ptr %256, align 4, !tbaa !9
  %258 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %257, ptr %258, align 4, !tbaa !45
  %259 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %260 = load i32, ptr %259, align 4, !tbaa !9
  %261 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %260, ptr %261, align 4, !tbaa !46
  %262 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %263 = load i32, ptr %262, align 4, !tbaa !9
  %264 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %263, ptr %264, align 4, !tbaa !47
  %265 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %266 = load i32, ptr %265, align 4, !tbaa !9
  %267 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %266, ptr %267, align 4, !tbaa !48
  %268 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %269 = load i32, ptr %268, align 4, !tbaa !9
  %270 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %269, ptr %270, align 4, !tbaa !49
  %271 = call fastcc i32 @kalloc(i32 noundef %240) #12
  %272 = call fastcc i32 @kalloc(i32 noundef %242) #12
  %273 = add i32 %240, 52
  %274 = add i32 %242, %273
  %275 = icmp ne i32 %271, 0
  %276 = icmp ne i32 %272, 0
  %277 = select i1 %275, i1 %276, i1 false
  br i1 %277, label %278, label %284

278:                                              ; preds = %238
  %279 = call i32 @kfs_iread(i32 noundef %229, i32 noundef 52, i32 noundef %271, i32 noundef %240) #13
  %280 = icmp eq i32 %279, %240
  br i1 %280, label %281, label %284

281:                                              ; preds = %278
  %282 = call i32 @kfs_iread(i32 noundef %229, i32 noundef %273, i32 noundef %272, i32 noundef %242) #13
  %283 = icmp eq i32 %282, %242
  br i1 %283, label %285, label %284

284:                                              ; preds = %281, %278, %238
  call fastcc void @kfree(i32 noundef %271) #12
  call fastcc void @kfree(i32 noundef %272) #12
  br label %318

285:                                              ; preds = %281
  %286 = sub i32 %271, %244
  %287 = sub i32 %272, %246
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #14
  %288 = ptrtoint ptr %3 to i32
  br label %289

289:                                              ; preds = %315, %285
  %290 = phi i32 [ %274, %285 ], [ %317, %315 ]
  %291 = phi i32 [ %248, %285 ], [ %316, %315 ]
  %292 = icmp eq i32 %291, 0
  br i1 %292, label %319, label %293

293:                                              ; preds = %289
  %294 = call i32 @llvm.umin.i32(i32 %291, i32 64)
  %295 = shl nuw nsw i32 %294, 2
  %296 = call i32 @kfs_iread(i32 noundef %229, i32 noundef %290, i32 noundef %288, i32 noundef %295) #13
  %297 = icmp eq i32 %296, %295
  br i1 %297, label %298, label %319

298:                                              ; preds = %293, %301
  %299 = phi i32 [ %314, %301 ], [ 0, %293 ]
  %300 = icmp eq i32 %299, %294
  br i1 %300, label %315, label %301

301:                                              ; preds = %298
  %302 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %299
  %303 = load i32, ptr %302, align 4, !tbaa !9
  %304 = icmp slt i32 %303, 0
  %305 = select i1 %304, i32 %272, i32 %271
  %306 = and i32 %303, 1073741823
  %307 = add i32 %305, %306
  %308 = and i32 %303, 1073741824
  %309 = icmp eq i32 %308, 0
  %310 = select i1 %309, i32 %286, i32 %287
  %311 = inttoptr i32 %307 to ptr
  %312 = load volatile i32, ptr %311, align 4, !tbaa !9
  %313 = add i32 %310, %312
  store volatile i32 %313, ptr %311, align 4, !tbaa !9
  %314 = add nuw nsw i32 %299, 1
  br label %298, !llvm.loop !50

315:                                              ; preds = %298
  %316 = sub i32 %291, %294
  %317 = add i32 %295, %290
  br label %289

318:                                              ; preds = %231, %284
  call void @kfs_iclose(i32 noundef %229) #13
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %472

319:                                              ; preds = %293, %289
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #14
  call void @kfs_iclose(i32 noundef %229) #13
  store i32 0, ptr %249, align 4, !tbaa !51
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %397

320:                                              ; preds = %222, %225
  %321 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %322 = load volatile i32, ptr %321, align 4, !tbaa !34
  %323 = inttoptr i32 %322 to ptr
  br label %324

324:                                              ; preds = %343, %320
  %325 = phi i32 [ 0, %320 ], [ %344, %343 ]
  %326 = icmp eq i32 %325, 4
  br i1 %326, label %472, label %327

327:                                              ; preds = %324
  %328 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %325
  %329 = load i8, ptr %328, align 4, !tbaa !3
  %330 = icmp eq i8 %329, 0
  br i1 %330, label %472, label %331

331:                                              ; preds = %327, %340
  %332 = phi i32 [ %342, %340 ], [ 0, %327 ]
  %333 = icmp eq i32 %332, 12
  br i1 %333, label %345, label %334

334:                                              ; preds = %331
  %335 = getelementptr inbounds nuw [12 x i8], ptr %328, i32 0, i32 %332
  %336 = load i8, ptr %335, align 1, !tbaa !3
  %337 = getelementptr inbounds nuw i8, ptr %323, i32 %332
  %338 = load i8, ptr %337, align 1, !tbaa !3
  %339 = icmp eq i8 %336, %338
  br i1 %339, label %340, label %343

340:                                              ; preds = %334
  %341 = icmp eq i8 %336, 0
  %342 = add nuw nsw i32 %332, 1
  br i1 %341, label %345, label %331, !llvm.loop !52

343:                                              ; preds = %334
  %344 = add nuw nsw i32 %325, 1
  br label %324, !llvm.loop !53

345:                                              ; preds = %340, %331
  %346 = getelementptr inbounds nuw i8, ptr %328, i32 16
  %347 = load i32, ptr %346, align 4, !tbaa !54
  %348 = tail call fastcc i32 @kalloc(i32 noundef %347) #12
  %349 = getelementptr inbounds nuw i8, ptr %328, i32 24
  %350 = load i32, ptr %349, align 4, !tbaa !55
  %351 = tail call fastcc i32 @kalloc(i32 noundef %350) #12
  %352 = icmp ne i32 %348, 0
  %353 = icmp ne i32 %351, 0
  %354 = select i1 %352, i1 %353, i1 false
  br i1 %354, label %355, label %472

355:                                              ; preds = %345
  %356 = getelementptr inbounds nuw i8, ptr %328, i32 12
  %357 = load i32, ptr %356, align 4, !tbaa !56
  %358 = inttoptr i32 %357 to ptr
  %359 = inttoptr i32 %348 to ptr
  br label %360

360:                                              ; preds = %371, %355
  %361 = phi ptr [ %358, %355 ], [ %372, %371 ]
  %362 = phi ptr [ %359, %355 ], [ %374, %371 ]
  %363 = phi i32 [ 0, %355 ], [ %375, %371 ]
  %364 = load i32, ptr %346, align 4, !tbaa !54
  %365 = icmp ult i32 %363, %364
  br i1 %365, label %371, label %366

366:                                              ; preds = %360
  %367 = getelementptr inbounds nuw i8, ptr %328, i32 20
  %368 = load i32, ptr %367, align 4, !tbaa !57
  %369 = inttoptr i32 %368 to ptr
  %370 = inttoptr i32 %351 to ptr
  br label %376

371:                                              ; preds = %360
  %372 = getelementptr inbounds nuw i8, ptr %361, i32 4
  %373 = load i32, ptr %361, align 4, !tbaa !9
  %374 = getelementptr inbounds nuw i8, ptr %362, i32 4
  store i32 %373, ptr %362, align 4, !tbaa !9
  %375 = add i32 %363, 4
  br label %360, !llvm.loop !58

376:                                              ; preds = %382, %366
  %377 = phi ptr [ %369, %366 ], [ %383, %382 ]
  %378 = phi ptr [ %370, %366 ], [ %385, %382 ]
  %379 = phi i32 [ 0, %366 ], [ %386, %382 ]
  %380 = load i32, ptr %349, align 4, !tbaa !55
  %381 = icmp ult i32 %379, %380
  br i1 %381, label %382, label %387

382:                                              ; preds = %376
  %383 = getelementptr inbounds nuw i8, ptr %377, i32 4
  %384 = load i32, ptr %377, align 4, !tbaa !9
  %385 = getelementptr inbounds nuw i8, ptr %378, i32 4
  store i32 %384, ptr %378, align 4, !tbaa !9
  %386 = add i32 %379, 4
  br label %376, !llvm.loop !59

387:                                              ; preds = %376
  %388 = getelementptr inbounds nuw i8, ptr %328, i32 28
  %389 = load i32, ptr %388, align 4, !tbaa !60
  %390 = getelementptr inbounds nuw i8, ptr %328, i32 32
  %391 = load i32, ptr %390, align 4, !tbaa !61
  %392 = getelementptr inbounds nuw i8, ptr %328, i32 36
  %393 = load i32, ptr %392, align 4, !tbaa !62
  %394 = sub i32 %348, %389
  %395 = sub i32 %351, %391
  %396 = inttoptr i32 %393 to ptr
  br label %397

397:                                              ; preds = %387, %319
  %398 = phi i32 [ %395, %387 ], [ %287, %319 ]
  %399 = phi i32 [ %394, %387 ], [ %286, %319 ]
  %400 = phi ptr [ %396, %387 ], [ null, %319 ]
  %401 = phi i32 [ %351, %387 ], [ %272, %319 ]
  %402 = phi i32 [ %348, %387 ], [ %271, %319 ]
  %403 = phi ptr [ %328, %387 ], [ %1, %319 ]
  %404 = getelementptr inbounds nuw i8, ptr %403, i32 40
  br label %405

405:                                              ; preds = %417, %397
  %406 = phi i32 [ 0, %397 ], [ %430, %417 ]
  %407 = load i32, ptr %404, align 4, !tbaa !51
  %408 = icmp ult i32 %406, %407
  br i1 %408, label %417, label %409

409:                                              ; preds = %405
  %410 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %410) #12
  %411 = load i32, ptr @curr, align 4, !tbaa !9
  %412 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %411
  store i32 %402, ptr %412, align 4, !tbaa !9
  %413 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %411, i32 1
  store i32 %401, ptr %413, align 4, !tbaa !9
  %414 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %415 = load volatile i32, ptr %414, align 4, !tbaa !35
  %416 = icmp eq i32 %415, 0
  br i1 %416, label %473, label %431

417:                                              ; preds = %405
  %418 = getelementptr inbounds nuw i32, ptr %400, i32 %406
  %419 = load i32, ptr %418, align 4, !tbaa !9
  %420 = icmp slt i32 %419, 0
  %421 = select i1 %420, i32 %401, i32 %402
  %422 = and i32 %419, 1073741823
  %423 = add i32 %421, %422
  %424 = and i32 %419, 1073741824
  %425 = icmp eq i32 %424, 0
  %426 = select i1 %425, i32 %399, i32 %398
  %427 = inttoptr i32 %423 to ptr
  %428 = load volatile i32, ptr %427, align 4, !tbaa !9
  %429 = add i32 %426, %428
  store volatile i32 %429, ptr %427, align 4, !tbaa !9
  %430 = add nuw i32 %406, 1
  br label %405, !llvm.loop !63

431:                                              ; preds = %409
  %432 = call fastcc i32 @kalloc(i32 noundef 256) #12
  %433 = icmp eq i32 %432, 0
  br i1 %433, label %473, label %434

434:                                              ; preds = %431
  %435 = load volatile i32, ptr %414, align 4, !tbaa !35
  %436 = inttoptr i32 %435 to ptr
  %437 = inttoptr i32 %432 to ptr
  %438 = add i32 %432, 64
  %439 = inttoptr i32 %438 to ptr
  %440 = add i32 %432, 256
  %441 = inttoptr i32 %440 to ptr
  %442 = getelementptr inbounds i8, ptr %441, i32 -1
  br label %443

443:                                              ; preds = %465, %434
  %444 = phi i32 [ 0, %434 ], [ %467, %465 ]
  %445 = phi ptr [ %439, %434 ], [ %466, %465 ]
  %446 = icmp eq i32 %444, 15
  br i1 %446, label %468, label %447

447:                                              ; preds = %443
  %448 = getelementptr inbounds nuw i32, ptr %436, i32 %444
  %449 = load i32, ptr %448, align 4, !tbaa !9
  %450 = icmp eq i32 %449, 0
  br i1 %450, label %468, label %451

451:                                              ; preds = %447
  %452 = inttoptr i32 %449 to ptr
  %453 = ptrtoint ptr %445 to i32
  %454 = getelementptr inbounds nuw i32, ptr %437, i32 %444
  store i32 %453, ptr %454, align 4, !tbaa !9
  br label %455

455:                                              ; preds = %462, %451
  %456 = phi ptr [ %445, %451 ], [ %464, %462 ]
  %457 = phi ptr [ %452, %451 ], [ %463, %462 ]
  %458 = load i8, ptr %457, align 1, !tbaa !3
  %459 = icmp ne i8 %458, 0
  %460 = icmp ult ptr %456, %442
  %461 = select i1 %459, i1 %460, i1 false
  br i1 %461, label %462, label %465

462:                                              ; preds = %455
  %463 = getelementptr inbounds nuw i8, ptr %457, i32 1
  %464 = getelementptr inbounds nuw i8, ptr %456, i32 1
  store i8 %458, ptr %456, align 1, !tbaa !3
  br label %455, !llvm.loop !64

465:                                              ; preds = %455
  %466 = getelementptr inbounds nuw i8, ptr %456, i32 1
  store i8 0, ptr %456, align 1, !tbaa !3
  %467 = add nuw nsw i32 %444, 1
  br label %443, !llvm.loop !65

468:                                              ; preds = %443, %447
  %469 = getelementptr inbounds nuw i32, ptr %437, i32 %444
  store i32 0, ptr %469, align 4, !tbaa !9
  %470 = load i32, ptr @curr, align 4, !tbaa !9
  %471 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %470, i32 2
  store i32 %432, ptr %471, align 4, !tbaa !9
  br label %473

472:                                              ; preds = %324, %327, %345, %318
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %569

473:                                              ; preds = %409, %468, %431
  %474 = phi i32 [ 0, %409 ], [ %444, %468 ], [ 0, %431 ]
  %475 = phi i32 [ 0, %409 ], [ %432, %468 ], [ 0, %431 ]
  %476 = getelementptr inbounds nuw i8, ptr %403, i32 52
  %477 = load i32, ptr %476, align 4, !tbaa !45
  %478 = add i32 %477, %401
  %479 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %478, ptr %479, align 4, !tbaa !22
  %480 = getelementptr inbounds nuw i8, ptr %403, i32 56
  %481 = load i32, ptr %480, align 4, !tbaa !46
  %482 = add i32 %481, %401
  %483 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %482, ptr %483, align 4, !tbaa !66
  %484 = getelementptr inbounds nuw i8, ptr %403, i32 60
  %485 = load i32, ptr %484, align 4, !tbaa !47
  %486 = add i32 %485, %401
  %487 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %486, ptr %487, align 4, !tbaa !23
  %488 = getelementptr inbounds nuw i8, ptr %403, i32 48
  %489 = load i32, ptr %488, align 4, !tbaa !44
  %490 = add i32 %489, %402
  %491 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %490, ptr %491, align 4, !tbaa !28
  %492 = getelementptr inbounds nuw i8, ptr %403, i32 64
  %493 = load i32, ptr %492, align 4, !tbaa !48
  %494 = add i32 %493, %401
  store i32 %494, ptr %6, align 4, !tbaa !18
  %495 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %496 = getelementptr inbounds nuw i8, ptr %403, i32 68
  %497 = load i32, ptr %496, align 4, !tbaa !49
  %498 = add i32 %497, %401
  %499 = inttoptr i32 %498 to ptr
  store volatile i32 %495, ptr %499, align 4, !tbaa !9
  %500 = load i32, ptr %491, align 4, !tbaa !28
  %501 = load i32, ptr %479, align 4, !tbaa !22
  %502 = inttoptr i32 %501 to ptr
  store volatile i32 %500, ptr %502, align 4, !tbaa !9
  %503 = load i32, ptr %476, align 4, !tbaa !45
  %504 = add i32 %503, %401
  %505 = add i32 %504, -84
  %506 = inttoptr i32 %505 to ptr
  store volatile i32 %474, ptr %506, align 4, !tbaa !9
  %507 = add i32 %504, -80
  %508 = inttoptr i32 %507 to ptr
  store volatile i32 %475, ptr %508, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  store i32 4, ptr %5, align 4, !tbaa !14
  %509 = load i32, ptr @curr, align 4, !tbaa !9
  %510 = getelementptr inbounds nuw i8, ptr %403, i32 44
  %511 = load i32, ptr %510, align 4, !tbaa !42
  %512 = add i32 %511, %402
  call fastcc void @kexit(i32 noundef %509, i32 noundef %512) #12
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %598

513:                                              ; preds = %0
  %514 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %515 = load volatile i32, ptr %514, align 4, !tbaa !34
  %516 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store i32 %515, ptr %516, align 4, !tbaa !39
  %517 = load i32, ptr @fsready, align 4, !tbaa !9
  %518 = icmp eq i32 %517, 0
  br i1 %518, label %521, label %519

519:                                              ; preds = %513
  tail call void @kfs_exit(i32 noundef %4) #13
  %520 = load i32, ptr @curr, align 4, !tbaa !9
  br label %521

521:                                              ; preds = %519, %513
  %522 = phi i32 [ %520, %519 ], [ %4, %513 ]
  tail call fastcc void @kfree_exec(i32 noundef %522) #12
  tail call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  %523 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %524 = load i32, ptr %523, align 4, !tbaa !37
  br label %525

525:                                              ; preds = %555, %521
  %526 = phi i32 [ 0, %521 ], [ %556, %555 ]
  %527 = icmp eq i32 %526, 8
  br i1 %527, label %567, label %528

528:                                              ; preds = %525
  %529 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %526
  %530 = getelementptr inbounds nuw i8, ptr %529, i32 4
  %531 = load i32, ptr %530, align 4, !tbaa !33
  %532 = icmp eq i32 %531, %524
  br i1 %532, label %533, label %555

533:                                              ; preds = %528
  %534 = load i32, ptr %529, align 4, !tbaa !14
  %535 = icmp eq i32 %534, 2
  br i1 %535, label %536, label %555

536:                                              ; preds = %533
  %537 = getelementptr inbounds nuw i8, ptr %529, i32 12
  %538 = load i32, ptr %537, align 4, !tbaa !16
  %539 = ptrtoint ptr %529 to i32
  %540 = icmp eq i32 %538, %539
  br i1 %540, label %541, label %555

541:                                              ; preds = %536
  %542 = getelementptr inbounds nuw i8, ptr %529, i32 12
  %543 = getelementptr inbounds nuw i8, ptr %529, i32 44
  %544 = load i32, ptr %543, align 4, !tbaa !18
  %545 = inttoptr i32 %544 to ptr
  %546 = getelementptr inbounds nuw i8, ptr %545, i32 4
  %547 = load volatile i32, ptr %546, align 4, !tbaa !34
  %548 = icmp eq i32 %547, 0
  br i1 %548, label %557, label %549

549:                                              ; preds = %541
  %550 = load i32, ptr %516, align 4, !tbaa !39
  %551 = load volatile i32, ptr %546, align 4, !tbaa !34
  %552 = inttoptr i32 %551 to ptr
  store volatile i32 %550, ptr %552, align 4, !tbaa !9
  %553 = load i32, ptr %543, align 4, !tbaa !18
  %554 = inttoptr i32 %553 to ptr
  br label %557

555:                                              ; preds = %536, %533, %528
  %556 = add nuw nsw i32 %526, 1
  br label %525, !llvm.loop !67

557:                                              ; preds = %549, %541
  %558 = phi ptr [ %554, %549 ], [ %545, %541 ]
  %559 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %560 = load i32, ptr %559, align 4, !tbaa !33
  %561 = getelementptr inbounds nuw i8, ptr %558, i32 16
  store volatile i32 %560, ptr %561, align 4, !tbaa !19
  %562 = getelementptr inbounds nuw i8, ptr %558, i32 20
  store volatile i32 1, ptr %562, align 4, !tbaa !21
  %563 = getelementptr inbounds nuw i8, ptr %529, i32 24
  %564 = load i32, ptr %563, align 4, !tbaa !22
  %565 = add i32 %564, -84
  %566 = inttoptr i32 %565 to ptr
  store volatile i32 %560, ptr %566, align 4, !tbaa !9
  store i32 0, ptr %542, align 4, !tbaa !16
  store i32 3, ptr %529, align 4, !tbaa !14
  br label %567

567:                                              ; preds = %525, %557
  %568 = phi i32 [ 0, %557 ], [ 5, %525 ]
  store i32 %568, ptr %5, align 4, !tbaa !14
  br label %597

569:                                              ; preds = %192, %0, %12, %15, %35, %129, %38, %41, %47, %50, %54, %57, %61, %64, %70, %73, %77, %80, %84, %87, %91, %94, %100, %103, %107, %110, %176, %180, %472
  %570 = phi i32 [ -1, %472 ], [ -1, %180 ], [ %179, %176 ], [ -1, %107 ], [ %111, %110 ], [ -1, %100 ], [ %106, %103 ], [ -1, %91 ], [ %99, %94 ], [ -1, %84 ], [ %90, %87 ], [ -1, %77 ], [ %83, %80 ], [ -1, %70 ], [ %76, %73 ], [ -1, %61 ], [ %69, %64 ], [ -1, %54 ], [ %60, %57 ], [ -1, %47 ], [ %53, %50 ], [ -1, %38 ], [ %46, %41 ], [ %130, %129 ], [ %36, %35 ], [ %16, %15 ], [ %14, %12 ], [ -1, %0 ], [ -1, %192 ]
  %571 = load i32, ptr %6, align 4, !tbaa !18
  %572 = inttoptr i32 %571 to ptr
  %573 = getelementptr inbounds nuw i8, ptr %572, i32 16
  store volatile i32 %570, ptr %573, align 4, !tbaa !19
  %574 = getelementptr inbounds nuw i8, ptr %572, i32 20
  store volatile i32 1, ptr %574, align 4, !tbaa !21
  %575 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %576 = load i32, ptr %575, align 4, !tbaa !22
  %577 = add i32 %576, -84
  %578 = inttoptr i32 %577 to ptr
  store volatile i32 %570, ptr %578, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %579 = load i32, ptr @curr, align 4, !tbaa !9
  %580 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %581 = load i32, ptr %580, align 4, !tbaa !23
  %582 = inttoptr i32 %581 to ptr
  %583 = load volatile i32, ptr %582, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %579, i32 noundef %583) #12
  br label %598

584:                                              ; preds = %129, %35
  %585 = load i32, ptr %5, align 4, !tbaa !14
  %586 = icmp eq i32 %585, 2
  br i1 %586, label %587, label %597

587:                                              ; preds = %205, %182, %132, %584
  %588 = phi i32 [ -3, %584 ], [ 0, %205 ], [ %191, %182 ], [ 0, %132 ]
  %589 = load i32, ptr %6, align 4, !tbaa !18
  %590 = inttoptr i32 %589 to ptr
  %591 = getelementptr inbounds nuw i8, ptr %590, i32 16
  store volatile i32 %588, ptr %591, align 4, !tbaa !19
  %592 = getelementptr inbounds nuw i8, ptr %590, i32 20
  store volatile i32 1, ptr %592, align 4, !tbaa !21
  %593 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %594 = load i32, ptr %593, align 4, !tbaa !22
  %595 = add i32 %594, -84
  %596 = inttoptr i32 %595 to ptr
  store volatile i32 %588, ptr %596, align 4, !tbaa !9
  br label %597

597:                                              ; preds = %567, %587, %584
  tail call fastcc void @swtch() #12
  br label %598

598:                                              ; preds = %473, %597, %569
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
declare dso_local i32 @kfs_link(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_unlink(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sync() local_unnamed_addr #8

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

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #8

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
