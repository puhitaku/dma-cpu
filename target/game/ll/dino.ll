; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr, ptr }
%struct.cld = type { i32, i32 }

@arena_w = external dso_local global [2304 x i32], align 4
@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 123731968, i32 7340032, i32 0], align 4
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@art_cloud = internal constant [5 x i32] [i32 130023424, i32 536051712, i32 1073725440, i32 2147475456, i32 1073709056], align 4
@.str = private unnamed_addr constant [26 x i8] c"dino: run table overflow\0A\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.3 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@sfx_tab = external dso_local local_unnamed_addr global [4 x i32], align 4
@.str.4 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@fb = external dso_local global [57600 x i16], align 2
@sbuf = internal unnamed_addr global [6 x i8] zeroinitializer, align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  %1 = alloca [2 x %struct.cld], align 4
  %2 = alloca [2 x i32], align 4
  br label %3

3:                                                ; preds = %6, %0
  %4 = phi i32 [ 0, %0 ], [ %8, %6 ]
  %5 = icmp eq i32 %4, 264
  br i1 %5, label %9, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4496), i32 %4
  store i16 -1, ptr %7, align 2, !tbaa !3
  %8 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !7

9:                                                ; preds = %3, %17
  %10 = phi i32 [ %18, %17 ], [ 6, %3 ]
  %11 = icmp samesign ult i32 %10, 256
  br i1 %11, label %12, label %22

12:                                               ; preds = %9
  %13 = getelementptr inbounds nuw i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4496), i32 %10
  br label %14

14:                                               ; preds = %19, %12
  %15 = phi i32 [ %21, %19 ], [ 0, %12 ]
  %16 = icmp eq i32 %15, 8
  br i1 %16, label %17, label %19

17:                                               ; preds = %14
  %18 = add nuw nsw i32 %10, 24
  br label %9, !llvm.loop !10

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i16, ptr %13, i32 %15
  store i16 14823, ptr %20, align 2, !tbaa !3
  %21 = add nuw nsw i32 %15, 1
  br label %14, !llvm.loop !11

22:                                               ; preds = %9, %28
  %23 = phi i32 [ %31, %28 ], [ 0, %9 ]
  %24 = icmp eq i32 %23, 10
  br i1 %24, label %25, label %28

25:                                               ; preds = %22
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull @arena_w) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 880)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1760)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2640)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3216)) #5
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cloud, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -16871, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296)) #5
  %26 = tail call i32 @gfx_cell_runs(ptr noundef nonnull @arena_w, i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6304), i32 noundef 256) #6
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %47, label %32

28:                                               ; preds = %22
  %29 = or disjoint i32 %23, 48
  %30 = getelementptr inbounds nuw [64 x i16], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 5024), i32 %23
  tail call void @gfx_glyph_cell(i32 noundef %29, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull %30) #6
  %31 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !12

32:                                               ; preds = %25
  %33 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 880), i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6560), i32 noundef 256) #6
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %47, label %35

35:                                               ; preds = %32
  %36 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1760), i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6816), i32 noundef 256) #6
  %37 = icmp slt i32 %36, 0
  br i1 %37, label %47, label %38

38:                                               ; preds = %35
  %39 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2640), i32 noundef 12, i32 noundef 24, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7072), i32 noundef 256) #6
  %40 = icmp slt i32 %39, 0
  br i1 %40, label %47, label %41

41:                                               ; preds = %38
  %42 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3216), i32 noundef 18, i32 noundef 30, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7328), i32 noundef 256) #6
  %43 = icmp slt i32 %42, 0
  br i1 %43, label %47, label %44

44:                                               ; preds = %41
  %45 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, i16 noundef zeroext -1, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7584), i32 noundef 256) #6
  %46 = icmp slt i32 %45, 0
  br i1 %46, label %47, label %48

47:                                               ; preds = %44, %41, %38, %35, %32, %25
  tail call void @uputs(ptr noundef nonnull @.str) #6
  br label %48

48:                                               ; preds = %47, %44
  %49 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %50 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %51 = getelementptr inbounds nuw i8, ptr %1, i32 12
  br label %52

