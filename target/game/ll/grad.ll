; ModuleID = 'grad.c'
source_filename = "grad.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [10 x i8] c"grad: up\0A\00", align 1
@lo = internal unnamed_addr global i32 0, align 4
@q = internal unnamed_addr global i32 0, align 4
@ahold = internal unnamed_addr global i32 0, align 4
@mode = internal unnamed_addr global i8 0, align 1
@mchan = internal unnamed_addr global i8 0, align 1
@kk = internal unnamed_addr global i32 0, align 4
@mn = internal unnamed_addr global i8 0, align 1
@mm = internal unnamed_addr global i8 0, align 1
@lbl = internal global [3 x i8] zeroinitializer, align 1
@khdr = internal global [29 x i8] c"tap back hold ramps  K 00/16\00", align 1
@hdr = internal global [28 x i8] c"tap back hold match 000-000\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [12 x i8] c"grad: back\0A\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"grad: match \00", align 1
@mhdr = internal global [26 x i8] c"C  N 00  M 00  floor +000\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"grad: view \00", align 1
@klo = internal unnamed_addr global i32 0, align 4
@kqs = internal unnamed_addr global i32 0, align 4
@.str.5 = private unnamed_addr constant [13 x i8] c"grad: ramps\0A\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"grad: comp \00", align 1
@mchn = internal unnamed_addr constant [5 x i8] c"RGBW\00", align 1
@mword = internal global i32 0, align 4
@fb = external dso_local global [57600 x i16], align 2

; Function Attrs: minsize nounwind optsize
define dso_local void @grad_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #6
  tail call void @led(i32 noundef 1039, i32 noundef 1039) #6
  store i32 0, ptr @lo, align 4, !tbaa !3
  store i32 16, ptr @q, align 4, !tbaa !3
  store i32 0, ptr @ahold, align 4, !tbaa !3
  store i8 0, ptr @mode, align 1, !tbaa !7
  store i8 0, ptr @mchan, align 1, !tbaa !7
  store i32 0, ptr @kk, align 4, !tbaa !3
  store i8 16, ptr @mn, align 1, !tbaa !7
  store i8 8, ptr @mm, align 1, !tbaa !7
  tail call void @gfx_clear(i16 noundef zeroext 0) #6
  tail call fastcc void @redraw() #7
  br label %1

1:                                                ; preds = %1, %0
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %2 = tail call fastcc i32 @grad_frame() #7
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
  %17 = sub nsw i32 %16, %9
  %18 = shl i32 %12, 2
  %19 = tail call fastcc i32 @kcurve(i32 noundef %18) #7
  %20 = tail call i32 @gfx_dither(i32 noundef %19, i32 noundef 0, i32 noundef 0) #6
  tail call void @gfx_dfill(i32 noundef %9, i32 noundef 16, i32 noundef %17, i32 noundef 56) #6
  %21 = tail call i32 @gfx_dither(i32 noundef 0, i32 noundef %19, i32 noundef 0) #6
  tail call void @gfx_dfill(i32 noundef %9, i32 noundef 72, i32 noundef %17, i32 noundef 56) #6
  %22 = tail call i32 @gfx_dither(i32 noundef 0, i32 noundef 0, i32 noundef %19) #6
  tail call void @gfx_dfill(i32 noundef %9, i32 noundef 128, i32 noundef %17, i32 noundef 56) #6
  %23 = tail call i32 @gfx_dither(i32 noundef %19, i32 noundef %19, i32 noundef %19) #6
  tail call void @gfx_dfill(i32 noundef %9, i32 noundef 184, i32 noundef %17, i32 noundef 56) #6
  %24 = icmp samesign ult i32 %9, 223
  %25 = select i1 %7, i1 %24, i1 false
  br i1 %25, label %28, label %26

26:                                               ; preds = %14
  %27 = and i32 %12, 1
  br label %36

