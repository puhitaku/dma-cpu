; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@kw_curresume = dso_local global ptr null, align 4
@ticks = dso_local global i32 0, align 4
@cons_r = internal unnamed_addr global i32 0, align 4
@cons_w = internal unnamed_addr global i32 0, align 4
@cons_buf = internal unnamed_addr global [128 x i8] zeroinitializer, align 1
@nextpid = dso_local local_unnamed_addr global i32 0, align 4
@k_sysentry = dso_local local_unnamed_addr global i32 0, align 4
@kw_pcurdisp = dso_local global ptr null, align 4
@kw_curthunk = dso_local global ptr null, align 4
@kw_pcurresume = dso_local global ptr null, align 4
@kw_nextresume = dso_local global ptr null, align 4
@kw_khalt = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@kimages = dso_local local_unnamed_addr global [4 x %struct.kimg] zeroinitializer, align 4
@arena = dso_local local_unnamed_addr global i32 0, align 4
@arena_end = dso_local local_unnamed_addr global i32 0, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@cons_e = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #0 {
  tail call fastcc void @kenter() #5
  tail call fastcc void @tick_income() #5
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
  tail call fastcc void @swtch() #5
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @kenter() unnamed_addr #0 {
  store i1 false, ptr @rearm, align 4
  %1 = load i32, ptr @curr, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %4 = load i32, ptr %3, align 4, !tbaa !13
  store i32 %4, ptr @entry_disp, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %6 = load i32, ptr %5, align 4, !tbaa !14
  store i32 %6, ptr @entry_thunk, align 4, !tbaa !3
  %7 = inttoptr i32 %4 to ptr
  %8 = load volatile i32, ptr %7, align 4, !tbaa !3
  %9 = icmp eq i32 %8, %6
  br i1 %9, label %11, label %10

10:                                               ; preds = %0
  store volatile i32 %6, ptr %7, align 4, !tbaa !3
  tail call fastcc void @tick_income() #5
  br label %11

11:                                               ; preds = %10, %0
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr inttoptr (i32 1342177476 to ptr), align 4, !tbaa !3
  %12 = load i32, ptr @tickpending, align 4, !tbaa !3
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %15, label %14

14:                                               ; preds = %11
  store i32 0, ptr @tickpending, align 4, !tbaa !3
  tail call fastcc void @tick_income() #5
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
  tail call fastcc void @kexit(i32 noundef %1, i32 noundef %16) #5
  br label %20

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %19 = load i32, ptr %18, align 4, !tbaa !10
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %19) #5
  br label %20

20:                                               ; preds = %17, %14
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #0 {
  tail call fastcc void @kenter() #5
  %1 = load i32, ptr @curr, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %4 = load i32, ptr %3, align 4, !tbaa !21
  %5 = inttoptr i32 %4 to ptr
  %6 = load volatile i32, ptr %5, align 4, !tbaa !22
  switch i32 %6, label %408 [
    i32 11, label %9
    i32 14, label %12
    i32 16, label %14
    i32 5, label %30
    i32 13, label %91
    i32 3, label %7
    i32 1, label %151
    i32 7, label %178
    i32 2, label %360
  ]

7:                                                ; preds = %0
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %103

9:                                                ; preds = %0
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %11 = load i32, ptr %10, align 4, !tbaa !24
  br label %408

12:                                               ; preds = %0
  %13 = load i32, ptr @ticks, align 4, !tbaa !3
  br label %408

14:                                               ; preds = %0
  %15 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %16 = load volatile i32, ptr %15, align 4, !tbaa !25
  %17 = inttoptr i32 %16 to ptr
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 12
  br label %19

19:                                               ; preds = %25, %14
  %20 = phi i32 [ 0, %14 ], [ %29, %25 ]
  %21 = load volatile i32, ptr %18, align 4, !tbaa !26
  %22 = icmp ult i32 %20, %21
  br i1 %22, label %25, label %23

23:                                               ; preds = %19
  %24 = load volatile i32, ptr %18, align 4, !tbaa !26
  br label %408

25:                                               ; preds = %19
  %26 = getelementptr inbounds nuw i8, ptr %17, i32 %20
  %27 = load i8, ptr %26, align 1, !tbaa !27
  %28 = sext i8 %27 to i32
  tail call fastcc void @cputc(i32 noundef %28) #5
  %29 = add nuw i32 %20, 1
  br label %19, !llvm.loop !28

30:                                               ; preds = %0
  %31 = load i32, ptr @cons_e, align 4
  %32 = load i32, ptr @cons_w, align 4
  %33 = load i32, ptr @cons_r, align 4
  br label %34

34:                                               ; preds = %67, %30
  %35 = phi i32 [ %60, %67 ], [ %32, %30 ]
  %36 = phi i32 [ %60, %67 ], [ %31, %30 ]
  br label %37

37:                                               ; preds = %65, %34
  %38 = phi i32 [ %36, %34 ], [ %66, %65 ]
  %39 = sub i32 %38, %33
  %40 = icmp ult i32 %39, 128
  br label %41

