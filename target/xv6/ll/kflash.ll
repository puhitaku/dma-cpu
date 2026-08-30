; ModuleID = 'kflash.c'
source_filename = "kflash.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@kflash_arm = dso_local local_unnamed_addr global i32 0, align 4
@fsslot = dso_local local_unnamed_addr global i32 0, align 4
@dma_disksize = external dso_local local_unnamed_addr global i32, align 4
@goldsum = dso_local local_unnamed_addr global i32 0, align 4
@fs_gen = internal unnamed_addr global i32 0, align 4
@kflash_cal.pat = internal unnamed_addr constant [4 x i8] c"\11\CE\A0\0D", align 1
@fs_dirty = external dso_local local_unnamed_addr global i32, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@kflash_phase = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kflash_sd(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = tail call i32 @ksd_on() #6
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %8, label %6

6:                                                ; preds = %3
  %7 = tail call i32 @ksd_op(i32 noundef %0, i32 noundef %1, i32 noundef %2) #6
  br label %12

8:                                                ; preds = %3
  %9 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  switch i32 %9, label %10 [
    i32 1, label %12
    i32 0, label %11
  ]

10:                                               ; preds = %8
  tail call fastcc void @arm_request(i32 noundef %0, i32 noundef %1, i32 noundef %2) #7
  br label %12

11:                                               ; preds = %8
  br label %12

12:                                               ; preds = %8, %11, %10, %6
  %13 = phi i32 [ %7, %6 ], [ 0, %10 ], [ -19, %8 ], [ -1, %11 ]
  ret i32 %13
}

; Function Attrs: minsize optsize
declare dso_local i32 @ksd_on() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @ksd_op(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @arm_request(i32 noundef %0, i32 noundef %1, i32 noundef %2) unnamed_addr #2 {
  %4 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 %0, ptr %5, align 4, !tbaa !7
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store volatile i32 %1, ptr %6, align 4, !tbaa !9
  %7 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store volatile i32 %2, ptr %7, align 4, !tbaa !10
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %9 = load volatile i32, ptr %8, align 4, !tbaa !11
  %10 = add i32 %9, 1
  store volatile i32 %10, ptr %8, align 4, !tbaa !11
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 16
  br label %12

12:                                               ; preds = %12, %3
  %13 = load volatile i32, ptr %11, align 4, !tbaa !12
  %14 = load volatile i32, ptr %8, align 4, !tbaa !11
  %15 = icmp eq i32 %13, %14
  br i1 %15, label %16, label %12, !llvm.loop !13

16:                                               ; preds = %12
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define dso_local i32 @kflash_slot_gen() local_unnamed_addr #3 {
  %1 = load i32, ptr @fsslot, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %21, label %3

3:                                                ; preds = %0
  %4 = add i32 %1, 67108864
  %5 = inttoptr i32 %4 to ptr
  %6 = load i32, ptr %5, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 843468100
  br i1 %7, label %8, label %21

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %10 = load i32, ptr %9, align 4, !tbaa !3
  %11 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %12 = icmp eq i32 %10, %11
  br i1 %12, label %13, label %21

13:                                               ; preds = %8
  %14 = getelementptr inbounds nuw i8, ptr %5, i32 16
  %15 = load i32, ptr %14, align 4, !tbaa !3
  %16 = load i32, ptr @goldsum, align 4, !tbaa !3
  %17 = icmp eq i32 %15, %16
  br i1 %17, label %18, label %21

18:                                               ; preds = %13
  %19 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %20 = load i32, ptr %19, align 4, !tbaa !3
  br label %21

21:                                               ; preds = %18, %13, %8, %3, %0
  %22 = phi i32 [ 0, %0 ], [ %20, %18 ], [ 0, %13 ], [ 0, %8 ], [ 0, %3 ]
  ret i32 %22
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: read, inaccessiblemem: none)
define dso_local void @kflash_init() local_unnamed_addr #5 {
  %1 = tail call i32 @kflash_slot_gen() #7
  store i32 %1, ptr @fs_gen, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kflash_cal(ptr noundef %0) local_unnamed_addr #2 {
  %2 = alloca [256 x i8], align 1
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 48
  br label %4

