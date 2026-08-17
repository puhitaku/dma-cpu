; ModuleID = 'usertests.c'
source_filename = "usertests.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-none-eabi"

%struct.test = type { ptr, ptr }
%struct.anon = type { i16, [62 x i8] }
%struct.stat = type { i32, i32, i16, i16, i32 }

@.str = private unnamed_addr constant [8 x i8] c"copyin1\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"open(copyin1) failed\0A\00", align 1
@.str.2 = private unnamed_addr constant [41 x i8] c"write(fd, %p, 8192) returned %d, not -1\0A\00", align 1
@.str.3 = private unnamed_addr constant [45 x i8] c"write(1, %p, 8192) returned %d, not -1 or 0\0A\00", align 1
@.str.4 = private unnamed_addr constant [15 x i8] c"pipe() failed\0A\00", align 1
@.str.5 = private unnamed_addr constant [48 x i8] c"write(pipe, %p, 8192) returned %d, not -1 or 0\0A\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"README\00", align 1
@.str.7 = private unnamed_addr constant [21 x i8] c"open(README) failed\0A\00", align 1
@.str.8 = private unnamed_addr constant [45 x i8] c"read(fd, %p, 8192) returned %d, not -1 or 0\0A\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.10 = private unnamed_addr constant [19 x i8] c"pipe write failed\0A\00", align 1
@.str.11 = private unnamed_addr constant [47 x i8] c"read(pipe, %p, 8192) returned %d, not -1 or 0\0A\00", align 1
@__const.copyinstr1.addrs = private unnamed_addr constant [5 x i32] [i32 -2147483648, i32 -8192, i32 -4096, i32 0, i32 -1], align 4
@.str.12 = private unnamed_addr constant [30 x i8] c"open(%p) returned %d, not -1\0A\00", align 1
@.str.13 = private unnamed_addr constant [32 x i8] c"unlink(%s) returned %d, not -1\0A\00", align 1
@.str.14 = private unnamed_addr constant [30 x i8] c"open(%s) returned %d, not -1\0A\00", align 1
@.str.15 = private unnamed_addr constant [34 x i8] c"link(%s, %s) returned %d, not -1\0A\00", align 1
@.str.16 = private unnamed_addr constant [3 x i8] c"xx\00", align 1
@.str.17 = private unnamed_addr constant [30 x i8] c"exec(%s) returned %d, not -1\0A\00", align 1
@.str.18 = private unnamed_addr constant [13 x i8] c"fork failed\0A\00", align 1
@copyinstr2.big = internal global [4097 x i8] zeroinitializer, align 1
@__const.copyinstr2.args2 = private unnamed_addr constant [4 x ptr] [ptr @copyinstr2.big, ptr @copyinstr2.big, ptr @copyinstr2.big, ptr null], align 4
@.str.19 = private unnamed_addr constant [5 x i8] c"echo\00", align 1
@.str.20 = private unnamed_addr constant [37 x i8] c"exec(echo, BIG) returned %d, not -1\0A\00", align 1
@.str.21 = private unnamed_addr constant [47 x i8] c"exec(echo, BIG) succeeded, should have failed\0A\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"oops\0A\00", align 1
@__const.copyinstr3.args = private unnamed_addr constant [2 x ptr] [ptr @.str.16, ptr null], align 8
@.str.23 = private unnamed_addr constant [21 x i8] c"sbrk(rwsbrk) failed\0A\00", align 1
@.str.24 = private unnamed_addr constant [28 x i8] c"sbrk(rwsbrk) shrink failed\0A\00", align 1
@.str.25 = private unnamed_addr constant [7 x i8] c"rwsbrk\00", align 1
@.str.26 = private unnamed_addr constant [21 x i8] c"open(rwsbrk) failed\0A\00", align 1
@.str.27 = private unnamed_addr constant [41 x i8] c"write(fd, %p, 1024) returned %d, not -1\0A\00", align 1
@.str.28 = private unnamed_addr constant [38 x i8] c"read(fd, %p, 10) returned %d, not -1\0A\00", align 1
@.str.29 = private unnamed_addr constant [10 x i8] c"truncfile\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"abcd\00", align 1
@.str.31 = private unnamed_addr constant [29 x i8] c"%s: read %d bytes, wanted 4\0A\00", align 1
@.str.32 = private unnamed_addr constant [12 x i8] c"aaa fd3=%d\0A\00", align 1
@.str.33 = private unnamed_addr constant [29 x i8] c"%s: read %d bytes, wanted 0\0A\00", align 1
@.str.34 = private unnamed_addr constant [12 x i8] c"bbb fd2=%d\0A\00", align 1
@.str.35 = private unnamed_addr constant [7 x i8] c"abcdef\00", align 1
@.str.36 = private unnamed_addr constant [29 x i8] c"%s: read %d bytes, wanted 6\0A\00", align 1
@.str.37 = private unnamed_addr constant [29 x i8] c"%s: read %d bytes, wanted 2\0A\00", align 1
@.str.38 = private unnamed_addr constant [36 x i8] c"%s: write returned %d, expected -1\0A\00", align 1
@.str.39 = private unnamed_addr constant [17 x i8] c"%s: fork failed\0A\00", align 1
@.str.40 = private unnamed_addr constant [17 x i8] c"%s: open failed\0A\00", align 1
@.str.41 = private unnamed_addr constant [11 x i8] c"1234567890\00", align 1
@.str.42 = private unnamed_addr constant [31 x i8] c"%s: write got %d, expected 10\0A\00", align 1
@.str.43 = private unnamed_addr constant [4 x i8] c"xxx\00", align 1
@.str.44 = private unnamed_addr constant [30 x i8] c"%s: write got %d, expected 3\0A\00", align 1
@.str.45 = private unnamed_addr constant [8 x i8] c"iputdir\00", align 1
@.str.46 = private unnamed_addr constant [18 x i8] c"%s: mkdir failed\0A\00", align 1
@.str.47 = private unnamed_addr constant [26 x i8] c"%s: chdir iputdir failed\0A\00", align 1
@.str.48 = private unnamed_addr constant [11 x i8] c"../iputdir\00", align 1
@.str.49 = private unnamed_addr constant [30 x i8] c"%s: unlink ../iputdir failed\0A\00", align 1
@.str.50 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.51 = private unnamed_addr constant [20 x i8] c"%s: chdir / failed\0A\00", align 1
@.str.52 = private unnamed_addr constant [24 x i8] c"%s: child chdir failed\0A\00", align 1
@.str.53 = private unnamed_addr constant [6 x i8] c"oidir\00", align 1
@.str.54 = private unnamed_addr constant [24 x i8] c"%s: mkdir oidir failed\0A\00", align 1
@.str.55 = private unnamed_addr constant [40 x i8] c"%s: open directory for write succeeded\0A\00", align 1
@.str.56 = private unnamed_addr constant [19 x i8] c"%s: unlink failed\0A\00", align 1
@.str.57 = private unnamed_addr constant [23 x i8] c"%s: open echo failed!\0A\00", align 1
@.str.58 = private unnamed_addr constant [13 x i8] c"doesnotexist\00", align 1
@.str.59 = private unnamed_addr constant [34 x i8] c"%s: open doesnotexist succeeded!\0A\00", align 1
@.str.60 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.61 = private unnamed_addr constant [32 x i8] c"%s: error: creat small failed!\0A\00", align 1
@.str.62 = private unnamed_addr constant [11 x i8] c"aaaaaaaaaa\00", align 1
@.str.63 = private unnamed_addr constant [40 x i8] c"%s: error: write aa %d new file failed\0A\00", align 1
@.str.64 = private unnamed_addr constant [11 x i8] c"bbbbbbbbbb\00", align 1
@.str.65 = private unnamed_addr constant [40 x i8] c"%s: error: write bb %d new file failed\0A\00", align 1
@.str.66 = private unnamed_addr constant [31 x i8] c"%s: error: open small failed!\0A\00", align 1
@buf = dso_local global [12288 x i8] zeroinitializer, align 4
@.str.67 = private unnamed_addr constant [17 x i8] c"%s: read failed\0A\00", align 1
@.str.68 = private unnamed_addr constant [25 x i8] c"%s: unlink small failed\0A\00", align 1
@.str.69 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.70 = private unnamed_addr constant [30 x i8] c"%s: error: creat big failed!\0A\00", align 1
@.str.71 = private unnamed_addr constant [39 x i8] c"%s: error: write big file failed i=%d\0A\00", align 1
@.str.72 = private unnamed_addr constant [29 x i8] c"%s: error: open big failed!\0A\00", align 1
@.str.73 = private unnamed_addr constant [33 x i8] c"%s: read only %d blocks from big\00", align 1
@.str.74 = private unnamed_addr constant [20 x i8] c"%s: read failed %d\0A\00", align 1
@.str.75 = private unnamed_addr constant [36 x i8] c"%s: read content of block %d is %d\0A\00", align 1
@.str.76 = private unnamed_addr constant [23 x i8] c"%s: unlink big failed\0A\00", align 1
@.str.77 = private unnamed_addr constant [5 x i8] c"dir0\00", align 1
@.str.78 = private unnamed_addr constant [23 x i8] c"%s: chdir dir0 failed\0A\00", align 1
@.str.79 = private unnamed_addr constant [3 x i8] c"..\00", align 1
@.str.80 = private unnamed_addr constant [21 x i8] c"%s: chdir .. failed\0A\00", align 1
@.str.81 = private unnamed_addr constant [24 x i8] c"%s: unlink dir0 failed\0A\00", align 1
@.str.82 = private unnamed_addr constant [3 x i8] c"OK\00", align 1
@__const.exectest.echoargv = private unnamed_addr constant [3 x ptr] [ptr @.str.19, ptr @.str.82, ptr null], align 4
@.str.83 = private unnamed_addr constant [8 x i8] c"echo-ok\00", align 1
@.str.84 = private unnamed_addr constant [16 x i8] c"%s: dup failed\0A\00", align 1
@.str.85 = private unnamed_addr constant [19 x i8] c"%s: create failed\0A\00", align 1
@.str.86 = private unnamed_addr constant [14 x i8] c"%s: wrong fd\0A\00", align 1
@.str.87 = private unnamed_addr constant [22 x i8] c"%s: exec echo failed\0A\00", align 1
@.str.88 = private unnamed_addr constant [18 x i8] c"%s: wait failed!\0A\00", align 1
@.str.89 = private unnamed_addr constant [28 x i8] c"%s: nonzero wait status %d\0A\00", align 1
@.str.90 = private unnamed_addr constant [18 x i8] c"%s: wrong output\0A\00", align 1
@.str.91 = private unnamed_addr constant [19 x i8] c"%s: pipe() failed\0A\00", align 1
@.str.92 = private unnamed_addr constant [18 x i8] c"%s: pipe1 oops 1\0A\00", align 1
@.str.93 = private unnamed_addr constant [18 x i8] c"%s: pipe1 oops 2\0A\00", align 1
@.str.94 = private unnamed_addr constant [27 x i8] c"%s: pipe1 oops 3 total %d\0A\00", align 1
@.str.95 = private unnamed_addr constant [19 x i8] c"%s: fork() failed\0A\00", align 1
@.str.96 = private unnamed_addr constant [25 x i8] c"%s: status should be -1\0A\00", align 1
@.str.97 = private unnamed_addr constant [16 x i8] c"%s: fork failed\00", align 1
@.str.98 = private unnamed_addr constant [24 x i8] c"%s: preempt write error\00", align 1
@.str.99 = private unnamed_addr constant [23 x i8] c"%s: preempt read error\00", align 1
@.str.100 = private unnamed_addr constant [9 x i8] c"kill... \00", align 1
@.str.101 = private unnamed_addr constant [9 x i8] c"wait... \00", align 1
@.str.102 = private unnamed_addr constant [20 x i8] c"%s: wait wrong pid\0A\00", align 1
@.str.103 = private unnamed_addr constant [28 x i8] c"%s: wait wrong exit status\0A\00", align 1
@.str.104 = private unnamed_addr constant [25 x i8] c"%s: fork in child failed\00", align 1
@.str.105 = private unnamed_addr constant [12 x i8] c"stopforking\00", align 1
@.str.106 = private unnamed_addr constant [30 x i8] c"%s: couldn't allocate mem?!!\0A\00", align 1
@.str.107 = private unnamed_addr constant [9 x i8] c"sharedfd\00", align 1
@.str.108 = private unnamed_addr constant [37 x i8] c"%s: cannot open sharedfd for writing\00", align 1
@.str.109 = private unnamed_addr constant [27 x i8] c"%s: write sharedfd failed\0A\00", align 1
@.str.110 = private unnamed_addr constant [38 x i8] c"%s: cannot open sharedfd for reading\0A\00", align 1
@.str.111 = private unnamed_addr constant [22 x i8] c"%s: nc/np test fails\0A\00", align 1
@.str.112 = private unnamed_addr constant [3 x i8] c"f0\00", align 1
@.str.113 = private unnamed_addr constant [3 x i8] c"f1\00", align 1
@.str.114 = private unnamed_addr constant [3 x i8] c"f2\00", align 1
@.str.115 = private unnamed_addr constant [3 x i8] c"f3\00", align 1
@__const.fourfiles.names = private unnamed_addr constant [4 x ptr] [ptr @.str.112, ptr @.str.113, ptr @.str.114, ptr @.str.115], align 4
@.str.116 = private unnamed_addr constant [17 x i8] c"write failed %d\0A\00", align 1
@.str.117 = private unnamed_addr constant [16 x i8] c"%s: wrong char\0A\00", align 1
@.str.118 = private unnamed_addr constant [17 x i8] c"wrong length %d\0A\00", align 1
@.str.119 = private unnamed_addr constant [39 x i8] c"%s: oops createdelete %s didn't exist\0A\00", align 1
@.str.120 = private unnamed_addr constant [36 x i8] c"%s: oops createdelete %s did exist\0A\00", align 1
@.str.121 = private unnamed_addr constant [11 x i8] c"unlinkread\00", align 1
@.str.122 = private unnamed_addr constant [30 x i8] c"%s: create unlinkread failed\0A\00", align 1
@.str.123 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.124 = private unnamed_addr constant [28 x i8] c"%s: open unlinkread failed\0A\00", align 1
@.str.125 = private unnamed_addr constant [30 x i8] c"%s: unlink unlinkread failed\0A\00", align 1
@.str.126 = private unnamed_addr constant [4 x i8] c"yyy\00", align 1
@.str.127 = private unnamed_addr constant [27 x i8] c"%s: unlinkread read failed\00", align 1
@.str.128 = private unnamed_addr constant [27 x i8] c"%s: unlinkread wrong data\0A\00", align 1
@.str.129 = private unnamed_addr constant [29 x i8] c"%s: unlinkread write failed\0A\00", align 1
@.str.130 = private unnamed_addr constant [4 x i8] c"lf1\00", align 1
@.str.131 = private unnamed_addr constant [4 x i8] c"lf2\00", align 1
@.str.132 = private unnamed_addr constant [23 x i8] c"%s: create lf1 failed\0A\00", align 1
@.str.133 = private unnamed_addr constant [22 x i8] c"%s: write lf1 failed\0A\00", align 1
@.str.134 = private unnamed_addr constant [25 x i8] c"%s: link lf1 lf2 failed\0A\00", align 1
@.str.135 = private unnamed_addr constant [41 x i8] c"%s: unlinked lf1 but it is still there!\0A\00", align 1
@.str.136 = private unnamed_addr constant [21 x i8] c"%s: open lf2 failed\0A\00", align 1
@.str.137 = private unnamed_addr constant [21 x i8] c"%s: read lf2 failed\0A\00", align 1
@.str.138 = private unnamed_addr constant [34 x i8] c"%s: link lf2 lf2 succeeded! oops\0A\00", align 1
@.str.139 = private unnamed_addr constant [39 x i8] c"%s: link non-existent succeeded! oops\0A\00", align 1
@.str.140 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.141 = private unnamed_addr constant [32 x i8] c"%s: link . lf1 succeeded! oops\0A\00", align 1
@.str.142 = private unnamed_addr constant [3 x i8] c"C0\00", align 1
@.str.143 = private unnamed_addr constant [28 x i8] c"concreate create %s failed\0A\00", align 1
@.str.144 = private unnamed_addr constant [29 x i8] c"%s: concreate weird file %s\0A\00", align 1
@.str.145 = private unnamed_addr constant [33 x i8] c"%s: concreate duplicate file %s\0A\00", align 1
@.str.146 = private unnamed_addr constant [53 x i8] c"%s: concreate not enough files in directory listing\0A\00", align 1
@.str.147 = private unnamed_addr constant [4 x i8] c"cat\00", align 1
@.str.148 = private unnamed_addr constant [3 x i8] c"ff\00", align 1
@.str.149 = private unnamed_addr constant [3 x i8] c"dd\00", align 1
@.str.150 = private unnamed_addr constant [21 x i8] c"%s: mkdir dd failed\0A\00", align 1
@.str.151 = private unnamed_addr constant [6 x i8] c"dd/ff\00", align 1
@.str.152 = private unnamed_addr constant [25 x i8] c"%s: create dd/ff failed\0A\00", align 1
@.str.153 = private unnamed_addr constant [42 x i8] c"%s: unlink dd (non-empty dir) succeeded!\0A\00", align 1
@.str.154 = private unnamed_addr constant [7 x i8] c"/dd/dd\00", align 1
@.str.155 = private unnamed_addr constant [31 x i8] c"%s: subdir mkdir dd/dd failed\0A\00", align 1
@.str.156 = private unnamed_addr constant [9 x i8] c"dd/dd/ff\00", align 1
@.str.157 = private unnamed_addr constant [28 x i8] c"%s: create dd/dd/ff failed\0A\00", align 1
@.str.158 = private unnamed_addr constant [3 x i8] c"FF\00", align 1
@.str.159 = private unnamed_addr constant [12 x i8] c"dd/dd/../ff\00", align 1
@.str.160 = private unnamed_addr constant [29 x i8] c"%s: open dd/dd/../ff failed\0A\00", align 1
@.str.161 = private unnamed_addr constant [31 x i8] c"%s: dd/dd/../ff wrong content\0A\00", align 1
@.str.162 = private unnamed_addr constant [11 x i8] c"dd/dd/ffff\00", align 1
@.str.163 = private unnamed_addr constant [37 x i8] c"%s: link dd/dd/ff dd/dd/ffff failed\0A\00", align 1
@.str.164 = private unnamed_addr constant [28 x i8] c"%s: unlink dd/dd/ff failed\0A\00", align 1
@.str.165 = private unnamed_addr constant [40 x i8] c"%s: open (unlinked) dd/dd/ff succeeded\0A\00", align 1
@.str.166 = private unnamed_addr constant [21 x i8] c"%s: chdir dd failed\0A\00", align 1
@.str.167 = private unnamed_addr constant [12 x i8] c"dd/../../dd\00", align 1
@.str.168 = private unnamed_addr constant [30 x i8] c"%s: chdir dd/../../dd failed\0A\00", align 1
@.str.169 = private unnamed_addr constant [15 x i8] c"dd/../../../dd\00", align 1
@.str.170 = private unnamed_addr constant [33 x i8] c"%s: chdir dd/../../../dd failed\0A\00", align 1
@.str.171 = private unnamed_addr constant [5 x i8] c"./..\00", align 1
@.str.172 = private unnamed_addr constant [23 x i8] c"%s: chdir ./.. failed\0A\00", align 1
@.str.173 = private unnamed_addr constant [28 x i8] c"%s: open dd/dd/ffff failed\0A\00", align 1
@.str.174 = private unnamed_addr constant [31 x i8] c"%s: read dd/dd/ffff wrong len\0A\00", align 1
@.str.175 = private unnamed_addr constant [41 x i8] c"%s: open (unlinked) dd/dd/ff succeeded!\0A\00", align 1
@.str.176 = private unnamed_addr constant [9 x i8] c"dd/ff/ff\00", align 1
@.str.177 = private unnamed_addr constant [32 x i8] c"%s: create dd/ff/ff succeeded!\0A\00", align 1
@.str.178 = private unnamed_addr constant [9 x i8] c"dd/xx/ff\00", align 1
@.str.179 = private unnamed_addr constant [32 x i8] c"%s: create dd/xx/ff succeeded!\0A\00", align 1
@.str.180 = private unnamed_addr constant [26 x i8] c"%s: create dd succeeded!\0A\00", align 1
@.str.181 = private unnamed_addr constant [29 x i8] c"%s: open dd rdwr succeeded!\0A\00", align 1
@.str.182 = private unnamed_addr constant [31 x i8] c"%s: open dd wronly succeeded!\0A\00", align 1
@.str.183 = private unnamed_addr constant [9 x i8] c"dd/dd/xx\00", align 1
@.str.184 = private unnamed_addr constant [39 x i8] c"%s: link dd/ff/ff dd/dd/xx succeeded!\0A\00", align 1
@.str.185 = private unnamed_addr constant [39 x i8] c"%s: link dd/xx/ff dd/dd/xx succeeded!\0A\00", align 1
@.str.186 = private unnamed_addr constant [38 x i8] c"%s: link dd/ff dd/dd/ffff succeeded!\0A\00", align 1
@.str.187 = private unnamed_addr constant [31 x i8] c"%s: mkdir dd/ff/ff succeeded!\0A\00", align 1
@.str.188 = private unnamed_addr constant [31 x i8] c"%s: mkdir dd/xx/ff succeeded!\0A\00", align 1
@.str.189 = private unnamed_addr constant [33 x i8] c"%s: mkdir dd/dd/ffff succeeded!\0A\00", align 1
@.str.190 = private unnamed_addr constant [32 x i8] c"%s: unlink dd/xx/ff succeeded!\0A\00", align 1
@.str.191 = private unnamed_addr constant [32 x i8] c"%s: unlink dd/ff/ff succeeded!\0A\00", align 1
@.str.192 = private unnamed_addr constant [28 x i8] c"%s: chdir dd/ff succeeded!\0A\00", align 1
@.str.193 = private unnamed_addr constant [6 x i8] c"dd/xx\00", align 1
@.str.194 = private unnamed_addr constant [28 x i8] c"%s: chdir dd/xx succeeded!\0A\00", align 1
@.str.195 = private unnamed_addr constant [25 x i8] c"%s: unlink dd/ff failed\0A\00", align 1
@.str.196 = private unnamed_addr constant [36 x i8] c"%s: unlink non-empty dd succeeded!\0A\00", align 1
@.str.197 = private unnamed_addr constant [6 x i8] c"dd/dd\00", align 1
@.str.198 = private unnamed_addr constant [25 x i8] c"%s: unlink dd/dd failed\0A\00", align 1
@.str.199 = private unnamed_addr constant [22 x i8] c"%s: unlink dd failed\0A\00", align 1
@.str.200 = private unnamed_addr constant [9 x i8] c"bigwrite\00", align 1
@.str.201 = private unnamed_addr constant [28 x i8] c"%s: cannot create bigwrite\0A\00", align 1
@.str.202 = private unnamed_addr constant [22 x i8] c"%s: write(%d) ret %d\0A\00", align 1
@.str.203 = private unnamed_addr constant [12 x i8] c"bigfile.dat\00", align 1
@.str.204 = private unnamed_addr constant [26 x i8] c"%s: cannot create bigfile\00", align 1
@.str.205 = private unnamed_addr constant [26 x i8] c"%s: write bigfile failed\0A\00", align 1
@.str.206 = private unnamed_addr constant [25 x i8] c"%s: cannot open bigfile\0A\00", align 1
@.str.207 = private unnamed_addr constant [25 x i8] c"%s: read bigfile failed\0A\00", align 1
@.str.208 = private unnamed_addr constant [24 x i8] c"%s: short read bigfile\0A\00", align 1
@.str.209 = private unnamed_addr constant [29 x i8] c"%s: read bigfile wrong data\0A\00", align 1
@.str.210 = private unnamed_addr constant [30 x i8] c"%s: read bigfile wrong total\0A\00", align 1
@.str.211 = private unnamed_addr constant [15 x i8] c"12345678901234\00", align 1
@.str.212 = private unnamed_addr constant [33 x i8] c"%s: mkdir 12345678901234 failed\0A\00", align 1
@.str.213 = private unnamed_addr constant [31 x i8] c"12345678901234/123456789012345\00", align 1
@.str.214 = private unnamed_addr constant [49 x i8] c"%s: mkdir 12345678901234/123456789012345 failed\0A\00", align 1
@.str.215 = private unnamed_addr constant [48 x i8] c"123456789012345/123456789012345/123456789012345\00", align 1
@.str.216 = private unnamed_addr constant [67 x i8] c"%s: create 123456789012345/123456789012345/123456789012345 failed\0A\00", align 1
@.str.217 = private unnamed_addr constant [45 x i8] c"12345678901234/12345678901234/12345678901234\00", align 1
@.str.218 = private unnamed_addr constant [62 x i8] c"%s: open 12345678901234/12345678901234/12345678901234 failed\0A\00", align 1
@.str.219 = private unnamed_addr constant [30 x i8] c"12345678901234/12345678901234\00", align 1
@.str.220 = private unnamed_addr constant [52 x i8] c"%s: mkdir 12345678901234/12345678901234 succeeded!\0A\00", align 1
@.str.221 = private unnamed_addr constant [31 x i8] c"123456789012345/12345678901234\00", align 1
@.str.222 = private unnamed_addr constant [53 x i8] c"%s: mkdir 12345678901234/123456789012345 succeeded!\0A\00", align 1
@.str.223 = private unnamed_addr constant [5 x i8] c"dots\00", align 1
@.str.224 = private unnamed_addr constant [23 x i8] c"%s: mkdir dots failed\0A\00", align 1
@.str.225 = private unnamed_addr constant [23 x i8] c"%s: chdir dots failed\0A\00", align 1
@.str.226 = private unnamed_addr constant [18 x i8] c"%s: rm . worked!\0A\00", align 1
@.str.227 = private unnamed_addr constant [19 x i8] c"%s: rm .. worked!\0A\00", align 1
@.str.228 = private unnamed_addr constant [7 x i8] c"dots/.\00", align 1
@.str.229 = private unnamed_addr constant [27 x i8] c"%s: unlink dots/. worked!\0A\00", align 1
@.str.230 = private unnamed_addr constant [8 x i8] c"dots/..\00", align 1
@.str.231 = private unnamed_addr constant [28 x i8] c"%s: unlink dots/.. worked!\0A\00", align 1
@.str.232 = private unnamed_addr constant [25 x i8] c"%s: unlink dots failed!\0A\00", align 1
@.str.233 = private unnamed_addr constant [8 x i8] c"dirfile\00", align 1
@.str.234 = private unnamed_addr constant [27 x i8] c"%s: create dirfile failed\0A\00", align 1
@.str.235 = private unnamed_addr constant [30 x i8] c"%s: chdir dirfile succeeded!\0A\00", align 1
@.str.236 = private unnamed_addr constant [11 x i8] c"dirfile/xx\00", align 1
@.str.237 = private unnamed_addr constant [34 x i8] c"%s: create dirfile/xx succeeded!\0A\00", align 1
@.str.238 = private unnamed_addr constant [33 x i8] c"%s: mkdir dirfile/xx succeeded!\0A\00", align 1
@.str.239 = private unnamed_addr constant [34 x i8] c"%s: unlink dirfile/xx succeeded!\0A\00", align 1
@.str.240 = private unnamed_addr constant [35 x i8] c"%s: link to dirfile/xx succeeded!\0A\00", align 1
@.str.241 = private unnamed_addr constant [28 x i8] c"%s: unlink dirfile failed!\0A\00", align 1
@.str.242 = private unnamed_addr constant [35 x i8] c"%s: open . for writing succeeded!\0A\00", align 1
@.str.243 = private unnamed_addr constant [24 x i8] c"%s: write . succeeded!\0A\00", align 1
@.str.244 = private unnamed_addr constant [6 x i8] c"irefd\00", align 1
@.str.245 = private unnamed_addr constant [24 x i8] c"%s: mkdir irefd failed\0A\00", align 1
@.str.246 = private unnamed_addr constant [24 x i8] c"%s: chdir irefd failed\0A\00", align 1
@.str.247 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.248 = private unnamed_addr constant [21 x i8] c"%s: no fork at all!\0A\00", align 1
@.str.249 = private unnamed_addr constant [38 x i8] c"%s: fork claimed to work 1000 times!\0A\00", align 1
@.str.250 = private unnamed_addr constant [24 x i8] c"%s: wait stopped early\0A\00", align 1
@.str.251 = private unnamed_addr constant [23 x i8] c"%s: wait got too many\0A\00", align 1
@.str.252 = private unnamed_addr constant [26 x i8] c"fork failed in sbrkbasic\0A\00", align 1
@.str.253 = private unnamed_addr constant [32 x i8] c"%s: too much memory allocated!\0A\00", align 1
@.str.254 = private unnamed_addr constant [31 x i8] c"%s: sbrk test failed %d %p %p\0A\00", align 1
@.str.255 = private unnamed_addr constant [27 x i8] c"%s: sbrk test fork failed\0A\00", align 1
@.str.256 = private unnamed_addr constant [32 x i8] c"%s: sbrk test failed post-fork\0A\00", align 1
@.str.257 = private unnamed_addr constant [66 x i8] c"%s: sbrk test failed to grow big address space; enough phys mem?\0A\00", align 1
@.str.258 = private unnamed_addr constant [31 x i8] c"%s: sbrk could not deallocate\0A\00", align 1
@.str.259 = private unnamed_addr constant [57 x i8] c"%s: sbrk deallocation produced wrong address, a %p c %p\0A\00", align 1
@.str.260 = private unnamed_addr constant [42 x i8] c"%s: sbrk re-allocation failed, a %p c %p\0A\00", align 1
@.str.261 = private unnamed_addr constant [49 x i8] c"%s: sbrk de-allocation didn't really deallocate\0A\00", align 1
@.str.262 = private unnamed_addr constant [37 x i8] c"%s: sbrk downsize failed, a %p c %p\0A\00", align 1
@.str.263 = private unnamed_addr constant [29 x i8] c"%s: oops could read %p = %x\0A\00", align 1
@.str.264 = private unnamed_addr constant [19 x i8] c"%s: oops wrote %p\0A\00", align 1
@.str.265 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.266 = private unnamed_addr constant [2 x i8] c"1\00", align 1
@.str.267 = private unnamed_addr constant [42 x i8] c"%s: no allocation failed; allocate more?\0A\00", align 1
@.str.268 = private unnamed_addr constant [31 x i8] c"%s: failed sbrk leaked memory\0A\00", align 1
@.str.269 = private unnamed_addr constant [43 x i8] c"%s: allocate a lot of memory succeeded %d\0A\00", align 1
@.str.270 = private unnamed_addr constant [5 x i8] c"sbrk\00", align 1
@.str.271 = private unnamed_addr constant [22 x i8] c"%s: open sbrk failed\0A\00", align 1
@.str.272 = private unnamed_addr constant [23 x i8] c"%s: write sbrk failed\0A\00", align 1
@.str.273 = private unnamed_addr constant [11 x i8] c"nosuchfile\00", align 1
@.str.274 = private unnamed_addr constant [29 x i8] c"%s: link should not succeed\0A\00", align 1
@uninit = dso_local local_unnamed_addr global [10000 x i8] zeroinitializer, align 1
@.str.275 = private unnamed_addr constant [21 x i8] c"%s: bss test failed\0A\00", align 1
@.str.276 = private unnamed_addr constant [10 x i8] c"bigarg-ok\00", align 1
@bigargtest.args = internal global [32 x ptr] zeroinitializer, align 4
@.str.277 = private unnamed_addr constant [29 x i8] c"%s: bigargtest: fork failed\0A\00", align 1
@.str.278 = private unnamed_addr constant [25 x i8] c"%s: bigarg test failed!\0A\00", align 1
@.str.279 = private unnamed_addr constant [13 x i8] c"fsfull test\0A\00", align 1
@.str.280 = private unnamed_addr constant [12 x i8] c"writing %s\0A\00", align 1
@.str.281 = private unnamed_addr constant [16 x i8] c"open %s failed\0A\00", align 1
@.str.282 = private unnamed_addr constant [16 x i8] c"wrote %d bytes\0A\00", align 1
@.str.283 = private unnamed_addr constant [33 x i8] c"fsfull test finished, %d blocks\0A\00", align 1
@.str.284 = private unnamed_addr constant [5 x i8] c"init\00", align 1
@.str.285 = private unnamed_addr constant [36 x i8] c"%s: stacktest: read below stack %d\0A\00", align 1
@__const.nowrite.addrs = private unnamed_addr constant [6 x i32] [i32 0, i32 -2147483648, i32 -8192, i32 -4096, i32 0, i32 -1], align 4
@.str.286 = private unnamed_addr constant [31 x i8] c"%s: write to %p did not fail!\0A\00", align 1
@big = dso_local local_unnamed_addr global ptr inttoptr (i32 12126 to ptr), align 4
@.str.287 = private unnamed_addr constant [19 x i8] c"sbrklazy() failed\0A\00", align 1
@.str.288 = private unnamed_addr constant [34 x i8] c"failed to read value from memory\0A\00", align 1
@.str.289 = private unnamed_addr constant [15 x i8] c"error forking\0A\00", align 1
@.str.290 = private unnamed_addr constant [21 x i8] c"memory not unmapped\0A\00", align 1
@.str.291 = private unnamed_addr constant [41 x i8] c"sbrk(sbrk(0)+1) returned %p, not old sz\0A\00", align 1
@__const.lazy_copy.bad = private unnamed_addr constant [6 x i32] [i32 -16384, i32 -12288, i32 -8192, i32 -4096, i32 0, i32 0], align 4
@.str.292 = private unnamed_addr constant [20 x i8] c"cannot open README\0A\00", align 1
@.str.293 = private unnamed_addr constant [16 x i8] c"read succeeded\0A\00", align 1
@.str.294 = private unnamed_addr constant [5 x i8] c"junk\00", align 1
@.str.295 = private unnamed_addr constant [18 x i8] c"cannot open junk\0A\00", align 1
@.str.296 = private unnamed_addr constant [17 x i8] c"write succeeded\0A\00", align 1
@.str.297 = private unnamed_addr constant [24 x i8] c"%s: sbrk did not align\0A\00", align 1
@.str.298 = private unnamed_addr constant [17 x i8] c"could not open /\00", align 1
@.str.299 = private unnamed_addr constant [17 x i8] c"could not stat /\00", align 1
@.str.300 = private unnamed_addr constant [15 x i8] c"/ is not T_DIR\00", align 1
@.str.302 = private unnamed_addr constant [43 x i8] c"sbrklazy(%d) returned %p, not expected %p\0A\00", align 1
@.str.303 = private unnamed_addr constant [53 x i8] c"sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\0A\00", align 1
@.str.304 = private unnamed_addr constant [40 x i8] c"sbrk() returned non-zero-filled memory\0A\00", align 1
@.str.305 = private unnamed_addr constant [37 x i8] c"sbrk(1) returned %p, expected error\0A\00", align 1
@.str.306 = private unnamed_addr constant [41 x i8] c"sbrklazy(1) returned %p, expected error\0A\00", align 1
@.str.307 = private unnamed_addr constant [9 x i8] c"testfile\00", align 1
@.str.308 = private unnamed_addr constant [28 x i8] c"%s: cannot create testfile\0A\00", align 1
@.str.309 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.310 = private unnamed_addr constant [23 x i8] c"%s: could not write A\0A\00", align 1
@.str.311 = private unnamed_addr constant [29 x i8] c"%s: cannot re-open testfile\0A\00", align 1
@.str.312 = private unnamed_addr constant [41 x i8] c"%s: write succeeded, should have failed\0A\00", align 1
@.str.313 = private unnamed_addr constant [26 x i8] c"%s: cannot read testfile\0A\00", align 1
@.str.314 = private unnamed_addr constant [34 x i8] c"%s: read returned %c, expected X\0A\00", align 1
@.str.315 = private unnamed_addr constant [8 x i8] c"bigfile\00", align 1
@.str.316 = private unnamed_addr constant [32 x i8] c"%s: could not write to bigfile\0A\00", align 1
@.str.317 = private unnamed_addr constant [3 x i8] c"/a\00", align 1
@.str.318 = private unnamed_addr constant [21 x i8] c"%s: mkdir /a failed\0A\00", align 1
@.str.319 = private unnamed_addr constant [5 x i8] c"/a/b\00", align 1
@.str.320 = private unnamed_addr constant [23 x i8] c"%s: mkdir /a/b failed\0A\00", align 1
@.str.321 = private unnamed_addr constant [18 x i8] c"%s: chdir failed\0A\00", align 1
@.str.322 = private unnamed_addr constant [24 x i8] c"%s: unlink /a/b failed\0A\00", align 1
@.str.323 = private unnamed_addr constant [22 x i8] c"%s: unlink /a failed\0A\00", align 1
@.str.324 = private unnamed_addr constant [4 x i8] c"../\00", align 1
@.str.325 = private unnamed_addr constant [37 x i8] c"%s: open ../ non-existing directory\0A\00", align 1
@.str.326 = private unnamed_addr constant [5 x i8] c"../c\00", align 1
@.str.327 = private unnamed_addr constant [35 x i8] c"%s: create ../c non-existing file\0A\00", align 1
@.str.328 = private unnamed_addr constant [7 x i8] c"copyin\00", align 1
@.str.329 = private unnamed_addr constant [8 x i8] c"copyout\00", align 1
@.str.330 = private unnamed_addr constant [11 x i8] c"copyinstr1\00", align 1
@.str.331 = private unnamed_addr constant [11 x i8] c"copyinstr2\00", align 1
@.str.332 = private unnamed_addr constant [11 x i8] c"copyinstr3\00", align 1
@.str.333 = private unnamed_addr constant [10 x i8] c"truncate1\00", align 1
@.str.334 = private unnamed_addr constant [10 x i8] c"truncate2\00", align 1
@.str.335 = private unnamed_addr constant [10 x i8] c"truncate3\00", align 1
@.str.336 = private unnamed_addr constant [9 x i8] c"openiput\00", align 1
@.str.337 = private unnamed_addr constant [9 x i8] c"exitiput\00", align 1
@.str.338 = private unnamed_addr constant [5 x i8] c"iput\00", align 1
@.str.339 = private unnamed_addr constant [9 x i8] c"opentest\00", align 1
@.str.340 = private unnamed_addr constant [10 x i8] c"writetest\00", align 1
@.str.341 = private unnamed_addr constant [9 x i8] c"writebig\00", align 1
@.str.342 = private unnamed_addr constant [11 x i8] c"createtest\00", align 1
@.str.343 = private unnamed_addr constant [8 x i8] c"dirtest\00", align 1
@.str.344 = private unnamed_addr constant [9 x i8] c"exectest\00", align 1
@.str.345 = private unnamed_addr constant [6 x i8] c"pipe1\00", align 1
@.str.346 = private unnamed_addr constant [11 x i8] c"killstatus\00", align 1
@.str.347 = private unnamed_addr constant [8 x i8] c"preempt\00", align 1
@.str.348 = private unnamed_addr constant [9 x i8] c"exitwait\00", align 1
@.str.349 = private unnamed_addr constant [9 x i8] c"reparent\00", align 1
@.str.350 = private unnamed_addr constant [12 x i8] c"twochildren\00", align 1
@.str.351 = private unnamed_addr constant [9 x i8] c"forkfork\00", align 1
@.str.352 = private unnamed_addr constant [13 x i8] c"forkforkfork\00", align 1
@.str.353 = private unnamed_addr constant [10 x i8] c"reparent2\00", align 1
@.str.354 = private unnamed_addr constant [4 x i8] c"mem\00", align 1
@.str.355 = private unnamed_addr constant [10 x i8] c"fourfiles\00", align 1
@.str.356 = private unnamed_addr constant [13 x i8] c"createdelete\00", align 1
@.str.357 = private unnamed_addr constant [9 x i8] c"linktest\00", align 1
@.str.358 = private unnamed_addr constant [10 x i8] c"concreate\00", align 1
@.str.359 = private unnamed_addr constant [11 x i8] c"linkunlink\00", align 1
@.str.360 = private unnamed_addr constant [7 x i8] c"subdir\00", align 1
@.str.361 = private unnamed_addr constant [9 x i8] c"fourteen\00", align 1
@.str.362 = private unnamed_addr constant [6 x i8] c"rmdot\00", align 1
@.str.363 = private unnamed_addr constant [5 x i8] c"iref\00", align 1
@.str.364 = private unnamed_addr constant [9 x i8] c"forktest\00", align 1
@.str.365 = private unnamed_addr constant [10 x i8] c"sbrkbasic\00", align 1
@.str.366 = private unnamed_addr constant [9 x i8] c"sbrkmuch\00", align 1
@.str.367 = private unnamed_addr constant [8 x i8] c"kernmem\00", align 1
@.str.368 = private unnamed_addr constant [10 x i8] c"MAXVAplus\00", align 1
@.str.369 = private unnamed_addr constant [9 x i8] c"sbrkfail\00", align 1
@.str.370 = private unnamed_addr constant [8 x i8] c"sbrkarg\00", align 1
@.str.371 = private unnamed_addr constant [13 x i8] c"validatetest\00", align 1
@.str.372 = private unnamed_addr constant [8 x i8] c"bsstest\00", align 1
@.str.373 = private unnamed_addr constant [11 x i8] c"bigargtest\00", align 1
@.str.374 = private unnamed_addr constant [9 x i8] c"argptest\00", align 1
@.str.375 = private unnamed_addr constant [10 x i8] c"stacktest\00", align 1
@.str.376 = private unnamed_addr constant [8 x i8] c"nowrite\00", align 1
@.str.377 = private unnamed_addr constant [6 x i8] c"pgbug\00", align 1
@.str.378 = private unnamed_addr constant [9 x i8] c"sbrkbugs\00", align 1
@.str.379 = private unnamed_addr constant [9 x i8] c"sbrklast\00", align 1
@.str.380 = private unnamed_addr constant [9 x i8] c"sbrk8000\00", align 1
@.str.381 = private unnamed_addr constant [7 x i8] c"badarg\00", align 1
@.str.382 = private unnamed_addr constant [11 x i8] c"lazy_alloc\00", align 1
@.str.383 = private unnamed_addr constant [11 x i8] c"lazy_unmap\00", align 1
@.str.384 = private unnamed_addr constant [10 x i8] c"lazy_copy\00", align 1
@.str.385 = private unnamed_addr constant [15 x i8] c"lazy_copyinstr\00", align 1
@.str.386 = private unnamed_addr constant [10 x i8] c"lazy_sbrk\00", align 1
@.str.387 = private unnamed_addr constant [14 x i8] c"partial_write\00", align 1
@.str.388 = private unnamed_addr constant [10 x i8] c"unlinkcwd\00", align 1
@quicktests = dso_local global [68 x %struct.test] [%struct.test { ptr @copyin, ptr @.str.328 }, %struct.test { ptr @copyout, ptr @.str.329 }, %struct.test { ptr @copyinstr1, ptr @.str.330 }, %struct.test { ptr @copyinstr2, ptr @.str.331 }, %struct.test { ptr @copyinstr3, ptr @.str.332 }, %struct.test { ptr @rwsbrk, ptr @.str.25 }, %struct.test { ptr @truncate1, ptr @.str.333 }, %struct.test { ptr @truncate2, ptr @.str.334 }, %struct.test { ptr @truncate3, ptr @.str.335 }, %struct.test { ptr @openiputtest, ptr @.str.336 }, %struct.test { ptr @exitiputtest, ptr @.str.337 }, %struct.test { ptr @iputtest, ptr @.str.338 }, %struct.test { ptr @opentest, ptr @.str.339 }, %struct.test { ptr @writetest, ptr @.str.340 }, %struct.test { ptr @writebig, ptr @.str.341 }, %struct.test { ptr @createtest, ptr @.str.342 }, %struct.test { ptr @dirtest, ptr @.str.343 }, %struct.test { ptr @exectest, ptr @.str.344 }, %struct.test { ptr @pipe1, ptr @.str.345 }, %struct.test { ptr @killstatus, ptr @.str.346 }, %struct.test { ptr @preempt, ptr @.str.347 }, %struct.test { ptr @exitwait, ptr @.str.348 }, %struct.test { ptr @reparent, ptr @.str.349 }, %struct.test { ptr @twochildren, ptr @.str.350 }, %struct.test { ptr @forkfork, ptr @.str.351 }, %struct.test { ptr @forkforkfork, ptr @.str.352 }, %struct.test { ptr @reparent2, ptr @.str.353 }, %struct.test { ptr @mem, ptr @.str.354 }, %struct.test { ptr @sharedfd, ptr @.str.107 }, %struct.test { ptr @fourfiles, ptr @.str.355 }, %struct.test { ptr @createdelete, ptr @.str.356 }, %struct.test { ptr @unlinkread, ptr @.str.121 }, %struct.test { ptr @linktest, ptr @.str.357 }, %struct.test { ptr @concreate, ptr @.str.358 }, %struct.test { ptr @linkunlink, ptr @.str.359 }, %struct.test { ptr @subdir, ptr @.str.360 }, %struct.test { ptr @bigwrite, ptr @.str.200 }, %struct.test { ptr @bigfile, ptr @.str.315 }, %struct.test { ptr @fourteen, ptr @.str.361 }, %struct.test { ptr @rmdot, ptr @.str.362 }, %struct.test { ptr @dirfile, ptr @.str.233 }, %struct.test { ptr @iref, ptr @.str.363 }, %struct.test { ptr @forktest, ptr @.str.364 }, %struct.test { ptr @sbrkbasic, ptr @.str.365 }, %struct.test { ptr @sbrkmuch, ptr @.str.366 }, %struct.test { ptr @kernmem, ptr @.str.367 }, %struct.test { ptr @MAXVAplus, ptr @.str.368 }, %struct.test { ptr @sbrkfail, ptr @.str.369 }, %struct.test { ptr @sbrkarg, ptr @.str.370 }, %struct.test { ptr @validatetest, ptr @.str.371 }, %struct.test { ptr @bsstest, ptr @.str.372 }, %struct.test { ptr @bigargtest, ptr @.str.373 }, %struct.test { ptr @argptest, ptr @.str.374 }, %struct.test { ptr @stacktest, ptr @.str.375 }, %struct.test { ptr @nowrite, ptr @.str.376 }, %struct.test { ptr @pgbug, ptr @.str.377 }, %struct.test { ptr @sbrkbugs, ptr @.str.378 }, %struct.test { ptr @sbrklast, ptr @.str.379 }, %struct.test { ptr @sbrk8000, ptr @.str.380 }, %struct.test { ptr @badarg, ptr @.str.381 }, %struct.test { ptr @lazy_alloc, ptr @.str.382 }, %struct.test { ptr @lazy_unmap, ptr @.str.383 }, %struct.test { ptr @lazy_copy, ptr @.str.384 }, %struct.test { ptr @lazy_copyinstr, ptr @.str.385 }, %struct.test { ptr @lazy_sbrk, ptr @.str.386 }, %struct.test { ptr @partial_write, ptr @.str.387 }, %struct.test { ptr @unlinkcwd, ptr @.str.388 }, %struct.test zeroinitializer], align 4
@.str.389 = private unnamed_addr constant [3 x i8] c"bd\00", align 1
@.str.390 = private unnamed_addr constant [26 x i8] c"%s: bigdir create failed\0A\00", align 1
@.str.391 = private unnamed_addr constant [37 x i8] c"%s: bigdir i=%d link(bd, %s) failed\0A\00", align 1
@.str.392 = private unnamed_addr constant [25 x i8] c"%s: bigdir unlink failed\00", align 1
@.str.393 = private unnamed_addr constant [22 x i8] c"%s: cannot create %s\0A\00", align 1
@.str.394 = private unnamed_addr constant [18 x i8] c"open junk failed\0A\00", align 1
@.str.395 = private unnamed_addr constant [14 x i8] c"write failed\0A\00", align 1
@__const.execout.args = private unnamed_addr constant [3 x ptr] [ptr @.str.19, ptr @.str.9, ptr null], align 4
@.str.396 = private unnamed_addr constant [12 x i8] c"diskfulldir\00", align 1
@.str.397 = private unnamed_addr constant [30 x i8] c"%s: could not create file %s\0A\00", align 1
@.str.398 = private unnamed_addr constant [48 x i8] c"%s: mkdir(diskfulldir) unexpectedly succeeded!\0A\00", align 1
@.str.399 = private unnamed_addr constant [7 x i8] c"bigdir\00", align 1
@.str.400 = private unnamed_addr constant [11 x i8] c"manywrites\00", align 1
@.str.401 = private unnamed_addr constant [9 x i8] c"badwrite\00", align 1
@.str.402 = private unnamed_addr constant [8 x i8] c"execout\00", align 1
@.str.403 = private unnamed_addr constant [9 x i8] c"diskfull\00", align 1
@.str.404 = private unnamed_addr constant [12 x i8] c"outofinodes\00", align 1
@slowtests = dso_local global [7 x %struct.test] [%struct.test { ptr @bigdir, ptr @.str.399 }, %struct.test { ptr @manywrites, ptr @.str.400 }, %struct.test { ptr @badwrite, ptr @.str.401 }, %struct.test { ptr @execout, ptr @.str.402 }, %struct.test { ptr @diskfull, ptr @.str.403 }, %struct.test { ptr @outofinodes, ptr @.str.404 }, %struct.test zeroinitializer], align 4
@.str.405 = private unnamed_addr constant [10 x i8] c"test %s: \00", align 1
@.str.406 = private unnamed_addr constant [21 x i8] c"runtest: fork error\0A\00", align 1
@.str.407 = private unnamed_addr constant [8 x i8] c"FAILED\0A\00", align 1
@.str.408 = private unnamed_addr constant [4 x i8] c"OK\0A\00", align 1
@.str.409 = private unnamed_addr constant [19 x i8] c"SOME TESTS FAILED\0A\00", align 1
@.str.410 = private unnamed_addr constant [20 x i8] c"usertests starting\0A\00", align 1
@.str.411 = private unnamed_addr constant [31 x i8] c"usertests slow tests starting\0A\00", align 1
@.str.412 = private unnamed_addr constant [47 x i8] c"FAILED -- lost some free pages %d (out of %d)\0A\00", align 1
@.str.413 = private unnamed_addr constant [19 x i8] c"NO TESTS EXECUTED\0A\00", align 1
@.str.414 = private unnamed_addr constant [3 x i8] c"-q\00", align 1
@.str.415 = private unnamed_addr constant [3 x i8] c"-c\00", align 1
@.str.416 = private unnamed_addr constant [3 x i8] c"-C\00", align 1
@.str.417 = private unnamed_addr constant [44 x i8] c"Usage: usertests [-c] [-C] [-q] [testname]\0A\00", align 1
@.str.418 = private unnamed_addr constant [18 x i8] c"ALL TESTS PASSED\0A\00", align 1

