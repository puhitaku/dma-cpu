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
@mdx = internal unnamed_addr constant [13 x i8] c"\F1\F2\F4\F7\F9\FD\00\03\07\09\0C\0E\0F", align 1
@mdy = internal unnamed_addr constant [13 x i8] c"\03\06\09\0C\0D\0F\0F\0F\0D\0C\09\06\03", align 1
@avx = internal unnamed_addr constant [13 x i8] c"\C5\CA\D1\DA\E6\F3\00\0D\1A&/6;", align 1
@avy = internal unnamed_addr constant [13 x i8] c"\F4\E7\DB\D1\CA\C6\C4\C6\CA\D1\DB\E7\F4", align 1
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
  store i32 6, ptr @arena_w, align 4, !tbaa !14
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

61:                                               ; preds = %758, %57
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
  br label %759

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
  br label %759

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
  br label %211

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
  %172 = icmp slt i32 %168, 12
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

181:                                              ; preds = %177, %209
  %182 = phi i32 [ %210, %209 ], [ 0, %177 ]
  %183 = icmp eq i32 %182, 3
  br i1 %183, label %144, label %184

184:                                              ; preds = %181
  %185 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %182
  %186 = load i32, ptr %185, align 4, !tbaa !6
  %187 = icmp eq i32 %186, -999
  br i1 %187, label %188, label %209

188:                                              ; preds = %184
  %189 = load i32, ptr @arena_w, align 4, !tbaa !14
  %190 = getelementptr inbounds [13 x i8], ptr @mdx, i32 0, i32 %189
  %191 = load i8, ptr %190, align 1, !tbaa !31
  %192 = sext i8 %191 to i32
  %193 = add nsw i32 %192, 120
  store i32 %193, ptr %185, align 4, !tbaa !6
  %194 = getelementptr inbounds [13 x i8], ptr @mdy, i32 0, i32 %189
  %195 = load i8, ptr %194, align 1, !tbaa !31
  %196 = sext i8 %195 to i32
  %197 = sub nsw i32 212, %196
  %198 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %182
  store i32 %197, ptr %198, align 4, !tbaa !6
  %199 = getelementptr inbounds [13 x i8], ptr @avx, i32 0, i32 %189
  %200 = load i8, ptr %199, align 1, !tbaa !31
  %201 = sext i8 %200 to i32
  %202 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %182
  store i32 %201, ptr %202, align 4, !tbaa !6
  %203 = getelementptr inbounds [13 x i8], ptr @avy, i32 0, i32 %189
  %204 = load i8, ptr %203, align 1, !tbaa !31
  %205 = sext i8 %204 to i32
  %206 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %182
  store i32 %205, ptr %206, align 4, !tbaa !6
  %207 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %182
  store i32 0, ptr %207, align 4, !tbaa !6
  %208 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 92), i32 0, i32 %182
  store i32 0, ptr %208, align 4, !tbaa !6
  tail call void @snd_sweep(i32 noundef 260, i32 noundef 45, i32 noundef 5, i32 noundef 25) #6
  br label %144

209:                                              ; preds = %184
  %210 = add nuw nsw i32 %182, 1
  br label %181, !llvm.loop !32

211:                                              ; preds = %144, %239
  %212 = phi i32 [ %240, %239 ], [ 0, %144 ]
  %213 = icmp eq i32 %212, 3
  br i1 %213, label %214, label %219

214:                                              ; preds = %211
  %215 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  %216 = add i32 %215, -1
  store i32 %216, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  %217 = icmp eq i32 %216, 0
  br i1 %217, label %241, label %218

218:                                              ; preds = %248, %255, %214
  br label %271

219:                                              ; preds = %211
  %220 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %212
  %221 = load i32, ptr %220, align 4, !tbaa !6
  %222 = icmp eq i32 %221, -999
  br i1 %222, label %239, label %223

223:                                              ; preds = %219
  %224 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 80), i32 0, i32 %212
  %225 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 56), i32 0, i32 %212
  %226 = load i32, ptr %225, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %220, ptr noundef nonnull %224, i32 noundef %226) #7
  %227 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %212
  %228 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 92), i32 0, i32 %212
  %229 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 68), i32 0, i32 %212
  %230 = load i32, ptr %229, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %227, ptr noundef nonnull %228, i32 noundef %230) #7
  %231 = load i32, ptr %227, align 4, !tbaa !6
  %232 = icmp slt i32 %231, 2
  br i1 %232, label %238, label %233

233:                                              ; preds = %223
  %234 = load i32, ptr %220, align 4, !tbaa !6
  %235 = icmp slt i32 %234, 3
  br i1 %235, label %238, label %236

236:                                              ; preds = %233
  %237 = icmp samesign ugt i32 %234, 236
  br i1 %237, label %238, label %239

238:                                              ; preds = %236, %233, %223
  store i32 -999, ptr %220, align 4, !tbaa !6
  br label %239

239:                                              ; preds = %236, %238, %219
  %240 = add nuw nsw i32 %212, 1
  br label %211, !llvm.loop !33

241:                                              ; preds = %214
  %242 = tail call i32 @rng_below(i32 noundef 90) #6
  %243 = add i32 %242, 90
  %244 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %245 = sdiv i32 %244, 20
  %246 = tail call i32 @llvm.smin.i32(i32 %245, i32 50)
  %247 = sub i32 %243, %246
  store i32 %247, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 680), align 4, !tbaa !22
  br label %248

