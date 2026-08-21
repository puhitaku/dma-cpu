; ModuleID = 'dmacc/testdata/xv6sig.c'
source_filename = "dmacc/testdata/xv6sig.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@st1 = dso_local global i32 111, align 4
@st2 = dso_local global i32 111, align 4
@idlecnt = dso_local global i32 0, align 4
@phase = dso_local global i32 0, align 4
@vspin = dso_local global i32 0, align 4
@caught = dso_local global i32 0, align 4
@done = dso_local global i32 0, align 4

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  %2 = tail call i32 @getpid() #5
  %3 = icmp eq i32 %2, 2
  br i1 %3, label %4, label %7

4:                                                ; preds = %0, %4
  %5 = load volatile i32, ptr @idlecnt, align 4, !tbaa !3
  %6 = add i32 %5, 1
  store volatile i32 %6, ptr @idlecnt, align 4, !tbaa !3
  br label %4, !llvm.loop !7

7:                                                ; preds = %0
  store volatile i32 1, ptr @phase, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #6
  store i32 0, ptr %1, align 4, !tbaa !3
  %8 = tail call i32 @fork() #5
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %13

10:                                               ; preds = %7, %10
  %11 = load volatile i32, ptr @vspin, align 4, !tbaa !3
  %12 = add i32 %11, 1
  store volatile i32 %12, ptr @vspin, align 4, !tbaa !3
  br label %10, !llvm.loop !9

13:                                               ; preds = %7
  %14 = call i32 @wait(ptr noundef nonnull %1) #5
  %15 = load i32, ptr %1, align 4, !tbaa !3
  store volatile i32 %15, ptr @st1, align 4, !tbaa !3
  store volatile i32 2, ptr @phase, align 4, !tbaa !3
  %16 = call i32 @fork() #5
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %29

18:                                               ; preds = %13
  %19 = call i32 @signal(i32 noundef 2, ptr noundef nonnull @onint) #5
  %20 = call i32 @pause(i32 noundef 600) #5
  %21 = icmp eq i32 %20, -1
  br i1 %21, label %22, label %27

22:                                               ; preds = %18
  %23 = load volatile i32, ptr @caught, align 4, !tbaa !3
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %27, label %25

25:                                               ; preds = %22
  %26 = call i32 @exit(i32 noundef 9) #7
  unreachable

27:                                               ; preds = %22, %18
  %28 = call i32 @exit(i32 noundef 3) #7
  unreachable

29:                                               ; preds = %13
  %30 = call i32 @wait(ptr noundef nonnull %1) #5
  %31 = load i32, ptr %1, align 4, !tbaa !3
  store volatile i32 %31, ptr @st2, align 4, !tbaa !3
  store volatile i32 1, ptr @done, align 4, !tbaa !3
  br label %32

32:                                               ; preds = %32, %29
  %33 = call i32 @pause(i32 noundef 50) #5
  br label %32, !llvm.loop !10
}

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @fork() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @wait(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @signal(i32 noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define internal void @onint(i32 %0) #3 {
  %2 = load volatile i32, ptr @caught, align 4, !tbaa !3
  %3 = add i32 %2, 1
  store volatile i32 %3, ptr @caught, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #4

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #6 = { nounwind }
attributes #7 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }

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
!10 = distinct !{!10, !8}
