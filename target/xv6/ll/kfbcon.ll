; ModuleID = 'dma/kfbcon.c'
source_filename = "dma/kfbcon.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fcx = internal unnamed_addr global i32 0, align 4
@ffg = internal unnamed_addr global i32 0, align 4
@fbg = internal unnamed_addr global i32 0, align 4
@fstate = internal unnamed_addr global i32 0, align 4
@fcursor = internal unnamed_addr global i1 false, align 4
@fnpar = internal unnamed_addr global i32 0, align 4
@fpriv = internal unnamed_addr global i1 false, align 4
@fpar = internal unnamed_addr global [4 x i32] zeroinitializer, align 4
@fcy = internal unnamed_addr global i32 0, align 4
@fb_base = external dso_local local_unnamed_addr global i32, align 4
@frowa = internal unnamed_addr global i32 0, align 4
@fbpal = internal unnamed_addr constant [16 x i8] c"\00\80\10\90\02\82\12\DB\92\E0\1C\FC\03\E3\1F\FF", align 1
@nibmask = internal unnamed_addr constant [16 x i32] [i32 0, i32 -16777216, i32 16711680, i32 -65536, i32 65280, i32 -16711936, i32 16776960, i32 -256, i32 255, i32 -16776961, i32 16711935, i32 -65281, i32 65535, i32 -16711681, i32 16777215, i32 -1], align 4
@flut16 = internal unnamed_addr global [16 x i32] zeroinitializer, align 4
@fluthi = internal unnamed_addr global [256 x i32] zeroinitializer, align 4
@flutlo = internal unnamed_addr global [256 x i32] zeroinitializer, align 4
@fbfont = internal unnamed_addr constant [1024 x i8] c"\00\00\00\00\00\00\00\00<B\A5\81\A5\99B<<~\DB\FF\FF\DBf<l\FE\FE\FE|8\10\00\108|\FE|8\10\00\108T\FET\108\00\108|\FE\FE\108\00\00\00\0000\00\00\00\FF\FF\FF\E7\E7\FF\FF\FF8D\82\82\82D8\00\C7\BB}}}\BB\C7\FF\0F\03\05y\88\88\88p8DDD8\10|\100($$( \E0\C0<$<$$\E4\DC\18\10T8\EE8T\10\00\80\C0\E0\F0\E0\C0\80\00\01\03\07\0F\07\03\01\00\10\10\10|\10\10\10\10\FCHHH\E8\08P |\A8\A8h(((\008@0HH0\08p\00\00\00<<\00\00\00  p p  \00\FF\FF\00\00\00\00\00\00\00\00\00\00\00\00\FF\FF\03\03\03\03\03\03\03\03\C0\C0\C0\C0\C0\C0\C0\C0\00\10\10\FF\10\10\00\00\00 P\88P \00\00\00\00\00\00\108|\FE\FE|8\10\00\00\00\00\00\00\00\00\00\00\00\00    \00\00 \00PPP\00\00\00\00\00PP\F8P\F8PP\00 x\A0p(\F0 \00\C0\C8\10 @\98\18\00@\A0@\A8\90\98`\00\10 @\00\00\00\00\00\10 @@@ \10\00@ \10\10\10 @\00 \A8p p\A8 \00\00  \F8  \00\00\00\00\00\00\00  @\00\00\00x\00\00\00\00\00\00\00\00\00``\00\00\00\08\10 @\80\00p\88\98\A8\C8\88p\00 `\A0   \F8\00p\88\08\10`\80\F8\00p\88\080\08\88p\00\100P\90\F8\10\10\00\F8\80\E0\10\08\10\E0\000@\80\F0\88\88p\00\F8\88\10    \00p\88\88p\88\88p\00p\88\88x\08\10`\00\00\00 \00\00 \00\00\00\00 \00\00  @\00\10 @ \10\00\00\00\00\F8\00\F8\00\00\00\00@ \10 @\00\00p\88\08\10 \00 \00\00p\A8\A8\B0\80p\00 P\88\88\F8\88\88\00\F0HHpHH\F0\000H\80\80\80H0\00\E0PHHHP\E0\00\F8\80\80\F0\80\80\F8\00\F8\80\80\F0\80\80\80\00p\88\80\B8\88\88p\00\88\88\88\F8\88\88\88\00p     p\008\10\10\10\90\90`\00\88\90\A0\C0\A0\90\88\00\80\80\80\80\80\80\F8\00\88\D8\A8\A8\88\88\88\00\88\C8\C8\A8\98\98\88\00p\88\88\88\88\88p\00\F0\88\88\F0\80\80\80\00p\88\88\88\A8\90h\00\F0\88\88\F0\A0\90\88\00p\88\80p\08\88p\00\F8      \00\88\88\88\88\88\88p\00\88\88\88\88PP \00\88\88\88\A8\A8\D8\88\00\88\88P P\88\88\00\88\88\88p   \00\F8\08\10 @\80\F8\00p@@@@@p\00\00\00\80@ \10\08\00p\10\10\10\10\10p\00 P\88\00\00\00\00\00\00\00\00\00\00\00\F8\00@ \10\00\00\00\00\00\00\00p\08x\88x\00\80\80\B0\C8\88\C8\B0\00\00\00p\88\80\88p\00\08\08h\98\88\98h\00\00\00p\88\F8\80p\00\10( \F8   \00\00\00h\98\98h\08p\80\80\F0\88\88\88\88\00 \00`   p\00\10\000\10\10\10\90`@@HP`PH\00`     p\00\00\00\D0\A8\A8\A8\A8\00\00\00\B0\C8\88\88\88\00\00\00p\88\88\88p\00\00\00\B0\C8\C8\B0\80\80\00\00h\98\98h\08\08\00\00\B0\C8\80\80\80\00\00\00x\80\F0\08\F0\00@@\F0@@H0\00\00\00\90\90\90\90h\00\00\00\88\88\88P \00\00\00\88\A8\A8\A8P\00\00\00\88P P\88\00\00\00\88\88\98h\08p\00\00\F8\10 @\F8\00\18  @  \18\00   \00   \00\C0  \10  \C0\00@\A8\10\00\00\00\00\00\00\00 P\F8\00\00\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @kfbcon_reset() local_unnamed_addr #0 {
  %1 = tail call i32 @kfb_active() #6
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %5, label %3

