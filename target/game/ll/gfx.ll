; ModuleID = 'gfx.c'
source_filename = "gfx.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@dx0 = internal unnamed_addr global i32 0, align 4
@dy0 = internal unnamed_addr global i32 0, align 4
@dx1 = internal unnamed_addr global i32 0, align 4
@dy1 = internal unnamed_addr global i32 0, align 4
@fb = dso_local global [57600 x i16] zeroinitializer, align 2
@fillword = internal global i32 0, align 4
@fbfont = internal unnamed_addr constant [1024 x i8] c"\00\00\00\00\00\00\00\00<B\A5\81\A5\99B<<~\DB\FF\FF\DBf<l\FE\FE\FE|8\10\00\108|\FE|8\10\00\108T\FET\108\00\108|\FE\FE\108\00\00\00\0000\00\00\00\FF\FF\FF\E7\E7\FF\FF\FF8D\82\82\82D8\00\C7\BB}}}\BB\C7\FF\0F\03\05y\88\88\88p8DDD8\10|\100($$( \E0\C0<$<$$\E4\DC\18\10T8\EE8T\10\00\80\C0\E0\F0\E0\C0\80\00\01\03\07\0F\07\03\01\00\10\10\10|\10\10\10\10\FCHHH\E8\08P |\A8\A8h(((\008@0HH0\08p\00\00\00<<\00\00\00  p p  \00\FF\FF\00\00\00\00\00\00\00\00\00\00\00\00\FF\FF\03\03\03\03\03\03\03\03\C0\C0\C0\C0\C0\C0\C0\C0\00\10\10\FF\10\10\00\00\00 P\88P \00\00\00\00\00\00\108|\FE\FE|8\10\00\00\00\00\00\00\00\00\00\00\00\00    \00\00 \00PPP\00\00\00\00\00PP\F8P\F8PP\00 x\A0p(\F0 \00\C0\C8\10 @\98\18\00@\A0@\A8\90\98`\00\10 @\00\00\00\00\00\10 @@@ \10\00@ \10\10\10 @\00 \A8p p\A8 \00\00  \F8  \00\00\00\00\00\00\00  @\00\00\00x\00\00\00\00\00\00\00\00\00``\00\00\00\08\10 @\80\00p\88\98\A8\C8\88p\00 `\A0   \F8\00p\88\08\10`\80\F8\00p\88\080\08\88p\00\100P\90\F8\10\10\00\F8\80\E0\10\08\10\E0\000@\80\F0\88\88p\00\F8\88\10    \00p\88\88p\88\88p\00p\88\88x\08\10`\00\00\00 \00\00 \00\00\00\00 \00\00  @\00\10 @ \10\00\00\00\00\F8\00\F8\00\00\00\00@ \10 @\00\00p\88\08\10 \00 \00\00p\A8\A8\B0\80p\00 P\88\88\F8\88\88\00\F0HHpHH\F0\000H\80\80\80H0\00\E0PHHHP\E0\00\F8\80\80\F0\80\80\F8\00\F8\80\80\F0\80\80\80\00p\88\80\B8\88\88p\00\88\88\88\F8\88\88\88\00p     p\008\10\10\10\90\90`\00\88\90\A0\C0\A0\90\88\00\80\80\80\80\80\80\F8\00\88\D8\A8\A8\88\88\88\00\88\C8\C8\A8\98\98\88\00p\88\88\88\88\88p\00\F0\88\88\F0\80\80\80\00p\88\88\88\A8\90h\00\F0\88\88\F0\A0\90\88\00p\88\80p\08\88p\00\F8      \00\88\88\88\88\88\88p\00\88\88\88\88PP \00\88\88\88\A8\A8\D8\88\00\88\88P P\88\88\00\88\88\88p   \00\F8\08\10 @\80\F8\00p@@@@@p\00\00\00\80@ \10\08\00p\10\10\10\10\10p\00 P\88\00\00\00\00\00\00\00\00\00\00\00\F8\00@ \10\00\00\00\00\00\00\00p\08x\88x\00\80\80\B0\C8\88\C8\B0\00\00\00p\88\80\88p\00\08\08h\98\88\98h\00\00\00p\88\F8\80p\00\10( \F8   \00\00\00h\98\98h\08p\80\80\F0\88\88\88\88\00 \00`   p\00\10\000\10\10\10\90`@@HP`PH\00`     p\00\00\00\D0\A8\A8\A8\A8\00\00\00\B0\C8\88\88\88\00\00\00p\88\88\88p\00\00\00\B0\C8\C8\B0\80\80\00\00h\98\98h\08\08\00\00\B0\C8\80\80\80\00\00\00x\80\F0\08\F0\00@@\F0@@H0\00\00\00\90\90\90\90h\00\00\00\88\88\88P \00\00\00\88\A8\A8\A8P\00\00\00\88P P\88\00\00\00\88\88\98h\08p\00\00\F8\10 @\F8\00\18  @  \18\00   \00   \00\C0  \10  \C0\00@\A8\10\00\00\00\00\00\00\00 P\F8\00\00\00", align 1
@half_tab = internal unnamed_addr global [241 x i8] zeroinitializer, align 1

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
  tail call void @lcd_flush(i32 noundef %2, i32 noundef %5, i32 noundef %1, i32 noundef %6) #8
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
  tail call void @gdma_fill(i32 noundef ptrtoint (ptr @fb to i32), i32 noundef %3, i32 noundef 115200) #8
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 0, i32 noundef 239, i32 noundef 239) #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i16 noundef zeroext %4) local_unnamed_addr #1 {
  %6 = tail call i32 @llvm.smin.i32(i32 %0, i32 0)
  %7 = add nsw i32 %2, %6
  %8 = tail call i32 @llvm.smax.i32(i32 %0, i32 0)
  %9 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %10 = tail call i32 @llvm.smin.i32(i32 %1, i32 0)
  %11 = add i32 %3, %10
  %12 = add nsw i32 %7, %8
  %13 = icmp sgt i32 %12, 240
  %14 = sub nsw i32 240, %8
  %15 = select i1 %13, i32 %14, i32 %7
  %16 = add i32 %11, %9
  %17 = icmp sgt i32 %16, 240
  %18 = sub nsw i32 240, %9
  %19 = select i1 %17, i32 %18, i32 %11
  %20 = icmp slt i32 %15, 1
  br i1 %20, label %54, label %21

