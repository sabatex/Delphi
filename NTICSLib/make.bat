@rem build NTICS.lib
@cd source_pas
@make -f NTICS.MAK
@if errorlevel 1 exit /B 1
@if EXIST *.bpl copy /Y *.bpl %Proj%\Bpl\
@if EXIST *.bpl del /Q *.bpl
@if EXIST *.dcp copy /Y *.dcp %Proj%\Bpl\
@if EXIST *.dcp del /Q *.dcp
@if EXIST *.bpi copy /Y *.bpi %Proj%\Lib\
@if EXIST *.bpi del /Q *.bpi
@if EXIST *.lib copy /Y *.lib %Proj%\Lib\
@if EXIST *.lib del /Q *.lib

@if EXIST *.hpp copy /Y *.hpp ..\Include\
@if EXIST *.hpp del /Q *.hpp
@if EXIST *.h copy /Y *.h ..\Include\

@if EXIST *.res copy /Y *.res ..\obj\
@if EXIST *.dfm copy /Y *.dfm ..\obj\
@if EXIST *.dcu copy /Y *.dcu ..\obj\
@if EXIST *.obj copy /Y *.obj ..\obj\


@cd ..\source
@make -f NTICSLib.MAK
@if errorlevel 1 exit /B 1

@if EXIST *.bpl copy /Y *.bpl %Proj%\Bpl\
@if EXIST *.bpl del /Q *.bpl
@if EXIST *.dcp copy /Y *.dcp %Proj%\Bpl\
@if EXIST *.dcp del /Q *.dcp
@if EXIST *.bpi copy /Y *.bpi %Proj%\Lib\
@if EXIST *.bpi del /Q *.bpi
@if EXIST *.lib copy /Y *.lib %Proj%\Lib\
@if EXIST *.lib del /Q *.lib

@if EXIST *.hpp copy /Y *.hpp ..\Include\
@if EXIST *.hpp del /Q *.hpp
@if EXIST *.h copy /Y *.h ..\Include\

@if EXIST *.res copy /Y *.res ..\obj\
@if EXIST *.dfm copy /Y *.dfm ..\obj\
@if EXIST *.dcu copy /Y *.dcu ..\obj\
@if EXIST *.obj copy /Y *.obj ..\obj\
