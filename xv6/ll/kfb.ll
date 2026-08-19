; ModuleID = 'dma/kfb.c'
source_filename = "dma/kfb.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fb_on = internal unnamed_addr global i1 false, align 4
@fb_psram = dso_local local_unnamed_addr global i32 0, align 4
@fb_owner = internal unnamed_addr global i32 0, align 4
@fb_sram = dso_local local_unnamed_addr global i32 0, align 4
@fb_abort = dso_local local_unnamed_addr global i32 0, align 4
@fb_dmabase = dso_local local_unnamed_addr global i32 0, align 4
@fb_psram_sz = dso_local local_unnamed_addr global i32 0, align 4
@fb_hstx = dso_local local_unnamed_addr global i32 0, align 4
@fb_ctrl_walk = dso_local local_unnamed_addr global i32 0, align 4
@fb_ctrl_kick = dso_local local_unnamed_addr global i32 0, align 4
@fb_ctrl_strm = dso_local local_unnamed_addr global i32 0, align 4
@fb_ctrl_vbl = dso_local local_unnamed_addr global i32 0, align 4
@fb_ctrl_tail = dso_local local_unnamed_addr global i32 0, align 4
@fb_ctrl_copy = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @kfb_active() local_unnamed_addr #0 {
  %1 = load i1, ptr @fb_on, align 4
  %2 = zext i1 %1 to i32
  ret i32 %2
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kfb_base() local_unnamed_addr #0 {
  %1 = load i32, ptr @fb_psram, align 4, !tbaa !3
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local noundef i32 @kfb_w() local_unnamed_addr #1 {
  ret i32 640
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local noundef i32 @kfb_h() local_unnamed_addr #1 {
  ret i32 480
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kfb_owner() local_unnamed_addr #0 {
  %1 = load i32, ptr @fb_owner, align 4, !tbaa !3
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
define dso_local void @kfb_setowner(i32 noundef %0) local_unnamed_addr #2 {
  store i32 %0, ptr @fb_owner, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kfb_setpan(i32 noundef %0) local_unnamed_addr #3 {
  %2 = alloca [2 x i32], align 4
  %3 = load i1, ptr @fb_on, align 4
  br i1 %3, label %4, label %55

4:                                                ; preds = %1
  %5 = load i32, ptr @fb_psram, align 4, !tbaa !3
  %6 = mul i32 %0, 640
  %7 = add i32 %5, %6
  %8 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %9 = add i32 %8, 15432
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #7
  %10 = sub i32 480, %0
  store i32 %10, ptr %2, align 4, !tbaa !3
  %11 = getelementptr inbounds nuw i8, ptr %2, i32 4
  store i32 %0, ptr %11, align 4, !tbaa !3
  br label %12

12:                                               ; preds = %52, %4
  %13 = phi i32 [ %7, %4 ], [ %53, %52 ]
  %14 = phi i32 [ %9, %4 ], [ %23, %52 ]
  %15 = phi i32 [ 0, %4 ], [ %54, %52 ]
  %16 = icmp eq i32 %15, 2
  br i1 %16, label %17, label %18

17:                                               ; preds = %12
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  br label %55

18:                                               ; preds = %12
  %19 = getelementptr inbounds nuw [2 x i32], ptr %2, i32 0, i32 %15
  %20 = load i32, ptr %19, align 4, !tbaa !3
  br label %21

21:                                               ; preds = %26, %18
  %22 = phi i32 [ %13, %18 ], [ %50, %26 ]
  %23 = phi i32 [ %14, %18 ], [ %49, %26 ]
  %24 = phi i32 [ %20, %18 ], [ %51, %26 ]
  %25 = icmp ugt i32 %24, 7
  br i1 %25, label %26, label %52

