; ModuleID = 'NumNum'

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@tmp = private unnamed_addr constant [8 x i8] c"success\00"
@tmp.3 = private unnamed_addr constant [11 x i8] c"no success\00"
@fmt.4 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@tmp.7 = private unnamed_addr constant [8 x i8] c"success\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %cond_result = call i32 @cond(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @tmp, i32 0, i32 0))
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %cond_result)
  %cond_result1 = call i32 @cond(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @tmp.3, i32 0, i32 0))
  %printf2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %cond_result1)
  ret i32 0
}

define i32 @cond(i8* %s) {
entry:
  %s1 = alloca i8*
  store i8* %s, i8** %s1
  %x = alloca i32
  %r = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @tmp.7, i32 0, i32 0), i8** %r
  %s2 = load i8*, i8** %s1
  %r3 = load i8*, i8** %r
  %s4 = load i8*, i8** %s1
  %tmp = icmp eq i8* %s2, %r3
  br i1 %tmp, label %then, label %else

merge:                                            ; preds = %else, %then
  %x5 = load i32, i32* %x
  ret i32 %x5

then:                                             ; preds = %entry
  store i32 42, i32* %x
  br label %merge

else:                                             ; preds = %entry
  store i32 17, i32* %x
  br label %merge
}
