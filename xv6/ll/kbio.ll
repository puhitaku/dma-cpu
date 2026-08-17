; ModuleID = 'kbio.c'
source_filename = "kbio.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.buf = type { i32, i32, i32, ptr }

@dma_disk = dso_local local_unnamed_addr global i32 0, align 4
@dma_disksize = dso_local local_unnamed_addr global i32 0, align 4
@.str = private unnamed_addr constant [6 x i8] c"bread\00", align 1
@bufs = internal global [8 x %struct.buf] zeroinitializer, align 4
@.str.1 = private unnamed_addr constant [18 x i8] c"bread: no buffers\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"brelse\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local ptr @bread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %10, label %5

5:                                                ; preds = %2
  %6 = shl i32 %1, 10
  %7 = add i32 %6, 1024
  %8 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %9 = icmp ugt i32 %7, %8
  br i1 %9, label %10, label %11

10:                                               ; preds = %5, %2
  tail call void @panic(ptr noundef nonnull @.str) #3
  unreachable

11:                                               ; preds = %5, %27
  %12 = phi ptr [ %31, %27 ], [ null, %5 ]
  %13 = phi i32 [ %32, %27 ], [ 0, %5 ]
  %14 = icmp eq i32 %13, 8
  br i1 %14, label %36, label %15

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw [8 x %struct.buf], ptr @bufs, i32 0, i32 %13
  %17 = getelementptr inbounds nuw i8, ptr %16, i32 8
  %18 = load i32, ptr %17, align 4, !tbaa !7
  %19 = icmp sgt i32 %18, 0
  br i1 %19, label %20, label %27

20:                                               ; preds = %15
  %21 = getelementptr inbounds nuw i8, ptr %16, i32 4
  %22 = load i32, ptr %21, align 4, !tbaa !11
  %23 = icmp eq i32 %22, %1
  br i1 %23, label %24, label %27

24:                                               ; preds = %20
  %25 = load i32, ptr %16, align 4, !tbaa !12
  %26 = icmp eq i32 %25, %0
  br i1 %26, label %33, label %27

27:                                               ; preds = %15, %20, %24
  %28 = icmp eq i32 %18, 0
  %29 = icmp eq ptr %12, null
  %30 = select i1 %28, i1 %29, i1 false
  %31 = select i1 %30, ptr %16, ptr %12
  %32 = add nuw nsw i32 %13, 1
  br label %11, !llvm.loop !13

33:                                               ; preds = %24
  %34 = getelementptr inbounds nuw i8, ptr %16, i32 8
  %35 = add nuw nsw i32 %18, 1
  store i32 %35, ptr %34, align 4, !tbaa !7
  br label %45

36:                                               ; preds = %11
  %37 = icmp eq ptr %12, null
  br i1 %37, label %38, label %39

38:                                               ; preds = %36
  tail call void @panic(ptr noundef nonnull @.str.1) #3
  unreachable

39:                                               ; preds = %36
  store i32 %0, ptr %12, align 4, !tbaa !12
  %40 = getelementptr inbounds nuw i8, ptr %12, i32 4
  store i32 %1, ptr %40, align 4, !tbaa !11
  %41 = getelementptr inbounds nuw i8, ptr %12, i32 8
  store i32 1, ptr %41, align 4, !tbaa !7
  %42 = add i32 %3, %6
  %43 = inttoptr i32 %42 to ptr
  %44 = getelementptr inbounds nuw i8, ptr %12, i32 12
  store ptr %43, ptr %44, align 4, !tbaa !16
  br label %45

45:                                               ; preds = %33, %39
  %46 = phi ptr [ %12, %39 ], [ %16, %33 ]
  ret ptr %46
}

; Function Attrs: minsize noreturn optsize
declare dso_local void @panic(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local void @brelse(ptr noundef captures(none) %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !7
  %4 = icmp slt i32 %3, 1
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  tail call void @panic(ptr noundef nonnull @.str.2) #3
  unreachable

6:                                                ; preds = %1
  %7 = add nsw i32 %3, -1
  store i32 %7, ptr %2, align 4, !tbaa !7
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @bwrite(ptr noundef readnone captures(none) %0) local_unnamed_addr #2 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @log_write(ptr noundef readnone captures(none) %0) local_unnamed_addr #2 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @begin_op() local_unnamed_addr #2 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @end_op() local_unnamed_addr #2 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @initlog(i32 noundef %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #2 {
  ret void
}

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !4, i64 8}
!8 = !{!"buf", !4, i64 0, !4, i64 4, !4, i64 8, !9, i64 12}
!9 = !{!"p1 omnipotent char", !10, i64 0}
!10 = !{!"any pointer", !5, i64 0}
!11 = !{!8, !4, i64 4}
!12 = !{!8, !4, i64 0}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = !{!8, !9, i64 12}
