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
  %3 = tail call fastcc ptr @xzalloc(i32 noundef 1084) #16
  store ptr %3, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 28
  %5 = load i32, ptr %4, align 4, !tbaa !8
  %6 = add nsw i32 %5, -1
  store i32 %6, ptr %4, align 4, !tbaa !8
  %7 = getelementptr inbounds nuw i8, ptr %3, i32 88
  store i32 2147483647, ptr %7, align 4, !tbaa !14
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 92
  store i32 -1, ptr %8, align 4, !tbaa !15
  %9 = tail call fastcc ptr @xzalloc(i32 noundef 2) #16
  %10 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 124
  store ptr %9, ptr %11, align 4, !tbaa !16
  %12 = getelementptr inbounds nuw i8, ptr %10, i32 112
  store i32 8, ptr %12, align 4, !tbaa !17
  store i32 1, ptr @optind, align 4, !tbaa !18
  %13 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %14 = add nsw i32 %0, -1
  %15 = getelementptr inbounds nuw i8, ptr %10, i32 32
  store i32 %14, ptr %15, align 4, !tbaa !19
  tail call fastcc void @write1(ptr noundef nonnull @.str) #16
  store i32 0, ptr @optind, align 4, !tbaa !18
  %16 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %17

17:                                               ; preds = %105, %2
  %18 = phi ptr [ %108, %105 ], [ %16, %2 ]
  %19 = phi i32 [ %107, %105 ], [ 0, %2 ]
  %20 = getelementptr inbounds ptr, ptr %13, i32 %19
  %21 = load ptr, ptr %20, align 4, !tbaa !20
  %22 = getelementptr inbounds nuw i8, ptr %18, i32 16
  store i32 1, ptr %22, align 4, !tbaa !21
  tail call fastcc void @rawmode() #16
  %23 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %24 = getelementptr inbounds nuw i8, ptr %23, i32 44
  store i32 24, ptr %24, align 4, !tbaa !22
  %25 = getelementptr inbounds nuw i8, ptr %23, i32 48
  store i32 80, ptr %25, align 4, !tbaa !23
  %26 = getelementptr inbounds nuw i8, ptr %23, i32 80
  %27 = load ptr, ptr %26, align 4, !tbaa !24
  tail call fastcc void @bb_free(ptr noundef %27) #16
  %28 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %29 = getelementptr inbounds nuw i8, ptr %28, i32 84
  store i32 1928, ptr %29, align 4, !tbaa !25
  %30 = tail call fastcc ptr @xmalloc(i32 noundef 1928) #16
  %31 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %32 = getelementptr inbounds nuw i8, ptr %31, i32 80
  store ptr %30, ptr %32, align 4, !tbaa !24
  tail call fastcc void @screen_erase() #16
  br label %33

33:                                               ; preds = %37, %17
  %34 = phi i32 [ 22, %17 ], [ %38, %37 ]
  %35 = phi ptr [ %30, %17 ], [ %39, %37 ]
  %36 = icmp eq i32 %34, 0
  br i1 %36, label %40, label %37

37:                                               ; preds = %33
  %38 = add nsw i32 %34, -1
  %39 = getelementptr inbounds nuw i8, ptr %35, i32 80
  store i8 126, ptr %39, align 1, !tbaa !26
  br label %33, !llvm.loop !27

40:                                               ; preds = %33
  %41 = tail call fastcc i32 @init_text_buffer(ptr noundef %21) #16
  %42 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %43 = getelementptr inbounds nuw i8, ptr %42, i32 148
  store i32 26, ptr %43, align 4, !tbaa !30
  %44 = load ptr, ptr %42, align 4, !tbaa !31
  %45 = getelementptr inbounds nuw i8, ptr %42, i32 400
  store ptr %44, ptr %45, align 4, !tbaa !20
  %46 = getelementptr inbounds nuw i8, ptr %42, i32 396
  store ptr %44, ptr %46, align 4, !tbaa !20
  %47 = getelementptr inbounds nuw i8, ptr %42, i32 52
  store i32 0, ptr %47, align 4, !tbaa !32
  %48 = getelementptr inbounds nuw i8, ptr %42, i32 56
  store i32 0, ptr %48, align 4, !tbaa !33
  %49 = getelementptr inbounds nuw i8, ptr %42, i32 20
  store i32 0, ptr %49, align 4, !tbaa !34
  %50 = getelementptr inbounds nuw i8, ptr %42, i32 36
  store i32 0, ptr %50, align 4, !tbaa !35
  %51 = getelementptr inbounds nuw i8, ptr %42, i32 60
  store i32 0, ptr %51, align 4, !tbaa !36
  br label %54

52:                                               ; preds = %63
  %53 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %54, !llvm.loop !37

54:                                               ; preds = %52, %40
  %55 = phi ptr [ %53, %52 ], [ %42, %40 ]
  %56 = getelementptr inbounds nuw i8, ptr %55, i32 416
  %57 = load ptr, ptr %56, align 4, !tbaa !38
  %58 = icmp eq ptr %57, null
  br i1 %58, label %77, label %59

59:                                               ; preds = %54
  %60 = getelementptr inbounds nuw i8, ptr %57, i32 4
  %61 = load ptr, ptr %60, align 4, !tbaa !39
  %62 = load ptr, ptr %57, align 4, !tbaa !41
  store ptr %62, ptr %56, align 4, !tbaa !42
  tail call void @free(ptr noundef nonnull %57) #17
  br label %63

63:                                               ; preds = %75, %59
  %64 = phi ptr [ %61, %59 ], [ %76, %75 ]
  %65 = icmp eq ptr %64, null
  br i1 %65, label %52, label %66

66:                                               ; preds = %63
  %67 = tail call ptr @strchr(ptr noundef nonnull %64, i8 noundef signext 10) #17
  %68 = icmp eq ptr %67, null
  br i1 %68, label %75, label %69

69:                                               ; preds = %66, %73
  %70 = phi ptr [ %74, %73 ], [ %67, %66 ]
  %71 = load i8, ptr %70, align 1, !tbaa !26
  %72 = icmp eq i8 %71, 10
  br i1 %72, label %73, label %75

73:                                               ; preds = %69
  %74 = getelementptr inbounds nuw i8, ptr %70, i32 1
  store i8 0, ptr %70, align 1, !tbaa !26
  br label %69, !llvm.loop !43

75:                                               ; preds = %69, %66
  %76 = phi ptr [ null, %66 ], [ %70, %69 ]
  tail call fastcc void @colon(ptr noundef nonnull %64) #16
  br label %63, !llvm.loop !44

77:                                               ; preds = %54
  tail call fastcc void @redraw(i32 noundef 0) #16
  br label %78

78:                                               ; preds = %104, %77
  %79 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %80 = getelementptr inbounds nuw i8, ptr %79, i32 16
  %81 = load i32, ptr %80, align 4, !tbaa !21
  %82 = icmp sgt i32 %81, 0
  br i1 %82, label %83, label %105

83:                                               ; preds = %78
  %84 = tail call fastcc i32 @readit() #16
  %85 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %86 = getelementptr inbounds nuw i8, ptr %85, i32 8
  %87 = load ptr, ptr %86, align 4, !tbaa !45
  %88 = tail call fastcc ptr @begin_line(ptr noundef %87) #16
  %89 = getelementptr inbounds nuw i8, ptr %85, i32 132
  %90 = load ptr, ptr %89, align 4, !tbaa !46
  %91 = icmp eq ptr %88, %90
  br i1 %91, label %95, label %92

92:                                               ; preds = %83
  store ptr %88, ptr %89, align 4, !tbaa !46
  %93 = tail call fastcc ptr @begin_line(ptr noundef %87) #16
  %94 = tail call fastcc ptr @end_line(ptr noundef %87) #16
  tail call fastcc void @text_yank(ptr noundef %93, ptr noundef %94, i32 noundef 27, i32 noundef 0) #16
  br label %95

95:                                               ; preds = %92, %83
  tail call fastcc void @do_cmd(i32 noundef %84) #16
  %96 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %97 = getelementptr inbounds nuw i8, ptr %96, i32 420
  %98 = load i8, ptr %97, align 4, !tbaa !26
  %99 = icmp eq i8 %98, 0
  br i1 %99, label %100, label %104

100:                                              ; preds = %95
  %101 = tail call i32 @select(i32 noundef 1, i32 noundef 1) #17
  %102 = icmp eq i32 %101, 0
  br i1 %102, label %103, label %104

103:                                              ; preds = %100
  tail call fastcc void @refresh(i32 noundef 0) #16
  tail call fastcc void @show_status_line() #16
  br label %104

104:                                              ; preds = %103, %100, %95
  br label %78, !llvm.loop !47

105:                                              ; preds = %78
  tail call fastcc void @go_bottom_and_clear_to_eol() #16
  tail call fastcc void @cookmode() #16
  %106 = load i32, ptr @optind, align 4, !tbaa !18
  %107 = add nsw i32 %106, 1
  store i32 %107, ptr @optind, align 4, !tbaa !18
  %108 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %109 = getelementptr inbounds nuw i8, ptr %108, i32 32
  %110 = load i32, ptr %109, align 4, !tbaa !19
  %111 = icmp slt i32 %107, %110
  br i1 %111, label %17, label %112, !llvm.loop !48

112:                                              ; preds = %105
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
  store i32 5120, ptr @__malloc_chunkunits, align 4, !tbaa !18
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
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 406
  store i8 8, ptr %2, align 1, !tbaa !26
  %3 = tail call i32 @ttyraw(i32 noundef 1) #17
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, -2147483648) i32 @init_text_buffer(ptr noundef %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = load ptr, ptr %2, align 4, !tbaa !31
  tail call fastcc void @bb_free(ptr noundef %3) #16
  %4 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 12
  store i32 10240, ptr %5, align 4, !tbaa !49
  %6 = tail call fastcc ptr @xzalloc(i32 noundef 10240) #16
  %7 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  store ptr %6, ptr %7, align 4, !tbaa !31
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 4
  store ptr %6, ptr %8, align 4, !tbaa !50
  %9 = getelementptr inbounds nuw i8, ptr %7, i32 8
  store ptr %6, ptr %9, align 4, !tbaa !45
  %10 = getelementptr inbounds nuw i8, ptr %7, i32 76
  store ptr %6, ptr %10, align 4, !tbaa !51
  %11 = getelementptr inbounds nuw i8, ptr %7, i32 108
  store i32 0, ptr %11, align 4, !tbaa !52
  %12 = getelementptr inbounds nuw i8, ptr %7, i32 88
  store i32 2147483647, ptr %12, align 4, !tbaa !14
  %13 = getelementptr inbounds nuw i8, ptr %7, i32 92
  store i32 -1, ptr %13, align 4, !tbaa !15
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 96
  store i32 0, ptr %14, align 4, !tbaa !53
  %15 = getelementptr inbounds nuw i8, ptr %7, i32 100
  store i32 0, ptr %15, align 4, !tbaa !54
  %16 = getelementptr inbounds nuw i8, ptr %7, i32 104
  store i32 1, ptr %16, align 4, !tbaa !55
  tail call fastcc void @update_filename(ptr noundef %0) #16
  %17 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %18 = load ptr, ptr %17, align 4, !tbaa !31
  %19 = tail call fastcc i32 @file_insert(ptr noundef %0, ptr noundef %18, i32 noundef 1) #16
  %20 = icmp slt i32 %19, 1
  %21 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %22 = getelementptr inbounds nuw i8, ptr %21, i32 4
  %23 = load ptr, ptr %22, align 4, !tbaa !50
  br i1 %20, label %28, label %24

24:                                               ; preds = %1
  %25 = getelementptr inbounds i8, ptr %23, i32 -1
  %26 = load i8, ptr %25, align 1, !tbaa !26
  %27 = icmp eq i8 %26, 10
  br i1 %27, label %31, label %28

28:                                               ; preds = %1, %24
  %29 = tail call fastcc ptr @char_insert(ptr noundef %23, i8 noundef signext 10) #16
  %30 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %31

31:                                               ; preds = %28, %24
  %32 = phi ptr [ %30, %28 ], [ %21, %24 ]
  %33 = getelementptr inbounds nuw i8, ptr %32, i32 24
  store i32 0, ptr %33, align 4, !tbaa !56
  %34 = getelementptr inbounds nuw i8, ptr %32, i32 28
  store i32 -1, ptr %34, align 4, !tbaa !8
  %35 = getelementptr inbounds nuw i8, ptr %32, i32 292
  %36 = tail call ptr @memset(ptr noundef nonnull %35, i32 noundef 0, i32 noundef 112) #17
  ret i32 %19
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @redraw(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  tail call fastcc void @write1(ptr noundef nonnull @.str.50) #16
  tail call fastcc void @screen_erase() #16
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 68
  store i32 0, ptr %3, align 4, !tbaa !57
  tail call fastcc void @refresh(i32 noundef %0) #16
  tail call fastcc void @show_status_line() #16
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -11, -2147483648) i32 @readit() unnamed_addr #0 {
  %1 = alloca i8, align 1
  %2 = load i32, ptr @bb_key_pending, align 4, !tbaa !18
  %3 = icmp sgt i32 %2, -1
  br i1 %3, label %4, label %5

4:                                                ; preds = %0
  store i32 -1, ptr @bb_key_pending, align 4, !tbaa !18
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
  store i32 %13, ptr @bb_key_pending, align 4, !tbaa !18
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
  %3 = load ptr, ptr %2, align 4, !tbaa !31
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
  %15 = load i8, ptr %14, align 1, !tbaa !26
  %16 = icmp eq i8 %15, 10
  br i1 %16, label %17, label %9, !llvm.loop !58

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
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 152
  %7 = getelementptr inbounds [28 x ptr], ptr %6, i32 0, i32 %2
  %8 = load ptr, ptr %7, align 4, !tbaa !20
  %9 = ptrtoint ptr %1 to i32
  %10 = ptrtoint ptr %0 to i32
  %11 = sub i32 %9, %10
  %12 = icmp slt i32 %11, 0
  %13 = select i1 %12, ptr %1, ptr %0
  %14 = tail call i32 @llvm.abs.i32(i32 %11, i1 true)
  %15 = add nuw nsw i32 %14, 1
  %16 = tail call fastcc ptr @xstrndup(ptr noundef %13, i32 noundef %15) #16
  %17 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %18 = getelementptr inbounds nuw i8, ptr %17, i32 152
  %19 = getelementptr inbounds [28 x ptr], ptr %18, i32 0, i32 %2
  store ptr %16, ptr %19, align 4, !tbaa !20
  %20 = trunc i32 %3 to i8
  %21 = getelementptr inbounds nuw i8, ptr %17, i32 264
  %22 = getelementptr inbounds [28 x i8], ptr %21, i32 0, i32 %2
  store i8 %20, ptr %22, align 1, !tbaa !26
  tail call fastcc void @bb_free(ptr noundef %8) #16
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @end_line(ptr noundef %0) unnamed_addr #5 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %4 = load ptr, ptr %3, align 4, !tbaa !50
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
  %7 = load ptr, ptr %6, align 4, !tbaa !45
  %8 = call ptr @memset(ptr noundef nonnull %4, i32 noundef 0, i32 noundef 12) #17
  %9 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %10 = getelementptr inbounds nuw i8, ptr %9, i32 412
  store i32 0, ptr %10, align 4, !tbaa !59
  %11 = getelementptr inbounds nuw i8, ptr %9, i32 128
  store i32 0, ptr %11, align 4, !tbaa !60
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
  %15 = load i32, ptr %14, align 4, !tbaa !34
  switch i32 %15, label %63 [
    i32 2, label %16
    i32 1, label %48
  ]

16:                                               ; preds = %12
  %17 = icmp eq i32 %0, -8
  br i1 %17, label %732, label %18

18:                                               ; preds = %16
  %19 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %20 = load ptr, ptr %19, align 4, !tbaa !45
  %21 = load i8, ptr %20, align 1, !tbaa !26
  %22 = icmp eq i8 %21, 10
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  store i32 1, ptr %14, align 4, !tbaa !34
  br label %48

24:                                               ; preds = %18
  %25 = icmp sgt i32 %0, 0
  br i1 %25, label %30, label %26

26:                                               ; preds = %24
  %27 = and i32 %0, 255
  %28 = add nsw i32 %27, -32
  %29 = icmp ult i32 %28, 95
  br i1 %29, label %32, label %1148

30:                                               ; preds = %24
  %31 = icmp eq i32 %0, 27
  br i1 %31, label %42, label %32

32:                                               ; preds = %26, %30
  %33 = getelementptr inbounds nuw i8, ptr %13, i32 406
  %34 = load i8, ptr %33, align 2, !tbaa !26
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
  store ptr %39, ptr %41, align 4, !tbaa !45
  br label %42

42:                                               ; preds = %37, %37, %38, %32, %30
  %43 = phi ptr [ %20, %37 ], [ %20, %37 ], [ %39, %38 ], [ %20, %32 ], [ %20, %30 ]
  %44 = trunc i32 %0 to i8
  %45 = call fastcc ptr @char_insert(ptr noundef %43, i8 noundef signext %44) #16
  %46 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %47 = getelementptr inbounds nuw i8, ptr %46, i32 8
  store ptr %45, ptr %47, align 4, !tbaa !45
  br label %1148

48:                                               ; preds = %12, %23
  %49 = icmp eq i32 %0, -8
  br i1 %49, label %808, label %50

50:                                               ; preds = %48
  %51 = icmp sgt i32 %0, 0
  br i1 %51, label %56, label %52

52:                                               ; preds = %50
  %53 = and i32 %0, 255
  %54 = add nsw i32 %53, -32
  %55 = icmp ult i32 %54, 95
  br i1 %55, label %56, label %1148

56:                                               ; preds = %52, %50
  %57 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %58 = load ptr, ptr %57, align 4, !tbaa !45
  %59 = trunc i32 %0 to i8
  %60 = call fastcc ptr @char_insert(ptr noundef %58, i8 noundef signext %59) #16
  %61 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %62 = getelementptr inbounds nuw i8, ptr %61, i32 8
  store ptr %60, ptr %62, align 4, !tbaa !45
  br label %1148

63:                                               ; preds = %12, %1, %1, %1, %1, %1, %1, %1, %1, %1
  switch i32 %0, label %85 [
    i32 0, label %1148
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
    i32 76, label %763
    i32 77, label %780
    i32 79, label %797
    i32 111, label %798
    i32 82, label %70
    i32 -9, label %814
    i32 88, label %826
    i32 120, label %826
    i32 115, label %826
    i32 90, label %853
    i32 94, label %908
    i32 98, label %909
    i32 101, label %909
    i32 99, label %962
    i32 100, label %962
    i32 121, label %962
    i32 89, label %962
    i32 107, label %999
    i32 -2, label %999
    i32 45, label %999
    i32 114, label %1028
    i32 119, label %79
    i32 122, label %1099
    i32 124, label %1117
    i32 126, label %74
    i32 -6, label %1147
  ]

64:                                               ; preds = %63
  %65 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %459

66:                                               ; preds = %63
  %67 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %68 = getelementptr inbounds nuw i8, ptr %67, i32 36
  %69 = load i32, ptr %68, align 4, !tbaa !35
  br label %702

70:                                               ; preds = %63
  %71 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %808

72:                                               ; preds = %63
  %73 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %735

74:                                               ; preds = %63
  %75 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %76 = getelementptr inbounds nuw i8, ptr %75, i32 8
  %77 = getelementptr inbounds nuw i8, ptr %75, i32 36
  %78 = getelementptr inbounds nuw i8, ptr %75, i32 24
  br label %1125

79:                                               ; preds = %63
  %80 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %81 = getelementptr inbounds nuw i8, ptr %80, i32 8
  %82 = load ptr, ptr %81, align 4, !tbaa !45
  %83 = getelementptr inbounds nuw i8, ptr %80, i32 4
  %84 = getelementptr inbounds nuw i8, ptr %80, i32 36
  br label %1059

85:                                               ; preds = %63
  %86 = trunc i32 %0 to i8
  store i8 %86, ptr %4, align 1, !tbaa !26
  %87 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store i8 0, ptr %87, align 1, !tbaa !26
  call fastcc void @not_implemented(ptr noundef %4) #16
  br label %1148

88:                                               ; preds = %63, %63
  %89 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %90 = getelementptr inbounds nuw i8, ptr %89, i32 44
  %91 = load i32, ptr %90, align 4, !tbaa !22
  %92 = add i32 %91, -2
  call fastcc void @dot_scroll(i32 noundef %92, i32 noundef -1) #16
  br label %1148

93:                                               ; preds = %63
  %94 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %95 = getelementptr inbounds nuw i8, ptr %94, i32 44
  %96 = load i32, ptr %95, align 4, !tbaa !22
  %97 = add i32 %96, -2
  %98 = lshr i32 %97, 1
  call fastcc void @dot_scroll(i32 noundef %98, i32 noundef 1) #16
  br label %1148

99:                                               ; preds = %63
  call fastcc void @dot_scroll(i32 noundef 1, i32 noundef 1) #16
  br label %1148

100:                                              ; preds = %63, %63
  %101 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %102 = getelementptr inbounds nuw i8, ptr %101, i32 44
  %103 = load i32, ptr %102, align 4, !tbaa !22
  %104 = add i32 %103, -2
  call fastcc void @dot_scroll(i32 noundef %104, i32 noundef 1) #16
  br label %1148

105:                                              ; preds = %63
  %106 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %107 = getelementptr inbounds nuw i8, ptr %106, i32 68
  store i32 0, ptr %107, align 4, !tbaa !57
  br label %1148

108:                                              ; preds = %63, %63, %63, %63
  %109 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %110 = getelementptr inbounds nuw i8, ptr %109, i32 36
  br label %111

111:                                              ; preds = %111, %108
  call fastcc void @dot_left() #16
  %112 = load i32, ptr %110, align 4, !tbaa !35
  %113 = add nsw i32 %112, -1
  store i32 %113, ptr %110, align 4, !tbaa !35
  %114 = icmp sgt i32 %112, 1
  br i1 %114, label %111, label %1148, !llvm.loop !61

115:                                              ; preds = %63, %63, %63, %63, %63
  %116 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %117 = getelementptr inbounds nuw i8, ptr %116, i32 8
  %118 = load ptr, ptr %117, align 4, !tbaa !45
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
  br label %1148

126:                                              ; preds = %120
  %127 = load i32, ptr %119, align 4, !tbaa !35
  %128 = add nsw i32 %127, -1
  store i32 %128, ptr %119, align 4, !tbaa !35
  %129 = icmp sgt i32 %127, 1
  br i1 %129, label %120, label %130, !llvm.loop !62

130:                                              ; preds = %126
  store ptr %122, ptr %117, align 4, !tbaa !45
  switch i32 %0, label %132 [
    i32 13, label %131
    i32 43, label %131
  ]

131:                                              ; preds = %130, %130
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

132:                                              ; preds = %130
  %133 = getelementptr inbounds nuw i8, ptr %116, i32 408
  %134 = load i32, ptr %133, align 4, !tbaa !63
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
  store ptr %141, ptr %117, align 4, !tbaa !45
  %142 = getelementptr inbounds nuw i8, ptr %116, i32 412
  store i32 1, ptr %142, align 4, !tbaa !59
  br label %1148

143:                                              ; preds = %63, %63
  call fastcc void @redraw(i32 noundef 1) #16
  br label %1148

144:                                              ; preds = %63
  %145 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %146 = getelementptr inbounds nuw i8, ptr %145, i32 44
  %147 = load i32, ptr %146, align 4, !tbaa !22
  %148 = add i32 %147, -2
  %149 = lshr i32 %148, 1
  call fastcc void @dot_scroll(i32 noundef %149, i32 noundef -1) #16
  br label %1148

150:                                              ; preds = %63
  call fastcc void @dot_scroll(i32 noundef 1, i32 noundef -1) #16
  br label %1148

151:                                              ; preds = %63
  %152 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %153 = getelementptr inbounds nuw i8, ptr %152, i32 20
  %154 = load i32, ptr %153, align 4, !tbaa !34
  %155 = icmp eq i32 %154, 0
  br i1 %155, label %156, label %158

156:                                              ; preds = %151
  call fastcc void @indicate_error() #16
  %157 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %158

158:                                              ; preds = %156, %151
  %159 = phi ptr [ %157, %156 ], [ %152, %151 ]
  %160 = getelementptr inbounds nuw i8, ptr %159, i32 20
  store i32 0, ptr %160, align 4, !tbaa !34
  %161 = getelementptr inbounds nuw i8, ptr %159, i32 68
  store i32 0, ptr %161, align 4, !tbaa !57
  br label %1148

162:                                              ; preds = %63, %63, %63
  %163 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %164 = getelementptr inbounds nuw i8, ptr %163, i32 36
  br label %165

165:                                              ; preds = %165, %162
  call fastcc void @dot_right() #16
  %166 = load i32, ptr %164, align 4, !tbaa !35
  %167 = add nsw i32 %166, -1
  store i32 %167, ptr %164, align 4, !tbaa !35
  %168 = icmp sgt i32 %166, 1
  br i1 %168, label %165, label %1148, !llvm.loop !64

169:                                              ; preds = %63
  %170 = call fastcc i32 @readit() #16
  %171 = or i32 %170, 32
  %172 = add nsw i32 %171, -97
  %173 = icmp ult i32 %172, 26
  br i1 %173, label %174, label %177

174:                                              ; preds = %169
  %175 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %176 = getelementptr inbounds nuw i8, ptr %175, i32 148
  store i32 %172, ptr %176, align 4, !tbaa !30
  br label %1148

177:                                              ; preds = %169
  call fastcc void @indicate_error() #16
  br label %1148

178:                                              ; preds = %63
  %179 = call fastcc i32 @readit() #16
  %180 = or i32 %179, 32
  %181 = add nsw i32 %180, -97
  %182 = icmp ult i32 %181, 26
  br i1 %182, label %183, label %197

183:                                              ; preds = %178
  %184 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %185 = getelementptr inbounds nuw i8, ptr %184, i32 292
  %186 = getelementptr inbounds nuw [28 x ptr], ptr %185, i32 0, i32 %181
  %187 = load ptr, ptr %186, align 4, !tbaa !20
  %188 = load ptr, ptr %184, align 4, !tbaa !31
  %189 = icmp ugt ptr %188, %187
  br i1 %189, label %196, label %190

190:                                              ; preds = %183
  %191 = getelementptr inbounds nuw i8, ptr %184, i32 4
  %192 = load ptr, ptr %191, align 4, !tbaa !50
  %193 = icmp ult ptr %187, %192
  br i1 %193, label %194, label %196

194:                                              ; preds = %190
  %195 = getelementptr inbounds nuw i8, ptr %184, i32 8
  store ptr %187, ptr %195, align 4, !tbaa !45
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

196:                                              ; preds = %190, %183
  call fastcc void @indicate_error() #16
  br label %1148

197:                                              ; preds = %178
  %198 = icmp eq i32 %180, 39
  br i1 %198, label %199, label %217

199:                                              ; preds = %197
  %200 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %201 = getelementptr inbounds nuw i8, ptr %200, i32 8
  %202 = load ptr, ptr %201, align 4, !tbaa !45
  %203 = load ptr, ptr %200, align 4, !tbaa !31
  %204 = getelementptr inbounds nuw i8, ptr %200, i32 400
  %205 = load ptr, ptr %204, align 4, !tbaa !20
  %206 = icmp ugt ptr %203, %205
  br i1 %206, label %214, label %207

207:                                              ; preds = %199
  %208 = getelementptr inbounds nuw i8, ptr %200, i32 4
  %209 = load ptr, ptr %208, align 4, !tbaa !50
  %210 = getelementptr inbounds i8, ptr %209, i32 -1
  %211 = icmp ugt ptr %205, %210
  br i1 %211, label %214, label %212

212:                                              ; preds = %207
  store ptr %202, ptr %204, align 4, !tbaa !20
  %213 = getelementptr inbounds nuw i8, ptr %200, i32 396
  store ptr %205, ptr %213, align 4, !tbaa !20
  br label %214

214:                                              ; preds = %199, %207, %212
  %215 = phi ptr [ %205, %212 ], [ %202, %207 ], [ %202, %199 ]
  store ptr %215, ptr %201, align 4, !tbaa !45
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  %216 = load ptr, ptr %201, align 4, !tbaa !45
  br label %1148

217:                                              ; preds = %197
  call fastcc void @indicate_error() #16
  br label %1148

218:                                              ; preds = %63
  %219 = call fastcc i32 @readit() #16
  %220 = or i32 %219, 32
  %221 = add nsw i32 %220, -97
  %222 = icmp ult i32 %221, 26
  br i1 %222, label %223, label %229

223:                                              ; preds = %218
  %224 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %225 = getelementptr inbounds nuw i8, ptr %224, i32 8
  %226 = load ptr, ptr %225, align 4, !tbaa !45
  %227 = getelementptr inbounds nuw i8, ptr %224, i32 292
  %228 = getelementptr inbounds nuw [28 x ptr], ptr %227, i32 0, i32 %221
  store ptr %226, ptr %228, align 4, !tbaa !20
  br label %1148

229:                                              ; preds = %218
  call fastcc void @indicate_error() #16
  br label %1148

230:                                              ; preds = %63, %63
  %231 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %232 = getelementptr inbounds nuw i8, ptr %231, i32 152
  %233 = getelementptr inbounds nuw i8, ptr %231, i32 148
  %234 = load i32, ptr %233, align 4, !tbaa !30
  %235 = getelementptr inbounds nuw [28 x ptr], ptr %232, i32 0, i32 %234
  %236 = load ptr, ptr %235, align 4, !tbaa !20
  %237 = icmp eq ptr %236, null
  br i1 %237, label %238, label %241

238:                                              ; preds = %230
  %239 = call fastcc signext i8 @what_reg() #16
  %240 = zext nneg i8 %239 to i32
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.52, i32 noundef %240) #16
  br label %1148

