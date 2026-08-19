; ModuleID = 'kfat.c'
source_filename = "kfat.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.inode = type { i32, i32, i32, %struct.sleeplock, i32, i16, i16, i16, i16, i32, [13 x i32] }
%struct.sleeplock = type { i8 }
%struct.fatmeta = type { i32, i32 }
%struct.dirent = type { i16, [62 x i8] }

@fbase = internal unnamed_addr global i32 0, align 4
@sdtag = internal unnamed_addr global [2 x i32] zeroinitializer, align 4
@fat_sd = internal unnamed_addr global i1 false, align 4
@sdpart = internal unnamed_addr global i32 0, align 4
@secsz = internal unnamed_addr global i32 0, align 4
@rootclus = internal unnamed_addr global i32 0, align 4
@clussz = internal unnamed_addr global i32 0, align 4
@fatoff = internal unnamed_addr global i32 0, align 4
@dataoff = internal unnamed_addr global i32 0, align 4
@fatnodes = internal global [16 x %struct.inode] zeroinitializer, align 4
@fatmeta = internal unnamed_addr global [16 x %struct.fatmeta] zeroinitializer, align 4
@.str = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"..\00", align 1
@fat_iter.slots = internal unnamed_addr constant [13 x i32] [i32 1, i32 3, i32 5, i32 7, i32 9, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 28, i32 30], align 4
@sdcache = internal global [2 x [512 x i8]] zeroinitializer, align 1
@sdvict = internal unnamed_addr global i32 0, align 4

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

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @fat_mount_sd() local_unnamed_addr #2 {
  %1 = alloca [2 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %1) #10
  store volatile i32 -1, ptr %1, align 4, !tbaa !10
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store volatile i32 0, ptr %2, align 4, !tbaa !10
  %3 = ptrtoint ptr %1 to i32
  %4 = call i32 @kflash_sd(i32 noundef 5, i32 noundef 0, i32 noundef %3) #11
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %52, label %6

6:                                                ; preds = %0
  %7 = load volatile i32, ptr %1, align 4, !tbaa !10
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %52

9:                                                ; preds = %6, %15
  %10 = phi i32 [ %17, %15 ], [ 0, %6 ]
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %15

12:                                               ; preds = %9
  store i1 true, ptr @fat_sd, align 4
  store i32 0, ptr @sdpart, align 4, !tbaa !10
  %13 = call fastcc i32 @rd8(i32 noundef 134218238) #12
  %14 = icmp eq i32 %13, 85
  br i1 %14, label %18, label %51

15:                                               ; preds = %9
  %16 = getelementptr inbounds nuw [2 x i32], ptr @sdtag, i32 0, i32 %10
  store i32 0, ptr %16, align 4, !tbaa !10
  %17 = add nuw nsw i32 %10, 1
  br label %9, !llvm.loop !11

18:                                               ; preds = %12
  %19 = call fastcc i32 @rd8(i32 noundef 134218239) #12
  %20 = icmp eq i32 %19, 170
  br i1 %20, label %21, label %51

21:                                               ; preds = %18
  %22 = call fastcc i32 @rd8(i32 noundef 134217739) #12
  %23 = call fastcc i32 @rd8(i32 noundef 134217740) #12
  %24 = shl nuw nsw i32 %23, 8
  %25 = or disjoint i32 %24, %22
  %26 = icmp eq i32 %25, 512
  br i1 %26, label %48, label %27

27:                                               ; preds = %21
  %28 = call fastcc i32 @rd8(i32 noundef 134218178) #12
  %29 = add nsw i32 %28, -11
  %30 = icmp ult i32 %29, 2
  br i1 %30, label %31, label %51

31:                                               ; preds = %27
  %32 = call fastcc i32 @rd8(i32 noundef 134218182) #12
  %33 = call fastcc i32 @rd8(i32 noundef 134218183) #12
  %34 = shl nuw nsw i32 %33, 8
  %35 = or disjoint i32 %34, %32
  %36 = call fastcc i32 @rd8(i32 noundef 134218184) #12
  %37 = shl nuw nsw i32 %36, 16
  %38 = or disjoint i32 %35, %37
  %39 = call fastcc i32 @rd8(i32 noundef 134218185) #12
  %40 = shl nuw i32 %39, 24
  %41 = or disjoint i32 %38, %40
  store i32 %41, ptr @sdpart, align 4, !tbaa !10
  br label %42

42:                                               ; preds = %45, %31
  %43 = phi i32 [ 0, %31 ], [ %47, %45 ]
  %44 = icmp eq i32 %43, 2
  br i1 %44, label %48, label %45

45:                                               ; preds = %42
  %46 = getelementptr inbounds nuw [2 x i32], ptr @sdtag, i32 0, i32 %43
  store i32 0, ptr %46, align 4, !tbaa !10
  %47 = add nuw nsw i32 %43, 1
  br label %42, !llvm.loop !14

48:                                               ; preds = %42, %21
  %49 = call i32 @fat_mount(i32 noundef 134217728) #12
  %50 = icmp slt i32 %49, 0
  br i1 %50, label %51, label %52

51:                                               ; preds = %48, %27, %12, %18
  store i1 false, ptr @fat_sd, align 4
  br label %52

52:                                               ; preds = %51, %48, %0, %6
  %53 = phi i32 [ -1, %6 ], [ -1, %0 ], [ 0, %48 ], [ -1, %51 ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %1) #10
  ret i32 %53
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sd(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 256) i32 @rd8(i32 noundef %0) unnamed_addr #2 {
  %2 = load i1, ptr @fat_sd, align 4
  br i1 %2, label %3, label %10

