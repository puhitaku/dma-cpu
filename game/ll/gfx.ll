; ModuleID = 'gfx.c'
source_filename = "gfx.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@dx0 = internal unnamed_addr global i32 0, align 4
@dy0 = internal unnamed_addr global i32 0, align 4
@dx1 = internal unnamed_addr global i32 0, align 4
@dy1 = internal unnamed_addr global i32 0, align 4
@fb = dso_local global [57600 x i16] zeroinitializer, align 2
@fbfont = internal unnamed_addr constant [1024 x i8] c"\00\00\00\00\00\00\00\00<B\A5\81\A5\99B<<~\DB\FF\FF\DBf<l\FE\FE\FE|8\10\00\108|\FE|8\10\00\108T\FET\108\00\108|\FE\FE\108\00\00\00\0000\00\00\00\FF\FF\FF\E7\E7\FF\FF\FF8D\82\82\82D8\00\C7\BB}}}\BB\C7\FF\0F\03\05y\88\88\88p8DDD8\10|\100($$( \E0\C0<$<$$\E4\DC\18\10T8\EE8T\10\00\80\C0\E0\F0\E0\C0\80\00\01\03\07\0F\07\03\01\00\10\10\10|\10\10\10\10\FCHHH\E8\08P |\A8\A8h(((\008@0HH0\08p\00\00\00<<\00\00\00  p p  \00\FF\FF\00\00\00\00\00\00\00\00\00\00\00\00\FF\FF\03\03\03\03\03\03\03\03\C0\C0\C0\C0\C0\C0\C0\C0\00\10\10\FF\10\10\00\00\00 P\88P \00\00\00\00\00\00\108|\FE\FE|8\10\00\00\00\00\00\00\00\00\00\00\00\00    \00\00 \00PPP\00\00\00\00\00PP\F8P\F8PP\00 x\A0p(\F0 \00\C0\C8\10 @\98\18\00@\A0@\A8\90\98`\00\10 @\00\00\00\00\00\10 @@@ \10\00@ \10\10\10 @\00 \A8p p\A8 \00\00  \F8  \00\00\00\00\00\00\00  @\00\00\00x\00\00\00\00\00\00\00\00\00``\00\00\00\08\10 @\80\00p\88\98\A8\C8\88p\00 `\A0   \F8\00p\88\08\10`\80\F8\00p\88\080\08\88p\00\100P\90\F8\10\10\00\F8\80\E0\10\08\10\E0\000@\80\F0\88\88p\00\F8\88\10    \00p\88\88p\88\88p\00p\88\88x\08\10`\00\00\00 \00\00 \00\00\00\00 \00\00  @\00\10 @ \10\00\00\00\00\F8\00\F8\00\00\00\00@ \10 @\00\00p\88\08\10 \00 \00\00p\A8\A8\B0\80p\00 P\88\88\F8\88\88\00\F0HHpHH\F0\000H\80\80\80H0\00\E0PHHHP\E0\00\F8\80\80\F0\80\80\F8\00\F8\80\80\F0\80\80\80\00p\88\80\B8\88\88p\00\88\88\88\F8\88\88\88\00p     p\008\10\10\10\90\90`\00\88\90\A0\C0\A0\90\88\00\80\80\80\80\80\80\F8\00\88\D8\A8\A8\88\88\88\00\88\C8\C8\A8\98\98\88\00p\88\88\88\88\88p\00\F0\88\88\F0\80\80\80\00p\88\88\88\A8\90h\00\F0\88\88\F0\A0\90\88\00p\88\80p\08\88p\00\F8      \00\88\88\88\88\88\88p\00\88\88\88\88PP \00\88\88\88\A8\A8\D8\88\00\88\88P P\88\88\00\88\88\88p   \00\F8\08\10 @\80\F8\00p@@@@@p\00\00\00\80@ \10\08\00p\10\10\10\10\10p\00 P\88\00\00\00\00\00\00\00\00\00\00\00\F8\00@ \10\00\00\00\00\00\00\00p\08x\88x\00\80\80\B0\C8\88\C8\B0\00\00\00p\88\80\88p\00\08\08h\98\88\98h\00\00\00p\88\F8\80p\00\10( \F8   \00\00\00h\98\98h\08p\80\80\F0\88\88\88\88\00 \00`   p\00\10\000\10\10\10\90`@@HP`PH\00`     p\00\00\00\D0\A8\A8\A8\A8\00\00\00\B0\C8\88\88\88\00\00\00p\88\88\88p\00\00\00\B0\C8\C8\B0\80\80\00\00h\98\98h\08\08\00\00\B0\C8\80\80\80\00\00\00x\80\F0\08\F0\00@@\F0@@H0\00\00\00\90\90\90\90h\00\00\00\88\88\88P \00\00\00\88\A8\A8\A8P\00\00\00\88P P\88\00\00\00\88\88\98h\08p\00\00\F8\10 @\F8\00\18  @  \18\00   \00   \00\C0  \10  \C0\00@\A8\10\00\00\00\00\00\00\00 P\F8\00\00\00", align 1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #0 {
  %5 = tail call i32 @llvm.smax.i32(i32 %0, i32 0)
  %6 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %7 = tail call i32 @llvm.smin.i32(i32 %2, i32 239)
  %8 = tail call i32 @llvm.smin.i32(i32 %3, i32 239)
  %9 = icmp sgt i32 %5, %7
  br i1 %9, label %28, label %10