41:                                               ; preds = %37, %52
  %42 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %43 = and i32 %42, 16
  %44 = icmp eq i32 %43, 0
  br i1 %44, label %45, label %68

45:                                               ; preds = %41
  %46 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !3
  %47 = trunc i32 %46 to i8
  switch i8 %47, label %52 [
    i8 8, label %48
    i8 127, label %48
  ]

48:                                               ; preds = %45, %45
  %49 = icmp eq i32 %38, %35
  br i1 %49, label %65, label %50

50:                                               ; preds = %48
  %51 = add i32 %38, -1
  store i32 %51, ptr @cons_e, align 4, !tbaa !3
  tail call fastcc void @cputc(i32 noundef 8) #5
  tail call fastcc void @cputc(i32 noundef 32) #5
  tail call fastcc void @cputc(i32 noundef 8) #5
  br label %65

52:                                               ; preds = %45
  br i1 %40, label %53, label %41

53:                                               ; preds = %52
  %54 = and i32 %46, 255
  %55 = icmp eq i32 %54, 13
  %56 = select i1 %55, i32 10, i32 %54
  %57 = trunc nuw i32 %56 to i8
  %58 = and i32 %38, 127
  %59 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %58
  store i8 %57, ptr %59, align 1, !tbaa !27
  %60 = add i32 %38, 1
  store i32 %60, ptr @cons_e, align 4, !tbaa !3
  tail call fastcc void @cputc(i32 noundef %56) #5
  %61 = icmp eq i32 %56, 10
  br i1 %61, label %67, label %62

62:                                               ; preds = %53
  %63 = sub i32 %60, %33
  %64 = icmp eq i32 %63, 128
  br i1 %64, label %67, label %65

65:                                               ; preds = %62, %48, %50
  %66 = phi i32 [ %51, %50 ], [ %35, %48 ], [ %60, %62 ]
  br label %37, !llvm.loop !29

67:                                               ; preds = %62, %53
  store i32 %60, ptr @cons_w, align 4, !tbaa !3
  br label %34

68:                                               ; preds = %41
  %69 = icmp eq i32 %33, %35
  br i1 %69, label %408, label %70

70:                                               ; preds = %68
  %71 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %72 = load volatile i32, ptr %71, align 4, !tbaa !25
  %73 = inttoptr i32 %72 to ptr
  %74 = getelementptr inbounds nuw i8, ptr %5, i32 12
  br label %75

75:                                               ; preds = %83, %70
  %76 = phi i32 [ 0, %70 ], [ %88, %83 ]
  %77 = load volatile i32, ptr %74, align 4, !tbaa !26
  %78 = icmp ult i32 %76, %77
  %79 = load i32, ptr @cons_r, align 4
  %80 = load i32, ptr @cons_w, align 4
  %81 = icmp ne i32 %79, %80
  %82 = select i1 %78, i1 %81, i1 false
  br i1 %82, label %83, label %408

83:                                               ; preds = %75
  %84 = and i32 %79, 127
  %85 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %84
  %86 = load i8, ptr %85, align 1, !tbaa !27
  %87 = add i32 %79, 1
  store i32 %87, ptr @cons_r, align 4, !tbaa !3
  %88 = add nuw i32 %76, 1
  %89 = getelementptr inbounds nuw i8, ptr %73, i32 %76
  store i8 %86, ptr %89, align 1, !tbaa !27
  %90 = icmp eq i8 %86, 10
  br i1 %90, label %408, label %75

91:                                               ; preds = %0
  %92 = load i32, ptr @ticks, align 4, !tbaa !3
  %93 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %94 = load volatile i32, ptr %93, align 4, !tbaa !30
  %95 = add i32 %94, %92
  %96 = getelementptr inbounds nuw i8, ptr %2, i32 16
  store i32 %95, ptr %96, align 4, !tbaa !16
  %97 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %98 = load i32, ptr %97, align 4, !tbaa !31
  %99 = inttoptr i32 %98 to ptr
  %100 = load volatile i32, ptr %99, align 4, !tbaa !3
  %101 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %100, ptr %101, align 4, !tbaa !10
  %102 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %102, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  br label %425

103:                                              ; preds = %7, %122
  %104 = phi i32 [ %125, %122 ], [ 0, %7 ]
  %105 = phi i32 [ %123, %122 ], [ -1, %7 ]
  %106 = phi i32 [ %124, %122 ], [ 0, %7 ]
  %107 = icmp eq i32 %104, 8
  br i1 %107, label %108, label %110

108:                                              ; preds = %103
  %109 = icmp sgt i32 %105, -1
  br i1 %109, label %126, label %139

110:                                              ; preds = %103
  %111 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %104
  %112 = load i32, ptr %111, align 4, !tbaa !12
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %122, label %114

114:                                              ; preds = %110
  %115 = getelementptr inbounds nuw i8, ptr %111, i32 8
  %116 = load i32, ptr %115, align 4, !tbaa !32
  %117 = load i32, ptr %8, align 4, !tbaa !24
  %118 = icmp eq i32 %116, %117
  br i1 %118, label %119, label %122

