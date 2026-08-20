; ModuleID = 'lanwalk.c'
source_filename = "lanwalk.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [16 x i8] c"lanwalk: start\0A\00", align 1
@mask = dso_local local_unnamed_addr global [49 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"hold press: quit\00", align 1
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [15 x i8] c"lanwalk: quit\0A\00", align 1
@lit = internal unnamed_addr global [49 x i8] zeroinitializer, align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"CONNECTED\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"press: menu\00", align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"lanwalk: solved moves=\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@stack = internal unnamed_addr global [49 x i8] zeroinitializer, align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"moves\00", align 1
@dr = internal unnamed_addr constant [4 x i8] c"\FF\00\01\00", align 1
@dc = internal unnamed_addr constant [4 x i8] c"\00\01\00\FF", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @lanwalk_run() local_unnamed_addr #0 {
  %1 = alloca [4 x i32], align 4
  %2 = alloca [49 x i8], align 1
  tail call void @uputs(ptr noundef nonnull @.str) #6
  br label %3

3:                                                ; preds = %7, %0
  %4 = phi i32 [ 0, %0 ], [ %10, %7 ]
  %5 = icmp eq i32 %4, 49
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  store i8 24, ptr @stack, align 1, !tbaa !3
  store i8 1, ptr getelementptr inbounds nuw (i8, ptr @lit, i32 24), align 1, !tbaa !3
  br label %11

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw [49 x i8], ptr @mask, i32 0, i32 %4
  store i8 0, ptr %8, align 1, !tbaa !3
  %9 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %4
  store i8 0, ptr %9, align 1, !tbaa !3
  %10 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !6

11:                                               ; preds = %59, %6
  %12 = phi i32 [ 1, %6 ], [ %60, %59 ]
  %13 = icmp sgt i32 %12, 0
  br i1 %13, label %14, label %61

14:                                               ; preds = %11
  %15 = add nsw i32 %12, -1
  %16 = getelementptr inbounds nuw [49 x i8], ptr @stack, i32 0, i32 %15
  %17 = load i8, ptr %16, align 1, !tbaa !3
  %18 = zext i8 %17 to i32
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %1) #7
  br label %19

19:                                               ; preds = %35, %14
  %20 = phi i32 [ 0, %14 ], [ %37, %35 ]
  %21 = phi i32 [ 0, %14 ], [ %36, %35 ]
  %22 = icmp eq i32 %20, 4
  br i1 %22, label %23, label %25

23:                                               ; preds = %19
  %24 = icmp eq i32 %21, 0
  br i1 %24, label %59, label %38, !llvm.loop !9

25:                                               ; preds = %19
  %26 = tail call fastcc i32 @neigh(i32 noundef %18, i32 noundef %20) #8
  %27 = icmp sgt i32 %26, -1
  br i1 %27, label %28, label %35

28:                                               ; preds = %25
  %29 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %26
  %30 = load i8, ptr %29, align 1, !tbaa !3
  %31 = icmp eq i8 %30, 0
  br i1 %31, label %32, label %35

32:                                               ; preds = %28
  %33 = add nsw i32 %21, 1
  %34 = getelementptr inbounds [4 x i32], ptr %1, i32 0, i32 %21
  store i32 %20, ptr %34, align 4, !tbaa !10
  br label %35

35:                                               ; preds = %32, %28, %25
  %36 = phi i32 [ %21, %28 ], [ %33, %32 ], [ %21, %25 ]
  %37 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !12

