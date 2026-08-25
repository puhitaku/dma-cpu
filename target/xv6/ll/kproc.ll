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
@selwait_to = internal global i32 0, align 4
@selwait_inf = internal global i32 0, align 4
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
@tick_taken = internal unnamed_addr global i1 false, align 4
@dma_disk = external dso_local local_unnamed_addr global i32, align 4
@.str = private unnamed_addr constant [18 x i8] c"fb: 640x480x8 on\0A\00", align 1
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
define internal fastcc void @cputc(i32 noundef range(i32 -128, -2147483648) %0) unnamed_addr #1 {
  %2 = icmp eq i32 %0, 10
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  tail call fastcc void @cputc_wire(i32 noundef 13) #11
  br label %4

4:                                                ; preds = %3, %1
  %5 = and i32 %0, 255
  tail call fastcc void @cputc_wire(i32 noundef %5) #11
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
  %1 = load i32, ptr @cons_w, align 4, !tbaa !9
  br label %2

2:                                                ; preds = %88, %0
  %3 = load i32, ptr @cons_e, align 4, !tbaa !9
  %4 = load i32, ptr @cons_r, align 4, !tbaa !9
  %5 = sub i32 %3, %4
  %6 = icmp ult i32 %5, 128
  br i1 %6, label %7, label %205

7:                                                ; preds = %2
  %8 = tail call i32 @kcons_rx() #12
  %9 = icmp eq i32 %8, -2
  br i1 %9, label %10, label %17

10:                                               ; preds = %7
  %11 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %12 = and i32 %11, 16
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %205

14:                                               ; preds = %10
  %15 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !9
  %16 = and i32 %15, 255
  br label %19

17:                                               ; preds = %7
  %18 = icmp slt i32 %8, 0
  br i1 %18, label %205, label %19

19:                                               ; preds = %14, %17
  %20 = phi i32 [ %16, %14 ], [ %8, %17 ]
  %21 = load i1, ptr @cons_raw, align 4
  br i1 %21, label %22, label %28

22:                                               ; preds = %19
  %23 = trunc i32 %20 to i8
  %24 = load i32, ptr @cons_e, align 4, !tbaa !9
  %25 = and i32 %24, 127
  %26 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %25
  store i8 %23, ptr %26, align 1, !tbaa !3
  %27 = add i32 %24, 1
  store i32 %27, ptr @cons_e, align 4, !tbaa !9
  store i32 %27, ptr @cons_w, align 4, !tbaa !9
  br label %88

28:                                               ; preds = %19
  %29 = icmp eq i32 %20, 3
  br i1 %29, label %30, label %171

30:                                               ; preds = %28
  %31 = load i32, ptr @fgpid, align 4, !tbaa !9
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %88, label %33

33:                                               ; preds = %30, %44
  %34 = phi i32 [ %45, %44 ], [ 0, %30 ]
  %35 = icmp eq i32 %34, 8
  br i1 %35, label %88, label %36, !llvm.loop !11

36:                                               ; preds = %33
  %37 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %34
  %38 = load i32, ptr %37, align 4, !tbaa !12
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %44, label %40

40:                                               ; preds = %36
  %41 = getelementptr inbounds nuw i8, ptr %37, i32 4
  %42 = load i32, ptr %41, align 4, !tbaa !14
  %43 = icmp eq i32 %42, %31
  br i1 %43, label %46, label %44

44:                                               ; preds = %40, %36
  %45 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !15

46:                                               ; preds = %40
  %47 = icmp eq i32 %38, 2
  br i1 %47, label %48, label %88

48:                                               ; preds = %46
  %49 = getelementptr inbounds nuw i8, ptr %37, i32 12
  %50 = load i32, ptr %49, align 4, !tbaa !16
  %51 = ptrtoint ptr %37 to i32
  %52 = icmp eq i32 %50, %51
  br i1 %52, label %53, label %74

53:                                               ; preds = %48, %70
  %54 = phi ptr [ %71, %70 ], [ null, %48 ]
  %55 = phi i32 [ %72, %70 ], [ 0, %48 ]
  %56 = phi i32 [ %73, %70 ], [ 0, %48 ]
  %57 = icmp eq i32 %56, 8
  br i1 %57, label %86, label %58

58:                                               ; preds = %53
  %59 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %56
  %60 = load i32, ptr %59, align 4, !tbaa !12
  switch i32 %60, label %61 [
    i32 0, label %70
    i32 5, label %70
  ]

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %59, i32 8
  %63 = load i32, ptr %62, align 4, !tbaa !17
  %64 = icmp eq i32 %63, %31
  br i1 %64, label %65, label %70

65:                                               ; preds = %61
  %66 = getelementptr inbounds nuw i8, ptr %59, i32 4
  %67 = load i32, ptr %66, align 4, !tbaa !14
  %68 = icmp ugt i32 %67, %55
  br i1 %68, label %69, label %70

69:                                               ; preds = %65
  br label %70

70:                                               ; preds = %69, %65, %61, %58, %58
  %71 = phi ptr [ %59, %69 ], [ %54, %65 ], [ %54, %61 ], [ %54, %58 ], [ %54, %58 ]
  %72 = phi i32 [ %67, %69 ], [ %55, %65 ], [ %55, %61 ], [ %55, %58 ], [ %55, %58 ]
  %73 = add nuw nsw i32 %56, 1
  br label %53, !llvm.loop !18

74:                                               ; preds = %48, %84
  %75 = phi i32 [ %85, %84 ], [ 0, %48 ]
  %76 = icmp eq i32 %75, 8
  br i1 %76, label %88, label %77, !llvm.loop !11

77:                                               ; preds = %74
  %78 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %75
  %79 = ptrtoint ptr %78 to i32
  %80 = icmp eq i32 %50, %79
  br i1 %80, label %81, label %84

81:                                               ; preds = %77
  %82 = load i32, ptr %78, align 4, !tbaa !12
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %84, label %89

84:                                               ; preds = %81, %77
  %85 = add nuw nsw i32 %75, 1
  br label %74, !llvm.loop !19

86:                                               ; preds = %53
  %87 = icmp eq ptr %54, null
  br i1 %87, label %88, label %89

88:                                               ; preds = %33, %74, %132, %86, %46, %30, %22, %178, %174, %200, %204, %180
  br label %2, !llvm.loop !11

89:                                               ; preds = %81, %86
  %90 = phi ptr [ %54, %86 ], [ %78, %81 ]
  tail call fastcc void @cputc(i32 noundef 94) #11
  tail call fastcc void @cputc(i32 noundef 67) #11
  tail call fastcc void @cputc(i32 noundef 10) #11
  br label %91

91:                                               ; preds = %129, %89
  %92 = phi i32 [ 0, %89 ], [ %130, %129 ]
  %93 = phi i32 [ 0, %89 ], [ %131, %129 ]
  %94 = icmp eq i32 %93, 8
  br i1 %94, label %132, label %95

95:                                               ; preds = %91
  %96 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %93
  %97 = load i32, ptr %96, align 4, !tbaa !12
  switch i32 %97, label %98 [
    i32 0, label %129
    i32 5, label %129
  ]

98:                                               ; preds = %95, %123
  %99 = phi ptr [ %124, %123 ], [ %96, %95 ]
  %100 = phi i32 [ %125, %123 ], [ 0, %95 ]
  %101 = icmp eq ptr %99, null
  %102 = icmp samesign ugt i32 %100, 7
  %103 = select i1 %101, i1 true, i1 %102
  br i1 %103, label %129, label %104

104:                                              ; preds = %98
  %105 = icmp eq ptr %99, %90
  br i1 %105, label %126, label %106

106:                                              ; preds = %104
  %107 = getelementptr inbounds nuw i8, ptr %99, i32 8
  %108 = load i32, ptr %107, align 4, !tbaa !17
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %129, label %110

110:                                              ; preds = %106, %121
  %111 = phi i32 [ %122, %121 ], [ 0, %106 ]
  %112 = icmp eq i32 %111, 8
  br i1 %112, label %123, label %113

113:                                              ; preds = %110
  %114 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %111
  %115 = load i32, ptr %114, align 4, !tbaa !12
  %116 = icmp eq i32 %115, 0
  br i1 %116, label %121, label %117

117:                                              ; preds = %113
  %118 = getelementptr inbounds nuw i8, ptr %114, i32 4
  %119 = load i32, ptr %118, align 4, !tbaa !14
  %120 = icmp eq i32 %119, %108
  br i1 %120, label %123, label %121

121:                                              ; preds = %117, %113
  %122 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !20

123:                                              ; preds = %117, %110
  %124 = phi ptr [ null, %110 ], [ %114, %117 ]
  %125 = add nuw nsw i32 %100, 1
  br label %98, !llvm.loop !21

126:                                              ; preds = %104
  %127 = shl nuw nsw i32 1, %93
  %128 = or i32 %127, %92
  br label %129

129:                                              ; preds = %106, %98, %126, %95, %95
  %130 = phi i32 [ %128, %126 ], [ %92, %95 ], [ %92, %95 ], [ %92, %98 ], [ %92, %106 ]
  %131 = add nuw nsw i32 %93, 1
  br label %91, !llvm.loop !22

132:                                              ; preds = %91, %169
  %133 = phi i32 [ %170, %169 ], [ 0, %91 ]
  %134 = icmp eq i32 %133, 8
  br i1 %134, label %88, label %135, !llvm.loop !11

135:                                              ; preds = %132
  %136 = shl nuw nsw i32 1, %133
  %137 = and i32 %136, %92
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %169, label %139

139:                                              ; preds = %135
  %140 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %133
  %141 = getelementptr inbounds nuw i8, ptr %140, i32 64
  %142 = load i32, ptr %141, align 4, !tbaa !23
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %163, label %144

144:                                              ; preds = %139
  %145 = getelementptr inbounds nuw i8, ptr %140, i32 68
  %146 = load i32, ptr %145, align 4, !tbaa !24
  %147 = icmp eq i32 %146, 0
  br i1 %147, label %148, label %169

148:                                              ; preds = %144
  %149 = load i32, ptr %140, align 4, !tbaa !12
  %150 = icmp eq i32 %149, 2
  br i1 %150, label %151, label %162

151:                                              ; preds = %148
  %152 = getelementptr inbounds nuw i8, ptr %140, i32 44
  %153 = load i32, ptr %152, align 4, !tbaa !25
  %154 = inttoptr i32 %153 to ptr
  %155 = getelementptr inbounds nuw i8, ptr %154, i32 16
  store volatile i32 -1, ptr %155, align 4, !tbaa !26
  %156 = getelementptr inbounds nuw i8, ptr %154, i32 20
  store volatile i32 1, ptr %156, align 4, !tbaa !28
  %157 = getelementptr inbounds nuw i8, ptr %140, i32 24
  %158 = load i32, ptr %157, align 4, !tbaa !29
  %159 = add i32 %158, -84
  %160 = inttoptr i32 %159 to ptr
  store volatile i32 -1, ptr %160, align 4, !tbaa !9
  %161 = getelementptr inbounds nuw i8, ptr %140, i32 12
  store i32 0, ptr %161, align 4, !tbaa !16
  store i32 3, ptr %140, align 4, !tbaa !12
  br label %162

162:                                              ; preds = %151, %148
  store i32 1, ptr %145, align 4, !tbaa !24
  br label %169

163:                                              ; preds = %139
  %164 = load i32, ptr %140, align 4, !tbaa !12
  %165 = icmp eq i32 %164, 2
  br i1 %165, label %166, label %167

166:                                              ; preds = %163
  tail call fastcc void @terminate(ptr noundef nonnull %140, i32 noundef -1) #11
  br label %169

167:                                              ; preds = %163
  %168 = getelementptr inbounds nuw i8, ptr %140, i32 48
  store i32 1, ptr %168, align 4, !tbaa !30
  br label %169

169:                                              ; preds = %167, %166, %162, %144, %135
  %170 = add nuw nsw i32 %133, 1
  br label %132, !llvm.loop !31

171:                                              ; preds = %28
  %172 = icmp eq i32 %20, 13
  %173 = select i1 %172, i32 10, i32 %20
  switch i32 %20, label %180 [
    i32 8, label %174
    i32 127, label %174
  ]

174:                                              ; preds = %171, %171
  %175 = load i32, ptr @cons_e, align 4, !tbaa !9
  %176 = load i32, ptr @cons_w, align 4, !tbaa !9
  %177 = icmp eq i32 %175, %176
  br i1 %177, label %88, label %178

178:                                              ; preds = %174
  %179 = add i32 %175, -1
  store i32 %179, ptr @cons_e, align 4, !tbaa !9
  tail call fastcc void @cputc(i32 noundef 8) #11
  tail call fastcc void @cputc(i32 noundef 32) #11
  tail call fastcc void @cputc(i32 noundef 8) #11
  br label %88

180:                                              ; preds = %171
  %181 = load i32, ptr @cons_e, align 4, !tbaa !9
  %182 = load i32, ptr @cons_r, align 4, !tbaa !9
  %183 = sub i32 %181, %182
  %184 = icmp ult i32 %183, 128
  br i1 %184, label %185, label %88

185:                                              ; preds = %180
  %186 = trunc i32 %173 to i8
  %187 = and i32 %181, 127
  %188 = getelementptr inbounds nuw [128 x i8], ptr @cons_buf, i32 0, i32 %187
  store i8 %186, ptr %188, align 1, !tbaa !3
  %189 = add i32 %181, 1
  store i32 %189, ptr @cons_e, align 4, !tbaa !9
  %190 = icmp samesign ult i32 %173, 32
  %191 = add nsw i32 %173, -11
  %192 = icmp ult i32 %191, -2
  %193 = and i1 %190, %192
  br i1 %193, label %194, label %196

194:                                              ; preds = %185
  tail call fastcc void @cputc(i32 noundef 94) #11
  %195 = or disjoint i32 %173, 64
  br label %196

