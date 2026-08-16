; ModuleID = 'dmacc/testdata/memory.c'
source_filename = "dmacc/testdata/memory.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.Item = type { i8, i16, i32 }

@__const.main.a = private unnamed_addr constant [8 x i32] [i32 5, i32 -3, i32 9, i32 0, i32 -7, i32 2, i32 8, i32 1], align 4
@items = dso_local local_unnamed_addr global [5 x %struct.Item] zeroinitializer, align 4

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @strsum(ptr noundef readonly captures(none) %0) local_unnamed_addr #0 {
  %2 = load i8, ptr %0, align 1, !tbaa !3
  %3 = icmp eq i8 %2, 0
  br i1 %3, label %14, label %4

4:                                                ; preds = %1, %4
  %5 = phi i8 [ %12, %4 ], [ %2, %1 ]
  %6 = phi i32 [ %11, %4 ], [ 0, %1 ]
  %7 = phi ptr [ %9, %4 ], [ %0, %1 ]
  %8 = mul nsw i32 %6, 31
  %9 = getelementptr inbounds nuw i8, ptr %7, i32 1
  %10 = sext i8 %5 to i32
  %11 = add nsw i32 %8, %10
  %12 = load i8, ptr %9, align 1, !tbaa !3
  %13 = icmp eq i8 %12, 0
  br i1 %13, label %14, label %4, !llvm.loop !6

14:                                               ; preds = %4, %1
  %15 = phi i32 [ 0, %1 ], [ %11, %4 ]
  ret i32 %15
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @bubble(ptr noundef captures(none) %0, i32 noundef %1) local_unnamed_addr #2 {
  %3 = icmp sgt i32 %1, 0
  br i1 %3, label %4, label %9

4:                                                ; preds = %2, %10
  %5 = phi i32 [ %12, %10 ], [ %1, %2 ]
  %6 = phi i32 [ %11, %10 ], [ 0, %2 ]
  %7 = sub nsw i32 %1, %6
  %8 = icmp sgt i32 %7, 1
  br i1 %8, label %14, label %10

9:                                                ; preds = %10, %2
  ret void

10:                                               ; preds = %23, %4
  %11 = add nuw nsw i32 %6, 1
  %12 = add i32 %5, -1
  %13 = icmp eq i32 %11, %1
  br i1 %13, label %9, label %4, !llvm.loop !9

14:                                               ; preds = %4, %23
  %15 = phi i32 [ %24, %23 ], [ 1, %4 ]
  %16 = phi i32 [ %15, %23 ], [ 0, %4 ]
  %17 = getelementptr inbounds nuw i32, ptr %0, i32 %16
  %18 = load i32, ptr %17, align 4, !tbaa !10
  %19 = getelementptr inbounds nuw i32, ptr %0, i32 %15
  %20 = load i32, ptr %19, align 4, !tbaa !10
  %21 = icmp sgt i32 %18, %20
  br i1 %21, label %22, label %23

22:                                               ; preds = %14
  store i32 %20, ptr %17, align 4, !tbaa !10
  store i32 %18, ptr %19, align 4, !tbaa !10
  br label %23

23:                                               ; preds = %14, %22
  %24 = add nuw nsw i32 %15, 1
  %25 = icmp eq i32 %24, %5
  br i1 %25, label %10, label %14, !llvm.loop !12
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, -2147483648) i32 @main() local_unnamed_addr #3 {
  %1 = alloca [8 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #5
  call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(32) %1, ptr noundef nonnull align 4 dereferenceable(32) @__const.main.a, i32 32, i1 false)
  br label %2

2:                                                ; preds = %6, %0
  %3 = phi i32 [ %8, %6 ], [ 8, %0 ]
  %4 = phi i32 [ %7, %6 ], [ 0, %0 ]
  %5 = icmp samesign ult i32 %4, 7
  br i1 %5, label %10, label %6

6:                                                ; preds = %19, %2
  %7 = add nuw nsw i32 %4, 1
  %8 = add nsw i32 %3, -1
  %9 = icmp eq i32 %7, 8
  br i1 %9, label %22, label %2, !llvm.loop !9

