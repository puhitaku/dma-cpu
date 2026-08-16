; ModuleID = 'filestrput.c'
source_filename = "filestrput.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none)
define dso_local range(i32 0, 256) i32 @__file_str_put(i8 noundef signext %0, ptr noundef captures(none) %1) local_unnamed_addr #0 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %4 = load ptr, ptr %3, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 20
  %6 = load ptr, ptr %5, align 4, !tbaa !13
  %7 = icmp eq ptr %4, %6
  br i1 %7, label %10, label %8

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store ptr %9, ptr %3, align 4, !tbaa !3
  store i8 %0, ptr %4, align 1, !tbaa !14
  br label %10

10:                                               ; preds = %8, %2
  %11 = zext i8 %0 to i32
  ret i32 %11
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !10, i64 16}
!4 = !{!"__file_str", !5, i64 0, !10, i64 16, !10, i64 20, !11, i64 24, !12, i64 28}
!5 = !{!"__file", !6, i64 0, !7, i64 2, !9, i64 4, !9, i64 8, !9, i64 12}
!6 = !{!"short", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"any pointer", !7, i64 0}
!10 = !{!"p1 omnipotent char", !9, i64 0}
!11 = !{!"int", !7, i64 0}
!12 = !{!"_Bool", !7, i64 0}
!13 = !{!4, !10, i64 20}
!14 = !{!7, !7, i64 0}