26:                                               ; preds = %21
  %27 = inttoptr i32 %23 to ptr
  store volatile i32 %22, ptr %27, align 4, !tbaa !3
  %28 = add i32 %22, 640
  %29 = add i32 %23, 12
  %30 = inttoptr i32 %29 to ptr
  store volatile i32 %28, ptr %30, align 4, !tbaa !3
  %31 = add i32 %22, 1280
  %32 = add i32 %23, 24
  %33 = inttoptr i32 %32 to ptr
  store volatile i32 %31, ptr %33, align 4, !tbaa !3
  %34 = add i32 %22, 1920
  %35 = add i32 %23, 36
  %36 = inttoptr i32 %35 to ptr
  store volatile i32 %34, ptr %36, align 4, !tbaa !3
  %37 = add i32 %22, 2560
  %38 = add i32 %23, 48
  %39 = inttoptr i32 %38 to ptr
  store volatile i32 %37, ptr %39, align 4, !tbaa !3
  %40 = add i32 %22, 3200
  %41 = add i32 %23, 60
  %42 = inttoptr i32 %41 to ptr
  store volatile i32 %40, ptr %42, align 4, !tbaa !3
  %43 = add i32 %22, 3840
  %44 = add i32 %23, 72
  %45 = inttoptr i32 %44 to ptr
  store volatile i32 %43, ptr %45, align 4, !tbaa !3
  %46 = add i32 %22, 4480
  %47 = add i32 %23, 84
  %48 = inttoptr i32 %47 to ptr
  store volatile i32 %46, ptr %48, align 4, !tbaa !3
  %49 = add i32 %23, 96
  %50 = add i32 %22, 5120
  %51 = add i32 %24, -8
  br label %21, !llvm.loop !7

52:                                               ; preds = %21
  %53 = load i32, ptr @fb_psram, align 4, !tbaa !3
  %54 = add nuw nsw i32 %15, 1
  br label %12, !llvm.loop !10

55:                                               ; preds = %1, %17
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kfb_pause() local_unnamed_addr #3 {
  %1 = load i1, ptr @fb_on, align 4
  br i1 %1, label %2, label %38

2:                                                ; preds = %0
  %3 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %4 = add i32 %3, 15412
  %5 = add i32 %3, 22567
  %6 = and i32 %5, -32
  %7 = add i32 %6, 68
  %8 = inttoptr i32 %7 to ptr
  store volatile i32 0, ptr %8, align 4, !tbaa !3
  %9 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %10 = add i32 %9, 22567
  %11 = and i32 %10, -32
  %12 = add i32 %11, 68
  %13 = inttoptr i32 %4 to ptr
  store volatile i32 %12, ptr %13, align 4, !tbaa !3
  %14 = load i32, ptr @fb_sram, align 4
  %15 = add i32 %14, 22567
  %16 = and i32 %15, -32
  %17 = add i32 %16, 68
  %18 = inttoptr i32 %17 to ptr
  br label %19

19:                                               ; preds = %22, %2
  %20 = phi i32 [ 0, %2 ], [ %25, %22 ]
  %21 = icmp eq i32 %20, 40000
  br i1 %21, label %26, label %22

22:                                               ; preds = %19
  %23 = load volatile i32, ptr %18, align 4, !tbaa !3
  %24 = icmp eq i32 %23, %14
  %25 = add nuw nsw i32 %20, 1
  br i1 %24, label %26, label %19, !llvm.loop !11

26:                                               ; preds = %22, %19
  %27 = load i32, ptr @fb_abort, align 4, !tbaa !3
  %28 = inttoptr i32 %27 to ptr
  store volatile i32 57344, ptr %28, align 4, !tbaa !3
  %29 = load i32, ptr @fb_abort, align 4, !tbaa !3
  %30 = inttoptr i32 %29 to ptr
  br label %31

31:                                               ; preds = %31, %26
  %32 = load volatile i32, ptr %30, align 4, !tbaa !3
  %33 = and i32 %32, 57344
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %35, label %31, !llvm.loop !12

35:                                               ; preds = %31
  %36 = load i32, ptr @fb_dmabase, align 4, !tbaa !3
  %37 = add i32 %36, 892
  store volatile i32 %37, ptr %13, align 4, !tbaa !3
  br label %38

38:                                               ; preds = %0, %35
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kfb_resume() local_unnamed_addr #3 {
  %1 = load i1, ptr @fb_on, align 4
  br i1 %1, label %2, label %3

2:                                                ; preds = %0
  tail call fastcc void @start() #8
  br label %3

