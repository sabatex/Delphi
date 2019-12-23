echo off
make -f AR1_0.mak >>Out.txt
if errorlevel 1 goto endError
echo -- make OK

rem возврасаем информаци_ о версии
rem echo -- vss : CheckIn %NAMEPROJECT%.rc
rem echo -- make: Exe сделан успешно  >> ..\Out.txt

"c:\program files\inno setup 4\compil32.exe" /cc  ar1.0.iss >> Out.txt
if errorlevel 1 goto endError
echo -- distributive OK

echo -- ALL OK
rem ------------------------------------------------------------------------
rem %EXEVER% .\Bin\%NAMEPROJECT%.exe "set verBuild=%%J-%%I-%%2R-%%3B">t$$.bat
rem echo rar a -r -ep1 -s -m5 -x*.scc .\Archiv\%NAMEPROJECT%_%%verBuild%%.rar .\Source\*.* >>t$$.bat
rem echo on
rem t$$.bat  /wait
rem del t$$.bat


pause
goto End

:endError
rem ------------произошла ошибка во врем€ компил€ции------------------

echo -- vss : undoCheckOut %NAMEPROJECT%.rc
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo ERROR см. out.txt
pause

:End