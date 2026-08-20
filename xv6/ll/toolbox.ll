; ModuleID = 'dma/toolbox.c'
source_filename = "dma/toolbox.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"kill\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"spin\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"trap\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"free\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"sync\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"help\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"mount\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"umount\00", align 1
@.str.9 = private unnamed_addr constant [3 x i8] c"wc\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"mkdir\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c"rm\00", align 1
@.str.12 = private unnamed_addr constant [87 x i8] c"toolbox: kill spin trap free sync mount umount wc mkdir rm gpio mux blink fbtest show\0A\00", align 1
@.str.13 = private unnamed_addr constant [20 x i8] c"usage: kill pid...\0A\00", align 1
@.str.14 = private unnamed_addr constant [11 x i8] c"spin: pid \00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c".\00", align 1
@obuf = internal global [256 x i8] zeroinitializer, align 1
@olen = internal unnamed_addr global i32 0, align 4
@.str.17 = private unnamed_addr constant [17 x i8] c"trap: Ctrl-C me\0A\00", align 1
@.str.18 = private unnamed_addr constant [34 x i8] c"\0Acaught SIGINT; exiting politely\0A\00", align 1
@.str.19 = private unnamed_addr constant [22 x i8] c"free: meminfo failed\0A\00", align 1
@.str.20 = private unnamed_addr constant [14 x i8] c"arena: total \00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c"  used \00", align 1
@.str.22 = private unnamed_addr constant [8 x i8] c"  free \00", align 1
@.str.23 = private unnamed_addr constant [11 x i8] c"  largest \00", align 1
@.str.24 = private unnamed_addr constant [14 x i8] c"\0Aof it: heap \00", align 1
@.str.25 = private unnamed_addr constant [8 x i8] c"  exec \00", align 1
@.str.26 = private unnamed_addr constant [9 x i8] c"\0Aprocs: \00", align 1
@.str.27 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.28 = private unnamed_addr constant [10 x i8] c"  uptime \00", align 1
@.str.29 = private unnamed_addr constant [8 x i8] c" ticks\0A\00", align 1
@.str.30 = private unnamed_addr constant [21 x i8] c"sync: not supported\0A\00", align 1
@.str.31 = private unnamed_addr constant [51 x i8] c"builtin: cd\0Acommands (flash registry, /dev/apps):\0A\00", align 1
@.str.32 = private unnamed_addr constant [10 x i8] c"/dev/apps\00", align 1
@.str.33 = private unnamed_addr constant [20 x i8] c"help: no /dev/apps\0A\00", align 1
@.str.34 = private unnamed_addr constant [3 x i8] c"-u\00", align 1
@.str.35 = private unnamed_addr constant [38 x i8] c"umount: failed (busy or not mounted)\0A\00", align 1
@.str.36 = private unnamed_addr constant [15 x i8] c"mount: failed\0A\00", align 1
@.str.37 = private unnamed_addr constant [38 x i8] c"usage: mount [fat0|sd0 DIR | -u DIR]\0A\00", align 1
@.str.38 = private unnamed_addr constant [20 x i8] c"usage: umount /dir\0A\00", align 1
@.str.39 = private unnamed_addr constant [17 x i8] c"wc: cannot open\0A\00", align 1
@wc_one.buf = internal global [512 x i8] zeroinitializer, align 1
@.str.40 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.41 = private unnamed_addr constant [21 x i8] c"usage: mkdir dir...\0A\00", align 1
@.str.42 = private unnamed_addr constant [15 x i8] c"mkdir: failed\0A\00", align 1
@.str.43 = private unnamed_addr constant [19 x i8] c"usage: rm file...\0A\00", align 1
@.str.44 = private unnamed_addr constant [12 x i8] c"rm: failed\0A\00", align 1

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
  br i1 %27, label %29, label %28

28:                                               ; preds = %25
  tail call fastcc void @t_spin() #8
  unreachable

29:                                               ; preds = %25
  %30 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.3) #8
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %33, label %32

32:                                               ; preds = %29
  tail call fastcc void @t_trap() #8
  unreachable

33:                                               ; preds = %29
  %34 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.4) #8
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %39, label %36

36:                                               ; preds = %33
  %37 = tail call fastcc i32 @t_free() #8
  %38 = tail call i32 @exit(i32 noundef %37) #9
  unreachable

39:                                               ; preds = %33
  %40 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.5) #8
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %45, label %42

