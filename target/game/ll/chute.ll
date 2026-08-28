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
  %40 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %37
  store i32 -999, ptr %40, align 4, !tbaa !6
  %41 = add nuw nsw i32 %37, 1
  br label %36, !llvm.loop !11

42:                                               ; preds = %36, %45
  %43 = phi i32 [ %47, %45 ], [ 0, %36 ]
  %44 = icmp eq i32 %43, 6
  br i1 %44, label %48, label %45

45:                                               ; preds = %42
  %46 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %43
  store i32 0, ptr %46, align 4, !tbaa !6
  %47 = add nuw nsw i32 %43, 1
  br label %42, !llvm.loop !12

48:                                               ; preds = %42, %51
  %49 = phi i32 [ %53, %51 ], [ 0, %42 ]
  %50 = icmp eq i32 %49, 4
  br i1 %50, label %54, label %51

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %49
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
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), align 4, !tbaa !22
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 588), align 4, !tbaa !23
  tail call fastcc void @draw_gun() #7
  tail call fastcc void @draw_score() #7
  tail call void @gfx_text(i32 noundef 60, i32 noundef 110, ptr noundef nonnull @.str.2, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  br label %61

58:                                               ; preds = %54
  %59 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %55
  store i32 -999, ptr %59, align 4, !tbaa !6
  %60 = add nuw nsw i32 %55, 1
  br label %54, !llvm.loop !24

61:                                               ; preds = %728, %57
  tail call void @gfx_present() #6
  br label %62

62:                                               ; preds = %61, %79
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %63 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 588), align 4, !tbaa !23
  %64 = add i32 %63, 1
  store i32 %64, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 588), align 4, !tbaa !23
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

83:                                               ; preds = %76, %98
  %84 = phi i32 [ %100, %98 ], [ 0, %76 ]
  %85 = phi i32 [ %99, %98 ], [ 0, %76 ]
  %86 = icmp eq i32 %84, 3
  br i1 %86, label %101, label %87

87:                                               ; preds = %83
  %88 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %84
  %89 = load i32, ptr %88, align 4, !tbaa !6
  %90 = icmp eq i32 %89, -999
  br i1 %90, label %98, label %91

91:                                               ; preds = %87
  %92 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %84
  %93 = load i32, ptr %92, align 4, !tbaa !6
  %94 = icmp slt i32 %93, 20
  %95 = select i1 %94, i32 1, i32 %85
  %96 = add nsw i32 %89, -3
  %97 = add nsw i32 %93, -3
  tail call fastcc void @sky(i32 noundef %96, i32 noundef %97, i32 noundef 6, i32 noundef 6) #7
  br label %98

98:                                               ; preds = %87, %91
  %99 = phi i32 [ %95, %91 ], [ %85, %87 ]
  %100 = add nuw nsw i32 %84, 1
  br label %83, !llvm.loop !26

101:                                              ; preds = %83, %109
  %102 = phi i32 [ %110, %109 ], [ 0, %83 ]
  %103 = icmp eq i32 %102, 2
  br i1 %103, label %111, label %104

104:                                              ; preds = %101
  %105 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %102
  %106 = load i32, ptr %105, align 4, !tbaa !6
  %107 = icmp eq i32 %106, -999
  br i1 %107, label %109, label %108

108:                                              ; preds = %104
  tail call fastcc void @heli_draw(i32 noundef %102, i32 noundef 1) #7
  br label %109

109:                                              ; preds = %104, %108
  %110 = add nuw nsw i32 %102, 1
  br label %101, !llvm.loop !27

111:                                              ; preds = %101, %118
  %112 = phi i32 [ %119, %118 ], [ 0, %101 ]
  %113 = icmp eq i32 %112, 6
  br i1 %113, label %120, label %114

114:                                              ; preds = %111
  %115 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %112
  %116 = load i32, ptr %115, align 4, !tbaa !6
  switch i32 %116, label %117 [
    i32 0, label %118
    i32 4, label %118
  ]

117:                                              ; preds = %114
  tail call fastcc void @troop_erase(i32 noundef %112) #7
  br label %118

118:                                              ; preds = %114, %114, %117
  %119 = add nuw nsw i32 %112, 1
  br label %111, !llvm.loop !28

120:                                              ; preds = %111, %132
  %121 = phi i32 [ %133, %132 ], [ 0, %111 ]
  %122 = icmp eq i32 %121, 4
  br i1 %122, label %134, label %123

123:                                              ; preds = %120
  %124 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %121
  %125 = load i32, ptr %124, align 4, !tbaa !6
  %126 = icmp eq i32 %125, -999
  br i1 %126, label %132, label %127

127:                                              ; preds = %123
  %128 = add nsw i32 %125, -2
  %129 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %121
  %130 = load i32, ptr %129, align 4, !tbaa !6
  %131 = add nsw i32 %130, -2
  tail call fastcc void @sky(i32 noundef %128, i32 noundef %131, i32 noundef 6, i32 noundef 6) #7
  br label %132

132:                                              ; preds = %123, %127
  %133 = add nuw nsw i32 %121, 1
  br label %120, !llvm.loop !29

134:                                              ; preds = %120, %150
  %135 = phi i32 [ %151, %150 ], [ 0, %120 ]
  %136 = icmp eq i32 %135, 12
  br i1 %136, label %137, label %141

137:                                              ; preds = %134
  %138 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %139 = icmp eq i32 %138, 0
  br i1 %139, label %140, label %152

140:                                              ; preds = %177, %184, %173, %137
  br label %202

141:                                              ; preds = %134
  %142 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %135
  %143 = load i32, ptr %142, align 4, !tbaa !6
  %144 = icmp eq i32 %143, -999
  br i1 %144, label %150, label %145

145:                                              ; preds = %141
  %146 = add nsw i32 %143, -1
  %147 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %135
  %148 = load i32, ptr %147, align 4, !tbaa !6
  %149 = add nsw i32 %148, -1
  tail call fastcc void @sky(i32 noundef %146, i32 noundef %149, i32 noundef 6, i32 noundef 5) #7
  br label %150

150:                                              ; preds = %141, %145
  %151 = add nuw nsw i32 %135, 1
  br label %134, !llvm.loop !30

