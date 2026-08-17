; ModuleID = 'kflash.c'
source_filename = "kflash.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fsslot = dso_local local_unnamed_addr global i32 0, align 4
@dma_disksize = external dso_local local_unnamed_addr global i32, align 4
@fs_gen = internal unnamed_addr global i32 0, align 4
@fs_dirty = external dso_local local_unnamed_addr global i32, align 4
@kflash_arm = dso_local local_unnamed_addr global i32 0, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define dso_local i32 @kflash_slot_gen() local_unnamed_addr #0 {
  %1 = load i32, ptr @fsslot, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %15, label %3

3:                                                ; preds = %0
  %4 = inttoptr i32 %1 to ptr
  %5 = load i32, ptr %4, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 1397116228
  br i1 %6, label %7, label %15

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %9 = load i32, ptr %8, align 4, !tbaa !3
  %10 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %11 = icmp eq i32 %9, %10
  br i1 %11, label %12, label %15

12:                                               ; preds = %7
  %13 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %14 = load i32, ptr %13, align 4, !tbaa !3
  br label %15

15:                                               ; preds = %12, %7, %3, %0
  %16 = phi i32 [ 0, %0 ], [ %14, %12 ], [ 0, %7 ], [ 0, %3 ]
  ret i32 %16
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: read, inaccessiblemem: none)
define dso_local void @kflash_init() local_unnamed_addr #2 {
  %1 = tail call i32 @kflash_slot_gen() #4
  store i32 %1, ptr @fs_gen, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kflash_cal(ptr noundef %0) local_unnamed_addr #3 {
  %2 = alloca [256 x i8], align 1
  store volatile i32 1, ptr %0, align 4, !tbaa !3
  tail call fastcc void @flash_exit_xip() #4
  store volatile i32 2, ptr %0, align 4, !tbaa !3
  %3 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %4 = or i32 %3, 5
  store volatile i32 %4, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %5 = tail call fastcc i32 @qmi_xfer(i32 noundef 159) #4
  %6 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %7 = shl nuw nsw i32 %6, 16
  %8 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %9 = shl nuw nsw i32 %8, 8
  %10 = or disjoint i32 %9, %7
  %11 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %12 = or disjoint i32 %10, %11
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 4
  store volatile i32 %12, ptr %13, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #4
  store volatile i32 3, ptr %0, align 4, !tbaa !3
  %14 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %15 = or i32 %14, 5
  store volatile i32 %15, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %16 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #4
  %17 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %18 = getelementptr inbounds nuw i8, ptr %0, i32 8
  store volatile i32 %17, ptr %18, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #4
  store volatile i32 4, ptr %0, align 4, !tbaa !3
  tail call fastcc void @flash_wren() #4
  %19 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %20 = or i32 %19, 5
  store volatile i32 %20, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %21 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #4
  %22 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %23 = getelementptr inbounds nuw i8, ptr %0, i32 12
  store volatile i32 %22, ptr %23, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #4
  store volatile i32 5, ptr %0, align 4, !tbaa !3
  %24 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %25 = or i32 %24, 5
  store volatile i32 %25, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %26 = tail call fastcc i32 @qmi_xfer(i32 noundef 3) #4
  %27 = tail call fastcc i32 @qmi_xfer(i32 noundef 19) #4
  %28 = tail call fastcc i32 @qmi_xfer(i32 noundef 4864) #4
  %29 = tail call fastcc i32 @qmi_xfer(i32 noundef 1245184) #4
  %30 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %31 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %32 = shl nuw nsw i32 %31, 8
  %33 = or disjoint i32 %32, %30
  %34 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %35 = shl nuw nsw i32 %34, 16
  %36 = or disjoint i32 %33, %35
  %37 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %38 = shl nuw i32 %37, 24
  %39 = or disjoint i32 %36, %38
  tail call fastcc void @qmi_end() #4
  %40 = getelementptr inbounds nuw i8, ptr %0, i32 16
  store volatile i32 %39, ptr %40, align 4, !tbaa !3
  store volatile i32 6, ptr %0, align 4, !tbaa !3
  tail call fastcc void @flash_erase4k(i32 noundef 1245184) #4
  %41 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %42 = or i32 %41, 5
  store volatile i32 %42, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %43 = tail call fastcc i32 @qmi_xfer(i32 noundef 3) #4
  %44 = tail call fastcc i32 @qmi_xfer(i32 noundef 19) #4
  %45 = tail call fastcc i32 @qmi_xfer(i32 noundef 4864) #4
  %46 = tail call fastcc i32 @qmi_xfer(i32 noundef 1245184) #4
  %47 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %48 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %49 = shl nuw nsw i32 %48, 8
  %50 = or disjoint i32 %49, %47
  %51 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %52 = shl nuw nsw i32 %51, 16
  %53 = or disjoint i32 %50, %52
  %54 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %55 = shl nuw i32 %54, 24
  %56 = or disjoint i32 %53, %55
  tail call fastcc void @qmi_end() #4
  %57 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store volatile i32 %56, ptr %57, align 4, !tbaa !3
  store volatile i32 7, ptr %0, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %2) #5
  br label %58

