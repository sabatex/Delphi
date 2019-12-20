[Setup]
AppName=Клиєнт бази нарядів
AppVerName=Клиєнт бази нарядів
AppCopyright=Copyright (C) 2002 Serhiy Lakas
DefaultDirName={pf}\SABA
OutputBaseFilename=MatiasClient
MessagesFile=compiler:Ukrainian-2-3.0.2.isl
WindowResizable=false
UninstallLogMode=overwrite
AllowNoIcons=true
UsePreviousSetupType=false
UsePreviousTasks=false
DisableReadyPage=false
ShowComponentSizes=false
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
Compression=bzip
OutputDir=..\Distributiv
DisableProgramGroupPage=true
DefaultGroupName=База нарядів

[Files]
Source: ..\FB1.0.0.679 RC2\bin\gds32.dll; DestDir: {sys}; CopyMode: alwaysskipifsameorolder; Flags: sharedfile
Source: Client\BIN\Matias.exe; DestDir: {app}; CopyMode: alwaysoverwrite
Source: Client\BIN\*.frf; DestDir: {app}
Source: Doc\Fruser.hlp; DestDir: {app}; CopyMode: alwaysoverwrite
Source: Doc\FRUSER.CNT; DestDir: {app}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[Code]
program Setup;

procedure CurStepChanged(CurStep:integer);
begin
  if CurStep = csFinished then
    if FileExists(ExpandConstant('{src}') + '\ServerConfig.ini') then
      FileCopy(ExpandConstant('{src}') + '\ServerConfig.ini',ExpandConstant('{app}') +'\ServerConfig.ini',true);
end;


begin
end.

[Icons]
Name: {group}\Клиєнт бази нарядів; Filename: {app}\Matias.exe; WorkingDir: {app}; IconFilename: {app}\Matias.exe; IconIndex: 0
