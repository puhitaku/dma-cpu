; ModuleID = 'user/sh.c'
source_filename = "user/sh.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [7 x i8] c"runcmd\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"exec \00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c" failed\0A\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"open \00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"pipe\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"$ \00", align 1
@main.buf = internal global [100 x i8] zeroinitializer, align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"console\00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c"cannot cd \00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"fork\00", align 1
@whitespace = dso_local global [6 x i8] c" \09\0D\0A\0B\00", align 1
@symbols = dso_local global [8 x i8] c"<|>&;()\00", align 1
@.str.10 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"leftovers: \00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"syntax\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"&\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c";\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@.str.16 = private unnamed_addr constant [3 x i8] c"<>\00", align 1
@.str.17 = private unnamed_addr constant [29 x i8] c"missing file for redirection\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str.19 = private unnamed_addr constant [11 x i8] c"parseblock\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.21 = private unnamed_addr constant [19 x i8] c"syntax - missing )\00", align 1
@.str.22 = private unnamed_addr constant [5 x i8] c"|)&;\00", align 1
@.str.23 = private unnamed_addr constant [14 x i8] c"too many args\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @runcmd(ptr noundef %0) local_unnamed_addr #0 {
  %2 = alloca [2 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #6
  %3 = icmp eq ptr %0, null
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  %5 = tail call i32 @exit(i32 noundef 1) #7
  unreachable

6:                                                ; preds = %1
  %7 = load i32, ptr %0, align 4, !tbaa !3
  switch i32 %7, label %8 [
    i32 1, label %9
    i32 2, label %18
    i32 4, label %34
    i32 3, label %44
    i32 5, label %84
  ]

8:                                                ; preds = %6
  tail call void @panic(ptr noundef nonnull @.str) #8
  unreachable

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %11 = load ptr, ptr %10, align 4, !tbaa !8
  %12 = icmp eq ptr %11, null
  br i1 %12, label %13, label %15

13:                                               ; preds = %9
  %14 = tail call i32 @exit(i32 noundef 1) #7
  unreachable

15:                                               ; preds = %9
  %16 = tail call i32 @exec(ptr noundef nonnull %11, ptr noundef nonnull %10) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.1) #9
  %17 = load ptr, ptr %10, align 4, !tbaa !8
  tail call void @fputstr(i32 noundef 2, ptr noundef %17) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.2) #9
  br label %90

18:                                               ; preds = %6
  %19 = getelementptr inbounds nuw i8, ptr %0, i32 20
  %20 = load i32, ptr %19, align 4, !tbaa !11
  %21 = tail call i32 @close(i32 noundef %20) #9
  %22 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %23 = load ptr, ptr %22, align 4, !tbaa !14
  %24 = getelementptr inbounds nuw i8, ptr %0, i32 16
  %25 = load i32, ptr %24, align 4, !tbaa !15
  %26 = tail call i32 @open(ptr noundef %23, i32 noundef %25) #9
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %31

28:                                               ; preds = %18
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.3) #9
  %29 = load ptr, ptr %22, align 4, !tbaa !14
  tail call void @fputstr(i32 noundef 2, ptr noundef %29) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.2) #9
  %30 = tail call i32 @exit(i32 noundef 1) #7
  unreachable

31:                                               ; preds = %18
  %32 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %33 = load ptr, ptr %32, align 4, !tbaa !16
  tail call void @runcmd(ptr noundef %33) #10
  unreachable

34:                                               ; preds = %6
  %35 = tail call i32 @fork1() #8
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %37, label %40

37:                                               ; preds = %34
  %38 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %39 = load ptr, ptr %38, align 4, !tbaa !17
  tail call void @runcmd(ptr noundef %39) #10
  unreachable

40:                                               ; preds = %34
  %41 = tail call i32 @wait(ptr noundef null) #9
  %42 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %43 = load ptr, ptr %42, align 4, !tbaa !19
  tail call void @runcmd(ptr noundef %43) #10
  unreachable

44:                                               ; preds = %6
  %45 = call i32 @pipe(ptr noundef nonnull %2) #9
  %46 = icmp slt i32 %45, 0
  br i1 %46, label %47, label %48

47:                                               ; preds = %44
  call void @panic(ptr noundef nonnull @.str.4) #8
  unreachable

48:                                               ; preds = %44
  %49 = call i32 @fork1() #8
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %51, label %62

