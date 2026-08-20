; ModuleID = 'dma/hwtools.c'
source_filename = "dma/hwtools.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.anon = type { ptr, i32 }
%struct.pio_prog = type { i32, i32, i32, [32 x i32] }
%struct.pio_smcfg = type { i32, i32, i32, i32, i32, i32, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"gpio\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"mux\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"blink\00", align 1
@.str.4 = private unnamed_addr constant [27 x i8] c"usage: gpio|mux|blink ...\0A\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"read\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"gpio: bad pin\0A\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"1\0A\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c"0\0A\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"write\00", align 1
@.str.10 = private unnamed_addr constant [43 x i8] c"usage: gpio write PIN 0|1 | gpio read PIN\0A\00", align 1
@t_mux.roles = internal unnamed_addr constant [9 x %struct.anon] [%struct.anon { ptr @.str.11, i32 1 }, %struct.anon { ptr @.str.12, i32 2 }, %struct.anon { ptr @.str.13, i32 3 }, %struct.anon { ptr @.str.14, i32 4 }, %struct.anon { ptr @.str.15, i32 5 }, %struct.anon { ptr @.str.16, i32 6 }, %struct.anon { ptr @.str.17, i32 7 }, %struct.anon { ptr @.str.18, i32 8 }, %struct.anon { ptr @.str.19, i32 31 }], align 4
@.str.11 = private unnamed_addr constant [4 x i8] c"spi\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"uart\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"i2c\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"pwm\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"sio\00", align 1
@.str.16 = private unnamed_addr constant [5 x i8] c"pio0\00", align 1
@.str.17 = private unnamed_addr constant [5 x i8] c"pio1\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"pio2\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.str.20 = private unnamed_addr constant [22 x i8] c"mux: bad pin or role\0A\00", align 1
@.str.21 = private unnamed_addr constant [59 x i8] c"usage: mux PIN spi|uart|i2c|pwm|sio|pio0|pio1|pio2|none|N\0A\00", align 1
@blink_pin = internal unnamed_addr global i32 -1, align 4
@.str.22 = private unnamed_addr constant [36 x i8] c"blinking (soft loop); Ctrl-C stops\0A\00", align 1
@.str.23 = private unnamed_addr constant [4 x i8] c"pio\00", align 1
@blinkprog = internal unnamed_addr constant [8 x i32] [i32 57473, i32 57407, i32 65281, i32 66, i32 57407, i32 65280, i32 69, i32 1], align 4
@.str.24 = private unnamed_addr constant [25 x i8] c"blink: pio setup failed\0A\00", align 1
@.str.25 = private unnamed_addr constant [54 x i8] c"blinking on pio0 sm0 (async); `blink stop PIN` stops\0A\00", align 1
@.str.26 = private unnamed_addr constant [5 x i8] c"stop\00", align 1
@.str.27 = private unnamed_addr constant [56 x i8] c"usage: blink gpio PIN | blink pio PIN | blink stop PIN\0A\00", align 1

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
  %15 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.1) #6
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
  %23 = tail call fastcc i32 @t_gpio(i32 noundef %0, ptr noundef %1) #6
  %24 = tail call i32 @exit(i32 noundef %23) #7
  unreachable

25:                                               ; preds = %14
  %26 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.2) #6
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %31, label %28

28:                                               ; preds = %25
  %29 = tail call fastcc i32 @t_mux(i32 noundef %0, ptr noundef %1) #6
  %30 = tail call i32 @exit(i32 noundef %29) #7
  unreachable

31:                                               ; preds = %25
  %32 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.3) #6
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %37, label %34

34:                                               ; preds = %31
  %35 = tail call fastcc i32 @t_blink(i32 noundef %0, ptr noundef %1) #6
  %36 = tail call i32 @exit(i32 noundef %35) #7
  unreachable

