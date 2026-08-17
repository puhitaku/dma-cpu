; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@inj_wreg = dso_local local_unnamed_addr global i32 1342177476, align 4
@inj_treg = dso_local local_unnamed_addr global i32 1342177500, align 4
@cons_r = internal unnamed_addr global i32 0, align 4
@cons_w = internal unnamed_addr global i32 0, align 4
@cons_buf = internal unnamed_addr global [128 x i8] zeroinitializer, align 1
@proc = dso_local global [8 x %struct.proc] zeroinitializer, align 4
@curr = dso_local local_unnamed_addr global i32 0, align 4
@waspark = internal unnamed_addr global i32 0, align 4
@kw_curresume = dso_local global ptr null, align 4
@ticks = dso_local global i32 0, align 4
@fsready = external dso_local local_unnamed_addr global i32, align 4
@nextpid = dso_local local_unnamed_addr global i32 0, align 4
@execmem = internal unnamed_addr global [8 x [3 x i32]] zeroinitializer, align 4
@k_sysentry = dso_local local_unnamed_addr global i32 0, align 4
@kw_pcurdisp = dso_local global ptr null, align 4
@kw_curthunk = dso_local global ptr null, align 4
@kw_pcurresume = dso_local global ptr null, align 4
@kw_nextresume = dso_local global ptr null, align 4
@kw_park = dso_local global ptr null, align 4
@kw_parkvec = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@kimages = dso_local local_unnamed_addr global [4 x %struct.kimg] zeroinitializer, align 4
@initpid = dso_local local_unnamed_addr global i32 0, align 4
@fgpid = dso_local local_unnamed_addr global i32 0, align 4
@arena = dso_local local_unnamed_addr global i32 0, align 4
@arena_end = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@cons_e = internal unnamed_addr global i32 0, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@parked = internal unnamed_addr global i1 false, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4
@heapmem = internal unnamed_addr global [8 x i32] zeroinitializer, align 4
@kheap_init = internal unnamed_addr global i1 false, align 4
@kfreelist = internal unnamed_addr global ptr null, align 4

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kconswrite(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #0 {
  br label %3

3:                                                ; preds = %7, %2
  %4 = phi i32 [ 0, %2 ], [ %11, %7 ]
  %5 = icmp slt i32 %4, %1
  br i1 %5, label %7, label %6

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %9 = load i8, ptr %8, align 1, !tbaa !3
  %10 = sext i8 %9 to i32
  tail call fastcc void @cputc(i32 noundef %10) #12
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !6
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none)
define internal fastcc void @cputc(i32 noundef range(i32 -128, 256) %0) unnamed_addr #2 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %8

3:                                                ; preds = %1, %3
  %4 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %5 = and i32 %4, 32
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %3, !llvm.loop !11

7:                                                ; preds = %3
  store volatile i32 13, ptr @__dma_uart_dr, align 4, !tbaa !9
  br label %8

8:                                                ; preds = %7, %1
  br label %9

9:                                                ; preds = %8, %9
  %10 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %11 = and i32 %10, 32
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %9, !llvm.loop !12

13:                                               ; preds = %9
  %14 = and i32 %0, 255
  store volatile i32 %14, ptr @__dma_uart_dr, align 4, !tbaa !9
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #3 {
  tail call fastcc void @cons_poll() #12
  %3 = load i32, ptr @cons_r, align 4, !tbaa !9
  %4 = load i32, ptr @cons_w, align 4, !tbaa !9
  %5 = icmp eq i32 %3, %4
  br i1 %5, label %23, label %6

6:                                                ; preds = %2
  %7 = inttoptr i32 %0 to ptr
  br label %8

8:                                                ; preds = %15, %6
  %9 = phi i32 [ 0, %6 ], [ %20, %15 ]
  %10 = icmp slt i32 %9, %1
  %11 = load i32, ptr @cons_r, align 4
  %12 = load i32, ptr @cons_w, align 4
  %13 = icmp ne i32 %11, %12
  %14 = select i1 %10, i1 %13, i1 false
  br i1 %14, label %15, label %23

15:                                               ; preds = %8
  %16 = and i32 %11, 127
  %17 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3
  %19 = add i32 %11, 1
  store i32 %19, ptr @cons_r, align 4, !tbaa !9
  %20 = add nuw nsw i32 %9, 1
  %21 = getelementptr inbounds nuw i8, ptr %7, i32 %9
  store i8 %18, ptr %21, align 1, !tbaa !3
  %22 = icmp eq i8 %18, 10
  br i1 %22, label %23, label %8

23:                                               ; preds = %15, %8, %2
  %24 = phi i32 [ -2, %2 ], [ %9, %8 ], [ %20, %15 ]
  ret i32 %24
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cons_poll() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %67, %0
  %2 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %3 = and i32 %2, 16
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %175

5:                                                ; preds = %1
  %6 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !9
  %7 = and i32 %6, 255
  %8 = icmp eq i32 %7, 3
  br i1 %8, label %9, label %150

9:                                                ; preds = %5
  %10 = load i32, ptr @fgpid, align 4, !tbaa !9
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %67, label %12

12:                                               ; preds = %9, %23
  %13 = phi i32 [ %24, %23 ], [ 0, %9 ]
  %14 = icmp eq i32 %13, 8
  br i1 %14, label %67, label %15, !llvm.loop !13

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %13
  %17 = load i32, ptr %16, align 4, !tbaa !14
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %23, label %19

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %16, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !16
  %22 = icmp eq i32 %21, %10
  br i1 %22, label %25, label %23

23:                                               ; preds = %19, %15
  %24 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !17

25:                                               ; preds = %19
  %26 = icmp eq i32 %17, 2
  br i1 %26, label %27, label %67

27:                                               ; preds = %25
  %28 = getelementptr inbounds nuw i8, ptr %16, i32 12
  %29 = load i32, ptr %28, align 4, !tbaa !18
  %30 = ptrtoint ptr %16 to i32
  %31 = icmp eq i32 %29, %30
  br i1 %31, label %32, label %53

32:                                               ; preds = %27, %49
  %33 = phi ptr [ %50, %49 ], [ null, %27 ]
  %34 = phi i32 [ %51, %49 ], [ 0, %27 ]
  %35 = phi i32 [ %52, %49 ], [ 0, %27 ]
  %36 = icmp eq i32 %35, 8
  br i1 %36, label %65, label %37

37:                                               ; preds = %32
  %38 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %35
  %39 = load i32, ptr %38, align 4, !tbaa !14
  switch i32 %39, label %40 [
    i32 0, label %49
    i32 5, label %49
  ]

40:                                               ; preds = %37
  %41 = getelementptr inbounds nuw i8, ptr %38, i32 8
  %42 = load i32, ptr %41, align 4, !tbaa !19
  %43 = icmp eq i32 %42, %10
  br i1 %43, label %44, label %49

44:                                               ; preds = %40
  %45 = getelementptr inbounds nuw i8, ptr %38, i32 4
  %46 = load i32, ptr %45, align 4, !tbaa !16
  %47 = icmp ugt i32 %46, %34
  br i1 %47, label %48, label %49

48:                                               ; preds = %44
  br label %49

49:                                               ; preds = %48, %44, %40, %37, %37
  %50 = phi ptr [ %38, %48 ], [ %33, %44 ], [ %33, %40 ], [ %33, %37 ], [ %33, %37 ]
  %51 = phi i32 [ %46, %48 ], [ %34, %44 ], [ %34, %40 ], [ %34, %37 ], [ %34, %37 ]
  %52 = add nuw nsw i32 %35, 1
  br label %32, !llvm.loop !20

53:                                               ; preds = %27, %63
  %54 = phi i32 [ %64, %63 ], [ 0, %27 ]
  %55 = icmp eq i32 %54, 8
  br i1 %55, label %67, label %56, !llvm.loop !13

56:                                               ; preds = %53
  %57 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %54
  %58 = ptrtoint ptr %57 to i32
  %59 = icmp eq i32 %29, %58
  br i1 %59, label %60, label %63

60:                                               ; preds = %56
  %61 = load i32, ptr %57, align 4, !tbaa !14
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %63, label %68

63:                                               ; preds = %60, %56
  %64 = add nuw nsw i32 %54, 1
  br label %53, !llvm.loop !21

65:                                               ; preds = %32
  %66 = icmp eq ptr %33, null
  br i1 %66, label %67, label %68

67:                                               ; preds = %12, %53, %111, %65, %25, %9, %160, %174, %171, %154, %158
  br label %1, !llvm.loop !13

68:                                               ; preds = %60, %65
  %69 = phi ptr [ %33, %65 ], [ %57, %60 ]
  tail call fastcc void @cputc(i32 noundef 94) #12
  tail call fastcc void @cputc(i32 noundef 67) #12
  tail call fastcc void @cputc(i32 noundef 10) #12
  br label %70

70:                                               ; preds = %108, %68
  %71 = phi i32 [ 0, %68 ], [ %109, %108 ]
  %72 = phi i32 [ 0, %68 ], [ %110, %108 ]
  %73 = icmp eq i32 %72, 8
  br i1 %73, label %111, label %74

74:                                               ; preds = %70
  %75 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %72
  %76 = load i32, ptr %75, align 4, !tbaa !14
  switch i32 %76, label %77 [
    i32 0, label %108
    i32 5, label %108
  ]

77:                                               ; preds = %74, %102
  %78 = phi ptr [ %103, %102 ], [ %75, %74 ]
  %79 = phi i32 [ %104, %102 ], [ 0, %74 ]
  %80 = icmp eq ptr %78, null
  %81 = icmp samesign ugt i32 %79, 7
  %82 = select i1 %80, i1 true, i1 %81
  br i1 %82, label %108, label %83

83:                                               ; preds = %77
  %84 = icmp eq ptr %78, %69
  br i1 %84, label %105, label %85

85:                                               ; preds = %83
  %86 = getelementptr inbounds nuw i8, ptr %78, i32 8
  %87 = load i32, ptr %86, align 4, !tbaa !19
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %108, label %89

89:                                               ; preds = %85, %100
  %90 = phi i32 [ %101, %100 ], [ 0, %85 ]
  %91 = icmp eq i32 %90, 8
  br i1 %91, label %102, label %92

92:                                               ; preds = %89
  %93 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %90
  %94 = load i32, ptr %93, align 4, !tbaa !14
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %100, label %96

96:                                               ; preds = %92
  %97 = getelementptr inbounds nuw i8, ptr %93, i32 4
  %98 = load i32, ptr %97, align 4, !tbaa !16
  %99 = icmp eq i32 %98, %87
  br i1 %99, label %102, label %100

100:                                              ; preds = %96, %92
  %101 = add nuw nsw i32 %90, 1
  br label %89, !llvm.loop !22

102:                                              ; preds = %96, %89
  %103 = phi ptr [ null, %89 ], [ %93, %96 ]
  %104 = add nuw nsw i32 %79, 1
  br label %77, !llvm.loop !23

105:                                              ; preds = %83
  %106 = shl nuw nsw i32 1, %72
  %107 = or i32 %106, %71
  br label %108

108:                                              ; preds = %85, %77, %105, %74, %74
  %109 = phi i32 [ %107, %105 ], [ %71, %74 ], [ %71, %74 ], [ %71, %77 ], [ %71, %85 ]
  %110 = add nuw nsw i32 %72, 1
  br label %70, !llvm.loop !24

111:                                              ; preds = %70, %148
  %112 = phi i32 [ %149, %148 ], [ 0, %70 ]
  %113 = icmp eq i32 %112, 8
  br i1 %113, label %67, label %114, !llvm.loop !13

114:                                              ; preds = %111
  %115 = shl nuw nsw i32 1, %112
  %116 = and i32 %115, %71
  %117 = icmp eq i32 %116, 0
  br i1 %117, label %148, label %118