119:                                              ; preds = %114
  %120 = icmp eq i32 %112, 5
  %121 = select i1 %120, i32 %104, i32 %105
  br label %122

122:                                              ; preds = %119, %110, %114
  %123 = phi i32 [ %105, %114 ], [ %105, %110 ], [ %121, %119 ]
  %124 = phi i32 [ %106, %114 ], [ %106, %110 ], [ 1, %119 ]
  %125 = add nuw nsw i32 %104, 1
  br label %103, !llvm.loop !33

126:                                              ; preds = %108
  %127 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %128 = load volatile i32, ptr %127, align 4, !tbaa !30
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %135, label %130

130:                                              ; preds = %126
  %131 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %105, i32 5
  %132 = load i32, ptr %131, align 4, !tbaa !34
  %133 = load volatile i32, ptr %127, align 4, !tbaa !30
  %134 = inttoptr i32 %133 to ptr
  store volatile i32 %132, ptr %134, align 4, !tbaa !3
  br label %135

135:                                              ; preds = %130, %126
  %136 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %105
  %137 = getelementptr inbounds nuw i8, ptr %136, i32 4
  %138 = load i32, ptr %137, align 4, !tbaa !24
  store i32 0, ptr %136, align 4, !tbaa !12
  br label %408

139:                                              ; preds = %108
  %140 = icmp eq i32 %106, 0
  br i1 %140, label %408, label %141

141:                                              ; preds = %139
  %142 = ptrtoint ptr %2 to i32
  %143 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %144 = load i32, ptr %143, align 4, !tbaa !31
  %145 = inttoptr i32 %144 to ptr
  %146 = load volatile i32, ptr %145, align 4, !tbaa !3
  %147 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %146, ptr %147, align 4, !tbaa !10
  %148 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 %142, ptr %148, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  %149 = getelementptr inbounds nuw i8, ptr %5, i32 16
  %150 = load volatile i32, ptr %149, align 4, !tbaa !35
  br label %425

151:                                              ; preds = %0, %154
  %152 = phi i32 [ %158, %154 ], [ 0, %0 ]
  %153 = icmp eq i32 %152, 8
  br i1 %153, label %408, label %154

154:                                              ; preds = %151
  %155 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %152
  %156 = load i32, ptr %155, align 4, !tbaa !12
  %157 = icmp eq i32 %156, 0
  %158 = add nuw nsw i32 %152, 1
  br i1 %157, label %159, label %151, !llvm.loop !36

159:                                              ; preds = %154
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(48) %155, ptr noundef nonnull align 4 dereferenceable(48) %2, i32 48, i1 false), !tbaa.struct !37
  %160 = load i32, ptr @nextpid, align 4, !tbaa !3
  %161 = add i32 %160, 1
  store i32 %161, ptr @nextpid, align 4, !tbaa !3
  %162 = getelementptr inbounds nuw i8, ptr %155, i32 4
  store i32 %160, ptr %162, align 4, !tbaa !24
  %163 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %164 = load i32, ptr %163, align 4, !tbaa !24
  %165 = getelementptr inbounds nuw i8, ptr %155, i32 8
  store i32 %164, ptr %165, align 4, !tbaa !32
  %166 = getelementptr inbounds nuw i8, ptr %155, i32 12
  store i32 0, ptr %166, align 4, !tbaa !15
  store i32 3, ptr %155, align 4, !tbaa !12
  %167 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %168 = load i32, ptr %167, align 4, !tbaa !31
  %169 = inttoptr i32 %168 to ptr
  %170 = load volatile i32, ptr %169, align 4, !tbaa !3
  %171 = getelementptr inbounds nuw i8, ptr %155, i32 40
  store i32 %170, ptr %171, align 4, !tbaa !10
  %172 = load volatile i32, ptr %169, align 4, !tbaa !3
  %173 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %172, ptr %173, align 4, !tbaa !10
  %174 = ptrtoint ptr %155 to i32
  %175 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 %174, ptr %175, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  %176 = load i32, ptr %3, align 4, !tbaa !21
  %177 = inttoptr i32 %176 to ptr
  br label %425

178:                                              ; preds = %0
  %179 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %180 = load volatile i32, ptr %179, align 4, !tbaa !30
  %181 = inttoptr i32 %180 to ptr
  br label %182

182:                                              ; preds = %201, %178
  %183 = phi i32 [ 0, %178 ], [ %202, %201 ]
  %184 = icmp eq i32 %183, 4
  br i1 %184, label %408, label %185

185:                                              ; preds = %182
  %186 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %183
  %187 = load i8, ptr %186, align 4, !tbaa !27
  %188 = icmp eq i8 %187, 0
  br i1 %188, label %408, label %189

189:                                              ; preds = %185, %198
  %190 = phi i32 [ %200, %198 ], [ 0, %185 ]
  %191 = icmp eq i32 %190, 12
  br i1 %191, label %203, label %192

