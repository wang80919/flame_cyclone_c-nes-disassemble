@echo off

set PARAM_1=%1

set FILE_NAME=%~n0
    
IF DEFINED PARAM_1 (
    echo %~n1
    set FILE_NAME=%~n1
    
) else (
    echo %~n0
)

set INPUT_FILE="%FILE_NAME%.asm"
set CLEAN_FILE="%~dp0%FILE_NAME%.fns"
set NESASM3="tools\NESASM.exe"

cd /d %~dp0

del "%FILE_NAME%.nes"
call %NESASM3% %INPUT_FILE%
set result=%errorlevel%
rem del %CLEAN_FILE%

if 0 NEQ %result% (
    pause
) else (
    rem del "[FC][Music][Namco163][Final].nes"
    rem rename "%FILE_NAME%.nes" "[FC][Music][Namco163][Final].nes"
)

goto:eof