118:                                              ; preds = %114
  %119 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %112
  %120 = getelementptr inbounds nuw i8, ptr %119, i32 64
  %121 = load i32, ptr %120, align 4, !tbaa !25
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %142, label %123

123:                                              ; preds = %118
  %124 = getelementptr inbounds nuw i8, ptr %119, i32 68
  %125 = load i32, ptr %124, align 4, !tbaa !26
  %126 = icmp eq i32 %125, 0
  br i1 %126, label %127, label %148

127:                                              ; preds = %123
  %128 = load i32, ptr %119, align 4, !tbaa !14
  %129 = icmp eq i32 %128, 2
  br i1 %129, label %130, label %141

130:                                              ; preds = %127
  %131 = getelementptr inbounds nuw i8, ptr %119, i32 44
  %132 = load i32, ptr %131, align 4, !tbaa !27
  %133 = inttoptr i32 %132 to ptr
  %134 = getelementptr inbounds nuw i8, ptr %133, i32 16
  store volatile i32 -1, ptr %134, align 4, !tbaa !28
  %135 = getelementptr inbounds nuw i8, ptr %133, i32 20
  store volatile i32 1, ptr %135, align 4, !tbaa !30
  %136 = getelementptr inbounds nuw i8, ptr %119, i32 24
  %137 = load i32, ptr %136, align 4, !tbaa !31
  %138 = add i32 %137, -84
  %139 = inttoptr i32 %138 to ptr
  store volatile i32 -1, ptr %139, align 4, !tbaa !9
  %140 = getelementptr inbounds nuw i8, ptr %119, i32 12
  store i32 0, ptr %140, align 4, !tbaa !18
  store i32 3, ptr %119, align 4, !tbaa !14
  br label %141

141:                                              ; preds = %130, %127
  store i32 1, ptr %124, align 4, !tbaa !26
  br label %148

142:                                              ; preds = %118
  %143 = load i32, ptr %119, align 4, !tbaa !14
  %144 = icmp eq i32 %143, 2
  br i1 %144, label %145, label %146

145:                                              ; preds = %142
  tail call fastcc void @terminate(ptr noundef nonnull %119, i32 noundef -1) #12
  br label %148

146:                                              ; preds = %142
  %147 = getelementptr inbounds nuw i8, ptr %119, i32 48
  store i32 1, ptr %147, align 4, !tbaa !32
  br label %148

148:                                              ; preds = %146, %145, %141, %123, %114
  %149 = add nuw nsw i32 %112, 1
  br label %111, !llvm.loop !33

150:                                              ; preds = %5
  %151 = icmp eq i32 %7, 13
  %152 = select i1 %151, i32 10, i32 %7
  %153 = trunc i32 %6 to i8
  switch i8 %153, label %160 [
    i8 8, label %154
    i8 127, label %154
  ]

154:                                              ; preds = %150, %150
  %155 = load i32, ptr @cons_e, align 4, !tbaa !9
  %156 = load i32, ptr @cons_w, align 4, !tbaa !9
  %157 = icmp eq i32 %155, %156
  br i1 %157, label %67, label %158

158:                                              ; preds = %154
  %159 = add i32 %155, -1
  store i32 %159, ptr @cons_e, align 4, !tbaa !9
  tail call fastcc void @cputc(i32 noundef 8) #12
  tail call fastcc void @cputc(i32 noundef 32) #12
  tail call fastcc void @cputc(i32 noundef 8) #12
  br label %67

160:                                              ; preds = %150
  %161 = load i32, ptr @cons_e, align 4, !tbaa !9
  %162 = load i32, ptr @cons_r, align 4, !tbaa !9
  %163 = sub i32 %161, %162
  %164 = icmp ult i32 %163, 128
  br i1 %164, label %165, label %67

165:                                              ; preds = %160
  %166 = trunc nuw i32 %152 to i8
  %167 = and i32 %161, 127
  %168 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %167
  store i8 %166, ptr %168, align 1, !tbaa !3
  %169 = add i32 %161, 1
  store i32 %169, ptr @cons_e, align 4, !tbaa !9
  tail call fastcc void @cputc(i32 noundef %152) #12
  %170 = icmp eq i32 %152, 10
  br i1 %170, label %174, label %171

171:                                              ; preds = %165
  %172 = sub i32 %169, %162
  %173 = icmp eq i32 %172, 128
  br i1 %173, label %174, label %67

174:                                              ; preds = %171, %165
  store i32 %169, ptr @cons_w, align 4, !tbaa !9
  br label %67

175:                                              ; preds = %1
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 9, 8) i32 @kfind_sleeper(i32 noundef %0) local_unnamed_addr #4 {
  br label %2

2:                                                ; preds = %13, %1
  %3 = phi i32 [ 0, %1 ], [ %14, %13 ]
  %4 = icmp eq i32 %3, 8
  br i1 %4, label %15, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %3
  %7 = load i32, ptr %6, align 4, !tbaa !14
  %8 = icmp eq i32 %7, 2
  br i1 %8, label %9, label %13

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 12
  %11 = load i32, ptr %10, align 4, !tbaa !18
  %12 = icmp eq i32 %11, %0
  br i1 %12, label %15, label %13

13:                                               ; preds = %5, %9
  %14 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !34

