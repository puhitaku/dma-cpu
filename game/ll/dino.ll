; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr }
%struct.cld = type { i32, i32 }

@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@cell_run_a = internal global [440 x i16] zeroinitializer, align 2
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 123731968, i32 7340032, i32 0], align 4
@cell_run_b = internal global [440 x i16] zeroinitializer, align 2
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@cell_dead = internal global [440 x i16] zeroinitializer, align 2
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@cell_cact_s = internal global [288 x i16] zeroinitializer, align 2
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@cell_cact_l = internal global [540 x i16] zeroinitializer, align 2
@art_cloud = internal constant [5 x i32] [i32 130023424, i32 536051712, i32 1073725440, i32 2147475456, i32 1073709056], align 4
@cell_cloud = internal global [100 x i16] zeroinitializer, align 2
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  %1 = alloca [2 x %struct.cld], align 4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_a) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_b) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_dead) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_s) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_l) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cloud, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -16871, i16 noundef zeroext -1, ptr noundef nonnull @cell_cloud) #4
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 12
  br label %5

5:                                                ; preds = %166, %0
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @led(i32 noundef 1064976, i32 noundef 0) #4
  tail call void @gfx_clear(i16 noundef zeroext -1) #4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #4
  tail call fastcc void @draw_dashes(i32 noundef 0) #5
  tail call fastcc void @draw_score(i32 noundef 0) #5
  tail call void @gfx_present() #4
  store i32 150, ptr %1, align 4, !tbaa !3
  store i32 40, ptr %2, align 4, !tbaa !8
  store i32 40, ptr %3, align 4, !tbaa !3
  store i32 64, ptr %4, align 4, !tbaa !8
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 40, ptr noundef nonnull @cell_cloud, i32 noundef 20, i32 noundef 5) #4
  tail call void @gfx_blit(i32 noundef 40, i32 noundef 64, ptr noundef nonnull @cell_cloud, i32 noundef 20, i32 noundef 5) #4
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 16), align 4, !tbaa !9
  store i32 -1000, ptr @obs, align 4, !tbaa !9
  br label %6

6:                                                ; preds = %145, %5
  %7 = phi i32 [ 0, %5 ], [ %53, %145 ]
  %8 = phi i32 [ 0, %5 ], [ %49, %145 ]
  %9 = phi i32 [ 1024, %5 ], [ %127, %145 ]
  %10 = phi i32 [ 45, %5 ], [ %45, %145 ]
  %11 = phi i32 [ 0, %5 ], [ %15, %145 ]
  %12 = phi i32 [ 0, %5 ], [ %110, %145 ]
  %13 = phi i32 [ 0, %5 ], [ %32, %145 ]
  %14 = phi i32 [ 0, %5 ], [ %33, %145 ]
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %15 = add i32 %11, 1
  %16 = load i32, ptr @in_edge, align 4, !tbaa !13
  %17 = and i32 %16, 17
  %18 = icmp ne i32 %17, 0
  %19 = icmp eq i32 %14, 0
  %20 = and i1 %18, %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %6
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 3) #4
  br label %25

22:                                               ; preds = %6
  br i1 %19, label %23, label %25

23:                                               ; preds = %22
  %24 = icmp sgt i32 %13, 0
  br i1 %24, label %25, label %31

25:                                               ; preds = %21, %23, %22
  %26 = phi i32 [ %13, %23 ], [ %13, %22 ], [ 2400, %21 ]
  %27 = add nsw i32 %26, %14
  %28 = add nsw i32 %26, -256
  %29 = icmp slt i32 %27, 1
  br i1 %29, label %30, label %31

30:                                               ; preds = %25
  br label %31

31:                                               ; preds = %25, %30, %23
  %32 = phi i32 [ 0, %30 ], [ %28, %25 ], [ %13, %23 ]
  %33 = phi i32 [ 0, %30 ], [ %27, %25 ], [ 0, %23 ]
  %34 = add nsw i32 %9, %8
  %35 = ashr i32 %34, 8
  %36 = and i32 %35, -2
  %37 = icmp sgt i32 %10, 0
  %38 = sext i1 %37 to i32
  %39 = add nsw i32 %10, %38
  %40 = icmp ugt i32 %12, 100
  %41 = ashr i32 %9, 7
  %42 = and i32 %41, -2
  br label %43

