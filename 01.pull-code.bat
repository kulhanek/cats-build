@echo off
REM windows batch

setlocal ENABLEDELAYEDEXPANSION

for /f "tokens=*" %%L in (repositories) do (
   for /f "tokens=1" %%S in ("%%L") do set A=%%S
   for /f "tokens=2" %%T in ("%%L") do set B=%%T

   if NOT "!A!" == "#" call:download_code !A! !B! || exit /B 1
)
endlocal

echo.

goto:EOF

REM -----------------------------------------------------------------

:download_code
    set P=%1
    set P=%P:/=\%
    set R=%2
	echo. 
 	echo ^# %R% -^> %P%
	echo ^# -------------------------------------------
	set OLDPWD=%cd%
	if NOT EXIST %P% mkdir %P% || exit /B 1
    cd %P% || exit /B 1
    if NOT EXIST .git (
   		git init
   		git remote add github https://github.com/kulhanek/%R%.git
 	)
	git pull github master || exit /B 1
	cd %OLDPWD%
goto:EOF


