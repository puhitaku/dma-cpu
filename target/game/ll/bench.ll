; ModuleID = 'bench.c'
source_filename = "bench.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [11 x i8] c"bench: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"BENCHMARK\00", align 1
@.str.2 = private unnamed_addr constant [27 x i8] c"fixed work, hardware timer\00", align 1
@xs = internal unnamed_addr global i32 0, align 4
@bench_run.kf = internal unnamed_addr constant [8 x ptr] [ptr @k_bogo, ptr @k_sieve, ptr @k_sort, ptr @k_mul, ptr @k_div, ptr @k_rand, ptr @k_shr1, ptr @k_mem], align 4
@knames = internal unnamed_addr constant [8 x ptr] [ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.22, ptr @.str.23, ptr @.str.24, ptr @.str.25], align 4
@.str.3 = private unnamed_addr constant [4 x i8] c"...\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"BENCH \00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c" ops=\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c" us=\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c" sum=\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.9 = private unnamed_addr constant [3 x i8] c"ms\00", align 1
@kunit = internal unnamed_addr constant [8 x ptr] [ptr @.str.26, ptr @.str.27, ptr @.str.28, ptr @.str.29, ptr @.str.30, ptr @.str.31, ptr @.str.32, ptr @.str.33], align 4
@.str.10 = private unnamed_addr constant [5 x i8] c"MIPS\00", align 1
@.str.11 = private unnamed_addr constant [26 x i8] c"ISA instr/s via bogo loop\00", align 1
@.str.12 = private unnamed_addr constant [23 x i8] c"BogoMIPS (linux conv):\00", align 1
@.str.13 = private unnamed_addr constant [12 x i8] c"press: back\00", align 1
@.str.14 = private unnamed_addr constant [15 x i8] c"BENCH mips100=\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c" bogo100=\00", align 1
@.str.16 = private unnamed_addr constant [13 x i8] c"\0Abench done\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.17 = private unnamed_addr constant [13 x i8] c"bench: back\0A\00", align 1
@bogo_i = internal global i32 0, align 4
@.str.18 = private unnamed_addr constant [6 x i8] c"bogo \00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"sieve\00", align 1
@.str.20 = private unnamed_addr constant [6 x i8] c"sort \00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"mul  \00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"div  \00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"rand \00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"shr1 \00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"mem  \00", align 1
@.str.26 = private unnamed_addr constant [7 x i8] c"loop/s\00", align 1
@.str.27 = private unnamed_addr constant [7 x i8] c"mark/s\00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"cmp/s \00", align 1
@.str.29 = private unnamed_addr constant [7 x i8] c"mul/s \00", align 1
@.str.30 = private unnamed_addr constant [7 x i8] c"div/s \00", align 1
@.str.31 = private unnamed_addr constant [7 x i8] c"rnd/s \00", align 1
@.str.32 = private unnamed_addr constant [7 x i8] c"shr/s \00", align 1
@.str.33 = private unnamed_addr constant [7 x i8] c"word/s\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @bench_run() local_unnamed_addr #0 {
  %1 = alloca [8 x i32], align 4
  %2 = alloca [32 x i8], align 1
  %3 = alloca i32, align 4
  %4 = alloca [16 x i8], align 1
  tail call void @uputs(ptr noundef nonnull @.str) #8
  tail call void @led(i32 noundef 985088, i32 noundef 985088) #8
  tail call void @gfx_clear(i16 noundef zeroext 2147) #8
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 8, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 2147) #8
  tail call void @gfx_text(i32 noundef 8, i32 noundef 32, ptr noundef nonnull @.str.2, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  tail call void @gfx_present() #8
  store i32 -1056969215, ptr @xs, align 4, !tbaa !3
  br label %5

5:                                                ; preds = %8, %0
  %6 = phi i32 [ 0, %0 ], [ %11, %8 ]
  %7 = icmp eq i32 %6, 512
  br i1 %7, label %12, label %8

8:                                                ; preds = %5
  %9 = tail call fastcc i32 @xrand() #9
  %10 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537125120 to ptr), i32 %6
  store i32 %9, ptr %10, align 4, !tbaa !3
  %11 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !7

12:                                               ; preds = %5, %15
  %13 = phi i32 [ %23, %15 ], [ 0, %5 ]
  %14 = icmp eq i32 %13, 144
  br i1 %14, label %24, label %15

