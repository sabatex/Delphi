{
@abstract(Compiletime Classes support)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpii_classes;

{$I ifps3_def.inc}
interface
uses
  ifpscomp, ifps3utl;

{
  Will register files from:
    Classes (exception TPersistent and TComponent)

  Register STD first

}
procedure SIRegister_Classes_TypesAndConsts(Cl: TIFPSPascalCompiler);

procedure SIRegisterTStrings(cl: TIFPSPascalCompiler; Streams: Boolean);
procedure SIRegisterTStringList(cl: TIFPSPascalCompiler);
{$IFNDEF IFPS3_MINIVCL}
procedure SIRegisterTBITS(Cl: TIFPSPascalCompiler);
{$ENDIF}
procedure SIRegisterTSTREAM(Cl: TIFPSPascalCompiler);
procedure SIRegisterTHANDLESTREAM(Cl: TIFPSPascalCompiler);
{$IFNDEF IFPS3_MINIVCL}
procedure SIRegisterTMEMORYSTREAM(Cl: TIFPSPascalCompiler);
{$ENDIF}
procedure SIRegisterTFILESTREAM(Cl: TIFPSPascalCompiler);
{$IFNDEF IFPS3_MINIVCL}
procedure SIRegisterTCUSTOMMEMORYSTREAM(Cl: TIFPSPascalCompiler);
procedure SIRegisterTRESOURCESTREAM(Cl: TIFPSPascalCompiler);
procedure SIRegisterTPARSER(Cl: TIFPSPascalCompiler);
procedure SIRegisterTCOLLECTIONITEM(CL: TIFPSPascalCompiler);
procedure SIRegisterTCOLLECTION(CL: TIFPSPascalCompiler);
{$IFDEF IFPS3_D3PLUS}
procedure SIRegisterTOWNEDCOLLECTION(CL: TIFPSPascalCompiler);
{$ENDIF}
{$ENDIF}

procedure SIRegister_Classes(Cl: TIFPSPascalCompiler; Streams: Boolean{$IFDEF D4PLUS}=True{$ENDIF});

implementation

procedure SIRegisterTStrings(cl: TIFPSPascalCompiler; Streams: Boolean); // requires TPersistent
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TSTRINGS') do
  begin
    IsAbstract := True;
    RegisterMethod('function Add(S: string): Integer;');
    RegisterMethod('procedure Append(S: string);');
    RegisterMethod('procedure AddStrings(Strings: TStrings);');
    RegisterMethod('procedure Clear;');
    RegisterMethod('procedure Delete(Index: Integer);');
    RegisterMethod('function IndexOf(const S: string): Integer; ');
    RegisterMethod('procedure Insert(Index: Integer; S: string); ');
    RegisterProperty('Count', 'Integer', iptR);
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('CommaText', 'String', iptrw);
    if Streams then
    begin
      RegisterMethod('procedure LoadFromFile(FileName: string); ');
      RegisterMethod('procedure SaveToFile(FileName: string); ');
    end;
    RegisterProperty('Strings', 'String Integer', iptRW);
    SetDefaultPropery('Strings');
    RegisterProperty('Objects', 'TObject Integer', iptRW);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterMethod('procedure BeginUpdate;');
    RegisterMethod('procedure EndUpdate;');
    RegisterMethod('function Equals(Strings: TStrings): Boolean;');
    RegisterMethod('procedure Exchange(Index1, Index2: Integer);');
    RegisterMethod('function IndexOfName(Name: string): Integer;');
    if Streams then
      RegisterMethod('procedure LoadFromStream(Stream: TStream); ');
    RegisterMethod('procedure Move(CurIndex, NewIndex: Integer); ');
    if Streams then
      RegisterMethod('procedure SaveToStream(Stream: TStream); ');
    RegisterMethod('procedure SetText(Text: PChar); ');
    RegisterProperty('Names', 'String Integer', iptr);
    RegisterProperty('Values', 'String String', iptRW);
    RegisterMethod('function ADDOBJECT(S:STRING;AOBJECT:TOBJECT):INTEGER');
    RegisterMethod('function GETTEXT:PCHAR');
    RegisterMethod('function INDEXOFOBJECT(AOBJECT:TOBJECT):INTEGER');
    RegisterMethod('procedure INSERTOBJECT(INDEX:INTEGER;S:STRING;AOBJECT:TOBJECT)');
    {$ENDIF}
  end;
end;

procedure SIRegisterTSTRINGLIST(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TSTRINGS'), 'TSTRINGLIST') do
  begin
    RegisterMethod('function FIND(S:STRING;var INDEX:INTEGER):BOOLEAN');
    RegisterMethod('procedure SORT');
    RegisterProperty('DUPLICATES', 'TDUPLICATES', iptrw);
    RegisterProperty('SORTED', 'BOOLEAN', iptrw);
    RegisterProperty('ONCHANGE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONCHANGING', 'TNOTIFYEVENT', iptrw);
  end;
end;

{$IFNDEF IFPS3_MINIVCL}
procedure SIRegisterTBITS(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TObject'), 'TBITS') do
  begin
    RegisterMethod('function OPENBIT:INTEGER');
    RegisterProperty('BITS', 'BOOLEAN INTEGER', iptrw);
    RegisterProperty('SIZE', 'INTEGER', iptrw);
  end;
end;
{$ENDIF}

procedure SIRegisterTSTREAM(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TOBJECT'), 'TSTREAM') do
  begin
    IsAbstract := True;
    RegisterMethod('function READ(BUFFER:STRING;COUNT:LONGINT):LONGINT');
    RegisterMethod('function WRITE(BUFFER:STRING;COUNT:LONGINT):LONGINT');
    RegisterMethod('function SEEK(OFFSET:LONGINT;ORIGIN:WORD):LONGINT');
    RegisterMethod('procedure READBUFFER(BUFFER:STRING;COUNT:LONGINT)');
    RegisterMethod('procedure WRITEBUFFER(BUFFER:STRING;COUNT:LONGINT)');
    RegisterMethod('function COPYFROM(SOURCE:TSTREAM;COUNT:LONGINT):LONGINT');
    RegisterProperty('POSITION', 'LONGINT', iptrw);
    RegisterProperty('SIZE', 'LONGINT', iptrw);
  end;
end;

procedure SIRegisterTHANDLESTREAM(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TSTREAM'), 'THANDLESTREAM') do
  begin
    RegisterMethod('constructor CREATE(AHANDLE:INTEGER)');
    RegisterProperty('HANDLE', 'INTEGER', iptr);
  end;
end;

{$IFNDEF IFPS3_MINIVCL}
procedure SIRegisterTMEMORYSTREAM(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMMEMORYSTREAM'), 'TMEMORYSTREAM') do
  begin
    RegisterMethod('procedure CLEAR');
    RegisterMethod('procedure LOADFROMSTREAM(STREAM:TSTREAM)');
    RegisterMethod('procedure LOADFROMFILE(FILENAME:STRING)');
    RegisterMethod('procedure SETSIZE(NEWSIZE:LONGINT)');
  end;
end;
{$ENDIF}

procedure SIRegisterTFILESTREAM(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('THANDLESTREAM'), 'TFILESTREAM') do
  begin
    RegisterMethod('constructor CREATE(FILENAME:STRING;MODE:WORD)');
  end;
end;

{$IFNDEF IFPS3_MINIVCL}
procedure SIRegisterTCUSTOMMEMORYSTREAM(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TSTREAM'), 'TCUSTOMMEMORYSTREAM') do
  begin
    IsAbstract := True;
    RegisterMethod('procedure SAVETOSTREAM(STREAM:TSTREAM)');
    RegisterMethod('procedure SAVETOFILE(FILENAME:STRING)');
  end;
end;

procedure SIRegisterTRESOURCESTREAM(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMMEMORYSTREAM'), 'TRESOURCESTREAM') do
  begin
    RegisterMethod('constructor CREATE(INSTANCE:THANDLE;RESNAME:STRING;RESTYPE:PCHAR)');
    RegisterMethod('constructor CREATEFROMID(INSTANCE:THANDLE;RESID:INTEGER;RESTYPE:PCHAR)');
  end;
end;

procedure SIRegisterTPARSER(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TOBJECT'), 'TPARSER') do
  begin
    RegisterMethod('constructor CREATE(STREAM:TSTREAM)');
    RegisterMethod('procedure CHECKTOKEN(T:CHAR)');
    RegisterMethod('procedure CHECKTOKENSYMBOL(S:STRING)');
    RegisterMethod('procedure ERROR(IDENT:INTEGER)');
    RegisterMethod('procedure ERRORSTR(MESSAGE:STRING)');
    RegisterMethod('procedure HEXTOBINARY(STREAM:TSTREAM)');
    RegisterMethod('function NEXTTOKEN:CHAR');
    RegisterMethod('function SOURCEPOS:LONGINT');
    RegisterMethod('function TOKENCOMPONENTIDENT:STRING');
    RegisterMethod('function TOKENFLOAT:EXTENDED');
    RegisterMethod('function TOKENINT:LONGINT');
    RegisterMethod('function TOKENSTRING:STRING');
    RegisterMethod('function TOKENSYMBOLIS(S:STRING):BOOLEAN');
    RegisterProperty('SOURCELINE', 'INTEGER', iptr);
    RegisterProperty('TOKEN', 'CHAR', iptr);
  end;
end;

procedure SIRegisterTCOLLECTIONITEM(CL: TIFPSPascalCompiler);
Begin
  if cl.FindClass('TCOLLECTION') = nil then cl.AddClassN(cl.FindClass('TPERSISTENT'), 'TCOLLECTION');
  With cl.AddClassN(cl.FindClass('TPERSISTENT'),'TCOLLECTIONITEM') do
  begin
  RegisterMethod('Constructor CREATE( COLLECTION : TCOLLECTION)');
  RegisterProperty('COLLECTION', 'TCOLLECTION', iptrw);
{$IFDEF IFPS3_D3PLUS}  RegisterProperty('ID', 'INTEGER', iptr); {$ENDIF}
  RegisterProperty('INDEX', 'INTEGER', iptrw);
{$IFDEF IFPS3_D3PLUS}  RegisterProperty('DISPLAYNAME', 'STRING', iptrw); {$ENDIF}
  end;
end;

procedure SIRegisterTCOLLECTION(CL: TIFPSPascalCompiler);
var
  cr: TIFPSCompileTimeClass;
Begin
  cr := CL.FindClass('TCOLLECTION');
  if cr = nil then cr := cl.AddClassN(cl.FindClass('TPERSISTENT'), 'TCOLLECTION');
With cr do
  begin
//  RegisterMethod('Constructor CREATE( ITEMCLASS : TCOLLECTIONITEMCLASS)');
{$IFDEF IFPS3_D3PLUS}  RegisterMethod('Function OWNER : TPERSISTENT'); {$ENDIF}
  RegisterMethod('Function ADD : TCOLLECTIONITEM');
  RegisterMethod('Procedure BEGINUPDATE');
  RegisterMethod('Procedure CLEAR');
{$IFDEF IFPS3_D3PLUS}  RegisterMethod('Procedure DELETE( INDEX : INTEGER)'); {$ENDIF}
  RegisterMethod('Procedure ENDUPDATE');
{$IFDEF IFPS3_D3PLUS}  RegisterMethod('Function FINDITEMID( ID : INTEGER) : TCOLLECTIONITEM'); {$ENDIF}
{$IFDEF IFPS3_D3PLUS}  RegisterMethod('Function INSERT( INDEX : INTEGER) : TCOLLECTIONITEM'); {$ENDIF}
  RegisterProperty('COUNT', 'INTEGER', iptr);
{$IFDEF IFPS3_D3PLUS}  RegisterProperty('ITEMCLASS', 'TCOLLECTIONITEMCLASS', iptr); {$ENDIF}
  RegisterProperty('ITEMS', 'TCOLLECTIONITEM INTEGER', iptrw);
  end;
end;

{$IFDEF IFPS3_D3PLUS}
procedure SIRegisterTOWNEDCOLLECTION(CL: TIFPSPascalCompiler);
Begin
With Cl.AddClassN(cl.FindClass('TCOLLECTION'),'TOWNEDCOLLECTION') do
  begin
//  RegisterMethod('Constructor CREATE( AOWNER : TPERSISTENT; ITEMCLASS : TCOLLECTIONITEMCLASS)');
  end;
end;
{$ENDIF}
{$ENDIF}

procedure SIRegister_Classes_TypesAndConsts(Cl: TIFPSPascalCompiler);
begin
  cl.AddConstantN('soFromBeginning', 'Longint').Value.ts32 := 0;
  cl.AddConstantN('soFromCurrent', 'Longint').Value.ts32 := 1;
  cl.AddConstantN('soFromEnd', 'Longint').Value.ts32 := 2;
  cl.AddConstantN('toEOF', 'Char').Value.tchar := #0;
  cl.AddConstantN('toSymbol', 'Char').Value.tchar := #1;
  cl.AddConstantN('toString', 'Char').Value.tchar := #2;
  cl.AddConstantN('toInteger', 'Char').Value.tchar := #3;
  cl.AddConstantN('toFloat', 'Char').Value.tchar := #4;
  cl.AddConstantN('fmCreate', 'Longint').Value.ts32 := $FFFF;
  cl.AddConstantN('fmOpenRead', 'Longint').Value.ts32 := 0;
  cl.AddConstantN('fmOpenWrite', 'Longint').Value.ts32 := 1;
  cl.AddConstantN('fmOpenReadWrite', 'Longint').Value.ts32 := 2;
  cl.AddConstantN('fmShareCompat', 'Longint').Value.ts32 := 0;
  cl.AddConstantN('fmShareExclusive', 'Longint').Value.ts32 := $10;
  cl.AddConstantN('fmShareDenyWrite', 'Longint').Value.ts32 := $20;
  cl.AddConstantN('fmShareDenyRead', 'Longint').Value.ts32 := $30;
  cl.AddConstantN('fmShareDenyNone', 'Longint').Value.ts32 := $40;
  cl.AddConstantN('SecsPerDay', 'Longint').Value.ts32 := 86400;
  cl.AddConstantN('MSecPerDay', 'Longint').Value.ts32 := 86400000;
  cl.AddConstantN('DateDelta', 'Longint').Value.ts32 := 693594;
  cl.AddTypeS('TAlignment', '(taLeftJustify, taRightJustify, taCenter)');
  cl.AddTypeS('THelpEvent', 'function (Command: Word; Data: Longint; var CallHelp: Boolean): Boolean');
  cl.AddTypeS('TGetStrProc', 'procedure(const S: string)');
  cl.AddTypeS('TDuplicates', '(dupIgnore, dupAccept, dupError)');
  cl.AddTypeS('TOperation', '(opInsert, opRemove)');
  cl.AddTypeS('THANDLE', 'Longint');

  cl.AddTypeS('TNotifyEvent', 'procedure (Sender: TObject)');
end;

procedure SIRegister_Classes(Cl: TIFPSPascalCompiler; Streams: Boolean);
begin
  SIRegister_Classes_TypesAndConsts(Cl);
  if Streams then
    SIRegisterTSTREAM(Cl);
  SIRegisterTStrings(cl, Streams);
  SIRegisterTStringList(cl);
  {$IFNDEF IFPS3_MINIVCL}
  SIRegisterTBITS(cl);
  {$ENDIF}
  if Streams then
  begin
    SIRegisterTHANDLESTREAM(Cl);
    SIRegisterTFILESTREAM(Cl);
    {$IFNDEF IFPS3_MINIVCL}
    SIRegisterTCUSTOMMEMORYSTREAM(Cl);
    SIRegisterTMEMORYSTREAM(Cl);
    SIRegisterTRESOURCESTREAM(Cl);
    {$ENDIF}
  end;
  {$IFNDEF IFPS3_MINIVCL}
  SIRegisterTPARSER(Cl);
  SIRegisterTCOLLECTIONITEM(Cl);
  SIRegisterTCOLLECTION(Cl);
  {$IFDEF IFPS3_D3PLUS}
  SIRegisterTOWNEDCOLLECTION(Cl);
  {$ENDIF}
  {$ENDIF}
end;

// IFPS3_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.