3:                                                ; preds = %0
  store i32 0, ptr @fcx, align 4, !tbaa !3
  store i32 0, ptr @fcy, align 4, !tbaa !3
  %4 = load i32, ptr @fb_base, align 4, !tbaa !3
  store i32 %4, ptr @frowa, align 4, !tbaa !3
  store i32 7, ptr @ffg, align 4, !tbaa !3
  store i32 0, ptr @fbg, align 4, !tbaa !3
  store i32 0, ptr @fstate, align 4, !tbaa !3
  store i1 false, ptr @fcursor, align 4
  tail call fastcc void @lut_build() #7
  tail call fastcc void @clear_screen() #7
  br label %5

5:                                                ; preds = %0, %3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_active() local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @lut_build() unnamed_addr #2 {
  %1 = load i32, ptr @ffg, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [16 x i8], ptr @fbpal, i32 0, i32 %1
  %3 = load i8, ptr %2, align 1, !tbaa !7
  %4 = zext i8 %3 to i32
  %5 = mul nuw i32 %4, 16843009
  %6 = load i32, ptr @fbg, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw [16 x i8], ptr @fbpal, i32 0, i32 %6
  %8 = load i8, ptr %7, align 1, !tbaa !7
  %9 = zext i8 %8 to i32
  %10 = mul nuw i32 %9, 16843009
  br label %11

11:                                               ; preds = %14, %0
  %12 = phi i32 [ 0, %0 ], [ %22, %14 ]
  %13 = icmp eq i32 %12, 16
  br i1 %13, label %23, label %14

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw [16 x i32], ptr @nibmask, i32 0, i32 %12
  %16 = load i32, ptr %15, align 4, !tbaa !3
  %17 = and i32 %16, %5
  %18 = xor i32 %16, -1
  %19 = and i32 %10, %18
  %20 = or i32 %17, %19
  %21 = getelementptr inbounds nuw [16 x i32], ptr @flut16, i32 0, i32 %12
  store i32 %20, ptr %21, align 4, !tbaa !3
  %22 = add nuw nsw i32 %12, 1
  br label %11, !llvm.loop !8

23:                                               ; preds = %11, %35
  %24 = phi i32 [ %32, %35 ], [ 0, %11 ]
  %25 = phi i32 [ %36, %35 ], [ 0, %11 ]
  %26 = icmp eq i32 %25, 16
  br i1 %26, label %27, label %28

