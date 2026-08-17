; ModuleID = 'kfat.c'
source_filename = "kfat.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.inode = type { i32, i32, i32, %struct.sleeplock, i32, i16, i16, i16, i16, i32, [13 x i32] }
%struct.sleeplock = type { i8 }
%struct.fatmeta = type { i32, i32 }
%struct.dirent = type { i16, [14 x i8] }

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
  %8 = ptrtoint ptr %0 to i32
  %9 = sub i32 %8, ptrtoint (ptr @fatnodes to i32)
  %10 = sdiv exact i32 %9, 84
  %11 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %10
  %12 = load i32, ptr %11, align 4, !tbaa !23
  %13 = tail call fastcc i32 @nameq(ptr noundef %1, ptr noundef nonnull @.str) #12
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %21

15:                                               ; preds = %2
  %16 = tail call fastcc i32 @nameq(ptr noundef %1, ptr noundef nonnull @.str.1) #12
  %17 = icmp ne i32 %16, 0
  %18 = load i32, ptr @rootclus, align 4
  %19 = icmp eq i32 %12, %18
  %20 = select i1 %17, i1 %19, i1 false
  br i1 %20, label %21, label %25

21:                                               ; preds = %15, %2
  %22 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %23 = load i32, ptr %22, align 4, !tbaa !12
  %24 = add nsw i32 %23, 1
  store i32 %24, ptr %22, align 4, !tbaa !12
  br label %51

25:                                               ; preds = %15
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #13
  store i32 0, ptr %3, align 4, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #13
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %7) #13
  br label %26

26:                                               ; preds = %29, %25
  %27 = call fastcc i32 @fat_iter(i32 noundef %12, ptr noundef %3, ptr noundef %7, ptr noundef %4, ptr noundef %5, ptr noundef %6) #12
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %49, label %29

29:                                               ; preds = %26
  %30 = call fastcc i32 @nameq(ptr noundef nonnull %7, ptr noundef %1) #12
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %26, label %32, !llvm.loop !26

32:                                               ; preds = %29
  %33 = tail call fastcc i32 @nameq(ptr noundef %1, ptr noundef nonnull @.str.1) #12
  %34 = icmp ne i32 %33, 0
  %35 = load i32, ptr %4, align 4
  %36 = icmp eq i32 %35, 0
  %37 = select i1 %34, i1 %36, i1 false
  br i1 %37, label %38, label %40

38:                                               ; preds = %32
  %39 = tail call ptr @fat_root() #12
  br label %49

40:                                               ; preds = %32
  %41 = shl i32 %12, 8
  %42 = load i32, ptr %3, align 4
  %43 = or i32 %41, %42
  %44 = or i32 %43, -2147483648
  %45 = select i1 %36, i32 %44, i32 %35
  %46 = load i32, ptr %5, align 4, !tbaa !10
  %47 = load i32, ptr %6, align 4, !tbaa !10
  %48 = tail call fastcc ptr @fat_getnode(i32 noundef %35, i32 noundef %46, i32 noundef %47, i32 noundef %45) #12
  br label %49

49:                                               ; preds = %26, %40, %38
  %50 = phi ptr [ %39, %38 ], [ %48, %40 ], [ null, %26 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %7) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #13
  br label %51

51:                                               ; preds = %49, %21
  %52 = phi ptr [ %0, %21 ], [ %50, %49 ]
  ret ptr %52
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
define internal fastcc range(i32 0, 2) i32 @fat_iter(i32 noundef %0, ptr noundef nonnull captures(none) %1, ptr noundef nonnull writeonly captures(none) %2, ptr noundef nonnull writeonly captures(none) %3, ptr noundef nonnull writeonly captures(none) %4, ptr noundef nonnull writeonly captures(none) %5) unnamed_addr #2 {
  %7 = alloca [64 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %7) #13
  %8 = load i32, ptr @clussz, align 4, !tbaa !10
  %9 = lshr i32 %8, 5
  %10 = load i32, ptr @fbase, align 4
  %11 = load i32, ptr @dataoff, align 4
  %12 = add i32 %10, %11
  %13 = getelementptr inbounds nuw i8, ptr %7, i32 63
  %14 = load i32, ptr %1, align 4, !tbaa !10
  br label %15

15:                                               ; preds = %85, %6
  %16 = phi i32 [ %14, %6 ], [ %38, %85 ]
  %17 = phi i32 [ 0, %6 ], [ %86, %85 ]
  br label %18

18:                                               ; preds = %15, %46
  %19 = phi i32 [ %38, %46 ], [ %16, %15 ]
  br label %20

