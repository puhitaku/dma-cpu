; ModuleID = 'dma/toolbox.c'
source_filename = "dma/toolbox.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"kill\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"free\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"sync\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"clear\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"mount\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"umount\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"mkdir\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c"rm\00", align 1
@.str.9 = private unnamed_addr constant [87 x i8] c"toolbox: kill spin trap free sync mount umount wc mkdir rm gpio mux blink fbtest show\0A\00", align 1
@.str.10 = private unnamed_addr constant [20 x i8] c"usage: kill pid...\0A\00", align 1
@.str.11 = private unnamed_addr constant [22 x i8] c"free: meminfo failed\0A\00", align 1
@.str.12 = private unnamed_addr constant [14 x i8] c"arena: total \00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"  used \00", align 1
@.str.14 = private unnamed_addr constant [8 x i8] c"  free \00", align 1
@.str.15 = private unnamed_addr constant [11 x i8] c"  largest \00", align 1
@.str.16 = private unnamed_addr constant [14 x i8] c"\0Aof it: heap \00", align 1
@.str.17 = private unnamed_addr constant [8 x i8] c"  exec \00", align 1
@.str.18 = private unnamed_addr constant [9 x i8] c"\0Aprocs: \00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"  uptime \00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c" ticks\0A\00", align 1
@obuf = internal global [256 x i8] zeroinitializer, align 1
@olen = internal unnamed_addr global i32 0, align 4
@.str.22 = private unnamed_addr constant [21 x i8] c"sync: not supported\0A\00", align 1
@.str.23 = private unnamed_addr constant [8 x i8] c"\1B[2J\1B[H\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"-u\00", align 1
@.str.25 = private unnamed_addr constant [38 x i8] c"umount: failed (busy or not mounted)\0A\00", align 1
@.str.26 = private unnamed_addr constant [15 x i8] c"mount: failed\0A\00", align 1
@.str.27 = private unnamed_addr constant [38 x i8] c"usage: mount [fat0|sd0 DIR | -u DIR]\0A\00", align 1
@.str.28 = private unnamed_addr constant [20 x i8] c"usage: umount /dir\0A\00", align 1
@.str.29 = private unnamed_addr constant [21 x i8] c"usage: mkdir dir...\0A\00", align 1
@.str.30 = private unnamed_addr constant [15 x i8] c"mkdir: failed\0A\00", align 1
@.str.31 = private unnamed_addr constant [19 x i8] c"usage: rm file...\0A\00", align 1
@.str.32 = private unnamed_addr constant [12 x i8] c"rm: failed\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %0, 0
  br i1 %3, label %4, label %8

4:                                                ; preds = %2
  %5 = load ptr, ptr %1, align 4, !tbaa !3
  %6 = icmp eq ptr %5, null
  %7 = select i1 %6, ptr @.str, ptr %5
  br label %8

8:                                                ; preds = %4, %2
  %9 = phi ptr [ %7, %4 ], [ @.str, %2 ]
  br label %10

10:                                               ; preds = %8, %19
  %11 = phi ptr [ %20, %19 ], [ %9, %8 ]
  %12 = phi ptr [ %21, %19 ], [ %9, %8 ]
  %13 = load i8, ptr %12, align 1, !tbaa !8
  switch i8 %13, label %19 [
    i8 0, label %14
    i8 47, label %17
  ]

14:                                               ; preds = %10
  %15 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.1) #8
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %25, label %22

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %12, i32 1
  br label %19

19:                                               ; preds = %10, %17
  %20 = phi ptr [ %18, %17 ], [ %11, %10 ]
  %21 = getelementptr inbounds nuw i8, ptr %12, i32 1
  br label %10, !llvm.loop !9

22:                                               ; preds = %14
  %23 = tail call fastcc i32 @t_kill(i32 noundef %0, ptr noundef %1) #8
  %24 = tail call i32 @exit(i32 noundef %23) #9
  unreachable

25:                                               ; preds = %14
  %26 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.2) #8
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %31, label %28

28:                                               ; preds = %25
  %29 = tail call fastcc i32 @t_free() #8
  %30 = tail call i32 @exit(i32 noundef %29) #9
  unreachable

31:                                               ; preds = %25
  %32 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.3) #8
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %37, label %34

34:                                               ; preds = %31
  %35 = tail call fastcc i32 @t_sync() #8
  %36 = tail call i32 @exit(i32 noundef %35) #9
  unreachable

37:                                               ; preds = %31
  %38 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.4) #8
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %42, label %40