248:                                              ; preds = %269, %241
  %249 = phi i32 [ 0, %241 ], [ %270, %269 ]
  %250 = icmp eq i32 %249, 2
  br i1 %250, label %218, label %251

251:                                              ; preds = %248
  %252 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %249
  %253 = load i32, ptr %252, align 4, !tbaa !6
  %254 = icmp eq i32 %253, -999
  br i1 %254, label %255, label %269

255:                                              ; preds = %251
  %256 = tail call i32 @rng() #6
  %257 = and i32 %256, 1
  %258 = icmp eq i32 %257, 0
  %259 = select i1 %258, i32 254, i32 -14
  store i32 %259, ptr %252, align 4, !tbaa !6
  %260 = select i1 %258, i32 -2, i32 2
  %261 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %249
  store i32 %260, ptr %261, align 4, !tbaa !6
  %262 = tail call i32 @rng_below(i32 noundef 2) #6
  %263 = shl nsw i32 %262, 4
  %264 = add nsw i32 %263, 18
  %265 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %249
  store i32 %264, ptr %265, align 4, !tbaa !6
  %266 = tail call i32 @rng_below(i32 noundef 172) #6
  %267 = add nsw i32 %266, 34
  %268 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %249
  store i32 %267, ptr %268, align 4, !tbaa !6
  br label %218

269:                                              ; preds = %251
  %270 = add nuw nsw i32 %249, 1
  br label %248, !llvm.loop !34

271:                                              ; preds = %218, %317
  %272 = phi i32 [ %318, %317 ], [ 0, %218 ]
  %273 = icmp eq i32 %272, 2
  br i1 %273, label %319, label %274

274:                                              ; preds = %271
  %275 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %272
  %276 = load i32, ptr %275, align 4, !tbaa !6
  %277 = icmp eq i32 %276, -999
  br i1 %277, label %317, label %278

278:                                              ; preds = %274
  %279 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 120), i32 0, i32 %272
  %280 = load i32, ptr %279, align 4, !tbaa !6
  %281 = add nsw i32 %280, %276
  store i32 %281, ptr %275, align 4, !tbaa !6
  %282 = icmp slt i32 %281, -15
  br i1 %282, label %285, label %283

283:                                              ; preds = %278
  %284 = icmp sgt i32 %281, 255
  br i1 %284, label %285, label %286

285:                                              ; preds = %283, %278
  store i32 -999, ptr %275, align 4, !tbaa !6
  br label %317

286:                                              ; preds = %283
  %287 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 128), i32 0, i32 %272
  %288 = load i32, ptr %287, align 4, !tbaa !6
  %289 = icmp sgt i32 %288, -1
  br i1 %289, label %290, label %317

290:                                              ; preds = %286
  %291 = icmp sgt i32 %280, 0
  br i1 %291, label %292, label %294

292:                                              ; preds = %290
  %293 = icmp slt i32 %281, %288
  br i1 %293, label %317, label %298

294:                                              ; preds = %290
  %295 = icmp slt i32 %280, 0
  br i1 %295, label %296, label %317

296:                                              ; preds = %294
  %297 = icmp sgt i32 %281, %288
  br i1 %297, label %317, label %298

298:                                              ; preds = %296, %292
  store i32 -1, ptr %287, align 4, !tbaa !6
  br label %299

299:                                              ; preds = %306, %298
  %300 = phi i32 [ 0, %298 ], [ %307, %306 ]
  %301 = icmp eq i32 %300, 6
  br i1 %301, label %317, label %302

302:                                              ; preds = %299
  %303 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %300
  %304 = load i32, ptr %303, align 4, !tbaa !6
  %305 = icmp eq i32 %304, 0
  br i1 %305, label %308, label %306

306:                                              ; preds = %302
  %307 = add nuw nsw i32 %300, 1
  br label %299, !llvm.loop !35

308:                                              ; preds = %302
  store i32 1, ptr %303, align 4, !tbaa !6
  %309 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %300
  store i32 15, ptr %309, align 4, !tbaa !6
  %310 = load i32, ptr %275, align 4, !tbaa !6
  %311 = and i32 %310, -2
  %312 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %300
  store i32 %311, ptr %312, align 4, !tbaa !6
  %313 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %272
  %314 = load i32, ptr %313, align 4, !tbaa !6
  %315 = add nsw i32 %314, 12
  %316 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %300
  store i32 %315, ptr %316, align 4, !tbaa !6
  br label %317

317:                                              ; preds = %299, %292, %308, %286, %294, %296, %274, %285
  %318 = add nuw nsw i32 %272, 1
  br label %271, !llvm.loop !36

319:                                              ; preds = %271, %417
  %320 = phi i32 [ %418, %417 ], [ 0, %271 ]
  %321 = icmp eq i32 %320, 6
  br i1 %321, label %419, label %322

322:                                              ; preds = %319
  %323 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %320
  %324 = load i32, ptr %323, align 4, !tbaa !6
  switch i32 %324, label %387 [
    i32 0, label %417
    i32 4, label %325
    i32 1, label %364
    i32 2, label %373
  ]

325:                                              ; preds = %322
  %326 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %327 = icmp sgt i32 %326, 3
  %328 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4
  %329 = icmp ne i32 %328, 0
  %330 = select i1 %327, i1 %329, i1 false
  br i1 %330, label %331, label %417

331:                                              ; preds = %325
  %332 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %320
  %333 = load i32, ptr %332, align 4, !tbaa !6
  %334 = add nsw i32 %333, -1
  store i32 %334, ptr %332, align 4, !tbaa !6
  %335 = icmp slt i32 %333, 2
  br i1 %335, label %336, label %417