37:                                               ; preds = %31
  %38 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.4, i32 noundef 26) #8
  %39 = tail call i32 @exit(i32 noundef 1) #7
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
define internal fastcc range(i32 0, 2) i32 @t_gpio(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp sgt i32 %0, 2
  br i1 %3, label %4, label %36

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %6 = load ptr, ptr %5, align 4, !tbaa !3
  %7 = tail call fastcc i32 @streq(ptr noundef %6, ptr noundef nonnull @.str.5) #6
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %20, label %9

9:                                                ; preds = %4
  %10 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %11 = load ptr, ptr %10, align 4, !tbaa !3
  %12 = tail call fastcc i32 @t_atoi(ptr noundef %11) #6
  %13 = tail call i32 @gpioctl(i32 noundef 1, i32 noundef %12, i32 noundef 0) #8
  %14 = icmp slt i32 %13, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  %16 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.6, i32 noundef 14) #8
  br label %38

17:                                               ; preds = %9
  %18 = icmp eq i32 %13, 0
  %19 = select i1 %18, ptr @.str.8, ptr @.str.7
  tail call void @fputstr(i32 noundef 1, ptr noundef nonnull %19) #8
  br label %38

20:                                               ; preds = %4
  %21 = icmp eq i32 %0, 3
  br i1 %21, label %36, label %22

22:                                               ; preds = %20
  %23 = tail call fastcc i32 @streq(ptr noundef %6, ptr noundef nonnull @.str.9) #6
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %36, label %25

25:                                               ; preds = %22
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %27 = load ptr, ptr %26, align 4, !tbaa !3
  %28 = tail call fastcc i32 @t_atoi(ptr noundef %27) #6
  %29 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %30 = load ptr, ptr %29, align 4, !tbaa !3
  %31 = tail call fastcc i32 @t_atoi(ptr noundef %30) #6
  %32 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %28, i32 noundef %31) #8
  %33 = icmp slt i32 %32, 0
  br i1 %33, label %34, label %38

34:                                               ; preds = %25
  %35 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.6, i32 noundef 14) #8
  br label %38

36:                                               ; preds = %2, %22, %20
  %37 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.10, i32 noundef 42) #8
  br label %38

38:                                               ; preds = %25, %15, %17, %36, %34
  %39 = phi i32 [ 1, %34 ], [ 1, %36 ], [ 1, %15 ], [ 0, %17 ], [ 0, %25 ]
  ret i32 %39
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_mux(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp sgt i32 %0, 2
  br i1 %3, label %4, label %38

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %6 = load ptr, ptr %5, align 4, !tbaa !3
  %7 = load i8, ptr %6, align 1, !tbaa !8
  %8 = add i8 %7, -48
  %9 = icmp ult i8 %8, 10
  br i1 %9, label %10, label %12

10:                                               ; preds = %4
  %11 = tail call fastcc i32 @t_atoi(ptr noundef nonnull %6) #6
  br label %27

12:                                               ; preds = %4, %24
  %13 = phi i32 [ %25, %24 ], [ -1, %4 ]
  %14 = phi i32 [ %26, %24 ], [ 0, %4 ]
  %15 = icmp eq i32 %14, 9
  br i1 %15, label %27, label %16

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw [9 x %struct.anon], ptr @t_mux.roles, i32 0, i32 %14
  %18 = load ptr, ptr %17, align 4, !tbaa !13
  %19 = tail call fastcc i32 @streq(ptr noundef nonnull %6, ptr noundef %18) #6
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %24, label %21

21:                                               ; preds = %16
  %22 = getelementptr inbounds nuw i8, ptr %17, i32 4
  %23 = load i32, ptr %22, align 4, !tbaa !16
  br label %24

24:                                               ; preds = %16, %21
  %25 = phi i32 [ %23, %21 ], [ %13, %16 ]
  %26 = add nuw nsw i32 %14, 1
  br label %12, !llvm.loop !17

27:                                               ; preds = %12, %10
  %28 = phi i32 [ %11, %10 ], [ %13, %12 ]
  %29 = icmp sgt i32 %28, -1
  br i1 %29, label %30, label %38

30:                                               ; preds = %27
  %31 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !3
  %33 = tail call fastcc i32 @t_atoi(ptr noundef %32) #6
  %34 = tail call i32 @pinmux(i32 noundef %33, i32 noundef %28) #8
  %35 = icmp slt i32 %34, 0
  br i1 %35, label %36, label %40

36:                                               ; preds = %30
  %37 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.20, i32 noundef 21) #8
  br label %40

38:                                               ; preds = %27, %2
  %39 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.21, i32 noundef 58) #8
  br label %40

