; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@inj_wreg = dso_local local_unnamed_addr global i32 1342177476, align 4
@inj_treg = dso_local local_unnamed_addr global i32 1342177500, align 4
@cons_r = internal unnamed_addr global i32 0, align 4
@cons_w = internal unnamed_addr global i32 0, align 4
@cons_buf = internal unnamed_addr global [128 x i8] zeroinitializer, align 1
@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@waspark = internal unnamed_addr global i32 0, align 4
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
@kw_park = dso_local global ptr null, align 4
@kw_parkvec = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@kimages = dso_local local_unnamed_addr global [4 x %struct.kimg] zeroinitializer, align 4
@initpid = dso_local local_unnamed_addr global i32 0, align 4
@arena = dso_local local_unnamed_addr global i32 0, align 4
@arena_end = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@cons_e = internal unnamed_addr global i32 0, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@parked = internal unnamed_addr global i1 false, align 4
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
  %1 = load i32, ptr @waspark, align 4, !tbaa !9
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %17

3:                                                ; preds = %0
  %4 = load i32, ptr @curr, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !25
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %16

9:                                                ; preds = %3
  %10 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !26
  %11 = load i32, ptr %10, align 4, !tbaa !9
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %11, ptr %12, align 4, !tbaa !24
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
  %8 = load i1, ptr @parked, align 4
  %9 = zext i1 %8 to i32
  store i32 %9, ptr @waspark, align 4, !tbaa !9
  br i1 %8, label %10, label %11

10:                                               ; preds = %7
  store i1 false, ptr @parked, align 4
  store i32 0, ptr @entry_disp, align 4, !tbaa !9
  br label %22

11:                                               ; preds = %7
  %12 = load i32, ptr @curr, align 4, !tbaa !9
  %13 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %12
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 24
  %15 = load i32, ptr %14, align 4, !tbaa !22
  store i32 %15, ptr @entry_disp, align 4, !tbaa !9
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 36
  %17 = load i32, ptr %16, align 4, !tbaa !29
  store i32 %17, ptr @entry_thunk, align 4, !tbaa !9
  %18 = inttoptr i32 %15 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !9
  %20 = icmp eq i32 %19, %17
  br i1 %20, label %22, label %21

21:                                               ; preds = %11
  store volatile i32 %17, ptr %18, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %22

22:                                               ; preds = %11, %21, %10
  %23 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %24 = inttoptr i32 %23 to ptr
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr %24, align 4, !tbaa !9
  %25 = load i32, ptr @tickpending, align 4, !tbaa !9
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %28, label %27

27:                                               ; preds = %22
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %28

28:                                               ; preds = %27, %22
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
  %17 = load i32, ptr %16, align 4, !tbaa !30
  %18 = sub i32 %2, %17
  %19 = icmp sgt i32 %18, -1
  br i1 %19, label %20, label %21

20:                                               ; preds = %15
  store i32 0, ptr %12, align 4, !tbaa !16
  store i32 3, ptr %8, align 4, !tbaa !14
  br label %21

21:                                               ; preds = %20, %15, %11, %7
  %22 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !31
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @terminate(ptr noundef %0, i32 noundef %1) unnamed_addr #6 {
  %3 = ptrtoint ptr %0 to i32
  %4 = sub i32 %3, ptrtoint (ptr @proc to i32)
  %5 = sdiv exact i32 %4, 52
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %6, align 4, !tbaa !32
  %7 = load i32, ptr @fsready, align 4, !tbaa !9
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %2
  tail call void @kfs_exit(i32 noundef %5) #13
  br label %10

10:                                               ; preds = %9, %2
  tail call fastcc void @kfree_exec(i32 noundef %5) #12
  tail call fastcc void @vfork_release(ptr noundef nonnull %0) #12
  %11 = load i32, ptr @initpid, align 4, !tbaa !9
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %34, label %13

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 4
  br label %15

15:                                               ; preds = %13, %32
  %16 = phi i32 [ %33, %32 ], [ 0, %13 ]
  %17 = icmp eq i32 %16, 8
  br i1 %17, label %34, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %16
  %20 = load i32, ptr %19, align 4, !tbaa !14
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %32, label %22

22:                                               ; preds = %18
  %23 = icmp eq ptr %19, %0
  br i1 %23, label %32, label %24

24:                                               ; preds = %22
  %25 = getelementptr inbounds nuw i8, ptr %19, i32 8
  %26 = load i32, ptr %25, align 4, !tbaa !33
  %27 = load i32, ptr %14, align 4, !tbaa !34
  %28 = icmp eq i32 %26, %27
  br i1 %28, label %29, label %32

29:                                               ; preds = %24
  store i32 %11, ptr %25, align 4, !tbaa !33
  %30 = icmp eq i32 %20, 5
  br i1 %30, label %31, label %32

31:                                               ; preds = %29
  store i32 0, ptr %19, align 4, !tbaa !14
  br label %32

32:                                               ; preds = %29, %31, %24, %22, %18
  %33 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !35

34:                                               ; preds = %15, %10
  %35 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %36 = load i32, ptr %35, align 4, !tbaa !33
  br label %37

37:                                               ; preds = %67, %34
  %38 = phi i32 [ 0, %34 ], [ %68, %67 ]
  %39 = icmp eq i32 %38, 8
  br i1 %39, label %79, label %40

40:                                               ; preds = %37
  %41 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %38
  %42 = getelementptr inbounds nuw i8, ptr %41, i32 4
  %43 = load i32, ptr %42, align 4, !tbaa !34
  %44 = icmp eq i32 %43, %36
  br i1 %44, label %45, label %67

45:                                               ; preds = %40
  %46 = load i32, ptr %41, align 4, !tbaa !14
  %47 = icmp eq i32 %46, 2
  br i1 %47, label %48, label %67

48:                                               ; preds = %45
  %49 = getelementptr inbounds nuw i8, ptr %41, i32 12
  %50 = load i32, ptr %49, align 4, !tbaa !16
  %51 = ptrtoint ptr %41 to i32
  %52 = icmp eq i32 %50, %51
  br i1 %52, label %53, label %67

53:                                               ; preds = %48
  %54 = getelementptr inbounds nuw i8, ptr %41, i32 12
  %55 = getelementptr inbounds nuw i8, ptr %41, i32 44
  %56 = load i32, ptr %55, align 4, !tbaa !18
  %57 = inttoptr i32 %56 to ptr
  %58 = getelementptr inbounds nuw i8, ptr %57, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !36
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %69, label %61

61:                                               ; preds = %53
  %62 = load i32, ptr %6, align 4, !tbaa !32
  %63 = load volatile i32, ptr %58, align 4, !tbaa !36
  %64 = inttoptr i32 %63 to ptr
  store volatile i32 %62, ptr %64, align 4, !tbaa !9
  %65 = load i32, ptr %55, align 4, !tbaa !18
  %66 = inttoptr i32 %65 to ptr
  br label %69