; Function Attrs: minsize nounwind optsize
define dso_local void @copyin(ptr readnone captures(none) %0) #0 {
  %2 = alloca [2 x i32], align 4
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %4

4:                                                ; preds = %39, %1
  %5 = phi i32 [ 0, %1 ], [ %44, %39 ]
  %6 = icmp eq i32 %5, 5
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [5 x i32], ptr @__const.copyinstr1.addrs, i32 0, i32 %5
  %10 = load i32, ptr %9, align 4, !tbaa !3
  %11 = call i32 @open(ptr noundef nonnull @.str, i32 noundef 513) #7
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %8
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.1) #7
  %14 = call i32 @exit(i32 noundef 1) #8
  unreachable

15:                                               ; preds = %8
  %16 = inttoptr i32 %10 to ptr
  %17 = call i32 @write(i32 noundef %11, ptr noundef %16, i32 noundef 8192) #7
  %18 = icmp sgt i32 %17, -1
  br i1 %18, label %19, label %21

19:                                               ; preds = %15
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.2, ptr noundef %16, i32 noundef %17) #7
  %20 = call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %15
  %22 = call i32 @close(i32 noundef %11) #7
  %23 = call i32 @unlink(ptr noundef nonnull @.str) #7
  %24 = call i32 @write(i32 noundef 1, ptr noundef %16, i32 noundef 8192) #7
  %25 = icmp sgt i32 %24, 0
  br i1 %25, label %26, label %28

26:                                               ; preds = %21
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.3, ptr noundef %16, i32 noundef %24) #7
  %27 = call i32 @exit(i32 noundef 1) #8
  unreachable

28:                                               ; preds = %21
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #9
  %29 = call i32 @pipe(ptr noundef nonnull %2) #7
  %30 = icmp slt i32 %29, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %28
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.4) #7
  %32 = call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %28
  %34 = load i32, ptr %3, align 4, !tbaa !7
  %35 = call i32 @write(i32 noundef %34, ptr noundef %16, i32 noundef 8192) #7
  %36 = icmp sgt i32 %35, 0
  br i1 %36, label %37, label %39

37:                                               ; preds = %33
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.5, ptr noundef %16, i32 noundef %35) #7
  %38 = call i32 @exit(i32 noundef 1) #8
  unreachable

39:                                               ; preds = %33
  %40 = load i32, ptr %2, align 4, !tbaa !7
  %41 = call i32 @close(i32 noundef %40) #7
  %42 = load i32, ptr %3, align 4, !tbaa !7
  %43 = call i32 @close(i32 noundef %42) #7
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #9
  %44 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !9
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i32, i1 immarg) #2

; Function Attrs: minsize optsize
declare dso_local i32 @open(ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @printf(ptr noundef, ...) local_unnamed_addr #3

; Function Attrs: minsize noreturn optsize
declare dso_local i32 @exit(i32 noundef) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare dso_local i32 @write(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @close(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @unlink(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @pipe(ptr noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: minsize nounwind optsize
define dso_local void @copyout(ptr readnone captures(none) %0) #0 {
  %2 = alloca [2 x i32], align 4
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %4

4:                                                ; preds = %39, %1
  %5 = phi i32 [ 0, %1 ], [ %44, %39 ]
  %6 = icmp eq i32 %5, 6
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw [6 x i32], ptr @__const.nowrite.addrs, i32 0, i32 %5
  %10 = load i32, ptr %9, align 4, !tbaa !3
  %11 = call i32 @open(ptr noundef nonnull @.str.6, i32 noundef 0) #7
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %8
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.7) #7
  %14 = call i32 @exit(i32 noundef 1) #8
  unreachable

15:                                               ; preds = %8
  %16 = inttoptr i32 %10 to ptr
  %17 = call i32 @read(i32 noundef %11, ptr noundef %16, i32 noundef 8192) #7
  %18 = icmp sgt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %15
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.8, ptr noundef %16, i32 noundef %17) #7
  %20 = call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %15
  %22 = call i32 @close(i32 noundef %11) #7
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #9
  %23 = call i32 @pipe(ptr noundef nonnull %2) #7
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %21
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.4) #7
  %26 = call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %21
  %28 = load i32, ptr %3, align 4, !tbaa !7
  %29 = call i32 @write(i32 noundef %28, ptr noundef nonnull @.str.9, i32 noundef 1) #7
  %30 = icmp eq i32 %29, 1
  br i1 %30, label %33, label %31

31:                                               ; preds = %27
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.10) #7
  %32 = call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %27
  %34 = load i32, ptr %2, align 4, !tbaa !7
  %35 = call i32 @read(i32 noundef %34, ptr noundef %16, i32 noundef 8192) #7
  %36 = icmp sgt i32 %35, 0
  br i1 %36, label %37, label %39

37:                                               ; preds = %33
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.11, ptr noundef %16, i32 noundef %35) #7
  %38 = call i32 @exit(i32 noundef 1) #8
  unreachable

39:                                               ; preds = %33
  %40 = load i32, ptr %2, align 4, !tbaa !7
  %41 = call i32 @close(i32 noundef %40) #7
  %42 = load i32, ptr %3, align 4, !tbaa !7
  %43 = call i32 @close(i32 noundef %42) #7
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #9
  %44 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !12
}

; Function Attrs: minsize optsize
declare dso_local i32 @read(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @copyinstr1(ptr readnone captures(none) %0) #0 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i32 [ 0, %1 ], [ %12, %6 ]
  %4 = icmp eq i32 %3, 5
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  ret void

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw [5 x i32], ptr @__const.copyinstr1.addrs, i32 0, i32 %3
  %8 = load i32, ptr %7, align 4, !tbaa !3
  %9 = inttoptr i32 %8 to ptr
  %10 = tail call i32 @open(ptr noundef %9, i32 noundef 513) #7
  %11 = icmp sgt i32 %10, -1
  %12 = add nuw nsw i32 %3, 1
  br i1 %11, label %13, label %2, !llvm.loop !13

13:                                               ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.12, ptr noundef %9, i32 noundef %10) #7
  %14 = tail call i32 @exit(i32 noundef 1) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @copyinstr2(ptr readnone captures(none) %0) #0 {
  %2 = alloca [129 x i8], align 1
  %3 = alloca [2 x ptr], align 8
  %4 = alloca [4 x ptr], align 4
  %5 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 129, ptr nonnull %2) #9
  br label %6

6:                                                ; preds = %13, %1
  %7 = phi i32 [ 0, %1 ], [ %15, %13 ]
  %8 = icmp eq i32 %7, 128
  br i1 %8, label %9, label %13

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 128
  store i8 0, ptr %10, align 1, !tbaa !14
  %11 = call i32 @unlink(ptr noundef nonnull %2) #7
  %12 = icmp eq i32 %11, -1
  br i1 %12, label %18, label %16

13:                                               ; preds = %6
  %14 = getelementptr inbounds nuw [129 x i8], ptr %2, i32 0, i32 %7
  store i8 120, ptr %14, align 1, !tbaa !14
  %15 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !15

16:                                               ; preds = %9
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.13, ptr noundef nonnull %2, i32 noundef %11) #7
  %17 = call i32 @exit(i32 noundef 1) #8
  unreachable

18:                                               ; preds = %9
  %19 = call i32 @open(ptr noundef nonnull %2, i32 noundef 513) #7
  %20 = icmp eq i32 %19, -1
  br i1 %20, label %23, label %21

21:                                               ; preds = %18
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.14, ptr noundef nonnull %2, i32 noundef %19) #7
  %22 = call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %18
  %24 = call i32 @link(ptr noundef nonnull %2, ptr noundef nonnull %2) #7
  %25 = icmp eq i32 %24, -1
  br i1 %25, label %28, label %26

26:                                               ; preds = %23
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.15, ptr noundef nonnull %2, ptr noundef nonnull %2, i32 noundef %24) #7
  %27 = call i32 @exit(i32 noundef 1) #8
  unreachable

28:                                               ; preds = %23
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #9
  %29 = load i64, ptr @__const.copyinstr3.args, align 8
  store i64 %29, ptr %3, align 8
  %30 = call i32 @exec(ptr noundef nonnull %2, ptr noundef nonnull %3) #7
  %31 = icmp eq i32 %30, -1
  br i1 %31, label %34, label %32

32:                                               ; preds = %28
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.17, ptr noundef nonnull %2, i32 noundef -1) #7
  %33 = call i32 @exit(i32 noundef 1) #8
  unreachable

34:                                               ; preds = %28
  %35 = call i32 @fork() #7
  %36 = icmp slt i32 %35, 0
  br i1 %36, label %37, label %39

37:                                               ; preds = %34
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %38 = call i32 @exit(i32 noundef 1) #8
  unreachable

39:                                               ; preds = %34
  %40 = icmp eq i32 %35, 0
  br i1 %40, label %41, label %54

41:                                               ; preds = %39, %47
  %42 = phi i32 [ %49, %47 ], [ 0, %39 ]
  %43 = icmp eq i32 %42, 4096
  br i1 %43, label %44, label %47

44:                                               ; preds = %41
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @copyinstr2.big, i32 4096), align 1, !tbaa !14
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #9
  call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(16) %4, ptr noundef nonnull align 4 dereferenceable(16) @__const.copyinstr2.args2, i32 16, i1 false)
  %45 = call i32 @exec(ptr noundef nonnull @.str.19, ptr noundef nonnull %4) #7
  %46 = icmp eq i32 %45, -1
  br i1 %46, label %52, label %50

47:                                               ; preds = %41
  %48 = getelementptr inbounds nuw [4097 x i8], ptr @copyinstr2.big, i32 0, i32 %42
  store i8 120, ptr %48, align 1, !tbaa !14
  %49 = add nuw nsw i32 %42, 1
  br label %41, !llvm.loop !16