10:                                               ; preds = %2, %19
  %11 = phi i32 [ %20, %19 ], [ 1, %2 ]
  %12 = phi i32 [ %11, %19 ], [ 0, %2 ]
  %13 = getelementptr inbounds nuw i32, ptr %1, i32 %12
  %14 = load i32, ptr %13, align 4, !tbaa !10
  %15 = getelementptr inbounds nuw i32, ptr %1, i32 %11
  %16 = load i32, ptr %15, align 4, !tbaa !10
  %17 = icmp sgt i32 %14, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %10
  store i32 %16, ptr %13, align 4, !tbaa !10
  store i32 %14, ptr %15, align 4, !tbaa !10
  br label %19

19:                                               ; preds = %18, %10
  %20 = add nuw nsw i32 %11, 1
  %21 = icmp eq i32 %20, %3
  br i1 %21, label %6, label %10, !llvm.loop !12

22:                                               ; preds = %6, %22
  %23 = phi i32 [ %30, %22 ], [ 0, %6 ]
  %24 = phi i32 [ %29, %22 ], [ 0, %6 ]
  %25 = mul nsw i32 %24, 10
  %26 = getelementptr inbounds nuw [8 x i32], ptr %1, i32 0, i32 %23
  %27 = load i32, ptr %26, align 4, !tbaa !10
  %28 = add i32 %25, 7
  %29 = add i32 %28, %27
  %30 = add nuw nsw i32 %23, 1
  %31 = icmp eq i32 %30, 8
  br i1 %31, label %32, label %22, !llvm.loop !13

32:                                               ; preds = %22, %32
  %33 = phi i32 [ %43, %32 ], [ 0, %22 ]
  %34 = trunc nuw nsw i32 %33 to i8
  %35 = mul i8 %34, 50
  %36 = getelementptr inbounds nuw [5 x %struct.Item], ptr @items, i32 0, i32 %33
  store i8 %35, ptr %36, align 4, !tbaa !14
  %37 = trunc nuw nsw i32 %33 to i16
  %38 = mul nuw nsw i16 %37, 1000
  %39 = add nsw i16 %38, -1500
  %40 = getelementptr inbounds nuw i8, ptr %36, i32 2
  store i16 %39, ptr %40, align 2, !tbaa !17
  %41 = mul nuw nsw i32 %33, 123456
  %42 = getelementptr inbounds nuw i8, ptr %36, i32 4
  store i32 %41, ptr %42, align 4, !tbaa !18
  %43 = add nuw nsw i32 %33, 1
  %44 = icmp eq i32 %43, 5
  br i1 %44, label %48, label %32, !llvm.loop !19

45:                                               ; preds = %48
  %46 = add nsw i32 %61, 1767653203
  %47 = and i32 %46, 2147483647
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #5
  ret i32 %47

48:                                               ; preds = %32, %48
  %49 = phi i32 [ %62, %48 ], [ 0, %32 ]
  %50 = phi i32 [ %61, %48 ], [ %29, %32 ]
  %51 = getelementptr inbounds nuw [5 x %struct.Item], ptr @items, i32 0, i32 %49
  %52 = load i8, ptr %51, align 4, !tbaa !14
  %53 = sext i8 %52 to i32
  %54 = getelementptr inbounds nuw i8, ptr %51, i32 2
  %55 = load i16, ptr %54, align 2, !tbaa !17
  %56 = sext i16 %55 to i32
  %57 = getelementptr inbounds nuw i8, ptr %51, i32 4
  %58 = load i32, ptr %57, align 4, !tbaa !18
  %59 = add i32 %50, %53
  %60 = add i32 %59, %56
  %61 = add i32 %60, %58
  %62 = add nuw nsw i32 %49, 1
  %63 = icmp eq i32 %62, 5
  br i1 %63, label %45, label %48, !llvm.loop !20
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #4

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nofree norecurse nosync nounwind memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind }

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
