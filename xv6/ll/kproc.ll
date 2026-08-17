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
  switch i32 %9, label %564 [
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
    i32 5, label %107
    i32 13, label %127
    i32 3, label %10
    i32 1, label %187
    i32 7, label %217
    i32 2, label %508
  ]

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %139

12:                                               ; preds = %0
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %14 = load i32, ptr %13, align 4, !tbaa !33
  br label %564

15:                                               ; preds = %0
  %16 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %564

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
  br i1 %37, label %579, label %564

38:                                               ; preds = %0
  %39 = load i32, ptr @fsready, align 4, !tbaa !9
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %564, label %41

41:                                               ; preds = %38
  %42 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %43 = load volatile i32, ptr %42, align 4, !tbaa !34
  %44 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %45 = load volatile i32, ptr %44, align 4, !tbaa !35
  %46 = tail call i32 @kfs_open(i32 noundef %43, i32 noundef %45) #13
  br label %564

47:                                               ; preds = %0
  %48 = load i32, ptr @fsready, align 4, !tbaa !9
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %564, label %50

50:                                               ; preds = %47
  %51 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %52 = load volatile i32, ptr %51, align 4, !tbaa !34
  %53 = tail call i32 @kfs_close(i32 noundef %52) #13
  br label %564

54:                                               ; preds = %0
  %55 = load i32, ptr @fsready, align 4, !tbaa !9
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %564, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !34
  %60 = tail call i32 @kfs_dup(i32 noundef %59) #13
  br label %564

61:                                               ; preds = %0
  %62 = load i32, ptr @fsready, align 4, !tbaa !9
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %564, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %66 = load volatile i32, ptr %65, align 4, !tbaa !34
  %67 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %68 = load volatile i32, ptr %67, align 4, !tbaa !35
  %69 = tail call i32 @kfs_fstat(i32 noundef %66, i32 noundef %68) #13
  br label %564

70:                                               ; preds = %0
  %71 = load i32, ptr @fsready, align 4, !tbaa !9
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %564, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %75 = load volatile i32, ptr %74, align 4, !tbaa !34
  %76 = tail call i32 @kfs_pipe(i32 noundef %75) #13
  br label %564

77:                                               ; preds = %0
  %78 = load i32, ptr @fsready, align 4, !tbaa !9
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %564, label %80

80:                                               ; preds = %77
  %81 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %82 = load volatile i32, ptr %81, align 4, !tbaa !34
  %83 = tail call i32 @kfs_chdir(i32 noundef %82) #13
  br label %564

84:                                               ; preds = %0
  %85 = load i32, ptr @fsready, align 4, !tbaa !9
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %564, label %87

87:                                               ; preds = %84
  %88 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %89 = load volatile i32, ptr %88, align 4, !tbaa !34
  %90 = tail call i32 @kfs_mkdir(i32 noundef %89) #13
  br label %564

91:                                               ; preds = %0
  %92 = load i32, ptr @fsready, align 4, !tbaa !9
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %564, label %94

94:                                               ; preds = %91
  %95 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %96 = load volatile i32, ptr %95, align 4, !tbaa !34
  %97 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %98 = load volatile i32, ptr %97, align 4, !tbaa !35
  %99 = tail call i32 @kfs_link(i32 noundef %96, i32 noundef %98) #13
  br label %564

100:                                              ; preds = %0
  %101 = load i32, ptr @fsready, align 4, !tbaa !9
  %102 = icmp eq i32 %101, 0
  br i1 %102, label %564, label %103

103:                                              ; preds = %100
  %104 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %105 = load volatile i32, ptr %104, align 4, !tbaa !34
  %106 = tail call i32 @kfs_unlink(i32 noundef %105) #13
  br label %564

107:                                              ; preds = %0
  %108 = load i32, ptr @fsready, align 4, !tbaa !9
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %118, label %110

110:                                              ; preds = %107
  %111 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %112 = load volatile i32, ptr %111, align 4, !tbaa !34
  %113 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %114 = load volatile i32, ptr %113, align 4, !tbaa !35
  %115 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %116 = load volatile i32, ptr %115, align 4, !tbaa !36
  %117 = tail call i32 @kfs_read(i32 noundef %112, i32 noundef %114, i32 noundef %116) #13
  br label %124

118:                                              ; preds = %107
  %119 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %120 = load volatile i32, ptr %119, align 4, !tbaa !35
  %121 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %122 = load volatile i32, ptr %121, align 4, !tbaa !36
  %123 = tail call i32 @kconsread(i32 noundef %120, i32 noundef %122) #12
  br label %124