50:                                               ; preds = %44
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.20, i32 noundef -1) #7
  %51 = call i32 @exit(i32 noundef 1) #8
  unreachable

52:                                               ; preds = %44
  %53 = call i32 @exit(i32 noundef 747) #8
  unreachable

54:                                               ; preds = %39
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #9
  store i32 0, ptr %5, align 4, !tbaa !7
  %55 = call i32 @wait(ptr noundef nonnull %5) #7
  %56 = load i32, ptr %5, align 4, !tbaa !7
  %57 = icmp eq i32 %56, 747
  br i1 %57, label %60, label %58

58:                                               ; preds = %54
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.21) #7
  %59 = call i32 @exit(i32 noundef 1) #8
  unreachable

60:                                               ; preds = %54
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #9
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 129, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @link(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @exec(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @fork() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @wait(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @copyinstr3(ptr readnone captures(none) %0) #0 {
  %2 = alloca [2 x ptr], align 8
  %3 = tail call ptr @sbrk(i32 noundef 8192) #7
  %4 = tail call ptr @sbrk(i32 noundef 0) #7
  %5 = ptrtoint ptr %4 to i32
  %6 = and i32 %5, 4095
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %11, label %8

8:                                                ; preds = %1
  %9 = sub nuw nsw i32 4096, %6
  %10 = tail call ptr @sbrk(i32 noundef %9) #7
  br label %11

11:                                               ; preds = %8, %1
  %12 = tail call ptr @sbrk(i32 noundef 0) #7
  %13 = ptrtoint ptr %12 to i32
  %14 = and i32 %13, 4095
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %18, label %16

16:                                               ; preds = %11
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.22) #7
  %17 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

18:                                               ; preds = %11
  %19 = add i32 %13, -1
  %20 = inttoptr i32 %19 to ptr
  store i8 120, ptr %20, align 1, !tbaa !14
  %21 = tail call i32 @unlink(ptr noundef nonnull %20) #7
  %22 = icmp eq i32 %21, -1
  br i1 %22, label %25, label %23

23:                                               ; preds = %18
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.13, ptr noundef nonnull %20, i32 noundef %21) #7
  %24 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

25:                                               ; preds = %18
  %26 = tail call i32 @open(ptr noundef nonnull %20, i32 noundef 513) #7
  %27 = icmp eq i32 %26, -1
  br i1 %27, label %30, label %28

28:                                               ; preds = %25
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.14, ptr noundef nonnull %20, i32 noundef %26) #7
  %29 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

30:                                               ; preds = %25
  %31 = tail call i32 @link(ptr noundef nonnull %20, ptr noundef nonnull %20) #7
  %32 = icmp eq i32 %31, -1
  br i1 %32, label %35, label %33

33:                                               ; preds = %30
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.15, ptr noundef nonnull %20, ptr noundef nonnull %20, i32 noundef %31) #7
  %34 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

35:                                               ; preds = %30
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #9
  %36 = load i64, ptr @__const.copyinstr3.args, align 8
  store i64 %36, ptr %2, align 8
  %37 = call i32 @exec(ptr noundef nonnull %20, ptr noundef nonnull %2) #7
  %38 = icmp eq i32 %37, -1
  br i1 %38, label %41, label %39

39:                                               ; preds = %35
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.17, ptr noundef nonnull %20, i32 noundef -1) #7
  %40 = call i32 @exit(i32 noundef 1) #8
  unreachable

41:                                               ; preds = %35
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local ptr @sbrk(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @rwsbrk(ptr readnone captures(none) %0) #5 {
  %2 = tail call ptr @sbrk(i32 noundef 8192) #7
  %3 = ptrtoint ptr %2 to i32
  %4 = icmp eq ptr %2, inttoptr (i32 -1 to ptr)
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.23) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = tail call ptr @sbrk(i32 noundef -8192) #7
  %9 = icmp eq ptr %8, inttoptr (i32 -1 to ptr)
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.24) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %7
  %13 = tail call i32 @open(ptr noundef nonnull @.str.25, i32 noundef 513) #7
  %14 = icmp slt i32 %13, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %12
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.26) #7
  %16 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

17:                                               ; preds = %12
  %18 = add i32 %3, 4096
  %19 = inttoptr i32 %18 to ptr
  %20 = tail call i32 @write(i32 noundef %13, ptr noundef %19, i32 noundef 1024) #7
  %21 = icmp sgt i32 %20, -1
  br i1 %21, label %22, label %25

22:                                               ; preds = %17
  %23 = getelementptr inbounds nuw i8, ptr %2, i32 4096
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.27, ptr noundef nonnull %23, i32 noundef %20) #7
  %24 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

25:                                               ; preds = %17
  %26 = tail call i32 @close(i32 noundef %13) #7
  %27 = tail call i32 @unlink(ptr noundef nonnull @.str.25) #7
  %28 = tail call i32 @open(ptr noundef nonnull @.str.6, i32 noundef 0) #7
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %30, label %32

30:                                               ; preds = %25
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.7) #7
  %31 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %25
  %33 = tail call i32 @read(i32 noundef %28, ptr noundef %19, i32 noundef 10) #7
  %34 = icmp sgt i32 %33, -1
  br i1 %34, label %35, label %38

35:                                               ; preds = %32
  %36 = getelementptr inbounds nuw i8, ptr %2, i32 4096
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.28, ptr noundef nonnull %36, i32 noundef %33) #7
  %37 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

38:                                               ; preds = %32
  %39 = tail call i32 @close(i32 noundef %28) #7
  %40 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @truncate1(ptr noundef %0) #0 {
  %2 = alloca [32 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #9
  %3 = tail call i32 @unlink(ptr noundef nonnull @.str.29) #7
  %4 = tail call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1537) #7
  %5 = tail call i32 @write(i32 noundef %4, ptr noundef nonnull @.str.30, i32 noundef 4) #7
  %6 = tail call i32 @close(i32 noundef %4) #7
  %7 = tail call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 0) #7
  %8 = call i32 @read(i32 noundef %7, ptr noundef nonnull %2, i32 noundef 32) #7
  %9 = icmp eq i32 %8, 4
  br i1 %9, label %12, label %10

10:                                               ; preds = %1
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.31, ptr noundef %0, i32 noundef %8) #7
  %11 = call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %1
  %13 = call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1025) #7
  %14 = call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 0) #7
  %15 = call i32 @read(i32 noundef %14, ptr noundef nonnull %2, i32 noundef 32) #7
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %19, label %17

17:                                               ; preds = %12
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.32, i32 noundef %14) #7
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.33, ptr noundef %0, i32 noundef %15) #7
  %18 = call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %12
  %20 = call i32 @read(i32 noundef %7, ptr noundef nonnull %2, i32 noundef 32) #7
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %24, label %22

22:                                               ; preds = %19
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.34, i32 noundef %7) #7
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.33, ptr noundef %0, i32 noundef %20) #7
  %23 = call i32 @exit(i32 noundef 1) #8
  unreachable

24:                                               ; preds = %19
  %25 = call i32 @write(i32 noundef %13, ptr noundef nonnull @.str.35, i32 noundef 6) #7
  %26 = call i32 @read(i32 noundef %14, ptr noundef nonnull %2, i32 noundef 32) #7
  %27 = icmp eq i32 %26, 6
  br i1 %27, label %30, label %28

28:                                               ; preds = %24
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.36, ptr noundef %0, i32 noundef %26) #7
  %29 = call i32 @exit(i32 noundef 1) #8
  unreachable

30:                                               ; preds = %24
  %31 = call i32 @read(i32 noundef %7, ptr noundef nonnull %2, i32 noundef 32) #7
  %32 = icmp eq i32 %31, 2
  br i1 %32, label %35, label %33

33:                                               ; preds = %30
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.37, ptr noundef %0, i32 noundef %31) #7
  %34 = call i32 @exit(i32 noundef 1) #8
  unreachable

35:                                               ; preds = %30
  %36 = call i32 @unlink(ptr noundef nonnull @.str.29) #7
  %37 = call i32 @close(i32 noundef %13) #7
  %38 = call i32 @close(i32 noundef %7) #7
  %39 = call i32 @close(i32 noundef %14) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @truncate2(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.29) #7
  %3 = tail call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1537) #7
  %4 = tail call i32 @write(i32 noundef %3, ptr noundef nonnull @.str.30, i32 noundef 4) #7
  %5 = tail call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1025) #7
  %6 = tail call i32 @write(i32 noundef %3, ptr noundef nonnull @.str.9, i32 noundef 1) #7
  %7 = icmp eq i32 %6, -1
  br i1 %7, label %10, label %8

8:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.38, ptr noundef %0, i32 noundef %6) #7
  %9 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

10:                                               ; preds = %1
  %11 = tail call i32 @unlink(ptr noundef nonnull @.str.29) #7
  %12 = tail call i32 @close(i32 noundef %3) #7
  %13 = tail call i32 @close(i32 noundef %5) #7
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @truncate3(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  %3 = alloca [32 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %4 = tail call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1537) #7
  %5 = tail call i32 @close(i32 noundef %4) #7
  %6 = tail call i32 @fork() #7
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %9 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

10:                                               ; preds = %1
  %11 = icmp eq i32 %6, 0
  br i1 %11, label %12, label %33

12:                                               ; preds = %10, %27
  %13 = phi i32 [ %32, %27 ], [ 0, %10 ]
  %14 = icmp eq i32 %13, 100
  br i1 %14, label %15, label %17

15:                                               ; preds = %12
  %16 = call i32 @exit(i32 noundef 0) #8
  unreachable

17:                                               ; preds = %12
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %3) #9
  %18 = call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1) #7
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %22

20:                                               ; preds = %17
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.40, ptr noundef %0) #7
  %21 = call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %17
  %23 = call i32 @write(i32 noundef %18, ptr noundef nonnull @.str.41, i32 noundef 10) #7
  %24 = icmp eq i32 %23, 10
  br i1 %24, label %27, label %25

25:                                               ; preds = %22
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.42, ptr noundef %0, i32 noundef %23) #7
  %26 = call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %22
  %28 = call i32 @close(i32 noundef %18) #7
  %29 = call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 0) #7
  %30 = call i32 @read(i32 noundef %29, ptr noundef nonnull %3, i32 noundef 32) #7
  %31 = call i32 @close(i32 noundef %29) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %3) #9
  %32 = add nuw nsw i32 %13, 1
  br label %12, !llvm.loop !17

33:                                               ; preds = %10, %51
  %34 = phi i32 [ %53, %51 ], [ 0, %10 ]
  %35 = icmp eq i32 %34, 150
  br i1 %35, label %36, label %41

36:                                               ; preds = %33
  %37 = call i32 @wait(ptr noundef nonnull %2) #7
  %38 = call i32 @unlink(ptr noundef nonnull @.str.29) #7
  %39 = load i32, ptr %2, align 4, !tbaa !7
  %40 = call i32 @exit(i32 noundef %39) #8
  unreachable

41:                                               ; preds = %33
  %42 = tail call i32 @open(ptr noundef nonnull @.str.29, i32 noundef 1537) #7
  %43 = icmp slt i32 %42, 0
  br i1 %43, label %44, label %46

44:                                               ; preds = %41
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.40, ptr noundef %0) #7
  %45 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

46:                                               ; preds = %41
  %47 = tail call i32 @write(i32 noundef %42, ptr noundef nonnull @.str.43, i32 noundef 3) #7
  %48 = icmp eq i32 %47, 3
  br i1 %48, label %51, label %49

49:                                               ; preds = %46
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.44, ptr noundef %0, i32 noundef %47) #7
  %50 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

51:                                               ; preds = %46
  %52 = tail call i32 @close(i32 noundef %42) #7
  %53 = add nuw nsw i32 %34, 1
  br label %33, !llvm.loop !18
}

; Function Attrs: minsize nounwind optsize
define dso_local void @iputtest(ptr noundef %0) #0 {
  %2 = tail call i32 @mkdir(ptr noundef nonnull @.str.45) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.46, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @chdir(ptr noundef nonnull @.str.45) #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.47, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = tail call i32 @unlink(ptr noundef nonnull @.str.48) #7
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.49, ptr noundef %0) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %11
  %17 = tail call i32 @chdir(ptr noundef nonnull @.str.50) #7
  %18 = icmp slt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.51, ptr noundef %0) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @mkdir(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @chdir(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @exitiputtest(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %3 = tail call i32 @fork() #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = icmp eq i32 %3, 0
  br i1 %8, label %9, label %26

9:                                                ; preds = %7
  %10 = tail call i32 @mkdir(ptr noundef nonnull @.str.45) #7
  %11 = icmp slt i32 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.46, ptr noundef %0) #7
  %13 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

14:                                               ; preds = %9
  %15 = tail call i32 @chdir(ptr noundef nonnull @.str.45) #7
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %17, label %19

17:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.52, ptr noundef %0) #7
  %18 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %14
  %20 = tail call i32 @unlink(ptr noundef nonnull @.str.48) #7
  %21 = icmp slt i32 %20, 0
  br i1 %21, label %22, label %24

22:                                               ; preds = %19
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.49, ptr noundef %0) #7
  %23 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

24:                                               ; preds = %19
  %25 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

26:                                               ; preds = %7
  %27 = call i32 @wait(ptr noundef nonnull %2) #7
  %28 = load i32, ptr %2, align 4, !tbaa !7
  %29 = call i32 @exit(i32 noundef %28) #8
  unreachable
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @openiputtest(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %3 = tail call i32 @mkdir(ptr noundef nonnull @.str.53) #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.54, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = tail call i32 @fork() #7
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %7
  %13 = icmp eq i32 %8, 0
  br i1 %13, label %14, label %21

14:                                               ; preds = %12
  %15 = tail call i32 @open(ptr noundef nonnull @.str.53, i32 noundef 2) #7
  %16 = icmp sgt i32 %15, -1
  br i1 %16, label %17, label %19

17:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.55, ptr noundef %0) #7
  %18 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %14
  %20 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

21:                                               ; preds = %12
  %22 = tail call i32 @pause(i32 noundef 1) #7
  %23 = tail call i32 @unlink(ptr noundef nonnull @.str.53) #7
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %27, label %25

25:                                               ; preds = %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.56, ptr noundef %0) #7
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %21
  %28 = call i32 @wait(ptr noundef nonnull %2) #7
  %29 = load i32, ptr %2, align 4, !tbaa !7
  %30 = call i32 @exit(i32 noundef %29) #8
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @pause(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @opentest(ptr noundef %0) #0 {
  %2 = tail call i32 @open(ptr noundef nonnull @.str.19, i32 noundef 0) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.57, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @close(i32 noundef %2) #7
  %8 = tail call i32 @open(ptr noundef nonnull @.str.58, i32 noundef 0) #7
  %9 = icmp sgt i32 %8, -1
  br i1 %9, label %10, label %12

10:                                               ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.59, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %6
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @writetest(ptr noundef %0) #0 {
  %2 = tail call i32 @open(ptr noundef nonnull @.str.60, i32 noundef 514) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.61, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1, %19
  %7 = phi i32 [ %20, %19 ], [ 0, %1 ]
  %8 = icmp eq i32 %7, 100
  br i1 %8, label %21, label %9

9:                                                ; preds = %6
  %10 = tail call i32 @write(i32 noundef %2, ptr noundef nonnull @.str.62, i32 noundef 10) #7
  %11 = icmp eq i32 %10, 10
  br i1 %11, label %14, label %12

12:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.63, ptr noundef %0, i32 noundef %7) #7
  %13 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

14:                                               ; preds = %9
  %15 = tail call i32 @write(i32 noundef %2, ptr noundef nonnull @.str.64, i32 noundef 10) #7
  %16 = icmp eq i32 %15, 10
  br i1 %16, label %19, label %17

17:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.65, ptr noundef %0, i32 noundef %7) #7
  %18 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %14
  %20 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !19

21:                                               ; preds = %6
  %22 = tail call i32 @close(i32 noundef %2) #7
  %23 = tail call i32 @open(ptr noundef nonnull @.str.60, i32 noundef 0) #7
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.66, ptr noundef %0) #7
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %21
  %28 = tail call i32 @read(i32 noundef %23, ptr noundef nonnull @buf, i32 noundef 2000) #7
  %29 = icmp eq i32 %28, 2000
  br i1 %29, label %32, label %30

30:                                               ; preds = %27
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.67, ptr noundef %0) #7
  %31 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %27
  %33 = tail call i32 @close(i32 noundef %23) #7
  %34 = tail call i32 @unlink(ptr noundef nonnull @.str.60) #7
  %35 = icmp slt i32 %34, 0
  br i1 %35, label %36, label %38

36:                                               ; preds = %32
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.68, ptr noundef %0) #7
  %37 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

38:                                               ; preds = %32
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @writebig(ptr noundef %0) #0 {
  %2 = tail call i32 @open(ptr noundef nonnull @.str.69, i32 noundef 514) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.70, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1, %14
  %7 = phi i32 [ %15, %14 ], [ 0, %1 ]
  %8 = icmp eq i32 %7, 268
  br i1 %8, label %16, label %9

9:                                                ; preds = %6
  store i32 %7, ptr @buf, align 4, !tbaa !7
  %10 = tail call i32 @write(i32 noundef %2, ptr noundef nonnull @buf, i32 noundef 1024) #7
  %11 = icmp eq i32 %10, 1024
  br i1 %11, label %14, label %12

12:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.71, ptr noundef %0, i32 noundef %7) #7
  %13 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

14:                                               ; preds = %9
  %15 = add nuw nsw i32 %7, 1
  br label %6, !llvm.loop !20

16:                                               ; preds = %6
  %17 = tail call i32 @close(i32 noundef %2) #7
  %18 = tail call i32 @open(ptr noundef nonnull @.str.69, i32 noundef 0) #7
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %22

20:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.72, ptr noundef %0) #7
  %21 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %16, %36
  %23 = phi i32 [ %37, %36 ], [ 0, %16 ]
  %24 = tail call i32 @read(i32 noundef %18, ptr noundef nonnull @buf, i32 noundef 1024) #7
  switch i32 %24, label %29 [
    i32 0, label %25
    i32 1024, label %31
  ]

25:                                               ; preds = %22
  %26 = icmp eq i32 %23, 268
  br i1 %26, label %38, label %27

27:                                               ; preds = %25
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.73, ptr noundef %0, i32 noundef %23) #7
  %28 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

29:                                               ; preds = %22
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.74, ptr noundef %0, i32 noundef %24) #7
  %30 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

31:                                               ; preds = %22
  %32 = load i32, ptr @buf, align 4, !tbaa !7
  %33 = icmp eq i32 %32, %23
  br i1 %33, label %36, label %34

34:                                               ; preds = %31
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.75, ptr noundef %0, i32 noundef %23, i32 noundef %32) #7
  %35 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

36:                                               ; preds = %31
  %37 = add nuw nsw i32 %23, 1
  br label %22, !llvm.loop !21

38:                                               ; preds = %25
  %39 = tail call i32 @close(i32 noundef %18) #7
  %40 = tail call i32 @unlink(ptr noundef nonnull @.str.69) #7
  %41 = icmp slt i32 %40, 0
  br i1 %41, label %42, label %44

42:                                               ; preds = %38
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.76, ptr noundef %0) #7
  %43 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

44:                                               ; preds = %38
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @createtest(ptr readnone captures(none) %0) #0 {
  %2 = alloca [3 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 3, ptr nonnull %2) #9
  store i8 97, ptr %2, align 1, !tbaa !14
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 2
  store i8 0, ptr %3, align 1, !tbaa !14
  %4 = getelementptr inbounds nuw i8, ptr %2, i32 1
  br label %5

5:                                                ; preds = %8, %1
  %6 = phi i32 [ 0, %1 ], [ %13, %8 ]
  %7 = icmp eq i32 %6, 52
  br i1 %7, label %14, label %8

8:                                                ; preds = %5
  %9 = trunc nuw nsw i32 %6 to i8
  %10 = add nuw nsw i8 %9, 48
  store i8 %10, ptr %4, align 1, !tbaa !14
  %11 = call i32 @open(ptr noundef nonnull %2, i32 noundef 514) #7
  %12 = call i32 @close(i32 noundef %11) #7
  %13 = add nuw nsw i32 %6, 1
  br label %5, !llvm.loop !22

14:                                               ; preds = %5
  store i8 97, ptr %2, align 1, !tbaa !14
  store i8 0, ptr %3, align 1, !tbaa !14
  br label %15

15:                                               ; preds = %18, %14
  %16 = phi i32 [ 0, %14 ], [ %22, %18 ]
  %17 = icmp eq i32 %16, 52
  br i1 %17, label %23, label %18

18:                                               ; preds = %15
  %19 = trunc nuw nsw i32 %16 to i8
  %20 = add nuw nsw i8 %19, 48
  store i8 %20, ptr %4, align 1, !tbaa !14
  %21 = call i32 @unlink(ptr noundef nonnull %2) #7
  %22 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !23

23:                                               ; preds = %15
  call void @llvm.lifetime.end.p0(i64 3, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dirtest(ptr noundef %0) #0 {
  %2 = tail call i32 @mkdir(ptr noundef nonnull @.str.77) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.46, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @chdir(ptr noundef nonnull @.str.77) #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.78, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = tail call i32 @chdir(ptr noundef nonnull @.str.79) #7
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.80, ptr noundef %0) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %11
  %17 = tail call i32 @unlink(ptr noundef nonnull @.str.77) #7
  %18 = icmp slt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.81, ptr noundef %0) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @exectest(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  %3 = alloca [3 x ptr], align 4
  %4 = alloca [3 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %3) #9
  call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(12) %3, ptr noundef nonnull align 4 dereferenceable(12) @__const.exectest.echoargv, i32 12, i1 false)
  call void @llvm.lifetime.start.p0(i64 3, ptr nonnull %4) #9
  %5 = tail call i32 @unlink(ptr noundef nonnull @.str.83) #7
  %6 = tail call i32 @fork() #7
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %9 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

10:                                               ; preds = %1
  %11 = icmp eq i32 %6, 0
  br i1 %11, label %12, label %32

12:                                               ; preds = %10
  %13 = tail call i32 @dup(i32 noundef 1) #7
  %14 = icmp slt i32 %13, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %12
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.84, ptr noundef %0) #7
  %16 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

17:                                               ; preds = %12
  %18 = tail call i32 @close(i32 noundef 1) #7
  %19 = tail call i32 @open(ptr noundef nonnull @.str.83, i32 noundef 513) #7
  %20 = icmp slt i32 %19, 0
  br i1 %20, label %21, label %23

21:                                               ; preds = %17
  tail call void (i32, ptr, ...) @fprintf(i32 noundef %13, ptr noundef nonnull @.str.85, ptr noundef %0) #7
  %22 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %17
  %24 = icmp eq i32 %19, 1
  br i1 %24, label %27, label %25

25:                                               ; preds = %23
  tail call void (i32, ptr, ...) @fprintf(i32 noundef %13, ptr noundef nonnull @.str.86, ptr noundef %0) #7
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %23
  %28 = call i32 @exec(ptr noundef nonnull @.str.19, ptr noundef nonnull %3) #7
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %30, label %32

30:                                               ; preds = %27
  call void (i32, ptr, ...) @fprintf(i32 noundef %13, ptr noundef nonnull @.str.87, ptr noundef %0) #7
  %31 = call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %27, %10
  %33 = call i32 @wait(ptr noundef nonnull %2) #7
  %34 = icmp eq i32 %33, %6
  br i1 %34, label %36, label %35

35:                                               ; preds = %32
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.88, ptr noundef %0) #7
  br label %36

36:                                               ; preds = %35, %32
  %37 = load i32, ptr %2, align 4, !tbaa !7
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %41, label %39

39:                                               ; preds = %36
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.89, ptr noundef %0, i32 noundef %37) #7
  %40 = call i32 @exit(i32 noundef 1) #8
  unreachable

41:                                               ; preds = %36
  %42 = call i32 @open(ptr noundef nonnull @.str.83, i32 noundef 0) #7
  %43 = icmp slt i32 %42, 0
  br i1 %43, label %44, label %46

44:                                               ; preds = %41
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.40, ptr noundef %0) #7
  %45 = call i32 @exit(i32 noundef 1) #8
  unreachable

46:                                               ; preds = %41
  %47 = call i32 @read(i32 noundef %42, ptr noundef nonnull %4, i32 noundef 2) #7
  %48 = icmp eq i32 %47, 2
  br i1 %48, label %51, label %49

49:                                               ; preds = %46
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.67, ptr noundef %0) #7
  %50 = call i32 @exit(i32 noundef 1) #8
  unreachable

51:                                               ; preds = %46
  %52 = call i32 @unlink(ptr noundef nonnull @.str.83) #7
  %53 = load i8, ptr %4, align 1, !tbaa !14
  %54 = icmp eq i8 %53, 79
  %55 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %56 = load i8, ptr %55, align 1
  %57 = icmp eq i8 %56, 75
  %58 = select i1 %54, i1 %57, i1 false
  br i1 %58, label %59, label %61

59:                                               ; preds = %51
  %60 = call i32 @exit(i32 noundef 0) #8
  unreachable

61:                                               ; preds = %51
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.90, ptr noundef %0) #7
  %62 = call i32 @exit(i32 noundef 1) #8
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @dup(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @fprintf(i32 noundef, ptr noundef, ...) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @pipe1(ptr noundef %0) #0 {
  %2 = alloca [2 x i32], align 4
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  %4 = call i32 @pipe(ptr noundef nonnull %2) #7
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %8, label %6

6:                                                ; preds = %1
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.91, ptr noundef %0) #7
  %7 = call i32 @exit(i32 noundef 1) #8
  unreachable

8:                                                ; preds = %1
  %9 = call i32 @fork() #7
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %37

11:                                               ; preds = %8
  %12 = load i32, ptr %2, align 4, !tbaa !7
  %13 = call i32 @close(i32 noundef %12) #7
  %14 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %15

15:                                               ; preds = %28, %11
  %16 = phi i32 [ 0, %11 ], [ %20, %28 ]
  %17 = phi i32 [ 0, %11 ], [ %32, %28 ]
  %18 = icmp eq i32 %17, 5
  br i1 %18, label %35, label %19

19:                                               ; preds = %15, %23
  %20 = phi i32 [ %24, %23 ], [ %16, %15 ]
  %21 = phi i32 [ %27, %23 ], [ 0, %15 ]
  %22 = icmp eq i32 %21, 1033
  br i1 %22, label %28, label %23

23:                                               ; preds = %19
  %24 = add nsw i32 %20, 1
  %25 = trunc i32 %20 to i8
  %26 = getelementptr inbounds nuw [12288 x i8], ptr @buf, i32 0, i32 %21
  store i8 %25, ptr %26, align 1, !tbaa !14
  %27 = add nuw nsw i32 %21, 1
  br label %19, !llvm.loop !24

28:                                               ; preds = %19
  %29 = load i32, ptr %14, align 4, !tbaa !7
  %30 = call i32 @write(i32 noundef %29, ptr noundef nonnull @buf, i32 noundef 1033) #7
  %31 = icmp eq i32 %30, 1033
  %32 = add nuw nsw i32 %17, 1
  br i1 %31, label %15, label %33, !llvm.loop !25

33:                                               ; preds = %28
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.92, ptr noundef %0) #7
  %34 = call i32 @exit(i32 noundef 1) #8
  unreachable

35:                                               ; preds = %15
  %36 = call i32 @exit(i32 noundef 0) #8
  unreachable

37:                                               ; preds = %8
  %38 = icmp sgt i32 %9, 0
  br i1 %38, label %39, label %79

39:                                               ; preds = %37
  %40 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %41 = load i32, ptr %40, align 4, !tbaa !7
  %42 = call i32 @close(i32 noundef %41) #7
  br label %43

43:                                               ; preds = %65, %39
  %44 = phi i32 [ 0, %39 ], [ %51, %65 ]
  %45 = phi i32 [ 1, %39 ], [ %68, %65 ]
  %46 = phi i32 [ 0, %39 ], [ %66, %65 ]
  %47 = load i32, ptr %2, align 4, !tbaa !7
  %48 = call i32 @read(i32 noundef %47, ptr noundef nonnull @buf, i32 noundef %45) #7
  %49 = icmp sgt i32 %48, 0
  br i1 %49, label %50, label %69

50:                                               ; preds = %43
  %51 = add i32 %48, %44
  br label %52

52:                                               ; preds = %50, %62
  %53 = phi i32 [ %63, %62 ], [ %44, %50 ]
  %54 = phi i32 [ %64, %62 ], [ 0, %50 ]
  %55 = icmp eq i32 %54, %48
  br i1 %55, label %65, label %56

56:                                               ; preds = %52
  %57 = getelementptr inbounds nuw [12288 x i8], ptr @buf, i32 0, i32 %54
  %58 = load i8, ptr %57, align 1, !tbaa !14
  %59 = trunc i32 %53 to i8
  %60 = icmp eq i8 %58, %59
  br i1 %60, label %62, label %61

61:                                               ; preds = %56
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.93, ptr noundef %0) #7
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #9
  ret void

62:                                               ; preds = %56
  %63 = add nsw i32 %53, 1
  %64 = add nuw i32 %54, 1
  br label %52, !llvm.loop !26

65:                                               ; preds = %52
  %66 = add nuw nsw i32 %48, %46
  %67 = shl nuw nsw i32 %45, 1
  %68 = call i32 @llvm.umin.i32(i32 %67, i32 12288)
  br label %43, !llvm.loop !27

69:                                               ; preds = %43
  %70 = icmp eq i32 %46, 5165
  br i1 %70, label %73, label %71

71:                                               ; preds = %69
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.94, ptr noundef %0, i32 noundef %46) #7
  %72 = call i32 @exit(i32 noundef 1) #8
  unreachable

73:                                               ; preds = %69
  %74 = load i32, ptr %2, align 4, !tbaa !7
  %75 = call i32 @close(i32 noundef %74) #7
  %76 = call i32 @wait(ptr noundef nonnull %3) #7
  %77 = load i32, ptr %3, align 4, !tbaa !7
  %78 = call i32 @exit(i32 noundef %77) #8
  unreachable

