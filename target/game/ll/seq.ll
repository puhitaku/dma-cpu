; ModuleID = 'seq.c'
source_filename = "seq.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [9 x i8] c"seq: up\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"SEQUENCER\00", align 1
@rendered = internal unnamed_addr global i1 false, align 4
@.str.2 = private unnamed_addr constant [22 x i8] c"Synthesizing Drums...\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"tempo\00", align 1
@.str.4 = private unnamed_addr constant [24 x i8] c"K kick   S snare  T tom\00", align 1
@.str.5 = private unnamed_addr constant [18 x i8] c"H hat    C cymbal\00", align 1
@.str.6 = private unnamed_addr constant [25 x i8] c"l/r: step  press: change\00", align 1
@.str.7 = private unnamed_addr constant [27 x i8] c"hold: exit  up/down: tempo\00", align 1
@seq_run.tdiv = internal unnamed_addr constant [8 x i32] [i32 26300, i32 24800, i32 23000, i32 21200, i32 18140, i32 17000, i32 16400, i32 15900], align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@pattern = internal unnamed_addr global [16 x i8] c"\01\00\04\00\02\00\04\04\01\00\04\01\02\00\05\00", align 1
@.str.8 = private unnamed_addr constant [15 x i8] c"seq: step set\0A\00", align 1
@in_down = external dso_local local_unnamed_addr global i32, align 4
@.str.9 = private unnamed_addr constant [11 x i8] c"seq: exit\0A\00", align 1
@dlen = internal unnamed_addr constant [6 x i32] [i32 0, i32 3000, i32 2000, i32 2200, i32 800, i32 3000], align 4
@daddr = internal unnamed_addr global [6 x i32] zeroinitializer, align 4
@dcol = internal unnamed_addr constant [6 x i16] [i16 8390, i16 -1339, i16 -377, i16 16111, i16 18012, i16 -17537], align 2
@dletter = internal unnamed_addr constant [6 x i8] c".KSTHC", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @seq_run() local_unnamed_addr #0 {
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @gfx_clear(i16 noundef zeroext 4163) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 8, ptr noundef nonnull @.str.1, i16 noundef zeroext -377, i16 noundef zeroext 4163) #4
  %1 = load i1, ptr @rendered, align 4
  br i1 %1, label %105, label %2

2:                                                ; preds = %0
  tail call void @gfx_text(i32 noundef 36, i32 noundef 116, ptr noundef nonnull @.str.2, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_present() #4
  br label %3

3:                                                ; preds = %43, %2
  %4 = phi i32 [ 537051136, %2 ], [ %48, %43 ]
  %5 = phi i32 [ 1, %2 ], [ %49, %43 ]
  %6 = icmp eq i32 %5, 6
  br i1 %6, label %7, label %43

7:                                                ; preds = %3
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 4), align 4, !tbaa !3
  %9 = inttoptr i32 %8 to ptr
  br label %10

10:                                               ; preds = %25, %7
  %11 = phi i32 [ 0, %7 ], [ %26, %25 ]
  %12 = phi i32 [ 1, %7 ], [ %27, %25 ]
  %13 = phi i32 [ 14000, %7 ], [ %29, %25 ]
  %14 = phi i32 [ 0, %7 ], [ %33, %25 ]
  %15 = icmp eq i32 %14, 3000
  br i1 %15, label %34, label %16

16:                                               ; preds = %10
  %17 = icmp sgt i32 %12, 0
  %18 = select i1 %17, i32 150, i32 -150
  %19 = add nsw i32 %18, %11
  %20 = icmp slt i32 %19, %13
  br i1 %20, label %21, label %25

21:                                               ; preds = %16
  %22 = sub nsw i32 0, %13
  %23 = icmp sgt i32 %19, %22
  br i1 %23, label %25, label %24

24:                                               ; preds = %21
  br label %25

25:                                               ; preds = %24, %21, %16
  %26 = phi i32 [ %22, %24 ], [ %19, %21 ], [ %13, %16 ]
  %27 = phi i32 [ 1, %24 ], [ %12, %21 ], [ -1, %16 ]
  %28 = ashr i32 %13, 10
  %29 = sub nsw i32 %13, %28
  %30 = and i32 %26, 65535
  %31 = mul nuw i32 %30, 65537
  %32 = getelementptr inbounds nuw i32, ptr %9, i32 %14
  store volatile i32 %31, ptr %32, align 4, !tbaa !3
  %33 = add nuw nsw i32 %14, 1
  br label %10, !llvm.loop !7

