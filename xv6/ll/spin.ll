; ModuleID = 'dma/spin.c'
source_filename = "dma/spin.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [11 x i8] c"spin: pid \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c".\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca [16 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %1) #3
  %2 = tail call i32 @getpid() #4
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 15
  store i8 10, ptr %3, align 1, !tbaa !3
  br label %4

4:                                                ; preds = %4, %0
  %5 = phi i32 [ %2, %0 ], [ %8, %4 ]
  %6 = phi i32 [ 15, %0 ], [ %13, %4 ]
  %7 = freeze i32 %5
  %8 = sdiv i32 %7, 10
  %9 = mul i32 %8, 10
  %10 = sub i32 %7, %9
  %11 = trunc nsw i32 %10 to i8
  %12 = add nsw i8 %11, 48
  %13 = add nsw i32 %6, -1
  %14 = getelementptr inbounds [16 x i8], ptr %1, i32 0, i32 %13
  store i8 %12, ptr %14, align 1, !tbaa !3
  %15 = add i32 %5, 9
  %16 = icmp ult i32 %15, 19
  br i1 %16, label %17, label %4, !llvm.loop !6

17:                                               ; preds = %4
  %18 = getelementptr inbounds [16 x i8], ptr %1, i32 0, i32 %13
  %19 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @.str, i32 noundef 10) #4
  %20 = sub nsw i32 17, %6
  %21 = call i32 @write(i32 noundef 1, ptr noundef nonnull %18, i32 noundef %20) #4
  br label %22

22:                                               ; preds = %22, %17
  %23 = call i32 @pause(i32 noundef 20) #4
  %24 = call i32 @write(i32 noundef 1, ptr noundef nonnull @.str.1, i32 noundef 1) #4
  br label %22, !llvm.loop !9
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #2

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = distinct !{!9, !8}