3:                                                ; preds = %1
  %4 = add i32 %0, -134217728
  %5 = lshr i32 %4, 9
  %6 = tail call fastcc ptr @sdsec(i32 noundef %5) #12
  %7 = and i32 %0, 511
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 %7
  %9 = load i8, ptr %8, align 1, !tbaa !15
  br label %13

10:                                               ; preds = %1
  %11 = inttoptr i32 %0 to ptr
  %12 = load volatile i8, ptr %11, align 1, !tbaa !15
  br label %13

13:                                               ; preds = %10, %3
  %14 = phi i8 [ %9, %3 ], [ %12, %10 ]
  %15 = zext i8 %14 to i32
  ret i32 %15
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @fat_mount(i32 noundef %0) local_unnamed_addr #2 {
  %2 = add i32 %0, 510
  %3 = tail call fastcc i32 @rd16(i32 noundef %2) #12
  %4 = icmp eq i32 %3, 43605
  br i1 %4, label %5, label %40

5:                                                ; preds = %1
  %6 = add i32 %0, 11
  %7 = tail call fastcc i32 @rd16(i32 noundef %6) #12
  store i32 %7, ptr @secsz, align 4, !tbaa !10
  %8 = add i32 %0, 13
  %9 = tail call fastcc i32 @rd8(i32 noundef %8) #12
  %10 = add i32 %0, 14
  %11 = tail call fastcc i32 @rd16(i32 noundef %10) #12
  %12 = add i32 %0, 16
  %13 = tail call fastcc i32 @rd8(i32 noundef %12) #12
  %14 = add i32 %0, 36
  %15 = tail call fastcc i32 @rd32(i32 noundef %14) #12
  %16 = add i32 %0, 44
  %17 = tail call fastcc i32 @rd32(i32 noundef %16) #12
  store i32 %17, ptr @rootclus, align 4, !tbaa !10
  %18 = load i32, ptr @secsz, align 4, !tbaa !10
  %19 = icmp eq i32 %18, 512
  br i1 %19, label %20, label %40

20:                                               ; preds = %5
  %21 = icmp eq i32 %9, 0
  br i1 %21, label %40, label %22

22:                                               ; preds = %20
  %23 = icmp eq i32 %13, 0
  br i1 %23, label %40, label %24

24:                                               ; preds = %22
  %25 = icmp eq i32 %15, 0
  br i1 %25, label %40, label %26

26:                                               ; preds = %24
  %27 = icmp ult i32 %17, 2
  br i1 %27, label %40, label %28

28:                                               ; preds = %26
  %29 = shl nuw nsw i32 %9, 9
  store i32 %29, ptr @clussz, align 4, !tbaa !10
  %30 = shl nuw nsw i32 %11, 9
  store i32 %30, ptr @fatoff, align 4, !tbaa !10
  %31 = mul i32 %15, %13
  %32 = add i32 %31, %11
  %33 = shl i32 %32, 9
  store i32 %33, ptr @dataoff, align 4, !tbaa !10
  store i32 %0, ptr @fbase, align 4, !tbaa !10
  br label %34

34:                                               ; preds = %37, %28
  %35 = phi i32 [ 0, %28 ], [ %39, %37 ]
  %36 = icmp eq i32 %35, 16
  br i1 %36, label %40, label %37

37:                                               ; preds = %34
  %38 = getelementptr inbounds nuw [16 x %struct.inode], ptr @fatnodes, i32 0, i32 %35, i32 2
  store i32 0, ptr %38, align 4, !tbaa !16
  %39 = add nuw nsw i32 %35, 1
  br label %34, !llvm.loop !17

40:                                               ; preds = %34, %26, %24, %22, %20, %5, %1
  %41 = phi i32 [ -1, %1 ], [ -1, %26 ], [ -1, %24 ], [ -1, %22 ], [ -1, %20 ], [ -1, %5 ], [ 0, %34 ]
  ret i32 %41
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 65536) i32 @rd16(i32 noundef %0) unnamed_addr #2 {
  %2 = tail call fastcc i32 @rd8(i32 noundef %0) #12
  %3 = add i32 %0, 1
  %4 = tail call fastcc i32 @rd8(i32 noundef %3) #12
  %5 = shl nuw nsw i32 %4, 8
  %6 = or disjoint i32 %5, %2
  ret i32 %6
}

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @rd32(i32 noundef %0) unnamed_addr #2 {
  %2 = tail call fastcc i32 @rd16(i32 noundef %0) #12
  %3 = add i32 %0, 2
  %4 = tail call fastcc i32 @rd16(i32 noundef %3) #12
  %5 = shl nuw i32 %4, 16
  %6 = or disjoint i32 %5, %2
  ret i32 %6
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @fat_busy() local_unnamed_addr #5 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %8, %4 ]
  %3 = icmp eq i32 %2, 16
  br i1 %3, label %9, label %4

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw [16 x %struct.inode], ptr @fatnodes, i32 0, i32 %2, i32 2
  %6 = load i32, ptr %5, align 4, !tbaa !16
  %7 = icmp sgt i32 %6, 0
  %8 = add nuw nsw i32 %2, 1
  br i1 %7, label %9, label %1, !llvm.loop !18