34:                                               ; preds = %10
  %35 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 8), align 4, !tbaa !3
  %36 = inttoptr i32 %35 to ptr
  tail call fastcc void @render_square(ptr noundef %36, i32 noundef 2000, i32 noundef 67, i32 noundef 0, i32 noundef 10000, i32 noundef 9) #5
  %37 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 12), align 4, !tbaa !3
  %38 = inttoptr i32 %37 to ptr
  tail call fastcc void @render_square(ptr noundef %38, i32 noundef 2200, i32 noundef 138, i32 noundef 1, i32 noundef 12000, i32 noundef 11) #5
  %39 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 16), align 4, !tbaa !3
  %40 = inttoptr i32 %39 to ptr
  tail call fastcc void @render_noise(ptr noundef %40, i32 noundef 800, i32 noundef 7) #5
  %41 = load i32, ptr getelementptr inbounds nuw (i8, ptr @daddr, i32 20), align 4, !tbaa !3
  %42 = inttoptr i32 %41 to ptr
  tail call fastcc void @render_noise(ptr noundef %42, i32 noundef 3000, i32 noundef 10) #5
  br label %50

43:                                               ; preds = %3
  %44 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %5
  store i32 %4, ptr %44, align 4, !tbaa !3
  %45 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %5
  %46 = load i32, ptr %45, align 4, !tbaa !3
  %47 = shl i32 %46, 2
  %48 = add i32 %47, %4
  %49 = add nuw nsw i32 %5, 1
  br label %3, !llvm.loop !10

50:                                               ; preds = %102, %34
  %51 = phi i32 [ 1, %34 ], [ %103, %102 ]
  %52 = icmp eq i32 %51, 6
  br i1 %52, label %104, label %53

53:                                               ; preds = %50
  %54 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %51
  %55 = load i32, ptr %54, align 4, !tbaa !3
  %56 = inttoptr i32 %55 to ptr
  %57 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %51
  %58 = load i32, ptr %57, align 4, !tbaa !3
  br label %59

59:                                               ; preds = %72, %53
  %60 = phi i32 [ 0, %53 ], [ %73, %72 ]
  %61 = icmp eq i32 %60, 6
  br i1 %61, label %66, label %62

62:                                               ; preds = %59
  %63 = shl nuw nsw i32 %60, 5
  %64 = getelementptr inbounds nuw i8, ptr %56, i32 %63
  %65 = sub nuw nsw i32 6, %60
  br label %69

66:                                               ; preds = %59
  %67 = getelementptr i32, ptr %56, i32 %58
  %68 = getelementptr i8, ptr %67, i32 -192
  br label %83

69:                                               ; preds = %74, %62
  %70 = phi i32 [ %82, %74 ], [ 0, %62 ]
  %71 = icmp eq i32 %70, 8
  br i1 %71, label %72, label %74

72:                                               ; preds = %69
  %73 = add nuw nsw i32 %60, 1
  br label %59, !llvm.loop !11

74:                                               ; preds = %69
  %75 = getelementptr inbounds nuw i32, ptr %64, i32 %70
  %76 = load volatile i32, ptr %75, align 4, !tbaa !3
  %77 = shl i32 %76, 16
  %78 = ashr exact i32 %77, 16
  %79 = ashr i32 %78, %65
  %80 = and i32 %79, 65535
  %81 = mul nuw i32 %80, 65537
  store volatile i32 %81, ptr %75, align 4, !tbaa !3
  %82 = add nuw nsw i32 %70, 1
  br label %69, !llvm.loop !12

83:                                               ; preds = %90, %66
  %84 = phi i32 [ 0, %66 ], [ %89, %90 ]
  %85 = icmp eq i32 %84, 6
  br i1 %85, label %102, label %86

86:                                               ; preds = %83
  %87 = shl nuw nsw i32 %84, 5
  %88 = getelementptr i8, ptr %68, i32 %87
  %89 = add nuw nsw i32 %84, 1
  br label %90

90:                                               ; preds = %93, %86
  %91 = phi i32 [ %101, %93 ], [ 0, %86 ]
  %92 = icmp eq i32 %91, 8
  br i1 %92, label %83, label %93, !llvm.loop !13