124:                                              ; preds = %118, %110
  %125 = phi i32 [ %117, %110 ], [ %123, %118 ]
  %126 = icmp eq i32 %125, -3
  br i1 %126, label %579, label %564

127:                                              ; preds = %0
  %128 = load i32, ptr @ticks, align 4, !tbaa !9
  %129 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %130 = load volatile i32, ptr %129, align 4, !tbaa !34
  %131 = add i32 %130, %128
  %132 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %131, ptr %132, align 4, !tbaa !29
  %133 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %134 = load i32, ptr %133, align 4, !tbaa !23
  %135 = inttoptr i32 %134 to ptr
  %136 = load volatile i32, ptr %135, align 4, !tbaa !9
  %137 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %136, ptr %137, align 4, !tbaa !24
  %138 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %138, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %582

139:                                              ; preds = %10, %158
  %140 = phi i32 [ %161, %158 ], [ 0, %10 ]
  %141 = phi i32 [ %159, %158 ], [ -1, %10 ]
  %142 = phi i32 [ %160, %158 ], [ 0, %10 ]
  %143 = icmp eq i32 %140, 8
  br i1 %143, label %144, label %146

144:                                              ; preds = %139
  %145 = icmp sgt i32 %141, -1
  br i1 %145, label %162, label %175

146:                                              ; preds = %139
  %147 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %140
  %148 = load i32, ptr %147, align 4, !tbaa !14
  %149 = icmp eq i32 %148, 0
  br i1 %149, label %158, label %150

150:                                              ; preds = %146
  %151 = getelementptr inbounds nuw i8, ptr %147, i32 8
  %152 = load i32, ptr %151, align 4, !tbaa !37
  %153 = load i32, ptr %11, align 4, !tbaa !33
  %154 = icmp eq i32 %152, %153
  br i1 %154, label %155, label %158

155:                                              ; preds = %150
  %156 = icmp eq i32 %148, 5
  %157 = select i1 %156, i32 %140, i32 %141
  br label %158

158:                                              ; preds = %155, %146, %150
  %159 = phi i32 [ %141, %150 ], [ %141, %146 ], [ %157, %155 ]
  %160 = phi i32 [ %142, %150 ], [ %142, %146 ], [ 1, %155 ]
  %161 = add nuw nsw i32 %140, 1
  br label %139, !llvm.loop !38

162:                                              ; preds = %144
  %163 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %164 = load volatile i32, ptr %163, align 4, !tbaa !34
  %165 = icmp eq i32 %164, 0
  br i1 %165, label %171, label %166

166:                                              ; preds = %162
  %167 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %141, i32 5
  %168 = load i32, ptr %167, align 4, !tbaa !39
  %169 = load volatile i32, ptr %163, align 4, !tbaa !34
  %170 = inttoptr i32 %169 to ptr
  store volatile i32 %168, ptr %170, align 4, !tbaa !9
  br label %171

171:                                              ; preds = %166, %162
  %172 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %141
  %173 = getelementptr inbounds nuw i8, ptr %172, i32 4
  %174 = load i32, ptr %173, align 4, !tbaa !33
  store i32 0, ptr %172, align 4, !tbaa !14
  br label %564

175:                                              ; preds = %144
  %176 = icmp eq i32 %142, 0
  br i1 %176, label %564, label %177

177:                                              ; preds = %175
  %178 = ptrtoint ptr %5 to i32
  %179 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %180 = load i32, ptr %179, align 4, !tbaa !23
  %181 = inttoptr i32 %180 to ptr
  %182 = load volatile i32, ptr %181, align 4, !tbaa !9
  %183 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %182, ptr %183, align 4, !tbaa !24
  %184 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %178, ptr %184, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  %185 = getelementptr inbounds nuw i8, ptr %8, i32 16
  %186 = load volatile i32, ptr %185, align 4, !tbaa !19
  br label %582

187:                                              ; preds = %0, %194
  %188 = phi i32 [ %195, %194 ], [ 0, %0 ]
  %189 = icmp eq i32 %188, 8
  br i1 %189, label %564, label %190

190:                                              ; preds = %187
  %191 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %188
  %192 = load i32, ptr %191, align 4, !tbaa !14
  %193 = icmp eq i32 %192, 0
  br i1 %193, label %196, label %194

194:                                              ; preds = %190
  %195 = add nuw nsw i32 %188, 1
  br label %187, !llvm.loop !40

196:                                              ; preds = %190
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(48) %191, ptr noundef nonnull align 4 dereferenceable(48) %5, i32 48, i1 false), !tbaa.struct !41
  %197 = load i32, ptr @fsready, align 4, !tbaa !9
  %198 = icmp eq i32 %197, 0
  br i1 %198, label %200, label %199