20:                                               ; preds = %27, %18
  %21 = phi i32 [ %0, %18 ], [ %29, %27 ]
  %22 = phi i32 [ %19, %18 ], [ %28, %27 ]
  %23 = add i32 %21, -2
  %24 = icmp ult i32 %23, 268435446
  br i1 %24, label %25, label %170

25:                                               ; preds = %20
  %26 = icmp ult i32 %22, %9
  br i1 %26, label %30, label %27

27:                                               ; preds = %25
  %28 = sub nuw i32 %22, %9
  %29 = tail call fastcc i32 @fat_next(i32 noundef %21) #12
  br label %20, !llvm.loop !28

30:                                               ; preds = %25
  %31 = mul i32 %23, %8
  %32 = shl nuw nsw i32 %22, 5
  %33 = add i32 %32, %31
  %34 = add i32 %33, %12
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %170, label %36

36:                                               ; preds = %30
  %37 = load i32, ptr %1, align 4, !tbaa !10
  %38 = add i32 %37, 1
  store i32 %38, ptr %1, align 4, !tbaa !10
  %39 = inttoptr i32 %34 to ptr
  %40 = load volatile i8, ptr %39, align 1, !tbaa !11
  switch i8 %40, label %41 [
    i8 0, label %170
    i8 -27, label %85
  ], !llvm.loop !29

41:                                               ; preds = %36
  %42 = add i32 %34, 11
  %43 = inttoptr i32 %42 to ptr
  %44 = load volatile i8, ptr %43, align 1, !tbaa !11
  %45 = icmp eq i8 %44, 15
  br i1 %45, label %46, label %81

46:                                               ; preds = %41
  %47 = and i8 %40, 31
  %48 = add nsw i8 %47, -1
  %49 = icmp ult i8 %48, 4
  br i1 %49, label %50, label %18

50:                                               ; preds = %46
  %51 = add i32 %34, 1
  %52 = mul nuw nsw i8 %47, 13
  %53 = zext nneg i8 %52 to i32
  %54 = add nsw i32 %53, -13
  br label %55

55:                                               ; preds = %50, %79
  %56 = phi i32 [ %80, %79 ], [ 0, %50 ]
  %57 = icmp eq i32 %56, 13
  br i1 %57, label %58, label %59

58:                                               ; preds = %55
  store i8 0, ptr %13, align 1, !tbaa !11
  br label %85

59:                                               ; preds = %55
  %60 = getelementptr inbounds nuw [13 x i32], ptr @fat_iter.slots, i32 0, i32 %56
  %61 = load i32, ptr %60, align 4, !tbaa !10
  %62 = add i32 %61, %34
  %63 = inttoptr i32 %62 to ptr
  %64 = load volatile i8, ptr %63, align 1, !tbaa !11
  %65 = add i32 %61, %51
  %66 = inttoptr i32 %65 to ptr
  %67 = load volatile i8, ptr %66, align 1, !tbaa !11
  %68 = add nuw nsw i32 %54, %56
  %69 = icmp ult i32 %68, 63
  br i1 %69, label %70, label %79

70:                                               ; preds = %59
  %71 = zext i8 %64 to i16
  %72 = zext i8 %67 to i16
  %73 = shl nuw i16 %72, 8
  %74 = or disjoint i16 %73, %71
  switch i16 %74, label %75 [
    i16 0, label %76
    i16 -1, label %76
  ]

75:                                               ; preds = %70
  br label %76

76:                                               ; preds = %70, %70, %75
  %77 = phi i8 [ %64, %75 ], [ 0, %70 ], [ 0, %70 ]
  %78 = getelementptr inbounds nuw [64 x i8], ptr %7, i32 0, i32 %68
  store i8 %77, ptr %78, align 1, !tbaa !11
  br label %79

79:                                               ; preds = %76, %59
  %80 = add nuw nsw i32 %56, 1
  br label %55, !llvm.loop !30

81:                                               ; preds = %41
  %82 = zext i8 %44 to i32
  %83 = and i32 %82, 8
  %84 = icmp eq i32 %83, 0
  br i1 %84, label %87, label %85

85:                                               ; preds = %36, %81, %58
  %86 = phi i32 [ 1, %58 ], [ 0, %81 ], [ 0, %36 ]
  br label %15, !llvm.loop !29

87:                                               ; preds = %81
  %88 = icmp eq i32 %17, 0
  br i1 %88, label %97, label %89

