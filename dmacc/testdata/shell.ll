; ModuleID = 'shell.c'
source_filename = "shell.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

@.str = private unnamed_addr constant [79 x i8] c"\0Adma-sh: a shell running on the RP2 DMA controller.\0AType 'help' for commands.\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"dma> \00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"help\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"echo \00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"echo\00", align 1
@stdout = external dso_local local_unnamed_addr constant ptr, align 4
@.str.6 = private unnamed_addr constant [5 x i8] c"stat\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"peek\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"poke\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"primes\00", align 1
@.str.10 = private unnamed_addr constant [21 x i8] c"unknown command: %s\0A\00", align 1
@stat_ticks = dso_local global ptr null, align 4
@stat_counter = dso_local global ptr null, align 4
@.str.11 = private unnamed_addr constant [4 x i8] c"\08 \08\00", align 1
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@.str.12 = private unnamed_addr constant [282 x i8] c"commands:\0A  help              this text\0A  echo <text>       print text\0A  stat              scheduler ticks + background process counter\0A  peek <addr>       read a 32-bit word (SRAM or MMIO)\0A  poke <addr> <val> write a 32-bit word\0A  primes <n>        sieve primes up to n (max 500)\0A\00", align 1
@.str.13 = private unnamed_addr constant [23 x i8] c"ticks=%u bgcounter=%u\0A\00", align 1
@.str.14 = private unnamed_addr constant [20 x i8] c"usage: peek <addr>\0A\00", align 1
@.str.15 = private unnamed_addr constant [15 x i8] c"[%08x] = %08x\0A\00", align 1
@.str.16 = private unnamed_addr constant [26 x i8] c"usage: poke <addr> <val>\0A\00", align 1
@.str.17 = private unnamed_addr constant [16 x i8] c"[%08x] <- %08x\0A\00", align 1
@composite = internal global [501 x i8] zeroinitializer, align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"%4u%c\00", align 1
@.str.19 = private unnamed_addr constant [19 x i8] c"(%d primes <= %u)\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca [80 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %6) #6
  %7 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str) #7
  %8 = load ptr, ptr @stdout, align 4
  br label %9

9:                                                ; preds = %50, %0
  %10 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.1) #7
  br label %11

11:                                               ; preds = %27, %9
  %12 = phi i32 [ 0, %9 ], [ %28, %27 ]
  %13 = icmp sgt i32 %12, 0
  %14 = icmp slt i32 %12, 79
  br label %15

15:                                               ; preds = %34, %11
  br label %16

16:                                               ; preds = %16, %15
  %17 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %18 = and i32 %17, 16
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %20, label %16, !llvm.loop !7

20:                                               ; preds = %16
  %21 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !3
  %22 = trunc i32 %21 to i8
  switch i8 %22, label %29 [
    i8 13, label %39
    i8 10, label %39
    i8 127, label %23
    i8 8, label %23
  ]

23:                                               ; preds = %20, %20
  br i1 %13, label %24, label %34

24:                                               ; preds = %23
  %25 = add nsw i32 %12, -1
  %26 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.11) #7
  br label %27

27:                                               ; preds = %24, %35
  %28 = phi i32 [ %36, %35 ], [ %25, %24 ]
  br label %11, !llvm.loop !10

29:                                               ; preds = %20
  %30 = and i32 %21, 255
  %31 = add nsw i32 %30, -32
  %32 = icmp ult i32 %31, 95
  %33 = select i1 %14, i1 %32, i1 false
  br i1 %33, label %35, label %34

34:                                               ; preds = %29, %23
  br label %15, !llvm.loop !10

35:                                               ; preds = %29
  %36 = add nsw i32 %12, 1
  %37 = getelementptr inbounds i8, ptr %6, i32 %12
  store i8 %22, ptr %37, align 1, !tbaa !11
  %38 = call i32 @fputc(i32 noundef %30, ptr noundef %8) #7
  br label %27