10:                                               ; preds = %4
  %11 = icmp sgt i32 %6, %8
  br i1 %11, label %28, label %12

12:                                               ; preds = %10
  %13 = load i32, ptr @dx0, align 4, !tbaa !3
  %14 = icmp slt i32 %5, %13
  br i1 %14, label %15, label %16

15:                                               ; preds = %12
  store i32 %5, ptr @dx0, align 4, !tbaa !3
  br label %16

16:                                               ; preds = %15, %12
  %17 = load i32, ptr @dy0, align 4, !tbaa !3
  %18 = icmp slt i32 %6, %17
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  store i32 %6, ptr @dy0, align 4, !tbaa !3
  br label %20

20:                                               ; preds = %19, %16
  %21 = load i32, ptr @dx1, align 4, !tbaa !3
  %22 = icmp sgt i32 %7, %21
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  store i32 %7, ptr @dx1, align 4, !tbaa !3
  br label %24

24:                                               ; preds = %23, %20
  %25 = load i32, ptr @dy1, align 4, !tbaa !3
  %26 = icmp sgt i32 %8, %25
  br i1 %26, label %27, label %28

27:                                               ; preds = %24
  store i32 %8, ptr @dy1, align 4, !tbaa !3
  br label %28

28:                                               ; preds = %4, %10, %27, %24
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_present() local_unnamed_addr #1 {
  %1 = load i32, ptr @dx1, align 4, !tbaa !3
  %2 = load i32, ptr @dx0, align 4, !tbaa !3
  %3 = icmp slt i32 %1, %2
  br i1 %3, label %7, label %4

4:                                                ; preds = %0
  %5 = load i32, ptr @dy0, align 4, !tbaa !3
  %6 = load i32, ptr @dy1, align 4, !tbaa !3
  tail call void @lcd_flush(i32 noundef %2, i32 noundef %5, i32 noundef %1, i32 noundef %6) #6
  store i32 240, ptr @dx0, align 4, !tbaa !3
  store i32 240, ptr @dy0, align 4, !tbaa !3
  store i32 -1, ptr @dx1, align 4, !tbaa !3
  store i32 -1, ptr @dy1, align 4, !tbaa !3
  br label %7

7:                                                ; preds = %0, %4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @lcd_flush(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_clear(i16 noundef zeroext %0) local_unnamed_addr #1 {
  %2 = zext i16 %0 to i32
  %3 = mul nuw i32 %2, 65537
  tail call void @gdma_fill(i32 noundef ptrtoint (ptr @fb to i32), i32 noundef %3, i32 noundef 115200) #6
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 0, i32 noundef 239, i32 noundef 239) #7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i16 noundef zeroext %4) local_unnamed_addr #1 {
  %6 = icmp slt i32 %2, 1
  br i1 %6, label %40, label %7

7:                                                ; preds = %5
  %8 = icmp slt i32 %3, 1
  br i1 %8, label %40, label %9

9:                                                ; preds = %7
  %10 = and i32 %2, 1
  %11 = zext i16 %4 to i32
  %12 = mul nuw i32 %11, 65537
  %13 = shl nuw i32 %2, 1
  br label %14

14:                                               ; preds = %9, %38
  %15 = phi i32 [ %39, %38 ], [ 0, %9 ]
  %16 = icmp eq i32 %15, %3
  br i1 %16, label %17, label %22