52:                                               ; preds = %359, %48
  tail call void @uputs(ptr noundef nonnull @.str.1) #6
  tail call void @led(i32 noundef 0, i32 noundef 0) #6
  tail call void @gfx_clear(i16 noundef zeroext -1) #6
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #6
  tail call fastcc void @draw_dashes(i32 noundef 0) #5
  br label %53

53:                                               ; preds = %56, %52
  %54 = phi i32 [ 0, %52 ], [ %58, %56 ]
  %55 = icmp eq i32 %54, 5
  br i1 %55, label %59, label %56

56:                                               ; preds = %53
  %57 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %54
  store i8 48, ptr %57, align 1, !tbaa !13
  %58 = add nuw nsw i32 %54, 1
  br label %53, !llvm.loop !14

59:                                               ; preds = %53
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @sbuf, i32 5), align 1, !tbaa !13
  tail call fastcc void @draw_score() #5
  tail call void @gfx_present() #6
  store i32 150, ptr %1, align 4, !tbaa !15
  store i32 40, ptr %49, align 4, !tbaa !18
  store i32 40, ptr %50, align 4, !tbaa !15
  store i32 64, ptr %51, align 4, !tbaa !18
  tail call void @gfx_blit_runs(i32 noundef 150, i32 noundef 40, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7584)) #6
  tail call void @gfx_blit_runs(i32 noundef 40, i32 noundef 64, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7584)) #6
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 20), align 4, !tbaa !19
  store i32 -1000, ptr @obs, align 4, !tbaa !19
  br label %61

60:                                               ; preds = %311
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  br label %61

61:                                               ; preds = %60, %59
  %62 = phi i32 [ 168, %59 ], [ %268, %60 ]
  %63 = phi i32 [ 0, %59 ], [ %272, %60 ]
  %64 = phi i32 [ 0, %59 ], [ %129, %60 ]
  %65 = phi i32 [ 32, %59 ], [ %302, %60 ]
  %66 = phi i32 [ 512, %59 ], [ %303, %60 ]
  %67 = phi i32 [ 90, %59 ], [ %145, %60 ]
  %68 = phi i32 [ 0, %59 ], [ %292, %60 ]
  %69 = phi i32 [ 0, %59 ], [ %74, %60 ]
  %70 = phi i32 [ 0, %59 ], [ %293, %60 ]
  %71 = phi i32 [ 0, %59 ], [ %118, %60 ]
  %72 = phi i32 [ 0, %59 ], [ %119, %60 ]
  %73 = phi i32 [ 0, %59 ], [ %120, %60 ]
  tail call void @frame_sync(i32 noundef 16667) #6
  tail call void @in_poll() #6
  %74 = add i32 %69, 1
  %75 = load i32, ptr @in_edge, align 4, !tbaa !24
  %76 = and i32 %75, 17
  %77 = icmp ne i32 %76, 0
  %78 = icmp eq i32 %73, 0
  %79 = and i1 %77, %78
  %80 = icmp eq i32 %72, 0
  %81 = select i1 %79, i1 %80, i1 false
  br i1 %81, label %82, label %83

82:                                               ; preds = %61
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 6) #6
  br label %89

83:                                               ; preds = %61
  %84 = icmp sgt i32 %73, 0
  br i1 %84, label %89, label %85

85:                                               ; preds = %83
  %86 = icmp sgt i32 %72, 0
  br i1 %86, label %89, label %87

87:                                               ; preds = %85
  %88 = icmp sgt i32 %71, 0
  br i1 %88, label %89, label %117