67:                                               ; preds = %48, %45, %40
  %68 = add nuw nsw i32 %38, 1
  br label %37, !llvm.loop !37

69:                                               ; preds = %61, %53
  %70 = phi ptr [ %66, %61 ], [ %57, %53 ]
  %71 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %72 = load i32, ptr %71, align 4, !tbaa !34
  %73 = getelementptr inbounds nuw i8, ptr %70, i32 16
  store volatile i32 %72, ptr %73, align 4, !tbaa !19
  %74 = getelementptr inbounds nuw i8, ptr %70, i32 20
  store volatile i32 1, ptr %74, align 4, !tbaa !21
  %75 = getelementptr inbounds nuw i8, ptr %41, i32 24
  %76 = load i32, ptr %75, align 4, !tbaa !22
  %77 = add i32 %76, -84
  %78 = inttoptr i32 %77 to ptr
  store volatile i32 %72, ptr %78, align 4, !tbaa !9
  store i32 0, ptr %54, align 4, !tbaa !16
  store i32 3, ptr %41, align 4, !tbaa !14
  br label %83

79:                                               ; preds = %37
  br i1 %12, label %82, label %80

80:                                               ; preds = %79
  %81 = icmp eq i32 %36, %11
  br i1 %81, label %83, label %82

82:                                               ; preds = %80, %79
  br label %83

83:                                               ; preds = %69, %80, %82
  %84 = phi i32 [ 5, %82 ], [ 0, %80 ], [ 0, %69 ]
  store i32 %84, ptr %0, align 4, !tbaa !14
  %85 = getelementptr inbounds nuw i8, ptr %0, i32 48
  store i32 0, ptr %85, align 4, !tbaa !25
  ret void
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
  br i1 %10, label %12, label %2, !llvm.loop !38

12:                                               ; preds = %5
  %13 = icmp slt i32 %7, 0
  br i1 %13, label %14, label %51

14:                                               ; preds = %2, %12
  %15 = load i32, ptr @entry_disp, align 4, !tbaa !9
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %23, label %17

17:                                               ; preds = %14
  %18 = inttoptr i32 %15 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !9
  %20 = load i32, ptr @entry_thunk, align 4, !tbaa !9
  %21 = icmp eq i32 %19, %20
  br i1 %21, label %23, label %22

22:                                               ; preds = %17
  store volatile i32 %20, ptr %18, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %23

23:                                               ; preds = %22, %17, %14
  %24 = load volatile ptr, ptr @kw_park, align 4, !tbaa !26
  %25 = ptrtoint ptr %24 to i32
  %26 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !26
  store i32 %25, ptr %26, align 4, !tbaa !9
  %27 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !26
  %28 = ptrtoint ptr %27 to i32
  %29 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !26
  store i32 %28, ptr %29, align 4, !tbaa !9
  %30 = load volatile ptr, ptr @kw_park, align 4, !tbaa !26
  %31 = ptrtoint ptr %30 to i32
  %32 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !26
  store i32 %31, ptr %32, align 4, !tbaa !9
  %33 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !26
  %34 = ptrtoint ptr %33 to i32
  %35 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !26
  store i32 %34, ptr %35, align 4, !tbaa !9
  %36 = load volatile ptr, ptr @kw_park, align 4, !tbaa !26
  %37 = ptrtoint ptr %36 to i32
  %38 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !26
  store i32 %37, ptr %38, align 4, !tbaa !9
  %39 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !26
  %40 = ptrtoint ptr %39 to i32
  %41 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %42 = inttoptr i32 %41 to ptr
  store volatile i32 %40, ptr %42, align 4, !tbaa !9
  store i1 true, ptr @parked, align 4
  %43 = load i32, ptr @tickpending, align 4, !tbaa !9
  %44 = icmp eq i32 %43, 0
  br i1 %44, label %46, label %45

45:                                               ; preds = %23
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %46

46:                                               ; preds = %45, %23
  %47 = load i1, ptr @rearm, align 4
  br i1 %47, label %48, label %54

48:                                               ; preds = %46
  %49 = load i32, ptr @inj_treg, align 4, !tbaa !9
  %50 = inttoptr i32 %49 to ptr
  store volatile i32 1, ptr %50, align 4, !tbaa !9
  br label %54

51:                                               ; preds = %12
  %52 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %53 = load i32, ptr %52, align 4, !tbaa !24
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %53) #12
  br label %54

54:                                               ; preds = %46, %48, %51
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
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !25
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #12
  tail call fastcc void @swtch() #12
  br label %578

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %12 = load i32, ptr %11, align 4, !tbaa !18
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !39
  switch i32 %14, label %546 [
    i32 11, label %19
    i32 14, label %22
    i32 16, label %24
    i32 15, label %45
    i32 21, label %54
    i32 10, label %61
    i32 8, label %68
    i32 4, label %77
    i32 9, label %84
    i32 20, label %91
    i32 19, label %98
    i32 18, label %107
    i32 22, label %114
    i32 5, label %119
    i32 13, label %139
    i32 3, label %17
    i32 1, label %199
    i32 7, label %229
    i32 2, label %520
    i32 6, label %15
  ]

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 4
  br label %523

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %151

19:                                               ; preds = %10
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !34
  br label %546

22:                                               ; preds = %10
  %23 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %546

24:                                               ; preds = %10
  %25 = load i32, ptr @fsready, align 4, !tbaa !9
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %35, label %27

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %29 = load volatile i32, ptr %28, align 4, !tbaa !36
  %30 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %31 = load volatile i32, ptr %30, align 4, !tbaa !40
  %32 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %33 = load volatile i32, ptr %32, align 4, !tbaa !41
  %34 = tail call i32 @kfs_write(i32 noundef %29, i32 noundef %31, i32 noundef %33) #13
  br label %42

35:                                               ; preds = %24
  %36 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %37 = load volatile i32, ptr %36, align 4, !tbaa !40
  %38 = inttoptr i32 %37 to ptr
  %39 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %40 = load volatile i32, ptr %39, align 4, !tbaa !41
  tail call void @kconswrite(ptr noundef %38, i32 noundef %40) #12
  %41 = load volatile i32, ptr %39, align 4, !tbaa !41
  br label %42

42:                                               ; preds = %35, %27
  %43 = phi i32 [ %34, %27 ], [ %41, %35 ]
  %44 = icmp eq i32 %43, -3
  br i1 %44, label %563, label %546

45:                                               ; preds = %10
  %46 = load i32, ptr @fsready, align 4, !tbaa !9
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %546, label %48