199:                                              ; preds = %196
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %188) #13
  br label %200

200:                                              ; preds = %199, %196
  %201 = load i32, ptr @nextpid, align 4, !tbaa !9
  %202 = add i32 %201, 1
  store i32 %202, ptr @nextpid, align 4, !tbaa !9
  %203 = getelementptr inbounds nuw i8, ptr %191, i32 4
  store i32 %201, ptr %203, align 4, !tbaa !33
  %204 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %205 = load i32, ptr %204, align 4, !tbaa !33
  %206 = getelementptr inbounds nuw i8, ptr %191, i32 8
  store i32 %205, ptr %206, align 4, !tbaa !37
  %207 = getelementptr inbounds nuw i8, ptr %191, i32 12
  store i32 0, ptr %207, align 4, !tbaa !16
  store i32 3, ptr %191, align 4, !tbaa !14
  %208 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %209 = load i32, ptr %208, align 4, !tbaa !23
  %210 = inttoptr i32 %209 to ptr
  %211 = load volatile i32, ptr %210, align 4, !tbaa !9
  %212 = getelementptr inbounds nuw i8, ptr %191, i32 40
  store i32 %211, ptr %212, align 4, !tbaa !24
  %213 = load volatile i32, ptr %210, align 4, !tbaa !9
  %214 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %213, ptr %214, align 4, !tbaa !24
  %215 = ptrtoint ptr %191 to i32
  %216 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %215, ptr %216, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %582

217:                                              ; preds = %0
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #14
  %218 = load i32, ptr @fsready, align 4, !tbaa !9
  %219 = icmp eq i32 %218, 0
  br i1 %219, label %315, label %220

220:                                              ; preds = %217
  %221 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %222 = load volatile i32, ptr %221, align 4, !tbaa !34
  %223 = inttoptr i32 %222 to ptr
  %224 = tail call i32 @kfs_iopen(ptr noundef %223) #13
  %225 = icmp eq i32 %224, 0
  br i1 %225, label %315, label %226

226:                                              ; preds = %220
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #14
  %227 = ptrtoint ptr %2 to i32
  %228 = call i32 @kfs_iread(i32 noundef %224, i32 noundef 0, i32 noundef %227, i32 noundef 52) #13
  %229 = icmp eq i32 %228, 52
  %230 = load i32, ptr %2, align 4
  %231 = icmp eq i32 %230, 1480674628
  %232 = select i1 %229, i1 %231, i1 false
  br i1 %232, label %233, label %313

233:                                              ; preds = %226
  %234 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %235 = load i32, ptr %234, align 4, !tbaa !9
  %236 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %237 = load i32, ptr %236, align 4, !tbaa !9
  %238 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %239 = load i32, ptr %238, align 4, !tbaa !9
  %240 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %241 = load i32, ptr %240, align 4, !tbaa !9
  %242 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %243 = load i32, ptr %242, align 4, !tbaa !9
  %244 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %245 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %246 = load i32, ptr %245, align 4, !tbaa !9
  %247 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %246, ptr %247, align 4, !tbaa !42
  %248 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %249 = load i32, ptr %248, align 4, !tbaa !9
  %250 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %249, ptr %250, align 4, !tbaa !44
  %251 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %252 = load i32, ptr %251, align 4, !tbaa !9
  %253 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %252, ptr %253, align 4, !tbaa !45
  %254 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %255 = load i32, ptr %254, align 4, !tbaa !9
  %256 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %255, ptr %256, align 4, !tbaa !46
  %257 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %258 = load i32, ptr %257, align 4, !tbaa !9
  %259 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %258, ptr %259, align 4, !tbaa !47
  %260 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %261 = load i32, ptr %260, align 4, !tbaa !9
  %262 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %261, ptr %262, align 4, !tbaa !48
  %263 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %264 = load i32, ptr %263, align 4, !tbaa !9
  %265 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %264, ptr %265, align 4, !tbaa !49
  %266 = call fastcc i32 @kalloc(i32 noundef %235) #12
  %267 = call fastcc i32 @kalloc(i32 noundef %237) #12
  %268 = add i32 %235, 52
  %269 = add i32 %237, %268
  %270 = icmp ne i32 %266, 0
  %271 = icmp ne i32 %267, 0
  %272 = select i1 %270, i1 %271, i1 false
  br i1 %272, label %273, label %279

273:                                              ; preds = %233
  %274 = call i32 @kfs_iread(i32 noundef %224, i32 noundef 52, i32 noundef %266, i32 noundef %235) #13
  %275 = icmp eq i32 %274, %235
  br i1 %275, label %276, label %279