38:                                               ; preds = %23
  %39 = tail call i32 @rng_below(i32 noundef %21) #6
  %40 = getelementptr inbounds nuw [4 x i32], ptr %1, i32 0, i32 %39
  %41 = load i32, ptr %40, align 4, !tbaa !10
  %42 = tail call fastcc i32 @neigh(i32 noundef %18, i32 noundef %41) #8
  %43 = shl nuw i32 1, %41
  %44 = getelementptr inbounds nuw [49 x i8], ptr @mask, i32 0, i32 %18
  %45 = load i8, ptr %44, align 1, !tbaa !3
  %46 = trunc i32 %43 to i8
  %47 = or i8 %45, %46
  store i8 %47, ptr %44, align 1, !tbaa !3
  %48 = and i32 %41, 3
  %49 = xor i32 %48, 2
  %50 = shl nuw nsw i32 1, %49
  %51 = getelementptr inbounds [49 x i8], ptr @mask, i32 0, i32 %42
  %52 = load i8, ptr %51, align 1, !tbaa !3
  %53 = trunc nuw nsw i32 %50 to i8
  %54 = or i8 %52, %53
  store i8 %54, ptr %51, align 1, !tbaa !3
  %55 = getelementptr inbounds [49 x i8], ptr @lit, i32 0, i32 %42
  store i8 1, ptr %55, align 1, !tbaa !3
  %56 = trunc nsw i32 %42 to i8
  %57 = add nuw nsw i32 %12, 1
  %58 = getelementptr inbounds nuw [49 x i8], ptr @stack, i32 0, i32 %12
  store i8 %56, ptr %58, align 1, !tbaa !3
  br label %59

59:                                               ; preds = %38, %23
  %60 = phi i32 [ %57, %38 ], [ %15, %23 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %1) #7
  br label %11

61:                                               ; preds = %11, %80
  %62 = phi i32 [ %82, %80 ], [ 0, %11 ]
  %63 = icmp eq i32 %62, 49
  br i1 %63, label %83, label %64

64:                                               ; preds = %61
  %65 = getelementptr inbounds nuw [49 x i8], ptr @mask, i32 0, i32 %62
  %66 = load i8, ptr %65, align 1, !tbaa !3
  %67 = zext i8 %66 to i32
  %68 = tail call i32 @rng() #6
  %69 = and i32 %68, 3
  br label %70

70:                                               ; preds = %74, %64
  %71 = phi i32 [ %67, %64 ], [ %79, %74 ]
  %72 = phi i32 [ %69, %64 ], [ %75, %74 ]
  %73 = icmp eq i32 %72, 0
  br i1 %73, label %80, label %74

74:                                               ; preds = %70
  %75 = add nsw i32 %72, -1
  %76 = shl nuw nsw i32 %71, 1
  %77 = lshr i32 %71, 3
  %78 = or i32 %76, %77
  %79 = and i32 %78, 15
  br label %70, !llvm.loop !13

80:                                               ; preds = %70
  %81 = trunc nuw i32 %71 to i8
  store i8 %81, ptr %65, align 1, !tbaa !3
  %82 = add nuw nsw i32 %62, 1
  br label %61, !llvm.loop !14

83:                                               ; preds = %61
  tail call fastcc void @relight() #8
  %84 = tail call fastcc i32 @all_lit() #8
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %92, label %86

86:                                               ; preds = %83
  %87 = load i8, ptr @mask, align 1, !tbaa !3
  %88 = shl i8 %87, 1
  %89 = lshr i8 %87, 3
  %90 = or i8 %88, %89
  %91 = and i8 %90, 15
  store i8 %91, ptr @mask, align 1, !tbaa !3
  tail call fastcc void @relight() #8
  br label %92

92:                                               ; preds = %86, %83
  tail call void @gfx_clear(i16 noundef zeroext 2148) #6
  br label %93

93:                                               ; preds = %101, %92
  %94 = phi i32 [ 0, %92 ], [ %104, %101 ]
  %95 = icmp eq i32 %94, 49
  br i1 %95, label %96, label %101

96:                                               ; preds = %93
  tail call void @gfx_text(i32 noundef 111, i32 noundef 222, ptr noundef nonnull @.str.1, i16 noundef zeroext -21063, i16 noundef zeroext 2148) #6
  tail call fastcc void @draw_moves(i32 noundef 0) #8
  tail call void @gfx_present() #6
  br label %97

