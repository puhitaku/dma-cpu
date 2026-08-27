; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr }
%struct.cld = type { i32, i32 }

@arena_w = external dso_local global [2304 x i32], align 4
@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 123731968, i32 7340032, i32 0], align 4
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@art_cloud = internal constant [5 x i32] [i32 130023424, i32 536051712, i32 1073725440, i32 2147475456, i32 1073709056], align 4
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@sfx_tab = external dso_local local_unnamed_addr global [4 x i32], align 4
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@fb = external dso_local global [57600 x i16], align 2
@sbuf = internal unnamed_addr global [6 x i8] zeroinitializer, align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  %1 = alloca [2 x %struct.cld], align 4
  br label %2

2:                                                ; preds = %5, %0
  %3 = phi i32 [ 0, %0 ], [ %7, %5 ]
  %4 = icmp eq i32 %3, 264
  br i1 %4, label %8, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 7272), i32 %3
  store i16 -1, ptr %6, align 2, !tbaa !3
  %7 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !7

8:                                                ; preds = %2, %16
  %9 = phi i32 [ %17, %16 ], [ 6, %2 ]
  %10 = icmp samesign ult i32 %9, 256
  br i1 %10, label %11, label %21

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 7272), i32 %9
  br label %13

13:                                               ; preds = %18, %11
  %14 = phi i32 [ %20, %18 ], [ 0, %11 ]
  %15 = icmp eq i32 %14, 8
  br i1 %15, label %16, label %18

16:                                               ; preds = %13
  %17 = add nuw nsw i32 %9, 24
  br label %8, !llvm.loop !10

18:                                               ; preds = %13
  %19 = getelementptr inbounds nuw i16, ptr %12, i32 %14
  store i16 14823, ptr %19, align 2, !tbaa !3
  %20 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !11

21:                                               ; preds = %8, %28
  %22 = phi i32 [ %31, %28 ], [ 0, %8 ]
  %23 = icmp eq i32 %22, 10
  br i1 %23, label %24, label %28

24:                                               ; preds = %21
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull @arena_w, i32 noundef 0, i32 noundef 6) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1360), i32 noundef 0, i32 noundef 6) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2720), i32 noundef 0, i32 noundef 6) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4080), i32 noundef 12, i32 noundef 0) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 5232), i32 noundef 12, i32 noundef 0) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cloud, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -16871, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7032), i32 noundef 4, i32 noundef 0) #4
  %25 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %27 = getelementptr inbounds nuw i8, ptr %1, i32 12
  br label %32

28:                                               ; preds = %21
  %29 = or disjoint i32 %22, 48
  %30 = getelementptr inbounds nuw [64 x i16], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 7800), i32 %22
  tail call void @gfx_glyph_cell(i32 noundef %29, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull %30) #5
  %31 = add nuw nsw i32 %22, 1
  br label %21, !llvm.loop !12

32:                                               ; preds = %286, %24
  tail call void @uputs(ptr noundef nonnull @.str) #5
  tail call void @led(i32 noundef 0, i32 noundef 0) #5
  tail call void @gfx_clear(i16 noundef zeroext -1) #5
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #5
  tail call fastcc void @draw_dashes(i32 noundef 0) #4
  br label %33

33:                                               ; preds = %36, %32
  %34 = phi i32 [ 0, %32 ], [ %38, %36 ]
  %35 = icmp eq i32 %34, 5
  br i1 %35, label %39, label %36

36:                                               ; preds = %33
  %37 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %34
  store i8 48, ptr %37, align 1, !tbaa !13
  %38 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !14

39:                                               ; preds = %33
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @sbuf, i32 5), align 1, !tbaa !13
  tail call fastcc void @draw_score() #4
  tail call void @gfx_present() #5
  store i32 150, ptr %1, align 4, !tbaa !15
  store i32 40, ptr %25, align 4, !tbaa !18
  store i32 40, ptr %26, align 4, !tbaa !15
  store i32 64, ptr %27, align 4, !tbaa !18
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 40, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7032), i32 noundef 24, i32 noundef 5) #5
  tail call void @gfx_blit(i32 noundef 40, i32 noundef 64, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7032), i32 noundef 24, i32 noundef 5) #5
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 16), align 4, !tbaa !19
  store i32 -1000, ptr @obs, align 4, !tbaa !19
  br label %40

