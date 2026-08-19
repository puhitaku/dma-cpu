; ModuleID = 'kdev.c'
source_filename = "kdev.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.anon = type { ptr, i32, i32 }
%struct.inode = type { i32, i32, i32, %struct.sleeplock, i32, i16, i16, i16, i16, i32, [13 x i32] }
%struct.sleeplock = type { i8 }
%struct.dirent = type { i16, [62 x i8] }

@devtab = internal unnamed_addr constant [9 x %struct.anon] [%struct.anon { ptr @.str, i32 1, i32 0 }, %struct.anon { ptr @.str.1, i32 2, i32 0 }, %struct.anon { ptr @.str.2, i32 6, i32 0 }, %struct.anon { ptr @.str.3, i32 3, i32 0 }, %struct.anon { ptr @.str.4, i32 4, i32 0 }, %struct.anon { ptr @.str.5, i32 4, i32 1 }, %struct.anon { ptr @.str.6, i32 4, i32 2 }, %struct.anon { ptr @.str.7, i32 5, i32 0 }, %struct.anon { ptr @.str.8, i32 7, i32 0 }], align 4
@fatvol = external dso_local local_unnamed_addr global i32, align 4
@devnodes = internal global [8 x %struct.inode] zeroinitializer, align 4
@.str = private unnamed_addr constant [8 x i8] c"console\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"fat0\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"sd0\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"gpio\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"pio0\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"pio1\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"pio2\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"fb0\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"apps\00", align 1
@gpiopins = external dso_local local_unnamed_addr global i32, align 4
@.str.9 = private unnamed_addr constant [13 x i8] c"sm_enable=0x\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"off\0A\00", align 1
@.str.11 = private unnamed_addr constant [8 x i8] c" owner=\00", align 1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define dso_local range(i32 0, 2) i32 @dev_is(ptr noundef readonly captures(address_is_null) %0) local_unnamed_addr #0 {
  %2 = icmp eq ptr %0, null
  br i1 %2, label %7, label %3

3:                                                ; preds = %1
  %4 = load i32, ptr %0, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 3559
  %6 = zext i1 %5 to i32
  br label %7

7:                                                ; preds = %3, %1
  %8 = phi i32 [ 0, %1 ], [ %6, %3 ]
  ret i32 %8
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @dev_root() local_unnamed_addr #1 {
  %1 = tail call fastcc ptr @dev_getnode(i32 noundef 0) #6
  ret ptr %1
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @dev_getnode(i32 noundef range(i32 -2147483647, 10) %0) unnamed_addr #1 {
  br label %2