97:                                               ; preds = %197, %96
  %98 = phi i32 [ %175, %197 ], [ 0, %96 ]
  %99 = phi i32 [ %148, %197 ], [ 0, %96 ]
  %100 = phi i32 [ %140, %197 ], [ 24, %96 ]
  br label %105

101:                                              ; preds = %93
  %102 = icmp eq i32 %94, 24
  %103 = zext i1 %102 to i32
  tail call fastcc void @draw_tile(i32 noundef %94, i32 noundef %103) #8
  %104 = add nuw nsw i32 %94, 1
  br label %93, !llvm.loop !15

105:                                              ; preds = %97, %151
  %106 = phi i32 [ %148, %151 ], [ %99, %97 ]
  %107 = phi i32 [ %140, %151 ], [ %100, %97 ]
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %108 = load i32, ptr @in_edge, align 4, !tbaa !10
  %109 = and i32 %108, 1
  %110 = icmp eq i32 %109, 0
  br i1 %110, label %115, label %111

111:                                              ; preds = %105
  %112 = tail call fastcc i32 @neigh(i32 noundef %107, i32 noundef 0) #8
  %113 = icmp slt i32 %112, 0
  %114 = select i1 %113, i32 %107, i32 %112
  br label %115

115:                                              ; preds = %111, %105
  %116 = phi i32 [ %107, %105 ], [ %114, %111 ]
  %117 = and i32 %108, 8
  %118 = icmp eq i32 %117, 0
  br i1 %118, label %123, label %119

119:                                              ; preds = %115
  %120 = tail call fastcc i32 @neigh(i32 noundef %116, i32 noundef 1) #8
  %121 = icmp slt i32 %120, 0
  %122 = select i1 %121, i32 %116, i32 %120
  br label %123

123:                                              ; preds = %119, %115
  %124 = phi i32 [ %116, %115 ], [ %122, %119 ]
  %125 = and i32 %108, 2
  %126 = icmp eq i32 %125, 0
  br i1 %126, label %131, label %127

127:                                              ; preds = %123
  %128 = tail call fastcc i32 @neigh(i32 noundef %124, i32 noundef 2) #8
  %129 = icmp slt i32 %128, 0
  %130 = select i1 %129, i32 %124, i32 %128
  br label %131

131:                                              ; preds = %127, %123
  %132 = phi i32 [ %124, %123 ], [ %130, %127 ]
  %133 = and i32 %108, 4
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %139, label %135

135:                                              ; preds = %131
  %136 = tail call fastcc i32 @neigh(i32 noundef %132, i32 noundef 3) #8
  %137 = icmp slt i32 %136, 0
  %138 = select i1 %137, i32 %132, i32 %136
  br label %139

139:                                              ; preds = %135, %131
  %140 = phi i32 [ %132, %131 ], [ %138, %135 ]
  %141 = icmp eq i32 %140, %107
  br i1 %141, label %143, label %142

142:                                              ; preds = %139
  tail call fastcc void @draw_tile(i32 noundef %107, i32 noundef 0) #8
  tail call fastcc void @draw_tile(i32 noundef %140, i32 noundef 1) #8
  tail call void @gfx_present() #6
  br label %143

143:                                              ; preds = %142, %139
  %144 = load i32, ptr @in_down, align 4, !tbaa !10
  %145 = and i32 %144, 16
  %146 = icmp eq i32 %145, 0
  %147 = add i32 %106, 1
  %148 = select i1 %146, i32 0, i32 %147
  %149 = icmp ugt i32 %148, 45
  br i1 %149, label %150, label %151

150:                                              ; preds = %143
  tail call void @uputs(ptr noundef nonnull @.str.2) #6
  br label %198

151:                                              ; preds = %143
  %152 = load i32, ptr @in_edge, align 4, !tbaa !10
  %153 = and i32 %152, 16
  %154 = icmp eq i32 %153, 0
  br i1 %154, label %105, label %155, !llvm.loop !16