17:                                               ; preds = %14
  %18 = add i32 %0, -1
  %19 = add i32 %18, %2
  %20 = add i32 %1, -1
  %21 = add i32 %20, %3
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %19, i32 noundef %21) #7
  br label %40

22:                                               ; preds = %14
  %23 = add nsw i32 %15, %1
  %24 = mul nsw i32 %23, 240
  %25 = add nsw i32 %24, %0
  %26 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %25
  %27 = ptrtoint ptr %26 to i32
  %28 = and i32 %27, 2
  %29 = or disjoint i32 %28, %10
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %22
  tail call void @gdma_fill(i32 noundef %27, i32 noundef %12, i32 noundef %13) #6
  br label %38

32:                                               ; preds = %22, %35
  %33 = phi i32 [ %37, %35 ], [ 0, %22 ]
  %34 = icmp eq i32 %33, %2
  br i1 %34, label %38, label %35

35:                                               ; preds = %32
  %36 = getelementptr inbounds nuw i16, ptr %26, i32 %33
  store i16 %4, ptr %36, align 2, !tbaa !7
  %37 = add nuw i32 %33, 1
  br label %32, !llvm.loop !9

38:                                               ; preds = %32, %31
  %39 = add nuw i32 %15, 1
  br label %14, !llvm.loop !12

40:                                               ; preds = %5, %7, %17
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define dso_local void @gfx_text(i32 noundef %0, i32 noundef %1, ptr noundef readonly captures(none) %2, i16 noundef zeroext %3, i16 noundef zeroext %4) local_unnamed_addr #3 {
  br label %6

6:                                                ; preds = %22, %5
  %7 = phi i32 [ %0, %5 ], [ %11, %22 ]
  %8 = phi ptr [ %2, %5 ], [ %23, %22 ]
  %9 = load i8, ptr %8, align 1, !tbaa !13
  %10 = icmp ne i8 %9, 0
  %11 = add nsw i32 %7, 8
  %12 = icmp slt i32 %7, 233
  %13 = select i1 %10, i1 %12, i1 false
  br i1 %13, label %14, label %44

14:                                               ; preds = %6
  %15 = and i8 %9, 127
  %16 = zext nneg i8 %15 to i32
  %17 = shl nuw nsw i32 %16, 3
  %18 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %17
  br label %19

19:                                               ; preds = %35, %14
  %20 = phi i32 [ 0, %14 ], [ %36, %35 ]
  %21 = icmp eq i32 %20, 8
  br i1 %21, label %22, label %24

22:                                               ; preds = %19
  %23 = getelementptr inbounds nuw i8, ptr %8, i32 1
  br label %6, !llvm.loop !14

24:                                               ; preds = %19
  %25 = add nsw i32 %20, %1
  %26 = mul nsw i32 %25, 240
  %27 = add nsw i32 %26, %7
  %28 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %27
  %29 = getelementptr inbounds nuw i8, ptr %18, i32 %20
  %30 = load i8, ptr %29, align 1, !tbaa !13
  %31 = zext i8 %30 to i32
  br label %32

32:                                               ; preds = %37, %24
  %33 = phi i32 [ 0, %24 ], [ %43, %37 ]
  %34 = icmp eq i32 %33, 8
  br i1 %34, label %35, label %37

35:                                               ; preds = %32
  %36 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !15

37:                                               ; preds = %32
  %38 = lshr exact i32 128, %33
  %39 = and i32 %38, %31
  %40 = icmp eq i32 %39, 0
  %41 = select i1 %40, i16 %4, i16 %3
  %42 = getelementptr inbounds nuw i16, ptr %28, i32 %33
  store i16 %41, ptr %42, align 2, !tbaa !7
  %43 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !16

44:                                               ; preds = %6
  %45 = add nsw i32 %7, -1
  %46 = add nsw i32 %1, 7
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %45, i32 noundef %46) #7
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define dso_local void @gfx_text2(i32 noundef %0, i32 noundef %1, ptr noundef readonly captures(none) %2, i16 noundef zeroext %3, i16 noundef zeroext %4) local_unnamed_addr #3 {
  br label %6