192:                                              ; preds = %189
  %193 = getelementptr inbounds nuw [12 x i8], ptr %186, i32 0, i32 %190
  %194 = load i8, ptr %193, align 1, !tbaa !27
  %195 = getelementptr inbounds nuw i8, ptr %181, i32 %190
  %196 = load i8, ptr %195, align 1, !tbaa !27
  %197 = icmp eq i8 %194, %196
  br i1 %197, label %198, label %201

198:                                              ; preds = %192
  %199 = icmp eq i8 %194, 0
  %200 = add nuw nsw i32 %190, 1
  br i1 %199, label %203, label %189, !llvm.loop !38

201:                                              ; preds = %192
  %202 = add nuw nsw i32 %183, 1
  br label %182, !llvm.loop !39

203:                                              ; preds = %198, %189
  %204 = getelementptr inbounds nuw i8, ptr %186, i32 16
  %205 = load i32, ptr %204, align 4, !tbaa !40
  %206 = tail call fastcc i32 @kalloc(i32 noundef %205) #5
  %207 = getelementptr inbounds nuw i8, ptr %186, i32 24
  %208 = load i32, ptr %207, align 4, !tbaa !42
  %209 = tail call fastcc i32 @kalloc(i32 noundef %208) #5
  %210 = icmp eq i32 %206, 0
  %211 = icmp eq i32 %209, 0
  %212 = select i1 %210, i1 true, i1 %211
  br i1 %212, label %408, label %213

213:                                              ; preds = %203
  %214 = getelementptr inbounds nuw i8, ptr %186, i32 12
  %215 = load i32, ptr %214, align 4, !tbaa !43
  %216 = inttoptr i32 %215 to ptr
  %217 = inttoptr i32 %206 to ptr
  br label %218

218:                                              ; preds = %229, %213
  %219 = phi i32 [ 0, %213 ], [ %233, %229 ]
  %220 = phi ptr [ %217, %213 ], [ %232, %229 ]
  %221 = phi ptr [ %216, %213 ], [ %230, %229 ]
  %222 = load i32, ptr %204, align 4, !tbaa !40
  %223 = icmp ult i32 %219, %222
  br i1 %223, label %229, label %224

224:                                              ; preds = %218
  %225 = getelementptr inbounds nuw i8, ptr %186, i32 20
  %226 = load i32, ptr %225, align 4, !tbaa !44
  %227 = inttoptr i32 %226 to ptr
  %228 = inttoptr i32 %209 to ptr
  br label %234

229:                                              ; preds = %218
  %230 = getelementptr inbounds nuw i8, ptr %221, i32 4
  %231 = load i32, ptr %221, align 4, !tbaa !3
  %232 = getelementptr inbounds nuw i8, ptr %220, i32 4
  store i32 %231, ptr %220, align 4, !tbaa !3
  %233 = add i32 %219, 4
  br label %218, !llvm.loop !45

234:                                              ; preds = %251, %224
  %235 = phi i32 [ 0, %224 ], [ %255, %251 ]
  %236 = phi ptr [ %228, %224 ], [ %254, %251 ]
  %237 = phi ptr [ %227, %224 ], [ %252, %251 ]
  %238 = load i32, ptr %207, align 4, !tbaa !42
  %239 = icmp ult i32 %235, %238
  br i1 %239, label %251, label %240

240:                                              ; preds = %234
  %241 = getelementptr inbounds nuw i8, ptr %186, i32 28
  %242 = load i32, ptr %241, align 4, !tbaa !46
  %243 = sub i32 %206, %242
  %244 = getelementptr inbounds nuw i8, ptr %186, i32 32
  %245 = load i32, ptr %244, align 4, !tbaa !47
  %246 = sub i32 %209, %245
  %247 = getelementptr inbounds nuw i8, ptr %186, i32 36
  %248 = load i32, ptr %247, align 4, !tbaa !48
  %249 = inttoptr i32 %248 to ptr
  %250 = getelementptr inbounds nuw i8, ptr %186, i32 40
  br label %256

251:                                              ; preds = %234
  %252 = getelementptr inbounds nuw i8, ptr %237, i32 4
  %253 = load i32, ptr %237, align 4, !tbaa !3
  %254 = getelementptr inbounds nuw i8, ptr %236, i32 4
  store i32 %253, ptr %236, align 4, !tbaa !3
  %255 = add i32 %235, 4
  br label %234, !llvm.loop !49

256:                                              ; preds = %264, %240
  %257 = phi i32 [ 0, %240 ], [ %277, %264 ]
  %258 = load i32, ptr %250, align 4, !tbaa !50
  %259 = icmp ult i32 %257, %258
  br i1 %259, label %264, label %260

260:                                              ; preds = %256
  %261 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %262 = load volatile i32, ptr %261, align 4, !tbaa !25
  %263 = icmp eq i32 %262, 0
  br i1 %263, label %320, label %278

