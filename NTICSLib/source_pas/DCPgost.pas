unit DCPgost;

interface
uses
  Classes, Sysutils, DCPcrypt2, DCPconst, DCPblockciphers;

type
  TDCP_gost= class(TDCP_blockcipher64)
  protected
    KeyData: array[0..7] of DWord;
    procedure InitKey(const Key; Size: longword); override;
  public
    class function GetID: integer; override;
    class function GetAlgorithm: string; override;
    class function GetMaxKeySize: integer; override;
    class function SelfTest: boolean; override;
    procedure Burn; override;
    procedure EncryptECB(const InData; var OutData); override;
    procedure DecryptECB(const InData; var OutData); override;
  end;


{******************************************************************************}
{******************************************************************************}
implementation
{$R-}{$Q-}
const
  sTable: array[0..3, 0..255] of DWord= (
   ($00072000,$00075000,$00074800,$00071000,$00076800,$00074000,$00070000,$00077000,
    $00073000,$00075800,$00070800,$00076000,$00073800,$00077800,$00072800,$00071800,
    $0005A000,$0005D000,$0005C800,$00059000,$0005E800,$0005C000,$00058000,$0005F000,
    $0005B000,$0005D800,$00058800,$0005E000,$0005B800,$0005F800,$0005A800,$00059800,
    $00022000,$00025000,$00024800,$00021000,$00026800,$00024000,$00020000,$00027000,
    $00023000,$00025800,$00020800,$00026000,$00023800,$00027800,$00022800,$00021800,
    $00062000,$00065000,$00064800,$00061000,$00066800,$00064000,$00060000,$00067000,
    $00063000,$00065800,$00060800,$00066000,$00063800,$00067800,$00062800,$00061800,
    $00032000,$00035000,$00034800,$00031000,$00036800,$00034000,$00030000,$00037000,
    $00033000,$00035800,$00030800,$00036000,$00033800,$00037800,$00032800,$00031800,
    $0006A000,$0006D000,$0006C800,$00069000,$0006E800,$0006C000,$00068000,$0006F000,
    $0006B000,$0006D800,$00068800,$0006E000,$0006B800,$0006F800,$0006A800,$00069800,
    $0007A000,$0007D000,$0007C800,$00079000,$0007E800,$0007C000,$00078000,$0007F000,
    $0007B000,$0007D800,$00078800,$0007E000,$0007B800,$0007F800,$0007A800,$00079800,
    $00052000,$00055000,$00054800,$00051000,$00056800,$00054000,$00050000,$00057000,
    $00053000,$00055800,$00050800,$00056000,$00053800,$00057800,$00052800,$00051800,
    $00012000,$00015000,$00014800,$00011000,$00016800,$00014000,$00010000,$00017000,
    $00013000,$00015800,$00010800,$00016000,$00013800,$00017800,$00012800,$00011800,
    $0001A000,$0001D000,$0001C800,$00019000,$0001E800,$0001C000,$00018000,$0001F000,
    $0001B000,$0001D800,$00018800,$0001E000,$0001B800,$0001F800,$0001A800,$00019800,
    $00042000,$00045000,$00044800,$00041000,$00046800,$00044000,$00040000,$00047000,
    $00043000,$00045800,$00040800,$00046000,$00043800,$00047800,$00042800,$00041800,
    $0000A000,$0000D000,$0000C800,$00009000,$0000E800,$0000C000,$00008000,$0000F000,
    $0000B000,$0000D800,$00008800,$0000E000,$0000B800,$0000F800,$0000A800,$00009800,
    $00002000,$00005000,$00004800,$00001000,$00006800,$00004000,$00000000,$00007000,
    $00003000,$00005800,$00000800,$00006000,$00003800,$00007800,$00002800,$00001800,
    $0003A000,$0003D000,$0003C800,$00039000,$0003E800,$0003C000,$00038000,$0003F000,
    $0003B000,$0003D800,$00038800,$0003E000,$0003B800,$0003F800,$0003A800,$00039800,
    $0002A000,$0002D000,$0002C800,$00029000,$0002E800,$0002C000,$00028000,$0002F000,
    $0002B000,$0002D800,$00028800,$0002E000,$0002B800,$0002F800,$0002A800,$00029800,
    $0004A000,$0004D000,$0004C800,$00049000,$0004E800,$0004C000,$00048000,$0004F000,
    $0004B000,$0004D800,$00048800,$0004E000,$0004B800,$0004F800,$0004A800,$00049800),
   ($03A80000,$03C00000,$03880000,$03E80000,$03D00000,$03980000,$03A00000,$03900000,
    $03F00000,$03F80000,$03E00000,$03B80000,$03B00000,$03800000,$03C80000,$03D80000,
    $06A80000,$06C00000,$06880000,$06E80000,$06D00000,$06980000,$06A00000,$06900000,
    $06F00000,$06F80000,$06E00000,$06B80000,$06B00000,$06800000,$06C80000,$06D80000,
    $05280000,$05400000,$05080000,$05680000,$05500000,$05180000,$05200000,$05100000,
    $05700000,$05780000,$05600000,$05380000,$05300000,$05000000,$05480000,$05580000,
    $00A80000,$00C00000,$00880000,$00E80000,$00D00000,$00980000,$00A00000,$00900000,
    $00F00000,$00F80000,$00E00000,$00B80000,$00B00000,$00800000,$00C80000,$00D80000,
    $00280000,$00400000,$00080000,$00680000,$00500000,$00180000,$00200000,$00100000,
    $00700000,$00780000,$00600000,$00380000,$00300000,$00000000,$00480000,$00580000,
    $04280000,$04400000,$04080000,$04680000,$04500000,$04180000,$04200000,$04100000,
    $04700000,$04780000,$04600000,$04380000,$04300000,$04000000,$04480000,$04580000,
    $04A80000,$04C00000,$04880000,$04E80000,$04D00000,$04980000,$04A00000,$04900000,
    $04F00000,$04F80000,$04E00000,$04B80000,$04B00000,$04800000,$04C80000,$04D80000,
    $07A80000,$07C00000,$07880000,$07E80000,$07D00000,$07980000,$07A00000,$07900000,
    $07F00000,$07F80000,$07E00000,$07B80000,$07B00000,$07800000,$07C80000,$07D80000,
    $07280000,$07400000,$07080000,$07680000,$07500000,$07180000,$07200000,$07100000,
    $07700000,$07780000,$07600000,$07380000,$07300000,$07000000,$07480000,$07580000,
    $02280000,$02400000,$02080000,$02680000,$02500000,$02180000,$02200000,$02100000,
    $02700000,$02780000,$02600000,$02380000,$02300000,$02000000,$02480000,$02580000,
    $03280000,$03400000,$03080000,$03680000,$03500000,$03180000,$03200000,$03100000,
    $03700000,$03780000,$03600000,$03380000,$03300000,$03000000,$03480000,$03580000,
    $06280000,$06400000,$06080000,$06680000,$06500000,$06180000,$06200000,$06100000,
    $06700000,$06780000,$06600000,$06380000,$06300000,$06000000,$06480000,$06580000,
    $05A80000,$05C00000,$05880000,$05E80000,$05D00000,$05980000,$05A00000,$05900000,
    $05F00000,$05F80000,$05E00000,$05B80000,$05B00000,$05800000,$05C80000,$05D80000,
    $01280000,$01400000,$01080000,$01680000,$01500000,$01180000,$01200000,$01100000,
    $01700000,$01780000,$01600000,$01380000,$01300000,$01000000,$01480000,$01580000,
    $02A80000,$02C00000,$02880000,$02E80000,$02D00000,$02980000,$02A00000,$02900000,
    $02F00000,$02F80000,$02E00000,$02B80000,$02B00000,$02800000,$02C80000,$02D80000,
    $01A80000,$01C00000,$01880000,$01E80000,$01D00000,$01980000,$01A00000,$01900000,
    $01F00000,$01F80000,$01E00000,$01B80000,$01B00000,$01800000,$01C80000,$01D80000),
   ($30000002,$60000002,$38000002,$08000002,$28000002,$78000002,$68000002,$40000002,
    $20000002,$50000002,$48000002,$70000002,$00000002,$18000002,$58000002,$10000002,
    $B0000005,$E0000005,$B8000005,$88000005,$A8000005,$F8000005,$E8000005,$C0000005,
    $A0000005,$D0000005,$C8000005,$F0000005,$80000005,$98000005,$D8000005,$90000005,
    $30000005,$60000005,$38000005,$08000005,$28000005,$78000005,$68000005,$40000005,
    $20000005,$50000005,$48000005,$70000005,$00000005,$18000005,$58000005,$10000005,
    $30000000,$60000000,$38000000,$08000000,$28000000,$78000000,$68000000,$40000000,
    $20000000,$50000000,$48000000,$70000000,$00000000,$18000000,$58000000,$10000000,
    $B0000003,$E0000003,$B8000003,$88000003,$A8000003,$F8000003,$E8000003,$C0000003,
    $A0000003,$D0000003,$C8000003,$F0000003,$80000003,$98000003,$D8000003,$90000003,
    $30000001,$60000001,$38000001,$08000001,$28000001,$78000001,$68000001,$40000001,
    $20000001,$50000001,$48000001,$70000001,$00000001,$18000001,$58000001,$10000001,
    $B0000000,$E0000000,$B8000000,$88000000,$A8000000,$F8000000,$E8000000,$C0000000,
    $A0000000,$D0000000,$C8000000,$F0000000,$80000000,$98000000,$D8000000,$90000000,
    $B0000006,$E0000006,$B8000006,$88000006,$A8000006,$F8000006,$E8000006,$C0000006,
    $A0000006,$D0000006,$C8000006,$F0000006,$80000006,$98000006,$D8000006,$90000006,
    $B0000001,$E0000001,$B8000001,$88000001,$A8000001,$F8000001,$E8000001,$C0000001,
    $A0000001,$D0000001,$C8000001,$F0000001,$80000001,$98000001,$D8000001,$90000001,
    $30000003,$60000003,$38000003,$08000003,$28000003,$78000003,$68000003,$40000003,
    $20000003,$50000003,$48000003,$70000003,$00000003,$18000003,$58000003,$10000003,
    $30000004,$60000004,$38000004,$08000004,$28000004,$78000004,$68000004,$40000004,
    $20000004,$50000004,$48000004,$70000004,$00000004,$18000004,$58000004,$10000004,
    $B0000002,$E0000002,$B8000002,$88000002,$A8000002,$F8000002,$E8000002,$C0000002,
    $A0000002,$D0000002,$C8000002,$F0000002,$80000002,$98000002,$D8000002,$90000002,
    $B0000004,$E0000004,$B8000004,$88000004,$A8000004,$F8000004,$E8000004,$C0000004,
    $A0000004,$D0000004,$C8000004,$F0000004,$80000004,$98000004,$D8000004,$90000004,
    $30000006,$60000006,$38000006,$08000006,$28000006,$78000006,$68000006,$40000006,
    $20000006,$50000006,$48000006,$70000006,$00000006,$18000006,$58000006,$10000006,
    $B0000007,$E0000007,$B8000007,$88000007,$A8000007,$F8000007,$E8000007,$C0000007,
    $A0000007,$D0000007,$C8000007,$F0000007,$80000007,$98000007,$D8000007,$90000007,
    $30000007,$60000007,$38000007,$08000007,$28000007,$78000007,$68000007,$40000007,
    $20000007,$50000007,$48000007,$70000007,$00000007,$18000007,$58000007,$10000007),
   ($000000E8,$000000D8,$000000A0,$00000088,$00000098,$000000F8,$000000A8,$000000C8,
    $00000080,$000000D0,$000000F0,$000000B8,$000000B0,$000000C0,$00000090,$000000E0,
    $000007E8,$000007D8,$000007A0,$00000788,$00000798,$000007F8,$000007A8,$000007C8,
    $00000780,$000007D0,$000007F0,$000007B8,$000007B0,$000007C0,$00000790,$000007E0,
    $000006E8,$000006D8,$000006A0,$00000688,$00000698,$000006F8,$000006A8,$000006C8,
    $00000680,$000006D0,$000006F0,$000006B8,$000006B0,$000006C0,$00000690,$000006E0,
    $00000068,$00000058,$00000020,$00000008,$00000018,$00000078,$00000028,$00000048,
    $00000000,$00000050,$00000070,$00000038,$00000030,$00000040,$00000010,$00000060,
    $000002E8,$000002D8,$000002A0,$00000288,$00000298,$000002F8,$000002A8,$000002C8,
    $00000280,$000002D0,$000002F0,$000002B8,$000002B0,$000002C0,$00000290,$000002E0,
    $000003E8,$000003D8,$000003A0,$00000388,$00000398,$000003F8,$000003A8,$000003C8,
    $00000380,$000003D0,$000003F0,$000003B8,$000003B0,$000003C0,$00000390,$000003E0,
    $00000568,$00000558,$00000520,$00000508,$00000518,$00000578,$00000528,$00000548,
    $00000500,$00000550,$00000570,$00000538,$00000530,$00000540,$00000510,$00000560,
    $00000268,$00000258,$00000220,$00000208,$00000218,$00000278,$00000228,$00000248,
    $00000200,$00000250,$00000270,$00000238,$00000230,$00000240,$00000210,$00000260,
    $000004E8,$000004D8,$000004A0,$00000488,$00000498,$000004F8,$000004A8,$000004C8,
    $00000480,$000004D0,$000004F0,$000004B8,$000004B0,$000004C0,$00000490,$000004E0,
    $00000168,$00000158,$00000120,$00000108,$00000118,$00000178,$00000128,$00000148,
    $00000100,$00000150,$00000170,$00000138,$00000130,$00000140,$00000110,$00000160,
    $000001E8,$000001D8,$000001A0,$00000188,$00000198,$000001F8,$000001A8,$000001C8,
    $00000180,$000001D0,$000001F0,$000001B8,$000001B0,$000001C0,$00000190,$000001E0,
    $00000768,$00000758,$00000720,$00000708,$00000718,$00000778,$00000728,$00000748,
    $00000700,$00000750,$00000770,$00000738,$00000730,$00000740,$00000710,$00000760,
    $00000368,$00000358,$00000320,$00000308,$00000318,$00000378,$00000328,$00000348,
    $00000300,$00000350,$00000370,$00000338,$00000330,$00000340,$00000310,$00000360,
    $000005E8,$000005D8,$000005A0,$00000588,$00000598,$000005F8,$000005A8,$000005C8,
    $00000580,$000005D0,$000005F0,$000005B8,$000005B0,$000005C0,$00000590,$000005E0,
    $00000468,$00000458,$00000420,$00000408,$00000418,$00000478,$00000428,$00000448,
    $00000400,$00000450,$00000470,$00000438,$00000430,$00000440,$00000410,$00000460,
    $00000668,$00000658,$00000620,$00000608,$00000618,$00000678,$00000628,$00000648,
    $00000600,$00000650,$00000670,$00000638,$00000630,$00000640,$00000610,$00000660));

