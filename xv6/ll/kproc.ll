; ModuleID = 'dma/kproc.c'
source_filename = "dma/kproc.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.kimg = type { [12 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.proc = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@inj_wreg = dso_local local_unnamed_addr global i32 1342177476, align 4
@inj_treg = dso_local local_unnamed_addr global i32 1342177500, align 4
@kimages = dso_local global [24 x %struct.kimg] zeroinitializer, align 4
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
@arena_end = dso_local local_unnamed_addr global i32 0, align 4
@arena = dso_local local_unnamed_addr global i32 0, align 4
@kheap_init = internal unnamed_addr global i1 false, align 4
@kfreelist = internal unnamed_addr global ptr null, align 4
@heapmem = internal unnamed_addr global [8 x i32] zeroinitializer, align 4
@cons_raw = internal unnamed_addr global i1 false, align 4
@cons_raw_pid = internal unnamed_addr global i32 0, align 4
@cons_e = internal unnamed_addr global i32 0, align 4
@kw_pcurdisp = dso_local global ptr null, align 4
@kw_curthunk = dso_local global ptr null, align 4
@kw_pcurresume = dso_local global ptr null, align 4
@kw_nextresume = dso_local global ptr null, align 4
@kw_park = dso_local global ptr null, align 4
@kw_parkvec = dso_local global ptr null, align 4
@tickpending = dso_local global i32 0, align 4
@initpid = dso_local local_unnamed_addr global i32 0, align 4
@fgpid = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@.str = private unnamed_addr constant [18 x i8] c"fb: 640x240x8 on\0A\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"fb: psram fail\0A\00", align 1
@parked = internal unnamed_addr global i1 false, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local ptr @kimg_name(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 0
  br i1 %2, label %10, label %3

3:                                                ; preds = %1
  %4 = icmp samesign ugt i32 %0, 23
  br i1 %4, label %10, label %5

5:                                                ; preds = %3
  %6 = getelementptr inbounds nuw [24 x %struct.kimg], ptr @kimages, i32 0, i32 %0
  %7 = load i8, ptr %6, align 4, !tbaa !3
  %8 = icmp eq i8 %7, 0
  %9 = select i1 %8, ptr null, ptr %6
  br label %10

10:                                               ; preds = %5, %1, %3
  %11 = phi ptr [ null, %3 ], [ null, %1 ], [ %9, %5 ]
  ret ptr %11
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kconswrite(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #1 {
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
  tail call fastcc void @cputc(i32 noundef %10) #11
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !6
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc(i32 noundef range(i32 -128, 256) %0) unnamed_addr #1 {
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
  tail call void @kfbcon_putc(i32 noundef %0) #12
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  tail call fastcc void @cons_poll() #11
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
define internal fastcc void @cons_poll() unnamed_addr #1 {
  br label %1

1:                                                ; preds = %79, %0
  %2 = load i32, ptr @cons_e, align 4, !tbaa !9
  %3 = load i32, ptr @cons_r, align 4, !tbaa !9
  %4 = sub i32 %2, %3
  %5 = icmp ult i32 %4, 128
  br i1 %5, label %6, label %191

6:                                                ; preds = %1
  %7 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %8 = and i32 %7, 16
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %191

10:                                               ; preds = %6
  %11 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !9
  %12 = and i32 %11, 255
  %13 = load i1, ptr @cons_raw, align 4
  br i1 %13, label %14, label %19

14:                                               ; preds = %10
  %15 = trunc i32 %11 to i8
  %16 = and i32 %2, 127
  %17 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %16
  store i8 %15, ptr %17, align 1, !tbaa !3
  %18 = add i32 %2, 1
  store i32 %18, ptr @cons_e, align 4, !tbaa !9
  store i32 %18, ptr @cons_w, align 4, !tbaa !9
  br label %79

19:                                               ; preds = %10
  %20 = icmp eq i32 %12, 3
  br i1 %20, label %21, label %162

21:                                               ; preds = %19
  %22 = load i32, ptr @fgpid, align 4, !tbaa !9
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %79, label %24

24:                                               ; preds = %21, %35
  %25 = phi i32 [ %36, %35 ], [ 0, %21 ]
  %26 = icmp eq i32 %25, 8
  br i1 %26, label %79, label %27, !llvm.loop !13

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %25
  %29 = load i32, ptr %28, align 4, !tbaa !14
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %35, label %31

31:                                               ; preds = %27
  %32 = getelementptr inbounds nuw i8, ptr %28, i32 4
  %33 = load i32, ptr %32, align 4, !tbaa !16
  %34 = icmp eq i32 %33, %22
  br i1 %34, label %37, label %35

35:                                               ; preds = %31, %27
  %36 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !17

37:                                               ; preds = %31
  %38 = icmp eq i32 %29, 2
  br i1 %38, label %39, label %79

39:                                               ; preds = %37
  %40 = getelementptr inbounds nuw i8, ptr %28, i32 12
  %41 = load i32, ptr %40, align 4, !tbaa !18
  %42 = ptrtoint ptr %28 to i32
  %43 = icmp eq i32 %41, %42
  br i1 %43, label %44, label %65

44:                                               ; preds = %39, %61
  %45 = phi ptr [ %62, %61 ], [ null, %39 ]
  %46 = phi i32 [ %63, %61 ], [ 0, %39 ]
  %47 = phi i32 [ %64, %61 ], [ 0, %39 ]
  %48 = icmp eq i32 %47, 8
  br i1 %48, label %77, label %49

49:                                               ; preds = %44
  %50 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %47
  %51 = load i32, ptr %50, align 4, !tbaa !14
  switch i32 %51, label %52 [
    i32 0, label %61
    i32 5, label %61
  ]

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %50, i32 8
  %54 = load i32, ptr %53, align 4, !tbaa !19
  %55 = icmp eq i32 %54, %22
  br i1 %55, label %56, label %61

56:                                               ; preds = %52
  %57 = getelementptr inbounds nuw i8, ptr %50, i32 4
  %58 = load i32, ptr %57, align 4, !tbaa !16
  %59 = icmp ugt i32 %58, %46
  br i1 %59, label %60, label %61

60:                                               ; preds = %56
  br label %61

61:                                               ; preds = %60, %56, %52, %49, %49
  %62 = phi ptr [ %50, %60 ], [ %45, %56 ], [ %45, %52 ], [ %45, %49 ], [ %45, %49 ]
  %63 = phi i32 [ %58, %60 ], [ %46, %56 ], [ %46, %52 ], [ %46, %49 ], [ %46, %49 ]
  %64 = add nuw nsw i32 %47, 1
  br label %44, !llvm.loop !20

65:                                               ; preds = %39, %75
  %66 = phi i32 [ %76, %75 ], [ 0, %39 ]
  %67 = icmp eq i32 %66, 8
  br i1 %67, label %79, label %68, !llvm.loop !13

68:                                               ; preds = %65
  %69 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %66
  %70 = ptrtoint ptr %69 to i32
  %71 = icmp eq i32 %41, %70
  br i1 %71, label %72, label %75

72:                                               ; preds = %68
  %73 = load i32, ptr %69, align 4, !tbaa !14
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %75, label %80

75:                                               ; preds = %72, %68
  %76 = add nuw nsw i32 %66, 1
  br label %65, !llvm.loop !21

77:                                               ; preds = %44
  %78 = icmp eq ptr %45, null
  br i1 %78, label %79, label %80

79:                                               ; preds = %24, %65, %123, %77, %37, %21, %190, %186, %166, %169, %14
  br label %1, !llvm.loop !13

80:                                               ; preds = %72, %77
  %81 = phi ptr [ %45, %77 ], [ %69, %72 ]
  tail call fastcc void @cputc(i32 noundef 94) #11
  tail call fastcc void @cputc(i32 noundef 67) #11
  tail call fastcc void @cputc(i32 noundef 10) #11
  br label %82

82:                                               ; preds = %120, %80
  %83 = phi i32 [ 0, %80 ], [ %121, %120 ]
  %84 = phi i32 [ 0, %80 ], [ %122, %120 ]
  %85 = icmp eq i32 %84, 8
  br i1 %85, label %123, label %86

86:                                               ; preds = %82
  %87 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %84
  %88 = load i32, ptr %87, align 4, !tbaa !14
  switch i32 %88, label %89 [
    i32 0, label %120
    i32 5, label %120
  ]

89:                                               ; preds = %86, %114
  %90 = phi ptr [ %115, %114 ], [ %87, %86 ]
  %91 = phi i32 [ %116, %114 ], [ 0, %86 ]
  %92 = icmp eq ptr %90, null
  %93 = icmp samesign ugt i32 %91, 7
  %94 = select i1 %92, i1 true, i1 %93
  br i1 %94, label %120, label %95

95:                                               ; preds = %89
  %96 = icmp eq ptr %90, %81
  br i1 %96, label %117, label %97

97:                                               ; preds = %95
  %98 = getelementptr inbounds nuw i8, ptr %90, i32 8
  %99 = load i32, ptr %98, align 4, !tbaa !19
  %100 = icmp eq i32 %99, 0
  br i1 %100, label %120, label %101

101:                                              ; preds = %97, %112
  %102 = phi i32 [ %113, %112 ], [ 0, %97 ]
  %103 = icmp eq i32 %102, 8
  br i1 %103, label %114, label %104

104:                                              ; preds = %101
  %105 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %102
  %106 = load i32, ptr %105, align 4, !tbaa !14
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %112, label %108

108:                                              ; preds = %104
  %109 = getelementptr inbounds nuw i8, ptr %105, i32 4
  %110 = load i32, ptr %109, align 4, !tbaa !16
  %111 = icmp eq i32 %110, %99
  br i1 %111, label %114, label %112

112:                                              ; preds = %108, %104
  %113 = add nuw nsw i32 %102, 1
  br label %101, !llvm.loop !22

114:                                              ; preds = %108, %101
  %115 = phi ptr [ null, %101 ], [ %105, %108 ]
  %116 = add nuw nsw i32 %91, 1
  br label %89, !llvm.loop !23

117:                                              ; preds = %95
  %118 = shl nuw nsw i32 1, %84
  %119 = or i32 %118, %83
  br label %120

120:                                              ; preds = %97, %89, %117, %86, %86
  %121 = phi i32 [ %119, %117 ], [ %83, %86 ], [ %83, %86 ], [ %83, %89 ], [ %83, %97 ]
  %122 = add nuw nsw i32 %84, 1
  br label %82, !llvm.loop !24

123:                                              ; preds = %82, %160
  %124 = phi i32 [ %161, %160 ], [ 0, %82 ]
  %125 = icmp eq i32 %124, 8
  br i1 %125, label %79, label %126, !llvm.loop !13

126:                                              ; preds = %123
  %127 = shl nuw nsw i32 1, %124
  %128 = and i32 %127, %83
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %160, label %130

130:                                              ; preds = %126
  %131 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %124
  %132 = getelementptr inbounds nuw i8, ptr %131, i32 64
  %133 = load i32, ptr %132, align 4, !tbaa !25
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %154, label %135

135:                                              ; preds = %130
  %136 = getelementptr inbounds nuw i8, ptr %131, i32 68
  %137 = load i32, ptr %136, align 4, !tbaa !26
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %139, label %160

139:                                              ; preds = %135
  %140 = load i32, ptr %131, align 4, !tbaa !14
  %141 = icmp eq i32 %140, 2
  br i1 %141, label %142, label %153

142:                                              ; preds = %139
  %143 = getelementptr inbounds nuw i8, ptr %131, i32 44
  %144 = load i32, ptr %143, align 4, !tbaa !27
  %145 = inttoptr i32 %144 to ptr
  %146 = getelementptr inbounds nuw i8, ptr %145, i32 16
  store volatile i32 -1, ptr %146, align 4, !tbaa !28
  %147 = getelementptr inbounds nuw i8, ptr %145, i32 20
  store volatile i32 1, ptr %147, align 4, !tbaa !30
  %148 = getelementptr inbounds nuw i8, ptr %131, i32 24
  %149 = load i32, ptr %148, align 4, !tbaa !31
  %150 = add i32 %149, -84
  %151 = inttoptr i32 %150 to ptr
  store volatile i32 -1, ptr %151, align 4, !tbaa !9
  %152 = getelementptr inbounds nuw i8, ptr %131, i32 12
  store i32 0, ptr %152, align 4, !tbaa !18
  store i32 3, ptr %131, align 4, !tbaa !14
  br label %153

153:                                              ; preds = %142, %139
  store i32 1, ptr %136, align 4, !tbaa !26
  br label %160

154:                                              ; preds = %130
  %155 = load i32, ptr %131, align 4, !tbaa !14
  %156 = icmp eq i32 %155, 2
  br i1 %156, label %157, label %158

157:                                              ; preds = %154
  tail call fastcc void @terminate(ptr noundef nonnull %131, i32 noundef -1) #11
  br label %160

158:                                              ; preds = %154
  %159 = getelementptr inbounds nuw i8, ptr %131, i32 48
  store i32 1, ptr %159, align 4, !tbaa !32
  br label %160

160:                                              ; preds = %158, %157, %153, %135, %126
  %161 = add nuw nsw i32 %124, 1
  br label %123, !llvm.loop !33

162:                                              ; preds = %19
  %163 = icmp eq i32 %12, 13
  %164 = select i1 %163, i32 10, i32 %12
  %165 = trunc i32 %11 to i8
  switch i8 %165, label %171 [
    i8 8, label %166
    i8 127, label %166
  ]

166:                                              ; preds = %162, %162
  %167 = load i32, ptr @cons_w, align 4, !tbaa !9
  %168 = icmp eq i32 %2, %167
  br i1 %168, label %79, label %169

169:                                              ; preds = %166
  %170 = add i32 %2, -1
  store i32 %170, ptr @cons_e, align 4, !tbaa !9
  tail call fastcc void @cputc(i32 noundef 8) #11
  tail call fastcc void @cputc(i32 noundef 32) #11
  tail call fastcc void @cputc(i32 noundef 8) #11
  br label %79

171:                                              ; preds = %162
  %172 = trunc nuw i32 %164 to i8
  %173 = and i32 %2, 127
  %174 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %173
  store i8 %172, ptr %174, align 1, !tbaa !3
  %175 = add i32 %2, 1
  store i32 %175, ptr @cons_e, align 4, !tbaa !9
  %176 = icmp samesign ult i32 %164, 32
  %177 = add nsw i32 %164, -11
  %178 = icmp ult i32 %177, -2
  %179 = and i1 %176, %178
  br i1 %179, label %180, label %182

180:                                              ; preds = %171
  tail call fastcc void @cputc(i32 noundef 94) #11
  %181 = or disjoint i32 %164, 64
  br label %182

182:                                              ; preds = %171, %180
  %183 = phi i32 [ %181, %180 ], [ %164, %171 ]
  tail call fastcc void @cputc(i32 noundef %183) #11
  %184 = icmp eq i32 %164, 10
  %185 = load i32, ptr @cons_e, align 4, !tbaa !9
  br i1 %184, label %190, label %186

186:                                              ; preds = %182
  %187 = load i32, ptr @cons_r, align 4, !tbaa !9
  %188 = sub i32 %185, %187
  %189 = icmp eq i32 %188, 128
  br i1 %189, label %190, label %79

190:                                              ; preds = %186, %182
  store i32 %185, ptr @cons_w, align 4, !tbaa !9
  br label %79

191:                                              ; preds = %1, %6
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 9, 8) i32 @kfind_sleeper(i32 noundef %0) local_unnamed_addr #3 {
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
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #4 {
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
define dso_local void @kmail_set(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #5 {
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
define dso_local void @kcomplete(i32 noundef %0, i32 noundef %1) local_unnamed_addr #5 {
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
define dso_local i32 @kblock_self_slot() local_unnamed_addr #0 {
  %1 = load i32, ptr @curr, align 4, !tbaa !9
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #4 {
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
define dso_local void @dma_ktick() local_unnamed_addr #1 {
  tail call fastcc void @kenter() #11
  tail call fastcc void @tick_income() #11
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
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #11
  br label %17

17:                                               ; preds = %0, %9, %15, %16
  tail call fastcc void @swtch() #11
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kenter() unnamed_addr #1 {
  store i1 false, ptr @rearm, align 4
  %1 = load i32, ptr @fsready, align 4, !tbaa !9
  %2 = icmp eq i32 %1, 0
  %3 = load i32, ptr @dma_disk, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %2, i1 %4, i1 false
  br i1 %5, label %6, label %14

6:                                                ; preds = %0
  %7 = tail call i32 @kfb_init() #12
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %6
  tail call void @kfbcon_reset() #12
  tail call void @kconswrite(ptr noundef nonnull @.str, i32 noundef 17) #11
  br label %13

10:                                               ; preds = %6
  %11 = icmp slt i32 %7, 0
  br i1 %11, label %12, label %13

12:                                               ; preds = %10
  tail call void @kconswrite(ptr noundef nonnull @.str.1, i32 noundef 15) #11
  br label %13

13:                                               ; preds = %10, %12, %9
  tail call void @kfs_start() #12
  tail call void @kflash_init() #12
  br label %14

14:                                               ; preds = %13, %0
  %15 = load i1, ptr @parked, align 4
  %16 = zext i1 %15 to i32
  store i32 %16, ptr @waspark, align 4, !tbaa !9
  br i1 %15, label %17, label %18

17:                                               ; preds = %14
  store i1 false, ptr @parked, align 4
  store i32 0, ptr @entry_disp, align 4, !tbaa !9
  br label %29

18:                                               ; preds = %14
  %19 = load i32, ptr @curr, align 4, !tbaa !9
  %20 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %19
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !31
  store i32 %22, ptr @entry_disp, align 4, !tbaa !9
  %23 = getelementptr inbounds nuw i8, ptr %20, i32 36
  %24 = load i32, ptr %23, align 4, !tbaa !40
  store i32 %24, ptr @entry_thunk, align 4, !tbaa !9
  %25 = inttoptr i32 %22 to ptr
  %26 = load volatile i32, ptr %25, align 4, !tbaa !9
  %27 = icmp eq i32 %26, %24
  br i1 %27, label %29, label %28

28:                                               ; preds = %18
  store volatile i32 %24, ptr %25, align 4, !tbaa !9
  tail call fastcc void @tick_income() #11
  br label %29

29:                                               ; preds = %18, %28, %17
  %30 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %31 = inttoptr i32 %30 to ptr
  store volatile i32 ptrtoint (ptr @tickpending to i32), ptr %31, align 4, !tbaa !9
  %32 = load i32, ptr @tickpending, align 4, !tbaa !9
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %35, label %34

34:                                               ; preds = %29
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @tick_income() #11
  br label %35

35:                                               ; preds = %34, %29
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tick_income() unnamed_addr #1 {
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
  tail call fastcc void @cons_poll() #11
  br label %26

26:                                               ; preds = %25, %6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @terminate(ptr noundef %0, i32 noundef %1) unnamed_addr #1 {
  %3 = ptrtoint ptr %0 to i32
  %4 = sub i32 %3, ptrtoint (ptr @proc to i32)
  %5 = sdiv exact i32 %4, 72
  %6 = load i1, ptr @cons_raw, align 4
  br i1 %6, label %7, label %13

7:                                                ; preds = %2
  %8 = load i32, ptr @cons_raw_pid, align 4, !tbaa !9
  %9 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %10 = load i32, ptr %9, align 4, !tbaa !16
  %11 = icmp eq i32 %8, %10
  br i1 %11, label %12, label %13

12:                                               ; preds = %7
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !9
  br label %13

13:                                               ; preds = %12, %7, %2
  %14 = tail call i32 @kfb_owner() #12
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !16
  %17 = icmp eq i32 %14, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %13
  tail call void @kfb_setowner(i32 noundef 0) #12
  tail call void @kfbcon_reset() #12
  br label %19

19:                                               ; preds = %18, %13
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %20, align 4, !tbaa !43
  %21 = load i32, ptr @fsready, align 4, !tbaa !9
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %24, label %23

23:                                               ; preds = %19
  tail call void @kfs_exit(i32 noundef %5) #12
  br label %24

24:                                               ; preds = %23, %19
  tail call fastcc void @kfree_exec(i32 noundef %5) #11
  tail call fastcc void @vfork_release(ptr noundef nonnull %0) #11
  %25 = load i32, ptr @initpid, align 4, !tbaa !9
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %46, label %27

27:                                               ; preds = %24, %44
  %28 = phi i32 [ %45, %44 ], [ 0, %24 ]
  %29 = icmp eq i32 %28, 8
  br i1 %29, label %46, label %30

30:                                               ; preds = %27
  %31 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %28
  %32 = load i32, ptr %31, align 4, !tbaa !14
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %44, label %34

34:                                               ; preds = %30
  %35 = icmp eq ptr %31, %0
  br i1 %35, label %44, label %36

36:                                               ; preds = %34
  %37 = getelementptr inbounds nuw i8, ptr %31, i32 8
  %38 = load i32, ptr %37, align 4, !tbaa !19
  %39 = load i32, ptr %15, align 4, !tbaa !16
  %40 = icmp eq i32 %38, %39
  br i1 %40, label %41, label %44

41:                                               ; preds = %36
  store i32 %25, ptr %37, align 4, !tbaa !19
  %42 = icmp eq i32 %32, 5
  br i1 %42, label %43, label %44

43:                                               ; preds = %41
  store i32 0, ptr %31, align 4, !tbaa !14
  br label %44

44:                                               ; preds = %41, %43, %36, %34, %30
  %45 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !44

46:                                               ; preds = %27, %24
  %47 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %48 = load i32, ptr %47, align 4, !tbaa !19
  br label %49

49:                                               ; preds = %79, %46
  %50 = phi i32 [ 0, %46 ], [ %80, %79 ]
  %51 = icmp eq i32 %50, 8
  br i1 %51, label %90, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %50
  %54 = getelementptr inbounds nuw i8, ptr %53, i32 4
  %55 = load i32, ptr %54, align 4, !tbaa !16
  %56 = icmp eq i32 %55, %48
  br i1 %56, label %57, label %79

57:                                               ; preds = %52
  %58 = load i32, ptr %53, align 4, !tbaa !14
  %59 = icmp eq i32 %58, 2
  br i1 %59, label %60, label %79

60:                                               ; preds = %57
  %61 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %62 = load i32, ptr %61, align 4, !tbaa !18
  %63 = ptrtoint ptr %53 to i32
  %64 = icmp eq i32 %62, %63
  br i1 %64, label %65, label %79

65:                                               ; preds = %60
  %66 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %67 = getelementptr inbounds nuw i8, ptr %53, i32 44
  %68 = load i32, ptr %67, align 4, !tbaa !27
  %69 = inttoptr i32 %68 to ptr
  %70 = getelementptr inbounds nuw i8, ptr %69, i32 4
  %71 = load volatile i32, ptr %70, align 4, !tbaa !45
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %81, label %73

73:                                               ; preds = %65
  %74 = load i32, ptr %20, align 4, !tbaa !43
  %75 = load volatile i32, ptr %70, align 4, !tbaa !45
  %76 = inttoptr i32 %75 to ptr
  store volatile i32 %74, ptr %76, align 4, !tbaa !9
  %77 = load i32, ptr %67, align 4, !tbaa !27
  %78 = inttoptr i32 %77 to ptr
  br label %81

79:                                               ; preds = %60, %57, %52
  %80 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !46

81:                                               ; preds = %73, %65
  %82 = phi ptr [ %78, %73 ], [ %69, %65 ]
  %83 = load i32, ptr %15, align 4, !tbaa !16
  %84 = getelementptr inbounds nuw i8, ptr %82, i32 16
  store volatile i32 %83, ptr %84, align 4, !tbaa !28
  %85 = getelementptr inbounds nuw i8, ptr %82, i32 20
  store volatile i32 1, ptr %85, align 4, !tbaa !30
  %86 = getelementptr inbounds nuw i8, ptr %53, i32 24
  %87 = load i32, ptr %86, align 4, !tbaa !31
  %88 = add i32 %87, -84
  %89 = inttoptr i32 %88 to ptr
  store volatile i32 %83, ptr %89, align 4, !tbaa !9
  store i32 0, ptr %66, align 4, !tbaa !18
  store i32 3, ptr %53, align 4, !tbaa !14
  br label %94

90:                                               ; preds = %49
  br i1 %26, label %93, label %91

91:                                               ; preds = %90
  %92 = icmp eq i32 %48, %25
  br i1 %92, label %94, label %93

93:                                               ; preds = %91, %90
  br label %94

94:                                               ; preds = %81, %91, %93
  %95 = phi i32 [ 5, %93 ], [ 0, %91 ], [ 0, %81 ]
  store i32 %95, ptr %0, align 4, !tbaa !14
  %96 = getelementptr inbounds nuw i8, ptr %0, i32 48
  store i32 0, ptr %96, align 4, !tbaa !32
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @swtch() unnamed_addr #1 {
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
  tail call fastcc void @tick_income() #11
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
  tail call fastcc void @tick_income() #11
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
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %53) #11
  br label %54

54:                                               ; preds = %46, %48, %51
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ksyscall() local_unnamed_addr #1 {
  %1 = alloca %struct.kimg, align 4
  %2 = alloca [13 x i32], align 4
  %3 = alloca [64 x i32], align 4
  tail call fastcc void @kenter() #11
  %4 = load i32, ptr @curr, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !32
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #11
  tail call fastcc void @swtch() #11
  br label %927

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %12 = load i32, ptr %11, align 4, !tbaa !27
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !48
  switch i32 %14, label %895 [
    i32 11, label %19
    i32 14, label %22
    i32 16, label %24
    i32 15, label %49
    i32 21, label %58
    i32 10, label %65
    i32 8, label %72
    i32 33, label %81
    i32 4, label %90
    i32 9, label %97
    i32 20, label %104
    i32 19, label %111
    i32 18, label %120
    i32 22, label %127
    i32 5, label %134
    i32 12, label %158
    i32 13, label %254
    i32 3, label %17
    i32 1, label %314
    i32 7, label %344
    i32 2, label %663
    i32 26, label %666
    i32 27, label %675
    i32 25, label %682
    i32 28, label %770
    i32 29, label %779
    i32 30, label %787
    i32 31, label %793
    i32 32, label %820
    i32 23, label %845
    i32 24, label %850
    i32 6, label %15
  ]

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 4
  br label %872

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %266

19:                                               ; preds = %10
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !16
  br label %895

22:                                               ; preds = %10
  %23 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %895

24:                                               ; preds = %10
  %25 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %26 = load volatile i32, ptr %25, align 4, !tbaa !49
  %27 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %28 = load volatile i32, ptr %27, align 4, !tbaa !50
  %29 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %26, i32 noundef %28) #11
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %895