89:                                               ; preds = %87, %92
  %90 = phi i32 [ %96, %92 ], [ 0, %87 ]
  %91 = icmp eq i32 %90, 64
  br i1 %91, label %141, label %92

92:                                               ; preds = %89
  %93 = getelementptr inbounds nuw [64 x i8], ptr %7, i32 0, i32 %90
  %94 = load i8, ptr %93, align 1, !tbaa !11
  %95 = getelementptr inbounds nuw i8, ptr %2, i32 %90
  store i8 %94, ptr %95, align 1, !tbaa !11
  %96 = add nuw nsw i32 %90, 1
  br label %89, !llvm.loop !31

97:                                               ; preds = %87, %110
  %98 = phi i32 [ %117, %110 ], [ 0, %87 ]
  %99 = icmp eq i32 %98, 8
  br i1 %99, label %105, label %100

100:                                              ; preds = %97
  %101 = add i32 %98, %34
  %102 = inttoptr i32 %101 to ptr
  %103 = load volatile i8, ptr %102, align 1, !tbaa !11
  %104 = icmp eq i8 %103, 32
  br i1 %104, label %105, label %110

105:                                              ; preds = %97, %100
  %106 = add i32 %34, 8
  %107 = inttoptr i32 %106 to ptr
  %108 = load volatile i8, ptr %107, align 1, !tbaa !11
  %109 = icmp eq i8 %108, 32
  br i1 %109, label %141, label %119

110:                                              ; preds = %100
  %111 = load volatile i8, ptr %102, align 1, !tbaa !11
  %112 = sext i8 %111 to i32
  %113 = add nsw i32 %112, -65
  %114 = icmp ult i32 %113, 26
  %115 = add i8 %111, 32
  %116 = select i1 %114, i8 %115, i8 %111
  %117 = add nuw nsw i32 %98, 1
  %118 = getelementptr inbounds nuw i8, ptr %2, i32 %98
  store i8 %116, ptr %118, align 1, !tbaa !11
  br label %97, !llvm.loop !32

119:                                              ; preds = %105
  %120 = getelementptr inbounds nuw i8, ptr %2, i32 %98
  store i8 46, ptr %120, align 1, !tbaa !11
  %121 = add nuw nsw i32 %98, 3
  br label %122

122:                                              ; preds = %132, %119
  %123 = phi i32 [ %98, %119 ], [ %125, %132 ]
  %124 = phi i32 [ 8, %119 ], [ %140, %132 ]
  %125 = add nuw nsw i32 %123, 1
  %126 = icmp eq i32 %123, %121
  br i1 %126, label %141, label %127

127:                                              ; preds = %122
  %128 = add i32 %124, %34
  %129 = inttoptr i32 %128 to ptr
  %130 = load volatile i8, ptr %129, align 1, !tbaa !11
  %131 = icmp eq i8 %130, 32
  br i1 %131, label %141, label %132

132:                                              ; preds = %127
  %133 = load volatile i8, ptr %129, align 1, !tbaa !11
  %134 = sext i8 %133 to i32
  %135 = add nsw i32 %134, -65
  %136 = icmp ult i32 %135, 26
  %137 = add i8 %133, 32
  %138 = select i1 %136, i8 %137, i8 %133
  %139 = getelementptr inbounds nuw i8, ptr %2, i32 %125
  store i8 %138, ptr %139, align 1, !tbaa !11
  %140 = add nuw nsw i32 %124, 1
  br label %122, !llvm.loop !33

141:                                              ; preds = %89, %122, %127, %105
  %142 = phi i32 [ %98, %105 ], [ %125, %127 ], [ %125, %122 ], [ 63, %89 ]
  %143 = getelementptr inbounds i8, ptr %2, i32 %142
  store i8 0, ptr %143, align 1, !tbaa !11
  %144 = add i32 %34, 20
  %145 = inttoptr i32 %144 to ptr
  %146 = load volatile i8, ptr %145, align 1, !tbaa !11
  %147 = zext i8 %146 to i32
  %148 = add i32 %34, 21
  %149 = inttoptr i32 %148 to ptr
  %150 = load volatile i8, ptr %149, align 1, !tbaa !11
  %151 = zext i8 %150 to i32
  %152 = shl nuw i32 %151, 24
  %153 = shl nuw nsw i32 %147, 16
  %154 = add i32 %34, 26
  %155 = inttoptr i32 %154 to ptr
  %156 = load volatile i8, ptr %155, align 1, !tbaa !11
  %157 = zext i8 %156 to i32
  %158 = add i32 %34, 27
  %159 = inttoptr i32 %158 to ptr
  %160 = load volatile i8, ptr %159, align 1, !tbaa !11
  %161 = zext i8 %160 to i32
  %162 = shl nuw nsw i32 %161, 8
  %163 = or disjoint i32 %152, %153
  %164 = or disjoint i32 %163, %157
  %165 = or disjoint i32 %164, %162
  store i32 %165, ptr %3, align 4, !tbaa !10
  %166 = add i32 %34, 28
  %167 = tail call fastcc i32 @rd32(i32 noundef %166) #12
  store i32 %167, ptr %4, align 4, !tbaa !10
  %168 = lshr i32 %82, 4
  %169 = and i32 %168, 1
  store i32 %169, ptr %5, align 4, !tbaa !10
  br label %170

