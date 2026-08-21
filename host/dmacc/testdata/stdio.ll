; ModuleID = 'stdio.c'
source_filename = "stdio.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@base = dso_local global i32 100, align 4
@.str = private unnamed_addr constant [26 x i8] c"stdio on the DMA machine\0A\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"i=%d v=%d u=%u x=%x c=%c\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"[%06d|%-8s|%04x]\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"acc=%d\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local noundef range(i32 0, -2147483648) i32 @main() local_unnamed_addr #0 {
  %1 = alloca [48 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %1) #3
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str) #4
  br label %3

3:                                                ; preds = %15, %0
  %4 = phi i32 [ 0, %0 ], [ %25, %15 ]
  %5 = phi i32 [ 0, %0 ], [ %24, %15 ]
  %6 = icmp eq i32 %4, 5
  br i1 %6, label %7, label %15

7:                                                ; preds = %3
  %8 = call i32 (ptr, i32, ptr, ...) @snprintf(ptr noundef nonnull %1, i32 noundef 48, ptr noundef nonnull @.str.2, i32 noundef -1234, ptr noundef nonnull @.str.3, i32 noundef 49374) #4
  %9 = call i32 @puts(ptr noundef nonnull %1) #4
  %10 = call i32 @strlen(ptr noundef nonnull %1) #4
  %11 = add i32 %8, %5
  %12 = add i32 %11, %10
  %13 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.4, i32 noundef %12) #4
  %14 = and i32 %12, 2147483647
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %1) #3
  ret i32 %14

15:                                               ; preds = %3
  %16 = load volatile i32, ptr @base, align 4, !tbaa !3
  %17 = add nsw i32 %16, %4
  %18 = add nsw i32 %4, -2
  %19 = mul nsw i32 %17, %18
  %20 = and i32 %19, 4095
  %21 = add nuw nsw i32 %4, 97
  %22 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.1, i32 noundef %4, i32 noundef %19, i32 noundef %19, i32 noundef %20, i32 noundef %21) #4
  %23 = mul nsw i32 %5, 31
  %24 = add nsw i32 %19, %23
  %25 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !7
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @printf(ptr noundef, ...) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @snprintf(ptr noundef, i32 noundef, ptr noundef, ...) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @puts(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @strlen(ptr noundef) local_unnamed_addr #2

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nounwind }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