48:                                               ; preds = %45
  %49 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %50 = load volatile i32, ptr %49, align 4, !tbaa !36
  %51 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %52 = load volatile i32, ptr %51, align 4, !tbaa !40
  %53 = tail call i32 @kfs_open(i32 noundef %50, i32 noundef %52) #13
  br label %546

54:                                               ; preds = %10
  %55 = load i32, ptr @fsready, align 4, !tbaa !9
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %546, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !36
  %60 = tail call i32 @kfs_close(i32 noundef %59) #13
  br label %546

61:                                               ; preds = %10
  %62 = load i32, ptr @fsready, align 4, !tbaa !9
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %546, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %66 = load volatile i32, ptr %65, align 4, !tbaa !36
  %67 = tail call i32 @kfs_dup(i32 noundef %66) #13
  br label %546

68:                                               ; preds = %10
  %69 = load i32, ptr @fsready, align 4, !tbaa !9
  %70 = icmp eq i32 %69, 0
  br i1 %70, label %546, label %71

71:                                               ; preds = %68
  %72 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %73 = load volatile i32, ptr %72, align 4, !tbaa !36
  %74 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %75 = load volatile i32, ptr %74, align 4, !tbaa !40
  %76 = tail call i32 @kfs_fstat(i32 noundef %73, i32 noundef %75) #13
  br label %546

77:                                               ; preds = %10
  %78 = load i32, ptr @fsready, align 4, !tbaa !9
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %546, label %80

80:                                               ; preds = %77
  %81 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %82 = load volatile i32, ptr %81, align 4, !tbaa !36
  %83 = tail call i32 @kfs_pipe(i32 noundef %82) #13
  br label %546

84:                                               ; preds = %10
  %85 = load i32, ptr @fsready, align 4, !tbaa !9
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %546, label %87

87:                                               ; preds = %84
  %88 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %89 = load volatile i32, ptr %88, align 4, !tbaa !36
  %90 = tail call i32 @kfs_chdir(i32 noundef %89) #13
  br label %546

91:                                               ; preds = %10
  %92 = load i32, ptr @fsready, align 4, !tbaa !9
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %546, label %94

94:                                               ; preds = %91
  %95 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %96 = load volatile i32, ptr %95, align 4, !tbaa !36
  %97 = tail call i32 @kfs_mkdir(i32 noundef %96) #13
  br label %546

98:                                               ; preds = %10
  %99 = load i32, ptr @fsready, align 4, !tbaa !9
  %100 = icmp eq i32 %99, 0
  br i1 %100, label %546, label %101

101:                                              ; preds = %98
  %102 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %103 = load volatile i32, ptr %102, align 4, !tbaa !36
  %104 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %105 = load volatile i32, ptr %104, align 4, !tbaa !40
  %106 = tail call i32 @kfs_link(i32 noundef %103, i32 noundef %105) #13
  br label %546

107:                                              ; preds = %10
  %108 = load i32, ptr @fsready, align 4, !tbaa !9
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %546, label %110

110:                                              ; preds = %107
  %111 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %112 = load volatile i32, ptr %111, align 4, !tbaa !36
  %113 = tail call i32 @kfs_unlink(i32 noundef %112) #13
  br label %546

114:                                              ; preds = %10
  %115 = load i32, ptr @fsready, align 4, !tbaa !9
  %116 = icmp eq i32 %115, 0
  br i1 %116, label %546, label %117

117:                                              ; preds = %114
  %118 = tail call i32 @kflash_sync() #13
  br label %546

119:                                              ; preds = %10
  %120 = load i32, ptr @fsready, align 4, !tbaa !9
  %121 = icmp eq i32 %120, 0
  br i1 %121, label %130, label %122

122:                                              ; preds = %119
  %123 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %124 = load volatile i32, ptr %123, align 4, !tbaa !36
  %125 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %126 = load volatile i32, ptr %125, align 4, !tbaa !40
  %127 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %128 = load volatile i32, ptr %127, align 4, !tbaa !41
  %129 = tail call i32 @kfs_read(i32 noundef %124, i32 noundef %126, i32 noundef %128) #13
  br label %136

130:                                              ; preds = %119
  %131 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %132 = load volatile i32, ptr %131, align 4, !tbaa !40
  %133 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %134 = load volatile i32, ptr %133, align 4, !tbaa !41
  %135 = tail call i32 @kconsread(i32 noundef %132, i32 noundef %134) #12
  br label %136

136:                                              ; preds = %130, %122
  %137 = phi i32 [ %129, %122 ], [ %135, %130 ]
  %138 = icmp eq i32 %137, -3
  br i1 %138, label %563, label %546

139:                                              ; preds = %10
  %140 = load i32, ptr @ticks, align 4, !tbaa !9
  %141 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %142 = load volatile i32, ptr %141, align 4, !tbaa !36
  %143 = add i32 %142, %140
  %144 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %143, ptr %144, align 4, !tbaa !30
  %145 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %146 = load i32, ptr %145, align 4, !tbaa !23
  %147 = inttoptr i32 %146 to ptr
  %148 = load volatile i32, ptr %147, align 4, !tbaa !9
  %149 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %148, ptr %149, align 4, !tbaa !24
  %150 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %150, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %567

151:                                              ; preds = %17, %170
  %152 = phi i32 [ %173, %170 ], [ 0, %17 ]
  %153 = phi i32 [ %171, %170 ], [ -1, %17 ]
  %154 = phi i32 [ %172, %170 ], [ 0, %17 ]
  %155 = icmp eq i32 %152, 8
  br i1 %155, label %156, label %158

156:                                              ; preds = %151
  %157 = icmp sgt i32 %153, -1
  br i1 %157, label %174, label %187

158:                                              ; preds = %151
  %159 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %152
  %160 = load i32, ptr %159, align 4, !tbaa !14
  %161 = icmp eq i32 %160, 0
  br i1 %161, label %170, label %162

162:                                              ; preds = %158
  %163 = getelementptr inbounds nuw i8, ptr %159, i32 8
  %164 = load i32, ptr %163, align 4, !tbaa !33
  %165 = load i32, ptr %18, align 4, !tbaa !34
  %166 = icmp eq i32 %164, %165
  br i1 %166, label %167, label %170

167:                                              ; preds = %162
  %168 = icmp eq i32 %160, 5
  %169 = select i1 %168, i32 %152, i32 %153
  br label %170

170:                                              ; preds = %167, %158, %162
  %171 = phi i32 [ %153, %162 ], [ %153, %158 ], [ %169, %167 ]
  %172 = phi i32 [ %154, %162 ], [ %154, %158 ], [ 1, %167 ]
  %173 = add nuw nsw i32 %152, 1
  br label %151, !llvm.loop !42

174:                                              ; preds = %156
  %175 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %176 = load volatile i32, ptr %175, align 4, !tbaa !36
  %177 = icmp eq i32 %176, 0
  br i1 %177, label %183, label %178

