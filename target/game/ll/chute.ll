; ModuleID = 'chute.c'
source_filename = "chute.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"chute: start\0A\00", align 1
@art_heli_la = internal constant [12 x i32] [i32 33554432, i32 -262144, i32 33554432, i32 534776832, i32 1072700416, i32 2147481984, i32 -536870976, i32 2146962560, i32 1072693248, i32 138412032, i32 1073217536, i32 0], align 4
@arena_w = external dso_local global [2304 x i32], align 4
@art_heli_lb = internal constant [12 x i32] [i32 33554432, i32 532676608, i32 33554432, i32 534776832, i32 1072700416, i32 2147481984, i32 -536870976, i32 2146962560, i32 1072693248, i32 138412032, i32 1073217536, i32 0], align 4
@art_heli_ra = internal constant [12 x i32] [i32 1024, i32 262128, i32 1024, i32 50364288, i32 58785728, i32 436207584, i32 1073741744, i32 318898144, i32 65472, i32 8448, i32 131008, i32 0], align 4
@art_heli_rb = internal constant [12 x i32] [i32 1024, i32 16256, i32 1024, i32 50364288, i32 58785728, i32 436207584, i32 1073741744, i32 318898144, i32 65472, i32 8448, i32 131008, i32 0], align 4
@art_para = internal constant [20 x i32] [i32 66846720, i32 268369920, i32 536838144, i32 1073725440, i32 858996736, i32 287473664, i32 279216128, i32 145031168, i32 150339584, i32 83099648, i32 116785152, i32 66846720, i32 33030144, i32 33030144, i32 33030144, i32 15728640, i32 26738688, i32 26738688, i32 51118080, i32 0], align 4
@art_fall = internal constant [10 x i32] [i32 201326592, i32 201326592, i32 -1639972864, i32 -4194304, i32 1056964608, i32 1056964608, i32 855638016, i32 1635778560, i32 -1061158912, i32 0], align 4
@art_stand = internal constant [12 x i32] [i32 -1941962752, i32 -1639972864, i32 -557842432, i32 2139095040, i32 1056964608, i32 1056964608, i32 1056964608, i32 1056964608, i32 503316480, i32 855638016, i32 855638016, i32 1635778560], align 4
@art_gun = internal constant [12 x i32] [i32 8355840, i32 33546240, i32 134215680, i32 268434432, i32 536870400, i32 1073741568, i32 1073741568, i32 2147483520, i32 2147483520, i32 -64, i32 -64, i32 1840700160], align 4
@.str.1 = private unnamed_addr constant [27 x i8] c"chute: run table overflow\0A\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"shoot the chutes!\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.3 = private unnamed_addr constant [13 x i8] c"chute: quit\0A\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.4 = private unnamed_addr constant [14 x i8] c"chute: again\0A\00", align 1
@adx = internal unnamed_addr constant [9 x i8] c"\FA\FB\FC\FE\00\02\04\05\06", align 1
@ady = internal unnamed_addr constant [9 x i8] c"\FC\FB\FA\F9\F9\F9\FA\FB\FC", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"Destroyed!\00", align 1
@.str.6 = private unnamed_addr constant [19 x i8] c"Press to try again\00", align 1
@.str.7 = private unnamed_addr constant [18 x i8] c"chute: game over\0A\00", align 1
@.str.8 = private unnamed_addr constant [22 x i8] c"chute: gun destroyed\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @chute_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #6
  tail call void @led(i32 noundef 263695, i32 noundef 263695) #6
  tail call fastcc void @art_cell(ptr noundef nonnull @art_heli_la, i32 noundef 28, i32 noundef 12, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 768)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_heli_lb, i32 noundef 28, i32 noundef 12, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 1440)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_heli_ra, i32 noundef 28, i32 noundef 12, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2112)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_heli_rb, i32 noundef 28, i32 noundef 12, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 2784)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_para, i32 noundef 20, i32 noundef 20, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3456)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_fall, i32 noundef 10, i32 noundef 10, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4256)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_fall, i32 noundef 10, i32 noundef 10, i16 noundef zeroext -28381, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4456)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_stand, i32 noundef 10, i32 noundef 12, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4656)) #7
  tail call fastcc void @art_cell(ptr noundef nonnull @art_gun, i32 noundef 26, i32 noundef 12, i16 noundef zeroext 6371, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4896)) #7
  br label %1

1:                                                ; preds = %18, %0
  %2 = phi i32 [ 0, %0 ], [ %26, %18 ]
  %3 = phi i32 [ 0, %0 ], [ %25, %18 ]
  %4 = icmp eq i32 %2, 4
  br i1 %4, label %5, label %18

5:                                                ; preds = %1
  %6 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3456), i32 noundef 20, i32 noundef 20, i16 noundef zeroext -23083, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6160), i32 noundef 224) #6
  %7 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4256), i32 noundef 10, i32 noundef 10, i16 noundef zeroext -23083, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6384), i32 noundef 64) #6
  %8 = or i32 %7, %6
  %9 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4456), i32 noundef 10, i32 noundef 10, i16 noundef zeroext -23083, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6448), i32 noundef 64) #6
  %10 = or i32 %8, %9
  %11 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4656), i32 noundef 10, i32 noundef 12, i16 noundef zeroext -23083, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6512), i32 noundef 64) #6
  %12 = or i32 %10, %11
  %13 = tail call i32 @gfx_cell_runs(ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4896), i32 noundef 26, i32 noundef 12, i16 noundef zeroext -23083, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6576), i32 noundef 96) #6
  %14 = or i32 %12, %13
  %15 = lshr i32 %14, 31
  %16 = or i32 %15, %3
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %29, label %27

18:                                               ; preds = %1
  %19 = mul nuw nsw i32 %2, 672
  %20 = getelementptr inbounds nuw i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 768), i32 %19
  %21 = mul nuw nsw i32 %2, 160
  %22 = getelementptr inbounds nuw i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 5520), i32 %21
  %23 = tail call i32 @gfx_cell_runs(ptr noundef nonnull %20, i32 noundef 28, i32 noundef 12, i16 noundef zeroext -23083, ptr noundef nonnull %22, i32 noundef 160) #6
  %24 = lshr i32 %23, 31
  %25 = or i32 %24, %3
  %26 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !3

27:                                               ; preds = %79, %5
  %28 = phi ptr [ @.str.1, %5 ], [ @.str.4, %79 ]
  tail call void @uputs(ptr noundef nonnull %28) #6
  br label %29

29:                                               ; preds = %27, %5
  tail call void @gfx_clear(i16 noundef zeroext -23083) #6
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 226, i32 noundef 240, i32 noundef 14, i16 noundef zeroext 14854) #6
  br label %30

30:                                               ; preds = %33, %29
  %31 = phi i32 [ 0, %29 ], [ %35, %33 ]
  %32 = icmp eq i32 %31, 3
  br i1 %32, label %36, label %33

33:                                               ; preds = %30
  %34 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %31
  store i32 -999, ptr %34, align 4, !tbaa !6
  %35 = add nuw nsw i32 %31, 1
  br label %30, !llvm.loop !10

36:                                               ; preds = %30, %39
  %37 = phi i32 [ %41, %39 ], [ 0, %30 ]
  %38 = icmp eq i32 %37, 2
  br i1 %38, label %42, label %39

39:                                               ; preds = %36
  %40 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %37
  store i32 -999, ptr %40, align 4, !tbaa !6
  %41 = add nuw nsw i32 %37, 1
  br label %36, !llvm.loop !11

42:                                               ; preds = %36, %45
  %43 = phi i32 [ %47, %45 ], [ 0, %36 ]
  %44 = icmp eq i32 %43, 6
  br i1 %44, label %48, label %45

45:                                               ; preds = %42
  %46 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %43
  store i32 0, ptr %46, align 4, !tbaa !6
  %47 = add nuw nsw i32 %43, 1
  br label %42, !llvm.loop !12

48:                                               ; preds = %42, %51
  %49 = phi i32 [ %53, %51 ], [ 0, %42 ]
  %50 = icmp eq i32 %49, 4
  br i1 %50, label %54, label %51

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %49
  store i32 -999, ptr %52, align 4, !tbaa !6
  %53 = add nuw nsw i32 %49, 1
  br label %48, !llvm.loop !13

