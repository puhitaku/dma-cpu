; ModuleID = 'sprintf.c'
source_filename = "sprintf.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.__va_list = type { ptr }
%struct.__file_str = type { %struct.__file, ptr, ptr, i32, i8 }
%struct.__file = type { i16, i8, ptr, ptr, ptr }

; Function Attrs: minsize nounwind optsize
define dso_local i32 @sprintf(ptr noundef %0, ptr noundef %1, ...) local_unnamed_addr #0 {
  %3 = alloca %struct.__va_list, align 4
  %4 = alloca %struct.__file_str, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #5
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %4) #5
  store i16 0, ptr %4, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 2
  store i8 2, ptr %5, align 2, !tbaa !9
  %6 = getelementptr inbounds nuw i8, ptr %4, i32 3
  store i8 0, ptr %6, align 1
  %7 = getelementptr inbounds nuw i8, ptr %4, i32 4
  store ptr @__file_str_put, ptr %7, align 4, !tbaa !10
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 8
  store ptr null, ptr %8, align 4, !tbaa !11
  %9 = getelementptr inbounds nuw i8, ptr %4, i32 12
  store ptr null, ptr %9, align 4, !tbaa !12
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 16
  store ptr %0, ptr %10, align 4, !tbaa !13
  %11 = getelementptr inbounds nuw i8, ptr %4, i32 20
  store ptr null, ptr %11, align 4, !tbaa !18
  %12 = getelementptr inbounds nuw i8, ptr %4, i32 24
  store i32 0, ptr %12, align 4, !tbaa !19
  %13 = getelementptr inbounds nuw i8, ptr %4, i32 28
  store i8 0, ptr %13, align 4, !tbaa !20
  %14 = getelementptr inbounds nuw i8, ptr %4, i32 29
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %14, i8 0, i64 3, i1 false)
  call void @llvm.va_start.p0(ptr nonnull %3)
  %15 = load i32, ptr %3, align 4
  %16 = insertvalue [1 x i32] poison, i32 %15, 0
  %17 = call i32 @vfprintf(ptr noundef nonnull %4, ptr noundef %1, [1 x i32] %16) #6
  call void @llvm.va_end.p0(ptr nonnull %3)
  %18 = icmp sgt i32 %17, -1
  br i1 %18, label %19, label %21

19:                                               ; preds = %2
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 %17
  store i8 0, ptr %20, align 1, !tbaa !21
  br label %21

21:                                               ; preds = %19, %2
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %4) #5
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #5
  ret i32 %17
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #2

; Function Attrs: minsize optsize
declare dso_local i32 @__file_str_put(i8 noundef signext, ptr noundef) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #4

; Function Attrs: minsize optsize
declare dso_local i32 @vfprintf(ptr noundef, ptr noundef, [1 x i32]) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #5 = { nounwind }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