21:                                               ; preds = %5
  %22 = icmp slt i32 %19, 1
  br i1 %22, label %54, label %23

23:                                               ; preds = %21
  %24 = mul nuw nsw i32 %9, 240
  %25 = add nuw nsw i32 %24, %8
  %26 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %25
  %27 = ptrtoint ptr %26 to i32
  %28 = and i32 %27, 2
  %29 = and i32 %15, 1
  %30 = or disjoint i32 %28, %29
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %32, label %36

32:                                               ; preds = %23
  %33 = zext i16 %4 to i32
  %34 = mul nuw i32 %33, 65537
  store i32 %34, ptr @fillword, align 4, !tbaa !3
  %35 = tail call fastcc i32 @halfof(i32 noundef %15) #9
  tail call void @gdma_rows(i32 noundef %27, i32 noundef ptrtoint (ptr @fillword to i32), i32 noundef %35, i32 noundef %19, i32 noundef 480, i32 noundef 0) #8
  br label %49

36:                                               ; preds = %23, %43
  %37 = phi ptr [ %45, %43 ], [ %26, %23 ]
  %38 = phi i32 [ %44, %43 ], [ 0, %23 ]
  %39 = icmp eq i32 %38, %19
  br i1 %39, label %49, label %40

40:                                               ; preds = %36, %46
  %41 = phi i32 [ %48, %46 ], [ 0, %36 ]
  %42 = icmp eq i32 %41, %15
  br i1 %42, label %43, label %46

43:                                               ; preds = %40
  %44 = add nuw i32 %38, 1
  %45 = getelementptr inbounds nuw i8, ptr %37, i32 480
  br label %36, !llvm.loop !7

46:                                               ; preds = %40
  %47 = getelementptr inbounds nuw i16, ptr %37, i32 %41
  store i16 %4, ptr %47, align 2, !tbaa !10
  %48 = add nuw i32 %41, 1
  br label %40, !llvm.loop !12

49:                                               ; preds = %36, %32
  %50 = add nsw i32 %8, -1
  %51 = add i32 %50, %15
  %52 = add nsw i32 %9, -1
  %53 = add i32 %52, %19
  tail call void @gfx_damage(i32 noundef %8, i32 noundef %9, i32 noundef %51, i32 noundef %53) #9
  br label %54

