@echo Start build
@set Proj="C:\Program files\borland\CBUILDER6\Projects
@echo Clear old files
@call clean.bat > build.log
@echo Build NTICSLib
@call make.bat >> build.log
@if errorlevel 1 goto endError
@goto End
:endError
rem ------------��������� ������ �� ����� ����������------------------
@echo ERROR BUILD
@pause

:End