; ModuleID = 'user/cat.c'
source_filename = "user/cat.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@buf = dso_local global [512 x i8] zeroinitializer, align 1
@.str = private unnamed_addr constant [18 x i8] c"cat: write error\0A\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"cat: read error\0A\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"cat: cannot open \00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @cat(i32 noundef %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %5, %1
  %3 = tail call i32 @read(i32 noundef %0, ptr noundef nonnull @buf, i32 noundef 512) #4
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %5, label %10

5:                                                ; preds = %2
  %6 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @buf, i32 noundef %3) #4
  %7 = icmp eq i32 %6, %3
  br i1 %7, label %2, label %8, !llvm.loop !3

8:                                                ; preds = %5
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str) #4
  %9 = tail call i32 @exit(i32 noundef 1) #5
  unreachable

10:                                               ; preds = %2
  %11 = icmp slt i32 %3, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %10
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.1) #4
  %13 = tail call i32 @exit(i32 noundef 1) #5
  unreachable

14:                                               ; preds = %10
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #3 {
  %3 = icmp slt i32 %0, 2
  br i1 %3, label %4, label %6

4:                                                ; preds = %2
  tail call void @cat(i32 noundef 0) #6
  %5 = tail call i32 @exit(i32 noundef 0) #5
  unreachable

6:                                                ; preds = %2, %17
  %7 = phi i32 [ %19, %17 ], [ 1, %2 ]
  %8 = icmp eq i32 %7, %0
  br i1 %8, label %20, label %9

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw ptr, ptr %1, i32 %7
  %11 = load ptr, ptr %10, align 4, !tbaa !6
  %12 = tail call i32 @open(ptr noundef %11, i32 noundef 0) #4
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %17

14:                                               ; preds = %9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.2) #4
  %15 = load ptr, ptr %10, align 4, !tbaa !6
  tail call void @fputstr(i32 noundef 2, ptr noundef %15) #4
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.3) #4
  %16 = tail call i32 @exit(i32 noundef 1) #5
  unreachable

17:                                               ; preds = %9
  tail call void @cat(i32 noundef %12) #6
  %18 = tail call i32 @close(i32 noundef %12) #4
  %19 = add nuw i32 %7, 1
  br label %6, !llvm.loop !11

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
!7 = !{!"p1 omnipotent char", !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !{!11, !4, !5}
