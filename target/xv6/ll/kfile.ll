; ModuleID = 'file.c'
source_filename = "file.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.anon = type { %struct.spinlock, [32 x %struct.file] }
%struct.spinlock = type { i8 }
%struct.file = type { i32, i32, i8, i8, ptr, ptr, i32, i16 }
%struct.devsw = type { ptr, ptr }
%struct.stat = type { i32, i32, i16, i16, i32 }

@ftable = dso_local global %struct.anon zeroinitializer, align 4
@.str = private unnamed_addr constant [7 x i8] c"ftable\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"filedup\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"fileclose\00", align 1
@devsw = dso_local local_unnamed_addr global [10 x %struct.devsw] zeroinitializer, align 4
@.str.3 = private unnamed_addr constant [9 x i8] c"fileread\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"filewrite\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @fileinit() local_unnamed_addr #0 {
  tail call void @initlock(ptr noundef nonnull @ftable, ptr noundef nonnull @.str) #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @initlock(ptr noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local ptr @filealloc() local_unnamed_addr #0 {
  tail call void @acquire(ptr noundef nonnull @ftable) #5
  br label %1

1:                                                ; preds = %10, %0
  %2 = phi ptr [ getelementptr inbounds nuw (i8, ptr @ftable, i32 4), %0 ], [ %11, %10 ]
  %3 = icmp ult ptr %2, getelementptr inbounds nuw (i8, ptr @ftable, i32 900)
  br i1 %3, label %4, label %12

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %6 = load i32, ptr %5, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw i8, ptr %2, i32 4
  store i32 1, ptr %9, align 4, !tbaa !3
  br label %12

10:                                               ; preds = %4
  %11 = getelementptr inbounds nuw i8, ptr %2, i32 28
  br label %1, !llvm.loop !12