89:                                               ; preds = %82, %87, %85, %83
  %90 = phi i32 [ %71, %87 ], [ %71, %85 ], [ %71, %83 ], [ 1200, %82 ]
  %91 = add i32 %90, %72
  %92 = add i32 %90, 255
  %93 = add i32 %92, %72
  %94 = tail call i32 @llvm.smin.i32(i32 %91, i32 255)
  %95 = sub i32 %93, %94
  %96 = lshr i32 %95, 8
  %97 = and i32 %95, -256
  %98 = sub i32 %91, %97
  %99 = add i32 %73, %96
  %100 = add nsw i32 %90, -64
  %101 = tail call i32 @llvm.smin.i32(i32 %99, i32 0)
  %102 = sub i32 %99, %101
  %103 = freeze i32 %102
  %104 = tail call i32 @llvm.smax.i32(i32 %98, i32 0)
  %105 = add nuw i32 %104, 255
  %106 = sub i32 %105, %98
  %107 = lshr i32 %106, 8
  %108 = tail call i32 @llvm.umin.i32(i32 %103, i32 %107)
  %109 = shl nuw i32 %108, 8
  %110 = add i32 %91, %109
  %111 = sub i32 %110, %97
  %112 = sub i32 %99, %108
  %113 = icmp eq i32 %112, 0
  %114 = icmp slt i32 %111, 1
  %115 = and i1 %114, %113
  br i1 %115, label %116, label %117

116:                                              ; preds = %89
  br label %117

117:                                              ; preds = %89, %116, %87
  %118 = phi i32 [ 0, %116 ], [ %100, %89 ], [ %71, %87 ]
  %119 = phi i32 [ 0, %116 ], [ %111, %89 ], [ %72, %87 ]
  %120 = phi i32 [ 0, %116 ], [ %112, %89 ], [ %73, %87 ]
  %121 = add i32 %66, %64
  %122 = add i32 %66, 511
  %123 = add i32 %122, %64
  %124 = tail call i32 @llvm.smin.i32(i32 %121, i32 511)
  %125 = sub i32 %123, %124
  %126 = lshr i32 %125, 8
  %127 = and i32 %126, 16777214
  %128 = and i32 %125, -512
  %129 = sub i32 %121, %128
  %130 = sub nsw i32 168, %120
  %131 = icmp ne i32 %130, %62
  %132 = and i32 %74, 7
  %133 = icmp eq i32 %132, 0
  %134 = select i1 %131, i1 true, i1 %133
  %135 = and i32 %74, 15
  %136 = icmp eq i32 %135, 0
  br i1 %134, label %137, label %138

137:                                              ; preds = %117
  tail call void @gfx_fill(i32 noundef 30, i32 noundef %62, i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1) #6
  br label %138

138:                                              ; preds = %137, %117
  %139 = icmp sgt i32 %67, 0
  %140 = sext i1 %139 to i32
  %141 = add nsw i32 %67, %140
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #7
  %142 = icmp ugt i32 %70, 100
  br label %143

143:                                              ; preds = %194, %138
  %144 = phi i32 [ 0, %138 ], [ %196, %194 ]
  %145 = phi i32 [ %141, %138 ], [ %195, %194 ]
  %146 = icmp eq i32 %144, 2
  br i1 %146, label %147, label %149

147:                                              ; preds = %143
  br i1 %136, label %197, label %148

148:                                              ; preds = %209, %147
  br label %226

149:                                              ; preds = %143
  %150 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %144
  %151 = load i32, ptr %150, align 4, !tbaa !19
  %152 = getelementptr inbounds nuw [2 x i32], ptr %2, i32 0, i32 %144
  store i32 %151, ptr %152, align 4, !tbaa !24
  %153 = icmp slt i32 %151, -100
  br i1 %153, label %154, label %175

154:                                              ; preds = %149
  %155 = icmp eq i32 %145, 0
  br i1 %155, label %156, label %194

156:                                              ; preds = %154
  br i1 %142, label %157, label %161

157:                                              ; preds = %156
  %158 = tail call i32 @rng() #6
  %159 = and i32 %158, 3
  %160 = icmp eq i32 %159, 0
  br i1 %160, label %162, label %161

161:                                              ; preds = %157, %156
  br label %162