3:                                                ; preds = %0, %2
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @start() unnamed_addr #3 {
  %1 = load i32, ptr @fb_dmabase, align 4, !tbaa !3
  %2 = load i32, ptr @fb_ctrl_copy, align 4, !tbaa !3
  %3 = add i32 %1, 976
  %4 = inttoptr i32 %3 to ptr
  store volatile i32 %2, ptr %4, align 4, !tbaa !3
  %5 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %6 = add i32 %5, 15424
  %7 = inttoptr i32 %6 to ptr
  %8 = load volatile i32, ptr %7, align 4, !tbaa !3
  %9 = add i32 %1, 1012
  %10 = inttoptr i32 %9 to ptr
  store volatile i32 %8, ptr %10, align 4, !tbaa !3
  %11 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %12 = add i32 %11, 15428
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !3
  %15 = add i32 %1, 1016
  %16 = inttoptr i32 %15 to ptr
  store volatile i32 %14, ptr %16, align 4, !tbaa !3
  %17 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %18 = add i32 %17, 15432
  %19 = inttoptr i32 %18 to ptr
  %20 = load volatile i32, ptr %19, align 4, !tbaa !3
  %21 = add i32 %1, 1020
  %22 = inttoptr i32 %21 to ptr
  store volatile i32 %20, ptr %22, align 4, !tbaa !3
  %23 = add i32 %1, 968
  %24 = inttoptr i32 %23 to ptr
  br label %25

25:                                               ; preds = %25, %0
  %26 = load volatile i32, ptr %24, align 4, !tbaa !3
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %25, !llvm.loop !13

28:                                               ; preds = %25
  %29 = load i32, ptr @fb_ctrl_walk, align 4, !tbaa !3
  %30 = add i32 %1, 848
  %31 = inttoptr i32 %30 to ptr
  store volatile i32 %29, ptr %31, align 4, !tbaa !3
  %32 = load i32, ptr @fb_dmabase, align 4, !tbaa !3
  %33 = add i32 %32, 896
  %34 = add i32 %1, 836
  %35 = inttoptr i32 %34 to ptr
  store volatile i32 %33, ptr %35, align 4, !tbaa !3
  %36 = add i32 %1, 840
  %37 = inttoptr i32 %36 to ptr
  store volatile i32 4, ptr %37, align 4, !tbaa !3
  %38 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %39 = add i32 %1, 892
  %40 = inttoptr i32 %39 to ptr
  store volatile i32 %38, ptr %40, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfb_syscall(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #5 {
  %5 = load i1, ptr @fb_on, align 4
  br i1 %5, label %6, label %26

6:                                                ; preds = %4
  switch i32 %0, label %26 [
    i32 0, label %7
    i32 1, label %16
    i32 2, label %22
  ]

7:                                                ; preds = %6
  %8 = icmp eq i32 %3, 0
  br i1 %8, label %9, label %26

9:                                                ; preds = %7
  %10 = inttoptr i32 %1 to ptr
  %11 = load i32, ptr @fb_psram, align 4, !tbaa !3
  store i32 %11, ptr %10, align 4, !tbaa !3
  %12 = getelementptr inbounds nuw i8, ptr %10, i32 4
  store i32 640, ptr %12, align 4, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 8
  store i32 480, ptr %13, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %10, i32 12
  store i32 8, ptr %14, align 4, !tbaa !3
  %15 = getelementptr inbounds nuw i8, ptr %10, i32 16
  store i32 640, ptr %15, align 4, !tbaa !3
  br label %26

16:                                               ; preds = %6
  %17 = load i32, ptr @fb_owner, align 4, !tbaa !3
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %21, label %19

19:                                               ; preds = %16
  %20 = icmp eq i32 %17, %2
  br i1 %20, label %21, label %26

21:                                               ; preds = %19, %16
  tail call void @kfbcon_reset() #9
  store i32 %2, ptr @fb_owner, align 4, !tbaa !3
  br label %26

22:                                               ; preds = %6
  %23 = load i32, ptr @fb_owner, align 4, !tbaa !3
  %24 = icmp eq i32 %23, %2
  br i1 %24, label %25, label %26

25:                                               ; preds = %22
  store i32 0, ptr @fb_owner, align 4, !tbaa !3
  tail call void @kfbcon_reset() #9
  br label %26

26:                                               ; preds = %6, %22, %19, %7, %4, %25, %21, %9
  %27 = phi i32 [ 0, %9 ], [ 0, %21 ], [ 0, %25 ], [ -1, %4 ], [ -1, %7 ], [ -1, %19 ], [ -1, %22 ], [ -1, %6 ]
  ret i32 %27
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #6

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 301) i32 @kfb_init() local_unnamed_addr #3 {
  %1 = load i32, ptr @fb_psram, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %199, label %3

