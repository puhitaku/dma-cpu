; ModuleID = 'lcd.c'
source_filename = "lcd.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@lcd_init.pgam = internal unnamed_addr constant [14 x i8] c"\D0\04\0D\11\13+?TL\18\0D\0B\1F#", align 1
@lcd_init.ngam = internal unnamed_addr constant [14 x i8] c"\D0\04\0C\11\13,?DQ/\1F\1F #", align 1
@fb = external dso_local global [57600 x i16], align 2
@spi16 = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local void @lcd_init() local_unnamed_addr #0 {
  store volatile i32 0, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  store volatile i32 4, ptr inttoptr (i32 1073987600 to ptr), align 16, !tbaa !3
  store volatile i32 199, ptr inttoptr (i32 1073987584 to ptr), align 16384, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987620 to ptr), align 4, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  tail call void @gpio_fn(i32 noundef 18, i32 noundef 1) #4
  tail call void @gpio_fn(i32 noundef 19, i32 noundef 1) #4
  tail call void @gpio_out(i32 noundef 17, i32 noundef 0) #4
  tail call void @gpio_out(i32 noundef 16, i32 noundef 1) #4
  tail call void @gpio_out(i32 noundef 21, i32 noundef 0) #4
  tail call void @gpio_out(i32 noundef 20, i32 noundef 0) #4
  tail call void @delay_us(i32 noundef 20000) #4
  tail call void @gpio_out(i32 noundef 20, i32 noundef 1) #4
  tail call void @delay_us(i32 noundef 120000) #4
  tail call fastcc void @lcd_cmd(i32 noundef 17) #5
  tail call void @delay_us(i32 noundef 120000) #4
  tail call fastcc void @lcd_cmd(i32 noundef 58) #5
  tail call fastcc void @spi_put8(i32 noundef 85) #5
  tail call fastcc void @lcd_cmd(i32 noundef 54) #5
  tail call fastcc void @spi_put8(i32 noundef 0) #5
  tail call fastcc void @lcd_cmd(i32 noundef 33) #5
  tail call fastcc void @lcd_cmd(i32 noundef 224) #5
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %9, %5 ]
  %3 = icmp eq i32 %2, 14
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  tail call fastcc void @lcd_cmd(i32 noundef 225) #5
  br label %10

5:                                                ; preds = %1
  %6 = getelementptr inbounds nuw [14 x i8], ptr @lcd_init.pgam, i32 0, i32 %2
  %7 = load i8, ptr %6, align 1, !tbaa !7
  %8 = zext i8 %7 to i32
  tail call fastcc void @spi_put8(i32 noundef %8) #5
  %9 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !8

10:                                               ; preds = %14, %4
  %11 = phi i32 [ 0, %4 ], [ %18, %14 ]
  %12 = icmp eq i32 %11, 14
  br i1 %12, label %13, label %14

13:                                               ; preds = %10
  tail call fastcc void @lcd_cmd(i32 noundef 38) #5
  tail call fastcc void @spi_put8(i32 noundef 8) #5
  tail call fastcc void @lcd_cmd(i32 noundef 19) #5
  tail call void @lcd_flush(i32 noundef 0, i32 noundef 0, i32 noundef 239, i32 noundef 239) #5
  tail call fastcc void @lcd_cmd(i32 noundef 41) #5
  tail call void @delay_us(i32 noundef 20000) #4
  tail call void @gpio_out(i32 noundef 21, i32 noundef 1) #4
  ret void

14:                                               ; preds = %10
  %15 = getelementptr inbounds nuw [14 x i8], ptr @lcd_init.ngam, i32 0, i32 %11
  %16 = load i8, ptr %15, align 1, !tbaa !7
  %17 = zext i8 %16 to i32
  tail call fastcc void @spi_put8(i32 noundef %17) #5
  %18 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !11
}

