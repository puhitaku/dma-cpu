; ModuleID = 'user/umalloc.c'
source_filename = "user/umalloc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%union.header = type { %struct.anon }
%struct.anon = type { ptr, i32 }

@freep = internal unnamed_addr global ptr null, align 4
@__malloc_chunkunits = dso_local local_unnamed_addr global i32 512, align 4
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
  %9 = phi ptr [ %5, %1 ], [ @base, %7 ]
  br label %10

10:                                               ; preds = %8, %43
  %11 = phi ptr [ %9, %8 ], [ %46, %43 ]
  br label %12

12:                                               ; preds = %10, %30
  %13 = phi ptr [ %14, %30 ], [ %11, %10 ]
  %14 = load ptr, ptr %13, align 4, !tbaa !3
  %15 = getelementptr inbounds nuw i8, ptr %14, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !3
  %17 = icmp ugt i32 %16, %3
  br i1 %17, label %18, label %30

18:                                               ; preds = %12
  %19 = getelementptr inbounds nuw i8, ptr %14, i32 4
  %20 = icmp eq i32 %16, %4
  br i1 %20, label %21, label %23

21:                                               ; preds = %18
  %22 = load ptr, ptr %14, align 4, !tbaa !3
  store ptr %22, ptr %13, align 4, !tbaa !3
  br label %27

23:                                               ; preds = %18
  %24 = sub i32 %16, %4
  store i32 %24, ptr %19, align 4, !tbaa !3
  %25 = getelementptr inbounds nuw %union.header, ptr %14, i32 %24
  %26 = getelementptr inbounds nuw i8, ptr %25, i32 4
  store i32 %4, ptr %26, align 4, !tbaa !3
  br label %27

27:                                               ; preds = %23, %21
  %28 = phi ptr [ %14, %21 ], [ %25, %23 ]
  store ptr %13, ptr @freep, align 4, !tbaa !9
  %29 = getelementptr inbounds nuw i8, ptr %28, i32 8
  br label %48

30:                                               ; preds = %12
  %31 = icmp eq ptr %14, %11
  br i1 %31, label %32, label %12, !llvm.loop !12

32:                                               ; preds = %30
  %33 = load i32, ptr @__malloc_chunkunits, align 4, !tbaa !13
  %34 = tail call i32 @llvm.umax.i32(i32 range(i32 1, 536870913) %4, i32 %33)
  br label %35

35:                                               ; preds = %40, %32
  %36 = phi i32 [ %34, %32 ], [ %41, %40 ]
  %37 = shl i32 %36, 3
  %38 = tail call ptr @sbrk(i32 noundef %37) #4
  %39 = icmp eq ptr %38, inttoptr (i32 -1 to ptr)
  br i1 %39, label %40, label %43

40:                                               ; preds = %35
  %41 = lshr i32 %36, 1
  %42 = icmp samesign ugt i32 %41, %3
  br i1 %42, label %35, label %48, !llvm.loop !15

43:                                               ; preds = %35
  %44 = getelementptr inbounds nuw i8, ptr %38, i32 4
  store i32 %36, ptr %44, align 4, !tbaa !3
  %45 = getelementptr inbounds nuw i8, ptr %38, i32 8
  tail call void @free(ptr noundef nonnull %45) #5
  %46 = load ptr, ptr @freep, align 4, !tbaa !9
  %47 = icmp eq ptr %46, null
  br i1 %47, label %48, label %10, !llvm.loop !12

48:                                               ; preds = %43, %40, %27
  %49 = phi ptr [ %29, %27 ], [ null, %40 ], [ null, %43 ]
  ret ptr %49
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
!13 = !{!14, !14, i64 0}
!14 = !{!"int", !4, i64 0}
!15 = distinct !{!15, !8}
