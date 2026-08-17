; ModuleID = 'kpipe.c'
source_filename = "kpipe.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.pipe = type { [512 x i8], i32, i32, i32, i32, i32 }

@pipes = internal global [4 x %struct.pipe] zeroinitializer, align 4

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @pipealloc(ptr noundef captures(none) %0, ptr noundef writeonly captures(none) %1) local_unnamed_addr #0 {
  br label %3

3:                                                ; preds = %7, %2
  %4 = phi i32 [ 0, %2 ], [ %12, %7 ]
  %5 = icmp eq i32 %4, 4
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  store ptr null, ptr %1, align 4, !tbaa !3
  store ptr null, ptr %0, align 4, !tbaa !3
  br label %35

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw [4 x %struct.pipe], ptr @pipes, i32 0, i32 %4
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 528
  %10 = load i32, ptr %9, align 4, !tbaa !8
  %11 = icmp eq i32 %10, 0
  %12 = add nuw nsw i32 %4, 1
  br i1 %11, label %13, label %3, !llvm.loop !11

13:                                               ; preds = %7
  store ptr null, ptr %1, align 4, !tbaa !3
  store ptr null, ptr %0, align 4, !tbaa !3
  %14 = tail call ptr @filealloc() #2
  store ptr %14, ptr %0, align 4, !tbaa !3
  %15 = icmp eq ptr %14, null
  br i1 %15, label %35, label %16

16:                                               ; preds = %13
  %17 = tail call ptr @filealloc() #2
  store ptr %17, ptr %1, align 4, !tbaa !3
  %18 = icmp eq ptr %17, null
  br i1 %18, label %19, label %23

19:                                               ; preds = %16
  %20 = load ptr, ptr %0, align 4, !tbaa !3
  %21 = icmp eq ptr %20, null
  br i1 %21, label %35, label %22

22:                                               ; preds = %19
  tail call void @fileclose(ptr noundef nonnull %20) #2
  br label %35

23:                                               ; preds = %16
  store i32 1, ptr %9, align 4, !tbaa !8
  %24 = getelementptr inbounds nuw i8, ptr %8, i32 520
  store i32 1, ptr %24, align 4, !tbaa !14
  %25 = getelementptr inbounds nuw i8, ptr %8, i32 524
  store i32 1, ptr %25, align 4, !tbaa !15
  %26 = getelementptr inbounds nuw i8, ptr %8, i32 516
  store i32 0, ptr %26, align 4, !tbaa !16
  %27 = getelementptr inbounds nuw i8, ptr %8, i32 512
  store i32 0, ptr %27, align 4, !tbaa !17
  %28 = load ptr, ptr %0, align 4, !tbaa !3
  store i32 1, ptr %28, align 4, !tbaa !18
  %29 = getelementptr inbounds nuw i8, ptr %28, i32 8
  store i8 1, ptr %29, align 4, !tbaa !23
  %30 = getelementptr inbounds nuw i8, ptr %28, i32 9
  store i8 0, ptr %30, align 1, !tbaa !24
  %31 = getelementptr inbounds nuw i8, ptr %28, i32 12
  store ptr %8, ptr %31, align 4, !tbaa !25
  store i32 1, ptr %17, align 4, !tbaa !18
  %32 = getelementptr inbounds nuw i8, ptr %17, i32 8
  store i8 0, ptr %32, align 4, !tbaa !23
  %33 = getelementptr inbounds nuw i8, ptr %17, i32 9
  store i8 1, ptr %33, align 1, !tbaa !24
  %34 = getelementptr inbounds nuw i8, ptr %17, i32 12
  store ptr %8, ptr %34, align 4, !tbaa !25
  br label %35

35:                                               ; preds = %13, %6, %19, %22, %23
  %36 = phi i32 [ 0, %23 ], [ -1, %22 ], [ -1, %19 ], [ -1, %6 ], [ -1, %13 ]
  ret i32 %36
}