162:                                              ; preds = %157, %161
  %163 = phi i32 [ 12, %161 ], [ 18, %157 ]
  %164 = phi i32 [ 24, %161 ], [ 30, %157 ]
  %165 = phi ptr [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 2640), %161 ], [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 3216), %157 ]
  %166 = phi ptr [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 7072), %161 ], [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 7328), %157 ]
  %167 = getelementptr inbounds nuw i8, ptr %150, i32 4
  store i32 %163, ptr %167, align 4, !tbaa !25
  %168 = getelementptr inbounds nuw i8, ptr %150, i32 8
  store i32 %164, ptr %168, align 4, !tbaa !26
  %169 = getelementptr inbounds nuw i8, ptr %150, i32 12
  store ptr %165, ptr %169, align 4, !tbaa !27
  %170 = getelementptr inbounds nuw i8, ptr %150, i32 16
  store ptr %166, ptr %170, align 4, !tbaa !28
  store i32 240, ptr %150, align 4, !tbaa !19
  %171 = tail call i32 @rng_below(i32 noundef 80) #6
  %172 = sub i32 %171, %65
  %173 = add i32 %172, 70
  %174 = tail call i32 @llvm.smax.i32(i32 %173, i32 50)
  br label %194

175:                                              ; preds = %149
  %176 = getelementptr inbounds nuw i8, ptr %150, i32 8
  %177 = load i32, ptr %176, align 4, !tbaa !26
  %178 = sub nsw i32 190, %177
  %179 = getelementptr inbounds nuw i8, ptr %150, i32 4
  %180 = load i32, ptr %179, align 4, !tbaa !25
  tail call void @gfx_fill(i32 noundef %151, i32 noundef %178, i32 noundef %180, i32 noundef %177, i16 noundef zeroext -1) #6
  %181 = load i32, ptr %150, align 4, !tbaa !19
  %182 = sub nsw i32 %181, %127
  store i32 %182, ptr %150, align 4, !tbaa !19
  %183 = load i32, ptr %179, align 4, !tbaa !25
  %184 = add nsw i32 %183, %182
  %185 = icmp slt i32 %184, 1
  br i1 %185, label %186, label %194

186:                                              ; preds = %175
  %187 = add nsw i32 %183, %151
  %188 = icmp sgt i32 %187, 0
  br i1 %188, label %189, label %193

189:                                              ; preds = %186
  %190 = load i32, ptr %176, align 4, !tbaa !26
  %191 = sub nsw i32 190, %190
  %192 = add nsw i32 %187, -1
  tail call void @lcd_flush(i32 noundef 0, i32 noundef %191, i32 noundef %192, i32 noundef 189) #6
  br label %193

193:                                              ; preds = %189, %186
  store i32 -1000, ptr %150, align 4, !tbaa !19
  br label %194

194:                                              ; preds = %175, %193, %154, %162
  %195 = phi i32 [ %174, %162 ], [ %145, %154 ], [ %145, %193 ], [ %145, %175 ]
  %196 = add nuw nsw i32 %144, 1
  br label %143, !llvm.loop !29

197:                                              ; preds = %147, %200
  %198 = phi i32 [ %208, %200 ], [ 0, %147 ]
  %199 = icmp eq i32 %198, 2
  br i1 %199, label %209, label %200

200:                                              ; preds = %197
  %201 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %198
  %202 = load i32, ptr %201, align 4, !tbaa !15
  %203 = getelementptr inbounds nuw i8, ptr %201, i32 4
  %204 = load i32, ptr %203, align 4, !tbaa !18
  tail call void @gfx_fill(i32 noundef %202, i32 noundef %204, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -1) #6
  %205 = add nsw i32 %202, -2
  %206 = icmp slt i32 %202, -18
  %207 = select i1 %206, i32 240, i32 %205
  store i32 %207, ptr %201, align 4, !tbaa !15
  %208 = add nuw nsw i32 %198, 1
  br label %197, !llvm.loop !30

209:                                              ; preds = %197, %224
  %210 = phi i32 [ %225, %224 ], [ 0, %197 ]
  %211 = icmp eq i32 %210, 2
  br i1 %211, label %148, label %212

212:                                              ; preds = %209
  %213 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %210
  %214 = load i32, ptr %213, align 4, !tbaa !15
  %215 = getelementptr inbounds nuw i8, ptr %213, i32 4
  %216 = load i32, ptr %215, align 4, !tbaa !18
  tail call void @gfx_blit_runs(i32 noundef %214, i32 noundef %216, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4296), i32 noundef 20, i32 noundef 5, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7584)) #6
  %217 = tail call i32 @llvm.smax.i32(i32 %214, i32 0)
  %218 = tail call i32 @llvm.smin.i32(i32 %214, i32 218)
  %219 = add nsw i32 %218, 22
  %220 = icmp sgt i32 %219, %217
  br i1 %220, label %221, label %224

