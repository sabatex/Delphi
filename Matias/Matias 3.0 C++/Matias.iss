[Setup]
AppName=ќбл≥к нар€д≥в
AppVerName=ќбл≥к нар€д≥в та FireBird 1.0.0.679 RC2
AppCopyright=Copyright (C) 2002 Serhiy Lakas
DefaultDirName={pf}\SABA
DefaultGroupName=SABA\
OutputBaseFilename=Matias and FireBird-1-00-RC2
MessagesFile=compiler:Ukrainian-2-3.0.2.isl
WindowResizable=false
UninstallLogMode=overwrite
WizardImageFile=FB1.0.0.679 RC2\FireBirdLogo.bmp
WizardSmallImageFile=FB1.0.0.679 RC2\SmallLogo.bmp
AllowNoIcons=true
UsePreviousSetupType=false
UsePreviousTasks=false
DisableReadyPage=false
ShowComponentSizes=false
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
Compression=bzip
OutputDir=Distributiv


[Types]
Name: _Matias; Description: ≤нстал€ц≥€ программи Matias; Flags: iscustom

[Components]
Name: Server; Description: FireBird database server; Types: _Matias
Name: Tools; Description: Administration tools; Types: _Matias
Name: Client; Description:  л≥Їнтська частина; Types: _Matias


[Dirs]
Name: {app}\bin; Components: Server
Name: {app}\doc; Components: Server
Name: {app}\intl; Components: Server
Name: {app}\udf; Components: Server
Name: {app}\Client; Components: Client

[Files]
Source: FB1.0.0.679 RC2\Readme.txt; DestDir: {app}; CopyMode: normal; Components: Server
Source: FB1.0.0.679 RC2\ISC4.GDB; DestDir: {app}; DestName: isc4.gdb; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall; Components: Server
Source: FB1.0.0.679 RC2\isc4.gbk; DestDir: {app}; CopyMode: onlyifdoesntexist; Flags: uninsneveruninstall; Components: Server
Source: FB1.0.0.679 RC2\ibconfig; DestDir: {app}; CopyMode: normal; Components: Server
Source: FB1.0.0.679 RC2\interbase.msg; DestDir: {app}; CopyMode: normal; Flags: sharedfile; Components: Server
Source: FB1.0.0.679 RC2\bin\*.exe; DestDir: {app}\bin; CopyMode: alwaysskipifsameorolder; Components: Server
Source: FB1.0.0.679 RC2\doc\*.*; DestDir: {app}\doc; Components: Server
Source: FB1.0.0.679 RC2\intl\gdsintl.dll; DestDir: {app}\intl; Components: Server
Source: FB1.0.0.679 RC2\UDF\*.*; DestDir: {app}\udf; Components: Server
Source: FB1.0.0.679 RC2\bin\gds32.dll; DestDir: {sys}; CopyMode: alwaysskipifsameorolder; Flags: sharedfile
Source: AdministrativeTools\BIN\FireBirdAdmin.exe; DestDir: {app}; Components: Tools
Source: Client\BIN\*.frf; DestDir: {app}\Client; CopyMode: normal; Components: Client
Source: Client\BIN\Matias.exe; DestDir: {app}\Client; CopyMode: normal; Components: Client
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[Registry]
Root: HKLM; Subkey: Software\Firebird Database Server\CurrentVersion; ValueType: string; ValueName: Version; ValueData: %AppVerName; Flags: uninsdeletevalue; Components: Server
Root: HKLM; Subkey: Software\Firebird Database Server\CurrentVersion; ValueType: string; ValueName: ServerDirectory; ValueData: {app}\bin\; Flags: uninsdeletevalue; Components: Server
Root: HKLM; Subkey: Software\Firebird Database Server\CurrentVersion; Flags: uninsdeletekeyifempty; Components: Server
Root: HKLM; Subkey: Software\Firebird Database Server; Flags: uninsdeletekeyifempty; Components: Server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR BACKWARD COMPATIBILITY
;Root: HKLM; Subkey: Software\Borland\InterBase; ValueType: DWord; ValueName: UseCount; ValueData: {reg:HKLM\Software\Borland\InterBase, UseCount|0} + 1
;Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: DWord; ValueName: UseCount; ValueData: {reg:HKLM\Software\Borland\InterBase\CurrentVersion, UseCount|0} + 1
; obsolete - Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: DefaultMode; ValueData: -r; Components: Server
Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: GuardianOptions; ValueData: 1; Components: Server
Root: HKLM; Subkey: Software\Borland\InterBase\CurrentVersion; ValueType: string; ValueName: ServerDirectory; ValueData: {app}\bin\; Components: Server
; Software\Borland\InterBase\CurrentVersion\RootDirectory
; &
; Software\Borland\InterBase\CurrentVersion\Version
; are setted by instreg.exe,
; delete of empty key Software\Borland\InterBase is work of instreg.exe too
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[Run]
Filename: {app}\bin\instreg.exe; Parameters: "install ""{app}"""; Flags: nowait runminimized; Components: Server
Filename: {app}\bin\instsvc.exe; Parameters: "install ""{app}"" -auto -z"; Flags: runminimized; MinVersion: 0,4.0; Components: Server
Filename: {app}\bin\instsvc.exe; Parameters: start; Flags: nowait runminimized; MinVersion: 0,4.0; Components: Server

[UninstallRun]
Filename: {app}\bin\instsvc.exe; Parameters: stop; Flags: runminimized; MinVersion: 0,4.0; Components: Server
Filename: {app}\bin\instsvc.exe; Parameters: remove; Flags: nowait runminimized; MinVersion: 0,4.0; Components: Server
Filename: {app}\bin\instreg.exe; Parameters: remove; Flags: runminimized; Components: Server

[UninstallDelete]
Name: {app}\*.lck; Type: files
Name: {app}\*.log; Type: files

[Icons]
Name: {group}\AdminMatias; Filename: {app}\FireBirdAdmin.exe; WorkingDir: {app}; IconIndex: 0; Components: Tools
Name: {group}\MatiasClient; Filename: {app}\Client\Matias.exe; WorkingDir: {app}\Client; IconIndex: 0; Components: Client
