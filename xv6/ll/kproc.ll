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
@kimages = dso_local local_unnamed_addr global [20 x %struct.kimg] zeroinitializer, align 4
@initpid = dso_local local_unnamed_addr global i32 0, align 4
@fgpid = dso_local local_unnamed_addr global i32 0, align 4
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@rearm = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@.str = private unnamed_addr constant [18 x i8] c"fb: 640x480x8 on\0A\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"fb: psram fail\0A\00", align 1
@parked = internal unnamed_addr global i1 false, align 4
@entry_disp = internal unnamed_addr global i32 0, align 4
@entry_thunk = internal unnamed_addr global i32 0, align 4

; Function Attrs: minsize nounwind optsize
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
  tail call fastcc void @cputc(i32 noundef %10) #11
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !6
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc(i32 noundef range(i32 -128, 256) %0) unnamed_addr #0 {
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
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define dso_local i32 @kconsread(i32 noundef %0, i32 noundef %1) local_unnamed_addr #0 {
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
define internal fastcc void @cons_poll() unnamed_addr #0 {
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
define dso_local range(i32 9, 8) i32 @kfind_sleeper(i32 noundef %0) local_unnamed_addr #2 {
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
define dso_local i32 @kmail_get(i32 noundef %0, i32 noundef %1) local_unnamed_addr #3 {
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
define dso_local void @kmail_set(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #4 {
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
define dso_local void @kcomplete(i32 noundef %0, i32 noundef %1) local_unnamed_addr #4 {
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
define dso_local i32 @kblock_self_slot() local_unnamed_addr #5 {
  %1 = load i32, ptr @curr, align 4, !tbaa !9
  ret i32 %1
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize willreturn
define dso_local void @kblock_current(i32 noundef %0) local_unnamed_addr #3 {
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
define dso_local void @dma_ktick() local_unnamed_addr #0 {
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
define internal fastcc void @kenter() unnamed_addr #0 {
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
define internal fastcc void @tick_income() unnamed_addr #0 {
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
define internal fastcc void @terminate(ptr noundef %0, i32 noundef %1) unnamed_addr #0 {
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
define dso_local void @dma_ksyscall() local_unnamed_addr #0 {
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
  br label %917

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %12 = load i32, ptr %11, align 4, !tbaa !27
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !48
  switch i32 %14, label %885 [
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
    i32 5, label %125
    i32 12, label %149
    i32 13, label %245
    i32 3, label %17
    i32 1, label %305
    i32 7, label %335
    i32 2, label %653
    i32 26, label %656
    i32 27, label %665
    i32 25, label %672
    i32 28, label %760
    i32 29, label %769
    i32 30, label %777
    i32 31, label %783
    i32 32, label %810
    i32 23, label %835
    i32 24, label %840
    i32 6, label %15
  ]

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 4
  br label %862

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %257

19:                                               ; preds = %10
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !16
  br label %885

22:                                               ; preds = %10
  %23 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %885

24:                                               ; preds = %10
  %25 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %26 = load volatile i32, ptr %25, align 4, !tbaa !49
  %27 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %28 = load volatile i32, ptr %27, align 4, !tbaa !50
  %29 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %26, i32 noundef %28) #11
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %885

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
  br i1 %48, label %902, label %885

49:                                               ; preds = %10
  %50 = load i32, ptr @fsready, align 4, !tbaa !9
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %885, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %54 = load volatile i32, ptr %53, align 4, !tbaa !45
  %55 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %56 = load volatile i32, ptr %55, align 4, !tbaa !49
  %57 = tail call i32 @kfs_open(i32 noundef %54, i32 noundef %56) #12
  br label %885

58:                                               ; preds = %10
  %59 = load i32, ptr @fsready, align 4, !tbaa !9
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %885, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %63 = load volatile i32, ptr %62, align 4, !tbaa !45
  %64 = tail call i32 @kfs_close(i32 noundef %63) #12
  br label %885

65:                                               ; preds = %10
  %66 = load i32, ptr @fsready, align 4, !tbaa !9
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %885, label %68

68:                                               ; preds = %65
  %69 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %70 = load volatile i32, ptr %69, align 4, !tbaa !45
  %71 = tail call i32 @kfs_dup(i32 noundef %70) #12
  br label %885

72:                                               ; preds = %10
  %73 = load i32, ptr @fsready, align 4, !tbaa !9
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %885, label %75

75:                                               ; preds = %72
  %76 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %77 = load volatile i32, ptr %76, align 4, !tbaa !45
  %78 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %79 = load volatile i32, ptr %78, align 4, !tbaa !49
  %80 = tail call i32 @kfs_fstat(i32 noundef %77, i32 noundef %79) #12
  br label %885

81:                                               ; preds = %10
  %82 = load i32, ptr @fsready, align 4, !tbaa !9
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %885, label %84

84:                                               ; preds = %81
  %85 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %86 = load volatile i32, ptr %85, align 4, !tbaa !45
  %87 = tail call i32 @kfs_pipe(i32 noundef %86) #12
  br label %885

88:                                               ; preds = %10
  %89 = load i32, ptr @fsready, align 4, !tbaa !9
  %90 = icmp eq i32 %89, 0
  br i1 %90, label %885, label %91

91:                                               ; preds = %88
  %92 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %93 = load volatile i32, ptr %92, align 4, !tbaa !45
  %94 = tail call i32 @kfs_chdir(i32 noundef %93) #12
  br label %885

95:                                               ; preds = %10
  %96 = load i32, ptr @fsready, align 4, !tbaa !9
  %97 = icmp eq i32 %96, 0
  br i1 %97, label %885, label %98

98:                                               ; preds = %95
  %99 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %100 = load volatile i32, ptr %99, align 4, !tbaa !45
  %101 = tail call i32 @kfs_mkdir(i32 noundef %100) #12
  br label %885

102:                                              ; preds = %10
  %103 = load i32, ptr @fsready, align 4, !tbaa !9
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %885, label %105

105:                                              ; preds = %102
  %106 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %107 = load volatile i32, ptr %106, align 4, !tbaa !45
  %108 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %109 = load volatile i32, ptr %108, align 4, !tbaa !49
  %110 = tail call i32 @kfs_link(i32 noundef %107, i32 noundef %109) #12
  br label %885

111:                                              ; preds = %10
  %112 = load i32, ptr @fsready, align 4, !tbaa !9
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %885, label %114

114:                                              ; preds = %111
  %115 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %116 = load volatile i32, ptr %115, align 4, !tbaa !45
  %117 = tail call i32 @kfs_unlink(i32 noundef %116) #12
  br label %885

118:                                              ; preds = %10
  tail call void @kfb_pause() #12
  %119 = load i32, ptr @fsready, align 4, !tbaa !9
  %120 = icmp eq i32 %119, 0
  br i1 %120, label %123, label %121

121:                                              ; preds = %118
  %122 = tail call i32 @kflash_sync() #12
  br label %123

123:                                              ; preds = %118, %121
  %124 = phi i32 [ %122, %121 ], [ -1, %118 ]
  tail call void @kfb_resume() #12
  br label %885

125:                                              ; preds = %10
  %126 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %127 = load volatile i32, ptr %126, align 4, !tbaa !49
  %128 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %129 = load volatile i32, ptr %128, align 4, !tbaa !50
  %130 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %127, i32 noundef %129) #11
  %131 = icmp eq i32 %130, 0
  br i1 %131, label %132, label %885

132:                                              ; preds = %125
  %133 = load i32, ptr @fsready, align 4, !tbaa !9
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %141, label %135