40:                                               ; preds = %36, %30, %38
  %41 = phi i32 [ 1, %38 ], [ 0, %30 ], [ 1, %36 ]
  ret i32 %41
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_blink(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = alloca %struct.pio_prog, align 4
  %4 = alloca %struct.pio_smcfg, align 4
  %5 = icmp sgt i32 %0, 2
  br i1 %5, label %6, label %75

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %8 = load ptr, ptr %7, align 4, !tbaa !3
  %9 = tail call fastcc i32 @streq(ptr noundef %8, ptr noundef nonnull @.str.1) #6
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %13 = load ptr, ptr %12, align 4, !tbaa !3
  %14 = tail call fastcc i32 @t_atoi(ptr noundef %13) #6
  store i32 %14, ptr @blink_pin, align 4, !tbaa !18
  %15 = tail call i32 @signal(i32 noundef 2, ptr noundef nonnull @blink_int) #8
  tail call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.22) #8
  br label %16

16:                                               ; preds = %16, %11
  %17 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %14, i32 noundef 1) #8
  %18 = tail call i32 @pause(i32 noundef 300) #8
  %19 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %14, i32 noundef 0) #8
  %20 = tail call i32 @pause(i32 noundef 300) #8
  br label %16, !llvm.loop !19

21:                                               ; preds = %6
  %22 = tail call fastcc i32 @streq(ptr noundef %8, ptr noundef nonnull @.str.23) #6
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %66, label %24

24:                                               ; preds = %21
  %25 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %26 = load ptr, ptr %25, align 4, !tbaa !3
  %27 = tail call fastcc i32 @t_atoi(ptr noundef %26) #6
  call void @llvm.lifetime.start.p0(i64 140, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 28, ptr nonnull %4) #9
  store i32 0, ptr %3, align 4, !tbaa !20
  %28 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store i32 0, ptr %28, align 4, !tbaa !22
  %29 = getelementptr inbounds nuw i8, ptr %3, i32 8
  store i32 8, ptr %29, align 4, !tbaa !23
  %30 = getelementptr inbounds nuw i8, ptr %3, i32 12
  br label %31

31:                                               ; preds = %45, %24
  %32 = phi i32 [ 0, %24 ], [ %49, %45 ]
  %33 = icmp eq i32 %32, 8
  br i1 %33, label %34, label %45

34:                                               ; preds = %31
  store i32 0, ptr %4, align 4, !tbaa !24
  %35 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store i32 0, ptr %35, align 4, !tbaa !26
  %36 = getelementptr inbounds nuw i8, ptr %4, i32 8
  store i32 0, ptr %36, align 4, !tbaa !27
  %37 = getelementptr inbounds nuw i8, ptr %4, i32 12
  store i32 -65536, ptr %37, align 4, !tbaa !28
  %38 = getelementptr inbounds nuw i8, ptr %4, i32 16
  store i32 126976, ptr %38, align 4, !tbaa !29
  %39 = getelementptr inbounds nuw i8, ptr %4, i32 20
  store i32 0, ptr %39, align 4, !tbaa !30
  %40 = shl i32 %27, 5
  %41 = or i32 %40, 67108864
  %42 = getelementptr inbounds nuw i8, ptr %4, i32 24
  store i32 %41, ptr %42, align 4, !tbaa !31
  %43 = tail call i32 @pinmux(i32 noundef %27, i32 noundef 6) #8
  %44 = icmp slt i32 %43, 0
  br i1 %44, label %61, label %50

45:                                               ; preds = %31
  %46 = getelementptr inbounds nuw [8 x i32], ptr @blinkprog, i32 0, i32 %32
  %47 = load i32, ptr %46, align 4, !tbaa !18
  %48 = getelementptr inbounds nuw [32 x i32], ptr %30, i32 0, i32 %32
  store i32 %47, ptr %48, align 4, !tbaa !18
  %49 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !32

50:                                               ; preds = %34
  %51 = ptrtoint ptr %3 to i32
  %52 = call i32 @pioctl(i32 noundef 0, i32 noundef %51, i32 noundef 0) #8
  %53 = icmp slt i32 %52, 0
  br i1 %53, label %61, label %54

