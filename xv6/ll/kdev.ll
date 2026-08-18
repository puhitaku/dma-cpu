; ModuleID = 'kdev.c'
source_filename = "kdev.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.anon = type { ptr, i32, i32 }
%struct.inode = type { i32, i32, i32, %struct.sleeplock, i32, i16, i16, i16, i16, i32, [13 x i32] }
%struct.sleeplock = type { i8 }
%struct.dirent = type { i16, [62 x i8] }

@devtab = internal unnamed_addr constant [6 x %struct.anon] [%struct.anon { ptr @.str, i32 1, i32 0 }, %struct.anon { ptr @.str.1, i32 2, i32 0 }, %struct.anon { ptr @.str.2, i32 3, i32 0 }, %struct.anon { ptr @.str.3, i32 4, i32 0 }, %struct.anon { ptr @.str.4, i32 4, i32 1 }, %struct.anon { ptr @.str.5, i32 4, i32 2 }], align 4
@fatvol = external dso_local local_unnamed_addr global i32, align 4
@devnodes = internal global [8 x %struct.inode] zeroinitializer, align 4
@.str = private unnamed_addr constant [8 x i8] c"console\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"fat0\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"gpio\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"pio0\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"pio1\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"pio2\00", align 1
@gpiopins = external dso_local local_unnamed_addr global i32, align 4
@.str.6 = private unnamed_addr constant [13 x i8] c"sm_enable=0x\00", align 1

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
define internal fastcc ptr @dev_getnode(i32 noundef range(i32 -2147483647, 7) %0) unnamed_addr #1 {
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
  store i32 512, ptr %34, align 4, !tbaa !18
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
  %16 = icmp eq i32 %15, 6
  br i1 %16, label %40, label %17

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw [6 x %struct.anon], ptr @devtab, i32 0, i32 %15
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
  %6 = alloca [300 x i8], align 1
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %8 = load i32, ptr %7, align 4, !tbaa !11
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %50

10:                                               ; preds = %4
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #7
  %11 = lshr i32 %3, 6
  %12 = lshr i32 %2, 6
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 2
  br label %14

14:                                               ; preds = %41, %10
  %15 = phi i32 [ %12, %10 ], [ %23, %41 ]
  %16 = phi i32 [ 0, %10 ], [ %46, %41 ]
  %17 = icmp samesign ult i32 %15, 6
  %18 = icmp samesign ult i32 %16, %11
  %19 = select i1 %17, i1 %18, i1 false
  br i1 %19, label %22, label %20

20:                                               ; preds = %14
  %21 = shl i32 %16, 6
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #7
  br label %79

22:                                               ; preds = %14
  %23 = add nuw nsw i32 %15, 1
  %24 = trunc nuw nsw i32 %23 to i16
  store i16 %24, ptr %5, align 2, !tbaa !26
  br label %25

25:                                               ; preds = %30, %22
  %26 = phi i32 [ 0, %22 ], [ %32, %30 ]
  %27 = icmp eq i32 %26, 62
  br i1 %27, label %28, label %30

28:                                               ; preds = %25
  %29 = getelementptr inbounds nuw [6 x %struct.anon], ptr @devtab, i32 0, i32 %15
  br label %33

30:                                               ; preds = %25
  %31 = getelementptr inbounds nuw [62 x i8], ptr %13, i32 0, i32 %26
  store i8 0, ptr %31, align 1, !tbaa !19
  %32 = add nuw nsw i32 %26, 1
  br label %25, !llvm.loop !28

33:                                               ; preds = %28, %47
  %34 = phi i32 [ %49, %47 ], [ 0, %28 ]
  %35 = icmp eq i32 %34, 62
  br i1 %35, label %41, label %36

36:                                               ; preds = %33
  %37 = load ptr, ptr %29, align 4, !tbaa !20
  %38 = getelementptr inbounds nuw i8, ptr %37, i32 %34
  %39 = load i8, ptr %38, align 1, !tbaa !19
  %40 = icmp eq i8 %39, 0
  br i1 %40, label %41, label %47

41:                                               ; preds = %33, %36
  %42 = shl nuw i32 %16, 6
  %43 = add i32 %42, %1
  %44 = inttoptr i32 %43 to ptr
  %45 = call ptr @memmove(ptr noundef %44, ptr noundef nonnull %5, i32 noundef 64) #8
  %46 = add nuw nsw i32 %16, 1
  br label %14, !llvm.loop !29