196:                                              ; preds = %185, %194
  %197 = phi i32 [ %195, %194 ], [ %173, %185 ]
  tail call fastcc void @cputc(i32 noundef %197) #11
  %198 = icmp eq i32 %173, 10
  %199 = load i32, ptr @cons_e, align 4, !tbaa !9
  br i1 %198, label %204, label %200

200:                                              ; preds = %196
  %201 = load i32, ptr @cons_r, align 4, !tbaa !9
  %202 = sub i32 %199, %201
  %203 = icmp eq i32 %202, 128
  br i1 %203, label %204, label %88

204:                                              ; preds = %200, %196
  store i32 %199, ptr @cons_w, align 4, !tbaa !9
  br label %88

205:                                              ; preds = %10, %17, %2
  %206 = load i32, ptr @cons_w, align 4, !tbaa !9
  %207 = icmp eq i32 %206, %1
  br i1 %207, label %235, label %208

208:                                              ; preds = %205, %233
  %209 = phi i32 [ %234, %233 ], [ 0, %205 ]
  %210 = icmp eq i32 %209, 8
  br i1 %210, label %235, label %211

211:                                              ; preds = %208
  %212 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %209
  %213 = load i32, ptr %212, align 4, !tbaa !12
  %214 = icmp eq i32 %213, 2
  br i1 %214, label %215, label %233

215:                                              ; preds = %211
  %216 = getelementptr inbounds nuw i8, ptr %212, i32 12
  %217 = load i32, ptr %216, align 4, !tbaa !16
  %218 = icmp eq i32 %217, ptrtoint (ptr @selwait_inf to i32)
  br i1 %218, label %221, label %219

219:                                              ; preds = %215
  %220 = icmp eq i32 %217, ptrtoint (ptr @selwait_to to i32)
  br i1 %220, label %221, label %233

221:                                              ; preds = %219, %215
  %222 = getelementptr inbounds nuw i8, ptr %212, i32 44
  %223 = load i32, ptr %222, align 4, !tbaa !25
  %224 = inttoptr i32 %223 to ptr
  %225 = getelementptr inbounds nuw i8, ptr %224, i32 4
  %226 = load volatile i32, ptr %225, align 4, !tbaa !32
  %227 = getelementptr inbounds nuw i8, ptr %224, i32 16
  store volatile i32 %226, ptr %227, align 4, !tbaa !26
  %228 = getelementptr inbounds nuw i8, ptr %224, i32 20
  store volatile i32 1, ptr %228, align 4, !tbaa !28
  %229 = getelementptr inbounds nuw i8, ptr %212, i32 24
  %230 = load i32, ptr %229, align 4, !tbaa !29
  %231 = add i32 %230, -84
  %232 = inttoptr i32 %231 to ptr
  store volatile i32 %226, ptr %232, align 4, !tbaa !9
  store i32 0, ptr %216, align 4, !tbaa !16
  store i32 3, ptr %212, align 4, !tbaa !12
  br label %233

233:                                              ; preds = %221, %219, %211
  %234 = add nuw nsw i32 %209, 1
  br label %208, !llvm.loop !33

235:                                              ; preds = %208, %205
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, argmem: none, inaccessiblemem: none)
define dso_local range(i32 0, 2) i32 @kcons_ready() local_unnamed_addr #0 {
  %1 = load i32, ptr @cons_r, align 4, !tbaa !9
  %2 = load i32, ptr @cons_w, align 4, !tbaa !9
  %3 = icmp ne i32 %1, %2
  %4 = zext i1 %3 to i32
  ret i32 %4
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
  %7 = load i32, ptr %6, align 4, !tbaa !12
  %8 = icmp eq i32 %7, 2
  br i1 %8, label %9, label %13

9:                                                ; preds = %5
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 12
  %11 = load i32, ptr %10, align 4, !tbaa !16
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
  %4 = load i32, ptr %3, align 4, !tbaa !25
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
  %5 = load i32, ptr %4, align 4, !tbaa !25
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
  %5 = load i32, ptr %4, align 4, !tbaa !25
  %6 = inttoptr i32 %5 to ptr
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 16
  store volatile i32 %1, ptr %7, align 4, !tbaa !26
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store volatile i32 1, ptr %8, align 4, !tbaa !28
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 24
  %10 = load i32, ptr %9, align 4, !tbaa !29
  %11 = add i32 %10, -84
  %12 = inttoptr i32 %11 to ptr
  store volatile i32 %1, ptr %12, align 4, !tbaa !9
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 12
  store i32 0, ptr %13, align 4, !tbaa !16
  store i32 3, ptr %3, align 4, !tbaa !12
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
  store i32 %0, ptr %9, align 4, !tbaa !16
  store i32 2, ptr %3, align 4, !tbaa !12
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dma_ktick() local_unnamed_addr #1 {
  tail call fastcc void @kenter() #11
  tail call fastcc void @fire_income() #11
  %1 = load i32, ptr @waspark, align 4, !tbaa !9
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %17

3:                                                ; preds = %0
  %4 = load i32, ptr @curr, align 4, !tbaa !9
  %5 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %7 = load i32, ptr %6, align 4, !tbaa !30
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %16

9:                                                ; preds = %3
  %10 = load volatile ptr, ptr @kw_curresume, align 4, !tbaa !37
  %11 = load i32, ptr %10, align 4, !tbaa !9
  %12 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %11, ptr %12, align 4, !tbaa !36
  %13 = load i32, ptr %5, align 4, !tbaa !12
  %14 = icmp eq i32 %13, 4
  br i1 %14, label %15, label %17

15:                                               ; preds = %9
  store i32 3, ptr %5, align 4, !tbaa !12
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
  store i1 false, ptr @tick_taken, align 4
  tail call void @kcons_aim(i32 noundef 0) #12
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
  %22 = load i32, ptr %21, align 4, !tbaa !29
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
  tail call fastcc void @fire_income() #11
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
  tail call fastcc void @fire_income() #11
  br label %35

35:                                               ; preds = %34, %29
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fire_income() unnamed_addr #1 {
  %1 = tail call i32 @kcons_on() #12
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call fastcc void @tick_income() #11
  br label %17

4:                                                ; preds = %0
  %5 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %6 = add i32 %5, 4
  %7 = inttoptr i32 %6 to ptr
  %8 = load volatile i32, ptr %7, align 4, !tbaa !9
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %13

10:                                               ; preds = %4
  %11 = load i1, ptr @tick_taken, align 4
  br i1 %11, label %13, label %12

12:                                               ; preds = %10
  store i1 true, ptr @tick_taken, align 4
  tail call fastcc void @tick_income() #11
  br label %13

13:                                               ; preds = %12, %10, %4
  %14 = load i32, ptr @fgpid, align 4, !tbaa !9
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %17, label %16

16:                                               ; preds = %13
  tail call fastcc void @cons_poll() #11
  br label %17

17:                                               ; preds = %3, %16, %13
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
  %10 = load i32, ptr %9, align 4, !tbaa !14
  %11 = icmp eq i32 %8, %10
  br i1 %11, label %12, label %13

12:                                               ; preds = %7
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !9
  br label %13

13:                                               ; preds = %12, %7, %2
  %14 = tail call i32 @kfb_owner() #12
  %15 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %16 = load i32, ptr %15, align 4, !tbaa !14
  %17 = icmp eq i32 %14, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %13
  tail call void @kfb_setowner(i32 noundef 0) #12
  tail call void @kfbcon_reset() #12
  br label %19

19:                                               ; preds = %18, %13
  %20 = getelementptr inbounds nuw i8, ptr %0, i32 20
  store i32 %1, ptr %20, align 4, !tbaa !41
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
  %32 = load i32, ptr %31, align 4, !tbaa !12
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %44, label %34

34:                                               ; preds = %30
  %35 = icmp eq ptr %31, %0
  br i1 %35, label %44, label %36

36:                                               ; preds = %34
  %37 = getelementptr inbounds nuw i8, ptr %31, i32 8
  %38 = load i32, ptr %37, align 4, !tbaa !17
  %39 = load i32, ptr %15, align 4, !tbaa !14
  %40 = icmp eq i32 %38, %39
  br i1 %40, label %41, label %44

41:                                               ; preds = %36
  store i32 %25, ptr %37, align 4, !tbaa !17
  %42 = icmp eq i32 %32, 5
  br i1 %42, label %43, label %44

43:                                               ; preds = %41
  store i32 0, ptr %31, align 4, !tbaa !12
  br label %44

44:                                               ; preds = %41, %43, %36, %34, %30
  %45 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !42

46:                                               ; preds = %27, %24
  %47 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %48 = load i32, ptr %47, align 4, !tbaa !17
  br label %49

49:                                               ; preds = %79, %46
  %50 = phi i32 [ 0, %46 ], [ %80, %79 ]
  %51 = icmp eq i32 %50, 8
  br i1 %51, label %90, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %50
  %54 = getelementptr inbounds nuw i8, ptr %53, i32 4
  %55 = load i32, ptr %54, align 4, !tbaa !14
  %56 = icmp eq i32 %55, %48
  br i1 %56, label %57, label %79

57:                                               ; preds = %52
  %58 = load i32, ptr %53, align 4, !tbaa !12
  %59 = icmp eq i32 %58, 2
  br i1 %59, label %60, label %79

60:                                               ; preds = %57
  %61 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %62 = load i32, ptr %61, align 4, !tbaa !16
  %63 = ptrtoint ptr %53 to i32
  %64 = icmp eq i32 %62, %63
  br i1 %64, label %65, label %79

65:                                               ; preds = %60
  %66 = getelementptr inbounds nuw i8, ptr %53, i32 12
  %67 = getelementptr inbounds nuw i8, ptr %53, i32 44
  %68 = load i32, ptr %67, align 4, !tbaa !25
  %69 = inttoptr i32 %68 to ptr
  %70 = getelementptr inbounds nuw i8, ptr %69, i32 4
  %71 = load volatile i32, ptr %70, align 4, !tbaa !32
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %81, label %73

73:                                               ; preds = %65
  %74 = load i32, ptr %20, align 4, !tbaa !41
  %75 = load volatile i32, ptr %70, align 4, !tbaa !32
  %76 = inttoptr i32 %75 to ptr
  store volatile i32 %74, ptr %76, align 4, !tbaa !9
  %77 = load i32, ptr %67, align 4, !tbaa !25
  %78 = inttoptr i32 %77 to ptr
  br label %81

79:                                               ; preds = %60, %57, %52
  %80 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !43

81:                                               ; preds = %73, %65
  %82 = phi ptr [ %78, %73 ], [ %69, %65 ]
  %83 = load i32, ptr %15, align 4, !tbaa !14
  %84 = getelementptr inbounds nuw i8, ptr %82, i32 16
  store volatile i32 %83, ptr %84, align 4, !tbaa !26
  %85 = getelementptr inbounds nuw i8, ptr %82, i32 20
  store volatile i32 1, ptr %85, align 4, !tbaa !28
  %86 = getelementptr inbounds nuw i8, ptr %53, i32 24
  %87 = load i32, ptr %86, align 4, !tbaa !29
  %88 = add i32 %87, -84
  %89 = inttoptr i32 %88 to ptr
  store volatile i32 %83, ptr %89, align 4, !tbaa !9
  store i32 0, ptr %66, align 4, !tbaa !16
  store i32 3, ptr %53, align 4, !tbaa !12
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
  store i32 %95, ptr %0, align 4, !tbaa !12
  %96 = getelementptr inbounds nuw i8, ptr %0, i32 48
  store i32 0, ptr %96, align 4, !tbaa !30
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @swtch() unnamed_addr #1 {
  %1 = load i32, ptr @curr, align 4
  br label %2

2:                                                ; preds = %5, %0
  %3 = phi i32 [ 1, %0 ], [ %11, %5 ]
  %4 = icmp eq i32 %3, 9
  br i1 %4, label %12, label %5

5:                                                ; preds = %2
  %6 = add i32 %3, %1
  %7 = and i32 %6, 7
  %8 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7
  %9 = load i32, ptr %8, align 4, !tbaa !12
  %10 = icmp eq i32 %9, 3
  %11 = add nuw nsw i32 %3, 1
  br i1 %10, label %59, label %2, !llvm.loop !44

12:                                               ; preds = %2
  %13 = load i32, ptr @entry_disp, align 4, !tbaa !9
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %12
  %16 = inttoptr i32 %13 to ptr
  %17 = load volatile i32, ptr %16, align 4, !tbaa !9
  %18 = load i32, ptr @entry_thunk, align 4, !tbaa !9
  %19 = icmp eq i32 %17, %18
  br i1 %19, label %21, label %20

20:                                               ; preds = %15
  store volatile i32 %18, ptr %16, align 4, !tbaa !9
  tail call fastcc void @fire_income() #11
  br label %21

21:                                               ; preds = %20, %15, %12
  %22 = load volatile ptr, ptr @kw_park, align 4, !tbaa !37
  %23 = ptrtoint ptr %22 to i32
  %24 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  store i32 %23, ptr %24, align 4, !tbaa !9
  %25 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %26 = ptrtoint ptr %25 to i32
  %27 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !37
  store i32 %26, ptr %27, align 4, !tbaa !9
  %28 = load volatile ptr, ptr @kw_park, align 4, !tbaa !37
  %29 = ptrtoint ptr %28 to i32
  %30 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !37
  store i32 %29, ptr %30, align 4, !tbaa !9
  %31 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %32 = ptrtoint ptr %31 to i32
  %33 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !37
  store i32 %32, ptr %33, align 4, !tbaa !9
  %34 = load volatile ptr, ptr @kw_park, align 4, !tbaa !37
  %35 = ptrtoint ptr %34 to i32
  %36 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !37
  store i32 %35, ptr %36, align 4, !tbaa !9
  %37 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %38 = ptrtoint ptr %37 to i32
  %39 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %40 = inttoptr i32 %39 to ptr
  store volatile i32 %38, ptr %40, align 4, !tbaa !9
  store i1 true, ptr @parked, align 4
  %41 = load i32, ptr @tickpending, align 4, !tbaa !9
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %44, label %43

