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
  tail call void @lcd_flush(i32 noundef %2, i32 noundef %5, i32 noundef %1, i32 noundef %6) #5
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
  tail call void @gdma_fill(i32 noundef ptrtoint (ptr @fb to i32), i32 noundef %3, i32 noundef 115200) #5
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 0, i32 noundef 239, i32 noundef 239) #6
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
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %19, i32 noundef %21) #6
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
  tail call void @gdma_fill(i32 noundef %27, i32 noundef %12, i32 noundef %13) #5
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

6:                                                ; preds = %19, %5
  %7 = phi i32 [ %0, %5 ], [ %21, %19 ]
  %8 = phi ptr [ %2, %5 ], [ %20, %19 ]
  %9 = load i8, ptr %8, align 1, !tbaa !13
  %10 = icmp eq i8 %9, 0
  br i1 %10, label %42, label %11

11:                                               ; preds = %6
  %12 = and i8 %9, 127
  %13 = zext nneg i8 %12 to i32
  %14 = shl nuw nsw i32 %13, 3
  %15 = getelementptr inbounds nuw [1024 x i8], ptr @fbfont, i32 0, i32 %14
  br label %16

16:                                               ; preds = %33, %11
  %17 = phi i32 [ 0, %11 ], [ %34, %33 ]
  %18 = icmp eq i32 %17, 8
  br i1 %18, label %19, label %22

19:                                               ; preds = %16
  %20 = getelementptr inbounds nuw i8, ptr %8, i32 1
  %21 = add nsw i32 %7, 8
  br label %6, !llvm.loop !14

22:                                               ; preds = %16
  %23 = add nsw i32 %17, %1
  %24 = mul nsw i32 %23, 240
  %25 = add nsw i32 %24, %7
  %26 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %25
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 %17
  %28 = load i8, ptr %27, align 1, !tbaa !13
  %29 = zext i8 %28 to i32
  br label %30

30:                                               ; preds = %35, %22
  %31 = phi i32 [ 0, %22 ], [ %41, %35 ]
  %32 = icmp eq i32 %31, 8
  br i1 %32, label %33, label %35

33:                                               ; preds = %30
  %34 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !15

35:                                               ; preds = %30
  %36 = lshr exact i32 128, %31
  %37 = and i32 %36, %29
  %38 = icmp eq i32 %37, 0
  %39 = select i1 %38, i16 %4, i16 %3
  %40 = getelementptr inbounds nuw i16, ptr %26, i32 %31
  store i16 %39, ptr %40, align 2, !tbaa !7
  %41 = add nuw nsw i32 %31, 1
  br label %30, !llvm.loop !16

42:                                               ; preds = %6
  %43 = add nsw i32 %7, -1
  %44 = add nsw i32 %1, 7
  tail call void @gfx_damage(i32 noundef %0, i32 noundef %1, i32 noundef %43, i32 noundef %44) #6
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
