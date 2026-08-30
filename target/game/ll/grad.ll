; ModuleID = 'grad.c'
source_filename = "grad.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [10 x i8] c"grad: up\0A\00", align 1
@lo = internal unnamed_addr global i32 0, align 4
@q = internal unnamed_addr global i32 0, align 4
@ahold = internal unnamed_addr global i32 0, align 4
@mon = internal unnamed_addr global i1 false, align 1
@mchan = internal unnamed_addr global i8 0, align 1
@mn = internal unnamed_addr global i8 0, align 1
@mm = internal unnamed_addr global i8 0, align 1
@lbl = internal global [3 x i8] zeroinitializer, align 1
@hdr = internal global [28 x i8] c"tap back hold match 000-000\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [12 x i8] c"grad: back\0A\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"grad: ramps\0A\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"grad: match \00", align 1
@mhdr = internal global [26 x i8] c"C  N 00  M 00  floor +000\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"grad: view \00", align 1
@mchn = internal unnamed_addr constant [5 x i8] c"RGBW\00", align 1
@mword = internal global i32 0, align 4
@fb = external dso_local global [57600 x i16], align 2

; Function Attrs: minsize nounwind optsize
define dso_local void @grad_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #5
  tail call void @led(i32 noundef 1039, i32 noundef 1039) #5
  store i32 0, ptr @lo, align 4, !tbaa !3
  store i32 16, ptr @q, align 4, !tbaa !3
  store i32 0, ptr @ahold, align 4, !tbaa !3
  store i1 false, ptr @mon, align 1
  store i8 0, ptr @mchan, align 1, !tbaa !7
  store i8 16, ptr @mn, align 1, !tbaa !7
  store i8 8, ptr @mm, align 1, !tbaa !7
  tail call void @gfx_clear(i16 noundef zeroext 0) #5
  tail call fastcc void @redraw() #6
  br label %1

1:                                                ; preds = %1, %0
  tail call void @frame_sync(i32 noundef 33000) #5
  tail call void @in_poll() #5
  %2 = tail call fastcc i32 @grad_frame() #6
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %1, label %4, !llvm.loop !8

4:                                                ; preds = %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @redraw() unnamed_addr #0 {
  %1 = load i32, ptr @q, align 4, !tbaa !3
  %2 = udiv i32 3932160, %1
  %3 = load i32, ptr @lo, align 4, !tbaa !3
  %4 = lshr i32 %3, 2
  %5 = lshr i32 %3, 3
  %6 = icmp ult i32 %1, 4
  %7 = icmp ult i32 %1, 7
  br label %8

8:                                                ; preds = %36, %0
  %9 = phi i32 [ 0, %0 ], [ %16, %36 ]
  %10 = phi i32 [ 0, %0 ], [ %15, %36 ]
  %11 = phi i32 [ %5, %0 ], [ %39, %36 ]
  %12 = phi i32 [ %4, %0 ], [ %38, %36 ]
  %13 = icmp samesign ult i32 %9, 240
  br i1 %13, label %14, label %40

14:                                               ; preds = %8
  %15 = add i32 %10, %2
  %16 = lshr i32 %15, 16
  %17 = trunc i32 %11 to i16
  %18 = shl i16 %17, 11
  %19 = trunc i32 %12 to i16
  %20 = shl i16 %19, 5
  %21 = sub nsw i32 %16, %9
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 16, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %18) #5
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 72, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %20) #5
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 128, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %17) #5
  %22 = or i16 %18, %17
  %23 = or i16 %22, %20
  tail call void @gfx_fill(i32 noundef %9, i32 noundef 184, i32 noundef %21, i32 noundef 56, i16 noundef zeroext %23) #5
  %24 = icmp samesign ult i32 %9, 223
  %25 = select i1 %7, i1 %24, i1 false
  br i1 %25, label %28, label %26

26:                                               ; preds = %14
  %27 = and i32 %12, 1
  br label %36

28:                                               ; preds = %14
  br i1 %6, label %29, label %31

