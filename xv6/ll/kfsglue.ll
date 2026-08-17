; ModuleID = 'kfsglue.c'
source_filename = "kfsglue.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, ptr, [16 x ptr] }
%struct.devsw = type { ptr, ptr }

@.str = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@fsproc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = external dso_local local_unnamed_addr global i32, align 4
@devsw = external dso_local local_unnamed_addr global [0 x %struct.devsw], align 4
@.str.2 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@fsready = dso_local local_unnamed_addr global i32 0, align 4
@.str.3 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"..\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"create dots\00", align 1
@.str.6 = private unnamed_addr constant [16 x i8] c"create: dirlink\00", align 1

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
  br label %1

1:                                                ; preds = %14, %0
  %2 = phi i32 [ 0, %0 ], [ %15, %14 ]
  %3 = icmp eq i32 %2, 8
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  store i32 1, ptr @fsready, align 4, !tbaa !11
  ret void

5:                                                ; preds = %1
  %6 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %2
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store i32 -1, ptr %7, align 4, !tbaa !17
  %8 = tail call ptr @namei(ptr noundef nonnull @.str.2) #7
  %9 = getelementptr inbounds nuw i8, ptr %6, i32 8
  store ptr %8, ptr %9, align 4, !tbaa !21
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 12
  br label %11

11:                                               ; preds = %16, %5
  %12 = phi i32 [ 0, %5 ], [ %22, %16 ]
  %13 = icmp eq i32 %12, 3
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  %15 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !22

16:                                               ; preds = %11
  %17 = tail call ptr @filealloc() #7
  store i32 3, ptr %17, align 4, !tbaa !23
  %18 = getelementptr inbounds nuw i8, ptr %17, i32 24
  store i16 1, ptr %18, align 4, !tbaa !27
  %19 = getelementptr inbounds nuw i8, ptr %17, i32 8
  store i8 1, ptr %19, align 4, !tbaa !28
  %20 = getelementptr inbounds nuw i8, ptr %17, i32 9
  store i8 1, ptr %20, align 1, !tbaa !29
  %21 = getelementptr inbounds nuw [16 x ptr], ptr %10, i32 0, i32 %12
  store ptr %17, ptr %21, align 4, !tbaa !30
  %22 = add nuw nsw i32 %12, 1
  br label %11, !llvm.loop !32
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
  %19 = load ptr, ptr %18, align 4, !tbaa !30
  %20 = icmp eq ptr %19, null
  br i1 %20, label %23, label %21

21:                                               ; preds = %17
  %22 = tail call ptr @filedup(ptr noundef nonnull %19) #7
  br label %23

23:                                               ; preds = %17, %21
  %24 = phi ptr [ %22, %21 ], [ null, %17 ]
  %25 = getelementptr inbounds nuw [16 x ptr], ptr %9, i32 0, i32 %11
  store ptr %24, ptr %25, align 4, !tbaa !30
  %26 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !33

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

; Function Attrs: minsize optsize
declare dso_local ptr @idup(ptr noundef) local_unnamed_addr #3

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
  %13 = load ptr, ptr %12, align 4, !tbaa !30
  %14 = icmp eq ptr %13, null
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  tail call void @fileclose(ptr noundef nonnull %13) #7
  store ptr null, ptr %12, align 4, !tbaa !30
  br label %16

16:                                               ; preds = %11, %15
  %17 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !34

18:                                               ; preds = %7
  tail call void @iput(ptr noundef nonnull %9) #7
  store ptr null, ptr %8, align 4, !tbaa !21
  br label %19

19:                                               ; preds = %18, %7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @fileclose(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iput(ptr noundef) local_unnamed_addr #3

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
  %10 = load ptr, ptr %9, align 4, !tbaa !30
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
  %10 = load ptr, ptr %9, align 4, !tbaa !30
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
  %8 = load ptr, ptr %7, align 4, !tbaa !30
  %9 = icmp eq ptr %8, null
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store ptr null, ptr %7, align 4, !tbaa !30
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
  %8 = load ptr, ptr %7, align 4, !tbaa !30
  %9 = icmp eq ptr %8, null
  br i1 %9, label %15, label %10

10:                                               ; preds = %5
  %11 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %8) #8
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
  %8 = load ptr, ptr %7, align 4, !tbaa !30
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %11

