{******************************************************************************}
{* WARNING:  JEDI VCL To CLX Converter generated unit.                        *}
{*           Manual modifications will be lost on next release.               *}
{******************************************************************************}

program InspectorSimpleExample;

uses
  QForms,
  InspectorSimpleExampleMain in 'InspectorSimpleExampleMain.pas' {SimpleMainForm},
  JvQDoubleBuffering in 'JvQDoubleBuffering.pas',
  JvQEventFilter in 'JvQEventFilter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSimpleMainForm, SimpleMainForm);
  Application.Run;
end.