29:                                               ; preds = %28
  tail call void @numsp(ptr noundef nonnull @lbl, i32 noundef 2, i32 noundef %12) #5
  %30 = add nuw nsw i32 %9, 2
  tail call void @gfx_text(i32 noundef %30, i32 noundef 116, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #5
  br label %31

31:                                               ; preds = %29, %28
  %32 = and i32 %12, 1
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %31
  tail call void @numsp(ptr noundef nonnull @lbl, i32 noundef 2, i32 noundef %11) #5
  %35 = add nuw nsw i32 %9, 2
  tail call void @gfx_text(i32 noundef %35, i32 noundef 60, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #5
  tail call void @gfx_text(i32 noundef %35, i32 noundef 172, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #5
  br label %36

36:                                               ; preds = %26, %31, %34
  %37 = phi i32 [ %27, %26 ], [ 1, %31 ], [ 0, %34 ]
  %38 = add i32 %12, 1
  %39 = add i32 %37, %11
  br label %8, !llvm.loop !10

40:                                               ; preds = %8
  %41 = load i32, ptr @lo, align 4, !tbaa !3
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 20), i32 noundef 3, i32 noundef %41) #5
  store i8 45, ptr getelementptr inbounds nuw (i8, ptr @hdr, i32 23), align 1, !tbaa !7
  %42 = load i32, ptr @lo, align 4, !tbaa !3
  %43 = load i32, ptr @q, align 4, !tbaa !3
  %44 = shl nuw nsw i32 %43, 4
  %45 = add i32 %42, -1
  %46 = add i32 %45, %44
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 24), i32 noundef 3, i32 noundef %46) #5
  tail call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull @hdr, i16 noundef zeroext -16870, i16 noundef zeroext 0) #5
  tail call void @gfx_present() #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc range(i32 0, 2) i32 @grad_frame() unnamed_addr #2 {
  %1 = load i32, ptr @in_edge, align 4, !tbaa !3
  %2 = and i32 %1, 16
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %0
  store i32 1, ptr @ahold, align 4, !tbaa !3
  br label %44

5:                                                ; preds = %0
  %6 = load i32, ptr @in_down, align 4, !tbaa !3
  %7 = and i32 %6, 16
  %8 = icmp eq i32 %7, 0
  %9 = load i32, ptr @ahold, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  br i1 %8, label %12, label %11

11:                                               ; preds = %5
  br i1 %10, label %44, label %19

12:                                               ; preds = %5
  br i1 %10, label %44, label %13

13:                                               ; preds = %12
  store i32 0, ptr @ahold, align 4, !tbaa !3
  %14 = icmp ult i32 %9, 25
  br i1 %14, label %15, label %44

15:                                               ; preds = %13
  %16 = load i1, ptr @mon, align 1
  br i1 %16, label %18, label %17

17:                                               ; preds = %15
  tail call void @led(i32 noundef 0, i32 noundef 0) #5
  br label %126

18:                                               ; preds = %15
  store i1 false, ptr @mon, align 1
  tail call void @gfx_clear(i16 noundef zeroext 0) #5
  tail call fastcc void @redraw() #6
  br label %126

19:                                               ; preds = %11
  %20 = add i32 %9, 1
  store i32 %20, ptr @ahold, align 4, !tbaa !3
  %21 = icmp eq i32 %20, 25
  br i1 %21, label %22, label %44

22:                                               ; preds = %19
  %23 = load i1, ptr @mon, align 1
  br i1 %23, label %24, label %42

24:                                               ; preds = %22
  %25 = load i8, ptr @mchan, align 1, !tbaa !7
  %26 = add i8 %25, 1
  %27 = and i8 %26, 3
  store i8 %27, ptr @mchan, align 1, !tbaa !7
  %28 = and i8 %25, 3
  %29 = icmp eq i8 %28, 0
  %30 = select i1 %29, i32 63, i32 31
  %31 = load i8, ptr @mn, align 1, !tbaa !7
  %32 = zext i8 %31 to i32
  %33 = icmp samesign ult i32 %30, %32
  br i1 %33, label %34, label %36

34:                                               ; preds = %24
  %35 = trunc nuw nsw i32 %30 to i8
  store i8 %35, ptr @mn, align 1, !tbaa !7
  br label %36

