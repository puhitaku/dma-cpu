; ModuleID = 'user/vi.c'
source_filename = "user/vi.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.stat = type { i32, i32, i16, i16, i32 }
%struct.__va_list = type { ptr }

@ptr_to_globals = internal unnamed_addr global ptr null, align 4
@optind = internal unnamed_addr global i32 0, align 4
@.str = private unnamed_addr constant [9 x i8] c"\1B[?1049h\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"\1B[?1049l\00", align 1
@__malloc_chunkunits = external dso_local local_unnamed_addr global i32, align 4
@.str.2 = private unnamed_addr constant [19 x i8] c"vi: out of memory\0A\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"'%s' is not a regular file\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"can't read '%s'\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"'%s' (error)\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"\1B[7m\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"\1B[m\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"(null)\00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"Invalid range\00", align 1
@.str.10 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"delete\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"edit\00", align 1
@.str.13 = private unnamed_addr constant [44 x i8] c"No write since last change (:%s! overrides)\00", align 1
@.str.14 = private unnamed_addr constant [20 x i8] c"No current filename\00", align 1
@.str.15 = private unnamed_addr constant [16 x i8] c"'%s'%s %uL, %uC\00", align 1
@.str.16 = private unnamed_addr constant [12 x i8] c" [New file]\00", align 1
@.str.17 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"file\00", align 1
@.str.19 = private unnamed_addr constant [35 x i8] c"No address allowed on this command\00", align 1
@.str.20 = private unnamed_addr constant [9 x i8] c"features\00", align 1
@.str.21 = private unnamed_addr constant [5 x i8] c"list\00", align 1
@.str.22 = private unnamed_addr constant [5 x i8] c"quit\00", align 1
@.str.23 = private unnamed_addr constant [5 x i8] c"next\00", align 1
@.str.24 = private unnamed_addr constant [5 x i8] c"prev\00", align 1
@.str.25 = private unnamed_addr constant [24 x i8] c"%u more file(s) to edit\00", align 1
@.str.26 = private unnamed_addr constant [22 x i8] c"No more files to edit\00", align 1
@.str.27 = private unnamed_addr constant [26 x i8] c"No previous files to edit\00", align 1
@.str.28 = private unnamed_addr constant [5 x i8] c"read\00", align 1
@.str.29 = private unnamed_addr constant [14 x i8] c"'%s' %uL, %uC\00", align 1
@.str.30 = private unnamed_addr constant [7 x i8] c"rewind\00", align 1
@.str.31 = private unnamed_addr constant [19 x i8] c"No previous search\00", align 1
@.str.32 = private unnamed_addr constant [9 x i8] c"No match\00", align 1
@.str.33 = private unnamed_addr constant [8 x i8] c"version\00", align 1
@.str.34 = private unnamed_addr constant [11 x i8] c"1.38.0-dma\00", align 1
@.str.35 = private unnamed_addr constant [6 x i8] c"write\00", align 1
@.str.36 = private unnamed_addr constant [3 x i8] c"wq\00", align 1
@.str.37 = private unnamed_addr constant [3 x i8] c"wn\00", align 1
@.str.38 = private unnamed_addr constant [28 x i8] c"File exists (:w! overrides)\00", align 1
@.str.39 = private unnamed_addr constant [5 x i8] c"yank\00", align 1
@.str.40 = private unnamed_addr constant [35 x i8] c"Yank %d lines (%d chars) into [%c]\00", align 1
@.str.41 = private unnamed_addr constant [33 x i8] c":s expression missing delimiters\00", align 1
@.str.42 = private unnamed_addr constant [13 x i8] c"Mark not set\00", align 1
@.str.43 = private unnamed_addr constant [18 x i8] c"Pattern not found\00", align 1
@.str.44 = private unnamed_addr constant [106 x i8] c"These features are available:\0A\09Pattern searches with / and ?\0A\09Line marking with 'x\0A\09Named buffers with \22x\00", align 1
@.str.45 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.46 = private unnamed_addr constant [25 x i8] c"[Hit return to continue]\00", align 1
@.str.47 = private unnamed_addr constant [24 x i8] c"'%s' is not implemented\00", align 1
@.str.48 = private unnamed_addr constant [7 x i8] c"(NULL)\00", align 1
@.str.49 = private unnamed_addr constant [2 x i8] c"\07\00", align 1
@.str.50 = private unnamed_addr constant [7 x i8] c"\1B[H\1B[J\00", align 1
@.str.51 = private unnamed_addr constant [22 x i8] c"can't read user input\00", align 1
@bb_key_pending = internal unnamed_addr global i32 -1, align 4
@.str.52 = private unnamed_addr constant [23 x i8] c"Nothing in register %c\00", align 1
@.str.53 = private unnamed_addr constant [7 x i8] c"()[]{}\00", align 1
@.str.54 = private unnamed_addr constant [32 x i8] c"search hit %s, continuing at %s\00", align 1
@.str.55 = private unnamed_addr constant [7 x i8] c"BOTTOM\00", align 1
@.str.56 = private unnamed_addr constant [4 x i8] c"TOP\00", align 1
@.str.57 = private unnamed_addr constant [2 x i8] c":\00", align 1
@.str.58 = private unnamed_addr constant [21 x i8] c"Write error: (error)\00", align 1
@.str.59 = private unnamed_addr constant [6 x i8] c"cdy><\00", align 1
@.str.60 = private unnamed_addr constant [23 x i8] c"^%$0bBeEfFtThnN/?|{}\08\7F\00", align 1
@.str.61 = private unnamed_addr constant [5 x i8] c"nN/?\00", align 1
@.str.62 = private unnamed_addr constant [3 x i8] c"wW\00", align 1
@.str.63 = private unnamed_addr constant [12 x i8] c"GHL+-gjk'\0D\0A\00", align 1
@.str.64 = private unnamed_addr constant [15 x i8] c"^0bBFThnN/?|\08\7F\00", align 1
@.str.65 = private unnamed_addr constant [3 x i8] c"{}\00", align 1
@.str.66 = private unnamed_addr constant [15 x i8] c":%{}'GHLMz/?Nn\00", align 1
@.str.67 = private unnamed_addr constant [9 x i8] c"\1B[%u;%uH\00", align 1
@format_edit_status.cmd_mode_indicator = internal unnamed_addr constant [5 x i8] c"-IR-\00", align 1
@.str.68 = private unnamed_addr constant [19 x i8] c"%c %s%s %d/%d %d%%\00", align 1
@.str.69 = private unnamed_addr constant [8 x i8] c"No file\00", align 1
@.str.70 = private unnamed_addr constant [12 x i8] c" [Modified]\00", align 1
@.str.71 = private unnamed_addr constant [4 x i8] c"\1B[K\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local noundef i32 @vi_main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #0 {
  %3 = tail call fastcc ptr @xzalloc(i32 noundef 1056) #16
  store ptr %3, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 28
  %5 = load i32, ptr %4, align 4, !tbaa !8
  %6 = add nsw i32 %5, -1
  store i32 %6, ptr %4, align 4, !tbaa !8
  %7 = tail call fastcc ptr @xzalloc(i32 noundef 2) #16
  %8 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 100
  store ptr %7, ptr %9, align 4, !tbaa !14
  %10 = getelementptr inbounds nuw i8, ptr %8, i32 88
  store i32 8, ptr %10, align 4, !tbaa !15
  store i32 1, ptr @optind, align 4, !tbaa !16
  %11 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %12 = add nsw i32 %0, -1
  %13 = getelementptr inbounds nuw i8, ptr %8, i32 32
  store i32 %12, ptr %13, align 4, !tbaa !17
  tail call fastcc void @write1(ptr noundef nonnull @.str) #16
  store i32 0, ptr @optind, align 4, !tbaa !16
  %14 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %15

15:                                               ; preds = %103, %2
  %16 = phi ptr [ %106, %103 ], [ %14, %2 ]
  %17 = phi i32 [ %105, %103 ], [ 0, %2 ]
  %18 = getelementptr inbounds ptr, ptr %11, i32 %17
  %19 = load ptr, ptr %18, align 4, !tbaa !18
  %20 = getelementptr inbounds nuw i8, ptr %16, i32 16
  store i32 1, ptr %20, align 4, !tbaa !19
  tail call fastcc void @rawmode() #16
  %21 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %22 = getelementptr inbounds nuw i8, ptr %21, i32 44
  store i32 24, ptr %22, align 4, !tbaa !20
  %23 = getelementptr inbounds nuw i8, ptr %21, i32 48
  store i32 80, ptr %23, align 4, !tbaa !21
  %24 = getelementptr inbounds nuw i8, ptr %21, i32 80
  %25 = load ptr, ptr %24, align 4, !tbaa !22
  tail call fastcc void @bb_free(ptr noundef %25) #16
  %26 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %27 = getelementptr inbounds nuw i8, ptr %26, i32 84
  store i32 1928, ptr %27, align 4, !tbaa !23
  %28 = tail call fastcc ptr @xmalloc(i32 noundef 1928) #16
  %29 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %30 = getelementptr inbounds nuw i8, ptr %29, i32 80
  store ptr %28, ptr %30, align 4, !tbaa !22
  tail call fastcc void @screen_erase() #16
  br label %31

31:                                               ; preds = %35, %15
  %32 = phi i32 [ 22, %15 ], [ %36, %35 ]
  %33 = phi ptr [ %28, %15 ], [ %37, %35 ]
  %34 = icmp eq i32 %32, 0
  br i1 %34, label %38, label %35

35:                                               ; preds = %31
  %36 = add nsw i32 %32, -1
  %37 = getelementptr inbounds nuw i8, ptr %33, i32 80
  store i8 126, ptr %37, align 1, !tbaa !24
  br label %31, !llvm.loop !25

38:                                               ; preds = %31
  %39 = tail call fastcc i32 @init_text_buffer(ptr noundef %19) #16
  %40 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %41 = getelementptr inbounds nuw i8, ptr %40, i32 120
  store i32 26, ptr %41, align 4, !tbaa !28
  %42 = load ptr, ptr %40, align 4, !tbaa !29
  %43 = getelementptr inbounds nuw i8, ptr %40, i32 372
  store ptr %42, ptr %43, align 4, !tbaa !18
  %44 = getelementptr inbounds nuw i8, ptr %40, i32 368
  store ptr %42, ptr %44, align 4, !tbaa !18
  %45 = getelementptr inbounds nuw i8, ptr %40, i32 52
  store i32 0, ptr %45, align 4, !tbaa !30
  %46 = getelementptr inbounds nuw i8, ptr %40, i32 56
  store i32 0, ptr %46, align 4, !tbaa !31
  %47 = getelementptr inbounds nuw i8, ptr %40, i32 20
  store i32 0, ptr %47, align 4, !tbaa !32
  %48 = getelementptr inbounds nuw i8, ptr %40, i32 36
  store i32 0, ptr %48, align 4, !tbaa !33
  %49 = getelementptr inbounds nuw i8, ptr %40, i32 60
  store i32 0, ptr %49, align 4, !tbaa !34
  br label %52

50:                                               ; preds = %61
  %51 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %52, !llvm.loop !35

52:                                               ; preds = %50, %38
  %53 = phi ptr [ %51, %50 ], [ %40, %38 ]
  %54 = getelementptr inbounds nuw i8, ptr %53, i32 388
  %55 = load ptr, ptr %54, align 4, !tbaa !36
  %56 = icmp eq ptr %55, null
  br i1 %56, label %75, label %57

57:                                               ; preds = %52
  %58 = getelementptr inbounds nuw i8, ptr %55, i32 4
  %59 = load ptr, ptr %58, align 4, !tbaa !37
  %60 = load ptr, ptr %55, align 4, !tbaa !39
  store ptr %60, ptr %54, align 4, !tbaa !40
  tail call void @free(ptr noundef nonnull %55) #17
  br label %61

61:                                               ; preds = %73, %57
  %62 = phi ptr [ %59, %57 ], [ %74, %73 ]
  %63 = icmp eq ptr %62, null
  br i1 %63, label %50, label %64

64:                                               ; preds = %61
  %65 = tail call ptr @strchr(ptr noundef nonnull %62, i8 noundef signext 10) #17
  %66 = icmp eq ptr %65, null
  br i1 %66, label %73, label %67

67:                                               ; preds = %64, %71
  %68 = phi ptr [ %72, %71 ], [ %65, %64 ]
  %69 = load i8, ptr %68, align 1, !tbaa !24
  %70 = icmp eq i8 %69, 10
  br i1 %70, label %71, label %73

71:                                               ; preds = %67
  %72 = getelementptr inbounds nuw i8, ptr %68, i32 1
  store i8 0, ptr %68, align 1, !tbaa !24
  br label %67, !llvm.loop !41

73:                                               ; preds = %67, %64
  %74 = phi ptr [ null, %64 ], [ %68, %67 ]
  tail call fastcc void @colon(ptr noundef nonnull %62) #16
  br label %61, !llvm.loop !42

75:                                               ; preds = %52
  tail call fastcc void @redraw(i32 noundef 0) #16
  br label %76

76:                                               ; preds = %102, %75
  %77 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %78 = getelementptr inbounds nuw i8, ptr %77, i32 16
  %79 = load i32, ptr %78, align 4, !tbaa !19
  %80 = icmp sgt i32 %79, 0
  br i1 %80, label %81, label %103

81:                                               ; preds = %76
  %82 = tail call fastcc i32 @readit() #16
  %83 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %84 = getelementptr inbounds nuw i8, ptr %83, i32 8
  %85 = load ptr, ptr %84, align 4, !tbaa !43
  %86 = tail call fastcc ptr @begin_line(ptr noundef %85) #16
  %87 = getelementptr inbounds nuw i8, ptr %83, i32 108
  %88 = load ptr, ptr %87, align 4, !tbaa !44
  %89 = icmp eq ptr %86, %88
  br i1 %89, label %93, label %90

90:                                               ; preds = %81
  store ptr %86, ptr %87, align 4, !tbaa !44
  %91 = tail call fastcc ptr @begin_line(ptr noundef %85) #16
  %92 = tail call fastcc ptr @end_line(ptr noundef %85) #16
  tail call fastcc void @text_yank(ptr noundef %91, ptr noundef %92, i32 noundef 27, i32 noundef 0) #16
  br label %93

93:                                               ; preds = %90, %81
  tail call fastcc void @do_cmd(i32 noundef %82) #16
  %94 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %95 = getelementptr inbounds nuw i8, ptr %94, i32 392
  %96 = load i8, ptr %95, align 4, !tbaa !24
  %97 = icmp eq i8 %96, 0
  br i1 %97, label %98, label %102

98:                                               ; preds = %93
  %99 = tail call i32 @select(i32 noundef 1, i32 noundef 1) #17
  %100 = icmp eq i32 %99, 0
  br i1 %100, label %101, label %102

101:                                              ; preds = %98
  tail call fastcc void @refresh(i32 noundef 0) #16
  tail call fastcc void @show_status_line() #16
  br label %102

102:                                              ; preds = %101, %98, %93
  br label %76, !llvm.loop !45

103:                                              ; preds = %76
  tail call fastcc void @go_bottom_and_clear_to_eol() #16
  tail call fastcc void @cookmode() #16
  %104 = load i32, ptr @optind, align 4, !tbaa !16
  %105 = add nsw i32 %104, 1
  store i32 %105, ptr @optind, align 4, !tbaa !16
  %106 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %107 = getelementptr inbounds nuw i8, ptr %106, i32 32
  %108 = load i32, ptr %107, align 4, !tbaa !17
  %109 = icmp slt i32 %105, %108
  br i1 %109, label %15, label %110, !llvm.loop !46

110:                                              ; preds = %103
  tail call fastcc void @write1(ptr noundef nonnull @.str.1) #16
  ret i32 0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define internal fastcc noundef nonnull ptr @xzalloc(i32 noundef %0) unnamed_addr #0 {
  %2 = tail call fastcc ptr @xmalloc(i32 noundef %0) #16
  %3 = tail call ptr @memset(ptr noundef nonnull %2, i32 noundef 0, i32 noundef %0) #17
  ret ptr %2
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @write1(ptr noundef %0) unnamed_addr #0 {
  tail call void @fputstr(i32 noundef 1, ptr noundef %0) #17
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #2 {
  store i32 5120, ptr @__malloc_chunkunits, align 4, !tbaa !16
  %3 = tail call i32 @vi_main(i32 noundef %0, ptr noundef %1) #16
  %4 = tail call i32 @exit(i32 noundef 0) #18
  unreachable
}

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define internal fastcc nonnull ptr @xmalloc(i32 noundef %0) unnamed_addr #0 {
  %2 = tail call i32 @llvm.umax.i32(i32 %0, i32 1)
  %3 = tail call ptr @malloc(i32 noundef %2) #17
  %4 = icmp eq ptr %3, null
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.2) #17
  %6 = tail call i32 @exit(i32 noundef 1) #18
  unreachable

7:                                                ; preds = %1
  ret ptr %3
}

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local ptr @malloc(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @rawmode() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 378
  store i8 8, ptr %2, align 1, !tbaa !24
  %3 = tail call i32 @ttyraw(i32 noundef 1) #17
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, -2147483648) i32 @init_text_buffer(ptr noundef %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = load ptr, ptr %2, align 4, !tbaa !29
  tail call fastcc void @bb_free(ptr noundef %3) #16
  %4 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 12
  store i32 10240, ptr %5, align 4, !tbaa !47
  %6 = tail call fastcc ptr @xzalloc(i32 noundef 10240) #16
  %7 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  store ptr %6, ptr %7, align 4, !tbaa !29
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 4
  store ptr %6, ptr %8, align 4, !tbaa !48
  %9 = getelementptr inbounds nuw i8, ptr %7, i32 8
  store ptr %6, ptr %9, align 4, !tbaa !43
  %10 = getelementptr inbounds nuw i8, ptr %7, i32 76
  store ptr %6, ptr %10, align 4, !tbaa !49
  tail call fastcc void @update_filename(ptr noundef %0) #16
  %11 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %12 = load ptr, ptr %11, align 4, !tbaa !29
  %13 = tail call fastcc i32 @file_insert(ptr noundef %0, ptr noundef %12, i32 noundef 1) #16
  %14 = icmp slt i32 %13, 1
  %15 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 4
  %17 = load ptr, ptr %16, align 4, !tbaa !48
  br i1 %14, label %22, label %18

18:                                               ; preds = %1
  %19 = getelementptr inbounds i8, ptr %17, i32 -1
  %20 = load i8, ptr %19, align 1, !tbaa !24
  %21 = icmp eq i8 %20, 10
  br i1 %21, label %25, label %22

22:                                               ; preds = %1, %18
  %23 = tail call fastcc ptr @char_insert(ptr noundef %17, i8 noundef signext 10) #16
  %24 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %25

25:                                               ; preds = %22, %18
  %26 = phi ptr [ %24, %22 ], [ %15, %18 ]
  %27 = getelementptr inbounds nuw i8, ptr %26, i32 24
  store i32 0, ptr %27, align 4, !tbaa !50
  %28 = getelementptr inbounds nuw i8, ptr %26, i32 28
  store i32 -1, ptr %28, align 4, !tbaa !8
  %29 = getelementptr inbounds nuw i8, ptr %26, i32 264
  %30 = tail call ptr @memset(ptr noundef nonnull %29, i32 noundef 0, i32 noundef 112) #17
  ret i32 %13
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @redraw(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  tail call fastcc void @write1(ptr noundef nonnull @.str.50) #16
  tail call fastcc void @screen_erase() #16
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 68
  store i32 0, ptr %3, align 4, !tbaa !51
  tail call fastcc void @refresh(i32 noundef %0) #16
  tail call fastcc void @show_status_line() #16
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -11, -2147483648) i32 @readit() unnamed_addr #0 {
  %1 = alloca i8, align 1
  %2 = load i32, ptr @bb_key_pending, align 4, !tbaa !16
  %3 = icmp sgt i32 %2, -1
  br i1 %3, label %4, label %5

4:                                                ; preds = %0
  store i32 -1, ptr @bb_key_pending, align 4, !tbaa !16
  br label %40

5:                                                ; preds = %0
  %6 = tail call fastcc i32 @bb_readc() #16
  %7 = icmp eq i32 %6, 27
  br i1 %7, label %8, label %35

8:                                                ; preds = %5
  %9 = tail call i32 @pause(i32 noundef 2) #17
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %1) #19
  %10 = call i32 @read_nb(i32 noundef 0, ptr noundef nonnull %1, i32 noundef 1) #17
  %11 = icmp sgt i32 %10, 0
  %12 = load i8, ptr %1, align 1
  %13 = zext i8 %12 to i32
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %1) #19
  br i1 %11, label %14, label %40

14:                                               ; preds = %8
  switch i8 %12, label %15 [
    i8 91, label %16
    i8 79, label %16
  ]

15:                                               ; preds = %14
  store i32 %13, ptr @bb_key_pending, align 4, !tbaa !16
  br label %40

16:                                               ; preds = %14, %14
  %17 = call fastcc i32 @bb_readc() #16
  switch i32 %17, label %35 [
    i32 65, label %40
    i32 66, label %18
    i32 67, label %19
    i32 68, label %20
    i32 72, label %21
    i32 70, label %22
    i32 49, label %23
    i32 50, label %25
    i32 51, label %27
    i32 52, label %29
    i32 53, label %31
    i32 54, label %33
  ]

18:                                               ; preds = %16
  br label %40

19:                                               ; preds = %16
  br label %40

20:                                               ; preds = %16
  br label %40

21:                                               ; preds = %16
  br label %40

22:                                               ; preds = %16
  br label %40

23:                                               ; preds = %16
  %24 = call fastcc i32 @bb_readc() #16
  br label %40

25:                                               ; preds = %16
  %26 = call fastcc i32 @bb_readc() #16
  br label %40

27:                                               ; preds = %16
  %28 = call fastcc i32 @bb_readc() #16
  br label %40

29:                                               ; preds = %16
  %30 = call fastcc i32 @bb_readc() #16
  br label %40

31:                                               ; preds = %16
  %32 = call fastcc i32 @bb_readc() #16
  br label %40

33:                                               ; preds = %16
  %34 = call fastcc i32 @bb_readc() #16
  br label %40

35:                                               ; preds = %16, %5
  %36 = phi i32 [ %6, %5 ], [ %17, %16 ]
  %37 = icmp eq i32 %36, -1
  br i1 %37, label %38, label %40

38:                                               ; preds = %35
  call fastcc void @go_bottom_and_clear_to_eol() #16
  call fastcc void @cookmode() #16
  call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.51) #17
  call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.45) #17
  %39 = call i32 @exit(i32 noundef 1) #18
  unreachable

40:                                               ; preds = %16, %33, %31, %29, %27, %25, %23, %22, %21, %20, %19, %18, %8, %15, %4, %35
  %41 = phi i32 [ %36, %35 ], [ -2, %16 ], [ -11, %33 ], [ -10, %31 ], [ -7, %29 ], [ -9, %27 ], [ -8, %25 ], [ -6, %23 ], [ -7, %22 ], [ -6, %21 ], [ -5, %20 ], [ -4, %19 ], [ -3, %18 ], [ 27, %8 ], [ 27, %15 ], [ %2, %4 ]
  ret i32 %41
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @begin_line(ptr noundef %0) unnamed_addr #5 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = load ptr, ptr %2, align 4, !tbaa !29
  %4 = icmp ugt ptr %0, %3
  br i1 %4, label %5, label %19

5:                                                ; preds = %1
  %6 = ptrtoint ptr %0 to i32
  %7 = ptrtoint ptr %3 to i32
  %8 = sub i32 %6, %7
  br label %9

9:                                                ; preds = %12, %5
  %10 = phi i32 [ %8, %5 ], [ %13, %12 ]
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %19, label %12

12:                                               ; preds = %9
  %13 = add i32 %10, -1
  %14 = getelementptr inbounds nuw i8, ptr %3, i32 %13
  %15 = load i8, ptr %14, align 1, !tbaa !24
  %16 = icmp eq i8 %15, 10
  br i1 %16, label %17, label %9, !llvm.loop !52

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw i8, ptr %3, i32 %10
  br label %19

19:                                               ; preds = %9, %1, %17
  %20 = phi ptr [ %18, %17 ], [ %0, %1 ], [ %3, %9 ]
  ret ptr %20
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @text_yank(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef range(i32 0, -1) %3) unnamed_addr #0 {
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 124
  %7 = getelementptr inbounds [28 x ptr], ptr %6, i32 0, i32 %2
  %8 = load ptr, ptr %7, align 4, !tbaa !18
  %9 = ptrtoint ptr %1 to i32
  %10 = ptrtoint ptr %0 to i32
  %11 = sub i32 %9, %10
  %12 = icmp slt i32 %11, 0
  %13 = select i1 %12, ptr %1, ptr %0
  %14 = tail call i32 @llvm.abs.i32(i32 %11, i1 true)
  %15 = add nuw nsw i32 %14, 1
  %16 = tail call fastcc ptr @xstrndup(ptr noundef %13, i32 noundef %15) #16
  %17 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %18 = getelementptr inbounds nuw i8, ptr %17, i32 124
  %19 = getelementptr inbounds [28 x ptr], ptr %18, i32 0, i32 %2
  store ptr %16, ptr %19, align 4, !tbaa !18
  %20 = trunc i32 %3 to i8
  %21 = getelementptr inbounds nuw i8, ptr %17, i32 236
  %22 = getelementptr inbounds [28 x i8], ptr %21, i32 0, i32 %2
  store i8 %20, ptr %22, align 1, !tbaa !24
  tail call fastcc void @bb_free(ptr noundef %8) #16
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @end_line(ptr noundef %0) unnamed_addr #5 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %4 = load ptr, ptr %3, align 4, !tbaa !48
  %5 = getelementptr inbounds i8, ptr %4, i32 -1
  %6 = icmp ult ptr %0, %5
  br i1 %6, label %7, label %15

7:                                                ; preds = %1
  %8 = ptrtoint ptr %4 to i32
  %9 = ptrtoint ptr %0 to i32
  %10 = xor i32 %9, -1
  %11 = add i32 %8, %10
  %12 = tail call fastcc ptr @bb_memchr(ptr noundef %0, i32 noundef %11) #16
  %13 = icmp eq ptr %12, null
  %14 = select i1 %13, ptr %5, ptr %12
  br label %15

15:                                               ; preds = %7, %1
  %16 = phi ptr [ %0, %1 ], [ %14, %7 ]
  ret ptr %16
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @do_cmd(i32 noundef %0) unnamed_addr #0 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  %4 = alloca [12 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #19
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #19
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %4) #19
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 8
  %7 = load ptr, ptr %6, align 4, !tbaa !43
  %8 = call ptr @memset(ptr noundef nonnull %4, i32 noundef 0, i32 noundef 12) #17
  %9 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 384
  store i32 0, ptr %10, align 4, !tbaa !53
  %11 = getelementptr inbounds nuw i8, ptr %9, i32 104
  store i32 0, ptr %11, align 4, !tbaa !54
  call fastcc void @show_status_line() #16
  switch i32 %0, label %12 [
    i32 -2, label %63
    i32 -3, label %63
    i32 -5, label %63
    i32 -4, label %63
    i32 -6, label %63
    i32 -7, label %63
    i32 -10, label %63
    i32 -11, label %63
    i32 -9, label %63
  ]

12:                                               ; preds = %1
  %13 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 20
  %15 = load i32, ptr %14, align 4, !tbaa !32
  switch i32 %15, label %63 [
    i32 2, label %16
    i32 1, label %48
  ]

16:                                               ; preds = %12
  %17 = icmp eq i32 %0, -8
  br i1 %17, label %732, label %18

18:                                               ; preds = %16
  %19 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %20 = load ptr, ptr %19, align 4, !tbaa !43
  %21 = load i8, ptr %20, align 1, !tbaa !24
  %22 = icmp eq i8 %21, 10
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  store i32 1, ptr %14, align 4, !tbaa !32
  br label %48

24:                                               ; preds = %18
  %25 = icmp sgt i32 %0, 0
  br i1 %25, label %30, label %26

26:                                               ; preds = %24
  %27 = and i32 %0, 255
  %28 = add nsw i32 %27, -32
  %29 = icmp ult i32 %28, 95
  br i1 %29, label %32, label %1146

30:                                               ; preds = %24
  %31 = icmp eq i32 %0, 27
  br i1 %31, label %42, label %32

32:                                               ; preds = %26, %30
  %33 = getelementptr inbounds nuw i8, ptr %13, i32 378
  %34 = load i8, ptr %33, align 2, !tbaa !24
  %35 = zext i8 %34 to i32
  %36 = icmp eq i32 %0, %35
  br i1 %36, label %42, label %37

37:                                               ; preds = %32
  switch i32 %0, label %38 [
    i32 8, label %42
    i32 127, label %42
  ]

38:                                               ; preds = %37
  %39 = call fastcc ptr @yank_delete(ptr noundef nonnull %20, ptr noundef nonnull %20, i32 noundef 0, i32 noundef 1) #16
  %40 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %41 = getelementptr inbounds nuw i8, ptr %40, i32 8
  store ptr %39, ptr %41, align 4, !tbaa !43
  br label %42

42:                                               ; preds = %37, %37, %38, %32, %30
  %43 = phi ptr [ %20, %37 ], [ %20, %37 ], [ %39, %38 ], [ %20, %32 ], [ %20, %30 ]
  %44 = trunc i32 %0 to i8
  %45 = call fastcc ptr @char_insert(ptr noundef %43, i8 noundef signext %44) #16
  %46 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %47 = getelementptr inbounds nuw i8, ptr %46, i32 8
  store ptr %45, ptr %47, align 4, !tbaa !43
  br label %1146

48:                                               ; preds = %12, %23
  %49 = icmp eq i32 %0, -8
  br i1 %49, label %807, label %50

50:                                               ; preds = %48
  %51 = icmp sgt i32 %0, 0
  br i1 %51, label %56, label %52

52:                                               ; preds = %50
  %53 = and i32 %0, 255
  %54 = add nsw i32 %53, -32
  %55 = icmp ult i32 %54, 95
  br i1 %55, label %56, label %1146

56:                                               ; preds = %52, %50
  %57 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %58 = load ptr, ptr %57, align 4, !tbaa !43
  %59 = trunc i32 %0 to i8
  %60 = call fastcc ptr @char_insert(ptr noundef %58, i8 noundef signext %59) #16
  %61 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %62 = getelementptr inbounds nuw i8, ptr %61, i32 8
  store ptr %60, ptr %62, align 4, !tbaa !43
  br label %1146

63:                                               ; preds = %12, %1, %1, %1, %1, %1, %1, %1, %1, %1
  switch i32 %0, label %85 [
    i32 0, label %1146
    i32 2, label %88
    i32 -10, label %88
    i32 4, label %93
    i32 5, label %99
    i32 6, label %100
    i32 -11, label %100
    i32 7, label %105
    i32 104, label %108
    i32 -5, label %108
    i32 8, label %108
    i32 127, label %108
    i32 10, label %115
    i32 106, label %115
    i32 -3, label %115
    i32 13, label %115
    i32 43, label %115
    i32 12, label %143
    i32 18, label %143
    i32 21, label %144
    i32 25, label %150
    i32 27, label %151
    i32 32, label %162
    i32 108, label %162
    i32 -4, label %162
    i32 34, label %169
    i32 39, label %178
    i32 109, label %218
    i32 80, label %230
    i32 112, label %230
    i32 85, label %289
    i32 36, label %307
    i32 -7, label %307
    i32 37, label %321
    i32 102, label %380
    i32 70, label %380
    i32 116, label %380
    i32 84, label %380
    i32 59, label %385
    i32 44, label %385
    i32 78, label %431
    i32 63, label %438
    i32 47, label %438
    i32 110, label %64
    i32 123, label %520
    i32 125, label %520
    i32 48, label %561
    i32 49, label %561
    i32 50, label %561
    i32 51, label %561
    i32 52, label %561
    i32 53, label %561
    i32 54, label %561
    i32 55, label %561
    i32 56, label %561
    i32 57, label %561
    i32 58, label %573
    i32 60, label %575
    i32 62, label %575
    i32 65, label %623
    i32 97, label %624
    i32 66, label %632
    i32 69, label %632
    i32 87, label %632
    i32 67, label %664
    i32 68, label %664
    i32 103, label %685
    i32 71, label %66
    i32 72, label %713
    i32 73, label %731
    i32 105, label %732
    i32 -8, label %732
    i32 74, label %72
    i32 76, label %762
    i32 77, label %779
    i32 79, label %796
    i32 111, label %797
    i32 82, label %70
    i32 -9, label %813
    i32 88, label %825
    i32 120, label %825
    i32 115, label %825
    i32 90, label %852
    i32 94, label %907
    i32 98, label %908
    i32 101, label %908
    i32 99, label %961
    i32 100, label %961
    i32 121, label %961
    i32 89, label %961
    i32 107, label %998
    i32 -2, label %998
    i32 45, label %998
    i32 114, label %1027
    i32 119, label %79
    i32 122, label %1098
    i32 124, label %1116
    i32 126, label %74
    i32 -6, label %1145
  ]

64:                                               ; preds = %63
  %65 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %459

66:                                               ; preds = %63
  %67 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %68 = getelementptr inbounds nuw i8, ptr %67, i32 36
  %69 = load i32, ptr %68, align 4, !tbaa !33
  br label %702

70:                                               ; preds = %63
  %71 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %807

72:                                               ; preds = %63
  %73 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %735

74:                                               ; preds = %63
  %75 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %76 = getelementptr inbounds nuw i8, ptr %75, i32 8
  %77 = getelementptr inbounds nuw i8, ptr %75, i32 36
  %78 = getelementptr inbounds nuw i8, ptr %75, i32 24
  br label %1124

79:                                               ; preds = %63
  %80 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %81 = getelementptr inbounds nuw i8, ptr %80, i32 8
  %82 = load ptr, ptr %81, align 4, !tbaa !43
  %83 = getelementptr inbounds nuw i8, ptr %80, i32 4
  %84 = getelementptr inbounds nuw i8, ptr %80, i32 36
  br label %1058

85:                                               ; preds = %63
  %86 = trunc i32 %0 to i8
  store i8 %86, ptr %4, align 1, !tbaa !24
  %87 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store i8 0, ptr %87, align 1, !tbaa !24
  call fastcc void @not_implemented(ptr noundef %4) #16
  br label %1146

88:                                               ; preds = %63, %63
  %89 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %90 = getelementptr inbounds nuw i8, ptr %89, i32 44
  %91 = load i32, ptr %90, align 4, !tbaa !20
  %92 = add i32 %91, -2
  call fastcc void @dot_scroll(i32 noundef %92, i32 noundef -1) #16
  br label %1146

93:                                               ; preds = %63
  %94 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %95 = getelementptr inbounds nuw i8, ptr %94, i32 44
  %96 = load i32, ptr %95, align 4, !tbaa !20
  %97 = add i32 %96, -2
  %98 = lshr i32 %97, 1
  call fastcc void @dot_scroll(i32 noundef %98, i32 noundef 1) #16
  br label %1146

99:                                               ; preds = %63
  call fastcc void @dot_scroll(i32 noundef 1, i32 noundef 1) #16
  br label %1146

100:                                              ; preds = %63, %63
  %101 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %102 = getelementptr inbounds nuw i8, ptr %101, i32 44
  %103 = load i32, ptr %102, align 4, !tbaa !20
  %104 = add i32 %103, -2
  call fastcc void @dot_scroll(i32 noundef %104, i32 noundef 1) #16
  br label %1146

105:                                              ; preds = %63
  %106 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %107 = getelementptr inbounds nuw i8, ptr %106, i32 68
  store i32 0, ptr %107, align 4, !tbaa !51
  br label %1146

108:                                              ; preds = %63, %63, %63, %63
  %109 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %110 = getelementptr inbounds nuw i8, ptr %109, i32 36
  br label %111

111:                                              ; preds = %111, %108
  call fastcc void @dot_left() #16
  %112 = load i32, ptr %110, align 4, !tbaa !33
  %113 = add nsw i32 %112, -1
  store i32 %113, ptr %110, align 4, !tbaa !33
  %114 = icmp sgt i32 %112, 1
  br i1 %114, label %111, label %1146, !llvm.loop !55

115:                                              ; preds = %63, %63, %63, %63, %63
  %116 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %117 = getelementptr inbounds nuw i8, ptr %116, i32 8
  %118 = load ptr, ptr %117, align 4, !tbaa !43
  %119 = getelementptr inbounds nuw i8, ptr %116, i32 36
  br label %120

