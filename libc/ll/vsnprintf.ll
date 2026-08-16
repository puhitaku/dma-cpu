; ModuleID = 'vsnprintf.c'
source_filename = "vsnprintf.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.__file_str = type { %struct.__file, ptr, ptr, i32, i8 }
%struct.__file = type { i16, i8, ptr, ptr, ptr }

; Function Attrs: minsize nounwind optsize
define dso_local i32 @vsnprintf(ptr noundef %0, i32 noundef %1, ptr noundef %2, [1 x i32] %3) local_unnamed_addr #0 {
  %5 = alloca %struct.__file_str, align 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %5) #4
  store i16 0, ptr %5, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 2
  store i8 2, ptr %6, align 2, !tbaa !9
  %7 = getelementptr inbounds nuw i8, ptr %5, i32 3
  store i8 0, ptr %7, align 1
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr @__file_str_put, ptr %8, align 4, !tbaa !10
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 8
  store ptr null, ptr %9, align 4, !tbaa !11
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store ptr null, ptr %10, align 4, !tbaa !12
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store ptr %0, ptr %11, align 4, !tbaa !13
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 20
  %13 = icmp slt i32 %1, 0
  %14 = icmp eq i32 %1, 0
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 %1
  %16 = getelementptr inbounds i8, ptr %15, i32 -1
  %17 = select i1 %14, ptr %0, ptr %16
  %18 = select i1 %13, ptr null, ptr %17
  store ptr %18, ptr %12, align 4, !tbaa !18
  %19 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 0, ptr %19, align 4, !tbaa !19
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i8 0, ptr %20, align 4, !tbaa !20
  %21 = getelementptr inbounds nuw i8, ptr %5, i32 29
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %21, i8 0, i64 3, i1 false)
  %22 = call i32 @vfprintf(ptr noundef nonnull %5, ptr noundef %2, [1 x i32] %3) #5
  br i1 %14, label %25, label %23

23:                                               ; preds = %4
  %24 = load ptr, ptr %11, align 4, !tbaa !13
  store i8 0, ptr %24, align 1, !tbaa !21
  br label %25

25:                                               ; preds = %23, %4
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %5) #4
  ret i32 %22
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #2

; Function Attrs: minsize optsize
declare dso_local i32 @__file_str_put(i8 noundef signext, ptr noundef) #3

; Function Attrs: minsize optsize
declare dso_local i32 @vfprintf(ptr noundef, ptr noundef, [1 x i32]) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nounwind }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"__file", !5, i64 0, !6, i64 2, !8, i64 4, !8, i64 8, !8, i64 12}
!5 = !{!"short", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"any pointer", !6, i64 0}
!9 = !{!4, !6, i64 2}
!10 = !{!4, !8, i64 4}
!11 = !{!4, !8, i64 8}
!12 = !{!4, !8, i64 12}
!13 = !{!14, !15, i64 16}
!14 = !{!"__file_str", !4, i64 0, !15, i64 16, !15, i64 20, !16, i64 24, !17, i64 28}
!15 = !{!"p1 omnipotent char", !8, i64 0}
!16 = !{!"int", !6, i64 0}
!17 = !{!"_Bool", !6, i64 0}
!18 = !{!14, !15, i64 20}
!19 = !{!14, !16, i64 24}
!20 = !{!14, !17, i64 28}
!21 = !{!6, !6, i64 0}