43:                                               ; preds = %21
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @fire_income() #11
  br label %44

44:                                               ; preds = %43, %21
  %45 = tail call i32 @kcons_on() #12
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %54, label %47

47:                                               ; preds = %44
  %48 = load i32, ptr @fgpid, align 4, !tbaa !9
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %51, label %50

50:                                               ; preds = %47
  tail call fastcc void @cons_poll() #11
  br label %51

51:                                               ; preds = %50, %47
  tail call void @kcons_kick() #12
  %52 = load volatile ptr, ptr @kw_parkvec, align 4, !tbaa !37
  %53 = ptrtoint ptr %52 to i32
  tail call void @kcons_aim(i32 noundef %53) #12
  br label %54

54:                                               ; preds = %51, %44
  %55 = load i1, ptr @rearm, align 4
  br i1 %55, label %56, label %62

56:                                               ; preds = %54
  %57 = load i32, ptr @inj_treg, align 4, !tbaa !9
  %58 = inttoptr i32 %57 to ptr
  store volatile i32 1, ptr %58, align 4, !tbaa !9
  br label %62

59:                                               ; preds = %5
  %60 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %7, i32 10
  %61 = load i32, ptr %60, align 4, !tbaa !36
  tail call fastcc void @kexit(i32 noundef %7, i32 noundef %61) #11
  br label %62

62:                                               ; preds = %54, %56, %59
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
  %7 = load i32, ptr %6, align 4, !tbaa !30
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %10, label %9

9:                                                ; preds = %0
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #11
  tail call fastcc void @swtch() #11
  br label %962

10:                                               ; preds = %0
  %11 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %12 = load i32, ptr %11, align 4, !tbaa !25
  %13 = inttoptr i32 %12 to ptr
  %14 = load volatile i32, ptr %13, align 4, !tbaa !45
  switch i32 %14, label %932 [
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
    i32 34, label %266
    i32 3, label %17
    i32 1, label %372
    i32 7, label %402
    i32 2, label %699
    i32 26, label %702
    i32 27, label %711
    i32 25, label %718
    i32 28, label %806
    i32 29, label %815
    i32 30, label %823
    i32 31, label %829
    i32 32, label %856
    i32 23, label %881
    i32 24, label %886
    i32 6, label %15
  ]

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 4
  br label %908

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %324

19:                                               ; preds = %10
  %20 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %21 = load i32, ptr %20, align 4, !tbaa !14
  br label %932

22:                                               ; preds = %10
  %23 = load i32, ptr @ticks, align 4, !tbaa !9
  br label %932

24:                                               ; preds = %10
  %25 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %26 = load volatile i32, ptr %25, align 4, !tbaa !46
  %27 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %28 = load volatile i32, ptr %27, align 4, !tbaa !47
  %29 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %26, i32 noundef %28) #11
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %932

31:                                               ; preds = %24
  %32 = load i32, ptr @fsready, align 4, !tbaa !9
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %40, label %34

34:                                               ; preds = %31
  %35 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %36 = load volatile i32, ptr %35, align 4, !tbaa !32
  %37 = load volatile i32, ptr %25, align 4, !tbaa !46
  %38 = load volatile i32, ptr %27, align 4, !tbaa !47
  %39 = tail call i32 @kfs_write(i32 noundef %36, i32 noundef %37, i32 noundef %38) #12
  br label %45

40:                                               ; preds = %31
  %41 = load volatile i32, ptr %25, align 4, !tbaa !46
  %42 = inttoptr i32 %41 to ptr
  %43 = load volatile i32, ptr %27, align 4, !tbaa !47
  tail call void @kconswrite(ptr noundef %42, i32 noundef %43) #11
  %44 = load volatile i32, ptr %27, align 4, !tbaa !47
  br label %45

45:                                               ; preds = %34, %40
  %46 = phi i32 [ %39, %34 ], [ %44, %40 ]
  %47 = freeze i32 %46
  %48 = icmp eq i32 %47, -3
  br i1 %48, label %947, label %932

49:                                               ; preds = %10
  %50 = load i32, ptr @fsready, align 4, !tbaa !9
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %932, label %52

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %54 = load volatile i32, ptr %53, align 4, !tbaa !32
  %55 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %56 = load volatile i32, ptr %55, align 4, !tbaa !46
  %57 = tail call i32 @kfs_open(i32 noundef %54, i32 noundef %56) #12
  br label %932

58:                                               ; preds = %10
  %59 = load i32, ptr @fsready, align 4, !tbaa !9
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %932, label %61

61:                                               ; preds = %58
  %62 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %63 = load volatile i32, ptr %62, align 4, !tbaa !32
  %64 = tail call i32 @kfs_close(i32 noundef %63) #12
  br label %932

65:                                               ; preds = %10
  %66 = load i32, ptr @fsready, align 4, !tbaa !9
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %932, label %68

68:                                               ; preds = %65
  %69 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %70 = load volatile i32, ptr %69, align 4, !tbaa !32
  %71 = tail call i32 @kfs_dup(i32 noundef %70) #12
  br label %932

72:                                               ; preds = %10
  %73 = load i32, ptr @fsready, align 4, !tbaa !9
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %932, label %75

75:                                               ; preds = %72
  %76 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %77 = load volatile i32, ptr %76, align 4, !tbaa !32
  %78 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %79 = load volatile i32, ptr %78, align 4, !tbaa !46
  %80 = tail call i32 @kfs_fstat(i32 noundef %77, i32 noundef %79) #12
  br label %932

81:                                               ; preds = %10
  %82 = load i32, ptr @fsready, align 4, !tbaa !9
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %932, label %84

84:                                               ; preds = %81
  %85 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %86 = load volatile i32, ptr %85, align 4, !tbaa !32
  %87 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %88 = load volatile i32, ptr %87, align 4, !tbaa !46
  %89 = tail call i32 @kfs_seek(i32 noundef %86, i32 noundef %88) #12
  br label %932

90:                                               ; preds = %10
  %91 = load i32, ptr @fsready, align 4, !tbaa !9
  %92 = icmp eq i32 %91, 0
  br i1 %92, label %932, label %93

93:                                               ; preds = %90
  %94 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %95 = load volatile i32, ptr %94, align 4, !tbaa !32
  %96 = tail call i32 @kfs_pipe(i32 noundef %95) #12
  br label %932

97:                                               ; preds = %10
  %98 = load i32, ptr @fsready, align 4, !tbaa !9
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %932, label %100

100:                                              ; preds = %97
  %101 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %102 = load volatile i32, ptr %101, align 4, !tbaa !32
  %103 = tail call i32 @kfs_chdir(i32 noundef %102) #12
  br label %932

104:                                              ; preds = %10
  %105 = load i32, ptr @fsready, align 4, !tbaa !9
  %106 = icmp eq i32 %105, 0
  br i1 %106, label %932, label %107

107:                                              ; preds = %104
  %108 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %109 = load volatile i32, ptr %108, align 4, !tbaa !32
  %110 = tail call i32 @kfs_mkdir(i32 noundef %109) #12
  br label %932

111:                                              ; preds = %10
  %112 = load i32, ptr @fsready, align 4, !tbaa !9
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %932, label %114

114:                                              ; preds = %111
  %115 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %116 = load volatile i32, ptr %115, align 4, !tbaa !32
  %117 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %118 = load volatile i32, ptr %117, align 4, !tbaa !46
  %119 = tail call i32 @kfs_link(i32 noundef %116, i32 noundef %118) #12
  br label %932

120:                                              ; preds = %10
  %121 = load i32, ptr @fsready, align 4, !tbaa !9
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %932, label %123

123:                                              ; preds = %120
  %124 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %125 = load volatile i32, ptr %124, align 4, !tbaa !32
  %126 = tail call i32 @kfs_unlink(i32 noundef %125) #12
  br label %932

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
  br label %932

134:                                              ; preds = %10
  %135 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %136 = load volatile i32, ptr %135, align 4, !tbaa !46
  %137 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %138 = load volatile i32, ptr %137, align 4, !tbaa !47
  %139 = tail call fastcc i32 @badbuf(ptr noundef nonnull %5, i32 noundef %136, i32 noundef %138) #11
  %140 = icmp eq i32 %139, 0
  br i1 %140, label %141, label %932

141:                                              ; preds = %134
  %142 = load i32, ptr @fsready, align 4, !tbaa !9
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %150, label %144

144:                                              ; preds = %141
  %145 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %146 = load volatile i32, ptr %145, align 4, !tbaa !32
  %147 = load volatile i32, ptr %135, align 4, !tbaa !46
  %148 = load volatile i32, ptr %137, align 4, !tbaa !47
  %149 = tail call i32 @kfs_read(i32 noundef %146, i32 noundef %147, i32 noundef %148) #12
  br label %154

150:                                              ; preds = %141
  %151 = load volatile i32, ptr %135, align 4, !tbaa !46
  %152 = load volatile i32, ptr %137, align 4, !tbaa !47
  %153 = tail call i32 @kconsread(i32 noundef %151, i32 noundef %152) #11
  br label %154

154:                                              ; preds = %144, %150
  %155 = phi i32 [ %149, %144 ], [ %153, %150 ]
  %156 = freeze i32 %155
  %157 = icmp eq i32 %156, -3
  br i1 %157, label %947, label %932

158:                                              ; preds = %10
  %159 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %160 = load volatile i32, ptr %159, align 4, !tbaa !32
  %161 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %162 = load i32, ptr %161, align 4, !tbaa !48
  %163 = icmp eq i32 %162, 0
  br i1 %163, label %164, label %186

164:                                              ; preds = %158
  %165 = icmp slt i32 %160, 0
  br i1 %165, label %932, label %166

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
  br i1 %179, label %932, label %180

180:                                              ; preds = %176
  %181 = load i32, ptr @curr, align 4, !tbaa !9
  %182 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %181
  store i32 %178, ptr %182, align 4, !tbaa !9
  %183 = getelementptr inbounds nuw i8, ptr %5, i32 60
  store i32 %178, ptr %183, align 4, !tbaa !49
  store i32 %178, ptr %161, align 4, !tbaa !48
  %184 = add i32 %178, %177
  %185 = getelementptr inbounds nuw i8, ptr %5, i32 56
  store i32 %184, ptr %185, align 4, !tbaa !50
  br label %193

186:                                              ; preds = %158
  %187 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %188 = load i32, ptr %187, align 4, !tbaa !49
  %189 = icmp sgt i32 %160, -1
  br i1 %189, label %190, label %209

190:                                              ; preds = %186
  %191 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %192 = load i32, ptr %191, align 4, !tbaa !50
  br label %193

193:                                              ; preds = %190, %180
  %194 = phi i32 [ %184, %180 ], [ %192, %190 ]
  %195 = phi i32 [ %178, %180 ], [ %188, %190 ]
  %196 = phi ptr [ %183, %180 ], [ %187, %190 ]
  %197 = sub i32 %194, %195
  %198 = icmp ugt i32 %160, %197
  br i1 %198, label %932, label %199

199:                                              ; preds = %193
  %200 = add i32 %195, %160
  br label %201

201:                                              ; preds = %206, %199
  %202 = phi i32 [ %208, %206 ], [ %195, %199 ]
  %203 = icmp ult i32 %202, %200
  br i1 %203, label %206, label %204

204:                                              ; preds = %201
  %205 = load i32, ptr %196, align 4, !tbaa !49
  br label %213

206:                                              ; preds = %201
  %207 = inttoptr i32 %202 to ptr
  store volatile i8 0, ptr %207, align 1, !tbaa !3
  %208 = add nuw i32 %202, 1
  br label %201, !llvm.loop !51

209:                                              ; preds = %186
  %210 = sub nsw i32 0, %160
  %211 = sub i32 %188, %162
  %212 = icmp ult i32 %211, %210
  br i1 %212, label %932, label %213

213:                                              ; preds = %209, %204
  %214 = phi i32 [ %195, %204 ], [ %188, %209 ]
  %215 = phi ptr [ %196, %204 ], [ %187, %209 ]
  %216 = phi i32 [ %205, %204 ], [ %188, %209 ]
  %217 = add i32 %216, %160
  store i32 %217, ptr %215, align 4, !tbaa !49
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
  br i1 %226, label %932, label %227

227:                                              ; preds = %224
  %228 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %225
  %229 = load i32, ptr %228, align 4, !tbaa !12
  %230 = icmp eq i32 %229, 2
  br i1 %230, label %231, label %235

231:                                              ; preds = %227
  %232 = getelementptr inbounds nuw i8, ptr %228, i32 12
  %233 = load i32, ptr %232, align 4, !tbaa !16
  %234 = icmp eq i32 %233, %221
  br i1 %234, label %237, label %235

235:                                              ; preds = %231, %227
  %236 = add nuw nsw i32 %225, 1
  br label %224, !llvm.loop !52

237:                                              ; preds = %231
  %238 = getelementptr inbounds nuw i8, ptr %228, i32 52
  %239 = load i32, ptr %238, align 4, !tbaa !48
  %240 = load i32, ptr %161, align 4, !tbaa !48
  %241 = icmp eq i32 %239, %240
  br i1 %241, label %247, label %242

242:                                              ; preds = %237
  store i32 %240, ptr %238, align 4, !tbaa !48
  %243 = load i32, ptr %218, align 4, !tbaa !50
  %244 = getelementptr inbounds nuw i8, ptr %228, i32 56
  store i32 %243, ptr %244, align 4, !tbaa !50
  %245 = load i32, ptr %161, align 4, !tbaa !48
  %246 = getelementptr inbounds nuw i8, ptr %228, i32 60
  store i32 %245, ptr %246, align 4, !tbaa !49
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
  br label %219, !llvm.loop !53