40:                                               ; preds = %255, %39
  %41 = phi i32 [ 168, %39 ], [ %126, %255 ]
  %42 = phi i32 [ 0, %39 ], [ %139, %255 ]
  %43 = phi i32 [ 0, %39 ], [ %108, %255 ]
  %44 = phi i32 [ 32, %39 ], [ %246, %255 ]
  %45 = phi i32 [ 512, %39 ], [ %247, %255 ]
  %46 = phi i32 [ 90, %39 ], [ %133, %255 ]
  %47 = phi i32 [ 0, %39 ], [ %236, %255 ]
  %48 = phi i32 [ 0, %39 ], [ %53, %255 ]
  %49 = phi i32 [ 0, %39 ], [ %237, %255 ]
  %50 = phi i32 [ 0, %39 ], [ %97, %255 ]
  %51 = phi i32 [ 0, %39 ], [ %98, %255 ]
  %52 = phi i32 [ 0, %39 ], [ %99, %255 ]
  tail call void @frame_sync(i32 noundef 16667) #5
  tail call void @in_poll() #5
  %53 = add i32 %48, 1
  %54 = load i32, ptr @in_edge, align 4, !tbaa !23
  %55 = and i32 %54, 17
  %56 = icmp ne i32 %55, 0
  %57 = icmp eq i32 %52, 0
  %58 = and i1 %56, %57
  %59 = icmp eq i32 %51, 0
  %60 = select i1 %58, i1 %59, i1 false
  br i1 %60, label %61, label %62

61:                                               ; preds = %40
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 6) #5
  br label %68

62:                                               ; preds = %40
  %63 = icmp sgt i32 %52, 0
  br i1 %63, label %68, label %64

64:                                               ; preds = %62
  %65 = icmp sgt i32 %51, 0
  br i1 %65, label %68, label %66

66:                                               ; preds = %64
  %67 = icmp sgt i32 %50, 0
  br i1 %67, label %68, label %96

68:                                               ; preds = %61, %66, %64, %62
  %69 = phi i32 [ %50, %66 ], [ %50, %64 ], [ %50, %62 ], [ 1200, %61 ]
  %70 = add i32 %69, %51
  %71 = add i32 %69, 255
  %72 = add i32 %71, %51
  %73 = tail call i32 @llvm.smin.i32(i32 %70, i32 255)
  %74 = sub i32 %72, %73
  %75 = lshr i32 %74, 8
  %76 = and i32 %74, -256
  %77 = sub i32 %70, %76
  %78 = add i32 %52, %75
  %79 = add nsw i32 %69, -64
  %80 = tail call i32 @llvm.smin.i32(i32 %78, i32 0)
  %81 = sub i32 %78, %80
  %82 = freeze i32 %81
  %83 = tail call i32 @llvm.smax.i32(i32 %77, i32 0)
  %84 = add nuw i32 %83, 255
  %85 = sub i32 %84, %77
  %86 = lshr i32 %85, 8
  %87 = tail call i32 @llvm.umin.i32(i32 %82, i32 %86)
  %88 = shl nuw i32 %87, 8
  %89 = add i32 %70, %88
  %90 = sub i32 %89, %76
  %91 = sub i32 %78, %87
  %92 = icmp eq i32 %91, 0
  %93 = icmp slt i32 %90, 1
  %94 = and i1 %93, %92
  br i1 %94, label %95, label %96

95:                                               ; preds = %68
  br label %96

96:                                               ; preds = %68, %95, %66
  %97 = phi i32 [ 0, %95 ], [ %79, %68 ], [ %50, %66 ]
  %98 = phi i32 [ 0, %95 ], [ %90, %68 ], [ %51, %66 ]
  %99 = phi i32 [ 0, %95 ], [ %91, %68 ], [ %52, %66 ]
  %100 = add i32 %45, %43
  %101 = add i32 %45, 511
  %102 = add i32 %101, %43
  %103 = tail call i32 @llvm.smin.i32(i32 %100, i32 511)
  %104 = sub i32 %102, %103
  %105 = lshr i32 %104, 8
  %106 = and i32 %105, 16777214
  %107 = and i32 %104, -512
  %108 = sub i32 %100, %107
  %109 = sub nsw i32 168, %99
  %110 = icmp eq i32 %109, %41
  br i1 %110, label %111, label %114

111:                                              ; preds = %96
  %112 = and i32 %53, 7
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %114, label %125