40:                                               ; preds = %37
  tail call fastcc void @t_clear() #8
  %41 = tail call i32 @exit(i32 noundef 0) #9
  unreachable

42:                                               ; preds = %37
  %43 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.5) #8
  %44 = icmp eq i32 %43, 0
  br i1 %44, label %48, label %45

45:                                               ; preds = %42
  %46 = tail call fastcc i32 @t_mount(i32 noundef %0, ptr noundef %1) #8
  %47 = tail call i32 @exit(i32 noundef %46) #9
  unreachable

48:                                               ; preds = %42
  %49 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.6) #8
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %54, label %51

51:                                               ; preds = %48
  %52 = tail call fastcc i32 @t_umount(i32 noundef %0, ptr noundef %1) #8
  %53 = tail call i32 @exit(i32 noundef %52) #9
  unreachable

54:                                               ; preds = %48
  %55 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.7) #8
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %60, label %57

57:                                               ; preds = %54
  %58 = tail call fastcc i32 @t_mkdir(i32 noundef %0, ptr noundef %1) #8
  %59 = tail call i32 @exit(i32 noundef %58) #9
  unreachable

60:                                               ; preds = %54
  %61 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.8) #8
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %66, label %63

63:                                               ; preds = %60
  %64 = tail call fastcc i32 @t_rm(i32 noundef %0, ptr noundef %1) #8
  %65 = tail call i32 @exit(i32 noundef %64) #9
  unreachable

66:                                               ; preds = %60
  %67 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.9, i32 noundef 87) #10
  %68 = tail call i32 @exit(i32 noundef 1) #9
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @streq(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #2 {
  br label %3

3:                                                ; preds = %11, %2
  %4 = phi ptr [ %0, %2 ], [ %12, %11 ]
  %5 = phi ptr [ %1, %2 ], [ %13, %11 ]
  %6 = load i8, ptr %4, align 1, !tbaa !8
  %7 = icmp ne i8 %6, 0
  %8 = load i8, ptr %5, align 1, !tbaa !8
  %9 = icmp eq i8 %6, %8
  %10 = select i1 %7, i1 %9, i1 false
  br i1 %10, label %11, label %14

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !12

14:                                               ; preds = %3
  %15 = zext i1 %9 to i32
  ret i32 %15
}

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_kill(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.10, i32 noundef 19) #10
  br label %15

6:                                                ; preds = %2, %9
  %7 = phi i32 [ %14, %9 ], [ 1, %2 ]
  %8 = icmp eq i32 %7, %0
  br i1 %8, label %15, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw ptr, ptr %1, i32 %7
  %11 = load ptr, ptr %10, align 4, !tbaa !3
  %12 = tail call i32 @atoi(ptr noundef %11) #10
  %13 = tail call i32 @kill(i32 noundef %12) #10
  %14 = add nuw i32 %7, 1
  br label %6, !llvm.loop !13

15:                                               ; preds = %6, %4
  %16 = phi i32 [ 1, %4 ], [ 0, %6 ]
  ret i32 %16
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_free() unnamed_addr #4 {
  %1 = alloca [8 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #11
  %2 = call i32 @meminfo(ptr noundef nonnull %1) #10
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %0
  %5 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.11, i32 noundef 21) #10
  br label %27

6:                                                ; preds = %0
  call fastcc void @emit(ptr noundef nonnull @.str.12) #8
  %7 = load i32, ptr %1, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %7) #8
  call fastcc void @emit(ptr noundef nonnull @.str.13) #8
  %8 = load i32, ptr %1, align 4, !tbaa !14
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %10 = load i32, ptr %9, align 4, !tbaa !14
  %11 = sub i32 %8, %10
  call fastcc void @emitn(i32 noundef %11) #8
  call fastcc void @emit(ptr noundef nonnull @.str.14) #8
  %12 = load i32, ptr %9, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %12) #8
  call fastcc void @emit(ptr noundef nonnull @.str.15) #8
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %14 = load i32, ptr %13, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %14) #8
  call fastcc void @emit(ptr noundef nonnull @.str.16) #8
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %16 = load i32, ptr %15, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %16) #8
  call fastcc void @emit(ptr noundef nonnull @.str.17) #8
  %17 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %18 = load i32, ptr %17, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %18) #8
  call fastcc void @emit(ptr noundef nonnull @.str.18) #8
  %19 = getelementptr inbounds nuw i8, ptr %1, i32 20
  %20 = load i32, ptr %19, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %20) #8
  call fastcc void @emit(ptr noundef nonnull @.str.19) #8
  %21 = getelementptr inbounds nuw i8, ptr %1, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %22) #8
  call fastcc void @emit(ptr noundef nonnull @.str.20) #8
  %23 = getelementptr inbounds nuw i8, ptr %1, i32 28
  %24 = load i32, ptr %23, align 4, !tbaa !14
  call fastcc void @emitn(i32 noundef %24) #8
  call fastcc void @emit(ptr noundef nonnull @.str.21) #8
  %25 = load i32, ptr @olen, align 4, !tbaa !14
  %26 = call i32 @write(i32 noundef 1, ptr noundef nonnull @obuf, i32 noundef %25) #10
  store i32 0, ptr @olen, align 4, !tbaa !14
  br label %27

