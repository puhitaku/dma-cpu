; ModuleID = 'dino.c'
source_filename = "dino.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.obst = type { i32, i32, i32, ptr }

@art_dino_a = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 103809024, i32 119275520, i32 0], align 4
@cell_run_a = internal global [440 x i16] zeroinitializer, align 2
@art_dino_b = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 7331840, i32 8380416, i32 8380416, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 108003328, i32 117440512, i32 125829120, i32 0], align 4
@cell_run_b = internal global [440 x i16] zeroinitializer, align 2
@art_dino_dead = internal constant [22 x i32] [i32 4177920, i32 8380416, i32 5758976, i32 7331840, i32 5758976, i32 8380416, i32 8126464, i32 8355840, i32 -2139357184, i32 -2130968576, i32 -1040318464, i32 -470024192, i32 -262144, i32 2147221504, i32 1073479680, i32 536346624, i32 267386880, i32 132120576, i32 106954752, i32 103809024, i32 119275520, i32 0], align 4
@cell_dead = internal global [440 x i16] zeroinitializer, align 2
@art_cact_s = internal constant [24 x i32] [i32 100663296, i32 100663296, i32 100663296, i32 1176502272, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1717567488, i32 1994391552, i32 1052770304, i32 532676608, i32 251658240, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296, i32 100663296], align 4
@cell_cact_s = internal global [288 x i16] zeroinitializer, align 2
@art_cact_l = internal constant [30 x i32] [i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 1642168320, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 1910734848, i32 2045214720, i32 1072103424, i32 536739840, i32 133955584, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280, i32 31457280], align 4
@cell_cact_l = internal global [540 x i16] zeroinitializer, align 2
@.str = private unnamed_addr constant [13 x i8] c"dino: start\0A\00", align 1
@obs = internal unnamed_addr global [2 x %struct.obst] zeroinitializer, align 4
@in_edge = external dso_local local_unnamed_addr global i32, align 4
@.str.1 = private unnamed_addr constant [10 x i8] c"GAME OVER\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"press: retry  down: menu\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"dino: over score=\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @dino_run() local_unnamed_addr #0 {
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_a, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_a) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_b, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_run_b) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_dino_dead, i32 noundef 20, i32 noundef 22, i16 noundef zeroext 14823, i16 noundef zeroext -1, ptr noundef nonnull @cell_dead) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_s, i32 noundef 12, i32 noundef 24, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_s) #4
  tail call void @gfx_sprite(ptr noundef nonnull @art_cact_l, i32 noundef 18, i32 noundef 30, i16 noundef zeroext 1031, i16 noundef zeroext -1, ptr noundef nonnull @cell_cact_l) #4
  br label %1

1:                                                ; preds = %138, %0
  tail call void @uputs(ptr noundef nonnull @.str) #4
  tail call void @gfx_clear(i16 noundef zeroext -1) #4
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 190, i32 noundef 240, i32 noundef 2, i16 noundef zeroext 14823) #4
  br label %2

2:                                                ; preds = %5, %1
  %3 = phi i32 [ 6, %1 ], [ %6, %5 ]
  %4 = icmp samesign ult i32 %3, 240
  br i1 %4, label %5, label %7

5:                                                ; preds = %2
  tail call void @gfx_fill(i32 noundef %3, i32 noundef 195, i32 noundef 8, i32 noundef 1, i16 noundef zeroext 14823) #4
  %6 = add nuw nsw i32 %3, 24
  br label %2, !llvm.loop !3

7:                                                ; preds = %2
  tail call fastcc void @draw_score(i32 noundef 0) #5
  tail call void @gfx_present() #4
  store i32 -1000, ptr getelementptr inbounds nuw (i8, ptr @obs, i32 16), align 4, !tbaa !6
  store i32 -1000, ptr @obs, align 4, !tbaa !6
  br label %8

8:                                                ; preds = %117, %7
  %9 = phi i32 [ 45, %7 ], [ %39, %117 ]
  %10 = phi i32 [ 4, %7 ], [ %86, %117 ]
  %11 = phi i32 [ 0, %7 ], [ %15, %117 ]
  %12 = phi i32 [ 0, %7 ], [ %43, %117 ]
  %13 = phi i32 [ 0, %7 ], [ %30, %117 ]
  %14 = phi i32 [ 0, %7 ], [ %31, %117 ]
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %15 = add i32 %11, 1
  %16 = load i32, ptr @in_edge, align 4, !tbaa !13
  %17 = and i32 %16, 17
  %18 = icmp ne i32 %17, 0
  %19 = icmp eq i32 %14, 0
  %20 = and i1 %18, %19
  %21 = select i1 %20, i32 2688, i32 %13
  br i1 %19, label %22, label %24

22:                                               ; preds = %8
  %23 = icmp sgt i32 %21, 0
  br i1 %23, label %24, label %29

24:                                               ; preds = %22, %8
  %25 = add nsw i32 %21, %14
  %26 = add nsw i32 %21, -256
  %27 = icmp slt i32 %25, 1
  br i1 %27, label %28, label %29