15:                                               ; preds = %12
  %16 = tail call fastcc i32 @xrand() #9
  %17 = and i32 %16, 255
  %18 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537129216 to ptr), i32 %13
  store i32 %17, ptr %18, align 4, !tbaa !3
  %19 = tail call fastcc i32 @xrand() #9
  %20 = and i32 %19, 255
  %21 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537129792 to ptr), i32 %13
  store i32 %20, ptr %21, align 4, !tbaa !3
  %22 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537130368 to ptr), i32 %13
  store i32 0, ptr %22, align 4, !tbaa !3
  %23 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !10

24:                                               ; preds = %12, %33
  %25 = phi i32 [ %37, %33 ], [ 0, %12 ]
  %26 = icmp eq i32 %25, 192
  br i1 %26, label %27, label %33

27:                                               ; preds = %24
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #10
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #10
  %28 = getelementptr inbounds nuw i8, ptr %2, i32 5
  %29 = getelementptr inbounds nuw i8, ptr %2, i32 3
  %30 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %31 = getelementptr inbounds nuw i8, ptr %2, i32 1
  %32 = getelementptr inbounds nuw i8, ptr %2, i32 2
  br label %38

33:                                               ; preds = %24
  %34 = tail call fastcc i32 @xrand() #9
  %35 = or i32 %34, 1
  %36 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537127680 to ptr), i32 %25
  store i32 %35, ptr %36, align 4, !tbaa !3
  %37 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !11

38:                                               ; preds = %117, %27
  %39 = phi i32 [ 0, %27 ], [ %120, %117 ]
  %40 = icmp eq i32 %39, 8
  br i1 %40, label %41, label %69

