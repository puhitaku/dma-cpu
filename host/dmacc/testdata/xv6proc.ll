; ModuleID = 'dmacc/testdata/xv6proc.c'
source_filename = "dmacc/testdata/xv6proc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@idlecount = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [17 x i8] c"parent: waiting\0A\00", align 1
@reap_pid = dso_local global i32 0, align 4
@reap_status = dso_local global i32 0, align 4
@.str.1 = private unnamed_addr constant [16 x i8] c"parent: reaped\0A\00", align 1
@parent_done = dso_local global i32 0, align 4
@.str.2 = private unnamed_addr constant [16 x i8] c"child: exiting\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  %2 = tail call i32 @getpid() #4
  switch i32 %2, label %13 [
    i32 1, label %3
    i32 2, label %6
  ]

3:                                                ; preds = %0, %3
  %4 = load volatile i32, ptr @idlecount, align 4, !tbaa !3
  %5 = add i32 %4, 1
  store volatile i32 %5, ptr @idlecount, align 4, !tbaa !3
  br label %3, !llvm.loop !7

6:                                                ; preds = %0
  %7 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str, i32 noundef 16) #4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #5
  store i32 -1, ptr %1, align 4, !tbaa !3
  %8 = call i32 @wait(ptr noundef nonnull %1) #4
  store volatile i32 %8, ptr @reap_pid, align 4, !tbaa !3
  %9 = load i32, ptr %1, align 4, !tbaa !3
  store volatile i32 %9, ptr @reap_status, align 4, !tbaa !3
  %10 = call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.1, i32 noundef 15) #4
  %11 = call i32 @uptime() #4
  store volatile i32 %11, ptr @parent_done, align 4, !tbaa !3
  %12 = call i32 @exit(i32 noundef 0) #6
  unreachable

13:                                               ; preds = %0
  %14 = tail call i32 @pause(i32 noundef 5) #4
  %15 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.2, i32 noundef 15) #4
  %16 = tail call i32 @exit(i32 noundef 42) #6
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @wait(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @uptime() local_unnamed_addr #2

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #2

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { nounwind }
attributes #6 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.unroll.disable"}