170:                                              ; preds = %30, %36, %20, %141
  %171 = phi i32 [ 1, %141 ], [ 0, %20 ], [ 0, %36 ], [ 0, %30 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %7) #13
  ret i32 %171
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
  br label %12, !llvm.loop !34

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
  br label %18, !llvm.loop !35

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
  br i1 %51, label %52, label %7, !llvm.loop !36

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
  %11 = ptrtoint ptr %0 to i32
  %12 = sub i32 %11, ptrtoint (ptr @fatnodes to i32)
  %13 = sdiv exact i32 %12, 84
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %15 = load i16, ptr %14, align 4, !tbaa !19
  %16 = icmp eq i16 %15, 1
  br i1 %16, label %17, label %65

17:                                               ; preds = %4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #13
  %18 = lshr i32 %3, 4
  %19 = lshr i32 %2, 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #13
  store i32 0, ptr %6, align 4, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #13
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #13
  %20 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %13
  %21 = getelementptr inbounds nuw i8, ptr %5, i32 2
  br label %22

22:                                               ; preds = %53, %17
  %23 = phi i32 [ %58, %53 ], [ 0, %17 ]
  %24 = phi i32 [ %33, %53 ], [ 0, %17 ]
  %25 = icmp eq i32 %23, %18
  br i1 %25, label %62, label %26

26:                                               ; preds = %22
  %27 = load i32, ptr %20, align 4, !tbaa !23
  br label %28

28:                                               ; preds = %26, %32
  %29 = phi i32 [ %33, %32 ], [ %24, %26 ]
  %30 = call fastcc i32 @fat_iter(i32 noundef %27, ptr noundef %6, ptr noundef %10, ptr noundef %7, ptr noundef %8, ptr noundef %9) #12
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %62, label %32

32:                                               ; preds = %28
  %33 = add i32 %29, 1
  %34 = icmp ult i32 %29, %19
  br i1 %34, label %28, label %35, !llvm.loop !37

35:                                               ; preds = %32
  %36 = load i32, ptr %7, align 4, !tbaa !10
  %37 = icmp eq i32 %36, 0
  %38 = trunc i32 %36 to i16
  %39 = select i1 %37, i16 -1, i16 %38
  store i16 %39, ptr %5, align 2, !tbaa !38
  br label %40

40:                                               ; preds = %43, %35
  %41 = phi i32 [ 0, %35 ], [ %45, %43 ]
  %42 = icmp eq i32 %41, 14
  br i1 %42, label %46, label %43

43:                                               ; preds = %40
  %44 = getelementptr inbounds nuw [14 x i8], ptr %21, i32 0, i32 %41
  store i8 0, ptr %44, align 1, !tbaa !11
  %45 = add nuw nsw i32 %41, 1
  br label %40, !llvm.loop !40

46:                                               ; preds = %40, %59
  %47 = phi i32 [ %61, %59 ], [ 0, %40 ]
  %48 = icmp eq i32 %47, 14
  br i1 %48, label %53, label %49

49:                                               ; preds = %46
  %50 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %47
  %51 = load i8, ptr %50, align 1, !tbaa !11
  %52 = icmp eq i8 %51, 0
  br i1 %52, label %53, label %59

53:                                               ; preds = %46, %49
  %54 = shl nuw i32 %23, 4
  %55 = add i32 %54, %1
  %56 = inttoptr i32 %55 to ptr
  %57 = call ptr @memmove(ptr noundef %56, ptr noundef nonnull %5, i32 noundef 16) #14
  %58 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !37

59:                                               ; preds = %49
  %60 = getelementptr inbounds nuw [14 x i8], ptr %21, i32 0, i32 %47
  store i8 %51, ptr %60, align 1, !tbaa !11
  %61 = add nuw nsw i32 %47, 1
  br label %46, !llvm.loop !41

