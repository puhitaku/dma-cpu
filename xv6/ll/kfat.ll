; ModuleID = 'kfat.c'
source_filename = "kfat.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.inode = type { i32, i32, i32, %struct.sleeplock, i32, i16, i16, i16, i16, i32, [13 x i32] }
%struct.sleeplock = type { i8 }
%struct.fatmeta = type { i32, i32 }
%struct.dirent = type { i16, [62 x i8] }

@fbase = internal unnamed_addr global i32 0, align 4
@rootclus = internal unnamed_addr global i32 0, align 4
@clussz = internal unnamed_addr global i32 0, align 4
@fatoff = internal unnamed_addr global i32 0, align 4
@dataoff = internal unnamed_addr global i32 0, align 4
@fatnodes = internal global [16 x %struct.inode] zeroinitializer, align 4
@fatmeta = internal unnamed_addr global [16 x %struct.fatmeta] zeroinitializer, align 4
@.str = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"..\00", align 1
@fat_iter.slots = internal unnamed_addr constant [13 x i32] [i32 1, i32 3, i32 5, i32 7, i32 9, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 28, i32 30], align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define dso_local range(i32 0, 2) i32 @fat_is(ptr noundef readonly captures(address_is_null) %0) local_unnamed_addr #0 {
  %2 = icmp eq ptr %0, null
  br i1 %2, label %7, label %3

3:                                                ; preds = %1
  %4 = load i32, ptr %0, align 4, !tbaa !3
  %5 = icmp eq i32 %4, 4007
  %6 = zext i1 %5 to i32
  br label %7

7:                                                ; preds = %3, %1
  %8 = phi i32 [ 0, %1 ], [ %6, %3 ]
  ret i32 %8
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @fat_active() local_unnamed_addr #1 {
  %1 = load i32, ptr @fbase, align 4, !tbaa !10
  %2 = icmp ne i32 %1, 0
  %3 = zext i1 %2 to i32
  ret i32 %3
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 1) i32 @fat_mount(i32 noundef %0) local_unnamed_addr #2 {
  %2 = add i32 %0, 510
  %3 = inttoptr i32 %2 to ptr
  %4 = load volatile i8, ptr %3, align 1, !tbaa !11
  %5 = zext i8 %4 to i32
  %6 = add i32 %0, 511
  %7 = inttoptr i32 %6 to ptr
  %8 = load volatile i8, ptr %7, align 1, !tbaa !11
  %9 = zext i8 %8 to i32
  %10 = shl nuw nsw i32 %9, 8
  %11 = or disjoint i32 %10, %5
  %12 = icmp eq i32 %11, 43605
  br i1 %12, label %13, label %67

13:                                               ; preds = %1
  %14 = add i32 %0, 11
  %15 = inttoptr i32 %14 to ptr
  %16 = load volatile i8, ptr %15, align 1, !tbaa !11
  %17 = zext i8 %16 to i32
  %18 = add i32 %0, 12
  %19 = inttoptr i32 %18 to ptr
  %20 = load volatile i8, ptr %19, align 1, !tbaa !11
  %21 = zext i8 %20 to i32
  %22 = shl nuw nsw i32 %21, 8
  %23 = or disjoint i32 %22, %17
  %24 = add i32 %0, 13
  %25 = inttoptr i32 %24 to ptr
  %26 = load volatile i8, ptr %25, align 1, !tbaa !11
  %27 = zext i8 %26 to i32
  %28 = add i32 %0, 14
  %29 = inttoptr i32 %28 to ptr
  %30 = load volatile i8, ptr %29, align 1, !tbaa !11
  %31 = zext i8 %30 to i32
  %32 = add i32 %0, 15
  %33 = inttoptr i32 %32 to ptr
  %34 = load volatile i8, ptr %33, align 1, !tbaa !11
  %35 = zext i8 %34 to i32
  %36 = shl nuw nsw i32 %35, 8
  %37 = or disjoint i32 %36, %31
  %38 = add i32 %0, 16
  %39 = inttoptr i32 %38 to ptr
  %40 = load volatile i8, ptr %39, align 1, !tbaa !11
  %41 = zext i8 %40 to i32
  %42 = add i32 %0, 36
  %43 = tail call fastcc i32 @rd32(i32 noundef %42) #12
  %44 = add i32 %0, 44
  %45 = tail call fastcc i32 @rd32(i32 noundef %44) #12
  store i32 %45, ptr @rootclus, align 4, !tbaa !10
  %46 = icmp eq i32 %23, 512
  br i1 %46, label %47, label %67

47:                                               ; preds = %13
  %48 = icmp eq i8 %26, 0
  br i1 %48, label %67, label %49

49:                                               ; preds = %47
  %50 = icmp eq i8 %40, 0
  br i1 %50, label %67, label %51

51:                                               ; preds = %49
  %52 = icmp eq i32 %43, 0
  br i1 %52, label %67, label %53

53:                                               ; preds = %51
  %54 = icmp ult i32 %45, 2
  br i1 %54, label %67, label %55

55:                                               ; preds = %53
  %56 = shl nuw nsw i32 %27, 9
  store i32 %56, ptr @clussz, align 4, !tbaa !10
  %57 = shl nuw nsw i32 %37, 9
  store i32 %57, ptr @fatoff, align 4, !tbaa !10
  %58 = mul i32 %43, %41
  %59 = add i32 %37, %58
  %60 = shl i32 %59, 9
  store i32 %60, ptr @dataoff, align 4, !tbaa !10
  store i32 %0, ptr @fbase, align 4, !tbaa !10
  br label %61

