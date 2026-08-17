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
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
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

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #0 {
  tail call fastcc void @kenter() #4
  tail call fastcc void @tick_income() #4
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
  tail call fastcc void @swtch() #4
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
  tail call fastcc void @tick_income() #4
  br label %11

11:                                               ; preds = %10, %0
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr inttoptr (i32 1342177476 to ptr), align 4, !tbaa !3
  %12 = load i32, ptr @tickpending, align 4, !tbaa !3
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %15, label %14

14:                                               ; preds = %11
  store i32 0, ptr @tickpending, align 4, !tbaa !3
  tail call fastcc void @tick_income() #4
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
  tail call fastcc void @kexit(i32 noundef %1, i32 noundef %16) #4
  br label %20

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %19 = load i32, ptr %18, align 4, !tbaa !10
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %19) #4
  br label %20

20:                                               ; preds = %17, %14
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #0 {
  tail call fastcc void @kenter() #4
  %1 = load i32, ptr @curr, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %1
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %4 = load i32, ptr %3, align 4, !tbaa !21
  %5 = inttoptr i32 %4 to ptr
  %6 = load volatile i32, ptr %5, align 4, !tbaa !22
  switch i32 %6, label %287 [
    i32 11, label %9
    i32 14, label %12
    i32 16, label %14
    i32 13, label %34
    i32 3, label %7
    i32 1, label %94
    i32 7, label %119
    i32 2, label %247
  ]

7:                                                ; preds = %0
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %46

9:                                                ; preds = %0
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %11 = load i32, ptr %10, align 4, !tbaa !24
  br label %287

12:                                               ; preds = %0
  %13 = load i32, ptr @ticks, align 4, !tbaa !3
  br label %287

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
  br label %287

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
  br label %298

46:                                               ; preds = %7, %65
  %47 = phi i32 [ %68, %65 ], [ 0, %7 ]
  %48 = phi i32 [ %66, %65 ], [ -1, %7 ]
  %49 = phi i32 [ %67, %65 ], [ 0, %7 ]
  %50 = icmp eq i32 %47, 8
  br i1 %50, label %51, label %53

51:                                               ; preds = %46
  %52 = icmp sgt i32 %48, -1
  br i1 %52, label %69, label %82

53:                                               ; preds = %46
  %54 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %47
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
  %64 = select i1 %63, i32 %47, i32 %48
  br label %65

65:                                               ; preds = %62, %53, %57
  %66 = phi i32 [ %48, %57 ], [ %48, %53 ], [ %64, %62 ]
  %67 = phi i32 [ %49, %57 ], [ %49, %53 ], [ 1, %62 ]
  %68 = add nuw nsw i32 %47, 1
  br label %46, !llvm.loop !33

69:                                               ; preds = %51
  %70 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %71 = load volatile i32, ptr %70, align 4, !tbaa !30
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %78, label %73

73:                                               ; preds = %69
  %74 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %48, i32 5
  %75 = load i32, ptr %74, align 4, !tbaa !34
  %76 = load volatile i32, ptr %70, align 4, !tbaa !30
  %77 = inttoptr i32 %76 to ptr
  store volatile i32 %75, ptr %77, align 4, !tbaa !3
  br label %78

78:                                               ; preds = %73, %69
  %79 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %48
  %80 = getelementptr inbounds nuw i8, ptr %79, i32 4
  %81 = load i32, ptr %80, align 4, !tbaa !24
  store i32 0, ptr %79, align 4, !tbaa !12
  br label %287

82:                                               ; preds = %51
  %83 = icmp eq i32 %49, 0
  br i1 %83, label %287, label %84

84:                                               ; preds = %82
  %85 = ptrtoint ptr %2 to i32
  %86 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %87 = load i32, ptr %86, align 4, !tbaa !31
  %88 = inttoptr i32 %87 to ptr
  %89 = load volatile i32, ptr %88, align 4, !tbaa !3
  %90 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %89, ptr %90, align 4, !tbaa !10
  %91 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 %85, ptr %91, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  %92 = getelementptr inbounds nuw i8, ptr %5, i32 16
  %93 = load volatile i32, ptr %92, align 4, !tbaa !35
  br label %298