31:                                               ; preds = %24
  %32 = load i32, ptr @fsready, align 4, !tbaa !9
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %40, label %34

34:                                               ; preds = %31
  %35 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %36 = load volatile i32, ptr %35, align 4, !tbaa !45
  %37 = load volatile i32, ptr %25, align 4, !tbaa !49
  %38 = load volatile i32, ptr %27, align 4, !tbaa !50
  %39 = tail call i32 @kfs_write(i32 noundef %36, i32 noundef %37, i32 noundef %38) #12
  br label %45

40:                                               ; preds = %31
  %41 = load volatile i32, ptr %25, align 4, !tbaa !49
  %42 = inttoptr i32 %41 to ptr
  %43 = load volatile i32, ptr %27, align 4, !tbaa !50
  tail call void @kconswrite(ptr noundef %42, i32 noundef %43) #11
  %44 = load volatile i32, ptr %27, align 4, !tbaa !50
  br label %45

45:                                               ; preds = %34, %40
  %46 = phi i32 [ %39, %34 ], [ %44, %40 ]
  %47 = freeze i32 %46
  %48 = icmp eq i32 %47, -3
  br i1 %48, label %912, label %895

49:                                               ; preds = %10
  %50 = load i32, ptr @fsready, align 4, !tbaa !9
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %895, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %54 = load volatile i32, ptr %53, align 4, !tbaa !45
  %55 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %56 = load volatile i32, ptr %55, align 4, !tbaa !49
  %57 = tail call i32 @kfs_open(i32 noundef %54, i32 noundef %56) #12
  br label %895

