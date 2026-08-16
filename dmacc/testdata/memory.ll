; ModuleID = 'dmacc/testdata/memory.c'
source_filename = "dmacc/testdata/memory.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.Item = type { i8, i16, i32 }

@__const.main.a = private unnamed_addr constant [8 x i32] [i32 5, i32 -3, i32 9, i32 0, i32 -7, i32 2, i32 8, i32 1], align 4
@items = dso_local local_unnamed_addr global [5 x %struct.Item] zeroinitializer, align 4
@.str = private unnamed_addr constant [8 x i8] c"dma-cpu\00", align 1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local i32 @strsum(ptr noundef readonly captures(none) %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi ptr [ %0, %1 ], [ %9, %7 ]
  %4 = phi i32 [ 0, %1 ], [ %11, %7 ]
  %5 = load i8, ptr %3, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %12, label %7

7:                                                ; preds = %2
  %8 = mul nsw i32 %4, 31
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %10 = sext i8 %5 to i32
  %11 = add nsw i32 %8, %10
  br label %2, !llvm.loop !6

12:                                               ; preds = %2
  ret i32 %4
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local void @bubble(ptr noundef captures(none) %0, i32 noundef %1) local_unnamed_addr #2 {
  br label %3

3:                                                ; preds = %13, %2
  %4 = phi i32 [ 0, %2 ], [ %14, %13 ]
  %5 = icmp slt i32 %4, %1
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = sub nsw i32 %1, %4
  br label %9

8:                                                ; preds = %3
  ret void

9:                                                ; preds = %21, %6
  %10 = phi i32 [ 0, %6 ], [ %11, %21 ]
  %11 = add nuw nsw i32 %10, 1
  %12 = icmp slt i32 %11, %7
  br i1 %12, label %15, label %13

13:                                               ; preds = %9
  %14 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !9

15:                                               ; preds = %9
  %16 = getelementptr inbounds nuw i32, ptr %0, i32 %10
  %17 = load i32, ptr %16, align 4, !tbaa !10
  %18 = getelementptr inbounds nuw i32, ptr %0, i32 %11
  %19 = load i32, ptr %18, align 4, !tbaa !10
  %20 = icmp sgt i32 %17, %19
  br i1 %20, label %22, label %21

21:                                               ; preds = %15, %22
  br label %9, !llvm.loop !12

22:                                               ; preds = %15
  store i32 %19, ptr %16, align 4, !tbaa !10
  store i32 %17, ptr %18, align 4, !tbaa !10
  br label %21
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #3 {
  %1 = alloca [8 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #5
  call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(32) %1, ptr noundef nonnull align 4 dereferenceable(32) @__const.main.a, i32 32, i1 false)
  call void @bubble(ptr noundef nonnull %1, i32 noundef 8) #6
  br label %2

2:                                                ; preds = %6, %0
  %3 = phi i32 [ 0, %0 ], [ %11, %6 ]
  %4 = phi i32 [ 0, %0 ], [ %12, %6 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %13, label %6

6:                                                ; preds = %2
  %7 = mul nsw i32 %3, 10
  %8 = getelementptr inbounds nuw [8 x i32], ptr %1, i32 0, i32 %4
  %9 = load i32, ptr %8, align 4, !tbaa !10
  %10 = add i32 %7, 7
  %11 = add i32 %10, %9
  %12 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !13

13:                                               ; preds = %2, %16
  %14 = phi i32 [ %26, %16 ], [ 0, %2 ]
  %15 = icmp eq i32 %14, 5
  br i1 %15, label %27, label %16

16:                                               ; preds = %13
  %17 = trunc nuw nsw i32 %14 to i8
  %18 = mul nuw i8 %17, 50
  %19 = getelementptr inbounds nuw [5 x %struct.Item], ptr @items, i32 0, i32 %14
  store i8 %18, ptr %19, align 4, !tbaa !14
  %20 = trunc nuw nsw i32 %14 to i16
  %21 = mul nuw nsw i16 %20, 1000
  %22 = add nsw i16 %21, -1500
  %23 = getelementptr inbounds nuw i8, ptr %19, i32 2
  store i16 %22, ptr %23, align 2, !tbaa !17
  %24 = mul nuw nsw i32 %14, 123456
  %25 = getelementptr inbounds nuw i8, ptr %19, i32 4
  store i32 %24, ptr %25, align 4, !tbaa !18
  %26 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !19

27:                                               ; preds = %13, %35
  %28 = phi i32 [ %46, %35 ], [ %3, %13 ]
  %29 = phi i32 [ %47, %35 ], [ 0, %13 ]
  %30 = icmp eq i32 %29, 5
  br i1 %30, label %31, label %35

31:                                               ; preds = %27
  %32 = tail call i32 @strsum(ptr noundef nonnull @.str) #6
  %33 = add nsw i32 %32, %28
  %34 = and i32 %33, 2147483647
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #5
  ret i32 %34

35:                                               ; preds = %27
  %36 = getelementptr inbounds nuw [5 x %struct.Item], ptr @items, i32 0, i32 %29
  %37 = load i8, ptr %36, align 4, !tbaa !14
  %38 = sext i8 %37 to i32
  %39 = getelementptr inbounds nuw i8, ptr %36, i32 2
  %40 = load i16, ptr %39, align 2, !tbaa !17
  %41 = sext i16 %40 to i32
  %42 = getelementptr inbounds nuw i8, ptr %36, i32 4
  %43 = load i32, ptr %42, align 4, !tbaa !18
  %44 = add i32 %28, %38
  %45 = add i32 %44, %41
  %46 = add i32 %45, %43
  %47 = add nuw nsw i32 %29, 1
  br label %27, !llvm.loop !20
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #4

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = distinct !{!9, !7, !8}
!10 = !{!11, !11, i64 0}
!11 = !{!"int", !4, i64 0}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = !{!15, !4, i64 0}
!15 = !{!"", !4, i64 0, !16, i64 2, !11, i64 4}
!16 = !{!"short", !4, i64 0}
!17 = !{!15, !16, i64 2}
!18 = !{!15, !11, i64 4}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
