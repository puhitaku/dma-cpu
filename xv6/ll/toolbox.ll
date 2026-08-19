; ModuleID = 'dma/toolbox.c'
source_filename = "dma/toolbox.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.anon = type { ptr, i32 }
%struct.pio_prog = type { i32, i32, i32, [32 x i32] }
%struct.pio_smcfg = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.fbinfo = type { i32, i32, i32, i32, i32 }
%struct.stat = type { i32, i32, i16, i16, i32 }
%struct.dirent = type { i16, [62 x i8] }

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
@.str.12 = private unnamed_addr constant [5 x i8] c"gpio\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"mux\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"blink\00", align 1
@.str.15 = private unnamed_addr constant [7 x i8] c"fbtest\00", align 1
@.str.16 = private unnamed_addr constant [5 x i8] c"show\00", align 1
@.str.17 = private unnamed_addr constant [87 x i8] c"toolbox: kill spin trap free sync mount umount wc mkdir rm gpio mux blink fbtest show\0A\00", align 1
@.str.18 = private unnamed_addr constant [20 x i8] c"usage: kill pid...\0A\00", align 1
@.str.19 = private unnamed_addr constant [11 x i8] c"spin: pid \00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c".\00", align 1
@obuf = internal global [256 x i8] zeroinitializer, align 1
@olen = internal unnamed_addr global i32 0, align 4
@.str.22 = private unnamed_addr constant [17 x i8] c"trap: Ctrl-C me\0A\00", align 1
@.str.23 = private unnamed_addr constant [34 x i8] c"\0Acaught SIGINT; exiting politely\0A\00", align 1
@.str.24 = private unnamed_addr constant [22 x i8] c"free: meminfo failed\0A\00", align 1
@.str.25 = private unnamed_addr constant [14 x i8] c"arena: total \00", align 1
@.str.26 = private unnamed_addr constant [8 x i8] c"  used \00", align 1
@.str.27 = private unnamed_addr constant [8 x i8] c"  free \00", align 1
@.str.28 = private unnamed_addr constant [11 x i8] c"  largest \00", align 1
@.str.29 = private unnamed_addr constant [14 x i8] c"\0Aof it: heap \00", align 1
@.str.30 = private unnamed_addr constant [8 x i8] c"  exec \00", align 1
@.str.31 = private unnamed_addr constant [9 x i8] c"\0Aprocs: \00", align 1
@.str.32 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.33 = private unnamed_addr constant [10 x i8] c"  uptime \00", align 1
@.str.34 = private unnamed_addr constant [8 x i8] c" ticks\0A\00", align 1
@.str.35 = private unnamed_addr constant [21 x i8] c"sync: not supported\0A\00", align 1
@.str.36 = private unnamed_addr constant [51 x i8] c"builtin: cd\0Acommands (flash registry, /dev/apps):\0A\00", align 1
@.str.37 = private unnamed_addr constant [10 x i8] c"/dev/apps\00", align 1
@.str.38 = private unnamed_addr constant [20 x i8] c"help: no /dev/apps\0A\00", align 1
@.str.39 = private unnamed_addr constant [3 x i8] c"-u\00", align 1
@.str.40 = private unnamed_addr constant [38 x i8] c"umount: failed (busy or not mounted)\0A\00", align 1
@.str.41 = private unnamed_addr constant [15 x i8] c"mount: failed\0A\00", align 1
@.str.42 = private unnamed_addr constant [36 x i8] c"usage: mount [fat0 /dir | -u /dir]\0A\00", align 1
@.str.43 = private unnamed_addr constant [20 x i8] c"usage: umount /dir\0A\00", align 1
@.str.44 = private unnamed_addr constant [17 x i8] c"wc: cannot open\0A\00", align 1
@wc_one.buf = internal global [512 x i8] zeroinitializer, align 1
@.str.45 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.46 = private unnamed_addr constant [21 x i8] c"usage: mkdir dir...\0A\00", align 1
@.str.47 = private unnamed_addr constant [15 x i8] c"mkdir: failed\0A\00", align 1
@.str.48 = private unnamed_addr constant [19 x i8] c"usage: rm file...\0A\00", align 1
@.str.49 = private unnamed_addr constant [12 x i8] c"rm: failed\0A\00", align 1
@.str.50 = private unnamed_addr constant [5 x i8] c"read\00", align 1
@.str.51 = private unnamed_addr constant [15 x i8] c"gpio: bad pin\0A\00", align 1
@.str.52 = private unnamed_addr constant [3 x i8] c"1\0A\00", align 1
@.str.53 = private unnamed_addr constant [3 x i8] c"0\0A\00", align 1
@.str.54 = private unnamed_addr constant [6 x i8] c"write\00", align 1
@.str.55 = private unnamed_addr constant [43 x i8] c"usage: gpio write PIN 0|1 | gpio read PIN\0A\00", align 1
@t_mux.roles = internal unnamed_addr constant [9 x %struct.anon] [%struct.anon { ptr @.str.56, i32 1 }, %struct.anon { ptr @.str.57, i32 2 }, %struct.anon { ptr @.str.58, i32 3 }, %struct.anon { ptr @.str.59, i32 4 }, %struct.anon { ptr @.str.60, i32 5 }, %struct.anon { ptr @.str.61, i32 6 }, %struct.anon { ptr @.str.62, i32 7 }, %struct.anon { ptr @.str.63, i32 8 }, %struct.anon { ptr @.str.64, i32 31 }], align 4
@.str.56 = private unnamed_addr constant [4 x i8] c"spi\00", align 1
@.str.57 = private unnamed_addr constant [5 x i8] c"uart\00", align 1
@.str.58 = private unnamed_addr constant [4 x i8] c"i2c\00", align 1
@.str.59 = private unnamed_addr constant [4 x i8] c"pwm\00", align 1
@.str.60 = private unnamed_addr constant [4 x i8] c"sio\00", align 1
@.str.61 = private unnamed_addr constant [5 x i8] c"pio0\00", align 1
@.str.62 = private unnamed_addr constant [5 x i8] c"pio1\00", align 1
@.str.63 = private unnamed_addr constant [5 x i8] c"pio2\00", align 1
@.str.64 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.str.65 = private unnamed_addr constant [22 x i8] c"mux: bad pin or role\0A\00", align 1
@.str.66 = private unnamed_addr constant [59 x i8] c"usage: mux PIN spi|uart|i2c|pwm|sio|pio0|pio1|pio2|none|N\0A\00", align 1
@blink_pin = internal unnamed_addr global i32 -1, align 4
@.str.67 = private unnamed_addr constant [36 x i8] c"blinking (soft loop); Ctrl-C stops\0A\00", align 1
@.str.68 = private unnamed_addr constant [4 x i8] c"pio\00", align 1
@blinkprog = internal unnamed_addr constant [8 x i32] [i32 57473, i32 57407, i32 65281, i32 66, i32 57407, i32 65280, i32 69, i32 1], align 4
@.str.69 = private unnamed_addr constant [25 x i8] c"blink: pio setup failed\0A\00", align 1
@.str.70 = private unnamed_addr constant [54 x i8] c"blinking on pio0 sm0 (async); `blink stop PIN` stops\0A\00", align 1
@.str.71 = private unnamed_addr constant [5 x i8] c"stop\00", align 1
@.str.72 = private unnamed_addr constant [56 x i8] c"usage: blink gpio PIN | blink pio PIN | blink stop PIN\0A\00", align 1
@.str.73 = private unnamed_addr constant [15 x i8] c"fbtest: no fb\0A\00", align 1
@.str.74 = private unnamed_addr constant [14 x i8] c"fbtest: busy\0A\00", align 1
@t_fbtest.bars = internal unnamed_addr constant [16 x i8] c"\00\80\10\90\02\82\12\DB\92\E0\1C\FC\03\E3\1F\FF", align 1
@t_fbtest.tmpl = internal unnamed_addr global [640 x i8] zeroinitializer, align 1
@.str.75 = private unnamed_addr constant [28 x i8] c"fbtest: test card up (5 s)\0A\00", align 1
@.str.76 = private unnamed_addr constant [21 x i8] c"fbtest: verify FAIL\0A\00", align 1
@.str.77 = private unnamed_addr constant [7 x i8] c"fb ok \00", align 1
@.str.78 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.79 = private unnamed_addr constant [13 x i8] c"show: no fb\0A\00", align 1
@nshow = internal unnamed_addr global i32 0, align 4
@.str.80 = private unnamed_addr constant [19 x i8] c"show: cannot open\0A\00", align 1
@shownames = internal global [32 x [64 x i8]] zeroinitializer, align 1
@.str.81 = private unnamed_addr constant [50 x i8] c"show: no slides (usage: show DIR | show FILE...)\0A\00", align 1
@.str.82 = private unnamed_addr constant [15 x i8] c"show: fb busy\0A\00", align 1

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
  %82 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.12) #8
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %87, label %84

