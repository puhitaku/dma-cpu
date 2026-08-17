; ModuleID = 'user/ulib.c'
source_filename = "user/ulib.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @start(i32 noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = tail call i32 @main(i32 noundef %0, ptr noundef %1) #9
  %4 = tail call i32 @exit(i32 noundef %3) #10
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @main(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @strcpy(ptr noundef returned writeonly captures(ret: address, provenance) %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #4 {
  br label %3

3:                                                ; preds = %3, %2
  %4 = phi ptr [ %1, %2 ], [ %6, %3 ]
  %5 = phi ptr [ %0, %2 ], [ %8, %3 ]
  %6 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %7 = load i8, ptr %4, align 1, !tbaa !3
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 1
  store i8 %7, ptr %5, align 1, !tbaa !3
  %9 = icmp eq i8 %7, 0
  br i1 %9, label %10, label %3, !llvm.loop !6

10:                                               ; preds = %3
  ret ptr %0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @strcmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #5 {
  br label %3

3:                                                ; preds = %11, %2
  %4 = phi ptr [ %0, %2 ], [ %12, %11 ]
  %5 = phi ptr [ %1, %2 ], [ %13, %11 ]
  %6 = load i8, ptr %4, align 1, !tbaa !3
  %7 = icmp ne i8 %6, 0
  %8 = load i8, ptr %5, align 1, !tbaa !3
  %9 = icmp eq i8 %6, %8
  %10 = select i1 %7, i1 %9, i1 false
  br i1 %10, label %11, label %14

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !9

14:                                               ; preds = %3
  %15 = zext i8 %6 to i32
  %16 = zext i8 %8 to i32
  %17 = sub nsw i32 %15, %16
  ret i32 %17
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local i32 @strlen(ptr noundef readonly captures(none) %0) local_unnamed_addr #5 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  %7 = add nuw nsw i32 %3, 1
  br i1 %6, label %8, label %2, !llvm.loop !10

8:                                                ; preds = %2
  ret i32 %3
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: write)
define dso_local noundef ptr @memset(ptr noundef returned writeonly captures(ret: address, provenance) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #6 {
  %4 = trunc i32 %1 to i8
  br label %5

5:                                                ; preds = %8, %3
  %6 = phi i32 [ 0, %3 ], [ %10, %8 ]
  %7 = icmp eq i32 %6, %2
  br i1 %7, label %11, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 %6
  store i8 %4, ptr %9, align 1, !tbaa !3
  %10 = add nuw i32 %6, 1
  br label %5, !llvm.loop !11

11:                                               ; preds = %5
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local noundef ptr @strchr(ptr noundef readonly captures(ret: address, provenance) %0, i8 noundef signext %1) local_unnamed_addr #5 {
  br label %3

3:                                                ; preds = %9, %2
  %4 = phi ptr [ %0, %2 ], [ %10, %9 ]
  %5 = load i8, ptr %4, align 1, !tbaa !3
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %11, label %7

7:                                                ; preds = %3
  %8 = icmp eq i8 %5, %1
  br i1 %8, label %11, label %9

9:                                                ; preds = %7
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 1
  br label %3, !llvm.loop !12

11:                                               ; preds = %3, %7
  %12 = phi ptr [ %4, %7 ], [ null, %3 ]
  ret ptr %12
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @gets(ptr noundef returned writeonly captures(ret: address, provenance) %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %3) #11
  br label %4

4:                                                ; preds = %11, %2
  %5 = phi i32 [ 0, %2 ], [ %6, %11 ]
  %6 = add nuw nsw i32 %5, 1
  %7 = icmp slt i32 %6, %1
  br i1 %7, label %8, label %14

8:                                                ; preds = %4
  %9 = call i32 @read(i32 noundef 0, ptr noundef nonnull %3, i32 noundef 1) #9
  %10 = icmp slt i32 %9, 1
  br i1 %10, label %14, label %11

11:                                               ; preds = %8
  %12 = load i8, ptr %3, align 1, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %0, i32 %5
  store i8 %12, ptr %13, align 1, !tbaa !3
  switch i8 %12, label %4 [
    i8 10, label %14
    i8 13, label %14
  ]

14:                                               ; preds = %11, %11, %8, %4
  %15 = phi i32 [ %5, %8 ], [ %6, %11 ], [ %5, %4 ], [ %6, %11 ]
  %16 = getelementptr inbounds i8, ptr %0, i32 %15
  store i8 0, ptr %16, align 1, !tbaa !3
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %3) #11
  ret ptr %0
}

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local i32 @stat(ptr noundef %0, ptr noundef %1) local_unnamed_addr #7 {
  %3 = tail call i32 @open(ptr noundef %0, i32 noundef 0) #9
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %8, label %5