178:                                              ; preds = %174
  %179 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %153, i32 5
  %180 = load i32, ptr %179, align 4, !tbaa !32
  %181 = load volatile i32, ptr %175, align 4, !tbaa !36
  %182 = inttoptr i32 %181 to ptr
  store volatile i32 %180, ptr %182, align 4, !tbaa !9
  br label %183

183:                                              ; preds = %178, %174
  %184 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %153
  %185 = getelementptr inbounds nuw i8, ptr %184, i32 4
  %186 = load i32, ptr %185, align 4, !tbaa !34
  store i32 0, ptr %184, align 4, !tbaa !14
  br label %546

187:                                              ; preds = %156
  %188 = icmp eq i32 %154, 0
  br i1 %188, label %546, label %189

189:                                              ; preds = %187
  %190 = ptrtoint ptr %5 to i32
  %191 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %192 = load i32, ptr %191, align 4, !tbaa !23
  %193 = inttoptr i32 %192 to ptr
  %194 = load volatile i32, ptr %193, align 4, !tbaa !9
  %195 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %194, ptr %195, align 4, !tbaa !24
  %196 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %190, ptr %196, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  %197 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %198 = load volatile i32, ptr %197, align 4, !tbaa !19
  br label %567

199:                                              ; preds = %10, %206
  %200 = phi i32 [ %207, %206 ], [ 0, %10 ]
  %201 = icmp eq i32 %200, 8
  br i1 %201, label %546, label %202

202:                                              ; preds = %199
  %203 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %200
  %204 = load i32, ptr %203, align 4, !tbaa !14
  %205 = icmp eq i32 %204, 0
  br i1 %205, label %208, label %206

206:                                              ; preds = %202
  %207 = add nuw nsw i32 %200, 1
  br label %199, !llvm.loop !43

208:                                              ; preds = %202
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(52) %203, ptr noundef nonnull align 4 dereferenceable(52) %5, i32 52, i1 false), !tbaa.struct !44
  %209 = load i32, ptr @fsready, align 4, !tbaa !9
  %210 = icmp eq i32 %209, 0
  br i1 %210, label %212, label %211

211:                                              ; preds = %208
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %200) #13
  br label %212

212:                                              ; preds = %211, %208
  %213 = load i32, ptr @nextpid, align 4, !tbaa !9
  %214 = add i32 %213, 1
  store i32 %214, ptr @nextpid, align 4, !tbaa !9
  %215 = getelementptr inbounds nuw i8, ptr %203, i32 4
  store i32 %213, ptr %215, align 4, !tbaa !34
  %216 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %217 = load i32, ptr %216, align 4, !tbaa !34
  %218 = getelementptr inbounds nuw i8, ptr %203, i32 8
  store i32 %217, ptr %218, align 4, !tbaa !33
  %219 = getelementptr inbounds nuw i8, ptr %203, i32 12
  store i32 0, ptr %219, align 4, !tbaa !16
  store i32 3, ptr %203, align 4, !tbaa !14
  %220 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %221 = load i32, ptr %220, align 4, !tbaa !23
  %222 = inttoptr i32 %221 to ptr
  %223 = load volatile i32, ptr %222, align 4, !tbaa !9
  %224 = getelementptr inbounds nuw i8, ptr %203, i32 40
  store i32 %223, ptr %224, align 4, !tbaa !24
  %225 = load volatile i32, ptr %222, align 4, !tbaa !9
  %226 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %225, ptr %226, align 4, !tbaa !24
  %227 = ptrtoint ptr %203 to i32
  %228 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %227, ptr %228, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %567

229:                                              ; preds = %10
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #14
  %230 = load i32, ptr @fsready, align 4, !tbaa !9
  %231 = icmp eq i32 %230, 0
  br i1 %231, label %327, label %232

232:                                              ; preds = %229
  %233 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %234 = load volatile i32, ptr %233, align 4, !tbaa !36
  %235 = inttoptr i32 %234 to ptr
  %236 = tail call i32 @kfs_iopen(ptr noundef %235) #13
  %237 = icmp eq i32 %236, 0
  br i1 %237, label %327, label %238

238:                                              ; preds = %232
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #14
  %239 = ptrtoint ptr %2 to i32
  %240 = call i32 @kfs_iread(i32 noundef %236, i32 noundef 0, i32 noundef %239, i32 noundef 52) #13
  %241 = icmp eq i32 %240, 52
  %242 = load i32, ptr %2, align 4
  %243 = icmp eq i32 %242, 1480674628
  %244 = select i1 %241, i1 %243, i1 false
  br i1 %244, label %245, label %325

245:                                              ; preds = %238
  %246 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %247 = load i32, ptr %246, align 4, !tbaa !9
  %248 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %249 = load i32, ptr %248, align 4, !tbaa !9
  %250 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %251 = load i32, ptr %250, align 4, !tbaa !9
  %252 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %253 = load i32, ptr %252, align 4, !tbaa !9
  %254 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %255 = load i32, ptr %254, align 4, !tbaa !9
  %256 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %257 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %258 = load i32, ptr %257, align 4, !tbaa !9
  %259 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %258, ptr %259, align 4, !tbaa !45
  %260 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %261 = load i32, ptr %260, align 4, !tbaa !9
  %262 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %261, ptr %262, align 4, !tbaa !47
  %263 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %264 = load i32, ptr %263, align 4, !tbaa !9
  %265 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %264, ptr %265, align 4, !tbaa !48
  %266 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %267 = load i32, ptr %266, align 4, !tbaa !9
  %268 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %267, ptr %268, align 4, !tbaa !49
  %269 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %270 = load i32, ptr %269, align 4, !tbaa !9
  %271 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %270, ptr %271, align 4, !tbaa !50
  %272 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %273 = load i32, ptr %272, align 4, !tbaa !9
  %274 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %273, ptr %274, align 4, !tbaa !51
  %275 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %276 = load i32, ptr %275, align 4, !tbaa !9
  %277 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %276, ptr %277, align 4, !tbaa !52
  %278 = call fastcc i32 @kalloc(i32 noundef %247) #12
  %279 = call fastcc i32 @kalloc(i32 noundef %249) #12
  %280 = add i32 %247, 52
  %281 = add i32 %249, %280
  %282 = icmp ne i32 %278, 0
  %283 = icmp ne i32 %279, 0
  %284 = select i1 %282, i1 %283, i1 false
  br i1 %284, label %285, label %291

285:                                              ; preds = %245
  %286 = call i32 @kfs_iread(i32 noundef %236, i32 noundef 52, i32 noundef %278, i32 noundef %247) #13
  %287 = icmp eq i32 %286, %247
  br i1 %287, label %288, label %291