114:                                              ; preds = %111, %96
  %115 = and i32 %53, 8
  %116 = icmp eq i32 %115, 0
  %117 = select i1 %116, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1360), ptr @arena_w
  %118 = icmp sgt i32 %99, 0
  %119 = select i1 %118, ptr @arena_w, ptr %117
  %120 = sub i32 162, %99
  %121 = add i32 %99, 28
  %122 = tail call i32 @llvm.smin.i32(i32 %121, i32 34)
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %120, ptr noundef nonnull %119, i32 noundef 20, i32 noundef %122) #5
  %123 = sub i32 %122, %99
  %124 = add i32 %123, 161
  tail call void @lcd_flush(i32 noundef 30, i32 noundef %120, i32 noundef 49, i32 noundef %124) #5
  br label %125

125:                                              ; preds = %114, %111
  %126 = phi i32 [ %109, %114 ], [ %41, %111 ]
  %127 = icmp sgt i32 %46, 0
  %128 = sext i1 %127 to i32
  %129 = add nsw i32 %46, %128
  %130 = icmp ugt i32 %49, 100
  br label %131

131:                                              ; preds = %193, %125
  %132 = phi i32 [ 0, %125 ], [ %195, %193 ]
  %133 = phi i32 [ %129, %125 ], [ %194, %193 ]
  %134 = icmp eq i32 %132, 2
  br i1 %134, label %135, label %142

135:                                              ; preds = %131
  %136 = add nsw i32 %106, %42
  %137 = icmp sgt i32 %136, 23
  %138 = add nsw i32 %136, -24
  %139 = select i1 %137, i32 %138, i32 %136
  tail call fastcc void @draw_dashes(i32 noundef %139) #4
  tail call void @lcd_flush(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #5
  %140 = and i32 %53, 15
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %196, label %216

142:                                              ; preds = %131
  %143 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %132
  %144 = getelementptr inbounds nuw i8, ptr %143, i32 8
  %145 = load i32, ptr %144, align 4, !tbaa !24
  %146 = sub nsw i32 190, %145
  %147 = load i32, ptr %143, align 4, !tbaa !19
  %148 = icmp slt i32 %147, -100
  br i1 %148, label %149, label %167

149:                                              ; preds = %142
  %150 = icmp eq i32 %133, 0
  br i1 %150, label %151, label %193

151:                                              ; preds = %149
  br i1 %130, label %152, label %156

152:                                              ; preds = %151
  %153 = tail call i32 @rng() #5
  %154 = and i32 %153, 3
  %155 = icmp eq i32 %154, 0
  br i1 %155, label %157, label %156

156:                                              ; preds = %152, %151
  br label %157

157:                                              ; preds = %152, %156
  %158 = phi i32 [ 12, %156 ], [ 18, %152 ]
  %159 = phi i32 [ 24, %156 ], [ 30, %152 ]
  %160 = phi ptr [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 4080), %156 ], [ getelementptr inbounds nuw (i8, ptr @arena_w, i32 5232), %152 ]
  %161 = getelementptr inbounds nuw i8, ptr %143, i32 4
  store i32 %158, ptr %161, align 4, !tbaa !25
  store i32 %159, ptr %144, align 4, !tbaa !24
  %162 = getelementptr inbounds nuw i8, ptr %143, i32 12
  store ptr %160, ptr %162, align 4, !tbaa !26
  store i32 240, ptr %143, align 4, !tbaa !19
  %163 = tail call i32 @rng_below(i32 noundef 80) #5
  %164 = sub i32 %163, %44
  %165 = add i32 %164, 70
  %166 = tail call i32 @llvm.smax.i32(i32 %165, i32 50)
  br label %193

167:                                              ; preds = %142
  %168 = sub nsw i32 %147, %106
  store i32 %168, ptr %143, align 4, !tbaa !19
  %169 = getelementptr inbounds nuw i8, ptr %143, i32 4
  %170 = load i32, ptr %169, align 4, !tbaa !25
  %171 = add nsw i32 %170, %168
  %172 = icmp slt i32 %171, 1
  br i1 %172, label %173, label %183

173:                                              ; preds = %167
  %174 = add nsw i32 %170, %147
  %175 = tail call i32 @llvm.smin.i32(i32 %174, i32 228)
  %176 = add nsw i32 %175, 12
  %177 = icmp slt i32 %174, -11
  br i1 %177, label %182, label %178

178:                                              ; preds = %173
  %179 = icmp slt i32 %145, 1
  br i1 %179, label %182, label %180

