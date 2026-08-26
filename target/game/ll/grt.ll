; ModuleID = 'grt.c'
source_filename = "grt.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@memctrl = dso_local local_unnamed_addr global i32 0, align 4
@gdma_fill.fill = internal global i32 0, align 4
@spictrl = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @uputs(ptr noundef readonly captures(none) %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi ptr [ %0, %1 ], [ %7, %6 ]
  %4 = load i8, ptr %3, align 1, !tbaa !3
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %8 = sext i8 %4 to i32
  tail call fastcc void @uputc(i32 noundef %8) #5
  br label %2, !llvm.loop !6

9:                                                ; preds = %2
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define internal fastcc void @uputc(i32 noundef range(i32 -128, 128) %0) unnamed_addr #1 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %8

3:                                                ; preds = %1, %3
  %4 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %5 = and i32 %4, 32
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !11

7:                                                ; preds = %3
  store volatile i32 13, ptr @__dma_uart_dr, align 4, !tbaa !9
  br label %8

8:                                                ; preds = %7, %1
  br label %9

9:                                                ; preds = %8, %9
  %10 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %11 = and i32 %10, 32
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %9, !llvm.loop !12

13:                                               ; preds = %9
  store volatile i32 %0, ptr @__dma_uart_dr, align 4, !tbaa !9
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @uputn(i32 noundef %0) local_unnamed_addr #0 {
  %2 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %2) #6
  br label %3

3:                                                ; preds = %3, %1
  %4 = phi i32 [ %0, %1 ], [ %7, %3 ]
  %5 = phi i32 [ 0, %1 ], [ %12, %3 ]
  %6 = freeze i32 %4
  %7 = udiv i32 %6, 10
  %8 = mul i32 %7, 10
  %9 = sub i32 %6, %8
  %10 = trunc nuw nsw i32 %9 to i8
  %11 = or disjoint i8 %10, 48
  %12 = add nuw nsw i32 %5, 1
  %13 = getelementptr inbounds nuw [12 x i8], ptr %2, i32 0, i32 %5
  store i8 %11, ptr %13, align 1, !tbaa !3
  %14 = icmp ult i32 %4, 10
  br i1 %14, label %15, label %3, !llvm.loop !13

15:                                               ; preds = %3, %18
  %16 = phi i32 [ %19, %18 ], [ %12, %3 ]
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %23, label %18

18:                                               ; preds = %15
  %19 = add nsw i32 %16, -1
  %20 = getelementptr inbounds [12 x i8], ptr %2, i32 0, i32 %19
  %21 = load i8, ptr %20, align 1, !tbaa !3
  %22 = sext i8 %21 to i32
  tail call fastcc void @uputc(i32 noundef %22) #5
  br label %15, !llvm.loop !14

23:                                               ; preds = %15
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %2) #6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @uputhex(i32 noundef %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i32 [ 28, %1 ], [ %13, %6 ]
  %4 = icmp sgt i32 %3, -1
  br i1 %4, label %6, label %5

5:                                                ; preds = %2
  ret void