276:                                              ; preds = %273
  %277 = call i32 @kfs_iread(i32 noundef %224, i32 noundef %268, i32 noundef %267, i32 noundef %237) #13
  %278 = icmp eq i32 %277, %237
  br i1 %278, label %280, label %279

279:                                              ; preds = %276, %273, %233
  call fastcc void @kfree(i32 noundef %266) #12
  call fastcc void @kfree(i32 noundef %267) #12
  br label %313

280:                                              ; preds = %276
  %281 = sub i32 %266, %239
  %282 = sub i32 %267, %241
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #14
  %283 = ptrtoint ptr %3 to i32
  br label %284

284:                                              ; preds = %310, %280
  %285 = phi i32 [ %269, %280 ], [ %312, %310 ]
  %286 = phi i32 [ %243, %280 ], [ %311, %310 ]
  %287 = icmp eq i32 %286, 0
  br i1 %287, label %314, label %288

288:                                              ; preds = %284
  %289 = call i32 @llvm.umin.i32(i32 %286, i32 64)
  %290 = shl nuw nsw i32 %289, 2
  %291 = call i32 @kfs_iread(i32 noundef %224, i32 noundef %285, i32 noundef %283, i32 noundef %290) #13
  %292 = icmp eq i32 %291, %290
  br i1 %292, label %293, label %314

293:                                              ; preds = %288, %296
  %294 = phi i32 [ %309, %296 ], [ 0, %288 ]
  %295 = icmp eq i32 %294, %289
  br i1 %295, label %310, label %296

296:                                              ; preds = %293
  %297 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %294
  %298 = load i32, ptr %297, align 4, !tbaa !9
  %299 = icmp slt i32 %298, 0
  %300 = select i1 %299, i32 %267, i32 %266
  %301 = and i32 %298, 1073741823
  %302 = add i32 %300, %301
  %303 = and i32 %298, 1073741824
  %304 = icmp eq i32 %303, 0
  %305 = select i1 %304, i32 %281, i32 %282
  %306 = inttoptr i32 %302 to ptr
  %307 = load volatile i32, ptr %306, align 4, !tbaa !9
  %308 = add i32 %305, %307
  store volatile i32 %308, ptr %306, align 4, !tbaa !9
  %309 = add nuw nsw i32 %294, 1
  br label %293, !llvm.loop !50

310:                                              ; preds = %293
  %311 = sub i32 %286, %289
  %312 = add i32 %290, %285
  br label %284

313:                                              ; preds = %226, %279
  call void @kfs_iclose(i32 noundef %224) #13
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %467

314:                                              ; preds = %288, %284
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #14
  call void @kfs_iclose(i32 noundef %224) #13
  store i32 0, ptr %244, align 4, !tbaa !51
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %392

315:                                              ; preds = %217, %220
  %316 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %317 = load volatile i32, ptr %316, align 4, !tbaa !34
  %318 = inttoptr i32 %317 to ptr
  br label %319

319:                                              ; preds = %338, %315
  %320 = phi i32 [ 0, %315 ], [ %339, %338 ]
  %321 = icmp eq i32 %320, 4
  br i1 %321, label %467, label %322

322:                                              ; preds = %319
  %323 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %320
  %324 = load i8, ptr %323, align 4, !tbaa !3
  %325 = icmp eq i8 %324, 0
  br i1 %325, label %467, label %326

326:                                              ; preds = %322, %335
  %327 = phi i32 [ %337, %335 ], [ 0, %322 ]
  %328 = icmp eq i32 %327, 12
  br i1 %328, label %340, label %329

329:                                              ; preds = %326
  %330 = getelementptr inbounds nuw [12 x i8], ptr %323, i32 0, i32 %327
  %331 = load i8, ptr %330, align 1, !tbaa !3
  %332 = getelementptr inbounds nuw i8, ptr %318, i32 %327
  %333 = load i8, ptr %332, align 1, !tbaa !3
  %334 = icmp eq i8 %331, %333
  br i1 %334, label %335, label %338

335:                                              ; preds = %329
  %336 = icmp eq i8 %331, 0
  %337 = add nuw nsw i32 %327, 1
  br i1 %336, label %340, label %326, !llvm.loop !52

338:                                              ; preds = %329
  %339 = add nuw nsw i32 %320, 1
  br label %319, !llvm.loop !53

