; ModuleID = 'user/printf.c'
source_filename = "user/printf.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.__va_list = type { ptr }

@.str = private unnamed_addr constant [7 x i8] c"(null)\00", align 1
@digits = internal unnamed_addr constant [17 x i8] c"0123456789ABCDEF\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @vprintf(i32 noundef %0, ptr noundef readonly captures(none) %1, [1 x i32] %2) local_unnamed_addr #0 {
  %4 = extractvalue [1 x i32] %2, 0
  %5 = inttoptr i32 %4 to ptr
  br label %6

6:                                                ; preds = %119, %3
  %7 = phi ptr [ %5, %3 ], [ %120, %119 ]
  %8 = phi i32 [ 0, %3 ], [ %123, %119 ]
  %9 = phi i32 [ 0, %3 ], [ %122, %119 ]
  %10 = getelementptr inbounds i8, ptr %1, i32 %8
  %11 = load i8, ptr %10, align 1, !tbaa !3
  %12 = icmp eq i8 %11, 0
  br i1 %12, label %124, label %13

13:                                               ; preds = %6
  switch i32 %9, label %119 [
    i32 0, label %14
    i32 37, label %17
  ]

14:                                               ; preds = %13
  %15 = icmp eq i8 %11, 37
  br i1 %15, label %119, label %16

16:                                               ; preds = %14
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext %11) #4
  br label %119

17:                                               ; preds = %13
  %18 = getelementptr i8, ptr %10, i32 1
  %19 = load i8, ptr %18, align 1, !tbaa !3
  %20 = icmp eq i8 %19, 0
  br i1 %20, label %25, label %21

21:                                               ; preds = %17
  %22 = getelementptr i8, ptr %10, i32 2
  %23 = load i8, ptr %22, align 1, !tbaa !3
  %24 = zext i8 %23 to i32
  br label %25

25:                                               ; preds = %21, %17
  %26 = phi i32 [ %24, %21 ], [ 0, %17 ]
  %27 = icmp eq i8 %11, 100
  br i1 %27, label %28, label %31

28:                                               ; preds = %25
  %29 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %30 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %30, i32 noundef 10, i32 noundef 1) #4
  br label %119

31:                                               ; preds = %25
  %32 = icmp eq i8 %11, 108
  %33 = icmp eq i8 %19, 100
  %34 = and i1 %32, %33
  br i1 %34, label %35, label %39

35:                                               ; preds = %31
  %36 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %37 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %37, i32 noundef 10, i32 noundef 1) #4
  %38 = add nsw i32 %8, 1
  br label %119

39:                                               ; preds = %31
  %40 = icmp eq i8 %19, 108
  %41 = and i1 %32, %40
  %42 = icmp eq i32 %26, 100
  %43 = select i1 %41, i1 %42, i1 false
  br i1 %43, label %44, label %48

44:                                               ; preds = %39
  %45 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %46 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %46, i32 noundef 10, i32 noundef 1) #4
  %47 = add nsw i32 %8, 2
  br label %119

48:                                               ; preds = %39
  %49 = icmp eq i8 %11, 117
  br i1 %49, label %50, label %53

50:                                               ; preds = %48
  %51 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %52 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %52, i32 noundef 10, i32 noundef 0) #4
  br label %119

53:                                               ; preds = %48
  %54 = icmp eq i8 %19, 117
  %55 = and i1 %32, %54
  br i1 %55, label %56, label %60

56:                                               ; preds = %53
  %57 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %58 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %58, i32 noundef 10, i32 noundef 0) #4
  %59 = add nsw i32 %8, 1
  br label %119

60:                                               ; preds = %53
  %61 = icmp eq i32 %26, 117
  %62 = select i1 %41, i1 %61, i1 false
  br i1 %62, label %63, label %67

63:                                               ; preds = %60
  %64 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %65 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %65, i32 noundef 10, i32 noundef 0) #4
  %66 = add nsw i32 %8, 2
  br label %119

67:                                               ; preds = %60
  %68 = icmp eq i8 %11, 120
  br i1 %68, label %69, label %72

69:                                               ; preds = %67
  %70 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %71 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %71, i32 noundef 16, i32 noundef 0) #4
  br label %119

72:                                               ; preds = %67
  %73 = icmp eq i8 %19, 120
  %74 = and i1 %32, %73
  br i1 %74, label %75, label %79