10:                                               ; preds = %6
  store ptr %0, ptr %7, align 4, !tbaa !30
  br label %13

11:                                               ; preds = %6
  %12 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !35

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
  %9 = load ptr, ptr %8, align 4, !tbaa !30
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
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  %4 = call i32 @pipealloc(ptr noundef nonnull %2, ptr noundef nonnull %3) #7
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %23, label %6

6:                                                ; preds = %1
  %7 = load ptr, ptr %2, align 4, !tbaa !30
  %8 = call fastcc i32 @fdalloc(ptr noundef %7) #8
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %10, label %17

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 4, !tbaa !30
  %12 = call fastcc i32 @fdalloc(ptr noundef %11) #8
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %20

14:                                               ; preds = %10
  %15 = load i32, ptr @curr, align 4, !tbaa !11
  %16 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %15, i32 3, i32 %8
  store ptr null, ptr %16, align 4, !tbaa !30
  br label %17

17:                                               ; preds = %6, %14
  %18 = load ptr, ptr %2, align 4, !tbaa !30
  call void @fileclose(ptr noundef %18) #7
  %19 = load ptr, ptr %3, align 4, !tbaa !30
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
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  ret i32 %24
}

; Function Attrs: minsize optsize
declare dso_local i32 @pipealloc(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 16) i32 @kfs_open(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %3 = inttoptr i32 %0 to ptr
  %4 = and i32 %1, 512
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = tail call fastcc ptr @create(ptr noundef %3, i16 noundef signext 2) #8
  %8 = icmp eq ptr %7, null
  br i1 %8, label %55, label %19

9:                                                ; preds = %2
  %10 = tail call ptr @namei(ptr noundef %3) #7
  %11 = icmp eq ptr %10, null
  br i1 %11, label %55, label %12

12:                                               ; preds = %9
  tail call void @ilock(ptr noundef nonnull %10) #7
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 20
  %14 = load i16, ptr %13, align 4, !tbaa !36
  %15 = icmp eq i16 %14, 1
  %16 = icmp ne i32 %1, 0
  %17 = and i1 %16, %15
  br i1 %17, label %18, label %19

18:                                               ; preds = %12
  tail call void @iunlockput(ptr noundef nonnull %10) #7
  br label %55

19:                                               ; preds = %12, %6
  %20 = phi ptr [ %7, %6 ], [ %10, %12 ]
  %21 = tail call ptr @filealloc() #7
  %22 = icmp eq ptr %21, null
  br i1 %22, label %27, label %23

23:                                               ; preds = %19
  %24 = tail call fastcc i32 @fdalloc(ptr noundef nonnull %21) #8
  %25 = icmp slt i32 %24, 0
  br i1 %25, label %26, label %28

26:                                               ; preds = %23
  tail call void @fileclose(ptr noundef nonnull %21) #7
  br label %27

27:                                               ; preds = %19, %26
  tail call void @iunlockput(ptr noundef nonnull %20) #7
  br label %55

28:                                               ; preds = %23
  %29 = getelementptr inbounds nuw i8, ptr %20, i32 20
  %30 = load i16, ptr %29, align 4, !tbaa !36
  %31 = icmp eq i16 %30, 3
  br i1 %31, label %32, label %36

32:                                               ; preds = %28
  %33 = getelementptr inbounds nuw i8, ptr %20, i32 22
  %34 = load i16, ptr %33, align 2, !tbaa !39
  %35 = getelementptr inbounds nuw i8, ptr %21, i32 24
  store i16 %34, ptr %35, align 4, !tbaa !27
  br label %38

36:                                               ; preds = %28
  %37 = getelementptr inbounds nuw i8, ptr %21, i32 20
  store i32 0, ptr %37, align 4, !tbaa !40
  br label %38

38:                                               ; preds = %36, %32
  %39 = phi i32 [ 3, %32 ], [ 2, %36 ]
  store i32 %39, ptr %21, align 4, !tbaa !23
  %40 = getelementptr inbounds nuw i8, ptr %21, i32 16
  store ptr %20, ptr %40, align 4, !tbaa !41
  %41 = trunc i32 %1 to i8
  %42 = and i8 %41, 1
  %43 = xor i8 %42, 1
  %44 = getelementptr inbounds nuw i8, ptr %21, i32 8
  store i8 %43, ptr %44, align 4, !tbaa !28
  %45 = and i32 %1, 3
  %46 = icmp ne i32 %45, 0
  %47 = zext i1 %46 to i8
  %48 = getelementptr inbounds nuw i8, ptr %21, i32 9
  store i8 %47, ptr %48, align 1, !tbaa !29
  %49 = and i32 %1, 1024
  %50 = icmp ne i32 %49, 0
  %51 = icmp eq i16 %30, 2
  %52 = and i1 %50, %51
  br i1 %52, label %53, label %54

53:                                               ; preds = %38
  tail call void @itrunc(ptr noundef nonnull %20) #7
  br label %54

54:                                               ; preds = %53, %38
  tail call void @iunlock(ptr noundef nonnull %20) #7
  br label %55

55:                                               ; preds = %27, %54, %9, %6, %18
  %56 = phi i32 [ -1, %18 ], [ -1, %6 ], [ -1, %9 ], [ -1, %27 ], [ %24, %54 ]
  ret i32 %56
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @create(ptr noundef %0, i16 noundef signext range(i16 1, 3) %1) unnamed_addr #1 {
  %3 = alloca [14 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 14, ptr nonnull %3) #9
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
  %13 = load i16, ptr %12, align 4, !tbaa !36
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
  store i16 0, ptr %21, align 2, !tbaa !39
  %22 = getelementptr inbounds nuw i8, ptr %18, i32 24
  store i16 0, ptr %22, align 4, !tbaa !43
  %23 = getelementptr inbounds nuw i8, ptr %18, i32 26
  store i16 1, ptr %23, align 2, !tbaa !44
  call void @iupdate(ptr noundef nonnull %18) #7
  %24 = icmp eq i16 %1, 1
  br i1 %24, label %25, label %36

25:                                               ; preds = %20
  %26 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %27 = load i32, ptr %26, align 4, !tbaa !45
  %28 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.3, i32 noundef %27) #7
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %35, label %30