15:                                               ; preds = %9, %2
  %16 = phi i32 [ -1, %2 ], [ %3, %9 ]
  ret i32 %16
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #5 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %4 = load i32, ptr %3, align 4, !tbaa !27
  %5 = add i32 %1, -1
  %6 = icmp ult i32 %5, 4
  %7 = shl nsw i32 %5, 2
  %8 = add nsw i32 %7, 4
  %9 = select i1 %6, i32 %8, i32 20
  %10 = inttoptr i32 %4 to ptr
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 %9
  %12 = load volatile i32, ptr %11, align 4, !tbaa !9
  ret i32 %12
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kmail_set(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0, i32 11
  %5 = load i32, ptr %4, align 4, !tbaa !27
  %6 = inttoptr i32 %5 to ptr
  switch i32 %1, label %12 [
    i32 2, label %9
    i32 3, label %7
    i32 5, label %8
  ]

7:                                                ; preds = %3
  br label %9

8:                                                ; preds = %3
  br label %9

9:                                                ; preds = %3, %7, %8
  %10 = phi i32 [ 20, %8 ], [ 12, %7 ], [ 8, %3 ]
  %11 = getelementptr inbounds nuw i8, ptr %6, i32 %10
  store volatile i32 %2, ptr %11, align 4, !tbaa !9
  br label %12

12:                                               ; preds = %9, %3
  ret void
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define dso_local void @kcomplete(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 44
  %5 = load i32, ptr %4, align 4, !tbaa !27
  %6 = inttoptr i32 %5 to ptr
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 16
  store volatile i32 %1, ptr %7, align 4, !tbaa !28
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store volatile i32 1, ptr %8, align 4, !tbaa !30
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 24
  %10 = load i32, ptr %9, align 4, !tbaa !31
  %11 = add i32 %10, -84
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 %1, ptr %12, align 4, !tbaa !9
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 0, ptr %13, align 4, !tbaa !18
  store i32 3, ptr %3, align 4, !tbaa !14
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local i32 @kblock_self_slot() local_unnamed_addr #6 {
  %1 = load i32, ptr @curr, align 4, !tbaa !9
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #5 {
  %2 = load i32, ptr @curr, align 4, !tbaa !9
  %3 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %2
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 32
  %5 = load i32, ptr %4, align 4, !tbaa !35
  %6 = inttoptr i32 %5 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !9
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 40
  store i32 %7, ptr %8, align 4, !tbaa !36
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 %0, ptr %9, align 4, !tbaa !18
  store i32 2, ptr %3, align 4, !tbaa !14
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #3 {
  tail call fastcc void @kenter() #12
  tail call fastcc void @tick_income() #12
  %1 = load i32, ptr @waspark, align 4, !tbaa !9
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %17

3:                                                ; preds = %0
  %4 = load i32, ptr @curr, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !32
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %16

9:                                                ; preds = %3
  %10 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !37
  %11 = load i32, ptr %10, align 4, !tbaa !9
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %11, ptr %12, align 4, !tbaa !36
  %13 = load i32, ptr %5, align 4, !tbaa !14
  %14 = icmp eq i32 %13, 4
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  store i32 3, ptr %5, align 4, !tbaa !14
  br label %17

16:                                               ; preds = %3
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #12
  br label %17

17:                                               ; preds = %0, %9, %15, %16
  tail call fastcc void @swtch() #12
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kenter() unnamed_addr #3 {
  store i1 false, ptr @rearm, align 4
  %1 = load i32, ptr @fsready, align 4, !tbaa !9
  %2 = icmp eq i32 %1, 0
  %3 = load i32, ptr @dma_disk, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %2, i1 %4, i1 false
  br i1 %5, label %6, label %7

6:                                                ; preds = %0
  tail call void @kfs_start() #13
  tail call void @kflash_init() #13
  br label %7

7:                                                ; preds = %6, %0
  %8 = load i1, ptr @parked, align 4
  %9 = zext i1 %8 to i32
  store i32 %9, ptr @waspark, align 4, !tbaa !9
  br i1 %8, label %10, label %11

10:                                               ; preds = %7
  store i1 false, ptr @parked, align 4
  store i32 0, ptr @entry_disp, align 4, !tbaa !9
  br label %22

11:                                               ; preds = %7
  %12 = load i32, ptr @curr, align 4, !tbaa !9
  %13 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %12
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 24
  %15 = load i32, ptr %14, align 4, !tbaa !31
  store i32 %15, ptr @entry_disp, align 4, !tbaa !9
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 36
  %17 = load i32, ptr %16, align 4, !tbaa !40
  store i32 %17, ptr @entry_thunk, align 4, !tbaa !9
  %18 = inttoptr i32 %15 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !9
  %20 = icmp eq i32 %19, %17
  br i1 %20, label %22, label %21

21:                                               ; preds = %11
  store volatile i32 %17, ptr %18, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %22

22:                                               ; preds = %11, %21, %10
  %23 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %24 = inttoptr i32 %23 to ptr
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr %24, align 4, !tbaa !9
  %25 = load i32, ptr @tickpending, align 4, !tbaa !9
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %28, label %27

27:                                               ; preds = %22
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %28

28:                                               ; preds = %27, %22
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tick_income() unnamed_addr #3 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !9
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !9
  store i1 true, ptr @rearm, align 4
  br label %3

3:                                                ; preds = %23, %0
  %4 = phi i32 [ 0, %0 ], [ %24, %23 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  %7 = load i32, ptr @fgpid, align 4, !tbaa !9
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %26, label %25

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %11 = load i32, ptr %10, align 4, !tbaa !14
  %12 = icmp eq i32 %11, 2
  br i1 %12, label %13, label %23

13:                                               ; preds = %9
  %14 = getelementptr inbounds nuw i8, ptr %10, i32 12
  %15 = load i32, ptr %14, align 4, !tbaa !18
  %16 = icmp eq i32 %15, ptrtoint (ptr @ticks to i32)
  br i1 %16, label %17, label %23

17:                                               ; preds = %13
  %18 = getelementptr inbounds nuw i8, ptr %10, i32 16
  %19 = load i32, ptr %18, align 4, !tbaa !41
  %20 = sub i32 %2, %19
  %21 = icmp sgt i32 %20, -1
  br i1 %21, label %22, label %23

22:                                               ; preds = %17
  store i32 0, ptr %14, align 4, !tbaa !18
  store i32 3, ptr %10, align 4, !tbaa !14
  br label %23

23:                                               ; preds = %22, %17, %13, %9
  %24 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !42

25:                                               ; preds = %6
  tail call fastcc void @cons_poll() #12
  br label %26

26:                                               ; preds = %25, %6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @terminate(ptr noundef %0, i32 noundef %1) unnamed_addr #3 {
  %3 = ptrtoint ptr %0 to i32
  %4 = sub i32 %3, ptrtoint (ptr @proc to i32)
  %5 = sdiv exact i32 %4, 72
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %6, align 4, !tbaa !43
  %7 = load i32, ptr @fsready, align 4, !tbaa !9
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %2
  tail call void @kfs_exit(i32 noundef %5) #13
  br label %10

10:                                               ; preds = %9, %2
  tail call fastcc void @kfree_exec(i32 noundef %5) #12
  tail call fastcc void @vfork_release(ptr noundef nonnull %0) #12
  %11 = load i32, ptr @initpid, align 4, !tbaa !9
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %34, label %13

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw i8, ptr %0, i32 4
  br label %15

15:                                               ; preds = %13, %32
  %16 = phi i32 [ %33, %32 ], [ 0, %13 ]
  %17 = icmp eq i32 %16, 8
  br i1 %17, label %34, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %16
  %20 = load i32, ptr %19, align 4, !tbaa !14
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %32, label %22

22:                                               ; preds = %18
  %23 = icmp eq ptr %19, %0
  br i1 %23, label %32, label %24

24:                                               ; preds = %22
  %25 = getelementptr inbounds nuw i8, ptr %19, i32 8
  %26 = load i32, ptr %25, align 4, !tbaa !19
  %27 = load i32, ptr %14, align 4, !tbaa !16
  %28 = icmp eq i32 %26, %27
  br i1 %28, label %29, label %32

29:                                               ; preds = %24
  store i32 %11, ptr %25, align 4, !tbaa !19
  %30 = icmp eq i32 %20, 5
  br i1 %30, label %31, label %32

31:                                               ; preds = %29
  store i32 0, ptr %19, align 4, !tbaa !14
  br label %32

32:                                               ; preds = %29, %31, %24, %22, %18
  %33 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !44

34:                                               ; preds = %15, %10
  %35 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %36 = load i32, ptr %35, align 4, !tbaa !19
  br label %37

37:                                               ; preds = %67, %34
  %38 = phi i32 [ 0, %34 ], [ %68, %67 ]
  %39 = icmp eq i32 %38, 8
  br i1 %39, label %79, label %40

40:                                               ; preds = %37
  %41 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %38
  %42 = getelementptr inbounds nuw i8, ptr %41, i32 4
  %43 = load i32, ptr %42, align 4, !tbaa !16
  %44 = icmp eq i32 %43, %36
  br i1 %44, label %45, label %67

45:                                               ; preds = %40
  %46 = load i32, ptr %41, align 4, !tbaa !14
  %47 = icmp eq i32 %46, 2
  br i1 %47, label %48, label %67

48:                                               ; preds = %45
  %49 = getelementptr inbounds nuw i8, ptr %41, i32 12
  %50 = load i32, ptr %49, align 4, !tbaa !18
  %51 = ptrtoint ptr %41 to i32
  %52 = icmp eq i32 %50, %51
  br i1 %52, label %53, label %67

53:                                               ; preds = %48
  %54 = getelementptr inbounds nuw i8, ptr %41, i32 12
  %55 = getelementptr inbounds nuw i8, ptr %41, i32 44
  %56 = load i32, ptr %55, align 4, !tbaa !27
  %57 = inttoptr i32 %56 to ptr
  %58 = getelementptr inbounds nuw i8, ptr %57, i32 4
  %59 = load volatile i32, ptr %58, align 4, !tbaa !45
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %69, label %61

61:                                               ; preds = %53
  %62 = load i32, ptr %6, align 4, !tbaa !43
  %63 = load volatile i32, ptr %58, align 4, !tbaa !45
  %64 = inttoptr i32 %63 to ptr
  store volatile i32 %62, ptr %64, align 4, !tbaa !9
  %65 = load i32, ptr %55, align 4, !tbaa !27
  %66 = inttoptr i32 %65 to ptr
  br label %69

67:                                               ; preds = %48, %45, %40
  %68 = add nuw nsw i32 %38, 1
  br label %37, !llvm.loop !46

69:                                               ; preds = %61, %53
  %70 = phi ptr [ %66, %61 ], [ %57, %53 ]
  %71 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %72 = load i32, ptr %71, align 4, !tbaa !16
  %73 = getelementptr inbounds nuw i8, ptr %70, i32 16
  store volatile i32 %72, ptr %73, align 4, !tbaa !28
  %74 = getelementptr inbounds nuw i8, ptr %70, i32 20
  store volatile i32 1, ptr %74, align 4, !tbaa !30
  %75 = getelementptr inbounds nuw i8, ptr %41, i32 24
  %76 = load i32, ptr %75, align 4, !tbaa !31
  %77 = add i32 %76, -84
  %78 = inttoptr i32 %77 to ptr
  store volatile i32 %72, ptr %78, align 4, !tbaa !9
  store i32 0, ptr %54, align 4, !tbaa !18
  store i32 3, ptr %41, align 4, !tbaa !14
  br label %83

79:                                               ; preds = %37
  br i1 %12, label %82, label %80

80:                                               ; preds = %79
  %81 = icmp eq i32 %36, %11
  br i1 %81, label %83, label %82

82:                                               ; preds = %80, %79
  br label %83

83:                                               ; preds = %69, %80, %82
  %84 = phi i32 [ 5, %82 ], [ 0, %80 ], [ 0, %69 ]
  store i32 %84, ptr %0, align 4, !tbaa !14
  %85 = getelementptr inbounds nuw i8, ptr %0, i32 48
  store i32 0, ptr %85, align 4, !tbaa !32
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @swtch() unnamed_addr #3 {
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
  %9 = load i32, ptr %8, align 4, !tbaa !14
  %10 = icmp eq i32 %9, 3
  %11 = add nuw nsw i32 %3, 1
  br i1 %10, label %12, label %2, !llvm.loop !47

12:                                               ; preds = %5
  %13 = icmp slt i32 %7, 0
  br i1 %13, label %14, label %51

14:                                               ; preds = %2, %12
  %15 = load i32, ptr @entry_disp, align 4, !tbaa !9
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %23, label %17

17:                                               ; preds = %14
  %18 = inttoptr i32 %15 to ptr
  %19 = load volatile i32, ptr %18, align 4, !tbaa !9
  %20 = load i32, ptr @entry_thunk, align 4, !tbaa !9
  %21 = icmp eq i32 %19, %20
  br i1 %21, label %23, label %22

22:                                               ; preds = %17
  store volatile i32 %20, ptr %18, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %23

23:                                               ; preds = %22, %17, %14
  %24 = load volatile ptr, ptr @kw_park, align 4, !tbaa !37
  %25 = ptrtoint ptr %24 to i32
  %26 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  store i32 %25, ptr %26, align 4, !tbaa !9
  %27 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %28 = ptrtoint ptr %27 to i32
  %29 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !37
  store i32 %28, ptr %29, align 4, !tbaa !9
  %30 = load volatile ptr, ptr @kw_park, align 4, !tbaa !37
  %31 = ptrtoint ptr %30 to i32
  %32 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !37
  store i32 %31, ptr %32, align 4, !tbaa !9
  %33 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %34 = ptrtoint ptr %33 to i32
  %35 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !37
  store i32 %34, ptr %35, align 4, !tbaa !9
  %36 = load volatile ptr, ptr @kw_park, align 4, !tbaa !37
  %37 = ptrtoint ptr %36 to i32
  %38 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !37
  store i32 %37, ptr %38, align 4, !tbaa !9
  %39 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %40 = ptrtoint ptr %39 to i32
  %41 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %42 = inttoptr i32 %41 to ptr
  store volatile i32 %40, ptr %42, align 4, !tbaa !9
  store i1 true, ptr @parked, align 4
  %43 = load i32, ptr @tickpending, align 4, !tbaa !9
  %44 = icmp eq i32 %43, 0
  br i1 %44, label %46, label %45

45:                                               ; preds = %23
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %46

46:                                               ; preds = %45, %23
  %47 = load i1, ptr @rearm, align 4
  br i1 %47, label %48, label %54

48:                                               ; preds = %46
  %49 = load i32, ptr @inj_treg, align 4, !tbaa !9
  %50 = inttoptr i32 %49 to ptr
  store volatile i32 1, ptr %50, align 4, !tbaa !9
  br label %54

51:                                               ; preds = %12
  %52 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %53 = load i32, ptr %52, align 4, !tbaa !36
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %53) #12
  br label %54

54:                                               ; preds = %46, %48, %51
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #3 {
  %1 = alloca %struct.kimg, align 4
  %2 = alloca [13 x i32], align 4
  %3 = alloca [64 x i32], align 4
  tail call fastcc void @kenter() #12
  %4 = load i32, ptr @curr, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !32
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #12
  tail call fastcc void @swtch() #12
  br label %736

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %12 = load i32, ptr %11, align 4, !tbaa !27
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !48
  switch i32 %14, label %704 [
    i32 11, label %19
    i32 14, label %22
    i32 16, label %24
    i32 15, label %49
    i32 21, label %58
    i32 10, label %65
    i32 8, label %72
    i32 4, label %81
    i32 9, label %88
    i32 20, label %95
    i32 19, label %102
    i32 18, label %111
    i32 22, label %118
    i32 5, label %123
    i32 12, label %147
    i32 13, label %243
    i32 3, label %17
    i32 1, label %303
    i32 7, label %333
    i32 2, label %651
    i32 23, label %654
    i32 24, label %659
    i32 6, label %15
  ]

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 4
  br label %681

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %255

19:                                               ; preds = %10
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !16
  br label %704

22:                                               ; preds = %10
  %23 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %704

24:                                               ; preds = %10
  %25 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %26 = load volatile i32, ptr %25, align 4, !tbaa !49
  %27 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %28 = load volatile i32, ptr %27, align 4, !tbaa !50
  %29 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %26, i32 noundef %28) #12
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %704

31:                                               ; preds = %24
  %32 = load i32, ptr @fsready, align 4, !tbaa !9
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %40, label %34

34:                                               ; preds = %31
  %35 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %36 = load volatile i32, ptr %35, align 4, !tbaa !45
  %37 = load volatile i32, ptr %25, align 4, !tbaa !49
  %38 = load volatile i32, ptr %27, align 4, !tbaa !50
  %39 = tail call i32 @kfs_write(i32 noundef %36, i32 noundef %37, i32 noundef %38) #13
  br label %45

40:                                               ; preds = %31
  %41 = load volatile i32, ptr %25, align 4, !tbaa !49
  %42 = inttoptr i32 %41 to ptr
  %43 = load volatile i32, ptr %27, align 4, !tbaa !50
  tail call void @kconswrite(ptr noundef %42, i32 noundef %43) #12
  %44 = load volatile i32, ptr %27, align 4, !tbaa !50
  br label %45

45:                                               ; preds = %34, %40
  %46 = phi i32 [ %39, %34 ], [ %44, %40 ]
  %47 = freeze i32 %46
  %48 = icmp eq i32 %47, -3
  br i1 %48, label %721, label %704

49:                                               ; preds = %10
  %50 = load i32, ptr @fsready, align 4, !tbaa !9
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %704, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %54 = load volatile i32, ptr %53, align 4, !tbaa !45
  %55 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %56 = load volatile i32, ptr %55, align 4, !tbaa !49
  %57 = tail call i32 @kfs_open(i32 noundef %54, i32 noundef %56) #13
  br label %704

58:                                               ; preds = %10
  %59 = load i32, ptr @fsready, align 4, !tbaa !9
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %704, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %63 = load volatile i32, ptr %62, align 4, !tbaa !45
  %64 = tail call i32 @kfs_close(i32 noundef %63) #13
  br label %704

65:                                               ; preds = %10
  %66 = load i32, ptr @fsready, align 4, !tbaa !9
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %704, label %68

68:                                               ; preds = %65
  %69 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %70 = load volatile i32, ptr %69, align 4, !tbaa !45
  %71 = tail call i32 @kfs_dup(i32 noundef %70) #13
  br label %704

72:                                               ; preds = %10
  %73 = load i32, ptr @fsready, align 4, !tbaa !9
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %704, label %75

75:                                               ; preds = %72
  %76 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %77 = load volatile i32, ptr %76, align 4, !tbaa !45
  %78 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %79 = load volatile i32, ptr %78, align 4, !tbaa !49
  %80 = tail call i32 @kfs_fstat(i32 noundef %77, i32 noundef %79) #13
  br label %704

81:                                               ; preds = %10
  %82 = load i32, ptr @fsready, align 4, !tbaa !9
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %704, label %84

84:                                               ; preds = %81
  %85 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %86 = load volatile i32, ptr %85, align 4, !tbaa !45
  %87 = tail call i32 @kfs_pipe(i32 noundef %86) #13
  br label %704

88:                                               ; preds = %10
  %89 = load i32, ptr @fsready, align 4, !tbaa !9
  %90 = icmp eq i32 %89, 0
  br i1 %90, label %704, label %91

91:                                               ; preds = %88
  %92 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %93 = load volatile i32, ptr %92, align 4, !tbaa !45
  %94 = tail call i32 @kfs_chdir(i32 noundef %93) #13
  br label %704

95:                                               ; preds = %10
  %96 = load i32, ptr @fsready, align 4, !tbaa !9
  %97 = icmp eq i32 %96, 0
  br i1 %97, label %704, label %98

98:                                               ; preds = %95
  %99 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %100 = load volatile i32, ptr %99, align 4, !tbaa !45
  %101 = tail call i32 @kfs_mkdir(i32 noundef %100) #13
  br label %704

102:                                              ; preds = %10
  %103 = load i32, ptr @fsready, align 4, !tbaa !9
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %704, label %105

105:                                              ; preds = %102
  %106 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %107 = load volatile i32, ptr %106, align 4, !tbaa !45
  %108 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %109 = load volatile i32, ptr %108, align 4, !tbaa !49
  %110 = tail call i32 @kfs_link(i32 noundef %107, i32 noundef %109) #13
  br label %704

111:                                              ; preds = %10
  %112 = load i32, ptr @fsready, align 4, !tbaa !9
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %704, label %114

114:                                              ; preds = %111
  %115 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %116 = load volatile i32, ptr %115, align 4, !tbaa !45
  %117 = tail call i32 @kfs_unlink(i32 noundef %116) #13
  br label %704

118:                                              ; preds = %10
  %119 = load i32, ptr @fsready, align 4, !tbaa !9
  %120 = icmp eq i32 %119, 0
  br i1 %120, label %704, label %121

121:                                              ; preds = %118
  %122 = tail call i32 @kflash_sync() #13
  br label %704

123:                                              ; preds = %10
  %124 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %125 = load volatile i32, ptr %124, align 4, !tbaa !49
  %126 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %127 = load volatile i32, ptr %126, align 4, !tbaa !50
  %128 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %125, i32 noundef %127) #12
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %130, label %704

