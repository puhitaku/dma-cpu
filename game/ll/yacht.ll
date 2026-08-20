; ModuleID = 'yacht.c'
source_filename = "yacht.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [14 x i8] c"yacht: start\0A\00", align 1
@scores = internal unnamed_addr global [12 x i32] zeroinitializer, align 4
@turn = internal unnamed_addr global i32 0, align 4
@.str.1 = private unnamed_addr constant [6 x i8] c"YACHT\00", align 1
@rolls_left = internal unnamed_addr global i32 0, align 4
@held = internal unnamed_addr global [5 x i32] zeroinitializer, align 4
@dice = internal unnamed_addr global [5 x i32] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [13 x i8] c"yacht: roll\0A\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"yacht: cat=\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c" score=\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"FINISHED\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"total\00", align 1
@.str.8 = private unnamed_addr constant [12 x i8] c"press: menu\00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"yacht: total=\00", align 1
@pips = internal unnamed_addr constant [7 x i16] [i16 0, i16 16, i16 257, i16 273, i16 325, i16 341, i16 365], align 2
@.str.10 = private unnamed_addr constant [5 x i8] c"ROLL\00", align 1
@catname = internal unnamed_addr constant [12 x ptr] [ptr @.str.11, ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.1], align 4
@.str.11 = private unnamed_addr constant [5 x i8] c"Aces\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"Twos\00", align 1
@.str.13 = private unnamed_addr constant [7 x i8] c"Threes\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"Fours\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"Fives\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"Sixes\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c"Choice\00", align 1
@.str.18 = private unnamed_addr constant [10 x i8] c"Four Kind\00", align 1
@.str.19 = private unnamed_addr constant [9 x i8] c"Full Hse\00", align 1
@.str.20 = private unnamed_addr constant [11 x i8] c"Little Str\00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c"Big Str\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"TOTAL\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @yacht_run() local_unnamed_addr #0 {
  %1 = alloca [4 x i8], align 1
  tail call void @uputs(ptr noundef nonnull @.str) #6
  br label %2

2:                                                ; preds = %7, %0
  %3 = phi i32 [ 0, %0 ], [ %9, %7 ]
  %4 = icmp eq i32 %3, 12
  br i1 %4, label %5, label %7

5:                                                ; preds = %2
  store i32 0, ptr @turn, align 4, !tbaa !3
  tail call void @gfx_clear(i16 noundef zeroext 2371) #6
  tail call void @gfx_text(i32 noundef 6, i32 noundef 4, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 2371) #6
  %6 = load i32, ptr @turn, align 4, !tbaa !3
  br label %10

7:                                                ; preds = %2
  %8 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %3
  store i32 -1, ptr %8, align 4, !tbaa !3
  %9 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !7

10:                                               ; preds = %180, %5
  %11 = phi i32 [ %181, %180 ], [ %6, %5 ]
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr @turn, align 4, !tbaa !3
  store i32 3, ptr @rolls_left, align 4, !tbaa !3
  br label %13

13:                                               ; preds = %16, %10
  %14 = phi i32 [ 0, %10 ], [ %18, %16 ]
  %15 = icmp eq i32 %14, 5
  br i1 %15, label %19, label %16

16:                                               ; preds = %13
  %17 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %14
  store i32 0, ptr %17, align 4, !tbaa !3
  %18 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !10

19:                                               ; preds = %13, %23
  %20 = phi i32 [ %25, %23 ], [ 0, %13 ]
  %21 = icmp eq i32 %20, 5
  br i1 %21, label %22, label %23

22:                                               ; preds = %19
  tail call fastcc void @roll_dice() #7
  br label %26

23:                                               ; preds = %19
  %24 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %20
  store i32 0, ptr %24, align 4, !tbaa !3
  %25 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !11

26:                                               ; preds = %26, %22
  %27 = phi i32 [ 0, %22 ], [ %31, %26 ]
  %28 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %27
  %29 = load i32, ptr %28, align 4, !tbaa !3
  %30 = icmp sgt i32 %29, -1
  %31 = add nuw nsw i32 %27, 1
  br i1 %30, label %26, label %32, !llvm.loop !12

32:                                               ; preds = %26, %36
  %33 = phi i32 [ %37, %36 ], [ 0, %26 ]
  %34 = icmp eq i32 %33, 5
  br i1 %34, label %35, label %36

