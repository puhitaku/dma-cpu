; ModuleID = 'dma/kfb.c'
source_filename = "dma/kfb.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@fb_on = internal unnamed_addr global i1 false, align 4
@fb_base = dso_local local_unnamed_addr global i32 0, align 4
@fb_owner = internal unnamed_addr global i32 0, align 4
@fb_ctl = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @kfb_active() local_unnamed_addr #0 {
  %1 = load i1, ptr @fb_on, align 4
  %2 = zext i1 %1 to i32
  ret i32 %2
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kfb_base() local_unnamed_addr #0 {
  %1 = load i32, ptr @fb_base, align 4, !tbaa !3
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local noundef i32 @kfb_w() local_unnamed_addr #1 {
  ret i32 640
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local noundef i32 @kfb_h() local_unnamed_addr #1 {
  ret i32 240
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kfb_owner() local_unnamed_addr #0 {
  %1 = load i32, ptr @fb_owner, align 4, !tbaa !3
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
define dso_local void @kfb_setowner(i32 noundef %0) local_unnamed_addr #2 {
  store i32 %0, ptr @fb_owner, align 4, !tbaa !3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kfb_setpan(i32 noundef %0) local_unnamed_addr #3 {
  %2 = load i1, ptr @fb_on, align 4
  br i1 %2, label %3, label %6

3:                                                ; preds = %1
  %4 = load i32, ptr @fb_ctl, align 4, !tbaa !3
  %5 = inttoptr i32 %4 to ptr
  store volatile i32 %0, ptr %5, align 4, !tbaa !3
  br label %6

6:                                                ; preds = %1, %3
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @kfb_pause() local_unnamed_addr #1 {
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @kfb_resume() local_unnamed_addr #1 {
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @kfb_syscall(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #4 {
  %5 = load i1, ptr @fb_on, align 4
  br i1 %5, label %6, label %26

6:                                                ; preds = %4
  switch i32 %0, label %26 [
    i32 0, label %7
    i32 1, label %16
    i32 2, label %22
  ]

7:                                                ; preds = %6
  %8 = icmp eq i32 %3, 0
  br i1 %8, label %9, label %26

9:                                                ; preds = %7
  %10 = inttoptr i32 %1 to ptr
  %11 = load i32, ptr @fb_base, align 4, !tbaa !3
  store i32 %11, ptr %10, align 4, !tbaa !3
  %12 = getelementptr inbounds nuw i8, ptr %10, i32 4
  store i32 640, ptr %12, align 4, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 8
  store i32 240, ptr %13, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %10, i32 12
  store i32 8, ptr %14, align 4, !tbaa !3
  %15 = getelementptr inbounds nuw i8, ptr %10, i32 16
  store i32 640, ptr %15, align 4, !tbaa !3
  br label %26

16:                                               ; preds = %6
  %17 = load i32, ptr @fb_owner, align 4, !tbaa !3
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %21, label %19

19:                                               ; preds = %16
  %20 = icmp eq i32 %17, %2
  br i1 %20, label %21, label %26

21:                                               ; preds = %19, %16
  tail call void @kfbcon_reset() #6
  store i32 %2, ptr @fb_owner, align 4, !tbaa !3
  br label %26

22:                                               ; preds = %6
  %23 = load i32, ptr @fb_owner, align 4, !tbaa !3
  %24 = icmp eq i32 %23, %2
  br i1 %24, label %25, label %26

25:                                               ; preds = %22
  store i32 0, ptr @fb_owner, align 4, !tbaa !3
  tail call void @kfbcon_reset() #6
  br label %26

26:                                               ; preds = %6, %22, %19, %7, %4, %25, %21, %9
  %27 = phi i32 [ 0, %9 ], [ 0, %21 ], [ 0, %25 ], [ -1, %4 ], [ -1, %7 ], [ -1, %19 ], [ -1, %22 ], [ -1, %6 ]
  ret i32 %27
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 151) i32 @kfb_init() local_unnamed_addr #4 {
  %1 = load i32, ptr @fb_base, align 4, !tbaa !3
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %13, label %3

3:                                                ; preds = %0
  %4 = inttoptr i32 %1 to ptr
  store volatile i32 1526618018, ptr %4, align 4, !tbaa !3
  %5 = load i32, ptr @fb_base, align 4, !tbaa !3
  %6 = inttoptr i32 %5 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !3
  %8 = icmp eq i32 %7, 1526618018
  br i1 %8, label %10, label %9

9:                                                ; preds = %3
  store i32 0, ptr @fb_base, align 4, !tbaa !3
  br label %13

10:                                               ; preds = %3
  tail call void @kdmaset(i32 noundef %5, i32 noundef 0, i32 noundef 153600) #6
  %11 = load i32, ptr @fb_ctl, align 4, !tbaa !3
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 0, ptr %12, align 4, !tbaa !3
  store i1 true, ptr @fb_on, align 4
  br label %13

13:                                               ; preds = %0, %10, %9
  %14 = phi i32 [ -1, %9 ], [ 150, %10 ], [ 0, %0 ]
  ret i32 %14
}

; Function Attrs: minsize optsize
declare dso_local void @kdmaset(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