152:                                              ; preds = %137
  %153 = load i32, ptr @in_edge, align 4, !tbaa !6
  %154 = and i32 %153, 4
  %155 = icmp ne i32 %154, 0
  %156 = load i32, ptr @arena_w, align 4
  %157 = icmp sgt i32 %156, 0
  %158 = select i1 %155, i1 %157, i1 false
  br i1 %158, label %159, label %163

159:                                              ; preds = %152
  %160 = add nsw i32 %156, -1
  store i32 %160, ptr @arena_w, align 4, !tbaa !14
  tail call fastcc void @turret_erase() #7
  %161 = load i32, ptr @in_edge, align 4, !tbaa !6
  %162 = load i32, ptr @arena_w, align 4
  br label %163

163:                                              ; preds = %159, %152
  %164 = phi i32 [ %162, %159 ], [ %156, %152 ]
  %165 = phi i32 [ %161, %159 ], [ %153, %152 ]
  %166 = and i32 %165, 8
  %167 = icmp ne i32 %166, 0
  %168 = icmp slt i32 %164, 8
  %169 = select i1 %167, i1 %168, i1 false
  br i1 %169, label %170, label %173

170:                                              ; preds = %163
  %171 = add nsw i32 %164, 1
  store i32 %171, ptr @arena_w, align 4, !tbaa !14
  tail call fastcc void @turret_erase() #7
  %172 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %173

173:                                              ; preds = %170, %163
  %174 = phi i32 [ %172, %170 ], [ %165, %163 ]
  %175 = and i32 %174, 17
  %176 = icmp eq i32 %175, 0
  br i1 %176, label %140, label %177

177:                                              ; preds = %173, %200
  %178 = phi i32 [ %201, %200 ], [ 0, %173 ]
  %179 = icmp eq i32 %178, 3
  br i1 %179, label %140, label %180

180:                                              ; preds = %177
  %181 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %178
  %182 = load i32, ptr %181, align 4, !tbaa !6
  %183 = icmp eq i32 %182, -999
  br i1 %183, label %184, label %200

184:                                              ; preds = %180
  %185 = load i32, ptr @arena_w, align 4, !tbaa !14
  %186 = getelementptr inbounds [9 x i8], ptr @adx, i32 0, i32 %185
  %187 = load i8, ptr %186, align 1, !tbaa !31
  %188 = sext i8 %187 to i32
  %189 = add nsw i32 %188, 120
  store i32 %189, ptr %181, align 4, !tbaa !6
  %190 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %178
  store i32 200, ptr %190, align 4, !tbaa !6
  %191 = mul nsw i32 %188, 9
  %192 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %178
  store i32 %191, ptr %192, align 4, !tbaa !6
  %193 = getelementptr inbounds [9 x i8], ptr @ady, i32 0, i32 %185
  %194 = load i8, ptr %193, align 1, !tbaa !31
  %195 = sext i8 %194 to i32
  %196 = mul nsw i32 %195, 9
  %197 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %178
  store i32 %196, ptr %197, align 4, !tbaa !6
  %198 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %178
  store i32 0, ptr %198, align 4, !tbaa !6
  %199 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 92), i32 0, i32 %178
  store i32 0, ptr %199, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 900, i32 noundef 40, i32 noundef 2) #6
  br label %140

200:                                              ; preds = %180
  %201 = add nuw nsw i32 %178, 1
  br label %177, !llvm.loop !32

202:                                              ; preds = %140, %230
  %203 = phi i32 [ %231, %230 ], [ 0, %140 ]
  %204 = icmp eq i32 %203, 3
  br i1 %204, label %205, label %210

205:                                              ; preds = %202
  %206 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), align 4, !tbaa !22
  %207 = add i32 %206, -1
  store i32 %207, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), align 4, !tbaa !22
  %208 = icmp eq i32 %207, 0
  br i1 %208, label %232, label %209

209:                                              ; preds = %239, %246, %205
  br label %262

210:                                              ; preds = %202
  %211 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %203
  %212 = load i32, ptr %211, align 4, !tbaa !6
  %213 = icmp eq i32 %212, -999
  br i1 %213, label %230, label %214

214:                                              ; preds = %210
  %215 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %203
  %216 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %203
  %217 = load i32, ptr %216, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %211, ptr noundef nonnull %215, i32 noundef %217) #7
  %218 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %203
  %219 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 92), i32 0, i32 %203
  %220 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %203
  %221 = load i32, ptr %220, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %218, ptr noundef nonnull %219, i32 noundef %221) #7
  %222 = load i32, ptr %218, align 4, !tbaa !6
  %223 = icmp slt i32 %222, 2
  br i1 %223, label %229, label %224

224:                                              ; preds = %214
  %225 = load i32, ptr %211, align 4, !tbaa !6
  %226 = icmp slt i32 %225, 3
  br i1 %226, label %229, label %227

227:                                              ; preds = %224
  %228 = icmp samesign ugt i32 %225, 236
  br i1 %228, label %229, label %230

229:                                              ; preds = %227, %224, %214
  store i32 -999, ptr %211, align 4, !tbaa !6
  br label %230

230:                                              ; preds = %227, %229, %210
  %231 = add nuw nsw i32 %203, 1
  br label %202, !llvm.loop !33

232:                                              ; preds = %205
  %233 = tail call i32 @rng_below(i32 noundef 90) #6
  %234 = add i32 %233, 90
  %235 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %236 = sdiv i32 %235, 20
  %237 = tail call i32 @llvm.smin.i32(i32 %236, i32 50)
  %238 = sub i32 %234, %237
  store i32 %238, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), align 4, !tbaa !22
  br label %239

239:                                              ; preds = %260, %232
  %240 = phi i32 [ 0, %232 ], [ %261, %260 ]
  %241 = icmp eq i32 %240, 2
  br i1 %241, label %209, label %242

242:                                              ; preds = %239
  %243 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %240
  %244 = load i32, ptr %243, align 4, !tbaa !6
  %245 = icmp eq i32 %244, -999
  br i1 %245, label %246, label %260

246:                                              ; preds = %242
  %247 = tail call i32 @rng() #6
  %248 = and i32 %247, 1
  %249 = icmp eq i32 %248, 0
  %250 = select i1 %249, i32 254, i32 -14
  store i32 %250, ptr %243, align 4, !tbaa !6
  %251 = select i1 %249, i32 -2, i32 2
  %252 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %240
  store i32 %251, ptr %252, align 4, !tbaa !6
  %253 = tail call i32 @rng_below(i32 noundef 2) #6
  %254 = shl nsw i32 %253, 4
  %255 = add nsw i32 %254, 18
  %256 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %240
  store i32 %255, ptr %256, align 4, !tbaa !6
  %257 = tail call i32 @rng_below(i32 noundef 60) #6
  %258 = add nsw i32 %257, 20
  %259 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %240
  store i32 %258, ptr %259, align 4, !tbaa !6
  br label %209