336:                                              ; preds = %331
  %337 = tail call i32 @rng_below(i32 noundef 50) #6
  %338 = add nsw i32 %337, 70
  store i32 %338, ptr %332, align 4, !tbaa !6
  br label %339

339:                                              ; preds = %362, %336
  %340 = phi i32 [ 0, %336 ], [ %363, %362 ]
  %341 = icmp eq i32 %340, 4
  br i1 %341, label %417, label %342

342:                                              ; preds = %339
  %343 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %340
  %344 = load i32, ptr %343, align 4, !tbaa !6
  %345 = icmp eq i32 %344, -999
  br i1 %345, label %346, label %362

346:                                              ; preds = %342
  %347 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %320
  %348 = load i32, ptr %347, align 4, !tbaa !6
  store i32 %348, ptr %343, align 4, !tbaa !6
  %349 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %340
  store i32 212, ptr %349, align 4, !tbaa !6
  %350 = load i32, ptr %347, align 4, !tbaa !6
  %351 = sub nsw i32 120, %350
  %352 = sdiv i32 %351, 22
  %353 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 264), i32 0, i32 %340
  store i32 %352, ptr %353, align 4, !tbaa !6
  %354 = add i32 %350, -99
  %355 = icmp ult i32 %354, 43
  br i1 %355, label %356, label %360

356:                                              ; preds = %346
  %357 = load i32, ptr %347, align 4, !tbaa !6
  %358 = icmp slt i32 %357, 120
  %359 = select i1 %358, i32 1, i32 -1
  store i32 %359, ptr %353, align 4, !tbaa !6
  br label %360

360:                                              ; preds = %356, %346
  %361 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 280), i32 0, i32 %340
  store i32 -6, ptr %361, align 4, !tbaa !6
  tail call void @snd_sweep(i32 noundef 700, i32 noundef 35, i32 noundef 5, i32 noundef 60) #6
  br label %417

362:                                              ; preds = %342
  %363 = add nuw nsw i32 %340, 1
  br label %339, !llvm.loop !37

364:                                              ; preds = %322
  %365 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %320
  %366 = load i32, ptr %365, align 4, !tbaa !6
  %367 = add nsw i32 %366, 2
  store i32 %367, ptr %365, align 4, !tbaa !6
  %368 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %320
  %369 = load i32, ptr %368, align 4, !tbaa !6
  %370 = add nsw i32 %369, -1
  store i32 %370, ptr %368, align 4, !tbaa !6
  %371 = icmp slt i32 %369, 2
  br i1 %371, label %372, label %391

372:                                              ; preds = %364
  store i32 2, ptr %323, align 4, !tbaa !6
  br label %391

373:                                              ; preds = %322
  %374 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %320
  %375 = load i32, ptr %374, align 4, !tbaa !6
  %376 = add nsw i32 %375, 1
  store i32 %376, ptr %374, align 4, !tbaa !6
  %377 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
  %378 = and i32 %377, 7
  %379 = icmp eq i32 %378, 0
  br i1 %379, label %380, label %391

380:                                              ; preds = %373
  %381 = and i32 %377, 8
  %382 = icmp eq i32 %381, 0
  %383 = select i1 %382, i32 -2, i32 2
  %384 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %320
  %385 = load i32, ptr %384, align 4, !tbaa !6
  %386 = add nsw i32 %385, %383
  store i32 %386, ptr %384, align 4, !tbaa !6
  br label %391

387:                                              ; preds = %322
  %388 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %320
  %389 = load i32, ptr %388, align 4, !tbaa !6
  %390 = add nsw i32 %389, 5
  store i32 %390, ptr %388, align 4, !tbaa !6
  br label %391

391:                                              ; preds = %387, %380, %373, %364, %372
  %392 = phi i32 [ %390, %387 ], [ %376, %380 ], [ %376, %373 ], [ %367, %364 ], [ %367, %372 ]
  %393 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %394 = icmp eq i32 %393, 0
  br i1 %394, label %403, label %395

395:                                              ; preds = %391
  %396 = icmp sgt i32 %392, 207
  br i1 %396, label %397, label %417

397:                                              ; preds = %395
  %398 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %320
  %399 = load i32, ptr %398, align 4, !tbaa !6
  %400 = add i32 %399, -105
  %401 = icmp ult i32 %400, 31
  br i1 %401, label %402, label %403

402:                                              ; preds = %397
  tail call fastcc void @troop_erase(i32 noundef %320) #7
  store i32 0, ptr %323, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %417

403:                                              ; preds = %397, %391
  %404 = icmp sgt i32 %392, 215
  br i1 %404, label %405, label %417

405:                                              ; preds = %403
  %406 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %320
  store i32 216, ptr %406, align 4, !tbaa !6
  %407 = icmp eq i32 %324, 3
  br i1 %407, label %408, label %411

408:                                              ; preds = %405
  store i32 0, ptr %323, align 4, !tbaa !6
  %409 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %410 = add nsw i32 %409, 2
  store i32 %410, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  tail call void @snd_play(i32 noundef 90, i32 noundef 60, i32 noundef 3) #6
  br label %417