54:                                               ; preds = %48, %58
  %55 = phi i32 [ %60, %58 ], [ 0, %48 ]
  %56 = icmp eq i32 %55, 12
  br i1 %56, label %57, label %58

57:                                               ; preds = %54
  store i32 4, ptr @arena_w, align 4, !tbaa !14
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !19
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4, !tbaa !21
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 464), align 4, !tbaa !22
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  tail call fastcc void @draw_gun() #7
  tail call fastcc void @draw_score() #7
  tail call void @gfx_text(i32 noundef 60, i32 noundef 110, ptr noundef nonnull @.str.2, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  br label %61

58:                                               ; preds = %54
  %59 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 272), i32 0, i32 %55
  store i32 -999, ptr %59, align 4, !tbaa !6
  %60 = add nuw nsw i32 %55, 1
  br label %54, !llvm.loop !24

61:                                               ; preds = %717, %57
  tail call void @gfx_present() #6
  br label %62

62:                                               ; preds = %61, %79
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %63 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  %64 = add i32 %63, 1
  store i32 %64, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  %65 = icmp eq i32 %64, 60
  br i1 %65, label %66, label %67

66:                                               ; preds = %62
  tail call void @gfx_fill(i32 noundef 60, i32 noundef 110, i32 noundef 136, i32 noundef 8, i16 noundef zeroext -23083) #6
  br label %67

67:                                               ; preds = %66, %62
  %68 = load i32, ptr @in_down, align 4, !tbaa !6
  %69 = and i32 %68, 16
  %70 = icmp eq i32 %69, 0
  %71 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4
  %72 = add nsw i32 %71, 1
  %73 = select i1 %70, i32 0, i32 %72
  store i32 %73, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 16), align 4, !tbaa !19
  %74 = icmp sgt i32 %73, 45
  br i1 %74, label %75, label %76

75:                                               ; preds = %67
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  tail call void @snd_off() #6
  ret void

76:                                               ; preds = %67
  %77 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  %78 = icmp eq i32 %77, 0
  br i1 %78, label %83, label %79

79:                                               ; preds = %76
  %80 = load i32, ptr @in_edge, align 4, !tbaa !6
  %81 = and i32 %80, 16
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %62, label %27, !llvm.loop !25

83:                                               ; preds = %76, %95
  %84 = phi i32 [ %96, %95 ], [ 0, %76 ]
  %85 = icmp eq i32 %84, 3
  br i1 %85, label %97, label %86

86:                                               ; preds = %83
  %87 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %84
  %88 = load i32, ptr %87, align 4, !tbaa !6
  %89 = icmp eq i32 %88, -999
  br i1 %89, label %95, label %90

90:                                               ; preds = %86
  %91 = add nsw i32 %88, -3
  %92 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %84
  %93 = load i32, ptr %92, align 4, !tbaa !6
  %94 = add nsw i32 %93, -3
  tail call fastcc void @sky(i32 noundef %91, i32 noundef %94, i32 noundef 6, i32 noundef 6) #7
  br label %95

95:                                               ; preds = %86, %90
  %96 = add nuw nsw i32 %84, 1
  br label %83, !llvm.loop !26

97:                                               ; preds = %83, %105
  %98 = phi i32 [ %106, %105 ], [ 0, %83 ]
  %99 = icmp eq i32 %98, 2
  br i1 %99, label %107, label %100

100:                                              ; preds = %97
  %101 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %98
  %102 = load i32, ptr %101, align 4, !tbaa !6
  %103 = icmp eq i32 %102, -999
  br i1 %103, label %105, label %104

104:                                              ; preds = %100
  tail call fastcc void @heli_draw(i32 noundef %98, i32 noundef 1) #7
  br label %105

105:                                              ; preds = %100, %104
  %106 = add nuw nsw i32 %98, 1
  br label %97, !llvm.loop !27

107:                                              ; preds = %97, %114
  %108 = phi i32 [ %115, %114 ], [ 0, %97 ]
  %109 = icmp eq i32 %108, 6
  br i1 %109, label %116, label %110

110:                                              ; preds = %107
  %111 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %108
  %112 = load i32, ptr %111, align 4, !tbaa !6
  switch i32 %112, label %113 [
    i32 0, label %114
    i32 4, label %114
  ]

113:                                              ; preds = %110
  tail call fastcc void @troop_erase(i32 noundef %108) #7
  br label %114

114:                                              ; preds = %110, %110, %113
  %115 = add nuw nsw i32 %108, 1
  br label %107, !llvm.loop !28

116:                                              ; preds = %107, %128
  %117 = phi i32 [ %129, %128 ], [ 0, %107 ]
  %118 = icmp eq i32 %117, 4
  br i1 %118, label %130, label %119

119:                                              ; preds = %116
  %120 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %117
  %121 = load i32, ptr %120, align 4, !tbaa !6
  %122 = icmp eq i32 %121, -999
  br i1 %122, label %128, label %123

123:                                              ; preds = %119
  %124 = add nsw i32 %121, -2
  %125 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 224), i32 0, i32 %117
  %126 = load i32, ptr %125, align 4, !tbaa !6
  %127 = add nsw i32 %126, -2
  tail call fastcc void @sky(i32 noundef %124, i32 noundef %127, i32 noundef 6, i32 noundef 6) #7
  br label %128

128:                                              ; preds = %119, %123
  %129 = add nuw nsw i32 %117, 1
  br label %116, !llvm.loop !29

130:                                              ; preds = %116, %146
  %131 = phi i32 [ %147, %146 ], [ 0, %116 ]
  %132 = icmp eq i32 %131, 12
  br i1 %132, label %133, label %137

133:                                              ; preds = %130
  %134 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %135 = icmp eq i32 %134, 0
  br i1 %135, label %136, label %148

136:                                              ; preds = %173, %180, %169, %133
  br label %194

137:                                              ; preds = %130
  %138 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 272), i32 0, i32 %131
  %139 = load i32, ptr %138, align 4, !tbaa !6
  %140 = icmp eq i32 %139, -999
  br i1 %140, label %146, label %141

141:                                              ; preds = %137
  %142 = add nsw i32 %139, -1
  %143 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), i32 0, i32 %131
  %144 = load i32, ptr %143, align 4, !tbaa !6
  %145 = add nsw i32 %144, -1
  tail call fastcc void @sky(i32 noundef %142, i32 noundef %145, i32 noundef 6, i32 noundef 5) #7
  br label %146

146:                                              ; preds = %137, %141
  %147 = add nuw nsw i32 %131, 1
  br label %130, !llvm.loop !30

148:                                              ; preds = %133
  %149 = load i32, ptr @in_edge, align 4, !tbaa !6
  %150 = and i32 %149, 4
  %151 = icmp ne i32 %150, 0
  %152 = load i32, ptr @arena_w, align 4
  %153 = icmp sgt i32 %152, 0
  %154 = select i1 %151, i1 %153, i1 false
  br i1 %154, label %155, label %159

155:                                              ; preds = %148
  %156 = add nsw i32 %152, -1
  store i32 %156, ptr @arena_w, align 4, !tbaa !14
  tail call fastcc void @turret_erase() #7
  %157 = load i32, ptr @in_edge, align 4, !tbaa !6
  %158 = load i32, ptr @arena_w, align 4
  br label %159

159:                                              ; preds = %155, %148
  %160 = phi i32 [ %158, %155 ], [ %152, %148 ]
  %161 = phi i32 [ %157, %155 ], [ %149, %148 ]
  %162 = and i32 %161, 8
  %163 = icmp ne i32 %162, 0
  %164 = icmp slt i32 %160, 8
  %165 = select i1 %163, i1 %164, i1 false
  br i1 %165, label %166, label %169

166:                                              ; preds = %159
  %167 = add nsw i32 %160, 1
  store i32 %167, ptr @arena_w, align 4, !tbaa !14
  tail call fastcc void @turret_erase() #7
  %168 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %169

169:                                              ; preds = %166, %159
  %170 = phi i32 [ %168, %166 ], [ %161, %159 ]
  %171 = and i32 %170, 17
  %172 = icmp eq i32 %171, 0
  br i1 %172, label %136, label %173