; Function Attrs: minsize optsize
declare dso_local ptr @filealloc() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @fileclose(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -3, -2147483648) i32 @piperead(ptr noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = inttoptr i32 %1 to ptr
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 512
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 516
  br label %7

7:                                                ; preds = %15, %3
  %8 = phi ptr [ %4, %3 ], [ %19, %15 ]
  %9 = phi i32 [ 0, %3 ], [ %22, %15 ]
  %10 = icmp slt i32 %9, %2
  br i1 %10, label %11, label %23

11:                                               ; preds = %7
  %12 = load i32, ptr %5, align 4, !tbaa !17
  %13 = load i32, ptr %6, align 4, !tbaa !16
  %14 = icmp eq i32 %12, %13
  br i1 %14, label %23, label %15

15:                                               ; preds = %11
  %16 = and i32 %12, 511
  %17 = getelementptr inbounds nuw [512 x i8], ptr %0, i32 0, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !26
  %19 = getelementptr inbounds nuw i8, ptr %8, i32 1
  store i8 %18, ptr %8, align 1, !tbaa !26
  %20 = load i32, ptr %5, align 4, !tbaa !17
  %21 = add i32 %20, 1
  store i32 %21, ptr %5, align 4, !tbaa !17
  %22 = add nuw nsw i32 %9, 1
  br label %7, !llvm.loop !27

23:                                               ; preds = %7, %11
  %24 = ptrtoint ptr %6 to i32
  %25 = tail call i32 @kfind_sleeper(i32 noundef %24) #2
  %26 = icmp slt i32 %25, 0
  br i1 %26, label %54, label %27

27:                                               ; preds = %23
  %28 = tail call i32 @kmail_get(i32 noundef %25, i32 noundef 2) #2
  %29 = inttoptr i32 %28 to ptr
  %30 = tail call i32 @kmail_get(i32 noundef %25, i32 noundef 3) #2
  %31 = tail call i32 @kmail_get(i32 noundef %25, i32 noundef 5) #2
  %32 = add i32 %31, %30
  br label %33

33:                                               ; preds = %43, %27
  %34 = phi ptr [ %29, %27 ], [ %44, %43 ]
  %35 = phi i32 [ %30, %27 ], [ %49, %43 ]
  %36 = phi i32 [ %31, %27 ], [ %50, %43 ]
  %37 = icmp eq i32 %35, 0
  br i1 %37, label %51, label %38

38:                                               ; preds = %33
  %39 = load i32, ptr %6, align 4, !tbaa !16
  %40 = load i32, ptr %5, align 4, !tbaa !17
  %41 = sub i32 %39, %40
  %42 = icmp ult i32 %41, 512
  br i1 %42, label %43, label %52

43:                                               ; preds = %38
  %44 = getelementptr inbounds nuw i8, ptr %34, i32 1
  %45 = load i8, ptr %34, align 1, !tbaa !26
  %46 = and i32 %39, 511
  %47 = getelementptr inbounds nuw [512 x i8], ptr %0, i32 0, i32 %46
  store i8 %45, ptr %47, align 1, !tbaa !26
  %48 = add i32 %39, 1
  store i32 %48, ptr %6, align 4, !tbaa !16
  %49 = add i32 %35, -1
  %50 = add i32 %36, 1
  br label %33, !llvm.loop !28

51:                                               ; preds = %33
  tail call void @kcomplete(i32 noundef %25, i32 noundef %32) #2
  br label %54

52:                                               ; preds = %38
  %53 = ptrtoint ptr %34 to i32
  tail call void @kmail_set(i32 noundef %25, i32 noundef 2, i32 noundef %53) #2
  tail call void @kmail_set(i32 noundef %25, i32 noundef 3, i32 noundef %35) #2
  tail call void @kmail_set(i32 noundef %25, i32 noundef 5, i32 noundef %36) #2
  br label %54

54:                                               ; preds = %23, %51, %52
  %55 = icmp eq i32 %9, 0
  br i1 %55, label %56, label %62

56:                                               ; preds = %54
  %57 = getelementptr inbounds nuw i8, ptr %0, i32 524
  %58 = load i32, ptr %57, align 4, !tbaa !15
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %62, label %60

60:                                               ; preds = %56
  %61 = ptrtoint ptr %5 to i32
  tail call void @kblock_current(i32 noundef %61) #2
  br label %62

62:                                               ; preds = %56, %54, %60
  %63 = phi i32 [ -3, %60 ], [ %9, %54 ], [ 0, %56 ]
  ret i32 %63
}

