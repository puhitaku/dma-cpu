; ModuleID = 'user/fbtest.c'
source_filename = "user/fbtest.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.fbinfo = type { i32, i32, i32, i32, i32 }

@.str = private unnamed_addr constant [15 x i8] c"fbtest: no fb\0A\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"fbtest: busy\0A\00", align 1
@t_fbtest.bars = internal unnamed_addr constant [16 x i8] c"\00\80\10\90\02\82\12\DB\92\E0\1C\FC\03\E3\1F\FF", align 1
@t_fbtest.tmpl = internal unnamed_addr global [640 x i8] zeroinitializer, align 1
@.str.2 = private unnamed_addr constant [28 x i8] c"fbtest: test card up (5 s)\0A\00", align 1
@.str.3 = private unnamed_addr constant [21 x i8] c"fbtest: verify FAIL\0A\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"fb ok \00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #0 {
  %3 = tail call fastcc i32 @t_fbtest() #5
  %4 = tail call i32 @exit(i32 noundef %3) #6
  unreachable
}

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_fbtest() unnamed_addr #2 {
  %1 = alloca %struct.fbinfo, align 4
  %2 = alloca [5 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #7
  %3 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %1) #8
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %0
  %6 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str, i32 noundef 14) #8
  br label %149

7:                                                ; preds = %0
  %8 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #8
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  %11 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.1, i32 noundef 13) #8
  br label %149

12:                                               ; preds = %7
  %13 = load i32, ptr %1, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %15 = load i32, ptr %14, align 4, !tbaa !8
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %2) #7
  %16 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %17 = load i32, ptr %16, align 4, !tbaa !9
  %18 = udiv i32 %17, 5
  br label %19

19:                                               ; preds = %27, %12
  %20 = phi i32 [ 0, %12 ], [ %28, %27 ]
  %21 = icmp eq i32 %20, 5
  br i1 %21, label %22, label %27

22:                                               ; preds = %19
  %23 = inttoptr i32 %13 to ptr
  %24 = lshr i32 %15, 2
  %25 = getelementptr inbounds nuw i8, ptr %2, i32 16
  store i32 %17, ptr %25, align 4, !tbaa !10
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 4
  br label %31

27:                                               ; preds = %19
  %28 = add nuw nsw i32 %20, 1
  %29 = mul nuw i32 %18, %28
  %30 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %20
  store i32 %29, ptr %30, align 4, !tbaa !10
  br label %19, !llvm.loop !11

31:                                               ; preds = %95, %22
  %32 = phi i32 [ 0, %22 ], [ %96, %95 ]
  %33 = icmp eq i32 %32, 5
  br i1 %33, label %110, label %34

34:                                               ; preds = %31
  %35 = icmp eq i32 %32, 0
  br i1 %35, label %36, label %39

36:                                               ; preds = %34
  %37 = load i32, ptr %26, align 4, !tbaa !14
  %38 = lshr i32 %37, 4
  br label %44

39:                                               ; preds = %34
  %40 = icmp eq i32 %32, 3
  %41 = load i32, ptr %26, align 4
  %42 = select i1 %40, i32 2, i32 3
  %43 = lshr i32 %41, %42
  br label %44

44:                                               ; preds = %39, %36
  %45 = phi i32 [ %37, %36 ], [ %41, %39 ]
  %46 = phi i32 [ %38, %36 ], [ %43, %39 ]
  br label %47

47:                                               ; preds = %72, %44
  %48 = phi i32 [ 0, %44 ], [ %74, %72 ]
  %49 = phi i32 [ 0, %44 ], [ %79, %72 ]
  %50 = phi i32 [ %46, %44 ], [ %80, %72 ]
  %51 = icmp eq i32 %48, %45
  br i1 %51, label %81, label %52

52:                                               ; preds = %47
  br i1 %35, label %53, label %56

53:                                               ; preds = %52
  %54 = getelementptr inbounds nuw [16 x i8], ptr @t_fbtest.bars, i32 0, i32 %49
  %55 = load i8, ptr %54, align 1, !tbaa !15
  br label %72

56:                                               ; preds = %52
  switch i32 %32, label %65 [
    i32 1, label %57
    i32 2, label %60
    i32 3, label %63
  ]

57:                                               ; preds = %56
  %58 = trunc i32 %49 to i8
  %59 = shl i8 %58, 5
  br label %72

60:                                               ; preds = %56
  %61 = trunc i32 %49 to i8
  %62 = shl i8 %61, 2
  br label %72

63:                                               ; preds = %56
  %64 = trunc i32 %49 to i8
  br label %72

65:                                               ; preds = %56
  %66 = shl i32 %49, 5
  %67 = shl i32 %49, 2
  %68 = or i32 %66, %67
  %69 = lshr i32 %49, 1
  %70 = or i32 %68, %69
  %71 = trunc i32 %70 to i8
  br label %72

72:                                               ; preds = %57, %63, %65, %60, %53
  %73 = phi i8 [ %55, %53 ], [ %59, %57 ], [ %62, %60 ], [ %64, %63 ], [ %71, %65 ]
  %74 = add i32 %48, 1
  %75 = getelementptr inbounds nuw [640 x i8], ptr @t_fbtest.tmpl, i32 0, i32 %48
  store i8 %73, ptr %75, align 1, !tbaa !15
  %76 = add i32 %50, -1
  %77 = icmp eq i32 %76, 0
  %78 = zext i1 %77 to i32
  %79 = add i32 %49, %78
  %80 = select i1 %77, i32 %46, i32 %76
  br label %47, !llvm.loop !16