79:                                               ; preds = %37
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.95, ptr noundef %0) #7
  %80 = call i32 @exit(i32 noundef 1) #8
  unreachable
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @killstatus(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  br label %3

3:                                                ; preds = %17, %1
  %4 = phi i32 [ 0, %1 ], [ %23, %17 ]
  %5 = icmp eq i32 %4, 100
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = call i32 @exit(i32 noundef 0) #8
  unreachable

8:                                                ; preds = %3
  %9 = call i32 @fork() #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %12 = call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = icmp eq i32 %9, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %13, %15
  %16 = call i32 @getpid() #7
  br label %15, !llvm.loop !28

17:                                               ; preds = %13
  %18 = call i32 @pause(i32 noundef 1) #7
  %19 = call i32 @kill(i32 noundef %9) #7
  %20 = call i32 @wait(ptr noundef nonnull %2) #7
  %21 = load i32, ptr %2, align 4, !tbaa !7
  %22 = icmp eq i32 %21, -1
  %23 = add nuw nsw i32 %4, 1
  br i1 %22, label %3, label %24, !llvm.loop !29

24:                                               ; preds = %17
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.96, ptr noundef %0) #7
  %25 = call i32 @exit(i32 noundef 1) #8
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local i32 @getpid() local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local i32 @kill(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @preempt(ptr noundef %0) #0 {
  %2 = alloca [2 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #9
  %3 = tail call i32 @fork() #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.97, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = icmp eq i32 %3, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %7, %9
  br label %9, !llvm.loop !30

10:                                               ; preds = %7
  %11 = tail call i32 @fork() #7
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %10
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %14 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

15:                                               ; preds = %10
  %16 = icmp eq i32 %11, 0
  br i1 %16, label %17, label %18

17:                                               ; preds = %15, %17
  br label %17, !llvm.loop !31

18:                                               ; preds = %15
  %19 = call i32 @pipe(ptr noundef nonnull %2) #7
  %20 = call i32 @fork() #7
  %21 = icmp slt i32 %20, 0
  br i1 %21, label %22, label %24

22:                                               ; preds = %18
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %23 = call i32 @exit(i32 noundef 1) #8
  unreachable

24:                                               ; preds = %18
  %25 = icmp eq i32 %20, 0
  br i1 %25, label %26, label %38

26:                                               ; preds = %24
  %27 = load i32, ptr %2, align 4, !tbaa !7
  %28 = call i32 @close(i32 noundef %27) #7
  %29 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %30 = load i32, ptr %29, align 4, !tbaa !7
  %31 = call i32 @write(i32 noundef %30, ptr noundef nonnull @.str.9, i32 noundef 1) #7
  %32 = icmp eq i32 %31, 1
  br i1 %32, label %34, label %33

33:                                               ; preds = %26
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.98, ptr noundef %0) #7
  br label %34

34:                                               ; preds = %33, %26
  %35 = load i32, ptr %29, align 4, !tbaa !7
  %36 = call i32 @close(i32 noundef %35) #7
  br label %37

37:                                               ; preds = %37, %34
  br label %37, !llvm.loop !32

38:                                               ; preds = %24
  %39 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %40 = load i32, ptr %39, align 4, !tbaa !7
  %41 = call i32 @close(i32 noundef %40) #7
  %42 = load i32, ptr %2, align 4, !tbaa !7
  %43 = call i32 @read(i32 noundef %42, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %44 = icmp eq i32 %43, 1
  br i1 %44, label %46, label %45

45:                                               ; preds = %38
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.99, ptr noundef %0) #7
  br label %55

46:                                               ; preds = %38
  %47 = load i32, ptr %2, align 4, !tbaa !7
  %48 = call i32 @close(i32 noundef %47) #7
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.100) #7
  %49 = call i32 @kill(i32 noundef %3) #7
  %50 = call i32 @kill(i32 noundef %11) #7
  %51 = call i32 @kill(i32 noundef %20) #7
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.101) #7
  %52 = call i32 @wait(ptr noundef null) #7
  %53 = call i32 @wait(ptr noundef null) #7
  %54 = call i32 @wait(ptr noundef null) #7
  br label %55

55:                                               ; preds = %46, %45
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @exitwait(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  br label %3

3:                                                ; preds = %23, %1
  %4 = phi i32 [ 0, %1 ], [ %24, %23 ]
  %5 = icmp eq i32 %4, 100
  br i1 %5, label %27, label %6

6:                                                ; preds = %3
  %7 = call i32 @fork() #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %10 = call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = icmp eq i32 %7, 0
  br i1 %12, label %25, label %13

13:                                               ; preds = %11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %14 = call i32 @wait(ptr noundef nonnull %2) #7
  %15 = icmp eq i32 %14, %7
  br i1 %15, label %18, label %16

16:                                               ; preds = %13
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.102, ptr noundef %0) #7
  %17 = call i32 @exit(i32 noundef 1) #8
  unreachable

18:                                               ; preds = %13
  %19 = load i32, ptr %2, align 4, !tbaa !7
  %20 = icmp eq i32 %4, %19
  br i1 %20, label %23, label %21

21:                                               ; preds = %18
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.103, ptr noundef %0) #7
  %22 = call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %18
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  %24 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !33

25:                                               ; preds = %11
  %26 = call i32 @exit(i32 noundef %4) #8
  unreachable

27:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @reparent(ptr noundef %0) #5 {
  %2 = tail call i32 @getpid() #7
  br label %3

3:                                                ; preds = %15, %1
  %4 = phi i32 [ 0, %1 ], [ %18, %15 ]
  %5 = icmp eq i32 %4, 200
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

8:                                                ; preds = %3
  %9 = tail call i32 @fork() #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = icmp eq i32 %9, 0
  br i1 %14, label %21, label %15

15:                                               ; preds = %13
  %16 = tail call i32 @wait(ptr noundef null) #7
  %17 = icmp eq i32 %16, %9
  %18 = add nuw nsw i32 %4, 1
  br i1 %17, label %3, label %19, !llvm.loop !34

19:                                               ; preds = %15
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.102, ptr noundef %0) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %13
  %22 = tail call i32 @fork() #7
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %24, label %27

24:                                               ; preds = %21
  %25 = tail call i32 @kill(i32 noundef %2) #7
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %21
  %28 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @twochildren(ptr noundef %0) #0 {
  br label %2

2:                                                ; preds = %24, %1
  %3 = phi i32 [ 0, %1 ], [ %27, %24 ]
  %4 = icmp eq i32 %3, 1000
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  ret void

6:                                                ; preds = %2
  %7 = tail call i32 @fork() #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = icmp eq i32 %7, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %11
  %14 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

15:                                               ; preds = %11
  %16 = tail call i32 @fork() #7
  %17 = icmp slt i32 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %15
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %15
  %21 = icmp eq i32 %16, 0
  br i1 %21, label %22, label %24

22:                                               ; preds = %20
  %23 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

24:                                               ; preds = %20
  %25 = tail call i32 @wait(ptr noundef null) #7
  %26 = tail call i32 @wait(ptr noundef null) #7
  %27 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !35
}

; Function Attrs: minsize nounwind optsize
define dso_local void @forkfork(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  br label %3

3:                                                ; preds = %12, %1
  %4 = phi i32 [ 0, %1 ], [ %14, %12 ]
  %5 = icmp eq i32 %4, 2
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  br label %32

7:                                                ; preds = %3
  %8 = tail call i32 @fork() #7
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.97, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %7
  %13 = icmp eq i32 %8, 0
  %14 = add nuw nsw i32 %4, 1
  br i1 %13, label %15, label %3, !llvm.loop !36

15:                                               ; preds = %12, %29
  %16 = phi i32 [ %31, %29 ], [ 0, %12 ]
  %17 = icmp eq i32 %16, 200
  br i1 %17, label %18, label %20

18:                                               ; preds = %15
  %19 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

20:                                               ; preds = %15
  %21 = tail call i32 @fork() #7
  %22 = icmp slt i32 %21, 0
  br i1 %22, label %23, label %25

23:                                               ; preds = %20
  %24 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

25:                                               ; preds = %20
  %26 = icmp eq i32 %21, 0
  br i1 %26, label %27, label %29

27:                                               ; preds = %25
  %28 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

29:                                               ; preds = %25
  %30 = tail call i32 @wait(ptr noundef null) #7
  %31 = add nuw nsw i32 %16, 1
  br label %15, !llvm.loop !37

32:                                               ; preds = %36, %6
  %33 = phi i32 [ 0, %6 ], [ %40, %36 ]
  %34 = icmp eq i32 %33, 2
  br i1 %34, label %35, label %36

35:                                               ; preds = %32
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  ret void

36:                                               ; preds = %32
  %37 = call i32 @wait(ptr noundef nonnull %2) #7
  %38 = load i32, ptr %2, align 4, !tbaa !7
  %39 = icmp eq i32 %38, 0
  %40 = add nuw nsw i32 %33, 1
  br i1 %39, label %32, label %41, !llvm.loop !38

41:                                               ; preds = %36
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.104, ptr noundef %0) #7
  %42 = call i32 @exit(i32 noundef 1) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @forkforkfork(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.105) #7
  %3 = tail call i32 @fork() #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.97, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = icmp eq i32 %3, 0
  br i1 %8, label %9, label %21

9:                                                ; preds = %7, %20
  %10 = tail call i32 @open(ptr noundef nonnull @.str.105, i32 noundef 0) #7
  %11 = icmp sgt i32 %10, -1
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  %13 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

14:                                               ; preds = %9
  %15 = tail call i32 @fork() #7
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  %18 = tail call i32 @open(ptr noundef nonnull @.str.105, i32 noundef 514) #7
  %19 = tail call i32 @close(i32 noundef %18) #7
  br label %20

20:                                               ; preds = %17, %14
  br label %9, !llvm.loop !39

21:                                               ; preds = %7
  %22 = tail call i32 @pause(i32 noundef 20) #7
  %23 = tail call i32 @open(ptr noundef nonnull @.str.105, i32 noundef 514) #7
  %24 = tail call i32 @close(i32 noundef %23) #7
  %25 = tail call i32 @wait(ptr noundef null) #7
  %26 = tail call i32 @pause(i32 noundef 10) #7
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @reparent2(ptr readnone captures(none) %0) #5 {
  br label %2

2:                                                ; preds = %18, %1
  %3 = phi i32 [ 0, %1 ], [ %20, %18 ]
  %4 = icmp eq i32 %3, 800
  br i1 %4, label %5, label %7

5:                                                ; preds = %2
  %6 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

7:                                                ; preds = %2
  %8 = tail call i32 @fork() #7
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %7
  %13 = icmp eq i32 %8, 0
  br i1 %13, label %14, label %18

14:                                               ; preds = %12
  %15 = tail call i32 @fork() #7
  %16 = tail call i32 @fork() #7
  %17 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

18:                                               ; preds = %12
  %19 = tail call i32 @wait(ptr noundef null) #7
  %20 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !40
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @mem(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  %3 = tail call i32 @fork() #7
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %22

5:                                                ; preds = %1, %9
  %6 = phi ptr [ %7, %9 ], [ null, %1 ]
  %7 = tail call ptr @malloc(i32 noundef 10001) #7
  %8 = icmp eq ptr %7, null
  br i1 %8, label %10, label %9

9:                                                ; preds = %5
  store ptr %6, ptr %7, align 4, !tbaa !41
  br label %5, !llvm.loop !44

10:                                               ; preds = %5, %13
  %11 = phi ptr [ %14, %13 ], [ %6, %5 ]
  %12 = icmp eq ptr %11, null
  br i1 %12, label %15, label %13

13:                                               ; preds = %10
  %14 = load ptr, ptr %11, align 4, !tbaa !41
  tail call void @free(ptr noundef nonnull %11) #7
  br label %10, !llvm.loop !45

15:                                               ; preds = %10
  %16 = tail call ptr @malloc(i32 noundef 20480) #7
  %17 = icmp eq ptr %16, null
  br i1 %17, label %18, label %20

18:                                               ; preds = %15
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.106, ptr noundef %0) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %15
  tail call void @free(ptr noundef nonnull %16) #7
  %21 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

22:                                               ; preds = %1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %23 = call i32 @wait(ptr noundef nonnull %2) #7
  %24 = load i32, ptr %2, align 4, !tbaa !7
  %25 = icmp eq i32 %24, -1
  br i1 %25, label %26, label %28

26:                                               ; preds = %22
  %27 = call i32 @exit(i32 noundef 0) #8
  unreachable

28:                                               ; preds = %22
  %29 = call i32 @exit(i32 noundef %24) #8
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local ptr @malloc(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize optsize
declare dso_local void @free(ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @sharedfd(ptr noundef %0) #5 {
  %2 = alloca [10 x i8], align 1
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %2) #9
  %4 = tail call i32 @unlink(ptr noundef nonnull @.str.107) #7
  %5 = tail call i32 @open(ptr noundef nonnull @.str.107, i32 noundef 514) #7
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %7, label %9

7:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.108, ptr noundef %0) #7
  %8 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

9:                                                ; preds = %1
  %10 = tail call i32 @fork() #7
  %11 = icmp eq i32 %10, 0
  %12 = select i1 %11, i32 99, i32 112
  %13 = call ptr @memset(ptr noundef nonnull %2, i32 noundef %12, i32 noundef 10) #7
  br label %14

14:                                               ; preds = %17, %9
  %15 = phi i32 [ 0, %9 ], [ %20, %17 ]
  %16 = icmp eq i32 %15, 1000
  br i1 %16, label %23, label %17

17:                                               ; preds = %14
  %18 = call i32 @write(i32 noundef %5, ptr noundef nonnull %2, i32 noundef 10) #7
  %19 = icmp eq i32 %18, 10
  %20 = add nuw nsw i32 %15, 1
  br i1 %19, label %14, label %21, !llvm.loop !46

21:                                               ; preds = %17
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.109, ptr noundef %0) #7
  %22 = call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %14
  br i1 %11, label %24, label %26

24:                                               ; preds = %23
  %25 = call i32 @exit(i32 noundef 0) #8
  unreachable

26:                                               ; preds = %23
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  %27 = call i32 @wait(ptr noundef nonnull %3) #7
  %28 = load i32, ptr %3, align 4, !tbaa !7
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %32, label %30

30:                                               ; preds = %26
  %31 = call i32 @exit(i32 noundef %28) #8
  unreachable

32:                                               ; preds = %26
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  %33 = call i32 @close(i32 noundef %5) #7
  %34 = call i32 @open(ptr noundef nonnull @.str.107, i32 noundef 0) #7
  %35 = icmp slt i32 %34, 0
  br i1 %35, label %36, label %38

36:                                               ; preds = %32
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.110, ptr noundef %0) #7
  %37 = call i32 @exit(i32 noundef 1) #8
  unreachable

38:                                               ; preds = %43, %32
  %39 = phi i32 [ 0, %32 ], [ %45, %43 ]
  %40 = phi i32 [ 0, %32 ], [ %46, %43 ]
  %41 = call i32 @read(i32 noundef %34, ptr noundef nonnull %2, i32 noundef 10) #7
  %42 = icmp sgt i32 %41, 0
  br i1 %42, label %43, label %58

43:                                               ; preds = %38, %48
  %44 = phi i32 [ %57, %48 ], [ 0, %38 ]
  %45 = phi i32 [ %53, %48 ], [ %39, %38 ]
  %46 = phi i32 [ %56, %48 ], [ %40, %38 ]
  %47 = icmp eq i32 %44, 10
  br i1 %47, label %38, label %48, !llvm.loop !47

48:                                               ; preds = %43
  %49 = getelementptr inbounds nuw [10 x i8], ptr %2, i32 0, i32 %44
  %50 = load i8, ptr %49, align 1, !tbaa !14
  %51 = icmp eq i8 %50, 99
  %52 = zext i1 %51 to i32
  %53 = add nsw i32 %45, %52
  %54 = icmp eq i8 %50, 112
  %55 = zext i1 %54 to i32
  %56 = add nsw i32 %46, %55
  %57 = add nuw nsw i32 %44, 1
  br label %43, !llvm.loop !48

58:                                               ; preds = %38
  %59 = call i32 @close(i32 noundef %34) #7
  %60 = call i32 @unlink(ptr noundef nonnull @.str.107) #7
  %61 = icmp eq i32 %39, 10000
  %62 = icmp eq i32 %40, 10000
  %63 = select i1 %61, i1 %62, i1 false
  br i1 %63, label %64, label %66

64:                                               ; preds = %58
  %65 = call i32 @exit(i32 noundef 0) #8
  unreachable

66:                                               ; preds = %58
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.111, ptr noundef %0) #7
  %67 = call i32 @exit(i32 noundef 1) #8
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local ptr @memset(ptr noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local void @fourfiles(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  br label %3

3:                                                ; preds = %35, %1
  %4 = phi i32 [ 0, %1 ], [ %36, %35 ]
  %5 = icmp eq i32 %4, 4
  br i1 %5, label %37, label %6

6:                                                ; preds = %3
  %7 = getelementptr inbounds nuw [4 x ptr], ptr @__const.fourfiles.names, i32 0, i32 %4
  %8 = load ptr, ptr %7, align 4, !tbaa !41
  %9 = tail call i32 @unlink(ptr noundef %8) #7
  %10 = tail call i32 @fork() #7
  %11 = icmp slt i32 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %13 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

14:                                               ; preds = %6
  %15 = icmp eq i32 %10, 0
  br i1 %15, label %16, label %35

16:                                               ; preds = %14
  %17 = tail call i32 @open(ptr noundef %8, i32 noundef 514) #7
  %18 = icmp slt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.85, ptr noundef %0) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  %22 = or disjoint i32 %4, 48
  %23 = tail call ptr @memset(ptr noundef nonnull @buf, i32 noundef %22, i32 noundef 500) #7
  br label %24

24:                                               ; preds = %27, %21
  %25 = phi i32 [ 0, %21 ], [ %30, %27 ]
  %26 = icmp eq i32 %25, 12
  br i1 %26, label %33, label %27

27:                                               ; preds = %24
  %28 = tail call i32 @write(i32 noundef %17, ptr noundef nonnull @buf, i32 noundef 500) #7
  %29 = icmp eq i32 %28, 500
  %30 = add nuw nsw i32 %25, 1
  br i1 %29, label %24, label %31, !llvm.loop !49

31:                                               ; preds = %27
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.116, i32 noundef %28) #7
  %32 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %24
  %34 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

35:                                               ; preds = %14
  %36 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !50

37:                                               ; preds = %3
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  br label %38

38:                                               ; preds = %41, %37
  %39 = phi i32 [ 0, %37 ], [ %45, %41 ]
  %40 = icmp eq i32 %39, 4
  br i1 %40, label %48, label %41

41:                                               ; preds = %38
  %42 = call i32 @wait(ptr noundef nonnull %2) #7
  %43 = load i32, ptr %2, align 4, !tbaa !7
  %44 = icmp eq i32 %43, 0
  %45 = add nuw nsw i32 %39, 1
  br i1 %44, label %38, label %46, !llvm.loop !51

46:                                               ; preds = %41
  %47 = call i32 @exit(i32 noundef %43) #8
  unreachable

48:                                               ; preds = %38, %78
  %49 = phi i32 [ %80, %78 ], [ 0, %38 ]
  %50 = icmp eq i32 %49, 4
  br i1 %50, label %81, label %51

51:                                               ; preds = %48
  %52 = getelementptr inbounds nuw [4 x ptr], ptr @__const.fourfiles.names, i32 0, i32 %49
  %53 = load ptr, ptr %52, align 4, !tbaa !41
  %54 = call i32 @open(ptr noundef %53, i32 noundef 0) #7
  %55 = or disjoint i32 %49, 48
  br label %56

56:                                               ; preds = %71, %51
  %57 = phi i32 [ 0, %51 ], [ %72, %71 ]
  %58 = call i32 @read(i32 noundef %54, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %59 = icmp sgt i32 %58, 0
  br i1 %59, label %60, label %73

60:                                               ; preds = %56, %63
  %61 = phi i32 [ %68, %63 ], [ 0, %56 ]
  %62 = icmp eq i32 %61, %58
  br i1 %62, label %71, label %63

63:                                               ; preds = %60
  %64 = getelementptr inbounds nuw [12288 x i8], ptr @buf, i32 0, i32 %61
  %65 = load i8, ptr %64, align 1, !tbaa !14
  %66 = sext i8 %65 to i32
  %67 = icmp eq i32 %55, %66
  %68 = add nuw i32 %61, 1
  br i1 %67, label %60, label %69, !llvm.loop !52

69:                                               ; preds = %63
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.117, ptr noundef %0) #7
  %70 = call i32 @exit(i32 noundef 1) #8
  unreachable

71:                                               ; preds = %60
  %72 = add nuw nsw i32 %58, %57
  br label %56, !llvm.loop !53

73:                                               ; preds = %56
  %74 = call i32 @close(i32 noundef %54) #7
  %75 = icmp eq i32 %57, 6000
  br i1 %75, label %78, label %76

76:                                               ; preds = %73
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.118, i32 noundef %57) #7
  %77 = call i32 @exit(i32 noundef 1) #8
  unreachable

78:                                               ; preds = %73
  %79 = call i32 @unlink(ptr noundef %53) #7
  %80 = add nuw nsw i32 %49, 1
  br label %48, !llvm.loop !54

81:                                               ; preds = %48
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @createdelete(ptr noundef %0) #0 {
  %2 = alloca [32 x i8], align 1
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #9
  br label %4

4:                                                ; preds = %47, %1
  %5 = phi i32 [ 0, %1 ], [ %48, %47 ]
  %6 = icmp eq i32 %5, 4
  br i1 %6, label %49, label %7

7:                                                ; preds = %4
  %8 = tail call i32 @fork() #7
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %7
  %13 = icmp eq i32 %8, 0
  br i1 %13, label %14, label %47

14:                                               ; preds = %12
  %15 = trunc nuw nsw i32 %5 to i8
  %16 = or disjoint i8 %15, 112
  store i8 %16, ptr %2, align 1, !tbaa !14
  %17 = getelementptr inbounds nuw i8, ptr %2, i32 2
  store i8 0, ptr %17, align 1, !tbaa !14
  %18 = getelementptr inbounds nuw i8, ptr %2, i32 1
  br label %19

19:                                               ; preds = %43, %14
  %20 = phi i32 [ 0, %14 ], [ %44, %43 ]
  %21 = icmp eq i32 %20, 20
  br i1 %21, label %45, label %22

22:                                               ; preds = %19
  %23 = trunc nuw nsw i32 %20 to i8
  %24 = add nuw nsw i8 %23, 48
  store i8 %24, ptr %18, align 1, !tbaa !14
  %25 = call i32 @open(ptr noundef nonnull %2, i32 noundef 514) #7
  %26 = icmp slt i32 %25, 0
  br i1 %26, label %27, label %29

27:                                               ; preds = %22
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.85, ptr noundef %0) #7
  %28 = call i32 @exit(i32 noundef 1) #8
  unreachable

29:                                               ; preds = %22
  %30 = call i32 @close(i32 noundef %25) #7
  %31 = icmp ne i32 %20, 0
  %32 = and i32 %20, 1
  %33 = icmp eq i32 %32, 0
  %34 = and i1 %31, %33
  br i1 %34, label %35, label %43

35:                                               ; preds = %29
  %36 = lshr exact i32 %20, 1
  %37 = trunc nuw nsw i32 %36 to i8
  %38 = or disjoint i8 %37, 48
  store i8 %38, ptr %18, align 1, !tbaa !14
  %39 = call i32 @unlink(ptr noundef nonnull %2) #7
  %40 = icmp slt i32 %39, 0
  br i1 %40, label %41, label %43

41:                                               ; preds = %35
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.56, ptr noundef %0) #7
  %42 = call i32 @exit(i32 noundef 1) #8
  unreachable

43:                                               ; preds = %29, %35
  %44 = add nuw nsw i32 %20, 1
  br label %19, !llvm.loop !55

45:                                               ; preds = %19
  %46 = call i32 @exit(i32 noundef 0) #8
  unreachable

47:                                               ; preds = %12
  %48 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !56

49:                                               ; preds = %4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  br label %50

50:                                               ; preds = %53, %49
  %51 = phi i32 [ 0, %49 ], [ %57, %53 ]
  %52 = icmp eq i32 %51, 4
  br i1 %52, label %60, label %53

53:                                               ; preds = %50
  %54 = call i32 @wait(ptr noundef nonnull %3) #7
  %55 = load i32, ptr %3, align 4, !tbaa !7
  %56 = icmp eq i32 %55, 0
  %57 = add nuw nsw i32 %51, 1
  br i1 %56, label %50, label %58, !llvm.loop !57

58:                                               ; preds = %53
  %59 = call i32 @exit(i32 noundef 1) #8
  unreachable

60:                                               ; preds = %50
  %61 = getelementptr inbounds nuw i8, ptr %2, i32 2
  store i8 0, ptr %61, align 1, !tbaa !14
  %62 = getelementptr inbounds nuw i8, ptr %2, i32 1
  br label %63

63:                                               ; preds = %96, %60
  %64 = phi i32 [ 0, %60 ], [ %97, %96 ]
  %65 = icmp eq i32 %64, 20
  br i1 %65, label %98, label %66

66:                                               ; preds = %63
  %67 = trunc nuw i32 %64 to i8
  %68 = add nuw nsw i8 %67, 48
  %69 = icmp eq i32 %64, 0
  %70 = icmp samesign ugt i32 %64, 9
  %71 = add nsw i32 %64, -1
  %72 = icmp ult i32 %71, 9
  br label %73

73:                                               ; preds = %66, %94
  %74 = phi i32 [ %95, %94 ], [ 0, %66 ]
  %75 = icmp eq i32 %74, 4
  br i1 %75, label %96, label %76

76:                                               ; preds = %73
  %77 = trunc nuw nsw i32 %74 to i8
  %78 = or disjoint i8 %77, 112
  store i8 %78, ptr %2, align 1, !tbaa !14
  store i8 %68, ptr %62, align 1, !tbaa !14
  %79 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %80 = icmp slt i32 %79, 0
  br i1 %69, label %83, label %81

81:                                               ; preds = %76
  %82 = select i1 %70, i1 %80, i1 false
  br i1 %82, label %84, label %86

83:                                               ; preds = %76
  br i1 %80, label %84, label %92

84:                                               ; preds = %81, %83
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.119, ptr noundef %0, ptr noundef nonnull %2) #7
  %85 = call i32 @exit(i32 noundef 1) #8
  unreachable

86:                                               ; preds = %81
  %87 = icmp sgt i32 %79, -1
  %88 = select i1 %72, i1 %87, i1 false
  br i1 %88, label %89, label %91

89:                                               ; preds = %86
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.120, ptr noundef %0, ptr noundef nonnull %2) #7
  %90 = call i32 @exit(i32 noundef 1) #8
  unreachable

91:                                               ; preds = %86
  br i1 %87, label %92, label %94

92:                                               ; preds = %83, %91
  %93 = call i32 @close(i32 noundef %79) #7
  br label %94

94:                                               ; preds = %91, %92
  %95 = add nuw nsw i32 %74, 1
  br label %73, !llvm.loop !58

96:                                               ; preds = %73
  %97 = add nuw nsw i32 %64, 1
  br label %63, !llvm.loop !59

98:                                               ; preds = %63, %112
  %99 = phi i32 [ %113, %112 ], [ 0, %63 ]
  %100 = icmp eq i32 %99, 20
  br i1 %100, label %114, label %101

101:                                              ; preds = %98
  %102 = trunc nuw i32 %99 to i8
  %103 = add nuw nsw i8 %102, 48
  br label %104

104:                                              ; preds = %101, %107
  %105 = phi i32 [ %111, %107 ], [ 0, %101 ]
  %106 = icmp eq i32 %105, 4
  br i1 %106, label %112, label %107

107:                                              ; preds = %104
  %108 = trunc nuw nsw i32 %105 to i8
  %109 = or disjoint i8 %108, 112
  store i8 %109, ptr %2, align 1, !tbaa !14
  store i8 %103, ptr %62, align 1, !tbaa !14
  %110 = call i32 @unlink(ptr noundef nonnull %2) #7
  %111 = add nuw nsw i32 %105, 1
  br label %104, !llvm.loop !60

112:                                              ; preds = %104
  %113 = add nuw nsw i32 %99, 1
  br label %98, !llvm.loop !61

114:                                              ; preds = %98
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @unlinkread(ptr noundef %0) #0 {
  %2 = tail call i32 @open(ptr noundef nonnull @.str.121, i32 noundef 514) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.122, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @write(i32 noundef %2, ptr noundef nonnull @.str.123, i32 noundef 5) #7
  %8 = tail call i32 @close(i32 noundef %2) #7
  %9 = tail call i32 @open(ptr noundef nonnull @.str.121, i32 noundef 2) #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.124, ptr noundef %0) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %6
  %14 = tail call i32 @unlink(ptr noundef nonnull @.str.121) #7
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %18, label %16

16:                                               ; preds = %13
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.125, ptr noundef %0) #7
  %17 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

18:                                               ; preds = %13
  %19 = tail call i32 @open(ptr noundef nonnull @.str.121, i32 noundef 514) #7
  %20 = tail call i32 @write(i32 noundef %19, ptr noundef nonnull @.str.126, i32 noundef 3) #7
  %21 = tail call i32 @close(i32 noundef %19) #7
  %22 = tail call i32 @read(i32 noundef %9, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %23 = icmp eq i32 %22, 5
  br i1 %23, label %26, label %24

24:                                               ; preds = %18
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.127, ptr noundef %0) #7
  %25 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

26:                                               ; preds = %18
  %27 = load i8, ptr @buf, align 4, !tbaa !14
  %28 = icmp eq i8 %27, 104
  br i1 %28, label %31, label %29

29:                                               ; preds = %26
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.128, ptr noundef %0) #7
  %30 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

31:                                               ; preds = %26
  %32 = tail call i32 @write(i32 noundef %9, ptr noundef nonnull @buf, i32 noundef 10) #7
  %33 = icmp eq i32 %32, 10
  br i1 %33, label %36, label %34

34:                                               ; preds = %31
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.129, ptr noundef %0) #7
  %35 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

36:                                               ; preds = %31
  %37 = tail call i32 @close(i32 noundef %9) #7
  %38 = tail call i32 @unlink(ptr noundef nonnull @.str.121) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @linktest(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.130) #7
  %3 = tail call i32 @unlink(ptr noundef nonnull @.str.131) #7
  %4 = tail call i32 @open(ptr noundef nonnull @.str.130, i32 noundef 514) #7
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.132, ptr noundef %0) #7
  %7 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

