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
  switch i32 %6, label %398 [
    i32 11, label %9
    i32 14, label %12
    i32 16, label %14
    i32 5, label %30
    i32 13, label %91
    i32 3, label %7
    i32 1, label %151
    i32 7, label %176
    i32 2, label %358
  ]

7:                                                ; preds = %0
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %103

9:                                                ; preds = %0
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %11 = load i32, ptr %10, align 4, !tbaa !24
  br label %398

12:                                               ; preds = %0
  %13 = load i32, ptr @ticks, align 4, !tbaa !3
  br label %398

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
  br label %398

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
  br i1 %69, label %398, label %70

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
  br i1 %82, label %83, label %398

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
  br i1 %90, label %398, label %75

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
  br label %409

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
  br label %398

139:                                              ; preds = %108
  %140 = icmp eq i32 %106, 0
  br i1 %140, label %398, label %141

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
  br label %409

151:                                              ; preds = %0, %154
  %152 = phi i32 [ %158, %154 ], [ 0, %0 ]
  %153 = icmp eq i32 %152, 8
  br i1 %153, label %398, label %154

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
  br label %409

176:                                              ; preds = %0
  %177 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %178 = load volatile i32, ptr %177, align 4, !tbaa !30
  %179 = inttoptr i32 %178 to ptr
  br label %180

180:                                              ; preds = %199, %176
  %181 = phi i32 [ 0, %176 ], [ %200, %199 ]
  %182 = icmp eq i32 %181, 4
  br i1 %182, label %398, label %183

183:                                              ; preds = %180
  %184 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %181
  %185 = load i8, ptr %184, align 4, !tbaa !27
  %186 = icmp eq i8 %185, 0
  br i1 %186, label %398, label %187

187:                                              ; preds = %183, %196
  %188 = phi i32 [ %198, %196 ], [ 0, %183 ]
  %189 = icmp eq i32 %188, 12
  br i1 %189, label %201, label %190

190:                                              ; preds = %187
  %191 = getelementptr inbounds nuw [12 x i8], ptr %184, i32 0, i32 %188
  %192 = load i8, ptr %191, align 1, !tbaa !27
  %193 = getelementptr inbounds nuw i8, ptr %179, i32 %188
  %194 = load i8, ptr %193, align 1, !tbaa !27
  %195 = icmp eq i8 %192, %194
  br i1 %195, label %196, label %199

196:                                              ; preds = %190
  %197 = icmp eq i8 %192, 0
  %198 = add nuw nsw i32 %188, 1
  br i1 %197, label %201, label %187, !llvm.loop !38

199:                                              ; preds = %190
  %200 = add nuw nsw i32 %181, 1
  br label %180, !llvm.loop !39

201:                                              ; preds = %196, %187
  %202 = getelementptr inbounds nuw i8, ptr %184, i32 16
  %203 = load i32, ptr %202, align 4, !tbaa !40
  %204 = tail call fastcc i32 @kalloc(i32 noundef %203) #5
  %205 = getelementptr inbounds nuw i8, ptr %184, i32 24
  %206 = load i32, ptr %205, align 4, !tbaa !42
  %207 = tail call fastcc i32 @kalloc(i32 noundef %206) #5
  %208 = icmp eq i32 %204, 0
  %209 = icmp eq i32 %207, 0
  %210 = select i1 %208, i1 true, i1 %209
  br i1 %210, label %398, label %211

211:                                              ; preds = %201
  %212 = getelementptr inbounds nuw i8, ptr %184, i32 12
  %213 = load i32, ptr %212, align 4, !tbaa !43
  %214 = inttoptr i32 %213 to ptr
  %215 = inttoptr i32 %204 to ptr
  br label %216

216:                                              ; preds = %227, %211
  %217 = phi i32 [ 0, %211 ], [ %231, %227 ]
  %218 = phi ptr [ %215, %211 ], [ %230, %227 ]
  %219 = phi ptr [ %214, %211 ], [ %228, %227 ]
  %220 = load i32, ptr %202, align 4, !tbaa !40
  %221 = icmp ult i32 %217, %220
  br i1 %221, label %227, label %222

