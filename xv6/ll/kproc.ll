; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@kw_curresume = dso_local global ptr null, align 4
@ticks = dso_local global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@kw_pcurdisp = dso_local global ptr null, align 4
@kw_curthunk = dso_local global ptr null, align 4
@kw_pcurresume = dso_local global ptr null, align 4
@kw_nextresume = dso_local global ptr null, align 4
@kw_khalt = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@rearm = internal unnamed_addr global i1 false, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #0 {
  tail call fastcc void @kenter() #2
  tail call fastcc void @tick_income() #2
  %1 = load i32, ptr @curr, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !7
  %4 = load i32, ptr %3, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %4, ptr %5, align 4, !tbaa !10
  %6 = load i32, ptr %2, align 4, !tbaa !12
  %7 = icmp eq i32 %6, 4
  br i1 %7, label %8, label %9

8:                                                ; preds = %0
  store i32 3, ptr %2, align 4, !tbaa !12
  br label %9

9:                                                ; preds = %8, %0
  tail call fastcc void @swtch() #2
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @kenter() unnamed_addr #0 {
  store i1 false, ptr @rearm, align 4
  %1 = load i32, ptr @curr, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %4 = load i32, ptr %3, align 4, !tbaa !13
  %5 = inttoptr i32 %4 to ptr
  %6 = load volatile i32, ptr %5, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %8 = load i32, ptr %7, align 4, !tbaa !14
  %9 = icmp eq i32 %6, %8
  br i1 %9, label %11, label %10

10:                                               ; preds = %0
  store volatile i32 %8, ptr %5, align 4, !tbaa !3
  tail call fastcc void @tick_income() #2
  br label %11

11:                                               ; preds = %10, %0
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr inttoptr (i32 1342177476 to ptr), align 4, !tbaa !3
  %12 = load i32, ptr @tickpending, align 4, !tbaa !3
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %15, label %14

14:                                               ; preds = %11
  store i32 0, ptr @tickpending, align 4, !tbaa !3
  tail call fastcc void @tick_income() #2
  br label %15

15:                                               ; preds = %14, %11
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @tick_income() unnamed_addr #1 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !3
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !3
  store i1 true, ptr @rearm, align 4
  br label %3

3:                                                ; preds = %21, %0
  %4 = phi i32 [ 0, %0 ], [ %22, %21 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %9 = load i32, ptr %8, align 4, !tbaa !12
  %10 = icmp eq i32 %9, 2
  br i1 %10, label %11, label %21

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 12
  %13 = load i32, ptr %12, align 4, !tbaa !15
  %14 = icmp eq i32 %13, ptrtoint (ptr @ticks to i32)
  br i1 %14, label %15, label %21

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw i8, ptr %8, i32 16
  %17 = load i32, ptr %16, align 4, !tbaa !16
  %18 = sub i32 %2, %17
  %19 = icmp sgt i32 %18, -1
  br i1 %19, label %20, label %21

20:                                               ; preds = %15
  store i32 0, ptr %12, align 4, !tbaa !15
  store i32 3, ptr %8, align 4, !tbaa !12
  br label %21

21:                                               ; preds = %20, %15, %11, %7
  %22 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !17
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @swtch() unnamed_addr #0 {
  %1 = load i32, ptr @curr, align 4
  br label %2

2:                                                ; preds = %5, %0
  %3 = phi i32 [ 1, %0 ], [ %11, %5 ]
  %4 = icmp eq i32 %3, 9
  br i1 %4, label %14, label %5

5:                                                ; preds = %2
  %6 = add i32 %3, %1
  %7 = srem i32 %6, 8
  %8 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %7
  %9 = load i32, ptr %8, align 4, !tbaa !12
  %10 = icmp eq i32 %9, 3
  %11 = add nuw nsw i32 %3, 1
  br i1 %10, label %12, label %2, !llvm.loop !20

12:                                               ; preds = %5
  %13 = icmp slt i32 %7, 0
  br i1 %13, label %14, label %17

14:                                               ; preds = %2, %12
  %15 = load volatile ptr, ptr @kw_khalt, align 4, !tbaa !7
  %16 = ptrtoint ptr %15 to i32
  tail call fastcc void @kexit(i32 noundef %1, i32 noundef %16) #2
  br label %20

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %19 = load i32, ptr %18, align 4, !tbaa !10
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %19) #2
  br label %20