51:                                               ; preds = %48
  %52 = call i32 @close(i32 noundef 1) #9
  %53 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %54 = load i32, ptr %53, align 4, !tbaa !20
  %55 = call i32 @dup(i32 noundef %54) #9
  %56 = load i32, ptr %2, align 4, !tbaa !20
  %57 = call i32 @close(i32 noundef %56) #9
  %58 = load i32, ptr %53, align 4, !tbaa !20
  %59 = call i32 @close(i32 noundef %58) #9
  %60 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %61 = load ptr, ptr %60, align 4, !tbaa !21
  call void @runcmd(ptr noundef %61) #10
  unreachable

62:                                               ; preds = %48
  %63 = call i32 @fork1() #8
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %65, label %76

65:                                               ; preds = %62
  %66 = call i32 @close(i32 noundef 0) #9
  %67 = load i32, ptr %2, align 4, !tbaa !20
  %68 = call i32 @dup(i32 noundef %67) #9
  %69 = load i32, ptr %2, align 4, !tbaa !20
  %70 = call i32 @close(i32 noundef %69) #9
  %71 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %72 = load i32, ptr %71, align 4, !tbaa !20
  %73 = call i32 @close(i32 noundef %72) #9
  %74 = getelementptr inbounds nuw i8, ptr %0, i32 8
  %75 = load ptr, ptr %74, align 4, !tbaa !23
  call void @runcmd(ptr noundef %75) #10
  unreachable

76:                                               ; preds = %62
  %77 = load i32, ptr %2, align 4, !tbaa !20
  %78 = call i32 @close(i32 noundef %77) #9
  %79 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %80 = load i32, ptr %79, align 4, !tbaa !20
  %81 = call i32 @close(i32 noundef %80) #9
  %82 = call i32 @wait(ptr noundef null) #9
  %83 = call i32 @wait(ptr noundef null) #9
  br label %90

84:                                               ; preds = %6
  %85 = tail call i32 @fork1() #8
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %87, label %90

87:                                               ; preds = %84
  %88 = getelementptr inbounds nuw i8, ptr %0, i32 4
  %89 = load ptr, ptr %88, align 4, !tbaa !24
  tail call void @runcmd(ptr noundef %89) #10
  unreachable

90:                                               ; preds = %84, %76, %15
  %91 = call i32 @exit(i32 noundef 0) #7
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @panic(ptr noundef %0) local_unnamed_addr #0 {
  tail call void @fputstr(i32 noundef 2, ptr noundef %0) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.8) #9
  %2 = tail call i32 @exit(i32 noundef 1) #7
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @exec(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fputstr(i32 noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 0, -1) i32 @fork1() local_unnamed_addr #4 {
  %1 = tail call i32 @fork() #9
  %2 = icmp eq i32 %1, -1
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call void @panic(ptr noundef nonnull @.str.9) #8
  unreachable

4:                                                ; preds = %0
  ret i32 %1
}

