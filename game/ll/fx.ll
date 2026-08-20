; ModuleID = 'fx.c'
source_filename = "fx.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@pioprog = internal unnamed_addr constant [12 x i16] [i16 28673, i16 6208, i16 24577, i16 -6098, i16 24577, i16 2116, i16 28673, i16 -2002, i16 25121, i16 4395, i16 5128, i16 -23486], align 2
@sndctrl = dso_local local_unnamed_addr global i32 0, align 4
@snd_frames = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local void @fx_init() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 12, %0 ], [ %5, %4 ]
  %3 = icmp eq i32 %2, 16
  br i1 %3, label %6, label %4

4:                                                ; preds = %1
  tail call void @gpio_fn(i32 noundef %2, i32 noundef 12294) #5
  %5 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !3

6:                                                ; preds = %1, %11
  %7 = phi i32 [ %18, %11 ], [ 0, %1 ]
  %8 = icmp eq i32 %7, 12
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  store volatile i32 9287680, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !6
  store volatile i32 28672, ptr inttoptr (i32 1344274636 to ptr), align 4, !tbaa !6
  store volatile i32 131072, ptr inttoptr (i32 1344274640 to ptr), align 16, !tbaa !6
  store volatile i32 1074803727, ptr inttoptr (i32 1344274652 to ptr), align 4, !tbaa !6
  store volatile i32 7, ptr inttoptr (i32 1344274648 to ptr), align 8, !tbaa !6
  store volatile i32 1638400, ptr inttoptr (i32 1344274656 to ptr), align 32, !tbaa !6
  store volatile i32 46080, ptr inttoptr (i32 1344274660 to ptr), align 4, !tbaa !6
  store volatile i32 805437440, ptr inttoptr (i32 1344274664 to ptr), align 8, !tbaa !6
  store volatile i32 536883200, ptr inttoptr (i32 1344274676 to ptr), align 4, !tbaa !6
  store volatile i32 8, ptr inttoptr (i32 1344274672 to ptr), align 16, !tbaa !6
  tail call void @gdma_fill(i32 noundef 537116672, i32 noundef 0, i32 noundef 4096) #5
  store volatile i32 537116672, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !6
  store volatile i32 1344274448, ptr inttoptr (i32 1342177860 to ptr), align 4, !tbaa !6
  store volatile i32 -1, ptr inttoptr (i32 1342177864 to ptr), align 8, !tbaa !6
  %10 = load i32, ptr @sndctrl, align 4, !tbaa !6
  store volatile i32 %10, ptr inttoptr (i32 1342177868 to ptr), align 4, !tbaa !6
  store volatile i32 3, ptr inttoptr (i32 1344274432 to ptr), align 2097152, !tbaa !6
  ret void

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw [12 x i16], ptr @pioprog, i32 0, i32 %7
  %13 = load i16, ptr %12, align 2, !tbaa !10
  %14 = zext i16 %13 to i32
  %15 = shl nuw nsw i32 %7, 2
  %16 = add nuw nsw i32 %15, 1344274504
  %17 = inttoptr i32 %16 to ptr
  store volatile i32 %14, ptr %17, align 4, !tbaa !6
  %18 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !12
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local void @gpio_fn(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_play(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = tail call i32 @llvm.umax.i32(i32 %0, i32 200)
  %5 = udiv i32 12500000, %4
  %6 = shl nuw nsw i32 %5, 8
  store volatile i32 %6, ptr inttoptr (i32 1344274632 to ptr), align 8, !tbaa !6
  %7 = shl i32 %1, 6
  %8 = and i32 %7, 65472
  %9 = mul nuw i32 %8, 65537
  br label %10

10:                                               ; preds = %17, %3
  %11 = phi i32 [ 0, %3 ], [ %19, %17 ]
  %12 = icmp eq i32 %11, 32
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  %14 = sub i32 0, %7
  %15 = and i32 %14, 65472
  %16 = mul nuw i32 %15, 65537
  br label %20

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537116672 to ptr), i32 %11
  store volatile i32 %9, ptr %18, align 4, !tbaa !6
  %19 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !13

20:                                               ; preds = %13, %23
  %21 = phi i32 [ %25, %23 ], [ 32, %13 ]
  %22 = icmp eq i32 %21, 64
  br i1 %22, label %26, label %23

23:                                               ; preds = %20
  %24 = getelementptr inbounds nuw i32, ptr inttoptr (i32 537116672 to ptr), i32 %21
  store volatile i32 %16, ptr %24, align 4, !tbaa !6
  %25 = add nuw nsw i32 %21, 1
  br label %20, !llvm.loop !14

26:                                               ; preds = %20, %30
  %27 = phi i32 [ %32, %30 ], [ 256, %20 ]
  %28 = icmp ult i32 %27, 4096
  br i1 %28, label %30, label %29

29:                                               ; preds = %26
  store i32 %2, ptr @snd_frames, align 4, !tbaa !6
  ret void

30:                                               ; preds = %26
  %31 = or disjoint i32 %27, 537116672
  tail call void @gdma_copy(i32 noundef %31, i32 noundef 537116672, i32 noundef %27) #5
  %32 = shl nuw nsw i32 %27, 1
  br label %26, !llvm.loop !15
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @snd_tick() local_unnamed_addr #0 {
  %1 = load i32, ptr @snd_frames, align 4, !tbaa !6
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %7, label %3

3:                                                ; preds = %0
  %4 = add i32 %1, -1
  store i32 %4, ptr @snd_frames, align 4, !tbaa !6
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  tail call void @gdma_fill(i32 noundef 537116672, i32 noundef 0, i32 noundef 4096) #5
  br label %7

7:                                                ; preds = %6, %3, %0
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @led(i32 noundef %0, i32 noundef %1) local_unnamed_addr #3 {
  %3 = alloca [2 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #6
  store i32 %0, ptr %3, align 4, !tbaa !6
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store i32 %1, ptr %4, align 4, !tbaa !6
  br label %5

5:                                                ; preds = %16, %2
  %6 = phi i32 [ 0, %2 ], [ %25, %16 ]
  %7 = icmp eq i32 %6, 2
  br i1 %7, label %8, label %9

8:                                                ; preds = %5
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #6
  ret void

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw [2 x i32], ptr %3, i32 0, i32 %6
  %11 = load i32, ptr %10, align 4, !tbaa !6
  br label %12

12:                                               ; preds = %12, %9
  %13 = load volatile i32, ptr inttoptr (i32 1344274436 to ptr), align 4, !tbaa !6
  %14 = and i32 %13, 131072
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %12, !llvm.loop !16

16:                                               ; preds = %12
  %17 = shl i32 %11, 8
  %18 = and i32 %17, 16711680
  %19 = lshr i32 %11, 8
  %20 = and i32 %19, 65280
  %21 = or disjoint i32 %18, %20
  %22 = and i32 %11, 255
  %23 = or disjoint i32 %21, %22
  %24 = shl nuw i32 %23, 8
  store volatile i32 %24, ptr inttoptr (i32 1344274452 to ptr), align 4, !tbaa !6
  %25 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !17
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #4

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !11, i64 0}
!11 = !{!"short", !8, i64 0}
!12 = distinct !{!12, !4, !5}
!13 = distinct !{!13, !4, !5}
!14 = distinct !{!14, !4, !5}
!15 = distinct !{!15, !4, !5}
!16 = distinct !{!16, !4, !5}
!17 = distinct !{!17, !4, !5}
