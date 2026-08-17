; ModuleID = 'kflash.c'
source_filename = "kflash.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fsslot = dso_local local_unnamed_addr global i32 0, align 4
@dma_disksize = external dso_local local_unnamed_addr global i32, align 4
@fs_gen = internal unnamed_addr global i32 0, align 4
@kflash_arm = dso_local local_unnamed_addr global i32 0, align 4
@fs_dirty = external dso_local local_unnamed_addr global i32, align 4
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
  br i1 %3, label %72, label %4

4:                                                ; preds = %0
  %5 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %72, label %7

7:                                                ; preds = %4
  %8 = add i32 %2, -268435456
  %9 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %10 = lshr i32 %9, 12
  %11 = tail call i32 @kflash_slot_gen() #4
  %12 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %13 = icmp eq i32 %11, %12
  %14 = icmp ne i32 %12, 0
  %15 = and i1 %13, %14
  %16 = load i32, ptr @fs_dirty, align 4
  %17 = icmp eq i32 %16, 0
  %18 = select i1 %15, i1 %17, i1 false
  br i1 %18, label %72, label %19

19:                                               ; preds = %7
  tail call fastcc void @flash_erase4k(i32 noundef %8) #4
  %20 = add i32 %2, -268431360
  br label %21

21:                                               ; preds = %44, %19
  %22 = phi i32 [ 0, %19 ], [ %45, %44 ]
  %23 = icmp eq i32 %22, %10
  br i1 %23, label %24, label %25

24:                                               ; preds = %21
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %1) #5
  br label %46

25:                                               ; preds = %21
  br i1 %15, label %26, label %31

26:                                               ; preds = %25
  %27 = load i32, ptr @fs_dirty, align 4, !tbaa !3
  %28 = shl nuw i32 1, %22
  %29 = and i32 %27, %28
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %44, label %31

31:                                               ; preds = %26, %25
  %32 = shl nuw i32 %22, 12
  %33 = add i32 %20, %32
  %34 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %35 = add i32 %34, %32
  %36 = inttoptr i32 %35 to ptr
  tail call fastcc void @flash_erase4k(i32 noundef %33) #4
  br label %37

37:                                               ; preds = %40, %31
  %38 = phi i32 [ 0, %31 ], [ %43, %40 ]
  %39 = icmp samesign ult i32 %38, 4096
  br i1 %39, label %40, label %44

40:                                               ; preds = %37
  %41 = add i32 %38, %33
  %42 = getelementptr inbounds nuw i8, ptr %36, i32 %38
  tail call fastcc void @flash_prog_page(i32 noundef %41, ptr noundef %42) #4
  %43 = add nuw nsw i32 %38, 256
  br label %37, !llvm.loop !7

44:                                               ; preds = %37, %26
  %45 = add nuw nsw i32 %22, 1
  br label %21, !llvm.loop !10

46:                                               ; preds = %69, %24
  %47 = phi i32 [ 0, %24 ], [ %71, %69 ]
  %48 = icmp eq i32 %47, 64
  br i1 %48, label %49, label %69

49:                                               ; preds = %46
  store i32 1397116228, ptr %1, align 4, !tbaa !3
  %50 = load i32, ptr @fs_gen, align 4, !tbaa !3
  %51 = add i32 %50, 1
  %52 = getelementptr inbounds nuw i8, ptr %1, i32 4
  store i32 %51, ptr %52, align 4, !tbaa !3
  %53 = load i32, ptr @dma_disksize, align 4, !tbaa !3
  %54 = getelementptr inbounds nuw i8, ptr %1, i32 8
  store i32 %53, ptr %54, align 4, !tbaa !3
  %55 = load i32, ptr @dma_disk, align 4, !tbaa !3
  %56 = inttoptr i32 %55 to ptr
  %57 = lshr i32 %53, 2
  br label %58

58:                                               ; preds = %62, %49
  %59 = phi i32 [ 0, %49 ], [ %65, %62 ]
  %60 = phi i32 [ 0, %49 ], [ %66, %62 ]
  %61 = icmp eq i32 %60, %57
  br i1 %61, label %67, label %62

62:                                               ; preds = %58
  %63 = getelementptr inbounds nuw i32, ptr %56, i32 %60
  %64 = load i32, ptr %63, align 4, !tbaa !3
  %65 = add i32 %64, %59
  %66 = add nuw nsw i32 %60, 1
  br label %58, !llvm.loop !11

67:                                               ; preds = %58
  %68 = getelementptr inbounds nuw i8, ptr %1, i32 12
  store i32 %59, ptr %68, align 4, !tbaa !3
  call fastcc void @flash_prog_page(i32 noundef %8, ptr noundef nonnull %1) #4
  store i32 %51, ptr @fs_gen, align 4, !tbaa !3
  store i32 0, ptr @fs_dirty, align 4, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %1) #5
  br label %72

69:                                               ; preds = %46
  %70 = getelementptr inbounds nuw [64 x i32], ptr %1, i32 0, i32 %47
  store i32 -1, ptr %70, align 4, !tbaa !3
  %71 = add nuw nsw i32 %47, 1
  br label %46, !llvm.loop !12

72:                                               ; preds = %67, %7, %0, %4
  %73 = phi i32 [ -1, %4 ], [ -1, %0 ], [ 0, %7 ], [ 0, %67 ]
  ret i32 %73
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_erase4k(i32 noundef %0) unnamed_addr #3 {
  tail call fastcc void @arm_request(i32 noundef 1, i32 noundef %0, i32 noundef 0) #4
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @flash_prog_page(i32 noundef %0, ptr noundef %1) unnamed_addr #3 {
  %3 = ptrtoint ptr %1 to i32
  tail call fastcc void @arm_request(i32 noundef 2, i32 noundef %0, i32 noundef %3) #4
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @arm_request(i32 noundef range(i32 1, 3) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #3 {
  %4 = load i32, ptr @kflash_arm, align 4, !tbaa !3
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 %0, ptr %5, align 4, !tbaa !13
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store volatile i32 %1, ptr %6, align 4, !tbaa !15
  %7 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store volatile i32 %2, ptr %7, align 4, !tbaa !16
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %9 = load volatile i32, ptr %8, align 4, !tbaa !17
  %10 = add i32 %9, 1
  store volatile i32 %10, ptr %8, align 4, !tbaa !17
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 16
  br label %12

12:                                               ; preds = %12, %3
  %13 = load volatile i32, ptr %11, align 4, !tbaa !18
  %14 = load volatile i32, ptr %8, align 4, !tbaa !17
  %15 = icmp eq i32 %13, %14
  br i1 %15, label %16, label %12, !llvm.loop !19

16:                                               ; preds = %12
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
!13 = !{!14, !4, i64 0}
!14 = !{!"flashreq", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!15 = !{!14, !4, i64 4}
!16 = !{!14, !4, i64 8}
!17 = !{!14, !4, i64 12}
!18 = !{!14, !4, i64 16}
!19 = distinct !{!19, !8, !9}
