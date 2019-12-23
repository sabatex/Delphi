unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, Menus, ExtCtrls,
  StdCtrls, FileCtrl, SynEditMiscClasses, inifiles,
  ComCtrls, ImgList, ToolWin;

type
  TfrmMain = class(TForm)
    OpenDialog1: TOpenDialog;
    pashighlighter: TSynPasSyn;
    mnuMain: TMainMenu;
    File1: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    N4: TMenuItem;
    mnuExit: TMenuItem;
    lboMessages: TListBox;
    Splitter1: TSplitter;
    Convert1: TMenuItem;
    mnuConvert: TMenuItem;
    N1: TMenuItem;
    mnuSettings: TMenuItem;
    TabControl1: TTabControl;
    Editor: TSynEdit;
    mnuSaveAll: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ImageList1: TImageList;

    procedure EditorDropFiles(Sender: TObject; X, Y: Integer;   AFiles: TStrings);

    procedure FormCreate(Sender: TObject);
    procedure AnyCommand(Sender: TObject);
    procedure mnuSettingsClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure TabControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure EditorChange(Sender: TObject);
  private
    { Private declarations }
    fIniFile    : TIniFile;
    fLoading    : Boolean;
    FModified   : Boolean;
    FFile       : string;
    fOutputDir  : String;
    fPrifix : String;
    FUseUnitAtDT: Boolean;
    FSingleUnit : Boolean;

    procedure Convert;
  public
    function SaveCheck: Boolean;
    Procedure LoadFile(aFileName:String);
    procedure SaveFiles(AllFiles:Boolean);
    procedure WriteLn(const s : string);
    procedure ReadLn(var s : string;const Promote,Caption : string);
    procedure ExecCmd(Cmd: Integer);
  end;

var
  frmMain: TfrmMain;

implementation


{$R *.dfm}

uses
  ParserU, FormSettings;

const
  OPEN_CMD        = 100;
  SAVE_CMD        = 101;
  SAVE_ALL_CMD    = 102;
  EXIT_CMD        = 103;
  CONVERT_CMD     = 104;

{ globals }
(*----------------------------------------------------------------------------*)
function  DateTimeToFileName(const DT: TDateTime; UseMSecs: Boolean = False): string;
begin
  case UseMSecs of
    False : Result := FormatDateTime('yyyy-mm-dd_hh_nn_ss', DT);
    True  : Result := FormatDateTime('yyyy-mm-dd_hh_nn_ss_zzz', DT);
  end;