264:                                              ; preds = %256
  %265 = getelementptr inbounds nuw i32, ptr %249, i32 %257
  %266 = load i32, ptr %265, align 4, !tbaa !3
  %267 = icmp slt i32 %266, 0
  %268 = select i1 %267, i32 %209, i32 %206
  %269 = and i32 %266, 1073741823
  %270 = add i32 %268, %269
  %271 = and i32 %266, 1073741824
  %272 = icmp eq i32 %271, 0
  %273 = select i1 %272, i32 %243, i32 %246
  %274 = inttoptr i32 %270 to ptr
  %275 = load volatile i32, ptr %274, align 4, !tbaa !3
  %276 = add i32 %273, %275
  store volatile i32 %276, ptr %274, align 4, !tbaa !3
  %277 = add nuw i32 %257, 1
  br label %256, !llvm.loop !51

278:                                              ; preds = %260
  %279 = load i32, ptr @arena, align 4, !tbaa !3
  %280 = add i32 %279, 256
  %281 = load i32, ptr @arena_end, align 4, !tbaa !3
  %282 = icmp ugt i32 %280, %281
  br i1 %282, label %320, label %283

283:                                              ; preds = %278
  store i32 %280, ptr @arena, align 4, !tbaa !3
  %284 = icmp eq i32 %279, 0
  br i1 %284, label %320, label %285

285:                                              ; preds = %283
  %286 = load volatile i32, ptr %261, align 4, !tbaa !25
  %287 = inttoptr i32 %286 to ptr
  %288 = inttoptr i32 %279 to ptr
  %289 = add i32 %279, 64
  %290 = inttoptr i32 %289 to ptr
  %291 = inttoptr i32 %280 to ptr
  %292 = getelementptr inbounds i8, ptr %291, i32 -1
  br label %293

293:                                              ; preds = %315, %285
  %294 = phi i32 [ 0, %285 ], [ %317, %315 ]
  %295 = phi ptr [ %290, %285 ], [ %316, %315 ]
  %296 = icmp eq i32 %294, 15
  br i1 %296, label %318, label %297

297:                                              ; preds = %293
  %298 = getelementptr inbounds nuw i32, ptr %287, i32 %294
  %299 = load i32, ptr %298, align 4, !tbaa !3
  %300 = icmp eq i32 %299, 0
  br i1 %300, label %318, label %301

301:                                              ; preds = %297
  %302 = inttoptr i32 %299 to ptr
  %303 = ptrtoint ptr %295 to i32
  %304 = getelementptr inbounds nuw i32, ptr %288, i32 %294
  store i32 %303, ptr %304, align 4, !tbaa !3
  br label %305

305:                                              ; preds = %312, %301
  %306 = phi ptr [ %295, %301 ], [ %314, %312 ]
  %307 = phi ptr [ %302, %301 ], [ %313, %312 ]
  %308 = load i8, ptr %307, align 1, !tbaa !27
  %309 = icmp ne i8 %308, 0
  %310 = icmp ult ptr %306, %292
  %311 = select i1 %309, i1 %310, i1 false
  br i1 %311, label %312, label %315

312:                                              ; preds = %305
  %313 = getelementptr inbounds nuw i8, ptr %307, i32 1
  %314 = getelementptr inbounds nuw i8, ptr %306, i32 1
  store i8 %308, ptr %306, align 1, !tbaa !27
  br label %305, !llvm.loop !52

315:                                              ; preds = %305
  %316 = getelementptr inbounds nuw i8, ptr %306, i32 1
  store i8 0, ptr %306, align 1, !tbaa !27
  %317 = add nuw nsw i32 %294, 1
  br label %293, !llvm.loop !53

318:                                              ; preds = %293, %297
  %319 = getelementptr inbounds nuw i32, ptr %288, i32 %294
  store i32 0, ptr %319, align 4, !tbaa !3
  br label %320

