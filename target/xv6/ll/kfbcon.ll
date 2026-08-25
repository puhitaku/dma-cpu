; ModuleID = 'dma/kfbcon.c'
source_filename = "dma/kfbcon.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fcy = internal unnamed_addr global i32 0, align 4
@fcx = internal unnamed_addr global i32 0, align 4
@ffg = internal unnamed_addr global i32 0, align 4
@fbg = internal unnamed_addr global i32 0, align 4
@fstate = internal unnamed_addr global i32 0, align 4
@fcursor = internal unnamed_addr global i1 false, align 4
@fnpar = internal unnamed_addr global i32 0, align 4
@fpriv = internal unnamed_addr global i1 false, align 4
@fpar = internal unnamed_addr global [4 x i32] zeroinitializer, align 4
@fbpal = internal unnamed_addr constant [16 x i8] c"\00\80\10\90\02\82\12\DB\92\E0\1C\FC\03\E3\1F\FF", align 1
@nibmask = internal unnamed_addr constant [16 x i32] [i32 0, i32 -16777216, i32 16711680, i32 -65536, i32 65280, i32 -16711936, i32 16776960, i32 -256, i32 255, i32 -16776961, i32 16711935, i32 -65281, i32 65535, i32 -16711681, i32 16777215, i32 -1], align 4
@flut16 = internal unnamed_addr global [16 x i32] zeroinitializer, align 4
@fluthi = internal unnamed_addr global [256 x i32] zeroinitializer, align 4
@flutlo = internal unnamed_addr global [256 x i32] zeroinitializer, align 4
@fbfont = internal unnamed_addr constant [1024 x i8] c"\00\00\00\00\00\00\00\00<B\A5\81\A5\99B<<~\DB\FF\FF\DBf<l\FE\FE\FE|8\10\00\108|\FE|8\10\00\108T\FET\108\00\108|\FE\FE\108\00\00\00\0000\00\00\00\FF\FF\FF\E7\E7\FF\FF\FF8D\82\82\82D8\00\C7\BB}}}\BB\C7\FF\0F\03\05y\88\88\88p8DDD8\10|\100($$( \E0\C0<$<$$\E4\DC\18\10T8\EE8T\10\00\80\C0\E0\F0\E0\C0\80\00\01\03\07\0F\07\03\01\00\10\10\10|\10\10\10\10\FCHHH\E8\08P |\A8\A8h(((\008@0HH0\08p\00\00\00<<\00\00\00  p p  \00\FF\FF\00\00\00\00\00\00\00\00\00\00\00\00\FF\FF\03\03\03\03\03\03\03\03\C0\C0\C0\C0\C0\C0\C0\C0\00\10\10\FF\10\10\00\00\00 P\88P \00\00\00\00\00\00\108|\FE\FE|8\10\00\00\00\00\00\00\00\00\00\00\00\00    \00\00 \00PPP\00\00\00\00\00PP\F8P\F8PP\00 x\A0p(\F0 \00\C0\C8\10 @\98\18\00@\A0@\A8\90\98`\00\10 @\00\00\00\00\00\10 @@@ \10\00@ \10\10\10 @\00 \A8p p\A8 \00\00  \F8  \00\00\00\00\00\00\00  @\00\00\00x\00\00\00\00\00\00\00\00\00``\00\00\00\08\10 @\80\00p\88\98\A8\C8\88p\00 `\A0   \F8\00p\88\08\10`\80\F8\00p\88\080\08\88p\00\100P\90\F8\10\10\00\F8\80\E0\10\08\10\E0\000@\80\F0\88\88p\00\F8\88\10    \00p\88\88p\88\88p\00p\88\88x\08\10`\00\00\00 \00\00 \00\00\00\00 \00\00  @\00\10 @ \10\00\00\00\00\F8\00\F8\00\00\00\00@ \10 @\00\00p\88\08\10 \00 \00\00p\A8\A8\B0\80p\00 P\88\88\F8\88\88\00\F0HHpHH\F0\000H\80\80\80H0\00\E0PHHHP\E0\00\F8\80\80\F0\80\80\F8\00\F8\80\80\F0\80\80\80\00p\88\80\B8\88\88p\00\88\88\88\F8\88\88\88\00p     p\008\10\10\10\90\90`\00\88\90\A0\C0\A0\90\88\00\80\80\80\80\80\80\F8\00\88\D8\A8\A8\88\88\88\00\88\C8\C8\A8\98\98\88\00p\88\88\88\88\88p\00\F0\88\88\F0\80\80\80\00p\88\88\88\A8\90h\00\F0\88\88\F0\A0\90\88\00p\88\80p\08\88p\00\F8      \00\88\88\88\88\88\88p\00\88\88\88\88PP \00\88\88\88\A8\A8\D8\88\00\88\88P P\88\88\00\88\88\88p   \00\F8\08\10 @\80\F8\00p@@@@@p\00\00\00\80@ \10\08\00p\10\10\10\10\10p\00 P\88\00\00\00\00\00\00\00\00\00\00\00\F8\00@ \10\00\00\00\00\00\00\00p\08x\88x\00\80\80\B0\C8\88\C8\B0\00\00\00p\88\80\88p\00\08\08h\98\88\98h\00\00\00p\88\F8\80p\00\10( \F8   \00\00\00h\98\98h\08p\80\80\F0\88\88\88\88\00 \00`   p\00\10\000\10\10\10\90`@@HP`PH\00`     p\00\00\00\D0\A8\A8\A8\A8\00\00\00\B0\C8\88\88\88\00\00\00p\88\88\88p\00\00\00\B0\C8\C8\B0\80\80\00\00h\98\98h\08\08\00\00\B0\C8\80\80\80\00\00\00x\80\F0\08\F0\00@@\F0@@H0\00\00\00\90\90\90\90h\00\00\00\88\88\88P \00\00\00\88\A8\A8\A8P\00\00\00\88P P\88\00\00\00\88\88\98h\08p\00\00\F8\10 @\F8\00\18  @  \18\00   \00   \00\C0  \10  \C0\00@\A8\10\00\00\00\00\00\00\00 P\F8\00\00\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @kfbcon_reset() local_unnamed_addr #0 {
  %1 = tail call i32 @kfb_active() #4
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %4, label %3

