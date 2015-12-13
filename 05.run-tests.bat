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

:test_code
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
        ctest || exit 1
    )
    cd %OLDPWD%
goto:EOF