340:                                              ; preds = %335, %326
  %341 = getelementptr inbounds nuw i8, ptr %323, i32 16
  %342 = load i32, ptr %341, align 4, !tbaa !54
  %343 = tail call fastcc i32 @kalloc(i32 noundef %342) #12
  %344 = getelementptr inbounds nuw i8, ptr %323, i32 24
  %345 = load i32, ptr %344, align 4, !tbaa !55
  %346 = tail call fastcc i32 @kalloc(i32 noundef %345) #12
  %347 = icmp ne i32 %343, 0
  %348 = icmp ne i32 %346, 0
  %349 = select i1 %347, i1 %348, i1 false
  br i1 %349, label %350, label %467

350:                                              ; preds = %340
  %351 = getelementptr inbounds nuw i8, ptr %323, i32 12
  %352 = load i32, ptr %351, align 4, !tbaa !56
  %353 = inttoptr i32 %352 to ptr
  %354 = inttoptr i32 %343 to ptr
  br label %355

355:                                              ; preds = %366, %350
  %356 = phi ptr [ %353, %350 ], [ %367, %366 ]
  %357 = phi ptr [ %354, %350 ], [ %369, %366 ]
  %358 = phi i32 [ 0, %350 ], [ %370, %366 ]
  %359 = load i32, ptr %341, align 4, !tbaa !54
  %360 = icmp ult i32 %358, %359
  br i1 %360, label %366, label %361

361:                                              ; preds = %355
  %362 = getelementptr inbounds nuw i8, ptr %323, i32 20
  %363 = load i32, ptr %362, align 4, !tbaa !57
  %364 = inttoptr i32 %363 to ptr
  %365 = inttoptr i32 %346 to ptr
  br label %371

366:                                              ; preds = %355
  %367 = getelementptr inbounds nuw i8, ptr %356, i32 4
  %368 = load i32, ptr %356, align 4, !tbaa !9
  %369 = getelementptr inbounds nuw i8, ptr %357, i32 4
  store i32 %368, ptr %357, align 4, !tbaa !9
  %370 = add i32 %358, 4
  br label %355, !llvm.loop !58

371:                                              ; preds = %377, %361
  %372 = phi ptr [ %364, %361 ], [ %378, %377 ]
  %373 = phi ptr [ %365, %361 ], [ %380, %377 ]
  %374 = phi i32 [ 0, %361 ], [ %381, %377 ]
  %375 = load i32, ptr %344, align 4, !tbaa !55
  %376 = icmp ult i32 %374, %375
  br i1 %376, label %377, label %382

377:                                              ; preds = %371
  %378 = getelementptr inbounds nuw i8, ptr %372, i32 4
  %379 = load i32, ptr %372, align 4, !tbaa !9
  %380 = getelementptr inbounds nuw i8, ptr %373, i32 4
  store i32 %379, ptr %373, align 4, !tbaa !9
  %381 = add i32 %374, 4
  br label %371, !llvm.loop !59

382:                                              ; preds = %371
  %383 = getelementptr inbounds nuw i8, ptr %323, i32 28
  %384 = load i32, ptr %383, align 4, !tbaa !60
  %385 = getelementptr inbounds nuw i8, ptr %323, i32 32
  %386 = load i32, ptr %385, align 4, !tbaa !61
  %387 = getelementptr inbounds nuw i8, ptr %323, i32 36
  %388 = load i32, ptr %387, align 4, !tbaa !62
  %389 = sub i32 %343, %384
  %390 = sub i32 %346, %386
  %391 = inttoptr i32 %388 to ptr
  br label %392

392:                                              ; preds = %382, %314
  %393 = phi i32 [ %390, %382 ], [ %282, %314 ]
  %394 = phi i32 [ %389, %382 ], [ %281, %314 ]
  %395 = phi ptr [ %391, %382 ], [ null, %314 ]
  %396 = phi i32 [ %346, %382 ], [ %267, %314 ]
  %397 = phi i32 [ %343, %382 ], [ %266, %314 ]
  %398 = phi ptr [ %323, %382 ], [ %1, %314 ]
  %399 = getelementptr inbounds nuw i8, ptr %398, i32 40
  br label %400

400:                                              ; preds = %412, %392
  %401 = phi i32 [ 0, %392 ], [ %425, %412 ]
  %402 = load i32, ptr %399, align 4, !tbaa !51
  %403 = icmp ult i32 %401, %402
  br i1 %403, label %412, label %404

404:                                              ; preds = %400
  %405 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %405) #12
  %406 = load i32, ptr @curr, align 4, !tbaa !9
  %407 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %406
  store i32 %397, ptr %407, align 4, !tbaa !9
  %408 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %406, i32 1
  store i32 %396, ptr %408, align 4, !tbaa !9
  %409 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %410 = load volatile i32, ptr %409, align 4, !tbaa !35
  %411 = icmp eq i32 %410, 0
  br i1 %411, label %468, label %426

