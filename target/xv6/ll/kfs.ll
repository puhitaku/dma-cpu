; ModuleID = 'fs.c'
source_filename = "fs.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.superblock = type { i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.anon = type { %struct.spinlock, [24 x %struct.inode] }
%struct.spinlock = type { i8 }
%struct.inode = type { i32, i32, i32, %struct.sleeplock, i32, i16, i16, i16, i16, i32, [13 x i32] }
%struct.sleeplock = type { i8 }
%struct.dinode = type { i16, i16, i16, i16, i32, [13 x i32] }
%struct.dirent = type { i16, [62 x i8] }

@sb = dso_local global %struct.superblock zeroinitializer, align 4
@.str = private unnamed_addr constant [20 x i8] c"invalid file system\00", align 1
@itable = dso_local global %struct.anon zeroinitializer, align 4
@.str.1 = private unnamed_addr constant [7 x i8] c"itable\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"inode\00", align 1
@.str.3 = private unnamed_addr constant [19 x i8] c"ialloc: no inodes\0A\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"ilock\00", align 1
@.str.5 = private unnamed_addr constant [15 x i8] c"ilock: no type\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"iunlock\00", align 1
@.str.7 = private unnamed_addr constant [29 x i8] c"ireclaim: orphaned inode %d\0A\00", align 1
@.str.8 = private unnamed_addr constant [18 x i8] c"dirlookup not DIR\00", align 1
@.str.9 = private unnamed_addr constant [15 x i8] c"dirlookup read\00", align 1
@.str.10 = private unnamed_addr constant [13 x i8] c"dirlink read\00", align 1
@.str.11 = private unnamed_addr constant [16 x i8] c"iget: no inodes\00", align 1
@.str.12 = private unnamed_addr constant [19 x i8] c"freeing free block\00", align 1
@.str.13 = private unnamed_addr constant [19 x i8] c"bmap: out of range\00", align 1
@.str.14 = private unnamed_addr constant [23 x i8] c"balloc: out of blocks\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @fsinit(i32 noundef %0) local_unnamed_addr #0 {
  %2 = tail call ptr @bread(i32 noundef %0, i32 noundef 1) #6
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %4 = load ptr, ptr %3, align 4, !tbaa !3
  %5 = tail call ptr @memmove(ptr noundef nonnull @sb, ptr noundef %4, i32 noundef 32) #6
  tail call void @brelse(ptr noundef %2) #6
  %6 = load i32, ptr @sb, align 4, !tbaa !10
  %7 = icmp eq i32 %6, 270544960
  br i1 %7, label %9, label %8

8:                                                ; preds = %1
  tail call void @panic(ptr noundef nonnull @.str) #7
  unreachable

9:                                                ; preds = %1
  tail call void @initlog(i32 noundef %0, ptr noundef nonnull @sb) #6
  tail call void @ireclaim(i32 noundef %0) #8
  ret void
}

; Function Attrs: minsize noreturn optsize
declare dso_local void @panic(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @initlog(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @ireclaim(i32 noundef %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %28, %1
  %3 = phi i32 [ 1, %1 ], [ %29, %28 ]
  %4 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 12), align 4, !tbaa !12
  %5 = icmp ult i32 %3, %4
  br i1 %5, label %7, label %6

6:                                                ; preds = %2
  ret void

7:                                                ; preds = %2
  %8 = lshr i32 %3, 4
  %9 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 24), align 4, !tbaa !13
  %10 = add i32 %9, %8
  %11 = tail call ptr @bread(i32 noundef %0, i32 noundef %10) #6
  %12 = getelementptr inbounds nuw i8, ptr %11, i32 12
  %13 = load ptr, ptr %12, align 4, !tbaa !3
  %14 = and i32 %3, 15
  %15 = getelementptr inbounds nuw %struct.dinode, ptr %13, i32 %14
  %16 = load i16, ptr %15, align 4, !tbaa !14
  %17 = icmp eq i16 %16, 0
  br i1 %17, label %24, label %18

18:                                               ; preds = %7
  %19 = getelementptr inbounds nuw i8, ptr %15, i32 6
  %20 = load i16, ptr %19, align 2, !tbaa !17
  %21 = icmp eq i16 %20, 0
  br i1 %21, label %22, label %24

22:                                               ; preds = %18
  tail call void (ptr, ...) @printk(ptr noundef nonnull @.str.7, i32 noundef %3) #6
  %23 = tail call fastcc ptr @iget(i32 noundef %0, i32 noundef %3) #8
  br label %24

24:                                               ; preds = %22, %18, %7
  %25 = phi ptr [ %23, %22 ], [ null, %18 ], [ null, %7 ]
  tail call void @brelse(ptr noundef nonnull %11) #6
  %26 = icmp eq ptr %25, null
  br i1 %26, label %28, label %27

27:                                               ; preds = %24
  tail call void @begin_op() #6
  tail call void @ilock(ptr noundef nonnull %25) #8
  tail call void @iunlock(ptr noundef nonnull %25) #8
  tail call void @iput(ptr noundef nonnull %25) #8
  tail call void @end_op() #6
  br label %28

28:                                               ; preds = %27, %24
  %29 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !18
}

; Function Attrs: minsize nounwind optsize
define dso_local void @iinit() local_unnamed_addr #0 {
  tail call void @initlock(ptr noundef nonnull @itable, ptr noundef nonnull @.str.1) #6
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %7, %4 ]
  %3 = icmp eq i32 %2, 24
  br i1 %3, label %8, label %4

4:                                                ; preds = %1
  %5 = mul nuw nsw i32 %2, 84
  %6 = getelementptr i8, ptr getelementptr inbounds nuw (i8, ptr @itable, i32 16), i32 %5
  tail call void @initsleeplock(ptr noundef %6, ptr noundef nonnull @.str.2) #6
  %7 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !21