39:                                               ; preds = %20, %20
  %40 = call i32 @fputc(i32 noundef 10, ptr noundef %8) #7
  %41 = getelementptr inbounds i8, ptr %6, i32 %12
  store i8 0, ptr %41, align 1, !tbaa !11
  %42 = call fastcc ptr @skip_spaces(ptr noundef nonnull %6) #8
  %43 = load i8, ptr %42, align 1, !tbaa !11
  %44 = icmp eq i8 %43, 0
  br i1 %44, label %50, label %45

45:                                               ; preds = %39
  %46 = call i32 @strcmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.2) #7
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %48, label %51

48:                                               ; preds = %45
  %49 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.12) #7
  br label %50

50:                                               ; preds = %48, %60, %85, %158, %160, %104, %65, %54, %39
  br label %9, !llvm.loop !12

51:                                               ; preds = %45
  %52 = call i32 @strncmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.3, i32 noundef 5) #7
  %53 = icmp eq i32 %52, 0
  br i1 %53, label %54, label %57

54:                                               ; preds = %51
  %55 = getelementptr inbounds nuw i8, ptr %42, i32 5
  %56 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.4, ptr noundef nonnull %55) #7
  br label %50

57:                                               ; preds = %51
  %58 = call i32 @strcmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.5) #7
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %60, label %62

60:                                               ; preds = %57
  %61 = call i32 @fputc(i32 noundef 10, ptr noundef %8) #7
  br label %50

62:                                               ; preds = %57
  %63 = call i32 @strcmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.6) #7
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %65, label %71

65:                                               ; preds = %62
  %66 = load volatile ptr, ptr @stat_ticks, align 4, !tbaa !13
  %67 = load volatile i32, ptr %66, align 4, !tbaa !3
  %68 = load volatile ptr, ptr @stat_counter, align 4, !tbaa !13
  %69 = load volatile i32, ptr %68, align 4, !tbaa !3
  %70 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.13, i32 noundef %67, i32 noundef %69) #7
  br label %50

71:                                               ; preds = %62
  %72 = call i32 @strncmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.7, i32 noundef 4) #7
  %73 = icmp eq i32 %72, 0
  br i1 %73, label %74, label %86

74:                                               ; preds = %71
  %75 = getelementptr inbounds nuw i8, ptr %42, i32 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #6
  %76 = call fastcc i32 @parse_num(ptr noundef nonnull %75, ptr noundef null, ptr noundef %5) #8
  %77 = load i32, ptr %5, align 4, !tbaa !3
  %78 = icmp eq i32 %77, 0
  br i1 %78, label %79, label %81

79:                                               ; preds = %74
  %80 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.14) #7
  br label %85

81:                                               ; preds = %74
  %82 = inttoptr i32 %76 to ptr
  %83 = load volatile i32, ptr %82, align 4, !tbaa !3
  %84 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.15, i32 noundef %76, i32 noundef %83) #7
  br label %85

85:                                               ; preds = %79, %81
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #6
  br label %50

86:                                               ; preds = %71
  %87 = call i32 @strncmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.8, i32 noundef 4) #7
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %89, label %105

89:                                               ; preds = %86
  %90 = getelementptr inbounds nuw i8, ptr %42, i32 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #6
  %91 = call fastcc i32 @parse_num(ptr noundef nonnull %90, ptr noundef nonnull %4, ptr noundef %2) #8
  %92 = load ptr, ptr %4, align 4, !tbaa !16
  %93 = call fastcc i32 @parse_num(ptr noundef %92, ptr noundef null, ptr noundef %3) #8
  %94 = load i32, ptr %2, align 4, !tbaa !3
  %95 = icmp ne i32 %94, 0
  %96 = load i32, ptr %3, align 4
  %97 = icmp ne i32 %96, 0
  %98 = select i1 %95, i1 %97, i1 false
  br i1 %98, label %101, label %99

99:                                               ; preds = %89
  %100 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.16) #7
  br label %104

101:                                              ; preds = %89
  %102 = inttoptr i32 %91 to ptr
  store volatile i32 %93, ptr %102, align 4, !tbaa !3
  %103 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.17, i32 noundef %91, i32 noundef %93) #7
  br label %104

104:                                              ; preds = %99, %101
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #6
  br label %50

105:                                              ; preds = %86
  %106 = call i32 @strncmp(ptr noundef nonnull %42, ptr noundef nonnull @.str.9, i32 noundef 6) #7
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %108, label %160

