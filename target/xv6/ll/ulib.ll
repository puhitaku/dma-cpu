; ModuleID = 'user/ulib.c'
source_filename = "user/ulib.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.dirent = type { i16, [62 x i8] }

@rl_nhist = internal unnamed_addr global i32 0, align 4
@.str = private unnamed_addr constant [4 x i8] c"^C\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"\08 \08\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"\08\00", align 1
@rl_hist = internal global [8 x [128 x i8]] zeroinitializer, align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"\1B[K\0D\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c".\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @start(i32 noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = tail call i32 @main(i32 noundef %0, ptr noundef %1) #9
  %4 = tail call i32 @exit(i32 noundef %3) #10
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @main(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @strcpy(ptr noundef returned writeonly captures(ret: address, provenance) %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #4 {
  br label %3

3:                                                ; preds = %3, %2
  %4 = phi ptr [ %1, %2 ], [ %6, %3 ]
  %5 = phi ptr [ %0, %2 ], [ %8, %3 ]
  %6 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %7 = load i8, ptr %4, align 1, !tbaa !3
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 1
  store i8 %7, ptr %5, align 1, !tbaa !3
  %9 = icmp eq i8 %7, 0
  br i1 %9, label %10, label %3, !llvm.loop !6

10:                                               ; preds = %3
  ret ptr %0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @strcmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #5 {
  br label %3

3:                                                ; preds = %11, %2
  %4 = phi ptr [ %0, %2 ], [ %12, %11 ]
  %5 = phi ptr [ %1, %2 ], [ %13, %11 ]
  %6 = load i8, ptr %4, align 1, !tbaa !3
  %7 = icmp ne i8 %6, 0
  %8 = load i8, ptr %5, align 1, !tbaa !3
  %9 = icmp eq i8 %6, %8
  %10 = select i1 %7, i1 %9, i1 false
  br i1 %10, label %11, label %14

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !9

14:                                               ; preds = %3
  %15 = zext i8 %6 to i32
  %16 = zext i8 %8 to i32
  %17 = sub nsw i32 %15, %16
  ret i32 %17
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local i32 @strlen(ptr noundef readonly captures(none) %0) local_unnamed_addr #5 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  %7 = add nuw nsw i32 %3, 1
  br i1 %6, label %8, label %2, !llvm.loop !10

8:                                                ; preds = %2
  ret i32 %3
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local noundef ptr @memset(ptr noundef returned %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #6 {
  %4 = trunc i32 %1 to i8
  br label %5

5:                                                ; preds = %13, %3
  %6 = phi i32 [ %2, %3 ], [ %15, %13 ]
  %7 = phi ptr [ %0, %3 ], [ %14, %13 ]
  %8 = icmp ne i32 %6, 0
  %9 = ptrtoint ptr %7 to i32
  %10 = and i32 %9, 3
  %11 = icmp ne i32 %10, 0
  %12 = select i1 %8, i1 %11, i1 false
  br i1 %12, label %13, label %16

13:                                               ; preds = %5
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 1
  store i8 %4, ptr %7, align 1, !tbaa !3
  %15 = add i32 %6, -1
  br label %5, !llvm.loop !11

16:                                               ; preds = %5
  %17 = and i32 %1, 255
  %18 = mul nuw i32 %17, 16843009
  br label %19

19:                                               ; preds = %23, %16
  %20 = phi i32 [ %6, %16 ], [ %25, %23 ]
  %21 = phi ptr [ %7, %16 ], [ %24, %23 ]
  %22 = icmp ugt i32 %20, 3
  br i1 %22, label %23, label %26

23:                                               ; preds = %19
  store i32 %18, ptr %21, align 4, !tbaa !12
  %24 = getelementptr inbounds nuw i8, ptr %21, i32 4
  %25 = add i32 %20, -4
  br label %19, !llvm.loop !14

26:                                               ; preds = %19, %30
  %27 = phi i32 [ %31, %30 ], [ %20, %19 ]
  %28 = phi ptr [ %32, %30 ], [ %21, %19 ]
  %29 = icmp eq i32 %27, 0
  br i1 %29, label %33, label %30

30:                                               ; preds = %26
  %31 = add i32 %27, -1
  %32 = getelementptr inbounds nuw i8, ptr %28, i32 1
  store i8 %4, ptr %28, align 1, !tbaa !3
  br label %26, !llvm.loop !15

33:                                               ; preds = %26
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local noundef ptr @strchr(ptr noundef readonly captures(ret: address, provenance) %0, i8 noundef signext %1) local_unnamed_addr #5 {
  br label %3

3:                                                ; preds = %9, %2
  %4 = phi ptr [ %0, %2 ], [ %10, %9 ]
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %11, label %7

7:                                                ; preds = %3
  %8 = icmp eq i8 %5, %1
  br i1 %8, label %11, label %9

9:                                                ; preds = %7
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 1
  br label %3, !llvm.loop !16

11:                                               ; preds = %3, %7
  %12 = phi ptr [ %4, %7 ], [ null, %3 ]
  ret ptr %12
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @gets(ptr noundef returned writeonly captures(ret: address, provenance) %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %3) #11
  br label %4

4:                                                ; preds = %11, %2
  %5 = phi i32 [ 0, %2 ], [ %6, %11 ]
  %6 = add nuw nsw i32 %5, 1
  %7 = icmp slt i32 %6, %1
  br i1 %7, label %8, label %14

8:                                                ; preds = %4
  %9 = call i32 @read(i32 noundef 0, ptr noundef nonnull %3, i32 noundef 1) #9
  %10 = icmp slt i32 %9, 1
  br i1 %10, label %14, label %11

11:                                               ; preds = %8
  %12 = load i8, ptr %3, align 1, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 %5
  store i8 %12, ptr %13, align 1, !tbaa !3
  switch i8 %12, label %4 [
    i8 10, label %14
    i8 13, label %14
  ]

14:                                               ; preds = %11, %11, %8, %4
  %15 = phi i32 [ %5, %8 ], [ %6, %11 ], [ %5, %4 ], [ %6, %11 ]
  %16 = getelementptr inbounds i8, ptr %0, i32 %15
  store i8 0, ptr %16, align 1, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %3) #11
  ret ptr %0
}

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local i32 @stat(ptr noundef %0, ptr noundef %1) local_unnamed_addr #7 {
  %3 = tail call i32 @open(ptr noundef %0, i32 noundef 0) #9
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %8, label %5

5:                                                ; preds = %2
  %6 = tail call i32 @fstat(i32 noundef %3, ptr noundef %1) #9
  %7 = tail call i32 @close(i32 noundef %3) #9
  br label %8

8:                                                ; preds = %2, %5
  %9 = phi i32 [ %6, %5 ], [ -1, %2 ]
  ret i32 %9
}

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local i32 @atoi(ptr noundef readonly captures(none) %0) local_unnamed_addr #5 {
  br label %2

2:                                                ; preds = %8, %1
  %3 = phi ptr [ %0, %1 ], [ %11, %8 ]
  %4 = phi i32 [ 0, %1 ], [ %13, %8 ]
  %5 = load i8, ptr %3, align 1, !tbaa !3
  %6 = add i8 %5, -48
  %7 = icmp ult i8 %6, 10
  br i1 %7, label %8, label %14

8:                                                ; preds = %2
  %9 = zext nneg i8 %5 to i32
  %10 = mul nsw i32 %4, 10
  %11 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %12 = add i32 %10, -48
  %13 = add i32 %12, %9
  br label %2, !llvm.loop !17

14:                                               ; preds = %2
  ret i32 %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memmove(ptr noundef returned %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #4 {
  %4 = icmp ugt ptr %1, %0
  br i1 %4, label %5, label %49

5:                                                ; preds = %3
  %6 = ptrtoint ptr %1 to i32
  %7 = ptrtoint ptr %0 to i32
  %8 = xor i32 %6, %7
  %9 = and i32 %8, 3
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %15, label %11

11:                                               ; preds = %29, %5
  %12 = phi i32 [ %2, %5 ], [ %30, %29 ]
  %13 = phi ptr [ %0, %5 ], [ %31, %29 ]
  %14 = phi ptr [ %1, %5 ], [ %32, %29 ]
  br label %39

15:                                               ; preds = %5, %24
  %16 = phi i32 [ %28, %24 ], [ %2, %5 ]
  %17 = phi ptr [ %27, %24 ], [ %0, %5 ]
  %18 = phi ptr [ %25, %24 ], [ %1, %5 ]
  %19 = icmp sgt i32 %16, 0
  %20 = ptrtoint ptr %17 to i32
  %21 = and i32 %20, 3
  %22 = icmp ne i32 %21, 0
  %23 = select i1 %19, i1 %22, i1 false
  br i1 %23, label %24, label %29

24:                                               ; preds = %15
  %25 = getelementptr inbounds nuw i8, ptr %18, i32 1
  %26 = load i8, ptr %18, align 1, !tbaa !3
  %27 = getelementptr inbounds nuw i8, ptr %17, i32 1
  store i8 %26, ptr %17, align 1, !tbaa !3
  %28 = add nsw i32 %16, -1
  br label %15, !llvm.loop !18

29:                                               ; preds = %15, %34
  %30 = phi i32 [ %38, %34 ], [ %16, %15 ]
  %31 = phi ptr [ %36, %34 ], [ %17, %15 ]
  %32 = phi ptr [ %37, %34 ], [ %18, %15 ]
  %33 = icmp sgt i32 %30, 3
  br i1 %33, label %34, label %11

34:                                               ; preds = %29
  %35 = load i32, ptr %32, align 4, !tbaa !12
  store i32 %35, ptr %31, align 4, !tbaa !12
  %36 = getelementptr inbounds nuw i8, ptr %31, i32 4
  %37 = getelementptr inbounds nuw i8, ptr %32, i32 4
  %38 = add nsw i32 %30, -4
  br label %29, !llvm.loop !19

39:                                               ; preds = %11, %44
  %40 = phi i32 [ %45, %44 ], [ %12, %11 ]
  %41 = phi ptr [ %48, %44 ], [ %13, %11 ]
  %42 = phi ptr [ %46, %44 ], [ %14, %11 ]
  %43 = icmp sgt i32 %40, 0
  br i1 %43, label %44, label %95

44:                                               ; preds = %39
  %45 = add nsw i32 %40, -1
  %46 = getelementptr inbounds nuw i8, ptr %42, i32 1
  %47 = load i8, ptr %42, align 1, !tbaa !3
  %48 = getelementptr inbounds nuw i8, ptr %41, i32 1
  store i8 %47, ptr %41, align 1, !tbaa !3
  br label %39, !llvm.loop !20

49:                                               ; preds = %3
  %50 = getelementptr inbounds i8, ptr %0, i32 %2
  %51 = getelementptr inbounds i8, ptr %1, i32 %2
  %52 = ptrtoint ptr %51 to i32
  %53 = ptrtoint ptr %50 to i32
  %54 = xor i32 %52, %53
  %55 = and i32 %54, 3
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %61, label %57

57:                                               ; preds = %75, %49
  %58 = phi i32 [ %2, %49 ], [ %76, %75 ]
  %59 = phi ptr [ %50, %49 ], [ %77, %75 ]
  %60 = phi ptr [ %51, %49 ], [ %78, %75 ]
  br label %85

61:                                               ; preds = %49, %70
  %62 = phi i32 [ %74, %70 ], [ %2, %49 ]
  %63 = phi ptr [ %73, %70 ], [ %50, %49 ]
  %64 = phi ptr [ %71, %70 ], [ %51, %49 ]
  %65 = icmp sgt i32 %62, 0
  %66 = ptrtoint ptr %63 to i32
  %67 = and i32 %66, 3
  %68 = icmp ne i32 %67, 0
  %69 = and i1 %65, %68
  br i1 %69, label %70, label %75

70:                                               ; preds = %61
  %71 = getelementptr inbounds i8, ptr %64, i32 -1
  %72 = load i8, ptr %71, align 1, !tbaa !3
  %73 = getelementptr inbounds i8, ptr %63, i32 -1
  store i8 %72, ptr %73, align 1, !tbaa !3
  %74 = add nsw i32 %62, -1
  br label %61, !llvm.loop !21

75:                                               ; preds = %61, %80
  %76 = phi i32 [ %84, %80 ], [ %62, %61 ]
  %77 = phi ptr [ %81, %80 ], [ %63, %61 ]
  %78 = phi ptr [ %82, %80 ], [ %64, %61 ]
  %79 = icmp sgt i32 %76, 3
  br i1 %79, label %80, label %57

80:                                               ; preds = %75
  %81 = getelementptr inbounds i8, ptr %77, i32 -4
  %82 = getelementptr inbounds i8, ptr %78, i32 -4
  %83 = load i32, ptr %82, align 4, !tbaa !12
  store i32 %83, ptr %81, align 4, !tbaa !12
  %84 = add nsw i32 %76, -4
  br label %75, !llvm.loop !22

85:                                               ; preds = %57, %90
  %86 = phi i32 [ %91, %90 ], [ %58, %57 ]
  %87 = phi ptr [ %94, %90 ], [ %59, %57 ]
  %88 = phi ptr [ %92, %90 ], [ %60, %57 ]
  %89 = icmp sgt i32 %86, 0
  br i1 %89, label %90, label %95

90:                                               ; preds = %85
  %91 = add nsw i32 %86, -1
  %92 = getelementptr inbounds i8, ptr %88, i32 -1
  %93 = load i8, ptr %92, align 1, !tbaa !3
  %94 = getelementptr inbounds i8, ptr %87, i32 -1
  store i8 %93, ptr %94, align 1, !tbaa !3
  br label %85, !llvm.loop !23

95:                                               ; preds = %85, %39
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @memcmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #5 {
  br label %4

4:                                                ; preds = %18, %3
  %5 = phi i32 [ %2, %3 ], [ %8, %18 ]
  %6 = phi ptr [ %0, %3 ], [ %19, %18 ]
  %7 = phi ptr [ %1, %3 ], [ %20, %18 ]
  %8 = add i32 %5, -1
  %9 = icmp eq i32 %5, 0
  br i1 %9, label %21, label %10

10:                                               ; preds = %4
  %11 = load i8, ptr %6, align 1, !tbaa !3
  %12 = load i8, ptr %7, align 1, !tbaa !3
  %13 = icmp eq i8 %11, %12
  br i1 %13, label %18, label %14

14:                                               ; preds = %10
  %15 = sext i8 %12 to i32
  %16 = sext i8 %11 to i32
  %17 = sub nsw i32 %16, %15
  br label %21

18:                                               ; preds = %10
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %20 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %4, !llvm.loop !24

21:                                               ; preds = %4, %14
  %22 = phi i32 [ %17, %14 ], [ 0, %4 ]
  ret i32 %22
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memcpy(ptr noundef returned %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #4 {
  %4 = tail call ptr @memmove(ptr noundef %0, ptr noundef %1, i32 noundef %2) #12
  ret ptr %0
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @sbrk(i32 noundef %0) local_unnamed_addr #7 {
  %2 = tail call ptr @sys_sbrk(i32 noundef %0, i32 noundef 1) #9
  ret ptr %2
}

; Function Attrs: minsize optsize
declare dso_local ptr @sys_sbrk(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local ptr @sbrklazy(i32 noundef %0) local_unnamed_addr #7 {
  %2 = tail call ptr @sys_sbrk(i32 noundef %0, i32 noundef 2) #9
  ret ptr %2
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fputstr(i32 noundef %0, ptr noundef %1) local_unnamed_addr #7 {
  br label %3

3:                                                ; preds = %3, %2
  %4 = phi i32 [ 0, %2 ], [ %8, %3 ]
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 %4
  %6 = load i8, ptr %5, align 1, !tbaa !3
  %7 = icmp eq i8 %6, 0
  %8 = add nuw nsw i32 %4, 1
  br i1 %7, label %9, label %3, !llvm.loop !25

9:                                                ; preds = %3
  %10 = tail call i32 @write(i32 noundef %0, ptr noundef nonnull %1, i32 noundef %4) #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @fputnum(i32 noundef %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %3) #11
  %4 = tail call i32 @llvm.abs.i32(i32 %1, i1 true)
  br label %5

5:                                                ; preds = %5, %2
  %6 = phi i32 [ 12, %2 ], [ %14, %5 ]
  %7 = phi i32 [ %4, %2 ], [ %9, %5 ]
  %8 = freeze i32 %7
  %9 = udiv i32 %8, 10
  %10 = mul i32 %9, 10
  %11 = sub i32 %8, %10
  %12 = trunc nuw nsw i32 %11 to i8
  %13 = or disjoint i8 %12, 48
  %14 = add nsw i32 %6, -1
  %15 = getelementptr inbounds [12 x i8], ptr %3, i32 0, i32 %14
  store i8 %13, ptr %15, align 1, !tbaa !3
  %16 = icmp samesign ult i32 %7, 10
  br i1 %16, label %17, label %5, !llvm.loop !26

17:                                               ; preds = %5
  %18 = icmp slt i32 %1, 0
  br i1 %18, label %19, label %22

19:                                               ; preds = %17
  %20 = add nsw i32 %6, -2
  %21 = getelementptr inbounds [12 x i8], ptr %3, i32 0, i32 %20
  store i8 45, ptr %21, align 1, !tbaa !3
  br label %22

22:                                               ; preds = %19, %17
  %23 = phi i32 [ %20, %19 ], [ %14, %17 ]
  %24 = getelementptr inbounds i8, ptr %3, i32 %23
  %25 = sub nsw i32 12, %23
  %26 = call i32 @write(i32 noundef %0, ptr noundef nonnull %24, i32 noundef %25) #9
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %3) #11
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @readline(ptr noundef %0, ptr noundef returned %1, i32 noundef %2) local_unnamed_addr #7 {
  %4 = alloca [128 x i8], align 1
  %5 = alloca %struct.dirent, align 2
  %6 = alloca [63 x i8], align 1
  %7 = alloca i8, align 1
  %8 = alloca i8, align 1
  %9 = alloca i8, align 1
  %10 = load i32, ptr @rl_nhist, align 4, !tbaa !12
  tail call void @fputstr(i32 noundef 1, ptr noundef %0) #12
  %11 = tail call i32 @ttyraw(i32 noundef 1) #9
  %12 = getelementptr i8, ptr %1, i32 -1
  %13 = add nsw i32 %2, -2
  %14 = getelementptr inbounds nuw i8, ptr %5, i32 2
  %15 = add nsw i32 %2, -1
  br label %16

16:                                               ; preds = %247, %3
  %17 = phi i32 [ 0, %3 ], [ %248, %247 ]
  %18 = phi i32 [ 0, %3 ], [ %249, %247 ]
  %19 = phi i32 [ %10, %3 ], [ %250, %247 ]
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %7) #11
  %20 = call i32 @read(i32 noundef 0, ptr noundef nonnull %7, i32 noundef 1) #9
  %21 = icmp slt i32 %20, 1
  br i1 %21, label %251, label %22

22:                                               ; preds = %16
  %23 = load i8, ptr %7, align 1, !tbaa !3
  switch i8 %23, label %232 [
    i8 13, label %251
    i8 10, label %251
    i8 3, label %24
    i8 8, label %25
    i8 127, label %25
    i8 1, label %37
    i8 5, label %38
    i8 21, label %39
    i8 9, label %43
    i8 27, label %169
  ]

24:                                               ; preds = %22
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str) #12
  call void @fputstr(i32 noundef 1, ptr noundef %0) #12
  br label %247, !llvm.loop !27

