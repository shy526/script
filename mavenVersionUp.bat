@echo off
set file= %DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2%%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%-%TIME:~9,2%"shy.txt"
:: 读取version 到文件
call mvn help:evaluate -Dexpression="project.version"  -q -DforceStdout > %file%

call:cllError 读取当前版本

set /p oldVersion=<%file%
del %file%


for /f "tokens=1 delims=-" %%I in ("%oldVersion%") do (
  set num=%%I
)
set /a version=%num:.=%+1
set newVersion=%version:~0,1%.%version:~1,1%.%version:~2,1%-SNAPSHOT
call:log %oldVersion%升级为%newVersion%


call:log 修改版本并验证

call mvn clean versions:set -DnewVersion=%newVersion%
echo:
call:cllError 修改版本



call mvn clean package -D maven.test.skip=true

if %errorlevel%  == 0 (
    call:log 验证通过并提交
    call mvn versions:commit
) else (
    call:log 验证失败并回滚
    call mvn versions:revert
)

::延迟
:sleep
ping -n %1 127.0.0.1 >nul
goto:EOF

:: 用来诊断上个 call 执行是否成功
:cllError

if %errorlevel%  == 0 (
    call:log %1%-SUCCESS
) else (
    call:log %1%-ERROR
    exit
)
goto:EOF


:log
    echo =====================[%1%]=====================
    call:sleep 1
goto:EOF