120:                                              ; preds = %126, %115
  %121 = phi ptr [ %122, %126 ], [ %118, %115 ]
  %122 = call fastcc ptr @next_line(ptr noundef %121) #16
  %123 = call fastcc ptr @end_line(ptr noundef %121) #16
  %124 = icmp eq ptr %122, %123
  br i1 %124, label %125, label %126

125:                                              ; preds = %120
  call fastcc void @indicate_error() #16
  br label %1146

126:                                              ; preds = %120
  %127 = load i32, ptr %119, align 4, !tbaa !33
  %128 = add nsw i32 %127, -1
  store i32 %128, ptr %119, align 4, !tbaa !33
  %129 = icmp sgt i32 %127, 1
  br i1 %129, label %120, label %130, !llvm.loop !56

130:                                              ; preds = %126
  store ptr %122, ptr %117, align 4, !tbaa !43
  switch i32 %0, label %132 [
    i32 13, label %131
    i32 43, label %131
  ]

131:                                              ; preds = %130, %130
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

132:                                              ; preds = %130
  %133 = getelementptr inbounds nuw i8, ptr %116, i32 380
  %134 = load i32, ptr %133, align 4, !tbaa !57
  %135 = icmp eq i32 %134, -1
  br i1 %135, label %136, label %138

136:                                              ; preds = %132
  %137 = call fastcc ptr @end_line(ptr noundef %122) #16
  br label %140

138:                                              ; preds = %132
  %139 = call fastcc ptr @move_to_col(ptr noundef %122, i32 noundef %134) #16
  br label %140

140:                                              ; preds = %138, %136
  %141 = phi ptr [ %137, %136 ], [ %139, %138 ]
  store ptr %141, ptr %117, align 4, !tbaa !43
  %142 = getelementptr inbounds nuw i8, ptr %116, i32 384
  store i32 1, ptr %142, align 4, !tbaa !53
  br label %1146

143:                                              ; preds = %63, %63
  call fastcc void @redraw(i32 noundef 1) #16
  br label %1146

144:                                              ; preds = %63
  %145 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %146 = getelementptr inbounds nuw i8, ptr %145, i32 44
  %147 = load i32, ptr %146, align 4, !tbaa !20
  %148 = add i32 %147, -2
  %149 = lshr i32 %148, 1
  call fastcc void @dot_scroll(i32 noundef %149, i32 noundef -1) #16
  br label %1146

150:                                              ; preds = %63
  call fastcc void @dot_scroll(i32 noundef 1, i32 noundef -1) #16
  br label %1146

151:                                              ; preds = %63
  %152 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %153 = getelementptr inbounds nuw i8, ptr %152, i32 20
  %154 = load i32, ptr %153, align 4, !tbaa !32
  %155 = icmp eq i32 %154, 0
  br i1 %155, label %156, label %158

156:                                              ; preds = %151
  call fastcc void @indicate_error() #16
  %157 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %158

158:                                              ; preds = %156, %151
  %159 = phi ptr [ %157, %156 ], [ %152, %151 ]
  %160 = getelementptr inbounds nuw i8, ptr %159, i32 20
  store i32 0, ptr %160, align 4, !tbaa !32
  %161 = getelementptr inbounds nuw i8, ptr %159, i32 68
  store i32 0, ptr %161, align 4, !tbaa !51
  br label %1146

162:                                              ; preds = %63, %63, %63
  %163 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %164 = getelementptr inbounds nuw i8, ptr %163, i32 36
  br label %165

165:                                              ; preds = %165, %162
  call fastcc void @dot_right() #16
  %166 = load i32, ptr %164, align 4, !tbaa !33
  %167 = add nsw i32 %166, -1
  store i32 %167, ptr %164, align 4, !tbaa !33
  %168 = icmp sgt i32 %166, 1
  br i1 %168, label %165, label %1146, !llvm.loop !58

169:                                              ; preds = %63
  %170 = call fastcc i32 @readit() #16
  %171 = or i32 %170, 32
  %172 = add nsw i32 %171, -97
  %173 = icmp ult i32 %172, 26
  br i1 %173, label %174, label %177

174:                                              ; preds = %169
  %175 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %176 = getelementptr inbounds nuw i8, ptr %175, i32 120
  store i32 %172, ptr %176, align 4, !tbaa !28
  br label %1146

177:                                              ; preds = %169
  call fastcc void @indicate_error() #16
  br label %1146

178:                                              ; preds = %63
  %179 = call fastcc i32 @readit() #16
  %180 = or i32 %179, 32
  %181 = add nsw i32 %180, -97
  %182 = icmp ult i32 %181, 26
  br i1 %182, label %183, label %197

183:                                              ; preds = %178
  %184 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %185 = getelementptr inbounds nuw i8, ptr %184, i32 264
  %186 = getelementptr inbounds nuw [28 x ptr], ptr %185, i32 0, i32 %181
  %187 = load ptr, ptr %186, align 4, !tbaa !18
  %188 = load ptr, ptr %184, align 4, !tbaa !29
  %189 = icmp ugt ptr %188, %187
  br i1 %189, label %196, label %190

190:                                              ; preds = %183
  %191 = getelementptr inbounds nuw i8, ptr %184, i32 4
  %192 = load ptr, ptr %191, align 4, !tbaa !48
  %193 = icmp ult ptr %187, %192
  br i1 %193, label %194, label %196

194:                                              ; preds = %190
  %195 = getelementptr inbounds nuw i8, ptr %184, i32 8
  store ptr %187, ptr %195, align 4, !tbaa !43
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

196:                                              ; preds = %190, %183
  call fastcc void @indicate_error() #16
  br label %1146

197:                                              ; preds = %178
  %198 = icmp eq i32 %180, 39
  br i1 %198, label %199, label %217

199:                                              ; preds = %197
  %200 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %201 = getelementptr inbounds nuw i8, ptr %200, i32 8
  %202 = load ptr, ptr %201, align 4, !tbaa !43
  %203 = load ptr, ptr %200, align 4, !tbaa !29
  %204 = getelementptr inbounds nuw i8, ptr %200, i32 372
  %205 = load ptr, ptr %204, align 4, !tbaa !18
  %206 = icmp ugt ptr %203, %205
  br i1 %206, label %214, label %207

207:                                              ; preds = %199
  %208 = getelementptr inbounds nuw i8, ptr %200, i32 4
  %209 = load ptr, ptr %208, align 4, !tbaa !48
  %210 = getelementptr inbounds i8, ptr %209, i32 -1
  %211 = icmp ugt ptr %205, %210
  br i1 %211, label %214, label %212

212:                                              ; preds = %207
  store ptr %202, ptr %204, align 4, !tbaa !18
  %213 = getelementptr inbounds nuw i8, ptr %200, i32 368
  store ptr %205, ptr %213, align 4, !tbaa !18
  br label %214

214:                                              ; preds = %199, %207, %212
  %215 = phi ptr [ %205, %212 ], [ %202, %207 ], [ %202, %199 ]
  store ptr %215, ptr %201, align 4, !tbaa !43
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  %216 = load ptr, ptr %201, align 4, !tbaa !43
  br label %1146

217:                                              ; preds = %197
  call fastcc void @indicate_error() #16
  br label %1146

218:                                              ; preds = %63
  %219 = call fastcc i32 @readit() #16
  %220 = or i32 %219, 32
  %221 = add nsw i32 %220, -97
  %222 = icmp ult i32 %221, 26
  br i1 %222, label %223, label %229

223:                                              ; preds = %218
  %224 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %225 = getelementptr inbounds nuw i8, ptr %224, i32 8
  %226 = load ptr, ptr %225, align 4, !tbaa !43
  %227 = getelementptr inbounds nuw i8, ptr %224, i32 264
  %228 = getelementptr inbounds nuw [28 x ptr], ptr %227, i32 0, i32 %221
  store ptr %226, ptr %228, align 4, !tbaa !18
  br label %1146

229:                                              ; preds = %218
  call fastcc void @indicate_error() #16
  br label %1146

230:                                              ; preds = %63, %63
  %231 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %232 = getelementptr inbounds nuw i8, ptr %231, i32 124
  %233 = getelementptr inbounds nuw i8, ptr %231, i32 120
  %234 = load i32, ptr %233, align 4, !tbaa !28
  %235 = getelementptr inbounds nuw [28 x ptr], ptr %232, i32 0, i32 %234
  %236 = load ptr, ptr %235, align 4, !tbaa !18
  %237 = icmp eq ptr %236, null
  br i1 %237, label %238, label %241

238:                                              ; preds = %230
  %239 = call fastcc signext i8 @what_reg() #16
  %240 = zext nneg i8 %239 to i32
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.52, i32 noundef %240) #16
  br label %1146

241:                                              ; preds = %230
  %242 = getelementptr inbounds nuw i8, ptr %231, i32 36
  %243 = load i32, ptr %242, align 4, !tbaa !33
  %244 = call i32 @llvm.umax.i32(i32 %243, i32 1)
  %245 = getelementptr inbounds nuw i8, ptr %231, i32 236
  %246 = getelementptr inbounds nuw [28 x i8], ptr %245, i32 0, i32 %234
  %247 = load i8, ptr %246, align 1, !tbaa !24
  %248 = icmp eq i8 %247, 1
  br i1 %248, label %249, label %262

249:                                              ; preds = %241
  %250 = icmp eq i32 %0, 80
  br i1 %250, label %251, label %252

251:                                              ; preds = %249
  call fastcc void @dot_begin() #16
  br label %272

252:                                              ; preds = %249
  %253 = getelementptr inbounds nuw i8, ptr %231, i32 8
  %254 = load ptr, ptr %253, align 4, !tbaa !43
  %255 = call fastcc ptr @end_line(ptr noundef %254) #16
  %256 = getelementptr inbounds nuw i8, ptr %231, i32 4
  %257 = load ptr, ptr %256, align 4, !tbaa !48
  %258 = getelementptr inbounds i8, ptr %257, i32 -1
  %259 = icmp eq ptr %255, %258
  br i1 %259, label %260, label %261

260:                                              ; preds = %252
  store ptr %257, ptr %253, align 4, !tbaa !43
  br label %272

261:                                              ; preds = %252
  call fastcc void @dot_next() #16
  br label %272

262:                                              ; preds = %241
  %263 = icmp eq i32 %0, 112
  br i1 %263, label %264, label %265

264:                                              ; preds = %262
  call fastcc void @dot_right() #16
  br label %265

265:                                              ; preds = %264, %262
  %266 = call ptr @strchr(ptr noundef nonnull %236, i8 noundef signext 10) #17
  %267 = icmp eq ptr %266, null
  br i1 %267, label %268, label %272

268:                                              ; preds = %265
  %269 = call i32 @strlen(ptr noundef nonnull %236) #17
  %270 = mul i32 %269, %244
  %271 = add i32 %270, -1
  br label %272

272:                                              ; preds = %265, %268, %251, %261, %260
  %273 = phi i32 [ 0, %251 ], [ 0, %260 ], [ 0, %261 ], [ %271, %268 ], [ 0, %265 ]
  %274 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %275

275:                                              ; preds = %275, %272
  %276 = phi ptr [ %280, %275 ], [ %274, %272 ]
  %277 = getelementptr inbounds nuw i8, ptr %276, i32 8
  %278 = load ptr, ptr %277, align 4, !tbaa !43
  %279 = call fastcc i32 @string_insert(ptr noundef %278, ptr noundef nonnull %236) #16
  %280 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %281 = getelementptr inbounds nuw i8, ptr %280, i32 36
  %282 = load i32, ptr %281, align 4, !tbaa !33
  %283 = add nsw i32 %282, -1
  store i32 %283, ptr %281, align 4, !tbaa !33
  %284 = icmp sgt i32 %282, 1
  br i1 %284, label %275, label %285, !llvm.loop !59

285:                                              ; preds = %275
  %286 = getelementptr inbounds nuw i8, ptr %280, i32 8
  %287 = load ptr, ptr %286, align 4, !tbaa !43
  %288 = getelementptr inbounds i8, ptr %287, i32 %273
  store ptr %288, ptr %286, align 4, !tbaa !43
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

289:                                              ; preds = %63
  %290 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %291 = getelementptr inbounds nuw i8, ptr %290, i32 232
  %292 = load ptr, ptr %291, align 4, !tbaa !18
  %293 = icmp eq ptr %292, null
  br i1 %293, label %1146, label %294

294:                                              ; preds = %289
  %295 = getelementptr inbounds nuw i8, ptr %290, i32 8
  %296 = load ptr, ptr %295, align 4, !tbaa !43
  %297 = call fastcc ptr @begin_line(ptr noundef %296) #16
  %298 = call fastcc ptr @end_line(ptr noundef %296) #16
  %299 = call fastcc ptr @text_hole_delete(ptr noundef %297, ptr noundef %298) #16
  %300 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %301 = getelementptr inbounds nuw i8, ptr %300, i32 232
  %302 = load ptr, ptr %301, align 4, !tbaa !18
  %303 = call fastcc i32 @string_insert(ptr noundef %299, ptr noundef %302) #16
  %304 = getelementptr inbounds nuw i8, ptr %299, i32 %303
  %305 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %306 = getelementptr inbounds nuw i8, ptr %305, i32 8
  store ptr %304, ptr %306, align 4, !tbaa !43
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

307:                                              ; preds = %63, %63
  %308 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %309 = getelementptr inbounds nuw i8, ptr %308, i32 8
  %310 = getelementptr inbounds nuw i8, ptr %308, i32 36
  br label %311

311:                                              ; preds = %317, %307
  %312 = load ptr, ptr %309, align 4, !tbaa !43
  %313 = call fastcc ptr @end_line(ptr noundef %312) #16
  store ptr %313, ptr %309, align 4, !tbaa !43
  %314 = load i32, ptr %310, align 4, !tbaa !33
  %315 = add nsw i32 %314, -1
  store i32 %315, ptr %310, align 4, !tbaa !33
  %316 = icmp slt i32 %314, 2
  br i1 %316, label %318, label %317

317:                                              ; preds = %311
  call fastcc void @dot_next() #16
  br label %311, !llvm.loop !60

318:                                              ; preds = %311
  %319 = getelementptr inbounds nuw i8, ptr %308, i32 380
  store i32 -1, ptr %319, align 4, !tbaa !57
  %320 = getelementptr inbounds nuw i8, ptr %308, i32 384
  store i32 1, ptr %320, align 4, !tbaa !53
  br label %1146

321:                                              ; preds = %63
  %322 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %323 = getelementptr inbounds nuw i8, ptr %322, i32 8
  %324 = load ptr, ptr %323, align 4, !tbaa !43
  br label %325

325:                                              ; preds = %373, %321
  %326 = phi ptr [ %322, %321 ], [ %375, %373 ]
  %327 = phi ptr [ %324, %321 ], [ %374, %373 ]
  %328 = getelementptr inbounds nuw i8, ptr %326, i32 4
  %329 = load ptr, ptr %328, align 4, !tbaa !48
  %330 = icmp ult ptr %327, %329
  br i1 %330, label %331, label %376

331:                                              ; preds = %325
  %332 = load i8, ptr %327, align 1, !tbaa !24
  %333 = icmp eq i8 %332, 10
  br i1 %333, label %379, label %334

334:                                              ; preds = %331
  %335 = call ptr @strchr(ptr noundef nonnull @.str.53, i8 noundef signext %332) #17
  %336 = icmp eq ptr %335, null
  br i1 %336, label %373, label %337

337:                                              ; preds = %334
  %338 = load i8, ptr %327, align 1, !tbaa !24
  %339 = call ptr @strchr(ptr noundef nonnull @.str.53, i8 noundef signext %338) #17
  %340 = ptrtoint ptr %339 to i32
  %341 = sub i32 %340, ptrtoint (ptr @.str.53 to i32)
  %342 = xor i32 %341, 1
  %343 = getelementptr inbounds i8, ptr @.str.53, i32 %342
  %344 = load i8, ptr %343, align 1, !tbaa !24
  %345 = shl i32 %342, 1
  %346 = and i32 %345, 2
  %347 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %348 = load ptr, ptr %347, align 4, !tbaa !29
  %349 = getelementptr inbounds nuw i8, ptr %347, i32 4
  br label %350

350:                                              ; preds = %368, %337
  %351 = phi ptr [ %327, %337 ], [ %354, %368 ]
  %352 = phi i32 [ 1, %337 ], [ %369, %368 ]
  %353 = getelementptr i8, ptr %351, i32 %346
  %354 = getelementptr i8, ptr %353, i32 -1
  %355 = icmp ult ptr %354, %348
  br i1 %355, label %370, label %356

356:                                              ; preds = %350
  %357 = load ptr, ptr %349, align 4, !tbaa !48
  %358 = icmp ult ptr %354, %357
  br i1 %358, label %359, label %370

359:                                              ; preds = %356
  %360 = load i8, ptr %354, align 1, !tbaa !24
  %361 = icmp eq i8 %360, %338
  %362 = zext i1 %361 to i32
  %363 = add nsw i32 %352, %362
  %364 = icmp eq i8 %360, %344
  br i1 %364, label %365, label %368

365:                                              ; preds = %359
  %366 = add nsw i32 %363, -1
  %367 = icmp eq i32 %366, 0
  br i1 %367, label %371, label %368

368:                                              ; preds = %365, %359
  %369 = phi i32 [ %366, %365 ], [ %363, %359 ]
  br label %350, !llvm.loop !61

370:                                              ; preds = %356, %350
  call fastcc void @indicate_error() #16
  br label %376

371:                                              ; preds = %365
  %372 = getelementptr inbounds nuw i8, ptr %347, i32 8
  store ptr %354, ptr %372, align 4, !tbaa !43
  br label %376

373:                                              ; preds = %334
  %374 = getelementptr inbounds nuw i8, ptr %327, i32 1
  %375 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %325, !llvm.loop !62

376:                                              ; preds = %325, %370, %371
  %377 = load i8, ptr %327, align 1, !tbaa !24
  %378 = icmp eq i8 %377, 10
  br i1 %378, label %379, label %1146

379:                                              ; preds = %331, %376
  call fastcc void @indicate_error() #16
  br label %1146

380:                                              ; preds = %63, %63, %63, %63
  %381 = call fastcc i32 @readit() #16
  %382 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %383 = getelementptr inbounds nuw i8, ptr %382, i32 92
  store i32 %381, ptr %383, align 4, !tbaa !63
  %384 = getelementptr inbounds nuw i8, ptr %382, i32 96
  store i32 %0, ptr %384, align 4, !tbaa !64
  br label %392

385:                                              ; preds = %63, %63
  %386 = icmp eq i32 %0, 44
  %387 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %388 = getelementptr inbounds nuw i8, ptr %387, i32 96
  %389 = load i32, ptr %388, align 4, !tbaa !64
  %390 = xor i32 %389, 32
  %391 = select i1 %386, i32 %390, i32 %389
  br label %392

392:                                              ; preds = %385, %380
  %393 = phi ptr [ %382, %380 ], [ %387, %385 ]
  %394 = phi i32 [ %0, %380 ], [ %391, %385 ]
  %395 = getelementptr inbounds nuw i8, ptr %393, i32 8
  %396 = add i32 %394, -123
  %397 = icmp ult i32 %396, -26
  %398 = select i1 %397, i32 -1, i32 1
  %399 = getelementptr inbounds nuw i8, ptr %393, i32 92
  %400 = load i32, ptr %399, align 4, !tbaa !63
  %401 = icmp eq i32 %400, 0
  br i1 %401, label %1146, label %402

402:                                              ; preds = %392
  %403 = load ptr, ptr %395, align 4, !tbaa !43
  %404 = getelementptr inbounds nuw i8, ptr %393, i32 4
  %405 = getelementptr inbounds nuw i8, ptr %393, i32 36
  br label %406

406:                                              ; preds = %423, %402
  %407 = phi ptr [ %403, %402 ], [ %408, %423 ]
  %408 = getelementptr inbounds i8, ptr %407, i32 %398
  br i1 %397, label %413, label %409

409:                                              ; preds = %406
  %410 = load ptr, ptr %404, align 4, !tbaa !48
  %411 = getelementptr inbounds i8, ptr %410, i32 -1
  %412 = icmp ugt ptr %408, %411
  br i1 %412, label %419, label %416

413:                                              ; preds = %406
  %414 = load ptr, ptr %393, align 4, !tbaa !29
  %415 = icmp ult ptr %408, %414
  br i1 %415, label %419, label %416

416:                                              ; preds = %413, %409
  %417 = load i8, ptr %408, align 1, !tbaa !24
  %418 = icmp eq i8 %417, 10
  br i1 %418, label %419, label %420

419:                                              ; preds = %416, %413, %409
  call fastcc void @indicate_error() #16
  br label %1146

420:                                              ; preds = %416
  %421 = sext i8 %417 to i32
  %422 = icmp eq i32 %400, %421
  br i1 %422, label %424, label %423

423:                                              ; preds = %420, %424
  br label %406, !llvm.loop !65

424:                                              ; preds = %420
  %425 = load i32, ptr %405, align 4, !tbaa !33
  %426 = add nsw i32 %425, -1
  store i32 %426, ptr %405, align 4, !tbaa !33
  %427 = icmp sgt i32 %425, 1
  br i1 %427, label %423, label %428

428:                                              ; preds = %424
  store ptr %408, ptr %395, align 4, !tbaa !43
  switch i32 %394, label %1146 [
    i32 116, label %429
    i32 84, label %430
  ]

429:                                              ; preds = %428
  call fastcc void @dot_left() #16
  br label %1146

430:                                              ; preds = %428
  call fastcc void @dot_right() #16
  br label %1146

431:                                              ; preds = %63
  %432 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %433 = getelementptr inbounds nuw i8, ptr %432, i32 100
  %434 = load ptr, ptr %433, align 4, !tbaa !14
  %435 = load i8, ptr %434, align 1, !tbaa !24
  %436 = icmp eq i8 %435, 47
  %437 = select i1 %436, i32 -1, i32 1
  br label %466

438:                                              ; preds = %63, %63
  %439 = trunc nuw nsw i32 %0 to i8
  store i8 %439, ptr %4, align 1, !tbaa !24
  %440 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store i8 0, ptr %440, align 1, !tbaa !24
  %441 = call fastcc ptr @get_input_line(ptr noundef nonnull %4) #16
  %442 = load i8, ptr %441, align 1, !tbaa !24
  %443 = icmp eq i8 %442, 0
  br i1 %443, label %1146, label %444

444:                                              ; preds = %438
  %445 = getelementptr inbounds nuw i8, ptr %441, i32 1
  %446 = load i8, ptr %445, align 1, !tbaa !24
  %447 = icmp eq i8 %446, 0
  %448 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %449 = getelementptr inbounds nuw i8, ptr %448, i32 100
  %450 = load ptr, ptr %449, align 4, !tbaa !14
  br i1 %447, label %451, label %455

451:                                              ; preds = %444
  %452 = load i8, ptr %450, align 1, !tbaa !24
  %453 = icmp eq i8 %452, 0
  br i1 %453, label %459, label %454

454:                                              ; preds = %451
  store i8 %439, ptr %450, align 1, !tbaa !24
  br label %459

455:                                              ; preds = %444
  call fastcc void @bb_free(ptr noundef %450) #16
  %456 = call fastcc ptr @xstrdup(ptr noundef nonnull %441) #16
  %457 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %458 = getelementptr inbounds nuw i8, ptr %457, i32 100
  store ptr %456, ptr %458, align 4, !tbaa !14
  br label %459

459:                                              ; preds = %64, %455, %454, %451
  %460 = phi ptr [ %65, %64 ], [ %457, %455 ], [ %448, %454 ], [ %448, %451 ]
  %461 = getelementptr inbounds nuw i8, ptr %460, i32 100
  %462 = load ptr, ptr %461, align 4, !tbaa !14
  %463 = load i8, ptr %462, align 1, !tbaa !24
  %464 = icmp eq i8 %463, 47
  %465 = select i1 %464, i32 1, i32 -1
  br label %466

466:                                              ; preds = %459, %431
  %467 = phi ptr [ %434, %431 ], [ %462, %459 ]
  %468 = phi ptr [ %432, %431 ], [ %460, %459 ]
  %469 = phi i32 [ %437, %431 ], [ %465, %459 ]
  %470 = getelementptr inbounds nuw i8, ptr %467, i32 1
  %471 = load i8, ptr %470, align 1, !tbaa !24
  %472 = icmp eq i8 %471, 0
  br i1 %472, label %477, label %473

473:                                              ; preds = %466
  %474 = shl nsw i32 %469, 1
  %475 = or disjoint i32 %474, 1
  %476 = icmp eq i32 %469, 1
  br label %478

477:                                              ; preds = %466
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.31) #16
  br label %1146

478:                                              ; preds = %473, %514
  %479 = phi ptr [ %468, %473 ], [ %515, %514 ]
  %480 = getelementptr inbounds nuw i8, ptr %479, i32 8
  %481 = load ptr, ptr %480, align 4, !tbaa !43
  %482 = getelementptr inbounds i8, ptr %481, i32 %469
  %483 = getelementptr inbounds nuw i8, ptr %479, i32 100
  %484 = load ptr, ptr %483, align 4, !tbaa !14
  %485 = getelementptr inbounds nuw i8, ptr %484, i32 1
  %486 = call fastcc ptr @char_search(ptr noundef nonnull %482, ptr noundef nonnull %485, i32 noundef %475) #16
  %487 = icmp eq ptr %486, null
  %488 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %487, label %491, label %489

489:                                              ; preds = %478
  %490 = getelementptr inbounds nuw i8, ptr %488, i32 8
  store ptr %486, ptr %490, align 4, !tbaa !43
  br label %514

491:                                              ; preds = %478
  br i1 %476, label %492, label %494

492:                                              ; preds = %491
  %493 = load ptr, ptr %488, align 4, !tbaa !29
  br label %498

494:                                              ; preds = %491
  %495 = getelementptr inbounds nuw i8, ptr %488, i32 4
  %496 = load ptr, ptr %495, align 4, !tbaa !48
  %497 = getelementptr inbounds i8, ptr %496, i32 -1
  br label %498

498:                                              ; preds = %494, %492
  %499 = phi ptr [ %493, %492 ], [ %497, %494 ]
  %500 = getelementptr inbounds nuw i8, ptr %488, i32 100
  %501 = load ptr, ptr %500, align 4, !tbaa !14
  %502 = getelementptr inbounds nuw i8, ptr %501, i32 1
  %503 = call fastcc ptr @char_search(ptr noundef %499, ptr noundef nonnull %502, i32 noundef %475) #16
  %504 = icmp eq ptr %503, null
  %505 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %504, label %508, label %506

506:                                              ; preds = %498
  %507 = getelementptr inbounds nuw i8, ptr %505, i32 8
  store ptr %503, ptr %507, align 4, !tbaa !43
  br label %510

508:                                              ; preds = %498
  %509 = getelementptr inbounds nuw i8, ptr %505, i32 36
  store i32 0, ptr %509, align 4, !tbaa !33
  br label %510

510:                                              ; preds = %508, %506
  %511 = phi ptr [ @.str.54, %506 ], [ @.str.43, %508 ]
  br i1 %476, label %512, label %513

512:                                              ; preds = %510
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull %511, ptr noundef nonnull @.str.55, ptr noundef nonnull @.str.56) #16
  br label %514

513:                                              ; preds = %510
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull %511, ptr noundef nonnull @.str.56, ptr noundef nonnull @.str.55) #16
  br label %514

514:                                              ; preds = %512, %513, %489
  %515 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %516 = getelementptr inbounds nuw i8, ptr %515, i32 36
  %517 = load i32, ptr %516, align 4, !tbaa !33
  %518 = add nsw i32 %517, -1
  store i32 %518, ptr %516, align 4, !tbaa !33
  %519 = icmp sgt i32 %517, 1
  br i1 %519, label %478, label %1146, !llvm.loop !66

520:                                              ; preds = %63, %63
  %521 = icmp eq i32 %0, 125
  %522 = select i1 %521, i32 1, i32 -1
  %523 = load ptr, ptr @ptr_to_globals, align 4
  %524 = getelementptr inbounds nuw i8, ptr %523, i32 8
  %525 = getelementptr inbounds nuw i8, ptr %523, i32 4
  %526 = getelementptr inbounds nuw i8, ptr %523, i32 36
  %527 = load ptr, ptr %524, align 4, !tbaa !43
  br label %528

528:                                              ; preds = %553, %520
  %529 = phi ptr [ %527, %520 ], [ %554, %553 ]
  %530 = phi i32 [ 1, %520 ], [ %555, %553 ]
  br i1 %521, label %531, label %535

531:                                              ; preds = %528
  %532 = load ptr, ptr %525, align 4, !tbaa !48
  %533 = getelementptr inbounds i8, ptr %532, i32 -1
  %534 = icmp ult ptr %529, %533
  br i1 %534, label %538, label %1146

535:                                              ; preds = %528
  %536 = load ptr, ptr %523, align 4, !tbaa !29
  %537 = icmp ugt ptr %529, %536
  br i1 %537, label %538, label %1146

538:                                              ; preds = %531, %535
  %539 = load i8, ptr %529, align 1, !tbaa !24
  %540 = icmp eq i8 %539, 10
  br i1 %540, label %541, label %550

541:                                              ; preds = %538
  %542 = getelementptr inbounds i8, ptr %529, i32 %522
  %543 = load i8, ptr %542, align 1, !tbaa !24
  %544 = icmp eq i8 %543, 10
  br i1 %544, label %545, label %550

545:                                              ; preds = %541
  %546 = icmp eq i32 %530, 0
  br i1 %546, label %547, label %550

547:                                              ; preds = %545
  br i1 %521, label %548, label %556

548:                                              ; preds = %547
  %549 = getelementptr inbounds nuw i8, ptr %529, i32 1
  store ptr %549, ptr %524, align 4, !tbaa !43
  br label %556

550:                                              ; preds = %538, %541, %545
  %551 = phi i32 [ 1, %545 ], [ 0, %541 ], [ 0, %538 ]
  %552 = getelementptr inbounds i8, ptr %529, i32 %522
  store ptr %552, ptr %524, align 4, !tbaa !43
  br label %553

553:                                              ; preds = %550, %556
  %554 = phi ptr [ %552, %550 ], [ %557, %556 ]
  %555 = phi i32 [ %551, %550 ], [ 1, %556 ]
  br label %528, !llvm.loop !67

556:                                              ; preds = %547, %548
  %557 = phi ptr [ %529, %547 ], [ %549, %548 ]
  %558 = load i32, ptr %526, align 4, !tbaa !33
  %559 = add nsw i32 %558, -1
  store i32 %559, ptr %526, align 4, !tbaa !33
  %560 = icmp sgt i32 %558, 1
  br i1 %560, label %553, label %1146

561:                                              ; preds = %63, %63, %63, %63, %63, %63, %63, %63, %63, %63
  %562 = icmp eq i32 %0, 48
  %563 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %564 = getelementptr inbounds nuw i8, ptr %563, i32 36
  %565 = load i32, ptr %564, align 4, !tbaa !33
  %566 = icmp slt i32 %565, 1
  %567 = select i1 %562, i1 %566, i1 false
  br i1 %567, label %568, label %569

568:                                              ; preds = %561
  call fastcc void @dot_begin() #16
  br label %1146

569:                                              ; preds = %561
  %570 = mul nsw i32 %565, 10
  %571 = add nsw i32 %0, -48
  %572 = add nsw i32 %571, %570
  store i32 %572, ptr %564, align 4, !tbaa !33
  br label %1146

573:                                              ; preds = %63
  %574 = call fastcc ptr @get_input_line(ptr noundef nonnull @.str.57) #16
  call fastcc void @colon(ptr noundef nonnull %574) #16
  br label %1146

575:                                              ; preds = %63, %63
  %576 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %577 = load ptr, ptr %576, align 4, !tbaa !29
  %578 = getelementptr inbounds nuw i8, ptr %576, i32 8
  %579 = load ptr, ptr %578, align 4, !tbaa !43
  %580 = call fastcc i32 @count_lines(ptr noundef %577, ptr noundef %579) #16
  %581 = call fastcc i32 @find_range(ptr noundef %2, ptr noundef %3, i32 noundef %0) #16
  %582 = icmp eq i32 %581, -1
  br i1 %582, label %1146, label %583

583:                                              ; preds = %575
  %584 = load ptr, ptr %2, align 4, !tbaa !18
  %585 = load ptr, ptr %3, align 4, !tbaa !18
  %586 = call fastcc i32 @count_lines(ptr noundef %584, ptr noundef %585) #16
  %587 = call fastcc ptr @begin_line(ptr noundef %584) #16
  %588 = icmp eq i32 %0, 60
  br label %589

589:                                              ; preds = %616, %583
  %590 = phi ptr [ %587, %583 ], [ %618, %616 ]
  %591 = phi i32 [ %586, %583 ], [ %617, %616 ]
  %592 = icmp sgt i32 %591, 0
  br i1 %592, label %593, label %619

593:                                              ; preds = %589
  br i1 %588, label %594, label %611

594:                                              ; preds = %593
  %595 = load i8, ptr %590, align 1, !tbaa !24
  switch i8 %595, label %616 [
    i8 9, label %596
    i8 32, label %598
  ]

596:                                              ; preds = %594
  %597 = call fastcc ptr @text_hole_delete(ptr noundef nonnull %590, ptr noundef nonnull %590) #16
  br label %616

598:                                              ; preds = %594, %607
  %599 = phi i8 [ %610, %607 ], [ %595, %594 ]
  %600 = phi i32 [ %609, %607 ], [ 0, %594 ]
  %601 = icmp eq i8 %599, 32
  br i1 %601, label %602, label %616

602:                                              ; preds = %598
  %603 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %604 = getelementptr inbounds nuw i8, ptr %603, i32 88
  %605 = load i32, ptr %604, align 4, !tbaa !15
  %606 = icmp slt i32 %600, %605
  br i1 %606, label %607, label %616

607:                                              ; preds = %602
  %608 = call fastcc ptr @text_hole_delete(ptr noundef nonnull %590, ptr noundef nonnull %590) #16
  %609 = add nuw nsw i32 %600, 1
  %610 = load i8, ptr %590, align 1, !tbaa !24
  br label %598, !llvm.loop !68

611:                                              ; preds = %593
  %612 = call fastcc ptr @end_line(ptr noundef %590) #16
  %613 = icmp eq ptr %590, %612
  br i1 %613, label %616, label %614

614:                                              ; preds = %611
  %615 = call fastcc ptr @char_insert(ptr noundef %590, i8 noundef signext 9) #16
  br label %616

616:                                              ; preds = %598, %602, %594, %596, %614, %611
  %617 = add nsw i32 %591, -1
  %618 = call fastcc ptr @next_line(ptr noundef %590) #16
  br label %589, !llvm.loop !69

619:                                              ; preds = %589
  %620 = call fastcc ptr @find_line(i32 noundef %580) #16
  %621 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %622 = getelementptr inbounds nuw i8, ptr %621, i32 8
  store ptr %620, ptr %622, align 4, !tbaa !43
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

623:                                              ; preds = %63
  call fastcc void @dot_end() #16
  br label %624

624:                                              ; preds = %63, %623
  %625 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %626 = getelementptr inbounds nuw i8, ptr %625, i32 8
  %627 = load ptr, ptr %626, align 4, !tbaa !43
  %628 = load i8, ptr %627, align 1, !tbaa !24
  %629 = icmp eq i8 %628, 10
  br i1 %629, label %732, label %630

630:                                              ; preds = %624
  %631 = getelementptr inbounds nuw i8, ptr %627, i32 1
  store ptr %631, ptr %626, align 4, !tbaa !43
  br label %732

632:                                              ; preds = %63, %63, %63
  %633 = icmp eq i32 %0, 66
  %634 = select i1 %633, i32 -1, i32 1
  %635 = icmp eq i32 %0, 87
  %636 = load ptr, ptr @ptr_to_globals, align 4
  %637 = getelementptr inbounds nuw i8, ptr %636, i32 8
  %638 = getelementptr inbounds nuw i8, ptr %636, i32 36
  %639 = load ptr, ptr %637, align 4, !tbaa !43
  br label %640

640:                                              ; preds = %659, %632
  %641 = phi ptr [ %660, %659 ], [ %639, %632 ]
  br i1 %635, label %656, label %642

642:                                              ; preds = %640
  %643 = getelementptr inbounds i8, ptr %641, i32 %634
  %644 = load i8, ptr %643, align 1, !tbaa !24
  %645 = sext i8 %644 to i32
  %646 = icmp ne i8 %644, 32
  %647 = add nsw i32 %645, -14
  %648 = icmp ult i32 %647, -5
  %649 = select i1 %646, i1 %648, i1 false
  br i1 %649, label %653, label %650