; Function Attrs: minsize optsize
declare dso_local i32 @wait(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @pipe(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @dup(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 -1, 1) i32 @getcmd(ptr noundef %0, i32 noundef %1) local_unnamed_addr #4 {
  %3 = tail call ptr @memset(ptr noundef %0, i32 noundef 0, i32 noundef %1) #9
  %4 = tail call ptr @readline(ptr noundef nonnull @.str.5, ptr noundef %0, i32 noundef %1) #9
  %5 = load i8, ptr %0, align 1, !tbaa !26
  %6 = icmp eq i8 %5, 0
  %7 = sext i1 %6 to i32
  ret i32 %7
}

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local ptr @readline(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %4, %0
  %2 = tail call i32 @open(ptr noundef nonnull @.str.6, i32 noundef 2) #9
  %3 = icmp sgt i32 %2, -1
  br i1 %3, label %4, label %8

4:                                                ; preds = %1
  %5 = icmp samesign ugt i32 %2, 2
  br i1 %5, label %6, label %1, !llvm.loop !27

6:                                                ; preds = %4
  %7 = tail call i32 @close(i32 noundef %2) #9
  br label %8

8:                                                ; preds = %1, %6
  br label %9

9:                                                ; preds = %40, %8
  %10 = tail call i32 @getcmd(ptr noundef nonnull @main.buf, i32 noundef 100) #8
  %11 = icmp sgt i32 %10, -1
  br i1 %11, label %12, label %41

12:                                               ; preds = %9, %15
  %13 = phi ptr [ %16, %15 ], [ @main.buf, %9 ]
  %14 = load i8, ptr %13, align 1, !tbaa !26
  switch i8 %14, label %33 [
    i8 32, label %15
    i8 9, label %15
    i8 10, label %40
    i8 99, label %17
  ]

15:                                               ; preds = %12, %12
  %16 = getelementptr inbounds nuw i8, ptr %13, i32 1
  br label %12, !llvm.loop !30

17:                                               ; preds = %12
  %18 = getelementptr inbounds nuw i8, ptr %13, i32 1
  %19 = load i8, ptr %18, align 1, !tbaa !26
  %20 = icmp eq i8 %19, 100
  br i1 %20, label %21, label %33

21:                                               ; preds = %17
  %22 = getelementptr inbounds nuw i8, ptr %13, i32 2
  %23 = load i8, ptr %22, align 1, !tbaa !26
  %24 = icmp eq i8 %23, 32
  br i1 %24, label %25, label %33

25:                                               ; preds = %21
  %26 = tail call i32 @strlen(ptr noundef nonnull %13) #9
  %27 = getelementptr i8, ptr %13, i32 %26
  %28 = getelementptr i8, ptr %27, i32 -1
  store i8 0, ptr %28, align 1, !tbaa !26
  %29 = getelementptr inbounds nuw i8, ptr %13, i32 3
  %30 = tail call i32 @chdir(ptr noundef nonnull %29) #9
  %31 = icmp slt i32 %30, 0
  br i1 %31, label %32, label %40

32:                                               ; preds = %25
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.7) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull %29) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.8) #9
  br label %40

33:                                               ; preds = %12, %21, %17
  %34 = tail call i32 @fork1() #8
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %38

36:                                               ; preds = %33
  %37 = tail call ptr @parsecmd(ptr noundef nonnull %13) #8
  tail call void @runcmd(ptr noundef %37) #10
  unreachable

38:                                               ; preds = %33
  %39 = tail call i32 @wait(ptr noundef null) #9
  br label %40

40:                                               ; preds = %12, %38, %32, %25
  br label %9

41:                                               ; preds = %9
  %42 = tail call i32 @exit(i32 noundef 0) #7
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @strlen(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @chdir(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local ptr @parsecmd(ptr noundef %0) local_unnamed_addr #4 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4, !tbaa !8
  %3 = tail call i32 @strlen(ptr noundef %0) #9
  %4 = getelementptr inbounds nuw i8, ptr %0, i32 %3
  %5 = call ptr @parseline(ptr noundef nonnull %2, ptr noundef %4) #8
  %6 = call i32 @peek(ptr noundef nonnull %2, ptr noundef %4, ptr noundef nonnull @.str.10) #8
  %7 = load ptr, ptr %2, align 4, !tbaa !8
  %8 = icmp eq ptr %7, %4
  br i1 %8, label %10, label %9

9:                                                ; preds = %1
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.11) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef %7) #9
  tail call void @fputstr(i32 noundef 2, ptr noundef nonnull @.str.8) #9
  tail call void @panic(ptr noundef nonnull @.str.12) #8
  unreachable

10:                                               ; preds = %1
  %11 = tail call ptr @nulterminate(ptr noundef %5) #8
  ret ptr %5
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @fork() local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @execcmd() local_unnamed_addr #4 {
  %1 = tail call ptr @malloc(i32 noundef 84) #9
  %2 = tail call ptr @memset(ptr noundef %1, i32 noundef 0, i32 noundef 84) #9
  store i32 1, ptr %1, align 4, !tbaa !31
  ret ptr %1
}