25:                                               ; preds = %22, %22
  %26 = icmp sgt i32 %18, 0
  br i1 %26, label %27, label %247, !llvm.loop !27

27:                                               ; preds = %25
  %28 = getelementptr inbounds nuw i8, ptr %1, i32 %18
  %29 = getelementptr inbounds i8, ptr %28, i32 -1
  %30 = sub nsw i32 %17, %18
  %31 = call ptr @memmove(ptr noundef nonnull %29, ptr noundef nonnull %28, i32 noundef %30) #12
  %32 = add nsw i32 %18, -1
  %33 = add nsw i32 %17, -1
  %34 = icmp eq i32 %18, %17
  br i1 %34, label %35, label %36

35:                                               ; preds = %27
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.1) #12
  br label %247, !llvm.loop !27

36:                                               ; preds = %27
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef nonnull %1, i32 noundef %33, i32 noundef %32) #12
  br label %247, !llvm.loop !27

37:                                               ; preds = %22
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %17, i32 noundef 0) #12
  br label %247, !llvm.loop !27

38:                                               ; preds = %22
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %17, i32 noundef %17) #12
  br label %247, !llvm.loop !27

39:                                               ; preds = %22
  %40 = getelementptr inbounds i8, ptr %1, i32 %18
  %41 = sub nsw i32 %17, %18
  %42 = call ptr @memmove(ptr noundef %1, ptr noundef %40, i32 noundef %41) #12
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %41, i32 noundef 0) #12
  br label %247, !llvm.loop !27