130:                                              ; preds = %123
  %131 = load i32, ptr @fsready, align 4, !tbaa !9
  %132 = icmp eq i32 %131, 0
  br i1 %132, label %139, label %133

133:                                              ; preds = %130
  %134 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %135 = load volatile i32, ptr %134, align 4, !tbaa !45
  %136 = load volatile i32, ptr %124, align 4, !tbaa !49
  %137 = load volatile i32, ptr %126, align 4, !tbaa !50
  %138 = tail call i32 @kfs_read(i32 noundef %135, i32 noundef %136, i32 noundef %137) #13
  br label %143

139:                                              ; preds = %130
  %140 = load volatile i32, ptr %124, align 4, !tbaa !49
  %141 = load volatile i32, ptr %126, align 4, !tbaa !50
  %142 = tail call i32 @kconsread(i32 noundef %140, i32 noundef %141) #12
  br label %143

143:                                              ; preds = %133, %139
  %144 = phi i32 [ %138, %133 ], [ %142, %139 ]
  %145 = freeze i32 %144
  %146 = icmp eq i32 %145, -3
  br i1 %146, label %721, label %704

147:                                              ; preds = %10
  %148 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %149 = load volatile i32, ptr %148, align 4, !tbaa !45
  %150 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %151 = load i32, ptr %150, align 4, !tbaa !51
  %152 = icmp eq i32 %151, 0
  br i1 %152, label %153, label %175

153:                                              ; preds = %147
  %154 = icmp slt i32 %149, 0
  br i1 %154, label %704, label %155

155:                                              ; preds = %153
  %156 = add nuw i32 %149, 255
  %157 = and i32 %156, -256
  %158 = icmp samesign ugt i32 %149, 16128
  %159 = select i1 %158, i32 %157, i32 16384
  %160 = tail call fastcc i32 @kalloc(i32 noundef %159) #12
  %161 = icmp ne i32 %160, 0
  %162 = or i1 %158, %161
  br i1 %162, label %165, label %163

163:                                              ; preds = %155
  %164 = tail call fastcc i32 @kalloc(i32 noundef %157) #12
  br label %165

165:                                              ; preds = %163, %155
  %166 = phi i32 [ %157, %163 ], [ %159, %155 ]
  %167 = phi i32 [ %164, %163 ], [ %160, %155 ]
  %168 = icmp eq i32 %167, 0
  br i1 %168, label %704, label %169

169:                                              ; preds = %165
  %170 = load i32, ptr @curr, align 4, !tbaa !9
  %171 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %170
  store i32 %167, ptr %171, align 4, !tbaa !9
  %172 = getelementptr inbounds nuw i8, ptr %5, i32 60
  store i32 %167, ptr %172, align 4, !tbaa !52
  store i32 %167, ptr %150, align 4, !tbaa !51
  %173 = add i32 %167, %166
  %174 = getelementptr inbounds nuw i8, ptr %5, i32 56
  store i32 %173, ptr %174, align 4, !tbaa !53
  br label %182

175:                                              ; preds = %147
  %176 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %177 = load i32, ptr %176, align 4, !tbaa !52
  %178 = icmp sgt i32 %149, -1
  br i1 %178, label %179, label %198

179:                                              ; preds = %175
  %180 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %181 = load i32, ptr %180, align 4, !tbaa !53
  br label %182

182:                                              ; preds = %179, %169
  %183 = phi i32 [ %173, %169 ], [ %181, %179 ]
  %184 = phi i32 [ %167, %169 ], [ %177, %179 ]
  %185 = phi ptr [ %172, %169 ], [ %176, %179 ]
  %186 = sub i32 %183, %184
  %187 = icmp ugt i32 %149, %186
  br i1 %187, label %704, label %188

188:                                              ; preds = %182
  %189 = add i32 %184, %149
  br label %190

190:                                              ; preds = %195, %188
  %191 = phi i32 [ %197, %195 ], [ %184, %188 ]
  %192 = icmp ult i32 %191, %189
  br i1 %192, label %195, label %193

193:                                              ; preds = %190
  %194 = load i32, ptr %185, align 4, !tbaa !52
  br label %202

195:                                              ; preds = %190
  %196 = inttoptr i32 %191 to ptr
  store volatile i8 0, ptr %196, align 1, !tbaa !3
  %197 = add nuw i32 %191, 1
  br label %190, !llvm.loop !54

198:                                              ; preds = %175
  %199 = sub nsw i32 0, %149
  %200 = sub i32 %177, %151
  %201 = icmp ult i32 %200, %199
  br i1 %201, label %704, label %202

202:                                              ; preds = %198, %193
  %203 = phi i32 [ %184, %193 ], [ %177, %198 ]
  %204 = phi ptr [ %185, %193 ], [ %176, %198 ]
  %205 = phi i32 [ %194, %193 ], [ %177, %198 ]
  %206 = add i32 %205, %149
  store i32 %206, ptr %204, align 4, !tbaa !52
  %207 = getelementptr inbounds nuw i8, ptr %5, i32 56
  br label %208

208:                                              ; preds = %242, %202
  %209 = phi ptr [ %5, %202 ], [ %217, %242 ]
  %210 = ptrtoint ptr %209 to i32
  %211 = sub i32 %210, ptrtoint (ptr @proc to i32)
  %212 = sdiv exact i32 %211, 72
  br label %213

213:                                              ; preds = %224, %208
  %214 = phi i32 [ 0, %208 ], [ %225, %224 ]
  %215 = icmp eq i32 %214, 8
  br i1 %215, label %704, label %216

216:                                              ; preds = %213
  %217 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %214
  %218 = load i32, ptr %217, align 4, !tbaa !14
  %219 = icmp eq i32 %218, 2
  br i1 %219, label %220, label %224

220:                                              ; preds = %216
  %221 = getelementptr inbounds nuw i8, ptr %217, i32 12
  %222 = load i32, ptr %221, align 4, !tbaa !18
  %223 = icmp eq i32 %222, %210
  br i1 %223, label %226, label %224

224:                                              ; preds = %220, %216
  %225 = add nuw nsw i32 %214, 1
  br label %213, !llvm.loop !55

226:                                              ; preds = %220
  %227 = getelementptr inbounds nuw i8, ptr %217, i32 52
  %228 = load i32, ptr %227, align 4, !tbaa !51
  %229 = load i32, ptr %150, align 4, !tbaa !51
  %230 = icmp eq i32 %228, %229
  br i1 %230, label %236, label %231

231:                                              ; preds = %226
  store i32 %229, ptr %227, align 4, !tbaa !51
  %232 = load i32, ptr %207, align 4, !tbaa !53
  %233 = getelementptr inbounds nuw i8, ptr %217, i32 56
  store i32 %232, ptr %233, align 4, !tbaa !53
  %234 = load i32, ptr %150, align 4, !tbaa !51
  %235 = getelementptr inbounds nuw i8, ptr %217, i32 60
  store i32 %234, ptr %235, align 4, !tbaa !52
  br label %236

236:                                              ; preds = %231, %226
  %237 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %212
  %238 = load i32, ptr %237, align 4, !tbaa !9
  %239 = icmp eq i32 %238, 0
  br i1 %239, label %242, label %240

240:                                              ; preds = %236
  %241 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %214
  store i32 %238, ptr %241, align 4, !tbaa !9
  store i32 0, ptr %237, align 4, !tbaa !9
  br label %242

242:                                              ; preds = %240, %236
  br label %208, !llvm.loop !56

243:                                              ; preds = %10
  %244 = load i32, ptr @ticks, align 4, !tbaa !9
  %245 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %246 = load volatile i32, ptr %245, align 4, !tbaa !45
  %247 = add i32 %246, %244
  %248 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %247, ptr %248, align 4, !tbaa !41
  %249 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %250 = load i32, ptr %249, align 4, !tbaa !35
  %251 = inttoptr i32 %250 to ptr
  %252 = load volatile i32, ptr %251, align 4, !tbaa !9
  %253 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %252, ptr %253, align 4, !tbaa !36
  %254 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %254, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %725

255:                                              ; preds = %17, %274
  %256 = phi i32 [ %277, %274 ], [ 0, %17 ]
  %257 = phi i32 [ %275, %274 ], [ -1, %17 ]
  %258 = phi i32 [ %276, %274 ], [ 0, %17 ]
  %259 = icmp eq i32 %256, 8
  br i1 %259, label %260, label %262

260:                                              ; preds = %255
  %261 = icmp sgt i32 %257, -1
  br i1 %261, label %278, label %291