9:                                                ; preds = %4, %1
  %10 = icmp samesign ult i32 %2, 16
  %11 = zext i1 %10 to i32
  ret i32 %11
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
define dso_local void @fat_unmount() local_unnamed_addr #6 {
  store i32 0, ptr @fbase, align 4, !tbaa !10
  store i1 false, ptr @fat_sd, align 4
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @fat_is_sd() local_unnamed_addr #1 {
  %1 = load i1, ptr @fat_sd, align 4
  %2 = zext i1 %1 to i32
  ret i32 %2
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @fat_root() local_unnamed_addr #2 {
  %1 = load i32, ptr @rootclus, align 4, !tbaa !10
  %2 = tail call fastcc ptr @fat_getnode(i32 noundef %1, i32 noundef 0, i32 noundef 1, i32 noundef %1) #12
  ret ptr %2
}

; Function Attrs: minsize nounwind optsize
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
  %12 = load i32, ptr %11, align 4, !tbaa !16
  %13 = icmp sgt i32 %12, 0
  br i1 %13, label %14, label %18

14:                                               ; preds = %9
  %15 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !19
  %17 = icmp eq i32 %16, %3
  br i1 %17, label %24, label %18

18:                                               ; preds = %14, %9
  %19 = icmp eq i32 %12, 0
  %20 = icmp eq ptr %6, null
  %21 = select i1 %19, i1 %20, i1 false
  %22 = select i1 %21, ptr %10, ptr %6
  %23 = add nuw nsw i32 %7, 1
  br label %5, !llvm.loop !20

24:                                               ; preds = %14
  %25 = getelementptr inbounds nuw i8, ptr %10, i32 8
  %26 = add nuw nsw i32 %12, 1
  store i32 %26, ptr %25, align 4, !tbaa !16
  br label %53

27:                                               ; preds = %5
  %28 = icmp eq ptr %6, null
  br i1 %28, label %53, label %29

29:                                               ; preds = %27
  %30 = ptrtoint ptr %6 to i32
  %31 = sub i32 %30, ptrtoint (ptr @fatnodes to i32)
  %32 = sdiv exact i32 %31, 84
  store i32 4007, ptr %6, align 4, !tbaa !3
  %33 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store i32 %3, ptr %33, align 4, !tbaa !19
  %34 = getelementptr inbounds nuw i8, ptr %6, i32 8
  store i32 1, ptr %34, align 4, !tbaa !16
  %35 = icmp eq i32 %2, 0
  %36 = select i1 %35, i16 2, i16 1
  %37 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store i16 %36, ptr %37, align 4, !tbaa !21
  %38 = getelementptr inbounds nuw i8, ptr %6, i32 26
  store i16 1, ptr %38, align 2, !tbaa !22
  br i1 %35, label %48, label %39

39:                                               ; preds = %29, %44
  %40 = phi i32 [ %47, %44 ], [ %0, %29 ]
  %41 = phi i32 [ %46, %44 ], [ 0, %29 ]
  %42 = add i32 %40, -2
  %43 = icmp ult i32 %42, 268435446
  br i1 %43, label %44, label %48

44:                                               ; preds = %39
  %45 = load i32, ptr @clussz, align 4, !tbaa !10
  %46 = add i32 %45, %41
  %47 = tail call fastcc i32 @fat_next(i32 noundef %40) #12
  br label %39, !llvm.loop !23

48:                                               ; preds = %39, %29
  %49 = phi i32 [ %1, %29 ], [ %41, %39 ]
  %50 = getelementptr inbounds nuw i8, ptr %6, i32 28
  store i32 %49, ptr %50, align 4, !tbaa !24
  %51 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %32
  store i32 %0, ptr %51, align 4, !tbaa !25
  %52 = getelementptr inbounds nuw i8, ptr %51, i32 4
  store i32 %49, ptr %52, align 4, !tbaa !27
  br label %53

53:                                               ; preds = %24, %27, %48
  %54 = phi ptr [ %6, %48 ], [ %10, %24 ], [ null, %27 ]
  ret ptr %54
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @fat_put(ptr noundef captures(none) %0) local_unnamed_addr #7 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !16
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  %6 = add nsw i32 %3, -1
  store i32 %6, ptr %2, align 4, !tbaa !16
  br label %7

7:                                                ; preds = %5, %1
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @fat_dup(ptr noundef captures(none) %0) local_unnamed_addr #7 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %3 = load i32, ptr %2, align 4, !tbaa !16
  %4 = add nsw i32 %3, 1
  store i32 %4, ptr %2, align 4, !tbaa !16
  ret void
}

; Function Attrs: minsize nounwind optsize
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
  %13 = load i32, ptr %12, align 4, !tbaa !25
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
  %24 = load i32, ptr %23, align 4, !tbaa !16
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %23, align 4, !tbaa !16
  br label %55

26:                                               ; preds = %16
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #10
  store i32 0, ptr %3, align 4, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #10
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %7) #10
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %8) #10
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
  br i1 %35, label %27, label %36, !llvm.loop !28

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
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #10
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %7) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #10
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
  %7 = load i8, ptr %5, align 1, !tbaa !15
  %8 = load i8, ptr %6, align 1, !tbaa !15
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
  br label %3, !llvm.loop !29

25:                                               ; preds = %3
  ret i32 %20
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @fat_iter(i32 noundef %0, ptr noundef nonnull captures(none) %1, ptr noundef nonnull writeonly captures(none) %2, ptr noundef nonnull captures(none) %3, ptr noundef nonnull writeonly captures(none) %4, ptr noundef nonnull writeonly captures(none) %5, ptr noundef nonnull writeonly captures(none) %6) unnamed_addr #2 {
  %8 = alloca [64 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %8) #10
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 63
  br label %10

