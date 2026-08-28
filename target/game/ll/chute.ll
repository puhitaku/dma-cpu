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
@.str.5 = private unnamed_addr constant [18 x i8] c"chute: game over\0A\00", align 1
@.str.6 = private unnamed_addr constant [11 x i8] c"Destroyed!\00", align 1
@.str.7 = private unnamed_addr constant [19 x i8] c"Press to try again\00", align 1
@.str.8 = private unnamed_addr constant [19 x i8] c"Down: back to menu\00", align 1
@.str.9 = private unnamed_addr constant [22 x i8] c"chute: gun destroyed\0A\00", align 1

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
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  store i32 0, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
  tail call fastcc void @draw_gun() #7
  tail call fastcc void @draw_score() #7
  tail call void @gfx_text(i32 noundef 60, i32 noundef 110, ptr noundef nonnull @.str.2, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  br label %61

58:                                               ; preds = %54
  %59 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %55
  store i32 -999, ptr %59, align 4, !tbaa !6
  %60 = add nuw nsw i32 %55, 1
  br label %54, !llvm.loop !24

61:                                               ; preds = %753, %57
  tail call void @gfx_present() #6
  br label %62

62:                                               ; preds = %61, %83
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %63 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
  %64 = add i32 %63, 1
  store i32 %64, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
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
  br label %754

76:                                               ; preds = %67
  %77 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  %78 = icmp eq i32 %77, 0
  br i1 %78, label %87, label %79

79:                                               ; preds = %76
  %80 = load i32, ptr @in_edge, align 4, !tbaa !6
  %81 = and i32 %80, 16
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %83, label %27

83:                                               ; preds = %79
  %84 = and i32 %80, 2
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %62, label %86, !llvm.loop !25

86:                                               ; preds = %83
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  tail call void @snd_off() #6
  tail call void @led(i32 noundef 0, i32 noundef 0) #6
  br label %754

87:                                               ; preds = %76, %102
  %88 = phi i32 [ %104, %102 ], [ 0, %76 ]
  %89 = phi i32 [ %103, %102 ], [ 0, %76 ]
  %90 = icmp eq i32 %88, 3
  br i1 %90, label %105, label %91

91:                                               ; preds = %87
  %92 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %88
  %93 = load i32, ptr %92, align 4, !tbaa !6
  %94 = icmp eq i32 %93, -999
  br i1 %94, label %102, label %95

95:                                               ; preds = %91
  %96 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %88
  %97 = load i32, ptr %96, align 4, !tbaa !6
  %98 = icmp slt i32 %97, 20
  %99 = select i1 %98, i32 1, i32 %89
  %100 = add nsw i32 %93, -3
  %101 = add nsw i32 %97, -3
  tail call fastcc void @sky(i32 noundef %100, i32 noundef %101, i32 noundef 6, i32 noundef 6) #7
  br label %102

102:                                              ; preds = %91, %95
  %103 = phi i32 [ %99, %95 ], [ %89, %91 ]
  %104 = add nuw nsw i32 %88, 1
  br label %87, !llvm.loop !26

105:                                              ; preds = %87, %113
  %106 = phi i32 [ %114, %113 ], [ 0, %87 ]
  %107 = icmp eq i32 %106, 2
  br i1 %107, label %115, label %108

108:                                              ; preds = %105
  %109 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %106
  %110 = load i32, ptr %109, align 4, !tbaa !6
  %111 = icmp eq i32 %110, -999
  br i1 %111, label %113, label %112

112:                                              ; preds = %108
  tail call fastcc void @heli_draw(i32 noundef %106, i32 noundef 1) #7
  br label %113

113:                                              ; preds = %108, %112
  %114 = add nuw nsw i32 %106, 1
  br label %105, !llvm.loop !27

115:                                              ; preds = %105, %122
  %116 = phi i32 [ %123, %122 ], [ 0, %105 ]
  %117 = icmp eq i32 %116, 6
  br i1 %117, label %124, label %118

118:                                              ; preds = %115
  %119 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %116
  %120 = load i32, ptr %119, align 4, !tbaa !6
  switch i32 %120, label %121 [
    i32 0, label %122
    i32 4, label %122
  ]

121:                                              ; preds = %118
  tail call fastcc void @troop_erase(i32 noundef %116) #7
  br label %122

122:                                              ; preds = %118, %118, %121
  %123 = add nuw nsw i32 %116, 1
  br label %115, !llvm.loop !28

124:                                              ; preds = %115, %136
  %125 = phi i32 [ %137, %136 ], [ 0, %115 ]
  %126 = icmp eq i32 %125, 4
  br i1 %126, label %138, label %127

127:                                              ; preds = %124
  %128 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %125
  %129 = load i32, ptr %128, align 4, !tbaa !6
  %130 = icmp eq i32 %129, -999
  br i1 %130, label %136, label %131

131:                                              ; preds = %127
  %132 = add nsw i32 %129, -2
  %133 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %125
  %134 = load i32, ptr %133, align 4, !tbaa !6
  %135 = add nsw i32 %134, -2
  tail call fastcc void @sky(i32 noundef %132, i32 noundef %135, i32 noundef 6, i32 noundef 6) #7
  br label %136

136:                                              ; preds = %127, %131
  %137 = add nuw nsw i32 %125, 1
  br label %124, !llvm.loop !29

138:                                              ; preds = %124, %154
  %139 = phi i32 [ %155, %154 ], [ 0, %124 ]
  %140 = icmp eq i32 %139, 12
  br i1 %140, label %141, label %145

141:                                              ; preds = %138
  %142 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %144, label %156

144:                                              ; preds = %181, %188, %177, %141
  br label %206

145:                                              ; preds = %138
  %146 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %139
  %147 = load i32, ptr %146, align 4, !tbaa !6
  %148 = icmp eq i32 %147, -999
  br i1 %148, label %154, label %149

149:                                              ; preds = %145
  %150 = add nsw i32 %147, -1
  %151 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %139
  %152 = load i32, ptr %151, align 4, !tbaa !6
  %153 = add nsw i32 %152, -1
  tail call fastcc void @sky(i32 noundef %150, i32 noundef %153, i32 noundef 6, i32 noundef 5) #7
  br label %154

154:                                              ; preds = %145, %149
  %155 = add nuw nsw i32 %139, 1
  br label %138, !llvm.loop !30

156:                                              ; preds = %141
  %157 = load i32, ptr @in_edge, align 4, !tbaa !6
  %158 = and i32 %157, 4
  %159 = icmp ne i32 %158, 0
  %160 = load i32, ptr @arena_w, align 4
  %161 = icmp sgt i32 %160, 0
  %162 = select i1 %159, i1 %161, i1 false
  br i1 %162, label %163, label %167

163:                                              ; preds = %156
  %164 = add nsw i32 %160, -1
  store i32 %164, ptr @arena_w, align 4, !tbaa !14
  tail call fastcc void @turret_erase() #7
  %165 = load i32, ptr @in_edge, align 4, !tbaa !6
  %166 = load i32, ptr @arena_w, align 4
  br label %167

167:                                              ; preds = %163, %156
  %168 = phi i32 [ %166, %163 ], [ %160, %156 ]
  %169 = phi i32 [ %165, %163 ], [ %157, %156 ]
  %170 = and i32 %169, 8
  %171 = icmp ne i32 %170, 0
  %172 = icmp slt i32 %168, 8
  %173 = select i1 %171, i1 %172, i1 false
  br i1 %173, label %174, label %177

174:                                              ; preds = %167
  %175 = add nsw i32 %168, 1
  store i32 %175, ptr @arena_w, align 4, !tbaa !14
  tail call fastcc void @turret_erase() #7
  %176 = load i32, ptr @in_edge, align 4, !tbaa !6
  br label %177

177:                                              ; preds = %174, %167
  %178 = phi i32 [ %176, %174 ], [ %169, %167 ]
  %179 = and i32 %178, 17
  %180 = icmp eq i32 %179, 0
  br i1 %180, label %144, label %181

181:                                              ; preds = %177, %204
  %182 = phi i32 [ %205, %204 ], [ 0, %177 ]
  %183 = icmp eq i32 %182, 3
  br i1 %183, label %144, label %184

184:                                              ; preds = %181
  %185 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %182
  %186 = load i32, ptr %185, align 4, !tbaa !6
  %187 = icmp eq i32 %186, -999
  br i1 %187, label %188, label %204

188:                                              ; preds = %184
  %189 = load i32, ptr @arena_w, align 4, !tbaa !14
  %190 = getelementptr inbounds [9 x i8], ptr @adx, i32 0, i32 %189
  %191 = load i8, ptr %190, align 1, !tbaa !31
  %192 = sext i8 %191 to i32
  %193 = add nsw i32 %192, 120
  store i32 %193, ptr %185, align 4, !tbaa !6
  %194 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %182
  store i32 200, ptr %194, align 4, !tbaa !6
  %195 = mul nsw i32 %192, 9
  %196 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %182
  store i32 %195, ptr %196, align 4, !tbaa !6
  %197 = getelementptr inbounds [9 x i8], ptr @ady, i32 0, i32 %189
  %198 = load i8, ptr %197, align 1, !tbaa !31
  %199 = sext i8 %198 to i32
  %200 = mul nsw i32 %199, 9
  %201 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %182
  store i32 %200, ptr %201, align 4, !tbaa !6
  %202 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %182
  store i32 0, ptr %202, align 4, !tbaa !6
  %203 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 92), i32 0, i32 %182
  store i32 0, ptr %203, align 4, !tbaa !6
  tail call void @snd_sweep(i32 noundef 260, i32 noundef 45, i32 noundef 5, i32 noundef 25) #6
  br label %144