94:                                               ; preds = %0, %97
  %95 = phi i32 [ %101, %97 ], [ 0, %0 ]
  %96 = icmp eq i32 %95, 8
  br i1 %96, label %287, label %97

97:                                               ; preds = %94
  %98 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %95
  %99 = load i32, ptr %98, align 4, !tbaa !12
  %100 = icmp eq i32 %99, 0
  %101 = add nuw nsw i32 %95, 1
  br i1 %100, label %102, label %94, !llvm.loop !36

102:                                              ; preds = %97
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(48) %98, ptr noundef nonnull align 4 dereferenceable(48) %2, i32 48, i1 false), !tbaa.struct !37
  %103 = load i32, ptr @nextpid, align 4, !tbaa !3
  %104 = add i32 %103, 1
  store i32 %104, ptr @nextpid, align 4, !tbaa !3
  %105 = getelementptr inbounds nuw i8, ptr %98, i32 4
  store i32 %103, ptr %105, align 4, !tbaa !24
  %106 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %107 = load i32, ptr %106, align 4, !tbaa !24
  %108 = getelementptr inbounds nuw i8, ptr %98, i32 8
  store i32 %107, ptr %108, align 4, !tbaa !32
  %109 = getelementptr inbounds nuw i8, ptr %98, i32 12
  store i32 0, ptr %109, align 4, !tbaa !15
  store i32 3, ptr %98, align 4, !tbaa !12
  %110 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %111 = load i32, ptr %110, align 4, !tbaa !31
  %112 = inttoptr i32 %111 to ptr
  %113 = load volatile i32, ptr %112, align 4, !tbaa !3
  %114 = getelementptr inbounds nuw i8, ptr %98, i32 40
  store i32 %113, ptr %114, align 4, !tbaa !10
  %115 = load volatile i32, ptr %112, align 4, !tbaa !3
  %116 = getelementptr inbounds nuw i8, ptr %2, i32 40
  store i32 %115, ptr %116, align 4, !tbaa !10
  %117 = ptrtoint ptr %98 to i32
  %118 = getelementptr inbounds nuw i8, ptr %2, i32 12
  store i32 %117, ptr %118, align 4, !tbaa !15
  store i32 2, ptr %2, align 4, !tbaa !12
  br label %298

119:                                              ; preds = %0
  %120 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %121 = load volatile i32, ptr %120, align 4, !tbaa !30
  %122 = inttoptr i32 %121 to ptr
  br label %123

123:                                              ; preds = %142, %119
  %124 = phi i32 [ 0, %119 ], [ %143, %142 ]
  %125 = icmp eq i32 %124, 4
  br i1 %125, label %287, label %126

126:                                              ; preds = %123
  %127 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %124
  %128 = load i8, ptr %127, align 4, !tbaa !28
  %129 = icmp eq i8 %128, 0
  br i1 %129, label %287, label %130

130:                                              ; preds = %126, %139
  %131 = phi i32 [ %141, %139 ], [ 0, %126 ]
  %132 = icmp eq i32 %131, 12
  br i1 %132, label %144, label %133

133:                                              ; preds = %130
  %134 = getelementptr inbounds nuw [12 x i8], ptr %127, i32 0, i32 %131
  %135 = load i8, ptr %134, align 1, !tbaa !28
  %136 = getelementptr inbounds nuw i8, ptr %122, i32 %131
  %137 = load i8, ptr %136, align 1, !tbaa !28
  %138 = icmp eq i8 %135, %137
  br i1 %138, label %139, label %142

139:                                              ; preds = %133
  %140 = icmp eq i8 %135, 0
  %141 = add nuw nsw i32 %131, 1
  br i1 %140, label %144, label %130, !llvm.loop !38

142:                                              ; preds = %133
  %143 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !39

144:                                              ; preds = %139, %130
  %145 = getelementptr inbounds nuw i8, ptr %127, i32 16
  %146 = load i32, ptr %145, align 4, !tbaa !40
  %147 = tail call fastcc i32 @kalloc(i32 noundef %146) #4
  %148 = getelementptr inbounds nuw i8, ptr %127, i32 24
  %149 = load i32, ptr %148, align 4, !tbaa !42
  %150 = tail call fastcc i32 @kalloc(i32 noundef %149) #4
  %151 = icmp eq i32 %147, 0
  %152 = icmp eq i32 %150, 0
  %153 = select i1 %151, i1 true, i1 %152
  br i1 %153, label %287, label %154