4:                                                ; preds = %4, %1
  %5 = load volatile i32, ptr %3, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 1611489293
  br i1 %6, label %7, label %4, !llvm.loop !16

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
  tail call fastcc void @flash_exit_xip() #7
  store volatile i32 3, ptr %0, align 4, !tbaa !3
  %16 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %17 = or i32 %16, 16777221
  store volatile i32 %17, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %18 = tail call fastcc i32 @qmi_xfer(i32 noundef 159) #7
  %19 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  %20 = shl nuw nsw i32 %19, 16
  %21 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  %22 = shl nuw nsw i32 %21, 8
  %23 = or disjoint i32 %22, %20
  %24 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  %25 = or disjoint i32 %23, %24
  %26 = getelementptr inbounds nuw i8, ptr %0, i32 8
  store volatile i32 %25, ptr %26, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #7
  %27 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %28 = or i32 %27, 16777221
  store volatile i32 %28, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %29 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #7
  %30 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  %31 = getelementptr inbounds nuw i8, ptr %0, i32 12
  store volatile i32 %30, ptr %31, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #7
  tail call fastcc void @flash_wren() #7
  %32 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %33 = or i32 %32, 16777221
  store volatile i32 %33, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %34 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #7
  %35 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  %36 = getelementptr inbounds nuw i8, ptr %0, i32 16
  store volatile i32 %35, ptr %36, align 4, !tbaa !3
  tail call fastcc void @qmi_end() #7
  store volatile i32 4, ptr %0, align 4, !tbaa !3
  tail call fastcc void @flash_erase4k(i32 noundef 4128768) #7
  %37 = tail call fastcc i32 @qmi_read32() #7
  %38 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store volatile i32 %37, ptr %38, align 4, !tbaa !3
  store volatile i32 5, ptr %0, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %2) #8
  br label %39

39:                                               ; preds = %48, %7
  %40 = phi i32 [ 0, %7 ], [ %53, %48 ]
  %41 = icmp eq i32 %40, 256
  br i1 %41, label %42, label %48

42:                                               ; preds = %39
  call fastcc void @flash_prog_page(i32 noundef 4128768, ptr noundef nonnull %2) #7
  %43 = call fastcc i32 @qmi_read32() #7
  %44 = getelementptr inbounds nuw i8, ptr %0, i32 24
  store volatile i32 %43, ptr %44, align 4, !tbaa !3
  store volatile i32 6, ptr %0, align 4, !tbaa !3
  store volatile i32 4096, ptr inttoptr (i32 1074593808 to ptr), align 16, !tbaa !3
  store volatile i32 3, ptr inttoptr (i32 1074593812 to ptr), align 4, !tbaa !3
  %45 = load volatile i32, ptr inttoptr (i32 339673088 to ptr), align 65536, !tbaa !3
  %46 = getelementptr inbounds nuw i8, ptr %0, i32 28
  store volatile i32 %45, ptr %46, align 4, !tbaa !3
  store volatile i32 7, ptr %0, align 4, !tbaa !3
  %47 = getelementptr inbounds nuw i8, ptr %0, i32 32
  store volatile i32 1, ptr %47, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %2) #8
  ret void

48:                                               ; preds = %39
  %49 = and i32 %40, 3
  %50 = getelementptr inbounds nuw [4 x i8], ptr @kflash_cal.pat, i32 0, i32 %49
  %51 = load i8, ptr %50, align 1, !tbaa !17
  %52 = getelementptr inbounds nuw [256 x i8], ptr %2, i32 0, i32 %40
  store i8 %51, ptr %52, align 1, !tbaa !17
  %53 = add nuw nsw i32 %40, 1
  br label %39, !llvm.loop !18
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_exit_xip() unnamed_addr #2 {
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
  tail call fastcc void @qspi_clocks(i32 noundef 32) #7
  store volatile i32 57344, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003976 to ptr), align 8, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003980 to ptr), align 4, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003984 to ptr), align 16, !tbaa !3
  store volatile i32 72, ptr inttoptr (i32 1074003988 to ptr), align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 32) #7
  store i32 15, ptr @kflash_phase, align 4, !tbaa !3
  store volatile i32 61440, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 57344, ptr inttoptr (i32 1073938460 to ptr), align 4, !tbaa !3
  store volatile i32 61440, ptr inttoptr (i32 1073938468 to ptr), align 4, !tbaa !3
  tail call fastcc void @qspi_clocks(i32 noundef 16) #7
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
define internal fastcc range(i32 0, 256) i32 @qmi_xfer(i32 noundef %0) unnamed_addr #2 {
  %2 = and i32 %0, 255
  store volatile i32 %2, ptr inttoptr (i32 1074593796 to ptr), align 4, !tbaa !3
  br label %3