30:                                               ; preds = %25
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %32 = load i32, ptr %31, align 4, !tbaa !45
  %33 = call i32 @dirlink(ptr noundef nonnull %18, ptr noundef nonnull @.str.4, i32 noundef %32) #7
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %35, label %36

35:                                               ; preds = %30, %25
  call void @panic(ptr noundef nonnull @.str.5) #10
  unreachable

36:                                               ; preds = %30, %20
  %37 = getelementptr inbounds nuw i8, ptr %18, i32 4
  %38 = load i32, ptr %37, align 4, !tbaa !45
  %39 = call i32 @dirlink(ptr noundef nonnull %4, ptr noundef nonnull %3, i32 noundef %38) #7
  %40 = icmp slt i32 %39, 0
  br i1 %40, label %41, label %42

41:                                               ; preds = %36
  call void @panic(ptr noundef nonnull @.str.6) #10
  unreachable

42:                                               ; preds = %36
  br i1 %24, label %43, label %47

43:                                               ; preds = %42
  %44 = getelementptr inbounds nuw i8, ptr %4, i32 26
  %45 = load i16, ptr %44, align 2, !tbaa !44
  %46 = add i16 %45, 1
  store i16 %46, ptr %44, align 2, !tbaa !44
  call void @iupdate(ptr noundef nonnull %4) #7
  br label %47

47:                                               ; preds = %42, %43, %16, %9, %11
  %48 = phi ptr [ %7, %11 ], [ %7, %9 ], [ %4, %16 ], [ %4, %43 ], [ %4, %42 ]
  %49 = phi ptr [ null, %11 ], [ null, %9 ], [ null, %16 ], [ %18, %43 ], [ %18, %42 ]
  call void @iunlockput(ptr noundef nonnull %48) #7
  br label %50

50:                                               ; preds = %47, %11, %2
  %51 = phi ptr [ null, %2 ], [ %7, %11 ], [ %49, %47 ]
  call void @llvm.lifetime.end.p0(i64 14, ptr nonnull %3) #9
  ret ptr %51
}