54:                                               ; preds = %5, %21, %49
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc range(i32 0, 256) i32 @halfof(i32 noundef range(i32 1, -2147483648) %0) unnamed_addr #3 {
  %2 = load i8, ptr getelementptr inbounds nuw (i8, ptr @half_tab, i32 2), align 1, !tbaa !13
  %3 = icmp eq i8 %2, 0
  br i1 %3, label %4, label %14

4:                                                ; preds = %1, %8
  %5 = phi i32 [ %12, %8 ], [ 0, %1 ]
  %6 = phi i32 [ %13, %8 ], [ 0, %1 ]
  %7 = icmp eq i32 %6, 241
  br i1 %7, label %14, label %8

8:                                                ; preds = %4
  %9 = trunc i32 %5 to i8
  %10 = getelementptr inbounds nuw [241 x i8], ptr @half_tab, i32 0, i32 %6
  store i8 %9, ptr %10, align 1, !tbaa !13
  %11 = and i32 %6, 1
  %12 = add i32 %11, %5
  %13 = add nuw nsw i32 %6, 1
  br label %4, !llvm.loop !14

14:                                               ; preds = %4, %1
  %15 = getelementptr inbounds nuw [241 x i8], ptr @half_tab, i32 0, i32 %0
  %16 = load i8, ptr %15, align 1, !tbaa !13
  %17 = zext i8 %16 to i32
  ret i32 %17
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define dso_local void @gfx_text(i32 noundef %0, i32 noundef %1, ptr noundef readonly captures(none) %2, i16 noundef zeroext %3, i16 noundef zeroext %4) local_unnamed_addr #4 {
  br label %6

6:                                                ; preds = %22, %5
  %7 = phi i32 [ %0, %5 ], [ %11, %22 ]
  %8 = phi ptr [ %2, %5 ], [ %23, %22 ]
  %9 = load i8, ptr %8, align 1, !tbaa !13
  %10 = icmp ne i8 %9, 0
  %11 = add nsw i32 %7, 8
  %12 = icmp slt i32 %7, 233
  %13 = select i1 %10, i1 %12, i1 false
  br i1 %13, label %14, label %45

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
  br label %6, !llvm.loop !15

24:                                               ; preds = %19
  %25 = add nsw i32 %20, %1
  %26 = mul nsw i32 %25, 240
  %27 = add nsw i32 %26, %7
  %28 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %27
  %29 = getelementptr inbounds nuw i8, ptr %18, i32 %20
  %30 = load i8, ptr %29, align 1, !tbaa !13
  %31 = zext i8 %30 to i32
  br label %32

32:                                               ; preds = %38, %24
  %33 = phi i32 [ 1, %24 ], [ %44, %38 ]
  %34 = phi i32 [ 7, %24 ], [ %43, %38 ]
  %35 = icmp sgt i32 %34, -1
  br i1 %35, label %38, label %36

36:                                               ; preds = %32
  %37 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !16

38:                                               ; preds = %32
  %39 = and i32 %33, %31
  %40 = icmp eq i32 %39, 0
  %41 = select i1 %40, i16 %4, i16 %3
  %42 = getelementptr inbounds nuw i16, ptr %28, i32 %34
  store i16 %41, ptr %42, align 2, !tbaa !10
  %43 = add nsw i32 %34, -1
  %44 = shl i32 %33, 1
  br label %32, !llvm.loop !17

45:                                               ; preds = %6
  %46 = add nsw i32 %7, -1
  %47 = add nsw i32 %1, 7
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %46, i32 noundef %47) #9
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define dso_local void @gfx_text2(i32 noundef %0, i32 noundef %1, ptr noundef readonly captures(none) %2, i16 noundef zeroext %3, i16 noundef zeroext %4) local_unnamed_addr #4 {
  br label %6

6:                                                ; preds = %22, %5
  %7 = phi i32 [ %0, %5 ], [ %11, %22 ]
  %8 = phi ptr [ %2, %5 ], [ %23, %22 ]
  %9 = load i8, ptr %8, align 1, !tbaa !13
  %10 = icmp ne i8 %9, 0
  %11 = add nsw i32 %7, 16
  %12 = icmp slt i32 %7, 225
  %13 = select i1 %10, i1 %12, i1 false
  br i1 %13, label %14, label %50

