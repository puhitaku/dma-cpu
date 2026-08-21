; ModuleID = 'seq.c'
source_filename = "seq.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [9 x i8] c"seq: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"SEQUENCER\00", align 1
@rendered = internal unnamed_addr global i1 false, align 4
@.str.2 = private unnamed_addr constant [22 x i8] c"synthesizing drums...\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"tempo\00", align 1
@.str.4 = private unnamed_addr constant [24 x i8] c"K kick   S snare  T tom\00", align 1
@.str.5 = private unnamed_addr constant [18 x i8] c"H hat    C cymbal\00", align 1
@.str.6 = private unnamed_addr constant [25 x i8] c"l/r: step  press: change\00", align 1
@.str.7 = private unnamed_addr constant [27 x i8] c"hold: exit  up/down: tempo\00", align 1
@seq_run.tdiv = internal unnamed_addr constant [8 x i32] [i32 26300, i32 24800, i32 23000, i32 21200, i32 18140, i32 17000, i32 16400, i32 15900], align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@pattern = internal unnamed_addr global [16 x i8] c"\01\00\04\00\02\00\04\04\01\00\04\01\02\00\05\00", align 1
@.str.8 = private unnamed_addr constant [15 x i8] c"seq: step set\0A\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.9 = private unnamed_addr constant [11 x i8] c"seq: exit\0A\00", align 1
@dlen = internal unnamed_addr constant [6 x i32] [i32 0, i32 3000, i32 2000, i32 2200, i32 800, i32 3000], align 4
@daddr = internal unnamed_addr global [6 x i32] zeroinitializer, align 4
@dcol = internal unnamed_addr constant [6 x i16] [i16 8390, i16 -1339, i16 -377, i16 16111, i16 18012, i16 -17537], align 2
@dletter = internal unnamed_addr constant [6 x i8] c".KSTHC", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @seq_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @gfx_clear(i16 noundef zeroext 4163) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 8, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 4163) #4
  %1 = load i1, ptr @rendered, align 4
  br i1 %1, label %50, label %2

2:                                                ; preds = %0
  tail call void @gfx_text(i32 noundef 52, i32 noundef 110, ptr noundef nonnull @.str.2, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_present() #4
  br label %3

3:                                                ; preds = %34, %2
  %4 = phi i32 [ 537051136, %2 ], [ %39, %34 ]
  %5 = phi i32 [ 1, %2 ], [ %40, %34 ]
  %6 = icmp eq i32 %5, 6
  br i1 %6, label %7, label %34

7:                                                ; preds = %3
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 4), align 4, !tbaa !3
  %9 = inttoptr i32 %8 to ptr
  br label %10

10:                                               ; preds = %25, %7
  %11 = phi i32 [ 0, %7 ], [ %26, %25 ]
  %12 = phi i32 [ 1, %7 ], [ %27, %25 ]
  %13 = phi i32 [ 14000, %7 ], [ %29, %25 ]
  %14 = phi i32 [ 0, %7 ], [ %33, %25 ]
  %15 = icmp eq i32 %14, 3000
  br i1 %15, label %41, label %16

16:                                               ; preds = %10
  %17 = icmp sgt i32 %12, 0
  %18 = select i1 %17, i32 150, i32 -150
  %19 = add nsw i32 %18, %11
  %20 = icmp slt i32 %19, %13
  br i1 %20, label %21, label %25

21:                                               ; preds = %16
  %22 = sub nsw i32 0, %13
  %23 = icmp sgt i32 %19, %22
  br i1 %23, label %25, label %24

24:                                               ; preds = %21
  br label %25

25:                                               ; preds = %24, %21, %16
  %26 = phi i32 [ %22, %24 ], [ %19, %21 ], [ %13, %16 ]
  %27 = phi i32 [ 1, %24 ], [ %12, %21 ], [ -1, %16 ]
  %28 = ashr i32 %13, 10
  %29 = sub nsw i32 %13, %28
  %30 = and i32 %26, 65535
  %31 = mul nuw i32 %30, 65537
  %32 = getelementptr inbounds nuw i32, ptr %9, i32 %14
  store volatile i32 %31, ptr %32, align 4, !tbaa !3
  %33 = add nuw nsw i32 %14, 1
  br label %10, !llvm.loop !7