93:                                               ; preds = %90
  %94 = getelementptr i32, ptr %88, i32 %91
  %95 = load volatile i32, ptr %94, align 4, !tbaa !3
  %96 = shl i32 %95, 16
  %97 = ashr exact i32 %96, 16
  %98 = ashr i32 %97, %89
  %99 = and i32 %98, 65535
  %100 = mul nuw i32 %99, 65537
  store volatile i32 %100, ptr %94, align 4, !tbaa !3
  %101 = add nuw nsw i32 %91, 1
  br label %90, !llvm.loop !14

102:                                              ; preds = %83
  %103 = add nuw nsw i32 %51, 1
  br label %50, !llvm.loop !15

104:                                              ; preds = %50
  store i1 true, ptr @rendered, align 4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 116, i32 noundef 240, i32 noundef 8, i16 noundef zeroext 4163) #4
  br label %105

105:                                              ; preds = %104, %0
  tail call void @gfx_text(i32 noundef 72, i32 noundef 40, ptr noundef nonnull @.str.3, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  br label %106

106:                                              ; preds = %110, %105
  %107 = phi i32 [ 0, %105 ], [ %113, %110 ]
  %108 = icmp eq i32 %107, 16
  br i1 %108, label %109, label %110

109:                                              ; preds = %106
  tail call void @gfx_text(i32 noundef 6, i32 noundef 150, ptr noundef nonnull @.str.4, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 162, ptr noundef nonnull @.str.5, i16 noundef zeroext -16966, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 200, ptr noundef nonnull @.str.6, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #4
  tail call void @gfx_text(i32 noundef 6, i32 noundef 212, ptr noundef nonnull @.str.7, i16 noundef zeroext 25327, i16 noundef zeroext 4163) #4
  tail call void @snd_rate(i32 noundef 18140) #4
  tail call fastcc void @draw_tempo(i32 noundef 4) #5
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  br label %114

110:                                              ; preds = %106
  %111 = icmp eq i32 %107, 0
  %112 = zext i1 %111 to i32
  tail call fastcc void @draw_step(i32 noundef %107, i32 noundef %112) #5
  %113 = add nuw nsw i32 %107, 1
  br label %106, !llvm.loop !16

114:                                              ; preds = %222, %109
  %115 = phi i32 [ -1, %109 ], [ %192, %222 ]
  %116 = phi i32 [ 0, %109 ], [ %184, %222 ]
  %117 = phi i32 [ 0, %109 ], [ %188, %222 ]
  %118 = phi i32 [ 0, %109 ], [ %145, %222 ]
  %119 = phi i32 [ 4, %109 ], [ %179, %222 ]
  tail call void @gfx_present() #4
  br label %120

120:                                              ; preds = %114, %187
  %121 = phi i32 [ %184, %187 ], [ %116, %114 ]
  %122 = phi i32 [ %188, %187 ], [ %117, %114 ]
  %123 = phi i32 [ %145, %187 ], [ %118, %114 ]
  %124 = phi i32 [ %179, %187 ], [ %119, %114 ]
  tail call void @frame_sync(i32 noundef 4000) #4
  tail call void @in_poll() #4
  %125 = load i32, ptr @in_edge, align 4, !tbaa !3
  %126 = and i32 %125, 4
  %127 = icmp eq i32 %126, 0
  br i1 %127, label %133, label %128

128:                                              ; preds = %120
  tail call fastcc void @draw_step(i32 noundef %123, i32 noundef 0) #5
  %129 = icmp eq i32 %123, 0
  %130 = add nsw i32 %123, -1
  %131 = select i1 %129, i32 15, i32 %130
  tail call fastcc void @draw_step(i32 noundef %131, i32 noundef 1) #5
  tail call void @gfx_present() #4
  %132 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %133

133:                                              ; preds = %128, %120
  %134 = phi i32 [ %132, %128 ], [ %125, %120 ]
  %135 = phi i32 [ %131, %128 ], [ %123, %120 ]
  %136 = and i32 %134, 8
  %137 = icmp eq i32 %136, 0
  br i1 %137, label %143, label %138

138:                                              ; preds = %133
  tail call fastcc void @draw_step(i32 noundef %135, i32 noundef 0) #5
  %139 = icmp eq i32 %135, 15
  %140 = add nsw i32 %135, 1
  %141 = select i1 %139, i32 0, i32 %140
  tail call fastcc void @draw_step(i32 noundef %141, i32 noundef 1) #5
  tail call void @gfx_present() #4
  %142 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %143

143:                                              ; preds = %138, %133
  %144 = phi i32 [ %142, %138 ], [ %134, %133 ]
  %145 = phi i32 [ %141, %138 ], [ %135, %133 ]
  %146 = and i32 %144, 16
  %147 = icmp eq i32 %146, 0
  br i1 %147, label %156, label %148

148:                                              ; preds = %143
  %149 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %145
  %150 = load i8, ptr %149, align 1, !tbaa !17
  %151 = zext i8 %150 to i16
  %152 = add nuw nsw i16 %151, 1
  %153 = urem i16 %152, 6
  %154 = trunc nuw nsw i16 %153 to i8
  store i8 %154, ptr %149, align 1, !tbaa !17
  tail call fastcc void @draw_step(i32 noundef %145, i32 noundef 1) #5
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.8) #4
  %155 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %156

156:                                              ; preds = %148, %143
  %157 = phi i32 [ %155, %148 ], [ %144, %143 ]
  %158 = and i32 %157, 1
  %159 = icmp ne i32 %158, 0
  %160 = icmp slt i32 %124, 7
  %161 = select i1 %159, i1 %160, i1 false
  br i1 %161, label %162, label %167

162:                                              ; preds = %156
  %163 = add nsw i32 %124, 1
  %164 = getelementptr inbounds [8 x i32], ptr @seq_run.tdiv, i32 0, i32 %163
  %165 = load i32, ptr %164, align 4, !tbaa !3
  tail call void @snd_rate(i32 noundef %165) #4
  tail call fastcc void @draw_tempo(i32 noundef %163) #5
  tail call void @gfx_present() #4
  %166 = load i32, ptr @in_edge, align 4, !tbaa !3
  br label %167

167:                                              ; preds = %162, %156
  %168 = phi i32 [ %166, %162 ], [ %157, %156 ]
  %169 = phi i32 [ %163, %162 ], [ %124, %156 ]
  %170 = and i32 %168, 2
  %171 = icmp ne i32 %170, 0
  %172 = icmp sgt i32 %169, 0
  %173 = select i1 %171, i1 %172, i1 false
  br i1 %173, label %174, label %178

174:                                              ; preds = %167
  %175 = add nsw i32 %169, -1
  %176 = getelementptr inbounds nuw [8 x i32], ptr @seq_run.tdiv, i32 0, i32 %175
  %177 = load i32, ptr %176, align 4, !tbaa !3
  tail call void @snd_rate(i32 noundef %177) #4
  tail call fastcc void @draw_tempo(i32 noundef %175) #5
  tail call void @gfx_present() #4
  br label %178

178:                                              ; preds = %174, %167
  %179 = phi i32 [ %175, %174 ], [ %169, %167 ]
  %180 = load i32, ptr @in_down, align 4, !tbaa !3
  %181 = and i32 %180, 16
  %182 = icmp eq i32 %181, 0
  %183 = add nuw nsw i32 %121, 1
  %184 = select i1 %182, i32 0, i32 %183
  %185 = icmp samesign ugt i32 %184, 300
  br i1 %185, label %186, label %187

186:                                              ; preds = %178
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  tail call void @snd_rate(i32 noundef 18140) #4
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  tail call void @uputs(ptr noundef nonnull @.str.9) #4
  ret void

187:                                              ; preds = %178
  %188 = load volatile i32, ptr inttoptr (i32 1342177856 to ptr), align 64, !tbaa !3
  %189 = icmp ult i32 %188, %122
  br i1 %189, label %190, label %120, !llvm.loop !18

190:                                              ; preds = %187
  %191 = add nsw i32 %115, 1
  %192 = and i32 %191, 15
  %193 = getelementptr inbounds nuw [16 x i8], ptr @pattern, i32 0, i32 %192
  %194 = load i8, ptr %193, align 1, !tbaa !17
  %195 = icmp eq i8 %194, 0
  br i1 %195, label %205, label %196

196:                                              ; preds = %190
  %197 = zext i8 %194 to i32
  %198 = getelementptr inbounds nuw [6 x i32], ptr @dlen, i32 0, i32 %197
  %199 = load i32, ptr %198, align 4, !tbaa !3
  %200 = shl i32 %199, 2
  %201 = getelementptr inbounds nuw [6 x i32], ptr @daddr, i32 0, i32 %197
  %202 = load i32, ptr %201, align 4, !tbaa !3
  tail call void @gdma_copy(i32 noundef 537100288, i32 noundef %202, i32 noundef %200) #4
  %203 = add i32 %200, 537100288
  %204 = sub i32 16384, %200
  tail call void @gdma_fill(i32 noundef %203, i32 noundef 0, i32 noundef %204) #4
  br label %206

205:                                              ; preds = %190
  tail call void @gdma_fill(i32 noundef 537100288, i32 noundef 0, i32 noundef 16384) #4
  br label %206

206:                                              ; preds = %205, %196
  %207 = icmp sgt i32 %115, -1
  br i1 %207, label %208, label %214

208:                                              ; preds = %206
  %209 = and i32 %115, 7
  %210 = mul nuw nsw i32 %209, 29
  %211 = add nuw nsw i32 %210, 6
  %212 = icmp samesign ult i32 %115, 8
  %213 = select i1 %212, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %211, i32 noundef %213, i32 noundef 26, i32 noundef 3, i16 noundef zeroext 4163) #4
  br label %214