14:                                               ; preds = %6
  %15 = and i8 %9, 127
  %16 = zext nneg i8 %15 to i32
  %17 = shl nuw nsw i32 %16, 3
  %18 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %17
  br label %19

19:                                               ; preds = %37, %14
  %20 = phi i32 [ 0, %14 ], [ %38, %37 ]
  %21 = icmp eq i32 %20, 8
  br i1 %21, label %22, label %24

22:                                               ; preds = %19
  %23 = getelementptr inbounds nuw i8, ptr %8, i32 1
  br label %6, !llvm.loop !18

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

33:                                               ; preds = %39, %24
  %34 = phi i32 [ 1, %24 ], [ %49, %39 ]
  %35 = phi i32 [ 7, %24 ], [ %48, %39 ]
  %36 = icmp sgt i32 %35, -1
  br i1 %36, label %39, label %37

37:                                               ; preds = %33
  %38 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !19

39:                                               ; preds = %33
  %40 = and i32 %34, %32
  %41 = icmp eq i32 %40, 0
  %42 = select i1 %41, i16 %4, i16 %3
  %43 = shl nuw nsw i32 %35, 2
  %44 = getelementptr inbounds nuw i8, ptr %29, i32 %43
  store i16 %42, ptr %44, align 2, !tbaa !10
  %45 = getelementptr inbounds nuw i8, ptr %44, i32 2
  store i16 %42, ptr %45, align 2, !tbaa !10
  %46 = getelementptr inbounds nuw i8, ptr %44, i32 480
  store i16 %42, ptr %46, align 2, !tbaa !10
  %47 = getelementptr inbounds nuw i8, ptr %44, i32 482
  store i16 %42, ptr %47, align 2, !tbaa !10
  %48 = add nsw i32 %35, -1
  %49 = shl i32 %34, 1
  br label %33, !llvm.loop !20

50:                                               ; preds = %6
  %51 = add nsw i32 %7, -1
  %52 = add nsw i32 %1, 15
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %51, i32 noundef %52) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_rect(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i16 noundef zeroext %5) local_unnamed_addr #1 {
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %4, i16 noundef zeroext %5) #9
  %7 = add nsw i32 %3, %1
  %8 = sub i32 %7, %4
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %8, i32 noundef %2, i32 noundef %4, i16 noundef zeroext %5) #9
  %9 = add nsw i32 %4, %1
  %10 = shl nsw i32 %4, 1
  %11 = sub nsw i32 %3, %10
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %9, i32 noundef %4, i32 noundef %11, i16 noundef zeroext %5) #9
  %12 = add nsw i32 %2, %0
  %13 = sub i32 %12, %4
  tail call void @gfx_fill(i32 noundef %13, i32 noundef %9, i32 noundef %4, i32 noundef %11, i16 noundef zeroext %5) #9
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
  br i1 %26, label %70, label %27

27:                                               ; preds = %5
  %28 = icmp slt i32 %25, 1
  br i1 %28, label %70, label %29

29:                                               ; preds = %27, %46
  %30 = phi ptr [ %47, %46 ], [ %2, %27 ]
  %31 = phi i32 [ %48, %46 ], [ 0, %27 ]
  %32 = icmp ult i32 %31, %13
  %33 = select i1 %12, i1 %32, i1 false
  br i1 %33, label %46, label %34

34:                                               ; preds = %29
  %35 = getelementptr i16, ptr %30, i32 %10
  %36 = ptrtoint ptr %35 to i32
  %37 = mul nuw nsw i32 %14, 240
  %38 = add nuw nsw i32 %37, %9
  %39 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %38
  %40 = ptrtoint ptr %39 to i32
  %41 = or i32 %36, %40
  %42 = and i32 %41, 3
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %49, label %44

44:                                               ; preds = %34
  %45 = shl nuw i32 %21, 1
  br label %52

46:                                               ; preds = %29
  %47 = getelementptr i16, ptr %30, i32 %3
  %48 = add nuw nsw i32 %31, 1
  br label %29, !llvm.loop !21

49:                                               ; preds = %34
  %50 = tail call fastcc i32 @halfof(i32 noundef %21) #9
  %51 = shl i32 %3, 1
  tail call void @gdma_rows(i32 noundef %40, i32 noundef %36, i32 noundef %50, i32 noundef %25, i32 noundef 480, i32 noundef %51) #8
  br label %65