34:                                               ; preds = %3
  %35 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %5
  store i32 %4, ptr %35, align 4, !tbaa !3
  %36 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %5
  %37 = load i32, ptr %36, align 4, !tbaa !3
  %38 = shl i32 %37, 2
  %39 = add i32 %38, %4
  %40 = add nuw nsw i32 %5, 1
  br label %3, !llvm.loop !10

41:                                               ; preds = %10
  %42 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 8), align 4, !tbaa !3
  %43 = inttoptr i32 %42 to ptr
  tail call fastcc void @render_square(ptr noundef %43, i32 noundef 2000, i32 noundef 67, i32 noundef 0, i32 noundef 10000, i32 noundef 9) #5
  %44 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 12), align 4, !tbaa !3
  %45 = inttoptr i32 %44 to ptr
  tail call fastcc void @render_square(ptr noundef %45, i32 noundef 2200, i32 noundef 138, i32 noundef 1, i32 noundef 12000, i32 noundef 11) #5
  %46 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 16), align 4, !tbaa !3
  %47 = inttoptr i32 %46 to ptr
  tail call fastcc void @render_noise(ptr noundef %47, i32 noundef 800, i32 noundef 7) #5
  %48 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 20), align 4, !tbaa !3
  %49 = inttoptr i32 %48 to ptr
  tail call fastcc void @render_noise(ptr noundef %49, i32 noundef 3000, i32 noundef 10) #5
  store i1 true, ptr @rendered, align 4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 104, i32 noundef 240, i32 noundef 26, i16 noundef zeroext 4163) #4
  br label %50

