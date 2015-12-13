@echo off
REM windows batch

set DEVELOPMENT_ROOT=%cd%\src

setlocal ENABLEDELAYEDEXPANSION

for /f "tokens=*" %%L in (repositories) do (
   for /f "tokens=1" %%S in ("%%L") do set A=%%S
   for /f "tokens=2" %%T in ("%%L") do set B=%%T 

   if NOT "!A!" == "#" call:build_code !A! !B! || exit /B 1
)
endlocal

echo.

goto:EOF

REM -----------------------------------------------------------------

:build_code
    set P=%1
    set P=%P:/=\%
    set R=%2
    echo. 
    echo ^# %p% (%R%)
    echo ^# -------------------------------------------
    set OLDPWD=%cd%
    if NOT EXIST %P% mkdir %P% || exit /B 1
    cd %P% || exit /B 1
    if EXIST CMakeLists.txt (
        cmake %MODE% -G "MinGW Makefiles" . || exit /B 1
        mingw32-make || exit /B 1
    )
    cd %OLDPWD%
goto:EOF


