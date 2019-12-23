//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ntics_storages.h"
#include <ntics_registration.h>
#include "default_frGrid.h"


//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBGridEh"
#pragma link "PrnDbgeh"
#pragma link "FIBDataSet"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"

using namespace :: ntics_storages;
TfrCustomGrid *frCustomGrid;
const int MaxParams = 10; // максимальное количество параметров для DataSet
//---------------------------------------------------------------------------
__fastcall TfrCustomGrid::TfrCustomGrid(TComponent* Owner)
        : TFrame(Owner)
{
  // поиск родительской формы
  while (!dynamic_cast<TForm*>(Owner)) Owner = Owner->Owner;
  // переопределяем событие OnShow
  FFormOnShow = dynamic_cast<TForm *> (Owner)->OnShow;
  dynamic_cast<TForm *> (Owner)->OnShow=FormShow;
}
//---------------------------------------------------------------------------
__fastcall TfrCustomGrid::~TfrCustomGrid()
{
  String SectionName = Name;
  // вычисляем уникальное имя грида
  for (TComponent* AOwner = this;
       !dynamic_cast<TForm*>(Owner);
       AOwner=AOwner->Owner) SectionName = AOwner->Name + "." + SectionName;

  DBGridEh->SaveGridLayoutIni(LocalStorage->FileName,SectionName,True);
  //inherited Destroy;
}

void __fastcall TfrCustomGrid::SetRO()
{
  DBGridEh->ReadOnly = True;
}

void __fastcall TfrCustomGrid::DBGridEhSortMarkingChanged(TObject *Sender)
{
// DataSetParams:array of Variant;
  TDBGridEh* eh = dynamic_cast<TDBGridEh*>(Sender);
  TDataSet* DataSet = eh->DataSource->DataSet;
  String s = "";
  // составляем список полей сортировки
  for (int i=0; i < (eh->SortMarkedColumns->Count); i++)
  {
    if (eh->SortMarkedColumns->Items[i]->Title->SortMarker == smUpEh)
      s = s + eh->SortMarkedColumns->Items[i]->FieldName + " DESC , ";
    else
      s = s + eh->SortMarkedColumns->Items[i]->FieldName + ", ";
  }
  if (s != "") s = " ORDER BY " + s.Delete(s.Length()-1,2);

  // Это TpFIBDataSet
  if (dynamic_cast<TpFIBDataSet*>(DataSet))
  {
    TpFIBDataSet* ds = dynamic_cast<TpFIBDataSet*>(DataSet);
    // save position
    Variant ID = ds->Fields->Fields[0]->Value;
    ds->Close();

    // save params
    int ds_par = ds->Params->Count;
    if (ds_par > MaxParams) throw("Превышение количества параметров DataSet");
    Variant DataSetParams[MaxParams];
    if (ds_par != 0)
      for (int i=0;i < ds_par;i++)
        DataSetParams[i] = ds->Params->Vars[i]->Value;

    // Set new sorting
    ds->SQLs->SelectSQL->Strings[ds->SQLs->SelectSQL->Count - 1] = s;

    // restore params
    if (ds_par != 0)
      for (int i=0;i < ds_par;i++)
        ds->Params->Vars[i]->Value = DataSetParams[i];

    ds->Open();
    TLocateOptions Opts;
    Opts.Clear();
    ds->Locate(ds->Fields->Fields[0]->FieldName,ID,Opts);
   }
}

//---------------------------------------------------------------------------
void __fastcall TfrCustomGrid::FormShow(TObject *Sender)
{
  DBNavigator1->DataSource = DBGridEh->DataSource;
  TComponent* AOwner = this;
  String SectionName = AOwner->Name;

  // вычисляем уникальное имя грида
  do {
    AOwner = AOwner->Owner;
    SectionName = AOwner->Name + "." + SectionName;
  } while (!dynamic_cast<TForm*>(Owner));

  TDBGridEhRestoreParams  Opts;
  Opts.Clear();
  Opts << grpColIndexEh << grpColWidthsEh << grpSortMarkerEh << grpColVisibleEh << grpRowHeightEh;

  DBGridEh->RestoreGridLayoutIni(LocalStorage->FileName,SectionName,Opts);
  if (FFormOnShow) FFormOnShow(Sender);
}

void __fastcall TfrCustomGrid::SpeedButton1Click(TObject *Sender)
{
  PrintDBGridEh->Title->Add("Таблица: " + DBGridEh->DataSource->DataSet->Name);
  PrintDBGridEh->Title->Add("Time: " + DateTimeToStr(Now()));
  //PrintDBGridEh->Title->Add("User: " + Registration::CurrentUserName);
  //PrintDBGridEh.Title.Add('DataBase User: ' + IBLogin.UserName);
  PrintDBGridEh->Preview();
}
//---------------------------------------------------------------------------