end;
(*----------------------------------------------------------------------------*)
function NormalizePath(const Path: string): string;
begin
  Result := Path;
  case Length(Result) of
    0 : {AppError('Path can not be an empty string')};
    1 : if (UpCase(Result[1]) in ['A'..'Z']) then
          Result := Result + ':\';
    2 : if (UpCase(Result[1]) in ['A'..'Z']) then
          if Result[2] = ':' then
            Result := Result + '\';
    else
        if not (Result[Length(Result)] = '\') then
           Result := Result + '\';
  end;
end;


{ methods }
(*----------------------------------------------------------------------------*)
function TfrmMain.SaveCheck: Boolean;
begin
  if FModified then
  begin
    case MessageDlg('File has not been saved, save now?', mtConfirmation, mbYesNoCancel, 0) of
      idYes:
        begin
          ExecCmd(SAVE_CMD);
          Result := FFile <> '';
        end;
      IDNO: Result := True;
      else
        Result := False;
    end;
  end else Result := True;
end;
(*----------------------------------------------------------------------------*)
procedure TfrmMain.Convert;
var
  Parser : TUnitParser;
  Path   : string;
  OldTab : Integer;
  List   : TStringList;
  AllowChange : Boolean;
begin
  OldTab := TabControl1.TabIndex;
  TabControl1Changing(Self, AllowChange);
  TabControl1.TabIndex := -1;
  lboMessages.Clear;

  Parser := TUnitParser.Create('conv.ini');
  try
    Parser.WriteLn     := WriteLn;
    Parser.ReadLn      := ReadLn;
    Parser.UseUnitAtDT := FUseUnitAtDT;
    Parser.SingleUnit  := FSingleUnit;

    try
      Parser.ParseUnit((Tabcontrol1.tabs.Objects[1] as tStringList).Text);
      WriteLn('Succesfully parsed');
    except
      on E: Exception do
      begin
        WriteLn('Exception:'+ E.Message);
        Exit;
      end;
    end;
    While TabControl1.tabs.Count >2 Do TabControl1.tabs.Delete(2);
    Path := NormalizePath(Trim(FOutPutDir));

{    if not DirectoryExists(Path) then
    begin
      Path := NormalizePath(ExtractFilePath(Application.ExeName) + DateTimeToFileName(Now, False));
      FOutPutDir := Path;
    end;

    ForceDirectories(Path);
    Parser.SaveToPath(Path);}
    if FSingleUnit then
    begin
      list := TstringList.create;
      TabControl1.tabs.AddObject(parser.UnitNameCmp,list);
      List.Text := parser.OutUnitList.Text;
      List.SaveToFile(Path + parser.UnitNameCmp);
    end else begin
      List := TStringList.Create;
      List.Text := parser.OutputRT;
      List.SaveToFile(Path + parser.UnitnameRT);
      TabControl1.tabs.AddObject(parser.UnitnameRT,list);

      List := TStringList.Create;
      List.Text := parser.OutputDT;
      List.SaveToFile(Path + parser.UnitnameCT);
      TabControl1.tabs.AddObject(parser.UnitnameCT,list);
    end;
    WriteLn('Files saved');
  finally
    Parser.Free;
    TabControl1.TabIndex := OldTab;
    TabControl1Change(Self);
  end;

end;

(*----------------------------------------------------------------------------*)
procedure TfrmMain.ReadLn(var s: string; const Promote, Caption: string);
begin
  s := InputBox(Caption, Promote, s)
end;

(*----------------------------------------------------------------------------*)
procedure TfrmMain.WriteLn(const s: string);
begin
  lboMessages.Items.Add(s);
end;

{ events }

(*----------------------------------------------------------------------------*)
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  fLoading   := false;
  fIniFile   := TIniFile.create(ExtractFilePath(Application.ExeName)+'Default.ini');
  Try
    fOutPutDir   := fIniFile.ReadString('Main','OutputDir',
                                        ExtractFilePath(Application.ExeName) + 'Import\');
    FSingleUnit  := fIniFile.ReadBool('Main','SingleUnit',True);
    FUseUnitAtDT := fIniFile.ReadBool('Main','UseUnitAtDT',False);
    fPrifix      := fIniFile.ReadString('Main','FilePrefix', 'IFSI');
  finally
    fIniFile.Free;
  end;
  ForceDirectories(fOutPutDir);

  mnuOpen       .Tag := OPEN_CMD      ;
  mnuSave       .Tag := SAVE_CMD      ;
  mnuSaveAll    .Tag := SAVE_ALL_CMD   ;
  mnuExit       .Tag := EXIT_CMD      ;
  mnuConvert    .Tag := CONVERT_CMD   ;

  If ParamCount>0 then
    LoadFile(Paramstr(1));
end;

(*----------------------------------------------------------------------------*)
procedure TfrmMain.EditorDropFiles(Sender: TObject; X, Y: Integer; AFiles: TStrings);
begin
  LoadFile(AFiles[0]);
end;

(*----------------------------------------------------------------------------*)
procedure TfrmMain.AnyCommand(Sender: TObject);
begin
  ExecCmd(TComponent(Sender).Tag);
end;

(*----------------------------------------------------------------------------*)
procedure TfrmMain.ExecCmd(Cmd: Integer);

begin
  case Cmd of
    OPEN_CMD       : begin
                       if SaveCheck then
                       begin
                         if OpenDialog1.Execute then
                         begin
                           Editor.ClearAll;
                           LoadFile(OpenDialog1.FileName);
                           Editor.Modified := False;
                           FFile := OpenDialog1.FileName;
                         end;
                       end;
                     end;
    SAVE_CMD       : begin
                       if FFile <> '' then
                       begin
                         SaveFiles(False);
                         Editor.Modified := False;
                       end;
                     end;
    SAVE_ALL_CMD    : begin
                       if FFile <> '' then
                       begin
                         SaveFiles(True);
                         Editor.Modified := False;
                       end;
                     end;
    EXIT_CMD       : Close;
    CONVERT_CMD    : Convert;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TfrmMain.mnuSettingsClick(Sender: TObject);
begin
  with TfrmSettings.create(nil) do begin
    try
      cbCreateOneImportfile.Checked  := FSingleUnit;
      cbUseUnitAtCompileTime.Checked := FUseUnitAtDT;
      edtOutPutDir.Text              := fOutputDir;
      edtPrefix.Text                 := fPrifix;
      If ShowModal = mrOk then begin
        FSingleUnit  := cbCreateOneImportfile.Checked;
        FUseUnitAtDT := cbUseUnitAtCompileTime.Checked;
        fOutputDir   := edtOutPutDir.Text;
        fPrifix      := edtPrefix.Text;
        If default.Checked then begin
          fIniFile   := TIniFile.create(ExtractFilePath(Application.ExeName)+'Default.ini');
          Try
            fIniFile.WriteString('Main','OutputDir', fOutputDir);
            fIniFile.WriteBool('Main','SingleUnit' , FSingleUnit);
            fIniFile.WriteBool('Main','UseUnitAtDT', FUseUnitAtDT);
            fIniFile.WriteString('Main','FilePrefix', fPrifix);
          finally
            fIniFile.Free;
          end;
        end;
        if ffile <> '' then begin
          fIniFile  := TIniFile.create(ChangeFileExt(FFile,'.iip'));
          Try
            fIniFile.WriteString('Main','OutputDir', fOutputDir);
            fIniFile.WriteBool('Main','SingleUnit',FSingleUnit);
            fIniFile.WriteBool('Main','UseUnitAtDT',FUseUnitAtDT);
            fIniFile.WriteString('Main','FilePrefix', fPrifix);
          finally
            fIniFile.Free;
          end;
        end;
        FModified := True;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.LoadFile(aFileName: String);
var
  AllowChange : Boolean;

  Function getTekst(AFile:String):TStringList;
  begin
    Result := TStringList.Create;
    Result.LoadFromFile(aFile);
  end;
begin
  FFile := aFileName;
  fIniFile   := TIniFile.create(ChangeFileExt(FFile,'.iip'));
  Try
    fOutPutDir   := fIniFile.ReadString('Main','OutputDir',fOutPutDir);
    FFile        := fIniFile.ReadString('Files','File0', fFile);
    FSingleUnit  := fIniFile.ReadBool('Main','SingleUnit',FSingleUnit);
    FUseUnitAtDT := fIniFile.ReadBool('Main','UseUnitAtDT',FUseUnitAtDT);
    fPrifix      := fIniFile.ReadString('Main','FilePrefix', fPrifix);
  finally
    fIniFile.Free;
  end;
  TabControl1.tabs.Text := '';
  TabControl1Changing(Self, AllowChange);
  TabControl1.tabs.AddObject(ExtractFileName(FFile),GetTekst(FFile));
  aFileName := fOutPutDir+ChangeFileExt(ExtractFileName(FFile),'.int');
  If FileExists(aFileName) then
    TabControl1.tabs.AddObject(ExtractFileName(aFileName),GetTekst(aFileName))
  else
    TabControl1.tabs.AddObject(ExtractFileName(aFileName),GetTekst(FFile));
  TabControl1.TabIndex := 1;
  TabControl1Change(Self);
end;

procedure TfrmMain.SaveFiles;
var
  oldTab, x : Integer;

  Procedure DoSave(TabId : Integer);
  begin
    If pos('*',Tabcontrol1.tabs[Tabid])<>0 then
      Tabcontrol1.tabs[Tabid] := StringReplace(Tabcontrol1.tabs[Tabid],' *','',[]);
    (Tabcontrol1.tabs.Objects[TabId] as tStringList).SaveToFile(fOutputDir+Tabcontrol1.tabs[Tabid]);
  end;

begin
  OldTab := TabControl1.TabIndex;
  TabControl1.TabIndex := -1;
  Try
    fIniFile  := TIniFile.create(ChangeFileExt(FFile,'.iip'));
    Try
      fIniFile.WriteString('Main','OutputDir', fOutputDir);
      fIniFile.WriteString('Files','File0', fFile);
      fIniFile.WriteBool('Main','SingleUnit',FSingleUnit);
      fIniFile.WriteBool('Main','UseUnitAtDT',FUseUnitAtDT);
      fIniFile.WriteString('Main','FilePrefix', fPrifix);
    finally
      fIniFile.Free;
    end;
    FModified := False;
    If AllFiles then begin
      for x := 0 to Tabcontrol1.tabs.Count -1 do begin
        If pos('*',Tabcontrol1.tabs[x])<>0 then DoSave(x);
      end;
    end else begin
      DoSave(OldTab);
      for x := 0 to Tabcontrol1.tabs.Count -1 do begin
        If pos('*',Tabcontrol1.tabs[x])<>0 then FModified := True;
      end;
    end;
  finally
    TabControl1.TabIndex := OldTab;
  end;
end;

procedure TfrmMain.TabControl1Change(Sender: TObject);
begin
  fLoading := True;
  Try
    If Tabcontrol1.TabIndex = -1 then begin
      Editor.Lines.Text := '';
    end else begin
      Editor.Lines.Assign(Tabcontrol1.tabs.Objects[Tabcontrol1.TabIndex] as tStringList);
      Editor.ReadOnly := Tabcontrol1.TabIndex <= 0;
      Editor.Modified := false;
    end;
  finally
    fLoading := False;
  end;
end;

procedure TfrmMain.TabControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:= True;
  If Tabcontrol1.TabIndex = -1 then exit;
  (Tabcontrol1.tabs.Objects[Tabcontrol1.TabIndex]as tStringList).Assign(Editor.Lines);
end;

procedure TfrmMain.EditorChange(Sender: TObject);
begin
  If Not FLoading then begin
    FModified := True;
    If pos('*',Tabcontrol1.tabs[Tabcontrol1.TabIndex])=0 then
      Tabcontrol1.tabs[Tabcontrol1.TabIndex] := Tabcontrol1.tabs[Tabcontrol1.TabIndex]+' *';
  end;
end;

end.