; Function Attrs: minsize optsize
declare dso_local void @kblock_current(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @pipewrite(ptr noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = inttoptr i32 %1 to ptr
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 520
  %6 = load i32, ptr %5, align 4, !tbaa !14
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %60, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 512
  %10 = ptrtoint ptr %9 to i32
  %11 = tail call i32 @kfind_sleeper(i32 noundef %10) #2
  %12 = icmp sgt i32 %11, -1
  br i1 %12, label %13, label %29

13:                                               ; preds = %8
  %14 = tail call i32 @kmail_get(i32 noundef %11, i32 noundef 2) #2
  %15 = inttoptr i32 %14 to ptr
  %16 = tail call i32 @kmail_get(i32 noundef %11, i32 noundef 3) #2
  br label %17

17:                                               ; preds = %23, %13
  %18 = phi i32 [ 0, %13 ], [ %24, %23 ]
  %19 = phi ptr [ %15, %13 ], [ %27, %23 ]
  %20 = icmp ult i32 %18, %16
  %21 = icmp slt i32 %18, %2
  %22 = and i1 %20, %21
  br i1 %22, label %23, label %28

23:                                               ; preds = %17
  %24 = add nuw nsw i32 %18, 1
  %25 = getelementptr inbounds nuw i8, ptr %4, i32 %18
  %26 = load i8, ptr %25, align 1, !tbaa !26
  %27 = getelementptr inbounds nuw i8, ptr %19, i32 1
  store i8 %26, ptr %19, align 1, !tbaa !26
  br label %17, !llvm.loop !29

28:                                               ; preds = %17
  tail call void @kcomplete(i32 noundef %11, i32 noundef %18) #2
  br label %29

29:                                               ; preds = %28, %8
  %30 = phi i32 [ %18, %28 ], [ 0, %8 ]
  %31 = getelementptr inbounds nuw i8, ptr %0, i32 516
  br label %32

32:                                               ; preds = %40, %29
  %33 = phi i32 [ %30, %29 ], [ %41, %40 ]
  %34 = icmp slt i32 %33, %2
  br i1 %34, label %35, label %47

35:                                               ; preds = %32
  %36 = load i32, ptr %31, align 4, !tbaa !16
  %37 = load i32, ptr %9, align 4, !tbaa !17
  %38 = sub i32 %36, %37
  %39 = icmp ult i32 %38, 512
  br i1 %39, label %40, label %47

40:                                               ; preds = %35
  %41 = add nuw nsw i32 %33, 1
  %42 = getelementptr inbounds nuw i8, ptr %4, i32 %33
  %43 = load i8, ptr %42, align 1, !tbaa !26
  %44 = and i32 %36, 511
  %45 = getelementptr inbounds nuw [512 x i8], ptr %0, i32 0, i32 %44
  store i8 %43, ptr %45, align 1, !tbaa !26
  %46 = add i32 %36, 1
  store i32 %46, ptr %31, align 4, !tbaa !16
  br label %32, !llvm.loop !30

47:                                               ; preds = %32, %35
  %48 = icmp eq i32 %33, %2
  br i1 %48, label %60, label %49

49:                                               ; preds = %47
  %50 = load i32, ptr %5, align 4, !tbaa !14
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %60, label %52

52:                                               ; preds = %49
  %53 = tail call i32 @kblock_self_slot() #2
  %54 = getelementptr inbounds nuw i8, ptr %4, i32 %33
  %55 = ptrtoint ptr %54 to i32
  tail call void @kmail_set(i32 noundef %53, i32 noundef 2, i32 noundef %55) #2
  %56 = tail call i32 @kblock_self_slot() #2
  %57 = sub nsw i32 %2, %33
  tail call void @kmail_set(i32 noundef %56, i32 noundef 3, i32 noundef %57) #2
  %58 = tail call i32 @kblock_self_slot() #2
  tail call void @kmail_set(i32 noundef %58, i32 noundef 5, i32 noundef %33) #2
  %59 = ptrtoint ptr %31 to i32
  tail call void @kblock_current(i32 noundef %59) #2
  br label %60

60:                                               ; preds = %52, %47, %49, %3
  %61 = phi i32 [ -1, %3 ], [ -3, %52 ], [ %2, %47 ], [ %33, %49 ]
  ret i32 %61
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfind_sleeper(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @kmail_get(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @kcomplete(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @kmail_set(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @kblock_self_slot() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local void @pipeclose(ptr noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %12, label %4

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 524
  store i32 0, ptr %5, align 4, !tbaa !15
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 512
  %7 = ptrtoint ptr %6 to i32
  br label %8

8:                                                ; preds = %11, %4
  %9 = tail call i32 @kfind_sleeper(i32 noundef %7) #2
  %10 = icmp sgt i32 %9, -1
  br i1 %10, label %11, label %21

11:                                               ; preds = %8
  tail call void @kcomplete(i32 noundef %9, i32 noundef 0) #2
  br label %8, !llvm.loop !31

12:                                               ; preds = %2
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 520
  store i32 0, ptr %13, align 4, !tbaa !14
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 516
  %15 = ptrtoint ptr %14 to i32
  br label %16

16:                                               ; preds = %19, %12
  %17 = tail call i32 @kfind_sleeper(i32 noundef %15) #2
  %18 = icmp sgt i32 %17, -1
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  %20 = tail call i32 @kmail_get(i32 noundef %17, i32 noundef 5) #2
  tail call void @kcomplete(i32 noundef %17, i32 noundef %20) #2
  br label %16, !llvm.loop !32

21:                                               ; preds = %8, %16
  %22 = getelementptr inbounds nuw i8, ptr %0, i32 520
  %23 = load i32, ptr %22, align 4, !tbaa !14
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %25, label %31

25:                                               ; preds = %21
  %26 = getelementptr inbounds nuw i8, ptr %0, i32 524
  %27 = load i32, ptr %26, align 4, !tbaa !15
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %31

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %0, i32 528
  store i32 0, ptr %30, align 4, !tbaa !8
  br label %31

31:                                               ; preds = %29, %25, %21
  ret void
}

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"p1 _ZTS4file", !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !10, i64 528}
!9 = !{!"pipe", !6, i64 0, !10, i64 512, !10, i64 516, !10, i64 520, !10, i64 524, !10, i64 528}
!10 = !{!"int", !6, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = !{!9, !10, i64 520}
!15 = !{!9, !10, i64 524}
!16 = !{!9, !10, i64 516}
!17 = !{!9, !10, i64 512}
!18 = !{!19, !10, i64 0}
!19 = !{!"file", !10, i64 0, !10, i64 4, !6, i64 8, !6, i64 9, !20, i64 12, !21, i64 16, !10, i64 20, !22, i64 24}
!20 = !{!"p1 _ZTS4pipe", !5, i64 0}
!21 = !{!"p1 _ZTS5inode", !5, i64 0}
!22 = !{!"short", !6, i64 0}
!23 = !{!19, !6, i64 8}
!24 = !{!19, !6, i64 9}
!25 = !{!19, !20, i64 12}
!26 = !{!6, !6, i64 0}
!27 = distinct !{!27, !12, !13}
!28 = distinct !{!28, !12, !13}
!29 = distinct !{!29, !12, !13}
!30 = distinct !{!30, !12, !13}
!31 = distinct !{!31, !12, !13}
!32 = distinct !{!32, !12, !13}
