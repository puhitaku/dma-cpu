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
@.str.4 = private unnamed_addr constant [5 x i8] c"/dev\00", align 1
@devmnt_dev = internal unnamed_addr global i32 -1, align 4
@devmnt_inum = internal unnamed_addr global i32 0, align 4
@devmnt = internal unnamed_addr global [8 x i8] zeroinitializer, align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@fsready = dso_local local_unnamed_addr global i32 0, align 4
@fatmnt = internal unnamed_addr global [28 x i8] zeroinitializer, align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"sd0 on \00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"fat0 on \00", align 1
@.str.8 = private unnamed_addr constant [17 x i8] c" type vfat (ro)\0A\00", align 1
@.str.9 = private unnamed_addr constant [31 x i8] c"devfs on /dev type devfs (ro)\0A\00", align 1
@fatvol = dso_local local_unnamed_addr global i32 0, align 4
@fatmnt_dev = internal unnamed_addr global i32 -1, align 4
@fatmnt_inum = internal unnamed_addr global i32 0, align 4
@.str.10 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c"..\00", align 1
@.str.12 = private unnamed_addr constant [18 x i8] c"unlink: nlink < 1\00", align 1
@.str.13 = private unnamed_addr constant [15 x i8] c"unlink: writei\00", align 1
@.str.14 = private unnamed_addr constant [12 x i8] c"create dots\00", align 1
@.str.15 = private unnamed_addr constant [16 x i8] c"create: dirlink\00", align 1
@.str.16 = private unnamed_addr constant [18 x i8] c"isdirempty: readi\00", align 1

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

4:                                                ; preds = %0
  %5 = tail call ptr @namei(ptr noundef nonnull @.str.4) #8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %11

7:                                                ; preds = %4
  %8 = tail call fastcc ptr @create(ptr noundef nonnull @.str.4, i16 noundef signext 1) #10
  %9 = icmp eq ptr %8, null
  br i1 %9, label %16, label %10

10:                                               ; preds = %7
  tail call void @iunlock(ptr noundef nonnull %8) #8
  br label %11

11:                                               ; preds = %10, %4
  %12 = phi ptr [ %5, %4 ], [ %8, %10 ]
  %13 = load i32, ptr %12, align 4, !tbaa !17
  store i32 %13, ptr @devmnt_dev, align 4, !tbaa !11
  %14 = getelementptr inbounds nuw i8, ptr %12, i32 4
  %15 = load i32, ptr %14, align 4, !tbaa !21
  store i32 %15, ptr @devmnt_inum, align 4, !tbaa !11
  tail call void @iput(ptr noundef nonnull %12) #8
  store i8 47, ptr @devmnt, align 1, !tbaa !3
  store i8 100, ptr getelementptr inbounds nuw (i8, ptr @devmnt, i32 1), align 1, !tbaa !3
  store i8 101, ptr getelementptr inbounds nuw (i8, ptr @devmnt, i32 2), align 1, !tbaa !3
  store i8 118, ptr getelementptr inbounds nuw (i8, ptr @devmnt, i32 3), align 1, !tbaa !3
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @devmnt, i32 4), align 1, !tbaa !3
  br label %16

16:                                               ; preds = %7, %11
  br label %17

17:                                               ; preds = %16, %30
  %18 = phi i32 [ %31, %30 ], [ 0, %16 ]
  %19 = icmp eq i32 %18, 8
  br i1 %19, label %20, label %21

20:                                               ; preds = %17
  tail call void @iput(ptr noundef nonnull %1) #8
  store i32 1, ptr @fsready, align 4, !tbaa !11
  ret void

21:                                               ; preds = %17
  %22 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %18
  %23 = getelementptr inbounds nuw i8, ptr %22, i32 4
  store i32 -1, ptr %23, align 4, !tbaa !22
  %24 = tail call ptr @namei(ptr noundef nonnull @.str.5) #8
  %25 = getelementptr inbounds nuw i8, ptr %22, i32 8
  store ptr %24, ptr %25, align 4, !tbaa !26
  %26 = getelementptr inbounds nuw i8, ptr %22, i32 12
  br label %27

27:                                               ; preds = %32, %21
  %28 = phi i32 [ 0, %21 ], [ %40, %32 ]
  %29 = icmp eq i32 %28, 3
  br i1 %29, label %30, label %32

30:                                               ; preds = %27
  %31 = add nuw nsw i32 %18, 1
  br label %17, !llvm.loop !27

32:                                               ; preds = %27
  %33 = tail call ptr @filealloc() #8
  store i32 3, ptr %33, align 4, !tbaa !28
  %34 = getelementptr inbounds nuw i8, ptr %33, i32 24
  store i16 1, ptr %34, align 4, !tbaa !31
  %35 = getelementptr inbounds nuw i8, ptr %33, i32 8
  store i8 1, ptr %35, align 4, !tbaa !32
  %36 = getelementptr inbounds nuw i8, ptr %33, i32 9
  store i8 1, ptr %36, align 1, !tbaa !33
  %37 = tail call ptr @idup(ptr noundef nonnull %1) #8
  %38 = getelementptr inbounds nuw i8, ptr %33, i32 16
  store ptr %37, ptr %38, align 4, !tbaa !34
  %39 = getelementptr inbounds nuw [16 x ptr], ptr %26, i32 0, i32 %28
  store ptr %33, ptr %39, align 4, !tbaa !35
  %40 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !37
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

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @create(ptr noundef %0, i16 noundef signext range(i16 1, 3) %1) unnamed_addr #1 {
  %3 = alloca [62 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %3) #11
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
  %13 = load i16, ptr %12, align 4, !tbaa !38
  %14 = and i16 %13, -2
  %15 = icmp eq i16 %14, 2
  br i1 %15, label %50, label %47

16:                                               ; preds = %6
  %17 = load i32, ptr %4, align 4, !tbaa !17
  %18 = call ptr @ialloc(i32 noundef %17, i16 noundef signext %1) #8
  %19 = icmp eq ptr %18, null
  br i1 %19, label %47, label %20

20:                                               ; preds = %16
  call void @ilock(ptr noundef nonnull %18) #8
  %21 = getelementptr inbounds nuw i8, ptr %18, i32 22
  store i16 0, ptr %21, align 2, !tbaa !39
  %22 = getelementptr inbounds nuw i8, ptr %18, i32 24
  store i16 0, ptr %22, align 4, !tbaa !40
  %23 = getelementptr inbounds nuw i8, ptr %18, i32 26
  store i16 1, ptr %23, align 2, !tbaa !41
  call void @iupdate(ptr noundef nonnull %18) #8
  %24 = icmp eq i16 %1, 1
  br i1 %24, label %25, label %36

25:                                               ; preds = %20
  %26 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %27 = load i32, ptr %26, align 4, !tbaa !21
  %28 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.10, i32 noundef %27) #8
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %35, label %30

30:                                               ; preds = %25
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %32 = load i32, ptr %31, align 4, !tbaa !21
  %33 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.11, i32 noundef %32) #8
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %35, label %36

35:                                               ; preds = %30, %25
  call void @panic(ptr noundef nonnull @.str.14) #9
  unreachable

36:                                               ; preds = %30, %20
  %37 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %38 = load i32, ptr %37, align 4, !tbaa !21
  %39 = call i32 @dirlink(ptr noundef nonnull %4, ptr noundef nonnull %3, i32 noundef %38) #8
  %40 = icmp slt i32 %39, 0
  br i1 %40, label %41, label %42

41:                                               ; preds = %36
  call void @panic(ptr noundef nonnull @.str.15) #9
  unreachable

42:                                               ; preds = %36
  br i1 %24, label %43, label %47