241:                                              ; preds = %230
  %242 = getelementptr inbounds nuw i8, ptr %231, i32 36
  %243 = load i32, ptr %242, align 4, !tbaa !35
  %244 = call i32 @llvm.umax.i32(i32 %243, i32 1)
  %245 = getelementptr inbounds nuw i8, ptr %231, i32 264
  %246 = getelementptr inbounds nuw [28 x i8], ptr %245, i32 0, i32 %234
  %247 = load i8, ptr %246, align 1, !tbaa !26
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
  %254 = load ptr, ptr %253, align 4, !tbaa !45
  %255 = call fastcc ptr @end_line(ptr noundef %254) #16
  %256 = getelementptr inbounds nuw i8, ptr %231, i32 4
  %257 = load ptr, ptr %256, align 4, !tbaa !50
  %258 = getelementptr inbounds i8, ptr %257, i32 -1
  %259 = icmp eq ptr %255, %258
  br i1 %259, label %260, label %261

260:                                              ; preds = %252
  store ptr %257, ptr %253, align 4, !tbaa !45
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
  %278 = load ptr, ptr %277, align 4, !tbaa !45
  %279 = call fastcc i32 @string_insert(ptr noundef %278, ptr noundef nonnull %236) #16
  %280 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %281 = getelementptr inbounds nuw i8, ptr %280, i32 36
  %282 = load i32, ptr %281, align 4, !tbaa !35
  %283 = add nsw i32 %282, -1
  store i32 %283, ptr %281, align 4, !tbaa !35
  %284 = icmp sgt i32 %282, 1
  br i1 %284, label %275, label %285, !llvm.loop !65

285:                                              ; preds = %275
  %286 = getelementptr inbounds nuw i8, ptr %280, i32 8
  %287 = load ptr, ptr %286, align 4, !tbaa !45
  %288 = getelementptr inbounds i8, ptr %287, i32 %273
  store ptr %288, ptr %286, align 4, !tbaa !45
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

289:                                              ; preds = %63
  %290 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %291 = getelementptr inbounds nuw i8, ptr %290, i32 260
  %292 = load ptr, ptr %291, align 4, !tbaa !20
  %293 = icmp eq ptr %292, null
  br i1 %293, label %1148, label %294

294:                                              ; preds = %289
  %295 = getelementptr inbounds nuw i8, ptr %290, i32 8
  %296 = load ptr, ptr %295, align 4, !tbaa !45
  %297 = call fastcc ptr @begin_line(ptr noundef %296) #16
  %298 = call fastcc ptr @end_line(ptr noundef %296) #16
  %299 = call fastcc ptr @text_hole_delete(ptr noundef %297, ptr noundef %298) #16
  %300 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %301 = getelementptr inbounds nuw i8, ptr %300, i32 260
  %302 = load ptr, ptr %301, align 4, !tbaa !20
  %303 = call fastcc i32 @string_insert(ptr noundef %299, ptr noundef %302) #16
  %304 = getelementptr inbounds nuw i8, ptr %299, i32 %303
  %305 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %306 = getelementptr inbounds nuw i8, ptr %305, i32 8
  store ptr %304, ptr %306, align 4, !tbaa !45
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

307:                                              ; preds = %63, %63
  %308 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %309 = getelementptr inbounds nuw i8, ptr %308, i32 8
  %310 = getelementptr inbounds nuw i8, ptr %308, i32 36
  br label %311

311:                                              ; preds = %317, %307
  %312 = load ptr, ptr %309, align 4, !tbaa !45
  %313 = call fastcc ptr @end_line(ptr noundef %312) #16
  store ptr %313, ptr %309, align 4, !tbaa !45
  %314 = load i32, ptr %310, align 4, !tbaa !35
  %315 = add nsw i32 %314, -1
  store i32 %315, ptr %310, align 4, !tbaa !35
  %316 = icmp slt i32 %314, 2
  br i1 %316, label %318, label %317

317:                                              ; preds = %311
  call fastcc void @dot_next() #16
  br label %311, !llvm.loop !66

318:                                              ; preds = %311
  %319 = getelementptr inbounds nuw i8, ptr %308, i32 408
  store i32 -1, ptr %319, align 4, !tbaa !63
  %320 = getelementptr inbounds nuw i8, ptr %308, i32 412
  store i32 1, ptr %320, align 4, !tbaa !59
  br label %1148

321:                                              ; preds = %63
  %322 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %323 = getelementptr inbounds nuw i8, ptr %322, i32 8
  %324 = load ptr, ptr %323, align 4, !tbaa !45
  br label %325

325:                                              ; preds = %373, %321
  %326 = phi ptr [ %322, %321 ], [ %375, %373 ]
  %327 = phi ptr [ %324, %321 ], [ %374, %373 ]
  %328 = getelementptr inbounds nuw i8, ptr %326, i32 4
  %329 = load ptr, ptr %328, align 4, !tbaa !50
  %330 = icmp ult ptr %327, %329
  br i1 %330, label %331, label %376

331:                                              ; preds = %325
  %332 = load i8, ptr %327, align 1, !tbaa !26
  %333 = icmp eq i8 %332, 10
  br i1 %333, label %379, label %334

334:                                              ; preds = %331
  %335 = call ptr @strchr(ptr noundef nonnull @.str.53, i8 noundef signext %332) #17
  %336 = icmp eq ptr %335, null
  br i1 %336, label %373, label %337

337:                                              ; preds = %334
  %338 = load i8, ptr %327, align 1, !tbaa !26
  %339 = call ptr @strchr(ptr noundef nonnull @.str.53, i8 noundef signext %338) #17
  %340 = ptrtoint ptr %339 to i32
  %341 = sub i32 %340, ptrtoint (ptr @.str.53 to i32)
  %342 = xor i32 %341, 1
  %343 = getelementptr inbounds i8, ptr @.str.53, i32 %342
  %344 = load i8, ptr %343, align 1, !tbaa !26
  %345 = shl i32 %342, 1
  %346 = and i32 %345, 2
  %347 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %348 = load ptr, ptr %347, align 4, !tbaa !31
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
  %357 = load ptr, ptr %349, align 4, !tbaa !50
  %358 = icmp ult ptr %354, %357
  br i1 %358, label %359, label %370

359:                                              ; preds = %356
  %360 = load i8, ptr %354, align 1, !tbaa !26
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
  br label %350, !llvm.loop !67

370:                                              ; preds = %356, %350
  call fastcc void @indicate_error() #16
  br label %376

371:                                              ; preds = %365
  %372 = getelementptr inbounds nuw i8, ptr %347, i32 8
  store ptr %354, ptr %372, align 4, !tbaa !45
  br label %376

373:                                              ; preds = %334
  %374 = getelementptr inbounds nuw i8, ptr %327, i32 1
  %375 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %325, !llvm.loop !68

376:                                              ; preds = %325, %370, %371
  %377 = load i8, ptr %327, align 1, !tbaa !26
  %378 = icmp eq i8 %377, 10
  br i1 %378, label %379, label %1148

379:                                              ; preds = %331, %376
  call fastcc void @indicate_error() #16
  br label %1148

380:                                              ; preds = %63, %63, %63, %63
  %381 = call fastcc i32 @readit() #16
  %382 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %383 = getelementptr inbounds nuw i8, ptr %382, i32 116
  store i32 %381, ptr %383, align 4, !tbaa !69
  %384 = getelementptr inbounds nuw i8, ptr %382, i32 120
  store i32 %0, ptr %384, align 4, !tbaa !70
  br label %392

385:                                              ; preds = %63, %63
  %386 = icmp eq i32 %0, 44
  %387 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %388 = getelementptr inbounds nuw i8, ptr %387, i32 120
  %389 = load i32, ptr %388, align 4, !tbaa !70
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
  %399 = getelementptr inbounds nuw i8, ptr %393, i32 116
  %400 = load i32, ptr %399, align 4, !tbaa !69
  %401 = icmp eq i32 %400, 0
  br i1 %401, label %1148, label %402

402:                                              ; preds = %392
  %403 = load ptr, ptr %395, align 4, !tbaa !45
  %404 = getelementptr inbounds nuw i8, ptr %393, i32 4
  %405 = getelementptr inbounds nuw i8, ptr %393, i32 36
  br label %406

406:                                              ; preds = %423, %402
  %407 = phi ptr [ %403, %402 ], [ %408, %423 ]
  %408 = getelementptr inbounds i8, ptr %407, i32 %398
  br i1 %397, label %413, label %409

409:                                              ; preds = %406
  %410 = load ptr, ptr %404, align 4, !tbaa !50
  %411 = getelementptr inbounds i8, ptr %410, i32 -1
  %412 = icmp ugt ptr %408, %411
  br i1 %412, label %419, label %416

413:                                              ; preds = %406
  %414 = load ptr, ptr %393, align 4, !tbaa !31
  %415 = icmp ult ptr %408, %414
  br i1 %415, label %419, label %416

416:                                              ; preds = %413, %409
  %417 = load i8, ptr %408, align 1, !tbaa !26
  %418 = icmp eq i8 %417, 10
  br i1 %418, label %419, label %420

419:                                              ; preds = %416, %413, %409
  call fastcc void @indicate_error() #16
  br label %1148

420:                                              ; preds = %416
  %421 = sext i8 %417 to i32
  %422 = icmp eq i32 %400, %421
  br i1 %422, label %424, label %423

423:                                              ; preds = %420, %424
  br label %406, !llvm.loop !71

424:                                              ; preds = %420
  %425 = load i32, ptr %405, align 4, !tbaa !35
  %426 = add nsw i32 %425, -1
  store i32 %426, ptr %405, align 4, !tbaa !35
  %427 = icmp sgt i32 %425, 1
  br i1 %427, label %423, label %428

428:                                              ; preds = %424
  store ptr %408, ptr %395, align 4, !tbaa !45
  switch i32 %394, label %1148 [
    i32 116, label %429
    i32 84, label %430
  ]

429:                                              ; preds = %428
  call fastcc void @dot_left() #16
  br label %1148

430:                                              ; preds = %428
  call fastcc void @dot_right() #16
  br label %1148

431:                                              ; preds = %63
  %432 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %433 = getelementptr inbounds nuw i8, ptr %432, i32 124
  %434 = load ptr, ptr %433, align 4, !tbaa !16
  %435 = load i8, ptr %434, align 1, !tbaa !26
  %436 = icmp eq i8 %435, 47
  %437 = select i1 %436, i32 -1, i32 1
  br label %466

438:                                              ; preds = %63, %63
  %439 = trunc nuw nsw i32 %0 to i8
  store i8 %439, ptr %4, align 1, !tbaa !26
  %440 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store i8 0, ptr %440, align 1, !tbaa !26
  %441 = call fastcc ptr @get_input_line(ptr noundef nonnull %4) #16
  %442 = load i8, ptr %441, align 1, !tbaa !26
  %443 = icmp eq i8 %442, 0
  br i1 %443, label %1148, label %444

444:                                              ; preds = %438
  %445 = getelementptr inbounds nuw i8, ptr %441, i32 1
  %446 = load i8, ptr %445, align 1, !tbaa !26
  %447 = icmp eq i8 %446, 0
  %448 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %449 = getelementptr inbounds nuw i8, ptr %448, i32 124
  %450 = load ptr, ptr %449, align 4, !tbaa !16
  br i1 %447, label %451, label %455

451:                                              ; preds = %444
  %452 = load i8, ptr %450, align 1, !tbaa !26
  %453 = icmp eq i8 %452, 0
  br i1 %453, label %459, label %454

454:                                              ; preds = %451
  store i8 %439, ptr %450, align 1, !tbaa !26
  br label %459

455:                                              ; preds = %444
  call fastcc void @bb_free(ptr noundef %450) #16
  %456 = call fastcc ptr @xstrdup(ptr noundef nonnull %441) #16
  %457 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %458 = getelementptr inbounds nuw i8, ptr %457, i32 124
  store ptr %456, ptr %458, align 4, !tbaa !16
  br label %459

459:                                              ; preds = %64, %455, %454, %451
  %460 = phi ptr [ %65, %64 ], [ %457, %455 ], [ %448, %454 ], [ %448, %451 ]
  %461 = getelementptr inbounds nuw i8, ptr %460, i32 124
  %462 = load ptr, ptr %461, align 4, !tbaa !16
  %463 = load i8, ptr %462, align 1, !tbaa !26
  %464 = icmp eq i8 %463, 47
  %465 = select i1 %464, i32 1, i32 -1
  br label %466

466:                                              ; preds = %459, %431
  %467 = phi ptr [ %434, %431 ], [ %462, %459 ]
  %468 = phi ptr [ %432, %431 ], [ %460, %459 ]
  %469 = phi i32 [ %437, %431 ], [ %465, %459 ]
  %470 = getelementptr inbounds nuw i8, ptr %467, i32 1
  %471 = load i8, ptr %470, align 1, !tbaa !26
  %472 = icmp eq i8 %471, 0
  br i1 %472, label %477, label %473

473:                                              ; preds = %466
  %474 = shl nsw i32 %469, 1
  %475 = or disjoint i32 %474, 1
  %476 = icmp eq i32 %469, 1
  br label %478

477:                                              ; preds = %466
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.31) #16
  br label %1148

478:                                              ; preds = %473, %514
  %479 = phi ptr [ %468, %473 ], [ %515, %514 ]
  %480 = getelementptr inbounds nuw i8, ptr %479, i32 8
  %481 = load ptr, ptr %480, align 4, !tbaa !45
  %482 = getelementptr inbounds i8, ptr %481, i32 %469
  %483 = getelementptr inbounds nuw i8, ptr %479, i32 124
  %484 = load ptr, ptr %483, align 4, !tbaa !16
  %485 = getelementptr inbounds nuw i8, ptr %484, i32 1
  %486 = call fastcc ptr @char_search(ptr noundef nonnull %482, ptr noundef nonnull %485, i32 noundef %475) #16
  %487 = icmp eq ptr %486, null
  %488 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %487, label %491, label %489

489:                                              ; preds = %478
  %490 = getelementptr inbounds nuw i8, ptr %488, i32 8
  store ptr %486, ptr %490, align 4, !tbaa !45
  br label %514

491:                                              ; preds = %478
  br i1 %476, label %492, label %494

492:                                              ; preds = %491
  %493 = load ptr, ptr %488, align 4, !tbaa !31
  br label %498

494:                                              ; preds = %491
  %495 = getelementptr inbounds nuw i8, ptr %488, i32 4
  %496 = load ptr, ptr %495, align 4, !tbaa !50
  %497 = getelementptr inbounds i8, ptr %496, i32 -1
  br label %498

498:                                              ; preds = %494, %492
  %499 = phi ptr [ %493, %492 ], [ %497, %494 ]
  %500 = getelementptr inbounds nuw i8, ptr %488, i32 124
  %501 = load ptr, ptr %500, align 4, !tbaa !16
  %502 = getelementptr inbounds nuw i8, ptr %501, i32 1
  %503 = call fastcc ptr @char_search(ptr noundef %499, ptr noundef nonnull %502, i32 noundef %475) #16
  %504 = icmp eq ptr %503, null
  %505 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %504, label %508, label %506

506:                                              ; preds = %498
  %507 = getelementptr inbounds nuw i8, ptr %505, i32 8
  store ptr %503, ptr %507, align 4, !tbaa !45
  br label %510

508:                                              ; preds = %498
  %509 = getelementptr inbounds nuw i8, ptr %505, i32 36
  store i32 0, ptr %509, align 4, !tbaa !35
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
  %517 = load i32, ptr %516, align 4, !tbaa !35
  %518 = add nsw i32 %517, -1
  store i32 %518, ptr %516, align 4, !tbaa !35
  %519 = icmp sgt i32 %517, 1
  br i1 %519, label %478, label %1148, !llvm.loop !72

520:                                              ; preds = %63, %63
  %521 = icmp eq i32 %0, 125
  %522 = select i1 %521, i32 1, i32 -1
  %523 = load ptr, ptr @ptr_to_globals, align 4
  %524 = getelementptr inbounds nuw i8, ptr %523, i32 8
  %525 = getelementptr inbounds nuw i8, ptr %523, i32 4
  %526 = getelementptr inbounds nuw i8, ptr %523, i32 36
  %527 = load ptr, ptr %524, align 4, !tbaa !45
  br label %528

528:                                              ; preds = %553, %520
  %529 = phi ptr [ %527, %520 ], [ %554, %553 ]
  %530 = phi i32 [ 1, %520 ], [ %555, %553 ]
  br i1 %521, label %531, label %535

531:                                              ; preds = %528
  %532 = load ptr, ptr %525, align 4, !tbaa !50
  %533 = getelementptr inbounds i8, ptr %532, i32 -1
  %534 = icmp ult ptr %529, %533
  br i1 %534, label %538, label %1148

535:                                              ; preds = %528
  %536 = load ptr, ptr %523, align 4, !tbaa !31
  %537 = icmp ugt ptr %529, %536
  br i1 %537, label %538, label %1148

538:                                              ; preds = %531, %535
  %539 = load i8, ptr %529, align 1, !tbaa !26
  %540 = icmp eq i8 %539, 10
  br i1 %540, label %541, label %550

541:                                              ; preds = %538
  %542 = getelementptr inbounds i8, ptr %529, i32 %522
  %543 = load i8, ptr %542, align 1, !tbaa !26
  %544 = icmp eq i8 %543, 10
  br i1 %544, label %545, label %550

545:                                              ; preds = %541
  %546 = icmp eq i32 %530, 0
  br i1 %546, label %547, label %550

547:                                              ; preds = %545
  br i1 %521, label %548, label %556

548:                                              ; preds = %547
  %549 = getelementptr inbounds nuw i8, ptr %529, i32 1
  store ptr %549, ptr %524, align 4, !tbaa !45
  br label %556

550:                                              ; preds = %538, %541, %545
  %551 = phi i32 [ 1, %545 ], [ 0, %541 ], [ 0, %538 ]
  %552 = getelementptr inbounds i8, ptr %529, i32 %522
  store ptr %552, ptr %524, align 4, !tbaa !45
  br label %553

553:                                              ; preds = %550, %556
  %554 = phi ptr [ %552, %550 ], [ %557, %556 ]
  %555 = phi i32 [ %551, %550 ], [ 1, %556 ]
  br label %528, !llvm.loop !73

556:                                              ; preds = %547, %548
  %557 = phi ptr [ %529, %547 ], [ %549, %548 ]
  %558 = load i32, ptr %526, align 4, !tbaa !35
  %559 = add nsw i32 %558, -1
  store i32 %559, ptr %526, align 4, !tbaa !35
  %560 = icmp sgt i32 %558, 1
  br i1 %560, label %553, label %1148

561:                                              ; preds = %63, %63, %63, %63, %63, %63, %63, %63, %63, %63
  %562 = icmp eq i32 %0, 48
  %563 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %564 = getelementptr inbounds nuw i8, ptr %563, i32 36
  %565 = load i32, ptr %564, align 4, !tbaa !35
  %566 = icmp slt i32 %565, 1
  %567 = select i1 %562, i1 %566, i1 false
  br i1 %567, label %568, label %569

568:                                              ; preds = %561
  call fastcc void @dot_begin() #16
  br label %1148

569:                                              ; preds = %561
  %570 = mul nsw i32 %565, 10
  %571 = add nsw i32 %0, -48
  %572 = add nsw i32 %571, %570
  store i32 %572, ptr %564, align 4, !tbaa !35
  br label %1148

573:                                              ; preds = %63
  %574 = call fastcc ptr @get_input_line(ptr noundef nonnull @.str.57) #16
  call fastcc void @colon(ptr noundef nonnull %574) #16
  br label %1148

575:                                              ; preds = %63, %63
  %576 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %577 = load ptr, ptr %576, align 4, !tbaa !31
  %578 = getelementptr inbounds nuw i8, ptr %576, i32 8
  %579 = load ptr, ptr %578, align 4, !tbaa !45
  %580 = call fastcc i32 @count_lines(ptr noundef %577, ptr noundef %579) #16
  %581 = call fastcc i32 @find_range(ptr noundef %2, ptr noundef %3, i32 noundef %0) #16
  %582 = icmp eq i32 %581, -1
  br i1 %582, label %1148, label %583

583:                                              ; preds = %575
  %584 = load ptr, ptr %2, align 4, !tbaa !20
  %585 = load ptr, ptr %3, align 4, !tbaa !20
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
  %595 = load i8, ptr %590, align 1, !tbaa !26
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
  %604 = getelementptr inbounds nuw i8, ptr %603, i32 112
  %605 = load i32, ptr %604, align 4, !tbaa !17
  %606 = icmp slt i32 %600, %605
  br i1 %606, label %607, label %616

607:                                              ; preds = %602
  %608 = call fastcc ptr @text_hole_delete(ptr noundef nonnull %590, ptr noundef nonnull %590) #16
  %609 = add nuw nsw i32 %600, 1
  %610 = load i8, ptr %590, align 1, !tbaa !26
  br label %598, !llvm.loop !74

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
  br label %589, !llvm.loop !75

619:                                              ; preds = %589
  %620 = call fastcc ptr @find_line(i32 noundef %580) #16
  %621 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %622 = getelementptr inbounds nuw i8, ptr %621, i32 8
  store ptr %620, ptr %622, align 4, !tbaa !45
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

623:                                              ; preds = %63
  call fastcc void @dot_end() #16
  br label %624

624:                                              ; preds = %63, %623
  %625 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %626 = getelementptr inbounds nuw i8, ptr %625, i32 8
  %627 = load ptr, ptr %626, align 4, !tbaa !45
  %628 = load i8, ptr %627, align 1, !tbaa !26
  %629 = icmp eq i8 %628, 10
  br i1 %629, label %732, label %630

630:                                              ; preds = %624
  %631 = getelementptr inbounds nuw i8, ptr %627, i32 1
  store ptr %631, ptr %626, align 4, !tbaa !45
  br label %732

632:                                              ; preds = %63, %63, %63
  %633 = icmp eq i32 %0, 66
  %634 = select i1 %633, i32 -1, i32 1
  %635 = icmp eq i32 %0, 87
  %636 = load ptr, ptr @ptr_to_globals, align 4
  %637 = getelementptr inbounds nuw i8, ptr %636, i32 8
  %638 = getelementptr inbounds nuw i8, ptr %636, i32 36
  %639 = load ptr, ptr %637, align 4, !tbaa !45
  br label %640

640:                                              ; preds = %659, %632
  %641 = phi ptr [ %660, %659 ], [ %639, %632 ]
  br i1 %635, label %656, label %642

642:                                              ; preds = %640
  %643 = getelementptr inbounds i8, ptr %641, i32 %634
  %644 = load i8, ptr %643, align 1, !tbaa !26
  %645 = sext i8 %644 to i32
  %646 = icmp ne i8 %644, 32
  %647 = add nsw i32 %645, -14
  %648 = icmp ult i32 %647, -5
  %649 = select i1 %646, i1 %648, i1 false
  br i1 %649, label %653, label %650

650:                                              ; preds = %642
  %651 = call fastcc ptr @skip_thing(ptr noundef nonnull %641, i32 noundef 1, i32 noundef %634, i32 noundef 2) #16
  store ptr %651, ptr %637, align 4, !tbaa !45
  %652 = call fastcc ptr @skip_thing(ptr noundef %651, i32 noundef 2, i32 noundef %634, i32 noundef 3) #16
  store ptr %652, ptr %637, align 4, !tbaa !45
  br label %653

653:                                              ; preds = %650, %642
  %654 = phi ptr [ %652, %650 ], [ %641, %642 ]
  %655 = call fastcc ptr @skip_thing(ptr noundef %654, i32 noundef 1, i32 noundef %634, i32 noundef 1) #16
  br label %659

656:                                              ; preds = %640
  %657 = call fastcc ptr @skip_thing(ptr noundef %641, i32 noundef 1, i32 noundef 1, i32 noundef 2) #16
  store ptr %657, ptr %637, align 4, !tbaa !45
  %658 = call fastcc ptr @skip_thing(ptr noundef %657, i32 noundef 2, i32 noundef 1, i32 noundef 3) #16
  br label %659

659:                                              ; preds = %656, %653
  %660 = phi ptr [ %655, %653 ], [ %658, %656 ]
  store ptr %660, ptr %637, align 4, !tbaa !45
  %661 = load i32, ptr %638, align 4, !tbaa !35
  %662 = add nsw i32 %661, -1
  store i32 %662, ptr %638, align 4, !tbaa !35
  %663 = icmp sgt i32 %661, 1
  br i1 %663, label %640, label %1148, !llvm.loop !76

664:                                              ; preds = %63, %63
  %665 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %666 = getelementptr inbounds nuw i8, ptr %665, i32 8
  %667 = load ptr, ptr %666, align 4, !tbaa !45
  %668 = call fastcc ptr @end_line(ptr noundef %667) #16
  %669 = load i8, ptr %668, align 1, !tbaa !26
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
  store ptr %680, ptr %666, align 4, !tbaa !45
  %681 = call fastcc ptr @yank_delete(ptr noundef %667, ptr noundef nonnull %680, i32 noundef 0, i32 noundef 1) #16
  %682 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %683 = getelementptr inbounds nuw i8, ptr %682, i32 8
  store ptr %681, ptr %683, align 4, !tbaa !45
  %684 = icmp eq i32 %0, 67
  br i1 %684, label %732, label %1148

685:                                              ; preds = %63
  %686 = call fastcc i32 @readit() #16
  %687 = icmp eq i32 %686, 103
  br i1 %687, label %696, label %688

