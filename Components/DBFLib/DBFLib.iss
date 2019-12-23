; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=DBFLib
AppVerName=DBFLib 6.0
AppPublisher=DBFLib
AppPublisherURL=http://www.uaservice.uzhgorod.ua
AppSupportURL=http://www.uaservice.uzhgorod.ua
AppUpdatesURL=http://www.uaservice.uzhgorod.ua
CreateAppDir=true
Compression=lzma/ultra
SolidCompression=true
AppendDefaultDirName=false
ShowLanguageDialog=yes
DefaultDirName={pf}\DBFLib 6.0


[_ISTool]
LogFile=InstallLog
LogFileAppend=false
[Code]
const
  BCBRegKey = 'Software\Borland\C++Builder\6.0';

var
  BorlandRoot:string;

function  BCBPath(S:string):string;
begin
  Result:= BorlandRoot;
end;

function InitializeSetup(): Boolean;
begin
    if not RegQueryStringValue(HKEY_CURRENT_USER,BCBRegKey,'RootDir',BorlandRoot) then
    begin
      MsgBox('Do not Exist C++Builder 6.0',mbInformation,MB_OK);
      result := false;
    end
    else
    begin
      Result := True;
    end;
end;



[Registry]
Root: HKCU; Subkey: Software\Borland\C++Builder\6.0\Known Packages; ValueType: string; ValueName: {code:BCBPath}\Bin\DBFBC6D.bpl; ValueData: DBF Library 6.0; Flags: uninsdeletevalue
Root: HKCU; Subkey: Software\DBFLib\6.0; ValueType: string; ValueName: path; ValueData: {app}; Flags: uninsdeletekey createvalueifdoesntexist
[Files]
Source: Source\CONV866.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_CDX.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_CNST.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_DATE.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_DBF.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_DBSY.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_DISK.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\gs6_encrxm.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_EROR.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\gs6_glbl.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_INDX.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_LCAL.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_MDX.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_MEMO.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_MIX.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_NDX.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_NTX.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_SHEL.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_SORT.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_SQL.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_TOOL.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\GS6_UDF.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\Halcn6DB.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\Halcn6Id.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\Halcn6Pr.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\Halcn6rg.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\SYSHALC.hpp; DestDir: {code:BCBPath}\Include\Vcl; Components: Library
Source: Source\CONV866.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_CDX.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_CNST.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DATE.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DBF.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DBSY.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DISK.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\gs6_encrxm.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_EROR.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\gs6_glbl.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_INDX.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_LCAL.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_MDX.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_MEMO.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_MIX.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_NDX.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_NTX.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_SORT.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_SQL.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_TOOL.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_UDF.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\Halcn6DB.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\SYSHALC.dcu; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\CONV866.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\DBFBC6R.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_CDX.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_CNST.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DATE.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DBF.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DBSY.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_DISK.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\gs6_encrxm.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_EROR.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\gs6_glbl.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_INDX.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_LCAL.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_MDX.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_MEMO.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_MIX.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_NDX.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_NTX.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_SORT.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_SQL.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_TOOL.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\GS6_UDF.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\Halcn6DB.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\SYSHALC.obj; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\DBFBC6R.res; DestDir: {code:BCBPath}\Lib\Obj; Components: Library
Source: Source\DBFBC6R.bpi; DestDir: {code:BCBPath}\Lib; Components: Library
Source: Source\DBFBC6D.bpl; DestDir: {code:BCBPath}\bin; Components: Library
Source: Source\DBFBC6R.lib; DestDir: {code:BCBPath}\Lib; Components: Library
Source: Source\DBFBC6R.bpl; DestDir: {sys}; Components: Library
Source: Readme.txt; DestDir: {app}; Components: Library
Source: Help\HALCYON6.GID; DestDir: {app}\Help\; Attribs: hidden; Components: Help
Source: Help\HALCYON6.HLP; DestDir: {app}\Help\; Components: Help
Source: Source\CONV866.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\DBF6.cfg; DestDir: {app}\Source\; Components: Source
Source: Source\DBF6.dof; DestDir: {app}\Source\; Components: Source
Source: Source\DBF6.dpk; DestDir: {app}\Source\; Components: Source
Source: Source\DBF6.res; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6D.bpk; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6D.cpp; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6D.mak; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6D.res; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6R.bpk; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6R.cpp; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6R.mak; DestDir: {app}\Source\; Components: Source
Source: Source\DBFBC6R.res; DestDir: {app}\Source\; Components: Source
Source: Source\DDBF6.cfg; DestDir: {app}\Source\; Components: Source
Source: Source\DDBF6.dof; DestDir: {app}\Source\; Components: Source
Source: Source\DDBF6.dpk; DestDir: {app}\Source\; Components: Source
Source: Source\DDBF6.res; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_CDX.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_CNST.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_DATE.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_DBF.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_DBSY.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_DISK.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\gs6_encrxm.pas; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_EROR.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_FLAG.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\gs6_glbl.pas; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_INDX.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_LCAL.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_MDX.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_MEMO.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_MIX.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_NDX.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_NTX.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_SHEL.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_SORT.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_SQL.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_TOOL.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\GS6_UDF.PAS; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6DB.pas; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6Id.dfm; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6Id.pas; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6Pr.dfm; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6Pr.pas; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6rg.dcr; DestDir: {app}\Source\; Components: Source
Source: Source\Halcn6rg.pas; DestDir: {app}\Source\; Components: Source
Source: Source\SYSHALC.PAS; DestDir: {app}\Source\; Components: Source
[Dirs]
Name: {app}\Help; Components: Help
Name: {app}\Source; Components: Source
[Components]
Name: Source; Description: Source; Types: custom full
Name: Help; Description: Help; Types: custom full
Name: Library; Description: Library; Flags: fixed; Types: custom compact full