41:                                               ; preds = %38
  %42 = load i32, ptr %1, align 4, !tbaa !3
  %43 = udiv i32 111350000, %42
  %44 = udiv i32 13107200, %42
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #10
  %45 = udiv i32 %43, 100
  call void @numsp(ptr noundef nonnull %4, i32 noundef 3, i32 noundef %45) #8
  %46 = getelementptr inbounds nuw i8, ptr %4, i32 3
  store i8 46, ptr %46, align 1, !tbaa !12
  %47 = freeze i32 %43
  %48 = udiv i32 %47, 10
  %49 = urem i32 %48, 10
  %50 = trunc nuw nsw i32 %49 to i8
  %51 = or disjoint i8 %50, 48
  %52 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store i8 %51, ptr %52, align 1, !tbaa !12
  %53 = mul i32 %48, 10
  %54 = sub i32 %47, %53
  %55 = trunc nuw nsw i32 %54 to i8
  %56 = or disjoint i8 %55, 48
  %57 = getelementptr inbounds nuw i8, ptr %4, i32 5
  store i8 %56, ptr %57, align 1, !tbaa !12
  %58 = getelementptr inbounds nuw i8, ptr %4, i32 6
  store i8 0, ptr %58, align 1, !tbaa !12
  call void @gfx_text2(i32 noundef 8, i32 noundef 160, ptr noundef nonnull %4, i16 noundef zeroext 24465, i16 noundef zeroext 2147) #8
  call void @gfx_text2(i32 noundef 112, i32 noundef 160, ptr noundef nonnull @.str.10, i16 noundef zeroext -377, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 8, i32 noundef 184, ptr noundef nonnull @.str.11, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  %59 = udiv i32 %44, 100
  call void @numsp(ptr noundef nonnull %4, i32 noundef 3, i32 noundef %59) #8
  store i8 46, ptr %46, align 1, !tbaa !12
  %60 = freeze i32 %44
  %61 = udiv i32 %60, 10
  %62 = urem i32 %61, 10
  %63 = trunc nuw nsw i32 %62 to i8
  %64 = or disjoint i8 %63, 48
  store i8 %64, ptr %52, align 1, !tbaa !12
  %65 = mul i32 %61, 10
  %66 = sub i32 %60, %65
  %67 = trunc nuw nsw i32 %66 to i8
  %68 = or disjoint i8 %67, 48
  store i8 %68, ptr %57, align 1, !tbaa !12
  store i8 0, ptr %58, align 1, !tbaa !12
  call void @gfx_text(i32 noundef 8, i32 noundef 198, ptr noundef nonnull @.str.12, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 184, i32 noundef 198, ptr noundef nonnull %4, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 8, i32 noundef 226, ptr noundef nonnull @.str.13, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_present() #8
  call void @uputs(ptr noundef nonnull @.str.14) #8
  call void @uputn(i32 noundef %43) #8
  call void @uputs(ptr noundef nonnull @.str.15) #8
  call void @uputn(i32 noundef %44) #8
  call void @uputs(ptr noundef nonnull @.str.16) #8
  call void @led(i32 noundef 3844, i32 noundef 3844) #8
  call void @snd_play(i32 noundef 659, i32 noundef 55, i32 noundef 255) #8
  call void @delay_us(i32 noundef 60000) #8
  call void @snd_play(i32 noundef 784, i32 noundef 55, i32 noundef 255) #8
  call void @delay_us(i32 noundef 90000) #8
  call void @snd_off() #8
  br label %121

69:                                               ; preds = %38
  %70 = mul nuw nsw i32 %39, 13
  %71 = add nuw nsw i32 %70, 48
  %72 = getelementptr inbounds nuw [8 x ptr], ptr @knames, i32 0, i32 %39
  %73 = load ptr, ptr %72, align 4, !tbaa !13
  call void @gfx_text(i32 noundef 8, i32 noundef %71, ptr noundef %73, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 56, i32 noundef %71, ptr noundef nonnull @.str.3, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_present() #8
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #10
  store i32 0, ptr %3, align 4, !tbaa !3
  %74 = call i32 @now_us() #8
  %75 = getelementptr inbounds nuw [8 x ptr], ptr @bench_run.kf, i32 0, i32 %39
  %76 = load ptr, ptr %75, align 4, !tbaa !16
  %77 = call i32 %76(ptr noundef nonnull %3) #8
  %78 = call i32 @now_us() #8
  %79 = sub i32 %78, %74
  %80 = icmp eq i32 %78, %74
  %81 = select i1 %80, i32 1, i32 %79
  %82 = getelementptr inbounds nuw [8 x i32], ptr %1, i32 0, i32 %39
  store i32 %81, ptr %82, align 4, !tbaa !3
  call void @uputs(ptr noundef nonnull @.str.4) #8
  call void @uputs(ptr noundef %73) #8
  call void @uputs(ptr noundef nonnull @.str.5) #8
  %83 = load i32, ptr %3, align 4, !tbaa !3
  call void @uputn(i32 noundef %83) #8
  call void @uputs(ptr noundef nonnull @.str.6) #8
  call void @uputn(i32 noundef %81) #8
  call void @uputs(ptr noundef nonnull @.str.7) #8
  call void @uputhex(i32 noundef %77) #8
  call void @uputs(ptr noundef nonnull @.str.8) #8
  %84 = udiv i32 %81, 1000
  %85 = icmp ult i32 %81, 1000
  %86 = select i1 %85, i32 1, i32 %84
  %87 = load i32, ptr %3, align 4, !tbaa !3
  %88 = freeze i32 %87
  %89 = freeze i32 %86
  %90 = udiv i32 %88, %89
  %91 = mul i32 %90, 1000
  %92 = mul i32 %90, %89
  %93 = sub i32 %88, %92
  %94 = mul nuw i32 %93, 1000
  %95 = udiv i32 %94, %86
  %96 = add i32 %95, %91
  call void @gfx_fill(i32 noundef 56, i32 noundef %71, i32 noundef 176, i32 noundef 12, i16 noundef zeroext 2147) #8
  call void @numsp(ptr noundef nonnull %2, i32 noundef 5, i32 noundef %86) #8
  store i8 0, ptr %28, align 1, !tbaa !12
  call void @gfx_text(i32 noundef 56, i32 noundef %71, ptr noundef nonnull %2, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 96, i32 noundef %71, ptr noundef nonnull @.str.9, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  %97 = icmp ugt i32 %96, 999999
  br i1 %97, label %98, label %110

98:                                               ; preds = %69
  %99 = udiv i32 %96, 100000
  %100 = udiv i32 %96, 1000000
  %101 = trunc nuw nsw i32 %100 to i16
  %102 = urem i16 %101, 10
  %103 = trunc nuw nsw i16 %102 to i8
  %104 = or disjoint i8 %103, 48
  store i8 %104, ptr %2, align 1, !tbaa !12
  store i8 46, ptr %31, align 1, !tbaa !12
  %105 = trunc nuw i32 %99 to i16
  %106 = urem i16 %105, 10
  %107 = trunc nuw nsw i16 %106 to i8
  %108 = or disjoint i8 %107, 48
  store i8 %108, ptr %32, align 1, !tbaa !12
  store i8 77, ptr %29, align 1, !tbaa !12
  store i8 0, ptr %30, align 1, !tbaa !12
  %109 = icmp ugt i32 %96, 9999999
  br i1 %109, label %114, label %117

110:                                              ; preds = %69
  %111 = icmp samesign ugt i32 %96, 999
  br i1 %111, label %112, label %114

112:                                              ; preds = %110
  %113 = udiv i32 %96, 1000
  br label %114

114:                                              ; preds = %110, %98, %112
  %115 = phi i32 [ %113, %112 ], [ %100, %98 ], [ %96, %110 ]
  %116 = phi i8 [ 107, %112 ], [ 77, %98 ], [ 32, %110 ]
  call void @numsp(ptr noundef nonnull %2, i32 noundef 3, i32 noundef %115) #8
  store i8 %116, ptr %29, align 1, !tbaa !12
  store i8 0, ptr %30, align 1, !tbaa !12
  br label %117

117:                                              ; preds = %114, %98
  call void @gfx_text(i32 noundef 128, i32 noundef %71, ptr noundef nonnull %2, i16 noundef zeroext 24465, i16 noundef zeroext 2147) #8
  %118 = getelementptr inbounds nuw [8 x ptr], ptr @kunit, i32 0, i32 %39
  %119 = load ptr, ptr %118, align 4, !tbaa !13
  call void @gfx_text(i32 noundef 172, i32 noundef %71, ptr noundef %119, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_present() #8
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #10
  %120 = add nuw nsw i32 %39, 1
  br label %38, !llvm.loop !17

121:                                              ; preds = %121, %41
  call void @frame_sync(i32 noundef 33000) #8
  call void @in_poll() #8
  %122 = load i32, ptr @in_edge, align 4, !tbaa !3
  %123 = and i32 %122, 31
  %124 = icmp eq i32 %123, 0
  br i1 %124, label %121, label %125, !llvm.loop !18

125:                                              ; preds = %121
  call void @led(i32 noundef 0, i32 noundef 0) #8
  call void @uputs(ptr noundef nonnull @.str.17) #8
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #10
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #10
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #10
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @xrand() unnamed_addr #3 {
  %1 = load i32, ptr @xs, align 4, !tbaa !3
  %2 = shl i32 %1, 13
  %3 = xor i32 %2, %1
  %4 = lshr i32 %3, 17
  %5 = xor i32 %4, %3
  %6 = shl i32 %5, 5
  %7 = xor i32 %6, %5
  store i32 %7, ptr @xs, align 4, !tbaa !3
  ret i32 %7
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: write)
define internal i32 @k_bogo(ptr noundef writeonly captures(none) %0) #4 {
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi i32 [ %11, %7 ], [ 65536, %1 ]
  %4 = phi i32 [ %9, %7 ], [ 0, %1 ]
  store volatile i32 %3, ptr @bogo_i, align 4, !tbaa !3
  %5 = load volatile i32, ptr @bogo_i, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %12, label %7

7:                                                ; preds = %2
  %8 = load volatile i32, ptr @bogo_i, align 4, !tbaa !3
  %9 = add i32 %8, %4
  %10 = load volatile i32, ptr @bogo_i, align 4, !tbaa !3
  %11 = add i32 %10, -1
  br label %2, !llvm.loop !19

12:                                               ; preds = %2
  store i32 65536, ptr %0, align 4, !tbaa !3
  ret i32 %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal i32 @k_sieve(ptr noundef writeonly captures(none) %0) #5 {
  br label %2

2:                                                ; preds = %19, %1
  %3 = phi i32 [ 0, %1 ], [ %15, %19 ]
  %4 = phi i32 [ 0, %1 ], [ %16, %19 ]
  %5 = phi i32 [ 0, %1 ], [ %20, %19 ]
  %6 = icmp eq i32 %5, 2
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  store i32 %3, ptr %0, align 4, !tbaa !3
  ret i32 %4

8:                                                ; preds = %2, %11
  %9 = phi i32 [ %13, %11 ], [ 0, %2 ]
  %10 = icmp eq i32 %9, 4096
  br i1 %10, label %14, label %11

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537121024 to ptr), i32 %9
  store i8 1, ptr %12, align 1, !tbaa !12
  %13 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !20

14:                                               ; preds = %8, %37
  %15 = phi i32 [ %38, %37 ], [ %3, %8 ]
  %16 = phi i32 [ %39, %37 ], [ %4, %8 ]
  %17 = phi i32 [ %40, %37 ], [ 2, %8 ]
  %18 = icmp eq i32 %17, 4096
  br i1 %18, label %19, label %21

19:                                               ; preds = %14
  %20 = add nuw nsw i32 %5, 1
  br label %2, !llvm.loop !21

21:                                               ; preds = %14
  %22 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537121024 to ptr), i32 %17
  %23 = load i8, ptr %22, align 1, !tbaa !12
  %24 = icmp eq i8 %23, 0
  br i1 %24, label %37, label %25

25:                                               ; preds = %21
  %26 = shl nuw nsw i32 %17, 1
  br label %27

27:                                               ; preds = %31, %25
  %28 = phi i32 [ %15, %25 ], [ %33, %31 ]
  %29 = phi i32 [ %26, %25 ], [ %34, %31 ]
  %30 = icmp samesign ult i32 %29, 4096
  br i1 %30, label %31, label %35

31:                                               ; preds = %27
  %32 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537121024 to ptr), i32 %29
  store i8 0, ptr %32, align 1, !tbaa !12
  %33 = add i32 %28, 1
  %34 = add nuw nsw i32 %29, %17
  br label %27, !llvm.loop !22

35:                                               ; preds = %27
  %36 = add i32 %16, 1
  br label %37

37:                                               ; preds = %35, %21
  %38 = phi i32 [ %15, %21 ], [ %28, %35 ]
  %39 = phi i32 [ %16, %21 ], [ %36, %35 ]
  %40 = add nuw nsw i32 %17, 1
  br label %14, !llvm.loop !23
}