84:                                               ; preds = %81
  %85 = tail call fastcc i32 @t_gpio(i32 noundef %0, ptr noundef %1) #8
  %86 = tail call i32 @exit(i32 noundef %85) #9
  unreachable

87:                                               ; preds = %81
  %88 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.13) #8
  %89 = icmp eq i32 %88, 0
  br i1 %89, label %93, label %90

90:                                               ; preds = %87
  %91 = tail call fastcc i32 @t_mux(i32 noundef %0, ptr noundef %1) #8
  %92 = tail call i32 @exit(i32 noundef %91) #9
  unreachable

93:                                               ; preds = %87
  %94 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.14) #8
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %99, label %96

96:                                               ; preds = %93
  %97 = tail call fastcc i32 @t_blink(i32 noundef %0, ptr noundef %1) #8
  %98 = tail call i32 @exit(i32 noundef %97) #9
  unreachable

99:                                               ; preds = %93
  %100 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.15) #8
  %101 = icmp eq i32 %100, 0
  br i1 %101, label %105, label %102

102:                                              ; preds = %99
  %103 = tail call fastcc i32 @t_fbtest() #8
  %104 = tail call i32 @exit(i32 noundef %103) #9
  unreachable

105:                                              ; preds = %99
  %106 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.16) #8
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %111, label %108

108:                                              ; preds = %105
  %109 = tail call fastcc i32 @t_show(i32 noundef %0, ptr noundef %1) #8
  %110 = tail call i32 @exit(i32 noundef %109) #9
  unreachable

111:                                              ; preds = %105
  %112 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.17, i32 noundef 87) #10
  %113 = tail call i32 @exit(i32 noundef 1) #9
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.18, i32 noundef 19) #10
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
  tail call fastcc void @emit(ptr noundef nonnull @.str.19) #8
  %1 = tail call i32 @getpid() #10
  tail call fastcc void @emitn(i32 noundef %1) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.20) #8
  tail call fastcc void @flush() #8
  br label %2

2:                                                ; preds = %2, %0
  %3 = tail call i32 @pause(i32 noundef 20) #10
  %4 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.21, i32 noundef 1) #10
  br label %2, !llvm.loop !14
}

; Function Attrs: minsize noreturn nounwind optsize
define internal fastcc void @t_trap() unnamed_addr #0 {
  %1 = tail call i32 @signal(i32 noundef 2, ptr noundef nonnull @onint) #10
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.22, i32 noundef 16) #10
  br label %3

3:                                                ; preds = %3, %0
  %4 = tail call i32 @pause(i32 noundef 20) #10
  %5 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.21, i32 noundef 1) #10
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
  %5 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.24, i32 noundef 21) #10
  br label %25

6:                                                ; preds = %0
  call fastcc void @emit(ptr noundef nonnull @.str.25) #8
  %7 = load i32, ptr %1, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %7) #8
  call fastcc void @emit(ptr noundef nonnull @.str.26) #8
  %8 = load i32, ptr %1, align 4, !tbaa !16
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %10 = load i32, ptr %9, align 4, !tbaa !16
  %11 = sub i32 %8, %10
  call fastcc void @emitn(i32 noundef %11) #8
  call fastcc void @emit(ptr noundef nonnull @.str.27) #8
  %12 = load i32, ptr %9, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %12) #8
  call fastcc void @emit(ptr noundef nonnull @.str.28) #8
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %14 = load i32, ptr %13, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %14) #8
  call fastcc void @emit(ptr noundef nonnull @.str.29) #8
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %16 = load i32, ptr %15, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %16) #8
  call fastcc void @emit(ptr noundef nonnull @.str.30) #8
  %17 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %18 = load i32, ptr %17, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %18) #8
  call fastcc void @emit(ptr noundef nonnull @.str.31) #8
  %19 = getelementptr inbounds nuw i8, ptr %1, i32 20
  %20 = load i32, ptr %19, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %20) #8
  call fastcc void @emit(ptr noundef nonnull @.str.32) #8
  %21 = getelementptr inbounds nuw i8, ptr %1, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %22) #8
  call fastcc void @emit(ptr noundef nonnull @.str.33) #8
  %23 = getelementptr inbounds nuw i8, ptr %1, i32 28
  %24 = load i32, ptr %23, align 4, !tbaa !16
  call fastcc void @emitn(i32 noundef %24) #8
  call fastcc void @emit(ptr noundef nonnull @.str.34) #8
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
  %4 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.35, i32 noundef 20) #10
  br label %5

5:                                                ; preds = %0, %3
  %6 = phi i32 [ 1, %3 ], [ 0, %0 ]
  ret i32 %6
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_help() unnamed_addr #4 {
  %1 = alloca [400 x i8], align 1
  %2 = alloca [80 x i8], align 1
  %3 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.36, i32 noundef 50) #10
  %4 = tail call i32 @open(ptr noundef nonnull @.str.37, i32 noundef 0) #10
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %0
  %7 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.38, i32 noundef 19) #10
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
  %13 = tail call fastcc i32 @streq(ptr noundef %12, ptr noundef nonnull @.str.39) #8
  %14 = icmp eq i32 %13, 0
  %15 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %16 = load ptr, ptr %15, align 4, !tbaa !3
  br i1 %14, label %22, label %17

17:                                               ; preds = %10
  %18 = tail call i32 @umount(ptr noundef %16) #10
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %29

20:                                               ; preds = %17
  %21 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.40, i32 noundef 37) #10
  br label %29

22:                                               ; preds = %10
  %23 = tail call i32 @mount(ptr noundef %12, ptr noundef %16) #10
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %25, label %29

25:                                               ; preds = %22
  %26 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.41, i32 noundef 14) #10
  br label %29

27:                                               ; preds = %2
  %28 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.42, i32 noundef 35) #10
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.43, i32 noundef 19) #10
  br label %13

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %8 = load ptr, ptr %7, align 4, !tbaa !3
  %9 = tail call i32 @umount(ptr noundef %8) #10
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %6
  %12 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.40, i32 noundef 37) #10
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
  %15 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.44, i32 noundef 16) #10
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.46, i32 noundef 20) #10
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
  %17 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.47, i32 noundef 14) #10
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
  %5 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.48, i32 noundef 18) #10
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
  %17 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.49, i32 noundef 11) #10
  %18 = zext i1 %16 to i32
  br label %19

