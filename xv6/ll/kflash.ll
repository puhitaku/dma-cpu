; ModuleID = 'kflash.c'
source_filename = "kflash.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fsslot = dso_local local_unnamed_addr global i32 0, align 4
@dma_disksize = external dso_local local_unnamed_addr global i32, align 4
@fs_gen = internal unnamed_addr global i32 0, align 4
@kflash_cal.pat = internal unnamed_addr constant [4 x i8] c"\11\CE\A0\0D", align 1
@fs_dirty = external dso_local local_unnamed_addr global i32, align 4
@kflash_arm = dso_local local_unnamed_addr global i32 0, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@kflash_phase = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define dso_local i32 @kflash_slot_gen() local_unnamed_addr #0 {
  %1 = load i32, ptr @fsslot, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %16, label %3

3:                                                ; preds = %0
  %4 = add i32 %1, 67108864
  %5 = inttoptr i32 %4 to ptr
  %6 = load i32, ptr %5, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 843468100
  br i1 %7, label %8, label %16

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %10 = load i32, ptr %9, align 4, !tbaa !3
  %11 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %12 = icmp eq i32 %10, %11
  br i1 %12, label %13, label %16

13:                                               ; preds = %8
  %14 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %15 = load i32, ptr %14, align 4, !tbaa !3
  br label %16

16:                                               ; preds = %13, %8, %3, %0
  %17 = phi i32 [ 0, %0 ], [ %15, %13 ], [ 0, %8 ], [ 0, %3 ]
  ret i32 %17
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
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 48
  br label %4

4:                                                ; preds = %4, %1
  %5 = load volatile i32, ptr %3, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 1611489293
  br i1 %6, label %7, label %4, !llvm.loop !7

7:                                                ; preds = %4
  store volatile i32 1, ptr %0, align 4, !tbaa !3
  %8 = load volatile i32, ptr inttoptr (i32 1074462760 to ptr), align 8, !tbaa !3
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 36
  store volatile i32 %8, ptr %9, align 4, !tbaa !3
  store volatile i32 16777217, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %10 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 4
  store volatile i32 %10, ptr %11, align 4, !tbaa !3
  %12 = load volatile i32, ptr inttoptr (i32 1074462760 to ptr), align 8, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 40
  store volatile i32 %12, ptr %13, align 4, !tbaa !3
  store volatile i32 0, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %14 = load volatile i32, ptr inttoptr (i32 1074462760 to ptr), align 8, !tbaa !3
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 44
  store volatile i32 %14, ptr %15, align 4, !tbaa !3
  store volatile i32 2, ptr %0, align 4, !tbaa !3
  tail call fastcc void @flash_exit_xip() #4
  store volatile i32 3, ptr %0, align 4, !tbaa !3
  %16 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %17 = or i32 %16, 16777221
  store volatile i32 %17, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %18 = tail call fastcc i32 @qmi_xfer(i32 noundef 159) #4
  %19 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %20 = shl nuw nsw i32 %19, 16
  %21 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %22 = shl nuw nsw i32 %21, 8
  %23 = or disjoint i32 %22, %20
  %24 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %25 = or disjoint i32 %23, %24
  %26 = getelementptr inbounds nuw i8, ptr %0, i32 8
  store volatile i32 %25, ptr %26, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #4
  %27 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %28 = or i32 %27, 16777221
  store volatile i32 %28, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %29 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #4
  %30 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %31 = getelementptr inbounds nuw i8, ptr %0, i32 12
  store volatile i32 %30, ptr %31, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #4
  tail call fastcc void @flash_wren() #4
  %32 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %33 = or i32 %32, 16777221
  store volatile i32 %33, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %34 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #4
  %35 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %36 = getelementptr inbounds nuw i8, ptr %0, i32 16
  store volatile i32 %35, ptr %36, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #4
  store volatile i32 4, ptr %0, align 4, !tbaa !3
  tail call fastcc void @flash_erase4k(i32 noundef 1245184) #4
  %37 = tail call fastcc i32 @qmi_read32() #4
  %38 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store volatile i32 %37, ptr %38, align 4, !tbaa !3
  store volatile i32 5, ptr %0, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %2) #5
  br label %39