61:                                               ; preds = %64, %55
  %62 = phi i32 [ 0, %55 ], [ %66, %64 ]
  %63 = icmp eq i32 %62, 16
  br i1 %63, label %67, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw [16 x %struct.inode], ptr @fatnodes, i32 0, i32 %62, i32 2
  store i32 0, ptr %65, align 4, !tbaa !12
  %66 = add nuw nsw i32 %62, 1
  br label %61, !llvm.loop !13

67:                                               ; preds = %61, %53, %51, %49, %47, %13, %1
  %68 = phi i32 [ -1, %1 ], [ -1, %53 ], [ -1, %51 ], [ -1, %49 ], [ -1, %47 ], [ -1, %13 ], [ 0, %61 ]
  ret i32 %68
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define internal fastcc i32 @rd32(i32 noundef %0) unnamed_addr #4 {
  %2 = inttoptr i32 %0 to ptr
  %3 = load volatile i8, ptr %2, align 1, !tbaa !11
  %4 = zext i8 %3 to i32
  %5 = add i32 %0, 1
  %6 = inttoptr i32 %5 to ptr
  %7 = load volatile i8, ptr %6, align 1, !tbaa !11
  %8 = zext i8 %7 to i32
  %9 = shl nuw nsw i32 %8, 8
  %10 = add i32 %0, 2
  %11 = inttoptr i32 %10 to ptr
  %12 = load volatile i8, ptr %11, align 1, !tbaa !11
  %13 = zext i8 %12 to i32
  %14 = add i32 %0, 3
  %15 = inttoptr i32 %14 to ptr
  %16 = load volatile i8, ptr %15, align 1, !tbaa !11
  %17 = zext i8 %16 to i32
  %18 = shl nuw i32 %17, 24
  %19 = shl nuw nsw i32 %13, 16
  %20 = or disjoint i32 %9, %4
  %21 = or disjoint i32 %20, %19
  %22 = or disjoint i32 %21, %18
  ret i32 %22
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @fat_busy() local_unnamed_addr #5 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %8, %4 ]
  %3 = icmp eq i32 %2, 16
  br i1 %3, label %9, label %4

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw [16 x %struct.inode], ptr @fatnodes, i32 0, i32 %2, i32 2
  %6 = load i32, ptr %5, align 4, !tbaa !12
  %7 = icmp sgt i32 %6, 0
  %8 = add nuw nsw i32 %2, 1
  br i1 %7, label %9, label %1, !llvm.loop !16

9:                                                ; preds = %4, %1
  %10 = icmp samesign ult i32 %2, 16
  %11 = zext i1 %10 to i32
  ret i32 %11
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
define dso_local void @fat_unmount() local_unnamed_addr #6 {
  store i32 0, ptr @fbase, align 4, !tbaa !10
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local ptr @fat_root() local_unnamed_addr #2 {
  %1 = load i32, ptr @rootclus, align 4, !tbaa !10
  %2 = tail call fastcc ptr @fat_getnode(i32 noundef %1, i32 noundef 0, i32 noundef 1, i32 noundef %1) #12
  ret ptr %2
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc ptr @fat_getnode(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) unnamed_addr #2 {
  br label %5

5:                                                ; preds = %18, %4
  %6 = phi ptr [ null, %4 ], [ %22, %18 ]
  %7 = phi i32 [ 0, %4 ], [ %23, %18 ]
  %8 = icmp eq i32 %7, 16
  br i1 %8, label %27, label %9

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw [16 x %struct.inode], ptr @fatnodes, i32 0, i32 %7
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 8
  %12 = load i32, ptr %11, align 4, !tbaa !12
  %13 = icmp sgt i32 %12, 0
  br i1 %13, label %14, label %18

14:                                               ; preds = %9
  %15 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !17
  %17 = icmp eq i32 %16, %3
  br i1 %17, label %24, label %18

18:                                               ; preds = %14, %9
  %19 = icmp eq i32 %12, 0
  %20 = icmp eq ptr %6, null
  %21 = select i1 %19, i1 %20, i1 false
  %22 = select i1 %21, ptr %10, ptr %6
  %23 = add nuw nsw i32 %7, 1
  br label %5, !llvm.loop !18

24:                                               ; preds = %14
  %25 = getelementptr inbounds nuw i8, ptr %10, i32 8
  %26 = add nuw nsw i32 %12, 1
  store i32 %26, ptr %25, align 4, !tbaa !12
  br label %54

27:                                               ; preds = %5
  %28 = icmp eq ptr %6, null
  br i1 %28, label %54, label %29

29:                                               ; preds = %27
  %30 = ptrtoint ptr %6 to i32
  %31 = sub i32 %30, ptrtoint (ptr @fatnodes to i32)
  %32 = sdiv exact i32 %31, 84
  store i32 4007, ptr %6, align 4, !tbaa !3
  %33 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store i32 %3, ptr %33, align 4, !tbaa !17
  %34 = getelementptr inbounds nuw i8, ptr %6, i32 8
  store i32 1, ptr %34, align 4, !tbaa !12
  %35 = icmp eq i32 %2, 0
  %36 = select i1 %35, i16 2, i16 1
  %37 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store i16 %36, ptr %37, align 4, !tbaa !19
  %38 = getelementptr inbounds nuw i8, ptr %6, i32 26
  store i16 1, ptr %38, align 2, !tbaa !20
  br i1 %35, label %49, label %39