320:                                              ; preds = %278, %283, %318, %260
  %321 = phi i32 [ 0, %260 ], [ %294, %318 ], [ 0, %283 ], [ 0, %278 ]
  %322 = phi i32 [ 0, %260 ], [ %279, %318 ], [ 0, %283 ], [ 0, %278 ]
  %323 = getelementptr inbounds nuw i8, ptr %186, i32 52
  %324 = load i32, ptr %323, align 4, !tbaa !54
  %325 = add i32 %324, %209
  %326 = getelementptr inbounds nuw i8, ptr %2, i32 24
  store i32 %325, ptr %326, align 4, !tbaa !13
  %327 = getelementptr inbounds nuw i8, ptr %186, i32 56
  %328 = load i32, ptr %327, align 4, !tbaa !55
  %329 = add i32 %328, %209
  %330 = getelementptr inbounds nuw i8, ptr %2, i32 28
  store i32 %329, ptr %330, align 4, !tbaa !56
  %331 = getelementptr inbounds nuw i8, ptr %186, i32 60
  %332 = load i32, ptr %331, align 4, !tbaa !57
  %333 = add i32 %332, %209
  %334 = getelementptr inbounds nuw i8, ptr %2, i32 32
  store i32 %333, ptr %334, align 4, !tbaa !31
  %335 = getelementptr inbounds nuw i8, ptr %186, i32 48
  %336 = load i32, ptr %335, align 4, !tbaa !58
  %337 = add i32 %336, %206
  %338 = getelementptr inbounds nuw i8, ptr %2, i32 36
  store i32 %337, ptr %338, align 4, !tbaa !14
  %339 = getelementptr inbounds nuw i8, ptr %186, i32 64
  %340 = load i32, ptr %339, align 4, !tbaa !59
  %341 = add i32 %340, %209
  store i32 %341, ptr %3, align 4, !tbaa !21
  %342 = load i32, ptr @k_sysentry, align 4, !tbaa !3
  %343 = getelementptr inbounds nuw i8, ptr %186, i32 68
  %344 = load i32, ptr %343, align 4, !tbaa !60
  %345 = add i32 %344, %209
  %346 = inttoptr i32 %345 to ptr
  store volatile i32 %342, ptr %346, align 4, !tbaa !3
  %347 = load i32, ptr %338, align 4, !tbaa !14
  %348 = load i32, ptr %326, align 4, !tbaa !13
  %349 = inttoptr i32 %348 to ptr
  store volatile i32 %347, ptr %349, align 4, !tbaa !3
  %350 = load i32, ptr %323, align 4, !tbaa !54
  %351 = add i32 %350, %209
  %352 = add i32 %351, -84
  %353 = inttoptr i32 %352 to ptr
  store volatile i32 %321, ptr %353, align 4, !tbaa !3
  %354 = add i32 %351, -80
  %355 = inttoptr i32 %354 to ptr
  store volatile i32 %322, ptr %355, align 4, !tbaa !3
  tail call fastcc void @vfork_release(ptr noundef nonnull %2) #5
  store i32 4, ptr %2, align 4, !tbaa !12
  %356 = load i32, ptr @curr, align 4, !tbaa !3
  %357 = getelementptr inbounds nuw i8, ptr %186, i32 44
  %358 = load i32, ptr %357, align 4, !tbaa !61
  %359 = add i32 %358, %206
  tail call fastcc void @kexit(i32 noundef %356, i32 noundef %359) #5
  br label %435

360:                                              ; preds = %0
  %361 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %362 = load volatile i32, ptr %361, align 4, !tbaa !30
  %363 = getelementptr inbounds nuw i8, ptr %2, i32 20
  store i32 %362, ptr %363, align 4, !tbaa !34
  tail call fastcc void @vfork_release(ptr noundef nonnull %2) #5
  %364 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %365 = load i32, ptr %364, align 4, !tbaa !32
  br label %366

366:                                              ; preds = %396, %360
  %367 = phi i32 [ 0, %360 ], [ %397, %396 ]
  %368 = icmp eq i32 %367, 8
  br i1 %368, label %423, label %369

369:                                              ; preds = %366
  %370 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %367
  %371 = getelementptr inbounds nuw i8, ptr %370, i32 4
  %372 = load i32, ptr %371, align 4, !tbaa !24
  %373 = icmp eq i32 %372, %365
  br i1 %373, label %374, label %396

374:                                              ; preds = %369
  %375 = load i32, ptr %370, align 4, !tbaa !12
  %376 = icmp eq i32 %375, 2
  br i1 %376, label %377, label %396

377:                                              ; preds = %374
  %378 = getelementptr inbounds nuw i8, ptr %370, i32 12
  %379 = load i32, ptr %378, align 4, !tbaa !15
  %380 = ptrtoint ptr %370 to i32
  %381 = icmp eq i32 %379, %380
  br i1 %381, label %382, label %396

382:                                              ; preds = %377
  %383 = getelementptr inbounds nuw i8, ptr %370, i32 12
  %384 = getelementptr inbounds nuw i8, ptr %370, i32 44
  %385 = load i32, ptr %384, align 4, !tbaa !21
  %386 = inttoptr i32 %385 to ptr
  %387 = getelementptr inbounds nuw i8, ptr %386, i32 4
  %388 = load volatile i32, ptr %387, align 4, !tbaa !30
  %389 = icmp eq i32 %388, 0
  br i1 %389, label %398, label %390

390:                                              ; preds = %382
  %391 = load i32, ptr %363, align 4, !tbaa !34
  %392 = load volatile i32, ptr %387, align 4, !tbaa !30
  %393 = inttoptr i32 %392 to ptr
  store volatile i32 %391, ptr %393, align 4, !tbaa !3
  %394 = load i32, ptr %384, align 4, !tbaa !21
  %395 = inttoptr i32 %394 to ptr
  br label %398

396:                                              ; preds = %377, %374, %369
  %397 = add nuw nsw i32 %367, 1
  br label %366, !llvm.loop !62

398:                                              ; preds = %390, %382
  %399 = phi ptr [ %395, %390 ], [ %386, %382 ]
  %400 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %401 = load i32, ptr %400, align 4, !tbaa !24
  %402 = getelementptr inbounds nuw i8, ptr %399, i32 16
  store volatile i32 %401, ptr %402, align 4, !tbaa !35
  %403 = getelementptr inbounds nuw i8, ptr %399, i32 20
  store volatile i32 1, ptr %403, align 4, !tbaa !63
  %404 = getelementptr inbounds nuw i8, ptr %370, i32 24
  %405 = load i32, ptr %404, align 4, !tbaa !13
  %406 = add i32 %405, -84
  %407 = inttoptr i32 %406 to ptr
  store volatile i32 %401, ptr %407, align 4, !tbaa !3
  store i32 0, ptr %383, align 4, !tbaa !15
  store i32 3, ptr %370, align 4, !tbaa !12
  br label %423

