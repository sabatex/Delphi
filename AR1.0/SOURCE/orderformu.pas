{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10989: orderformu.pas 
{
{   Rev 1.0    28.11.2002 15:05:28  Work
}
{
{   Rev 1.0    26.09.2002 11:28:54  Work
}
unit orderformu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, fcButton, fcImgBtn, fcImage, fcImageForm, StdCtrls, ComCtrls,
  fcImager, RichEdit, ShellApi, fcDemoRichEdit, fcShapeBtn,
  fcClearPanel, fcButtonGroup, fcOutlookBar;

type
  TOrderForm = class(TForm)
    fcImageForm1: TfcImageForm;
    AboutButton: TfcImageBtn;
    OrderingButton: TfcImageBtn;
    PricesButton: TfcImageBtn;
    CloseBtn: TfcImageBtn;
    fcImager1: TfcImager;
    DragControl: TImage;
    fcOutlookBar1: TfcOutlookBar;
    Prices: TfcShapeBtn;
    Ordering: TfcShapeBtn;
    About: TfcShapeBtn;
    RichEditOrdering: TfcDemoRichEdit;
    RichEditAbout: TfcDemoRichEdit;
    RichEditPrices: TfcDemoRichEdit;
    procedure CloseBtnClick(Sender: TObject);
    procedure PricesButtonClick(Sender: TObject);
    procedure OrderingButtonClick(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
    procedure RichEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetWordFromPoint(CurRichEdit:TCustomRichEdit; X, Y: Integer): String;
  end;

var
  OrderForm: TOrderForm;

implementation

{$R *.DFM}


procedure TOrderForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TOrderForm.PricesButtonClick(Sender: TObject);
begin
   fcOutlookBar1.ActivePage := Prices;
end;

procedure TOrderForm.OrderingButtonClick(Sender: TObject);
begin
   fcOutlookBar1.ActivePage := Ordering;
end;

procedure TOrderForm.AboutButtonClick(Sender: TObject);
begin
   fcOutlookBar1.ActivePage := About;
end;

{Get RichEdit Word From Point}
function TOrderForm.GetWordFromPoint(CurRichEdit:TCustomRichEdit; X, Y: Integer): String;
type TCharSet = Set of Char;
var CurSel: Integer;
    Line: Integer;
    LineIndex: Integer;
    CurLineStr: string;
    Offset: Integer;
    p: TPoint;
    startWord: integer;

    //Get position of start of the current word.
    function GetStartOfWord(Subset: TCharSet; s: string; Index: integer): integer;
    begin
      if Index = 0 then Index := Length(s);
      for result := Index - 1 downto 1 do
         if s[result] in Subset then break;
    end;
begin
  p := Point(x, y);
  CurSel := SendMessage(CurRichEdit.Handle, EM_CHARFROMPOS, 0, LParam(@p));
  Line := SendMessage(CurRichEdit.Handle, EM_EXLINEFROMCHAR, 0, CurSel);
  CurLineStr := CurRichEdit.Lines[Line];
  LineIndex := SendMessage(CurRichEdit.Handle, EM_LINEINDEX, Line, 0);

  Offset := CurSel - LineIndex;
  if (Offset > 0) and (CurLineStr[Offset] = ' ') then inc(Offset);

  startWord:= GetStartOfWord([' ',#9], CurLineStr, Offset + 1) + 1;
  //Loop from current offset til next whitespace.
  while not (curLineStr[offset] in [' ', #9, #13, #10]) do begin
    inc(offset);
    if (offset>=length(curLineStr)) then break;
  end;

  result := Copy(CurLineStr, startWord, offset-startWord)
end;

{Change cursor when over a recognized url link}
procedure TOrderForm.RichEdit1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 if (GetWordFromPoint((Sender as TCustomRichEdit),X,Y) = 'http://www.woll2woll.com') or
    (GetWordFromPoint((Sender as TCustomRichEdit),X,Y) = 'sales@woll2woll.com') then
    (Sender as TCustomRichEdit).Cursor := crHandPoint
 else
    (Sender as TCustomRichEdit).Cursor := crDefault;
end;

procedure TOrderForm.RichEdit1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Check for url links and execute them}
  if GetWordFromPoint((Sender as TCustomRichEdit),X,Y) = 'http://www.woll2woll.com' then
     ShellExecute(Handle, 'OPEN',
     PChar('https://www.he.net/cgi-bin/suid/~wol2wol/ordering/order.cgi'), nil, nil, sw_shownormal)
  else if GetWordFromPoint((Sender as TCustomRichEdit),X,Y) = 'sales@woll2woll.com' then
     ShellExecute(Handle, 'OPEN',
     PChar('mailto:sales@woll2woll.com'), nil, nil, sw_shownormal)
end;


end.