155:                                              ; preds = %151
  %156 = getelementptr inbounds [49 x i8], ptr @mask, i32 0, i32 %140
  %157 = load i8, ptr %156, align 1, !tbaa !3
  %158 = shl i8 %157, 1
  %159 = lshr i8 %157, 3
  %160 = or i8 %158, %159
  %161 = and i8 %160, 15
  store i8 %161, ptr %156, align 1, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 49, ptr nonnull %2) #7
  br label %162

162:                                              ; preds = %166, %155
  %163 = phi i32 [ 0, %155 ], [ %170, %166 ]
  %164 = icmp eq i32 %163, 49
  br i1 %164, label %165, label %166

165:                                              ; preds = %162
  tail call fastcc void @relight() #8
  br label %171

166:                                              ; preds = %162
  %167 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %163
  %168 = load i8, ptr %167, align 1, !tbaa !3
  %169 = getelementptr inbounds nuw [49 x i8], ptr %2, i32 0, i32 %163
  store i8 %168, ptr %169, align 1, !tbaa !3
  %170 = add nuw nsw i32 %163, 1
  br label %162, !llvm.loop !17

171:                                              ; preds = %189, %165
  %172 = phi i32 [ 0, %165 ], [ %190, %189 ]
  %173 = icmp eq i32 %172, 49
  br i1 %173, label %174, label %178

174:                                              ; preds = %171
  %175 = add i32 %98, 1
  tail call fastcc void @draw_moves(i32 noundef %175) #8
  tail call void @gfx_present() #6
  %176 = tail call fastcc i32 @all_lit() #8
  %177 = icmp eq i32 %176, 0
  br i1 %177, label %197, label %191

178:                                              ; preds = %171
  %179 = getelementptr inbounds nuw [49 x i8], ptr %2, i32 0, i32 %172
  %180 = load i8, ptr %179, align 1, !tbaa !3
  %181 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %172
  %182 = load i8, ptr %181, align 1, !tbaa !3
  %183 = icmp eq i8 %180, %182
  br i1 %183, label %184, label %186

184:                                              ; preds = %178
  %185 = icmp eq i32 %172, %140
  br i1 %185, label %186, label %189

186:                                              ; preds = %184, %178
  %187 = icmp eq i32 %172, %140
  %188 = zext i1 %187 to i32
  tail call fastcc void @draw_tile(i32 noundef %172, i32 noundef %188) #8
  br label %189

189:                                              ; preds = %184, %186
  %190 = add nuw nsw i32 %172, 1
  br label %171, !llvm.loop !18

191:                                              ; preds = %174
  tail call void @gfx_fill(i32 noundef 30, i32 noundef 100, i32 noundef 180, i32 noundef 44, i16 noundef zeroext 2148) #6
  tail call void @gfx_rect(i32 noundef 30, i32 noundef 100, i32 noundef 180, i32 noundef 44, i32 noundef 2, i16 noundef zeroext 16175) #6
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 108, ptr noundef nonnull @.str.3, i16 noundef zeroext 16175, i16 noundef zeroext 2148) #6
  tail call void @gfx_text(i32 noundef 74, i32 noundef 128, ptr noundef nonnull @.str.4, i16 noundef zeroext -21063, i16 noundef zeroext 2148) #6
  tail call void @gfx_present() #6
  tail call void @uputs(ptr noundef nonnull @.str.5) #6
  tail call void @uputn(i32 noundef %175) #6
  tail call void @uputs(ptr noundef nonnull @.str.6) #6
  br label %192

192:                                              ; preds = %192, %191
  tail call void @frame_sync(i32 noundef 33000) #6
  tail call void @in_poll() #6
  %193 = load i32, ptr @in_edge, align 4, !tbaa !10
  %194 = and i32 %193, 16
  %195 = icmp eq i32 %194, 0
  br i1 %195, label %192, label %196, !llvm.loop !19

196:                                              ; preds = %192
  call void @llvm.lifetime.end.p0(i64 49, ptr nonnull %2) #7
  br label %198

197:                                              ; preds = %174
  call void @llvm.lifetime.end.p0(i64 49, ptr nonnull %2) #7
  br label %97, !llvm.loop !16

