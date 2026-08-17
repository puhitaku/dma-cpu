; ModuleID = 'user/wc.c'
source_filename = "user/wc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@buf = dso_local global [512 x i8] zeroinitializer, align 1
@.str = private unnamed_addr constant [6 x i8] c" \0D\09\0A\0B\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"wc: read error\0A\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"%d %d %d %s\0A\00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.4 = private unnamed_addr constant [20 x i8] c"wc: cannot open %s\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @wc(i32 noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  br label %5

3:                                                ; preds = %12
  %4 = add i32 %10, %8
  br label %5, !llvm.loop !3

5:                                                ; preds = %3, %2
  %6 = phi i32 [ 0, %2 ], [ %14, %3 ]
  %7 = phi i32 [ 0, %2 ], [ %15, %3 ]
  %8 = phi i32 [ 0, %2 ], [ %4, %3 ]
  %9 = phi i32 [ 0, %2 ], [ %16, %3 ]
  %10 = tail call i32 @read(i32 noundef %0, ptr noundef nonnull @buf, i32 noundef 512) #4
  %11 = icmp sgt i32 %10, 0
  br i1 %11, label %12, label %31

12:                                               ; preds = %5, %18
  %13 = phi i32 [ %30, %18 ], [ 0, %5 ]
  %14 = phi i32 [ %23, %18 ], [ %6, %5 ]
  %15 = phi i32 [ %28, %18 ], [ %7, %5 ]
  %16 = phi i32 [ %29, %18 ], [ %9, %5 ]
  %17 = icmp eq i32 %13, %10
  br i1 %17, label %3, label %18

18:                                               ; preds = %12
  %19 = getelementptr inbounds nuw [512 x i8], ptr @buf, i32 0, i32 %13
  %20 = load i8, ptr %19, align 1, !tbaa !6
  %21 = icmp eq i8 %20, 10
  %22 = zext i1 %21 to i32
  %23 = add nsw i32 %14, %22
  %24 = tail call ptr @strchr(ptr noundef nonnull @.str, i8 noundef signext %20) #4
  %25 = icmp eq ptr %24, null
  %26 = xor i32 %16, 1
  %27 = select i1 %25, i32 %26, i32 0
  %28 = add nsw i32 %27, %15
  %29 = zext i1 %25 to i32
  %30 = add nuw i32 %13, 1
  br label %12, !llvm.loop !9

31:                                               ; preds = %5
  %32 = icmp slt i32 %10, 0
  br i1 %32, label %33, label %35

33:                                               ; preds = %31
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.1) #4
  %34 = tail call i32 @exit(i32 noundef 1) #5
  unreachable

35:                                               ; preds = %31
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.2, i32 noundef %6, i32 noundef %7, i32 noundef %8, ptr noundef %1) #4
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local ptr @strchr(ptr noundef, i8 noundef signext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @printf(ptr noundef, ...) local_unnamed_addr #1

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #3 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  tail call void @wc(i32 noundef 0, ptr noundef nonnull @.str.3) #6
  %5 = tail call i32 @exit(i32 noundef 0) #5
  unreachable

6:                                                ; preds = %2, %17
  %7 = phi i32 [ %19, %17 ], [ 1, %2 ]
  %8 = icmp eq i32 %7, %0
  br i1 %8, label %20, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw ptr, ptr %1, i32 %7
  %11 = load ptr, ptr %10, align 4, !tbaa !10
  %12 = tail call i32 @open(ptr noundef %11, i32 noundef 0) #4
  %13 = icmp slt i32 %12, 0
  %14 = load ptr, ptr %10, align 4, !tbaa !10
  br i1 %13, label %15, label %17

15:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.4, ptr noundef %14) #4
  %16 = tail call i32 @exit(i32 noundef 1) #5
  unreachable

17:                                               ; preds = %9
  tail call void @wc(i32 noundef %12, ptr noundef %14) #6
  %18 = tail call i32 @close(i32 noundef %12) #4
  %19 = add nuw i32 %7, 1
  br label %6, !llvm.loop !13

20:                                               ; preds = %6
  %21 = tail call i32 @exit(i32 noundef 0) #5
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #6 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !4, !5}
!10 = !{!11, !11, i64 0}
!11 = !{!"p1 omnipotent char", !12, i64 0}
!12 = !{!"any pointer", !7, i64 0}
!13 = distinct !{!13, !4, !5}
