program sample8;

uses
  ifpscomp,
  ifps3,
  ifps3utl,

  Dialogs

  ;

procedure MyOwnFunction(const Data: string);
begin
  // Do something with Data
  ShowMessage(Data);
end;

function ScriptOnExportCheck(Sender: TIFPSPascalCompiler; Proc: TIFPSInternalProcedure; const ProcDecl: string): Boolean;
{
  The OnExportCheck callback function is called for each function in the script
  (Also for the main proc, with '!MAIN' as a Proc^.Name). ProcDecl contains the
  result type and parameter types of a function using this format:
  ProcDecl: ResultType + ' ' + Parameter1 + ' ' + Parameter2 + ' '+Parameter3 + .....
  Parameter: ParameterType+TypeName
  ParameterType is @ for a normal parameter and ! for a var parameter.
  A result type of 0 means no result.
}
begin
  if Proc.Name = 'TEST' then // Check if the proc is the Test proc we want.
  begin
    if not ExportCheck(Sender, Proc, [btString, btString], [pmIn]) then // Check if the proc has the correct params.
    begin
      { Something is wrong, so cause an error. }
      Sender.MakeError('', ecTypeMismatch, '');
      Result := False;
      Exit;
    end;
    Proc.aExport := etExportDecl;
    { Export the proc with Decl Mode; This is needed because IFPS doesn't store the
    typeinfo for this function by default }
    Result := True;
  end else Result := True;
end;

function ScriptOnUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
{ the OnUses callback function is called for each "uses" in the script.
  It's always called with the parameter 'SYSTEM' at the top of the script.
  For example: uses ii1, ii2;
  This will call this function 3 times. First with 'SYSTEM' then 'II1' and then 'II2'.
}
begin
  if Name = 'SYSTEM' then
  begin

    Sender.AddDelphiFunction('procedure MyOwnFunction(Data: string)');
    { This will register the function to the script engine. Now it can be used from within the script. }


    Result := True;
  end else
    Result := False;
end;

type
  TTestFunction = function (const s: string): string of object;
  // Header of the test function, added of object. 

procedure ExecuteScript(const Script: string);
var
  Compiler: TIFPSPascalCompiler;
  { TIFPSPascalCompiler is the compiler part of the scriptengine. This will
    translate a Pascal script into a compiled for the executer understands. }
  Exec: TIFPSExec;
   { TIFPSExec is the executer part of the scriptengine. It uses the output of
    the compiler to run a script. }
  Data: string;

  TestFunc: TTestFunction;
begin
  Compiler := TIFPSPascalCompiler.Create; // create an instance of the compiler.
  Compiler.OnUses := ScriptOnUses; // assign the OnUses event.

  Compiler.OnExportCheck := ScriptOnExportCheck; // Assign the onExportCheck event.

  Compiler.AllowNoBegin := True;
  Compiler.AllowNoEnd := True; // AllowNoBegin and AllowNoEnd allows it that begin and end are not required in a script. 

  if not Compiler.Compile(Script) then  // Compile the Pascal script into bytecode.
  begin
    Compiler.Free;
     // You could raise an exception here.
    Exit;
  end;

  Compiler.GetOutput(Data); // Save the output of the compiler in the string Data.
  Compiler.Free; // After compiling the script, there is no need for the compiler anymore.

  Exec := TIFPSExec.Create;  // Create an instance of the executer.

  Exec.RegisterDelphiFunction(@MyOwnFunction, 'MYOWNFUNCTION', cdRegister);
  { This will register the function to the executer. The first parameter is the executer. The second parameter is a
    pointer to the function. The third parameter is the name of the function (in uppercase). And the last parameter is the
    calling convention (usually Register). This function can be found in the ifpidelphiruntime.pas file. }

  if not Exec.LoadData(Data) then // Load the data from the Data string.
  begin
    { For some reason the script could not be loaded. This is usually the case when a 
      library that has been used at compile time isn't registered at runtime. }
    Exec.Free;
     // You could raise an exception here.
    Exit;
  end;

  TestFunc := TTestFunction(Exec.GetProcAsMethodN('Test'));
  if @TestFunc <> nil then
    ShowMessage('Result from TestFunc(''test indata''): '+TestFunc('test indata'));

  Exec.Free; // Free the executer.
end;



const
  Script = 'function test(s: string): string; begin MyOwnFunction(''Test Called with param: ''+s); Result := ''Test Result: ''+s; end;';

begin
  ExecuteScript(Script);
end.