173:                                              ; preds = %169, %192
  %174 = phi i32 [ %193, %192 ], [ 0, %169 ]
  %175 = icmp eq i32 %174, 3
  br i1 %175, label %136, label %176

176:                                              ; preds = %173
  %177 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %174
  %178 = load i32, ptr %177, align 4, !tbaa !6
  %179 = icmp eq i32 %178, -999
  br i1 %179, label %180, label %192

180:                                              ; preds = %176
  %181 = load i32, ptr @arena_w, align 4, !tbaa !14
  %182 = getelementptr inbounds [9 x i8], ptr @adx, i32 0, i32 %181
  %183 = load i8, ptr %182, align 1, !tbaa !31
  %184 = sext i8 %183 to i32
  %185 = add nsw i32 %184, 120
  store i32 %185, ptr %177, align 4, !tbaa !6
  %186 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %174
  store i32 200, ptr %186, align 4, !tbaa !6
  %187 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %174
  store i32 %184, ptr %187, align 4, !tbaa !6
  %188 = getelementptr inbounds [9 x i8], ptr @ady, i32 0, i32 %181
  %189 = load i8, ptr %188, align 1, !tbaa !31
  %190 = sext i8 %189 to i32
  %191 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %174
  store i32 %190, ptr %191, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 900, i32 noundef 40, i32 noundef 2) #6
  br label %136

192:                                              ; preds = %176
  %193 = add nuw nsw i32 %174, 1
  br label %173, !llvm.loop !32

194:                                              ; preds = %136, %221
  %195 = phi i32 [ %222, %221 ], [ 0, %136 ]
  %196 = icmp eq i32 %195, 3
  br i1 %196, label %197, label %202

197:                                              ; preds = %194
  %198 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 464), align 4, !tbaa !22
  %199 = add i32 %198, -1
  store i32 %199, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 464), align 4, !tbaa !22
  %200 = icmp eq i32 %199, 0
  br i1 %200, label %223, label %201

201:                                              ; preds = %230, %237, %197
  br label %253

202:                                              ; preds = %194
  %203 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %195
  %204 = load i32, ptr %203, align 4, !tbaa !6
  %205 = icmp eq i32 %204, -999
  br i1 %205, label %221, label %206

206:                                              ; preds = %202
  %207 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %195
  %208 = load i32, ptr %207, align 4, !tbaa !6
  %209 = add nsw i32 %208, %204
  store i32 %209, ptr %203, align 4, !tbaa !6
  %210 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %195
  %211 = load i32, ptr %210, align 4, !tbaa !6
  %212 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %195
  %213 = load i32, ptr %212, align 4, !tbaa !6
  %214 = add nsw i32 %213, %211
  store i32 %214, ptr %212, align 4, !tbaa !6
  %215 = icmp slt i32 %214, 2
  br i1 %215, label %220, label %216

216:                                              ; preds = %206
  %217 = icmp slt i32 %209, 3
  br i1 %217, label %220, label %218

218:                                              ; preds = %216
  %219 = icmp samesign ugt i32 %209, 236
  br i1 %219, label %220, label %221

220:                                              ; preds = %218, %216, %206
  store i32 -999, ptr %203, align 4, !tbaa !6
  br label %221

221:                                              ; preds = %218, %220, %202
  %222 = add nuw nsw i32 %195, 1
  br label %194, !llvm.loop !33

223:                                              ; preds = %197
  %224 = tail call i32 @rng_below(i32 noundef 90) #6
  %225 = add i32 %224, 90
  %226 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %227 = sdiv i32 %226, 20
  %228 = tail call i32 @llvm.smin.i32(i32 %227, i32 50)
  %229 = sub i32 %225, %228
  store i32 %229, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 464), align 4, !tbaa !22
  br label %230

230:                                              ; preds = %251, %223
  %231 = phi i32 [ 0, %223 ], [ %252, %251 ]
  %232 = icmp eq i32 %231, 2
  br i1 %232, label %201, label %233

233:                                              ; preds = %230
  %234 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %231
  %235 = load i32, ptr %234, align 4, !tbaa !6
  %236 = icmp eq i32 %235, -999
  br i1 %236, label %237, label %251

237:                                              ; preds = %233
  %238 = tail call i32 @rng() #6
  %239 = and i32 %238, 1
  %240 = icmp eq i32 %239, 0
  %241 = select i1 %240, i32 254, i32 -14
  store i32 %241, ptr %234, align 4, !tbaa !6
  %242 = select i1 %240, i32 -2, i32 2
  %243 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %231
  store i32 %242, ptr %243, align 4, !tbaa !6
  %244 = tail call i32 @rng_below(i32 noundef 2) #6
  %245 = shl nsw i32 %244, 4
  %246 = add nsw i32 %245, 18
  %247 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %231
  store i32 %246, ptr %247, align 4, !tbaa !6
  %248 = tail call i32 @rng_below(i32 noundef 60) #6
  %249 = add nsw i32 %248, 20
  %250 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %231
  store i32 %249, ptr %250, align 4, !tbaa !6
  br label %201

251:                                              ; preds = %233
  %252 = add nuw nsw i32 %231, 1
  br label %230, !llvm.loop !34

253:                                              ; preds = %201, %294
  %254 = phi i32 [ %295, %294 ], [ 0, %201 ]
  %255 = icmp eq i32 %254, 2
  br i1 %255, label %296, label %256

256:                                              ; preds = %253
  %257 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %254
  %258 = load i32, ptr %257, align 4, !tbaa !6
  %259 = icmp eq i32 %258, -999
  br i1 %259, label %294, label %260

260:                                              ; preds = %256
  %261 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %254
  %262 = load i32, ptr %261, align 4, !tbaa !6
  %263 = add nsw i32 %262, %258
  store i32 %263, ptr %257, align 4, !tbaa !6
  %264 = icmp slt i32 %263, -15
  br i1 %264, label %267, label %265

265:                                              ; preds = %260
  %266 = icmp sgt i32 %263, 255
  br i1 %266, label %267, label %268

267:                                              ; preds = %265, %260
  store i32 -999, ptr %257, align 4, !tbaa !6
  br label %294

268:                                              ; preds = %265
  %269 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %254
  %270 = load i32, ptr %269, align 4, !tbaa !6
  %271 = add nsw i32 %270, -1
  store i32 %271, ptr %269, align 4, !tbaa !6
  %272 = icmp eq i32 %271, 0
  %273 = add nsw i32 %263, -31
  %274 = icmp ult i32 %273, 179
  %275 = and i1 %274, %272
  br i1 %275, label %276, label %294

276:                                              ; preds = %268, %283
  %277 = phi i32 [ %284, %283 ], [ 0, %268 ]
  %278 = icmp eq i32 %277, 6
  br i1 %278, label %294, label %279

279:                                              ; preds = %276
  %280 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %277
  %281 = load i32, ptr %280, align 4, !tbaa !6
  %282 = icmp eq i32 %281, 0
  br i1 %282, label %285, label %283

283:                                              ; preds = %279
  %284 = add nuw nsw i32 %277, 1
  br label %276, !llvm.loop !35

285:                                              ; preds = %279
  store i32 1, ptr %280, align 4, !tbaa !6
  %286 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %277
  store i32 15, ptr %286, align 4, !tbaa !6
  %287 = load i32, ptr %257, align 4, !tbaa !6
  %288 = and i32 %287, -2
  %289 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %277
  store i32 %288, ptr %289, align 4, !tbaa !6
  %290 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %254
  %291 = load i32, ptr %290, align 4, !tbaa !6
  %292 = add nsw i32 %291, 12
  %293 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %277
  store i32 %292, ptr %293, align 4, !tbaa !6
  br label %294

294:                                              ; preds = %276, %285, %268, %256, %267
  %295 = add nuw nsw i32 %254, 1
  br label %253, !llvm.loop !36

296:                                              ; preds = %253, %394
  %297 = phi i32 [ %395, %394 ], [ 0, %253 ]
  %298 = icmp eq i32 %297, 6
  br i1 %298, label %396, label %299

