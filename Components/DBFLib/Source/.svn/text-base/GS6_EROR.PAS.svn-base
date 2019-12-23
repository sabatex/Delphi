unit gs6_eror;
{-----------------------------------------------------------------------------
                                 Error Handling

       gsf_Eror Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Apr 1996

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles errors.

       Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   gs6_cnst,
   gs6_glbl;

const

   {                  Run Time Error Codes                        }

   dosInvalidFunct   =    1;         {Invalid function number}
   dosFileNotFound   =    2;         {File not found}
   dosPathNotFound   =    3;         {Path not found}
   dosTooManyFiles   =    4;         {Too many open files}
   dosAccessDenied   =    5;         {File access denied}
   dosInvalidHandle  =    6;         {Invalid file handle}
   dosInvalidAccess  =   12;         {Invalid file access code}
   dosInvalidDrive   =   15;         {Invalid drive number}
   dosCantRemoveDir  =   16;         {Cannot remove current directory}
   dosCantRename     =   17;         {Cannot rename across drives}
   dosLockViolated   =   33;         {Attempted to read locked disk}
   dosDiskReadError  =  100;         {Disk read error}
   dosDiskWriteError =  101;         {Disk write error}
   dosFileNotAssgd   =  102;         {File not assigned}
   dosFileNotOpen    =  103;         {File not open}
   dosNotOpenInput   =  104;         {File not open for input}
   dosNotOpenOutput  =  105;         {File not open for output}
   dosInvalidNumber  =  106;         {Invalid numeric format}
   dosWriteProtected =  150;         {Disk is write-protected}
   dosBadStructure   =  151;         {Bad drive request struct length}
   dosDriveNotReady  =  152;         {Drive not ready}
   dosDataCRCError   =  154;         {CRC error in data}
   dosDiskSeekError  =  156;         {Disk seek error}
   dosMediaUnknown   =  157;         {Unknown media type}
   dosSectorNotFound =  158;         {Sector Not Found}
   dosPrinterNoPaper =  159;         {Printer out of paper}
   dosWriteFault     =  160;         {Device write fault}
   dosReadFault      =  161;         {Device read fault}
   dosHardwareFail   =  162;         {Hardware failure}
   dosFileNameExists =  183;         {File Name already exists}
   tpDivideByZero    =  200;         {Division by zero}
   tpRangeCheck      =  201;         {Range check error}
   tpStackOverflow   =  202;         {Stack overflow error}
   tpHeapOverflow    =  203;         {Heap overflow error}
   tpInvalidPointer  =  204;         {Invalid pointer operation}
   tpFloatPointOflow =  205;         {Floating point overflow}
   tpFloatPointUFlow =  206;         {Floating point underflow}
   tpFloatPointInvld =  207;         {Invalid floating point operation}
   tpNoOverlayMngr   =  208;         {Overlay manager not installed}
   tpOverlayReadErr  =  209;         {Overlay file read error}
   tpObjectNotInit   =  210;         {Object not initialized}
   tpAbstractCall    =  211;         {Call to abstract method}
   tpStreamRegError  =  212;         {Stream registration error}
   tpCollectionIndex =  213;         {Collection index out of range}
   tpCollectionOFlow =  214;         {Collection overflow error}
   gsShortDiskRead   =  221;         {Short Disk Read'}
   gsShortDiskWrite  =  222;         {Short Disk Write'}
   gsMemoAccessError =  230;         {Error accessing Memo File}
   gsBadDBFHeader    = 1001;         {dBase DBF file header invalid}
   gsDBFRangeError   = 1002;         {dBase record request beyond EOF}
   gsInvalidField    = 1003;         {dBase field name is invalid}
   gsBadFieldType    = 1004;         {dBase field is of incorrect type}
   gsBadDBTRecord    = 1005;         {dBase memo record has format error}
   gsBadFormula      = 1006;         {Formula expression cannot be translated}
   gsFileAlreadyOpen = 1007;         {Dest file for sort or copy already open}
   gsAreaIsNotInUse  = 1008;         {Object is not initialized in file area}
   gsKeyTooLong      = 1009;         {Key is longer than 255 bytes}
   gsLowMemory       = 1010;         {Insufficient Heap Memory}
   gsNumberTooBig    = 1011;         {Number too large for field}
   {               Extended Run Time Error Code Information             }

                             {ssf_DSK errors}
   dskCloseError     = 1103;         {Error in GSO_DiskFile.Close}
   dskEraseError     = 1104;         {Error in GSO_DiskFile.Erase}
   dskFileSizeError  = 1105;         {Error in GSO_DiskFile.FileSize}
   dskFlushError     = 1111;         {Error in GSO_DiskFile.Flush}
   dskLockError      = 1112;         {File/record lock error}
   dskLockRecError   = 1113;         {Record lock error-GSO_DiskFile.RecLock}
   dskReadError      = 1101;         {Error in GSO_DiskFile.Read}
   dskRenameError    = 1106;         {Error in GSO_DiskFile.ReName}
   dskResetError     = 1107;         {Error in GSO_DiskFile.Reset}
   dskRewriteError   = 1108;         {Error in GSO_DiskFile.Write}
   dskTruncateError  = 1109;         {Error in GSO_DiskFile.Truncate}
   dskUnlockError    = 1114;         {Unlock error-GSO_DiskFile.Unlock}
   dskWriteError     = 1102;         {Error in GSO_DiskFile.Write}

                             {ssf_DBF errors}
   dbfAppendError     = 1206;        {Error in GSO_dBaseDBF.Append}
   dbfAnalyzeField    = 1298;        {Error in GSO_dBaseFLD.AnalyzeField}
   dbfCheckFieldError = 1299;        {Error in GSO_dBaseFLD.CheckField}
   dbfGetRecError     = 1207;        {Error in GSO_dBaseDBF.GetRec}
   dbfHdrWriteError   = 1201;        {Error in GSO_dBaseDBF.HdrWrite}
   dbfInitError       = 1204;        {Error in GSO_dBaseDBF.Init}
   dbfPutRecError     = 1202;        {Error in GSO_dBaseDBF.PutRec}
   dbfBadDateString   = 1251;        {Date field string is bad}
   dbfBadMemoPtr      = 1255;        {Invalid memo block number}
   dbfBadNumberString = 1261;        {Number field string is bad}
   dbfBadLogicString  = 1262;        {Logical field string is bad}
   dbfUnExpectedPassword = 1269;     {Password for unencrypted file}
   dbfNoPassword      = 1270;        {No Password for encrypted file}
   dbfBadPassword     = 1271;        {Invalid Password for encrypted file}


                             {ssf_DBS errors}
   dbsFormulaError    = 2101;        {Error in GSO_dBHandler.Formula}
   dbsMemoGetError    = 2102;        {Error in GSO_dBHandler.MemoGet}
   dbsMemoGetNError   = 2103;        {Error in GSO_dBHandler.MemoGetN}
   dbsMemoPutNError   = 2104;        {Error in GSO_dBHandler.MemoPutN}
   dbsPackError       = 2105;        {Error in GSO_dBHandler.Pack}
   dbsSortFile        = 2107;        {Error in GSO_dBHandler.SortFile}
   dbsZapError        = 2106;        {Error in GSO_dBHandler.Zap}
   dbsIndexFileBad    = 2112;        {Error Opening Index in IndexTo}
   dbsBadIndexLock    = 2222;        {Failed to lock indexes on write} 

                             {ssf_NDX errors}
   ndxInitError        = 5101;       {Error in GSO_IndexFile.Init}
   ndxNDX_AdjValError  = 5102;       {Error in GSO_IndexFile.KeyAdjVal}
   ndxKeyUpdateError   = 5103;       {Error in GSO_IndexFile.KeyUpdate}
   ndxKeyFindError     = 5104;       {Error in GSO_IndexFile.KeyFind}
   ndxNoSuchTag        = 5109;       {Error in Tag Name of index}
   cdxInitError        = 5114;       {Error in GSO_CDXFile.Init}
   cdxCDX_AdjValError  = 5115;       {Error in GSO_CDXFile.CDX_AdjVal}
   cdxKeyUpdateError   = 5116;       {Error in GSO_CDXFile.KeyUpdate}
   CDXNoSuchTag        = 5117;       {Error in finding CDX tag}
   CDXKeyFindError     = 5118;       {Error in CDX file structure}
   CDXNoCollateGen     = 5119;       {CDX GENERAL Collate not available}
   indxLockError       = 5120;       {Error locking index file}

                             {ssf_INX errors}
   inxRetrieveKeyError = 5211;       {Error in GSO_IdxColl.RetrieveKey}
   inxResolveElement   = 5212;       {Error resolving expression}

                              {ssf_MMO errors}
   mmoGeneralError     = 6100;       {Memo General Error}
   mmoInitError        = 6101;       {Error in GSO_dBMemo.Init}
   mmoMemoPutError     = 6102;       {Error in GSO_dBMemo.MemoPut}
   mmoMemoLineMissing  = 6103;       {Memo line not available}
   mmoMemoTooLarge     = 6104;       {Memo is greater than 65520 bytes}
   mmoMemoSetParamErr  = 6199;       {Error in GSO_dBMemo4.MemoSetParam}

                             {ssf_Shel errors}
   shelConfirmUsedArea = 7101;       {Accessed a file area that is not Use'd}


type
   ErrListRec = record
      ErrCode : integer;
      ErrStr  : string;
   end;

const
   ErrCount = 31;

   ErrListAry : array[0..ErrCount-1] of ErrListRec = (
         (ErrCode: 2; ErrStr: 'Файл не найден'),
         (ErrCode: 3; ErrStr: 'Каталог не найден'),
         (ErrCode: 4; ErrStr: 'Слишком много открыто файлов'),
         (ErrCode: 5; ErrStr: 'Доступ к файлу запрещен'),
         (ErrCode: 12; ErrStr: 'Некорректный код доступа к файлу'),
         (ErrCode: 15; ErrStr: 'Некорректный номер диска'),
         (ErrCode: 32; ErrStr: 'Доступ к файлу запрещен (файл заблокирован)'),
         (ErrCode: 33; ErrStr: 'Запись заблокирована другим пользователем'),
         (ErrCode: 100; ErrStr: 'Ошибка чтения с диска'),
         (ErrCode: 101; ErrStr: 'Ошибка записи на диск'),
         (ErrCode: 102; ErrStr: 'File not assigned'),
         (ErrCode: 103; ErrStr: 'Файл не открыт'),
         (ErrCode: 104; ErrStr: 'Файл не открыт для чтения'),
         (ErrCode: 105; ErrStr: 'Файл не открыт для записи'),
         (ErrCode: 106; ErrStr: 'Некорректный формат числа'),
         (ErrCode: 150; ErrStr: 'Диск защищен от записи'),
         (ErrCode: 152; ErrStr: 'Диск не отвечает'),
         (ErrCode: 162; ErrStr: 'Аппаратная ошибка'),
         (ErrCode: 183; ErrStr: 'Файл уже существует'),
         (ErrCode: 1001; ErrStr: 'Некорректный заголовок файла dBase DBF'),
         (ErrCode: 1002; ErrStr: 'Попытка чтения записи за границей dBase файла'),
         (ErrCode: 1003; ErrStr: 'Некорректное имя поля dBase файла'),
         (ErrCode: 1004; ErrStr: 'Некорректный тип поля dBase файла'),
         (ErrCode: 1005; ErrStr: 'Ошибка в формате записи dBase memo'),
         (ErrCode: 1006; ErrStr: 'Выражение формулы невозможно вычислить'),
         (ErrCode: 1011; ErrStr: 'Число слишком большое для записи в поле'),
         (ErrCode: 1101; ErrStr: 'Ошибка чтения файла или сбой сети'),
         (ErrCode: 1102; ErrStr: 'Ошибка записи в файл или сбой сети'),
         (ErrCode: 1269; ErrStr: gsErrUnExpectedPassword),
         (ErrCode: 1270; ErrStr: gsErrNoPassword),
         (ErrCode: 1271; ErrStr: gsErrBadPassword));


Procedure DefCapError(Code, Info: integer; StP: string);
Procedure FoundPgmError(Code, Info:integer; StP: string);

{private}

const

   gsfMsgOnly = -7;
   gsfCapErr = 'Halcyon Error';

type

   CaptureError = Procedure(Code, Info:Integer; StP: string);

var
   CapError      : CaptureError;


implementation

{$F+}
Procedure DefCapError(Code, Info: integer; StP: string);
var
   i  : integer;
   s1 : string;
   s2 : string;
begin
   if (Info < 0) and (Info <> gsfMsgOnly) then RunError(Code); {!!RFG 091297}
   s1 := StP;
   i := -1;
   repeat
      inc(i)
   until (i >= ErrCount) or (ErrListAry[i].ErrCode = Code);
   if i < ErrCount then
      raise EHalcyonError.Create(ErrListAry[i].ErrStr+' - '+s1)
   else
   begin
      s2 := 'Halcyon Error '+IntToStr(Code);
      if Info <> gsfMsgOnly then              {!!RFG 091297}
         s2 := s2 +', SubCode '+IntToStr(Info); {!!RFG 091297}
      s2 := s2 +'.'+#13;                        {!!RFG 091297}
      if s1 <> '' then s2 := s2 + ' '+s1+ '>'+IntToStr(Info);
      raise EHalcyonError.Create(s2);
   end;
end;
{$F-}

Procedure FoundPgmError(Code, Info:integer; StP: string);
begin
   CapError(Code,Info,StP);
end;

initialization
   CapError := DefCapError;
end.