54:                                               ; preds = %50
  %55 = ptrtoint ptr %4 to i32
  %56 = call i32 @pioctl(i32 noundef 1, i32 noundef %55, i32 noundef 0) #8
  %57 = icmp slt i32 %56, 0
  br i1 %57, label %61, label %58

58:                                               ; preds = %54
  %59 = call i32 @pioctl(i32 noundef 2, i32 noundef 0, i32 noundef 1) #8
  %60 = icmp slt i32 %59, 0
  br i1 %60, label %61, label %63

61:                                               ; preds = %58, %54, %50, %34
  %62 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.24, i32 noundef 24) #8
  br label %64

63:                                               ; preds = %58
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.25) #8
  br label %64

64:                                               ; preds = %63, %61
  %65 = phi i32 [ 1, %61 ], [ 0, %63 ]
  call void @llvm.lifetime.end.p0(i64 28, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 140, ptr nonnull %3) #9
  br label %77

66:                                               ; preds = %21
  %67 = tail call fastcc i32 @streq(ptr noundef %8, ptr noundef nonnull @.str.26) #6
  %68 = icmp eq i32 %67, 0
  br i1 %68, label %75, label %69

69:                                               ; preds = %66
  %70 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %71 = load ptr, ptr %70, align 4, !tbaa !3
  %72 = tail call fastcc i32 @t_atoi(ptr noundef %71) #6
  %73 = tail call i32 @pioctl(i32 noundef 2, i32 noundef 0, i32 noundef 0) #8
  %74 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %72, i32 noundef 0) #8
  br label %77

75:                                               ; preds = %2, %66
  %76 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.27, i32 noundef 55) #8
  br label %77

77:                                               ; preds = %75, %69, %64
  %78 = phi i32 [ %65, %64 ], [ 0, %69 ], [ 1, %75 ]
  ret i32 %78
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @gpioctl(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc i32 @t_atoi(ptr noundef readonly captures(none) %0) unnamed_addr #2 {
  br label %2

2:                                                ; preds = %8, %1
  %3 = phi ptr [ %0, %1 ], [ %10, %8 ]
  %4 = phi i32 [ 0, %1 ], [ %12, %8 ]
  %5 = load i8, ptr %3, align 1, !tbaa !8
  %6 = add i8 %5, -48
  %7 = icmp ult i8 %6, 10
  br i1 %7, label %8, label %13

8:                                                ; preds = %2
  %9 = mul nsw i32 %4, 10
  %10 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %11 = zext nneg i8 %6 to i32
  %12 = add nsw i32 %9, %11
  br label %2, !llvm.loop !33

13:                                               ; preds = %2
  ret i32 %4
}

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @pinmux(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @signal(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize noreturn nounwind optsize
define internal void @blink_int(i32 %0) #0 {
  %2 = load i32, ptr @blink_pin, align 4, !tbaa !18
  %3 = icmp sgt i32 %2, -1
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  %5 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %2, i32 noundef 0) #8
  br label %6

6:                                                ; preds = %4, %1
  %7 = tail call i32 @exit(i32 noundef 0) #7
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @pioctl(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }
attributes #7 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #9 = { nounwind }

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
!13 = !{!14, !4, i64 0}
!14 = !{!"", !4, i64 0, !15, i64 4}
!15 = !{!"int", !6, i64 0}
!16 = !{!14, !15, i64 4}
!17 = distinct !{!17, !10, !11}
!18 = !{!15, !15, i64 0}
!19 = distinct !{!19, !11}
!20 = !{!21, !15, i64 0}
!21 = !{!"pio_prog", !15, i64 0, !15, i64 4, !15, i64 8, !6, i64 12}
!22 = !{!21, !15, i64 4}
!23 = !{!21, !15, i64 8}
!24 = !{!25, !15, i64 0}
!25 = !{!"pio_smcfg", !15, i64 0, !15, i64 4, !15, i64 8, !15, i64 12, !15, i64 16, !15, i64 20, !15, i64 24}
!26 = !{!25, !15, i64 4}
!27 = !{!25, !15, i64 8}
!28 = !{!25, !15, i64 12}
!29 = !{!25, !15, i64 16}
!30 = !{!25, !15, i64 20}
!31 = !{!25, !15, i64 24}
!32 = distinct !{!32, !10, !11}
!33 = distinct !{!33, !10, !11}