58:                                               ; preds = %82, %1
  %59 = phi i32 [ 0, %1 ], [ %86, %82 ]
  %60 = icmp eq i32 %59, 256
  br i1 %60, label %61, label %82

61:                                               ; preds = %58
  call fastcc void @flash_prog_page(i32 noundef 1245184, ptr noundef nonnull %2) #4
  %62 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %63 = or i32 %62, 5
  store volatile i32 %63, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %64 = call fastcc i32 @qmi_xfer(i32 noundef 3) #4
  %65 = call fastcc i32 @qmi_xfer(i32 noundef 19) #4
  %66 = call fastcc i32 @qmi_xfer(i32 noundef 4864) #4
  %67 = call fastcc i32 @qmi_xfer(i32 noundef 1245184) #4
  %68 = call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %69 = call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %70 = shl nuw nsw i32 %69, 8
  %71 = or disjoint i32 %70, %68
  %72 = call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %73 = shl nuw nsw i32 %72, 16
  %74 = or disjoint i32 %71, %73
  %75 = call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %76 = shl nuw i32 %75, 24
  %77 = or disjoint i32 %74, %76
  call fastcc void @qmi_end() #4
  %78 = getelementptr inbounds nuw i8, ptr %0, i32 24
  store volatile i32 %77, ptr %78, align 4, !tbaa !3
  store volatile i32 8, ptr %0, align 4, !tbaa !3
  %79 = load volatile i32, ptr inttoptr (i32 269680640 to ptr), align 65536, !tbaa !3
  %80 = getelementptr inbounds nuw i8, ptr %0, i32 28
  store volatile i32 %79, ptr %80, align 4, !tbaa !3
  %81 = getelementptr inbounds nuw i8, ptr %0, i32 32
  store volatile i32 1, ptr %81, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %2) #5
  ret void

