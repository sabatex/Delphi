{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10987: Options.pas 
{
{   Rev 1.1    06.12.2002 16:41:58  Work
}
{
{   Rev 1.0    28.11.2002 15:05:28  Work
}
{
{   Rev 1.2    27.09.2002 16:50:28  Work
}
{
{   Rev 1.1    26.09.2002 17:01:02  Work
}
{
{   Rev 1.0    26.09.2002 11:28:54  Work
}
unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DdeMan, StdCtrls,Registry, ExtCtrls, ComCtrls,  
  DCPcrypt2, DCPGost, DCPSHA1,inifiles, Grids, DBGridEh, DB, DBCtrls,
  frameCustomGrid, Buttons, Mask;

type
  TOptionsDlg = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    frCustomGrid1: TfrCustomGrid;
    frCustomGrid3: TfrCustomGrid;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsDlg: TOptionsDlg;
  inifile:TIniFile;

implementation

uses Main, fDM8DR;

{$R *.DFM}

procedure TOptionsDlg.FormDestroy(Sender: TObject);
begin
 inifile.Free;
end;

procedure TOptionsDlg.SpeedButton1Click(Sender: TObject);
begin
  {DM8DR.SaveAsConfig;}
end;

procedure TOptionsDlg.SpeedButton2Click(Sender: TObject);
begin
  {DM8DR.LoadAsConfig;}
end;

end.