43:                                               ; preds = %22, %50
  %44 = phi i32 [ %51, %50 ], [ %18, %22 ]
  %45 = icmp sgt i32 %44, 0
  br i1 %45, label %46, label %52

46:                                               ; preds = %43
  %47 = getelementptr i8, ptr %12, i32 %44
  %48 = load i8, ptr %47, align 1, !tbaa !3
  %49 = icmp eq i8 %48, 32
  br i1 %49, label %52, label %50

50:                                               ; preds = %46
  %51 = add nsw i32 %44, -1
  br label %43, !llvm.loop !28

52:                                               ; preds = %43, %46
  call void @llvm.lifetime.start.p0(i64 128, ptr nonnull %4) #11
  br label %53

53:                                               ; preds = %57, %52
  %54 = phi i32 [ %44, %52 ], [ %61, %57 ]
  %55 = phi i32 [ %44, %52 ], [ %62, %57 ]
  %56 = icmp slt i32 %54, %18
  br i1 %56, label %57, label %63

57:                                               ; preds = %53
  %58 = getelementptr inbounds i8, ptr %1, i32 %54
  %59 = load i8, ptr %58, align 1, !tbaa !3
  %60 = icmp eq i8 %59, 47
  %61 = add nsw i32 %54, 1
  %62 = select i1 %60, i32 %61, i32 %55
  br label %53, !llvm.loop !29