; Function Attrs: minsize nounwind optsize
define internal i32 @k_sort(ptr noundef writeonly captures(none) %0) #0 {
  br label %2

2:                                                ; preds = %16, %1
  %3 = phi i32 [ 0, %1 ], [ %26, %16 ]
  %4 = phi i32 [ 0, %1 ], [ %25, %16 ]
  %5 = phi i32 [ 0, %1 ], [ %14, %16 ]
  %6 = icmp eq i32 %3, 4
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  store i32 %5, ptr %0, align 4, !tbaa !3
  ret i32 %4

8:                                                ; preds = %2
  %9 = shl nuw nsw i32 %3, 9
  %10 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537125120 to ptr), i32 %9
  %11 = ptrtoint ptr %10 to i32
  tail call void @gdma_copy(i32 noundef 537127168, i32 noundef %11, i32 noundef 512) #8
  br label %12

12:                                               ; preds = %43, %8
  %13 = phi i32 [ 1, %8 ], [ %47, %43 ]
  %14 = phi i32 [ %5, %8 ], [ %45, %43 ]
  %15 = icmp eq i32 %13, 128
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr inttoptr (i32 537127168 to ptr), align 256, !tbaa !3
  %18 = load i32, ptr inttoptr (i32 537127424 to ptr), align 512, !tbaa !3
  %19 = load i32, ptr inttoptr (i32 537127676 to ptr), align 4, !tbaa !3
  %20 = load i32, ptr inttoptr (i32 537127196 to ptr), align 4, !tbaa !3
  %21 = mul i32 %20, %3
  %22 = add i32 %17, %4
  %23 = add i32 %22, %18
  %24 = add i32 %23, %19
  %25 = add i32 %24, %21
  %26 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !24