3:                                                ; preds = %0
  store i32 0, ptr @fcy, align 4, !tbaa !3
  store i32 0, ptr @fcx, align 4, !tbaa !3
  store i32 7, ptr @ffg, align 4, !tbaa !3
  store i32 0, ptr @fbg, align 4, !tbaa !3
  store i32 0, ptr @fstate, align 4, !tbaa !3
  store i1 false, ptr @fcursor, align 4
  tail call fastcc void @lut_build() #5
  tail call fastcc void @clear_screen() #5
  br label %4

4:                                                ; preds = %0, %3
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
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %6, %5 ]
  %3 = icmp eq i32 %2, 30
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  ret void

5:                                                ; preds = %1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %2, i32 noundef 80) #5
  %6 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !13
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kfbcon_putc(i32 noundef %0) local_unnamed_addr #0 {
  %2 = tail call i32 @kfb_active() #4
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %211, label %4

4:                                                ; preds = %1
  %5 = tail call i32 @kfb_owner() #4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %211

7:                                                ; preds = %4
  %8 = load i1, ptr @fcursor, align 4
  br i1 %8, label %9, label %10

9:                                                ; preds = %7
  tail call fastcc void @cursor_xor() #5
  store i1 false, ptr @fcursor, align 4
  br label %10

10:                                               ; preds = %9, %7
  %11 = and i32 %0, 255
  %12 = load i32, ptr @fstate, align 4, !tbaa !3
  switch i32 %12, label %160 [
    i32 1, label %13
    i32 2, label %17
  ]

13:                                               ; preds = %10
  %14 = icmp eq i32 %11, 91
  br i1 %14, label %15, label %16

15:                                               ; preds = %13
  store i32 2, ptr @fstate, align 4, !tbaa !3
  store i32 0, ptr @fnpar, align 4, !tbaa !3
  store i1 false, ptr @fpriv, align 4
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 12), align 4, !tbaa !3
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 8), align 4, !tbaa !3
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 4), align 4, !tbaa !3
  store i32 0, ptr @fpar, align 4, !tbaa !3
  br label %210