39:                                               ; preds = %29
  %40 = load i32, ptr @clussz, align 4
  br label %41

41:                                               ; preds = %46, %39
  %42 = phi i32 [ %0, %39 ], [ %48, %46 ]
  %43 = phi i32 [ 0, %39 ], [ %47, %46 ]
  %44 = add i32 %42, -2
  %45 = icmp ult i32 %44, 268435446
  br i1 %45, label %46, label %49

46:                                               ; preds = %41
  %47 = add i32 %43, %40
  %48 = tail call fastcc i32 @fat_next(i32 noundef %42) #12
  br label %41, !llvm.loop !21

49:                                               ; preds = %41, %29
  %50 = phi i32 [ %1, %29 ], [ %43, %41 ]
  %51 = getelementptr inbounds nuw i8, ptr %6, i32 28
  store i32 %50, ptr %51, align 4, !tbaa !22
  %52 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %32
  store i32 %0, ptr %52, align 4, !tbaa !23
  %53 = getelementptr inbounds nuw i8, ptr %52, i32 4
  store i32 %50, ptr %53, align 4, !tbaa !25
  br label %54

54:                                               ; preds = %24, %27, %49
  %55 = phi ptr [ %6, %49 ], [ %10, %24 ], [ null, %27 ]
  ret ptr %55
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @fat_put(ptr noundef captures(none) %0) local_unnamed_addr #7 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !12
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  %6 = add nsw i32 %3, -1
  store i32 %6, ptr %2, align 4, !tbaa !12
  br label %7

7:                                                ; preds = %5, %1
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @fat_dup(ptr noundef captures(none) %0) local_unnamed_addr #7 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !12
  %4 = add nsw i32 %3, 1
  store i32 %4, ptr %2, align 4, !tbaa !12
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local ptr @fat_lookup(ptr noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca [64 x i8], align 1
  %8 = alloca [16 x i8], align 1
  %9 = ptrtoint ptr %0 to i32
  %10 = sub i32 %9, ptrtoint (ptr @fatnodes to i32)
  %11 = sdiv exact i32 %10, 84
  %12 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %11
  %13 = load i32, ptr %12, align 4, !tbaa !23
  %14 = tail call fastcc i32 @nameq(ptr noundef %1, ptr noundef nonnull @.str) #12
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %22

16:                                               ; preds = %2
  %17 = tail call fastcc i32 @nameq(ptr noundef %1, ptr noundef nonnull @.str.1) #12
  %18 = icmp ne i32 %17, 0
  %19 = load i32, ptr @rootclus, align 4
  %20 = icmp eq i32 %13, %19
  %21 = select i1 %18, i1 %20, i1 false
  br i1 %21, label %22, label %26

22:                                               ; preds = %16, %2
  %23 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %24 = load i32, ptr %23, align 4, !tbaa !12
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %23, align 4, !tbaa !12
  br label %55

26:                                               ; preds = %16
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #13
  store i32 0, ptr %3, align 4, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #13
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %7) #13
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %8) #13
  br label %27

27:                                               ; preds = %33, %26
  %28 = call fastcc i32 @fat_iter(i32 noundef %13, ptr noundef %3, ptr noundef %7, ptr noundef %8, ptr noundef %4, ptr noundef %5, ptr noundef %6) #12
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %53, label %30

30:                                               ; preds = %27
  %31 = call fastcc i32 @nameq(ptr noundef nonnull %7, ptr noundef %1) #12
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %33, label %36

33:                                               ; preds = %30
  %34 = call fastcc i32 @nameq(ptr noundef nonnull %8, ptr noundef %1) #12
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %27, label %36, !llvm.loop !26

36:                                               ; preds = %33, %30
  %37 = tail call fastcc i32 @nameq(ptr noundef %1, ptr noundef nonnull @.str.1) #12
  %38 = icmp ne i32 %37, 0
  %39 = load i32, ptr %4, align 4
  %40 = icmp eq i32 %39, 0
  %41 = select i1 %38, i1 %40, i1 false
  br i1 %41, label %42, label %44

42:                                               ; preds = %36
  %43 = tail call ptr @fat_root() #12
  br label %53

44:                                               ; preds = %36
  %45 = shl i32 %13, 8
  %46 = load i32, ptr %3, align 4
  %47 = or i32 %45, %46
  %48 = or i32 %47, -2147483648
  %49 = select i1 %40, i32 %48, i32 %39
  %50 = load i32, ptr %5, align 4, !tbaa !10
  %51 = load i32, ptr %6, align 4, !tbaa !10
  %52 = tail call fastcc ptr @fat_getnode(i32 noundef %39, i32 noundef %50, i32 noundef %51, i32 noundef %49) #12
  br label %53

53:                                               ; preds = %27, %44, %42
  %54 = phi ptr [ %43, %42 ], [ %52, %44 ], [ null, %27 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #13
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %7) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #13
  br label %55

