; ModuleID = 'dma/fbtools.c'
source_filename = "dma/fbtools.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.fbinfo = type { i32, i32, i32, i32, i32 }
%struct.stat = type { i32, i32, i16, i16, i32 }
%struct.dirent = type { i16, [62 x i8] }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"fbtest\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"show\00", align 1
@.str.3 = private unnamed_addr constant [48 x i8] c"usage: fbtest | show DIR|FILE...|DECK [series]\0A\00", align 1
@.str.4 = private unnamed_addr constant [15 x i8] c"fbtest: no fb\0A\00", align 1
@.str.5 = private unnamed_addr constant [14 x i8] c"fbtest: busy\0A\00", align 1
@t_fbtest.bars = internal unnamed_addr constant [16 x i8] c"\00\80\10\90\02\82\12\DB\92\E0\1C\FC\03\E3\1F\FF", align 1
@t_fbtest.tmpl = internal unnamed_addr global [640 x i8] zeroinitializer, align 1
@.str.6 = private unnamed_addr constant [28 x i8] c"fbtest: test card up (5 s)\0A\00", align 1
@.str.7 = private unnamed_addr constant [21 x i8] c"fbtest: verify FAIL\0A\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"fb ok \00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.11 = private unnamed_addr constant [13 x i8] c"show: no fb\0A\00", align 1
@nshow = internal unnamed_addr global i32 0, align 4
@deckfd = internal unnamed_addr global i32 -1, align 4
@.str.12 = private unnamed_addr constant [30 x i8] c"show: no such series in deck\0A\00", align 1
@.str.13 = private unnamed_addr constant [19 x i8] c"show: cannot open\0A\00", align 1
@shownames = internal global [32 x [64 x i8]] zeroinitializer, align 1
@.str.14 = private unnamed_addr constant [57 x i8] c"show: no slides (usage: show DIR|FILE...|DECK [series])\0A\00", align 1
@.str.15 = private unnamed_addr constant [15 x i8] c" slides found\0A\00", align 1
@.str.16 = private unnamed_addr constant [15 x i8] c"show: fb busy\0A\00", align 1
@.str.17 = private unnamed_addr constant [11 x i8] c"UART: quit\00", align 1
@.str.18 = private unnamed_addr constant [12 x i8] c"UART: right\00", align 1
@.str.19 = private unnamed_addr constant [11 x i8] c"UART: left\00", align 1
@.str.20 = private unnamed_addr constant [13 x i8] c"Joystick: up\00", align 1
@.str.21 = private unnamed_addr constant [15 x i8] c"Joystick: down\00", align 1
@.str.22 = private unnamed_addr constant [15 x i8] c"Joystick: left\00", align 1
@.str.23 = private unnamed_addr constant [16 x i8] c"Joystick: right\00", align 1
@.str.24 = private unnamed_addr constant [15 x i8] c"Joystick: push\00", align 1
@decksz = internal unnamed_addr global i32 0, align 4
@deckoff = internal unnamed_addr global i32 0, align 4
@olen = internal unnamed_addr global i32 0, align 4
@.str.25 = private unnamed_addr constant [23 x i8] c" slides found (series \00", align 1
@.str.26 = private unnamed_addr constant [3 x i8] c")\0A\00", align 1
@obuf = internal global [256 x i8] zeroinitializer, align 1
@.str.27 = private unnamed_addr constant [21 x i8] c"Start drawing slide \00", align 1
@.str.28 = private unnamed_addr constant [8 x i8] c" on FB\0A\00", align 1
@.str.29 = private unnamed_addr constant [20 x i8] c"Done drawing slide \00", align 1
@.str.30 = private unnamed_addr constant [19 x i8] c"show: cannot open \00", align 1
@.str.31 = private unnamed_addr constant [8 x i8] c"Opened \00", align 1
@.str.32 = private unnamed_addr constant [15 x i8] c"Start drawing \00", align 1
@.str.33 = private unnamed_addr constant [7 x i8] c" on FB\00", align 1
@.str.34 = private unnamed_addr constant [14 x i8] c"Done drawing \00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %0, 0
  br i1 %3, label %4, label %8

4:                                                ; preds = %2
  %5 = load ptr, ptr %1, align 4, !tbaa !3
  %6 = icmp eq ptr %5, null
  %7 = select i1 %6, ptr @.str, ptr %5
  br label %8

8:                                                ; preds = %4, %2
  %9 = phi ptr [ %7, %4 ], [ @.str, %2 ]
  br label %10

10:                                               ; preds = %8, %19
  %11 = phi ptr [ %20, %19 ], [ %9, %8 ]
  %12 = phi ptr [ %21, %19 ], [ %9, %8 ]
  %13 = load i8, ptr %12, align 1, !tbaa !8
  switch i8 %13, label %19 [
    i8 0, label %14
    i8 47, label %17
  ]

14:                                               ; preds = %10
  %15 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.1) #9
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %25, label %22

17:                                               ; preds = %10
  %18 = getelementptr inbounds nuw i8, ptr %12, i32 1
  br label %19

19:                                               ; preds = %10, %17
  %20 = phi ptr [ %18, %17 ], [ %11, %10 ]
  %21 = getelementptr inbounds nuw i8, ptr %12, i32 1
  br label %10, !llvm.loop !9

22:                                               ; preds = %14
  %23 = tail call fastcc i32 @t_fbtest() #9
  %24 = tail call i32 @exit(i32 noundef %23) #10
  unreachable

25:                                               ; preds = %14
  %26 = tail call fastcc i32 @streq(ptr noundef %11, ptr noundef nonnull @.str.2) #9
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %31, label %28

28:                                               ; preds = %25
  %29 = tail call fastcc i32 @t_show(i32 noundef %0, ptr noundef %1) #9
  %30 = tail call i32 @exit(i32 noundef %29) #10
  unreachable

31:                                               ; preds = %25
  %32 = tail call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.3, i32 noundef 47) #11
  %33 = tail call i32 @exit(i32 noundef 1) #10
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @streq(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #2 {
  br label %3

3:                                                ; preds = %11, %2
  %4 = phi ptr [ %0, %2 ], [ %12, %11 ]
  %5 = phi ptr [ %1, %2 ], [ %13, %11 ]
  %6 = load i8, ptr %4, align 1, !tbaa !8
  %7 = icmp ne i8 %6, 0
  %8 = load i8, ptr %5, align 1, !tbaa !8
  %9 = icmp eq i8 %6, %8
  %10 = select i1 %7, i1 %9, i1 false
  br i1 %10, label %11, label %14

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %13 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !12

14:                                               ; preds = %3
  %15 = zext i1 %9 to i32
  ret i32 %15
}

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_fbtest() unnamed_addr #4 {
  %1 = alloca %struct.fbinfo, align 4
  %2 = alloca [5 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %1) #12
  %3 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %1) #11
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %0
  %6 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.4, i32 noundef 14) #11
  br label %149

7:                                                ; preds = %0
  %8 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #11
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  %11 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.5, i32 noundef 13) #11
  br label %149

12:                                               ; preds = %7
  %13 = load i32, ptr %1, align 4, !tbaa !13
  %14 = getelementptr inbounds nuw i8, ptr %1, i32 16
  %15 = load i32, ptr %14, align 4, !tbaa !16
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %2) #12
  %16 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %17 = load i32, ptr %16, align 4, !tbaa !17
  %18 = udiv i32 %17, 5
  br label %19

19:                                               ; preds = %27, %12
  %20 = phi i32 [ 0, %12 ], [ %28, %27 ]
  %21 = icmp eq i32 %20, 5
  br i1 %21, label %22, label %27