288:                                              ; preds = %285
  %289 = call i32 @kfs_iread(i32 noundef %236, i32 noundef %280, i32 noundef %279, i32 noundef %249) #13
  %290 = icmp eq i32 %289, %249
  br i1 %290, label %292, label %291

291:                                              ; preds = %288, %285, %245
  call fastcc void @kfree(i32 noundef %278) #12
  call fastcc void @kfree(i32 noundef %279) #12
  br label %325

292:                                              ; preds = %288
  %293 = sub i32 %278, %251
  %294 = sub i32 %279, %253
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #14
  %295 = ptrtoint ptr %3 to i32
  br label %296

296:                                              ; preds = %322, %292
  %297 = phi i32 [ %255, %292 ], [ %323, %322 ]
  %298 = phi i32 [ %281, %292 ], [ %324, %322 ]
  %299 = icmp eq i32 %297, 0
  br i1 %299, label %326, label %300

300:                                              ; preds = %296
  %301 = call i32 @llvm.umin.i32(i32 %297, i32 64)
  %302 = shl nuw nsw i32 %301, 2
  %303 = call i32 @kfs_iread(i32 noundef %236, i32 noundef %298, i32 noundef %295, i32 noundef %302) #13
  %304 = icmp eq i32 %303, %302
  br i1 %304, label %305, label %326

305:                                              ; preds = %300, %308
  %306 = phi i32 [ %321, %308 ], [ 0, %300 ]
  %307 = icmp eq i32 %306, %301
  br i1 %307, label %322, label %308

308:                                              ; preds = %305
  %309 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %306
  %310 = load i32, ptr %309, align 4, !tbaa !9
  %311 = icmp slt i32 %310, 0
  %312 = select i1 %311, i32 %279, i32 %278
  %313 = and i32 %310, 1073741823
  %314 = add i32 %312, %313
  %315 = and i32 %310, 1073741824
  %316 = icmp eq i32 %315, 0
  %317 = select i1 %316, i32 %293, i32 %294
  %318 = inttoptr i32 %314 to ptr
  %319 = load volatile i32, ptr %318, align 4, !tbaa !9
  %320 = add i32 %317, %319
  store volatile i32 %320, ptr %318, align 4, !tbaa !9
  %321 = add nuw nsw i32 %306, 1
  br label %305, !llvm.loop !53

322:                                              ; preds = %305
  %323 = sub i32 %297, %301
  %324 = add i32 %302, %298
  br label %296

325:                                              ; preds = %238, %291
  call void @kfs_iclose(i32 noundef %236) #13
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %479

326:                                              ; preds = %300, %296
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #14
  call void @kfs_iclose(i32 noundef %236) #13
  store i32 0, ptr %256, align 4, !tbaa !54
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %404

327:                                              ; preds = %229, %232
  %328 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %329 = load volatile i32, ptr %328, align 4, !tbaa !36
  %330 = inttoptr i32 %329 to ptr
  br label %331

331:                                              ; preds = %350, %327
  %332 = phi i32 [ 0, %327 ], [ %351, %350 ]
  %333 = icmp eq i32 %332, 4
  br i1 %333, label %479, label %334

334:                                              ; preds = %331
  %335 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %332
  %336 = load i8, ptr %335, align 4, !tbaa !3
  %337 = icmp eq i8 %336, 0
  br i1 %337, label %479, label %338

338:                                              ; preds = %334, %347
  %339 = phi i32 [ %349, %347 ], [ 0, %334 ]
  %340 = icmp eq i32 %339, 12
  br i1 %340, label %352, label %341

341:                                              ; preds = %338
  %342 = getelementptr inbounds nuw [12 x i8], ptr %335, i32 0, i32 %339
  %343 = load i8, ptr %342, align 1, !tbaa !3
  %344 = getelementptr inbounds nuw i8, ptr %330, i32 %339
  %345 = load i8, ptr %344, align 1, !tbaa !3
  %346 = icmp eq i8 %343, %345
  br i1 %346, label %347, label %350

347:                                              ; preds = %341
  %348 = icmp eq i8 %343, 0
  %349 = add nuw nsw i32 %339, 1
  br i1 %348, label %352, label %338, !llvm.loop !55

350:                                              ; preds = %341
  %351 = add nuw nsw i32 %332, 1
  br label %331, !llvm.loop !56

352:                                              ; preds = %347, %338
  %353 = getelementptr inbounds nuw i8, ptr %335, i32 16
  %354 = load i32, ptr %353, align 4, !tbaa !57
  %355 = tail call fastcc i32 @kalloc(i32 noundef %354) #12
  %356 = getelementptr inbounds nuw i8, ptr %335, i32 24
  %357 = load i32, ptr %356, align 4, !tbaa !58
  %358 = tail call fastcc i32 @kalloc(i32 noundef %357) #12
  %359 = icmp ne i32 %355, 0
  %360 = icmp ne i32 %358, 0
  %361 = select i1 %359, i1 %360, i1 false
  br i1 %361, label %362, label %479

362:                                              ; preds = %352
  %363 = getelementptr inbounds nuw i8, ptr %335, i32 12
  %364 = load i32, ptr %363, align 4, !tbaa !59
  %365 = inttoptr i32 %364 to ptr
  %366 = inttoptr i32 %355 to ptr
  br label %367

367:                                              ; preds = %378, %362
  %368 = phi ptr [ %365, %362 ], [ %379, %378 ]
  %369 = phi ptr [ %366, %362 ], [ %381, %378 ]
  %370 = phi i32 [ 0, %362 ], [ %382, %378 ]
  %371 = load i32, ptr %353, align 4, !tbaa !57
  %372 = icmp ult i32 %370, %371
  br i1 %372, label %378, label %373

373:                                              ; preds = %367
  %374 = getelementptr inbounds nuw i8, ptr %335, i32 20
  %375 = load i32, ptr %374, align 4, !tbaa !60
  %376 = inttoptr i32 %375 to ptr
  %377 = inttoptr i32 %358 to ptr
  br label %383

378:                                              ; preds = %367
  %379 = getelementptr inbounds nuw i8, ptr %368, i32 4
  %380 = load i32, ptr %368, align 4, !tbaa !9
  %381 = getelementptr inbounds nuw i8, ptr %369, i32 4
  store i32 %380, ptr %369, align 4, !tbaa !9
  %382 = add i32 %370, 4
  br label %367, !llvm.loop !61

383:                                              ; preds = %389, %373
  %384 = phi ptr [ %376, %373 ], [ %390, %389 ]
  %385 = phi ptr [ %377, %373 ], [ %392, %389 ]
  %386 = phi i32 [ 0, %373 ], [ %393, %389 ]
  %387 = load i32, ptr %356, align 4, !tbaa !58
  %388 = icmp ult i32 %386, %387
  br i1 %388, label %389, label %394