254:                                              ; preds = %10
  %255 = load i32, ptr @ticks, align 4, !tbaa !9
  %256 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %257 = load volatile i32, ptr %256, align 4, !tbaa !32
  %258 = add i32 %257, %255
  %259 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %258, ptr %259, align 4, !tbaa !54
  %260 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %261 = load i32, ptr %260, align 4, !tbaa !35
  %262 = inttoptr i32 %261 to ptr
  %263 = load volatile i32, ptr %262, align 4, !tbaa !9
  %264 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %263, ptr %264, align 4, !tbaa !36
  %265 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 ptrtoint (ptr @ticks to i32), ptr %265, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !12
  br label %951

266:                                              ; preds = %10
  %267 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %268 = load volatile i32, ptr %267, align 4, !tbaa !32
  br label %269

269:                                              ; preds = %293, %266
  %270 = phi i32 [ 0, %266 ], [ %295, %293 ]
  %271 = phi i32 [ 0, %266 ], [ %294, %293 ]
  %272 = icmp eq i32 %270, 31
  br i1 %272, label %273, label %275

273:                                              ; preds = %269
  %274 = icmp eq i32 %271, 0
  br i1 %274, label %296, label %932

275:                                              ; preds = %269
  %276 = shl nuw nsw i32 1, %270
  %277 = and i32 %276, %268
  %278 = icmp eq i32 %277, 0
  br i1 %278, label %293, label %279

279:                                              ; preds = %275
  %280 = load i32, ptr @fsready, align 4, !tbaa !9
  %281 = icmp eq i32 %280, 0
  br i1 %281, label %285, label %282

282:                                              ; preds = %279
  %283 = tail call i32 @kfs_selready(i32 noundef %270) #12
  %284 = icmp eq i32 %283, 0
  br label %289

285:                                              ; preds = %279
  %286 = load i32, ptr @cons_r, align 4, !tbaa !9
  %287 = load i32, ptr @cons_w, align 4, !tbaa !9
  %288 = icmp eq i32 %286, %287
  br label %289

289:                                              ; preds = %285, %282
  %290 = phi i1 [ %284, %282 ], [ %288, %285 ]
  %291 = select i1 %290, i32 0, i32 %276
  %292 = or i32 %291, %271
  br label %293

293:                                              ; preds = %275, %289
  %294 = phi i32 [ %292, %289 ], [ %271, %275 ]
  %295 = add nuw nsw i32 %270, 1
  br label %269, !llvm.loop !55

296:                                              ; preds = %273
  %297 = icmp eq i32 %268, 0
  br i1 %297, label %932, label %298

298:                                              ; preds = %296
  %299 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %300 = load volatile i32, ptr %299, align 4, !tbaa !46
  %301 = icmp eq i32 %300, 0
  br i1 %301, label %315, label %302

302:                                              ; preds = %298
  %303 = load i32, ptr @ticks, align 4, !tbaa !9
  %304 = load volatile i32, ptr %299, align 4, !tbaa !46
  %305 = add i32 %304, %303
  %306 = getelementptr inbounds nuw i8, ptr %5, i32 16
  store i32 %305, ptr %306, align 4, !tbaa !54
  %307 = load i32, ptr @curr, align 4, !tbaa !9
  %308 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %307
  %309 = getelementptr inbounds nuw i8, ptr %308, i32 32
  %310 = load i32, ptr %309, align 4, !tbaa !35
  %311 = inttoptr i32 %310 to ptr
  %312 = load volatile i32, ptr %311, align 4, !tbaa !9
  %313 = getelementptr inbounds nuw i8, ptr %308, i32 40
  store i32 %312, ptr %313, align 4, !tbaa !36
  %314 = getelementptr inbounds nuw i8, ptr %308, i32 12
  store i32 ptrtoint (ptr @selwait_to to i32), ptr %314, align 4, !tbaa !16
  store i32 2, ptr %308, align 4, !tbaa !12
  br label %947

315:                                              ; preds = %298
  %316 = load i32, ptr @curr, align 4, !tbaa !9
  %317 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %316
  %318 = getelementptr inbounds nuw i8, ptr %317, i32 32
  %319 = load i32, ptr %318, align 4, !tbaa !35
  %320 = inttoptr i32 %319 to ptr
  %321 = load volatile i32, ptr %320, align 4, !tbaa !9
  %322 = getelementptr inbounds nuw i8, ptr %317, i32 40
  store i32 %321, ptr %322, align 4, !tbaa !36
  %323 = getelementptr inbounds nuw i8, ptr %317, i32 12
  store i32 ptrtoint (ptr @selwait_inf to i32), ptr %323, align 4, !tbaa !16
  store i32 2, ptr %317, align 4, !tbaa !12
  br label %947

324:                                              ; preds = %17, %343
  %325 = phi i32 [ %346, %343 ], [ 0, %17 ]
  %326 = phi i32 [ %344, %343 ], [ -1, %17 ]
  %327 = phi i32 [ %345, %343 ], [ 0, %17 ]
  %328 = icmp eq i32 %325, 8
  br i1 %328, label %329, label %331

329:                                              ; preds = %324
  %330 = icmp sgt i32 %326, -1
  br i1 %330, label %347, label %360

331:                                              ; preds = %324
  %332 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %325
  %333 = load i32, ptr %332, align 4, !tbaa !12
  %334 = icmp eq i32 %333, 0
  br i1 %334, label %343, label %335

335:                                              ; preds = %331
  %336 = getelementptr inbounds nuw i8, ptr %332, i32 8
  %337 = load i32, ptr %336, align 4, !tbaa !17
  %338 = load i32, ptr %18, align 4, !tbaa !14
  %339 = icmp eq i32 %337, %338
  br i1 %339, label %340, label %343

340:                                              ; preds = %335
  %341 = icmp eq i32 %333, 5
  %342 = select i1 %341, i32 %325, i32 %326
  br label %343

343:                                              ; preds = %340, %331, %335
  %344 = phi i32 [ %326, %335 ], [ %326, %331 ], [ %342, %340 ]
  %345 = phi i32 [ %327, %335 ], [ %327, %331 ], [ 1, %340 ]
  %346 = add nuw nsw i32 %325, 1
  br label %324, !llvm.loop !56

347:                                              ; preds = %329
  %348 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %349 = load volatile i32, ptr %348, align 4, !tbaa !32
  %350 = icmp eq i32 %349, 0
  br i1 %350, label %356, label %351

351:                                              ; preds = %347
  %352 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %326, i32 5
  %353 = load i32, ptr %352, align 4, !tbaa !41
  %354 = load volatile i32, ptr %348, align 4, !tbaa !32
  %355 = inttoptr i32 %354 to ptr
  store volatile i32 %353, ptr %355, align 4, !tbaa !9
  br label %356

356:                                              ; preds = %351, %347
  %357 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %326
  %358 = getelementptr inbounds nuw i8, ptr %357, i32 4
  %359 = load i32, ptr %358, align 4, !tbaa !14
  store i32 0, ptr %357, align 4, !tbaa !12
  br label %932

360:                                              ; preds = %329
  %361 = icmp eq i32 %327, 0
  br i1 %361, label %932, label %362

362:                                              ; preds = %360
  %363 = ptrtoint ptr %5 to i32
  %364 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %365 = load i32, ptr %364, align 4, !tbaa !35
  %366 = inttoptr i32 %365 to ptr
  %367 = load volatile i32, ptr %366, align 4, !tbaa !9
  %368 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %367, ptr %368, align 4, !tbaa !36
  %369 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %363, ptr %369, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !12
  %370 = getelementptr inbounds nuw i8, ptr %13, i32 16
  %371 = load volatile i32, ptr %370, align 4, !tbaa !26
  br label %951

372:                                              ; preds = %10, %379
  %373 = phi i32 [ %380, %379 ], [ 0, %10 ]
  %374 = icmp eq i32 %373, 8
  br i1 %374, label %932, label %375

375:                                              ; preds = %372
  %376 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %373
  %377 = load i32, ptr %376, align 4, !tbaa !12
  %378 = icmp eq i32 %377, 0
  br i1 %378, label %381, label %379

379:                                              ; preds = %375
  %380 = add nuw nsw i32 %373, 1
  br label %372, !llvm.loop !57

381:                                              ; preds = %375
  tail call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(72) %376, ptr noundef nonnull align 4 dereferenceable(72) %5, i32 72, i1 false), !tbaa.struct !58
  %382 = load i32, ptr @fsready, align 4, !tbaa !9
  %383 = icmp eq i32 %382, 0
  br i1 %383, label %385, label %384

384:                                              ; preds = %381
  tail call void @kfs_forkcopy(i32 noundef %4, i32 noundef %373) #12
  br label %385

385:                                              ; preds = %384, %381
  %386 = load i32, ptr @nextpid, align 4, !tbaa !9
  %387 = add i32 %386, 1
  store i32 %387, ptr @nextpid, align 4, !tbaa !9
  %388 = getelementptr inbounds nuw i8, ptr %376, i32 4
  store i32 %386, ptr %388, align 4, !tbaa !14
  %389 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %390 = load i32, ptr %389, align 4, !tbaa !14
  %391 = getelementptr inbounds nuw i8, ptr %376, i32 8
  store i32 %390, ptr %391, align 4, !tbaa !17
  %392 = getelementptr inbounds nuw i8, ptr %376, i32 12
  store i32 0, ptr %392, align 4, !tbaa !16
  store i32 3, ptr %376, align 4, !tbaa !12
  %393 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %394 = load i32, ptr %393, align 4, !tbaa !35
  %395 = inttoptr i32 %394 to ptr
  %396 = load volatile i32, ptr %395, align 4, !tbaa !9
  %397 = getelementptr inbounds nuw i8, ptr %376, i32 40
  store i32 %396, ptr %397, align 4, !tbaa !36
  %398 = load volatile i32, ptr %395, align 4, !tbaa !9
  %399 = getelementptr inbounds nuw i8, ptr %5, i32 40
  store i32 %398, ptr %399, align 4, !tbaa !36
  %400 = ptrtoint ptr %376 to i32
  %401 = getelementptr inbounds nuw i8, ptr %5, i32 12
  store i32 %400, ptr %401, align 4, !tbaa !16
  store i32 2, ptr %5, align 4, !tbaa !12
  br label %951

402:                                              ; preds = %10
  call void @llvm.lifetime.start.p0(i64 72, ptr nonnull %1) #13
  %403 = load i32, ptr @fsready, align 4, !tbaa !9
  %404 = icmp eq i32 %403, 0
  br i1 %404, label %500, label %405

405:                                              ; preds = %402
  %406 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %407 = load volatile i32, ptr %406, align 4, !tbaa !32
  %408 = inttoptr i32 %407 to ptr
  %409 = tail call i32 @kfs_iopen(ptr noundef %408) #12
  %410 = icmp eq i32 %409, 0
  br i1 %410, label %500, label %411

411:                                              ; preds = %405
  call void @llvm.lifetime.start.p0(i64 52, ptr nonnull %2) #13
  %412 = ptrtoint ptr %2 to i32
  %413 = call i32 @kfs_iread(i32 noundef %409, i32 noundef 0, i32 noundef %412, i32 noundef 52) #12
  %414 = icmp eq i32 %413, 52
  %415 = load i32, ptr %2, align 4
  %416 = icmp eq i32 %415, 1480674628
  %417 = select i1 %414, i1 %416, i1 false
  br i1 %417, label %418, label %498

418:                                              ; preds = %411
  %419 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %420 = load i32, ptr %419, align 4, !tbaa !9
  %421 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %422 = load i32, ptr %421, align 4, !tbaa !9
  %423 = getelementptr inbounds nuw i8, ptr %2, i32 12
  %424 = load i32, ptr %423, align 4, !tbaa !9
  %425 = getelementptr inbounds nuw i8, ptr %2, i32 16
  %426 = load i32, ptr %425, align 4, !tbaa !9
  %427 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %428 = load i32, ptr %427, align 4, !tbaa !9
  %429 = getelementptr inbounds nuw i8, ptr %1, i32 40
  %430 = getelementptr inbounds nuw i8, ptr %2, i32 24
  %431 = load i32, ptr %430, align 4, !tbaa !9
  %432 = getelementptr inbounds nuw i8, ptr %1, i32 44
  store i32 %431, ptr %432, align 4, !tbaa !59
  %433 = getelementptr inbounds nuw i8, ptr %2, i32 28
  %434 = load i32, ptr %433, align 4, !tbaa !9
  %435 = getelementptr inbounds nuw i8, ptr %1, i32 48
  store i32 %434, ptr %435, align 4, !tbaa !61
  %436 = getelementptr inbounds nuw i8, ptr %2, i32 32
  %437 = load i32, ptr %436, align 4, !tbaa !9
  %438 = getelementptr inbounds nuw i8, ptr %1, i32 52
  store i32 %437, ptr %438, align 4, !tbaa !62
  %439 = getelementptr inbounds nuw i8, ptr %2, i32 36
  %440 = load i32, ptr %439, align 4, !tbaa !9
  %441 = getelementptr inbounds nuw i8, ptr %1, i32 56
  store i32 %440, ptr %441, align 4, !tbaa !63
  %442 = getelementptr inbounds nuw i8, ptr %2, i32 40
  %443 = load i32, ptr %442, align 4, !tbaa !9
  %444 = getelementptr inbounds nuw i8, ptr %1, i32 60
  store i32 %443, ptr %444, align 4, !tbaa !64
  %445 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %446 = load i32, ptr %445, align 4, !tbaa !9
  %447 = getelementptr inbounds nuw i8, ptr %1, i32 64
  store i32 %446, ptr %447, align 4, !tbaa !65
  %448 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %449 = load i32, ptr %448, align 4, !tbaa !9
  %450 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %449, ptr %450, align 4, !tbaa !66
  %451 = call fastcc i32 @kalloc(i32 noundef %420) #11
  %452 = call fastcc i32 @kalloc(i32 noundef %422) #11
  %453 = add i32 %420, 52
  %454 = add i32 %422, %453
  %455 = icmp ne i32 %451, 0
  %456 = icmp ne i32 %452, 0
  %457 = select i1 %455, i1 %456, i1 false
  br i1 %457, label %458, label %464

