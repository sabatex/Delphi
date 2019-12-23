{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10033: GS6_FLAG.pas 
{
{   Rev 1.1    28.11.2002 15:56:18  Work
}
{------------------------------------------------------------------------------
                         Defines and Compiler Flags

       gs6_flag Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Apr 1996

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the defines and compiler flags that are used
       to configure the compiler.  It is included ($I SSF_FLAG.PAS) in
       each unit.

   Changes:

------------------------------------------------------------------------------}

{Set CBuilder 4 and Delphi 5 to be treated as Delphi 4}

{$IFDEF VER140}      {Delphi 6} { Kirill }
   {$DEFINE VER120}             { Kirill }
{$ENDIF}                        { Kirill }

{$IFDEF VER130}      {Delphi 5}
   {$DEFINE VER120}
{$ENDIF}

{$IFDEF VER125}      {CBuilder 4}
   {$DEFINE VER120}
{$ENDIF}

{Set define flag DELPHI if Delphi; set WINAPI if SysHalc, Win32, or Delphi}

{$IFDEF VER80}
   {$DEFINE DELPHI}
   {$DEFINE WINAPI}
{$ELSE}
   {$DEFINE DELPHI}
   {$DEFINE DELPHI32}
   {$DEFINE WINAPI}
{$ENDIF}

{$IFNDEF NOFOXGEN}
   {$DEFINE FOXGENERAL}   {Set General Collate mode for FoxPro}
{$ENDIF}

{$IFNDEF NODBASE3}
   {$DEFINE DBASE3OK}     {Include DBase 3 index code}
{$ENDIF}

{$IFNDEF NODBASE4}
   {$DEFINE DBASE4OK}     {Include DBase 4 index code}
{$ENDIF}

{$IFNDEF NOCLIP}
   {$DEFINE CLIPOK}       {Include Clipper index code}
{$ENDIF}

{$IFNDEF NOFOX}
   {$DEFINE FOXOK}        {Include FoxPro index code}
{$ENDIF}

{$IFNDEF NOTEST}
   {$DEFINE TESTING}   {Remove for the finished program}
{$ENDIF}