22:                                               ; preds = %19
  %23 = inttoptr i32 %13 to ptr
  %24 = lshr i32 %15, 2
  %25 = getelementptr inbounds nuw i8, ptr %2, i32 16
  store i32 %17, ptr %25, align 4, !tbaa !18
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 4
  br label %31

27:                                               ; preds = %19
  %28 = add nuw nsw i32 %20, 1
  %29 = mul nuw i32 %18, %28
  %30 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %20
  store i32 %29, ptr %30, align 4, !tbaa !18
  br label %19, !llvm.loop !19

31:                                               ; preds = %95, %22
  %32 = phi i32 [ 0, %22 ], [ %96, %95 ]
  %33 = icmp eq i32 %32, 5
  br i1 %33, label %110, label %34

34:                                               ; preds = %31
  %35 = icmp eq i32 %32, 0
  br i1 %35, label %36, label %39

36:                                               ; preds = %34
  %37 = load i32, ptr %26, align 4, !tbaa !20
  %38 = lshr i32 %37, 4
  br label %44

39:                                               ; preds = %34
  %40 = icmp eq i32 %32, 3
  %41 = load i32, ptr %26, align 4
  %42 = select i1 %40, i32 2, i32 3
  %43 = lshr i32 %41, %42
  br label %44

44:                                               ; preds = %39, %36
  %45 = phi i32 [ %37, %36 ], [ %41, %39 ]
  %46 = phi i32 [ %38, %36 ], [ %43, %39 ]
  br label %47

47:                                               ; preds = %72, %44
  %48 = phi i32 [ 0, %44 ], [ %74, %72 ]
  %49 = phi i32 [ 0, %44 ], [ %79, %72 ]
  %50 = phi i32 [ %46, %44 ], [ %80, %72 ]
  %51 = icmp eq i32 %48, %45
  br i1 %51, label %81, label %52

52:                                               ; preds = %47
  br i1 %35, label %53, label %56

53:                                               ; preds = %52
  %54 = getelementptr inbounds nuw [16 x i8], ptr @t_fbtest.bars, i32 0, i32 %49
  %55 = load i8, ptr %54, align 1, !tbaa !8
  br label %72

56:                                               ; preds = %52
  switch i32 %32, label %65 [
    i32 1, label %57
    i32 2, label %60
    i32 3, label %63
  ]

57:                                               ; preds = %56
  %58 = trunc i32 %49 to i8
  %59 = shl i8 %58, 5
  br label %72

60:                                               ; preds = %56
  %61 = trunc i32 %49 to i8
  %62 = shl i8 %61, 2
  br label %72

63:                                               ; preds = %56
  %64 = trunc i32 %49 to i8
  br label %72

65:                                               ; preds = %56
  %66 = shl i32 %49, 5
  %67 = shl i32 %49, 2
  %68 = or i32 %66, %67
  %69 = lshr i32 %49, 1
  %70 = or i32 %68, %69
  %71 = trunc i32 %70 to i8
  br label %72

72:                                               ; preds = %57, %63, %65, %60, %53
  %73 = phi i8 [ %55, %53 ], [ %59, %57 ], [ %62, %60 ], [ %64, %63 ], [ %71, %65 ]
  %74 = add i32 %48, 1
  %75 = getelementptr inbounds nuw [640 x i8], ptr @t_fbtest.tmpl, i32 0, i32 %48
  store i8 %73, ptr %75, align 1, !tbaa !8
  %76 = add i32 %50, -1
  %77 = icmp eq i32 %76, 0
  %78 = zext i1 %77 to i32
  %79 = add i32 %49, %78
  %80 = select i1 %77, i32 %46, i32 %76
  br label %47, !llvm.loop !21

81:                                               ; preds = %47
  store i8 -1, ptr @t_fbtest.tmpl, align 1, !tbaa !8
  %82 = add i32 %45, -1
  %83 = getelementptr inbounds nuw [640 x i8], ptr @t_fbtest.tmpl, i32 0, i32 %82
  store i8 -1, ptr %83, align 1, !tbaa !8
  br i1 %35, label %88, label %84

84:                                               ; preds = %81
  %85 = add nsw i32 %32, -1
  %86 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %85
  %87 = load i32, ptr %86, align 4, !tbaa !18
  br label %88

88:                                               ; preds = %81, %84
  %89 = phi i32 [ %87, %84 ], [ 0, %81 ]
  %90 = getelementptr inbounds nuw [5 x i32], ptr %2, i32 0, i32 %32
  %91 = load i32, ptr %90, align 4, !tbaa !18
  br label %92

92:                                               ; preds = %103, %88
  %93 = phi i32 [ %89, %88 ], [ %104, %103 ]
  %94 = icmp ult i32 %93, %91
  br i1 %94, label %97, label %95

95:                                               ; preds = %92
  %96 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !22

97:                                               ; preds = %92
  %98 = mul i32 %93, %24
  %99 = getelementptr inbounds nuw i32, ptr %23, i32 %98
  br label %100

100:                                              ; preds = %105, %97
  %101 = phi i32 [ 0, %97 ], [ %109, %105 ]
  %102 = icmp eq i32 %101, %24
  br i1 %102, label %103, label %105

103:                                              ; preds = %100
  %104 = add nuw i32 %93, 1
  br label %92, !llvm.loop !23

105:                                              ; preds = %100
  %106 = getelementptr inbounds nuw i32, ptr @t_fbtest.tmpl, i32 %101
  %107 = load i32, ptr %106, align 4, !tbaa !18
  %108 = getelementptr inbounds nuw i32, ptr %99, i32 %101
  store volatile i32 %107, ptr %108, align 4, !tbaa !18
  %109 = add nuw nsw i32 %101, 1
  br label %100, !llvm.loop !24

110:                                              ; preds = %31, %116
  %111 = phi i32 [ %123, %116 ], [ 0, %31 ]
  %112 = icmp eq i32 %111, %24
  br i1 %112, label %113, label %116

113:                                              ; preds = %110
  %114 = load volatile i32, ptr %23, align 4, !tbaa !18
  %115 = icmp eq i32 %114, -1
  br i1 %115, label %124, label %137

116:                                              ; preds = %110
  %117 = getelementptr inbounds nuw i32, ptr %23, i32 %111
  store volatile i32 -1, ptr %117, align 4, !tbaa !18
  %118 = load i32, ptr %16, align 4, !tbaa !17
  %119 = add i32 %118, -1
  %120 = mul i32 %119, %24
  %121 = getelementptr i32, ptr %23, i32 %120
  %122 = getelementptr i32, ptr %121, i32 %111
  store volatile i32 -1, ptr %122, align 4, !tbaa !18
  %123 = add nuw nsw i32 %111, 1
  br label %110, !llvm.loop !25

124:                                              ; preds = %113
  %125 = getelementptr inbounds nuw i32, ptr %23, i32 %24
  %126 = load volatile i32, ptr %125, align 4, !tbaa !18
  %127 = and i32 %126, 255
  %128 = icmp eq i32 %127, 255
  br i1 %128, label %129, label %137

129:                                              ; preds = %124
  %130 = mul i32 %24, 400
  %131 = getelementptr inbounds nuw i8, ptr %23, i32 %130
  %132 = load volatile i32, ptr %131, align 4, !tbaa !18
  %133 = and i32 %132, 65280
  %134 = icmp eq i32 %133, 0
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.6) #11
  %135 = call i32 @pause(i32 noundef 1000) #11
  %136 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #11
  br i1 %134, label %142, label %140

137:                                              ; preds = %113, %124
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.6) #11
  %138 = call i32 @pause(i32 noundef 1000) #11
  %139 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #11
  br label %140

140:                                              ; preds = %137, %129
  %141 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.7, i32 noundef 20) #11
  br label %147