35:                                               ; preds = %32
  tail call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %38

36:                                               ; preds = %32
  tail call fastcc void @draw_die(i32 noundef %33, i32 noundef 0) #7
  %37 = add nuw nsw i32 %33, 1
  br label %32, !llvm.loop !13

38:                                               ; preds = %42, %35
  %39 = phi i32 [ 0, %35 ], [ %43, %42 ]
  %40 = icmp eq i32 %39, 12
  br i1 %40, label %41, label %42

41:                                               ; preds = %38
  tail call fastcc void @draw_total() #7
  tail call void @gfx_present() #6
  br label %174

42:                                               ; preds = %38
  tail call fastcc void @draw_cat(i32 noundef %39, i32 noundef 0, i32 noundef 0) #7
  %43 = add nuw nsw i32 %39, 1
  br label %38, !llvm.loop !14

44:                                               ; preds = %115, %166
  %45 = phi i32 [ %167, %166 ], [ %116, %115 ]
  %46 = phi i32 [ %169, %166 ], [ %85, %115 ]
  br i1 %179, label %47, label %180

47:                                               ; preds = %44
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %48 = icmp eq i32 %45, 0
  %49 = load i32, ptr @in_edge, align 4, !tbaa !3
  br i1 %48, label %50, label %122

50:                                               ; preds = %47
  %51 = and i32 %49, 4
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %66, label %53

53:                                               ; preds = %50
  %54 = icmp eq i32 %46, 0
  %55 = add nsw i32 %46, -1
  %56 = select i1 %54, i32 5, i32 %55
  %57 = icmp eq i32 %46, 5
  br i1 %57, label %58, label %59

58:                                               ; preds = %53
  tail call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %60

59:                                               ; preds = %53
  tail call fastcc void @draw_die(i32 noundef %46, i32 noundef 0) #7
  br label %60

60:                                               ; preds = %59, %58
  %61 = icmp eq i32 %56, 5
  br i1 %61, label %62, label %63

62:                                               ; preds = %60
  tail call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %64

63:                                               ; preds = %60
  tail call fastcc void @draw_die(i32 noundef %56, i32 noundef 1) #7
  br label %64

64:                                               ; preds = %63, %62
  tail call void @gfx_present() #6
  %65 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %66

66:                                               ; preds = %64, %50
  %67 = phi i32 [ %65, %64 ], [ %49, %50 ]
  %68 = phi i32 [ %56, %64 ], [ %46, %50 ]
  %69 = and i32 %67, 8
  %70 = icmp eq i32 %69, 0
  br i1 %70, label %83, label %71

71:                                               ; preds = %66
  %72 = icmp eq i32 %68, 5
  %73 = add nsw i32 %68, 1
  %74 = select i1 %72, i32 0, i32 %73
  br i1 %72, label %75, label %76

75:                                               ; preds = %71
  tail call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %77

76:                                               ; preds = %71
  tail call fastcc void @draw_die(i32 noundef %68, i32 noundef 0) #7
  br label %77

77:                                               ; preds = %76, %75
  %78 = icmp eq i32 %74, 5
  br i1 %78, label %79, label %80

79:                                               ; preds = %77
  tail call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %81

80:                                               ; preds = %77
  tail call fastcc void @draw_die(i32 noundef %74, i32 noundef 1) #7
  br label %81

81:                                               ; preds = %80, %79
  tail call void @gfx_present() #6
  %82 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %83

83:                                               ; preds = %81, %66
  %84 = phi i32 [ %82, %81 ], [ %67, %66 ]
  %85 = phi i32 [ %74, %81 ], [ %68, %66 ]
  %86 = and i32 %84, 16
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %111, label %88

88:                                               ; preds = %83
  %89 = icmp slt i32 %85, 5
  br i1 %89, label %90, label %95

90:                                               ; preds = %88
  %91 = getelementptr inbounds [5 x i32], ptr @held, i32 0, i32 %85
  %92 = load i32, ptr %91, align 4, !tbaa !3
  %93 = icmp eq i32 %92, 0
  %94 = zext i1 %93 to i32
  store i32 %94, ptr %91, align 4, !tbaa !3
  tail call fastcc void @draw_die(i32 noundef %85, i32 noundef 1) #7
  tail call void @gfx_present() #6
  br label %111