63:                                               ; preds = %53
  %64 = icmp sgt i32 %55, %44
  br i1 %64, label %65, label %70

65:                                               ; preds = %63
  %66 = getelementptr inbounds i8, ptr %1, i32 %44
  %67 = sub nsw i32 %55, %44
  %68 = call ptr @memmove(ptr noundef nonnull %4, ptr noundef %66, i32 noundef %67) #12
  %69 = getelementptr inbounds nuw [128 x i8], ptr %4, i32 0, i32 %67
  store i8 0, ptr %69, align 1, !tbaa !3
  br label %76

70:                                               ; preds = %63
  %71 = icmp eq i32 %44, 0
  br i1 %71, label %72, label %74

72:                                               ; preds = %70
  %73 = call ptr @strcpy(ptr noundef nonnull %4, ptr noundef nonnull @.str.6) #12
  br label %76

74:                                               ; preds = %70
  %75 = call ptr @strcpy(ptr noundef nonnull %4, ptr noundef nonnull @.str.7) #12
  br label %76

76:                                               ; preds = %74, %72, %65
  %77 = sub nsw i32 %18, %55
  %78 = call i32 @open(ptr noundef nonnull %4, i32 noundef 0) #9
  %79 = icmp slt i32 %78, 0
  br i1 %79, label %80, label %81

