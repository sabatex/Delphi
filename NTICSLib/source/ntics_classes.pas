unit ntics_classes;
interface
uses types;
type
  TDWORDArray = array of DWORD;
  TSecretKey = record
    EDRPOU:string[10];
    ID_FIZ:integer;
    COMPANY_NAME:string;
    LICENZE:integer;
    SERIAL:string;
  end;


implementation

{ TPeriod }


end.