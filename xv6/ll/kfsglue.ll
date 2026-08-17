; ModuleID = 'kfsglue.c'
source_filename = "kfsglue.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, ptr, [16 x ptr] }
%struct.devsw = type { ptr, ptr }
%struct.dirent = type { i16, [62 x i8] }

@.str = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@fsproc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = external dso_local local_unnamed_addr global i32, align 4
@devsw = external dso_local local_unnamed_addr global [0 x %struct.devsw], align 4
@.str.2 = private unnamed_addr constant [9 x i8] c"/console\00", align 1
@.str.3 = private unnamed_addr constant [22 x i8] c"kfs_start: no console\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@fsready = dso_local local_unnamed_addr global i32 0, align 4
@fatmnt = internal unnamed_addr global [28 x i8] zeroinitializer, align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"fat0 on \00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c" type vfat (ro)\0A\00", align 1
@fatvol = dso_local local_unnamed_addr global i32 0, align 4
@fatmnt_dev = internal unnamed_addr global i32 -1, align 4
@fatmnt_inum = internal unnamed_addr global i32 0, align 4
@.str.7 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c"..\00", align 1
@.str.9 = private unnamed_addr constant [18 x i8] c"unlink: nlink < 1\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"unlink: writei\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"create dots\00", align 1
@.str.12 = private unnamed_addr constant [16 x i8] c"create: dirlink\00", align 1
@.str.13 = private unnamed_addr constant [18 x i8] c"isdirempty: readi\00", align 1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @initlock(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #0 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @acquire(ptr noundef readnone captures(none) %0) local_unnamed_addr #0 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @release(ptr noundef readnone captures(none) %0) local_unnamed_addr #0 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @initsleeplock(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #0 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @acquiresleep(ptr noundef readnone captures(none) %0) local_unnamed_addr #0 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @releasesleep(ptr noundef readnone captures(none) %0) local_unnamed_addr #0 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local noundef i32 @holdingsleep(ptr noundef readnone captures(none) %0) local_unnamed_addr #0 {
  ret i32 1
}

; Function Attrs: minsize nounwind optsize
define dso_local void @printk(ptr noundef %0, ...) local_unnamed_addr #1 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  %7 = add nuw nsw i32 %3, 1
  br i1 %6, label %8, label %2, !llvm.loop !6

8:                                                ; preds = %2
  tail call void @kconswrite(ptr noundef nonnull %0, i32 noundef %3) #7
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @kconswrite(ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @panic(ptr noundef %0) local_unnamed_addr #4 {
  tail call void @kconswrite(ptr noundef nonnull @.str, i32 noundef 7) #7
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  %7 = add nuw nsw i32 %3, 1
  br i1 %6, label %8, label %2, !llvm.loop !9

8:                                                ; preds = %2
  tail call void @kconswrite(ptr noundef nonnull %0, i32 noundef %3) #7
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 1) #7
  br label %9