42:                                               ; preds = %39
  %43 = tail call fastcc i32 @t_sync() #8
  %44 = tail call i32 @exit(i32 noundef %43) #9
  unreachable

45:                                               ; preds = %39
  %46 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.6) #8
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %51, label %48

48:                                               ; preds = %45
  %49 = tail call fastcc i32 @t_help() #8
  %50 = tail call i32 @exit(i32 noundef %49) #9
  unreachable

51:                                               ; preds = %45
  %52 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.7) #8
  %53 = icmp eq i32 %52, 0
  br i1 %53, label %57, label %54

54:                                               ; preds = %51
  %55 = tail call fastcc i32 @t_mount(i32 noundef %0, ptr noundef %1) #8
  %56 = tail call i32 @exit(i32 noundef %55) #9
  unreachable

57:                                               ; preds = %51
  %58 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.8) #8
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %63, label %60

60:                                               ; preds = %57
  %61 = tail call fastcc i32 @t_umount(i32 noundef %0, ptr noundef %1) #8
  %62 = tail call i32 @exit(i32 noundef %61) #9
  unreachable

63:                                               ; preds = %57
  %64 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.9) #8
  %65 = icmp eq i32 %64, 0
  br i1 %65, label %69, label %66

66:                                               ; preds = %63
  %67 = tail call fastcc i32 @t_wc(i32 noundef %0, ptr noundef %1) #8
  %68 = tail call i32 @exit(i32 noundef %67) #9
  unreachable

69:                                               ; preds = %63
  %70 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.10) #8
  %71 = icmp eq i32 %70, 0
  br i1 %71, label %75, label %72

72:                                               ; preds = %69
  %73 = tail call fastcc i32 @t_mkdir(i32 noundef %0, ptr noundef %1) #8
  %74 = tail call i32 @exit(i32 noundef %73) #9
  unreachable

75:                                               ; preds = %69
  %76 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.11) #8
  %77 = icmp eq i32 %76, 0
  br i1 %77, label %81, label %78

78:                                               ; preds = %75
  %79 = tail call fastcc i32 @t_rm(i32 noundef %0, ptr noundef %1) #8
  %80 = tail call i32 @exit(i32 noundef %79) #9
  unreachable

81:                                               ; preds = %75
  %82 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.12, i32 noundef 87) #10
  %83 = tail call i32 @exit(i32 noundef 1) #9
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.13, i32 noundef 19) #10
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

; Function Attrs: minsize noreturn nounwind optsize
define internal fastcc void @t_spin() unnamed_addr #0 {
  tail call fastcc void @emit(ptr noundef nonnull @.str.14) #8
  %1 = tail call i32 @getpid() #10
  tail call fastcc void @emitn(i32 noundef %1) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.15) #8
  tail call fastcc void @flush() #8
  br label %2

2:                                                ; preds = %2, %0
  %3 = tail call i32 @pause(i32 noundef 20) #10
  %4 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.16, i32 noundef 1) #10
  br label %2, !llvm.loop !14
}

; Function Attrs: minsize noreturn nounwind optsize
define internal fastcc void @t_trap() unnamed_addr #0 {
  %1 = tail call i32 @signal(i32 noundef 2, ptr noundef nonnull @onint) #10
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.17, i32 noundef 16) #10
  br label %3

3:                                                ; preds = %3, %0
  %4 = tail call i32 @pause(i32 noundef 20) #10
  %5 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.16, i32 noundef 1) #10
  br label %3, !llvm.loop !15
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_free() unnamed_addr #4 {
  %1 = alloca [8 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #11
  %2 = call i32 @meminfo(ptr noundef nonnull %1) #10
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %0
  %5 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.19, i32 noundef 21) #10
  br label %25