3:                                                ; preds = %3, %1
  %4 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %5 = and i32 %4, 65536
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !19

7:                                                ; preds = %3
  %8 = load volatile i32, ptr inttoptr (i32 1074593800 to ptr), align 8, !tbaa !3
  %9 = and i32 %8, 255
  ret i32 %9
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @qmi_end() unnamed_addr #2 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = and i32 %1, -5
  store volatile i32 %2, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  br label %3

3:                                                ; preds = %3, %0
  %4 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %5 = and i32 %4, 2
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !20

7:                                                ; preds = %3
  %8 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %9 = and i32 %8, -2
  store volatile i32 %9, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_wren() unnamed_addr #2 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = or i32 %1, 16777221
  store volatile i32 %2, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = tail call fastcc i32 @qmi_xfer(i32 noundef 6) #7
  tail call fastcc void @qmi_end() #7
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_erase4k(i32 noundef %0) unnamed_addr #2 {
  %2 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  switch i32 %2, label %3 [
    i32 1, label %13
    i32 0, label %4
  ]

3:                                                ; preds = %1
  tail call fastcc void @arm_request(i32 noundef 1, i32 noundef %0, i32 noundef 0) #7
  br label %13

4:                                                ; preds = %1
  tail call fastcc void @flash_wren() #7
  %5 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %6 = or i32 %5, 16777221
  store volatile i32 %6, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %7 = tail call fastcc i32 @qmi_xfer(i32 noundef 32) #7
  %8 = lshr i32 %0, 16
  %9 = tail call fastcc i32 @qmi_xfer(i32 noundef %8) #7
  %10 = lshr i32 %0, 8
  %11 = tail call fastcc i32 @qmi_xfer(i32 noundef %10) #7
  %12 = tail call fastcc i32 @qmi_xfer(i32 noundef %0) #7
  tail call fastcc void @qmi_end() #7
  tail call fastcc void @flash_wait_wip() #7
  br label %13

13:                                               ; preds = %1, %4, %3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc i32 @qmi_read32() unnamed_addr #2 {
  %1 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %2 = or i32 %1, 16777221
  store volatile i32 %2, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = tail call fastcc i32 @qmi_xfer(i32 noundef 3) #7
  %4 = tail call fastcc i32 @qmi_xfer(i32 noundef 63) #7
  %5 = tail call fastcc i32 @qmi_xfer(i32 noundef 16128) #7
  %6 = tail call fastcc i32 @qmi_xfer(i32 noundef 4128768) #7
  br label %7

7:                                                ; preds = %12, %0
  %8 = phi i32 [ 0, %0 ], [ %16, %12 ]
  %9 = phi i32 [ 0, %0 ], [ %17, %12 ]
  %10 = icmp eq i32 %9, 4
  br i1 %10, label %11, label %12

11:                                               ; preds = %7
  tail call fastcc void @qmi_end() #7
  ret i32 %8

12:                                               ; preds = %7
  %13 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  %14 = shl nuw nsw i32 %9, 3
  %15 = shl nuw i32 %13, %14
  %16 = or i32 %15, %8
  %17 = add nuw nsw i32 %9, 1
  br label %7, !llvm.loop !21
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_prog_page(i32 noundef %0, ptr noundef %1) unnamed_addr #2 {
  %3 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  switch i32 %3, label %4 [
    i32 1, label %25
    i32 0, label %6
  ]

4:                                                ; preds = %2
  %5 = ptrtoint ptr %1 to i32
  tail call fastcc void @arm_request(i32 noundef 2, i32 noundef %0, i32 noundef %5) #7
  br label %25