81:                                               ; preds = %47
  store i8 -1, ptr @t_fbtest.tmpl, align 1, !tbaa !15
  %82 = add i32 %45, -1
  %83 = getelementptr inbounds nuw [640 x i8], ptr @t_fbtest.tmpl, i32 0, i32 %82
  store i8 -1, ptr %83, align 1, !tbaa !15
  br i1 %35, label %88, label %84

84:                                               ; preds = %81
  %85 = add nsw i32 %32, -1
  %86 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %85
  %87 = load i32, ptr %86, align 4, !tbaa !10
  br label %88

88:                                               ; preds = %81, %84
  %89 = phi i32 [ %87, %84 ], [ 0, %81 ]
  %90 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %32
  %91 = load i32, ptr %90, align 4, !tbaa !10
  br label %92

92:                                               ; preds = %103, %88
  %93 = phi i32 [ %89, %88 ], [ %104, %103 ]
  %94 = icmp ult i32 %93, %91
  br i1 %94, label %97, label %95

95:                                               ; preds = %92
  %96 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !17

97:                                               ; preds = %92
  %98 = mul i32 %93, %24
  %99 = getelementptr inbounds nuw i32, ptr %23, i32 %98
  br label %100

100:                                              ; preds = %105, %97
  %101 = phi i32 [ 0, %97 ], [ %109, %105 ]
  %102 = icmp eq i32 %101, %24
  br i1 %102, label %103, label %105

103:                                              ; preds = %100
  %104 = add nuw i32 %93, 1
  br label %92, !llvm.loop !18

105:                                              ; preds = %100
  %106 = getelementptr inbounds nuw i32, ptr @t_fbtest.tmpl, i32 %101
  %107 = load i32, ptr %106, align 4, !tbaa !10
  %108 = getelementptr inbounds nuw i32, ptr %99, i32 %101
  store volatile i32 %107, ptr %108, align 4, !tbaa !10
  %109 = add nuw nsw i32 %101, 1
  br label %100, !llvm.loop !19

110:                                              ; preds = %31, %116
  %111 = phi i32 [ %123, %116 ], [ 0, %31 ]
  %112 = icmp eq i32 %111, %24
  br i1 %112, label %113, label %116

113:                                              ; preds = %110
  %114 = load volatile i32, ptr %23, align 4, !tbaa !10
  %115 = icmp eq i32 %114, -1
  br i1 %115, label %124, label %137

116:                                              ; preds = %110
  %117 = getelementptr inbounds nuw i32, ptr %23, i32 %111
  store volatile i32 -1, ptr %117, align 4, !tbaa !10
  %118 = load i32, ptr %16, align 4, !tbaa !9
  %119 = add i32 %118, -1
  %120 = mul i32 %119, %24
  %121 = getelementptr i32, ptr %23, i32 %120
  %122 = getelementptr i32, ptr %121, i32 %111
  store volatile i32 -1, ptr %122, align 4, !tbaa !10
  %123 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !20

124:                                              ; preds = %113
  %125 = getelementptr inbounds nuw i32, ptr %23, i32 %24
  %126 = load volatile i32, ptr %125, align 4, !tbaa !10
  %127 = and i32 %126, 255
  %128 = icmp eq i32 %127, 255
  br i1 %128, label %129, label %137

129:                                              ; preds = %124
  %130 = mul i32 %24, 400
  %131 = getelementptr inbounds nuw i8, ptr %23, i32 %130
  %132 = load volatile i32, ptr %131, align 4, !tbaa !10
  %133 = and i32 %132, 65280
  %134 = icmp eq i32 %133, 0
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.2) #8
  %135 = call i32 @pause(i32 noundef 1000) #8
  %136 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #8
  br i1 %134, label %142, label %140

137:                                              ; preds = %113, %124
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.2) #8
  %138 = call i32 @pause(i32 noundef 1000) #8
  %139 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #8
  br label %140

140:                                              ; preds = %137, %129
  %141 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.3, i32 noundef 20) #8
  br label %147

142:                                              ; preds = %129
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.4) #8
  %143 = load i32, ptr %26, align 4, !tbaa !14
  call void @fputnum(i32 noundef 1, i32 noundef %143) #8
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.5) #8
  %144 = load i32, ptr %16, align 4, !tbaa !9
  call void @fputnum(i32 noundef 1, i32 noundef %144) #8
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.5) #8
  %145 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %146 = load i32, ptr %145, align 4, !tbaa !21
  call void @fputnum(i32 noundef 1, i32 noundef %146) #8
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.6) #8
  br label %147

147:                                              ; preds = %142, %140
  %148 = phi i32 [ 0, %142 ], [ 1, %140 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %2) #7
  br label %149

149:                                              ; preds = %147, %10, %5
  %150 = phi i32 [ 1, %5 ], [ 1, %10 ], [ %148, %147 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #7
  ret i32 %150
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @fbctl(i32 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local void @fputnum(i32 noundef, i32 noundef) local_unnamed_addr #4

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #7 = { nounwind }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"fbinfo", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!4, !5, i64 16}
!9 = !{!4, !5, i64 8}
!10 = !{!5, !5, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = !{!4, !5, i64 4}
!15 = !{!6, !6, i64 0}
!16 = distinct !{!16, !12, !13}
!17 = distinct !{!17, !12, !13}
!18 = distinct !{!18, !12, !13}
!19 = distinct !{!19, !12, !13}
!20 = distinct !{!20, !12, !13}
!21 = !{!4, !5, i64 12}