2:                                                ; preds = %15, %1
  %3 = phi ptr [ null, %1 ], [ %19, %15 ]
  %4 = phi i32 [ 0, %1 ], [ %20, %15 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %24, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw [8 x %struct.inode], ptr @devnodes, i32 0, i32 %4
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 8
  %9 = load i32, ptr %8, align 4, !tbaa !10
  %10 = icmp sgt i32 %9, 0
  br i1 %10, label %11, label %15

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %13 = load i32, ptr %12, align 4, !tbaa !11
  %14 = icmp eq i32 %13, %0
  br i1 %14, label %21, label %15

15:                                               ; preds = %11, %6
  %16 = icmp eq i32 %9, 0
  %17 = icmp eq ptr %3, null
  %18 = select i1 %16, i1 %17, i1 false
  %19 = select i1 %18, ptr %7, ptr %3
  %20 = add nuw nsw i32 %4, 1
  br label %2, !llvm.loop !12

21:                                               ; preds = %11
  %22 = getelementptr inbounds nuw i8, ptr %7, i32 8
  %23 = add nuw nsw i32 %9, 1
  store i32 %23, ptr %22, align 4, !tbaa !10
  br label %43

24:                                               ; preds = %2
  %25 = icmp eq ptr %3, null
  br i1 %25, label %43, label %26

26:                                               ; preds = %24
  store i32 3559, ptr %3, align 4, !tbaa !3
  %27 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store i32 %0, ptr %27, align 4, !tbaa !11
  %28 = getelementptr inbounds nuw i8, ptr %3, i32 8
  store i32 1, ptr %28, align 4, !tbaa !10
  %29 = getelementptr inbounds nuw i8, ptr %3, i32 26
  store i16 1, ptr %29, align 2, !tbaa !15
  %30 = getelementptr inbounds nuw i8, ptr %3, i32 22
  store i16 0, ptr %30, align 2, !tbaa !16
  %31 = icmp eq i32 %0, 0
  br i1 %31, label %32, label %35

32:                                               ; preds = %26
  %33 = getelementptr inbounds nuw i8, ptr %3, i32 20
  store i16 1, ptr %33, align 4, !tbaa !17
  %34 = getelementptr inbounds nuw i8, ptr %3, i32 28
  store i32 704, ptr %34, align 4, !tbaa !18
  br label %43

35:                                               ; preds = %26
  %36 = add nsw i32 %0, -1
  %37 = icmp eq i32 %36, 0
  %38 = getelementptr inbounds nuw i8, ptr %3, i32 20
  %39 = getelementptr inbounds nuw i8, ptr %3, i32 28
  br i1 %37, label %40, label %41

40:                                               ; preds = %35
  store i16 3, ptr %38, align 4, !tbaa !17
  store i16 1, ptr %30, align 2, !tbaa !16
  store i32 0, ptr %39, align 4, !tbaa !18
  br label %43

41:                                               ; preds = %35
  store i16 2, ptr %38, align 4, !tbaa !17
  %42 = tail call fastcc i32 @dev_size(i32 noundef %36) #6
  store i32 %42, ptr %39, align 4, !tbaa !18
  br label %43

43:                                               ; preds = %21, %32, %41, %40, %24
  %44 = phi ptr [ %7, %21 ], [ null, %24 ], [ %3, %40 ], [ %3, %41 ], [ %3, %32 ]
  ret ptr %44
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @dev_put(ptr noundef captures(none) %0) local_unnamed_addr #2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !10
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  %6 = add nsw i32 %3, -1
  store i32 %6, ptr %2, align 4, !tbaa !10
  br label %7

7:                                                ; preds = %5, %1
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @dev_dup(ptr noundef captures(none) %0) local_unnamed_addr #2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !10
  %4 = add nsw i32 %3, 1
  store i32 %4, ptr %2, align 4, !tbaa !10
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @dev_lookup(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #1 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !11
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %40

6:                                                ; preds = %2
  %7 = load i8, ptr %1, align 1, !tbaa !19
  %8 = icmp eq i8 %7, 46
  br i1 %8, label %9, label %13

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %1, i32 1
  %11 = load i8, ptr %10, align 1, !tbaa !19
  %12 = icmp eq i8 %11, 0
  br i1 %12, label %37, label %13

13:                                               ; preds = %9, %6
  br label %14

14:                                               ; preds = %13, %35
  %15 = phi i32 [ %36, %35 ], [ 0, %13 ]
  %16 = icmp eq i32 %15, 9
  br i1 %16, label %40, label %17

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw [9 x %struct.anon], ptr @devtab, i32 0, i32 %15
  %19 = load ptr, ptr %18, align 4, !tbaa !20
  br label %20

20:                                               ; preds = %28, %17
  %21 = phi ptr [ %19, %17 ], [ %29, %28 ]
  %22 = phi ptr [ %1, %17 ], [ %30, %28 ]
  %23 = load i8, ptr %21, align 1, !tbaa !19
  %24 = icmp eq i8 %23, 0
  %25 = load i8, ptr %22, align 1, !tbaa !19
  br i1 %24, label %31, label %26

26:                                               ; preds = %20
  %27 = icmp eq i8 %23, %25
  br i1 %27, label %28, label %35

28:                                               ; preds = %26
  %29 = getelementptr inbounds nuw i8, ptr %21, i32 1
  %30 = getelementptr inbounds nuw i8, ptr %22, i32 1
  br label %20, !llvm.loop !24

31:                                               ; preds = %20
  %32 = icmp eq i8 %25, 0
  br i1 %32, label %33, label %35

33:                                               ; preds = %31
  %34 = add nuw nsw i32 %15, 1
  br label %37

35:                                               ; preds = %26, %31
  %36 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !25

37:                                               ; preds = %9, %33
  %38 = phi i32 [ %34, %33 ], [ 0, %9 ]
  %39 = tail call fastcc ptr @dev_getnode(i32 noundef %38) #6
  br label %40

40:                                               ; preds = %14, %37, %2
  %41 = phi ptr [ null, %2 ], [ %39, %37 ], [ null, %14 ]
  ret ptr %41
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @dev_readi(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #1 {
  %5 = alloca %struct.dirent, align 2
  %6 = alloca [400 x i8], align 1
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %8 = load i32, ptr %7, align 4, !tbaa !11
  switch i32 %8, label %64 [
    i32 0, label %9
    i32 3, label %49
    i32 2, label %51
  ]

9:                                                ; preds = %4
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #7
  %10 = lshr i32 %3, 6
  %11 = lshr i32 %2, 6
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 2
  br label %13

13:                                               ; preds = %40, %9
  %14 = phi i32 [ %11, %9 ], [ %22, %40 ]
  %15 = phi i32 [ 0, %9 ], [ %45, %40 ]
  %16 = icmp samesign ult i32 %14, 9
  %17 = icmp samesign ult i32 %15, %10
  %18 = select i1 %16, i1 %17, i1 false
  br i1 %18, label %21, label %19

19:                                               ; preds = %13
  %20 = shl i32 %15, 6
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #7
  br label %78

21:                                               ; preds = %13
  %22 = add nuw nsw i32 %14, 1
  %23 = trunc nuw nsw i32 %22 to i16
  store i16 %23, ptr %5, align 2, !tbaa !26
  br label %24

24:                                               ; preds = %29, %21
  %25 = phi i32 [ 0, %21 ], [ %31, %29 ]
  %26 = icmp eq i32 %25, 62
  br i1 %26, label %27, label %29

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw [9 x %struct.anon], ptr @devtab, i32 0, i32 %14
  br label %32

29:                                               ; preds = %24
  %30 = getelementptr inbounds nuw [62 x i8], ptr %12, i32 0, i32 %25
  store i8 0, ptr %30, align 1, !tbaa !19
  %31 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !28

32:                                               ; preds = %27, %46
  %33 = phi i32 [ %48, %46 ], [ 0, %27 ]
  %34 = icmp eq i32 %33, 62
  br i1 %34, label %40, label %35

35:                                               ; preds = %32
  %36 = load ptr, ptr %28, align 4, !tbaa !20
  %37 = getelementptr inbounds nuw i8, ptr %36, i32 %33
  %38 = load i8, ptr %37, align 1, !tbaa !19
  %39 = icmp eq i8 %38, 0
  br i1 %39, label %40, label %46

40:                                               ; preds = %32, %35
  %41 = shl nuw i32 %15, 6
  %42 = add i32 %41, %1
  %43 = inttoptr i32 %42 to ptr
  %44 = call ptr @memmove(ptr noundef %43, ptr noundef nonnull %5, i32 noundef 64) #8
  %45 = add nuw nsw i32 %15, 1
  br label %13, !llvm.loop !29

46:                                               ; preds = %35
  %47 = getelementptr inbounds nuw [62 x i8], ptr %12, i32 0, i32 %33
  store i8 %38, ptr %47, align 1, !tbaa !19
  %48 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !30

49:                                               ; preds = %4
  %50 = tail call i32 @fat_sd_rawread(i32 noundef %1, i32 noundef %2, i32 noundef %3) #8
  br label %78

51:                                               ; preds = %4
  %52 = tail call fastcc i32 @fat0_size() #6
  %53 = icmp ult i32 %2, %52
  br i1 %53, label %54, label %78

54:                                               ; preds = %51
  %55 = add i32 %3, %2
  %56 = icmp ugt i32 %55, %52
  %57 = sub nuw i32 %52, %2
  %58 = select i1 %56, i32 %57, i32 %3
  %59 = inttoptr i32 %1 to ptr
  %60 = load i32, ptr @fatvol, align 4, !tbaa !31
  %61 = add i32 %60, %2
  %62 = inttoptr i32 %61 to ptr
  %63 = tail call ptr @memmove(ptr noundef %59, ptr noundef %62, i32 noundef %58) #8
  br label %78

64:                                               ; preds = %4
  %65 = add nsw i32 %8, -1
  call void @llvm.lifetime.start.p0(i64 400, ptr nonnull %6) #7
  %66 = call fastcc i32 @dev_text(i32 noundef %65, ptr noundef %6) #6
  %67 = icmp ult i32 %2, %66
  br i1 %67, label %68, label %76

68:                                               ; preds = %64
  %69 = add i32 %3, %2
  %70 = icmp ugt i32 %69, %66
  %71 = sub nuw i32 %66, %2
  %72 = select i1 %70, i32 %71, i32 %3
  %73 = inttoptr i32 %1 to ptr
  %74 = getelementptr inbounds nuw i8, ptr %6, i32 %2
  %75 = call ptr @memmove(ptr noundef %73, ptr noundef nonnull %74, i32 noundef %72) #8
  br label %76

76:                                               ; preds = %64, %68
  %77 = phi i32 [ %72, %68 ], [ 0, %64 ]
  call void @llvm.lifetime.end.p0(i64 400, ptr nonnull %6) #7
  br label %78

78:                                               ; preds = %49, %76, %51, %54, %19
  %79 = phi i32 [ %20, %19 ], [ %50, %49 ], [ %77, %76 ], [ %58, %54 ], [ 0, %51 ]
  ret i32 %79
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @fat_sd_rawread(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc range(i32 0, -511) i32 @fat0_size() unnamed_addr #5 {
  %1 = load i32, ptr @fatvol, align 4, !tbaa !31
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %31, label %3

3:                                                ; preds = %0
  %4 = inttoptr i32 %1 to ptr
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 19
  %6 = load i8, ptr %5, align 1, !tbaa !19
  %7 = zext i8 %6 to i32
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 20
  %9 = load i8, ptr %8, align 1, !tbaa !19
  %10 = zext i8 %9 to i32
  %11 = shl nuw nsw i32 %10, 8
  %12 = or disjoint i32 %11, %7
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %28

14:                                               ; preds = %3
  %15 = getelementptr inbounds nuw i8, ptr %4, i32 32
  %16 = load i8, ptr %15, align 1, !tbaa !19
  %17 = zext i8 %16 to i32
  %18 = getelementptr inbounds nuw i8, ptr %4, i32 33
  %19 = load i8, ptr %18, align 1, !tbaa !19
  %20 = zext i8 %19 to i32
  %21 = shl nuw nsw i32 %20, 8
  %22 = or disjoint i32 %21, %17
  %23 = getelementptr inbounds nuw i8, ptr %4, i32 34
  %24 = load i8, ptr %23, align 1, !tbaa !19
  %25 = zext i8 %24 to i32
  %26 = shl nuw nsw i32 %25, 16
  %27 = or disjoint i32 %22, %26
  br label %28

28:                                               ; preds = %14, %3
  %29 = phi i32 [ %27, %14 ], [ %12, %3 ]
  %30 = shl i32 %29, 9
  br label %31

31:                                               ; preds = %0, %28
  %32 = phi i32 [ %30, %28 ], [ 0, %0 ]
  ret i32 %32
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -2147483647, -2147483648) i32 @dev_text(i32 noundef %0, ptr noundef nonnull writeonly captures(none) %1) unnamed_addr #1 {
  %3 = alloca [12 x i8], align 1
  %4 = alloca [3 x i32], align 4
  %5 = getelementptr inbounds [9 x %struct.anon], ptr @devtab, i32 0, i32 %0
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %7 = load i32, ptr %6, align 4, !tbaa !32
  switch i32 %7, label %178 [
    i32 7, label %8
    i32 3, label %34
    i32 4, label %61
    i32 5, label %81
  ]

8:                                                ; preds = %2, %31
  %9 = phi i32 [ %33, %31 ], [ 0, %2 ]
  %10 = phi i32 [ %32, %31 ], [ 0, %2 ]
  %11 = tail call ptr @kimg_name(i32 noundef %9) #8
  %12 = icmp eq ptr %11, null
  br i1 %12, label %178, label %13

13:                                               ; preds = %8, %24
  %14 = phi i32 [ %27, %24 ], [ 0, %8 ]
  %15 = phi i32 [ %25, %24 ], [ %10, %8 ]
  %16 = getelementptr inbounds nuw i8, ptr %11, i32 %14
  %17 = load i8, ptr %16, align 1, !tbaa !19
  %18 = icmp ne i8 %17, 0
  %19 = icmp samesign ult i32 %14, 12
  %20 = select i1 %18, i1 %19, i1 false
  %21 = icmp slt i32 %15, 400
  %22 = select i1 %20, i1 %21, i1 false
  br i1 %22, label %24, label %23

23:                                               ; preds = %13
  br i1 %21, label %28, label %31

24:                                               ; preds = %13
  %25 = add nsw i32 %15, 1
  %26 = getelementptr inbounds i8, ptr %1, i32 %15
  store i8 %17, ptr %26, align 1, !tbaa !19
  %27 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !33

28:                                               ; preds = %23
  %29 = add nsw i32 %15, 1
  %30 = getelementptr inbounds i8, ptr %1, i32 %15
  store i8 10, ptr %30, align 1, !tbaa !19
  br label %31

31:                                               ; preds = %23, %28
  %32 = phi i32 [ %15, %23 ], [ %29, %28 ]
  %33 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !34

34:                                               ; preds = %2, %41
  %35 = phi i32 [ %60, %41 ], [ 0, %2 ]
  %36 = phi i32 [ %58, %41 ], [ 0, %2 ]
  %37 = load i32, ptr @gpiopins, align 4, !tbaa !31
  %38 = icmp ult i32 %35, %37
  %39 = icmp samesign ult i32 %36, 394
  %40 = select i1 %38, i1 %39, i1 false
  br i1 %40, label %41, label %178

41:                                               ; preds = %34
  %42 = freeze i32 %35
  %43 = udiv i32 %42, 10
  %44 = trunc i32 %43 to i8
  %45 = add i8 %44, 48
  %46 = getelementptr inbounds nuw i8, ptr %1, i32 %36
  store i8 %45, ptr %46, align 1, !tbaa !19
  %47 = mul i32 %43, 10
  %48 = sub i32 %42, %47
  %49 = trunc nuw nsw i32 %48 to i8
  %50 = or disjoint i8 %49, 48
  %51 = getelementptr i8, ptr %46, i32 1
  store i8 %50, ptr %51, align 1, !tbaa !19
  %52 = getelementptr i8, ptr %46, i32 2
  store i8 61, ptr %52, align 1, !tbaa !19
  %53 = tail call i32 @kgpio_peek(i32 noundef %35) #8
  %54 = trunc i32 %53 to i8
  %55 = and i8 %54, 1
  %56 = or disjoint i8 %55, 48
  %57 = getelementptr i8, ptr %46, i32 3
  store i8 %56, ptr %57, align 1, !tbaa !19
  %58 = add nuw nsw i32 %36, 5
  %59 = getelementptr inbounds nuw i8, ptr %46, i32 4
  store i8 10, ptr %59, align 1, !tbaa !19
  %60 = add nuw nsw i32 %35, 1
  br label %34, !llvm.loop !35

61:                                               ; preds = %2, %65
  %62 = phi ptr [ %67, %65 ], [ @.str.9, %2 ]
  %63 = phi i32 [ %68, %65 ], [ 0, %2 ]
  %64 = icmp eq i32 %63, 12
  br i1 %64, label %70, label %65

65:                                               ; preds = %61
  %66 = load i8, ptr %62, align 1, !tbaa !19
  %67 = getelementptr inbounds nuw i8, ptr %62, i32 1
  %68 = add nuw nsw i32 %63, 1
  %69 = getelementptr inbounds nuw i8, ptr %1, i32 %63
  store i8 %66, ptr %69, align 1, !tbaa !19
  br label %61, !llvm.loop !36

70:                                               ; preds = %61
  %71 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %72 = load i32, ptr %71, align 4, !tbaa !37
  %73 = tail call i32 @kpio_ctrl(i32 noundef %72) #8
  %74 = icmp ult i32 %73, 10
  %75 = or disjoint i32 %73, 48
  %76 = add i32 %73, 87
  %77 = select i1 %74, i32 %75, i32 %76
  %78 = trunc i32 %77 to i8
  %79 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i8 %78, ptr %79, align 1, !tbaa !19
  %80 = getelementptr inbounds nuw i8, ptr %1, i32 13
  store i8 10, ptr %80, align 1, !tbaa !19
  br label %178

81:                                               ; preds = %2
  %82 = tail call i32 @kfb_active() #8
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %84, label %93

84:                                               ; preds = %81, %88
  %85 = phi ptr [ %90, %88 ], [ @.str.10, %81 ]
  %86 = phi i32 [ %91, %88 ], [ 0, %81 ]
  %87 = icmp eq i32 %86, 4
  br i1 %87, label %178, label %88

88:                                               ; preds = %84
  %89 = load i8, ptr %85, align 1, !tbaa !19
  %90 = getelementptr inbounds nuw i8, ptr %85, i32 1
  %91 = add nuw nsw i32 %86, 1
  %92 = getelementptr inbounds nuw i8, ptr %1, i32 %86
  store i8 %89, ptr %92, align 1, !tbaa !19
  br label %84, !llvm.loop !38

93:                                               ; preds = %81
  %94 = tail call i32 @kfb_w() #8
  %95 = tail call i32 @kfb_h() #8
  %96 = tail call i32 @kfb_owner() #8
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %3) #7
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %4) #7
  store i32 %94, ptr %4, align 4, !tbaa !31
  %97 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store i32 %95, ptr %97, align 4, !tbaa !31
  %98 = getelementptr inbounds nuw i8, ptr %4, i32 8
  store i32 8, ptr %98, align 4, !tbaa !31
  br label %99

99:                                               ; preds = %137, %93
  %100 = phi i32 [ 0, %93 ], [ %138, %137 ]
  %101 = phi i32 [ 0, %93 ], [ %139, %137 ]
  %102 = icmp eq i32 %101, 3
  br i1 %102, label %140, label %103

103:                                              ; preds = %99
  %104 = getelementptr inbounds nuw [3 x i32], ptr %4, i32 0, i32 %101
  %105 = load i32, ptr %104, align 4, !tbaa !31
  br label %106

106:                                              ; preds = %106, %103
  %107 = phi i32 [ 0, %103 ], [ %115, %106 ]
  %108 = phi i32 [ %105, %103 ], [ %110, %106 ]
  %109 = freeze i32 %108
  %110 = sdiv i32 %109, 10
  %111 = mul i32 %110, 10
  %112 = sub i32 %109, %111
  %113 = trunc nsw i32 %112 to i8
  %114 = add nsw i8 %113, 48
  %115 = add nuw nsw i32 %107, 1
  %116 = getelementptr inbounds nuw [12 x i8], ptr %3, i32 0, i32 %107
  store i8 %114, ptr %116, align 1, !tbaa !19
  %117 = add i32 %108, 9
  %118 = icmp ult i32 %117, 19
  br i1 %118, label %119, label %106, !llvm.loop !39

119:                                              ; preds = %106, %125
  %120 = phi i32 [ %129, %125 ], [ %100, %106 ]
  %121 = phi i32 [ %126, %125 ], [ %115, %106 ]
  %122 = icmp sgt i32 %121, 0
  %123 = icmp slt i32 %120, 400
  %124 = select i1 %122, i1 %123, i1 false
  br i1 %124, label %125, label %131

125:                                              ; preds = %119
  %126 = add nsw i32 %121, -1
  %127 = getelementptr inbounds nuw [12 x i8], ptr %3, i32 0, i32 %126
  %128 = load i8, ptr %127, align 1, !tbaa !19
  %129 = add nsw i32 %120, 1
  %130 = getelementptr inbounds i8, ptr %1, i32 %120
  store i8 %128, ptr %130, align 1, !tbaa !19
  br label %119, !llvm.loop !40

131:                                              ; preds = %119
  %132 = icmp ne i32 %101, 2
  %133 = select i1 %132, i1 %123, i1 false
  br i1 %133, label %134, label %137

134:                                              ; preds = %131
  %135 = add nsw i32 %120, 1
  %136 = getelementptr inbounds i8, ptr %1, i32 %120
  store i8 120, ptr %136, align 1, !tbaa !19
  br label %137

137:                                              ; preds = %131, %134
  %138 = phi i32 [ %135, %134 ], [ %120, %131 ]
  %139 = add nuw nsw i32 %101, 1
  br label %99, !llvm.loop !41

140:                                              ; preds = %99, %147
  %141 = phi i32 [ %149, %147 ], [ %100, %99 ]
  %142 = phi ptr [ %148, %147 ], [ @.str.11, %99 ]
  %143 = load i8, ptr %142, align 1, !tbaa !19
  %144 = icmp ne i8 %143, 0
  %145 = icmp slt i32 %141, 400
  %146 = select i1 %144, i1 %145, i1 false
  br i1 %146, label %147, label %151

147:                                              ; preds = %140
  %148 = getelementptr inbounds nuw i8, ptr %142, i32 1
  %149 = add nsw i32 %141, 1
  %150 = getelementptr inbounds i8, ptr %1, i32 %141
  store i8 %143, ptr %150, align 1, !tbaa !19
  br label %140, !llvm.loop !42

151:                                              ; preds = %140, %151
  %152 = phi i32 [ %155, %151 ], [ %96, %140 ]
  %153 = phi i32 [ %160, %151 ], [ 0, %140 ]
  %154 = freeze i32 %152
  %155 = udiv i32 %154, 10
  %156 = mul i32 %155, 10
  %157 = sub i32 %154, %156
  %158 = trunc nuw nsw i32 %157 to i8
  %159 = or disjoint i8 %158, 48
  %160 = add nuw nsw i32 %153, 1
  %161 = getelementptr inbounds nuw [12 x i8], ptr %3, i32 0, i32 %153
  store i8 %159, ptr %161, align 1, !tbaa !19
  %162 = icmp ult i32 %152, 10
  br i1 %162, label %163, label %151, !llvm.loop !43

163:                                              ; preds = %151, %169
  %164 = phi i32 [ %173, %169 ], [ %141, %151 ]
  %165 = phi i32 [ %170, %169 ], [ %160, %151 ]
  %166 = icmp sgt i32 %165, 0
  %167 = icmp slt i32 %164, 400
  %168 = select i1 %166, i1 %167, i1 false
  br i1 %168, label %169, label %175

169:                                              ; preds = %163
  %170 = add nsw i32 %165, -1
  %171 = getelementptr inbounds nuw [12 x i8], ptr %3, i32 0, i32 %170
  %172 = load i8, ptr %171, align 1, !tbaa !19
  %173 = add nsw i32 %164, 1
  %174 = getelementptr inbounds i8, ptr %1, i32 %164
  store i8 %172, ptr %174, align 1, !tbaa !19
  br label %163, !llvm.loop !44

175:                                              ; preds = %163
  %176 = add nsw i32 %164, 1
  %177 = getelementptr inbounds i8, ptr %1, i32 %164
  store i8 10, ptr %177, align 1, !tbaa !19
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %4) #7
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %3) #7
  br label %178