411:                                              ; preds = %405
  store i32 4, ptr %323, align 4, !tbaa !6
  %412 = tail call i32 @rng_below(i32 noundef 40) #6
  %413 = add nsw i32 %412, 40
  %414 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 208), i32 0, i32 %320
  store i32 %413, ptr %414, align 4, !tbaa !6
  %415 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %416 = add nsw i32 %415, 1
  store i32 %416, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call void @snd_play(i32 noundef 150, i32 noundef 50, i32 noundef 4) #6
  tail call fastcc void @draw_score() #7
  br label %417

417:                                              ; preds = %339, %395, %403, %322, %325, %331, %360, %411, %408, %402
  %418 = add nuw nsw i32 %320, 1
  br label %319, !llvm.loop !38

419:                                              ; preds = %319, %456
  %420 = phi i32 [ %457, %456 ], [ 0, %319 ]
  %421 = icmp eq i32 %420, 4
  br i1 %421, label %458, label %422

422:                                              ; preds = %419
  %423 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %420
  %424 = load i32, ptr %423, align 4, !tbaa !6
  %425 = icmp eq i32 %424, -999
  br i1 %425, label %456, label %426

426:                                              ; preds = %422
  %427 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 264), i32 0, i32 %420
  %428 = load i32, ptr %427, align 4, !tbaa !6
  %429 = add nsw i32 %428, %424
  store i32 %429, ptr %423, align 4, !tbaa !6
  %430 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 280), i32 0, i32 %420
  %431 = load i32, ptr %430, align 4, !tbaa !6
  %432 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %420
  %433 = load i32, ptr %432, align 4, !tbaa !6
  %434 = add nsw i32 %433, %431
  store i32 %434, ptr %432, align 4, !tbaa !6
  %435 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 684), align 4, !tbaa !23
  %436 = and i32 %435, 1
  %437 = icmp eq i32 %436, 0
  br i1 %437, label %440, label %438

438:                                              ; preds = %426
  %439 = add nsw i32 %431, 1
  store i32 %439, ptr %430, align 4, !tbaa !6
  br label %440

440:                                              ; preds = %438, %426
  %441 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %442 = icmp eq i32 %441, 0
  br i1 %442, label %449, label %443

443:                                              ; preds = %440
  %444 = icmp sgt i32 %434, 211
  br i1 %444, label %445, label %451

445:                                              ; preds = %443
  %446 = add i32 %429, -106
  %447 = icmp ult i32 %446, 29
  br i1 %447, label %448, label %449

448:                                              ; preds = %445
  store i32 -999, ptr %423, align 4, !tbaa !6
  tail call fastcc void @gun_destroy() #7
  br label %456

449:                                              ; preds = %445, %440
  %450 = icmp sgt i32 %434, 223
  br i1 %450, label %455, label %451

451:                                              ; preds = %443, %449
  %452 = icmp slt i32 %429, 3
  br i1 %452, label %455, label %453

453:                                              ; preds = %451
  %454 = icmp samesign ugt i32 %429, 236
  br i1 %454, label %455, label %456

455:                                              ; preds = %453, %451, %449
  store i32 -999, ptr %423, align 4, !tbaa !6
  br label %456

456:                                              ; preds = %453, %455, %422, %448
  %457 = add nuw nsw i32 %420, 1
  br label %419, !llvm.loop !39

458:                                              ; preds = %419, %555
  %459 = phi i32 [ %556, %555 ], [ 0, %419 ]
  %460 = icmp eq i32 %459, 12
  br i1 %460, label %557, label %461

461:                                              ; preds = %458
  %462 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %459
  %463 = load i32, ptr %462, align 4, !tbaa !6
  %464 = icmp eq i32 %463, -999
  br i1 %464, label %555, label %465

465:                                              ; preds = %461
  %466 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 488), i32 0, i32 %459
  %467 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 392), i32 0, i32 %459
  %468 = load i32, ptr %467, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %462, ptr noundef nonnull %466, i32 noundef %468) #7
  %469 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %459
  %470 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 536), i32 0, i32 %459
  %471 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 440), i32 0, i32 %459
  %472 = load i32, ptr %471, align 4, !tbaa !6
  tail call fastcc void @subpx(ptr noundef nonnull %469, ptr noundef nonnull %470, i32 noundef %472) #7
  %473 = load i32, ptr %471, align 4, !tbaa !6
  %474 = tail call i32 @llvm.smin.i32(i32 %473, i32 24)
  %475 = add nsw i32 %474, 8
  store i32 %475, ptr %471, align 4, !tbaa !6
  %476 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 584), i32 0, i32 %459
  %477 = load i32, ptr %476, align 4, !tbaa !6
  %478 = icmp eq i32 %477, 0
  br i1 %478, label %483, label %479

479:                                              ; preds = %465
  %480 = add nsw i32 %477, -1
  store i32 %480, ptr %476, align 4, !tbaa !6
  %481 = icmp eq i32 %480, 0
  br i1 %481, label %482, label %483

482:                                              ; preds = %479
  store i32 -999, ptr %462, align 4, !tbaa !6
  br label %555

483:                                              ; preds = %479, %465
  %484 = load i32, ptr %462, align 4, !tbaa !6
  %485 = load i32, ptr %469, align 4, !tbaa !6
  %486 = icmp sgt i32 %485, 223
  br i1 %486, label %493, label %487

487:                                              ; preds = %483
  %488 = icmp slt i32 %485, 4
  br i1 %488, label %493, label %489

489:                                              ; preds = %487
  %490 = icmp slt i32 %484, 2
  br i1 %490, label %493, label %491

491:                                              ; preds = %489
  %492 = icmp samesign ugt i32 %484, 236
  br i1 %492, label %493, label %494