688:                                              ; preds = %685
  store i8 103, ptr %4, align 1, !tbaa !26
  %689 = icmp sgt i32 %686, -1
  %690 = trunc i32 %686 to i8
  %691 = select i1 %689, i8 %690, i8 42
  %692 = getelementptr inbounds nuw i8, ptr %4, i32 1
  store i8 %691, ptr %692, align 1, !tbaa !26
  %693 = getelementptr inbounds nuw i8, ptr %4, i32 2
  store i8 0, ptr %693, align 1, !tbaa !26
  call fastcc void @not_implemented(ptr noundef %4) #16
  %694 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %695 = getelementptr inbounds nuw i8, ptr %694, i32 128
  store i32 1, ptr %695, align 4, !tbaa !60
  br label %1148

696:                                              ; preds = %685
  %697 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %698 = getelementptr inbounds nuw i8, ptr %697, i32 36
  %699 = load i32, ptr %698, align 4, !tbaa !35
  %700 = icmp eq i32 %699, 0
  br i1 %700, label %701, label %702

701:                                              ; preds = %696
  store i32 1, ptr %698, align 4, !tbaa !35
  br label %702

702:                                              ; preds = %66, %696, %701
  %703 = phi i32 [ %69, %66 ], [ %699, %696 ], [ 1, %701 ]
  %704 = phi ptr [ %67, %66 ], [ %697, %696 ], [ %697, %701 ]
  %705 = getelementptr inbounds nuw i8, ptr %704, i32 4
  %706 = load ptr, ptr %705, align 4, !tbaa !50
  %707 = getelementptr inbounds i8, ptr %706, i32 -1
  %708 = getelementptr inbounds nuw i8, ptr %704, i32 8
  store ptr %707, ptr %708, align 4, !tbaa !45
  %709 = icmp sgt i32 %703, 0
  br i1 %709, label %710, label %712

710:                                              ; preds = %702
  %711 = call fastcc ptr @find_line(i32 noundef %703) #16
  store ptr %711, ptr %708, align 4, !tbaa !45
  br label %712

712:                                              ; preds = %710, %702
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

713:                                              ; preds = %63
  %714 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %715 = getelementptr inbounds nuw i8, ptr %714, i32 76
  %716 = load ptr, ptr %715, align 4, !tbaa !51
  %717 = getelementptr inbounds nuw i8, ptr %714, i32 8
  store ptr %716, ptr %717, align 4, !tbaa !45
  %718 = getelementptr inbounds nuw i8, ptr %714, i32 36
  %719 = load i32, ptr %718, align 4, !tbaa !35
  %720 = getelementptr inbounds nuw i8, ptr %714, i32 44
  %721 = load i32, ptr %720, align 4, !tbaa !22
  %722 = add i32 %721, -1
  %723 = call i32 @llvm.umin.i32(i32 %719, i32 %722)
  br label %724

724:                                              ; preds = %728, %713
  %725 = phi i32 [ %729, %728 ], [ %723, %713 ]
  %726 = add nsw i32 %725, -1
  store i32 %726, ptr %718, align 4, !tbaa !35
  %727 = icmp sgt i32 %725, 1
  br i1 %727, label %728, label %730

728:                                              ; preds = %724
  call fastcc void @dot_next() #16
  %729 = load i32, ptr %718, align 4, !tbaa !35
  br label %724, !llvm.loop !77

730:                                              ; preds = %724
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

731:                                              ; preds = %63
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %732

732:                                              ; preds = %986, %994, %997, %851, %799, %807, %731, %63, %63, %679, %624, %630, %16
  %733 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %734 = getelementptr inbounds nuw i8, ptr %733, i32 20
  store i32 1, ptr %734, align 4, !tbaa !34
  br label %1148

735:                                              ; preds = %72, %757
  %736 = phi ptr [ %73, %72 ], [ %758, %757 ]
  call fastcc void @dot_end() #16
  %737 = getelementptr inbounds nuw i8, ptr %736, i32 8
  %738 = load ptr, ptr %737, align 4, !tbaa !45
  %739 = getelementptr inbounds nuw i8, ptr %736, i32 4
  %740 = load ptr, ptr %739, align 4, !tbaa !50
  %741 = getelementptr inbounds i8, ptr %740, i32 -1
  %742 = icmp ult ptr %738, %741
  br i1 %742, label %743, label %757

743:                                              ; preds = %735
  call fastcc void @text_changed(ptr noundef %738, i32 noundef 1, i32 noundef 0, i32 noundef -1) #16
  %744 = load ptr, ptr %737, align 4, !tbaa !45
  %745 = getelementptr inbounds nuw i8, ptr %744, i32 1
  store ptr %745, ptr %737, align 4, !tbaa !45
  store i8 32, ptr %744, align 1, !tbaa !26
  %746 = getelementptr inbounds nuw i8, ptr %736, i32 24
  %747 = load i32, ptr %746, align 4, !tbaa !56
  %748 = add nsw i32 %747, 1
  store i32 %748, ptr %746, align 4, !tbaa !56
  br label %749

749:                                              ; preds = %754, %743
  %750 = phi ptr [ %756, %754 ], [ %736, %743 ]
  %751 = getelementptr inbounds nuw i8, ptr %750, i32 8
  %752 = load ptr, ptr %751, align 4, !tbaa !45
  %753 = load i8, ptr %752, align 1, !tbaa !26
  switch i8 %753, label %757 [
    i8 32, label %754
    i8 9, label %754
  ]

754:                                              ; preds = %749, %749
  %755 = call fastcc ptr @text_hole_delete(ptr noundef nonnull %752, ptr noundef nonnull %752) #16
  %756 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %749, !llvm.loop !78

757:                                              ; preds = %749, %735
  %758 = phi ptr [ %736, %735 ], [ %750, %749 ]
  %759 = getelementptr inbounds nuw i8, ptr %758, i32 36
  %760 = load i32, ptr %759, align 4, !tbaa !35
  %761 = add nsw i32 %760, -1
  store i32 %761, ptr %759, align 4, !tbaa !35
  %762 = icmp sgt i32 %760, 1
  br i1 %762, label %735, label %1148, !llvm.loop !79

763:                                              ; preds = %63
  %764 = call fastcc ptr @end_screen() #16
  %765 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %766 = getelementptr inbounds nuw i8, ptr %765, i32 8
  store ptr %764, ptr %766, align 4, !tbaa !45
  %767 = getelementptr inbounds nuw i8, ptr %765, i32 36
  %768 = load i32, ptr %767, align 4, !tbaa !35
  %769 = getelementptr inbounds nuw i8, ptr %765, i32 44
  %770 = load i32, ptr %769, align 4, !tbaa !22
  %771 = add i32 %770, -1
  %772 = call i32 @llvm.umin.i32(i32 %768, i32 %771)
  br label %773

773:                                              ; preds = %777, %763
  %774 = phi i32 [ %778, %777 ], [ %772, %763 ]
  %775 = add nsw i32 %774, -1
  store i32 %775, ptr %767, align 4, !tbaa !35
  %776 = icmp sgt i32 %774, 1
  br i1 %776, label %777, label %779

777:                                              ; preds = %773
  call fastcc void @dot_prev() #16
  %778 = load i32, ptr %767, align 4, !tbaa !35
  br label %773, !llvm.loop !80

779:                                              ; preds = %773
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

780:                                              ; preds = %63
  %781 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %782 = getelementptr inbounds nuw i8, ptr %781, i32 76
  %783 = load ptr, ptr %782, align 4, !tbaa !51
  %784 = getelementptr inbounds nuw i8, ptr %781, i32 8
  store ptr %783, ptr %784, align 4, !tbaa !45
  %785 = getelementptr inbounds nuw i8, ptr %781, i32 44
  %786 = load i32, ptr %785, align 4, !tbaa !22
  %787 = add i32 %786, -1
  %788 = lshr i32 %787, 1
  br label %789

789:                                              ; preds = %793, %780
  %790 = phi ptr [ %783, %780 ], [ %794, %793 ]
  %791 = phi i32 [ 0, %780 ], [ %795, %793 ]
  %792 = icmp eq i32 %791, %788
  br i1 %792, label %796, label %793

793:                                              ; preds = %789
  %794 = call fastcc ptr @next_line(ptr noundef %790) #16
  store ptr %794, ptr %784, align 4, !tbaa !45
  %795 = add nuw i32 %791, 1
  br label %789, !llvm.loop !81

796:                                              ; preds = %789
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

797:                                              ; preds = %63
  call fastcc void @dot_begin() #16
  br label %799

798:                                              ; preds = %63
  call fastcc void @dot_end() #16
  br label %799

799:                                              ; preds = %798, %797
  %800 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %801 = getelementptr inbounds nuw i8, ptr %800, i32 8
  %802 = load ptr, ptr %801, align 4, !tbaa !45
  %803 = call fastcc ptr @char_insert(ptr noundef %802, i8 noundef signext 10) #16
  %804 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %805 = getelementptr inbounds nuw i8, ptr %804, i32 8
  store ptr %803, ptr %805, align 4, !tbaa !45
  %806 = icmp eq i32 %0, 79
  br i1 %806, label %807, label %732

807:                                              ; preds = %799
  call fastcc void @dot_prev() #16
  br label %732

808:                                              ; preds = %70, %48
  %809 = phi ptr [ %71, %70 ], [ %13, %48 ]
  %810 = getelementptr inbounds nuw i8, ptr %809, i32 20
  store i32 2, ptr %810, align 4, !tbaa !34
  %811 = getelementptr inbounds nuw i8, ptr %809, i32 8
  %812 = load ptr, ptr %811, align 4, !tbaa !45
  %813 = getelementptr inbounds nuw i8, ptr %809, i32 40
  store ptr %812, ptr %813, align 4, !tbaa !82
  br label %1148

814:                                              ; preds = %63
  %815 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %816 = getelementptr inbounds nuw i8, ptr %815, i32 8
  %817 = load ptr, ptr %816, align 4, !tbaa !45
  %818 = getelementptr inbounds nuw i8, ptr %815, i32 4
  %819 = load ptr, ptr %818, align 4, !tbaa !50
  %820 = getelementptr inbounds i8, ptr %819, i32 -1
  %821 = icmp ult ptr %817, %820
  br i1 %821, label %822, label %1148

822:                                              ; preds = %814
  %823 = call fastcc ptr @yank_delete(ptr noundef %817, ptr noundef %817, i32 noundef 0, i32 noundef 1) #16
  %824 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %825 = getelementptr inbounds nuw i8, ptr %824, i32 8
  store ptr %823, ptr %825, align 4, !tbaa !45
  br label %1148

826:                                              ; preds = %63, %63, %63
  %827 = icmp eq i32 %0, 88
  %828 = sext i1 %827 to i32
  %829 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %830

830:                                              ; preds = %845, %826
  %831 = phi ptr [ %846, %845 ], [ %829, %826 ]
  %832 = getelementptr inbounds nuw i8, ptr %831, i32 8
  %833 = load ptr, ptr %832, align 4, !tbaa !45
  %834 = getelementptr inbounds i8, ptr %833, i32 %828
  %835 = load i8, ptr %834, align 1, !tbaa !26
  %836 = icmp eq i8 %835, 10
  br i1 %836, label %845, label %837

837:                                              ; preds = %830
  br i1 %827, label %838, label %840

838:                                              ; preds = %837
  %839 = getelementptr inbounds i8, ptr %833, i32 -1
  store ptr %839, ptr %832, align 4, !tbaa !45
  br label %840

840:                                              ; preds = %838, %837
  %841 = phi ptr [ %839, %838 ], [ %833, %837 ]
  %842 = call fastcc ptr @yank_delete(ptr noundef nonnull %841, ptr noundef nonnull %841, i32 noundef 0, i32 noundef 1) #16
  %843 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %844 = getelementptr inbounds nuw i8, ptr %843, i32 8
  store ptr %842, ptr %844, align 4, !tbaa !45
  br label %845

845:                                              ; preds = %830, %840
  %846 = phi ptr [ %831, %830 ], [ %843, %840 ]
  %847 = getelementptr inbounds nuw i8, ptr %846, i32 36
  %848 = load i32, ptr %847, align 4, !tbaa !35
  %849 = add nsw i32 %848, -1
  store i32 %849, ptr %847, align 4, !tbaa !35
  %850 = icmp sgt i32 %848, 1
  br i1 %850, label %830, label %851, !llvm.loop !83

851:                                              ; preds = %845
  %852 = icmp eq i32 %0, 115
  br i1 %852, label %732, label %1148

853:                                              ; preds = %63
  %854 = call fastcc i32 @readit() #16
  switch i32 %854, label %860 [
    i32 81, label %855
    i32 90, label %861
  ]

855:                                              ; preds = %853
  %856 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %857 = getelementptr inbounds nuw i8, ptr %856, i32 16
  store i32 0, ptr %857, align 4, !tbaa !21
  %858 = getelementptr inbounds nuw i8, ptr %856, i32 32
  %859 = load i32, ptr %858, align 4, !tbaa !19
  store i32 %859, ptr @optind, align 4, !tbaa !18
  br label %1148

860:                                              ; preds = %853
  call fastcc void @indicate_error() #16
  br label %1148

861:                                              ; preds = %853
  %862 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %863 = getelementptr inbounds nuw i8, ptr %862, i32 24
  %864 = load i32, ptr %863, align 4, !tbaa !56
  %865 = icmp eq i32 %864, 0
  br i1 %865, label %891, label %866

866:                                              ; preds = %861
  %867 = getelementptr inbounds nuw i8, ptr %862, i32 72
  %868 = load ptr, ptr %867, align 4, !tbaa !84
  %869 = load ptr, ptr %862, align 4, !tbaa !31
  %870 = getelementptr inbounds nuw i8, ptr %862, i32 4
  %871 = load ptr, ptr %870, align 4, !tbaa !50
  %872 = getelementptr inbounds i8, ptr %871, i32 -1
  %873 = call fastcc i32 @file_write(ptr noundef %868, ptr noundef %869, ptr noundef nonnull %872) #16
  %874 = icmp slt i32 %873, 0
  br i1 %874, label %875, label %878

875:                                              ; preds = %866
  %876 = icmp eq i32 %873, -1
  br i1 %876, label %877, label %893

877:                                              ; preds = %875
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.58) #16
  br label %893

878:                                              ; preds = %866
  %879 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %880 = getelementptr inbounds nuw i8, ptr %879, i32 4
  %881 = load ptr, ptr %880, align 4, !tbaa !50
  %882 = getelementptr inbounds i8, ptr %881, i32 -1
  %883 = load ptr, ptr %879, align 4, !tbaa !31
  %884 = ptrtoint ptr %882 to i32
  %885 = ptrtoint ptr %883 to i32
  %886 = sub i32 %884, %885
  %887 = add i32 %886, 1
  %888 = icmp eq i32 %873, %887
  br i1 %888, label %889, label %893

889:                                              ; preds = %878
  %890 = getelementptr inbounds nuw i8, ptr %879, i32 16
  store i32 0, ptr %890, align 4, !tbaa !21
  br label %893

891:                                              ; preds = %861
  %892 = getelementptr inbounds nuw i8, ptr %862, i32 16
  store i32 0, ptr %892, align 4, !tbaa !21
  br label %893

893:                                              ; preds = %877, %875, %889, %878, %891
  %894 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %895 = getelementptr inbounds nuw i8, ptr %894, i32 32
  %896 = load i32, ptr %895, align 4, !tbaa !19
  %897 = load i32, ptr @optind, align 4, !tbaa !18
  %898 = xor i32 %897, -1
  %899 = add i32 %896, %898
  %900 = getelementptr inbounds nuw i8, ptr %894, i32 16
  %901 = load i32, ptr %900, align 4, !tbaa !21
  %902 = icmp eq i32 %901, 0
  %903 = icmp sgt i32 %899, 0
  %904 = select i1 %902, i1 %903, i1 false
  br i1 %904, label %905, label %1148

905:                                              ; preds = %893
  store i32 1, ptr %900, align 4, !tbaa !21
  %906 = getelementptr inbounds nuw i8, ptr %894, i32 24
  store i32 0, ptr %906, align 4, !tbaa !56
  %907 = getelementptr inbounds nuw i8, ptr %894, i32 28
  store i32 -1, ptr %907, align 4, !tbaa !8
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.25, i32 noundef %899) #16
  br label %1148

908:                                              ; preds = %63
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

909:                                              ; preds = %63, %63
  %910 = icmp eq i32 %0, 98
  %911 = select i1 %910, i32 -1, i32 1
  %912 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %913 = getelementptr inbounds nuw i8, ptr %912, i32 8
  %914 = load ptr, ptr %912, align 4, !tbaa !31
  %915 = load ptr, ptr %913, align 4, !tbaa !45
  %916 = getelementptr inbounds nuw i8, ptr %912, i32 4
  %917 = icmp eq i32 %0, 101
  %918 = select i1 %917, i32 2, i32 1
  %919 = getelementptr inbounds nuw i8, ptr %912, i32 36
  br label %920

920:                                              ; preds = %957, %909
  %921 = phi ptr [ %958, %957 ], [ %915, %909 ]
  %922 = getelementptr inbounds i8, ptr %921, i32 %911
  %923 = icmp ult ptr %922, %914
  br i1 %923, label %1148, label %924

924:                                              ; preds = %920
  %925 = load ptr, ptr %916, align 4, !tbaa !50
  %926 = getelementptr inbounds i8, ptr %925, i32 -1
  %927 = icmp ugt ptr %922, %926
  br i1 %927, label %1148, label %928

928:                                              ; preds = %924
  store ptr %922, ptr %913, align 4, !tbaa !45
  %929 = load i8, ptr %922, align 1, !tbaa !26
  %930 = sext i8 %929 to i32
  %931 = icmp ne i8 %929, 32
  %932 = add nsw i32 %930, -14
  %933 = icmp ult i32 %932, -5
  %934 = select i1 %931, i1 %933, i1 false
  br i1 %934, label %939, label %935

935:                                              ; preds = %928
  %936 = call fastcc ptr @skip_thing(ptr noundef nonnull %922, i32 noundef %918, i32 noundef %911, i32 noundef 3) #16
  store ptr %936, ptr %913, align 4, !tbaa !45
  %937 = load i8, ptr %936, align 1, !tbaa !26
  %938 = sext i8 %937 to i32
  br label %939

939:                                              ; preds = %935, %928
  %940 = phi i32 [ %938, %935 ], [ %930, %928 ]
  %941 = phi i8 [ %937, %935 ], [ %929, %928 ]
  %942 = phi ptr [ %936, %935 ], [ %922, %928 ]
  %943 = and i32 %940, -33
  %944 = add nsw i32 %943, -91
  %945 = icmp ult i32 %944, -26
  %946 = add nsw i32 %940, -58
  %947 = icmp ult i32 %946, -10
  %948 = select i1 %945, i1 %947, i1 false
  br i1 %948, label %949, label %954

949:                                              ; preds = %939
  %950 = icmp eq i8 %941, 95
  br i1 %950, label %954, label %951

951:                                              ; preds = %949
  %952 = call fastcc i32 @bb_ispunct(i32 noundef %940) #16
  %953 = icmp eq i32 %952, 0
  br i1 %953, label %957, label %954

954:                                              ; preds = %951, %939, %949
  %955 = phi i32 [ 5, %949 ], [ 5, %939 ], [ 4, %951 ]
  %956 = call fastcc ptr @skip_thing(ptr noundef nonnull %942, i32 noundef 1, i32 noundef %911, i32 noundef %955) #16
  store ptr %956, ptr %913, align 4, !tbaa !45
  br label %957

957:                                              ; preds = %954, %951
  %958 = phi ptr [ %942, %951 ], [ %956, %954 ]
  %959 = load i32, ptr %919, align 4, !tbaa !35
  %960 = add nsw i32 %959, -1
  store i32 %960, ptr %919, align 4, !tbaa !35
  %961 = icmp sgt i32 %959, 1
  br i1 %961, label %920, label %1148, !llvm.loop !85

962:                                              ; preds = %63, %63, %63, %63
  %963 = add nsw i32 %0, -89
  %964 = and i32 %963, -33
  %965 = icmp ne i32 %964, 0
  %966 = zext i1 %965 to i32
  %967 = call fastcc i32 @find_range(ptr noundef %2, ptr noundef %3, i32 noundef %0) #16
  %968 = icmp eq i32 %967, -1
  br i1 %968, label %1148, label %969

969:                                              ; preds = %962
  %970 = icmp eq i32 %967, 1
  %971 = load ptr, ptr %2, align 4, !tbaa !20
  br i1 %970, label %974, label %972

972:                                              ; preds = %969
  %973 = load ptr, ptr %3, align 4, !tbaa !20
  br label %978

974:                                              ; preds = %969
  %975 = call fastcc ptr @begin_line(ptr noundef %971) #16
  %976 = load ptr, ptr %3, align 4, !tbaa !20
  %977 = call fastcc ptr @end_line(ptr noundef %976) #16
  br label %978

978:                                              ; preds = %972, %974
  %979 = phi ptr [ %977, %974 ], [ %973, %972 ]
  %980 = phi ptr [ %975, %974 ], [ %971, %972 ]
  %981 = phi ptr [ %971, %974 ], [ undef, %972 ]
  %982 = call fastcc ptr @yank_delete(ptr noundef %980, ptr noundef %979, i32 noundef %967, i32 noundef %966) #16
  %983 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %984 = getelementptr inbounds nuw i8, ptr %983, i32 8
  store ptr %982, ptr %984, align 4, !tbaa !45
  br i1 %970, label %985, label %997

985:                                              ; preds = %978
  switch i32 %0, label %996 [
    i32 99, label %986
    i32 100, label %995
  ]

986:                                              ; preds = %985
  %987 = call fastcc ptr @char_insert(ptr noundef %982, i8 noundef signext 10) #16
  %988 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %989 = getelementptr inbounds nuw i8, ptr %988, i32 8
  store ptr %987, ptr %989, align 4, !tbaa !45
  %990 = getelementptr inbounds nuw i8, ptr %988, i32 4
  %991 = load ptr, ptr %990, align 4, !tbaa !50
  %992 = getelementptr inbounds i8, ptr %991, i32 -1
  %993 = icmp eq ptr %987, %992
  br i1 %993, label %732, label %994

994:                                              ; preds = %986
  call fastcc void @dot_prev() #16
  br label %732

995:                                              ; preds = %985
  call fastcc void @dot_begin() #16
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

996:                                              ; preds = %985
  store ptr %981, ptr %984, align 4, !tbaa !45
  br label %997

997:                                              ; preds = %996, %978
  %998 = icmp eq i32 %0, 99
  br i1 %998, label %732, label %1148

999:                                              ; preds = %63, %63, %63
  %1000 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1001 = getelementptr inbounds nuw i8, ptr %1000, i32 8
  %1002 = load ptr, ptr %1001, align 4, !tbaa !45
  %1003 = getelementptr inbounds nuw i8, ptr %1000, i32 36
  br label %1004

1004:                                             ; preds = %1010, %999
  %1005 = phi ptr [ %1006, %1010 ], [ %1002, %999 ]
  %1006 = call fastcc ptr @prev_line(ptr noundef %1005) #16
  %1007 = call fastcc ptr @begin_line(ptr noundef %1005) #16
  %1008 = icmp eq ptr %1006, %1007
  br i1 %1008, label %1009, label %1010

1009:                                             ; preds = %1004
  call fastcc void @indicate_error() #16
  br label %1148

1010:                                             ; preds = %1004
  %1011 = load i32, ptr %1003, align 4, !tbaa !35
  %1012 = add nsw i32 %1011, -1
  store i32 %1012, ptr %1003, align 4, !tbaa !35
  %1013 = icmp sgt i32 %1011, 1
  br i1 %1013, label %1004, label %1014, !llvm.loop !86

1014:                                             ; preds = %1010
  store ptr %1006, ptr %1001, align 4, !tbaa !45
  %1015 = icmp eq i32 %0, 45
  br i1 %1015, label %1016, label %1017

1016:                                             ; preds = %1014
  call fastcc void @dot_skip_over_ws() #16
  br label %1148

1017:                                             ; preds = %1014
  %1018 = getelementptr inbounds nuw i8, ptr %1000, i32 408
  %1019 = load i32, ptr %1018, align 4, !tbaa !63
  %1020 = icmp eq i32 %1019, -1
  br i1 %1020, label %1021, label %1023

1021:                                             ; preds = %1017
  %1022 = call fastcc ptr @end_line(ptr noundef %1006) #16
  br label %1025

1023:                                             ; preds = %1017
  %1024 = call fastcc ptr @move_to_col(ptr noundef %1006, i32 noundef %1019) #16
  br label %1025

1025:                                             ; preds = %1023, %1021
  %1026 = phi ptr [ %1022, %1021 ], [ %1024, %1023 ]
  store ptr %1026, ptr %1001, align 4, !tbaa !45
  %1027 = getelementptr inbounds nuw i8, ptr %1000, i32 412
  store i32 1, ptr %1027, align 4, !tbaa !59
  br label %1148

1028:                                             ; preds = %63
  %1029 = call fastcc i32 @readit() #16
  %1030 = icmp eq i32 %1029, 27
  br i1 %1030, label %1148, label %1031

1031:                                             ; preds = %1028
  %1032 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1033 = getelementptr inbounds nuw i8, ptr %1032, i32 8
  %1034 = load ptr, ptr %1033, align 4, !tbaa !45
  %1035 = call fastcc ptr @end_line(ptr noundef %1034) #16
  %1036 = ptrtoint ptr %1035 to i32
  %1037 = ptrtoint ptr %1034 to i32
  %1038 = sub i32 %1036, %1037
  %1039 = getelementptr inbounds nuw i8, ptr %1032, i32 36
  %1040 = load i32, ptr %1039, align 4, !tbaa !35
  %1041 = call i32 @llvm.umax.i32(i32 %1040, i32 1)
  %1042 = icmp slt i32 %1038, %1041
  br i1 %1042, label %1045, label %1043

1043:                                             ; preds = %1031
  %1044 = trunc i32 %1029 to i8
  br label %1046

1045:                                             ; preds = %1031
  call fastcc void @indicate_error() #16
  br label %1148

1046:                                             ; preds = %1043, %1046
  %1047 = phi ptr [ %1034, %1043 ], [ %1051, %1046 ]
  %1048 = call fastcc ptr @text_hole_delete(ptr noundef %1047, ptr noundef %1047) #16
  %1049 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1050 = getelementptr inbounds nuw i8, ptr %1049, i32 8
  store ptr %1048, ptr %1050, align 4, !tbaa !45
  %1051 = call fastcc ptr @char_insert(ptr noundef %1048, i8 noundef signext %1044) #16
  %1052 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1053 = getelementptr inbounds nuw i8, ptr %1052, i32 8
  store ptr %1051, ptr %1053, align 4, !tbaa !45
  %1054 = getelementptr inbounds nuw i8, ptr %1052, i32 36
  %1055 = load i32, ptr %1054, align 4, !tbaa !35
  %1056 = add nsw i32 %1055, -1
  store i32 %1056, ptr %1054, align 4, !tbaa !35
  %1057 = icmp sgt i32 %1055, 1
  br i1 %1057, label %1046, label %1058, !llvm.loop !87

1058:                                             ; preds = %1046
  call fastcc void @dot_left() #16
  br label %1148

1059:                                             ; preds = %79, %1094
  %1060 = phi ptr [ %82, %79 ], [ %1095, %1094 ]
  %1061 = load i8, ptr %1060, align 1, !tbaa !26
  %1062 = sext i8 %1061 to i32
  %1063 = and i32 %1062, -33
  %1064 = add nsw i32 %1063, -91
  %1065 = icmp ult i32 %1064, -26
  %1066 = add nsw i32 %1062, -58
  %1067 = icmp ult i32 %1066, -10
  %1068 = select i1 %1065, i1 %1067, i1 false
  br i1 %1068, label %1069, label %1074

