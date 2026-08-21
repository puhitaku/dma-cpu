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
@.str.10 = private unnamed_addr constant [5 x i8] c"run \00", align 1
@.str.11 = private unnamed_addr constant [21 x i8] c"unknown command: %s\0A\00", align 1
@stat_ticks = dso_local global ptr null, align 4
@stat_counter = dso_local global ptr null, align 4
@.str.12 = private unnamed_addr constant [4 x i8] c"\08 \08\00", align 1
@__dma_uart_fr = external dso_local global i32, align 4
@__dma_uart_dr = external dso_local global i32, align 4
@.str.13 = private unnamed_addr constant [344 x i8] c"commands:\0A  help              this text\0A  echo <text>       print text\0A  stat              scheduler ticks + background process counter\0A  peek <addr>       read a 32-bit word (SRAM or MMIO)\0A  poke <addr> <val> write a 32-bit word\0A  primes <n>        sieve primes up to n (max 500)\0A  run <img> [args]  fork+exec a registered image, wait for it\0A\00", align 1
@.str.14 = private unnamed_addr constant [23 x i8] c"ticks=%u bgcounter=%u\0A\00", align 1
@.str.15 = private unnamed_addr constant [20 x i8] c"usage: peek <addr>\0A\00", align 1
@.str.16 = private unnamed_addr constant [15 x i8] c"[%08x] = %08x\0A\00", align 1
@.str.17 = private unnamed_addr constant [26 x i8] c"usage: poke <addr> <val>\0A\00", align 1
@.str.18 = private unnamed_addr constant [16 x i8] c"[%08x] <- %08x\0A\00", align 1
@composite = internal global [501 x i8] zeroinitializer, align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"%4u%c\00", align 1
@.str.20 = private unnamed_addr constant [19 x i8] c"(%d primes <= %u)\0A\00", align 1
@.str.21 = private unnamed_addr constant [25 x i8] c"usage: run <img> [args]\0A\00", align 1
@.str.22 = private unnamed_addr constant [21 x i8] c"run: exec %s failed\0A\00", align 1
@.str.23 = private unnamed_addr constant [28 x i8] c"[pid %d exited, status %d]\0A\00", align 1

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca [8 x ptr], align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 4
  %7 = alloca i32, align 4
  %8 = alloca [80 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %8) #6
  %9 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull @.str) #7
  %10 = load ptr, ptr @stdout, align 4
  %11 = getelementptr inbounds nuw i8, ptr %1, i32 28
  br label %12

12:                                               ; preds = %53, %0
  %13 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.1) #7
  br label %14

14:                                               ; preds = %30, %12
  %15 = phi i32 [ 0, %12 ], [ %31, %30 ]
  %16 = icmp sgt i32 %15, 0
  %17 = icmp slt i32 %15, 79
  br label %18

18:                                               ; preds = %37, %14
  br label %19

19:                                               ; preds = %19, %18
  %20 = load volatile i32, ptr @__dma_uart_fr, align 4, !tbaa !3
  %21 = and i32 %20, 16
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %23, label %19, !llvm.loop !7

23:                                               ; preds = %19
  %24 = load volatile i32, ptr @__dma_uart_dr, align 4, !tbaa !3
  %25 = trunc i32 %24 to i8
  switch i8 %25, label %32 [
    i8 13, label %42
    i8 10, label %42
    i8 127, label %26
    i8 8, label %26
  ]

26:                                               ; preds = %23, %23
  br i1 %16, label %27, label %37

27:                                               ; preds = %26
  %28 = add nsw i32 %15, -1
  %29 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.12) #7
  br label %30

30:                                               ; preds = %27, %38
  %31 = phi i32 [ %39, %38 ], [ %28, %27 ]
  br label %14, !llvm.loop !10

32:                                               ; preds = %23
  %33 = and i32 %24, 255
  %34 = add nsw i32 %33, -32
  %35 = icmp ult i32 %34, 95
  %36 = select i1 %17, i1 %35, i1 false
  br i1 %36, label %38, label %37

37:                                               ; preds = %32, %26
  br label %18, !llvm.loop !10

