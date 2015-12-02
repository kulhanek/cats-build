@echo off
REM windows batch

setlocal ENABLEDELAYEDEXPANSION

for /f "tokens=*" %%L in (repositories) do (
   for /f "tokens=1" %%S in ("%%L") do set A=%%S
   for /f "tokens=2" %%T in ("%%L") do set B=%%T

   if NOT "!A!" == "#" call:clean_code !A! !B! || exit /B 1
)
endlocal

goto:EOF

REM -----------------------------------------------------------------

:clean_code
    set P=%1
    set P=%P:/=\%
    set R=%2
    echo. 
    echo ^# %P% ^(clean^)
    echo ^# -------------------------------------------
    set OLDPWD=%cd%
    if EXIST %P% (
        cd %P% || exit /B 1
        if EXIST CMakeClean.bat (
            CMakeClean.bat %1%
        )
        cd %OLDPWD%
    ) else (
        echo ^> Nothing to clean ...
    )
goto:EOF