299:                                              ; preds = %296
  %300 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %297
  %301 = load i32, ptr %300, align 4, !tbaa !6
  switch i32 %301, label %364 [
    i32 0, label %394
    i32 4, label %302
    i32 1, label %341
    i32 2, label %350
  ]

302:                                              ; preds = %299
  %303 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %304 = icmp sgt i32 %303, 3
  %305 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4
  %306 = icmp ne i32 %305, 0
  %307 = select i1 %304, i1 %306, i1 false
  br i1 %307, label %308, label %394

308:                                              ; preds = %302
  %309 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %297
  %310 = load i32, ptr %309, align 4, !tbaa !6
  %311 = add nsw i32 %310, -1
  store i32 %311, ptr %309, align 4, !tbaa !6
  %312 = icmp slt i32 %310, 2
  br i1 %312, label %313, label %394

313:                                              ; preds = %308
  %314 = tail call i32 @rng_below(i32 noundef 50) #6
  %315 = add nsw i32 %314, 70
  store i32 %315, ptr %309, align 4, !tbaa !6
  br label %316

316:                                              ; preds = %339, %313
  %317 = phi i32 [ 0, %313 ], [ %340, %339 ]
  %318 = icmp eq i32 %317, 4
  br i1 %318, label %394, label %319

319:                                              ; preds = %316
  %320 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %317
  %321 = load i32, ptr %320, align 4, !tbaa !6
  %322 = icmp eq i32 %321, -999
  br i1 %322, label %323, label %339

323:                                              ; preds = %319
  %324 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %297
  %325 = load i32, ptr %324, align 4, !tbaa !6
  store i32 %325, ptr %320, align 4, !tbaa !6
  %326 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 224), i32 0, i32 %317
  store i32 212, ptr %326, align 4, !tbaa !6
  %327 = load i32, ptr %324, align 4, !tbaa !6
  %328 = sub nsw i32 120, %327
  %329 = sdiv i32 %328, 22
  %330 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 240), i32 0, i32 %317
  store i32 %329, ptr %330, align 4, !tbaa !6
  %331 = add i32 %327, -99
  %332 = icmp ult i32 %331, 43
  br i1 %332, label %333, label %337

333:                                              ; preds = %323
  %334 = load i32, ptr %324, align 4, !tbaa !6
  %335 = icmp slt i32 %334, 120
  %336 = select i1 %335, i32 1, i32 -1
  store i32 %336, ptr %330, align 4, !tbaa !6
  br label %337

337:                                              ; preds = %333, %323
  %338 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 256), i32 0, i32 %317
  store i32 -6, ptr %338, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 400, i32 noundef 35, i32 noundef 2) #6
  br label %394

339:                                              ; preds = %319
  %340 = add nuw nsw i32 %317, 1
  br label %316, !llvm.loop !37

341:                                              ; preds = %299
  %342 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %297
  %343 = load i32, ptr %342, align 4, !tbaa !6
  %344 = add nsw i32 %343, 4
  store i32 %344, ptr %342, align 4, !tbaa !6
  %345 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %297
  %346 = load i32, ptr %345, align 4, !tbaa !6
  %347 = add nsw i32 %346, -1
  store i32 %347, ptr %345, align 4, !tbaa !6
  %348 = icmp slt i32 %346, 2
  br i1 %348, label %349, label %368

349:                                              ; preds = %341
  store i32 2, ptr %300, align 4, !tbaa !6
  br label %368

350:                                              ; preds = %299
  %351 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %297
  %352 = load i32, ptr %351, align 4, !tbaa !6
  %353 = add nsw i32 %352, 1
  store i32 %353, ptr %351, align 4, !tbaa !6
  %354 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  %355 = and i32 %354, 7
  %356 = icmp eq i32 %355, 0
  br i1 %356, label %357, label %368

357:                                              ; preds = %350
  %358 = and i32 %354, 8
  %359 = icmp eq i32 %358, 0
  %360 = select i1 %359, i32 -2, i32 2
  %361 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %297
  %362 = load i32, ptr %361, align 4, !tbaa !6
  %363 = add nsw i32 %362, %360
  store i32 %363, ptr %361, align 4, !tbaa !6
  br label %368

364:                                              ; preds = %299
  %365 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %297
  %366 = load i32, ptr %365, align 4, !tbaa !6
  %367 = add nsw i32 %366, 5
  store i32 %367, ptr %365, align 4, !tbaa !6
  br label %368

368:                                              ; preds = %364, %357, %350, %341, %349
  %369 = phi i32 [ %367, %364 ], [ %353, %357 ], [ %353, %350 ], [ %344, %341 ], [ %344, %349 ]
  %370 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %371 = icmp eq i32 %370, 0
  br i1 %371, label %380, label %372

372:                                              ; preds = %368
  %373 = icmp sgt i32 %369, 207
  br i1 %373, label %374, label %394

374:                                              ; preds = %372
  %375 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %297
  %376 = load i32, ptr %375, align 4, !tbaa !6
  %377 = add i32 %376, -105
  %378 = icmp ult i32 %377, 31
  br i1 %378, label %379, label %380

379:                                              ; preds = %374
  tail call fastcc void @troop_erase(i32 noundef %297) #7
  store i32 0, ptr %300, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %394

380:                                              ; preds = %374, %368
  %381 = icmp sgt i32 %369, 215
  br i1 %381, label %382, label %394

382:                                              ; preds = %380
  %383 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %297
  store i32 216, ptr %383, align 4, !tbaa !6
  %384 = icmp eq i32 %301, 3
  br i1 %384, label %385, label %388

385:                                              ; preds = %382
  store i32 0, ptr %300, align 4, !tbaa !6
  %386 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %387 = add nsw i32 %386, 2
  store i32 %387, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #6
  br label %394

388:                                              ; preds = %382
  store i32 4, ptr %300, align 4, !tbaa !6
  %389 = tail call i32 @rng_below(i32 noundef 40) #6
  %390 = add nsw i32 %389, 40
  %391 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %297
  store i32 %390, ptr %391, align 4, !tbaa !6
  %392 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %393 = add nsw i32 %392, 1
  store i32 %393, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #6
  tail call fastcc void @draw_score() #7
  br label %394

394:                                              ; preds = %316, %372, %380, %299, %302, %308, %337, %388, %385, %379
  %395 = add nuw nsw i32 %297, 1
  br label %296, !llvm.loop !38

396:                                              ; preds = %296, %433
  %397 = phi i32 [ %434, %433 ], [ 0, %296 ]
  %398 = icmp eq i32 %397, 4
  br i1 %398, label %435, label %399

399:                                              ; preds = %396
  %400 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %397
  %401 = load i32, ptr %400, align 4, !tbaa !6
  %402 = icmp eq i32 %401, -999
  br i1 %402, label %433, label %403

403:                                              ; preds = %399
  %404 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 240), i32 0, i32 %397
  %405 = load i32, ptr %404, align 4, !tbaa !6
  %406 = add nsw i32 %405, %401
  store i32 %406, ptr %400, align 4, !tbaa !6
  %407 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 256), i32 0, i32 %397
  %408 = load i32, ptr %407, align 4, !tbaa !6
  %409 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 224), i32 0, i32 %397
  %410 = load i32, ptr %409, align 4, !tbaa !6
  %411 = add nsw i32 %410, %408
  store i32 %411, ptr %409, align 4, !tbaa !6
  %412 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  %413 = and i32 %412, 1
  %414 = icmp eq i32 %413, 0
  br i1 %414, label %417, label %415

415:                                              ; preds = %403
  %416 = add nsw i32 %408, 1
  store i32 %416, ptr %407, align 4, !tbaa !6
  br label %417

417:                                              ; preds = %415, %403
  %418 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %419 = icmp eq i32 %418, 0
  br i1 %419, label %426, label %420

420:                                              ; preds = %417
  %421 = icmp sgt i32 %411, 211
  br i1 %421, label %422, label %428

422:                                              ; preds = %420
  %423 = add i32 %406, -106
  %424 = icmp ult i32 %423, 29
  br i1 %424, label %425, label %426

425:                                              ; preds = %422
  store i32 -999, ptr %400, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %433