204:                                              ; preds = %184
  %205 = add nuw nsw i32 %182, 1
  br label %181, !llvm.loop !32

206:                                              ; preds = %144, %234
  %207 = phi i32 [ %235, %234 ], [ 0, %144 ]
  %208 = icmp eq i32 %207, 3
  br i1 %208, label %209, label %214

209:                                              ; preds = %206
  %210 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  %211 = add i32 %210, -1
  store i32 %211, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  %212 = icmp eq i32 %211, 0
  br i1 %212, label %236, label %213

213:                                              ; preds = %243, %250, %209
  br label %266

214:                                              ; preds = %206
  %215 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %207
  %216 = load i32, ptr %215, align 4, !tbaa !6
  %217 = icmp eq i32 %216, -999
  br i1 %217, label %234, label %218

218:                                              ; preds = %214
  %219 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %207
  %220 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %207
  %221 = load i32, ptr %220, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %215, ptr noundef nonnull %219, i32 noundef %221) #7
  %222 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %207
  %223 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 92), i32 0, i32 %207
  %224 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %207
  %225 = load i32, ptr %224, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %222, ptr noundef nonnull %223, i32 noundef %225) #7
  %226 = load i32, ptr %222, align 4, !tbaa !6
  %227 = icmp slt i32 %226, 2
  br i1 %227, label %233, label %228

228:                                              ; preds = %218
  %229 = load i32, ptr %215, align 4, !tbaa !6
  %230 = icmp slt i32 %229, 3
  br i1 %230, label %233, label %231

231:                                              ; preds = %228
  %232 = icmp samesign ugt i32 %229, 236
  br i1 %232, label %233, label %234

233:                                              ; preds = %231, %228, %218
  store i32 -999, ptr %215, align 4, !tbaa !6
  br label %234

234:                                              ; preds = %231, %233, %214
  %235 = add nuw nsw i32 %207, 1
  br label %206, !llvm.loop !33

236:                                              ; preds = %209
  %237 = tail call i32 @rng_below(i32 noundef 90) #6
  %238 = add i32 %237, 90
  %239 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %240 = sdiv i32 %239, 20
  %241 = tail call i32 @llvm.smin.i32(i32 %240, i32 50)
  %242 = sub i32 %238, %241
  store i32 %242, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  br label %243

243:                                              ; preds = %264, %236
  %244 = phi i32 [ 0, %236 ], [ %265, %264 ]
  %245 = icmp eq i32 %244, 2
  br i1 %245, label %213, label %246

246:                                              ; preds = %243
  %247 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %244
  %248 = load i32, ptr %247, align 4, !tbaa !6
  %249 = icmp eq i32 %248, -999
  br i1 %249, label %250, label %264