142:                                              ; preds = %129
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.8) #11
  %143 = load i32, ptr %26, align 4, !tbaa !20
  call void @fputnum(i32 noundef 1, i32 noundef %143) #11
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.9) #11
  %144 = load i32, ptr %16, align 4, !tbaa !17
  call void @fputnum(i32 noundef 1, i32 noundef %144) #11
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.9) #11
  %145 = getelementptr inbounds nuw i8, ptr %1, i32 12
  %146 = load i32, ptr %145, align 4, !tbaa !26
  call void @fputnum(i32 noundef 1, i32 noundef %146) #11
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.10) #11
  br label %147

147:                                              ; preds = %142, %140
  %148 = phi i32 [ 0, %142 ], [ 1, %140 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %2) #12
  br label %149

149:                                              ; preds = %147, %10, %5
  %150 = phi i32 [ 1, %5 ], [ 1, %10 ], [ %148, %147 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %1) #12
  ret i32 %150
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 0, 2) i32 @t_show(i32 noundef %0, ptr noundef readonly captures(none) %1) unnamed_addr #4 {
  %3 = alloca [16 x i8], align 1
  %4 = alloca [24 x i8], align 1
  %5 = alloca [13 x i8], align 1
  %6 = alloca %struct.fbinfo, align 4
  %7 = alloca %struct.stat, align 4
  %8 = alloca %struct.stat, align 4
  %9 = alloca %struct.dirent, align 2
  %10 = alloca [64 x i8], align 1
  %11 = alloca i8, align 1
  %12 = alloca i8, align 1
  %13 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %6) #12
  %14 = call i32 @fbctl(i32 noundef 0, ptr noundef nonnull %6) #11
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %2
  %17 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.11, i32 noundef 12) #11
  br label %464

18:                                               ; preds = %2
  store i32 0, ptr @nshow, align 4, !tbaa !18
  store i32 -1, ptr @deckfd, align 4, !tbaa !18
  %19 = icmp eq i32 %0, 2
  br i1 %19, label %22, label %20

20:                                               ; preds = %18
  %21 = icmp eq i32 %0, 3
  br i1 %21, label %22, label %317

22:                                               ; preds = %20, %18
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %7) #12
  %23 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %24 = load ptr, ptr %23, align 4, !tbaa !3
  %25 = call i32 @open(ptr noundef %24, i32 noundef 0) #11
  %26 = icmp sgt i32 %25, -1
  br i1 %26, label %27, label %191

27:                                               ; preds = %22
  %28 = call i32 @fstat(i32 noundef %25, ptr noundef nonnull %7) #11
  %29 = icmp eq i32 %28, 0
  %30 = getelementptr inbounds nuw i8, ptr %7, i32 8
  %31 = load i16, ptr %30, align 4
  %32 = icmp eq i16 %31, 2
  %33 = select i1 %29, i1 %32, i1 false
  br i1 %33, label %34, label %189

34:                                               ; preds = %27
  %35 = icmp eq i32 %0, 3
  br i1 %35, label %36, label %39

36:                                               ; preds = %34
  %37 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %38 = load ptr, ptr %37, align 4, !tbaa !3
  br label %39

39:                                               ; preds = %34, %36
  %40 = phi ptr [ %38, %36 ], [ null, %34 ]
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #12
  %41 = call i32 @seek(i32 noundef range(i32 0, -2147483648) %25, i32 noundef 0) #11
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %128, label %43

43:                                               ; preds = %39
  %44 = call i32 @read(i32 noundef range(i32 0, -2147483648) %25, ptr noundef nonnull %3, i32 noundef 16) #11
  %45 = icmp eq i32 %44, 16
  br i1 %45, label %46, label %128

46:                                               ; preds = %43
  %47 = load i8, ptr %3, align 1, !tbaa !8
  %48 = icmp eq i8 %47, 83
  %49 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %50 = load i8, ptr %49, align 1
  %51 = icmp eq i8 %50, 76
  %52 = select i1 %48, i1 %51, i1 false
  %53 = getelementptr inbounds nuw i8, ptr %3, i32 2
  %54 = load i8, ptr %53, align 1
  %55 = icmp eq i8 %54, 68
  %56 = select i1 %52, i1 %55, i1 false
  %57 = getelementptr inbounds nuw i8, ptr %3, i32 3
  %58 = load i8, ptr %57, align 1
  %59 = icmp eq i8 %58, 75
  %60 = select i1 %56, i1 %59, i1 false
  br i1 %60, label %61, label %128

61:                                               ; preds = %46
  %62 = getelementptr inbounds nuw i8, ptr %3, i32 8
  %63 = load i8, ptr %62, align 1, !tbaa !8
  %64 = zext i8 %63 to i32
  %65 = getelementptr inbounds nuw i8, ptr %3, i32 9
  %66 = load i8, ptr %65, align 1, !tbaa !8
  %67 = zext i8 %66 to i32
  %68 = shl nuw nsw i32 %67, 8
  %69 = getelementptr inbounds nuw i8, ptr %3, i32 10
  %70 = load i8, ptr %69, align 1, !tbaa !8
  %71 = zext i8 %70 to i32
  %72 = shl nuw nsw i32 %71, 16
  %73 = getelementptr inbounds nuw i8, ptr %3, i32 11
  %74 = load i8, ptr %73, align 1, !tbaa !8
  %75 = zext i8 %74 to i32
  %76 = shl nuw i32 %75, 24
  %77 = or disjoint i32 %68, %72
  %78 = or disjoint i32 %77, %76
  %79 = or disjoint i32 %78, %64
  %80 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %81 = load i8, ptr %80, align 1, !tbaa !8
  %82 = zext i8 %81 to i32
  %83 = getelementptr inbounds nuw i8, ptr %3, i32 13
  %84 = load i8, ptr %83, align 1, !tbaa !8
  %85 = zext i8 %84 to i32
  %86 = shl nuw nsw i32 %85, 8
  %87 = or disjoint i32 %86, %82
  %88 = getelementptr inbounds nuw i8, ptr %3, i32 14
  %89 = load i8, ptr %88, align 1, !tbaa !8
  %90 = zext i8 %89 to i32
  %91 = shl nuw nsw i32 %90, 16
  %92 = or disjoint i32 %87, %91
  %93 = getelementptr inbounds nuw i8, ptr %3, i32 15
  %94 = load i8, ptr %93, align 1, !tbaa !8
  %95 = zext i8 %94 to i32
  %96 = shl nuw i32 %95, 24
  %97 = or disjoint i32 %92, %96
  store i32 %97, ptr @decksz, align 4, !tbaa !18
  %98 = icmp eq i32 %97, 0
  br i1 %98, label %128, label %99

99:                                               ; preds = %61
  %100 = icmp eq i32 %79, 0
  br i1 %100, label %128, label %101

101:                                              ; preds = %99
  %102 = icmp ugt i32 %79, 16
  br i1 %102, label %128, label %103

103:                                              ; preds = %101
  %104 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %105 = icmp eq ptr %40, null
  br label %106

106:                                              ; preds = %126, %103
  %107 = phi i32 [ %127, %126 ], [ 0, %103 ]
  %108 = icmp eq i32 %107, %64
  br i1 %108, label %128, label %109

109:                                              ; preds = %106
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %4) #12
  %110 = call i32 @read(i32 noundef range(i32 0, -2147483648) %25, ptr noundef nonnull %4, i32 noundef 24) #11
  %111 = icmp eq i32 %110, 24
  br i1 %111, label %113, label %112

112:                                              ; preds = %109
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %186

113:                                              ; preds = %109
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %5) #12
  br label %114

114:                                              ; preds = %118, %113
  %115 = phi i32 [ 0, %113 ], [ %122, %118 ]
  %116 = icmp eq i32 %115, 12
  br i1 %116, label %117, label %118