62:                                               ; preds = %22, %28
  %63 = phi i32 [ %23, %28 ], [ %18, %22 ]
  %64 = shl i32 %63, 4
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #13
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #13
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #13
  br label %117

65:                                               ; preds = %4
  %66 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %13
  %67 = getelementptr inbounds nuw i8, ptr %66, i32 4
  %68 = load i32, ptr %67, align 4, !tbaa !25
  %69 = icmp ult i32 %2, %68
  br i1 %69, label %70, label %117

70:                                               ; preds = %65
  %71 = load i32, ptr %66, align 4, !tbaa !23
  %72 = load i32, ptr @clussz, align 4, !tbaa !10
  %73 = freeze i32 %72
  %74 = udiv i32 %2, %73
  br label %75

75:                                               ; preds = %82, %70
  %76 = phi i32 [ %71, %70 ], [ %84, %82 ]
  %77 = phi i32 [ %74, %70 ], [ %83, %82 ]
  %78 = icmp ne i32 %77, 0
  %79 = add i32 %76, -2
  %80 = icmp ult i32 %79, 268435446
  %81 = select i1 %78, i1 %80, i1 false
  br i1 %81, label %82, label %85

82:                                               ; preds = %75
  %83 = add i32 %77, -1
  %84 = tail call fastcc i32 @fat_next(i32 noundef %76) #12
  br label %75, !llvm.loop !42

85:                                               ; preds = %75
  %86 = add i32 %3, %2
  %87 = icmp ugt i32 %86, %68
  %88 = sub nuw i32 %68, %2
  %89 = select i1 %87, i32 %88, i32 %3
  %90 = mul i32 %74, %73
  %91 = sub i32 %2, %90
  br label %92

92:                                               ; preds = %100, %85
  %93 = phi i32 [ %76, %85 ], [ %116, %100 ]
  %94 = phi i32 [ 0, %85 ], [ %115, %100 ]
  %95 = phi i32 [ %91, %85 ], [ 0, %100 ]
  %96 = icmp ult i32 %94, %89
  %97 = add i32 %93, -2
  %98 = icmp ult i32 %97, 268435446
  %99 = select i1 %96, i1 %98, i1 false
  br i1 %99, label %100, label %117

100:                                              ; preds = %92
  %101 = load i32, ptr @clussz, align 4, !tbaa !10
  %102 = sub nsw i32 %101, %95
  %103 = sub nuw i32 %89, %94
  %104 = tail call i32 @llvm.umin.i32(i32 %102, i32 %103)
  %105 = add i32 %94, %1
  %106 = inttoptr i32 %105 to ptr
  %107 = load i32, ptr @fbase, align 4, !tbaa !10
  %108 = load i32, ptr @dataoff, align 4, !tbaa !10
  %109 = mul i32 %101, %97
  %110 = add i32 %107, %95
  %111 = add i32 %110, %109
  %112 = add i32 %111, %108
  %113 = inttoptr i32 %112 to ptr
  %114 = tail call ptr @memmove(ptr noundef %106, ptr noundef %113, i32 noundef %104) #14
  %115 = add i32 %104, %94
  %116 = tail call fastcc i32 @fat_next(i32 noundef %93) #12
  br label %92, !llvm.loop !43

117:                                              ; preds = %92, %65, %62
  %118 = phi i32 [ %64, %62 ], [ 0, %65 ], [ %94, %92 ]
  ret i32 %118
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
  store i32 4007, ptr %1, align 4, !tbaa !44
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !17
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %4, ptr %5, align 4, !tbaa !47
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %7 = load i16, ptr %6, align 4, !tbaa !19
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i16 %7, ptr %8, align 4, !tbaa !48
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 10
  store i16 1, ptr %9, align 2, !tbaa !49
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %11 = load i32, ptr %10, align 4, !tbaa !22
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %11, ptr %12, align 4, !tbaa !50
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
!38 = !{!39, !9, i64 0}
!39 = !{!"dirent", !9, i64 0, !6, i64 2}
!40 = distinct !{!40, !14, !15}
!41 = distinct !{!41, !14, !15}
!42 = distinct !{!42, !14, !15}
!43 = distinct !{!43, !14, !15}
!44 = !{!45, !5, i64 0}
!45 = !{!"stat", !5, i64 0, !5, i64 4, !9, i64 8, !9, i64 10, !46, i64 12}
!46 = !{!"long", !6, i64 0}
!47 = !{!45, !5, i64 4}
!48 = !{!45, !9, i64 8}
!49 = !{!45, !9, i64 10}
!50 = !{!45, !46, i64 12}