493:                                              ; preds = %491, %489, %487, %483
  store i32 -999, ptr %462, align 4, !tbaa !6
  br label %555

494:                                              ; preds = %491, %516
  %495 = phi i32 [ %517, %516 ], [ 0, %491 ]
  %496 = icmp eq i32 %495, 2
  br i1 %496, label %518, label %497

497:                                              ; preds = %494
  %498 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %495
  %499 = load i32, ptr %498, align 4, !tbaa !6
  %500 = icmp ne i32 %499, -999
  %501 = add nsw i32 %499, -14
  %502 = icmp sgt i32 %484, %501
  %503 = select i1 %500, i1 %502, i1 false
  %504 = add nsw i32 %499, 14
  %505 = icmp slt i32 %484, %504
  %506 = select i1 %503, i1 %505, i1 false
  br i1 %506, label %507, label %516

507:                                              ; preds = %497
  %508 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %495
  %509 = load i32, ptr %508, align 4, !tbaa !6
  %510 = add nsw i32 %509, -2
  %511 = icmp sgt i32 %485, %510
  %512 = add nsw i32 %509, 12
  %513 = icmp slt i32 %485, %512
  %514 = select i1 %511, i1 %513, i1 false
  br i1 %514, label %515, label %516

515:                                              ; preds = %507
  tail call fastcc void @heli_kill(i32 noundef %495) #7
  store i32 -999, ptr %462, align 4, !tbaa !6
  br label %555

516:                                              ; preds = %497, %507
  %517 = add nuw nsw i32 %495, 1
  br label %494, !llvm.loop !40

518:                                              ; preds = %494
  %519 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 632), i32 0, i32 %459
  %520 = load i32, ptr %519, align 4, !tbaa !6
  %521 = icmp eq i32 %520, 0
  br i1 %521, label %555, label %522

522:                                              ; preds = %518, %553
  %523 = phi i32 [ %554, %553 ], [ 0, %518 ]
  %524 = icmp eq i32 %523, 6
  br i1 %524, label %555, label %525

525:                                              ; preds = %522
  %526 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %523
  %527 = load i32, ptr %526, align 4, !tbaa !6
  switch i32 %527, label %528 [
    i32 0, label %553
    i32 4, label %531
  ]

528:                                              ; preds = %525
  %529 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %523
  %530 = load i32, ptr %529, align 4, !tbaa !6
  br label %531

531:                                              ; preds = %525, %528
  %532 = phi i32 [ %530, %528 ], [ 218, %525 ]
  %533 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %523
  %534 = load i32, ptr %533, align 4, !tbaa !6
  %535 = add nsw i32 %534, -10
  %536 = icmp sgt i32 %484, %535
  %537 = add nsw i32 %534, 10
  %538 = icmp slt i32 %484, %537
  %539 = select i1 %536, i1 %538, i1 false
  %540 = add nsw i32 %532, -12
  %541 = icmp sgt i32 %485, %540
  %542 = select i1 %539, i1 %541, i1 false
  %543 = add nsw i32 %532, 10
  %544 = icmp slt i32 %485, %543
  %545 = select i1 %542, i1 %544, i1 false
  br i1 %545, label %546, label %553

546:                                              ; preds = %531
  %547 = icmp eq i32 %527, 4
  br i1 %547, label %548, label %551

548:                                              ; preds = %546
  tail call fastcc void @sky(i32 noundef %535, i32 noundef 214, i32 noundef 20, i32 noundef 12) #7
  %549 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  %550 = add nsw i32 %549, -1
  store i32 %550, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 8), align 4, !tbaa !17
  tail call fastcc void @draw_score() #7
  br label %552

551:                                              ; preds = %546
  tail call fastcc void @troop_erase(i32 noundef range(i32 -2147483648, 6) %523) #7
  br label %552

552:                                              ; preds = %551, %548
  store i32 0, ptr %526, align 4, !tbaa !6
  store i32 -999, ptr %462, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 300, i32 noundef 40, i32 noundef 2) #6
  br label %555

553:                                              ; preds = %525, %531
  %554 = add nuw nsw i32 %523, 1
  br label %522, !llvm.loop !41

555:                                              ; preds = %522, %552, %515, %493, %518, %461, %482
  %556 = add nuw nsw i32 %459, 1
  br label %458, !llvm.loop !42

557:                                              ; preds = %458, %626
  %558 = phi i32 [ %627, %626 ], [ 0, %458 ]
  %559 = icmp eq i32 %558, 3
  br i1 %559, label %560, label %566

560:                                              ; preds = %557
  %561 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %562 = icmp eq i32 %561, 0
  %563 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4
  %564 = icmp sgt i32 %563, 0
  %565 = select i1 %562, i1 %564, i1 false
  br i1 %565, label %628, label %632

566:                                              ; preds = %557
  %567 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %558
  %568 = load i32, ptr %567, align 4, !tbaa !6
  %569 = icmp eq i32 %568, -999
  br i1 %569, label %626, label %570

570:                                              ; preds = %566
  %571 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %558
  %572 = load i32, ptr %571, align 4, !tbaa !6
  %573 = add i32 %568, 10
  br label %574

574:                                              ; preds = %603, %570
  %575 = phi i32 [ 0, %570 ], [ %604, %603 ]
  %576 = icmp eq i32 %575, 6
  br i1 %576, label %605, label %577

