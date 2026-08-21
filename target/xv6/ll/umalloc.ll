; ModuleID = 'user/umalloc.c'
source_filename = "user/umalloc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%union.header = type { %struct.anon }
%struct.anon = type { ptr, i32 }

@freep = internal unnamed_addr global ptr null, align 4
@base = internal global %union.header zeroinitializer, align 4

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define dso_local void @free(ptr noundef %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds i8, ptr %0, i32 -8
  %3 = load ptr, ptr @freep, align 4, !tbaa !3
  br label %4

4:                                                ; preds = %12, %1
  %5 = phi ptr [ %3, %1 ], [ %7, %12 ]
  %6 = icmp ugt ptr %2, %5
  %7 = load ptr, ptr %5, align 4, !tbaa !3
  br i1 %6, label %8, label %13

8:                                                ; preds = %4
  %9 = icmp uge ptr %2, %7
  %10 = icmp ult ptr %5, %7
  %11 = and i1 %9, %10
  br i1 %11, label %12, label %17

12:                                               ; preds = %8, %13
  br label %4, !llvm.loop !6

13:                                               ; preds = %4
  %14 = icmp uge ptr %5, %7
  %15 = icmp ult ptr %2, %7
  %16 = and i1 %14, %15
  br i1 %16, label %17, label %12

17:                                               ; preds = %13, %8
  %18 = getelementptr inbounds i8, ptr %0, i32 -4
  %19 = load i32, ptr %18, align 4, !tbaa !3
  %20 = getelementptr inbounds nuw %union.header, ptr %2, i32 %19
  %21 = icmp eq ptr %20, %7
  br i1 %21, label %22, label %28

22:                                               ; preds = %17
  %23 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %24 = load i32, ptr %23, align 4, !tbaa !3
  %25 = add i32 %24, %19
  store i32 %25, ptr %18, align 4, !tbaa !3
  %26 = load ptr, ptr %5, align 4, !tbaa !3
  %27 = load ptr, ptr %26, align 4, !tbaa !3
  br label %28

28:                                               ; preds = %17, %22
  %29 = phi i32 [ %25, %22 ], [ %19, %17 ]
  %30 = phi ptr [ %27, %22 ], [ %7, %17 ]
  store ptr %30, ptr %2, align 4, !tbaa !3
  %31 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %32 = load i32, ptr %31, align 4, !tbaa !3
  %33 = getelementptr inbounds nuw %union.header, ptr %5, i32 %32
  %34 = icmp eq ptr %33, %2
  br i1 %34, label %35, label %38

35:                                               ; preds = %28
  %36 = add i32 %29, %32
  store i32 %36, ptr %31, align 4, !tbaa !3
  %37 = load ptr, ptr %2, align 4, !tbaa !3
  br label %38

38:                                               ; preds = %28, %35
  %39 = phi ptr [ %37, %35 ], [ %2, %28 ]
  store ptr %39, ptr %5, align 4, !tbaa !3
  store ptr %5, ptr @freep, align 4, !tbaa !9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @malloc(i32 noundef %0) local_unnamed_addr #1 {
  %2 = add i32 %0, 7
  %3 = lshr i32 %2, 3
  %4 = add nuw nsw i32 %3, 1
  %5 = load ptr, ptr @freep, align 4, !tbaa !9
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %8

7:                                                ; preds = %1
  store ptr @base, ptr @freep, align 4, !tbaa !9
  store ptr @base, ptr @base, align 4, !tbaa !3
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @base, i32 4), align 4, !tbaa !3
  br label %8

8:                                                ; preds = %7, %1
  %9 = phi ptr [ @base, %7 ], [ %5, %1 ]
  %10 = tail call i32 @llvm.umax.i32(i32 range(i32 1, 536870913) %4, i32 512)
  %11 = shl i32 %10, 3
  br label %12

12:                                               ; preds = %37, %8
  %13 = phi ptr [ %40, %37 ], [ %9, %8 ]
  br label %14

14:                                               ; preds = %12, %32
  %15 = phi ptr [ %16, %32 ], [ %13, %12 ]
  %16 = load ptr, ptr %15, align 4, !tbaa !3
  %17 = getelementptr inbounds nuw i8, ptr %16, i32 4
  %18 = load i32, ptr %17, align 4, !tbaa !3
  %19 = icmp ugt i32 %18, %3
  br i1 %19, label %20, label %32

20:                                               ; preds = %14
  %21 = getelementptr inbounds nuw i8, ptr %16, i32 4
  %22 = icmp eq i32 %18, %4
  br i1 %22, label %23, label %25

23:                                               ; preds = %20
  %24 = load ptr, ptr %16, align 4, !tbaa !3
  store ptr %24, ptr %15, align 4, !tbaa !3
  br label %29

25:                                               ; preds = %20
  %26 = sub i32 %18, %4
  store i32 %26, ptr %21, align 4, !tbaa !3
  %27 = getelementptr inbounds nuw %union.header, ptr %16, i32 %26
  %28 = getelementptr inbounds nuw i8, ptr %27, i32 4
  store i32 %4, ptr %28, align 4, !tbaa !3
  br label %29

29:                                               ; preds = %25, %23
  %30 = phi ptr [ %16, %23 ], [ %27, %25 ]
  store ptr %15, ptr @freep, align 4, !tbaa !9
  %31 = getelementptr inbounds nuw i8, ptr %30, i32 8
  br label %42

32:                                               ; preds = %14
  %33 = icmp eq ptr %16, %13
  br i1 %33, label %34, label %14, !llvm.loop !12

34:                                               ; preds = %32
  %35 = tail call ptr @sbrk(i32 noundef %11) #4
  %36 = icmp eq ptr %35, inttoptr (i32 -1 to ptr)
  br i1 %36, label %42, label %37

37:                                               ; preds = %34
  %38 = getelementptr inbounds nuw i8, ptr %35, i32 4
  store i32 %10, ptr %38, align 4, !tbaa !3
  %39 = getelementptr inbounds nuw i8, ptr %35, i32 8
  tail call void @free(ptr noundef nonnull %39) #5
  %40 = load ptr, ptr @freep, align 4, !tbaa !9
  %41 = icmp eq ptr %40, null
  br i1 %41, label %42, label %12, !llvm.loop !12

42:                                               ; preds = %34, %37, %29
  %43 = phi ptr [ %31, %29 ], [ null, %37 ], [ null, %34 ]
  ret ptr %43
}

; Function Attrs: minsize optsize
declare dso_local ptr @sbrk(i32 noundef) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #3

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }

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
!9 = !{!10, !10, i64 0}
!10 = !{!"p1 _ZTS6header", !11, i64 0}
!11 = !{!"any pointer", !4, i64 0}
!12 = distinct !{!12, !8}