43:                                               ; preds = %86, %31
  %44 = phi i32 [ 0, %31 ], [ %88, %86 ]
  %45 = phi i32 [ %39, %31 ], [ %87, %86 ]
  %46 = icmp eq i32 %44, 2
  br i1 %46, label %47, label %56

47:                                               ; preds = %43
  %48 = shl nsw i32 %36, 8
  %49 = sub nsw i32 %34, %48
  %50 = add nsw i32 %36, %7
  %51 = icmp sgt i32 %50, 23
  %52 = add nsw i32 %50, -24
  %53 = select i1 %51, i32 %52, i32 %50
  tail call fastcc void @draw_dashes(i32 noundef %53) #5
  %54 = and i32 %15, 7
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %89, label %101

56:                                               ; preds = %43
  %57 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %44
  %58 = load i32, ptr %57, align 4, !tbaa !9
  %59 = icmp slt i32 %58, -100
  br i1 %59, label %60, label %79

60:                                               ; preds = %56
  %61 = icmp eq i32 %45, 0
  br i1 %61, label %62, label %86

62:                                               ; preds = %60
  br i1 %40, label %63, label %67

63:                                               ; preds = %62
  %64 = tail call i32 @rng() #4
  %65 = and i32 %64, 3
  %66 = icmp eq i32 %65, 0
  br i1 %66, label %68, label %67

67:                                               ; preds = %63, %62
  br label %68

68:                                               ; preds = %63, %67
  %69 = phi i32 [ 12, %67 ], [ 18, %63 ]
  %70 = phi i32 [ 24, %67 ], [ 30, %63 ]
  %71 = phi ptr [ @cell_cact_s, %67 ], [ @cell_cact_l, %63 ]
  %72 = getelementptr inbounds nuw i8, ptr %57, i32 4
  store i32 %69, ptr %72, align 4, !tbaa !14
  %73 = getelementptr inbounds nuw i8, ptr %57, i32 8
  store i32 %70, ptr %73, align 4, !tbaa !15
  %74 = getelementptr inbounds nuw i8, ptr %57, i32 12
  store ptr %71, ptr %74, align 4, !tbaa !16
  store i32 240, ptr %57, align 4, !tbaa !9
  %75 = tail call i32 @rng_below(i32 noundef 40) #4
  %76 = sub i32 %75, %42
  %77 = add i32 %76, 30
  %78 = tail call i32 @llvm.smax.i32(i32 %77, i32 18)
  br label %86

79:                                               ; preds = %56
  %80 = sub nsw i32 %58, %36
  %81 = getelementptr inbounds nuw i8, ptr %57, i32 4
  %82 = load i32, ptr %81, align 4, !tbaa !14
  %83 = add nsw i32 %82, %80
  %84 = icmp slt i32 %83, 1
  %85 = select i1 %84, i32 -1000, i32 %80
  store i32 %85, ptr %57, align 4
  br label %86

86:                                               ; preds = %60, %68, %79
  %87 = phi i32 [ %45, %79 ], [ %78, %68 ], [ %45, %60 ]
  %88 = add nuw nsw i32 %44, 1
  br label %43, !llvm.loop !17

89:                                               ; preds = %47, %92
  %90 = phi i32 [ %100, %92 ], [ 0, %47 ]
  %91 = icmp eq i32 %90, 2
  br i1 %91, label %101, label %92