27:                                               ; preds = %12
  %28 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537127168 to ptr), i32 %13
  %29 = load i32, ptr %28, align 4, !tbaa !3
  %30 = add i32 %14, %13
  br label %31

31:                                               ; preds = %41, %27
  %32 = phi i32 [ %14, %27 ], [ %36, %41 ]
  %33 = phi i32 [ %13, %27 ], [ %42, %41 ]
  %34 = icmp eq i32 %32, %30
  br i1 %34, label %43, label %35

35:                                               ; preds = %31
  %36 = add i32 %32, 1
  %37 = getelementptr i32, ptr inttoptr (i32 537127168 to ptr), i32 %33
  %38 = getelementptr i8, ptr %37, i32 -4
  %39 = load i32, ptr %38, align 4, !tbaa !3
  %40 = icmp ugt i32 %39, %29
  br i1 %40, label %41, label %43

41:                                               ; preds = %35
  store i32 %39, ptr %37, align 4, !tbaa !3
  %42 = add nsw i32 %33, -1
  br label %31, !llvm.loop !25

43:                                               ; preds = %35, %31
  %44 = phi i32 [ %33, %35 ], [ 0, %31 ]
  %45 = phi i32 [ %36, %35 ], [ %30, %31 ]
  %46 = getelementptr inbounds i32, ptr inttoptr (i32 537127168 to ptr), i32 %44
  store i32 %29, ptr %46, align 4, !tbaa !3
  %47 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !26
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal i32 @k_mul(ptr noundef writeonly captures(none) %0) #5 {
  br label %2