260:                                              ; preds = %242
  %261 = add nuw nsw i32 %240, 1
  br label %239, !llvm.loop !34

262:                                              ; preds = %209, %303
  %263 = phi i32 [ %304, %303 ], [ 0, %209 ]
  %264 = icmp eq i32 %263, 2
  br i1 %264, label %305, label %265

265:                                              ; preds = %262
  %266 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %263
  %267 = load i32, ptr %266, align 4, !tbaa !6
  %268 = icmp eq i32 %267, -999
  br i1 %268, label %303, label %269

269:                                              ; preds = %265
  %270 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %263
  %271 = load i32, ptr %270, align 4, !tbaa !6
  %272 = add nsw i32 %271, %267
  store i32 %272, ptr %266, align 4, !tbaa !6
  %273 = icmp slt i32 %272, -15
  br i1 %273, label %276, label %274

274:                                              ; preds = %269
  %275 = icmp sgt i32 %272, 255
  br i1 %275, label %276, label %277

276:                                              ; preds = %274, %269
  store i32 -999, ptr %266, align 4, !tbaa !6
  br label %303

277:                                              ; preds = %274
  %278 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %263
  %279 = load i32, ptr %278, align 4, !tbaa !6
  %280 = add nsw i32 %279, -1
  store i32 %280, ptr %278, align 4, !tbaa !6
  %281 = icmp eq i32 %280, 0
  %282 = add nsw i32 %272, -31
  %283 = icmp ult i32 %282, 179
  %284 = and i1 %283, %281
  br i1 %284, label %285, label %303

285:                                              ; preds = %277, %292
  %286 = phi i32 [ %293, %292 ], [ 0, %277 ]
  %287 = icmp eq i32 %286, 6
  br i1 %287, label %303, label %288

288:                                              ; preds = %285
  %289 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %286
  %290 = load i32, ptr %289, align 4, !tbaa !6
  %291 = icmp eq i32 %290, 0
  br i1 %291, label %294, label %292

292:                                              ; preds = %288
  %293 = add nuw nsw i32 %286, 1
  br label %285, !llvm.loop !35

294:                                              ; preds = %288
  store i32 1, ptr %289, align 4, !tbaa !6
  %295 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %286
  store i32 15, ptr %295, align 4, !tbaa !6
  %296 = load i32, ptr %266, align 4, !tbaa !6
  %297 = and i32 %296, -2
  %298 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %286
  store i32 %297, ptr %298, align 4, !tbaa !6
  %299 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %263
  %300 = load i32, ptr %299, align 4, !tbaa !6
  %301 = add nsw i32 %300, 12
  %302 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %286
  store i32 %301, ptr %302, align 4, !tbaa !6
  br label %303

303:                                              ; preds = %285, %294, %277, %265, %276
  %304 = add nuw nsw i32 %263, 1
  br label %262, !llvm.loop !36

305:                                              ; preds = %262, %403
  %306 = phi i32 [ %404, %403 ], [ 0, %262 ]
  %307 = icmp eq i32 %306, 6
  br i1 %307, label %405, label %308

308:                                              ; preds = %305
  %309 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %306
  %310 = load i32, ptr %309, align 4, !tbaa !6
  switch i32 %310, label %373 [
    i32 0, label %403
    i32 4, label %311
    i32 1, label %350
    i32 2, label %359
  ]

311:                                              ; preds = %308
  %312 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %313 = icmp sgt i32 %312, 3
  %314 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4
  %315 = icmp ne i32 %314, 0
  %316 = select i1 %313, i1 %315, i1 false
  br i1 %316, label %317, label %403

317:                                              ; preds = %311
  %318 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %306
  %319 = load i32, ptr %318, align 4, !tbaa !6
  %320 = add nsw i32 %319, -1
  store i32 %320, ptr %318, align 4, !tbaa !6
  %321 = icmp slt i32 %319, 2
  br i1 %321, label %322, label %403

322:                                              ; preds = %317
  %323 = tail call i32 @rng_below(i32 noundef 50) #6
  %324 = add nsw i32 %323, 70
  store i32 %324, ptr %318, align 4, !tbaa !6
  br label %325

325:                                              ; preds = %348, %322
  %326 = phi i32 [ 0, %322 ], [ %349, %348 ]
  %327 = icmp eq i32 %326, 4
  br i1 %327, label %403, label %328

328:                                              ; preds = %325
  %329 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %326
  %330 = load i32, ptr %329, align 4, !tbaa !6
  %331 = icmp eq i32 %330, -999
  br i1 %331, label %332, label %348

332:                                              ; preds = %328
  %333 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %306
  %334 = load i32, ptr %333, align 4, !tbaa !6
  store i32 %334, ptr %329, align 4, !tbaa !6
  %335 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %326
  store i32 212, ptr %335, align 4, !tbaa !6
  %336 = load i32, ptr %333, align 4, !tbaa !6
  %337 = sub nsw i32 120, %336
  %338 = sdiv i32 %337, 22
  %339 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 264), i32 0, i32 %326
  store i32 %338, ptr %339, align 4, !tbaa !6
  %340 = add i32 %336, -99
  %341 = icmp ult i32 %340, 43
  br i1 %341, label %342, label %346

342:                                              ; preds = %332
  %343 = load i32, ptr %333, align 4, !tbaa !6
  %344 = icmp slt i32 %343, 120
  %345 = select i1 %344, i32 1, i32 -1
  store i32 %345, ptr %339, align 4, !tbaa !6
  br label %346

346:                                              ; preds = %342, %332
  %347 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 280), i32 0, i32 %326
  store i32 -6, ptr %347, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 400, i32 noundef 35, i32 noundef 2) #6
  br label %403

348:                                              ; preds = %328
  %349 = add nuw nsw i32 %326, 1
  br label %325, !llvm.loop !37