389:                                              ; preds = %383
  %390 = getelementptr inbounds nuw i8, ptr %384, i32 4
  %391 = load i32, ptr %384, align 4, !tbaa !9
  %392 = getelementptr inbounds nuw i8, ptr %385, i32 4
  store i32 %391, ptr %385, align 4, !tbaa !9
  %393 = add i32 %386, 4
  br label %383, !llvm.loop !62

394:                                              ; preds = %383
  %395 = getelementptr inbounds nuw i8, ptr %335, i32 28
  %396 = load i32, ptr %395, align 4, !tbaa !63
  %397 = getelementptr inbounds nuw i8, ptr %335, i32 32
  %398 = load i32, ptr %397, align 4, !tbaa !64
  %399 = getelementptr inbounds nuw i8, ptr %335, i32 36
  %400 = load i32, ptr %399, align 4, !tbaa !65
  %401 = sub i32 %355, %396
  %402 = sub i32 %358, %398
  %403 = inttoptr i32 %400 to ptr
  br label %404

404:                                              ; preds = %394, %326
  %405 = phi i32 [ %402, %394 ], [ %294, %326 ]
  %406 = phi i32 [ %401, %394 ], [ %293, %326 ]
  %407 = phi ptr [ %403, %394 ], [ null, %326 ]
  %408 = phi i32 [ %358, %394 ], [ %279, %326 ]
  %409 = phi i32 [ %355, %394 ], [ %278, %326 ]
  %410 = phi ptr [ %335, %394 ], [ %1, %326 ]
  %411 = getelementptr inbounds nuw i8, ptr %410, i32 40
  br label %412

412:                                              ; preds = %424, %404
  %413 = phi i32 [ 0, %404 ], [ %437, %424 ]
  %414 = load i32, ptr %411, align 4, !tbaa !54
  %415 = icmp ult i32 %413, %414
  br i1 %415, label %424, label %416

416:                                              ; preds = %412
  %417 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %417) #12
  %418 = load i32, ptr @curr, align 4, !tbaa !9
  %419 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %418
  store i32 %409, ptr %419, align 4, !tbaa !9
  %420 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %418, i32 1
  store i32 %408, ptr %420, align 4, !tbaa !9
  %421 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %422 = load volatile i32, ptr %421, align 4, !tbaa !40
  %423 = icmp eq i32 %422, 0
  br i1 %423, label %480, label %438

424:                                              ; preds = %412
  %425 = getelementptr inbounds nuw i32, ptr %407, i32 %413
  %426 = load i32, ptr %425, align 4, !tbaa !9
  %427 = icmp slt i32 %426, 0
  %428 = select i1 %427, i32 %408, i32 %409
  %429 = and i32 %426, 1073741823
  %430 = add i32 %428, %429
  %431 = and i32 %426, 1073741824
  %432 = icmp eq i32 %431, 0
  %433 = select i1 %432, i32 %406, i32 %405
  %434 = inttoptr i32 %430 to ptr
  %435 = load volatile i32, ptr %434, align 4, !tbaa !9
  %436 = add i32 %433, %435
  store volatile i32 %436, ptr %434, align 4, !tbaa !9
  %437 = add nuw i32 %413, 1
  br label %412, !llvm.loop !66

438:                                              ; preds = %416
  %439 = call fastcc i32 @kalloc(i32 noundef 256) #12
  %440 = icmp eq i32 %439, 0
  br i1 %440, label %480, label %441

441:                                              ; preds = %438
  %442 = load volatile i32, ptr %421, align 4, !tbaa !40
  %443 = inttoptr i32 %442 to ptr
  %444 = inttoptr i32 %439 to ptr
  %445 = add i32 %439, 64
  %446 = inttoptr i32 %445 to ptr
  %447 = add i32 %439, 256
  %448 = inttoptr i32 %447 to ptr
  %449 = getelementptr inbounds i8, ptr %448, i32 -1
  br label %450

450:                                              ; preds = %472, %441
  %451 = phi i32 [ 0, %441 ], [ %474, %472 ]
  %452 = phi ptr [ %446, %441 ], [ %473, %472 ]
  %453 = icmp eq i32 %451, 15
  br i1 %453, label %475, label %454

454:                                              ; preds = %450
  %455 = getelementptr inbounds nuw i32, ptr %443, i32 %451
  %456 = load i32, ptr %455, align 4, !tbaa !9
  %457 = icmp eq i32 %456, 0
  br i1 %457, label %475, label %458

458:                                              ; preds = %454
  %459 = inttoptr i32 %456 to ptr
  %460 = ptrtoint ptr %452 to i32
  %461 = getelementptr inbounds nuw i32, ptr %444, i32 %451
  store i32 %460, ptr %461, align 4, !tbaa !9
  br label %462

462:                                              ; preds = %469, %458
  %463 = phi ptr [ %452, %458 ], [ %471, %469 ]
  %464 = phi ptr [ %459, %458 ], [ %470, %469 ]
  %465 = load i8, ptr %464, align 1, !tbaa !3
  %466 = icmp ne i8 %465, 0
  %467 = icmp ult ptr %463, %449
  %468 = select i1 %466, i1 %467, i1 false
  br i1 %468, label %469, label %472

469:                                              ; preds = %462
  %470 = getelementptr inbounds nuw i8, ptr %464, i32 1
  %471 = getelementptr inbounds nuw i8, ptr %463, i32 1
  store i8 %465, ptr %463, align 1, !tbaa !3
  br label %462, !llvm.loop !67

472:                                              ; preds = %462
  %473 = getelementptr inbounds nuw i8, ptr %463, i32 1
  store i8 0, ptr %463, align 1, !tbaa !3
  %474 = add nuw nsw i32 %451, 1
  br label %450, !llvm.loop !68

475:                                              ; preds = %450, %454
  %476 = getelementptr inbounds nuw i32, ptr %444, i32 %451
  store i32 0, ptr %476, align 4, !tbaa !9
  %477 = load i32, ptr @curr, align 4, !tbaa !9
  %478 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %477, i32 2
  store i32 %439, ptr %478, align 4, !tbaa !9
  br label %480

479:                                              ; preds = %331, %334, %352, %325
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %546