198:                                              ; preds = %150, %196
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @relight() unnamed_addr #2 {
  br label %1

1:                                                ; preds = %5, %0
  %2 = phi i32 [ 0, %0 ], [ %7, %5 ]
  %3 = icmp eq i32 %2, 49
  br i1 %3, label %4, label %5

4:                                                ; preds = %1
  store i8 24, ptr @stack, align 1, !tbaa !3
  store i8 1, ptr getelementptr inbounds nuw (i8, ptr @lit, i32 24), align 1, !tbaa !3
  br label %8

5:                                                ; preds = %1
  %6 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %2
  store i8 0, ptr %6, align 1, !tbaa !3
  %7 = add nuw nsw i32 %2, 1
  br label %1, !llvm.loop !20

8:                                                ; preds = %17, %4
  %9 = phi i32 [ 1, %4 ], [ %18, %17 ]
  %10 = icmp sgt i32 %9, 0
  br i1 %10, label %11, label %49

11:                                               ; preds = %8
  %12 = add nsw i32 %9, -1
  %13 = getelementptr inbounds nuw [49 x i8], ptr @stack, i32 0, i32 %12
  %14 = load i8, ptr %13, align 1, !tbaa !3
  %15 = zext i8 %14 to i32
  %16 = getelementptr inbounds nuw [49 x i8], ptr @mask, i32 0, i32 %15
  br label %17

17:                                               ; preds = %46, %11
  %18 = phi i32 [ %12, %11 ], [ %47, %46 ]
  %19 = phi i32 [ 0, %11 ], [ %48, %46 ]
  %20 = icmp eq i32 %19, 4
  br i1 %20, label %8, label %21, !llvm.loop !21

21:                                               ; preds = %17
  %22 = tail call fastcc i32 @neigh(i32 noundef %15, i32 noundef %19) #8
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %46, label %24

24:                                               ; preds = %21
  %25 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %22
  %26 = load i8, ptr %25, align 1, !tbaa !3
  %27 = icmp eq i8 %26, 0
  br i1 %27, label %28, label %46

28:                                               ; preds = %24
  %29 = load i8, ptr %16, align 1, !tbaa !3
  %30 = zext i8 %29 to i32
  %31 = shl nuw nsw i32 1, %19
  %32 = and i32 %31, %30
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %46, label %34

34:                                               ; preds = %28
  %35 = getelementptr inbounds nuw [49 x i8], ptr @mask, i32 0, i32 %22
  %36 = load i8, ptr %35, align 1, !tbaa !3
  %37 = zext i8 %36 to i32
  %38 = xor i32 %19, 2
  %39 = shl nuw nsw i32 1, %38
  %40 = and i32 %39, %37
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %46, label %42

42:                                               ; preds = %34
  store i8 1, ptr %25, align 1, !tbaa !3
  %43 = trunc nuw nsw i32 %22 to i8
  %44 = add nsw i32 %18, 1
  %45 = getelementptr inbounds [49 x i8], ptr @stack, i32 0, i32 %18
  store i8 %43, ptr %45, align 1, !tbaa !3
  br label %46

46:                                               ; preds = %28, %34, %42, %21, %24
  %47 = phi i32 [ %18, %24 ], [ %18, %21 ], [ %44, %42 ], [ %18, %34 ], [ %18, %28 ]
  %48 = add nuw nsw i32 %19, 1
  br label %17, !llvm.loop !22

49:                                               ; preds = %8
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none)
define internal fastcc range(i32 0, 2) i32 @all_lit() unnamed_addr #3 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i32 [ 0, %0 ], [ %8, %4 ]
  %3 = icmp eq i32 %2, 49
  br i1 %3, label %9, label %4

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw [49 x i8], ptr @lit, i32 0, i32 %2
  %6 = load i8, ptr %5, align 1, !tbaa !3
  %7 = icmp eq i8 %6, 0
  %8 = add nuw nsw i32 %2, 1
  br i1 %7, label %9, label %1, !llvm.loop !23