350:                                              ; preds = %308
  %351 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %306
  %352 = load i32, ptr %351, align 4, !tbaa !6
  %353 = add nsw i32 %352, 2
  store i32 %353, ptr %351, align 4, !tbaa !6
  %354 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %306
  %355 = load i32, ptr %354, align 4, !tbaa !6
  %356 = add nsw i32 %355, -1
  store i32 %356, ptr %354, align 4, !tbaa !6
  %357 = icmp slt i32 %355, 2
  br i1 %357, label %358, label %377

358:                                              ; preds = %350
  store i32 2, ptr %309, align 4, !tbaa !6
  br label %377

359:                                              ; preds = %308
  %360 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %306
  %361 = load i32, ptr %360, align 4, !tbaa !6
  %362 = add nsw i32 %361, 1
  store i32 %362, ptr %360, align 4, !tbaa !6
  %363 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 588), align 4, !tbaa !23
  %364 = and i32 %363, 7
  %365 = icmp eq i32 %364, 0
  br i1 %365, label %366, label %377

366:                                              ; preds = %359
  %367 = and i32 %363, 8
  %368 = icmp eq i32 %367, 0
  %369 = select i1 %368, i32 -2, i32 2
  %370 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %306
  %371 = load i32, ptr %370, align 4, !tbaa !6
  %372 = add nsw i32 %371, %369
  store i32 %372, ptr %370, align 4, !tbaa !6
  br label %377

373:                                              ; preds = %308
  %374 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %306
  %375 = load i32, ptr %374, align 4, !tbaa !6
  %376 = add nsw i32 %375, 5
  store i32 %376, ptr %374, align 4, !tbaa !6
  br label %377

377:                                              ; preds = %373, %366, %359, %350, %358
  %378 = phi i32 [ %376, %373 ], [ %362, %366 ], [ %362, %359 ], [ %353, %350 ], [ %353, %358 ]
  %379 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %380 = icmp eq i32 %379, 0
  br i1 %380, label %389, label %381

381:                                              ; preds = %377
  %382 = icmp sgt i32 %378, 207
  br i1 %382, label %383, label %403

383:                                              ; preds = %381
  %384 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %306
  %385 = load i32, ptr %384, align 4, !tbaa !6
  %386 = add i32 %385, -105
  %387 = icmp ult i32 %386, 31
  br i1 %387, label %388, label %389

388:                                              ; preds = %383
  tail call fastcc void @troop_erase(i32 noundef %306) #7
  store i32 0, ptr %309, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %403

389:                                              ; preds = %383, %377
  %390 = icmp sgt i32 %378, 215
  br i1 %390, label %391, label %403

391:                                              ; preds = %389
  %392 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %306
  store i32 216, ptr %392, align 4, !tbaa !6
  %393 = icmp eq i32 %310, 3
  br i1 %393, label %394, label %397

394:                                              ; preds = %391
  store i32 0, ptr %309, align 4, !tbaa !6
  %395 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %396 = add nsw i32 %395, 2
  store i32 %396, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #6
  br label %403

397:                                              ; preds = %391
  store i32 4, ptr %309, align 4, !tbaa !6
  %398 = tail call i32 @rng_below(i32 noundef 40) #6
  %399 = add nsw i32 %398, 40
  %400 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %306
  store i32 %399, ptr %400, align 4, !tbaa !6
  %401 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %402 = add nsw i32 %401, 1
  store i32 %402, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #6
  tail call fastcc void @draw_score() #7
  br label %403

403:                                              ; preds = %325, %381, %389, %308, %311, %317, %346, %397, %394, %388
  %404 = add nuw nsw i32 %306, 1
  br label %305, !llvm.loop !38

405:                                              ; preds = %305, %442
  %406 = phi i32 [ %443, %442 ], [ 0, %305 ]
  %407 = icmp eq i32 %406, 4
  br i1 %407, label %444, label %408

408:                                              ; preds = %405
  %409 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %406
  %410 = load i32, ptr %409, align 4, !tbaa !6
  %411 = icmp eq i32 %410, -999
  br i1 %411, label %442, label %412

412:                                              ; preds = %408
  %413 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 264), i32 0, i32 %406
  %414 = load i32, ptr %413, align 4, !tbaa !6
  %415 = add nsw i32 %414, %410
  store i32 %415, ptr %409, align 4, !tbaa !6
  %416 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 280), i32 0, i32 %406
  %417 = load i32, ptr %416, align 4, !tbaa !6
  %418 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %406
  %419 = load i32, ptr %418, align 4, !tbaa !6
  %420 = add nsw i32 %419, %417
  store i32 %420, ptr %418, align 4, !tbaa !6
  %421 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 588), align 4, !tbaa !23
  %422 = and i32 %421, 1
  %423 = icmp eq i32 %422, 0
  br i1 %423, label %426, label %424

424:                                              ; preds = %412
  %425 = add nsw i32 %417, 1
  store i32 %425, ptr %416, align 4, !tbaa !6
  br label %426

426:                                              ; preds = %424, %412
  %427 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %428 = icmp eq i32 %427, 0
  br i1 %428, label %435, label %429

429:                                              ; preds = %426
  %430 = icmp sgt i32 %420, 211
  br i1 %430, label %431, label %437

431:                                              ; preds = %429
  %432 = add i32 %415, -106
  %433 = icmp ult i32 %432, 29
  br i1 %433, label %434, label %435

434:                                              ; preds = %431
  store i32 -999, ptr %409, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %442

435:                                              ; preds = %431, %426
  %436 = icmp sgt i32 %420, 223
  br i1 %436, label %441, label %437

437:                                              ; preds = %429, %435
  %438 = icmp slt i32 %415, 3
  br i1 %438, label %441, label %439

439:                                              ; preds = %437
  %440 = icmp samesign ugt i32 %415, 236
  br i1 %440, label %441, label %442

441:                                              ; preds = %439, %437, %435
  store i32 -999, ptr %409, align 4, !tbaa !6
  br label %442

442:                                              ; preds = %439, %441, %408, %434
  %443 = add nuw nsw i32 %406, 1
  br label %405, !llvm.loop !39

444:                                              ; preds = %405, %529
  %445 = phi i32 [ %530, %529 ], [ 0, %405 ]
  %446 = icmp eq i32 %445, 12
  br i1 %446, label %531, label %447

447:                                              ; preds = %444
  %448 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %445
  %449 = load i32, ptr %448, align 4, !tbaa !6
  %450 = icmp eq i32 %449, -999
  br i1 %450, label %529, label %451