55:                                               ; preds = %53, %22
  %56 = phi ptr [ %0, %22 ], [ %54, %53 ]
  ret ptr %56
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc i32 @nameq(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #8 {
  br label %3

3:                                                ; preds = %22, %2
  %4 = phi i32 [ undef, %2 ], [ %20, %22 ]
  %5 = phi ptr [ %0, %2 ], [ %23, %22 ]
  %6 = phi ptr [ %1, %2 ], [ %24, %22 ]
  %7 = load i8, ptr %5, align 1, !tbaa !11
  %8 = load i8, ptr %6, align 1, !tbaa !11
  %9 = add i8 %7, -65
  %10 = icmp ult i8 %9, 26
  %11 = or disjoint i8 %7, 32
  %12 = select i1 %10, i8 %11, i8 %7
  %13 = add i8 %8, -65
  %14 = icmp ult i8 %13, 26
  %15 = or disjoint i8 %8, 32
  %16 = select i1 %14, i8 %15, i8 %8
  %17 = icmp eq i8 %12, %16
  %18 = icmp ne i8 %12, 0
  %19 = select i1 %18, i32 %4, i32 1
  %20 = select i1 %17, i32 %19, i32 0
  %21 = and i1 %18, %17
  br i1 %21, label %22, label %25

22:                                               ; preds = %3
  %23 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %24 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %3, !llvm.loop !27

25:                                               ; preds = %3
  ret i32 %20
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 0, 2) i32 @fat_iter(i32 noundef %0, ptr noundef nonnull captures(none) %1, ptr noundef nonnull writeonly captures(none) %2, ptr noundef nonnull captures(none) %3, ptr noundef nonnull writeonly captures(none) %4, ptr noundef nonnull writeonly captures(none) %5, ptr noundef nonnull writeonly captures(none) %6) unnamed_addr #2 {
  %8 = alloca [64 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %8) #13
  %9 = load i32, ptr @clussz, align 4, !tbaa !10
  %10 = lshr i32 %9, 5
  %11 = load i32, ptr @fbase, align 4
  %12 = load i32, ptr @dataoff, align 4
  %13 = add i32 %11, %12
  %14 = getelementptr inbounds nuw i8, ptr %8, i32 63
  %15 = load i32, ptr %1, align 4, !tbaa !10
  br label %16

16:                                               ; preds = %86, %7
  %17 = phi i32 [ %15, %7 ], [ %39, %86 ]
  %18 = phi i32 [ 0, %7 ], [ %87, %86 ]
  br label %19

19:                                               ; preds = %16, %47
  %20 = phi i32 [ %39, %47 ], [ %17, %16 ]
  br label %21

21:                                               ; preds = %28, %19
  %22 = phi i32 [ %0, %19 ], [ %30, %28 ]
  %23 = phi i32 [ %20, %19 ], [ %29, %28 ]
  %24 = add i32 %22, -2
  %25 = icmp ult i32 %24, 268435446
  br i1 %25, label %26, label %181

26:                                               ; preds = %21
  %27 = icmp ult i32 %23, %10
  br i1 %27, label %31, label %28

28:                                               ; preds = %26
  %29 = sub nuw i32 %23, %10
  %30 = tail call fastcc i32 @fat_next(i32 noundef %22) #12
  br label %21, !llvm.loop !28

31:                                               ; preds = %26
  %32 = mul i32 %24, %9
  %33 = shl nuw nsw i32 %23, 5
  %34 = add i32 %33, %32
  %35 = add i32 %34, %13
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %181, label %37

37:                                               ; preds = %31
  %38 = load i32, ptr %1, align 4, !tbaa !10
  %39 = add i32 %38, 1
  store i32 %39, ptr %1, align 4, !tbaa !10
  %40 = inttoptr i32 %35 to ptr
  %41 = load volatile i8, ptr %40, align 1, !tbaa !11
  switch i8 %41, label %42 [
    i8 0, label %181
    i8 -27, label %86
  ], !llvm.loop !29

42:                                               ; preds = %37
  %43 = add i32 %35, 11
  %44 = inttoptr i32 %43 to ptr
  %45 = load volatile i8, ptr %44, align 1, !tbaa !11
  %46 = icmp eq i8 %45, 15
  br i1 %46, label %47, label %82

47:                                               ; preds = %42
  %48 = and i8 %41, 31
  %49 = add nsw i8 %48, -1
  %50 = icmp ult i8 %49, 4
  br i1 %50, label %51, label %19

51:                                               ; preds = %47
  %52 = add i32 %35, 1
  %53 = mul nuw nsw i8 %48, 13
  %54 = zext nneg i8 %53 to i32
  %55 = add nsw i32 %54, -13
  br label %56

56:                                               ; preds = %51, %80
  %57 = phi i32 [ %81, %80 ], [ 0, %51 ]
  %58 = icmp eq i32 %57, 13
  br i1 %58, label %59, label %60

59:                                               ; preds = %56
  store i8 0, ptr %14, align 1, !tbaa !11
  br label %86

60:                                               ; preds = %56
  %61 = getelementptr inbounds nuw [13 x i32], ptr @fat_iter.slots, i32 0, i32 %57
  %62 = load i32, ptr %61, align 4, !tbaa !10
  %63 = add i32 %62, %35
  %64 = inttoptr i32 %63 to ptr
  %65 = load volatile i8, ptr %64, align 1, !tbaa !11
  %66 = add i32 %62, %52
  %67 = inttoptr i32 %66 to ptr
  %68 = load volatile i8, ptr %67, align 1, !tbaa !11
  %69 = add nuw nsw i32 %55, %57
  %70 = icmp ult i32 %69, 63
  br i1 %70, label %71, label %80

71:                                               ; preds = %60
  %72 = zext i8 %65 to i16
  %73 = zext i8 %68 to i16
  %74 = shl nuw i16 %73, 8
  %75 = or disjoint i16 %74, %72
  switch i16 %75, label %76 [
    i16 0, label %77
    i16 -1, label %77
  ]