28:                                               ; preds = %14
  br i1 %6, label %29, label %31

29:                                               ; preds = %28
  tail call void @numsp(ptr noundef nonnull @lbl, i32 noundef 2, i32 noundef %12) #6
  %30 = add nuw nsw i32 %9, 2
  tail call void @gfx_text(i32 noundef %30, i32 noundef 116, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #6
  br label %31

31:                                               ; preds = %29, %28
  %32 = and i32 %12, 1
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %31
  tail call void @numsp(ptr noundef nonnull @lbl, i32 noundef 2, i32 noundef %11) #6
  %35 = add nuw nsw i32 %9, 2
  tail call void @gfx_text(i32 noundef %35, i32 noundef 60, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #6
  tail call void @gfx_text(i32 noundef %35, i32 noundef 172, ptr noundef nonnull @lbl, i16 noundef zeroext 0, i16 noundef zeroext -8617) #6
  br label %36

36:                                               ; preds = %26, %31, %34
  %37 = phi i32 [ %27, %26 ], [ 1, %31 ], [ 0, %34 ]
  %38 = add i32 %12, 1
  %39 = add i32 %37, %11
  br label %8, !llvm.loop !10

40:                                               ; preds = %8
  %41 = load i8, ptr @mode, align 1, !tbaa !7
  %42 = icmp eq i8 %41, 2
  br i1 %42, label %43, label %45

43:                                               ; preds = %40
  %44 = load i32, ptr @kk, align 4, !tbaa !3
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @khdr, i32 23), i32 noundef 2, i32 noundef %44) #6
  store i8 47, ptr getelementptr inbounds nuw (i8, ptr @khdr, i32 25), align 1, !tbaa !7
  br label %52

45:                                               ; preds = %40
  %46 = load i32, ptr @lo, align 4, !tbaa !3
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 20), i32 noundef 3, i32 noundef %46) #6
  store i8 45, ptr getelementptr inbounds nuw (i8, ptr @hdr, i32 23), align 1, !tbaa !7
  %47 = load i32, ptr @lo, align 4, !tbaa !3
  %48 = load i32, ptr @q, align 4, !tbaa !3
  %49 = shl nuw nsw i32 %48, 4
  %50 = add i32 %47, -1
  %51 = add i32 %50, %49
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 24), i32 noundef 3, i32 noundef %51) #6
  br label %52

52:                                               ; preds = %45, %43
  %53 = phi ptr [ @hdr, %45 ], [ @khdr, %43 ]
  tail call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull %53, i16 noundef zeroext -16870, i16 noundef zeroext 0) #6
  tail call void @gfx_present() #6
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
  br label %49

5:                                                ; preds = %0
  %6 = load i32, ptr @in_down, align 4, !tbaa !3
  %7 = and i32 %6, 16
  %8 = icmp eq i32 %7, 0
  %9 = load i32, ptr @ahold, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  br i1 %8, label %12, label %11

11:                                               ; preds = %5
  br i1 %10, label %49, label %20

12:                                               ; preds = %5
  br i1 %10, label %49, label %13

13:                                               ; preds = %12
  store i32 0, ptr @ahold, align 4, !tbaa !3
  %14 = icmp ult i32 %9, 25
  br i1 %14, label %15, label %49

15:                                               ; preds = %13
  %16 = load i8, ptr @mode, align 1, !tbaa !7
  %17 = icmp eq i8 %16, 0
  br i1 %17, label %18, label %19

18:                                               ; preds = %15
  tail call void @led(i32 noundef 0, i32 noundef 0) #6
  tail call void @uputs(ptr noundef nonnull @.str.1) #6
  br label %135

19:                                               ; preds = %15
  tail call fastcc void @gomode(i32 noundef 0) #7
  br label %135

20:                                               ; preds = %11
  %21 = add i32 %9, 1
  store i32 %21, ptr @ahold, align 4, !tbaa !3
  %22 = icmp eq i32 %21, 25
  br i1 %22, label %23, label %49