108:                                              ; preds = %105
  %109 = getelementptr inbounds nuw i8, ptr %42, i32 6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %1) #6
  %110 = call fastcc i32 @parse_num(ptr noundef nonnull %109, ptr noundef null, ptr noundef %1) #8
  %111 = load i32, ptr %1, align 4, !tbaa !3
  %112 = icmp eq i32 %111, 0
  br i1 %112, label %115, label %113

113:                                              ; preds = %108
  %114 = icmp ult i32 %110, 2
  br i1 %114, label %115, label %116

115:                                              ; preds = %113, %108
  br label %116

116:                                              ; preds = %115, %113
  %117 = phi i32 [ 100, %115 ], [ %110, %113 ]
  %118 = call i32 @llvm.umin.i32(i32 %117, i32 500)
  %119 = call ptr @memset(ptr noundef nonnull @composite, i32 noundef 0, i32 noundef 501) #7
  br label %120

120:                                              ; preds = %134, %116
  %121 = phi i32 [ 2, %116 ], [ %135, %134 ]
  %122 = mul i32 %121, %121
  %123 = icmp ugt i32 %122, %118
  br i1 %123, label %136, label %124

124:                                              ; preds = %120
  %125 = getelementptr inbounds nuw [501 x i8], ptr @composite, i32 0, i32 %121
  %126 = load i8, ptr %125, align 1, !tbaa !11
  %127 = icmp eq i8 %126, 0
  br i1 %127, label %128, label %134

128:                                              ; preds = %124, %131
  %129 = phi i32 [ %133, %131 ], [ %122, %124 ]
  %130 = icmp ugt i32 %129, %118
  br i1 %130, label %134, label %131

131:                                              ; preds = %128
  %132 = getelementptr inbounds nuw [501 x i8], ptr @composite, i32 0, i32 %129
  store i8 1, ptr %132, align 1, !tbaa !11
  %133 = add i32 %129, %121
  br label %128, !llvm.loop !18

134:                                              ; preds = %128, %124
  %135 = add i32 %121, 1
  br label %120, !llvm.loop !19

136:                                              ; preds = %120, %153
  %137 = phi i32 [ %154, %153 ], [ 0, %120 ]
  %138 = phi i32 [ %155, %153 ], [ 2, %120 ]
  %139 = icmp samesign ugt i32 %138, %118
  br i1 %139, label %140, label %143

140:                                              ; preds = %136
  %141 = srem i32 %137, 10
  %142 = icmp eq i32 %141, 0
  br i1 %142, label %158, label %156

143:                                              ; preds = %136
  %144 = getelementptr inbounds nuw [501 x i8], ptr @composite, i32 0, i32 %138
  %145 = load i8, ptr %144, align 1, !tbaa !11
  %146 = icmp eq i8 %145, 0
  br i1 %146, label %147, label %153

147:                                              ; preds = %143
  %148 = add nsw i32 %137, 1
  %149 = srem i32 %148, 10
  %150 = icmp eq i32 %149, 0
  %151 = select i1 %150, i32 10, i32 32
  %152 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.18, i32 noundef %138, i32 noundef %151) #7
  br label %153

153:                                              ; preds = %147, %143
  %154 = phi i32 [ %137, %143 ], [ %148, %147 ]
  %155 = add nuw nsw i32 %138, 1
  br label %136, !llvm.loop !20

156:                                              ; preds = %140
  %157 = call i32 @fputc(i32 noundef 10, ptr noundef %8) #7
  br label %158

158:                                              ; preds = %140, %156
  %159 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.19, i32 noundef %137, i32 noundef %118) #7
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %1) #6
  br label %50

160:                                              ; preds = %105
  %161 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.10, ptr noundef nonnull %42) #7
  br label %50
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize optsize
declare dso_local i32 @printf(ptr noundef, ...) local_unnamed_addr #2

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define internal fastcc noundef ptr @skip_spaces(ptr noundef readonly captures(ret: address, provenance) %0) unnamed_addr #3 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi ptr [ %0, %1 ], [ %6, %2 ]
  %4 = load i8, ptr %3, align 1, !tbaa !11
  %5 = icmp eq i8 %4, 32
  %6 = getelementptr inbounds nuw i8, ptr %3, i32 1
  br i1 %5, label %2, label %7, !llvm.loop !21