6:                                                ; preds = %2
  %7 = lshr i32 %0, %3
  %8 = and i32 %7, 15
  %9 = icmp samesign ult i32 %8, 10
  %10 = or disjoint i32 %8, 48
  %11 = add nuw nsw i32 %8, 87
  %12 = select i1 %9, i32 %10, i32 %11
  tail call fastcc void @uputc(i32 noundef %12) #5
  %13 = add nsw i32 %3, -4
  br label %2, !llvm.loop !15
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local void @numstr(ptr noundef writeonly captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #3 {
  %4 = getelementptr inbounds i8, ptr %0, i32 %1
  store i8 0, ptr %4, align 1, !tbaa !3
  br label %5

5:                                                ; preds = %10, %3
  %6 = phi i32 [ %2, %3 ], [ %13, %10 ]
  %7 = phi i32 [ %1, %3 ], [ %11, %10 ]
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %5
  ret void

10:                                               ; preds = %5
  %11 = add nsw i32 %7, -1
  %12 = freeze i32 %6
  %13 = udiv i32 %12, 10
  %14 = mul i32 %13, 10
  %15 = sub i32 %12, %14
  %16 = trunc nuw nsw i32 %15 to i8
  %17 = or disjoint i8 %16, 48
  %18 = getelementptr inbounds nuw i8, ptr %0, i32 %11
  store i8 %17, ptr %18, align 1, !tbaa !3
  br label %5, !llvm.loop !16
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local void @numsp(ptr noundef writeonly captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #3 {
  %4 = getelementptr inbounds i8, ptr %0, i32 %1
  store i8 0, ptr %4, align 1, !tbaa !3
  %5 = add nsw i32 %1, -1
  br label %6

6:                                                ; preds = %19, %3
  %7 = phi i32 [ %2, %3 ], [ %22, %19 ]
  %8 = phi i32 [ %5, %3 ], [ %23, %19 ]
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %11, label %10

10:                                               ; preds = %6
  ret void

11:                                               ; preds = %6
  %12 = icmp eq i32 %7, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %11
  %14 = icmp eq i32 %8, %5
  br i1 %14, label %15, label %19

15:                                               ; preds = %13, %11
  %16 = urem i32 %7, 10
  %17 = trunc nuw nsw i32 %16 to i8
  %18 = or disjoint i8 %17, 48
  br label %19

19:                                               ; preds = %13, %15
  %20 = phi i8 [ %18, %15 ], [ 32, %13 ]
  %21 = getelementptr inbounds nuw i8, ptr %0, i32 %8
  store i8 %20, ptr %21, align 1, !tbaa !3
  %22 = udiv i32 %7, 10
  %23 = add nsw i32 %8, -1
  br label %6, !llvm.loop !17
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local i32 @now_us() local_unnamed_addr #4 {
  %1 = load volatile i32, ptr inttoptr (i32 1074085928 to ptr), align 8, !tbaa !9
  ret i32 %1
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @delay_us(i32 noundef %0) local_unnamed_addr #0 {
  %2 = load volatile i32, ptr inttoptr (i32 1074085928 to ptr), align 8, !tbaa !9
  br label %3

3:                                                ; preds = %3, %1
  %4 = load volatile i32, ptr inttoptr (i32 1074085928 to ptr), align 8, !tbaa !9
  %5 = sub i32 %4, %2
  %6 = icmp ult i32 %5, %0
  br i1 %6, label %3, label %7, !llvm.loop !18

7:                                                ; preds = %3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gpio_fn(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = shl i32 %0, 2
  %4 = add i32 %3, 1073856516
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 82, ptr %5, align 4, !tbaa !9
  %6 = shl i32 %0, 3
  %7 = add i32 %6, 1073823748
  %8 = inttoptr i32 %7 to ptr
  store volatile i32 %1, ptr %8, align 4, !tbaa !9
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gpio_out(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp eq i32 %1, 0
  %4 = select i1 %3, i32 12800, i32 13056
  %5 = shl i32 %0, 3
  %6 = add i32 %5, 1073823748
  %7 = inttoptr i32 %6 to ptr
  store volatile i32 %4, ptr %7, align 4, !tbaa !9
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gpio_in_init(i32 noundef %0) local_unnamed_addr #0 {
  %2 = shl i32 %0, 2
  %3 = add i32 %2, 1073856516
  %4 = inttoptr i32 %3 to ptr
  store volatile i32 90, ptr %4, align 4, !tbaa !9
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local range(i32 0, 131073) i32 @gpio_in(i32 noundef %0) local_unnamed_addr #4 {
  %2 = shl i32 %0, 3
  %3 = add i32 %2, 1073823744
  %4 = inttoptr i32 %3 to ptr
  %5 = load volatile i32, ptr %4, align 8, !tbaa !9
  %6 = and i32 %5, 131072
  ret i32 %6
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gd_wait() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !9
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %1, !llvm.loop !19

4:                                                ; preds = %1
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gdma_copy(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %26, label %5

5:                                                ; preds = %3
  %6 = or i32 %1, %0
  %7 = or i32 %6, %2
  %8 = and i32 %7, 3
  %9 = icmp eq i32 %8, 0
  %10 = load i32, ptr @memctrl, align 4
  %11 = icmp ne i32 %10, 0
  %12 = select i1 %9, i1 %11, i1 false
  br i1 %12, label %13, label %15

13:                                               ; preds = %5
  %14 = lshr i32 %2, 2
  tail call fastcc void @gd_run(i32 noundef %1, i32 noundef %0, i32 noundef %14, i32 noundef %10) #5
  br label %26

15:                                               ; preds = %5
  %16 = inttoptr i32 %1 to ptr
  %17 = inttoptr i32 %0 to ptr
  br label %18

18:                                               ; preds = %21, %15
  %19 = phi i32 [ 0, %15 ], [ %25, %21 ]
  %20 = icmp eq i32 %19, %2
  br i1 %20, label %26, label %21

21:                                               ; preds = %18
  %22 = getelementptr inbounds nuw i8, ptr %16, i32 %19
  %23 = load i8, ptr %22, align 1, !tbaa !3
  %24 = getelementptr inbounds nuw i8, ptr %17, i32 %19
  store i8 %23, ptr %24, align 1, !tbaa !3
  %25 = add i32 %19, 1
  br label %18, !llvm.loop !20

26:                                               ; preds = %18, %3, %13
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @gd_run(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) unnamed_addr #0 {
  tail call void @gd_wait() #5
  store volatile i32 %0, ptr inttoptr (i32 1342177984 to ptr), align 64, !tbaa !9
  store volatile i32 %1, ptr inttoptr (i32 1342177988 to ptr), align 4, !tbaa !9
  store volatile i32 %2, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !9
  store volatile i32 %3, ptr inttoptr (i32 1342177996 to ptr), align 4, !tbaa !9
  br label %5

5:                                                ; preds = %5, %4
  %6 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !9
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %5, !llvm.loop !21

8:                                                ; preds = %5
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gdma_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %2, 0
  br i1 %4, label %23, label %5

5:                                                ; preds = %3
  %6 = or i32 %2, %0
  %7 = and i32 %6, 3
  %8 = icmp eq i32 %7, 0
  %9 = load i32, ptr @memctrl, align 4
  %10 = icmp ne i32 %9, 0
  %11 = select i1 %8, i1 %10, i1 false
  br i1 %11, label %14, label %12

12:                                               ; preds = %5
  %13 = add i32 %2, %0
  br label %17

14:                                               ; preds = %5
  store i32 %1, ptr @gdma_fill.fill, align 4, !tbaa !9
  %15 = lshr i32 %2, 2
  %16 = and i32 %9, -17
  tail call fastcc void @gd_run(i32 noundef ptrtoint (ptr @gdma_fill.fill to i32), i32 noundef %0, i32 noundef %15, i32 noundef %16) #5
  br label %23

17:                                               ; preds = %12, %20
  %18 = phi i32 [ %22, %20 ], [ %0, %12 ]
  %19 = icmp ult i32 %18, %13
  br i1 %19, label %20, label %23

20:                                               ; preds = %17
  %21 = inttoptr i32 %18 to ptr
  store volatile i32 %1, ptr %21, align 4, !tbaa !9
  %22 = add i32 %18, 4
  br label %17, !llvm.loop !22

23:                                               ; preds = %17, %3, %14
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gdma_rows(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %5) local_unnamed_addr #0 {
  tail call void @gd_wait() #5
  %7 = icmp eq i32 %5, 0
  %8 = load i32, ptr @memctrl, align 4
  %9 = and i32 %8, -17
  %10 = select i1 %7, i32 %9, i32 %8
  store volatile i32 %10, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !9
  store volatile i32 %2, ptr inttoptr (i32 1342178040 to ptr), align 8, !tbaa !9
  br label %11

11:                                               ; preds = %21, %6
  %12 = phi i32 [ %1, %6 ], [ %23, %21 ]
  %13 = phi i32 [ %0, %6 ], [ %22, %21 ]
  %14 = phi i32 [ 0, %6 ], [ %24, %21 ]
  %15 = icmp slt i32 %14, %3
  br i1 %15, label %17, label %16

16:                                               ; preds = %11
  ret void

17:                                               ; preds = %11
  store volatile i32 %13, ptr inttoptr (i32 1342178036 to ptr), align 4, !tbaa !9
  store volatile i32 %12, ptr inttoptr (i32 1342178044 to ptr), align 4, !tbaa !9
  br label %18

18:                                               ; preds = %18, %17
  %19 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !9
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %18, !llvm.loop !23

21:                                               ; preds = %18
  %22 = add i32 %13, %4
  %23 = add i32 %12, %5
  %24 = add nuw nsw i32 %14, 1
  br label %11, !llvm.loop !24
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gdma_spi_rows(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #0 {
  tail call void @gd_wait() #5
  %5 = load i32, ptr @spictrl, align 4, !tbaa !9
  store volatile i32 %5, ptr inttoptr (i32 1342178000 to ptr), align 16, !tbaa !9
  store volatile i32 1073987592, ptr inttoptr (i32 1342178036 to ptr), align 4, !tbaa !9
  %6 = shl i32 %1, 1
  %7 = icmp eq i32 %3, %6
  br i1 %7, label %8, label %10

8:                                                ; preds = %4
  %9 = mul i32 %2, %1
  store volatile i32 %9, ptr inttoptr (i32 1342178040 to ptr), align 8, !tbaa !9
  store volatile i32 %0, ptr inttoptr (i32 1342178044 to ptr), align 4, !tbaa !9
  br label %24

10:                                               ; preds = %4
  store volatile i32 %1, ptr inttoptr (i32 1342178040 to ptr), align 8, !tbaa !9
  %11 = add nsw i32 %2, -1
  br label %12

12:                                               ; preds = %22, %10
  %13 = phi i32 [ %0, %10 ], [ %17, %22 ]
  %14 = phi i32 [ 0, %10 ], [ %23, %22 ]
  %15 = icmp slt i32 %14, %2
  br i1 %15, label %16, label %24

16:                                               ; preds = %12
  store volatile i32 %13, ptr inttoptr (i32 1342178044 to ptr), align 4, !tbaa !9
  %17 = add i32 %13, %3
  %18 = icmp eq i32 %14, %11
  br i1 %18, label %22, label %19

19:                                               ; preds = %16, %19
  %20 = load volatile i32, ptr inttoptr (i32 1342177992 to ptr), align 8, !tbaa !9
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %22, label %19, !llvm.loop !25

22:                                               ; preds = %19, %16
  %23 = add nuw nsw i32 %14, 1
  br label %12, !llvm.loop !26

24:                                               ; preds = %12, %8
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @gdma_spi16(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = load i32, ptr @spictrl, align 4, !tbaa !9
  tail call fastcc void @gd_run(i32 noundef %0, i32 noundef 1073987592, i32 noundef %1, i32 noundef %3) #5
  ret void
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !4, i64 0}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !7, !8}
!17 = distinct !{!17, !7, !8}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !7, !8}
!23 = distinct !{!23, !7, !8}
!24 = distinct !{!24, !7, !8}
!25 = distinct !{!25, !7, !8}
!26 = distinct !{!26, !7, !8}