480:                                              ; preds = %416, %475, %438
  %481 = phi i32 [ 0, %416 ], [ %451, %475 ], [ 0, %438 ]
  %482 = phi i32 [ 0, %416 ], [ %439, %475 ], [ 0, %438 ]
  %483 = getelementptr inbounds nuw i8, ptr %410, i32 52
  %484 = load i32, ptr %483, align 4, !tbaa !48
  %485 = add i32 %484, %408
  %486 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %485, ptr %486, align 4, !tbaa !22
  %487 = getelementptr inbounds nuw i8, ptr %410, i32 56
  %488 = load i32, ptr %487, align 4, !tbaa !49
  %489 = add i32 %488, %408
  %490 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %489, ptr %490, align 4, !tbaa !69
  %491 = getelementptr inbounds nuw i8, ptr %410, i32 60
  %492 = load i32, ptr %491, align 4, !tbaa !50
  %493 = add i32 %492, %408
  %494 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %493, ptr %494, align 4, !tbaa !23
  %495 = getelementptr inbounds nuw i8, ptr %410, i32 48
  %496 = load i32, ptr %495, align 4, !tbaa !47
  %497 = add i32 %496, %409
  %498 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %497, ptr %498, align 4, !tbaa !29
  %499 = getelementptr inbounds nuw i8, ptr %410, i32 64
  %500 = load i32, ptr %499, align 4, !tbaa !51
  %501 = add i32 %500, %408
  store i32 %501, ptr %11, align 4, !tbaa !18
  %502 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %503 = getelementptr inbounds nuw i8, ptr %410, i32 68
  %504 = load i32, ptr %503, align 4, !tbaa !52
  %505 = add i32 %504, %408
  %506 = inttoptr i32 %505 to ptr
  store volatile i32 %502, ptr %506, align 4, !tbaa !9
  %507 = load i32, ptr %498, align 4, !tbaa !29
  %508 = load i32, ptr %486, align 4, !tbaa !22
  %509 = inttoptr i32 %508 to ptr
  store volatile i32 %507, ptr %509, align 4, !tbaa !9
  %510 = load i32, ptr %483, align 4, !tbaa !48
  %511 = add i32 %510, %408
  %512 = add i32 %511, -84
  %513 = inttoptr i32 %512 to ptr
  store volatile i32 %481, ptr %513, align 4, !tbaa !9
  %514 = add i32 %511, -80
  %515 = inttoptr i32 %514 to ptr
  store volatile i32 %482, ptr %515, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  store i32 4, ptr %5, align 4, !tbaa !14
  %516 = load i32, ptr @curr, align 4, !tbaa !9
  %517 = getelementptr inbounds nuw i8, ptr %410, i32 44
  %518 = load i32, ptr %517, align 4, !tbaa !45
  %519 = add i32 %518, %409
  call fastcc void @kexit(i32 noundef %516, i32 noundef %519) #12
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %578

520:                                              ; preds = %10
  %521 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %522 = load volatile i32, ptr %521, align 4, !tbaa !36
  br label %561

523:                                              ; preds = %15, %535
  %524 = phi i32 [ %536, %535 ], [ 0, %15 ]
  %525 = icmp eq i32 %524, 8
  br i1 %525, label %546, label %526

526:                                              ; preds = %523
  %527 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %524
  %528 = load i32, ptr %527, align 4, !tbaa !14
  %529 = icmp eq i32 %528, 0
  br i1 %529, label %535, label %530

530:                                              ; preds = %526
  %531 = getelementptr inbounds nuw i8, ptr %527, i32 4
  %532 = load i32, ptr %531, align 4, !tbaa !34
  %533 = load volatile i32, ptr %16, align 4, !tbaa !36
  %534 = icmp eq i32 %532, %533
  br i1 %534, label %537, label %535

535:                                              ; preds = %526, %530
  %536 = add nuw nsw i32 %524, 1
  br label %523, !llvm.loop !70

537:                                              ; preds = %530
  %538 = icmp eq i32 %528, 5
  br i1 %538, label %546, label %539

539:                                              ; preds = %537
  %540 = icmp eq i32 %524, %4
  br i1 %540, label %561, label %541

541:                                              ; preds = %539
  %542 = icmp eq i32 %528, 2
  br i1 %542, label %543, label %544

543:                                              ; preds = %541
  tail call fastcc void @terminate(ptr noundef nonnull %527, i32 noundef -1) #12
  br label %546

544:                                              ; preds = %541
  %545 = getelementptr inbounds nuw i8, ptr %527, i32 48
  store i32 1, ptr %545, align 4, !tbaa !25
  br label %546

546:                                              ; preds = %523, %199, %10, %19, %22, %42, %136, %45, %48, %54, %57, %61, %64, %68, %71, %77, %80, %84, %87, %91, %94, %98, %101, %107, %110, %114, %117, %183, %187, %537, %544, %543, %479
  %547 = phi i32 [ -1, %479 ], [ 0, %543 ], [ 0, %544 ], [ -1, %537 ], [ -1, %187 ], [ %186, %183 ], [ -1, %114 ], [ %118, %117 ], [ -1, %107 ], [ %113, %110 ], [ -1, %98 ], [ %106, %101 ], [ -1, %91 ], [ %97, %94 ], [ -1, %84 ], [ %90, %87 ], [ -1, %77 ], [ %83, %80 ], [ -1, %68 ], [ %76, %71 ], [ -1, %61 ], [ %67, %64 ], [ -1, %54 ], [ %60, %57 ], [ -1, %45 ], [ %53, %48 ], [ %137, %136 ], [ %43, %42 ], [ %23, %22 ], [ %21, %19 ], [ -1, %10 ], [ -1, %199 ], [ -1, %523 ]
  %548 = load i32, ptr %11, align 4, !tbaa !18
  %549 = inttoptr i32 %548 to ptr
  %550 = getelementptr inbounds nuw i8, ptr %549, i32 16
  store volatile i32 %547, ptr %550, align 4, !tbaa !19
  %551 = getelementptr inbounds nuw i8, ptr %549, i32 20
  store volatile i32 1, ptr %551, align 4, !tbaa !21
  %552 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %553 = load i32, ptr %552, align 4, !tbaa !22
  %554 = add i32 %553, -84
  %555 = inttoptr i32 %554 to ptr
  store volatile i32 %547, ptr %555, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %556 = load i32, ptr @curr, align 4, !tbaa !9
  %557 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %558 = load i32, ptr %557, align 4, !tbaa !23
  %559 = inttoptr i32 %558 to ptr
  %560 = load volatile i32, ptr %559, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %556, i32 noundef %560) #12
  br label %578

561:                                              ; preds = %539, %520
  %562 = phi i32 [ %522, %520 ], [ -1, %539 ]
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef %562) #12
  br label %563

563:                                              ; preds = %561, %136, %42
  %564 = phi i32 [ -3, %42 ], [ -3, %136 ], [ -1, %561 ]
  %565 = load i32, ptr %5, align 4, !tbaa !14
  %566 = icmp eq i32 %565, 2
  br i1 %566, label %567, label %577