27:                                               ; preds = %23
  ret void

28:                                               ; preds = %23
  %29 = getelementptr inbounds nuw [16 x i32], ptr @flut16, i32 0, i32 %25
  %30 = load i32, ptr %29, align 4, !tbaa !3
  br label %31

31:                                               ; preds = %37, %28
  %32 = phi i32 [ %24, %28 ], [ %42, %37 ]
  %33 = phi i32 [ 0, %28 ], [ %43, %37 ]
  %34 = icmp eq i32 %33, 16
  br i1 %34, label %35, label %37

35:                                               ; preds = %31
  %36 = add nuw nsw i32 %25, 1
  br label %23, !llvm.loop !11

37:                                               ; preds = %31
  %38 = getelementptr inbounds nuw [256 x i32], ptr @fluthi, i32 0, i32 %32
  store i32 %30, ptr %38, align 4, !tbaa !3
  %39 = getelementptr inbounds nuw [16 x i32], ptr @flut16, i32 0, i32 %33
  %40 = load i32, ptr %39, align 4, !tbaa !3
  %41 = getelementptr inbounds nuw [256 x i32], ptr @flutlo, i32 0, i32 %32
  store i32 %40, ptr %41, align 4, !tbaa !3
  %42 = add i32 %32, 1
  %43 = add nuw nsw i32 %33, 1
  br label %31, !llvm.loop !12
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @clear_screen() unnamed_addr #0 {
  %1 = load i32, ptr @fb_base, align 4, !tbaa !3
  %2 = tail call fastcc i32 @bg_word() #7
  tail call void @kdmaset(i32 noundef %1, i32 noundef %2, i32 noundef 307200) #6
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kfbcon_putc(i32 noundef %0) local_unnamed_addr #0 {
  %2 = tail call i32 @kfb_condark() #6
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %226

4:                                                ; preds = %1
  %5 = and i32 %0, 255
  %6 = load i32, ptr @fstate, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %170, label %8

8:                                                ; preds = %4
  %9 = load i1, ptr @fcursor, align 4
  br i1 %9, label %10, label %11

10:                                               ; preds = %8
  tail call fastcc void @cursor_xor() #7
  br label %11

11:                                               ; preds = %10, %8
  %12 = icmp eq i32 %6, 1
  br i1 %12, label %13, label %17

13:                                               ; preds = %11
  %14 = icmp eq i32 %5, 91
  br i1 %14, label %15, label %16

15:                                               ; preds = %13
  store i32 2, ptr @fstate, align 4, !tbaa !3
  store i32 0, ptr @fnpar, align 4, !tbaa !3
  store i1 false, ptr @fpriv, align 4
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 12), align 4, !tbaa !3
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 8), align 4, !tbaa !3
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 4), align 4, !tbaa !3
  store i32 0, ptr @fpar, align 4, !tbaa !3
  br label %225

16:                                               ; preds = %13
  store i32 0, ptr @fstate, align 4, !tbaa !3
  br label %225

17:                                               ; preds = %11
  %18 = add nsw i32 %5, -48
  %19 = icmp ult i32 %18, 10
  br i1 %19, label %20, label %31

20:                                               ; preds = %17
  %21 = load i32, ptr @fnpar, align 4, !tbaa !3
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  store i32 1, ptr @fnpar, align 4, !tbaa !3
  br label %24

24:                                               ; preds = %23, %20
  %25 = phi i32 [ 1, %23 ], [ %21, %20 ]
  %26 = add nsw i32 %25, -1
  %27 = getelementptr inbounds [4 x i32], ptr @fpar, i32 0, i32 %26
  %28 = load i32, ptr %27, align 4, !tbaa !3
  %29 = mul nsw i32 %28, 10
  %30 = add nsw i32 %29, %18
  store i32 %30, ptr %27, align 4, !tbaa !3
  br label %225

31:                                               ; preds = %17
  %32 = trunc i32 %0 to i8
  switch i8 %32, label %41 [
    i8 59, label %33
    i8 63, label %40
  ]

33:                                               ; preds = %31
  %34 = load i32, ptr @fnpar, align 4, !tbaa !3
  %35 = icmp slt i32 %34, 4
  br i1 %35, label %36, label %225

