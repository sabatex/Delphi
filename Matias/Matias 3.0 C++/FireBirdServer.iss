[Setup]
AppName=Сервер FireBird 1.0.0.679 RC2
AppVerName=Сервер FireBird 1.0.0.679 RC2
AppCopyright=Copyright (C) 2002 Serhiy Lakas
DefaultDirName={pf}\FireBird
OutputBaseFilename=Matias Server FireBird 1.0.0.679 RC2
MessagesFile=compiler:Ukrainian-2-3.0.2.isl
WindowResizable=false
UninstallLogMode=overwrite
WizardImageFile=..\FB1.0.0.679 RC2\FireBirdLogo.bmp
WizardSmallImageFile=..\FB1.0.0.679 RC2\SmallLogo.bmp
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


[Dirs]
Name: {app}\bin
Name: {app}\doc
Name: {app}\intl
Name: {app}\udf

[Files]
Source: ..\FB1.0.0.679 RC2\Readme.txt; DestDir: {app}; CopyMode: normal
Source: ..\FB1.0.0.679 RC2\ISC4.GDB; DestDir: {app}; DestName: isc4.gdb; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall
Source: ..\FB1.0.0.679 RC2\isc4.gbk; DestDir: {app}; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall
Source: ..\FB1.0.0.679 RC2\ibconfig; DestDir: {app}; CopyMode: normal
Source: ..\FB1.0.0.679 RC2\interbase.msg; DestDir: {app}; CopyMode: normal; Flags: sharedfile
Source: ..\FB1.0.0.679 RC2\bin\*.exe; DestDir: {app}\bin; CopyMode: alwaysskipifsameorolder
Source: ..\FB1.0.0.679 RC2\doc\*.*; DestDir: {app}\doc
Source: ..\FB1.0.0.679 RC2\intl\gdsintl.dll; DestDir: {app}\intl
Source: ..\FB1.0.0.679 RC2\UDF\*.*; DestDir: {app}\udf
Source: ..\FB1.0.0.679 RC2\bin\gds32.dll; DestDir: {sys}; CopyMode: alwaysskipifsameorolder; Flags: sharedfile; Components: Client Server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[Registry]
Root: HKLM; Subkey: Software\Firebird Database Server\CurrentVersion; ValueType: string; ValueName: Version; ValueData: %AppVerName; Flags: uninsdeletevalue
Root: HKLM; Subkey: Software\Firebird Database Server\CurrentVersion; ValueType: string; ValueName: ServerDirectory; ValueData: {app}\bin\; Flags: uninsdeletevalue
Root: HKLM; Subkey: Software\Firebird Database Server\CurrentVersion; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: Software\Firebird Database Server; Flags: uninsdeletekeyifempty
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR BACKWARD COMPATIBILITY
;Root: HKLM; Subkey: Software\Borland\InterBase; ValueType: DWord; ValueName: UseCount; ValueData: {reg:HKLM\Software\Borland\InterBase, UseCount|0} + 1
;Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: DWord; ValueName: UseCount; ValueData: {reg:HKLM\Software\Borland\InterBase\CurrentVersion, UseCount|0} + 1
; obsolete - Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: DefaultMode; ValueData: -r; Components: Server
Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: GuardianOptions; ValueData: 1
Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: ServerDirectory; ValueData: {app}\bin\
; Software\Borland\InterBase\CurrentVersion\RootDirectory
; &
; Software\Borland\InterBase\CurrentVersion\Version
; are setted by instreg.exe,
; delete of empty key Software\Borland\InterBase is work of instreg.exe too
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[Run]
Filename: {app}\bin\instreg.exe; Parameters: "install ""{app}"""; Flags: nowait runminimized
Filename: {app}\bin\instsvc.exe; Parameters: "install ""{app}"" -auto -z"; Flags: runminimized; MinVersion: 0,4.0
Filename: {app}\bin\instsvc.exe; Parameters: start; Flags: nowait runminimized; MinVersion: 0,4.0

[UninstallRun]
Filename: {app}\bin\instsvc.exe; Parameters: stop; Flags: runminimized; MinVersion: 0,4.0
Filename: {app}\bin\instsvc.exe; Parameters: remove; Flags: nowait runminimized; MinVersion: 0,4.0
Filename: {app}\bin\instreg.exe; Parameters: remove; Flags: runminimized

[UninstallDelete]
Name: {app}\*.lck; Type: files
Name: {app}\*.log; Type: files

[Code]
program Setup;
var
  ConfigString:TArrayOfString;

procedure CurStepChanged(CurStep:integer);
begin
  if CurStep = csFinished then
  begin
    if FileExists(ExpandConstant('{app}') + '\ClientsShare\ServerConfig.ini') then DeleteFile(ExpandConstant('{app}') + '\ClientsShare\ServerConfig.ini');
    SetArrayLength(ConfigString,2);
    ConfigString[0]:=GetComputerNameString();
    ConfigString[1]:=ExpandConstant('{app}') +'\DataBase\Matias.GDB';
    SaveStringsToFile(ExpandConstant('{app}') + '\ClientsShare\ServerConfig.ini',ConfigString,true);
  end;
end;


begin
end.

[Types]
Name: Server; Description: Компоненти сервера; MinVersion: 0,4.00.1381sp3; Flags: iscustom

[Components]
Name: Client; Description: FireBird Client; Types: Server
Name: Server; Description: FireBird Server; Types: Server