458:                                              ; preds = %418
  %459 = call i32 @kfs_iread(i32 noundef %409, i32 noundef 52, i32 noundef %451, i32 noundef %420) #12
  %460 = icmp eq i32 %459, %420
  br i1 %460, label %461, label %464

461:                                              ; preds = %458
  %462 = call i32 @kfs_iread(i32 noundef %409, i32 noundef %453, i32 noundef %452, i32 noundef %422) #12
  %463 = icmp eq i32 %462, %422
  br i1 %463, label %465, label %464

464:                                              ; preds = %461, %458, %418
  call fastcc void @kfree(i32 noundef %451) #11
  call fastcc void @kfree(i32 noundef %452) #11
  br label %498

465:                                              ; preds = %461
  %466 = sub i32 %451, %424
  %467 = sub i32 %452, %426
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #13
  %468 = ptrtoint ptr %3 to i32
  br label %469

469:                                              ; preds = %495, %465
  %470 = phi i32 [ %454, %465 ], [ %497, %495 ]
  %471 = phi i32 [ %428, %465 ], [ %496, %495 ]
  %472 = icmp eq i32 %471, 0
  br i1 %472, label %499, label %473

473:                                              ; preds = %469
  %474 = call i32 @llvm.umin.i32(i32 %471, i32 64)
  %475 = shl nuw nsw i32 %474, 2
  %476 = call i32 @kfs_iread(i32 noundef %409, i32 noundef %470, i32 noundef %468, i32 noundef %475) #12
  %477 = icmp eq i32 %476, %475
  br i1 %477, label %478, label %499

478:                                              ; preds = %473, %481
  %479 = phi i32 [ %494, %481 ], [ 0, %473 ]
  %480 = icmp eq i32 %479, %474
  br i1 %480, label %495, label %481

481:                                              ; preds = %478
  %482 = getelementptr inbounds nuw [64 x i32], ptr %3, i32 0, i32 %479
  %483 = load i32, ptr %482, align 4, !tbaa !9
  %484 = icmp slt i32 %483, 0
  %485 = select i1 %484, i32 %452, i32 %451
  %486 = and i32 %483, 1073741823
  %487 = add i32 %485, %486
  %488 = and i32 %483, 1073741824
  %489 = icmp eq i32 %488, 0
  %490 = select i1 %489, i32 %466, i32 %467
  %491 = inttoptr i32 %487 to ptr
  %492 = load volatile i32, ptr %491, align 4, !tbaa !9
  %493 = add i32 %490, %492
  store volatile i32 %493, ptr %491, align 4, !tbaa !9
  %494 = add nuw nsw i32 %479, 1
  br label %478, !llvm.loop !67

495:                                              ; preds = %478
  %496 = sub i32 %471, %474
  %497 = add i32 %475, %470
  br label %469

498:                                              ; preds = %411, %464
  call void @kfs_iclose(i32 noundef %409) #12
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #13
  br label %658

499:                                              ; preds = %473, %469
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #13
  call void @kfs_iclose(i32 noundef %409) #12
  store i32 0, ptr %429, align 4, !tbaa !68
  call void @llvm.lifetime.end.p0(i64 52, ptr nonnull %2) #13
  br label %556

500:                                              ; preds = %402, %405
  %501 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %502 = load volatile i32, ptr %501, align 4, !tbaa !32
  %503 = inttoptr i32 %502 to ptr
  br label %504

504:                                              ; preds = %523, %500
  %505 = phi i32 [ 0, %500 ], [ %524, %523 ]
  %506 = icmp eq i32 %505, 24
  br i1 %506, label %658, label %507

507:                                              ; preds = %504
  %508 = getelementptr inbounds nuw [24 x %struct.kimg], ptr @kimages, i32 0, i32 %505
  %509 = load i8, ptr %508, align 4, !tbaa !3
  %510 = icmp eq i8 %509, 0
  br i1 %510, label %658, label %511

511:                                              ; preds = %507, %520
  %512 = phi i32 [ %522, %520 ], [ 0, %507 ]
  %513 = icmp eq i32 %512, 12
  br i1 %513, label %525, label %514

514:                                              ; preds = %511
  %515 = getelementptr inbounds nuw [12 x i8], ptr %508, i32 0, i32 %512
  %516 = load i8, ptr %515, align 1, !tbaa !3
  %517 = getelementptr inbounds nuw i8, ptr %503, i32 %512
  %518 = load i8, ptr %517, align 1, !tbaa !3
  %519 = icmp eq i8 %516, %518
  br i1 %519, label %520, label %523

520:                                              ; preds = %514
  %521 = icmp eq i8 %516, 0
  %522 = add nuw nsw i32 %512, 1
  br i1 %521, label %525, label %511, !llvm.loop !69

523:                                              ; preds = %514
  %524 = add nuw nsw i32 %505, 1
  br label %504, !llvm.loop !70

525:                                              ; preds = %520, %511
  %526 = getelementptr inbounds nuw i8, ptr %508, i32 16
  %527 = load i32, ptr %526, align 4, !tbaa !71
  %528 = tail call fastcc i32 @kalloc(i32 noundef %527) #11
  %529 = getelementptr inbounds nuw i8, ptr %508, i32 24
  %530 = load i32, ptr %529, align 4, !tbaa !72
  %531 = tail call fastcc i32 @kalloc(i32 noundef %530) #11
  %532 = icmp ne i32 %528, 0
  %533 = icmp ne i32 %531, 0
  %534 = select i1 %532, i1 %533, i1 false
  br i1 %534, label %536, label %535

535:                                              ; preds = %525
  tail call fastcc void @kfree(i32 noundef %528) #11
  tail call fastcc void @kfree(i32 noundef %531) #11
  br label %658

536:                                              ; preds = %525
  %537 = getelementptr inbounds nuw i8, ptr %508, i32 12
  %538 = load i32, ptr %537, align 4, !tbaa !73
  %539 = load i32, ptr %526, align 4, !tbaa !71
  %540 = add i32 %539, 3
  %541 = and i32 %540, -4
  tail call void @kdmacpy(i32 noundef %528, i32 noundef %538, i32 noundef %541) #12
  %542 = getelementptr inbounds nuw i8, ptr %508, i32 20
  %543 = load i32, ptr %542, align 4, !tbaa !74
  %544 = load i32, ptr %529, align 4, !tbaa !72
  %545 = add i32 %544, 3
  %546 = and i32 %545, -4
  tail call void @kdmacpy(i32 noundef %531, i32 noundef %543, i32 noundef %546) #12
  %547 = getelementptr inbounds nuw i8, ptr %508, i32 28
  %548 = load i32, ptr %547, align 4, !tbaa !75
  %549 = getelementptr inbounds nuw i8, ptr %508, i32 32
  %550 = load i32, ptr %549, align 4, !tbaa !76
  %551 = getelementptr inbounds nuw i8, ptr %508, i32 36
  %552 = load i32, ptr %551, align 4, !tbaa !77
  %553 = sub i32 %528, %548
  %554 = sub i32 %531, %550
  %555 = inttoptr i32 %552 to ptr
  br label %556

556:                                              ; preds = %499, %536
  %557 = phi i32 [ %467, %499 ], [ %554, %536 ]
  %558 = phi i32 [ %466, %499 ], [ %553, %536 ]
  %559 = phi ptr [ null, %499 ], [ %555, %536 ]
  %560 = phi i32 [ %452, %499 ], [ %531, %536 ]
  %561 = phi i32 [ %451, %499 ], [ %528, %536 ]
  %562 = phi ptr [ %1, %499 ], [ %508, %536 ]
  %563 = getelementptr inbounds nuw i8, ptr %562, i32 40
  br label %564

564:                                              ; preds = %603, %556
  %565 = phi i32 [ 0, %556 ], [ %616, %603 ]
  %566 = load i32, ptr %563, align 4, !tbaa !68
  %567 = icmp ult i32 %565, %566
  br i1 %567, label %603, label %568

568:                                              ; preds = %564
  %569 = getelementptr inbounds nuw i8, ptr %5, i32 52
  %570 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %571 = getelementptr inbounds nuw i8, ptr %5, i32 60
  br label %572

572:                                              ; preds = %588, %568
  %573 = phi ptr [ %5, %568 ], [ %579, %588 ]
  %574 = ptrtoint ptr %573 to i32
  br label %575

575:                                              ; preds = %586, %572
  %576 = phi i32 [ 0, %572 ], [ %587, %586 ]
  %577 = icmp eq i32 %576, 8
  br i1 %577, label %595, label %578

578:                                              ; preds = %575
  %579 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %576
  %580 = load i32, ptr %579, align 4, !tbaa !12
  %581 = icmp eq i32 %580, 2
  br i1 %581, label %582, label %586

582:                                              ; preds = %578
  %583 = getelementptr inbounds nuw i8, ptr %579, i32 12
  %584 = load i32, ptr %583, align 4, !tbaa !16
  %585 = icmp eq i32 %584, %574
  br i1 %585, label %588, label %586

586:                                              ; preds = %582, %578
  %587 = add nuw nsw i32 %576, 1
  br label %575, !llvm.loop !78

588:                                              ; preds = %582
  %589 = load i32, ptr %569, align 4, !tbaa !48
  %590 = getelementptr inbounds nuw i8, ptr %579, i32 52
  store i32 %589, ptr %590, align 4, !tbaa !48
  %591 = load i32, ptr %570, align 4, !tbaa !50
  %592 = getelementptr inbounds nuw i8, ptr %579, i32 56
  store i32 %591, ptr %592, align 4, !tbaa !50
  %593 = load i32, ptr %571, align 4, !tbaa !49
  %594 = getelementptr inbounds nuw i8, ptr %579, i32 60
  store i32 %593, ptr %594, align 4, !tbaa !49
  br label %572, !llvm.loop !79

595:                                              ; preds = %575
  %596 = load i32, ptr @curr, align 4, !tbaa !9
  call fastcc void @kfree_exec(i32 noundef %596) #11
  %597 = load i32, ptr @curr, align 4, !tbaa !9
  %598 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %597
  store i32 %561, ptr %598, align 4, !tbaa !9
  %599 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %597, i32 1
  store i32 %560, ptr %599, align 4, !tbaa !9
  %600 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %601 = load volatile i32, ptr %600, align 4, !tbaa !46
  %602 = icmp eq i32 %601, 0
  br i1 %602, label %659, label %617

603:                                              ; preds = %564
  %604 = getelementptr inbounds nuw i32, ptr %559, i32 %565
  %605 = load i32, ptr %604, align 4, !tbaa !9
  %606 = icmp slt i32 %605, 0
  %607 = select i1 %606, i32 %560, i32 %561
  %608 = and i32 %605, 1073741823
  %609 = add i32 %607, %608
  %610 = and i32 %605, 1073741824
  %611 = icmp eq i32 %610, 0
  %612 = select i1 %611, i32 %558, i32 %557
  %613 = inttoptr i32 %609 to ptr
  %614 = load volatile i32, ptr %613, align 4, !tbaa !9
  %615 = add i32 %612, %614
  store volatile i32 %615, ptr %613, align 4, !tbaa !9
  %616 = add nuw i32 %565, 1
  br label %564, !llvm.loop !80

617:                                              ; preds = %595
  %618 = call fastcc i32 @kalloc(i32 noundef 256) #11
  %619 = icmp eq i32 %618, 0
  br i1 %619, label %659, label %620

620:                                              ; preds = %617
  %621 = load volatile i32, ptr %600, align 4, !tbaa !46
  %622 = inttoptr i32 %621 to ptr
  %623 = inttoptr i32 %618 to ptr
  %624 = add i32 %618, 64
  %625 = inttoptr i32 %624 to ptr
  %626 = add i32 %618, 256
  %627 = inttoptr i32 %626 to ptr
  %628 = getelementptr inbounds i8, ptr %627, i32 -1
  br label %629

629:                                              ; preds = %651, %620
  %630 = phi i32 [ 0, %620 ], [ %653, %651 ]
  %631 = phi ptr [ %625, %620 ], [ %652, %651 ]
  %632 = icmp eq i32 %630, 15
  br i1 %632, label %654, label %633

633:                                              ; preds = %629
  %634 = getelementptr inbounds nuw i32, ptr %622, i32 %630
  %635 = load i32, ptr %634, align 4, !tbaa !9
  %636 = icmp eq i32 %635, 0
  br i1 %636, label %654, label %637

637:                                              ; preds = %633
  %638 = inttoptr i32 %635 to ptr
  %639 = ptrtoint ptr %631 to i32
  %640 = getelementptr inbounds nuw i32, ptr %623, i32 %630
  store i32 %639, ptr %640, align 4, !tbaa !9
  br label %641

641:                                              ; preds = %648, %637
  %642 = phi ptr [ %631, %637 ], [ %650, %648 ]
  %643 = phi ptr [ %638, %637 ], [ %649, %648 ]
  %644 = load i8, ptr %643, align 1, !tbaa !3
  %645 = icmp ne i8 %644, 0
  %646 = icmp ult ptr %642, %628
  %647 = select i1 %645, i1 %646, i1 false
  br i1 %647, label %648, label %651

648:                                              ; preds = %641
  %649 = getelementptr inbounds nuw i8, ptr %643, i32 1
  %650 = getelementptr inbounds nuw i8, ptr %642, i32 1
  store i8 %644, ptr %642, align 1, !tbaa !3
  br label %641, !llvm.loop !81

651:                                              ; preds = %641
  %652 = getelementptr inbounds nuw i8, ptr %642, i32 1
  store i8 0, ptr %642, align 1, !tbaa !3
  %653 = add nuw nsw i32 %630, 1
  br label %629, !llvm.loop !82