650:                                              ; preds = %642
  %651 = call fastcc ptr @skip_thing(ptr noundef nonnull %641, i32 noundef 1, i32 noundef %634, i32 noundef 2) #16
  store ptr %651, ptr %637, align 4, !tbaa !43
  %652 = call fastcc ptr @skip_thing(ptr noundef %651, i32 noundef 2, i32 noundef %634, i32 noundef 3) #16
  store ptr %652, ptr %637, align 4, !tbaa !43
  br label %653

653:                                              ; preds = %650, %642
  %654 = phi ptr [ %652, %650 ], [ %641, %642 ]
  %655 = call fastcc ptr @skip_thing(ptr noundef %654, i32 noundef 1, i32 noundef %634, i32 noundef 1) #16
  br label %659

656:                                              ; preds = %640
  %657 = call fastcc ptr @skip_thing(ptr noundef %641, i32 noundef 1, i32 noundef 1, i32 noundef 2) #16
  store ptr %657, ptr %637, align 4, !tbaa !43
  %658 = call fastcc ptr @skip_thing(ptr noundef %657, i32 noundef 2, i32 noundef 1, i32 noundef 3) #16
  br label %659

659:                                              ; preds = %656, %653
  %660 = phi ptr [ %655, %653 ], [ %658, %656 ]
  store ptr %660, ptr %637, align 4, !tbaa !43
  %661 = load i32, ptr %638, align 4, !tbaa !33
  %662 = add nsw i32 %661, -1
  store i32 %662, ptr %638, align 4, !tbaa !33
  %663 = icmp sgt i32 %661, 1
  br i1 %663, label %640, label %1146, !llvm.loop !70

664:                                              ; preds = %63, %63
  %665 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %666 = getelementptr inbounds nuw i8, ptr %665, i32 8
  %667 = load ptr, ptr %666, align 4, !tbaa !43
  %668 = call fastcc ptr @end_line(ptr noundef %667) #16
  %669 = load i8, ptr %668, align 1, !tbaa !24
  %670 = icmp eq i8 %669, 10
  br i1 %670, label %671, label %679

671:                                              ; preds = %664
  %672 = call fastcc ptr @begin_line(ptr noundef nonnull %668) #16
  %673 = ptrtoint ptr %668 to i32
  %674 = ptrtoint ptr %672 to i32
  %675 = sub i32 %673, %674
  %676 = icmp sgt i32 %675, 0
  %677 = sext i1 %676 to i32
  %678 = getelementptr inbounds i8, ptr %668, i32 %677
  br label %679

679:                                              ; preds = %664, %671
  %680 = phi ptr [ %668, %664 ], [ %678, %671 ]
  store ptr %680, ptr %666, align 4, !tbaa !43
  %681 = call fastcc ptr @yank_delete(ptr noundef %667, ptr noundef nonnull %680, i32 noundef 0, i32 noundef 1) #16
  %682 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %683 = getelementptr inbounds nuw i8, ptr %682, i32 8
  store ptr %681, ptr %683, align 4, !tbaa !43
  %684 = icmp eq i32 %0, 67
  br i1 %684, label %732, label %1146

685:                                              ; preds = %63
  %686 = call fastcc i32 @readit() #16
  %687 = icmp eq i32 %686, 103
  br i1 %687, label %696, label %688

688:                                              ; preds = %685
  store i8 103, ptr %4, align 1, !tbaa !24
  %689 = icmp sgt i32 %686, -1
  %690 = trunc i32 %686 to i8
  %691 = select i1 %689, i8 %690, i8 42
  %692 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store i8 %691, ptr %692, align 1, !tbaa !24
  %693 = getelementptr inbounds nuw i8, ptr %4, i32 2
  store i8 0, ptr %693, align 1, !tbaa !24
  call fastcc void @not_implemented(ptr noundef %4) #16
  %694 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %695 = getelementptr inbounds nuw i8, ptr %694, i32 104
  store i32 1, ptr %695, align 4, !tbaa !54
  br label %1146

696:                                              ; preds = %685
  %697 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %698 = getelementptr inbounds nuw i8, ptr %697, i32 36
  %699 = load i32, ptr %698, align 4, !tbaa !33
  %700 = icmp eq i32 %699, 0
  br i1 %700, label %701, label %702

701:                                              ; preds = %696
  store i32 1, ptr %698, align 4, !tbaa !33
  br label %702

702:                                              ; preds = %66, %696, %701
  %703 = phi i32 [ %69, %66 ], [ %699, %696 ], [ 1, %701 ]
  %704 = phi ptr [ %67, %66 ], [ %697, %696 ], [ %697, %701 ]
  %705 = getelementptr inbounds nuw i8, ptr %704, i32 4
  %706 = load ptr, ptr %705, align 4, !tbaa !48
  %707 = getelementptr inbounds i8, ptr %706, i32 -1
  %708 = getelementptr inbounds nuw i8, ptr %704, i32 8
  store ptr %707, ptr %708, align 4, !tbaa !43
  %709 = icmp sgt i32 %703, 0
  br i1 %709, label %710, label %712

710:                                              ; preds = %702
  %711 = call fastcc ptr @find_line(i32 noundef %703) #16
  store ptr %711, ptr %708, align 4, !tbaa !43
  br label %712

712:                                              ; preds = %710, %702
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

713:                                              ; preds = %63
  %714 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %715 = getelementptr inbounds nuw i8, ptr %714, i32 76
  %716 = load ptr, ptr %715, align 4, !tbaa !49
  %717 = getelementptr inbounds nuw i8, ptr %714, i32 8
  store ptr %716, ptr %717, align 4, !tbaa !43
  %718 = getelementptr inbounds nuw i8, ptr %714, i32 36
  %719 = load i32, ptr %718, align 4, !tbaa !33
  %720 = getelementptr inbounds nuw i8, ptr %714, i32 44
  %721 = load i32, ptr %720, align 4, !tbaa !20
  %722 = add i32 %721, -1
  %723 = call i32 @llvm.umin.i32(i32 %719, i32 %722)
  br label %724

724:                                              ; preds = %728, %713
  %725 = phi i32 [ %729, %728 ], [ %723, %713 ]
  %726 = add nsw i32 %725, -1
  store i32 %726, ptr %718, align 4, !tbaa !33
  %727 = icmp sgt i32 %725, 1
  br i1 %727, label %728, label %730

728:                                              ; preds = %724
  call fastcc void @dot_next() #16
  %729 = load i32, ptr %718, align 4, !tbaa !33
  br label %724, !llvm.loop !71

730:                                              ; preds = %724
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

731:                                              ; preds = %63
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %732

732:                                              ; preds = %985, %993, %996, %850, %798, %806, %731, %63, %63, %679, %624, %630, %16
  %733 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %734 = getelementptr inbounds nuw i8, ptr %733, i32 20
  store i32 1, ptr %734, align 4, !tbaa !32
  br label %1146

735:                                              ; preds = %72, %756
  %736 = phi ptr [ %73, %72 ], [ %757, %756 ]
  call fastcc void @dot_end() #16
  %737 = getelementptr inbounds nuw i8, ptr %736, i32 8
  %738 = load ptr, ptr %737, align 4, !tbaa !43
  %739 = getelementptr inbounds nuw i8, ptr %736, i32 4
  %740 = load ptr, ptr %739, align 4, !tbaa !48
  %741 = getelementptr inbounds i8, ptr %740, i32 -1
  %742 = icmp ult ptr %738, %741
  br i1 %742, label %743, label %756

743:                                              ; preds = %735
  %744 = getelementptr inbounds nuw i8, ptr %738, i32 1
  store ptr %744, ptr %737, align 4, !tbaa !43
  store i8 32, ptr %738, align 1, !tbaa !24
  %745 = getelementptr inbounds nuw i8, ptr %736, i32 24
  %746 = load i32, ptr %745, align 4, !tbaa !50
  %747 = add nsw i32 %746, 1
  store i32 %747, ptr %745, align 4, !tbaa !50
  br label %748

748:                                              ; preds = %753, %743
  %749 = phi ptr [ %755, %753 ], [ %736, %743 ]
  %750 = getelementptr inbounds nuw i8, ptr %749, i32 8
  %751 = load ptr, ptr %750, align 4, !tbaa !43
  %752 = load i8, ptr %751, align 1, !tbaa !24
  switch i8 %752, label %756 [
    i8 32, label %753
    i8 9, label %753
  ]

753:                                              ; preds = %748, %748
  %754 = call fastcc ptr @text_hole_delete(ptr noundef nonnull %751, ptr noundef nonnull %751) #16
  %755 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %748, !llvm.loop !72

756:                                              ; preds = %748, %735
  %757 = phi ptr [ %736, %735 ], [ %749, %748 ]
  %758 = getelementptr inbounds nuw i8, ptr %757, i32 36
  %759 = load i32, ptr %758, align 4, !tbaa !33
  %760 = add nsw i32 %759, -1
  store i32 %760, ptr %758, align 4, !tbaa !33
  %761 = icmp sgt i32 %759, 1
  br i1 %761, label %735, label %1146, !llvm.loop !73

762:                                              ; preds = %63
  %763 = call fastcc ptr @end_screen() #16
  %764 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %765 = getelementptr inbounds nuw i8, ptr %764, i32 8
  store ptr %763, ptr %765, align 4, !tbaa !43
  %766 = getelementptr inbounds nuw i8, ptr %764, i32 36
  %767 = load i32, ptr %766, align 4, !tbaa !33
  %768 = getelementptr inbounds nuw i8, ptr %764, i32 44
  %769 = load i32, ptr %768, align 4, !tbaa !20
  %770 = add i32 %769, -1
  %771 = call i32 @llvm.umin.i32(i32 %767, i32 %770)
  br label %772

772:                                              ; preds = %776, %762
  %773 = phi i32 [ %777, %776 ], [ %771, %762 ]
  %774 = add nsw i32 %773, -1
  store i32 %774, ptr %766, align 4, !tbaa !33
  %775 = icmp sgt i32 %773, 1
  br i1 %775, label %776, label %778

776:                                              ; preds = %772
  call fastcc void @dot_prev() #16
  %777 = load i32, ptr %766, align 4, !tbaa !33
  br label %772, !llvm.loop !74

778:                                              ; preds = %772
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

779:                                              ; preds = %63
  %780 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %781 = getelementptr inbounds nuw i8, ptr %780, i32 76
  %782 = load ptr, ptr %781, align 4, !tbaa !49
  %783 = getelementptr inbounds nuw i8, ptr %780, i32 8
  store ptr %782, ptr %783, align 4, !tbaa !43
  %784 = getelementptr inbounds nuw i8, ptr %780, i32 44
  %785 = load i32, ptr %784, align 4, !tbaa !20
  %786 = add i32 %785, -1
  %787 = lshr i32 %786, 1
  br label %788

788:                                              ; preds = %792, %779
  %789 = phi ptr [ %782, %779 ], [ %793, %792 ]
  %790 = phi i32 [ 0, %779 ], [ %794, %792 ]
  %791 = icmp eq i32 %790, %787
  br i1 %791, label %795, label %792

792:                                              ; preds = %788
  %793 = call fastcc ptr @next_line(ptr noundef %789) #16
  store ptr %793, ptr %783, align 4, !tbaa !43
  %794 = add nuw i32 %790, 1
  br label %788, !llvm.loop !75

795:                                              ; preds = %788
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

796:                                              ; preds = %63
  call fastcc void @dot_begin() #16
  br label %798

797:                                              ; preds = %63
  call fastcc void @dot_end() #16
  br label %798

798:                                              ; preds = %797, %796
  %799 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %800 = getelementptr inbounds nuw i8, ptr %799, i32 8
  %801 = load ptr, ptr %800, align 4, !tbaa !43
  %802 = call fastcc ptr @char_insert(ptr noundef %801, i8 noundef signext 10) #16
  %803 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %804 = getelementptr inbounds nuw i8, ptr %803, i32 8
  store ptr %802, ptr %804, align 4, !tbaa !43
  %805 = icmp eq i32 %0, 79
  br i1 %805, label %806, label %732

806:                                              ; preds = %798
  call fastcc void @dot_prev() #16
  br label %732

807:                                              ; preds = %70, %48
  %808 = phi ptr [ %71, %70 ], [ %13, %48 ]
  %809 = getelementptr inbounds nuw i8, ptr %808, i32 20
  store i32 2, ptr %809, align 4, !tbaa !32
  %810 = getelementptr inbounds nuw i8, ptr %808, i32 8
  %811 = load ptr, ptr %810, align 4, !tbaa !43
  %812 = getelementptr inbounds nuw i8, ptr %808, i32 40
  store ptr %811, ptr %812, align 4, !tbaa !76
  br label %1146

813:                                              ; preds = %63
  %814 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %815 = getelementptr inbounds nuw i8, ptr %814, i32 8
  %816 = load ptr, ptr %815, align 4, !tbaa !43
  %817 = getelementptr inbounds nuw i8, ptr %814, i32 4
  %818 = load ptr, ptr %817, align 4, !tbaa !48
  %819 = getelementptr inbounds i8, ptr %818, i32 -1
  %820 = icmp ult ptr %816, %819
  br i1 %820, label %821, label %1146

821:                                              ; preds = %813
  %822 = call fastcc ptr @yank_delete(ptr noundef %816, ptr noundef %816, i32 noundef 0, i32 noundef 1) #16
  %823 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %824 = getelementptr inbounds nuw i8, ptr %823, i32 8
  store ptr %822, ptr %824, align 4, !tbaa !43
  br label %1146

825:                                              ; preds = %63, %63, %63
  %826 = icmp eq i32 %0, 88
  %827 = sext i1 %826 to i32
  %828 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %829

829:                                              ; preds = %844, %825
  %830 = phi ptr [ %845, %844 ], [ %828, %825 ]
  %831 = getelementptr inbounds nuw i8, ptr %830, i32 8
  %832 = load ptr, ptr %831, align 4, !tbaa !43
  %833 = getelementptr inbounds i8, ptr %832, i32 %827
  %834 = load i8, ptr %833, align 1, !tbaa !24
  %835 = icmp eq i8 %834, 10
  br i1 %835, label %844, label %836

836:                                              ; preds = %829
  br i1 %826, label %837, label %839

837:                                              ; preds = %836
  %838 = getelementptr inbounds i8, ptr %832, i32 -1
  store ptr %838, ptr %831, align 4, !tbaa !43
  br label %839

839:                                              ; preds = %837, %836
  %840 = phi ptr [ %838, %837 ], [ %832, %836 ]
  %841 = call fastcc ptr @yank_delete(ptr noundef nonnull %840, ptr noundef nonnull %840, i32 noundef 0, i32 noundef 1) #16
  %842 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %843 = getelementptr inbounds nuw i8, ptr %842, i32 8
  store ptr %841, ptr %843, align 4, !tbaa !43
  br label %844

844:                                              ; preds = %829, %839
  %845 = phi ptr [ %830, %829 ], [ %842, %839 ]
  %846 = getelementptr inbounds nuw i8, ptr %845, i32 36
  %847 = load i32, ptr %846, align 4, !tbaa !33
  %848 = add nsw i32 %847, -1
  store i32 %848, ptr %846, align 4, !tbaa !33
  %849 = icmp sgt i32 %847, 1
  br i1 %849, label %829, label %850, !llvm.loop !77

850:                                              ; preds = %844
  %851 = icmp eq i32 %0, 115
  br i1 %851, label %732, label %1146

852:                                              ; preds = %63
  %853 = call fastcc i32 @readit() #16
  switch i32 %853, label %859 [
    i32 81, label %854
    i32 90, label %860
  ]

854:                                              ; preds = %852
  %855 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %856 = getelementptr inbounds nuw i8, ptr %855, i32 16
  store i32 0, ptr %856, align 4, !tbaa !19
  %857 = getelementptr inbounds nuw i8, ptr %855, i32 32
  %858 = load i32, ptr %857, align 4, !tbaa !17
  store i32 %858, ptr @optind, align 4, !tbaa !16
  br label %1146

859:                                              ; preds = %852
  call fastcc void @indicate_error() #16
  br label %1146

860:                                              ; preds = %852
  %861 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %862 = getelementptr inbounds nuw i8, ptr %861, i32 24
  %863 = load i32, ptr %862, align 4, !tbaa !50
  %864 = icmp eq i32 %863, 0
  br i1 %864, label %890, label %865

865:                                              ; preds = %860
  %866 = getelementptr inbounds nuw i8, ptr %861, i32 72
  %867 = load ptr, ptr %866, align 4, !tbaa !78
  %868 = load ptr, ptr %861, align 4, !tbaa !29
  %869 = getelementptr inbounds nuw i8, ptr %861, i32 4
  %870 = load ptr, ptr %869, align 4, !tbaa !48
  %871 = getelementptr inbounds i8, ptr %870, i32 -1
  %872 = call fastcc i32 @file_write(ptr noundef %867, ptr noundef %868, ptr noundef nonnull %871) #16
  %873 = icmp slt i32 %872, 0
  br i1 %873, label %874, label %877

874:                                              ; preds = %865
  %875 = icmp eq i32 %872, -1
  br i1 %875, label %876, label %892

876:                                              ; preds = %874
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.58) #16
  br label %892

877:                                              ; preds = %865
  %878 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %879 = getelementptr inbounds nuw i8, ptr %878, i32 4
  %880 = load ptr, ptr %879, align 4, !tbaa !48
  %881 = getelementptr inbounds i8, ptr %880, i32 -1
  %882 = load ptr, ptr %878, align 4, !tbaa !29
  %883 = ptrtoint ptr %881 to i32
  %884 = ptrtoint ptr %882 to i32
  %885 = sub i32 %883, %884
  %886 = add i32 %885, 1
  %887 = icmp eq i32 %872, %886
  br i1 %887, label %888, label %892

888:                                              ; preds = %877
  %889 = getelementptr inbounds nuw i8, ptr %878, i32 16
  store i32 0, ptr %889, align 4, !tbaa !19
  br label %892

890:                                              ; preds = %860
  %891 = getelementptr inbounds nuw i8, ptr %861, i32 16
  store i32 0, ptr %891, align 4, !tbaa !19
  br label %892

892:                                              ; preds = %876, %874, %888, %877, %890
  %893 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %894 = getelementptr inbounds nuw i8, ptr %893, i32 32
  %895 = load i32, ptr %894, align 4, !tbaa !17
  %896 = load i32, ptr @optind, align 4, !tbaa !16
  %897 = xor i32 %896, -1
  %898 = add i32 %895, %897
  %899 = getelementptr inbounds nuw i8, ptr %893, i32 16
  %900 = load i32, ptr %899, align 4, !tbaa !19
  %901 = icmp eq i32 %900, 0
  %902 = icmp sgt i32 %898, 0
  %903 = select i1 %901, i1 %902, i1 false
  br i1 %903, label %904, label %1146

904:                                              ; preds = %892
  store i32 1, ptr %899, align 4, !tbaa !19
  %905 = getelementptr inbounds nuw i8, ptr %893, i32 24
  store i32 0, ptr %905, align 4, !tbaa !50
  %906 = getelementptr inbounds nuw i8, ptr %893, i32 28
  store i32 -1, ptr %906, align 4, !tbaa !8
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.25, i32 noundef %898) #16
  br label %1146

907:                                              ; preds = %63
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

908:                                              ; preds = %63, %63
  %909 = icmp eq i32 %0, 98
  %910 = select i1 %909, i32 -1, i32 1
  %911 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %912 = getelementptr inbounds nuw i8, ptr %911, i32 8
  %913 = load ptr, ptr %911, align 4, !tbaa !29
  %914 = load ptr, ptr %912, align 4, !tbaa !43
  %915 = getelementptr inbounds nuw i8, ptr %911, i32 4
  %916 = icmp eq i32 %0, 101
  %917 = select i1 %916, i32 2, i32 1
  %918 = getelementptr inbounds nuw i8, ptr %911, i32 36
  br label %919

919:                                              ; preds = %956, %908
  %920 = phi ptr [ %957, %956 ], [ %914, %908 ]
  %921 = getelementptr inbounds i8, ptr %920, i32 %910
  %922 = icmp ult ptr %921, %913
  br i1 %922, label %1146, label %923

923:                                              ; preds = %919
  %924 = load ptr, ptr %915, align 4, !tbaa !48
  %925 = getelementptr inbounds i8, ptr %924, i32 -1
  %926 = icmp ugt ptr %921, %925
  br i1 %926, label %1146, label %927

927:                                              ; preds = %923
  store ptr %921, ptr %912, align 4, !tbaa !43
  %928 = load i8, ptr %921, align 1, !tbaa !24
  %929 = sext i8 %928 to i32
  %930 = icmp ne i8 %928, 32
  %931 = add nsw i32 %929, -14
  %932 = icmp ult i32 %931, -5
  %933 = select i1 %930, i1 %932, i1 false
  br i1 %933, label %938, label %934

934:                                              ; preds = %927
  %935 = call fastcc ptr @skip_thing(ptr noundef nonnull %921, i32 noundef %917, i32 noundef %910, i32 noundef 3) #16
  store ptr %935, ptr %912, align 4, !tbaa !43
  %936 = load i8, ptr %935, align 1, !tbaa !24
  %937 = sext i8 %936 to i32
  br label %938

938:                                              ; preds = %934, %927
  %939 = phi i32 [ %937, %934 ], [ %929, %927 ]
  %940 = phi i8 [ %936, %934 ], [ %928, %927 ]
  %941 = phi ptr [ %935, %934 ], [ %921, %927 ]
  %942 = and i32 %939, -33
  %943 = add nsw i32 %942, -91
  %944 = icmp ult i32 %943, -26
  %945 = add nsw i32 %939, -58
  %946 = icmp ult i32 %945, -10
  %947 = select i1 %944, i1 %946, i1 false
  br i1 %947, label %948, label %953

948:                                              ; preds = %938
  %949 = icmp eq i8 %940, 95
  br i1 %949, label %953, label %950

950:                                              ; preds = %948
  %951 = call fastcc i32 @bb_ispunct(i32 noundef %939) #16
  %952 = icmp eq i32 %951, 0
  br i1 %952, label %956, label %953

953:                                              ; preds = %950, %938, %948
  %954 = phi i32 [ 5, %948 ], [ 5, %938 ], [ 4, %950 ]
  %955 = call fastcc ptr @skip_thing(ptr noundef nonnull %941, i32 noundef 1, i32 noundef %910, i32 noundef %954) #16
  store ptr %955, ptr %912, align 4, !tbaa !43
  br label %956

956:                                              ; preds = %953, %950
  %957 = phi ptr [ %941, %950 ], [ %955, %953 ]
  %958 = load i32, ptr %918, align 4, !tbaa !33
  %959 = add nsw i32 %958, -1
  store i32 %959, ptr %918, align 4, !tbaa !33
  %960 = icmp sgt i32 %958, 1
  br i1 %960, label %919, label %1146, !llvm.loop !79

961:                                              ; preds = %63, %63, %63, %63
  %962 = add nsw i32 %0, -89
  %963 = and i32 %962, -33
  %964 = icmp ne i32 %963, 0
  %965 = zext i1 %964 to i32
  %966 = call fastcc i32 @find_range(ptr noundef %2, ptr noundef %3, i32 noundef %0) #16
  %967 = icmp eq i32 %966, -1
  br i1 %967, label %1146, label %968

968:                                              ; preds = %961
  %969 = icmp eq i32 %966, 1
  %970 = load ptr, ptr %2, align 4, !tbaa !18
  br i1 %969, label %973, label %971

971:                                              ; preds = %968
  %972 = load ptr, ptr %3, align 4, !tbaa !18
  br label %977

973:                                              ; preds = %968
  %974 = call fastcc ptr @begin_line(ptr noundef %970) #16
  %975 = load ptr, ptr %3, align 4, !tbaa !18
  %976 = call fastcc ptr @end_line(ptr noundef %975) #16
  br label %977

977:                                              ; preds = %971, %973
  %978 = phi ptr [ %976, %973 ], [ %972, %971 ]
  %979 = phi ptr [ %974, %973 ], [ %970, %971 ]
  %980 = phi ptr [ %970, %973 ], [ undef, %971 ]
  %981 = call fastcc ptr @yank_delete(ptr noundef %979, ptr noundef %978, i32 noundef %966, i32 noundef %965) #16
  %982 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %983 = getelementptr inbounds nuw i8, ptr %982, i32 8
  store ptr %981, ptr %983, align 4, !tbaa !43
  br i1 %969, label %984, label %996

984:                                              ; preds = %977
  switch i32 %0, label %995 [
    i32 99, label %985
    i32 100, label %994
  ]

985:                                              ; preds = %984
  %986 = call fastcc ptr @char_insert(ptr noundef %981, i8 noundef signext 10) #16
  %987 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %988 = getelementptr inbounds nuw i8, ptr %987, i32 8
  store ptr %986, ptr %988, align 4, !tbaa !43
  %989 = getelementptr inbounds nuw i8, ptr %987, i32 4
  %990 = load ptr, ptr %989, align 4, !tbaa !48
  %991 = getelementptr inbounds i8, ptr %990, i32 -1
  %992 = icmp eq ptr %986, %991
  br i1 %992, label %732, label %993

993:                                              ; preds = %985
  call fastcc void @dot_prev() #16
  br label %732

994:                                              ; preds = %984
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

995:                                              ; preds = %984
  store ptr %980, ptr %983, align 4, !tbaa !43
  br label %996

996:                                              ; preds = %995, %977
  %997 = icmp eq i32 %0, 99
  br i1 %997, label %732, label %1146

998:                                              ; preds = %63, %63, %63
  %999 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1000 = getelementptr inbounds nuw i8, ptr %999, i32 8
  %1001 = load ptr, ptr %1000, align 4, !tbaa !43
  %1002 = getelementptr inbounds nuw i8, ptr %999, i32 36
  br label %1003

1003:                                             ; preds = %1009, %998
  %1004 = phi ptr [ %1005, %1009 ], [ %1001, %998 ]
  %1005 = call fastcc ptr @prev_line(ptr noundef %1004) #16
  %1006 = call fastcc ptr @begin_line(ptr noundef %1004) #16
  %1007 = icmp eq ptr %1005, %1006
  br i1 %1007, label %1008, label %1009

1008:                                             ; preds = %1003
  call fastcc void @indicate_error() #16
  br label %1146

1009:                                             ; preds = %1003
  %1010 = load i32, ptr %1002, align 4, !tbaa !33
  %1011 = add nsw i32 %1010, -1
  store i32 %1011, ptr %1002, align 4, !tbaa !33
  %1012 = icmp sgt i32 %1010, 1
  br i1 %1012, label %1003, label %1013, !llvm.loop !80

1013:                                             ; preds = %1009
  store ptr %1005, ptr %1000, align 4, !tbaa !43
  %1014 = icmp eq i32 %0, 45
  br i1 %1014, label %1015, label %1016

1015:                                             ; preds = %1013
  call fastcc void @dot_skip_over_ws() #16
  br label %1146

1016:                                             ; preds = %1013
  %1017 = getelementptr inbounds nuw i8, ptr %999, i32 380
  %1018 = load i32, ptr %1017, align 4, !tbaa !57
  %1019 = icmp eq i32 %1018, -1
  br i1 %1019, label %1020, label %1022

1020:                                             ; preds = %1016
  %1021 = call fastcc ptr @end_line(ptr noundef %1005) #16
  br label %1024

1022:                                             ; preds = %1016
  %1023 = call fastcc ptr @move_to_col(ptr noundef %1005, i32 noundef %1018) #16
  br label %1024

1024:                                             ; preds = %1022, %1020
  %1025 = phi ptr [ %1021, %1020 ], [ %1023, %1022 ]
  store ptr %1025, ptr %1000, align 4, !tbaa !43
  %1026 = getelementptr inbounds nuw i8, ptr %999, i32 384
  store i32 1, ptr %1026, align 4, !tbaa !53
  br label %1146

1027:                                             ; preds = %63
  %1028 = call fastcc i32 @readit() #16
  %1029 = icmp eq i32 %1028, 27
  br i1 %1029, label %1146, label %1030

1030:                                             ; preds = %1027
  %1031 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1032 = getelementptr inbounds nuw i8, ptr %1031, i32 8
  %1033 = load ptr, ptr %1032, align 4, !tbaa !43
  %1034 = call fastcc ptr @end_line(ptr noundef %1033) #16
  %1035 = ptrtoint ptr %1034 to i32
  %1036 = ptrtoint ptr %1033 to i32
  %1037 = sub i32 %1035, %1036
  %1038 = getelementptr inbounds nuw i8, ptr %1031, i32 36
  %1039 = load i32, ptr %1038, align 4, !tbaa !33
  %1040 = call i32 @llvm.umax.i32(i32 %1039, i32 1)
  %1041 = icmp slt i32 %1037, %1040
  br i1 %1041, label %1044, label %1042

1042:                                             ; preds = %1030
  %1043 = trunc i32 %1028 to i8
  br label %1045

1044:                                             ; preds = %1030
  call fastcc void @indicate_error() #16
  br label %1146

1045:                                             ; preds = %1042, %1045
  %1046 = phi ptr [ %1033, %1042 ], [ %1050, %1045 ]
  %1047 = call fastcc ptr @text_hole_delete(ptr noundef %1046, ptr noundef %1046) #16
  %1048 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1049 = getelementptr inbounds nuw i8, ptr %1048, i32 8
  store ptr %1047, ptr %1049, align 4, !tbaa !43
  %1050 = call fastcc ptr @char_insert(ptr noundef %1047, i8 noundef signext %1043) #16
  %1051 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1052 = getelementptr inbounds nuw i8, ptr %1051, i32 8
  store ptr %1050, ptr %1052, align 4, !tbaa !43
  %1053 = getelementptr inbounds nuw i8, ptr %1051, i32 36
  %1054 = load i32, ptr %1053, align 4, !tbaa !33
  %1055 = add nsw i32 %1054, -1
  store i32 %1055, ptr %1053, align 4, !tbaa !33
  %1056 = icmp sgt i32 %1054, 1
  br i1 %1056, label %1045, label %1057, !llvm.loop !81

1057:                                             ; preds = %1045
  call fastcc void @dot_left() #16
  br label %1146

1058:                                             ; preds = %79, %1093
  %1059 = phi ptr [ %82, %79 ], [ %1094, %1093 ]
  %1060 = load i8, ptr %1059, align 1, !tbaa !24
  %1061 = sext i8 %1060 to i32
  %1062 = and i32 %1061, -33
  %1063 = add nsw i32 %1062, -91
  %1064 = icmp ult i32 %1063, -26
  %1065 = add nsw i32 %1061, -58
  %1066 = icmp ult i32 %1065, -10
  %1067 = select i1 %1064, i1 %1066, i1 false
  br i1 %1067, label %1068, label %1073

1068:                                             ; preds = %1058
  %1069 = icmp eq i8 %1060, 95
  br i1 %1069, label %1073, label %1070

1070:                                             ; preds = %1068
  %1071 = call fastcc i32 @bb_ispunct(i32 noundef %1061) #16
  %1072 = icmp eq i32 %1071, 0
  br i1 %1072, label %1076, label %1073

1073:                                             ; preds = %1070, %1058, %1068
  %1074 = phi i32 [ 5, %1068 ], [ 5, %1058 ], [ 4, %1070 ]
  %1075 = call fastcc ptr @skip_thing(ptr noundef nonnull %1059, i32 noundef 1, i32 noundef 1, i32 noundef %1074) #16
  store ptr %1075, ptr %81, align 4, !tbaa !43
  br label %1076

1076:                                             ; preds = %1073, %1070
  %1077 = phi ptr [ %1059, %1070 ], [ %1075, %1073 ]
  %1078 = load ptr, ptr %83, align 4, !tbaa !48
  %1079 = getelementptr inbounds i8, ptr %1078, i32 -1
  %1080 = icmp ult ptr %1077, %1079
  br i1 %1080, label %1081, label %1083

1081:                                             ; preds = %1076
  %1082 = getelementptr inbounds nuw i8, ptr %1077, i32 1
  store ptr %1082, ptr %81, align 4, !tbaa !43
  br label %1083

1083:                                             ; preds = %1081, %1076
  %1084 = phi ptr [ %1082, %1081 ], [ %1077, %1076 ]
  %1085 = load i8, ptr %1084, align 1, !tbaa !24
  %1086 = sext i8 %1085 to i32
  %1087 = icmp ne i8 %1085, 32
  %1088 = add nsw i32 %1086, -14
  %1089 = icmp ult i32 %1088, -5
  %1090 = select i1 %1087, i1 %1089, i1 false
  br i1 %1090, label %1093, label %1091

1091:                                             ; preds = %1083
  %1092 = call fastcc ptr @skip_thing(ptr noundef nonnull %1084, i32 noundef 2, i32 noundef 1, i32 noundef 3) #16
  store ptr %1092, ptr %81, align 4, !tbaa !43
  br label %1093

1093:                                             ; preds = %1083, %1091
  %1094 = phi ptr [ %1084, %1083 ], [ %1092, %1091 ]
  %1095 = load i32, ptr %84, align 4, !tbaa !33
  %1096 = add nsw i32 %1095, -1
  store i32 %1096, ptr %84, align 4, !tbaa !33
  %1097 = icmp sgt i32 %1095, 1
  br i1 %1097, label %1058, label %1146, !llvm.loop !82

1098:                                             ; preds = %63
  %1099 = call fastcc i32 @readit() #16
  %1100 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  switch i32 %1099, label %1110 [
    i32 46, label %1101
    i32 45, label %1106
  ]

1101:                                             ; preds = %1098
  %1102 = getelementptr inbounds nuw i8, ptr %1100, i32 44
  %1103 = load i32, ptr %1102, align 4, !tbaa !20
  %1104 = add i32 %1103, -2
  %1105 = lshr i32 %1104, 1
  br label %1110

1106:                                             ; preds = %1098
  %1107 = getelementptr inbounds nuw i8, ptr %1100, i32 44
  %1108 = load i32, ptr %1107, align 4, !tbaa !20
  %1109 = add i32 %1108, -2
  br label %1110

1110:                                             ; preds = %1098, %1101, %1106
  %1111 = phi i32 [ %1109, %1106 ], [ %1105, %1101 ], [ 0, %1098 ]
  %1112 = getelementptr inbounds nuw i8, ptr %1100, i32 8
  %1113 = load ptr, ptr %1112, align 4, !tbaa !43
  %1114 = call fastcc ptr @begin_line(ptr noundef %1113) #16
  %1115 = getelementptr inbounds nuw i8, ptr %1100, i32 76
  store ptr %1114, ptr %1115, align 4, !tbaa !49
  call fastcc void @dot_scroll(i32 noundef %1111, i32 noundef -1) #16
  br label %1146

1116:                                             ; preds = %63
  %1117 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1118 = getelementptr inbounds nuw i8, ptr %1117, i32 8
  %1119 = load ptr, ptr %1118, align 4, !tbaa !43
  %1120 = getelementptr inbounds nuw i8, ptr %1117, i32 36
  %1121 = load i32, ptr %1120, align 4, !tbaa !33
  %1122 = add nsw i32 %1121, -1
  %1123 = call fastcc ptr @move_to_col(ptr noundef %1119, i32 noundef %1122) #16
  store ptr %1123, ptr %1118, align 4, !tbaa !43
  br label %1146

1124:                                             ; preds = %74, %1141
  %1125 = load ptr, ptr %76, align 4, !tbaa !43
  %1126 = load i8, ptr %1125, align 1, !tbaa !24
  %1127 = sext i8 %1126 to i32
  %1128 = add nsw i32 %1127, -123
  %1129 = icmp ult i32 %1128, -26
  br i1 %1129, label %1132, label %1130

1130:                                             ; preds = %1124
  %1131 = add i8 %1126, -32
  br label %1137

1132:                                             ; preds = %1124
  %1133 = add nsw i32 %1127, -91
  %1134 = icmp ult i32 %1133, -26
  br i1 %1134, label %1141, label %1135

1135:                                             ; preds = %1132
  %1136 = or i8 %1126, 32
  br label %1137

1137:                                             ; preds = %1130, %1135
  %1138 = phi i8 [ %1136, %1135 ], [ %1131, %1130 ]
  store i8 %1138, ptr %1125, align 1, !tbaa !24
  %1139 = load i32, ptr %78, align 4, !tbaa !50
  %1140 = add nsw i32 %1139, 1
  store i32 %1140, ptr %78, align 4, !tbaa !50
  br label %1141

1141:                                             ; preds = %1137, %1132
  call fastcc void @dot_right() #16
  %1142 = load i32, ptr %77, align 4, !tbaa !33
  %1143 = add nsw i32 %1142, -1
  store i32 %1143, ptr %77, align 4, !tbaa !33
  %1144 = icmp sgt i32 %1142, 1
  br i1 %1144, label %1124, label %1146, !llvm.loop !83