36:                                               ; preds = %34, %24
  %37 = load i8, ptr @mm, align 1, !tbaa !7
  %38 = zext i8 %37 to i32
  %39 = icmp samesign ult i32 %30, %38
  br i1 %39, label %40, label %43

40:                                               ; preds = %36
  %41 = trunc nuw nsw i32 %30 to i8
  store i8 %41, ptr @mm, align 1, !tbaa !7
  br label %43

42:                                               ; preds = %22
  store i1 true, ptr @mon, align 1
  tail call void @gfx_clear(i16 noundef zeroext 0) #5
  br label %43

43:                                               ; preds = %36, %40, %42
  tail call fastcc void @mredraw() #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #5
  tail call void @uputs(ptr noundef nonnull @mhdr) #5
  br label %126

44:                                               ; preds = %4, %12, %11, %13, %19
  %45 = and i32 %1, 15
  %46 = load i1, ptr @mon, align 1
  br i1 %46, label %47, label %82

47:                                               ; preds = %44
  %48 = icmp eq i32 %45, 0
  br i1 %48, label %129, label %49

49:                                               ; preds = %47
  %50 = load i8, ptr @mchan, align 1, !tbaa !7
  %51 = icmp eq i8 %50, 1
  %52 = select i1 %51, i32 63, i32 31
  %53 = and i32 %1, 1
  %54 = icmp eq i32 %53, 0
  br i1 %54, label %61, label %55

55:                                               ; preds = %49
  %56 = load i8, ptr @mm, align 1, !tbaa !7
  %57 = zext i8 %56 to i32
  %58 = icmp samesign ugt i32 %52, %57
  br i1 %58, label %59, label %129

59:                                               ; preds = %55
  %60 = add i8 %56, 1
  store i8 %60, ptr @mm, align 1, !tbaa !7
  br label %81

61:                                               ; preds = %49
  %62 = and i32 %1, 2
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %69, label %64

64:                                               ; preds = %61
  %65 = load i8, ptr @mm, align 1, !tbaa !7
  %66 = icmp eq i8 %65, 0
  br i1 %66, label %129, label %67

67:                                               ; preds = %64
  %68 = add i8 %65, -1
  store i8 %68, ptr @mm, align 1, !tbaa !7
  br label %81

69:                                               ; preds = %61
  %70 = icmp samesign ult i32 %45, 8
  %71 = load i8, ptr @mn, align 1, !tbaa !7
  br i1 %70, label %77, label %72

72:                                               ; preds = %69
  %73 = zext i8 %71 to i32
  %74 = icmp samesign ugt i32 %52, %73
  br i1 %74, label %75, label %129

75:                                               ; preds = %72
  %76 = add i8 %71, 1
  store i8 %76, ptr @mn, align 1, !tbaa !7
  br label %81

77:                                               ; preds = %69
  %78 = icmp eq i8 %71, 0
  br i1 %78, label %129, label %79

79:                                               ; preds = %77
  %80 = add i8 %71, -1
  store i8 %80, ptr @mn, align 1, !tbaa !7
  br label %81

81:                                               ; preds = %79, %75, %67, %59
  tail call fastcc void @mredraw() #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #5
  tail call void @uputs(ptr noundef nonnull @mhdr) #5
  br label %126

82:                                               ; preds = %44
  %83 = load i32, ptr @lo, align 4, !tbaa !3
  %84 = load i32, ptr @q, align 4, !tbaa !3
  %85 = and i32 %1, 1
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %93, label %87

87:                                               ; preds = %82
  %88 = icmp ugt i32 %84, 1
  br i1 %88, label %89, label %114

89:                                               ; preds = %87
  %90 = shl nuw nsw i32 %84, 2
  %91 = add nsw i32 %90, %83
  %92 = lshr i32 %84, 1
  br label %114

93:                                               ; preds = %82
  %94 = and i32 %1, 2
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %102, label %96

96:                                               ; preds = %93
  %97 = icmp ult i32 %84, 16
  br i1 %97, label %98, label %114