5:                                                ; preds = %2
  %6 = tail call i32 @fstat(i32 noundef %3, ptr noundef %1) #9
  %7 = tail call i32 @close(i32 noundef %3) #9
  br label %8

8:                                                ; preds = %2, %5
  %9 = phi i32 [ %6, %5 ], [ -1, %2 ]
  ret i32 %9
}

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local i32 @atoi(ptr noundef readonly captures(none) %0) local_unnamed_addr #5 {
  br label %2

2:                                                ; preds = %8, %1
  %3 = phi ptr [ %0, %1 ], [ %11, %8 ]
  %4 = phi i32 [ 0, %1 ], [ %13, %8 ]
  %5 = load i8, ptr %3, align 1, !tbaa !3
  %6 = add i8 %5, -48
  %7 = icmp ult i8 %6, 10
  br i1 %7, label %8, label %14

8:                                                ; preds = %2
  %9 = zext nneg i8 %5 to i32
  %10 = mul nsw i32 %4, 10
  %11 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %12 = add i32 %10, -48
  %13 = add i32 %12, %9
  br label %2, !llvm.loop !13

14:                                               ; preds = %2
  ret i32 %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memmove(ptr noundef returned writeonly captures(address, ret: address, provenance) %0, ptr noundef readonly captures(address) %1, i32 noundef %2) local_unnamed_addr #4 {
  %4 = icmp ugt ptr %1, %0
  br i1 %4, label %5, label %15

5:                                                ; preds = %3, %10
  %6 = phi i32 [ %11, %10 ], [ %2, %3 ]
  %7 = phi ptr [ %14, %10 ], [ %0, %3 ]
  %8 = phi ptr [ %12, %10 ], [ %1, %3 ]
  %9 = icmp sgt i32 %6, 0
  br i1 %9, label %10, label %28

10:                                               ; preds = %5
  %11 = add nsw i32 %6, -1
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 1
  %13 = load i8, ptr %8, align 1, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 1
  store i8 %13, ptr %7, align 1, !tbaa !3
  br label %5, !llvm.loop !14

15:                                               ; preds = %3
  %16 = getelementptr inbounds i8, ptr %0, i32 %2
  %17 = getelementptr inbounds i8, ptr %1, i32 %2
  br label %18

18:                                               ; preds = %23, %15
  %19 = phi i32 [ %2, %15 ], [ %24, %23 ]
  %20 = phi ptr [ %16, %15 ], [ %27, %23 ]
  %21 = phi ptr [ %17, %15 ], [ %25, %23 ]
  %22 = icmp sgt i32 %19, 0
  br i1 %22, label %23, label %28

23:                                               ; preds = %18
  %24 = add nsw i32 %19, -1
  %25 = getelementptr inbounds i8, ptr %21, i32 -1
  %26 = load i8, ptr %25, align 1, !tbaa !3
  %27 = getelementptr inbounds i8, ptr %20, i32 -1
  store i8 %26, ptr %27, align 1, !tbaa !3
  br label %18, !llvm.loop !15

28:                                               ; preds = %18, %5
  ret ptr %0
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local range(i32 -255, 256) i32 @memcmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) local_unnamed_addr #5 {
  br label %4

4:                                                ; preds = %18, %3
  %5 = phi i32 [ %2, %3 ], [ %8, %18 ]
  %6 = phi ptr [ %0, %3 ], [ %19, %18 ]
  %7 = phi ptr [ %1, %3 ], [ %20, %18 ]
  %8 = add i32 %5, -1
  %9 = icmp eq i32 %5, 0
  br i1 %9, label %21, label %10