1145:                                             ; preds = %63
  call fastcc void @dot_begin() #16
  br label %1146

1146:                                             ; preds = %1141, %1093, %919, %923, %956, %756, %659, %556, %535, %531, %514, %165, %111, %994, %430, %429, %428, %419, %392, %85, %88, %93, %99, %100, %105, %143, %144, %150, %158, %238, %285, %318, %477, %573, %619, %688, %712, %730, %732, %778, %795, %807, %854, %859, %907, %1110, %1116, %63, %1145, %140, %131, %177, %174, %214, %217, %194, %196, %229, %223, %294, %289, %379, %376, %438, %569, %568, %679, %821, %813, %850, %904, %892, %996, %961, %575, %1044, %1024, %1015, %1057, %1027, %52, %56, %26, %42, %1008, %125
  %1147 = phi ptr [ %7, %732 ], [ %7, %807 ], [ %7, %56 ], [ %7, %52 ], [ %7, %85 ], [ %7, %63 ], [ %7, %88 ], [ %7, %93 ], [ %7, %99 ], [ %7, %100 ], [ %7, %105 ], [ %7, %125 ], [ %7, %131 ], [ %7, %140 ], [ %7, %143 ], [ %7, %144 ], [ %7, %150 ], [ %7, %158 ], [ %7, %174 ], [ %7, %177 ], [ %7, %194 ], [ %7, %196 ], [ %216, %214 ], [ %7, %217 ], [ %7, %223 ], [ %7, %229 ], [ %7, %238 ], [ %7, %285 ], [ %7, %294 ], [ %7, %289 ], [ %7, %318 ], [ %7, %379 ], [ %7, %376 ], [ %7, %477 ], [ %7, %438 ], [ %7, %568 ], [ %7, %569 ], [ %7, %573 ], [ %7, %575 ], [ %7, %619 ], [ %7, %679 ], [ %7, %688 ], [ %7, %712 ], [ %7, %730 ], [ %7, %778 ], [ %7, %795 ], [ %7, %821 ], [ %7, %813 ], [ %7, %850 ], [ %7, %854 ], [ %7, %859 ], [ %7, %904 ], [ %7, %892 ], [ %7, %907 ], [ %7, %961 ], [ %7, %996 ], [ %7, %1008 ], [ %7, %1015 ], [ %7, %1024 ], [ %7, %1044 ], [ %7, %1057 ], [ %7, %1027 ], [ %7, %1110 ], [ %7, %1116 ], [ %7, %1145 ], [ %7, %42 ], [ %7, %26 ], [ %7, %392 ], [ %7, %419 ], [ %7, %428 ], [ %7, %429 ], [ %7, %430 ], [ %7, %994 ], [ %7, %111 ], [ %7, %165 ], [ %7, %514 ], [ %7, %531 ], [ %7, %535 ], [ %7, %556 ], [ %7, %659 ], [ %7, %756 ], [ %7, %956 ], [ %7, %923 ], [ %7, %919 ], [ %7, %1093 ], [ %7, %1141 ]
  %1148 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1149 = getelementptr inbounds nuw i8, ptr %1148, i32 4
  %1150 = load ptr, ptr %1149, align 4, !tbaa !48
  %1151 = load ptr, ptr %1148, align 4, !tbaa !29
  %1152 = icmp eq ptr %1150, %1151
  br i1 %1152, label %1156, label %1153

1153:                                             ; preds = %1146
  %1154 = getelementptr inbounds nuw i8, ptr %1148, i32 8
  %1155 = load ptr, ptr %1154, align 4, !tbaa !43
  br label %1163

1156:                                             ; preds = %1146
  %1157 = call fastcc ptr @char_insert(ptr noundef %1151, i8 noundef signext 10) #16
  %1158 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1159 = load ptr, ptr %1158, align 4, !tbaa !29
  %1160 = getelementptr inbounds nuw i8, ptr %1158, i32 8
  store ptr %1159, ptr %1160, align 4, !tbaa !43
  %1161 = getelementptr inbounds nuw i8, ptr %1158, i32 4
  %1162 = load ptr, ptr %1161, align 4, !tbaa !48
  br label %1163

1163:                                             ; preds = %1153, %1156
  %1164 = phi ptr [ %1162, %1156 ], [ %1150, %1153 ]
  %1165 = phi ptr [ %1159, %1156 ], [ %1155, %1153 ]
  %1166 = phi ptr [ %1158, %1156 ], [ %1148, %1153 ]
  %1167 = icmp eq ptr %1165, %1164
  br i1 %1167, label %1172, label %1168

1168:                                             ; preds = %1163
  %1169 = call fastcc ptr @bound_dot(ptr noundef %1165) #16
  %1170 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1171 = getelementptr inbounds nuw i8, ptr %1170, i32 8
  store ptr %1169, ptr %1171, align 4, !tbaa !43
  br label %1172

1172:                                             ; preds = %1168, %1163
  %1173 = phi ptr [ %1169, %1168 ], [ %1164, %1163 ]
  %1174 = phi ptr [ %1170, %1168 ], [ %1166, %1163 ]
  %1175 = icmp eq ptr %1173, %1147
  br i1 %1175, label %1187, label %1176

1176:                                             ; preds = %1172
  %1177 = trunc i32 %0 to i8
  %1178 = call ptr @strchr(ptr noundef nonnull @.str.66, i8 noundef signext %1177) #17
  %1179 = icmp eq ptr %1178, null
  %1180 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %1179, label %1187, label %1181

1181:                                             ; preds = %1176
  %1182 = getelementptr inbounds nuw i8, ptr %1180, i32 368
  %1183 = load ptr, ptr %1182, align 4, !tbaa !18
  %1184 = getelementptr inbounds nuw i8, ptr %1180, i32 372
  store ptr %1183, ptr %1184, align 4, !tbaa !18
  %1185 = getelementptr inbounds nuw i8, ptr %1180, i32 8
  %1186 = load ptr, ptr %1185, align 4, !tbaa !43
  store ptr %1186, ptr %1182, align 4, !tbaa !18
  br label %1187

1187:                                             ; preds = %1181, %1176, %1172
  %1188 = phi ptr [ %1180, %1181 ], [ %1180, %1176 ], [ %1174, %1172 ]
  %1189 = add i32 %0, -58
  %1190 = icmp ult i32 %1189, -10
  br i1 %1190, label %1191, label %1193

1191:                                             ; preds = %1187
  %1192 = getelementptr inbounds nuw i8, ptr %1188, i32 36
  store i32 0, ptr %1192, align 4, !tbaa !33
  br label %1193

1193:                                             ; preds = %1191, %1187
  %1194 = getelementptr inbounds nuw i8, ptr %1188, i32 8
  %1195 = load ptr, ptr %1194, align 4, !tbaa !43
  %1196 = call fastcc ptr @begin_line(ptr noundef %1195) #16
  %1197 = ptrtoint ptr %1195 to i32
  %1198 = ptrtoint ptr %1196 to i32
  %1199 = sub i32 %1197, %1198
  %1200 = load i8, ptr %1195, align 1, !tbaa !24
  %1201 = icmp eq i8 %1200, 10
  %1202 = icmp sgt i32 %1199, 0
  %1203 = select i1 %1201, i1 %1202, i1 false
  br i1 %1203, label %1204, label %1210

1204:                                             ; preds = %1193
  %1205 = getelementptr inbounds nuw i8, ptr %1188, i32 20
  %1206 = load i32, ptr %1205, align 4, !tbaa !32
  %1207 = icmp eq i32 %1206, 0
  br i1 %1207, label %1208, label %1210

1208:                                             ; preds = %1204
  %1209 = getelementptr inbounds i8, ptr %1195, i32 -1
  store ptr %1209, ptr %1194, align 4, !tbaa !43
  br label %1210

1210:                                             ; preds = %1208, %1204, %1193
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %4) #19
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #19
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @refresh(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %4 = load ptr, ptr %3, align 4, !tbaa !43
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 52
  %6 = getelementptr inbounds nuw i8, ptr %2, i32 56
  %7 = tail call fastcc ptr @begin_line(ptr noundef %4) #16
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 76
  %9 = load ptr, ptr %8, align 4, !tbaa !49
  %10 = icmp ult ptr %7, %9
  br i1 %10, label %11, label %29

11:                                               ; preds = %1
  %12 = tail call fastcc i32 @count_lines(ptr noundef %7, ptr noundef nonnull %9) #16
  %13 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %14 = load i32, ptr %13, align 4, !tbaa !20
  %15 = add i32 %14, -1
  %16 = lshr i32 %15, 1
  br label %17

17:                                               ; preds = %36, %11
  %18 = phi i32 [ %41, %36 ], [ %16, %11 ]
  %19 = phi i32 [ %40, %36 ], [ %15, %11 ]
  %20 = phi i32 [ %37, %36 ], [ %12, %11 ]
  store ptr %7, ptr %8, align 4, !tbaa !49
  %21 = icmp ugt i32 %20, %18
  br i1 %21, label %22, label %55

22:                                               ; preds = %17, %26
  %23 = phi ptr [ %27, %26 ], [ %7, %17 ]
  %24 = phi i32 [ %28, %26 ], [ 0, %17 ]
  %25 = icmp eq i32 %24, %18
  br i1 %25, label %55, label %26

26:                                               ; preds = %22
  %27 = tail call fastcc ptr @prev_line(ptr noundef %23) #16
  store ptr %27, ptr %8, align 4, !tbaa !49
  %28 = add nuw i32 %24, 1
  br label %22, !llvm.loop !84

29:                                               ; preds = %1
  %30 = tail call fastcc ptr @end_screen() #16
  %31 = icmp ugt ptr %7, %30
  br i1 %31, label %36, label %32

32:                                               ; preds = %29
  %33 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %34 = load i32, ptr %33, align 4, !tbaa !20
  %35 = add i32 %34, -1
  br label %55

36:                                               ; preds = %29
  %37 = tail call fastcc i32 @count_lines(ptr noundef %30, ptr noundef nonnull %7) #16
  %38 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %39 = load i32, ptr %38, align 4, !tbaa !20
  %40 = add i32 %39, -1
  %41 = lshr i32 %40, 1
  %42 = icmp ugt i32 %37, %41
  br i1 %42, label %17, label %43

43:                                               ; preds = %36
  %44 = add nsw i32 %37, -1
  br label %45

45:                                               ; preds = %50, %43
  %46 = phi ptr [ %51, %50 ], [ %9, %43 ]
  %47 = phi i32 [ %54, %50 ], [ 0, %43 ]
  %48 = phi ptr [ %53, %50 ], [ %30, %43 ]
  %49 = icmp slt i32 %47, %44
  br i1 %49, label %50, label %55

50:                                               ; preds = %45
  %51 = tail call fastcc ptr @next_line(ptr noundef %46) #16
  store ptr %51, ptr %8, align 4, !tbaa !49
  %52 = tail call fastcc ptr @next_line(ptr noundef %48) #16
  %53 = tail call fastcc ptr @end_line(ptr noundef %52) #16
  %54 = add nuw nsw i32 %47, 1
  br label %45, !llvm.loop !85

55:                                               ; preds = %45, %22, %32, %17
  %56 = phi i32 [ %35, %32 ], [ %19, %17 ], [ %19, %22 ], [ %40, %45 ]
  %57 = phi ptr [ %9, %32 ], [ %7, %17 ], [ %23, %22 ], [ %46, %45 ]
  br label %58

58:                                               ; preds = %64, %55
  %59 = phi ptr [ %57, %55 ], [ %65, %64 ]
  %60 = phi i32 [ 0, %55 ], [ %66, %64 ]
  %61 = icmp uge i32 %60, %56
  %62 = icmp eq ptr %59, %7
  %63 = select i1 %61, i1 true, i1 %62
  br i1 %63, label %67, label %64

64:                                               ; preds = %58
  %65 = tail call fastcc ptr @next_line(ptr noundef %59) #16
  %66 = add nuw nsw i32 %60, 1
  br label %58, !llvm.loop !86

67:                                               ; preds = %58
  %68 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %69 = getelementptr inbounds i8, ptr %4, i32 -1
  br label %70

70:                                               ; preds = %86, %67
  %71 = phi ptr [ %59, %67 ], [ %87, %86 ]
  %72 = phi i32 [ 0, %67 ], [ %76, %86 ]
  %73 = load i8, ptr %71, align 1, !tbaa !24
  %74 = icmp eq i8 %73, 10
  br i1 %74, label %91, label %75

75:                                               ; preds = %70
  %76 = tail call fastcc i32 @next_column(i8 noundef signext %73, i32 noundef %72) #16
  %77 = load i32, ptr %68, align 4, !tbaa !32
  %78 = icmp ne i32 %77, 0
  %79 = icmp eq ptr %71, %69
  %80 = select i1 %78, i1 %79, i1 false
  br i1 %80, label %81, label %84

81:                                               ; preds = %75
  %82 = load i8, ptr %4, align 1, !tbaa !24
  %83 = icmp eq i8 %82, 9
  br i1 %83, label %91, label %84

84:                                               ; preds = %81, %75
  %85 = icmp ult ptr %71, %4
  br i1 %85, label %86, label %89

86:                                               ; preds = %84
  %87 = getelementptr inbounds nuw i8, ptr %71, i32 1
  %88 = icmp eq i32 %76, 0
  br i1 %88, label %91, label %70, !llvm.loop !87

89:                                               ; preds = %84
  %90 = add nsw i32 %76, -1
  br label %91

91:                                               ; preds = %86, %81, %70, %89
  %92 = phi i32 [ %90, %89 ], [ 0, %86 ], [ %72, %70 ], [ %76, %81 ]
  %93 = getelementptr inbounds nuw i8, ptr %2, i32 60
  %94 = load i32, ptr %93, align 4, !tbaa !34
  %95 = icmp slt i32 %92, %94
  br i1 %95, label %96, label %97

96:                                               ; preds = %91
  store i32 %92, ptr %93, align 4, !tbaa !34
  br label %97

97:                                               ; preds = %96, %91
  %98 = phi i32 [ %92, %96 ], [ %94, %91 ]
  %99 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %100 = load i32, ptr %99, align 4, !tbaa !21
  %101 = add i32 %100, %98
  %102 = icmp ult i32 %92, %101
  br i1 %102, label %106, label %103

103:                                              ; preds = %97
  %104 = add i32 %92, 1
  %105 = sub i32 %104, %100
  store i32 %105, ptr %93, align 4, !tbaa !34
  br label %106

106:                                              ; preds = %103, %97
  %107 = phi i32 [ %105, %103 ], [ %98, %97 ]
  %108 = icmp eq ptr %4, %7
  br i1 %108, label %109, label %113

109:                                              ; preds = %106
  %110 = load i8, ptr %4, align 1, !tbaa !24
  %111 = icmp eq i8 %110, 9
  br i1 %111, label %112, label %113

112:                                              ; preds = %109
  store i32 0, ptr %93, align 4, !tbaa !34
  br label %113

113:                                              ; preds = %106, %109, %112
  %114 = phi i32 [ 0, %112 ], [ %107, %109 ], [ %107, %106 ]
  %115 = sub nsw i32 %92, %114
  store i32 %60, ptr %5, align 4, !tbaa !16
  store i32 %115, ptr %6, align 4, !tbaa !16
  %116 = icmp eq i32 %0, 0
  br label %117

117:                                              ; preds = %283, %113
  %118 = phi ptr [ %2, %113 ], [ %284, %283 ]
  %119 = phi ptr [ %57, %113 ], [ %228, %283 ]
  %120 = phi i32 [ 0, %113 ], [ %285, %283 ]
  %121 = getelementptr inbounds nuw i8, ptr %118, i32 44
  %122 = load i32, ptr %121, align 4, !tbaa !20
  %123 = add i32 %122, -1
  %124 = icmp ult i32 %120, %123
  br i1 %124, label %125, label %286

125:                                              ; preds = %117
  %126 = getelementptr inbounds nuw i8, ptr %118, i32 60
  %127 = load i32, ptr %126, align 4, !tbaa !34
  %128 = getelementptr inbounds nuw i8, ptr %118, i32 736
  br label %129

129:                                              ; preds = %191, %125
  %130 = phi ptr [ %118, %125 ], [ %192, %191 ]
  %131 = phi ptr [ %119, %125 ], [ %174, %191 ]
  %132 = phi i8 [ 126, %125 ], [ %175, %191 ]
  %133 = phi i32 [ 0, %125 ], [ %193, %191 ]
  %134 = phi i32 [ %127, %125 ], [ %194, %191 ]
  %135 = getelementptr inbounds nuw i8, ptr %130, i32 48
  %136 = load i32, ptr %135, align 4, !tbaa !21
  %137 = getelementptr inbounds nuw i8, ptr %130, i32 88
  %138 = load i32, ptr %137, align 4, !tbaa !15
  %139 = add i32 %138, %136
  %140 = icmp ult i32 %133, %139
  br i1 %140, label %141, label %201

141:                                              ; preds = %129
  %142 = getelementptr inbounds nuw i8, ptr %130, i32 4
  %143 = load ptr, ptr %142, align 4, !tbaa !48
  %144 = icmp ult ptr %131, %143
  br i1 %144, label %145, label %173

145:                                              ; preds = %141
  %146 = getelementptr inbounds nuw i8, ptr %131, i32 1
  %147 = load i8, ptr %131, align 1, !tbaa !24
  %148 = icmp eq i8 %147, 10
  br i1 %148, label %201, label %149

149:                                              ; preds = %145
  %150 = icmp sgt i8 %147, -1
  %151 = select i1 %150, i8 %147, i8 46
  %152 = icmp samesign ult i8 %151, 32
  br i1 %152, label %155, label %153

153:                                              ; preds = %149
  %154 = icmp eq i8 %151, 127
  br i1 %154, label %167, label %173

155:                                              ; preds = %149
  %156 = icmp eq i8 %151, 9
  br i1 %156, label %157, label %167

157:                                              ; preds = %155, %163
  %158 = phi i32 [ %166, %163 ], [ %138, %155 ]
  %159 = phi i32 [ %164, %163 ], [ %133, %155 ]
  %160 = srem i32 %159, %158
  %161 = add nsw i32 %158, -1
  %162 = icmp eq i32 %160, %161
  br i1 %162, label %173, label %163

163:                                              ; preds = %157
  %164 = add nsw i32 %159, 1
  %165 = getelementptr inbounds i8, ptr %128, i32 %159
  store i8 32, ptr %165, align 1, !tbaa !24
  %166 = load i32, ptr %137, align 4, !tbaa !15
  br label %157, !llvm.loop !88

167:                                              ; preds = %155, %153
  %168 = add nuw nsw i32 %133, 1
  %169 = getelementptr inbounds i8, ptr %128, i32 %133
  store i8 94, ptr %169, align 1, !tbaa !24
  %170 = icmp eq i8 %151, 127
  %171 = add nuw i8 %151, 64
  %172 = select i1 %170, i8 63, i8 %171
  br label %173

173:                                              ; preds = %157, %167, %153, %141
  %174 = phi ptr [ %146, %153 ], [ %131, %141 ], [ %146, %167 ], [ %146, %157 ]
  %175 = phi i8 [ %151, %153 ], [ %132, %141 ], [ %172, %167 ], [ 32, %157 ]
  %176 = phi i32 [ %133, %153 ], [ %133, %141 ], [ %168, %167 ], [ %159, %157 ]
  %177 = add nsw i32 %176, 1
  %178 = getelementptr inbounds i8, ptr %128, i32 %176
  store i8 %175, ptr %178, align 1, !tbaa !24
  %179 = load i32, ptr %137, align 4, !tbaa !15
  %180 = icmp slt i32 %134, %179
  br i1 %180, label %191, label %181

181:                                              ; preds = %173
  %182 = icmp slt i32 %177, %179
  br i1 %182, label %191, label %183

183:                                              ; preds = %181
  %184 = getelementptr inbounds i8, ptr %128, i32 %179
  %185 = tail call ptr @memmove(ptr noundef nonnull %128, ptr noundef nonnull %184, i32 noundef %177) #17
  %186 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %187 = getelementptr inbounds nuw i8, ptr %186, i32 88
  %188 = load i32, ptr %187, align 4, !tbaa !15
  %189 = sub nsw i32 %177, %188
  %190 = sub nsw i32 %134, %188
  br label %191

191:                                              ; preds = %183, %181, %173
  %192 = phi ptr [ %186, %183 ], [ %130, %181 ], [ %130, %173 ]
  %193 = phi i32 [ %189, %183 ], [ %177, %181 ], [ %177, %173 ]
  %194 = phi i32 [ %190, %183 ], [ %134, %181 ], [ %134, %173 ]
  %195 = getelementptr inbounds nuw i8, ptr %192, i32 4
  %196 = load ptr, ptr %195, align 4, !tbaa !48
  %197 = icmp ult ptr %174, %196
  br i1 %197, label %129, label %198, !llvm.loop !89

198:                                              ; preds = %191
  %199 = getelementptr inbounds nuw i8, ptr %192, i32 48
  %200 = load i32, ptr %199, align 4, !tbaa !21
  br label %201, !llvm.loop !89

201:                                              ; preds = %145, %129, %198
  %202 = phi i32 [ %200, %198 ], [ %136, %129 ], [ %136, %145 ]
  %203 = phi i32 [ %193, %198 ], [ %133, %129 ], [ %133, %145 ]
  %204 = phi i32 [ %194, %198 ], [ %134, %129 ], [ %134, %145 ]
  %205 = tail call i32 @llvm.smin.i32(i32 %203, i32 %204)
  %206 = sub nsw i32 %203, %205
  %207 = icmp ult i32 %206, %202
  br i1 %207, label %208, label %212

208:                                              ; preds = %201
  %209 = getelementptr inbounds i8, ptr %128, i32 %203
  %210 = sub nuw i32 %202, %206
  %211 = tail call ptr @memset(ptr noundef nonnull %209, i32 noundef 32, i32 noundef %210) #17
  br label %212

212:                                              ; preds = %201, %208
  %213 = getelementptr inbounds i8, ptr %128, i32 %205
  %214 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %215 = getelementptr inbounds nuw i8, ptr %214, i32 4
  %216 = load ptr, ptr %215, align 4, !tbaa !48
  %217 = icmp ult ptr %119, %216
  br i1 %217, label %218, label %227

218:                                              ; preds = %212
  %219 = ptrtoint ptr %216 to i32
  %220 = ptrtoint ptr %119 to i32
  %221 = sub i32 %219, %220
  %222 = tail call fastcc ptr @bb_memchr(ptr noundef %119, i32 noundef %221) #16
  %223 = icmp eq ptr %222, null
  %224 = getelementptr inbounds i8, ptr %216, i32 -1
  %225 = select i1 %223, ptr %224, ptr %222
  %226 = getelementptr inbounds nuw i8, ptr %225, i32 1
  br label %227

227:                                              ; preds = %218, %212
  %228 = phi ptr [ %226, %218 ], [ %119, %212 ]
  %229 = getelementptr inbounds nuw i8, ptr %214, i32 48
  %230 = load i32, ptr %229, align 4, !tbaa !21
  %231 = add i32 %230, -1
  %232 = getelementptr inbounds nuw i8, ptr %214, i32 80
  %233 = load ptr, ptr %232, align 4, !tbaa !22
  %234 = mul i32 %230, %120
  %235 = getelementptr inbounds nuw i8, ptr %233, i32 %234
  br i1 %116, label %236, label %269

236:                                              ; preds = %227, %245
  %237 = phi i32 [ %246, %245 ], [ 0, %227 ]
  %238 = icmp sgt i32 %237, %231
  br i1 %238, label %247, label %239

239:                                              ; preds = %236
  %240 = getelementptr inbounds nuw i8, ptr %213, i32 %237
  %241 = load i8, ptr %240, align 1, !tbaa !24
  %242 = getelementptr inbounds nuw i8, ptr %235, i32 %237
  %243 = load i8, ptr %242, align 1, !tbaa !24
  %244 = icmp eq i8 %241, %243
  br i1 %244, label %245, label %247

245:                                              ; preds = %239
  %246 = add nuw nsw i32 %237, 1
  br label %236, !llvm.loop !90

247:                                              ; preds = %239, %236
  %248 = phi i32 [ 0, %236 ], [ 1, %239 ]
  br label %249

249:                                              ; preds = %258, %247
  %250 = phi i32 [ %231, %247 ], [ %259, %258 ]
  %251 = icmp slt i32 %250, %237
  br i1 %251, label %260, label %252

252:                                              ; preds = %249
  %253 = getelementptr inbounds i8, ptr %213, i32 %250
  %254 = load i8, ptr %253, align 1, !tbaa !24
  %255 = getelementptr inbounds i8, ptr %235, i32 %250
  %256 = load i8, ptr %255, align 1, !tbaa !24
  %257 = icmp eq i8 %254, %256
  br i1 %257, label %258, label %260

258:                                              ; preds = %252
  %259 = add nsw i32 %250, -1
  br label %249, !llvm.loop !91

260:                                              ; preds = %249, %252
  %261 = phi i32 [ %248, %249 ], [ 1, %252 ]
  %262 = getelementptr inbounds nuw i8, ptr %214, i32 60
  %263 = load i32, ptr %262, align 4, !tbaa !34
  %264 = getelementptr inbounds nuw i8, ptr %214, i32 112
  %265 = load i32, ptr %264, align 4, !tbaa !92
  %266 = icmp eq i32 %263, %265
  %267 = icmp eq i32 %261, 0
  %268 = and i1 %267, %266
  br i1 %268, label %283, label %269

269:                                              ; preds = %227, %260
  %270 = phi i32 [ %250, %260 ], [ %231, %227 ]
  %271 = phi i32 [ %237, %260 ], [ 0, %227 ]
  %272 = tail call i32 @llvm.umin.i32(i32 %270, i32 %231)
  %273 = icmp sgt i32 %271, %272
  %274 = select i1 %273, i32 %231, i32 %272
  %275 = select i1 %273, i32 0, i32 %271
  %276 = getelementptr inbounds nuw i8, ptr %235, i32 %275
  %277 = getelementptr inbounds nuw i8, ptr %213, i32 %275
  %278 = sub nsw i32 %274, %275
  %279 = add nsw i32 %278, 1
  %280 = tail call ptr @memmove(ptr noundef %276, ptr noundef nonnull %277, i32 noundef %279) #17
  tail call fastcc void @place_cursor(i32 noundef %120, i32 noundef %275) #16
  %281 = tail call i32 @write(i32 noundef 1, ptr noundef %276, i32 noundef range(i32 -2147483647, -2147483648) %279) #17
  %282 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %283

283:                                              ; preds = %269, %260
  %284 = phi ptr [ %282, %269 ], [ %214, %260 ]
  %285 = add nuw nsw i32 %120, 1
  br label %117, !llvm.loop !93

286:                                              ; preds = %117
  %287 = getelementptr inbounds nuw i8, ptr %118, i32 52
  %288 = load i32, ptr %287, align 4, !tbaa !30
  %289 = getelementptr inbounds nuw i8, ptr %118, i32 56
  %290 = load i32, ptr %289, align 4, !tbaa !31
  tail call fastcc void @place_cursor(i32 noundef %288, i32 noundef %290) #16
  %291 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %292 = getelementptr inbounds nuw i8, ptr %291, i32 384
  %293 = load i32, ptr %292, align 4, !tbaa !53
  %294 = icmp eq i32 %293, 0
  br i1 %294, label %298, label %295

295:                                              ; preds = %286
  %296 = getelementptr inbounds nuw i8, ptr %291, i32 60
  %297 = load i32, ptr %296, align 4, !tbaa !34
  br label %305

298:                                              ; preds = %286
  %299 = getelementptr inbounds nuw i8, ptr %291, i32 56
  %300 = load i32, ptr %299, align 4, !tbaa !31
  %301 = getelementptr inbounds nuw i8, ptr %291, i32 60
  %302 = load i32, ptr %301, align 4, !tbaa !34
  %303 = add nsw i32 %302, %300
  %304 = getelementptr inbounds nuw i8, ptr %291, i32 380
  store i32 %303, ptr %304, align 4, !tbaa !57
  br label %305

305:                                              ; preds = %295, %298
  %306 = phi i32 [ %297, %295 ], [ %302, %298 ]
  %307 = getelementptr inbounds nuw i8, ptr %291, i32 112
  store i32 %306, ptr %307, align 4, !tbaa !92
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_status_line() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 64
  %3 = load i32, ptr %2, align 4, !tbaa !94
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %76

5:                                                ; preds = %0
  %6 = load ptr, ptr %1, align 4, !tbaa !29
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %8 = load ptr, ptr %7, align 4, !tbaa !43
  %9 = tail call fastcc i32 @count_lines(ptr noundef %6, ptr noundef %8) #16
  %10 = getelementptr inbounds nuw i8, ptr %1, i32 24
  %11 = load i32, ptr %10, align 4, !tbaa !50
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 28
  %13 = load i32, ptr %12, align 4, !tbaa !8
  %14 = icmp eq i32 %11, %13
  br i1 %14, label %15, label %18

15:                                               ; preds = %5
  %16 = getelementptr inbounds nuw i8, ptr %1, i32 116
  %17 = load i32, ptr %16, align 4, !tbaa !95
  br label %26

18:                                               ; preds = %5
  %19 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %20 = load ptr, ptr %19, align 4, !tbaa !48
  %21 = getelementptr inbounds i8, ptr %20, i32 -1
  %22 = tail call fastcc i32 @count_lines(ptr noundef %8, ptr noundef nonnull %21) #16
  %23 = add i32 %9, -1
  %24 = add i32 %23, %22
  %25 = getelementptr inbounds nuw i8, ptr %1, i32 116
  store i32 %24, ptr %25, align 4, !tbaa !95
  store i32 %11, ptr %12, align 4, !tbaa !8
  br label %26

26:                                               ; preds = %18, %15
  %27 = phi i32 [ %17, %15 ], [ %24, %18 ]
  %28 = icmp sgt i32 %27, 0
  br i1 %28, label %29, label %32

29:                                               ; preds = %26
  %30 = mul nsw i32 %9, 100
  %31 = sdiv i32 %30, %27
  br label %34

32:                                               ; preds = %26
  %33 = getelementptr inbounds nuw i8, ptr %1, i32 116
  store i32 0, ptr %33, align 4, !tbaa !95
  br label %34

34:                                               ; preds = %29, %32
  %35 = phi i32 [ %27, %29 ], [ 0, %32 ]
  %36 = phi i32 [ %31, %29 ], [ 100, %32 ]
  %37 = phi i32 [ %9, %29 ], [ 0, %32 ]
  %38 = getelementptr inbounds nuw i8, ptr %1, i32 48
  %39 = load i32, ptr %38, align 4, !tbaa !21
  %40 = tail call i32 @llvm.umin.i32(i32 %39, i32 199)
  %41 = getelementptr inbounds nuw i8, ptr %1, i32 408
  %42 = add nuw nsw i32 %40, 1
  %43 = getelementptr inbounds nuw i8, ptr %1, i32 20
  %44 = load i32, ptr %43, align 4, !tbaa !32
  %45 = and i32 %44, 3
  %46 = getelementptr inbounds nuw [5 x i8], ptr @format_edit_status.cmd_mode_indicator, i32 0, i32 %45
  %47 = load i8, ptr %46, align 1, !tbaa !24
  %48 = sext i8 %47 to i32
  %49 = getelementptr inbounds nuw i8, ptr %1, i32 72
  %50 = load ptr, ptr %49, align 4, !tbaa !78
  %51 = icmp eq ptr %50, null
  %52 = select i1 %51, ptr @.str.69, ptr %50
  %53 = icmp eq i32 %11, 0
  %54 = select i1 %53, ptr @.str.17, ptr @.str.70
  %55 = tail call i32 (ptr, i32, ptr, ...) @bb_snprintf(ptr noundef nonnull %41, i32 noundef %42, ptr nonnull poison, i32 noundef %48, ptr noundef nonnull %52, ptr noundef nonnull %54, i32 noundef %37, i32 noundef %35, i32 noundef %36) #16
  %56 = tail call range(i32 0, 200) i32 @llvm.umin.i32(i32 %55, i32 %40)
  %57 = getelementptr inbounds nuw i8, ptr %41, i32 %56
  br label %58

58:                                               ; preds = %62, %34
  %59 = phi i32 [ 0, %34 ], [ %66, %62 ]
  %60 = phi ptr [ %41, %34 ], [ %63, %62 ]
  %61 = icmp ult ptr %60, %57
  br i1 %61, label %62, label %67

62:                                               ; preds = %58
  %63 = getelementptr inbounds nuw i8, ptr %60, i32 1
  %64 = load i8, ptr %60, align 1, !tbaa !24
  %65 = zext i8 %64 to i32
  %66 = add nuw nsw i32 %59, %65
  br label %58, !llvm.loop !96

67:                                               ; preds = %58
  %68 = load i32, ptr %2, align 4, !tbaa !94
  %69 = icmp eq i32 %68, 0
  br i1 %69, label %70, label %76

70:                                               ; preds = %67
  %71 = icmp eq i32 %56, 0
  br i1 %71, label %109, label %72

72:                                               ; preds = %70
  %73 = getelementptr inbounds nuw i8, ptr %1, i32 68
  %74 = load i32, ptr %73, align 4, !tbaa !51
  %75 = icmp eq i32 %74, %59
  br i1 %75, label %109, label %76

76:                                               ; preds = %0, %72, %67
  %77 = phi i32 [ %59, %72 ], [ %59, %67 ], [ 0, %0 ]
  %78 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %77, ptr %78, align 4, !tbaa !51
  tail call fastcc void @go_bottom_and_clear_to_eol() #16
  %79 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %80 = getelementptr inbounds nuw i8, ptr %79, i32 408
  tail call fastcc void @write1(ptr noundef nonnull %80) #16
  %81 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %82 = getelementptr inbounds nuw i8, ptr %81, i32 64
  %83 = load i32, ptr %82, align 4, !tbaa !94
  %84 = icmp eq i32 %83, 0
  br i1 %84, label %103, label %85

85:                                               ; preds = %76
  %86 = getelementptr inbounds nuw i8, ptr %81, i32 408
  %87 = tail call i32 @strlen(ptr noundef nonnull %86) #17
  %88 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %89 = getelementptr inbounds nuw i8, ptr %88, i32 64
  %90 = load i32, ptr %89, align 4, !tbaa !94
  %91 = add i32 %87, 1
  %92 = sub i32 %91, %90
  %93 = icmp sgt i32 %92, -1
  br i1 %93, label %94, label %100

94:                                               ; preds = %85
  %95 = getelementptr inbounds nuw i8, ptr %88, i32 48
  %96 = load i32, ptr %95, align 4, !tbaa !21
  %97 = icmp ult i32 %92, %96
  br i1 %97, label %100, label %98

98:                                               ; preds = %94
  tail call fastcc void @Hit_Return() #16
  %99 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %100

100:                                              ; preds = %98, %94, %85
  %101 = phi ptr [ %99, %98 ], [ %88, %94 ], [ %88, %85 ]
  %102 = getelementptr inbounds nuw i8, ptr %101, i32 64
  store i32 0, ptr %102, align 4, !tbaa !94
  br label %103

103:                                              ; preds = %100, %76
  %104 = phi ptr [ %101, %100 ], [ %81, %76 ]
  %105 = getelementptr inbounds nuw i8, ptr %104, i32 52
  %106 = load i32, ptr %105, align 4, !tbaa !30
  %107 = getelementptr inbounds nuw i8, ptr %104, i32 56
  %108 = load i32, ptr %107, align 4, !tbaa !31
  tail call fastcc void @place_cursor(i32 noundef %106, i32 noundef %108) #16
  br label %109

109:                                              ; preds = %103, %72, %70
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @go_bottom_and_clear_to_eol() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 44
  %3 = load i32, ptr %2, align 4, !tbaa !20
  %4 = add i32 %3, -1
  tail call fastcc void @place_cursor(i32 noundef %4, i32 noundef 0) #16
  tail call fastcc void @write1(ptr noundef nonnull @.str.71) #16
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @cookmode() unnamed_addr #0 {
  %1 = tail call i32 @ttyraw(i32 noundef 0) #17
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @ttyraw(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @bb_free(ptr noundef %0) unnamed_addr #0 {
  %2 = icmp eq ptr %0, null
  br i1 %2, label %4, label %3

3:                                                ; preds = %1
  tail call void @free(ptr noundef nonnull %0) #17
  br label %4

4:                                                ; preds = %3, %1
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @screen_erase() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 80
  %3 = load ptr, ptr %2, align 4, !tbaa !22
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 84
  %5 = load i32, ptr %4, align 4, !tbaa !23
  %6 = tail call ptr @memset(ptr noundef %3, i32 noundef 32, i32 noundef %5) #17
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @free(ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @update_filename(ptr noundef %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 72
  %4 = load ptr, ptr %3, align 4, !tbaa !78
  %5 = icmp eq ptr %0, %4
  br i1 %5, label %10, label %6

6:                                                ; preds = %1
  tail call fastcc void @bb_free(ptr noundef %4) #16
  %7 = tail call fastcc ptr @xstrdup(ptr noundef %0) #16
  %8 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 72
  store ptr %7, ptr %9, align 4, !tbaa !78
  br label %10

10:                                               ; preds = %6, %1
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, -2147483648) i32 @file_insert(ptr noundef %0, ptr noundef %1, i32 noundef range(i32 0, 2) %2) unnamed_addr #0 {
  %4 = alloca %struct.stat, align 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #19
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = load ptr, ptr %5, align 4, !tbaa !29
  %7 = icmp ult ptr %1, %6
  %8 = select i1 %7, ptr %6, ptr %1
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %10 = load ptr, ptr %9, align 4, !tbaa !48
  %11 = icmp ugt ptr %8, %10
  %12 = select i1 %11, ptr %10, ptr %8
  %13 = icmp eq ptr %0, null
  br i1 %13, label %54, label %14

14:                                               ; preds = %3
  %15 = tail call i32 @open(ptr noundef nonnull %0, i32 noundef 0) #17
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  %18 = icmp eq i32 %2, 0
  br i1 %18, label %19, label %54

19:                                               ; preds = %17
  tail call fastcc void @status_line_bold_errno(ptr noundef nonnull %0) #16
  br label %54

20:                                               ; preds = %14
  %21 = call i32 @fstat(i32 noundef %15, ptr noundef nonnull %4) #17
  %22 = icmp slt i32 %21, 0
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  call fastcc void @status_line_bold_errno(ptr noundef nonnull %0) #16
  br label %51

24:                                               ; preds = %20
  %25 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %26 = load i16, ptr %25, align 4, !tbaa !97
  %27 = icmp eq i16 %26, 2
  br i1 %27, label %29, label %28

28:                                               ; preds = %24
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.3, ptr noundef nonnull %0) #16
  br label %51

29:                                               ; preds = %24
  %30 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %31 = load i32, ptr %30, align 4, !tbaa !101
  %32 = call i32 @llvm.umin.i32(i32 %31, i32 2147483647)
  %33 = call fastcc i32 @text_hole_make(ptr noundef %12, i32 noundef %32) #16
  %34 = getelementptr inbounds nuw i8, ptr %12, i32 %33
  br label %35

35:                                               ; preds = %38, %29
  %36 = phi i32 [ 0, %29 ], [ %43, %38 ]
  %37 = icmp slt i32 %36, %32
  br i1 %37, label %38, label %44

38:                                               ; preds = %35
  %39 = getelementptr inbounds nuw i8, ptr %34, i32 %36
  %40 = sub nsw i32 %32, %36
  %41 = call i32 @read(i32 noundef range(i32 0, -2147483648) %15, ptr noundef %39, i32 noundef %40) #17
  %42 = icmp slt i32 %41, 1
  %43 = add nuw nsw i32 %41, %36
  br i1 %42, label %44, label %35

44:                                               ; preds = %35, %38
  %45 = icmp samesign ult i32 %36, %32
  br i1 %45, label %46, label %51

46:                                               ; preds = %44
  %47 = getelementptr inbounds nuw i8, ptr %34, i32 %36
  %48 = getelementptr inbounds nuw i8, ptr %34, i32 %32
  %49 = getelementptr inbounds i8, ptr %48, i32 -1
  %50 = call fastcc ptr @text_hole_delete(ptr noundef %47, ptr noundef nonnull %49) #16
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.4, ptr noundef nonnull %0) #16
  br label %51

51:                                               ; preds = %46, %44, %28, %23
  %52 = phi i32 [ -1, %23 ], [ %36, %46 ], [ %36, %44 ], [ -1, %28 ]
  %53 = call i32 @close(i32 noundef %15) #17
  br label %54

54:                                               ; preds = %17, %19, %3, %51
  %55 = phi i32 [ %52, %51 ], [ -1, %3 ], [ -1, %19 ], [ -1, %17 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #19
  ret i32 %55
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @char_insert(ptr noundef %0, i8 noundef signext %1) unnamed_addr #0 {
  %3 = tail call fastcc ptr @begin_line(ptr noundef %0) #16
  switch i8 %1, label %65 [
    i8 22, label %4
    i8 27, label %14
    i8 4, label %28
  ]

4:                                                ; preds = %2
  %5 = tail call fastcc i32 @stupid_insert(ptr noundef %0, i8 noundef signext 94) #16
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 %5
  tail call fastcc void @refresh(i32 noundef 0) #16
  %7 = tail call fastcc i32 @readit() #16
  %8 = trunc i32 %7 to i8
  store i8 %8, ptr %6, align 1, !tbaa !24
  %9 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %11 = load i32, ptr %10, align 4, !tbaa !50
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr %10, align 4, !tbaa !50
  %13 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %98

14:                                               ; preds = %2
  %15 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %16 = getelementptr inbounds nuw i8, ptr %15, i32 20
  store i32 0, ptr %16, align 4, !tbaa !32
  %17 = getelementptr inbounds nuw i8, ptr %15, i32 36
  store i32 0, ptr %17, align 4, !tbaa !33
  %18 = getelementptr inbounds nuw i8, ptr %15, i32 68
  store i32 0, ptr %18, align 4, !tbaa !51
  %19 = getelementptr inbounds nuw i8, ptr %15, i32 8
  %20 = load ptr, ptr %19, align 4, !tbaa !43
  %21 = load ptr, ptr %15, align 4, !tbaa !29
  %22 = icmp ugt ptr %20, %21
  br i1 %22, label %23, label %98

23:                                               ; preds = %14
  %24 = getelementptr inbounds i8, ptr %0, i32 -1
  %25 = load i8, ptr %24, align 1, !tbaa !24
  %26 = icmp eq i8 %25, 10
  %27 = select i1 %26, ptr %0, ptr %24
  br label %98

28:                                               ; preds = %2
  %29 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %30 = getelementptr inbounds nuw i8, ptr %29, i32 4
  %31 = load ptr, ptr %30, align 4, !tbaa !48
  %32 = getelementptr inbounds i8, ptr %31, i32 -1
  br label %33

33:                                               ; preds = %38, %28
  %34 = phi ptr [ %3, %28 ], [ %39, %38 ]
  %35 = icmp ult ptr %34, %32
  br i1 %35, label %36, label %40

36:                                               ; preds = %33
  %37 = load i8, ptr %34, align 1, !tbaa !24
  switch i8 %37, label %40 [
    i8 32, label %38
    i8 9, label %38
  ]

38:                                               ; preds = %36, %36
  %39 = getelementptr inbounds nuw i8, ptr %34, i32 1
  br label %33, !llvm.loop !102

40:                                               ; preds = %33, %36
  %41 = ptrtoint ptr %34 to i32
  %42 = ptrtoint ptr %3 to i32
  %43 = sub i32 %41, %42
  %44 = getelementptr inbounds nuw i8, ptr %3, i32 %43
  %45 = tail call fastcc i32 @get_column(ptr noundef %44) #16
  %46 = getelementptr inbounds nuw i8, ptr %29, i32 88
  %47 = load i32, ptr %46, align 4, !tbaa !15
  %48 = srem i32 %45, %47
  %49 = icmp eq i32 %48, 0
  %50 = select i1 %49, i32 %47, i32 %48
  %51 = sub nsw i32 %45, %50
  br label %52

52:                                               ; preds = %59, %40
  %53 = phi ptr [ %44, %40 ], [ %64, %59 ]
  %54 = phi ptr [ %0, %40 ], [ %62, %59 ]
  %55 = icmp ugt ptr %53, %3
  br i1 %55, label %56, label %98

56:                                               ; preds = %52
  %57 = tail call fastcc i32 @get_column(ptr noundef nonnull %53) #16
  %58 = icmp sgt i32 %57, %51
  br i1 %58, label %59, label %98

59:                                               ; preds = %56
  %60 = icmp ugt ptr %54, %3
  %61 = sext i1 %60 to i32
  %62 = getelementptr inbounds i8, ptr %54, i32 %61
  %63 = getelementptr inbounds i8, ptr %53, i32 -1
  %64 = tail call fastcc ptr @text_hole_delete(ptr noundef nonnull %63, ptr noundef nonnull %63) #16
  br label %52, !llvm.loop !103

65:                                               ; preds = %2
  %66 = sext i8 %1 to i32
  %67 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %68 = getelementptr inbounds nuw i8, ptr %67, i32 378
  %69 = load i8, ptr %68, align 2, !tbaa !24
  %70 = zext i8 %69 to i32
  %71 = icmp eq i32 %66, %70
  br i1 %71, label %73, label %72

72:                                               ; preds = %65
  switch i8 %1, label %89 [
    i8 8, label %73
    i8 127, label %73
  ]

73:                                               ; preds = %72, %72, %65
  %74 = getelementptr inbounds nuw i8, ptr %67, i32 20
  %75 = load i32, ptr %74, align 4, !tbaa !32
  %76 = icmp eq i32 %75, 2
  br i1 %76, label %77, label %83

77:                                               ; preds = %73
  %78 = getelementptr inbounds nuw i8, ptr %67, i32 40
  %79 = load ptr, ptr %78, align 4, !tbaa !76
  %80 = icmp ugt ptr %0, %79
  %81 = sext i1 %80 to i32
  %82 = getelementptr inbounds i8, ptr %0, i32 %81
  br label %98

83:                                               ; preds = %73
  %84 = load ptr, ptr %67, align 4, !tbaa !29
  %85 = icmp ugt ptr %0, %84
  br i1 %85, label %86, label %98

86:                                               ; preds = %83
  %87 = getelementptr inbounds i8, ptr %0, i32 -1
  %88 = tail call fastcc ptr @text_hole_delete(ptr noundef nonnull %87, ptr noundef nonnull %87) #16
  br label %98

89:                                               ; preds = %72
  %90 = icmp eq i8 %1, 13
  %91 = select i1 %90, i8 10, i8 %1
  %92 = getelementptr inbounds nuw i8, ptr %67, i32 24
  %93 = load i32, ptr %92, align 4, !tbaa !50
  %94 = add nsw i32 %93, 1
  store i32 %94, ptr %92, align 4, !tbaa !50
  %95 = tail call fastcc i32 @stupid_insert(ptr noundef %0, i8 noundef signext %91) #16
  %96 = getelementptr i8, ptr %0, i32 %95
  %97 = getelementptr i8, ptr %96, i32 1
  br label %98

98:                                               ; preds = %56, %52, %77, %23, %14, %89, %83, %86, %4
  %99 = phi ptr [ %13, %4 ], [ %0, %14 ], [ %88, %86 ], [ %0, %83 ], [ %97, %89 ], [ %27, %23 ], [ %82, %77 ], [ %54, %52 ], [ %54, %56 ]
  ret ptr %99
}

; Function Attrs: minsize nounwind optsize
define internal fastcc noundef nonnull ptr @xstrdup(ptr noundef %0) unnamed_addr #0 {
  %2 = tail call i32 @strlen(ptr noundef %0) #17
  %3 = add nsw i32 %2, 1
  %4 = tail call fastcc ptr @xmalloc(i32 noundef %3) #16
  %5 = tail call ptr @strcpy(ptr noundef nonnull %4, ptr noundef %0) #17
  ret ptr %4
}