43:                                               ; preds = %42
  %44 = getelementptr inbounds nuw i8, ptr %4, i32 26
  %45 = load i16, ptr %44, align 2, !tbaa !41
  %46 = add i16 %45, 1
  store i16 %46, ptr %44, align 2, !tbaa !41
  call void @iupdate(ptr noundef nonnull %4) #8
  br label %47

47:                                               ; preds = %42, %43, %16, %9, %11
  %48 = phi ptr [ %7, %11 ], [ %7, %9 ], [ %4, %16 ], [ %4, %43 ], [ %4, %42 ]
  %49 = phi ptr [ null, %11 ], [ null, %9 ], [ null, %16 ], [ %18, %43 ], [ %18, %42 ]
  call void @iunlockput(ptr noundef nonnull %48) #8
  br label %50

50:                                               ; preds = %47, %11, %2
  %51 = phi ptr [ null, %2 ], [ %7, %11 ], [ %49, %47 ]
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %3) #11
  ret ptr %51
}

; Function Attrs: minsize optsize
declare dso_local void @iunlock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iput(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @filealloc() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @idup(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_forkcopy(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @fsproc, i32 0, i32 %0
  %4 = getelementptr inbounds [8 x %struct.proc], ptr @fsproc, i32 0, i32 %1
  %5 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %6 = load i32, ptr %5, align 4, !tbaa !22
  %7 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store i32 %6, ptr %7, align 4, !tbaa !22
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %9 = getelementptr inbounds nuw i8, ptr %4, i32 12
  br label %10

10:                                               ; preds = %23, %2
  %11 = phi i32 [ 0, %2 ], [ %26, %23 ]
  %12 = icmp eq i32 %11, 16
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %15 = load ptr, ptr %14, align 4, !tbaa !26
  %16 = icmp eq ptr %15, null
  br i1 %16, label %29, label %27

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw [16 x ptr], ptr %8, i32 0, i32 %11
  %19 = load ptr, ptr %18, align 4, !tbaa !35
  %20 = icmp eq ptr %19, null
  br i1 %20, label %23, label %21

21:                                               ; preds = %17
  %22 = tail call ptr @filedup(ptr noundef nonnull %19) #8
  br label %23

23:                                               ; preds = %17, %21
  %24 = phi ptr [ %22, %21 ], [ null, %17 ]
  %25 = getelementptr inbounds nuw [16 x ptr], ptr %9, i32 0, i32 %11
  store ptr %24, ptr %25, align 4, !tbaa !35
  %26 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !42

27:                                               ; preds = %13
  %28 = tail call ptr @idup(ptr noundef nonnull %15) #8
  br label %29

29:                                               ; preds = %13, %27
  %30 = phi ptr [ %28, %27 ], [ null, %13 ]
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 8
  store ptr %30, ptr %31, align 4, !tbaa !26
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
  %9 = load ptr, ptr %8, align 4, !tbaa !26
  %10 = icmp eq ptr %9, null
  br i1 %10, label %19, label %18

11:                                               ; preds = %4
  %12 = getelementptr inbounds nuw [16 x ptr], ptr %3, i32 0, i32 %5
  %13 = load ptr, ptr %12, align 4, !tbaa !35
  %14 = icmp eq ptr %13, null
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  tail call void @fileclose(ptr noundef nonnull %13) #8
  store ptr null, ptr %12, align 4, !tbaa !35
  br label %16

16:                                               ; preds = %11, %15
  %17 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !43

18:                                               ; preds = %7
  tail call void @vfs_iput(ptr noundef nonnull %9) #10
  store ptr null, ptr %8, align 4, !tbaa !26
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
  br label %10

5:                                                ; preds = %1
  %6 = tail call i32 @dev_is(ptr noundef %0) #8
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %9, label %8

8:                                                ; preds = %5
  tail call void @dev_put(ptr noundef %0) #8
  br label %10

9:                                                ; preds = %5
  tail call void @iput(ptr noundef %0) #8
  br label %10

10:                                               ; preds = %8, %9, %4
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vfs_readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = tail call i32 @fat_is(ptr noundef %0) #8
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %5
  %9 = tail call i32 @fat_readi(ptr noundef %0, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
  br label %17

10:                                               ; preds = %5
  %11 = tail call i32 @dev_is(ptr noundef %0) #8
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %15, label %13

13:                                               ; preds = %10
  %14 = tail call i32 @dev_readi(ptr noundef %0, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
  br label %17

15:                                               ; preds = %10
  %16 = tail call i32 @readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
  br label %17

17:                                               ; preds = %15, %13, %8
  %18 = phi i32 [ %9, %8 ], [ %14, %13 ], [ %16, %15 ]
  ret i32 %18
}

; Function Attrs: minsize optsize
declare dso_local i32 @fat_is(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @fat_readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @dev_is(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @dev_readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vfs_writei(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = tail call i32 @fat_is(ptr noundef %0) #8
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %13

8:                                                ; preds = %5
  %9 = tail call i32 @dev_is(ptr noundef %0) #8
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  %12 = tail call i32 @writei(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #8
  br label %13

13:                                               ; preds = %5, %8, %11
  %14 = phi i32 [ %12, %11 ], [ -1, %8 ], [ -1, %5 ]
  ret i32 %14
}

; Function Attrs: minsize optsize
declare dso_local i32 @writei(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_ilock(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #8
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %8

4:                                                ; preds = %1
  %5 = tail call i32 @dev_is(ptr noundef %0) #8
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  tail call void @ilock(ptr noundef %0) #8
  br label %8

8:                                                ; preds = %7, %4, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @ilock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_iunlock(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @fat_is(ptr noundef %0) #8
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %8

4:                                                ; preds = %1
  %5 = tail call i32 @dev_is(ptr noundef %0) #8
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  tail call void @iunlock(ptr noundef %0) #8
  br label %8

8:                                                ; preds = %7, %4, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @fat_put(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @dev_put(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @vfs_stati(ptr noundef %0, ptr noundef %1) local_unnamed_addr #1 {
  %3 = tail call i32 @fat_is(ptr noundef %0) #8
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %6, label %5

5:                                                ; preds = %2
  tail call void @fat_stati(ptr noundef %0, ptr noundef %1) #8
  br label %11

6:                                                ; preds = %2
  %7 = tail call i32 @dev_is(ptr noundef %0) #8
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %6
  tail call void @dev_stati(ptr noundef %0, ptr noundef %1) #8
  br label %11

10:                                               ; preds = %6
  tail call void @stati(ptr noundef %0, ptr noundef %1) #8
  br label %11

11:                                               ; preds = %9, %10, %5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @fat_stati(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @dev_stati(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @stati(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_mount(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = icmp eq i32 %0, 0
  br i1 %3, label %4, label %58

4:                                                ; preds = %2
  %5 = inttoptr i32 %1 to ptr
  %6 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %41, label %8

8:                                                ; preds = %4
  %9 = tail call i32 @fat_is_sd() #8
  %10 = icmp eq i32 %9, 0
  %11 = select i1 %10, ptr @.str.7, ptr @.str.6
  br label %12

12:                                               ; preds = %17, %8
  %13 = phi ptr [ %11, %8 ], [ %18, %17 ]
  %14 = phi i32 [ 0, %8 ], [ %19, %17 ]
  %15 = load i8, ptr %13, align 1, !tbaa !3
  %16 = icmp eq i8 %15, 0
  br i1 %16, label %21, label %17

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw i8, ptr %13, i32 1
  %19 = add nuw nsw i32 %14, 1
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 %14
  store i8 %15, ptr %20, align 1, !tbaa !3
  br label %12, !llvm.loop !44

21:                                               ; preds = %12, %27
  %22 = phi i32 [ %30, %27 ], [ 0, %12 ]
  %23 = phi i32 [ %28, %27 ], [ %14, %12 ]
  %24 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %22
  %25 = load i8, ptr %24, align 1, !tbaa !3
  %26 = icmp eq i8 %25, 0
  br i1 %26, label %31, label %27

27:                                               ; preds = %21
  %28 = add nuw nsw i32 %23, 1
  %29 = getelementptr inbounds nuw i8, ptr %5, i32 %23
  store i8 %25, ptr %29, align 1, !tbaa !3
  %30 = add nuw nsw i32 %22, 1
  br label %21, !llvm.loop !45

31:                                               ; preds = %21, %35
  %32 = phi i32 [ %38, %35 ], [ 0, %21 ]
  %33 = phi i32 [ %39, %35 ], [ %23, %21 ]
  %34 = icmp eq i32 %32, 16
  br i1 %34, label %41, label %35

35:                                               ; preds = %31
  %36 = getelementptr inbounds nuw i8, ptr @.str.8, i32 %32
  %37 = load i8, ptr %36, align 1, !tbaa !3
  %38 = add nuw nsw i32 %32, 1
  %39 = add nuw nsw i32 %33, 1
  %40 = getelementptr inbounds nuw i8, ptr %5, i32 %33
  store i8 %37, ptr %40, align 1, !tbaa !3
  br label %31, !llvm.loop !46

41:                                               ; preds = %31, %4
  %42 = phi i32 [ 0, %4 ], [ %33, %31 ]
  %43 = load i8, ptr @devmnt, align 1, !tbaa !3
  %44 = icmp eq i8 %43, 0
  br i1 %44, label %55, label %45

45:                                               ; preds = %41, %49
  %46 = phi i32 [ %52, %49 ], [ 0, %41 ]
  %47 = phi i32 [ %53, %49 ], [ %42, %41 ]
  %48 = icmp eq i32 %46, 30
  br i1 %48, label %55, label %49

49:                                               ; preds = %45
  %50 = getelementptr inbounds nuw i8, ptr @.str.9, i32 %46
  %51 = load i8, ptr %50, align 1, !tbaa !3
  %52 = add nuw nsw i32 %46, 1
  %53 = add nuw nsw i32 %47, 1
  %54 = getelementptr inbounds i8, ptr %5, i32 %47
  store i8 %51, ptr %54, align 1, !tbaa !3
  br label %45, !llvm.loop !47

55:                                               ; preds = %45, %41
  %56 = phi i32 [ %42, %41 ], [ %47, %45 ]
  %57 = getelementptr inbounds i8, ptr %5, i32 %56
  store i8 0, ptr %57, align 1, !tbaa !3
  br label %146

58:                                               ; preds = %2
  %59 = inttoptr i32 %0 to ptr
  %60 = inttoptr i32 %1 to ptr
  %61 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %62 = icmp eq i8 %61, 0
  br i1 %62, label %63, label %146

63:                                               ; preds = %58
  %64 = load i8, ptr %59, align 1, !tbaa !3
  switch i8 %64, label %146 [
    i8 115, label %65
    i8 102, label %77
  ]

65:                                               ; preds = %63
  %66 = getelementptr inbounds nuw i8, ptr %59, i32 1
  %67 = load i8, ptr %66, align 1, !tbaa !3
  %68 = icmp eq i8 %67, 100
  br i1 %68, label %69, label %146

69:                                               ; preds = %65
  %70 = getelementptr inbounds nuw i8, ptr %59, i32 2
  %71 = load i8, ptr %70, align 1, !tbaa !3
  %72 = icmp eq i8 %71, 48
  br i1 %72, label %73, label %146

73:                                               ; preds = %69
  %74 = getelementptr inbounds nuw i8, ptr %59, i32 3
  %75 = load i8, ptr %74, align 1, !tbaa !3
  %76 = icmp eq i8 %75, 0
  br i1 %76, label %96, label %146

77:                                               ; preds = %63
  %78 = getelementptr inbounds nuw i8, ptr %59, i32 1
  %79 = load i8, ptr %78, align 1, !tbaa !3
  %80 = icmp eq i8 %79, 97
  br i1 %80, label %81, label %146

81:                                               ; preds = %77
  %82 = getelementptr inbounds nuw i8, ptr %59, i32 2
  %83 = load i8, ptr %82, align 1, !tbaa !3
  %84 = icmp eq i8 %83, 116
  br i1 %84, label %85, label %146

85:                                               ; preds = %81
  %86 = getelementptr inbounds nuw i8, ptr %59, i32 3
  %87 = load i8, ptr %86, align 1, !tbaa !3
  %88 = icmp eq i8 %87, 48
  br i1 %88, label %89, label %146

89:                                               ; preds = %85
  %90 = getelementptr inbounds nuw i8, ptr %59, i32 4
  %91 = load i8, ptr %90, align 1, !tbaa !3
  %92 = icmp eq i8 %91, 0
  br i1 %92, label %93, label %146

93:                                               ; preds = %89
  %94 = load i32, ptr @fatvol, align 4
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %146, label %96

96:                                               ; preds = %73, %93
  %97 = phi i1 [ false, %93 ], [ true, %73 ]
  %98 = load i8, ptr %60, align 1, !tbaa !3
  %99 = icmp eq i8 %98, 47
  br i1 %99, label %100, label %146

100:                                              ; preds = %96
  %101 = getelementptr inbounds nuw i8, ptr %60, i32 1
  %102 = load i8, ptr %101, align 1, !tbaa !3
  %103 = icmp eq i8 %102, 0
  br i1 %103, label %146, label %104

104:                                              ; preds = %100
  %105 = tail call ptr @namei(ptr noundef nonnull %60) #8
  %106 = icmp eq ptr %105, null
  br i1 %106, label %146, label %107

107:                                              ; preds = %104
  tail call void @ilock(ptr noundef nonnull %105) #8
  %108 = getelementptr inbounds nuw i8, ptr %105, i32 20
  %109 = load i16, ptr %108, align 4, !tbaa !38
  %110 = icmp eq i16 %109, 1
  %111 = load i32, ptr %105, align 4, !tbaa !17
  %112 = getelementptr inbounds nuw i8, ptr %105, i32 4
  %113 = load i32, ptr %112, align 4, !tbaa !21
  tail call void @iunlockput(ptr noundef nonnull %105) #8
  br i1 %110, label %114, label %146

114:                                              ; preds = %107
  br i1 %97, label %115, label %118

115:                                              ; preds = %114
  %116 = tail call i32 @fat_mount_sd() #8
  %117 = icmp slt i32 %116, 0
  br i1 %117, label %146, label %122

118:                                              ; preds = %114
  %119 = load i32, ptr @fatvol, align 4, !tbaa !11
  %120 = tail call i32 @fat_mount(i32 noundef %119) #8
  %121 = icmp slt i32 %120, 0
  br i1 %121, label %146, label %122

122:                                              ; preds = %118, %115
  store i32 %111, ptr @fatmnt_dev, align 4, !tbaa !11
  store i32 %113, ptr @fatmnt_inum, align 4, !tbaa !11
  br label %123

123:                                              ; preds = %133, %122
  %124 = phi i32 [ 0, %122 ], [ %135, %133 ]
  %125 = getelementptr inbounds nuw i8, ptr %60, i32 %124
  %126 = load i8, ptr %125, align 1, !tbaa !3
  %127 = icmp eq i8 %126, 0
  br i1 %127, label %128, label %129

128:                                              ; preds = %129, %123
  br label %136

129:                                              ; preds = %123
  %130 = icmp ne i8 %126, 32
  %131 = icmp samesign ult i32 %124, 26
  %132 = select i1 %130, i1 %131, i1 false
  br i1 %132, label %133, label %128

133:                                              ; preds = %129
  %134 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %124
  store i8 %126, ptr %134, align 1, !tbaa !3
  %135 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !48

136:                                              ; preds = %128, %139
  %137 = phi i32 [ %140, %139 ], [ %124, %128 ]
  %138 = icmp sgt i32 %137, 1
  br i1 %138, label %139, label %144

139:                                              ; preds = %136
  %140 = add nsw i32 %137, -1
  %141 = getelementptr inbounds nuw [28 x i8], ptr @fatmnt, i32 0, i32 %140
  %142 = load i8, ptr %141, align 1, !tbaa !3
  %143 = icmp eq i8 %142, 47
  br i1 %143, label %136, label %144, !llvm.loop !49

144:                                              ; preds = %136, %139
  %145 = getelementptr inbounds [28 x i8], ptr @fatmnt, i32 0, i32 %137
  store i8 0, ptr %145, align 1, !tbaa !3
  br label %146

146:                                              ; preds = %63, %65, %69, %73, %58, %104, %115, %118, %107, %144, %96, %100, %93, %77, %81, %85, %89, %55
  %147 = phi i32 [ %56, %55 ], [ -1, %58 ], [ -1, %89 ], [ -1, %85 ], [ -1, %81 ], [ -1, %77 ], [ -1, %93 ], [ -1, %100 ], [ -1, %96 ], [ -1, %104 ], [ 0, %144 ], [ -1, %107 ], [ -1, %118 ], [ -1, %115 ], [ -1, %73 ], [ -1, %69 ], [ -1, %65 ], [ -1, %63 ]
  ret i32 %147
}

; Function Attrs: minsize optsize
declare dso_local i32 @fat_is_sd() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iunlockput(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @fat_mount_sd() local_unnamed_addr #3

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
  br label %5, !llvm.loop !50

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
  %10 = load ptr, ptr %9, align 4, !tbaa !35
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
  %10 = load ptr, ptr %9, align 4, !tbaa !35
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
  %8 = load ptr, ptr %7, align 4, !tbaa !35
  %9 = icmp eq ptr %8, null
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store ptr null, ptr %7, align 4, !tbaa !35
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
  %8 = load ptr, ptr %7, align 4, !tbaa !35
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
  %8 = load ptr, ptr %7, align 4, !tbaa !35
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %11

10:                                               ; preds = %6
  store ptr %0, ptr %7, align 4, !tbaa !35
  br label %13

11:                                               ; preds = %6
  %12 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !51

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
  %9 = load ptr, ptr %8, align 4, !tbaa !35
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
  %7 = load ptr, ptr %2, align 4, !tbaa !35
  %8 = call fastcc i32 @fdalloc(ptr noundef %7) #10
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %10, label %17

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 4, !tbaa !35
  %12 = call fastcc i32 @fdalloc(ptr noundef %11) #10
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %20

14:                                               ; preds = %10
  %15 = load i32, ptr @curr, align 4, !tbaa !11
  %16 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %15, i32 3, i32 %8
  store ptr null, ptr %16, align 4, !tbaa !35
  br label %17

17:                                               ; preds = %6, %14
  %18 = load ptr, ptr %2, align 4, !tbaa !35
  call void @fileclose(ptr noundef %18) #8
  %19 = load ptr, ptr %3, align 4, !tbaa !35
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
  br i1 %8, label %9, label %100

9:                                                ; preds = %7
  %10 = tail call fastcc ptr @create(ptr noundef %3, i16 noundef signext 2) #10
  %11 = icmp eq ptr %10, null
  br i1 %11, label %100, label %64

12:                                               ; preds = %2
  %13 = icmp ne i32 %6, 0
  %14 = icmp ne i32 %1, 0
  %15 = and i1 %14, %13
  br i1 %15, label %100, label %16

16:                                               ; preds = %12
  %17 = tail call fastcc ptr @vfs_resolve(ptr noundef %3) #10
  %18 = icmp eq ptr %17, null
  br i1 %18, label %100, label %19

19:                                               ; preds = %16
  %20 = tail call i32 @fat_is(ptr noundef nonnull %17) #8
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %22, label %25

22:                                               ; preds = %19
  %23 = tail call i32 @dev_is(ptr noundef nonnull %17) #8
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %58, label %25

25:                                               ; preds = %22, %19
  %26 = tail call ptr @filealloc() #8
  %27 = icmp eq ptr %26, null
  br i1 %27, label %32, label %28

28:                                               ; preds = %25
  %29 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %26) #10
  %30 = icmp slt i32 %29, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %28
  tail call void @fileclose(ptr noundef nonnull %26) #8
  br label %32

32:                                               ; preds = %25, %31
  tail call void @vfs_iput(ptr noundef nonnull %17) #10
  br label %100

33:                                               ; preds = %28
  %34 = tail call i32 @dev_is(ptr noundef nonnull %17) #8
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %53, label %36

36:                                               ; preds = %33
  %37 = getelementptr inbounds nuw i8, ptr %17, i32 20
  %38 = load i16, ptr %37, align 4, !tbaa !38
  %39 = icmp eq i16 %38, 3
  br i1 %39, label %40, label %53

40:                                               ; preds = %36
  store i32 3, ptr %26, align 4, !tbaa !28
  %41 = getelementptr inbounds nuw i8, ptr %17, i32 22
  %42 = load i16, ptr %41, align 2, !tbaa !39
  %43 = getelementptr inbounds nuw i8, ptr %26, i32 24
  store i16 %42, ptr %43, align 4, !tbaa !31
  %44 = getelementptr inbounds nuw i8, ptr %26, i32 16
  store ptr %17, ptr %44, align 4, !tbaa !34
  %45 = trunc i32 %1 to i8
  %46 = and i8 %45, 1
  %47 = xor i8 %46, 1
  %48 = getelementptr inbounds nuw i8, ptr %26, i32 8
  store i8 %47, ptr %48, align 4, !tbaa !32
  %49 = and i32 %1, 3
  %50 = icmp ne i32 %49, 0
  %51 = zext i1 %50 to i8
  %52 = getelementptr inbounds nuw i8, ptr %26, i32 9
  store i8 %51, ptr %52, align 1, !tbaa !33
  br label %100

53:                                               ; preds = %36, %33
  store i32 2, ptr %26, align 4, !tbaa !28
  %54 = getelementptr inbounds nuw i8, ptr %26, i32 20
  store i32 0, ptr %54, align 4, !tbaa !52
  %55 = getelementptr inbounds nuw i8, ptr %26, i32 16
  store ptr %17, ptr %55, align 4, !tbaa !34
  %56 = getelementptr inbounds nuw i8, ptr %26, i32 8
  store i8 1, ptr %56, align 4, !tbaa !32
  %57 = getelementptr inbounds nuw i8, ptr %26, i32 9
  store i8 0, ptr %57, align 1, !tbaa !33
  br label %100

58:                                               ; preds = %22
  tail call void @ilock(ptr noundef nonnull %17) #8
  %59 = getelementptr inbounds nuw i8, ptr %17, i32 20
  %60 = load i16, ptr %59, align 4, !tbaa !38
  %61 = icmp eq i16 %60, 1
  %62 = and i1 %14, %61
  br i1 %62, label %63, label %64

63:                                               ; preds = %58
  tail call void @iunlockput(ptr noundef nonnull %17) #8
  br label %100

64:                                               ; preds = %58, %9
  %65 = phi ptr [ %10, %9 ], [ %17, %58 ]
  %66 = tail call ptr @filealloc() #8
  %67 = icmp eq ptr %66, null
  br i1 %67, label %72, label %68

68:                                               ; preds = %64
  %69 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %66) #10
  %70 = icmp slt i32 %69, 0
  br i1 %70, label %71, label %73

71:                                               ; preds = %68
  tail call void @fileclose(ptr noundef nonnull %66) #8
  br label %72

72:                                               ; preds = %64, %71
  tail call void @iunlockput(ptr noundef nonnull %65) #8
  br label %100

73:                                               ; preds = %68
  %74 = getelementptr inbounds nuw i8, ptr %65, i32 20
  %75 = load i16, ptr %74, align 4, !tbaa !38
  %76 = icmp eq i16 %75, 3
  br i1 %76, label %77, label %81

77:                                               ; preds = %73
  %78 = getelementptr inbounds nuw i8, ptr %65, i32 22
  %79 = load i16, ptr %78, align 2, !tbaa !39
  %80 = getelementptr inbounds nuw i8, ptr %66, i32 24
  store i16 %79, ptr %80, align 4, !tbaa !31
  br label %83

81:                                               ; preds = %73
  %82 = getelementptr inbounds nuw i8, ptr %66, i32 20
  store i32 0, ptr %82, align 4, !tbaa !52
  br label %83

83:                                               ; preds = %81, %77
  %84 = phi i32 [ 3, %77 ], [ 2, %81 ]
  store i32 %84, ptr %66, align 4, !tbaa !28
  %85 = getelementptr inbounds nuw i8, ptr %66, i32 16
  store ptr %65, ptr %85, align 4, !tbaa !34
  %86 = trunc i32 %1 to i8
  %87 = and i8 %86, 1
  %88 = xor i8 %87, 1
  %89 = getelementptr inbounds nuw i8, ptr %66, i32 8
  store i8 %88, ptr %89, align 4, !tbaa !32
  %90 = and i32 %1, 3
  %91 = icmp ne i32 %90, 0
  %92 = zext i1 %91 to i8
  %93 = getelementptr inbounds nuw i8, ptr %66, i32 9
  store i8 %92, ptr %93, align 1, !tbaa !33
  %94 = and i32 %1, 1024
  %95 = icmp ne i32 %94, 0
  %96 = icmp eq i16 %75, 2
  %97 = and i1 %95, %96
  br i1 %97, label %98, label %99

98:                                               ; preds = %83
  tail call void @itrunc(ptr noundef nonnull %65) #8
  br label %99

99:                                               ; preds = %98, %83
  tail call void @iunlock(ptr noundef nonnull %65) #8
  br label %100

100:                                              ; preds = %72, %99, %32, %40, %53, %16, %12, %9, %7, %63
  %101 = phi i32 [ -1, %63 ], [ -1, %7 ], [ -1, %9 ], [ -1, %12 ], [ -1, %16 ], [ -1, %32 ], [ %29, %40 ], [ %29, %53 ], [ -1, %72 ], [ %69, %99 ]
  ret i32 %101
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @fat_writepath(ptr noundef readonly captures(address) %0) unnamed_addr #1 {
  %2 = tail call fastcc ptr @fat_prefix(ptr noundef %0) #10
  %3 = icmp eq ptr %2, null
  br i1 %3, label %4, label %23

4:                                                ; preds = %1
  %5 = tail call fastcc ptr @dev_prefix(ptr noundef %0) #10
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %23

7:                                                ; preds = %4
  %8 = load i8, ptr %0, align 1, !tbaa !3
  %9 = icmp eq i8 %8, 47
  br i1 %9, label %23, label %10

10:                                               ; preds = %7
  %11 = load i32, ptr @curr, align 4, !tbaa !11
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %11, i32 2
  %13 = load ptr, ptr %12, align 4, !tbaa !26
  %14 = icmp eq ptr %13, null
  br i1 %14, label %23, label %15

15:                                               ; preds = %10
  %16 = tail call i32 @fat_is(ptr noundef nonnull %13) #8
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %23

18:                                               ; preds = %15
  %19 = load ptr, ptr %12, align 4, !tbaa !26
  %20 = tail call i32 @dev_is(ptr noundef %19) #8
  %21 = icmp ne i32 %20, 0
  %22 = zext i1 %21 to i32
  br label %23

23:                                               ; preds = %7, %10, %18, %15, %1, %4
  %24 = phi i32 [ 1, %4 ], [ 1, %1 ], [ 0, %10 ], [ 0, %7 ], [ 1, %15 ], [ %22, %18 ]
  ret i32 %24
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @vfs_resolve(ptr noundef %0) unnamed_addr #1 {
  %2 = load i32, ptr @curr, align 4, !tbaa !11
  %3 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %2
  %4 = load i8, ptr @fatmnt, align 1, !tbaa !3
  %5 = icmp eq i8 %4, 0
  %6 = load i8, ptr @devmnt, align 1
  %7 = icmp eq i8 %6, 0
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %22

9:                                                ; preds = %1
  %10 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %11 = load ptr, ptr %10, align 4, !tbaa !26
  %12 = icmp eq ptr %11, null
  br i1 %12, label %20, label %13

13:                                               ; preds = %9
  %14 = tail call i32 @fat_is(ptr noundef nonnull %11) #8
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %22

16:                                               ; preds = %13
  %17 = load ptr, ptr %10, align 4, !tbaa !26
  %18 = tail call i32 @dev_is(ptr noundef %17) #8
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %20, label %22

20:                                               ; preds = %16, %9
  %21 = tail call ptr @namei(ptr noundef %0) #8
  br label %80

22:                                               ; preds = %16, %13, %1
  %23 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %24 = load ptr, ptr %23, align 4, !tbaa !26
  %25 = icmp eq ptr %24, null
  br i1 %25, label %35, label %26

26:                                               ; preds = %22
  %27 = tail call i32 @fat_is(ptr noundef nonnull %24) #8
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %33

29:                                               ; preds = %26
  %30 = load ptr, ptr %23, align 4, !tbaa !26
  %31 = tail call i32 @dev_is(ptr noundef %30) #8
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %35, label %33

33:                                               ; preds = %29, %26
  %34 = tail call fastcc ptr @vfs_walk(ptr noundef %0) #10
  br label %80

35:                                               ; preds = %29, %22
  %36 = load i8, ptr %0, align 1, !tbaa !3
  %37 = icmp eq i8 %36, 47
  br i1 %37, label %38, label %46

38:                                               ; preds = %35
  %39 = tail call fastcc ptr @fat_prefix(ptr noundef nonnull %0) #10
  %40 = icmp eq ptr %39, null
  br i1 %40, label %41, label %44

41:                                               ; preds = %38
  %42 = tail call fastcc ptr @dev_prefix(ptr noundef nonnull %0) #10
  %43 = icmp eq ptr %42, null
  br i1 %43, label %46, label %44

44:                                               ; preds = %41, %38
  %45 = tail call fastcc ptr @vfs_walk(ptr noundef nonnull %0) #10
  br label %80

46:                                               ; preds = %41, %35
  %47 = tail call ptr @namei(ptr noundef nonnull %0) #8
  %48 = icmp eq ptr %47, null
  br i1 %48, label %49, label %59

49:                                               ; preds = %46
  %50 = tail call fastcc ptr @vfs_walk(ptr noundef nonnull %0) #10
  %51 = icmp eq ptr %50, null
  br i1 %51, label %80, label %52

52:                                               ; preds = %49
  %53 = tail call i32 @fat_is(ptr noundef nonnull %50) #8
  %54 = icmp eq i32 %53, 0
  br i1 %54, label %55, label %80

55:                                               ; preds = %52
  %56 = tail call i32 @dev_is(ptr noundef nonnull %50) #8
  %57 = icmp eq i32 %56, 0
  br i1 %57, label %58, label %80

58:                                               ; preds = %55
  tail call void @iput(ptr noundef nonnull %50) #8
  br label %80

59:                                               ; preds = %46
  %60 = load i32, ptr %47, align 4, !tbaa !17
  %61 = load i32, ptr @fatmnt_dev, align 4, !tbaa !11
  %62 = icmp eq i32 %60, %61
  br i1 %62, label %63, label %70

63:                                               ; preds = %59
  %64 = getelementptr inbounds nuw i8, ptr %47, i32 4
  %65 = load i32, ptr %64, align 4, !tbaa !21
  %66 = load i32, ptr @fatmnt_inum, align 4, !tbaa !11
  %67 = icmp eq i32 %65, %66
  br i1 %67, label %68, label %70

68:                                               ; preds = %63
  tail call void @iput(ptr noundef nonnull %47) #8
  %69 = tail call ptr @fat_root() #8
  br label %80

70:                                               ; preds = %63, %59
  %71 = load i32, ptr @devmnt_dev, align 4, !tbaa !11
  %72 = icmp eq i32 %60, %71
  br i1 %72, label %73, label %80

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw i8, ptr %47, i32 4
  %75 = load i32, ptr %74, align 4, !tbaa !21
  %76 = load i32, ptr @devmnt_inum, align 4, !tbaa !11
  %77 = icmp eq i32 %75, %76
  br i1 %77, label %78, label %80

78:                                               ; preds = %73
  tail call void @iput(ptr noundef nonnull %47) #8
  %79 = tail call ptr @dev_root() #8
  br label %80

80:                                               ; preds = %58, %68, %78, %55, %52, %49, %73, %70, %44, %33, %20
  %81 = phi ptr [ %34, %33 ], [ %45, %44 ], [ %21, %20 ], [ null, %58 ], [ %69, %68 ], [ %79, %78 ], [ %50, %55 ], [ %50, %52 ], [ null, %49 ], [ %47, %73 ], [ %47, %70 ]
  ret ptr %81
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
  %11 = load i16, ptr %10, align 4, !tbaa !38
  %12 = icmp eq i16 %11, 1
  br i1 %12, label %20, label %13

13:                                               ; preds = %9
  tail call void @fat_put(ptr noundef nonnull %4) #8
  br label %26

14:                                               ; preds = %6
  tail call void @ilock(ptr noundef nonnull %4) #8
  %15 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !38
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
  %22 = load ptr, ptr %21, align 4, !tbaa !26
  %23 = icmp eq ptr %22, null
  br i1 %23, label %25, label %24

24:                                               ; preds = %20
  tail call void @vfs_iput(ptr noundef nonnull %22) #10
  br label %25

25:                                               ; preds = %24, %20
  store ptr %4, ptr %21, align 4, !tbaa !26
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
  %3 = alloca [62 x i8], align 1
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
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %3) #11
  %12 = tail call ptr @namei(ptr noundef %4) #8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %39, label %14

14:                                               ; preds = %11
  tail call void @ilock(ptr noundef nonnull %12) #8
  %15 = getelementptr inbounds nuw i8, ptr %12, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !38
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %18, label %19

18:                                               ; preds = %14
  tail call void @iunlockput(ptr noundef nonnull %12) #8
  br label %39

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i8, ptr %12, i32 26
  %21 = load i16, ptr %20, align 2, !tbaa !41
  %22 = add i16 %21, 1
  store i16 %22, ptr %20, align 2, !tbaa !41
  tail call void @iupdate(ptr noundef nonnull %12) #8
  tail call void @iunlock(ptr noundef nonnull %12) #8
  %23 = call ptr @nameiparent(ptr noundef %8, ptr noundef nonnull %3) #8
  %24 = icmp eq ptr %23, null
  br i1 %24, label %36, label %25

25:                                               ; preds = %19
  call void @ilock(ptr noundef nonnull %23) #8
  %26 = load i32, ptr %23, align 4, !tbaa !17
  %27 = load i32, ptr %12, align 4, !tbaa !17
  %28 = icmp eq i32 %26, %27
  br i1 %28, label %29, label %35

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %12, i32 4
  %31 = load i32, ptr %30, align 4, !tbaa !21
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
  %37 = load i16, ptr %20, align 2, !tbaa !41
  %38 = add i16 %37, -1
  store i16 %38, ptr %20, align 2, !tbaa !41
  call void @iupdate(ptr noundef nonnull %12) #8
  call void @iunlockput(ptr noundef nonnull %12) #8
  br label %39

39:                                               ; preds = %34, %36, %11, %18
  %40 = phi i32 [ -1, %18 ], [ -1, %11 ], [ 0, %34 ], [ -1, %36 ]
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %3) #11
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
  %7 = tail call fastcc i32 @fat_writepath(ptr noundef %6) #10
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %69

9:                                                ; preds = %1
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %3) #11
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %4) #11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #11
  %10 = call ptr @nameiparent(ptr noundef %6, ptr noundef nonnull %4) #8
  %11 = icmp eq ptr %10, null
  br i1 %11, label %67, label %12

12:                                               ; preds = %9
  call void @ilock(ptr noundef nonnull %10) #8
  %13 = call i32 @namecmp(ptr noundef nonnull %4, ptr noundef nonnull @.str.10) #8
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %64, label %15

15:                                               ; preds = %12
  %16 = call i32 @namecmp(ptr noundef nonnull %4, ptr noundef nonnull @.str.11) #8
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %64, label %18

18:                                               ; preds = %15
  %19 = call ptr @dirlookup(ptr noundef nonnull %10, ptr noundef nonnull %4, ptr noundef nonnull %5) #8
  %20 = icmp eq ptr %19, null
  br i1 %20, label %64, label %21

21:                                               ; preds = %18
  call void @ilock(ptr noundef nonnull %19) #8
  %22 = getelementptr inbounds nuw i8, ptr %19, i32 26
  %23 = load i16, ptr %22, align 2, !tbaa !41
  %24 = icmp slt i16 %23, 1
  br i1 %24, label %25, label %26

25:                                               ; preds = %21
  call void @panic(ptr noundef nonnull @.str.12) #9
  unreachable

26:                                               ; preds = %21
  %27 = getelementptr inbounds nuw i8, ptr %19, i32 20
  %28 = load i16, ptr %27, align 4, !tbaa !38
  %29 = icmp eq i16 %28, 1
  br i1 %29, label %30, label %47

30:                                               ; preds = %26
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #11
  %31 = getelementptr inbounds nuw i8, ptr %19, i32 28
  %32 = ptrtoint ptr %2 to i32
  br label %33

33:                                               ; preds = %41, %30
  %34 = phi i32 [ 128, %30 ], [ %44, %41 ]
  %35 = load i32, ptr %31, align 4, !tbaa !53
  %36 = icmp ult i32 %34, %35
  br i1 %36, label %37, label %45

37:                                               ; preds = %33
  %38 = call i32 @readi(ptr noundef nonnull %19, i32 noundef 0, i32 noundef %32, i32 noundef %34, i32 noundef 64) #8
  %39 = icmp eq i32 %38, 64
  br i1 %39, label %41, label %40

40:                                               ; preds = %37
  call void @panic(ptr noundef nonnull @.str.16) #9
  unreachable

41:                                               ; preds = %37
  %42 = load i16, ptr %2, align 2, !tbaa !54
  %43 = icmp eq i16 %42, 0
  %44 = add i32 %34, 64
  br i1 %43, label %33, label %46, !llvm.loop !56

45:                                               ; preds = %33
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #11
  br label %47

46:                                               ; preds = %41
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #11
  call void @iunlockput(ptr noundef nonnull %19) #8
  br label %64

47:                                               ; preds = %45, %26
  %48 = call ptr @memset(ptr noundef nonnull %3, i32 noundef 0, i32 noundef 64) #8
  %49 = ptrtoint ptr %3 to i32
  %50 = load i32, ptr %5, align 4, !tbaa !11
  %51 = call i32 @writei(ptr noundef nonnull %10, i32 noundef 0, i32 noundef %49, i32 noundef %50, i32 noundef 64) #8
  %52 = icmp eq i32 %51, 64
  br i1 %52, label %54, label %53

53:                                               ; preds = %47
  call void @panic(ptr noundef nonnull @.str.13) #9
  unreachable

54:                                               ; preds = %47
  %55 = load i16, ptr %27, align 4, !tbaa !38
  %56 = icmp eq i16 %55, 1
  br i1 %56, label %57, label %61

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %10, i32 26
  %59 = load i16, ptr %58, align 2, !tbaa !41
  %60 = add i16 %59, -1
  store i16 %60, ptr %58, align 2, !tbaa !41
  call void @iupdate(ptr noundef nonnull %10) #8
  br label %61

61:                                               ; preds = %57, %54
  call void @iunlockput(ptr noundef nonnull %10) #8
  %62 = load i16, ptr %22, align 2, !tbaa !41
  %63 = add i16 %62, -1
  store i16 %63, ptr %22, align 2, !tbaa !41
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
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %3) #11
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
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #11
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
  br label %5, !llvm.loop !57

15:                                               ; preds = %5
  store i8 0, ptr %12, align 1, !tbaa !3
  %16 = load i8, ptr %0, align 1, !tbaa !3
  %17 = icmp eq i8 %16, 47
  br i1 %17, label %25, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %3, i32 2
  %20 = load ptr, ptr %19, align 4, !tbaa !26
  %21 = icmp eq ptr %20, null
  br i1 %21, label %28, label %22

22:                                               ; preds = %18
  %23 = tail call i32 @fat_is(ptr noundef nonnull %20) #8
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %25, label %28

25:                                               ; preds = %15, %22
  %26 = tail call ptr @namei(ptr noundef nonnull %0) #8
  %27 = icmp eq ptr %26, null
  br i1 %27, label %28, label %34

28:                                               ; preds = %18, %22, %25
  %29 = load i8, ptr %0, align 1, !tbaa !3
  %30 = icmp eq i8 %29, 47
  br i1 %30, label %42, label %31

31:                                               ; preds = %28
  %32 = call ptr @namei(ptr noundef nonnull %2) #8
  %33 = icmp eq ptr %32, null
  br i1 %33, label %42, label %34

34:                                               ; preds = %25, %31
  %35 = phi ptr [ %32, %31 ], [ %26, %25 ]
  call void @ilock(ptr noundef nonnull %35) #8
  %36 = getelementptr inbounds nuw i8, ptr %35, i32 20
  %37 = load i16, ptr %36, align 4, !tbaa !38
  %38 = icmp eq i16 %37, 2
  br i1 %38, label %40, label %39

39:                                               ; preds = %34
  call void @iunlockput(ptr noundef nonnull %35) #8
  br label %42

40:                                               ; preds = %34
  %41 = ptrtoint ptr %35 to i32
  br label %42

42:                                               ; preds = %28, %31, %40, %39
  %43 = phi i32 [ 0, %39 ], [ %41, %40 ], [ 0, %31 ], [ 0, %28 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #11
  ret i32 %43
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

; Function Attrs: minsize optsize
declare dso_local ptr @ialloc(i32 noundef, i16 noundef signext) local_unnamed_addr #3

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
  br label %7, !llvm.loop !58

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

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @dev_prefix(ptr noundef readonly captures(ret: address, provenance) %0) unnamed_addr #7 {
  %2 = load i8, ptr @devmnt, align 1, !tbaa !3
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
  %17 = getelementptr inbounds nuw [8 x i8], ptr @devmnt, i32 0, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3
  br label %7, !llvm.loop !59

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

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @vfs_walk(ptr noundef readonly captures(none) %0) unnamed_addr #1 {
  %2 = alloca [64 x i8], align 1
  %3 = load i8, ptr %0, align 1, !tbaa !3
  %4 = icmp eq i8 %3, 47
  br i1 %4, label %10, label %5

5:                                                ; preds = %1
  %6 = load i32, ptr @curr, align 4, !tbaa !11
  %7 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %6, i32 2
  %8 = load ptr, ptr %7, align 4, !tbaa !26
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %12

10:                                               ; preds = %5, %1
  %11 = tail call ptr @namei(ptr noundef nonnull @.str.5) #8
  br label %24

12:                                               ; preds = %5
  %13 = tail call i32 @fat_is(ptr noundef nonnull %8) #8
  %14 = icmp eq i32 %13, 0
  %15 = load ptr, ptr %7, align 4, !tbaa !26
  br i1 %14, label %17, label %16

16:                                               ; preds = %12
  tail call void @fat_dup(ptr noundef %15) #8
  br label %24

17:                                               ; preds = %12
  %18 = tail call i32 @dev_is(ptr noundef %15) #8
  %19 = icmp eq i32 %18, 0
  %20 = load ptr, ptr %7, align 4, !tbaa !26
  br i1 %19, label %22, label %21

21:                                               ; preds = %17
  tail call void @dev_dup(ptr noundef %20) #8
  br label %24

22:                                               ; preds = %17
  %23 = tail call ptr @idup(ptr noundef %20) #8
  br label %24

24:                                               ; preds = %16, %22, %21, %10
  %25 = phi ptr [ %11, %10 ], [ %15, %16 ], [ %20, %21 ], [ %23, %22 ]
  %26 = icmp eq ptr %25, null
  br i1 %26, label %109, label %27

27:                                               ; preds = %24
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #11
  br label %28

28:                                               ; preds = %94, %27
  %29 = phi ptr [ %25, %27 ], [ %95, %94 ]
  %30 = phi ptr [ %0, %27 ], [ %38, %94 ]
  br label %31

31:                                               ; preds = %34, %28
  %32 = phi ptr [ %30, %28 ], [ %35, %34 ]
  %33 = load i8, ptr %32, align 1, !tbaa !3
  switch i8 %33, label %36 [
    i8 47, label %34
    i8 0, label %107
  ]

34:                                               ; preds = %31
  %35 = getelementptr inbounds nuw i8, ptr %32, i32 1
  br label %31, !llvm.loop !60

36:                                               ; preds = %31, %45
  %37 = phi i8 [ %48, %45 ], [ %33, %31 ]
  %38 = phi ptr [ %47, %45 ], [ %32, %31 ]
  %39 = phi i32 [ %46, %45 ], [ 0, %31 ]
  switch i8 %37, label %40 [
    i8 0, label %49
    i8 47, label %49
  ]

40:                                               ; preds = %36
  %41 = icmp slt i32 %39, 63
  br i1 %41, label %42, label %45

42:                                               ; preds = %40
  %43 = add nsw i32 %39, 1
  %44 = getelementptr inbounds i8, ptr %2, i32 %39
  store i8 %37, ptr %44, align 1, !tbaa !3
  br label %45

45:                                               ; preds = %42, %40
  %46 = phi i32 [ %43, %42 ], [ %39, %40 ]
  %47 = getelementptr inbounds nuw i8, ptr %38, i32 1
  %48 = load i8, ptr %47, align 1, !tbaa !3
  br label %36, !llvm.loop !61

49:                                               ; preds = %36, %36
  %50 = getelementptr inbounds i8, ptr %2, i32 %39
  store i8 0, ptr %50, align 1, !tbaa !3
  %51 = call i32 @fat_is(ptr noundef nonnull %29) #8
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %62, label %53

53:                                               ; preds = %49
  %54 = getelementptr inbounds nuw i8, ptr %29, i32 20
  %55 = load i16, ptr %54, align 4, !tbaa !38
  %56 = icmp eq i16 %55, 1
  br i1 %56, label %57, label %59

57:                                               ; preds = %53
  %58 = call ptr @fat_lookup(ptr noundef nonnull %29, ptr noundef nonnull %2) #8
  br label %59

59:                                               ; preds = %53, %57
  %60 = phi ptr [ %58, %57 ], [ null, %53 ]
  call void @fat_put(ptr noundef nonnull %29) #8
  %61 = icmp eq ptr %60, null
  br i1 %61, label %107, label %94

62:                                               ; preds = %49
  %63 = call i32 @dev_is(ptr noundef nonnull %29) #8
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %74, label %65

65:                                               ; preds = %62
  %66 = getelementptr inbounds nuw i8, ptr %29, i32 20
  %67 = load i16, ptr %66, align 4, !tbaa !38
  %68 = icmp eq i16 %67, 1
  br i1 %68, label %69, label %71

69:                                               ; preds = %65
  %70 = call ptr @dev_lookup(ptr noundef nonnull %29, ptr noundef nonnull %2) #8
  br label %71

71:                                               ; preds = %65, %69
  %72 = phi ptr [ %70, %69 ], [ null, %65 ]
  call void @dev_put(ptr noundef nonnull %29) #8
  %73 = icmp eq ptr %72, null
  br i1 %73, label %107, label %94

74:                                               ; preds = %62
  call void @ilock(ptr noundef nonnull %29) #8
  %75 = getelementptr inbounds nuw i8, ptr %29, i32 20
  %76 = load i16, ptr %75, align 4, !tbaa !38
  %77 = icmp eq i16 %76, 1
  br i1 %77, label %79, label %78

78:                                               ; preds = %74
  call void @iunlockput(ptr noundef nonnull %29) #8
  br label %107

79:                                               ; preds = %74
  %80 = call ptr @dirlookup(ptr noundef nonnull %29, ptr noundef nonnull %2, ptr noundef null) #8
  call void @iunlockput(ptr noundef nonnull %29) #8
  %81 = icmp eq ptr %80, null
  br i1 %81, label %107, label %82

82:                                               ; preds = %79
  %83 = load i32, ptr %80, align 4, !tbaa !17
  %84 = load i32, ptr @fatmnt_dev, align 4, !tbaa !11
  %85 = icmp eq i32 %83, %84
  br i1 %85, label %86, label %96

86:                                               ; preds = %82
  %87 = getelementptr inbounds nuw i8, ptr %80, i32 4
  %88 = load i32, ptr %87, align 4, !tbaa !21
  %89 = load i32, ptr @fatmnt_inum, align 4, !tbaa !11
  %90 = icmp eq i32 %88, %89
  br i1 %90, label %91, label %96

91:                                               ; preds = %86
  call void @iput(ptr noundef nonnull %80) #8
  %92 = call ptr @fat_root() #8
  %93 = icmp eq ptr %92, null
  br i1 %93, label %107, label %94

94:                                               ; preds = %91, %104, %99, %96, %71, %59
  %95 = phi ptr [ %60, %59 ], [ %72, %71 ], [ %92, %91 ], [ %105, %104 ], [ %80, %99 ], [ %80, %96 ]
  br label %28

96:                                               ; preds = %86, %82
  %97 = load i32, ptr @devmnt_dev, align 4, !tbaa !11
  %98 = icmp eq i32 %83, %97
  br i1 %98, label %99, label %94

99:                                               ; preds = %96
  %100 = getelementptr inbounds nuw i8, ptr %80, i32 4
  %101 = load i32, ptr %100, align 4, !tbaa !21
  %102 = load i32, ptr @devmnt_inum, align 4, !tbaa !11
  %103 = icmp eq i32 %101, %102
  br i1 %103, label %104, label %94

104:                                              ; preds = %99
  call void @iput(ptr noundef nonnull %80) #8
  %105 = call ptr @dev_root() #8
  %106 = icmp eq ptr %105, null
  br i1 %106, label %107, label %94

107:                                              ; preds = %71, %59, %104, %91, %79, %31, %78
  %108 = phi ptr [ null, %78 ], [ %29, %31 ], [ null, %79 ], [ null, %91 ], [ null, %104 ], [ null, %59 ], [ null, %71 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #11
  br label %109

109:                                              ; preds = %24, %107
  %110 = phi ptr [ %108, %107 ], [ null, %24 ]
  ret ptr %110
}

; Function Attrs: minsize optsize
declare dso_local ptr @fat_root() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @dev_root() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fat_dup(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @dev_dup(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @fat_lookup(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @dev_lookup(ptr noundef, ptr noundef) local_unnamed_addr #3

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
!17 = !{!18, !12, i64 0}
!18 = !{!"inode", !12, i64 0, !12, i64 4, !12, i64 8, !19, i64 12, !12, i64 16, !20, i64 20, !20, i64 22, !20, i64 24, !20, i64 26, !12, i64 28, !4, i64 32}
!19 = !{!"sleeplock", !4, i64 0}
!20 = !{!"short", !4, i64 0}
!21 = !{!18, !12, i64 4}
!22 = !{!23, !24, i64 4}
!23 = !{!"proc", !12, i64 0, !24, i64 4, !25, i64 8, !4, i64 12}
!24 = !{!"long", !4, i64 0}
!25 = !{!"p1 _ZTS5inode", !15, i64 0}
!26 = !{!23, !25, i64 8}
!27 = distinct !{!27, !7, !8}
!28 = !{!29, !12, i64 0}
!29 = !{!"file", !12, i64 0, !12, i64 4, !4, i64 8, !4, i64 9, !30, i64 12, !25, i64 16, !12, i64 20, !20, i64 24}
!30 = !{!"p1 _ZTS4pipe", !15, i64 0}
!31 = !{!29, !20, i64 24}
!32 = !{!29, !4, i64 8}
!33 = !{!29, !4, i64 9}
!34 = !{!29, !25, i64 16}
!35 = !{!36, !36, i64 0}
!36 = !{!"p1 _ZTS4file", !15, i64 0}
!37 = distinct !{!37, !7, !8}
!38 = !{!18, !20, i64 20}
!39 = !{!18, !20, i64 22}
!40 = !{!18, !20, i64 24}
!41 = !{!18, !20, i64 26}
!42 = distinct !{!42, !7, !8}
!43 = distinct !{!43, !7, !8}
!44 = distinct !{!44, !7, !8}
!45 = distinct !{!45, !7, !8}
!46 = distinct !{!46, !7, !8}
!47 = distinct !{!47, !7, !8}
!48 = distinct !{!48, !7, !8}
!49 = distinct !{!49, !7, !8}
!50 = distinct !{!50, !7, !8}
!51 = distinct !{!51, !7, !8}
!52 = !{!29, !12, i64 20}
!53 = !{!18, !12, i64 28}
!54 = !{!55, !20, i64 0}
!55 = !{!"dirent", !20, i64 0, !4, i64 2}
!56 = distinct !{!56, !7, !8}
!57 = distinct !{!57, !7, !8}
!58 = distinct !{!58, !7, !8}
!59 = distinct !{!59, !7, !8}
!60 = distinct !{!60, !7, !8}
!61 = distinct !{!61, !7, !8}