6:                                                ; preds = %2
  tail call fastcc void @flash_wren() #7
  %7 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %8 = or i32 %7, 16777221
  store volatile i32 %8, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %9 = tail call fastcc i32 @qmi_xfer(i32 noundef 2) #7
  %10 = lshr i32 %0, 16
  %11 = tail call fastcc i32 @qmi_xfer(i32 noundef %10) #7
  %12 = lshr i32 %0, 8
  %13 = tail call fastcc i32 @qmi_xfer(i32 noundef %12) #7
  %14 = tail call fastcc i32 @qmi_xfer(i32 noundef %0) #7
  br label %15

15:                                               ; preds = %19, %6
  %16 = phi i32 [ 0, %6 ], [ %24, %19 ]
  %17 = icmp eq i32 %16, 256
  br i1 %17, label %18, label %19

18:                                               ; preds = %15
  tail call fastcc void @qmi_end() #7
  tail call fastcc void @flash_wait_wip() #7
  br label %25

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %1, i32 %16
  %21 = load i8, ptr %20, align 1, !tbaa !17
  %22 = zext i8 %21 to i32
  %23 = tail call fastcc i32 @qmi_xfer(i32 noundef %22) #7
  %24 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !22

25:                                               ; preds = %2, %18, %4
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local range(i32 -19, 1) i32 @kflash_sync() local_unnamed_addr #2 {
  %1 = alloca [64 x i32], align 4
  %2 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 1
  br i1 %3, label %85, label %4

4:                                                ; preds = %0
  %5 = load i32, ptr @fsslot, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %85, label %7

7:                                                ; preds = %4
  %8 = add i32 %5, -268435456
  %9 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %10 = lshr i32 %9, 12
  %11 = tail call i32 @kflash_slot_gen() #7
  %12 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %13 = icmp eq i32 %11, %12
  %14 = icmp ne i32 %12, 0
  %15 = and i1 %13, %14
  %16 = load i32, ptr @fs_dirty, align 4
  %17 = icmp eq i32 %16, 0
  %18 = select i1 %15, i1 %17, i1 false
  br i1 %18, label %85, label %19

19:                                               ; preds = %7
  %20 = icmp eq i32 %2, 0
  br i1 %20, label %21, label %22

21:                                               ; preds = %19
  tail call fastcc void @flash_exit_xip() #7
  br label %22

22:                                               ; preds = %21, %19
  tail call fastcc void @flash_erase4k(i32 noundef %8) #7
  %23 = add i32 %5, -268431360
  br label %24

24:                                               ; preds = %47, %22
  %25 = phi i32 [ 0, %22 ], [ %48, %47 ]
  %26 = icmp eq i32 %25, %10
  br i1 %26, label %27, label %28

27:                                               ; preds = %24
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %1) #8
  br label %49

28:                                               ; preds = %24
  br i1 %15, label %29, label %34

29:                                               ; preds = %28
  %30 = load i32, ptr @fs_dirty, align 4, !tbaa !3
  %31 = shl nuw i32 1, %25
  %32 = and i32 %30, %31
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %47, label %34

34:                                               ; preds = %29, %28
  %35 = shl nuw i32 %25, 12
  %36 = add i32 %23, %35
  %37 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %38 = add i32 %37, %35
  %39 = inttoptr i32 %38 to ptr
  tail call fastcc void @flash_erase4k(i32 noundef %36) #7
  br label %40

40:                                               ; preds = %43, %34
  %41 = phi i32 [ 0, %34 ], [ %46, %43 ]
  %42 = icmp samesign ult i32 %41, 4096
  br i1 %42, label %43, label %47

43:                                               ; preds = %40
  %44 = add i32 %41, %36
  %45 = getelementptr inbounds nuw i8, ptr %39, i32 %41
  tail call fastcc void @flash_prog_page(i32 noundef %44, ptr noundef %45) #7
  %46 = add nuw nsw i32 %41, 256
  br label %40, !llvm.loop !23

47:                                               ; preds = %40, %29
  %48 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !24

49:                                               ; preds = %76, %27
  %50 = phi i32 [ 0, %27 ], [ %78, %76 ]
  %51 = icmp eq i32 %50, 64
  br i1 %51, label %52, label %76