52:                                               ; preds = %44, %56
  %53 = phi ptr [ %63, %56 ], [ %35, %44 ]
  %54 = phi i32 [ %64, %56 ], [ 0, %44 ]
  %55 = icmp eq i32 %54, %25
  br i1 %55, label %65, label %56

56:                                               ; preds = %52
  %57 = add nuw nsw i32 %54, %14
  %58 = mul nuw nsw i32 %57, 240
  %59 = add nuw nsw i32 %58, %9
  %60 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %59
  %61 = ptrtoint ptr %60 to i32
  %62 = ptrtoint ptr %53 to i32
  tail call void @gdma_copy(i32 noundef %61, i32 noundef %62, i32 noundef %45) #8
  %63 = getelementptr i16, ptr %53, i32 %3
  %64 = add nuw i32 %54, 1
  br label %52, !llvm.loop !22

65:                                               ; preds = %52, %49
  %66 = add nsw i32 %9, -1
  %67 = add i32 %66, %21
  %68 = add nsw i32 %14, -1
  %69 = add i32 %68, %25
  tail call void @gfx_damage(i32 noundef %9, i32 noundef %14, i32 noundef %67, i32 noundef %69) #9
  br label %70

70:                                               ; preds = %5, %27, %65
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local void @gfx_cell_spans(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2, i16 noundef zeroext %3, ptr noundef writeonly captures(none) %4) local_unnamed_addr #5 {
  %6 = getelementptr inbounds i8, ptr %4, i32 1
  br label %7

7:                                                ; preds = %45, %5
  %8 = phi i32 [ 0, %5 ], [ %49, %45 ]
  %9 = icmp slt i32 %8, %2
  br i1 %9, label %11, label %10

10:                                               ; preds = %7
  ret void

11:                                               ; preds = %7
  %12 = mul nsw i32 %8, %1
  %13 = getelementptr inbounds i16, ptr %0, i32 %12
  br label %14

14:                                               ; preds = %21, %11
  %15 = phi i32 [ %1, %11 ], [ %26, %21 ]
  %16 = phi i32 [ -1, %11 ], [ %27, %21 ]
  %17 = phi i32 [ 0, %11 ], [ %28, %21 ]
  %18 = icmp slt i32 %17, %1
  br i1 %18, label %21, label %19

19:                                               ; preds = %14
  %20 = icmp slt i32 %16, 0
  br i1 %20, label %29, label %32

21:                                               ; preds = %14
  %22 = getelementptr inbounds nuw i16, ptr %13, i32 %17
  %23 = load i16, ptr %22, align 2, !tbaa !10
  %24 = icmp eq i16 %23, %3
  %25 = tail call i32 @llvm.smin.i32(i32 %17, i32 %15)
  %26 = select i1 %24, i32 %15, i32 %25
  %27 = select i1 %24, i32 %16, i32 %17
  %28 = add nuw nsw i32 %17, 1
  br label %14, !llvm.loop !23

29:                                               ; preds = %19
  %30 = shl nuw nsw i32 %8, 1
  %31 = getelementptr inbounds nuw i8, ptr %4, i32 %30
  store i8 0, ptr %31, align 1, !tbaa !13
  br label %45

32:                                               ; preds = %19
  %33 = and i32 %15, -2
  %34 = add nuw nsw i32 %16, 2
  %35 = sub i32 %34, %33
  %36 = and i32 %35, -2
  %37 = add nsw i32 %36, %33
  %38 = icmp sgt i32 %37, %1
  %39 = sub nsw i32 %1, %33
  %40 = select i1 %38, i32 %39, i32 %36
  %41 = trunc i32 %33 to i8
  %42 = shl nuw nsw i32 %8, 1
  %43 = getelementptr inbounds nuw i8, ptr %4, i32 %42
  store i8 %41, ptr %43, align 1, !tbaa !13
  %44 = trunc i32 %40 to i8
  br label %45

45:                                               ; preds = %32, %29
  %46 = phi i32 [ %42, %32 ], [ %30, %29 ]
  %47 = phi i8 [ %44, %32 ], [ 0, %29 ]
  %48 = getelementptr inbounds i8, ptr %6, i32 %46
  store i8 %47, ptr %48, align 1, !tbaa !13
  %49 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !24
}