9:                                                ; preds = %4, %1
  %10 = icmp samesign ugt i32 %2, 48
  %11 = zext i1 %10 to i32
  ret i32 %11
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_tile(i32 noundef range(i32 -2147483648, 49) %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = sdiv i32 %0, 7
  %4 = mul i32 %3, 7
  %5 = sub i32 %0, %4
  %6 = mul nsw i32 %5, 30
  %7 = add nsw i32 %6, 15
  %8 = mul nsw i32 %3, 30
  %9 = add nsw i32 %8, 8
  tail call void @gfx_fill(i32 noundef %7, i32 noundef %9, i32 noundef 30, i32 noundef 30, i16 noundef zeroext 2148) #6
  tail call void @gfx_rect(i32 noundef %7, i32 noundef %9, i32 noundef 30, i32 noundef 30, i32 noundef 1, i16 noundef zeroext 6440) #6
  %10 = getelementptr inbounds [49 x i8], ptr @mask, i32 0, i32 %0
  %11 = load i8, ptr %10, align 1, !tbaa !3
  %12 = zext i8 %11 to i32
  %13 = getelementptr inbounds [49 x i8], ptr @lit, i32 0, i32 %0
  %14 = load i8, ptr %13, align 1, !tbaa !3
  %15 = icmp eq i8 %14, 0
  %16 = select i1 %15, i16 27536, i16 16175
  %17 = and i32 %12, 1
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %21, label %19

19:                                               ; preds = %2
  %20 = add nsw i32 %6, 28
  tail call void @gfx_fill(i32 noundef %20, i32 noundef %9, i32 noundef 4, i32 noundef 17, i16 noundef zeroext %16) #6
  br label %21

21:                                               ; preds = %19, %2
  %22 = and i32 %12, 2
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %27, label %24

24:                                               ; preds = %21
  %25 = add nsw i32 %6, 28
  %26 = add nsw i32 %8, 21
  tail call void @gfx_fill(i32 noundef %25, i32 noundef %26, i32 noundef 17, i32 noundef 4, i16 noundef zeroext %16) #6
  br label %27

27:                                               ; preds = %24, %21
  %28 = and i32 %12, 4
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %33, label %30

30:                                               ; preds = %27
  %31 = add nsw i32 %6, 28
  %32 = add nsw i32 %8, 21
  tail call void @gfx_fill(i32 noundef %31, i32 noundef %32, i32 noundef 4, i32 noundef 17, i16 noundef zeroext %16) #6
  br label %33

33:                                               ; preds = %30, %27
  %34 = and i32 %12, 8
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %38, label %36

36:                                               ; preds = %33
  %37 = add nsw i32 %8, 21
  tail call void @gfx_fill(i32 noundef %7, i32 noundef %37, i32 noundef 17, i32 noundef 4, i16 noundef zeroext %16) #6
  br label %38

38:                                               ; preds = %36, %33
  %39 = icmp eq i32 %0, 24
  br i1 %39, label %40, label %43

40:                                               ; preds = %38
  %41 = add nuw nsw i32 %6, 23
  %42 = add nuw nsw i32 %8, 16
  tail call void @gfx_fill(i32 noundef %41, i32 noundef %42, i32 noundef 14, i32 noundef 14, i16 noundef zeroext -699) #6
  br label %62

43:                                               ; preds = %38
  %44 = lshr i32 %12, 1
  %45 = and i32 %44, 1
  %46 = add nuw nsw i32 %45, %17
  %47 = lshr i32 %12, 2
  %48 = and i32 %47, 1
  %49 = add nuw nsw i32 %46, %48
  %50 = lshr i32 %12, 3
  %51 = and i32 %50, 1
  %52 = add nuw nsw i32 %49, %51
  %53 = icmp eq i32 %52, 1
  br i1 %53, label %54, label %62

54:                                               ; preds = %43
  %55 = add nsw i32 %6, 24
  %56 = add nsw i32 %8, 17
  tail call void @gfx_rect(i32 noundef %55, i32 noundef %56, i32 noundef 12, i32 noundef 12, i32 noundef 2, i16 noundef zeroext %16) #6
  %57 = load i8, ptr %13, align 1, !tbaa !3
  %58 = icmp eq i8 %57, 0
  br i1 %58, label %62, label %59

59:                                               ; preds = %54
  %60 = add nsw i32 %6, 28
  %61 = add nsw i32 %8, 21
  tail call void @gfx_fill(i32 noundef %60, i32 noundef %61, i32 noundef 4, i32 noundef 4, i16 noundef zeroext 16175) #6
  br label %62

62:                                               ; preds = %43, %59, %54, %40
  %63 = icmp eq i32 %1, 0
  br i1 %63, label %67, label %64

64:                                               ; preds = %62
  %65 = add nsw i32 %6, 16
  %66 = add nsw i32 %8, 9
  tail call void @gfx_rect(i32 noundef %65, i32 noundef %66, i32 noundef 28, i32 noundef 28, i32 noundef 2, i16 noundef zeroext -1) #6
  br label %67

67:                                               ; preds = %64, %62
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_moves(i32 noundef %0) unnamed_addr #0 {
  %2 = alloca [5 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 5, ptr nonnull %2) #7
  call void @numstr(ptr noundef nonnull %2, i32 noundef 4, i32 noundef %0) #6
  call void @gfx_text(i32 noundef 15, i32 noundef 222, ptr noundef nonnull @.str.7, i16 noundef zeroext -21063, i16 noundef zeroext 2148) #6
  call void @gfx_text(i32 noundef 63, i32 noundef 222, ptr noundef nonnull %2, i16 noundef zeroext -1, i16 noundef zeroext 2148) #6
  call void @llvm.lifetime.end.p0(i64 5, ptr nonnull %2) #7
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 -1, 49) i32 @neigh(i32 noundef range(i32 -1, 256) %0, i32 noundef %1) unnamed_addr #5 {
  %3 = trunc nsw i32 %0 to i16
  %4 = sdiv i16 %3, 7
  %5 = zext nneg i16 %4 to i32
  %6 = getelementptr inbounds [4 x i8], ptr @dr, i32 0, i32 %1
  %7 = load i8, ptr %6, align 1, !tbaa !3
  %8 = sext i8 %7 to i32
  %9 = add nsw i32 %8, %5
  %10 = mul i16 %4, 7
  %11 = sub i16 %3, %10
  %12 = sext i16 %11 to i32
  %13 = getelementptr inbounds [4 x i8], ptr @dc, i32 0, i32 %1
  %14 = load i8, ptr %13, align 1, !tbaa !3
  %15 = sext i8 %14 to i32
  %16 = add nsw i32 %15, %12
  %17 = icmp slt i32 %9, 0
  br i1 %17, label %27, label %18

18:                                               ; preds = %2
  %19 = icmp samesign ugt i32 %9, 6
  br i1 %19, label %27, label %20

20:                                               ; preds = %18
  %21 = icmp slt i32 %16, 0
  br i1 %21, label %27, label %22

22:                                               ; preds = %20
  %23 = icmp samesign ugt i32 %16, 6
  br i1 %23, label %27, label %24

24:                                               ; preds = %22
  %25 = mul nuw nsw i32 %9, 7
  %26 = add nuw nsw i32 %25, %16
  br label %27

27:                                               ; preds = %2, %18, %20, %22, %24
  %28 = phi i32 [ %26, %24 ], [ -1, %22 ], [ -1, %20 ], [ -1, %18 ], [ -1, %2 ]
  ret i32 %28
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputn(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local i32 @rng() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @numstr(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #7 = { nounwind }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }

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
!9 = distinct !{!9, !7, !8}
!10 = !{!11, !11, i64 0}
!11 = !{!"int", !4, i64 0}
!12 = distinct !{!12, !7, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = distinct !{!15, !7, !8}
!16 = distinct !{!16, !8}
!17 = distinct !{!17, !7, !8}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !7, !8}
!23 = distinct !{!23, !7, !8}