154:                                              ; preds = %144
  %155 = getelementptr inbounds nuw i8, ptr %127, i32 12
  %156 = load i32, ptr %155, align 4, !tbaa !43
  %157 = inttoptr i32 %156 to ptr
  %158 = inttoptr i32 %147 to ptr
  br label %159

159:                                              ; preds = %170, %154
  %160 = phi ptr [ %157, %154 ], [ %171, %170 ]
  %161 = phi ptr [ %158, %154 ], [ %173, %170 ]
  %162 = phi i32 [ 0, %154 ], [ %174, %170 ]
  %163 = load i32, ptr %145, align 4, !tbaa !40
  %164 = icmp ult i32 %162, %163
  br i1 %164, label %170, label %165

165:                                              ; preds = %159
  %166 = getelementptr inbounds nuw i8, ptr %127, i32 20
  %167 = load i32, ptr %166, align 4, !tbaa !44
  %168 = inttoptr i32 %167 to ptr
  %169 = inttoptr i32 %150 to ptr
  br label %175

170:                                              ; preds = %159
  %171 = getelementptr inbounds nuw i8, ptr %160, i32 4
  %172 = load i32, ptr %160, align 4, !tbaa !3
  %173 = getelementptr inbounds nuw i8, ptr %161, i32 4
  store i32 %172, ptr %161, align 4, !tbaa !3
  %174 = add i32 %162, 4
  br label %159, !llvm.loop !45

175:                                              ; preds = %192, %165
  %176 = phi ptr [ %168, %165 ], [ %193, %192 ]
  %177 = phi ptr [ %169, %165 ], [ %195, %192 ]
  %178 = phi i32 [ 0, %165 ], [ %196, %192 ]
  %179 = load i32, ptr %148, align 4, !tbaa !42
  %180 = icmp ult i32 %178, %179
  br i1 %180, label %192, label %181

181:                                              ; preds = %175
  %182 = getelementptr inbounds nuw i8, ptr %127, i32 28
  %183 = load i32, ptr %182, align 4, !tbaa !46
  %184 = sub i32 %147, %183
  %185 = getelementptr inbounds nuw i8, ptr %127, i32 32
  %186 = load i32, ptr %185, align 4, !tbaa !47
  %187 = sub i32 %150, %186
  %188 = getelementptr inbounds nuw i8, ptr %127, i32 36
  %189 = load i32, ptr %188, align 4, !tbaa !48
  %190 = inttoptr i32 %189 to ptr
  %191 = getelementptr inbounds nuw i8, ptr %127, i32 40
  br label %197

192:                                              ; preds = %175
  %193 = getelementptr inbounds nuw i8, ptr %176, i32 4
  %194 = load i32, ptr %176, align 4, !tbaa !3
  %195 = getelementptr inbounds nuw i8, ptr %177, i32 4
  store i32 %194, ptr %177, align 4, !tbaa !3
  %196 = add i32 %178, 4
  br label %175, !llvm.loop !49

197:                                              ; preds = %233, %181
  %198 = phi i32 [ 0, %181 ], [ %246, %233 ]
  %199 = load i32, ptr %191, align 4, !tbaa !50
  %200 = icmp ult i32 %198, %199
  br i1 %200, label %233, label %201