10:                                               ; preds = %56, %7
  %11 = phi i32 [ 0, %7 ], [ %57, %56 ]
  br label %12

12:                                               ; preds = %10, %45
  %13 = load i32, ptr %1, align 4, !tbaa !10
  %14 = load i32, ptr @clussz, align 4, !tbaa !10
  %15 = lshr i32 %14, 5
  br label %16

16:                                               ; preds = %23, %12
  %17 = phi i32 [ %0, %12 ], [ %25, %23 ]
  %18 = phi i32 [ %13, %12 ], [ %24, %23 ]
  %19 = add i32 %17, -2
  %20 = icmp ult i32 %19, 268435446
  br i1 %20, label %21, label %155

21:                                               ; preds = %16
  %22 = icmp ult i32 %18, %15
  br i1 %22, label %26, label %23

23:                                               ; preds = %21
  %24 = sub nuw i32 %18, %15
  %25 = tail call fastcc i32 @fat_next(i32 noundef %17) #12
  br label %16, !llvm.loop !30

26:                                               ; preds = %21
  %27 = load i32, ptr @fbase, align 4, !tbaa !10
  %28 = load i32, ptr @dataoff, align 4, !tbaa !10
  %29 = load i32, ptr @clussz, align 4, !tbaa !10
  %30 = mul i32 %29, %19
  %31 = shl nuw nsw i32 %18, 5
  %32 = add i32 %27, %31
  %33 = add i32 %32, %28
  %34 = add i32 %33, %30
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %155, label %36

36:                                               ; preds = %26
  %37 = load i32, ptr %1, align 4, !tbaa !10
  %38 = add i32 %37, 1
  store i32 %38, ptr %1, align 4, !tbaa !10
  %39 = tail call fastcc i32 @rd8(i32 noundef %34) #12
  %40 = trunc nuw i32 %39 to i8
  switch i8 %40, label %41 [
    i8 0, label %155
    i8 -27, label %56
  ], !llvm.loop !31

41:                                               ; preds = %36
  %42 = add i32 %34, 11
  %43 = tail call fastcc i32 @rd8(i32 noundef %42) #12
  %44 = icmp eq i32 %43, 15
  br i1 %44, label %45, label %74

45:                                               ; preds = %41
  %46 = and i32 %39, 31
  %47 = add nsw i32 %46, -1
  %48 = icmp ult i32 %47, 4
  br i1 %48, label %49, label %12

49:                                               ; preds = %45
  %50 = mul nuw nsw i32 %46, 13
  %51 = add nsw i32 %50, -13
  br label %52

52:                                               ; preds = %49, %72
  %53 = phi i32 [ %73, %72 ], [ 0, %49 ]
  %54 = icmp eq i32 %53, 13
  br i1 %54, label %55, label %58

55:                                               ; preds = %52
  store i8 0, ptr %9, align 1, !tbaa !15
  br label %56

56:                                               ; preds = %36, %55, %74
  %57 = phi i32 [ 0, %74 ], [ 1, %55 ], [ 0, %36 ]
  br label %10, !llvm.loop !31

58:                                               ; preds = %52
  %59 = getelementptr inbounds nuw [13 x i32], ptr @fat_iter.slots, i32 0, i32 %53
  %60 = load i32, ptr %59, align 4, !tbaa !10
  %61 = add i32 %60, %34
  %62 = tail call fastcc i32 @rd16(i32 noundef %61) #12
  %63 = add nuw nsw i32 %51, %53
  %64 = icmp ult i32 %63, 63
  br i1 %64, label %65, label %72

65:                                               ; preds = %58
  %66 = trunc nuw i32 %62 to i16
  switch i16 %66, label %67 [
    i16 0, label %69
    i16 -1, label %69
  ]

67:                                               ; preds = %65
  %68 = trunc i32 %62 to i8
  br label %69

69:                                               ; preds = %65, %65, %67
  %70 = phi i8 [ %68, %67 ], [ 0, %65 ], [ 0, %65 ]
  %71 = getelementptr inbounds nuw [64 x i8], ptr %8, i32 0, i32 %63
  store i8 %70, ptr %71, align 1, !tbaa !15
  br label %72

72:                                               ; preds = %69, %58
  %73 = add nuw nsw i32 %53, 1
  br label %52, !llvm.loop !32

74:                                               ; preds = %41
  %75 = and i32 %43, 8
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %77, label %56

77:                                               ; preds = %74, %88
  %78 = phi i32 [ %97, %88 ], [ 0, %74 ]
  %79 = icmp eq i32 %78, 8
  br i1 %79, label %84, label %80

80:                                               ; preds = %77
  %81 = add i32 %78, %34
  %82 = tail call fastcc i32 @rd8(i32 noundef %81) #12
  %83 = icmp eq i32 %82, 32
  br i1 %83, label %84, label %88

84:                                               ; preds = %77, %80
  %85 = add i32 %34, 8
  %86 = tail call fastcc i32 @rd8(i32 noundef %85) #12
  %87 = icmp eq i32 %86, 32
  br i1 %87, label %122, label %99

88:                                               ; preds = %80
  %89 = tail call fastcc i32 @rd8(i32 noundef %81) #12
  %90 = shl nuw i32 %89, 24
  %91 = ashr exact i32 %90, 24
  %92 = add nsw i32 %91, -65
  %93 = icmp ult i32 %92, 26
  %94 = add nuw nsw i32 %89, 32
  %95 = select i1 %93, i32 %94, i32 %89
  %96 = trunc i32 %95 to i8
  %97 = add nuw nsw i32 %78, 1
  %98 = getelementptr inbounds nuw i8, ptr %3, i32 %78
  store i8 %96, ptr %98, align 1, !tbaa !15
  br label %77, !llvm.loop !33