76:                                               ; preds = %71
  br label %77

77:                                               ; preds = %71, %71, %76
  %78 = phi i8 [ %65, %76 ], [ 0, %71 ], [ 0, %71 ]
  %79 = getelementptr inbounds nuw [64 x i8], ptr %8, i32 0, i32 %69
  store i8 %78, ptr %79, align 1, !tbaa !11
  br label %80

80:                                               ; preds = %77, %60
  %81 = add nuw nsw i32 %57, 1
  br label %56, !llvm.loop !30

82:                                               ; preds = %42
  %83 = zext i8 %45 to i32
  %84 = and i32 %83, 8
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %88, label %86

86:                                               ; preds = %37, %82, %59
  %87 = phi i32 [ 1, %59 ], [ 0, %82 ], [ 0, %37 ]
  br label %16, !llvm.loop !29

88:                                               ; preds = %82, %101
  %89 = phi i32 [ %108, %101 ], [ 0, %82 ]
  %90 = icmp eq i32 %89, 8
  br i1 %90, label %96, label %91

91:                                               ; preds = %88
  %92 = add i32 %89, %35
  %93 = inttoptr i32 %92 to ptr
  %94 = load volatile i8, ptr %93, align 1, !tbaa !11
  %95 = icmp eq i8 %94, 32
  br i1 %95, label %96, label %101

96:                                               ; preds = %88, %91
  %97 = add i32 %35, 8
  %98 = inttoptr i32 %97 to ptr
  %99 = load volatile i8, ptr %98, align 1, !tbaa !11
  %100 = icmp eq i8 %99, 32
  br i1 %100, label %132, label %110

101:                                              ; preds = %91
  %102 = load volatile i8, ptr %93, align 1, !tbaa !11
  %103 = sext i8 %102 to i32
  %104 = add nsw i32 %103, -65
  %105 = icmp ult i32 %104, 26
  %106 = add i8 %102, 32
  %107 = select i1 %105, i8 %106, i8 %102
  %108 = add nuw nsw i32 %89, 1
  %109 = getelementptr inbounds nuw i8, ptr %3, i32 %89
  store i8 %107, ptr %109, align 1, !tbaa !11
  br label %88, !llvm.loop !31

110:                                              ; preds = %96
  %111 = getelementptr inbounds nuw i8, ptr %3, i32 %89
  store i8 46, ptr %111, align 1, !tbaa !11
  %112 = add nuw nsw i32 %89, 3
  br label %113

113:                                              ; preds = %123, %110
  %114 = phi i32 [ %89, %110 ], [ %116, %123 ]
  %115 = phi i32 [ 8, %110 ], [ %131, %123 ]
  %116 = add nuw nsw i32 %114, 1
  %117 = icmp eq i32 %114, %112
  br i1 %117, label %132, label %118

118:                                              ; preds = %113
  %119 = add i32 %115, %35
  %120 = inttoptr i32 %119 to ptr
  %121 = load volatile i8, ptr %120, align 1, !tbaa !11
  %122 = icmp eq i8 %121, 32
  br i1 %122, label %132, label %123

123:                                              ; preds = %118
  %124 = load volatile i8, ptr %120, align 1, !tbaa !11
  %125 = sext i8 %124 to i32
  %126 = add nsw i32 %125, -65
  %127 = icmp ult i32 %126, 26
  %128 = add i8 %124, 32
  %129 = select i1 %127, i8 %128, i8 %124
  %130 = getelementptr inbounds nuw i8, ptr %3, i32 %116
  store i8 %129, ptr %130, align 1, !tbaa !11
  %131 = add nuw nsw i32 %115, 1
  br label %113, !llvm.loop !32

132:                                              ; preds = %118, %113, %96
  %133 = phi i32 [ %89, %96 ], [ %116, %113 ], [ %116, %118 ]
  %134 = getelementptr inbounds i8, ptr %3, i32 %133
  store i8 0, ptr %134, align 1, !tbaa !11
  %135 = icmp eq i32 %18, 0
  br i1 %135, label %144, label %136

136:                                              ; preds = %132, %139
  %137 = phi i32 [ %143, %139 ], [ 0, %132 ]
  %138 = icmp eq i32 %137, 64
  br i1 %138, label %152, label %139

139:                                              ; preds = %136
  %140 = getelementptr inbounds nuw [64 x i8], ptr %8, i32 0, i32 %137
  %141 = load i8, ptr %140, align 1, !tbaa !11
  %142 = getelementptr inbounds nuw i8, ptr %2, i32 %137
  store i8 %141, ptr %142, align 1, !tbaa !11
  %143 = add nuw nsw i32 %137, 1
  br label %136, !llvm.loop !33

144:                                              ; preds = %132, %149
  %145 = phi i32 [ %151, %149 ], [ 0, %132 ]
  %146 = getelementptr inbounds nuw i8, ptr %3, i32 %145
  %147 = load i8, ptr %146, align 1, !tbaa !11
  %148 = icmp eq i8 %147, 0
  br i1 %148, label %152, label %149

149:                                              ; preds = %144
  %150 = getelementptr inbounds nuw i8, ptr %2, i32 %145
  store i8 %147, ptr %150, align 1, !tbaa !11
  %151 = add nuw nsw i32 %145, 1
  br label %144, !llvm.loop !34

