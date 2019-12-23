// Процедуры и функции зависящие от платформы

unit QLowLevelFunction;
interface
uses
  {$IFDEF WIN32} Windows,{$ELSE} Libc, {$ENDIF} Variants,Types,SysUtils;

function GetLocalHostShort:string;
function GetCurrentUserName:string;
function GetSerialNumberHDD:string; 
function GetHardwareNumber:string;

implementation
{$IFDEF Linux}
const
  HDIO_GET_IDENTITY =	$030d;	// get IDE identification info
type
  hd_driveid = record
	config:WORD;		        // lots of obsolete bit flags */
	cyls:WORD;		        // "physical" cyls */
	reserved2:WORD;	                // reserved (word 2) */
	heads:WORD;		        // "physical" heads */
	track_bytes:WORD;	        // unformatted bytes per track */
	sector_bytes:WORD;	        // unformatted bytes per sector */
	sectors:WORD;	                // "physical" sectors per track */
	vendor0:WORD;	                // vendor unique */
	vendor1:WORD;	                // vendor unique */
	vendor2:WORD;     	        // vendor unique */
	serial_no:array[0..19] of char; //* 0 = not_specified */
	buf_type:WORD;
	buf_size:WORD;	                //* 512 byte increments; 0 = not_specified */
	ecc_bytes:WORD;	                //* for r/w long cmds; 0 = not_specified */
	fw_rev:array[0..7] of byte;	//* 0 = not_specified */
	model:array[0..39]of byte;	//* 0 = not_specified */
	max_multsect:byte;      	//* 0=not_implemented */
	vendor3:byte;	                //* vendor unique */
	dword_io:WORD;          	//* 0=not_implemented; 1=implemented */
	vendor4:byte;           	//* vendor unique */
	capability:byte;        	//* bits 0:DMA 1:LBA 2:IORDYsw 3:IORDYsup*/
	reserved50:WORD;        	//* reserved (word 50) */
	vendor5:byte;           	//* vendor unique */
	tPIO:byte;      		//* 0=slow, 1=medium, 2=fast */
	vendor6:byte;           	//* vendor unique */
	tDMA:byte;      		//* 0=slow, 1=medium, 2=fast */
	field_valid:WORD;       	//* bits 0:cur_ok 1:eide_ok */
	cur_cyls:WORD;          	//* logical cylinders */
	cur_heads:WORD;         	//* logical heads */
	cur_sectors:WORD;       	//* logical sectors per track */
	cur_capacity0:WORD;     	//* logical total sectors on drive */
	cur_capacity1:WORD;     	//*  (2 words, misaligned int)     */
	multsect:byte;          	//* current multiple sector count */
	multsect_valid:byte;    	//* when (bit0==1) multsect is ok */
	lba_capacity:DWORD;     	//* total number of sectors */
	dma_1word:WORD;         	//* single-word dma info */
	dma_mword:WORD;         	//* multiple-word dma info */
	eide_pio_modes:WORD;            //* bits 0:mode3 1:mode4 */
	eide_dma_min:WORD;      	//* min mword dma cycle time (ns) */
	eide_dma_time:WORD;     	//* recommended mword dma cycle time (ns) */
	eide_pio:WORD;                  //* min cycle time (ns), no IORDY  */
	eide_pio_iordy:WORD;            //* min cycle time (ns), with IORDY */
	words69_70:array[0..1] of WORD; //* reserved words 69-70 */
	//* HDIO_GET_IDENTITY currently returns only words 0 through 70 */
	words71_74:array[0..3] of WORD;	//* reserved words 71-74 */
	queue_depth:WORD;       	//*  */
	words76_79:array[0..3] of WORD;	//* reserved words 76-79 */
	major_rev_num:WORD;     	//*  */
	minor_rev_num:WORD;     	//*  */
	command_set_1:WORD;	        //* bits 0:Smart 1:Security 2:Removable 3:PM */
	command_set_2:WORD;	        //* bits 14:Smart Enabled 13:0 zero */
	cfsse:WORD;     		//* command set-feature supported extensions */
	cfs_enable_1:WORD;      	//* command set-feature enabled */
	cfs_enable_2:WORD;      	//* command set-feature enabled */	unsigned short  csf_default;	//* command set-feature default */
	dma_ultra:WORD;         	//*  */
	word89:WORD;    		//* reserved (word 89) */
	word90:WORD;    		//* reserved (word 90) */
	CurAPMvalues:WORD;      	//* current APM values */
	word92:WORD;    		//* reserved (word 92) */
	hw_config:WORD;         	//* hardware config */
	words94_125:array[0..31] of WORD;//* reserved words 94-125 */
	last_lun:WORD;          	//* reserved (word 126) */
	word127:WORD;           	//* reserved (word 127) */
	dlf:WORD;       		{ device lock function
					 * 15:9	reserved
					 * 8	security level 1:max 0:high
					 * 7:6	reserved
					 * 5	enhanced erase
					 * 4	expire
					 * 3	frozen
					 * 2	locked
					 * 1	en/disabled
					 * 0	capability
					 *}
	csfo:WORD;      		{* current set features options
					 * 15:4	reserved
					 * 3	auto reassign
					 * 2	reverting
					 * 1	read-look-ahead
					 * 0	write cache
					 *}
	words130_155:array[0..25] of WORD;//* reserved vendor words 130-155 */
	word156:WORD;
	words157_159:array[0..2] of WORD; //* reserved vendor words 157-159 */
	words160_255:array[0..94] of WORD;//* reserved words 160-255 */
  end;
{$ENDIF}

function GetLocalHostShort:string;
{$IFDEF WIN32}
var
  Buffer:array[0..255] of char;
  nSize:Cardinal;
  lpBuffer:PChar;
{$ENDIF}
begin
  // Определение имени текущего компютера
{$IFDEF WIN32}
  lpBuffer:=Buffer;
  nSize:=sizeof(Buffer);
  if GetComputerName(lpBuffer,nSize)<>NULL then
    Result:=''+lpBuffer;
{$ENDIF}
end;

function GetCurrentUserName:string;
{$IFDEF WIN32}
var
  Buffer:array[0..255] of char;
  nSize:Cardinal;
  lpBuffer:PChar;
{$ENDIF}
begin
  // Определение имени текущего пользователя
{$IFDEF WIN32}
  lpBuffer:=Buffer;
  nSize:=sizeof(Buffer);
  if GetUserName(lpBuffer,nSize)<>NULL then
    Result:=''+lpBuffer;
{$ENDIF}
end;

function GetSerialNumberHDD:string;
var
  a:DWORD;
{$IFDEF WIN32}
  SerialNum:dword;
  b:dword;
  Buffer:array[0..255] of char;
{$ELSE}
  hd:hd_driveid;
{$ENDIF}
begin
  {$IFDEF WIN32}
  if  GetVolumeInformation('c:\',Buffer,Sizeof(Buffer),@SerialNum,a,b,nil,0)then
    Result:=IntToStr(SerialNum)
  else
    Result:='';
  {$ELSE}
    a:=open('/dev/hda',O_RDONLY);
    ioctl(a,HDIO_GET_IDENTITY,@hd);
    Result:=String(hd.serial_no);
  {$ENDIF}
end;

function GetHardwareNumber:string;
begin
  Result:=GetSerialNumberHDD;
end;

end.