117:                                              ; preds = %114
  store i8 0, ptr %104, align 1, !tbaa !8
  br i1 %105, label %130, label %123

118:                                              ; preds = %114
  %119 = getelementptr inbounds nuw [24 x i8], ptr %4, i32 0, i32 %115
  %120 = load i8, ptr %119, align 1, !tbaa !8
  %121 = getelementptr inbounds nuw [13 x i8], ptr %5, i32 0, i32 %115
  store i8 %120, ptr %121, align 1, !tbaa !8
  %122 = add nuw nsw i32 %115, 1
  br label %114, !llvm.loop !27

123:                                              ; preds = %117
  %124 = call fastcc i32 @streq(ptr noundef nonnull %5, ptr noundef nonnull readonly %40) #9
  %125 = icmp eq i32 %124, 0
  br i1 %125, label %126, label %130

126:                                              ; preds = %123
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  %127 = add nuw nsw i32 %107, 1
  br label %106, !llvm.loop !28

128:                                              ; preds = %106, %43, %39, %46, %101, %99, %61
  %129 = phi i32 [ 0, %61 ], [ 0, %99 ], [ 0, %101 ], [ 0, %46 ], [ 0, %39 ], [ 0, %43 ], [ -1, %106 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  br label %183

130:                                              ; preds = %117, %123
  %131 = getelementptr inbounds nuw i8, ptr %4, i32 16
  %132 = load i8, ptr %131, align 1, !tbaa !8
  %133 = zext i8 %132 to i32
  %134 = getelementptr inbounds nuw i8, ptr %4, i32 17
  %135 = load i8, ptr %134, align 1, !tbaa !8
  %136 = zext i8 %135 to i32
  %137 = shl nuw nsw i32 %136, 8
  %138 = or disjoint i32 %137, %133
  %139 = getelementptr inbounds nuw i8, ptr %4, i32 18
  %140 = load i8, ptr %139, align 1, !tbaa !8
  %141 = zext i8 %140 to i32
  %142 = shl nuw nsw i32 %141, 16
  %143 = or disjoint i32 %138, %142
  %144 = getelementptr inbounds nuw i8, ptr %4, i32 19
  %145 = load i8, ptr %144, align 1, !tbaa !8
  %146 = zext i8 %145 to i32
  %147 = shl nuw i32 %146, 24
  %148 = or disjoint i32 %143, %147
  store i32 %148, ptr @deckoff, align 4, !tbaa !18
  store i32 %25, ptr @deckfd, align 4, !tbaa !18
  store i32 0, ptr @olen, align 4, !tbaa !18
  %149 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %150 = load i8, ptr %149, align 1, !tbaa !8
  %151 = zext i8 %150 to i32
  %152 = getelementptr inbounds nuw i8, ptr %4, i32 13
  %153 = load i8, ptr %152, align 1, !tbaa !8
  %154 = zext i8 %153 to i32
  %155 = shl nuw nsw i32 %154, 8
  %156 = or disjoint i32 %155, %151
  %157 = getelementptr inbounds nuw i8, ptr %4, i32 14
  %158 = load i8, ptr %157, align 1, !tbaa !8
  %159 = zext i8 %158 to i32
  %160 = shl nuw nsw i32 %159, 16
  %161 = or disjoint i32 %156, %160
  %162 = getelementptr inbounds nuw i8, ptr %4, i32 15
  %163 = load i8, ptr %162, align 1, !tbaa !8
  %164 = zext i8 %163 to i32
  %165 = shl nuw i32 %164, 24
  %166 = or disjoint i32 %161, %165
  call fastcc void @emitn(i32 noundef %166) #9
  call fastcc void @emit(ptr noundef nonnull @.str.25) #9
  call fastcc void @emit(ptr noundef nonnull %5) #9
  call fastcc void @emit(ptr noundef nonnull @.str.26) #9
  call fastcc void @flush() #9
  %167 = load i8, ptr %149, align 1, !tbaa !8
  %168 = zext i8 %167 to i32
  %169 = load i8, ptr %152, align 1, !tbaa !8
  %170 = zext i8 %169 to i32
  %171 = shl nuw nsw i32 %170, 8
  %172 = or disjoint i32 %171, %168
  %173 = load i8, ptr %157, align 1, !tbaa !8
  %174 = zext i8 %173 to i32
  %175 = shl nuw nsw i32 %174, 16
  %176 = or disjoint i32 %172, %175
  %177 = load i8, ptr %162, align 1, !tbaa !8
  %178 = zext i8 %177 to i32
  %179 = shl nuw i32 %178, 24
  %180 = or disjoint i32 %176, %179
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %5) #12
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #12
  %181 = icmp sgt i32 %180, 0
  br i1 %181, label %182, label %183

182:                                              ; preds = %130
  store i32 %180, ptr @nshow, align 4, !tbaa !18
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  br label %349

183:                                              ; preds = %128, %130
  %184 = phi i32 [ %129, %128 ], [ %180, %130 ]
  %185 = icmp slt i32 %184, 0
  br i1 %185, label %186, label %189

186:                                              ; preds = %112, %183
  %187 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.12, i32 noundef 29) #11
  %188 = call i32 @close(i32 noundef %25) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  br label %464

189:                                              ; preds = %27, %183
  %190 = call i32 @close(i32 noundef %25) #11
  br label %191

191:                                              ; preds = %189, %22
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %7) #12
  br i1 %19, label %194, label %192

192:                                              ; preds = %191
  %193 = load i32, ptr @nshow, align 4, !tbaa !18
  br label %317

194:                                              ; preds = %191
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %8) #12
  %195 = load ptr, ptr %23, align 4, !tbaa !3
  %196 = call i32 @open(ptr noundef %195, i32 noundef 0) #11
  %197 = icmp slt i32 %196, 0
  br i1 %197, label %315, label %198

198:                                              ; preds = %194
  %199 = call i32 @fstat(i32 noundef %196, ptr noundef nonnull %8) #11
  %200 = icmp slt i32 %199, 0
  br i1 %200, label %315, label %201

201:                                              ; preds = %198
  %202 = getelementptr inbounds nuw i8, ptr %8, i32 8
  %203 = load i16, ptr %202, align 4, !tbaa !29
  %204 = icmp eq i16 %203, 1
  br i1 %204, label %205, label %298

205:                                              ; preds = %201
  %206 = load ptr, ptr %23, align 4, !tbaa !3
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %9) #12
  %207 = getelementptr inbounds nuw i8, ptr %9, i32 2
  br label %208

208:                                              ; preds = %242, %205
  %209 = call i32 @read(i32 noundef %196, ptr noundef nonnull %9, i32 noundef 64) #11
  %210 = icmp eq i32 %209, 64
  br i1 %210, label %211, label %254

211:                                              ; preds = %208
  %212 = load i16, ptr %9, align 2, !tbaa !33
  %213 = icmp eq i16 %212, 0
  br i1 %213, label %242, label %214

214:                                              ; preds = %211, %214
  %215 = phi i32 [ %219, %214 ], [ 0, %211 ]
  %216 = getelementptr inbounds nuw i8, ptr %207, i32 %215
  %217 = load i8, ptr %216, align 1, !tbaa !8
  %218 = icmp eq i8 %217, 0
  %219 = add nuw nsw i32 %215, 1
  br i1 %218, label %220, label %214, !llvm.loop !35

220:                                              ; preds = %214
  %221 = getelementptr inbounds nuw i8, ptr %207, i32 %215
  %222 = icmp samesign ult i32 %215, 4
  br i1 %222, label %242, label %223

223:                                              ; preds = %220
  %224 = getelementptr inbounds i8, ptr %221, i32 -4
  %225 = load i8, ptr %224, align 1, !tbaa !8
  %226 = icmp eq i8 %225, 46
  br i1 %226, label %227, label %242