152:                                              ; preds = %136, %144
  %153 = phi i32 [ %145, %144 ], [ 63, %136 ]
  %154 = getelementptr inbounds nuw i8, ptr %2, i32 %153
  store i8 0, ptr %154, align 1, !tbaa !11
  %155 = add i32 %35, 20
  %156 = inttoptr i32 %155 to ptr
  %157 = load volatile i8, ptr %156, align 1, !tbaa !11
  %158 = zext i8 %157 to i32
  %159 = add i32 %35, 21
  %160 = inttoptr i32 %159 to ptr
  %161 = load volatile i8, ptr %160, align 1, !tbaa !11
  %162 = zext i8 %161 to i32
  %163 = shl nuw i32 %162, 24
  %164 = shl nuw nsw i32 %158, 16
  %165 = add i32 %35, 26
  %166 = inttoptr i32 %165 to ptr
  %167 = load volatile i8, ptr %166, align 1, !tbaa !11
  %168 = zext i8 %167 to i32
  %169 = add i32 %35, 27
  %170 = inttoptr i32 %169 to ptr
  %171 = load volatile i8, ptr %170, align 1, !tbaa !11
  %172 = zext i8 %171 to i32
  %173 = shl nuw nsw i32 %172, 8
  %174 = or disjoint i32 %163, %164
  %175 = or disjoint i32 %174, %168
  %176 = or disjoint i32 %175, %173
  store i32 %176, ptr %4, align 4, !tbaa !10
  %177 = add i32 %35, 28
  %178 = tail call fastcc i32 @rd32(i32 noundef %177) #12
  store i32 %178, ptr %5, align 4, !tbaa !10
  %179 = lshr i32 %83, 4
  %180 = and i32 %179, 1
  store i32 %180, ptr %6, align 4, !tbaa !10
  br label %181

181:                                              ; preds = %31, %37, %21, %152
  %182 = phi i32 [ 1, %152 ], [ 0, %21 ], [ 0, %37 ], [ 0, %31 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %8) #13
  ret i32 %182
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local ptr @fat_walk(ptr noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  %3 = alloca [64 x i8], align 1
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %5 = load i32, ptr %4, align 4, !tbaa !12
  %6 = add nsw i32 %5, 1
  store i32 %6, ptr %4, align 4, !tbaa !12
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %3) #13
  br label %7

7:                                                ; preds = %50, %2
  %8 = phi ptr [ %1, %2 ], [ %20, %50 ]
  %9 = phi ptr [ %0, %2 ], [ %44, %50 ]
  %10 = load i8, ptr %8, align 1, !tbaa !11
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %52, label %12

12:                                               ; preds = %7, %15
  %13 = phi i8 [ %17, %15 ], [ %10, %7 ]
  %14 = phi ptr [ %16, %15 ], [ %8, %7 ]
  switch i8 %13, label %18 [
    i8 47, label %15
    i8 0, label %52
  ]

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw i8, ptr %14, i32 1
  %17 = load i8, ptr %16, align 1, !tbaa !11
  br label %12, !llvm.loop !35

18:                                               ; preds = %12, %27
  %19 = phi i8 [ %31, %27 ], [ %13, %12 ]
  %20 = phi ptr [ %28, %27 ], [ %14, %12 ]
  %21 = phi i32 [ %29, %27 ], [ 0, %12 ]
  %22 = icmp eq i8 %19, 0
  br i1 %22, label %32, label %23

23:                                               ; preds = %18
  %24 = icmp ne i8 %19, 47
  %25 = icmp samesign ult i32 %21, 63
  %26 = select i1 %24, i1 %25, i1 false
  br i1 %26, label %27, label %32

27:                                               ; preds = %23
  %28 = getelementptr inbounds nuw i8, ptr %20, i32 1
  %29 = add nuw nsw i32 %21, 1
  %30 = getelementptr inbounds nuw [64 x i8], ptr %3, i32 0, i32 %21
  store i8 %19, ptr %30, align 1, !tbaa !11
  %31 = load i8, ptr %28, align 1, !tbaa !11
  br label %18, !llvm.loop !36

32:                                               ; preds = %23, %18
  %33 = getelementptr inbounds nuw [64 x i8], ptr %3, i32 0, i32 %21
  store i8 0, ptr %33, align 1, !tbaa !11
  %34 = getelementptr inbounds nuw i8, ptr %9, i32 20
  %35 = load i16, ptr %34, align 4, !tbaa !19
  %36 = icmp eq i16 %35, 1
  br i1 %36, label %43, label %37

37:                                               ; preds = %32
  %38 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %39 = load i32, ptr %38, align 4, !tbaa !12
  %40 = icmp sgt i32 %39, 0
  br i1 %40, label %41, label %52

41:                                               ; preds = %37
  %42 = add nsw i32 %39, -1
  store i32 %42, ptr %38, align 4, !tbaa !12
  br label %52

43:                                               ; preds = %32
  %44 = call ptr @fat_lookup(ptr noundef nonnull %9, ptr noundef nonnull %3) #12
  %45 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %46 = load i32, ptr %45, align 4, !tbaa !12
  %47 = icmp sgt i32 %46, 0
  br i1 %47, label %48, label %50

48:                                               ; preds = %43
  %49 = add nsw i32 %46, -1
  store i32 %49, ptr %45, align 4, !tbaa !12
  br label %50

50:                                               ; preds = %48, %43
  %51 = icmp eq ptr %44, null
  br i1 %51, label %52, label %7, !llvm.loop !37