50:                                               ; preds = %41, %0
  tail call void @gfx_text(i32 noundef 72, i32 noundef 40, ptr noundef nonnull @.str.3, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  br label %51

51:                                               ; preds = %55, %50
  %52 = phi i32 [ 0, %50 ], [ %58, %55 ]
  %53 = icmp eq i32 %52, 16
  br i1 %53, label %54, label %55

54:                                               ; preds = %51
  tail call void @gfx_text(i32 noundef 6, i32 noundef 150, ptr noundef nonnull @.str.4, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 162, ptr noundef nonnull @.str.5, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 200, ptr noundef nonnull @.str.6, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 212, ptr noundef nonnull @.str.7, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #4
  tail call void @snd_rate(i32 noundef 18140) #4
  tail call fastcc void @draw_tempo(i32 noundef 4) #5
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  br label %59

55:                                               ; preds = %51
  %56 = icmp eq i32 %52, 0
  %57 = zext i1 %56 to i32
  tail call fastcc void @draw_step(i32 noundef %52, i32 noundef %57) #5
  %58 = add nuw nsw i32 %52, 1
  br label %51, !llvm.loop !11

59:                                               ; preds = %167, %54
  %60 = phi i32 [ -1, %54 ], [ %137, %167 ]
  %61 = phi i32 [ 0, %54 ], [ %129, %167 ]
  %62 = phi i32 [ 0, %54 ], [ %133, %167 ]
  %63 = phi i32 [ 0, %54 ], [ %90, %167 ]
  %64 = phi i32 [ 4, %54 ], [ %124, %167 ]
  tail call void @gfx_present() #4
  br label %65

65:                                               ; preds = %59, %132
  %66 = phi i32 [ %129, %132 ], [ %61, %59 ]
  %67 = phi i32 [ %133, %132 ], [ %62, %59 ]
  %68 = phi i32 [ %90, %132 ], [ %63, %59 ]
  %69 = phi i32 [ %124, %132 ], [ %64, %59 ]
  tail call void @frame_sync(i32 noundef 4000) #4
  tail call void @in_poll() #4
  %70 = load i32, ptr @in_edge, align 4, !tbaa !3
  %71 = and i32 %70, 4
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %78, label %73

73:                                               ; preds = %65
  tail call fastcc void @draw_step(i32 noundef %68, i32 noundef 0) #5
  %74 = icmp eq i32 %68, 0
  %75 = add nsw i32 %68, -1
  %76 = select i1 %74, i32 15, i32 %75
  tail call fastcc void @draw_step(i32 noundef %76, i32 noundef 1) #5
  tail call void @gfx_present() #4
  %77 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %78

78:                                               ; preds = %73, %65
  %79 = phi i32 [ %77, %73 ], [ %70, %65 ]
  %80 = phi i32 [ %76, %73 ], [ %68, %65 ]
  %81 = and i32 %79, 8
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %88, label %83

83:                                               ; preds = %78
  tail call fastcc void @draw_step(i32 noundef %80, i32 noundef 0) #5
  %84 = icmp eq i32 %80, 15
  %85 = add nsw i32 %80, 1
  %86 = select i1 %84, i32 0, i32 %85
  tail call fastcc void @draw_step(i32 noundef %86, i32 noundef 1) #5
  tail call void @gfx_present() #4
  %87 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %88

88:                                               ; preds = %83, %78
  %89 = phi i32 [ %87, %83 ], [ %79, %78 ]
  %90 = phi i32 [ %86, %83 ], [ %80, %78 ]
  %91 = and i32 %89, 16
  %92 = icmp eq i32 %91, 0
  br i1 %92, label %101, label %93

93:                                               ; preds = %88
  %94 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %90
  %95 = load i8, ptr %94, align 1, !tbaa !12
  %96 = zext i8 %95 to i16
  %97 = add nuw nsw i16 %96, 1
  %98 = urem i16 %97, 6
  %99 = trunc nuw nsw i16 %98 to i8
  store i8 %99, ptr %94, align 1, !tbaa !12
  tail call fastcc void @draw_step(i32 noundef %90, i32 noundef 1) #5
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  %100 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %101

101:                                              ; preds = %93, %88
  %102 = phi i32 [ %100, %93 ], [ %89, %88 ]
  %103 = and i32 %102, 1
  %104 = icmp ne i32 %103, 0
  %105 = icmp slt i32 %69, 7
  %106 = select i1 %104, i1 %105, i1 false
  br i1 %106, label %107, label %112

107:                                              ; preds = %101
  %108 = add nsw i32 %69, 1
  %109 = getelementptr inbounds [8 x i32], ptr @seq_run.tdiv, i32 0, i32 %108
  %110 = load i32, ptr %109, align 4, !tbaa !3
  tail call void @snd_rate(i32 noundef %110) #4
  tail call fastcc void @draw_tempo(i32 noundef %108) #5
  tail call void @gfx_present() #4
  %111 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %112

112:                                              ; preds = %107, %101
  %113 = phi i32 [ %111, %107 ], [ %102, %101 ]
  %114 = phi i32 [ %108, %107 ], [ %69, %101 ]
  %115 = and i32 %113, 2
  %116 = icmp ne i32 %115, 0
  %117 = icmp sgt i32 %114, 0
  %118 = select i1 %116, i1 %117, i1 false
  br i1 %118, label %119, label %123

119:                                              ; preds = %112
  %120 = add nsw i32 %114, -1
  %121 = getelementptr inbounds nuw [8 x i32], ptr @seq_run.tdiv, i32 0, i32 %120
  %122 = load i32, ptr %121, align 4, !tbaa !3
  tail call void @snd_rate(i32 noundef %122) #4
  tail call fastcc void @draw_tempo(i32 noundef %120) #5
  tail call void @gfx_present() #4
  br label %123

123:                                              ; preds = %119, %112
  %124 = phi i32 [ %120, %119 ], [ %114, %112 ]
  %125 = load i32, ptr @in_down, align 4, !tbaa !3
  %126 = and i32 %125, 16
  %127 = icmp eq i32 %126, 0
  %128 = add nuw nsw i32 %66, 1
  %129 = select i1 %127, i32 0, i32 %128
  %130 = icmp samesign ugt i32 %129, 300
  br i1 %130, label %131, label %132

131:                                              ; preds = %123
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  tail call void @snd_rate(i32 noundef 18140) #4
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  tail call void @uputs(ptr noundef nonnull @.str.9) #4
  ret void

132:                                              ; preds = %123
  %133 = load volatile i32, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !3
  %134 = icmp ult i32 %133, %67
  br i1 %134, label %135, label %65, !llvm.loop !13

135:                                              ; preds = %132
  %136 = add nsw i32 %60, 1
  %137 = and i32 %136, 15
  %138 = getelementptr inbounds nuw [16 x i8], ptr @pattern, i32 0, i32 %137
  %139 = load i8, ptr %138, align 1, !tbaa !12
  %140 = icmp eq i8 %139, 0
  br i1 %140, label %150, label %141

141:                                              ; preds = %135
  %142 = zext i8 %139 to i32
  %143 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %142
  %144 = load i32, ptr %143, align 4, !tbaa !3
  %145 = shl i32 %144, 2
  %146 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %142
  %147 = load i32, ptr %146, align 4, !tbaa !3
  tail call void @gdma_copy(i32 noundef 537100288, i32 noundef %147, i32 noundef %145) #4
  %148 = add i32 %145, 537100288
  %149 = sub i32 16384, %145
  tail call void @gdma_fill(i32 noundef %148, i32 noundef 0, i32 noundef %149) #4
  br label %151

150:                                              ; preds = %135
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  br label %151

151:                                              ; preds = %150, %141
  %152 = icmp sgt i32 %60, -1
  br i1 %152, label %153, label %159

153:                                              ; preds = %151
  %154 = and i32 %60, 7
  %155 = mul nuw nsw i32 %154, 29
  %156 = add nuw nsw i32 %155, 6
  %157 = icmp samesign ult i32 %60, 8
  %158 = select i1 %157, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %156, i32 noundef %158, i32 noundef 26, i32 noundef 3, i16 noundef zeroext 4163) #4
  br label %159

159:                                              ; preds = %151, %153
  %160 = and i32 %136, 7
  %161 = mul nuw nsw i32 %160, 29
  %162 = add nuw nsw i32 %161, 6
  %163 = icmp samesign ult i32 %137, 8
  %164 = select i1 %163, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %162, i32 noundef %164, i32 noundef 26, i32 noundef 3, i16 noundef zeroext -377) #4
  switch i8 %139, label %168 [
    i8 1, label %165
    i8 2, label %166
  ]