58:                                               ; preds = %10
  %59 = load i32, ptr @fsready, align 4, !tbaa !9
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %895, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %63 = load volatile i32, ptr %62, align 4, !tbaa !45
  %64 = tail call i32 @kfs_close(i32 noundef %63) #12
  br label %895

65:                                               ; preds = %10
  %66 = load i32, ptr @fsready, align 4, !tbaa !9
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %895, label %68

68:                                               ; preds = %65
  %69 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %70 = load volatile i32, ptr %69, align 4, !tbaa !45
  %71 = tail call i32 @kfs_dup(i32 noundef %70) #12
  br label %895

72:                                               ; preds = %10
  %73 = load i32, ptr @fsready, align 4, !tbaa !9
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %895, label %75

75:                                               ; preds = %72
  %76 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %77 = load volatile i32, ptr %76, align 4, !tbaa !45
  %78 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %79 = load volatile i32, ptr %78, align 4, !tbaa !49
  %80 = tail call i32 @kfs_fstat(i32 noundef %77, i32 noundef %79) #12
  br label %895

81:                                               ; preds = %10
  %82 = load i32, ptr @fsready, align 4, !tbaa !9
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %895, label %84

84:                                               ; preds = %81
  %85 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %86 = load volatile i32, ptr %85, align 4, !tbaa !45
  %87 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %88 = load volatile i32, ptr %87, align 4, !tbaa !49
  %89 = tail call i32 @kfs_seek(i32 noundef %86, i32 noundef %88) #12
  br label %895

90:                                               ; preds = %10
  %91 = load i32, ptr @fsready, align 4, !tbaa !9
  %92 = icmp eq i32 %91, 0
  br i1 %92, label %895, label %93

93:                                               ; preds = %90
  %94 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %95 = load volatile i32, ptr %94, align 4, !tbaa !45
  %96 = tail call i32 @kfs_pipe(i32 noundef %95) #12
  br label %895

97:                                               ; preds = %10
  %98 = load i32, ptr @fsready, align 4, !tbaa !9
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %895, label %100

100:                                              ; preds = %97
  %101 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %102 = load volatile i32, ptr %101, align 4, !tbaa !45
  %103 = tail call i32 @kfs_chdir(i32 noundef %102) #12
  br label %895

104:                                              ; preds = %10
  %105 = load i32, ptr @fsready, align 4, !tbaa !9
  %106 = icmp eq i32 %105, 0
  br i1 %106, label %895, label %107

107:                                              ; preds = %104
  %108 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %109 = load volatile i32, ptr %108, align 4, !tbaa !45
  %110 = tail call i32 @kfs_mkdir(i32 noundef %109) #12
  br label %895

111:                                              ; preds = %10
  %112 = load i32, ptr @fsready, align 4, !tbaa !9
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %895, label %114

114:                                              ; preds = %111
  %115 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %116 = load volatile i32, ptr %115, align 4, !tbaa !45
  %117 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %118 = load volatile i32, ptr %117, align 4, !tbaa !49
  %119 = tail call i32 @kfs_link(i32 noundef %116, i32 noundef %118) #12
  br label %895

120:                                              ; preds = %10
  %121 = load i32, ptr @fsready, align 4, !tbaa !9
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %895, label %123

123:                                              ; preds = %120
  %124 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %125 = load volatile i32, ptr %124, align 4, !tbaa !45
  %126 = tail call i32 @kfs_unlink(i32 noundef %125) #12
  br label %895

127:                                              ; preds = %10
  tail call void @kfb_pause() #12
  %128 = load i32, ptr @fsready, align 4, !tbaa !9
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %132, label %130

130:                                              ; preds = %127
  %131 = tail call i32 @kflash_sync() #12
  br label %132

132:                                              ; preds = %127, %130
  %133 = phi i32 [ %131, %130 ], [ -1, %127 ]
  tail call void @kfb_resume() #12
  br label %895

134:                                              ; preds = %10
  %135 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %136 = load volatile i32, ptr %135, align 4, !tbaa !49
  %137 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %138 = load volatile i32, ptr %137, align 4, !tbaa !50
  %139 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %136, i32 noundef %138) #11
  %140 = icmp eq i32 %139, 0
  br i1 %140, label %141, label %895

141:                                              ; preds = %134
  %142 = load i32, ptr @fsready, align 4, !tbaa !9
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %150, label %144

144:                                              ; preds = %141
  %145 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %146 = load volatile i32, ptr %145, align 4, !tbaa !45
  %147 = load volatile i32, ptr %135, align 4, !tbaa !49
  %148 = load volatile i32, ptr %137, align 4, !tbaa !50
  %149 = tail call i32 @kfs_read(i32 noundef %146, i32 noundef %147, i32 noundef %148) #12
  br label %154

150:                                              ; preds = %141
  %151 = load volatile i32, ptr %135, align 4, !tbaa !49
  %152 = load volatile i32, ptr %137, align 4, !tbaa !50
  %153 = tail call i32 @kconsread(i32 noundef %151, i32 noundef %152) #11
  br label %154

154:                                              ; preds = %144, %150
  %155 = phi i32 [ %149, %144 ], [ %153, %150 ]
  %156 = freeze i32 %155
  %157 = icmp eq i32 %156, -3
  br i1 %157, label %912, label %895

158:                                              ; preds = %10
  %159 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %160 = load volatile i32, ptr %159, align 4, !tbaa !45
  %161 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %162 = load i32, ptr %161, align 4, !tbaa !51
  %163 = icmp eq i32 %162, 0
  br i1 %163, label %164, label %186

164:                                              ; preds = %158
  %165 = icmp slt i32 %160, 0
  br i1 %165, label %895, label %166