221:                                              ; preds = %212
  %222 = add nsw i32 %218, 21
  %223 = add nsw i32 %216, 4
  tail call void @lcd_flush(i32 noundef %217, i32 noundef %216, i32 noundef %222, i32 noundef %223) #6
  br label %224

224:                                              ; preds = %221, %212
  %225 = add nuw nsw i32 %210, 1
  br label %209, !llvm.loop !31

226:                                              ; preds = %148, %254
  %227 = phi i32 [ %255, %254 ], [ 0, %148 ]
  %228 = icmp eq i32 %227, 2
  br i1 %228, label %229, label %230

229:                                              ; preds = %226
  br i1 %134, label %256, label %267

230:                                              ; preds = %226
  %231 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %227
  %232 = load i32, ptr %231, align 4, !tbaa !19
  %233 = icmp slt i32 %232, -100
  br i1 %233, label %254, label %234

234:                                              ; preds = %230
  %235 = getelementptr inbounds nuw i8, ptr %231, i32 8
  %236 = load i32, ptr %235, align 4, !tbaa !26
  %237 = sub nsw i32 190, %236
  %238 = getelementptr inbounds nuw i8, ptr %231, i32 12
  %239 = load ptr, ptr %238, align 4, !tbaa !27
  %240 = getelementptr inbounds nuw i8, ptr %231, i32 4
  %241 = load i32, ptr %240, align 4, !tbaa !25
  %242 = getelementptr inbounds nuw i8, ptr %231, i32 16
  %243 = load ptr, ptr %242, align 4, !tbaa !28
  tail call void @gfx_blit_runs(i32 noundef %232, i32 noundef %237, ptr noundef %239, i32 noundef %241, i32 noundef %236, ptr noundef %243) #6
  %244 = load i32, ptr %231, align 4, !tbaa !19
  %245 = tail call i32 @llvm.smax.i32(i32 %244, i32 0)
  %246 = getelementptr inbounds nuw [2 x i32], ptr %2, i32 0, i32 %227
  %247 = load i32, ptr %246, align 4, !tbaa !24
  %248 = load i32, ptr %240, align 4, !tbaa !25
  %249 = add nsw i32 %248, %247
  %250 = tail call i32 @llvm.smin.i32(i32 %249, i32 240)
  %251 = load i32, ptr %235, align 4, !tbaa !26
  %252 = sub nsw i32 190, %251
  %253 = add nsw i32 %250, -1
  tail call void @lcd_flush(i32 noundef %245, i32 noundef %252, i32 noundef %253, i32 noundef 189) #6
  br label %254

254:                                              ; preds = %230, %234
  %255 = add nuw nsw i32 %227, 1
  br label %226, !llvm.loop !32

256:                                              ; preds = %229
  %257 = and i32 %74, 8
  %258 = icmp eq i32 %257, 0
  %259 = select i1 %258, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 880), ptr @arena_w
  %260 = select i1 %258, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 6560), ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 6304)
  %261 = icmp sgt i32 %120, 0
  %262 = select i1 %261, ptr @arena_w, ptr %259
  %263 = select i1 %261, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 6304), ptr %260
  tail call void @gfx_blit_runs(i32 noundef 30, i32 noundef %130, ptr noundef nonnull %262, i32 noundef 20, i32 noundef 22, ptr noundef nonnull %263) #6
  %264 = tail call i32 @llvm.smin.i32(i32 %130, i32 %62)
  %265 = tail call i32 @llvm.smax.i32(i32 %130, i32 %62)
  %266 = add nsw i32 %265, 21
  tail call void @lcd_flush(i32 noundef 30, i32 noundef %264, i32 noundef 49, i32 noundef %266) #6
  br label %267