8:                                                ; preds = %1
  %9 = tail call i32 @write(i32 noundef %4, ptr noundef nonnull @.str.123, i32 noundef 5) #7
  %10 = icmp eq i32 %9, 5
  br i1 %10, label %13, label %11

11:                                               ; preds = %8
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.133, ptr noundef %0) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = tail call i32 @close(i32 noundef %4) #7
  %15 = tail call i32 @link(ptr noundef nonnull @.str.130, ptr noundef nonnull @.str.131) #7
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %17, label %19

17:                                               ; preds = %13
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.134, ptr noundef %0) #7
  %18 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %13
  %20 = tail call i32 @unlink(ptr noundef nonnull @.str.130) #7
  %21 = tail call i32 @open(ptr noundef nonnull @.str.130, i32 noundef 0) #7
  %22 = icmp sgt i32 %21, -1
  br i1 %22, label %23, label %25

23:                                               ; preds = %19
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.135, ptr noundef %0) #7
  %24 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

25:                                               ; preds = %19
  %26 = tail call i32 @open(ptr noundef nonnull @.str.131, i32 noundef 0) #7
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %30

28:                                               ; preds = %25
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.136, ptr noundef %0) #7
  %29 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

30:                                               ; preds = %25
  %31 = tail call i32 @read(i32 noundef %26, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %32 = icmp eq i32 %31, 5
  br i1 %32, label %35, label %33

33:                                               ; preds = %30
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.137, ptr noundef %0) #7
  %34 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

35:                                               ; preds = %30
  %36 = tail call i32 @close(i32 noundef %26) #7
  %37 = tail call i32 @link(ptr noundef nonnull @.str.131, ptr noundef nonnull @.str.131) #7
  %38 = icmp sgt i32 %37, -1
  br i1 %38, label %39, label %41

39:                                               ; preds = %35
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.138, ptr noundef %0) #7
  %40 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

41:                                               ; preds = %35
  %42 = tail call i32 @unlink(ptr noundef nonnull @.str.131) #7
  %43 = tail call i32 @link(ptr noundef nonnull @.str.131, ptr noundef nonnull @.str.130) #7
  %44 = icmp sgt i32 %43, -1
  br i1 %44, label %45, label %47

45:                                               ; preds = %41
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.139, ptr noundef %0) #7
  %46 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

47:                                               ; preds = %41
  %48 = tail call i32 @link(ptr noundef nonnull @.str.140, ptr noundef nonnull @.str.130) #7
  %49 = icmp sgt i32 %48, -1
  br i1 %49, label %50, label %52

50:                                               ; preds = %47
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.141, ptr noundef %0) #7
  %51 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

52:                                               ; preds = %47
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @concreate(ptr noundef %0) #0 {
  %2 = alloca [3 x i8], align 1
  %3 = alloca [40 x i8], align 1
  %4 = alloca %struct.anon, align 2
  %5 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 3, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %4) #9
  store i8 67, ptr %2, align 1, !tbaa !14
  %6 = getelementptr inbounds nuw i8, ptr %2, i32 2
  store i8 0, ptr %6, align 1, !tbaa !14
  %7 = getelementptr inbounds nuw i8, ptr %2, i32 1
  br label %8

8:                                                ; preds = %44, %1
  %9 = phi i32 [ 0, %1 ], [ %45, %44 ]
  %10 = icmp eq i32 %9, 40
  br i1 %10, label %46, label %11

11:                                               ; preds = %8
  %12 = trunc nuw i32 %9 to i8
  %13 = add nuw nsw i8 %12, 48
  store i8 %13, ptr %7, align 1, !tbaa !14
  %14 = call i32 @unlink(ptr noundef nonnull %2) #7
  %15 = call i32 @fork() #7
  %16 = icmp ne i32 %15, 0
  %17 = urem i8 %12, 3
  %18 = icmp eq i8 %17, 1
  %19 = and i1 %18, %16
  br i1 %19, label %20, label %22

20:                                               ; preds = %11
  %21 = call i32 @link(ptr noundef nonnull @.str.142, ptr noundef nonnull %2) #7
  br label %38

22:                                               ; preds = %11
  %23 = icmp eq i32 %15, 0
  %24 = urem i8 %12, 5
  %25 = icmp eq i8 %24, 1
  %26 = and i1 %25, %23
  br i1 %26, label %27, label %29

27:                                               ; preds = %22
  %28 = call i32 @link(ptr noundef nonnull @.str.142, ptr noundef nonnull %2) #7
  br label %36

29:                                               ; preds = %22
  %30 = call i32 @open(ptr noundef nonnull %2, i32 noundef 514) #7
  %31 = icmp slt i32 %30, 0
  br i1 %31, label %32, label %34

32:                                               ; preds = %29
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.143, ptr noundef nonnull %2) #7
  %33 = call i32 @exit(i32 noundef 1) #8
  unreachable

34:                                               ; preds = %29
  %35 = call i32 @close(i32 noundef %30) #7
  br i1 %23, label %36, label %38

36:                                               ; preds = %34, %27
  %37 = call i32 @exit(i32 noundef 0) #8
  unreachable

38:                                               ; preds = %20, %34
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #9
  %39 = call i32 @wait(ptr noundef nonnull %5) #7
  %40 = load i32, ptr %5, align 4, !tbaa !7
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %44, label %42

42:                                               ; preds = %38
  %43 = call i32 @exit(i32 noundef 1) #8
  unreachable

44:                                               ; preds = %38
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #9
  %45 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !62

46:                                               ; preds = %8
  %47 = call ptr @memset(ptr noundef nonnull %3, i32 noundef 0, i32 noundef 40) #7
  %48 = call i32 @open(ptr noundef nonnull @.str.140, i32 noundef 0) #7
  %49 = getelementptr inbounds nuw i8, ptr %4, i32 2
  %50 = getelementptr inbounds nuw i8, ptr %4, i32 4
  %51 = getelementptr inbounds nuw i8, ptr %4, i32 3
  br label %52

52:                                               ; preds = %82, %46
  %53 = phi i32 [ %83, %82 ], [ 0, %46 ]
  br label %54

54:                                               ; preds = %52, %61
  br label %55

55:                                               ; preds = %54, %58
  %56 = call i32 @read(i32 noundef %48, ptr noundef nonnull %4, i32 noundef 64) #7
  %57 = icmp sgt i32 %56, 0
  br i1 %57, label %58, label %84

58:                                               ; preds = %55
  %59 = load i16, ptr %4, align 2, !tbaa !63
  %60 = icmp eq i16 %59, 0
  br i1 %60, label %55, label %61, !llvm.loop !66

61:                                               ; preds = %58
  %62 = load i8, ptr %49, align 2, !tbaa !14
  %63 = icmp eq i8 %62, 67
  %64 = load i8, ptr %50, align 2
  %65 = icmp eq i8 %64, 0
  %66 = select i1 %63, i1 %65, i1 false
  br i1 %66, label %67, label %54, !llvm.loop !66

67:                                               ; preds = %61
  %68 = load i8, ptr %51, align 1, !tbaa !14
  %69 = sext i8 %68 to i32
  %70 = add nsw i32 %69, -48
  %71 = icmp slt i8 %68, 48
  br i1 %71, label %74, label %72

72:                                               ; preds = %67
  %73 = icmp ugt i32 %70, 39
  br i1 %73, label %74, label %76

74:                                               ; preds = %72, %67
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.144, ptr noundef %0, ptr noundef nonnull %49) #7
  %75 = call i32 @exit(i32 noundef 1) #8
  unreachable

76:                                               ; preds = %72
  %77 = getelementptr inbounds nuw [40 x i8], ptr %3, i32 0, i32 %70
  %78 = load i8, ptr %77, align 1, !tbaa !14
  %79 = icmp eq i8 %78, 0
  br i1 %79, label %82, label %80

80:                                               ; preds = %76
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.145, ptr noundef %0, ptr noundef nonnull %49) #7
  %81 = call i32 @exit(i32 noundef 1) #8
  unreachable

82:                                               ; preds = %76
  store i8 1, ptr %77, align 1, !tbaa !14
  %83 = add nuw nsw i32 %53, 1
  br label %52, !llvm.loop !66

84:                                               ; preds = %55
  %85 = call i32 @close(i32 noundef %48) #7
  %86 = icmp eq i32 %53, 40
  br i1 %86, label %89, label %87

87:                                               ; preds = %84
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.146, ptr noundef %0) #7
  %88 = call i32 @exit(i32 noundef 1) #8
  unreachable

89:                                               ; preds = %84, %132
  %90 = phi i32 [ %134, %132 ], [ 0, %84 ]
  %91 = icmp eq i32 %90, 40
  br i1 %91, label %135, label %92

92:                                               ; preds = %89
  %93 = trunc nuw i32 %90 to i8
  %94 = add nuw nsw i8 %93, 48
  store i8 %94, ptr %7, align 1, !tbaa !14
  %95 = call i32 @fork() #7
  %96 = icmp slt i32 %95, 0
  br i1 %96, label %97, label %99

97:                                               ; preds = %92
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %98 = call i32 @exit(i32 noundef 1) #8
  unreachable

99:                                               ; preds = %92
  %100 = urem i8 %93, 3
  %101 = zext nneg i8 %100 to i32
  %102 = icmp eq i32 %95, 0
  %103 = or i32 %95, %101
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %109, label %105

105:                                              ; preds = %99
  %106 = icmp eq i8 %100, 1
  %107 = icmp ne i32 %95, 0
  %108 = and i1 %106, %107
  br i1 %108, label %109, label %122

109:                                              ; preds = %105, %99
  %110 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %111 = call i32 @close(i32 noundef %110) #7
  %112 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %113 = call i32 @close(i32 noundef %112) #7
  %114 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %115 = call i32 @close(i32 noundef %114) #7
  %116 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %117 = call i32 @close(i32 noundef %116) #7
  %118 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %119 = call i32 @close(i32 noundef %118) #7
  %120 = call i32 @open(ptr noundef nonnull %2, i32 noundef 0) #7
  %121 = call i32 @close(i32 noundef %120) #7
  br label %129

122:                                              ; preds = %105
  %123 = call i32 @unlink(ptr noundef nonnull %2) #7
  %124 = call i32 @unlink(ptr noundef nonnull %2) #7
  %125 = call i32 @unlink(ptr noundef nonnull %2) #7
  %126 = call i32 @unlink(ptr noundef nonnull %2) #7
  %127 = call i32 @unlink(ptr noundef nonnull %2) #7
  %128 = call i32 @unlink(ptr noundef nonnull %2) #7
  br label %129

129:                                              ; preds = %122, %109
  br i1 %102, label %130, label %132

130:                                              ; preds = %129
  %131 = call i32 @exit(i32 noundef 0) #8
  unreachable

132:                                              ; preds = %129
  %133 = call i32 @wait(ptr noundef null) #7
  %134 = add nuw nsw i32 %90, 1
  br label %89, !llvm.loop !67

135:                                              ; preds = %89
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 3, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @linkunlink(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.9) #7
  %3 = tail call i32 @fork() #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = icmp eq i32 %3, 0
  %9 = select i1 %8, i32 97, i32 1
  br label %10

10:                                               ; preds = %25, %7
  %11 = phi i32 [ 0, %7 ], [ %26, %25 ]
  %12 = phi i32 [ %9, %7 ], [ %16, %25 ]
  %13 = icmp eq i32 %11, 100
  br i1 %13, label %27, label %14

14:                                               ; preds = %10
  %15 = mul i32 %12, 1103515245
  %16 = add i32 %15, 12345
  %17 = urem i32 %16, 3
  switch i32 %17, label %23 [
    i32 0, label %18
    i32 1, label %21
  ]

18:                                               ; preds = %14
  %19 = tail call i32 @open(ptr noundef nonnull @.str.9, i32 noundef 514) #7
  %20 = tail call i32 @close(i32 noundef %19) #7
  br label %25

21:                                               ; preds = %14
  %22 = tail call i32 @link(ptr noundef nonnull @.str.147, ptr noundef nonnull @.str.9) #7
  br label %25

23:                                               ; preds = %14
  %24 = tail call i32 @unlink(ptr noundef nonnull @.str.9) #7
  br label %25

25:                                               ; preds = %18, %23, %21
  %26 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !68

27:                                               ; preds = %10
  br i1 %8, label %30, label %28

28:                                               ; preds = %27
  %29 = tail call i32 @wait(ptr noundef null) #7
  ret void

30:                                               ; preds = %27
  %31 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @subdir(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.148) #7
  %3 = tail call i32 @mkdir(ptr noundef nonnull @.str.149) #7
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %7, label %5

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.150, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = tail call i32 @open(ptr noundef nonnull @.str.151, i32 noundef 514) #7
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %7
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.152, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %7
  %13 = tail call i32 @write(i32 noundef %8, ptr noundef nonnull @.str.148, i32 noundef 2) #7
  %14 = tail call i32 @close(i32 noundef %8) #7
  %15 = tail call i32 @unlink(ptr noundef nonnull @.str.149) #7
  %16 = icmp sgt i32 %15, -1
  br i1 %16, label %17, label %19

17:                                               ; preds = %12
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.153, ptr noundef %0) #7
  %18 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %12
  %20 = tail call i32 @mkdir(ptr noundef nonnull @.str.154) #7
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %24, label %22

22:                                               ; preds = %19
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.155, ptr noundef %0) #7
  %23 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

24:                                               ; preds = %19
  %25 = tail call i32 @open(ptr noundef nonnull @.str.156, i32 noundef 514) #7
  %26 = icmp slt i32 %25, 0
  br i1 %26, label %27, label %29

27:                                               ; preds = %24
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.157, ptr noundef %0) #7
  %28 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

29:                                               ; preds = %24
  %30 = tail call i32 @write(i32 noundef %25, ptr noundef nonnull @.str.158, i32 noundef 2) #7
  %31 = tail call i32 @close(i32 noundef %25) #7
  %32 = tail call i32 @open(ptr noundef nonnull @.str.159, i32 noundef 0) #7
  %33 = icmp slt i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %29
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.160, ptr noundef %0) #7
  %35 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

36:                                               ; preds = %29
  %37 = tail call i32 @read(i32 noundef %32, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %38 = icmp eq i32 %37, 2
  %39 = load i8, ptr @buf, align 4
  %40 = icmp eq i8 %39, 102
  %41 = select i1 %38, i1 %40, i1 false
  br i1 %41, label %44, label %42

42:                                               ; preds = %36
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.161, ptr noundef %0) #7
  %43 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

44:                                               ; preds = %36
  %45 = tail call i32 @close(i32 noundef %32) #7
  %46 = tail call i32 @link(ptr noundef nonnull @.str.156, ptr noundef nonnull @.str.162) #7
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %50, label %48

48:                                               ; preds = %44
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.163, ptr noundef %0) #7
  %49 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

50:                                               ; preds = %44
  %51 = tail call i32 @unlink(ptr noundef nonnull @.str.156) #7
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %55, label %53

53:                                               ; preds = %50
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.164, ptr noundef %0) #7
  %54 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

55:                                               ; preds = %50
  %56 = tail call i32 @open(ptr noundef nonnull @.str.156, i32 noundef 0) #7
  %57 = icmp sgt i32 %56, -1
  br i1 %57, label %58, label %60

58:                                               ; preds = %55
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.165, ptr noundef %0) #7
  %59 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

60:                                               ; preds = %55
  %61 = tail call i32 @chdir(ptr noundef nonnull @.str.149) #7
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %65, label %63

63:                                               ; preds = %60
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.166, ptr noundef %0) #7
  %64 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

65:                                               ; preds = %60
  %66 = tail call i32 @chdir(ptr noundef nonnull @.str.167) #7
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %70, label %68

68:                                               ; preds = %65
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.168, ptr noundef %0) #7
  %69 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

70:                                               ; preds = %65
  %71 = tail call i32 @chdir(ptr noundef nonnull @.str.169) #7
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %75, label %73

73:                                               ; preds = %70
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.170, ptr noundef %0) #7
  %74 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

75:                                               ; preds = %70
  %76 = tail call i32 @chdir(ptr noundef nonnull @.str.171) #7
  %77 = icmp eq i32 %76, 0
  br i1 %77, label %80, label %78

78:                                               ; preds = %75
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.172, ptr noundef %0) #7
  %79 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

80:                                               ; preds = %75
  %81 = tail call i32 @open(ptr noundef nonnull @.str.162, i32 noundef 0) #7
  %82 = icmp slt i32 %81, 0
  br i1 %82, label %83, label %85

83:                                               ; preds = %80
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.173, ptr noundef %0) #7
  %84 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

85:                                               ; preds = %80
  %86 = tail call i32 @read(i32 noundef %81, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %87 = icmp eq i32 %86, 2
  br i1 %87, label %90, label %88

88:                                               ; preds = %85
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.174, ptr noundef %0) #7
  %89 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

90:                                               ; preds = %85
  %91 = tail call i32 @close(i32 noundef %81) #7
  %92 = tail call i32 @open(ptr noundef nonnull @.str.156, i32 noundef 0) #7
  %93 = icmp sgt i32 %92, -1
  br i1 %93, label %94, label %96

94:                                               ; preds = %90
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.175, ptr noundef %0) #7
  %95 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

96:                                               ; preds = %90
  %97 = tail call i32 @open(ptr noundef nonnull @.str.176, i32 noundef 514) #7
  %98 = icmp sgt i32 %97, -1
  br i1 %98, label %99, label %101

99:                                               ; preds = %96
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.177, ptr noundef %0) #7
  %100 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

101:                                              ; preds = %96
  %102 = tail call i32 @open(ptr noundef nonnull @.str.178, i32 noundef 514) #7
  %103 = icmp sgt i32 %102, -1
  br i1 %103, label %104, label %106

104:                                              ; preds = %101
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.179, ptr noundef %0) #7
  %105 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

106:                                              ; preds = %101
  %107 = tail call i32 @open(ptr noundef nonnull @.str.149, i32 noundef 512) #7
  %108 = icmp sgt i32 %107, -1
  br i1 %108, label %109, label %111

109:                                              ; preds = %106
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.180, ptr noundef %0) #7
  %110 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

111:                                              ; preds = %106
  %112 = tail call i32 @open(ptr noundef nonnull @.str.149, i32 noundef 2) #7
  %113 = icmp sgt i32 %112, -1
  br i1 %113, label %114, label %116

114:                                              ; preds = %111
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.181, ptr noundef %0) #7
  %115 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

116:                                              ; preds = %111
  %117 = tail call i32 @open(ptr noundef nonnull @.str.149, i32 noundef 1) #7
  %118 = icmp sgt i32 %117, -1
  br i1 %118, label %119, label %121

119:                                              ; preds = %116
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.182, ptr noundef %0) #7
  %120 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

121:                                              ; preds = %116
  %122 = tail call i32 @link(ptr noundef nonnull @.str.176, ptr noundef nonnull @.str.183) #7
  %123 = icmp eq i32 %122, 0
  br i1 %123, label %124, label %126

124:                                              ; preds = %121
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.184, ptr noundef %0) #7
  %125 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

126:                                              ; preds = %121
  %127 = tail call i32 @link(ptr noundef nonnull @.str.178, ptr noundef nonnull @.str.183) #7
  %128 = icmp eq i32 %127, 0
  br i1 %128, label %129, label %131

129:                                              ; preds = %126
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.185, ptr noundef %0) #7
  %130 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

131:                                              ; preds = %126
  %132 = tail call i32 @link(ptr noundef nonnull @.str.151, ptr noundef nonnull @.str.162) #7
  %133 = icmp eq i32 %132, 0
  br i1 %133, label %134, label %136

134:                                              ; preds = %131
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.186, ptr noundef %0) #7
  %135 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

136:                                              ; preds = %131
  %137 = tail call i32 @mkdir(ptr noundef nonnull @.str.176) #7
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %139, label %141

139:                                              ; preds = %136
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.187, ptr noundef %0) #7
  %140 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

141:                                              ; preds = %136
  %142 = tail call i32 @mkdir(ptr noundef nonnull @.str.178) #7
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %144, label %146

144:                                              ; preds = %141
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.188, ptr noundef %0) #7
  %145 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

146:                                              ; preds = %141
  %147 = tail call i32 @mkdir(ptr noundef nonnull @.str.162) #7
  %148 = icmp eq i32 %147, 0
  br i1 %148, label %149, label %151

149:                                              ; preds = %146
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.189, ptr noundef %0) #7
  %150 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

151:                                              ; preds = %146
  %152 = tail call i32 @unlink(ptr noundef nonnull @.str.178) #7
  %153 = icmp eq i32 %152, 0
  br i1 %153, label %154, label %156

154:                                              ; preds = %151
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.190, ptr noundef %0) #7
  %155 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

156:                                              ; preds = %151
  %157 = tail call i32 @unlink(ptr noundef nonnull @.str.176) #7
  %158 = icmp eq i32 %157, 0
  br i1 %158, label %159, label %161

159:                                              ; preds = %156
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.191, ptr noundef %0) #7
  %160 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

161:                                              ; preds = %156
  %162 = tail call i32 @chdir(ptr noundef nonnull @.str.151) #7
  %163 = icmp eq i32 %162, 0
  br i1 %163, label %164, label %166

164:                                              ; preds = %161
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.192, ptr noundef %0) #7
  %165 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

166:                                              ; preds = %161
  %167 = tail call i32 @chdir(ptr noundef nonnull @.str.193) #7
  %168 = icmp eq i32 %167, 0
  br i1 %168, label %169, label %171

169:                                              ; preds = %166
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.194, ptr noundef %0) #7
  %170 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

171:                                              ; preds = %166
  %172 = tail call i32 @unlink(ptr noundef nonnull @.str.162) #7
  %173 = icmp eq i32 %172, 0
  br i1 %173, label %176, label %174

174:                                              ; preds = %171
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.164, ptr noundef %0) #7
  %175 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

176:                                              ; preds = %171
  %177 = tail call i32 @unlink(ptr noundef nonnull @.str.151) #7
  %178 = icmp eq i32 %177, 0
  br i1 %178, label %181, label %179

179:                                              ; preds = %176
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.195, ptr noundef %0) #7
  %180 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

181:                                              ; preds = %176
  %182 = tail call i32 @unlink(ptr noundef nonnull @.str.149) #7
  %183 = icmp eq i32 %182, 0
  br i1 %183, label %184, label %186

184:                                              ; preds = %181
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.196, ptr noundef %0) #7
  %185 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

186:                                              ; preds = %181
  %187 = tail call i32 @unlink(ptr noundef nonnull @.str.197) #7
  %188 = icmp slt i32 %187, 0
  br i1 %188, label %189, label %191

189:                                              ; preds = %186
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.198, ptr noundef %0) #7
  %190 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

191:                                              ; preds = %186
  %192 = tail call i32 @unlink(ptr noundef nonnull @.str.149) #7
  %193 = icmp slt i32 %192, 0
  br i1 %193, label %194, label %196

194:                                              ; preds = %191
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.199, ptr noundef %0) #7
  %195 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

196:                                              ; preds = %191
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @bigwrite(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.200) #7
  br label %3

3:                                                ; preds = %20, %1
  %4 = phi i32 [ 499, %1 ], [ %23, %20 ]
  %5 = icmp samesign ult i32 %4, 12288
  br i1 %5, label %6, label %24

6:                                                ; preds = %3
  %7 = tail call i32 @open(ptr noundef nonnull @.str.200, i32 noundef 514) #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.201, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6, %14
  %12 = phi i32 [ %17, %14 ], [ 0, %6 ]
  %13 = icmp eq i32 %12, 2
  br i1 %13, label %20, label %14

14:                                               ; preds = %11
  %15 = tail call i32 @write(i32 noundef %7, ptr noundef nonnull @buf, i32 noundef %4) #7
  %16 = icmp eq i32 %15, %4
  %17 = add nuw nsw i32 %12, 1
  br i1 %16, label %11, label %18, !llvm.loop !69

18:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.202, ptr noundef %0, i32 noundef %4, i32 noundef %15) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %11
  %21 = tail call i32 @close(i32 noundef %7) #7
  %22 = tail call i32 @unlink(ptr noundef nonnull @.str.200) #7
  %23 = add nuw nsw i32 %4, 471
  br label %3, !llvm.loop !70

24:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @bigfile(ptr noundef %0) #0 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.203) #7
  %3 = tail call i32 @open(ptr noundef nonnull @.str.203, i32 noundef 514) #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.204, ptr noundef %0) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1, %10
  %8 = phi i32 [ %14, %10 ], [ 0, %1 ]
  %9 = icmp eq i32 %8, 20
  br i1 %9, label %17, label %10

10:                                               ; preds = %7
  %11 = tail call ptr @memset(ptr noundef nonnull @buf, i32 noundef %8, i32 noundef 600) #7
  %12 = tail call i32 @write(i32 noundef %3, ptr noundef nonnull @buf, i32 noundef 600) #7
  %13 = icmp eq i32 %12, 600
  %14 = add nuw nsw i32 %8, 1
  br i1 %13, label %7, label %15, !llvm.loop !71

15:                                               ; preds = %10
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.205, ptr noundef %0) #7
  %16 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

17:                                               ; preds = %7
  %18 = tail call i32 @close(i32 noundef %3) #7
  %19 = tail call i32 @open(ptr noundef nonnull @.str.203, i32 noundef 0) #7
  %20 = icmp slt i32 %19, 0
  br i1 %20, label %21, label %23

21:                                               ; preds = %17
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.206, ptr noundef %0) #7
  %22 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %17, %44
  %24 = phi i32 [ %46, %44 ], [ 0, %17 ]
  %25 = phi i32 [ %45, %44 ], [ 0, %17 ]
  %26 = tail call i32 @read(i32 noundef %19, ptr noundef nonnull @buf, i32 noundef 300) #7
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %30

28:                                               ; preds = %23
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.207, ptr noundef %0) #7
  %29 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

30:                                               ; preds = %23
  switch i32 %26, label %31 [
    i32 0, label %47
    i32 300, label %33
  ]

31:                                               ; preds = %30
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.208, ptr noundef %0) #7
  %32 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %30
  %34 = load i8, ptr @buf, align 4, !tbaa !14
  %35 = sext i8 %34 to i32
  %36 = lshr i32 %24, 1
  %37 = icmp eq i32 %36, %35
  %38 = load i8, ptr getelementptr inbounds nuw (i8, ptr @buf, i32 299), align 1
  %39 = sext i8 %38 to i32
  %40 = icmp eq i32 %36, %39
  %41 = select i1 %37, i1 %40, i1 false
  br i1 %41, label %44, label %42

42:                                               ; preds = %33
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.209, ptr noundef %0) #7
  %43 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

44:                                               ; preds = %33
  %45 = add nuw nsw i32 %25, 300
  %46 = add nuw nsw i32 %24, 1
  br label %23, !llvm.loop !72

47:                                               ; preds = %30
  %48 = tail call i32 @close(i32 noundef %19) #7
  %49 = icmp eq i32 %25, 12000
  br i1 %49, label %52, label %50

50:                                               ; preds = %47
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.210, ptr noundef %0) #7
  %51 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

52:                                               ; preds = %47
  %53 = tail call i32 @unlink(ptr noundef nonnull @.str.203) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fourteen(ptr noundef %0) #0 {
  %2 = tail call i32 @mkdir(ptr noundef nonnull @.str.211) #7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %6, label %4

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.212, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @mkdir(ptr noundef nonnull @.str.213) #7
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %11, label %9

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.214, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = tail call i32 @open(ptr noundef nonnull @.str.215, i32 noundef 512) #7
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.216, ptr noundef %0) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %11
  %17 = tail call i32 @close(i32 noundef %12) #7
  %18 = tail call i32 @open(ptr noundef nonnull @.str.217, i32 noundef 0) #7
  %19 = icmp slt i32 %18, 0
  br i1 %19, label %20, label %22

20:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.218, ptr noundef %0) #7
  %21 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %16
  %23 = tail call i32 @close(i32 noundef %18) #7
  %24 = tail call i32 @mkdir(ptr noundef nonnull @.str.219) #7
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %28

26:                                               ; preds = %22
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.220, ptr noundef %0) #7
  %27 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

28:                                               ; preds = %22
  %29 = tail call i32 @mkdir(ptr noundef nonnull @.str.221) #7
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %28
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.222, ptr noundef %0) #7
  %32 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %28
  %34 = tail call i32 @unlink(ptr noundef nonnull @.str.221) #7
  %35 = tail call i32 @unlink(ptr noundef nonnull @.str.219) #7
  %36 = tail call i32 @unlink(ptr noundef nonnull @.str.217) #7
  %37 = tail call i32 @unlink(ptr noundef nonnull @.str.215) #7
  %38 = tail call i32 @unlink(ptr noundef nonnull @.str.213) #7
  %39 = tail call i32 @unlink(ptr noundef nonnull @.str.211) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @rmdot(ptr noundef %0) #0 {
  %2 = tail call i32 @mkdir(ptr noundef nonnull @.str.223) #7
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %6, label %4

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.224, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @chdir(ptr noundef nonnull @.str.223) #7
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %11, label %9

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.225, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = tail call i32 @unlink(ptr noundef nonnull @.str.140) #7
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.226, ptr noundef %0) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %11
  %17 = tail call i32 @unlink(ptr noundef nonnull @.str.79) #7
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.227, ptr noundef %0) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  %22 = tail call i32 @chdir(ptr noundef nonnull @.str.50) #7
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %26, label %24

24:                                               ; preds = %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.51, ptr noundef %0) #7
  %25 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

26:                                               ; preds = %21
  %27 = tail call i32 @unlink(ptr noundef nonnull @.str.228) #7
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %31

29:                                               ; preds = %26
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.229, ptr noundef %0) #7
  %30 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

31:                                               ; preds = %26
  %32 = tail call i32 @unlink(ptr noundef nonnull @.str.230) #7
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %31
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.231, ptr noundef %0) #7
  %35 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

36:                                               ; preds = %31
  %37 = tail call i32 @unlink(ptr noundef nonnull @.str.223) #7
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %41, label %39

39:                                               ; preds = %36
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.232, ptr noundef %0) #7
  %40 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