227:                                              ; preds = %223
  %228 = getelementptr inbounds i8, ptr %221, i32 -3
  %229 = load i8, ptr %228, align 1, !tbaa !8
  switch i8 %229, label %242 [
    i8 115, label %230
    i8 83, label %230
  ]

230:                                              ; preds = %227, %227
  %231 = getelementptr inbounds i8, ptr %221, i32 -2
  %232 = load i8, ptr %231, align 1, !tbaa !8
  switch i8 %232, label %242 [
    i8 108, label %233
    i8 76, label %233
  ]

233:                                              ; preds = %230, %230
  %234 = getelementptr inbounds i8, ptr %221, i32 -1
  %235 = load i8, ptr %234, align 1, !tbaa !8
  switch i8 %235, label %242 [
    i8 100, label %236
    i8 68, label %236
  ]

236:                                              ; preds = %233, %233
  %237 = load i8, ptr %207, align 2, !tbaa !8
  %238 = icmp eq i8 %237, 46
  br i1 %238, label %242, label %239

239:                                              ; preds = %236
  %240 = load i32, ptr @nshow, align 4, !tbaa !18
  %241 = icmp slt i32 %240, 32
  br i1 %241, label %243, label %242

242:                                              ; preds = %239, %246, %211, %220, %223, %227, %230, %233, %236
  br label %208, !llvm.loop !36

243:                                              ; preds = %239, %249
  %244 = phi i32 [ %253, %249 ], [ 0, %239 ]
  %245 = icmp eq i32 %244, 62
  br i1 %245, label %246, label %249

246:                                              ; preds = %243
  %247 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %240, i32 62
  store i8 0, ptr %247, align 1, !tbaa !8
  %248 = add nsw i32 %240, 1
  store i32 %248, ptr @nshow, align 4, !tbaa !18
  br label %242

249:                                              ; preds = %243
  %250 = getelementptr inbounds nuw [62 x i8], ptr %207, i32 0, i32 %244
  %251 = load i8, ptr %250, align 1, !tbaa !8
  %252 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %240, i32 %244
  store i8 %251, ptr %252, align 1, !tbaa !8
  %253 = add nuw nsw i32 %244, 1
  br label %243, !llvm.loop !37

254:                                              ; preds = %208
  %255 = call i32 @close(i32 noundef %196) #11
  br label %256

256:                                              ; preds = %291, %254
  %257 = phi i32 [ 1, %254 ], [ %292, %291 ]
  %258 = load i32, ptr @nshow, align 4, !tbaa !18
  %259 = icmp slt i32 %257, %258
  br i1 %259, label %261, label %260

260:                                              ; preds = %256
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %9) #12
  br label %312

261:                                              ; preds = %256
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %10) #12
  br label %262

262:                                              ; preds = %265, %261
  %263 = phi i32 [ 0, %261 ], [ %269, %265 ]
  %264 = icmp eq i32 %263, 64
  br i1 %264, label %270, label %265

265:                                              ; preds = %262
  %266 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %257, i32 %263
  %267 = load i8, ptr %266, align 1, !tbaa !8
  %268 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %263
  store i8 %267, ptr %268, align 1, !tbaa !8
  %269 = add nuw nsw i32 %263, 1
  br label %262, !llvm.loop !38

270:                                              ; preds = %278, %262
  %271 = phi i32 [ %257, %262 ], [ %272, %278 ]
  %272 = add nsw i32 %271, -1
  %273 = icmp sgt i32 %271, 0
  br i1 %273, label %274, label %286

274:                                              ; preds = %270
  %275 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %272
  %276 = call i32 @strcmp(ptr noundef nonnull %275, ptr noundef nonnull %10) #11
  %277 = icmp sgt i32 %276, 0
  br i1 %277, label %278, label %286

278:                                              ; preds = %274, %281
  %279 = phi i32 [ %285, %281 ], [ 0, %274 ]
  %280 = icmp eq i32 %279, 64
  br i1 %280, label %270, label %281, !llvm.loop !39

281:                                              ; preds = %278
  %282 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %272, i32 %279
  %283 = load i8, ptr %282, align 1, !tbaa !8
  %284 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %271, i32 %279
  store i8 %283, ptr %284, align 1, !tbaa !8
  %285 = add nuw nsw i32 %279, 1
  br label %278, !llvm.loop !40

286:                                              ; preds = %270, %274
  %287 = phi i32 [ 0, %270 ], [ %271, %274 ]
  br label %288

288:                                              ; preds = %293, %286
  %289 = phi i32 [ 0, %286 ], [ %297, %293 ]
  %290 = icmp eq i32 %289, 64
  br i1 %290, label %291, label %293

291:                                              ; preds = %288
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %10) #12
  %292 = add nuw nsw i32 %257, 1
  br label %256, !llvm.loop !41

293:                                              ; preds = %288
  %294 = getelementptr inbounds nuw [64 x i8], ptr %10, i32 0, i32 %289
  %295 = load i8, ptr %294, align 1, !tbaa !8
  %296 = getelementptr inbounds nuw [32 x [64 x i8]], ptr @shownames, i32 0, i32 %287, i32 %289
  store i8 %295, ptr %296, align 1, !tbaa !8
  %297 = add nuw nsw i32 %289, 1
  br label %288, !llvm.loop !42

298:                                              ; preds = %201
  %299 = call i32 @close(i32 noundef %196) #11
  br label %300

300:                                              ; preds = %309, %298
  %301 = phi i32 [ 0, %298 ], [ %311, %309 ]
  %302 = load ptr, ptr %23, align 4, !tbaa !3
  %303 = getelementptr inbounds nuw i8, ptr %302, i32 %301
  %304 = load i8, ptr %303, align 1, !tbaa !8
  %305 = icmp ne i8 %304, 0
  %306 = icmp samesign ult i32 %301, 63
  %307 = select i1 %305, i1 %306, i1 false
  br i1 %307, label %309, label %308

308:                                              ; preds = %300
  store i32 1, ptr @nshow, align 4, !tbaa !18
  br label %312

309:                                              ; preds = %300
  %310 = getelementptr inbounds nuw [64 x i8], ptr @shownames, i32 0, i32 %301
  store i8 %304, ptr %310, align 1, !tbaa !8
  %311 = add nuw nsw i32 %301, 1
  br label %300, !llvm.loop !43

312:                                              ; preds = %308, %260
  %313 = phi i32 [ 1, %308 ], [ %258, %260 ]
  %314 = phi ptr [ null, %308 ], [ %206, %260 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #12
  br label %342

315:                                              ; preds = %194, %198
  %316 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.13, i32 noundef 18) #11
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #12
  br label %464

317:                                              ; preds = %192, %20
  %318 = phi i32 [ %193, %192 ], [ 0, %20 ]
  %319 = icmp sgt i32 %0, 2
  br i1 %319, label %320, label %342

320:                                              ; preds = %317, %339
  %321 = phi i32 [ %340, %339 ], [ %318, %317 ]
  %322 = phi i32 [ %341, %339 ], [ 1, %317 ]
  %323 = icmp slt i32 %322, %0
  %324 = icmp slt i32 %321, 32
  %325 = select i1 %323, i1 %324, i1 false
  br i1 %325, label %326, label %342

326:                                              ; preds = %320
  %327 = getelementptr inbounds nuw ptr, ptr %1, i32 %322
  br label %328

328:                                              ; preds = %326, %337
  %329 = phi i32 [ %338, %337 ], [ 0, %326 ]
  %330 = load ptr, ptr %327, align 4, !tbaa !3
  %331 = getelementptr inbounds nuw i8, ptr %330, i32 %329
  %332 = load i8, ptr %331, align 1, !tbaa !8
  %333 = icmp ne i8 %332, 0
  %334 = icmp samesign ult i32 %329, 63
  %335 = select i1 %333, i1 %334, i1 false
  %336 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %321, i32 %329
  br i1 %335, label %337, label %339

