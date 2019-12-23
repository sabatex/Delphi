@set project=DBFLib
@echo Start build  %project%

@set lib=%bcb%\lib\%project%
@set include=%bcb%\include\%project%
@set Proj=%bcb%\Projects
@set bcbbpl=%Proj%\bpl
@set bcblib=%Proj%\lib

@echo make
@cd source
@make -f DBFBC6R.mak > out.txt
@if errorlevel 1 goto endError
@make -f DBFBC6D.mak >> out.txt
@if errorlevel 1 goto endError

@if not EXIST %lib% mkdir %lib%
@if not EXIST %Include% mkdir %include%

@echo Clean ...
@if EXIST %lib%\*.* del /q /f /s %lib%\*.*
@if EXIST %include%\*.* del /q /f /s %include%\*.*

@if EXIST *.bpl copy /Y *.bpl %bcbbpl%
@if EXIST *.bpl del /Q *.bpl
@if EXIST *.dcp copy /Y *.dcp %bcbbpl%
@if EXIST *.dcp del /Q *.dcp
@if EXIST *.bpi copy /Y *.bpi %bcblib%
@if EXIST *.bpi del /Q *.bpi
@if EXIST *.lib copy /Y *.lib %bcblib%
@if EXIST *.lib del /Q *.lib

@if EXIST *.dcu copy /Y *.dcu %lib%
@if EXIST *.dcu del /Q *.dcu
@if EXIST *.obj copy /Y *.obj %lib%
@if EXIST *.obj del /Q *.obj
@if EXIST *.res copy /Y *.res %lib%
@if EXIST *.dfm copy /Y *.dfm %lib%

@rem include files
@if EXIST *.hpp copy /Y *.hpp %include%
@if EXIST *.h copy /Y *.h %include%

@if EXIST *.tds del /Q *.tds

@goto End
:endError
rem ------------произошла ошибка во врем€ компил€ции------------------
@echo ERROR BUILD
@pause

:End