214:                                              ; preds = %206, %208
  %215 = and i32 %191, 7
  %216 = mul nuw nsw i32 %215, 29
  %217 = add nuw nsw i32 %216, 6
  %218 = icmp samesign ult i32 %192, 8
  %219 = select i1 %218, i32 91, i32 131
  tail call void @gfx_fill(i32 noundef %217, i32 noundef %219, i32 noundef 26, i32 noundef 3, i16 noundef zeroext -377) #4
  switch i8 %194, label %223 [
    i8 1, label %220
    i8 2, label %221
  ]

220:                                              ; preds = %214
  tail call void @led(i32 noundef 4132864, i32 noundef 0) #4
  br label %222

221:                                              ; preds = %214
  tail call void @led(i32 noundef 0, i32 noundef 4144912) #4
  br label %222

222:                                              ; preds = %221, %225, %224, %220
  br label %114, !llvm.loop !18

223:                                              ; preds = %214
  br i1 %195, label %225, label %224

224:                                              ; preds = %223
  tail call void @led(i32 noundef 3855, i32 noundef 3855) #4
  br label %222

225:                                              ; preds = %223
  tail call void @led(i32 noundef 0, i32 noundef 0) #4
  br label %222
}

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text2(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_text(i32 noundef, i32 noundef, ptr noundef, i16 noundef zeroext, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_present() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_step(i32 noundef %0, i32 noundef range(i32 0, 2) %1) unnamed_addr #0 {
  %3 = alloca [2 x i8], align 1
  %4 = and i32 %0, 7
  %5 = mul nuw nsw i32 %4, 29
  %6 = add nuw nsw i32 %5, 6
  %7 = icmp slt i32 %0, 8
  %8 = select i1 %7, i32 64, i32 104
  %9 = getelementptr inbounds [16 x i8], ptr @pattern, i32 0, i32 %0
  %10 = load i8, ptr %9, align 1, !tbaa !17
  %11 = zext i8 %10 to i32
  %12 = getelementptr inbounds nuw [6 x i16], ptr @dcol, i32 0, i32 %11
  %13 = load i16, ptr %12, align 2, !tbaa !19
  tail call void @gfx_fill(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i16 noundef zeroext %13) #4
  %14 = icmp eq i8 %10, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %3) #6
  %16 = getelementptr inbounds nuw [6 x i8], ptr @dletter, i32 0, i32 %11
  %17 = load i8, ptr %16, align 1, !tbaa !17
  store i8 %17, ptr %3, align 1, !tbaa !17
  %18 = getelementptr inbounds nuw i8, ptr %3, i32 1
  store i8 0, ptr %18, align 1, !tbaa !17
  %19 = add nuw nsw i32 %5, 15
  %20 = add nuw nsw i32 %8, 9
  call void @gfx_text(i32 noundef %19, i32 noundef %20, ptr noundef nonnull %3, i16 noundef zeroext 2114, i16 noundef zeroext %13) #4
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %3) #6
  br label %21