250:                                              ; preds = %246
  %251 = tail call i32 @rng() #6
  %252 = and i32 %251, 1
  %253 = icmp eq i32 %252, 0
  %254 = select i1 %253, i32 254, i32 -14
  store i32 %254, ptr %247, align 4, !tbaa !6
  %255 = select i1 %253, i32 -2, i32 2
  %256 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %244
  store i32 %255, ptr %256, align 4, !tbaa !6
  %257 = tail call i32 @rng_below(i32 noundef 2) #6
  %258 = shl nsw i32 %257, 4
  %259 = add nsw i32 %258, 18
  %260 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %244
  store i32 %259, ptr %260, align 4, !tbaa !6
  %261 = tail call i32 @rng_below(i32 noundef 172) #6
  %262 = add nsw i32 %261, 34
  %263 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %244
  store i32 %262, ptr %263, align 4, !tbaa !6
  br label %213

264:                                              ; preds = %246
  %265 = add nuw nsw i32 %244, 1
  br label %243, !llvm.loop !34

266:                                              ; preds = %213, %312
  %267 = phi i32 [ %313, %312 ], [ 0, %213 ]
  %268 = icmp eq i32 %267, 2
  br i1 %268, label %314, label %269

269:                                              ; preds = %266
  %270 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %267
  %271 = load i32, ptr %270, align 4, !tbaa !6
  %272 = icmp eq i32 %271, -999
  br i1 %272, label %312, label %273

273:                                              ; preds = %269
  %274 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %267
  %275 = load i32, ptr %274, align 4, !tbaa !6
  %276 = add nsw i32 %275, %271
  store i32 %276, ptr %270, align 4, !tbaa !6
  %277 = icmp slt i32 %276, -15
  br i1 %277, label %280, label %278

278:                                              ; preds = %273
  %279 = icmp sgt i32 %276, 255
  br i1 %279, label %280, label %281

280:                                              ; preds = %278, %273
  store i32 -999, ptr %270, align 4, !tbaa !6
  br label %312

281:                                              ; preds = %278
  %282 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %267
  %283 = load i32, ptr %282, align 4, !tbaa !6
  %284 = icmp sgt i32 %283, -1
  br i1 %284, label %285, label %312

285:                                              ; preds = %281
  %286 = icmp sgt i32 %275, 0
  br i1 %286, label %287, label %289

287:                                              ; preds = %285
  %288 = icmp slt i32 %276, %283
  br i1 %288, label %312, label %293

289:                                              ; preds = %285
  %290 = icmp slt i32 %275, 0
  br i1 %290, label %291, label %312

291:                                              ; preds = %289
  %292 = icmp sgt i32 %276, %283
  br i1 %292, label %312, label %293

293:                                              ; preds = %291, %287
  store i32 -1, ptr %282, align 4, !tbaa !6
  br label %294

294:                                              ; preds = %301, %293
  %295 = phi i32 [ 0, %293 ], [ %302, %301 ]
  %296 = icmp eq i32 %295, 6
  br i1 %296, label %312, label %297

297:                                              ; preds = %294
  %298 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %295
  %299 = load i32, ptr %298, align 4, !tbaa !6
  %300 = icmp eq i32 %299, 0
  br i1 %300, label %303, label %301

301:                                              ; preds = %297
  %302 = add nuw nsw i32 %295, 1
  br label %294, !llvm.loop !35

303:                                              ; preds = %297
  store i32 1, ptr %298, align 4, !tbaa !6
  %304 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %295
  store i32 15, ptr %304, align 4, !tbaa !6
  %305 = load i32, ptr %270, align 4, !tbaa !6
  %306 = and i32 %305, -2
  %307 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %295
  store i32 %306, ptr %307, align 4, !tbaa !6
  %308 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %267
  %309 = load i32, ptr %308, align 4, !tbaa !6
  %310 = add nsw i32 %309, 12
  %311 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %295
  store i32 %310, ptr %311, align 4, !tbaa !6
  br label %312

312:                                              ; preds = %294, %287, %303, %281, %289, %291, %269, %280
  %313 = add nuw nsw i32 %267, 1
  br label %266, !llvm.loop !36

314:                                              ; preds = %266, %412
  %315 = phi i32 [ %413, %412 ], [ 0, %266 ]
  %316 = icmp eq i32 %315, 6
  br i1 %316, label %414, label %317

317:                                              ; preds = %314
  %318 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %315
  %319 = load i32, ptr %318, align 4, !tbaa !6
  switch i32 %319, label %382 [
    i32 0, label %412
    i32 4, label %320
    i32 1, label %359
    i32 2, label %368
  ]

320:                                              ; preds = %317
  %321 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %322 = icmp sgt i32 %321, 3
  %323 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4
  %324 = icmp ne i32 %323, 0
  %325 = select i1 %322, i1 %324, i1 false
  br i1 %325, label %326, label %412

326:                                              ; preds = %320
  %327 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %315
  %328 = load i32, ptr %327, align 4, !tbaa !6
  %329 = add nsw i32 %328, -1
  store i32 %329, ptr %327, align 4, !tbaa !6
  %330 = icmp slt i32 %328, 2
  br i1 %330, label %331, label %412

331:                                              ; preds = %326
  %332 = tail call i32 @rng_below(i32 noundef 50) #6
  %333 = add nsw i32 %332, 70
  store i32 %333, ptr %327, align 4, !tbaa !6
  br label %334

334:                                              ; preds = %357, %331
  %335 = phi i32 [ 0, %331 ], [ %358, %357 ]
  %336 = icmp eq i32 %335, 4
  br i1 %336, label %412, label %337

337:                                              ; preds = %334
  %338 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %335
  %339 = load i32, ptr %338, align 4, !tbaa !6
  %340 = icmp eq i32 %339, -999
  br i1 %340, label %341, label %357

341:                                              ; preds = %337
  %342 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %315
  %343 = load i32, ptr %342, align 4, !tbaa !6
  store i32 %343, ptr %338, align 4, !tbaa !6
  %344 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %335
  store i32 212, ptr %344, align 4, !tbaa !6
  %345 = load i32, ptr %342, align 4, !tbaa !6
  %346 = sub nsw i32 120, %345
  %347 = sdiv i32 %346, 22
  %348 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 264), i32 0, i32 %335
  store i32 %347, ptr %348, align 4, !tbaa !6
  %349 = add i32 %345, -99
  %350 = icmp ult i32 %349, 43
  br i1 %350, label %351, label %355