95:                                               ; preds = %88
  %96 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %97 = icmp sgt i32 %96, 0
  br i1 %97, label %98, label %111

98:                                               ; preds = %95
  tail call fastcc void @roll_dice() #7
  br label %99

99:                                               ; preds = %103, %98
  %100 = phi i32 [ 0, %98 ], [ %104, %103 ]
  %101 = icmp eq i32 %100, 5
  br i1 %101, label %102, label %103

102:                                              ; preds = %99
  tail call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %105

103:                                              ; preds = %99
  tail call fastcc void @draw_die(i32 noundef %100, i32 noundef 0) #7
  %104 = add nuw nsw i32 %100, 1
  br label %99, !llvm.loop !15

105:                                              ; preds = %109, %102
  %106 = phi i32 [ 0, %102 ], [ %110, %109 ]
  %107 = icmp eq i32 %106, 12
  br i1 %107, label %108, label %109

108:                                              ; preds = %105
  tail call void @gfx_present() #6
  tail call void @uputs(ptr noundef nonnull @.str.2) #6
  br label %111

109:                                              ; preds = %105
  tail call fastcc void @draw_cat(i32 noundef %106, i32 noundef 0, i32 noundef 0) #7
  %110 = add nuw nsw i32 %106, 1
  br label %105, !llvm.loop !16

111:                                              ; preds = %90, %108, %95, %83
  %112 = load i32, ptr @in_edge, align 4, !tbaa !3
  %113 = and i32 %112, 3
  %114 = icmp eq i32 %113, 0
  br i1 %114, label %115, label %117

115:                                              ; preds = %111, %121
  %116 = phi i32 [ 1, %121 ], [ 0, %111 ]
  br label %44, !llvm.loop !17

117:                                              ; preds = %111
  %118 = icmp eq i32 %85, 5
  br i1 %118, label %119, label %120

119:                                              ; preds = %117
  tail call fastcc void @draw_roll_btn(i32 noundef 0) #7
  br label %121

120:                                              ; preds = %117
  tail call fastcc void @draw_die(i32 noundef %85, i32 noundef 0) #7
  br label %121

121:                                              ; preds = %120, %119
  tail call fastcc void @draw_cat(i32 noundef %168, i32 noundef 1, i32 noundef 1) #7
  tail call void @gfx_present() #6
  br label %115

122:                                              ; preds = %47
  %123 = and i32 %49, 12
  %124 = icmp eq i32 %123, 0
  br i1 %124, label %131, label %125

125:                                              ; preds = %122
  tail call fastcc void @draw_cat(i32 noundef %168, i32 noundef 0, i32 noundef 0) #7
  %126 = icmp eq i32 %46, 5
  br i1 %126, label %127, label %128

127:                                              ; preds = %125
  tail call fastcc void @draw_roll_btn(i32 noundef 1) #7
  br label %129

128:                                              ; preds = %125
  tail call fastcc void @draw_die(i32 noundef %46, i32 noundef 1) #7
  br label %129

129:                                              ; preds = %128, %127
  tail call void @gfx_present() #6
  %130 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %131

131:                                              ; preds = %129, %122
  %132 = phi i32 [ %130, %129 ], [ %49, %122 ]
  %133 = phi i32 [ 0, %129 ], [ 1, %122 ]
  %134 = and i32 %132, 1
  %135 = icmp eq i32 %134, 0
  br i1 %135, label %146, label %136

136:                                              ; preds = %131, %136
  %137 = phi i32 [ %140, %136 ], [ %168, %131 ]
  %138 = icmp eq i32 %137, 0
  %139 = add nsw i32 %137, -1
  %140 = select i1 %138, i32 11, i32 %139
  %141 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %140
  %142 = load i32, ptr %141, align 4, !tbaa !3
  %143 = icmp sgt i32 %142, -1
  br i1 %143, label %136, label %144, !llvm.loop !18