class function TDCP_gost.GetMaxKeySize: integer;
begin
  Result:= 256;
end;

class function TDCP_gost.GetID: integer;
begin
  Result:= DCP_gost;
end;

class function TDCP_gost.GetAlgorithm: string;
begin
  Result:= 'Gost';
end;

class function TDCP_gost.SelfTest: boolean;
const
  Key1: array[0..31] of byte=
    ($BE,$5E,$C2,$00,$6C,$FF,$9D,$CF,$52,$35,$49,$59,$F1,$FF,$0C,$BF,
     $E9,$50,$61,$B5,$A6,$48,$C1,$03,$87,$06,$9C,$25,$99,$7C,$06,$72);
  InData1: array[0..7] of byte=
    ($0D,$F8,$28,$02,$B7,$41,$A2,$92);
  OutData1: array[0..7] of byte=
    ($07,$F9,$02,$7D,$F7,$F7,$DF,$89);
  Key2: array[0..31] of byte=
    ($B3,$85,$27,$2A,$C8,$D7,$2A,$5A,$8B,$34,$4B,$C8,$03,$63,$AC,$4D,
     $09,$BF,$58,$F4,$1F,$54,$06,$24,$CB,$CB,$8F,$DC,$F5,$53,$07,$D7);
  InData2: array[0..7] of byte=
    ($13,$54,$EE,$9C,$0A,$11,$CD,$4C);
  OutData2: array[0..7] of byte=
    ($4F,$B5,$05,$36,$F9,$60,$A7,$B1);