654:                                              ; preds = %629, %633
  %655 = getelementptr inbounds nuw i32, ptr %623, i32 %630
  store i32 0, ptr %655, align 4, !tbaa !9
  %656 = load i32, ptr @curr, align 4, !tbaa !9
  %657 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %656, i32 2
  store i32 %618, ptr %657, align 4, !tbaa !9
  br label %659

658:                                              ; preds = %504, %507, %535, %498
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #13
  br label %932

659:                                              ; preds = %595, %654, %617
  %660 = phi i32 [ 0, %595 ], [ %630, %654 ], [ 0, %617 ]
  %661 = phi i32 [ 0, %595 ], [ %618, %654 ], [ 0, %617 ]
  %662 = getelementptr inbounds nuw i8, ptr %562, i32 52
  %663 = load i32, ptr %662, align 4, !tbaa !62
  %664 = add i32 %663, %560
  %665 = getelementptr inbounds nuw i8, ptr %5, i32 24
  store i32 %664, ptr %665, align 4, !tbaa !29
  %666 = getelementptr inbounds nuw i8, ptr %562, i32 56
  %667 = load i32, ptr %666, align 4, !tbaa !63
  %668 = add i32 %667, %560
  %669 = getelementptr inbounds nuw i8, ptr %5, i32 28
  store i32 %668, ptr %669, align 4, !tbaa !83
  %670 = getelementptr inbounds nuw i8, ptr %562, i32 60
  %671 = load i32, ptr %670, align 4, !tbaa !64
  %672 = add i32 %671, %560
  %673 = getelementptr inbounds nuw i8, ptr %5, i32 32
  store i32 %672, ptr %673, align 4, !tbaa !35
  %674 = getelementptr inbounds nuw i8, ptr %562, i32 48
  %675 = load i32, ptr %674, align 4, !tbaa !61
  %676 = add i32 %675, %561
  %677 = getelementptr inbounds nuw i8, ptr %5, i32 36
  store i32 %676, ptr %677, align 4, !tbaa !40
  %678 = getelementptr inbounds nuw i8, ptr %562, i32 64
  %679 = load i32, ptr %678, align 4, !tbaa !65
  %680 = add i32 %679, %560
  store i32 %680, ptr %11, align 4, !tbaa !25
  %681 = load i32, ptr @k_sysentry, align 4, !tbaa !9
  %682 = getelementptr inbounds nuw i8, ptr %562, i32 68
  %683 = load i32, ptr %682, align 4, !tbaa !66
  %684 = add i32 %683, %560
  %685 = inttoptr i32 %684 to ptr
  store volatile i32 %681, ptr %685, align 4, !tbaa !9
  %686 = load i32, ptr %677, align 4, !tbaa !40
  %687 = load i32, ptr %665, align 4, !tbaa !29
  %688 = inttoptr i32 %687 to ptr
  store volatile i32 %686, ptr %688, align 4, !tbaa !9
  %689 = load i32, ptr %662, align 4, !tbaa !62
  %690 = add i32 %689, %560
  %691 = add i32 %690, -84
  %692 = inttoptr i32 %691 to ptr
  store volatile i32 %660, ptr %692, align 4, !tbaa !9
  %693 = add i32 %690, -80
  %694 = inttoptr i32 %693 to ptr
  store volatile i32 %661, ptr %694, align 4, !tbaa !9
  call fastcc void @vfork_release(ptr noundef nonnull %5) #11
  store i32 4, ptr %5, align 4, !tbaa !12
  %695 = load i32, ptr @curr, align 4, !tbaa !9
  %696 = getelementptr inbounds nuw i8, ptr %562, i32 44
  %697 = load i32, ptr %696, align 4, !tbaa !59
  %698 = add i32 %697, %561
  call fastcc void @kexit(i32 noundef %695, i32 noundef %698) #11
  call void @llvm.lifetime.end.p0(i64 72, ptr nonnull %1) #13
  br label %962

699:                                              ; preds = %10
  %700 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %701 = load volatile i32, ptr %700, align 4, !tbaa !32
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef %701) #11
  br label %947

702:                                              ; preds = %10
  %703 = load i32, ptr @fsready, align 4, !tbaa !9
  %704 = icmp eq i32 %703, 0
  br i1 %704, label %932, label %705

705:                                              ; preds = %702
  %706 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %707 = load volatile i32, ptr %706, align 4, !tbaa !32
  %708 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %709 = load volatile i32, ptr %708, align 4, !tbaa !46
  %710 = tail call i32 @kfs_mount(i32 noundef %707, i32 noundef %709) #12
  br label %932

711:                                              ; preds = %10
  %712 = load i32, ptr @fsready, align 4, !tbaa !9
  %713 = icmp eq i32 %712, 0
  br i1 %713, label %932, label %714

714:                                              ; preds = %711
  %715 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %716 = load volatile i32, ptr %715, align 4, !tbaa !32
  %717 = tail call i32 @kfs_umount(i32 noundef %716) #12
  br label %932

718:                                              ; preds = %10
  %719 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %720 = load volatile i32, ptr %719, align 4, !tbaa !32
  %721 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %722 = load i32, ptr %721, align 4, !tbaa !50
  %723 = icmp ult i32 %720, %722
  br i1 %723, label %724, label %731

724:                                              ; preds = %718
  %725 = add i32 %720, 32
  %726 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %727 = load i32, ptr %726, align 4, !tbaa !49
  %728 = icmp ugt i32 %725, %727
  br i1 %728, label %729, label %731

729:                                              ; preds = %724
  %730 = icmp ugt i32 %720, -33
  br i1 %730, label %731, label %932

731:                                              ; preds = %718, %724, %729
  %732 = load volatile i32, ptr %719, align 4, !tbaa !32
  %733 = inttoptr i32 %732 to ptr
  %734 = load i32, ptr @arena_end, align 4, !tbaa !9
  %735 = load i32, ptr @arena, align 4, !tbaa !9
  %736 = sub i32 %734, %735
  store i32 %736, ptr %733, align 4, !tbaa !9
  %737 = getelementptr inbounds nuw i8, ptr %733, i32 4
  store i32 0, ptr %737, align 4, !tbaa !9
  %738 = getelementptr inbounds nuw i8, ptr %733, i32 8
  store i32 0, ptr %738, align 4, !tbaa !9
  %739 = load i1, ptr @kheap_init, align 4
  br i1 %739, label %741, label %740

740:                                              ; preds = %731
  store i32 %736, ptr %738, align 4, !tbaa !9
  store i32 %736, ptr %737, align 4, !tbaa !9
  br label %756

741:                                              ; preds = %731, %753
  %742 = phi i32 [ %754, %753 ], [ 0, %731 ]
  %743 = phi i32 [ %749, %753 ], [ 0, %731 ]
  %744 = phi ptr [ %755, %753 ], [ @kfreelist, %731 ]
  %745 = load ptr, ptr %744, align 4, !tbaa !84
  %746 = icmp eq ptr %745, null
  br i1 %746, label %756, label %747

747:                                              ; preds = %741
  %748 = load i32, ptr %745, align 4, !tbaa !86
  %749 = add i32 %743, %748
  store i32 %749, ptr %737, align 4, !tbaa !9
  %750 = load i32, ptr %745, align 4, !tbaa !86
  %751 = icmp ugt i32 %750, %742
  br i1 %751, label %752, label %753

752:                                              ; preds = %747
  store i32 %750, ptr %738, align 4, !tbaa !9
  br label %753

753:                                              ; preds = %747, %752
  %754 = phi i32 [ %742, %747 ], [ %750, %752 ]
  %755 = getelementptr inbounds nuw i8, ptr %745, i32 4
  br label %741, !llvm.loop !88

756:                                              ; preds = %741, %740
  %757 = getelementptr inbounds nuw i8, ptr %733, i32 20
  store i32 0, ptr %757, align 4, !tbaa !9
  %758 = getelementptr inbounds nuw i8, ptr %733, i32 16
  store i32 0, ptr %758, align 4, !tbaa !9
  %759 = getelementptr inbounds nuw i8, ptr %733, i32 12
  store i32 0, ptr %759, align 4, !tbaa !9
  br label %760

760:                                              ; preds = %803, %756
  %761 = phi i32 [ 0, %756 ], [ %782, %803 ]
  %762 = phi i32 [ 0, %756 ], [ %804, %803 ]
  %763 = phi i32 [ 0, %756 ], [ %780, %803 ]
  %764 = phi i32 [ 0, %756 ], [ %805, %803 ]
  %765 = icmp eq i32 %764, 8
  br i1 %765, label %766, label %770

766:                                              ; preds = %760
  %767 = getelementptr inbounds nuw i8, ptr %733, i32 24
  store i32 8, ptr %767, align 4, !tbaa !9
  %768 = load i32, ptr @ticks, align 4, !tbaa !9
  %769 = getelementptr inbounds nuw i8, ptr %733, i32 28
  store i32 %768, ptr %769, align 4, !tbaa !9
  br label %932

770:                                              ; preds = %760
  %771 = getelementptr inbounds nuw [8 x i32], ptr @heapmem, i32 0, i32 %764
  %772 = load i32, ptr %771, align 4, !tbaa !9
  %773 = icmp eq i32 %772, 0
  br i1 %773, label %779, label %774

774:                                              ; preds = %770
  %775 = add i32 %772, -256
  %776 = inttoptr i32 %775 to ptr
  %777 = load volatile i32, ptr %776, align 4, !tbaa !9
  %778 = add i32 %763, %777
  store i32 %778, ptr %759, align 4, !tbaa !9
  br label %779

779:                                              ; preds = %774, %770
  %780 = phi i32 [ %778, %774 ], [ %763, %770 ]
  br label %781

781:                                              ; preds = %798, %779
  %782 = phi i32 [ %761, %779 ], [ %799, %798 ]
  %783 = phi i32 [ 0, %779 ], [ %800, %798 ]
  %784 = icmp eq i32 %783, 3
  br i1 %784, label %785, label %789

785:                                              ; preds = %781
  %786 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %764
  %787 = load i32, ptr %786, align 4, !tbaa !12
  %788 = icmp eq i32 %787, 0
  br i1 %788, label %803, label %801

789:                                              ; preds = %781
  %790 = getelementptr inbounds nuw [8 x [3 x i32]], ptr @execmem, i32 0, i32 %764, i32 %783
  %791 = load i32, ptr %790, align 4, !tbaa !9
  %792 = icmp eq i32 %791, 0
  br i1 %792, label %798, label %793

793:                                              ; preds = %789
  %794 = add i32 %791, -256
  %795 = inttoptr i32 %794 to ptr
  %796 = load volatile i32, ptr %795, align 4, !tbaa !9
  %797 = add i32 %782, %796
  store i32 %797, ptr %758, align 4, !tbaa !9
  br label %798

798:                                              ; preds = %789, %793
  %799 = phi i32 [ %782, %789 ], [ %797, %793 ]
  %800 = add nuw nsw i32 %783, 1
  br label %781, !llvm.loop !89

801:                                              ; preds = %785
  %802 = add i32 %762, 1
  store i32 %802, ptr %757, align 4, !tbaa !9
  br label %803

803:                                              ; preds = %785, %801
  %804 = phi i32 [ %762, %785 ], [ %802, %801 ]
  %805 = add nuw nsw i32 %764, 1
  br label %760, !llvm.loop !90

806:                                              ; preds = %10
  %807 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %808 = load volatile i32, ptr %807, align 4, !tbaa !32
  %809 = icmp eq i32 %808, 0
  br i1 %809, label %814, label %810

810:                                              ; preds = %806
  store i1 true, ptr @cons_raw, align 4
  %811 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %812 = load i32, ptr %811, align 4, !tbaa !14
  store i32 %812, ptr @cons_raw_pid, align 4, !tbaa !9
  %813 = load i32, ptr @cons_e, align 4, !tbaa !9
  store i32 %813, ptr @cons_w, align 4, !tbaa !9
  br label %932

814:                                              ; preds = %806
  store i1 false, ptr @cons_raw, align 4
  store i32 0, ptr @cons_raw_pid, align 4, !tbaa !9
  br label %932

815:                                              ; preds = %10
  %816 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %817 = load volatile i32, ptr %816, align 4, !tbaa !32
  %818 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %819 = load volatile i32, ptr %818, align 4, !tbaa !46
  %820 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %821 = load volatile i32, ptr %820, align 4, !tbaa !47
  %822 = tail call i32 @kgpio(i32 noundef %817, i32 noundef %819, i32 noundef %821) #12
  br label %932

823:                                              ; preds = %10
  %824 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %825 = load volatile i32, ptr %824, align 4, !tbaa !32
  %826 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %827 = load volatile i32, ptr %826, align 4, !tbaa !46
  %828 = tail call i32 @kpinmux(i32 noundef %825, i32 noundef %827) #12
  br label %932

829:                                              ; preds = %10
  %830 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %831 = load volatile i32, ptr %830, align 4, !tbaa !32
  %832 = icmp eq i32 %831, 0
  br i1 %832, label %836, label %833

833:                                              ; preds = %829
  %834 = load volatile i32, ptr %830, align 4, !tbaa !32
  %835 = icmp eq i32 %834, 1
  br i1 %835, label %836, label %849

836:                                              ; preds = %833, %829
  %837 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %838 = load volatile i32, ptr %837, align 4, !tbaa !46
  %839 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %840 = load i32, ptr %839, align 4, !tbaa !50
  %841 = icmp ult i32 %838, %840
  br i1 %841, label %842, label %849

842:                                              ; preds = %836
  %843 = add i32 %838, 28
  %844 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %845 = load i32, ptr %844, align 4, !tbaa !49
  %846 = icmp ugt i32 %843, %845
  br i1 %846, label %847, label %849

847:                                              ; preds = %842
  %848 = icmp ugt i32 %838, -29
  br i1 %848, label %849, label %932