577:                                              ; preds = %574
  %578 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %575
  %579 = load i32, ptr %578, align 4, !tbaa !6
  %580 = add i32 %579, -3
  %581 = icmp ult i32 %580, -2
  br i1 %581, label %603, label %582

582:                                              ; preds = %577
  %583 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %575
  %584 = load i32, ptr %583, align 4, !tbaa !6
  %585 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %575
  %586 = load i32, ptr %585, align 4, !tbaa !6
  %587 = sub nsw i32 %572, %586
  %588 = sub i32 %573, %584
  %589 = icmp ult i32 %588, 21
  %590 = add i32 %587, 11
  %591 = icmp ult i32 %590, 23
  %592 = select i1 %589, i1 %591, i1 false
  br i1 %592, label %593, label %603

593:                                              ; preds = %582
  %594 = icmp eq i32 %579, 2
  %595 = icmp slt i32 %587, 0
  %596 = select i1 %594, i1 %595, i1 false
  tail call fastcc void @troop_erase(i32 noundef %575) #7
  %597 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %598 = select i1 %596, i32 5, i32 10
  %599 = select i1 %596, i32 3, i32 0
  %600 = add nsw i32 %597, %598
  store i32 %599, ptr %578, align 4, !tbaa !6
  store i32 %600, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  store i32 -999, ptr %567, align 4, !tbaa !6
  tail call void @snd_play(i32 noundef 500, i32 noundef 50, i32 noundef 2) #6
  tail call void @led_blink(i32 noundef 4139008, i32 noundef 1) #6
  %601 = load i32, ptr %567, align 4, !tbaa !6
  %602 = icmp eq i32 %601, -999
  br i1 %602, label %626, label %605

603:                                              ; preds = %577, %582
  %604 = add nuw nsw i32 %575, 1
  br label %574, !llvm.loop !43

605:                                              ; preds = %574, %593
  %606 = add i32 %568, -14
  %607 = add i32 %572, -12
  br label %608

608:                                              ; preds = %605, %624
  %609 = phi i32 [ %625, %624 ], [ 0, %605 ]
  %610 = icmp eq i32 %609, 2
  br i1 %610, label %626, label %611

611:                                              ; preds = %608
  %612 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %609
  %613 = load i32, ptr %612, align 4, !tbaa !6
  %614 = icmp eq i32 %613, -999
  br i1 %614, label %624, label %615

615:                                              ; preds = %611
  %616 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 112), i32 0, i32 %609
  %617 = load i32, ptr %616, align 4, !tbaa !6
  %618 = sub i32 %606, %613
  %619 = icmp ult i32 %618, -27
  %620 = sub i32 %607, %617
  %621 = icmp ult i32 %620, -13
  %622 = select i1 %619, i1 true, i1 %621
  br i1 %622, label %624, label %623

623:                                              ; preds = %615
  tail call fastcc void @heli_kill(i32 noundef %609) #7
  store i32 -999, ptr %567, align 4, !tbaa !6
  br label %626

624:                                              ; preds = %615, %611
  %625 = add nuw nsw i32 %609, 1
  br label %608, !llvm.loop !44

626:                                              ; preds = %608, %623, %593, %566
  %627 = add nuw nsw i32 %558, 1
  br label %557, !llvm.loop !45

628:                                              ; preds = %560
  %629 = add nsw i32 %563, -1
  store i32 %629, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 28), align 4, !tbaa !21
  %630 = icmp eq i32 %629, 0
  br i1 %630, label %631, label %632

631:                                              ; preds = %628
  store i32 1, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  tail call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %632

632:                                              ; preds = %631, %628, %560
  br label %633

633:                                              ; preds = %632, %654
  %634 = phi i32 [ %655, %654 ], [ 0, %632 ]
  %635 = icmp eq i32 %634, 6
  br i1 %635, label %656, label %636

636:                                              ; preds = %633
  %637 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 184), i32 0, i32 %634
  %638 = load i32, ptr %637, align 4, !tbaa !6
  %639 = icmp eq i32 %638, 0
  br i1 %639, label %654, label %640

640:                                              ; preds = %636
  %641 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 136), i32 0, i32 %634
  %642 = load i32, ptr %641, align 4, !tbaa !6
  %643 = getelementptr inbounds nuw [6 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 160), i32 0, i32 %634
  %644 = load i32, ptr %643, align 4, !tbaa !6
  switch i32 %638, label %652 [
    i32 2, label %645
    i32 1, label %648
    i32 3, label %650
  ]

645:                                              ; preds = %640
  %646 = add nsw i32 %642, -10
  %647 = add nsw i32 %644, -10
  tail call void @gfx_blit_runs(i32 noundef %646, i32 noundef %647, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 3456), i32 noundef 20, i32 noundef 20, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6160)) #6
  br label %654

648:                                              ; preds = %640
  %649 = add nsw i32 %642, -4
  tail call void @gfx_blit_runs(i32 noundef %649, i32 noundef %644, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4256), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6384)) #6
  br label %654

650:                                              ; preds = %640
  %651 = add nsw i32 %642, -4
  tail call void @gfx_blit_runs(i32 noundef %651, i32 noundef %644, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4456), i32 noundef 10, i32 noundef 10, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6448)) #6
  br label %654

652:                                              ; preds = %640
  %653 = add nsw i32 %642, -4
  tail call void @gfx_blit_runs(i32 noundef %653, i32 noundef 214, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 4656), i32 noundef 10, i32 noundef 12, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @arena_w, i32 6512)) #6
  br label %654

