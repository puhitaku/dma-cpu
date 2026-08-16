; ModuleID = 'dmacc/testdata/xv6sys.c'
source_filename = "dmacc/testdata/xv6sys.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [32 x i8] c"hello from pid 1 via SYS_write\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"pid 1 saw the clock advance\0A\00", align 1
@donetick = dso_local global i32 0, align 4
@.str.2 = private unnamed_addr constant [15 x i8] c"pid 1 exiting\0A\00", align 1
@bgcount = dso_local global i32 0, align 4

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = tail call i32 @getpid() #3
  %2 = icmp eq i32 %1, 1
  br i1 %2, label %3, label %17

3:                                                ; preds = %0
  %4 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str, i32 noundef 31) #3
  %5 = tail call i32 @uptime() #3
  %6 = add i32 %5, 4
  br label %7

7:                                                ; preds = %7, %3
  %8 = tail call i32 @uptime() #3
  %9 = icmp ult i32 %8, %6
  br i1 %9, label %7, label %10, !llvm.loop !3

10:                                               ; preds = %7
  %11 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.1, i32 noundef 28) #3
  %12 = tail call i32 @pause(i32 noundef 0) #3
  %13 = tail call i32 @pause(i32 noundef 0) #3
  %14 = tail call i32 @uptime() #3
  store volatile i32 %14, ptr @donetick, align 4, !tbaa !6
  %15 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.2, i32 noundef 14) #3
  %16 = tail call i32 @exit(i32 noundef 0) #4
  unreachable

17:                                               ; preds = %0, %25
  %18 = load volatile i32, ptr @bgcount, align 4, !tbaa !6
  %19 = add i32 %18, 1
  store volatile i32 %19, ptr @bgcount, align 4, !tbaa !6
  %20 = load volatile i32, ptr @bgcount, align 4, !tbaa !6
  %21 = and i32 %20, 4095
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %23, label %25

23:                                               ; preds = %17
  %24 = tail call i32 @pause(i32 noundef 0) #3
  br label %25

25:                                               ; preds = %23, %17
  br label %17, !llvm.loop !10
}

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @uptime() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #2

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #4 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !5}