52:                                               ; preds = %7, %50, %12, %41, %37
  %53 = phi ptr [ null, %37 ], [ null, %41 ], [ %9, %12 ], [ %9, %7 ], [ null, %50 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %3) #13
  ret ptr %53
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @fat_readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #9 {
  %5 = alloca %struct.dirent, align 2
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca [64 x i8], align 1
  %11 = alloca [16 x i8], align 1
  %12 = ptrtoint ptr %0 to i32
  %13 = sub i32 %12, ptrtoint (ptr @fatnodes to i32)
  %14 = sdiv exact i32 %13, 84
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %16 = load i16, ptr %15, align 4, !tbaa !19
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %18, label %75

18:                                               ; preds = %4
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #13
  %19 = lshr i32 %3, 6
  %20 = lshr i32 %2, 6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #13
  store i32 0, ptr %6, align 4, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #13
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #13
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %11) #13
  %21 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %14
  %22 = getelementptr inbounds nuw i8, ptr %5, i32 2
  br label %23

23:                                               ; preds = %63, %18
  %24 = phi i32 [ %68, %63 ], [ 0, %18 ]
  %25 = phi i32 [ %34, %63 ], [ 0, %18 ]
  %26 = icmp eq i32 %24, %19
  br i1 %26, label %72, label %27

27:                                               ; preds = %23
  %28 = load i32, ptr %21, align 4, !tbaa !23
  br label %29

29:                                               ; preds = %27, %33
  %30 = phi i32 [ %34, %33 ], [ %25, %27 ]
  %31 = call fastcc i32 @fat_iter(i32 noundef %28, ptr noundef %6, ptr noundef %10, ptr noundef %11, ptr noundef %7, ptr noundef %8, ptr noundef %9) #12
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %72, label %33

33:                                               ; preds = %29
  %34 = add i32 %30, 1
  %35 = icmp ult i32 %30, %20
  br i1 %35, label %29, label %36, !llvm.loop !38

36:                                               ; preds = %33, %36
  %37 = phi i32 [ %41, %36 ], [ 0, %33 ]
  %38 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %37
  %39 = load i8, ptr %38, align 1, !tbaa !11
  %40 = icmp eq i8 %39, 0
  %41 = add i32 %37, 1
  br i1 %40, label %42, label %36, !llvm.loop !39

42:                                               ; preds = %36
  %43 = load i32, ptr %7, align 4, !tbaa !10
  %44 = icmp eq i32 %43, 0
  %45 = trunc i32 %43 to i16
  %46 = select i1 %44, i16 -1, i16 %45
  store i16 %46, ptr %5, align 2, !tbaa !40
  br label %47

47:                                               ; preds = %53, %42
  %48 = phi i32 [ 0, %42 ], [ %55, %53 ]
  %49 = icmp eq i32 %48, 62
  br i1 %49, label %50, label %53

50:                                               ; preds = %47
  %51 = icmp ult i32 %37, 63
  %52 = select i1 %51, ptr %10, ptr %11
  br label %56

53:                                               ; preds = %47
  %54 = getelementptr inbounds nuw [62 x i8], ptr %22, i32 0, i32 %48
  store i8 0, ptr %54, align 1, !tbaa !11
  %55 = add nuw nsw i32 %48, 1
  br label %47, !llvm.loop !42

56:                                               ; preds = %50, %69
  %57 = phi i32 [ %71, %69 ], [ 0, %50 ]
  %58 = icmp eq i32 %57, 62
  br i1 %58, label %63, label %59

59:                                               ; preds = %56
  %60 = getelementptr inbounds nuw i8, ptr %52, i32 %57
  %61 = load i8, ptr %60, align 1, !tbaa !11
  %62 = icmp eq i8 %61, 0
  br i1 %62, label %63, label %69

63:                                               ; preds = %56, %59
  %64 = shl nuw i32 %24, 6
  %65 = add i32 %64, %1
  %66 = inttoptr i32 %65 to ptr
  %67 = call ptr @memmove(ptr noundef %66, ptr noundef nonnull %5, i32 noundef 64) #14
  %68 = add nuw nsw i32 %24, 1
  br label %23, !llvm.loop !38

69:                                               ; preds = %59
  %70 = getelementptr inbounds nuw [62 x i8], ptr %22, i32 0, i32 %57
  store i8 %61, ptr %70, align 1, !tbaa !11
  %71 = add nuw nsw i32 %57, 1
  br label %56, !llvm.loop !43

72:                                               ; preds = %23, %29
  %73 = phi i32 [ %24, %29 ], [ %19, %23 ]
  %74 = shl i32 %73, 6
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %11) #13
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #13
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #13
  br label %127

75:                                               ; preds = %4
  %76 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %14
  %77 = getelementptr inbounds nuw i8, ptr %76, i32 4
  %78 = load i32, ptr %77, align 4, !tbaa !25
  %79 = icmp ult i32 %2, %78
  br i1 %79, label %80, label %127

80:                                               ; preds = %75
  %81 = load i32, ptr %76, align 4, !tbaa !23
  %82 = load i32, ptr @clussz, align 4, !tbaa !10
  %83 = freeze i32 %82
  %84 = udiv i32 %2, %83
  br label %85

85:                                               ; preds = %92, %80
  %86 = phi i32 [ %81, %80 ], [ %94, %92 ]
  %87 = phi i32 [ %84, %80 ], [ %93, %92 ]
  %88 = icmp ne i32 %87, 0
  %89 = add i32 %86, -2
  %90 = icmp ult i32 %89, 268435446
  %91 = select i1 %88, i1 %90, i1 false
  br i1 %91, label %92, label %95