16:                                               ; preds = %13
  store i32 0, ptr @fstate, align 4, !tbaa !3
  br label %210

17:                                               ; preds = %10
  %18 = add nsw i32 %11, -48
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
  br label %210

31:                                               ; preds = %17
  %32 = trunc i32 %0 to i8
  switch i8 %32, label %41 [
    i8 59, label %33
    i8 63, label %40
  ]

33:                                               ; preds = %31
  %34 = load i32, ptr @fnpar, align 4, !tbaa !3
  %35 = icmp slt i32 %34, 4
  br i1 %35, label %36, label %210

36:                                               ; preds = %33
  %37 = add nuw nsw i32 %34, 1
  %38 = icmp eq i32 %34, 0
  %39 = select i1 %38, i32 2, i32 %37
  store i32 %39, ptr @fnpar, align 4
  br label %210

40:                                               ; preds = %31
  store i1 true, ptr @fpriv, align 4
  br label %210

41:                                               ; preds = %31
  store i32 0, ptr @fstate, align 4, !tbaa !3
  %42 = load i32, ptr @fpar, align 4, !tbaa !3
  %43 = tail call i32 @llvm.umax.i32(i32 %42, i32 1)
  %44 = load i1, ptr @fpriv, align 4
  br i1 %44, label %45, label %49

45:                                               ; preds = %41
  %46 = icmp eq i32 %42, 1049
  br i1 %46, label %47, label %210

47:                                               ; preds = %45
  switch i8 %32, label %210 [
    i8 104, label %48
    i8 108, label %48
  ]

48:                                               ; preds = %47, %47
  tail call fastcc void @clear_screen() #5
  store i32 0, ptr @fcy, align 4, !tbaa !3
  store i32 0, ptr @fcx, align 4, !tbaa !3
  br label %210

49:                                               ; preds = %41
  switch i8 %32, label %210 [
    i8 65, label %50
    i8 66, label %54
    i8 67, label %58
    i8 68, label %62
    i8 72, label %66
    i8 102, label %66
    i8 74, label %79
    i8 75, label %100
    i8 109, label %111
  ]

50:                                               ; preds = %49
  %51 = load i32, ptr @fcy, align 4, !tbaa !3
  %52 = sub nsw i32 %51, %43
  %53 = tail call i32 @llvm.smax.i32(i32 %52, i32 0)
  store i32 %53, ptr @fcy, align 4
  br label %210

54:                                               ; preds = %49
  %55 = load i32, ptr @fcy, align 4, !tbaa !3
  %56 = add nsw i32 %55, %43
  %57 = tail call i32 @llvm.smin.i32(i32 %56, i32 29)
  store i32 %57, ptr @fcy, align 4
  br label %210

58:                                               ; preds = %49
  %59 = load i32, ptr @fcx, align 4, !tbaa !3
  %60 = add nsw i32 %59, %43
  %61 = tail call i32 @llvm.smin.i32(i32 %60, i32 79)
  store i32 %61, ptr @fcx, align 4
  br label %210

62:                                               ; preds = %49
  %63 = load i32, ptr @fcx, align 4, !tbaa !3
  %64 = sub nsw i32 %63, %43
  %65 = tail call i32 @llvm.smax.i32(i32 %64, i32 0)
  store i32 %65, ptr @fcx, align 4
  br label %210

66:                                               ; preds = %49, %49
  %67 = tail call i32 @llvm.usub.sat.i32(i32 %42, i32 1)
  %68 = load i32, ptr @fnpar, align 4, !tbaa !3
  %69 = icmp sgt i32 %68, 1
  %70 = load i32, ptr getelementptr inbounds nuw (i8, ptr @fpar, i32 4), align 4
  %71 = icmp ne i32 %70, 0
  %72 = select i1 %69, i1 %71, i1 false
  %73 = tail call i32 @llvm.smax.i32(i32 %67, i32 0)
  %74 = tail call i32 @llvm.umin.i32(i32 %73, i32 29)
  store i32 %74, ptr @fcy, align 4, !tbaa !3
  %75 = tail call i32 @llvm.smax.i32(i32 %70, i32 1)
  %76 = tail call i32 @llvm.umin.i32(i32 %75, i32 80)
  %77 = add nsw i32 %76, -1
  %78 = select i1 %72, i32 %77, i32 0
  store i32 %78, ptr @fcx, align 4, !tbaa !3
  br label %210