41:                                               ; preds = %36
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @dirfile(ptr noundef %0) #0 {
  %2 = tail call i32 @open(ptr noundef nonnull @.str.233, i32 noundef 512) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.234, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @close(i32 noundef %2) #7
  %8 = tail call i32 @chdir(ptr noundef nonnull @.str.233) #7
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.235, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %6
  %13 = tail call i32 @open(ptr noundef nonnull @.str.236, i32 noundef 0) #7
  %14 = icmp sgt i32 %13, -1
  br i1 %14, label %15, label %17

15:                                               ; preds = %12
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.237, ptr noundef %0) #7
  %16 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

17:                                               ; preds = %12
  %18 = tail call i32 @open(ptr noundef nonnull @.str.236, i32 noundef 512) #7
  %19 = icmp sgt i32 %18, -1
  br i1 %19, label %20, label %22

20:                                               ; preds = %17
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.237, ptr noundef %0) #7
  %21 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %17
  %23 = tail call i32 @mkdir(ptr noundef nonnull @.str.236) #7
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %22
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.238, ptr noundef %0) #7
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %22
  %28 = tail call i32 @unlink(ptr noundef nonnull @.str.236) #7
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %32

30:                                               ; preds = %27
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.239, ptr noundef %0) #7
  %31 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %27
  %33 = tail call i32 @link(ptr noundef nonnull @.str.6, ptr noundef nonnull @.str.236) #7
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %35, label %37

35:                                               ; preds = %32
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.240, ptr noundef %0) #7
  %36 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

37:                                               ; preds = %32
  %38 = tail call i32 @unlink(ptr noundef nonnull @.str.233) #7
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %42, label %40

40:                                               ; preds = %37
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.241, ptr noundef %0) #7
  %41 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

42:                                               ; preds = %37
  %43 = tail call i32 @open(ptr noundef nonnull @.str.140, i32 noundef 2) #7
  %44 = icmp sgt i32 %43, -1
  br i1 %44, label %45, label %47

45:                                               ; preds = %42
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.242, ptr noundef %0) #7
  %46 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

47:                                               ; preds = %42
  %48 = tail call i32 @open(ptr noundef nonnull @.str.140, i32 noundef 0) #7
  %49 = tail call i32 @write(i32 noundef %48, ptr noundef nonnull @.str.9, i32 noundef 1) #7
  %50 = icmp sgt i32 %49, 0
  br i1 %50, label %51, label %53

51:                                               ; preds = %47
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.243, ptr noundef %0) #7
  %52 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

53:                                               ; preds = %47
  %54 = tail call i32 @close(i32 noundef %48) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @iref(ptr noundef %0) #0 {
  br label %2

2:                                                ; preds = %27, %1
  %3 = phi i32 [ 0, %1 ], [ %29, %27 ]
  %4 = icmp eq i32 %3, 51
  br i1 %4, label %30, label %5

5:                                                ; preds = %2
  %6 = tail call i32 @mkdir(ptr noundef nonnull @.str.244) #7
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %5
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.245, ptr noundef %0) #7
  %9 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

10:                                               ; preds = %5
  %11 = tail call i32 @chdir(ptr noundef nonnull @.str.244) #7
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %15, label %13

13:                                               ; preds = %10
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.246, ptr noundef %0) #7
  %14 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

15:                                               ; preds = %10
  %16 = tail call i32 @mkdir(ptr noundef nonnull @.str.247) #7
  %17 = tail call i32 @link(ptr noundef nonnull @.str.6, ptr noundef nonnull @.str.247) #7
  %18 = tail call i32 @open(ptr noundef nonnull @.str.247, i32 noundef 512) #7
  %19 = icmp sgt i32 %18, -1
  br i1 %19, label %20, label %22

20:                                               ; preds = %15
  %21 = tail call i32 @close(i32 noundef %18) #7
  br label %22

22:                                               ; preds = %20, %15
  %23 = tail call i32 @open(ptr noundef nonnull @.str.16, i32 noundef 512) #7
  %24 = icmp sgt i32 %23, -1
  br i1 %24, label %25, label %27

25:                                               ; preds = %22
  %26 = tail call i32 @close(i32 noundef %23) #7
  br label %27

27:                                               ; preds = %25, %22
  %28 = tail call i32 @unlink(ptr noundef nonnull @.str.16) #7
  %29 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !73

30:                                               ; preds = %2, %33
  %31 = phi i32 [ %36, %33 ], [ 0, %2 ]
  %32 = icmp eq i32 %31, 51
  br i1 %32, label %37, label %33

33:                                               ; preds = %30
  %34 = tail call i32 @chdir(ptr noundef nonnull @.str.79) #7
  %35 = tail call i32 @unlink(ptr noundef nonnull @.str.244) #7
  %36 = add nuw nsw i32 %31, 1
  br label %30, !llvm.loop !74

37:                                               ; preds = %30
  %38 = tail call i32 @chdir(ptr noundef nonnull @.str.50) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @forktest(ptr noundef %0) #0 {
  br label %2

2:                                                ; preds = %12, %1
  %3 = phi i32 [ 0, %1 ], [ %13, %12 ]
  %4 = icmp eq i32 %3, 1000
  br i1 %4, label %18, label %5

5:                                                ; preds = %2
  %6 = tail call i32 @fork() #7
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %14, label %8

8:                                                ; preds = %5
  %9 = icmp eq i32 %6, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %8
  %11 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

12:                                               ; preds = %8
  %13 = add nuw nsw i32 %3, 1
  br label %2, !llvm.loop !75

14:                                               ; preds = %5
  %15 = icmp eq i32 %3, 0
  br i1 %15, label %16, label %20

16:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.248, ptr noundef %0) #7
  %17 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

18:                                               ; preds = %2
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.249, ptr noundef %0) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %14, %24
  %21 = phi i32 [ %26, %24 ], [ %3, %14 ]
  %22 = icmp sgt i32 %21, 0
  %23 = tail call i32 @wait(ptr noundef null) #7
  br i1 %22, label %24, label %29

24:                                               ; preds = %20
  %25 = icmp slt i32 %23, 0
  %26 = add nsw i32 %21, -1
  br i1 %25, label %27, label %20, !llvm.loop !76

27:                                               ; preds = %24
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.250, ptr noundef %0) #7
  %28 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

29:                                               ; preds = %20
  %30 = icmp eq i32 %23, -1
  br i1 %30, label %33, label %31

31:                                               ; preds = %29
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.251, ptr noundef %0) #7
  %32 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %29
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @sbrkbasic(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %3 = tail call i32 @fork() #7
  %4 = icmp slt i32 %3, 0
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.252) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1
  %8 = icmp eq i32 %3, 0
  br i1 %8, label %9, label %22

9:                                                ; preds = %7
  %10 = tail call ptr @sbrk(i32 noundef 1073741824) #7
  %11 = icmp eq ptr %10, inttoptr (i32 -1 to ptr)
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  %13 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

14:                                               ; preds = %9, %17
  %15 = phi i32 [ %19, %17 ], [ 0, %9 ]
  %16 = icmp samesign ult i32 %15, 1073741824
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %10, i32 %15
  store i8 99, ptr %18, align 1, !tbaa !14
  %19 = add nuw nsw i32 %15, 4096
  br label %14, !llvm.loop !77

20:                                               ; preds = %14
  %21 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %7
  %23 = call i32 @wait(ptr noundef nonnull %2) #7
  %24 = load i32, ptr %2, align 4, !tbaa !7
  %25 = icmp eq i32 %24, 1
  br i1 %25, label %26, label %28

26:                                               ; preds = %22
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.253, ptr noundef %0) #7
  %27 = call i32 @exit(i32 noundef 1) #8
  unreachable

28:                                               ; preds = %22
  %29 = call ptr @sbrk(i32 noundef 0) #7
  br label %30

30:                                               ; preds = %39, %28
  %31 = phi i32 [ 0, %28 ], [ %41, %39 ]
  %32 = phi ptr [ %29, %28 ], [ %40, %39 ]
  %33 = icmp eq i32 %31, 5000
  br i1 %33, label %42, label %34

34:                                               ; preds = %30
  %35 = call ptr @sbrk(i32 noundef 1) #7
  %36 = icmp eq ptr %35, %32
  br i1 %36, label %39, label %37

37:                                               ; preds = %34
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.254, ptr noundef %0, i32 noundef %31, ptr noundef %32, ptr noundef %35) #7
  %38 = call i32 @exit(i32 noundef 1) #8
  unreachable

39:                                               ; preds = %34
  store i8 1, ptr %35, align 1, !tbaa !14
  %40 = getelementptr inbounds nuw i8, ptr %35, i32 1
  %41 = add nuw nsw i32 %31, 1
  br label %30, !llvm.loop !78

42:                                               ; preds = %30
  %43 = call i32 @fork() #7
  %44 = icmp slt i32 %43, 0
  br i1 %44, label %45, label %47

45:                                               ; preds = %42
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.255, ptr noundef %0) #7
  %46 = call i32 @exit(i32 noundef 1) #8
  unreachable

47:                                               ; preds = %42
  %48 = call ptr @sbrk(i32 noundef 1) #7
  %49 = call ptr @sbrk(i32 noundef 1) #7
  %50 = getelementptr inbounds nuw i8, ptr %32, i32 1
  %51 = icmp eq ptr %49, %50
  br i1 %51, label %54, label %52

52:                                               ; preds = %47
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.256, ptr noundef %0) #7
  %53 = call i32 @exit(i32 noundef 1) #8
  unreachable

54:                                               ; preds = %47
  %55 = icmp eq i32 %43, 0
  br i1 %55, label %56, label %58

56:                                               ; preds = %54
  %57 = call i32 @exit(i32 noundef 0) #8
  unreachable

58:                                               ; preds = %54
  %59 = call i32 @wait(ptr noundef nonnull %2) #7
  %60 = load i32, ptr %2, align 4, !tbaa !7
  %61 = call i32 @exit(i32 noundef %60) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @sbrkmuch(ptr noundef %0) #0 {
  %2 = tail call ptr @sbrk(i32 noundef 0) #7
  %3 = tail call ptr @sbrk(i32 noundef 0) #7
  %4 = ptrtoint ptr %3 to i32
  %5 = sub i32 104857600, %4
  %6 = tail call ptr @sbrk(i32 noundef %5) #7
  %7 = icmp eq ptr %6, %3
  br i1 %7, label %10, label %8

8:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.257, ptr noundef %0) #7
  %9 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

10:                                               ; preds = %1
  store i8 99, ptr inttoptr (i32 104857599 to ptr), align 1, !tbaa !14
  %11 = tail call ptr @sbrk(i32 noundef 0) #7
  %12 = tail call ptr @sbrk(i32 noundef -4096) #7
  %13 = icmp eq ptr %12, inttoptr (i32 -1 to ptr)
  br i1 %13, label %14, label %16

14:                                               ; preds = %10
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.258, ptr noundef %0) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %10
  %17 = tail call ptr @sbrk(i32 noundef 0) #7
  %18 = getelementptr inbounds i8, ptr %11, i32 -4096
  %19 = icmp eq ptr %17, %18
  br i1 %19, label %22, label %20

20:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.259, ptr noundef %0, ptr noundef %11, ptr noundef %17) #7
  %21 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %16
  %23 = tail call ptr @sbrk(i32 noundef 0) #7
  %24 = tail call ptr @sbrk(i32 noundef 4096) #7
  %25 = icmp eq ptr %24, %23
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = tail call ptr @sbrk(i32 noundef 0) #7
  %28 = getelementptr inbounds nuw i8, ptr %23, i32 4096
  %29 = icmp eq ptr %27, %28
  br i1 %29, label %32, label %30

30:                                               ; preds = %26, %22
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.260, ptr noundef %0, ptr noundef %23, ptr noundef %24) #7
  %31 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %26
  %33 = load i8, ptr inttoptr (i32 104857599 to ptr), align 1, !tbaa !14
  %34 = icmp eq i8 %33, 99
  br i1 %34, label %35, label %37

35:                                               ; preds = %32
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.261, ptr noundef %0) #7
  %36 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

37:                                               ; preds = %32
  %38 = tail call ptr @sbrk(i32 noundef 0) #7
  %39 = tail call ptr @sbrk(i32 noundef 0) #7
  %40 = ptrtoint ptr %39 to i32
  %41 = ptrtoint ptr %2 to i32
  %42 = sub i32 %41, %40
  %43 = tail call ptr @sbrk(i32 noundef %42) #7
  %44 = icmp eq ptr %43, %38
  br i1 %44, label %47, label %45

45:                                               ; preds = %37
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.262, ptr noundef %0, ptr noundef %38, ptr noundef %43) #7
  %46 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

47:                                               ; preds = %37
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @kernmem(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  br label %3

3:                                                ; preds = %23, %1
  %4 = phi ptr [ inttoptr (i32 536870912 to ptr), %1 ], [ %24, %23 ]
  %5 = icmp ult ptr %4, inttoptr (i32 538870912 to ptr)
  br i1 %5, label %6, label %25

6:                                                ; preds = %3
  %7 = call i32 @fork() #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %10 = call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = icmp eq i32 %7, 0
  br i1 %12, label %13, label %17

13:                                               ; preds = %11
  %14 = load i8, ptr %4, align 1, !tbaa !14
  %15 = sext i8 %14 to i32
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.263, ptr noundef %0, ptr noundef nonnull %4, i32 noundef %15) #7
  %16 = call i32 @exit(i32 noundef 1) #8
  unreachable

17:                                               ; preds = %11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %18 = call i32 @wait(ptr noundef nonnull %2) #7
  %19 = load i32, ptr %2, align 4, !tbaa !7
  %20 = icmp eq i32 %19, -1
  br i1 %20, label %23, label %21

21:                                               ; preds = %17
  %22 = call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %17
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  %24 = getelementptr inbounds nuw i8, ptr %4, i32 50000
  br label %3, !llvm.loop !79

25:                                               ; preds = %3
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @MAXVAplus(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2)
  br label %4

4:                                                ; preds = %27, %1
  %5 = phi i32 [ %29, %27 ], [ -2147483648, %1 ]
  store volatile i32 %5, ptr %2, align 4, !tbaa !3
  %6 = load volatile i32, ptr %2, align 4, !tbaa !3
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %30, label %8

8:                                                ; preds = %4
  %9 = call i32 @fork() #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %12 = call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = icmp eq i32 %9, 0
  br i1 %14, label %15, label %21

15:                                               ; preds = %13
  %16 = load volatile i32, ptr %2, align 4, !tbaa !3
  %17 = inttoptr i32 %16 to ptr
  store i8 99, ptr %17, align 1, !tbaa !14
  %18 = load volatile i32, ptr %2, align 4, !tbaa !3
  %19 = inttoptr i32 %18 to ptr
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.264, ptr noundef %0, ptr noundef %19) #7
  %20 = call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %13
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  %22 = call i32 @wait(ptr noundef nonnull %3) #7
  %23 = load i32, ptr %3, align 4, !tbaa !7
  %24 = icmp eq i32 %23, -1
  br i1 %24, label %27, label %25

25:                                               ; preds = %21
  %26 = call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %21
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  %28 = load volatile i32, ptr %2, align 4, !tbaa !3
  %29 = shl i32 %28, 1
  br label %4, !llvm.loop !80

30:                                               ; preds = %4
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2)
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @sbrkfail(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca [2 x i32], align 4
  %4 = alloca i8, align 1
  %5 = alloca [10 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #9
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %4) #9
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5) #9
  %6 = call i32 @pipe(ptr noundef nonnull %3) #7
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %10, label %8

8:                                                ; preds = %1
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.91, ptr noundef %0) #7
  %9 = call i32 @exit(i32 noundef 1) #8
  unreachable

10:                                               ; preds = %1, %35
  %11 = phi i32 [ %37, %35 ], [ 0, %1 ]
  %12 = phi i32 [ %36, %35 ], [ 0, %1 ]
  %13 = icmp eq i32 %11, 10
  br i1 %13, label %38, label %14

14:                                               ; preds = %10
  %15 = call i32 @fork() #7
  %16 = getelementptr inbounds nuw [10 x i32], ptr %5, i32 0, i32 %11
  store i32 %15, ptr %16, align 4, !tbaa !7
  switch i32 %15, label %29 [
    i32 0, label %17
    i32 -1, label %35
  ]

17:                                               ; preds = %14
  %18 = call ptr @sbrk(i32 noundef 0) #7
  %19 = ptrtoint ptr %18 to i32
  %20 = sub i32 104857600, %19
  %21 = call ptr @sbrk(i32 noundef %20) #7
  %22 = icmp eq ptr %21, inttoptr (i32 -1 to ptr)
  %23 = getelementptr inbounds nuw i8, ptr %3, i32 4
  %24 = load i32, ptr %23, align 4, !tbaa !7
  %25 = select i1 %22, ptr @.str.265, ptr @.str.266
  %26 = call i32 @write(i32 noundef %24, ptr noundef nonnull %25, i32 noundef 1) #7
  br label %27

27:                                               ; preds = %27, %17
  %28 = call i32 @pause(i32 noundef 1000) #7
  br label %27, !llvm.loop !81

29:                                               ; preds = %14
  %30 = load i32, ptr %3, align 4, !tbaa !7
  %31 = call i32 @read(i32 noundef %30, ptr noundef nonnull %4, i32 noundef 1) #7
  %32 = load i8, ptr %4, align 1, !tbaa !14
  %33 = icmp eq i8 %32, 48
  %34 = select i1 %33, i32 1, i32 %12
  br label %35

35:                                               ; preds = %29, %14
  %36 = phi i32 [ %12, %14 ], [ %34, %29 ]
  %37 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !82

38:                                               ; preds = %10
  %39 = icmp eq i32 %12, 0
  br i1 %39, label %40, label %41

40:                                               ; preds = %38
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.267, ptr noundef %0) #7
  br label %41

41:                                               ; preds = %40, %38
  %42 = call ptr @sbrk(i32 noundef 4096) #7
  br label %43

43:                                               ; preds = %53, %41
  %44 = phi i32 [ 0, %41 ], [ %54, %53 ]
  %45 = icmp eq i32 %44, 10
  br i1 %45, label %55, label %46

46:                                               ; preds = %43
  %47 = getelementptr inbounds nuw [10 x i32], ptr %5, i32 0, i32 %44
  %48 = load i32, ptr %47, align 4, !tbaa !7
  %49 = icmp eq i32 %48, -1
  br i1 %49, label %53, label %50

50:                                               ; preds = %46
  %51 = call i32 @kill(i32 noundef %48) #7
  %52 = call i32 @wait(ptr noundef null) #7
  br label %53

53:                                               ; preds = %46, %50
  %54 = add nuw nsw i32 %44, 1
  br label %43, !llvm.loop !83

55:                                               ; preds = %43
  %56 = icmp eq ptr %42, inttoptr (i32 -1 to ptr)
  br i1 %56, label %57, label %59

57:                                               ; preds = %55
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.268, ptr noundef %0) #7
  %58 = call i32 @exit(i32 noundef 1) #8
  unreachable

59:                                               ; preds = %55
  %60 = call i32 @fork() #7
  %61 = icmp slt i32 %60, 0
  br i1 %61, label %62, label %64

62:                                               ; preds = %59
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %63 = call i32 @exit(i32 noundef 1) #8
  unreachable

64:                                               ; preds = %59
  %65 = icmp eq i32 %60, 0
  br i1 %65, label %66, label %73

66:                                               ; preds = %64
  %67 = call ptr @sbrk(i32 noundef 1048576000) #7
  %68 = icmp eq ptr %67, inttoptr (i32 -1 to ptr)
  br i1 %68, label %69, label %71

69:                                               ; preds = %66
  %70 = call i32 @exit(i32 noundef 0) #8
  unreachable

71:                                               ; preds = %66
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.269, ptr noundef %0, i32 noundef 1048576000) #7
  %72 = call i32 @exit(i32 noundef 1) #8
  unreachable

73:                                               ; preds = %64
  %74 = call i32 @wait(ptr noundef nonnull %2) #7
  %75 = load i32, ptr %2, align 4, !tbaa !7
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %79, label %77

77:                                               ; preds = %73
  %78 = call i32 @exit(i32 noundef 1) #8
  unreachable

79:                                               ; preds = %73
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5) #9
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %4) #9
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #9
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @sbrkarg(ptr noundef %0) #0 {
  %2 = tail call ptr @sbrk(i32 noundef 4096) #7
  %3 = tail call i32 @open(ptr noundef nonnull @.str.270, i32 noundef 513) #7
  %4 = tail call i32 @unlink(ptr noundef nonnull @.str.270) #7
  %5 = icmp slt i32 %3, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.271, ptr noundef %0) #7
  %7 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

8:                                                ; preds = %1
  %9 = tail call i32 @write(i32 noundef %3, ptr noundef %2, i32 noundef 4096) #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.272, ptr noundef %0) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = tail call i32 @close(i32 noundef %3) #7
  %15 = tail call ptr @sbrk(i32 noundef 4096) #7
  %16 = tail call i32 @pipe(ptr noundef %15) #7
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %20, label %18

18:                                               ; preds = %13
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.91, ptr noundef %0) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %13
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @validatetest(ptr noundef %0) #0 {
  br label %2

2:                                                ; preds = %5, %1
  %3 = phi i32 [ 0, %1 ], [ %9, %5 ]
  %4 = icmp samesign ult i32 %3, 1126401
  br i1 %4, label %5, label %12

5:                                                ; preds = %2
  %6 = inttoptr i32 %3 to ptr
  %7 = tail call i32 @link(ptr noundef nonnull @.str.273, ptr noundef %6) #7
  %8 = icmp eq i32 %7, -1
  %9 = add nuw nsw i32 %3, 4096
  br i1 %8, label %2, label %10, !llvm.loop !84

10:                                               ; preds = %5
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.274, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %2
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @bsstest(ptr noundef %0) #0 {
  br label %2

2:                                                ; preds = %5, %1
  %3 = phi i32 [ 0, %1 ], [ %9, %5 ]
  %4 = icmp eq i32 %3, 10000
  br i1 %4, label %12, label %5

5:                                                ; preds = %2
  %6 = getelementptr inbounds nuw [10000 x i8], ptr @uninit, i32 0, i32 %3
  %7 = load i8, ptr %6, align 1, !tbaa !14
  %8 = icmp eq i8 %7, 0
  %9 = add nuw nsw i32 %3, 1
  br i1 %8, label %2, label %10, !llvm.loop !85

10:                                               ; preds = %5
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.275, ptr noundef %0) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %2
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @bigargtest(ptr noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca [400 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %4 = tail call i32 @unlink(ptr noundef nonnull @.str.276) #7
  %5 = tail call i32 @fork() #7
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %21

7:                                                ; preds = %1
  call void @llvm.lifetime.start.p0(i64 400, ptr nonnull %3) #9
  %8 = call ptr @memset(ptr noundef nonnull %3, i32 noundef 32, i32 noundef 400) #7
  %9 = getelementptr inbounds nuw i8, ptr %3, i32 399
  store i8 0, ptr %9, align 1, !tbaa !14
  br label %10

10:                                               ; preds = %13, %7
  %11 = phi i32 [ 0, %7 ], [ %15, %13 ]
  %12 = icmp eq i32 %11, 31
  br i1 %12, label %16, label %13

13:                                               ; preds = %10
  %14 = getelementptr inbounds nuw [32 x ptr], ptr @bigargtest.args, i32 0, i32 %11
  store ptr %3, ptr %14, align 4, !tbaa !41
  %15 = add nuw nsw i32 %11, 1
  br label %10, !llvm.loop !86

16:                                               ; preds = %10
  store ptr null, ptr getelementptr inbounds nuw (i8, ptr @bigargtest.args, i32 124), align 4, !tbaa !41
  %17 = call i32 @exec(ptr noundef nonnull @.str.19, ptr noundef nonnull @bigargtest.args) #7
  %18 = call i32 @open(ptr noundef nonnull @.str.276, i32 noundef 512) #7
  %19 = call i32 @close(i32 noundef %18) #7
  %20 = call i32 @exit(i32 noundef 0) #8
  unreachable

21:                                               ; preds = %1
  %22 = icmp slt i32 %5, 0
  br i1 %22, label %23, label %25

23:                                               ; preds = %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.277, ptr noundef %0) #7
  %24 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

25:                                               ; preds = %21
  %26 = call i32 @wait(ptr noundef nonnull %2) #7
  %27 = load i32, ptr %2, align 4, !tbaa !7
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %31, label %29

29:                                               ; preds = %25
  %30 = call i32 @exit(i32 noundef %27) #8
  unreachable

31:                                               ; preds = %25
  %32 = call i32 @open(ptr noundef nonnull @.str.276, i32 noundef 0) #7
  %33 = icmp slt i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %31
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.278, ptr noundef %0) #7
  %35 = call i32 @exit(i32 noundef 1) #8
  unreachable

36:                                               ; preds = %31
  %37 = call i32 @close(i32 noundef %32) #7
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fsfull() local_unnamed_addr #0 {
  %1 = alloca [64 x i8], align 1
  %2 = alloca [64 x i8], align 1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.279) #7
  %3 = getelementptr inbounds nuw i8, ptr %1, i32 1
  %4 = getelementptr inbounds nuw i8, ptr %1, i32 2
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 3
  %6 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %7 = getelementptr inbounds nuw i8, ptr %1, i32 5
  br label %8

8:                                                ; preds = %48, %0
  %9 = phi i32 [ 0, %0 ], [ %32, %48 ]
  %10 = phi i32 [ 0, %0 ], [ %49, %48 ]
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %1) #9
  store i8 102, ptr %1, align 1, !tbaa !14
  %11 = freeze i32 %10
  %12 = udiv i32 %11, 1000
  %13 = trunc i32 %12 to i8
  %14 = add i8 %13, 48
  store i8 %14, ptr %3, align 1, !tbaa !14
  %15 = mul i32 %12, 1000
  %16 = sub i32 %11, %15
  %17 = trunc nuw nsw i32 %16 to i16
  %18 = udiv i16 %17, 100
  %19 = trunc nuw nsw i16 %18 to i8
  %20 = or disjoint i8 %19, 48
  store i8 %20, ptr %4, align 1, !tbaa !14
  %21 = urem i32 %10, 100
  %22 = trunc nuw nsw i32 %21 to i8
  %23 = udiv i8 %22, 10
  %24 = or disjoint i8 %23, 48
  store i8 %24, ptr %5, align 1, !tbaa !14
  %25 = urem i32 %10, 10
  %26 = trunc nuw nsw i32 %25 to i8
  %27 = or disjoint i8 %26, 48
  store i8 %27, ptr %6, align 1, !tbaa !14
  store i8 0, ptr %7, align 1, !tbaa !14
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.280, ptr noundef nonnull %1) #7
  %28 = call i32 @open(ptr noundef nonnull %1, i32 noundef 514) #7
  %29 = icmp slt i32 %28, 0
  br i1 %29, label %30, label %31

30:                                               ; preds = %8
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.281, ptr noundef nonnull %1) #7
  br label %41

31:                                               ; preds = %8, %31
  %32 = phi i32 [ %37, %31 ], [ %9, %8 ]
  %33 = phi i32 [ %36, %31 ], [ 0, %8 ]
  %34 = call i32 @write(i32 noundef %28, ptr noundef nonnull @buf, i32 noundef 1024) #7
  %35 = icmp slt i32 %34, 1024
  %36 = add nuw nsw i32 %34, %33
  %37 = add nsw i32 %32, 1
  br i1 %35, label %38, label %31

38:                                               ; preds = %31
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.282, i32 noundef %33) #7
  %39 = call i32 @close(i32 noundef %28) #7
  %40 = icmp eq i32 %33, 0
  br i1 %40, label %41, label %48

41:                                               ; preds = %38, %30
  %42 = phi i32 [ %9, %30 ], [ %32, %38 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %1) #9
  %43 = getelementptr inbounds nuw i8, ptr %2, i32 1
  %44 = getelementptr inbounds nuw i8, ptr %2, i32 2
  %45 = getelementptr inbounds nuw i8, ptr %2, i32 3
  %46 = getelementptr inbounds nuw i8, ptr %2, i32 4
  %47 = getelementptr inbounds nuw i8, ptr %2, i32 5
  br label %50

48:                                               ; preds = %38
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %1) #9
  %49 = add nuw nsw i32 %10, 1
  br label %8, !llvm.loop !87

50:                                               ; preds = %41, %53
  %51 = phi i32 [ %10, %41 ], [ %72, %53 ]
  %52 = icmp sgt i32 %51, -1
  br i1 %52, label %53, label %73

53:                                               ; preds = %50
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #9
  store i8 102, ptr %2, align 1, !tbaa !14
  %54 = freeze i32 %51
  %55 = udiv i32 %54, 1000
  %56 = trunc i32 %55 to i8
  %57 = add i8 %56, 48
  store i8 %57, ptr %43, align 1, !tbaa !14
  %58 = mul i32 %55, 1000
  %59 = sub i32 %54, %58
  %60 = trunc nuw nsw i32 %59 to i16
  %61 = udiv i16 %60, 100
  %62 = trunc nuw nsw i16 %61 to i8
  %63 = or disjoint i8 %62, 48
  store i8 %63, ptr %44, align 1, !tbaa !14
  %64 = urem i32 %51, 100
  %65 = trunc nuw nsw i32 %64 to i8
  %66 = udiv i8 %65, 10
  %67 = or disjoint i8 %66, 48
  store i8 %67, ptr %45, align 1, !tbaa !14
  %68 = urem i32 %51, 10
  %69 = trunc nuw nsw i32 %68 to i8
  %70 = or disjoint i8 %69, 48
  store i8 %70, ptr %46, align 1, !tbaa !14
  store i8 0, ptr %47, align 1, !tbaa !14
  %71 = call i32 @unlink(ptr noundef nonnull %2) #7
  %72 = add nsw i32 %51, -1
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #9
  br label %50, !llvm.loop !88

73:                                               ; preds = %50
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.283, i32 noundef %42) #7
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @argptest(ptr noundef %0) #0 {
  %2 = tail call i32 @open(ptr noundef nonnull @.str.284, i32 noundef 0) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.40, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call ptr @sbrk(i32 noundef 0) #7
  %8 = getelementptr inbounds i8, ptr %7, i32 -1
  %9 = tail call i32 @read(i32 noundef %2, ptr noundef nonnull %8, i32 noundef -1) #7
  %10 = tail call i32 @close(i32 noundef %2) #7
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @stacktest(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %3 = tail call i32 @fork() #7
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %9

5:                                                ; preds = %1
  %6 = load i8, ptr inttoptr (i32 -4096 to ptr), align 4096, !tbaa !14
  %7 = sext i8 %6 to i32
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.285, ptr noundef %0, i32 noundef %7) #7
  %8 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