; Function Attrs: minsize optsize
declare dso_local void @gpio_fn(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gpio_out(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @delay_us(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @lcd_cmd(i32 noundef range(i32 17, 226) %0) unnamed_addr #0 {
  tail call void @gd_wait() #4
  %2 = load i32, ptr @spi16, align 4, !tbaa !3
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %1
  tail call fastcc void @spi_bits(i32 noundef 8) #5
  br label %5

5:                                                ; preds = %4, %1
  tail call fastcc void @spi_wait_idle() #5
  tail call void @gpio_out(i32 noundef 16, i32 noundef 0) #4
  tail call fastcc void @spi_put8(i32 noundef %0) #5
  tail call fastcc void @spi_wait_idle() #5
  tail call void @gpio_out(i32 noundef 16, i32 noundef 1) #4
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @lcd_flush(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #0 {
  %5 = icmp slt i32 %2, %0
  br i1 %5, label %25, label %6

6:                                                ; preds = %4
  %7 = icmp slt i32 %3, %1
  br i1 %7, label %25, label %8

8:                                                ; preds = %6
  %9 = tail call i32 @llvm.smax.i32(i32 %0, i32 0)
  %10 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %11 = tail call i32 @llvm.smin.i32(i32 %2, i32 239)
  %12 = tail call i32 @llvm.smin.i32(i32 %3, i32 239)
  %13 = sub nsw i32 %11, %9
  %14 = icmp sgt i32 %13, 118
  %15 = select i1 %14, i32 0, i32 %9
  %16 = select i1 %14, i32 239, i32 %11
  tail call fastcc void @lcd_cmd(i32 noundef 42) #5
  tail call fastcc void @spi_put8(i32 noundef 0) #5
  tail call fastcc void @spi_put8(i32 noundef %15) #5
  tail call fastcc void @spi_put8(i32 noundef 0) #5
  tail call fastcc void @spi_put8(i32 noundef %16) #5
  tail call fastcc void @lcd_cmd(i32 noundef 43) #5
  tail call fastcc void @spi_put8(i32 noundef 0) #5
  tail call fastcc void @spi_put8(i32 noundef %10) #5
  tail call fastcc void @spi_put8(i32 noundef 0) #5
  tail call fastcc void @spi_put8(i32 noundef %12) #5
  tail call fastcc void @lcd_cmd(i32 noundef 44) #5
  tail call fastcc void @spi_bits(i32 noundef 16) #5
  %17 = mul nuw nsw i32 %10, 240
  %18 = add nuw nsw i32 %15, %17
  %19 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %18
  %20 = ptrtoint ptr %19 to i32
  %21 = sub i32 %16, %15
  %22 = add i32 %21, 1
  %23 = sub i32 %12, %10
  %24 = add i32 %23, 1
  tail call void @gdma_spi_rows(i32 noundef %20, i32 noundef %22, i32 noundef %24, i32 noundef 480) #4
  br label %25

25:                                               ; preds = %4, %6, %8
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @spi_bits(i32 noundef range(i32 8, 17) %0) unnamed_addr #2 {
  %2 = icmp eq i32 %0, 16
  %3 = zext i1 %2 to i32
  store i32 %3, ptr @spi16, align 4, !tbaa !3
  tail call fastcc void @spi_wait_idle() #5
  store volatile i32 0, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  %4 = add nsw i32 %0, -1
  %5 = or i32 %4, 192
  store volatile i32 %5, ptr inttoptr (i32 1073987584 to ptr), align 16384, !tbaa !3
  store volatile i32 2, ptr inttoptr (i32 1073987588 to ptr), align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_spi_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gd_wait() local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @spi_wait_idle() unnamed_addr #2 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = load volatile i32, ptr inttoptr (i32 1073987596 to ptr), align 4, !tbaa !3
  %3 = and i32 %2, 16
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %1, !llvm.loop !12

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
  br i1 %5, label %2, label %6, !llvm.loop !13

6:                                                ; preds = %2
  %7 = and i32 %0, 255
  store volatile i32 %7, ptr inttoptr (i32 1073987592 to ptr), align 8, !tbaa !3
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }

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