99:                                               ; preds = %84
  %100 = getelementptr inbounds nuw i8, ptr %3, i32 %78
  store i8 46, ptr %100, align 1, !tbaa !15
  %101 = add nuw nsw i32 %78, 3
  br label %102

102:                                              ; preds = %111, %99
  %103 = phi i32 [ %78, %99 ], [ %105, %111 ]
  %104 = phi i32 [ 8, %99 ], [ %121, %111 ]
  %105 = add nuw nsw i32 %103, 1
  %106 = icmp eq i32 %103, %101
  br i1 %106, label %122, label %107

107:                                              ; preds = %102
  %108 = add i32 %104, %34
  %109 = tail call fastcc i32 @rd8(i32 noundef %108) #12
  %110 = icmp eq i32 %109, 32
  br i1 %110, label %122, label %111

111:                                              ; preds = %107
  %112 = tail call fastcc i32 @rd8(i32 noundef %108) #12
  %113 = shl nuw i32 %112, 24
  %114 = ashr exact i32 %113, 24
  %115 = add nsw i32 %114, -65
  %116 = icmp ult i32 %115, 26
  %117 = add nuw nsw i32 %112, 32
  %118 = select i1 %116, i32 %117, i32 %112
  %119 = trunc i32 %118 to i8
  %120 = getelementptr inbounds nuw i8, ptr %3, i32 %105
  store i8 %119, ptr %120, align 1, !tbaa !15
  %121 = add nuw nsw i32 %104, 1
  br label %102, !llvm.loop !34

122:                                              ; preds = %107, %102, %84
  %123 = phi i32 [ %78, %84 ], [ %105, %102 ], [ %105, %107 ]
  %124 = getelementptr inbounds i8, ptr %3, i32 %123
  store i8 0, ptr %124, align 1, !tbaa !15
  %125 = icmp eq i32 %11, 0
  br i1 %125, label %134, label %126

126:                                              ; preds = %122, %129
  %127 = phi i32 [ %133, %129 ], [ 0, %122 ]
  %128 = icmp eq i32 %127, 64
  br i1 %128, label %142, label %129

129:                                              ; preds = %126
  %130 = getelementptr inbounds nuw [64 x i8], ptr %8, i32 0, i32 %127
  %131 = load i8, ptr %130, align 1, !tbaa !15
  %132 = getelementptr inbounds nuw i8, ptr %2, i32 %127
  store i8 %131, ptr %132, align 1, !tbaa !15
  %133 = add nuw nsw i32 %127, 1
  br label %126, !llvm.loop !35

134:                                              ; preds = %122, %139
  %135 = phi i32 [ %141, %139 ], [ 0, %122 ]
  %136 = getelementptr inbounds nuw i8, ptr %3, i32 %135
  %137 = load i8, ptr %136, align 1, !tbaa !15
  %138 = icmp eq i8 %137, 0
  br i1 %138, label %142, label %139

139:                                              ; preds = %134
  %140 = getelementptr inbounds nuw i8, ptr %2, i32 %135
  store i8 %137, ptr %140, align 1, !tbaa !15
  %141 = add nuw nsw i32 %135, 1
  br label %134, !llvm.loop !36

142:                                              ; preds = %126, %134
  %143 = phi i32 [ %135, %134 ], [ 63, %126 ]
  %144 = getelementptr inbounds nuw i8, ptr %2, i32 %143
  store i8 0, ptr %144, align 1, !tbaa !15
  %145 = add i32 %34, 20
  %146 = tail call fastcc i32 @rd16(i32 noundef %145) #12
  %147 = shl nuw i32 %146, 16
  %148 = add i32 %34, 26
  %149 = tail call fastcc i32 @rd16(i32 noundef %148) #12
  %150 = or disjoint i32 %147, %149
  store i32 %150, ptr %4, align 4, !tbaa !10
  %151 = add i32 %34, 28
  %152 = tail call fastcc i32 @rd32(i32 noundef %151) #12
  store i32 %152, ptr %5, align 4, !tbaa !10
  %153 = lshr i32 %43, 4
  %154 = and i32 %153, 1
  store i32 %154, ptr %6, align 4, !tbaa !10
  br label %155

155:                                              ; preds = %26, %36, %16, %142
  %156 = phi i32 [ 1, %142 ], [ 0, %16 ], [ 0, %36 ], [ 0, %26 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %8) #10
  ret i32 %156
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @fat_walk(ptr noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  %3 = alloca [64 x i8], align 1
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %5 = load i32, ptr %4, align 4, !tbaa !16
  %6 = add nsw i32 %5, 1
  store i32 %6, ptr %4, align 4, !tbaa !16
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %3) #10
  br label %7

7:                                                ; preds = %50, %2
  %8 = phi ptr [ %1, %2 ], [ %20, %50 ]
  %9 = phi ptr [ %0, %2 ], [ %44, %50 ]
  %10 = load i8, ptr %8, align 1, !tbaa !15
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
  %17 = load i8, ptr %16, align 1, !tbaa !15
  br label %12, !llvm.loop !37

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
  store i8 %19, ptr %30, align 1, !tbaa !15
  %31 = load i8, ptr %28, align 1, !tbaa !15
  br label %18, !llvm.loop !38