1069:                                             ; preds = %1059
  %1070 = icmp eq i8 %1061, 95
  br i1 %1070, label %1074, label %1071

1071:                                             ; preds = %1069
  %1072 = call fastcc i32 @bb_ispunct(i32 noundef %1062) #16
  %1073 = icmp eq i32 %1072, 0
  br i1 %1073, label %1077, label %1074

1074:                                             ; preds = %1071, %1059, %1069
  %1075 = phi i32 [ 5, %1069 ], [ 5, %1059 ], [ 4, %1071 ]
  %1076 = call fastcc ptr @skip_thing(ptr noundef nonnull %1060, i32 noundef 1, i32 noundef 1, i32 noundef %1075) #16
  store ptr %1076, ptr %81, align 4, !tbaa !45
  br label %1077

1077:                                             ; preds = %1074, %1071
  %1078 = phi ptr [ %1060, %1071 ], [ %1076, %1074 ]
  %1079 = load ptr, ptr %83, align 4, !tbaa !50
  %1080 = getelementptr inbounds i8, ptr %1079, i32 -1
  %1081 = icmp ult ptr %1078, %1080
  br i1 %1081, label %1082, label %1084

1082:                                             ; preds = %1077
  %1083 = getelementptr inbounds nuw i8, ptr %1078, i32 1
  store ptr %1083, ptr %81, align 4, !tbaa !45
  br label %1084

1084:                                             ; preds = %1082, %1077
  %1085 = phi ptr [ %1083, %1082 ], [ %1078, %1077 ]
  %1086 = load i8, ptr %1085, align 1, !tbaa !26
  %1087 = sext i8 %1086 to i32
  %1088 = icmp ne i8 %1086, 32
  %1089 = add nsw i32 %1087, -14
  %1090 = icmp ult i32 %1089, -5
  %1091 = select i1 %1088, i1 %1090, i1 false
  br i1 %1091, label %1094, label %1092

1092:                                             ; preds = %1084
  %1093 = call fastcc ptr @skip_thing(ptr noundef nonnull %1085, i32 noundef 2, i32 noundef 1, i32 noundef 3) #16
  store ptr %1093, ptr %81, align 4, !tbaa !45
  br label %1094

1094:                                             ; preds = %1084, %1092
  %1095 = phi ptr [ %1085, %1084 ], [ %1093, %1092 ]
  %1096 = load i32, ptr %84, align 4, !tbaa !35
  %1097 = add nsw i32 %1096, -1
  store i32 %1097, ptr %84, align 4, !tbaa !35
  %1098 = icmp sgt i32 %1096, 1
  br i1 %1098, label %1059, label %1148, !llvm.loop !88

1099:                                             ; preds = %63
  %1100 = call fastcc i32 @readit() #16
  %1101 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  switch i32 %1100, label %1111 [
    i32 46, label %1102
    i32 45, label %1107
  ]

1102:                                             ; preds = %1099
  %1103 = getelementptr inbounds nuw i8, ptr %1101, i32 44
  %1104 = load i32, ptr %1103, align 4, !tbaa !22
  %1105 = add i32 %1104, -2
  %1106 = lshr i32 %1105, 1
  br label %1111

1107:                                             ; preds = %1099
  %1108 = getelementptr inbounds nuw i8, ptr %1101, i32 44
  %1109 = load i32, ptr %1108, align 4, !tbaa !22
  %1110 = add i32 %1109, -2
  br label %1111

1111:                                             ; preds = %1099, %1102, %1107
  %1112 = phi i32 [ %1110, %1107 ], [ %1106, %1102 ], [ 0, %1099 ]
  %1113 = getelementptr inbounds nuw i8, ptr %1101, i32 8
  %1114 = load ptr, ptr %1113, align 4, !tbaa !45
  %1115 = call fastcc ptr @begin_line(ptr noundef %1114) #16
  %1116 = getelementptr inbounds nuw i8, ptr %1101, i32 76
  store ptr %1115, ptr %1116, align 4, !tbaa !51
  call fastcc void @dot_scroll(i32 noundef %1112, i32 noundef -1) #16
  br label %1148

1117:                                             ; preds = %63
  %1118 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1119 = getelementptr inbounds nuw i8, ptr %1118, i32 8
  %1120 = load ptr, ptr %1119, align 4, !tbaa !45
  %1121 = getelementptr inbounds nuw i8, ptr %1118, i32 36
  %1122 = load i32, ptr %1121, align 4, !tbaa !35
  %1123 = add nsw i32 %1122, -1
  %1124 = call fastcc ptr @move_to_col(ptr noundef %1120, i32 noundef %1123) #16
  store ptr %1124, ptr %1119, align 4, !tbaa !45
  br label %1148

1125:                                             ; preds = %74, %1143
  %1126 = load ptr, ptr %76, align 4, !tbaa !45
  %1127 = load i8, ptr %1126, align 1, !tbaa !26
  %1128 = sext i8 %1127 to i32
  %1129 = add nsw i32 %1128, -123
  %1130 = icmp ult i32 %1129, -26
  br i1 %1130, label %1133, label %1131

1131:                                             ; preds = %1125
  %1132 = add i8 %1127, -32
  br label %1138

1133:                                             ; preds = %1125
  %1134 = add nsw i32 %1128, -91
  %1135 = icmp ult i32 %1134, -26
  br i1 %1135, label %1143, label %1136

1136:                                             ; preds = %1133
  %1137 = or i8 %1127, 32
  br label %1138

1138:                                             ; preds = %1131, %1136
  %1139 = phi i8 [ %1137, %1136 ], [ %1132, %1131 ]
  store i8 %1139, ptr %1126, align 1, !tbaa !26
  %1140 = load ptr, ptr %76, align 4, !tbaa !45
  call fastcc void @text_changed(ptr noundef %1140, i32 noundef 1, i32 noundef 0, i32 noundef 0) #16
  %1141 = load i32, ptr %78, align 4, !tbaa !56
  %1142 = add nsw i32 %1141, 1
  store i32 %1142, ptr %78, align 4, !tbaa !56
  br label %1143

1143:                                             ; preds = %1138, %1133
  call fastcc void @dot_right() #16
  %1144 = load i32, ptr %77, align 4, !tbaa !35
  %1145 = add nsw i32 %1144, -1
  store i32 %1145, ptr %77, align 4, !tbaa !35
  %1146 = icmp sgt i32 %1144, 1
  br i1 %1146, label %1125, label %1148, !llvm.loop !89

1147:                                             ; preds = %63
  call fastcc void @dot_begin() #16
  br label %1148

1148:                                             ; preds = %1143, %1094, %920, %924, %957, %757, %659, %556, %535, %531, %514, %165, %111, %995, %430, %429, %428, %419, %392, %85, %88, %93, %99, %100, %105, %143, %144, %150, %158, %238, %285, %318, %477, %573, %619, %688, %712, %730, %732, %779, %796, %808, %855, %860, %908, %1111, %1117, %63, %1147, %140, %131, %177, %174, %214, %217, %194, %196, %229, %223, %294, %289, %379, %376, %438, %569, %568, %679, %822, %814, %851, %905, %893, %997, %962, %575, %1045, %1025, %1016, %1058, %1028, %52, %56, %26, %42, %1009, %125
  %1149 = phi ptr [ %7, %732 ], [ %7, %808 ], [ %7, %56 ], [ %7, %52 ], [ %7, %85 ], [ %7, %63 ], [ %7, %88 ], [ %7, %93 ], [ %7, %99 ], [ %7, %100 ], [ %7, %105 ], [ %7, %125 ], [ %7, %131 ], [ %7, %140 ], [ %7, %143 ], [ %7, %144 ], [ %7, %150 ], [ %7, %158 ], [ %7, %174 ], [ %7, %177 ], [ %7, %194 ], [ %7, %196 ], [ %216, %214 ], [ %7, %217 ], [ %7, %223 ], [ %7, %229 ], [ %7, %238 ], [ %7, %285 ], [ %7, %294 ], [ %7, %289 ], [ %7, %318 ], [ %7, %379 ], [ %7, %376 ], [ %7, %477 ], [ %7, %438 ], [ %7, %568 ], [ %7, %569 ], [ %7, %573 ], [ %7, %575 ], [ %7, %619 ], [ %7, %679 ], [ %7, %688 ], [ %7, %712 ], [ %7, %730 ], [ %7, %779 ], [ %7, %796 ], [ %7, %822 ], [ %7, %814 ], [ %7, %851 ], [ %7, %855 ], [ %7, %860 ], [ %7, %905 ], [ %7, %893 ], [ %7, %908 ], [ %7, %962 ], [ %7, %997 ], [ %7, %1009 ], [ %7, %1016 ], [ %7, %1025 ], [ %7, %1045 ], [ %7, %1058 ], [ %7, %1028 ], [ %7, %1111 ], [ %7, %1117 ], [ %7, %1147 ], [ %7, %42 ], [ %7, %26 ], [ %7, %392 ], [ %7, %419 ], [ %7, %428 ], [ %7, %429 ], [ %7, %430 ], [ %7, %995 ], [ %7, %111 ], [ %7, %165 ], [ %7, %514 ], [ %7, %531 ], [ %7, %535 ], [ %7, %556 ], [ %7, %659 ], [ %7, %757 ], [ %7, %957 ], [ %7, %924 ], [ %7, %920 ], [ %7, %1094 ], [ %7, %1143 ]
  %1150 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1151 = getelementptr inbounds nuw i8, ptr %1150, i32 4
  %1152 = load ptr, ptr %1151, align 4, !tbaa !50
  %1153 = load ptr, ptr %1150, align 4, !tbaa !31
  %1154 = icmp eq ptr %1152, %1153
  br i1 %1154, label %1158, label %1155

1155:                                             ; preds = %1148
  %1156 = getelementptr inbounds nuw i8, ptr %1150, i32 8
  %1157 = load ptr, ptr %1156, align 4, !tbaa !45
  br label %1165

1158:                                             ; preds = %1148
  %1159 = call fastcc ptr @char_insert(ptr noundef %1153, i8 noundef signext 10) #16
  %1160 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1161 = load ptr, ptr %1160, align 4, !tbaa !31
  %1162 = getelementptr inbounds nuw i8, ptr %1160, i32 8
  store ptr %1161, ptr %1162, align 4, !tbaa !45
  %1163 = getelementptr inbounds nuw i8, ptr %1160, i32 4
  %1164 = load ptr, ptr %1163, align 4, !tbaa !50
  br label %1165

1165:                                             ; preds = %1155, %1158
  %1166 = phi ptr [ %1164, %1158 ], [ %1152, %1155 ]
  %1167 = phi ptr [ %1161, %1158 ], [ %1157, %1155 ]
  %1168 = phi ptr [ %1160, %1158 ], [ %1150, %1155 ]
  %1169 = icmp eq ptr %1167, %1166
  br i1 %1169, label %1174, label %1170

1170:                                             ; preds = %1165
  %1171 = call fastcc ptr @bound_dot(ptr noundef %1167) #16
  %1172 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %1173 = getelementptr inbounds nuw i8, ptr %1172, i32 8
  store ptr %1171, ptr %1173, align 4, !tbaa !45
  br label %1174

1174:                                             ; preds = %1170, %1165
  %1175 = phi ptr [ %1171, %1170 ], [ %1166, %1165 ]
  %1176 = phi ptr [ %1172, %1170 ], [ %1168, %1165 ]
  %1177 = icmp eq ptr %1175, %1149
  br i1 %1177, label %1189, label %1178

1178:                                             ; preds = %1174
  %1179 = trunc i32 %0 to i8
  %1180 = call ptr @strchr(ptr noundef nonnull @.str.66, i8 noundef signext %1179) #17
  %1181 = icmp eq ptr %1180, null
  %1182 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %1181, label %1189, label %1183

1183:                                             ; preds = %1178
  %1184 = getelementptr inbounds nuw i8, ptr %1182, i32 396
  %1185 = load ptr, ptr %1184, align 4, !tbaa !20
  %1186 = getelementptr inbounds nuw i8, ptr %1182, i32 400
  store ptr %1185, ptr %1186, align 4, !tbaa !20
  %1187 = getelementptr inbounds nuw i8, ptr %1182, i32 8
  %1188 = load ptr, ptr %1187, align 4, !tbaa !45
  store ptr %1188, ptr %1184, align 4, !tbaa !20
  br label %1189

1189:                                             ; preds = %1183, %1178, %1174
  %1190 = phi ptr [ %1182, %1183 ], [ %1182, %1178 ], [ %1176, %1174 ]
  %1191 = add i32 %0, -58
  %1192 = icmp ult i32 %1191, -10
  br i1 %1192, label %1193, label %1195

1193:                                             ; preds = %1189
  %1194 = getelementptr inbounds nuw i8, ptr %1190, i32 36
  store i32 0, ptr %1194, align 4, !tbaa !35
  br label %1195

1195:                                             ; preds = %1193, %1189
  %1196 = getelementptr inbounds nuw i8, ptr %1190, i32 8
  %1197 = load ptr, ptr %1196, align 4, !tbaa !45
  %1198 = call fastcc ptr @begin_line(ptr noundef %1197) #16
  %1199 = ptrtoint ptr %1197 to i32
  %1200 = ptrtoint ptr %1198 to i32
  %1201 = sub i32 %1199, %1200
  %1202 = load i8, ptr %1197, align 1, !tbaa !26
  %1203 = icmp eq i8 %1202, 10
  %1204 = icmp sgt i32 %1201, 0
  %1205 = select i1 %1203, i1 %1204, i1 false
  br i1 %1205, label %1206, label %1212

1206:                                             ; preds = %1195
  %1207 = getelementptr inbounds nuw i8, ptr %1190, i32 20
  %1208 = load i32, ptr %1207, align 4, !tbaa !34
  %1209 = icmp eq i32 %1208, 0
  br i1 %1209, label %1210, label %1212

1210:                                             ; preds = %1206
  %1211 = getelementptr inbounds i8, ptr %1197, i32 -1
  store ptr %1211, ptr %1196, align 4, !tbaa !45
  br label %1212