135:                                              ; preds = %132
  %136 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %137 = load volatile i32, ptr %136, align 4, !tbaa !45
  %138 = load volatile i32, ptr %126, align 4, !tbaa !49
  %139 = load volatile i32, ptr %128, align 4, !tbaa !50
  %140 = tail call i32 @kfs_read(i32 noundef %137, i32 noundef %138, i32 noundef %139) #12
  br label %145

141:                                              ; preds = %132
  %142 = load volatile i32, ptr %126, align 4, !tbaa !49
  %143 = load volatile i32, ptr %128, align 4, !tbaa !50
  %144 = tail call i32 @kconsread(i32 noundef %142, i32 noundef %143) #11
  br label %145

145:                                              ; preds = %135, %141
  %146 = phi i32 [ %140, %135 ], [ %144, %141 ]
  %147 = freeze i32 %146
  %148 = icmp eq i32 %147, -3
  br i1 %148, label %902, label %885

149:                                              ; preds = %10
  %150 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %151 = load volatile i32, ptr %150, align 4, !tbaa !45
  %152 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %153 = load i32, ptr %152, align 4, !tbaa !51
  %154 = icmp eq i32 %153, 0
  br i1 %154, label %155, label %177

155:                                              ; preds = %149
  %156 = icmp slt i32 %151, 0
  br i1 %156, label %885, label %157

157:                                              ; preds = %155
  %158 = add nuw i32 %151, 255
  %159 = and i32 %158, -256
  %160 = icmp samesign ugt i32 %151, 16128
  %161 = select i1 %160, i32 %159, i32 16384
  %162 = tail call fastcc i32 @kalloc(i32 noundef %161) #11
  %163 = icmp ne i32 %162, 0
  %164 = or i1 %160, %163
  br i1 %164, label %167, label %165

165:                                              ; preds = %157
  %166 = tail call fastcc i32 @kalloc(i32 noundef %159) #11
  br label %167

167:                                              ; preds = %165, %157
  %168 = phi i32 [ %159, %165 ], [ %161, %157 ]
  %169 = phi i32 [ %166, %165 ], [ %162, %157 ]
  %170 = icmp eq i32 %169, 0
  br i1 %170, label %885, label %171

171:                                              ; preds = %167
  %172 = load i32, ptr @curr, align 4, !tbaa !9
  %173 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %172
  store i32 %169, ptr %173, align 4, !tbaa !9
  %174 = getelementptr inbounds nuw i8, ptr %5, i32 60
  store i32 %169, ptr %174, align 4, !tbaa !52
  store i32 %169, ptr %152, align 4, !tbaa !51
  %175 = add i32 %169, %168
  %176 = getelementptr inbounds nuw i8, ptr %5, i32 56
  store i32 %175, ptr %176, align 4, !tbaa !53
  br label %184

177:                                              ; preds = %149
  %178 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %179 = load i32, ptr %178, align 4, !tbaa !52
  %180 = icmp sgt i32 %151, -1
  br i1 %180, label %181, label %200

181:                                              ; preds = %177
  %182 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %183 = load i32, ptr %182, align 4, !tbaa !53
  br label %184

184:                                              ; preds = %181, %171
  %185 = phi i32 [ %175, %171 ], [ %183, %181 ]
  %186 = phi i32 [ %169, %171 ], [ %179, %181 ]
  %187 = phi ptr [ %174, %171 ], [ %178, %181 ]
  %188 = sub i32 %185, %186
  %189 = icmp ugt i32 %151, %188
  br i1 %189, label %885, label %190

190:                                              ; preds = %184
  %191 = add i32 %186, %151
  br label %192

192:                                              ; preds = %197, %190
  %193 = phi i32 [ %199, %197 ], [ %186, %190 ]
  %194 = icmp ult i32 %193, %191
  br i1 %194, label %197, label %195

195:                                              ; preds = %192
  %196 = load i32, ptr %187, align 4, !tbaa !52
  br label %204

197:                                              ; preds = %192
  %198 = inttoptr i32 %193 to ptr
  store volatile i8 0, ptr %198, align 1, !tbaa !3
  %199 = add nuw i32 %193, 1
  br label %192, !llvm.loop !54

200:                                              ; preds = %177
  %201 = sub nsw i32 0, %151
  %202 = sub i32 %179, %153
  %203 = icmp ult i32 %202, %201
  br i1 %203, label %885, label %204

204:                                              ; preds = %200, %195
  %205 = phi i32 [ %186, %195 ], [ %179, %200 ]
  %206 = phi ptr [ %187, %195 ], [ %178, %200 ]
  %207 = phi i32 [ %196, %195 ], [ %179, %200 ]
  %208 = add i32 %207, %151
  store i32 %208, ptr %206, align 4, !tbaa !52
  %209 = getelementptr inbounds nuw i8, ptr %5, i32 56
  br label %210

210:                                              ; preds = %244, %204
  %211 = phi ptr [ %5, %204 ], [ %219, %244 ]
  %212 = ptrtoint ptr %211 to i32
  %213 = sub i32 %212, ptrtoint (ptr @proc to i32)
  %214 = sdiv exact i32 %213, 72
  br label %215

215:                                              ; preds = %226, %210
  %216 = phi i32 [ 0, %210 ], [ %227, %226 ]
  %217 = icmp eq i32 %216, 8
  br i1 %217, label %885, label %218

218:                                              ; preds = %215
  %219 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %216
  %220 = load i32, ptr %219, align 4, !tbaa !14
  %221 = icmp eq i32 %220, 2
  br i1 %221, label %222, label %226

222:                                              ; preds = %218
  %223 = getelementptr inbounds nuw i8, ptr %219, i32 12
  %224 = load i32, ptr %223, align 4, !tbaa !18
  %225 = icmp eq i32 %224, %212
  br i1 %225, label %228, label %226

226:                                              ; preds = %222, %218
  %227 = add nuw nsw i32 %216, 1
  br label %215, !llvm.loop !55

228:                                              ; preds = %222
  %229 = getelementptr inbounds nuw i8, ptr %219, i32 52
  %230 = load i32, ptr %229, align 4, !tbaa !51
  %231 = load i32, ptr %152, align 4, !tbaa !51
  %232 = icmp eq i32 %230, %231
  br i1 %232, label %238, label %233

233:                                              ; preds = %228
  store i32 %231, ptr %229, align 4, !tbaa !51
  %234 = load i32, ptr %209, align 4, !tbaa !53
  %235 = getelementptr inbounds nuw i8, ptr %219, i32 56
  store i32 %234, ptr %235, align 4, !tbaa !53
  %236 = load i32, ptr %152, align 4, !tbaa !51
  %237 = getelementptr inbounds nuw i8, ptr %219, i32 60
  store i32 %236, ptr %237, align 4, !tbaa !52
  br label %238

238:                                              ; preds = %233, %228
  %239 = getelementptr inbounds [8 x i32], ptr @heapmem, i32 0, i32 %214
  %240 = load i32, ptr %239, align 4, !tbaa !9
  %241 = icmp eq i32 %240, 0
  br i1 %241, label %244, label %242

242:                                              ; preds = %238
  %243 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %216
  store i32 %240, ptr %243, align 4, !tbaa !9
  store i32 0, ptr %239, align 4, !tbaa !9
  br label %244

244:                                              ; preds = %242, %238
  br label %210, !llvm.loop !56

245:                                              ; preds = %10
  %246 = load i32, ptr @ticks, align 4, !tbaa !9
  %247 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %248 = load volatile i32, ptr %247, align 4, !tbaa !45
  %249 = add i32 %248, %246
  %250 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %249, ptr %250, align 4, !tbaa !41
  %251 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %252 = load i32, ptr %251, align 4, !tbaa !35
  %253 = inttoptr i32 %252 to ptr
  %254 = load volatile i32, ptr %253, align 4, !tbaa !9
  %255 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %254, ptr %255, align 4, !tbaa !36
  %256 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %256, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %906