79:                                               ; preds = %49
  switch i32 %42, label %90 [
    i32 2, label %80
    i32 1, label %81
  ]

80:                                               ; preds = %79
  tail call fastcc void @clear_screen() #5
  br label %210

81:                                               ; preds = %79, %88
  %82 = phi i32 [ %89, %88 ], [ 0, %79 ]
  %83 = load i32, ptr @fcy, align 4, !tbaa !3
  %84 = icmp slt i32 %82, %83
  br i1 %84, label %88, label %85

85:                                               ; preds = %81
  %86 = load i32, ptr @fcx, align 4, !tbaa !3
  %87 = add nsw i32 %86, 1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %83, i32 noundef %87) #5
  br label %210

88:                                               ; preds = %81
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %82, i32 noundef 80) #5
  %89 = add nuw nsw i32 %82, 1
  br label %81, !llvm.loop !14

90:                                               ; preds = %79
  %91 = load i32, ptr @fcx, align 4, !tbaa !3
  %92 = load i32, ptr @fcy, align 4, !tbaa !3
  %93 = sub nsw i32 80, %91
  tail call fastcc void @clear_cells(i32 noundef %91, i32 noundef %92, i32 noundef %93) #5
  %94 = load i32, ptr @fcy, align 4, !tbaa !3
  br label %95

95:                                               ; preds = %98, %90
  %96 = phi i32 [ %94, %90 ], [ %99, %98 ]
  %97 = icmp slt i32 %96, 29
  br i1 %97, label %98, label %210

98:                                               ; preds = %95
  %99 = add nsw i32 %96, 1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %99, i32 noundef 80) #5
  br label %95, !llvm.loop !15

100:                                              ; preds = %49
  switch i32 %42, label %107 [
    i32 2, label %101
    i32 1, label %103
  ]

101:                                              ; preds = %100
  %102 = load i32, ptr @fcy, align 4, !tbaa !3
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %102, i32 noundef 80) #5
  br label %210

103:                                              ; preds = %100
  %104 = load i32, ptr @fcy, align 4, !tbaa !3
  %105 = load i32, ptr @fcx, align 4, !tbaa !3
  %106 = add nsw i32 %105, 1
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef %104, i32 noundef %106) #5
  br label %210

107:                                              ; preds = %100
  %108 = load i32, ptr @fcx, align 4, !tbaa !3
  %109 = load i32, ptr @fcy, align 4, !tbaa !3
  %110 = sub nsw i32 80, %108
  tail call fastcc void @clear_cells(i32 noundef %108, i32 noundef %109, i32 noundef %110) #5
  br label %210

111:                                              ; preds = %49
  %112 = load i32, ptr @fnpar, align 4, !tbaa !3
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %114, label %115

114:                                              ; preds = %111
  store i32 1, ptr @fnpar, align 4, !tbaa !3
  store i32 0, ptr @fpar, align 4, !tbaa !3
  br label %115

115:                                              ; preds = %114, %111
  %116 = phi i32 [ 1, %114 ], [ %112, %111 ]
  %117 = load i32, ptr @ffg, align 4
  %118 = load i32, ptr @fbg, align 4
  br label %119

119:                                              ; preds = %155, %115
  %120 = phi i32 [ %118, %115 ], [ %156, %155 ]
  %121 = phi i32 [ %117, %115 ], [ %157, %155 ]
  %122 = phi i32 [ 0, %115 ], [ %158, %155 ]
  %123 = icmp slt i32 %122, %116
  br i1 %123, label %124, label %159

124:                                              ; preds = %119
  %125 = getelementptr inbounds nuw [4 x i32], ptr @fpar, i32 0, i32 %122
  %126 = load i32, ptr %125, align 4, !tbaa !3
  switch i32 %126, label %131 [
    i32 0, label %127
    i32 1, label %128
    i32 7, label %130
  ]

