; ModuleID = 'NumNum'

@errno = available_externally global i32 0
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.1 = private unnamed_addr constant [4 x i8] c"%x\0A\00"
@fmt.2 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@fmt.4 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.5 = private unnamed_addr constant [4 x i8] c"%x\0A\00"
@fmt.6 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt.7 = private unnamed_addr constant [4 x i8] c"%s\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @open(i8*, i32, ...)

declare i32 @read(i32, i32*, i32, ...)

declare i32 @creat(i8*, i32, ...)

declare i32 @write(i32, i8*, i32, ...)

declare i32 @close(i32, ...)

define i32 @main() {
entry:
  %cond_result = call i32 @cond(i1 true)
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %cond_result)
  %cond_result1 = call i32 @cond(i1 false)
  %printf2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %cond_result1)
  ret i32 0
}

define i32 @cond(i1 %b) {
entry:
  %b1 = alloca i1
  store i1 %b, i1* %b1
  %x = alloca i32
  br i1 false, label %then, label %else

merge:                                            ; preds = %merge2, %then
  %x9 = load i32, i32* %x
  ret i32 %x9

then:                                             ; preds = %entry
  store i32 42, i32* %x
  br label %merge

else:                                             ; preds = %entry
  br i1 false, label %then3, label %else4

merge2:                                           ; preds = %merge6, %then3
  br label %merge

then3:                                            ; preds = %else
  store i32 95, i32* %x
  br label %merge2

else4:                                            ; preds = %else
  %b5 = load i1, i1* %b1
  br i1 %b5, label %then7, label %else8

merge6:                                           ; preds = %else8, %then7
  br label %merge2

then7:                                            ; preds = %else4
  store i32 423, i32* %x
  br label %merge6

else8:                                            ; preds = %else4
  store i32 17, i32* %x
  br label %merge6
}