36:                                               ; preds = %33
  %37 = add nuw nsw i32 %34, 1
  %38 = icmp eq i32 %34, 0
  %39 = select i1 %38, i32 2, i32 %37
  store i32 %39, ptr @fnpar, align 4
  br label %225

40:                                               ; preds = %31
  store i1 true, ptr @fpriv, align 4
  br label %225

41:                                               ; preds = %31
  store i32 0, ptr @fstate, align 4, !tbaa !3
  %42 = load i32, ptr @fpar, align 4, !tbaa !3
  %43 = tail call i32 @llvm.umax.i32(i32 %42, i32 1)
  %44 = load i1, ptr @fpriv, align 4
  br i1 %44, label %45, label %50

45:                                               ; preds = %41
  %46 = icmp eq i32 %42, 1049
  br i1 %46, label %47, label %225

47:                                               ; preds = %45
  switch i8 %32, label %225 [
    i8 104, label %48
    i8 108, label %48
  ]

48:                                               ; preds = %47, %47
  tail call fastcc void @clear_screen() #7
  store i32 0, ptr @fcx, align 4, !tbaa !3
  store i32 0, ptr @fcy, align 4, !tbaa !3
  %49 = load i32, ptr @fb_base, align 4, !tbaa !3
  store i32 %49, ptr @frowa, align 4, !tbaa !3
  br label %225

50:                                               ; preds = %41
  switch i8 %32, label %225 [
    i8 65, label %51
    i8 66, label %58
    i8 67, label %65
    i8 68, label %69
    i8 72, label %73
    i8 102, label %73
    i8 74, label %89
    i8 75, label %110
    i8 109, label %121
  ]

51:                                               ; preds = %50
  %52 = load i32, ptr @fcy, align 4, !tbaa !3
  %53 = sub nsw i32 %52, %43
  %54 = tail call i32 @llvm.smax.i32(i32 %53, i32 0)
  store i32 %54, ptr @fcy, align 4, !tbaa !3
  %55 = load i32, ptr @fb_base, align 4, !tbaa !3
  %56 = mul i32 %54, 10240
  %57 = add i32 %56, %55
  store i32 %57, ptr @frowa, align 4, !tbaa !3
  br label %225

58:                                               ; preds = %50
  %59 = load i32, ptr @fcy, align 4, !tbaa !3
  %60 = add nsw i32 %59, %43
  %61 = tail call i32 @llvm.smin.i32(i32 %60, i32 29)
  store i32 %61, ptr @fcy, align 4, !tbaa !3
  %62 = load i32, ptr @fb_base, align 4, !tbaa !3
  %63 = mul i32 %61, 10240
  %64 = add i32 %63, %62
  store i32 %64, ptr @frowa, align 4, !tbaa !3
  br label %225

65:                                               ; preds = %50
  %66 = load i32, ptr @fcx, align 4, !tbaa !3
  %67 = add nsw i32 %66, %43
  %68 = tail call i32 @llvm.smin.i32(i32 %67, i32 79)
  store i32 %68, ptr @fcx, align 4
  br label %225

69:                                               ; preds = %50
  %70 = load i32, ptr @fcx, align 4, !tbaa !3
  %71 = sub nsw i32 %70, %43
  %72 = tail call i32 @llvm.smax.i32(i32 %71, i32 0)
  store i32 %72, ptr @fcx, align 4
  br label %225

73:                                               ; preds = %50, %50
  %74 = tail call i32 @llvm.usub.sat.i32(i32 %42, i32 1)
  %75 = load i32, ptr @fnpar, align 4, !tbaa !3
  %76 = icmp sgt i32 %75, 1
  %77 = load i32, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 4), align 4
  %78 = icmp ne i32 %77, 0
  %79 = select i1 %76, i1 %78, i1 false
  %80 = tail call i32 @llvm.smax.i32(i32 %74, i32 0)
  %81 = tail call i32 @llvm.umin.i32(i32 %80, i32 29)
  store i32 %81, ptr @fcy, align 4, !tbaa !3
  %82 = load i32, ptr @fb_base, align 4, !tbaa !3
  %83 = mul nuw nsw i32 %81, 10240
  %84 = add i32 %82, %83
  store i32 %84, ptr @frowa, align 4, !tbaa !3
  %85 = tail call i32 @llvm.smax.i32(i32 %77, i32 1)
  %86 = tail call i32 @llvm.umin.i32(i32 %85, i32 80)
  %87 = add nsw i32 %86, -1
  %88 = select i1 %79, i32 %87, i32 0
  store i32 %88, ptr @fcx, align 4, !tbaa !3
  br label %225