222:                                              ; preds = %216
  %223 = getelementptr inbounds nuw i8, ptr %184, i32 20
  %224 = load i32, ptr %223, align 4, !tbaa !44
  %225 = inttoptr i32 %224 to ptr
  %226 = inttoptr i32 %207 to ptr
  br label %232

227:                                              ; preds = %216
  %228 = getelementptr inbounds nuw i8, ptr %219, i32 4
  %229 = load i32, ptr %219, align 4, !tbaa !3
  %230 = getelementptr inbounds nuw i8, ptr %218, i32 4
  store i32 %229, ptr %218, align 4, !tbaa !3
  %231 = add i32 %217, 4
  br label %216, !llvm.loop !45

232:                                              ; preds = %249, %222
  %233 = phi i32 [ 0, %222 ], [ %253, %249 ]
  %234 = phi ptr [ %226, %222 ], [ %252, %249 ]
  %235 = phi ptr [ %225, %222 ], [ %250, %249 ]
  %236 = load i32, ptr %205, align 4, !tbaa !42
  %237 = icmp ult i32 %233, %236
  br i1 %237, label %249, label %238

238:                                              ; preds = %232
  %239 = getelementptr inbounds nuw i8, ptr %184, i32 28
  %240 = load i32, ptr %239, align 4, !tbaa !46
  %241 = sub i32 %204, %240
  %242 = getelementptr inbounds nuw i8, ptr %184, i32 32
  %243 = load i32, ptr %242, align 4, !tbaa !47
  %244 = sub i32 %207, %243
  %245 = getelementptr inbounds nuw i8, ptr %184, i32 36
  %246 = load i32, ptr %245, align 4, !tbaa !48
  %247 = inttoptr i32 %246 to ptr
  %248 = getelementptr inbounds nuw i8, ptr %184, i32 40
  br label %254

249:                                              ; preds = %232
  %250 = getelementptr inbounds nuw i8, ptr %235, i32 4
  %251 = load i32, ptr %235, align 4, !tbaa !3
  %252 = getelementptr inbounds nuw i8, ptr %234, i32 4
  store i32 %251, ptr %234, align 4, !tbaa !3
  %253 = add i32 %233, 4
  br label %232, !llvm.loop !49

254:                                              ; preds = %262, %238
  %255 = phi i32 [ 0, %238 ], [ %275, %262 ]
  %256 = load i32, ptr %248, align 4, !tbaa !50
  %257 = icmp ult i32 %255, %256
  br i1 %257, label %262, label %258

258:                                              ; preds = %254
  %259 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %260 = load volatile i32, ptr %259, align 4, !tbaa !25
  %261 = icmp eq i32 %260, 0
  br i1 %261, label %318, label %276

262:                                              ; preds = %254
  %263 = getelementptr inbounds nuw i32, ptr %247, i32 %255
  %264 = load i32, ptr %263, align 4, !tbaa !3
  %265 = icmp slt i32 %264, 0
  %266 = select i1 %265, i32 %207, i32 %204
  %267 = and i32 %264, 1073741823
  %268 = add i32 %266, %267
  %269 = and i32 %264, 1073741824
  %270 = icmp eq i32 %269, 0
  %271 = select i1 %270, i32 %241, i32 %244
  %272 = inttoptr i32 %268 to ptr
  %273 = load volatile i32, ptr %272, align 4, !tbaa !3
  %274 = add i32 %271, %273
  store volatile i32 %274, ptr %272, align 4, !tbaa !3
  %275 = add nuw i32 %255, 1
  br label %254, !llvm.loop !51

276:                                              ; preds = %258
  %277 = load i32, ptr @arena, align 4, !tbaa !3
  %278 = add i32 %277, 256
  %279 = load i32, ptr @arena_end, align 4, !tbaa !3
  %280 = icmp ugt i32 %278, %279
  br i1 %280, label %318, label %281