127:                                              ; preds = %124
  store i32 7, ptr @ffg, align 4, !tbaa !3
  store i32 0, ptr @fbg, align 4, !tbaa !3
  br label %155

128:                                              ; preds = %124
  %129 = or i32 %121, 8
  store i32 %129, ptr @ffg, align 4, !tbaa !3
  br label %155

130:                                              ; preds = %124
  store i32 %120, ptr @ffg, align 4, !tbaa !3
  store i32 %121, ptr @fbg, align 4, !tbaa !3
  br label %155

131:                                              ; preds = %124
  %132 = add i32 %126, -30
  %133 = icmp ult i32 %132, 8
  br i1 %133, label %134, label %137

134:                                              ; preds = %131
  %135 = and i32 %121, 8
  %136 = or disjoint i32 %132, %135
  store i32 %136, ptr @ffg, align 4, !tbaa !3
  br label %155

137:                                              ; preds = %131
  %138 = and i32 %126, -8
  %139 = icmp eq i32 %138, 40
  br i1 %139, label %140, label %142

140:                                              ; preds = %137
  %141 = add nsw i32 %126, -40
  store i32 %141, ptr @fbg, align 4, !tbaa !3
  br label %155

142:                                              ; preds = %137
  %143 = add i32 %126, -90
  %144 = icmp ult i32 %143, 8
  br i1 %144, label %145, label %147

145:                                              ; preds = %142
  %146 = add nsw i32 %126, -82
  store i32 %146, ptr @ffg, align 4, !tbaa !3
  br label %155

147:                                              ; preds = %142
  %148 = add i32 %126, -100
  %149 = icmp ult i32 %148, 8
  br i1 %149, label %150, label %152

150:                                              ; preds = %147
  %151 = add nsw i32 %126, -92
  store i32 %151, ptr @fbg, align 4, !tbaa !3
  br label %155

152:                                              ; preds = %147
  switch i32 %126, label %155 [
    i32 39, label %153
    i32 49, label %154
  ]

153:                                              ; preds = %152
  store i32 7, ptr @ffg, align 4, !tbaa !3
  br label %155

154:                                              ; preds = %152
  store i32 0, ptr @fbg, align 4, !tbaa !3
  br label %155

155:                                              ; preds = %154, %153, %152, %150, %145, %140, %134, %130, %128, %127
  %156 = phi i32 [ %120, %152 ], [ %120, %128 ], [ %120, %134 ], [ %120, %145 ], [ %120, %153 ], [ 0, %154 ], [ %151, %150 ], [ %141, %140 ], [ %121, %130 ], [ 0, %127 ]
  %157 = phi i32 [ %121, %152 ], [ %129, %128 ], [ %136, %134 ], [ %146, %145 ], [ 7, %153 ], [ %121, %154 ], [ %121, %150 ], [ %121, %140 ], [ %120, %130 ], [ 7, %127 ]
  %158 = add nuw nsw i32 %122, 1
  br label %119, !llvm.loop !16

159:                                              ; preds = %119
  tail call fastcc void @lut_build() #5
  br label %210

160:                                              ; preds = %10
  %161 = trunc i32 %0 to i8
  switch i8 %161, label %175 [
    i8 27, label %162
    i8 10, label %163
    i8 13, label %164
    i8 8, label %165
    i8 9, label %170
  ]

162:                                              ; preds = %160
  store i32 1, ptr @fstate, align 4, !tbaa !3
  br label %210

163:                                              ; preds = %160
  tail call fastcc void @newline() #5
  br label %210

164:                                              ; preds = %160
  store i32 0, ptr @fcx, align 4, !tbaa !3
  br label %210

165:                                              ; preds = %160
  %166 = load i32, ptr @fcx, align 4, !tbaa !3
  %167 = icmp sgt i32 %166, 0
  br i1 %167, label %168, label %210

168:                                              ; preds = %165
  %169 = add nsw i32 %166, -1
  store i32 %169, ptr @fcx, align 4, !tbaa !3
  br label %210

170:                                              ; preds = %160
  %171 = load i32, ptr @fcx, align 4, !tbaa !3
  %172 = and i32 %171, -8
  %173 = tail call i32 @llvm.smin.i32(i32 %172, i32 71)
  %174 = add nsw i32 %173, 8
  store i32 %174, ptr @fcx, align 4
  br label %210