89:                                               ; preds = %50
  switch i32 %42, label %100 [
    i32 2, label %90
    i32 1, label %91
  ]

90:                                               ; preds = %89
  tail call fastcc void @clear_screen() #7
  br label %225

91:                                               ; preds = %89, %98
  %92 = phi i32 [ %99, %98 ], [ 0, %89 ]
  %93 = load i32, ptr @fcy, align 4, !tbaa !3
  %94 = icmp slt i32 %92, %93
  br i1 %94, label %98, label %95

95:                                               ; preds = %91
  %96 = load i32, ptr @fcx, align 4, !tbaa !3
  %97 = add nsw i32 %96, 1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %93, i32 noundef %97) #7
  br label %225

98:                                               ; preds = %91
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %92, i32 noundef 80) #7
  %99 = add nuw nsw i32 %92, 1
  br label %91, !llvm.loop !13

100:                                              ; preds = %89
  %101 = load i32, ptr @fcx, align 4, !tbaa !3
  %102 = load i32, ptr @fcy, align 4, !tbaa !3
  %103 = sub nsw i32 80, %101
  tail call fastcc void @clear_cells(i32 noundef %101, i32 noundef %102, i32 noundef %103) #7
  %104 = load i32, ptr @fcy, align 4, !tbaa !3
  br label %105

105:                                              ; preds = %108, %100
  %106 = phi i32 [ %104, %100 ], [ %109, %108 ]
  %107 = icmp slt i32 %106, 29
  br i1 %107, label %108, label %225

108:                                              ; preds = %105
  %109 = add nsw i32 %106, 1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %109, i32 noundef 80) #7
  br label %105, !llvm.loop !14

110:                                              ; preds = %50
  switch i32 %42, label %117 [
    i32 2, label %111
    i32 1, label %113
  ]

111:                                              ; preds = %110
  %112 = load i32, ptr @fcy, align 4, !tbaa !3
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %112, i32 noundef 80) #7
  br label %225

113:                                              ; preds = %110
  %114 = load i32, ptr @fcy, align 4, !tbaa !3
  %115 = load i32, ptr @fcx, align 4, !tbaa !3
  %116 = add nsw i32 %115, 1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %114, i32 noundef %116) #7
  br label %225

117:                                              ; preds = %110
  %118 = load i32, ptr @fcx, align 4, !tbaa !3
  %119 = load i32, ptr @fcy, align 4, !tbaa !3
  %120 = sub nsw i32 80, %118
  tail call fastcc void @clear_cells(i32 noundef %118, i32 noundef %119, i32 noundef %120) #7
  br label %225

121:                                              ; preds = %50
  %122 = load i32, ptr @fnpar, align 4, !tbaa !3
  %123 = icmp eq i32 %122, 0
  br i1 %123, label %124, label %125

124:                                              ; preds = %121
  store i32 1, ptr @fnpar, align 4, !tbaa !3
  store i32 0, ptr @fpar, align 4, !tbaa !3
  br label %125

125:                                              ; preds = %124, %121
  %126 = phi i32 [ 1, %124 ], [ %122, %121 ]
  %127 = load i32, ptr @ffg, align 4
  %128 = load i32, ptr @fbg, align 4
  br label %129

129:                                              ; preds = %165, %125
  %130 = phi i32 [ %128, %125 ], [ %166, %165 ]
  %131 = phi i32 [ %127, %125 ], [ %167, %165 ]
  %132 = phi i32 [ 0, %125 ], [ %168, %165 ]
  %133 = icmp slt i32 %132, %126
  br i1 %133, label %134, label %169

134:                                              ; preds = %129
  %135 = getelementptr inbounds nuw [4 x i32], ptr @fpar, i32 0, i32 %132
  %136 = load i32, ptr %135, align 4, !tbaa !3
  switch i32 %136, label %141 [
    i32 0, label %137
    i32 1, label %138
    i32 7, label %140
  ]

137:                                              ; preds = %134
  store i32 7, ptr @ffg, align 4, !tbaa !3
  store i32 0, ptr @fbg, align 4, !tbaa !3
  br label %165

138:                                              ; preds = %134
  %139 = or i32 %131, 8
  store i32 %139, ptr @ffg, align 4, !tbaa !3
  br label %165