281:                                              ; preds = %276
  store i32 %278, ptr @arena, align 4, !tbaa !3
  %282 = icmp eq i32 %277, 0
  br i1 %282, label %318, label %283

283:                                              ; preds = %281
  %284 = load volatile i32, ptr %259, align 4, !tbaa !25
  %285 = inttoptr i32 %284 to ptr
  %286 = inttoptr i32 %277 to ptr
  %287 = add i32 %277, 64
  %288 = inttoptr i32 %287 to ptr
  %289 = inttoptr i32 %278 to ptr
  %290 = getelementptr inbounds i8, ptr %289, i32 -1
  br label %291

291:                                              ; preds = %313, %283
  %292 = phi i32 [ 0, %283 ], [ %315, %313 ]
  %293 = phi ptr [ %288, %283 ], [ %314, %313 ]
  %294 = icmp eq i32 %292, 15
  br i1 %294, label %316, label %295

295:                                              ; preds = %291
  %296 = getelementptr inbounds nuw i32, ptr %285, i32 %292
  %297 = load i32, ptr %296, align 4, !tbaa !3
  %298 = icmp eq i32 %297, 0
  br i1 %298, label %316, label %299

299:                                              ; preds = %295
  %300 = inttoptr i32 %297 to ptr
  %301 = ptrtoint ptr %293 to i32
  %302 = getelementptr inbounds nuw i32, ptr %286, i32 %292
  store i32 %301, ptr %302, align 4, !tbaa !3
  br label %303

303:                                              ; preds = %310, %299
  %304 = phi ptr [ %293, %299 ], [ %312, %310 ]
  %305 = phi ptr [ %300, %299 ], [ %311, %310 ]
  %306 = load i8, ptr %305, align 1, !tbaa !27
  %307 = icmp ne i8 %306, 0
  %308 = icmp ult ptr %304, %290
  %309 = select i1 %307, i1 %308, i1 false
  br i1 %309, label %310, label %313

310:                                              ; preds = %303
  %311 = getelementptr inbounds nuw i8, ptr %305, i32 1
  %312 = getelementptr inbounds nuw i8, ptr %304, i32 1
  store i8 %306, ptr %304, align 1, !tbaa !27
  br label %303, !llvm.loop !52

313:                                              ; preds = %303
  %314 = getelementptr inbounds nuw i8, ptr %304, i32 1
  store i8 0, ptr %304, align 1, !tbaa !27
  %315 = add nuw nsw i32 %292, 1
  br label %291, !llvm.loop !53

316:                                              ; preds = %291, %295
  %317 = getelementptr inbounds nuw i32, ptr %286, i32 %292
  store i32 0, ptr %317, align 4, !tbaa !3
  br label %318