; Function Attrs: minsize optsize
declare dso_local void @ilock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iunlockput(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @itrunc(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iunlock(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_chdir(i32 noundef %0) local_unnamed_addr #1 {
  %2 = load i32, ptr @curr, align 4, !tbaa !11
  %3 = inttoptr i32 %0 to ptr
  %4 = tail call ptr @namei(ptr noundef %3) #7
  %5 = icmp eq ptr %4, null
  br i1 %5, label %17, label %6

6:                                                ; preds = %1
  tail call void @ilock(ptr noundef nonnull %4) #7
  %7 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %8 = load i16, ptr %7, align 4, !tbaa !36
  %9 = icmp eq i16 %8, 1
  br i1 %9, label %11, label %10

10:                                               ; preds = %6
  tail call void @iunlockput(ptr noundef nonnull %4) #7
  br label %17

11:                                               ; preds = %6
  tail call void @iunlock(ptr noundef nonnull %4) #7
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @fsproc, i32 0, i32 %2, i32 2
  %13 = load ptr, ptr %12, align 4, !tbaa !21
  %14 = icmp eq ptr %13, null
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  tail call void @iput(ptr noundef nonnull %13) #7
  br label %16

16:                                               ; preds = %15, %11
  store ptr %4, ptr %12, align 4, !tbaa !21
  br label %17

17:                                               ; preds = %1, %16, %10
  %18 = phi i32 [ -1, %10 ], [ 0, %16 ], [ -1, %1 ]
  ret i32 %18
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfs_mkdir(i32 noundef %0) local_unnamed_addr #1 {
  %2 = inttoptr i32 %0 to ptr
  %3 = tail call fastcc ptr @create(ptr noundef %2, i16 noundef signext 1) #8
  %4 = icmp eq ptr %3, null
  br i1 %4, label %6, label %5

5:                                                ; preds = %1
  tail call void @iunlockput(ptr noundef nonnull %3) #7
  br label %6

6:                                                ; preds = %1, %5
  %7 = phi i32 [ 0, %5 ], [ -1, %1 ]
  ret i32 %7
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_iopen(ptr noundef %0) local_unnamed_addr #1 {
  %2 = tail call ptr @namei(ptr noundef %0) #7
  %3 = icmp eq ptr %2, null
  br i1 %3, label %11, label %4

4:                                                ; preds = %1
  tail call void @ilock(ptr noundef nonnull %2) #7
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %6 = load i16, ptr %5, align 4, !tbaa !36
  %7 = icmp eq i16 %6, 2
  br i1 %7, label %9, label %8

8:                                                ; preds = %4
  tail call void @iunlockput(ptr noundef nonnull %2) #7
  br label %11

9:                                                ; preds = %4
  %10 = ptrtoint ptr %2 to i32
  br label %11

11:                                               ; preds = %1, %9, %8
  %12 = phi i32 [ 0, %8 ], [ %10, %9 ], [ 0, %1 ]
  ret i32 %12
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kfs_iread(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = inttoptr i32 %0 to ptr
  %6 = tail call i32 @readi(ptr noundef %5, i32 noundef 0, i32 noundef %2, i32 noundef %1, i32 noundef %3) #7
  ret i32 %6
}

; Function Attrs: minsize optsize
declare dso_local i32 @readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @kfs_iclose(i32 noundef %0) local_unnamed_addr #1 {
  %2 = inttoptr i32 %0 to ptr
  tail call void @iunlockput(ptr noundef %2) #7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kconsread(i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @nameiparent(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @dirlookup(ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @ialloc(i32 noundef, i16 noundef signext) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @iupdate(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @dirlink(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }
attributes #9 = { nounwind }
attributes #10 = { minsize nobuiltin noreturn optsize "no-builtins" }

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
!30 = !{!31, !31, i64 0}
!31 = !{!"p1 _ZTS4file", !15, i64 0}
!32 = distinct !{!32, !7, !8}
!33 = distinct !{!33, !7, !8}
!34 = distinct !{!34, !7, !8}
!35 = distinct !{!35, !7, !8}
!36 = !{!37, !26, i64 20}
!37 = !{!"inode", !12, i64 0, !12, i64 4, !12, i64 8, !38, i64 12, !12, i64 16, !26, i64 20, !26, i64 22, !26, i64 24, !26, i64 26, !12, i64 28, !4, i64 32}
!38 = !{!"sleeplock", !4, i64 0}
!39 = !{!37, !26, i64 22}
!40 = !{!24, !12, i64 20}
!41 = !{!24, !20, i64 16}
!42 = !{!37, !12, i64 0}
!43 = !{!37, !26, i64 24}
!44 = !{!37, !26, i64 26}
!45 = !{!37, !12, i64 4}
