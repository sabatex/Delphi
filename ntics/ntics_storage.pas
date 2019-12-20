unit ntics_storage;
interface
uses   Windows,SysUtils,Forms,IniFiles,Classes;

type
  TStorage = class(TIniFile)
  private
  public
    procedure SaveOpenChildForms(); // Сохранение открытых дочерных форм
    procedure RestoreChildForms(); // Востановление сохранённых дочерных форм
    procedure SaveCrypt(Section,Ident,Value:string);virtual;
    function LoadCrypt(Section,Ident,Default:string):string;virtual;
  end;


var
  // Центральное хранилище параметров программы
  NetStorage:TStorage;
  LocalStorage:TStorage;
  DefaultSection:string;




implementation
uses ntics_const;

function GetDefaultIniName: string;
begin
  Result:=ExtractFileName(Application.ExeName);
  Result:=copy(Result,1,pos('.',Result))+'cfg';
end;

{ TStorage }

function TStorage.LoadCrypt(Section, Ident, Default: string): string;
begin
  Result:=ReadString(Section,Ident,Default);
end;

procedure TStorage.RestoreChildForms;
var
  i:Integer;
  Form,FormName:string;
  ClassForm:TComponentClass;
  FForm:TForm;
begin
  i := ReadInteger('STOREFORMS','Forms',0);
  while i>=0 do
  begin
    dec(i);
    Form := ReadString('STOREFORMS','Form'+IntToStr(i),'');
    FormName := ReadString('STOREFORMS','FormName'+IntToStr(i),'');
    ClassForm := TComponentClass(GetClass(Form));
    if Assigned(ClassForm) then Application.CreateForm(ClassForm,FForm);
  end;
end;

procedure TStorage.SaveCrypt(Section, Ident, Value: string);
begin
  WriteString(Section,Ident,Value);
end;

procedure TStorage.SaveOpenChildForms;
var
  i:integer;
begin
  with Application.MainForm do
  begin
    EraseSection('STOREFORMS');
    WriteInteger('STOREFORMS','Forms',MDIChildCount);
    i:=MDIChildCount-1;
    while i>=0 do
    begin
      WriteString('STOREFORMS','Form'+IntToStr(i),MDIChildren[i].ClassName());
      WriteString('STOREFORMS','FormName'+IntToStr(i),MDIChildren[i].Caption);
      MDIChildren[i].Close();
      dec(i);
    end;
  end;
end;

initialization
  LocalStorage:=TStorage.Create(ExtractFilePath(Application.ExeName)+GetDefaultIniName);
  NetStorage := LocalStorage;
  DefaultSection:='Defoult'; // Set function to return user name

end.