2:                                                ; preds = %13, %1
  %3 = phi i32 [ %16, %13 ], [ 12, %1 ]
  %4 = phi i32 [ %14, %13 ], [ 0, %1 ]
  %5 = phi i32 [ %15, %13 ], [ 0, %1 ]
  %6 = icmp eq i32 %5, 12
  br i1 %6, label %9, label %7

7:                                                ; preds = %2
  %8 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537130368 to ptr), i32 %4
  br label %10

9:                                                ; preds = %2
  store i32 1728, ptr %0, align 4, !tbaa !3
  br label %34

10:                                               ; preds = %7, %22
  %11 = phi i32 [ %24, %22 ], [ 0, %7 ]
  %12 = icmp eq i32 %11, 12
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  %14 = add nuw nsw i32 %4, 12
  %15 = add nuw nsw i32 %5, 1
  %16 = add nuw nsw i32 %3, 12
  br label %2, !llvm.loop !27

17:                                               ; preds = %10, %25
  %18 = phi i32 [ %31, %25 ], [ 0, %10 ]
  %19 = phi i32 [ %32, %25 ], [ %4, %10 ]
  %20 = phi i32 [ %33, %25 ], [ %11, %10 ]
  %21 = icmp eq i32 %19, %3
  br i1 %21, label %22, label %25

22:                                               ; preds = %17
  %23 = getelementptr inbounds nuw i32, ptr %8, i32 %11
  store i32 %18, ptr %23, align 4, !tbaa !3
  %24 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !28

25:                                               ; preds = %17
  %26 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537129216 to ptr), i32 %19
  %27 = load i32, ptr %26, align 4, !tbaa !3
  %28 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537129792 to ptr), i32 %20
  %29 = load i32, ptr %28, align 4, !tbaa !3
  %30 = mul i32 %29, %27
  %31 = add i32 %30, %18
  %32 = add nuw nsw i32 %19, 1
  %33 = add nuw nsw i32 %20, 12
  br label %17, !llvm.loop !29

34:                                               ; preds = %39, %9
  %35 = phi i32 [ 0, %9 ], [ %42, %39 ]
  %36 = phi i32 [ 0, %9 ], [ %43, %39 ]
  %37 = icmp eq i32 %36, 144
  br i1 %37, label %38, label %39

38:                                               ; preds = %34
  ret i32 %35

39:                                               ; preds = %34
  %40 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537130368 to ptr), i32 %36
  %41 = load i32, ptr %40, align 4, !tbaa !3
  %42 = add i32 %41, %35
  %43 = add nuw nsw i32 %36, 1
  br label %34, !llvm.loop !30
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none)
define internal i32 @k_div(ptr noundef writeonly captures(none) %0) #6 {
  br label %2

2:                                                ; preds = %22, %1
  %3 = phi i32 [ 0, %1 ], [ %23, %22 ]
  %4 = phi i32 [ 0, %1 ], [ %24, %22 ]
  %5 = phi i32 [ 0, %1 ], [ %17, %22 ]
  %6 = icmp eq i32 %4, 96
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  store i32 %5, ptr %0, align 4, !tbaa !3
  ret i32 %3