451:                                              ; preds = %447
  %452 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 488), i32 0, i32 %445
  %453 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 392), i32 0, i32 %445
  %454 = load i32, ptr %453, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %448, ptr noundef nonnull %452, i32 noundef %454) #7
  %455 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %445
  %456 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 536), i32 0, i32 %445
  %457 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 440), i32 0, i32 %445
  %458 = load i32, ptr %457, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %455, ptr noundef nonnull %456, i32 noundef %458) #7
  %459 = load i32, ptr %457, align 4, !tbaa !6
  %460 = tail call i32 @llvm.smin.i32(i32 %459, i32 24)
  %461 = add nsw i32 %460, 8
  store i32 %461, ptr %457, align 4, !tbaa !6
  %462 = load i32, ptr %448, align 4, !tbaa !6
  %463 = load i32, ptr %455, align 4, !tbaa !6
  %464 = icmp sgt i32 %463, 223
  br i1 %464, label %471, label %465

465:                                              ; preds = %451
  %466 = icmp slt i32 %463, 4
  br i1 %466, label %471, label %467

467:                                              ; preds = %465
  %468 = icmp slt i32 %462, 2
  br i1 %468, label %471, label %469

469:                                              ; preds = %467
  %470 = icmp samesign ugt i32 %462, 236
  br i1 %470, label %471, label %472

471:                                              ; preds = %469, %467, %465, %451
  store i32 -999, ptr %448, align 4, !tbaa !6
  br label %529

472:                                              ; preds = %469, %494
  %473 = phi i32 [ %495, %494 ], [ 0, %469 ]
  %474 = icmp eq i32 %473, 2
  br i1 %474, label %496, label %475

475:                                              ; preds = %472
  %476 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %473
  %477 = load i32, ptr %476, align 4, !tbaa !6
  %478 = icmp ne i32 %477, -999
  %479 = add nsw i32 %477, -14
  %480 = icmp sgt i32 %462, %479
  %481 = select i1 %478, i1 %480, i1 false
  %482 = add nsw i32 %477, 14
  %483 = icmp slt i32 %462, %482
  %484 = select i1 %481, i1 %483, i1 false
  br i1 %484, label %485, label %494

485:                                              ; preds = %475
  %486 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %473
  %487 = load i32, ptr %486, align 4, !tbaa !6
  %488 = add nsw i32 %487, -2
  %489 = icmp sgt i32 %463, %488
  %490 = add nsw i32 %487, 12
  %491 = icmp slt i32 %463, %490
  %492 = select i1 %489, i1 %491, i1 false
  br i1 %492, label %493, label %494

493:                                              ; preds = %485
  tail call fastcc void @heli_kill(i32 noundef %473) #7
  store i32 -999, ptr %448, align 4, !tbaa !6
  br label %529

494:                                              ; preds = %475, %485
  %495 = add nuw nsw i32 %473, 1
  br label %472, !llvm.loop !40

496:                                              ; preds = %472, %527
  %497 = phi i32 [ %528, %527 ], [ 0, %472 ]
  %498 = icmp eq i32 %497, 6
  br i1 %498, label %529, label %499

499:                                              ; preds = %496
  %500 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %497
  %501 = load i32, ptr %500, align 4, !tbaa !6
  switch i32 %501, label %502 [
    i32 0, label %527
    i32 4, label %505
  ]

502:                                              ; preds = %499
  %503 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %497
  %504 = load i32, ptr %503, align 4, !tbaa !6
  br label %505

505:                                              ; preds = %499, %502
  %506 = phi i32 [ %504, %502 ], [ 218, %499 ]
  %507 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %497
  %508 = load i32, ptr %507, align 4, !tbaa !6
  %509 = add nsw i32 %508, -10
  %510 = icmp sgt i32 %462, %509
  %511 = add nsw i32 %508, 10
  %512 = icmp slt i32 %462, %511
  %513 = select i1 %510, i1 %512, i1 false
  %514 = add nsw i32 %506, -12
  %515 = icmp sgt i32 %463, %514
  %516 = select i1 %513, i1 %515, i1 false
  %517 = add nsw i32 %506, 10
  %518 = icmp slt i32 %463, %517
  %519 = select i1 %516, i1 %518, i1 false
  br i1 %519, label %520, label %527

520:                                              ; preds = %505
  %521 = icmp eq i32 %501, 4
  br i1 %521, label %522, label %525

522:                                              ; preds = %520
  tail call fastcc void @sky(i32 noundef %509, i32 noundef 214, i32 noundef 20, i32 noundef 12) #7
  %523 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %524 = add nsw i32 %523, -1
  store i32 %524, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call fastcc void @draw_score() #7
  br label %526

525:                                              ; preds = %520
  tail call fastcc void @troop_erase(i32 noundef range(i32 -2147483648, 6) %497) #7
  br label %526

526:                                              ; preds = %525, %522
  store i32 0, ptr %500, align 4, !tbaa !6
  store i32 -999, ptr %448, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 300, i32 noundef 40, i32 noundef 2) #6
  br label %529

527:                                              ; preds = %499, %505
  %528 = add nuw nsw i32 %497, 1
  br label %496, !llvm.loop !41

529:                                              ; preds = %496, %526, %493, %471, %447
  %530 = add nuw nsw i32 %445, 1
  br label %444, !llvm.loop !42

531:                                              ; preds = %444, %600
  %532 = phi i32 [ %601, %600 ], [ 0, %444 ]
  %533 = icmp eq i32 %532, 3
  br i1 %533, label %534, label %540

534:                                              ; preds = %531
  %535 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %536 = icmp eq i32 %535, 0
  %537 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4
  %538 = icmp sgt i32 %537, 0
  %539 = select i1 %536, i1 %538, i1 false
  br i1 %539, label %602, label %606

540:                                              ; preds = %531
  %541 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %532
  %542 = load i32, ptr %541, align 4, !tbaa !6
  %543 = icmp eq i32 %542, -999
  br i1 %543, label %600, label %544

544:                                              ; preds = %540
  %545 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %532
  %546 = load i32, ptr %545, align 4, !tbaa !6
  %547 = add i32 %542, 10
  br label %548

548:                                              ; preds = %577, %544
  %549 = phi i32 [ 0, %544 ], [ %578, %577 ]
  %550 = icmp eq i32 %549, 6
  br i1 %550, label %579, label %551