262:                                              ; preds = %255
  %263 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %256
  %264 = load i32, ptr %263, align 4, !tbaa !14
  %265 = icmp eq i32 %264, 0
  br i1 %265, label %274, label %266

266:                                              ; preds = %262
  %267 = getelementptr inbounds nuw i8, ptr %263, i32 8
  %268 = load i32, ptr %267, align 4, !tbaa !19
  %269 = load i32, ptr %18, align 4, !tbaa !16
  %270 = icmp eq i32 %268, %269
  br i1 %270, label %271, label %274

271:                                              ; preds = %266
  %272 = icmp eq i32 %264, 5
  %273 = select i1 %272, i32 %256, i32 %257
  br label %274

274:                                              ; preds = %271, %262, %266
  %275 = phi i32 [ %257, %266 ], [ %257, %262 ], [ %273, %271 ]
  %276 = phi i32 [ %258, %266 ], [ %258, %262 ], [ 1, %271 ]
  %277 = add nuw nsw i32 %256, 1
  br label %255, !llvm.loop !57

278:                                              ; preds = %260
  %279 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %280 = load volatile i32, ptr %279, align 4, !tbaa !45
  %281 = icmp eq i32 %280, 0
  br i1 %281, label %287, label %282

282:                                              ; preds = %278
  %283 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %257, i32 5
  %284 = load i32, ptr %283, align 4, !tbaa !43
  %285 = load volatile i32, ptr %279, align 4, !tbaa !45
  %286 = inttoptr i32 %285 to ptr
  store volatile i32 %284, ptr %286, align 4, !tbaa !9
  br label %287

287:                                              ; preds = %282, %278
  %288 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %257
  %289 = getelementptr inbounds nuw i8, ptr %288, i32 4
  %290 = load i32, ptr %289, align 4, !tbaa !16
  store i32 0, ptr %288, align 4, !tbaa !14
  br label %704

291:                                              ; preds = %260
  %292 = icmp eq i32 %258, 0
  br i1 %292, label %704, label %293

293:                                              ; preds = %291
  %294 = ptrtoint ptr %5 to i32
  %295 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %296 = load i32, ptr %295, align 4, !tbaa !35
  %297 = inttoptr i32 %296 to ptr
  %298 = load volatile i32, ptr %297, align 4, !tbaa !9
  %299 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %298, ptr %299, align 4, !tbaa !36
  %300 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %294, ptr %300, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  %301 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %302 = load volatile i32, ptr %301, align 4, !tbaa !28
  br label %725

303:                                              ; preds = %10, %310
  %304 = phi i32 [ %311, %310 ], [ 0, %10 ]
  %305 = icmp eq i32 %304, 8
  br i1 %305, label %704, label %306

306:                                              ; preds = %303
  %307 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %304
  %308 = load i32, ptr %307, align 4, !tbaa !14
  %309 = icmp eq i32 %308, 0
  br i1 %309, label %312, label %310

310:                                              ; preds = %306
  %311 = add nuw nsw i32 %304, 1
  br label %303, !llvm.loop !58

312:                                              ; preds = %306
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %307, ptr noundef nonnull align 4 dereferenceable(72) %5, i32 72, i1 false), !tbaa.struct !59
  %313 = load i32, ptr @fsready, align 4, !tbaa !9
  %314 = icmp eq i32 %313, 0
  br i1 %314, label %316, label %315

315:                                              ; preds = %312
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %304) #13
  br label %316

316:                                              ; preds = %315, %312
  %317 = load i32, ptr @nextpid, align 4, !tbaa !9
  %318 = add i32 %317, 1
  store i32 %318, ptr @nextpid, align 4, !tbaa !9
  %319 = getelementptr inbounds nuw i8, ptr %307, i32 4
  store i32 %317, ptr %319, align 4, !tbaa !16
  %320 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %321 = load i32, ptr %320, align 4, !tbaa !16
  %322 = getelementptr inbounds nuw i8, ptr %307, i32 8
  store i32 %321, ptr %322, align 4, !tbaa !19
  %323 = getelementptr inbounds nuw i8, ptr %307, i32 12
  store i32 0, ptr %323, align 4, !tbaa !18
  store i32 3, ptr %307, align 4, !tbaa !14
  %324 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %325 = load i32, ptr %324, align 4, !tbaa !35
  %326 = inttoptr i32 %325 to ptr
  %327 = load volatile i32, ptr %326, align 4, !tbaa !9
  %328 = getelementptr inbounds nuw i8, ptr %307, i32 40
  store i32 %327, ptr %328, align 4, !tbaa !36
  %329 = load volatile i32, ptr %326, align 4, !tbaa !9
  %330 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %329, ptr %330, align 4, !tbaa !36
  %331 = ptrtoint ptr %307 to i32
  %332 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %331, ptr %332, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %725

333:                                              ; preds = %10
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #14
  %334 = load i32, ptr @fsready, align 4, !tbaa !9
  %335 = icmp eq i32 %334, 0
  br i1 %335, label %431, label %336

336:                                              ; preds = %333
  %337 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %338 = load volatile i32, ptr %337, align 4, !tbaa !45
  %339 = inttoptr i32 %338 to ptr
  %340 = tail call i32 @kfs_iopen(ptr noundef %339) #13
  %341 = icmp eq i32 %340, 0
  br i1 %341, label %431, label %342

342:                                              ; preds = %336
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #14
  %343 = ptrtoint ptr %2 to i32
  %344 = call i32 @kfs_iread(i32 noundef %340, i32 noundef 0, i32 noundef %343, i32 noundef 52) #13
  %345 = icmp eq i32 %344, 52
  %346 = load i32, ptr %2, align 4
  %347 = icmp eq i32 %346, 1480674628
  %348 = select i1 %345, i1 %347, i1 false
  br i1 %348, label %349, label %429

349:                                              ; preds = %342
  %350 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %351 = load i32, ptr %350, align 4, !tbaa !9
  %352 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %353 = load i32, ptr %352, align 4, !tbaa !9
  %354 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %355 = load i32, ptr %354, align 4, !tbaa !9
  %356 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %357 = load i32, ptr %356, align 4, !tbaa !9
  %358 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %359 = load i32, ptr %358, align 4, !tbaa !9
  %360 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %361 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %362 = load i32, ptr %361, align 4, !tbaa !9
  %363 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %362, ptr %363, align 4, !tbaa !60
  %364 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %365 = load i32, ptr %364, align 4, !tbaa !9
  %366 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %365, ptr %366, align 4, !tbaa !62
  %367 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %368 = load i32, ptr %367, align 4, !tbaa !9
  %369 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %368, ptr %369, align 4, !tbaa !63
  %370 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %371 = load i32, ptr %370, align 4, !tbaa !9
  %372 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %371, ptr %372, align 4, !tbaa !64
  %373 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %374 = load i32, ptr %373, align 4, !tbaa !9
  %375 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %374, ptr %375, align 4, !tbaa !65
  %376 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %377 = load i32, ptr %376, align 4, !tbaa !9
  %378 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %377, ptr %378, align 4, !tbaa !66
  %379 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %380 = load i32, ptr %379, align 4, !tbaa !9
  %381 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %380, ptr %381, align 4, !tbaa !67
  %382 = call fastcc i32 @kalloc(i32 noundef %351) #12
  %383 = call fastcc i32 @kalloc(i32 noundef %353) #12
  %384 = add i32 %351, 52
  %385 = add i32 %353, %384
  %386 = icmp ne i32 %382, 0
  %387 = icmp ne i32 %383, 0
  %388 = select i1 %386, i1 %387, i1 false
  br i1 %388, label %389, label %395

389:                                              ; preds = %349
  %390 = call i32 @kfs_iread(i32 noundef %340, i32 noundef 52, i32 noundef %382, i32 noundef %351) #13
  %391 = icmp eq i32 %390, %351
  br i1 %391, label %392, label %395

392:                                              ; preds = %389
  %393 = call i32 @kfs_iread(i32 noundef %340, i32 noundef %384, i32 noundef %383, i32 noundef %353) #13
  %394 = icmp eq i32 %393, %353
  br i1 %394, label %396, label %395

395:                                              ; preds = %392, %389, %349
  call fastcc void @kfree(i32 noundef %382) #12
  call fastcc void @kfree(i32 noundef %383) #12
  br label %429

396:                                              ; preds = %392
  %397 = sub i32 %382, %355
  %398 = sub i32 %383, %357
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #14
  %399 = ptrtoint ptr %3 to i32
  br label %400

400:                                              ; preds = %426, %396
  %401 = phi i32 [ %385, %396 ], [ %428, %426 ]
  %402 = phi i32 [ %359, %396 ], [ %427, %426 ]
  %403 = icmp eq i32 %402, 0
  br i1 %403, label %430, label %404

404:                                              ; preds = %400
  %405 = call i32 @llvm.umin.i32(i32 %402, i32 64)
  %406 = shl nuw nsw i32 %405, 2
  %407 = call i32 @kfs_iread(i32 noundef %340, i32 noundef %401, i32 noundef %399, i32 noundef %406) #13
  %408 = icmp eq i32 %407, %406
  br i1 %408, label %409, label %430

409:                                              ; preds = %404, %412
  %410 = phi i32 [ %425, %412 ], [ 0, %404 ]
  %411 = icmp eq i32 %410, %405
  br i1 %411, label %426, label %412

412:                                              ; preds = %409
  %413 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %410
  %414 = load i32, ptr %413, align 4, !tbaa !9
  %415 = icmp slt i32 %414, 0
  %416 = select i1 %415, i32 %383, i32 %382
  %417 = and i32 %414, 1073741823
  %418 = add i32 %416, %417
  %419 = and i32 %414, 1073741824
  %420 = icmp eq i32 %419, 0
  %421 = select i1 %420, i32 %397, i32 %398
  %422 = inttoptr i32 %418 to ptr
  %423 = load volatile i32, ptr %422, align 4, !tbaa !9
  %424 = add i32 %421, %423
  store volatile i32 %424, ptr %422, align 4, !tbaa !9
  %425 = add nuw nsw i32 %410, 1
  br label %409, !llvm.loop !68

426:                                              ; preds = %409
  %427 = sub i32 %402, %405
  %428 = add i32 %406, %401
  br label %400

429:                                              ; preds = %342, %395
  call void @kfs_iclose(i32 noundef %340) #13
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %610

430:                                              ; preds = %404, %400
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #14
  call void @kfs_iclose(i32 noundef %340) #13
  store i32 0, ptr %360, align 4, !tbaa !69
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #14
  br label %508

431:                                              ; preds = %333, %336
  %432 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %433 = load volatile i32, ptr %432, align 4, !tbaa !45
  %434 = inttoptr i32 %433 to ptr
  br label %435

435:                                              ; preds = %454, %431
  %436 = phi i32 [ 0, %431 ], [ %455, %454 ]
  %437 = icmp eq i32 %436, 4
  br i1 %437, label %610, label %438

438:                                              ; preds = %435
  %439 = getelementptr inbounds nuw [4 x %struct.kimg], ptr @kimages, i32 0, i32 %436
  %440 = load i8, ptr %439, align 4, !tbaa !3
  %441 = icmp eq i8 %440, 0
  br i1 %441, label %610, label %442

442:                                              ; preds = %438, %451
  %443 = phi i32 [ %453, %451 ], [ 0, %438 ]
  %444 = icmp eq i32 %443, 12
  br i1 %444, label %456, label %445

445:                                              ; preds = %442
  %446 = getelementptr inbounds nuw [12 x i8], ptr %439, i32 0, i32 %443
  %447 = load i8, ptr %446, align 1, !tbaa !3
  %448 = getelementptr inbounds nuw i8, ptr %434, i32 %443
  %449 = load i8, ptr %448, align 1, !tbaa !3
  %450 = icmp eq i8 %447, %449
  br i1 %450, label %451, label %454