19:                                               ; preds = %6, %15, %4
  %20 = phi i32 [ 1, %4 ], [ %18, %15 ], [ 0, %6 ]
  ret i32 %20
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_gpio(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = icmp sgt i32 %0, 2
  br i1 %3, label %4, label %36

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %6 = load ptr, ptr %5, align 4, !tbaa !3
  %7 = tail call fastcc i32 @streq(ptr noundef %6, ptr noundef nonnull @.str.50) #8
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %20, label %9

9:                                                ; preds = %4
  %10 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %11 = load ptr, ptr %10, align 4, !tbaa !3
  %12 = tail call fastcc i32 @t_atoi(ptr noundef %11) #8
  %13 = tail call i32 @gpioctl(i32 noundef 1, i32 noundef %12, i32 noundef 0) #10
  %14 = icmp slt i32 %13, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  %16 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.51, i32 noundef 14) #10
  br label %38

17:                                               ; preds = %9
  %18 = icmp eq i32 %13, 0
  %19 = select i1 %18, ptr @.str.53, ptr @.str.52
  tail call void @fputstr(i32 noundef 1, ptr noundef nonnull %19) #10
  br label %38

20:                                               ; preds = %4
  %21 = icmp eq i32 %0, 3
  br i1 %21, label %36, label %22

22:                                               ; preds = %20
  %23 = tail call fastcc i32 @streq(ptr noundef %6, ptr noundef nonnull @.str.54) #8
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %36, label %25

25:                                               ; preds = %22
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %27 = load ptr, ptr %26, align 4, !tbaa !3
  %28 = tail call fastcc i32 @t_atoi(ptr noundef %27) #8
  %29 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %30 = load ptr, ptr %29, align 4, !tbaa !3
  %31 = tail call fastcc i32 @t_atoi(ptr noundef %30) #8
  %32 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %28, i32 noundef %31) #10
  %33 = icmp slt i32 %32, 0
  br i1 %33, label %34, label %38

34:                                               ; preds = %25
  %35 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.51, i32 noundef 14) #10
  br label %38

36:                                               ; preds = %2, %22, %20
  %37 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.55, i32 noundef 42) #10
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
  %11 = tail call fastcc i32 @t_atoi(ptr noundef nonnull %6) #8
  br label %27

12:                                               ; preds = %4, %24
  %13 = phi i32 [ %25, %24 ], [ -1, %4 ]
  %14 = phi i32 [ %26, %24 ], [ 0, %4 ]
  %15 = icmp eq i32 %14, 9
  br i1 %15, label %27, label %16

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw [9 x %struct.anon], ptr @t_mux.roles, i32 0, i32 %14
  %18 = load ptr, ptr %17, align 4, !tbaa !23
  %19 = tail call fastcc i32 @streq(ptr noundef nonnull %6, ptr noundef %18) #8
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %24, label %21

21:                                               ; preds = %16
  %22 = getelementptr inbounds nuw i8, ptr %17, i32 4
  %23 = load i32, ptr %22, align 4, !tbaa !25
  br label %24

24:                                               ; preds = %16, %21
  %25 = phi i32 [ %23, %21 ], [ %13, %16 ]
  %26 = add nuw nsw i32 %14, 1
  br label %12, !llvm.loop !26

27:                                               ; preds = %12, %10
  %28 = phi i32 [ %11, %10 ], [ %13, %12 ]
  %29 = icmp sgt i32 %28, -1
  br i1 %29, label %30, label %38

30:                                               ; preds = %27
  %31 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !3
  %33 = tail call fastcc i32 @t_atoi(ptr noundef %32) #8
  %34 = tail call i32 @pinmux(i32 noundef %33, i32 noundef %28) #10
  %35 = icmp slt i32 %34, 0
  br i1 %35, label %36, label %40

36:                                               ; preds = %30
  %37 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.65, i32 noundef 21) #10
  br label %40

38:                                               ; preds = %27, %2
  %39 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.66, i32 noundef 58) #10
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
  %9 = tail call fastcc i32 @streq(ptr noundef %8, ptr noundef nonnull @.str.12) #8
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %21, label %11

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %13 = load ptr, ptr %12, align 4, !tbaa !3
  %14 = tail call fastcc i32 @t_atoi(ptr noundef %13) #8
  store i32 %14, ptr @blink_pin, align 4, !tbaa !16
  %15 = tail call i32 @signal(i32 noundef 2, ptr noundef nonnull @blink_int) #10
  tail call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.67) #10
  br label %16

16:                                               ; preds = %16, %11
  %17 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %14, i32 noundef 1) #10
  %18 = tail call i32 @pause(i32 noundef 300) #10
  %19 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %14, i32 noundef 0) #10
  %20 = tail call i32 @pause(i32 noundef 300) #10
  br label %16, !llvm.loop !27

21:                                               ; preds = %6
  %22 = tail call fastcc i32 @streq(ptr noundef %8, ptr noundef nonnull @.str.68) #8
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %66, label %24

24:                                               ; preds = %21
  %25 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %26 = load ptr, ptr %25, align 4, !tbaa !3
  %27 = tail call fastcc i32 @t_atoi(ptr noundef %26) #8
  call void @llvm.lifetime.start.p0(i64 140, ptr nonnull %3) #11
  call void @llvm.lifetime.start.p0(i64 28, ptr nonnull %4) #11
  store i32 0, ptr %3, align 4, !tbaa !28
  %28 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store i32 0, ptr %28, align 4, !tbaa !30
  %29 = getelementptr inbounds nuw i8, ptr %3, i32 8
  store i32 8, ptr %29, align 4, !tbaa !31
  %30 = getelementptr inbounds nuw i8, ptr %3, i32 12
  br label %31

31:                                               ; preds = %45, %24
  %32 = phi i32 [ 0, %24 ], [ %49, %45 ]
  %33 = icmp eq i32 %32, 8
  br i1 %33, label %34, label %45

34:                                               ; preds = %31
  store i32 0, ptr %4, align 4, !tbaa !32
  %35 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store i32 0, ptr %35, align 4, !tbaa !34
  %36 = getelementptr inbounds nuw i8, ptr %4, i32 8
  store i32 0, ptr %36, align 4, !tbaa !35
  %37 = getelementptr inbounds nuw i8, ptr %4, i32 12
  store i32 -65536, ptr %37, align 4, !tbaa !36
  %38 = getelementptr inbounds nuw i8, ptr %4, i32 16
  store i32 126976, ptr %38, align 4, !tbaa !37
  %39 = getelementptr inbounds nuw i8, ptr %4, i32 20
  store i32 0, ptr %39, align 4, !tbaa !38
  %40 = shl i32 %27, 5
  %41 = or i32 %40, 67108864
  %42 = getelementptr inbounds nuw i8, ptr %4, i32 24
  store i32 %41, ptr %42, align 4, !tbaa !39
  %43 = tail call i32 @pinmux(i32 noundef %27, i32 noundef 6) #10
  %44 = icmp slt i32 %43, 0
  br i1 %44, label %61, label %50