38:                                               ; preds = %32
  %39 = add nsw i32 %15, 1
  %40 = getelementptr inbounds i8, ptr %8, i32 %15
  store i8 %25, ptr %40, align 1, !tbaa !11
  %41 = call i32 @fputc(i32 noundef %33, ptr noundef %10) #7
  br label %30

42:                                               ; preds = %23, %23
  %43 = call i32 @fputc(i32 noundef 10, ptr noundef %10) #7
  %44 = getelementptr inbounds i8, ptr %8, i32 %15
  store i8 0, ptr %44, align 1, !tbaa !11
  %45 = call fastcc ptr @skip_spaces(ptr noundef nonnull %8) #8
  %46 = load i8, ptr %45, align 1, !tbaa !11
  %47 = icmp eq i8 %46, 0
  br i1 %47, label %53, label %48

48:                                               ; preds = %42
  %49 = call i32 @strcmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.2) #7
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %51, label %54

51:                                               ; preds = %48
  %52 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.13) #7
  br label %53

53:                                               ; preds = %51, %63, %88, %161, %209, %208, %107, %68, %57, %42
  br label %12, !llvm.loop !12

54:                                               ; preds = %48
  %55 = call i32 @strncmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.3, i32 noundef 5) #7
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %57, label %60

57:                                               ; preds = %54
  %58 = getelementptr inbounds nuw i8, ptr %45, i32 5
  %59 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.4, ptr noundef nonnull %58) #7
  br label %53

60:                                               ; preds = %54
  %61 = call i32 @strcmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.5) #7
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %63, label %65

63:                                               ; preds = %60
  %64 = call i32 @fputc(i32 noundef 10, ptr noundef %10) #7
  br label %53

65:                                               ; preds = %60
  %66 = call i32 @strcmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.6) #7
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %68, label %74

68:                                               ; preds = %65
  %69 = load volatile ptr, ptr @stat_ticks, align 4, !tbaa !13
  %70 = load volatile i32, ptr %69, align 4, !tbaa !3
  %71 = load volatile ptr, ptr @stat_counter, align 4, !tbaa !13
  %72 = load volatile i32, ptr %71, align 4, !tbaa !3
  %73 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.14, i32 noundef %70, i32 noundef %72) #7
  br label %53

74:                                               ; preds = %65
  %75 = call i32 @strncmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.7, i32 noundef 4) #7
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %77, label %89

77:                                               ; preds = %74
  %78 = getelementptr inbounds nuw i8, ptr %45, i32 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #6
  %79 = call fastcc i32 @parse_num(ptr noundef nonnull %78, ptr noundef null, ptr noundef %7) #8
  %80 = load i32, ptr %7, align 4, !tbaa !3
  %81 = icmp eq i32 %80, 0
  br i1 %81, label %82, label %84

82:                                               ; preds = %77
  %83 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.15) #7
  br label %88

84:                                               ; preds = %77
  %85 = inttoptr i32 %79 to ptr
  %86 = load volatile i32, ptr %85, align 4, !tbaa !3
  %87 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.16, i32 noundef %79, i32 noundef %86) #7
  br label %88

88:                                               ; preds = %82, %84
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #6
  br label %53

89:                                               ; preds = %74
  %90 = call i32 @strncmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.8, i32 noundef 4) #7
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %92, label %108

92:                                               ; preds = %89
  %93 = getelementptr inbounds nuw i8, ptr %45, i32 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %6) #6
  %94 = call fastcc i32 @parse_num(ptr noundef nonnull %93, ptr noundef nonnull %6, ptr noundef %4) #8
  %95 = load ptr, ptr %6, align 4, !tbaa !16
  %96 = call fastcc i32 @parse_num(ptr noundef %95, ptr noundef null, ptr noundef %5) #8
  %97 = load i32, ptr %4, align 4, !tbaa !3
  %98 = icmp ne i32 %97, 0
  %99 = load i32, ptr %5, align 4
  %100 = icmp ne i32 %99, 0
  %101 = select i1 %98, i1 %100, i1 false
  br i1 %101, label %104, label %102

102:                                              ; preds = %92
  %103 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.17) #7
  br label %107