10:                                               ; preds = %4
  %11 = load i8, ptr %6, align 1, !tbaa !3
  %12 = load i8, ptr %7, align 1, !tbaa !3
  %13 = icmp eq i8 %11, %12
  br i1 %13, label %18, label %14

14:                                               ; preds = %10
  %15 = sext i8 %12 to i32
  %16 = sext i8 %11 to i32
  %17 = sub nsw i32 %16, %15
  br label %21

18:                                               ; preds = %10
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %20 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %4, !llvm.loop !16

21:                                               ; preds = %4, %14
  %22 = phi i32 [ %17, %14 ], [ 0, %4 ]
  ret i32 %22
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define dso_local noundef ptr @memcpy(ptr noundef returned captures(address, ret: address, provenance) %0, ptr noundef readonly captures(address) %1, i32 noundef %2) local_unnamed_addr #4 {
  %4 = tail call ptr @memmove(ptr noundef %0, ptr noundef %1, i32 noundef %2) #12
  ret ptr %0
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @sbrk(i32 noundef %0) local_unnamed_addr #7 {
  %2 = tail call ptr @sys_sbrk(i32 noundef %0, i32 noundef 1) #9
  ret ptr %2
}

; Function Attrs: minsize optsize
declare dso_local ptr @sys_sbrk(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local ptr @sbrklazy(i32 noundef %0) local_unnamed_addr #7 {
  %2 = tail call ptr @sys_sbrk(i32 noundef %0, i32 noundef 2) #9
  ret ptr %2
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fputstr(i32 noundef %0, ptr noundef %1) local_unnamed_addr #7 {
  br label %3

3:                                                ; preds = %3, %2
  %4 = phi i32 [ 0, %2 ], [ %8, %3 ]
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 %4
  %6 = load i8, ptr %5, align 1, !tbaa !3
  %7 = icmp eq i8 %6, 0
  %8 = add nuw nsw i32 %4, 1
  br i1 %7, label %9, label %3, !llvm.loop !17

9:                                                ; preds = %3
  %10 = tail call i32 @write(i32 noundef %0, ptr noundef nonnull %1, i32 noundef %4) #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define dso_local void @fputnum(i32 noundef %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %3) #11
  %4 = tail call i32 @llvm.abs.i32(i32 %1, i1 true)
  br label %5

5:                                                ; preds = %5, %2
  %6 = phi i32 [ 12, %2 ], [ %14, %5 ]
  %7 = phi i32 [ %4, %2 ], [ %9, %5 ]
  %8 = freeze i32 %7
  %9 = udiv i32 %8, 10
  %10 = mul i32 %9, 10
  %11 = sub i32 %8, %10
  %12 = trunc nuw nsw i32 %11 to i8
  %13 = or disjoint i8 %12, 48
  %14 = add nsw i32 %6, -1
  %15 = getelementptr inbounds [12 x i8], ptr %3, i32 0, i32 %14
  store i8 %13, ptr %15, align 1, !tbaa !3
  %16 = icmp samesign ult i32 %7, 10
  br i1 %16, label %17, label %5, !llvm.loop !18

17:                                               ; preds = %5
  %18 = icmp slt i32 %1, 0
  br i1 %18, label %19, label %22

19:                                               ; preds = %17
  %20 = add nsw i32 %6, -2
  %21 = getelementptr inbounds [12 x i8], ptr %3, i32 0, i32 %20
  store i8 45, ptr %21, align 1, !tbaa !3
  br label %22

22:                                               ; preds = %19, %17
  %23 = phi i32 [ %20, %19 ], [ %14, %17 ]
  %24 = getelementptr inbounds i8, ptr %3, i32 %23
  %25 = sub nsw i32 12, %23
  %26 = call i32 @write(i32 noundef %0, ptr noundef nonnull %24, i32 noundef %25) #9
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %3) #11
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.abs.i32(i32, i1 immarg) #8

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: write) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #10 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #11 = { nounwind }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }

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
!9 = distinct !{!9, !7, !8}
!10 = distinct !{!10, !7, !8}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !7, !8}
!17 = distinct !{!17, !7, !8}
!18 = distinct !{!18, !7, !8}