75:                                               ; preds = %72
  %76 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %77 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %77, i32 noundef 16, i32 noundef 0) #4
  %78 = add nsw i32 %8, 1
  br label %119

79:                                               ; preds = %72
  %80 = icmp eq i32 %26, 120
  %81 = select i1 %41, i1 %80, i1 false
  br i1 %81, label %82, label %86

82:                                               ; preds = %79
  %83 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %84 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @printint(i32 noundef %0, i32 noundef %84, i32 noundef 16, i32 noundef 0) #4
  %85 = add nsw i32 %8, 2
  br label %119

86:                                               ; preds = %79
  switch i8 %11, label %114 [
    i8 112, label %87
    i8 99, label %99
    i8 115, label %103
    i8 37, label %113
  ]

87:                                               ; preds = %86
  %88 = load i32, ptr %7, align 4, !tbaa !6
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext 48) #4
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext 120) #4
  br label %89

89:                                               ; preds = %93, %87
  %90 = phi i32 [ %88, %87 ], [ %98, %93 ]
  %91 = phi i32 [ 0, %87 ], [ %97, %93 ]
  %92 = icmp eq i32 %91, 8
  br i1 %92, label %115, label %93

93:                                               ; preds = %89
  %94 = lshr i32 %90, 28
  %95 = getelementptr inbounds nuw [17 x i8], ptr @digits, i32 0, i32 %94
  %96 = load i8, ptr %95, align 1, !tbaa !3
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext %96) #4
  %97 = add nuw nsw i32 %91, 1
  %98 = shl i32 %90, 4
  br label %89, !llvm.loop !8

99:                                               ; preds = %86
  %100 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %101 = load i32, ptr %7, align 4, !tbaa !6
  %102 = trunc i32 %101 to i8
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext %102) #4
  br label %119

103:                                              ; preds = %86
  %104 = load ptr, ptr %7, align 4, !tbaa !11
  %105 = icmp eq ptr %104, null
  %106 = select i1 %105, ptr @.str, ptr %104
  br label %107

107:                                              ; preds = %111, %103
  %108 = phi ptr [ %106, %103 ], [ %112, %111 ]
  %109 = load i8, ptr %108, align 1, !tbaa !3
  %110 = icmp eq i8 %109, 0
  br i1 %110, label %117, label %111

111:                                              ; preds = %107
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext %109) #4
  %112 = getelementptr inbounds nuw i8, ptr %108, i32 1
  br label %107, !llvm.loop !14

113:                                              ; preds = %86
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext 37) #4
  br label %119

114:                                              ; preds = %86
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext 37) #4
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext %11) #4
  br label %119

115:                                              ; preds = %89
  %116 = getelementptr inbounds nuw i8, ptr %7, i32 4
  br label %119

117:                                              ; preds = %107
  %118 = getelementptr inbounds nuw i8, ptr %7, i32 4
  br label %119

119:                                              ; preds = %117, %115, %28, %44, %56, %69, %82, %99, %113, %114, %75, %63, %50, %35, %13, %14, %16
  %120 = phi ptr [ %7, %16 ], [ %7, %14 ], [ %7, %13 ], [ %29, %28 ], [ %36, %35 ], [ %45, %44 ], [ %51, %50 ], [ %57, %56 ], [ %64, %63 ], [ %70, %69 ], [ %76, %75 ], [ %83, %82 ], [ %100, %99 ], [ %7, %113 ], [ %7, %114 ], [ %116, %115 ], [ %118, %117 ]
  %121 = phi i32 [ %8, %16 ], [ %8, %14 ], [ %8, %13 ], [ %8, %28 ], [ %38, %35 ], [ %47, %44 ], [ %8, %50 ], [ %59, %56 ], [ %66, %63 ], [ %8, %69 ], [ %78, %75 ], [ %85, %82 ], [ %8, %99 ], [ %8, %113 ], [ %8, %114 ], [ %8, %115 ], [ %8, %117 ]
  %122 = phi i32 [ 0, %16 ], [ 37, %14 ], [ %9, %13 ], [ 0, %28 ], [ 0, %35 ], [ 0, %44 ], [ 0, %50 ], [ 0, %56 ], [ 0, %63 ], [ 0, %69 ], [ 0, %75 ], [ 0, %82 ], [ 0, %99 ], [ 0, %113 ], [ 0, %114 ], [ 0, %115 ], [ 0, %117 ]
  %123 = add nsw i32 %121, 1
  br label %6, !llvm.loop !15