140:                                              ; preds = %134
  store i32 %130, ptr @ffg, align 4, !tbaa !3
  store i32 %131, ptr @fbg, align 4, !tbaa !3
  br label %165

141:                                              ; preds = %134
  %142 = add i32 %136, -30
  %143 = icmp ult i32 %142, 8
  br i1 %143, label %144, label %147

144:                                              ; preds = %141
  %145 = and i32 %131, 8
  %146 = or disjoint i32 %142, %145
  store i32 %146, ptr @ffg, align 4, !tbaa !3
  br label %165

147:                                              ; preds = %141
  %148 = and i32 %136, -8
  %149 = icmp eq i32 %148, 40
  br i1 %149, label %150, label %152

150:                                              ; preds = %147
  %151 = add nsw i32 %136, -40
  store i32 %151, ptr @fbg, align 4, !tbaa !3
  br label %165

152:                                              ; preds = %147
  %153 = add i32 %136, -90
  %154 = icmp ult i32 %153, 8
  br i1 %154, label %155, label %157

155:                                              ; preds = %152
  %156 = add nsw i32 %136, -82
  store i32 %156, ptr @ffg, align 4, !tbaa !3
  br label %165

157:                                              ; preds = %152
  %158 = add i32 %136, -100
  %159 = icmp ult i32 %158, 8
  br i1 %159, label %160, label %162

160:                                              ; preds = %157
  %161 = add nsw i32 %136, -92
  store i32 %161, ptr @fbg, align 4, !tbaa !3
  br label %165

162:                                              ; preds = %157
  switch i32 %136, label %165 [
    i32 39, label %163
    i32 49, label %164
  ]

163:                                              ; preds = %162
  store i32 7, ptr @ffg, align 4, !tbaa !3
  br label %165

164:                                              ; preds = %162
  store i32 0, ptr @fbg, align 4, !tbaa !3
  br label %165

165:                                              ; preds = %164, %163, %162, %160, %155, %150, %144, %140, %138, %137
  %166 = phi i32 [ %130, %162 ], [ %130, %138 ], [ %130, %144 ], [ %130, %155 ], [ %130, %163 ], [ 0, %164 ], [ %161, %160 ], [ %151, %150 ], [ %131, %140 ], [ 0, %137 ]
  %167 = phi i32 [ %131, %162 ], [ %139, %138 ], [ %146, %144 ], [ %156, %155 ], [ 7, %163 ], [ %131, %164 ], [ %131, %160 ], [ %131, %150 ], [ %130, %140 ], [ 7, %137 ]
  %168 = add nuw nsw i32 %132, 1
  br label %129, !llvm.loop !15

169:                                              ; preds = %129
  tail call fastcc void @lut_build() #7
  br label %225

170:                                              ; preds = %4
  %171 = add nsw i32 %5, -32
  %172 = icmp ult i32 %171, 95
  br i1 %172, label %173, label %207

173:                                              ; preds = %170
  %174 = shl nuw nsw i32 %5, 3
  %175 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %174
  %176 = load i32, ptr @frowa, align 4, !tbaa !3
  %177 = load i32, ptr @fcx, align 4, !tbaa !3
  %178 = shl i32 %177, 3
  %179 = add i32 %178, %176
  br label %180

180:                                              ; preds = %185, %173
  %181 = phi i32 [ 8, %173 ], [ %201, %185 ]
  %182 = phi i32 [ %179, %173 ], [ %200, %185 ]
  %183 = phi ptr [ %175, %173 ], [ %186, %185 ]
  %184 = icmp eq i32 %181, 0
  br i1 %184, label %202, label %185

185:                                              ; preds = %180
  %186 = getelementptr inbounds nuw i8, ptr %183, i32 1
  %187 = load i8, ptr %183, align 1, !tbaa !7
  %188 = zext i8 %187 to i32
  %189 = getelementptr inbounds nuw [256 x i32], ptr @fluthi, i32 0, i32 %188
  %190 = load i32, ptr %189, align 4, !tbaa !3
  %191 = getelementptr inbounds nuw [256 x i32], ptr @flutlo, i32 0, i32 %188
  %192 = load i32, ptr %191, align 4, !tbaa !3
  %193 = inttoptr i32 %182 to ptr
  store volatile i32 %190, ptr %193, align 4, !tbaa !3
  %194 = add i32 %182, 4
  %195 = inttoptr i32 %194 to ptr
  store volatile i32 %192, ptr %195, align 4, !tbaa !3
  %196 = add i32 %182, 640
  %197 = inttoptr i32 %196 to ptr
  store volatile i32 %190, ptr %197, align 4, !tbaa !3
  %198 = add i32 %182, 644
  %199 = inttoptr i32 %198 to ptr
  store volatile i32 %192, ptr %199, align 4, !tbaa !3
  %200 = add i32 %182, 1280
  %201 = add nsw i32 %181, -1
  br label %180, !llvm.loop !16

