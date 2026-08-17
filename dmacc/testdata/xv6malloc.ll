; ModuleID = 'dmacc/testdata/xv6malloc.c'
source_filename = "dmacc/testdata/xv6malloc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@seed = dso_local global i32 12345, align 4

; Function Attrs: minsize nounwind optsize
define dso_local ptr @sbrk(i32 noundef %0) local_unnamed_addr #0 {
  %2 = tail call ptr @sys_sbrk(i32 noundef %0, i32 noundef 0) #3
  ret ptr %2
}

; Function Attrs: minsize optsize
declare dso_local ptr @sys_sbrk(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 1, 12648431) i32 @main() local_unnamed_addr #0 {
  %1 = alloca [12 x ptr], align 4
  %2 = alloca [12 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %1) #4
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %2) #4
  %3 = load volatile i32, ptr @seed, align 4, !tbaa !3
  br label %4

4:                                                ; preds = %20, %0
  %5 = phi i32 [ 0, %0 ], [ %23, %20 ]
  %6 = phi i32 [ %3, %0 ], [ %10, %20 ]
  %7 = icmp eq i32 %5, 12
  br i1 %7, label %24, label %8

8:                                                ; preds = %4
  %9 = mul i32 %6, 1103515245
  %10 = add i32 %9, 12345
  %11 = lshr i32 %10, 16
  %12 = trunc nuw i32 %11 to i16
  %13 = urem i16 %12, 200
  %14 = add nuw nsw i16 %13, 8
  %15 = zext nneg i16 %14 to i32
  %16 = getelementptr inbounds nuw [12 x i32], ptr %2, i32 0, i32 %5
  store i32 %15, ptr %16, align 4, !tbaa !3
  %17 = tail call ptr @malloc(i32 noundef %15) #3
  %18 = getelementptr inbounds nuw [12 x ptr], ptr %1, i32 0, i32 %5
  store ptr %17, ptr %18, align 4, !tbaa !7
  %19 = icmp eq ptr %17, null
  br i1 %19, label %83, label %20

20:                                               ; preds = %8
  %21 = or disjoint i32 %5, 64
  %22 = tail call ptr @memset(ptr noundef nonnull %17, i32 noundef %21, i32 noundef %15) #3
  %23 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !9

24:                                               ; preds = %4, %27
  %25 = phi i32 [ %30, %27 ], [ 0, %4 ]
  %26 = icmp samesign ult i32 %25, 12
  br i1 %26, label %27, label %31

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw [12 x ptr], ptr %1, i32 0, i32 %25
  %29 = load ptr, ptr %28, align 4, !tbaa !7
  tail call void @free(ptr noundef %29) #3
  %30 = add nuw nsw i32 %25, 2
  br label %24, !llvm.loop !12

31:                                               ; preds = %24, %42
  %32 = phi i32 [ %45, %42 ], [ 0, %24 ]
  %33 = icmp samesign ugt i32 %32, 11
  br i1 %33, label %46, label %34

34:                                               ; preds = %31
  %35 = getelementptr inbounds nuw [12 x i32], ptr %2, i32 0, i32 %32
  %36 = load i32, ptr %35, align 4, !tbaa !3
  %37 = lshr i32 %36, 1
  %38 = add nuw i32 %37, 4
  %39 = tail call ptr @malloc(i32 noundef %38) #3
  %40 = getelementptr inbounds nuw [12 x ptr], ptr %1, i32 0, i32 %32
  store ptr %39, ptr %40, align 4, !tbaa !7
  %41 = icmp eq ptr %39, null
  br i1 %41, label %83, label %42

42:                                               ; preds = %34
  %43 = or disjoint i32 %32, 96
  %44 = tail call ptr @memset(ptr noundef nonnull %39, i32 noundef %43, i32 noundef %38) #3
  store i32 %38, ptr %35, align 4, !tbaa !3
  %45 = add nuw nsw i32 %32, 2
  br label %31, !llvm.loop !13

46:                                               ; preds = %31, %67
  %47 = phi i32 [ %68, %67 ], [ 0, %31 ]
  %48 = icmp eq i32 %47, 12
  br i1 %48, label %71, label %49

49:                                               ; preds = %46
  %50 = and i32 %47, 1
  %51 = icmp eq i32 %50, 0
  %52 = select i1 %51, i32 96, i32 64
  %53 = or disjoint i32 %52, %47
  %54 = getelementptr inbounds nuw [12 x ptr], ptr %1, i32 0, i32 %47
  %55 = load ptr, ptr %54, align 4, !tbaa !7
  %56 = getelementptr inbounds nuw [12 x i32], ptr %2, i32 0, i32 %47
  %57 = load i32, ptr %56, align 4, !tbaa !3
  br label %58

58:                                               ; preds = %61, %49
  %59 = phi i32 [ 0, %49 ], [ %66, %61 ]
  %60 = icmp eq i32 %59, %57
  br i1 %60, label %67, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %55, i32 %59
  %63 = load i8, ptr %62, align 1, !tbaa !14
  %64 = zext i8 %63 to i32
  %65 = icmp eq i32 %53, %64
  %66 = add i32 %59, 1
  br i1 %65, label %58, label %69, !llvm.loop !15

67:                                               ; preds = %58
  %68 = add nuw nsw i32 %47, 1
  br label %46, !llvm.loop !16

69:                                               ; preds = %61
  %70 = icmp samesign ugt i32 %47, 11
  br i1 %70, label %71, label %83

71:                                               ; preds = %46, %69
  br label %72

72:                                               ; preds = %71, %79
  %73 = phi i32 [ %82, %79 ], [ 0, %71 ]
  %74 = icmp eq i32 %73, 12
  br i1 %74, label %75, label %79

75:                                               ; preds = %72
  %76 = tail call ptr @malloc(i32 noundef 4000) #3
  %77 = icmp eq ptr %76, null
  %78 = select i1 %77, i32 4, i32 12648430
  br label %83

79:                                               ; preds = %72
  %80 = getelementptr inbounds nuw [12 x ptr], ptr %1, i32 0, i32 %73
  %81 = load ptr, ptr %80, align 4, !tbaa !7
  tail call void @free(ptr noundef %81) #3
  %82 = add nuw nsw i32 %73, 1
  br label %72, !llvm.loop !17

83:                                               ; preds = %8, %34, %75, %69
  %84 = phi i32 [ 3, %69 ], [ %78, %75 ], [ 2, %34 ], [ 1, %8 ]
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %2) #4
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %1) #4
  ret i32 %84
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local ptr @malloc(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @free(ptr noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #4 = { nounwind }

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
!8 = !{!"any pointer", !5, i64 0}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = distinct !{!13, !10, !11}
!14 = !{!5, !5, i64 0}
!15 = distinct !{!15, !10, !11}
!16 = distinct !{!16, !10, !11}
!17 = distinct !{!17, !10, !11}
