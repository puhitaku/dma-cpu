; ModuleID = 'user/ls.c'
source_filename = "user/ls.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.dirent = type { i16, [14 x i8] }
%struct.stat = type { i32, i32, i16, i16, i32 }

@fmtname.buf = internal global [15 x i8] zeroinitializer, align 1
@.str = private unnamed_addr constant [17 x i8] c"ls: cannot open \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"ls: cannot stat \00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.4 = private unnamed_addr constant [19 x i8] c"ls: path too long\0A\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c".\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local noundef nonnull ptr @fmtname(ptr noundef %0) local_unnamed_addr #0 {
  %2 = tail call i32 @strlen(ptr noundef %0) #5
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 %2
  br label %4

4:                                                ; preds = %10, %1
  %5 = phi ptr [ %3, %1 ], [ %11, %10 ]
  %6 = icmp ult ptr %5, %0
  br i1 %6, label %12, label %7

7:                                                ; preds = %4
  %8 = load i8, ptr %5, align 1, !tbaa !3
  %9 = icmp eq i8 %8, 47
  br i1 %9, label %12, label %10

10:                                               ; preds = %7
  %11 = getelementptr inbounds i8, ptr %5, i32 -1
  br label %4, !llvm.loop !6

12:                                               ; preds = %4, %7
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %14 = tail call i32 @strlen(ptr noundef nonnull %13) #5
  %15 = icmp ugt i32 %14, 13
  br i1 %15, label %24, label %16

16:                                               ; preds = %12
  %17 = tail call i32 @strlen(ptr noundef nonnull %13) #5
  %18 = tail call ptr @memmove(ptr noundef nonnull @fmtname.buf, ptr noundef nonnull %13, i32 noundef %17) #5
  %19 = tail call i32 @strlen(ptr noundef nonnull %13) #5
  %20 = getelementptr inbounds nuw i8, ptr @fmtname.buf, i32 %19
  %21 = tail call i32 @strlen(ptr noundef nonnull %13) #5
  %22 = sub i32 14, %21
  %23 = tail call ptr @memset(ptr noundef nonnull %20, i32 noundef 32, i32 noundef %22) #5
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @fmtname.buf, i32 14), align 1, !tbaa !3
  br label %24

24:                                               ; preds = %12, %16
  %25 = phi ptr [ @fmtname.buf, %16 ], [ %13, %12 ]
  ret ptr %25
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @strlen(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define dso_local void @ls(ptr noundef %0) local_unnamed_addr #0 {
  %2 = alloca [512 x i8], align 1
  %3 = alloca %struct.dirent, align 2
  %4 = alloca %struct.stat, align 4
  call void @llvm.lifetime.start.p0(i64 512, ptr nonnull %2) #6
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #6
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #6
  %5 = tail call i32 @open(ptr noundef %0, i32 noundef 0) #5
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %7, label %8

7:                                                ; preds = %1
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str) #5
  tail call void @fputstr(i32 noundef 2, ptr noundef %0) #5
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.1) #5
  br label %60

8:                                                ; preds = %1
  %9 = call i32 @fstat(i32 noundef %5, ptr noundef nonnull %4) #5
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.2) #5
  call void @fputstr(i32 noundef 2, ptr noundef %0) #5
  call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.1) #5
  %12 = call i32 @close(i32 noundef %5) #5
  br label %60

13:                                               ; preds = %8
  %14 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %15 = load i16, ptr %14, align 4, !tbaa !9
  switch i16 %15, label %58 [
    i16 3, label %16
    i16 2, label %16
    i16 1, label %24
  ]

16:                                               ; preds = %13, %13
  %17 = call ptr @fmtname(ptr noundef %0) #7
  call void @fputstr(i32 noundef 1, ptr noundef nonnull %17) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #5
  %18 = load i16, ptr %14, align 4, !tbaa !9
  %19 = sext i16 %18 to i32
  call void @fputnum(i32 noundef 1, i32 noundef %19) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #5
  %20 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !14
  call void @fputnum(i32 noundef 1, i32 noundef %21) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #5
  %22 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %23 = load i32, ptr %22, align 4, !tbaa !15
  call void @fputnum(i32 noundef 1, i32 noundef %23) #5
  br label %56

24:                                               ; preds = %13
  %25 = call i32 @strlen(ptr noundef %0) #5
  %26 = add i32 %25, -497
  %27 = icmp ult i32 %26, -513
  br i1 %27, label %56, label %28