var
  Block: array[0..7] of byte;
  Cipher: TDCP_gost;
begin
  Cipher:= TDCP_gost.Create(nil);
  Cipher.Init(Key1,Sizeof(Key1)*8,nil);
  Cipher.EncryptECB(InData1,Block);
  Result:= boolean(CompareMem(@Block,@OutData1,8));
  Cipher.DecryptECB(Block,Block);
  Cipher.Burn;
  Result:= Result and boolean(CompareMem(@Block,@InData1,8));
  Cipher.Init(Key2,Sizeof(Key2)*8,nil);
  Cipher.EncryptECB(InData2,Block);
  Result:= Result and boolean(CompareMem(@Block,@OutData2,8));
  Cipher.DecryptECB(Block,Block);
  Cipher.Burn;
  Result:= Result and boolean(CompareMem(@Block,@InData2,8));
  Cipher.Free;
end;

procedure TDCP_gost.InitKey(const Key; Size: longword);
var
  i: longword;
  userkey: array[0..31] of byte;
begin
  Size:= Size div 8;

  FillChar(userkey,Sizeof(userkey),0);
  Move(Key,userkey,Size);
  for i:= 0 to 7 do
    KeyData[i]:= (dword(UserKey[4*i+3]) shl 24) or (dword(UserKey[4*i+2]) shl 16) or
      (dword(UserKey[4*i+1]) shl 8) or (dword(UserKey[4*i+0]));