9:                                                ; preds = %9, %8
  br label %9, !llvm.loop !10
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @either_copyout(i32 noundef %0, i32 noundef %1, ptr noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %1 to ptr
  %6 = tail call ptr @memmove(ptr noundef %5, ptr noundef %2, i32 noundef %3) #7
  ret i32 0
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @either_copyin(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %2 to ptr
  %6 = tail call ptr @memmove(ptr noundef %0, ptr noundef %5, i32 noundef %3) #7
  ret i32 0
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @copyout(i32 noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = inttoptr i32 %2 to ptr
  %7 = tail call ptr @memmove(ptr noundef %6, ptr noundef %3, i32 noundef %4) #7
  ret i32 0
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @copyin(i32 noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %2 to ptr
  %6 = tail call ptr @memmove(ptr noundef %1, ptr noundef %5, i32 noundef %3) #7
  ret i32 0
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local nonnull ptr @myproc() local_unnamed_addr #5 {
  %1 = load i32, ptr @curr, align 4, !tbaa !11
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %1
  ret ptr %2
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_start() local_unnamed_addr #1 {
  tail call void @fsinit(i32 noundef 1) #7
  tail call void @fileinit() #7
  store ptr @consoleread, ptr getelementptr inbounds nuw (i8, ptr @devsw, i32 8), align 4, !tbaa !13
  store ptr @consolewrite, ptr getelementptr inbounds nuw (i8, ptr @devsw, i32 12), align 4, !tbaa !16
  %1 = tail call ptr @namei(ptr noundef nonnull @.str.2) #7
  %2 = icmp eq ptr %1, null
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call void @panic(ptr noundef nonnull @.str.3) #8
  unreachable

4:                                                ; preds = %0, %17
  %5 = phi i32 [ %18, %17 ], [ 0, %0 ]
  %6 = icmp eq i32 %5, 8
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  tail call void @iput(ptr noundef nonnull %1) #7
  store i32 1, ptr @fsready, align 4, !tbaa !11
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %5
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 4
  store i32 -1, ptr %10, align 4, !tbaa !17
  %11 = tail call ptr @namei(ptr noundef nonnull @.str.4) #7
  %12 = getelementptr inbounds nuw i8, ptr %9, i32 8
  store ptr %11, ptr %12, align 4, !tbaa !21
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  br label %14

14:                                               ; preds = %19, %8
  %15 = phi i32 [ 0, %8 ], [ %27, %19 ]
  %16 = icmp eq i32 %15, 3
  br i1 %16, label %17, label %19

17:                                               ; preds = %14
  %18 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !22

19:                                               ; preds = %14
  %20 = tail call ptr @filealloc() #7
  store i32 3, ptr %20, align 4, !tbaa !23
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 24
  store i16 1, ptr %21, align 4, !tbaa !27
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 8
  store i8 1, ptr %22, align 4, !tbaa !28
  %23 = getelementptr inbounds nuw i8, ptr %20, i32 9
  store i8 1, ptr %23, align 1, !tbaa !29
  %24 = tail call ptr @idup(ptr noundef nonnull %1) #7
  %25 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store ptr %24, ptr %25, align 4, !tbaa !30
  %26 = getelementptr inbounds nuw [16 x ptr], ptr %13, i32 0, i32 %15
  store ptr %20, ptr %26, align 4, !tbaa !31
  %27 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !33
}

; Function Attrs: minsize optsize
declare dso_local void @fsinit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fileinit() local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define internal i32 @consoleread(i32 %0, i32 noundef %1, i32 noundef %2) #1 {
  %4 = tail call i32 @kconsread(i32 noundef %1, i32 noundef %2) #7
  ret i32 %4
}

; Function Attrs: minsize nounwind optsize
define internal noundef i32 @consolewrite(i32 %0, i32 noundef %1, i32 noundef returned %2) #1 {
  %4 = inttoptr i32 %1 to ptr
  tail call void @kconswrite(ptr noundef %4, i32 noundef %2) #7
  ret i32 %2
}

; Function Attrs: minsize optsize
declare dso_local ptr @namei(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @filealloc() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @idup(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iput(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_forkcopy(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @fsproc, i32 0, i32 %0
  %4 = getelementptr inbounds [8 x %struct.proc], ptr @fsproc, i32 0, i32 %1
  %5 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %6 = load i32, ptr %5, align 4, !tbaa !17
  %7 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store i32 %6, ptr %7, align 4, !tbaa !17
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %9 = getelementptr inbounds nuw i8, ptr %4, i32 12
  br label %10

10:                                               ; preds = %23, %2
  %11 = phi i32 [ 0, %2 ], [ %26, %23 ]
  %12 = icmp eq i32 %11, 16
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %15 = load ptr, ptr %14, align 4, !tbaa !21
  %16 = icmp eq ptr %15, null
  br i1 %16, label %29, label %27

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw [16 x ptr], ptr %8, i32 0, i32 %11
  %19 = load ptr, ptr %18, align 4, !tbaa !31
  %20 = icmp eq ptr %19, null
  br i1 %20, label %23, label %21

21:                                               ; preds = %17
  %22 = tail call ptr @filedup(ptr noundef nonnull %19) #7
  br label %23

23:                                               ; preds = %17, %21
  %24 = phi ptr [ %22, %21 ], [ null, %17 ]
  %25 = getelementptr inbounds nuw [16 x ptr], ptr %9, i32 0, i32 %11
  store ptr %24, ptr %25, align 4, !tbaa !31
  %26 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !34

27:                                               ; preds = %13
  %28 = tail call ptr @idup(ptr noundef nonnull %15) #7
  br label %29

29:                                               ; preds = %13, %27
  %30 = phi ptr [ %28, %27 ], [ null, %13 ]
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 8
  store ptr %30, ptr %31, align 4, !tbaa !21
  ret void
}

; Function Attrs: minsize optsize
declare dso_local ptr @filedup(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_exit(i32 noundef %0) local_unnamed_addr #1 {
  %2 = getelementptr inbounds [8 x %struct.proc], ptr @fsproc, i32 0, i32 %0
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 12
  br label %4

4:                                                ; preds = %16, %1
  %5 = phi i32 [ 0, %1 ], [ %17, %16 ]
  %6 = icmp eq i32 %5, 16
  br i1 %6, label %7, label %11

7:                                                ; preds = %4
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %9 = load ptr, ptr %8, align 4, !tbaa !21
  %10 = icmp eq ptr %9, null
  br i1 %10, label %19, label %18

11:                                               ; preds = %4
  %12 = getelementptr inbounds nuw [16 x ptr], ptr %3, i32 0, i32 %5
  %13 = load ptr, ptr %12, align 4, !tbaa !31
  %14 = icmp eq ptr %13, null
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  tail call void @fileclose(ptr noundef nonnull %13) #7
  store ptr null, ptr %12, align 4, !tbaa !31
  br label %16

16:                                               ; preds = %11, %15
  %17 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !35

18:                                               ; preds = %7
  tail call void @vfs_iput(ptr noundef nonnull %9) #9
  store ptr null, ptr %8, align 4, !tbaa !21
  br label %19

19:                                               ; preds = %18, %7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @fileclose(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_iput(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %1
  tail call void @fat_put(ptr noundef %0) #7
  br label %6

5:                                                ; preds = %1
  tail call void @iput(ptr noundef %0) #7
  br label %6

6:                                                ; preds = %5, %4
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vfs_readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = tail call i32 @fat_is(ptr noundef %0) #7
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %5
  %9 = tail call i32 @fat_readi(ptr noundef %0, i32 noundef %2, i32 noundef %3, i32 noundef %4) #7
  br label %12

10:                                               ; preds = %5
  %11 = tail call i32 @readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #7
  br label %12

12:                                               ; preds = %10, %8
  %13 = phi i32 [ %9, %8 ], [ %11, %10 ]
  ret i32 %13
}

; Function Attrs: minsize optsize
declare dso_local i32 @fat_is(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @fat_readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vfs_writei(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = tail call i32 @fat_is(ptr noundef %0) #7
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %5
  %9 = tail call i32 @writei(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #7
  br label %10

10:                                               ; preds = %5, %8
  %11 = phi i32 [ %9, %8 ], [ -1, %5 ]
  ret i32 %11
}

; Function Attrs: minsize optsize
declare dso_local i32 @writei(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_ilock(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  tail call void @ilock(ptr noundef %0) #7
  br label %5

5:                                                ; preds = %4, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @ilock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_iunlock(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  tail call void @iunlock(ptr noundef %0) #7
  br label %5

5:                                                ; preds = %4, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @iunlock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fat_put(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_stati(ptr noundef %0, ptr noundef %1) local_unnamed_addr #1 {
  %3 = tail call i32 @fat_is(ptr noundef %0) #7
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %6, label %5

5:                                                ; preds = %2
  tail call void @fat_stati(ptr noundef %0, ptr noundef %1) #7
  br label %7

6:                                                ; preds = %2
  tail call void @stati(ptr noundef %0, ptr noundef %1) #7
  br label %7

7:                                                ; preds = %6, %5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @fat_stati(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @stati(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_mount(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = icmp eq i32 %0, 0
  br i1 %3, label %4, label %40

4:                                                ; preds = %2
  %5 = inttoptr i32 %1 to ptr
  %6 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %37, label %8

8:                                                ; preds = %4, %12
  %9 = phi ptr [ %14, %12 ], [ @.str.5, %4 ]
  %10 = phi i32 [ %15, %12 ], [ 0, %4 ]
  %11 = icmp eq i32 %10, 8
  br i1 %11, label %17, label %12

12:                                               ; preds = %8
  %13 = load i8, ptr %9, align 1, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %9, i32 1
  %15 = add nuw nsw i32 %10, 1
  %16 = getelementptr inbounds nuw i8, ptr %5, i32 %10
  store i8 %13, ptr %16, align 1, !tbaa !3
  br label %8, !llvm.loop !36

17:                                               ; preds = %8, %23
  %18 = phi i32 [ %26, %23 ], [ 0, %8 ]
  %19 = phi i32 [ %24, %23 ], [ 8, %8 ]
  %20 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %18
  %21 = load i8, ptr %20, align 1, !tbaa !3
  %22 = icmp eq i8 %21, 0
  br i1 %22, label %27, label %23

23:                                               ; preds = %17
  %24 = add nuw nsw i32 %19, 1
  %25 = getelementptr inbounds nuw i8, ptr %5, i32 %19
  store i8 %21, ptr %25, align 1, !tbaa !3
  %26 = add nuw nsw i32 %18, 1
  br label %17, !llvm.loop !37

27:                                               ; preds = %17, %31
  %28 = phi i32 [ %34, %31 ], [ 0, %17 ]
  %29 = phi i32 [ %35, %31 ], [ %19, %17 ]
  %30 = icmp eq i32 %28, 16
  br i1 %30, label %37, label %31

31:                                               ; preds = %27
  %32 = getelementptr inbounds nuw i8, ptr @.str.6, i32 %28
  %33 = load i8, ptr %32, align 1, !tbaa !3
  %34 = add nuw nsw i32 %28, 1
  %35 = add nuw nsw i32 %29, 1
  %36 = getelementptr inbounds nuw i8, ptr %5, i32 %29
  store i8 %33, ptr %36, align 1, !tbaa !3
  br label %27, !llvm.loop !38

37:                                               ; preds = %27, %4
  %38 = phi i32 [ 0, %4 ], [ %29, %27 ]
  %39 = getelementptr inbounds i8, ptr %5, i32 %38
  store i8 0, ptr %39, align 1, !tbaa !3
  br label %112

40:                                               ; preds = %2
  %41 = inttoptr i32 %0 to ptr
  %42 = inttoptr i32 %1 to ptr
  %43 = load i32, ptr @fatvol, align 4, !tbaa !11
  %44 = icmp ne i32 %43, 0
  %45 = load i8, ptr @fatmnt, align 1
  %46 = icmp eq i8 %45, 0
  %47 = select i1 %44, i1 %46, i1 false
  br i1 %47, label %48, label %112

48:                                               ; preds = %40
  %49 = load i8, ptr %41, align 1, !tbaa !3
  %50 = icmp eq i8 %49, 102
  br i1 %50, label %51, label %112

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw i8, ptr %41, i32 1
  %53 = load i8, ptr %52, align 1, !tbaa !3
  %54 = icmp eq i8 %53, 97
  br i1 %54, label %55, label %112

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %41, i32 2
  %57 = load i8, ptr %56, align 1, !tbaa !3
  %58 = icmp eq i8 %57, 116
  br i1 %58, label %59, label %112

59:                                               ; preds = %55
  %60 = getelementptr inbounds nuw i8, ptr %41, i32 3
  %61 = load i8, ptr %60, align 1, !tbaa !3
  %62 = icmp eq i8 %61, 48
  br i1 %62, label %63, label %112

63:                                               ; preds = %59
  %64 = getelementptr inbounds nuw i8, ptr %41, i32 4
  %65 = load i8, ptr %64, align 1, !tbaa !3
  %66 = icmp eq i8 %65, 0
  br i1 %66, label %67, label %112

67:                                               ; preds = %63
  %68 = load i8, ptr %42, align 1, !tbaa !3
  %69 = icmp eq i8 %68, 47
  br i1 %69, label %70, label %112

70:                                               ; preds = %67
  %71 = getelementptr inbounds nuw i8, ptr %42, i32 1
  %72 = load i8, ptr %71, align 1, !tbaa !3
  %73 = icmp eq i8 %72, 0
  br i1 %73, label %112, label %74

74:                                               ; preds = %70
  %75 = tail call ptr @namei(ptr noundef nonnull %42) #7
  %76 = icmp eq ptr %75, null
  br i1 %76, label %112, label %77

77:                                               ; preds = %74
  tail call void @ilock(ptr noundef nonnull %75) #7
  %78 = getelementptr inbounds nuw i8, ptr %75, i32 20
  %79 = load i16, ptr %78, align 4, !tbaa !39
  %80 = icmp eq i16 %79, 1
  %81 = load i32, ptr %75, align 4, !tbaa !42
  %82 = getelementptr inbounds nuw i8, ptr %75, i32 4
  %83 = load i32, ptr %82, align 4, !tbaa !43
  tail call void @iunlockput(ptr noundef nonnull %75) #7
  br i1 %80, label %84, label %112

84:                                               ; preds = %77
  %85 = load i32, ptr @fatvol, align 4, !tbaa !11
  %86 = tail call i32 @fat_mount(i32 noundef %85) #7
  %87 = icmp slt i32 %86, 0
  br i1 %87, label %112, label %88

88:                                               ; preds = %84
  store i32 %81, ptr @fatmnt_dev, align 4, !tbaa !11
  store i32 %83, ptr @fatmnt_inum, align 4, !tbaa !11
  br label %89

89:                                               ; preds = %99, %88
  %90 = phi i32 [ 0, %88 ], [ %101, %99 ]
  %91 = getelementptr inbounds nuw i8, ptr %42, i32 %90
  %92 = load i8, ptr %91, align 1, !tbaa !3
  %93 = icmp eq i8 %92, 0
  br i1 %93, label %94, label %95

94:                                               ; preds = %95, %89
  br label %102

95:                                               ; preds = %89
  %96 = icmp ne i8 %92, 32
  %97 = icmp samesign ult i32 %90, 26
  %98 = select i1 %96, i1 %97, i1 false
  br i1 %98, label %99, label %94

99:                                               ; preds = %95
  %100 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %90
  store i8 %92, ptr %100, align 1, !tbaa !3
  %101 = add nuw nsw i32 %90, 1
  br label %89, !llvm.loop !44

102:                                              ; preds = %94, %105
  %103 = phi i32 [ %106, %105 ], [ %90, %94 ]
  %104 = icmp sgt i32 %103, 1
  br i1 %104, label %105, label %110

105:                                              ; preds = %102
  %106 = add nsw i32 %103, -1
  %107 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %106
  %108 = load i8, ptr %107, align 1, !tbaa !3
  %109 = icmp eq i8 %108, 47
  br i1 %109, label %102, label %110, !llvm.loop !45

110:                                              ; preds = %102, %105
  %111 = getelementptr inbounds [28 x i8], ptr @fatmnt, i32 0, i32 %103
  store i8 0, ptr %111, align 1, !tbaa !3
  br label %112

112:                                              ; preds = %40, %63, %59, %55, %51, %48, %70, %67, %110, %77, %84, %74, %37
  %113 = phi i32 [ %38, %37 ], [ -1, %40 ], [ -1, %63 ], [ -1, %59 ], [ -1, %55 ], [ -1, %51 ], [ -1, %48 ], [ -1, %70 ], [ -1, %67 ], [ -1, %74 ], [ 0, %110 ], [ -1, %77 ], [ -1, %84 ]
  ret i32 %113
}

; Function Attrs: minsize optsize
declare dso_local void @iunlockput(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @fat_mount(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_umount(i32 noundef %0) local_unnamed_addr #1 {
  %2 = inttoptr i32 %0 to ptr
  %3 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %4 = icmp eq i8 %3, 0
  br i1 %4, label %27, label %5

5:                                                ; preds = %1, %13
  %6 = phi i8 [ %16, %13 ], [ %3, %1 ]
  %7 = phi i32 [ %14, %13 ], [ 0, %1 ]
  %8 = icmp eq i8 %6, 0
  %9 = getelementptr inbounds nuw i8, ptr %2, i32 %7
  %10 = load i8, ptr %9, align 1, !tbaa !3
  br i1 %8, label %17, label %11

11:                                               ; preds = %5
  %12 = icmp eq i8 %10, %6
  br i1 %12, label %13, label %27

13:                                               ; preds = %11
  %14 = add nuw nsw i32 %7, 1
  %15 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %14
  %16 = load i8, ptr %15, align 1, !tbaa !3
  br label %5, !llvm.loop !46

17:                                               ; preds = %5
  %18 = getelementptr inbounds nuw i8, ptr %2, i32 %7
  switch i8 %10, label %27 [
    i8 0, label %23
    i8 47, label %19
  ]

19:                                               ; preds = %17
  %20 = getelementptr inbounds nuw i8, ptr %18, i32 1
  %21 = load i8, ptr %20, align 1, !tbaa !3
  %22 = icmp eq i8 %21, 0
  br i1 %22, label %23, label %27

23:                                               ; preds = %17, %19
  %24 = tail call i32 @fat_busy() #7
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %23
  tail call void @fat_unmount() #7
  store i8 0, ptr @fatmnt, align 1, !tbaa !3
  store i32 -1, ptr @fatmnt_dev, align 4, !tbaa !11
  br label %27

27:                                               ; preds = %11, %26, %17, %19, %23, %1
  %28 = phi i32 [ -1, %1 ], [ 0, %26 ], [ -1, %17 ], [ -1, %19 ], [ -1, %23 ], [ -1, %11 ]
  ret i32 %28
}

; Function Attrs: minsize optsize
declare dso_local i32 @fat_busy() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fat_unmount() local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_read(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = icmp slt i32 %0, 0
  br i1 %4, label %14, label %5

5:                                                ; preds = %3
  %6 = icmp samesign ugt i32 %0, 15
  br i1 %6, label %14, label %7

7:                                                ; preds = %5
  %8 = load i32, ptr @curr, align 4, !tbaa !11
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %8, i32 3, i32 %0
  %10 = load ptr, ptr %9, align 4, !tbaa !31
  %11 = icmp eq ptr %10, null
  br i1 %11, label %14, label %12

12:                                               ; preds = %7
  %13 = tail call i32 @fileread(ptr noundef nonnull %10, i32 noundef %1, i32 noundef %2) #7
  br label %14

14:                                               ; preds = %3, %5, %7, %12
  %15 = phi i32 [ %13, %12 ], [ -1, %7 ], [ -1, %5 ], [ -1, %3 ]
  ret i32 %15
}

; Function Attrs: minsize optsize
declare dso_local i32 @fileread(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_write(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  %4 = icmp slt i32 %0, 0
  br i1 %4, label %14, label %5

5:                                                ; preds = %3
  %6 = icmp samesign ugt i32 %0, 15
  br i1 %6, label %14, label %7

7:                                                ; preds = %5
  %8 = load i32, ptr @curr, align 4, !tbaa !11
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %8, i32 3, i32 %0
  %10 = load ptr, ptr %9, align 4, !tbaa !31
  %11 = icmp eq ptr %10, null
  br i1 %11, label %14, label %12

12:                                               ; preds = %7
  %13 = tail call i32 @filewrite(ptr noundef nonnull %10, i32 noundef %1, i32 noundef %2) #7
  br label %14

14:                                               ; preds = %3, %5, %7, %12
  %15 = phi i32 [ %13, %12 ], [ -1, %7 ], [ -1, %5 ], [ -1, %3 ]
  ret i32 %15
}

; Function Attrs: minsize optsize
declare dso_local i32 @filewrite(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_close(i32 noundef %0) local_unnamed_addr #1 {
  %2 = icmp slt i32 %0, 0
  br i1 %2, label %11, label %3

3:                                                ; preds = %1
  %4 = icmp samesign ugt i32 %0, 15
  br i1 %4, label %11, label %5

5:                                                ; preds = %3
  %6 = load i32, ptr @curr, align 4, !tbaa !11
  %7 = getelementptr inbounds [8 x %struct.proc], ptr @fsproc, i32 0, i32 %6, i32 3, i32 %0
  %8 = load ptr, ptr %7, align 4, !tbaa !31
  %9 = icmp eq ptr %8, null
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store ptr null, ptr %7, align 4, !tbaa !31
  tail call void @fileclose(ptr noundef nonnull %8) #7
  br label %11

11:                                               ; preds = %1, %3, %5, %10
  %12 = phi i32 [ 0, %10 ], [ -1, %5 ], [ -1, %3 ], [ -1, %1 ]
  ret i32 %12
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 16) i32 @kfs_dup(i32 noundef %0) local_unnamed_addr #1 {
  %2 = icmp slt i32 %0, 0
  br i1 %2, label %15, label %3

3:                                                ; preds = %1
  %4 = icmp samesign ugt i32 %0, 15
  br i1 %4, label %15, label %5

5:                                                ; preds = %3
  %6 = load i32, ptr @curr, align 4, !tbaa !11
  %7 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %6, i32 3, i32 %0
  %8 = load ptr, ptr %7, align 4, !tbaa !31
  %9 = icmp eq ptr %8, null
  br i1 %9, label %15, label %10

10:                                               ; preds = %5
  %11 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %8) #9
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %15, label %13

13:                                               ; preds = %10
  %14 = tail call ptr @filedup(ptr noundef nonnull %8) #7
  br label %15

15:                                               ; preds = %1, %3, %13, %10, %5
  %16 = phi i32 [ -1, %5 ], [ %11, %13 ], [ -1, %10 ], [ -1, %3 ], [ -1, %1 ]
  ret i32 %16
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc range(i32 -1, 16) i32 @fdalloc(ptr noundef %0) unnamed_addr #6 {
  %2 = load i32, ptr @curr, align 4, !tbaa !11
  br label %3

3:                                                ; preds = %11, %1
  %4 = phi i32 [ 0, %1 ], [ %12, %11 ]
  %5 = icmp eq i32 %4, 16
  br i1 %5, label %13, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %2, i32 3, i32 %4
  %8 = load ptr, ptr %7, align 4, !tbaa !31
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %11

10:                                               ; preds = %6
  store ptr %0, ptr %7, align 4, !tbaa !31
  br label %13

11:                                               ; preds = %6
  %12 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !47

13:                                               ; preds = %3, %10
  %14 = phi i32 [ %4, %10 ], [ -1, %3 ]
  ret i32 %14
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_fstat(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = icmp slt i32 %0, 0
  br i1 %3, label %13, label %4

4:                                                ; preds = %2
  %5 = icmp samesign ugt i32 %0, 15
  br i1 %5, label %13, label %6

6:                                                ; preds = %4
  %7 = load i32, ptr @curr, align 4, !tbaa !11
  %8 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %7, i32 3, i32 %0
  %9 = load ptr, ptr %8, align 4, !tbaa !31
  %10 = icmp eq ptr %9, null
  br i1 %10, label %13, label %11

11:                                               ; preds = %6
  %12 = tail call i32 @filestat(ptr noundef nonnull %9, i32 noundef %1) #7
  br label %13

13:                                               ; preds = %2, %4, %6, %11
  %14 = phi i32 [ %12, %11 ], [ -1, %6 ], [ -1, %4 ], [ -1, %2 ]
  ret i32 %14
}

; Function Attrs: minsize optsize
declare dso_local i32 @filestat(ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_pipe(i32 noundef %0) local_unnamed_addr #1 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #10
  %4 = call i32 @pipealloc(ptr noundef nonnull %2, ptr noundef nonnull %3) #7
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %23, label %6

6:                                                ; preds = %1
  %7 = load ptr, ptr %2, align 4, !tbaa !31
  %8 = call fastcc i32 @fdalloc(ptr noundef %7) #9
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %10, label %17

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 4, !tbaa !31
  %12 = call fastcc i32 @fdalloc(ptr noundef %11) #9
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %20

14:                                               ; preds = %10
  %15 = load i32, ptr @curr, align 4, !tbaa !11
  %16 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %15, i32 3, i32 %8
  store ptr null, ptr %16, align 4, !tbaa !31
  br label %17

17:                                               ; preds = %6, %14
  %18 = load ptr, ptr %2, align 4, !tbaa !31
  call void @fileclose(ptr noundef %18) #7
  %19 = load ptr, ptr %3, align 4, !tbaa !31
  call void @fileclose(ptr noundef %19) #7
  br label %23

20:                                               ; preds = %10
  %21 = inttoptr i32 %0 to ptr
  store i32 %8, ptr %21, align 4, !tbaa !11
  %22 = getelementptr inbounds nuw i8, ptr %21, i32 4
  store i32 %12, ptr %22, align 4, !tbaa !11
  br label %23

23:                                               ; preds = %17, %20, %1
  %24 = phi i32 [ -1, %1 ], [ -1, %17 ], [ 0, %20 ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #10
  ret i32 %24
}

; Function Attrs: minsize optsize
declare dso_local i32 @pipealloc(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 16) i32 @kfs_open(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = inttoptr i32 %0 to ptr
  %4 = and i32 %1, 512
  %5 = icmp eq i32 %4, 0
  %6 = tail call fastcc i32 @fat_writepath(ptr noundef %3) #9
  br i1 %5, label %12, label %7

7:                                                ; preds = %2
  %8 = icmp eq i32 %6, 0
  br i1 %8, label %9, label %77

9:                                                ; preds = %7
  %10 = tail call fastcc ptr @create(ptr noundef %3, i16 noundef signext 2) #9
  %11 = icmp eq ptr %10, null
  br i1 %11, label %77, label %41

12:                                               ; preds = %2
  %13 = icmp ne i32 %6, 0
  %14 = icmp ne i32 %1, 0
  %15 = and i1 %14, %13
  br i1 %15, label %77, label %16

16:                                               ; preds = %12
  %17 = tail call fastcc ptr @vfs_resolve(ptr noundef %3) #9
  %18 = icmp eq ptr %17, null
  br i1 %18, label %77, label %19

19:                                               ; preds = %16
  %20 = tail call i32 @fat_is(ptr noundef nonnull %17) #7
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %35, label %22

22:                                               ; preds = %19
  %23 = tail call ptr @filealloc() #7
  %24 = icmp eq ptr %23, null
  br i1 %24, label %29, label %25

25:                                               ; preds = %22
  %26 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %23) #9
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %30

28:                                               ; preds = %25
  tail call void @fileclose(ptr noundef nonnull %23) #7
  br label %29

29:                                               ; preds = %22, %28
  tail call void @fat_put(ptr noundef nonnull %17) #7
  br label %77

30:                                               ; preds = %25
  store i32 2, ptr %23, align 4, !tbaa !23
  %31 = getelementptr inbounds nuw i8, ptr %23, i32 20
  store i32 0, ptr %31, align 4, !tbaa !48
  %32 = getelementptr inbounds nuw i8, ptr %23, i32 16
  store ptr %17, ptr %32, align 4, !tbaa !30
  %33 = getelementptr inbounds nuw i8, ptr %23, i32 8
  store i8 1, ptr %33, align 4, !tbaa !28
  %34 = getelementptr inbounds nuw i8, ptr %23, i32 9
  store i8 0, ptr %34, align 1, !tbaa !29
  br label %77

35:                                               ; preds = %19
  tail call void @ilock(ptr noundef nonnull %17) #7
  %36 = getelementptr inbounds nuw i8, ptr %17, i32 20
  %37 = load i16, ptr %36, align 4, !tbaa !39
  %38 = icmp eq i16 %37, 1
  %39 = and i1 %14, %38
  br i1 %39, label %40, label %41

40:                                               ; preds = %35
  tail call void @iunlockput(ptr noundef nonnull %17) #7
  br label %77

41:                                               ; preds = %35, %9
  %42 = phi ptr [ %10, %9 ], [ %17, %35 ]
  %43 = tail call ptr @filealloc() #7
  %44 = icmp eq ptr %43, null
  br i1 %44, label %49, label %45

45:                                               ; preds = %41
  %46 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %43) #9
  %47 = icmp slt i32 %46, 0
  br i1 %47, label %48, label %50

48:                                               ; preds = %45
  tail call void @fileclose(ptr noundef nonnull %43) #7
  br label %49

49:                                               ; preds = %41, %48
  tail call void @iunlockput(ptr noundef nonnull %42) #7
  br label %77

50:                                               ; preds = %45
  %51 = getelementptr inbounds nuw i8, ptr %42, i32 20
  %52 = load i16, ptr %51, align 4, !tbaa !39
  %53 = icmp eq i16 %52, 3
  br i1 %53, label %54, label %58

54:                                               ; preds = %50
  %55 = getelementptr inbounds nuw i8, ptr %42, i32 22
  %56 = load i16, ptr %55, align 2, !tbaa !49
  %57 = getelementptr inbounds nuw i8, ptr %43, i32 24
  store i16 %56, ptr %57, align 4, !tbaa !27
  br label %60

58:                                               ; preds = %50
  %59 = getelementptr inbounds nuw i8, ptr %43, i32 20
  store i32 0, ptr %59, align 4, !tbaa !48
  br label %60

60:                                               ; preds = %58, %54
  %61 = phi i32 [ 3, %54 ], [ 2, %58 ]
  store i32 %61, ptr %43, align 4, !tbaa !23
  %62 = getelementptr inbounds nuw i8, ptr %43, i32 16
  store ptr %42, ptr %62, align 4, !tbaa !30
  %63 = trunc i32 %1 to i8
  %64 = and i8 %63, 1
  %65 = xor i8 %64, 1
  %66 = getelementptr inbounds nuw i8, ptr %43, i32 8
  store i8 %65, ptr %66, align 4, !tbaa !28
  %67 = and i32 %1, 3
  %68 = icmp ne i32 %67, 0
  %69 = zext i1 %68 to i8
  %70 = getelementptr inbounds nuw i8, ptr %43, i32 9
  store i8 %69, ptr %70, align 1, !tbaa !29
  %71 = and i32 %1, 1024
  %72 = icmp ne i32 %71, 0
  %73 = icmp eq i16 %52, 2
  %74 = and i1 %72, %73
  br i1 %74, label %75, label %76

75:                                               ; preds = %60
  tail call void @itrunc(ptr noundef nonnull %42) #7
  br label %76

76:                                               ; preds = %75, %60
  tail call void @iunlock(ptr noundef nonnull %42) #7
  br label %77

77:                                               ; preds = %49, %76, %29, %30, %16, %12, %9, %7, %40
  %78 = phi i32 [ -1, %40 ], [ -1, %7 ], [ -1, %9 ], [ -1, %12 ], [ -1, %16 ], [ -1, %29 ], [ %26, %30 ], [ -1, %49 ], [ %46, %76 ]
  ret i32 %78
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @fat_writepath(ptr noundef readonly captures(none) %0) unnamed_addr #1 {
  %2 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %3 = icmp eq i8 %2, 0
  %4 = load i8, ptr %0, align 1, !tbaa !3
  br i1 %3, label %20, label %5

5:                                                ; preds = %1
  %6 = icmp eq i8 %4, 47
  br i1 %6, label %7, label %22

7:                                                ; preds = %5, %15
  %8 = phi i8 [ %18, %15 ], [ %2, %5 ]
  %9 = phi i32 [ %16, %15 ], [ 0, %5 ]
  %10 = icmp eq i8 %8, 0
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 %9
  %12 = load i8, ptr %11, align 1, !tbaa !3
  br i1 %10, label %19, label %13

13:                                               ; preds = %7
  %14 = icmp eq i8 %12, %8
  br i1 %14, label %15, label %20

15:                                               ; preds = %13
  %16 = add nuw nsw i32 %9, 1
  %17 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3
  br label %7, !llvm.loop !50

19:                                               ; preds = %7
  switch i8 %12, label %20 [
    i8 0, label %31
    i8 47, label %31
  ]

20:                                               ; preds = %13, %19, %1
  %21 = icmp eq i8 %4, 47
  br i1 %21, label %31, label %22

22:                                               ; preds = %5, %20
  %23 = load i32, ptr @curr, align 4, !tbaa !11
  %24 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %23, i32 2
  %25 = load ptr, ptr %24, align 4, !tbaa !21
  %26 = icmp eq ptr %25, null
  br i1 %26, label %31, label %27

27:                                               ; preds = %22
  %28 = tail call i32 @fat_is(ptr noundef nonnull %25) #7
  %29 = icmp ne i32 %28, 0
  %30 = zext i1 %29 to i32
  br label %31

31:                                               ; preds = %19, %19, %20, %22, %27
  %32 = phi i32 [ 0, %22 ], [ 0, %20 ], [ %30, %27 ], [ 1, %19 ], [ 1, %19 ]
  ret i32 %32
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @create(ptr noundef %0, i16 noundef signext range(i16 1, 3) %1) unnamed_addr #1 {
  %3 = alloca [62 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %3) #10
  %4 = call ptr @nameiparent(ptr noundef %0, ptr noundef nonnull %3) #7
  %5 = icmp eq ptr %4, null
  br i1 %5, label %50, label %6

6:                                                ; preds = %2
  call void @ilock(ptr noundef nonnull %4) #7
  %7 = call ptr @dirlookup(ptr noundef nonnull %4, ptr noundef nonnull %3, ptr noundef null) #7
  %8 = icmp eq ptr %7, null
  br i1 %8, label %16, label %9

9:                                                ; preds = %6
  call void @iunlockput(ptr noundef nonnull %4) #7
  call void @ilock(ptr noundef nonnull %7) #7
  %10 = icmp eq i16 %1, 2
  br i1 %10, label %11, label %47

11:                                               ; preds = %9
  %12 = getelementptr inbounds nuw i8, ptr %7, i32 20
  %13 = load i16, ptr %12, align 4, !tbaa !39
  %14 = and i16 %13, -2
  %15 = icmp eq i16 %14, 2
  br i1 %15, label %50, label %47

16:                                               ; preds = %6
  %17 = load i32, ptr %4, align 4, !tbaa !42
  %18 = call ptr @ialloc(i32 noundef %17, i16 noundef signext %1) #7
  %19 = icmp eq ptr %18, null
  br i1 %19, label %47, label %20

20:                                               ; preds = %16
  call void @ilock(ptr noundef nonnull %18) #7
  %21 = getelementptr inbounds nuw i8, ptr %18, i32 22
  store i16 0, ptr %21, align 2, !tbaa !49
  %22 = getelementptr inbounds nuw i8, ptr %18, i32 24
  store i16 0, ptr %22, align 4, !tbaa !51
  %23 = getelementptr inbounds nuw i8, ptr %18, i32 26
  store i16 1, ptr %23, align 2, !tbaa !52
  call void @iupdate(ptr noundef nonnull %18) #7
  %24 = icmp eq i16 %1, 1
  br i1 %24, label %25, label %36

25:                                               ; preds = %20
  %26 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %27 = load i32, ptr %26, align 4, !tbaa !43
  %28 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.7, i32 noundef %27) #7
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %35, label %30

30:                                               ; preds = %25
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %32 = load i32, ptr %31, align 4, !tbaa !43
  %33 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.8, i32 noundef %32) #7
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %35, label %36

35:                                               ; preds = %30, %25
  call void @panic(ptr noundef nonnull @.str.11) #8
  unreachable

36:                                               ; preds = %30, %20
  %37 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %38 = load i32, ptr %37, align 4, !tbaa !43
  %39 = call i32 @dirlink(ptr noundef nonnull %4, ptr noundef nonnull %3, i32 noundef %38) #7
  %40 = icmp slt i32 %39, 0
  br i1 %40, label %41, label %42

41:                                               ; preds = %36
  call void @panic(ptr noundef nonnull @.str.12) #8
  unreachable

42:                                               ; preds = %36
  br i1 %24, label %43, label %47

43:                                               ; preds = %42
  %44 = getelementptr inbounds nuw i8, ptr %4, i32 26
  %45 = load i16, ptr %44, align 2, !tbaa !52
  %46 = add i16 %45, 1
  store i16 %46, ptr %44, align 2, !tbaa !52
  call void @iupdate(ptr noundef nonnull %4) #7
  br label %47

47:                                               ; preds = %42, %43, %16, %9, %11
  %48 = phi ptr [ %7, %11 ], [ %7, %9 ], [ %4, %16 ], [ %4, %43 ], [ %4, %42 ]
  %49 = phi ptr [ null, %11 ], [ null, %9 ], [ null, %16 ], [ %18, %43 ], [ %18, %42 ]
  call void @iunlockput(ptr noundef nonnull %48) #7
  br label %50

50:                                               ; preds = %47, %11, %2
  %51 = phi ptr [ null, %2 ], [ %7, %11 ], [ %49, %47 ]
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %3) #10
  ret ptr %51
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @vfs_resolve(ptr noundef %0) unnamed_addr #1 {
  %2 = alloca [64 x i8], align 1
  %3 = load i32, ptr @curr, align 4, !tbaa !11
  %4 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %3
  %5 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %7, label %16

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %9 = load ptr, ptr %8, align 4, !tbaa !21
  %10 = icmp eq ptr %9, null
  br i1 %10, label %14, label %11

11:                                               ; preds = %7
  %12 = tail call i32 @fat_is(ptr noundef nonnull %9) #7
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11, %7
  %15 = tail call ptr @namei(ptr noundef %0) #7
  br label %94

16:                                               ; preds = %11, %1
  %17 = load i8, ptr %0, align 1, !tbaa !3
  %18 = icmp eq i8 %17, 47
  br i1 %18, label %23, label %19

19:                                               ; preds = %16
  %20 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %21 = load ptr, ptr %20, align 4, !tbaa !21
  %22 = icmp eq ptr %21, null
  br i1 %22, label %23, label %25

23:                                               ; preds = %19, %16
  %24 = tail call ptr @namei(ptr noundef nonnull @.str.4) #7
  br label %32

25:                                               ; preds = %19
  %26 = tail call i32 @fat_is(ptr noundef nonnull %21) #7
  %27 = icmp eq i32 %26, 0
  %28 = load ptr, ptr %20, align 4, !tbaa !21
  br i1 %27, label %30, label %29

29:                                               ; preds = %25
  tail call void @fat_dup(ptr noundef %28) #7
  br label %32

30:                                               ; preds = %25
  %31 = tail call ptr @idup(ptr noundef %28) #7
  br label %32

32:                                               ; preds = %29, %30, %23
  %33 = phi ptr [ %24, %23 ], [ %28, %29 ], [ %31, %30 ]
  %34 = icmp eq ptr %33, null
  br i1 %34, label %94, label %35

35:                                               ; preds = %32
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #10
  br label %36

36:                                               ; preds = %90, %35
  %37 = phi ptr [ %33, %35 ], [ %91, %90 ]
  %38 = phi ptr [ %0, %35 ], [ %46, %90 ]
  br label %39

39:                                               ; preds = %42, %36
  %40 = phi ptr [ %38, %36 ], [ %43, %42 ]
  %41 = load i8, ptr %40, align 1, !tbaa !3
  switch i8 %41, label %44 [
    i8 47, label %42
    i8 0, label %92
  ]

42:                                               ; preds = %39
  %43 = getelementptr inbounds nuw i8, ptr %40, i32 1
  br label %39, !llvm.loop !53

44:                                               ; preds = %39, %53
  %45 = phi i8 [ %56, %53 ], [ %41, %39 ]
  %46 = phi ptr [ %55, %53 ], [ %40, %39 ]
  %47 = phi i32 [ %54, %53 ], [ 0, %39 ]
  switch i8 %45, label %48 [
    i8 0, label %57
    i8 47, label %57
  ]

48:                                               ; preds = %44
  %49 = icmp slt i32 %47, 63
  br i1 %49, label %50, label %53

50:                                               ; preds = %48
  %51 = add nsw i32 %47, 1
  %52 = getelementptr inbounds i8, ptr %2, i32 %47
  store i8 %45, ptr %52, align 1, !tbaa !3
  br label %53

53:                                               ; preds = %50, %48
  %54 = phi i32 [ %51, %50 ], [ %47, %48 ]
  %55 = getelementptr inbounds nuw i8, ptr %46, i32 1
  %56 = load i8, ptr %55, align 1, !tbaa !3
  br label %44, !llvm.loop !54

57:                                               ; preds = %44, %44
  %58 = getelementptr inbounds i8, ptr %2, i32 %47
  store i8 0, ptr %58, align 1, !tbaa !3
  %59 = call i32 @fat_is(ptr noundef nonnull %37) #7
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %70, label %61

61:                                               ; preds = %57
  %62 = getelementptr inbounds nuw i8, ptr %37, i32 20
  %63 = load i16, ptr %62, align 4, !tbaa !39
  %64 = icmp eq i16 %63, 1
  br i1 %64, label %65, label %67

65:                                               ; preds = %61
  %66 = call ptr @fat_lookup(ptr noundef nonnull %37, ptr noundef nonnull %2) #7
  br label %67

67:                                               ; preds = %61, %65
  %68 = phi ptr [ %66, %65 ], [ null, %61 ]
  call void @fat_put(ptr noundef nonnull %37) #7
  %69 = icmp eq ptr %68, null
  br i1 %69, label %92, label %90

70:                                               ; preds = %57
  call void @ilock(ptr noundef nonnull %37) #7
  %71 = getelementptr inbounds nuw i8, ptr %37, i32 20
  %72 = load i16, ptr %71, align 4, !tbaa !39
  %73 = icmp eq i16 %72, 1
  br i1 %73, label %75, label %74

74:                                               ; preds = %70
  call void @iunlockput(ptr noundef nonnull %37) #7
  br label %92

75:                                               ; preds = %70
  %76 = call ptr @dirlookup(ptr noundef nonnull %37, ptr noundef nonnull %2, ptr noundef null) #7
  call void @iunlockput(ptr noundef nonnull %37) #7
  %77 = icmp eq ptr %76, null
  br i1 %77, label %92, label %78

78:                                               ; preds = %75
  %79 = load i32, ptr %76, align 4, !tbaa !42
  %80 = load i32, ptr @fatmnt_dev, align 4, !tbaa !11
  %81 = icmp eq i32 %79, %80
  br i1 %81, label %82, label %90

82:                                               ; preds = %78
  %83 = getelementptr inbounds nuw i8, ptr %76, i32 4
  %84 = load i32, ptr %83, align 4, !tbaa !43
  %85 = load i32, ptr @fatmnt_inum, align 4, !tbaa !11
  %86 = icmp eq i32 %84, %85
  br i1 %86, label %87, label %90

87:                                               ; preds = %82
  call void @iput(ptr noundef nonnull %76) #7
  %88 = call ptr @fat_root() #7
  %89 = icmp eq ptr %88, null
  br i1 %89, label %92, label %90

90:                                               ; preds = %87, %67, %78, %82
  %91 = phi ptr [ %68, %67 ], [ %76, %82 ], [ %76, %78 ], [ %88, %87 ]
  br label %36

92:                                               ; preds = %67, %87, %75, %39, %74
  %93 = phi ptr [ null, %74 ], [ %37, %39 ], [ null, %75 ], [ null, %87 ], [ null, %67 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #10
  br label %94

94:                                               ; preds = %32, %92, %14
  %95 = phi ptr [ %93, %92 ], [ %15, %14 ], [ null, %32 ]
  ret ptr %95
}

; Function Attrs: minsize optsize
declare dso_local void @itrunc(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_chdir(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i32, ptr @curr, align 4, !tbaa !11
  %3 = inttoptr i32 %0 to ptr
  %4 = tail call fastcc ptr @vfs_resolve(ptr noundef %3) #9
  %5 = icmp eq ptr %4, null
  br i1 %5, label %26, label %6

6:                                                ; preds = %1
  %7 = tail call i32 @fat_is(ptr noundef nonnull %4) #7
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %14, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %11 = load i16, ptr %10, align 4, !tbaa !39
  %12 = icmp eq i16 %11, 1
  br i1 %12, label %20, label %13

13:                                               ; preds = %9
  tail call void @fat_put(ptr noundef nonnull %4) #7
  br label %26

14:                                               ; preds = %6
  tail call void @ilock(ptr noundef nonnull %4) #7
  %15 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !39
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %19, label %18

18:                                               ; preds = %14
  tail call void @iunlockput(ptr noundef nonnull %4) #7
  br label %26

19:                                               ; preds = %14
  tail call void @iunlock(ptr noundef nonnull %4) #7
  br label %20

20:                                               ; preds = %9, %19
  %21 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %2, i32 2
  %22 = load ptr, ptr %21, align 4, !tbaa !21
  %23 = icmp eq ptr %22, null
  br i1 %23, label %25, label %24

24:                                               ; preds = %20
  tail call void @vfs_iput(ptr noundef nonnull %22) #9
  br label %25

25:                                               ; preds = %24, %20
  store ptr %4, ptr %21, align 4, !tbaa !21
  br label %26

26:                                               ; preds = %1, %25, %18, %13
  %27 = phi i32 [ -1, %13 ], [ 0, %25 ], [ -1, %18 ], [ -1, %1 ]
  ret i32 %27
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_mkdir(i32 noundef %0) local_unnamed_addr #1 {
  %2 = inttoptr i32 %0 to ptr
  %3 = tail call fastcc i32 @fat_writepath(ptr noundef %2) #9
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %9

5:                                                ; preds = %1
  %6 = tail call fastcc ptr @create(ptr noundef %2, i16 noundef signext 1) #9
  %7 = icmp eq ptr %6, null
  br i1 %7, label %9, label %8

8:                                                ; preds = %5
  tail call void @iunlockput(ptr noundef nonnull %6) #7
  br label %9

9:                                                ; preds = %8, %5, %1
  %10 = phi i32 [ -1, %1 ], [ 0, %8 ], [ -1, %5 ]
  ret i32 %10
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_link(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = alloca [62 x i8], align 1
  %4 = inttoptr i32 %0 to ptr
  %5 = tail call fastcc i32 @fat_writepath(ptr noundef %4) #9
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %41

7:                                                ; preds = %2
  %8 = inttoptr i32 %1 to ptr
  %9 = tail call fastcc i32 @fat_writepath(ptr noundef %8) #9
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %41

11:                                               ; preds = %7
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %3) #10
  %12 = tail call ptr @namei(ptr noundef %4) #7
  %13 = icmp eq ptr %12, null
  br i1 %13, label %39, label %14

14:                                               ; preds = %11
  tail call void @ilock(ptr noundef nonnull %12) #7
  %15 = getelementptr inbounds nuw i8, ptr %12, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !39
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %18, label %19

18:                                               ; preds = %14
  tail call void @iunlockput(ptr noundef nonnull %12) #7
  br label %39

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i8, ptr %12, i32 26
  %21 = load i16, ptr %20, align 2, !tbaa !52
  %22 = add i16 %21, 1
  store i16 %22, ptr %20, align 2, !tbaa !52
  tail call void @iupdate(ptr noundef nonnull %12) #7
  tail call void @iunlock(ptr noundef nonnull %12) #7
  %23 = call ptr @nameiparent(ptr noundef %8, ptr noundef nonnull %3) #7
  %24 = icmp eq ptr %23, null
  br i1 %24, label %36, label %25

25:                                               ; preds = %19
  call void @ilock(ptr noundef nonnull %23) #7
  %26 = load i32, ptr %23, align 4, !tbaa !42
  %27 = load i32, ptr %12, align 4, !tbaa !42
  %28 = icmp eq i32 %26, %27
  br i1 %28, label %29, label %35

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %12, i32 4
  %31 = load i32, ptr %30, align 4, !tbaa !43
  %32 = call i32 @dirlink(ptr noundef nonnull %23, ptr noundef nonnull %3, i32 noundef %31) #7
  %33 = icmp sgt i32 %32, -1
  br i1 %33, label %34, label %35

34:                                               ; preds = %29
  call void @iunlockput(ptr noundef nonnull %23) #7
  call void @iput(ptr noundef nonnull %12) #7
  br label %39

35:                                               ; preds = %29, %25
  call void @iunlockput(ptr noundef nonnull %23) #7
  br label %36

36:                                               ; preds = %35, %19
  call void @ilock(ptr noundef nonnull %12) #7
  %37 = load i16, ptr %20, align 2, !tbaa !52
  %38 = add i16 %37, -1
  store i16 %38, ptr %20, align 2, !tbaa !52
  call void @iupdate(ptr noundef nonnull %12) #7
  call void @iunlockput(ptr noundef nonnull %12) #7
  br label %39

39:                                               ; preds = %34, %36, %11, %18
  %40 = phi i32 [ -1, %18 ], [ -1, %11 ], [ 0, %34 ], [ -1, %36 ]
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %3) #10
  br label %41

41:                                               ; preds = %2, %7, %39
  %42 = phi i32 [ %40, %39 ], [ -1, %7 ], [ -1, %2 ]
  ret i32 %42
}

; Function Attrs: minsize optsize
declare dso_local void @iupdate(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @nameiparent(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @dirlink(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_unlink(i32 noundef %0) local_unnamed_addr #1 {
  %2 = alloca %struct.dirent, align 2
  %3 = alloca %struct.dirent, align 2
  %4 = alloca [62 x i8], align 1
  %5 = alloca i32, align 4
  %6 = inttoptr i32 %0 to ptr
  %7 = tail call fastcc i32 @fat_writepath(ptr noundef %6) #9
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %69

9:                                                ; preds = %1
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %3) #10
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %4) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #10
  %10 = call ptr @nameiparent(ptr noundef %6, ptr noundef nonnull %4) #7
  %11 = icmp eq ptr %10, null
  br i1 %11, label %67, label %12

12:                                               ; preds = %9
  call void @ilock(ptr noundef nonnull %10) #7
  %13 = call i32 @namecmp(ptr noundef nonnull %4, ptr noundef nonnull @.str.7) #7
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %64, label %15

15:                                               ; preds = %12
  %16 = call i32 @namecmp(ptr noundef nonnull %4, ptr noundef nonnull @.str.8) #7
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %64, label %18

18:                                               ; preds = %15
  %19 = call ptr @dirlookup(ptr noundef nonnull %10, ptr noundef nonnull %4, ptr noundef nonnull %5) #7
  %20 = icmp eq ptr %19, null
  br i1 %20, label %64, label %21

21:                                               ; preds = %18
  call void @ilock(ptr noundef nonnull %19) #7
  %22 = getelementptr inbounds nuw i8, ptr %19, i32 26
  %23 = load i16, ptr %22, align 2, !tbaa !52
  %24 = icmp slt i16 %23, 1
  br i1 %24, label %25, label %26

25:                                               ; preds = %21
  call void @panic(ptr noundef nonnull @.str.9) #8
  unreachable

26:                                               ; preds = %21
  %27 = getelementptr inbounds nuw i8, ptr %19, i32 20
  %28 = load i16, ptr %27, align 4, !tbaa !39
  %29 = icmp eq i16 %28, 1
  br i1 %29, label %30, label %47

30:                                               ; preds = %26
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #10
  %31 = getelementptr inbounds nuw i8, ptr %19, i32 28
  %32 = ptrtoint ptr %2 to i32
  br label %33

33:                                               ; preds = %41, %30
  %34 = phi i32 [ 128, %30 ], [ %44, %41 ]
  %35 = load i32, ptr %31, align 4, !tbaa !55
  %36 = icmp ult i32 %34, %35
  br i1 %36, label %37, label %45

37:                                               ; preds = %33
  %38 = call i32 @readi(ptr noundef nonnull %19, i32 noundef 0, i32 noundef %32, i32 noundef %34, i32 noundef 64) #7
  %39 = icmp eq i32 %38, 64
  br i1 %39, label %41, label %40

40:                                               ; preds = %37
  call void @panic(ptr noundef nonnull @.str.13) #8
  unreachable

41:                                               ; preds = %37
  %42 = load i16, ptr %2, align 2, !tbaa !56
  %43 = icmp eq i16 %42, 0
  %44 = add i32 %34, 64
  br i1 %43, label %33, label %46, !llvm.loop !58

45:                                               ; preds = %33
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #10
  br label %47

46:                                               ; preds = %41
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #10
  call void @iunlockput(ptr noundef nonnull %19) #7
  br label %64

47:                                               ; preds = %45, %26
  %48 = call ptr @memset(ptr noundef nonnull %3, i32 noundef 0, i32 noundef 64) #7
  %49 = ptrtoint ptr %3 to i32
  %50 = load i32, ptr %5, align 4, !tbaa !11
  %51 = call i32 @writei(ptr noundef nonnull %10, i32 noundef 0, i32 noundef %49, i32 noundef %50, i32 noundef 64) #7
  %52 = icmp eq i32 %51, 64
  br i1 %52, label %54, label %53

53:                                               ; preds = %47
  call void @panic(ptr noundef nonnull @.str.10) #8
  unreachable

54:                                               ; preds = %47
  %55 = load i16, ptr %27, align 4, !tbaa !39
  %56 = icmp eq i16 %55, 1
  br i1 %56, label %57, label %61

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %10, i32 26
  %59 = load i16, ptr %58, align 2, !tbaa !52
  %60 = add i16 %59, -1
  store i16 %60, ptr %58, align 2, !tbaa !52
  call void @iupdate(ptr noundef nonnull %10) #7
  br label %61

61:                                               ; preds = %57, %54
  call void @iunlockput(ptr noundef nonnull %10) #7
  %62 = load i16, ptr %22, align 2, !tbaa !52
  %63 = add i16 %62, -1
  store i16 %63, ptr %22, align 2, !tbaa !52
  call void @iupdate(ptr noundef nonnull %19) #7
  br label %64

64:                                               ; preds = %46, %15, %12, %18, %61
  %65 = phi ptr [ %19, %61 ], [ %10, %18 ], [ %10, %12 ], [ %10, %15 ], [ %10, %46 ]
  %66 = phi i32 [ 0, %61 ], [ -1, %18 ], [ -1, %12 ], [ -1, %15 ], [ -1, %46 ]
  call void @iunlockput(ptr noundef nonnull %65) #7
  br label %67

67:                                               ; preds = %64, %9
  %68 = phi i32 [ -1, %9 ], [ %66, %64 ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #10
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %4) #10
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %3) #10
  br label %69

69:                                               ; preds = %1, %67
  %70 = phi i32 [ %68, %67 ], [ -1, %1 ]
  ret i32 %70
}

; Function Attrs: minsize optsize
declare dso_local i32 @namecmp(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @dirlookup(ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kfs_iopen(ptr noundef %0) local_unnamed_addr #1 {
  %2 = alloca [64 x i8], align 1
  %3 = load i32, ptr @curr, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #10
  store i8 47, ptr %2, align 1, !tbaa !3
  %4 = getelementptr i8, ptr %0, i32 -1
  br label %5

5:                                                ; preds = %13, %1
  %6 = phi i32 [ 1, %1 ], [ %14, %13 ]
  %7 = getelementptr i8, ptr %4, i32 %6
  %8 = load i8, ptr %7, align 1, !tbaa !3
  %9 = icmp ne i8 %8, 0
  %10 = icmp samesign ult i32 %6, 63
  %11 = select i1 %9, i1 %10, i1 false
  %12 = getelementptr inbounds nuw [64 x i8], ptr %2, i32 0, i32 %6
  br i1 %11, label %13, label %15

13:                                               ; preds = %5
  store i8 %8, ptr %12, align 1, !tbaa !3
  %14 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !59

15:                                               ; preds = %5
  store i8 0, ptr %12, align 1, !tbaa !3
  %16 = load i8, ptr %0, align 1, !tbaa !3
  %17 = icmp eq i8 %16, 47
  br i1 %17, label %25, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %3, i32 2
  %20 = load ptr, ptr %19, align 4, !tbaa !21
  %21 = icmp eq ptr %20, null
  br i1 %21, label %28, label %22

22:                                               ; preds = %18
  %23 = tail call i32 @fat_is(ptr noundef nonnull %20) #7
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %25, label %28

25:                                               ; preds = %15, %22
  %26 = tail call ptr @namei(ptr noundef nonnull %0) #7
  %27 = icmp eq ptr %26, null
  br i1 %27, label %28, label %34

28:                                               ; preds = %18, %22, %25
  %29 = load i8, ptr %0, align 1, !tbaa !3
  %30 = icmp eq i8 %29, 47
  br i1 %30, label %42, label %31

31:                                               ; preds = %28
  %32 = call ptr @namei(ptr noundef nonnull %2) #7
  %33 = icmp eq ptr %32, null
  br i1 %33, label %42, label %34

34:                                               ; preds = %25, %31
  %35 = phi ptr [ %32, %31 ], [ %26, %25 ]
  call void @ilock(ptr noundef nonnull %35) #7
  %36 = getelementptr inbounds nuw i8, ptr %35, i32 20
  %37 = load i16, ptr %36, align 4, !tbaa !39
  %38 = icmp eq i16 %37, 2
  br i1 %38, label %40, label %39

39:                                               ; preds = %34
  call void @iunlockput(ptr noundef nonnull %35) #7
  br label %42

40:                                               ; preds = %34
  %41 = ptrtoint ptr %35 to i32
  br label %42

42:                                               ; preds = %28, %31, %40, %39
  %43 = phi i32 [ 0, %39 ], [ %41, %40 ], [ 0, %31 ], [ 0, %28 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #10
  ret i32 %43
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_iread(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %0 to ptr
  %6 = tail call i32 @readi(ptr noundef %5, i32 noundef 0, i32 noundef %2, i32 noundef %1, i32 noundef %3) #7
  ret i32 %6
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_iclose(i32 noundef %0) local_unnamed_addr #1 {
  %2 = inttoptr i32 %0 to ptr
  tail call void @iunlockput(ptr noundef %2) #7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kconsread(i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @ialloc(i32 noundef, i16 noundef signext) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fat_dup(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @fat_lookup(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @fat_root() local_unnamed_addr #3

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin noreturn optsize "no-builtins" }
attributes #9 = { minsize nobuiltin optsize "no-builtins" }
attributes #10 = { nounwind }

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
!9 = distinct !{!9, !7, !8}
!10 = distinct !{!10, !8}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !4, i64 0}
!13 = !{!14, !15, i64 0}
!14 = !{!"devsw", !15, i64 0, !15, i64 4}
!15 = !{!"any pointer", !4, i64 0}
!16 = !{!14, !15, i64 4}
!17 = !{!18, !19, i64 4}
!18 = !{!"proc", !12, i64 0, !19, i64 4, !20, i64 8, !4, i64 12}
!19 = !{!"long", !4, i64 0}
!20 = !{!"p1 _ZTS5inode", !15, i64 0}
!21 = !{!18, !20, i64 8}
!22 = distinct !{!22, !7, !8}
!23 = !{!24, !12, i64 0}
!24 = !{!"file", !12, i64 0, !12, i64 4, !4, i64 8, !4, i64 9, !25, i64 12, !20, i64 16, !12, i64 20, !26, i64 24}
!25 = !{!"p1 _ZTS4pipe", !15, i64 0}
!26 = !{!"short", !4, i64 0}
!27 = !{!24, !26, i64 24}
!28 = !{!24, !4, i64 8}
!29 = !{!24, !4, i64 9}
!30 = !{!24, !20, i64 16}
!31 = !{!32, !32, i64 0}
!32 = !{!"p1 _ZTS4file", !15, i64 0}
!33 = distinct !{!33, !7, !8}
!34 = distinct !{!34, !7, !8}
!35 = distinct !{!35, !7, !8}
!36 = distinct !{!36, !7, !8}
!37 = distinct !{!37, !7, !8}
!38 = distinct !{!38, !7, !8}
!39 = !{!40, !26, i64 20}
!40 = !{!"inode", !12, i64 0, !12, i64 4, !12, i64 8, !41, i64 12, !12, i64 16, !26, i64 20, !26, i64 22, !26, i64 24, !26, i64 26, !12, i64 28, !4, i64 32}
!41 = !{!"sleeplock", !4, i64 0}
!42 = !{!40, !12, i64 0}
!43 = !{!40, !12, i64 4}
!44 = distinct !{!44, !7, !8}
!45 = distinct !{!45, !7, !8}
!46 = distinct !{!46, !7, !8}
!47 = distinct !{!47, !7, !8}
!48 = !{!24, !12, i64 20}
!49 = !{!40, !26, i64 22}
!50 = distinct !{!50, !7, !8}
!51 = !{!40, !26, i64 24}
!52 = !{!40, !26, i64 26}
!53 = distinct !{!53, !7, !8}
!54 = distinct !{!54, !7, !8}
!55 = !{!40, !12, i64 28}
!56 = !{!57, !26, i64 0}
!57 = !{!"dirent", !26, i64 0, !4, i64 2}
!58 = distinct !{!58, !7, !8}
!59 = distinct !{!59, !7, !8}