; Function Attrs: minsize nounwind optsize
define dso_local void @gfx_blit_spans(i32 noundef %0, i32 noundef %1, ptr noundef %2, i32 noundef %3, i32 noundef %4, ptr noundef readonly captures(none) %5) local_unnamed_addr #1 {
  %7 = mul nsw i32 %1, 240
  %8 = add nsw i32 %7, %0
  %9 = shl nsw i32 %8, 1
  %10 = add i32 %9, ptrtoint (ptr @fb to i32)
  %11 = ptrtoint ptr %2 to i32
  %12 = shl i32 %3, 1
  br label %13

13:                                               ; preds = %48, %6
  %14 = phi i32 [ 0, %6 ], [ %51, %48 ]
  %15 = phi i32 [ %11, %6 ], [ %50, %48 ]
  %16 = phi i32 [ %10, %6 ], [ %49, %48 ]
  %17 = icmp slt i32 %14, %4
  br i1 %17, label %23, label %18

18:                                               ; preds = %13
  %19 = add i32 %0, -1
  %20 = add i32 %19, %3
  %21 = add i32 %1, -1
  %22 = add i32 %21, %4
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %20, i32 noundef %22) #9
  ret void

23:                                               ; preds = %13
  %24 = add nsw i32 %14, %1
  %25 = shl nuw nsw i32 %14, 1
  %26 = getelementptr inbounds nuw i8, ptr %5, i32 %25
  %27 = getelementptr inbounds nuw i8, ptr %26, i32 1
  %28 = load i8, ptr %27, align 1, !tbaa !13
  %29 = icmp ne i8 %28, 0
  %30 = icmp ult i32 %24, 240
  %31 = select i1 %29, i1 %30, i1 false
  br i1 %31, label %32, label %48

32:                                               ; preds = %23
  %33 = zext i8 %28 to i32
  %34 = load i8, ptr %26, align 1, !tbaa !13
  %35 = zext i8 %34 to i32
  %36 = add nsw i32 %0, %35
  %37 = add nsw i32 %36, %33
  %38 = tail call i32 @llvm.smax.i32(i32 %36, i32 0)
  %39 = tail call i32 @llvm.smin.i32(i32 %37, i32 240)
  %40 = icmp sgt i32 %39, %38
  br i1 %40, label %41, label %48

41:                                               ; preds = %32
  %42 = sub nsw i32 %38, %0
  %43 = shl i32 %42, 1
  %44 = add i32 %43, %16
  %45 = add i32 %43, %15
  %46 = sub nsw i32 %39, %38
  %47 = shl nuw nsw i32 %46, 1
  tail call void @gdma_copy(i32 noundef %44, i32 noundef %45, i32 noundef %47) #8
  br label %48

48:                                               ; preds = %32, %41, %23
  %49 = add i32 %16, 480
  %50 = add i32 %15, %12
  %51 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !25
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local void @gfx_disc_cell(i32 noundef %0, i32 noundef %1, i16 noundef zeroext %2, i16 noundef zeroext %3, ptr noundef writeonly captures(none) %4) local_unnamed_addr #6 {
  %6 = shl nsw i32 %1, 2
  %7 = mul nsw i32 %6, %1
  br label %8

8:                                                ; preds = %22, %5
  %9 = phi i32 [ 0, %5 ], [ %23, %22 ]
  %10 = icmp slt i32 %9, %0
  br i1 %10, label %12, label %11

11:                                               ; preds = %8
  ret void

12:                                               ; preds = %8
  %13 = shl nuw nsw i32 %9, 1
  %14 = sub nsw i32 %13, %0
  %15 = add nsw i32 %14, 1
  %16 = mul nsw i32 %15, %15
  %17 = mul nsw i32 %9, %0
  %18 = getelementptr i16, ptr %4, i32 %17
  br label %19

19:                                               ; preds = %24, %12
  %20 = phi i32 [ 0, %12 ], [ %33, %24 ]
  %21 = icmp eq i32 %20, %0
  br i1 %21, label %22, label %24

22:                                               ; preds = %19
  %23 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !26