267:                                              ; preds = %256, %229
  %268 = phi i32 [ %130, %256 ], [ %62, %229 ]
  %269 = add nsw i32 %127, %63
  %270 = icmp sgt i32 %269, 23
  %271 = add nsw i32 %269, -24
  %272 = select i1 %270, i32 %271, i32 %269
  tail call fastcc void @draw_dashes(i32 noundef %272) #5
  tail call void @lcd_flush(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #6
  %273 = and i32 %74, 3
  %274 = icmp eq i32 %273, 0
  br i1 %274, label %275, label %291

275:                                              ; preds = %267
  %276 = add i32 %70, 1
  br label %277

277:                                              ; preds = %285, %275
  %278 = phi i32 [ 4, %275 ], [ %286, %285 ]
  %279 = icmp sgt i32 %278, -1
  br i1 %279, label %280, label %287

280:                                              ; preds = %277
  %281 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %278
  %282 = load i8, ptr %281, align 1, !tbaa !13
  %283 = add i8 %282, 1
  store i8 %283, ptr %281, align 1, !tbaa !13
  %284 = icmp slt i8 %283, 58
  br i1 %284, label %287, label %285

285:                                              ; preds = %280
  store i8 48, ptr %281, align 1, !tbaa !13
  %286 = add nsw i32 %278, -1
  br label %277, !llvm.loop !33

287:                                              ; preds = %277, %280
  %288 = add i32 %68, 1
  %289 = icmp eq i32 %288, 100
  br i1 %289, label %290, label %291

290:                                              ; preds = %287
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 6) #6
  tail call void @led_rainbow(i32 noundef 30) #6
  br label %291

291:                                              ; preds = %287, %290, %267
  %292 = phi i32 [ 0, %290 ], [ %288, %287 ], [ %68, %267 ]
  %293 = phi i32 [ %276, %290 ], [ %276, %287 ], [ %70, %267 ]
  %294 = icmp slt i32 %66, 1280
  %295 = and i32 %74, 63
  %296 = icmp eq i32 %295, 0
  %297 = select i1 %294, i1 %296, i1 false
  %298 = add nsw i32 %66, 8
  %299 = lshr exact i32 %74, 6
  %300 = and i32 %299, 1
  %301 = select i1 %297, i32 %300, i32 0
  %302 = add nuw nsw i32 %65, %301
  %303 = select i1 %297, i32 %298, i32 %66
  %304 = and i32 %69, 1
  %305 = icmp eq i32 %304, 0
  br i1 %305, label %307, label %306

306:                                              ; preds = %291
  tail call fastcc void @draw_score() #5
  tail call void @lcd_flush(i32 noundef 192, i32 noundef 8, i32 noundef 231, i32 noundef 15) #6
  br label %307

307:                                              ; preds = %306, %291
  %308 = sub i32 189, %120
  %309 = add i32 %120, -172
  %310 = icmp sgt i32 %309, -191
  br label %311

311:                                              ; preds = %330, %307
  %312 = phi i32 [ 0, %307 ], [ %331, %330 ]
  %313 = icmp eq i32 %312, 2
  br i1 %313, label %60, label %314, !llvm.loop !34

314:                                              ; preds = %311
  %315 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %312
  %316 = load i32, ptr %315, align 4, !tbaa !19
  %317 = add i32 %316, 100
  %318 = icmp ult i32 %317, 145
  br i1 %318, label %319, label %330

319:                                              ; preds = %314
  %320 = getelementptr inbounds nuw i8, ptr %315, i32 8
  %321 = load i32, ptr %320, align 4, !tbaa !26
  %322 = sub i32 192, %321
  %323 = getelementptr inbounds nuw i8, ptr %315, i32 4
  %324 = load i32, ptr %323, align 4, !tbaa !25
  %325 = add nsw i32 %324, %316
  %326 = icmp sgt i32 %325, 35
  %327 = icmp sgt i32 %308, %322
  %328 = and i1 %310, %327
  %329 = select i1 %326, i1 %328, i1 false
  br i1 %329, label %332, label %330

330:                                              ; preds = %319, %314
  %331 = add nuw nsw i32 %312, 1
  br label %311, !llvm.loop !35