451:                                              ; preds = %445
  %452 = icmp eq i8 %447, 0
  %453 = add nuw nsw i32 %443, 1
  br i1 %452, label %456, label %442, !llvm.loop !70

454:                                              ; preds = %445
  %455 = add nuw nsw i32 %436, 1
  br label %435, !llvm.loop !71

456:                                              ; preds = %451, %442
  %457 = getelementptr inbounds nuw i8, ptr %439, i32 16
  %458 = load i32, ptr %457, align 4, !tbaa !72
  %459 = tail call fastcc i32 @kalloc(i32 noundef %458) #12
  %460 = getelementptr inbounds nuw i8, ptr %439, i32 24
  %461 = load i32, ptr %460, align 4, !tbaa !73
  %462 = tail call fastcc i32 @kalloc(i32 noundef %461) #12
  %463 = icmp ne i32 %459, 0
  %464 = icmp ne i32 %462, 0
  %465 = select i1 %463, i1 %464, i1 false
  br i1 %465, label %466, label %610

466:                                              ; preds = %456
  %467 = getelementptr inbounds nuw i8, ptr %439, i32 12
  %468 = load i32, ptr %467, align 4, !tbaa !74
  %469 = inttoptr i32 %468 to ptr
  %470 = inttoptr i32 %459 to ptr
  br label %471

471:                                              ; preds = %482, %466
  %472 = phi ptr [ %469, %466 ], [ %483, %482 ]
  %473 = phi ptr [ %470, %466 ], [ %485, %482 ]
  %474 = phi i32 [ 0, %466 ], [ %486, %482 ]
  %475 = load i32, ptr %457, align 4, !tbaa !72
  %476 = icmp ult i32 %474, %475
  br i1 %476, label %482, label %477

477:                                              ; preds = %471
  %478 = getelementptr inbounds nuw i8, ptr %439, i32 20
  %479 = load i32, ptr %478, align 4, !tbaa !75
  %480 = inttoptr i32 %479 to ptr
  %481 = inttoptr i32 %462 to ptr
  br label %487

482:                                              ; preds = %471
  %483 = getelementptr inbounds nuw i8, ptr %472, i32 4
  %484 = load i32, ptr %472, align 4, !tbaa !9
  %485 = getelementptr inbounds nuw i8, ptr %473, i32 4
  store i32 %484, ptr %473, align 4, !tbaa !9
  %486 = add i32 %474, 4
  br label %471, !llvm.loop !76

487:                                              ; preds = %493, %477
  %488 = phi ptr [ %480, %477 ], [ %494, %493 ]
  %489 = phi ptr [ %481, %477 ], [ %496, %493 ]
  %490 = phi i32 [ 0, %477 ], [ %497, %493 ]
  %491 = load i32, ptr %460, align 4, !tbaa !73
  %492 = icmp ult i32 %490, %491
  br i1 %492, label %493, label %498

493:                                              ; preds = %487
  %494 = getelementptr inbounds nuw i8, ptr %488, i32 4
  %495 = load i32, ptr %488, align 4, !tbaa !9
  %496 = getelementptr inbounds nuw i8, ptr %489, i32 4
  store i32 %495, ptr %489, align 4, !tbaa !9
  %497 = add i32 %490, 4
  br label %487, !llvm.loop !77

498:                                              ; preds = %487
  %499 = getelementptr inbounds nuw i8, ptr %439, i32 28
  %500 = load i32, ptr %499, align 4, !tbaa !78
  %501 = getelementptr inbounds nuw i8, ptr %439, i32 32
  %502 = load i32, ptr %501, align 4, !tbaa !79
  %503 = getelementptr inbounds nuw i8, ptr %439, i32 36
  %504 = load i32, ptr %503, align 4, !tbaa !80
  %505 = sub i32 %459, %500
  %506 = sub i32 %462, %502
  %507 = inttoptr i32 %504 to ptr
  br label %508

508:                                              ; preds = %498, %430
  %509 = phi i32 [ %506, %498 ], [ %398, %430 ]
  %510 = phi i32 [ %505, %498 ], [ %397, %430 ]
  %511 = phi ptr [ %507, %498 ], [ null, %430 ]
  %512 = phi i32 [ %462, %498 ], [ %383, %430 ]
  %513 = phi i32 [ %459, %498 ], [ %382, %430 ]
  %514 = phi ptr [ %439, %498 ], [ %1, %430 ]
  %515 = getelementptr inbounds nuw i8, ptr %514, i32 40
  br label %516

516:                                              ; preds = %555, %508
  %517 = phi i32 [ 0, %508 ], [ %568, %555 ]
  %518 = load i32, ptr %515, align 4, !tbaa !69
  %519 = icmp ult i32 %517, %518
  br i1 %519, label %555, label %520

520:                                              ; preds = %516
  %521 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %522 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %523 = getelementptr inbounds nuw i8, ptr %5, i32 60
  br label %524

524:                                              ; preds = %540, %520
  %525 = phi ptr [ %5, %520 ], [ %531, %540 ]
  %526 = ptrtoint ptr %525 to i32
  br label %527

527:                                              ; preds = %538, %524
  %528 = phi i32 [ 0, %524 ], [ %539, %538 ]
  %529 = icmp eq i32 %528, 8
  br i1 %529, label %547, label %530

530:                                              ; preds = %527
  %531 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %528
  %532 = load i32, ptr %531, align 4, !tbaa !14
  %533 = icmp eq i32 %532, 2
  br i1 %533, label %534, label %538

534:                                              ; preds = %530
  %535 = getelementptr inbounds nuw i8, ptr %531, i32 12
  %536 = load i32, ptr %535, align 4, !tbaa !18
  %537 = icmp eq i32 %536, %526
  br i1 %537, label %540, label %538

538:                                              ; preds = %534, %530
  %539 = add nuw nsw i32 %528, 1
  br label %527, !llvm.loop !81

540:                                              ; preds = %534
  %541 = load i32, ptr %521, align 4, !tbaa !51
  %542 = getelementptr inbounds nuw i8, ptr %531, i32 52
  store i32 %541, ptr %542, align 4, !tbaa !51
  %543 = load i32, ptr %522, align 4, !tbaa !53
  %544 = getelementptr inbounds nuw i8, ptr %531, i32 56
  store i32 %543, ptr %544, align 4, !tbaa !53
  %545 = load i32, ptr %523, align 4, !tbaa !52
  %546 = getelementptr inbounds nuw i8, ptr %531, i32 60
  store i32 %545, ptr %546, align 4, !tbaa !52
  br label %524, !llvm.loop !82

547:                                              ; preds = %527
  %548 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %548) #12
  %549 = load i32, ptr @curr, align 4, !tbaa !9
  %550 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %549
  store i32 %513, ptr %550, align 4, !tbaa !9
  %551 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %549, i32 1
  store i32 %512, ptr %551, align 4, !tbaa !9
  %552 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %553 = load volatile i32, ptr %552, align 4, !tbaa !49
  %554 = icmp eq i32 %553, 0
  br i1 %554, label %611, label %569

555:                                              ; preds = %516
  %556 = getelementptr inbounds nuw i32, ptr %511, i32 %517
  %557 = load i32, ptr %556, align 4, !tbaa !9
  %558 = icmp slt i32 %557, 0
  %559 = select i1 %558, i32 %512, i32 %513
  %560 = and i32 %557, 1073741823
  %561 = add i32 %559, %560
  %562 = and i32 %557, 1073741824
  %563 = icmp eq i32 %562, 0
  %564 = select i1 %563, i32 %510, i32 %509
  %565 = inttoptr i32 %561 to ptr
  %566 = load volatile i32, ptr %565, align 4, !tbaa !9
  %567 = add i32 %564, %566
  store volatile i32 %567, ptr %565, align 4, !tbaa !9
  %568 = add nuw i32 %517, 1
  br label %516, !llvm.loop !83

569:                                              ; preds = %547
  %570 = call fastcc i32 @kalloc(i32 noundef 256) #12
  %571 = icmp eq i32 %570, 0
  br i1 %571, label %611, label %572

572:                                              ; preds = %569
  %573 = load volatile i32, ptr %552, align 4, !tbaa !49
  %574 = inttoptr i32 %573 to ptr
  %575 = inttoptr i32 %570 to ptr
  %576 = add i32 %570, 64
  %577 = inttoptr i32 %576 to ptr
  %578 = add i32 %570, 256
  %579 = inttoptr i32 %578 to ptr
  %580 = getelementptr inbounds i8, ptr %579, i32 -1
  br label %581

581:                                              ; preds = %603, %572
  %582 = phi i32 [ 0, %572 ], [ %605, %603 ]
  %583 = phi ptr [ %577, %572 ], [ %604, %603 ]
  %584 = icmp eq i32 %582, 15
  br i1 %584, label %606, label %585

585:                                              ; preds = %581
  %586 = getelementptr inbounds nuw i32, ptr %574, i32 %582
  %587 = load i32, ptr %586, align 4, !tbaa !9
  %588 = icmp eq i32 %587, 0
  br i1 %588, label %606, label %589

589:                                              ; preds = %585
  %590 = inttoptr i32 %587 to ptr
  %591 = ptrtoint ptr %583 to i32
  %592 = getelementptr inbounds nuw i32, ptr %575, i32 %582
  store i32 %591, ptr %592, align 4, !tbaa !9
  br label %593

593:                                              ; preds = %600, %589
  %594 = phi ptr [ %583, %589 ], [ %602, %600 ]
  %595 = phi ptr [ %590, %589 ], [ %601, %600 ]
  %596 = load i8, ptr %595, align 1, !tbaa !3
  %597 = icmp ne i8 %596, 0
  %598 = icmp ult ptr %594, %580
  %599 = select i1 %597, i1 %598, i1 false
  br i1 %599, label %600, label %603

600:                                              ; preds = %593
  %601 = getelementptr inbounds nuw i8, ptr %595, i32 1
  %602 = getelementptr inbounds nuw i8, ptr %594, i32 1
  store i8 %596, ptr %594, align 1, !tbaa !3
  br label %593, !llvm.loop !84

603:                                              ; preds = %593
  %604 = getelementptr inbounds nuw i8, ptr %594, i32 1
  store i8 0, ptr %594, align 1, !tbaa !3
  %605 = add nuw nsw i32 %582, 1
  br label %581, !llvm.loop !85

606:                                              ; preds = %581, %585
  %607 = getelementptr inbounds nuw i32, ptr %575, i32 %582
  store i32 0, ptr %607, align 4, !tbaa !9
  %608 = load i32, ptr @curr, align 4, !tbaa !9
  %609 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %608, i32 2
  store i32 %570, ptr %609, align 4, !tbaa !9
  br label %611

610:                                              ; preds = %435, %438, %456, %429
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %704