426:                                              ; preds = %422, %417
  %427 = icmp sgt i32 %411, 223
  br i1 %427, label %432, label %428

428:                                              ; preds = %420, %426
  %429 = icmp slt i32 %406, 3
  br i1 %429, label %432, label %430

430:                                              ; preds = %428
  %431 = icmp samesign ugt i32 %406, 236
  br i1 %431, label %432, label %433

432:                                              ; preds = %430, %428, %426
  store i32 -999, ptr %400, align 4, !tbaa !6
  br label %433

433:                                              ; preds = %430, %432, %399, %425
  %434 = add nuw nsw i32 %397, 1
  br label %396, !llvm.loop !39

435:                                              ; preds = %396, %520
  %436 = phi i32 [ %521, %520 ], [ 0, %396 ]
  %437 = icmp eq i32 %436, 12
  br i1 %437, label %522, label %438

438:                                              ; preds = %435
  %439 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 272), i32 0, i32 %436
  %440 = load i32, ptr %439, align 4, !tbaa !6
  %441 = icmp eq i32 %440, -999
  br i1 %441, label %520, label %442

442:                                              ; preds = %438
  %443 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 368), i32 0, i32 %436
  %444 = load i32, ptr %443, align 4, !tbaa !6
  %445 = add nsw i32 %444, %440
  store i32 %445, ptr %439, align 4, !tbaa !6
  %446 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 416), i32 0, i32 %436
  %447 = load i32, ptr %446, align 4, !tbaa !6
  %448 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), i32 0, i32 %436
  %449 = load i32, ptr %448, align 4, !tbaa !6
  %450 = add nsw i32 %449, %447
  store i32 %450, ptr %448, align 4, !tbaa !6
  %451 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  %452 = and i32 %451, 1
  %453 = icmp eq i32 %452, 0
  br i1 %453, label %456, label %454

454:                                              ; preds = %442
  %455 = add nsw i32 %447, 1
  store i32 %455, ptr %446, align 4, !tbaa !6
  br label %456

456:                                              ; preds = %454, %442
  %457 = icmp sgt i32 %450, 223
  br i1 %457, label %462, label %458

458:                                              ; preds = %456
  %459 = icmp slt i32 %445, 2
  br i1 %459, label %462, label %460

460:                                              ; preds = %458
  %461 = icmp samesign ugt i32 %445, 236
  br i1 %461, label %462, label %463

462:                                              ; preds = %460, %458, %456
  store i32 -999, ptr %439, align 4, !tbaa !6
  br label %520

463:                                              ; preds = %460, %485
  %464 = phi i32 [ %486, %485 ], [ 0, %460 ]
  %465 = icmp eq i32 %464, 2
  br i1 %465, label %487, label %466

466:                                              ; preds = %463
  %467 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %464
  %468 = load i32, ptr %467, align 4, !tbaa !6
  %469 = icmp eq i32 %468, -999
  br i1 %469, label %485, label %470

470:                                              ; preds = %466
  %471 = add nsw i32 %468, -14
  %472 = icmp sgt i32 %445, %471
  %473 = add nsw i32 %468, 14
  %474 = icmp slt i32 %445, %473
  %475 = select i1 %472, i1 %474, i1 false
  br i1 %475, label %476, label %485

476:                                              ; preds = %470
  %477 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %464
  %478 = load i32, ptr %477, align 4, !tbaa !6
  %479 = add nsw i32 %478, -2
  %480 = icmp sgt i32 %450, %479
  %481 = add nsw i32 %478, 12
  %482 = icmp slt i32 %450, %481
  %483 = select i1 %480, i1 %482, i1 false
  br i1 %483, label %484, label %485

484:                                              ; preds = %476
  tail call fastcc void @heli_kill(i32 noundef %464) #7
  store i32 -999, ptr %439, align 4, !tbaa !6
  br label %520

485:                                              ; preds = %466, %470, %476
  %486 = add nuw nsw i32 %464, 1
  br label %463, !llvm.loop !40

487:                                              ; preds = %463, %518
  %488 = phi i32 [ %519, %518 ], [ 0, %463 ]
  %489 = icmp eq i32 %488, 6
  br i1 %489, label %520, label %490

490:                                              ; preds = %487
  %491 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %488
  %492 = load i32, ptr %491, align 4, !tbaa !6
  switch i32 %492, label %493 [
    i32 0, label %518
    i32 4, label %496
  ]

493:                                              ; preds = %490
  %494 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %488
  %495 = load i32, ptr %494, align 4, !tbaa !6
  br label %496

496:                                              ; preds = %490, %493
  %497 = phi i32 [ %495, %493 ], [ 218, %490 ]
  %498 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %488
  %499 = load i32, ptr %498, align 4, !tbaa !6
  %500 = add nsw i32 %499, -10
  %501 = icmp sgt i32 %445, %500
  %502 = add nsw i32 %499, 10
  %503 = icmp slt i32 %445, %502
  %504 = select i1 %501, i1 %503, i1 false
  br i1 %504, label %505, label %518

505:                                              ; preds = %496
  %506 = add nsw i32 %497, -12
  %507 = icmp sgt i32 %450, %506
  %508 = add nsw i32 %497, 10
  %509 = icmp slt i32 %450, %508
  %510 = select i1 %507, i1 %509, i1 false
  br i1 %510, label %511, label %518

511:                                              ; preds = %505
  %512 = icmp eq i32 %492, 4
  br i1 %512, label %513, label %516

513:                                              ; preds = %511
  tail call fastcc void @sky(i32 noundef %500, i32 noundef 214, i32 noundef 20, i32 noundef 12) #7
  %514 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %515 = add nsw i32 %514, -1
  store i32 %515, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call fastcc void @draw_score() #7
  br label %517

516:                                              ; preds = %511
  tail call fastcc void @troop_erase(i32 noundef range(i32 -2147483648, 6) %488) #7
  br label %517

517:                                              ; preds = %516, %513
  store i32 0, ptr %491, align 4, !tbaa !6
  store i32 -999, ptr %439, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 300, i32 noundef 40, i32 noundef 2) #6
  br label %520

518:                                              ; preds = %490, %505, %496
  %519 = add nuw nsw i32 %488, 1
  br label %487, !llvm.loop !41

520:                                              ; preds = %487, %517, %484, %438, %462
  %521 = add nuw nsw i32 %436, 1
  br label %435, !llvm.loop !42

522:                                              ; preds = %435, %591
  %523 = phi i32 [ %592, %591 ], [ 0, %435 ]
  %524 = icmp eq i32 %523, 3
  br i1 %524, label %525, label %531

525:                                              ; preds = %522
  %526 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %527 = icmp eq i32 %526, 0
  %528 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4
  %529 = icmp sgt i32 %528, 0
  %530 = select i1 %527, i1 %529, i1 false
  br i1 %530, label %593, label %597

531:                                              ; preds = %522
  %532 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %523
  %533 = load i32, ptr %532, align 4, !tbaa !6
  %534 = icmp eq i32 %533, -999
  br i1 %534, label %591, label %535

535:                                              ; preds = %531
  %536 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %523
  %537 = load i32, ptr %536, align 4, !tbaa !6
  %538 = add i32 %533, 10
  br label %539

539:                                              ; preds = %568, %535
  %540 = phi i32 [ 0, %535 ], [ %569, %568 ]
  %541 = icmp eq i32 %540, 6
  br i1 %541, label %570, label %542

542:                                              ; preds = %539
  %543 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %540
  %544 = load i32, ptr %543, align 4, !tbaa !6
  %545 = add i32 %544, -3
  %546 = icmp ult i32 %545, -2
  br i1 %546, label %568, label %547

547:                                              ; preds = %542
  %548 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %540
  %549 = load i32, ptr %548, align 4, !tbaa !6
  %550 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %540
  %551 = load i32, ptr %550, align 4, !tbaa !6
  %552 = sub nsw i32 %537, %551
  %553 = sub i32 %538, %549
  %554 = icmp ult i32 %553, 21
  %555 = add i32 %552, 11
  %556 = icmp ult i32 %555, 23
  %557 = select i1 %554, i1 %556, i1 false
  br i1 %557, label %558, label %568