551:                                              ; preds = %548
  %552 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %549
  %553 = load i32, ptr %552, align 4, !tbaa !6
  %554 = add i32 %553, -3
  %555 = icmp ult i32 %554, -2
  br i1 %555, label %577, label %556

556:                                              ; preds = %551
  %557 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %549
  %558 = load i32, ptr %557, align 4, !tbaa !6
  %559 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %549
  %560 = load i32, ptr %559, align 4, !tbaa !6
  %561 = sub nsw i32 %546, %560
  %562 = sub i32 %547, %558
  %563 = icmp ult i32 %562, 21
  %564 = add i32 %561, 11
  %565 = icmp ult i32 %564, 23
  %566 = select i1 %563, i1 %565, i1 false
  br i1 %566, label %567, label %577

567:                                              ; preds = %556
  %568 = icmp eq i32 %553, 2
  %569 = icmp slt i32 %561, 0
  %570 = select i1 %568, i1 %569, i1 false
  tail call fastcc void @troop_erase(i32 noundef %549) #7
  %571 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %572 = select i1 %570, i32 5, i32 10
  %573 = select i1 %570, i32 3, i32 0
  %574 = add nsw i32 %571, %572
  store i32 %573, ptr %552, align 4, !tbaa !6
  store i32 %574, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  store i32 -999, ptr %541, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #6
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #6
  %575 = load i32, ptr %541, align 4, !tbaa !6
  %576 = icmp eq i32 %575, -999
  br i1 %576, label %600, label %579

577:                                              ; preds = %551, %556
  %578 = add nuw nsw i32 %549, 1
  br label %548, !llvm.loop !43

579:                                              ; preds = %548, %567
  %580 = add i32 %542, -14
  %581 = add i32 %546, -12
  br label %582

582:                                              ; preds = %579, %598
  %583 = phi i32 [ %599, %598 ], [ 0, %579 ]
  %584 = icmp eq i32 %583, 2
  br i1 %584, label %600, label %585

585:                                              ; preds = %582
  %586 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %583
  %587 = load i32, ptr %586, align 4, !tbaa !6
  %588 = icmp eq i32 %587, -999
  br i1 %588, label %598, label %589

589:                                              ; preds = %585
  %590 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %583
  %591 = load i32, ptr %590, align 4, !tbaa !6
  %592 = sub i32 %580, %587
  %593 = icmp ult i32 %592, -27
  %594 = sub i32 %581, %591
  %595 = icmp ult i32 %594, -13
  %596 = select i1 %593, i1 true, i1 %595
  br i1 %596, label %598, label %597

597:                                              ; preds = %589
  tail call fastcc void @heli_kill(i32 noundef %583) #7
  store i32 -999, ptr %541, align 4, !tbaa !6
  br label %600

598:                                              ; preds = %589, %585
  %599 = add nuw nsw i32 %583, 1
  br label %582, !llvm.loop !44

600:                                              ; preds = %582, %597, %567, %540
  %601 = add nuw nsw i32 %532, 1
  br label %531, !llvm.loop !45

602:                                              ; preds = %534
  %603 = add nsw i32 %537, -1
  store i32 %603, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4, !tbaa !21
  %604 = icmp eq i32 %603, 0
  br i1 %604, label %605, label %606

605:                                              ; preds = %602
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  tail call void @gfx_text2(i32 noundef 40, i32 noundef 104, ptr noundef nonnull @.str.5, i16 noundef zeroext -20286, i16 noundef zeroext -23083) #6
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.6, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  tail call void @uputs(ptr noundef nonnull @.str.7) #6
  br label %606

606:                                              ; preds = %605, %602, %534
  br label %607

607:                                              ; preds = %606, %628
  %608 = phi i32 [ %629, %628 ], [ 0, %606 ]
  %609 = icmp eq i32 %608, 6
  br i1 %609, label %630, label %610

610:                                              ; preds = %607
  %611 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %608
  %612 = load i32, ptr %611, align 4, !tbaa !6
  %613 = icmp eq i32 %612, 0
  br i1 %613, label %628, label %614

614:                                              ; preds = %610
  %615 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %608
  %616 = load i32, ptr %615, align 4, !tbaa !6
  %617 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %608
  %618 = load i32, ptr %617, align 4, !tbaa !6
  switch i32 %612, label %626 [
    i32 2, label %619
    i32 1, label %622
    i32 3, label %624
  ]

619:                                              ; preds = %614
  %620 = add nsw i32 %616, -10
  %621 = add nsw i32 %618, -10
  tail call void @gfx_blit_runs(i32 noundef %620, i32 noundef %621, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3456), i32 noundef 20, i32 noundef 20, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6160)) #6
  br label %628

622:                                              ; preds = %614
  %623 = add nsw i32 %616, -4
  tail call void @gfx_blit_runs(i32 noundef %623, i32 noundef %618, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4256), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6384)) #6
  br label %628

624:                                              ; preds = %614
  %625 = add nsw i32 %616, -4
  tail call void @gfx_blit_runs(i32 noundef %625, i32 noundef %618, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4456), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6448)) #6
  br label %628

626:                                              ; preds = %614
  %627 = add nsw i32 %616, -4
  tail call void @gfx_blit_runs(i32 noundef %627, i32 noundef 214, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4656), i32 noundef 10, i32 noundef 12, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6512)) #6
  br label %628

628:                                              ; preds = %626, %624, %622, %619, %610
  %629 = add nuw nsw i32 %608, 1
  br label %607, !llvm.loop !46

630:                                              ; preds = %607, %638
  %631 = phi i32 [ %639, %638 ], [ 0, %607 ]
  %632 = icmp eq i32 %631, 2
  br i1 %632, label %640, label %633

633:                                              ; preds = %630
  %634 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %631
  %635 = load i32, ptr %634, align 4, !tbaa !6
  %636 = icmp eq i32 %635, -999
  br i1 %636, label %638, label %637

637:                                              ; preds = %633
  tail call fastcc void @heli_draw(i32 noundef %631, i32 noundef 0) #7
  br label %638

638:                                              ; preds = %633, %637
  %639 = add nuw nsw i32 %631, 1
  br label %630, !llvm.loop !47

640:                                              ; preds = %630, %655
  %641 = phi i32 [ %656, %655 ], [ 0, %630 ]
  %642 = icmp eq i32 %641, 4
  br i1 %642, label %643, label %646