6:                                                ; preds = %0
  call fastcc void @emit(ptr noundef nonnull @.str.20) #8
  %7 = load i32, ptr %1, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %7) #8
  call fastcc void @emit(ptr noundef nonnull @.str.21) #8
  %8 = load i32, ptr %1, align 4, !tbaa !16
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %10 = load i32, ptr %9, align 4, !tbaa !16
  %11 = sub i32 %8, %10
  call fastcc void @emitn(i32 noundef %11) #8
  call fastcc void @emit(ptr noundef nonnull @.str.22) #8
  %12 = load i32, ptr %9, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %12) #8
  call fastcc void @emit(ptr noundef nonnull @.str.23) #8
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %14 = load i32, ptr %13, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %14) #8
  call fastcc void @emit(ptr noundef nonnull @.str.24) #8
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %16 = load i32, ptr %15, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %16) #8
  call fastcc void @emit(ptr noundef nonnull @.str.25) #8
  %17 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %18 = load i32, ptr %17, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %18) #8
  call fastcc void @emit(ptr noundef nonnull @.str.26) #8
  %19 = getelementptr inbounds nuw i8, ptr %1, i32 20
  %20 = load i32, ptr %19, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %20) #8
  call fastcc void @emit(ptr noundef nonnull @.str.27) #8
  %21 = getelementptr inbounds nuw i8, ptr %1, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %22) #8
  call fastcc void @emit(ptr noundef nonnull @.str.28) #8
  %23 = getelementptr inbounds nuw i8, ptr %1, i32 28
  %24 = load i32, ptr %23, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %24) #8
  call fastcc void @emit(ptr noundef nonnull @.str.29) #8
  call fastcc void @flush() #8
  br label %25

25:                                               ; preds = %6, %4
  %26 = phi i32 [ 1, %4 ], [ 0, %6 ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #11
  ret i32 %26
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_sync() unnamed_addr #4 {
  %1 = tail call i32 @sync() #10
  %2 = icmp slt i32 %1, 0
  br i1 %2, label %3, label %5

3:                                                ; preds = %0
  %4 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.30, i32 noundef 20) #10
  br label %5

5:                                                ; preds = %0, %3
  %6 = phi i32 [ 1, %3 ], [ 0, %0 ]
  ret i32 %6
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_help() unnamed_addr #4 {
  %1 = alloca [400 x i8], align 1
  %2 = alloca [80 x i8], align 1
  %3 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.31, i32 noundef 50) #10
  %4 = tail call i32 @open(ptr noundef nonnull @.str.32, i32 noundef 0) #10
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %0
  %7 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.33, i32 noundef 19) #10
  br label %56

8:                                                ; preds = %0
  call void @llvm.lifetime.start.p0(i64 400, ptr nonnull %1) #11
  %9 = call i32 @read(i32 noundef %4, ptr noundef nonnull %1, i32 noundef 400) #10
  %10 = call i32 @close(i32 noundef %4) #10
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %2) #11
  br label %11

11:                                               ; preds = %47, %8
  %12 = phi i32 [ 0, %8 ], [ %48, %47 ]
  %13 = phi i32 [ 0, %8 ], [ %49, %47 ]
  %14 = phi i32 [ 0, %8 ], [ %50, %47 ]
  %15 = icmp sgt i32 %14, %9
  br i1 %15, label %16, label %18

16:                                               ; preds = %11
  %17 = icmp eq i32 %13, 0
  br i1 %17, label %55, label %51

18:                                               ; preds = %11
  %19 = icmp slt i32 %14, %9
  br i1 %19, label %20, label %29

20:                                               ; preds = %18
  %21 = getelementptr inbounds nuw [400 x i8], ptr %1, i32 0, i32 %14
  %22 = load i8, ptr %21, align 1, !tbaa !8
  %23 = icmp eq i8 %22, 10
  br i1 %23, label %29, label %24

24:                                               ; preds = %20
  %25 = icmp slt i32 %13, 78
  br i1 %25, label %26, label %47

26:                                               ; preds = %24
  %27 = add nsw i32 %13, 1
  %28 = getelementptr inbounds [80 x i8], ptr %2, i32 0, i32 %13
  store i8 %22, ptr %28, align 1, !tbaa !8
  br label %47

29:                                               ; preds = %18, %20
  %30 = icmp eq i32 %13, 0
  %31 = icmp eq i32 %12, 0
  %32 = select i1 %30, i1 %31, i1 false
  br i1 %32, label %47, label %33

33:                                               ; preds = %29
  %34 = add nsw i32 %12, 1
  %35 = icmp eq i32 %34, 6
  br i1 %35, label %36, label %40

36:                                               ; preds = %33
  %37 = add nsw i32 %13, 1
  %38 = getelementptr inbounds [80 x i8], ptr %2, i32 0, i32 %13
  store i8 10, ptr %38, align 1, !tbaa !8
  %39 = call i32 @write(i32 noundef 1, ptr noundef nonnull %2, i32 noundef %37) #10
  br label %47

40:                                               ; preds = %33, %44
  %41 = phi i32 [ %45, %44 ], [ %13, %33 ]
  %42 = srem i32 %41, 13
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %47, label %44

