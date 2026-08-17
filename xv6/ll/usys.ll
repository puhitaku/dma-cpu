; ModuleID = 'dma/usys.c'
source_filename = "dma/usys.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.dma_sysmail = type { i32, i32, i32, i32, i32, i32 }

@__dma_sysmail = dso_local global %struct.dma_sysmail zeroinitializer, align 4
@__dma_syscall_entry = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
define dso_local i32 @write(i32 noundef %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = ptrtoint ptr %1 to i32
  store volatile i32 16, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 %0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 %4, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 %2, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %5 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %6 = inttoptr i32 %5 to ptr
  tail call void %6() #2
  %7 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %7
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @getpid() local_unnamed_addr #0 {
  store volatile i32 11, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %1 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %2 = inttoptr i32 %1 to ptr
  tail call void %2() #2
  %3 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @uptime() local_unnamed_addr #0 {
  store volatile i32 14, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %1 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %2 = inttoptr i32 %1 to ptr
  tail call void %2() #2
  %3 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 1, 0) i32 @read(i32 noundef %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = ptrtoint ptr %1 to i32
  br label %5

5:                                                ; preds = %10, %3
  store volatile i32 5, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 %0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 %4, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 %2, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %6 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %7 = inttoptr i32 %6 to ptr
  tail call void %7() #2
  %8 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %14

10:                                               ; preds = %5
  store volatile i32 13, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 1, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %11 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %12 = inttoptr i32 %11 to ptr
  tail call void %12() #2
  %13 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  br label %5

14:                                               ; preds = %5
  ret i32 %8
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @pause(i32 noundef %0) local_unnamed_addr #0 {
  store volatile i32 13, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 %0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %2 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %3 = inttoptr i32 %2 to ptr
  tail call void %3() #2
  %4 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %4
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @wait(ptr noundef %0) local_unnamed_addr #0 {
  %2 = ptrtoint ptr %0 to i32
  store volatile i32 3, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 %2, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %3 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %4 = inttoptr i32 %3 to ptr
  tail call void %4() #2
  %5 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %5
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @fork() local_unnamed_addr #0 {
  store volatile i32 1, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %1 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %2 = inttoptr i32 %1 to ptr
  tail call void %2() #2
  %3 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @exec(ptr noundef %0, ptr noundef %1) local_unnamed_addr #0 {
  store volatile i32 7, ptr @__dma_sysmail, align 4, !tbaa !3
  %3 = ptrtoint ptr %0 to i32
  store volatile i32 %3, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  %4 = ptrtoint ptr %1 to i32
  store volatile i32 %4, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %5 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %6 = inttoptr i32 %5 to ptr
  tail call void %6() #2
  %7 = load volatile i32, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 16), align 4, !tbaa !13
  ret i32 %7
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @exit(i32 noundef %0) local_unnamed_addr #1 {
  store volatile i32 2, ptr @__dma_sysmail, align 4, !tbaa !3
  store volatile i32 %0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 4), align 4, !tbaa !8
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 8), align 4, !tbaa !9
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 12), align 4, !tbaa !10
  store volatile i32 0, ptr getelementptr inbounds nuw (i8, ptr @__dma_sysmail, i32 20), align 4, !tbaa !11
  %2 = load i32, ptr @__dma_syscall_entry, align 4, !tbaa !12
  %3 = inttoptr i32 %2 to ptr
  tail call void %3() #2
  br label %4

4:                                                ; preds = %4, %1
  br label %4, !llvm.loop !14
}

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nobuiltin nounwind optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"dma_sysmail", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16, !5, i64 20}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!4, !5, i64 4}
!9 = !{!4, !5, i64 8}
!10 = !{!4, !5, i64 12}
!11 = !{!4, !5, i64 20}
!12 = !{!5, !5, i64 0}
!13 = !{!4, !5, i64 16}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.unroll.disable"}