23:                                               ; preds = %20
  %24 = load i8, ptr @mode, align 1, !tbaa !7
  %25 = icmp eq i8 %24, 1
  %26 = load i8, ptr @mchan, align 1
  %27 = icmp ult i8 %26, 3
  %28 = select i1 %25, i1 %27, i1 false
  br i1 %28, label %29, label %45

29:                                               ; preds = %23
  %30 = add nuw nsw i8 %26, 1
  store i8 %30, ptr @mchan, align 1, !tbaa !7
  %31 = icmp eq i8 %26, 0
  %32 = select i1 %31, i32 63, i32 31
  %33 = load i8, ptr @mn, align 1, !tbaa !7
  %34 = zext i8 %33 to i32
  %35 = icmp samesign ult i32 %32, %34
  br i1 %35, label %36, label %38

36:                                               ; preds = %29
  %37 = trunc nuw nsw i32 %32 to i8
  store i8 %37, ptr @mn, align 1, !tbaa !7
  br label %38

38:                                               ; preds = %36, %29
  %39 = load i8, ptr @mm, align 1, !tbaa !7
  %40 = zext i8 %39 to i32
  %41 = icmp samesign ult i32 %32, %40
  br i1 %41, label %42, label %44

42:                                               ; preds = %38
  %43 = trunc nuw nsw i32 %32 to i8
  store i8 %43, ptr @mm, align 1, !tbaa !7
  br label %44

44:                                               ; preds = %42, %38
  tail call fastcc void @mredraw() #7
  tail call void @uputs(ptr noundef nonnull @.str.2) #6
  tail call void @uputs(ptr noundef nonnull @mhdr) #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  br label %135

45:                                               ; preds = %23
  %46 = icmp eq i8 %24, 0
  %47 = select i1 %25, i32 2, i32 0
  %48 = select i1 %46, i32 1, i32 %47
  tail call fastcc void @gomode(i32 noundef %48) #7
  br label %135

49:                                               ; preds = %4, %12, %11, %13, %20
  %50 = and i32 %1, 15
  %51 = load i8, ptr @mode, align 1, !tbaa !7
  %52 = icmp eq i8 %51, 0
  br i1 %52, label %91, label %53

53:                                               ; preds = %49
  %54 = icmp eq i32 %50, 0
  br i1 %54, label %135, label %55

55:                                               ; preds = %53
  %56 = icmp eq i8 %51, 1
  br i1 %56, label %57, label %90

57:                                               ; preds = %55
  %58 = load i8, ptr @mchan, align 1, !tbaa !7
  %59 = icmp eq i8 %58, 1
  %60 = select i1 %59, i32 63, i32 31
  %61 = and i32 %1, 1
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %69, label %63

63:                                               ; preds = %57
  %64 = load i8, ptr @mm, align 1, !tbaa !7
  %65 = zext i8 %64 to i32
  %66 = icmp samesign ugt i32 %60, %65
  br i1 %66, label %67, label %135

67:                                               ; preds = %63
  %68 = add i8 %64, 1
  store i8 %68, ptr @mm, align 1, !tbaa !7
  br label %89

69:                                               ; preds = %57
  %70 = and i32 %1, 2
  %71 = icmp eq i32 %70, 0
  br i1 %71, label %77, label %72

72:                                               ; preds = %69
  %73 = load i8, ptr @mm, align 1, !tbaa !7
  %74 = icmp eq i8 %73, 0
  br i1 %74, label %135, label %75

75:                                               ; preds = %72
  %76 = add i8 %73, -1
  store i8 %76, ptr @mm, align 1, !tbaa !7
  br label %89

77:                                               ; preds = %69
  %78 = icmp samesign ult i32 %50, 8
  %79 = load i8, ptr @mn, align 1, !tbaa !7
  br i1 %78, label %85, label %80