98:                                               ; preds = %96
  %99 = shl nuw nsw i32 %84, 3
  %100 = sub nsw i32 %83, %99
  %101 = shl nuw nsw i32 %84, 1
  br label %114

102:                                              ; preds = %93
  %103 = and i32 %1, 4
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %108, label %105

105:                                              ; preds = %102
  %106 = shl nuw nsw i32 %84, 2
  %107 = sub nsw i32 %83, %106
  br label %114

108:                                              ; preds = %102
  %109 = and i32 %1, 8
  %110 = icmp eq i32 %109, 0
  br i1 %110, label %129, label %111

111:                                              ; preds = %108
  %112 = shl nuw nsw i32 %84, 2
  %113 = add nsw i32 %112, %83
  br label %114

114:                                              ; preds = %98, %96, %111, %105, %87, %89
  %115 = phi i32 [ %91, %89 ], [ %83, %87 ], [ %100, %98 ], [ %83, %96 ], [ %107, %105 ], [ %113, %111 ]
  %116 = phi i32 [ %92, %89 ], [ %84, %87 ], [ %101, %98 ], [ %84, %96 ], [ %84, %105 ], [ %84, %111 ]
  %117 = shl nuw nsw i32 %116, 4
  %118 = sub nsw i32 256, %117
  %119 = icmp slt i32 %115, 0
  %120 = tail call i32 @llvm.smin.i32(i32 %115, i32 %118)
  %121 = select i1 %119, i32 0, i32 %120
  %122 = icmp eq i32 %121, %83
  %123 = icmp eq i32 %116, %84
  %124 = select i1 %122, i1 %123, i1 false
  br i1 %124, label %129, label %125

125:                                              ; preds = %114
  store i32 %121, ptr @lo, align 4, !tbaa !3
  store i32 %116, ptr @q, align 4, !tbaa !3
  tail call fastcc void @redraw() #6
  tail call void @uputs(ptr noundef nonnull @.str.5) #5
  tail call void @uputs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 20)) #5
  br label %126

126:                                              ; preds = %43, %125, %81, %18, %17
  %127 = phi ptr [ @.str.1, %17 ], [ @.str.2, %18 ], [ @.str.4, %81 ], [ @.str.4, %125 ], [ @.str.4, %43 ]
  %128 = phi i32 [ 1, %17 ], [ 0, %18 ], [ 0, %81 ], [ 0, %125 ], [ 0, %43 ]
  tail call void @uputs(ptr noundef nonnull %127) #5
  br label %129

129:                                              ; preds = %126, %77, %72, %64, %55, %47, %114, %108
  %130 = phi i32 [ 0, %108 ], [ 0, %114 ], [ 0, %47 ], [ 0, %55 ], [ 0, %64 ], [ 0, %72 ], [ 0, %77 ], [ %128, %126 ]
  ret i32 %130
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numsp(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @mredraw() unnamed_addr #0 {
  %1 = tail call fastcc zeroext i16 @mcolor(i32 noundef 0) #6
  %2 = load i8, ptr @mn, align 1, !tbaa !7
  %3 = zext i8 %2 to i32
  %4 = tail call fastcc zeroext i16 @mcolor(i32 noundef %3) #6
  %5 = load i8, ptr @mm, align 1, !tbaa !7
  %6 = zext i8 %5 to i32
  %7 = tail call fastcc zeroext i16 @mcolor(i32 noundef %6) #6
  tail call void @gfx_fill(i32 noundef 120, i32 noundef 16, i32 noundef 120, i32 noundef 224, i16 noundef zeroext %7) #5
  tail call fastcc void @mrows(i32 noundef 16, i16 noundef zeroext %1, i16 noundef zeroext %4) #6
  tail call fastcc void @mrows(i32 noundef 17, i16 noundef zeroext %4, i16 noundef zeroext %1) #6
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 16, i32 noundef 119, i32 noundef 239) #5
  %8 = load i8, ptr @mchan, align 1, !tbaa !7
  %9 = zext nneg i8 %8 to i32
  %10 = getelementptr inbounds nuw [5 x i8], ptr @mchn, i32 0, i32 %9
  %11 = load i8, ptr %10, align 1, !tbaa !7
  store i8 %11, ptr @mhdr, align 1, !tbaa !7
  %12 = load i8, ptr @mn, align 1, !tbaa !7
  %13 = zext i8 %12 to i32
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @mhdr, i32 5), i32 noundef 2, i32 noundef %13) #5
  store i8 32, ptr getelementptr inbounds nuw (i8, ptr @mhdr, i32 7), align 1, !tbaa !7
  %14 = load i8, ptr @mm, align 1, !tbaa !7
  %15 = zext i8 %14 to i32
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @mhdr, i32 11), i32 noundef 2, i32 noundef %15) #5
  store i8 32, ptr getelementptr inbounds nuw (i8, ptr @mhdr, i32 13), align 1, !tbaa !7
  %16 = load i8, ptr @mn, align 1, !tbaa !7
  %17 = zext i8 %16 to i32
  %18 = load i8, ptr @mm, align 1, !tbaa !7
  %19 = zext i8 %18 to i32
  %20 = shl nuw nsw i32 %19, 1
  %21 = sub nsw i32 %17, %20
  store i8 43, ptr getelementptr inbounds nuw (i8, ptr @mhdr, i32 21), align 1, !tbaa !7
  %22 = icmp slt i32 %21, 0
  br i1 %22, label %23, label %25