28:                                               ; preds = %24
  %29 = call ptr @strcpy(ptr noundef nonnull %2, ptr noundef %0) #5
  %30 = call i32 @strlen(ptr noundef nonnull %2) #5
  %31 = getelementptr inbounds nuw i8, ptr %2, i32 %30
  %32 = getelementptr inbounds nuw i8, ptr %31, i32 1
  store i8 47, ptr %31, align 1, !tbaa !3
  %33 = getelementptr inbounds nuw i8, ptr %3, i32 2
  %34 = getelementptr inbounds nuw i8, ptr %31, i32 15
  %35 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %36 = getelementptr inbounds nuw i8, ptr %4, i32 12
  br label %37

37:                                               ; preds = %49, %28
  %38 = call i32 @read(i32 noundef %5, ptr noundef nonnull %3, i32 noundef 16) #5
  %39 = icmp eq i32 %38, 16
  br i1 %39, label %40, label %58

40:                                               ; preds = %37
  %41 = load i16, ptr %3, align 2, !tbaa !16
  %42 = icmp eq i16 %41, 0
  br i1 %42, label %49, label %43

43:                                               ; preds = %40
  %44 = call ptr @memmove(ptr noundef nonnull %32, ptr noundef nonnull %33, i32 noundef 14) #5
  store i8 0, ptr %34, align 1, !tbaa !3
  %45 = call i32 @stat(ptr noundef nonnull %2, ptr noundef nonnull %4) #5
  %46 = icmp slt i32 %45, 0
  br i1 %46, label %47, label %50

47:                                               ; preds = %43
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.2) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull %2) #5
  br label %48

48:                                               ; preds = %50, %47
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.1) #5
  br label %49

49:                                               ; preds = %48, %40
  br label %37, !llvm.loop !18

50:                                               ; preds = %43
  %51 = call ptr @fmtname(ptr noundef nonnull %2) #7
  call void @fputstr(i32 noundef 1, ptr noundef nonnull %51) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #5
  %52 = load i16, ptr %14, align 4, !tbaa !9
  %53 = sext i16 %52 to i32
  call void @fputnum(i32 noundef 1, i32 noundef %53) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #5
  %54 = load i32, ptr %35, align 4, !tbaa !14
  call void @fputnum(i32 noundef 1, i32 noundef %54) #5
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #5
  %55 = load i32, ptr %36, align 4, !tbaa !15
  call void @fputnum(i32 noundef 1, i32 noundef %55) #5
  br label %48

56:                                               ; preds = %24, %16
  %57 = phi ptr [ @.str.1, %16 ], [ @.str.4, %24 ]
  call void @fputstr(i32 noundef 1, ptr noundef nonnull %57) #5
  br label %58

58:                                               ; preds = %37, %56, %13
  %59 = call i32 @close(i32 noundef %5) #5
  br label %60

60:                                               ; preds = %58, %11, %7
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #6
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #6
  call void @llvm.lifetime.end.p0(i64 512, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @fputnum(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local ptr @strcpy(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @stat(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #3 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  tail call void @ls(ptr noundef nonnull @.str.5) #7
  %5 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

6:                                                ; preds = %2, %9
  %7 = phi i32 [ %12, %9 ], [ 1, %2 ]
  %8 = icmp eq i32 %7, %0
  br i1 %8, label %13, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw ptr, ptr %1, i32 %7
  %11 = load ptr, ptr %10, align 4, !tbaa !19
  tail call void @ls(ptr noundef %11) #7
  %12 = add nuw i32 %7, 1
  br label %6, !llvm.loop !22

13:                                               ; preds = %6
  %14 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #4

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { nounwind }
attributes #7 = { minsize nobuiltin optsize "no-builtins" }
attributes #8 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }

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
!9 = !{!10, !12, i64 8}
!10 = !{!"stat", !11, i64 0, !11, i64 4, !12, i64 8, !12, i64 10, !13, i64 12}
!11 = !{!"int", !4, i64 0}
!12 = !{!"short", !4, i64 0}
!13 = !{!"long", !4, i64 0}
!14 = !{!10, !11, i64 4}
!15 = !{!10, !13, i64 12}
!16 = !{!17, !12, i64 0}
!17 = !{!"dirent", !12, i64 0, !4, i64 2}
!18 = distinct !{!18, !7, !8}
!19 = !{!20, !20, i64 0}
!20 = !{!"p1 omnipotent char", !21, i64 0}
!21 = !{!"any pointer", !4, i64 0}
!22 = distinct !{!22, !7, !8}