80:                                               ; preds = %77
  %81 = zext i8 %79 to i32
  %82 = icmp samesign ugt i32 %60, %81
  br i1 %82, label %83, label %135

83:                                               ; preds = %80
  %84 = add i8 %79, 1
  store i8 %84, ptr @mn, align 1, !tbaa !7
  br label %89

85:                                               ; preds = %77
  %86 = icmp eq i8 %79, 0
  br i1 %86, label %135, label %87

87:                                               ; preds = %85
  %88 = add i8 %79, -1
  store i8 %88, ptr @mn, align 1, !tbaa !7
  br label %89

89:                                               ; preds = %87, %83, %75, %67
  tail call fastcc void @mredraw() #7
  tail call void @uputs(ptr noundef nonnull @.str.2) #6
  tail call void @uputs(ptr noundef nonnull @mhdr) #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  br label %135

90:                                               ; preds = %55
  tail call fastcc void @kstep(i32 noundef %50) #7
  br label %135

91:                                               ; preds = %49
  %92 = load i32, ptr @lo, align 4, !tbaa !3
  %93 = load i32, ptr @q, align 4, !tbaa !3
  %94 = and i32 %1, 1
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %102, label %96

96:                                               ; preds = %91
  %97 = icmp ugt i32 %93, 1
  br i1 %97, label %98, label %123

98:                                               ; preds = %96
  %99 = shl nuw nsw i32 %93, 2
  %100 = add nsw i32 %99, %92
  %101 = lshr i32 %93, 1
  br label %123

102:                                              ; preds = %91
  %103 = and i32 %1, 2
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %111, label %105

105:                                              ; preds = %102
  %106 = icmp ult i32 %93, 16
  br i1 %106, label %107, label %123

107:                                              ; preds = %105
  %108 = shl nuw nsw i32 %93, 3
  %109 = sub nsw i32 %92, %108
  %110 = shl nuw nsw i32 %93, 1
  br label %123

111:                                              ; preds = %102
  %112 = and i32 %1, 4
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %117, label %114

114:                                              ; preds = %111
  %115 = shl nuw nsw i32 %93, 2
  %116 = sub nsw i32 %92, %115
  br label %123

117:                                              ; preds = %111
  %118 = and i32 %1, 8
  %119 = icmp eq i32 %118, 0
  br i1 %119, label %135, label %120

120:                                              ; preds = %117
  %121 = shl nuw nsw i32 %93, 2
  %122 = add nsw i32 %121, %92
  br label %123

123:                                              ; preds = %107, %105, %120, %114, %96, %98
  %124 = phi i32 [ %100, %98 ], [ %92, %96 ], [ %109, %107 ], [ %92, %105 ], [ %116, %114 ], [ %122, %120 ]
  %125 = phi i32 [ %101, %98 ], [ %93, %96 ], [ %110, %107 ], [ %93, %105 ], [ %93, %114 ], [ %93, %120 ]
  %126 = shl nuw nsw i32 %125, 4
  %127 = sub nsw i32 256, %126
  %128 = icmp slt i32 %124, 0
  %129 = tail call i32 @llvm.smin.i32(i32 %124, i32 %127)
  %130 = select i1 %128, i32 0, i32 %129
  %131 = icmp eq i32 %130, %92
  %132 = icmp eq i32 %125, %93
  %133 = select i1 %131, i1 %132, i1 false
  br i1 %133, label %135, label %134

134:                                              ; preds = %123
  store i32 %130, ptr @lo, align 4, !tbaa !3
  store i32 %125, ptr @q, align 4, !tbaa !3
  tail call fastcc void @redraw() #7
  tail call void @uputs(ptr noundef nonnull @.str.4) #6
  tail call void @uputs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @hdr, i32 20)) #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  br label %135