166:                                              ; preds = %164
  %167 = add nuw i32 %160, 255
  %168 = and i32 %167, -256
  %169 = icmp samesign ugt i32 %160, 16128
  %170 = select i1 %169, i32 %168, i32 16384
  %171 = tail call fastcc i32 @kalloc(i32 noundef %170) #11
  %172 = icmp ne i32 %171, 0
  %173 = or i1 %169, %172
  br i1 %173, label %176, label %174

174:                                              ; preds = %166
  %175 = tail call fastcc i32 @kalloc(i32 noundef %168) #11
  br label %176

176:                                              ; preds = %174, %166
  %177 = phi i32 [ %168, %174 ], [ %170, %166 ]
  %178 = phi i32 [ %175, %174 ], [ %171, %166 ]
  %179 = icmp eq i32 %178, 0
  br i1 %179, label %895, label %180

180:                                              ; preds = %176
  %181 = load i32, ptr @curr, align 4, !tbaa !9
  %182 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %181
  store i32 %178, ptr %182, align 4, !tbaa !9
  %183 = getelementptr inbounds nuw i8, ptr %5, i32 60
  store i32 %178, ptr %183, align 4, !tbaa !52
  store i32 %178, ptr %161, align 4, !tbaa !51
  %184 = add i32 %178, %177
  %185 = getelementptr inbounds nuw i8, ptr %5, i32 56
  store i32 %184, ptr %185, align 4, !tbaa !53
  br label %193

186:                                              ; preds = %158
  %187 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %188 = load i32, ptr %187, align 4, !tbaa !52
  %189 = icmp sgt i32 %160, -1
  br i1 %189, label %190, label %209

190:                                              ; preds = %186
  %191 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %192 = load i32, ptr %191, align 4, !tbaa !53
  br label %193

193:                                              ; preds = %190, %180
  %194 = phi i32 [ %184, %180 ], [ %192, %190 ]
  %195 = phi i32 [ %178, %180 ], [ %188, %190 ]
  %196 = phi ptr [ %183, %180 ], [ %187, %190 ]
  %197 = sub i32 %194, %195
  %198 = icmp ugt i32 %160, %197
  br i1 %198, label %895, label %199

199:                                              ; preds = %193
  %200 = add i32 %195, %160
  br label %201

201:                                              ; preds = %206, %199
  %202 = phi i32 [ %208, %206 ], [ %195, %199 ]
  %203 = icmp ult i32 %202, %200
  br i1 %203, label %206, label %204

204:                                              ; preds = %201
  %205 = load i32, ptr %196, align 4, !tbaa !52
  br label %213

206:                                              ; preds = %201
  %207 = inttoptr i32 %202 to ptr
  store volatile i8 0, ptr %207, align 1, !tbaa !3
  %208 = add nuw i32 %202, 1
  br label %201, !llvm.loop !54

209:                                              ; preds = %186
  %210 = sub nsw i32 0, %160
  %211 = sub i32 %188, %162
  %212 = icmp ult i32 %211, %210
  br i1 %212, label %895, label %213

213:                                              ; preds = %209, %204
  %214 = phi i32 [ %195, %204 ], [ %188, %209 ]
  %215 = phi ptr [ %196, %204 ], [ %187, %209 ]
  %216 = phi i32 [ %205, %204 ], [ %188, %209 ]
  %217 = add i32 %216, %160
  store i32 %217, ptr %215, align 4, !tbaa !52
  %218 = getelementptr inbounds nuw i8, ptr %5, i32 56
  br label %219

219:                                              ; preds = %253, %213
  %220 = phi ptr [ %5, %213 ], [ %228, %253 ]
  %221 = ptrtoint ptr %220 to i32
  %222 = sub i32 %221, ptrtoint (ptr @proc to i32)
  %223 = sdiv exact i32 %222, 72
  br label %224

224:                                              ; preds = %235, %219
  %225 = phi i32 [ 0, %219 ], [ %236, %235 ]
  %226 = icmp eq i32 %225, 8
  br i1 %226, label %895, label %227

227:                                              ; preds = %224
  %228 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %225
  %229 = load i32, ptr %228, align 4, !tbaa !14
  %230 = icmp eq i32 %229, 2
  br i1 %230, label %231, label %235

231:                                              ; preds = %227
  %232 = getelementptr inbounds nuw i8, ptr %228, i32 12
  %233 = load i32, ptr %232, align 4, !tbaa !18
  %234 = icmp eq i32 %233, %221
  br i1 %234, label %237, label %235

235:                                              ; preds = %231, %227
  %236 = add nuw nsw i32 %225, 1
  br label %224, !llvm.loop !55

237:                                              ; preds = %231
  %238 = getelementptr inbounds nuw i8, ptr %228, i32 52
  %239 = load i32, ptr %238, align 4, !tbaa !51
  %240 = load i32, ptr %161, align 4, !tbaa !51
  %241 = icmp eq i32 %239, %240
  br i1 %241, label %247, label %242

242:                                              ; preds = %237
  store i32 %240, ptr %238, align 4, !tbaa !51
  %243 = load i32, ptr %218, align 4, !tbaa !53
  %244 = getelementptr inbounds nuw i8, ptr %228, i32 56
  store i32 %243, ptr %244, align 4, !tbaa !53
  %245 = load i32, ptr %161, align 4, !tbaa !51
  %246 = getelementptr inbounds nuw i8, ptr %228, i32 60
  store i32 %245, ptr %246, align 4, !tbaa !52
  br label %247

247:                                              ; preds = %242, %237
  %248 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %223
  %249 = load i32, ptr %248, align 4, !tbaa !9
  %250 = icmp eq i32 %249, 0
  br i1 %250, label %253, label %251

251:                                              ; preds = %247
  %252 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %225
  store i32 %249, ptr %252, align 4, !tbaa !9
  store i32 0, ptr %248, align 4, !tbaa !9
  br label %253

253:                                              ; preds = %251, %247
  br label %219, !llvm.loop !56

254:                                              ; preds = %10
  %255 = load i32, ptr @ticks, align 4, !tbaa !9
  %256 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %257 = load volatile i32, ptr %256, align 4, !tbaa !45
  %258 = add i32 %257, %255
  %259 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %258, ptr %259, align 4, !tbaa !41
  %260 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %261 = load i32, ptr %260, align 4, !tbaa !35
  %262 = inttoptr i32 %261 to ptr
  %263 = load volatile i32, ptr %262, align 4, !tbaa !9
  %264 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %263, ptr %264, align 4, !tbaa !36
  %265 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %265, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %916

266:                                              ; preds = %17, %285
  %267 = phi i32 [ %288, %285 ], [ 0, %17 ]
  %268 = phi i32 [ %286, %285 ], [ -1, %17 ]
  %269 = phi i32 [ %287, %285 ], [ 0, %17 ]
  %270 = icmp eq i32 %267, 8
  br i1 %270, label %271, label %273

271:                                              ; preds = %266
  %272 = icmp sgt i32 %268, -1
  br i1 %272, label %289, label %302

273:                                              ; preds = %266
  %274 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %267
  %275 = load i32, ptr %274, align 4, !tbaa !14
  %276 = icmp eq i32 %275, 0
  br i1 %276, label %285, label %277

277:                                              ; preds = %273
  %278 = getelementptr inbounds nuw i8, ptr %274, i32 8
  %279 = load i32, ptr %278, align 4, !tbaa !19
  %280 = load i32, ptr %18, align 4, !tbaa !16
  %281 = icmp eq i32 %279, %280
  br i1 %281, label %282, label %285

282:                                              ; preds = %277
  %283 = icmp eq i32 %275, 5
  %284 = select i1 %283, i32 %267, i32 %268
  br label %285

285:                                              ; preds = %282, %273, %277
  %286 = phi i32 [ %268, %277 ], [ %268, %273 ], [ %284, %282 ]
  %287 = phi i32 [ %269, %277 ], [ %269, %273 ], [ 1, %282 ]
  %288 = add nuw nsw i32 %267, 1
  br label %266, !llvm.loop !57

289:                                              ; preds = %271
  %290 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %291 = load volatile i32, ptr %290, align 4, !tbaa !45
  %292 = icmp eq i32 %291, 0
  br i1 %292, label %298, label %293

293:                                              ; preds = %289
  %294 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %268, i32 5
  %295 = load i32, ptr %294, align 4, !tbaa !43
  %296 = load volatile i32, ptr %290, align 4, !tbaa !45
  %297 = inttoptr i32 %296 to ptr
  store volatile i32 %295, ptr %297, align 4, !tbaa !9
  br label %298

298:                                              ; preds = %293, %289
  %299 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %268
  %300 = getelementptr inbounds nuw i8, ptr %299, i32 4
  %301 = load i32, ptr %300, align 4, !tbaa !16
  store i32 0, ptr %299, align 4, !tbaa !14
  br label %895

302:                                              ; preds = %271
  %303 = icmp eq i32 %269, 0
  br i1 %303, label %895, label %304

304:                                              ; preds = %302
  %305 = ptrtoint ptr %5 to i32
  %306 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %307 = load i32, ptr %306, align 4, !tbaa !35
  %308 = inttoptr i32 %307 to ptr
  %309 = load volatile i32, ptr %308, align 4, !tbaa !9
  %310 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %309, ptr %310, align 4, !tbaa !36
  %311 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %305, ptr %311, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  %312 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %313 = load volatile i32, ptr %312, align 4, !tbaa !28
  br label %916

314:                                              ; preds = %10, %321
  %315 = phi i32 [ %322, %321 ], [ 0, %10 ]
  %316 = icmp eq i32 %315, 8
  br i1 %316, label %895, label %317

317:                                              ; preds = %314
  %318 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %315
  %319 = load i32, ptr %318, align 4, !tbaa !14
  %320 = icmp eq i32 %319, 0
  br i1 %320, label %323, label %321

321:                                              ; preds = %317
  %322 = add nuw nsw i32 %315, 1
  br label %314, !llvm.loop !58

323:                                              ; preds = %317
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %318, ptr noundef nonnull align 4 dereferenceable(72) %5, i32 72, i1 false), !tbaa.struct !59
  %324 = load i32, ptr @fsready, align 4, !tbaa !9
  %325 = icmp eq i32 %324, 0
  br i1 %325, label %327, label %326

326:                                              ; preds = %323
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %315) #12
  br label %327

327:                                              ; preds = %326, %323
  %328 = load i32, ptr @nextpid, align 4, !tbaa !9
  %329 = add i32 %328, 1
  store i32 %329, ptr @nextpid, align 4, !tbaa !9
  %330 = getelementptr inbounds nuw i8, ptr %318, i32 4
  store i32 %328, ptr %330, align 4, !tbaa !16
  %331 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %332 = load i32, ptr %331, align 4, !tbaa !16
  %333 = getelementptr inbounds nuw i8, ptr %318, i32 8
  store i32 %332, ptr %333, align 4, !tbaa !19
  %334 = getelementptr inbounds nuw i8, ptr %318, i32 12
  store i32 0, ptr %334, align 4, !tbaa !18
  store i32 3, ptr %318, align 4, !tbaa !14
  %335 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %336 = load i32, ptr %335, align 4, !tbaa !35
  %337 = inttoptr i32 %336 to ptr
  %338 = load volatile i32, ptr %337, align 4, !tbaa !9
  %339 = getelementptr inbounds nuw i8, ptr %318, i32 40
  store i32 %338, ptr %339, align 4, !tbaa !36
  %340 = load volatile i32, ptr %337, align 4, !tbaa !9
  %341 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %340, ptr %341, align 4, !tbaa !36
  %342 = ptrtoint ptr %318 to i32
  %343 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %342, ptr %343, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %916