351:                                              ; preds = %341
  %352 = load i32, ptr %342, align 4, !tbaa !6
  %353 = icmp slt i32 %352, 120
  %354 = select i1 %353, i32 1, i32 -1
  store i32 %354, ptr %348, align 4, !tbaa !6
  br label %355

355:                                              ; preds = %351, %341
  %356 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 280), i32 0, i32 %335
  store i32 -6, ptr %356, align 4, !tbaa !6
  tail call void @snd_sweep(i32 noundef 700, i32 noundef 35, i32 noundef 5, i32 noundef 60) #6
  br label %412

357:                                              ; preds = %337
  %358 = add nuw nsw i32 %335, 1
  br label %334, !llvm.loop !37

359:                                              ; preds = %317
  %360 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %315
  %361 = load i32, ptr %360, align 4, !tbaa !6
  %362 = add nsw i32 %361, 2
  store i32 %362, ptr %360, align 4, !tbaa !6
  %363 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %315
  %364 = load i32, ptr %363, align 4, !tbaa !6
  %365 = add nsw i32 %364, -1
  store i32 %365, ptr %363, align 4, !tbaa !6
  %366 = icmp slt i32 %364, 2
  br i1 %366, label %367, label %386

367:                                              ; preds = %359
  store i32 2, ptr %318, align 4, !tbaa !6
  br label %386

368:                                              ; preds = %317
  %369 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %315
  %370 = load i32, ptr %369, align 4, !tbaa !6
  %371 = add nsw i32 %370, 1
  store i32 %371, ptr %369, align 4, !tbaa !6
  %372 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
  %373 = and i32 %372, 7
  %374 = icmp eq i32 %373, 0
  br i1 %374, label %375, label %386

375:                                              ; preds = %368
  %376 = and i32 %372, 8
  %377 = icmp eq i32 %376, 0
  %378 = select i1 %377, i32 -2, i32 2
  %379 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %315
  %380 = load i32, ptr %379, align 4, !tbaa !6
  %381 = add nsw i32 %380, %378
  store i32 %381, ptr %379, align 4, !tbaa !6
  br label %386

382:                                              ; preds = %317
  %383 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %315
  %384 = load i32, ptr %383, align 4, !tbaa !6
  %385 = add nsw i32 %384, 5
  store i32 %385, ptr %383, align 4, !tbaa !6
  br label %386

386:                                              ; preds = %382, %375, %368, %359, %367
  %387 = phi i32 [ %385, %382 ], [ %371, %375 ], [ %371, %368 ], [ %362, %359 ], [ %362, %367 ]
  %388 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %389 = icmp eq i32 %388, 0
  br i1 %389, label %398, label %390

390:                                              ; preds = %386
  %391 = icmp sgt i32 %387, 207
  br i1 %391, label %392, label %412

392:                                              ; preds = %390
  %393 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %315
  %394 = load i32, ptr %393, align 4, !tbaa !6
  %395 = add i32 %394, -105
  %396 = icmp ult i32 %395, 31
  br i1 %396, label %397, label %398

397:                                              ; preds = %392
  tail call fastcc void @troop_erase(i32 noundef %315) #7
  store i32 0, ptr %318, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %412

398:                                              ; preds = %392, %386
  %399 = icmp sgt i32 %387, 215
  br i1 %399, label %400, label %412

400:                                              ; preds = %398
  %401 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %315
  store i32 216, ptr %401, align 4, !tbaa !6
  %402 = icmp eq i32 %319, 3
  br i1 %402, label %403, label %406

403:                                              ; preds = %400
  store i32 0, ptr %318, align 4, !tbaa !6
  %404 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %405 = add nsw i32 %404, 2
  store i32 %405, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #6
  br label %412

406:                                              ; preds = %400
  store i32 4, ptr %318, align 4, !tbaa !6
  %407 = tail call i32 @rng_below(i32 noundef 40) #6
  %408 = add nsw i32 %407, 40
  %409 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %315
  store i32 %408, ptr %409, align 4, !tbaa !6
  %410 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %411 = add nsw i32 %410, 1
  store i32 %411, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #6
  tail call fastcc void @draw_score() #7
  br label %412

412:                                              ; preds = %334, %390, %398, %317, %320, %326, %355, %406, %403, %397
  %413 = add nuw nsw i32 %315, 1
  br label %314, !llvm.loop !38

414:                                              ; preds = %314, %451
  %415 = phi i32 [ %452, %451 ], [ 0, %314 ]
  %416 = icmp eq i32 %415, 4
  br i1 %416, label %453, label %417

417:                                              ; preds = %414
  %418 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %415
  %419 = load i32, ptr %418, align 4, !tbaa !6
  %420 = icmp eq i32 %419, -999
  br i1 %420, label %451, label %421

421:                                              ; preds = %417
  %422 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 264), i32 0, i32 %415
  %423 = load i32, ptr %422, align 4, !tbaa !6
  %424 = add nsw i32 %423, %419
  store i32 %424, ptr %418, align 4, !tbaa !6
  %425 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 280), i32 0, i32 %415
  %426 = load i32, ptr %425, align 4, !tbaa !6
  %427 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %415
  %428 = load i32, ptr %427, align 4, !tbaa !6
  %429 = add nsw i32 %428, %426
  store i32 %429, ptr %427, align 4, !tbaa !6
  %430 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
  %431 = and i32 %430, 1
  %432 = icmp eq i32 %431, 0
  br i1 %432, label %435, label %433

433:                                              ; preds = %421
  %434 = add nsw i32 %426, 1
  store i32 %434, ptr %425, align 4, !tbaa !6
  br label %435

435:                                              ; preds = %433, %421
  %436 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %437 = icmp eq i32 %436, 0
  br i1 %437, label %444, label %438

438:                                              ; preds = %435
  %439 = icmp sgt i32 %429, 211
  br i1 %439, label %440, label %446

440:                                              ; preds = %438
  %441 = add i32 %424, -106
  %442 = icmp ult i32 %441, 29
  br i1 %442, label %443, label %444

443:                                              ; preds = %440
  store i32 -999, ptr %418, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %451

444:                                              ; preds = %440, %435
  %445 = icmp sgt i32 %429, 223
  br i1 %445, label %450, label %446

