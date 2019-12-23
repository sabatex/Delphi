unit ntics_interpreter_const;
interface

const
  {The name of the main proc }
  IFPSMainProcName = '!MAIN';
  {The original name for the main proc, can be used for user purposes}
  IFPSMainProcNameOrg = 'Main Proc';
{ The lowest supported build by the executer. }
  IFPSLowBuildSupport = 12;
{ The current build of the compiler and executer. }
  IFPSCurrentBuildNo = 22;
{ The current version of the script engine }
  IFPSCurrentversion = '1.30';
{ The header of a compiled IFPS3 binary must start with this }
  IFPSValidHeader = 1397769801;
{ Start of the positive stack }
  IFPSAddrStackStart = 1610612736;
{ Start of the negative stack }
  IFPSAddrNegativeStackStart = 1073741824;


{ Executer internal type for return addresses, can not be used as a type }
  btReturnAddress = 0;
  btU8 = 1; // A 1 byte unsigned integer (byte)
  btS8 = 2;{ A 1 byte signed integer (Shortint) }
  btU16 = 3;{ A 2 byte unsigned integer (word) }
  btS16 = 4; { A 2 byte signed integer (smallint) }
  btU32 = 5; { A 4 byte unsigned integer (cardinal/longword) }
  btS32 = 6; { A 4 byte signed integer (Integer/Longint) }
  btSingle = 7; { A 4 byte float (single) }
  btDouble = 8; { A 8 byte float (double) }
  btExtended = 9; { A 10 byte float (extended) }
  btString = 10; { A string }
  btRecord = 11; { A record }
  btArray = 12; { An array}
  btPointer = 13;{ A pointer }
  btPChar = 14; { A PChar (internally the same as a string) }
  btResourcePointer = 15;{ A resource pointer: Variable that can contain things from outside the script engine }
  btVariant = 16;{ A variant }
  btS64 = 17;{ An 8 byte signed integer (int64) }
  btChar = 18; {a Char (1 byte)}
  btWideString = 19;{ A wide string}
  btWideChar = 20;{A widechar}
  btProcPtr = 21;{ Compile time procedural pointer (will be btu32 when compiled) }
  btStaticArray = 22;{Static array}
  btSet = 23;{Set}
  btCurrency = 24;{Currency}
  btClass = 25;{class}
  btInterface = 26;{Interface}
  btType = 130;{Compile time: a type}
  btEnum = 129;{ Compile time enumeration; This will be a btu32 when compiled }

// Script internal command:
  CM_A = 0; // Assign command
  CM_CA = 1;//Calculate Command
  CM_P = 2;// Push
  CM_PV = 3;//Push Var
  CM_PO = 4;//Pop
  Cm_C = 5;//Call
  Cm_G = 6;//Goto
  Cm_CG = 7;//Conditional Goto
  Cm_CNG = 8; //Conditional NOT Goto
  Cm_R = 9; //Ret
  Cm_ST = 10;//Set Stack Type
  Cm_Pt = 11;//Push Type
  CM_CO = 12;//Compare
  Cm_cv = 13;//Call Var
  cm_sp = 14;//Set Pointer
  cm_bn = 15;//Boolean NOT
  cm_vm = 16;//Var Minus
  cm_sf = 17;//Set Flag
  cm_fg = 18;//Flag Goto
  cm_puexh = 19;//Push Exception Handler
  cm_poexh = 20; //Pop Exception Handler
  cm_in = 21;//Integer NOT
  cm_spc = 22;//Set Stack Pointer To Copy
  cm_inc = 23;//Inc
  cm_dec = 24;//Dec
  cm_nop = 255;//nop

{Maximum number of items in a list}
  MaxListSize = Maxint div 16;

implementation

end.