; Function Attrs: minsize optsize
declare dso_local ptr @malloc(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @redircmd(ptr noundef %0, ptr noundef %1, ptr noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #4 {
  %6 = tail call ptr @malloc(i32 noundef 24) #9
  %7 = tail call ptr @memset(ptr noundef %6, i32 noundef 0, i32 noundef 24) #9
  store i32 2, ptr %6, align 4, !tbaa !33
  %8 = getelementptr inbounds nuw i8, ptr %6, i32 4
  store ptr %0, ptr %8, align 4, !tbaa !16
  %9 = getelementptr inbounds nuw i8, ptr %6, i32 8
  store ptr %1, ptr %9, align 4, !tbaa !14
  %10 = getelementptr inbounds nuw i8, ptr %6, i32 12
  store ptr %2, ptr %10, align 4, !tbaa !34
  %11 = getelementptr inbounds nuw i8, ptr %6, i32 16
  store i32 %3, ptr %11, align 4, !tbaa !15
  %12 = getelementptr inbounds nuw i8, ptr %6, i32 20
  store i32 %4, ptr %12, align 4, !tbaa !11
  ret ptr %6
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @pipecmd(ptr noundef %0, ptr noundef %1) local_unnamed_addr #4 {
  %3 = tail call ptr @malloc(i32 noundef 12) #9
  %4 = tail call ptr @memset(ptr noundef %3, i32 noundef 0, i32 noundef 12) #9
  store i32 3, ptr %3, align 4, !tbaa !35
  %5 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store ptr %0, ptr %5, align 4, !tbaa !21
  %6 = getelementptr inbounds nuw i8, ptr %3, i32 8
  store ptr %1, ptr %6, align 4, !tbaa !23
  ret ptr %3
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @listcmd(ptr noundef %0, ptr noundef %1) local_unnamed_addr #4 {
  %3 = tail call ptr @malloc(i32 noundef 12) #9
  %4 = tail call ptr @memset(ptr noundef %3, i32 noundef 0, i32 noundef 12) #9
  store i32 4, ptr %3, align 4, !tbaa !36
  %5 = getelementptr inbounds nuw i8, ptr %3, i32 4
  store ptr %0, ptr %5, align 4, !tbaa !17
  %6 = getelementptr inbounds nuw i8, ptr %3, i32 8
  store ptr %1, ptr %6, align 4, !tbaa !19
  ret ptr %3
}

; Function Attrs: minsize nounwind optsize
define dso_local noundef ptr @backcmd(ptr noundef %0) local_unnamed_addr #4 {
  %2 = tail call ptr @malloc(i32 noundef 8) #9
  %3 = tail call ptr @memset(ptr noundef %2, i32 noundef 0, i32 noundef 8) #9
  store i32 5, ptr %2, align 4, !tbaa !37
  %4 = getelementptr inbounds nuw i8, ptr %2, i32 4
  store ptr %0, ptr %4, align 4, !tbaa !24
  ret ptr %2
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 0, 128) i32 @gettoken(ptr noundef captures(none) %0, ptr noundef readnone captures(address) %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3) local_unnamed_addr #4 {
  %5 = load ptr, ptr %0, align 4, !tbaa !8
  br label %6

6:                                                ; preds = %13, %4
  %7 = phi ptr [ %5, %4 ], [ %14, %13 ]
  %8 = icmp ult ptr %7, %1
  br i1 %8, label %9, label %15

9:                                                ; preds = %6
  %10 = load i8, ptr %7, align 1, !tbaa !26
  %11 = tail call ptr @strchr(ptr noundef nonnull @whitespace, i8 noundef signext %10) #9
  %12 = icmp eq ptr %11, null
  br i1 %12, label %15, label %13

13:                                               ; preds = %9
  %14 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %6, !llvm.loop !38

15:                                               ; preds = %6, %9
  %16 = icmp eq ptr %2, null
  br i1 %16, label %18, label %17

17:                                               ; preds = %15
  store ptr %7, ptr %2, align 4, !tbaa !8
  br label %18

18:                                               ; preds = %17, %15
  %19 = load i8, ptr %7, align 1, !tbaa !26
  switch i8 %19, label %29 [
    i8 0, label %42
    i8 124, label %20
    i8 40, label %20
    i8 41, label %20
    i8 59, label %20
    i8 38, label %20
    i8 60, label %20
    i8 62, label %23
  ]

20:                                               ; preds = %18, %18, %18, %18, %18, %18
  %21 = zext nneg i8 %19 to i32
  %22 = getelementptr inbounds nuw i8, ptr %7, i32 1
  br label %42

23:                                               ; preds = %18
  %24 = getelementptr inbounds nuw i8, ptr %7, i32 1
  %25 = load i8, ptr %24, align 1, !tbaa !26
  %26 = icmp eq i8 %25, 62
  br i1 %26, label %27, label %42

27:                                               ; preds = %23
  %28 = getelementptr inbounds nuw i8, ptr %7, i32 2
  br label %42

