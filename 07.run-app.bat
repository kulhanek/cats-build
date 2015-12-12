@echo off
REM windows batch

setlocal ENABLEDELAYEDEXPANSION

set PATH=

if EXIST tools.paths (
    for /f "tokens=*" %%L in (tools.paths) do (
        for /f "tokens=1" %%S in ("%%L") do set A=%%S

        if NOT "!A!" == "#" call:gen_path_win !A!
    )
)

for /f "tokens=*" %%L in (repositories) do (
   for /f "tokens=1" %%S in ("%%L") do set A=%%S
   for /f "tokens=2" %%T in ("%%L") do set B=%%T 

   if NOT "!A!" == "#" call:gen_path !A!
)

echo %PATH%

REM run the application
%1%

endlocal


goto:EOF

REM -----------------------------------------------------------------

:gen_path
    set P=%1
    set P=%P:/=\%
    if EXIST %cd%\%P%\lib set PATH=%PATH%;%cd%\%P%\lib
    if EXIST %cd%\%P%\lib\drivers set PATH=%PATH%;%cd%\%P%\lib\drivers
    if EXIST %cd%\%P%\bin set PATH=%PATH%;%cd%\%P%\bin
goto:EOF

:gen_path_win
    set P=%1
    set PATH=%PATH%;%P%
goto:EOF


