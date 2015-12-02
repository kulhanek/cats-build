@echo off
REM windows batch

set DEVELOPMENT_ROOT=%cd%

setlocal ENABLEDELAYEDEXPANSION

echo|set /p=set PATH^=

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
endlocal

goto:EOF

REM -----------------------------------------------------------------

:gen_path
    set P=%1
    set P=%P:/=\%
	echo|set /p=%DEVELOPMENT_ROOT%\%P%\lib^;%DEVELOPMENT_ROOT%\%P%\bin^;
goto:EOF

:gen_path_win
    set P=%1
	echo|set /p=%P%^;
goto:EOF