202:                                              ; preds = %180
  %203 = load i32, ptr @fcx, align 4, !tbaa !3
  %204 = add nsw i32 %203, 1
  store i32 %204, ptr @fcx, align 4, !tbaa !3
  %205 = icmp sgt i32 %203, 78
  br i1 %205, label %206, label %225

206:                                              ; preds = %202
  tail call fastcc void @newline() #7
  br label %225

207:                                              ; preds = %170
  %208 = load i1, ptr @fcursor, align 4
  br i1 %208, label %209, label %210

209:                                              ; preds = %207
  tail call fastcc void @cursor_xor() #7
  br label %210

210:                                              ; preds = %209, %207
  %211 = trunc i32 %0 to i8
  switch i8 %211, label %225 [
    i8 10, label %212
    i8 27, label %213
    i8 13, label %214
    i8 8, label %215
    i8 9, label %220
  ]

212:                                              ; preds = %210
  tail call fastcc void @newline() #7
  br label %225

213:                                              ; preds = %210
  store i32 1, ptr @fstate, align 4, !tbaa !3
  br label %225

214:                                              ; preds = %210
  store i32 0, ptr @fcx, align 4, !tbaa !3
  br label %225

215:                                              ; preds = %210
  %216 = load i32, ptr @fcx, align 4, !tbaa !3
  %217 = icmp sgt i32 %216, 0
  br i1 %217, label %218, label %225

218:                                              ; preds = %215
  %219 = add nsw i32 %216, -1
  store i32 %219, ptr @fcx, align 4, !tbaa !3
  br label %225

220:                                              ; preds = %210
  %221 = load i32, ptr @fcx, align 4, !tbaa !3
  %222 = and i32 %221, -8
  %223 = tail call i32 @llvm.smin.i32(i32 %222, i32 71)
  %224 = add nsw i32 %223, 8
  store i32 %224, ptr @fcx, align 4
  br label %225

225:                                              ; preds = %105, %169, %117, %113, %111, %95, %90, %73, %69, %65, %58, %51, %50, %48, %47, %45, %40, %36, %33, %24, %210, %206, %202, %213, %218, %215, %220, %214, %212, %16, %15
  tail call fastcc void @cursor_xor() #7
  store i1 true, ptr @fcursor, align 4
  br label %226

226:                                              ; preds = %1, %225
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_condark() local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @cursor_xor() unnamed_addr #3 {
  %1 = load i32, ptr @frowa, align 4, !tbaa !3
  %2 = load i32, ptr @fcx, align 4, !tbaa !3
  %3 = shl i32 %2, 3
  %4 = add i32 %1, 7680
  %5 = add i32 %4, %3
  br label %6

6:                                                ; preds = %11, %0
  %7 = phi i32 [ %5, %0 ], [ %19, %11 ]
  %8 = phi i32 [ 4, %0 ], [ %20, %11 ]
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %6
  ret void

11:                                               ; preds = %6
  %12 = inttoptr i32 %7 to ptr
  %13 = load volatile i32, ptr %12, align 4, !tbaa !3
  %14 = xor i32 %13, -1
  store volatile i32 %14, ptr %12, align 4, !tbaa !3
  %15 = add i32 %7, 4
  %16 = inttoptr i32 %15 to ptr
  %17 = load volatile i32, ptr %16, align 4, !tbaa !3
  %18 = xor i32 %17, -1
  store volatile i32 %18, ptr %16, align 4, !tbaa !3
  %19 = add i32 %7, 640
  %20 = add nsw i32 %8, -1
  br label %6, !llvm.loop !17
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @newline() unnamed_addr #0 {
  store i32 0, ptr @fcx, align 4, !tbaa !3
  %1 = load i32, ptr @fcy, align 4, !tbaa !3
  %2 = icmp slt i32 %1, 29
  br i1 %2, label %3, label %8