180:                                              ; preds = %178
  tail call void @gfx_fill(i32 noundef 0, i32 noundef range(i32 -2147483457, -2147483648) %146, i32 noundef %176, i32 noundef %145, i16 noundef zeroext -1) #5
  %181 = add nsw i32 %175, 11
  tail call void @lcd_flush(i32 noundef 0, i32 noundef range(i32 -2147483457, -2147483648) %146, i32 noundef %181, i32 noundef 189) #5
  br label %182

182:                                              ; preds = %173, %178, %180
  store i32 -1000, ptr %143, align 4, !tbaa !19
  br label %193

183:                                              ; preds = %167
  %184 = getelementptr inbounds nuw i8, ptr %143, i32 12
  %185 = load ptr, ptr %184, align 4, !tbaa !26
  %186 = add nsw i32 %170, 12
  tail call void @gfx_blit(i32 noundef %168, i32 noundef %146, ptr noundef %185, i32 noundef %186, i32 noundef %145) #5
  %187 = load i32, ptr %143, align 4, !tbaa !19
  %188 = tail call i32 @llvm.smax.i32(i32 %187, i32 0)
  %189 = load i32, ptr %169, align 4, !tbaa !25
  %190 = add nsw i32 %189, %187
  %191 = tail call i32 @llvm.smin.i32(i32 %190, i32 228)
  %192 = add nsw i32 %191, 11
  tail call void @lcd_flush(i32 noundef %188, i32 noundef %146, i32 noundef %192, i32 noundef 189) #5
  br label %193

193:                                              ; preds = %182, %183, %149, %157
  %194 = phi i32 [ %166, %157 ], [ %133, %149 ], [ %133, %183 ], [ %133, %182 ]
  %195 = add nuw nsw i32 %132, 1
  br label %131, !llvm.loop !27

196:                                              ; preds = %135, %214
  %197 = phi i32 [ %215, %214 ], [ 0, %135 ]
  %198 = icmp eq i32 %197, 2
  br i1 %198, label %216, label %199

199:                                              ; preds = %196
  %200 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %197
  %201 = load i32, ptr %200, align 4, !tbaa !15
  %202 = add nsw i32 %201, -2
  %203 = icmp slt i32 %201, -22
  %204 = select i1 %203, i32 240, i32 %202
  store i32 %204, ptr %200, align 4, !tbaa !15
  %205 = getelementptr inbounds nuw i8, ptr %200, i32 4
  %206 = load i32, ptr %205, align 4, !tbaa !18
  tail call void @gfx_blit(i32 noundef %204, i32 noundef %206, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 7032), i32 noundef 24, i32 noundef 5) #5
  %207 = tail call i32 @llvm.smax.i32(i32 %204, i32 0)
  %208 = tail call i32 @llvm.smin.i32(i32 %204, i32 216)
  %209 = add nsw i32 %208, 24
  %210 = icmp sgt i32 %209, %207
  br i1 %210, label %211, label %214

211:                                              ; preds = %199
  %212 = add nsw i32 %208, 23
  %213 = add nsw i32 %206, 4
  tail call void @lcd_flush(i32 noundef %207, i32 noundef %206, i32 noundef %212, i32 noundef %213) #5
  br label %214

214:                                              ; preds = %211, %199
  %215 = add nuw nsw i32 %197, 1
  br label %196, !llvm.loop !28

216:                                              ; preds = %196, %135
  %217 = and i32 %53, 3
  %218 = icmp eq i32 %217, 0
  br i1 %218, label %219, label %235

219:                                              ; preds = %216
  %220 = add i32 %49, 1
  br label %221

221:                                              ; preds = %229, %219
  %222 = phi i32 [ 4, %219 ], [ %230, %229 ]
  %223 = icmp sgt i32 %222, -1
  br i1 %223, label %224, label %231

224:                                              ; preds = %221
  %225 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %222
  %226 = load i8, ptr %225, align 1, !tbaa !13
  %227 = add i8 %226, 1
  store i8 %227, ptr %225, align 1, !tbaa !13
  %228 = icmp slt i8 %227, 58
  br i1 %228, label %231, label %229

229:                                              ; preds = %224
  store i8 48, ptr %225, align 1, !tbaa !13
  %230 = add nsw i32 %222, -1
  br label %221, !llvm.loop !29