7:                                                ; preds = %2
  ret ptr %3
}

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @strncmp(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @fputc(i32 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none)
define internal fastcc i32 @parse_num(ptr noundef %0, ptr noundef writeonly captures(address_is_null) %1, ptr noundef nonnull writeonly captures(none) %2) unnamed_addr #4 {
  %4 = tail call fastcc ptr @skip_spaces(ptr noundef %0) #8
  %5 = load i8, ptr %4, align 1, !tbaa !11
  %6 = icmp eq i8 %5, 48
  br i1 %6, label %7, label %12

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %9 = load i8, ptr %8, align 1, !tbaa !11
  switch i8 %9, label %12 [
    i8 120, label %10
    i8 88, label %10
  ]

10:                                               ; preds = %7, %7
  %11 = getelementptr inbounds nuw i8, ptr %4, i32 2
  br label %12

12:                                               ; preds = %7, %10, %3
  %13 = phi ptr [ %11, %10 ], [ %4, %3 ], [ %4, %7 ]
  %14 = phi i1 [ false, %10 ], [ true, %3 ], [ true, %7 ]
  br label %15

15:                                               ; preds = %37, %12
  %16 = phi ptr [ %13, %12 ], [ %43, %37 ]
  %17 = phi i32 [ 0, %12 ], [ %42, %37 ]
  %18 = phi i32 [ 0, %12 ], [ 1, %37 ]
  %19 = load i8, ptr %16, align 1, !tbaa !11
  %20 = add i8 %19, -48
  %21 = icmp ult i8 %20, 10
  br i1 %21, label %22, label %24

22:                                               ; preds = %15
  %23 = zext nneg i8 %20 to i32
  br label %37

24:                                               ; preds = %15
  br i1 %14, label %44, label %25

25:                                               ; preds = %24
  %26 = add i8 %19, -97
  %27 = icmp ult i8 %26, 6
  br i1 %27, label %28, label %31

28:                                               ; preds = %25
  %29 = zext nneg i8 %19 to i32
  %30 = add nsw i32 %29, -87
  br label %37

31:                                               ; preds = %25
  %32 = add i8 %19, -65
  %33 = icmp ult i8 %32, 6
  br i1 %33, label %34, label %44

34:                                               ; preds = %31
  %35 = zext nneg i8 %19 to i32
  %36 = add nsw i32 %35, -55
  br label %37

37:                                               ; preds = %28, %34, %22
  %38 = phi i32 [ %23, %22 ], [ %30, %28 ], [ %36, %34 ]
  %39 = shl i32 %17, 4
  %40 = mul i32 %17, 10
  %41 = select i1 %14, i32 %40, i32 %39
  %42 = add i32 %38, %41
  %43 = getelementptr inbounds nuw i8, ptr %16, i32 1
  br label %15, !llvm.loop !22

44:                                               ; preds = %24, %31
  %45 = icmp eq ptr %1, null
  br i1 %45, label %47, label %46

46:                                               ; preds = %44
  store ptr %16, ptr %1, align 4, !tbaa !16
  br label %47

47:                                               ; preds = %46, %44
  store i32 %18, ptr %2, align 4, !tbaa !3
  ret i32 %17
}

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #5

attributes #0 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { nounwind }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin optsize "no-builtins" }

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
!10 = distinct !{!10, !9}
!11 = !{!5, !5, i64 0}
!12 = distinct !{!12, !9}
!13 = !{!14, !14, i64 0}
!14 = !{!"p1 int", !15, i64 0}
!15 = !{!"any pointer", !5, i64 0}
!16 = !{!17, !17, i64 0}
!17 = !{!"p1 omnipotent char", !15, i64 0}
!18 = distinct !{!18, !8, !9}
!19 = distinct !{!19, !8, !9}
!20 = distinct !{!20, !8, !9}
!21 = distinct !{!21, !8, !9}
!22 = distinct !{!22, !9}