8:                                                ; preds = %1
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local void @initlock(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @initsleeplock(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nounwind optsize
define dso_local ptr @ialloc(i32 noundef %0, i16 noundef signext %1) local_unnamed_addr #0 {
  br label %3

3:                                                ; preds = %21, %2
  %4 = phi i32 [ 1, %2 ], [ %22, %21 ]
  %5 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 12), align 4, !tbaa !12
  %6 = icmp ult i32 %4, %5
  br i1 %6, label %7, label %23

7:                                                ; preds = %3
  %8 = lshr i32 %4, 4
  %9 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 24), align 4, !tbaa !13
  %10 = add i32 %9, %8
  %11 = tail call ptr @bread(i32 noundef %0, i32 noundef %10) #6
  %12 = getelementptr inbounds nuw i8, ptr %11, i32 12
  %13 = load ptr, ptr %12, align 4, !tbaa !3
  %14 = and i32 %4, 15
  %15 = getelementptr inbounds nuw %struct.dinode, ptr %13, i32 %14
  %16 = load i16, ptr %15, align 4, !tbaa !14
  %17 = icmp eq i16 %16, 0
  br i1 %17, label %18, label %21

18:                                               ; preds = %7
  %19 = tail call ptr @memset(ptr noundef nonnull %15, i32 noundef 0, i32 noundef 64) #6
  store i16 %1, ptr %15, align 4, !tbaa !14
  tail call void @log_write(ptr noundef nonnull %11) #6
  tail call void @brelse(ptr noundef nonnull %11) #6
  %20 = tail call fastcc ptr @iget(i32 noundef %0, i32 noundef %4) #8
  br label %24

21:                                               ; preds = %7
  tail call void @brelse(ptr noundef nonnull %11) #6
  %22 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !22

23:                                               ; preds = %3
  tail call void (ptr, ...) @printk(ptr noundef nonnull @.str.3) #6
  br label %24

24:                                               ; preds = %23, %18
  %25 = phi ptr [ %20, %18 ], [ null, %23 ]
  ret ptr %25
}