446:                                              ; preds = %438, %444
  %447 = icmp slt i32 %424, 3
  br i1 %447, label %450, label %448

448:                                              ; preds = %446
  %449 = icmp samesign ugt i32 %424, 236
  br i1 %449, label %450, label %451

450:                                              ; preds = %448, %446, %444
  store i32 -999, ptr %418, align 4, !tbaa !6
  br label %451

451:                                              ; preds = %448, %450, %417, %443
  %452 = add nuw nsw i32 %415, 1
  br label %414, !llvm.loop !39

453:                                              ; preds = %414, %550
  %454 = phi i32 [ %551, %550 ], [ 0, %414 ]
  %455 = icmp eq i32 %454, 12
  br i1 %455, label %552, label %456

456:                                              ; preds = %453
  %457 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %454
  %458 = load i32, ptr %457, align 4, !tbaa !6
  %459 = icmp eq i32 %458, -999
  br i1 %459, label %550, label %460

460:                                              ; preds = %456
  %461 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 488), i32 0, i32 %454
  %462 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 392), i32 0, i32 %454
  %463 = load i32, ptr %462, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %457, ptr noundef nonnull %461, i32 noundef %463) #7
  %464 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %454
  %465 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 536), i32 0, i32 %454
  %466 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 440), i32 0, i32 %454
  %467 = load i32, ptr %466, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %464, ptr noundef nonnull %465, i32 noundef %467) #7
  %468 = load i32, ptr %466, align 4, !tbaa !6
  %469 = tail call i32 @llvm.smin.i32(i32 %468, i32 24)
  %470 = add nsw i32 %469, 8
  store i32 %470, ptr %466, align 4, !tbaa !6
  %471 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), i32 0, i32 %454
  %472 = load i32, ptr %471, align 4, !tbaa !6
  %473 = icmp eq i32 %472, 0
  br i1 %473, label %478, label %474

474:                                              ; preds = %460
  %475 = add nsw i32 %472, -1
  store i32 %475, ptr %471, align 4, !tbaa !6
  %476 = icmp eq i32 %475, 0
  br i1 %476, label %477, label %478

477:                                              ; preds = %474
  store i32 -999, ptr %457, align 4, !tbaa !6
  br label %550

478:                                              ; preds = %474, %460
  %479 = load i32, ptr %457, align 4, !tbaa !6
  %480 = load i32, ptr %464, align 4, !tbaa !6
  %481 = icmp sgt i32 %480, 223
  br i1 %481, label %488, label %482

482:                                              ; preds = %478
  %483 = icmp slt i32 %480, 4
  br i1 %483, label %488, label %484

484:                                              ; preds = %482
  %485 = icmp slt i32 %479, 2
  br i1 %485, label %488, label %486

486:                                              ; preds = %484
  %487 = icmp samesign ugt i32 %479, 236
  br i1 %487, label %488, label %489

488:                                              ; preds = %486, %484, %482, %478
  store i32 -999, ptr %457, align 4, !tbaa !6
  br label %550

489:                                              ; preds = %486, %511
  %490 = phi i32 [ %512, %511 ], [ 0, %486 ]
  %491 = icmp eq i32 %490, 2
  br i1 %491, label %513, label %492

492:                                              ; preds = %489
  %493 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %490
  %494 = load i32, ptr %493, align 4, !tbaa !6
  %495 = icmp ne i32 %494, -999
  %496 = add nsw i32 %494, -14
  %497 = icmp sgt i32 %479, %496
  %498 = select i1 %495, i1 %497, i1 false
  %499 = add nsw i32 %494, 14
  %500 = icmp slt i32 %479, %499
  %501 = select i1 %498, i1 %500, i1 false
  br i1 %501, label %502, label %511

502:                                              ; preds = %492
  %503 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %490
  %504 = load i32, ptr %503, align 4, !tbaa !6
  %505 = add nsw i32 %504, -2
  %506 = icmp sgt i32 %480, %505
  %507 = add nsw i32 %504, 12
  %508 = icmp slt i32 %480, %507
  %509 = select i1 %506, i1 %508, i1 false
  br i1 %509, label %510, label %511

510:                                              ; preds = %502
  tail call fastcc void @heli_kill(i32 noundef %490) #7
  store i32 -999, ptr %457, align 4, !tbaa !6
  br label %550

511:                                              ; preds = %492, %502
  %512 = add nuw nsw i32 %490, 1
  br label %489, !llvm.loop !40

513:                                              ; preds = %489
  %514 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 632), i32 0, i32 %454
  %515 = load i32, ptr %514, align 4, !tbaa !6
  %516 = icmp eq i32 %515, 0
  br i1 %516, label %550, label %517

517:                                              ; preds = %513, %548
  %518 = phi i32 [ %549, %548 ], [ 0, %513 ]
  %519 = icmp eq i32 %518, 6
  br i1 %519, label %550, label %520

520:                                              ; preds = %517
  %521 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %518
  %522 = load i32, ptr %521, align 4, !tbaa !6
  switch i32 %522, label %523 [
    i32 0, label %548
    i32 4, label %526
  ]

523:                                              ; preds = %520
  %524 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %518
  %525 = load i32, ptr %524, align 4, !tbaa !6
  br label %526

526:                                              ; preds = %520, %523
  %527 = phi i32 [ %525, %523 ], [ 218, %520 ]
  %528 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %518
  %529 = load i32, ptr %528, align 4, !tbaa !6
  %530 = add nsw i32 %529, -10
  %531 = icmp sgt i32 %479, %530
  %532 = add nsw i32 %529, 10
  %533 = icmp slt i32 %479, %532
  %534 = select i1 %531, i1 %533, i1 false
  %535 = add nsw i32 %527, -12
  %536 = icmp sgt i32 %480, %535
  %537 = select i1 %534, i1 %536, i1 false
  %538 = add nsw i32 %527, 10
  %539 = icmp slt i32 %480, %538
  %540 = select i1 %537, i1 %539, i1 false
  br i1 %540, label %541, label %548

541:                                              ; preds = %526
  %542 = icmp eq i32 %522, 4
  br i1 %542, label %543, label %546

543:                                              ; preds = %541
  tail call fastcc void @sky(i32 noundef %530, i32 noundef 214, i32 noundef 20, i32 noundef 12) #7
  %544 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %545 = add nsw i32 %544, -1
  store i32 %545, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call fastcc void @draw_score() #7
  br label %547