39:                                               ; preds = %48, %7
  %40 = phi i32 [ 0, %7 ], [ %53, %48 ]
  %41 = icmp eq i32 %40, 256
  br i1 %41, label %42, label %48

42:                                               ; preds = %39
  call fastcc void @flash_prog_page(i32 noundef 1245184, ptr noundef nonnull %2) #4
  %43 = call fastcc i32 @qmi_read32() #4
  %44 = getelementptr inbounds nuw i8, ptr %0, i32 24
  store volatile i32 %43, ptr %44, align 4, !tbaa !3
  store volatile i32 6, ptr %0, align 4, !tbaa !3
  store volatile i32 4096, ptr inttoptr (i32 1074593808 to ptr), align 16, !tbaa !3
  store volatile i32 3, ptr inttoptr (i32 1074593812 to ptr), align 4, !tbaa !3
  %45 = load volatile i32, ptr inttoptr (i32 336789504 to ptr), align 65536, !tbaa !3
  %46 = getelementptr inbounds nuw i8, ptr %0, i32 28
  store volatile i32 %45, ptr %46, align 4, !tbaa !3
  store volatile i32 7, ptr %0, align 4, !tbaa !3
  %47 = getelementptr inbounds nuw i8, ptr %0, i32 32
  store volatile i32 1, ptr %47, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %2) #5
  ret void

48:                                               ; preds = %39
  %49 = and i32 %40, 3
  %50 = getelementptr inbounds nuw [4 x i8], ptr @kflash_cal.pat, i32 0, i32 %49
  %51 = load i8, ptr %50, align 1, !tbaa !10
  %52 = getelementptr inbounds nuw [256 x i8], ptr %2, i32 0, i32 %40
  store i8 %51, ptr %52, align 1, !tbaa !10
  %53 = add nuw nsw i32 %40, 1
  br label %39, !llvm.loop !11
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_exit_xip() unnamed_addr #3 {
  store i32 10, ptr @kflash_phase, align 4, !tbaa !3
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
  store i32 13, ptr @kflash_phase, align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 32) #4
  store volatile i32 57344, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003976 to ptr), align 8, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003980 to ptr), align 4, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003984 to ptr), align 16, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003988 to ptr), align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 32) #4
  store i32 15, ptr @kflash_phase, align 4, !tbaa !3
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
  store i32 18, ptr @kflash_phase, align 4, !tbaa !3
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
  br i1 %6, label %7, label %3, !llvm.loop !12

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
  br i1 %6, label %7, label %3, !llvm.loop !13

7:                                                ; preds = %3
  %8 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %9 = and i32 %8, -2
  store volatile i32 %9, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_wren() unnamed_addr #3 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = or i32 %1, 16777221
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
  %7 = or i32 %6, 16777221
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
define internal fastcc i32 @qmi_read32() unnamed_addr #3 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = or i32 %1, 16777221
  store volatile i32 %2, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = tail call fastcc i32 @qmi_xfer(i32 noundef 3) #4
  %4 = tail call fastcc i32 @qmi_xfer(i32 noundef 19) #4
  %5 = tail call fastcc i32 @qmi_xfer(i32 noundef 4864) #4
  %6 = tail call fastcc i32 @qmi_xfer(i32 noundef 1245184) #4
  br label %7

7:                                                ; preds = %12, %0
  %8 = phi i32 [ 0, %0 ], [ %16, %12 ]
  %9 = phi i32 [ 0, %0 ], [ %17, %12 ]
  %10 = icmp eq i32 %9, 4
  br i1 %10, label %11, label %12

11:                                               ; preds = %7
  tail call fastcc void @qmi_end() #4
  ret i32 %8