849:                                              ; preds = %836, %842, %847, %833
  %850 = load volatile i32, ptr %830, align 4, !tbaa !32
  %851 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %852 = load volatile i32, ptr %851, align 4, !tbaa !46
  %853 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %854 = load volatile i32, ptr %853, align 4, !tbaa !47
  %855 = tail call i32 @kpio(i32 noundef %850, i32 noundef %852, i32 noundef %854) #12
  br label %932

856:                                              ; preds = %10
  %857 = getelementptr inbounds nuw i8, ptr %13, i32 4
  %858 = load volatile i32, ptr %857, align 4, !tbaa !32
  %859 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %860 = load volatile i32, ptr %859, align 4, !tbaa !46
  %861 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %862 = load i32, ptr %861, align 4, !tbaa !14
  %863 = load volatile i32, ptr %857, align 4, !tbaa !32
  %864 = icmp eq i32 %863, 0
  br i1 %864, label %865, label %878

865:                                              ; preds = %856
  %866 = load volatile i32, ptr %859, align 4, !tbaa !46
  %867 = getelementptr inbounds nuw i8, ptr %5, i32 56
  %868 = load i32, ptr %867, align 4, !tbaa !50
  %869 = icmp ult i32 %866, %868
  br i1 %869, label %870, label %878

870:                                              ; preds = %865
  %871 = add i32 %866, 20
  %872 = getelementptr inbounds nuw i8, ptr %5, i32 60
  %873 = load i32, ptr %872, align 4, !tbaa !49
  %874 = icmp ugt i32 %871, %873
  br i1 %874, label %875, label %878

875:                                              ; preds = %870
  %876 = icmp ult i32 %866, -20
  %877 = zext i1 %876 to i32
  br label %878

878:                                              ; preds = %875, %870, %865, %856
  %879 = phi i32 [ 0, %856 ], [ 0, %870 ], [ 0, %865 ], [ %877, %875 ]
  %880 = tail call i32 @kfb_syscall(i32 noundef %858, i32 noundef %860, i32 noundef %862, i32 noundef %879) #12
  br label %932

881:                                              ; preds = %10
  %882 = getelementptr inbounds nuw i8, ptr %13, i32 12
  %883 = load volatile i32, ptr %882, align 4, !tbaa !47
  %884 = getelementptr inbounds nuw i8, ptr %5, i32 64
  store i32 %883, ptr %884, align 4, !tbaa !23
  %885 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %885, align 4, !tbaa !24
  br label %932

886:                                              ; preds = %10
  %887 = getelementptr inbounds nuw i8, ptr %5, i32 64
  %888 = load i32, ptr %887, align 4, !tbaa !23
  %889 = icmp eq i32 %888, 0
  br i1 %889, label %932, label %890

890:                                              ; preds = %886
  %891 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %892 = load i32, ptr %891, align 4, !tbaa !29
  %893 = add i32 %892, -84
  %894 = getelementptr inbounds nuw i8, ptr %5, i32 68
  store i32 0, ptr %894, align 4, !tbaa !24
  %895 = add i32 %888, 8
  %896 = inttoptr i32 %895 to ptr
  %897 = load volatile i32, ptr %896, align 4, !tbaa !9
  %898 = inttoptr i32 %893 to ptr
  store volatile i32 %897, ptr %898, align 4, !tbaa !9
  %899 = add i32 %888, 12
  %900 = inttoptr i32 %899 to ptr
  %901 = load volatile i32, ptr %900, align 4, !tbaa !9
  %902 = add i32 %892, -80
  %903 = inttoptr i32 %902 to ptr
  store volatile i32 %901, ptr %903, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !12
  %904 = load i32, ptr @curr, align 4, !tbaa !9
  %905 = add i32 %888, 4
  %906 = inttoptr i32 %905 to ptr
  %907 = load volatile i32, ptr %906, align 4, !tbaa !9
  tail call fastcc void @kexit(i32 noundef %904, i32 noundef %907) #11
  br label %962

908:                                              ; preds = %15, %920
  %909 = phi i32 [ %921, %920 ], [ 0, %15 ]
  %910 = icmp eq i32 %909, 8
  br i1 %910, label %932, label %911

911:                                              ; preds = %908
  %912 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %909
  %913 = load i32, ptr %912, align 4, !tbaa !12
  %914 = icmp eq i32 %913, 0
  br i1 %914, label %920, label %915

915:                                              ; preds = %911
  %916 = getelementptr inbounds nuw i8, ptr %912, i32 4
  %917 = load i32, ptr %916, align 4, !tbaa !14
  %918 = load volatile i32, ptr %16, align 4, !tbaa !32
  %919 = icmp eq i32 %917, %918
  br i1 %919, label %922, label %920

920:                                              ; preds = %911, %915
  %921 = add nuw nsw i32 %909, 1
  br label %908, !llvm.loop !91

922:                                              ; preds = %915
  %923 = icmp eq i32 %913, 5
  br i1 %923, label %932, label %924

924:                                              ; preds = %922
  %925 = icmp eq i32 %909, %4
  br i1 %925, label %926, label %927

926:                                              ; preds = %924
  tail call fastcc void @terminate(ptr noundef nonnull %5, i32 noundef -1) #11
  br label %947

927:                                              ; preds = %924
  %928 = icmp eq i32 %913, 2
  br i1 %928, label %929, label %930

929:                                              ; preds = %927
  tail call fastcc void @terminate(ptr noundef nonnull %912, i32 noundef -1) #11
  br label %932

930:                                              ; preds = %927
  %931 = getelementptr inbounds nuw i8, ptr %912, i32 48
  store i32 1, ptr %931, align 4, !tbaa !30
  br label %932

932:                                              ; preds = %908, %372, %224, %134, %24, %10, %19, %22, %132, %729, %766, %815, %823, %849, %878, %881, %49, %52, %58, %61, %65, %68, %72, %75, %81, %84, %90, %93, %97, %100, %104, %107, %111, %114, %120, %123, %296, %273, %356, %360, %702, %705, %711, %714, %814, %810, %847, %922, %930, %929, %886, %45, %154, %164, %176, %193, %209, %658
  %933 = phi i32 [ -1, %658 ], [ -1, %176 ], [ -1, %209 ], [ -1, %193 ], [ -1, %164 ], [ %156, %154 ], [ %47, %45 ], [ -1, %886 ], [ 0, %929 ], [ 0, %930 ], [ -1, %922 ], [ -1, %847 ], [ 0, %810 ], [ 0, %814 ], [ -1, %711 ], [ %717, %714 ], [ -1, %702 ], [ %710, %705 ], [ -1, %360 ], [ %359, %356 ], [ %271, %273 ], [ 0, %296 ], [ -1, %120 ], [ %126, %123 ], [ -1, %111 ], [ %119, %114 ], [ -1, %104 ], [ %110, %107 ], [ -1, %97 ], [ %103, %100 ], [ -1, %90 ], [ %96, %93 ], [ -1, %81 ], [ %89, %84 ], [ -1, %72 ], [ %80, %75 ], [ -1, %65 ], [ %71, %68 ], [ -1, %58 ], [ %64, %61 ], [ -1, %49 ], [ %57, %52 ], [ 0, %881 ], [ %880, %878 ], [ %855, %849 ], [ %828, %823 ], [ %822, %815 ], [ 0, %766 ], [ -1, %729 ], [ %133, %132 ], [ %23, %22 ], [ %21, %19 ], [ -1, %10 ], [ -1, %24 ], [ -1, %134 ], [ %214, %224 ], [ -1, %372 ], [ -1, %908 ]
  %934 = load i32, ptr %11, align 4, !tbaa !25
  %935 = inttoptr i32 %934 to ptr
  %936 = getelementptr inbounds nuw i8, ptr %935, i32 16
  store volatile i32 %933, ptr %936, align 4, !tbaa !26
  %937 = getelementptr inbounds nuw i8, ptr %935, i32 20
  store volatile i32 1, ptr %937, align 4, !tbaa !28
  %938 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %939 = load i32, ptr %938, align 4, !tbaa !29
  %940 = add i32 %939, -84
  %941 = inttoptr i32 %940 to ptr
  store volatile i32 %933, ptr %941, align 4, !tbaa !9
  store i32 4, ptr %5, align 4, !tbaa !12
  %942 = load i32, ptr @curr, align 4, !tbaa !9
  %943 = getelementptr inbounds nuw i8, ptr %5, i32 32
  %944 = load i32, ptr %943, align 4, !tbaa !35
  %945 = inttoptr i32 %944 to ptr
  %946 = load volatile i32, ptr %945, align 4, !tbaa !9
  call fastcc void @kexit(i32 noundef %942, i32 noundef %946) #11
  br label %962

947:                                              ; preds = %154, %45, %699, %302, %315, %926
  %948 = phi i32 [ -1, %926 ], [ 0, %302 ], [ 0, %315 ], [ -1, %699 ], [ -3, %45 ], [ -3, %154 ]
  %949 = load i32, ptr %5, align 4, !tbaa !12
  %950 = icmp eq i32 %949, 2
  br i1 %950, label %951, label %961

951:                                              ; preds = %385, %362, %254, %947
  %952 = phi i32 [ %948, %947 ], [ 0, %385 ], [ %371, %362 ], [ 0, %254 ]
  %953 = load i32, ptr %11, align 4, !tbaa !25
  %954 = inttoptr i32 %953 to ptr
  %955 = getelementptr inbounds nuw i8, ptr %954, i32 16
  store volatile i32 %952, ptr %955, align 4, !tbaa !26
  %956 = getelementptr inbounds nuw i8, ptr %954, i32 20
  store volatile i32 1, ptr %956, align 4, !tbaa !28
  %957 = getelementptr inbounds nuw i8, ptr %5, i32 24
  %958 = load i32, ptr %957, align 4, !tbaa !29
  %959 = add i32 %958, -84
  %960 = inttoptr i32 %959 to ptr
  store volatile i32 %952, ptr %960, align 4, !tbaa !9
  br label %961

961:                                              ; preds = %951, %947
  tail call fastcc void @swtch() #11
  br label %962

962:                                              ; preds = %659, %890, %932, %961, %9
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @badbuf(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) unnamed_addr #6 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 56
  %5 = load i32, ptr %4, align 4, !tbaa !50
  %6 = icmp ne i32 %2, 0
  %7 = icmp ult i32 %1, %5
  %8 = and i1 %6, %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = add i32 %2, %1
  %11 = getelementptr inbounds nuw i8, ptr %0, i32 60
  %12 = load i32, ptr %11, align 4, !tbaa !49
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

; Function Attrs: minsize optsize
declare dso_local i32 @kfs_selready(i32 noundef) local_unnamed_addr #7

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
  store ptr %5, ptr @kfreelist, align 4, !tbaa !84
  %6 = load i32, ptr @arena_end, align 4, !tbaa !9
  %7 = sub i32 %6, %4
  store i32 %7, ptr %5, align 4, !tbaa !86
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
  %15 = load ptr, ptr %14, align 4, !tbaa !84
  %16 = icmp eq ptr %15, null
  br i1 %16, label %40, label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %15, align 4, !tbaa !86
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
  store i32 %21, ptr %26, align 4, !tbaa !86
  %27 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %28 = load ptr, ptr %27, align 4, !tbaa !92
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 4
  store ptr %28, ptr %29, align 4, !tbaa !92
  store i32 %12, ptr %15, align 4, !tbaa !86
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !92
  %33 = ptrtoint ptr %15 to i32
  br label %34

34:                                               ; preds = %30, %23
  %35 = phi i32 [ %33, %30 ], [ %24, %23 ]
  %36 = phi ptr [ %32, %30 ], [ %26, %23 ]
  store ptr %36, ptr %14, align 4, !tbaa !84
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
define internal fastcc void @kfree(i32 noundef %0) unnamed_addr #9 {
  %2 = icmp eq i32 %0, 0
  br i1 %2, label %41, label %3

3:                                                ; preds = %1
  %4 = add i32 %0, -256
  br label %5

5:                                                ; preds = %5, %3
  %6 = phi ptr [ null, %3 ], [ %8, %5 ]
  %7 = phi ptr [ @kfreelist, %3 ], [ %13, %5 ]
  %8 = load ptr, ptr %7, align 4, !tbaa !84
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
  store ptr %15, ptr @kfreelist, align 4, !tbaa !84
  br label %21

21:                                               ; preds = %20, %18
  br i1 %9, label %22, label %30

22:                                               ; preds = %21
  %23 = load i32, ptr %15, align 4, !tbaa !86
  %24 = add i32 %23, %4
  %25 = icmp eq i32 %24, %10
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = load i32, ptr %8, align 4, !tbaa !86
  %28 = add i32 %27, %23
  store i32 %28, ptr %15, align 4, !tbaa !86
  %29 = load ptr, ptr %13, align 4, !tbaa !92
  store ptr %29, ptr %16, align 4, !tbaa !92
  br label %30

30:                                               ; preds = %26, %22, %21
  br i1 %17, label %41, label %31

31:                                               ; preds = %30
  %32 = ptrtoint ptr %6 to i32
  %33 = load i32, ptr %6, align 4, !tbaa !86
  %34 = add i32 %33, %32
  %35 = icmp eq i32 %34, %4
  br i1 %35, label %36, label %41

36:                                               ; preds = %31
  %37 = load i32, ptr %15, align 4, !tbaa !86
  %38 = add i32 %37, %33
  store i32 %38, ptr %6, align 4, !tbaa !86
  %39 = load ptr, ptr %16, align 4, !tbaa !92
  %40 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %39, ptr %40, align 4, !tbaa !92
  br label %41

41:                                               ; preds = %30, %31, %36, %1
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kdmacpy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #7

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
  store i32 0, ptr %9, align 4, !tbaa !49
  %10 = getelementptr inbounds nuw i8, ptr %8, i32 56
  store i32 0, ptr %10, align 4, !tbaa !50
  %11 = getelementptr inbounds nuw i8, ptr %8, i32 52
  store i32 0, ptr %11, align 4, !tbaa !48
  %12 = getelementptr inbounds nuw i8, ptr %8, i32 68
  store i32 0, ptr %12, align 4, !tbaa !24
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 64
  store i32 0, ptr %13, align 4, !tbaa !23
  ret void