1212:                                             ; preds = %1210, %1206, %1195
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %4) #19
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #19
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @refresh(i32 noundef range(i32 0, 2) %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %4 = load ptr, ptr %3, align 4, !tbaa !45
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 52
  %6 = getelementptr inbounds nuw i8, ptr %2, i32 56
  %7 = tail call fastcc ptr @begin_line(ptr noundef %4) #16
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 76
  %9 = load ptr, ptr %8, align 4, !tbaa !51
  %10 = icmp ult ptr %7, %9
  br i1 %10, label %11, label %29

11:                                               ; preds = %1
  %12 = tail call fastcc i32 @count_lines(ptr noundef %7, ptr noundef nonnull %9) #16
  %13 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %14 = load i32, ptr %13, align 4, !tbaa !22
  %15 = add i32 %14, -1
  %16 = lshr i32 %15, 1
  br label %17

17:                                               ; preds = %36, %11
  %18 = phi i32 [ %41, %36 ], [ %16, %11 ]
  %19 = phi i32 [ %40, %36 ], [ %15, %11 ]
  %20 = phi i32 [ %37, %36 ], [ %12, %11 ]
  store ptr %7, ptr %8, align 4, !tbaa !51
  %21 = icmp ugt i32 %20, %18
  br i1 %21, label %22, label %55

22:                                               ; preds = %17, %26
  %23 = phi ptr [ %27, %26 ], [ %7, %17 ]
  %24 = phi i32 [ %28, %26 ], [ 0, %17 ]
  %25 = icmp eq i32 %24, %18
  br i1 %25, label %55, label %26

26:                                               ; preds = %22
  %27 = tail call fastcc ptr @prev_line(ptr noundef %23) #16
  store ptr %27, ptr %8, align 4, !tbaa !51
  %28 = add nuw i32 %24, 1
  br label %22, !llvm.loop !90

29:                                               ; preds = %1
  %30 = tail call fastcc ptr @end_screen() #16
  %31 = icmp ugt ptr %7, %30
  br i1 %31, label %36, label %32

32:                                               ; preds = %29
  %33 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %34 = load i32, ptr %33, align 4, !tbaa !22
  %35 = add i32 %34, -1
  br label %55

36:                                               ; preds = %29
  %37 = tail call fastcc i32 @count_lines(ptr noundef %30, ptr noundef nonnull %7) #16
  %38 = getelementptr inbounds nuw i8, ptr %2, i32 44
  %39 = load i32, ptr %38, align 4, !tbaa !22
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
  store ptr %51, ptr %8, align 4, !tbaa !51
  %52 = tail call fastcc ptr @next_line(ptr noundef %48) #16
  %53 = tail call fastcc ptr @end_line(ptr noundef %52) #16
  %54 = add nuw nsw i32 %47, 1
  br label %45, !llvm.loop !91

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
  br label %58, !llvm.loop !92

67:                                               ; preds = %58
  %68 = getelementptr inbounds nuw i8, ptr %2, i32 20
  %69 = getelementptr inbounds i8, ptr %4, i32 -1
  br label %70

70:                                               ; preds = %86, %67
  %71 = phi ptr [ %59, %67 ], [ %87, %86 ]
  %72 = phi i32 [ 0, %67 ], [ %76, %86 ]
  %73 = load i8, ptr %71, align 1, !tbaa !26
  %74 = icmp eq i8 %73, 10
  br i1 %74, label %91, label %75

75:                                               ; preds = %70
  %76 = tail call fastcc i32 @next_column(i8 noundef signext %73, i32 noundef %72) #16
  %77 = load i32, ptr %68, align 4, !tbaa !34
  %78 = icmp ne i32 %77, 0
  %79 = icmp eq ptr %71, %69
  %80 = select i1 %78, i1 %79, i1 false
  br i1 %80, label %81, label %84

81:                                               ; preds = %75
  %82 = load i8, ptr %4, align 1, !tbaa !26
  %83 = icmp eq i8 %82, 9
  br i1 %83, label %91, label %84

84:                                               ; preds = %81, %75
  %85 = icmp ult ptr %71, %4
  br i1 %85, label %86, label %89

86:                                               ; preds = %84
  %87 = getelementptr inbounds nuw i8, ptr %71, i32 1
  %88 = icmp eq i32 %76, 0
  br i1 %88, label %91, label %70, !llvm.loop !93

89:                                               ; preds = %84
  %90 = add nsw i32 %76, -1
  br label %91

91:                                               ; preds = %86, %81, %70, %89
  %92 = phi i32 [ %90, %89 ], [ 0, %86 ], [ %72, %70 ], [ %76, %81 ]
  %93 = getelementptr inbounds nuw i8, ptr %2, i32 60
  %94 = load i32, ptr %93, align 4, !tbaa !36
  %95 = icmp slt i32 %92, %94
  br i1 %95, label %96, label %97

96:                                               ; preds = %91
  store i32 %92, ptr %93, align 4, !tbaa !36
  br label %97

97:                                               ; preds = %96, %91
  %98 = phi i32 [ %92, %96 ], [ %94, %91 ]
  %99 = getelementptr inbounds nuw i8, ptr %2, i32 48
  %100 = load i32, ptr %99, align 4, !tbaa !23
  %101 = add i32 %100, %98
  %102 = icmp ult i32 %92, %101
  br i1 %102, label %106, label %103

103:                                              ; preds = %97
  %104 = add i32 %92, 1
  %105 = sub i32 %104, %100
  store i32 %105, ptr %93, align 4, !tbaa !36
  br label %106

106:                                              ; preds = %103, %97
  %107 = phi i32 [ %105, %103 ], [ %98, %97 ]
  %108 = icmp eq ptr %4, %7
  br i1 %108, label %109, label %113

109:                                              ; preds = %106
  %110 = load i8, ptr %4, align 1, !tbaa !26
  %111 = icmp eq i8 %110, 9
  br i1 %111, label %112, label %113

112:                                              ; preds = %109
  store i32 0, ptr %93, align 4, !tbaa !36
  br label %113

113:                                              ; preds = %106, %109, %112
  %114 = phi i32 [ 0, %112 ], [ %107, %109 ], [ %107, %106 ]
  %115 = sub nsw i32 %92, %114
  store i32 %60, ptr %5, align 4, !tbaa !18
  store i32 %115, ptr %6, align 4, !tbaa !18
  %116 = icmp eq i32 %0, 0
  br i1 %116, label %117, label %147

117:                                              ; preds = %113
  %118 = getelementptr inbounds nuw i8, ptr %2, i32 104
  %119 = load i32, ptr %118, align 4, !tbaa !55
  %120 = icmp eq i32 %119, 0
  br i1 %120, label %121, label %147

121:                                              ; preds = %117
  %122 = getelementptr inbounds nuw i8, ptr %2, i32 136
  %123 = load i32, ptr %122, align 4, !tbaa !94
  %124 = icmp eq i32 %114, %123
  br i1 %124, label %125, label %147

125:                                              ; preds = %121
  %126 = load ptr, ptr %2, align 4, !tbaa !31
  %127 = ptrtoint ptr %57 to i32
  %128 = ptrtoint ptr %126 to i32
  %129 = sub i32 %127, %128
  %130 = getelementptr inbounds nuw i8, ptr %2, i32 140
  %131 = load i32, ptr %130, align 4, !tbaa !95
  %132 = icmp eq i32 %129, %131
  br i1 %132, label %133, label %147

133:                                              ; preds = %125
  %134 = getelementptr inbounds nuw i8, ptr %2, i32 88
  %135 = load i32, ptr %134, align 4, !tbaa !14
  %136 = getelementptr inbounds nuw i8, ptr %2, i32 92
  %137 = load i32, ptr %136, align 4, !tbaa !15
  %138 = icmp sgt i32 %135, %137
  br i1 %138, label %139, label %147

139:                                              ; preds = %133
  %140 = getelementptr inbounds nuw i8, ptr %2, i32 96
  %141 = load i32, ptr %140, align 4, !tbaa !53
  %142 = icmp eq i32 %141, 0
  br i1 %142, label %143, label %147

143:                                              ; preds = %139
  %144 = getelementptr inbounds nuw i8, ptr %2, i32 100
  %145 = load i32, ptr %144, align 4, !tbaa !54
  %146 = icmp eq i32 %145, 0
  br i1 %146, label %342, label %147

147:                                              ; preds = %113, %117, %121, %143, %139, %133, %125
  %148 = phi i1 [ false, %143 ], [ false, %139 ], [ false, %133 ], [ true, %125 ], [ true, %121 ], [ true, %117 ], [ true, %113 ]
  br label %149

149:                                              ; preds = %334, %147
  %150 = phi ptr [ %2, %147 ], [ %335, %334 ]
  %151 = phi ptr [ %57, %147 ], [ %171, %334 ]
  %152 = phi i32 [ 0, %147 ], [ %336, %334 ]
  %153 = getelementptr inbounds nuw i8, ptr %150, i32 44
  %154 = load i32, ptr %153, align 4, !tbaa !22
  %155 = add i32 %154, -1
  %156 = icmp ult i32 %152, %155
  br i1 %156, label %157, label %337

157:                                              ; preds = %149
  %158 = getelementptr inbounds nuw i8, ptr %150, i32 4
  %159 = load ptr, ptr %158, align 4, !tbaa !50
  %160 = icmp ult ptr %151, %159
  br i1 %160, label %161, label %170

161:                                              ; preds = %157
  %162 = ptrtoint ptr %159 to i32
  %163 = ptrtoint ptr %151 to i32
  %164 = sub i32 %162, %163
  %165 = tail call fastcc ptr @bb_memchr(ptr noundef %151, i32 noundef %164) #16
  %166 = icmp eq ptr %165, null
  %167 = getelementptr inbounds i8, ptr %159, i32 -1
  %168 = select i1 %166, ptr %167, ptr %165
  %169 = getelementptr inbounds nuw i8, ptr %168, i32 1
  br label %170

170:                                              ; preds = %161, %157
  %171 = phi ptr [ %169, %161 ], [ %151, %157 ]
  br i1 %148, label %191, label %172

172:                                              ; preds = %170
  %173 = load ptr, ptr %150, align 4, !tbaa !31
  %174 = ptrtoint ptr %171 to i32
  %175 = ptrtoint ptr %173 to i32
  %176 = sub i32 %174, %175
  %177 = getelementptr inbounds nuw i8, ptr %150, i32 88
  %178 = load i32, ptr %177, align 4, !tbaa !14
  %179 = icmp sgt i32 %176, %178
  br i1 %179, label %180, label %334

180:                                              ; preds = %172
  %181 = getelementptr inbounds nuw i8, ptr %150, i32 100
  %182 = load i32, ptr %181, align 4, !tbaa !54
  %183 = icmp eq i32 %182, 0
  br i1 %183, label %184, label %191

184:                                              ; preds = %180
  %185 = ptrtoint ptr %151 to i32
  %186 = sub i32 %185, %175
  %187 = getelementptr inbounds nuw i8, ptr %150, i32 92
  %188 = load i32, ptr %187, align 4, !tbaa !15
  %189 = add nsw i32 %188, 1
  %190 = icmp sgt i32 %186, %189
  br i1 %190, label %334, label %191

191:                                              ; preds = %184, %180, %170
  %192 = getelementptr inbounds nuw i8, ptr %150, i32 60
  %193 = load i32, ptr %192, align 4, !tbaa !36
  %194 = getelementptr inbounds nuw i8, ptr %150, i32 764
  br label %195

195:                                              ; preds = %256, %191
  %196 = phi ptr [ %159, %191 ], [ %261, %256 ]
  %197 = phi ptr [ %150, %191 ], [ %257, %256 ]
  %198 = phi ptr [ %151, %191 ], [ %239, %256 ]
  %199 = phi i8 [ 126, %191 ], [ %240, %256 ]
  %200 = phi i32 [ 0, %191 ], [ %258, %256 ]
  %201 = phi i32 [ %193, %191 ], [ %259, %256 ]
  %202 = getelementptr inbounds nuw i8, ptr %197, i32 48
  %203 = load i32, ptr %202, align 4, !tbaa !23
  %204 = getelementptr inbounds nuw i8, ptr %197, i32 112
  %205 = load i32, ptr %204, align 4, !tbaa !17
  %206 = add i32 %205, %203
  %207 = icmp ult i32 %200, %206
  br i1 %207, label %208, label %266

208:                                              ; preds = %195
  %209 = icmp ult ptr %198, %196
  br i1 %209, label %210, label %238

210:                                              ; preds = %208
  %211 = getelementptr inbounds nuw i8, ptr %198, i32 1
  %212 = load i8, ptr %198, align 1, !tbaa !26
  %213 = icmp eq i8 %212, 10
  br i1 %213, label %266, label %214

214:                                              ; preds = %210
  %215 = icmp sgt i8 %212, -1
  %216 = select i1 %215, i8 %212, i8 46
  %217 = icmp samesign ult i8 %216, 32
  br i1 %217, label %220, label %218

218:                                              ; preds = %214
  %219 = icmp eq i8 %216, 127
  br i1 %219, label %232, label %238

220:                                              ; preds = %214
  %221 = icmp eq i8 %216, 9
  br i1 %221, label %222, label %232

222:                                              ; preds = %220, %228
  %223 = phi i32 [ %231, %228 ], [ %205, %220 ]
  %224 = phi i32 [ %229, %228 ], [ %200, %220 ]
  %225 = srem i32 %224, %223
  %226 = add nsw i32 %223, -1
  %227 = icmp eq i32 %225, %226
  br i1 %227, label %238, label %228

228:                                              ; preds = %222
  %229 = add nsw i32 %224, 1
  %230 = getelementptr inbounds i8, ptr %194, i32 %224
  store i8 32, ptr %230, align 1, !tbaa !26
  %231 = load i32, ptr %204, align 4, !tbaa !17
  br label %222, !llvm.loop !96

232:                                              ; preds = %220, %218
  %233 = add nuw nsw i32 %200, 1
  %234 = getelementptr inbounds i8, ptr %194, i32 %200
  store i8 94, ptr %234, align 1, !tbaa !26
  %235 = icmp eq i8 %216, 127
  %236 = add nuw i8 %216, 64
  %237 = select i1 %235, i8 63, i8 %236
  br label %238

238:                                              ; preds = %222, %232, %218, %208
  %239 = phi ptr [ %211, %218 ], [ %198, %208 ], [ %211, %232 ], [ %211, %222 ]
  %240 = phi i8 [ %216, %218 ], [ %199, %208 ], [ %237, %232 ], [ 32, %222 ]
  %241 = phi i32 [ %200, %218 ], [ %200, %208 ], [ %233, %232 ], [ %224, %222 ]
  %242 = add nsw i32 %241, 1
  %243 = getelementptr inbounds i8, ptr %194, i32 %241
  store i8 %240, ptr %243, align 1, !tbaa !26
  %244 = load i32, ptr %204, align 4, !tbaa !17
  %245 = icmp slt i32 %201, %244
  br i1 %245, label %256, label %246

246:                                              ; preds = %238
  %247 = icmp slt i32 %242, %244
  br i1 %247, label %256, label %248

248:                                              ; preds = %246
  %249 = getelementptr inbounds i8, ptr %194, i32 %244
  %250 = tail call ptr @memmove(ptr noundef nonnull %194, ptr noundef nonnull %249, i32 noundef %242) #17
  %251 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %252 = getelementptr inbounds nuw i8, ptr %251, i32 112
  %253 = load i32, ptr %252, align 4, !tbaa !17
  %254 = sub nsw i32 %242, %253
  %255 = sub nsw i32 %201, %253
  br label %256

256:                                              ; preds = %248, %246, %238
  %257 = phi ptr [ %251, %248 ], [ %197, %246 ], [ %197, %238 ]
  %258 = phi i32 [ %254, %248 ], [ %242, %246 ], [ %242, %238 ]
  %259 = phi i32 [ %255, %248 ], [ %201, %246 ], [ %201, %238 ]
  %260 = getelementptr inbounds nuw i8, ptr %257, i32 4
  %261 = load ptr, ptr %260, align 4, !tbaa !50
  %262 = icmp ult ptr %239, %261
  br i1 %262, label %195, label %263, !llvm.loop !97

263:                                              ; preds = %256
  %264 = getelementptr inbounds nuw i8, ptr %257, i32 48
  %265 = load i32, ptr %264, align 4, !tbaa !23
  br label %266, !llvm.loop !97

266:                                              ; preds = %210, %195, %263
  %267 = phi i32 [ %265, %263 ], [ %203, %195 ], [ %203, %210 ]
  %268 = phi i32 [ %258, %263 ], [ %200, %195 ], [ %200, %210 ]
  %269 = phi i32 [ %259, %263 ], [ %201, %195 ], [ %201, %210 ]
  %270 = tail call i32 @llvm.smin.i32(i32 %268, i32 %269)
  %271 = sub nsw i32 %268, %270
  %272 = icmp ult i32 %271, %267
  br i1 %272, label %273, label %277

273:                                              ; preds = %266
  %274 = getelementptr inbounds i8, ptr %194, i32 %268
  %275 = sub nuw i32 %267, %271
  %276 = tail call ptr @memset(ptr noundef nonnull %274, i32 noundef 32, i32 noundef %275) #17
  br label %277

277:                                              ; preds = %266, %273
  %278 = getelementptr inbounds i8, ptr %194, i32 %270
  %279 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %280 = getelementptr inbounds nuw i8, ptr %279, i32 48
  %281 = load i32, ptr %280, align 4, !tbaa !23
  %282 = add i32 %281, -1
  %283 = getelementptr inbounds nuw i8, ptr %279, i32 80
  %284 = load ptr, ptr %283, align 4, !tbaa !24
  %285 = mul i32 %281, %152
  %286 = getelementptr inbounds nuw i8, ptr %284, i32 %285
  br i1 %116, label %287, label %320

287:                                              ; preds = %277, %296
  %288 = phi i32 [ %297, %296 ], [ 0, %277 ]
  %289 = icmp sgt i32 %288, %282
  br i1 %289, label %298, label %290

290:                                              ; preds = %287
  %291 = getelementptr inbounds nuw i8, ptr %278, i32 %288
  %292 = load i8, ptr %291, align 1, !tbaa !26
  %293 = getelementptr inbounds nuw i8, ptr %286, i32 %288
  %294 = load i8, ptr %293, align 1, !tbaa !26
  %295 = icmp eq i8 %292, %294
  br i1 %295, label %296, label %298

296:                                              ; preds = %290
  %297 = add nuw nsw i32 %288, 1
  br label %287, !llvm.loop !98

298:                                              ; preds = %290, %287
  %299 = phi i32 [ 0, %287 ], [ 1, %290 ]
  br label %300

300:                                              ; preds = %309, %298
  %301 = phi i32 [ %282, %298 ], [ %310, %309 ]
  %302 = icmp slt i32 %301, %288
  br i1 %302, label %311, label %303

303:                                              ; preds = %300
  %304 = getelementptr inbounds i8, ptr %278, i32 %301
  %305 = load i8, ptr %304, align 1, !tbaa !26
  %306 = getelementptr inbounds i8, ptr %286, i32 %301
  %307 = load i8, ptr %306, align 1, !tbaa !26
  %308 = icmp eq i8 %305, %307
  br i1 %308, label %309, label %311

309:                                              ; preds = %303
  %310 = add nsw i32 %301, -1
  br label %300, !llvm.loop !99

311:                                              ; preds = %300, %303
  %312 = phi i32 [ %299, %300 ], [ 1, %303 ]
  %313 = getelementptr inbounds nuw i8, ptr %279, i32 60
  %314 = load i32, ptr %313, align 4, !tbaa !36
  %315 = getelementptr inbounds nuw i8, ptr %279, i32 136
  %316 = load i32, ptr %315, align 4, !tbaa !94
  %317 = icmp eq i32 %314, %316
  %318 = icmp eq i32 %312, 0
  %319 = and i1 %318, %317
  br i1 %319, label %334, label %320

320:                                              ; preds = %277, %311
  %321 = phi i32 [ %301, %311 ], [ %282, %277 ]
  %322 = phi i32 [ %288, %311 ], [ 0, %277 ]
  %323 = tail call i32 @llvm.umin.i32(i32 %321, i32 %282)
  %324 = icmp sgt i32 %322, %323
  %325 = select i1 %324, i32 %282, i32 %323
  %326 = select i1 %324, i32 0, i32 %322
  %327 = getelementptr inbounds nuw i8, ptr %286, i32 %326
  %328 = getelementptr inbounds nuw i8, ptr %278, i32 %326
  %329 = sub nsw i32 %325, %326
  %330 = add nsw i32 %329, 1
  %331 = tail call ptr @memmove(ptr noundef %327, ptr noundef nonnull %328, i32 noundef %330) #17
  tail call fastcc void @place_cursor(i32 noundef %152, i32 noundef %326) #16
  %332 = tail call i32 @write(i32 noundef 1, ptr noundef %327, i32 noundef range(i32 -2147483647, -2147483648) %330) #17
  %333 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %334

334:                                              ; preds = %311, %320, %172, %184
  %335 = phi ptr [ %279, %311 ], [ %333, %320 ], [ %150, %172 ], [ %150, %184 ]
  %336 = add nuw nsw i32 %152, 1
  br label %149, !llvm.loop !100

337:                                              ; preds = %149
  %338 = getelementptr inbounds nuw i8, ptr %150, i32 52
  %339 = load i32, ptr %338, align 4, !tbaa !32
  %340 = getelementptr inbounds nuw i8, ptr %150, i32 56
  %341 = load i32, ptr %340, align 4, !tbaa !33
  br label %342

342:                                              ; preds = %337, %143
  %343 = phi i32 [ %341, %337 ], [ %115, %143 ]
  %344 = phi i32 [ %339, %337 ], [ %60, %143 ]
  tail call fastcc void @place_cursor(i32 noundef %344, i32 noundef %343) #16
  %345 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %346 = getelementptr inbounds nuw i8, ptr %345, i32 412
  %347 = load i32, ptr %346, align 4, !tbaa !59
  %348 = icmp eq i32 %347, 0
  br i1 %348, label %352, label %349

349:                                              ; preds = %342
  %350 = getelementptr inbounds nuw i8, ptr %345, i32 60
  %351 = load i32, ptr %350, align 4, !tbaa !36
  br label %359

352:                                              ; preds = %342
  %353 = getelementptr inbounds nuw i8, ptr %345, i32 56
  %354 = load i32, ptr %353, align 4, !tbaa !33
  %355 = getelementptr inbounds nuw i8, ptr %345, i32 60
  %356 = load i32, ptr %355, align 4, !tbaa !36
  %357 = add nsw i32 %356, %354
  %358 = getelementptr inbounds nuw i8, ptr %345, i32 408
  store i32 %357, ptr %358, align 4, !tbaa !63
  br label %359

359:                                              ; preds = %349, %352
  %360 = phi i32 [ %351, %349 ], [ %356, %352 ]
  %361 = getelementptr inbounds nuw i8, ptr %345, i32 136
  store i32 %360, ptr %361, align 4, !tbaa !94
  %362 = getelementptr inbounds nuw i8, ptr %345, i32 76
  %363 = load ptr, ptr %362, align 4, !tbaa !51
  %364 = load ptr, ptr %345, align 4, !tbaa !31
  %365 = ptrtoint ptr %363 to i32
  %366 = ptrtoint ptr %364 to i32
  %367 = sub i32 %365, %366
  %368 = getelementptr inbounds nuw i8, ptr %345, i32 140
  store i32 %367, ptr %368, align 4, !tbaa !95
  %369 = getelementptr inbounds nuw i8, ptr %345, i32 88
  store i32 2147483647, ptr %369, align 4, !tbaa !14
  %370 = getelementptr inbounds nuw i8, ptr %345, i32 92
  store i32 -1, ptr %370, align 4, !tbaa !15
  %371 = getelementptr inbounds nuw i8, ptr %345, i32 96
  store i32 0, ptr %371, align 4, !tbaa !53
  %372 = getelementptr inbounds nuw i8, ptr %345, i32 100
  store i32 0, ptr %372, align 4, !tbaa !54
  %373 = getelementptr inbounds nuw i8, ptr %345, i32 104
  store i32 0, ptr %373, align 4, !tbaa !55
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @show_status_line() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 64
  %3 = load i32, ptr %2, align 4, !tbaa !101
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %77

5:                                                ; preds = %0
  %6 = load ptr, ptr %1, align 4, !tbaa !31
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %8 = load ptr, ptr %7, align 4, !tbaa !45
  %9 = tail call fastcc i32 @count_lines(ptr noundef %6, ptr noundef %8) #16
  %10 = getelementptr inbounds nuw i8, ptr %1, i32 24
  %11 = load i32, ptr %10, align 4, !tbaa !56
  %12 = getelementptr inbounds nuw i8, ptr %1, i32 28
  %13 = load i32, ptr %12, align 4, !tbaa !8
  %14 = icmp eq i32 %11, %13
  br i1 %14, label %15, label %18

15:                                               ; preds = %5
  %16 = getelementptr inbounds nuw i8, ptr %1, i32 144
  %17 = load i32, ptr %16, align 4, !tbaa !102
  br label %27

18:                                               ; preds = %5
  %19 = getelementptr inbounds nuw i8, ptr %1, i32 108
  %20 = load i32, ptr %19, align 4, !tbaa !52
  %21 = tail call fastcc ptr @end_line(ptr noundef %8) #16
  %22 = load i8, ptr %21, align 1, !tbaa !26
  %23 = icmp ne i8 %22, 10
  %24 = sext i1 %23 to i32
  %25 = add i32 %20, %24
  %26 = getelementptr inbounds nuw i8, ptr %1, i32 144
  store i32 %25, ptr %26, align 4, !tbaa !102
  store i32 %11, ptr %12, align 4, !tbaa !8
  br label %27

27:                                               ; preds = %18, %15
  %28 = phi i32 [ %17, %15 ], [ %25, %18 ]
  %29 = icmp sgt i32 %28, 0
  br i1 %29, label %30, label %33

30:                                               ; preds = %27
  %31 = mul nsw i32 %9, 100
  %32 = sdiv i32 %31, %28
  br label %35

33:                                               ; preds = %27
  %34 = getelementptr inbounds nuw i8, ptr %1, i32 144
  store i32 0, ptr %34, align 4, !tbaa !102
  br label %35

35:                                               ; preds = %30, %33
  %36 = phi i32 [ %28, %30 ], [ 0, %33 ]
  %37 = phi i32 [ %32, %30 ], [ 100, %33 ]
  %38 = phi i32 [ %9, %30 ], [ 0, %33 ]
  %39 = getelementptr inbounds nuw i8, ptr %1, i32 48
  %40 = load i32, ptr %39, align 4, !tbaa !23
  %41 = tail call i32 @llvm.umin.i32(i32 %40, i32 199)
  %42 = getelementptr inbounds nuw i8, ptr %1, i32 436
  %43 = add nuw nsw i32 %41, 1
  %44 = getelementptr inbounds nuw i8, ptr %1, i32 20
  %45 = load i32, ptr %44, align 4, !tbaa !34
  %46 = and i32 %45, 3
  %47 = getelementptr inbounds nuw [5 x i8], ptr @format_edit_status.cmd_mode_indicator, i32 0, i32 %46
  %48 = load i8, ptr %47, align 1, !tbaa !26
  %49 = sext i8 %48 to i32
  %50 = getelementptr inbounds nuw i8, ptr %1, i32 72
  %51 = load ptr, ptr %50, align 4, !tbaa !84
  %52 = icmp eq ptr %51, null
  %53 = select i1 %52, ptr @.str.69, ptr %51
  %54 = icmp eq i32 %11, 0
  %55 = select i1 %54, ptr @.str.17, ptr @.str.70
  %56 = tail call i32 (ptr, i32, ptr, ...) @bb_snprintf(ptr noundef nonnull %42, i32 noundef %43, ptr nonnull poison, i32 noundef %49, ptr noundef nonnull %53, ptr noundef nonnull %55, i32 noundef %38, i32 noundef %36, i32 noundef %37) #16
  %57 = tail call range(i32 0, 200) i32 @llvm.umin.i32(i32 %56, i32 %41)
  %58 = getelementptr inbounds nuw i8, ptr %42, i32 %57
  br label %59

59:                                               ; preds = %63, %35
  %60 = phi i32 [ 0, %35 ], [ %67, %63 ]
  %61 = phi ptr [ %42, %35 ], [ %64, %63 ]
  %62 = icmp ult ptr %61, %58
  br i1 %62, label %63, label %68

63:                                               ; preds = %59
  %64 = getelementptr inbounds nuw i8, ptr %61, i32 1
  %65 = load i8, ptr %61, align 1, !tbaa !26
  %66 = zext i8 %65 to i32
  %67 = add nuw nsw i32 %60, %66
  br label %59, !llvm.loop !103

68:                                               ; preds = %59
  %69 = load i32, ptr %2, align 4, !tbaa !101
  %70 = icmp eq i32 %69, 0
  br i1 %70, label %71, label %77

71:                                               ; preds = %68
  %72 = icmp eq i32 %57, 0
  br i1 %72, label %110, label %73

73:                                               ; preds = %71
  %74 = getelementptr inbounds nuw i8, ptr %1, i32 68
  %75 = load i32, ptr %74, align 4, !tbaa !57
  %76 = icmp eq i32 %75, %60
  br i1 %76, label %110, label %77

77:                                               ; preds = %0, %73, %68
  %78 = phi i32 [ %60, %73 ], [ %60, %68 ], [ 0, %0 ]
  %79 = getelementptr inbounds nuw i8, ptr %1, i32 68
  store i32 %78, ptr %79, align 4, !tbaa !57
  tail call fastcc void @go_bottom_and_clear_to_eol() #16
  %80 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %81 = getelementptr inbounds nuw i8, ptr %80, i32 436
  tail call fastcc void @write1(ptr noundef nonnull %81) #16
  %82 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %83 = getelementptr inbounds nuw i8, ptr %82, i32 64
  %84 = load i32, ptr %83, align 4, !tbaa !101
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %104, label %86

86:                                               ; preds = %77
  %87 = getelementptr inbounds nuw i8, ptr %82, i32 436
  %88 = tail call i32 @strlen(ptr noundef nonnull %87) #17
  %89 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %90 = getelementptr inbounds nuw i8, ptr %89, i32 64
  %91 = load i32, ptr %90, align 4, !tbaa !101
  %92 = add i32 %88, 1
  %93 = sub i32 %92, %91
  %94 = icmp sgt i32 %93, -1
  br i1 %94, label %95, label %101

95:                                               ; preds = %86
  %96 = getelementptr inbounds nuw i8, ptr %89, i32 48
  %97 = load i32, ptr %96, align 4, !tbaa !23
  %98 = icmp ult i32 %93, %97
  br i1 %98, label %101, label %99

99:                                               ; preds = %95
  tail call fastcc void @Hit_Return() #16
  %100 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br label %101

101:                                              ; preds = %99, %95, %86
  %102 = phi ptr [ %100, %99 ], [ %89, %95 ], [ %89, %86 ]
  %103 = getelementptr inbounds nuw i8, ptr %102, i32 64
  store i32 0, ptr %103, align 4, !tbaa !101
  br label %104

104:                                              ; preds = %101, %77
  %105 = phi ptr [ %102, %101 ], [ %82, %77 ]
  %106 = getelementptr inbounds nuw i8, ptr %105, i32 52
  %107 = load i32, ptr %106, align 4, !tbaa !32
  %108 = getelementptr inbounds nuw i8, ptr %105, i32 56
  %109 = load i32, ptr %108, align 4, !tbaa !33
  tail call fastcc void @place_cursor(i32 noundef %107, i32 noundef %109) #16
  br label %110

110:                                              ; preds = %104, %73, %71
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @go_bottom_and_clear_to_eol() unnamed_addr #0 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 44
  %3 = load i32, ptr %2, align 4, !tbaa !22
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
  %3 = load ptr, ptr %2, align 4, !tbaa !24
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 84
  %5 = load i32, ptr %4, align 4, !tbaa !25
  %6 = tail call ptr @memset(ptr noundef %3, i32 noundef 32, i32 noundef %5) #17
  %7 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 104
  store i32 1, ptr %8, align 4, !tbaa !55
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @free(ptr noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc void @update_filename(ptr noundef %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 72
  %4 = load ptr, ptr %3, align 4, !tbaa !84
  %5 = icmp eq ptr %0, %4
  br i1 %5, label %10, label %6

6:                                                ; preds = %1
  tail call fastcc void @bb_free(ptr noundef %4) #16
  %7 = tail call fastcc ptr @xstrdup(ptr noundef %0) #16
  %8 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 72
  store ptr %7, ptr %9, align 4, !tbaa !84
  br label %10

10:                                               ; preds = %6, %1
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, -2147483648) i32 @file_insert(ptr noundef %0, ptr noundef %1, i32 noundef range(i32 0, 2) %2) unnamed_addr #0 {
  %4 = alloca %struct.stat, align 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #19
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = load ptr, ptr %5, align 4, !tbaa !31
  %7 = icmp ult ptr %1, %6
  %8 = select i1 %7, ptr %6, ptr %1
  %9 = getelementptr inbounds nuw i8, ptr %5, i32 4
  %10 = load ptr, ptr %9, align 4, !tbaa !50
  %11 = icmp ugt ptr %8, %10
  %12 = select i1 %11, ptr %10, ptr %8
  %13 = icmp eq ptr %0, null
  br i1 %13, label %59, label %14

14:                                               ; preds = %3
  %15 = tail call i32 @open(ptr noundef nonnull %0, i32 noundef 0) #17
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  %18 = icmp eq i32 %2, 0
  br i1 %18, label %19, label %59

19:                                               ; preds = %17
  tail call fastcc void @status_line_bold_errno(ptr noundef nonnull %0) #16
  br label %59

20:                                               ; preds = %14
  %21 = call i32 @fstat(i32 noundef %15, ptr noundef nonnull %4) #17
  %22 = icmp slt i32 %21, 0
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  call fastcc void @status_line_bold_errno(ptr noundef nonnull %0) #16
  br label %56

24:                                               ; preds = %20
  %25 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %26 = load i16, ptr %25, align 4, !tbaa !104
  %27 = icmp eq i16 %26, 2
  br i1 %27, label %29, label %28

28:                                               ; preds = %24
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.3, ptr noundef nonnull %0) #16
  br label %56

29:                                               ; preds = %24
  %30 = getelementptr inbounds nuw i8, ptr %4, i32 12
  %31 = load i32, ptr %30, align 4, !tbaa !108
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
  %45 = icmp eq i32 %36, 0
  br i1 %45, label %49, label %46

46:                                               ; preds = %44
  %47 = getelementptr inbounds nuw i8, ptr %34, i32 %36
  %48 = call fastcc i32 @count_newlines(ptr noundef %34, ptr noundef nonnull %47) #16
  call fastcc void @text_changed(ptr noundef %34, i32 noundef %36, i32 noundef 0, i32 noundef %48) #16
  br label %49

49:                                               ; preds = %44, %46
  %50 = icmp samesign ult i32 %36, %32
  br i1 %50, label %51, label %56

51:                                               ; preds = %49
  %52 = getelementptr inbounds nuw i8, ptr %34, i32 %36
  %53 = getelementptr inbounds nuw i8, ptr %34, i32 %32
  %54 = getelementptr inbounds i8, ptr %53, i32 -1
  %55 = call fastcc ptr @text_hole_delete(ptr noundef %52, ptr noundef nonnull %54) #16
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.4, ptr noundef nonnull %0) #16
  br label %56

56:                                               ; preds = %51, %49, %28, %23
  %57 = phi i32 [ -1, %23 ], [ %36, %51 ], [ %36, %49 ], [ -1, %28 ]
  %58 = call i32 @close(i32 noundef %15) #17
  br label %59

