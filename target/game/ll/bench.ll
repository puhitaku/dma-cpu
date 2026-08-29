; ModuleID = 'bench.c'
source_filename = "bench.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [11 x i8] c"bench: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"BENCHMARK\00", align 1
@.str.2 = private unnamed_addr constant [27 x i8] c"fixed work, hardware timer\00", align 1
@xs = internal unnamed_addr global i32 0, align 4
@bench_run.kf = internal unnamed_addr constant [8 x ptr] [ptr @k_bogo, ptr @k_sieve, ptr @k_sort, ptr @k_mul, ptr @k_div, ptr @k_rand, ptr @k_shr1, ptr @k_mem], align 4
@knames = internal unnamed_addr constant [8 x ptr] [ptr @.str.20, ptr @.str.21, ptr @.str.22, ptr @.str.23, ptr @.str.24, ptr @.str.25, ptr @.str.26, ptr @.str.27], align 4
@.str.3 = private unnamed_addr constant [4 x i8] c"...\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"BENCH \00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c" ops=\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c" us=\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c" sum=\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.9 = private unnamed_addr constant [3 x i8] c"ms\00", align 1
@kunit = internal unnamed_addr constant [8 x ptr] [ptr @.str.28, ptr @.str.29, ptr @.str.30, ptr @.str.31, ptr @.str.32, ptr @.str.33, ptr @.str.34, ptr @.str.35], align 4
@.str.10 = private unnamed_addr constant [6 x i8] c"SCORE\00", align 1
@.str.11 = private unnamed_addr constant [27 x i8] c"kernel rates/1k + mem/100k\00", align 1
@.str.12 = private unnamed_addr constant [18 x i8] c"MIPS (bogo loop):\00", align 1
@.str.13 = private unnamed_addr constant [23 x i8] c"BogoMIPS (linux conv):\00", align 1
@.str.14 = private unnamed_addr constant [12 x i8] c"press: back\00", align 1
@.str.15 = private unnamed_addr constant [13 x i8] c"BENCH score=\00", align 1
@.str.16 = private unnamed_addr constant [16 x i8] c"\0ABENCH mips100=\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c" bogo100=\00", align 1
@.str.18 = private unnamed_addr constant [13 x i8] c"\0Abench done\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.19 = private unnamed_addr constant [13 x i8] c"bench: back\0A\00", align 1
@bogo_i = internal global i32 0, align 4
@.str.20 = private unnamed_addr constant [6 x i8] c"bogo \00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"sieve\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"sort \00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"mul  \00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"div  \00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"rand \00", align 1
@.str.26 = private unnamed_addr constant [6 x i8] c"shr1 \00", align 1
@.str.27 = private unnamed_addr constant [6 x i8] c"mem  \00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"loop/s\00", align 1
@.str.29 = private unnamed_addr constant [7 x i8] c"mark/s\00", align 1
@.str.30 = private unnamed_addr constant [7 x i8] c"cmp/s \00", align 1
@.str.31 = private unnamed_addr constant [7 x i8] c"mul/s \00", align 1
@.str.32 = private unnamed_addr constant [7 x i8] c"div/s \00", align 1
@.str.33 = private unnamed_addr constant [7 x i8] c"rnd/s \00", align 1
@.str.34 = private unnamed_addr constant [7 x i8] c"shr/s \00", align 1
@.str.35 = private unnamed_addr constant [7 x i8] c"word/s\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @bench_run() local_unnamed_addr #0 {
  %1 = alloca [8 x i32], align 4
  %2 = alloca [8 x i32], align 4
  %3 = alloca [32 x i8], align 1
  %4 = alloca i32, align 4
  %5 = alloca [16 x i8], align 1
  tail call void @uputs(ptr noundef nonnull @.str) #8
  tail call void @led(i32 noundef 985088, i32 noundef 985088) #8
  tail call void @gfx_clear(i16 noundef zeroext 2147) #8
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 8, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 2147) #8
  tail call void @gfx_text(i32 noundef 8, i32 noundef 32, ptr noundef nonnull @.str.2, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  tail call void @gfx_present() #8
  store i32 -1056969215, ptr @xs, align 4, !tbaa !3
  br label %6

6:                                                ; preds = %9, %0
  %7 = phi i32 [ 0, %0 ], [ %12, %9 ]
  %8 = icmp eq i32 %7, 512
  br i1 %8, label %13, label %9

9:                                                ; preds = %6
  %10 = tail call fastcc i32 @xrand() #9
  %11 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537125120 to ptr), i32 %7
  store i32 %10, ptr %11, align 4, !tbaa !3
  %12 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !7