9:                                                ; preds = %1
  %10 = icmp slt i32 %3, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %9
  %14 = call i32 @wait(ptr noundef nonnull %2) #7
  %15 = load i32, ptr %2, align 4, !tbaa !7
  %16 = icmp eq i32 %15, -1
  br i1 %16, label %17, label %19

17:                                               ; preds = %13
  %18 = call i32 @exit(i32 noundef 0) #8
  unreachable

19:                                               ; preds = %13
  %20 = call i32 @exit(i32 noundef %15) #8
  unreachable
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @nowrite(ptr noundef %0) #5 {
  %2 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  br label %3

3:                                                ; preds = %26, %1
  %4 = phi i32 [ 0, %1 ], [ %27, %26 ]
  %5 = icmp eq i32 %4, 6
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = call i32 @exit(i32 noundef 0) #8
  unreachable

8:                                                ; preds = %3
  %9 = call i32 @fork() #7
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %16

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw [6 x i32], ptr @__const.nowrite.addrs, i32 0, i32 %4
  %13 = load i32, ptr %12, align 4, !tbaa !3
  %14 = inttoptr i32 %13 to ptr
  store volatile i32 10, ptr %14, align 4, !tbaa !7
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.286, ptr noundef %0, ptr noundef nonnull %14) #7
  %15 = call i32 @exit(i32 noundef 0) #8
  unreachable

16:                                               ; preds = %8
  %17 = icmp slt i32 %9, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %16
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.39, ptr noundef %0) #7
  %19 = call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %16
  %21 = call i32 @wait(ptr noundef nonnull %2) #7
  %22 = load i32, ptr %2, align 4, !tbaa !7
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %26

24:                                               ; preds = %20
  %25 = call i32 @exit(i32 noundef 1) #8
  unreachable

26:                                               ; preds = %20
  %27 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !89
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @pgbug(ptr readnone captures(none) %0) #5 {
  %2 = alloca [1 x ptr], align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  store ptr null, ptr %2, align 4, !tbaa !41
  %3 = load ptr, ptr @big, align 4, !tbaa !90
  %4 = call i32 @exec(ptr noundef %3, ptr noundef nonnull %2) #7
  %5 = load ptr, ptr @big, align 4, !tbaa !90
  %6 = call i32 @pipe(ptr noundef %5) #7
  %7 = call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @sbrkbugs(ptr readnone captures(none) %0) #5 {
  %2 = tail call i32 @fork() #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = icmp eq i32 %2, 0
  br i1 %7, label %8, label %14

8:                                                ; preds = %6
  %9 = tail call ptr @sbrk(i32 noundef 0) #7
  %10 = ptrtoint ptr %9 to i32
  %11 = sub nsw i32 0, %10
  %12 = tail call ptr @sbrk(i32 noundef %11) #7
  %13 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

14:                                               ; preds = %6
  %15 = tail call i32 @wait(ptr noundef null) #7
  %16 = tail call i32 @fork() #7
  %17 = icmp slt i32 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %14
  %21 = icmp eq i32 %16, 0
  br i1 %21, label %22, label %28

22:                                               ; preds = %20
  %23 = tail call ptr @sbrk(i32 noundef 0) #7
  %24 = ptrtoint ptr %23 to i32
  %25 = sub nsw i32 3500, %24
  %26 = tail call ptr @sbrk(i32 noundef %25) #7
  %27 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

28:                                               ; preds = %20
  %29 = tail call i32 @wait(ptr noundef null) #7
  %30 = tail call i32 @fork() #7
  %31 = icmp slt i32 %30, 0
  br i1 %31, label %32, label %34

32:                                               ; preds = %28
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %33 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

34:                                               ; preds = %28
  %35 = icmp eq i32 %30, 0
  br i1 %35, label %36, label %43

36:                                               ; preds = %34
  %37 = tail call ptr @sbrk(i32 noundef 0) #7
  %38 = ptrtoint ptr %37 to i32
  %39 = sub i32 43008, %38
  %40 = tail call ptr @sbrk(i32 noundef %39) #7
  %41 = tail call ptr @sbrk(i32 noundef -10) #7
  %42 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

43:                                               ; preds = %34
  %44 = tail call i32 @wait(ptr noundef null) #7
  %45 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @sbrklast(ptr readnone captures(none) %0) #0 {
  %2 = tail call ptr @sbrk(i32 noundef 0) #7
  %3 = ptrtoint ptr %2 to i32
  %4 = and i32 %3, 4095
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %1
  %7 = sub nuw nsw i32 4096, %4
  %8 = tail call ptr @sbrk(i32 noundef %7) #7
  br label %9

9:                                                ; preds = %6, %1
  %10 = tail call ptr @sbrk(i32 noundef 4096) #7
  %11 = tail call ptr @sbrk(i32 noundef 10) #7
  %12 = tail call ptr @sbrk(i32 noundef -20) #7
  %13 = tail call ptr @sbrk(i32 noundef 0) #7
  %14 = ptrtoint ptr %13 to i32
  %15 = add i32 %14, -64
  %16 = inttoptr i32 %15 to ptr
  store i8 120, ptr %16, align 1, !tbaa !14
  %17 = getelementptr inbounds nuw i8, ptr %16, i32 1
  store i8 0, ptr %17, align 1, !tbaa !14
  %18 = tail call i32 @open(ptr noundef nonnull %16, i32 noundef 514) #7
  %19 = tail call i32 @write(i32 noundef %18, ptr noundef nonnull %16, i32 noundef 1) #7
  %20 = tail call i32 @close(i32 noundef %18) #7
  %21 = tail call i32 @open(ptr noundef nonnull %16, i32 noundef 2) #7
  store i8 0, ptr %16, align 1, !tbaa !14
  %22 = tail call i32 @read(i32 noundef %21, ptr noundef nonnull %16, i32 noundef 1) #7
  %23 = load i8, ptr %16, align 1, !tbaa !14
  %24 = icmp eq i8 %23, 120
  br i1 %24, label %27, label %25

25:                                               ; preds = %9
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @sbrk8000(ptr readnone captures(none) %0) #0 {
  %2 = tail call ptr @sbrk(i32 noundef -2147483644) #7
  %3 = tail call ptr @sbrk(i32 noundef 0) #7
  %4 = getelementptr inbounds i8, ptr %3, i32 -1
  %5 = load volatile i8, ptr %4, align 1, !tbaa !14
  %6 = add i8 %5, 1
  store volatile i8 %6, ptr %4, align 1, !tbaa !14
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @badarg(ptr readnone captures(none) %0) #5 {
  %2 = alloca [2 x ptr], align 4
  %3 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %4

4:                                                ; preds = %9, %1
  %5 = phi i32 [ 0, %1 ], [ %11, %9 ]
  %6 = icmp eq i32 %5, 50000
  br i1 %6, label %7, label %9

7:                                                ; preds = %4
  %8 = call i32 @exit(i32 noundef 0) #8
  unreachable

9:                                                ; preds = %4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #9
  store ptr inttoptr (i32 -1 to ptr), ptr %2, align 4, !tbaa !41
  store ptr null, ptr %3, align 4, !tbaa !41
  %10 = call i32 @exec(ptr noundef nonnull @.str.19, ptr noundef nonnull %2) #7
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #9
  %11 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !91
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @lazy_alloc(ptr readnone captures(none) %0) #5 {
  %2 = tail call ptr @sbrklazy(i32 noundef 1073741824) #7
  %3 = icmp eq ptr %2, inttoptr (i32 -1 to ptr)
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.287) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1, %9
  %7 = phi i32 [ %11, %9 ], [ 4096, %1 ]
  %8 = icmp samesign ult i32 %7, 1073741824
  br i1 %8, label %9, label %12

9:                                                ; preds = %6
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 %7
  store ptr %10, ptr %10, align 4, !tbaa !41
  %11 = add nuw nsw i32 %7, 262144
  br label %6, !llvm.loop !92

12:                                               ; preds = %6, %15
  %13 = phi i32 [ %19, %15 ], [ 4096, %6 ]
  %14 = icmp samesign ult i32 %13, 1073741824
  br i1 %14, label %15, label %22

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw i8, ptr %2, i32 %13
  %17 = load ptr, ptr %16, align 4, !tbaa !41
  %18 = icmp eq ptr %17, %16
  %19 = add nuw nsw i32 %13, 262144
  br i1 %18, label %12, label %20, !llvm.loop !93

20:                                               ; preds = %15
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.288) #7
  %21 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

22:                                               ; preds = %12
  %23 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize optsize
declare dso_local ptr @sbrklazy(i32 noundef) local_unnamed_addr #3

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @lazy_unmap(ptr readnone captures(none) %0) #5 {
  %2 = alloca i32, align 4
  %3 = tail call ptr @sbrklazy(i32 noundef 1073741824) #7
  %4 = icmp eq ptr %3, inttoptr (i32 -1 to ptr)
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.287) #7
  %6 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

7:                                                ; preds = %1, %10
  %8 = phi i32 [ %12, %10 ], [ 4096, %1 ]
  %9 = icmp samesign ult i32 %8, 1073741824
  br i1 %9, label %10, label %13

10:                                               ; preds = %7
  %11 = getelementptr inbounds nuw i8, ptr %3, i32 %8
  store ptr %11, ptr %11, align 4, !tbaa !41
  %12 = add nuw nsw i32 %8, 16777216
  br label %7, !llvm.loop !94

13:                                               ; preds = %7, %33
  %14 = phi i32 [ %34, %33 ], [ 4096, %7 ]
  %15 = icmp samesign ult i32 %14, 1073741824
  br i1 %15, label %16, label %35

16:                                               ; preds = %13
  %17 = call i32 @fork() #7
  %18 = icmp slt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.289) #7
  %20 = call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  %22 = icmp eq i32 %17, 0
  br i1 %22, label %23, label %27

23:                                               ; preds = %21
  %24 = getelementptr inbounds nuw i8, ptr %3, i32 %14
  %25 = call ptr @sbrklazy(i32 noundef -1073741824) #7
  store ptr %24, ptr %24, align 4, !tbaa !41
  %26 = call i32 @exit(i32 noundef 0) #8
  unreachable

27:                                               ; preds = %21
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #9
  %28 = call i32 @wait(ptr noundef nonnull %2) #7
  %29 = load i32, ptr %2, align 4, !tbaa !7
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %31, label %33

31:                                               ; preds = %27
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.290) #7
  %32 = call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %27
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #9
  %34 = add nuw nsw i32 %14, 16777216
  br label %13, !llvm.loop !95

35:                                               ; preds = %13
  %36 = call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @lazy_copy(ptr readnone captures(none) %0) #5 {
  %2 = tail call ptr @sbrk(i32 noundef 0) #7
  %3 = tail call ptr @sbrklazy(i32 noundef 16384) #7
  %4 = getelementptr inbounds nuw i8, ptr %2, i32 8192
  %5 = tail call i32 @open(ptr noundef nonnull %4, i32 noundef 0) #7
  %6 = tail call ptr @sbrk(i32 noundef 0) #7
  %7 = ptrtoint ptr %6 to i32
  %8 = xor i32 %7, -1
  %9 = tail call ptr @sbrk(i32 noundef %8) #7
  %10 = icmp eq ptr %9, %6
  br i1 %10, label %13, label %11

11:                                               ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.291, ptr noundef %9) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %1, %42
  %14 = phi i32 [ %44, %42 ], [ 0, %1 ]
  %15 = icmp eq i32 %14, 6
  br i1 %15, label %16, label %18

16:                                               ; preds = %13
  %17 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

18:                                               ; preds = %13
  %19 = tail call i32 @open(ptr noundef nonnull @.str.6, i32 noundef 0) #7
  %20 = icmp slt i32 %19, 0
  br i1 %20, label %21, label %23

21:                                               ; preds = %18
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.292) #7
  %22 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

23:                                               ; preds = %18
  %24 = getelementptr inbounds nuw [6 x i32], ptr @__const.lazy_copy.bad, i32 0, i32 %14
  %25 = load i32, ptr %24, align 4, !tbaa !3
  %26 = inttoptr i32 %25 to ptr
  %27 = tail call i32 @read(i32 noundef %19, ptr noundef %26, i32 noundef 512) #7
  %28 = icmp sgt i32 %27, -1
  br i1 %28, label %29, label %31

29:                                               ; preds = %23
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.293) #7
  %30 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

31:                                               ; preds = %23
  %32 = tail call i32 @close(i32 noundef %19) #7
  %33 = tail call i32 @open(ptr noundef nonnull @.str.294, i32 noundef 1538) #7
  %34 = icmp slt i32 %33, 0
  br i1 %34, label %35, label %37

35:                                               ; preds = %31
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.295) #7
  %36 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

37:                                               ; preds = %31
  %38 = tail call i32 @write(i32 noundef %33, ptr noundef %26, i32 noundef 512) #7
  %39 = icmp sgt i32 %38, -1
  br i1 %39, label %40, label %42

40:                                               ; preds = %37
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.296) #7
  %41 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

42:                                               ; preds = %37
  %43 = tail call i32 @close(i32 noundef %33) #7
  %44 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !96
}

; Function Attrs: minsize nounwind optsize
define dso_local void @lazy_copyinstr(ptr noundef %0) #0 {
  %2 = alloca %struct.stat, align 4
  %3 = tail call ptr @sbrk(i32 noundef 0) #7
  %4 = ptrtoint ptr %3 to i32
  %5 = and i32 %4, 4095
  %6 = sub nuw nsw i32 4096, %5
  %7 = tail call ptr @sbrk(i32 noundef %6) #7
  %8 = tail call ptr @sbrk(i32 noundef 0) #7
  %9 = ptrtoint ptr %8 to i32
  %10 = and i32 %9, 4095
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %14, label %12

12:                                               ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.297, ptr noundef %0) #7
  %13 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

14:                                               ; preds = %1
  %15 = tail call ptr @sbrklazy(i32 noundef 8192) #7
  %16 = getelementptr inbounds nuw i8, ptr %8, i32 4095
  store i8 47, ptr %16, align 1, !tbaa !14
  %17 = tail call i32 @open(ptr noundef nonnull %16, i32 noundef 0) #7
  %18 = icmp slt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.298) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %14
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #9
  %22 = call i32 @fstat(i32 noundef %17, ptr noundef nonnull %2) #7
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %24, label %26

24:                                               ; preds = %21
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.299) #7
  %25 = call i32 @exit(i32 noundef 1) #8
  unreachable

26:                                               ; preds = %21
  %27 = getelementptr inbounds nuw i8, ptr %2, i32 8
  %28 = load i16, ptr %27, align 4, !tbaa !97
  %29 = icmp eq i16 %28, 1
  br i1 %29, label %32, label %30

30:                                               ; preds = %26
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.300) #7
  %31 = call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %26
  %33 = call i32 @close(i32 noundef %17) #7
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i32 @fstat(i32 noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @lazy_sbrk(ptr readnone captures(none) %0) #5 {
  %2 = tail call ptr @sbrk(i32 noundef 0) #7
  br label %3

3:                                                ; preds = %6, %1
  %4 = phi ptr [ %2, %1 ], [ %8, %6 ]
  %5 = icmp ult ptr %4, inttoptr (i32 1073741824 to ptr)
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  %7 = tail call ptr @sbrklazy(i32 noundef 1073741824) #7
  %8 = tail call ptr @sbrklazy(i32 noundef 0) #7
  br label %3, !llvm.loop !99

9:                                                ; preds = %3
  %10 = ptrtoint ptr %4 to i32
  %11 = sub i32 2147471360, %10
  %12 = tail call ptr @sbrklazy(i32 noundef %11) #7
  %13 = icmp eq ptr %12, %4
  br i1 %13, label %16, label %14

14:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.302, i32 noundef %11, ptr noundef %12, ptr noundef %4) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %9
  %17 = tail call ptr @sbrk(i32 noundef 4096) #7
  %18 = icmp eq ptr %17, inttoptr (i32 2147471360 to ptr)
  br i1 %18, label %21, label %19

19:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.303, i32 noundef 4096, ptr noundef %17) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  store i8 1, ptr %17, align 1, !tbaa !14
  %22 = getelementptr inbounds nuw i8, ptr %17, i32 1
  %23 = load i8, ptr %22, align 1, !tbaa !14
  %24 = icmp eq i8 %23, 0
  br i1 %24, label %27, label %25

25:                                               ; preds = %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.304) #7
  %26 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %21
  %28 = tail call ptr @sbrk(i32 noundef 1) #7
  %29 = icmp eq ptr %28, inttoptr (i32 -1 to ptr)
  br i1 %29, label %32, label %30

30:                                               ; preds = %27
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.305, ptr noundef %28) #7
  %31 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %27
  %33 = tail call ptr @sbrklazy(i32 noundef 1) #7
  %34 = icmp eq ptr %33, inttoptr (i32 -1 to ptr)
  br i1 %34, label %37, label %35

35:                                               ; preds = %32
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.306, ptr noundef %33) #7
  %36 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

37:                                               ; preds = %32
  %38 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize nounwind optsize
define dso_local void @partial_write(ptr noundef %0) #0 {
  %2 = alloca i8, align 1
  %3 = alloca [1024 x i8], align 1
  %4 = tail call i32 @unlink(ptr noundef nonnull @.str.307) #7
  %5 = tail call i32 @open(ptr noundef nonnull @.str.307, i32 noundef 514) #7
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %7, label %9

7:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.308, ptr noundef %0) #7
  %8 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

9:                                                ; preds = %1
  %10 = tail call i32 @write(i32 noundef %5, ptr noundef nonnull @.str.309, i32 noundef 1) #7
  %11 = icmp eq i32 %10, 1
  br i1 %11, label %14, label %12

12:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.310, ptr noundef %0) #7
  %13 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

14:                                               ; preds = %9
  %15 = tail call i32 @close(i32 noundef %5) #7
  %16 = tail call i32 @open(ptr noundef nonnull @.str.307, i32 noundef 2) #7
  %17 = icmp slt i32 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %14
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.311, ptr noundef %0) #7
  %19 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

20:                                               ; preds = %14
  %21 = tail call ptr @sbrk(i32 noundef 0) #7
  %22 = ptrtoint ptr %21 to i32
  %23 = and i32 %22, 4095
  %24 = sub nuw nsw i32 4096, %23
  %25 = tail call ptr @sbrk(i32 noundef %24) #7
  %26 = tail call ptr @sbrk(i32 noundef 0) #7
  %27 = ptrtoint ptr %26 to i32
  %28 = and i32 %27, 4095
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %32, label %30

30:                                               ; preds = %20
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.297, ptr noundef %0) #7
  %31 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

32:                                               ; preds = %20
  %33 = getelementptr inbounds i8, ptr %26, i32 -1
  store i8 88, ptr %33, align 1, !tbaa !14
  %34 = tail call i32 @write(i32 noundef %16, ptr noundef nonnull %33, i32 noundef 2) #7
  %35 = icmp eq i32 %34, -1
  br i1 %35, label %38, label %36

36:                                               ; preds = %32
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.312, ptr noundef %0) #7
  %37 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

38:                                               ; preds = %32
  %39 = tail call i32 @close(i32 noundef %16) #7
  %40 = tail call i32 @open(ptr noundef nonnull @.str.307, i32 noundef 0) #7
  %41 = icmp slt i32 %40, 0
  br i1 %41, label %42, label %44

42:                                               ; preds = %38
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.311, ptr noundef %0) #7
  %43 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

44:                                               ; preds = %38
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %2) #9
  %45 = call i32 @read(i32 noundef %40, ptr noundef nonnull %2, i32 noundef 1) #7
  %46 = icmp eq i32 %45, 1
  br i1 %46, label %49, label %47

47:                                               ; preds = %44
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.313, ptr noundef %0) #7
  %48 = call i32 @exit(i32 noundef 1) #8
  unreachable

49:                                               ; preds = %44
  %50 = call i32 @close(i32 noundef %40) #7
  %51 = load i8, ptr %2, align 1, !tbaa !14
  %52 = icmp eq i8 %51, 88
  br i1 %52, label %56, label %53

53:                                               ; preds = %49
  %54 = sext i8 %51 to i32
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.314, ptr noundef %0, i32 noundef %54) #7
  %55 = call i32 @exit(i32 noundef 1) #8
  unreachable

56:                                               ; preds = %49
  %57 = call i32 @open(ptr noundef nonnull @.str.315, i32 noundef 514) #7
  br label %58

58:                                               ; preds = %72, %56
  %59 = phi i32 [ 0, %56 ], [ %73, %72 ]
  %60 = icmp eq i32 %59, 64
  br i1 %60, label %61, label %66

61:                                               ; preds = %58
  %62 = call i32 @close(i32 noundef %57) #7
  %63 = call i32 @unlink(ptr noundef nonnull @.str.315) #7
  %64 = call i32 @open(ptr noundef nonnull @.str.307, i32 noundef 0) #7
  %65 = icmp slt i32 %64, 0
  br i1 %65, label %74, label %76

66:                                               ; preds = %58
  call void @llvm.lifetime.start.p0(i64 1024, ptr nonnull %3) #9
  %67 = call ptr @memset(ptr noundef nonnull %3, i32 noundef 0, i32 noundef 1024) #7
  %68 = call i32 @write(i32 noundef %57, ptr noundef nonnull %3, i32 noundef 1024) #7
  %69 = icmp eq i32 %68, 1024
  br i1 %69, label %72, label %70

70:                                               ; preds = %66
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.316, ptr noundef %0) #7
  %71 = call i32 @exit(i32 noundef -1) #8
  unreachable

72:                                               ; preds = %66
  call void @llvm.lifetime.end.p0(i64 1024, ptr nonnull %3) #9
  %73 = add nuw nsw i32 %59, 1
  br label %58, !llvm.loop !100

74:                                               ; preds = %61
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.311, ptr noundef %0) #7
  %75 = call i32 @exit(i32 noundef 1) #8
  unreachable

76:                                               ; preds = %61
  %77 = call i32 @read(i32 noundef %64, ptr noundef nonnull %2, i32 noundef 1) #7
  %78 = icmp eq i32 %77, 1
  br i1 %78, label %81, label %79

79:                                               ; preds = %76
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.313, ptr noundef %0) #7
  %80 = call i32 @exit(i32 noundef 1) #8
  unreachable

81:                                               ; preds = %76
  %82 = call i32 @close(i32 noundef %64) #7
  %83 = load i8, ptr %2, align 1, !tbaa !14
  %84 = icmp eq i8 %83, 88
  br i1 %84, label %88, label %85

85:                                               ; preds = %81
  %86 = sext i8 %83 to i32
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.314, ptr noundef %0, i32 noundef %86) #7
  %87 = call i32 @exit(i32 noundef 1) #8
  unreachable

88:                                               ; preds = %81
  %89 = call i32 @unlink(ptr noundef nonnull @.str.307) #7
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @unlinkcwd(ptr noundef %0) #0 {
  %2 = tail call i32 @mkdir(ptr noundef nonnull @.str.317) #7
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %4, label %6

4:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.318, ptr noundef %0) #7
  %5 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

6:                                                ; preds = %1
  %7 = tail call i32 @mkdir(ptr noundef nonnull @.str.319) #7
  %8 = icmp slt i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %6
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.320, ptr noundef %0) #7
  %10 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

11:                                               ; preds = %6
  %12 = tail call i32 @chdir(ptr noundef nonnull @.str.319) #7
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.321, ptr noundef %0) #7
  %15 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

16:                                               ; preds = %11
  %17 = tail call i32 @unlink(ptr noundef nonnull @.str.319) #7
  %18 = icmp slt i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.322, ptr noundef %0) #7
  %20 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

21:                                               ; preds = %16
  %22 = tail call i32 @unlink(ptr noundef nonnull @.str.317) #7
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %24, label %26

24:                                               ; preds = %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.323, ptr noundef %0) #7
  %25 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

26:                                               ; preds = %21
  %27 = tail call i32 @open(ptr noundef nonnull @.str.324, i32 noundef 0) #7
  %28 = icmp sgt i32 %27, 0
  br i1 %28, label %29, label %30

29:                                               ; preds = %26
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.325, ptr noundef %0) #7
  br label %30

30:                                               ; preds = %29, %26
  %31 = tail call i32 @open(ptr noundef nonnull @.str.326, i32 noundef 512) #7
  %32 = icmp sgt i32 %31, 0
  br i1 %32, label %33, label %34

33:                                               ; preds = %30
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.327, ptr noundef %0) #7
  br label %34

34:                                               ; preds = %33, %30
  ret void
}

; Function Attrs: minsize nounwind optsize
define dso_local void @bigdir(ptr noundef %0) #0 {
  %2 = alloca [10 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %2) #9
  %3 = tail call i32 @unlink(ptr noundef nonnull @.str.389) #7
  %4 = tail call i32 @open(ptr noundef nonnull @.str.389, i32 noundef 512) #7
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %1
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.390, ptr noundef %0) #7
  %7 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

8:                                                ; preds = %1
  %9 = tail call i32 @close(i32 noundef %4) #7
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 1
  %11 = getelementptr inbounds nuw i8, ptr %2, i32 2
  %12 = getelementptr inbounds nuw i8, ptr %2, i32 3
  br label %13

13:                                               ; preds = %27, %8
  %14 = phi i32 [ 0, %8 ], [ %28, %27 ]
  %15 = icmp eq i32 %14, 500
  br i1 %15, label %29, label %16

16:                                               ; preds = %13
  store i8 120, ptr %2, align 1, !tbaa !14
  %17 = lshr i32 %14, 6
  %18 = trunc nuw nsw i32 %17 to i8
  %19 = or disjoint i8 %18, 48
  store i8 %19, ptr %10, align 1, !tbaa !14
  %20 = trunc i32 %14 to i8
  %21 = and i8 %20, 63
  %22 = add nuw nsw i8 %21, 48
  store i8 %22, ptr %11, align 1, !tbaa !14
  store i8 0, ptr %12, align 1, !tbaa !14
  %23 = call i32 @link(ptr noundef nonnull @.str.389, ptr noundef nonnull %2) #7
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %27, label %25

25:                                               ; preds = %16
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.391, ptr noundef %0, i32 noundef %14, ptr noundef nonnull %2) #7
  %26 = call i32 @exit(i32 noundef 1) #8
  unreachable

27:                                               ; preds = %16
  %28 = add nuw nsw i32 %14, 1
  br label %13, !llvm.loop !101

29:                                               ; preds = %13
  %30 = call i32 @unlink(ptr noundef nonnull @.str.389) #7
  br label %31

31:                                               ; preds = %34, %29
  %32 = phi i32 [ 0, %29 ], [ %43, %34 ]
  %33 = icmp eq i32 %32, 500
  br i1 %33, label %46, label %34

34:                                               ; preds = %31
  store i8 120, ptr %2, align 1, !tbaa !14
  %35 = lshr i32 %32, 6
  %36 = trunc nuw nsw i32 %35 to i8
  %37 = or disjoint i8 %36, 48
  store i8 %37, ptr %10, align 1, !tbaa !14
  %38 = trunc i32 %32 to i8
  %39 = and i8 %38, 63
  %40 = add nuw nsw i8 %39, 48
  store i8 %40, ptr %11, align 1, !tbaa !14
  store i8 0, ptr %12, align 1, !tbaa !14
  %41 = call i32 @unlink(ptr noundef nonnull %2) #7
  %42 = icmp eq i32 %41, 0
  %43 = add nuw nsw i32 %32, 1
  br i1 %42, label %31, label %44, !llvm.loop !102

44:                                               ; preds = %34
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.392, ptr noundef %0) #7
  %45 = call i32 @exit(i32 noundef 1) #8
  unreachable

46:                                               ; preds = %31
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %2) #9
  ret void
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @manywrites(ptr noundef %0) #5 {
  %2 = alloca [3 x i8], align 1
  %3 = alloca i32, align 4
  br label %4

4:                                                ; preds = %46, %1
  %5 = phi i32 [ %48, %46 ], [ 1, %1 ]
  %6 = phi i32 [ %47, %46 ], [ 0, %1 ]
  %7 = icmp eq i32 %6, 4
  br i1 %7, label %49, label %8

8:                                                ; preds = %4
  %9 = tail call i32 @fork() #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = icmp eq i32 %9, 0
  br i1 %14, label %15, label %46

15:                                               ; preds = %13
  call void @llvm.lifetime.start.p0(i64 3, ptr nonnull %2) #9
  store i8 98, ptr %2, align 1, !tbaa !14
  %16 = trunc nuw nsw i32 %6 to i8
  %17 = add nuw nsw i8 %16, 97
  %18 = getelementptr inbounds nuw i8, ptr %2, i32 1
  store i8 %17, ptr %18, align 1, !tbaa !14
  %19 = getelementptr inbounds nuw i8, ptr %2, i32 2
  store i8 0, ptr %19, align 1, !tbaa !14
  %20 = call i32 @unlink(ptr noundef nonnull %2) #7
  br label %21

21:                                               ; preds = %30, %15
  %22 = phi i32 [ 0, %15 ], [ %32, %30 ]
  %23 = icmp eq i32 %22, 30
  br i1 %23, label %24, label %27

24:                                               ; preds = %21
  %25 = call i32 @unlink(ptr noundef nonnull %2) #7
  %26 = call i32 @exit(i32 noundef 0) #8
  unreachable

27:                                               ; preds = %21, %43
  %28 = phi i32 [ %45, %43 ], [ 0, %21 ]
  %29 = icmp eq i32 %28, %5
  br i1 %29, label %30, label %33

30:                                               ; preds = %27
  %31 = call i32 @unlink(ptr noundef nonnull %2) #7
  %32 = add nuw nsw i32 %22, 1
  br label %21, !llvm.loop !103

33:                                               ; preds = %27
  %34 = call i32 @open(ptr noundef nonnull %2, i32 noundef 514) #7
  %35 = icmp slt i32 %34, 0
  br i1 %35, label %36, label %38

36:                                               ; preds = %33
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.393, ptr noundef %0, ptr noundef nonnull %2) #7
  %37 = call i32 @exit(i32 noundef 1) #8
  unreachable