412:                                              ; preds = %400
  %413 = getelementptr inbounds nuw i32, ptr %395, i32 %401
  %414 = load i32, ptr %413, align 4, !tbaa !9
  %415 = icmp slt i32 %414, 0
  %416 = select i1 %415, i32 %396, i32 %397
  %417 = and i32 %414, 1073741823
  %418 = add i32 %416, %417
  %419 = and i32 %414, 1073741824
  %420 = icmp eq i32 %419, 0
  %421 = select i1 %420, i32 %394, i32 %393
  %422 = inttoptr i32 %418 to ptr
  %423 = load volatile i32, ptr %422, align 4, !tbaa !9
  %424 = add i32 %421, %423
  store volatile i32 %424, ptr %422, align 4, !tbaa !9
  %425 = add nuw i32 %401, 1
  br label %400, !llvm.loop !63

426:                                              ; preds = %404
  %427 = call fastcc i32 @kalloc(i32 noundef 256) #12
  %428 = icmp eq i32 %427, 0
  br i1 %428, label %468, label %429

429:                                              ; preds = %426
  %430 = load volatile i32, ptr %409, align 4, !tbaa !35
  %431 = inttoptr i32 %430 to ptr
  %432 = inttoptr i32 %427 to ptr
  %433 = add i32 %427, 64
  %434 = inttoptr i32 %433 to ptr
  %435 = add i32 %427, 256
  %436 = inttoptr i32 %435 to ptr
  %437 = getelementptr inbounds i8, ptr %436, i32 -1
  br label %438

438:                                              ; preds = %460, %429
  %439 = phi i32 [ 0, %429 ], [ %462, %460 ]
  %440 = phi ptr [ %434, %429 ], [ %461, %460 ]
  %441 = icmp eq i32 %439, 15
  br i1 %441, label %463, label %442

442:                                              ; preds = %438
  %443 = getelementptr inbounds nuw i32, ptr %431, i32 %439
  %444 = load i32, ptr %443, align 4, !tbaa !9
  %445 = icmp eq i32 %444, 0
  br i1 %445, label %463, label %446

446:                                              ; preds = %442
  %447 = inttoptr i32 %444 to ptr
  %448 = ptrtoint ptr %440 to i32
  %449 = getelementptr inbounds nuw i32, ptr %432, i32 %439
  store i32 %448, ptr %449, align 4, !tbaa !9
  br label %450

450:                                              ; preds = %457, %446
  %451 = phi ptr [ %440, %446 ], [ %459, %457 ]
  %452 = phi ptr [ %447, %446 ], [ %458, %457 ]
  %453 = load i8, ptr %452, align 1, !tbaa !3
  %454 = icmp ne i8 %453, 0
  %455 = icmp ult ptr %451, %437
  %456 = select i1 %454, i1 %455, i1 false
  br i1 %456, label %457, label %460

457:                                              ; preds = %450
  %458 = getelementptr inbounds nuw i8, ptr %452, i32 1
  %459 = getelementptr inbounds nuw i8, ptr %451, i32 1
  store i8 %453, ptr %451, align 1, !tbaa !3
  br label %450, !llvm.loop !64

460:                                              ; preds = %450
  %461 = getelementptr inbounds nuw i8, ptr %451, i32 1
  store i8 0, ptr %451, align 1, !tbaa !3
  %462 = add nuw nsw i32 %439, 1
  br label %438, !llvm.loop !65

463:                                              ; preds = %438, %442
  %464 = getelementptr inbounds nuw i32, ptr %432, i32 %439
  store i32 0, ptr %464, align 4, !tbaa !9
  %465 = load i32, ptr @curr, align 4, !tbaa !9
  %466 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %465, i32 2
  store i32 %427, ptr %466, align 4, !tbaa !9
  br label %468

467:                                              ; preds = %319, %322, %340, %313
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %564