344:                                              ; preds = %10
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #13
  %345 = load i32, ptr @fsready, align 4, !tbaa !9
  %346 = icmp eq i32 %345, 0
  br i1 %346, label %442, label %347

347:                                              ; preds = %344
  %348 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %349 = load volatile i32, ptr %348, align 4, !tbaa !45
  %350 = inttoptr i32 %349 to ptr
  %351 = tail call i32 @kfs_iopen(ptr noundef %350) #12
  %352 = icmp eq i32 %351, 0
  br i1 %352, label %442, label %353

353:                                              ; preds = %347
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #13
  %354 = ptrtoint ptr %2 to i32
  %355 = call i32 @kfs_iread(i32 noundef %351, i32 noundef 0, i32 noundef %354, i32 noundef 52) #12
  %356 = icmp eq i32 %355, 52
  %357 = load i32, ptr %2, align 4
  %358 = icmp eq i32 %357, 1480674628
  %359 = select i1 %356, i1 %358, i1 false
  br i1 %359, label %360, label %440

360:                                              ; preds = %353
  %361 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %362 = load i32, ptr %361, align 4, !tbaa !9
  %363 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %364 = load i32, ptr %363, align 4, !tbaa !9
  %365 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %366 = load i32, ptr %365, align 4, !tbaa !9
  %367 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %368 = load i32, ptr %367, align 4, !tbaa !9
  %369 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %370 = load i32, ptr %369, align 4, !tbaa !9
  %371 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %372 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %373 = load i32, ptr %372, align 4, !tbaa !9
  %374 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %373, ptr %374, align 4, !tbaa !60
  %375 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %376 = load i32, ptr %375, align 4, !tbaa !9
  %377 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %376, ptr %377, align 4, !tbaa !62
  %378 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %379 = load i32, ptr %378, align 4, !tbaa !9
  %380 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %379, ptr %380, align 4, !tbaa !63
  %381 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %382 = load i32, ptr %381, align 4, !tbaa !9
  %383 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %382, ptr %383, align 4, !tbaa !64
  %384 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %385 = load i32, ptr %384, align 4, !tbaa !9
  %386 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %385, ptr %386, align 4, !tbaa !65
  %387 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %388 = load i32, ptr %387, align 4, !tbaa !9
  %389 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %388, ptr %389, align 4, !tbaa !66
  %390 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %391 = load i32, ptr %390, align 4, !tbaa !9
  %392 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %391, ptr %392, align 4, !tbaa !67
  %393 = call fastcc i32 @kalloc(i32 noundef %362) #11
  %394 = call fastcc i32 @kalloc(i32 noundef %364) #11
  %395 = add i32 %362, 52
  %396 = add i32 %364, %395
  %397 = icmp ne i32 %393, 0
  %398 = icmp ne i32 %394, 0
  %399 = select i1 %397, i1 %398, i1 false
  br i1 %399, label %400, label %406

400:                                              ; preds = %360
  %401 = call i32 @kfs_iread(i32 noundef %351, i32 noundef 52, i32 noundef %393, i32 noundef %362) #12
  %402 = icmp eq i32 %401, %362
  br i1 %402, label %403, label %406

403:                                              ; preds = %400
  %404 = call i32 @kfs_iread(i32 noundef %351, i32 noundef %395, i32 noundef %394, i32 noundef %364) #12
  %405 = icmp eq i32 %404, %364
  br i1 %405, label %407, label %406

406:                                              ; preds = %403, %400, %360
  call fastcc void @kfree(i32 noundef %393) #11
  call fastcc void @kfree(i32 noundef %394) #11
  br label %440

407:                                              ; preds = %403
  %408 = sub i32 %393, %366
  %409 = sub i32 %394, %368
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #13
  %410 = ptrtoint ptr %3 to i32
  br label %411

411:                                              ; preds = %437, %407
  %412 = phi i32 [ %396, %407 ], [ %439, %437 ]
  %413 = phi i32 [ %370, %407 ], [ %438, %437 ]
  %414 = icmp eq i32 %413, 0
  br i1 %414, label %441, label %415

415:                                              ; preds = %411
  %416 = call i32 @llvm.umin.i32(i32 %413, i32 64)
  %417 = shl nuw nsw i32 %416, 2
  %418 = call i32 @kfs_iread(i32 noundef %351, i32 noundef %412, i32 noundef %410, i32 noundef %417) #12
  %419 = icmp eq i32 %418, %417
  br i1 %419, label %420, label %441

420:                                              ; preds = %415, %423
  %421 = phi i32 [ %436, %423 ], [ 0, %415 ]
  %422 = icmp eq i32 %421, %416
  br i1 %422, label %437, label %423

423:                                              ; preds = %420
  %424 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %421
  %425 = load i32, ptr %424, align 4, !tbaa !9
  %426 = icmp slt i32 %425, 0
  %427 = select i1 %426, i32 %394, i32 %393
  %428 = and i32 %425, 1073741823
  %429 = add i32 %427, %428
  %430 = and i32 %425, 1073741824
  %431 = icmp eq i32 %430, 0
  %432 = select i1 %431, i32 %408, i32 %409
  %433 = inttoptr i32 %429 to ptr
  %434 = load volatile i32, ptr %433, align 4, !tbaa !9
  %435 = add i32 %432, %434
  store volatile i32 %435, ptr %433, align 4, !tbaa !9
  %436 = add nuw nsw i32 %421, 1
  br label %420, !llvm.loop !68

437:                                              ; preds = %420
  %438 = sub i32 %413, %416
  %439 = add i32 %417, %412
  br label %411

440:                                              ; preds = %353, %406
  call void @kfs_iclose(i32 noundef %351) #12
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #13
  br label %622

441:                                              ; preds = %415, %411
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #13
  call void @kfs_iclose(i32 noundef %351) #12
  store i32 0, ptr %371, align 4, !tbaa !69
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #13
  br label %520

442:                                              ; preds = %344, %347
  %443 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %444 = load volatile i32, ptr %443, align 4, !tbaa !45
  %445 = inttoptr i32 %444 to ptr
  br label %446

446:                                              ; preds = %465, %442
  %447 = phi i32 [ 0, %442 ], [ %466, %465 ]
  %448 = icmp eq i32 %447, 24
  br i1 %448, label %622, label %449

449:                                              ; preds = %446
  %450 = getelementptr inbounds nuw [24 x %struct.kimg], ptr @kimages, i32 0, i32 %447
  %451 = load i8, ptr %450, align 4, !tbaa !3
  %452 = icmp eq i8 %451, 0
  br i1 %452, label %622, label %453

453:                                              ; preds = %449, %462
  %454 = phi i32 [ %464, %462 ], [ 0, %449 ]
  %455 = icmp eq i32 %454, 12
  br i1 %455, label %467, label %456

456:                                              ; preds = %453
  %457 = getelementptr inbounds nuw [12 x i8], ptr %450, i32 0, i32 %454
  %458 = load i8, ptr %457, align 1, !tbaa !3
  %459 = getelementptr inbounds nuw i8, ptr %445, i32 %454
  %460 = load i8, ptr %459, align 1, !tbaa !3
  %461 = icmp eq i8 %458, %460
  br i1 %461, label %462, label %465

462:                                              ; preds = %456
  %463 = icmp eq i8 %458, 0
  %464 = add nuw nsw i32 %454, 1
  br i1 %463, label %467, label %453, !llvm.loop !70

465:                                              ; preds = %456
  %466 = add nuw nsw i32 %447, 1
  br label %446, !llvm.loop !71

467:                                              ; preds = %462, %453
  %468 = getelementptr inbounds nuw i8, ptr %450, i32 16
  %469 = load i32, ptr %468, align 4, !tbaa !72
  %470 = tail call fastcc i32 @kalloc(i32 noundef %469) #11
  %471 = getelementptr inbounds nuw i8, ptr %450, i32 24
  %472 = load i32, ptr %471, align 4, !tbaa !73
  %473 = tail call fastcc i32 @kalloc(i32 noundef %472) #11
  %474 = icmp ne i32 %470, 0
  %475 = icmp ne i32 %473, 0
  %476 = select i1 %474, i1 %475, i1 false
  br i1 %476, label %478, label %477

477:                                              ; preds = %467
  tail call fastcc void @kfree(i32 noundef %470) #11
  tail call fastcc void @kfree(i32 noundef %473) #11
  br label %622

478:                                              ; preds = %467
  %479 = getelementptr inbounds nuw i8, ptr %450, i32 12
  %480 = load i32, ptr %479, align 4, !tbaa !74
  %481 = inttoptr i32 %480 to ptr
  %482 = inttoptr i32 %470 to ptr
  br label %483

483:                                              ; preds = %494, %478
  %484 = phi ptr [ %481, %478 ], [ %495, %494 ]
  %485 = phi ptr [ %482, %478 ], [ %497, %494 ]
  %486 = phi i32 [ 0, %478 ], [ %498, %494 ]
  %487 = load i32, ptr %468, align 4, !tbaa !72
  %488 = icmp ult i32 %486, %487
  br i1 %488, label %494, label %489

489:                                              ; preds = %483
  %490 = getelementptr inbounds nuw i8, ptr %450, i32 20
  %491 = load i32, ptr %490, align 4, !tbaa !75
  %492 = inttoptr i32 %491 to ptr
  %493 = inttoptr i32 %473 to ptr
  br label %499

494:                                              ; preds = %483
  %495 = getelementptr inbounds nuw i8, ptr %484, i32 4
  %496 = load i32, ptr %484, align 4, !tbaa !9
  %497 = getelementptr inbounds nuw i8, ptr %485, i32 4
  store i32 %496, ptr %485, align 4, !tbaa !9
  %498 = add i32 %486, 4
  br label %483, !llvm.loop !76

499:                                              ; preds = %505, %489
  %500 = phi ptr [ %492, %489 ], [ %506, %505 ]
  %501 = phi ptr [ %493, %489 ], [ %508, %505 ]
  %502 = phi i32 [ 0, %489 ], [ %509, %505 ]
  %503 = load i32, ptr %471, align 4, !tbaa !73
  %504 = icmp ult i32 %502, %503
  br i1 %504, label %505, label %510

505:                                              ; preds = %499
  %506 = getelementptr inbounds nuw i8, ptr %500, i32 4
  %507 = load i32, ptr %500, align 4, !tbaa !9
  %508 = getelementptr inbounds nuw i8, ptr %501, i32 4
  store i32 %507, ptr %501, align 4, !tbaa !9
  %509 = add i32 %502, 4
  br label %499, !llvm.loop !77

510:                                              ; preds = %499
  %511 = getelementptr inbounds nuw i8, ptr %450, i32 28
  %512 = load i32, ptr %511, align 4, !tbaa !78
  %513 = getelementptr inbounds nuw i8, ptr %450, i32 32
  %514 = load i32, ptr %513, align 4, !tbaa !79
  %515 = getelementptr inbounds nuw i8, ptr %450, i32 36
  %516 = load i32, ptr %515, align 4, !tbaa !80
  %517 = sub i32 %470, %512
  %518 = sub i32 %473, %514
  %519 = inttoptr i32 %516 to ptr
  br label %520