257:                                              ; preds = %17, %276
  %258 = phi i32 [ %279, %276 ], [ 0, %17 ]
  %259 = phi i32 [ %277, %276 ], [ -1, %17 ]
  %260 = phi i32 [ %278, %276 ], [ 0, %17 ]
  %261 = icmp eq i32 %258, 8
  br i1 %261, label %262, label %264

262:                                              ; preds = %257
  %263 = icmp sgt i32 %259, -1
  br i1 %263, label %280, label %293

264:                                              ; preds = %257
  %265 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %258
  %266 = load i32, ptr %265, align 4, !tbaa !14
  %267 = icmp eq i32 %266, 0
  br i1 %267, label %276, label %268

268:                                              ; preds = %264
  %269 = getelementptr inbounds nuw i8, ptr %265, i32 8
  %270 = load i32, ptr %269, align 4, !tbaa !19
  %271 = load i32, ptr %18, align 4, !tbaa !16
  %272 = icmp eq i32 %270, %271
  br i1 %272, label %273, label %276

273:                                              ; preds = %268
  %274 = icmp eq i32 %266, 5
  %275 = select i1 %274, i32 %258, i32 %259
  br label %276

276:                                              ; preds = %273, %264, %268
  %277 = phi i32 [ %259, %268 ], [ %259, %264 ], [ %275, %273 ]
  %278 = phi i32 [ %260, %268 ], [ %260, %264 ], [ 1, %273 ]
  %279 = add nuw nsw i32 %258, 1
  br label %257, !llvm.loop !57

280:                                              ; preds = %262
  %281 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %282 = load volatile i32, ptr %281, align 4, !tbaa !45
  %283 = icmp eq i32 %282, 0
  br i1 %283, label %289, label %284

284:                                              ; preds = %280
  %285 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %259, i32 5
  %286 = load i32, ptr %285, align 4, !tbaa !43
  %287 = load volatile i32, ptr %281, align 4, !tbaa !45
  %288 = inttoptr i32 %287 to ptr
  store volatile i32 %286, ptr %288, align 4, !tbaa !9
  br label %289

289:                                              ; preds = %284, %280
  %290 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %259
  %291 = getelementptr inbounds nuw i8, ptr %290, i32 4
  %292 = load i32, ptr %291, align 4, !tbaa !16
  store i32 0, ptr %290, align 4, !tbaa !14
  br label %885

293:                                              ; preds = %262
  %294 = icmp eq i32 %260, 0
  br i1 %294, label %885, label %295

295:                                              ; preds = %293
  %296 = ptrtoint ptr %5 to i32
  %297 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %298 = load i32, ptr %297, align 4, !tbaa !35
  %299 = inttoptr i32 %298 to ptr
  %300 = load volatile i32, ptr %299, align 4, !tbaa !9
  %301 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %300, ptr %301, align 4, !tbaa !36
  %302 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %296, ptr %302, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  %303 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %304 = load volatile i32, ptr %303, align 4, !tbaa !28
  br label %906

305:                                              ; preds = %10, %312
  %306 = phi i32 [ %313, %312 ], [ 0, %10 ]
  %307 = icmp eq i32 %306, 8
  br i1 %307, label %885, label %308

308:                                              ; preds = %305
  %309 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %306
  %310 = load i32, ptr %309, align 4, !tbaa !14
  %311 = icmp eq i32 %310, 0
  br i1 %311, label %314, label %312

312:                                              ; preds = %308
  %313 = add nuw nsw i32 %306, 1
  br label %305, !llvm.loop !58

314:                                              ; preds = %308
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %309, ptr noundef nonnull align 4 dereferenceable(72) %5, i32 72, i1 false), !tbaa.struct !59
  %315 = load i32, ptr @fsready, align 4, !tbaa !9
  %316 = icmp eq i32 %315, 0
  br i1 %316, label %318, label %317

317:                                              ; preds = %314
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %306) #12
  br label %318

318:                                              ; preds = %317, %314
  %319 = load i32, ptr @nextpid, align 4, !tbaa !9
  %320 = add i32 %319, 1
  store i32 %320, ptr @nextpid, align 4, !tbaa !9
  %321 = getelementptr inbounds nuw i8, ptr %309, i32 4
  store i32 %319, ptr %321, align 4, !tbaa !16
  %322 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %323 = load i32, ptr %322, align 4, !tbaa !16
  %324 = getelementptr inbounds nuw i8, ptr %309, i32 8
  store i32 %323, ptr %324, align 4, !tbaa !19
  %325 = getelementptr inbounds nuw i8, ptr %309, i32 12
  store i32 0, ptr %325, align 4, !tbaa !18
  store i32 3, ptr %309, align 4, !tbaa !14
  %326 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %327 = load i32, ptr %326, align 4, !tbaa !35
  %328 = inttoptr i32 %327 to ptr
  %329 = load volatile i32, ptr %328, align 4, !tbaa !9
  %330 = getelementptr inbounds nuw i8, ptr %309, i32 40
  store i32 %329, ptr %330, align 4, !tbaa !36
  %331 = load volatile i32, ptr %328, align 4, !tbaa !9
  %332 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %331, ptr %332, align 4, !tbaa !36
  %333 = ptrtoint ptr %309 to i32
  %334 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %333, ptr %334, align 4, !tbaa !18
  store i32 2, ptr %5, align 4, !tbaa !14
  br label %906

335:                                              ; preds = %10
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #13
  %336 = load i32, ptr @fsready, align 4, !tbaa !9
  %337 = icmp eq i32 %336, 0
  br i1 %337, label %433, label %338

338:                                              ; preds = %335
  %339 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %340 = load volatile i32, ptr %339, align 4, !tbaa !45
  %341 = inttoptr i32 %340 to ptr
  %342 = tail call i32 @kfs_iopen(ptr noundef %341) #12
  %343 = icmp eq i32 %342, 0
  br i1 %343, label %433, label %344

344:                                              ; preds = %338
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #13
  %345 = ptrtoint ptr %2 to i32
  %346 = call i32 @kfs_iread(i32 noundef %342, i32 noundef 0, i32 noundef %345, i32 noundef 52) #12
  %347 = icmp eq i32 %346, 52
  %348 = load i32, ptr %2, align 4
  %349 = icmp eq i32 %348, 1480674628
  %350 = select i1 %347, i1 %349, i1 false
  br i1 %350, label %351, label %431

351:                                              ; preds = %344
  %352 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %353 = load i32, ptr %352, align 4, !tbaa !9
  %354 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %355 = load i32, ptr %354, align 4, !tbaa !9
  %356 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %357 = load i32, ptr %356, align 4, !tbaa !9
  %358 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %359 = load i32, ptr %358, align 4, !tbaa !9
  %360 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %361 = load i32, ptr %360, align 4, !tbaa !9
  %362 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %363 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %364 = load i32, ptr %363, align 4, !tbaa !9
  %365 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %364, ptr %365, align 4, !tbaa !60
  %366 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %367 = load i32, ptr %366, align 4, !tbaa !9
  %368 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %367, ptr %368, align 4, !tbaa !62
  %369 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %370 = load i32, ptr %369, align 4, !tbaa !9
  %371 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %370, ptr %371, align 4, !tbaa !63
  %372 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %373 = load i32, ptr %372, align 4, !tbaa !9
  %374 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %373, ptr %374, align 4, !tbaa !64
  %375 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %376 = load i32, ptr %375, align 4, !tbaa !9
  %377 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %376, ptr %377, align 4, !tbaa !65
  %378 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %379 = load i32, ptr %378, align 4, !tbaa !9
  %380 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %379, ptr %380, align 4, !tbaa !66
  %381 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %382 = load i32, ptr %381, align 4, !tbaa !9
  %383 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %382, ptr %383, align 4, !tbaa !67
  %384 = call fastcc i32 @kalloc(i32 noundef %353) #11
  %385 = call fastcc i32 @kalloc(i32 noundef %355) #11
  %386 = add i32 %353, 52
  %387 = add i32 %355, %386
  %388 = icmp ne i32 %384, 0
  %389 = icmp ne i32 %385, 0
  %390 = select i1 %388, i1 %389, i1 false
  br i1 %390, label %391, label %397

