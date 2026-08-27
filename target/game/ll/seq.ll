; ModuleID = 'seq.c'
source_filename = "seq.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [9 x i8] c"seq: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"SEQUENCER\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"tempo\00", align 1
@.str.3 = private unnamed_addr constant [24 x i8] c"K kick   S snare  T tom\00", align 1
@.str.4 = private unnamed_addr constant [18 x i8] c"H hat    C cymbal\00", align 1
@.str.5 = private unnamed_addr constant [25 x i8] c"l/r: step  press: change\00", align 1
@.str.6 = private unnamed_addr constant [27 x i8] c"hold: exit  up/down: tempo\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@pattern = internal unnamed_addr global [16 x i8] c"\01\00\04\00\02\00\04\04\01\00\04\01\02\00\05\00", align 1
@.str.7 = private unnamed_addr constant [15 x i8] c"seq: step set\0A\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.8 = private unnamed_addr constant [11 x i8] c"seq: exit\0A\00", align 1
@daddr = dso_local local_unnamed_addr global [6 x i32] zeroinitializer, align 4
@dlen = internal unnamed_addr constant [6 x i32] [i32 0, i32 2800, i32 1900, i32 2000, i32 800, i32 2700], align 4
@dcol = internal unnamed_addr constant [6 x i16] [i16 8390, i16 -1339, i16 -377, i16 16111, i16 18012, i16 -17537], align 2
@dletter = internal unnamed_addr constant [6 x i8] c".KSTHC", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"BPM\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @seq_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @gfx_clear(i16 noundef zeroext 4163) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 8, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 56, i32 noundef 40, ptr noundef nonnull @.str.2, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  br label %1

1:                                                ; preds = %14, %0
  %2 = phi i32 [ 0, %0 ], [ %17, %14 ]
  %3 = icmp eq i32 %2, 16
  br i1 %3, label %4, label %14

4:                                                ; preds = %1
  tail call void @gfx_text(i32 noundef 6, i32 noundef 150, ptr noundef nonnull @.str.3, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 162, ptr noundef nonnull @.str.4, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 200, ptr noundef nonnull @.str.5, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 212, ptr noundef nonnull @.str.6, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #4
  tail call void @snd_rate(i32 noundef 22675) #4
  tail call fastcc void @draw_tempo(i32 noundef 120) #5
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  tail call void @gfx_present() #4
  %5 = load volatile i32, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !3
  br label %6

6:                                                ; preds = %154, %4
  %7 = phi i32 [ %104, %154 ], [ -1, %4 ]
  %8 = phi i32 [ %84, %154 ], [ 0, %4 ]
  %9 = phi i32 [ %88, %154 ], [ %5, %4 ]
  %10 = phi i32 [ %102, %154 ], [ 0, %4 ]
  %11 = phi i32 [ %45, %154 ], [ 0, %4 ]
  %12 = phi i32 [ %78, %154 ], [ 22050, %4 ]
  %13 = phi i32 [ %79, %154 ], [ 120, %4 ]
  br label %18

14:                                               ; preds = %1
  %15 = icmp eq i32 %2, 0
  %16 = zext i1 %15 to i32
  tail call fastcc void @draw_step(i32 noundef %2, i32 noundef %16) #5
  %17 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !7

18:                                               ; preds = %6, %98
  %19 = phi i32 [ %84, %98 ], [ %8, %6 ]
  %20 = phi i32 [ %88, %98 ], [ %9, %6 ]
  %21 = phi i32 [ %99, %98 ], [ %10, %6 ]
  %22 = phi i32 [ %45, %98 ], [ %11, %6 ]
  %23 = phi i32 [ %78, %98 ], [ %12, %6 ]
  %24 = phi i32 [ %79, %98 ], [ %13, %6 ]
  tail call void @frame_sync(i32 noundef 4000) #4
  tail call void @in_poll() #4
  %25 = load i32, ptr @in_edge, align 4, !tbaa !3
  %26 = and i32 %25, 4
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %33, label %28

28:                                               ; preds = %18
  tail call fastcc void @draw_step(i32 noundef %22, i32 noundef 0) #5
  %29 = icmp eq i32 %22, 0
  %30 = add nsw i32 %22, -1
  %31 = select i1 %29, i32 15, i32 %30
  tail call fastcc void @draw_step(i32 noundef %31, i32 noundef 1) #5
  tail call void @gfx_present() #4
  %32 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %33

33:                                               ; preds = %28, %18
  %34 = phi i32 [ %32, %28 ], [ %25, %18 ]
  %35 = phi i32 [ %31, %28 ], [ %22, %18 ]
  %36 = and i32 %34, 8
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %43, label %38

38:                                               ; preds = %33
  tail call fastcc void @draw_step(i32 noundef %35, i32 noundef 0) #5
  %39 = icmp eq i32 %35, 15
  %40 = add nsw i32 %35, 1
  %41 = select i1 %39, i32 0, i32 %40
  tail call fastcc void @draw_step(i32 noundef %41, i32 noundef 1) #5
  tail call void @gfx_present() #4
  %42 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %43

43:                                               ; preds = %38, %33
  %44 = phi i32 [ %42, %38 ], [ %34, %33 ]
  %45 = phi i32 [ %41, %38 ], [ %35, %33 ]
  %46 = and i32 %44, 16
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %56, label %48

48:                                               ; preds = %43
  %49 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %45
  %50 = load i8, ptr %49, align 1, !tbaa !10
  %51 = zext i8 %50 to i16
  %52 = add nuw nsw i16 %51, 1
  %53 = urem i16 %52, 6
  %54 = trunc nuw nsw i16 %53 to i8
  store i8 %54, ptr %49, align 1, !tbaa !10
  tail call fastcc void @draw_step(i32 noundef %45, i32 noundef 1) #5
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.7) #4
  %55 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %56