28:                                               ; preds = %24
  br label %29

29:                                               ; preds = %24, %28, %22
  %30 = phi i32 [ 0, %28 ], [ %26, %24 ], [ %13, %22 ]
  %31 = phi i32 [ 0, %28 ], [ %25, %24 ], [ 0, %22 ]
  %32 = icmp sgt i32 %9, 0
  %33 = sext i1 %32 to i32
  %34 = add nsw i32 %9, %33
  %35 = icmp ugt i32 %12, 100
  %36 = shl i32 %10, 1
  br label %37

37:                                               ; preds = %74, %29
  %38 = phi i32 [ 0, %29 ], [ %76, %74 ]
  %39 = phi i32 [ %34, %29 ], [ %75, %74 ]
  %40 = icmp eq i32 %38, 2
  br i1 %40, label %41, label %44

41:                                               ; preds = %37
  %42 = and i32 %11, 1
  %43 = add i32 %12, %42
  switch i32 %43, label %77 [
    i32 150, label %81
    i32 400, label %81
  ]

44:                                               ; preds = %37
  %45 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %38
  %46 = load i32, ptr %45, align 4, !tbaa !6
  %47 = icmp slt i32 %46, -100
  br i1 %47, label %48, label %67

48:                                               ; preds = %44
  %49 = icmp eq i32 %39, 0
  br i1 %49, label %50, label %74

50:                                               ; preds = %48
  br i1 %35, label %51, label %55

51:                                               ; preds = %50
  %52 = tail call i32 @rng() #4
  %53 = and i32 %52, 3
  %54 = icmp eq i32 %53, 0
  br i1 %54, label %56, label %55

55:                                               ; preds = %51, %50
  br label %56

56:                                               ; preds = %51, %55
  %57 = phi i32 [ 12, %55 ], [ 18, %51 ]
  %58 = phi i32 [ 24, %55 ], [ 30, %51 ]
  %59 = phi ptr [ @cell_cact_s, %55 ], [ @cell_cact_l, %51 ]
  %60 = getelementptr inbounds nuw i8, ptr %45, i32 4
  store i32 %57, ptr %60, align 4, !tbaa !14
  %61 = getelementptr inbounds nuw i8, ptr %45, i32 8
  store i32 %58, ptr %61, align 4, !tbaa !15
  %62 = getelementptr inbounds nuw i8, ptr %45, i32 12
  store ptr %59, ptr %62, align 4, !tbaa !16
  store i32 240, ptr %45, align 4, !tbaa !6
  %63 = tail call i32 @rng_below(i32 noundef 40) #4
  %64 = sub i32 %63, %36
  %65 = add i32 %64, 30
  %66 = tail call i32 @llvm.smax.i32(i32 %65, i32 18)
  br label %74

67:                                               ; preds = %44
  %68 = sub nsw i32 %46, %10
  %69 = getelementptr inbounds nuw i8, ptr %45, i32 4
  %70 = load i32, ptr %69, align 4, !tbaa !14
  %71 = add nsw i32 %70, %68
  %72 = icmp slt i32 %71, 1
  %73 = select i1 %72, i32 -1000, i32 %68
  store i32 %73, ptr %45, align 4
  br label %74

74:                                               ; preds = %48, %56, %67
  %75 = phi i32 [ %39, %67 ], [ %66, %56 ], [ %39, %48 ]
  %76 = add nuw nsw i32 %38, 1
  br label %37, !llvm.loop !17

77:                                               ; preds = %41
  %78 = icmp eq i32 %43, 800
  %79 = icmp slt i32 %10, 10
  %80 = select i1 %78, i1 %79, i1 false
  br i1 %80, label %83, label %85

81:                                               ; preds = %41, %41
  %82 = icmp slt i32 %10, 10
  br i1 %82, label %83, label %85

83:                                               ; preds = %77, %81
  %84 = add nsw i32 %10, 2
  br label %85

85:                                               ; preds = %81, %83, %77
  %86 = phi i32 [ %84, %83 ], [ %10, %81 ], [ %10, %77 ]
  tail call void @gfx_fill(i32 noundef 0, i32 noundef 100, i32 noundef 240, i32 noundef 90, i16 noundef zeroext -1) #4
  %87 = lshr i32 %31, 8
  %88 = sub nsw i32 168, %87
  %89 = and i32 %15, 4
  %90 = icmp eq i32 %89, 0
  %91 = icmp eq i32 %31, 0
  %92 = select i1 %91, i1 %90, i1 false
  %93 = select i1 %92, ptr @cell_run_b, ptr @cell_run_a
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %88, ptr noundef nonnull %93, i32 noundef 20, i32 noundef 22) #4
  br label %94

94:                                               ; preds = %112, %85
  %95 = phi i32 [ 0, %85 ], [ %113, %112 ]
  %96 = icmp eq i32 %95, 2
  br i1 %96, label %97, label %100

97:                                               ; preds = %94
  %98 = and i32 %15, 7
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %114, label %115

100:                                              ; preds = %94
  %101 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %95
  %102 = load i32, ptr %101, align 4, !tbaa !6
  %103 = icmp sgt i32 %102, -100
  br i1 %103, label %104, label %112

