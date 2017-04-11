echo off
cls
call config.bat
call clear.bat

if exist MAKEFILE goto :Makefile 
goto :Manual

:Makefile
echo --- Makefile work... ---
make -B
goto :Run

:Manual
echo --- Compilling... ---
tasm %name%.asm
echo --- Linking... ---
tlink %name%.obj
goto :Run

:Run
echo --- Running... ---
echo ---------------------------------------------------------------
echo.
echo.
%name%
echo.
echo.
echo ---------------------------------------------------------------
echo --- End of programm ---
call clear.bat
pause
exit