45:                                               ; preds = %31
  %46 = getelementptr inbounds nuw [8 x i32], ptr @blinkprog, i32 0, i32 %32
  %47 = load i32, ptr %46, align 4, !tbaa !16
  %48 = getelementptr inbounds nuw [32 x i32], ptr %30, i32 0, i32 %32
  store i32 %47, ptr %48, align 4, !tbaa !16
  %49 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !40

50:                                               ; preds = %34
  %51 = ptrtoint ptr %3 to i32
  %52 = call i32 @pioctl(i32 noundef 0, i32 noundef %51, i32 noundef 0) #10
  %53 = icmp slt i32 %52, 0
  br i1 %53, label %61, label %54

54:                                               ; preds = %50
  %55 = ptrtoint ptr %4 to i32
  %56 = call i32 @pioctl(i32 noundef 1, i32 noundef %55, i32 noundef 0) #10
  %57 = icmp slt i32 %56, 0
  br i1 %57, label %61, label %58

58:                                               ; preds = %54
  %59 = call i32 @pioctl(i32 noundef 2, i32 noundef 0, i32 noundef 1) #10
  %60 = icmp slt i32 %59, 0
  br i1 %60, label %61, label %63

61:                                               ; preds = %58, %54, %50, %34
  %62 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.69, i32 noundef 24) #10
  br label %64

63:                                               ; preds = %58
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.70) #10
  br label %64

64:                                               ; preds = %63, %61
  %65 = phi i32 [ 1, %61 ], [ 0, %63 ]
  call void @llvm.lifetime.end.p0(i64 28, ptr nonnull %4) #11
  call void @llvm.lifetime.end.p0(i64 140, ptr nonnull %3) #11
  br label %77

66:                                               ; preds = %21
  %67 = tail call fastcc i32 @streq(ptr noundef %8, ptr noundef nonnull @.str.71) #8
  %68 = icmp eq i32 %67, 0
  br i1 %68, label %75, label %69

69:                                               ; preds = %66
  %70 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %71 = load ptr, ptr %70, align 4, !tbaa !3
  %72 = tail call fastcc i32 @t_atoi(ptr noundef %71) #8
  %73 = tail call i32 @pioctl(i32 noundef 2, i32 noundef 0, i32 noundef 0) #10
  %74 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %72, i32 noundef 0) #10
  br label %77

75:                                               ; preds = %2, %66
  %76 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.72, i32 noundef 55) #10
  br label %77

77:                                               ; preds = %75, %69, %64
  %78 = phi i32 [ %65, %64 ], [ 0, %69 ], [ 1, %75 ]
  ret i32 %78
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_fbtest() unnamed_addr #4 {
  %1 = alloca %struct.fbinfo, align 4
  %2 = alloca [5 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #11
  %3 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %1) #10
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %0
  %6 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.73, i32 noundef 14) #10
  br label %149

7:                                                ; preds = %0
  %8 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #10
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  %11 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.74, i32 noundef 13) #10
  br label %149

12:                                               ; preds = %7
  %13 = load i32, ptr %1, align 4, !tbaa !41
  %14 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %15 = load i32, ptr %14, align 4, !tbaa !43
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %2) #11
  %16 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %17 = load i32, ptr %16, align 4, !tbaa !44
  %18 = udiv i32 %17, 5
  br label %19

19:                                               ; preds = %27, %12
  %20 = phi i32 [ 0, %12 ], [ %28, %27 ]
  %21 = icmp eq i32 %20, 5
  br i1 %21, label %22, label %27

22:                                               ; preds = %19
  %23 = inttoptr i32 %13 to ptr
  %24 = lshr i32 %15, 2
  %25 = getelementptr inbounds nuw i8, ptr %2, i32 16
  store i32 %17, ptr %25, align 4, !tbaa !16
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 4
  br label %31

27:                                               ; preds = %19
  %28 = add nuw nsw i32 %20, 1
  %29 = mul nuw i32 %18, %28
  %30 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %20
  store i32 %29, ptr %30, align 4, !tbaa !16
  br label %19, !llvm.loop !45

31:                                               ; preds = %95, %22
  %32 = phi i32 [ 0, %22 ], [ %96, %95 ]
  %33 = icmp eq i32 %32, 5
  br i1 %33, label %110, label %34

34:                                               ; preds = %31
  %35 = icmp eq i32 %32, 0
  br i1 %35, label %36, label %39

36:                                               ; preds = %34
  %37 = load i32, ptr %26, align 4, !tbaa !46
  %38 = lshr i32 %37, 4
  br label %44

39:                                               ; preds = %34
  %40 = icmp eq i32 %32, 3
  %41 = load i32, ptr %26, align 4
  %42 = select i1 %40, i32 2, i32 3
  %43 = lshr i32 %41, %42
  br label %44

44:                                               ; preds = %39, %36
  %45 = phi i32 [ %37, %36 ], [ %41, %39 ]
  %46 = phi i32 [ %38, %36 ], [ %43, %39 ]
  br label %47

47:                                               ; preds = %72, %44
  %48 = phi i32 [ 0, %44 ], [ %74, %72 ]
  %49 = phi i32 [ 0, %44 ], [ %79, %72 ]
  %50 = phi i32 [ %46, %44 ], [ %80, %72 ]
  %51 = icmp eq i32 %48, %45
  br i1 %51, label %81, label %52

52:                                               ; preds = %47
  br i1 %35, label %53, label %56

53:                                               ; preds = %52
  %54 = getelementptr inbounds nuw [16 x i8], ptr @t_fbtest.bars, i32 0, i32 %49
  %55 = load i8, ptr %54, align 1, !tbaa !8
  br label %72

56:                                               ; preds = %52
  switch i32 %32, label %65 [
    i32 1, label %57
    i32 2, label %60
    i32 3, label %63
  ]

57:                                               ; preds = %56
  %58 = trunc i32 %49 to i8
  %59 = shl i8 %58, 5
  br label %72

60:                                               ; preds = %56
  %61 = trunc i32 %49 to i8
  %62 = shl i8 %61, 2
  br label %72

63:                                               ; preds = %56
  %64 = trunc i32 %49 to i8
  br label %72

65:                                               ; preds = %56
  %66 = shl i32 %49, 5
  %67 = shl i32 %49, 2
  %68 = or i32 %66, %67
  %69 = lshr i32 %49, 1
  %70 = or i32 %68, %69
  %71 = trunc i32 %70 to i8
  br label %72

72:                                               ; preds = %57, %63, %65, %60, %53
  %73 = phi i8 [ %55, %53 ], [ %59, %57 ], [ %62, %60 ], [ %64, %63 ], [ %71, %65 ]
  %74 = add i32 %48, 1
  %75 = getelementptr inbounds nuw [640 x i8], ptr @t_fbtest.tmpl, i32 0, i32 %48
  store i8 %73, ptr %75, align 1, !tbaa !8
  %76 = add i32 %50, -1
  %77 = icmp eq i32 %76, 0
  %78 = zext i1 %77 to i32
  %79 = add i32 %49, %78
  %80 = select i1 %77, i32 %46, i32 %76
  br label %47, !llvm.loop !47

81:                                               ; preds = %47
  store i8 -1, ptr @t_fbtest.tmpl, align 1, !tbaa !8
  %82 = add i32 %45, -1
  %83 = getelementptr inbounds nuw [640 x i8], ptr @t_fbtest.tmpl, i32 0, i32 %82
  store i8 -1, ptr %83, align 1, !tbaa !8
  br i1 %35, label %88, label %84

84:                                               ; preds = %81
  %85 = add nsw i32 %32, -1
  %86 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %85
  %87 = load i32, ptr %86, align 4, !tbaa !16
  br label %88