3:                                                ; preds = %0
  %4 = add nsw i32 %1, 1
  store i32 %4, ptr @fcy, align 4, !tbaa !3
  %5 = load i32, ptr @fb_base, align 4, !tbaa !3
  %6 = mul i32 %4, 10240
  %7 = add i32 %5, %6
  store i32 %7, ptr @frowa, align 4, !tbaa !3
  br label %13

8:                                                ; preds = %0
  %9 = load i32, ptr @fb_base, align 4, !tbaa !3
  %10 = add i32 %9, 10240
  tail call void @kdmacpy(i32 noundef %9, i32 noundef %10, i32 noundef 296960) #6
  %11 = add i32 %9, 296960
  %12 = tail call fastcc i32 @bg_word() #7
  tail call void @kdmaset(i32 noundef %11, i32 noundef %12, i32 noundef 10240) #6
  br label %13

13:                                               ; preds = %8, %3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kdmaset(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @bg_word() unnamed_addr #4 {
  %1 = load i32, ptr @fbg, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [16 x i8], ptr @fbpal, i32 0, i32 %1
  %3 = load i8, ptr %2, align 1, !tbaa !7
  %4 = zext i8 %3 to i32
  %5 = shl nuw nsw i32 %4, 8
  %6 = shl nuw nsw i32 %4, 16
  %7 = shl nuw i32 %4, 24
  %8 = or disjoint i32 %6, %5
  %9 = or disjoint i32 %8, %7
  %10 = or disjoint i32 %9, %4
  ret i32 %10
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @clear_cells(i32 noundef %0, i32 noundef %1, i32 noundef range(i32 -2147483647, -2147483648) %2) unnamed_addr #0 {
  %4 = tail call fastcc i32 @bg_word() #7
  %5 = load i32, ptr @fb_base, align 4, !tbaa !3
  %6 = mul i32 %1, 10240
  %7 = shl i32 %0, 3
  %8 = add i32 %6, %7
  %9 = add i32 %8, %5
  %10 = icmp sgt i32 %2, 7
  br i1 %10, label %13, label %11

11:                                               ; preds = %3
  %12 = shl nsw i32 %2, 1
  br label %22

13:                                               ; preds = %3
  %14 = shl nsw i32 %2, 3
  br label %15

15:                                               ; preds = %13, %19
  %16 = phi i32 [ %20, %19 ], [ %9, %13 ]
  %17 = phi i32 [ %21, %19 ], [ 16, %13 ]
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %37, label %19

19:                                               ; preds = %15
  tail call void @kdmaset(i32 noundef %16, i32 noundef %4, i32 noundef %14) #6
  %20 = add i32 %16, 640
  %21 = add nsw i32 %17, -1
  br label %15, !llvm.loop !18

22:                                               ; preds = %11, %34
  %23 = phi i32 [ %35, %34 ], [ %9, %11 ]
  %24 = phi i32 [ %36, %34 ], [ 16, %11 ]
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %37, label %26

26:                                               ; preds = %22, %30
  %27 = phi i32 [ %32, %30 ], [ %23, %22 ]
  %28 = phi i32 [ %33, %30 ], [ %12, %22 ]
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %34, label %30

30:                                               ; preds = %26
  %31 = inttoptr i32 %27 to ptr
  store volatile i32 %4, ptr %31, align 4, !tbaa !3
  %32 = add i32 %27, 4
  %33 = add i32 %28, -1
  br label %26, !llvm.loop !19

34:                                               ; preds = %26
  %35 = add i32 %23, 640
  %36 = add nsw i32 %24, -1
  br label %22, !llvm.loop !20

37:                                               ; preds = %22, %15
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kdmacpy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.usub.sat.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
!8 = distinct !{!8, !9, !10}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{!"llvm.loop.unroll.disable"}
!11 = distinct !{!11, !9, !10}
!12 = distinct !{!12, !9, !10}
!13 = distinct !{!13, !9, !10}
!14 = distinct !{!14, !9, !10}
!15 = distinct !{!15, !9, !10}
!16 = distinct !{!16, !9, !10}
!17 = distinct !{!17, !9, !10}
!18 = distinct !{!18, !9, !10}
!19 = distinct !{!19, !9, !10}
!20 = distinct !{!20, !9, !10}