82:                                               ; preds = %58
  %83 = trunc nuw i32 %59 to i8
  %84 = add i8 %83, -64
  %85 = getelementptr inbounds nuw [256 x i8], ptr %2, i32 0, i32 %59
  store i8 %84, ptr %85, align 1, !tbaa !7
  %86 = add nuw nsw i32 %59, 1
  br label %58, !llvm.loop !8
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_exit_xip() unnamed_addr #3 {
  %1 = load volatile i32, ptr inttoptr (i32 1074003976 to ptr), align 8, !tbaa !3
  %2 = load volatile i32, ptr inttoptr (i32 1074003980 to ptr), align 4, !tbaa !3
  %3 = load volatile i32, ptr inttoptr (i32 1074003984 to ptr), align 16, !tbaa !3
  %4 = load volatile i32, ptr inttoptr (i32 1074003988 to ptr), align 4, !tbaa !3
  store volatile i32 32768, ptr inttoptr (i32 1073938468 to ptr), align 4, !tbaa !3
  store volatile i32 32768, ptr inttoptr (i32 1073938476 to ptr), align 4, !tbaa !3
  store volatile i32 32768, ptr inttoptr (i32 1073938484 to ptr), align 4, !tbaa !3
  store volatile i32 32768, ptr inttoptr (i32 1073938492 to ptr), align 4, !tbaa !3
  store volatile i32 61440, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 68, ptr inttoptr (i32 1074003976 to ptr), align 8, !tbaa !3
  store volatile i32 68, ptr inttoptr (i32 1074003980 to ptr), align 4, !tbaa !3
  store volatile i32 68, ptr inttoptr (i32 1074003984 to ptr), align 16, !tbaa !3
  store volatile i32 68, ptr inttoptr (i32 1074003988 to ptr), align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 32) #4
  store volatile i32 57344, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003976 to ptr), align 8, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003980 to ptr), align 4, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003984 to ptr), align 16, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003988 to ptr), align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 32) #4
  store volatile i32 61440, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 57344, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 61440, ptr inttoptr (i32 1073938468 to ptr), align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 16) #4
  store volatile i32 0, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 0, ptr inttoptr (i32 1073938452 to ptr), align 4, !tbaa !3
  store volatile i32 0, ptr inttoptr (i32 1073938468 to ptr), align 4, !tbaa !3
  store volatile i32 0, ptr inttoptr (i32 1073938476 to ptr), align 4, !tbaa !3
  store volatile i32 0, ptr inttoptr (i32 1073938484 to ptr), align 4, !tbaa !3
  store volatile i32 0, ptr inttoptr (i32 1073938492 to ptr), align 4, !tbaa !3
  store volatile i32 %1, ptr inttoptr (i32 1074003976 to ptr), align 8, !tbaa !3
  store volatile i32 %2, ptr inttoptr (i32 1074003980 to ptr), align 4, !tbaa !3
  store volatile i32 %3, ptr inttoptr (i32 1074003984 to ptr), align 16, !tbaa !3
  store volatile i32 %4, ptr inttoptr (i32 1074003988 to ptr), align 4, !tbaa !3
  %5 = load volatile i32, ptr inttoptr (i32 1074593808 to ptr), align 16, !tbaa !3
  %6 = or i32 %5, 4096
  store volatile i32 %6, ptr inttoptr (i32 1074593808 to ptr), align 16, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc range(i32 0, 256) i32 @qmi_xfer(i32 noundef %0) unnamed_addr #3 {
  %2 = and i32 %0, 255
  store volatile i32 %2, ptr inttoptr (i32 1074593796 to ptr), align 4, !tbaa !3
  br label %3

3:                                                ; preds = %3, %1
  %4 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %5 = and i32 %4, 65536
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !11

7:                                                ; preds = %3
  %8 = load volatile i32, ptr inttoptr (i32 1074593800 to ptr), align 8, !tbaa !3
  %9 = and i32 %8, 255
  ret i32 %9
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @qmi_end() unnamed_addr #3 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = and i32 %1, -5
  store volatile i32 %2, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  br label %3

3:                                                ; preds = %3, %0
  %4 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %5 = and i32 %4, 2
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !12

7:                                                ; preds = %3
  %8 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %9 = and i32 %8, -2
  store volatile i32 %9, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_wren() unnamed_addr #3 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = or i32 %1, 5
  store volatile i32 %2, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = tail call fastcc i32 @qmi_xfer(i32 noundef 6) #4
  tail call fastcc void @qmi_end() #4
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_erase4k(i32 noundef %0) unnamed_addr #3 {
  %2 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %1
  tail call fastcc void @arm_request(i32 noundef 1, i32 noundef %0, i32 noundef 0) #4
  br label %14

5:                                                ; preds = %1
  tail call fastcc void @flash_wren() #4
  %6 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %7 = or i32 %6, 5
  store volatile i32 %7, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %8 = tail call fastcc i32 @qmi_xfer(i32 noundef 32) #4
  %9 = lshr i32 %0, 16
  %10 = tail call fastcc i32 @qmi_xfer(i32 noundef %9) #4
  %11 = lshr i32 %0, 8
  %12 = tail call fastcc i32 @qmi_xfer(i32 noundef %11) #4
  %13 = tail call fastcc i32 @qmi_xfer(i32 noundef %0) #4
  tail call fastcc void @qmi_end() #4
  tail call fastcc void @flash_wait_wip() #4
  br label %14

14:                                               ; preds = %5, %4
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_prog_page(i32 noundef %0, ptr noundef %1) unnamed_addr #3 {
  %3 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %7, label %5