567:                                              ; preds = %212, %189, %139, %563
  %568 = phi i32 [ %564, %563 ], [ 0, %212 ], [ %198, %189 ], [ 0, %139 ]
  %569 = load i32, ptr %11, align 4, !tbaa !18
  %570 = inttoptr i32 %569 to ptr
  %571 = getelementptr inbounds nuw i8, ptr %570, i32 16
  store volatile i32 %568, ptr %571, align 4, !tbaa !19
  %572 = getelementptr inbounds nuw i8, ptr %570, i32 20
  store volatile i32 1, ptr %572, align 4, !tbaa !21
  %573 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %574 = load i32, ptr %573, align 4, !tbaa !22
  %575 = add i32 %574, -84
  %576 = inttoptr i32 %575 to ptr
  store volatile i32 %568, ptr %576, align 4, !tbaa !9
  br label %577

577:                                              ; preds = %567, %563
  tail call fastcc void @swtch() #12
  br label %578

578:                                              ; preds = %480, %546, %577, %9
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
  store ptr %5, ptr @kfreelist, align 4, !tbaa !71
  %6 = load i32, ptr @arena_end, align 4, !tbaa !9
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !73
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr null, ptr %8, align 4, !tbaa !75
  br label %9

9:                                                ; preds = %3, %1
  %10 = add i32 %0, 255
  %11 = and i32 %10, -256
  %12 = add i32 %11, 256
  br label %13

13:                                               ; preds = %38, %9
  %14 = phi ptr [ @kfreelist, %9 ], [ %39, %38 ]
  %15 = load ptr, ptr %14, align 4, !tbaa !71
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !73
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
  store i32 %21, ptr %26, align 4, !tbaa !73
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !75
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !75
  store i32 %12, ptr %15, align 4, !tbaa !73
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !75
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !71
  %37 = add i32 %35, 256
  br label %40

38:                                               ; preds = %17
  %39 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %13, !llvm.loop !76

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
  %8 = load ptr, ptr %7, align 4, !tbaa !71
  %9 = icmp ne ptr %8, null
  %10 = ptrtoint ptr %8 to i32
  %11 = icmp ugt i32 %4, %10
  %12 = and i1 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 4
  br i1 %12, label %5, label %14, !llvm.loop !77

14:                                               ; preds = %5
  %15 = inttoptr i32 %4 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  store ptr %8, ptr %16, align 4, !tbaa !75
  %17 = icmp eq ptr %6, null
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %15, ptr %19, align 4, !tbaa !75
  br label %21

20:                                               ; preds = %14
  store ptr %15, ptr @kfreelist, align 4, !tbaa !71
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !73
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !73
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !73
  %29 = load ptr, ptr %13, align 4, !tbaa !75
  store ptr %29, ptr %16, align 4, !tbaa !75
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !73
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !73
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !73
  %39 = load ptr, ptr %16, align 4, !tbaa !75
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !75
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
  br label %2, !llvm.loop !78
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
  %17 = load i32, ptr %3, align 4, !tbaa !34
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
  br label %4, !llvm.loop !79
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
  %15 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !26
  store i32 %14, ptr %15, align 4, !tbaa !9
  %16 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %17 = load i32, ptr %16, align 4, !tbaa !29
  %18 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !26
  store i32 %17, ptr %18, align 4, !tbaa !9
  %19 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %20 = load i32, ptr %19, align 4, !tbaa !69
  %21 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !26
  store i32 %20, ptr %21, align 4, !tbaa !9
  %22 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !26
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

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #8

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
!15 = !{!"proc", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48}
!16 = !{!15, !10, i64 12}
!17 = distinct !{!17, !7, !8}
!18 = !{!15, !10, i64 44}
!19 = !{!20, !10, i64 16}
!20 = !{!"dma_sysmail", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20}
!21 = !{!20, !10, i64 20}
!22 = !{!15, !10, i64 24}
!23 = !{!15, !10, i64 32}
!24 = !{!15, !10, i64 40}
!25 = !{!15, !10, i64 48}
!26 = !{!27, !27, i64 0}
!27 = !{!"p1 int", !28, i64 0}
!28 = !{!"any pointer", !4, i64 0}
!29 = !{!15, !10, i64 36}
!30 = !{!15, !10, i64 16}
!31 = distinct !{!31, !7, !8}
!32 = !{!15, !10, i64 20}
!33 = !{!15, !10, i64 8}
!34 = !{!15, !10, i64 4}
!35 = distinct !{!35, !7, !8}
!36 = !{!20, !10, i64 4}
!37 = distinct !{!37, !7, !8}
!38 = distinct !{!38, !7, !8}
!39 = !{!20, !10, i64 0}
!40 = !{!20, !10, i64 8}
!41 = !{!20, !10, i64 12}
!42 = distinct !{!42, !7, !8}
!43 = distinct !{!43, !7, !8}
!44 = !{i64 0, i64 4, !9, i64 4, i64 4, !9, i64 8, i64 4, !9, i64 12, i64 4, !9, i64 16, i64 4, !9, i64 20, i64 4, !9, i64 24, i64 4, !9, i64 28, i64 4, !9, i64 32, i64 4, !9, i64 36, i64 4, !9, i64 40, i64 4, !9, i64 44, i64 4, !9, i64 48, i64 4, !9}
!45 = !{!46, !10, i64 44}
!46 = !{!"kimg", !4, i64 0, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48, !10, i64 52, !10, i64 56, !10, i64 60, !10, i64 64, !10, i64 68}
!47 = !{!46, !10, i64 48}
!48 = !{!46, !10, i64 52}
!49 = !{!46, !10, i64 56}
!50 = !{!46, !10, i64 60}
!51 = !{!46, !10, i64 64}
!52 = !{!46, !10, i64 68}
!53 = distinct !{!53, !7, !8}
!54 = !{!46, !10, i64 40}
!55 = distinct !{!55, !7, !8}
!56 = distinct !{!56, !7, !8}
!57 = !{!46, !10, i64 16}
!58 = !{!46, !10, i64 24}
!59 = !{!46, !10, i64 12}
!60 = !{!46, !10, i64 20}
!61 = distinct !{!61, !7, !8}
!62 = distinct !{!62, !7, !8}
!63 = !{!46, !10, i64 28}
!64 = !{!46, !10, i64 32}
!65 = !{!46, !10, i64 36}
!66 = distinct !{!66, !7, !8}
!67 = distinct !{!67, !7, !8}
!68 = distinct !{!68, !7, !8}
!69 = !{!15, !10, i64 28}
!70 = distinct !{!70, !7, !8}
!71 = !{!72, !72, i64 0}
!72 = !{!"p1 _ZTS4khdr", !28, i64 0}
!73 = !{!74, !10, i64 0}
!74 = !{!"khdr", !10, i64 0, !72, i64 4}
!75 = !{!74, !72, i64 4}
!76 = distinct !{!76, !7, !8}
!77 = distinct !{!77, !7, !8}
!78 = distinct !{!78, !7, !8}
!79 = distinct !{!79, !7, !8}