231:                                              ; preds = %221, %224
  %232 = add i32 %47, 1
  %233 = icmp eq i32 %232, 100
  br i1 %233, label %234, label %235

234:                                              ; preds = %231
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 6) #5
  tail call void @led_rainbow(i32 noundef 30) #5
  br label %235

235:                                              ; preds = %231, %234, %216
  %236 = phi i32 [ 0, %234 ], [ %232, %231 ], [ %47, %216 ]
  %237 = phi i32 [ %220, %234 ], [ %220, %231 ], [ %49, %216 ]
  %238 = icmp slt i32 %45, 1280
  %239 = and i32 %53, 63
  %240 = icmp eq i32 %239, 0
  %241 = select i1 %238, i1 %240, i1 false
  %242 = add nsw i32 %45, 8
  %243 = lshr exact i32 %53, 6
  %244 = and i32 %243, 1
  %245 = select i1 %241, i32 %244, i32 0
  %246 = add nuw nsw i32 %44, %245
  %247 = select i1 %241, i32 %242, i32 %45
  %248 = and i32 %48, 1
  %249 = icmp eq i32 %248, 0
  br i1 %249, label %251, label %250

250:                                              ; preds = %235
  tail call fastcc void @draw_score() #4
  tail call void @lcd_flush(i32 noundef 192, i32 noundef 8, i32 noundef 231, i32 noundef 15) #5
  br label %251

251:                                              ; preds = %250, %235
  %252 = sub i32 189, %99
  %253 = add i32 %99, -172
  %254 = icmp sgt i32 %253, -191
  br label %255

255:                                              ; preds = %274, %251
  %256 = phi i32 [ 0, %251 ], [ %275, %274 ]
  %257 = icmp eq i32 %256, 2
  br i1 %257, label %40, label %258, !llvm.loop !30

258:                                              ; preds = %255
  %259 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %256
  %260 = load i32, ptr %259, align 4, !tbaa !19
  %261 = add i32 %260, 100
  %262 = icmp ult i32 %261, 145
  br i1 %262, label %263, label %274

263:                                              ; preds = %258
  %264 = getelementptr inbounds nuw i8, ptr %259, i32 8
  %265 = load i32, ptr %264, align 4, !tbaa !24
  %266 = sub i32 192, %265
  %267 = getelementptr inbounds nuw i8, ptr %259, i32 4
  %268 = load i32, ptr %267, align 4, !tbaa !25
  %269 = add nsw i32 %268, %260
  %270 = icmp sgt i32 %269, 35
  %271 = icmp sgt i32 %252, %266
  %272 = and i1 %254, %271
  %273 = select i1 %270, i1 %272, i1 false
  br i1 %273, label %276, label %274

274:                                              ; preds = %263, %258
  %275 = add nuw nsw i32 %256, 1
  br label %255, !llvm.loop !31

276:                                              ; preds = %263
  tail call void @led_blink(i32 noundef 16711680, i32 noundef 3) #5
  %277 = sub i32 162, %99
  %278 = add i32 %99, 28
  %279 = tail call i32 @llvm.smin.i32(i32 %278, i32 34)
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %277, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2720), i32 noundef 20, i32 noundef %279) #5
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 56, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #5
  tail call void @gfx_text(i32 noundef 24, i32 noundef 80, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #5
  tail call void @gfx_present() #5
  %280 = load i32, ptr @sfx_tab, align 4, !tbaa !23
  %281 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sfx_tab, i32 4), align 4, !tbaa !23
  tail call void @pcm_play(i32 noundef %280, i32 noundef %281) #5
  tail call void @uputs(ptr noundef nonnull @.str.3) #5
  tail call void @uputn(i32 noundef %237) #5
  tail call void @uputs(ptr noundef nonnull @.str.4) #5
  br label %282

282:                                              ; preds = %287, %276
  tail call void @frame_sync(i32 noundef 16667) #5
  tail call void @in_poll() #5
  %283 = load i32, ptr @in_edge, align 4, !tbaa !23
  %284 = and i32 %283, 17
  %285 = icmp eq i32 %284, 0
  br i1 %285, label %287, label %286

286:                                              ; preds = %282
  tail call void @pcm_stop() #5
  br label %32

287:                                              ; preds = %282
  %288 = and i32 %283, 2
  %289 = icmp eq i32 %288, 0
  br i1 %289, label %282, label %290, !llvm.loop !32