88:                                               ; preds = %81, %84
  %89 = phi i32 [ %87, %84 ], [ 0, %81 ]
  %90 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %32
  %91 = load i32, ptr %90, align 4, !tbaa !16
  br label %92

92:                                               ; preds = %103, %88
  %93 = phi i32 [ %89, %88 ], [ %104, %103 ]
  %94 = icmp ult i32 %93, %91
  br i1 %94, label %97, label %95

95:                                               ; preds = %92
  %96 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !48

97:                                               ; preds = %92
  %98 = mul i32 %93, %24
  %99 = getelementptr inbounds nuw i32, ptr %23, i32 %98
  br label %100

100:                                              ; preds = %105, %97
  %101 = phi i32 [ 0, %97 ], [ %109, %105 ]
  %102 = icmp eq i32 %101, %24
  br i1 %102, label %103, label %105

103:                                              ; preds = %100
  %104 = add nuw i32 %93, 1
  br label %92, !llvm.loop !49

105:                                              ; preds = %100
  %106 = getelementptr inbounds nuw i32, ptr @t_fbtest.tmpl, i32 %101
  %107 = load i32, ptr %106, align 4, !tbaa !16
  %108 = getelementptr inbounds nuw i32, ptr %99, i32 %101
  store volatile i32 %107, ptr %108, align 4, !tbaa !16
  %109 = add nuw nsw i32 %101, 1
  br label %100, !llvm.loop !50

110:                                              ; preds = %31, %116
  %111 = phi i32 [ %123, %116 ], [ 0, %31 ]
  %112 = icmp eq i32 %111, %24
  br i1 %112, label %113, label %116

113:                                              ; preds = %110
  %114 = load volatile i32, ptr %23, align 4, !tbaa !16
  %115 = icmp eq i32 %114, -1
  br i1 %115, label %124, label %137

116:                                              ; preds = %110
  %117 = getelementptr inbounds nuw i32, ptr %23, i32 %111
  store volatile i32 -1, ptr %117, align 4, !tbaa !16
  %118 = load i32, ptr %16, align 4, !tbaa !44
  %119 = add i32 %118, -1
  %120 = mul i32 %119, %24
  %121 = getelementptr i32, ptr %23, i32 %120
  %122 = getelementptr i32, ptr %121, i32 %111
  store volatile i32 -1, ptr %122, align 4, !tbaa !16
  %123 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !51

124:                                              ; preds = %113
  %125 = getelementptr inbounds nuw i32, ptr %23, i32 %24
  %126 = load volatile i32, ptr %125, align 4, !tbaa !16
  %127 = and i32 %126, 255
  %128 = icmp eq i32 %127, 255
  br i1 %128, label %129, label %137

129:                                              ; preds = %124
  %130 = mul i32 %24, 400
  %131 = getelementptr inbounds nuw i8, ptr %23, i32 %130
  %132 = load volatile i32, ptr %131, align 4, !tbaa !16
  %133 = and i32 %132, 65280
  %134 = icmp eq i32 %133, 0
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.75) #10
  %135 = call i32 @pause(i32 noundef 1000) #10
  %136 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #10
  br i1 %134, label %142, label %140

137:                                              ; preds = %113, %124
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.75) #10
  %138 = call i32 @pause(i32 noundef 1000) #10
  %139 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #10
  br label %140

140:                                              ; preds = %137, %129
  %141 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.76, i32 noundef 20) #10
  br label %147

142:                                              ; preds = %129
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.77) #10
  %143 = load i32, ptr %26, align 4, !tbaa !46
  call void @fputnum(i32 noundef 1, i32 noundef %143) #10
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.78) #10
  %144 = load i32, ptr %16, align 4, !tbaa !44
  call void @fputnum(i32 noundef 1, i32 noundef %144) #10
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.78) #10
  %145 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %146 = load i32, ptr %145, align 4, !tbaa !52
  call void @fputnum(i32 noundef 1, i32 noundef %146) #10
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.20) #10
  br label %147

147:                                              ; preds = %142, %140
  %148 = phi i32 [ 0, %142 ], [ 1, %140 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %2) #11
  br label %149

149:                                              ; preds = %147, %10, %5
  %150 = phi i32 [ 1, %5 ], [ 1, %10 ], [ %148, %147 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #11
  ret i32 %150
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_show(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = alloca %struct.fbinfo, align 4
  %4 = alloca %struct.stat, align 4
  %5 = alloca %struct.dirent, align 2
  %6 = alloca [64 x i8], align 1
  %7 = alloca i8, align 1
  %8 = alloca i8, align 1
  %9 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %3) #11
  %10 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %3) #10
  %11 = icmp slt i32 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %2
  %13 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.79, i32 noundef 12) #10
  br label %257

14:                                               ; preds = %2
  store i32 0, ptr @nshow, align 4, !tbaa !16
  %15 = icmp eq i32 %0, 2
  br i1 %15, label %16, label %140

16:                                               ; preds = %14
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #11
  %17 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %18 = load ptr, ptr %17, align 4, !tbaa !3
  %19 = call i32 @open(ptr noundef %18, i32 noundef 0) #10
  %20 = icmp slt i32 %19, 0
  br i1 %20, label %138, label %21

21:                                               ; preds = %16
  %22 = call i32 @fstat(i32 noundef %19, ptr noundef nonnull %4) #10
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %138, label %24

24:                                               ; preds = %21
  %25 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %26 = load i16, ptr %25, align 4, !tbaa !53
  %27 = icmp eq i16 %26, 1
  br i1 %27, label %28, label %121

28:                                               ; preds = %24
  %29 = load ptr, ptr %17, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #11
  %30 = getelementptr inbounds nuw i8, ptr %5, i32 2
  br label %31

31:                                               ; preds = %65, %28
  %32 = call i32 @read(i32 noundef %19, ptr noundef nonnull %5, i32 noundef 64) #10
  %33 = icmp eq i32 %32, 64
  br i1 %33, label %34, label %77

34:                                               ; preds = %31
  %35 = load i16, ptr %5, align 2, !tbaa !57
  %36 = icmp eq i16 %35, 0
  br i1 %36, label %65, label %37

37:                                               ; preds = %34, %37
  %38 = phi i32 [ %42, %37 ], [ 0, %34 ]
  %39 = getelementptr inbounds nuw i8, ptr %30, i32 %38
  %40 = load i8, ptr %39, align 1, !tbaa !8
  %41 = icmp eq i8 %40, 0
  %42 = add nuw nsw i32 %38, 1
  br i1 %41, label %43, label %37, !llvm.loop !59

43:                                               ; preds = %37
  %44 = getelementptr inbounds nuw i8, ptr %30, i32 %38
  %45 = icmp samesign ult i32 %38, 4
  br i1 %45, label %65, label %46

46:                                               ; preds = %43
  %47 = getelementptr inbounds i8, ptr %44, i32 -4
  %48 = load i8, ptr %47, align 1, !tbaa !8
  %49 = icmp eq i8 %48, 46
  br i1 %49, label %50, label %65

50:                                               ; preds = %46
  %51 = getelementptr inbounds i8, ptr %44, i32 -3
  %52 = load i8, ptr %51, align 1, !tbaa !8
  switch i8 %52, label %65 [
    i8 115, label %53
    i8 83, label %53
  ]

53:                                               ; preds = %50, %50
  %54 = getelementptr inbounds i8, ptr %44, i32 -2
  %55 = load i8, ptr %54, align 1, !tbaa !8
  switch i8 %55, label %65 [
    i8 108, label %56
    i8 76, label %56
  ]