104:                                              ; preds = %92
  %105 = inttoptr i32 %94 to ptr
  store volatile i32 %96, ptr %105, align 4, !tbaa !3
  %106 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.18, i32 noundef %94, i32 noundef %96) #7
  br label %107

107:                                              ; preds = %102, %104
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %6) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #6
  br label %53

108:                                              ; preds = %89
  %109 = call i32 @strncmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.9, i32 noundef 6) #7
  %110 = icmp eq i32 %109, 0
  br i1 %110, label %111, label %163

111:                                              ; preds = %108
  %112 = getelementptr inbounds nuw i8, ptr %45, i32 6
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6
  %113 = call fastcc i32 @parse_num(ptr noundef nonnull %112, ptr noundef null, ptr noundef %3) #8
  %114 = load i32, ptr %3, align 4, !tbaa !3
  %115 = icmp eq i32 %114, 0
  br i1 %115, label %118, label %116

116:                                              ; preds = %111
  %117 = icmp ult i32 %113, 2
  br i1 %117, label %118, label %119

118:                                              ; preds = %116, %111
  br label %119

119:                                              ; preds = %118, %116
  %120 = phi i32 [ 100, %118 ], [ %113, %116 ]
  %121 = call i32 @llvm.umin.i32(i32 %120, i32 500)
  %122 = call ptr @memset(ptr noundef nonnull @composite, i32 noundef 0, i32 noundef 501) #7
  br label %123

123:                                              ; preds = %137, %119
  %124 = phi i32 [ 2, %119 ], [ %138, %137 ]
  %125 = mul i32 %124, %124
  %126 = icmp ugt i32 %125, %121
  br i1 %126, label %139, label %127

127:                                              ; preds = %123
  %128 = getelementptr inbounds nuw [501 x i8], ptr @composite, i32 0, i32 %124
  %129 = load i8, ptr %128, align 1, !tbaa !11
  %130 = icmp eq i8 %129, 0
  br i1 %130, label %131, label %137

131:                                              ; preds = %127, %134
  %132 = phi i32 [ %136, %134 ], [ %125, %127 ]
  %133 = icmp ugt i32 %132, %121
  br i1 %133, label %137, label %134

134:                                              ; preds = %131
  %135 = getelementptr inbounds nuw [501 x i8], ptr @composite, i32 0, i32 %132
  store i8 1, ptr %135, align 1, !tbaa !11
  %136 = add i32 %132, %124
  br label %131, !llvm.loop !18

137:                                              ; preds = %131, %127
  %138 = add i32 %124, 1
  br label %123, !llvm.loop !19

139:                                              ; preds = %123, %156
  %140 = phi i32 [ %157, %156 ], [ 0, %123 ]
  %141 = phi i32 [ %158, %156 ], [ 2, %123 ]
  %142 = icmp samesign ugt i32 %141, %121
  br i1 %142, label %143, label %146

143:                                              ; preds = %139
  %144 = srem i32 %140, 10
  %145 = icmp eq i32 %144, 0
  br i1 %145, label %161, label %159

146:                                              ; preds = %139
  %147 = getelementptr inbounds nuw [501 x i8], ptr @composite, i32 0, i32 %141
  %148 = load i8, ptr %147, align 1, !tbaa !11
  %149 = icmp eq i8 %148, 0
  br i1 %149, label %150, label %156

150:                                              ; preds = %146
  %151 = add nsw i32 %140, 1
  %152 = srem i32 %151, 10
  %153 = icmp eq i32 %152, 0
  %154 = select i1 %153, i32 10, i32 32
  %155 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.19, i32 noundef %141, i32 noundef %154) #7
  br label %156

156:                                              ; preds = %150, %146
  %157 = phi i32 [ %140, %146 ], [ %151, %150 ]
  %158 = add nuw nsw i32 %141, 1
  br label %139, !llvm.loop !20

159:                                              ; preds = %143
  %160 = call i32 @fputc(i32 noundef 10, ptr noundef %10) #7
  br label %161

161:                                              ; preds = %143, %159
  %162 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.20, i32 noundef %140, i32 noundef %121) #7
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6
  br label %53

163:                                              ; preds = %108
  %164 = call i32 @strncmp(ptr noundef nonnull %45, ptr noundef nonnull @.str.10, i32 noundef 4) #7
  %165 = icmp eq i32 %164, 0
  br i1 %165, label %166, label %209