; Function Attrs: minsize optsize
declare dso_local i32 @strlen(ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local ptr @strcpy(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @status_line_bold_errno(ptr noundef %0) unnamed_addr #0 {
  tail call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.5, ptr noundef %0) #16
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal void @status_line_bold(ptr noundef readonly captures(none) %0, ...) unnamed_addr #0 {
  %2 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #19
  call void @llvm.va_start.p0(ptr nonnull %2)
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 408
  %5 = call ptr @strcpy(ptr noundef nonnull %4, ptr noundef nonnull @.str.6) #17
  %6 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 412
  %8 = load i32, ptr %2, align 4
  %9 = insertvalue [1 x i32] poison, i32 %8, 0
  %10 = call fastcc i32 @bb_vsnprintf(ptr noundef nonnull %7, i32 noundef 191, ptr noundef %0, [1 x i32] %9) #16
  %11 = getelementptr inbounds nuw i8, ptr %6, i32 408
  br label %12

12:                                               ; preds = %12, %1
  %13 = phi ptr [ %11, %1 ], [ %16, %12 ]
  %14 = load i8, ptr %13, align 1, !tbaa !24
  %15 = icmp eq i8 %14, 0
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 1
  br i1 %15, label %17, label %12, !llvm.loop !104

17:                                               ; preds = %12, %17
  %18 = phi i32 [ %21, %17 ], [ 0, %12 ]
  %19 = phi ptr [ %23, %17 ], [ %13, %12 ]
  %20 = getelementptr inbounds nuw i8, ptr @.str.7, i32 %18
  %21 = add nuw nsw i32 %18, 1
  %22 = load i8, ptr %20, align 1, !tbaa !24
  %23 = getelementptr inbounds nuw i8, ptr %19, i32 1
  store i8 %22, ptr %19, align 1, !tbaa !24
  %24 = icmp eq i32 %18, 3
  br i1 %24, label %25, label %17, !llvm.loop !105

25:                                               ; preds = %17
  call void @llvm.va_end.p0(ptr nonnull %2)
  %26 = getelementptr inbounds nuw i8, ptr %6, i32 64
  store i32 8, ptr %26, align 4, !tbaa !94
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @text_hole_make(ptr noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = icmp slt i32 %1, 1
  br i1 %3, label %73, label %4

4:                                                ; preds = %2
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %7 = load ptr, ptr %6, align 4, !tbaa !48
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 %1
  store ptr %8, ptr %6, align 4, !tbaa !48
  %9 = load ptr, ptr %5, align 4, !tbaa !29
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %11 = load i32, ptr %10, align 4, !tbaa !47
  %12 = getelementptr inbounds i8, ptr %9, i32 %11
  %13 = icmp ult ptr %8, %12
  br i1 %13, label %61, label %14

14:                                               ; preds = %4
  %15 = ptrtoint ptr %8 to i32
  %16 = ptrtoint ptr %12 to i32
  %17 = add i32 %15, 10240
  %18 = add i32 %17, %11
  %19 = sub i32 %18, %16
  store i32 %19, ptr %10, align 4, !tbaa !47
  %20 = icmp eq ptr %9, null
  br i1 %20, label %21, label %23

21:                                               ; preds = %14
  %22 = tail call fastcc ptr @xmalloc(i32 noundef %19) #16
  br label %31

23:                                               ; preds = %14
  %24 = getelementptr inbounds i8, ptr %9, i32 -4
  %25 = load i32, ptr %24, align 4, !tbaa !24
  %26 = shl i32 %25, 3
  %27 = add i32 %26, -8
  %28 = tail call fastcc ptr @xmalloc(i32 noundef %19) #16
  %29 = tail call i32 @llvm.smin.i32(i32 %27, i32 %19)
  %30 = tail call ptr @memmove(ptr noundef nonnull %28, ptr noundef nonnull %9, i32 noundef %29) #17
  tail call void @free(ptr noundef nonnull %9) #17
  br label %31

31:                                               ; preds = %21, %23
  %32 = phi ptr [ %28, %23 ], [ %22, %21 ]
  %33 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %34 = load ptr, ptr %33, align 4, !tbaa !29
  %35 = ptrtoint ptr %32 to i32
  %36 = ptrtoint ptr %34 to i32
  %37 = sub i32 %35, %36
  %38 = getelementptr inbounds nuw i8, ptr %33, i32 76
  %39 = load ptr, ptr %38, align 4, !tbaa !49
  %40 = getelementptr inbounds nuw i8, ptr %39, i32 %37
  store ptr %40, ptr %38, align 4, !tbaa !49
  %41 = getelementptr inbounds nuw i8, ptr %33, i32 8
  %42 = load ptr, ptr %41, align 4, !tbaa !43
  %43 = getelementptr inbounds nuw i8, ptr %42, i32 %37
  store ptr %43, ptr %41, align 4, !tbaa !43
  %44 = getelementptr inbounds nuw i8, ptr %33, i32 4
  %45 = load ptr, ptr %44, align 4, !tbaa !48
  %46 = getelementptr inbounds nuw i8, ptr %45, i32 %37
  store ptr %46, ptr %44, align 4, !tbaa !48
  %47 = getelementptr inbounds nuw i8, ptr %33, i32 264
  br label %48

48:                                               ; preds = %57, %31
  %49 = phi i32 [ 0, %31 ], [ %58, %57 ]
  %50 = icmp eq i32 %49, 28
  br i1 %50, label %59, label %51

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw [28 x ptr], ptr %47, i32 0, i32 %49
  %53 = load ptr, ptr %52, align 4, !tbaa !18
  %54 = icmp eq ptr %53, null
  br i1 %54, label %57, label %55

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %53, i32 %37
  store ptr %56, ptr %52, align 4, !tbaa !18
  br label %57

57:                                               ; preds = %51, %55
  %58 = add nuw nsw i32 %49, 1
  br label %48, !llvm.loop !106

59:                                               ; preds = %48
  %60 = getelementptr inbounds nuw i8, ptr %0, i32 %37
  store ptr %32, ptr %33, align 4, !tbaa !29
  br label %61

61:                                               ; preds = %59, %4
  %62 = phi ptr [ %46, %59 ], [ %8, %4 ]
  %63 = phi ptr [ %60, %59 ], [ %0, %4 ]
  %64 = phi i32 [ %37, %59 ], [ 0, %4 ]
  %65 = getelementptr inbounds nuw i8, ptr %63, i32 %1
  %66 = sub nsw i32 0, %1
  %67 = getelementptr inbounds i8, ptr %62, i32 %66
  %68 = ptrtoint ptr %67 to i32
  %69 = ptrtoint ptr %63 to i32
  %70 = sub i32 %68, %69
  %71 = tail call ptr @memmove(ptr noundef nonnull %65, ptr noundef %63, i32 noundef %70) #17
  %72 = tail call ptr @memset(ptr noundef %63, i32 noundef 32, i32 noundef %1) #17
  br label %73

73:                                               ; preds = %2, %61
  %74 = phi i32 [ %64, %61 ], [ 0, %2 ]
  ret i32 %74
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @text_hole_delete(ptr noundef %0, ptr noundef %1) unnamed_addr #0 {
  %3 = icmp ult ptr %1, %0
  %4 = select i1 %3, ptr %1, ptr %0
  %5 = select i1 %3, ptr %0, ptr %1
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %7 = ptrtoint ptr %1 to i32
  %8 = ptrtoint ptr %0 to i32
  %9 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 4
  %11 = load ptr, ptr %10, align 4, !tbaa !48
  %12 = ptrtoint ptr %11 to i32
  %13 = ptrtoint ptr %6 to i32
  %14 = sub i32 %12, %13
  %15 = load ptr, ptr %9, align 4, !tbaa !29
  %16 = icmp ult ptr %6, %15
  br i1 %16, label %48, label %17

17:                                               ; preds = %2
  %18 = icmp ugt ptr %6, %11
  br i1 %18, label %48, label %19

19:                                               ; preds = %17
  %20 = icmp uge ptr %4, %15
  %21 = icmp ult ptr %4, %11
  %22 = select i1 %20, i1 %21, i1 false
  br i1 %22, label %23, label %48

23:                                               ; preds = %19
  %24 = getelementptr inbounds nuw i8, ptr %9, i32 24
  %25 = load i32, ptr %24, align 4, !tbaa !50
  %26 = add nsw i32 %25, 1
  store i32 %26, ptr %24, align 4, !tbaa !50
  %27 = icmp ult ptr %6, %11
  br i1 %27, label %28, label %34

28:                                               ; preds = %23
  %29 = tail call ptr @memmove(ptr noundef %4, ptr noundef nonnull %6, i32 noundef %14) #17
  %30 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %31 = getelementptr inbounds nuw i8, ptr %30, i32 4
  %32 = load ptr, ptr %31, align 4, !tbaa !48
  %33 = load ptr, ptr %30, align 4, !tbaa !29
  br label %34

34:                                               ; preds = %23, %28
  %35 = phi ptr [ %15, %23 ], [ %33, %28 ]
  %36 = phi ptr [ %11, %23 ], [ %32, %28 ]
  %37 = phi ptr [ %9, %23 ], [ %30, %28 ]
  %38 = getelementptr inbounds nuw i8, ptr %37, i32 4
  %39 = xor i32 %7, -1
  %40 = getelementptr i8, ptr %36, i32 %39
  %41 = getelementptr i8, ptr %40, i32 %8
  %42 = icmp ult ptr %4, %41
  %43 = getelementptr inbounds i8, ptr %41, i32 -1
  %44 = select i1 %42, ptr %4, ptr %43
  %45 = icmp ugt ptr %41, %35
  %46 = select i1 %45, ptr %41, ptr %35
  store ptr %46, ptr %38, align 4
  %47 = select i1 %45, ptr %44, ptr %35
  br label %48

48:                                               ; preds = %34, %19, %2, %17
  %49 = phi ptr [ %4, %2 ], [ %4, %17 ], [ %4, %19 ], [ %47, %34 ]
  ret ptr %49
}

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #6

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none)
define internal fastcc i32 @bb_vsnprintf(ptr noundef writeonly captures(none) %0, i32 noundef range(i32 1, 134217728) %1, ptr noundef readonly captures(none) %2, [1 x i32] %3) unnamed_addr #7 {
  %5 = alloca [12 x i8], align 1
  %6 = extractvalue [1 x i32] %3, 0
  %7 = inttoptr i32 %6 to ptr
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %5) #19
  br label %8

8:                                                ; preds = %100, %4
  %9 = phi i32 [ 0, %4 ], [ %101, %100 ]
  %10 = phi ptr [ %2, %4 ], [ %104, %100 ]
  %11 = phi ptr [ %7, %4 ], [ %103, %100 ]
  %12 = load i8, ptr %10, align 1, !tbaa !24
  switch i8 %12, label %13 [
    i8 0, label %105
    i8 37, label %18
  ]

13:                                               ; preds = %8
  %14 = add nsw i32 %9, 1
  %15 = icmp slt i32 %14, %1
  br i1 %15, label %16, label %100

16:                                               ; preds = %13
  %17 = getelementptr inbounds i8, ptr %0, i32 %9
  store i8 %12, ptr %17, align 1, !tbaa !24
  br label %100

18:                                               ; preds = %8
  %19 = getelementptr inbounds nuw i8, ptr %10, i32 1
  %20 = load i8, ptr %19, align 1, !tbaa !24
  switch i8 %20, label %91 [
    i8 37, label %21
    i8 99, label %26
    i8 115, label %34
    i8 100, label %50
    i8 117, label %50
  ]

21:                                               ; preds = %18
  %22 = add nsw i32 %9, 1
  %23 = icmp slt i32 %22, %1
  br i1 %23, label %24, label %100

24:                                               ; preds = %21
  %25 = getelementptr inbounds i8, ptr %0, i32 %9
  store i8 37, ptr %25, align 1, !tbaa !24
  br label %100

26:                                               ; preds = %18
  %27 = getelementptr inbounds nuw i8, ptr %11, i32 4
  %28 = add nsw i32 %9, 1
  %29 = icmp slt i32 %28, %1
  br i1 %29, label %30, label %100

30:                                               ; preds = %26
  %31 = load i32, ptr %11, align 4, !tbaa !16
  %32 = trunc i32 %31 to i8
  %33 = getelementptr inbounds i8, ptr %0, i32 %9
  store i8 %32, ptr %33, align 1, !tbaa !24
  br label %100

34:                                               ; preds = %18
  %35 = load ptr, ptr %11, align 4, !tbaa !18
  %36 = icmp eq ptr %35, null
  %37 = select i1 %36, ptr @.str.8, ptr %35
  br label %38

38:                                               ; preds = %48, %34
  %39 = phi i32 [ %9, %34 ], [ %44, %48 ]
  %40 = phi ptr [ %37, %34 ], [ %49, %48 ]
  %41 = load i8, ptr %40, align 1, !tbaa !24
  %42 = icmp eq i8 %41, 0
  br i1 %42, label %98, label %43

43:                                               ; preds = %38
  %44 = add nsw i32 %39, 1
  %45 = icmp slt i32 %44, %1
  br i1 %45, label %46, label %48

46:                                               ; preds = %43
  %47 = getelementptr inbounds i8, ptr %0, i32 %39
  store i8 %41, ptr %47, align 1, !tbaa !24
  br label %48

48:                                               ; preds = %46, %43
  %49 = getelementptr inbounds nuw i8, ptr %40, i32 1
  br label %38, !llvm.loop !107

50:                                               ; preds = %18, %18
  %51 = load i32, ptr %11, align 4, !tbaa !16
  %52 = icmp eq i8 %20, 100
  %53 = tail call i32 @llvm.abs.i32(i32 %51, i1 true)
  %54 = select i1 %52, i32 %53, i32 %51
  br label %55

55:                                               ; preds = %55, %50
  %56 = phi i32 [ %54, %50 ], [ %59, %55 ]
  %57 = phi i32 [ 12, %50 ], [ %64, %55 ]
  %58 = freeze i32 %56
  %59 = udiv i32 %58, 10
  %60 = mul i32 %59, 10
  %61 = sub i32 %58, %60
  %62 = trunc nuw nsw i32 %61 to i8
  %63 = or disjoint i8 %62, 48
  %64 = add nsw i32 %57, -1
  %65 = getelementptr inbounds [12 x i8], ptr %5, i32 0, i32 %64
  store i8 %63, ptr %65, align 1, !tbaa !24
  %66 = icmp ult i32 %56, 10
  br i1 %66, label %67, label %55, !llvm.loop !108

67:                                               ; preds = %55
  %68 = getelementptr inbounds nuw i8, ptr %11, i32 4
  %69 = icmp slt i32 %51, 0
  %70 = load i8, ptr %19, align 1, !tbaa !24
  %71 = icmp eq i8 %70, 100
  %72 = select i1 %71, i1 %69, i1 false
  br i1 %72, label %73, label %76

73:                                               ; preds = %67
  %74 = add nsw i32 %57, -2
  %75 = getelementptr inbounds [12 x i8], ptr %5, i32 0, i32 %74
  store i8 45, ptr %75, align 1, !tbaa !24
  br label %76

76:                                               ; preds = %73, %67
  %77 = phi i32 [ %64, %67 ], [ %74, %73 ]
  br label %78

78:                                               ; preds = %76, %89
  %79 = phi i32 [ %83, %89 ], [ %9, %76 ]
  %80 = phi i32 [ %90, %89 ], [ %77, %76 ]
  %81 = icmp slt i32 %80, 12
  br i1 %81, label %82, label %100

82:                                               ; preds = %78
  %83 = add nsw i32 %79, 1
  %84 = icmp slt i32 %83, %1
  br i1 %84, label %85, label %89

85:                                               ; preds = %82
  %86 = getelementptr inbounds [12 x i8], ptr %5, i32 0, i32 %80
  %87 = load i8, ptr %86, align 1, !tbaa !24
  %88 = getelementptr inbounds i8, ptr %0, i32 %79
  store i8 %87, ptr %88, align 1, !tbaa !24
  br label %89

89:                                               ; preds = %85, %82
  %90 = add nsw i32 %80, 1
  br label %78, !llvm.loop !109

91:                                               ; preds = %18
  %92 = add nsw i32 %9, 2
  %93 = icmp slt i32 %92, %1
  br i1 %93, label %94, label %100

94:                                               ; preds = %91
  %95 = getelementptr inbounds i8, ptr %0, i32 %9
  store i8 37, ptr %95, align 1, !tbaa !24
  %96 = load i8, ptr %19, align 1, !tbaa !24
  %97 = getelementptr i8, ptr %95, i32 1
  store i8 %96, ptr %97, align 1, !tbaa !24
  br label %100

98:                                               ; preds = %38
  %99 = getelementptr inbounds nuw i8, ptr %11, i32 4
  br label %100

100:                                              ; preds = %78, %98, %91, %94, %26, %30, %21, %24, %13, %16
  %101 = phi i32 [ %14, %16 ], [ %14, %13 ], [ %22, %24 ], [ %22, %21 ], [ %28, %30 ], [ %28, %26 ], [ %92, %94 ], [ %92, %91 ], [ %39, %98 ], [ %79, %78 ]
  %102 = phi ptr [ %10, %16 ], [ %10, %13 ], [ %19, %24 ], [ %19, %21 ], [ %19, %30 ], [ %19, %26 ], [ %19, %94 ], [ %19, %91 ], [ %19, %98 ], [ %19, %78 ]
  %103 = phi ptr [ %11, %16 ], [ %11, %13 ], [ %11, %24 ], [ %11, %21 ], [ %27, %30 ], [ %27, %26 ], [ %11, %94 ], [ %11, %91 ], [ %99, %98 ], [ %68, %78 ]
  %104 = getelementptr inbounds nuw i8, ptr %102, i32 1
  br label %8, !llvm.loop !110

105:                                              ; preds = %8
  %106 = add nsw i32 %1, -1
  %107 = tail call i32 @llvm.smin.i32(i32 %9, i32 %106)
  %108 = getelementptr inbounds i8, ptr %0, i32 %107
  store i8 0, ptr %108, align 1, !tbaa !24
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %5) #19
  ret i32 %9
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #6

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @stupid_insert(ptr noundef %0, i8 noundef signext %1) unnamed_addr #0 {
  %3 = tail call fastcc i32 @text_hole_make(ptr noundef %0, i32 noundef 1) #16
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  store i8 %1, ptr %4, align 1, !tbaa !24
  ret i32 %3
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc range(i32 -2147483647, -2147483648) i32 @get_column(ptr noundef readonly %0) unnamed_addr #5 {
  %2 = tail call fastcc ptr @begin_line(ptr noundef %0) #16
  br label %3

3:                                                ; preds = %7, %1
  %4 = phi ptr [ %2, %1 ], [ %10, %7 ]
  %5 = phi i32 [ 0, %1 ], [ %9, %7 ]
  %6 = icmp ult ptr %4, %0
  br i1 %6, label %7, label %11

7:                                                ; preds = %3
  %8 = load i8, ptr %4, align 1, !tbaa !24
  %9 = tail call fastcc i32 @next_column(i8 noundef signext %8, i32 noundef %5) #16
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 1
  br label %3, !llvm.loop !111

11:                                               ; preds = %3
  ret i32 %5
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc range(i32 -2147483647, -2147483648) i32 @next_column(i8 noundef signext %0, i32 noundef %1) unnamed_addr #8 {
  %3 = icmp eq i8 %0, 9
  br i1 %3, label %4, label %12

4:                                                ; preds = %2
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 88
  %7 = load i32, ptr %6, align 4, !tbaa !15
  %8 = srem i32 %1, %7
  %9 = xor i32 %8, -1
  %10 = add i32 %7, %1
  %11 = add i32 %10, %9
  br label %18

12:                                               ; preds = %2
  %13 = icmp ult i8 %0, 32
  br i1 %13, label %16, label %14

14:                                               ; preds = %12
  %15 = icmp eq i8 %0, 127
  br i1 %15, label %16, label %18

16:                                               ; preds = %14, %12
  %17 = add nsw i32 %1, 1
  br label %18

18:                                               ; preds = %14, %16, %4
  %19 = phi i32 [ %11, %4 ], [ %17, %16 ], [ %1, %14 ]
  %20 = add nsw i32 %19, 1
  ret i32 %20
}

; Function Attrs: minsize optsize
declare dso_local ptr @strchr(ptr noundef, i8 noundef signext) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @colon(ptr noundef %0) unnamed_addr #0 {
  %2 = alloca [10 x i8], align 1
  %3 = alloca %struct.stat, align 4
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %2) #19
  br label %4

4:                                                ; preds = %4, %1
  %5 = phi ptr [ %0, %1 ], [ %8, %4 ]
  %6 = load i8, ptr %5, align 1, !tbaa !24
  %7 = icmp eq i8 %6, 58
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br i1 %7, label %4, label %9, !llvm.loop !112

9:                                                ; preds = %4
  %10 = tail call fastcc ptr @skip_whitespace(ptr noundef nonnull %5) #16
  %11 = load i8, ptr %10, align 1, !tbaa !24
  switch i8 %11, label %12 [
    i8 0, label %796
    i8 34, label %796
  ]

12:                                               ; preds = %9
  %13 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %15 = load ptr, ptr %14, align 4, !tbaa !43
  br label %16

16:                                               ; preds = %217, %12
  %17 = phi ptr [ %13, %12 ], [ %218, %217 ]
  %18 = phi i8 [ %11, %12 ], [ %227, %217 ]
  %19 = phi i32 [ -1, %12 ], [ %219, %217 ]
  %20 = phi i32 [ -1, %12 ], [ %220, %217 ]
  %21 = phi i32 [ 0, %12 ], [ %221, %217 ]
  %22 = phi ptr [ %13, %12 ], [ %222, %217 ]
  %23 = phi ptr [ %13, %12 ], [ %223, %217 ]
  %24 = phi ptr [ %13, %12 ], [ %224, %217 ]
  %25 = phi i32 [ 0, %12 ], [ %225, %217 ]
  %26 = phi ptr [ %10, %12 ], [ %226, %217 ]
  switch i8 %18, label %29 [
    i8 32, label %27
    i8 9, label %27
  ]

27:                                               ; preds = %16, %16
  %28 = getelementptr inbounds nuw i8, ptr %26, i32 1
  br label %217

29:                                               ; preds = %16
  %30 = icmp eq i32 %25, 0
  br i1 %30, label %31, label %211

31:                                               ; preds = %29
  %32 = icmp eq i8 %18, 37
  br i1 %32, label %33, label %40

33:                                               ; preds = %31
  %34 = getelementptr inbounds nuw i8, ptr %26, i32 1
  %35 = load ptr, ptr %22, align 4, !tbaa !29
  %36 = getelementptr inbounds nuw i8, ptr %22, i32 4
  %37 = load ptr, ptr %36, align 4, !tbaa !48
  %38 = getelementptr inbounds i8, ptr %37, i32 -1
  %39 = tail call fastcc i32 @count_lines(ptr noundef %35, ptr noundef nonnull %38) #16
  br label %217

40:                                               ; preds = %31
  %41 = load ptr, ptr %23, align 4, !tbaa !29
  %42 = getelementptr inbounds nuw i8, ptr %23, i32 8
  %43 = load ptr, ptr %42, align 4, !tbaa !43
  %44 = tail call fastcc i32 @count_lines(ptr noundef %41, ptr noundef %43) #16
  br label %45

45:                                               ; preds = %188, %40
  %46 = phi ptr [ %17, %40 ], [ %189, %188 ]
  %47 = phi ptr [ %22, %40 ], [ %190, %188 ]
  %48 = phi i8 [ %18, %40 ], [ %201, %188 ]
  %49 = phi ptr [ %23, %40 ], [ %191, %188 ]
  %50 = phi ptr [ %41, %40 ], [ %192, %188 ]
  %51 = phi ptr [ %23, %40 ], [ %193, %188 ]
  %52 = phi ptr [ %41, %40 ], [ %194, %188 ]
  %53 = phi ptr [ %23, %40 ], [ %195, %188 ]
  %54 = phi ptr [ %23, %40 ], [ %196, %188 ]
  %55 = phi ptr [ %26, %40 ], [ %197, %188 ]
  %56 = phi i32 [ 0, %40 ], [ %198, %188 ]
  %57 = phi i32 [ %44, %40 ], [ %199, %188 ]
  %58 = phi i32 [ 0, %40 ], [ %200, %188 ]
  %59 = sext i8 %48 to i32
  switch i8 %48, label %66 [
    i8 32, label %60
    i8 9, label %60
  ]

60:                                               ; preds = %45, %45
  %61 = icmp eq i32 %58, 0
  %62 = select i1 %61, i32 %56, i32 0
  %63 = select i1 %61, i32 0, i32 %56
  %64 = add nsw i32 %63, %57
  %65 = getelementptr inbounds nuw i8, ptr %55, i32 1
  br label %188

66:                                               ; preds = %45
  %67 = icmp eq i32 %58, 0
  br i1 %67, label %68, label %159

68:                                               ; preds = %66
  switch i8 %48, label %159 [
    i8 46, label %70
    i8 36, label %72
    i8 39, label %78
    i8 47, label %69
    i8 63, label %69
  ]

69:                                               ; preds = %68, %68
  br label %100

70:                                               ; preds = %68
  %71 = getelementptr inbounds nuw i8, ptr %55, i32 1
  br label %188