6:                                                ; preds = %22, %5
  %7 = phi i32 [ %0, %5 ], [ %11, %22 ]
  %8 = phi ptr [ %2, %5 ], [ %23, %22 ]
  %9 = load i8, ptr %8, align 1, !tbaa !13
  %10 = icmp ne i8 %9, 0
  %11 = add nsw i32 %7, 16
  %12 = icmp slt i32 %7, 225
  %13 = select i1 %10, i1 %12, i1 false
  br i1 %13, label %14, label %49

14:                                               ; preds = %6
  %15 = and i8 %9, 127
  %16 = zext nneg i8 %15 to i32
  %17 = shl nuw nsw i32 %16, 3
  %18 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %17
  br label %19

19:                                               ; preds = %36, %14
  %20 = phi i32 [ 0, %14 ], [ %37, %36 ]
  %21 = icmp eq i32 %20, 8
  br i1 %21, label %22, label %24

22:                                               ; preds = %19
  %23 = getelementptr inbounds nuw i8, ptr %8, i32 1
  br label %6, !llvm.loop !17

24:                                               ; preds = %19
  %25 = shl nuw nsw i32 %20, 1
  %26 = add nsw i32 %25, %1
  %27 = mul nsw i32 %26, 240
  %28 = add nsw i32 %27, %7
  %29 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %28
  %30 = getelementptr inbounds nuw i8, ptr %18, i32 %20
  %31 = load i8, ptr %30, align 1, !tbaa !13
  %32 = zext i8 %31 to i32
  br label %33

33:                                               ; preds = %38, %24
  %34 = phi i32 [ 0, %24 ], [ %48, %38 ]
  %35 = icmp eq i32 %34, 8
  br i1 %35, label %36, label %38

36:                                               ; preds = %33
  %37 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !18

38:                                               ; preds = %33
  %39 = lshr exact i32 128, %34
  %40 = and i32 %39, %32
  %41 = icmp eq i32 %40, 0
  %42 = select i1 %41, i16 %4, i16 %3
  %43 = shl nuw nsw i32 %34, 2
  %44 = getelementptr inbounds nuw i8, ptr %29, i32 %43
  store i16 %42, ptr %44, align 2, !tbaa !7
  %45 = getelementptr inbounds nuw i8, ptr %44, i32 2
  store i16 %42, ptr %45, align 2, !tbaa !7
  %46 = getelementptr inbounds nuw i8, ptr %44, i32 480
  store i16 %42, ptr %46, align 2, !tbaa !7
  %47 = getelementptr inbounds nuw i8, ptr %44, i32 482
  store i16 %42, ptr %47, align 2, !tbaa !7
  %48 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !19