104:                                              ; preds = %100
  %105 = getelementptr inbounds nuw i8, ptr %101, i32 8
  %106 = load i32, ptr %105, align 4, !tbaa !15
  %107 = sub nsw i32 190, %106
  %108 = getelementptr inbounds nuw i8, ptr %101, i32 12
  %109 = load ptr, ptr %108, align 4, !tbaa !16
  %110 = getelementptr inbounds nuw i8, ptr %101, i32 4
  %111 = load i32, ptr %110, align 4, !tbaa !14
  tail call void @gfx_blit(i32 noundef %102, i32 noundef %107, ptr noundef %109, i32 noundef %111, i32 noundef %106) #4
  br label %112

112:                                              ; preds = %100, %104
  %113 = add nuw nsw i32 %95, 1
  br label %94, !llvm.loop !18

114:                                              ; preds = %97
  tail call fastcc void @draw_score(i32 noundef %43) #5
  br label %115

115:                                              ; preds = %114, %97
  tail call void @gfx_present() #4
  %116 = sub nsw i32 189, %87
  br label %117

117:                                              ; preds = %135, %115
  %118 = phi i32 [ 0, %115 ], [ %136, %135 ]
  %119 = icmp eq i32 %118, 2
  br i1 %119, label %8, label %120, !llvm.loop !19

120:                                              ; preds = %117
  %121 = getelementptr inbounds nuw [2 x %struct.obst], ptr @obs, i32 0, i32 %118
  %122 = load i32, ptr %121, align 4, !tbaa !6
  %123 = add i32 %122, 100
  %124 = icmp ult i32 %123, 145
  br i1 %124, label %125, label %135

125:                                              ; preds = %120
  %126 = getelementptr inbounds nuw i8, ptr %121, i32 8
  %127 = load i32, ptr %126, align 4, !tbaa !15
  %128 = sub i32 192, %127
  %129 = getelementptr inbounds nuw i8, ptr %121, i32 4
  %130 = load i32, ptr %129, align 4, !tbaa !14
  %131 = add nsw i32 %130, %122
  %132 = icmp sgt i32 %131, 35
  %133 = icmp sgt i32 %116, %128
  %134 = select i1 %132, i1 %133, i1 false
  br i1 %134, label %137, label %135

135:                                              ; preds = %125, %120
  %136 = add nuw nsw i32 %118, 1
  br label %117, !llvm.loop !20

137:                                              ; preds = %125
  tail call void @gfx_blit(i32 noundef 30, i32 noundef %88, ptr noundef nonnull @cell_dead, i32 noundef 20, i32 noundef 22) #4
  tail call void @gfx_text2(i32 noundef 48, i32 noundef 130, ptr noundef nonnull @.str.1, i16 noundef zeroext -14011, i16 noundef zeroext -1) #4
  tail call void @gfx_text(i32 noundef 24, i32 noundef 154, ptr noundef nonnull @.str.2, i16 noundef zeroext 14823, i16 noundef zeroext -1) #4
  tail call void @gfx_present() #4
  tail call void @uputs(ptr noundef nonnull @.str.3) #4
  tail call void @uputn(i32 noundef %43) #4
  tail call void @uputs(ptr noundef nonnull @.str.4) #4
  br label %138

138:                                              ; preds = %142, %137
  tail call void @frame_sync(i32 noundef 33000) #4
  tail call void @in_poll() #4
  %139 = load i32, ptr @in_edge, align 4, !tbaa !13
  %140 = and i32 %139, 17
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %142, label %1

142:                                              ; preds = %138
  %143 = and i32 %139, 2
  %144 = icmp eq i32 %143, 0
  br i1 %144, label %138, label %145, !llvm.loop !21

145:                                              ; preds = %142
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @gfx_sprite(ptr noundef, i32 noundef, i32 noundef, i16 noundef zeroext, i16 noundef zeroext, ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @uputs(ptr noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_clear(i16 noundef zeroext) local_unnamed_addr #1

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
declare dso_local void @frame_sync(i32 noundef) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @in_poll() local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local i32 @rng_below(i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: minsize optsize
declare dso_local void @gfx_fill(i32 noundef, i32 noundef, i32 noundef, i32 noundef, i16 noundef zeroext) local_unnamed_addr #1

; Function Attrs: minsize optsize
declare dso_local void @gfx_blit(i32 noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

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
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !8, i64 0}
!7 = !{!"obst", !8, i64 0, !8, i64 4, !8, i64 8, !11, i64 12}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!"p1 short", !12, i64 0}
!12 = !{!"any pointer", !9, i64 0}
!13 = !{!8, !8, i64 0}
!14 = !{!7, !8, i64 4}
!15 = !{!7, !8, i64 8}
!16 = !{!7, !11, i64 12}
!17 = distinct !{!17, !4, !5}
!18 = distinct !{!18, !4, !5}
!19 = distinct !{!19, !5}
!20 = distinct !{!20, !4, !5}
!21 = distinct !{!21, !5}