654:                                              ; preds = %652, %650, %648, %645, %636
  %655 = add nuw nsw i32 %634, 1
  br label %633, !llvm.loop !46

656:                                              ; preds = %633, %664
  %657 = phi i32 [ %665, %664 ], [ 0, %633 ]
  %658 = icmp eq i32 %657, 2
  br i1 %658, label %666, label %659

659:                                              ; preds = %656
  %660 = getelementptr inbounds nuw [2 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 104), i32 0, i32 %657
  %661 = load i32, ptr %660, align 4, !tbaa !6
  %662 = icmp eq i32 %661, -999
  br i1 %662, label %664, label %663

663:                                              ; preds = %659
  tail call fastcc void @heli_draw(i32 noundef %657, i32 noundef 0) #7
  br label %664

664:                                              ; preds = %659, %663
  %665 = add nuw nsw i32 %657, 1
  br label %656, !llvm.loop !47

666:                                              ; preds = %656, %681
  %667 = phi i32 [ %682, %681 ], [ 0, %656 ]
  %668 = icmp eq i32 %667, 4
  br i1 %668, label %669, label %672

669:                                              ; preds = %666
  %670 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 24), align 4, !tbaa !20
  %671 = icmp eq i32 %670, 0
  br i1 %671, label %684, label %683

672:                                              ; preds = %666
  %673 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %667
  %674 = load i32, ptr %673, align 4, !tbaa !6
  %675 = icmp eq i32 %674, -999
  br i1 %675, label %681, label %676

676:                                              ; preds = %672
  %677 = add nsw i32 %674, -1
  %678 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %667
  %679 = load i32, ptr %678, align 4, !tbaa !6
  %680 = add nsw i32 %679, -1
  tail call void @gfx_fill(i32 noundef %677, i32 noundef %680, i32 noundef 3, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %681

681:                                              ; preds = %672, %676
  %682 = add nuw nsw i32 %667, 1
  br label %666, !llvm.loop !48

683:                                              ; preds = %669
  tail call fastcc void @draw_gun() #7
  br label %684

684:                                              ; preds = %683, %669
  br label %685

685:                                              ; preds = %684, %695
  %686 = phi i32 [ %696, %695 ], [ 0, %684 ]
  %687 = icmp eq i32 %686, 12
  br i1 %687, label %697, label %688

688:                                              ; preds = %685
  %689 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %686
  %690 = load i32, ptr %689, align 4, !tbaa !6
  %691 = icmp eq i32 %690, -999
  br i1 %691, label %695, label %692

692:                                              ; preds = %688
  %693 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %686
  %694 = load i32, ptr %693, align 4, !tbaa !6
  tail call void @gfx_fill(i32 noundef %690, i32 noundef %694, i32 noundef 4, i32 noundef 3, i16 noundef zeroext 6371) #6
  br label %695

695:                                              ; preds = %688, %692
  %696 = add nuw nsw i32 %686, 1
  br label %685, !llvm.loop !49

697:                                              ; preds = %685, %713
  %698 = phi i32 [ %714, %713 ], [ 0, %685 ]
  %699 = icmp eq i32 %698, 3
  br i1 %699, label %715, label %700

700:                                              ; preds = %697
  %701 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 32), i32 0, i32 %698
  %702 = load i32, ptr %701, align 4, !tbaa !6
  %703 = icmp eq i32 %702, -999
  br i1 %703, label %713, label %704

704:                                              ; preds = %700
  %705 = getelementptr inbounds nuw [3 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 44), i32 0, i32 %698
  %706 = load i32, ptr %705, align 4, !tbaa !6
  %707 = add nsw i32 %702, -2
  %708 = add nsw i32 %706, -1
  tail call void @gfx_fill(i32 noundef %707, i32 noundef %708, i32 noundef 4, i32 noundef 2, i16 noundef zeroext 6371) #6
  %709 = add nsw i32 %702, -1
  %710 = add nsw i32 %706, -2
  tail call void @gfx_fill(i32 noundef %709, i32 noundef %710, i32 noundef 2, i32 noundef 4, i16 noundef zeroext 6371) #6
  %711 = add nsw i32 %702, 2
  %712 = add nsw i32 %706, 2
  tail call void @gfx_damage(i32 noundef %707, i32 noundef %710, i32 noundef %711, i32 noundef %712) #6
  br label %713

713:                                              ; preds = %700, %704
  %714 = add nuw nsw i32 %698, 1
  br label %697, !llvm.loop !50

715:                                              ; preds = %697, %729
  %716 = phi i32 [ %730, %729 ], [ 0, %697 ]
  %717 = icmp eq i32 %716, 4
  br i1 %717, label %731, label %718

718:                                              ; preds = %715
  %719 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 232), i32 0, i32 %716
  %720 = load i32, ptr %719, align 4, !tbaa !6
  %721 = icmp eq i32 %720, -999
  br i1 %721, label %729, label %722

722:                                              ; preds = %718
  %723 = add nsw i32 %720, -2
  %724 = getelementptr inbounds nuw [4 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 248), i32 0, i32 %716
  %725 = load i32, ptr %724, align 4, !tbaa !6
  %726 = add nsw i32 %725, -2
  %727 = add nsw i32 %720, 3
  %728 = add nsw i32 %725, 3
  tail call void @gfx_damage(i32 noundef %723, i32 noundef %726, i32 noundef %727, i32 noundef %728) #6
  br label %729