end;

procedure TDCP_gost.Burn;
begin
  FillChar(KeyData,Sizeof(KeyData),0);
  inherited Burn;
end;

procedure TDCP_gost.EncryptECB(const InData; var OutData);
var
  n1, n2: DWord;
  i: longword;
begin
  if not fInitialized then
    raise EDCP_blockcipher.Create('Cipher not initialized');
  n1:= PDword(@InData)^;
  n2:= PDword(dword(@InData)+4)^;
  for i:= 0 to 2 do
  begin
    n2:= n2 xor (sTable[3,(n1+KeyData[0]) shr 24] xor sTable[2,((n1+KeyData[0]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[0]) shr 8) and $FF] xor sTable[0,(n1+KeyData[0]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[1]) shr 24] xor sTable[2,((n2+KeyData[1]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[1]) shr 8) and $FF] xor sTable[0,(n2+KeyData[1]) and $FF]);
    n2:= n2 xor (sTable[3,(n1+KeyData[2]) shr 24] xor sTable[2,((n1+KeyData[2]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[2]) shr 8) and $FF] xor sTable[0,(n1+KeyData[2]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[3]) shr 24] xor sTable[2,((n2+KeyData[3]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[3]) shr 8) and $FF] xor sTable[0,(n2+KeyData[3]) and $FF]);
    n2:= n2 xor (sTable[3,(n1+KeyData[4]) shr 24] xor sTable[2,((n1+KeyData[4]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[4]) shr 8) and $FF] xor sTable[0,(n1+KeyData[4]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[5]) shr 24] xor sTable[2,((n2+KeyData[5]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[5]) shr 8) and $FF] xor sTable[0,(n2+KeyData[5]) and $FF]);
    n2:= n2 xor (sTable[3,(n1+KeyData[6]) shr 24] xor sTable[2,((n1+KeyData[6]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[6]) shr 8) and $FF] xor sTable[0,(n1+KeyData[6]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[7]) shr 24] xor sTable[2,((n2+KeyData[7]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[7]) shr 8) and $FF] xor sTable[0,(n2+KeyData[7]) and $FF]);
  end;
  n2:= n2 xor (sTable[3,(n1+KeyData[7]) shr 24] xor sTable[2,((n1+KeyData[7]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[7]) shr 8) and $FF] xor sTable[0,(n1+KeyData[7]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[6]) shr 24] xor sTable[2,((n2+KeyData[6]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[6]) shr 8) and $FF] xor sTable[0,(n2+KeyData[6]) and $FF]);
  n2:= n2 xor (sTable[3,(n1+KeyData[5]) shr 24] xor sTable[2,((n1+KeyData[5]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[5]) shr 8) and $FF] xor sTable[0,(n1+KeyData[5]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[4]) shr 24] xor sTable[2,((n2+KeyData[4]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[4]) shr 8) and $FF] xor sTable[0,(n2+KeyData[4]) and $FF]);
  n2:= n2 xor (sTable[3,(n1+KeyData[3]) shr 24] xor sTable[2,((n1+KeyData[3]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[3]) shr 8) and $FF] xor sTable[0,(n1+KeyData[3]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[2]) shr 24] xor sTable[2,((n2+KeyData[2]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[2]) shr 8) and $FF] xor sTable[0,(n2+KeyData[2]) and $FF]);
  n2:= n2 xor (sTable[3,(n1+KeyData[1]) shr 24] xor sTable[2,((n1+KeyData[1]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[1]) shr 8) and $FF] xor sTable[0,(n1+KeyData[1]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[0]) shr 24] xor sTable[2,((n2+KeyData[0]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[0]) shr 8) and $FF] xor sTable[0,(n2+KeyData[0]) and $FF]);
  PDword(@OutData)^:= n2;
  PDword(dword(@OutData)+4)^:= n1;