643:                                              ; preds = %640
  %644 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %645 = icmp eq i32 %644, 0
  br i1 %645, label %658, label %657

646:                                              ; preds = %640
  %647 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %641
  %648 = load i32, ptr %647, align 4, !tbaa !6
  %649 = icmp eq i32 %648, -999
  br i1 %649, label %655, label %650

650:                                              ; preds = %646
  %651 = add nsw i32 %648, -1
  %652 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %641
  %653 = load i32, ptr %652, align 4, !tbaa !6
  %654 = add nsw i32 %653, -1
  tail call void @gfx_fill(i32 noundef %651, i32 noundef %654, i32 noundef 3, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %655

655:                                              ; preds = %646, %650
  %656 = add nuw nsw i32 %641, 1
  br label %640, !llvm.loop !48

657:                                              ; preds = %643
  tail call fastcc void @draw_gun() #7
  br label %658

658:                                              ; preds = %657, %643
  br label %659

659:                                              ; preds = %658, %669
  %660 = phi i32 [ %670, %669 ], [ 0, %658 ]
  %661 = icmp eq i32 %660, 12
  br i1 %661, label %671, label %662

662:                                              ; preds = %659
  %663 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %660
  %664 = load i32, ptr %663, align 4, !tbaa !6
  %665 = icmp eq i32 %664, -999
  br i1 %665, label %669, label %666

666:                                              ; preds = %662
  %667 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %660
  %668 = load i32, ptr %667, align 4, !tbaa !6
  tail call void @gfx_fill(i32 noundef %664, i32 noundef %668, i32 noundef 4, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %669

669:                                              ; preds = %662, %666
  %670 = add nuw nsw i32 %660, 1
  br label %659, !llvm.loop !49

671:                                              ; preds = %659, %687
  %672 = phi i32 [ %688, %687 ], [ 0, %659 ]
  %673 = icmp eq i32 %672, 3
  br i1 %673, label %689, label %674

674:                                              ; preds = %671
  %675 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %672
  %676 = load i32, ptr %675, align 4, !tbaa !6
  %677 = icmp eq i32 %676, -999
  br i1 %677, label %687, label %678

678:                                              ; preds = %674
  %679 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %672
  %680 = load i32, ptr %679, align 4, !tbaa !6
  %681 = add nsw i32 %676, -2
  %682 = add nsw i32 %680, -1
  tail call void @gfx_fill(i32 noundef %681, i32 noundef %682, i32 noundef 4, i32 noundef 2, i16 noundef zeroext 6371) #6
  %683 = add nsw i32 %676, -1
  %684 = add nsw i32 %680, -2
  tail call void @gfx_fill(i32 noundef %683, i32 noundef %684, i32 noundef 2, i32 noundef 4, i16 noundef zeroext 6371) #6
  %685 = add nsw i32 %676, 2
  %686 = add nsw i32 %680, 2
  tail call void @gfx_damage(i32 noundef %681, i32 noundef %684, i32 noundef %685, i32 noundef %686) #6
  br label %687

687:                                              ; preds = %674, %678
  %688 = add nuw nsw i32 %672, 1
  br label %671, !llvm.loop !50

689:                                              ; preds = %671, %703
  %690 = phi i32 [ %704, %703 ], [ 0, %671 ]
  %691 = icmp eq i32 %690, 4
  br i1 %691, label %705, label %692

692:                                              ; preds = %689
  %693 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %690
  %694 = load i32, ptr %693, align 4, !tbaa !6
  %695 = icmp eq i32 %694, -999
  br i1 %695, label %703, label %696

696:                                              ; preds = %692
  %697 = add nsw i32 %694, -2
  %698 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %690
  %699 = load i32, ptr %698, align 4, !tbaa !6
  %700 = add nsw i32 %699, -2
  %701 = add nsw i32 %694, 3
  %702 = add nsw i32 %699, 3
  tail call void @gfx_damage(i32 noundef %697, i32 noundef %700, i32 noundef %701, i32 noundef %702) #6
  br label %703

703:                                              ; preds = %692, %696
  %704 = add nuw nsw i32 %690, 1
  br label %689, !llvm.loop !51

705:                                              ; preds = %689, %721
  %706 = phi i32 [ %722, %721 ], [ 0, %689 ]
  %707 = icmp eq i32 %706, 12
  br i1 %707, label %708, label %710

708:                                              ; preds = %705
  %709 = icmp eq i32 %85, 0
  br i1 %709, label %723, label %727

710:                                              ; preds = %705
  %711 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %706
  %712 = load i32, ptr %711, align 4, !tbaa !6
  %713 = icmp eq i32 %712, -999
  br i1 %713, label %721, label %714

714:                                              ; preds = %710
  %715 = add nsw i32 %712, -1
  %716 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %706
  %717 = load i32, ptr %716, align 4, !tbaa !6
  %718 = add nsw i32 %717, -1
  %719 = add nsw i32 %712, 5
  %720 = add nsw i32 %717, 4
  tail call void @gfx_damage(i32 noundef %715, i32 noundef %718, i32 noundef %719, i32 noundef %720) #6
  br label %721

721:                                              ; preds = %710, %714
  %722 = add nuw nsw i32 %706, 1
  br label %705, !llvm.loop !52

723:                                              ; preds = %708
  %724 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %725 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !53
  %726 = icmp eq i32 %724, %725
  br i1 %726, label %728, label %727

727:                                              ; preds = %723, %708
  tail call fastcc void @draw_score() #7
  br label %728

728:                                              ; preds = %727, %723
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
  store i32 %7, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !53
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
  %3 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %0
  %4 = load i32, ptr %3, align 4, !tbaa !6
  %5 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %0
  %6 = load i32, ptr %5, align 4, !tbaa !6
  %7 = icmp eq i32 %1, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %2
  %9 = add nsw i32 %4, -14
  tail call fastcc void @sky(i32 noundef %9, i32 noundef %6, i32 noundef 28, i32 noundef 12) #7
  br label %24

10:                                               ; preds = %2
  %11 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %0
  %12 = load i32, ptr %11, align 4, !tbaa !6
  %13 = icmp sgt i32 %12, 0
  %14 = select i1 %13, i32 2, i32 0
  %15 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 588), align 4, !tbaa !23
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
  %2 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %0
  %3 = load i32, ptr %2, align 4, !tbaa !6
  %4 = add nsw i32 %3, -10
  %5 = getelementptr inbounds [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %0
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

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc void @subpx(ptr noundef captures(none) %0, ptr noundef captures(none) %1, i32 noundef %2) unnamed_addr #2 {
  %4 = load i32, ptr %1, align 4, !tbaa !6
  %5 = add nsw i32 %4, %2
  br label %6

6:                                                ; preds = %9, %3
  %7 = phi i32 [ %5, %3 ], [ %10, %9 ]
  %8 = icmp sgt i32 %7, 15
  br i1 %8, label %9, label %13

9:                                                ; preds = %6
  %10 = add nsw i32 %7, -16
  %11 = load i32, ptr %0, align 4, !tbaa !6
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr %0, align 4, !tbaa !6
  br label %6, !llvm.loop !61

13:                                               ; preds = %6, %16
  %14 = phi i32 [ %17, %16 ], [ %7, %6 ]
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %16, label %20

16:                                               ; preds = %13
  %17 = add nsw i32 %14, 16
  %18 = load i32, ptr %0, align 4, !tbaa !6
  %19 = add nsw i32 %18, -1
  store i32 %19, ptr %0, align 4, !tbaa !6
  br label %13, !llvm.loop !62

20:                                               ; preds = %13
  store i32 %14, ptr %1, align 4, !tbaa !6
  ret void
}

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
  tail call fastcc void @debris_spawn(i32 noundef 110, i32 noundef 216, i32 noundef -64, i32 noundef -96) #7
  tail call fastcc void @debris_spawn(i32 noundef 116, i32 noundef 214, i32 noundef -32, i32 noundef -128) #7
  tail call fastcc void @debris_spawn(i32 noundef 122, i32 noundef 214, i32 noundef 32, i32 noundef -112) #7
  tail call fastcc void @debris_spawn(i32 noundef 128, i32 noundef 216, i32 noundef 64, i32 noundef -80) #7
  tail call fastcc void @debris_spawn(i32 noundef 120, i32 noundef 218, i32 noundef 96, i32 noundef -64) #7
  tail call void @uputs(ptr noundef nonnull @.str.8) #6
  tail call void @snd_play(i32 noundef 90, i32 noundef 80, i32 noundef 20) #6
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #6
  br label %4

4:                                                ; preds = %0, %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @heli_kill(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %0
  %3 = load i32, ptr %2, align 4, !tbaa !6
  %4 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %0
  %5 = load i32, ptr %4, align 4, !tbaa !6
  tail call fastcc void @heli_draw(i32 noundef %0, i32 noundef 1) #7
  store i32 -999, ptr %2, align 4, !tbaa !6
  %6 = add nsw i32 %3, -8
  %7 = add nsw i32 %5, 2
  tail call fastcc void @debris_spawn(i32 noundef %6, i32 noundef %7, i32 noundef -12, i32 noundef 4) #7
  %8 = add nsw i32 %3, -2
  %9 = add nsw i32 %5, 4
  tail call fastcc void @debris_spawn(i32 noundef %8, i32 noundef %9, i32 noundef -5, i32 noundef 9) #7
  %10 = add nsw i32 %3, 2
  tail call fastcc void @debris_spawn(i32 noundef %10, i32 noundef %7, i32 noundef 5, i32 noundef 7) #7
  %11 = add nsw i32 %3, 8
  tail call fastcc void @debris_spawn(i32 noundef %11, i32 noundef %9, i32 noundef 12, i32 noundef 2) #7
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
define internal fastcc void @debris_spawn(i32 noundef %0, i32 noundef range(i32 -2147483646, -2147483648) %1, i32 noundef range(i32 -64, 97) %2, i32 noundef range(i32 -128, 10) %3) unnamed_addr #4 {
  br label %5

5:                                                ; preds = %18, %4
  %6 = phi i32 [ 0, %4 ], [ %19, %18 ]
  %7 = icmp eq i32 %6, 12
  br i1 %7, label %20, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %6
  %10 = load i32, ptr %9, align 4, !tbaa !6
  %11 = icmp eq i32 %10, -999
  br i1 %11, label %12, label %18

12:                                               ; preds = %8
  store i32 %0, ptr %9, align 4, !tbaa !6
  %13 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %6
  store i32 %1, ptr %13, align 4, !tbaa !6
  %14 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 392), i32 0, i32 %6
  store i32 %2, ptr %14, align 4, !tbaa !6
  %15 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 440), i32 0, i32 %6
  store i32 %3, ptr %15, align 4, !tbaa !6
  %16 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 488), i32 0, i32 %6
  store i32 0, ptr %16, align 4, !tbaa !6
  %17 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 536), i32 0, i32 %6
  store i32 0, ptr %17, align 4, !tbaa !6
  br label %20