135:                                              ; preds = %18, %19, %89, %85, %80, %72, %63, %90, %53, %134, %123, %117, %45, %44
  %136 = phi i32 [ 0, %44 ], [ 0, %45 ], [ 0, %117 ], [ 0, %123 ], [ 0, %134 ], [ 0, %53 ], [ 0, %90 ], [ 0, %63 ], [ 0, %72 ], [ 0, %80 ], [ 0, %85 ], [ 0, %89 ], [ 1, %18 ], [ 0, %19 ]
  ret i32 %136
}

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @kcurve(i32 noundef range(i32 0, -3) %0) unnamed_addr #3 {
  %2 = load i32, ptr @kk, align 4, !tbaa !3
  %3 = sub i32 255, %0
  %4 = mul i32 %0, 4112
  %5 = mul i32 %4, %3
  %6 = mul i32 %5, %2
  %7 = lshr i32 %6, 24
  %8 = sub i32 %0, %7
  ret i32 %8
}

; Function Attrs: minsize optsize
declare dso_local i32 @gfx_dither(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_dfill(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numsp(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc void @gomode(i32 noundef range(i32 0, 3) %0) unnamed_addr #2 {
  %2 = icmp eq i32 %0, 2
  br i1 %2, label %3, label %6

3:                                                ; preds = %1
  %4 = load i32, ptr @lo, align 4, !tbaa !3
  store i32 %4, ptr @klo, align 4, !tbaa !3
  %5 = load i32, ptr @q, align 4, !tbaa !3
  store i32 %5, ptr @kqs, align 4, !tbaa !3
  store i32 0, ptr @lo, align 4, !tbaa !3
  store i32 16, ptr @q, align 4, !tbaa !3
  br label %12

6:                                                ; preds = %1
  %7 = load i8, ptr @mode, align 1, !tbaa !7
  %8 = icmp eq i8 %7, 2
  br i1 %8, label %9, label %12

9:                                                ; preds = %6
  %10 = load i32, ptr @klo, align 4, !tbaa !3
  store i32 %10, ptr @lo, align 4, !tbaa !3
  %11 = load i32, ptr @kqs, align 4, !tbaa !3
  store i32 %11, ptr @q, align 4, !tbaa !3
  store i32 0, ptr @kk, align 4, !tbaa !3
  br label %12

12:                                               ; preds = %6, %9, %3
  %13 = trunc nuw nsw i32 %0 to i8
  store i8 %13, ptr @mode, align 1, !tbaa !7
  tail call void @gfx_clear(i16 noundef zeroext 0) #6
  %14 = icmp eq i32 %0, 1
  br i1 %14, label %15, label %24

15:                                               ; preds = %12
  store i8 0, ptr @mchan, align 1, !tbaa !7
  %16 = load i8, ptr @mn, align 1, !tbaa !7
  %17 = icmp ugt i8 %16, 31
  br i1 %17, label %18, label %19

18:                                               ; preds = %15
  store i8 31, ptr @mn, align 1, !tbaa !7
  br label %19

19:                                               ; preds = %18, %15
  %20 = load i8, ptr @mm, align 1, !tbaa !7
  %21 = icmp ugt i8 %20, 31
  br i1 %21, label %22, label %23

22:                                               ; preds = %19
  store i8 31, ptr @mm, align 1, !tbaa !7
  br label %23

23:                                               ; preds = %22, %19
  tail call fastcc void @mredraw() #7
  tail call void @uputs(ptr noundef nonnull @.str.2) #6
  tail call void @uputs(ptr noundef nonnull @mhdr) #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  br label %28

24:                                               ; preds = %12
  tail call fastcc void @redraw() #7
  %25 = icmp eq i32 %0, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %24
  tail call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %28

27:                                               ; preds = %24
  tail call fastcc void @kecho() #7
  br label %28

28:                                               ; preds = %27, %26, %23
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @mredraw() unnamed_addr #0 {
  %1 = tail call fastcc zeroext i16 @mcolor(i32 noundef 0) #7
  %2 = load i8, ptr @mn, align 1, !tbaa !7
  %3 = zext i8 %2 to i32
  %4 = tail call fastcc zeroext i16 @mcolor(i32 noundef %3) #7
  %5 = load i8, ptr @mm, align 1, !tbaa !7
  %6 = zext i8 %5 to i32
  %7 = tail call fastcc zeroext i16 @mcolor(i32 noundef %6) #7
  tail call void @gfx_fill(i32 noundef 120, i32 noundef 16, i32 noundef 120, i32 noundef 224, i16 noundef zeroext %7) #6
  tail call fastcc void @mrows(i32 noundef 16, i16 noundef zeroext %1, i16 noundef zeroext %4) #7
  tail call fastcc void @mrows(i32 noundef 17, i16 noundef zeroext %4, i16 noundef zeroext %1) #7
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 16, i32 noundef 119, i32 noundef 239) #6
  %8 = load i8, ptr @mchan, align 1, !tbaa !7
  %9 = zext i8 %8 to i32
  %10 = getelementptr inbounds nuw [5 x i8], ptr @mchn, i32 0, i32 %9
  %11 = load i8, ptr %10, align 1, !tbaa !7
  store i8 %11, ptr @mhdr, align 1, !tbaa !7
  %12 = load i8, ptr @mn, align 1, !tbaa !7
  %13 = zext i8 %12 to i32
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @mhdr, i32 5), i32 noundef 2, i32 noundef %13) #6
  store i8 32, ptr getelementptr inbounds nuw (i8, ptr @mhdr, i32 7), align 1, !tbaa !7
  %14 = load i8, ptr @mm, align 1, !tbaa !7
  %15 = zext i8 %14 to i32
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @mhdr, i32 11), i32 noundef 2, i32 noundef %15) #6
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
  tail call void @numstr(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @mhdr, i32 22), i32 noundef 3, i32 noundef %26) #6
  tail call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull @mhdr, i16 noundef zeroext -16870, i16 noundef zeroext 0) #6
  tail call void @gfx_present() #6
  ret void
}

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc void @kstep(i32 noundef range(i32 1, 16) %0) unnamed_addr #2 {
  %2 = and i32 %0, 1
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %9, label %4