56:                                               ; preds = %48, %43
  %57 = phi i32 [ %55, %48 ], [ %44, %43 ]
  %58 = and i32 %57, 1
  %59 = icmp ne i32 %58, 0
  %60 = icmp slt i32 %24, 200
  %61 = select i1 %59, i1 %60, i1 false
  br i1 %61, label %62, label %66

62:                                               ; preds = %56
  %63 = add nsw i32 %24, 10
  %64 = udiv i32 2646000, %63
  tail call fastcc void @draw_tempo(i32 noundef %63) #5
  tail call void @gfx_present() #4
  %65 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %66

66:                                               ; preds = %62, %56
  %67 = phi i32 [ %65, %62 ], [ %57, %56 ]
  %68 = phi i32 [ %64, %62 ], [ %23, %56 ]
  %69 = phi i32 [ %63, %62 ], [ %24, %56 ]
  %70 = and i32 %67, 2
  %71 = icmp ne i32 %70, 0
  %72 = icmp sgt i32 %69, 60
  %73 = select i1 %71, i1 %72, i1 false
  br i1 %73, label %74, label %77

74:                                               ; preds = %66
  %75 = add nsw i32 %69, -10
  %76 = udiv i32 2646000, %75
  tail call fastcc void @draw_tempo(i32 noundef %75) #5
  tail call void @gfx_present() #4
  br label %77

77:                                               ; preds = %74, %66
  %78 = phi i32 [ %76, %74 ], [ %68, %66 ]
  %79 = phi i32 [ %75, %74 ], [ %69, %66 ]
  %80 = load i32, ptr @in_down, align 4, !tbaa !3
  %81 = and i32 %80, 16
  %82 = icmp eq i32 %81, 0
  %83 = add nuw nsw i32 %19, 1
  %84 = select i1 %82, i32 0, i32 %83
  %85 = icmp samesign ugt i32 %84, 300
  br i1 %85, label %86, label %87

86:                                               ; preds = %77
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  tail call void @snd_rate(i32 noundef 22675) #4
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  ret void

87:                                               ; preds = %77
  %88 = load volatile i32, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !3
  %89 = sub i32 %88, %20
  %90 = and i32 %89, 16383
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %98, label %92

92:                                               ; preds = %87
  %93 = sub i32 537116672, %20
  %94 = tail call i32 @llvm.umin.i32(i32 %93, i32 %90)
  tail call void @gdma_fill(i32 noundef %20, i32 noundef 0, i32 noundef %94) #4
  %95 = icmp ugt i32 %90, %93
  br i1 %95, label %96, label %98

96:                                               ; preds = %92
  %97 = sub nsw i32 %90, %94
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef %97) #4
  br label %98

98:                                               ; preds = %92, %96, %87
  %99 = add i32 %90, %21
  %100 = icmp ult i32 %99, %78
  br i1 %100, label %18, label %101, !llvm.loop !11

101:                                              ; preds = %98
  %102 = sub nuw i32 %99, %78
  %103 = add nsw i32 %7, 1
  %104 = and i32 %103, 15
  %105 = getelementptr inbounds nuw [16 x i8], ptr @pattern, i32 0, i32 %104
  %106 = load i8, ptr %105, align 1, !tbaa !10
  %107 = icmp eq i8 %106, 0
  br i1 %107, label %135, label %108