558:                                              ; preds = %547
  %559 = icmp eq i32 %544, 2
  %560 = icmp slt i32 %552, 0
  %561 = select i1 %559, i1 %560, i1 false
  tail call fastcc void @troop_erase(i32 noundef %540) #7
  %562 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %563 = select i1 %561, i32 5, i32 10
  %564 = select i1 %561, i32 3, i32 0
  %565 = add nsw i32 %562, %563
  store i32 %564, ptr %543, align 4, !tbaa !6
  store i32 %565, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  store i32 -999, ptr %532, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #6
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #6
  %566 = load i32, ptr %532, align 4, !tbaa !6
  %567 = icmp eq i32 %566, -999
  br i1 %567, label %591, label %570

568:                                              ; preds = %542, %547
  %569 = add nuw nsw i32 %540, 1
  br label %539, !llvm.loop !43

570:                                              ; preds = %539, %558
  %571 = add i32 %533, -14
  %572 = add i32 %537, -12
  br label %573

573:                                              ; preds = %570, %589
  %574 = phi i32 [ %590, %589 ], [ 0, %570 ]
  %575 = icmp eq i32 %574, 2
  br i1 %575, label %591, label %576

576:                                              ; preds = %573
  %577 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %574
  %578 = load i32, ptr %577, align 4, !tbaa !6
  %579 = icmp eq i32 %578, -999
  br i1 %579, label %589, label %580

580:                                              ; preds = %576
  %581 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %574
  %582 = load i32, ptr %581, align 4, !tbaa !6
  %583 = sub i32 %571, %578
  %584 = icmp ult i32 %583, -27
  %585 = sub i32 %572, %582
  %586 = icmp ult i32 %585, -13
  %587 = select i1 %584, i1 true, i1 %586
  br i1 %587, label %589, label %588

588:                                              ; preds = %580
  tail call fastcc void @heli_kill(i32 noundef %574) #7
  store i32 -999, ptr %532, align 4, !tbaa !6
  br label %591

589:                                              ; preds = %580, %576
  %590 = add nuw nsw i32 %574, 1
  br label %573, !llvm.loop !44

591:                                              ; preds = %573, %588, %558, %531
  %592 = add nuw nsw i32 %523, 1
  br label %522, !llvm.loop !45

593:                                              ; preds = %525
  %594 = add nsw i32 %528, -1
  store i32 %594, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4, !tbaa !21
  %595 = icmp eq i32 %594, 0
  br i1 %595, label %596, label %597

596:                                              ; preds = %593
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  tail call void @gfx_text2(i32 noundef 40, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -20286, i16 noundef zeroext -23083) #6
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  tail call void @uputs(ptr noundef nonnull @.str.7) #6
  br label %597

597:                                              ; preds = %596, %593, %525
  br label %598

598:                                              ; preds = %597, %619
  %599 = phi i32 [ %620, %619 ], [ 0, %597 ]
  %600 = icmp eq i32 %599, 6
  br i1 %600, label %621, label %601

601:                                              ; preds = %598
  %602 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %599
  %603 = load i32, ptr %602, align 4, !tbaa !6
  %604 = icmp eq i32 %603, 0
  br i1 %604, label %619, label %605

605:                                              ; preds = %601
  %606 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %599
  %607 = load i32, ptr %606, align 4, !tbaa !6
  %608 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %599
  %609 = load i32, ptr %608, align 4, !tbaa !6
  switch i32 %603, label %617 [
    i32 2, label %610
    i32 1, label %613
    i32 3, label %615
  ]

610:                                              ; preds = %605
  %611 = add nsw i32 %607, -10
  %612 = add nsw i32 %609, -10
  tail call void @gfx_blit_runs(i32 noundef %611, i32 noundef %612, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3456), i32 noundef 20, i32 noundef 20, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6160)) #6
  br label %619

613:                                              ; preds = %605
  %614 = add nsw i32 %607, -4
  tail call void @gfx_blit_runs(i32 noundef %614, i32 noundef %609, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4256), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6384)) #6
  br label %619

615:                                              ; preds = %605
  %616 = add nsw i32 %607, -4
  tail call void @gfx_blit_runs(i32 noundef %616, i32 noundef %609, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4456), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6448)) #6
  br label %619

617:                                              ; preds = %605
  %618 = add nsw i32 %607, -4
  tail call void @gfx_blit_runs(i32 noundef %618, i32 noundef 214, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4656), i32 noundef 10, i32 noundef 12, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6512)) #6
  br label %619

619:                                              ; preds = %617, %615, %613, %610, %601
  %620 = add nuw nsw i32 %599, 1
  br label %598, !llvm.loop !46

621:                                              ; preds = %598, %629
  %622 = phi i32 [ %630, %629 ], [ 0, %598 ]
  %623 = icmp eq i32 %622, 2
  br i1 %623, label %631, label %624

624:                                              ; preds = %621
  %625 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %622
  %626 = load i32, ptr %625, align 4, !tbaa !6
  %627 = icmp eq i32 %626, -999
  br i1 %627, label %629, label %628

628:                                              ; preds = %624
  tail call fastcc void @heli_draw(i32 noundef %622, i32 noundef 0) #7
  br label %629

629:                                              ; preds = %624, %628
  %630 = add nuw nsw i32 %622, 1
  br label %621, !llvm.loop !47

631:                                              ; preds = %621, %646
  %632 = phi i32 [ %647, %646 ], [ 0, %621 ]
  %633 = icmp eq i32 %632, 4
  br i1 %633, label %634, label %637

634:                                              ; preds = %631
  %635 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %636 = icmp eq i32 %635, 0
  br i1 %636, label %649, label %648

637:                                              ; preds = %631
  %638 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %632
  %639 = load i32, ptr %638, align 4, !tbaa !6
  %640 = icmp eq i32 %639, -999
  br i1 %640, label %646, label %641

641:                                              ; preds = %637
  %642 = add nsw i32 %639, -1
  %643 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 224), i32 0, i32 %632
  %644 = load i32, ptr %643, align 4, !tbaa !6
  %645 = add nsw i32 %644, -1
  tail call void @gfx_fill(i32 noundef %642, i32 noundef %645, i32 noundef 3, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %646

646:                                              ; preds = %637, %641
  %647 = add nuw nsw i32 %632, 1
  br label %631, !llvm.loop !48

648:                                              ; preds = %634
  tail call fastcc void @draw_gun() #7
  br label %649

649:                                              ; preds = %648, %634
  br label %650

650:                                              ; preds = %649, %660
  %651 = phi i32 [ %661, %660 ], [ 0, %649 ]
  %652 = icmp eq i32 %651, 12
  br i1 %652, label %662, label %653

653:                                              ; preds = %650
  %654 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 272), i32 0, i32 %651
  %655 = load i32, ptr %654, align 4, !tbaa !6
  %656 = icmp eq i32 %655, -999
  br i1 %656, label %660, label %657