201:                                              ; preds = %197
  %202 = getelementptr inbounds nuw i8, ptr %127, i32 52
  %203 = load i32, ptr %202, align 4, !tbaa !51
  %204 = add i32 %203, %150
  %205 = getelementptr inbounds nuw i8, ptr %2, i32 24
  store i32 %204, ptr %205, align 4, !tbaa !13
  %206 = getelementptr inbounds nuw i8, ptr %127, i32 56
  %207 = load i32, ptr %206, align 4, !tbaa !52
  %208 = add i32 %207, %150
  %209 = getelementptr inbounds nuw i8, ptr %2, i32 28
  store i32 %208, ptr %209, align 4, !tbaa !53
  %210 = getelementptr inbounds nuw i8, ptr %127, i32 60
  %211 = load i32, ptr %210, align 4, !tbaa !54
  %212 = add i32 %211, %150
  %213 = getelementptr inbounds nuw i8, ptr %2, i32 32
  store i32 %212, ptr %213, align 4, !tbaa !31
  %214 = getelementptr inbounds nuw i8, ptr %127, i32 48
  %215 = load i32, ptr %214, align 4, !tbaa !55
  %216 = add i32 %215, %147
  %217 = getelementptr inbounds nuw i8, ptr %2, i32 36
  store i32 %216, ptr %217, align 4, !tbaa !14
  %218 = getelementptr inbounds nuw i8, ptr %127, i32 64
  %219 = load i32, ptr %218, align 4, !tbaa !56
  %220 = add i32 %219, %150
  store i32 %220, ptr %3, align 4, !tbaa !21
  %221 = load i32, ptr @k_sysentry, align 4, !tbaa !3
  %222 = getelementptr inbounds nuw i8, ptr %127, i32 68
  %223 = load i32, ptr %222, align 4, !tbaa !57
  %224 = add i32 %223, %150
  %225 = inttoptr i32 %224 to ptr
  store volatile i32 %221, ptr %225, align 4, !tbaa !3
  %226 = load i32, ptr %217, align 4, !tbaa !14
  %227 = load i32, ptr %205, align 4, !tbaa !13
  %228 = inttoptr i32 %227 to ptr
  store volatile i32 %226, ptr %228, align 4, !tbaa !3
  tail call fastcc void @vfork_release(ptr noundef nonnull %2) #4
  store i32 4, ptr %2, align 4, !tbaa !12
  %229 = load i32, ptr @curr, align 4, !tbaa !3
  %230 = getelementptr inbounds nuw i8, ptr %127, i32 44
  %231 = load i32, ptr %230, align 4, !tbaa !58
  %232 = add i32 %231, %147
  tail call fastcc void @kexit(i32 noundef %229, i32 noundef %232) #4
  br label %303

233:                                              ; preds = %197
  %234 = getelementptr inbounds nuw i32, ptr %190, i32 %198
  %235 = load i32, ptr %234, align 4, !tbaa !3
  %236 = icmp slt i32 %235, 0
  %237 = select i1 %236, i32 %150, i32 %147
  %238 = and i32 %235, 1073741823
  %239 = add i32 %237, %238
  %240 = and i32 %235, 1073741824
  %241 = icmp eq i32 %240, 0
  %242 = select i1 %241, i32 %184, i32 %187
  %243 = inttoptr i32 %239 to ptr
  %244 = load volatile i32, ptr %243, align 4, !tbaa !3
  %245 = add i32 %242, %244
  store volatile i32 %245, ptr %243, align 4, !tbaa !3
  %246 = add nuw i32 %198, 1
  br label %197, !llvm.loop !59

247:                                              ; preds = %0
  %248 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %249 = load volatile i32, ptr %248, align 4, !tbaa !30
  %250 = getelementptr inbounds nuw i8, ptr %2, i32 20
  store i32 %249, ptr %250, align 4, !tbaa !34
  tail call fastcc void @vfork_release(ptr noundef nonnull %2) #4
  %251 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %252 = load i32, ptr %251, align 4, !tbaa !32
  br label %253

253:                                              ; preds = %281, %247
  %254 = phi i32 [ 0, %247 ], [ %282, %281 ]
  %255 = icmp eq i32 %254, 8
  br i1 %255, label %296, label %256

256:                                              ; preds = %253
  %257 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %254
  %258 = getelementptr inbounds nuw i8, ptr %257, i32 4
  %259 = load i32, ptr %258, align 4, !tbaa !24
  %260 = icmp eq i32 %259, %252
  br i1 %260, label %261, label %281

261:                                              ; preds = %256
  %262 = load i32, ptr %257, align 4, !tbaa !12
  %263 = icmp eq i32 %262, 2
  br i1 %263, label %264, label %281