5:                                                ; preds = %2
  %6 = ptrtoint ptr %1 to i32
  tail call fastcc void @arm_request(i32 noundef 2, i32 noundef %0, i32 noundef %6) #4
  br label %26

7:                                                ; preds = %2
  tail call fastcc void @flash_wren() #4
  %8 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %9 = or i32 %8, 5
  store volatile i32 %9, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %10 = tail call fastcc i32 @qmi_xfer(i32 noundef 2) #4
  %11 = lshr i32 %0, 16
  %12 = tail call fastcc i32 @qmi_xfer(i32 noundef %11) #4
  %13 = lshr i32 %0, 8
  %14 = tail call fastcc i32 @qmi_xfer(i32 noundef %13) #4
  %15 = tail call fastcc i32 @qmi_xfer(i32 noundef %0) #4
  br label %16

16:                                               ; preds = %20, %7
  %17 = phi i32 [ 0, %7 ], [ %25, %20 ]
  %18 = icmp eq i32 %17, 256
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  tail call fastcc void @qmi_end() #4
  tail call fastcc void @flash_wait_wip() #4
  br label %26

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %1, i32 %17
  %22 = load i8, ptr %21, align 1, !tbaa !7
  %23 = zext i8 %22 to i32
  %24 = tail call fastcc i32 @qmi_xfer(i32 noundef %23) #4
  %25 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !13

26:                                               ; preds = %19, %5
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 1) i32 @kflash_sync() local_unnamed_addr #3 {
  %1 = alloca [64 x i32], align 4
  %2 = load i32, ptr @fsslot, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %73, label %4

4:                                                ; preds = %0
  %5 = add i32 %2, -268435456
  %6 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %7 = lshr i32 %6, 12
  %8 = tail call i32 @kflash_slot_gen() #4
  %9 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %10 = icmp eq i32 %8, %9
  %11 = icmp ne i32 %9, 0
  %12 = and i1 %10, %11
  %13 = load i32, ptr @fs_dirty, align 4
  %14 = icmp eq i32 %13, 0
  %15 = select i1 %12, i1 %14, i1 false
  br i1 %15, label %73, label %16

16:                                               ; preds = %4
  %17 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  tail call fastcc void @flash_exit_xip() #4
  br label %20

20:                                               ; preds = %19, %16
  tail call fastcc void @flash_erase4k(i32 noundef %5) #4
  %21 = add i32 %2, -268431360
  br label %22

22:                                               ; preds = %45, %20
  %23 = phi i32 [ 0, %20 ], [ %46, %45 ]
  %24 = icmp eq i32 %23, %7
  br i1 %24, label %25, label %26

25:                                               ; preds = %22
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %1) #5
  br label %47

26:                                               ; preds = %22
  br i1 %12, label %27, label %32

27:                                               ; preds = %26
  %28 = load i32, ptr @fs_dirty, align 4, !tbaa !3
  %29 = shl nuw i32 1, %23
  %30 = and i32 %28, %29
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %45, label %32

32:                                               ; preds = %27, %26
  %33 = shl nuw i32 %23, 12
  %34 = add i32 %21, %33
  %35 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %36 = add i32 %35, %33
  %37 = inttoptr i32 %36 to ptr
  tail call fastcc void @flash_erase4k(i32 noundef %34) #4
  br label %38

38:                                               ; preds = %41, %32
  %39 = phi i32 [ 0, %32 ], [ %44, %41 ]
  %40 = icmp samesign ult i32 %39, 4096
  br i1 %40, label %41, label %45

41:                                               ; preds = %38
  %42 = add i32 %39, %34
  %43 = getelementptr inbounds nuw i8, ptr %37, i32 %39
  tail call fastcc void @flash_prog_page(i32 noundef %42, ptr noundef %43) #4
  %44 = add nuw nsw i32 %39, 256
  br label %38, !llvm.loop !14

45:                                               ; preds = %38, %27
  %46 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !15

47:                                               ; preds = %70, %25
  %48 = phi i32 [ 0, %25 ], [ %72, %70 ]
  %49 = icmp eq i32 %48, 64
  br i1 %49, label %50, label %70