520:                                              ; preds = %510, %441
  %521 = phi i32 [ %518, %510 ], [ %409, %441 ]
  %522 = phi i32 [ %517, %510 ], [ %408, %441 ]
  %523 = phi ptr [ %519, %510 ], [ null, %441 ]
  %524 = phi i32 [ %473, %510 ], [ %394, %441 ]
  %525 = phi i32 [ %470, %510 ], [ %393, %441 ]
  %526 = phi ptr [ %450, %510 ], [ %1, %441 ]
  %527 = getelementptr inbounds nuw i8, ptr %526, i32 40
  br label %528

528:                                              ; preds = %567, %520
  %529 = phi i32 [ 0, %520 ], [ %580, %567 ]
  %530 = load i32, ptr %527, align 4, !tbaa !69
  %531 = icmp ult i32 %529, %530
  br i1 %531, label %567, label %532

532:                                              ; preds = %528
  %533 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %534 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %535 = getelementptr inbounds nuw i8, ptr %5, i32 60
  br label %536

536:                                              ; preds = %552, %532
  %537 = phi ptr [ %5, %532 ], [ %543, %552 ]
  %538 = ptrtoint ptr %537 to i32
  br label %539

539:                                              ; preds = %550, %536
  %540 = phi i32 [ 0, %536 ], [ %551, %550 ]
  %541 = icmp eq i32 %540, 8
  br i1 %541, label %559, label %542

542:                                              ; preds = %539
  %543 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %540
  %544 = load i32, ptr %543, align 4, !tbaa !14
  %545 = icmp eq i32 %544, 2
  br i1 %545, label %546, label %550

546:                                              ; preds = %542
  %547 = getelementptr inbounds nuw i8, ptr %543, i32 12
  %548 = load i32, ptr %547, align 4, !tbaa !18
  %549 = icmp eq i32 %548, %538
  br i1 %549, label %552, label %550

550:                                              ; preds = %546, %542
  %551 = add nuw nsw i32 %540, 1
  br label %539, !llvm.loop !81

552:                                              ; preds = %546
  %553 = load i32, ptr %533, align 4, !tbaa !51
  %554 = getelementptr inbounds nuw i8, ptr %543, i32 52
  store i32 %553, ptr %554, align 4, !tbaa !51
  %555 = load i32, ptr %534, align 4, !tbaa !53
  %556 = getelementptr inbounds nuw i8, ptr %543, i32 56
  store i32 %555, ptr %556, align 4, !tbaa !53
  %557 = load i32, ptr %535, align 4, !tbaa !52
  %558 = getelementptr inbounds nuw i8, ptr %543, i32 60
  store i32 %557, ptr %558, align 4, !tbaa !52
  br label %536, !llvm.loop !82

559:                                              ; preds = %539
  %560 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %560) #11
  %561 = load i32, ptr @curr, align 4, !tbaa !9
  %562 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %561
  store i32 %525, ptr %562, align 4, !tbaa !9
  %563 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %561, i32 1
  store i32 %524, ptr %563, align 4, !tbaa !9
  %564 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %565 = load volatile i32, ptr %564, align 4, !tbaa !49
  %566 = icmp eq i32 %565, 0
  br i1 %566, label %623, label %581

567:                                              ; preds = %528
  %568 = getelementptr inbounds nuw i32, ptr %523, i32 %529
  %569 = load i32, ptr %568, align 4, !tbaa !9
  %570 = icmp slt i32 %569, 0
  %571 = select i1 %570, i32 %524, i32 %525
  %572 = and i32 %569, 1073741823
  %573 = add i32 %571, %572
  %574 = and i32 %569, 1073741824
  %575 = icmp eq i32 %574, 0
  %576 = select i1 %575, i32 %522, i32 %521
  %577 = inttoptr i32 %573 to ptr
  %578 = load volatile i32, ptr %577, align 4, !tbaa !9
  %579 = add i32 %576, %578
  store volatile i32 %579, ptr %577, align 4, !tbaa !9
  %580 = add nuw i32 %529, 1
  br label %528, !llvm.loop !83

581:                                              ; preds = %559
  %582 = call fastcc i32 @kalloc(i32 noundef 256) #11
  %583 = icmp eq i32 %582, 0
  br i1 %583, label %623, label %584

584:                                              ; preds = %581
  %585 = load volatile i32, ptr %564, align 4, !tbaa !49
  %586 = inttoptr i32 %585 to ptr
  %587 = inttoptr i32 %582 to ptr
  %588 = add i32 %582, 64
  %589 = inttoptr i32 %588 to ptr
  %590 = add i32 %582, 256
  %591 = inttoptr i32 %590 to ptr
  %592 = getelementptr inbounds i8, ptr %591, i32 -1
  br label %593

593:                                              ; preds = %615, %584
  %594 = phi i32 [ 0, %584 ], [ %617, %615 ]
  %595 = phi ptr [ %589, %584 ], [ %616, %615 ]
  %596 = icmp eq i32 %594, 15
  br i1 %596, label %618, label %597

597:                                              ; preds = %593
  %598 = getelementptr inbounds nuw i32, ptr %586, i32 %594
  %599 = load i32, ptr %598, align 4, !tbaa !9
  %600 = icmp eq i32 %599, 0
  br i1 %600, label %618, label %601

601:                                              ; preds = %597
  %602 = inttoptr i32 %599 to ptr
  %603 = ptrtoint ptr %595 to i32
  %604 = getelementptr inbounds nuw i32, ptr %587, i32 %594
  store i32 %603, ptr %604, align 4, !tbaa !9
  br label %605

605:                                              ; preds = %612, %601
  %606 = phi ptr [ %595, %601 ], [ %614, %612 ]
  %607 = phi ptr [ %602, %601 ], [ %613, %612 ]
  %608 = load i8, ptr %607, align 1, !tbaa !3
  %609 = icmp ne i8 %608, 0
  %610 = icmp ult ptr %606, %592
  %611 = select i1 %609, i1 %610, i1 false
  br i1 %611, label %612, label %615

612:                                              ; preds = %605
  %613 = getelementptr inbounds nuw i8, ptr %607, i32 1
  %614 = getelementptr inbounds nuw i8, ptr %606, i32 1
  store i8 %608, ptr %606, align 1, !tbaa !3
  br label %605, !llvm.loop !84

615:                                              ; preds = %605
  %616 = getelementptr inbounds nuw i8, ptr %606, i32 1
  store i8 0, ptr %606, align 1, !tbaa !3
  %617 = add nuw nsw i32 %594, 1
  br label %593, !llvm.loop !85

618:                                              ; preds = %593, %597
  %619 = getelementptr inbounds nuw i32, ptr %587, i32 %594
  store i32 0, ptr %619, align 4, !tbaa !9
  %620 = load i32, ptr @curr, align 4, !tbaa !9
  %621 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %620, i32 2
  store i32 %582, ptr %621, align 4, !tbaa !9
  br label %623

622:                                              ; preds = %446, %449, %477, %440
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #13
  br label %895

623:                                              ; preds = %559, %618, %581
  %624 = phi i32 [ 0, %559 ], [ %594, %618 ], [ 0, %581 ]
  %625 = phi i32 [ 0, %559 ], [ %582, %618 ], [ 0, %581 ]
  %626 = getelementptr inbounds nuw i8, ptr %526, i32 52
  %627 = load i32, ptr %626, align 4, !tbaa !63
  %628 = add i32 %627, %524
  %629 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %628, ptr %629, align 4, !tbaa !31
  %630 = getelementptr inbounds nuw i8, ptr %526, i32 56
  %631 = load i32, ptr %630, align 4, !tbaa !64
  %632 = add i32 %631, %524
  %633 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %632, ptr %633, align 4, !tbaa !86
  %634 = getelementptr inbounds nuw i8, ptr %526, i32 60
  %635 = load i32, ptr %634, align 4, !tbaa !65
  %636 = add i32 %635, %524
  %637 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %636, ptr %637, align 4, !tbaa !35
  %638 = getelementptr inbounds nuw i8, ptr %526, i32 48
  %639 = load i32, ptr %638, align 4, !tbaa !62
  %640 = add i32 %639, %525
  %641 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %640, ptr %641, align 4, !tbaa !40
  %642 = getelementptr inbounds nuw i8, ptr %526, i32 64
  %643 = load i32, ptr %642, align 4, !tbaa !66
  %644 = add i32 %643, %524
  store i32 %644, ptr %11, align 4, !tbaa !27
  %645 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %646 = getelementptr inbounds nuw i8, ptr %526, i32 68
  %647 = load i32, ptr %646, align 4, !tbaa !67
  %648 = add i32 %647, %524
  %649 = inttoptr i32 %648 to ptr
  store volatile i32 %645, ptr %649, align 4, !tbaa !9
  %650 = load i32, ptr %641, align 4, !tbaa !40
  %651 = load i32, ptr %629, align 4, !tbaa !31
  %652 = inttoptr i32 %651 to ptr
  store volatile i32 %650, ptr %652, align 4, !tbaa !9
  %653 = load i32, ptr %626, align 4, !tbaa !63
  %654 = add i32 %653, %524
  %655 = add i32 %654, -84
  %656 = inttoptr i32 %655 to ptr
  store volatile i32 %624, ptr %656, align 4, !tbaa !9
  %657 = add i32 %654, -80
  %658 = inttoptr i32 %657 to ptr
  store volatile i32 %625, ptr %658, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #11
  store i32 4, ptr %5, align 4, !tbaa !14
  %659 = load i32, ptr @curr, align 4, !tbaa !9
  %660 = getelementptr inbounds nuw i8, ptr %526, i32 44
  %661 = load i32, ptr %660, align 4, !tbaa !60
  %662 = add i32 %661, %525
  call fastcc void @kexit(i32 noundef %659, i32 noundef %662) #11
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #13
  br label %927

663:                                              ; preds = %10
  %664 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %665 = load volatile i32, ptr %664, align 4, !tbaa !45
  br label %910

666:                                              ; preds = %10
  %667 = load i32, ptr @fsready, align 4, !tbaa !9
  %668 = icmp eq i32 %667, 0
  br i1 %668, label %895, label %669

669:                                              ; preds = %666
  %670 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %671 = load volatile i32, ptr %670, align 4, !tbaa !45
  %672 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %673 = load volatile i32, ptr %672, align 4, !tbaa !49
  %674 = tail call i32 @kfs_mount(i32 noundef %671, i32 noundef %673) #12
  br label %895

675:                                              ; preds = %10
  %676 = load i32, ptr @fsready, align 4, !tbaa !9
  %677 = icmp eq i32 %676, 0
  br i1 %677, label %895, label %678

678:                                              ; preds = %675
  %679 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %680 = load volatile i32, ptr %679, align 4, !tbaa !45
  %681 = tail call i32 @kfs_umount(i32 noundef %680) #12
  br label %895

682:                                              ; preds = %10
  %683 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %684 = load volatile i32, ptr %683, align 4, !tbaa !45
  %685 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %686 = load i32, ptr %685, align 4, !tbaa !53
  %687 = icmp ult i32 %684, %686
  br i1 %687, label %688, label %695

688:                                              ; preds = %682
  %689 = add i32 %684, 32
  %690 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %691 = load i32, ptr %690, align 4, !tbaa !52
  %692 = icmp ugt i32 %689, %691
  br i1 %692, label %693, label %695