32:                                               ; preds = %23, %18
  %33 = getelementptr inbounds nuw [64 x i8], ptr %3, i32 0, i32 %21
  store i8 0, ptr %33, align 1, !tbaa !15
  %34 = getelementptr inbounds nuw i8, ptr %9, i32 20
  %35 = load i16, ptr %34, align 4, !tbaa !21
  %36 = icmp eq i16 %35, 1
  br i1 %36, label %43, label %37

37:                                               ; preds = %32
  %38 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %39 = load i32, ptr %38, align 4, !tbaa !16
  %40 = icmp sgt i32 %39, 0
  br i1 %40, label %41, label %52

41:                                               ; preds = %37
  %42 = add nsw i32 %39, -1
  store i32 %42, ptr %38, align 4, !tbaa !16
  br label %52

43:                                               ; preds = %32
  %44 = call ptr @fat_lookup(ptr noundef nonnull %9, ptr noundef nonnull %3) #12
  %45 = getelementptr inbounds nuw i8, ptr %9, i32 8
  %46 = load i32, ptr %45, align 4, !tbaa !16
  %47 = icmp sgt i32 %46, 0
  br i1 %47, label %48, label %50

48:                                               ; preds = %43
  %49 = add nsw i32 %46, -1
  store i32 %49, ptr %45, align 4, !tbaa !16
  br label %50

50:                                               ; preds = %48, %43
  %51 = icmp eq ptr %44, null
  br i1 %51, label %52, label %7, !llvm.loop !39

52:                                               ; preds = %7, %50, %12, %41, %37
  %53 = phi ptr [ null, %37 ], [ null, %41 ], [ %9, %12 ], [ %9, %7 ], [ null, %50 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %3) #10
  ret ptr %53
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @fat_readi(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #2 {
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
  %16 = load i16, ptr %15, align 4, !tbaa !21
  %17 = icmp eq i16 %16, 1
  br i1 %17, label %18, label %74

18:                                               ; preds = %4
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #10
  %19 = lshr i32 %3, 6
  %20 = lshr i32 %2, 6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #10
  store i32 0, ptr %6, align 4, !tbaa !10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %8) #10
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %9) #10
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #10
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %11) #10
  %21 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %14
  %22 = getelementptr inbounds nuw i8, ptr %5, i32 2
  br label %23

23:                                               ; preds = %62, %18
  %24 = phi i32 [ %33, %62 ], [ 0, %18 ]
  %25 = phi i32 [ %67, %62 ], [ 0, %18 ]
  %26 = icmp eq i32 %25, %19
  br i1 %26, label %71, label %27

27:                                               ; preds = %23, %32
  %28 = phi i32 [ %33, %32 ], [ %24, %23 ]
  %29 = load i32, ptr %21, align 4, !tbaa !25
  %30 = call fastcc i32 @fat_iter(i32 noundef %29, ptr noundef %6, ptr noundef %10, ptr noundef %11, ptr noundef %7, ptr noundef %8, ptr noundef %9) #12
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %71, label %32

32:                                               ; preds = %27
  %33 = add i32 %28, 1
  %34 = icmp ult i32 %28, %20
  br i1 %34, label %27, label %35, !llvm.loop !40

35:                                               ; preds = %32, %35
  %36 = phi i32 [ %40, %35 ], [ 0, %32 ]
  %37 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %36
  %38 = load i8, ptr %37, align 1, !tbaa !15
  %39 = icmp eq i8 %38, 0
  %40 = add i32 %36, 1
  br i1 %39, label %41, label %35, !llvm.loop !41

41:                                               ; preds = %35
  %42 = load i32, ptr %7, align 4, !tbaa !10
  %43 = icmp eq i32 %42, 0
  %44 = trunc i32 %42 to i16
  %45 = select i1 %43, i16 -1, i16 %44
  store i16 %45, ptr %5, align 2, !tbaa !42
  br label %46

46:                                               ; preds = %52, %41
  %47 = phi i32 [ 0, %41 ], [ %54, %52 ]
  %48 = icmp eq i32 %47, 62
  br i1 %48, label %49, label %52

49:                                               ; preds = %46
  %50 = icmp ult i32 %36, 63
  %51 = select i1 %50, ptr %10, ptr %11
  br label %55

52:                                               ; preds = %46
  %53 = getelementptr inbounds nuw [62 x i8], ptr %22, i32 0, i32 %47
  store i8 0, ptr %53, align 1, !tbaa !15
  %54 = add nuw nsw i32 %47, 1
  br label %46, !llvm.loop !44

55:                                               ; preds = %49, %68
  %56 = phi i32 [ %70, %68 ], [ 0, %49 ]
  %57 = icmp eq i32 %56, 62
  br i1 %57, label %62, label %58

58:                                               ; preds = %55
  %59 = getelementptr inbounds nuw i8, ptr %51, i32 %56
  %60 = load i8, ptr %59, align 1, !tbaa !15
  %61 = icmp eq i8 %60, 0
  br i1 %61, label %62, label %68

62:                                               ; preds = %55, %58
  %63 = shl nuw i32 %25, 6
  %64 = add i32 %63, %1
  %65 = inttoptr i32 %64 to ptr
  %66 = call ptr @memmove(ptr noundef %65, ptr noundef nonnull %5, i32 noundef 64) #11
  %67 = add nuw nsw i32 %25, 1
  br label %23, !llvm.loop !40