20:                                               ; preds = %17, %14
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #0 {
  tail call fastcc void @kenter() #2
  %1 = load i32, ptr @curr, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %4 = load i32, ptr %3, align 4, !tbaa !21
  %5 = inttoptr i32 %4 to ptr
  %6 = load volatile i32, ptr %5, align 4, !tbaa !22
  switch i32 %6, label %135 [
    i32 11, label %9
    i32 14, label %12
    i32 16, label %14
    i32 13, label %34
    i32 3, label %7
    i32 2, label %96
  ]

7:                                                ; preds = %0
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %46

9:                                                ; preds = %0
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %11 = load i32, ptr %10, align 4, !tbaa !24
  br label %135

12:                                               ; preds = %0
  %13 = load i32, ptr @ticks, align 4, !tbaa !3
  br label %135

14:                                               ; preds = %0
  %15 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %16 = load volatile i32, ptr %15, align 4, !tbaa !25
  %17 = inttoptr i32 %16 to ptr
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 12
  br label %19

19:                                               ; preds = %29, %14
  %20 = phi i32 [ 0, %14 ], [ %33, %29 ]
  %21 = load volatile i32, ptr %18, align 4, !tbaa !26
  %22 = icmp ult i32 %20, %21
  br i1 %22, label %25, label %23

23:                                               ; preds = %19
  %24 = load volatile i32, ptr %18, align 4, !tbaa !26
  br label %135

25:                                               ; preds = %19, %25
  %26 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %27 = and i32 %26, 32
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %25, !llvm.loop !27

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %17, i32 %20
  %31 = load i8, ptr %30, align 1, !tbaa !28
  %32 = zext i8 %31 to i32
  store volatile i32 %32, ptr @__dma_uart_dr, align 4, !tbaa !3
  %33 = add nuw i32 %20, 1
  br label %19, !llvm.loop !29

34:                                               ; preds = %0
  %35 = load i32, ptr @ticks, align 4, !tbaa !3
  %36 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %37 = load volatile i32, ptr %36, align 4, !tbaa !30
  %38 = add i32 %37, %35
  %39 = getelementptr inbounds nuw i8, ptr %2, i32 16
  store i32 %38, ptr %39, align 4, !tbaa !16
  %40 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %41 = load i32, ptr %40, align 4, !tbaa !31
  %42 = inttoptr i32 %41 to ptr
  %43 = load volatile i32, ptr %42, align 4, !tbaa !3
  %44 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %43, ptr %44, align 4, !tbaa !10
  %45 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %45, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  br label %146

46:                                               ; preds = %7, %65
  %47 = phi i32 [ %66, %65 ], [ 0, %7 ]
  %48 = phi i32 [ %67, %65 ], [ -1, %7 ]
  %49 = phi i32 [ %68, %65 ], [ 0, %7 ]
  %50 = icmp eq i32 %49, 8
  br i1 %50, label %51, label %53

51:                                               ; preds = %46
  %52 = icmp sgt i32 %48, -1
  br i1 %52, label %69, label %84

53:                                               ; preds = %46
  %54 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %49
  %55 = load i32, ptr %54, align 4, !tbaa !12
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %65, label %57

57:                                               ; preds = %53
  %58 = getelementptr inbounds nuw i8, ptr %54, i32 8
  %59 = load i32, ptr %58, align 4, !tbaa !32
  %60 = load i32, ptr %8, align 4, !tbaa !24
  %61 = icmp eq i32 %59, %60
  br i1 %61, label %62, label %65

62:                                               ; preds = %57
  %63 = icmp eq i32 %55, 5
  %64 = select i1 %63, i32 %49, i32 %48
  br label %65

65:                                               ; preds = %62, %53, %57
  %66 = phi i32 [ %47, %57 ], [ %47, %53 ], [ 1, %62 ]
  %67 = phi i32 [ %48, %57 ], [ %48, %53 ], [ %64, %62 ]
  %68 = add nuw nsw i32 %49, 1
  br label %46, !llvm.loop !33

69:                                               ; preds = %51
  %70 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %71 = load volatile i32, ptr %70, align 4, !tbaa !30
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %79, label %73

73:                                               ; preds = %69
  %74 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %48, i32 5
  %75 = load i32, ptr %74, align 4, !tbaa !34
  %76 = load volatile i32, ptr %70, align 4, !tbaa !30
  %77 = inttoptr i32 %76 to ptr
  store volatile i32 %75, ptr %77, align 4, !tbaa !3
  %78 = load i32, ptr @curr, align 4, !tbaa !3
  br label %79