178:                                              ; preds = %84, %34, %8, %2, %175, %70
  %179 = phi i32 [ 14, %70 ], [ %176, %175 ], [ 0, %2 ], [ %10, %8 ], [ %36, %34 ], [ 4, %84 ]
  ret i32 %179
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dev_stati(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) initializes((0, 16)) %1) local_unnamed_addr #1 {
  store i32 3559, ptr %1, align 4, !tbaa !45
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !11
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %4, ptr %5, align 4, !tbaa !48
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %7 = load i16, ptr %6, align 4, !tbaa !17
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i16 %7, ptr %8, align 4, !tbaa !49
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 10
  store i16 1, ptr %9, align 2, !tbaa !50
  %10 = icmp eq i32 %4, 0
  br i1 %10, label %11, label %14

11:                                               ; preds = %2
  %12 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %13 = load i32, ptr %12, align 4, !tbaa !18
  br label %17

14:                                               ; preds = %2
  %15 = add nsw i32 %4, -1
  %16 = tail call fastcc i32 @dev_size(i32 noundef %15) #6
  br label %17

17:                                               ; preds = %14, %11
  %18 = phi i32 [ %13, %11 ], [ %16, %14 ]
  %19 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %18, ptr %19, align 4, !tbaa !51
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @dev_size(i32 noundef %0) unnamed_addr #1 {
  %2 = alloca [400 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 400, ptr nonnull %2) #7
  %3 = getelementptr inbounds [9 x %struct.anon], ptr @devtab, i32 0, i32 %0, i32 1
  %4 = load i32, ptr %3, align 4, !tbaa !32
  switch i32 %4, label %11 [
    i32 2, label %5
    i32 6, label %7
    i32 3, label %9
    i32 4, label %9
    i32 5, label %9
    i32 7, label %9
  ]

