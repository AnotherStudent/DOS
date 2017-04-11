echo off
cls
call config.bat
call clear.bat

if exist MAKEFILE goto :Makefile
goto :Manual

:Makefile
echo --- Makefile work... ---
make -B -DDEBUG
goto :Run

:Manual
echo --- Compilling... ---
tasm /zi %name%.asm
echo --- Linking... ---
tlink /v %name%.obj
goto :Run

:Run
echo --- Debugging... ---
echo ---------------------------------------------------------------
echo.
echo.
if exist %name%.com call td %name%.com
if exist %name%.exe call td %name%.exe
echo.
echo.
echo ---------------------------------------------------------------
echo --- End of programm ---
call clear.bat
exit
