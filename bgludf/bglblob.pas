unit bglblob;

{$mode objfpc}
{$packrecords C}
interface
uses strings,bglstr,sysutils;

type
  Int                  =LongInt;  // 32 bit signed
  Long                 =LongInt;  // 32 bit signed
  Short                =SmallInt; // 16 bit signed
  PInt                 = ^Int;


  TISC_BlobGetSegment = function(BlobHandle: PInt;
                                 Buffer: PChar;
                                 BufferSize: Long;
                                 var ResultLength: Long): Short; cdecl;
  TISC_BlobPutSegment = procedure(BlobHandle: PInt;
                                  Buffer: PChar;
                                  BufferLength: Short); cdecl;
  TBlob = record
    GetSegment         : TISC_BlobGetSegment;
    BlobHandle         : PInt;
    SegmentCount       : Long;
    MaxSegmentLength   : Long;
    TotalSize          : Long;
    PutSegment         : TISC_BlobPutSegment;
  end;
  PBlob = ^TBlob;

  function blobaspchar(Blob: PBlob): PChar; cdecl; export;

implementation

function blobaspchar(Blob: PBlob): PChar; cdecl; export;
var
  bytes_read, bytes_left, total_bytes_read: Long;
  st: String;
begin
  result := nil;
  if (not Assigned(Blob)) or
     (not Assigned(Blob^.BlobHandle)) then exit;
  with Blob^ do begin
    bytes_left := TotalSize;                // I have TotalSize bytes to read.
    if (bytes_left = 0) then exit;          // if I've nothing to copy, exit.
    SetString(st, nil, TotalSize);
    total_bytes_read := 0;                  // total bytes read is 0.
    repeat
      // Using BlobHandle, store at most "bytes_left" bytes in
      //   the buffer starting where I last left off
      GetSegment(BlobHandle, @st[total_bytes_read + 1], bytes_left, bytes_read);
      // Increment total_bytes_read by the number of bytes actually read.
      Inc(total_bytes_read, bytes_read);
      // Decrement bytes_left by the number of bytes actually read.
      Dec(bytes_left, bytes_read);
    until bytes_left <= 0;
  end;
  result := MakeResultString(PChar(Trim(st)), nil, 0);
end;


end.