408:                                              ; preds = %185, %182, %151, %83, %75, %0, %9, %12, %23, %68, %135, %139, %203
  %409 = phi i32 [ -1, %203 ], [ -1, %139 ], [ %138, %135 ], [ 0, %68 ], [ %24, %23 ], [ %13, %12 ], [ %11, %9 ], [ -1, %0 ], [ %88, %83 ], [ %76, %75 ], [ -1, %151 ], [ -1, %182 ], [ -1, %185 ]
  %410 = load i32, ptr %3, align 4, !tbaa !21
  %411 = inttoptr i32 %410 to ptr
  %412 = getelementptr inbounds nuw i8, ptr %411, i32 16
  store volatile i32 %409, ptr %412, align 4, !tbaa !35
  %413 = getelementptr inbounds nuw i8, ptr %411, i32 20
  store volatile i32 1, ptr %413, align 4, !tbaa !63
  %414 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %415 = load i32, ptr %414, align 4, !tbaa !13
  %416 = add i32 %415, -84
  %417 = inttoptr i32 %416 to ptr
  store volatile i32 %409, ptr %417, align 4, !tbaa !3
  store i32 4, ptr %2, align 4, !tbaa !12
  %418 = load i32, ptr @curr, align 4, !tbaa !3
  %419 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %420 = load i32, ptr %419, align 4, !tbaa !31
  %421 = inttoptr i32 %420 to ptr
  %422 = load volatile i32, ptr %421, align 4, !tbaa !3
  tail call fastcc void @kexit(i32 noundef %418, i32 noundef %422) #5
  br label %435

423:                                              ; preds = %366, %398
  %424 = phi i32 [ 0, %398 ], [ 5, %366 ]
  store i32 %424, ptr %2, align 4, !tbaa !12
  br label %434

425:                                              ; preds = %91, %141, %159
  %426 = phi ptr [ %5, %91 ], [ %5, %141 ], [ %177, %159 ]
  %427 = phi i32 [ 0, %91 ], [ %150, %141 ], [ 0, %159 ]
  %428 = getelementptr inbounds nuw i8, ptr %426, i32 16
  store volatile i32 %427, ptr %428, align 4, !tbaa !35
  %429 = getelementptr inbounds nuw i8, ptr %426, i32 20
  store volatile i32 1, ptr %429, align 4, !tbaa !63
  %430 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %431 = load i32, ptr %430, align 4, !tbaa !13
  %432 = add i32 %431, -84
  %433 = inttoptr i32 %432 to ptr
  store volatile i32 %427, ptr %433, align 4, !tbaa !3
  br label %434

434:                                              ; preds = %423, %425
  tail call fastcc void @swtch() #5
  br label %435

435:                                              ; preds = %320, %434, %408
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define internal fastcc void @cputc(i32 noundef range(i32 -128, 256) %0) unnamed_addr #2 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %8

3:                                                ; preds = %1, %3
  %4 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %5 = and i32 %4, 32
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !64

7:                                                ; preds = %3
  store volatile i32 13, ptr @__dma_uart_dr, align 4, !tbaa !3
  br label %8

8:                                                ; preds = %7, %1
  br label %9

9:                                                ; preds = %8, %9
  %10 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %11 = and i32 %10, 32
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %9, !llvm.loop !65

13:                                               ; preds = %9
  %14 = and i32 %0, 255
  store volatile i32 %14, ptr @__dma_uart_dr, align 4, !tbaa !3
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #3

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #4 {
  %2 = add i32 %0, 255
  %3 = and i32 %2, -256
  %4 = load i32, ptr @arena, align 4, !tbaa !3
  %5 = add i32 %4, %3
  %6 = load i32, ptr @arena_end, align 4, !tbaa !3
  %7 = icmp ugt i32 %5, %6
  br i1 %7, label %9, label %8

8:                                                ; preds = %1
  store i32 %5, ptr @arena, align 4, !tbaa !3
  br label %9

9:                                                ; preds = %1, %8
  %10 = phi i32 [ %4, %8 ], [ 0, %1 ]
  ret i32 %10
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @vfork_release(ptr noundef %0) unnamed_addr #0 {
  %2 = ptrtoint ptr %0 to i32
  %3 = getelementptr inbounds nuw i8, ptr %0, i32 4
  br label %4