391:                                              ; preds = %351
  %392 = call i32 @kfs_iread(i32 noundef %342, i32 noundef 52, i32 noundef %384, i32 noundef %353) #12
  %393 = icmp eq i32 %392, %353
  br i1 %393, label %394, label %397

394:                                              ; preds = %391
  %395 = call i32 @kfs_iread(i32 noundef %342, i32 noundef %386, i32 noundef %385, i32 noundef %355) #12
  %396 = icmp eq i32 %395, %355
  br i1 %396, label %398, label %397

397:                                              ; preds = %394, %391, %351
  call fastcc void @kfree(i32 noundef %384) #11
  call fastcc void @kfree(i32 noundef %385) #11
  br label %431

398:                                              ; preds = %394
  %399 = sub i32 %384, %357
  %400 = sub i32 %385, %359
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #13
  %401 = ptrtoint ptr %3 to i32
  br label %402

402:                                              ; preds = %428, %398
  %403 = phi i32 [ %387, %398 ], [ %430, %428 ]
  %404 = phi i32 [ %361, %398 ], [ %429, %428 ]
  %405 = icmp eq i32 %404, 0
  br i1 %405, label %432, label %406

406:                                              ; preds = %402
  %407 = call i32 @llvm.umin.i32(i32 %404, i32 64)
  %408 = shl nuw nsw i32 %407, 2
  %409 = call i32 @kfs_iread(i32 noundef %342, i32 noundef %403, i32 noundef %401, i32 noundef %408) #12
  %410 = icmp eq i32 %409, %408
  br i1 %410, label %411, label %432

411:                                              ; preds = %406, %414
  %412 = phi i32 [ %427, %414 ], [ 0, %406 ]
  %413 = icmp eq i32 %412, %407
  br i1 %413, label %428, label %414

414:                                              ; preds = %411
  %415 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %412
  %416 = load i32, ptr %415, align 4, !tbaa !9
  %417 = icmp slt i32 %416, 0
  %418 = select i1 %417, i32 %385, i32 %384
  %419 = and i32 %416, 1073741823
  %420 = add i32 %418, %419
  %421 = and i32 %416, 1073741824
  %422 = icmp eq i32 %421, 0
  %423 = select i1 %422, i32 %399, i32 %400
  %424 = inttoptr i32 %420 to ptr
  %425 = load volatile i32, ptr %424, align 4, !tbaa !9
  %426 = add i32 %423, %425
  store volatile i32 %426, ptr %424, align 4, !tbaa !9
  %427 = add nuw nsw i32 %412, 1
  br label %411, !llvm.loop !68

428:                                              ; preds = %411
  %429 = sub i32 %404, %407
  %430 = add i32 %408, %403
  br label %402

431:                                              ; preds = %344, %397
  call void @kfs_iclose(i32 noundef %342) #12
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #13
  br label %612

432:                                              ; preds = %406, %402
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #13
  call void @kfs_iclose(i32 noundef %342) #12
  store i32 0, ptr %362, align 4, !tbaa !69
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #13
  br label %510

433:                                              ; preds = %335, %338
  %434 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %435 = load volatile i32, ptr %434, align 4, !tbaa !45
  %436 = inttoptr i32 %435 to ptr
  br label %437

437:                                              ; preds = %456, %433
  %438 = phi i32 [ 0, %433 ], [ %457, %456 ]
  %439 = icmp eq i32 %438, 20
  br i1 %439, label %612, label %440

440:                                              ; preds = %437
  %441 = getelementptr inbounds nuw [20 x %struct.kimg], ptr @kimages, i32 0, i32 %438
  %442 = load i8, ptr %441, align 4, !tbaa !3
  %443 = icmp eq i8 %442, 0
  br i1 %443, label %612, label %444

444:                                              ; preds = %440, %453
  %445 = phi i32 [ %455, %453 ], [ 0, %440 ]
  %446 = icmp eq i32 %445, 12
  br i1 %446, label %458, label %447

447:                                              ; preds = %444
  %448 = getelementptr inbounds nuw [12 x i8], ptr %441, i32 0, i32 %445
  %449 = load i8, ptr %448, align 1, !tbaa !3
  %450 = getelementptr inbounds nuw i8, ptr %436, i32 %445
  %451 = load i8, ptr %450, align 1, !tbaa !3
  %452 = icmp eq i8 %449, %451
  br i1 %452, label %453, label %456

453:                                              ; preds = %447
  %454 = icmp eq i8 %449, 0
  %455 = add nuw nsw i32 %445, 1
  br i1 %454, label %458, label %444, !llvm.loop !70

456:                                              ; preds = %447
  %457 = add nuw nsw i32 %438, 1
  br label %437, !llvm.loop !71

458:                                              ; preds = %453, %444
  %459 = getelementptr inbounds nuw i8, ptr %441, i32 16
  %460 = load i32, ptr %459, align 4, !tbaa !72
  %461 = tail call fastcc i32 @kalloc(i32 noundef %460) #11
  %462 = getelementptr inbounds nuw i8, ptr %441, i32 24
  %463 = load i32, ptr %462, align 4, !tbaa !73
  %464 = tail call fastcc i32 @kalloc(i32 noundef %463) #11
  %465 = icmp ne i32 %461, 0
  %466 = icmp ne i32 %464, 0
  %467 = select i1 %465, i1 %466, i1 false
  br i1 %467, label %468, label %612

468:                                              ; preds = %458
  %469 = getelementptr inbounds nuw i8, ptr %441, i32 12
  %470 = load i32, ptr %469, align 4, !tbaa !74
  %471 = inttoptr i32 %470 to ptr
  %472 = inttoptr i32 %461 to ptr
  br label %473

473:                                              ; preds = %484, %468
  %474 = phi ptr [ %471, %468 ], [ %485, %484 ]
  %475 = phi ptr [ %472, %468 ], [ %487, %484 ]
  %476 = phi i32 [ 0, %468 ], [ %488, %484 ]
  %477 = load i32, ptr %459, align 4, !tbaa !72
  %478 = icmp ult i32 %476, %477
  br i1 %478, label %484, label %479

479:                                              ; preds = %473
  %480 = getelementptr inbounds nuw i8, ptr %441, i32 20
  %481 = load i32, ptr %480, align 4, !tbaa !75
  %482 = inttoptr i32 %481 to ptr
  %483 = inttoptr i32 %464 to ptr
  br label %489

484:                                              ; preds = %473
  %485 = getelementptr inbounds nuw i8, ptr %474, i32 4
  %486 = load i32, ptr %474, align 4, !tbaa !9
  %487 = getelementptr inbounds nuw i8, ptr %475, i32 4
  store i32 %486, ptr %475, align 4, !tbaa !9
  %488 = add i32 %476, 4
  br label %473, !llvm.loop !76

