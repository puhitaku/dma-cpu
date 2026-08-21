; ModuleID = 'dmacc/testdata/xv6spawn.c'
source_filename = "dmacc/testdata/xv6spawn.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@idlecount = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [18 x i8] c"parent: spawning\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"exec failed\0A\00", align 1
@spawn_pid = dso_local global i32 0, align 4
@reap_pid = dso_local global i32 0, align 4
@reap_status = dso_local global i32 0, align 4
@.str.3 = private unnamed_addr constant [16 x i8] c"parent: reaped\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  %2 = tail call i32 @getpid() #4
  %3 = icmp eq i32 %2, 1
  br i1 %3, label %4, label %7

4:                                                ; preds = %0, %4
  %5 = load volatile i32, ptr @idlecount, align 4, !tbaa !3
  %6 = add i32 %5, 1
  store volatile i32 %6, ptr @idlecount, align 4, !tbaa !3
  br label %4, !llvm.loop !7

7:                                                ; preds = %0
  %8 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str, i32 noundef 17) #4
  %9 = tail call i32 @fork() #4
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %15

11:                                               ; preds = %7
  %12 = tail call i32 @exec(ptr noundef nonnull @.str.1, ptr noundef null) #4
  %13 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.2, i32 noundef 12) #4
  %14 = tail call i32 @exit(i32 noundef 111) #5
  unreachable

15:                                               ; preds = %7
  store volatile i32 %9, ptr @spawn_pid, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #6
  store i32 -1, ptr %1, align 4, !tbaa !3
  %16 = call i32 @wait(ptr noundef nonnull %1) #4
  store volatile i32 %16, ptr @reap_pid, align 4, !tbaa !3
  %17 = load i32, ptr %1, align 4, !tbaa !3
  store volatile i32 %17, ptr @reap_status, align 4, !tbaa !3
  %18 = call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.3, i32 noundef 15) #4
  br label %19

19:                                               ; preds = %19, %15
  %20 = call i32 @pause(i32 noundef 100) #4
  br label %19, !llvm.loop !9
}

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @fork() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @exec(ptr noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @wait(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #6 = { nounwind }

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
!9 = distinct !{!9, !8}
