unit fSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, ComCtrls, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSplash = class(TForm)
    Panel1: TPanel;
    LVersion: TLabel;
    lProductName: TLabel;
    StatusLabel: TLabel;
    Image1: TImage;
  private
    { Private declarations }
  public
    class procedure ShowSplash(Msg:string);
    class procedure SplashFree;
  end;


implementation
{$G+}
{$R *.DFM}
uses FileVersionInfo;

var
  Splash:TfrmSplash;

class procedure TfrmSplash.ShowSplash(Msg:string);
var
   FVersion:TFileVersionInfo;
begin
  if not Assigned(Splash) then
  begin
    Splash:=TfrmSplash.Create(nil);
    {try
      Splash.Image1.Picture.Bitmap.LoadFromResourceName(HInstance ,'FIRMLOGO');
    except
    end;}
    FVersion:=TFileVersionInfo.Create(ExtractFileName(Application.ExeName));
    Splash.LVersion.Caption  :='Version ' +  FVersion.FileVersion;
    Splash.LProductName.Caption:=FVersion.ProductName;
    //Splash.lProductName.Caption:=LoadResString('PRODUCTNAME');
    FVersion.Free;
    Splash.Show;
  end;
  Splash.StatusLabel.Caption:=Msg;
  Splash.Refresh;
end;

class procedure TfrmSplash.SplashFree;
begin
  if Assigned(Splash) then
    Splash.Free;
  Splash:=nil;
end;

end.