290:                                              ; preds = %287
  tail call void @pcm_stop() #5
  tail call void @led(i32 noundef 0, i32 noundef 0) #5
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_glyph_cell(i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @cell_render(ptr noundef readonly captures(none) %0, i32 noundef range(i32 12, 21) %1, i32 noundef range(i32 5, 31) %2, i16 noundef zeroext range(i16 -16871, 14824) %3, ptr noundef writeonly captures(none) %4, i32 noundef range(i32 0, 13) %5, i32 noundef range(i32 0, 7) %6) unnamed_addr #2 {
  %8 = add nuw nsw i32 %5, %1
  %9 = shl nuw nsw i32 %6, 1
  %10 = add nuw nsw i32 %9, %2
  %11 = mul nuw nsw i32 %10, %8
  br label %12

12:                                               ; preds = %18, %7
  %13 = phi i32 [ 0, %7 ], [ %20, %18 ]
  %14 = icmp eq i32 %13, %11
  br i1 %14, label %15, label %18

15:                                               ; preds = %12
  %16 = sub nuw nsw i32 32, %1
  %17 = shl nuw nsw i32 1, %16
  br label %21

18:                                               ; preds = %12
  %19 = getelementptr inbounds nuw i16, ptr %4, i32 %13
  store i16 -1, ptr %19, align 2, !tbaa !3
  %20 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !33

21:                                               ; preds = %15, %36
  %22 = phi i32 [ %37, %36 ], [ 0, %15 ]
  %23 = icmp eq i32 %22, %2
  br i1 %23, label %24, label %25

24:                                               ; preds = %21
  ret void

25:                                               ; preds = %21
  %26 = getelementptr inbounds nuw i32, ptr %0, i32 %22
  %27 = load i32, ptr %26, align 4, !tbaa !23
  %28 = add nuw nsw i32 %22, %6
  %29 = mul nuw nsw i32 %28, %8
  %30 = getelementptr inbounds nuw i16, ptr %4, i32 %29
  br label %31

31:                                               ; preds = %43, %25
  %32 = phi i32 [ %17, %25 ], [ %44, %43 ]
  %33 = phi i32 [ %1, %25 ], [ %34, %43 ]
  %34 = add nsw i32 %33, -1
  %35 = icmp sgt i32 %33, 0
  br i1 %35, label %38, label %36

36:                                               ; preds = %31
  %37 = add nuw nsw i32 %22, 1
  br label %21, !llvm.loop !34

38:                                               ; preds = %31
  %39 = and i32 %32, %27
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %43, label %41

41:                                               ; preds = %38
  %42 = getelementptr inbounds nuw i16, ptr %30, i32 %34
  store i16 %3, ptr %42, align 2, !tbaa !3
  br label %43

43:                                               ; preds = %38, %41
  %44 = shl i32 %32, 1
  br label %31, !llvm.loop !35
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_dashes(i32 noundef range(i32 -2147483648, 2147483624) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds i16, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 7272), i32 %0
  %3 = ptrtoint ptr %2 to i32
  tail call void @gdma_rows(i32 noundef ptrtoint (ptr getelementptr inbounds nuw (i8, ptr @fb, i32 93600) to i32), i32 noundef %3, i32 noundef 120, i32 noundef 1, i32 noundef 0, i32 noundef 480) #5
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #5
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
  %13 = getelementptr [64 x i16], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 1656), i32 %12
  %14 = ptrtoint ptr %13 to i32
  tail call void @gdma_rows(i32 noundef %9, i32 noundef %14, i32 noundef 4, i32 noundef 8, i32 noundef 480, i32 noundef 16) #5
  %15 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !36
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

; Function Attrs: minsize optsize
declare dso_local void @lcd_flush(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_rainbow(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @pcm_play(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @pcm_stop() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_rows(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #3

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { minsize nobuiltin optsize "no-builtins" }
attributes #5 = { minsize nobuiltin nounwind optsize "no-builtins" }

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
!20 = !{!"obst", !17, i64 0, !17, i64 4, !17, i64 8, !21, i64 12}
!21 = !{!"p1 short", !22, i64 0}
!22 = !{!"any pointer", !5, i64 0}
!23 = !{!17, !17, i64 0}
!24 = !{!20, !17, i64 8}
!25 = !{!20, !17, i64 4}
!26 = !{!20, !21, i64 12}
!27 = distinct !{!27, !8, !9}
!28 = distinct !{!28, !8, !9}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
!36 = distinct !{!36, !8, !9}