693:                                              ; preds = %688
  %694 = icmp ugt i32 %684, -33
  br i1 %694, label %695, label %895

695:                                              ; preds = %682, %688, %693
  %696 = load volatile i32, ptr %683, align 4, !tbaa !45
  %697 = inttoptr i32 %696 to ptr
  %698 = load i32, ptr @arena_end, align 4, !tbaa !9
  %699 = load i32, ptr @arena, align 4, !tbaa !9
  %700 = sub i32 %698, %699
  store i32 %700, ptr %697, align 4, !tbaa !9
  %701 = getelementptr inbounds nuw i8, ptr %697, i32 4
  store i32 0, ptr %701, align 4, !tbaa !9
  %702 = getelementptr inbounds nuw i8, ptr %697, i32 8
  store i32 0, ptr %702, align 4, !tbaa !9
  %703 = load i1, ptr @kheap_init, align 4
  br i1 %703, label %705, label %704

704:                                              ; preds = %695
  store i32 %700, ptr %702, align 4, !tbaa !9
  store i32 %700, ptr %701, align 4, !tbaa !9
  br label %720

705:                                              ; preds = %695, %717
  %706 = phi i32 [ %718, %717 ], [ 0, %695 ]
  %707 = phi i32 [ %713, %717 ], [ 0, %695 ]
  %708 = phi ptr [ %719, %717 ], [ @kfreelist, %695 ]
  %709 = load ptr, ptr %708, align 4, !tbaa !87
  %710 = icmp eq ptr %709, null
  br i1 %710, label %720, label %711

711:                                              ; preds = %705
  %712 = load i32, ptr %709, align 4, !tbaa !89
  %713 = add i32 %707, %712
  store i32 %713, ptr %701, align 4, !tbaa !9
  %714 = load i32, ptr %709, align 4, !tbaa !89
  %715 = icmp ugt i32 %714, %706
  br i1 %715, label %716, label %717

716:                                              ; preds = %711
  store i32 %714, ptr %702, align 4, !tbaa !9
  br label %717

717:                                              ; preds = %711, %716
  %718 = phi i32 [ %706, %711 ], [ %714, %716 ]
  %719 = getelementptr inbounds nuw i8, ptr %709, i32 4
  br label %705, !llvm.loop !91

720:                                              ; preds = %705, %704
  %721 = getelementptr inbounds nuw i8, ptr %697, i32 20
  store i32 0, ptr %721, align 4, !tbaa !9
  %722 = getelementptr inbounds nuw i8, ptr %697, i32 16
  store i32 0, ptr %722, align 4, !tbaa !9
  %723 = getelementptr inbounds nuw i8, ptr %697, i32 12
  store i32 0, ptr %723, align 4, !tbaa !9
  br label %724

724:                                              ; preds = %767, %720
  %725 = phi i32 [ 0, %720 ], [ %746, %767 ]
  %726 = phi i32 [ 0, %720 ], [ %768, %767 ]
  %727 = phi i32 [ 0, %720 ], [ %744, %767 ]
  %728 = phi i32 [ 0, %720 ], [ %769, %767 ]
  %729 = icmp eq i32 %728, 8
  br i1 %729, label %730, label %734

730:                                              ; preds = %724
  %731 = getelementptr inbounds nuw i8, ptr %697, i32 24
  store i32 8, ptr %731, align 4, !tbaa !9
  %732 = load i32, ptr @ticks, align 4, !tbaa !9
  %733 = getelementptr inbounds nuw i8, ptr %697, i32 28
  store i32 %732, ptr %733, align 4, !tbaa !9
  br label %895

734:                                              ; preds = %724
  %735 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %728
  %736 = load i32, ptr %735, align 4, !tbaa !9
  %737 = icmp eq i32 %736, 0
  br i1 %737, label %743, label %738

738:                                              ; preds = %734
  %739 = add i32 %736, -256
  %740 = inttoptr i32 %739 to ptr
  %741 = load volatile i32, ptr %740, align 4, !tbaa !9
  %742 = add i32 %727, %741
  store i32 %742, ptr %723, align 4, !tbaa !9
  br label %743

743:                                              ; preds = %738, %734
  %744 = phi i32 [ %742, %738 ], [ %727, %734 ]
  br label %745

745:                                              ; preds = %762, %743
  %746 = phi i32 [ %725, %743 ], [ %763, %762 ]
  %747 = phi i32 [ 0, %743 ], [ %764, %762 ]
  %748 = icmp eq i32 %747, 3
  br i1 %748, label %749, label %753

749:                                              ; preds = %745
  %750 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %728
  %751 = load i32, ptr %750, align 4, !tbaa !14
  %752 = icmp eq i32 %751, 0
  br i1 %752, label %767, label %765

753:                                              ; preds = %745
  %754 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %728, i32 %747
  %755 = load i32, ptr %754, align 4, !tbaa !9
  %756 = icmp eq i32 %755, 0
  br i1 %756, label %762, label %757

757:                                              ; preds = %753
  %758 = add i32 %755, -256
  %759 = inttoptr i32 %758 to ptr
  %760 = load volatile i32, ptr %759, align 4, !tbaa !9
  %761 = add i32 %746, %760
  store i32 %761, ptr %722, align 4, !tbaa !9
  br label %762

762:                                              ; preds = %753, %757
  %763 = phi i32 [ %746, %753 ], [ %761, %757 ]
  %764 = add nuw nsw i32 %747, 1
  br label %745, !llvm.loop !92

765:                                              ; preds = %749
  %766 = add i32 %726, 1
  store i32 %766, ptr %721, align 4, !tbaa !9
  br label %767

767:                                              ; preds = %749, %765
  %768 = phi i32 [ %726, %749 ], [ %766, %765 ]
  %769 = add nuw nsw i32 %728, 1
  br label %724, !llvm.loop !93

770:                                              ; preds = %10
  %771 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %772 = load volatile i32, ptr %771, align 4, !tbaa !45
  %773 = icmp eq i32 %772, 0
  br i1 %773, label %778, label %774

774:                                              ; preds = %770
  store i1 true, ptr @cons_raw, align 4
  %775 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %776 = load i32, ptr %775, align 4, !tbaa !16
  store i32 %776, ptr @cons_raw_pid, align 4, !tbaa !9
  %777 = load i32, ptr @cons_e, align 4, !tbaa !9
  store i32 %777, ptr @cons_w, align 4, !tbaa !9
  br label %895

778:                                              ; preds = %770
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !9
  br label %895

779:                                              ; preds = %10
  %780 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %781 = load volatile i32, ptr %780, align 4, !tbaa !45
  %782 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %783 = load volatile i32, ptr %782, align 4, !tbaa !49
  %784 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %785 = load volatile i32, ptr %784, align 4, !tbaa !50
  %786 = tail call i32 @kgpio(i32 noundef %781, i32 noundef %783, i32 noundef %785) #12
  br label %895

787:                                              ; preds = %10
  %788 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %789 = load volatile i32, ptr %788, align 4, !tbaa !45
  %790 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %791 = load volatile i32, ptr %790, align 4, !tbaa !49
  %792 = tail call i32 @kpinmux(i32 noundef %789, i32 noundef %791) #12
  br label %895

793:                                              ; preds = %10
  %794 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %795 = load volatile i32, ptr %794, align 4, !tbaa !45
  %796 = icmp eq i32 %795, 0
  br i1 %796, label %800, label %797

797:                                              ; preds = %793
  %798 = load volatile i32, ptr %794, align 4, !tbaa !45
  %799 = icmp eq i32 %798, 1
  br i1 %799, label %800, label %813

800:                                              ; preds = %797, %793
  %801 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %802 = load volatile i32, ptr %801, align 4, !tbaa !49
  %803 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %804 = load i32, ptr %803, align 4, !tbaa !53
  %805 = icmp ult i32 %802, %804
  br i1 %805, label %806, label %813

806:                                              ; preds = %800
  %807 = add i32 %802, 28
  %808 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %809 = load i32, ptr %808, align 4, !tbaa !52
  %810 = icmp ugt i32 %807, %809
  br i1 %810, label %811, label %813

811:                                              ; preds = %806
  %812 = icmp ugt i32 %802, -29
  br i1 %812, label %813, label %895

813:                                              ; preds = %800, %806, %811, %797
  %814 = load volatile i32, ptr %794, align 4, !tbaa !45
  %815 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %816 = load volatile i32, ptr %815, align 4, !tbaa !49
  %817 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %818 = load volatile i32, ptr %817, align 4, !tbaa !50
  %819 = tail call i32 @kpio(i32 noundef %814, i32 noundef %816, i32 noundef %818) #12
  br label %895

820:                                              ; preds = %10
  %821 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %822 = load volatile i32, ptr %821, align 4, !tbaa !45
  %823 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %824 = load volatile i32, ptr %823, align 4, !tbaa !49
  %825 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %826 = load i32, ptr %825, align 4, !tbaa !16
  %827 = load volatile i32, ptr %821, align 4, !tbaa !45
  %828 = icmp eq i32 %827, 0
  br i1 %828, label %829, label %842

829:                                              ; preds = %820
  %830 = load volatile i32, ptr %823, align 4, !tbaa !49
  %831 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %832 = load i32, ptr %831, align 4, !tbaa !53
  %833 = icmp ult i32 %830, %832
  br i1 %833, label %834, label %842

834:                                              ; preds = %829
  %835 = add i32 %830, 20
  %836 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %837 = load i32, ptr %836, align 4, !tbaa !52
  %838 = icmp ugt i32 %835, %837
  br i1 %838, label %839, label %842

839:                                              ; preds = %834
  %840 = icmp ult i32 %830, -20
  %841 = zext i1 %840 to i32
  br label %842

842:                                              ; preds = %839, %834, %829, %820
  %843 = phi i32 [ 0, %820 ], [ 0, %834 ], [ 0, %829 ], [ %841, %839 ]
  %844 = tail call i32 @kfb_syscall(i32 noundef %822, i32 noundef %824, i32 noundef %826, i32 noundef %843) #12
  br label %895

845:                                              ; preds = %10
  %846 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %847 = load volatile i32, ptr %846, align 4, !tbaa !50
  %848 = getelementptr inbounds nuw i8, ptr %5, i32 64
  store i32 %847, ptr %848, align 4, !tbaa !25
  %849 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %849, align 4, !tbaa !26
  br label %895

850:                                              ; preds = %10
  %851 = getelementptr inbounds nuw i8, ptr %5, i32 64
  %852 = load i32, ptr %851, align 4, !tbaa !25
  %853 = icmp eq i32 %852, 0
  br i1 %853, label %895, label %854

854:                                              ; preds = %850
  %855 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %856 = load i32, ptr %855, align 4, !tbaa !31
  %857 = add i32 %856, -84
  %858 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %858, align 4, !tbaa !26
  %859 = add i32 %852, 8
  %860 = inttoptr i32 %859 to ptr
  %861 = load volatile i32, ptr %860, align 4, !tbaa !9
  %862 = inttoptr i32 %857 to ptr
  store volatile i32 %861, ptr %862, align 4, !tbaa !9
  %863 = add i32 %852, 12
  %864 = inttoptr i32 %863 to ptr
  %865 = load volatile i32, ptr %864, align 4, !tbaa !9
  %866 = add i32 %856, -80
  %867 = inttoptr i32 %866 to ptr
  store volatile i32 %865, ptr %867, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %868 = load i32, ptr @curr, align 4, !tbaa !9
  %869 = add i32 %852, 4
  %870 = inttoptr i32 %869 to ptr
  %871 = load volatile i32, ptr %870, align 4, !tbaa !9
  tail call fastcc void @kexit(i32 noundef %868, i32 noundef %871) #11
  br label %927