108:                                              ; preds = %101
  %109 = zext i8 %106 to i32
  %110 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %109
  %111 = load i32, ptr %110, align 4, !tbaa !3
  %112 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %109
  %113 = load i32, ptr %112, align 4, !tbaa !3
  %114 = shl i32 %113, 2
  %115 = load volatile i32, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !3
  %116 = add i32 %115, 256
  %117 = and i32 %116, 16383
  %118 = sub nuw nsw i32 16384, %117
  %119 = tail call i32 @llvm.umin.i32(i32 %118, i32 %114)
  %120 = or disjoint i32 %117, 537100288
  tail call void @gdma_copy(i32 noundef %120, i32 noundef %111, i32 noundef %119) #4
  %121 = icmp ugt i32 %114, %118
  br i1 %121, label %122, label %125

122:                                              ; preds = %108
  %123 = sub i32 %114, %119
  %124 = add i32 %119, %111
  tail call void @gdma_copy(i32 noundef 537100288, i32 noundef %124, i32 noundef %123) #4
  br label %125

125:                                              ; preds = %122, %108
  %126 = add i32 %116, %114
  %127 = and i32 %126, 16383
  %128 = sub i32 16384, %114
  %129 = sub nuw nsw i32 16384, %127
  %130 = tail call i32 @llvm.umin.i32(i32 %129, i32 %128)
  %131 = or disjoint i32 %127, 537100288
  tail call void @gdma_fill(i32 noundef %131, i32 noundef 0, i32 noundef %130) #4
  %132 = icmp ugt i32 %128, %129
  br i1 %132, label %133, label %135

133:                                              ; preds = %125
  %134 = sub i32 %128, %130
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef %134) #4
  br label %135

135:                                              ; preds = %133, %125, %101
  %136 = icmp sgt i32 %7, -1
  br i1 %136, label %137, label %143

137:                                              ; preds = %135
  %138 = and i32 %7, 7
  %139 = mul nuw nsw i32 %138, 29
  %140 = add nuw nsw i32 %139, 6
  %141 = icmp samesign ult i32 %7, 8
  %142 = select i1 %141, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %140, i32 noundef %142, i32 noundef 26, i32 noundef 3, i16 noundef zeroext 4163) #4
  br label %143

143:                                              ; preds = %135, %137
  %144 = and i32 %103, 7
  %145 = mul nuw nsw i32 %144, 29
  %146 = add nuw nsw i32 %145, 6
  %147 = icmp samesign ult i32 %104, 8
  %148 = select i1 %147, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %146, i32 noundef %148, i32 noundef 26, i32 noundef 3, i16 noundef zeroext -377) #4
  switch i8 %106, label %151 [
    i8 1, label %149
    i8 2, label %150
  ]

149:                                              ; preds = %143
  tail call void @led(i32 noundef 4132864, i32 noundef 0) #4
  br label %154

150:                                              ; preds = %143
  tail call void @led(i32 noundef 0, i32 noundef 4144912) #4
  br label %154

151:                                              ; preds = %143
  br i1 %107, label %153, label %152

152:                                              ; preds = %151
  tail call void @led(i32 noundef 3855, i32 noundef 3855) #4
  br label %154

153:                                              ; preds = %151
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  br label %154

154:                                              ; preds = %150, %153, %152, %149
  tail call void @gfx_present() #4
  br label %6, !llvm.loop !11
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

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
  %10 = load i8, ptr %9, align 1, !tbaa !10
  %11 = zext i8 %10 to i32
  %12 = getelementptr inbounds nuw [6 x i16], ptr @dcol, i32 0, i32 %11
  %13 = load i16, ptr %12, align 2, !tbaa !12
  tail call void @gfx_fill(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i16 noundef zeroext %13) #4
  %14 = icmp eq i8 %10, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %3) #6
  %16 = getelementptr inbounds nuw [6 x i8], ptr @dletter, i32 0, i32 %11
  %17 = load i8, ptr %16, align 1, !tbaa !10
  store i8 %17, ptr %3, align 1, !tbaa !10
  %18 = getelementptr inbounds nuw i8, ptr %3, i32 1
  store i8 0, ptr %18, align 1, !tbaa !10
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
define internal fastcc void @draw_tempo(i32 noundef range(i32 -2147483638, 2147483638) %0) unnamed_addr #0 {
  %2 = alloca [4 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #6
  call void @numsp(ptr noundef nonnull %2, i32 noundef 3, i32 noundef %0) #4
  call void @gfx_text(i32 noundef 104, i32 noundef 40, ptr noundef nonnull %2, i16 noundef zeroext -1, i16 noundef zeroext 4163) #4
  call void @gfx_text(i32 noundef 132, i32 noundef 40, ptr noundef nonnull @.str.9, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numsp(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
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
!10 = !{!5, !5, i64 0}
!11 = distinct !{!11, !9}
!12 = !{!13, !13, i64 0}
!13 = !{!"short", !5, i64 0}
