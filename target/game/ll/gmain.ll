; ModuleID = 'gmain.c'
source_filename = "gmain.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [16 x i8] c"GAMEPICO: boot\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"GAMEPICO: lcd up\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"GAMEPICO: fx up\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @gmain() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #2
  tail call void @lcd_init() #2
  tail call void @uputs(ptr noundef nonnull @.str.1) #2
  tail call void @fx_init() #2
  tail call void @uputs(ptr noundef nonnull @.str.2) #2
  br label %1

1:                                                ; preds = %5, %0
  %2 = tail call i32 @menu_run() #2
  switch i32 %2, label %13 [
    i32 0, label %3
    i32 1, label %4
    i32 2, label %6
    i32 3, label %7
    i32 4, label %8
    i32 5, label %9
    i32 7, label %10
    i32 8, label %11
    i32 9, label %12
  ]

3:                                                ; preds = %1
  tail call void @dino_run() #2
  br label %5

4:                                                ; preds = %1
  tail call void @lanwalk_run() #2
  br label %5

5:                                                ; preds = %4, %7, %9, %11, %13, %12, %10, %8, %6, %3
  br label %1, !llvm.loop !3

6:                                                ; preds = %1
  tail call void @yacht_run() #2
  br label %5

7:                                                ; preds = %1
  tail call void @seq_run() #2
  br label %5

8:                                                ; preds = %1
  tail call void @bench_run() #2
  br label %5

9:                                                ; preds = %1
  tail call void @radio_run() #2
  br label %5

10:                                               ; preds = %1
  tail call void @boing_run() #2
  br label %5

11:                                               ; preds = %1
  tail call void @chute_run() #2
  br label %5

12:                                               ; preds = %1
  tail call void @puni_run() #2
  br label %5

13:                                               ; preds = %1
  tail call void @cpumon_run() #2
  br label %5
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @lcd_init() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @fx_init() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @menu_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @dino_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @lanwalk_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @yacht_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @seq_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @bench_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @radio_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @boing_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @chute_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @puni_run() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @cpumon_run() local_unnamed_addr #1

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.unroll.disable"}