68:                                               ; preds = %58
  %69 = getelementptr inbounds nuw [62 x i8], ptr %22, i32 0, i32 %56
  store i8 %60, ptr %69, align 1, !tbaa !15
  %70 = add nuw nsw i32 %56, 1
  br label %55, !llvm.loop !45

71:                                               ; preds = %23, %27
  %72 = phi i32 [ %25, %27 ], [ %19, %23 ]
  %73 = shl i32 %72, 6
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %11) #10
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %9) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %8) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #10
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #10
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #10
  br label %154

74:                                               ; preds = %4
  %75 = getelementptr inbounds [16 x %struct.fatmeta], ptr @fatmeta, i32 0, i32 %14
  %76 = getelementptr inbounds nuw i8, ptr %75, i32 4
  %77 = load i32, ptr %76, align 4, !tbaa !27
  %78 = icmp ult i32 %2, %77
  br i1 %78, label %79, label %154

79:                                               ; preds = %74
  %80 = load i32, ptr %75, align 4, !tbaa !25
  %81 = load i32, ptr @clussz, align 4, !tbaa !10
  %82 = udiv i32 %2, %81
  br label %83

83:                                               ; preds = %90, %79
  %84 = phi i32 [ %80, %79 ], [ %92, %90 ]
  %85 = phi i32 [ %82, %79 ], [ %91, %90 ]
  %86 = icmp ne i32 %85, 0
  %87 = add i32 %84, -2
  %88 = icmp ult i32 %87, 268435446
  %89 = select i1 %86, i1 %88, i1 false
  br i1 %89, label %90, label %93

90:                                               ; preds = %83
  %91 = add i32 %85, -1
  %92 = tail call fastcc i32 @fat_next(i32 noundef %84) #12
  br label %83, !llvm.loop !46

93:                                               ; preds = %83
  %94 = add i32 %3, %2
  %95 = icmp ugt i32 %94, %77
  %96 = sub nuw i32 %77, %2
  %97 = select i1 %95, i32 %96, i32 %3
  %98 = load i32, ptr @clussz, align 4, !tbaa !10
  %99 = urem i32 %2, %98
  br label %100

100:                                              ; preds = %151, %93
  %101 = phi i32 [ %84, %93 ], [ %153, %151 ]
  %102 = phi i32 [ 0, %93 ], [ %152, %151 ]
  %103 = phi i32 [ %99, %93 ], [ 0, %151 ]
  %104 = icmp ult i32 %102, %97
  %105 = add i32 %101, -2
  %106 = icmp ult i32 %105, 268435446
  %107 = select i1 %104, i1 %106, i1 false
  br i1 %107, label %108, label %154

108:                                              ; preds = %100
  %109 = load i32, ptr @clussz, align 4, !tbaa !10
  %110 = sub nsw i32 %109, %103
  %111 = sub nuw i32 %97, %102
  %112 = tail call i32 @llvm.umin.i32(i32 %110, i32 %111)
  %113 = load i1, ptr @fat_sd, align 4
  br i1 %113, label %114, label %140

114:                                              ; preds = %108
  %115 = load i32, ptr @fbase, align 4, !tbaa !10
  %116 = load i32, ptr @dataoff, align 4, !tbaa !10
  %117 = mul i32 %109, %105
  %118 = add i32 %103, -134217728
  %119 = add i32 %118, %117
  %120 = add i32 %119, %115
  %121 = add i32 %120, %116
  %122 = add i32 %102, %1
  br label %123

123:                                              ; preds = %128, %114
  %124 = phi i32 [ %121, %114 ], [ %137, %128 ]
  %125 = phi i32 [ %112, %114 ], [ %139, %128 ]
  %126 = phi i32 [ %122, %114 ], [ %138, %128 ]
  %127 = icmp eq i32 %125, 0
  br i1 %127, label %151, label %128

128:                                              ; preds = %123
  %129 = and i32 %124, 511
  %130 = sub nuw nsw i32 512, %129
  %131 = tail call i32 @llvm.umin.i32(i32 %130, i32 %125)
  %132 = inttoptr i32 %126 to ptr
  %133 = lshr i32 %124, 9
  %134 = tail call fastcc ptr @sdsec(i32 noundef %133) #12
  %135 = getelementptr inbounds nuw i8, ptr %134, i32 %129
  %136 = tail call ptr @memmove(ptr noundef %132, ptr noundef nonnull %135, i32 noundef %131) #11
  %137 = add i32 %131, %124
  %138 = add i32 %131, %126
  %139 = sub i32 %125, %131
  br label %123, !llvm.loop !47

140:                                              ; preds = %108
  %141 = add i32 %102, %1
  %142 = inttoptr i32 %141 to ptr
  %143 = load i32, ptr @fbase, align 4, !tbaa !10
  %144 = load i32, ptr @dataoff, align 4, !tbaa !10
  %145 = mul i32 %109, %105
  %146 = add i32 %145, %103
  %147 = add i32 %146, %143
  %148 = add i32 %147, %144
  %149 = inttoptr i32 %148 to ptr
  %150 = tail call ptr @memmove(ptr noundef %142, ptr noundef %149, i32 noundef %112) #11
  br label %151

151:                                              ; preds = %123, %140
  %152 = add i32 %112, %102
  %153 = tail call fastcc i32 @fat_next(i32 noundef %101) #12
  br label %100, !llvm.loop !48