546:                                              ; preds = %541
  tail call fastcc void @troop_erase(i32 noundef range(i32 -2147483648, 6) %518) #7
  br label %547

547:                                              ; preds = %546, %543
  store i32 0, ptr %521, align 4, !tbaa !6
  store i32 -999, ptr %457, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 300, i32 noundef 40, i32 noundef 2) #6
  br label %550

548:                                              ; preds = %520, %526
  %549 = add nuw nsw i32 %518, 1
  br label %517, !llvm.loop !41

550:                                              ; preds = %517, %547, %510, %488, %513, %456, %477
  %551 = add nuw nsw i32 %454, 1
  br label %453, !llvm.loop !42

552:                                              ; preds = %453, %621
  %553 = phi i32 [ %622, %621 ], [ 0, %453 ]
  %554 = icmp eq i32 %553, 3
  br i1 %554, label %555, label %561

555:                                              ; preds = %552
  %556 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %557 = icmp eq i32 %556, 0
  %558 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4
  %559 = icmp sgt i32 %558, 0
  %560 = select i1 %557, i1 %559, i1 false
  br i1 %560, label %623, label %627

561:                                              ; preds = %552
  %562 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %553
  %563 = load i32, ptr %562, align 4, !tbaa !6
  %564 = icmp eq i32 %563, -999
  br i1 %564, label %621, label %565

565:                                              ; preds = %561
  %566 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %553
  %567 = load i32, ptr %566, align 4, !tbaa !6
  %568 = add i32 %563, 10
  br label %569

569:                                              ; preds = %598, %565
  %570 = phi i32 [ 0, %565 ], [ %599, %598 ]
  %571 = icmp eq i32 %570, 6
  br i1 %571, label %600, label %572

572:                                              ; preds = %569
  %573 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %570
  %574 = load i32, ptr %573, align 4, !tbaa !6
  %575 = add i32 %574, -3
  %576 = icmp ult i32 %575, -2
  br i1 %576, label %598, label %577

577:                                              ; preds = %572
  %578 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %570
  %579 = load i32, ptr %578, align 4, !tbaa !6
  %580 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %570
  %581 = load i32, ptr %580, align 4, !tbaa !6
  %582 = sub nsw i32 %567, %581
  %583 = sub i32 %568, %579
  %584 = icmp ult i32 %583, 21
  %585 = add i32 %582, 11
  %586 = icmp ult i32 %585, 23
  %587 = select i1 %584, i1 %586, i1 false
  br i1 %587, label %588, label %598

588:                                              ; preds = %577
  %589 = icmp eq i32 %574, 2
  %590 = icmp slt i32 %582, 0
  %591 = select i1 %589, i1 %590, i1 false
  tail call fastcc void @troop_erase(i32 noundef %570) #7
  %592 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %593 = select i1 %591, i32 5, i32 10
  %594 = select i1 %591, i32 3, i32 0
  %595 = add nsw i32 %592, %593
  store i32 %594, ptr %573, align 4, !tbaa !6
  store i32 %595, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  store i32 -999, ptr %562, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #6
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #6
  %596 = load i32, ptr %562, align 4, !tbaa !6
  %597 = icmp eq i32 %596, -999
  br i1 %597, label %621, label %600

598:                                              ; preds = %572, %577
  %599 = add nuw nsw i32 %570, 1
  br label %569, !llvm.loop !43

600:                                              ; preds = %569, %588
  %601 = add i32 %563, -14
  %602 = add i32 %567, -12
  br label %603

603:                                              ; preds = %600, %619
  %604 = phi i32 [ %620, %619 ], [ 0, %600 ]
  %605 = icmp eq i32 %604, 2
  br i1 %605, label %621, label %606

606:                                              ; preds = %603
  %607 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %604
  %608 = load i32, ptr %607, align 4, !tbaa !6
  %609 = icmp eq i32 %608, -999
  br i1 %609, label %619, label %610

610:                                              ; preds = %606
  %611 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %604
  %612 = load i32, ptr %611, align 4, !tbaa !6
  %613 = sub i32 %601, %608
  %614 = icmp ult i32 %613, -27
  %615 = sub i32 %602, %612
  %616 = icmp ult i32 %615, -13
  %617 = select i1 %614, i1 true, i1 %616
  br i1 %617, label %619, label %618

618:                                              ; preds = %610
  tail call fastcc void @heli_kill(i32 noundef %604) #7
  store i32 -999, ptr %562, align 4, !tbaa !6
  br label %621

619:                                              ; preds = %610, %606
  %620 = add nuw nsw i32 %604, 1
  br label %603, !llvm.loop !44

621:                                              ; preds = %603, %618, %588, %561
  %622 = add nuw nsw i32 %553, 1
  br label %552, !llvm.loop !45

623:                                              ; preds = %555
  %624 = add nsw i32 %558, -1
  store i32 %624, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4, !tbaa !21
  %625 = icmp eq i32 %624, 0
  br i1 %625, label %626, label %627

626:                                              ; preds = %623
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  tail call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %627

627:                                              ; preds = %626, %623, %555
  br label %628

628:                                              ; preds = %627, %649
  %629 = phi i32 [ %650, %649 ], [ 0, %627 ]
  %630 = icmp eq i32 %629, 6
  br i1 %630, label %651, label %631

631:                                              ; preds = %628
  %632 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %629
  %633 = load i32, ptr %632, align 4, !tbaa !6
  %634 = icmp eq i32 %633, 0
  br i1 %634, label %649, label %635

635:                                              ; preds = %631
  %636 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %629
  %637 = load i32, ptr %636, align 4, !tbaa !6
  %638 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %629
  %639 = load i32, ptr %638, align 4, !tbaa !6
  switch i32 %633, label %647 [
    i32 2, label %640
    i32 1, label %643
    i32 3, label %645
  ]

640:                                              ; preds = %635
  %641 = add nsw i32 %637, -10
  %642 = add nsw i32 %639, -10
  tail call void @gfx_blit_runs(i32 noundef %641, i32 noundef %642, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3456), i32 noundef 20, i32 noundef 20, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6160)) #6
  br label %649