611:                                              ; preds = %547, %606, %569
  %612 = phi i32 [ 0, %547 ], [ %582, %606 ], [ 0, %569 ]
  %613 = phi i32 [ 0, %547 ], [ %570, %606 ], [ 0, %569 ]
  %614 = getelementptr inbounds nuw i8, ptr %514, i32 52
  %615 = load i32, ptr %614, align 4, !tbaa !63
  %616 = add i32 %615, %512
  %617 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %616, ptr %617, align 4, !tbaa !31
  %618 = getelementptr inbounds nuw i8, ptr %514, i32 56
  %619 = load i32, ptr %618, align 4, !tbaa !64
  %620 = add i32 %619, %512
  %621 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %620, ptr %621, align 4, !tbaa !86
  %622 = getelementptr inbounds nuw i8, ptr %514, i32 60
  %623 = load i32, ptr %622, align 4, !tbaa !65
  %624 = add i32 %623, %512
  %625 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %624, ptr %625, align 4, !tbaa !35
  %626 = getelementptr inbounds nuw i8, ptr %514, i32 48
  %627 = load i32, ptr %626, align 4, !tbaa !62
  %628 = add i32 %627, %513
  %629 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %628, ptr %629, align 4, !tbaa !40
  %630 = getelementptr inbounds nuw i8, ptr %514, i32 64
  %631 = load i32, ptr %630, align 4, !tbaa !66
  %632 = add i32 %631, %512
  store i32 %632, ptr %11, align 4, !tbaa !27
  %633 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %634 = getelementptr inbounds nuw i8, ptr %514, i32 68
  %635 = load i32, ptr %634, align 4, !tbaa !67
  %636 = add i32 %635, %512
  %637 = inttoptr i32 %636 to ptr
  store volatile i32 %633, ptr %637, align 4, !tbaa !9
  %638 = load i32, ptr %629, align 4, !tbaa !40
  %639 = load i32, ptr %617, align 4, !tbaa !31
  %640 = inttoptr i32 %639 to ptr
  store volatile i32 %638, ptr %640, align 4, !tbaa !9
  %641 = load i32, ptr %614, align 4, !tbaa !63
  %642 = add i32 %641, %512
  %643 = add i32 %642, -84
  %644 = inttoptr i32 %643 to ptr
  store volatile i32 %612, ptr %644, align 4, !tbaa !9
  %645 = add i32 %642, -80
  %646 = inttoptr i32 %645 to ptr
  store volatile i32 %613, ptr %646, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #12
  store i32 4, ptr %5, align 4, !tbaa !14
  %647 = load i32, ptr @curr, align 4, !tbaa !9
  %648 = getelementptr inbounds nuw i8, ptr %514, i32 44
  %649 = load i32, ptr %648, align 4, !tbaa !60
  %650 = add i32 %649, %513
  call fastcc void @kexit(i32 noundef %647, i32 noundef %650) #12
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #14
  br label %736

651:                                              ; preds = %10
  %652 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %653 = load volatile i32, ptr %652, align 4, !tbaa !45
  br label %719

654:                                              ; preds = %10
  %655 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %656 = load volatile i32, ptr %655, align 4, !tbaa !50
  %657 = getelementptr inbounds nuw i8, ptr %5, i32 64
  store i32 %656, ptr %657, align 4, !tbaa !25
  %658 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %658, align 4, !tbaa !26
  br label %704

659:                                              ; preds = %10
  %660 = getelementptr inbounds nuw i8, ptr %5, i32 64
  %661 = load i32, ptr %660, align 4, !tbaa !25
  %662 = icmp eq i32 %661, 0
  br i1 %662, label %704, label %663

663:                                              ; preds = %659
  %664 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %665 = load i32, ptr %664, align 4, !tbaa !31
  %666 = add i32 %665, -84
  %667 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %667, align 4, !tbaa !26
  %668 = add i32 %661, 8
  %669 = inttoptr i32 %668 to ptr
  %670 = load volatile i32, ptr %669, align 4, !tbaa !9
  %671 = inttoptr i32 %666 to ptr
  store volatile i32 %670, ptr %671, align 4, !tbaa !9
  %672 = add i32 %661, 12
  %673 = inttoptr i32 %672 to ptr
  %674 = load volatile i32, ptr %673, align 4, !tbaa !9
  %675 = add i32 %665, -80
  %676 = inttoptr i32 %675 to ptr
  store volatile i32 %674, ptr %676, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %677 = load i32, ptr @curr, align 4, !tbaa !9
  %678 = add i32 %661, 4
  %679 = inttoptr i32 %678 to ptr
  %680 = load volatile i32, ptr %679, align 4, !tbaa !9
  tail call fastcc void @kexit(i32 noundef %677, i32 noundef %680) #12
  br label %736

681:                                              ; preds = %15, %693
  %682 = phi i32 [ %694, %693 ], [ 0, %15 ]
  %683 = icmp eq i32 %682, 8
  br i1 %683, label %704, label %684

684:                                              ; preds = %681
  %685 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %682
  %686 = load i32, ptr %685, align 4, !tbaa !14
  %687 = icmp eq i32 %686, 0
  br i1 %687, label %693, label %688

688:                                              ; preds = %684
  %689 = getelementptr inbounds nuw i8, ptr %685, i32 4
  %690 = load i32, ptr %689, align 4, !tbaa !16
  %691 = load volatile i32, ptr %16, align 4, !tbaa !45
  %692 = icmp eq i32 %690, %691
  br i1 %692, label %695, label %693

693:                                              ; preds = %684, %688
  %694 = add nuw nsw i32 %682, 1
  br label %681, !llvm.loop !87

695:                                              ; preds = %688
  %696 = icmp eq i32 %686, 5
  br i1 %696, label %704, label %697

697:                                              ; preds = %695
  %698 = icmp eq i32 %682, %4
  br i1 %698, label %719, label %699

699:                                              ; preds = %697
  %700 = icmp eq i32 %686, 2
  br i1 %700, label %701, label %702

701:                                              ; preds = %699
  tail call fastcc void @terminate(ptr noundef nonnull %685, i32 noundef -1) #12
  br label %704

702:                                              ; preds = %699
  %703 = getelementptr inbounds nuw i8, ptr %685, i32 48
  store i32 1, ptr %703, align 4, !tbaa !32
  br label %704

704:                                              ; preds = %681, %303, %213, %123, %24, %10, %19, %22, %654, %49, %52, %58, %61, %65, %68, %72, %75, %81, %84, %88, %91, %95, %98, %102, %105, %111, %114, %118, %121, %287, %291, %695, %702, %701, %659, %45, %143, %153, %165, %182, %198, %610
  %705 = phi i32 [ -1, %610 ], [ -1, %165 ], [ -1, %198 ], [ -1, %182 ], [ -1, %153 ], [ %145, %143 ], [ %47, %45 ], [ -1, %659 ], [ 0, %701 ], [ 0, %702 ], [ -1, %695 ], [ -1, %291 ], [ %290, %287 ], [ -1, %118 ], [ %122, %121 ], [ -1, %111 ], [ %117, %114 ], [ -1, %102 ], [ %110, %105 ], [ -1, %95 ], [ %101, %98 ], [ -1, %88 ], [ %94, %91 ], [ -1, %81 ], [ %87, %84 ], [ -1, %72 ], [ %80, %75 ], [ -1, %65 ], [ %71, %68 ], [ -1, %58 ], [ %64, %61 ], [ -1, %49 ], [ %57, %52 ], [ 0, %654 ], [ %23, %22 ], [ %21, %19 ], [ -1, %10 ], [ -1, %24 ], [ -1, %123 ], [ %203, %213 ], [ -1, %303 ], [ -1, %681 ]
  %706 = load i32, ptr %11, align 4, !tbaa !27
  %707 = inttoptr i32 %706 to ptr
  %708 = getelementptr inbounds nuw i8, ptr %707, i32 16
  store volatile i32 %705, ptr %708, align 4, !tbaa !28
  %709 = getelementptr inbounds nuw i8, ptr %707, i32 20
  store volatile i32 1, ptr %709, align 4, !tbaa !30
  %710 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %711 = load i32, ptr %710, align 4, !tbaa !31
  %712 = add i32 %711, -84
  %713 = inttoptr i32 %712 to ptr
  store volatile i32 %705, ptr %713, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %714 = load i32, ptr @curr, align 4, !tbaa !9
  %715 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %716 = load i32, ptr %715, align 4, !tbaa !35
  %717 = inttoptr i32 %716 to ptr
  %718 = load volatile i32, ptr %717, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %714, i32 noundef %718) #12
  br label %736

719:                                              ; preds = %697, %651
  %720 = phi i32 [ %653, %651 ], [ -1, %697 ]
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef %720) #12
  br label %721

721:                                              ; preds = %719, %143, %45
  %722 = phi i32 [ -3, %45 ], [ -3, %143 ], [ -1, %719 ]
  %723 = load i32, ptr %5, align 4, !tbaa !14
  %724 = icmp eq i32 %723, 2
  br i1 %724, label %725, label %735

725:                                              ; preds = %316, %293, %243, %721
  %726 = phi i32 [ %722, %721 ], [ 0, %316 ], [ %302, %293 ], [ 0, %243 ]
  %727 = load i32, ptr %11, align 4, !tbaa !27
  %728 = inttoptr i32 %727 to ptr
  %729 = getelementptr inbounds nuw i8, ptr %728, i32 16
  store volatile i32 %726, ptr %729, align 4, !tbaa !28
  %730 = getelementptr inbounds nuw i8, ptr %728, i32 20
  store volatile i32 1, ptr %730, align 4, !tbaa !30
  %731 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %732 = load i32, ptr %731, align 4, !tbaa !31
  %733 = add i32 %732, -84
  %734 = inttoptr i32 %733 to ptr
  store volatile i32 %726, ptr %734, align 4, !tbaa !9
  br label %735

735:                                              ; preds = %725, %721
  tail call fastcc void @swtch() #12
  br label %736