79:                                               ; preds = %73, %69
  %80 = phi i32 [ %78, %73 ], [ %1, %69 ]
  %81 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %48
  %82 = getelementptr inbounds nuw i8, ptr %81, i32 4
  %83 = load i32, ptr %82, align 4, !tbaa !24
  store i32 0, ptr %81, align 4, !tbaa !12
  br label %135

84:                                               ; preds = %51
  %85 = icmp eq i32 %47, 0
  br i1 %85, label %135, label %86

86:                                               ; preds = %84
  %87 = ptrtoint ptr %2 to i32
  %88 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %89 = load i32, ptr %88, align 4, !tbaa !31
  %90 = inttoptr i32 %89 to ptr
  %91 = load volatile i32, ptr %90, align 4, !tbaa !3
  %92 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %91, ptr %92, align 4, !tbaa !10
  %93 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 %87, ptr %93, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  %94 = getelementptr inbounds nuw i8, ptr %5, i32 16
  %95 = load volatile i32, ptr %94, align 4, !tbaa !35
  br label %146

96:                                               ; preds = %0
  %97 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %98 = load volatile i32, ptr %97, align 4, !tbaa !30
  %99 = getelementptr inbounds nuw i8, ptr %2, i32 20
  store i32 %98, ptr %99, align 4, !tbaa !34
  %100 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %101 = load i32, ptr %100, align 4, !tbaa !32
  br label %102

102:                                              ; preds = %129, %96
  %103 = phi i32 [ 0, %96 ], [ %130, %129 ]
  %104 = icmp eq i32 %103, 8
  br i1 %104, label %144, label %105

105:                                              ; preds = %102
  %106 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %103
  %107 = getelementptr inbounds nuw i8, ptr %106, i32 4
  %108 = load i32, ptr %107, align 4, !tbaa !24
  %109 = icmp eq i32 %108, %101
  br i1 %109, label %110, label %129

110:                                              ; preds = %105
  %111 = load i32, ptr %106, align 4, !tbaa !12
  %112 = icmp eq i32 %111, 2
  br i1 %112, label %113, label %129

113:                                              ; preds = %110
  %114 = getelementptr inbounds nuw i8, ptr %106, i32 12
  %115 = load i32, ptr %114, align 4, !tbaa !15
  %116 = ptrtoint ptr %106 to i32
  %117 = icmp eq i32 %115, %116
  br i1 %117, label %118, label %129

118:                                              ; preds = %113
  %119 = getelementptr inbounds nuw i8, ptr %106, i32 12
  %120 = getelementptr inbounds nuw i8, ptr %106, i32 44
  %121 = load i32, ptr %120, align 4, !tbaa !21
  %122 = inttoptr i32 %121 to ptr
  %123 = getelementptr inbounds nuw i8, ptr %122, i32 4
  %124 = load volatile i32, ptr %123, align 4, !tbaa !30
  %125 = icmp eq i32 %124, 0
  br i1 %125, label %131, label %126

126:                                              ; preds = %118
  %127 = load volatile i32, ptr %123, align 4, !tbaa !30
  %128 = inttoptr i32 %127 to ptr
  store volatile i32 %98, ptr %128, align 4, !tbaa !3
  br label %131

129:                                              ; preds = %113, %110, %105
  %130 = add nuw nsw i32 %103, 1
  br label %102, !llvm.loop !36

131:                                              ; preds = %126, %118
  %132 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %133 = load i32, ptr %132, align 4, !tbaa !24
  %134 = getelementptr inbounds nuw i8, ptr %122, i32 16
  store volatile i32 %133, ptr %134, align 4, !tbaa !35
  store i32 0, ptr %119, align 4, !tbaa !15
  store i32 3, ptr %106, align 4, !tbaa !12
  br label %144