3:                                                ; preds = %0
  %4 = inttoptr i32 %1 to ptr
  store volatile i32 1526618018, ptr %4, align 4, !tbaa !3
  %5 = load i32, ptr @fb_psram, align 4, !tbaa !3
  %6 = load i32, ptr @fb_psram_sz, align 4, !tbaa !3
  %7 = add i32 %5, -4
  %8 = add i32 %7, %6
  %9 = inttoptr i32 %8 to ptr
  store volatile i32 -1056969216, ptr %9, align 4, !tbaa !3
  %10 = load i32, ptr @fb_psram, align 4, !tbaa !3
  %11 = inttoptr i32 %10 to ptr
  %12 = load volatile i32, ptr %11, align 4, !tbaa !3
  %13 = icmp eq i32 %12, 1526618018
  br i1 %13, label %14, label %21

14:                                               ; preds = %3
  %15 = load i32, ptr @fb_psram_sz, align 4, !tbaa !3
  %16 = add i32 %10, -4
  %17 = add i32 %16, %15
  %18 = inttoptr i32 %17 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !3
  %20 = icmp eq i32 %19, -1056969216
  br i1 %20, label %22, label %21

21:                                               ; preds = %14, %3
  store i32 0, ptr @fb_psram, align 4, !tbaa !3
  br label %199

22:                                               ; preds = %14
  %23 = add i32 %10, 307200
  br label %24

24:                                               ; preds = %196, %22
  %25 = phi i32 [ %10, %22 ], [ %198, %196 ]
  %26 = icmp ult i32 %25, %23
  br i1 %26, label %196, label %27

27:                                               ; preds = %24, %30
  %28 = phi i32 [ %52, %30 ], [ 0, %24 ]
  %29 = icmp eq i32 %28, 2
  br i1 %29, label %53, label %30

30:                                               ; preds = %27
  %31 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %32 = mul nuw nsw i32 %28, 676
  %33 = add nuw nsw i32 %32, 21184
  %34 = add i32 %33, %31
  %35 = inttoptr i32 %34 to ptr
  store volatile i32 4112, ptr %35, align 4, !tbaa !3
  %36 = add i32 %34, 4
  %37 = inttoptr i32 %36 to ptr
  store volatile i32 894259883, ptr %37, align 4, !tbaa !3
  %38 = add i32 %34, 8
  %39 = inttoptr i32 %38 to ptr
  store volatile i32 61440, ptr %39, align 4, !tbaa !3
  %40 = add i32 %34, 12
  %41 = inttoptr i32 %40 to ptr
  store volatile i32 4192, ptr %41, align 4, !tbaa !3
  %42 = add i32 %34, 16
  %43 = inttoptr i32 %42 to ptr
  store volatile i32 894259540, ptr %43, align 4, !tbaa !3
  %44 = add i32 %34, 20
  %45 = inttoptr i32 %44 to ptr
  store volatile i32 61440, ptr %45, align 4, !tbaa !3
  %46 = add i32 %34, 24
  %47 = inttoptr i32 %46 to ptr
  store volatile i32 4144, ptr %47, align 4, !tbaa !3
  %48 = add i32 %34, 28
  %49 = inttoptr i32 %48 to ptr
  store volatile i32 894259883, ptr %49, align 4, !tbaa !3
  %50 = add i32 %34, 32
  %51 = inttoptr i32 %50 to ptr
  store volatile i32 8832, ptr %51, align 4, !tbaa !3
  %52 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !14

53:                                               ; preds = %27, %56
  %54 = phi i32 [ %80, %56 ], [ 0, %27 ]
  %55 = icmp eq i32 %54, 2
  br i1 %55, label %81, label %56

56:                                               ; preds = %53
  %57 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %58 = add i32 %57, 22567
  %59 = and i32 %58, -32
  %60 = shl nuw nsw i32 %54, 5
  %61 = add i32 %59, %60
  %62 = icmp eq i32 %54, 0
  %63 = select i1 %62, i32 894259883, i32 894259371
  %64 = select i1 %62, i32 894259540, i32 894260052
  %65 = inttoptr i32 %61 to ptr
  store volatile i32 4112, ptr %65, align 32, !tbaa !3
  %66 = or disjoint i32 %61, 4
  %67 = inttoptr i32 %66 to ptr
  store volatile i32 %63, ptr %67, align 4, !tbaa !3
  %68 = or disjoint i32 %61, 8
  %69 = inttoptr i32 %68 to ptr
  store volatile i32 4192, ptr %69, align 8, !tbaa !3
  %70 = or disjoint i32 %61, 12
  %71 = inttoptr i32 %70 to ptr
  store volatile i32 %64, ptr %71, align 4, !tbaa !3
  %72 = or disjoint i32 %61, 16
  %73 = inttoptr i32 %72 to ptr
  store volatile i32 4784, ptr %73, align 16, !tbaa !3
  %74 = or disjoint i32 %61, 20
  %75 = inttoptr i32 %74 to ptr
  store volatile i32 %63, ptr %75, align 4, !tbaa !3
  %76 = or disjoint i32 %61, 24
  %77 = inttoptr i32 %76 to ptr
  store volatile i32 61440, ptr %77, align 8, !tbaa !3
  %78 = or disjoint i32 %61, 28
  %79 = inttoptr i32 %78 to ptr
  store volatile i32 61440, ptr %79, align 4, !tbaa !3
  %80 = add nuw nsw i32 %54, 1
  br label %53, !llvm.loop !15