4:                                                ; preds = %27, %1
  %5 = phi i32 [ 0, %1 ], [ %28, %27 ]
  %6 = icmp eq i32 %5, 8
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %5
  %10 = load i32, ptr %9, align 4, !tbaa !12
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %27

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !15
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr %3, align 4, !tbaa !24
  %18 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %19 = load i32, ptr %18, align 4, !tbaa !21
  %20 = inttoptr i32 %19 to ptr
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store volatile i32 %17, ptr %21, align 4, !tbaa !35
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 20
  store volatile i32 1, ptr %22, align 4, !tbaa !63
  %23 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %24 = load i32, ptr %23, align 4, !tbaa !13
  %25 = add i32 %24, -84
  %26 = inttoptr i32 %25 to ptr
  store volatile i32 %17, ptr %26, align 4, !tbaa !3
  store i32 0, ptr %13, align 4, !tbaa !15
  store i32 3, ptr %9, align 4, !tbaa !12
  br label %27

27:                                               ; preds = %16, %12, %8
  %28 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !66
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = load i32, ptr @entry_disp, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %11, label %5

5:                                                ; preds = %2
  %6 = inttoptr i32 %3 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !3
  %8 = load i32, ptr @entry_thunk, align 4, !tbaa !3
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store volatile i32 %8, ptr %6, align 4, !tbaa !3
  tail call fastcc void @tick_income() #5
  br label %11

11:                                               ; preds = %10, %5, %2
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  store i32 %0, ptr @curr, align 4, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %14 = load i32, ptr %13, align 4, !tbaa !13
  %15 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !7
  store i32 %14, ptr %15, align 4, !tbaa !3
  %16 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %17 = load i32, ptr %16, align 4, !tbaa !14
  %18 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !7
  store i32 %17, ptr %18, align 4, !tbaa !3
  %19 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %20 = load i32, ptr %19, align 4, !tbaa !56
  %21 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !7
  store i32 %20, ptr %21, align 4, !tbaa !3
  %22 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !7
  store i32 %1, ptr %22, align 4, !tbaa !3
  %23 = load i32, ptr %13, align 4, !tbaa !13
  store volatile i32 %23, ptr inttoptr (i32 1342177476 to ptr), align 4, !tbaa !3
  %24 = load i32, ptr @tickpending, align 4, !tbaa !3
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %27, label %26

26:                                               ; preds = %11
  store i32 0, ptr @tickpending, align 4, !tbaa !3
  tail call fastcc void @tick_income() #5
  br label %27

27:                                               ; preds = %26, %11
  %28 = load i1, ptr @rearm, align 4
  br i1 %28, label %29, label %30

29:                                               ; preds = %27
  store volatile i32 1, ptr inttoptr (i32 1342177500 to ptr), align 4, !tbaa !3
  br label %30

30:                                               ; preds = %29, %27
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #0 {
  tail call void @dma_ktick() #5
  tail call void @dma_ksyscall() #5
  ret i32 0
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }

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
!27 = !{!5, !5, i64 0}
!28 = distinct !{!28, !18, !19}
!29 = distinct !{!29, !18, !19}
!30 = !{!23, !4, i64 4}
!31 = !{!11, !4, i64 32}
!32 = !{!11, !4, i64 8}
!33 = distinct !{!33, !18, !19}
!34 = !{!11, !4, i64 20}
!35 = !{!23, !4, i64 16}
!36 = distinct !{!36, !18, !19}
!37 = !{i64 0, i64 4, !3, i64 4, i64 4, !3, i64 8, i64 4, !3, i64 12, i64 4, !3, i64 16, i64 4, !3, i64 20, i64 4, !3, i64 24, i64 4, !3, i64 28, i64 4, !3, i64 32, i64 4, !3, i64 36, i64 4, !3, i64 40, i64 4, !3, i64 44, i64 4, !3}
!38 = distinct !{!38, !18, !19}
!39 = distinct !{!39, !18, !19}
!40 = !{!41, !4, i64 16}
!41 = !{!"kimg", !5, i64 0, !4, i64 12, !4, i64 16, !4, i64 20, !4, i64 24, !4, i64 28, !4, i64 32, !4, i64 36, !4, i64 40, !4, i64 44, !4, i64 48, !4, i64 52, !4, i64 56, !4, i64 60, !4, i64 64, !4, i64 68}
!42 = !{!41, !4, i64 24}
!43 = !{!41, !4, i64 12}
!44 = !{!41, !4, i64 20}
!45 = distinct !{!45, !18, !19}
!46 = !{!41, !4, i64 28}
!47 = !{!41, !4, i64 32}
!48 = !{!41, !4, i64 36}
!49 = distinct !{!49, !18, !19}
!50 = !{!41, !4, i64 40}
!51 = distinct !{!51, !18, !19}
!52 = distinct !{!52, !18, !19}
!53 = distinct !{!53, !18, !19}
!54 = !{!41, !4, i64 52}
!55 = !{!41, !4, i64 56}
!56 = !{!11, !4, i64 28}
!57 = !{!41, !4, i64 60}
!58 = !{!41, !4, i64 48}
!59 = !{!41, !4, i64 64}
!60 = !{!41, !4, i64 68}
!61 = !{!41, !4, i64 44}
!62 = distinct !{!62, !18, !19}
!63 = !{!23, !4, i64 20}
!64 = distinct !{!64, !18, !19}
!65 = distinct !{!65, !18, !19}
!66 = distinct !{!66, !18, !19}