47:                                               ; preds = %36
  %48 = getelementptr inbounds nuw [62 x i8], ptr %13, i32 0, i32 %34
  store i8 %39, ptr %48, align 1, !tbaa !19
  %49 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !30

50:                                               ; preds = %4
  %51 = add nsw i32 %8, -1
  %52 = icmp eq i32 %51, 1
  br i1 %52, label %53, label %66

53:                                               ; preds = %50
  %54 = tail call fastcc i32 @fat0_size() #6
  %55 = icmp ult i32 %2, %54
  br i1 %55, label %56, label %79

56:                                               ; preds = %53
  %57 = add i32 %3, %2
  %58 = icmp ugt i32 %57, %54
  %59 = sub nuw i32 %54, %2
  %60 = select i1 %58, i32 %59, i32 %3
  %61 = inttoptr i32 %1 to ptr
  %62 = load i32, ptr @fatvol, align 4, !tbaa !31
  %63 = add i32 %62, %2
  %64 = inttoptr i32 %63 to ptr
  %65 = tail call ptr @memmove(ptr noundef %61, ptr noundef %64, i32 noundef %60) #8
  br label %79

66:                                               ; preds = %50
  call void @llvm.lifetime.start.p0(i64 300, ptr nonnull %6) #7
  %67 = call fastcc i32 @dev_text(i32 noundef %51, ptr noundef %6) #6
  %68 = icmp ult i32 %2, %67
  br i1 %68, label %69, label %77

69:                                               ; preds = %66
  %70 = add i32 %3, %2
  %71 = icmp ugt i32 %70, %67
  %72 = sub nuw nsw i32 %67, %2
  %73 = select i1 %71, i32 %72, i32 %3
  %74 = inttoptr i32 %1 to ptr
  %75 = getelementptr inbounds nuw i8, ptr %6, i32 %2
  %76 = call ptr @memmove(ptr noundef %74, ptr noundef nonnull %75, i32 noundef %73) #8
  br label %77

77:                                               ; preds = %66, %69
  %78 = phi i32 [ %73, %69 ], [ 0, %66 ]
  call void @llvm.lifetime.end.p0(i64 300, ptr nonnull %6) #7
  br label %79

79:                                               ; preds = %77, %53, %56, %20
  %80 = phi i32 [ %21, %20 ], [ %78, %77 ], [ %60, %56 ], [ 0, %53 ]
  ret i32 %80
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

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
define internal fastcc range(i32 0, 299) i32 @dev_text(i32 noundef %0, ptr noundef nonnull writeonly captures(none) %1) unnamed_addr #1 {
  %3 = getelementptr inbounds [6 x %struct.anon], ptr @devtab, i32 0, i32 %0
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %5 = load i32, ptr %4, align 4, !tbaa !32
  switch i32 %5, label %53 [
    i32 3, label %6
    i32 4, label %33
  ]

6:                                                ; preds = %2, %13
  %7 = phi i32 [ %32, %13 ], [ 0, %2 ]
  %8 = phi i32 [ %30, %13 ], [ 0, %2 ]
  %9 = load i32, ptr @gpiopins, align 4, !tbaa !31
  %10 = icmp ult i32 %7, %9
  %11 = icmp samesign ult i32 %8, 294
  %12 = select i1 %10, i1 %11, i1 false
  br i1 %12, label %13, label %53

13:                                               ; preds = %6
  %14 = freeze i32 %7
  %15 = udiv i32 %14, 10
  %16 = trunc i32 %15 to i8
  %17 = add i8 %16, 48
  %18 = getelementptr inbounds nuw i8, ptr %1, i32 %8
  store i8 %17, ptr %18, align 1, !tbaa !19
  %19 = mul i32 %15, 10
  %20 = sub i32 %14, %19
  %21 = trunc nuw nsw i32 %20 to i8
  %22 = or disjoint i8 %21, 48
  %23 = getelementptr i8, ptr %18, i32 1
  store i8 %22, ptr %23, align 1, !tbaa !19
  %24 = getelementptr i8, ptr %18, i32 2
  store i8 61, ptr %24, align 1, !tbaa !19
  %25 = tail call i32 @kgpio_peek(i32 noundef %7) #8
  %26 = trunc i32 %25 to i8
  %27 = and i8 %26, 1
  %28 = or disjoint i8 %27, 48
  %29 = getelementptr i8, ptr %18, i32 3
  store i8 %28, ptr %29, align 1, !tbaa !19
  %30 = add nuw nsw i32 %8, 5
  %31 = getelementptr inbounds nuw i8, ptr %18, i32 4
  store i8 10, ptr %31, align 1, !tbaa !19
  %32 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !33