81:                                               ; preds = %53
  %82 = load i32, ptr @fb_psram, align 4, !tbaa !3
  br label %83

83:                                               ; preds = %87, %81
  %84 = phi i32 [ %82, %81 ], [ %100, %87 ]
  %85 = phi i32 [ 0, %81 ], [ %101, %87 ]
  %86 = icmp eq i32 %85, 480
  br i1 %86, label %102, label %87

87:                                               ; preds = %83
  %88 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %89 = mul nuw nsw i32 %85, 12
  %90 = add nuw nsw i32 %89, 15424
  %91 = add i32 %90, %88
  %92 = trunc i32 %85 to i1
  %93 = select i1 %92, i32 21896, i32 21220
  %94 = add i32 %88, %93
  %95 = inttoptr i32 %91 to ptr
  store volatile i32 %94, ptr %95, align 4, !tbaa !3
  %96 = add i32 %91, 4
  %97 = inttoptr i32 %96 to ptr
  store volatile i32 160, ptr %97, align 4, !tbaa !3
  %98 = add i32 %91, 8
  %99 = inttoptr i32 %98 to ptr
  store volatile i32 %84, ptr %99, align 4, !tbaa !3
  %100 = add i32 %84, 640
  %101 = add nuw nsw i32 %85, 1
  br label %83, !llvm.loop !16

102:                                              ; preds = %83
  %103 = load i32, ptr @fb_dmabase, align 4, !tbaa !3
  %104 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %105 = add i32 %103, 1012
  br label %106

106:                                              ; preds = %110, %102
  %107 = phi i32 [ %104, %102 ], [ %140, %110 ]
  %108 = phi i32 [ 0, %102 ], [ %111, %110 ]
  %109 = icmp eq i32 %108, 480
  br i1 %109, label %141, label %110

110:                                              ; preds = %106
  %111 = add nuw nsw i32 %108, 1
  %112 = icmp eq i32 %111, 480
  %113 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %114 = mul nuw nsw i32 %111, 12
  %115 = add nuw nsw i32 %114, 15424
  %116 = select i1 %112, i32 15424, i32 %115
  %117 = add i32 %113, %116
  %118 = inttoptr i32 %107 to ptr
  store volatile i32 %117, ptr %118, align 4, !tbaa !3
  %119 = add i32 %107, 4
  %120 = inttoptr i32 %119 to ptr
  store volatile i32 %105, ptr %120, align 4, !tbaa !3
  %121 = add i32 %107, 8
  %122 = inttoptr i32 %121 to ptr
  store volatile i32 3, ptr %122, align 4, !tbaa !3
  %123 = load i32, ptr @fb_ctrl_kick, align 4, !tbaa !3
  %124 = add i32 %107, 12
  %125 = inttoptr i32 %124 to ptr
  store volatile i32 %123, ptr %125, align 4, !tbaa !3
  %126 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %127 = trunc i32 %108 to i1
  %128 = select i1 %127, i32 21860, i32 21184
  %129 = add i32 %126, %128
  %130 = add i32 %107, 16
  %131 = inttoptr i32 %130 to ptr
  store volatile i32 %129, ptr %131, align 4, !tbaa !3
  %132 = load i32, ptr @fb_hstx, align 4, !tbaa !3
  %133 = add i32 %107, 20
  %134 = inttoptr i32 %133 to ptr
  store volatile i32 %132, ptr %134, align 4, !tbaa !3
  %135 = add i32 %107, 24
  %136 = inttoptr i32 %135 to ptr
  store volatile i32 169, ptr %136, align 4, !tbaa !3
  %137 = load i32, ptr @fb_ctrl_strm, align 4, !tbaa !3
  %138 = add i32 %107, 28
  %139 = inttoptr i32 %138 to ptr
  store volatile i32 %137, ptr %139, align 4, !tbaa !3
  %140 = add i32 %107, 32
  br label %106, !llvm.loop !17

