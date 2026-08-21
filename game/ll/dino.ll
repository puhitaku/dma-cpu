; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr }
%struct.cld = type { i32, i32 }

@cell_digit = internal global [10 x [64 x i16]] zeroinitializer, align 2
@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@cell_run_a = internal global [680 x i16] zeroinitializer, align 2
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 123731968, i32 7340032, i32 0], align 4
@cell_run_b = internal global [680 x i16] zeroinitializer, align 2
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 108003328, i32 117440512, i32 0], align 4
@cell_dead = internal global [680 x i16] zeroinitializer, align 2
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@cell_cact_s = internal global [576 x i16] zeroinitializer, align 2
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@cell_cact_l = internal global [900 x i16] zeroinitializer, align 2
@art_cloud = internal constant [5 x i32] [i32 130023424, i32 536051712, i32 1073725440, i32 2147475456, i32 1073709056], align 4
@cell_cloud = internal global [120 x i16] zeroinitializer, align 2
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@sfx_tab = external dso_local local_unnamed_addr global [4 x i32], align 4
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@dashpat = internal global [264 x i16] zeroinitializer, align 2
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
  %6 = getelementptr inbounds nuw [264 x i16], ptr @dashpat, i32 0, i32 %3
  store i16 -1, ptr %6, align 2, !tbaa !3
  %7 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !7

8:                                                ; preds = %2, %14
  %9 = phi i32 [ %15, %14 ], [ 6, %2 ]
  %10 = icmp samesign ult i32 %9, 256
  br i1 %10, label %11, label %20

11:                                               ; preds = %8, %16
  %12 = phi i32 [ %19, %16 ], [ 0, %8 ]
  %13 = icmp eq i32 %12, 8
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  %15 = add nuw nsw i32 %9, 24
  br label %8, !llvm.loop !10

16:                                               ; preds = %11
  %17 = add nuw nsw i32 %12, %9
  %18 = getelementptr inbounds nuw [264 x i16], ptr @dashpat, i32 0, i32 %17
  store i16 14823, ptr %18, align 2, !tbaa !3
  %19 = add nuw nsw i32 %12, 1
  br label %11, !llvm.loop !11

20:                                               ; preds = %8, %27
  %21 = phi i32 [ %30, %27 ], [ 0, %8 ]
  %22 = icmp eq i32 %21, 10
  br i1 %22, label %23, label %27

23:                                               ; preds = %20
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull @cell_run_a, i32 noundef 0, i32 noundef 6) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull @cell_run_b, i32 noundef 0, i32 noundef 6) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, ptr noundef nonnull @cell_dead, i32 noundef 0, i32 noundef 6) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, ptr noundef nonnull @cell_cact_s, i32 noundef 12, i32 noundef 0) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, ptr noundef nonnull @cell_cact_l, i32 noundef 12, i32 noundef 0) #4
  tail call fastcc void @cell_render(ptr noundef nonnull @art_cloud, i32 noundef 20, i32 noundef 5, i16 noundef zeroext -16871, ptr noundef nonnull @cell_cloud, i32 noundef 4, i32 noundef 0) #4
  %24 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %25 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 12
  br label %31

27:                                               ; preds = %20
  %28 = or disjoint i32 %21, 48
  %29 = getelementptr inbounds nuw [10 x [64 x i16]], ptr @cell_digit, i32 0, i32 %21
  tail call void @gfx_glyph_cell(i32 noundef %28, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull %29) #5
  %30 = add nuw nsw i32 %21, 1
  br label %20, !llvm.loop !12

31:                                               ; preds = %285, %23
  tail call void @uputs(ptr noundef nonnull @.str) #5
  tail call void @led(i32 noundef 0, i32 noundef 0) #5
  tail call void @gfx_clear(i16 noundef zeroext -1) #5
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #5
  tail call fastcc void @draw_dashes(i32 noundef 0) #4
  br label %32

32:                                               ; preds = %35, %31
  %33 = phi i32 [ 0, %31 ], [ %37, %35 ]
  %34 = icmp eq i32 %33, 5
  br i1 %34, label %38, label %35