80:                                               ; preds = %76
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %4) #11
  br label %247

81:                                               ; preds = %76
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #11
  call void @llvm.lifetime.start.p0(i64 63, ptr nonnull %6) #11
  %82 = icmp sgt i32 %77, 62
  %83 = getelementptr i8, ptr %1, i32 %55
  br label %84

84:                                               ; preds = %134, %81
  %85 = phi i32 [ %136, %134 ], [ 0, %81 ]
  %86 = phi i32 [ %135, %134 ], [ 0, %81 ]
  br label %87

87:                                               ; preds = %97, %84
  %88 = call i32 @read(i32 noundef %78, ptr noundef nonnull %5, i32 noundef 64) #9
  %89 = icmp eq i32 %88, 64
  br i1 %89, label %90, label %137

90:                                               ; preds = %87
  %91 = load i16, ptr %5, align 2, !tbaa !30
  %92 = icmp eq i16 %91, 0
  br i1 %92, label %97, label %93

93:                                               ; preds = %90
  %94 = load i8, ptr %14, align 2, !tbaa !3
  %95 = icmp eq i8 %94, 46
  %96 = select i1 %95, i1 true, i1 %82
  br i1 %96, label %97, label %98

97:                                               ; preds = %101, %93, %90
  br label %87, !llvm.loop !33

98:                                               ; preds = %93, %101
  %99 = phi i32 [ %107, %101 ], [ 0, %93 ]
  %100 = icmp slt i32 %99, %77
  br i1 %100, label %101, label %108

101:                                              ; preds = %98
  %102 = getelementptr inbounds nuw [62 x i8], ptr %14, i32 0, i32 %99
  %103 = load i8, ptr %102, align 1, !tbaa !3
  %104 = getelementptr i8, ptr %83, i32 %99
  %105 = load i8, ptr %104, align 1, !tbaa !3
  %106 = icmp eq i8 %103, %105
  %107 = add nuw nsw i32 %99, 1
  br i1 %106, label %98, label %97, !llvm.loop !34

108:                                              ; preds = %98, %115
  %109 = phi i32 [ %116, %115 ], [ 0, %98 ]
  %110 = icmp eq i32 %109, 62
  br i1 %110, label %117, label %111