318:                                              ; preds = %276, %281, %316, %258
  %319 = phi i32 [ 0, %258 ], [ %292, %316 ], [ 0, %281 ], [ 0, %276 ]
  %320 = phi i32 [ 0, %258 ], [ %277, %316 ], [ 0, %281 ], [ 0, %276 ]
  %321 = getelementptr inbounds nuw i8, ptr %184, i32 52
  %322 = load i32, ptr %321, align 4, !tbaa !54
  %323 = add i32 %322, %207
  %324 = getelementptr inbounds nuw i8, ptr %2, i32 24
  store i32 %323, ptr %324, align 4, !tbaa !13
  %325 = getelementptr inbounds nuw i8, ptr %184, i32 56
  %326 = load i32, ptr %325, align 4, !tbaa !55
  %327 = add i32 %326, %207
  %328 = getelementptr inbounds nuw i8, ptr %2, i32 28
  store i32 %327, ptr %328, align 4, !tbaa !56
  %329 = getelementptr inbounds nuw i8, ptr %184, i32 60
  %330 = load i32, ptr %329, align 4, !tbaa !57
  %331 = add i32 %330, %207
  %332 = getelementptr inbounds nuw i8, ptr %2, i32 32
  store i32 %331, ptr %332, align 4, !tbaa !31
  %333 = getelementptr inbounds nuw i8, ptr %184, i32 48
  %334 = load i32, ptr %333, align 4, !tbaa !58
  %335 = add i32 %334, %204
  %336 = getelementptr inbounds nuw i8, ptr %2, i32 36
  store i32 %335, ptr %336, align 4, !tbaa !14
  %337 = getelementptr inbounds nuw i8, ptr %184, i32 64
  %338 = load i32, ptr %337, align 4, !tbaa !59
  %339 = add i32 %338, %207
  store i32 %339, ptr %3, align 4, !tbaa !21
  %340 = load i32, ptr @k_sysentry, align 4, !tbaa !3
  %341 = getelementptr inbounds nuw i8, ptr %184, i32 68
  %342 = load i32, ptr %341, align 4, !tbaa !60
  %343 = add i32 %342, %207
  %344 = inttoptr i32 %343 to ptr
  store volatile i32 %340, ptr %344, align 4, !tbaa !3
  %345 = load i32, ptr %336, align 4, !tbaa !14
  %346 = load i32, ptr %324, align 4, !tbaa !13
  %347 = inttoptr i32 %346 to ptr
  store volatile i32 %345, ptr %347, align 4, !tbaa !3
  %348 = load i32, ptr %321, align 4, !tbaa !54
  %349 = add i32 %348, %207
  %350 = add i32 %349, -84
  %351 = inttoptr i32 %350 to ptr
  store volatile i32 %319, ptr %351, align 4, !tbaa !3
  %352 = add i32 %349, -80
  %353 = inttoptr i32 %352 to ptr
  store volatile i32 %320, ptr %353, align 4, !tbaa !3
  tail call fastcc void @vfork_release(ptr noundef nonnull %2) #5
  store i32 4, ptr %2, align 4, !tbaa !12
  %354 = load i32, ptr @curr, align 4, !tbaa !3
  %355 = getelementptr inbounds nuw i8, ptr %184, i32 44
  %356 = load i32, ptr %355, align 4, !tbaa !61
  %357 = add i32 %356, %204
  tail call fastcc void @kexit(i32 noundef %354, i32 noundef %357) #5
  br label %414

358:                                              ; preds = %0
  %359 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %360 = load volatile i32, ptr %359, align 4, !tbaa !30
  %361 = getelementptr inbounds nuw i8, ptr %2, i32 20
  store i32 %360, ptr %361, align 4, !tbaa !34
  tail call fastcc void @vfork_release(ptr noundef nonnull %2) #5
  %362 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %363 = load i32, ptr %362, align 4, !tbaa !32
  br label %364

364:                                              ; preds = %392, %358
  %365 = phi i32 [ 0, %358 ], [ %393, %392 ]
  %366 = icmp eq i32 %365, 8
  br i1 %366, label %407, label %367

367:                                              ; preds = %364
  %368 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %365
  %369 = getelementptr inbounds nuw i8, ptr %368, i32 4
  %370 = load i32, ptr %369, align 4, !tbaa !24
  %371 = icmp eq i32 %370, %363
  br i1 %371, label %372, label %392

372:                                              ; preds = %367
  %373 = load i32, ptr %368, align 4, !tbaa !12
  %374 = icmp eq i32 %373, 2
  br i1 %374, label %375, label %392

375:                                              ; preds = %372
  %376 = getelementptr inbounds nuw i8, ptr %368, i32 12
  %377 = load i32, ptr %376, align 4, !tbaa !15
  %378 = ptrtoint ptr %368 to i32
  %379 = icmp eq i32 %377, %378
  br i1 %379, label %380, label %392