175:                                              ; preds = %160
  %176 = add nsw i32 %11, -32
  %177 = icmp ult i32 %176, 95
  br i1 %177, label %178, label %210

178:                                              ; preds = %175
  %179 = shl nuw nsw i32 %11, 3
  %180 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %179
  %181 = load i32, ptr @fcx, align 4, !tbaa !3
  %182 = load i32, ptr @fcy, align 4, !tbaa !3
  %183 = tail call fastcc i32 @cell_addr(i32 noundef %181, i32 noundef %182) #5
  br label %184

184:                                              ; preds = %188, %178
  %185 = phi i32 [ 0, %178 ], [ %204, %188 ]
  %186 = phi i32 [ %183, %178 ], [ %203, %188 ]
  %187 = icmp eq i32 %185, 8
  br i1 %187, label %205, label %188

188:                                              ; preds = %184
  %189 = getelementptr inbounds nuw i8, ptr %180, i32 %185
  %190 = load i8, ptr %189, align 1, !tbaa !7
  %191 = zext i8 %190 to i32
  %192 = getelementptr inbounds nuw [256 x i32], ptr @fluthi, i32 0, i32 %191
  %193 = load i32, ptr %192, align 4, !tbaa !3
  %194 = getelementptr inbounds nuw [256 x i32], ptr @flutlo, i32 0, i32 %191
  %195 = load i32, ptr %194, align 4, !tbaa !3
  %196 = inttoptr i32 %186 to ptr
  store volatile i32 %193, ptr %196, align 4, !tbaa !3
  %197 = add i32 %186, 4
  %198 = inttoptr i32 %197 to ptr
  store volatile i32 %195, ptr %198, align 4, !tbaa !3
  %199 = add i32 %186, 640
  %200 = inttoptr i32 %199 to ptr
  store volatile i32 %193, ptr %200, align 4, !tbaa !3
  %201 = add i32 %186, 644
  %202 = inttoptr i32 %201 to ptr
  store volatile i32 %195, ptr %202, align 4, !tbaa !3
  %203 = add i32 %186, 1280
  %204 = add nuw nsw i32 %185, 1
  br label %184, !llvm.loop !17

205:                                              ; preds = %184
  %206 = load i32, ptr @fcx, align 4, !tbaa !3
  %207 = add nsw i32 %206, 1
  store i32 %207, ptr @fcx, align 4, !tbaa !3
  %208 = icmp sgt i32 %206, 78
  br i1 %208, label %209, label %210

209:                                              ; preds = %205
  tail call fastcc void @newline() #5
  br label %210

210:                                              ; preds = %95, %36, %33, %159, %107, %103, %101, %85, %80, %66, %62, %58, %54, %50, %49, %48, %47, %45, %40, %24, %163, %168, %165, %175, %209, %205, %170, %164, %162, %15, %16
  tail call fastcc void @cursor_xor() #5
  store i1 true, ptr @fcursor, align 4
  br label %211

211:                                              ; preds = %1, %4, %210
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_owner() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cursor_xor() unnamed_addr #0 {
  %1 = load i32, ptr @fcx, align 4, !tbaa !3
  %2 = load i32, ptr @fcy, align 4, !tbaa !3
  %3 = tail call fastcc i32 @cell_addr(i32 noundef %1, i32 noundef %2) #5
  %4 = add i32 %3, 7680
  br label %5

5:                                                ; preds = %10, %0
  %6 = phi i32 [ %4, %0 ], [ %18, %10 ]
  %7 = phi i32 [ 0, %0 ], [ %19, %10 ]
  %8 = icmp eq i32 %7, 4
  br i1 %8, label %9, label %10

9:                                                ; preds = %5
  ret void