643:                                              ; preds = %635
  %644 = add nsw i32 %637, -4
  tail call void @gfx_blit_runs(i32 noundef %644, i32 noundef %639, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4256), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6384)) #6
  br label %649

645:                                              ; preds = %635
  %646 = add nsw i32 %637, -4
  tail call void @gfx_blit_runs(i32 noundef %646, i32 noundef %639, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4456), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6448)) #6
  br label %649

647:                                              ; preds = %635
  %648 = add nsw i32 %637, -4
  tail call void @gfx_blit_runs(i32 noundef %648, i32 noundef 214, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4656), i32 noundef 10, i32 noundef 12, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6512)) #6
  br label %649

649:                                              ; preds = %647, %645, %643, %640, %631
  %650 = add nuw nsw i32 %629, 1
  br label %628, !llvm.loop !46

651:                                              ; preds = %628, %659
  %652 = phi i32 [ %660, %659 ], [ 0, %628 ]
  %653 = icmp eq i32 %652, 2
  br i1 %653, label %661, label %654

654:                                              ; preds = %651
  %655 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %652
  %656 = load i32, ptr %655, align 4, !tbaa !6
  %657 = icmp eq i32 %656, -999
  br i1 %657, label %659, label %658

658:                                              ; preds = %654
  tail call fastcc void @heli_draw(i32 noundef %652, i32 noundef 0) #7
  br label %659

659:                                              ; preds = %654, %658
  %660 = add nuw nsw i32 %652, 1
  br label %651, !llvm.loop !47

661:                                              ; preds = %651, %676
  %662 = phi i32 [ %677, %676 ], [ 0, %651 ]
  %663 = icmp eq i32 %662, 4
  br i1 %663, label %664, label %667

664:                                              ; preds = %661
  %665 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %666 = icmp eq i32 %665, 0
  br i1 %666, label %679, label %678

667:                                              ; preds = %661
  %668 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %662
  %669 = load i32, ptr %668, align 4, !tbaa !6
  %670 = icmp eq i32 %669, -999
  br i1 %670, label %676, label %671