111:                                              ; preds = %108
  %112 = getelementptr inbounds nuw [62 x i8], ptr %14, i32 0, i32 %109
  %113 = load i8, ptr %112, align 1, !tbaa !3
  %114 = icmp eq i8 %113, 0
  br i1 %114, label %117, label %115

115:                                              ; preds = %111
  %116 = add nuw nsw i32 %109, 1
  br label %108, !llvm.loop !35

117:                                              ; preds = %111, %108
  %118 = icmp eq i32 %85, 0
  br i1 %118, label %121, label %119

119:                                              ; preds = %117
  %120 = call i32 @llvm.smin.i32(i32 %86, i32 %109)
  br label %123

121:                                              ; preds = %117
  %122 = call ptr @memmove(ptr noundef nonnull %6, ptr noundef nonnull %14, i32 noundef %109) #12
  br label %134

123:                                              ; preds = %132, %119
  %124 = phi i32 [ %133, %132 ], [ 0, %119 ]
  %125 = icmp eq i32 %124, %120
  br i1 %125, label %134, label %126

126:                                              ; preds = %123
  %127 = getelementptr inbounds nuw [63 x i8], ptr %6, i32 0, i32 %124
  %128 = load i8, ptr %127, align 1, !tbaa !3
  %129 = getelementptr inbounds nuw [62 x i8], ptr %14, i32 0, i32 %124
  %130 = load i8, ptr %129, align 1, !tbaa !3
  %131 = icmp eq i8 %128, %130
  br i1 %131, label %132, label %134

132:                                              ; preds = %126
  %133 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !36

134:                                              ; preds = %126, %123, %121
  %135 = phi i32 [ %109, %121 ], [ %120, %123 ], [ %124, %126 ]
  %136 = add nuw nsw i32 %85, 1
  br label %84, !llvm.loop !33

137:                                              ; preds = %87
  %138 = call i32 @close(i32 noundef %78) #9
  %139 = icmp ne i32 %85, 0
  %140 = icmp sgt i32 %86, %77
  %141 = select i1 %139, i1 %140, i1 false
  br i1 %141, label %142, label %165

142:                                              ; preds = %137
  %143 = sub nsw i32 %86, %77
  %144 = add i32 %17, 1
  %145 = add i32 %144, %143
  %146 = icmp slt i32 %145, %13
  br i1 %146, label %147, label %165

147:                                              ; preds = %142
  %148 = getelementptr inbounds i8, ptr %1, i32 %18
  %149 = getelementptr inbounds i8, ptr %148, i32 %143
  %150 = sub i32 %17, %18
  %151 = call ptr @memmove(ptr noundef %149, ptr noundef %148, i32 noundef %150) #12
  %152 = getelementptr inbounds i8, ptr %6, i32 %77
  %153 = call ptr @memmove(ptr noundef %148, ptr noundef nonnull %152, i32 noundef %143) #12
  %154 = add nsw i32 %143, %17
  %155 = add nsw i32 %143, %18
  %156 = icmp eq i32 %85, 1
  br i1 %156, label %157, label %166

157:                                              ; preds = %147
  %158 = add nsw i32 %154, 1
  %159 = icmp slt i32 %158, %13
  br i1 %159, label %160, label %166

160:                                              ; preds = %157
  %161 = getelementptr inbounds i8, ptr %1, i32 %155
  %162 = getelementptr inbounds nuw i8, ptr %161, i32 1
  %163 = call ptr @memmove(ptr noundef nonnull %162, ptr noundef %161, i32 noundef %150) #12
  store i8 32, ptr %161, align 1, !tbaa !3
  %164 = add nsw i32 %155, 1
  br label %166

165:                                              ; preds = %137, %142
  call void @llvm.lifetime.end.p0(i64 63, ptr nonnull %6) #11
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #11
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %4) #11
  br label %247

166:                                              ; preds = %160, %157, %147
  %167 = phi i32 [ %154, %147 ], [ %154, %157 ], [ %158, %160 ]
  %168 = phi i32 [ %155, %147 ], [ %155, %157 ], [ %164, %160 ]
  call void @llvm.lifetime.end.p0(i64 63, ptr nonnull %6) #11
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #11
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %4) #11
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %167, i32 noundef %168) #12
  br label %247

169:                                              ; preds = %22
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %8) #11
  store i8 0, ptr %8, align 1, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %9) #11
  store i8 0, ptr %9, align 1, !tbaa !3
  %170 = call i32 @read(i32 noundef 0, ptr noundef nonnull %8, i32 noundef 1) #9
  %171 = icmp slt i32 %170, 1
  br i1 %171, label %228, label %172, !llvm.loop !27

172:                                              ; preds = %169
  %173 = load i8, ptr %8, align 1, !tbaa !3
  switch i8 %173, label %228 [
    i8 91, label %174
    i8 79, label %174
  ], !llvm.loop !27

174:                                              ; preds = %172, %172
  %175 = call i32 @read(i32 noundef 0, ptr noundef nonnull %9, i32 noundef 1) #9
  %176 = icmp slt i32 %175, 1
  br i1 %176, label %228, label %177, !llvm.loop !27

177:                                              ; preds = %174
  %178 = load i8, ptr %9, align 1, !tbaa !3
  %179 = icmp eq i8 %178, 68
  %180 = icmp sgt i32 %18, 0
  %181 = select i1 %179, i1 %180, i1 false
  br i1 %181, label %182, label %184