332:                                              ; preds = %319
  tail call void @led_blink(i32 noundef 16711680, i32 noundef 3) #6
  tail call void @gfx_fill(i32 noundef 30, i32 noundef %130, i32 noundef 20, i32 noundef 22, i16 noundef zeroext -1) #6
  br label %333

333:                                              ; preds = %353, %332
  %334 = phi i32 [ 0, %332 ], [ %354, %353 ]
  %335 = icmp eq i32 %334, 2
  br i1 %335, label %336, label %339

336:                                              ; preds = %333
  tail call void @gfx_blit_runs(i32 noundef 30, i32 noundef %130, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1760), i32 noundef 20, i32 noundef 22, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6816)) #6
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 56, ptr noundef nonnull @.str.2, i16 noundef zeroext -14011, i16 noundef zeroext -1) #6
  tail call void @gfx_text(i32 noundef 24, i32 noundef 80, ptr noundef nonnull @.str.3, i16 noundef zeroext 14823, i16 noundef zeroext -1) #6
  tail call void @gfx_present() #6
  %337 = load i32, ptr @sfx_tab, align 4, !tbaa !24
  %338 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sfx_tab, i32 4), align 4, !tbaa !24
  tail call void @pcm_play(i32 noundef %337, i32 noundef %338) #6
  tail call void @uputs(ptr noundef nonnull @.str.4) #6
  tail call void @uputn(i32 noundef %293) #6
  tail call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %355

339:                                              ; preds = %333
  %340 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %334
  %341 = load i32, ptr %340, align 4, !tbaa !19
  %342 = icmp sgt i32 %341, -101
  br i1 %342, label %343, label %353

343:                                              ; preds = %339
  %344 = getelementptr inbounds nuw i8, ptr %340, i32 8
  %345 = load i32, ptr %344, align 4, !tbaa !26
  %346 = sub nsw i32 190, %345
  %347 = getelementptr inbounds nuw i8, ptr %340, i32 12
  %348 = load ptr, ptr %347, align 4, !tbaa !27
  %349 = getelementptr inbounds nuw i8, ptr %340, i32 4
  %350 = load i32, ptr %349, align 4, !tbaa !25
  %351 = getelementptr inbounds nuw i8, ptr %340, i32 16
  %352 = load ptr, ptr %351, align 4, !tbaa !28
  tail call void @gfx_blit_runs(i32 noundef %341, i32 noundef %346, ptr noundef %348, i32 noundef %350, i32 noundef %345, ptr noundef %352) #6
  br label %353

353:                                              ; preds = %339, %343
  %354 = add nuw nsw i32 %334, 1
  br label %333, !llvm.loop !36

355:                                              ; preds = %360, %336
  tail call void @frame_sync(i32 noundef 16667) #6
  tail call void @in_poll() #6
  %356 = load i32, ptr @in_edge, align 4, !tbaa !24
  %357 = and i32 %356, 17
  %358 = icmp eq i32 %357, 0
  br i1 %358, label %360, label %359

359:                                              ; preds = %355
  tail call void @pcm_stop() #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  br label %52

360:                                              ; preds = %355
  %361 = and i32 %356, 2
  %362 = icmp eq i32 %361, 0
  br i1 %362, label %355, label %363, !llvm.loop !37