144:                                              ; preds = %136
  tail call fastcc void @draw_cat(i32 noundef %168, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @draw_cat(i32 noundef %140, i32 noundef 1, i32 noundef 1) #7
  tail call void @gfx_present() #6
  %145 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %146

146:                                              ; preds = %144, %131
  %147 = phi i32 [ %145, %144 ], [ %132, %131 ]
  %148 = phi i32 [ %140, %144 ], [ %168, %131 ]
  %149 = and i32 %147, 2
  %150 = icmp eq i32 %149, 0
  br i1 %150, label %161, label %151

151:                                              ; preds = %146, %151
  %152 = phi i32 [ %155, %151 ], [ %148, %146 ]
  %153 = icmp eq i32 %152, 11
  %154 = add nsw i32 %152, 1
  %155 = select i1 %153, i32 0, i32 %154
  %156 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %155
  %157 = load i32, ptr %156, align 4, !tbaa !3
  %158 = icmp sgt i32 %157, -1
  br i1 %158, label %151, label %159, !llvm.loop !19

159:                                              ; preds = %151
  tail call fastcc void @draw_cat(i32 noundef %148, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @draw_cat(i32 noundef %155, i32 noundef 1, i32 noundef 1) #7
  tail call void @gfx_present() #6
  %160 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %161

161:                                              ; preds = %159, %146
  %162 = phi i32 [ %160, %159 ], [ %147, %146 ]
  %163 = phi i32 [ %155, %159 ], [ %148, %146 ]
  %164 = and i32 %162, 16
  %165 = icmp eq i32 %164, 0
  br i1 %165, label %166, label %170, !llvm.loop !17

166:                                              ; preds = %174, %161
  %167 = phi i32 [ %133, %161 ], [ %175, %174 ]
  %168 = phi i32 [ %163, %161 ], [ %176, %174 ]
  %169 = phi i32 [ %46, %161 ], [ %178, %174 ]
  br label %44

170:                                              ; preds = %161
  %171 = tail call fastcc i32 @cat_score(i32 noundef %163) #7
  %172 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %163
  store i32 %171, ptr %172, align 4, !tbaa !3
  tail call void @uputs(ptr noundef nonnull @.str.3) #6
  tail call void @uputn(i32 noundef %163) #6
  tail call void @uputs(ptr noundef nonnull @.str.4) #6
  %173 = load i32, ptr %172, align 4, !tbaa !3
  tail call void @uputn(i32 noundef %173) #6
  tail call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %174, !llvm.loop !17

174:                                              ; preds = %41, %170
  %175 = phi i32 [ 0, %41 ], [ %133, %170 ]
  %176 = phi i32 [ %27, %41 ], [ %163, %170 ]
  %177 = phi i32 [ -1, %41 ], [ %163, %170 ]
  %178 = phi i32 [ 5, %41 ], [ %46, %170 ]
  %179 = icmp slt i32 %177, 0
  br label %166

180:                                              ; preds = %44
  tail call fastcc void @draw_cat(i32 noundef %177, i32 noundef 0, i32 noundef 0) #7
  tail call fastcc void @draw_total() #7
  tail call void @gfx_present() #6
  %181 = load i32, ptr @turn, align 4, !tbaa !3
  %182 = icmp eq i32 %181, 12
  br i1 %182, label %183, label %10

183:                                              ; preds = %180
  tail call void @gfx_fill(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i16 noundef zeroext 2532) #6
  tail call void @gfx_rect(i32 noundef 30, i32 noundef 96, i32 noundef 180, i32 noundef 52, i32 noundef 2, i16 noundef zeroext -377) #6
  tail call void @gfx_text2(i32 noundef 52, i32 noundef 104, ptr noundef nonnull @.str.6, i16 noundef zeroext -377, i16 noundef zeroext 2532) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #8
  %184 = tail call fastcc i32 @total() #7
  call void @numstr(ptr noundef nonnull %1, i32 noundef 3, i32 noundef %184) #6
  call void @gfx_text(i32 noundef 76, i32 noundef 124, ptr noundef nonnull @.str.7, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 124, i32 noundef 124, ptr noundef nonnull %1, i16 noundef zeroext -1, i16 noundef zeroext 2532) #6
  call void @gfx_text(i32 noundef 74, i32 noundef 136, ptr noundef nonnull @.str.8, i16 noundef zeroext -12615, i16 noundef zeroext 2532) #6
  call void @gfx_present() #6
  call void @uputs(ptr noundef nonnull @.str.9) #6
  %185 = call fastcc i32 @total() #7
  call void @uputn(i32 noundef %185) #6
  call void @uputs(ptr noundef nonnull @.str.5) #6
  br label %186

186:                                              ; preds = %186, %183
  call void @frame_sync(i32 noundef 33000) #6
  call void @in_poll() #6
  %187 = load i32, ptr @in_edge, align 4, !tbaa !3
  %188 = and i32 %187, 16
  %189 = icmp eq i32 %188, 0
  br i1 %189, label %186, label %190, !llvm.loop !20

190:                                              ; preds = %186
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @roll_dice() unnamed_addr #0 {
  br label %1

1:                                                ; preds = %15, %0
  %2 = phi i32 [ 0, %0 ], [ %16, %15 ]
  %3 = icmp eq i32 %2, 5
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %6 = add nsw i32 %5, -1
  store i32 %6, ptr @rolls_left, align 4, !tbaa !3
  ret void

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw [5 x i32], ptr @held, i32 0, i32 %2
  %9 = load i32, ptr %8, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %15

11:                                               ; preds = %7
  %12 = tail call i32 @rng_below(i32 noundef 6) #6
  %13 = add nsw i32 %12, 1
  %14 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %2
  store i32 %13, ptr %14, align 4, !tbaa !3
  br label %15

15:                                               ; preds = %7, %11
  %16 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !21
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_die(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = mul nsw i32 %0, 34
  %4 = add nsw i32 %3, 6
  %5 = add nsw i32 %3, 4
  tail call void @gfx_fill(i32 noundef %5, i32 noundef 16, i32 noundef 32, i32 noundef 40, i16 noundef zeroext 2371) #6
  tail call void @gfx_fill(i32 noundef %4, i32 noundef 18, i32 noundef 28, i32 noundef 28, i16 noundef zeroext -2115) #6
  tail call void @gfx_rect(i32 noundef %4, i32 noundef 18, i32 noundef 28, i32 noundef 28, i32 noundef 1, i16 noundef zeroext 4259) #6
  %6 = getelementptr inbounds [5 x i32], ptr @dice, i32 0, i32 %0
  %7 = load i32, ptr %6, align 4, !tbaa !3
  %8 = getelementptr inbounds [7 x i16], ptr @pips, i32 0, i32 %7
  %9 = load i16, ptr %8, align 2, !tbaa !22
  %10 = zext i16 %9 to i32
  %11 = add nsw i32 %3, 10
  br label %12

12:                                               ; preds = %35, %2
  %13 = phi i32 [ 0, %2 ], [ %36, %35 ]
  %14 = icmp eq i32 %13, 9
  br i1 %14, label %15, label %19

15:                                               ; preds = %12
  %16 = getelementptr inbounds [5 x i32], ptr @held, i32 0, i32 %0
  %17 = load i32, ptr %16, align 4, !tbaa !3
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %39, label %37

19:                                               ; preds = %12
  %20 = shl nuw nsw i32 1, %13
  %21 = and i32 %20, %10
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %35, label %23

23:                                               ; preds = %19
  %24 = trunc nuw i32 %13 to i8
  %25 = freeze i8 %24
  %26 = udiv i8 %25, 3
  %27 = mul i8 %26, 3
  %28 = sub i8 %25, %27
  %29 = shl nuw nsw i8 %28, 3
  %30 = zext nneg i8 %29 to i32
  %31 = add nsw i32 %11, %30
  %32 = shl nuw nsw i8 %26, 3
  %33 = add nuw nsw i8 %32, 22
  %34 = zext nneg i8 %33 to i32
  tail call void @gfx_fill(i32 noundef %31, i32 noundef %34, i32 noundef 4, i32 noundef 4, i16 noundef zeroext 4259) #6
  br label %35

35:                                               ; preds = %19, %23
  %36 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !24

37:                                               ; preds = %15
  %38 = add nsw i32 %3, 8
  tail call void @gfx_fill(i32 noundef %38, i32 noundef 49, i32 noundef 24, i32 noundef 4, i16 noundef zeroext -377) #6
  br label %39

39:                                               ; preds = %37, %15
  %40 = icmp eq i32 %1, 0
  br i1 %40, label %42, label %41

41:                                               ; preds = %39
  tail call void @gfx_rect(i32 noundef %5, i32 noundef 16, i32 noundef 32, i32 noundef 40, i32 noundef 2, i16 noundef zeroext -1337) #6
  br label %42

42:                                               ; preds = %41, %39
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_roll_btn(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = alloca [2 x i8], align 1
  tail call void @gfx_fill(i32 noundef 176, i32 noundef 16, i32 noundef 58, i32 noundef 40, i16 noundef zeroext 2371) #6
  %3 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i16 2371, i16 2532
  tail call void @gfx_fill(i32 noundef 178, i32 noundef 18, i32 noundef 54, i32 noundef 22, i16 noundef zeroext %5) #6
  %6 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %7, i16 27662, i16 -12615
  tail call void @gfx_rect(i32 noundef 178, i32 noundef 18, i32 noundef 54, i32 noundef 22, i32 noundef 1, i16 noundef zeroext %8) #6
  %9 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %10 = icmp eq i32 %9, 0
  %11 = select i1 %10, i16 27662, i16 -1
  %12 = select i1 %10, i16 2371, i16 2532
  tail call void @gfx_text(i32 noundef 189, i32 noundef 25, ptr noundef nonnull @.str.10, i16 noundef zeroext %11, i16 noundef zeroext %12) #6
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %2) #8
  %13 = load i32, ptr @rolls_left, align 4, !tbaa !3
  %14 = trunc i32 %13 to i8
  %15 = add i8 %14, 48
  store i8 %15, ptr %2, align 1, !tbaa !25
  %16 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 0, ptr %16, align 1, !tbaa !25
  call void @gfx_text(i32 noundef 202, i32 noundef 44, ptr noundef nonnull %2, i16 noundef zeroext 27662, i16 noundef zeroext 2371) #6
  %17 = icmp eq i32 %0, 0
  br i1 %17, label %19, label %18

18:                                               ; preds = %1
  call void @gfx_rect(i32 noundef 176, i32 noundef 16, i32 noundef 58, i32 noundef 40, i32 noundef 2, i16 noundef zeroext -1337) #6
  br label %19

19:                                               ; preds = %18, %1
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %2) #8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_cat(i32 noundef %0, i32 noundef range(i32 0, 2) %1, i32 noundef range(i32 0, 2) %2) unnamed_addr #0 {
  %4 = alloca [4 x i8], align 1
  %5 = mul nsw i32 %0, 12
  %6 = add nsw i32 %5, 66
  %7 = add nsw i32 %5, 65
  %8 = icmp eq i32 %1, 0
  %9 = select i1 %8, i16 2371, i16 2532
  tail call void @gfx_fill(i32 noundef 4, i32 noundef %7, i32 noundef 232, i32 noundef 11, i16 noundef zeroext %9) #6
  %10 = getelementptr inbounds [12 x ptr], ptr @catname, i32 0, i32 %0
  %11 = load ptr, ptr %10, align 4, !tbaa !26
  %12 = getelementptr inbounds [12 x i32], ptr @scores, i32 0, i32 %0
  %13 = load i32, ptr %12, align 4, !tbaa !3
  %14 = icmp sgt i32 %13, -1
  %15 = select i1 %14, i16 27662, i16 -12615
  tail call void @gfx_text(i32 noundef 10, i32 noundef %6, ptr noundef %11, i16 noundef zeroext %15, i16 noundef zeroext %9) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #8
  %16 = load i32, ptr %12, align 4, !tbaa !3
  %17 = icmp sgt i32 %16, -1
  br i1 %17, label %25, label %18

18:                                               ; preds = %3
  %19 = icmp ne i32 %2, 0
  %20 = load i32, ptr @rolls_left, align 4
  %21 = icmp slt i32 %20, 3
  %22 = select i1 %19, i1 %21, i1 false
  br i1 %22, label %23, label %28

23:                                               ; preds = %18
  %24 = tail call fastcc i32 @cat_score(i32 noundef %0) #7
  br label %25

25:                                               ; preds = %3, %23
  %26 = phi i32 [ %24, %23 ], [ %16, %3 ]
  %27 = phi i16 [ 32500, %23 ], [ -1, %3 ]
  call void @numstr(ptr noundef nonnull %4, i32 noundef 3, i32 noundef %26) #6
  call void @gfx_text(i32 noundef 200, i32 noundef %6, ptr noundef nonnull %4, i16 noundef zeroext %27, i16 noundef zeroext %9) #6
  br label %28

28:                                               ; preds = %25, %18
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #8
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_total() unnamed_addr #0 {
  %1 = alloca [4 x i8], align 1
  tail call void @gfx_fill(i32 noundef 4, i32 noundef 212, i32 noundef 232, i32 noundef 20, i16 noundef zeroext 2371) #6
  tail call void @gfx_text(i32 noundef 10, i32 noundef 218, ptr noundef nonnull @.str.22, i16 noundef zeroext -12615, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #8
  %2 = tail call fastcc i32 @total() #7
  call void @numstr(ptr noundef nonnull %1, i32 noundef 3, i32 noundef %2) #6
  call void @gfx_text(i32 noundef 200, i32 noundef 218, ptr noundef nonnull %1, i16 noundef zeroext -1, i16 noundef zeroext 2371) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #8
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc i32 @cat_score(i32 noundef %0) unnamed_addr #3 {
  %2 = alloca [7 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 28, ptr nonnull %2) #8
  call void @llvm.memset.p0.i32(ptr noundef nonnull align 4 dereferenceable(28) %2, i8 0, i32 28, i1 false)
  br label %3

3:                                                ; preds = %15, %1
  %4 = phi i32 [ 0, %1 ], [ %21, %15 ]
  %5 = phi i32 [ 0, %1 ], [ %22, %15 ]
  %6 = icmp eq i32 %5, 5
  br i1 %6, label %7, label %15

7:                                                ; preds = %3
  %8 = icmp slt i32 %0, 6
  br i1 %8, label %9, label %23

9:                                                ; preds = %7
  %10 = add nsw i32 %0, 1
  %11 = getelementptr inbounds [7 x i32], ptr %2, i32 0, i32 %10
  %12 = load i32, ptr %11, align 4, !tbaa !3
  %13 = tail call i32 @llvm.smax.i32(i32 %12, i32 0)
  %14 = mul i32 %13, %10
  br label %78

15:                                               ; preds = %3
  %16 = getelementptr inbounds nuw [5 x i32], ptr @dice, i32 0, i32 %5
  %17 = load i32, ptr %16, align 4, !tbaa !3
  %18 = getelementptr inbounds [7 x i32], ptr %2, i32 0, i32 %17
  %19 = load i32, ptr %18, align 4, !tbaa !3
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr %18, align 4, !tbaa !3
  %21 = add nsw i32 %17, %4
  %22 = add nuw nsw i32 %5, 1
  br label %3, !llvm.loop !29

23:                                               ; preds = %7
  switch i32 %0, label %70 [
    i32 6, label %78
    i32 7, label %24
    i32 8, label %35
    i32 9, label %54
    i32 10, label %62
  ]

24:                                               ; preds = %23, %33
  %25 = phi i32 [ %34, %33 ], [ 1, %23 ]
  %26 = icmp eq i32 %25, 7
  br i1 %26, label %78, label %27

27:                                               ; preds = %24
  %28 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %25
  %29 = load i32, ptr %28, align 4, !tbaa !3
  %30 = icmp sgt i32 %29, 3
  br i1 %30, label %31, label %33

31:                                               ; preds = %27
  %32 = shl nuw nsw i32 %25, 2
  br label %78

33:                                               ; preds = %27
  %34 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !30

35:                                               ; preds = %23, %50
  %36 = phi i32 [ %51, %50 ], [ 0, %23 ]
  %37 = phi i32 [ %52, %50 ], [ 0, %23 ]
  %38 = phi i32 [ %53, %50 ], [ 1, %23 ]
  %39 = icmp eq i32 %38, 7
  br i1 %39, label %40, label %45

40:                                               ; preds = %35
  %41 = icmp ne i32 %36, 0
  %42 = icmp ne i32 %37, 0
  %43 = select i1 %41, i1 %42, i1 false
  %44 = select i1 %43, i32 %4, i32 0
  br label %78

45:                                               ; preds = %35
  %46 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %38
  %47 = load i32, ptr %46, align 4, !tbaa !3
  switch i32 %47, label %49 [
    i32 3, label %50
    i32 2, label %48
  ]

48:                                               ; preds = %45
  br label %50

49:                                               ; preds = %45
  br label %50

50:                                               ; preds = %45, %49, %48
  %51 = phi i32 [ %36, %48 ], [ 1, %45 ], [ %36, %49 ]
  %52 = phi i32 [ 1, %48 ], [ %37, %45 ], [ %37, %49 ]
  %53 = add nuw nsw i32 %38, 1
  br label %35, !llvm.loop !31

54:                                               ; preds = %23, %57
  %55 = phi i32 [ %61, %57 ], [ 1, %23 ]
  %56 = icmp eq i32 %55, 6
  br i1 %56, label %78, label %57

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %55
  %59 = load i32, ptr %58, align 4, !tbaa !3
  %60 = icmp eq i32 %59, 1
  %61 = add nuw nsw i32 %55, 1
  br i1 %60, label %54, label %78, !llvm.loop !32

62:                                               ; preds = %23, %65
  %63 = phi i32 [ %69, %65 ], [ 2, %23 ]
  %64 = icmp eq i32 %63, 7
  br i1 %64, label %78, label %65

65:                                               ; preds = %62
  %66 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %63
  %67 = load i32, ptr %66, align 4, !tbaa !3
  %68 = icmp eq i32 %67, 1
  %69 = add nuw nsw i32 %63, 1
  br i1 %68, label %62, label %78, !llvm.loop !33

70:                                               ; preds = %23, %73
  %71 = phi i32 [ %77, %73 ], [ 1, %23 ]
  %72 = icmp eq i32 %71, 7
  br i1 %72, label %78, label %73

73:                                               ; preds = %70
  %74 = getelementptr inbounds nuw [7 x i32], ptr %2, i32 0, i32 %71
  %75 = load i32, ptr %74, align 4, !tbaa !3
  %76 = icmp eq i32 %75, 5
  %77 = add nuw nsw i32 %71, 1
  br i1 %76, label %78, label %70, !llvm.loop !34

78:                                               ; preds = %62, %65, %54, %57, %24, %70, %73, %9, %31, %23, %40
  %79 = phi i32 [ %44, %40 ], [ %4, %23 ], [ %32, %31 ], [ %14, %9 ], [ 0, %70 ], [ 50, %73 ], [ 0, %24 ], [ 30, %54 ], [ 0, %57 ], [ 30, %62 ], [ 0, %65 ]
  call void @llvm.lifetime.end.p0(i64 28, ptr nonnull %2) #8
  ret i32 %79
}

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc range(i32 0, -2147483648) i32 @total() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %6, %0
  %2 = phi i32 [ 0, %0 ], [ %10, %6 ]
  %3 = phi i32 [ 0, %0 ], [ %11, %6 ]
  %4 = icmp eq i32 %3, 12
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  ret i32 %2

6:                                                ; preds = %1
  %7 = getelementptr inbounds nuw [12 x i32], ptr @scores, i32 0, i32 %3
  %8 = load i32, ptr %7, align 4, !tbaa !3
  %9 = tail call i32 @llvm.smax.i32(i32 %8, i32 0)
  %10 = add nuw nsw i32 %9, %2
  %11 = add nuw nsw i32 %3, 1
  br label %1, !llvm.loop !35
}

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i32(ptr writeonly captures(none), i8, i32, i1 immarg) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #5

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { minsize nobuiltin optsize "no-builtins" }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8, !9}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !8, !9}
!11 = distinct !{!11, !8, !9}
!12 = distinct !{!12, !8, !9}
!13 = distinct !{!13, !8, !9}
!14 = distinct !{!14, !8, !9}
!15 = distinct !{!15, !8, !9}
!16 = distinct !{!16, !8, !9}
!17 = distinct !{!17, !8, !9}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !9}
!21 = distinct !{!21, !8, !9}
!22 = !{!23, !23, i64 0}
!23 = !{!"short", !5, i64 0}
!24 = distinct !{!24, !8, !9}
!25 = !{!5, !5, i64 0}
!26 = !{!27, !27, i64 0}
!27 = !{!"p1 omnipotent char", !28, i64 0}
!28 = !{!"any pointer", !5, i64 0}
!29 = distinct !{!29, !8, !9}
!30 = distinct !{!30, !8, !9}
!31 = distinct !{!31, !8, !9}
!32 = distinct !{!32, !8, !9}
!33 = distinct !{!33, !8, !9}
!34 = distinct !{!34, !8, !9}
!35 = distinct !{!35, !8, !9}