33:                                               ; preds = %2, %37
  %34 = phi ptr [ %39, %37 ], [ @.str.6, %2 ]
  %35 = phi i32 [ %40, %37 ], [ 0, %2 ]
  %36 = icmp eq i32 %35, 12
  br i1 %36, label %42, label %37

37:                                               ; preds = %33
  %38 = load i8, ptr %34, align 1, !tbaa !19
  %39 = getelementptr inbounds nuw i8, ptr %34, i32 1
  %40 = add nuw nsw i32 %35, 1
  %41 = getelementptr inbounds nuw i8, ptr %1, i32 %35
  store i8 %38, ptr %41, align 1, !tbaa !19
  br label %33, !llvm.loop !34

42:                                               ; preds = %33
  %43 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %44 = load i32, ptr %43, align 4, !tbaa !35
  %45 = tail call i32 @kpio_ctrl(i32 noundef %44) #8
  %46 = icmp ult i32 %45, 10
  %47 = or disjoint i32 %45, 48
  %48 = add i32 %45, 87
  %49 = select i1 %46, i32 %47, i32 %48
  %50 = trunc i32 %49 to i8
  %51 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i8 %50, ptr %51, align 1, !tbaa !19
  %52 = getelementptr inbounds nuw i8, ptr %1, i32 13
  store i8 10, ptr %52, align 1, !tbaa !19
  br label %53

53:                                               ; preds = %6, %2, %42
  %54 = phi i32 [ 14, %42 ], [ 0, %2 ], [ %8, %6 ]
  ret i32 %54
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dev_stati(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) initializes((0, 16)) %1) local_unnamed_addr #1 {
  store i32 3559, ptr %1, align 4, !tbaa !36
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !11
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %4, ptr %5, align 4, !tbaa !39
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %7 = load i16, ptr %6, align 4, !tbaa !17
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i16 %7, ptr %8, align 4, !tbaa !40
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 10
  store i16 1, ptr %9, align 2, !tbaa !41
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
  store i32 %18, ptr %19, align 4, !tbaa !42
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, -511) i32 @dev_size(i32 noundef %0) unnamed_addr #1 {
  %2 = alloca [300 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 300, ptr nonnull %2) #7
  %3 = getelementptr inbounds [6 x %struct.anon], ptr @devtab, i32 0, i32 %0, i32 1
  %4 = load i32, ptr %3, align 4, !tbaa !32
  switch i32 %4, label %9 [
    i32 2, label %5
    i32 3, label %7
    i32 4, label %7
  ]

5:                                                ; preds = %1
  %6 = tail call fastcc i32 @fat0_size() #6
  br label %9

7:                                                ; preds = %1, %1
  %8 = call fastcc i32 @dev_text(i32 noundef %0, ptr noundef %2) #6
  br label %9

9:                                                ; preds = %1, %7, %5
  %10 = phi i32 [ %6, %5 ], [ %8, %7 ], [ 0, %1 ]
  call void @llvm.lifetime.end.p0(i64 300, ptr nonnull %2) #7
  ret i32 %10
}

; Function Attrs: minsize optsize
declare dso_local i32 @kgpio_peek(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @kpio_ctrl(i32 noundef) local_unnamed_addr #4

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
!34 = distinct !{!34, !13, !14}
!35 = !{!21, !5, i64 8}
!36 = !{!37, !5, i64 0}
!37 = !{!"stat", !5, i64 0, !5, i64 4, !9, i64 8, !9, i64 10, !38, i64 12}
!38 = !{!"long", !6, i64 0}
!39 = !{!37, !5, i64 4}
!40 = !{!37, !9, i64 8}
!41 = !{!37, !9, i64 10}
!42 = !{!37, !38, i64 12}