363:                                              ; preds = %360
  tail call void @pcm_stop() #6
  tail call void @led(i32 noundef 0, i32 noundef 0) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #7
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_glyph_cell(i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @cell_render(ptr noundef readonly captures(none) %0, i32 noundef range(i32 12, 21) %1, i32 noundef range(i32 5, 31) %2, i16 noundef zeroext range(i16 -16871, 14824) %3, ptr noundef writeonly captures(none) %4) unnamed_addr #3 {
  %6 = mul nuw nsw i32 %2, %1
  br label %7

7:                                                ; preds = %13, %5
  %8 = phi i32 [ 0, %5 ], [ %15, %13 ]
  %9 = icmp eq i32 %8, %6
  br i1 %9, label %10, label %13

10:                                               ; preds = %7
  %11 = sub nuw nsw i32 32, %1
  %12 = shl nuw nsw i32 1, %11
  br label %16

13:                                               ; preds = %7
  %14 = getelementptr inbounds nuw i16, ptr %4, i32 %8
  store i16 -1, ptr %14, align 2, !tbaa !3
  %15 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !38

16:                                               ; preds = %10, %30
  %17 = phi i32 [ %31, %30 ], [ 0, %10 ]
  %18 = icmp eq i32 %17, %2
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  ret void

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i32, ptr %0, i32 %17
  %22 = load i32, ptr %21, align 4, !tbaa !24
  %23 = mul nuw nsw i32 %17, %1
  %24 = getelementptr inbounds nuw i16, ptr %4, i32 %23
  br label %25

25:                                               ; preds = %37, %20
  %26 = phi i32 [ %12, %20 ], [ %38, %37 ]
  %27 = phi i32 [ %1, %20 ], [ %28, %37 ]
  %28 = add nsw i32 %27, -1
  %29 = icmp sgt i32 %27, 0
  br i1 %29, label %32, label %30

30:                                               ; preds = %25
  %31 = add nuw nsw i32 %17, 1
  br label %16, !llvm.loop !39

32:                                               ; preds = %25
  %33 = and i32 %26, %22
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %37, label %35

35:                                               ; preds = %32
  %36 = getelementptr inbounds nuw i16, ptr %24, i32 %28
  store i16 %3, ptr %36, align 2, !tbaa !3
  br label %37

37:                                               ; preds = %32, %35
  %38 = shl i32 %26, 1
  br label %25, !llvm.loop !40
}

; Function Attrs: minsize optsize
declare dso_local i32 @gfx_cell_runs(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_dashes(i32 noundef range(i32 -2147483648, 2147483624) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4496), i32 %0
  %3 = ptrtoint ptr %2 to i32
  tail call void @gdma_rows(i32 noundef ptrtoint (ptr getelementptr inbounds nuw (i8, ptr @fb, i32 93600) to i32), i32 noundef %3, i32 noundef 120, i32 noundef 1, i32 noundef 0, i32 noundef 480) #6
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #6
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score() unnamed_addr #0 {
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %15, %5 ]
  %3 = icmp eq i32 %2, 5
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  ret void

5:                                                ; preds = %1
  %6 = shl nuw nsw i32 %2, 3
  %7 = or disjoint i32 %6, 2112
  %8 = getelementptr inbounds nuw [57600 x i16], ptr @fb, i32 0, i32 %7
  %9 = ptrtoint ptr %8 to i32
  %10 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %2
  %11 = load i8, ptr %10, align 1, !tbaa !13
  %12 = sext i8 %11 to i32
  %13 = getelementptr [64 x i16], ptr getelementptr (i8, ptr @arena_w, i32 -1120), i32 %12
  %14 = ptrtoint ptr %13 to i32
  tail call void @gdma_rows(i32 noundef %9, i32 noundef %14, i32 noundef 4, i32 noundef 8, i32 noundef 480, i32 noundef 16) #6
  %15 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !41
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit_runs(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @lcd_flush(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @led_rainbow(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @pcm_play(i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @pcm_stop() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gdma_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #4

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"short", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = !{!5, !5, i64 0}
!14 = distinct !{!14, !8, !9}
!15 = !{!16, !17, i64 0}
!16 = !{!"cld", !17, i64 0, !17, i64 4}
!17 = !{!"int", !5, i64 0}
!18 = !{!16, !17, i64 4}
!19 = !{!20, !17, i64 0}
!20 = !{!"obst", !17, i64 0, !17, i64 4, !17, i64 8, !21, i64 12, !23, i64 16}
!21 = !{!"p1 short", !22, i64 0}
!22 = !{!"any pointer", !5, i64 0}
!23 = !{!"p1 omnipotent char", !22, i64 0}
!24 = !{!17, !17, i64 0}
!25 = !{!20, !17, i64 4}
!26 = !{!20, !17, i64 8}
!27 = !{!20, !21, i64 12}
!28 = !{!20, !23, i64 16}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !8, !9}
!37 = distinct !{!37, !9}
!38 = distinct !{!38, !8, !9}
!39 = distinct !{!39, !8, !9}
!40 = distinct !{!40, !8, !9}
!41 = distinct !{!41, !8, !9}