44:                                               ; preds = %40
  %45 = add nsw i32 %41, 1
  %46 = getelementptr inbounds [80 x i8], ptr %2, i32 0, i32 %41
  store i8 32, ptr %46, align 1, !tbaa !8
  br label %40, !llvm.loop !18

47:                                               ; preds = %40, %36, %29, %24, %26
  %48 = phi i32 [ %12, %26 ], [ %12, %24 ], [ 0, %29 ], [ 0, %36 ], [ %34, %40 ]
  %49 = phi i32 [ %27, %26 ], [ %13, %24 ], [ 0, %29 ], [ 0, %36 ], [ %41, %40 ]
  %50 = add nuw nsw i32 %14, 1
  br label %11, !llvm.loop !19

51:                                               ; preds = %16
  %52 = add nsw i32 %13, 1
  %53 = getelementptr inbounds [80 x i8], ptr %2, i32 0, i32 %13
  store i8 10, ptr %53, align 1, !tbaa !8
  %54 = call i32 @write(i32 noundef 1, ptr noundef nonnull %2, i32 noundef %52) #10
  br label %55

55:                                               ; preds = %51, %16
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %2) #11
  call void @llvm.lifetime.end.p0(i64 400, ptr nonnull %1) #11
  br label %56

56:                                               ; preds = %55, %6
  %57 = phi i32 [ 1, %6 ], [ 0, %55 ]
  ret i32 %57
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
  %13 = tail call fastcc i32 @streq(ptr noundef %12, ptr noundef nonnull @.str.34) #8
  %14 = icmp eq i32 %13, 0
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %16 = load ptr, ptr %15, align 4, !tbaa !3
  br i1 %14, label %22, label %17

17:                                               ; preds = %10
  %18 = tail call i32 @umount(ptr noundef %16) #10
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %29

20:                                               ; preds = %17
  %21 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.35, i32 noundef 37) #10
  br label %29

22:                                               ; preds = %10
  %23 = tail call i32 @mount(ptr noundef %12, ptr noundef %16) #10
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %25, label %29

25:                                               ; preds = %22
  %26 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.36, i32 noundef 14) #10
  br label %29

27:                                               ; preds = %2
  %28 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.37, i32 noundef 37) #10
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.38, i32 noundef 19) #10
  br label %13

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %8 = load ptr, ptr %7, align 4, !tbaa !3
  %9 = tail call i32 @umount(ptr noundef %8) #10
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %6
  %12 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.35, i32 noundef 37) #10
  br label %13

13:                                               ; preds = %6, %11, %4
  %14 = phi i32 [ 1, %4 ], [ 1, %11 ], [ 0, %6 ]
  ret i32 %14
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_wc(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %5

4:                                                ; preds = %2
  tail call fastcc void @wc_one(i32 noundef 0, ptr noundef nonnull @.str) #8
  br label %21

5:                                                ; preds = %2, %17
  %6 = phi i32 [ %20, %17 ], [ 1, %2 ]
  %7 = icmp eq i32 %6, %0
  br i1 %7, label %21, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw ptr, ptr %1, i32 %6
  %10 = load ptr, ptr %9, align 4, !tbaa !3
  %11 = tail call i32 @open(ptr noundef %10, i32 noundef 0) #10
  %12 = icmp sgt i32 %11, -1
  br i1 %12, label %17, label %13

13:                                               ; preds = %8
  %14 = icmp slt i32 %6, %0
  %15 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.39, i32 noundef 16) #10
  %16 = zext i1 %14 to i32
  br label %21

17:                                               ; preds = %8
  %18 = load ptr, ptr %9, align 4, !tbaa !3
  tail call fastcc void @wc_one(i32 noundef %11, ptr noundef %18) #8
  %19 = tail call i32 @close(i32 noundef %11) #10
  %20 = add nuw i32 %6, 1
  br label %5, !llvm.loop !20

21:                                               ; preds = %5, %13, %4
  %22 = phi i32 [ 0, %4 ], [ %16, %13 ], [ 0, %5 ]
  ret i32 %22
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_mkdir(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.41, i32 noundef 20) #10
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
  br i1 %13, label %15, label %6, !llvm.loop !21

15:                                               ; preds = %9
  %16 = icmp slt i32 %7, %0
  %17 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.42, i32 noundef 14) #10
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.43, i32 noundef 18) #10
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
  br i1 %13, label %15, label %6, !llvm.loop !22