24:                                               ; preds = %19
  %25 = shl nuw nsw i32 %20, 1
  %26 = sub nsw i32 %25, %0
  %27 = add nsw i32 %26, 1
  %28 = mul nsw i32 %27, %27
  %29 = add nuw nsw i32 %28, %16
  %30 = icmp sgt i32 %29, %7
  %31 = select i1 %30, i16 %3, i16 %2
  %32 = getelementptr i16, ptr %18, i32 %20
  store i16 %31, ptr %32, align 2, !tbaa !10
  %33 = add nuw i32 %20, 1
  br label %19, !llvm.loop !27
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local void @gfx_glyph_cell(i32 noundef %0, i16 noundef zeroext %1, i16 noundef zeroext %2, ptr noundef writeonly captures(none) %3) local_unnamed_addr #6 {
  %5 = shl i32 %0, 3
  %6 = and i32 %5, 1016
  %7 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %6
  br label %8

8:                                                ; preds = %22, %4
  %9 = phi i32 [ 0, %4 ], [ %24, %22 ]
  %10 = phi i32 [ 0, %4 ], [ %23, %22 ]
  %11 = icmp eq i32 %9, 8
  br i1 %11, label %12, label %13

12:                                               ; preds = %8
  ret void

13:                                               ; preds = %8
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 %9
  %15 = load i8, ptr %14, align 1, !tbaa !13
  %16 = zext i8 %15 to i32
  %17 = getelementptr inbounds nuw i16, ptr %3, i32 %10
  br label %18

18:                                               ; preds = %25, %13
  %19 = phi i32 [ 1, %13 ], [ %31, %25 ]
  %20 = phi i32 [ 7, %13 ], [ %30, %25 ]
  %21 = icmp sgt i32 %20, -1
  br i1 %21, label %25, label %22

22:                                               ; preds = %18
  %23 = add nuw nsw i32 %10, 8
  %24 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !28

25:                                               ; preds = %18
  %26 = and i32 %19, %16
  %27 = icmp eq i32 %26, 0
  %28 = select i1 %27, i16 %2, i16 %1
  %29 = getelementptr inbounds nuw i16, ptr %17, i32 %20
  store i16 %28, ptr %29, align 2, !tbaa !10
  %30 = add nsw i32 %20, -1
  %31 = shl i32 %19, 1
  br label %18, !llvm.loop !29
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local void @gfx_sprite(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2, i16 noundef zeroext %3, i16 noundef zeroext %4, ptr noundef writeonly captures(none) %5) local_unnamed_addr #5 {
  %7 = sub nsw i32 32, %1
  %8 = shl nuw i32 1, %7
  br label %9

9:                                                ; preds = %22, %6
  %10 = phi i32 [ 0, %6 ], [ %24, %22 ]
  %11 = phi i32 [ 0, %6 ], [ %23, %22 ]
  %12 = icmp slt i32 %10, %2
  br i1 %12, label %14, label %13

13:                                               ; preds = %9
  ret void

14:                                               ; preds = %9
  %15 = getelementptr inbounds nuw i32, ptr %0, i32 %10
  %16 = load i32, ptr %15, align 4, !tbaa !3
  %17 = getelementptr i16, ptr %5, i32 %11
  br label %18

18:                                               ; preds = %25, %14
  %19 = phi i32 [ %8, %14 ], [ %31, %25 ]
  %20 = phi i32 [ %1, %14 ], [ %26, %25 ]
  %21 = icmp sgt i32 %20, 0
  br i1 %21, label %25, label %22

22:                                               ; preds = %18
  %23 = add nsw i32 %11, %1
  %24 = add nuw nsw i32 %10, 1
  br label %9, !llvm.loop !30

25:                                               ; preds = %18
  %26 = add nsw i32 %20, -1
  %27 = and i32 %19, %16
  %28 = icmp eq i32 %27, 0
  %29 = select i1 %28, i16 %4, i16 %3
  %30 = getelementptr i16, ptr %17, i32 %26
  store i16 %29, ptr %30, align 2, !tbaa !10
  %31 = shl i32 %19, 1
  br label %18, !llvm.loop !31
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #7

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #9 = { minsize nobuiltin optsize "no-builtins" }

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
!10 = !{!11, !11, i64 0}
!11 = !{!"short", !5, i64 0}
!12 = distinct !{!12, !8, !9}
!13 = !{!5, !5, i64 0}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
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