14:                                               ; preds = %2
  %15 = getelementptr inbounds [8 x [3 x i32]], ptr @execmem, i32 0, i32 %0, i32 %3
  %16 = load i32, ptr %15, align 4, !tbaa !9
  tail call fastcc void @kfree(i32 noundef %16) #11
  store i32 0, ptr %15, align 4, !tbaa !9
  %17 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !95
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
  %10 = load i32, ptr %9, align 4, !tbaa !12
  %11 = icmp eq i32 %10, 2
  br i1 %11, label %12, label %27

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %9, i32 12
  %14 = load i32, ptr %13, align 4, !tbaa !16
  %15 = icmp eq i32 %14, %2
  br i1 %15, label %16, label %27

16:                                               ; preds = %12
  %17 = load i32, ptr %3, align 4, !tbaa !14
  %18 = getelementptr inbounds nuw i8, ptr %9, i32 44
  %19 = load i32, ptr %18, align 4, !tbaa !25
  %20 = inttoptr i32 %19 to ptr
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 16
  store volatile i32 %17, ptr %21, align 4, !tbaa !26
  %22 = getelementptr inbounds nuw i8, ptr %20, i32 20
  store volatile i32 1, ptr %22, align 4, !tbaa !28
  %23 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %24 = load i32, ptr %23, align 4, !tbaa !29
  %25 = add i32 %24, -84
  %26 = inttoptr i32 %25 to ptr
  store volatile i32 %17, ptr %26, align 4, !tbaa !9
  store i32 0, ptr %13, align 4, !tbaa !16
  store i32 3, ptr %9, align 4, !tbaa !12
  br label %27

27:                                               ; preds = %16, %12, %8
  %28 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !96
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
  tail call fastcc void @fire_income() #11
  br label %11

11:                                               ; preds = %10, %5, %2
  %12 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %0
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 68
  %14 = load i32, ptr %13, align 4, !tbaa !24
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %40

16:                                               ; preds = %11
  %17 = getelementptr inbounds nuw i8, ptr %12, i32 64
  %18 = load i32, ptr %17, align 4, !tbaa !23
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %40, label %20

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %22 = load i32, ptr %21, align 4, !tbaa !29
  %23 = add i32 %22, -84
  %24 = add i32 %18, 4
  %25 = inttoptr i32 %24 to ptr
  store volatile i32 %1, ptr %25, align 4, !tbaa !9
  %26 = inttoptr i32 %23 to ptr
  %27 = load volatile i32, ptr %26, align 4, !tbaa !9
  %28 = load i32, ptr %17, align 4, !tbaa !23
  %29 = add i32 %28, 8
  %30 = inttoptr i32 %29 to ptr
  store volatile i32 %27, ptr %30, align 4, !tbaa !9
  %31 = add i32 %22, -80
  %32 = inttoptr i32 %31 to ptr
  %33 = load volatile i32, ptr %32, align 4, !tbaa !9
  %34 = load i32, ptr %17, align 4, !tbaa !23
  %35 = add i32 %34, 12
  %36 = inttoptr i32 %35 to ptr
  store volatile i32 %33, ptr %36, align 4, !tbaa !9
  %37 = load i32, ptr %17, align 4, !tbaa !23
  %38 = inttoptr i32 %37 to ptr
  %39 = load volatile i32, ptr %38, align 4, !tbaa !9
  store i32 2, ptr %13, align 4, !tbaa !24
  br label %40

40:                                               ; preds = %20, %16, %11
  %41 = phi i32 [ %39, %20 ], [ %1, %16 ], [ %1, %11 ]
  store i32 %0, ptr @curr, align 4, !tbaa !9
  %42 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %43 = load i32, ptr %42, align 4, !tbaa !29
  %44 = load volatile ptr, ptr @kw_pcurdisp, align 4, !tbaa !37
  store i32 %43, ptr %44, align 4, !tbaa !9
  %45 = getelementptr inbounds nuw i8, ptr %12, i32 36
  %46 = load i32, ptr %45, align 4, !tbaa !40
  %47 = load volatile ptr, ptr @kw_curthunk, align 4, !tbaa !37
  store i32 %46, ptr %47, align 4, !tbaa !9
  %48 = getelementptr inbounds nuw i8, ptr %12, i32 28
  %49 = load i32, ptr %48, align 4, !tbaa !83
  %50 = load volatile ptr, ptr @kw_pcurresume, align 4, !tbaa !37
  store i32 %49, ptr %50, align 4, !tbaa !9
  %51 = load volatile ptr, ptr @kw_nextresume, align 4, !tbaa !37
  store i32 %41, ptr %51, align 4, !tbaa !9
  %52 = load i32, ptr %42, align 4, !tbaa !29
  %53 = load i32, ptr @inj_wreg, align 4, !tbaa !9
  %54 = inttoptr i32 %53 to ptr
  store volatile i32 %52, ptr %54, align 4, !tbaa !9
  %55 = load i32, ptr @tickpending, align 4, !tbaa !9
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %58, label %57

57:                                               ; preds = %40
  store i32 0, ptr @tickpending, align 4, !tbaa !9
  tail call fastcc void @fire_income() #11
  br label %58

58:                                               ; preds = %57, %40
  %59 = tail call i32 @kcons_on() #12
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %67, label %61

61:                                               ; preds = %58
  %62 = load i32, ptr @fgpid, align 4, !tbaa !9
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %65, label %64

64:                                               ; preds = %61
  tail call fastcc void @cons_poll() #11
  br label %65

65:                                               ; preds = %64, %61
  tail call void @kcons_kick() #12
  %66 = load i32, ptr %42, align 4, !tbaa !29
  tail call void @kcons_aim(i32 noundef %66) #12
  br label %67

67:                                               ; preds = %65, %58
  %68 = load i1, ptr @rearm, align 4
  br i1 %68, label %69, label %72

69:                                               ; preds = %67
  %70 = load i32, ptr @inj_treg, align 4, !tbaa !9
  %71 = inttoptr i32 %70 to ptr
  store volatile i32 1, ptr %71, align 4, !tbaa !9
  br label %72

72:                                               ; preds = %69, %67
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

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cputc_wire(i32 noundef range(i32 0, 256) %0) unnamed_addr #1 {
  %2 = tail call i32 @kcons_tx(i32 noundef %0) #12
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %9

4:                                                ; preds = %1, %4
  %5 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !9
  %6 = and i32 %5, 32
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %8, label %4, !llvm.loop !97

8:                                                ; preds = %4
  store volatile i32 %0, ptr @__dma_uart_dr, align 4, !tbaa !9
  br label %9

9:                                                ; preds = %1, %8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_putc(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_tx(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_rx() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kcons_aim(i32 noundef) local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kfb_init() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfbcon_reset() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kfs_start() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local void @kflash_init() local_unnamed_addr #7

; Function Attrs: minsize optsize
declare dso_local i32 @kcons_on() local_unnamed_addr #7

; Function Attrs: minsize nounwind optsize
define internal fastcc void @tick_income() unnamed_addr #1 {
  %1 = load i32, ptr @ticks, align 4, !tbaa !9
  %2 = add i32 %1, 1
  store i32 %2, ptr @ticks, align 4, !tbaa !9
  store i1 true, ptr @rearm, align 4
  br label %3

3:                                                ; preds = %25, %0
  %4 = phi i32 [ 0, %0 ], [ %26, %25 ]
  %5 = icmp eq i32 %4, 8
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  %7 = load i32, ptr @fgpid, align 4, !tbaa !9
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %28, label %27

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw [8 x %struct.proc], ptr @proc, i32 0, i32 %4
  %11 = load i32, ptr %10, align 4, !tbaa !12
  %12 = icmp eq i32 %11, 2
  br i1 %12, label %13, label %25

13:                                               ; preds = %9
  %14 = getelementptr inbounds nuw i8, ptr %10, i32 12
  %15 = load i32, ptr %14, align 4, !tbaa !16
  %16 = icmp eq i32 %15, ptrtoint (ptr @ticks to i32)
  br i1 %16, label %19, label %17

17:                                               ; preds = %13
  %18 = icmp eq i32 %15, ptrtoint (ptr @selwait_to to i32)
  br i1 %18, label %19, label %25

19:                                               ; preds = %17, %13
  %20 = getelementptr inbounds nuw i8, ptr %10, i32 16
  %21 = load i32, ptr %20, align 4, !tbaa !54
  %22 = sub i32 %2, %21
  %23 = icmp sgt i32 %22, -1
  br i1 %23, label %24, label %25

24:                                               ; preds = %19
  store i32 0, ptr %14, align 4, !tbaa !16
  store i32 3, ptr %10, align 4, !tbaa !12
  br label %25

25:                                               ; preds = %24, %19, %17, %9
  %26 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !98

27:                                               ; preds = %6
  tail call fastcc void @cons_poll() #11
  br label %28

28:                                               ; preds = %27, %6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @kcons_kick() local_unnamed_addr #7

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
!12 = !{!13, !10, i64 0}
!13 = !{!"proc", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48, !10, i64 52, !10, i64 56, !10, i64 60, !10, i64 64, !10, i64 68}
!14 = !{!13, !10, i64 4}
!15 = distinct !{!15, !7, !8}
!16 = !{!13, !10, i64 12}
!17 = !{!13, !10, i64 8}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !7, !8}
!23 = !{!13, !10, i64 64}
!24 = !{!13, !10, i64 68}
!25 = !{!13, !10, i64 44}
!26 = !{!27, !10, i64 16}
!27 = !{!"dma_sysmail", !10, i64 0, !10, i64 4, !10, i64 8, !10, i64 12, !10, i64 16, !10, i64 20}
!28 = !{!27, !10, i64 20}
!29 = !{!13, !10, i64 24}
!30 = !{!13, !10, i64 48}
!31 = distinct !{!31, !7, !8}
!32 = !{!27, !10, i64 4}
!33 = distinct !{!33, !7, !8}
!34 = distinct !{!34, !7, !8}
!35 = !{!13, !10, i64 32}
!36 = !{!13, !10, i64 40}
!37 = !{!38, !38, i64 0}
!38 = !{!"p1 int", !39, i64 0}
!39 = !{!"any pointer", !4, i64 0}
!40 = !{!13, !10, i64 36}
!41 = !{!13, !10, i64 20}
!42 = distinct !{!42, !7, !8}
!43 = distinct !{!43, !7, !8}
!44 = distinct !{!44, !7, !8}
!45 = !{!27, !10, i64 0}
!46 = !{!27, !10, i64 8}
!47 = !{!27, !10, i64 12}
!48 = !{!13, !10, i64 52}
!49 = !{!13, !10, i64 60}
!50 = !{!13, !10, i64 56}
!51 = distinct !{!51, !7, !8}
!52 = distinct !{!52, !7, !8}
!53 = distinct !{!53, !8}
!54 = !{!13, !10, i64 16}
!55 = distinct !{!55, !7, !8}
!56 = distinct !{!56, !7, !8}
!57 = distinct !{!57, !7, !8}
!58 = !{i64 0, i64 4, !9, i64 4, i64 4, !9, i64 8, i64 4, !9, i64 12, i64 4, !9, i64 16, i64 4, !9, i64 20, i64 4, !9, i64 24, i64 4, !9, i64 28, i64 4, !9, i64 32, i64 4, !9, i64 36, i64 4, !9, i64 40, i64 4, !9, i64 44, i64 4, !9, i64 48, i64 4, !9, i64 52, i64 4, !9, i64 56, i64 4, !9, i64 60, i64 4, !9, i64 64, i64 4, !9, i64 68, i64 4, !9}
!59 = !{!60, !10, i64 44}
!60 = !{!"kimg", !4, i64 0, !10, i64 12, !10, i64 16, !10, i64 20, !10, i64 24, !10, i64 28, !10, i64 32, !10, i64 36, !10, i64 40, !10, i64 44, !10, i64 48, !10, i64 52, !10, i64 56, !10, i64 60, !10, i64 64, !10, i64 68}
!61 = !{!60, !10, i64 48}
!62 = !{!60, !10, i64 52}
!63 = !{!60, !10, i64 56}
!64 = !{!60, !10, i64 60}
!65 = !{!60, !10, i64 64}
!66 = !{!60, !10, i64 68}
!67 = distinct !{!67, !7, !8}
!68 = !{!60, !10, i64 40}
!69 = distinct !{!69, !7, !8}
!70 = distinct !{!70, !7, !8}
!71 = !{!60, !10, i64 16}
!72 = !{!60, !10, i64 24}
!73 = !{!60, !10, i64 12}
!74 = !{!60, !10, i64 20}
!75 = !{!60, !10, i64 28}
!76 = !{!60, !10, i64 32}
!77 = !{!60, !10, i64 36}
!78 = distinct !{!78, !7, !8}
!79 = distinct !{!79, !8}
!80 = distinct !{!80, !7, !8}
!81 = distinct !{!81, !7, !8}
!82 = distinct !{!82, !7, !8}
!83 = !{!13, !10, i64 28}
!84 = !{!85, !85, i64 0}
!85 = !{!"p1 _ZTS4khdr", !39, i64 0}
!86 = !{!87, !10, i64 0}
!87 = !{!"khdr", !10, i64 0, !85, i64 4}
!88 = distinct !{!88, !7, !8}
!89 = distinct !{!89, !7, !8}
!90 = distinct !{!90, !7, !8}
!91 = distinct !{!91, !7, !8}
!92 = !{!87, !85, i64 4}
!93 = distinct !{!93, !7, !8}
!94 = distinct !{!94, !7, !8}
!95 = distinct !{!95, !7, !8}
!96 = distinct !{!96, !7, !8}
!97 = distinct !{!97, !7, !8}
!98 = distinct !{!98, !7, !8}