154:                                              ; preds = %100, %74, %71
  %155 = phi i32 [ %73, %71 ], [ 0, %74 ], [ %102, %100 ]
  ret i32 %155
}

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 268435456) i32 @fat_next(i32 noundef range(i32 2, 268435448) %0) unnamed_addr #2 {
  %2 = load i32, ptr @fbase, align 4, !tbaa !10
  %3 = load i32, ptr @fatoff, align 4, !tbaa !10
  %4 = shl nuw nsw i32 %0, 2
  %5 = add i32 %2, %4
  %6 = add i32 %5, %3
  %7 = tail call fastcc i32 @rd32(i32 noundef %6) #12
  %8 = and i32 %7, 268435455
  ret i32 %8
}

; Function Attrs: minsize nounwind optsize
define internal fastcc nonnull ptr @sdsec(i32 noundef range(i32 0, 8388608) %0) unnamed_addr #2 {
  %2 = load i32, ptr @sdpart, align 4, !tbaa !10
  %3 = add i32 %2, %0
  %4 = add i32 %3, 1
  br label %5

5:                                                ; preds = %12, %1
  %6 = phi i32 [ 0, %1 ], [ %13, %12 ]
  %7 = icmp eq i32 %6, 2
  br i1 %7, label %16, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw [2 x i32], ptr @sdtag, i32 0, i32 %6
  %10 = load i32, ptr %9, align 4, !tbaa !10
  %11 = icmp eq i32 %10, %4
  br i1 %11, label %14, label %12

12:                                               ; preds = %8
  %13 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !49

14:                                               ; preds = %8
  %15 = getelementptr inbounds nuw [2 x [512 x i8]], ptr @sdcache, i32 0, i32 %6
  br label %26

16:                                               ; preds = %5
  %17 = load i32, ptr @sdvict, align 4, !tbaa !10
  %18 = and i32 %17, 1
  %19 = xor i32 %18, 1
  store i32 %19, ptr @sdvict, align 4, !tbaa !10
  %20 = getelementptr inbounds nuw [2 x i32], ptr @sdtag, i32 0, i32 %17
  store i32 0, ptr %20, align 4, !tbaa !10
  %21 = getelementptr inbounds nuw [2 x [512 x i8]], ptr @sdcache, i32 0, i32 %17
  %22 = ptrtoint ptr %21 to i32
  %23 = tail call i32 @kflash_sd(i32 noundef 4, i32 noundef %3, i32 noundef %22) #11
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %26, label %25

25:                                               ; preds = %16
  store i32 %4, ptr %20, align 4, !tbaa !10
  br label %26

26:                                               ; preds = %14, %25, %16
  %27 = phi ptr [ %15, %14 ], [ %21, %16 ], [ %21, %25 ]
  ret ptr %27
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite)
define dso_local void @fat_stati(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) initializes((0, 16)) %1) local_unnamed_addr #7 {
  store i32 4007, ptr %1, align 4, !tbaa !50
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %4 = load i32, ptr %3, align 4, !tbaa !19
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %4, ptr %5, align 4, !tbaa !53
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %7 = load i16, ptr %6, align 4, !tbaa !21
  %8 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i16 %7, ptr %8, align 4, !tbaa !54
  %9 = getelementptr inbounds nuw i8, ptr %1, i32 10
  store i16 1, ptr %9, align 2, !tbaa !55
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 28
  %11 = load i32, ptr %10, align 4, !tbaa !24
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %11, ptr %12, align 4, !tbaa !56
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #9

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { nounwind }
attributes #11 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }

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
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = distinct !{!14, !12, !13}
!15 = !{!6, !6, i64 0}
!16 = !{!4, !5, i64 8}
!17 = distinct !{!17, !12, !13}
!18 = distinct !{!18, !12, !13}
!19 = !{!4, !5, i64 4}
!20 = distinct !{!20, !12, !13}
!21 = !{!4, !9, i64 20}
!22 = !{!4, !9, i64 26}
!23 = distinct !{!23, !12, !13}
!24 = !{!4, !5, i64 28}
!25 = !{!26, !5, i64 0}
!26 = !{!"fatmeta", !5, i64 0, !5, i64 4}
!27 = !{!26, !5, i64 4}
!28 = distinct !{!28, !12, !13}
!29 = distinct !{!29, !13}
!30 = distinct !{!30, !12, !13}
!31 = distinct !{!31, !13}
!32 = distinct !{!32, !12, !13}
!33 = distinct !{!33, !12, !13}
!34 = distinct !{!34, !12, !13}
!35 = distinct !{!35, !12, !13}
!36 = distinct !{!36, !12, !13}
!37 = distinct !{!37, !12, !13}
!38 = distinct !{!38, !12, !13}
!39 = distinct !{!39, !12, !13}
!40 = distinct !{!40, !12, !13}
!41 = distinct !{!41, !12, !13}
!42 = !{!43, !9, i64 0}
!43 = !{!"dirent", !9, i64 0, !6, i64 2}
!44 = distinct !{!44, !12, !13}
!45 = distinct !{!45, !12, !13}
!46 = distinct !{!46, !12, !13}
!47 = distinct !{!47, !12, !13}
!48 = distinct !{!48, !12, !13}
!49 = distinct !{!49, !12, !13}
!50 = !{!51, !5, i64 0}
!51 = !{!"stat", !5, i64 0, !5, i64 4, !9, i64 8, !9, i64 10, !52, i64 12}
!52 = !{!"long", !6, i64 0}
!53 = !{!51, !5, i64 4}
!54 = !{!51, !9, i64 8}
!55 = !{!51, !9, i64 10}
!56 = !{!51, !52, i64 12}