8:                                                ; preds = %2
  %9 = shl nuw nsw i32 %4, 3
  %10 = getelementptr inbounds nuw i8, ptr inttoptr (i32 537127680 to ptr), i32 %9
  %11 = load i32, ptr %10, align 8, !tbaa !3
  %12 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %13 = load i32, ptr %12, align 4, !tbaa !3
  br label %14

14:                                               ; preds = %19, %8
  %15 = phi i32 [ %11, %8 ], [ %16, %19 ]
  %16 = phi i32 [ %13, %8 ], [ %20, %19 ]
  %17 = phi i32 [ %5, %8 ], [ %21, %19 ]
  %18 = icmp eq i32 %16, 0
  br i1 %18, label %22, label %19

19:                                               ; preds = %14
  %20 = urem i32 %15, %16
  %21 = add i32 %17, 1
  br label %14, !llvm.loop !31

22:                                               ; preds = %14
  %23 = add i32 %15, %3
  %24 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !32
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal i32 @k_rand(ptr noundef writeonly captures(none) %0) #5 {
  store i32 19088743, ptr @xs, align 4, !tbaa !3
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi i32 [ 0, %1 ], [ %9, %7 ]
  %4 = phi i32 [ 0, %1 ], [ %10, %7 ]
  %5 = icmp eq i32 %4, 2048
  br i1 %5, label %6, label %7

6:                                                ; preds = %2
  store i32 2048, ptr %0, align 4, !tbaa !3
  ret i32 %3

7:                                                ; preds = %2
  %8 = tail call fastcc i32 @xrand() #9
  %9 = add i32 %8, %3
  %10 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !33
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define internal i32 @k_shr1(ptr noundef writeonly captures(none) %0) #7 {
  br label %2

2:                                                ; preds = %8, %1
  %3 = phi i32 [ -559038737, %1 ], [ %11, %8 ]
  %4 = phi i32 [ 0, %1 ], [ %10, %8 ]
  %5 = phi i32 [ 0, %1 ], [ %12, %8 ]
  %6 = icmp eq i32 %5, 1024
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  store i32 1024, ptr %0, align 4, !tbaa !3
  ret i32 %4

8:                                                ; preds = %2
  %9 = lshr i32 %3, 1
  %10 = add i32 %4, %9
  %11 = add i32 %3, -1640531527
  %12 = add nuw nsw i32 %5, 1
  br label %2, !llvm.loop !34
}

; Function Attrs: minsize nounwind optsize
define internal i32 @k_mem(ptr noundef writeonly captures(none) %0) #0 {
  br label %2

2:                                                ; preds = %9, %1
  %3 = phi i32 [ 0, %1 ], [ %11, %9 ]
  %4 = icmp eq i32 %3, 8
  br i1 %4, label %5, label %9

5:                                                ; preds = %2
  store i32 16384, ptr %0, align 4, !tbaa !3
  %6 = load i32, ptr inttoptr (i32 537125124 to ptr), align 4, !tbaa !3
  %7 = load i32, ptr inttoptr (i32 537125116 to ptr), align 4, !tbaa !3
  %8 = add i32 %7, %6
  ret i32 %8

9:                                                ; preds = %2
  %10 = add nuw nsw i32 %3, -1515870811
  tail call void @gdma_fill(i32 noundef 537125120, i32 noundef %10, i32 noundef 4096) #8
  tail call void @gdma_copy(i32 noundef 537121024, i32 noundef 537125120, i32 noundef 4096) #8
  %11 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !35
}

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputhex(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numsp(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @delay_us(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #9 = { minsize nobuiltin optsize "no-builtins" }
attributes #10 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = distinct !{!11, !8, !9}
!12 = !{!5, !5, i64 0}
!13 = !{!14, !14, i64 0}
!14 = !{!"p1 omnipotent char", !15, i64 0}
!15 = !{!"any pointer", !5, i64 0}
!16 = !{!15, !15, i64 0}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !8, !9}
!26 = distinct !{!26, !8, !9}
!27 = distinct !{!27, !8, !9}
!28 = distinct !{!28, !8, !9}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
