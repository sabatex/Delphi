unit Classes8DR;
interface
type
  T8DR = record
    NP:integer;
    PERIOD:integer;
    RIK:integer;
    KOD:string[10];
    TYP:integer;
    TIN:string[10];
    S_DOX:Currency;
    S_TAX:Currency;
    D_PRIYN:TDateTime;
    D_ZVILN:TDateTime;
    OZN_DOX:integer;
    OZN_PILG:integer;
    OZNAKA:integer;
  end;
  T8DRArray = array of T8DR;

implementation

end.
