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
define dso_local range(i32 -1, 1) i32 @kflash_sync() local_unnamed_addr #3 {
  %1 = alloca [64 x i32], align 4
  %2 = load i32, ptr @fsslot, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %81, label %4

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
  br i1 %15, label %81, label %16

16:                                               ; preds = %4
  %17 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %28

19:                                               ; preds = %16, %22
  %20 = phi i32 [ %27, %22 ], [ 0, %16 ]
  %21 = icmp eq i32 %20, 2
  br i1 %21, label %28, label %22

22:                                               ; preds = %19
  %23 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %24 = or i32 %23, 5
  store volatile i32 %24, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %25 = tail call fastcc i32 @qmi_xfer(i32 noundef 255) #4
  %26 = tail call fastcc i32 @qmi_xfer(i32 noundef 255) #4
  tail call fastcc void @qmi_end() #4
  %27 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !7

28:                                               ; preds = %19, %16
  tail call fastcc void @flash_erase4k(i32 noundef %5) #4
  %29 = add i32 %2, -268431360
  br label %30

30:                                               ; preds = %53, %28
  %31 = phi i32 [ 0, %28 ], [ %54, %53 ]
  %32 = icmp eq i32 %31, %7
  br i1 %32, label %33, label %34

33:                                               ; preds = %30
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %1) #5
  br label %55

34:                                               ; preds = %30
  br i1 %12, label %35, label %40

35:                                               ; preds = %34
  %36 = load i32, ptr @fs_dirty, align 4, !tbaa !3
  %37 = shl nuw i32 1, %31
  %38 = and i32 %36, %37
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %53, label %40

40:                                               ; preds = %35, %34
  %41 = shl nuw i32 %31, 12
  %42 = add i32 %29, %41
  %43 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %44 = add i32 %43, %41
  %45 = inttoptr i32 %44 to ptr
  tail call fastcc void @flash_erase4k(i32 noundef %42) #4
  br label %46

46:                                               ; preds = %49, %40
  %47 = phi i32 [ 0, %40 ], [ %52, %49 ]
  %48 = icmp samesign ult i32 %47, 4096
  br i1 %48, label %49, label %53

49:                                               ; preds = %46
  %50 = add i32 %47, %42
  %51 = getelementptr inbounds nuw i8, ptr %45, i32 %47
  tail call fastcc void @flash_prog_page(i32 noundef %50, ptr noundef %51) #4
  %52 = add nuw nsw i32 %47, 256
  br label %46, !llvm.loop !10

53:                                               ; preds = %46, %35
  %54 = add nuw nsw i32 %31, 1
  br label %30, !llvm.loop !11

55:                                               ; preds = %78, %33
  %56 = phi i32 [ 0, %33 ], [ %80, %78 ]
  %57 = icmp eq i32 %56, 64
  br i1 %57, label %58, label %78

58:                                               ; preds = %55
  store i32 1397116228, ptr %1, align 4, !tbaa !3
  %59 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %60 = add i32 %59, 1
  %61 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %60, ptr %61, align 4, !tbaa !3
  %62 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %63 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i32 %62, ptr %63, align 4, !tbaa !3
  %64 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %65 = inttoptr i32 %64 to ptr
  %66 = lshr i32 %62, 2
  br label %67

67:                                               ; preds = %71, %58
  %68 = phi i32 [ 0, %58 ], [ %74, %71 ]
  %69 = phi i32 [ 0, %58 ], [ %75, %71 ]
  %70 = icmp eq i32 %69, %66
  br i1 %70, label %76, label %71

71:                                               ; preds = %67
  %72 = getelementptr inbounds nuw i32, ptr %65, i32 %69
  %73 = load i32, ptr %72, align 4, !tbaa !3
  %74 = add i32 %73, %68
  %75 = add nuw nsw i32 %69, 1
  br label %67, !llvm.loop !12

76:                                               ; preds = %67
  %77 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %68, ptr %77, align 4, !tbaa !3
  call fastcc void @flash_prog_page(i32 noundef %5, ptr noundef nonnull %1) #4
  store i32 %60, ptr @fs_gen, align 4, !tbaa !3
  store i32 0, ptr @fs_dirty, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %1) #5
  br label %81

78:                                               ; preds = %55
  %79 = getelementptr inbounds nuw [64 x i32], ptr %1, i32 0, i32 %56
  store i32 -1, ptr %79, align 4, !tbaa !3
  %80 = add nuw nsw i32 %56, 1
  br label %55, !llvm.loop !13

81:                                               ; preds = %76, %4, %0
  %82 = phi i32 [ -1, %0 ], [ 0, %4 ], [ 0, %76 ]
  ret i32 %82
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
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = zext i8 %22 to i32
  %24 = tail call fastcc i32 @qmi_xfer(i32 noundef %23) #4
  %25 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !15

26:                                               ; preds = %19, %5
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
  br i1 %6, label %7, label %3, !llvm.loop !16

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
  br i1 %6, label %7, label %3, !llvm.loop !17

7:                                                ; preds = %3
  %8 = load volatile i32, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  %9 = and i32 %8, -2
  store volatile i32 %9, ptr inttoptr (i32 1074593792 to ptr), align 65536, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @arm_request(i32 noundef range(i32 1, 3) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #3 {
  %4 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 %0, ptr %5, align 4, !tbaa !18
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store volatile i32 %1, ptr %6, align 4, !tbaa !20
  %7 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store volatile i32 %2, ptr %7, align 4, !tbaa !21
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %9 = load volatile i32, ptr %8, align 4, !tbaa !22
  %10 = add i32 %9, 1
  store volatile i32 %10, ptr %8, align 4, !tbaa !22
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 16
  br label %12

12:                                               ; preds = %12, %3
  %13 = load volatile i32, ptr %11, align 4, !tbaa !23
  %14 = load volatile i32, ptr %8, align 4, !tbaa !22
  %15 = icmp eq i32 %13, %14
  br i1 %15, label %16, label %12, !llvm.loop !24

16:                                               ; preds = %12
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
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = !{!5, !5, i64 0}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = !{!19, !4, i64 0}
!19 = !{!"flashreq", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!20 = !{!19, !4, i64 4}
!21 = !{!19, !4, i64 8}
!22 = !{!19, !4, i64 12}
!23 = !{!19, !4, i64 16}
!24 = distinct !{!24, !8, !9}