23:                                               ; preds = %0
  store i8 45, ptr getelementptr inbounds nuw (i8, ptr @mhdr, i32 21), align 1, !tbaa !7
  %24 = sub nsw i32 0, %21
  br label %25

25:                                               ; preds = %23, %0
  %26 = phi i32 [ %24, %23 ], [ %21, %0 ]
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @mhdr, i32 22), i32 noundef 3, i32 noundef %26) #5
  tail call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull @mhdr, i16 noundef zeroext -16870, i16 noundef zeroext 0) #5
  tail call void @gfx_present() #5
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc zeroext i16 @mcolor(i32 noundef range(i32 0, 256) %0) unnamed_addr #3 {
  %2 = load i8, ptr @mchan, align 1, !tbaa !7
  switch i8 %2, label %11 [
    i8 0, label %3
    i8 1, label %6
    i8 2, label %9
  ]

3:                                                ; preds = %1
  %4 = trunc nuw nsw i32 %0 to i16
  %5 = shl i16 %4, 11
  br label %17

6:                                                ; preds = %1
  %7 = trunc nuw nsw i32 %0 to i16
  %8 = shl nuw nsw i16 %7, 5
  br label %17

9:                                                ; preds = %1
  %10 = trunc nuw nsw i32 %0 to i16
  br label %17

11:                                               ; preds = %1
  %12 = shl nuw nsw i32 %0, 11
  %13 = shl nuw nsw i32 %0, 6
  %14 = or i32 %13, %12
  %15 = or i32 %14, %0
  %16 = trunc i32 %15 to i16
  br label %17

17:                                               ; preds = %11, %9, %6, %3
  %18 = phi i16 [ %5, %3 ], [ %8, %6 ], [ %10, %9 ], [ %16, %11 ]
  ret i16 %18
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @mrows(i32 noundef range(i32 16, 18) %0, i16 noundef zeroext %1, i16 noundef zeroext %2) unnamed_addr #0 {
  %4 = zext i16 %1 to i32
  %5 = zext i16 %2 to i32
  %6 = shl nuw i32 %5, 16
  %7 = or disjoint i32 %6, %4
  store i32 %7, ptr @mword, align 4, !tbaa !3
  %8 = mul nuw nsw i32 %0, 240
  %9 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %8
  %10 = ptrtoint ptr %9 to i32
  tail call void @gdma_rows(i32 noundef %10, i32 noundef ptrtoint (ptr @mword to i32), i32 noundef 60, i32 noundef 112, i32 noundef 960, i32 noundef 0) #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize noinline nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!5, !5, i64 0}
!8 = distinct !{!8, !9}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !11, !9}
!11 = !{!"llvm.loop.mustprogress"}