56:                                               ; preds = %53, %53
  %57 = getelementptr inbounds i8, ptr %44, i32 -1
  %58 = load i8, ptr %57, align 1, !tbaa !8
  switch i8 %58, label %65 [
    i8 100, label %59
    i8 68, label %59
  ]

59:                                               ; preds = %56, %56
  %60 = load i8, ptr %30, align 2, !tbaa !8
  %61 = icmp eq i8 %60, 46
  br i1 %61, label %65, label %62

62:                                               ; preds = %59
  %63 = load i32, ptr @nshow, align 4, !tbaa !16
  %64 = icmp slt i32 %63, 32
  br i1 %64, label %66, label %65

65:                                               ; preds = %62, %69, %34, %43, %46, %50, %53, %56, %59
  br label %31, !llvm.loop !60

66:                                               ; preds = %62, %72
  %67 = phi i32 [ %76, %72 ], [ 0, %62 ]
  %68 = icmp eq i32 %67, 62
  br i1 %68, label %69, label %72

69:                                               ; preds = %66
  %70 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %63, i32 62
  store i8 0, ptr %70, align 1, !tbaa !8
  %71 = add nsw i32 %63, 1
  store i32 %71, ptr @nshow, align 4, !tbaa !16
  br label %65

72:                                               ; preds = %66
  %73 = getelementptr inbounds nuw [62 x i8], ptr %30, i32 0, i32 %67
  %74 = load i8, ptr %73, align 1, !tbaa !8
  %75 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %63, i32 %67
  store i8 %74, ptr %75, align 1, !tbaa !8
  %76 = add nuw nsw i32 %67, 1
  br label %66, !llvm.loop !61

77:                                               ; preds = %31
  %78 = call i32 @close(i32 noundef %19) #10
  br label %79

79:                                               ; preds = %114, %77
  %80 = phi i32 [ 1, %77 ], [ %115, %114 ]
  %81 = load i32, ptr @nshow, align 4, !tbaa !16
  %82 = icmp slt i32 %80, %81
  br i1 %82, label %84, label %83

83:                                               ; preds = %79
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #11
  br label %135

84:                                               ; preds = %79
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %6) #11
  br label %85

85:                                               ; preds = %88, %84
  %86 = phi i32 [ 0, %84 ], [ %92, %88 ]
  %87 = icmp eq i32 %86, 64
  br i1 %87, label %93, label %88

88:                                               ; preds = %85
  %89 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %80, i32 %86
  %90 = load i8, ptr %89, align 1, !tbaa !8
  %91 = getelementptr inbounds nuw [64 x i8], ptr %6, i32 0, i32 %86
  store i8 %90, ptr %91, align 1, !tbaa !8
  %92 = add nuw nsw i32 %86, 1
  br label %85, !llvm.loop !62

93:                                               ; preds = %101, %85
  %94 = phi i32 [ %80, %85 ], [ %95, %101 ]
  %95 = add nsw i32 %94, -1
  %96 = icmp sgt i32 %94, 0
  br i1 %96, label %97, label %109

97:                                               ; preds = %93
  %98 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %95
  %99 = call i32 @strcmp(ptr noundef nonnull %98, ptr noundef nonnull %6) #10
  %100 = icmp sgt i32 %99, 0
  br i1 %100, label %101, label %109

101:                                              ; preds = %97, %104
  %102 = phi i32 [ %108, %104 ], [ 0, %97 ]
  %103 = icmp eq i32 %102, 64
  br i1 %103, label %93, label %104, !llvm.loop !63

104:                                              ; preds = %101
  %105 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %95, i32 %102
  %106 = load i8, ptr %105, align 1, !tbaa !8
  %107 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %94, i32 %102
  store i8 %106, ptr %107, align 1, !tbaa !8
  %108 = add nuw nsw i32 %102, 1
  br label %101, !llvm.loop !64

109:                                              ; preds = %93, %97
  %110 = phi i32 [ 0, %93 ], [ %94, %97 ]
  br label %111

111:                                              ; preds = %116, %109
  %112 = phi i32 [ 0, %109 ], [ %120, %116 ]
  %113 = icmp eq i32 %112, 64
  br i1 %113, label %114, label %116

114:                                              ; preds = %111
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %6) #11
  %115 = add nuw nsw i32 %80, 1
  br label %79, !llvm.loop !65

116:                                              ; preds = %111
  %117 = getelementptr inbounds nuw [64 x i8], ptr %6, i32 0, i32 %112
  %118 = load i8, ptr %117, align 1, !tbaa !8
  %119 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %110, i32 %112
  store i8 %118, ptr %119, align 1, !tbaa !8
  %120 = add nuw nsw i32 %112, 1
  br label %111, !llvm.loop !66

121:                                              ; preds = %24
  %122 = call i32 @close(i32 noundef %19) #10
  br label %123

123:                                              ; preds = %132, %121
  %124 = phi i32 [ 0, %121 ], [ %134, %132 ]
  %125 = load ptr, ptr %17, align 4, !tbaa !3
  %126 = getelementptr inbounds nuw i8, ptr %125, i32 %124
  %127 = load i8, ptr %126, align 1, !tbaa !8
  %128 = icmp ne i8 %127, 0
  %129 = icmp samesign ult i32 %124, 63
  %130 = select i1 %128, i1 %129, i1 false
  br i1 %130, label %132, label %131

131:                                              ; preds = %123
  store i32 1, ptr @nshow, align 4, !tbaa !16
  br label %135

132:                                              ; preds = %123
  %133 = getelementptr inbounds nuw [64 x i8], ptr @shownames, i32 0, i32 %124
  store i8 %127, ptr %133, align 1, !tbaa !8
  %134 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !67

135:                                              ; preds = %131, %83
  %136 = phi i32 [ 1, %131 ], [ %81, %83 ]
  %137 = phi ptr [ null, %131 ], [ %29, %83 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #11
  br label %164

138:                                              ; preds = %16, %21
  %139 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.80, i32 noundef 18) #10
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #11
  br label %257

140:                                              ; preds = %14
  %141 = icmp sgt i32 %0, 2
  br i1 %141, label %142, label %168

142:                                              ; preds = %140, %161
  %143 = phi i32 [ %162, %161 ], [ 0, %140 ]
  %144 = phi i32 [ %163, %161 ], [ 1, %140 ]
  %145 = icmp slt i32 %144, %0
  %146 = icmp samesign ult i32 %143, 32
  %147 = select i1 %145, i1 %146, i1 false
  br i1 %147, label %148, label %164

148:                                              ; preds = %142
  %149 = getelementptr inbounds nuw ptr, ptr %1, i32 %144
  br label %150

150:                                              ; preds = %148, %159
  %151 = phi i32 [ %160, %159 ], [ 0, %148 ]
  %152 = load ptr, ptr %149, align 4, !tbaa !3
  %153 = getelementptr inbounds nuw i8, ptr %152, i32 %151
  %154 = load i8, ptr %153, align 1, !tbaa !8
  %155 = icmp ne i8 %154, 0
  %156 = icmp samesign ult i32 %151, 63
  %157 = select i1 %155, i1 %156, i1 false
  %158 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %143, i32 %151
  br i1 %157, label %159, label %161

159:                                              ; preds = %150
  store i8 %154, ptr %158, align 1, !tbaa !8
  %160 = add nuw nsw i32 %151, 1
  br label %150, !llvm.loop !68