124:                                              ; preds = %6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @putc(i32 noundef %0, i8 noundef signext %1) unnamed_addr #0 {
  %3 = alloca i8, align 1
  store i8 %1, ptr %3, align 1, !tbaa !3
  %4 = call i32 @write(i32 noundef %0, ptr noundef nonnull %3, i32 noundef 1) #5
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @printint(i32 noundef %0, i32 noundef %1, i32 noundef range(i32 10, 17) %2, i32 noundef range(i32 0, 2) %3) unnamed_addr #0 {
  %5 = alloca [20 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %5) #6
  %6 = icmp eq i32 %3, 0
  %7 = icmp sgt i32 %1, -1
  %8 = or i1 %7, %6
  %9 = sub nsw i32 0, %1
  %10 = select i1 %8, i32 %1, i32 %9
  br label %11

11:                                               ; preds = %11, %4
  %12 = phi i32 [ 0, %4 ], [ %20, %11 ]
  %13 = phi i32 [ %10, %4 ], [ %15, %11 ]
  %14 = freeze i32 %13
  %15 = udiv i32 %14, %2
  %16 = mul i32 %15, %2
  %17 = sub i32 %14, %16
  %18 = getelementptr inbounds nuw [17 x i8], ptr @digits, i32 0, i32 %17
  %19 = load i8, ptr %18, align 1, !tbaa !3
  %20 = add nuw nsw i32 %12, 1
  %21 = getelementptr inbounds nuw [20 x i8], ptr %5, i32 0, i32 %12
  store i8 %19, ptr %21, align 1, !tbaa !3
  %22 = icmp ugt i32 %2, %13
  br i1 %22, label %23, label %11, !llvm.loop !16

23:                                               ; preds = %11
  br i1 %8, label %27, label %24

24:                                               ; preds = %23
  %25 = add nuw nsw i32 %12, 2
  %26 = getelementptr inbounds nuw [20 x i8], ptr %5, i32 0, i32 %20
  store i8 45, ptr %26, align 1, !tbaa !3
  br label %27

27:                                               ; preds = %24, %23
  %28 = phi i32 [ %20, %23 ], [ %25, %24 ]
  br label %29

29:                                               ; preds = %27, %32
  %30 = phi i32 [ %33, %32 ], [ %28, %27 ]
  %31 = icmp sgt i32 %30, 0
  br i1 %31, label %32, label %36

32:                                               ; preds = %29
  %33 = add nsw i32 %30, -1
  %34 = getelementptr inbounds nuw [20 x i8], ptr %5, i32 0, i32 %33
  %35 = load i8, ptr %34, align 1, !tbaa !3
  tail call fastcc void @putc(i32 noundef %0, i8 noundef signext %35) #4
  br label %29, !llvm.loop !17

36:                                               ; preds = %29
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %5) #6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define dso_local void @fprintf(i32 noundef %0, ptr noundef readonly captures(none) %1, ...) local_unnamed_addr #0 {
  %3 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6
  call void @llvm.va_start.p0(ptr nonnull %3)
  %4 = load i32, ptr %3, align 4
  %5 = insertvalue [1 x i32] poison, i32 %4, 0
  call void @vprintf(i32 noundef %0, ptr noundef %1, [1 x i32] %5) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #2

; Function Attrs: minsize nounwind optsize
define dso_local void @printf(ptr noundef readonly captures(none) %0, ...) local_unnamed_addr #0 {
  %2 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #6
  call void @llvm.va_start.p0(ptr nonnull %2)
  %3 = load i32, ptr %2, align 4
  %4 = insertvalue [1 x i32] poison, i32 %3, 0
  call void @vprintf(i32 noundef 1, ptr noundef %0, [1 x i32] %4) #4
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !4, i64 0}
!8 = distinct !{!8, !9, !10}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{!"llvm.loop.unroll.disable"}
!11 = !{!12, !12, i64 0}
!12 = !{!"p1 omnipotent char", !13, i64 0}
!13 = !{!"any pointer", !4, i64 0}
!14 = distinct !{!14, !9, !10}
!15 = distinct !{!15, !9, !10}
!16 = distinct !{!16, !9, !10}
!17 = distinct !{!17, !9, !10}