12:                                               ; preds = %1, %8
  %13 = phi ptr [ %2, %8 ], [ null, %1 ]
  tail call void @release(ptr noundef nonnull @ftable) #5
  ret ptr %13
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @acquire(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @release(ptr noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @filedup(ptr noundef returned captures(ret: address, provenance) %0) local_unnamed_addr #0 {
  tail call void @acquire(ptr noundef nonnull @ftable) #5
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %3 = load i32, ptr %2, align 4, !tbaa !3
  %4 = icmp slt i32 %3, 1
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  tail call void @panic(ptr noundef nonnull @.str.1) #6
  unreachable

6:                                                ; preds = %1
  %7 = add nuw nsw i32 %3, 1
  store i32 %7, ptr %2, align 4, !tbaa !3
  tail call void @release(ptr noundef nonnull @ftable) #5
  ret ptr %0
}

; Function Attrs: minsize noreturn optsize
declare dso_local void @panic(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @fileclose(ptr noundef captures(none) %0) local_unnamed_addr #0 {
  tail call void @acquire(ptr noundef nonnull @ftable) #5
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %3 = load i32, ptr %2, align 4, !tbaa !3
  %4 = icmp slt i32 %3, 1
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  tail call void @panic(ptr noundef nonnull @.str.2) #6
  unreachable

6:                                                ; preds = %1
  %7 = add nsw i32 %3, -1
  store i32 %7, ptr %2, align 4, !tbaa !3
  %8 = icmp eq i32 %3, 1
  br i1 %8, label %10, label %9

9:                                                ; preds = %6
  tail call void @release(ptr noundef nonnull @ftable) #5
  br label %21

10:                                               ; preds = %6
  %11 = load i32, ptr %0, align 4, !tbaa !15
  %12 = getelementptr inbounds nuw i8, ptr %0, i32 9
  %13 = load i8, ptr %12, align 1, !tbaa !16
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 12
  %15 = load ptr, ptr %14, align 4, !tbaa !17
  %16 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %17 = load ptr, ptr %16, align 4, !tbaa !18
  store i32 0, ptr %2, align 4, !tbaa !3
  store i32 0, ptr %0, align 4, !tbaa !19
  tail call void @release(ptr noundef nonnull @ftable) #5
  switch i32 %11, label %21 [
    i32 1, label %18
    i32 2, label %20
    i32 3, label %20
  ]

18:                                               ; preds = %10
  %19 = sext i8 %13 to i32
  tail call void @pipeclose(ptr noundef %15, i32 noundef %19) #5
  br label %21

20:                                               ; preds = %10, %10
  tail call void @begin_op() #5
  tail call void @vfs_iput(ptr noundef %17) #5
  tail call void @end_op() #5
  br label %21

21:                                               ; preds = %18, %20, %10, %9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @pipeclose(ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @begin_op() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @vfs_iput(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @end_op() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @filestat(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = alloca %struct.stat, align 4
  %4 = tail call ptr @myproc() #5
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #7
  %5 = load i32, ptr %0, align 4, !tbaa !19
  %6 = and i32 %5, -2
  %7 = icmp eq i32 %6, 2
  br i1 %7, label %8, label %18

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %10 = load ptr, ptr %9, align 4, !tbaa !20
  tail call void @vfs_ilock(ptr noundef %10) #5
  %11 = load ptr, ptr %9, align 4, !tbaa !20
  call void @vfs_stati(ptr noundef %11, ptr noundef nonnull %3) #5
  %12 = load ptr, ptr %9, align 4, !tbaa !20
  call void @vfs_iunlock(ptr noundef %12) #5
  %13 = load i32, ptr %4, align 4, !tbaa !21
  %14 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %15 = load i32, ptr %14, align 4, !tbaa !24
  %16 = call i32 @copyout(i32 noundef %13, i32 noundef %15, i32 noundef %1, ptr noundef nonnull %3, i32 noundef 16) #5
  %17 = ashr i32 %16, 31
  br label %18

18:                                               ; preds = %2, %8
  %19 = phi i32 [ %17, %8 ], [ -1, %2 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #7
  ret i32 %19
}

; Function Attrs: minsize optsize
declare dso_local ptr @myproc() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @vfs_ilock(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @vfs_stati(ptr noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @vfs_iunlock(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @copyout(i32 noundef, i32 noundef, i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @fileread(ptr noundef captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %5 = load i8, ptr %4, align 4, !tbaa !25
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %40, label %7

7:                                                ; preds = %3
  %8 = load i32, ptr %0, align 4, !tbaa !19
  switch i32 %8, label %39 [
    i32 1, label %9
    i32 3, label %13
    i32 2, label %26
  ]

9:                                                ; preds = %7
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 12
  %11 = load ptr, ptr %10, align 4, !tbaa !26
  %12 = tail call i32 @piperead(ptr noundef %11, i32 noundef %1, i32 noundef %2) #5
  br label %40

13:                                               ; preds = %7
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 24
  %15 = load i16, ptr %14, align 4, !tbaa !27
  %16 = sext i16 %15 to i32
  %17 = icmp slt i16 %15, 0
  br i1 %17, label %40, label %18

18:                                               ; preds = %13
  %19 = icmp samesign ugt i16 %15, 9
  br i1 %19, label %40, label %20

20:                                               ; preds = %18
  %21 = getelementptr inbounds nuw [10 x %struct.devsw], ptr @devsw, i32 0, i32 %16
  %22 = load ptr, ptr %21, align 4, !tbaa !28
  %23 = icmp eq ptr %22, null
  br i1 %23, label %40, label %24

24:                                               ; preds = %20
  %25 = tail call i32 %22(i32 noundef 1, i32 noundef %1, i32 noundef %2) #5
  br label %40

26:                                               ; preds = %7
  %27 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %28 = load ptr, ptr %27, align 4, !tbaa !20
  tail call void @vfs_ilock(ptr noundef %28) #5
  %29 = load ptr, ptr %27, align 4, !tbaa !20
  %30 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %31 = load i32, ptr %30, align 4, !tbaa !30
  %32 = tail call i32 @vfs_readi(ptr noundef %29, i32 noundef 1, i32 noundef %1, i32 noundef %31, i32 noundef %2) #5
  %33 = icmp sgt i32 %32, 0
  br i1 %33, label %34, label %37

34:                                               ; preds = %26
  %35 = load i32, ptr %30, align 4, !tbaa !30
  %36 = add i32 %35, %32
  store i32 %36, ptr %30, align 4, !tbaa !30
  br label %37

37:                                               ; preds = %34, %26
  %38 = load ptr, ptr %27, align 4, !tbaa !20
  tail call void @vfs_iunlock(ptr noundef %38) #5
  br label %40

39:                                               ; preds = %7
  tail call void @panic(ptr noundef nonnull @.str.3) #6
  unreachable

40:                                               ; preds = %9, %37, %24, %13, %18, %20, %3
  %41 = phi i32 [ -1, %3 ], [ -1, %20 ], [ -1, %18 ], [ -1, %13 ], [ %12, %9 ], [ %25, %24 ], [ %32, %37 ]
  ret i32 %41
}

; Function Attrs: minsize optsize
declare dso_local i32 @piperead(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @vfs_readi(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @filewrite(ptr noundef captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 9
  %5 = load i8, ptr %4, align 1, !tbaa !31
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %52, label %7

7:                                                ; preds = %3
  %8 = load i32, ptr %0, align 4, !tbaa !19
  switch i32 %8, label %51 [
    i32 1, label %12
    i32 3, label %16
    i32 2, label %9
  ]

9:                                                ; preds = %7
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 20
  br label %29

12:                                               ; preds = %7
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 12
  %14 = load ptr, ptr %13, align 4, !tbaa !26
  %15 = tail call i32 @pipewrite(ptr noundef %14, i32 noundef %1, i32 noundef %2) #5
  br label %52

16:                                               ; preds = %7
  %17 = getelementptr inbounds nuw i8, ptr %0, i32 24
  %18 = load i16, ptr %17, align 4, !tbaa !27
  %19 = sext i16 %18 to i32
  %20 = icmp slt i16 %18, 0
  br i1 %20, label %52, label %21

21:                                               ; preds = %16
  %22 = icmp samesign ugt i16 %18, 9
  br i1 %22, label %52, label %23

23:                                               ; preds = %21
  %24 = getelementptr inbounds nuw [10 x %struct.devsw], ptr @devsw, i32 0, i32 %19, i32 1
  %25 = load ptr, ptr %24, align 4, !tbaa !32
  %26 = icmp eq ptr %25, null
  br i1 %26, label %52, label %27

27:                                               ; preds = %23
  %28 = tail call i32 %25(i32 noundef 1, i32 noundef %1, i32 noundef %2) #5
  br label %52

29:                                               ; preds = %9, %44
  %30 = phi i32 [ %47, %44 ], [ 0, %9 ]
  %31 = icmp slt i32 %30, %2
  br i1 %31, label %32, label %48

32:                                               ; preds = %29
  %33 = sub nsw i32 %2, %30
  %34 = tail call i32 @llvm.smin.i32(i32 %33, i32 3072)
  tail call void @begin_op() #5
  %35 = load ptr, ptr %10, align 4, !tbaa !20
  tail call void @vfs_ilock(ptr noundef %35) #5
  %36 = load ptr, ptr %10, align 4, !tbaa !20
  %37 = add i32 %30, %1
  %38 = load i32, ptr %11, align 4, !tbaa !30
  %39 = tail call i32 @vfs_writei(ptr noundef %36, i32 noundef 1, i32 noundef %37, i32 noundef %38, i32 noundef %34) #5
  %40 = icmp sgt i32 %39, 0
  br i1 %40, label %41, label %44

41:                                               ; preds = %32
  %42 = load i32, ptr %11, align 4, !tbaa !30
  %43 = add i32 %42, %39
  store i32 %43, ptr %11, align 4, !tbaa !30
  br label %44

44:                                               ; preds = %41, %32
  %45 = load ptr, ptr %10, align 4, !tbaa !20
  tail call void @vfs_iunlock(ptr noundef %45) #5
  tail call void @end_op() #5
  %46 = icmp eq i32 %39, %34
  %47 = add nsw i32 %39, %30
  br i1 %46, label %29, label %48

48:                                               ; preds = %44, %29
  %49 = icmp eq i32 %30, %2
  %50 = select i1 %49, i32 %2, i32 -1
  br label %52

51:                                               ; preds = %7
  tail call void @panic(ptr noundef nonnull @.str.4) #6
  unreachable

52:                                               ; preds = %12, %48, %27, %16, %21, %23, %3
  %53 = phi i32 [ -1, %3 ], [ -1, %23 ], [ -1, %21 ], [ -1, %16 ], [ %15, %12 ], [ %28, %27 ], [ %50, %48 ]
  ret i32 %53
}

; Function Attrs: minsize optsize
declare dso_local i32 @pipewrite(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @vfs_writei(ptr noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 4}
!4 = !{!"file", !5, i64 0, !5, i64 4, !6, i64 8, !6, i64 9, !8, i64 12, !10, i64 16, !5, i64 20, !11, i64 24}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"p1 _ZTS4pipe", !9, i64 0}
!9 = !{!"any pointer", !6, i64 0}
!10 = !{!"p1 _ZTS5inode", !9, i64 0}
!11 = !{!"short", !6, i64 0}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
!15 = !{!5, !5, i64 0}
!16 = !{!6, !6, i64 0}
!17 = !{!8, !8, i64 0}
!18 = !{!10, !10, i64 0}
!19 = !{!4, !5, i64 0}
!20 = !{!4, !10, i64 16}
!21 = !{!22, !5, i64 0}
!22 = !{!"proc", !5, i64 0, !23, i64 4, !10, i64 8, !6, i64 12}
!23 = !{!"long", !6, i64 0}
!24 = !{!22, !23, i64 4}
!25 = !{!4, !6, i64 8}
!26 = !{!4, !8, i64 12}
!27 = !{!4, !11, i64 24}
!28 = !{!29, !9, i64 0}
!29 = !{!"devsw", !9, i64 0, !9, i64 4}
!30 = !{!4, !5, i64 20}
!31 = !{!4, !6, i64 9}
!32 = !{!29, !9, i64 4}
