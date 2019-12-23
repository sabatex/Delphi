//---------------------------------------------------------------------------

#pragma hdrstop

#include "ntics_forms.h"

//---------------------------------------------------------------------------

#pragma package(smart_init)

const String Form_Left = "Left";
const String Form_Heigth = "Heigth";
const String Form_Top = "Top";
const String Form_Width = "Width";

using namespace :: ntics_forms;

class TFormManager: public TComponent
{
 public:
    bool isFormSave;
    TFormType FormType;
    TCloseEvent OldEvent;
    void __fastcall FormSave(void);
    void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
    __fastcall TFormManager(TComponent* AOwner);
    //__fastcall virtual ~TFormManager(void){ if (!isFormSave) FormSave();};
};

__fastcall TFormManager::TFormManager(TComponent* AOwner)
        : TComponent(AOwner)
{
  isFormSave = false;
}

void __fastcall TFormManager::FormSave(void)
{
  TForm* form = dynamic_cast<TForm*>(Owner);
  String s = form->Name;
  Registration::SaveValue(s+ Form_Heigth,form->Height);
  Registration::SaveValue(s+ Form_Width,form->Width);
  Registration::SaveValue(s+Form_Top,form->Top);
  Registration::SaveValue(s + Form_Left,form->Left);
  isFormSave = true;
}

void __fastcall TFormManager::FormClose(TObject *Sender, TCloseAction &Action)
{
  // ����� ����� ������� ???
  if (OldEvent) OldEvent(Sender,Action);

  // ��������� ��������� �����
  FormSave();

  // ���� �� ����� ����� � ��������� �� ���������
  //SaveGrids(Sender,s);

  // ���� ����� �� ��������� �� ���������
  TFormState fs; fs.Clear(); fs << fsModal;
  if (FormType == ftMDI) Action=caFree;
}



void RestoreForm(TForm* Form)
{
  String s = Form->Name;
  Form->Height = StrToInt(Registration::LoadValue(s+Form_Heigth,Form->Height));
  Form->Width = StrToInt(Registration::LoadValue(s+Form_Width,Form->Width));
  Form->Top = StrToInt(Registration::LoadValue(s+Form_Top,Form->Top));
  Form->Left = StrToInt(Registration::LoadValue(s + Form_Left,Form->Left));
}

void __fastcall AddEvent(TForm* Form, TFormType FormType)
{
  // ���� ������� ���������� �� ��������� ��� � ����� �������
  // ���������� ������� �� �������
  TFormManager* FormManager = new TFormManager(Form);
  FormManager->OldEvent = Form->OnClose;
  FormManager->FormType = FormType;
  Form->OnClose = &FormManager->FormClose;
}


Forms::TForm* __fastcall  ntics_forms::ShowForm(TMetaClass* ClassForm, AnsiString FormName, TFormType FormType, bool One)
{
  // ���������, ���������� �� ����� �����. ������� �.
  if (One)
  {
    for (int i=0;i < Screen->FormCount;i++)
    {
      if (Screen->Forms[i]->Caption == FormName)
      {
        Screen->Forms[i]->BringToFront();
        return 0;
      }
    }
  }

  // �������� �����
  TForm* Result;
  Application->CreateForm(ClassForm,&Result);
  Result->Caption = FormName;
  switch (FormType){
    case ftNormal:{RestoreForm(Result); Result->Show();break;}
    case ftMDI: {Result->FormStyle = fsMDIChild; RestoreForm(Result);break;}
    case ftModal: {RestoreForm(Result); Result->ShowModal();break;}
  }
  AddEvent(Result,FormType);
  return Result;
}

void __fastcall ntics_forms::CloseChildForms(TForm* MainMDI)
{
  Registration::EraseSection("STOREFORMS");
  Registration::SaveValue("STOREFORMS","Forms",IntToStr(MainMDI->MDIChildCount));
  for(int i = MainMDI->MDIChildCount-1; i >= 0; i--)
  {
    Registration::SaveValue("STOREFORMS","Form"+IntToStr(i),MainMDI->MDIChildren[i]->ClassName());
    Registration::SaveValue("STOREFORMS","FormName"+IntToStr(i),MainMDI->MDIChildren[i]->Caption);
    MainMDI->MDIChildren[i]->Close();
  }
}

void __fastcall ntics_forms::RestoreChildForms(void)
{
  int i = StrToInt(Registration::LoadValue("STOREFORMS","Forms","0"));
  while (i>=0)
  {
    i--;
    String Form = Registration::LoadValue("STOREFORMS","Form"+IntToStr(i),"");
    String FormName = Registration::LoadValue("STOREFORMS","FormName"+IntToStr(i),"");
    TMetaClass *MetaClass = GetClass(Form);
    if (MetaClass) ShowForm(MetaClass,FormName,ftMDI);
  }
}