166:                                              ; preds = %163
  %167 = getelementptr inbounds nuw i8, ptr %45, i32 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %1) #6
  br label %169

168:                                              ; preds = %182, %182
  br label %169

169:                                              ; preds = %168, %166
  %170 = phi ptr [ %167, %166 ], [ %183, %168 ]
  %171 = phi i32 [ 0, %166 ], [ %180, %168 ]
  %172 = icmp eq i32 %171, 7
  br i1 %172, label %173, label %174

173:                                              ; preds = %169
  store ptr null, ptr %11, align 4, !tbaa !16
  br label %192

174:                                              ; preds = %169, %177
  %175 = phi ptr [ %178, %177 ], [ %170, %169 ]
  %176 = load i8, ptr %175, align 1, !tbaa !11
  switch i8 %176, label %179 [
    i8 32, label %177
    i8 0, label %187
  ]

177:                                              ; preds = %174
  %178 = getelementptr inbounds nuw i8, ptr %175, i32 1
  store i8 0, ptr %175, align 1, !tbaa !11
  br label %174, !llvm.loop !21

179:                                              ; preds = %174
  %180 = add nuw nsw i32 %171, 1
  %181 = getelementptr inbounds nuw [8 x ptr], ptr %1, i32 0, i32 %171
  store ptr %175, ptr %181, align 4, !tbaa !16
  br label %182

182:                                              ; preds = %185, %179
  %183 = phi ptr [ %175, %179 ], [ %186, %185 ]
  %184 = load i8, ptr %183, align 1, !tbaa !11
  switch i8 %184, label %185 [
    i8 0, label %168
    i8 32, label %168
  ], !llvm.loop !22

185:                                              ; preds = %182
  %186 = getelementptr inbounds nuw i8, ptr %183, i32 1
  br label %182, !llvm.loop !23

187:                                              ; preds = %174
  %188 = getelementptr inbounds nuw [8 x ptr], ptr %1, i32 0, i32 %171
  store ptr null, ptr %188, align 4, !tbaa !16
  %189 = icmp eq i32 %171, 0
  br i1 %189, label %190, label %192

190:                                              ; preds = %187
  %191 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.21) #7
  br label %208

192:                                              ; preds = %187, %173
  %193 = call i32 @fork() #7
  %194 = icmp eq i32 %193, 0
  br i1 %194, label %195, label %198

195:                                              ; preds = %192
  %196 = load ptr, ptr %1, align 4, !tbaa !16
  %197 = call i32 @exec(ptr noundef %196, ptr noundef nonnull %1) #7
  call void @exit(i32 noundef 127) #7
  br label %198

198:                                              ; preds = %195, %192
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #6
  store i32 -1, ptr %2, align 4, !tbaa !3
  %199 = call i32 @wait(ptr noundef nonnull %2) #7
  %200 = load i32, ptr %2, align 4, !tbaa !3
  %201 = icmp eq i32 %200, 127
  br i1 %201, label %202, label %205

202:                                              ; preds = %198
  %203 = load ptr, ptr %1, align 4, !tbaa !16
  %204 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.22, ptr noundef %203) #7
  br label %207

205:                                              ; preds = %198
  %206 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.23, i32 noundef %199, i32 noundef %200) #7
  br label %207

207:                                              ; preds = %205, %202
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #6
  br label %208

208:                                              ; preds = %190, %207
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %1) #6
  br label %53

209:                                              ; preds = %163
  %210 = call i32 (ptr, ...) @printf(ptr noundef nonnull @.str.11, ptr noundef nonnull %45) #7
  br label %53
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
  br i1 %5, label %2, label %7, !llvm.loop !24

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
  br label %15, !llvm.loop !25

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

; Function Attrs: minsize optsize
declare dso_local i32 @fork() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @exec(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @exit(i32 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local i32 @wait(ptr noundef) local_unnamed_addr #2

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
!22 = distinct !{!22, !8, !9}
!23 = distinct !{!23, !8, !9}
!24 = distinct !{!24, !8, !9}
!25 = distinct !{!25, !9}