141:                                              ; preds = %106
  %142 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %143 = add i32 %142, 22567
  %144 = and i32 %143, -32
  %145 = inttoptr i32 %107 to ptr
  store volatile i32 %144, ptr %145, align 4, !tbaa !3
  %146 = load i32, ptr @fb_hstx, align 4, !tbaa !3
  %147 = add i32 %107, 4
  %148 = inttoptr i32 %147 to ptr
  store volatile i32 %146, ptr %148, align 4, !tbaa !3
  %149 = add i32 %107, 8
  %150 = inttoptr i32 %149 to ptr
  store volatile i32 80, ptr %150, align 4, !tbaa !3
  %151 = load i32, ptr @fb_ctrl_vbl, align 4, !tbaa !3
  %152 = add i32 %107, 12
  %153 = inttoptr i32 %152 to ptr
  store volatile i32 %151, ptr %153, align 4, !tbaa !3
  %154 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %155 = add i32 %154, 22567
  %156 = and i32 %155, -32
  %157 = add i32 %156, 32
  %158 = add i32 %107, 16
  %159 = inttoptr i32 %158 to ptr
  store volatile i32 %157, ptr %159, align 4, !tbaa !3
  %160 = load i32, ptr @fb_hstx, align 4, !tbaa !3
  %161 = add i32 %107, 20
  %162 = inttoptr i32 %161 to ptr
  store volatile i32 %160, ptr %162, align 4, !tbaa !3
  %163 = add i32 %107, 24
  %164 = inttoptr i32 %163 to ptr
  store volatile i32 16, ptr %164, align 4, !tbaa !3
  %165 = load i32, ptr @fb_ctrl_vbl, align 4, !tbaa !3
  %166 = add i32 %107, 28
  %167 = inttoptr i32 %166 to ptr
  store volatile i32 %165, ptr %167, align 4, !tbaa !3
  %168 = add i32 %107, 32
  %169 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %170 = add i32 %169, 22567
  %171 = and i32 %170, -32
  %172 = inttoptr i32 %168 to ptr
  store volatile i32 %171, ptr %172, align 4, !tbaa !3
  %173 = load i32, ptr @fb_hstx, align 4, !tbaa !3
  %174 = add i32 %107, 36
  %175 = inttoptr i32 %174 to ptr
  store volatile i32 %173, ptr %175, align 4, !tbaa !3
  %176 = add i32 %107, 40
  %177 = inttoptr i32 %176 to ptr
  store volatile i32 264, ptr %177, align 4, !tbaa !3
  %178 = load i32, ptr @fb_ctrl_vbl, align 4, !tbaa !3
  %179 = add i32 %107, 44
  %180 = inttoptr i32 %179 to ptr
  store volatile i32 %178, ptr %180, align 4, !tbaa !3
  %181 = load i32, ptr @fb_sram, align 4, !tbaa !3
  %182 = add i32 %181, 22567
  %183 = and i32 %182, -32
  %184 = add i32 %183, 64
  %185 = inttoptr i32 %184 to ptr
  store volatile i32 %181, ptr %185, align 32, !tbaa !3
  %186 = add i32 %107, 48
  %187 = inttoptr i32 %186 to ptr
  store volatile i32 %184, ptr %187, align 4, !tbaa !3
  %188 = add i32 %103, 892
  %189 = add i32 %107, 52
  %190 = inttoptr i32 %189 to ptr
  store volatile i32 %188, ptr %190, align 4, !tbaa !3
  %191 = add i32 %107, 56
  %192 = inttoptr i32 %191 to ptr
  store volatile i32 1, ptr %192, align 4, !tbaa !3
  %193 = load i32, ptr @fb_ctrl_tail, align 4, !tbaa !3
  %194 = add i32 %107, 60
  %195 = inttoptr i32 %194 to ptr
  store volatile i32 %193, ptr %195, align 4, !tbaa !3
  tail call fastcc void @start() #8
  store i1 true, ptr @fb_on, align 4
  br label %199

196:                                              ; preds = %24
  %197 = inttoptr i32 %25 to ptr
  store volatile i32 0, ptr %197, align 4, !tbaa !3
  %198 = add i32 %25, 4
  br label %24, !llvm.loop !18

199:                                              ; preds = %0, %141, %21
  %200 = phi i32 [ -1, %21 ], [ 300, %141 ], [ 0, %0 ]
  ret i32 %200
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { nounwind }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }
attributes #9 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