59:                                               ; preds = %17, %19, %3, %56
  %60 = phi i32 [ %57, %56 ], [ -1, %3 ], [ -1, %19 ], [ -1, %17 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #19
  ret i32 %60
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @char_insert(ptr noundef %0, i8 noundef signext %1) unnamed_addr #0 {
  %3 = tail call fastcc ptr @begin_line(ptr noundef %0) #16
  switch i8 %1, label %68 [
    i8 22, label %4
    i8 27, label %17
    i8 4, label %31
  ]

4:                                                ; preds = %2
  %5 = tail call fastcc i32 @stupid_insert(ptr noundef %0, i8 noundef signext 94) #16
  %6 = getelementptr inbounds nuw i8, ptr %0, i32 %5
  tail call fastcc void @refresh(i32 noundef 0) #16
  %7 = tail call fastcc i32 @readit() #16
  %8 = trunc i32 %7 to i8
  store i8 %8, ptr %6, align 1, !tbaa !26
  %9 = and i32 %7, 255
  %10 = icmp eq i32 %9, 10
  %11 = zext i1 %10 to i32
  tail call fastcc void @text_changed(ptr noundef nonnull %6, i32 noundef 1, i32 noundef 0, i32 noundef %11) #16
  %12 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %13 = getelementptr inbounds nuw i8, ptr %12, i32 24
  %14 = load i32, ptr %13, align 4, !tbaa !56
  %15 = add nsw i32 %14, 1
  store i32 %15, ptr %13, align 4, !tbaa !56
  %16 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %101

17:                                               ; preds = %2
  %18 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %19 = getelementptr inbounds nuw i8, ptr %18, i32 20
  store i32 0, ptr %19, align 4, !tbaa !34
  %20 = getelementptr inbounds nuw i8, ptr %18, i32 36
  store i32 0, ptr %20, align 4, !tbaa !35
  %21 = getelementptr inbounds nuw i8, ptr %18, i32 68
  store i32 0, ptr %21, align 4, !tbaa !57
  %22 = getelementptr inbounds nuw i8, ptr %18, i32 8
  %23 = load ptr, ptr %22, align 4, !tbaa !45
  %24 = load ptr, ptr %18, align 4, !tbaa !31
  %25 = icmp ugt ptr %23, %24
  br i1 %25, label %26, label %101

26:                                               ; preds = %17
  %27 = getelementptr inbounds i8, ptr %0, i32 -1
  %28 = load i8, ptr %27, align 1, !tbaa !26
  %29 = icmp eq i8 %28, 10
  %30 = select i1 %29, ptr %0, ptr %27
  br label %101

31:                                               ; preds = %2
  %32 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %33 = getelementptr inbounds nuw i8, ptr %32, i32 4
  %34 = load ptr, ptr %33, align 4, !tbaa !50
  %35 = getelementptr inbounds i8, ptr %34, i32 -1
  br label %36

36:                                               ; preds = %41, %31
  %37 = phi ptr [ %3, %31 ], [ %42, %41 ]
  %38 = icmp ult ptr %37, %35
  br i1 %38, label %39, label %43

39:                                               ; preds = %36
  %40 = load i8, ptr %37, align 1, !tbaa !26
  switch i8 %40, label %43 [
    i8 32, label %41
    i8 9, label %41
  ]

41:                                               ; preds = %39, %39
  %42 = getelementptr inbounds nuw i8, ptr %37, i32 1
  br label %36, !llvm.loop !109

43:                                               ; preds = %36, %39
  %44 = ptrtoint ptr %37 to i32
  %45 = ptrtoint ptr %3 to i32
  %46 = sub i32 %44, %45
  %47 = getelementptr inbounds nuw i8, ptr %3, i32 %46
  %48 = tail call fastcc i32 @get_column(ptr noundef %47) #16
  %49 = getelementptr inbounds nuw i8, ptr %32, i32 112
  %50 = load i32, ptr %49, align 4, !tbaa !17
  %51 = srem i32 %48, %50
  %52 = icmp eq i32 %51, 0
  %53 = select i1 %52, i32 %50, i32 %51
  %54 = sub nsw i32 %48, %53
  br label %55

55:                                               ; preds = %62, %43
  %56 = phi ptr [ %47, %43 ], [ %67, %62 ]
  %57 = phi ptr [ %0, %43 ], [ %65, %62 ]
  %58 = icmp ugt ptr %56, %3
  br i1 %58, label %59, label %101

59:                                               ; preds = %55
  %60 = tail call fastcc i32 @get_column(ptr noundef nonnull %56) #16
  %61 = icmp sgt i32 %60, %54
  br i1 %61, label %62, label %101

62:                                               ; preds = %59
  %63 = icmp ugt ptr %57, %3
  %64 = sext i1 %63 to i32
  %65 = getelementptr inbounds i8, ptr %57, i32 %64
  %66 = getelementptr inbounds i8, ptr %56, i32 -1
  %67 = tail call fastcc ptr @text_hole_delete(ptr noundef nonnull %66, ptr noundef nonnull %66) #16
  br label %55, !llvm.loop !110

68:                                               ; preds = %2
  %69 = sext i8 %1 to i32
  %70 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %71 = getelementptr inbounds nuw i8, ptr %70, i32 406
  %72 = load i8, ptr %71, align 2, !tbaa !26
  %73 = zext i8 %72 to i32
  %74 = icmp eq i32 %69, %73
  br i1 %74, label %76, label %75

75:                                               ; preds = %68
  switch i8 %1, label %92 [
    i8 8, label %76
    i8 127, label %76
  ]

76:                                               ; preds = %75, %75, %68
  %77 = getelementptr inbounds nuw i8, ptr %70, i32 20
  %78 = load i32, ptr %77, align 4, !tbaa !34
  %79 = icmp eq i32 %78, 2
  br i1 %79, label %80, label %86

80:                                               ; preds = %76
  %81 = getelementptr inbounds nuw i8, ptr %70, i32 40
  %82 = load ptr, ptr %81, align 4, !tbaa !82
  %83 = icmp ugt ptr %0, %82
  %84 = sext i1 %83 to i32
  %85 = getelementptr inbounds i8, ptr %0, i32 %84
  br label %101

86:                                               ; preds = %76
  %87 = load ptr, ptr %70, align 4, !tbaa !31
  %88 = icmp ugt ptr %0, %87
  br i1 %88, label %89, label %101

89:                                               ; preds = %86
  %90 = getelementptr inbounds i8, ptr %0, i32 -1
  %91 = tail call fastcc ptr @text_hole_delete(ptr noundef nonnull %90, ptr noundef nonnull %90) #16
  br label %101

92:                                               ; preds = %75
  %93 = icmp eq i8 %1, 13
  %94 = select i1 %93, i8 10, i8 %1
  %95 = getelementptr inbounds nuw i8, ptr %70, i32 24
  %96 = load i32, ptr %95, align 4, !tbaa !56
  %97 = add nsw i32 %96, 1
  store i32 %97, ptr %95, align 4, !tbaa !56
  %98 = tail call fastcc i32 @stupid_insert(ptr noundef %0, i8 noundef signext %94) #16
  %99 = getelementptr i8, ptr %0, i32 %98
  %100 = getelementptr i8, ptr %99, i32 1
  br label %101

101:                                              ; preds = %59, %55, %80, %26, %17, %92, %86, %89, %4
  %102 = phi ptr [ %16, %4 ], [ %0, %17 ], [ %91, %89 ], [ %0, %86 ], [ %100, %92 ], [ %30, %26 ], [ %85, %80 ], [ %57, %55 ], [ %57, %59 ]
  ret ptr %102
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
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 436
  %5 = call ptr @strcpy(ptr noundef nonnull %4, ptr noundef nonnull @.str.6) #17
  %6 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 440
  %8 = load i32, ptr %2, align 4
  %9 = insertvalue [1 x i32] poison, i32 %8, 0
  %10 = call fastcc i32 @bb_vsnprintf(ptr noundef nonnull %7, i32 noundef 191, ptr noundef %0, [1 x i32] %9) #16
  %11 = getelementptr inbounds nuw i8, ptr %6, i32 436
  br label %12

12:                                               ; preds = %12, %1
  %13 = phi ptr [ %11, %1 ], [ %16, %12 ]
  %14 = load i8, ptr %13, align 1, !tbaa !26
  %15 = icmp eq i8 %14, 0
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 1
  br i1 %15, label %17, label %12, !llvm.loop !111

17:                                               ; preds = %12, %17
  %18 = phi i32 [ %21, %17 ], [ 0, %12 ]
  %19 = phi ptr [ %23, %17 ], [ %13, %12 ]
  %20 = getelementptr inbounds nuw i8, ptr @.str.7, i32 %18
  %21 = add nuw nsw i32 %18, 1
  %22 = load i8, ptr %20, align 1, !tbaa !26
  %23 = getelementptr inbounds nuw i8, ptr %19, i32 1
  store i8 %22, ptr %19, align 1, !tbaa !26
  %24 = icmp eq i32 %18, 3
  br i1 %24, label %25, label %17, !llvm.loop !112

25:                                               ; preds = %17
  call void @llvm.va_end.p0(ptr nonnull %2)
  %26 = getelementptr inbounds nuw i8, ptr %6, i32 64
  store i32 8, ptr %26, align 4, !tbaa !101
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
  %7 = load ptr, ptr %6, align 4, !tbaa !50
  %8 = getelementptr inbounds nuw i8, ptr %7, i32 %1
  store ptr %8, ptr %6, align 4, !tbaa !50
  %9 = load ptr, ptr %5, align 4, !tbaa !31
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 12
  %11 = load i32, ptr %10, align 4, !tbaa !49
  %12 = getelementptr inbounds i8, ptr %9, i32 %11
  %13 = icmp ult ptr %8, %12
  br i1 %13, label %61, label %14

14:                                               ; preds = %4
  %15 = ptrtoint ptr %8 to i32
  %16 = ptrtoint ptr %12 to i32
  %17 = add i32 %15, 10240
  %18 = add i32 %17, %11
  %19 = sub i32 %18, %16
  store i32 %19, ptr %10, align 4, !tbaa !49
  %20 = icmp eq ptr %9, null
  br i1 %20, label %21, label %23

21:                                               ; preds = %14
  %22 = tail call fastcc ptr @xmalloc(i32 noundef %19) #16
  br label %31

23:                                               ; preds = %14
  %24 = getelementptr inbounds i8, ptr %9, i32 -4
  %25 = load i32, ptr %24, align 4, !tbaa !26
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
  %34 = load ptr, ptr %33, align 4, !tbaa !31
  %35 = ptrtoint ptr %32 to i32
  %36 = ptrtoint ptr %34 to i32
  %37 = sub i32 %35, %36
  %38 = getelementptr inbounds nuw i8, ptr %33, i32 76
  %39 = load ptr, ptr %38, align 4, !tbaa !51
  %40 = getelementptr inbounds nuw i8, ptr %39, i32 %37
  store ptr %40, ptr %38, align 4, !tbaa !51
  %41 = getelementptr inbounds nuw i8, ptr %33, i32 8
  %42 = load ptr, ptr %41, align 4, !tbaa !45
  %43 = getelementptr inbounds nuw i8, ptr %42, i32 %37
  store ptr %43, ptr %41, align 4, !tbaa !45
  %44 = getelementptr inbounds nuw i8, ptr %33, i32 4
  %45 = load ptr, ptr %44, align 4, !tbaa !50
  %46 = getelementptr inbounds nuw i8, ptr %45, i32 %37
  store ptr %46, ptr %44, align 4, !tbaa !50
  %47 = getelementptr inbounds nuw i8, ptr %33, i32 292
  br label %48

48:                                               ; preds = %57, %31
  %49 = phi i32 [ 0, %31 ], [ %58, %57 ]
  %50 = icmp eq i32 %49, 28
  br i1 %50, label %59, label %51

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw [28 x ptr], ptr %47, i32 0, i32 %49
  %53 = load ptr, ptr %52, align 4, !tbaa !20
  %54 = icmp eq ptr %53, null
  br i1 %54, label %57, label %55

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %53, i32 %37
  store ptr %56, ptr %52, align 4, !tbaa !20
  br label %57

57:                                               ; preds = %51, %55
  %58 = add nuw nsw i32 %49, 1
  br label %48, !llvm.loop !113

59:                                               ; preds = %48
  %60 = getelementptr inbounds nuw i8, ptr %0, i32 %37
  store ptr %32, ptr %33, align 4, !tbaa !31
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
  tail call fastcc void @text_changed(ptr noundef %63, i32 noundef %1, i32 noundef %1, i32 noundef 0) #16
  br label %73

73:                                               ; preds = %2, %61
  %74 = phi i32 [ %64, %61 ], [ 0, %2 ]
  ret i32 %74
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define internal fastcc void @text_changed(ptr noundef %0, i32 noundef %1, i32 noundef range(i32 -2147483647, -2147483648) %2, i32 noundef %3) unnamed_addr #6 {
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = load ptr, ptr %5, align 4, !tbaa !31
  %7 = ptrtoint ptr %0 to i32
  %8 = ptrtoint ptr %6 to i32
  %9 = sub i32 %7, %8
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 88
  %11 = load i32, ptr %10, align 4, !tbaa !14
  %12 = icmp sgt i32 %11, %9
  br i1 %12, label %13, label %14

13:                                               ; preds = %4
  store i32 %9, ptr %10, align 4, !tbaa !14
  br label %14

14:                                               ; preds = %13, %4
  %15 = getelementptr inbounds nuw i8, ptr %5, i32 92
  %16 = load i32, ptr %15, align 4, !tbaa !15
  %17 = add nsw i32 %16, %2
  %18 = add i32 %1, -1
  %19 = add i32 %18, %9
  %20 = tail call i32 @llvm.smax.i32(i32 %17, i32 %19)
  store i32 %20, ptr %15, align 4
  %21 = getelementptr inbounds nuw i8, ptr %5, i32 96
  %22 = load i32, ptr %21, align 4, !tbaa !53
  %23 = add nsw i32 %22, %2
  store i32 %23, ptr %21, align 4, !tbaa !53
  %24 = getelementptr inbounds nuw i8, ptr %5, i32 100
  %25 = load i32, ptr %24, align 4, !tbaa !54
  %26 = add nsw i32 %25, %3
  store i32 %26, ptr %24, align 4, !tbaa !54
  %27 = getelementptr inbounds nuw i8, ptr %5, i32 108
  %28 = load i32, ptr %27, align 4, !tbaa !52
  %29 = add nsw i32 %28, %3
  store i32 %29, ptr %27, align 4, !tbaa !52
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc i32 @count_newlines(ptr noundef readonly captures(address) %0, ptr noundef readnone captures(address) %1) unnamed_addr #7 {
  br label %3

3:                                                ; preds = %7, %2
  %4 = phi ptr [ %0, %2 ], [ %8, %7 ]
  %5 = phi i32 [ 0, %2 ], [ %12, %7 ]
  %6 = icmp ult ptr %4, %1
  br i1 %6, label %7, label %13

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %9 = load i8, ptr %4, align 1, !tbaa !26
  %10 = icmp eq i8 %9, 10
  %11 = zext i1 %10 to i32
  %12 = add nuw nsw i32 %5, %11
  br label %3, !llvm.loop !114

13:                                               ; preds = %3
  ret i32 %5
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @text_hole_delete(ptr noundef %0, ptr noundef %1) unnamed_addr #0 {
  %3 = icmp ult ptr %1, %0
  %4 = select i1 %3, ptr %1, ptr %0
  %5 = select i1 %3, ptr %0, ptr %1
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %7 = ptrtoint ptr %1 to i32
  %8 = ptrtoint ptr %0 to i32
  %9 = sub i32 %7, %8
  %10 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %12 = load ptr, ptr %11, align 4, !tbaa !50
  %13 = ptrtoint ptr %12 to i32
  %14 = ptrtoint ptr %6 to i32
  %15 = sub i32 %13, %14
  %16 = load ptr, ptr %10, align 4, !tbaa !31
  %17 = icmp ult ptr %6, %16
  br i1 %17, label %52, label %18

18:                                               ; preds = %2
  %19 = icmp ugt ptr %6, %12
  br i1 %19, label %52, label %20

20:                                               ; preds = %18
  %21 = icmp uge ptr %4, %16
  %22 = icmp ult ptr %4, %12
  %23 = select i1 %21, i1 %22, i1 false
  br i1 %23, label %24, label %52

24:                                               ; preds = %20
  %25 = getelementptr inbounds nuw i8, ptr %10, i32 24
  %26 = load i32, ptr %25, align 4, !tbaa !56
  %27 = add nsw i32 %26, 1
  store i32 %27, ptr %25, align 4, !tbaa !56
  %28 = xor i32 %9, -1
  %29 = getelementptr i8, ptr %4, i32 %9
  %30 = getelementptr i8, ptr %29, i32 1
  %31 = tail call fastcc i32 @count_newlines(ptr noundef %4, ptr noundef %30) #16
  %32 = sub nsw i32 0, %31
  tail call fastcc void @text_changed(ptr noundef %4, i32 noundef 0, i32 noundef %28, i32 noundef %32) #16
  %33 = load ptr, ptr %11, align 4, !tbaa !50
  %34 = icmp ult ptr %6, %33
  br i1 %34, label %35, label %40

35:                                               ; preds = %24
  %36 = tail call ptr @memmove(ptr noundef %4, ptr noundef nonnull %6, i32 noundef %15) #17
  %37 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %38 = getelementptr inbounds nuw i8, ptr %37, i32 4
  %39 = load ptr, ptr %38, align 4, !tbaa !50
  br label %40

40:                                               ; preds = %24, %35
  %41 = phi ptr [ %33, %24 ], [ %39, %35 ]
  %42 = phi ptr [ %10, %24 ], [ %37, %35 ]
  %43 = getelementptr inbounds nuw i8, ptr %42, i32 4
  %44 = getelementptr inbounds i8, ptr %41, i32 %28
  %45 = icmp ult ptr %4, %44
  %46 = getelementptr inbounds i8, ptr %44, i32 -1
  %47 = select i1 %45, ptr %4, ptr %46
  %48 = load ptr, ptr %42, align 4, !tbaa !31
  %49 = icmp ugt ptr %44, %48
  %50 = select i1 %49, ptr %44, ptr %48
  store ptr %50, ptr %43, align 4
  %51 = select i1 %49, ptr %47, ptr %48
  br label %52

52:                                               ; preds = %40, %20, %2, %18
  %53 = phi ptr [ %4, %2 ], [ %4, %18 ], [ %4, %20 ], [ %51, %40 ]
  ret ptr %53
}

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #8

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none)
define internal fastcc i32 @bb_vsnprintf(ptr noundef writeonly captures(none) %0, i32 noundef range(i32 1, 134217728) %1, ptr noundef readonly captures(none) %2, [1 x i32] %3) unnamed_addr #9 {
  %5 = alloca [12 x i8], align 1
  %6 = extractvalue [1 x i32] %3, 0
  %7 = inttoptr i32 %6 to ptr
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %5) #19
  br label %8

8:                                                ; preds = %100, %4
  %9 = phi i32 [ 0, %4 ], [ %101, %100 ]
  %10 = phi ptr [ %2, %4 ], [ %104, %100 ]
  %11 = phi ptr [ %7, %4 ], [ %103, %100 ]
  %12 = load i8, ptr %10, align 1, !tbaa !26
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
  store i8 %12, ptr %17, align 1, !tbaa !26
  br label %100

18:                                               ; preds = %8
  %19 = getelementptr inbounds nuw i8, ptr %10, i32 1
  %20 = load i8, ptr %19, align 1, !tbaa !26
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
  store i8 37, ptr %25, align 1, !tbaa !26
  br label %100

26:                                               ; preds = %18
  %27 = getelementptr inbounds nuw i8, ptr %11, i32 4
  %28 = add nsw i32 %9, 1
  %29 = icmp slt i32 %28, %1
  br i1 %29, label %30, label %100

30:                                               ; preds = %26
  %31 = load i32, ptr %11, align 4, !tbaa !18
  %32 = trunc i32 %31 to i8
  %33 = getelementptr inbounds i8, ptr %0, i32 %9
  store i8 %32, ptr %33, align 1, !tbaa !26
  br label %100

34:                                               ; preds = %18
  %35 = load ptr, ptr %11, align 4, !tbaa !20
  %36 = icmp eq ptr %35, null
  %37 = select i1 %36, ptr @.str.8, ptr %35
  br label %38

38:                                               ; preds = %48, %34
  %39 = phi i32 [ %9, %34 ], [ %44, %48 ]
  %40 = phi ptr [ %37, %34 ], [ %49, %48 ]
  %41 = load i8, ptr %40, align 1, !tbaa !26
  %42 = icmp eq i8 %41, 0
  br i1 %42, label %98, label %43

43:                                               ; preds = %38
  %44 = add nsw i32 %39, 1
  %45 = icmp slt i32 %44, %1
  br i1 %45, label %46, label %48

46:                                               ; preds = %43
  %47 = getelementptr inbounds i8, ptr %0, i32 %39
  store i8 %41, ptr %47, align 1, !tbaa !26
  br label %48

48:                                               ; preds = %46, %43
  %49 = getelementptr inbounds nuw i8, ptr %40, i32 1
  br label %38, !llvm.loop !115

50:                                               ; preds = %18, %18
  %51 = load i32, ptr %11, align 4, !tbaa !18
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
  store i8 %63, ptr %65, align 1, !tbaa !26
  %66 = icmp ult i32 %56, 10
  br i1 %66, label %67, label %55, !llvm.loop !116

67:                                               ; preds = %55
  %68 = getelementptr inbounds nuw i8, ptr %11, i32 4
  %69 = icmp slt i32 %51, 0
  %70 = load i8, ptr %19, align 1, !tbaa !26
  %71 = icmp eq i8 %70, 100
  %72 = select i1 %71, i1 %69, i1 false
  br i1 %72, label %73, label %76

73:                                               ; preds = %67
  %74 = add nsw i32 %57, -2
  %75 = getelementptr inbounds [12 x i8], ptr %5, i32 0, i32 %74
  store i8 45, ptr %75, align 1, !tbaa !26
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
  %87 = load i8, ptr %86, align 1, !tbaa !26
  %88 = getelementptr inbounds i8, ptr %0, i32 %79
  store i8 %87, ptr %88, align 1, !tbaa !26
  br label %89

89:                                               ; preds = %85, %82
  %90 = add nsw i32 %80, 1
  br label %78, !llvm.loop !117

91:                                               ; preds = %18
  %92 = add nsw i32 %9, 2
  %93 = icmp slt i32 %92, %1
  br i1 %93, label %94, label %100

94:                                               ; preds = %91
  %95 = getelementptr inbounds i8, ptr %0, i32 %9
  store i8 37, ptr %95, align 1, !tbaa !26
  %96 = load i8, ptr %19, align 1, !tbaa !26
  %97 = getelementptr i8, ptr %95, i32 1
  store i8 %96, ptr %97, align 1, !tbaa !26
  br label %100

98:                                               ; preds = %38
  %99 = getelementptr inbounds nuw i8, ptr %11, i32 4
  br label %100

100:                                              ; preds = %78, %98, %91, %94, %26, %30, %21, %24, %13, %16
  %101 = phi i32 [ %14, %16 ], [ %14, %13 ], [ %22, %24 ], [ %22, %21 ], [ %28, %30 ], [ %28, %26 ], [ %92, %94 ], [ %92, %91 ], [ %39, %98 ], [ %79, %78 ]
  %102 = phi ptr [ %10, %16 ], [ %10, %13 ], [ %19, %24 ], [ %19, %21 ], [ %19, %30 ], [ %19, %26 ], [ %19, %94 ], [ %19, %91 ], [ %19, %98 ], [ %19, %78 ]
  %103 = phi ptr [ %11, %16 ], [ %11, %13 ], [ %11, %24 ], [ %11, %21 ], [ %27, %30 ], [ %27, %26 ], [ %11, %94 ], [ %11, %91 ], [ %99, %98 ], [ %68, %78 ]
  %104 = getelementptr inbounds nuw i8, ptr %102, i32 1
  br label %8, !llvm.loop !118

105:                                              ; preds = %8
  %106 = add nsw i32 %1, -1
  %107 = tail call i32 @llvm.smin.i32(i32 %9, i32 %106)
  %108 = getelementptr inbounds i8, ptr %0, i32 %107
  store i8 0, ptr %108, align 1, !tbaa !26
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %5) #19
  ret i32 %9
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #8

; Function Attrs: minsize optsize
declare dso_local ptr @memmove(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define internal fastcc i32 @stupid_insert(ptr noundef %0, i8 noundef signext %1) unnamed_addr #0 {
  %3 = tail call fastcc i32 @text_hole_make(ptr noundef %0, i32 noundef 1) #16
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  store i8 %1, ptr %4, align 1, !tbaa !26
  %5 = icmp eq i8 %1, 10
  %6 = zext i1 %5 to i32
  tail call fastcc void @text_changed(ptr noundef nonnull %4, i32 noundef 1, i32 noundef 0, i32 noundef %6) #16
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
  %8 = load i8, ptr %4, align 1, !tbaa !26
  %9 = tail call fastcc i32 @next_column(i8 noundef signext %8, i32 noundef %5) #16
  %10 = getelementptr inbounds nuw i8, ptr %4, i32 1
  br label %3, !llvm.loop !119

11:                                               ; preds = %3
  ret i32 %5
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none)
define internal fastcc range(i32 -2147483647, -2147483648) i32 @next_column(i8 noundef signext %0, i32 noundef %1) unnamed_addr #10 {
  %3 = icmp eq i8 %0, 9
  br i1 %3, label %4, label %12

4:                                                ; preds = %2
  %5 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %6 = getelementptr inbounds nuw i8, ptr %5, i32 112
  %7 = load i32, ptr %6, align 4, !tbaa !17
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
  %6 = load i8, ptr %5, align 1, !tbaa !26
  %7 = icmp eq i8 %6, 58
  %8 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br i1 %7, label %4, label %9, !llvm.loop !120

9:                                                ; preds = %4
  %10 = tail call fastcc ptr @skip_whitespace(ptr noundef nonnull %5) #16
  %11 = load i8, ptr %10, align 1, !tbaa !26
  switch i8 %11, label %12 [
    i8 0, label %796
    i8 34, label %796
  ]

12:                                               ; preds = %9
  %13 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 8
  %15 = load ptr, ptr %14, align 4, !tbaa !45
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
  %35 = load ptr, ptr %22, align 4, !tbaa !31
  %36 = getelementptr inbounds nuw i8, ptr %22, i32 4
  %37 = load ptr, ptr %36, align 4, !tbaa !50
  %38 = getelementptr inbounds i8, ptr %37, i32 -1
  %39 = tail call fastcc i32 @count_lines(ptr noundef %35, ptr noundef nonnull %38) #16
  br label %217

40:                                               ; preds = %31
  %41 = load ptr, ptr %23, align 4, !tbaa !31
  %42 = getelementptr inbounds nuw i8, ptr %23, i32 8
  %43 = load ptr, ptr %42, align 4, !tbaa !45
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
  %75 = load ptr, ptr %74, align 4, !tbaa !50
  %76 = getelementptr inbounds i8, ptr %75, i32 -1
  %77 = tail call fastcc i32 @count_lines(ptr noundef %50, ptr noundef nonnull %76) #16
  br label %188

78:                                               ; preds = %68
  %79 = getelementptr inbounds nuw i8, ptr %55, i32 1
  %80 = load i8, ptr %79, align 1, !tbaa !26
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
  %93 = getelementptr inbounds nuw i8, ptr %54, i32 292
  %94 = and i32 %92, 255
  %95 = getelementptr inbounds nuw [28 x ptr], ptr %93, i32 0, i32 %94
  %96 = load ptr, ptr %95, align 4, !tbaa !20
  %97 = icmp eq ptr %96, null
  br i1 %97, label %228, label %98

98:                                               ; preds = %91
  %99 = tail call fastcc i32 @count_lines(ptr noundef %52, ptr noundef nonnull %96) #16
  br label %188

100:                                              ; preds = %69, %100
  %101 = phi i32 [ %107, %100 ], [ 1, %69 ]
  %102 = getelementptr inbounds nuw i8, ptr %55, i32 %101
  %103 = load i8, ptr %102, align 1, !tbaa !26
  %104 = icmp eq i8 %103, 0
  %105 = icmp eq i8 %48, %103
  %106 = or i1 %104, %105
  %107 = add nuw nsw i32 %101, 1
  br i1 %106, label %108, label %100, !llvm.loop !121

108:                                              ; preds = %100
  %109 = getelementptr inbounds nuw i8, ptr %55, i32 %101
  %110 = icmp eq i32 %101, 1
  br i1 %110, label %118, label %111

111:                                              ; preds = %108
  %112 = getelementptr inbounds nuw i8, ptr %54, i32 124
  %113 = load ptr, ptr %112, align 4, !tbaa !16
  tail call fastcc void @bb_free(ptr noundef %113) #16
  %114 = tail call fastcc ptr @xstrndup(ptr noundef nonnull %55, i32 noundef %101) #16
  %115 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %116 = getelementptr inbounds nuw i8, ptr %115, i32 124
  store ptr %114, ptr %116, align 4, !tbaa !16
  %117 = load i8, ptr %109, align 1, !tbaa !26
  br label %118

118:                                              ; preds = %111, %108
  %119 = phi ptr [ %115, %111 ], [ %54, %108 ]
  %120 = phi i8 [ %117, %111 ], [ %103, %108 ]
  %121 = icmp eq i8 %120, %48
  %122 = zext i1 %121 to i32
  %123 = getelementptr inbounds nuw i8, ptr %109, i32 %122
  %124 = icmp eq i8 %48, 47
  %125 = getelementptr inbounds nuw i8, ptr %119, i32 8
  %126 = load ptr, ptr %125, align 4, !tbaa !45
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
  %134 = getelementptr inbounds nuw i8, ptr %119, i32 124
  %135 = load ptr, ptr %134, align 4, !tbaa !16
  %136 = getelementptr inbounds nuw i8, ptr %135, i32 1
  %137 = tail call fastcc ptr @char_search(ptr noundef %132, ptr noundef nonnull %136, i32 noundef %133) #16
  %138 = icmp eq ptr %137, null
  br i1 %138, label %139, label %154

139:                                              ; preds = %131
  %140 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  br i1 %124, label %141, label %143

141:                                              ; preds = %139
  %142 = load ptr, ptr %140, align 4, !tbaa !31
  br label %147

143:                                              ; preds = %139
  %144 = getelementptr inbounds nuw i8, ptr %140, i32 4
  %145 = load ptr, ptr %144, align 4, !tbaa !50
  %146 = getelementptr inbounds i8, ptr %145, i32 -1
  br label %147

147:                                              ; preds = %143, %141
  %148 = phi ptr [ %142, %141 ], [ %146, %143 ]
  %149 = getelementptr inbounds nuw i8, ptr %140, i32 124
  %150 = load ptr, ptr %149, align 4, !tbaa !16
  %151 = getelementptr inbounds nuw i8, ptr %150, i32 1
  %152 = tail call fastcc ptr @char_search(ptr noundef %148, ptr noundef nonnull %151, i32 noundef %133) #16
  %153 = icmp eq ptr %152, null
  br i1 %153, label %228, label %154

154:                                              ; preds = %147, %131
  %155 = phi ptr [ %152, %147 ], [ %137, %131 ]
  %156 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %157 = load ptr, ptr %156, align 4, !tbaa !31
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
  %174 = load i8, ptr %171, align 1, !tbaa !26
  br label %162, !llvm.loop !122

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
  %201 = load i8, ptr %197, align 1, !tbaa !26
  br label %45, !llvm.loop !123

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
  store ptr %213, ptr %214, align 4, !tbaa !45
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
  %227 = load i8, ptr %226, align 1, !tbaa !26
  br label %16, !llvm.loop !124

228:                                              ; preds = %78, %91, %147
  %229 = phi ptr [ @.str.42, %91 ], [ @.str.42, %78 ], [ @.str.43, %147 ]
  tail call void (ptr, ...) @status_line_bold(ptr noundef nonnull %229) #16
  %230 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %231 = getelementptr inbounds nuw i8, ptr %230, i32 8
  store ptr %15, ptr %231, align 4, !tbaa !45
  br label %796

232:                                              ; preds = %205, %211
  %233 = phi ptr [ %17, %211 ], [ %46, %205 ]
  %234 = phi ptr [ %26, %211 ], [ %55, %205 ]
  %235 = getelementptr inbounds nuw i8, ptr %233, i32 8
  store ptr %15, ptr %235, align 4, !tbaa !45
  br label %236

236:                                              ; preds = %244, %232
  %237 = phi i32 [ 0, %232 ], [ %246, %244 ]
  %238 = icmp eq i32 %237, 9
  br i1 %238, label %239, label %240

239:                                              ; preds = %240, %236
  br label %247

240:                                              ; preds = %236
  %241 = getelementptr inbounds nuw i8, ptr %234, i32 %237
  %242 = load i8, ptr %241, align 1, !tbaa !26
  %243 = icmp eq i8 %242, 0
  br i1 %243, label %239, label %244

244:                                              ; preds = %240
  %245 = getelementptr inbounds nuw i8, ptr %2, i32 %237
  store i8 %242, ptr %245, align 1, !tbaa !26
  %246 = add nuw nsw i32 %237, 1
  br label %236, !llvm.loop !125

247:                                              ; preds = %239, %250
  %248 = phi i32 [ %252, %250 ], [ %237, %239 ]
  %249 = icmp samesign ult i32 %248, 9
  br i1 %249, label %250, label %253