21:                                               ; preds = %15, %2
  %22 = icmp eq i32 %1, 0
  %23 = select i1 %22, i32 1, i32 2
  %24 = select i1 %22, i16 14730, i16 -1
  call void @gfx_rect(i32 noundef %6, i32 noundef %8, i32 noundef 26, i32 noundef 26, i32 noundef %23, i16 noundef zeroext %24) #4
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @snd_rate(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nounwind optsize
define internal fastcc void @draw_tempo(i32 noundef range(i32 -2147483647, 2147483647) %0) unnamed_addr #0 {
  %2 = alloca [2 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %2) #6
  %3 = trunc i32 %0 to i8
  %4 = add i8 %3, 49
  store i8 %4, ptr %2, align 1, !tbaa !17
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 0, ptr %5, align 1, !tbaa !17
  call void @gfx_text(i32 noundef 140, i32 noundef 40, ptr noundef nonnull %2, i16 noundef zeroext -1, i16 noundef zeroext 4163) #4
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %2) #6
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gdma_fill(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @led(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gdma_copy(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize nofree norecurse nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite)
define internal fastcc void @render_square(ptr noundef %0, i32 noundef range(i32 2000, 2201) %1, i32 noundef range(i32 67, 139) %2, i32 noundef range(i32 0, 2) %3, i32 noundef range(i32 10000, 12001) %4, i32 noundef range(i32 9, 12) %5) unnamed_addr #3 {
  %7 = icmp ne i32 %3, 0
  br label %8

8:                                                ; preds = %16, %6
  %9 = phi i32 [ %4, %6 ], [ %28, %16 ]
  %10 = phi i32 [ %2, %6 ], [ %26, %16 ]
  %11 = phi i32 [ 0, %6 ], [ %20, %16 ]
  %12 = phi i32 [ 1, %6 ], [ %21, %16 ]
  %13 = phi i32 [ 0, %6 ], [ %35, %16 ]
  %14 = icmp eq i32 %13, %1
  br i1 %14, label %15, label %16

15:                                               ; preds = %8
  ret void

16:                                               ; preds = %8
  %17 = add nsw i32 %11, 1
  %18 = icmp slt i32 %17, %10
  %19 = sub nsw i32 0, %12
  %20 = select i1 %18, i32 %17, i32 0
  %21 = select i1 %18, i32 %12, i32 %19
  %22 = and i32 %13, 31
  %23 = icmp eq i32 %22, 0
  %24 = and i1 %7, %23
  %25 = zext i1 %24 to i32
  %26 = add nuw nsw i32 %10, %25
  %27 = ashr i32 %9, %5
  %28 = sub nsw i32 %9, %27
  %29 = icmp sgt i32 %21, 0
  %30 = sub nsw i32 0, %28
  %31 = select i1 %29, i32 %28, i32 %30
  %32 = and i32 %31, 65535
  %33 = mul nuw i32 %32, 65537
  %34 = getelementptr inbounds nuw i32, ptr %0, i32 %13
  store volatile i32 %33, ptr %34, align 4, !tbaa !3
  %35 = add nuw nsw i32 %13, 1
  br label %8, !llvm.loop !21
}

; Function Attrs: minsize nofree norecurse nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite)
define internal fastcc void @render_noise(ptr noundef %0, i32 noundef range(i32 800, 3001) %1, i32 noundef range(i32 7, 11) %2) unnamed_addr #3 {
  br label %4