92:                                               ; preds = %85
  %93 = add i32 %87, -1
  %94 = tail call fastcc i32 @fat_next(i32 noundef %86) #12
  br label %85, !llvm.loop !44

95:                                               ; preds = %85
  %96 = add i32 %3, %2
  %97 = icmp ugt i32 %96, %78
  %98 = sub nuw i32 %78, %2
  %99 = select i1 %97, i32 %98, i32 %3
  %100 = mul i32 %84, %83
  %101 = sub i32 %2, %100
  br label %102

102:                                              ; preds = %110, %95
  %103 = phi i32 [ %86, %95 ], [ %126, %110 ]
  %104 = phi i32 [ 0, %95 ], [ %125, %110 ]
  %105 = phi i32 [ %101, %95 ], [ 0, %110 ]
  %106 = icmp ult i32 %104, %99
  %107 = add i32 %103, -2
  %108 = icmp ult i32 %107, 268435446
  %109 = select i1 %106, i1 %108, i1 false
  br i1 %109, label %110, label %127

110:                                              ; preds = %102
  %111 = load i32, ptr @clussz, align 4, !tbaa !10
  %112 = sub nsw i32 %111, %105
  %113 = sub nuw i32 %99, %104
  %114 = tail call i32 @llvm.umin.i32(i32 %112, i32 %113)
  %115 = add i32 %104, %1
  %116 = inttoptr i32 %115 to ptr
  %117 = load i32, ptr @fbase, align 4, !tbaa !10
  %118 = load i32, ptr @dataoff, align 4, !tbaa !10
  %119 = mul i32 %111, %107
  %120 = add i32 %117, %105
  %121 = add i32 %120, %119
  %122 = add i32 %121, %118
  %123 = inttoptr i32 %122 to ptr
  %124 = tail call ptr @memmove(ptr noundef %116, ptr noundef %123, i32 noundef %114) #14
  %125 = add i32 %114, %104
  %126 = tail call fastcc i32 @fat_next(i32 noundef %103) #12
  br label %102, !llvm.loop !45

127:                                              ; preds = %102, %75, %72
  %128 = phi i32 [ %74, %72 ], [ 0, %75 ], [ %104, %102 ]
  ret i32 %128
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #10

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define internal fastcc range(i32 0, 268435456) i32 @fat_next(i32 noundef range(i32 2, 268435448) %0) unnamed_addr #4 {
  %2 = load i32, ptr @fbase, align 4, !tbaa !10
  %3 = load i32, ptr @fatoff, align 4, !tbaa !10
  %4 = shl nuw nsw i32 %0, 2
  %5 = add i32 %2, %4
  %6 = add i32 %5, %3
  %7 = tail call fastcc i32 @rd32(i32 noundef %6) #12
  %8 = and i32 %7, 268435455
  ret i32 %8
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @fat_stati(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) initializes((0, 16)) %1) local_unnamed_addr #7 {
  store i32 4007, ptr %1, align 4, !tbaa !46
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !17
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %4, ptr %5, align 4, !tbaa !49
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %7 = load i16, ptr %6, align 4, !tbaa !19
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i16 %7, ptr %8, align 4, !tbaa !50
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 10
  store i16 1, ptr %9, align 2, !tbaa !51
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %11 = load i32, ptr %10, align 4, !tbaa !22
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %11, ptr %12, align 4, !tbaa !52
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #11

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #11 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }
attributes #13 = { nounwind }
attributes #14 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
!10 = !{!5, !5, i64 0}
!11 = !{!6, !6, i64 0}
!12 = !{!4, !5, i64 8}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !14, !15}
!17 = !{!4, !5, i64 4}
!18 = distinct !{!18, !14, !15}
!19 = !{!4, !9, i64 20}
!20 = !{!4, !9, i64 26}
!21 = distinct !{!21, !14, !15}
!22 = !{!4, !5, i64 28}
!23 = !{!24, !5, i64 0}
!24 = !{!"fatmeta", !5, i64 0, !5, i64 4}
!25 = !{!24, !5, i64 4}
!26 = distinct !{!26, !14, !15}
!27 = distinct !{!27, !15}
!28 = distinct !{!28, !14, !15}
!29 = distinct !{!29, !15}
!30 = distinct !{!30, !14, !15}
!31 = distinct !{!31, !14, !15}
!32 = distinct !{!32, !14, !15}
!33 = distinct !{!33, !14, !15}
!34 = distinct !{!34, !14, !15}
!35 = distinct !{!35, !14, !15}
!36 = distinct !{!36, !14, !15}
!37 = distinct !{!37, !14, !15}
!38 = distinct !{!38, !14, !15}
!39 = distinct !{!39, !14, !15}
!40 = !{!41, !9, i64 0}
!41 = !{!"dirent", !9, i64 0, !6, i64 2}
!42 = distinct !{!42, !14, !15}
!43 = distinct !{!43, !14, !15}
!44 = distinct !{!44, !14, !15}
!45 = distinct !{!45, !14, !15}
!46 = !{!47, !5, i64 0}
!47 = !{!"stat", !5, i64 0, !5, i64 4, !9, i64 8, !9, i64 10, !48, i64 12}
!48 = !{!"long", !6, i64 0}
!49 = !{!47, !5, i64 4}
!50 = !{!47, !9, i64 8}
!51 = !{!47, !9, i64 10}
!52 = !{!47, !48, i64 12}