337:                                              ; preds = %328
  store i8 %332, ptr %336, align 1, !tbaa !8
  %338 = add nuw nsw i32 %329, 1
  br label %328, !llvm.loop !44

339:                                              ; preds = %328
  store i8 0, ptr %336, align 1, !tbaa !8
  %340 = add nsw i32 %321, 1
  store i32 %340, ptr @nshow, align 4, !tbaa !18
  %341 = add nuw nsw i32 %322, 1
  br label %320, !llvm.loop !45

342:                                              ; preds = %320, %312, %317
  %343 = phi i32 [ %313, %312 ], [ %318, %317 ], [ %321, %320 ]
  %344 = phi ptr [ %314, %312 ], [ null, %317 ], [ null, %320 ]
  %345 = icmp eq i32 %343, 0
  br i1 %345, label %346, label %348

346:                                              ; preds = %342
  %347 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.14, i32 noundef 56) #11
  br label %464

348:                                              ; preds = %342
  call fastcc void @emitn(i32 noundef %343) #9
  call fastcc void @emit(ptr noundef nonnull @.str.15) #9
  call fastcc void @flush() #9
  br label %349

349:                                              ; preds = %182, %348
  %350 = phi i32 [ 1, %182 ], [ 0, %348 ]
  %351 = phi ptr [ null, %182 ], [ %344, %348 ]
  %352 = call i32 @fbctl(i32 noundef 1, ptr noundef null) #11
  %353 = icmp slt i32 %352, 0
  br i1 %353, label %354, label %356

354:                                              ; preds = %349
  %355 = call i32 @write(i32 noundef 2, ptr noundef nonnull @.str.16, i32 noundef 14) #11
  br label %464

356:                                              ; preds = %349
  %357 = call i32 @ttyraw(i32 noundef 1) #11
  %358 = getelementptr inbounds nuw i8, ptr %6, i32 8
  %359 = load i32, ptr %358, align 4, !tbaa !17
  %360 = getelementptr inbounds nuw i8, ptr %6, i32 16
  %361 = load i32, ptr %360, align 4, !tbaa !16
  %362 = mul i32 %361, %359
  %363 = load i32, ptr %6, align 4, !tbaa !13
  call fastcc void @show_slide(i32 noundef %350, ptr noundef %351, i32 noundef 0, i32 noundef %363, i32 noundef %362) #9
  br label %364

364:                                              ; preds = %454, %356
  %365 = phi i32 [ 0, %356 ], [ %455, %454 ]
  %366 = phi i32 [ 31, %356 ], [ %411, %454 ]
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %11) #12
  br label %367

367:                                              ; preds = %379, %364
  %368 = phi i32 [ 0, %364 ], [ %380, %379 ]
  %369 = phi i32 [ 0, %364 ], [ %371, %379 ]
  br label %370

370:                                              ; preds = %367, %377
  %371 = phi i32 [ %369, %367 ], [ 1, %377 ]
  br label %372

372:                                              ; preds = %370, %375
  %373 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %11, i32 noundef 1) #11
  %374 = icmp eq i32 %373, 1
  br i1 %374, label %375, label %398

375:                                              ; preds = %372
  %376 = load i8, ptr %11, align 1, !tbaa !8
  switch i8 %376, label %372 [
    i8 113, label %377
    i8 3, label %377
    i8 110, label %378
    i8 32, label %378
    i8 108, label %378
    i8 112, label %381
    i8 104, label %381
    i8 27, label %382
  ], !llvm.loop !46

377:                                              ; preds = %375, %375
  call fastcc void @show_log(ptr noundef nonnull @.str.17, ptr noundef null, ptr noundef null) #9
  br label %370, !llvm.loop !46

378:                                              ; preds = %375, %375, %375
  call fastcc void @show_log(ptr noundef nonnull @.str.18, ptr noundef null, ptr noundef null) #9
  br label %379

379:                                              ; preds = %378, %381, %396
  %380 = phi i32 [ %397, %396 ], [ -1, %381 ], [ 1, %378 ]
  br label %367, !llvm.loop !46

381:                                              ; preds = %375, %375
  call fastcc void @show_log(ptr noundef nonnull @.str.19, ptr noundef null, ptr noundef null) #9
  br label %379

382:                                              ; preds = %375
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %12) #12
  store i8 0, ptr %12, align 1, !tbaa !8
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %13) #12
  store i8 0, ptr %13, align 1, !tbaa !8
  %383 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %12, i32 noundef 1) #11
  %384 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %13, i32 noundef 1) #11
  %385 = load i8, ptr %12, align 1, !tbaa !8
  %386 = icmp eq i8 %385, 91
  %387 = load i8, ptr %13, align 1
  %388 = icmp eq i8 %387, 67
  %389 = select i1 %386, i1 %388, i1 false
  br i1 %389, label %393, label %390

390:                                              ; preds = %382
  %391 = icmp eq i8 %387, 68
  %392 = select i1 %386, i1 %391, i1 false
  br i1 %392, label %393, label %396

393:                                              ; preds = %390, %382
  %394 = phi ptr [ @.str.18, %382 ], [ @.str.19, %390 ]
  %395 = phi i32 [ 1, %382 ], [ -1, %390 ]
  call fastcc void @show_log(ptr noundef nonnull %394, ptr noundef null, ptr noundef null) #9
  br label %396

396:                                              ; preds = %393, %390
  %397 = phi i32 [ %368, %390 ], [ %395, %393 ]
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %13) #12
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %12) #12
  br label %379

398:                                              ; preds = %372
  %399 = call i32 @gpioctl(i32 noundef 2, i32 noundef 26, i32 noundef 0) #11
  %400 = call i32 @gpioctl(i32 noundef 2, i32 noundef 27, i32 noundef 0) #11
  %401 = shl i32 %400, 1
  %402 = or i32 %401, %399
  %403 = call i32 @gpioctl(i32 noundef 2, i32 noundef 28, i32 noundef 0) #11
  %404 = shl i32 %403, 2
  %405 = or i32 %402, %404
  %406 = call i32 @gpioctl(i32 noundef 2, i32 noundef 29, i32 noundef 0) #11
  %407 = shl i32 %406, 3
  %408 = or i32 %405, %407
  %409 = call i32 @gpioctl(i32 noundef 2, i32 noundef 24, i32 noundef 0) #11
  %410 = shl i32 %409, 4
  %411 = or i32 %408, %410
  %412 = xor i32 %411, -1
  %413 = and i32 %366, %412
  %414 = and i32 %413, 1
  %415 = icmp eq i32 %414, 0
  br i1 %415, label %417, label %416

416:                                              ; preds = %398
  call fastcc void @show_log(ptr noundef nonnull @.str.20, ptr noundef null, ptr noundef null) #9
  br label %417

417:                                              ; preds = %416, %398
  %418 = and i32 %413, 2
  %419 = icmp eq i32 %418, 0
  br i1 %419, label %421, label %420

420:                                              ; preds = %417
  call fastcc void @show_log(ptr noundef nonnull @.str.21, ptr noundef null, ptr noundef null) #9
  br label %421

421:                                              ; preds = %420, %417
  %422 = and i32 %413, 4
  %423 = icmp eq i32 %422, 0
  br i1 %423, label %425, label %424

424:                                              ; preds = %421
  call fastcc void @show_log(ptr noundef nonnull @.str.22, ptr noundef null, ptr noundef null) #9
  br label %425