92:                                               ; preds = %89
  %93 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %90
  %94 = load i32, ptr %93, align 4, !tbaa !3
  %95 = getelementptr inbounds nuw i8, ptr %93, i32 4
  %96 = load i32, ptr %95, align 4, !tbaa !8
  tail call void @gfx_fill(i32 noundef %94, i32 noundef %96, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -1) #4
  %97 = add nsw i32 %94, -2
  %98 = icmp slt i32 %94, -18
  %99 = select i1 %98, i32 240, i32 %97
  store i32 %99, ptr %93, align 4, !tbaa !3
  tail call void @gfx_blit(i32 noundef %99, i32 noundef %96, ptr noundef nonnull @cell_cloud, i32 noundef 20, i32 noundef 5) #4
  %100 = add nuw nsw i32 %90, 1
  br label %89, !llvm.loop !20

101:                                              ; preds = %89, %47
  %102 = and i32 %11, 1
  %103 = icmp eq i32 %102, 0
  br i1 %103, label %109, label %104

104:                                              ; preds = %101
  %105 = add i32 %12, 1
  %106 = urem i32 %105, 100
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %108, label %109

108:                                              ; preds = %104
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 3) #4
  tail call void @led(i32 noundef 4210752, i32 noundef 1064976) #4
  br label %109

109:                                              ; preds = %104, %108, %101
  %110 = phi i32 [ %105, %108 ], [ %105, %104 ], [ %12, %101 ]
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 100, i32 noundef 240, i32 noundef 90, i16 noundef zeroext -1) #4
  %111 = lshr i32 %33, 8
  %112 = sub nsw i32 168, %111
  %113 = and i32 %15, 4
  %114 = icmp eq i32 %113, 0
  %115 = icmp eq i32 %33, 0
  %116 = select i1 %115, i1 %114, i1 false
  %117 = select i1 %116, ptr @cell_run_b, ptr @cell_run_a
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %112, ptr noundef nonnull %117, i32 noundef 20, i32 noundef 22) #4
  br label %118

118:                                              ; preds = %140, %109
  %119 = phi i32 [ 0, %109 ], [ %141, %140 ]
  %120 = icmp eq i32 %119, 2
  br i1 %120, label %121, label %128

121:                                              ; preds = %118
  %122 = icmp slt i32 %9, 2560
  %123 = and i32 %15, 31
  %124 = icmp eq i32 %123, 0
  %125 = select i1 %122, i1 %124, i1 false
  %126 = add nsw i32 %9, 16
  %127 = select i1 %125, i32 %126, i32 %9
  br i1 %103, label %143, label %142

128:                                              ; preds = %118
  %129 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %119
  %130 = load i32, ptr %129, align 4, !tbaa !9
  %131 = icmp sgt i32 %130, -100
  br i1 %131, label %132, label %140

132:                                              ; preds = %128
  %133 = getelementptr inbounds nuw i8, ptr %129, i32 8
  %134 = load i32, ptr %133, align 4, !tbaa !15
  %135 = sub nsw i32 190, %134
  %136 = getelementptr inbounds nuw i8, ptr %129, i32 12
  %137 = load ptr, ptr %136, align 4, !tbaa !16
  %138 = getelementptr inbounds nuw i8, ptr %129, i32 4
  %139 = load i32, ptr %138, align 4, !tbaa !14
  tail call void @gfx_blit(i32 noundef %130, i32 noundef %135, ptr noundef %137, i32 noundef %139, i32 noundef %134) #4
  br label %140

140:                                              ; preds = %128, %132
  %141 = add nuw nsw i32 %119, 1
  br label %118, !llvm.loop !21

142:                                              ; preds = %121
  tail call fastcc void @draw_score(i32 noundef %110) #5
  br label %143

143:                                              ; preds = %142, %121
  tail call void @gfx_present() #4
  %144 = sub nsw i32 189, %111
  br label %145

145:                                              ; preds = %163, %143
  %146 = phi i32 [ 0, %143 ], [ %164, %163 ]
  %147 = icmp eq i32 %146, 2
  br i1 %147, label %6, label %148, !llvm.loop !22

148:                                              ; preds = %145
  %149 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %146
  %150 = load i32, ptr %149, align 4, !tbaa !9
  %151 = add i32 %150, 100
  %152 = icmp ult i32 %151, 145
  br i1 %152, label %153, label %163