29:                                               ; preds = %18, %40
  %30 = phi ptr [ %41, %40 ], [ %7, %18 ]
  %31 = icmp ult ptr %30, %1
  br i1 %31, label %32, label %42

32:                                               ; preds = %29
  %33 = load i8, ptr %30, align 1, !tbaa !26
  %34 = tail call ptr @strchr(ptr noundef nonnull @whitespace, i8 noundef signext %33) #9
  %35 = icmp eq ptr %34, null
  br i1 %35, label %36, label %42

36:                                               ; preds = %32
  %37 = load i8, ptr %30, align 1, !tbaa !26
  %38 = tail call ptr @strchr(ptr noundef nonnull @symbols, i8 noundef signext %37) #9
  %39 = icmp eq ptr %38, null
  br i1 %39, label %40, label %42

40:                                               ; preds = %36
  %41 = getelementptr inbounds nuw i8, ptr %30, i32 1
  br label %29, !llvm.loop !39

42:                                               ; preds = %36, %29, %32, %23, %27, %20, %18
  %43 = phi ptr [ %7, %18 ], [ %22, %20 ], [ %28, %27 ], [ %24, %23 ], [ %30, %32 ], [ %30, %29 ], [ %30, %36 ]
  %44 = phi i32 [ 0, %18 ], [ %21, %20 ], [ 43, %27 ], [ 62, %23 ], [ 97, %32 ], [ 97, %29 ], [ 97, %36 ]
  %45 = icmp eq ptr %3, null
  br i1 %45, label %47, label %46

46:                                               ; preds = %42
  store ptr %43, ptr %3, align 4, !tbaa !8
  br label %47

47:                                               ; preds = %46, %42
  br label %48

48:                                               ; preds = %47, %55
  %49 = phi ptr [ %56, %55 ], [ %43, %47 ]
  %50 = icmp ult ptr %49, %1
  br i1 %50, label %51, label %57

51:                                               ; preds = %48
  %52 = load i8, ptr %49, align 1, !tbaa !26
  %53 = tail call ptr @strchr(ptr noundef nonnull @whitespace, i8 noundef signext %52) #9
  %54 = icmp eq ptr %53, null
  br i1 %54, label %57, label %55

55:                                               ; preds = %51
  %56 = getelementptr inbounds nuw i8, ptr %49, i32 1
  br label %48, !llvm.loop !40

57:                                               ; preds = %48, %51
  store ptr %49, ptr %0, align 4, !tbaa !8
  ret i32 %44
}

; Function Attrs: minsize optsize
declare dso_local ptr @strchr(ptr noundef, i8 noundef signext) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 0, 2) i32 @peek(ptr noundef captures(none) %0, ptr noundef readnone captures(address) %1, ptr noundef %2) local_unnamed_addr #4 {
  %4 = load ptr, ptr %0, align 4, !tbaa !8
  br label %5

5:                                                ; preds = %12, %3
  %6 = phi ptr [ %4, %3 ], [ %13, %12 ]
  %7 = icmp ult ptr %6, %1
  br i1 %7, label %8, label %14

8:                                                ; preds = %5
  %9 = load i8, ptr %6, align 1, !tbaa !26
  %10 = tail call ptr @strchr(ptr noundef nonnull @whitespace, i8 noundef signext %9) #9
  %11 = icmp eq ptr %10, null
  br i1 %11, label %14, label %12

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %6, i32 1
  br label %5, !llvm.loop !41

14:                                               ; preds = %5, %8
  store ptr %6, ptr %0, align 4, !tbaa !8
  %15 = load i8, ptr %6, align 1, !tbaa !26
  %16 = icmp eq i8 %15, 0
  br i1 %16, label %21, label %17

17:                                               ; preds = %14
  %18 = tail call ptr @strchr(ptr noundef %2, i8 noundef signext %15) #9
  %19 = icmp ne ptr %18, null
  %20 = zext i1 %19 to i32
  br label %21

21:                                               ; preds = %17, %14
  %22 = phi i32 [ 0, %14 ], [ %20, %17 ]
  ret i32 %22
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @parseline(ptr noundef captures(none) %0, ptr noundef readnone captures(address) %1) local_unnamed_addr #4 {
  %3 = tail call ptr @parsepipe(ptr noundef %0, ptr noundef %1) #8
  br label %4