671:                                              ; preds = %667
  %672 = add nsw i32 %669, -1
  %673 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %662
  %674 = load i32, ptr %673, align 4, !tbaa !6
  %675 = add nsw i32 %674, -1
  tail call void @gfx_fill(i32 noundef %672, i32 noundef %675, i32 noundef 3, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %676

676:                                              ; preds = %667, %671
  %677 = add nuw nsw i32 %662, 1
  br label %661, !llvm.loop !48

678:                                              ; preds = %664
  tail call fastcc void @draw_gun() #7
  br label %679

679:                                              ; preds = %678, %664
  br label %680

680:                                              ; preds = %679, %690
  %681 = phi i32 [ %691, %690 ], [ 0, %679 ]
  %682 = icmp eq i32 %681, 12
  br i1 %682, label %692, label %683

683:                                              ; preds = %680
  %684 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %681
  %685 = load i32, ptr %684, align 4, !tbaa !6
  %686 = icmp eq i32 %685, -999
  br i1 %686, label %690, label %687

687:                                              ; preds = %683
  %688 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %681
  %689 = load i32, ptr %688, align 4, !tbaa !6
  tail call void @gfx_fill(i32 noundef %685, i32 noundef %689, i32 noundef 4, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %690

690:                                              ; preds = %683, %687
  %691 = add nuw nsw i32 %681, 1
  br label %680, !llvm.loop !49

692:                                              ; preds = %680, %708
  %693 = phi i32 [ %709, %708 ], [ 0, %680 ]
  %694 = icmp eq i32 %693, 3
  br i1 %694, label %710, label %695

695:                                              ; preds = %692
  %696 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %693
  %697 = load i32, ptr %696, align 4, !tbaa !6
  %698 = icmp eq i32 %697, -999
  br i1 %698, label %708, label %699

699:                                              ; preds = %695
  %700 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %693
  %701 = load i32, ptr %700, align 4, !tbaa !6
  %702 = add nsw i32 %697, -2
  %703 = add nsw i32 %701, -1
  tail call void @gfx_fill(i32 noundef %702, i32 noundef %703, i32 noundef 4, i32 noundef 2, i16 noundef zeroext 6371) #6
  %704 = add nsw i32 %697, -1
  %705 = add nsw i32 %701, -2
  tail call void @gfx_fill(i32 noundef %704, i32 noundef %705, i32 noundef 2, i32 noundef 4, i16 noundef zeroext 6371) #6
  %706 = add nsw i32 %697, 2
  %707 = add nsw i32 %701, 2
  tail call void @gfx_damage(i32 noundef %702, i32 noundef %705, i32 noundef %706, i32 noundef %707) #6
  br label %708

708:                                              ; preds = %695, %699
  %709 = add nuw nsw i32 %693, 1
  br label %692, !llvm.loop !50

710:                                              ; preds = %692, %724
  %711 = phi i32 [ %725, %724 ], [ 0, %692 ]
  %712 = icmp eq i32 %711, 4
  br i1 %712, label %726, label %713

713:                                              ; preds = %710
  %714 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %711
  %715 = load i32, ptr %714, align 4, !tbaa !6
  %716 = icmp eq i32 %715, -999
  br i1 %716, label %724, label %717

717:                                              ; preds = %713
  %718 = add nsw i32 %715, -2
  %719 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %711
  %720 = load i32, ptr %719, align 4, !tbaa !6
  %721 = add nsw i32 %720, -2
  %722 = add nsw i32 %715, 3
  %723 = add nsw i32 %720, 3
  tail call void @gfx_damage(i32 noundef %718, i32 noundef %721, i32 noundef %722, i32 noundef %723) #6
  br label %724

724:                                              ; preds = %713, %717
  %725 = add nuw nsw i32 %711, 1
  br label %710, !llvm.loop !51

726:                                              ; preds = %710, %742
  %727 = phi i32 [ %743, %742 ], [ 0, %710 ]
  %728 = icmp eq i32 %727, 12
  br i1 %728, label %729, label %731

729:                                              ; preds = %726
  %730 = icmp eq i32 %89, 0
  br i1 %730, label %744, label %748

731:                                              ; preds = %726
  %732 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %727
  %733 = load i32, ptr %732, align 4, !tbaa !6
  %734 = icmp eq i32 %733, -999
  br i1 %734, label %742, label %735

735:                                              ; preds = %731
  %736 = add nsw i32 %733, -1
  %737 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %727
  %738 = load i32, ptr %737, align 4, !tbaa !6
  %739 = add nsw i32 %738, -1
  %740 = add nsw i32 %733, 5
  %741 = add nsw i32 %738, 4
  tail call void @gfx_damage(i32 noundef %736, i32 noundef %739, i32 noundef %740, i32 noundef %741) #6
  br label %742

742:                                              ; preds = %731, %735
  %743 = add nuw nsw i32 %727, 1
  br label %726, !llvm.loop !52

744:                                              ; preds = %729
  %745 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %746 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !53
  %747 = icmp eq i32 %745, %746
  br i1 %747, label %749, label %748

748:                                              ; preds = %744, %729
  tail call fastcc void @draw_score() #7
  br label %749

749:                                              ; preds = %748, %744
  %750 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  %751 = icmp eq i32 %750, 0
  br i1 %751, label %753, label %752

752:                                              ; preds = %749
  tail call void @gfx_text2(i32 noundef 40, i32 noundef 104, ptr noundef nonnull @.str.6, i16 noundef zeroext -20286, i16 noundef zeroext -23083) #6
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.7, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  tail call void @gfx_text(i32 noundef 48, i32 noundef 140, ptr noundef nonnull @.str.8, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  br label %753

753:                                              ; preds = %752, %749
  br label %61, !llvm.loop !25

754:                                              ; preds = %86, %75
  ret void
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
  %15 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
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
declare dso_local void @snd_sweep(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

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
  tail call fastcc void @debris_spawn(i32 noundef 110, i32 noundef 216, i32 noundef -64, i32 noundef -96, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @debris_spawn(i32 noundef 116, i32 noundef 214, i32 noundef -32, i32 noundef -128, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @debris_spawn(i32 noundef 122, i32 noundef 214, i32 noundef 32, i32 noundef -112, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @debris_spawn(i32 noundef 128, i32 noundef 216, i32 noundef 64, i32 noundef -80, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @debris_spawn(i32 noundef 120, i32 noundef 218, i32 noundef 96, i32 noundef -64, i32 noundef 0, i32 noundef 0) #7
  tail call void @uputs(ptr noundef nonnull @.str.9) #6
  tail call void @snd_noise(i32 noundef 70, i32 noundef 30) #6
  tail call void @led_blink(i32 noundef 4130824, i32 noundef 6) #6
  br label %4

4:                                                ; preds = %0, %3
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @snd_play(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

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
  tail call fastcc void @debris_spawn(i32 noundef %6, i32 noundef %7, i32 noundef -12, i32 noundef 4, i32 noundef 30, i32 noundef 1) #7
  %8 = add nsw i32 %3, -2
  %9 = add nsw i32 %5, 4
  tail call fastcc void @debris_spawn(i32 noundef %8, i32 noundef %9, i32 noundef -5, i32 noundef 9, i32 noundef 30, i32 noundef 1) #7
  %10 = add nsw i32 %3, 2
  tail call fastcc void @debris_spawn(i32 noundef %10, i32 noundef %7, i32 noundef 5, i32 noundef 7, i32 noundef 30, i32 noundef 1) #7
  %11 = add nsw i32 %3, 8
  tail call fastcc void @debris_spawn(i32 noundef %11, i32 noundef %9, i32 noundef 12, i32 noundef 2, i32 noundef 30, i32 noundef 1) #7
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
declare dso_local void @gfx_damage(i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit_runs(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @debris_spawn(i32 noundef %0, i32 noundef range(i32 -2147483646, -2147483648) %1, i32 noundef range(i32 -64, 97) %2, i32 noundef range(i32 -128, 10) %3, i32 noundef range(i32 0, 31) %4, i32 noundef range(i32 0, 2) %5) unnamed_addr #4 {
  br label %7

7:                                                ; preds = %22, %6
  %8 = phi i32 [ 0, %6 ], [ %23, %22 ]
  %9 = icmp eq i32 %8, 12
  br i1 %9, label %24, label %10

10:                                               ; preds = %7
  %11 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %8
  %12 = load i32, ptr %11, align 4, !tbaa !6
  %13 = icmp eq i32 %12, -999
  br i1 %13, label %14, label %22

14:                                               ; preds = %10
  store i32 %0, ptr %11, align 4, !tbaa !6
  %15 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %8
  store i32 %1, ptr %15, align 4, !tbaa !6
  %16 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 392), i32 0, i32 %8
  store i32 %2, ptr %16, align 4, !tbaa !6
  %17 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 440), i32 0, i32 %8
  store i32 %3, ptr %17, align 4, !tbaa !6
  %18 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 488), i32 0, i32 %8
  store i32 0, ptr %18, align 4, !tbaa !6
  %19 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 536), i32 0, i32 %8
  store i32 0, ptr %19, align 4, !tbaa !6
  %20 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), i32 0, i32 %8
  store i32 %4, ptr %20, align 4, !tbaa !6
  %21 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 632), i32 0, i32 %8
  store i32 %5, ptr %21, align 4, !tbaa !6
  br label %24

22:                                               ; preds = %10
  %23 = add nuw nsw i32 %8, 1
  br label %7, !llvm.loop !63

24:                                               ; preds = %7, %14
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @snd_noise(i32 noundef, i32 noundef) local_unnamed_addr #1

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
!15 = !{!"cst", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !8, i64 32, !8, i64 44, !8, i64 56, !8, i64 68, !8, i64 80, !8, i64 92, !8, i64 104, !8, i64 112, !8, i64 120, !8, i64 128, !8, i64 136, !8, i64 160, !8, i64 184, !8, i64 208, !8, i64 232, !8, i64 248, !8, i64 264, !8, i64 280, !8, i64 296, !8, i64 344, !8, i64 392, !8, i64 440, !8, i64 488, !8, i64 536, !8, i64 584, !8, i64 632, !7, i64 680, !7, i64 684}
!16 = !{!15, !7, i64 4}
!17 = !{!15, !7, i64 8}
!18 = !{!15, !7, i64 12}
!19 = !{!15, !7, i64 16}
!20 = !{!15, !7, i64 24}
!21 = !{!15, !7, i64 28}
!22 = !{!15, !7, i64 680}
!23 = !{!15, !7, i64 684}
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