872:                                              ; preds = %15, %884
  %873 = phi i32 [ %885, %884 ], [ 0, %15 ]
  %874 = icmp eq i32 %873, 8
  br i1 %874, label %895, label %875

875:                                              ; preds = %872
  %876 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %873
  %877 = load i32, ptr %876, align 4, !tbaa !14
  %878 = icmp eq i32 %877, 0
  br i1 %878, label %884, label %879

879:                                              ; preds = %875
  %880 = getelementptr inbounds nuw i8, ptr %876, i32 4
  %881 = load i32, ptr %880, align 4, !tbaa !16
  %882 = load volatile i32, ptr %16, align 4, !tbaa !45
  %883 = icmp eq i32 %881, %882
  br i1 %883, label %886, label %884

884:                                              ; preds = %875, %879
  %885 = add nuw nsw i32 %873, 1
  br label %872, !llvm.loop !94

886:                                              ; preds = %879
  %887 = icmp eq i32 %877, 5
  br i1 %887, label %895, label %888

888:                                              ; preds = %886
  %889 = icmp eq i32 %873, %4
  br i1 %889, label %910, label %890

890:                                              ; preds = %888
  %891 = icmp eq i32 %877, 2
  br i1 %891, label %892, label %893

892:                                              ; preds = %890
  tail call fastcc void @terminate(ptr noundef nonnull %876, i32 noundef -1) #11
  br label %895

893:                                              ; preds = %890
  %894 = getelementptr inbounds nuw i8, ptr %876, i32 48
  store i32 1, ptr %894, align 4, !tbaa !32
  br label %895

895:                                              ; preds = %872, %314, %224, %134, %24, %10, %19, %22, %132, %693, %730, %779, %787, %813, %842, %845, %49, %52, %58, %61, %65, %68, %72, %75, %81, %84, %90, %93, %97, %100, %104, %107, %111, %114, %120, %123, %298, %302, %666, %669, %675, %678, %778, %774, %811, %886, %893, %892, %850, %45, %154, %164, %176, %193, %209, %622
  %896 = phi i32 [ -1, %622 ], [ -1, %176 ], [ -1, %209 ], [ -1, %193 ], [ -1, %164 ], [ %156, %154 ], [ %47, %45 ], [ -1, %850 ], [ 0, %892 ], [ 0, %893 ], [ -1, %886 ], [ -1, %811 ], [ 0, %774 ], [ 0, %778 ], [ -1, %675 ], [ %681, %678 ], [ -1, %666 ], [ %674, %669 ], [ -1, %302 ], [ %301, %298 ], [ -1, %120 ], [ %126, %123 ], [ -1, %111 ], [ %119, %114 ], [ -1, %104 ], [ %110, %107 ], [ -1, %97 ], [ %103, %100 ], [ -1, %90 ], [ %96, %93 ], [ -1, %81 ], [ %89, %84 ], [ -1, %72 ], [ %80, %75 ], [ -1, %65 ], [ %71, %68 ], [ -1, %58 ], [ %64, %61 ], [ -1, %49 ], [ %57, %52 ], [ 0, %845 ], [ %844, %842 ], [ %819, %813 ], [ %792, %787 ], [ %786, %779 ], [ 0, %730 ], [ -1, %693 ], [ %133, %132 ], [ %23, %22 ], [ %21, %19 ], [ -1, %10 ], [ -1, %24 ], [ -1, %134 ], [ %214, %224 ], [ -1, %314 ], [ -1, %872 ]
  %897 = load i32, ptr %11, align 4, !tbaa !27
  %898 = inttoptr i32 %897 to ptr
  %899 = getelementptr inbounds nuw i8, ptr %898, i32 16
  store volatile i32 %896, ptr %899, align 4, !tbaa !28
  %900 = getelementptr inbounds nuw i8, ptr %898, i32 20
  store volatile i32 1, ptr %900, align 4, !tbaa !30
  %901 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %902 = load i32, ptr %901, align 4, !tbaa !31
  %903 = add i32 %902, -84
  %904 = inttoptr i32 %903 to ptr
  store volatile i32 %896, ptr %904, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %905 = load i32, ptr @curr, align 4, !tbaa !9
  %906 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %907 = load i32, ptr %906, align 4, !tbaa !35
  %908 = inttoptr i32 %907 to ptr
  %909 = load volatile i32, ptr %908, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %905, i32 noundef %909) #11
  br label %927

910:                                              ; preds = %888, %663
  %911 = phi i32 [ %665, %663 ], [ -1, %888 ]
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef %911) #11
  br label %912

912:                                              ; preds = %910, %154, %45
  %913 = phi i32 [ -3, %45 ], [ -3, %154 ], [ -1, %910 ]
  %914 = load i32, ptr %5, align 4, !tbaa !14
  %915 = icmp eq i32 %914, 2
  br i1 %915, label %916, label %926

916:                                              ; preds = %327, %304, %254, %912
  %917 = phi i32 [ %913, %912 ], [ 0, %327 ], [ %313, %304 ], [ 0, %254 ]
  %918 = load i32, ptr %11, align 4, !tbaa !27
  %919 = inttoptr i32 %918 to ptr
  %920 = getelementptr inbounds nuw i8, ptr %919, i32 16
  store volatile i32 %917, ptr %920, align 4, !tbaa !28
  %921 = getelementptr inbounds nuw i8, ptr %919, i32 20
  store volatile i32 1, ptr %921, align 4, !tbaa !30
  %922 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %923 = load i32, ptr %922, align 4, !tbaa !31
  %924 = add i32 %923, -84
  %925 = inttoptr i32 %924 to ptr
  store volatile i32 %917, ptr %925, align 4, !tbaa !9
  br label %926

926:                                              ; preds = %916, %912
  tail call fastcc void @swtch() #11
  br label %927

927:                                              ; preds = %623, %854, %895, %926, %9
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @badbuf(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #6 {
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
declare dso_local i32 @kfs_write(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_open(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_close(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_dup(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_fstat(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_seek(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_pipe(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_chdir(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mkdir(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_link(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_unlink(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfb_pause() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kflash_sync() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfb_resume() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_read(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #8

; Function Attrs: minsize optsize
declare dso_local void @kfs_forkcopy(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iopen(ptr noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_iread(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_iclose(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc i32 @kalloc(i32 noundef %0) unnamed_addr #9 {
  %2 = load i1, ptr @kheap_init, align 4
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  store i1 true, ptr @kheap_init, align 4
  %4 = load i32, ptr @arena, align 4, !tbaa !9
  %5 = inttoptr i32 %4 to ptr
  store ptr %5, ptr @kfreelist, align 4, !tbaa !87
  %6 = load i32, ptr @arena_end, align 4, !tbaa !9
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !89
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 4
  store ptr null, ptr %8, align 4, !tbaa !95
  br label %9

9:                                                ; preds = %3, %1
  %10 = add i32 %0, 255
  %11 = and i32 %10, -256
  %12 = add i32 %11, 256
  br label %13

13:                                               ; preds = %38, %9
  %14 = phi ptr [ @kfreelist, %9 ], [ %39, %38 ]
  %15 = load ptr, ptr %14, align 4, !tbaa !87
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !89
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
  store i32 %21, ptr %26, align 4, !tbaa !89
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !95
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !95
  store i32 %12, ptr %15, align 4, !tbaa !89
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !95
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !87
  %37 = add i32 %35, 256
  br label %40

38:                                               ; preds = %17
  %39 = getelementptr inbounds nuw i8, ptr %15, i32 4
  br label %13, !llvm.loop !96

40:                                               ; preds = %13, %34
  %41 = phi i32 [ %37, %34 ], [ 0, %13 ]
  ret i32 %41
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #9 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %41, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -256
  br label %5

5:                                                ; preds = %5, %3
  %6 = phi ptr [ null, %3 ], [ %8, %5 ]
  %7 = phi ptr [ @kfreelist, %3 ], [ %13, %5 ]
  %8 = load ptr, ptr %7, align 4, !tbaa !87
  %9 = icmp ne ptr %8, null
  %10 = ptrtoint ptr %8 to i32
  %11 = icmp ugt i32 %4, %10
  %12 = and i1 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 4
  br i1 %12, label %5, label %14, !llvm.loop !97

14:                                               ; preds = %5
  %15 = inttoptr i32 %4 to ptr
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  store ptr %8, ptr %16, align 4, !tbaa !95
  %17 = icmp eq ptr %6, null
  br i1 %17, label %20, label %18

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %15, ptr %19, align 4, !tbaa !95
  br label %21

20:                                               ; preds = %14
  store ptr %15, ptr @kfreelist, align 4, !tbaa !87
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !89
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !89
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !89
  %29 = load ptr, ptr %13, align 4, !tbaa !95
  store ptr %29, ptr %16, align 4, !tbaa !95
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !89
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !89
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !89
  %39 = load ptr, ptr %16, align 4, !tbaa !95
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !95
  br label %41

41:                                               ; preds = %30, %31, %36, %1
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @kfree_exec(i32 noundef %0) unnamed_addr #9 {
  br label %2

2:                                                ; preds = %14, %1
  %3 = phi i32 [ 0, %1 ], [ %17, %14 ]
  %4 = icmp eq i32 %3, 3
  br i1 %4, label %5, label %14

5:                                                ; preds = %2
  %6 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !9
  tail call fastcc void @kfree(i32 noundef %7) #11
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
  tail call fastcc void @kfree(i32 noundef %16) #11
  store i32 0, ptr %15, align 4, !tbaa !9
  %17 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !98
}

; Function Attrs: minsize nofree norecurse nounwind optsize
define internal fastcc void @vfork_release(ptr noundef %0) unnamed_addr #5 {
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
  br label %4, !llvm.loop !99
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #1 {
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
  tail call fastcc void @tick_income() #11
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
  tail call fastcc void @tick_income() #11
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

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_mount(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_umount(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kgpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kpinmux(i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kpio(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_syscall(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @kmain() local_unnamed_addr #1 {
  tail call void @dma_ktick() #11
  tail call void @dma_ksyscall() #11
  ret i32 0
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_putc(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_init() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_owner() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfb_setowner(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_exit(i32 noundef) local_unnamed_addr #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #10

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #11 = { minsize nobuiltin optsize "no-builtins" }
attributes #12 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #13 = { nounwind }

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
!87 = !{!88, !88, i64 0}
!88 = !{!"p1 _ZTS4khdr", !39, i64 0}
!89 = !{!90, !10, i64 0}
!90 = !{!"khdr", !10, i64 0, !88, i64 4}
!91 = distinct !{!91, !7, !8}
!92 = distinct !{!92, !7, !8}
!93 = distinct !{!93, !7, !8}
!94 = distinct !{!94, !7, !8}
!95 = !{!90, !88, i64 4}
!96 = distinct !{!96, !7, !8}
!97 = distinct !{!97, !7, !8}
!98 = distinct !{!98, !7, !8}
!99 = distinct !{!99, !7, !8}