489:                                              ; preds = %495, %479
  %490 = phi ptr [ %482, %479 ], [ %496, %495 ]
  %491 = phi ptr [ %483, %479 ], [ %498, %495 ]
  %492 = phi i32 [ 0, %479 ], [ %499, %495 ]
  %493 = load i32, ptr %462, align 4, !tbaa !73
  %494 = icmp ult i32 %492, %493
  br i1 %494, label %495, label %500

495:                                              ; preds = %489
  %496 = getelementptr inbounds nuw i8, ptr %490, i32 4
  %497 = load i32, ptr %490, align 4, !tbaa !9
  %498 = getelementptr inbounds nuw i8, ptr %491, i32 4
  store i32 %497, ptr %491, align 4, !tbaa !9
  %499 = add i32 %492, 4
  br label %489, !llvm.loop !77

500:                                              ; preds = %489
  %501 = getelementptr inbounds nuw i8, ptr %441, i32 28
  %502 = load i32, ptr %501, align 4, !tbaa !78
  %503 = getelementptr inbounds nuw i8, ptr %441, i32 32
  %504 = load i32, ptr %503, align 4, !tbaa !79
  %505 = getelementptr inbounds nuw i8, ptr %441, i32 36
  %506 = load i32, ptr %505, align 4, !tbaa !80
  %507 = sub i32 %461, %502
  %508 = sub i32 %464, %504
  %509 = inttoptr i32 %506 to ptr
  br label %510

510:                                              ; preds = %500, %432
  %511 = phi i32 [ %508, %500 ], [ %400, %432 ]
  %512 = phi i32 [ %507, %500 ], [ %399, %432 ]
  %513 = phi ptr [ %509, %500 ], [ null, %432 ]
  %514 = phi i32 [ %464, %500 ], [ %385, %432 ]
  %515 = phi i32 [ %461, %500 ], [ %384, %432 ]
  %516 = phi ptr [ %441, %500 ], [ %1, %432 ]
  %517 = getelementptr inbounds nuw i8, ptr %516, i32 40
  br label %518

518:                                              ; preds = %557, %510
  %519 = phi i32 [ 0, %510 ], [ %570, %557 ]
  %520 = load i32, ptr %517, align 4, !tbaa !69
  %521 = icmp ult i32 %519, %520
  br i1 %521, label %557, label %522

522:                                              ; preds = %518
  %523 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %524 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %525 = getelementptr inbounds nuw i8, ptr %5, i32 60
  br label %526

526:                                              ; preds = %542, %522
  %527 = phi ptr [ %5, %522 ], [ %533, %542 ]
  %528 = ptrtoint ptr %527 to i32
  br label %529

529:                                              ; preds = %540, %526
  %530 = phi i32 [ 0, %526 ], [ %541, %540 ]
  %531 = icmp eq i32 %530, 8
  br i1 %531, label %549, label %532

532:                                              ; preds = %529
  %533 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %530
  %534 = load i32, ptr %533, align 4, !tbaa !14
  %535 = icmp eq i32 %534, 2
  br i1 %535, label %536, label %540

536:                                              ; preds = %532
  %537 = getelementptr inbounds nuw i8, ptr %533, i32 12
  %538 = load i32, ptr %537, align 4, !tbaa !18
  %539 = icmp eq i32 %538, %528
  br i1 %539, label %542, label %540

540:                                              ; preds = %536, %532
  %541 = add nuw nsw i32 %530, 1
  br label %529, !llvm.loop !81

542:                                              ; preds = %536
  %543 = load i32, ptr %523, align 4, !tbaa !51
  %544 = getelementptr inbounds nuw i8, ptr %533, i32 52
  store i32 %543, ptr %544, align 4, !tbaa !51
  %545 = load i32, ptr %524, align 4, !tbaa !53
  %546 = getelementptr inbounds nuw i8, ptr %533, i32 56
  store i32 %545, ptr %546, align 4, !tbaa !53
  %547 = load i32, ptr %525, align 4, !tbaa !52
  %548 = getelementptr inbounds nuw i8, ptr %533, i32 60
  store i32 %547, ptr %548, align 4, !tbaa !52
  br label %526, !llvm.loop !82

549:                                              ; preds = %529
  %550 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %550) #11
  %551 = load i32, ptr @curr, align 4, !tbaa !9
  %552 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %551
  store i32 %515, ptr %552, align 4, !tbaa !9
  %553 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %551, i32 1
  store i32 %514, ptr %553, align 4, !tbaa !9
  %554 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %555 = load volatile i32, ptr %554, align 4, !tbaa !49
  %556 = icmp eq i32 %555, 0
  br i1 %556, label %613, label %571

557:                                              ; preds = %518
  %558 = getelementptr inbounds nuw i32, ptr %513, i32 %519
  %559 = load i32, ptr %558, align 4, !tbaa !9
  %560 = icmp slt i32 %559, 0
  %561 = select i1 %560, i32 %514, i32 %515
  %562 = and i32 %559, 1073741823
  %563 = add i32 %561, %562
  %564 = and i32 %559, 1073741824
  %565 = icmp eq i32 %564, 0
  %566 = select i1 %565, i32 %512, i32 %511
  %567 = inttoptr i32 %563 to ptr
  %568 = load volatile i32, ptr %567, align 4, !tbaa !9
  %569 = add i32 %566, %568
  store volatile i32 %569, ptr %567, align 4, !tbaa !9
  %570 = add nuw i32 %519, 1
  br label %518, !llvm.loop !83

571:                                              ; preds = %549
  %572 = call fastcc i32 @kalloc(i32 noundef 256) #11
  %573 = icmp eq i32 %572, 0
  br i1 %573, label %613, label %574

574:                                              ; preds = %571
  %575 = load volatile i32, ptr %554, align 4, !tbaa !49
  %576 = inttoptr i32 %575 to ptr
  %577 = inttoptr i32 %572 to ptr
  %578 = add i32 %572, 64
  %579 = inttoptr i32 %578 to ptr
  %580 = add i32 %572, 256
  %581 = inttoptr i32 %580 to ptr
  %582 = getelementptr inbounds i8, ptr %581, i32 -1
  br label %583

583:                                              ; preds = %605, %574
  %584 = phi i32 [ 0, %574 ], [ %607, %605 ]
  %585 = phi ptr [ %579, %574 ], [ %606, %605 ]
  %586 = icmp eq i32 %584, 15
  br i1 %586, label %608, label %587

587:                                              ; preds = %583
  %588 = getelementptr inbounds nuw i32, ptr %576, i32 %584
  %589 = load i32, ptr %588, align 4, !tbaa !9
  %590 = icmp eq i32 %589, 0
  br i1 %590, label %608, label %591

591:                                              ; preds = %587
  %592 = inttoptr i32 %589 to ptr
  %593 = ptrtoint ptr %585 to i32
  %594 = getelementptr inbounds nuw i32, ptr %577, i32 %584
  store i32 %593, ptr %594, align 4, !tbaa !9
  br label %595

595:                                              ; preds = %602, %591
  %596 = phi ptr [ %585, %591 ], [ %604, %602 ]
  %597 = phi ptr [ %592, %591 ], [ %603, %602 ]
  %598 = load i8, ptr %597, align 1, !tbaa !3
  %599 = icmp ne i8 %598, 0
  %600 = icmp ult ptr %596, %582
  %601 = select i1 %599, i1 %600, i1 false
  br i1 %601, label %602, label %605

602:                                              ; preds = %595
  %603 = getelementptr inbounds nuw i8, ptr %597, i32 1
  %604 = getelementptr inbounds nuw i8, ptr %596, i32 1
  store i8 %598, ptr %596, align 1, !tbaa !3
  br label %595, !llvm.loop !84