736:                                              ; preds = %611, %663, %704, %735, %9
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @badbuf(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #7 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 56
  %5 = load i32, ptr %4, align 4, !tbaa !53
  %6 = icmp ne i32 %2, 0
  %7 = icmp ult i32 %1, %5
  %8 = and i1 %6, %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = add i32 %2, %1
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 60
  %12 = load i32, ptr %11, align 4, !tbaa !52
  %13 = icmp ugt i32 %10, %12
  br i1 %13, label %14, label %17

14:                                               ; preds = %9
  %15 = icmp uge i32 %10, %1
  %16 = zext i1 %15 to i32
  br label %17

17:                                               ; preds = %14, %9, %3
  %18 = phi i32 [ 0, %9 ], [ 0, %3 ], [ %16, %14 ]
  ret i32 %18
}

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_write(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_open(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_close(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_dup(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_fstat(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_pipe(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_chdir(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mkdir(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_link(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_unlink(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sync() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_read(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #9

; Function Attrs: minsize optsize
declare dso_local void @kfs_forkcopy(i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iopen(ptr noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iread(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_iclose(i32 noundef) local_unnamed_addr #8

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #10 {
  %2 = load i1, ptr @kheap_init, align 4
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  store i1 true, ptr @kheap_init, align 4
  %4 = load i32, ptr @arena, align 4, !tbaa !9
  %5 = inttoptr i32 %4 to ptr
  store ptr %5, ptr @kfreelist, align 4, !tbaa !88
  %6 = load i32, ptr @arena_end, align 4, !tbaa !9
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !90
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr null, ptr %8, align 4, !tbaa !92
  br label %9

9:                                                ; preds = %3, %1
  %10 = add i32 %0, 255
  %11 = and i32 %10, -256
  %12 = add i32 %11, 256
  br label %13

13:                                               ; preds = %38, %9
  %14 = phi ptr [ @kfreelist, %9 ], [ %39, %38 ]
  %15 = load ptr, ptr %14, align 4, !tbaa !88
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !90
  %19 = icmp ult i32 %18, %12
  br i1 %19, label %38, label %20

20:                                               ; preds = %17
  %21 = sub nuw i32 %18, %12
  %22 = icmp ugt i32 %21, 511
  br i1 %22, label %23, label %30

23:                                               ; preds = %20
  %24 = ptrtoint ptr %15 to i32
  %25 = add i32 %12, %24
  %26 = inttoptr i32 %25 to ptr
  store i32 %21, ptr %26, align 4, !tbaa !90
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !92
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !92
  store i32 %12, ptr %15, align 4, !tbaa !90
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !92
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !88
  %37 = add i32 %35, 256
  br label %40

38:                                               ; preds = %17
  %39 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %13, !llvm.loop !93

40:                                               ; preds = %13, %34
  %41 = phi i32 [ %37, %34 ], [ 0, %13 ]
  ret i32 %41
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #10 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %41, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -256
  br label %5

5:                                                ; preds = %5, %3
  %6 = phi ptr [ null, %3 ], [ %8, %5 ]
  %7 = phi ptr [ @kfreelist, %3 ], [ %13, %5 ]
  %8 = load ptr, ptr %7, align 4, !tbaa !88
  %9 = icmp ne ptr %8, null
  %10 = ptrtoint ptr %8 to i32
  %11 = icmp ugt i32 %4, %10
  %12 = and i1 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 4
  br i1 %12, label %5, label %14, !llvm.loop !94

14:                                               ; preds = %5
  %15 = inttoptr i32 %4 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  store ptr %8, ptr %16, align 4, !tbaa !92
  %17 = icmp eq ptr %6, null
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %15, ptr %19, align 4, !tbaa !92
  br label %21

20:                                               ; preds = %14
  store ptr %15, ptr @kfreelist, align 4, !tbaa !88
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !90
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !90
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !90
  %29 = load ptr, ptr %13, align 4, !tbaa !92
  store ptr %29, ptr %16, align 4, !tbaa !92
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !90
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !90
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !90
  %39 = load ptr, ptr %16, align 4, !tbaa !92
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !92
  br label %41

41:                                               ; preds = %30, %31, %36, %1
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree_exec(i32 noundef %0) unnamed_addr #10 {
  br label %2

2:                                                ; preds = %14, %1
  %3 = phi i32 [ 0, %1 ], [ %17, %14 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %5, label %14

5:                                                ; preds = %2
  %6 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !9
  tail call fastcc void @kfree(i32 noundef %7) #12
  store i32 0, ptr %6, align 4, !tbaa !9
  %8 = getelementptr inbounds [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 60
  store i32 0, ptr %9, align 4, !tbaa !52
  %10 = getelementptr inbounds nuw i8, ptr %8, i32 56
  store i32 0, ptr %10, align 4, !tbaa !53
  %11 = getelementptr inbounds nuw i8, ptr %8, i32 52
  store i32 0, ptr %11, align 4, !tbaa !51
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 68
  store i32 0, ptr %12, align 4, !tbaa !26
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 64
  store i32 0, ptr %13, align 4, !tbaa !25
  ret void

14:                                               ; preds = %2
  %15 = getelementptr inbounds [8 x [3 x i32]], ptr @execmem, i32 0, i32 %0, i32 %3
  %16 = load i32, ptr %15, align 4, !tbaa !9
  tail call fastcc void @kfree(i32 noundef %16) #12
  store i32 0, ptr %15, align 4, !tbaa !9
  %17 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !95
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
  %10 = load i32, ptr %9, align 4, !tbaa !14
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %27

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !18
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr %3, align 4, !tbaa !16
  %18 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %19 = load i32, ptr %18, align 4, !tbaa !27
  %20 = inttoptr i32 %19 to ptr
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store volatile i32 %17, ptr %21, align 4, !tbaa !28
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 20
  store volatile i32 1, ptr %22, align 4, !tbaa !30
  %23 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %24 = load i32, ptr %23, align 4, !tbaa !31
  %25 = add i32 %24, -84
  %26 = inttoptr i32 %25 to ptr
  store volatile i32 %17, ptr %26, align 4, !tbaa !9
  store i32 0, ptr %13, align 4, !tbaa !18
  store i32 3, ptr %9, align 4, !tbaa !14
  br label %27

27:                                               ; preds = %16, %12, %8
  %28 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !96
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #3 {
  %3 = load i32, ptr @entry_disp, align 4, !tbaa !9
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %11, label %5

5:                                                ; preds = %2
  %6 = inttoptr i32 %3 to ptr
  %7 = load volatile i32, ptr %6, align 4, !tbaa !9
  %8 = load i32, ptr @entry_thunk, align 4, !tbaa !9
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  store volatile i32 %8, ptr %6, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %11

11:                                               ; preds = %10, %5, %2
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 68
  %14 = load i32, ptr %13, align 4, !tbaa !26
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %40

16:                                               ; preds = %11
  %17 = getelementptr inbounds nuw i8, ptr %12, i32 64
  %18 = load i32, ptr %17, align 4, !tbaa !25
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %40, label %20

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !31
  %23 = add i32 %22, -84
  %24 = add i32 %18, 4
  %25 = inttoptr i32 %24 to ptr
  store volatile i32 %1, ptr %25, align 4, !tbaa !9
  %26 = inttoptr i32 %23 to ptr
  %27 = load volatile i32, ptr %26, align 4, !tbaa !9
  %28 = load i32, ptr %17, align 4, !tbaa !25
  %29 = add i32 %28, 8
  %30 = inttoptr i32 %29 to ptr
  store volatile i32 %27, ptr %30, align 4, !tbaa !9
  %31 = add i32 %22, -80
  %32 = inttoptr i32 %31 to ptr
  %33 = load volatile i32, ptr %32, align 4, !tbaa !9
  %34 = load i32, ptr %17, align 4, !tbaa !25
  %35 = add i32 %34, 12
  %36 = inttoptr i32 %35 to ptr
  store volatile i32 %33, ptr %36, align 4, !tbaa !9
  %37 = load i32, ptr %17, align 4, !tbaa !25
  %38 = inttoptr i32 %37 to ptr
  %39 = load volatile i32, ptr %38, align 4, !tbaa !9
  store i32 2, ptr %13, align 4, !tbaa !26
  br label %40

40:                                               ; preds = %20, %16, %11
  %41 = phi i32 [ %39, %20 ], [ %1, %16 ], [ %1, %11 ]
  store i32 %0, ptr @curr, align 4, !tbaa !9
  %42 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %43 = load i32, ptr %42, align 4, !tbaa !31
  %44 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !37
  store i32 %43, ptr %44, align 4, !tbaa !9
  %45 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %46 = load i32, ptr %45, align 4, !tbaa !40
  %47 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !37
  store i32 %46, ptr %47, align 4, !tbaa !9
  %48 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %49 = load i32, ptr %48, align 4, !tbaa !86
  %50 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !37
  store i32 %49, ptr %50, align 4, !tbaa !9
  %51 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !37
  store i32 %41, ptr %51, align 4, !tbaa !9
  %52 = load i32, ptr %42, align 4, !tbaa !31
  %53 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %54 = inttoptr i32 %53 to ptr
  store volatile i32 %52, ptr %54, align 4, !tbaa !9
  %55 = load i32, ptr @tickpending, align 4, !tbaa !9
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %58, label %57

57:                                               ; preds = %40
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #12
  br label %58

58:                                               ; preds = %57, %40
  %59 = load i1, ptr @rearm, align 4
  br i1 %59, label %60, label %63

60:                                               ; preds = %58
  %61 = load i32, ptr @inj_treg, align 4, !tbaa !9
  %62 = inttoptr i32 %61 to ptr
  store volatile i32 1, ptr %62, align 4, !tbaa !9
  br label %63

63:                                               ; preds = %60, %58
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #3 {
  tail call void @dma_ktick() #12
  tail call void @dma_ksyscall() #12
  ret i32 0
}

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #11

attributes #0 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nounwind optsize memory(readwrite, argmem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #11 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { minsize nobuiltin optsize "no-builtins" }
attributes #13 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #14 = { nounwind }

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
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !4, i64 0}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = !{!15, !10, i64 0}
!15 = !{!"proc", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48, !10, i64 52, !10, i64 56, !10, i64 60, !10, i64 64, !10, i64 68}
!16 = !{!15, !10, i64 4}
!17 = distinct !{!17, !7, !8}
!18 = !{!15, !10, i64 12}
!19 = !{!15, !10, i64 8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !7, !8}
!23 = distinct !{!23, !7, !8}
!24 = distinct !{!24, !7, !8}
!25 = !{!15, !10, i64 64}
!26 = !{!15, !10, i64 68}
!27 = !{!15, !10, i64 44}
!28 = !{!29, !10, i64 16}
!29 = !{!"dma_sysmail", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20}
!30 = !{!29, !10, i64 20}
!31 = !{!15, !10, i64 24}
!32 = !{!15, !10, i64 48}
!33 = distinct !{!33, !7, !8}
!34 = distinct !{!34, !7, !8}
!35 = !{!15, !10, i64 32}
!36 = !{!15, !10, i64 40}
!37 = !{!38, !38, i64 0}
!38 = !{!"p1 int", !39, i64 0}
!39 = !{!"any pointer", !4, i64 0}
!40 = !{!15, !10, i64 36}
!41 = !{!15, !10, i64 16}
!42 = distinct !{!42, !7, !8}
!43 = !{!15, !10, i64 20}
!44 = distinct !{!44, !7, !8}
!45 = !{!29, !10, i64 4}
!46 = distinct !{!46, !7, !8}
!47 = distinct !{!47, !7, !8}
!48 = !{!29, !10, i64 0}
!49 = !{!29, !10, i64 8}
!50 = !{!29, !10, i64 12}
!51 = !{!15, !10, i64 52}
!52 = !{!15, !10, i64 60}
!53 = !{!15, !10, i64 56}
!54 = distinct !{!54, !7, !8}
!55 = distinct !{!55, !7, !8}
!56 = distinct !{!56, !8}
!57 = distinct !{!57, !7, !8}
!58 = distinct !{!58, !7, !8}
!59 = !{i64 0, i64 4, !9, i64 4, i64 4, !9, i64 8, i64 4, !9, i64 12, i64 4, !9, i64 16, i64 4, !9, i64 20, i64 4, !9, i64 24, i64 4, !9, i64 28, i64 4, !9, i64 32, i64 4, !9, i64 36, i64 4, !9, i64 40, i64 4, !9, i64 44, i64 4, !9, i64 48, i64 4, !9, i64 52, i64 4, !9, i64 56, i64 4, !9, i64 60, i64 4, !9, i64 64, i64 4, !9, i64 68, i64 4, !9}
!60 = !{!61, !10, i64 44}
!61 = !{!"kimg", !4, i64 0, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48, !10, i64 52, !10, i64 56, !10, i64 60, !10, i64 64, !10, i64 68}
!62 = !{!61, !10, i64 48}
!63 = !{!61, !10, i64 52}
!64 = !{!61, !10, i64 56}
!65 = !{!61, !10, i64 60}
!66 = !{!61, !10, i64 64}
!67 = !{!61, !10, i64 68}
!68 = distinct !{!68, !7, !8}
!69 = !{!61, !10, i64 40}
!70 = distinct !{!70, !7, !8}
!71 = distinct !{!71, !7, !8}
!72 = !{!61, !10, i64 16}
!73 = !{!61, !10, i64 24}
!74 = !{!61, !10, i64 12}
!75 = !{!61, !10, i64 20}
!76 = distinct !{!76, !7, !8}
!77 = distinct !{!77, !7, !8}
!78 = !{!61, !10, i64 28}
!79 = !{!61, !10, i64 32}
!80 = !{!61, !10, i64 36}
!81 = distinct !{!81, !7, !8}
!82 = distinct !{!82, !8}
!83 = distinct !{!83, !7, !8}
!84 = distinct !{!84, !7, !8}
!85 = distinct !{!85, !7, !8}
!86 = !{!15, !10, i64 28}
!87 = distinct !{!87, !7, !8}
!88 = !{!89, !89, i64 0}
!89 = !{!"p1 _ZTS4khdr", !39, i64 0}
!90 = !{!91, !10, i64 0}
!91 = !{!"khdr", !10, i64 0, !89, i64 4}
!92 = !{!91, !89, i64 4}
!93 = distinct !{!93, !7, !8}
!94 = distinct !{!94, !7, !8}
!95 = distinct !{!95, !7, !8}
!96 = distinct !{!96, !7, !8}