250:                                              ; preds = %247
  %251 = getelementptr inbounds nuw i8, ptr %2, i32 %248
  store i8 0, ptr %251, align 1, !tbaa !26
  %252 = add nuw nsw i32 %248, 1
  br label %247, !llvm.loop !126

253:                                              ; preds = %247
  %254 = getelementptr inbounds nuw i8, ptr %2, i32 9
  store i8 0, ptr %254, align 1, !tbaa !26
  %255 = call fastcc ptr @skip_non_whitespace(ptr noundef %2) #16
  store i8 0, ptr %255, align 1, !tbaa !26
  %256 = load i8, ptr %2, align 1, !tbaa !26
  %257 = icmp eq i8 %256, 0
  br i1 %257, label %267, label %258

258:                                              ; preds = %253
  %259 = call i32 @strlen(ptr noundef nonnull %2) #17
  %260 = getelementptr i8, ptr %2, i32 %259
  %261 = getelementptr i8, ptr %260, i32 -1
  %262 = load i8, ptr %261, align 1, !tbaa !26
  %263 = icmp eq i8 %262, 33
  br i1 %263, label %264, label %267

264:                                              ; preds = %258
  %265 = icmp ugt ptr %261, %2
  br i1 %265, label %266, label %267

266:                                              ; preds = %264
  store i8 0, ptr %261, align 1, !tbaa !26
  br label %267

267:                                              ; preds = %258, %253, %266, %264
  %268 = phi i1 [ false, %266 ], [ false, %264 ], [ true, %253 ], [ true, %258 ]
  %269 = call fastcc ptr @skip_non_whitespace(ptr noundef %234) #16
  %270 = call fastcc ptr @skip_whitespace(ptr noundef nonnull %269) #16
  %271 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %272 = load ptr, ptr %271, align 4, !tbaa !31
  %273 = getelementptr inbounds nuw i8, ptr %271, i32 4
  %274 = load ptr, ptr %273, align 4, !tbaa !50
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
  store ptr %308, ptr %310, align 4, !tbaa !45
  call fastcc void @dot_skip_over_ws() #16
  br label %796

311:                                              ; preds = %300
  %312 = load i8, ptr %2, align 1, !tbaa !26
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
  %321 = load ptr, ptr %320, align 4, !tbaa !31
  %322 = getelementptr inbounds nuw i8, ptr %320, i32 8
  %323 = load ptr, ptr %322, align 4, !tbaa !45
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
  %334 = load ptr, ptr %333, align 4, !tbaa !45
  %335 = call fastcc ptr @begin_line(ptr noundef %334) #16
  %336 = call fastcc ptr @end_line(ptr noundef %334) #16
  br label %337

337:                                              ; preds = %331, %330
  %338 = phi ptr [ %301, %330 ], [ %336, %331 ]
  %339 = phi ptr [ %302, %330 ], [ %335, %331 ]
  %340 = call fastcc ptr @yank_delete(ptr noundef %339, ptr noundef %338, i32 noundef 1, i32 noundef 1) #16
  %341 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %342 = getelementptr inbounds nuw i8, ptr %341, i32 8
  store ptr %340, ptr %342, align 4, !tbaa !45
  call fastcc void @dot_skip_over_ws() #16
  br label %796

343:                                              ; preds = %327
  %344 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.12, i32 noundef %303) #16
  %345 = icmp eq i32 %344, 0
  br i1 %345, label %346, label %389

346:                                              ; preds = %343
  %347 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %348 = getelementptr inbounds nuw i8, ptr %347, i32 24
  %349 = load i32, ptr %348, align 4, !tbaa !56
  %350 = icmp ne i32 %349, 0
  %351 = and i1 %268, %350
  br i1 %351, label %352, label %353

352:                                              ; preds = %346
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.13, ptr noundef nonnull %2) #16
  br label %796

353:                                              ; preds = %346
  %354 = load i8, ptr %270, align 1, !tbaa !26
  %355 = icmp eq i8 %354, 0
  br i1 %355, label %356, label %361

356:                                              ; preds = %353
  %357 = getelementptr inbounds nuw i8, ptr %347, i32 72
  %358 = load ptr, ptr %357, align 4, !tbaa !84
  %359 = icmp eq ptr %358, null
  br i1 %359, label %360, label %361

360:                                              ; preds = %356
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.14) #16
  br label %796

361:                                              ; preds = %353, %356
  %362 = phi ptr [ %358, %356 ], [ %270, %353 ]
  %363 = call fastcc i32 @init_text_buffer(ptr noundef nonnull %362) #16
  %364 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %365 = getelementptr inbounds nuw i8, ptr %364, i32 260
  %366 = load ptr, ptr %365, align 4, !tbaa !20
  call fastcc void @bb_free(ptr noundef %366) #16
  %367 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %368 = getelementptr inbounds nuw i8, ptr %367, i32 260
  store ptr null, ptr %368, align 4, !tbaa !20
  %369 = getelementptr inbounds nuw i8, ptr %367, i32 152
  %370 = getelementptr inbounds nuw i8, ptr %367, i32 148
  %371 = load i32, ptr %370, align 4, !tbaa !30
  %372 = getelementptr inbounds nuw [28 x ptr], ptr %369, i32 0, i32 %371
  %373 = load ptr, ptr %372, align 4, !tbaa !20
  call fastcc void @bb_free(ptr noundef %373) #16
  %374 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %375 = getelementptr inbounds nuw i8, ptr %374, i32 152
  %376 = getelementptr inbounds nuw i8, ptr %374, i32 148
  %377 = load i32, ptr %376, align 4, !tbaa !30
  %378 = getelementptr inbounds nuw [28 x ptr], ptr %375, i32 0, i32 %377
  store ptr null, ptr %378, align 4, !tbaa !20
  %379 = icmp slt i32 %363, 0
  %380 = select i1 %379, ptr @.str.16, ptr @.str.17
  %381 = load ptr, ptr %374, align 4, !tbaa !31
  %382 = getelementptr inbounds nuw i8, ptr %374, i32 4
  %383 = load ptr, ptr %382, align 4, !tbaa !50
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
  %396 = load i8, ptr %270, align 1, !tbaa !26
  %397 = icmp eq i8 %396, 0
  br i1 %397, label %399, label %398

398:                                              ; preds = %395
  call fastcc void @update_filename(ptr noundef nonnull %270) #16
  br label %796

399:                                              ; preds = %395
  %400 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %401 = getelementptr inbounds nuw i8, ptr %400, i32 68
  store i32 0, ptr %401, align 4, !tbaa !57
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
  %413 = load ptr, ptr %412, align 4, !tbaa !45
  %414 = call fastcc ptr @begin_line(ptr noundef %413) #16
  %415 = call fastcc ptr @end_line(ptr noundef %413) #16
  br label %416

416:                                              ; preds = %411, %409
  %417 = phi ptr [ %301, %409 ], [ %415, %411 ]
  %418 = phi ptr [ %302, %409 ], [ %414, %411 ]
  %419 = getelementptr inbounds nuw i8, ptr %410, i32 64
  store i32 1, ptr %419, align 4, !tbaa !101
  %420 = getelementptr inbounds nuw i8, ptr %410, i32 436
  %421 = getelementptr inbounds nuw i8, ptr %410, i32 625
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
  %430 = load i8, ptr %424, align 1, !tbaa !26
  %431 = icmp eq i8 %430, 10
  br i1 %431, label %432, label %434

432:                                              ; preds = %428
  %433 = getelementptr inbounds nuw i8, ptr %423, i32 1
  store i8 36, ptr %423, align 1, !tbaa !26
  br label %455

434:                                              ; preds = %428
  %435 = icmp slt i8 %430, 0
  br i1 %435, label %436, label %440

436:                                              ; preds = %434
  %437 = call fastcc ptr @stpcpy(ptr noundef %423, ptr noundef nonnull @.str.6) #16
  %438 = getelementptr inbounds nuw i8, ptr %437, i32 1
  store i8 46, ptr %437, align 1, !tbaa !26
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
  store i8 94, ptr %423, align 1, !tbaa !26
  %446 = icmp eq i8 %430, 127
  %447 = add nuw i8 %430, 64
  %448 = select i1 %446, i8 63, i8 %447
  br label %449

449:                                              ; preds = %444, %442
  %450 = phi i8 [ %430, %442 ], [ %448, %444 ]
  %451 = phi ptr [ %423, %442 ], [ %445, %444 ]
  %452 = getelementptr inbounds nuw i8, ptr %451, i32 1
  store i8 %450, ptr %451, align 1, !tbaa !26
  br label %453

453:                                              ; preds = %449, %436
  %454 = phi ptr [ %439, %436 ], [ %452, %449 ]
  br label %422, !llvm.loop !127

455:                                              ; preds = %422, %432
  %456 = phi ptr [ %433, %432 ], [ %423, %422 ]
  store i8 0, ptr %456, align 1, !tbaa !26
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
  %472 = load i32, ptr %471, align 4, !tbaa !19
  store i32 %472, ptr @optind, align 4, !tbaa !18
  br label %473

473:                                              ; preds = %470, %467
  %474 = getelementptr inbounds nuw i8, ptr %469, i32 16
  store i32 0, ptr %474, align 4, !tbaa !21
  br label %796

475:                                              ; preds = %466
  %476 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %477 = getelementptr inbounds nuw i8, ptr %476, i32 24
  %478 = load i32, ptr %477, align 4, !tbaa !56
  %479 = icmp eq i32 %478, 0
  br i1 %479, label %481, label %480

480:                                              ; preds = %475
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.13, ptr noundef nonnull %2) #16
  br label %796

481:                                              ; preds = %475
  %482 = getelementptr inbounds nuw i8, ptr %476, i32 32
  %483 = load i32, ptr %482, align 4, !tbaa !19
  %484 = load i32, ptr @optind, align 4, !tbaa !18
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
  store i32 %502, ptr @optind, align 4, !tbaa !18
  br label %503

503:                                              ; preds = %501, %496
  %504 = getelementptr inbounds nuw i8, ptr %476, i32 16
  store i32 0, ptr %504, align 4, !tbaa !21
  br label %796

505:                                              ; preds = %463
  %506 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.28, i32 noundef %303) #16
  %507 = icmp eq i32 %506, 0
  br i1 %507, label %508, label %566

508:                                              ; preds = %505
  %509 = load i8, ptr %270, align 1, !tbaa !26
  %510 = icmp eq i8 %509, 0
  br i1 %510, label %511, label %517

511:                                              ; preds = %508
  %512 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %513 = getelementptr inbounds nuw i8, ptr %512, i32 72
  %514 = load ptr, ptr %513, align 4, !tbaa !84
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
  %522 = load ptr, ptr %521, align 4, !tbaa !31
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
  %530 = load ptr, ptr %529, align 4, !tbaa !45
  br label %531

531:                                              ; preds = %527, %524
  %532 = phi ptr [ %526, %524 ], [ %528, %527 ]
  %533 = phi ptr [ %525, %524 ], [ %530, %527 ]
  %534 = call fastcc ptr @next_line(ptr noundef %533) #16
  %535 = getelementptr inbounds nuw i8, ptr %532, i32 4
  %536 = load ptr, ptr %535, align 4, !tbaa !50
  %537 = getelementptr inbounds i8, ptr %536, i32 -1
  %538 = icmp eq ptr %534, %537
  %539 = zext i1 %538 to i32
  %540 = getelementptr inbounds nuw i8, ptr %534, i32 %539
  %541 = load ptr, ptr %532, align 4, !tbaa !31
  br label %542

542:                                              ; preds = %531, %520
  %543 = phi ptr [ %522, %520 ], [ %541, %531 ]
  %544 = phi ptr [ %521, %520 ], [ %532, %531 ]
  %545 = phi ptr [ %522, %520 ], [ %540, %531 ]
  %546 = call fastcc i32 @count_lines(ptr noundef %543, ptr noundef %545) #16
  %547 = getelementptr inbounds nuw i8, ptr %544, i32 4
  %548 = load ptr, ptr %547, align 4, !tbaa !50
  %549 = call fastcc i32 @file_insert(ptr noundef nonnull %518, ptr noundef %545, i32 noundef 0) #16
  %550 = icmp slt i32 %549, 0
  br i1 %550, label %796, label %551

551:                                              ; preds = %542
  %552 = icmp eq ptr %545, %548
  %553 = zext i1 %552 to i32
  %554 = add nsw i32 %546, %553
  %555 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %556 = load ptr, ptr %555, align 4, !tbaa !31
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
  store ptr %564, ptr %565, align 4, !tbaa !45
  br label %796

566:                                              ; preds = %505
  %567 = call fastcc i32 @bb_strncmp(ptr noundef nonnull %2, ptr noundef nonnull @.str.30, i32 noundef %303) #16
  %568 = icmp eq i32 %567, 0
  br i1 %568, label %569, label %578

569:                                              ; preds = %566
  %570 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %571 = getelementptr inbounds nuw i8, ptr %570, i32 24
  %572 = load i32, ptr %571, align 4, !tbaa !56
  %573 = icmp ne i32 %572, 0
  %574 = and i1 %268, %573
  br i1 %574, label %575, label %576

575:                                              ; preds = %569
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.13, ptr noundef nonnull %2) #16
  br label %796

576:                                              ; preds = %569
  store i32 -1, ptr @optind, align 4, !tbaa !18
  %577 = getelementptr inbounds nuw i8, ptr %570, i32 16
  store i32 0, ptr %577, align 4, !tbaa !21
  br label %796

578:                                              ; preds = %566
  %579 = icmp eq i8 %312, 115
  br i1 %579, label %580, label %674

580:                                              ; preds = %578
  %581 = getelementptr inbounds nuw i8, ptr %234, i32 1
  %582 = call fastcc ptr @skip_whitespace(ptr noundef nonnull %581) #16
  %583 = load i8, ptr %582, align 1, !tbaa !26
  %584 = getelementptr inbounds nuw i8, ptr %582, i32 1
  %585 = call ptr @strchr(ptr noundef nonnull %584, i8 noundef signext %583) #17
  %586 = icmp eq ptr %585, null
  br i1 %586, label %803, label %587

587:                                              ; preds = %580
  %588 = ptrtoint ptr %585 to i32
  %589 = ptrtoint ptr %584 to i32
  %590 = sub i32 %588, %589
  %591 = getelementptr inbounds nuw i8, ptr %585, i32 1
  store i8 0, ptr %585, align 1, !tbaa !26
  %592 = call ptr @strchr(ptr noundef nonnull %591, i8 noundef signext %583) #17
  %593 = icmp eq ptr %592, null
  br i1 %593, label %598, label %594

594:                                              ; preds = %587
  %595 = getelementptr inbounds nuw i8, ptr %592, i32 1
  store i8 0, ptr %592, align 1, !tbaa !26
  %596 = load i8, ptr %595, align 1, !tbaa !26
  %597 = icmp eq i8 %596, 103
  br label %598

598:                                              ; preds = %594, %587
  %599 = phi i1 [ %597, %594 ], [ false, %587 ]
  %600 = icmp eq i32 %590, 0
  %601 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %602 = getelementptr inbounds nuw i8, ptr %601, i32 124
  %603 = load ptr, ptr %602, align 4, !tbaa !16
  br i1 %600, label %608, label %604

604:                                              ; preds = %598
  call fastcc void @bb_free(ptr noundef %603) #16
  %605 = call fastcc ptr @xstrdup(ptr noundef nonnull %582) #16
  %606 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %607 = getelementptr inbounds nuw i8, ptr %606, i32 124
  store ptr %605, ptr %607, align 4, !tbaa !16
  store i8 47, ptr %605, align 1, !tbaa !26
  br label %615

608:                                              ; preds = %598
  %609 = getelementptr inbounds nuw i8, ptr %603, i32 1
  %610 = load i8, ptr %609, align 1, !tbaa !26
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
  %621 = load ptr, ptr %620, align 4, !tbaa !45
  %622 = call fastcc ptr @begin_line(ptr noundef %621) #16
  %623 = call fastcc ptr @end_line(ptr noundef %621) #16
  %624 = load ptr, ptr %619, align 4, !tbaa !31
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
  store ptr %656, ptr %659, align 4, !tbaa !45
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
  br label %636, !llvm.loop !128

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
  %688 = load i8, ptr %2, align 1, !tbaa !26
  %689 = icmp eq i8 %688, 120
  %690 = load i8, ptr %314, align 1
  %691 = icmp eq i8 %690, 0
  %692 = select i1 %689, i1 %691, i1 false
  br i1 %692, label %693, label %770

693:                                              ; preds = %687, %684, %681, %678
  %694 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %695 = getelementptr inbounds nuw i8, ptr %694, i32 72
  %696 = load ptr, ptr %695, align 4, !tbaa !84
  %697 = load i8, ptr %270, align 1, !tbaa !26
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
  %715 = load i32, ptr %714, align 4, !tbaa !56
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
  %739 = load ptr, ptr %738, align 4, !tbaa !31
  %740 = icmp eq ptr %302, %739
  br i1 %740, label %741, label %748

741:                                              ; preds = %737
  %742 = getelementptr inbounds nuw i8, ptr %738, i32 4
  %743 = load ptr, ptr %742, align 4, !tbaa !50
  %744 = icmp eq ptr %733, %743
  br i1 %744, label %745, label %748

745:                                              ; preds = %741
  %746 = getelementptr inbounds nuw i8, ptr %738, i32 24
  store i32 0, ptr %746, align 4, !tbaa !56
  %747 = getelementptr inbounds nuw i8, ptr %738, i32 28
  store i32 -1, ptr %747, align 4, !tbaa !8
  br label %748

748:                                              ; preds = %745, %741, %737
  %749 = load i8, ptr %314, align 1, !tbaa !26
  %750 = icmp eq i8 %749, 110
  br i1 %750, label %751, label %753

751:                                              ; preds = %748
  %752 = getelementptr inbounds nuw i8, ptr %738, i32 16
  store i32 0, ptr %752, align 4, !tbaa !21
  br label %796

753:                                              ; preds = %748
  %754 = load i8, ptr %2, align 1, !tbaa !26
  %755 = icmp eq i8 %754, 120
  br i1 %755, label %758, label %756

756:                                              ; preds = %753
  %757 = icmp eq i8 %749, 113
  br i1 %757, label %758, label %796

758:                                              ; preds = %756, %753
  %759 = getelementptr inbounds nuw i8, ptr %738, i32 32
  %760 = load i32, ptr %759, align 4, !tbaa !19
  %761 = load i32, ptr @optind, align 4, !tbaa !18
  %762 = xor i32 %761, -1
  %763 = add i32 %760, %762
  %764 = icmp sgt i32 %763, 0
  br i1 %764, label %765, label %767

765:                                              ; preds = %758
  br i1 %268, label %769, label %766

766:                                              ; preds = %765
  store i32 %760, ptr @optind, align 4, !tbaa !18
  br label %767

767:                                              ; preds = %758, %766
  %768 = getelementptr inbounds nuw i8, ptr %738, i32 16
  store i32 0, ptr %768, align 4, !tbaa !21
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
  %777 = load ptr, ptr %776, align 4, !tbaa !45
  %778 = call fastcc ptr @begin_line(ptr noundef %777) #16
  %779 = call fastcc ptr @end_line(ptr noundef %777) #16
  br label %780

780:                                              ; preds = %775, %773
  %781 = phi ptr [ %301, %773 ], [ %779, %775 ]
  %782 = phi ptr [ %302, %773 ], [ %778, %775 ]
  %783 = getelementptr inbounds nuw i8, ptr %774, i32 148
  %784 = load i32, ptr %783, align 4, !tbaa !30
  call fastcc void @text_yank(ptr noundef %782, ptr noundef %781, i32 noundef %784, i32 noundef 1) #16
  %785 = call fastcc i32 @count_lines(ptr noundef %782, ptr noundef %781) #16
  %786 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %787 = getelementptr inbounds nuw i8, ptr %786, i32 152
  %788 = getelementptr inbounds nuw i8, ptr %786, i32 148
  %789 = load i32, ptr %788, align 4, !tbaa !30
  %790 = getelementptr inbounds nuw [28 x ptr], ptr %787, i32 0, i32 %789
  %791 = load ptr, ptr %790, align 4, !tbaa !20
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
  %799 = load ptr, ptr %798, align 4, !tbaa !45
  %800 = call fastcc ptr @bound_dot(ptr noundef %799) #16
  %801 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %802 = getelementptr inbounds nuw i8, ptr %801, i32 8
  store ptr %800, ptr %802, align 4, !tbaa !45
  br label %804

803:                                              ; preds = %580
  call void (ptr, ...) @status_line(ptr noundef nonnull @.str.41) #16
  br label %804

804:                                              ; preds = %803, %796
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc noundef ptr @skip_whitespace(ptr noundef readonly captures(ret: address, provenance) %0) unnamed_addr #7 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi ptr [ %0, %1 ], [ %10, %2 ]
  %4 = load i8, ptr %3, align 1, !tbaa !26
  %5 = sext i8 %4 to i32
  %6 = icmp ne i8 %4, 32
  %7 = add nsw i32 %5, -14
  %8 = icmp ult i32 %7, -5
  %9 = select i1 %6, i1 %8, i1 false
  %10 = getelementptr inbounds nuw i8, ptr %3, i32 1
  br i1 %9, label %11, label %2, !llvm.loop !129

11:                                               ; preds = %2
  ret ptr %3
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc noundef nonnull ptr @skip_non_whitespace(ptr noundef nonnull readonly captures(ret: address, provenance) %0) unnamed_addr #7 {
  br label %2

2:                                                ; preds = %12, %1
  %3 = phi ptr [ %0, %1 ], [ %13, %12 ]
  %4 = load i8, ptr %3, align 1, !tbaa !26
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
  br label %2, !llvm.loop !130

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
  %14 = load ptr, ptr %8, align 4, !tbaa !50
  %15 = getelementptr inbounds i8, ptr %14, i32 -1
  %16 = icmp ugt ptr %10, %15
  br i1 %16, label %24, label %17

17:                                               ; preds = %13
  %18 = tail call fastcc ptr @end_line(ptr noundef %10) #16
  %19 = load i8, ptr %18, align 1, !tbaa !26
  %20 = icmp eq i8 %19, 10
  %21 = zext i1 %20 to i32
  %22 = add nuw nsw i32 %11, %21
  %23 = getelementptr inbounds nuw i8, ptr %18, i32 1
  br label %9, !llvm.loop !131

24:                                               ; preds = %9, %13
  ret i32 %11
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @find_line(i32 noundef %0) unnamed_addr #5 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = load ptr, ptr %2, align 4, !tbaa !31
  br label %4

4:                                                ; preds = %8, %1
  %5 = phi i32 [ %0, %1 ], [ %10, %8 ]
  %6 = phi ptr [ %3, %1 ], [ %9, %8 ]
  %7 = icmp sgt i32 %5, 1
  br i1 %7, label %8, label %11

8:                                                ; preds = %4
  %9 = tail call fastcc ptr @next_line(ptr noundef %6) #16
  %10 = add nsw i32 %5, -1
  br label %4, !llvm.loop !132

11:                                               ; preds = %4
  ret ptr %6
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_skip_over_ws() unnamed_addr #11 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 4
  br label %5

5:                                                ; preds = %19, %0
  %6 = phi ptr [ %20, %19 ], [ %3, %0 ]
  %7 = load i8, ptr %6, align 1, !tbaa !26
  %8 = sext i8 %7 to i32
  %9 = icmp ne i8 %7, 32
  %10 = add nsw i32 %8, -14
  %11 = icmp ult i32 %10, -5
  %12 = select i1 %9, i1 %11, i1 false
  %13 = icmp eq i8 %7, 10
  %14 = or i1 %12, %13
  br i1 %14, label %21, label %15

15:                                               ; preds = %5
  %16 = load ptr, ptr %4, align 4, !tbaa !50
  %17 = getelementptr inbounds i8, ptr %16, i32 -1
  %18 = icmp ult ptr %6, %17
  br i1 %18, label %19, label %21

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %6, i32 1
  store ptr %20, ptr %2, align 4, !tbaa !45
  br label %5, !llvm.loop !133

21:                                               ; preds = %5, %15
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize
define internal void @status_line(ptr noundef readonly captures(none) %0, ...) unnamed_addr #12 {
  %2 = alloca %struct.__va_list, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #19
  call void @llvm.va_start.p0(ptr nonnull %2)
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 436
  %5 = load i32, ptr %2, align 4
  %6 = insertvalue [1 x i32] poison, i32 %5, 0
  %7 = call fastcc i32 @bb_vsnprintf(ptr noundef nonnull %4, i32 noundef 200, ptr noundef %0, [1 x i32] %6) #16
  call void @llvm.va_end.p0(ptr nonnull %2)
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 64
  store i32 1, ptr %8, align 4, !tbaa !101
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc range(i32 -255, 256) i32 @bb_strncmp(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, i32 noundef %2) unnamed_addr #7 {
  br label %4

4:                                                ; preds = %16, %3
  %5 = phi ptr [ %0, %3 ], [ %17, %16 ]
  %6 = phi ptr [ %1, %3 ], [ %18, %16 ]
  %7 = phi i32 [ %2, %3 ], [ %8, %16 ]
  %8 = add nsw i32 %7, -1
  %9 = icmp eq i32 %7, 0
  br i1 %9, label %26, label %10

10:                                               ; preds = %4
  %11 = load i8, ptr %5, align 1, !tbaa !26
  %12 = icmp eq i8 %11, 0
  br i1 %12, label %19, label %13

13:                                               ; preds = %10
  %14 = load i8, ptr %6, align 1, !tbaa !26
  %15 = icmp eq i8 %11, %14
  br i1 %15, label %16, label %19

16:                                               ; preds = %13
  %17 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %18 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %4, !llvm.loop !134

19:                                               ; preds = %10, %13
  %20 = icmp slt i32 %7, 1
  br i1 %20, label %26, label %21

21:                                               ; preds = %19
  %22 = zext i8 %11 to i32
  %23 = load i8, ptr %6, align 1, !tbaa !26
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
  %10 = load i8, ptr %7, align 1, !tbaa !26
  %11 = icmp eq i8 %10, 10
  br i1 %11, label %19, label %12

12:                                               ; preds = %9, %4
  %13 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %14 = getelementptr inbounds nuw i8, ptr %13, i32 148
  %15 = load i32, ptr %14, align 4, !tbaa !30
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
define internal fastcc noundef ptr @stpcpy(ptr noundef writeonly captures(ret: address, provenance) %0, ptr noundef readonly captures(none) %1) unnamed_addr #13 {
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi ptr [ %0, %2 ], [ %9, %8 ]
  %5 = phi ptr [ %1, %2 ], [ %10, %8 ]
  %6 = load i8, ptr %5, align 1, !tbaa !26
  store i8 %6, ptr %4, align 1, !tbaa !26
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %11, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 1
  br label %3, !llvm.loop !135

11:                                               ; preds = %3
  ret ptr %4
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @next_line(ptr noundef readonly %0) unnamed_addr #5 {
  %2 = tail call fastcc ptr @end_line(ptr noundef %0) #16
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %5 = load ptr, ptr %4, align 4, !tbaa !50
  %6 = getelementptr inbounds i8, ptr %5, i32 -1
  %7 = icmp ult ptr %2, %6
  br i1 %7, label %8, label %13

8:                                                ; preds = %1
  %9 = load i8, ptr %2, align 1, !tbaa !26
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
  %10 = load ptr, ptr %9, align 4, !tbaa !50
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
  br label %17, !llvm.loop !136