182:                                              ; preds = %177
  %183 = add nsw i32 %18, -1
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.2) #12
  br label %228, !llvm.loop !27

184:                                              ; preds = %177
  %185 = icmp eq i8 %178, 67
  %186 = icmp slt i32 %18, %17
  %187 = select i1 %185, i1 %186, i1 false
  br i1 %187, label %188, label %192

188:                                              ; preds = %184
  %189 = getelementptr inbounds i8, ptr %1, i32 %18
  %190 = call i32 @write(i32 noundef 1, ptr noundef %189, i32 noundef 1) #9
  %191 = add nsw i32 %18, 1
  br label %228, !llvm.loop !27

192:                                              ; preds = %184
  switch i8 %178, label %228 [
    i8 72, label %193
    i8 70, label %193
    i8 51, label %196
    i8 65, label %205
    i8 66, label %205
  ], !llvm.loop !27

193:                                              ; preds = %192, %192
  %194 = icmp eq i8 %178, 72
  %195 = select i1 %194, i32 0, i32 %17
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %17, i32 noundef %195) #12
  br label %228, !llvm.loop !27

196:                                              ; preds = %192
  %197 = call i32 @read(i32 noundef 0, ptr noundef nonnull %9, i32 noundef 1) #9
  br i1 %186, label %198, label %228, !llvm.loop !27

198:                                              ; preds = %196
  %199 = getelementptr inbounds i8, ptr %1, i32 %18
  %200 = getelementptr inbounds nuw i8, ptr %199, i32 1
  %201 = xor i32 %18, -1
  %202 = add i32 %17, %201
  %203 = call ptr @memmove(ptr noundef %199, ptr noundef nonnull %200, i32 noundef %202) #12
  %204 = add nsw i32 %17, -1
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %204, i32 noundef %18) #12
  br label %228, !llvm.loop !27

205:                                              ; preds = %192, %192
  %206 = icmp eq i8 %178, 65
  %207 = select i1 %206, i32 -1, i32 1
  %208 = add nsw i32 %207, %19
  %209 = icmp slt i32 %208, 0
  br i1 %209, label %225, label %210, !llvm.loop !27

210:                                              ; preds = %205
  %211 = load i32, ptr @rl_nhist, align 4, !tbaa !12
  %212 = icmp sgt i32 %208, %211
  br i1 %212, label %225, label %213, !llvm.loop !27

213:                                              ; preds = %210
  %214 = icmp eq i32 %211, 0
  br i1 %214, label %225, label %215, !llvm.loop !27

215:                                              ; preds = %213
  %216 = sub nsw i32 %211, %208
  %217 = icmp sgt i32 %216, 8
  br i1 %217, label %225, label %218, !llvm.loop !27

218:                                              ; preds = %215
  %219 = icmp eq i32 %208, %211
  br i1 %219, label %226, label %220

220:                                              ; preds = %218
  %221 = and i32 %208, 7
  %222 = getelementptr inbounds nuw [8 x [128 x i8]], ptr @rl_hist, i32 0, i32 %221
  %223 = call ptr @strcpy(ptr noundef %1, ptr noundef nonnull %222) #12
  %224 = call i32 @strlen(ptr noundef %1) #12
  br label %226

225:                                              ; preds = %215, %213, %210, %205
  br label %228, !llvm.loop !27

226:                                              ; preds = %218, %220
  %227 = phi i32 [ %224, %220 ], [ 0, %218 ]
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %227, i32 noundef %227) #12
  br label %228, !llvm.loop !27

228:                                              ; preds = %226, %225, %182, %193, %196, %198, %188, %192, %174, %169, %172
  %229 = phi i32 [ %17, %169 ], [ %17, %172 ], [ %17, %174 ], [ %17, %182 ], [ %17, %188 ], [ %17, %192 ], [ %17, %193 ], [ %204, %198 ], [ %17, %196 ], [ %227, %226 ], [ %17, %225 ]
  %230 = phi i32 [ %18, %169 ], [ %18, %172 ], [ %18, %174 ], [ %183, %182 ], [ %191, %188 ], [ %18, %192 ], [ %195, %193 ], [ %18, %198 ], [ %18, %196 ], [ %227, %226 ], [ %18, %225 ]
  %231 = phi i32 [ %19, %169 ], [ %19, %172 ], [ %19, %174 ], [ %19, %182 ], [ %19, %188 ], [ %19, %192 ], [ %19, %193 ], [ %19, %198 ], [ %19, %196 ], [ %208, %226 ], [ %19, %225 ]
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %9) #11
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %8) #11
  br label %247

232:                                              ; preds = %22
  %233 = icmp sgt i8 %23, 31
  br i1 %233, label %234, label %247

234:                                              ; preds = %232
  %235 = add nsw i32 %17, 1
  %236 = icmp slt i32 %235, %15
  br i1 %236, label %237, label %247

237:                                              ; preds = %234
  %238 = getelementptr inbounds i8, ptr %1, i32 %18
  %239 = getelementptr inbounds nuw i8, ptr %238, i32 1
  %240 = sub nsw i32 %17, %18
  %241 = call ptr @memmove(ptr noundef nonnull %239, ptr noundef %238, i32 noundef %240) #12
  store i8 %23, ptr %238, align 1, !tbaa !3
  %242 = add nsw i32 %18, 1
  %243 = icmp eq i32 %18, %17
  br i1 %243, label %244, label %246