18:                                               ; preds = %8
  %19 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !63

20:                                               ; preds = %5, %12
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
!15 = !{!"cst", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !8, i64 32, !8, i64 44, !8, i64 56, !8, i64 68, !8, i64 80, !8, i64 92, !8, i64 104, !8, i64 112, !8, i64 120, !8, i64 128, !8, i64 136, !8, i64 160, !8, i64 184, !8, i64 208, !8, i64 232, !8, i64 248, !8, i64 264, !8, i64 280, !8, i64 296, !8, i64 344, !8, i64 392, !8, i64 440, !8, i64 488, !8, i64 536, !7, i64 584, !7, i64 588}
!16 = !{!15, !7, i64 4}
!17 = !{!15, !7, i64 8}
!18 = !{!15, !7, i64 12}
!19 = !{!15, !7, i64 16}
!20 = !{!15, !7, i64 24}
!21 = !{!15, !7, i64 28}
!22 = !{!15, !7, i64 584}
!23 = !{!15, !7, i64 588}
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
!52 = distinct !{!52, !4, !5}
!53 = !{!15, !7, i64 20}
!54 = !{!55, !55, i64 0}
!55 = !{!"short", !8, i64 0}
!56 = distinct !{!56, !4, !5}
!57 = distinct !{!57, !4, !5}
!58 = distinct !{!58, !4, !5}
!59 = distinct !{!59, !4, !5}
!60 = distinct !{!60, !4, !5}
!61 = distinct !{!61, !4, !5}
!62 = distinct !{!62, !4, !5}
!63 = distinct !{!63, !4, !5}