52:                                               ; preds = %49
  store i32 843468100, ptr %1, align 4, !tbaa !3
  %53 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %54 = add i32 %53, 1
  %55 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %54, ptr %55, align 4, !tbaa !3
  %56 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %57 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i32 %56, ptr %57, align 4, !tbaa !3
  %58 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %59 = inttoptr i32 %58 to ptr
  %60 = lshr i32 %56, 2
  br label %61

61:                                               ; preds = %65, %52
  %62 = phi i32 [ 0, %52 ], [ %68, %65 ]
  %63 = phi i32 [ 0, %52 ], [ %69, %65 ]
  %64 = icmp eq i32 %63, %60
  br i1 %64, label %70, label %65

65:                                               ; preds = %61
  %66 = getelementptr inbounds nuw i32, ptr %59, i32 %63
  %67 = load i32, ptr %66, align 4, !tbaa !3
  %68 = add i32 %67, %62
  %69 = add nuw nsw i32 %63, 1
  br label %61, !llvm.loop !25

70:                                               ; preds = %61
  %71 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %62, ptr %71, align 4, !tbaa !3
  %72 = load i32, ptr @goldsum, align 4, !tbaa !3
  %73 = getelementptr inbounds nuw i8, ptr %1, i32 16
  store i32 %72, ptr %73, align 4, !tbaa !3
  call fastcc void @flash_prog_page(i32 noundef %8, ptr noundef nonnull %1) #7
  %74 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %75 = icmp eq i32 %74, 0
  br i1 %75, label %79, label %82

76:                                               ; preds = %49
  %77 = getelementptr inbounds nuw [64 x i32], ptr %1, i32 0, i32 %50
  store i32 -1, ptr %77, align 4, !tbaa !3
  %78 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !26

79:                                               ; preds = %70
  store volatile i32 4096, ptr inttoptr (i32 1074593808 to ptr), align 16, !tbaa !3
  store volatile i32 3, ptr inttoptr (i32 1074593812 to ptr), align 4, !tbaa !3
  %80 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %81 = add i32 %80, 1
  br label %83

82:                                               ; preds = %70
  call fastcc void @arm_request(i32 noundef 3, i32 noundef 0, i32 noundef 0) #7
  br label %83

83:                                               ; preds = %82, %79
  %84 = phi i32 [ %54, %82 ], [ %81, %79 ]
  store i32 %84, ptr @fs_gen, align 4, !tbaa !3
  store i32 0, ptr @fs_dirty, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %1) #8
  br label %85

85:                                               ; preds = %83, %7, %4, %0
  %86 = phi i32 [ -19, %0 ], [ -1, %4 ], [ 0, %7 ], [ 0, %83 ]
  ret i32 %86
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @qspi_clocks(i32 noundef range(i32 16, 33) %0) unnamed_addr #2 {
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
  br label %2, !llvm.loop !27
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_wait_wip() unnamed_addr #2 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %3 = or i32 %2, 16777221
  store volatile i32 %3, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %4 = tail call fastcc i32 @qmi_xfer(i32 noundef 5) #7
  %5 = tail call fastcc i32 @qmi_xfer(i32 noundef 0) #7
  tail call fastcc void @qmi_end() #7
  %6 = and i32 %5, 1
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %1

8:                                                ; preds = %1
  ret void
}

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { minsize nobuiltin optsize "no-builtins" }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !4, i64 0}
!8 = !{!"flashreq", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!9 = !{!8, !4, i64 4}
!10 = !{!8, !4, i64 8}
!11 = !{!8, !4, i64 12}
!12 = !{!8, !4, i64 16}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !14, !15}
!17 = !{!5, !5, i64 0}
!18 = distinct !{!18, !14, !15}
!19 = distinct !{!19, !14, !15}
!20 = distinct !{!20, !14, !15}
!21 = distinct !{!21, !14, !15}
!22 = distinct !{!22, !14, !15}
!23 = distinct !{!23, !14, !15}
!24 = distinct !{!24, !14, !15}
!25 = distinct !{!25, !14, !15}
!26 = distinct !{!26, !14, !15}
!27 = distinct !{!27, !14, !15}