end;

procedure TDCP_gost.DecryptECB(const InData; var OutData);
var
  n1, n2: DWord;
  i: longword;
begin
  if not fInitialized then
    raise EDCP_blockcipher.Create('Cipher not initialized');
  n1:= PDword(@InData)^;
  n2:= PDword(dword(@InData)+4)^;
  n2:= n2 xor (sTable[3,(n1+KeyData[0]) shr 24] xor sTable[2,((n1+KeyData[0]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[0]) shr 8) and $FF] xor sTable[0,(n1+KeyData[0]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[1]) shr 24] xor sTable[2,((n2+KeyData[1]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[1]) shr 8) and $FF] xor sTable[0,(n2+KeyData[1]) and $FF]);
  n2:= n2 xor (sTable[3,(n1+KeyData[2]) shr 24] xor sTable[2,((n1+KeyData[2]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[2]) shr 8) and $FF] xor sTable[0,(n1+KeyData[2]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[3]) shr 24] xor sTable[2,((n2+KeyData[3]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[3]) shr 8) and $FF] xor sTable[0,(n2+KeyData[3]) and $FF]);
  n2:= n2 xor (sTable[3,(n1+KeyData[4]) shr 24] xor sTable[2,((n1+KeyData[4]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[4]) shr 8) and $FF] xor sTable[0,(n1+KeyData[4]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[5]) shr 24] xor sTable[2,((n2+KeyData[5]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[5]) shr 8) and $FF] xor sTable[0,(n2+KeyData[5]) and $FF]);
  n2:= n2 xor (sTable[3,(n1+KeyData[6]) shr 24] xor sTable[2,((n1+KeyData[6]) shr 16) and $FF]
    xor sTable[1,((n1+KeyData[6]) shr 8) and $FF] xor sTable[0,(n1+KeyData[6]) and $FF]);
  n1:= n1 xor (sTable[3,(n2+KeyData[7]) shr 24] xor sTable[2,((n2+KeyData[7]) shr 16) and $FF]
    xor sTable[1,((n2+KeyData[7]) shr 8) and $FF] xor sTable[0,(n2+KeyData[7]) and $FF]);
  for i:= 0 to 2 do
  begin
    n2:= n2 xor (sTable[3,(n1+KeyData[7]) shr 24] xor sTable[2,((n1+KeyData[7]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[7]) shr 8) and $FF] xor sTable[0,(n1+KeyData[7]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[6]) shr 24] xor sTable[2,((n2+KeyData[6]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[6]) shr 8) and $FF] xor sTable[0,(n2+KeyData[6]) and $FF]);
    n2:= n2 xor (sTable[3,(n1+KeyData[5]) shr 24] xor sTable[2,((n1+KeyData[5]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[5]) shr 8) and $FF] xor sTable[0,(n1+KeyData[5]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[4]) shr 24] xor sTable[2,((n2+KeyData[4]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[4]) shr 8) and $FF] xor sTable[0,(n2+KeyData[4]) and $FF]);
    n2:= n2 xor (sTable[3,(n1+KeyData[3]) shr 24] xor sTable[2,((n1+KeyData[3]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[3]) shr 8) and $FF] xor sTable[0,(n1+KeyData[3]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[2]) shr 24] xor sTable[2,((n2+KeyData[2]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[2]) shr 8) and $FF] xor sTable[0,(n2+KeyData[2]) and $FF]);
    n2:= n2 xor (sTable[3,(n1+KeyData[1]) shr 24] xor sTable[2,((n1+KeyData[1]) shr 16) and $FF]
      xor sTable[1,((n1+KeyData[1]) shr 8) and $FF] xor sTable[0,(n1+KeyData[1]) and $FF]);
    n1:= n1 xor (sTable[3,(n2+KeyData[0]) shr 24] xor sTable[2,((n2+KeyData[0]) shr 16) and $FF]
      xor sTable[1,((n2+KeyData[0]) shr 8) and $FF] xor sTable[0,(n2+KeyData[0]) and $FF]);
  end;
  PDword(@OutData)^:= n2;
  PDword(dword(@OutData)+4)^:= n1;
end;


end.