165:                                              ; preds = %159
  tail call void @led(i32 noundef 5246976, i32 noundef 0) #4
  br label %167

166:                                              ; preds = %159
  tail call void @led(i32 noundef 0, i32 noundef 4210704) #4
  br label %167

167:                                              ; preds = %166, %170, %169, %165
  br label %59, !llvm.loop !13

168:                                              ; preds = %159
  br i1 %140, label %170, label %169

169:                                              ; preds = %168
  tail call void @led(i32 noundef 2072, i32 noundef 2072) #4
  br label %167

170:                                              ; preds = %168
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  br label %167
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_step(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = alloca [2 x i8], align 1
  %4 = and i32 %0, 7
  %5 = mul nuw nsw i32 %4, 29
  %6 = add nuw nsw i32 %5, 6
  %7 = icmp slt i32 %0, 8
  %8 = select i1 %7, i32 64, i32 104
  %9 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %0
  %10 = load i8, ptr %9, align 1, !tbaa !12
  %11 = zext i8 %10 to i32
  %12 = getelementptr inbounds nuw [6 x i16], ptr @dcol, i32 0, i32 %11
  %13 = load i16, ptr %12, align 2, !tbaa !14
  tail call void @gfx_fill(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i16 noundef zeroext %13) #4
  %14 = icmp eq i8 %10, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %3) #6
  %16 = getelementptr inbounds nuw [6 x i8], ptr @dletter, i32 0, i32 %11
  %17 = load i8, ptr %16, align 1, !tbaa !12
  store i8 %17, ptr %3, align 1, !tbaa !12
  %18 = getelementptr inbounds nuw i8, ptr %3, i32 1
  store i8 0, ptr %18, align 1, !tbaa !12
  %19 = add nuw nsw i32 %5, 15
  %20 = add nuw nsw i32 %8, 9
  call void @gfx_text(i32 noundef %19, i32 noundef %20, ptr noundef nonnull %3, i16 noundef zeroext 2114, i16 noundef zeroext %13) #4
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %3) #6
  br label %21