605:                                              ; preds = %595
  %606 = getelementptr inbounds nuw i8, ptr %596, i32 1
  store i8 0, ptr %596, align 1, !tbaa !3
  %607 = add nuw nsw i32 %584, 1
  br label %583, !llvm.loop !85

608:                                              ; preds = %583, %587
  %609 = getelementptr inbounds nuw i32, ptr %577, i32 %584
  store i32 0, ptr %609, align 4, !tbaa !9
  %610 = load i32, ptr @curr, align 4, !tbaa !9
  %611 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %610, i32 2
  store i32 %572, ptr %611, align 4, !tbaa !9
  br label %613

612:                                              ; preds = %437, %440, %458, %431
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #13
  br label %885

613:                                              ; preds = %549, %608, %571
  %614 = phi i32 [ 0, %549 ], [ %584, %608 ], [ 0, %571 ]
  %615 = phi i32 [ 0, %549 ], [ %572, %608 ], [ 0, %571 ]
  %616 = getelementptr inbounds nuw i8, ptr %516, i32 52
  %617 = load i32, ptr %616, align 4, !tbaa !63
  %618 = add i32 %617, %514
  %619 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %618, ptr %619, align 4, !tbaa !31
  %620 = getelementptr inbounds nuw i8, ptr %516, i32 56
  %621 = load i32, ptr %620, align 4, !tbaa !64
  %622 = add i32 %621, %514
  %623 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %622, ptr %623, align 4, !tbaa !86
  %624 = getelementptr inbounds nuw i8, ptr %516, i32 60
  %625 = load i32, ptr %624, align 4, !tbaa !65
  %626 = add i32 %625, %514
  %627 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %626, ptr %627, align 4, !tbaa !35
  %628 = getelementptr inbounds nuw i8, ptr %516, i32 48
  %629 = load i32, ptr %628, align 4, !tbaa !62
  %630 = add i32 %629, %515
  %631 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %630, ptr %631, align 4, !tbaa !40
  %632 = getelementptr inbounds nuw i8, ptr %516, i32 64
  %633 = load i32, ptr %632, align 4, !tbaa !66
  %634 = add i32 %633, %514
  store i32 %634, ptr %11, align 4, !tbaa !27
  %635 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %636 = getelementptr inbounds nuw i8, ptr %516, i32 68
  %637 = load i32, ptr %636, align 4, !tbaa !67
  %638 = add i32 %637, %514
  %639 = inttoptr i32 %638 to ptr
  store volatile i32 %635, ptr %639, align 4, !tbaa !9
  %640 = load i32, ptr %631, align 4, !tbaa !40
  %641 = load i32, ptr %619, align 4, !tbaa !31
  %642 = inttoptr i32 %641 to ptr
  store volatile i32 %640, ptr %642, align 4, !tbaa !9
  %643 = load i32, ptr %616, align 4, !tbaa !63
  %644 = add i32 %643, %514
  %645 = add i32 %644, -84
  %646 = inttoptr i32 %645 to ptr
  store volatile i32 %614, ptr %646, align 4, !tbaa !9
  %647 = add i32 %644, -80
  %648 = inttoptr i32 %647 to ptr
  store volatile i32 %615, ptr %648, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #11
  store i32 4, ptr %5, align 4, !tbaa !14
  %649 = load i32, ptr @curr, align 4, !tbaa !9
  %650 = getelementptr inbounds nuw i8, ptr %516, i32 44
  %651 = load i32, ptr %650, align 4, !tbaa !60
  %652 = add i32 %651, %515
  call fastcc void @kexit(i32 noundef %649, i32 noundef %652) #11
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #13
  br label %917

653:                                              ; preds = %10
  %654 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %655 = load volatile i32, ptr %654, align 4, !tbaa !45
  br label %900

656:                                              ; preds = %10
  %657 = load i32, ptr @fsready, align 4, !tbaa !9
  %658 = icmp eq i32 %657, 0
  br i1 %658, label %885, label %659

659:                                              ; preds = %656
  %660 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %661 = load volatile i32, ptr %660, align 4, !tbaa !45
  %662 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %663 = load volatile i32, ptr %662, align 4, !tbaa !49
  %664 = tail call i32 @kfs_mount(i32 noundef %661, i32 noundef %663) #12
  br label %885

665:                                              ; preds = %10
  %666 = load i32, ptr @fsready, align 4, !tbaa !9
  %667 = icmp eq i32 %666, 0
  br i1 %667, label %885, label %668

668:                                              ; preds = %665
  %669 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %670 = load volatile i32, ptr %669, align 4, !tbaa !45
  %671 = tail call i32 @kfs_umount(i32 noundef %670) #12
  br label %885

672:                                              ; preds = %10
  %673 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %674 = load volatile i32, ptr %673, align 4, !tbaa !45
  %675 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %676 = load i32, ptr %675, align 4, !tbaa !53
  %677 = icmp ult i32 %674, %676
  br i1 %677, label %678, label %685

678:                                              ; preds = %672
  %679 = add i32 %674, 32
  %680 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %681 = load i32, ptr %680, align 4, !tbaa !52
  %682 = icmp ugt i32 %679, %681
  br i1 %682, label %683, label %685

683:                                              ; preds = %678
  %684 = icmp ugt i32 %674, -33
  br i1 %684, label %685, label %885

685:                                              ; preds = %672, %678, %683
  %686 = load volatile i32, ptr %673, align 4, !tbaa !45
  %687 = inttoptr i32 %686 to ptr
  %688 = load i32, ptr @arena_end, align 4, !tbaa !9
  %689 = load i32, ptr @arena, align 4, !tbaa !9
  %690 = sub i32 %688, %689
  store i32 %690, ptr %687, align 4, !tbaa !9
  %691 = getelementptr inbounds nuw i8, ptr %687, i32 4
  store i32 0, ptr %691, align 4, !tbaa !9
  %692 = getelementptr inbounds nuw i8, ptr %687, i32 8
  store i32 0, ptr %692, align 4, !tbaa !9
  %693 = load i1, ptr @kheap_init, align 4
  br i1 %693, label %695, label %694

694:                                              ; preds = %685
  store i32 %690, ptr %692, align 4, !tbaa !9
  store i32 %690, ptr %691, align 4, !tbaa !9
  br label %710

695:                                              ; preds = %685, %707
  %696 = phi i32 [ %708, %707 ], [ 0, %685 ]
  %697 = phi i32 [ %703, %707 ], [ 0, %685 ]
  %698 = phi ptr [ %709, %707 ], [ @kfreelist, %685 ]
  %699 = load ptr, ptr %698, align 4, !tbaa !87
  %700 = icmp eq ptr %699, null
  br i1 %700, label %710, label %701

701:                                              ; preds = %695
  %702 = load i32, ptr %699, align 4, !tbaa !89
  %703 = add i32 %697, %702
  store i32 %703, ptr %691, align 4, !tbaa !9
  %704 = load i32, ptr %699, align 4, !tbaa !89
  %705 = icmp ugt i32 %704, %696
  br i1 %705, label %706, label %707

706:                                              ; preds = %701
  store i32 %704, ptr %692, align 4, !tbaa !9
  br label %707

707:                                              ; preds = %701, %706
  %708 = phi i32 [ %696, %701 ], [ %704, %706 ]
  %709 = getelementptr inbounds nuw i8, ptr %699, i32 4
  br label %695, !llvm.loop !91

710:                                              ; preds = %695, %694
  %711 = getelementptr inbounds nuw i8, ptr %687, i32 20
  store i32 0, ptr %711, align 4, !tbaa !9
  %712 = getelementptr inbounds nuw i8, ptr %687, i32 16
  store i32 0, ptr %712, align 4, !tbaa !9
  %713 = getelementptr inbounds nuw i8, ptr %687, i32 12
  store i32 0, ptr %713, align 4, !tbaa !9
  br label %714