15:                                               ; preds = %9
  %16 = icmp slt i32 %7, %0
  %17 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.44, i32 noundef 11) #10
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
  store i32 %10, ptr @olen, align 4, !tbaa !16
  %11 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %4
  store i8 %6, ptr %11, align 1, !tbaa !8
  br label %3, !llvm.loop !23

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
  br i1 %14, label %15, label %3, !llvm.loop !24

15:                                               ; preds = %3
  %16 = load i32, ptr @olen, align 4, !tbaa !16
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
  br label %17, !llvm.loop !25

27:                                               ; preds = %17
  store i32 %18, ptr @olen, align 4, !tbaa !16
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %2) #11
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define internal fastcc void @flush() unnamed_addr #4 {
  %1 = load i32, ptr @olen, align 4, !tbaa !16
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @obuf, i32 noundef %1) #10
  store i32 0, ptr @olen, align 4, !tbaa !16
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @signal(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize noreturn nounwind optsize
define internal void @onint(i32 %0) #0 {
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.18, i32 noundef 33) #10
  %3 = tail call i32 @exit(i32 noundef 0) #9
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @meminfo(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @sync() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @mount(ptr noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @umount(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define internal fastcc void @wc_one(i32 noundef range(i32 0, -2147483648) %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  br label %5

3:                                                ; preds = %12
  %4 = add i32 %10, %7
  br label %5, !llvm.loop !26

5:                                                ; preds = %3, %2
  %6 = phi i32 [ 0, %2 ], [ %13, %3 ]
  %7 = phi i32 [ 0, %2 ], [ %4, %3 ]
  %8 = phi i32 [ 0, %2 ], [ %14, %3 ]
  %9 = phi i32 [ 0, %2 ], [ %15, %3 ]
  %10 = tail call i32 @read(i32 noundef %0, ptr noundef nonnull @wc_one.buf, i32 noundef 512) #10
  %11 = icmp sgt i32 %10, 0
  br i1 %11, label %12, label %32

12:                                               ; preds = %5, %28
  %13 = phi i32 [ %29, %28 ], [ %6, %5 ]
  %14 = phi i32 [ %30, %28 ], [ %8, %5 ]
  %15 = phi i32 [ %23, %28 ], [ %9, %5 ]
  %16 = phi i32 [ %31, %28 ], [ 0, %5 ]
  %17 = icmp eq i32 %16, %10
  br i1 %17, label %3, label %18

18:                                               ; preds = %12
  %19 = getelementptr inbounds nuw [512 x i8], ptr @wc_one.buf, i32 0, i32 %16
  %20 = load i8, ptr %19, align 1, !tbaa !8
  %21 = icmp eq i8 %20, 10
  %22 = zext i1 %21 to i32
  %23 = add nsw i32 %15, %22
  switch i8 %20, label %24 [
    i8 32, label %28
    i8 9, label %28
    i8 10, label %28
    i8 13, label %28
  ]

24:                                               ; preds = %18
  %25 = icmp eq i32 %14, 0
  %26 = zext i1 %25 to i32
  %27 = add nsw i32 %13, %26
  br label %28

28:                                               ; preds = %24, %18, %18, %18, %18
  %29 = phi i32 [ %13, %18 ], [ %13, %18 ], [ %13, %18 ], [ %13, %18 ], [ %27, %24 ]
  %30 = phi i32 [ 0, %18 ], [ 0, %18 ], [ 0, %18 ], [ 0, %18 ], [ 1, %24 ]
  %31 = add nuw i32 %16, 1
  br label %12, !llvm.loop !27

32:                                               ; preds = %5
  tail call fastcc void @emitn(i32 noundef %9) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.40) #8
  tail call fastcc void @emitn(i32 noundef %6) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.40) #8
  tail call fastcc void @emitn(i32 noundef %7) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.40) #8
  tail call fastcc void @emit(ptr noundef %1) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.15) #8
  tail call fastcc void @flush() #8
  ret void
}

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
!14 = distinct !{!14, !11}
!15 = distinct !{!15, !11}
!16 = !{!17, !17, i64 0}
!17 = !{!"int", !6, i64 0}
!18 = distinct !{!18, !10, !11}
!19 = distinct !{!19, !10, !11}
!20 = distinct !{!20, !10, !11}
!21 = distinct !{!21, !10, !11}
!22 = distinct !{!22, !10, !11}
!23 = distinct !{!23, !10, !11}
!24 = distinct !{!24, !10, !11}
!25 = distinct !{!25, !10, !11}
!26 = distinct !{!26, !10, !11}
!27 = distinct !{!27, !10, !11}