21:                                               ; preds = %15, %2
  %22 = icmp eq i32 %1, 0
  %23 = select i1 %22, i32 1, i32 2
  %24 = select i1 %22, i16 14730, i16 -1
  call void @gfx_rect(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i32 noundef %23, i16 noundef zeroext %24) #4
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @snd_rate(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_tempo(i32 noundef range(i32 -2147483647, 2147483647) %0) unnamed_addr #0 {
  %2 = alloca [2 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %2) #6
  %3 = trunc i32 %0 to i8
  %4 = add i8 %3, 49
  store i8 %4, ptr %2, align 1, !tbaa !12
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 0, ptr %5, align 1, !tbaa !12
  call void @gfx_text(i32 noundef 140, i32 noundef 40, ptr noundef nonnull %2, i16 noundef zeroext -1, i16 noundef zeroext 4163) #4
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite)
define internal fastcc void @render_square(ptr noundef %0, i32 noundef range(i32 2000, 2201) %1, i32 noundef range(i32 67, 139) %2, i32 noundef range(i32 0, 2) %3, i32 noundef range(i32 10000, 12001) %4, i32 noundef range(i32 9, 12) %5) unnamed_addr #3 {
  %7 = icmp ne i32 %3, 0
  br label %8

8:                                                ; preds = %16, %6
  %9 = phi i32 [ %4, %6 ], [ %28, %16 ]
  %10 = phi i32 [ %2, %6 ], [ %26, %16 ]
  %11 = phi i32 [ 0, %6 ], [ %20, %16 ]
  %12 = phi i32 [ 1, %6 ], [ %21, %16 ]
  %13 = phi i32 [ 0, %6 ], [ %35, %16 ]
  %14 = icmp eq i32 %13, %1
  br i1 %14, label %15, label %16

15:                                               ; preds = %8
  ret void

16:                                               ; preds = %8
  %17 = add nsw i32 %11, 1
  %18 = icmp slt i32 %17, %10
  %19 = sub nsw i32 0, %12
  %20 = select i1 %18, i32 %17, i32 0
  %21 = select i1 %18, i32 %12, i32 %19
  %22 = and i32 %13, 31
  %23 = icmp eq i32 %22, 0
  %24 = and i1 %7, %23
  %25 = zext i1 %24 to i32
  %26 = add nuw nsw i32 %10, %25
  %27 = ashr i32 %9, %5
  %28 = sub nsw i32 %9, %27
  %29 = icmp sgt i32 %21, 0
  %30 = sub nsw i32 0, %28
  %31 = select i1 %29, i32 %28, i32 %30
  %32 = and i32 %31, 65535
  %33 = mul nuw i32 %32, 65537
  %34 = getelementptr inbounds nuw i32, ptr %0, i32 %13
  store volatile i32 %33, ptr %34, align 4, !tbaa !3
  %35 = add nuw nsw i32 %13, 1
  br label %8, !llvm.loop !16
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite)
define internal fastcc void @render_noise(ptr noundef %0, i32 noundef range(i32 800, 3001) %1, i32 noundef range(i32 7, 11) %2) unnamed_addr #3 {
  br label %4

4:                                                ; preds = %10, %3
  %5 = phi i32 [ 9000, %3 ], [ %18, %10 ]
  %6 = phi i32 [ 495397697, %3 ], [ %16, %10 ]
  %7 = phi i32 [ 0, %3 ], [ %26, %10 ]
  %8 = icmp eq i32 %7, %1
  br i1 %8, label %9, label %10

9:                                                ; preds = %4
  ret void

10:                                               ; preds = %4
  %11 = shl i32 %6, 13
  %12 = xor i32 %11, %6
  %13 = lshr i32 %12, 17
  %14 = xor i32 %13, %12
  %15 = shl i32 %14, 5
  %16 = xor i32 %15, %14
  %17 = ashr i32 %5, %2
  %18 = sub nsw i32 %5, %17
  %19 = and i32 %14, 1
  %20 = icmp eq i32 %19, 0
  %21 = sub nsw i32 0, %18
  %22 = select i1 %20, i32 %21, i32 %18
  %23 = and i32 %22, 65535
  %24 = mul nuw i32 %23, 65537
  %25 = getelementptr inbounds nuw i32, ptr %0, i32 %7
  store volatile i32 %24, ptr %25, align 4, !tbaa !3
  %26 = add nuw nsw i32 %7, 1
  br label %4, !llvm.loop !17
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { nounwind }

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
!13 = distinct !{!13, !9}
!14 = !{!15, !15, i64 0}
!15 = !{!"short", !5, i64 0}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