161:                                              ; preds = %150
  store i8 0, ptr %158, align 1, !tbaa !8
  %162 = add nuw nsw i32 %143, 1
  store i32 %162, ptr @nshow, align 4, !tbaa !16
  %163 = add nuw nsw i32 %144, 1
  br label %142, !llvm.loop !69

164:                                              ; preds = %142, %135
  %165 = phi i32 [ %136, %135 ], [ %143, %142 ]
  %166 = phi ptr [ %137, %135 ], [ null, %142 ]
  %167 = icmp eq i32 %165, 0
  br i1 %167, label %168, label %170

168:                                              ; preds = %140, %164
  %169 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.81, i32 noundef 49) #10
  br label %257

170:                                              ; preds = %164
  %171 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #10
  %172 = icmp slt i32 %171, 0
  br i1 %172, label %173, label %175

173:                                              ; preds = %170
  %174 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.82, i32 noundef 14) #10
  br label %257

175:                                              ; preds = %170
  %176 = call i32 @ttyraw(i32 noundef 1) #10
  %177 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %178 = load i32, ptr %177, align 4, !tbaa !44
  %179 = getelementptr inbounds nuw i8, ptr %3, i32 16
  %180 = load i32, ptr %179, align 4, !tbaa !43
  %181 = mul i32 %180, %178
  %182 = load i32, ptr %3, align 4, !tbaa !41
  call fastcc void @show_load(ptr noundef %166, ptr noundef nonnull @shownames, i32 noundef %182, i32 noundef %181) #8
  br label %183

183:                                              ; preds = %251, %175
  %184 = phi i32 [ 0, %175 ], [ %252, %251 ]
  %185 = phi i32 [ 31, %175 ], [ %226, %251 ]
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %7) #11
  br label %186

186:                                              ; preds = %197, %183
  %187 = phi i32 [ 0, %183 ], [ %198, %197 ]
  %188 = phi i32 [ 0, %183 ], [ %191, %197 ]
  br label %190

189:                                              ; preds = %195, %195
  br label %190

190:                                              ; preds = %189, %186
  %191 = phi i32 [ %188, %186 ], [ 1, %189 ]
  br label %192

192:                                              ; preds = %190, %212
  %193 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %7, i32 noundef 1) #10
  %194 = icmp eq i32 %193, 1
  br i1 %194, label %195, label %213

195:                                              ; preds = %192
  %196 = load i8, ptr %7, align 1, !tbaa !8
  switch i8 %196, label %212 [
    i8 113, label %189
    i8 3, label %189
    i8 110, label %197
    i8 32, label %197
    i8 108, label %197
    i8 112, label %199
    i8 104, label %199
    i8 27, label %200
  ], !llvm.loop !70

197:                                              ; preds = %195, %195, %195, %199, %200
  %198 = phi i32 [ %211, %200 ], [ -1, %199 ], [ 1, %195 ], [ 1, %195 ], [ 1, %195 ]
  br label %186, !llvm.loop !70

199:                                              ; preds = %195, %195
  br label %197

200:                                              ; preds = %195
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %8) #11
  store i8 0, ptr %8, align 1, !tbaa !8
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %9) #11
  store i8 0, ptr %9, align 1, !tbaa !8
  %201 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %8, i32 noundef 1) #10
  %202 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %9, i32 noundef 1) #10
  %203 = load i8, ptr %8, align 1, !tbaa !8
  %204 = icmp eq i8 %203, 91
  %205 = load i8, ptr %9, align 1
  %206 = icmp eq i8 %205, 67
  %207 = select i1 %204, i1 %206, i1 false
  %208 = icmp eq i8 %205, 68
  %209 = select i1 %204, i1 %208, i1 false
  %210 = select i1 %209, i32 -1, i32 %187
  %211 = select i1 %207, i32 1, i32 %210
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %9) #11
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %8) #11
  br label %197

212:                                              ; preds = %195
  br label %192, !llvm.loop !70

213:                                              ; preds = %192
  %214 = call i32 @gpioctl(i32 noundef 2, i32 noundef 26, i32 noundef 0) #10
  %215 = call i32 @gpioctl(i32 noundef 2, i32 noundef 27, i32 noundef 0) #10
  %216 = shl i32 %215, 1
  %217 = or i32 %216, %214
  %218 = call i32 @gpioctl(i32 noundef 2, i32 noundef 28, i32 noundef 0) #10
  %219 = shl i32 %218, 2
  %220 = or i32 %217, %219
  %221 = call i32 @gpioctl(i32 noundef 2, i32 noundef 29, i32 noundef 0) #10
  %222 = shl i32 %221, 3
  %223 = or i32 %220, %222
  %224 = call i32 @gpioctl(i32 noundef 2, i32 noundef 24, i32 noundef 0) #10
  %225 = shl i32 %224, 4
  %226 = or i32 %223, %225
  %227 = xor i32 %226, -1
  %228 = and i32 %185, %227
  %229 = and i32 %228, 10
  %230 = icmp eq i32 %229, 0
  %231 = and i32 %228, 5
  %232 = icmp eq i32 %231, 0
  %233 = select i1 %232, i32 %187, i32 -1
  %234 = select i1 %230, i32 %233, i32 1
  %235 = and i32 %228, 16
  %236 = or disjoint i32 %235, %191
  %237 = icmp eq i32 %236, 0
  br i1 %237, label %238, label %254

238:                                              ; preds = %213
  %239 = icmp eq i32 %234, 0
  br i1 %239, label %251, label %240

240:                                              ; preds = %238
  %241 = add nsw i32 %234, %184
  %242 = icmp slt i32 %241, 0
  %243 = load i32, ptr @nshow, align 4
  %244 = add nsw i32 %243, -1
  %245 = select i1 %242, i32 %244, i32 %241
  %246 = icmp slt i32 %245, %243
  %247 = select i1 %246, i32 %245, i32 0
  %248 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %247
  %249 = load i32, ptr %3, align 4, !tbaa !41
  call fastcc void @show_load(ptr noundef %166, ptr noundef nonnull %248, i32 noundef %249, i32 noundef %181) #8
  %250 = call i32 @pause(i32 noundef 8) #10
  br label %251

251:                                              ; preds = %238, %240
  %252 = phi i32 [ %247, %240 ], [ %184, %238 ]
  %253 = call i32 @pause(i32 noundef 2) #10
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %7) #11
  br label %183

254:                                              ; preds = %213
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %7) #11
  %255 = call i32 @ttyraw(i32 noundef 0) #10
  %256 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #10
  br label %257

257:                                              ; preds = %138, %168, %173, %254, %12
  %258 = phi i32 [ 1, %12 ], [ 1, %168 ], [ 1, %173 ], [ 0, %254 ], [ 1, %138 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %3) #11
  ret i32 %258
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
  br label %3, !llvm.loop !71

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
  br i1 %14, label %15, label %3, !llvm.loop !72

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
  br label %17, !llvm.loop !73

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
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.23, i32 noundef 33) #10
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
  br label %5, !llvm.loop !74

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
  br label %12, !llvm.loop !75

32:                                               ; preds = %5
  tail call fastcc void @emitn(i32 noundef %9) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.45) #8
  tail call fastcc void @emitn(i32 noundef %6) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.45) #8
  tail call fastcc void @emitn(i32 noundef %7) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.45) #8
  tail call fastcc void @emit(ptr noundef %1) #8
  tail call fastcc void @emit(ptr noundef nonnull @.str.20) #8
  tail call fastcc void @flush() #8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @mkdir(ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @unlink(ptr noundef) local_unnamed_addr #5

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
  br label %2, !llvm.loop !76