10:                                               ; preds = %5
  %11 = inttoptr i32 %6 to ptr
  %12 = load volatile i32, ptr %11, align 4, !tbaa !3
  %13 = xor i32 %12, -1
  store volatile i32 %13, ptr %11, align 4, !tbaa !3
  %14 = add i32 %6, 4
  %15 = inttoptr i32 %14 to ptr
  %16 = load volatile i32, ptr %15, align 4, !tbaa !3
  %17 = xor i32 %16, -1
  store volatile i32 %17, ptr %15, align 4, !tbaa !3
  %18 = add i32 %6, 640
  %19 = add nuw nsw i32 %7, 1
  br label %5, !llvm.loop !18
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @newline() unnamed_addr #0 {
  store i32 0, ptr @fcx, align 4, !tbaa !3
  %1 = load i32, ptr @fcy, align 4, !tbaa !3
  %2 = icmp slt i32 %1, 29
  br i1 %2, label %3, label %5

3:                                                ; preds = %0
  %4 = add nsw i32 %1, 1
  store i32 %4, ptr @fcy, align 4, !tbaa !3
  br label %8

5:                                                ; preds = %0
  %6 = tail call i32 @kfb_base() #4
  %7 = add i32 %6, 10240
  tail call void @kdmacpy(i32 noundef %6, i32 noundef %7, i32 noundef 296960) #4
  tail call fastcc void @clear_cells(i32 noundef 0, i32 noundef 29, i32 noundef 80) #5
  br label %8

8:                                                ; preds = %5, %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @clear_cells(i32 noundef %0, i32 noundef %1, i32 noundef range(i32 -2147483647, -2147483648) %2) unnamed_addr #0 {
  %4 = load i32, ptr @fbg, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw [16 x i8], ptr @fbpal, i32 0, i32 %4
  %6 = load i8, ptr %5, align 1, !tbaa !7
  %7 = zext i8 %6 to i32
  %8 = shl nuw nsw i32 %7, 8
  %9 = shl nuw nsw i32 %7, 16
  %10 = shl nuw i32 %7, 24
  %11 = or disjoint i32 %9, %8
  %12 = or disjoint i32 %11, %10
  %13 = or disjoint i32 %12, %7
  %14 = tail call fastcc i32 @cell_addr(i32 noundef %0, i32 noundef %1) #5
  %15 = icmp sgt i32 %2, 7
  br i1 %15, label %18, label %16

16:                                               ; preds = %3
  %17 = shl nsw i32 %2, 1
  br label %27

18:                                               ; preds = %3
  %19 = shl nsw i32 %2, 3
  br label %20

20:                                               ; preds = %18, %24
  %21 = phi i32 [ %25, %24 ], [ %14, %18 ]
  %22 = phi i32 [ %26, %24 ], [ 0, %18 ]
  %23 = icmp eq i32 %22, 16
  br i1 %23, label %42, label %24

24:                                               ; preds = %20
  tail call void @kdmaset(i32 noundef %21, i32 noundef %13, i32 noundef %19) #4
  %25 = add i32 %21, 640
  %26 = add nuw nsw i32 %22, 1
  br label %20, !llvm.loop !19

27:                                               ; preds = %16, %39
  %28 = phi i32 [ %40, %39 ], [ %14, %16 ]
  %29 = phi i32 [ %41, %39 ], [ 0, %16 ]
  %30 = icmp eq i32 %29, 16
  br i1 %30, label %42, label %31

31:                                               ; preds = %27, %35
  %32 = phi i32 [ %37, %35 ], [ %28, %27 ]
  %33 = phi i32 [ %38, %35 ], [ %17, %27 ]
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %39, label %35

35:                                               ; preds = %31
  %36 = inttoptr i32 %32 to ptr
  store volatile i32 %13, ptr %36, align 4, !tbaa !3
  %37 = add i32 %32, 4
  %38 = add i32 %33, -1
  br label %31, !llvm.loop !20

39:                                               ; preds = %31
  %40 = add i32 %28, 640
  %41 = add nuw nsw i32 %29, 1
  br label %27, !llvm.loop !21

42:                                               ; preds = %27, %20
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @cell_addr(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = tail call i32 @kfb_base() #4
  %4 = mul i32 %1, 10240
  %5 = shl i32 %0, 3
  %6 = add i32 %4, %5
  %7 = add i32 %6, %3
  ret i32 %7
}

; Function Attrs: minsize optsize
declare dso_local void @kdmaset(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_base() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @kdmacpy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.usub.sat.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }

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
!21 = distinct !{!21, !9, !10}