27:                                               ; preds = %6, %4
  %28 = phi i32 [ 1, %4 ], [ 0, %6 ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #11
  ret i32 %28
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_sync() unnamed_addr #4 {
  %1 = tail call i32 @sync() #10
  %2 = icmp slt i32 %1, 0
  br i1 %2, label %3, label %5

3:                                                ; preds = %0
  %4 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.22, i32 noundef 20) #10
  br label %5

5:                                                ; preds = %0, %3
  %6 = phi i32 [ 1, %3 ], [ 0, %0 ]
  ret i32 %6
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @t_clear() unnamed_addr #4 {
  %1 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.23, i32 noundef 7) #10
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_mount(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = alloca [64 x i8], align 1
  switch i32 %0, label %27 [
    i32 1, label %4
    i32 3, label %10
  ]

4:                                                ; preds = %2
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %3) #11
  %5 = call i32 @mount(ptr noundef null, ptr noundef nonnull %3) #10
  %6 = icmp sgt i32 %5, 0
  br i1 %6, label %7, label %9

7:                                                ; preds = %4
  %8 = call i32 @write(i32 noundef 1, ptr noundef nonnull %3, i32 noundef %5) #10
  br label %9

9:                                                ; preds = %7, %4
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %3) #11
  br label %29

10:                                               ; preds = %2
  %11 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %12 = load ptr, ptr %11, align 4, !tbaa !3
  %13 = tail call fastcc i32 @streq(ptr noundef %12, ptr noundef nonnull @.str.24) #8
  %14 = icmp eq i32 %13, 0
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %16 = load ptr, ptr %15, align 4, !tbaa !3
  br i1 %14, label %22, label %17

17:                                               ; preds = %10
  %18 = tail call i32 @umount(ptr noundef %16) #10
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %29

20:                                               ; preds = %17
  %21 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.25, i32 noundef 37) #10
  br label %29

22:                                               ; preds = %10
  %23 = tail call i32 @mount(ptr noundef %12, ptr noundef %16) #10
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %25, label %29

25:                                               ; preds = %22
  %26 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.26, i32 noundef 14) #10
  br label %29

27:                                               ; preds = %2
  %28 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.27, i32 noundef 37) #10
  br label %29

29:                                               ; preds = %22, %17, %27, %25, %20, %9
  %30 = phi i32 [ 0, %9 ], [ 1, %20 ], [ 1, %25 ], [ 1, %27 ], [ 0, %17 ], [ 0, %22 ]
  ret i32 %30
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_umount(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp eq i32 %0, 2
  br i1 %3, label %6, label %4

4:                                                ; preds = %2
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.28, i32 noundef 19) #10
  br label %13

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %8 = load ptr, ptr %7, align 4, !tbaa !3
  %9 = tail call i32 @umount(ptr noundef %8) #10
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %6
  %12 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.25, i32 noundef 37) #10
  br label %13

13:                                               ; preds = %6, %11, %4
  %14 = phi i32 [ 1, %4 ], [ 1, %11 ], [ 0, %6 ]
  ret i32 %14
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_mkdir(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.29, i32 noundef 20) #10
  br label %19

6:                                                ; preds = %2, %9
  %7 = phi i32 [ %14, %9 ], [ 1, %2 ]
  %8 = icmp eq i32 %7, %0
  br i1 %8, label %19, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw ptr, ptr %1, i32 %7
  %11 = load ptr, ptr %10, align 4, !tbaa !3
  %12 = tail call i32 @mkdir(ptr noundef %11) #10
  %13 = icmp slt i32 %12, 0
  %14 = add nuw i32 %7, 1
  br i1 %13, label %15, label %6, !llvm.loop !16

