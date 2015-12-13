@echo off
REM windows batch

setlocal ENABLEDELAYEDEXPANSION

if EXIST repositories.push (
    echo.
    echo Using repositories.push ...
    for /f "tokens=*" %%L in (repositories.push) do (
        for /f "tokens=1" %%S in ("%%L") do set A=%%S
        for /f "tokens=2" %%T in ("%%L") do set B=%%T

        if NOT "!A!" == "#" call:download_code !A! !B! || exit /B 1
    )
    ) else (
    echo.
    echo Using repositories ...
    for /f "tokens=*" %%L in (repositories) do (
        for /f "tokens=1" %%S in ("%%L") do set A=%%S
        for /f "tokens=2" %%T in ("%%L") do set B=%%T

        if NOT "!A!" == "#" call:download_code !A! !B! || exit /B 1
    )
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
    echo ^# %P% -^> %R%
    echo ^# -------------------------------------------
    set OLDPWD=%cd%
    cd %P% || exit /B 1
    git push github master || exit /B 1
    cd %OLDPWD%
goto:EOF