50:                                               ; preds = %47
  store i32 1397116228, ptr %1, align 4, !tbaa !3
  %51 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %52 = add i32 %51, 1
  %53 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %52, ptr %53, align 4, !tbaa !3
  %54 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %55 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i32 %54, ptr %55, align 4, !tbaa !3
  %56 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %57 = inttoptr i32 %56 to ptr
  %58 = lshr i32 %54, 2
  br label %59

59:                                               ; preds = %63, %50
  %60 = phi i32 [ 0, %50 ], [ %66, %63 ]
  %61 = phi i32 [ 0, %50 ], [ %67, %63 ]
  %62 = icmp eq i32 %61, %58
  br i1 %62, label %68, label %63

63:                                               ; preds = %59
  %64 = getelementptr inbounds nuw i32, ptr %57, i32 %61
  %65 = load i32, ptr %64, align 4, !tbaa !3
  %66 = add i32 %65, %60
  %67 = add nuw nsw i32 %61, 1
  br label %59, !llvm.loop !16

68:                                               ; preds = %59
  %69 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %60, ptr %69, align 4, !tbaa !3
  call fastcc void @flash_prog_page(i32 noundef %5, ptr noundef nonnull %1) #4
  store i32 %52, ptr @fs_gen, align 4, !tbaa !3
  store i32 0, ptr @fs_dirty, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %1) #5
  br label %73

70:                                               ; preds = %47
  %71 = getelementptr inbounds nuw [64 x i32], ptr %1, i32 0, i32 %48
  store i32 -1, ptr %71, align 4, !tbaa !3
  %72 = add nuw nsw i32 %48, 1
  br label %47, !llvm.loop !17

73:                                               ; preds = %68, %4, %0
  %74 = phi i32 [ -1, %0 ], [ 0, %4 ], [ 0, %68 ]
  ret i32 %74
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @qspi_clocks(i32 noundef range(i32 16, 33) %0) unnamed_addr #3 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %6 ]
  %4 = icmp eq i32 %3, %0
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  ret void

6:                                                ; preds = %2
  store volatile i32 57344, ptr inttoptr (i32 1073938452 to ptr), align 4, !tbaa !3
  store volatile i32 61440, ptr inttoptr (i32 1073938452 to ptr), align 4, !tbaa !3
  %7 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !18
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @arm_request(i32 noundef range(i32 1, 3) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #3 {
  %4 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 %0, ptr %5, align 4, !tbaa !19
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store volatile i32 %1, ptr %6, align 4, !tbaa !21
  %7 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store volatile i32 %2, ptr %7, align 4, !tbaa !22
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %9 = load volatile i32, ptr %8, align 4, !tbaa !23
  %10 = add i32 %9, 1
  store volatile i32 %10, ptr %8, align 4, !tbaa !23
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 16
  br label %12

12:                                               ; preds = %12, %3
  %13 = load volatile i32, ptr %11, align 4, !tbaa !24
  %14 = load volatile i32, ptr %8, align 4, !tbaa !23
  %15 = icmp eq i32 %13, %14
  br i1 %15, label %16, label %12, !llvm.loop !25

16:                                               ; preds = %12
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_wait_wip() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = or i32 %2, 5
  store volatile i32 %3, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %4 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #4
  %5 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  tail call fastcc void @qmi_end() #4
  %6 = and i32 %5, 1
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %1

8:                                                ; preds = %1
  ret void
}

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!5, !5, i64 0}
!8 = distinct !{!8, !9, !10}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{!"llvm.loop.unroll.disable"}
!11 = distinct !{!11, !9, !10}
!12 = distinct !{!12, !9, !10}
!13 = distinct !{!13, !9, !10}
!14 = distinct !{!14, !9, !10}
!15 = distinct !{!15, !9, !10}
!16 = distinct !{!16, !9, !10}
!17 = distinct !{!17, !9, !10}
!18 = distinct !{!18, !9, !10}
!19 = !{!20, !4, i64 0}
!20 = !{!"flashreq", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!21 = !{!20, !4, i64 4}
!22 = !{!20, !4, i64 8}
!23 = !{!20, !4, i64 12}
!24 = !{!20, !4, i64 16}
!25 = distinct !{!25, !9, !10}