72:                                               ; preds = %68
  %73 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %74 = getelementptr inbounds nuw i8, ptr %51, i32 4
  %75 = load ptr, ptr %74, align 4, !tbaa !48
  %76 = getelementptr inbounds i8, ptr %75, i32 -1
  %77 = tail call fastcc i32 @count_lines(ptr noundef %50, ptr noundef nonnull %76) #16
  br label %188

78:                                               ; preds = %68
  %79 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %80 = load i8, ptr %79, align 1, !tbaa !24
  %81 = sext i8 %80 to i32
  %82 = add nsw i32 %81, -91
  %83 = icmp ult i32 %82, -26
  %84 = add nuw nsw i32 %81, 32
  %85 = select i1 %83, i32 %81, i32 %84
  %86 = getelementptr inbounds nuw i8, ptr %55, i32 2
  %87 = shl i32 %85, 24
  %88 = ashr exact i32 %87, 24
  %89 = add nsw i32 %88, -97
  %90 = icmp ult i32 %89, 26
  br i1 %90, label %91, label %228

91:                                               ; preds = %78
  %92 = add nsw i32 %85, 159
  %93 = getelementptr inbounds nuw i8, ptr %54, i32 264
  %94 = and i32 %92, 255
  %95 = getelementptr inbounds nuw [28 x ptr], ptr %93, i32 0, i32 %94
  %96 = load ptr, ptr %95, align 4, !tbaa !18
  %97 = icmp eq ptr %96, null
  br i1 %97, label %228, label %98

98:                                               ; preds = %91
  %99 = tail call fastcc i32 @count_lines(ptr noundef %52, ptr noundef nonnull %96) #16
  br label %188

100:                                              ; preds = %69, %100
  %101 = phi i32 [ %107, %100 ], [ 1, %69 ]
  %102 = getelementptr inbounds nuw i8, ptr %55, i32 %101
  %103 = load i8, ptr %102, align 1, !tbaa !24
  %104 = icmp eq i8 %103, 0
  %105 = icmp eq i8 %48, %103
  %106 = or i1 %104, %105
  %107 = add nuw nsw i32 %101, 1
  br i1 %106, label %108, label %100, !llvm.loop !113

108:                                              ; preds = %100
  %109 = getelementptr inbounds nuw i8, ptr %55, i32 %101
  %110 = icmp eq i32 %101, 1
  br i1 %110, label %118, label %111

111:                                              ; preds = %108
  %112 = getelementptr inbounds nuw i8, ptr %54, i32 100
  %113 = load ptr, ptr %112, align 4, !tbaa !14
  tail call fastcc void @bb_free(ptr noundef %113) #16
  %114 = tail call fastcc ptr @xstrndup(ptr noundef nonnull %55, i32 noundef %101) #16
  %115 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %116 = getelementptr inbounds nuw i8, ptr %115, i32 100
  store ptr %114, ptr %116, align 4, !tbaa !14
  %117 = load i8, ptr %109, align 1, !tbaa !24
  br label %118

118:                                              ; preds = %111, %108
  %119 = phi ptr [ %115, %111 ], [ %54, %108 ]
  %120 = phi i8 [ %117, %111 ], [ %103, %108 ]
  %121 = icmp eq i8 %120, %48
  %122 = zext i1 %121 to i32
  %123 = getelementptr inbounds nuw i8, ptr %109, i32 %122
  %124 = icmp eq i8 %48, 47
  %125 = getelementptr inbounds nuw i8, ptr %119, i32 8
  %126 = load ptr, ptr %125, align 4, !tbaa !43
  br i1 %124, label %127, label %129

127:                                              ; preds = %118
  %128 = tail call fastcc ptr @next_line(ptr noundef %126) #16
  br label %131

129:                                              ; preds = %118
  %130 = tail call fastcc ptr @begin_line(ptr noundef %126) #16
  br label %131

131:                                              ; preds = %129, %127
  %132 = phi ptr [ %128, %127 ], [ %130, %129 ]
  %133 = phi i32 [ 3, %127 ], [ -1, %129 ]
  %134 = getelementptr inbounds nuw i8, ptr %119, i32 100
  %135 = load ptr, ptr %134, align 4, !tbaa !14
  %136 = getelementptr inbounds nuw i8, ptr %135, i32 1
  %137 = tail call fastcc ptr @char_search(ptr noundef %132, ptr noundef nonnull %136, i32 noundef %133) #16
  %138 = icmp eq ptr %137, null
  br i1 %138, label %139, label %154

139:                                              ; preds = %131
  %140 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %124, label %141, label %143

141:                                              ; preds = %139
  %142 = load ptr, ptr %140, align 4, !tbaa !29
  br label %147

143:                                              ; preds = %139
  %144 = getelementptr inbounds nuw i8, ptr %140, i32 4
  %145 = load ptr, ptr %144, align 4, !tbaa !48
  %146 = getelementptr inbounds i8, ptr %145, i32 -1
  br label %147

147:                                              ; preds = %143, %141
  %148 = phi ptr [ %142, %141 ], [ %146, %143 ]
  %149 = getelementptr inbounds nuw i8, ptr %140, i32 100
  %150 = load ptr, ptr %149, align 4, !tbaa !14
  %151 = getelementptr inbounds nuw i8, ptr %150, i32 1
  %152 = tail call fastcc ptr @char_search(ptr noundef %148, ptr noundef nonnull %151, i32 noundef %133) #16
  %153 = icmp eq ptr %152, null
  br i1 %153, label %228, label %154

154:                                              ; preds = %147, %131
  %155 = phi ptr [ %152, %147 ], [ %137, %131 ]
  %156 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %157 = load ptr, ptr %156, align 4, !tbaa !29
  %158 = tail call fastcc i32 @count_lines(ptr noundef %157, ptr noundef nonnull %155) #16
  br label %188

159:                                              ; preds = %68, %66
  %160 = add nsw i32 %59, -58
  %161 = icmp ult i32 %160, -10
  br i1 %161, label %181, label %162

162:                                              ; preds = %159, %169
  %163 = phi i8 [ %174, %169 ], [ %48, %159 ]
  %164 = phi ptr [ %171, %169 ], [ %55, %159 ]
  %165 = phi i32 [ %173, %169 ], [ 0, %159 ]
  %166 = sext i8 %163 to i32
  %167 = add nsw i32 %166, -58
  %168 = icmp ult i32 %167, -10
  br i1 %168, label %175, label %169

169:                                              ; preds = %162
  %170 = mul nsw i32 %165, 10
  %171 = getelementptr inbounds nuw i8, ptr %164, i32 1
  %172 = add nsw i32 %166, -48
  %173 = add i32 %172, %170
  %174 = load i8, ptr %171, align 1, !tbaa !24
  br label %162, !llvm.loop !114

175:                                              ; preds = %162
  %176 = sub nsw i32 0, %165
  %177 = icmp slt i32 %56, 0
  %178 = select i1 %177, i32 %176, i32 %165
  %179 = add nsw i32 %178, %57
  %180 = select i1 %67, i32 %165, i32 %179
  br label %188

181:                                              ; preds = %159
  switch i8 %48, label %202 [
    i8 45, label %182
    i8 43, label %182
  ]

182:                                              ; preds = %181, %181
  %183 = select i1 %67, i32 0, i32 %56
  %184 = add nsw i32 %183, %57
  %185 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %186 = icmp eq i8 %48, 45
  %187 = select i1 %186, i32 -1, i32 1
  br label %188

188:                                              ; preds = %182, %175, %154, %98, %72, %70, %60
  %189 = phi ptr [ %46, %60 ], [ %46, %175 ], [ %46, %182 ], [ %156, %154 ], [ %46, %98 ], [ %46, %72 ], [ %46, %70 ]
  %190 = phi ptr [ %47, %60 ], [ %47, %175 ], [ %47, %182 ], [ %156, %154 ], [ %47, %98 ], [ %47, %72 ], [ %47, %70 ]
  %191 = phi ptr [ %49, %60 ], [ %49, %175 ], [ %49, %182 ], [ %156, %154 ], [ %49, %98 ], [ %49, %72 ], [ %49, %70 ]
  %192 = phi ptr [ %50, %60 ], [ %50, %175 ], [ %50, %182 ], [ %157, %154 ], [ %50, %98 ], [ %50, %72 ], [ %50, %70 ]
  %193 = phi ptr [ %51, %60 ], [ %51, %175 ], [ %51, %182 ], [ %156, %154 ], [ %51, %98 ], [ %51, %72 ], [ %51, %70 ]
  %194 = phi ptr [ %52, %60 ], [ %52, %175 ], [ %52, %182 ], [ %157, %154 ], [ %52, %98 ], [ %50, %72 ], [ %52, %70 ]
  %195 = phi ptr [ %53, %60 ], [ %53, %175 ], [ %53, %182 ], [ %156, %154 ], [ %53, %98 ], [ %51, %72 ], [ %53, %70 ]
  %196 = phi ptr [ %54, %60 ], [ %54, %175 ], [ %54, %182 ], [ %156, %154 ], [ %53, %98 ], [ %51, %72 ], [ %54, %70 ]
  %197 = phi ptr [ %65, %60 ], [ %164, %175 ], [ %185, %182 ], [ %123, %154 ], [ %86, %98 ], [ %73, %72 ], [ %71, %70 ]
  %198 = phi i32 [ %62, %60 ], [ 0, %175 ], [ %187, %182 ], [ %56, %154 ], [ %56, %98 ], [ %56, %72 ], [ %56, %70 ]
  %199 = phi i32 [ %64, %60 ], [ %180, %175 ], [ %184, %182 ], [ %158, %154 ], [ %99, %98 ], [ %77, %72 ], [ %57, %70 ]
  %200 = phi i32 [ %58, %60 ], [ 1, %175 ], [ 1, %182 ], [ 1, %154 ], [ 1, %98 ], [ 1, %72 ], [ 1, %70 ]
  %201 = load i8, ptr %197, align 1, !tbaa !24
  br label %45, !llvm.loop !115

202:                                              ; preds = %181
  %203 = add nsw i32 %57, %56
  br i1 %67, label %204, label %208

204:                                              ; preds = %202
  switch i8 %48, label %205 [
    i8 44, label %208
    i8 59, label %208
  ]

205:                                              ; preds = %204
  %206 = and i32 %21, 1
  %207 = icmp eq i32 %206, 0
  br i1 %207, label %232, label %208

208:                                              ; preds = %205, %204, %204, %202
  %209 = shl i32 %21, 1
  %210 = or disjoint i32 %209, 1
  br label %217

211:                                              ; preds = %29
  switch i8 %18, label %232 [
    i8 59, label %212
    i8 44, label %215
  ]

212:                                              ; preds = %211
  %213 = tail call fastcc ptr @find_line(i32 noundef %20) #16
  %214 = getelementptr inbounds nuw i8, ptr %24, i32 8
  store ptr %213, ptr %214, align 4, !tbaa !43
  br label %215

215:                                              ; preds = %212, %211
  %216 = getelementptr inbounds nuw i8, ptr %26, i32 1
  br label %217

217:                                              ; preds = %215, %208, %33, %27
  %218 = phi ptr [ %17, %33 ], [ %46, %208 ], [ %17, %215 ], [ %17, %27 ]
  %219 = phi i32 [ 1, %33 ], [ %20, %208 ], [ %19, %215 ], [ %19, %27 ]
  %220 = phi i32 [ %39, %33 ], [ %203, %208 ], [ %20, %215 ], [ %20, %27 ]
  %221 = phi i32 [ 3, %33 ], [ %210, %208 ], [ %21, %215 ], [ %21, %27 ]
  %222 = phi ptr [ %22, %33 ], [ %47, %208 ], [ %22, %215 ], [ %22, %27 ]
  %223 = phi ptr [ %22, %33 ], [ %49, %208 ], [ %23, %215 ], [ %23, %27 ]
  %224 = phi ptr [ %22, %33 ], [ %51, %208 ], [ %24, %215 ], [ %24, %27 ]
  %225 = phi i32 [ 1, %33 ], [ 1, %208 ], [ 0, %215 ], [ %25, %27 ]
  %226 = phi ptr [ %34, %33 ], [ %55, %208 ], [ %216, %215 ], [ %28, %27 ]
  %227 = load i8, ptr %226, align 1, !tbaa !24
  br label %16, !llvm.loop !116

228:                                              ; preds = %78, %91, %147
  %229 = phi ptr [ @.str.42, %91 ], [ @.str.42, %78 ], [ @.str.43, %147 ]
  tail call void (ptr, ...) @status_line_bold(ptr noundef nonnull %229) #16
  %230 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %231 = getelementptr inbounds nuw i8, ptr %230, i32 8
  store ptr %15, ptr %231, align 4, !tbaa !43
  br label %796

232:                                              ; preds = %205, %211
  %233 = phi ptr [ %17, %211 ], [ %46, %205 ]
  %234 = phi ptr [ %26, %211 ], [ %55, %205 ]
  %235 = getelementptr inbounds nuw i8, ptr %233, i32 8
  store ptr %15, ptr %235, align 4, !tbaa !43
  br label %236

236:                                              ; preds = %244, %232
  %237 = phi i32 [ 0, %232 ], [ %246, %244 ]
  %238 = icmp eq i32 %237, 9
  br i1 %238, label %239, label %240

239:                                              ; preds = %240, %236
  br label %247

240:                                              ; preds = %236
  %241 = getelementptr inbounds nuw i8, ptr %234, i32 %237
  %242 = load i8, ptr %241, align 1, !tbaa !24
  %243 = icmp eq i8 %242, 0
  br i1 %243, label %239, label %244

244:                                              ; preds = %240
  %245 = getelementptr inbounds nuw i8, ptr %2, i32 %237
  store i8 %242, ptr %245, align 1, !tbaa !24
  %246 = add nuw nsw i32 %237, 1
  br label %236, !llvm.loop !117

247:                                              ; preds = %239, %250
  %248 = phi i32 [ %252, %250 ], [ %237, %239 ]
  %249 = icmp samesign ult i32 %248, 9
  br i1 %249, label %250, label %253

250:                                              ; preds = %247
  %251 = getelementptr inbounds nuw i8, ptr %2, i32 %248
  store i8 0, ptr %251, align 1, !tbaa !24
  %252 = add nuw nsw i32 %248, 1
  br label %247, !llvm.loop !118

253:                                              ; preds = %247
  %254 = getelementptr inbounds nuw i8, ptr %2, i32 9
  store i8 0, ptr %254, align 1, !tbaa !24
  %255 = call fastcc ptr @skip_non_whitespace(ptr noundef %2) #16
  store i8 0, ptr %255, align 1, !tbaa !24
  %256 = load i8, ptr %2, align 1, !tbaa !24
  %257 = icmp eq i8 %256, 0
  br i1 %257, label %267, label %258

258:                                              ; preds = %253
  %259 = call i32 @strlen(ptr noundef nonnull %2) #17
  %260 = getelementptr i8, ptr %2, i32 %259
  %261 = getelementptr i8, ptr %260, i32 -1
  %262 = load i8, ptr %261, align 1, !tbaa !24
  %263 = icmp eq i8 %262, 33
  br i1 %263, label %264, label %267

264:                                              ; preds = %258
  %265 = icmp ugt ptr %261, %2
  br i1 %265, label %266, label %267

266:                                              ; preds = %264
  store i8 0, ptr %261, align 1, !tbaa !24
  br label %267

267:                                              ; preds = %258, %253, %266, %264
  %268 = phi i1 [ false, %266 ], [ false, %264 ], [ true, %253 ], [ true, %258 ]
  %269 = call fastcc ptr @skip_non_whitespace(ptr noundef %234) #16
  %270 = call fastcc ptr @skip_whitespace(ptr noundef nonnull %269) #16
  %271 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %272 = load ptr, ptr %271, align 4, !tbaa !29
  %273 = getelementptr inbounds nuw i8, ptr %271, i32 4
  %274 = load ptr, ptr %273, align 4, !tbaa !48
  %275 = getelementptr inbounds i8, ptr %274, i32 -1
  %276 = and i32 %21, 1
  %277 = icmp eq i32 %276, 0
  br i1 %277, label %300, label %278

278:                                              ; preds = %267
  %279 = icmp slt i32 %20, 0
  br i1 %279, label %283, label %280

280:                                              ; preds = %278
  %281 = call fastcc i32 @count_lines(ptr noundef %272, ptr noundef nonnull %275) #16
  %282 = icmp sgt i32 %20, %281
  br i1 %282, label %283, label %284

283:                                              ; preds = %280, %278
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.9) #16
  br label %796

284:                                              ; preds = %280
  %285 = call fastcc ptr @find_line(i32 noundef %20) #16
  %286 = and i32 %21, 3
  %287 = icmp eq i32 %286, 3
  br i1 %287, label %288, label %297

288:                                              ; preds = %284
  %289 = icmp slt i32 %19, 0
  br i1 %289, label %294, label %290

290:                                              ; preds = %288
  %291 = icmp samesign ugt i32 %19, %281
  br i1 %291, label %294, label %292

292:                                              ; preds = %290
  %293 = icmp samesign ugt i32 %19, %20
  br i1 %293, label %294, label %295

294:                                              ; preds = %292, %290, %288
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.9) #16
  br label %796

295:                                              ; preds = %292
  %296 = call fastcc ptr @find_line(i32 noundef %19) #16
  br label %297

297:                                              ; preds = %284, %295
  %298 = phi ptr [ %296, %295 ], [ %285, %284 ]
  %299 = call fastcc ptr @end_line(ptr noundef %285) #16
  br label %300

300:                                              ; preds = %297, %267
  %301 = phi ptr [ %275, %267 ], [ %299, %297 ]
  %302 = phi ptr [ %272, %267 ], [ %298, %297 ]
  %303 = call i32 @strlen(ptr noundef nonnull %2) #17
  %304 = icmp eq i32 %303, 0
  br i1 %304, label %305, label %311

305:                                              ; preds = %300
  %306 = icmp sgt i32 %20, -1
  br i1 %306, label %307, label %796

307:                                              ; preds = %305
  %308 = call fastcc ptr @find_line(i32 noundef %20) #16
  %309 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %310 = getelementptr inbounds nuw i8, ptr %309, i32 8
  store ptr %308, ptr %310, align 4, !tbaa !43
  call fastcc void @dot_skip_over_ws() #16
  br label %796

311:                                              ; preds = %300
  %312 = load i8, ptr %2, align 1, !tbaa !24
  %313 = icmp eq i8 %312, 61
  %314 = getelementptr inbounds nuw i8, ptr %2, i32 1
  %315 = load i8, ptr %314, align 1
  %316 = icmp eq i8 %315, 0
  %317 = select i1 %313, i1 %316, i1 false
  br i1 %317, label %318, label %327

318:                                              ; preds = %311
  br i1 %277, label %319, label %325

319:                                              ; preds = %318
  %320 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %321 = load ptr, ptr %320, align 4, !tbaa !29
  %322 = getelementptr inbounds nuw i8, ptr %320, i32 8
  %323 = load ptr, ptr %322, align 4, !tbaa !43
  %324 = call fastcc i32 @count_lines(ptr noundef %321, ptr noundef %323) #16
  br label %325

325:                                              ; preds = %319, %318
  %326 = phi i32 [ %324, %319 ], [ %20, %318 ]
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.10, i32 noundef %326) #16
  br label %796

327:                                              ; preds = %311
  %328 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.11, i32 noundef %303) #16
  %329 = icmp eq i32 %328, 0
  br i1 %329, label %330, label %343

330:                                              ; preds = %327
  br i1 %277, label %331, label %337

331:                                              ; preds = %330
  %332 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %333 = getelementptr inbounds nuw i8, ptr %332, i32 8
  %334 = load ptr, ptr %333, align 4, !tbaa !43
  %335 = call fastcc ptr @begin_line(ptr noundef %334) #16
  %336 = call fastcc ptr @end_line(ptr noundef %334) #16
  br label %337

337:                                              ; preds = %331, %330
  %338 = phi ptr [ %301, %330 ], [ %336, %331 ]
  %339 = phi ptr [ %302, %330 ], [ %335, %331 ]
  %340 = call fastcc ptr @yank_delete(ptr noundef %339, ptr noundef %338, i32 noundef 1, i32 noundef 1) #16
  %341 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %342 = getelementptr inbounds nuw i8, ptr %341, i32 8
  store ptr %340, ptr %342, align 4, !tbaa !43
  call fastcc void @dot_skip_over_ws() #16
  br label %796

343:                                              ; preds = %327
  %344 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.12, i32 noundef %303) #16
  %345 = icmp eq i32 %344, 0
  br i1 %345, label %346, label %389

346:                                              ; preds = %343
  %347 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %348 = getelementptr inbounds nuw i8, ptr %347, i32 24
  %349 = load i32, ptr %348, align 4, !tbaa !50
  %350 = icmp ne i32 %349, 0
  %351 = and i1 %268, %350
  br i1 %351, label %352, label %353

352:                                              ; preds = %346
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.13, ptr noundef nonnull %2) #16
  br label %796

353:                                              ; preds = %346
  %354 = load i8, ptr %270, align 1, !tbaa !24
  %355 = icmp eq i8 %354, 0
  br i1 %355, label %356, label %361

356:                                              ; preds = %353
  %357 = getelementptr inbounds nuw i8, ptr %347, i32 72
  %358 = load ptr, ptr %357, align 4, !tbaa !78
  %359 = icmp eq ptr %358, null
  br i1 %359, label %360, label %361

360:                                              ; preds = %356
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.14) #16
  br label %796

361:                                              ; preds = %353, %356
  %362 = phi ptr [ %358, %356 ], [ %270, %353 ]
  %363 = call fastcc i32 @init_text_buffer(ptr noundef nonnull %362) #16
  %364 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %365 = getelementptr inbounds nuw i8, ptr %364, i32 232
  %366 = load ptr, ptr %365, align 4, !tbaa !18
  call fastcc void @bb_free(ptr noundef %366) #16
  %367 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %368 = getelementptr inbounds nuw i8, ptr %367, i32 232
  store ptr null, ptr %368, align 4, !tbaa !18
  %369 = getelementptr inbounds nuw i8, ptr %367, i32 124
  %370 = getelementptr inbounds nuw i8, ptr %367, i32 120
  %371 = load i32, ptr %370, align 4, !tbaa !28
  %372 = getelementptr inbounds nuw [28 x ptr], ptr %369, i32 0, i32 %371
  %373 = load ptr, ptr %372, align 4, !tbaa !18
  call fastcc void @bb_free(ptr noundef %373) #16
  %374 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %375 = getelementptr inbounds nuw i8, ptr %374, i32 124
  %376 = getelementptr inbounds nuw i8, ptr %374, i32 120
  %377 = load i32, ptr %376, align 4, !tbaa !28
  %378 = getelementptr inbounds nuw [28 x ptr], ptr %375, i32 0, i32 %377
  store ptr null, ptr %378, align 4, !tbaa !18
  %379 = icmp slt i32 %363, 0
  %380 = select i1 %379, ptr @.str.16, ptr @.str.17
  %381 = load ptr, ptr %374, align 4, !tbaa !29
  %382 = getelementptr inbounds nuw i8, ptr %374, i32 4
  %383 = load ptr, ptr %382, align 4, !tbaa !48
  %384 = getelementptr inbounds i8, ptr %383, i32 -1
  %385 = call fastcc i32 @count_lines(ptr noundef %381, ptr noundef nonnull %384) #16
  %386 = ptrtoint ptr %383 to i32
  %387 = ptrtoint ptr %381 to i32
  %388 = sub i32 %386, %387
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.15, ptr noundef nonnull %362, ptr noundef nonnull %380, i32 noundef %385, i32 noundef %388) #16
  br label %796

389:                                              ; preds = %343
  %390 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.18, i32 noundef %303) #16
  %391 = icmp eq i32 %390, 0
  br i1 %391, label %392, label %402

392:                                              ; preds = %389
  %393 = icmp sgt i32 %20, -1
  br i1 %393, label %394, label %395

394:                                              ; preds = %392
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.19) #16
  br label %796

395:                                              ; preds = %392
  %396 = load i8, ptr %270, align 1, !tbaa !24
  %397 = icmp eq i8 %396, 0
  br i1 %397, label %399, label %398

398:                                              ; preds = %395
  call fastcc void @update_filename(ptr noundef nonnull %270) #16
  br label %796

399:                                              ; preds = %395
  %400 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %401 = getelementptr inbounds nuw i8, ptr %400, i32 68
  store i32 0, ptr %401, align 4, !tbaa !51
  br label %796

402:                                              ; preds = %389
  %403 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.20, i32 noundef %303) #16
  %404 = icmp eq i32 %403, 0
  br i1 %404, label %405, label %406

405:                                              ; preds = %402
  call fastcc void @go_bottom_and_clear_to_eol() #16
  call fastcc void @cookmode() #16
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.44) #17
  call void @fputstr(i32 noundef 1, ptr noundef nonnull @.str.45) #17
  call fastcc void @rawmode() #16
  call fastcc void @Hit_Return() #16
  br label %796

406:                                              ; preds = %402
  %407 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.21, i32 noundef %303) #16
  %408 = icmp eq i32 %407, 0
  br i1 %408, label %409, label %457

409:                                              ; preds = %406
  %410 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %277, label %411, label %416

411:                                              ; preds = %409
  %412 = getelementptr inbounds nuw i8, ptr %410, i32 8
  %413 = load ptr, ptr %412, align 4, !tbaa !43
  %414 = call fastcc ptr @begin_line(ptr noundef %413) #16
  %415 = call fastcc ptr @end_line(ptr noundef %413) #16
  br label %416

416:                                              ; preds = %411, %409
  %417 = phi ptr [ %301, %409 ], [ %415, %411 ]
  %418 = phi ptr [ %302, %409 ], [ %414, %411 ]
  %419 = getelementptr inbounds nuw i8, ptr %410, i32 64
  store i32 1, ptr %419, align 4, !tbaa !94
  %420 = getelementptr inbounds nuw i8, ptr %410, i32 408
  %421 = getelementptr inbounds nuw i8, ptr %410, i32 597
  br label %422

422:                                              ; preds = %453, %416
  %423 = phi ptr [ %420, %416 ], [ %454, %453 ]
  %424 = phi ptr [ %418, %416 ], [ %429, %453 ]
  %425 = icmp ule ptr %424, %417
  %426 = icmp ult ptr %423, %421
  %427 = select i1 %425, i1 %426, i1 false
  br i1 %427, label %428, label %455

428:                                              ; preds = %422
  %429 = getelementptr inbounds nuw i8, ptr %424, i32 1
  %430 = load i8, ptr %424, align 1, !tbaa !24
  %431 = icmp eq i8 %430, 10
  br i1 %431, label %432, label %434

432:                                              ; preds = %428
  %433 = getelementptr inbounds nuw i8, ptr %423, i32 1
  store i8 36, ptr %423, align 1, !tbaa !24
  br label %455

434:                                              ; preds = %428
  %435 = icmp slt i8 %430, 0
  br i1 %435, label %436, label %440

436:                                              ; preds = %434
  %437 = call fastcc ptr @stpcpy(ptr noundef %423, ptr noundef nonnull @.str.6) #16
  %438 = getelementptr inbounds nuw i8, ptr %437, i32 1
  store i8 46, ptr %437, align 1, !tbaa !24
  %439 = call fastcc ptr @stpcpy(ptr noundef nonnull %438, ptr noundef nonnull @.str.7) #16
  br label %453

440:                                              ; preds = %434
  %441 = icmp samesign ult i8 %430, 32
  br i1 %441, label %444, label %442

442:                                              ; preds = %440
  %443 = icmp eq i8 %430, 127
  br i1 %443, label %444, label %449

444:                                              ; preds = %442, %440
  %445 = getelementptr inbounds nuw i8, ptr %423, i32 1
  store i8 94, ptr %423, align 1, !tbaa !24
  %446 = icmp eq i8 %430, 127
  %447 = add nuw i8 %430, 64
  %448 = select i1 %446, i8 63, i8 %447
  br label %449

449:                                              ; preds = %444, %442
  %450 = phi i8 [ %430, %442 ], [ %448, %444 ]
  %451 = phi ptr [ %423, %442 ], [ %445, %444 ]
  %452 = getelementptr inbounds nuw i8, ptr %451, i32 1
  store i8 %450, ptr %451, align 1, !tbaa !24
  br label %453

453:                                              ; preds = %449, %436
  %454 = phi ptr [ %439, %436 ], [ %452, %449 ]
  br label %422, !llvm.loop !119

455:                                              ; preds = %422, %432
  %456 = phi ptr [ %433, %432 ], [ %423, %422 ]
  store i8 0, ptr %456, align 1, !tbaa !24
  br label %796

457:                                              ; preds = %406
  %458 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.22, i32 noundef %303) #16
  %459 = icmp eq i32 %458, 0
  br i1 %459, label %466, label %460

460:                                              ; preds = %457
  %461 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.23, i32 noundef %303) #16
  %462 = icmp eq i32 %461, 0
  br i1 %462, label %466, label %463

463:                                              ; preds = %460
  %464 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.24, i32 noundef %303) #16
  %465 = icmp eq i32 %464, 0
  br i1 %465, label %466, label %505

466:                                              ; preds = %463, %460, %457
  br i1 %268, label %475, label %467

467:                                              ; preds = %466
  %468 = icmp eq i8 %312, 113
  %469 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %468, label %470, label %473

470:                                              ; preds = %467
  %471 = getelementptr inbounds nuw i8, ptr %469, i32 32
  %472 = load i32, ptr %471, align 4, !tbaa !17
  store i32 %472, ptr @optind, align 4, !tbaa !16
  br label %473

473:                                              ; preds = %470, %467
  %474 = getelementptr inbounds nuw i8, ptr %469, i32 16
  store i32 0, ptr %474, align 4, !tbaa !19
  br label %796

475:                                              ; preds = %466
  %476 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %477 = getelementptr inbounds nuw i8, ptr %476, i32 24
  %478 = load i32, ptr %477, align 4, !tbaa !50
  %479 = icmp eq i32 %478, 0
  br i1 %479, label %481, label %480

480:                                              ; preds = %475
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.13, ptr noundef nonnull %2) #16
  br label %796

481:                                              ; preds = %475
  %482 = getelementptr inbounds nuw i8, ptr %476, i32 32
  %483 = load i32, ptr %482, align 4, !tbaa !17
  %484 = load i32, ptr @optind, align 4, !tbaa !16
  %485 = xor i32 %484, -1
  %486 = add i32 %483, %485
  %487 = icmp eq i8 %312, 113
  %488 = icmp sgt i32 %486, 0
  %489 = select i1 %487, i1 %488, i1 false
  br i1 %489, label %490, label %491

490:                                              ; preds = %481
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.25, i32 noundef %486) #16
  br label %796

491:                                              ; preds = %481
  %492 = icmp eq i8 %312, 110
  %493 = icmp slt i32 %486, 1
  %494 = select i1 %492, i1 %493, i1 false
  br i1 %494, label %495, label %496

495:                                              ; preds = %491
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.26) #16
  br label %796

496:                                              ; preds = %491
  %497 = icmp eq i8 %312, 112
  br i1 %497, label %498, label %503

498:                                              ; preds = %496
  %499 = icmp slt i32 %484, 1
  br i1 %499, label %500, label %501

500:                                              ; preds = %498
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.27) #16
  br label %796

501:                                              ; preds = %498
  %502 = add nsw i32 %484, -2
  store i32 %502, ptr @optind, align 4, !tbaa !16
  br label %503

503:                                              ; preds = %501, %496
  %504 = getelementptr inbounds nuw i8, ptr %476, i32 16
  store i32 0, ptr %504, align 4, !tbaa !19
  br label %796

505:                                              ; preds = %463
  %506 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.28, i32 noundef %303) #16
  %507 = icmp eq i32 %506, 0
  br i1 %507, label %508, label %566

508:                                              ; preds = %505
  %509 = load i8, ptr %270, align 1, !tbaa !24
  %510 = icmp eq i8 %509, 0
  br i1 %510, label %511, label %517

511:                                              ; preds = %508
  %512 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %513 = getelementptr inbounds nuw i8, ptr %512, i32 72
  %514 = load ptr, ptr %513, align 4, !tbaa !78
  %515 = icmp eq ptr %514, null
  br i1 %515, label %516, label %517

516:                                              ; preds = %511
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.14) #16
  br label %796

517:                                              ; preds = %508, %511
  %518 = phi ptr [ %514, %511 ], [ %270, %508 ]
  %519 = icmp eq i32 %20, 0
  br i1 %519, label %520, label %523

520:                                              ; preds = %517
  %521 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %522 = load ptr, ptr %521, align 4, !tbaa !29
  br label %542

523:                                              ; preds = %517
  br i1 %277, label %527, label %524

524:                                              ; preds = %523
  %525 = call fastcc ptr @find_line(i32 noundef %20) #16
  %526 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %531

527:                                              ; preds = %523
  %528 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %529 = getelementptr inbounds nuw i8, ptr %528, i32 8
  %530 = load ptr, ptr %529, align 4, !tbaa !43
  br label %531

531:                                              ; preds = %527, %524
  %532 = phi ptr [ %526, %524 ], [ %528, %527 ]
  %533 = phi ptr [ %525, %524 ], [ %530, %527 ]
  %534 = call fastcc ptr @next_line(ptr noundef %533) #16
  %535 = getelementptr inbounds nuw i8, ptr %532, i32 4
  %536 = load ptr, ptr %535, align 4, !tbaa !48
  %537 = getelementptr inbounds i8, ptr %536, i32 -1
  %538 = icmp eq ptr %534, %537
  %539 = zext i1 %538 to i32
  %540 = getelementptr inbounds nuw i8, ptr %534, i32 %539
  %541 = load ptr, ptr %532, align 4, !tbaa !29
  br label %542

542:                                              ; preds = %531, %520
  %543 = phi ptr [ %522, %520 ], [ %541, %531 ]
  %544 = phi ptr [ %521, %520 ], [ %532, %531 ]
  %545 = phi ptr [ %522, %520 ], [ %540, %531 ]
  %546 = call fastcc i32 @count_lines(ptr noundef %543, ptr noundef %545) #16
  %547 = getelementptr inbounds nuw i8, ptr %544, i32 4
  %548 = load ptr, ptr %547, align 4, !tbaa !48
  %549 = call fastcc i32 @file_insert(ptr noundef nonnull %518, ptr noundef %545, i32 noundef 0) #16
  %550 = icmp slt i32 %549, 0
  br i1 %550, label %796, label %551

551:                                              ; preds = %542
  %552 = icmp eq ptr %545, %548
  %553 = zext i1 %552 to i32
  %554 = add nsw i32 %546, %553
  %555 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %556 = load ptr, ptr %555, align 4, !tbaa !29
  %557 = ptrtoint ptr %545 to i32
  %558 = ptrtoint ptr %543 to i32
  %559 = sub i32 %557, %558
  %560 = getelementptr inbounds nuw i8, ptr %556, i32 %559
  %561 = getelementptr inbounds nuw i8, ptr %560, i32 %549
  %562 = getelementptr inbounds i8, ptr %561, i32 -1
  %563 = call fastcc i32 @count_lines(ptr noundef %560, ptr noundef nonnull %562) #16
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.29, ptr noundef nonnull %518, i32 noundef %563, i32 noundef %549) #16
  %564 = call fastcc ptr @find_line(i32 noundef %554) #16
  %565 = getelementptr inbounds nuw i8, ptr %555, i32 8
  store ptr %564, ptr %565, align 4, !tbaa !43
  br label %796

566:                                              ; preds = %505
  %567 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.30, i32 noundef %303) #16
  %568 = icmp eq i32 %567, 0
  br i1 %568, label %569, label %578

569:                                              ; preds = %566
  %570 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %571 = getelementptr inbounds nuw i8, ptr %570, i32 24
  %572 = load i32, ptr %571, align 4, !tbaa !50
  %573 = icmp ne i32 %572, 0
  %574 = and i1 %268, %573
  br i1 %574, label %575, label %576

575:                                              ; preds = %569
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.13, ptr noundef nonnull %2) #16
  br label %796

576:                                              ; preds = %569
  store i32 -1, ptr @optind, align 4, !tbaa !16
  %577 = getelementptr inbounds nuw i8, ptr %570, i32 16
  store i32 0, ptr %577, align 4, !tbaa !19
  br label %796

578:                                              ; preds = %566
  %579 = icmp eq i8 %312, 115
  br i1 %579, label %580, label %674

580:                                              ; preds = %578
  %581 = getelementptr inbounds nuw i8, ptr %234, i32 1
  %582 = call fastcc ptr @skip_whitespace(ptr noundef nonnull %581) #16
  %583 = load i8, ptr %582, align 1, !tbaa !24
  %584 = getelementptr inbounds nuw i8, ptr %582, i32 1
  %585 = call ptr @strchr(ptr noundef nonnull %584, i8 noundef signext %583) #17
  %586 = icmp eq ptr %585, null
  br i1 %586, label %803, label %587

