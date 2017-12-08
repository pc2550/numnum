; ModuleID = 'NumNum'

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@fmt.1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@tmp = private unnamed_addr constant [13 x i8] c"./4chars.txt\00"
@tmp.3 = private unnamed_addr constant [12 x i8] c"       read\00"
@a = global [12 x i8] c"       read\00"

declare i32 @printf(i8*, ...)

declare i32 @open(i8*, i32, ...)

declare i32 @read(i32, i8*, i32, ...)

@errno = external global i32

define i32 @main() {
entry:
  %path = alloca i8*
  %buff = alloca i8*
  %flags = alloca i32
  %fd = alloca i32
  %ret = alloca i32
  store i8* getelementptr inbounds ([13 x i8], [13 x i8]* @tmp, i32 0, i32 0), i8** %path
  store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @a, i32 0, i32 0), i8** %buff
  store i32 0, i32* %flags
  %flags1 = load i32, i32* %flags
  %path2 = load i8*, i8** %path
  %open = call i32 (i8*, i32, ...) @open(i8* %path2, i32 %flags1)
  store i32 %open, i32* %fd
  %fd3 = load i32, i32* %fd
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %fd3)
  %buff4 = load i8*, i8** %buff
  %fd5 = load i32, i32* %fd
  %read = call i32 (i32, i8*, i32, ...) @read(i32 %fd5, i8* %buff4, i32 4)
  store i32 %read, i32* %ret
  %ret6 = load i32, i32* %ret
  %merp0 = load i32, i32* @errno, align 4
  %printf7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %merp0)
  %buff8 = load i8*, i8** %buff
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %buff8)
  ret i32 0
}
