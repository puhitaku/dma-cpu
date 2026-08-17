; ModuleID = 'kfsglue.c'
source_filename = "kfsglue.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, ptr, [16 x ptr] }
%struct.devsw = type { ptr, ptr }
%struct.dirent = type { i16, [14 x i8] }

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
  tail call void @kconswrite(ptr noundef nonnull %0, i32 noundef %3) #8
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
  tail call void @kconswrite(ptr noundef nonnull @.str, i32 noundef 7) #8
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  %7 = add nuw nsw i32 %3, 1
  br i1 %6, label %8, label %2, !llvm.loop !9

8:                                                ; preds = %2
  tail call void @kconswrite(ptr noundef nonnull %0, i32 noundef %3) #8
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 1) #8
  br label %9

9:                                                ; preds = %9, %8
  br label %9, !llvm.loop !10
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @either_copyout(i32 noundef %0, i32 noundef %1, ptr noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %1 to ptr
  %6 = tail call ptr @memmove(ptr noundef %5, ptr noundef %2, i32 noundef %3) #8
  ret i32 0
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @either_copyin(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %2 to ptr
  %6 = tail call ptr @memmove(ptr noundef %0, ptr noundef %5, i32 noundef %3) #8
  ret i32 0
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @copyout(i32 noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = inttoptr i32 %2 to ptr
  %7 = tail call ptr @memmove(ptr noundef %6, ptr noundef %3, i32 noundef %4) #8
  ret i32 0
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @copyin(i32 noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %2 to ptr
  %6 = tail call ptr @memmove(ptr noundef %1, ptr noundef %5, i32 noundef %3) #8
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
  tail call void @fsinit(i32 noundef 1) #8
  tail call void @fileinit() #8
  store ptr @consoleread, ptr getelementptr inbounds nuw (i8, ptr @devsw, i32 8), align 4, !tbaa !13
  store ptr @consolewrite, ptr getelementptr inbounds nuw (i8, ptr @devsw, i32 12), align 4, !tbaa !16
  %1 = tail call ptr @namei(ptr noundef nonnull @.str.2) #8
  %2 = icmp eq ptr %1, null
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call void @panic(ptr noundef nonnull @.str.3) #9
  unreachable

4:                                                ; preds = %0, %17
  %5 = phi i32 [ %18, %17 ], [ 0, %0 ]
  %6 = icmp eq i32 %5, 8
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  tail call void @iput(ptr noundef nonnull %1) #8
  store i32 1, ptr @fsready, align 4, !tbaa !11
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %5
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 4
  store i32 -1, ptr %10, align 4, !tbaa !17
  %11 = tail call ptr @namei(ptr noundef nonnull @.str.4) #8
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
  %20 = tail call ptr @filealloc() #8
  store i32 3, ptr %20, align 4, !tbaa !23
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 24
  store i16 1, ptr %21, align 4, !tbaa !27
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 8
  store i8 1, ptr %22, align 4, !tbaa !28
  %23 = getelementptr inbounds nuw i8, ptr %20, i32 9
  store i8 1, ptr %23, align 1, !tbaa !29
  %24 = tail call ptr @idup(ptr noundef nonnull %1) #8
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
  %4 = tail call i32 @kconsread(i32 noundef %1, i32 noundef %2) #8
  ret i32 %4
}

; Function Attrs: minsize nounwind optsize
define internal noundef i32 @consolewrite(i32 %0, i32 noundef %1, i32 noundef returned %2) #1 {
  %4 = inttoptr i32 %1 to ptr
  tail call void @kconswrite(ptr noundef %4, i32 noundef %2) #8
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
  %22 = tail call ptr @filedup(ptr noundef nonnull %19) #8
  br label %23

23:                                               ; preds = %17, %21
  %24 = phi ptr [ %22, %21 ], [ null, %17 ]
  %25 = getelementptr inbounds nuw [16 x ptr], ptr %9, i32 0, i32 %11
  store ptr %24, ptr %25, align 4, !tbaa !31
  %26 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !34

27:                                               ; preds = %13
  %28 = tail call ptr @idup(ptr noundef nonnull %15) #8
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
  tail call void @fileclose(ptr noundef nonnull %13) #8
  store ptr null, ptr %12, align 4, !tbaa !31
  br label %16

16:                                               ; preds = %11, %15
  %17 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !35

18:                                               ; preds = %7
  tail call void @vfs_iput(ptr noundef nonnull %9) #10
  store ptr null, ptr %8, align 4, !tbaa !21
  br label %19

19:                                               ; preds = %18, %7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @fileclose(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_iput(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #8
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %1
  tail call void @fat_put(ptr noundef %0) #8
  br label %6

5:                                                ; preds = %1
  tail call void @iput(ptr noundef %0) #8
  br label %6

6:                                                ; preds = %5, %4
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vfs_readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = tail call i32 @fat_is(ptr noundef %0) #8
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %5
  %9 = tail call i32 @fat_readi(ptr noundef %0, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
  br label %12

10:                                               ; preds = %5
  %11 = tail call i32 @readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
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
  %6 = tail call i32 @fat_is(ptr noundef %0) #8
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %5
  %9 = tail call i32 @writei(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
  br label %10

10:                                               ; preds = %5, %8
  %11 = phi i32 [ %9, %8 ], [ -1, %5 ]
  ret i32 %11
}

; Function Attrs: minsize optsize
declare dso_local i32 @writei(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_ilock(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #8
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  tail call void @ilock(ptr noundef %0) #8
  br label %5

5:                                                ; preds = %4, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @ilock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_iunlock(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #8
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  tail call void @iunlock(ptr noundef %0) #8
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
  %3 = tail call i32 @fat_is(ptr noundef %0) #8
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %6, label %5

5:                                                ; preds = %2
  tail call void @fat_stati(ptr noundef %0, ptr noundef %1) #8
  br label %7

6:                                                ; preds = %2
  tail call void @stati(ptr noundef %0, ptr noundef %1) #8
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
  br label %108

40:                                               ; preds = %2
  %41 = inttoptr i32 %0 to ptr
  %42 = inttoptr i32 %1 to ptr
  %43 = load i32, ptr @fatvol, align 4, !tbaa !11
  %44 = icmp ne i32 %43, 0
  %45 = load i8, ptr @fatmnt, align 1
  %46 = icmp eq i8 %45, 0
  %47 = select i1 %44, i1 %46, i1 false
  br i1 %47, label %48, label %108

48:                                               ; preds = %40
  %49 = load i8, ptr %41, align 1, !tbaa !3
  %50 = icmp eq i8 %49, 102
  br i1 %50, label %51, label %108

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw i8, ptr %41, i32 1
  %53 = load i8, ptr %52, align 1, !tbaa !3
  %54 = icmp eq i8 %53, 97
  br i1 %54, label %55, label %108

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %41, i32 2
  %57 = load i8, ptr %56, align 1, !tbaa !3
  %58 = icmp eq i8 %57, 116
  br i1 %58, label %59, label %108

59:                                               ; preds = %55
  %60 = getelementptr inbounds nuw i8, ptr %41, i32 3
  %61 = load i8, ptr %60, align 1, !tbaa !3
  %62 = icmp eq i8 %61, 48
  br i1 %62, label %63, label %108

63:                                               ; preds = %59
  %64 = getelementptr inbounds nuw i8, ptr %41, i32 4
  %65 = load i8, ptr %64, align 1, !tbaa !3
  %66 = icmp eq i8 %65, 0
  br i1 %66, label %67, label %108

67:                                               ; preds = %63
  %68 = load i8, ptr %42, align 1, !tbaa !3
  %69 = icmp eq i8 %68, 47
  br i1 %69, label %70, label %108

70:                                               ; preds = %67
  %71 = getelementptr inbounds nuw i8, ptr %42, i32 1
  %72 = load i8, ptr %71, align 1, !tbaa !3
  %73 = icmp eq i8 %72, 0
  br i1 %73, label %108, label %74

74:                                               ; preds = %70
  %75 = tail call ptr @namei(ptr noundef nonnull %42) #8
  %76 = icmp eq ptr %75, null
  br i1 %76, label %108, label %77

77:                                               ; preds = %74
  tail call void @ilock(ptr noundef nonnull %75) #8
  %78 = getelementptr inbounds nuw i8, ptr %75, i32 20
  %79 = load i16, ptr %78, align 4, !tbaa !39
  %80 = icmp eq i16 %79, 1
  tail call void @iunlockput(ptr noundef nonnull %75) #8
  br i1 %80, label %81, label %108

81:                                               ; preds = %77
  %82 = load i32, ptr @fatvol, align 4, !tbaa !11
  %83 = tail call i32 @fat_mount(i32 noundef %82) #8
  %84 = icmp slt i32 %83, 0
  br i1 %84, label %108, label %85

85:                                               ; preds = %81, %95
  %86 = phi i32 [ %97, %95 ], [ 0, %81 ]
  %87 = getelementptr inbounds nuw i8, ptr %42, i32 %86
  %88 = load i8, ptr %87, align 1, !tbaa !3
  %89 = icmp eq i8 %88, 0
  br i1 %89, label %90, label %91

90:                                               ; preds = %91, %85
  br label %98

91:                                               ; preds = %85
  %92 = icmp ne i8 %88, 32
  %93 = icmp samesign ult i32 %86, 26
  %94 = select i1 %92, i1 %93, i1 false
  br i1 %94, label %95, label %90

95:                                               ; preds = %91
  %96 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %86
  store i8 %88, ptr %96, align 1, !tbaa !3
  %97 = add nuw nsw i32 %86, 1
  br label %85, !llvm.loop !42

98:                                               ; preds = %90, %101
  %99 = phi i32 [ %102, %101 ], [ %86, %90 ]
  %100 = icmp sgt i32 %99, 1
  br i1 %100, label %101, label %106

101:                                              ; preds = %98
  %102 = add nsw i32 %99, -1
  %103 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %102
  %104 = load i8, ptr %103, align 1, !tbaa !3
  %105 = icmp eq i8 %104, 47
  br i1 %105, label %98, label %106, !llvm.loop !43

106:                                              ; preds = %98, %101
  %107 = getelementptr inbounds [28 x i8], ptr @fatmnt, i32 0, i32 %99
  store i8 0, ptr %107, align 1, !tbaa !3
  br label %108

108:                                              ; preds = %40, %63, %59, %55, %51, %48, %70, %67, %106, %77, %81, %74, %37
  %109 = phi i32 [ %38, %37 ], [ -1, %40 ], [ -1, %63 ], [ -1, %59 ], [ -1, %55 ], [ -1, %51 ], [ -1, %48 ], [ -1, %70 ], [ -1, %67 ], [ -1, %74 ], [ 0, %106 ], [ -1, %77 ], [ -1, %81 ]
  ret i32 %109
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
  br label %5, !llvm.loop !44

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
  %24 = tail call i32 @fat_busy() #8
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %23
  tail call void @fat_unmount() #8
  store i8 0, ptr @fatmnt, align 1, !tbaa !3
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
  %13 = tail call i32 @fileread(ptr noundef nonnull %10, i32 noundef %1, i32 noundef %2) #8
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
  %13 = tail call i32 @filewrite(ptr noundef nonnull %10, i32 noundef %1, i32 noundef %2) #8
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
  tail call void @fileclose(ptr noundef nonnull %8) #8
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
  %11 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %8) #10
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %15, label %13

13:                                               ; preds = %10
  %14 = tail call ptr @filedup(ptr noundef nonnull %8) #8
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
  br label %3, !llvm.loop !45

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
  %12 = tail call i32 @filestat(ptr noundef nonnull %9, i32 noundef %1) #8
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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #11
  %4 = call i32 @pipealloc(ptr noundef nonnull %2, ptr noundef nonnull %3) #8
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %23, label %6

6:                                                ; preds = %1
  %7 = load ptr, ptr %2, align 4, !tbaa !31
  %8 = call fastcc i32 @fdalloc(ptr noundef %7) #10
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %10, label %17

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 4, !tbaa !31
  %12 = call fastcc i32 @fdalloc(ptr noundef %11) #10
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %20

14:                                               ; preds = %10
  %15 = load i32, ptr @curr, align 4, !tbaa !11
  %16 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %15, i32 3, i32 %8
  store ptr null, ptr %16, align 4, !tbaa !31
  br label %17

17:                                               ; preds = %6, %14
  %18 = load ptr, ptr %2, align 4, !tbaa !31
  call void @fileclose(ptr noundef %18) #8
  %19 = load ptr, ptr %3, align 4, !tbaa !31
  call void @fileclose(ptr noundef %19) #8
  br label %23

20:                                               ; preds = %10
  %21 = inttoptr i32 %0 to ptr
  store i32 %8, ptr %21, align 4, !tbaa !11
  %22 = getelementptr inbounds nuw i8, ptr %21, i32 4
  store i32 %12, ptr %22, align 4, !tbaa !11
  br label %23

23:                                               ; preds = %17, %20, %1
  %24 = phi i32 [ -1, %1 ], [ -1, %17 ], [ 0, %20 ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #11
  ret i32 %24
}

; Function Attrs: minsize optsize
declare dso_local i32 @pipealloc(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 16) i32 @kfs_open(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = inttoptr i32 %0 to ptr
  %4 = and i32 %1, 512
  %5 = icmp eq i32 %4, 0
  %6 = tail call fastcc i32 @fat_writepath(ptr noundef %3) #10
  br i1 %5, label %12, label %7

7:                                                ; preds = %2
  %8 = icmp eq i32 %6, 0
  br i1 %8, label %9, label %77

9:                                                ; preds = %7
  %10 = tail call fastcc ptr @create(ptr noundef %3, i16 noundef signext 2) #10
  %11 = icmp eq ptr %10, null
  br i1 %11, label %77, label %41

12:                                               ; preds = %2
  %13 = icmp ne i32 %6, 0
  %14 = icmp ne i32 %1, 0
  %15 = and i1 %14, %13
  br i1 %15, label %77, label %16

16:                                               ; preds = %12
  %17 = tail call fastcc ptr @vfs_resolve(ptr noundef %3) #10
  %18 = icmp eq ptr %17, null
  br i1 %18, label %77, label %19

19:                                               ; preds = %16
  %20 = tail call i32 @fat_is(ptr noundef nonnull %17) #8
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %35, label %22

22:                                               ; preds = %19
  %23 = tail call ptr @filealloc() #8
  %24 = icmp eq ptr %23, null
  br i1 %24, label %29, label %25

25:                                               ; preds = %22
  %26 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %23) #10
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %30

28:                                               ; preds = %25
  tail call void @fileclose(ptr noundef nonnull %23) #8
  br label %29

29:                                               ; preds = %22, %28
  tail call void @fat_put(ptr noundef nonnull %17) #8
  br label %77

30:                                               ; preds = %25
  store i32 2, ptr %23, align 4, !tbaa !23
  %31 = getelementptr inbounds nuw i8, ptr %23, i32 20
  store i32 0, ptr %31, align 4, !tbaa !46
  %32 = getelementptr inbounds nuw i8, ptr %23, i32 16
  store ptr %17, ptr %32, align 4, !tbaa !30
  %33 = getelementptr inbounds nuw i8, ptr %23, i32 8
  store i8 1, ptr %33, align 4, !tbaa !28
  %34 = getelementptr inbounds nuw i8, ptr %23, i32 9
  store i8 0, ptr %34, align 1, !tbaa !29
  br label %77

35:                                               ; preds = %19
  tail call void @ilock(ptr noundef nonnull %17) #8
  %36 = getelementptr inbounds nuw i8, ptr %17, i32 20
  %37 = load i16, ptr %36, align 4, !tbaa !39
  %38 = icmp eq i16 %37, 1
  %39 = and i1 %14, %38
  br i1 %39, label %40, label %41

40:                                               ; preds = %35
  tail call void @iunlockput(ptr noundef nonnull %17) #8
  br label %77

41:                                               ; preds = %35, %9
  %42 = phi ptr [ %10, %9 ], [ %17, %35 ]
  %43 = tail call ptr @filealloc() #8
  %44 = icmp eq ptr %43, null
  br i1 %44, label %49, label %45

45:                                               ; preds = %41
  %46 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %43) #10
  %47 = icmp slt i32 %46, 0
  br i1 %47, label %48, label %50

48:                                               ; preds = %45
  tail call void @fileclose(ptr noundef nonnull %43) #8
  br label %49

49:                                               ; preds = %41, %48
  tail call void @iunlockput(ptr noundef nonnull %42) #8
  br label %77

50:                                               ; preds = %45
  %51 = getelementptr inbounds nuw i8, ptr %42, i32 20
  %52 = load i16, ptr %51, align 4, !tbaa !39
  %53 = icmp eq i16 %52, 3
  br i1 %53, label %54, label %58

54:                                               ; preds = %50
  %55 = getelementptr inbounds nuw i8, ptr %42, i32 22
  %56 = load i16, ptr %55, align 2, !tbaa !47
  %57 = getelementptr inbounds nuw i8, ptr %43, i32 24
  store i16 %56, ptr %57, align 4, !tbaa !27
  br label %60

58:                                               ; preds = %50
  %59 = getelementptr inbounds nuw i8, ptr %43, i32 20
  store i32 0, ptr %59, align 4, !tbaa !46
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
  tail call void @itrunc(ptr noundef nonnull %42) #8
  br label %76

76:                                               ; preds = %75, %60
  tail call void @iunlock(ptr noundef nonnull %42) #8
  br label %77

77:                                               ; preds = %49, %76, %29, %30, %16, %12, %9, %7, %40
  %78 = phi i32 [ -1, %40 ], [ -1, %7 ], [ -1, %9 ], [ -1, %12 ], [ -1, %16 ], [ -1, %29 ], [ %26, %30 ], [ -1, %49 ], [ %46, %76 ]
  ret i32 %78
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @fat_writepath(ptr noundef readonly captures(address) %0) unnamed_addr #1 {
  %2 = tail call fastcc ptr @fat_prefix(ptr noundef %0) #10
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %16

4:                                                ; preds = %1
  %5 = load i8, ptr %0, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 47
  br i1 %6, label %16, label %7

7:                                                ; preds = %4
  %8 = load i32, ptr @curr, align 4, !tbaa !11
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %8, i32 2
  %10 = load ptr, ptr %9, align 4, !tbaa !21
  %11 = icmp eq ptr %10, null
  br i1 %11, label %16, label %12

12:                                               ; preds = %7
  %13 = tail call i32 @fat_is(ptr noundef nonnull %10) #8
  %14 = icmp ne i32 %13, 0
  %15 = zext i1 %14 to i32
  br label %16

16:                                               ; preds = %4, %7, %12, %1
  %17 = phi i32 [ 1, %1 ], [ 0, %7 ], [ 0, %4 ], [ %15, %12 ]
  ret i32 %17
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @create(ptr noundef %0, i16 noundef signext range(i16 1, 3) %1) unnamed_addr #1 {
  %3 = alloca [14 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 14, ptr nonnull %3) #11
  %4 = call ptr @nameiparent(ptr noundef %0, ptr noundef nonnull %3) #8
  %5 = icmp eq ptr %4, null
  br i1 %5, label %50, label %6

6:                                                ; preds = %2
  call void @ilock(ptr noundef nonnull %4) #8
  %7 = call ptr @dirlookup(ptr noundef nonnull %4, ptr noundef nonnull %3, ptr noundef null) #8
  %8 = icmp eq ptr %7, null
  br i1 %8, label %16, label %9

9:                                                ; preds = %6
  call void @iunlockput(ptr noundef nonnull %4) #8
  call void @ilock(ptr noundef nonnull %7) #8
  %10 = icmp eq i16 %1, 2
  br i1 %10, label %11, label %47

11:                                               ; preds = %9
  %12 = getelementptr inbounds nuw i8, ptr %7, i32 20
  %13 = load i16, ptr %12, align 4, !tbaa !39
  %14 = and i16 %13, -2
  %15 = icmp eq i16 %14, 2
  br i1 %15, label %50, label %47

16:                                               ; preds = %6
  %17 = load i32, ptr %4, align 4, !tbaa !48
  %18 = call ptr @ialloc(i32 noundef %17, i16 noundef signext %1) #8
  %19 = icmp eq ptr %18, null
  br i1 %19, label %47, label %20

20:                                               ; preds = %16
  call void @ilock(ptr noundef nonnull %18) #8
  %21 = getelementptr inbounds nuw i8, ptr %18, i32 22
  store i16 0, ptr %21, align 2, !tbaa !47
  %22 = getelementptr inbounds nuw i8, ptr %18, i32 24
  store i16 0, ptr %22, align 4, !tbaa !49
  %23 = getelementptr inbounds nuw i8, ptr %18, i32 26
  store i16 1, ptr %23, align 2, !tbaa !50
  call void @iupdate(ptr noundef nonnull %18) #8
  %24 = icmp eq i16 %1, 1
  br i1 %24, label %25, label %36

25:                                               ; preds = %20
  %26 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %27 = load i32, ptr %26, align 4, !tbaa !51
  %28 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.7, i32 noundef %27) #8
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %35, label %30

30:                                               ; preds = %25
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %32 = load i32, ptr %31, align 4, !tbaa !51
  %33 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.8, i32 noundef %32) #8
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %35, label %36

35:                                               ; preds = %30, %25
  call void @panic(ptr noundef nonnull @.str.11) #9
  unreachable

36:                                               ; preds = %30, %20
  %37 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %38 = load i32, ptr %37, align 4, !tbaa !51
  %39 = call i32 @dirlink(ptr noundef nonnull %4, ptr noundef nonnull %3, i32 noundef %38) #8
  %40 = icmp slt i32 %39, 0
  br i1 %40, label %41, label %42

41:                                               ; preds = %36
  call void @panic(ptr noundef nonnull @.str.12) #9
  unreachable

42:                                               ; preds = %36
  br i1 %24, label %43, label %47

43:                                               ; preds = %42
  %44 = getelementptr inbounds nuw i8, ptr %4, i32 26
  %45 = load i16, ptr %44, align 2, !tbaa !50
  %46 = add i16 %45, 1
  store i16 %46, ptr %44, align 2, !tbaa !50
  call void @iupdate(ptr noundef nonnull %4) #8
  br label %47

47:                                               ; preds = %42, %43, %16, %9, %11
  %48 = phi ptr [ %7, %11 ], [ %7, %9 ], [ %4, %16 ], [ %4, %43 ], [ %4, %42 ]
  %49 = phi ptr [ null, %11 ], [ null, %9 ], [ null, %16 ], [ %18, %43 ], [ %18, %42 ]
  call void @iunlockput(ptr noundef nonnull %48) #8
  br label %50

50:                                               ; preds = %47, %11, %2
  %51 = phi ptr [ null, %2 ], [ %7, %11 ], [ %49, %47 ]
  call void @llvm.lifetime.end.p0(i64 14, ptr nonnull %3) #11
  ret ptr %51
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @vfs_resolve(ptr noundef %0) unnamed_addr #1 {
  %2 = tail call fastcc ptr @fat_prefix(ptr noundef %0) #10
  %3 = icmp eq ptr %2, null
  br i1 %3, label %9, label %4

4:                                                ; preds = %1
  %5 = tail call ptr @fat_root() #8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %25, label %7

7:                                                ; preds = %4
  %8 = tail call ptr @fat_walk(ptr noundef nonnull %5, ptr noundef nonnull %2) #8
  tail call void @fat_put(ptr noundef nonnull %5) #8
  br label %25

9:                                                ; preds = %1
  %10 = load i8, ptr %0, align 1, !tbaa !3
  %11 = icmp eq i8 %10, 47
  br i1 %11, label %23, label %12

12:                                               ; preds = %9
  %13 = load i32, ptr @curr, align 4, !tbaa !11
  %14 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %13, i32 2
  %15 = load ptr, ptr %14, align 4, !tbaa !21
  %16 = icmp eq ptr %15, null
  br i1 %16, label %23, label %17

17:                                               ; preds = %12
  %18 = tail call i32 @fat_is(ptr noundef nonnull %15) #8
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %23, label %20

20:                                               ; preds = %17
  %21 = load ptr, ptr %14, align 4, !tbaa !21
  %22 = tail call ptr @fat_walk(ptr noundef %21, ptr noundef nonnull %0) #8
  br label %25

23:                                               ; preds = %17, %12, %9
  %24 = tail call ptr @namei(ptr noundef nonnull %0) #8
  br label %25

25:                                               ; preds = %20, %23, %7, %4
  %26 = phi ptr [ %8, %7 ], [ null, %4 ], [ %22, %20 ], [ %24, %23 ]
  ret ptr %26
}

; Function Attrs: minsize optsize
declare dso_local void @itrunc(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_chdir(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i32, ptr @curr, align 4, !tbaa !11
  %3 = inttoptr i32 %0 to ptr
  %4 = tail call fastcc ptr @vfs_resolve(ptr noundef %3) #10
  %5 = icmp eq ptr %4, null
  br i1 %5, label %26, label %6

6:                                                ; preds = %1
  %7 = tail call i32 @fat_is(ptr noundef nonnull %4) #8
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %14, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %11 = load i16, ptr %10, align 4, !tbaa !39
  %12 = icmp eq i16 %11, 1
  br i1 %12, label %20, label %13

13:                                               ; preds = %9
  tail call void @fat_put(ptr noundef nonnull %4) #8
  br label %26

14:                                               ; preds = %6
  tail call void @ilock(ptr noundef nonnull %4) #8
  %15 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !39
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %19, label %18

18:                                               ; preds = %14
  tail call void @iunlockput(ptr noundef nonnull %4) #8
  br label %26

19:                                               ; preds = %14
  tail call void @iunlock(ptr noundef nonnull %4) #8
  br label %20

20:                                               ; preds = %9, %19
  %21 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %2, i32 2
  %22 = load ptr, ptr %21, align 4, !tbaa !21
  %23 = icmp eq ptr %22, null
  br i1 %23, label %25, label %24

24:                                               ; preds = %20
  tail call void @vfs_iput(ptr noundef nonnull %22) #10
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
  %3 = tail call fastcc i32 @fat_writepath(ptr noundef %2) #10
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %9

5:                                                ; preds = %1
  %6 = tail call fastcc ptr @create(ptr noundef %2, i16 noundef signext 1) #10
  %7 = icmp eq ptr %6, null
  br i1 %7, label %9, label %8

8:                                                ; preds = %5
  tail call void @iunlockput(ptr noundef nonnull %6) #8
  br label %9

9:                                                ; preds = %8, %5, %1
  %10 = phi i32 [ -1, %1 ], [ 0, %8 ], [ -1, %5 ]
  ret i32 %10
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_link(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = alloca [14 x i8], align 1
  %4 = inttoptr i32 %0 to ptr
  %5 = tail call fastcc i32 @fat_writepath(ptr noundef %4) #10
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %41

7:                                                ; preds = %2
  %8 = inttoptr i32 %1 to ptr
  %9 = tail call fastcc i32 @fat_writepath(ptr noundef %8) #10
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %41

11:                                               ; preds = %7
  call void @llvm.lifetime.start.p0(i64 14, ptr nonnull %3) #11
  %12 = tail call ptr @namei(ptr noundef %4) #8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %39, label %14

14:                                               ; preds = %11
  tail call void @ilock(ptr noundef nonnull %12) #8
  %15 = getelementptr inbounds nuw i8, ptr %12, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !39
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %18, label %19

18:                                               ; preds = %14
  tail call void @iunlockput(ptr noundef nonnull %12) #8
  br label %39

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i8, ptr %12, i32 26
  %21 = load i16, ptr %20, align 2, !tbaa !50
  %22 = add i16 %21, 1
  store i16 %22, ptr %20, align 2, !tbaa !50
  tail call void @iupdate(ptr noundef nonnull %12) #8
  tail call void @iunlock(ptr noundef nonnull %12) #8
  %23 = call ptr @nameiparent(ptr noundef %8, ptr noundef nonnull %3) #8
  %24 = icmp eq ptr %23, null
  br i1 %24, label %36, label %25

25:                                               ; preds = %19
  call void @ilock(ptr noundef nonnull %23) #8
  %26 = load i32, ptr %23, align 4, !tbaa !48
  %27 = load i32, ptr %12, align 4, !tbaa !48
  %28 = icmp eq i32 %26, %27
  br i1 %28, label %29, label %35

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %12, i32 4
  %31 = load i32, ptr %30, align 4, !tbaa !51
  %32 = call i32 @dirlink(ptr noundef nonnull %23, ptr noundef nonnull %3, i32 noundef %31) #8
  %33 = icmp sgt i32 %32, -1
  br i1 %33, label %34, label %35

34:                                               ; preds = %29
  call void @iunlockput(ptr noundef nonnull %23) #8
  call void @iput(ptr noundef nonnull %12) #8
  br label %39

35:                                               ; preds = %29, %25
  call void @iunlockput(ptr noundef nonnull %23) #8
  br label %36

36:                                               ; preds = %35, %19
  call void @ilock(ptr noundef nonnull %12) #8
  %37 = load i16, ptr %20, align 2, !tbaa !50
  %38 = add i16 %37, -1
  store i16 %38, ptr %20, align 2, !tbaa !50
  call void @iupdate(ptr noundef nonnull %12) #8
  call void @iunlockput(ptr noundef nonnull %12) #8
  br label %39

39:                                               ; preds = %34, %36, %11, %18
  %40 = phi i32 [ -1, %18 ], [ -1, %11 ], [ 0, %34 ], [ -1, %36 ]
  call void @llvm.lifetime.end.p0(i64 14, ptr nonnull %3) #11
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
  %4 = alloca [14 x i8], align 1
  %5 = alloca i32, align 4
  %6 = inttoptr i32 %0 to ptr
  %7 = tail call fastcc i32 @fat_writepath(ptr noundef %6) #10
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %69

9:                                                ; preds = %1
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #11
  call void @llvm.lifetime.start.p0(i64 14, ptr nonnull %4) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #11
  %10 = call ptr @nameiparent(ptr noundef %6, ptr noundef nonnull %4) #8
  %11 = icmp eq ptr %10, null
  br i1 %11, label %67, label %12

12:                                               ; preds = %9
  call void @ilock(ptr noundef nonnull %10) #8
  %13 = call i32 @namecmp(ptr noundef nonnull %4, ptr noundef nonnull @.str.7) #8
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %64, label %15

15:                                               ; preds = %12
  %16 = call i32 @namecmp(ptr noundef nonnull %4, ptr noundef nonnull @.str.8) #8
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %64, label %18

18:                                               ; preds = %15
  %19 = call ptr @dirlookup(ptr noundef nonnull %10, ptr noundef nonnull %4, ptr noundef nonnull %5) #8
  %20 = icmp eq ptr %19, null
  br i1 %20, label %64, label %21

21:                                               ; preds = %18
  call void @ilock(ptr noundef nonnull %19) #8
  %22 = getelementptr inbounds nuw i8, ptr %19, i32 26
  %23 = load i16, ptr %22, align 2, !tbaa !50
  %24 = icmp slt i16 %23, 1
  br i1 %24, label %25, label %26

25:                                               ; preds = %21
  call void @panic(ptr noundef nonnull @.str.9) #9
  unreachable

26:                                               ; preds = %21
  %27 = getelementptr inbounds nuw i8, ptr %19, i32 20
  %28 = load i16, ptr %27, align 4, !tbaa !39
  %29 = icmp eq i16 %28, 1
  br i1 %29, label %30, label %47

30:                                               ; preds = %26
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #11
  %31 = getelementptr inbounds nuw i8, ptr %19, i32 28
  %32 = ptrtoint ptr %2 to i32
  br label %33

33:                                               ; preds = %41, %30
  %34 = phi i32 [ 32, %30 ], [ %44, %41 ]
  %35 = load i32, ptr %31, align 4, !tbaa !52
  %36 = icmp ult i32 %34, %35
  br i1 %36, label %37, label %45

37:                                               ; preds = %33
  %38 = call i32 @readi(ptr noundef nonnull %19, i32 noundef 0, i32 noundef %32, i32 noundef %34, i32 noundef 16) #8
  %39 = icmp eq i32 %38, 16
  br i1 %39, label %41, label %40

40:                                               ; preds = %37
  call void @panic(ptr noundef nonnull @.str.13) #9
  unreachable

41:                                               ; preds = %37
  %42 = load i16, ptr %2, align 2, !tbaa !53
  %43 = icmp eq i16 %42, 0
  %44 = add i32 %34, 16
  br i1 %43, label %33, label %46, !llvm.loop !55

45:                                               ; preds = %33
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #11
  br label %47

46:                                               ; preds = %41
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #11
  call void @iunlockput(ptr noundef nonnull %19) #8
  br label %64

47:                                               ; preds = %45, %26
  %48 = call ptr @memset(ptr noundef nonnull %3, i32 noundef 0, i32 noundef 16) #8
  %49 = ptrtoint ptr %3 to i32
  %50 = load i32, ptr %5, align 4, !tbaa !11
  %51 = call i32 @writei(ptr noundef nonnull %10, i32 noundef 0, i32 noundef %49, i32 noundef %50, i32 noundef 16) #8
  %52 = icmp eq i32 %51, 16
  br i1 %52, label %54, label %53

53:                                               ; preds = %47
  call void @panic(ptr noundef nonnull @.str.10) #9
  unreachable

54:                                               ; preds = %47
  %55 = load i16, ptr %27, align 4, !tbaa !39
  %56 = icmp eq i16 %55, 1
  br i1 %56, label %57, label %61

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %10, i32 26
  %59 = load i16, ptr %58, align 2, !tbaa !50
  %60 = add i16 %59, -1
  store i16 %60, ptr %58, align 2, !tbaa !50
  call void @iupdate(ptr noundef nonnull %10) #8
  br label %61

61:                                               ; preds = %57, %54
  call void @iunlockput(ptr noundef nonnull %10) #8
  %62 = load i16, ptr %22, align 2, !tbaa !50
  %63 = add i16 %62, -1
  store i16 %63, ptr %22, align 2, !tbaa !50
  call void @iupdate(ptr noundef nonnull %19) #8
  br label %64

64:                                               ; preds = %46, %15, %12, %18, %61
  %65 = phi ptr [ %19, %61 ], [ %10, %18 ], [ %10, %12 ], [ %10, %15 ], [ %10, %46 ]
  %66 = phi i32 [ 0, %61 ], [ -1, %18 ], [ -1, %12 ], [ -1, %15 ], [ -1, %46 ]
  call void @iunlockput(ptr noundef nonnull %65) #8
  br label %67

67:                                               ; preds = %64, %9
  %68 = phi i32 [ -1, %9 ], [ %66, %64 ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #11
  call void @llvm.lifetime.end.p0(i64 14, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #11
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
define dso_local i32 @kfs_iopen(ptr noundef %0) local_unnamed_addr #1 {
  %2 = alloca [64 x i8], align 1
  %3 = load i32, ptr @curr, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #11
  %4 = load i8, ptr %0, align 1, !tbaa !3
  %5 = icmp eq i8 %4, 47
  br i1 %5, label %26, label %6

6:                                                ; preds = %1
  %7 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %3, i32 2
  %8 = load ptr, ptr %7, align 4, !tbaa !21
  %9 = icmp eq ptr %8, null
  br i1 %9, label %26, label %10

10:                                               ; preds = %6
  %11 = tail call i32 @fat_is(ptr noundef nonnull %8) #8
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %26, label %13

13:                                               ; preds = %10
  store i8 47, ptr %2, align 1, !tbaa !3
  %14 = getelementptr i8, ptr %0, i32 -1
  br label %15

15:                                               ; preds = %23, %13
  %16 = phi i32 [ 1, %13 ], [ %24, %23 ]
  %17 = getelementptr i8, ptr %14, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3
  %19 = icmp ne i8 %18, 0
  %20 = icmp samesign ult i32 %16, 63
  %21 = select i1 %19, i1 %20, i1 false
  %22 = getelementptr inbounds nuw [64 x i8], ptr %2, i32 0, i32 %16
  br i1 %21, label %23, label %25

23:                                               ; preds = %15
  store i8 %18, ptr %22, align 1, !tbaa !3
  %24 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !56

25:                                               ; preds = %15
  store i8 0, ptr %22, align 1, !tbaa !3
  br label %26

26:                                               ; preds = %25, %10, %6, %1
  %27 = phi ptr [ %2, %25 ], [ %0, %10 ], [ %0, %6 ], [ %0, %1 ]
  %28 = call ptr @namei(ptr noundef nonnull %27) #8
  %29 = icmp eq ptr %28, null
  br i1 %29, label %37, label %30

30:                                               ; preds = %26
  call void @ilock(ptr noundef nonnull %28) #8
  %31 = getelementptr inbounds nuw i8, ptr %28, i32 20
  %32 = load i16, ptr %31, align 4, !tbaa !39
  %33 = icmp eq i16 %32, 2
  br i1 %33, label %35, label %34

34:                                               ; preds = %30
  call void @iunlockput(ptr noundef nonnull %28) #8
  br label %37

35:                                               ; preds = %30
  %36 = ptrtoint ptr %28 to i32
  br label %37

37:                                               ; preds = %26, %35, %34
  %38 = phi i32 [ 0, %34 ], [ %36, %35 ], [ 0, %26 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #11
  ret i32 %38
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_iread(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %0 to ptr
  %6 = tail call i32 @readi(ptr noundef %5, i32 noundef 0, i32 noundef %2, i32 noundef %1, i32 noundef %3) #8
  ret i32 %6
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_iclose(i32 noundef %0) local_unnamed_addr #1 {
  %2 = inttoptr i32 %0 to ptr
  tail call void @iunlockput(ptr noundef %2) #8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kconsread(i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @fat_prefix(ptr noundef readonly captures(ret: address, provenance) %0) unnamed_addr #7 {
  %2 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %3 = icmp eq i8 %2, 0
  br i1 %3, label %24, label %4

4:                                                ; preds = %1
  %5 = load i8, ptr %0, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 47
  br i1 %6, label %7, label %24

7:                                                ; preds = %4, %15
  %8 = phi i8 [ %18, %15 ], [ %2, %4 ]
  %9 = phi i32 [ %16, %15 ], [ 0, %4 ]
  %10 = icmp eq i8 %8, 0
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 %9
  %12 = load i8, ptr %11, align 1, !tbaa !3
  br i1 %10, label %19, label %13

13:                                               ; preds = %7
  %14 = icmp eq i8 %12, %8
  br i1 %14, label %15, label %24

15:                                               ; preds = %13
  %16 = add nuw nsw i32 %9, 1
  %17 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3
  br label %7, !llvm.loop !57

19:                                               ; preds = %7
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 %9
  switch i8 %12, label %23 [
    i8 0, label %24
    i8 47, label %21
  ]

21:                                               ; preds = %19
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 1
  br label %24

23:                                               ; preds = %19
  br label %24

24:                                               ; preds = %13, %21, %23, %19, %1, %4
  %25 = phi ptr [ null, %4 ], [ null, %1 ], [ %22, %21 ], [ null, %23 ], [ %20, %19 ], [ null, %13 ]
  ret ptr %25
}

; Function Attrs: minsize optsize
declare dso_local ptr @ialloc(i32 noundef, i16 noundef signext) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @fat_root() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @fat_walk(ptr noundef, ptr noundef) local_unnamed_addr #3

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #9 = { minsize nobuiltin noreturn optsize "no-builtins" }
attributes #10 = { minsize nobuiltin optsize "no-builtins" }
attributes #11 = { nounwind }

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
!42 = distinct !{!42, !7, !8}
!43 = distinct !{!43, !7, !8}
!44 = distinct !{!44, !7, !8}
!45 = distinct !{!45, !7, !8}
!46 = !{!24, !12, i64 20}
!47 = !{!40, !26, i64 22}
!48 = !{!40, !12, i64 0}
!49 = !{!40, !26, i64 24}
!50 = !{!40, !26, i64 26}
!51 = !{!40, !12, i64 4}
!52 = !{!40, !12, i64 28}
!53 = !{!54, !26, i64 0}
!54 = !{!"dirent", !26, i64 0, !4, i64 2}
!55 = distinct !{!55, !7, !8}
!56 = distinct !{!56, !7, !8}
!57 = distinct !{!57, !7, !8}