4:                                                ; preds = %10, %3
  %5 = phi i32 [ 9000, %3 ], [ %18, %10 ]
  %6 = phi i32 [ 495397697, %3 ], [ %16, %10 ]
  %7 = phi i32 [ 0, %3 ], [ %26, %10 ]
  %8 = icmp eq i32 %7, %1
  br i1 %8, label %9, label %10

9:                                                ; preds = %4
  ret void

10:                                               ; preds = %4
  %11 = shl i32 %6, 13
  %12 = xor i32 %11, %6
  %13 = lshr i32 %12, 17
  %14 = xor i32 %13, %12
  %15 = shl i32 %14, 5
  %16 = xor i32 %15, %14
  %17 = ashr i32 %5, %2
  %18 = sub nsw i32 %5, %17
  %19 = and i32 %14, 1
  %20 = icmp eq i32 %19, 0
  %21 = sub nsw i32 0, %18
  %22 = select i1 %20, i32 %21, i32 %18
  %23 = and i32 %22, 65535
  %24 = mul nuw i32 %23, 65537
  %25 = getelementptr inbounds nuw i32, ptr %0, i32 %7
  store volatile i32 %24, ptr %25, align 4, !tbaa !3
  %26 = add nuw nsw i32 %7, 1
  br label %4, !llvm.loop !22
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_rect(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize nofree norecurse nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #5 = { minsize nobuiltin optsize "no-builtins" }
attributes #6 = { nounwind }

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
!17 = !{!5, !5, i64 0}
!18 = distinct !{!18, !9}
!19 = !{!20, !20, i64 0}
!20 = !{!"short", !5, i64 0}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !8, !9}