13:                                               ; preds = %6, %16
  %14 = phi i32 [ %24, %16 ], [ 0, %6 ]
  %15 = icmp eq i32 %14, 144
  br i1 %15, label %25, label %16

16:                                               ; preds = %13
  %17 = tail call fastcc i32 @xrand() #9
  %18 = and i32 %17, 255
  %19 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537129216 to ptr), i32 %14
  store i32 %18, ptr %19, align 4, !tbaa !3
  %20 = tail call fastcc i32 @xrand() #9
  %21 = and i32 %20, 255
  %22 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537129792 to ptr), i32 %14
  store i32 %21, ptr %22, align 4, !tbaa !3
  %23 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537130368 to ptr), i32 %14
  store i32 0, ptr %23, align 4, !tbaa !3
  %24 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !10

25:                                               ; preds = %13, %34
  %26 = phi i32 [ %38, %34 ], [ 0, %13 ]
  %27 = icmp eq i32 %26, 192
  br i1 %27, label %28, label %34

28:                                               ; preds = %25
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #10
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #10
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %3) #10
  %29 = getelementptr inbounds nuw i8, ptr %3, i32 5
  %30 = getelementptr inbounds nuw i8, ptr %3, i32 3
  %31 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %32 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %33 = getelementptr inbounds nuw i8, ptr %3, i32 2
  br label %39

34:                                               ; preds = %25
  %35 = tail call fastcc i32 @xrand() #9
  %36 = or i32 %35, 1
  %37 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537127680 to ptr), i32 %26
  store i32 %36, ptr %37, align 4, !tbaa !3
  %38 = add nuw nsw i32 %26, 1
  br label %25, !llvm.loop !11

39:                                               ; preds = %143, %28
  %40 = phi i32 [ 0, %28 ], [ %146, %143 ]
  %41 = icmp eq i32 %40, 8
  br i1 %41, label %42, label %94