35:                                               ; preds = %32
  %36 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %33
  store i8 48, ptr %36, align 1, !tbaa !13
  %37 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !14

38:                                               ; preds = %32
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @sbuf, i32 5), align 1, !tbaa !13
  tail call fastcc void @draw_score() #4
  tail call void @gfx_present() #5
  store i32 150, ptr %1, align 4, !tbaa !15
  store i32 40, ptr %24, align 4, !tbaa !18
  store i32 40, ptr %25, align 4, !tbaa !15
  store i32 64, ptr %26, align 4, !tbaa !18
  tail call void @gfx_blit(i32 noundef 150, i32 noundef 40, ptr noundef nonnull @cell_cloud, i32 noundef 24, i32 noundef 5) #5
  tail call void @gfx_blit(i32 noundef 40, i32 noundef 64, ptr noundef nonnull @cell_cloud, i32 noundef 24, i32 noundef 5) #5
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 16), align 4, !tbaa !19
  store i32 -1000, ptr @obs, align 4, !tbaa !19
  br label %39

39:                                               ; preds = %254, %38
  %40 = phi i32 [ 168, %38 ], [ %125, %254 ]
  %41 = phi i32 [ 0, %38 ], [ %138, %254 ]
  %42 = phi i32 [ 0, %38 ], [ %107, %254 ]
  %43 = phi i32 [ 32, %38 ], [ %245, %254 ]
  %44 = phi i32 [ 512, %38 ], [ %246, %254 ]
  %45 = phi i32 [ 90, %38 ], [ %132, %254 ]
  %46 = phi i32 [ 0, %38 ], [ %235, %254 ]
  %47 = phi i32 [ 0, %38 ], [ %52, %254 ]
  %48 = phi i32 [ 0, %38 ], [ %236, %254 ]
  %49 = phi i32 [ 0, %38 ], [ %96, %254 ]
  %50 = phi i32 [ 0, %38 ], [ %97, %254 ]
  %51 = phi i32 [ 0, %38 ], [ %98, %254 ]
  tail call void @frame_sync(i32 noundef 16667) #5
  tail call void @in_poll() #5
  %52 = add i32 %47, 1
  %53 = load i32, ptr @in_edge, align 4, !tbaa !23
  %54 = and i32 %53, 17
  %55 = icmp ne i32 %54, 0
  %56 = icmp eq i32 %51, 0
  %57 = and i1 %55, %56
  %58 = icmp eq i32 %50, 0
  %59 = select i1 %57, i1 %58, i1 false
  br i1 %59, label %60, label %61

60:                                               ; preds = %39
  tail call void @snd_play(i32 noundef 900, i32 noundef 35, i32 noundef 6) #5
  br label %67

61:                                               ; preds = %39
  %62 = icmp sgt i32 %51, 0
  br i1 %62, label %67, label %63

63:                                               ; preds = %61
  %64 = icmp sgt i32 %50, 0
  br i1 %64, label %67, label %65

65:                                               ; preds = %63
  %66 = icmp sgt i32 %49, 0
  br i1 %66, label %67, label %95

67:                                               ; preds = %60, %65, %63, %61
  %68 = phi i32 [ %49, %65 ], [ %49, %63 ], [ %49, %61 ], [ 1200, %60 ]
  %69 = add i32 %68, %50
  %70 = add i32 %68, 255
  %71 = add i32 %70, %50
  %72 = tail call i32 @llvm.smin.i32(i32 %69, i32 255)
  %73 = sub i32 %71, %72
  %74 = lshr i32 %73, 8
  %75 = and i32 %73, -256
  %76 = sub i32 %69, %75
  %77 = add i32 %51, %74
  %78 = add nsw i32 %68, -64
  %79 = tail call i32 @llvm.smin.i32(i32 %77, i32 0)
  %80 = sub i32 %77, %79
  %81 = freeze i32 %80
  %82 = tail call i32 @llvm.smax.i32(i32 %76, i32 0)
  %83 = add nuw i32 %82, 255
  %84 = sub i32 %83, %76
  %85 = lshr i32 %84, 8
  %86 = tail call i32 @llvm.umin.i32(i32 %81, i32 %85)
  %87 = shl nuw i32 %86, 8
  %88 = add i32 %69, %87
  %89 = sub i32 %88, %75
  %90 = sub i32 %77, %86
  %91 = icmp eq i32 %90, 0
  %92 = icmp slt i32 %89, 1
  %93 = and i1 %92, %91
  br i1 %93, label %94, label %95