4:                                                ; preds = %8, %2
  %5 = phi ptr [ %3, %2 ], [ %10, %8 ]
  %6 = tail call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.13) #8
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %11, label %8

8:                                                ; preds = %4
  %9 = tail call i32 @gettoken(ptr noundef %0, ptr noundef %1, ptr noundef null, ptr noundef null) #8
  %10 = tail call ptr @backcmd(ptr noundef %5) #8
  br label %4, !llvm.loop !42

11:                                               ; preds = %4
  %12 = tail call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.14) #8
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11, %16
  %15 = phi ptr [ %19, %16 ], [ %5, %11 ]
  ret ptr %15

16:                                               ; preds = %11
  %17 = tail call i32 @gettoken(ptr noundef %0, ptr noundef %1, ptr noundef null, ptr noundef null) #8
  %18 = tail call ptr @parseline(ptr noundef %0, ptr noundef %1) #8
  %19 = tail call ptr @listcmd(ptr noundef %5, ptr noundef %18) #8
  br label %14
}

; Function Attrs: minsize nofree nosync nounwind optsize memory(readwrite, inaccessiblemem: none)
define dso_local noundef ptr @nulterminate(ptr noundef readonly returned captures(address_is_null, ret: address, provenance) %0) local_unnamed_addr #5 {
  br label %2

2:                                                ; preds = %31, %1
  %3 = phi ptr [ %0, %1 ], [ %34, %31 ]
  %4 = icmp eq ptr %3, null
  br i1 %4, label %19, label %5

5:                                                ; preds = %2
  %6 = load i32, ptr %3, align 4, !tbaa !3
  switch i32 %6, label %19 [
    i32 1, label %7
    i32 2, label %21
    i32 3, label %27
    i32 4, label %27
    i32 5, label %31
  ]

7:                                                ; preds = %5
  %8 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 44
  br label %10

10:                                               ; preds = %7, %15
  %11 = phi i32 [ %18, %15 ], [ 0, %7 ]
  %12 = getelementptr inbounds nuw [10 x ptr], ptr %8, i32 0, i32 %11
  %13 = load ptr, ptr %12, align 4, !tbaa !8
  %14 = icmp eq ptr %13, null
  br i1 %14, label %19, label %15

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw [10 x ptr], ptr %9, i32 0, i32 %11
  %17 = load ptr, ptr %16, align 4, !tbaa !8
  store i8 0, ptr %17, align 1, !tbaa !26
  %18 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !43

19:                                               ; preds = %10, %5, %2, %21
  %20 = phi ptr [ %0, %21 ], [ %0, %2 ], [ %0, %5 ], [ %0, %10 ]
  ret ptr %20

21:                                               ; preds = %5
  %22 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %23 = load ptr, ptr %22, align 4, !tbaa !16
  %24 = tail call ptr @nulterminate(ptr noundef %23) #8
  %25 = getelementptr inbounds nuw i8, ptr %3, i32 12
  %26 = load ptr, ptr %25, align 4, !tbaa !34
  store i8 0, ptr %26, align 1, !tbaa !26
  br label %19

27:                                               ; preds = %5, %5
  %28 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %29 = load ptr, ptr %28, align 4, !tbaa !44
  %30 = tail call ptr @nulterminate(ptr noundef %29) #8
  br label %31

31:                                               ; preds = %27, %5
  %32 = phi i32 [ 4, %5 ], [ 8, %27 ]
  %33 = getelementptr inbounds nuw i8, ptr %3, i32 %32
  %34 = load ptr, ptr %33, align 4, !tbaa !44
  br label %2
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @parsepipe(ptr noundef captures(none) %0, ptr noundef readnone captures(address) %1) local_unnamed_addr #4 {
  %3 = tail call ptr @parseexec(ptr noundef %0, ptr noundef %1) #8
  %4 = tail call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.15) #8
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %2, %8
  %7 = phi ptr [ %11, %8 ], [ %3, %2 ]
  ret ptr %7

8:                                                ; preds = %2
  %9 = tail call i32 @gettoken(ptr noundef %0, ptr noundef %1, ptr noundef null, ptr noundef null) #8
  %10 = tail call ptr @parsepipe(ptr noundef %0, ptr noundef %1) #8
  %11 = tail call ptr @pipecmd(ptr noundef %3, ptr noundef %10) #8
  br label %6
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @parseexec(ptr noundef captures(none) %0, ptr noundef readnone captures(address) %1) local_unnamed_addr #4 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #6
  %5 = tail call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.18) #8
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %9, label %7