42:                                               ; preds = %39
  %43 = load i32, ptr %2, align 4, !tbaa !3
  %44 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %45 = load i32, ptr %44, align 4, !tbaa !3
  %46 = add i32 %45, %43
  %47 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %48 = load i32, ptr %47, align 4, !tbaa !3
  %49 = add i32 %46, %48
  %50 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %51 = load i32, ptr %50, align 4, !tbaa !3
  %52 = add i32 %49, %51
  %53 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %54 = load i32, ptr %53, align 4, !tbaa !3
  %55 = add i32 %52, %54
  %56 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %57 = load i32, ptr %56, align 4, !tbaa !3
  %58 = add i32 %55, %57
  %59 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %60 = load i32, ptr %59, align 4, !tbaa !3
  %61 = add i32 %58, %60
  %62 = udiv i32 %61, 1000
  %63 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %64 = load i32, ptr %63, align 4, !tbaa !3
  %65 = udiv i32 %64, 100000
  %66 = add nuw nsw i32 %62, %65
  %67 = load i32, ptr %1, align 4, !tbaa !3
  %68 = udiv i32 111350000, %67
  %69 = udiv i32 13107200, %67
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #10
  call void @numsp(ptr noundef nonnull %5, i32 noundef 5, i32 noundef %66) #8
  call void @gfx_text2(i32 noundef 8, i32 noundef 160, ptr noundef nonnull @.str.10, i16 noundef zeroext -377, i16 noundef zeroext 2147) #8
  call void @gfx_text2(i32 noundef 112, i32 noundef 160, ptr noundef nonnull %5, i16 noundef zeroext 24465, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 8, i32 noundef 184, ptr noundef nonnull @.str.11, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  %70 = udiv i32 %68, 100
  call void @numsp(ptr noundef nonnull %5, i32 noundef 3, i32 noundef %70) #8
  %71 = getelementptr inbounds nuw i8, ptr %5, i32 3
  store i8 46, ptr %71, align 1, !tbaa !12
  %72 = freeze i32 %68
  %73 = udiv i32 %72, 10
  %74 = urem i32 %73, 10
  %75 = trunc nuw nsw i32 %74 to i8
  %76 = or disjoint i8 %75, 48
  %77 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store i8 %76, ptr %77, align 1, !tbaa !12
  %78 = mul i32 %73, 10
  %79 = sub i32 %72, %78
  %80 = trunc nuw nsw i32 %79 to i8
  %81 = or disjoint i8 %80, 48
  %82 = getelementptr inbounds nuw i8, ptr %5, i32 5
  store i8 %81, ptr %82, align 1, !tbaa !12
  %83 = getelementptr inbounds nuw i8, ptr %5, i32 6
  store i8 0, ptr %83, align 1, !tbaa !12
  call void @gfx_text(i32 noundef 8, i32 noundef 198, ptr noundef nonnull @.str.12, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 184, i32 noundef 198, ptr noundef nonnull %5, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  %84 = udiv i32 %69, 100
  call void @numsp(ptr noundef nonnull %5, i32 noundef 3, i32 noundef %84) #8
  store i8 46, ptr %71, align 1, !tbaa !12
  %85 = freeze i32 %69
  %86 = udiv i32 %85, 10
  %87 = urem i32 %86, 10
  %88 = trunc nuw nsw i32 %87 to i8
  %89 = or disjoint i8 %88, 48
  store i8 %89, ptr %77, align 1, !tbaa !12
  %90 = mul i32 %86, 10
  %91 = sub i32 %85, %90
  %92 = trunc nuw nsw i32 %91 to i8
  %93 = or disjoint i8 %92, 48
  store i8 %93, ptr %82, align 1, !tbaa !12
  store i8 0, ptr %83, align 1, !tbaa !12
  call void @gfx_text(i32 noundef 8, i32 noundef 212, ptr noundef nonnull @.str.13, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 184, i32 noundef 212, ptr noundef nonnull %5, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 8, i32 noundef 226, ptr noundef nonnull @.str.14, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_present() #8
  call void @uputs(ptr noundef nonnull @.str.15) #8
  call void @uputn(i32 noundef %66) #8
  call void @uputs(ptr noundef nonnull @.str.16) #8
  call void @uputn(i32 noundef %68) #8
  call void @uputs(ptr noundef nonnull @.str.17) #8
  call void @uputn(i32 noundef %69) #8
  call void @uputs(ptr noundef nonnull @.str.18) #8
  call void @led(i32 noundef 3844, i32 noundef 3844) #8
  call void @snd_play(i32 noundef 659, i32 noundef 55, i32 noundef 255) #8
  call void @delay_us(i32 noundef 60000) #8
  call void @snd_play(i32 noundef 784, i32 noundef 55, i32 noundef 255) #8
  call void @delay_us(i32 noundef 90000) #8
  call void @snd_off() #8
  br label %147

94:                                               ; preds = %39
  %95 = mul nuw nsw i32 %40, 13
  %96 = add nuw nsw i32 %95, 48
  %97 = getelementptr inbounds nuw [8 x ptr], ptr @knames, i32 0, i32 %40
  %98 = load ptr, ptr %97, align 4, !tbaa !13
  call void @gfx_text(i32 noundef 8, i32 noundef %96, ptr noundef %98, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 56, i32 noundef %96, ptr noundef nonnull @.str.3, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_present() #8
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #10
  store i32 0, ptr %4, align 4, !tbaa !3
  %99 = call i32 @now_us() #8
  %100 = getelementptr inbounds nuw [8 x ptr], ptr @bench_run.kf, i32 0, i32 %40
  %101 = load ptr, ptr %100, align 4, !tbaa !16
  %102 = call i32 %101(ptr noundef nonnull %4) #8
  %103 = call i32 @now_us() #8
  %104 = sub i32 %103, %99
  %105 = icmp eq i32 %103, %99
  %106 = select i1 %105, i32 1, i32 %104
  %107 = getelementptr inbounds nuw [8 x i32], ptr %1, i32 0, i32 %40
  store i32 %106, ptr %107, align 4, !tbaa !3
  call void @uputs(ptr noundef nonnull @.str.4) #8
  call void @uputs(ptr noundef %98) #8
  call void @uputs(ptr noundef nonnull @.str.5) #8
  %108 = load i32, ptr %4, align 4, !tbaa !3
  call void @uputn(i32 noundef %108) #8
  call void @uputs(ptr noundef nonnull @.str.6) #8
  call void @uputn(i32 noundef %106) #8
  call void @uputs(ptr noundef nonnull @.str.7) #8
  call void @uputhex(i32 noundef %102) #8
  call void @uputs(ptr noundef nonnull @.str.8) #8
  %109 = udiv i32 %106, 1000
  %110 = icmp ult i32 %106, 1000
  %111 = select i1 %110, i32 1, i32 %109
  %112 = load i32, ptr %4, align 4, !tbaa !3
  %113 = freeze i32 %112
  %114 = freeze i32 %111
  %115 = udiv i32 %113, %114
  %116 = mul i32 %115, 1000
  %117 = mul i32 %115, %114
  %118 = sub i32 %113, %117
  %119 = mul nuw i32 %118, 1000
  %120 = udiv i32 %119, %111
  %121 = add i32 %120, %116
  %122 = getelementptr inbounds nuw [8 x i32], ptr %2, i32 0, i32 %40
  store i32 %121, ptr %122, align 4, !tbaa !3
  call void @gfx_fill(i32 noundef 56, i32 noundef %96, i32 noundef 176, i32 noundef 12, i16 noundef zeroext 2147) #8
  call void @numsp(ptr noundef nonnull %3, i32 noundef 5, i32 noundef %111) #8
  store i8 0, ptr %29, align 1, !tbaa !12
  call void @gfx_text(i32 noundef 56, i32 noundef %96, ptr noundef nonnull %3, i16 noundef zeroext -18950, i16 noundef zeroext 2147) #8
  call void @gfx_text(i32 noundef 96, i32 noundef %96, ptr noundef nonnull @.str.9, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  %123 = icmp ugt i32 %121, 999999
  br i1 %123, label %124, label %136

124:                                              ; preds = %94
  %125 = udiv i32 %121, 100000
  %126 = udiv i32 %121, 1000000
  %127 = trunc nuw nsw i32 %126 to i16
  %128 = urem i16 %127, 10
  %129 = trunc nuw nsw i16 %128 to i8
  %130 = or disjoint i8 %129, 48
  store i8 %130, ptr %3, align 1, !tbaa !12
  store i8 46, ptr %32, align 1, !tbaa !12
  %131 = trunc nuw i32 %125 to i16
  %132 = urem i16 %131, 10
  %133 = trunc nuw nsw i16 %132 to i8
  %134 = or disjoint i8 %133, 48
  store i8 %134, ptr %33, align 1, !tbaa !12
  store i8 77, ptr %30, align 1, !tbaa !12
  store i8 0, ptr %31, align 1, !tbaa !12
  %135 = icmp ugt i32 %121, 9999999
  br i1 %135, label %140, label %143

136:                                              ; preds = %94
  %137 = icmp samesign ugt i32 %121, 999
  br i1 %137, label %138, label %140

138:                                              ; preds = %136
  %139 = udiv i32 %121, 1000
  br label %140

140:                                              ; preds = %136, %124, %138
  %141 = phi i32 [ %139, %138 ], [ %126, %124 ], [ %121, %136 ]
  %142 = phi i8 [ 107, %138 ], [ 77, %124 ], [ 32, %136 ]
  call void @numsp(ptr noundef nonnull %3, i32 noundef 3, i32 noundef %141) #8
  store i8 %142, ptr %30, align 1, !tbaa !12
  store i8 0, ptr %31, align 1, !tbaa !12
  br label %143

143:                                              ; preds = %140, %124
  call void @gfx_text(i32 noundef 128, i32 noundef %96, ptr noundef nonnull %3, i16 noundef zeroext 24465, i16 noundef zeroext 2147) #8
  %144 = getelementptr inbounds nuw [8 x ptr], ptr @kunit, i32 0, i32 %40
  %145 = load ptr, ptr %144, align 4, !tbaa !13
  call void @gfx_text(i32 noundef 172, i32 noundef %96, ptr noundef %145, i16 noundef zeroext 27537, i16 noundef zeroext 2147) #8
  call void @gfx_present() #8
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #10
  %146 = add nuw nsw i32 %40, 1
  br label %39, !llvm.loop !17

147:                                              ; preds = %147, %42
  call void @frame_sync(i32 noundef 33000) #8
  call void @in_poll() #8
  %148 = load i32, ptr @in_edge, align 4, !tbaa !3
  %149 = and i32 %148, 31
  %150 = icmp eq i32 %149, 0
  br i1 %150, label %147, label %151, !llvm.loop !18

151:                                              ; preds = %147
  call void @led(i32 noundef 0, i32 noundef 0) #8
  call void @uputs(ptr noundef nonnull @.str.19) #8
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #10
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %3) #10
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