38:                                               ; preds = %33
  %39 = call i32 @write(i32 noundef %34, ptr noundef nonnull @buf, i32 noundef 12288) #7
  %40 = icmp eq i32 %39, 12288
  br i1 %40, label %43, label %41

41:                                               ; preds = %38
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.202, ptr noundef %0, i32 noundef 12288, i32 noundef %39) #7
  %42 = call i32 @exit(i32 noundef 1) #8
  unreachable

43:                                               ; preds = %38
  %44 = call i32 @close(i32 noundef %34) #7
  %45 = add nuw nsw i32 %28, 1
  br label %27, !llvm.loop !104

46:                                               ; preds = %13
  %47 = add nuw nsw i32 %6, 1
  %48 = add nuw nsw i32 %5, 1
  br label %4, !llvm.loop !105

49:                                               ; preds = %4, %60
  %50 = phi i32 [ %61, %60 ], [ 0, %4 ]
  %51 = icmp eq i32 %50, 4
  br i1 %51, label %52, label %54

52:                                               ; preds = %49
  %53 = call i32 @exit(i32 noundef 0) #8
  unreachable

54:                                               ; preds = %49
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  store i32 0, ptr %3, align 4, !tbaa !7
  %55 = call i32 @wait(ptr noundef nonnull %3) #7
  %56 = load i32, ptr %3, align 4, !tbaa !7
  %57 = icmp eq i32 %56, 0
  br i1 %57, label %60, label %58

58:                                               ; preds = %54
  %59 = call i32 @exit(i32 noundef %56) #8
  unreachable

60:                                               ; preds = %54
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  %61 = add nuw nsw i32 %50, 1
  br label %49, !llvm.loop !106
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @badwrite(ptr readnone captures(none) %0) #5 {
  %2 = tail call i32 @unlink(ptr noundef nonnull @.str.294) #7
  br label %3

3:                                                ; preds = %12, %1
  %4 = phi i32 [ 0, %1 ], [ %16, %12 ]
  %5 = icmp eq i32 %4, 600
  %6 = tail call i32 @open(ptr noundef nonnull @.str.294, i32 noundef 513) #7
  %7 = icmp slt i32 %6, 0
  br i1 %5, label %8, label %9

8:                                                ; preds = %3
  br i1 %7, label %17, label %19

9:                                                ; preds = %3
  br i1 %7, label %10, label %12

10:                                               ; preds = %9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.394) #7
  %11 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %9
  %13 = tail call i32 @write(i32 noundef %6, ptr noundef nonnull inttoptr (i32 -1 to ptr), i32 noundef 1) #7
  %14 = tail call i32 @close(i32 noundef %6) #7
  %15 = tail call i32 @unlink(ptr noundef nonnull @.str.294) #7
  %16 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !107

17:                                               ; preds = %8
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.394) #7
  %18 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

19:                                               ; preds = %8
  %20 = tail call i32 @write(i32 noundef %6, ptr noundef nonnull @.str.9, i32 noundef 1) #7
  %21 = icmp eq i32 %20, 1
  br i1 %21, label %24, label %22

22:                                               ; preds = %19
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.395) #7
  %23 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

24:                                               ; preds = %19
  %25 = tail call i32 @close(i32 noundef %6) #7
  %26 = tail call i32 @unlink(ptr noundef nonnull @.str.294) #7
  %27 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @execout(ptr readnone captures(none) %0) #5 {
  %2 = alloca [3 x ptr], align 4
  br label %3

3:                                                ; preds = %30, %1
  %4 = phi i32 [ 0, %1 ], [ %32, %30 ]
  %5 = icmp eq i32 %4, 15
  br i1 %5, label %6, label %8

6:                                                ; preds = %3
  %7 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

8:                                                ; preds = %3
  %9 = tail call i32 @fork() #7
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %8
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.18) #7
  %12 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

13:                                               ; preds = %8
  %14 = icmp eq i32 %9, 0
  br i1 %14, label %15, label %30

15:                                               ; preds = %13, %18
  %16 = tail call ptr @sbrk(i32 noundef 4096) #7
  %17 = icmp eq ptr %16, inttoptr (i32 -1 to ptr)
  br i1 %17, label %20, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds nuw i8, ptr %16, i32 4095
  store i8 1, ptr %19, align 1, !tbaa !14
  br label %15

20:                                               ; preds = %15, %27
  %21 = phi i32 [ %29, %27 ], [ 0, %15 ]
  %22 = icmp eq i32 %21, %4
  br i1 %22, label %23, label %27

23:                                               ; preds = %20
  %24 = tail call i32 @close(i32 noundef 1) #7
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %2) #9
  call void @llvm.memcpy.p0.p0.i32(ptr noundef nonnull align 4 dereferenceable(12) %2, ptr noundef nonnull align 4 dereferenceable(12) @__const.execout.args, i32 12, i1 false)
  %25 = call i32 @exec(ptr noundef nonnull @.str.19, ptr noundef nonnull %2) #7
  %26 = call i32 @exit(i32 noundef 0) #8
  unreachable

27:                                               ; preds = %20
  %28 = tail call ptr @sbrk(i32 noundef -4096) #7
  %29 = add nuw nsw i32 %21, 1
  br label %20, !llvm.loop !108

30:                                               ; preds = %13
  %31 = tail call i32 @wait(ptr noundef null) #7
  %32 = add nuw nsw i32 %4, 1
  br label %3, !llvm.loop !109
}

; Function Attrs: minsize nounwind optsize
define dso_local void @diskfull(ptr noundef %0) #0 {
  %2 = alloca [32 x i8], align 1
  %3 = alloca [1024 x i8], align 1
  %4 = alloca [32 x i8], align 1
  %5 = alloca [32 x i8], align 1
  %6 = alloca [32 x i8], align 1
  %7 = tail call i32 @unlink(ptr noundef nonnull @.str.396) #7
  %8 = getelementptr inbounds nuw i8, ptr %2, i32 1
  %9 = getelementptr inbounds nuw i8, ptr %2, i32 2
  %10 = getelementptr inbounds nuw i8, ptr %2, i32 3
  %11 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %12

12:                                               ; preds = %35, %1
  %13 = phi i32 [ 0, %1 ], [ %36, %35 ]
  %14 = phi i32 [ 0, %1 ], [ %38, %35 ]
  %15 = icmp eq i32 %13, 0
  %16 = icmp samesign ult i32 %14, 79
  %17 = select i1 %15, i1 %16, i1 false
  br i1 %17, label %18, label %39

18:                                               ; preds = %12
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #9
  store i8 98, ptr %2, align 1, !tbaa !14
  store i8 105, ptr %8, align 1, !tbaa !14
  store i8 103, ptr %9, align 1, !tbaa !14
  %19 = trunc nuw nsw i32 %14 to i8
  %20 = add nuw nsw i8 %19, 48
  store i8 %20, ptr %10, align 1, !tbaa !14
  store i8 0, ptr %11, align 1, !tbaa !14
  %21 = call i32 @unlink(ptr noundef nonnull %2) #7
  %22 = call i32 @open(ptr noundef nonnull %2, i32 noundef 1538) #7
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %34, label %24

24:                                               ; preds = %18, %32
  %25 = phi i32 [ %33, %32 ], [ 0, %18 ]
  %26 = icmp eq i32 %25, 268
  br i1 %26, label %35, label %27

27:                                               ; preds = %24
  call void @llvm.lifetime.start.p0(i64 1024, ptr nonnull %3) #9
  %28 = call i32 @write(i32 noundef %22, ptr noundef nonnull %3, i32 noundef 1024) #7
  %29 = icmp eq i32 %28, 1024
  br i1 %29, label %32, label %30

30:                                               ; preds = %27
  %31 = call i32 @close(i32 noundef %22) #7
  call void @llvm.lifetime.end.p0(i64 1024, ptr nonnull %3) #9
  br label %35

32:                                               ; preds = %27
  call void @llvm.lifetime.end.p0(i64 1024, ptr nonnull %3) #9
  %33 = add nuw nsw i32 %25, 1
  br label %24, !llvm.loop !110

34:                                               ; preds = %18
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.397, ptr noundef %0, ptr noundef nonnull %2) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #9
  br label %39

35:                                               ; preds = %24, %30
  %36 = phi i32 [ 1, %30 ], [ 0, %24 ]
  %37 = call i32 @close(i32 noundef %22) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #9
  %38 = add nuw nsw i32 %14, 1
  br label %12, !llvm.loop !111

39:                                               ; preds = %12, %34
  %40 = getelementptr inbounds nuw i8, ptr %4, i32 1
  %41 = getelementptr inbounds nuw i8, ptr %4, i32 2
  %42 = getelementptr inbounds nuw i8, ptr %4, i32 3
  %43 = getelementptr inbounds nuw i8, ptr %4, i32 4
  br label %44

44:                                               ; preds = %57, %39
  %45 = phi i32 [ 0, %39 ], [ %59, %57 ]
  %46 = icmp eq i32 %45, 128
  br i1 %46, label %61, label %47

47:                                               ; preds = %44
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %4) #9
  store i8 122, ptr %4, align 1, !tbaa !14
  store i8 122, ptr %40, align 1, !tbaa !14
  %48 = lshr i32 %45, 5
  %49 = trunc nuw nsw i32 %48 to i8
  %50 = or disjoint i8 %49, 48
  store i8 %50, ptr %41, align 1, !tbaa !14
  %51 = trunc nuw nsw i32 %45 to i8
  %52 = and i8 %51, 31
  %53 = add nuw nsw i8 %52, 48
  store i8 %53, ptr %42, align 1, !tbaa !14
  store i8 0, ptr %43, align 1, !tbaa !14
  %54 = call i32 @unlink(ptr noundef nonnull %4) #7
  %55 = call i32 @open(ptr noundef nonnull %4, i32 noundef 1538) #7
  %56 = icmp sgt i32 %55, -1
  br i1 %56, label %57, label %60

57:                                               ; preds = %47
  %58 = call i32 @close(i32 noundef %55) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %4) #9
  %59 = add nuw nsw i32 %45, 1
  br label %44, !llvm.loop !112

60:                                               ; preds = %47
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %4) #9
  br label %61

61:                                               ; preds = %44, %60
  %62 = call i32 @mkdir(ptr noundef nonnull @.str.396) #7
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %64, label %65

64:                                               ; preds = %61
  call void (ptr, ...) @printf(ptr noundef nonnull @.str.398, ptr noundef %0) #7
  br label %65

65:                                               ; preds = %64, %61
  %66 = call i32 @unlink(ptr noundef nonnull @.str.396) #7
  %67 = getelementptr inbounds nuw i8, ptr %5, i32 1
  %68 = getelementptr inbounds nuw i8, ptr %5, i32 2
  %69 = getelementptr inbounds nuw i8, ptr %5, i32 3
  %70 = getelementptr inbounds nuw i8, ptr %5, i32 4
  br label %71

71:                                               ; preds = %79, %65
  %72 = phi i32 [ 0, %65 ], [ %87, %79 ]
  %73 = icmp eq i32 %72, 128
  br i1 %73, label %74, label %79

74:                                               ; preds = %71
  %75 = getelementptr inbounds nuw i8, ptr %6, i32 1
  %76 = getelementptr inbounds nuw i8, ptr %6, i32 2
  %77 = getelementptr inbounds nuw i8, ptr %6, i32 3
  %78 = getelementptr inbounds nuw i8, ptr %6, i32 4
  br label %88

79:                                               ; preds = %71
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %5) #9
  store i8 122, ptr %5, align 1, !tbaa !14
  store i8 122, ptr %67, align 1, !tbaa !14
  %80 = lshr i32 %72, 5
  %81 = trunc nuw nsw i32 %80 to i8
  %82 = or disjoint i8 %81, 48
  store i8 %82, ptr %68, align 1, !tbaa !14
  %83 = trunc nuw nsw i32 %72 to i8
  %84 = and i8 %83, 31
  %85 = add nuw nsw i8 %84, 48
  store i8 %85, ptr %69, align 1, !tbaa !14
  store i8 0, ptr %70, align 1, !tbaa !14
  %86 = call i32 @unlink(ptr noundef nonnull %5) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %5) #9
  %87 = add nuw nsw i32 %72, 1
  br label %71, !llvm.loop !113

88:                                               ; preds = %74, %92
  %89 = phi i32 [ %96, %92 ], [ 0, %74 ]
  %90 = icmp eq i32 %89, 79
  br i1 %90, label %91, label %92

91:                                               ; preds = %88
  ret void

92:                                               ; preds = %88
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %6) #9
  store i8 98, ptr %6, align 1, !tbaa !14
  store i8 105, ptr %75, align 1, !tbaa !14
  store i8 103, ptr %76, align 1, !tbaa !14
  %93 = trunc nuw nsw i32 %89 to i8
  %94 = add nuw nsw i8 %93, 48
  store i8 %94, ptr %77, align 1, !tbaa !14
  store i8 0, ptr %78, align 1, !tbaa !14
  %95 = call i32 @unlink(ptr noundef nonnull %6) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %6) #9
  %96 = add nuw nsw i32 %89, 1
  br label %88, !llvm.loop !114
}

; Function Attrs: minsize nounwind optsize
define dso_local void @outofinodes(ptr readnone captures(none) %0) #0 {
  %2 = alloca [32 x i8], align 1
  %3 = alloca [32 x i8], align 1
  %4 = getelementptr inbounds nuw i8, ptr %2, i32 1
  %5 = getelementptr inbounds nuw i8, ptr %2, i32 2
  %6 = getelementptr inbounds nuw i8, ptr %2, i32 3
  %7 = getelementptr inbounds nuw i8, ptr %2, i32 4
  br label %8

8:                                                ; preds = %21, %1
  %9 = phi i32 [ 0, %1 ], [ %23, %21 ]
  %10 = icmp eq i32 %9, 1024
  br i1 %10, label %25, label %11

11:                                               ; preds = %8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %2) #9
  store i8 122, ptr %2, align 1, !tbaa !14
  store i8 122, ptr %4, align 1, !tbaa !14
  %12 = lshr i32 %9, 5
  %13 = trunc nuw nsw i32 %12 to i8
  %14 = add nuw nsw i8 %13, 48
  store i8 %14, ptr %5, align 1, !tbaa !14
  %15 = trunc i32 %9 to i8
  %16 = and i8 %15, 31
  %17 = add nuw nsw i8 %16, 48
  store i8 %17, ptr %6, align 1, !tbaa !14
  store i8 0, ptr %7, align 1, !tbaa !14
  %18 = call i32 @unlink(ptr noundef nonnull %2) #7
  %19 = call i32 @open(ptr noundef nonnull %2, i32 noundef 1538) #7
  %20 = icmp sgt i32 %19, -1
  br i1 %20, label %21, label %24

21:                                               ; preds = %11
  %22 = call i32 @close(i32 noundef %19) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #9
  %23 = add nuw nsw i32 %9, 1
  br label %8, !llvm.loop !115

24:                                               ; preds = %11
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %2) #9
  br label %25

25:                                               ; preds = %8, %24
  %26 = getelementptr inbounds nuw i8, ptr %3, i32 1
  %27 = getelementptr inbounds nuw i8, ptr %3, i32 2
  %28 = getelementptr inbounds nuw i8, ptr %3, i32 3
  %29 = getelementptr inbounds nuw i8, ptr %3, i32 4
  br label %30

30:                                               ; preds = %34, %25
  %31 = phi i32 [ 0, %25 ], [ %42, %34 ]
  %32 = icmp eq i32 %31, 1024
  br i1 %32, label %33, label %34

33:                                               ; preds = %30
  ret void

34:                                               ; preds = %30
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %3) #9
  store i8 122, ptr %3, align 1, !tbaa !14
  store i8 122, ptr %26, align 1, !tbaa !14
  %35 = lshr i32 %31, 5
  %36 = trunc nuw nsw i32 %35 to i8
  %37 = add nuw nsw i8 %36, 48
  store i8 %37, ptr %27, align 1, !tbaa !14
  %38 = trunc i32 %31 to i8
  %39 = and i8 %38, 31
  %40 = add nuw nsw i8 %39, 48
  store i8 %40, ptr %28, align 1, !tbaa !14
  store i8 0, ptr %29, align 1, !tbaa !14
  %41 = call i32 @unlink(ptr noundef nonnull %3) #7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %3) #9
  %42 = add nuw nsw i32 %31, 1
  br label %30, !llvm.loop !116
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 0, 2) i32 @run(ptr noundef readonly captures(none) %0, ptr noundef %1) local_unnamed_addr #0 {
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #9
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.405, ptr noundef %1) #7
  %4 = tail call i32 @fork() #7
  %5 = icmp slt i32 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %2
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.406) #7
  %7 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

8:                                                ; preds = %2
  %9 = icmp eq i32 %4, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %8
  tail call void %0(ptr noundef %1) #7
  %11 = tail call i32 @exit(i32 noundef 0) #8
  unreachable

12:                                               ; preds = %8
  %13 = call i32 @wait(ptr noundef nonnull %3) #7
  %14 = load i32, ptr %3, align 4, !tbaa !7
  %15 = icmp eq i32 %14, 0
  %16 = select i1 %15, ptr @.str.408, ptr @.str.407
  call void (ptr, ...) @printf(ptr noundef nonnull %16) #7
  %17 = load i32, ptr %3, align 4, !tbaa !7
  %18 = icmp eq i32 %17, 0
  %19 = zext i1 %18 to i32
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #9
  ret i32 %19
}

; Function Attrs: minsize nounwind optsize
define dso_local i32 @runtests(ptr noundef readonly captures(none) %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq ptr %1, null
  %5 = icmp ne i32 %2, 2
  br label %6

6:                                                ; preds = %26, %3
  %7 = phi i32 [ 0, %3 ], [ %27, %26 ]
  %8 = phi ptr [ %0, %3 ], [ %28, %26 ]
  %9 = getelementptr inbounds nuw i8, ptr %8, i32 4
  %10 = load ptr, ptr %9, align 4, !tbaa !117
  %11 = icmp eq ptr %10, null
  br i1 %11, label %29, label %12

12:                                               ; preds = %6
  br i1 %4, label %18, label %13

13:                                               ; preds = %12
  %14 = tail call i32 @strcmp(ptr noundef nonnull %10, ptr noundef nonnull %1) #7
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %26

16:                                               ; preds = %13
  %17 = load ptr, ptr %9, align 4, !tbaa !117
  br label %18

18:                                               ; preds = %16, %12
  %19 = phi ptr [ %17, %16 ], [ %10, %12 ]
  %20 = add nsw i32 %7, 1
  %21 = load ptr, ptr %8, align 4, !tbaa !119
  %22 = tail call i32 @run(ptr noundef %21, ptr noundef %19) #10
  %23 = icmp eq i32 %22, 0
  %24 = and i1 %5, %23
  br i1 %24, label %25, label %26

25:                                               ; preds = %18
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.409) #7
  br label %29

26:                                               ; preds = %13, %18
  %27 = phi i32 [ %20, %18 ], [ %7, %13 ]
  %28 = getelementptr inbounds nuw i8, ptr %8, i32 8
  br label %6, !llvm.loop !120

29:                                               ; preds = %6, %25
  %30 = phi i32 [ -1, %25 ], [ %7, %6 ]
  ret i32 %30
}

; Function Attrs: minsize optsize
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: minsize nounwind optsize
define dso_local i32 @countfree() local_unnamed_addr #0 {
  %1 = tail call ptr @sbrk(i32 noundef 0) #7
  br label %2

2:                                                ; preds = %2, %0
  %3 = phi i32 [ 0, %0 ], [ %6, %2 ]
  %4 = tail call ptr @sbrk(i32 noundef 4096) #7
  %5 = icmp eq ptr %4, inttoptr (i32 -1 to ptr)
  %6 = add nuw nsw i32 %3, 1
  br i1 %5, label %7, label %2

7:                                                ; preds = %2
  %8 = ptrtoint ptr %1 to i32
  %9 = tail call ptr @sbrk(i32 noundef 0) #7
  %10 = ptrtoint ptr %9 to i32
  %11 = sub i32 %8, %10
  %12 = tail call ptr @sbrk(i32 noundef %11) #7
  ret i32 %3
}

; Function Attrs: minsize nounwind optsize
define dso_local range(i32 0, 2) i32 @drivetests(i32 noundef %0, i32 noundef %1, ptr noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i32 %1, 2
  %5 = icmp eq i32 %0, 0
  %6 = icmp eq ptr %2, null
  %7 = icmp ne ptr %2, null
  %8 = icmp eq i32 %1, 0
  br label %9

9:                                                ; preds = %33, %3
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.410) #7
  %10 = tail call i32 @countfree() #10
  %11 = tail call i32 @runtests(ptr noundef nonnull @quicktests, ptr noundef %2, i32 noundef %1) #10
  %12 = icmp sgt i32 %11, -1
  %13 = or i1 %12, %4
  %14 = select i1 %12, i32 %11, i32 0
  br i1 %13, label %15, label %34

15:                                               ; preds = %9
  br i1 %5, label %16, label %24

16:                                               ; preds = %15
  br i1 %6, label %17, label %18

17:                                               ; preds = %16
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.411) #7
  br label %18

18:                                               ; preds = %17, %16
  %19 = tail call i32 @runtests(ptr noundef nonnull @slowtests, ptr noundef %2, i32 noundef %1) #10
  %20 = icmp slt i32 %19, 0
  br i1 %20, label %21, label %22

21:                                               ; preds = %18
  br i1 %4, label %24, label %34

22:                                               ; preds = %18
  %23 = add nuw nsw i32 %19, %14
  br label %24

24:                                               ; preds = %22, %21, %15
  %25 = phi i32 [ %14, %15 ], [ %14, %21 ], [ %23, %22 ]
  %26 = tail call i32 @countfree() #10
  %27 = icmp slt i32 %26, %10
  br i1 %27, label %28, label %29

28:                                               ; preds = %24
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.412, i32 noundef %26, i32 noundef %10) #7
  br i1 %4, label %29, label %34

29:                                               ; preds = %28, %24
  %30 = icmp eq i32 %25, 0
  %31 = select i1 %7, i1 %30, i1 false
  br i1 %31, label %32, label %33

32:                                               ; preds = %29
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.413) #7
  br label %34

33:                                               ; preds = %29
  br i1 %8, label %34, label %9, !llvm.loop !121

34:                                               ; preds = %28, %21, %33, %9, %32
  %35 = phi i32 [ 1, %32 ], [ 1, %28 ], [ 1, %21 ], [ 0, %33 ], [ 1, %9 ]
  ret i32 %35
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local noundef i32 @main(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #5 {
  %3 = icmp eq i32 %0, 2
  br i1 %3, label %4, label %21

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %1, i32 4
  %6 = load ptr, ptr %5, align 4, !tbaa !41
  %7 = tail call i32 @strcmp(ptr noundef %6, ptr noundef nonnull @.str.414) #7
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %25, label %9

9:                                                ; preds = %4
  %10 = load ptr, ptr %5, align 4, !tbaa !41
  %11 = tail call i32 @strcmp(ptr noundef %10, ptr noundef nonnull @.str.415) #7
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %25, label %13

13:                                               ; preds = %9
  %14 = load ptr, ptr %5, align 4, !tbaa !41
  %15 = tail call i32 @strcmp(ptr noundef %14, ptr noundef nonnull @.str.416) #7
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %25, label %17

17:                                               ; preds = %13
  %18 = load ptr, ptr %5, align 4, !tbaa !41
  %19 = load i8, ptr %18, align 1, !tbaa !14
  %20 = icmp eq i8 %19, 45
  br i1 %20, label %23, label %25

21:                                               ; preds = %2
  %22 = icmp sgt i32 %0, 1
  br i1 %22, label %23, label %25

23:                                               ; preds = %17, %21
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.417) #7
  %24 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

25:                                               ; preds = %17, %13, %9, %4, %21
  %26 = phi i32 [ 0, %21 ], [ 0, %4 ], [ 1, %9 ], [ 2, %13 ], [ 0, %17 ]
  %27 = phi i32 [ 0, %21 ], [ 1, %4 ], [ 0, %9 ], [ 0, %13 ], [ 0, %17 ]
  %28 = phi ptr [ null, %21 ], [ null, %4 ], [ null, %9 ], [ null, %13 ], [ %18, %17 ]
  %29 = tail call i32 @drivetests(i32 noundef %27, i32 noundef %26, ptr noundef %28) #10
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %33, label %31

31:                                               ; preds = %25
  %32 = tail call i32 @exit(i32 noundef 1) #8
  unreachable

33:                                               ; preds = %25
  tail call void (ptr, ...) @printf(ptr noundef nonnull @.str.418) #7
  %34 = tail call i32 @exit(i32 noundef 0) #8
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #6

attributes #0 = { minsize nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { minsize optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #4 = { minsize noreturn optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #5 = { minsize noreturn nounwind optsize "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m0" "target-features"="+armv6-m,+strict-align,+thumb-mode,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve.fp,-neon,-sha2,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { minsize nobuiltin nounwind optsize "no-builtins" }
attributes #8 = { minsize nobuiltin noreturn nounwind optsize "no-builtins" }
attributes #9 = { nounwind }
attributes #10 = { minsize nobuiltin optsize "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"Apple clang version 21.0.0 (clang-2100.1.1.101)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"long", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !5, i64 0}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = distinct !{!13, !10, !11}
!14 = !{!5, !5, i64 0}
!15 = distinct !{!15, !10, !11}
!16 = distinct !{!16, !10, !11}
!17 = distinct !{!17, !10, !11}
!18 = distinct !{!18, !10, !11}
!19 = distinct !{!19, !10, !11}
!20 = distinct !{!20, !10, !11}
!21 = distinct !{!21, !11}
!22 = distinct !{!22, !10, !11}
!23 = distinct !{!23, !10, !11}
!24 = distinct !{!24, !10, !11}
!25 = distinct !{!25, !10, !11}
!26 = distinct !{!26, !10, !11}
!27 = distinct !{!27, !10, !11}
!28 = distinct !{!28, !11}
!29 = distinct !{!29, !10, !11}
!30 = distinct !{!30, !11}
!31 = distinct !{!31, !11}
!32 = distinct !{!32, !11}
!33 = distinct !{!33, !10, !11}
!34 = distinct !{!34, !10, !11}
!35 = distinct !{!35, !10, !11}
!36 = distinct !{!36, !10, !11}
!37 = distinct !{!37, !10, !11}
!38 = distinct !{!38, !10, !11}
!39 = distinct !{!39, !11}
!40 = distinct !{!40, !10, !11}
!41 = !{!42, !42, i64 0}
!42 = !{!"p1 omnipotent char", !43, i64 0}
!43 = !{!"any pointer", !5, i64 0}
!44 = distinct !{!44, !10, !11}
!45 = distinct !{!45, !10, !11}
!46 = distinct !{!46, !10, !11}
!47 = distinct !{!47, !10, !11}
!48 = distinct !{!48, !10, !11}
!49 = distinct !{!49, !10, !11}
!50 = distinct !{!50, !10, !11}
!51 = distinct !{!51, !10, !11}
!52 = distinct !{!52, !10, !11}
!53 = distinct !{!53, !10, !11}
!54 = distinct !{!54, !10, !11}
!55 = distinct !{!55, !10, !11}
!56 = distinct !{!56, !10, !11}
!57 = distinct !{!57, !10, !11}
!58 = distinct !{!58, !10, !11}
!59 = distinct !{!59, !10, !11}
!60 = distinct !{!60, !10, !11}
!61 = distinct !{!61, !10, !11}
!62 = distinct !{!62, !10, !11}
!63 = !{!64, !65, i64 0}
!64 = !{!"", !65, i64 0, !5, i64 2}
!65 = !{!"short", !5, i64 0}
!66 = distinct !{!66, !10, !11}
!67 = distinct !{!67, !10, !11}
!68 = distinct !{!68, !10, !11}
!69 = distinct !{!69, !10, !11}
!70 = distinct !{!70, !10, !11}
!71 = distinct !{!71, !10, !11}
!72 = distinct !{!72, !11}
!73 = distinct !{!73, !10, !11}
!74 = distinct !{!74, !10, !11}
!75 = distinct !{!75, !10, !11}
!76 = distinct !{!76, !10, !11}
!77 = distinct !{!77, !10, !11}
!78 = distinct !{!78, !10, !11}
!79 = distinct !{!79, !10, !11}
!80 = distinct !{!80, !10, !11}
!81 = distinct !{!81, !11}
!82 = distinct !{!82, !10, !11}
!83 = distinct !{!83, !10, !11}
!84 = distinct !{!84, !10, !11}
!85 = distinct !{!85, !10, !11}
!86 = distinct !{!86, !10, !11}
!87 = distinct !{!87, !11}
!88 = distinct !{!88, !10, !11}
!89 = distinct !{!89, !10, !11}
!90 = !{!43, !43, i64 0}
!91 = distinct !{!91, !10, !11}
!92 = distinct !{!92, !10, !11}
!93 = distinct !{!93, !10, !11}
!94 = distinct !{!94, !10, !11}
!95 = distinct !{!95, !10, !11}
!96 = distinct !{!96, !10, !11}
!97 = !{!98, !65, i64 8}
!98 = !{!"stat", !8, i64 0, !8, i64 4, !65, i64 8, !65, i64 10, !4, i64 12}
!99 = distinct !{!99, !10, !11}
!100 = distinct !{!100, !10, !11}
!101 = distinct !{!101, !10, !11}
!102 = distinct !{!102, !10, !11}
!103 = distinct !{!103, !10, !11}
!104 = distinct !{!104, !10, !11}
!105 = distinct !{!105, !10, !11}
!106 = distinct !{!106, !10, !11}
!107 = distinct !{!107, !10, !11}
!108 = distinct !{!108, !10, !11}
!109 = distinct !{!109, !10, !11}
!110 = distinct !{!110, !10, !11}
!111 = distinct !{!111, !10, !11}
!112 = distinct !{!112, !10, !11}
!113 = distinct !{!113, !10, !11}
!114 = distinct !{!114, !10, !11}
!115 = distinct !{!115, !10, !11}
!116 = distinct !{!116, !10, !11}
!117 = !{!118, !42, i64 4}
!118 = !{!"test", !43, i64 0, !42, i64 4}
!119 = !{!118, !43, i64 0}
!120 = distinct !{!120, !10, !11}
!121 = distinct !{!121, !10, !11}