94:                                               ; preds = %67
  br label %95

95:                                               ; preds = %67, %94, %65
  %96 = phi i32 [ 0, %94 ], [ %78, %67 ], [ %49, %65 ]
  %97 = phi i32 [ 0, %94 ], [ %89, %67 ], [ %50, %65 ]
  %98 = phi i32 [ 0, %94 ], [ %90, %67 ], [ %51, %65 ]
  %99 = add i32 %44, %42
  %100 = add i32 %44, 511
  %101 = add i32 %100, %42
  %102 = tail call i32 @llvm.smin.i32(i32 %99, i32 511)
  %103 = sub i32 %101, %102
  %104 = lshr i32 %103, 8
  %105 = and i32 %104, 16777214
  %106 = and i32 %103, -512
  %107 = sub i32 %99, %106
  %108 = sub nsw i32 168, %98
  %109 = icmp eq i32 %108, %40
  br i1 %109, label %110, label %113

110:                                              ; preds = %95
  %111 = and i32 %52, 7
  %112 = icmp eq i32 %111, 0
  br i1 %112, label %113, label %124

113:                                              ; preds = %110, %95
  %114 = and i32 %52, 8
  %115 = icmp eq i32 %114, 0
  %116 = select i1 %115, ptr @cell_run_b, ptr @cell_run_a
  %117 = icmp sgt i32 %98, 0
  %118 = select i1 %117, ptr @cell_run_a, ptr %116
  %119 = sub i32 162, %98
  %120 = add i32 %98, 28
  %121 = tail call i32 @llvm.smin.i32(i32 %120, i32 34)
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %119, ptr noundef nonnull %118, i32 noundef 20, i32 noundef %121) #5
  %122 = sub i32 %121, %98
  %123 = add i32 %122, 161
  tail call void @lcd_flush(i32 noundef 30, i32 noundef %119, i32 noundef 49, i32 noundef %123) #5
  br label %124

124:                                              ; preds = %113, %110
  %125 = phi i32 [ %108, %113 ], [ %40, %110 ]
  %126 = icmp sgt i32 %45, 0
  %127 = sext i1 %126 to i32
  %128 = add nsw i32 %45, %127
  %129 = icmp ugt i32 %48, 100
  br label %130

130:                                              ; preds = %192, %124
  %131 = phi i32 [ 0, %124 ], [ %194, %192 ]
  %132 = phi i32 [ %128, %124 ], [ %193, %192 ]
  %133 = icmp eq i32 %131, 2
  br i1 %133, label %134, label %141

