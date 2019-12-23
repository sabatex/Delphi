unit fCustomForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmCustomForm = class(TForm)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; FormName: string);reintroduce;overload;
    { Public declarations }
  end;

var
  frmCustomForm: TfrmCustomForm;

implementation

{$R *.dfm}

constructor TfrmCustomForm.Create(AOwner: TComponent; FormName: string);
var
 i:integer;
begin
 for i:=0 to Screen.FormCount - 1 do
  if Screen.Forms[i].Caption = FormName then
  begin
   Screen.Forms[i].BringToFront;
   Exit;
  end;
 Create(AOwner);
 Caption:=FormName;
end;

end.