380:                                              ; preds = %375
  %381 = getelementptr inbounds nuw i8, ptr %368, i32 12
  %382 = getelementptr inbounds nuw i8, ptr %368, i32 44
  %383 = load i32, ptr %382, align 4, !tbaa !21
  %384 = inttoptr i32 %383 to ptr
  %385 = getelementptr inbounds nuw i8, ptr %384, i32 4
  %386 = load volatile i32, ptr %385, align 4, !tbaa !30
  %387 = icmp eq i32 %386, 0
  br i1 %387, label %394, label %388

388:                                              ; preds = %380
  %389 = load i32, ptr %361, align 4, !tbaa !34
  %390 = load volatile i32, ptr %385, align 4, !tbaa !30
  %391 = inttoptr i32 %390 to ptr
  store volatile i32 %389, ptr %391, align 4, !tbaa !3
  br label %394

392:                                              ; preds = %375, %372, %367
  %393 = add nuw nsw i32 %365, 1
  br label %364, !llvm.loop !62

394:                                              ; preds = %388, %380
  %395 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %396 = load i32, ptr %395, align 4, !tbaa !24
  %397 = getelementptr inbounds nuw i8, ptr %384, i32 16
  store volatile i32 %396, ptr %397, align 4, !tbaa !35
  store i32 0, ptr %381, align 4, !tbaa !15
  store i32 3, ptr %368, align 4, !tbaa !12
  br label %407

398:                                              ; preds = %183, %180, %151, %83, %75, %0, %9, %12, %23, %68, %135, %139, %201
  %399 = phi i32 [ -1, %201 ], [ -1, %139 ], [ %138, %135 ], [ 0, %68 ], [ %24, %23 ], [ %13, %12 ], [ %11, %9 ], [ -1, %0 ], [ %88, %83 ], [ %76, %75 ], [ -1, %151 ], [ -1, %180 ], [ -1, %183 ]
  %400 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store volatile i32 %399, ptr %400, align 4, !tbaa !35
  %401 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store volatile i32 1, ptr %401, align 4, !tbaa !63
  store i32 4, ptr %2, align 4, !tbaa !12
  %402 = load i32, ptr @curr, align 4, !tbaa !3
  %403 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %404 = load i32, ptr %403, align 4, !tbaa !31
  %405 = inttoptr i32 %404 to ptr
  %406 = load volatile i32, ptr %405, align 4, !tbaa !3
  tail call fastcc void @kexit(i32 noundef %402, i32 noundef %406) #5
  br label %414

407:                                              ; preds = %364, %394
  %408 = phi i32 [ 0, %394 ], [ 5, %364 ]
  store i32 %408, ptr %2, align 4, !tbaa !12
  br label %412

409:                                              ; preds = %91, %141, %159
  %410 = phi i32 [ 0, %159 ], [ %150, %141 ], [ 0, %91 ]
  %411 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store volatile i32 %410, ptr %411, align 4, !tbaa !35
  br label %412

412:                                              ; preds = %407, %409
  %413 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store volatile i32 1, ptr %413, align 4, !tbaa !63
  tail call fastcc void @swtch() #5
  br label %414

414:                                              ; preds = %318, %412, %398
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

4:                                                ; preds = %22, %1
  %5 = phi i32 [ 0, %1 ], [ %23, %22 ]
  %6 = icmp eq i32 %5, 8
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %5
  %10 = load i32, ptr %9, align 4, !tbaa !12
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %22

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !15
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %22

16:                                               ; preds = %12
  %17 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %18 = load i32, ptr %17, align 4, !tbaa !21
  %19 = inttoptr i32 %18 to ptr
  %20 = load i32, ptr %3, align 4, !tbaa !24
  %21 = getelementptr inbounds nuw i8, ptr %19, i32 16
  store volatile i32 %20, ptr %21, align 4, !tbaa !35
  store i32 0, ptr %13, align 4, !tbaa !15
  store i32 3, ptr %9, align 4, !tbaa !12
  br label %22

22:                                               ; preds = %16, %12, %8
  %23 = add nuw nsw i32 %5, 1
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
