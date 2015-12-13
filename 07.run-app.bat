@echo off
REM windows batch
set PWD=%cd%
setlocal ENABLEDELAYEDEXPANSION

SET INSTPATH=%~dp0
SET REPO_PATH=%INSTPATH:~0,-1%

set PATH=

if EXIST "%REPO_PATH%\tools.paths" (
    for /f "tokens=*" %%L in ( %REPO_PATH%\tools.paths ) do (
        for /f "tokens=1" %%S in ("%%L") do set A=%%S

        if NOT "!A!" == "#" call:gen_path_win !A!
    )
)

for /f "tokens=*" %%L in ( %REPO_PATH%\repositories ) do (
   for /f "tokens=1" %%S in ("%%L") do set A=%%S
   for /f "tokens=2" %%T in ("%%L") do set B=%%T 

   if NOT "!A!" == "#" call:gen_path !A!
)

echo %PATH%

REM run the application
cd  %PWD%
echo Cmd: %*
%* 

endlocal


goto:EOF

REM -----------------------------------------------------------------

:gen_path
    set P=%1
    set P=%P:/=\%
    if EXIST %REPO_PATH%\%P%\build\bin set PATH=%PATH%;%REPO_PATH%\%P%\build\bin
    if EXIST %REPO_PATH%\%P%\build\lib set PATH=%PATH%;%REPO_PATH%\%P%\build\lib
    if EXIST %REPO_PATH%\%P%\lib set PATH=%PATH%;%REPO_PATH%\%P%\lib
    if EXIST %REPO_PATH%\%P%\lib\drivers set PATH=%PATH%;%REPO_PATH%\%P%\lib\drivers
    if EXIST %REPO_PATH%\%P%\bin set PATH=%PATH%;%REPO_PATH%\%P%\bin
goto:EOF

:gen_path_win
    set P=%1
    set PATH=%PATH%;%P%
goto:EOF