153:                                              ; preds = %148
  %154 = getelementptr inbounds nuw i8, ptr %149, i32 8
  %155 = load i32, ptr %154, align 4, !tbaa !15
  %156 = sub i32 192, %155
  %157 = getelementptr inbounds nuw i8, ptr %149, i32 4
  %158 = load i32, ptr %157, align 4, !tbaa !14
  %159 = add nsw i32 %158, %150
  %160 = icmp sgt i32 %159, 35
  %161 = icmp sgt i32 %144, %156
  %162 = select i1 %160, i1 %161, i1 false
  br i1 %162, label %165, label %163

163:                                              ; preds = %153, %148
  %164 = add nuw nsw i32 %146, 1
  br label %145, !llvm.loop !23

165:                                              ; preds = %153
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 18) #4
  tail call void @led(i32 noundef 6291456, i32 noundef 6291456) #4
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %112, ptr noundef nonnull @cell_dead, i32 noundef 20, i32 noundef 22) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 56, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #4
  tail call void @gfx_text(i32 noundef 24, i32 noundef 80, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #4
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  tail call void @uputn(i32 noundef %110) #4
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  br label %166

166:                                              ; preds = %170, %165
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %167 = load i32, ptr @in_edge, align 4, !tbaa !13
  %168 = and i32 %167, 17
  %169 = icmp eq i32 %168, 0
  br i1 %169, label %170, label %5

170:                                              ; preds = %166
  %171 = and i32 %167, 2
  %172 = icmp eq i32 %171, 0
  br i1 %172, label %166, label %173, !llvm.loop !24

173:                                              ; preds = %170
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_sprite(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_dashes(i32 noundef %0) unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 195, i32 noundef 240, i32 noundef 1, i16 noundef zeroext -1) #4
  %2 = sub nsw i32 6, %0
  br label %3

3:                                                ; preds = %17, %1
  %4 = phi i32 [ %2, %1 ], [ %18, %17 ]
  %5 = icmp slt i32 %4, 240
  br i1 %5, label %7, label %6

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = tail call i32 @llvm.smax.i32(i32 %4, i32 0)
  %9 = tail call i32 @llvm.smin.i32(i32 %4, i32 0)
  %10 = add nsw i32 %9, 8
  %11 = add nsw i32 %10, %8
  %12 = icmp sgt i32 %11, 240
  %13 = sub nuw nsw i32 240, %8
  %14 = select i1 %12, i32 %13, i32 %10
  %15 = icmp sgt i32 %14, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %7
  tail call void @gfx_fill(i32 noundef %8, i32 noundef 195, i32 noundef %14, i32 noundef 1, i16 noundef zeroext 14823) #4
  br label %17

17:                                               ; preds = %16, %7
  %18 = add nsw i32 %4, 24
  br label %3, !llvm.loop !25
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score(i32 noundef %0) unnamed_addr #0 {
  %2 = alloca [6 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %2) #6
  call void @numstr(ptr noundef nonnull %2, i32 noundef 5, i32 noundef %0) #4
  call void @gfx_text(i32 noundef 192, i32 noundef 8, ptr noundef nonnull %2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #4
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"cld", !5, i64 0, !5, i64 4}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!4, !5, i64 4}
!9 = !{!10, !5, i64 0}
!10 = !{!"obst", !5, i64 0, !5, i64 4, !5, i64 8, !11, i64 12}
!11 = !{!"p1 short", !12, i64 0}
!12 = !{!"any pointer", !6, i64 0}
!13 = !{!5, !5, i64 0}
!14 = !{!10, !5, i64 4}
!15 = !{!10, !5, i64 8}
!16 = !{!10, !11, i64 12}
!17 = distinct !{!17, !18, !19}
!18 = !{!"llvm.loop.mustprogress"}
!19 = !{!"llvm.loop.unroll.disable"}
!20 = distinct !{!20, !18, !19}
!21 = distinct !{!21, !18, !19}
!22 = distinct !{!22, !19}
!23 = distinct !{!23, !18, !19}
!24 = distinct !{!24, !19}
!25 = distinct !{!25, !18, !19}