12:                                               ; preds = %7
  %13 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #4
  %14 = shl nuw nsw i32 %9, 3
  %15 = shl nuw i32 %13, %14
  %16 = or i32 %15, %8
  %17 = add nuw nsw i32 %9, 1
  br label %7, !llvm.loop !14
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
  %9 = or i32 %8, 16777221
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
  %22 = load i8, ptr %21, align 1, !tbaa !10
  %23 = zext i8 %22 to i32
  %24 = tail call fastcc i32 @qmi_xfer(i32 noundef %23) #4
  %25 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !15

26:                                               ; preds = %19, %5
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -1, 1) i32 @kflash_sync() local_unnamed_addr #3 {
  %1 = alloca [64 x i32], align 4
  %2 = load i32, ptr @fsslot, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %80, label %4

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
  br i1 %15, label %80, label %16

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
  br label %38, !llvm.loop !16

45:                                               ; preds = %38, %27
  %46 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !17

47:                                               ; preds = %72, %25
  %48 = phi i32 [ 0, %25 ], [ %74, %72 ]
  %49 = icmp eq i32 %48, 64
  br i1 %49, label %50, label %72

50:                                               ; preds = %47
  store i32 843468100, ptr %1, align 4, !tbaa !3
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
  br label %59, !llvm.loop !18

68:                                               ; preds = %59
  %69 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %60, ptr %69, align 4, !tbaa !3
  call fastcc void @flash_prog_page(i32 noundef %5, ptr noundef nonnull %1) #4
  %70 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %71 = icmp eq i32 %70, 0
  br i1 %71, label %75, label %78

72:                                               ; preds = %47
  %73 = getelementptr inbounds nuw [64 x i32], ptr %1, i32 0, i32 %48
  store i32 -1, ptr %73, align 4, !tbaa !3
  %74 = add nuw nsw i32 %48, 1
  br label %47, !llvm.loop !19

75:                                               ; preds = %68
  store volatile i32 4096, ptr inttoptr (i32 1074593808 to ptr), align 16, !tbaa !3
  store volatile i32 3, ptr inttoptr (i32 1074593812 to ptr), align 4, !tbaa !3
  %76 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %77 = add i32 %76, 1
  br label %78

78:                                               ; preds = %75, %68
  %79 = phi i32 [ %77, %75 ], [ %52, %68 ]
  store i32 %79, ptr @fs_gen, align 4, !tbaa !3
  store i32 0, ptr @fs_dirty, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %1) #5
  br label %80

80:                                               ; preds = %78, %4, %0
  %81 = phi i32 [ -1, %0 ], [ 0, %4 ], [ 0, %78 ]
  ret i32 %81
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
  br label %2, !llvm.loop !20
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @arm_request(i32 noundef range(i32 1, 3) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #3 {
  %4 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 %0, ptr %5, align 4, !tbaa !21
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store volatile i32 %1, ptr %6, align 4, !tbaa !23
  %7 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store volatile i32 %2, ptr %7, align 4, !tbaa !24
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %9 = load volatile i32, ptr %8, align 4, !tbaa !25
  %10 = add i32 %9, 1
  store volatile i32 %10, ptr %8, align 4, !tbaa !25
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 16
  br label %12

12:                                               ; preds = %12, %3
  %13 = load volatile i32, ptr %11, align 4, !tbaa !26
  %14 = load volatile i32, ptr %8, align 4, !tbaa !25
  %15 = icmp eq i32 %13, %14
  br i1 %15, label %16, label %12, !llvm.loop !27

16:                                               ; preds = %12
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_wait_wip() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = or i32 %2, 16777221
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
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = !{!5, !5, i64 0}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = !{!22, !4, i64 0}
!22 = !{!"flashreq", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!23 = !{!22, !4, i64 4}
!24 = !{!22, !4, i64 8}
!25 = !{!22, !4, i64 12}
!26 = !{!22, !4, i64 16}
!27 = distinct !{!27, !8, !9}