468:                                              ; preds = %404, %463, %426
  %469 = phi i32 [ 0, %404 ], [ %439, %463 ], [ 0, %426 ]
  %470 = phi i32 [ 0, %404 ], [ %427, %463 ], [ 0, %426 ]
  %471 = getelementptr inbounds nuw i8, ptr %398, i32 52
  %472 = load i32, ptr %471, align 4, !tbaa !45
  %473 = add i32 %472, %396
  %474 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %473, ptr %474, align 4, !tbaa !22
  %475 = getelementptr inbounds nuw i8, ptr %398, i32 56
  %476 = load i32, ptr %475, align 4, !tbaa !46
  %477 = add i32 %476, %396
  %478 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %477, ptr %478, align 4, !tbaa !66
  %479 = getelementptr inbounds nuw i8, ptr %398, i32 60
  %480 = load i32, ptr %479, align 4, !tbaa !47
  %481 = add i32 %480, %396
  %482 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %481, ptr %482, align 4, !tbaa !23
  %483 = getelementptr inbounds nuw i8, ptr %398, i32 48
  %484 = load i32, ptr %483, align 4, !tbaa !44
  %485 = add i32 %484, %397
  %486 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %485, ptr %486, align 4, !tbaa !28
  %487 = getelementptr inbounds nuw i8, ptr %398, i32 64
  %488 = load i32, ptr %487, align 4, !tbaa !48
  %489 = add i32 %488, %396
  store i32 %489, ptr %6, align 4, !tbaa !18
  %490 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %491 = getelementptr inbounds nuw i8, ptr %398, i32 68
  %492 = load i32, ptr %491, align 4, !tbaa !49
  %493 = add i32 %492, %396
  %494 = inttoptr i32 %493 to ptr
  store volatile i32 %490, ptr %494, align 4, !tbaa !9
  %495 = load i32, ptr %486, align 4, !tbaa !28
  %496 = load i32, ptr %474, align 4, !tbaa !22
  %497 = inttoptr i32 %496 to ptr
  store volatile i32 %495, ptr %497, align 4, !tbaa !9
  %498 = load i32, ptr %471, align 4, !tbaa !45
  %499 = add i32 %498, %396
  %500 = add i32 %499, -84
  %501 = inttoptr i32 %500 to ptr
  store volatile i32 %469, ptr %501, align 4, !tbaa !9
  %502 = add i32 %499, -80
  %503 = inttoptr i32 %502 to ptr
  store volatile i32 %470, ptr %503, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  store i32 4, ptr %5, align 4, !tbaa !14
  %504 = load i32, ptr @curr, align 4, !tbaa !9
  %505 = getelementptr inbounds nuw i8, ptr %398, i32 44
  %506 = load i32, ptr %505, align 4, !tbaa !42
  %507 = add i32 %506, %397
  call fastcc void @kexit(i32 noundef %504, i32 noundef %507) #12
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %593

508:                                              ; preds = %0
  %509 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %510 = load volatile i32, ptr %509, align 4, !tbaa !34
  %511 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store i32 %510, ptr %511, align 4, !tbaa !39
  %512 = load i32, ptr @fsready, align 4, !tbaa !9
  %513 = icmp eq i32 %512, 0
  br i1 %513, label %516, label %514

514:                                              ; preds = %508
  tail call void @kfs_exit(i32 noundef %4) #13
  %515 = load i32, ptr @curr, align 4, !tbaa !9
  br label %516

516:                                              ; preds = %514, %508
  %517 = phi i32 [ %515, %514 ], [ %4, %508 ]
  tail call fastcc void @kfree_exec(i32 noundef %517) #12
  tail call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  %518 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %519 = load i32, ptr %518, align 4, !tbaa !37
  br label %520

520:                                              ; preds = %550, %516
  %521 = phi i32 [ 0, %516 ], [ %551, %550 ]
  %522 = icmp eq i32 %521, 8
  br i1 %522, label %562, label %523

523:                                              ; preds = %520
  %524 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %521
  %525 = getelementptr inbounds nuw i8, ptr %524, i32 4
  %526 = load i32, ptr %525, align 4, !tbaa !33
  %527 = icmp eq i32 %526, %519
  br i1 %527, label %528, label %550

528:                                              ; preds = %523
  %529 = load i32, ptr %524, align 4, !tbaa !14
  %530 = icmp eq i32 %529, 2
  br i1 %530, label %531, label %550

531:                                              ; preds = %528
  %532 = getelementptr inbounds nuw i8, ptr %524, i32 12
  %533 = load i32, ptr %532, align 4, !tbaa !16
  %534 = ptrtoint ptr %524 to i32
  %535 = icmp eq i32 %533, %534
  br i1 %535, label %536, label %550

536:                                              ; preds = %531
  %537 = getelementptr inbounds nuw i8, ptr %524, i32 12
  %538 = getelementptr inbounds nuw i8, ptr %524, i32 44
  %539 = load i32, ptr %538, align 4, !tbaa !18
  %540 = inttoptr i32 %539 to ptr
  %541 = getelementptr inbounds nuw i8, ptr %540, i32 4
  %542 = load volatile i32, ptr %541, align 4, !tbaa !34
  %543 = icmp eq i32 %542, 0
  br i1 %543, label %552, label %544

