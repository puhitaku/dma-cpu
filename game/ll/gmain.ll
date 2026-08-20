; ModuleID = 'gmain.c'
source_filename = "gmain.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [16 x i8] c"GAMEPICO: boot\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"GAMEPICO: lcd up\0A\00", align 1
@.str.2 = private unnamed_addr constant [27 x i8] c"GAMEPICO: test card shown\0A\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"joy a=\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c" b=\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"beat \00", align 1
@bars = internal unnamed_addr constant [8 x i16] [i16 -1, i16 -32, i16 2047, i16 2016, i16 -2017, i16 -2048, i16 31, i16 0], align 2
@fb = external dso_local local_unnamed_addr global [57600 x i16], align 2
@.str.7 = private unnamed_addr constant [19 x i8] c"GAMEPICO test card\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @gmain() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #3
  tail call void @lcd_init() #3
  tail call void @uputs(ptr noundef nonnull @.str.1) #3
  tail call void @gfx_clear(i16 noundef zeroext 0) #3
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %8, %4 ]
  %3 = icmp eq i32 %2, 8
  br i1 %3, label %9, label %4

4:                                                ; preds = %1
  %5 = mul nuw nsw i32 %2, 30
  %6 = getelementptr inbounds nuw [8 x i16], ptr @bars, i32 0, i32 %2
  %7 = load i16, ptr %6, align 2, !tbaa !3
  tail call void @gfx_fill(i32 noundef %5, i32 noundef 0, i32 noundef 30, i32 noundef 180, i16 noundef zeroext %7) #3
  %8 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !7

9:                                                ; preds = %1, %25
  %10 = phi i32 [ %26, %25 ], [ 0, %1 ]
  %11 = icmp eq i32 %10, 240
  br i1 %11, label %32, label %12

12:                                               ; preds = %9
  %13 = add nuw nsw i32 %10, 8
  %14 = and i32 %13, 248
  %15 = shl nuw nsw i32 %14, 8
  %16 = shl nuw nsw i32 %13, 3
  %17 = and i32 %16, 2016
  %18 = or disjoint i32 %15, %17
  %19 = lshr exact i32 %14, 3
  %20 = or disjoint i32 %18, %19
  %21 = trunc nuw i32 %20 to i16
  br label %22

22:                                               ; preds = %27, %12
  %23 = phi i32 [ 180, %12 ], [ %31, %27 ]
  %24 = icmp eq i32 %23, 210
  br i1 %24, label %25, label %27

25:                                               ; preds = %22
  %26 = add nuw nsw i32 %10, 1
  br label %9, !llvm.loop !10

27:                                               ; preds = %22
  %28 = mul nuw nsw i32 %23, 240
  %29 = add nuw nsw i32 %28, %10
  %30 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %29
  store i16 %21, ptr %30, align 2, !tbaa !3
  %31 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !11

32:                                               ; preds = %9
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 180, i32 noundef 239, i32 noundef 209) #3
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 210, i32 noundef 240, i32 noundef 30, i16 noundef zeroext 4232) #3
  tail call void @gfx_text(i32 noundef 8, i32 noundef 220, ptr noundef nonnull @.str.7, i16 noundef zeroext -1, i16 noundef zeroext 4232) #3
  tail call void @gfx_present() #3
  tail call void @uputs(ptr noundef nonnull @.str.2) #3
  %33 = tail call i32 @now_us() #3
  br label %34

34:                                               ; preds = %54, %32
  %35 = phi i32 [ %56, %54 ], [ 0, %32 ]
  %36 = phi i32 [ %55, %54 ], [ %33, %32 ]
  %37 = phi i32 [ %49, %54 ], [ 31, %32 ]
  %38 = phi i32 [ %50, %54 ], [ 31, %32 ]
  br label %39

39:                                               ; preds = %34, %48
  %40 = phi i32 [ %49, %48 ], [ %37, %34 ]
  %41 = phi i32 [ %50, %48 ], [ %38, %34 ]
  %42 = tail call fastcc i32 @joys(i32 noundef 2) #4
  %43 = tail call fastcc i32 @joys(i32 noundef 7) #4
  %44 = icmp eq i32 %42, %41
  %45 = icmp eq i32 %43, %40
  %46 = select i1 %44, i1 %45, i1 false
  br i1 %46, label %48, label %47

47:                                               ; preds = %39
  tail call void @uputs(ptr noundef nonnull @.str.3) #3
  tail call void @uputhex(i32 noundef %42) #3
  tail call void @uputs(ptr noundef nonnull @.str.4) #3
  tail call void @uputhex(i32 noundef %43) #3
  tail call void @uputs(ptr noundef nonnull @.str.5) #3
  br label %48

48:                                               ; preds = %39, %47
  %49 = phi i32 [ %43, %47 ], [ %40, %39 ]
  %50 = phi i32 [ %42, %47 ], [ %41, %39 ]
  %51 = tail call i32 @now_us() #3
  %52 = sub i32 %51, %36
  %53 = icmp ugt i32 %52, 999999
  br i1 %53, label %54, label %39, !llvm.loop !12

54:                                               ; preds = %48
  %55 = add i32 %36, 1000000
  %56 = add i32 %35, 1
  tail call void @uputs(ptr noundef nonnull @.str.6) #3
  tail call void @uputn(i32 noundef %56) #3
  tail call void @uputs(ptr noundef nonnull @.str.5) #3
  br label %34, !llvm.loop !12
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @lcd_init() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @now_us() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @joys(i32 noundef range(i32 2, 8) %0) unnamed_addr #2 {
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi i32 [ 0, %1 ], [ %11, %7 ]
  %4 = phi i32 [ 0, %1 ], [ %12, %7 ]
  %5 = icmp eq i32 %4, 5
  br i1 %5, label %6, label %7

6:                                                ; preds = %2
  ret i32 %3

7:                                                ; preds = %2
  %8 = add nuw nsw i32 %4, %0
  %9 = tail call i32 @gpio_in_pu(i32 noundef %8) #3
  %10 = shl i32 %9, %4
  %11 = or i32 %10, %3
  %12 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !13
}

; Function Attrs: minsize optsize
declare dso_local void @uputhex(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @gpio_in_pu(i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"short", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !9}
!13 = distinct !{!13, !8, !9}