729:                                              ; preds = %718, %722
  %730 = add nuw nsw i32 %716, 1
  br label %715, !llvm.loop !51

731:                                              ; preds = %715, %747
  %732 = phi i32 [ %748, %747 ], [ 0, %715 ]
  %733 = icmp eq i32 %732, 12
  br i1 %733, label %734, label %736

734:                                              ; preds = %731
  %735 = icmp eq i32 %89, 0
  br i1 %735, label %749, label %753

736:                                              ; preds = %731
  %737 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 296), i32 0, i32 %732
  %738 = load i32, ptr %737, align 4, !tbaa !6
  %739 = icmp eq i32 %738, -999
  br i1 %739, label %747, label %740

740:                                              ; preds = %736
  %741 = add nsw i32 %738, -1
  %742 = getelementptr inbounds nuw [12 x i32], ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 344), i32 0, i32 %732
  %743 = load i32, ptr %742, align 4, !tbaa !6
  %744 = add nsw i32 %743, -1
  %745 = add nsw i32 %738, 5
  %746 = add nsw i32 %743, 4
  tail call void @gfx_damage(i32 noundef %741, i32 noundef %744, i32 noundef %745, i32 noundef %746) #6
  br label %747

747:                                              ; preds = %736, %740
  %748 = add nuw nsw i32 %732, 1
  br label %731, !llvm.loop !52

749:                                              ; preds = %734
  %750 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 4), align 4, !tbaa !16
  %751 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 20), align 4, !tbaa !53
  %752 = icmp eq i32 %750, %751
  br i1 %752, label %754, label %753

753:                                              ; preds = %749, %734
  tail call fastcc void @draw_score() #7
  br label %754

754:                                              ; preds = %753, %749
  %755 = load i32, ptr getelementptr inbounds nuw (i8, ptr @arena_w, i32 12), align 4, !tbaa !18
  %756 = icmp eq i32 %755, 0
  br i1 %756, label %758, label %757

757:                                              ; preds = %754
  tail call void @gfx_text2(i32 noundef 40, i32 noundef 104, ptr noundef nonnull @.str.6, i16 noundef zeroext -20286, i16 noundef zeroext -23083) #6
  tail call void @gfx_text(i32 noundef 48, i32 noundef 128, ptr noundef nonnull @.str.7, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  tail call void @gfx_text(i32 noundef 48, i32 noundef 140, ptr noundef nonnull @.str.8, i16 noundef zeroext 6371, i16 noundef zeroext -23083) #6
  br label %758

758:                                              ; preds = %757, %754
  br label %61, !llvm.loop !25

759:                                              ; preds = %86, %75
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
  %2 = getelementptr inbounds [13 x i8], ptr @mdx, i32 0, i32 %1
  %3 = load i8, ptr %2, align 1, !tbaa !31
  %4 = sext i8 %3 to i32
  %5 = add nsw i32 %4, 120
  %6 = getelementptr inbounds [13 x i8], ptr @mdy, i32 0, i32 %1
  %7 = load i8, ptr %6, align 1, !tbaa !31
  %8 = sext i8 %7 to i32
  %9 = sub nsw i32 212, %8
  %10 = add i32 %1, -7
  %11 = icmp ult i32 %10, 6
  %12 = sub nsw i32 0, %4
  %13 = select i1 %11, i32 %4, i32 %12
  %14 = select i1 %11, i32 1, i32 -1
  %15 = sub nsw i32 %13, %8
  %16 = sub nsw i32 0, %8
  br label %17

17:                                               ; preds = %26, %0
  %18 = phi i32 [ 212, %0 ], [ %35, %26 ]
  %19 = phi i32 [ %15, %0 ], [ %37, %26 ]
  %20 = phi i32 [ 120, %0 ], [ %32, %26 ]
  %21 = add nsw i32 %20, -1
  %22 = add nsw i32 %18, -1
  tail call void @gfx_fill(i32 noundef %21, i32 noundef %22, i32 noundef 3, i32 noundef 3, i16 noundef zeroext 6371) #6
  %23 = icmp eq i32 %20, %5
  %24 = icmp eq i32 %18, %9
  %25 = and i1 %24, %23
  br i1 %25, label %38, label %26

26:                                               ; preds = %17
  %27 = shl nsw i32 %19, 1
  %28 = icmp sgt i32 %27, %16
  %29 = select i1 %28, i32 %8, i32 0
  %30 = sub i32 %19, %29
  %31 = select i1 %28, i32 %14, i32 0
  %32 = add nsw i32 %31, %20
  %33 = icmp slt i32 %27, %13
  %34 = sext i1 %33 to i32
  %35 = add nsw i32 %18, %34
  %36 = select i1 %33, i32 %13, i32 0
  %37 = add nsw i32 %30, %36
  br label %17, !llvm.loop !59

38:                                               ; preds = %17
  tail call void @gfx_damage(i32 noundef 103, i32 noundef 195, i32 noundef 136, i32 noundef 225) #6
  ret void
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
  tail call void @gfx_fill(i32 noundef 103, i32 noundef 195, i32 noundef 34, i32 noundef 18, i16 noundef zeroext -23083) #6
  tail call void @gfx_damage(i32 noundef 103, i32 noundef 195, i32 noundef 136, i32 noundef 212) #6
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
!59 = distinct !{!59, !5}
!60 = distinct !{!60, !4, !5}
!61 = distinct !{!61, !4, !5}
!62 = distinct !{!62, !4, !5}
!63 = distinct !{!63, !4, !5}