134:                                              ; preds = %130
  %135 = add nsw i32 %105, %41
  %136 = icmp sgt i32 %135, 23
  %137 = add nsw i32 %135, -24
  %138 = select i1 %136, i32 %137, i32 %135
  tail call fastcc void @draw_dashes(i32 noundef %138) #4
  tail call void @lcd_flush(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #5
  %139 = and i32 %52, 15
  %140 = icmp eq i32 %139, 0
  br i1 %140, label %195, label %215

141:                                              ; preds = %130
  %142 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %131
  %143 = getelementptr inbounds nuw i8, ptr %142, i32 8
  %144 = load i32, ptr %143, align 4, !tbaa !24
  %145 = sub nsw i32 190, %144
  %146 = load i32, ptr %142, align 4, !tbaa !19
  %147 = icmp slt i32 %146, -100
  br i1 %147, label %148, label %166

148:                                              ; preds = %141
  %149 = icmp eq i32 %132, 0
  br i1 %149, label %150, label %192

150:                                              ; preds = %148
  br i1 %129, label %151, label %155

151:                                              ; preds = %150
  %152 = tail call i32 @rng() #5
  %153 = and i32 %152, 3
  %154 = icmp eq i32 %153, 0
  br i1 %154, label %156, label %155

155:                                              ; preds = %151, %150
  br label %156

156:                                              ; preds = %151, %155
  %157 = phi i32 [ 12, %155 ], [ 18, %151 ]
  %158 = phi i32 [ 24, %155 ], [ 30, %151 ]
  %159 = phi ptr [ @cell_cact_s, %155 ], [ @cell_cact_l, %151 ]
  %160 = getelementptr inbounds nuw i8, ptr %142, i32 4
  store i32 %157, ptr %160, align 4, !tbaa !25
  store i32 %158, ptr %143, align 4, !tbaa !24
  %161 = getelementptr inbounds nuw i8, ptr %142, i32 12
  store ptr %159, ptr %161, align 4, !tbaa !26
  store i32 240, ptr %142, align 4, !tbaa !19
  %162 = tail call i32 @rng_below(i32 noundef 80) #5
  %163 = sub i32 %162, %43
  %164 = add i32 %163, 70
  %165 = tail call i32 @llvm.smax.i32(i32 %164, i32 50)
  br label %192

166:                                              ; preds = %141
  %167 = sub nsw i32 %146, %105
  store i32 %167, ptr %142, align 4, !tbaa !19
  %168 = getelementptr inbounds nuw i8, ptr %142, i32 4
  %169 = load i32, ptr %168, align 4, !tbaa !25
  %170 = add nsw i32 %169, %167
  %171 = icmp slt i32 %170, 1
  br i1 %171, label %172, label %182

172:                                              ; preds = %166
  %173 = add nsw i32 %169, %146
  %174 = tail call i32 @llvm.smin.i32(i32 %173, i32 228)
  %175 = add nsw i32 %174, 12
  %176 = icmp slt i32 %173, -11
  br i1 %176, label %181, label %177

177:                                              ; preds = %172
  %178 = icmp slt i32 %144, 1
  br i1 %178, label %181, label %179

179:                                              ; preds = %177
  tail call void @gfx_fill(i32 noundef 0, i32 noundef range(i32 -2147483457, -2147483648) %145, i32 noundef %175, i32 noundef %144, i16 noundef zeroext -1) #5
  %180 = add nsw i32 %174, 11
  tail call void @lcd_flush(i32 noundef 0, i32 noundef range(i32 -2147483457, -2147483648) %145, i32 noundef %180, i32 noundef 189) #5
  br label %181

181:                                              ; preds = %172, %177, %179
  store i32 -1000, ptr %142, align 4, !tbaa !19
  br label %192

182:                                              ; preds = %166
  %183 = getelementptr inbounds nuw i8, ptr %142, i32 12
  %184 = load ptr, ptr %183, align 4, !tbaa !26
  %185 = add nsw i32 %169, 12
  tail call void @gfx_blit(i32 noundef %167, i32 noundef %145, ptr noundef %184, i32 noundef %185, i32 noundef %144) #5
  %186 = load i32, ptr %142, align 4, !tbaa !19
  %187 = tail call i32 @llvm.smax.i32(i32 %186, i32 0)
  %188 = load i32, ptr %168, align 4, !tbaa !25
  %189 = add nsw i32 %188, %186
  %190 = tail call i32 @llvm.smin.i32(i32 %189, i32 228)
  %191 = add nsw i32 %190, 11
  tail call void @lcd_flush(i32 noundef %187, i32 noundef %145, i32 noundef %191, i32 noundef 189) #5
  br label %192

192:                                              ; preds = %181, %182, %148, %156
  %193 = phi i32 [ %165, %156 ], [ %132, %148 ], [ %132, %182 ], [ %132, %181 ]
  %194 = add nuw nsw i32 %131, 1
  br label %130, !llvm.loop !27

195:                                              ; preds = %134, %213
  %196 = phi i32 [ %214, %213 ], [ 0, %134 ]
  %197 = icmp eq i32 %196, 2
  br i1 %197, label %215, label %198

198:                                              ; preds = %195
  %199 = getelementptr inbounds nuw [2 x %struct.cld], ptr %1, i32 0, i32 %196
  %200 = load i32, ptr %199, align 4, !tbaa !15
  %201 = add nsw i32 %200, -2
  %202 = icmp slt i32 %200, -22
  %203 = select i1 %202, i32 240, i32 %201
  store i32 %203, ptr %199, align 4, !tbaa !15
  %204 = getelementptr inbounds nuw i8, ptr %199, i32 4
  %205 = load i32, ptr %204, align 4, !tbaa !18
  tail call void @gfx_blit(i32 noundef %203, i32 noundef %205, ptr noundef nonnull @cell_cloud, i32 noundef 24, i32 noundef 5) #5
  %206 = tail call i32 @llvm.smax.i32(i32 %203, i32 0)
  %207 = tail call i32 @llvm.smin.i32(i32 %203, i32 216)
  %208 = add nsw i32 %207, 24
  %209 = icmp sgt i32 %208, %206
  br i1 %209, label %210, label %213

210:                                              ; preds = %198
  %211 = add nsw i32 %207, 23
  %212 = add nsw i32 %205, 4
  tail call void @lcd_flush(i32 noundef %206, i32 noundef %205, i32 noundef %211, i32 noundef %212) #5
  br label %213

213:                                              ; preds = %210, %198
  %214 = add nuw nsw i32 %196, 1
  br label %195, !llvm.loop !28

215:                                              ; preds = %195, %134
  %216 = and i32 %52, 3
  %217 = icmp eq i32 %216, 0
  br i1 %217, label %218, label %234

218:                                              ; preds = %215
  %219 = add i32 %48, 1
  br label %220

220:                                              ; preds = %228, %218
  %221 = phi i32 [ 4, %218 ], [ %229, %228 ]
  %222 = icmp sgt i32 %221, -1
  br i1 %222, label %223, label %230

223:                                              ; preds = %220
  %224 = getelementptr inbounds nuw [6 x i8], ptr @sbuf, i32 0, i32 %221
  %225 = load i8, ptr %224, align 1, !tbaa !13
  %226 = add i8 %225, 1
  store i8 %226, ptr %224, align 1, !tbaa !13
  %227 = icmp slt i8 %226, 58
  br i1 %227, label %230, label %228

228:                                              ; preds = %223
  store i8 48, ptr %224, align 1, !tbaa !13
  %229 = add nsw i32 %221, -1
  br label %220, !llvm.loop !29

230:                                              ; preds = %220, %223
  %231 = add i32 %46, 1
  %232 = icmp eq i32 %231, 100
  br i1 %232, label %233, label %234

233:                                              ; preds = %230
  tail call void @snd_play(i32 noundef 1200, i32 noundef 40, i32 noundef 6) #5
  tail call void @led_rainbow(i32 noundef 30) #5
  br label %234

234:                                              ; preds = %230, %233, %215
  %235 = phi i32 [ 0, %233 ], [ %231, %230 ], [ %46, %215 ]
  %236 = phi i32 [ %219, %233 ], [ %219, %230 ], [ %48, %215 ]
  %237 = icmp slt i32 %44, 1280
  %238 = and i32 %52, 63
  %239 = icmp eq i32 %238, 0
  %240 = select i1 %237, i1 %239, i1 false
  %241 = add nsw i32 %44, 8
  %242 = lshr exact i32 %52, 6
  %243 = and i32 %242, 1
  %244 = select i1 %240, i32 %243, i32 0
  %245 = add nuw nsw i32 %43, %244
  %246 = select i1 %240, i32 %241, i32 %44
  %247 = and i32 %47, 1
  %248 = icmp eq i32 %247, 0
  br i1 %248, label %250, label %249

249:                                              ; preds = %234
  tail call fastcc void @draw_score() #4
  tail call void @lcd_flush(i32 noundef 192, i32 noundef 8, i32 noundef 231, i32 noundef 15) #5
  br label %250

250:                                              ; preds = %249, %234
  %251 = sub i32 189, %98
  %252 = add i32 %98, -172
  %253 = icmp sgt i32 %252, -191
  br label %254

254:                                              ; preds = %273, %250
  %255 = phi i32 [ 0, %250 ], [ %274, %273 ]
  %256 = icmp eq i32 %255, 2
  br i1 %256, label %39, label %257, !llvm.loop !30

257:                                              ; preds = %254
  %258 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %255
  %259 = load i32, ptr %258, align 4, !tbaa !19
  %260 = add i32 %259, 100
  %261 = icmp ult i32 %260, 145
  br i1 %261, label %262, label %273

262:                                              ; preds = %257
  %263 = getelementptr inbounds nuw i8, ptr %258, i32 8
  %264 = load i32, ptr %263, align 4, !tbaa !24
  %265 = sub i32 192, %264
  %266 = getelementptr inbounds nuw i8, ptr %258, i32 4
  %267 = load i32, ptr %266, align 4, !tbaa !25
  %268 = add nsw i32 %267, %259
  %269 = icmp sgt i32 %268, 35
  %270 = icmp sgt i32 %251, %265
  %271 = and i1 %253, %270
  %272 = select i1 %269, i1 %271, i1 false
  br i1 %272, label %275, label %273

273:                                              ; preds = %262, %257
  %274 = add nuw nsw i32 %255, 1
  br label %254, !llvm.loop !31

275:                                              ; preds = %262
  tail call void @led_blink(i32 noundef 16711680, i32 noundef 3) #5
  %276 = sub i32 162, %98
  %277 = add i32 %98, 28
  %278 = tail call i32 @llvm.smin.i32(i32 %277, i32 34)
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %276, ptr noundef nonnull @cell_dead, i32 noundef 20, i32 noundef %278) #5
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 56, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #5
  tail call void @gfx_text(i32 noundef 24, i32 noundef 80, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #5
  tail call void @gfx_present() #5
  %279 = load i32, ptr @sfx_tab, align 4, !tbaa !23
  %280 = load i32, ptr getelementptr inbounds nuw (i8, ptr @sfx_tab, i32 4), align 4, !tbaa !23
  tail call void @pcm_play(i32 noundef %279, i32 noundef %280) #5
  tail call void @uputs(ptr noundef nonnull @.str.3) #5
  tail call void @uputn(i32 noundef %236) #5
  tail call void @uputs(ptr noundef nonnull @.str.4) #5
  br label %281

281:                                              ; preds = %286, %275
  tail call void @frame_sync(i32 noundef 16667) #5
  tail call void @in_poll() #5
  %282 = load i32, ptr @in_edge, align 4, !tbaa !23
  %283 = and i32 %282, 17
  %284 = icmp eq i32 %283, 0
  br i1 %284, label %286, label %285

285:                                              ; preds = %281
  tail call void @pcm_stop() #5
  br label %31

286:                                              ; preds = %281
  %287 = and i32 %282, 2
  %288 = icmp eq i32 %287, 0
  br i1 %288, label %281, label %289, !llvm.loop !32

289:                                              ; preds = %286
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
  %2 = getelementptr inbounds [264 x i16], ptr @dashpat, i32 0, i32 %0
  %3 = ptrtoint ptr %2 to i32
  tail call void @gdma_rows(i32 noundef ptrtoint (ptr getelementptr inbounds nuw (i8, ptr @fb, i32 93600) to i32), i32 noundef %3, i32 noundef 120, i32 noundef 1, i32 noundef 0, i32 noundef 0) #5
  tail call void @gfx_damage(i32 noundef 0, i32 noundef 195, i32 noundef 239, i32 noundef 195) #5
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score() unnamed_addr #0 {
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %16, %5 ]
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
  %13 = add nsw i32 %12, -48
  %14 = getelementptr inbounds [10 x [64 x i16]], ptr @cell_digit, i32 0, i32 %13
  %15 = ptrtoint ptr %14 to i32
  tail call void @gdma_rows(i32 noundef %9, i32 noundef %15, i32 noundef 4, i32 noundef 8, i32 noundef 480, i32 noundef 16) #5
  %16 = add nuw nsw i32 %2, 1
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