657:                                              ; preds = %653
  %658 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), i32 0, i32 %651
  %659 = load i32, ptr %658, align 4, !tbaa !6
  tail call void @gfx_fill(i32 noundef %655, i32 noundef %659, i32 noundef 4, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %660

660:                                              ; preds = %653, %657
  %661 = add nuw nsw i32 %651, 1
  br label %650, !llvm.loop !49

662:                                              ; preds = %650, %678
  %663 = phi i32 [ %679, %678 ], [ 0, %650 ]
  %664 = icmp eq i32 %663, 3
  br i1 %664, label %680, label %665

665:                                              ; preds = %662
  %666 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %663
  %667 = load i32, ptr %666, align 4, !tbaa !6
  %668 = icmp eq i32 %667, -999
  br i1 %668, label %678, label %669

669:                                              ; preds = %665
  %670 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %663
  %671 = load i32, ptr %670, align 4, !tbaa !6
  %672 = add nsw i32 %667, -2
  %673 = add nsw i32 %671, -1
  tail call void @gfx_fill(i32 noundef %672, i32 noundef %673, i32 noundef 4, i32 noundef 2, i16 noundef zeroext 6371) #6
  %674 = add nsw i32 %667, -1
  %675 = add nsw i32 %671, -2
  tail call void @gfx_fill(i32 noundef %674, i32 noundef %675, i32 noundef 2, i32 noundef 4, i16 noundef zeroext 6371) #6
  %676 = add nsw i32 %667, 2
  %677 = add nsw i32 %671, 2
  tail call void @gfx_damage(i32 noundef %672, i32 noundef %675, i32 noundef %676, i32 noundef %677) #6
  br label %678

678:                                              ; preds = %665, %669
  %679 = add nuw nsw i32 %663, 1
  br label %662, !llvm.loop !50

680:                                              ; preds = %662, %694
  %681 = phi i32 [ %695, %694 ], [ 0, %662 ]
  %682 = icmp eq i32 %681, 4
  br i1 %682, label %696, label %683

683:                                              ; preds = %680
  %684 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %681
  %685 = load i32, ptr %684, align 4, !tbaa !6
  %686 = icmp eq i32 %685, -999
  br i1 %686, label %694, label %687

687:                                              ; preds = %683
  %688 = add nsw i32 %685, -2
  %689 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 224), i32 0, i32 %681
  %690 = load i32, ptr %689, align 4, !tbaa !6
  %691 = add nsw i32 %690, -2
  %692 = add nsw i32 %685, 3
  %693 = add nsw i32 %690, 3
  tail call void @gfx_damage(i32 noundef %688, i32 noundef %691, i32 noundef %692, i32 noundef %693) #6
  br label %694

694:                                              ; preds = %683, %687
  %695 = add nuw nsw i32 %681, 1
  br label %680, !llvm.loop !51

696:                                              ; preds = %680, %714
  %697 = phi i32 [ %715, %714 ], [ 0, %680 ]
  %698 = icmp eq i32 %697, 12
  br i1 %698, label %699, label %703

699:                                              ; preds = %696
  %700 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %701 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !52
  %702 = icmp eq i32 %700, %701
  br i1 %702, label %717, label %716

703:                                              ; preds = %696
  %704 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 272), i32 0, i32 %697
  %705 = load i32, ptr %704, align 4, !tbaa !6
  %706 = icmp eq i32 %705, -999
  br i1 %706, label %714, label %707

707:                                              ; preds = %703
  %708 = add nsw i32 %705, -1
  %709 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), i32 0, i32 %697
  %710 = load i32, ptr %709, align 4, !tbaa !6
  %711 = add nsw i32 %710, -1
  %712 = add nsw i32 %705, 5
  %713 = add nsw i32 %710, 4
  tail call void @gfx_damage(i32 noundef %708, i32 noundef %711, i32 noundef %712, i32 noundef %713) #6
  br label %714

714:                                              ; preds = %703, %707
  %715 = add nuw nsw i32 %697, 1
  br label %696, !llvm.loop !53

716:                                              ; preds = %699
  tail call fastcc void @draw_score() #7
  br label %717

717:                                              ; preds = %716, %699
  br label %61, !llvm.loop !25
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @art_cell(ptr noundef readonly captures(none) %0, i32 noundef range(i32 10, 29) %1, i32 noundef range(i32 10, 21) %2, i16 noundef zeroext range(i16 6371, -28380) %3, ptr noundef writeonly captures(none) %4) unnamed_addr #2 {
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
  store i16 -23083, ptr %14, align 2, !tbaa !54
  %15 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !56

16:                                               ; preds = %10, %30
  %17 = phi i32 [ %31, %30 ], [ 0, %10 ]
  %18 = icmp eq i32 %17, %2
  br i1 %18, label %19, label %20

19:                                               ; preds = %16
  ret void

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i32, ptr %0, i32 %17
  %22 = load i32, ptr %21, align 4, !tbaa !6
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
  br label %16, !llvm.loop !57

32:                                               ; preds = %25
  %33 = and i32 %26, %22
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %37, label %35

35:                                               ; preds = %32
  %36 = getelementptr inbounds nuw i16, ptr %24, i32 %28
  store i16 %3, ptr %36, align 2, !tbaa !54
  br label %37

37:                                               ; preds = %32, %35
  %38 = shl i32 %26, 1
  br label %25, !llvm.loop !58
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local i32 @gfx_cell_runs(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, ptr noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #3

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_gun() unnamed_addr #0 {
  tail call void @gfx_blit_runs(i32 noundef 106, i32 noundef 214, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4896), i32 noundef 26, i32 noundef 12, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6576)) #6
  %1 = load i32, ptr @arena_w, align 4, !tbaa !14
  %2 = getelementptr inbounds [9 x i8], ptr @adx, i32 0, i32 %1
  %3 = load i8, ptr %2, align 1, !tbaa !31
  %4 = sext i8 %3 to i32
  br label %5

5:                                                ; preds = %9, %0
  %6 = phi i32 [ 1, %0 ], [ %17, %9 ]
  %7 = icmp eq i32 %6, 4
  br i1 %7, label %8, label %9

8:                                                ; preds = %5
  tail call void @gfx_damage(i32 noundef 106, i32 noundef 200, i32 noundef 133, i32 noundef 225) #6
  ret void

9:                                                ; preds = %5
  %10 = mul nsw i32 %6, %4
  %11 = trunc i32 %10 to i16
  %12 = sdiv i16 %11, 3
  %13 = add nsw i16 %12, 118
  %14 = sext i16 %13 to i32
  %15 = mul nsw i32 %6, -3
  %16 = add nsw i32 %15, 212
  tail call void @gfx_fill(i32 noundef %14, i32 noundef %16, i32 noundef 4, i32 noundef 4, i16 noundef zeroext 6371) #6
  %17 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !59
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_score() unnamed_addr #0 {
  %1 = alloca [6 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %1) #8
  %2 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  call void @numstr(ptr noundef nonnull %1, i32 noundef 5, i32 noundef %2) #6
  call void @gfx_text(i32 noundef 4, i32 noundef 4, ptr noundef nonnull %1, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  br label %3

3:                                                ; preds = %8, %0
  %4 = phi i32 [ 0, %0 ], [ %14, %8 ]
  %5 = icmp eq i32 %4, 4
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  call void @gfx_damage(i32 noundef 180, i32 noundef 4, i32 noundef 233, i32 noundef 13) #6
  %7 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  store i32 %7, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !52
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %1) #8
  ret void

8:                                                ; preds = %3
  %9 = mul nsw i32 %4, -10
  %10 = add nsw i32 %9, 220
  %11 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %12 = icmp slt i32 %4, %11
  %13 = select i1 %12, i16 -20286, i16 31823
  call void @gfx_fill(i32 noundef %10, i32 noundef 6, i32 noundef 6, i32 noundef 6, i16 noundef zeroext %13) #6
  %14 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !60
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @snd_off() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @sky(i32 noundef range(i32 -2147483648, 2147483647) %0, i32 noundef %1, i32 noundef range(i32 6, 29) %2, i32 noundef range(i32 5, 25) %3) unnamed_addr #0 {
  %5 = add nsw i32 %3, %1
  %6 = icmp sgt i32 %5, 226
  %7 = sub nsw i32 226, %1
  %8 = select i1 %6, i32 %7, i32 %3
  %9 = icmp sgt i32 %8, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %4
  tail call void @gfx_fill(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %8, i16 noundef zeroext -23083) #6
  br label %11

11:                                               ; preds = %10, %4
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @heli_draw(i32 noundef range(i32 0, 2) %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %0
  %4 = load i32, ptr %3, align 4, !tbaa !6
  %5 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %0
  %6 = load i32, ptr %5, align 4, !tbaa !6
  %7 = icmp eq i32 %1, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %2
  %9 = add nsw i32 %4, -14
  tail call fastcc void @sky(i32 noundef %9, i32 noundef %6, i32 noundef 28, i32 noundef 12) #7
  br label %24

10:                                               ; preds = %2
  %11 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 96), i32 0, i32 %0
  %12 = load i32, ptr %11, align 4, !tbaa !6
  %13 = icmp sgt i32 %12, 0
  %14 = select i1 %13, i32 2, i32 0
  %15 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 468), align 4, !tbaa !23
  %16 = lshr i32 %15, 2
  %17 = and i32 %16, 1
  %18 = or disjoint i32 %17, %14
  %19 = add nsw i32 %4, -14
  %20 = mul nuw nsw i32 %18, 672
  %21 = getelementptr inbounds nuw i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 768), i32 %20
  %22 = mul nuw nsw i32 %18, 160
  %23 = getelementptr inbounds nuw i8, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 5520), i32 %22
  tail call void @gfx_blit_runs(i32 noundef %19, i32 noundef %6, ptr noundef nonnull %21, i32 noundef 28, i32 noundef 12, ptr noundef nonnull %23) #6
  br label %24