425:                                              ; preds = %424, %421
  %426 = and i32 %413, 8
  %427 = icmp eq i32 %426, 0
  br i1 %427, label %429, label %428

428:                                              ; preds = %425
  call fastcc void @show_log(ptr noundef nonnull @.str.23, ptr noundef null, ptr noundef null) #9
  br label %429

429:                                              ; preds = %428, %425
  %430 = and i32 %413, 16
  %431 = icmp eq i32 %430, 0
  br i1 %431, label %433, label %432

432:                                              ; preds = %429
  call fastcc void @show_log(ptr noundef nonnull @.str.24, ptr noundef null, ptr noundef null) #9
  br label %433

433:                                              ; preds = %432, %429
  %434 = phi i32 [ 1, %432 ], [ %371, %429 ]
  %435 = and i32 %413, 10
  %436 = icmp eq i32 %435, 0
  %437 = and i32 %413, 5
  %438 = icmp eq i32 %437, 0
  %439 = select i1 %438, i32 %368, i32 -1
  %440 = select i1 %436, i32 %439, i32 1
  %441 = icmp eq i32 %434, 0
  br i1 %441, label %442, label %457

442:                                              ; preds = %433
  %443 = icmp eq i32 %440, 0
  br i1 %443, label %454, label %444

444:                                              ; preds = %442
  %445 = add nsw i32 %440, %365
  %446 = icmp slt i32 %445, 0
  %447 = load i32, ptr @nshow, align 4
  %448 = add nsw i32 %447, -1
  %449 = select i1 %446, i32 %448, i32 %445
  %450 = icmp slt i32 %449, %447
  %451 = select i1 %450, i32 %449, i32 0
  %452 = load i32, ptr %6, align 4, !tbaa !13
  call fastcc void @show_slide(i32 noundef %350, ptr noundef %351, i32 noundef %451, i32 noundef %452, i32 noundef %362) #9
  %453 = call i32 @pause(i32 noundef 8) #11
  br label %454

454:                                              ; preds = %442, %444
  %455 = phi i32 [ %451, %444 ], [ %365, %442 ]
  %456 = call i32 @pause(i32 noundef 2) #11
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %11) #12
  br label %364

457:                                              ; preds = %433
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %11) #12
  %458 = call i32 @ttyraw(i32 noundef 0) #11
  %459 = call i32 @fbctl(i32 noundef 2, ptr noundef null) #11
  %460 = load i32, ptr @deckfd, align 4, !tbaa !18
  %461 = icmp sgt i32 %460, -1
  br i1 %461, label %462, label %464

462:                                              ; preds = %457
  %463 = call i32 @close(i32 noundef %460) #11
  store i32 -1, ptr @deckfd, align 4, !tbaa !18
  br label %464

464:                                              ; preds = %315, %186, %346, %354, %462, %457, %16
  %465 = phi i32 [ 1, %16 ], [ 1, %346 ], [ 1, %354 ], [ 1, %315 ], [ 1, %186 ], [ 0, %462 ], [ 0, %457 ]
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %6) #12
  ret i32 %465
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @fbctl(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local void @fputnum(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #5

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none)
define internal fastcc void @emitn(i32 noundef %0) unnamed_addr #6 {
  %2 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %2) #12
  br label %3

3:                                                ; preds = %3, %1
  %4 = phi i32 [ %0, %1 ], [ %7, %3 ]
  %5 = phi i32 [ 0, %1 ], [ %12, %3 ]
  %6 = freeze i32 %4
  %7 = udiv i32 %6, 10
  %8 = mul i32 %7, 10
  %9 = sub i32 %6, %8
  %10 = trunc nuw nsw i32 %9 to i8
  %11 = or disjoint i8 %10, 48
  %12 = add nuw nsw i32 %5, 1
  %13 = getelementptr inbounds nuw [12 x i8], ptr %2, i32 0, i32 %5
  store i8 %11, ptr %13, align 1, !tbaa !8
  %14 = icmp ult i32 %4, 10
  br i1 %14, label %15, label %3, !llvm.loop !47

15:                                               ; preds = %3
  %16 = load i32, ptr @olen, align 4, !tbaa !18
  br label %17

17:                                               ; preds = %15, %21
  %18 = phi i32 [ %25, %21 ], [ %16, %15 ]
  %19 = phi i32 [ %22, %21 ], [ %12, %15 ]
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %27, label %21

21:                                               ; preds = %17
  %22 = add nsw i32 %19, -1
  %23 = getelementptr inbounds [12 x i8], ptr %2, i32 0, i32 %22
  %24 = load i8, ptr %23, align 1, !tbaa !8
  %25 = add nsw i32 %18, 1
  %26 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %18
  store i8 %24, ptr %26, align 1, !tbaa !8
  br label %17, !llvm.loop !48

27:                                               ; preds = %17
  store i32 %18, ptr @olen, align 4, !tbaa !18
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %2) #12
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none)
define internal fastcc void @emit(ptr noundef readonly captures(none) %0) unnamed_addr #7 {
  %2 = load i32, ptr @olen, align 4
  br label %3

3:                                                ; preds = %8, %1
  %4 = phi i32 [ %2, %1 ], [ %10, %8 ]
  %5 = phi ptr [ %0, %1 ], [ %9, %8 ]
  %6 = load i8, ptr %5, align 1, !tbaa !8
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %12, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %10 = add nsw i32 %4, 1
  store i32 %10, ptr @olen, align 4, !tbaa !18
  %11 = getelementptr inbounds [256 x i8], ptr @obuf, i32 0, i32 %4
  store i8 %6, ptr %11, align 1, !tbaa !8
  br label %3, !llvm.loop !49

12:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @flush() unnamed_addr #4 {
  %1 = load i32, ptr @olen, align 4, !tbaa !18
  %2 = tail call i32 @write(i32 noundef 1, ptr noundef nonnull @obuf, i32 noundef %1) #11
  store i32 0, ptr @olen, align 4, !tbaa !18
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @ttyraw(i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_slide(i32 noundef range(i32 0, 2) %0, ptr noundef readonly captures(address_is_null) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) unnamed_addr #4 {
  %6 = alloca [96 x i8], align 1
  %7 = icmp eq i32 %0, 0
  br i1 %7, label %8, label %62

8:                                                ; preds = %5
  %9 = getelementptr inbounds [32 x [64 x i8]], ptr @shownames, i32 0, i32 %2
  call void @llvm.lifetime.start.p0(i64 96, ptr nonnull %6) #12
  %10 = icmp eq ptr %1, null
  br i1 %10, label %29, label %11

11:                                               ; preds = %8, %18
  %12 = phi i32 [ %19, %18 ], [ 0, %8 ]
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 %12
  %14 = load i8, ptr %13, align 1, !tbaa !8
  %15 = icmp eq i8 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %11
  %17 = icmp eq i32 %12, 0
  br i1 %17, label %29, label %21

18:                                               ; preds = %11
  %19 = add nuw nsw i32 %12, 1
  %20 = getelementptr inbounds nuw [96 x i8], ptr %6, i32 0, i32 %12
  store i8 %14, ptr %20, align 1, !tbaa !8
  br label %11, !llvm.loop !50

21:                                               ; preds = %16
  %22 = add nsw i32 %12, -1
  %23 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %22
  %24 = load i8, ptr %23, align 1, !tbaa !8
  %25 = icmp eq i8 %24, 47
  br i1 %25, label %29, label %26

26:                                               ; preds = %21
  %27 = add nuw nsw i32 %12, 1
  %28 = getelementptr inbounds nuw [96 x i8], ptr %6, i32 0, i32 %12
  store i8 47, ptr %28, align 1, !tbaa !8
  br label %29

29:                                               ; preds = %26, %21, %16, %8
  %30 = phi i32 [ 0, %8 ], [ 0, %16 ], [ %12, %21 ], [ %27, %26 ]
  br label %31

31:                                               ; preds = %29, %43
  %32 = phi i32 [ %46, %43 ], [ 0, %29 ]
  %33 = phi i32 [ %44, %43 ], [ %30, %29 ]
  %34 = getelementptr inbounds nuw i8, ptr %9, i32 %32
  %35 = load i8, ptr %34, align 1, !tbaa !8
  %36 = icmp ne i8 %35, 0
  %37 = icmp slt i32 %33, 94
  %38 = select i1 %36, i1 %37, i1 false
  br i1 %38, label %43, label %39

39:                                               ; preds = %31
  %40 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 0, ptr %40, align 1, !tbaa !8
  %41 = call i32 @open(ptr noundef nonnull %6, i32 noundef 0) #11
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %60, label %47

43:                                               ; preds = %31
  %44 = add nsw i32 %33, 1
  %45 = getelementptr inbounds [96 x i8], ptr %6, i32 0, i32 %33
  store i8 %35, ptr %45, align 1, !tbaa !8
  %46 = add nuw nsw i32 %32, 1
  br label %31, !llvm.loop !51

47:                                               ; preds = %39
  call fastcc void @show_log(ptr noundef nonnull @.str.31, ptr noundef nonnull %6, ptr noundef null) #9
  call fastcc void @show_log(ptr noundef nonnull @.str.32, ptr noundef nonnull %6, ptr noundef nonnull @.str.33) #9
  br label %48

48:                                               ; preds = %51, %47
  %49 = phi i32 [ 0, %47 ], [ %57, %51 ]
  %50 = icmp ult i32 %49, %4
  br i1 %50, label %51, label %58

51:                                               ; preds = %48
  %52 = add i32 %49, %3
  %53 = inttoptr i32 %52 to ptr
  %54 = sub nuw i32 %4, %49
  %55 = call i32 @read(i32 noundef %41, ptr noundef %53, i32 noundef %54) #11
  %56 = icmp slt i32 %55, 1
  %57 = add i32 %55, %49
  br i1 %56, label %58, label %48

58:                                               ; preds = %51, %48
  %59 = call i32 @close(i32 noundef %41) #11
  br label %60

60:                                               ; preds = %39, %58
  %61 = phi ptr [ @.str.34, %58 ], [ @.str.30, %39 ]
  call fastcc void @show_log(ptr noundef nonnull %61, ptr noundef nonnull %6, ptr noundef null) #9
  call void @llvm.lifetime.end.p0(i64 96, ptr nonnull %6) #12
  br label %84

62:                                               ; preds = %5
  store i32 0, ptr @olen, align 4, !tbaa !18
  tail call fastcc void @emit(ptr noundef nonnull @.str.27) #9
  %63 = add i32 %2, 1
  tail call fastcc void @emitn(i32 noundef %63) #9
  tail call fastcc void @emit(ptr noundef nonnull @.str.28) #9
  tail call fastcc void @flush() #9
  %64 = load i32, ptr @deckfd, align 4, !tbaa !18
  %65 = load i32, ptr @deckoff, align 4, !tbaa !18
  %66 = load i32, ptr @decksz, align 4, !tbaa !18
  %67 = mul i32 %66, %2
  %68 = add i32 %67, %65
  %69 = tail call i32 @seek(i32 noundef %64, i32 noundef %68) #11
  %70 = load i32, ptr @decksz, align 4, !tbaa !18
  %71 = tail call i32 @llvm.umin.i32(i32 %70, i32 %4)
  br label %72

72:                                               ; preds = %75, %62
  %73 = phi i32 [ 0, %62 ], [ %82, %75 ]
  %74 = icmp ult i32 %73, %71
  br i1 %74, label %75, label %83

75:                                               ; preds = %72
  %76 = load i32, ptr @deckfd, align 4, !tbaa !18
  %77 = add i32 %73, %3
  %78 = inttoptr i32 %77 to ptr
  %79 = sub nuw i32 %71, %73
  %80 = tail call i32 @read(i32 noundef %76, ptr noundef %78, i32 noundef %79) #11
  %81 = icmp slt i32 %80, 1
  %82 = add i32 %80, %73
  br i1 %81, label %83, label %72

83:                                               ; preds = %75, %72
  store i32 0, ptr @olen, align 4, !tbaa !18
  tail call fastcc void @emit(ptr noundef nonnull @.str.29) #9
  tail call fastcc void @emitn(i32 noundef %63) #9
  tail call fastcc void @emit(ptr noundef nonnull @.str.10) #9
  tail call fastcc void @flush() #9
  br label %84

84:                                               ; preds = %83, %60
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @read_nb(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_log(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(address_is_null) %1, ptr noundef readonly captures(address_is_null) %2) unnamed_addr #4 {
  tail call fastcc void @emit(ptr noundef %0) #9
  %4 = icmp eq ptr %1, null
  br i1 %4, label %6, label %5

5:                                                ; preds = %3
  tail call fastcc void @emit(ptr noundef nonnull %1) #9
  br label %6

6:                                                ; preds = %5, %3
  %7 = icmp eq ptr %2, null
  br i1 %7, label %9, label %8

8:                                                ; preds = %6
  tail call fastcc void @emit(ptr noundef nonnull %2) #9
  br label %9

9:                                                ; preds = %8, %6
  tail call fastcc void @emit(ptr noundef nonnull @.str.10) #9
  tail call fastcc void @flush() #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @gpioctl(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare dso_local i32 @seek(i32 noundef, i32 noundef) local_unnamed_addr #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #8

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { minsize nobuiltin optsize "no-builtins" }
attributes #10 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #11 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #12 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"p1 omnipotent char", !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!6, !6, i64 0}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = !{!14, !15, i64 0}
!14 = !{!"fbinfo", !15, i64 0, !15, i64 4, !15, i64 8, !15, i64 12, !15, i64 16}
!15 = !{!"int", !6, i64 0}
!16 = !{!14, !15, i64 16}
!17 = !{!14, !15, i64 8}
!18 = !{!15, !15, i64 0}
!19 = distinct !{!19, !10, !11}
!20 = !{!14, !15, i64 4}
!21 = distinct !{!21, !10, !11}
!22 = distinct !{!22, !10, !11}
!23 = distinct !{!23, !10, !11}
!24 = distinct !{!24, !10, !11}
!25 = distinct !{!25, !10, !11}
!26 = !{!14, !15, i64 12}
!27 = distinct !{!27, !10, !11}
!28 = distinct !{!28, !10, !11}
!29 = !{!30, !31, i64 8}
!30 = !{!"stat", !15, i64 0, !15, i64 4, !31, i64 8, !31, i64 10, !32, i64 12}
!31 = !{!"short", !6, i64 0}
!32 = !{!"long", !6, i64 0}
!33 = !{!34, !31, i64 0}
!34 = !{!"dirent", !31, i64 0, !6, i64 2}
!35 = distinct !{!35, !10, !11}
!36 = distinct !{!36, !10, !11}
!37 = distinct !{!37, !10, !11}
!38 = distinct !{!38, !10, !11}
!39 = distinct !{!39, !10, !11}
!40 = distinct !{!40, !10, !11}
!41 = distinct !{!41, !10, !11}
!42 = distinct !{!42, !10, !11}
!43 = distinct !{!43, !10, !11}
!44 = distinct !{!44, !10, !11}
!45 = distinct !{!45, !10, !11}
!46 = distinct !{!46, !10, !11}
!47 = distinct !{!47, !10, !11}
!48 = distinct !{!48, !10, !11}
!49 = distinct !{!49, !10, !11}
!50 = distinct !{!50, !10, !11}
!51 = distinct !{!51, !10, !11}