587:                                              ; preds = %580
  %588 = ptrtoint ptr %585 to i32
  %589 = ptrtoint ptr %584 to i32
  %590 = sub i32 %588, %589
  %591 = getelementptr inbounds nuw i8, ptr %585, i32 1
  store i8 0, ptr %585, align 1, !tbaa !24
  %592 = call ptr @strchr(ptr noundef nonnull %591, i8 noundef signext %583) #17
  %593 = icmp eq ptr %592, null
  br i1 %593, label %598, label %594

594:                                              ; preds = %587
  %595 = getelementptr inbounds nuw i8, ptr %592, i32 1
  store i8 0, ptr %592, align 1, !tbaa !24
  %596 = load i8, ptr %595, align 1, !tbaa !24
  %597 = icmp eq i8 %596, 103
  br label %598

598:                                              ; preds = %594, %587
  %599 = phi i1 [ %597, %594 ], [ false, %587 ]
  %600 = icmp eq i32 %590, 0
  %601 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %602 = getelementptr inbounds nuw i8, ptr %601, i32 100
  %603 = load ptr, ptr %602, align 4, !tbaa !14
  br i1 %600, label %608, label %604

604:                                              ; preds = %598
  call fastcc void @bb_free(ptr noundef %603) #16
  %605 = call fastcc ptr @xstrdup(ptr noundef nonnull %582) #16
  %606 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %607 = getelementptr inbounds nuw i8, ptr %606, i32 100
  store ptr %605, ptr %607, align 4, !tbaa !14
  store i8 47, ptr %605, align 1, !tbaa !24
  br label %615

608:                                              ; preds = %598
  %609 = getelementptr inbounds nuw i8, ptr %603, i32 1
  %610 = load i8, ptr %609, align 1, !tbaa !24
  %611 = icmp eq i8 %610, 0
  br i1 %611, label %612, label %613

612:                                              ; preds = %608
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.31) #16
  br label %796

613:                                              ; preds = %608
  %614 = call i32 @strlen(ptr noundef nonnull %609) #17
  br label %615

615:                                              ; preds = %613, %604
  %616 = phi ptr [ %584, %604 ], [ %609, %613 ]
  %617 = phi i32 [ %590, %604 ], [ %614, %613 ]
  br i1 %277, label %618, label %626

618:                                              ; preds = %615
  %619 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %620 = getelementptr inbounds nuw i8, ptr %619, i32 8
  %621 = load ptr, ptr %620, align 4, !tbaa !43
  %622 = call fastcc ptr @begin_line(ptr noundef %621) #16
  %623 = call fastcc ptr @end_line(ptr noundef %621) #16
  %624 = load ptr, ptr %619, align 4, !tbaa !29
  %625 = call fastcc i32 @count_lines(ptr noundef %624, ptr noundef %622) #16
  br label %630

626:                                              ; preds = %615
  %627 = and i32 %21, 3
  %628 = icmp eq i32 %627, 3
  %629 = select i1 %628, i32 %19, i32 %20
  br label %630

630:                                              ; preds = %626, %618
  %631 = phi i32 [ %625, %618 ], [ %629, %626 ]
  %632 = phi i32 [ %625, %618 ], [ %20, %626 ]
  %633 = phi ptr [ %622, %618 ], [ %302, %626 ]
  %634 = call i32 @strlen(ptr noundef nonnull %591) #17
  %635 = icmp eq i32 %634, 0
  br label %636

636:                                              ; preds = %665, %630
  %637 = phi i32 [ %631, %630 ], [ %669, %665 ]
  %638 = phi i32 [ 0, %630 ], [ %666, %665 ]
  %639 = phi ptr [ %633, %630 ], [ %668, %665 ]
  %640 = icmp sgt i32 %637, %632
  br i1 %640, label %670, label %641

641:                                              ; preds = %636, %661
  %642 = phi i32 [ %660, %661 ], [ %638, %636 ]
  %643 = phi ptr [ %656, %661 ], [ %639, %636 ]
  %644 = phi ptr [ %662, %661 ], [ %639, %636 ]
  %645 = call fastcc ptr @char_search(ptr noundef %644, ptr noundef nonnull %616, i32 noundef 2) #16
  %646 = icmp eq ptr %645, null
  br i1 %646, label %665, label %647

647:                                              ; preds = %641
  %648 = getelementptr inbounds nuw i8, ptr %645, i32 %617
  %649 = getelementptr inbounds i8, ptr %648, i32 -1
  %650 = call fastcc ptr @text_hole_delete(ptr noundef nonnull %645, ptr noundef nonnull %649) #16
  br i1 %635, label %655, label %651

651:                                              ; preds = %647
  %652 = call fastcc i32 @string_insert(ptr noundef nonnull %645, ptr noundef nonnull %591) #16
  %653 = getelementptr inbounds nuw i8, ptr %645, i32 %652
  %654 = getelementptr inbounds nuw i8, ptr %643, i32 %652
  br label %655

655:                                              ; preds = %651, %647
  %656 = phi ptr [ %654, %651 ], [ %643, %647 ]
  %657 = phi ptr [ %653, %651 ], [ %645, %647 ]
  %658 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %659 = getelementptr inbounds nuw i8, ptr %658, i32 8
  store ptr %656, ptr %659, align 4, !tbaa !43
  %660 = add nsw i32 %642, 1
  br i1 %599, label %661, label %665

661:                                              ; preds = %655
  %662 = getelementptr inbounds nuw i8, ptr %657, i32 %634
  %663 = call fastcc ptr @end_line(ptr noundef %656) #16
  %664 = icmp ult ptr %662, %663
  br i1 %664, label %641, label %665

665:                                              ; preds = %661, %655, %641
  %666 = phi i32 [ %642, %641 ], [ %660, %655 ], [ %660, %661 ]
  %667 = phi ptr [ %643, %641 ], [ %656, %655 ], [ %656, %661 ]
  %668 = call fastcc ptr @next_line(ptr noundef %667) #16
  %669 = add nsw i32 %637, 1
  br label %636, !llvm.loop !120

670:                                              ; preds = %636
  %671 = icmp eq i32 %638, 0
  br i1 %671, label %672, label %673

672:                                              ; preds = %670
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.32) #16
  br label %796

673:                                              ; preds = %670
  call fastcc void @dot_skip_over_ws() #16
  br label %796

674:                                              ; preds = %578
  %675 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.33, i32 noundef %303) #16
  %676 = icmp eq i32 %675, 0
  br i1 %676, label %677, label %678

677:                                              ; preds = %674
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.34) #16
  br label %796

678:                                              ; preds = %674
  %679 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.35, i32 noundef %303) #16
  %680 = icmp eq i32 %679, 0
  br i1 %680, label %693, label %681

681:                                              ; preds = %678
  %682 = call i32 @strcmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.36) #17
  %683 = icmp eq i32 %682, 0
  br i1 %683, label %693, label %684

684:                                              ; preds = %681
  %685 = call i32 @strcmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.37) #17
  %686 = icmp eq i32 %685, 0
  br i1 %686, label %693, label %687

687:                                              ; preds = %684
  %688 = load i8, ptr %2, align 1, !tbaa !24
  %689 = icmp eq i8 %688, 120
  %690 = load i8, ptr %314, align 1
  %691 = icmp eq i8 %690, 0
  %692 = select i1 %689, i1 %691, i1 false
  br i1 %692, label %693, label %770

693:                                              ; preds = %687, %684, %681, %678
  %694 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %695 = getelementptr inbounds nuw i8, ptr %694, i32 72
  %696 = load ptr, ptr %695, align 4, !tbaa !78
  %697 = load i8, ptr %270, align 1, !tbaa !24
  %698 = icmp eq i8 %697, 0
  br i1 %698, label %711, label %699

699:                                              ; preds = %693
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #19
  br i1 %268, label %700, label %708

700:                                              ; preds = %699
  %701 = icmp eq ptr %696, null
  br i1 %701, label %705, label %702

702:                                              ; preds = %700
  %703 = call i32 @strcmp(ptr noundef nonnull %696, ptr noundef nonnull %270) #17
  %704 = icmp eq i32 %703, 0
  br i1 %704, label %708, label %705

705:                                              ; preds = %702, %700
  %706 = call i32 @stat(ptr noundef nonnull %270, ptr noundef nonnull %3) #17
  %707 = icmp eq i32 %706, 0
  br i1 %707, label %710, label %708

708:                                              ; preds = %705, %702, %699
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #19
  %709 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %711

710:                                              ; preds = %705
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.38) #16
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #19
  br label %796

711:                                              ; preds = %708, %693
  %712 = phi ptr [ %694, %693 ], [ %709, %708 ]
  %713 = phi ptr [ %696, %693 ], [ %270, %708 ]
  %714 = getelementptr inbounds nuw i8, ptr %712, i32 24
  %715 = load i32, ptr %714, align 4, !tbaa !50
  %716 = icmp eq i32 %715, 0
  %717 = load i8, ptr %2, align 1
  %718 = icmp eq i8 %717, 120
  %719 = select i1 %716, i1 %718, i1 false
  br i1 %719, label %730, label %720

720:                                              ; preds = %711
  %721 = ptrtoint ptr %301 to i32
  %722 = ptrtoint ptr %302 to i32
  %723 = add i32 %721, 1
  %724 = sub i32 %723, %722
  %725 = call fastcc i32 @file_write(ptr noundef %713, ptr noundef %302, ptr noundef %301) #16
  %726 = icmp slt i32 %725, 0
  br i1 %726, label %727, label %730

727:                                              ; preds = %720
  %728 = icmp eq i32 %725, -1
  br i1 %728, label %729, label %796

729:                                              ; preds = %727
  call fastcc void @status_line_bold_errno(ptr noundef %713) #16
  br label %796

730:                                              ; preds = %711, %720
  %731 = phi i32 [ %725, %720 ], [ 0, %711 ]
  %732 = phi i32 [ %724, %720 ], [ 0, %711 ]
  %733 = getelementptr inbounds nuw i8, ptr %302, i32 %731
  %734 = getelementptr inbounds i8, ptr %733, i32 -1
  %735 = call fastcc i32 @count_lines(ptr noundef %302, ptr noundef nonnull %734) #16
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.29, ptr noundef %713, i32 noundef %735, i32 noundef %731) #16
  %736 = icmp eq i32 %731, %732
  br i1 %736, label %737, label %796

737:                                              ; preds = %730
  %738 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %739 = load ptr, ptr %738, align 4, !tbaa !29
  %740 = icmp eq ptr %302, %739
  br i1 %740, label %741, label %748

741:                                              ; preds = %737
  %742 = getelementptr inbounds nuw i8, ptr %738, i32 4
  %743 = load ptr, ptr %742, align 4, !tbaa !48
  %744 = icmp eq ptr %733, %743
  br i1 %744, label %745, label %748

745:                                              ; preds = %741
  %746 = getelementptr inbounds nuw i8, ptr %738, i32 24
  store i32 0, ptr %746, align 4, !tbaa !50
  %747 = getelementptr inbounds nuw i8, ptr %738, i32 28
  store i32 -1, ptr %747, align 4, !tbaa !8
  br label %748

748:                                              ; preds = %745, %741, %737
  %749 = load i8, ptr %314, align 1, !tbaa !24
  %750 = icmp eq i8 %749, 110
  br i1 %750, label %751, label %753

751:                                              ; preds = %748
  %752 = getelementptr inbounds nuw i8, ptr %738, i32 16
  store i32 0, ptr %752, align 4, !tbaa !19
  br label %796

753:                                              ; preds = %748
  %754 = load i8, ptr %2, align 1, !tbaa !24
  %755 = icmp eq i8 %754, 120
  br i1 %755, label %758, label %756

756:                                              ; preds = %753
  %757 = icmp eq i8 %749, 113
  br i1 %757, label %758, label %796

758:                                              ; preds = %756, %753
  %759 = getelementptr inbounds nuw i8, ptr %738, i32 32
  %760 = load i32, ptr %759, align 4, !tbaa !17
  %761 = load i32, ptr @optind, align 4, !tbaa !16
  %762 = xor i32 %761, -1
  %763 = add i32 %760, %762
  %764 = icmp sgt i32 %763, 0
  br i1 %764, label %765, label %767

765:                                              ; preds = %758
  br i1 %268, label %769, label %766

766:                                              ; preds = %765
  store i32 %760, ptr @optind, align 4, !tbaa !16
  br label %767

767:                                              ; preds = %758, %766
  %768 = getelementptr inbounds nuw i8, ptr %738, i32 16
  store i32 0, ptr %768, align 4, !tbaa !19
  br label %796

769:                                              ; preds = %765
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.25, i32 noundef %763) #16
  br label %796

770:                                              ; preds = %687
  %771 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.39, i32 noundef %303) #16
  %772 = icmp eq i32 %771, 0
  br i1 %772, label %773, label %795

773:                                              ; preds = %770
  %774 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %277, label %775, label %780

775:                                              ; preds = %773
  %776 = getelementptr inbounds nuw i8, ptr %774, i32 8
  %777 = load ptr, ptr %776, align 4, !tbaa !43
  %778 = call fastcc ptr @begin_line(ptr noundef %777) #16
  %779 = call fastcc ptr @end_line(ptr noundef %777) #16
  br label %780

780:                                              ; preds = %775, %773
  %781 = phi ptr [ %301, %773 ], [ %779, %775 ]
  %782 = phi ptr [ %302, %773 ], [ %778, %775 ]
  %783 = getelementptr inbounds nuw i8, ptr %774, i32 120
  %784 = load i32, ptr %783, align 4, !tbaa !28
  call fastcc void @text_yank(ptr noundef %782, ptr noundef %781, i32 noundef %784, i32 noundef 1) #16
  %785 = call fastcc i32 @count_lines(ptr noundef %782, ptr noundef %781) #16
  %786 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %787 = getelementptr inbounds nuw i8, ptr %786, i32 124
  %788 = getelementptr inbounds nuw i8, ptr %786, i32 120
  %789 = load i32, ptr %788, align 4, !tbaa !28
  %790 = getelementptr inbounds nuw [28 x ptr], ptr %787, i32 0, i32 %789
  %791 = load ptr, ptr %790, align 4, !tbaa !18
  %792 = call i32 @strlen(ptr noundef %791) #17
  %793 = call fastcc signext i8 @what_reg() #16
  %794 = zext nneg i8 %793 to i32
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.40, i32 noundef %785, i32 noundef %792, i32 noundef %794) #16
  br label %796

795:                                              ; preds = %770
  call fastcc void @not_implemented(ptr noundef %2) #16
  br label %796

796:                                              ; preds = %730, %756, %751, %767, %672, %673, %612, %710, %769, %727, %729, %283, %294, %228, %551, %516, %542, %503, %473, %480, %490, %495, %500, %361, %352, %360, %9, %9, %307, %305, %337, %399, %398, %455, %795, %780, %677, %575, %576, %405, %325, %394
  %797 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %798 = getelementptr inbounds nuw i8, ptr %797, i32 8
  %799 = load ptr, ptr %798, align 4, !tbaa !43
  %800 = call fastcc ptr @bound_dot(ptr noundef %799) #16
  %801 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %802 = getelementptr inbounds nuw i8, ptr %801, i32 8
  store ptr %800, ptr %802, align 4, !tbaa !43
  br label %804

803:                                              ; preds = %580
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.41) #16
  br label %804

804:                                              ; preds = %803, %796
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc noundef ptr @skip_whitespace(ptr noundef readonly captures(ret: address, provenance) %0) unnamed_addr #9 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi ptr [ %0, %1 ], [ %10, %2 ]
  %4 = load i8, ptr %3, align 1, !tbaa !24
  %5 = sext i8 %4 to i32
  %6 = icmp ne i8 %4, 32
  %7 = add nsw i32 %5, -14
  %8 = icmp ult i32 %7, -5
  %9 = select i1 %6, i1 %8, i1 false
  %10 = getelementptr inbounds nuw i8, ptr %3, i32 1
  br i1 %9, label %11, label %2, !llvm.loop !121

11:                                               ; preds = %2
  ret ptr %3
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc noundef nonnull ptr @skip_non_whitespace(ptr noundef nonnull readonly captures(ret: address, provenance) %0) unnamed_addr #9 {
  br label %2

2:                                                ; preds = %12, %1
  %3 = phi ptr [ %0, %1 ], [ %13, %12 ]
  %4 = load i8, ptr %3, align 1, !tbaa !24
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %14, label %6

6:                                                ; preds = %2
  %7 = sext i8 %4 to i32
  %8 = icmp ne i8 %4, 32
  %9 = add nsw i32 %7, -14
  %10 = icmp ult i32 %9, -5
  %11 = select i1 %8, i1 %10, i1 false
  br i1 %11, label %12, label %14

12:                                               ; preds = %6
  %13 = getelementptr inbounds nuw i8, ptr %3, i32 1
  br label %2, !llvm.loop !122

14:                                               ; preds = %2, %6
  ret ptr %3
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc i32 @count_lines(ptr noundef readonly %0, ptr noundef readonly %1) unnamed_addr #5 {
  %3 = icmp ult ptr %1, %0
  %4 = select i1 %3, ptr %0, ptr %1
  %5 = select i1 %3, ptr %1, ptr %0
  %6 = tail call fastcc ptr @end_line(ptr noundef %4) #16
  %7 = load ptr, ptr @ptr_to_globals, align 4
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 4
  br label %9

9:                                                ; preds = %17, %2
  %10 = phi ptr [ %5, %2 ], [ %23, %17 ]
  %11 = phi i32 [ 0, %2 ], [ %22, %17 ]
  %12 = icmp ugt ptr %10, %6
  br i1 %12, label %24, label %13

13:                                               ; preds = %9
  %14 = load ptr, ptr %8, align 4, !tbaa !48
  %15 = getelementptr inbounds i8, ptr %14, i32 -1
  %16 = icmp ugt ptr %10, %15
  br i1 %16, label %24, label %17

17:                                               ; preds = %13
  %18 = tail call fastcc ptr @end_line(ptr noundef %10) #16
  %19 = load i8, ptr %18, align 1, !tbaa !24
  %20 = icmp eq i8 %19, 10
  %21 = zext i1 %20 to i32
  %22 = add nuw nsw i32 %11, %21
  %23 = getelementptr inbounds nuw i8, ptr %18, i32 1
  br label %9, !llvm.loop !123

24:                                               ; preds = %9, %13
  ret i32 %11
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @find_line(i32 noundef %0) unnamed_addr #5 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = load ptr, ptr %2, align 4, !tbaa !29
  br label %4

4:                                                ; preds = %8, %1
  %5 = phi i32 [ %0, %1 ], [ %10, %8 ]
  %6 = phi ptr [ %3, %1 ], [ %9, %8 ]
  %7 = icmp sgt i32 %5, 1
  br i1 %7, label %8, label %11

8:                                                ; preds = %4
  %9 = tail call fastcc ptr @next_line(ptr noundef %6) #16
  %10 = add nsw i32 %5, -1
  br label %4, !llvm.loop !124

11:                                               ; preds = %4
  ret ptr %6
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_skip_over_ws() unnamed_addr #10 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 4
  br label %5

5:                                                ; preds = %19, %0
  %6 = phi ptr [ %20, %19 ], [ %3, %0 ]
  %7 = load i8, ptr %6, align 1, !tbaa !24
  %8 = sext i8 %7 to i32
  %9 = icmp ne i8 %7, 32
  %10 = add nsw i32 %8, -14
  %11 = icmp ult i32 %10, -5
  %12 = select i1 %9, i1 %11, i1 false
  %13 = icmp eq i8 %7, 10
  %14 = or i1 %12, %13
  br i1 %14, label %21, label %15

15:                                               ; preds = %5
  %16 = load ptr, ptr %4, align 4, !tbaa !48
  %17 = getelementptr inbounds i8, ptr %16, i32 -1
  %18 = icmp ult ptr %6, %17
  br i1 %18, label %19, label %21

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %6, i32 1
  store ptr %20, ptr %2, align 4, !tbaa !43
  br label %5, !llvm.loop !125

21:                                               ; preds = %5, %15
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize
define internal void @status_line(ptr noundef readonly captures(none) %0, ...) unnamed_addr #11 {
  %2 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #19
  call void @llvm.va_start.p0(ptr nonnull %2)
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 408
  %5 = load i32, ptr %2, align 4
  %6 = insertvalue [1 x i32] poison, i32 %5, 0
  %7 = call fastcc i32 @bb_vsnprintf(ptr noundef nonnull %4, i32 noundef 200, ptr noundef %0, [1 x i32] %6) #16
  call void @llvm.va_end.p0(ptr nonnull %2)
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 64
  store i32 1, ptr %8, align 4, !tbaa !94
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc range(i32 -255, 256) i32 @bb_strncmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) unnamed_addr #9 {
  br label %4

4:                                                ; preds = %16, %3
  %5 = phi ptr [ %0, %3 ], [ %17, %16 ]
  %6 = phi ptr [ %1, %3 ], [ %18, %16 ]
  %7 = phi i32 [ %2, %3 ], [ %8, %16 ]
  %8 = add nsw i32 %7, -1
  %9 = icmp eq i32 %7, 0
  br i1 %9, label %26, label %10

10:                                               ; preds = %4
  %11 = load i8, ptr %5, align 1, !tbaa !24
  %12 = icmp eq i8 %11, 0
  br i1 %12, label %19, label %13

13:                                               ; preds = %10
  %14 = load i8, ptr %6, align 1, !tbaa !24
  %15 = icmp eq i8 %11, %14
  br i1 %15, label %16, label %19

16:                                               ; preds = %13
  %17 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %18 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %4, !llvm.loop !126

19:                                               ; preds = %10, %13
  %20 = icmp slt i32 %7, 1
  br i1 %20, label %26, label %21

21:                                               ; preds = %19
  %22 = zext i8 %11 to i32
  %23 = load i8, ptr %6, align 1, !tbaa !24
  %24 = zext i8 %23 to i32
  %25 = sub nsw i32 %22, %24
  br label %26

26:                                               ; preds = %4, %19, %21
  %27 = phi i32 [ %25, %21 ], [ 0, %19 ], [ 0, %4 ]
  ret i32 %27
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @yank_delete(ptr noundef %0, ptr noundef %1, i32 noundef range(i32 0, -1) %2, i32 noundef range(i32 0, 2) %3) unnamed_addr #0 {
  %5 = icmp ugt ptr %0, %1
  %6 = select i1 %5, ptr %0, ptr %1
  %7 = select i1 %5, ptr %1, ptr %0
  %8 = icmp eq i32 %2, 0
  br i1 %8, label %9, label %12

9:                                                ; preds = %4
  %10 = load i8, ptr %7, align 1, !tbaa !24
  %11 = icmp eq i8 %10, 10
  br i1 %11, label %19, label %12

12:                                               ; preds = %9, %4
  %13 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 120
  %15 = load i32, ptr %14, align 4, !tbaa !28
  tail call fastcc void @text_yank(ptr noundef %7, ptr noundef %6, i32 noundef %15, i32 noundef %2) #16
  %16 = icmp eq i32 %3, 0
  br i1 %16, label %19, label %17

17:                                               ; preds = %12
  %18 = tail call fastcc ptr @text_hole_delete(ptr noundef %7, ptr noundef %6) #16
  br label %19

19:                                               ; preds = %12, %17, %9
  %20 = phi ptr [ %7, %9 ], [ %18, %17 ], [ %7, %12 ]
  ret ptr %20
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @Hit_Return() unnamed_addr #0 {
  tail call fastcc void @write1(ptr noundef nonnull @.str.6) #16
  tail call fastcc void @write1(ptr noundef nonnull @.str.46) #16
  tail call fastcc void @write1(ptr noundef nonnull @.str.7) #16
  br label %1

1:                                                ; preds = %1, %0
  %2 = tail call fastcc i32 @readit() #16
  switch i32 %2, label %1 [
    i32 13, label %3
    i32 10, label %3
  ]

3:                                                ; preds = %1, %1
  tail call fastcc void @redraw(i32 noundef 1) #16
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite)
define internal fastcc noundef ptr @stpcpy(ptr noundef writeonly captures(ret: address, provenance) %0, ptr noundef readonly captures(none) %1) unnamed_addr #12 {
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi ptr [ %0, %2 ], [ %9, %8 ]
  %5 = phi ptr [ %1, %2 ], [ %10, %8 ]
  %6 = load i8, ptr %5, align 1, !tbaa !24
  store i8 %6, ptr %4, align 1, !tbaa !24
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %11, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !127

11:                                               ; preds = %3
  ret ptr %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @next_line(ptr noundef readonly %0) unnamed_addr #5 {
  %2 = tail call fastcc ptr @end_line(ptr noundef %0) #16
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %5 = load ptr, ptr %4, align 4, !tbaa !48
  %6 = getelementptr inbounds i8, ptr %5, i32 -1
  %7 = icmp ult ptr %2, %6
  br i1 %7, label %8, label %13

8:                                                ; preds = %1
  %9 = load i8, ptr %2, align 1, !tbaa !24
  %10 = icmp eq i8 %9, 10
  %11 = zext i1 %10 to i32
  %12 = getelementptr inbounds nuw i8, ptr %2, i32 %11
  br label %13

13:                                               ; preds = %8, %1
  %14 = phi ptr [ %2, %1 ], [ %12, %8 ]
  ret ptr %14
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @char_search(ptr noundef readonly %0, ptr noundef %1, i32 noundef %2) unnamed_addr #0 {
  %4 = tail call i32 @strlen(ptr noundef %1) #17
  %5 = and i32 %2, 1
  %6 = icmp sgt i32 %2, 0
  %7 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %6, label %8, label %25

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %7, i32 4
  %10 = load ptr, ptr %9, align 4, !tbaa !48
  %11 = getelementptr inbounds i8, ptr %10, i32 -1
  %12 = icmp eq i32 %5, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %8
  %14 = tail call fastcc ptr @next_line(ptr noundef %0) #16
  br label %15

15:                                               ; preds = %13, %8
  %16 = phi ptr [ %14, %13 ], [ %11, %8 ]
  br label %17

17:                                               ; preds = %23, %15
  %18 = phi ptr [ %0, %15 ], [ %24, %23 ]
  %19 = icmp ult ptr %18, %16
  br i1 %19, label %20, label %42

20:                                               ; preds = %17
  %21 = tail call fastcc i32 @bb_strncmp(ptr noundef %18, ptr noundef %1, i32 noundef %4) #16
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %42, label %23

23:                                               ; preds = %20
  %24 = getelementptr inbounds nuw i8, ptr %18, i32 1
  br label %17, !llvm.loop !128

25:                                               ; preds = %3
  %26 = load ptr, ptr %7, align 4, !tbaa !29
  %27 = icmp eq i32 %5, 0
  br i1 %27, label %28, label %30

28:                                               ; preds = %25
  %29 = tail call fastcc ptr @prev_line(ptr noundef %0) #16
  br label %30

30:                                               ; preds = %28, %25
  %31 = phi ptr [ %29, %28 ], [ %26, %25 ]
  %32 = sub i32 0, %4
  %33 = getelementptr inbounds i8, ptr %0, i32 %32
  br label %34

34:                                               ; preds = %40, %30
  %35 = phi ptr [ %33, %30 ], [ %41, %40 ]
  %36 = icmp ult ptr %35, %31
  br i1 %36, label %42, label %37

37:                                               ; preds = %34
  %38 = tail call fastcc i32 @bb_strncmp(ptr noundef %35, ptr noundef %1, i32 noundef %4) #16
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %42, label %40

40:                                               ; preds = %37
  %41 = getelementptr inbounds i8, ptr %35, i32 -1
  br label %34, !llvm.loop !129

42:                                               ; preds = %34, %37, %17, %20
  %43 = phi ptr [ null, %17 ], [ %18, %20 ], [ null, %34 ], [ %35, %37 ]
  ret ptr %43
}

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @string_insert(ptr noundef %0, ptr noundef %1) unnamed_addr #0 {
  %3 = tail call i32 @strlen(ptr noundef %1) #17
  %4 = tail call fastcc i32 @text_hole_make(ptr noundef %0, i32 noundef %3) #16
  %5 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %6 = tail call ptr @memmove(ptr noundef %5, ptr noundef %1, i32 noundef %3) #17
  ret i32 %4
}

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @stat(ptr noundef, ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @file_write(ptr noundef %0, ptr noundef %1, ptr noundef %2) unnamed_addr #0 {
  %4 = icmp eq ptr %0, null
  br i1 %4, label %5, label %6

5:                                                ; preds = %3
  tail call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.14) #16
  br label %18

6:                                                ; preds = %3
  %7 = tail call i32 @open(ptr noundef nonnull %0, i32 noundef 1537) #17
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %18, label %9

9:                                                ; preds = %6
  %10 = ptrtoint ptr %2 to i32
  %11 = ptrtoint ptr %1 to i32
  %12 = sub i32 %10, %11
  %13 = add nsw i32 %12, 1
  %14 = tail call i32 @write(i32 noundef range(i32 0, -2147483648) %7, ptr noundef %1, i32 noundef range(i32 -2147483647, -2147483648) %13) #17
  %15 = icmp eq i32 %14, %13
  %16 = select i1 %15, i32 %14, i32 0
  %17 = tail call i32 @close(i32 noundef %7) #17
  br label %18

18:                                               ; preds = %6, %9, %5
  %19 = phi i32 [ -2, %5 ], [ %16, %9 ], [ -1, %6 ]
  ret i32 %19
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc signext range(i8 68, 123) i8 @what_reg() unnamed_addr #8 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 120
  %3 = load i32, ptr %2, align 4, !tbaa !28
  %4 = icmp ult i32 %3, 26
  %5 = trunc i32 %3 to i8
  %6 = add i8 %5, 97
  %7 = select i1 %4, i8 %6, i8 68
  %8 = icmp eq i32 %3, 27
  %9 = select i1 %8, i8 85, i8 %7
  ret i8 %9
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @not_implemented(ptr noundef nonnull readonly captures(none) %0) unnamed_addr #0 {
  %2 = alloca [128 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 128, ptr nonnull %2) #19
  %3 = load i8, ptr %0, align 1, !tbaa !24
  %4 = icmp eq i8 %3, 0
  %5 = select i1 %4, ptr @.str.48, ptr %0
  %6 = ptrtoint ptr %2 to i32
  br label %7

7:                                                ; preds = %23, %1
  %8 = phi ptr [ %5, %1 ], [ %30, %23 ]
  %9 = phi ptr [ %2, %1 ], [ %26, %23 ]
  %10 = load i8, ptr %8, align 1, !tbaa !24
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %31, label %12

12:                                               ; preds = %7
  %13 = icmp sgt i8 %10, -1
  %14 = select i1 %13, i8 %10, i8 63
  %15 = icmp samesign ult i8 %14, 32
  br i1 %15, label %18, label %16

16:                                               ; preds = %12
  %17 = icmp eq i8 %14, 127
  br i1 %17, label %18, label %23

18:                                               ; preds = %16, %12
  %19 = getelementptr inbounds nuw i8, ptr %9, i32 1
  store i8 94, ptr %9, align 1, !tbaa !24
  %20 = or i8 %14, 64
  %21 = icmp eq i8 %20, 127
  %22 = select i1 %21, i8 63, i8 %20
  br label %23

23:                                               ; preds = %18, %16
  %24 = phi ptr [ %19, %18 ], [ %9, %16 ]
  %25 = phi i8 [ %22, %18 ], [ %14, %16 ]
  %26 = getelementptr inbounds nuw i8, ptr %24, i32 1
  store i8 %25, ptr %24, align 1, !tbaa !24
  store i8 0, ptr %26, align 1, !tbaa !24
  %27 = ptrtoint ptr %26 to i32
  %28 = sub i32 %27, %6
  %29 = icmp sgt i32 %28, 118
  %30 = getelementptr inbounds nuw i8, ptr %8, i32 1
  br i1 %29, label %31, label %7, !llvm.loop !130

31:                                               ; preds = %7, %23
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.47, ptr noundef nonnull %2) #16
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @bound_dot(ptr noundef readnone captures(address, ret: address, provenance) %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %4 = load ptr, ptr %3, align 4, !tbaa !48
  %5 = icmp ult ptr %0, %4
  br i1 %5, label %12, label %6

6:                                                ; preds = %1
  %7 = load ptr, ptr %2, align 4, !tbaa !29
  %8 = icmp ugt ptr %4, %7
  br i1 %8, label %9, label %12

9:                                                ; preds = %6
  %10 = getelementptr inbounds i8, ptr %4, i32 -1
  tail call fastcc void @indicate_error() #16
  %11 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %12

12:                                               ; preds = %9, %6, %1
  %13 = phi ptr [ %11, %9 ], [ %2, %6 ], [ %2, %1 ]
  %14 = phi ptr [ %10, %9 ], [ %0, %6 ], [ %0, %1 ]
  %15 = load ptr, ptr %13, align 4, !tbaa !29
  %16 = icmp ult ptr %14, %15
  br i1 %16, label %17, label %18

17:                                               ; preds = %12
  tail call fastcc void @indicate_error() #16
  br label %18

18:                                               ; preds = %17, %12
  %19 = phi ptr [ %15, %17 ], [ %14, %12 ]
  ret ptr %19
}

; Function Attrs: minsize nounwind optsize
define internal fastcc noundef nonnull ptr @xstrndup(ptr noundef %0, i32 noundef %1) unnamed_addr #0 {
  br label %3

3:                                                ; preds = %10, %2
  %4 = phi i32 [ 0, %2 ], [ %11, %10 ]
  %5 = icmp slt i32 %4, %1
  br i1 %5, label %6, label %12

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %8 = load i8, ptr %7, align 1, !tbaa !24
  %9 = icmp eq i8 %8, 0
  br i1 %9, label %12, label %10

10:                                               ; preds = %6
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !131

12:                                               ; preds = %3, %6
  %13 = add nuw nsw i32 %4, 1
  %14 = tail call fastcc ptr @xmalloc(i32 noundef %13) #16
  %15 = tail call ptr @memmove(ptr noundef nonnull %14, ptr noundef %0, i32 noundef %4) #17
  %16 = getelementptr inbounds nuw i8, ptr %14, i32 %4
  store i8 0, ptr %16, align 1, !tbaa !24
  ret ptr %14
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @prev_line(ptr noundef readonly %0) unnamed_addr #5 {
  %2 = tail call fastcc ptr @begin_line(ptr noundef %0) #16
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = load ptr, ptr %3, align 4, !tbaa !29
  %5 = icmp ugt ptr %2, %4
  br i1 %5, label %6, label %11

6:                                                ; preds = %1
  %7 = getelementptr inbounds i8, ptr %2, i32 -1
  %8 = load i8, ptr %7, align 1, !tbaa !24
  %9 = icmp eq i8 %8, 10
  %10 = select i1 %9, ptr %7, ptr %2
  br label %11