49:                                               ; preds = %6
  %50 = add nsw i32 %7, -1
  %51 = add nsw i32 %1, 15
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %50, i32 noundef %51) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_rect(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i16 noundef zeroext %5) local_unnamed_addr #1 {
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %4, i16 noundef zeroext %5) #7
  %7 = add nsw i32 %3, %1
  %8 = sub i32 %7, %4
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %8, i32 noundef %2, i32 noundef %4, i16 noundef zeroext %5) #7
  %9 = add nsw i32 %4, %1
  %10 = shl nsw i32 %4, 1
  %11 = sub nsw i32 %3, %10
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %9, i32 noundef %4, i32 noundef %11, i16 noundef zeroext %5) #7
  %12 = add nsw i32 %2, %0
  %13 = sub i32 %12, %4
  tail call void @gfx_fill(i32 noundef %13, i32 noundef %9, i32 noundef %4, i32 noundef %11, i16 noundef zeroext %5) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_blit(i32 noundef %0, i32 noundef %1, ptr noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #1 {
  %6 = icmp slt i32 %0, 0
  %7 = and i32 %0, 1
  %8 = sub nsw i32 %7, %0
  %9 = select i1 %6, i32 %7, i32 %0
  %10 = select i1 %6, i32 %8, i32 0
  %11 = sub nsw i32 %3, %10
  %12 = icmp slt i32 %1, 0
  %13 = sub nsw i32 0, %1
  %14 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %15 = tail call i32 @llvm.smin.i32(i32 %1, i32 0)
  %16 = add i32 %4, %15
  %17 = add nsw i32 %11, %9
  %18 = icmp sgt i32 %17, 240
  %19 = sub nsw i32 240, %9
  %20 = select i1 %18, i32 %19, i32 %11
  %21 = and i32 %20, -2
  %22 = add i32 %16, %14
  %23 = icmp sgt i32 %22, 240
  %24 = sub nsw i32 240, %14
  %25 = select i1 %23, i32 %24, i32 %16
  %26 = icmp slt i32 %20, 2
  br i1 %26, label %58, label %27

27:                                               ; preds = %5
  %28 = icmp slt i32 %25, 1
  br i1 %28, label %58, label %29

29:                                               ; preds = %27, %37
  %30 = phi ptr [ %38, %37 ], [ %2, %27 ]
  %31 = phi i32 [ %39, %37 ], [ 0, %27 ]
  %32 = icmp ult i32 %31, %13
  %33 = select i1 %12, i1 %32, i1 false
  br i1 %33, label %37, label %34

34:                                               ; preds = %29
  %35 = getelementptr i16, ptr %30, i32 %10
  %36 = shl nuw i32 %21, 1
  br label %40

37:                                               ; preds = %29
  %38 = getelementptr i16, ptr %30, i32 %3
  %39 = add nuw nsw i32 %31, 1
  br label %29, !llvm.loop !20

40:                                               ; preds = %34, %49
  %41 = phi ptr [ %56, %49 ], [ %35, %34 ]
  %42 = phi i32 [ %57, %49 ], [ 0, %34 ]
  %43 = icmp eq i32 %42, %25
  br i1 %43, label %44, label %49

44:                                               ; preds = %40
  %45 = add nsw i32 %9, -1
  %46 = add i32 %45, %21
  %47 = add nsw i32 %14, -1
  %48 = add i32 %47, %25
  tail call void @gfx_damage(i32 noundef %9, i32 noundef %14, i32 noundef %46, i32 noundef %48) #7
  br label %58

49:                                               ; preds = %40
  %50 = add nuw nsw i32 %42, %14
  %51 = mul nuw nsw i32 %50, 240
  %52 = add nuw nsw i32 %51, %9
  %53 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %52
  %54 = ptrtoint ptr %53 to i32
  %55 = ptrtoint ptr %41 to i32
  tail call void @gdma_copy(i32 noundef %54, i32 noundef %55, i32 noundef %36) #6
  %56 = getelementptr i16, ptr %41, i32 %3
  %57 = add nuw i32 %42, 1
  br label %40, !llvm.loop !21

58:                                               ; preds = %5, %27, %44
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local void @gfx_sprite(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2, i16 noundef zeroext %3, i16 noundef zeroext %4, ptr noundef writeonly captures(none) %5) local_unnamed_addr #4 {
  br label %7

7:                                                ; preds = %19, %6
  %8 = phi i32 [ 0, %6 ], [ %20, %19 ]
  %9 = phi i32 [ 0, %6 ], [ %16, %19 ]
  %10 = icmp slt i32 %8, %2
  br i1 %10, label %12, label %11

11:                                               ; preds = %7
  ret void

12:                                               ; preds = %7
  %13 = getelementptr inbounds nuw i32, ptr %0, i32 %8
  %14 = load i32, ptr %13, align 4, !tbaa !3
  br label %15

15:                                               ; preds = %21, %12
  %16 = phi i32 [ %9, %12 ], [ %26, %21 ]
  %17 = phi i32 [ 0, %12 ], [ %28, %21 ]
  %18 = icmp slt i32 %17, %1
  br i1 %18, label %21, label %19

19:                                               ; preds = %15
  %20 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !22

21:                                               ; preds = %15
  %22 = lshr exact i32 -2147483648, %17
  %23 = and i32 %22, %14
  %24 = icmp eq i32 %23, 0
  %25 = select i1 %24, i16 %4, i16 %3
  %26 = add nsw i32 %16, 1
  %27 = getelementptr inbounds i16, ptr %5, i32 %16
  store i16 %25, ptr %27, align 2, !tbaa !7
  %28 = add nuw nsw i32 %17, 1
  br label %15, !llvm.loop !23
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #5

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
!7 = !{!8, !8, i64 0}
!8 = !{!"short", !5, i64 0}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = !{!5, !5, i64 0}
!14 = distinct !{!14, !10, !11}
!15 = distinct !{!15, !10, !11}
!16 = distinct !{!16, !10, !11}
!17 = distinct !{!17, !10, !11}
!18 = distinct !{!18, !10, !11}
!19 = distinct !{!19, !10, !11}
!20 = distinct !{!20, !10, !11}
!21 = distinct !{!21, !10, !11}
!22 = distinct !{!22, !10, !11}
!23 = distinct !{!23, !10, !11}
