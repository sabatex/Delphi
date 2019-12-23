{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is JclOtaConsts.pas.                                                           }
{                                                                                                  }
{ The Initial Developer of the Original Code is Petr Vones.                                        }
{ Portions created by Petr Vones are Copyright (C) of Petr Vones.                                  }
{                                                                                                  }
{ Contributors:                                                                                    }
{   Florent Ouchet (outchy)                                                                        }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Unit owner: Florent Ouchet                                                                       }
{ Last modified: $Date: 2005/12/16 23:46:24 $                                                      }
{                                                                                                  }
{**************************************************************************************************}

unit JclOtaConsts;

interface

{$I jcl.inc}

const
  DelphiRootDirKeyValue = 'RootDir';
  JediIDESubKey         = 'Jedi\JCL\IDE\';
  DelphiEnvironmentVar  = 'DELPHI';
  {$IFDEF COMPILER6_UP}
  EnvironmentVarsKey    = 'Environment Variables';
  {$ENDIF COMP�LER6_UP}
  BPLExtension          = '.bpl';
  DPKExtension          = '.dpk';
  MAPExtension          = '.map';
  DRCExtension          = '.drc';
  DPRExtention          = '.dpr';
  BDSPROJExtension      = '.bdsproj';

  //=== Debug Expert =========================================================
  JclDebugExpertRegKey    = 'JclDebugExpert';
  JclDebugEnabledRegValue = 'JclDebugEnabled';
  MapFileOptionName       = 'MapFile';
  OutputDirOptionName     = 'OutputDir';
  RuntimeOnlyOptionName   = 'RuntimeOnly';
  PkgDllDirOptionName     = 'PkgDllDir';
  BPLOutputDirOptionName  = 'PackageDPLOutput';
  LIBPREFIXOptionName     = 'SOPrefix';
  LIBSUFFIXOptionName     = 'SOSuffix';

  //=== Favorite Folders Expert ==============================================
  JclFavoritesExpertName     = 'JclFavoriteFoldersExpert';
  JclFavoritesListSubKey     = 'Favorites';
  PictDialogFolderItemName   = 'PictureDialogPath';
  BorlandImagesPath          = 'Borland Shared\Images';
  FavDialogTemplateName      = 'FAVDLGTEMPLATE';
  OpenPictDialogTemplateName = 'DLGTEMPLATE';

  //=== Threads Expert =======================================================
  JclThreadsExpertName = 'JclThreadsExpert';
  MutexName            = 'DebugThreadNamesMutex';
  MutexReadName        = 'DebugThreadNamesReadMutex';
  MappingName          = 'DebugThreadNamesMapping';
  EventName            = 'DebugThreadNamesEvent';

  //=== SIMD Expert ==========================================================
  JclSIMDExpertName = 'JclSIMDExpert';

  //=== Uses Expert ==========================================================
  JclUsesExpertName   = 'JclUsesExpert';
  SIniIdentifierLists = 'IdentifierLists';
  SRegDebugLibPath    = 'Debug Library';
  SRegLibPath         = 'Library';
  SRegWizardActive    = 'Uses Wizard Active';
  SRegWizardConfirm   = 'Uses Wizard Confirm';
  SRegWizardIniFile   = 'Configuration File';

  SJCLUsesWizardID    = 'JEDI.JCLUsesWizard'; // wizard ID
  SJCLUsesWizardName  = 'JCL Uses Wizard'; // wizard name

implementation

// History:

// $Log: JclOtaConsts.pas,v $
// Revision 1.5  2005/12/16 23:46:24  outchy
// Added expert stack form.
// Added code to display call stack on expert exception.
// Fixed package extension for D2006.
//
// Revision 1.4  2005/10/26 03:29:44  rrossmair
// - improved header information, added $Date: 2005/12/16 23:46:24 $ and $Log: JclOtaConsts.pas,v $
// - improved header information, added $Date$ and Revision 1.5  2005/12/16 23:46:24  outchy
// - improved header information, added $Date$ and Added expert stack form.
// - improved header information, added $Date$ and Added code to display call stack on expert exception.
// - improved header information, added $Date$ and Fixed package extension for D2006.
// - improved header information, added $Date$ and CVS tags.
//
// Revision 1.3  2005/10/23 12:53:36  marquardt
// further expert cleanup and integration, use of JclRegistry
//
// Revision 1.2  2005/10/22 14:24:18  marquardt
// more expert integration and cleanup
//
// Revision 1.1  2005/10/21 12:24:41  marquardt
// experts reorganized with new directory common
//

end.