11:                                               ; preds = %6, %1
  %12 = phi ptr [ %2, %1 ], [ %10, %6 ]
  %13 = tail call fastcc ptr @begin_line(ptr noundef %12) #16
  ret ptr %13
}

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @indicate_error() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 104
  store i32 1, ptr %2, align 4, !tbaa !54
  tail call fastcc void @write1(ptr noundef nonnull @.str.49) #16
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, 256) i32 @bb_readc() unnamed_addr #0 {
  %1 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %1) #19
  %2 = call i32 @read(i32 noundef 0, ptr noundef nonnull %1, i32 noundef 1) #17
  %3 = icmp slt i32 %2, 1
  %4 = load i8, ptr %1, align 1
  %5 = zext i8 %4 to i32
  %6 = select i1 %3, i32 -1, i32 %5
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %1) #19
  ret i32 %6
}

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @read_nb(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc ptr @bb_memchr(ptr noundef readonly captures(ret: address, provenance) %0, i32 noundef %1) unnamed_addr #9 {
  br label %3

3:                                                ; preds = %6, %2
  %4 = phi i32 [ 0, %2 ], [ %10, %6 ]
  %5 = icmp eq i32 %4, %1
  br i1 %5, label %13, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %8 = load i8, ptr %7, align 1, !tbaa !24
  %9 = icmp eq i8 %8, 10
  %10 = add i32 %4, 1
  br i1 %9, label %11, label %3, !llvm.loop !132

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  br label %13

13:                                               ; preds = %3, %11
  %14 = phi ptr [ %12, %11 ], [ null, %3 ]
  ret ptr %14
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_scroll(i32 noundef %0, i32 noundef range(i32 -1, 2) %1) unnamed_addr #10 {
  %3 = icmp slt i32 %1, 0
  %4 = load ptr, ptr @ptr_to_globals, align 4
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 76
  br label %6

6:                                                ; preds = %15, %2
  %7 = phi i32 [ %0, %2 ], [ %17, %15 ]
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %18

9:                                                ; preds = %6
  %10 = load ptr, ptr %5, align 4, !tbaa !49
  br i1 %3, label %11, label %13

11:                                               ; preds = %9
  %12 = tail call fastcc ptr @prev_line(ptr noundef %10) #16
  br label %15

13:                                               ; preds = %9
  %14 = tail call fastcc ptr @next_line(ptr noundef %10) #16
  br label %15

15:                                               ; preds = %11, %13
  %16 = phi ptr [ %14, %13 ], [ %12, %11 ]
  store ptr %16, ptr %5, align 4, !tbaa !49
  %17 = add nsw i32 %7, -1
  br label %6, !llvm.loop !133

18:                                               ; preds = %6
  %19 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %20 = load ptr, ptr %19, align 4, !tbaa !43
  %21 = load ptr, ptr %5, align 4, !tbaa !49
  %22 = icmp ult ptr %20, %21
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  store ptr %21, ptr %19, align 4, !tbaa !43
  br label %24

24:                                               ; preds = %23, %18
  %25 = phi ptr [ %21, %23 ], [ %20, %18 ]
  %26 = tail call fastcc ptr @end_screen() #16
  %27 = icmp ugt ptr %25, %26
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = tail call fastcc ptr @begin_line(ptr noundef %26) #16
  store ptr %29, ptr %19, align 4, !tbaa !43
  br label %30

30:                                               ; preds = %28, %24
  tail call fastcc void @dot_skip_over_ws() #16
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_left() unnamed_addr #13 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = load ptr, ptr %1, align 4, !tbaa !29
  %5 = icmp ugt ptr %3, %4
  br i1 %5, label %6, label %11

6:                                                ; preds = %0
  %7 = getelementptr inbounds i8, ptr %3, i32 -1
  %8 = load i8, ptr %7, align 1, !tbaa !24
  %9 = icmp eq i8 %8, 10
  br i1 %9, label %11, label %10

10:                                               ; preds = %6
  store ptr %7, ptr %2, align 4, !tbaa !43
  br label %11

11:                                               ; preds = %10, %6, %0
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @move_to_col(ptr noundef readonly %0, i32 noundef %1) unnamed_addr #5 {
  %3 = tail call fastcc ptr @begin_line(ptr noundef %0) #16
  %4 = load ptr, ptr @ptr_to_globals, align 4
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 4
  br label %6

6:                                                ; preds = %14, %2
  %7 = phi ptr [ %3, %2 ], [ %15, %14 ]
  %8 = phi i32 [ 0, %2 ], [ %12, %14 ]
  %9 = load i8, ptr %7, align 1, !tbaa !24
  %10 = icmp eq i8 %9, 10
  br i1 %10, label %18, label %11

11:                                               ; preds = %6
  %12 = tail call fastcc i32 @next_column(i8 noundef signext %9, i32 noundef %8) #16
  %13 = icmp sgt i32 %12, %1
  br i1 %13, label %18, label %14

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %7, i32 1
  %16 = load ptr, ptr %5, align 4, !tbaa !48
  %17 = icmp ult ptr %7, %16
  br i1 %17, label %6, label %18, !llvm.loop !134

18:                                               ; preds = %11, %6, %14
  %19 = phi ptr [ %7, %6 ], [ %15, %14 ], [ %7, %11 ]
  ret ptr %19
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_right() unnamed_addr #13 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %5 = load ptr, ptr %4, align 4, !tbaa !48
  %6 = getelementptr inbounds i8, ptr %5, i32 -1
  %7 = icmp ult ptr %3, %6
  br i1 %7, label %8, label %13

8:                                                ; preds = %0
  %9 = load i8, ptr %3, align 1, !tbaa !24
  %10 = icmp eq i8 %9, 10
  br i1 %10, label %13, label %11

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i8, ptr %3, i32 1
  store ptr %12, ptr %2, align 4, !tbaa !43
  br label %13

13:                                               ; preds = %11, %8, %0
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_begin() unnamed_addr #10 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = tail call fastcc ptr @begin_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !43
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_next() unnamed_addr #10 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = tail call fastcc ptr @next_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !43
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc nonnull ptr @get_input_line(ptr noundef %0) unnamed_addr #0 {
  %2 = alloca i8, align 1
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 608
  %5 = tail call ptr @strcpy(ptr noundef nonnull %4, ptr noundef %0) #17
  %6 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 68
  store i32 0, ptr %7, align 4, !tbaa !51
  tail call fastcc void @go_bottom_and_clear_to_eol() #16
  %8 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 608
  tail call fastcc void @write1(ptr noundef nonnull %9) #16
  %10 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 608
  %12 = tail call i32 @strlen(ptr noundef nonnull %11) #17
  br label %13

13:                                               ; preds = %34, %1
  %14 = phi i32 [ %12, %1 ], [ %35, %34 ]
  %15 = icmp slt i32 %14, 127
  br label %16

16:                                               ; preds = %13, %36
  br i1 %15, label %17, label %46

17:                                               ; preds = %16
  %18 = call fastcc i32 @readit() #16
  switch i32 %18, label %19 [
    i32 10, label %46
    i32 13, label %46
    i32 27, label %46
  ]

19:                                               ; preds = %17
  %20 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 378
  %22 = load i8, ptr %21, align 2, !tbaa !24
  %23 = zext i8 %22 to i32
  %24 = icmp eq i32 %18, %23
  br i1 %24, label %26, label %25

25:                                               ; preds = %19
  switch i32 %18, label %36 [
    i32 8, label %26
    i32 127, label %26
  ]

26:                                               ; preds = %25, %25, %19
  %27 = getelementptr inbounds nuw i8, ptr %20, i32 608
  %28 = add nsw i32 %14, -1
  %29 = getelementptr inbounds [128 x i8], ptr %27, i32 0, i32 %28
  store i8 0, ptr %29, align 1, !tbaa !24
  call fastcc void @go_bottom_and_clear_to_eol() #16
  %30 = icmp slt i32 %14, 2
  br i1 %30, label %46, label %31

31:                                               ; preds = %26
  %32 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %33 = getelementptr inbounds nuw i8, ptr %32, i32 608
  call fastcc void @write1(ptr noundef nonnull %33) #16
  br label %34

34:                                               ; preds = %31, %39
  %35 = phi i32 [ %43, %39 ], [ %28, %31 ]
  br label %13, !llvm.loop !135

36:                                               ; preds = %25
  %37 = add nsw i32 %18, -1
  %38 = icmp ult i32 %37, 255
  br i1 %38, label %39, label %16, !llvm.loop !135

39:                                               ; preds = %36
  %40 = trunc nuw i32 %18 to i8
  %41 = getelementptr inbounds nuw i8, ptr %20, i32 608
  %42 = getelementptr inbounds [128 x i8], ptr %41, i32 0, i32 %14
  store i8 %40, ptr %42, align 1, !tbaa !24
  %43 = add nsw i32 %14, 1
  %44 = getelementptr inbounds [128 x i8], ptr %41, i32 0, i32 %43
  store i8 0, ptr %44, align 1, !tbaa !24
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %2) #19
  store i8 %40, ptr %2, align 1, !tbaa !24
  %45 = call i32 @write(i32 noundef 1, ptr noundef nonnull %2, i32 noundef 1) #17
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %2) #19
  br label %34

46:                                               ; preds = %26, %17, %17, %17, %16
  call fastcc void @refresh(i32 noundef 0) #16
  %47 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %48 = getelementptr inbounds nuw i8, ptr %47, i32 608
  ret ptr %48
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, 3) i32 @find_range(ptr noundef nonnull writeonly captures(none) %0, ptr noundef nonnull writeonly captures(none) %1, i32 noundef %2) unnamed_addr #0 {
  %4 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %6 = load ptr, ptr %5, align 4, !tbaa !43
  %7 = icmp eq i32 %2, 89
  br i1 %7, label %37, label %8

8:                                                ; preds = %3
  %9 = tail call fastcc i32 @readit() #16
  %10 = add nsw i32 %9, -58
  %11 = icmp ult i32 %10, -10
  br i1 %11, label %32, label %12

12:                                               ; preds = %8
  %13 = icmp eq i32 %9, 48
  br i1 %13, label %23, label %14

14:                                               ; preds = %12, %19
  %15 = phi i32 [ %22, %19 ], [ %9, %12 ]
  %16 = phi i32 [ %21, %19 ], [ 0, %12 ]
  %17 = add nsw i32 %15, -48
  %18 = icmp ugt i32 %17, 9
  br i1 %18, label %26, label %19

19:                                               ; preds = %14
  %20 = mul nsw i32 %16, 10
  %21 = add nsw i32 %20, %17
  %22 = tail call fastcc i32 @readit() #16
  br label %14, !llvm.loop !136

23:                                               ; preds = %12
  %24 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %25 = getelementptr inbounds nuw i8, ptr %24, i32 36
  store i32 0, ptr %25, align 4, !tbaa !33
  br label %32

26:                                               ; preds = %14
  %27 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %28 = getelementptr inbounds nuw i8, ptr %27, i32 36
  %29 = load i32, ptr %28, align 4, !tbaa !33
  %30 = tail call i32 @llvm.umax.i32(i32 %29, i32 1)
  %31 = mul nsw i32 %30, %16
  store i32 %31, ptr %28, align 4, !tbaa !33
  br label %32

32:                                               ; preds = %26, %8, %23
  %33 = phi i32 [ %15, %26 ], [ %9, %8 ], [ 48, %23 ]
  %34 = icmp eq i32 %2, %33
  br i1 %34, label %37, label %35

35:                                               ; preds = %32
  %36 = trunc i32 %33 to i8
  br label %53

37:                                               ; preds = %3, %32
  %38 = phi i32 [ %2, %32 ], [ 121, %3 ]
  %39 = trunc i32 %38 to i8
  %40 = tail call ptr @strchr(ptr noundef nonnull @.str.59, i8 noundef signext %39) #17
  %41 = icmp eq ptr %40, null
  br i1 %41, label %53, label %42

42:                                               ; preds = %37
  %43 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %44 = getelementptr inbounds nuw i8, ptr %43, i32 36
  %45 = load i32, ptr %44, align 4, !tbaa !33
  %46 = add nsw i32 %45, -1
  store i32 %46, ptr %44, align 4, !tbaa !33
  %47 = icmp sgt i32 %45, 1
  br i1 %47, label %48, label %139

48:                                               ; preds = %42
  tail call fastcc void @do_cmd(i32 noundef 106) #16
  %49 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %50 = getelementptr inbounds nuw i8, ptr %49, i32 104
  %51 = load i32, ptr %50, align 4, !tbaa !54
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %139, label %135

53:                                               ; preds = %35, %37
  %54 = phi i8 [ %36, %35 ], [ %39, %37 ]
  %55 = phi i32 [ %33, %35 ], [ %38, %37 ]
  %56 = tail call ptr @strchr(ptr noundef nonnull @.str.60, i8 noundef signext %54) #17
  %57 = icmp eq ptr %56, null
  br i1 %57, label %66, label %58

58:                                               ; preds = %53
  %59 = tail call ptr @strchr(ptr noundef nonnull @.str.61, i8 noundef signext %54) #17
  %60 = icmp eq ptr %59, null
  %61 = select i1 %60, i32 0, i32 2
  tail call fastcc void @do_cmd(i32 noundef %55) #16
  %62 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %63 = getelementptr inbounds nuw i8, ptr %62, i32 8
  %64 = load ptr, ptr %63, align 4, !tbaa !43
  %65 = icmp eq ptr %6, %64
  br i1 %65, label %135, label %139

66:                                               ; preds = %53
  %67 = tail call ptr @strchr(ptr noundef nonnull @.str.62, i8 noundef signext %54) #17
  %68 = icmp eq ptr %67, null
  br i1 %68, label %112, label %69

69:                                               ; preds = %66
  tail call fastcc void @do_cmd(i32 noundef %55) #16
  %70 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %71 = getelementptr inbounds nuw i8, ptr %70, i32 8
  %72 = load ptr, ptr %71, align 4, !tbaa !43
  %73 = icmp ugt ptr %72, %6
  br i1 %73, label %74, label %86

74:                                               ; preds = %69
  %75 = tail call fastcc i32 @at_eof(ptr noundef nonnull %72) #16
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %84, label %77

77:                                               ; preds = %74
  %78 = icmp eq i32 %55, 119
  br i1 %78, label %79, label %86

79:                                               ; preds = %77
  %80 = load i8, ptr %72, align 1, !tbaa !24
  %81 = sext i8 %80 to i32
  %82 = tail call fastcc i32 @bb_ispunct(i32 noundef %81) #16
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %86, label %84

84:                                               ; preds = %79, %74
  %85 = getelementptr inbounds i8, ptr %72, i32 -1
  store ptr %85, ptr %71, align 4, !tbaa !43
  br label %86

86:                                               ; preds = %84, %79, %77, %69
  %87 = phi ptr [ %72, %69 ], [ %72, %77 ], [ %72, %79 ], [ %85, %84 ]
  br label %88

88:                                               ; preds = %86, %99
  %89 = phi ptr [ %100, %99 ], [ %87, %86 ]
  %90 = phi ptr [ %103, %99 ], [ %87, %86 ]
  %91 = icmp ugt ptr %89, %6
  br i1 %91, label %92, label %104

92:                                               ; preds = %88
  %93 = load i8, ptr %89, align 1, !tbaa !24
  %94 = sext i8 %93 to i32
  %95 = icmp ne i8 %93, 32
  %96 = add nsw i32 %94, -14
  %97 = icmp ult i32 %96, -5
  %98 = select i1 %95, i1 %97, i1 false
  br i1 %98, label %104, label %99

99:                                               ; preds = %92
  %100 = getelementptr inbounds i8, ptr %89, i32 -1
  store ptr %100, ptr %71, align 4, !tbaa !43
  %101 = load i8, ptr %89, align 1, !tbaa !24
  %102 = icmp eq i8 %101, 10
  %103 = select i1 %102, ptr %100, ptr %90
  br label %88, !llvm.loop !137

104:                                              ; preds = %88, %92
  %105 = icmp eq i32 %2, 99
  br i1 %105, label %139, label %106

106:                                              ; preds = %104
  %107 = icmp eq ptr %89, %90
  br i1 %107, label %139, label %108

108:                                              ; preds = %106
  %109 = load i8, ptr %89, align 1, !tbaa !24
  %110 = icmp eq i8 %109, 10
  br i1 %110, label %139, label %111

111:                                              ; preds = %108
  store ptr %90, ptr %71, align 4, !tbaa !43
  br label %139

112:                                              ; preds = %66
  %113 = tail call ptr @strchr(ptr noundef nonnull @.str.63, i8 noundef signext %54) #17
  %114 = icmp eq ptr %113, null
  br i1 %114, label %120, label %115

115:                                              ; preds = %112
  tail call fastcc void @do_cmd(i32 noundef %55) #16
  %116 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %117 = getelementptr inbounds nuw i8, ptr %116, i32 104
  %118 = load i32, ptr %117, align 4, !tbaa !54
  %119 = icmp eq i32 %118, 0
  br i1 %119, label %139, label %135

120:                                              ; preds = %112
  switch i32 %55, label %135 [
    i32 32, label %121
    i32 108, label %121
  ]

121:                                              ; preds = %120, %120
  %122 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %123 = getelementptr inbounds nuw i8, ptr %122, i32 36
  %124 = load i32, ptr %123, align 4, !tbaa !33
  %125 = tail call i32 @llvm.umax.i32(i32 %124, i32 1)
  tail call fastcc void @do_cmd(i32 noundef %55) #16
  %126 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %127 = getelementptr inbounds nuw i8, ptr %126, i32 8
  %128 = load ptr, ptr %127, align 4, !tbaa !43
  %129 = ptrtoint ptr %128 to i32
  %130 = ptrtoint ptr %6 to i32
  %131 = sub i32 %129, %130
  %132 = icmp eq i32 %125, %131
  br i1 %132, label %133, label %139

133:                                              ; preds = %121
  %134 = getelementptr inbounds i8, ptr %128, i32 -1
  store ptr %134, ptr %127, align 4, !tbaa !43
  br label %139

135:                                              ; preds = %58, %120, %48, %115
  %136 = phi i32 [ %38, %48 ], [ %55, %115 ], [ %55, %120 ], [ %55, %58 ]
  %137 = icmp eq i32 %136, 27
  br i1 %137, label %181, label %138

138:                                              ; preds = %135
  tail call fastcc void @indicate_error() #16
  br label %181

139:                                              ; preds = %115, %48, %42, %111, %108, %106, %104, %58, %133, %121
  %140 = phi ptr [ %126, %121 ], [ %126, %133 ], [ %62, %58 ], [ %70, %104 ], [ %70, %106 ], [ %70, %108 ], [ %70, %111 ], [ %43, %42 ], [ %49, %48 ], [ %116, %115 ]
  %141 = phi i32 [ %55, %121 ], [ %55, %133 ], [ %55, %58 ], [ %55, %104 ], [ %55, %106 ], [ %55, %108 ], [ %55, %111 ], [ %38, %42 ], [ %38, %48 ], [ %55, %115 ]
  %142 = phi i32 [ 0, %121 ], [ 0, %133 ], [ %61, %58 ], [ 2, %104 ], [ 2, %106 ], [ 2, %108 ], [ 2, %111 ], [ 1, %42 ], [ 1, %48 ], [ 1, %115 ]
  %143 = getelementptr inbounds nuw i8, ptr %140, i32 8
  %144 = load ptr, ptr %143, align 4, !tbaa !43
  %145 = icmp ult ptr %144, %6
  %146 = select i1 %145, ptr %144, ptr %6
  %147 = select i1 %145, ptr %6, ptr %144
  %148 = icmp ugt ptr %147, %146
  br i1 %148, label %149, label %178

149:                                              ; preds = %139
  %150 = trunc i32 %141 to i8
  %151 = tail call ptr @strchr(ptr noundef nonnull @.str.64, i8 noundef signext %150) #17
  %152 = icmp eq ptr %151, null
  br i1 %152, label %155, label %153

153:                                              ; preds = %149
  %154 = getelementptr inbounds i8, ptr %147, i32 -1
  br label %178

155:                                              ; preds = %149
  %156 = tail call ptr @strchr(ptr noundef nonnull @.str.65, i8 noundef signext %150) #17
  %157 = icmp eq ptr %156, null
  br i1 %157, label %178, label %158

158:                                              ; preds = %155
  %159 = tail call fastcc ptr @begin_line(ptr noundef %146) #16
  %160 = icmp eq ptr %146, %159
  br i1 %160, label %161, label %168

161:                                              ; preds = %158
  %162 = load i8, ptr %147, align 1, !tbaa !24
  %163 = icmp eq i8 %162, 10
  br i1 %163, label %168, label %164

164:                                              ; preds = %161
  %165 = tail call fastcc i32 @at_eof(ptr noundef nonnull %147) #16
  %166 = icmp eq i32 %165, 0
  %167 = select i1 %166, i32 2, i32 1
  br label %168

168:                                              ; preds = %161, %164, %158
  %169 = phi i32 [ 2, %158 ], [ 1, %161 ], [ %167, %164 ]
  %170 = tail call fastcc i32 @at_eof(ptr noundef nonnull %147) #16
  %171 = icmp eq i32 %170, 0
  br i1 %171, label %172, label %178

172:                                              ; preds = %168
  %173 = getelementptr inbounds i8, ptr %147, i32 -1
  %174 = icmp ugt ptr %173, %146
  br i1 %174, label %175, label %178

175:                                              ; preds = %172
  %176 = getelementptr inbounds i8, ptr %147, i32 -2
  %177 = select i1 %160, ptr %173, ptr %176
  br label %178

178:                                              ; preds = %175, %153, %168, %172, %155, %139
  %179 = phi ptr [ %154, %153 ], [ %147, %168 ], [ %173, %172 ], [ %147, %155 ], [ %147, %139 ], [ %177, %175 ]
  %180 = phi i32 [ %142, %153 ], [ %169, %168 ], [ %169, %172 ], [ %142, %155 ], [ %142, %139 ], [ %169, %175 ]
  store ptr %146, ptr %0, align 4, !tbaa !18
  store ptr %179, ptr %1, align 4, !tbaa !18
  br label %181

181:                                              ; preds = %135, %138, %178
  %182 = phi i32 [ %180, %178 ], [ -1, %138 ], [ -1, %135 ]
  ret i32 %182
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_end() unnamed_addr #10 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = tail call fastcc ptr @end_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !43
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc noundef ptr @skip_thing(ptr noundef readonly captures(address, ret: address, provenance) %0, i32 noundef range(i32 1, 3) %1, i32 noundef range(i32 -1, 2) %2, i32 noundef range(i32 1, 6) %3) unnamed_addr #5 {
  %5 = icmp sgt i32 %2, -1
  %6 = load ptr, ptr @ptr_to_globals, align 4
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 4
  %8 = load i8, ptr %0, align 1, !tbaa !24
  br label %9

9:                                                ; preds = %62, %4
  %10 = phi i8 [ %8, %4 ], [ %14, %62 ]
  %11 = phi i32 [ %1, %4 ], [ %57, %62 ]
  %12 = phi ptr [ %0, %4 ], [ %13, %62 ]
  %13 = getelementptr inbounds i8, ptr %12, i32 %2
  %14 = load i8, ptr %13, align 1, !tbaa !24
  switch i32 %3, label %33 [
    i32 1, label %15
    i32 2, label %43
    i32 3, label %23
    i32 4, label %29
  ]

15:                                               ; preds = %9
  %16 = sext i8 %14 to i32
  %17 = icmp eq i8 %14, 32
  %18 = add nsw i32 %16, -9
  %19 = icmp ult i32 %18, 5
  %20 = select i1 %17, i1 true, i1 %19
  %21 = icmp ne i8 %14, 10
  %22 = and i1 %21, %20
  br i1 %22, label %66, label %51

23:                                               ; preds = %9
  %24 = sext i8 %10 to i32
  %25 = icmp ne i8 %10, 32
  %26 = add nsw i32 %24, -14
  %27 = icmp ult i32 %26, -5
  %28 = select i1 %25, i1 %27, i1 false
  br i1 %28, label %66, label %51

29:                                               ; preds = %9
  %30 = sext i8 %14 to i32
  %31 = tail call fastcc i32 @bb_ispunct(i32 noundef %30) #16
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %66, label %51

33:                                               ; preds = %9
  %34 = sext i8 %14 to i32
  %35 = and i32 %34, -33
  %36 = add nsw i32 %35, -91
  %37 = icmp ult i32 %36, -26
  %38 = add nsw i32 %34, -58
  %39 = icmp ult i32 %38, -10
  %40 = select i1 %37, i1 %39, i1 false
  %41 = icmp ne i8 %14, 95
  %42 = select i1 %40, i1 %41, i1 false
  br i1 %42, label %66, label %51

43:                                               ; preds = %9
  %44 = sext i8 %10 to i32
  %45 = icmp eq i8 %10, 32
  %46 = add nsw i32 %44, -9
  %47 = icmp ult i32 %46, 5
  %48 = select i1 %45, i1 true, i1 %47
  %49 = icmp ne i8 %10, 10
  %50 = and i1 %49, %48
  br i1 %50, label %66, label %51

51:                                               ; preds = %15, %23, %29, %33, %43
  %52 = phi i8 [ %14, %33 ], [ %10, %43 ], [ %14, %29 ], [ %10, %23 ], [ %14, %15 ]
  %53 = icmp eq i8 %52, 10
  br i1 %53, label %54, label %56

54:                                               ; preds = %51
  %55 = icmp samesign ult i32 %11, 2
  br i1 %55, label %66, label %56

56:                                               ; preds = %54, %51
  %57 = phi i32 [ 1, %54 ], [ %11, %51 ]
  br i1 %5, label %58, label %63

58:                                               ; preds = %56
  %59 = load ptr, ptr %7, align 4, !tbaa !48
  %60 = getelementptr inbounds i8, ptr %59, i32 -1
  %61 = icmp ult ptr %12, %60
  br i1 %61, label %62, label %66

62:                                               ; preds = %58, %63
  br label %9, !llvm.loop !138

63:                                               ; preds = %56
  %64 = load ptr, ptr %6, align 4, !tbaa !29
  %65 = icmp ugt ptr %12, %64
  br i1 %65, label %62, label %66

66:                                               ; preds = %15, %23, %29, %33, %63, %58, %54, %43
  ret ptr %12
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @end_screen() unnamed_addr #5 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 76
  %3 = load ptr, ptr %2, align 4, !tbaa !49
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 44
  %5 = load i32, ptr %4, align 4, !tbaa !20
  %6 = add i32 %5, -2
  br label %7

7:                                                ; preds = %11, %0
  %8 = phi ptr [ %3, %0 ], [ %12, %11 ]
  %9 = phi i32 [ 0, %0 ], [ %13, %11 ]
  %10 = icmp eq i32 %9, %6
  br i1 %10, label %14, label %11

11:                                               ; preds = %7
  %12 = tail call fastcc ptr @next_line(ptr noundef %8) #16
  %13 = add nuw i32 %9, 1
  br label %7, !llvm.loop !139

14:                                               ; preds = %7
  %15 = tail call fastcc ptr @end_line(ptr noundef %8) #16
  ret ptr %15
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_prev() unnamed_addr #10 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !43
  %4 = tail call fastcc ptr @prev_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !43
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define internal fastcc range(i32 0, 2) i32 @bb_ispunct(i32 noundef range(i32 -128, 128) %0) unnamed_addr #14 {
  %2 = add nsw i32 %0, -33
  %3 = icmp ult i32 %2, 94
  br i1 %3, label %4, label %12

4:                                                ; preds = %1
  %5 = and i32 %0, 95
  %6 = add nsw i32 %5, -91
  %7 = icmp ult i32 %6, -26
  %8 = add nsw i32 %0, -58
  %9 = icmp ult i32 %8, -10
  %10 = select i1 %7, i1 %9, i1 false
  %11 = zext i1 %10 to i32
  br label %12

12:                                               ; preds = %4, %1
  %13 = phi i32 [ 0, %1 ], [ %11, %4 ]
  ret i32 %13
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc range(i32 0, 2) i32 @at_eof(ptr noundef readonly captures(address) %0) unnamed_addr #8 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %4 = load ptr, ptr %3, align 4, !tbaa !48
  %5 = getelementptr inbounds i8, ptr %4, i32 -2
  %6 = icmp eq ptr %0, %5
  br i1 %6, label %7, label %11

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 1
  %9 = load i8, ptr %8, align 1, !tbaa !24
  %10 = icmp eq i8 %9, 10
  br i1 %10, label %15, label %11

11:                                               ; preds = %7, %1
  %12 = getelementptr inbounds i8, ptr %4, i32 -1
  %13 = icmp eq ptr %0, %12
  %14 = zext i1 %13 to i32
  br label %15

15:                                               ; preds = %11, %7
  %16 = phi i32 [ 1, %7 ], [ %14, %11 ]
  ret i32 %16
}

; Function Attrs: minsize optsize
declare dso_local i32 @select(i32 noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @place_cursor(i32 noundef %0, i32 noundef %1) unnamed_addr #0 {
  %3 = alloca [33 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 33, ptr nonnull %3) #19
  %4 = tail call i32 @llvm.smax.i32(i32 %0, i32 0)
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 44
  %7 = load i32, ptr %6, align 4, !tbaa !20
  %8 = icmp ult i32 %4, %7
  %9 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %11 = load i32, ptr %10, align 4, !tbaa !21
  %12 = icmp ult i32 %9, %11
  %13 = add nuw nsw i32 %4, 1
  %14 = select i1 %8, i32 %13, i32 %7
  %15 = add nuw nsw i32 %9, 1
  %16 = select i1 %12, i32 %15, i32 %11
  call void (ptr, ptr, ...) @bb_sprintf(ptr noundef %3, ptr nonnull poison, i32 noundef %14, i32 noundef %16) #16
  call fastcc void @write1(ptr noundef nonnull %3) #16
  call void @llvm.lifetime.end.p0(i64 33, ptr nonnull %3) #19
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize
define internal void @bb_sprintf(ptr noundef nonnull writeonly captures(none) %0, ptr readnone captures(none) %1, ...) unnamed_addr #11 {
  %3 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #19
  call void @llvm.va_start.p0(ptr nonnull %3)
  %4 = load i32, ptr %3, align 4
  %5 = insertvalue [1 x i32] poison, i32 %4, 0
  %6 = call fastcc i32 @bb_vsnprintf(ptr noundef nonnull %0, i32 noundef 134217727, ptr noundef nonnull @.str.67, [1 x i32] %5) #16
  call void @llvm.va_end.p0(ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #19
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize
define internal i32 @bb_snprintf(ptr noundef writeonly captures(none) %0, i32 noundef range(i32 1, 201) %1, ptr readnone captures(none) %2, ...) unnamed_addr #11 {
  %4 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #19
  call void @llvm.va_start.p0(ptr nonnull %4)
  %5 = load i32, ptr %4, align 4
  %6 = insertvalue [1 x i32] poison, i32 %5, 0
  %7 = call fastcc i32 @bb_vsnprintf(ptr noundef %0, i32 noundef %1, ptr noundef nonnull @.str.68, [1 x i32] %6) #16
  call void @llvm.va_end.p0(ptr nonnull %4)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #19
  ret i32 %7
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umax.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.abs.i32(i32, i1 immarg) #15

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #9 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #11 = { minsize nofree norecurse nosync nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #12 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #13 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #14 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #15 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #16 = { minsize nobuiltin optsize "no-builtins" }
attributes #17 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #18 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #19 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"p1 _ZTS7globals", !5, i64 0}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !11, i64 28}
!9 = !{!"globals", !10, i64 0, !10, i64 4, !10, i64 8, !11, i64 12, !11, i64 16, !11, i64 20, !11, i64 24, !11, i64 28, !11, i64 32, !11, i64 36, !10, i64 40, !11, i64 44, !11, i64 48, !11, i64 52, !11, i64 56, !11, i64 60, !11, i64 64, !11, i64 68, !10, i64 72, !10, i64 76, !10, i64 80, !11, i64 84, !11, i64 88, !11, i64 92, !11, i64 96, !10, i64 100, !11, i64 104, !10, i64 108, !11, i64 112, !11, i64 116, !11, i64 120, !6, i64 124, !6, i64 236, !6, i64 264, !12, i64 376, !11, i64 380, !11, i64 384, !13, i64 388, !6, i64 392, !6, i64 408, !6, i64 608, !6, i64 736}
!10 = !{!"p1 omnipotent char", !5, i64 0}
!11 = !{!"int", !6, i64 0}
!12 = !{!"termios", !6, i64 0}
!13 = !{!"p1 _ZTS7llist_t", !5, i64 0}
!14 = !{!9, !10, i64 100}
!15 = !{!9, !11, i64 88}
!16 = !{!11, !11, i64 0}
!17 = !{!9, !11, i64 32}
!18 = !{!10, !10, i64 0}
!19 = !{!9, !11, i64 16}
!20 = !{!9, !11, i64 44}
!21 = !{!9, !11, i64 48}
!22 = !{!9, !10, i64 80}
!23 = !{!9, !11, i64 84}
!24 = !{!6, !6, i64 0}
!25 = distinct !{!25, !26, !27}
!26 = !{!"llvm.loop.mustprogress"}
!27 = !{!"llvm.loop.unroll.disable"}
!28 = !{!9, !11, i64 120}
!29 = !{!9, !10, i64 0}
!30 = !{!9, !11, i64 52}
!31 = !{!9, !11, i64 56}
!32 = !{!9, !11, i64 20}
!33 = !{!9, !11, i64 36}
!34 = !{!9, !11, i64 60}
!35 = distinct !{!35, !26, !27}
!36 = !{!9, !13, i64 388}
!37 = !{!38, !10, i64 4}
!38 = !{!"llist_t", !13, i64 0, !10, i64 4}
!39 = !{!38, !13, i64 0}
!40 = !{!13, !13, i64 0}
!41 = distinct !{!41, !26, !27}
!42 = distinct !{!42, !26, !27}
!43 = !{!9, !10, i64 8}
!44 = !{!9, !10, i64 108}
!45 = distinct !{!45, !26, !27}
!46 = distinct !{!46, !27}
!47 = !{!9, !11, i64 12}
!48 = !{!9, !10, i64 4}
!49 = !{!9, !10, i64 76}
!50 = !{!9, !11, i64 24}
!51 = !{!9, !11, i64 68}
!52 = distinct !{!52, !26, !27}
!53 = !{!9, !11, i64 384}
!54 = !{!9, !11, i64 104}
!55 = distinct !{!55, !26, !27}
!56 = distinct !{!56, !26, !27}
!57 = !{!9, !11, i64 380}
!58 = distinct !{!58, !26, !27}
!59 = distinct !{!59, !26, !27}
!60 = distinct !{!60, !27}
!61 = distinct !{!61, !27}
!62 = distinct !{!62, !26, !27}
!63 = !{!9, !11, i64 92}
!64 = !{!9, !11, i64 96}
!65 = distinct !{!65, !26, !27}
!66 = distinct !{!66, !26, !27}
!67 = distinct !{!67, !26, !27}
!68 = distinct !{!68, !26, !27}
!69 = distinct !{!69, !26, !27}
!70 = distinct !{!70, !26, !27}
!71 = distinct !{!71, !26, !27}
!72 = distinct !{!72, !26, !27}
!73 = distinct !{!73, !26, !27}
!74 = distinct !{!74, !26, !27}
!75 = distinct !{!75, !26, !27}
!76 = !{!9, !10, i64 40}
!77 = distinct !{!77, !26, !27}
!78 = !{!9, !10, i64 72}
!79 = distinct !{!79, !26, !27}
!80 = distinct !{!80, !26, !27}
!81 = distinct !{!81, !26, !27}
!82 = distinct !{!82, !26, !27}
!83 = distinct !{!83, !26, !27}
!84 = distinct !{!84, !26, !27}
!85 = distinct !{!85, !26, !27}
!86 = distinct !{!86, !26, !27}
!87 = distinct !{!87, !26, !27}
!88 = distinct !{!88, !26, !27}
!89 = distinct !{!89, !26, !27}
!90 = distinct !{!90, !26, !27}
!91 = distinct !{!91, !26, !27}
!92 = !{!9, !11, i64 112}
!93 = distinct !{!93, !26, !27}
!94 = !{!9, !11, i64 64}
!95 = !{!9, !11, i64 116}
!96 = distinct !{!96, !26, !27}
!97 = !{!98, !99, i64 8}
!98 = !{!"stat", !11, i64 0, !11, i64 4, !99, i64 8, !99, i64 10, !100, i64 12}
!99 = !{!"short", !6, i64 0}
!100 = !{!"long", !6, i64 0}
!101 = !{!98, !100, i64 12}
!102 = distinct !{!102, !26, !27}
!103 = distinct !{!103, !26, !27}
!104 = distinct !{!104, !26, !27}
!105 = distinct !{!105, !26, !27}
!106 = distinct !{!106, !26, !27}
!107 = distinct !{!107, !26, !27}
!108 = distinct !{!108, !26, !27}
!109 = distinct !{!109, !26, !27}
!110 = distinct !{!110, !26, !27}
!111 = distinct !{!111, !26, !27}
!112 = distinct !{!112, !26, !27}
!113 = distinct !{!113, !26, !27}
!114 = distinct !{!114, !26, !27}
!115 = distinct !{!115, !27}
!116 = distinct !{!116, !27}
!117 = distinct !{!117, !26, !27}
!118 = distinct !{!118, !26, !27}
!119 = distinct !{!119, !26, !27}
!120 = distinct !{!120, !26, !27}
!121 = distinct !{!121, !26, !27}
!122 = distinct !{!122, !26, !27}
!123 = distinct !{!123, !26, !27}
!124 = distinct !{!124, !26, !27}
!125 = distinct !{!125, !26, !27}
!126 = distinct !{!126, !26, !27}
!127 = distinct !{!127, !26, !27}
!128 = distinct !{!128, !26, !27}
!129 = distinct !{!129, !26, !27}
!130 = distinct !{!130, !26, !27}
!131 = distinct !{!131, !26, !27}
!132 = distinct !{!132, !26, !27}
!133 = distinct !{!133, !26, !27}
!134 = distinct !{!134, !26, !27}
!135 = distinct !{!135, !26, !27}
!136 = distinct !{!136, !26, !27}
!137 = distinct !{!137, !26, !27}
!138 = distinct !{!138, !26, !27}
!139 = distinct !{!139, !26, !27}