544:                                              ; preds = %536
  %545 = load i32, ptr %511, align 4, !tbaa !39
  %546 = load volatile i32, ptr %541, align 4, !tbaa !34
  %547 = inttoptr i32 %546 to ptr
  store volatile i32 %545, ptr %547, align 4, !tbaa !9
  %548 = load i32, ptr %538, align 4, !tbaa !18
  %549 = inttoptr i32 %548 to ptr
  br label %552

550:                                              ; preds = %531, %528, %523
  %551 = add nuw nsw i32 %521, 1
  br label %520, !llvm.loop !67

552:                                              ; preds = %544, %536
  %553 = phi ptr [ %549, %544 ], [ %540, %536 ]
  %554 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %555 = load i32, ptr %554, align 4, !tbaa !33
  %556 = getelementptr inbounds nuw i8, ptr %553, i32 16
  store volatile i32 %555, ptr %556, align 4, !tbaa !19
  %557 = getelementptr inbounds nuw i8, ptr %553, i32 20
  store volatile i32 1, ptr %557, align 4, !tbaa !21
  %558 = getelementptr inbounds nuw i8, ptr %524, i32 24
  %559 = load i32, ptr %558, align 4, !tbaa !22
  %560 = add i32 %559, -84
  %561 = inttoptr i32 %560 to ptr
  store volatile i32 %555, ptr %561, align 4, !tbaa !9
  store i32 0, ptr %537, align 4, !tbaa !16
  store i32 3, ptr %524, align 4, !tbaa !14
  br label %562

562:                                              ; preds = %520, %552
  %563 = phi i32 [ 0, %552 ], [ 5, %520 ]
  store i32 %563, ptr %5, align 4, !tbaa !14
  br label %592

564:                                              ; preds = %187, %0, %12, %15, %35, %124, %38, %41, %47, %50, %54, %57, %61, %64, %70, %73, %77, %80, %84, %87, %91, %94, %100, %103, %171, %175, %467
  %565 = phi i32 [ -1, %467 ], [ -1, %175 ], [ %174, %171 ], [ -1, %100 ], [ %106, %103 ], [ -1, %91 ], [ %99, %94 ], [ -1, %84 ], [ %90, %87 ], [ -1, %77 ], [ %83, %80 ], [ -1, %70 ], [ %76, %73 ], [ -1, %61 ], [ %69, %64 ], [ -1, %54 ], [ %60, %57 ], [ -1, %47 ], [ %53, %50 ], [ -1, %38 ], [ %46, %41 ], [ %125, %124 ], [ %36, %35 ], [ %16, %15 ], [ %14, %12 ], [ -1, %0 ], [ -1, %187 ]
  %566 = load i32, ptr %6, align 4, !tbaa !18
  %567 = inttoptr i32 %566 to ptr
  %568 = getelementptr inbounds nuw i8, ptr %567, i32 16
  store volatile i32 %565, ptr %568, align 4, !tbaa !19
  %569 = getelementptr inbounds nuw i8, ptr %567, i32 20
  store volatile i32 1, ptr %569, align 4, !tbaa !21
  %570 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %571 = load i32, ptr %570, align 4, !tbaa !22
  %572 = add i32 %571, -84
  %573 = inttoptr i32 %572 to ptr
  store volatile i32 %565, ptr %573, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %574 = load i32, ptr @curr, align 4, !tbaa !9
  %575 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %576 = load i32, ptr %575, align 4, !tbaa !23
  %577 = inttoptr i32 %576 to ptr
  %578 = load volatile i32, ptr %577, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %574, i32 noundef %578) #12
  br label %593

579:                                              ; preds = %124, %35
  %580 = load i32, ptr %5, align 4, !tbaa !14
  %581 = icmp eq i32 %580, 2
  br i1 %581, label %582, label %592

582:                                              ; preds = %200, %177, %127, %579
  %583 = phi i32 [ -3, %579 ], [ 0, %200 ], [ %186, %177 ], [ 0, %127 ]
  %584 = load i32, ptr %6, align 4, !tbaa !18
  %585 = inttoptr i32 %584 to ptr
  %586 = getelementptr inbounds nuw i8, ptr %585, i32 16
  store volatile i32 %583, ptr %586, align 4, !tbaa !19
  %587 = getelementptr inbounds nuw i8, ptr %585, i32 20
  store volatile i32 1, ptr %587, align 4, !tbaa !21
  %588 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %589 = load i32, ptr %588, align 4, !tbaa !22
  %590 = add i32 %589, -84
  %591 = inttoptr i32 %590 to ptr
  store volatile i32 %583, ptr %591, align 4, !tbaa !9
  br label %592

592:                                              ; preds = %562, %582, %579
  tail call fastcc void @swtch() #12
  br label %593

593:                                              ; preds = %468, %592, %564
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