4:                                                ; preds = %1
  %5 = load i32, ptr @kk, align 4, !tbaa !3
  %6 = icmp ugt i32 %5, 15
  br i1 %6, label %19, label %7

7:                                                ; preds = %4
  %8 = add nuw nsw i32 %5, 1
  br label %17

9:                                                ; preds = %1
  %10 = and i32 %0, 2
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %19, label %12

12:                                               ; preds = %9
  %13 = load i32, ptr @kk, align 4, !tbaa !3
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %19, label %15

15:                                               ; preds = %12
  %16 = add nsw i32 %13, -1
  br label %17

17:                                               ; preds = %15, %7
  %18 = phi i32 [ %16, %15 ], [ %8, %7 ]
  store i32 %18, ptr @kk, align 4, !tbaa !3
  tail call fastcc void @redraw() #7
  tail call fastcc void @kecho() #7
  br label %19

19:                                               ; preds = %9, %12, %4, %17
  ret void
}

; Function Attrs: minsize noinline nounwind optsize
define internal fastcc void @kecho() unnamed_addr #2 {
  tail call void @uputs(ptr noundef nonnull @.str.6) #6
  tail call void @uputs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @khdr, i32 21)) #6
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc zeroext i16 @mcolor(i32 noundef range(i32 0, 256) %0) unnamed_addr #4 {
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

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

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
  tail call void @gdma_rows(i32 noundef %10, i32 noundef ptrtoint (ptr @mword to i32), i32 noundef 60, i32 noundef 112, i32 noundef 960, i32 noundef 0) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize noinline nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { minsize nobuiltin optsize "no-builtins" }

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