7:                                                ; preds = %2
  %8 = tail call ptr @parseblock(ptr noundef %0, ptr noundef %1) #8
  br label %35

9:                                                ; preds = %2
  %10 = tail call ptr @execcmd() #8
  %11 = tail call ptr @parseredirs(ptr noundef %10, ptr noundef %0, ptr noundef %1) #8
  %12 = getelementptr inbounds nuw i8, ptr %10, i32 4
  %13 = getelementptr inbounds nuw i8, ptr %10, i32 44
  br label %14

14:                                               ; preds = %29, %9
  %15 = phi i32 [ 0, %9 ], [ %30, %29 ]
  %16 = phi ptr [ %11, %9 ], [ %31, %29 ]
  %17 = call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.22) #8
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %32

19:                                               ; preds = %14
  %20 = call i32 @gettoken(ptr noundef %0, ptr noundef %1, ptr noundef nonnull %3, ptr noundef nonnull %4) #8
  switch i32 %20, label %21 [
    i32 0, label %32
    i32 97, label %22
  ]

21:                                               ; preds = %19
  call void @panic(ptr noundef nonnull @.str.12) #8
  unreachable

22:                                               ; preds = %19
  %23 = load ptr, ptr %3, align 4, !tbaa !8
  %24 = getelementptr inbounds nuw [10 x ptr], ptr %12, i32 0, i32 %15
  store ptr %23, ptr %24, align 4, !tbaa !8
  %25 = load ptr, ptr %4, align 4, !tbaa !8
  %26 = getelementptr inbounds nuw [10 x ptr], ptr %13, i32 0, i32 %15
  store ptr %25, ptr %26, align 4, !tbaa !8
  %27 = icmp eq i32 %15, 9
  br i1 %27, label %28, label %29

28:                                               ; preds = %22
  call void @panic(ptr noundef nonnull @.str.23) #8
  unreachable

29:                                               ; preds = %22
  %30 = add nuw nsw i32 %15, 1
  %31 = call ptr @parseredirs(ptr noundef %16, ptr noundef %0, ptr noundef %1) #8
  br label %14, !llvm.loop !45

32:                                               ; preds = %19, %14
  %33 = getelementptr inbounds nuw [10 x ptr], ptr %12, i32 0, i32 %15
  store ptr null, ptr %33, align 4, !tbaa !8
  %34 = getelementptr inbounds nuw [10 x ptr], ptr %13, i32 0, i32 %15
  store ptr null, ptr %34, align 4, !tbaa !8
  br label %35

35:                                               ; preds = %32, %7
  %36 = phi ptr [ %8, %7 ], [ %16, %32 ]
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6
  ret ptr %36
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @parseredirs(ptr noundef %0, ptr noundef captures(none) %1, ptr noundef readnone captures(address) %2) local_unnamed_addr #4 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #6
  br label %6

6:                                                ; preds = %21, %3
  %7 = phi ptr [ %0, %3 ], [ %22, %21 ]
  br label %8

8:                                                ; preds = %6, %16
  %9 = call i32 @peek(ptr noundef %1, ptr noundef %2, ptr noundef nonnull @.str.16) #8
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %31, label %11

11:                                               ; preds = %8
  %12 = call i32 @gettoken(ptr noundef %1, ptr noundef %2, ptr noundef null, ptr noundef null) #8
  %13 = call i32 @gettoken(ptr noundef %1, ptr noundef %2, ptr noundef nonnull %4, ptr noundef nonnull %5) #8
  %14 = icmp eq i32 %13, 97
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  call void @panic(ptr noundef nonnull @.str.17) #8
  unreachable

16:                                               ; preds = %11
  switch i32 %12, label %8 [
    i32 60, label %17
    i32 62, label %23
    i32 43, label %27
  ], !llvm.loop !46

17:                                               ; preds = %16
  %18 = load ptr, ptr %4, align 4, !tbaa !8
  %19 = load ptr, ptr %5, align 4, !tbaa !8
  %20 = call ptr @redircmd(ptr noundef %7, ptr noundef %18, ptr noundef %19, i32 noundef 0, i32 noundef 0) #8
  br label %21