13:                                               ; preds = %2
  ret i32 %4
}

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @pinmux(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize noreturn nounwind optsize
define internal void @blink_int(i32 %0) #0 {
  %2 = load i32, ptr @blink_pin, align 4, !tbaa !16
  %3 = icmp sgt i32 %2, -1
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  %5 = tail call i32 @gpioctl(i32 noundef 0, i32 noundef %2, i32 noundef 0) #10
  br label %6

6:                                                ; preds = %4, %1
  %7 = tail call i32 @exit(i32 noundef 0) #9
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @pioctl(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @fbctl(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @fputnum(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @ttyraw(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_load(ptr noundef readonly captures(address_is_null) %0, ptr noundef readonly captures(none) %1, i32 noundef %2, i32 noundef %3) unnamed_addr #4 {
  %5 = alloca [96 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 96, ptr nonnull %5) #11
  %6 = icmp eq ptr %0, null
  br i1 %6, label %25, label %7

7:                                                ; preds = %4, %14
  %8 = phi i32 [ %15, %14 ], [ 0, %4 ]
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 %8
  %10 = load i8, ptr %9, align 1, !tbaa !8
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %7
  %13 = icmp eq i32 %8, 0
  br i1 %13, label %25, label %17

14:                                               ; preds = %7
  %15 = add nuw nsw i32 %8, 1
  %16 = getelementptr inbounds nuw [96 x i8], ptr %5, i32 0, i32 %8
  store i8 %10, ptr %16, align 1, !tbaa !8
  br label %7, !llvm.loop !77

17:                                               ; preds = %12
  %18 = add nsw i32 %8, -1
  %19 = getelementptr inbounds [96 x i8], ptr %5, i32 0, i32 %18
  %20 = load i8, ptr %19, align 1, !tbaa !8
  %21 = icmp eq i8 %20, 47
  br i1 %21, label %25, label %22

22:                                               ; preds = %17
  %23 = add nuw nsw i32 %8, 1
  %24 = getelementptr inbounds nuw [96 x i8], ptr %5, i32 0, i32 %8
  store i8 47, ptr %24, align 1, !tbaa !8
  br label %25

25:                                               ; preds = %12, %17, %22, %4
  %26 = phi i32 [ 0, %4 ], [ %23, %22 ], [ %8, %17 ], [ 0, %12 ]
  br label %27

27:                                               ; preds = %25, %39
  %28 = phi i32 [ %42, %39 ], [ 0, %25 ]
  %29 = phi i32 [ %40, %39 ], [ %26, %25 ]
  %30 = getelementptr inbounds nuw i8, ptr %1, i32 %28
  %31 = load i8, ptr %30, align 1, !tbaa !8
  %32 = icmp ne i8 %31, 0
  %33 = icmp slt i32 %29, 94
  %34 = select i1 %32, i1 %33, i1 false
  br i1 %34, label %39, label %35

35:                                               ; preds = %27
  %36 = getelementptr inbounds [96 x i8], ptr %5, i32 0, i32 %29
  store i8 0, ptr %36, align 1, !tbaa !8
  %37 = call i32 @open(ptr noundef nonnull %5, i32 noundef 0) #10
  %38 = icmp slt i32 %37, 0
  br i1 %38, label %55, label %43

39:                                               ; preds = %27
  %40 = add nsw i32 %29, 1
  %41 = getelementptr inbounds [96 x i8], ptr %5, i32 0, i32 %29
  store i8 %31, ptr %41, align 1, !tbaa !8
  %42 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !78

43:                                               ; preds = %35, %46
  %44 = phi i32 [ %52, %46 ], [ 0, %35 ]
  %45 = icmp ult i32 %44, %3
  br i1 %45, label %46, label %53

46:                                               ; preds = %43
  %47 = add i32 %44, %2
  %48 = inttoptr i32 %47 to ptr
  %49 = sub nuw i32 %3, %44
  %50 = call i32 @read(i32 noundef %37, ptr noundef %48, i32 noundef %49) #10
  %51 = icmp slt i32 %50, 1
  %52 = add i32 %50, %44
  br i1 %51, label %53, label %43

53:                                               ; preds = %46, %43
  %54 = call i32 @close(i32 noundef %37) #10
  br label %55

55:                                               ; preds = %35, %53
  call void @llvm.lifetime.end.p0(i64 96, ptr nonnull %5) #11
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read_nb(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

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
!23 = !{!24, !4, i64 0}
!24 = !{!"", !4, i64 0, !17, i64 4}
!25 = !{!24, !17, i64 4}
!26 = distinct !{!26, !10, !11}
!27 = distinct !{!27, !11}
!28 = !{!29, !17, i64 0}
!29 = !{!"pio_prog", !17, i64 0, !17, i64 4, !17, i64 8, !6, i64 12}
!30 = !{!29, !17, i64 4}
!31 = !{!29, !17, i64 8}
!32 = !{!33, !17, i64 0}
!33 = !{!"pio_smcfg", !17, i64 0, !17, i64 4, !17, i64 8, !17, i64 12, !17, i64 16, !17, i64 20, !17, i64 24}
!34 = !{!33, !17, i64 4}
!35 = !{!33, !17, i64 8}
!36 = !{!33, !17, i64 12}
!37 = !{!33, !17, i64 16}
!38 = !{!33, !17, i64 20}
!39 = !{!33, !17, i64 24}
!40 = distinct !{!40, !10, !11}
!41 = !{!42, !17, i64 0}
!42 = !{!"fbinfo", !17, i64 0, !17, i64 4, !17, i64 8, !17, i64 12, !17, i64 16}
!43 = !{!42, !17, i64 16}
!44 = !{!42, !17, i64 8}
!45 = distinct !{!45, !10, !11}
!46 = !{!42, !17, i64 4}
!47 = distinct !{!47, !10, !11}
!48 = distinct !{!48, !10, !11}
!49 = distinct !{!49, !10, !11}
!50 = distinct !{!50, !10, !11}
!51 = distinct !{!51, !10, !11}
!52 = !{!42, !17, i64 12}
!53 = !{!54, !55, i64 8}
!54 = !{!"stat", !17, i64 0, !17, i64 4, !55, i64 8, !55, i64 10, !56, i64 12}
!55 = !{!"short", !6, i64 0}
!56 = !{!"long", !6, i64 0}
!57 = !{!58, !55, i64 0}
!58 = !{!"dirent", !55, i64 0, !6, i64 2}
!59 = distinct !{!59, !10, !11}
!60 = distinct !{!60, !10, !11}
!61 = distinct !{!61, !10, !11}
!62 = distinct !{!62, !10, !11}
!63 = distinct !{!63, !10, !11}
!64 = distinct !{!64, !10, !11}
!65 = distinct !{!65, !10, !11}
!66 = distinct !{!66, !10, !11}
!67 = distinct !{!67, !10, !11}
!68 = distinct !{!68, !10, !11}
!69 = distinct !{!69, !10, !11}
!70 = distinct !{!70, !10, !11}
!71 = distinct !{!71, !10, !11}
!72 = distinct !{!72, !10, !11}
!73 = distinct !{!73, !10, !11}
!74 = distinct !{!74, !10, !11}
!75 = distinct !{!75, !10, !11}
!76 = distinct !{!76, !10, !11}
!77 = distinct !{!77, !10, !11}
!78 = distinct !{!78, !10, !11}