714:                                              ; preds = %757, %710
  %715 = phi i32 [ 0, %710 ], [ %736, %757 ]
  %716 = phi i32 [ 0, %710 ], [ %758, %757 ]
  %717 = phi i32 [ 0, %710 ], [ %734, %757 ]
  %718 = phi i32 [ 0, %710 ], [ %759, %757 ]
  %719 = icmp eq i32 %718, 8
  br i1 %719, label %720, label %724

720:                                              ; preds = %714
  %721 = getelementptr inbounds nuw i8, ptr %687, i32 24
  store i32 8, ptr %721, align 4, !tbaa !9
  %722 = load i32, ptr @ticks, align 4, !tbaa !9
  %723 = getelementptr inbounds nuw i8, ptr %687, i32 28
  store i32 %722, ptr %723, align 4, !tbaa !9
  br label %885

724:                                              ; preds = %714
  %725 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %718
  %726 = load i32, ptr %725, align 4, !tbaa !9
  %727 = icmp eq i32 %726, 0
  br i1 %727, label %733, label %728

728:                                              ; preds = %724
  %729 = add i32 %726, -256
  %730 = inttoptr i32 %729 to ptr
  %731 = load volatile i32, ptr %730, align 4, !tbaa !9
  %732 = add i32 %717, %731
  store i32 %732, ptr %713, align 4, !tbaa !9
  br label %733

733:                                              ; preds = %728, %724
  %734 = phi i32 [ %732, %728 ], [ %717, %724 ]
  br label %735

735:                                              ; preds = %752, %733
  %736 = phi i32 [ %715, %733 ], [ %753, %752 ]
  %737 = phi i32 [ 0, %733 ], [ %754, %752 ]
  %738 = icmp eq i32 %737, 3
  br i1 %738, label %739, label %743

739:                                              ; preds = %735
  %740 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %718
  %741 = load i32, ptr %740, align 4, !tbaa !14
  %742 = icmp eq i32 %741, 0
  br i1 %742, label %757, label %755

743:                                              ; preds = %735
  %744 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %718, i32 %737
  %745 = load i32, ptr %744, align 4, !tbaa !9
  %746 = icmp eq i32 %745, 0
  br i1 %746, label %752, label %747

747:                                              ; preds = %743
  %748 = add i32 %745, -256
  %749 = inttoptr i32 %748 to ptr
  %750 = load volatile i32, ptr %749, align 4, !tbaa !9
  %751 = add i32 %736, %750
  store i32 %751, ptr %712, align 4, !tbaa !9
  br label %752

752:                                              ; preds = %743, %747
  %753 = phi i32 [ %736, %743 ], [ %751, %747 ]
  %754 = add nuw nsw i32 %737, 1
  br label %735, !llvm.loop !92

755:                                              ; preds = %739
  %756 = add i32 %716, 1
  store i32 %756, ptr %711, align 4, !tbaa !9
  br label %757

757:                                              ; preds = %739, %755
  %758 = phi i32 [ %716, %739 ], [ %756, %755 ]
  %759 = add nuw nsw i32 %718, 1
  br label %714, !llvm.loop !93

760:                                              ; preds = %10
  %761 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %762 = load volatile i32, ptr %761, align 4, !tbaa !45
  %763 = icmp eq i32 %762, 0
  br i1 %763, label %768, label %764

764:                                              ; preds = %760
  store i1 true, ptr @cons_raw, align 4
  %765 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %766 = load i32, ptr %765, align 4, !tbaa !16
  store i32 %766, ptr @cons_raw_pid, align 4, !tbaa !9
  %767 = load i32, ptr @cons_e, align 4, !tbaa !9
  store i32 %767, ptr @cons_w, align 4, !tbaa !9
  br label %885

768:                                              ; preds = %760
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !9
  br label %885

769:                                              ; preds = %10
  %770 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %771 = load volatile i32, ptr %770, align 4, !tbaa !45
  %772 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %773 = load volatile i32, ptr %772, align 4, !tbaa !49
  %774 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %775 = load volatile i32, ptr %774, align 4, !tbaa !50
  %776 = tail call i32 @kgpio(i32 noundef %771, i32 noundef %773, i32 noundef %775) #12
  br label %885

777:                                              ; preds = %10
  %778 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %779 = load volatile i32, ptr %778, align 4, !tbaa !45
  %780 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %781 = load volatile i32, ptr %780, align 4, !tbaa !49
  %782 = tail call i32 @kpinmux(i32 noundef %779, i32 noundef %781) #12
  br label %885

783:                                              ; preds = %10
  %784 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %785 = load volatile i32, ptr %784, align 4, !tbaa !45
  %786 = icmp eq i32 %785, 0
  br i1 %786, label %790, label %787

787:                                              ; preds = %783
  %788 = load volatile i32, ptr %784, align 4, !tbaa !45
  %789 = icmp eq i32 %788, 1
  br i1 %789, label %790, label %803

790:                                              ; preds = %787, %783
  %791 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %792 = load volatile i32, ptr %791, align 4, !tbaa !49
  %793 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %794 = load i32, ptr %793, align 4, !tbaa !53
  %795 = icmp ult i32 %792, %794
  br i1 %795, label %796, label %803

796:                                              ; preds = %790
  %797 = add i32 %792, 28
  %798 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %799 = load i32, ptr %798, align 4, !tbaa !52
  %800 = icmp ugt i32 %797, %799
  br i1 %800, label %801, label %803

801:                                              ; preds = %796
  %802 = icmp ugt i32 %792, -29
  br i1 %802, label %803, label %885

803:                                              ; preds = %790, %796, %801, %787
  %804 = load volatile i32, ptr %784, align 4, !tbaa !45
  %805 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %806 = load volatile i32, ptr %805, align 4, !tbaa !49
  %807 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %808 = load volatile i32, ptr %807, align 4, !tbaa !50
  %809 = tail call i32 @kpio(i32 noundef %804, i32 noundef %806, i32 noundef %808) #12
  br label %885

810:                                              ; preds = %10
  %811 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %812 = load volatile i32, ptr %811, align 4, !tbaa !45
  %813 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %814 = load volatile i32, ptr %813, align 4, !tbaa !49
  %815 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %816 = load i32, ptr %815, align 4, !tbaa !16
  %817 = load volatile i32, ptr %811, align 4, !tbaa !45
  %818 = icmp eq i32 %817, 0
  br i1 %818, label %819, label %832

819:                                              ; preds = %810
  %820 = load volatile i32, ptr %813, align 4, !tbaa !49
  %821 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %822 = load i32, ptr %821, align 4, !tbaa !53
  %823 = icmp ult i32 %820, %822
  br i1 %823, label %824, label %832

824:                                              ; preds = %819
  %825 = add i32 %820, 20
  %826 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %827 = load i32, ptr %826, align 4, !tbaa !52
  %828 = icmp ugt i32 %825, %827
  br i1 %828, label %829, label %832

829:                                              ; preds = %824
  %830 = icmp ult i32 %820, -20
  %831 = zext i1 %830 to i32
  br label %832

832:                                              ; preds = %829, %824, %819, %810
  %833 = phi i32 [ 0, %810 ], [ 0, %824 ], [ 0, %819 ], [ %831, %829 ]
  %834 = tail call i32 @kfb_syscall(i32 noundef %812, i32 noundef %814, i32 noundef %816, i32 noundef %833) #12
  br label %885