15:                                               ; preds = %9
  %16 = icmp slt i32 %7, %0
  %17 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.30, i32 noundef 14) #10
  %18 = zext i1 %16 to i32
  br label %19

19:                                               ; preds = %6, %15, %4
  %20 = phi i32 [ 1, %4 ], [ %18, %15 ], [ 0, %6 ]
  ret i32 %20
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_rm(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.31, i32 noundef 18) #10
  br label %19

6:                                                ; preds = %2, %9
  %7 = phi i32 [ %14, %9 ], [ 1, %2 ]
  %8 = icmp eq i32 %7, %0
  br i1 %8, label %19, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw ptr, ptr %1, i32 %7
  %11 = load ptr, ptr %10, align 4, !tbaa !3
  %12 = tail call i32 @unlink(ptr noundef %11) #10
  %13 = icmp slt i32 %12, 0
  %14 = add nuw i32 %7, 1
  br i1 %13, label %15, label %6, !llvm.loop !17

15:                                               ; preds = %9
  %16 = icmp slt i32 %7, %0
  %17 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.32, i32 noundef 11) #10
  %18 = zext i1 %16 to i32
  br label %19

19:                                               ; preds = %6, %15, %4
  %20 = phi i32 [ 1, %4 ], [ %18, %15 ], [ 0, %6 ]
  ret i32 %20
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @kill(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @atoi(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @meminfo(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none)
define internal fastcc void @emit(ptr noundef readonly captures(none) %0) unnamed_addr #6 {
  %2 = load i32, ptr @olen, align 4
  br label %3

3:                                                ; preds = %8, %1
  %4 = phi i32 [ %2, %1 ], [ %10, %8 ]
  %5 = phi ptr [ %0, %1 ], [ %9, %8 ]
  %6 = load i8, ptr %5, align 1, !tbaa !8
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %12, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %10 = add nsw i32 %4, 1
  store i32 %10, ptr @olen, align 4, !tbaa !14
  %11 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %4
  store i8 %6, ptr %11, align 1, !tbaa !8
  br label %3, !llvm.loop !18

12:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @emitn(i32 noundef %0) unnamed_addr #7 {
  %2 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %2) #11
  br label %3

3:                                                ; preds = %3, %1
  %4 = phi i32 [ %0, %1 ], [ %7, %3 ]
  %5 = phi i32 [ 0, %1 ], [ %12, %3 ]
  %6 = freeze i32 %4
  %7 = udiv i32 %6, 10
  %8 = mul i32 %7, 10
  %9 = sub i32 %6, %8
  %10 = trunc nuw nsw i32 %9 to i8
  %11 = or disjoint i8 %10, 48
  %12 = add nuw nsw i32 %5, 1
  %13 = getelementptr inbounds nuw [12 x i8], ptr %2, i32 0, i32 %5
  store i8 %11, ptr %13, align 1, !tbaa !8
  %14 = icmp ult i32 %4, 10
  br i1 %14, label %15, label %3, !llvm.loop !19

15:                                               ; preds = %3
  %16 = load i32, ptr @olen, align 4, !tbaa !14
  br label %17

17:                                               ; preds = %15, %21
  %18 = phi i32 [ %25, %21 ], [ %16, %15 ]
  %19 = phi i32 [ %22, %21 ], [ %12, %15 ]
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %27, label %21

21:                                               ; preds = %17
  %22 = add nsw i32 %19, -1
  %23 = getelementptr inbounds [12 x i8], ptr %2, i32 0, i32 %22
  %24 = load i8, ptr %23, align 1, !tbaa !8
  %25 = add nsw i32 %18, 1
  %26 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %18
  store i8 %24, ptr %26, align 1, !tbaa !8
  br label %17, !llvm.loop !20

27:                                               ; preds = %17
  store i32 %18, ptr @olen, align 4, !tbaa !14
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %2) #11
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @sync() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @mount(ptr noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @umount(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @mkdir(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @unlink(ptr noundef) local_unnamed_addr #5

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }
attributes #9 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #10 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #11 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"p1 omnipotent char", !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!6, !6, i64 0}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = distinct !{!13, !10, !11}
!14 = !{!15, !15, i64 0}
!15 = !{!"int", !6, i64 0}
!16 = distinct !{!16, !10, !11}
!17 = distinct !{!17, !10, !11}
!18 = distinct !{!18, !10, !11}
!19 = distinct !{!19, !10, !11}
!20 = distinct !{!20, !10, !11}