25:                                               ; preds = %3
  %26 = load ptr, ptr %7, align 4, !tbaa !31
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
  br label %34, !llvm.loop !137

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
  %7 = getelementptr inbounds i8, ptr %1, i32 %3
  %8 = tail call fastcc i32 @count_newlines(ptr noundef %1, ptr noundef %7) #16
  tail call fastcc void @text_changed(ptr noundef %5, i32 noundef %3, i32 noundef 0, i32 noundef %8) #16
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
define internal fastcc signext range(i8 68, 123) i8 @what_reg() unnamed_addr #10 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 148
  %3 = load i32, ptr %2, align 4, !tbaa !30
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
  %3 = load i8, ptr %0, align 1, !tbaa !26
  %4 = icmp eq i8 %3, 0
  %5 = select i1 %4, ptr @.str.48, ptr %0
  %6 = ptrtoint ptr %2 to i32
  br label %7

7:                                                ; preds = %23, %1
  %8 = phi ptr [ %5, %1 ], [ %30, %23 ]
  %9 = phi ptr [ %2, %1 ], [ %26, %23 ]
  %10 = load i8, ptr %8, align 1, !tbaa !26
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
  store i8 94, ptr %9, align 1, !tbaa !26
  %20 = or i8 %14, 64
  %21 = icmp eq i8 %20, 127
  %22 = select i1 %21, i8 63, i8 %20
  br label %23

23:                                               ; preds = %18, %16
  %24 = phi ptr [ %19, %18 ], [ %9, %16 ]
  %25 = phi i8 [ %22, %18 ], [ %14, %16 ]
  %26 = getelementptr inbounds nuw i8, ptr %24, i32 1
  store i8 %25, ptr %24, align 1, !tbaa !26
  store i8 0, ptr %26, align 1, !tbaa !26
  %27 = ptrtoint ptr %26 to i32
  %28 = sub i32 %27, %6
  %29 = icmp sgt i32 %28, 118
  %30 = getelementptr inbounds nuw i8, ptr %8, i32 1
  br i1 %29, label %31, label %7, !llvm.loop !138

31:                                               ; preds = %7, %23
  call void (ptr, ...) @status_line_bold(ptr noundef nonnull @.str.47, ptr noundef nonnull %2) #16
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc ptr @bound_dot(ptr noundef readnone captures(address, ret: address, provenance) %0) unnamed_addr #0 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %4 = load ptr, ptr %3, align 4, !tbaa !50
  %5 = icmp ult ptr %0, %4
  br i1 %5, label %12, label %6

6:                                                ; preds = %1
  %7 = load ptr, ptr %2, align 4, !tbaa !31
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
  %15 = load ptr, ptr %13, align 4, !tbaa !31
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
  %8 = load i8, ptr %7, align 1, !tbaa !26
  %9 = icmp eq i8 %8, 0
  br i1 %9, label %12, label %10

10:                                               ; preds = %6
  %11 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !139

12:                                               ; preds = %3, %6
  %13 = add nuw nsw i32 %4, 1
  %14 = tail call fastcc ptr @xmalloc(i32 noundef %13) #16
  %15 = tail call ptr @memmove(ptr noundef nonnull %14, ptr noundef %0, i32 noundef %4) #17
  %16 = getelementptr inbounds nuw i8, ptr %14, i32 %4
  store i8 0, ptr %16, align 1, !tbaa !26
  ret ptr %14
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @prev_line(ptr noundef readonly %0) unnamed_addr #5 {
  %2 = tail call fastcc ptr @begin_line(ptr noundef %0) #16
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = load ptr, ptr %3, align 4, !tbaa !31
  %5 = icmp ugt ptr %2, %4
  br i1 %5, label %6, label %11

6:                                                ; preds = %1
  %7 = getelementptr inbounds i8, ptr %2, i32 -1
  %8 = load i8, ptr %7, align 1, !tbaa !26
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
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 128
  store i32 1, ptr %2, align 4, !tbaa !60
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
define internal fastcc ptr @bb_memchr(ptr noundef readonly captures(ret: address, provenance) %0, i32 noundef %1) unnamed_addr #7 {
  br label %3

3:                                                ; preds = %6, %2
  %4 = phi i32 [ 0, %2 ], [ %10, %6 ]
  %5 = icmp eq i32 %4, %1
  br i1 %5, label %13, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  %8 = load i8, ptr %7, align 1, !tbaa !26
  %9 = icmp eq i8 %8, 10
  %10 = add i32 %4, 1
  br i1 %9, label %11, label %3, !llvm.loop !140

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw i8, ptr %0, i32 %4
  br label %13

13:                                               ; preds = %3, %11
  %14 = phi ptr [ %12, %11 ], [ null, %3 ]
  ret ptr %14
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_scroll(i32 noundef %0, i32 noundef range(i32 -1, 2) %1) unnamed_addr #11 {
  %3 = icmp slt i32 %1, 0
  %4 = load ptr, ptr @ptr_to_globals, align 4
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 76
  br label %6

6:                                                ; preds = %15, %2
  %7 = phi i32 [ %0, %2 ], [ %17, %15 ]
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %18

9:                                                ; preds = %6
  %10 = load ptr, ptr %5, align 4, !tbaa !51
  br i1 %3, label %11, label %13

11:                                               ; preds = %9
  %12 = tail call fastcc ptr @prev_line(ptr noundef %10) #16
  br label %15

13:                                               ; preds = %9
  %14 = tail call fastcc ptr @next_line(ptr noundef %10) #16
  br label %15

15:                                               ; preds = %11, %13
  %16 = phi ptr [ %14, %13 ], [ %12, %11 ]
  store ptr %16, ptr %5, align 4, !tbaa !51
  %17 = add nsw i32 %7, -1
  br label %6, !llvm.loop !141

18:                                               ; preds = %6
  %19 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %20 = load ptr, ptr %19, align 4, !tbaa !45
  %21 = load ptr, ptr %5, align 4, !tbaa !51
  %22 = icmp ult ptr %20, %21
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  store ptr %21, ptr %19, align 4, !tbaa !45
  br label %24

24:                                               ; preds = %23, %18
  %25 = phi ptr [ %21, %23 ], [ %20, %18 ]
  %26 = tail call fastcc ptr @end_screen() #16
  %27 = icmp ugt ptr %25, %26
  br i1 %27, label %28, label %30

28:                                               ; preds = %24
  %29 = tail call fastcc ptr @begin_line(ptr noundef %26) #16
  store ptr %29, ptr %19, align 4, !tbaa !45
  br label %30

30:                                               ; preds = %28, %24
  tail call fastcc void @dot_skip_over_ws() #16
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_left() unnamed_addr #6 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = load ptr, ptr %1, align 4, !tbaa !31
  %5 = icmp ugt ptr %3, %4
  br i1 %5, label %6, label %11

6:                                                ; preds = %0
  %7 = getelementptr inbounds i8, ptr %3, i32 -1
  %8 = load i8, ptr %7, align 1, !tbaa !26
  %9 = icmp eq i8 %8, 10
  br i1 %9, label %11, label %10

10:                                               ; preds = %6
  store ptr %7, ptr %2, align 4, !tbaa !45
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
  %9 = load i8, ptr %7, align 1, !tbaa !26
  %10 = icmp eq i8 %9, 10
  br i1 %10, label %18, label %11

11:                                               ; preds = %6
  %12 = tail call fastcc i32 @next_column(i8 noundef signext %9, i32 noundef %8) #16
  %13 = icmp sgt i32 %12, %1
  br i1 %13, label %18, label %14

14:                                               ; preds = %11
  %15 = getelementptr inbounds nuw i8, ptr %7, i32 1
  %16 = load ptr, ptr %5, align 4, !tbaa !50
  %17 = icmp ult ptr %7, %16
  br i1 %17, label %6, label %18, !llvm.loop !142

18:                                               ; preds = %11, %6, %14
  %19 = phi ptr [ %7, %6 ], [ %15, %14 ], [ %7, %11 ]
  ret ptr %19
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_right() unnamed_addr #6 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %5 = load ptr, ptr %4, align 4, !tbaa !50
  %6 = getelementptr inbounds i8, ptr %5, i32 -1
  %7 = icmp ult ptr %3, %6
  br i1 %7, label %8, label %13

8:                                                ; preds = %0
  %9 = load i8, ptr %3, align 1, !tbaa !26
  %10 = icmp eq i8 %9, 10
  br i1 %10, label %13, label %11

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i8, ptr %3, i32 1
  store ptr %12, ptr %2, align 4, !tbaa !45
  br label %13

13:                                               ; preds = %11, %8, %0
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_begin() unnamed_addr #11 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = tail call fastcc ptr @begin_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !45
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_next() unnamed_addr #11 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = tail call fastcc ptr @next_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !45
  ret void
}

; Function Attrs: minsize nounwind optsize
define internal fastcc nonnull ptr @get_input_line(ptr noundef %0) unnamed_addr #0 {
  %2 = alloca i8, align 1
  %3 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %4 = getelementptr inbounds nuw i8, ptr %3, i32 636
  %5 = tail call ptr @strcpy(ptr noundef nonnull %4, ptr noundef %0) #17
  %6 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 68
  store i32 0, ptr %7, align 4, !tbaa !57
  tail call fastcc void @go_bottom_and_clear_to_eol() #16
  %8 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 636
  tail call fastcc void @write1(ptr noundef nonnull %9) #16
  %10 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %11 = getelementptr inbounds nuw i8, ptr %10, i32 636
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
  %21 = getelementptr inbounds nuw i8, ptr %20, i32 406
  %22 = load i8, ptr %21, align 2, !tbaa !26
  %23 = zext i8 %22 to i32
  %24 = icmp eq i32 %18, %23
  br i1 %24, label %26, label %25

25:                                               ; preds = %19
  switch i32 %18, label %36 [
    i32 8, label %26
    i32 127, label %26
  ]

26:                                               ; preds = %25, %25, %19
  %27 = getelementptr inbounds nuw i8, ptr %20, i32 636
  %28 = add nsw i32 %14, -1
  %29 = getelementptr inbounds [128 x i8], ptr %27, i32 0, i32 %28
  store i8 0, ptr %29, align 1, !tbaa !26
  call fastcc void @go_bottom_and_clear_to_eol() #16
  %30 = icmp slt i32 %14, 2
  br i1 %30, label %46, label %31

31:                                               ; preds = %26
  %32 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %33 = getelementptr inbounds nuw i8, ptr %32, i32 636
  call fastcc void @write1(ptr noundef nonnull %33) #16
  br label %34

34:                                               ; preds = %31, %39
  %35 = phi i32 [ %43, %39 ], [ %28, %31 ]
  br label %13, !llvm.loop !143

36:                                               ; preds = %25
  %37 = add nsw i32 %18, -1
  %38 = icmp ult i32 %37, 255
  br i1 %38, label %39, label %16, !llvm.loop !143

39:                                               ; preds = %36
  %40 = trunc nuw i32 %18 to i8
  %41 = getelementptr inbounds nuw i8, ptr %20, i32 636
  %42 = getelementptr inbounds [128 x i8], ptr %41, i32 0, i32 %14
  store i8 %40, ptr %42, align 1, !tbaa !26
  %43 = add nsw i32 %14, 1
  %44 = getelementptr inbounds [128 x i8], ptr %41, i32 0, i32 %43
  store i8 0, ptr %44, align 1, !tbaa !26
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %2) #19
  store i8 %40, ptr %2, align 1, !tbaa !26
  %45 = call i32 @write(i32 noundef 1, ptr noundef nonnull %2, i32 noundef 1) #17
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %2) #19
  br label %34

46:                                               ; preds = %26, %17, %17, %17, %16
  call fastcc void @refresh(i32 noundef 0) #16
  %47 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %48 = getelementptr inbounds nuw i8, ptr %47, i32 636
  ret ptr %48
}

; Function Attrs: minsize nounwind optsize
define internal fastcc range(i32 -1, 3) i32 @find_range(ptr noundef nonnull writeonly captures(none) %0, ptr noundef nonnull writeonly captures(none) %1, i32 noundef %2) unnamed_addr #0 {
  %4 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %5 = getelementptr inbounds nuw i8, ptr %4, i32 8
  %6 = load ptr, ptr %5, align 4, !tbaa !45
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
  br label %14, !llvm.loop !144

23:                                               ; preds = %12
  %24 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %25 = getelementptr inbounds nuw i8, ptr %24, i32 36
  store i32 0, ptr %25, align 4, !tbaa !35
  br label %32

26:                                               ; preds = %14
  %27 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %28 = getelementptr inbounds nuw i8, ptr %27, i32 36
  %29 = load i32, ptr %28, align 4, !tbaa !35
  %30 = tail call i32 @llvm.umax.i32(i32 %29, i32 1)
  %31 = mul nsw i32 %30, %16
  store i32 %31, ptr %28, align 4, !tbaa !35
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
  %45 = load i32, ptr %44, align 4, !tbaa !35
  %46 = add nsw i32 %45, -1
  store i32 %46, ptr %44, align 4, !tbaa !35
  %47 = icmp sgt i32 %45, 1
  br i1 %47, label %48, label %139

48:                                               ; preds = %42
  tail call fastcc void @do_cmd(i32 noundef 106) #16
  %49 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %50 = getelementptr inbounds nuw i8, ptr %49, i32 128
  %51 = load i32, ptr %50, align 4, !tbaa !60
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
  %64 = load ptr, ptr %63, align 4, !tbaa !45
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
  %72 = load ptr, ptr %71, align 4, !tbaa !45
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
  %80 = load i8, ptr %72, align 1, !tbaa !26
  %81 = sext i8 %80 to i32
  %82 = tail call fastcc i32 @bb_ispunct(i32 noundef %81) #16
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %86, label %84

84:                                               ; preds = %79, %74
  %85 = getelementptr inbounds i8, ptr %72, i32 -1
  store ptr %85, ptr %71, align 4, !tbaa !45
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
  %93 = load i8, ptr %89, align 1, !tbaa !26
  %94 = sext i8 %93 to i32
  %95 = icmp ne i8 %93, 32
  %96 = add nsw i32 %94, -14
  %97 = icmp ult i32 %96, -5
  %98 = select i1 %95, i1 %97, i1 false
  br i1 %98, label %104, label %99

99:                                               ; preds = %92
  %100 = getelementptr inbounds i8, ptr %89, i32 -1
  store ptr %100, ptr %71, align 4, !tbaa !45
  %101 = load i8, ptr %89, align 1, !tbaa !26
  %102 = icmp eq i8 %101, 10
  %103 = select i1 %102, ptr %100, ptr %90
  br label %88, !llvm.loop !145

104:                                              ; preds = %88, %92
  %105 = icmp eq i32 %2, 99
  br i1 %105, label %139, label %106

106:                                              ; preds = %104
  %107 = icmp eq ptr %89, %90
  br i1 %107, label %139, label %108

108:                                              ; preds = %106
  %109 = load i8, ptr %89, align 1, !tbaa !26
  %110 = icmp eq i8 %109, 10
  br i1 %110, label %139, label %111

111:                                              ; preds = %108
  store ptr %90, ptr %71, align 4, !tbaa !45
  br label %139

112:                                              ; preds = %66
  %113 = tail call ptr @strchr(ptr noundef nonnull @.str.63, i8 noundef signext %54) #17
  %114 = icmp eq ptr %113, null
  br i1 %114, label %120, label %115

115:                                              ; preds = %112
  tail call fastcc void @do_cmd(i32 noundef %55) #16
  %116 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %117 = getelementptr inbounds nuw i8, ptr %116, i32 128
  %118 = load i32, ptr %117, align 4, !tbaa !60
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
  %124 = load i32, ptr %123, align 4, !tbaa !35
  %125 = tail call i32 @llvm.umax.i32(i32 %124, i32 1)
  tail call fastcc void @do_cmd(i32 noundef %55) #16
  %126 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %127 = getelementptr inbounds nuw i8, ptr %126, i32 8
  %128 = load ptr, ptr %127, align 4, !tbaa !45
  %129 = ptrtoint ptr %128 to i32
  %130 = ptrtoint ptr %6 to i32
  %131 = sub i32 %129, %130
  %132 = icmp eq i32 %125, %131
  br i1 %132, label %133, label %139

133:                                              ; preds = %121
  %134 = getelementptr inbounds i8, ptr %128, i32 -1
  store ptr %134, ptr %127, align 4, !tbaa !45
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
  %144 = load ptr, ptr %143, align 4, !tbaa !45
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
  %162 = load i8, ptr %147, align 1, !tbaa !26
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
  store ptr %146, ptr %0, align 4, !tbaa !20
  store ptr %179, ptr %1, align 4, !tbaa !20
  br label %181

181:                                              ; preds = %135, %138, %178
  %182 = phi i32 [ %180, %178 ], [ -1, %138 ], [ -1, %135 ]
  ret i32 %182
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_end() unnamed_addr #11 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = tail call fastcc ptr @end_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !45
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc noundef ptr @skip_thing(ptr noundef readonly captures(address, ret: address, provenance) %0, i32 noundef range(i32 1, 3) %1, i32 noundef range(i32 -1, 2) %2, i32 noundef range(i32 1, 6) %3) unnamed_addr #5 {
  %5 = icmp sgt i32 %2, -1
  %6 = load ptr, ptr @ptr_to_globals, align 4
  %7 = getelementptr inbounds nuw i8, ptr %6, i32 4
  %8 = load i8, ptr %0, align 1, !tbaa !26
  br label %9

9:                                                ; preds = %62, %4
  %10 = phi i8 [ %8, %4 ], [ %14, %62 ]
  %11 = phi i32 [ %1, %4 ], [ %57, %62 ]
  %12 = phi ptr [ %0, %4 ], [ %13, %62 ]
  %13 = getelementptr inbounds i8, ptr %12, i32 %2
  %14 = load i8, ptr %13, align 1, !tbaa !26
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
  %59 = load ptr, ptr %7, align 4, !tbaa !50
  %60 = getelementptr inbounds i8, ptr %59, i32 -1
  %61 = icmp ult ptr %12, %60
  br i1 %61, label %62, label %66

62:                                               ; preds = %58, %63
  br label %9, !llvm.loop !146

63:                                               ; preds = %56
  %64 = load ptr, ptr %6, align 4, !tbaa !31
  %65 = icmp ugt ptr %12, %64
  br i1 %65, label %62, label %66

66:                                               ; preds = %15, %23, %29, %33, %63, %58, %54, %43
  ret ptr %12
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, inaccessiblemem: none)
define internal fastcc ptr @end_screen() unnamed_addr #5 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 76
  %3 = load ptr, ptr %2, align 4, !tbaa !51
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 44
  %5 = load i32, ptr %4, align 4, !tbaa !22
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
  br label %7, !llvm.loop !147

14:                                               ; preds = %7
  %15 = tail call fastcc ptr @end_line(ptr noundef %8) #16
  ret ptr %15
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define internal fastcc void @dot_prev() unnamed_addr #11 {
  %1 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %2 = getelementptr inbounds nuw i8, ptr %1, i32 8
  %3 = load ptr, ptr %2, align 4, !tbaa !45
  %4 = tail call fastcc ptr @prev_line(ptr noundef %3) #16
  store ptr %4, ptr %2, align 4, !tbaa !45
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
define internal fastcc range(i32 0, 2) i32 @at_eof(ptr noundef readonly captures(address) %0) unnamed_addr #10 {
  %2 = load ptr, ptr @ptr_to_globals, align 4, !tbaa !3
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %4 = load ptr, ptr %3, align 4, !tbaa !50
  %5 = getelementptr inbounds i8, ptr %4, i32 -2
  %6 = icmp eq ptr %0, %5
  br i1 %6, label %7, label %11

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw i8, ptr %0, i32 1
  %9 = load i8, ptr %8, align 1, !tbaa !26
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
  %7 = load i32, ptr %6, align 4, !tbaa !22
  %8 = icmp ult i32 %4, %7
  %9 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %10 = getelementptr inbounds nuw i8, ptr %5, i32 48
  %11 = load i32, ptr %10, align 4, !tbaa !23
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
define internal void @bb_sprintf(ptr noundef nonnull writeonly captures(none) %0, ptr readnone captures(none) %1, ...) unnamed_addr #12 {
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
define internal i32 @bb_snprintf(ptr noundef writeonly captures(none) %0, i32 noundef range(i32 1, 201) %1, ptr readnone captures(none) %2, ...) unnamed_addr #12 {
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
attributes #6 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #7 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #8 = { mustprogress nocallback nofree nosync nounwind willreturn }
attributes #9 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #10 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(read, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #11 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #12 = { minsize nofree norecurse nosync nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #13 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
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
!9 = !{!"globals", !10, i64 0, !10, i64 4, !10, i64 8, !11, i64 12, !11, i64 16, !11, i64 20, !11, i64 24, !11, i64 28, !11, i64 32, !11, i64 36, !10, i64 40, !11, i64 44, !11, i64 48, !11, i64 52, !11, i64 56, !11, i64 60, !11, i64 64, !11, i64 68, !10, i64 72, !10, i64 76, !10, i64 80, !11, i64 84, !11, i64 88, !11, i64 92, !11, i64 96, !11, i64 100, !11, i64 104, !11, i64 108, !11, i64 112, !11, i64 116, !11, i64 120, !10, i64 124, !11, i64 128, !10, i64 132, !11, i64 136, !11, i64 140, !11, i64 144, !11, i64 148, !6, i64 152, !6, i64 264, !6, i64 292, !12, i64 404, !11, i64 408, !11, i64 412, !13, i64 416, !6, i64 420, !6, i64 436, !6, i64 636, !6, i64 764}
!10 = !{!"p1 omnipotent char", !5, i64 0}
!11 = !{!"int", !6, i64 0}
!12 = !{!"termios", !6, i64 0}
!13 = !{!"p1 _ZTS7llist_t", !5, i64 0}
!14 = !{!9, !11, i64 88}
!15 = !{!9, !11, i64 92}
!16 = !{!9, !10, i64 124}
!17 = !{!9, !11, i64 112}
!18 = !{!11, !11, i64 0}
!19 = !{!9, !11, i64 32}
!20 = !{!10, !10, i64 0}
!21 = !{!9, !11, i64 16}
!22 = !{!9, !11, i64 44}
!23 = !{!9, !11, i64 48}
!24 = !{!9, !10, i64 80}
!25 = !{!9, !11, i64 84}
!26 = !{!6, !6, i64 0}
!27 = distinct !{!27, !28, !29}
!28 = !{!"llvm.loop.mustprogress"}
!29 = !{!"llvm.loop.unroll.disable"}
!30 = !{!9, !11, i64 148}
!31 = !{!9, !10, i64 0}
!32 = !{!9, !11, i64 52}
!33 = !{!9, !11, i64 56}
!34 = !{!9, !11, i64 20}
!35 = !{!9, !11, i64 36}
!36 = !{!9, !11, i64 60}
!37 = distinct !{!37, !28, !29}
!38 = !{!9, !13, i64 416}
!39 = !{!40, !10, i64 4}
!40 = !{!"llist_t", !13, i64 0, !10, i64 4}
!41 = !{!40, !13, i64 0}
!42 = !{!13, !13, i64 0}
!43 = distinct !{!43, !28, !29}
!44 = distinct !{!44, !28, !29}
!45 = !{!9, !10, i64 8}
!46 = !{!9, !10, i64 132}
!47 = distinct !{!47, !28, !29}
!48 = distinct !{!48, !29}
!49 = !{!9, !11, i64 12}
!50 = !{!9, !10, i64 4}
!51 = !{!9, !10, i64 76}
!52 = !{!9, !11, i64 108}
!53 = !{!9, !11, i64 96}
!54 = !{!9, !11, i64 100}
!55 = !{!9, !11, i64 104}
!56 = !{!9, !11, i64 24}
!57 = !{!9, !11, i64 68}
!58 = distinct !{!58, !28, !29}
!59 = !{!9, !11, i64 412}
!60 = !{!9, !11, i64 128}
!61 = distinct !{!61, !28, !29}
!62 = distinct !{!62, !28, !29}
!63 = !{!9, !11, i64 408}
!64 = distinct !{!64, !28, !29}
!65 = distinct !{!65, !28, !29}
!66 = distinct !{!66, !29}
!67 = distinct !{!67, !29}
!68 = distinct !{!68, !28, !29}
!69 = !{!9, !11, i64 116}
!70 = !{!9, !11, i64 120}
!71 = distinct !{!71, !28, !29}
!72 = distinct !{!72, !28, !29}
!73 = distinct !{!73, !28, !29}
!74 = distinct !{!74, !28, !29}
!75 = distinct !{!75, !28, !29}
!76 = distinct !{!76, !28, !29}
!77 = distinct !{!77, !28, !29}
!78 = distinct !{!78, !28, !29}
!79 = distinct !{!79, !28, !29}
!80 = distinct !{!80, !28, !29}
!81 = distinct !{!81, !28, !29}
!82 = !{!9, !10, i64 40}
!83 = distinct !{!83, !28, !29}
!84 = !{!9, !10, i64 72}
!85 = distinct !{!85, !28, !29}
!86 = distinct !{!86, !28, !29}
!87 = distinct !{!87, !28, !29}
!88 = distinct !{!88, !28, !29}
!89 = distinct !{!89, !28, !29}
!90 = distinct !{!90, !28, !29}
!91 = distinct !{!91, !28, !29}
!92 = distinct !{!92, !28, !29}
!93 = distinct !{!93, !28, !29}
!94 = !{!9, !11, i64 136}
!95 = !{!9, !11, i64 140}
!96 = distinct !{!96, !28, !29}
!97 = distinct !{!97, !28, !29}
!98 = distinct !{!98, !28, !29}
!99 = distinct !{!99, !28, !29}
!100 = distinct !{!100, !28, !29}
!101 = !{!9, !11, i64 64}
!102 = !{!9, !11, i64 144}
!103 = distinct !{!103, !28, !29}
!104 = !{!105, !106, i64 8}
!105 = !{!"stat", !11, i64 0, !11, i64 4, !106, i64 8, !106, i64 10, !107, i64 12}
!106 = !{!"short", !6, i64 0}
!107 = !{!"long", !6, i64 0}
!108 = !{!105, !107, i64 12}
!109 = distinct !{!109, !28, !29}
!110 = distinct !{!110, !28, !29}
!111 = distinct !{!111, !28, !29}
!112 = distinct !{!112, !28, !29}
!113 = distinct !{!113, !28, !29}
!114 = distinct !{!114, !28, !29}
!115 = distinct !{!115, !28, !29}
!116 = distinct !{!116, !28, !29}
!117 = distinct !{!117, !28, !29}
!118 = distinct !{!118, !28, !29}
!119 = distinct !{!119, !28, !29}
!120 = distinct !{!120, !28, !29}
!121 = distinct !{!121, !28, !29}
!122 = distinct !{!122, !28, !29}
!123 = distinct !{!123, !29}
!124 = distinct !{!124, !29}
!125 = distinct !{!125, !28, !29}
!126 = distinct !{!126, !28, !29}
!127 = distinct !{!127, !28, !29}
!128 = distinct !{!128, !28, !29}
!129 = distinct !{!129, !28, !29}
!130 = distinct !{!130, !28, !29}
!131 = distinct !{!131, !28, !29}
!132 = distinct !{!132, !28, !29}
!133 = distinct !{!133, !28, !29}
!134 = distinct !{!134, !28, !29}
!135 = distinct !{!135, !28, !29}
!136 = distinct !{!136, !28, !29}
!137 = distinct !{!137, !28, !29}
!138 = distinct !{!138, !28, !29}
!139 = distinct !{!139, !28, !29}
!140 = distinct !{!140, !28, !29}
!141 = distinct !{!141, !28, !29}
!142 = distinct !{!142, !28, !29}
!143 = distinct !{!143, !28, !29}
!144 = distinct !{!144, !28, !29}
!145 = distinct !{!145, !28, !29}
!146 = distinct !{!146, !28, !29}
!147 = distinct !{!147, !28, !29}
