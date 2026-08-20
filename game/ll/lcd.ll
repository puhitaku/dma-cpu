; ModuleID = 'lcd.c'
source_filename = "lcd.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fb = external dso_local global [57600 x i16], align 2

; Function Attrs: minsize nounwind optsize
define dso_local void @lcd_init() local_unnamed_addr #0 {
  store volatile i32 0, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987600 to ptr), align 16, !tbaa !3
  store volatile i32 7, ptr inttoptr (i32 1073987584 to ptr), align 16384, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987620 to ptr), align 4, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  tail call void @gpio_fn(i32 noundef 18, i32 noundef 1) #3
  tail call void @gpio_fn(i32 noundef 19, i32 noundef 1) #3
  tail call void @gpio_out(i32 noundef 17, i32 noundef 0) #3
  tail call void @gpio_out(i32 noundef 16, i32 noundef 1) #3
  tail call void @gpio_out(i32 noundef 21, i32 noundef 1) #3
  tail call void @gpio_out(i32 noundef 20, i32 noundef 0) #3
  tail call void @delay_us(i32 noundef 20000) #3
  tail call void @gpio_out(i32 noundef 20, i32 noundef 1) #3
  tail call void @delay_us(i32 noundef 120000) #3
  tail call fastcc void @lcd_cmd(i32 noundef 17) #4
  tail call void @delay_us(i32 noundef 120000) #3
  tail call fastcc void @lcd_cmd(i32 noundef 58) #4
  tail call fastcc void @spi_put8(i32 noundef 85) #4
  tail call fastcc void @lcd_cmd(i32 noundef 54) #4
  tail call fastcc void @spi_put8(i32 noundef 0) #4
  tail call fastcc void @lcd_cmd(i32 noundef 33) #4
  tail call fastcc void @lcd_cmd(i32 noundef 19) #4
  tail call fastcc void @lcd_cmd(i32 noundef 41) #4
  tail call void @delay_us(i32 noundef 20000) #3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gpio_fn(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gpio_out(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @delay_us(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @lcd_cmd(i32 noundef range(i32 17, 59) %0) unnamed_addr #0 {
  tail call fastcc void @spi_wait_idle() #4
  tail call void @gpio_out(i32 noundef 16, i32 noundef 0) #3
  tail call fastcc void @spi_put8(i32 noundef %0) #4
  tail call fastcc void @spi_wait_idle() #4
  tail call void @gpio_out(i32 noundef 16, i32 noundef 1) #3
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @lcd_flush(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #0 {
  tail call fastcc void @lcd_cmd(i32 noundef 42) #4
  %5 = lshr i32 %0, 8
  tail call fastcc void @spi_put8(i32 noundef %5) #4
  tail call fastcc void @spi_put8(i32 noundef %0) #4
  %6 = lshr i32 %2, 8
  tail call fastcc void @spi_put8(i32 noundef %6) #4
  tail call fastcc void @spi_put8(i32 noundef %2) #4
  tail call fastcc void @lcd_cmd(i32 noundef 43) #4
  %7 = lshr i32 %1, 8
  tail call fastcc void @spi_put8(i32 noundef %7) #4
  tail call fastcc void @spi_put8(i32 noundef %1) #4
  %8 = lshr i32 %3, 8
  tail call fastcc void @spi_put8(i32 noundef %8) #4
  tail call fastcc void @spi_put8(i32 noundef %3) #4
  tail call fastcc void @lcd_cmd(i32 noundef 44) #4
  tail call fastcc void @spi_bits(i32 noundef 16) #4
  %9 = sub i32 %2, %0
  %10 = add i32 %9, 1
  br label %11

11:                                               ; preds = %15, %4
  %12 = phi i32 [ %1, %4 ], [ %20, %15 ]
  %13 = icmp sgt i32 %12, %3
  br i1 %13, label %14, label %15

14:                                               ; preds = %11
  tail call fastcc void @spi_bits(i32 noundef 8) #4
  ret void

15:                                               ; preds = %11
  %16 = mul nsw i32 %12, 240
  %17 = add nsw i32 %16, %0
  %18 = getelementptr inbounds [57600 x i16], ptr @fb, i32 0, i32 %17
  %19 = ptrtoint ptr %18 to i32
  tail call void @gdma_spi16(i32 noundef %19, i32 noundef %10) #3
  %20 = add nsw i32 %12, 1
  br label %11, !llvm.loop !7
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @spi_bits(i32 noundef range(i32 8, 17) %0) unnamed_addr #2 {
  tail call fastcc void @spi_wait_idle() #4
  store volatile i32 0, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  %2 = add nsw i32 %0, -1
  store volatile i32 %2, ptr inttoptr (i32 1073987584 to ptr), align 16384, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_spi16(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @spi_wait_idle() unnamed_addr #2 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = load volatile i32, ptr inttoptr (i32 1073987596 to ptr), align 4, !tbaa !3
  %3 = and i32 %2, 16
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %1, !llvm.loop !10

5:                                                ; preds = %1
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @spi_put8(i32 noundef %0) unnamed_addr #2 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = load volatile i32, ptr inttoptr (i32 1073987596 to ptr), align 4, !tbaa !3
  %4 = and i32 %3, 2
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %2, label %6, !llvm.loop !11

6:                                                ; preds = %2
  %7 = and i32 %0, 255
  store volatile i32 %7, ptr inttoptr (i32 1073987592 to ptr), align 8, !tbaa !3
  ret void
}

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }

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