; Function Attrs: minsize optsize
declare dso_local ptr @bread(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @log_write(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @brelse(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @iget(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  tail call void @acquire(ptr noundef nonnull @itable) #6
  br label %3

3:                                                ; preds = %21, %2
  %4 = phi ptr [ getelementptr inbounds nuw (i8, ptr @itable, i32 4), %2 ], [ %26, %21 ]
  %5 = phi ptr [ null, %2 ], [ %25, %21 ]
  %6 = icmp ult ptr %4, getelementptr inbounds nuw (i8, ptr @itable, i32 2020)
  br i1 %6, label %7, label %27

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %9 = load i32, ptr %8, align 4, !tbaa !23
  %10 = icmp sgt i32 %9, 0
  br i1 %10, label %11, label %21

11:                                               ; preds = %7
  %12 = load i32, ptr %4, align 4, !tbaa !26
  %13 = icmp eq i32 %12, %0
  br i1 %13, label %14, label %21

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !27
  %17 = icmp eq i32 %16, %1
  br i1 %17, label %18, label %21

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %20 = add nuw nsw i32 %9, 1
  store i32 %20, ptr %19, align 4, !tbaa !23
  br label %34

21:                                               ; preds = %14, %11, %7
  %22 = icmp eq ptr %5, null
  %23 = icmp eq i32 %9, 0
  %24 = select i1 %23, ptr %4, ptr null
  %25 = select i1 %22, ptr %24, ptr %5
  %26 = getelementptr inbounds nuw i8, ptr %4, i32 84
  br label %3, !llvm.loop !28

27:                                               ; preds = %3
  %28 = icmp eq ptr %5, null
  br i1 %28, label %29, label %30

29:                                               ; preds = %27
  tail call void @panic(ptr noundef nonnull @.str.11) #7
  unreachable

30:                                               ; preds = %27
  store i32 %0, ptr %5, align 4, !tbaa !26
  %31 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store i32 %1, ptr %31, align 4, !tbaa !27
  %32 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store i32 1, ptr %32, align 4, !tbaa !23
  %33 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 0, ptr %33, align 4, !tbaa !29
  br label %34

34:                                               ; preds = %30, %18
  %35 = phi ptr [ %4, %18 ], [ %5, %30 ]
  tail call void @release(ptr noundef nonnull @itable) #6
  ret ptr %35
}

; Function Attrs: minsize optsize
declare dso_local void @printk(ptr noundef, ...) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @iupdate(ptr noundef %0) local_unnamed_addr #0 {
  %2 = load i32, ptr %0, align 4, !tbaa !26
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !27
  %5 = lshr i32 %4, 4
  %6 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 24), align 4, !tbaa !13
  %7 = add i32 %5, %6
  %8 = tail call ptr @bread(i32 noundef %2, i32 noundef %7) #6
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %10 = load ptr, ptr %9, align 4, !tbaa !3
  %11 = load i32, ptr %3, align 4, !tbaa !27
  %12 = and i32 %11, 15
  %13 = getelementptr inbounds nuw %struct.dinode, ptr %10, i32 %12
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %15 = load i16, ptr %14, align 4, !tbaa !30
  store i16 %15, ptr %13, align 4, !tbaa !14
  %16 = getelementptr inbounds nuw i8, ptr %0, i32 22
  %17 = load i16, ptr %16, align 2, !tbaa !31
  %18 = getelementptr inbounds nuw i8, ptr %13, i32 2
  store i16 %17, ptr %18, align 2, !tbaa !32
  %19 = getelementptr inbounds nuw i8, ptr %0, i32 24
  %20 = load i16, ptr %19, align 4, !tbaa !33
  %21 = getelementptr inbounds nuw i8, ptr %13, i32 4
  store i16 %20, ptr %21, align 4, !tbaa !34
  %22 = getelementptr inbounds nuw i8, ptr %0, i32 26
  %23 = load i16, ptr %22, align 2, !tbaa !35
  %24 = getelementptr inbounds nuw i8, ptr %13, i32 6
  store i16 %23, ptr %24, align 2, !tbaa !17
  %25 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %26 = load i32, ptr %25, align 4, !tbaa !36
  %27 = getelementptr inbounds nuw i8, ptr %13, i32 8
  store i32 %26, ptr %27, align 4, !tbaa !37
  %28 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %29 = getelementptr inbounds nuw i8, ptr %0, i32 32
  %30 = tail call ptr @memmove(ptr noundef nonnull %28, ptr noundef nonnull %29, i32 noundef 52) #6
  tail call void @log_write(ptr noundef %8) #6
  tail call void @brelse(ptr noundef %8) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @idup(ptr noundef returned captures(ret: address, provenance) %0) local_unnamed_addr #0 {
  tail call void @acquire(ptr noundef nonnull @itable) #6
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !23
  %4 = add nsw i32 %3, 1
  store i32 %4, ptr %2, align 4, !tbaa !23
  tail call void @release(ptr noundef nonnull @itable) #6
  ret ptr %0
}

; Function Attrs: minsize optsize
declare dso_local void @acquire(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @release(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @ilock(ptr noundef %0) local_unnamed_addr #0 {
  %2 = icmp eq ptr %0, null
  br i1 %2, label %7, label %3

3:                                                ; preds = %1
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %5 = load i32, ptr %4, align 4, !tbaa !23
  %6 = icmp slt i32 %5, 1
  br i1 %6, label %7, label %8

7:                                                ; preds = %3, %1
  tail call void @panic(ptr noundef nonnull @.str.4) #7
  unreachable

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 12
  tail call void @acquiresleep(ptr noundef nonnull %9) #6
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %11 = load i32, ptr %10, align 4, !tbaa !29
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %46

13:                                               ; preds = %8
  %14 = load i32, ptr %0, align 4, !tbaa !26
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !27
  %17 = lshr i32 %16, 4
  %18 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 24), align 4, !tbaa !13
  %19 = add i32 %17, %18
  %20 = tail call ptr @bread(i32 noundef %14, i32 noundef %19) #6
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 12
  %22 = load ptr, ptr %21, align 4, !tbaa !3
  %23 = load i32, ptr %15, align 4, !tbaa !27
  %24 = and i32 %23, 15
  %25 = getelementptr inbounds nuw %struct.dinode, ptr %22, i32 %24
  %26 = load i16, ptr %25, align 4, !tbaa !14
  %27 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i16 %26, ptr %27, align 4, !tbaa !30
  %28 = getelementptr inbounds nuw i8, ptr %25, i32 2
  %29 = load i16, ptr %28, align 2, !tbaa !32
  %30 = getelementptr inbounds nuw i8, ptr %0, i32 22
  store i16 %29, ptr %30, align 2, !tbaa !31
  %31 = getelementptr inbounds nuw i8, ptr %25, i32 4
  %32 = load i16, ptr %31, align 4, !tbaa !34
  %33 = getelementptr inbounds nuw i8, ptr %0, i32 24
  store i16 %32, ptr %33, align 4, !tbaa !33
  %34 = getelementptr inbounds nuw i8, ptr %25, i32 6
  %35 = load i16, ptr %34, align 2, !tbaa !17
  %36 = getelementptr inbounds nuw i8, ptr %0, i32 26
  store i16 %35, ptr %36, align 2, !tbaa !35
  %37 = getelementptr inbounds nuw i8, ptr %25, i32 8
  %38 = load i32, ptr %37, align 4, !tbaa !37
  %39 = getelementptr inbounds nuw i8, ptr %0, i32 28
  store i32 %38, ptr %39, align 4, !tbaa !36
  %40 = getelementptr inbounds nuw i8, ptr %0, i32 32
  %41 = getelementptr inbounds nuw i8, ptr %25, i32 12
  %42 = tail call ptr @memmove(ptr noundef nonnull %40, ptr noundef nonnull %41, i32 noundef 52) #6
  tail call void @brelse(ptr noundef %20) #6
  store i32 1, ptr %10, align 4, !tbaa !29
  %43 = load i16, ptr %27, align 4, !tbaa !30
  %44 = icmp eq i16 %43, 0
  br i1 %44, label %45, label %46

45:                                               ; preds = %13
  tail call void @panic(ptr noundef nonnull @.str.5) #7
  unreachable

46:                                               ; preds = %13, %8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @acquiresleep(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @iunlock(ptr noundef %0) local_unnamed_addr #0 {
  %2 = icmp eq ptr %0, null
  br i1 %2, label %11, label %3

3:                                                ; preds = %1
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 12
  %5 = tail call i32 @holdingsleep(ptr noundef nonnull %4) #6
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %11, label %7

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %9 = load i32, ptr %8, align 4, !tbaa !23
  %10 = icmp slt i32 %9, 1
  br i1 %10, label %11, label %12

11:                                               ; preds = %7, %3, %1
  tail call void @panic(ptr noundef nonnull @.str.6) #7
  unreachable

12:                                               ; preds = %7
  tail call void @releasesleep(ptr noundef nonnull %4) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @holdingsleep(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @releasesleep(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @iput(ptr noundef %0) local_unnamed_addr #0 {
  tail call void @acquire(ptr noundef nonnull @itable) #6
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !23
  %4 = icmp eq i32 %3, 1
  br i1 %4, label %5, label %17

5:                                                ; preds = %1
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %7 = load i32, ptr %6, align 4, !tbaa !29
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %17, label %9

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 26
  %11 = load i16, ptr %10, align 2, !tbaa !35
  %12 = icmp eq i16 %11, 0
  br i1 %12, label %13, label %17

13:                                               ; preds = %9
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 12
  tail call void @acquiresleep(ptr noundef nonnull %14) #6
  tail call void @release(ptr noundef nonnull @itable) #6
  tail call void @itrunc(ptr noundef nonnull %0) #8
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i16 0, ptr %15, align 4, !tbaa !30
  tail call void @iupdate(ptr noundef nonnull %0) #8
  store i32 0, ptr %6, align 4, !tbaa !29
  tail call void @releasesleep(ptr noundef nonnull %14) #6
  tail call void @acquire(ptr noundef nonnull @itable) #6
  %16 = load i32, ptr %2, align 4, !tbaa !23
  br label %17

17:                                               ; preds = %13, %9, %5, %1
  %18 = phi i32 [ %16, %13 ], [ 1, %9 ], [ 1, %5 ], [ %3, %1 ]
  %19 = add nsw i32 %18, -1
  store i32 %19, ptr %2, align 4, !tbaa !23
  tail call void @release(ptr noundef nonnull @itable) #6
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @itrunc(ptr noundef %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 32
  br label %3

3:                                                ; preds = %12, %1
  %4 = phi i32 [ 0, %1 ], [ %13, %12 ]
  %5 = icmp eq i32 %4, 12
  br i1 %5, label %14, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw [13 x i32], ptr %2, i32 0, i32 %4
  %8 = load i32, ptr %7, align 4, !tbaa !38
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %12, label %10

10:                                               ; preds = %6
  %11 = load i32, ptr %0, align 4, !tbaa !26
  tail call fastcc void @bfree(i32 noundef %11, i32 noundef %8) #8
  store i32 0, ptr %7, align 4, !tbaa !38
  br label %12

12:                                               ; preds = %6, %10
  %13 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !39

14:                                               ; preds = %3
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 80
  %16 = load i32, ptr %15, align 4, !tbaa !38
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %37, label %18

18:                                               ; preds = %14
  %19 = load i32, ptr %0, align 4, !tbaa !26
  %20 = tail call ptr @bread(i32 noundef %19, i32 noundef %16) #6
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 12
  %22 = load ptr, ptr %21, align 4, !tbaa !3
  br label %23

23:                                               ; preds = %32, %18
  %24 = phi i32 [ 0, %18 ], [ %33, %32 ]
  %25 = icmp eq i32 %24, 256
  br i1 %25, label %34, label %26

26:                                               ; preds = %23
  %27 = getelementptr inbounds nuw i32, ptr %22, i32 %24
  %28 = load i32, ptr %27, align 4, !tbaa !38
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %32, label %30

30:                                               ; preds = %26
  %31 = load i32, ptr %0, align 4, !tbaa !26
  tail call fastcc void @bfree(i32 noundef %31, i32 noundef %28) #8
  br label %32

32:                                               ; preds = %26, %30
  %33 = add nuw nsw i32 %24, 1
  br label %23, !llvm.loop !40

34:                                               ; preds = %23
  tail call void @brelse(ptr noundef %20) #6
  %35 = load i32, ptr %0, align 4, !tbaa !26
  %36 = load i32, ptr %15, align 4, !tbaa !38
  tail call fastcc void @bfree(i32 noundef %35, i32 noundef %36) #8
  store i32 0, ptr %15, align 4, !tbaa !38
  br label %37

37:                                               ; preds = %34, %14
  %38 = getelementptr inbounds nuw i8, ptr %0, i32 28
  store i32 0, ptr %38, align 4, !tbaa !36
  tail call void @iupdate(ptr noundef nonnull %0) #8
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @iunlockput(ptr noundef %0) local_unnamed_addr #0 {
  tail call void @iunlock(ptr noundef %0) #8
  tail call void @iput(ptr noundef %0) #8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @begin_op() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @end_op() local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @bfree(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = lshr i32 %1, 13
  %4 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 28), align 4, !tbaa !41
  %5 = add i32 %4, %3
  %6 = tail call ptr @bread(i32 noundef %0, i32 noundef %5) #6
  %7 = and i32 %1, 7
  %8 = shl nuw nsw i32 1, %7
  %9 = getelementptr inbounds nuw i8, ptr %6, i32 12
  %10 = load ptr, ptr %9, align 4, !tbaa !3
  %11 = lshr i32 %1, 3
  %12 = and i32 %11, 1023
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 %12
  %14 = load i8, ptr %13, align 1, !tbaa !42
  %15 = zext i8 %14 to i32
  %16 = and i32 %8, %15
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %19

18:                                               ; preds = %2
  tail call void @panic(ptr noundef nonnull @.str.12) #7
  unreachable

19:                                               ; preds = %2
  %20 = trunc nuw i32 %8 to i8
  %21 = xor i8 %20, -1
  %22 = and i8 %14, %21
  store i8 %22, ptr %13, align 1, !tbaa !42
  tail call void @log_write(ptr noundef nonnull %6) #6
  tail call void @brelse(ptr noundef nonnull %6) #6
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @stati(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) initializes((0, 16)) %1) local_unnamed_addr #4 {
  %3 = load i32, ptr %0, align 4, !tbaa !26
  store i32 %3, ptr %1, align 4, !tbaa !43
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %5 = load i32, ptr %4, align 4, !tbaa !27
  %6 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %5, ptr %6, align 4, !tbaa !46
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %8 = load i16, ptr %7, align 4, !tbaa !30
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i16 %8, ptr %9, align 4, !tbaa !47
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 26
  %11 = load i16, ptr %10, align 2, !tbaa !35
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 10
  store i16 %11, ptr %12, align 2, !tbaa !48
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %14 = load i32, ptr %13, align 4, !tbaa !36
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %14, ptr %15, align 4, !tbaa !49
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @readi(ptr noundef captures(none) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #0 {
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %7 = load i32, ptr %6, align 4, !tbaa !36
  %8 = icmp ugt i32 %3, %7
  br i1 %8, label %41, label %9

9:                                                ; preds = %5
  %10 = add i32 %4, %3
  %11 = icmp ult i32 %10, %3
  br i1 %11, label %41, label %12

12:                                               ; preds = %9
  %13 = icmp ugt i32 %10, %7
  %14 = sub i32 %7, %3
  %15 = select i1 %13, i32 %14, i32 %4
  br label %16

16:                                               ; preds = %37, %12
  %17 = phi i32 [ %3, %12 ], [ %39, %37 ]
  %18 = phi i32 [ 0, %12 ], [ %38, %37 ]
  %19 = phi i32 [ %2, %12 ], [ %40, %37 ]
  %20 = icmp ult i32 %18, %15
  br i1 %20, label %21, label %41

21:                                               ; preds = %16
  %22 = lshr i32 %17, 10
  %23 = tail call fastcc i32 @bmap(ptr noundef nonnull %0, i32 noundef %22) #8
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %41, label %25

25:                                               ; preds = %21
  %26 = load i32, ptr %0, align 4, !tbaa !26
  %27 = tail call ptr @bread(i32 noundef %26, i32 noundef %23) #6
  %28 = sub i32 %15, %18
  %29 = and i32 %17, 1023
  %30 = sub nuw nsw i32 1024, %29
  %31 = tail call i32 @llvm.umin.i32(i32 %28, i32 %30)
  %32 = getelementptr inbounds nuw i8, ptr %27, i32 12
  %33 = load ptr, ptr %32, align 4, !tbaa !3
  %34 = getelementptr inbounds nuw i8, ptr %33, i32 %29
  %35 = tail call i32 @either_copyout(i32 noundef %1, i32 noundef %19, ptr noundef %34, i32 noundef %31) #6
  %36 = icmp eq i32 %35, -1
  tail call void @brelse(ptr noundef %27) #6
  br i1 %36, label %41, label %37

37:                                               ; preds = %25
  %38 = add i32 %31, %18
  %39 = add i32 %31, %17
  %40 = add i32 %31, %19
  br label %16, !llvm.loop !50

41:                                               ; preds = %25, %21, %16, %5, %9
  %42 = phi i32 [ 0, %9 ], [ 0, %5 ], [ -1, %25 ], [ %18, %21 ], [ %18, %16 ]
  ret i32 %42
}

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @bmap(ptr noundef captures(none) %0, i32 noundef range(i32 0, 4194304) %1) unnamed_addr #0 {
  %3 = icmp samesign ult i32 %1, 12
  br i1 %3, label %4, label %14

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 32
  %6 = getelementptr inbounds nuw [13 x i32], ptr %5, i32 0, i32 %1
  %7 = load i32, ptr %6, align 4, !tbaa !38
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %43

9:                                                ; preds = %4
  %10 = load i32, ptr %0, align 4, !tbaa !26
  %11 = tail call fastcc i32 @balloc(i32 noundef %10) #8
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %43, label %13

13:                                               ; preds = %9
  store i32 %11, ptr %6, align 4, !tbaa !38
  br label %43

14:                                               ; preds = %2
  %15 = add nsw i32 %1, -12
  %16 = icmp samesign ult i32 %15, 256
  br i1 %16, label %17, label %42

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %0, i32 80
  %19 = load i32, ptr %18, align 4, !tbaa !38
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %26

21:                                               ; preds = %17
  %22 = load i32, ptr %0, align 4, !tbaa !26
  %23 = tail call fastcc i32 @balloc(i32 noundef %22) #8
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %43, label %25

25:                                               ; preds = %21
  store i32 %23, ptr %18, align 4, !tbaa !38
  br label %26

26:                                               ; preds = %25, %17
  %27 = phi i32 [ %23, %25 ], [ %19, %17 ]
  %28 = load i32, ptr %0, align 4, !tbaa !26
  %29 = tail call ptr @bread(i32 noundef %28, i32 noundef %27) #6
  %30 = getelementptr inbounds nuw i8, ptr %29, i32 12
  %31 = load ptr, ptr %30, align 4, !tbaa !3
  %32 = getelementptr inbounds nuw i32, ptr %31, i32 %15
  %33 = load i32, ptr %32, align 4, !tbaa !38
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %35, label %40

35:                                               ; preds = %26
  %36 = load i32, ptr %0, align 4, !tbaa !26
  %37 = tail call fastcc i32 @balloc(i32 noundef %36) #8
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %40, label %39

39:                                               ; preds = %35
  store i32 %37, ptr %32, align 4, !tbaa !38
  tail call void @log_write(ptr noundef nonnull %29) #6
  br label %40

40:                                               ; preds = %35, %39, %26
  %41 = phi i32 [ %37, %39 ], [ 0, %35 ], [ %33, %26 ]
  tail call void @brelse(ptr noundef nonnull %29) #6
  br label %43

42:                                               ; preds = %14
  tail call void @panic(ptr noundef nonnull @.str.13) #7
  unreachable

43:                                               ; preds = %21, %4, %13, %9, %40
  %44 = phi i32 [ %41, %40 ], [ 0, %9 ], [ %11, %13 ], [ %7, %4 ], [ 0, %21 ]
  ret i32 %44
}

; Function Attrs: minsize optsize
declare dso_local i32 @either_copyout(i32 noundef, i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local i32 @writei(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #0 {
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %7 = load i32, ptr %6, align 4, !tbaa !36
  %8 = icmp ugt i32 %3, %7
  br i1 %8, label %44, label %9

9:                                                ; preds = %5
  %10 = add i32 %4, %3
  %11 = icmp ult i32 %10, %3
  br i1 %11, label %44, label %12

12:                                               ; preds = %9
  %13 = icmp ugt i32 %10, 274432
  br i1 %13, label %44, label %14

14:                                               ; preds = %12, %35
  %15 = phi i32 [ %37, %35 ], [ %3, %12 ]
  %16 = phi i32 [ %36, %35 ], [ 0, %12 ]
  %17 = phi i32 [ %38, %35 ], [ %2, %12 ]
  %18 = icmp ult i32 %16, %4
  br i1 %18, label %19, label %39

19:                                               ; preds = %14
  %20 = lshr i32 %15, 10
  %21 = tail call fastcc i32 @bmap(ptr noundef nonnull %0, i32 noundef %20) #8
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %39, label %23

23:                                               ; preds = %19
  %24 = load i32, ptr %0, align 4, !tbaa !26
  %25 = tail call ptr @bread(i32 noundef %24, i32 noundef %21) #6
  %26 = sub i32 %4, %16
  %27 = and i32 %15, 1023
  %28 = sub nuw nsw i32 1024, %27
  %29 = tail call i32 @llvm.umin.i32(i32 %26, i32 %28)
  %30 = getelementptr inbounds nuw i8, ptr %25, i32 12
  %31 = load ptr, ptr %30, align 4, !tbaa !3
  %32 = getelementptr inbounds nuw i8, ptr %31, i32 %27
  %33 = tail call i32 @either_copyin(ptr noundef %32, i32 noundef %1, i32 noundef %17, i32 noundef %29) #6
  %34 = icmp eq i32 %33, -1
  tail call void @log_write(ptr noundef %25) #6
  tail call void @brelse(ptr noundef %25) #6
  br i1 %34, label %39, label %35

35:                                               ; preds = %23
  %36 = add i32 %29, %16
  %37 = add i32 %29, %15
  %38 = add i32 %29, %17
  br label %14, !llvm.loop !51

39:                                               ; preds = %23, %19, %14
  %40 = load i32, ptr %6, align 4, !tbaa !36
  %41 = icmp ugt i32 %15, %40
  br i1 %41, label %42, label %43

42:                                               ; preds = %39
  store i32 %15, ptr %6, align 4, !tbaa !36
  br label %43

43:                                               ; preds = %42, %39
  tail call void @iupdate(ptr noundef nonnull %0) #8
  br label %44

44:                                               ; preds = %12, %5, %9, %43
  %45 = phi i32 [ %16, %43 ], [ -1, %9 ], [ -1, %5 ], [ -1, %12 ]
  ret i32 %45
}

; Function Attrs: minsize optsize
declare dso_local i32 @either_copyin(ptr noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local i32 @namecmp(ptr noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = tail call i32 @strncmp(ptr noundef %0, ptr noundef %1, i32 noundef 62) #6
  ret i32 %3
}

; Function Attrs: minsize optsize
declare dso_local i32 @strncmp(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local ptr @dirlookup(ptr noundef captures(none) %0, ptr noundef %1, ptr noundef writeonly captures(address_is_null) %2) local_unnamed_addr #0 {
  %4 = alloca %struct.dirent, align 2
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %4) #9
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %6 = load i16, ptr %5, align 4, !tbaa !30
  %7 = icmp eq i16 %6, 1
  br i1 %7, label %8, label %12

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %10 = ptrtoint ptr %4 to i32
  %11 = getelementptr inbounds nuw i8, ptr %4, i32 2
  br label %13

12:                                               ; preds = %3
  tail call void @panic(ptr noundef nonnull @.str.8) #7
  unreachable

13:                                               ; preds = %8, %35
  %14 = phi i32 [ %36, %35 ], [ 0, %8 ]
  %15 = load i32, ptr %9, align 4, !tbaa !36
  %16 = icmp ult i32 %14, %15
  br i1 %16, label %17, label %37

17:                                               ; preds = %13
  %18 = call i32 @readi(ptr noundef nonnull %0, i32 noundef 0, i32 noundef %10, i32 noundef %14, i32 noundef 64) #8
  %19 = icmp eq i32 %18, 64
  br i1 %19, label %21, label %20

20:                                               ; preds = %17
  call void @panic(ptr noundef nonnull @.str.9) #7
  unreachable

21:                                               ; preds = %17
  %22 = load i16, ptr %4, align 2, !tbaa !52
  %23 = icmp eq i16 %22, 0
  br i1 %23, label %35, label %24

24:                                               ; preds = %21
  %25 = call i32 @namecmp(ptr noundef %1, ptr noundef nonnull %11) #8
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %27, label %35

27:                                               ; preds = %24
  %28 = icmp eq ptr %2, null
  br i1 %28, label %30, label %29

29:                                               ; preds = %27
  store i32 %14, ptr %2, align 4, !tbaa !38
  br label %30

30:                                               ; preds = %29, %27
  %31 = load i16, ptr %4, align 2, !tbaa !52
  %32 = zext i16 %31 to i32
  %33 = load i32, ptr %0, align 4, !tbaa !26
  %34 = call fastcc ptr @iget(i32 noundef %33, i32 noundef %32) #8
  br label %37

35:                                               ; preds = %24, %21
  %36 = add i32 %14, 64
  br label %13, !llvm.loop !54

37:                                               ; preds = %13, %30
  %38 = phi ptr [ %34, %30 ], [ null, %13 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %4) #9
  ret ptr %38
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @dirlink(ptr noundef %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = alloca %struct.dirent, align 2
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %4) #9
  %5 = tail call ptr @dirlookup(ptr noundef %0, ptr noundef %1, ptr noundef null) #8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %10

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %9 = ptrtoint ptr %4 to i32
  br label %11

10:                                               ; preds = %3
  tail call void @iput(ptr noundef nonnull %5) #8
  br label %31

11:                                               ; preds = %7, %22
  %12 = phi i32 [ %23, %22 ], [ 0, %7 ]
  %13 = load i32, ptr %8, align 4, !tbaa !36
  %14 = icmp ult i32 %12, %13
  br i1 %14, label %15, label %24

15:                                               ; preds = %11
  %16 = call i32 @readi(ptr noundef nonnull %0, i32 noundef 0, i32 noundef %9, i32 noundef %12, i32 noundef 64) #8
  %17 = icmp eq i32 %16, 64
  br i1 %17, label %19, label %18

18:                                               ; preds = %15
  call void @panic(ptr noundef nonnull @.str.10) #7
  unreachable

19:                                               ; preds = %15
  %20 = load i16, ptr %4, align 2, !tbaa !52
  %21 = icmp eq i16 %20, 0
  br i1 %21, label %24, label %22

22:                                               ; preds = %19
  %23 = add i32 %12, 64
  br label %11, !llvm.loop !55

24:                                               ; preds = %19, %11
  %25 = getelementptr inbounds nuw i8, ptr %4, i32 2
  %26 = call ptr @strncpy(ptr noundef nonnull %25, ptr noundef %1, i32 noundef 62) #6
  %27 = trunc i32 %2 to i16
  store i16 %27, ptr %4, align 2, !tbaa !52
  %28 = call i32 @writei(ptr noundef nonnull %0, i32 noundef 0, i32 noundef %9, i32 noundef %12, i32 noundef 64) #8
  %29 = icmp ne i32 %28, 64
  %30 = sext i1 %29 to i32
  br label %31

31:                                               ; preds = %24, %10
  %32 = phi i32 [ -1, %10 ], [ %30, %24 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %4) #9
  ret i32 %32
}

; Function Attrs: minsize optsize
declare dso_local ptr @strncpy(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local ptr @namei(ptr noundef %0) local_unnamed_addr #0 {
  %2 = alloca [62 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 62, ptr nonnull %2) #9
  %3 = call fastcc ptr @namex(ptr noundef %0, i32 noundef 0, ptr noundef nonnull %2) #8
  call void @llvm.lifetime.end.p0(i64 62, ptr nonnull %2) #9
  ret ptr %3
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @namex(ptr noundef %0, i32 noundef range(i32 0, 2) %1, ptr noundef %2) unnamed_addr #0 {
  %4 = load i8, ptr %0, align 1, !tbaa !42
  %5 = icmp eq i8 %4, 47
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = tail call fastcc ptr @iget(i32 noundef 1, i32 noundef 1) #8
  br label %13

8:                                                ; preds = %3
  %9 = tail call ptr @myproc() #6
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %11 = load ptr, ptr %10, align 4, !tbaa !56
  %12 = tail call ptr @idup(ptr noundef %11) #8
  br label %13

13:                                               ; preds = %8, %6
  %14 = phi ptr [ %7, %6 ], [ %11, %8 ]
  %15 = icmp eq i32 %1, 0
  br label %16

16:                                               ; preds = %61, %13
  %17 = phi ptr [ %0, %13 ], [ %42, %61 ]
  %18 = phi ptr [ %14, %13 ], [ %62, %61 ]
  br label %19

19:                                               ; preds = %22, %16
  %20 = phi ptr [ %17, %16 ], [ %23, %22 ]
  %21 = load i8, ptr %20, align 1, !tbaa !42
  switch i8 %21, label %24 [
    i8 47, label %22
    i8 0, label %64
  ]

22:                                               ; preds = %19
  %23 = getelementptr inbounds nuw i8, ptr %20, i32 1
  br label %19, !llvm.loop !59

24:                                               ; preds = %19, %27
  %25 = phi i8 [ %29, %27 ], [ %21, %19 ]
  %26 = phi ptr [ %28, %27 ], [ %20, %19 ]
  switch i8 %25, label %27 [
    i8 47, label %30
    i8 0, label %30
  ]

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw i8, ptr %26, i32 1
  %29 = load i8, ptr %28, align 1, !tbaa !42
  br label %24, !llvm.loop !60

30:                                               ; preds = %24, %24
  %31 = ptrtoint ptr %26 to i32
  %32 = ptrtoint ptr %20 to i32
  %33 = sub i32 %31, %32
  %34 = icmp sgt i32 %33, 61
  br i1 %34, label %35, label %37

35:                                               ; preds = %30
  %36 = tail call ptr @memmove(ptr noundef %2, ptr noundef nonnull %20, i32 noundef 62) #6
  br label %40

37:                                               ; preds = %30
  %38 = tail call ptr @memmove(ptr noundef %2, ptr noundef nonnull %20, i32 noundef %33) #6
  %39 = getelementptr inbounds i8, ptr %2, i32 %33
  store i8 0, ptr %39, align 1, !tbaa !42
  br label %40

40:                                               ; preds = %37, %35
  br label %41

41:                                               ; preds = %40, %41
  %42 = phi ptr [ %45, %41 ], [ %26, %40 ]
  %43 = load i8, ptr %42, align 1, !tbaa !42
  %44 = icmp eq i8 %43, 47
  %45 = getelementptr inbounds nuw i8, ptr %42, i32 1
  br i1 %44, label %41, label %46, !llvm.loop !61

46:                                               ; preds = %41
  tail call void @ilock(ptr noundef %18) #8
  %47 = getelementptr inbounds nuw i8, ptr %18, i32 20
  %48 = load i16, ptr %47, align 4, !tbaa !30
  %49 = icmp eq i16 %48, 1
  br i1 %49, label %51, label %50

50:                                               ; preds = %46
  tail call void @iunlockput(ptr noundef nonnull %18) #8
  br label %66

51:                                               ; preds = %46
  %52 = getelementptr inbounds nuw i8, ptr %18, i32 26
  %53 = load i16, ptr %52, align 2, !tbaa !35
  %54 = icmp eq i16 %53, 0
  br i1 %54, label %55, label %56

55:                                               ; preds = %51
  tail call void @iunlockput(ptr noundef nonnull %18) #8
  br label %66

56:                                               ; preds = %51
  br i1 %15, label %61, label %57

57:                                               ; preds = %56
  %58 = load i8, ptr %42, align 1, !tbaa !42
  %59 = icmp eq i8 %58, 0
  br i1 %59, label %60, label %61

60:                                               ; preds = %57
  tail call void @iunlock(ptr noundef nonnull %18) #8
  br label %66

61:                                               ; preds = %57, %56
  %62 = tail call ptr @dirlookup(ptr noundef nonnull %18, ptr noundef %2, ptr noundef null) #8
  %63 = icmp eq ptr %62, null
  tail call void @iunlockput(ptr noundef nonnull %18) #8
  br i1 %63, label %66, label %16, !llvm.loop !62

64:                                               ; preds = %19
  br i1 %15, label %66, label %65

65:                                               ; preds = %64
  tail call void @iput(ptr noundef %18) #8
  br label %66

66:                                               ; preds = %61, %64, %65, %60, %55, %50
  %67 = phi ptr [ null, %50 ], [ null, %55 ], [ %18, %60 ], [ null, %65 ], [ %18, %64 ], [ null, %61 ]
  ret ptr %67
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @nameiparent(ptr noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = tail call fastcc ptr @namex(ptr noundef %0, i32 noundef 1, ptr noundef %1) #8
  ret ptr %3
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, -1) i32 @balloc(i32 noundef %0) unnamed_addr #0 {
  br label %2

2:                                                ; preds = %38, %1
  %3 = phi i32 [ 0, %1 ], [ %39, %38 ]
  %4 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 4), align 4, !tbaa !63
  %5 = icmp ult i32 %3, %4
  br i1 %5, label %6, label %40

6:                                                ; preds = %2
  %7 = lshr exact i32 %3, 13
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 28), align 4, !tbaa !41
  %9 = add i32 %8, %7
  %10 = tail call ptr @bread(i32 noundef %0, i32 noundef %9) #6
  %11 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sb, i32 4), align 4
  %12 = getelementptr inbounds nuw i8, ptr %10, i32 12
  br label %13

13:                                               ; preds = %19, %6
  %14 = phi i32 [ 0, %6 ], [ %29, %19 ]
  %15 = icmp eq i32 %14, 8192
  br i1 %15, label %38, label %16

16:                                               ; preds = %13
  %17 = or disjoint i32 %14, %3
  %18 = icmp ult i32 %17, %11
  br i1 %18, label %19, label %38

19:                                               ; preds = %16
  %20 = and i32 %14, 7
  %21 = shl nuw nsw i32 1, %20
  %22 = load ptr, ptr %12, align 4, !tbaa !3
  %23 = lshr i32 %14, 3
  %24 = getelementptr inbounds nuw i8, ptr %22, i32 %23
  %25 = load i8, ptr %24, align 1, !tbaa !42
  %26 = zext i8 %25 to i32
  %27 = and i32 %21, %26
  %28 = icmp eq i32 %27, 0
  %29 = add nuw nsw i32 %14, 1
  br i1 %28, label %30, label %13, !llvm.loop !64

30:                                               ; preds = %19
  %31 = getelementptr inbounds nuw i8, ptr %22, i32 %23
  %32 = trunc nuw i32 %21 to i8
  %33 = or i8 %25, %32
  store i8 %33, ptr %31, align 1, !tbaa !42
  tail call void @log_write(ptr noundef nonnull %10) #6
  tail call void @brelse(ptr noundef nonnull %10) #6
  %34 = tail call ptr @bread(i32 noundef %0, i32 noundef %17) #6
  %35 = getelementptr inbounds nuw i8, ptr %34, i32 12
  %36 = load ptr, ptr %35, align 4, !tbaa !3
  %37 = tail call ptr @memset(ptr noundef %36, i32 noundef 0, i32 noundef 1024) #6
  tail call void @log_write(ptr noundef %34) #6
  tail call void @brelse(ptr noundef %34) #6
  br label %41

38:                                               ; preds = %13, %16
  tail call void @brelse(ptr noundef %10) #6
  %39 = add nuw nsw i32 %3, 8192
  br label %2, !llvm.loop !65

40:                                               ; preds = %2
  tail call void (ptr, ...) @printk(ptr noundef nonnull @.str.14) #6
  br label %41

41:                                               ; preds = %40, %30
  %42 = phi i32 [ %17, %30 ], [ 0, %40 ]
  ret i32 %42
}

; Function Attrs: minsize optsize
declare dso_local ptr @myproc() local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }
attributes #9 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !8, i64 12}
!4 = !{!"buf", !5, i64 0, !5, i64 4, !5, i64 8, !8, i64 12}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"p1 omnipotent char", !9, i64 0}
!9 = !{!"any pointer", !6, i64 0}
!10 = !{!11, !5, i64 0}
!11 = !{!"superblock", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16, !5, i64 20, !5, i64 24, !5, i64 28}
!12 = !{!11, !5, i64 12}
!13 = !{!11, !5, i64 24}
!14 = !{!15, !16, i64 0}
!15 = !{!"dinode", !16, i64 0, !16, i64 2, !16, i64 4, !16, i64 6, !5, i64 8, !6, i64 12}
!16 = !{!"short", !6, i64 0}
!17 = !{!15, !16, i64 6}
!18 = distinct !{!18, !19, !20}
!19 = !{!"llvm.loop.mustprogress"}
!20 = !{!"llvm.loop.unroll.disable"}
!21 = distinct !{!21, !19, !20}
!22 = distinct !{!22, !19, !20}
!23 = !{!24, !5, i64 8}
!24 = !{!"inode", !5, i64 0, !5, i64 4, !5, i64 8, !25, i64 12, !5, i64 16, !16, i64 20, !16, i64 22, !16, i64 24, !16, i64 26, !5, i64 28, !6, i64 32}
!25 = !{!"sleeplock", !6, i64 0}
!26 = !{!24, !5, i64 0}
!27 = !{!24, !5, i64 4}
!28 = distinct !{!28, !19, !20}
!29 = !{!24, !5, i64 16}
!30 = !{!24, !16, i64 20}
!31 = !{!24, !16, i64 22}
!32 = !{!15, !16, i64 2}
!33 = !{!24, !16, i64 24}
!34 = !{!15, !16, i64 4}
!35 = !{!24, !16, i64 26}
!36 = !{!24, !5, i64 28}
!37 = !{!15, !5, i64 8}
!38 = !{!5, !5, i64 0}
!39 = distinct !{!39, !19, !20}
!40 = distinct !{!40, !19, !20}
!41 = !{!11, !5, i64 28}
!42 = !{!6, !6, i64 0}
!43 = !{!44, !5, i64 0}
!44 = !{!"stat", !5, i64 0, !5, i64 4, !16, i64 8, !16, i64 10, !45, i64 12}
!45 = !{!"long", !6, i64 0}
!46 = !{!44, !5, i64 4}
!47 = !{!44, !16, i64 8}
!48 = !{!44, !16, i64 10}
!49 = !{!44, !45, i64 12}
!50 = distinct !{!50, !19, !20}
!51 = distinct !{!51, !19, !20}
!52 = !{!53, !16, i64 0}
!53 = !{!"dirent", !16, i64 0, !6, i64 2}
!54 = distinct !{!54, !19, !20}
!55 = distinct !{!55, !19, !20}
!56 = !{!57, !58, i64 8}
!57 = !{!"proc", !5, i64 0, !45, i64 4, !58, i64 8, !6, i64 12}
!58 = !{!"p1 _ZTS5inode", !9, i64 0}
!59 = distinct !{!59, !19, !20}
!60 = distinct !{!60, !19, !20}
!61 = distinct !{!61, !19, !20}
!62 = distinct !{!62, !19, !20}
!63 = !{!11, !5, i64 4}
!64 = distinct !{!64, !19, !20}
!65 = distinct !{!65, !19, !20}