135:                                              ; preds = %0, %9, %12, %23, %79, %84
  %136 = phi i32 [ %1, %84 ], [ %80, %79 ], [ %1, %23 ], [ %1, %12 ], [ %1, %9 ], [ %1, %0 ]
  %137 = phi i32 [ -1, %84 ], [ %83, %79 ], [ %24, %23 ], [ %13, %12 ], [ %11, %9 ], [ -1, %0 ]
  %138 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store volatile i32 %137, ptr %138, align 4, !tbaa !35
  %139 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store volatile i32 1, ptr %139, align 4, !tbaa !37
  store i32 4, ptr %2, align 4, !tbaa !12
  %140 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %141 = load i32, ptr %140, align 4, !tbaa !31
  %142 = inttoptr i32 %141 to ptr
  %143 = load volatile i32, ptr %142, align 4, !tbaa !3
  tail call fastcc void @kexit(i32 noundef %136, i32 noundef %143) #2
  br label %151

144:                                              ; preds = %102, %131
  %145 = phi i32 [ 0, %131 ], [ 5, %102 ]
  store i32 %145, ptr %2, align 4, !tbaa !12
  br label %149

146:                                              ; preds = %34, %86
  %147 = phi i32 [ %95, %86 ], [ 0, %34 ]
  %148 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store volatile i32 %147, ptr %148, align 4, !tbaa !35
  br label %149

149:                                              ; preds = %144, %146
  %150 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store volatile i32 1, ptr %150, align 4, !tbaa !37
  tail call fastcc void @swtch() #2
  br label %151

151:                                              ; preds = %149, %135
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  store i32 %0, ptr @curr, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 24
  %5 = load i32, ptr %4, align 4, !tbaa !13
  %6 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !7
  store i32 %5, ptr %6, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %3, i32 36
  %8 = load i32, ptr %7, align 4, !tbaa !14
  %9 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !7
  store i32 %8, ptr %9, align 4, !tbaa !3
  %10 = getelementptr inbounds nuw i8, ptr %3, i32 28
  %11 = load i32, ptr %10, align 4, !tbaa !38
  %12 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !7
  store i32 %11, ptr %12, align 4, !tbaa !3
  %13 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !7
  store i32 %1, ptr %13, align 4, !tbaa !3
  %14 = load i32, ptr %4, align 4, !tbaa !13
  store volatile i32 %14, ptr inttoptr (i32 1342177476 to ptr), align 4, !tbaa !3
  %15 = load i32, ptr @tickpending, align 4, !tbaa !3
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %18, label %17

17:                                               ; preds = %2
  store i32 0, ptr @tickpending, align 4, !tbaa !3
  tail call fastcc void @tick_income() #2
  br label %18

18:                                               ; preds = %17, %2
  %19 = load i1, ptr @rearm, align 4
  br i1 %19, label %20, label %21

20:                                               ; preds = %18
  store volatile i32 1, ptr inttoptr (i32 1342177500 to ptr), align 4, !tbaa !3
  br label %21

21:                                               ; preds = %20, %18
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #0 {
  tail call void @dma_ktick() #2
  tail call void @dma_ksyscall() #2
  ret i32 0
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"p1 int", !9, i64 0}
!9 = !{!"any pointer", !5, i64 0}
!10 = !{!11, !4, i64 40}
!11 = !{!"proc", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16, !4, i64 20, !4, i64 24, !4, i64 28, !4, i64 32, !4, i64 36, !4, i64 40, !4, i64 44}
!12 = !{!11, !4, i64 0}
!13 = !{!11, !4, i64 24}
!14 = !{!11, !4, i64 36}
!15 = !{!11, !4, i64 12}
!16 = !{!11, !4, i64 16}
!17 = distinct !{!17, !18, !19}
!18 = !{!"llvm.loop.mustprogress"}
!19 = !{!"llvm.loop.unroll.disable"}
!20 = distinct !{!20, !18, !19}
!21 = !{!11, !4, i64 44}
!22 = !{!23, !4, i64 0}
!23 = !{!"dma_sysmail", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16, !4, i64 20}
!24 = !{!11, !4, i64 4}
!25 = !{!23, !4, i64 8}
!26 = !{!23, !4, i64 12}
!27 = distinct !{!27, !18, !19}
!28 = !{!5, !5, i64 0}
!29 = distinct !{!29, !18, !19}
!30 = !{!23, !4, i64 4}
!31 = !{!11, !4, i64 32}
!32 = !{!11, !4, i64 8}
!33 = distinct !{!33, !18, !19}
!34 = !{!11, !4, i64 20}
!35 = !{!23, !4, i64 16}
!36 = distinct !{!36, !18, !19}
!37 = !{!23, !4, i64 20}
!38 = !{!11, !4, i64 28}