244:                                              ; preds = %237
  %245 = call i32 @write(i32 noundef 1, ptr noundef nonnull %7, i32 noundef 1) #9
  br label %247

246:                                              ; preds = %237
  call fastcc void @rl_redraw(ptr noundef %0, ptr noundef nonnull %1, i32 noundef %235, i32 noundef %242) #12
  br label %247

247:                                              ; preds = %165, %80, %232, %234, %246, %244, %166, %25, %36, %35, %228, %39, %38, %37, %24
  %248 = phi i32 [ %235, %244 ], [ %235, %246 ], [ %17, %234 ], [ %17, %232 ], [ 0, %24 ], [ %33, %35 ], [ %33, %36 ], [ %17, %25 ], [ %17, %37 ], [ %17, %38 ], [ %41, %39 ], [ %17, %165 ], [ %167, %166 ], [ %229, %228 ], [ %17, %80 ]
  %249 = phi i32 [ %242, %244 ], [ %242, %246 ], [ %18, %234 ], [ %18, %232 ], [ 0, %24 ], [ %32, %35 ], [ %32, %36 ], [ %18, %25 ], [ 0, %37 ], [ %17, %38 ], [ 0, %39 ], [ %18, %165 ], [ %168, %166 ], [ %230, %228 ], [ %18, %80 ]
  %250 = phi i32 [ %19, %244 ], [ %19, %246 ], [ %19, %234 ], [ %19, %232 ], [ %19, %24 ], [ %19, %35 ], [ %19, %36 ], [ %19, %25 ], [ %19, %37 ], [ %19, %38 ], [ %19, %39 ], [ %19, %165 ], [ %19, %166 ], [ %231, %228 ], [ %19, %80 ]
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %7) #11
  br label %16

251:                                              ; preds = %16, %22, %22
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %7) #11
  %252 = call i32 @ttyraw(i32 noundef 0) #9
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.3) #12
  %253 = add i32 %17, -1
  %254 = icmp ult i32 %253, 127
  br i1 %254, label %255, label %270

255:                                              ; preds = %251
  %256 = getelementptr inbounds nuw i8, ptr %1, i32 %17
  store i8 0, ptr %256, align 1, !tbaa !3
  %257 = load i32, ptr @rl_nhist, align 4, !tbaa !12
  %258 = icmp eq i32 %257, 0
  br i1 %258, label %265, label %259

259:                                              ; preds = %255
  %260 = add nsw i32 %257, -1
  %261 = srem i32 %260, 8
  %262 = getelementptr inbounds [8 x [128 x i8]], ptr @rl_hist, i32 0, i32 %261
  %263 = call i32 @strcmp(ptr noundef nonnull %262, ptr noundef nonnull %1) #12
  %264 = icmp eq i32 %263, 0
  br i1 %264, label %270, label %265

265:                                              ; preds = %259, %255
  %266 = srem i32 %257, 8
  %267 = getelementptr inbounds [8 x [128 x i8]], ptr @rl_hist, i32 0, i32 %266
  %268 = call ptr @strcpy(ptr noundef nonnull %267, ptr noundef nonnull %1) #12
  %269 = add nsw i32 %257, 1
  store i32 %269, ptr @rl_nhist, align 4, !tbaa !12
  br label %270

270:                                              ; preds = %259, %265, %251
  %271 = getelementptr inbounds i8, ptr %1, i32 %17
  store i8 10, ptr %271, align 1, !tbaa !3
  %272 = getelementptr i8, ptr %271, i32 1
  store i8 0, ptr %272, align 1, !tbaa !3
  ret ptr %1
}

; Function Attrs: minsize optsize
declare dso_local i32 @ttyraw(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @rl_redraw(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) unnamed_addr #7 {
  tail call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.4) #12
  tail call void @fputstr(i32 noundef 1, ptr noundef %0) #12
  %5 = tail call i32 @write(i32 noundef 1, ptr noundef %1, i32 noundef %2) #9
  tail call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.5) #12
  tail call void @fputstr(i32 noundef 1, ptr noundef %0) #12
  %6 = tail call i32 @write(i32 noundef 1, ptr noundef %1, i32 noundef %3) #9
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.abs.i32(i32, i1 immarg) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #8

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #10 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #11 = { nounwind }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }

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
!10 = distinct !{!10, !7, !8}
!11 = distinct !{!11, !7, !8}
!12 = !{!13, !13, i64 0}
!13 = !{!"int", !4, i64 0}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !7, !8}
!17 = distinct !{!17, !7, !8}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !7, !8}
!23 = distinct !{!23, !7, !8}
!24 = distinct !{!24, !7, !8}
!25 = distinct !{!25, !7, !8}
!26 = distinct !{!26, !7, !8}
!27 = distinct !{!27, !8}
!28 = distinct !{!28, !7, !8}
!29 = distinct !{!29, !7, !8}
!30 = !{!31, !32, i64 0}
!31 = !{!"dirent", !32, i64 0, !4, i64 2}
!32 = !{!"short", !4, i64 0}
!33 = distinct !{!33, !7, !8}
!34 = distinct !{!34, !7, !8}
!35 = distinct !{!35, !7, !8}
!36 = distinct !{!36, !7, !8}