24:                                               ; preds = %10, %8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @troop_erase(i32 noundef range(i32 -2147483648, 6) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %0
  %3 = load i32, ptr %2, align 4, !tbaa !6
  %4 = add nsw i32 %3, -10
  %5 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %0
  %6 = load i32, ptr %5, align 4, !tbaa !6
  %7 = add nsw i32 %6, -12
  tail call fastcc void @sky(i32 noundef %4, i32 noundef %7, i32 noundef 20, i32 noundef 24) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @turret_erase() unnamed_addr #0 {
  tail call void @gfx_fill(i32 noundef 106, i32 noundef 200, i32 noundef 28, i32 noundef 14, i16 noundef zeroext -23083) #6
  tail call void @gfx_damage(i32 noundef 106, i32 noundef 200, i32 noundef 133, i32 noundef 213) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @gun_destroy() unnamed_addr #0 {
  %1 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %4, label %3

3:                                                ; preds = %0
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  store i32 45, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4, !tbaa !21
  tail call fastcc void @turret_erase() #7
  tail call fastcc void @sky(i32 noundef 106, i32 noundef 214, i32 noundef 28, i32 noundef 12) #7
  tail call fastcc void @debris_spawn(i32 noundef 110, i32 noundef 216, i32 noundef -4, i32 noundef -6) #7
  tail call fastcc void @debris_spawn(i32 noundef 116, i32 noundef 214, i32 noundef -2, i32 noundef -8) #7
  tail call fastcc void @debris_spawn(i32 noundef 122, i32 noundef 214, i32 noundef 2, i32 noundef -7) #7
  tail call fastcc void @debris_spawn(i32 noundef 128, i32 noundef 216, i32 noundef 4, i32 noundef -5) #7
  tail call fastcc void @debris_spawn(i32 noundef 120, i32 noundef 218, i32 noundef 6, i32 noundef -4) #7
  tail call void @uputs(ptr noundef nonnull @.str.8) #6
  tail call void @snd_play(i32 noundef 90, i32 noundef 80, i32 noundef 20) #6
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #6
  br label %4

4:                                                ; preds = %0, %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @heli_kill(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %0
  %3 = load i32, ptr %2, align 4, !tbaa !6
  %4 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 88), i32 0, i32 %0
  %5 = load i32, ptr %4, align 4, !tbaa !6
  tail call fastcc void @heli_draw(i32 noundef %0, i32 noundef 1) #7
  store i32 -999, ptr %2, align 4, !tbaa !6
  %6 = add nsw i32 %3, -8
  %7 = add nsw i32 %5, 2
  tail call fastcc void @debris_spawn(i32 noundef %6, i32 noundef %7, i32 noundef -3, i32 noundef -4) #7
  %8 = add nsw i32 %3, -2
  %9 = add nsw i32 %5, 4
  tail call fastcc void @debris_spawn(i32 noundef %8, i32 noundef %9, i32 noundef -1, i32 noundef -6) #7
  %10 = add nsw i32 %3, 2
  tail call fastcc void @debris_spawn(i32 noundef %10, i32 noundef %7, i32 noundef 1, i32 noundef -5) #7
  %11 = add nsw i32 %3, 8
  tail call fastcc void @debris_spawn(i32 noundef %11, i32 noundef %9, i32 noundef 3, i32 noundef -3) #7
  %12 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %13 = add nsw i32 %12, 20
  store i32 %13, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  tail call void @snd_play(i32 noundef 220, i32 noundef 70, i32 noundef 5) #6
  tail call void @led_blink(i32 noundef 4134912, i32 noundef 2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @led_blink(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit_runs(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @debris_spawn(i32 noundef %0, i32 noundef range(i32 -2147483646, -2147483648) %1, i32 noundef range(i32 -4, 7) %2, i32 noundef range(i32 -8, -2) %3) unnamed_addr #4 {
  br label %5

5:                                                ; preds = %16, %4
  %6 = phi i32 [ 0, %4 ], [ %17, %16 ]
  %7 = icmp eq i32 %6, 12
  br i1 %7, label %18, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 272), i32 0, i32 %6
  %10 = load i32, ptr %9, align 4, !tbaa !6
  %11 = icmp eq i32 %10, -999
  br i1 %11, label %12, label %16

12:                                               ; preds = %8
  store i32 %0, ptr %9, align 4, !tbaa !6
  %13 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 320), i32 0, i32 %6
  store i32 %1, ptr %13, align 4, !tbaa !6
  %14 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 368), i32 0, i32 %6
  store i32 %2, ptr %14, align 4, !tbaa !6
  %15 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 416), i32 0, i32 %6
  store i32 %3, ptr %15, align 4, !tbaa !6
  br label %18

16:                                               ; preds = %8
  %17 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !61

18:                                               ; preds = %5, %12
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { minsize nobuiltin optsize "no-builtins" }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !4, !5}
!11 = distinct !{!11, !4, !5}
!12 = distinct !{!12, !4, !5}
!13 = distinct !{!13, !4, !5}
!14 = !{!15, !7, i64 0}
!15 = !{!"cst", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !8, i64 32, !8, i64 44, !8, i64 56, !8, i64 68, !8, i64 80, !8, i64 88, !8, i64 96, !8, i64 104, !8, i64 112, !8, i64 136, !8, i64 160, !8, i64 184, !8, i64 208, !8, i64 224, !8, i64 240, !8, i64 256, !8, i64 272, !8, i64 320, !8, i64 368, !8, i64 416, !7, i64 464, !7, i64 468}
!16 = !{!15, !7, i64 4}
!17 = !{!15, !7, i64 8}
!18 = !{!15, !7, i64 12}
!19 = !{!15, !7, i64 16}
!20 = !{!15, !7, i64 24}
!21 = !{!15, !7, i64 28}
!22 = !{!15, !7, i64 464}
!23 = !{!15, !7, i64 468}
!24 = distinct !{!24, !4, !5}
!25 = distinct !{!25, !5}
!26 = distinct !{!26, !4, !5}
!27 = distinct !{!27, !4, !5}
!28 = distinct !{!28, !4, !5}
!29 = distinct !{!29, !4, !5}
!30 = distinct !{!30, !4, !5}
!31 = !{!8, !8, i64 0}
!32 = distinct !{!32, !4, !5}
!33 = distinct !{!33, !4, !5}
!34 = distinct !{!34, !4, !5}
!35 = distinct !{!35, !4, !5}
!36 = distinct !{!36, !4, !5}
!37 = distinct !{!37, !4, !5}
!38 = distinct !{!38, !4, !5}
!39 = distinct !{!39, !4, !5}
!40 = distinct !{!40, !4, !5}
!41 = distinct !{!41, !4, !5}
!42 = distinct !{!42, !4, !5}
!43 = distinct !{!43, !4, !5}
!44 = distinct !{!44, !4, !5}
!45 = distinct !{!45, !4, !5}
!46 = distinct !{!46, !4, !5}
!47 = distinct !{!47, !4, !5}
!48 = distinct !{!48, !4, !5}
!49 = distinct !{!49, !4, !5}
!50 = distinct !{!50, !4, !5}
!51 = distinct !{!51, !4, !5}
!52 = !{!15, !7, i64 20}
!53 = distinct !{!53, !4, !5}
!54 = !{!55, !55, i64 0}
!55 = !{!"short", !8, i64 0}
!56 = distinct !{!56, !4, !5}
!57 = distinct !{!57, !4, !5}
!58 = distinct !{!58, !4, !5}
!59 = distinct !{!59, !4, !5}
!60 = distinct !{!60, !4, !5}
!61 = distinct !{!61, !4, !5}