21:                                               ; preds = %17, %23, %27
  %22 = phi ptr [ %30, %27 ], [ %26, %23 ], [ %20, %17 ]
  br label %6, !llvm.loop !46

23:                                               ; preds = %16
  %24 = load ptr, ptr %4, align 4, !tbaa !8
  %25 = load ptr, ptr %5, align 4, !tbaa !8
  %26 = call ptr @redircmd(ptr noundef %7, ptr noundef %24, ptr noundef %25, i32 noundef 1537, i32 noundef 1) #8
  br label %21

27:                                               ; preds = %16
  %28 = load ptr, ptr %4, align 4, !tbaa !8
  %29 = load ptr, ptr %5, align 4, !tbaa !8
  %30 = call ptr @redircmd(ptr noundef %7, ptr noundef %28, ptr noundef %29, i32 noundef 513, i32 noundef 1) #8
  br label %21

31:                                               ; preds = %8
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #6
  ret ptr %7
}

; Function Attrs: minsize nounwind optsize
define dso_local ptr @parseblock(ptr noundef captures(none) %0, ptr noundef readnone captures(address) %1) local_unnamed_addr #4 {
  %3 = tail call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.18) #8
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  tail call void @panic(ptr noundef nonnull @.str.19) #8
  unreachable

6:                                                ; preds = %2
  %7 = tail call i32 @gettoken(ptr noundef %0, ptr noundef %1, ptr noundef null, ptr noundef null) #8
  %8 = tail call ptr @parseline(ptr noundef %0, ptr noundef %1) #8
  %9 = tail call i32 @peek(ptr noundef %0, ptr noundef %1, ptr noundef nonnull @.str.20) #8
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %12

11:                                               ; preds = %6
  tail call void @panic(ptr noundef nonnull @.str.21) #8
  unreachable

12:                                               ; preds = %6
  %13 = tail call i32 @gettoken(ptr noundef %0, ptr noundef %1, ptr noundef null, ptr noundef null) #8
  %14 = tail call ptr @parseredirs(ptr noundef %8, ptr noundef %0, ptr noundef %1) #8
  ret ptr %14
}

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize nofree nosync nounwind optsize memory(readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { nounwind }
attributes #7 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }
attributes #9 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #10 = { minsize nobuiltin noreturn optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"cmd", !5, i64 0}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"p1 omnipotent char", !10, i64 0}
!10 = !{!"any pointer", !6, i64 0}
!11 = !{!12, !5, i64 20}
!12 = !{!"redircmd", !5, i64 0, !13, i64 4, !9, i64 8, !9, i64 12, !5, i64 16, !5, i64 20}
!13 = !{!"p1 _ZTS3cmd", !10, i64 0}
!14 = !{!12, !9, i64 8}
!15 = !{!12, !5, i64 16}
!16 = !{!12, !13, i64 4}
!17 = !{!18, !13, i64 4}
!18 = !{!"listcmd", !5, i64 0, !13, i64 4, !13, i64 8}
!19 = !{!18, !13, i64 8}
!20 = !{!5, !5, i64 0}
!21 = !{!22, !13, i64 4}
!22 = !{!"pipecmd", !5, i64 0, !13, i64 4, !13, i64 8}
!23 = !{!22, !13, i64 8}
!24 = !{!25, !13, i64 4}
!25 = !{!"backcmd", !5, i64 0, !13, i64 4}
!26 = !{!6, !6, i64 0}
!27 = distinct !{!27, !28, !29}
!28 = !{!"llvm.loop.mustprogress"}
!29 = !{!"llvm.loop.unroll.disable"}
!30 = distinct !{!30, !28, !29}
!31 = !{!32, !5, i64 0}
!32 = !{!"execcmd", !5, i64 0, !6, i64 4, !6, i64 44}
!33 = !{!12, !5, i64 0}
!34 = !{!12, !9, i64 12}
!35 = !{!22, !5, i64 0}
!36 = !{!18, !5, i64 0}
!37 = !{!25, !5, i64 0}
!38 = distinct !{!38, !28, !29}
!39 = distinct !{!39, !28, !29}
!40 = distinct !{!40, !28, !29}
!41 = distinct !{!41, !28, !29}
!42 = distinct !{!42, !28, !29}
!43 = distinct !{!43, !28, !29}
!44 = !{!13, !13, i64 0}
!45 = distinct !{!45, !28, !29}
!46 = distinct !{!46, !28, !29}