5:                                                ; preds = %1
  %6 = tail call fastcc i32 @fat0_size() #6
  br label %11

7:                                                ; preds = %1
  %8 = tail call i32 @fat_sd_bytes() #8
  br label %11

9:                                                ; preds = %1, %1, %1, %1
  %10 = call fastcc i32 @dev_text(i32 noundef %0, ptr noundef %2) #6
  br label %11

11:                                               ; preds = %1, %9, %7, %5
  %12 = phi i32 [ %6, %5 ], [ %8, %7 ], [ %10, %9 ], [ 0, %1 ]
  call void @llvm.lifetime.end.p0(i64 400, ptr nonnull %2) #7
  ret i32 %12
}

; Function Attrs: minsize optsize
declare dso_local ptr @kimg_name(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kgpio_peek(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kpio_ctrl(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_active() local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_w() local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_h() local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_owner() local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @fat_sd_bytes() local_unnamed_addr #4

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }
attributes #7 = { nounwind }
attributes #8 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"inode", !5, i64 0, !5, i64 4, !5, i64 8, !8, i64 12, !5, i64 16, !9, i64 20, !9, i64 22, !9, i64 24, !9, i64 26, !5, i64 28, !6, i64 32}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"sleeplock", !6, i64 0}
!9 = !{!"short", !6, i64 0}
!10 = !{!4, !5, i64 8}
!11 = !{!4, !5, i64 4}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
!15 = !{!4, !9, i64 26}
!16 = !{!4, !9, i64 22}
!17 = !{!4, !9, i64 20}
!18 = !{!4, !5, i64 28}
!19 = !{!6, !6, i64 0}
!20 = !{!21, !22, i64 0}
!21 = !{!"", !22, i64 0, !5, i64 4, !5, i64 8}
!22 = !{!"p1 omnipotent char", !23, i64 0}
!23 = !{!"any pointer", !6, i64 0}
!24 = distinct !{!24, !13, !14}
!25 = distinct !{!25, !13, !14}
!26 = !{!27, !9, i64 0}
!27 = !{!"dirent", !9, i64 0, !6, i64 2}
!28 = distinct !{!28, !13, !14}
!29 = distinct !{!29, !13, !14}
!30 = distinct !{!30, !13, !14}
!31 = !{!5, !5, i64 0}
!32 = !{!21, !5, i64 4}
!33 = distinct !{!33, !13, !14}
!34 = distinct !{!34, !14}
!35 = distinct !{!35, !13, !14}
!36 = distinct !{!36, !13, !14}
!37 = !{!21, !5, i64 8}
!38 = distinct !{!38, !13, !14}
!39 = distinct !{!39, !13, !14}
!40 = distinct !{!40, !13, !14}
!41 = distinct !{!41, !13, !14}
!42 = distinct !{!42, !13, !14}
!43 = distinct !{!43, !13, !14}
!44 = distinct !{!44, !13, !14}
!45 = !{!46, !5, i64 0}
!46 = !{!"stat", !5, i64 0, !5, i64 4, !9, i64 8, !9, i64 10, !47, i64 12}
!47 = !{!"long", !6, i64 0}
!48 = !{!46, !5, i64 4}
!49 = !{!46, !9, i64 8}
!50 = !{!46, !9, i64 10}
!51 = !{!46, !47, i64 12}