264:                                              ; preds = %261
  %265 = getelementptr inbounds nuw i8, ptr %257, i32 12
  %266 = load i32, ptr %265, align 4, !tbaa !15
  %267 = ptrtoint ptr %257 to i32
  %268 = icmp eq i32 %266, %267
  br i1 %268, label %269, label %281

269:                                              ; preds = %264
  %270 = getelementptr inbounds nuw i8, ptr %257, i32 12
  %271 = getelementptr inbounds nuw i8, ptr %257, i32 44
  %272 = load i32, ptr %271, align 4, !tbaa !21
  %273 = inttoptr i32 %272 to ptr
  %274 = getelementptr inbounds nuw i8, ptr %273, i32 4
  %275 = load volatile i32, ptr %274, align 4, !tbaa !30
  %276 = icmp eq i32 %275, 0
  br i1 %276, label %283, label %277

277:                                              ; preds = %269
  %278 = load i32, ptr %250, align 4, !tbaa !34
  %279 = load volatile i32, ptr %274, align 4, !tbaa !30
  %280 = inttoptr i32 %279 to ptr
  store volatile i32 %278, ptr %280, align 4, !tbaa !3
  br label %283

281:                                              ; preds = %264, %261, %256
  %282 = add nuw nsw i32 %254, 1
  br label %253, !llvm.loop !60

283:                                              ; preds = %277, %269
  %284 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %285 = load i32, ptr %284, align 4, !tbaa !24
  %286 = getelementptr inbounds nuw i8, ptr %273, i32 16
  store volatile i32 %285, ptr %286, align 4, !tbaa !35
  store i32 0, ptr %270, align 4, !tbaa !15
  store i32 3, ptr %257, align 4, !tbaa !12
  br label %296

287:                                              ; preds = %126, %123, %94, %0, %9, %12, %23, %78, %82, %144
  %288 = phi i32 [ -1, %144 ], [ -1, %82 ], [ %81, %78 ], [ %24, %23 ], [ %13, %12 ], [ %11, %9 ], [ -1, %0 ], [ -1, %94 ], [ -1, %123 ], [ -1, %126 ]
  %289 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store volatile i32 %288, ptr %289, align 4, !tbaa !35
  %290 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store volatile i32 1, ptr %290, align 4, !tbaa !61
  store i32 4, ptr %2, align 4, !tbaa !12
  %291 = load i32, ptr @curr, align 4, !tbaa !3
  %292 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %293 = load i32, ptr %292, align 4, !tbaa !31
  %294 = inttoptr i32 %293 to ptr
  %295 = load volatile i32, ptr %294, align 4, !tbaa !3
  tail call fastcc void @kexit(i32 noundef %291, i32 noundef %295) #4
  br label %303

296:                                              ; preds = %253, %283
  %297 = phi i32 [ 0, %283 ], [ 5, %253 ]
  store i32 %297, ptr %2, align 4, !tbaa !12
  br label %301

298:                                              ; preds = %34, %84, %102
  %299 = phi i32 [ 0, %102 ], [ %93, %84 ], [ 0, %34 ]
  %300 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store volatile i32 %299, ptr %300, align 4, !tbaa !35
  br label %301

301:                                              ; preds = %296, %298
  %302 = getelementptr inbounds nuw i8, ptr %5, i32 20
  store volatile i32 1, ptr %302, align 4, !tbaa !61
  tail call fastcc void @swtch() #4
  br label %303

303:                                              ; preds = %201, %301, %287
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #2

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #3 {
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
  br label %4, !llvm.loop !62
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
  %11 = load i32, ptr %10, align 4, !tbaa !53
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
  tail call fastcc void @tick_income() #4
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
  tail call void @dma_ktick() #4
  tail call void @dma_ksyscall() #4
  ret i32 0
}

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }

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
!51 = !{!41, !4, i64 52}
!52 = !{!41, !4, i64 56}
!53 = !{!11, !4, i64 28}
!54 = !{!41, !4, i64 60}
!55 = !{!41, !4, i64 48}
!56 = !{!41, !4, i64 64}
!57 = !{!41, !4, i64 68}
!58 = !{!41, !4, i64 44}
!59 = distinct !{!59, !18, !19}
!60 = distinct !{!60, !18, !19}
!61 = !{!23, !4, i64 20}
!62 = distinct !{!62, !18, !19}