835:                                              ; preds = %10
  %836 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %837 = load volatile i32, ptr %836, align 4, !tbaa !50
  %838 = getelementptr inbounds nuw i8, ptr %5, i32 64
  store i32 %837, ptr %838, align 4, !tbaa !25
  %839 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %839, align 4, !tbaa !26
  br label %885

840:                                              ; preds = %10
  %841 = getelementptr inbounds nuw i8, ptr %5, i32 64
  %842 = load i32, ptr %841, align 4, !tbaa !25
  %843 = icmp eq i32 %842, 0
  br i1 %843, label %885, label %844

844:                                              ; preds = %840
  %845 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %846 = load i32, ptr %845, align 4, !tbaa !31
  %847 = add i32 %846, -84
  %848 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %848, align 4, !tbaa !26
  %849 = add i32 %842, 8
  %850 = inttoptr i32 %849 to ptr
  %851 = load volatile i32, ptr %850, align 4, !tbaa !9
  %852 = inttoptr i32 %847 to ptr
  store volatile i32 %851, ptr %852, align 4, !tbaa !9
  %853 = add i32 %842, 12
  %854 = inttoptr i32 %853 to ptr
  %855 = load volatile i32, ptr %854, align 4, !tbaa !9
  %856 = add i32 %846, -80
  %857 = inttoptr i32 %856 to ptr
  store volatile i32 %855, ptr %857, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %858 = load i32, ptr @curr, align 4, !tbaa !9
  %859 = add i32 %842, 4
  %860 = inttoptr i32 %859 to ptr
  %861 = load volatile i32, ptr %860, align 4, !tbaa !9
  tail call fastcc void @kexit(i32 noundef %858, i32 noundef %861) #11
  br label %917

862:                                              ; preds = %15, %874
  %863 = phi i32 [ %875, %874 ], [ 0, %15 ]
  %864 = icmp eq i32 %863, 8
  br i1 %864, label %885, label %865

865:                                              ; preds = %862
  %866 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %863
  %867 = load i32, ptr %866, align 4, !tbaa !14
  %868 = icmp eq i32 %867, 0
  br i1 %868, label %874, label %869

869:                                              ; preds = %865
  %870 = getelementptr inbounds nuw i8, ptr %866, i32 4
  %871 = load i32, ptr %870, align 4, !tbaa !16
  %872 = load volatile i32, ptr %16, align 4, !tbaa !45
  %873 = icmp eq i32 %871, %872
  br i1 %873, label %876, label %874

874:                                              ; preds = %865, %869
  %875 = add nuw nsw i32 %863, 1
  br label %862, !llvm.loop !94

876:                                              ; preds = %869
  %877 = icmp eq i32 %867, 5
  br i1 %877, label %885, label %878

878:                                              ; preds = %876
  %879 = icmp eq i32 %863, %4
  br i1 %879, label %900, label %880

880:                                              ; preds = %878
  %881 = icmp eq i32 %867, 2
  br i1 %881, label %882, label %883

882:                                              ; preds = %880
  tail call fastcc void @terminate(ptr noundef nonnull %866, i32 noundef -1) #11
  br label %885

883:                                              ; preds = %880
  %884 = getelementptr inbounds nuw i8, ptr %866, i32 48
  store i32 1, ptr %884, align 4, !tbaa !32
  br label %885

885:                                              ; preds = %862, %305, %215, %125, %24, %10, %19, %22, %123, %683, %720, %769, %777, %803, %832, %835, %49, %52, %58, %61, %65, %68, %72, %75, %81, %84, %88, %91, %95, %98, %102, %105, %111, %114, %289, %293, %656, %659, %665, %668, %768, %764, %801, %876, %883, %882, %840, %45, %145, %155, %167, %184, %200, %612
  %886 = phi i32 [ -1, %612 ], [ -1, %167 ], [ -1, %200 ], [ -1, %184 ], [ -1, %155 ], [ %147, %145 ], [ %47, %45 ], [ -1, %840 ], [ 0, %882 ], [ 0, %883 ], [ -1, %876 ], [ -1, %801 ], [ 0, %764 ], [ 0, %768 ], [ -1, %665 ], [ %671, %668 ], [ -1, %656 ], [ %664, %659 ], [ -1, %293 ], [ %292, %289 ], [ -1, %111 ], [ %117, %114 ], [ -1, %102 ], [ %110, %105 ], [ -1, %95 ], [ %101, %98 ], [ -1, %88 ], [ %94, %91 ], [ -1, %81 ], [ %87, %84 ], [ -1, %72 ], [ %80, %75 ], [ -1, %65 ], [ %71, %68 ], [ -1, %58 ], [ %64, %61 ], [ -1, %49 ], [ %57, %52 ], [ 0, %835 ], [ %834, %832 ], [ %809, %803 ], [ %782, %777 ], [ %776, %769 ], [ 0, %720 ], [ -1, %683 ], [ %124, %123 ], [ %23, %22 ], [ %21, %19 ], [ -1, %10 ], [ -1, %24 ], [ -1, %125 ], [ %205, %215 ], [ -1, %305 ], [ -1, %862 ]
  %887 = load i32, ptr %11, align 4, !tbaa !27
  %888 = inttoptr i32 %887 to ptr
  %889 = getelementptr inbounds nuw i8, ptr %888, i32 16
  store volatile i32 %886, ptr %889, align 4, !tbaa !28
  %890 = getelementptr inbounds nuw i8, ptr %888, i32 20
  store volatile i32 1, ptr %890, align 4, !tbaa !30
  %891 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %892 = load i32, ptr %891, align 4, !tbaa !31
  %893 = add i32 %892, -84
  %894 = inttoptr i32 %893 to ptr
  store volatile i32 %886, ptr %894, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !14
  %895 = load i32, ptr @curr, align 4, !tbaa !9
  %896 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %897 = load i32, ptr %896, align 4, !tbaa !35
  %898 = inttoptr i32 %897 to ptr
  %899 = load volatile i32, ptr %898, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %895, i32 noundef %899) #11
  br label %917

900:                                              ; preds = %878, %653
  %901 = phi i32 [ %655, %653 ], [ -1, %878 ]
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef %901) #11
  br label %902

902:                                              ; preds = %900, %145, %45
  %903 = phi i32 [ -3, %45 ], [ -3, %145 ], [ -1, %900 ]
  %904 = load i32, ptr %5, align 4, !tbaa !14
  %905 = icmp eq i32 %904, 2
  br i1 %905, label %906, label %916

906:                                              ; preds = %318, %295, %245, %902
  %907 = phi i32 [ %903, %902 ], [ 0, %318 ], [ %304, %295 ], [ 0, %245 ]
  %908 = load i32, ptr %11, align 4, !tbaa !27
  %909 = inttoptr i32 %908 to ptr
  %910 = getelementptr inbounds nuw i8, ptr %909, i32 16
  store volatile i32 %907, ptr %910, align 4, !tbaa !28
  %911 = getelementptr inbounds nuw i8, ptr %909, i32 20
  store volatile i32 1, ptr %911, align 4, !tbaa !30
  %912 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %913 = load i32, ptr %912, align 4, !tbaa !31
  %914 = add i32 %913, -84
  %915 = inttoptr i32 %914 to ptr
  store volatile i32 %907, ptr %915, align 4, !tbaa !9
  br label %916

916:                                              ; preds = %906, %902
  tail call fastcc void @swtch() #11
  br label %917

917:                                              ; preds = %613, %844, %885, %916, %9
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
define internal fastcc void @vfork_release(ptr noundef %0) unnamed_addr #4 {
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
define internal fastcc void @kexit(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
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
define dso_local noundef i32 @kmain() local_unnamed_addr #0 {
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

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize mustprogress nofree norecurse nounwind optsize willreturn "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
