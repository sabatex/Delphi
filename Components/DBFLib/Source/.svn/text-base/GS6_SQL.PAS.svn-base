unit gs6_sql;
{-----------------------------------------------------------------------------
                          Basic Expression Resolver

       gs6_sql Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          4 Mar 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit evaluates expressions and returns the result.

   Changes:

------------------------------------------------------------------------------}
{$I defines.inc}
interface
uses
   SysHalc,
   SysUtils,
   Classes,
   {$IFDEF Delphi6} Variants, {$ENDIF} { Kirill }
   gs6_cnst,
   gs6_tool,
   gs6_date,
   gs6_glbl;

type
   TgsExpressionType  = (etUnknown, etAbsorbed, etContainer, etOperator,
                           etFunction, etFieldVar, etTextLit, etNumLit,
                           etDateLit, etBlnLit, etVariable);

   TgsExpResultType   = (rtUnknown, rtEmpty, rtAny, rtText, rtFloat, rtInteger,
                           rtDate, rtDateTime, rtBoolean, rtMemo, rtPointer);

   TgsExpHandler = class;
   TgsExpFunction = class;

   TgsUserDefFunction = class(TObject)
   (*An object of TgsUserDefFunction is created for each function registered in
     the expression handler.  This class provides the actual code to handle the
     specific function calculation.*)
   public
      function FunctionName: gsUTFString; virtual;
      (*Returns the function name of the owner of this object.  The result string
        is typically used in the search for the name of a function assigned in an
        expression.*)

      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                              var ExpResult: TgsExpResultType): boolean; virtual;
      (*This method is used to return the results expected for this specific
        function.  The function return value is placed in Buffer.  The resut
        type is returned in ExpResult.  A result of true is returned upon the
        successful completion of the calculation.*)
   end;

   TgsUserDefFieldVar = class(TObject)
   (*An object of TgsUserDefFieldVar is created for each variable registered in
     the expression handler.  This class provides the actual code to return the
     variable value to the expression handler.*)
   private
      FName: gsUTFString;
      FVarLen: integer;
      FDescendents: boolean;
   public
      constructor Create(const AName: gsUTFString);
      (*Creates an instance of the class TgsUserDefFieldVar for the variable AName.*)
      destructor Destroy; override;
      (*Releases memory allocated for the variable name string and frees the class.*)

      function FieldVarName: gsUTFString; virtual;
      (*Returns the variable name of the owner of this object.  The result string
        is typically used in the search for the name of a variable assigned in an
        expression.*)

      function FieldVarType: integer; virtual;
      (*Returns the variable type of the owner of this object.  The result integer
        default is 0.  Descendants will pass their own type for use in enumerating
        a list of specific variable types (for example, for database fields) of a
        variable assigned in an expression.*)

      function FieldVarResult(var BufVar: variant;
                              var ExpResult: TgsExpResultType): boolean; virtual;
      (*This method is used to return the results expected for this specific
        variable.  The variable return value is placed in Buffer.  The resut
        type is returned in ExpResult.  A result of true is returned upon the
        successful retrieval of the variable.*)

      property VarLength: integer read FVarLen write FVarLen;
      (*Property returns the fixed length for a numeric field.  This is needed
        when several numeric fields are combined to determine the size of a result
        string of the value.  Used internally for numeric fields*)
      property Descendents: boolean read FDescendents write FDescendents;
   end;

   TgsFunctionReg = class(TList)
   (*Container class for TgsUserDefFunction objects.  Used to access each of
     the objects by reference to its Index value.*)
   public
      destructor Destroy; override;
      (*Frees all TgsUserDefFunction objects contained in the list.*)

      function RegisterFunction(AFunction: TgsUserDefFunction): boolean;
      (*Adds the TgsUserDefFunction object to the end of the list.  Returns
        true if successful.*)

      function FunctionName(Index: integer): gsUTFString;
      (*Returns the name of the TgsUserDefFunction object stored at Index in the
        list.  Returns an empty string if the Index is not valid.*)

      function FunctionLink(Index: integer): TgsUserDefFunction;
      (*Returns The pointer to the TgsUserDefFunction object stored at Index in
        the list.  Returns nil if the index is not valid.*)
   end;

   TgsFieldVarReg = class(TList)
   (*Container class for TgsUserDefFieldVar objects.  Used to access each of
     the objects by reference to its Index value.*)
   public
      destructor Destroy; override;
      (*Frees all TgsUserDefFieldVar objects contained in the list.*)

      function RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
      (*Adds the TgsUserDefFieldVar object to the end of the list.  Returns
        true if successful.*)

      function FieldVarName(Index: integer): gsUTFString;
      (*Returns the name of the TgsUserDefFieldVar object stored at Index in the
        list.  Returns an empty string if the Index is not valid.*)

      function FieldVarType(Index: integer): integer;
      (*Returns the variable type of the TgsUserDefFieldVar object stored at
        Index in the list.  Returns zero if the Index is not valid.*)

      function FieldVarLink(Index: integer): TgsUserDefFieldVar;
      (*Returns The pointer to the TgsUserDefFieldVar object stored at Index in
        the list.  Returns nil if the index is not valid.*)
   end;

   TgsExpUserLink = class(TObject)
   (*Handler class to manage user-registered functions and variables.*)
   private
      UserFunctionRegistry: TgsFunctionReg;
      UserFieldVarRegistry: TgsFieldVarReg;
      FStrSize: integer;
   public
      constructor Create;
      (*Creates a TgsExpUserLink instance and allocates TgsFunctionReg and
        TgsFieldVar containers to hold function and variable objects.*)

      destructor Destroy; override;
      (*Frees the TgsFunctionReg and TgsFieldVar containers that were used to
        hold function and variable objects.*)

      function FindFunction(const AFunction: gsUTFString): TgsUserDefFunction; virtual;
      (*Searches the TgsFunctionRef container to find a function name to match
        AFunction.  Returns the pointer to the function if found, otherwise it
        returns nil.*)

      function FindFieldVar(const AFieldVar: gsUTFString): TgsUserDefFieldVar; virtual;
      (*Searches the TgsFieldVarReg container to find a variable name to match
        AFieldVar.  Returns the pointer to the variable function if found,
        otherwise it returns nil.*)

      function RegisterFunction(AFunction: TgsUserDefFunction): boolean;
      (*Registers a user function in the TgsFunctionRef container.  Returns true
        if successful.*)

      function RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
      (*Registers a user variable in the TgsFieldVarRef container.  Returns true
        if successful.*)

      function OnNoFunction(const AFunction: gsUTFString): TgsUserDefFunction; virtual;

      property DefaultStrSize: integer read FStrSize write FStrSize;
      (*Returns the default string length used for Str functions when the
        length argument is not provided.  The internal default is 10 characters.*)
   end;

   TgsExpBaseObject = class(TObject)
   (*Base object class for all espression process classes.  Expression process
     classes are those such as TgsExpFunction that handles processing functions,
     TgsExpOperator that handle operator actions (+,-,*,/,and,or,not), and
     literal classes such as TgsTextLit, TgsDateLit,TgsBlnLit, and TgsNumLit
     that hold constant values.*)
   private
      FExpType     : TgsExpressionType;
      FResultType  : TgsExpResultType;
      FExpChg      : Boolean;
      FExpLen      : integer;
      FExpDec      : integer;
      FArgLeft     : TgsExpBaseObject;
      FArgRight    : TgsExpBaseObject;
   public
      constructor  Create;
                   (*Initializes internal values.*)

      destructor   Destroy; override;
      (*Frees expression process classes this object owns.*)

      function     ExpObjectContains: gsUTFString; virtual;
      (*Returns the function/variable name, literal, or operator assigned to
        this object.*)

      function     ExpObjectType: integer; virtual;
      (*Returns the type of the object linked to this object.  Can be used to
        determine the kind of link (database, local, etc)*)

      function     ExpRebuildExpression: gsUTFString; virtual;
      (*Reconstructs the expression by calling ExpObjectContains for all the
        FArgLeft and FArgRight expression processes and properly formating
        those strings with its own ExpObjectContains string.*)

      function     ExpEnumTypes(AType: integer): gsUTFString; virtual;

      procedure    ExpParse(var BufVar: variant;
                            var ExpResult: TgsExpResultType); virtual;
     (*Retrieves the calculated values for all subordinate expression processes
       and places the final calculated result in Buffer.  The Result Type is
       placed in ExpResult.  If successful, address of Buffer is returned as the
       result, otherwise nil is returned.*)
   end;

   TgsExpContainer = Class(TgsExpBaseObject)
   (*Holder class that contains a grouped collection of expression elements
     that were enclosed in parentheses.  This object is then passed as the
     left or right argument of an operator.*)
   public
      constructor   Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
      (*Creates a holder object that contains the expression elements in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is contained in parends.  For example, if the
        expression 1+2*(3+4)-5 was assigned to the expression handler, it would
        send the (3+4) to a TgsExpContainer object, where it would be processed.
        Then, the expression handler would deal only with this object when it
        needed to calculate the result: 1+2*object-5.  Note that when Avalue is
        processed, it may generate TgsExpContainer or TgsExpFunction objects
        owned by this object if there are parend groups or functions inside AValue.*)

      function      ExpRebuildExpression: gsUTFString; override;
      (*Reconstructs the expression by calling ExpObjectContains for the
        FArgLeft and FArgRight expression processes and properly formating those
        strings with its own ExpObjectContains string.  This string is enclosed
        in parends and returned.*)

      function     ExpEnumTypes(AType: integer): gsUTFString; override;

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Retrieves the calculated values for all subordinate expression processes
        and places the final calculated result in Buffer.  The Result Type is
        placed in ExpResult.  If successful, address of Buffer is returned as
        the result, otherwise nil is returned.*)
   end;

   TgsExpFunction = Class(TgsExpBaseObject)
   (*Holder class for a function.  This class will link to the correct function
     and handle assembling the function argument list.*)
   private
      FOwner        : TgsExpHandler;
      FUDF          : TgsUserDefFunction;
      FArgList      : TList;
   protected
      function      FetchUser: TgsExpUserLink;
   public
      constructor   Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
      (*Creates a holder object that contains the function expression in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is identified as a function.  An argument list is
        allocated to hold the expression processes that constitute the arguments
        for the function.  For example, if the expression PadR('Hello',9)+'World'
        was assigned to the expression handler, it would send the PadR('Hello',9)
        to a TgsExpFunction object, where it would be processed. The function
        for PadR (a descendant of TgsUserDefFunction) would be located and saved
        in this object.  First, the system functions would be searched for a
        match with AValue. If this is unsuccessful, the UserLink of the owner
        expression handler in AOwner is searched. If the function is not found,
        an exception is raised.  The expression processes for 'Hello" and 9
        would be stored in the object's argument list. Then, the expression
        handler would deal only with this object when it needed to calculate the
        result: object+'World'.  Note that when Avalue is processed, it may
        generate TgsExpContainer or TgsExpFunction objects owned by this object
        if there are parend groups or functions inside AValue.*)

      destructor    Destroy; override;
      (*Frees the argument list created for this function.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the name of the function linked to this object.*)

      function      ExpRebuildExpression: gsUTFString; override;
      (*Reconstructs the expression by calling ExpObjectContains for each of the
        argument list expression processes and properly formating those strings
        with its own ExpObjectContains string to construct the complete function
        string.*)

      function     ExpEnumTypes(AType: integer): gsUTFString; override;

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Calls the TgsUserDefFunction.ExpParse method of the function linked to
        this object. The final calculated result is returned in Buffer.  The
        Result Type is returned in ExpResult. If successful, address of Buffer
        is returned as the result, otherwise nil is returned.*)

     procedure      FetchArg(Index: integer; var BufVar: variant;
                       var ExpResult: TgsExpResultType;
                       ExpResultNeeded: TgsExpResultType);
     (*Method that is called by the TgsUserDefFunction.ExpParse method of the
       function linked to this object to retrieve the argument located at Index.
       If Index is valid, the ExpParse method of the expression process in the
       argument list is called.  If the returned ExpResult result is not equal
       to ExpResultNeeded or rtAny, an exception is raised.  If successful, the
       result is returned in Buffer and the result type is returned in ExpResult.*)
   end;

   TgsExpFieldvar = Class(TgsExpBaseObject)
   (*Holder class for a variable.  A variable can be any value generated by the
     user application.  Database fields are considered variables and can be
     retrieved through this object type.*)
   private
      FOwner        : TgsExpHandler;
      FUDF          : TgsUserDefFieldVar;
   protected
      function      FetchUser: TgsExpUserLink;
   public
      constructor   Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
      (*Creates a holder object that contains the variable expression in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is identified as a variable.  The variable expression
        process (a descendant of TgsUserDefFieldVar) would be located and saved
        in this object by searching the UserLink of the owner expression handler
        in AOwner.  If the variable is not found, an exception is raised.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the name of the variable linked to this object.*)

      function      ExpObjectType: integer; override;
      (*Returns the type of the variable linked to this object.  Can be used to
        determine the kind of link (database, local, etc)*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Calls the TgsUserDefFieldVar.ExpParse method of the variable linked to
        this object. The result is returned in Buffer. The Result Type is
        returned in ExpResult.*)
   end;

   TgsExpOperator = Class(TgsExpBaseObject)
   (*Holder class for an operator.  The operator can be for numeric, relational,
     or string concatenation operations*)
   private
      FOperator     : gsUTFChar;
      FPrecedence   : gsUTFChar;
      FInsensitive  : boolean;
      FWildCards    : boolean;
      FWildCharAll  : gsUTFChar;
      FWildCharOne  : gsUTFChar;
   protected
      function StrWCComp(vStr1, vStr2 : variant): Integer;
   public
      constructor   Create(AOperator, APrecedence: char);
      (*Creates the holder class for the operator identified in AOperator.
        The precedence of the operator is saved using the value of APrecedence.
        This determines the order in which operations are sequenced.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the symbol of the operator linked to this object.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Calls ExpParse for the FArgLeft and FArgRight expression processes and
      then acts based on the operator and places the final calculated result in
      Buffer.  The Result Type is placed in ExpResult.  If the operation cannot
      be done on the two arguments, an exception is raised*)
   end;

   TgsExpTextLit = Class(TgsExpBaseObject)
   (*Holder class for a text literal.*)
   private
      FExpValue     : gsUTFString;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal text value in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is identified as a text literal.*)

      destructor    Destroy; override;
      (*Frees the memory allocated to hold the text literal value.*)

      function      ExpObjectContains: gsUTFString; override;
     (*Returns the text literal.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
     (*Returns the text literal in Buffer.  Returns rtText in ExpResult.*)
   end;

   TgsExpNumLit = Class(TgsExpBaseObject)
   (*Holder class for a numeric literal.*)
   private
      FExpFloat     : FloatNum;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal numeric value stored
        in AValue. This class is allocated as the original expression is
        generated and part of the expression is identified as a numeric literal.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the numeric literal as a string.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
    (*Returns the numeric literal as a FloatNum type in Buffer.  Returns rtFloat
      in ExpResult.*)
   end;

   TgsExpDateLit = Class(TgsExpBaseObject)
   (*Holder class for a date literal.*)
   private
      FExpDate     : FloatNum;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal date value stored
        in AValue. This class is allocated as the original expression is
        generated and part of the expression is identified as a date literal.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the date literal as a Julian Date string.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
    (*Returns the numeric literal as a FloatNum type in Buffer.  Returns rtDate
      in ExpResult.*)
   end;

   TgsExpBlnLit = Class(TgsExpBaseObject)
   (*Holder class for a boolean literal.*)
   private
      FExpLogic     : boolean;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal boolean value stored
        in AValue. This class is allocated as the original expression is
        generated and part of the expression is identified as a boolean literal.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the boolean literal as '.T.' or '.F.'.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
    (*Returns the boolean literal as a boolean type in Buffer.  Returns rtBoolean
      in ExpResult.*)
   end;

   TgsExpHandler = Class(TObject)
   (*An Expression Handler class compiles and evaluates an expression that is
     assigned to it.  The expression can be any type commonly used in dBase
     index key and filter expressions.   Additionally, SQL Select..Where style
     expressions can be processed.*)
   private
      FUserLink   : TgsExpUserLink;
      FResultType  : TgsExpResultType;
      FExpChg      : Boolean;
      FExpLen      : integer;
      FExpDec      : integer;
      FParseObj    : TgsExpBaseObject;
      FArgCount    : integer;
      FInsensitive : boolean;
      FWildCards   : boolean;
      FWildCharAll : gsUTFChar;
      FWildCharOne : gsUTFChar;
      function CompressExpression(const Value: gsUTFString): gsUTFString;
      function GenerateObjects(const Value: gsUTFString): TgsExpBaseObject;
      function     GetExpression: gsUTFString; virtual;
      procedure    SetExpression(const AExpression: gsUTFString);
      function ScanFunctionGroup(const workStr: gsUTFString; ElemStart: integer;
                                 UseComma: boolean): integer;
      function CheckForOperator(var workStr, resultStr: gsUTFString): boolean;
      function CheckForGroup(var workStr, resultStr: gsUTFString): boolean;
      function CheckForEntity(var workStr, resultStr: gsUTFString): boolean;
      function CheckForLiteral(var workStr, resultStr: gsUTFString): boolean;
      function CheckForNumber(var workStr, resultStr: gsUTFString): boolean;
      function CheckForTrueFalse(var workStr, resultStr: gsUTFString): boolean;
      function CheckForLogical(var workStr, resultStr: gsUTFString): boolean;
      function CheckForNegation(var workStr, resultStr: gsUTFString): boolean;
   public
      constructor  Create(AUser: TgsExpUserLink; const AExpression: gsUTFString; IsSQL: boolean);
      (*Initializes the expression handler parameters.  Argument AUser is the
        TgsExpUserLink object that allows external variables and functions to be
        included in the expression compilation and evaluation.  AExpression is the
        expression to be compiled.  It can be nil, and the Expression passed in the
        Expression property later.  IsSQL is a boolean identifying whether dBase
        or SQL wildcard tokens will be used.*)

      destructor   Destroy; override;
      (*Frees resources allocated for the object.*)

      procedure ExpressionResult(var BufVar: variant); virtual;
      (*Requests the Expression be evaluated and the results returned in Buffer.
        The requestor will need to get the type through a call to ResultType to
        determine the type of value returned.  If successful, Result returns
        Buffer; otherwise it returns nil.*)

      procedure     ExpressionAsVariant(var AVar: TgsVariant); virtual;
      (*Requests the Expression be evaluated and the results returned in AVar as
        a TgsVariant.*)

      function     ResultType: TgsExpResultType;
      (*Returns the type of value (rtText, rtDate, rtBoolean, rtFloat, etc.) to
        which the expression evaluates.*)

      function     EnumerateType(AType: integer): gsUTFString;

      property     UserLink: TgsExpUserLink read FUserLink write FUserLink;
      (*Returns the pointer to the user link attached to this object.*)

      property     Expression: gsUTFString read GetExpression write SetExpression;
      (*This property sets the expression or returns the expression string.  If
        assigning a new expression, the expression processes assigned to the
        old expression are released and new ones created as the new expression is
        compiled.*)
      property     ArgCount: integer read FArgCount;
      (*Returns the number of expression processes allocated for the expression.*)

      property     DecimalCount: integer read FExpDec;
      (*Used to return the number of decimals to be used when a number (rtFloat)
        is converted to a string.  This is needed for dBase fields returned as
        variables since they specify the number of decimal places, but are handled
        as floating point numbers.*)

      property     NumberLength: integer read FExpLen;
      (*Used to return the number of digits (including decimal point) to be used
        when a number (rtFloat) is converted to a string.  This is needed for
        dBase fields returned as variables since they specify the field length,
        but are handled as floating point numbers.*)

      property     CaseInsensitive: boolean read FInsensitive write FInsensitive;
      (*Flag determines if a text comparison is case insensitive.*)

      property     UseWildCards: boolean read FWildCards write FWildCards;
      (*Flag determines if wild cards can be used in a text comparison.*)

      property     WildCardAll: char read FWildCharAll write FWildCharAll;
      (*Assigns the wild card character that is used to designate any number
        of characters is valid.  The default is '*'.  (e.g. 'SM*' would match
        any string that started with SM, for example, SMITH and SMYTHE).  If the
        expression handler was created with IsSQL true, then the '%' character
        is automatically assigned.*)

      property     WildCardOne: char read FWildCharOne write FWildCharOne;
      (*Assigns the wildcard character used to designate a single place
        wildcard.  The default is '?'.  (e.g., GRIFF?N would match GRIFFIN and
        GRIFFEN). If the expression handler was created with IsSQL true, then
        the '_' character is automatically assigned.*)
   end;

   EHalcyonExpression = class(Exception);

var
   GSFunctionRegistry: TgsFunctionReg;

implementation

const
   DefStrLen   = 10;
   EmptyDate   = 1E100;
   DateDescendMax = 5231808;
   WildCardChar1 = '*';
   WildCardChar2 = '%';
   WildCardChar3 = '?';
   WildCardChar4 = '_';


(*
   exOpStrings = '@T@F@TRUE@FALSE@;-@;-@;-@;-@;-@AND@OR@NOT@';
   exOpStringSQL = '@T@F@TRUE@FALSE@EQ@LE@LT@GE@GT@AND@OR@NOT@LIKE@POS@';
   exOpT      = 1;
   exOpF      = 3;
   exOpTLong  = 5;
   exOpFLong  = 10;
   exOpEQ     = 16;
   exOpLE     = 19;
   exOpLT     = 22;
   exOpGE     = 25;
   exOpGT     = 28;
   exOpAND    = 31;
   exOpOR     = 35;
   exOpNOT    = 38;
   exOpLIKE   = 42;
   exopPOS    = 47;

   opTypeUnary = #$02;   {unary operators}
   opTypeMult  = #$03;   {multiplying operators}
   opTypeAdd   = #$04;   {adding operators}
   opTypeRelat = #$05;   {relational operators}
   opTypeRelNot= #$06;   {relational NOT}
   opTypeRelAnd= #$07;   {relational AND}
   opTypeRelOr = #$08;   {relational OR}
   opTypeGrpBg = #$09;   {grouped characters start}
   opTypeGrpEn = #$0A;   {grouped characters end}
   opTypeTxtBg = #$0B;   {literal text begin}
   opTypeTxtEn = #$0C;   {literal text end}
   opTypeDteBg = #$0D;   {literal date begin}
   opTypeDteEn = #$0E;   {literal date end}
   opTypeBlnLt = #$1A;   {literal boolean}
   opTypeComma = #$1B;   {comma delimiter in function args}
   opTypeSpace = #$1C;   {space character}
   opTypeFunct = #$1D;   {function}
   opTypeVarFld= #$1E;   {variable or field}
   opTypeNumLt = #$1F;   {numeric literal}
   opTypeLimit = #$20;

   opEQ        = #$81;   {=}
   opNE        = #$82;   {<>,!=,#}
   opGT        = #$83;   {>}
   opLT        = #$84;   {<}
   opGE        = #$85;   {>=,=>}
   opLE        = #$86;   {<=,=<}
   opPOS       = #$87;   { $}
   opExactEQ   = #$88;   {==}
   opPlus      = #$89;   {+}
   opMinus     = #$8A;   {-}
   opMultiply  = #$8B;   {*}
   opDivide    = #$8C;   {/}
   opExponent  = #$8D;   {**,^}
   opAND       = #$90;   {AND}
   opOR        = #$91;   {OR}
   opNOT       = #$92;   {NOT}
   opLike      = #$93;   {LIKE}
   opQuoteOpen = #$98;   {",',[}
   opQuoteEnd  = #$99;   {",',]}
   opGroupOpen = #$9A;   {(}
   opGroupEnd  = #$9B;   {)}
   opDateOpen  = #$9C;   {Open Brace}
   opDateEnd   = #$9D;   {Close Brace}
   opRefPtr    = #$9E;   {Reference Pointer (-> or .)}
*)

   ExpElementEnd = #01;
   opTypeUnary = #$02;   {unary operators}
   opTypeMult  = #$03;   {multiplying operators}
   opTypeAdd   = #$04;   {adding operators}
   opTypeRelat = #$05;   {relational operators}
   opTypeRelNot= #$06;   {relational NOT}
   opTypeRelAnd= #$07;   {relational AND}
   opTypeRelOr = #$08;   {relational OR}

   opElemEQ        = #$81;   {=}
   opElemNE        = #$82;   {<>,!=,#}
   opElemGT        = #$83;   {>}
   opElemLT        = #$84;   {<}
   opElemGE        = #$85;   {>=,=>}
   opElemLE        = #$86;   {<=,=<}
   opElemPOS       = #$87;   { $}
   opElemExactEQ   = #$88;   {==}
   opElemPlus      = #$89;   {+}
   opElemMinus     = #$8A;   {-}
   opElemMultiply  = #$8B;   {*}
   opElemDivide    = #$8C;   {/}
   opElemExponent  = #$8D;   {**,^}
   opElemAND       = #$90;   {AND}
   opElemOR        = #$91;   {OR}
   opElemNOT       = #$92;   {NOT}
   opElemLike      = #$93;   {LIKE}
   opElemFunction  = #$98;   {Function}
   opElemVariable  = #$99;   {Variable}
   opElemGroup     = #$9A;   {(..)}
   opElemText      = #$9B;   {Text Literal}
   opElemDate      = #$9C;   {Date Literal}
   opElemNumber    = #$9D;   {Number Literal}
   opElemBoolean   = #$9E;   {Boolean Literal}
   opElemUnary     = #$9F;   {Unary Operator}

   LogicValueCount = 8;
   OperatorValueCount = 18;
   ParserValueCount = LogicValueCount + OperatorValueCount;
   ParserValueArray : array[0..ParserValueCount-1] of gsUTFString =
                           ('AND','OR','EQ','NE','GE','LE','LT','GT',

                            '=','+','-','*','/','**','^',
                            '<>','!=','#','>','<','>=','=>',
                            '<=','=<','$','==');


   ParserActionArray : array[0..ParserValueCount-1] of gsUTFChar =
                            (opElemAND,opElemOR,opElemEQ,opElemNE,
                             opElemGE,opElemLE,opElemLT,opElemGT,

                             opElemEQ,opElemPlus,opElemMinus,opElemMultiply,
                             opElemDivide,opElemExponent,opElemExponent,
                             opElemNE,opElemNE,opElemNE,opElemGT,opElemLT,
                             opElemGE,opElemGE,opElemLE,opElemLE,opElemPos,
                             opElemExactEQ);










   SingleQuote = '''';
   DoubleQuote = '"';


{---------------------------------------------------------------------------
                         User Defined Functions
----------------------------------------------------------------------------}
type
   TgsUDFAllTrim = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFAsc = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFAt = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFAtC = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFBetween = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFCeiling = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFChr = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFCTOD = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFDate = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFDescend = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFDOW = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFDTOC = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFDTOS = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFEmpty = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFFloor = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFIIF = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFInt = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFLeft = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFLen = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFLower = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFLTrim = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFMod = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFPadMain = class(TgsUserDefFunction)
      PadChar: gsUTFChar;
      PadSize: integer;
      PadText: gsUTFString;
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

         TgsUDFPadC = class(TgsUDFPadMain)
            function FunctionName: gsUTFString; override;
            function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                                    var ExpResult: TgsExpResultType): boolean; override;
         end;

         TgsUDFPadL = class(TgsUDFPadMain)
            function FunctionName: gsUTFString; override;
            function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                                    var ExpResult: TgsExpResultType): boolean; override;
         end;

         TgsUDFPadR = class(TgsUDFPadMain)
            function FunctionName: gsUTFString; override;
            function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                                    var ExpResult: TgsExpResultType): boolean; override;
         end;

   TgsUDFProper = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFRight = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFSoundex = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFSpace = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFStr = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

         TgsUDFStrZero = class(TgsUDFStr)
            function FunctionName: gsUTFString; override;
            function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                            var ExpResult: TgsExpResultType): boolean; override;
         end;

   TgsUDFStrTran = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFSubStr = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

   TgsUDFTrim = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

         TgsUDFRTrim = class(TgsUDFTrim)
            function FunctionName: gsUTFString; override;
         end;

    TgsUDFUpper = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;

    TgsUDFVal = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      function FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType): boolean; override;
   end;



{---------------------------------------------------------------------------
                            Ceiling and Floor
----------------------------------------------------------------------------}

function Ceil(X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) > 0 then
    Inc(Result);
end;

function Floor(X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) < 0 then
    Dec(Result);
end;

{---------------------------------------------------------------------------
                             StrNumDec  (Decimal Places in Numeric String)
----------------------------------------------------------------------------}

function StrNumDec(const Str1: gsUTFString): integer;
var
   DecPos: integer;
begin
   Result := 0;
   if Length(Str1) <> 0 then
   begin
      DecPos := Pos('.',Str1);
      if DecPos > 0 then
      begin
         Result := Length(Str1)-DecPos;
      end;
   end;
end;

{---------------------------------------------------------------------------
                          TgsExpUserLink
----------------------------------------------------------------------------}

constructor TgsExpUserLink.Create;
begin
   inherited Create;
   UserFunctionRegistry := TgsFunctionReg.Create;
   UserFieldVarRegistry := TgsFieldVarReg.Create;
   FStrSize := DefStrLen;
end;

destructor TgsExpUserLink.Destroy;
begin
   UserFunctionRegistry.Free;
   UserFieldVarRegistry.Free;
   inherited Destroy;
end;

function TgsExpUserLink.FindFunction(const AFunction: gsUTFString): TgsUserDefFunction;
var
   i: integer;
begin
   i := 0;
   while (i < UserFunctionRegistry.Count) and
         (UserFunctionRegistry.FunctionName(i) <> AFunction) do
      inc(i);
   if i < UserFunctionRegistry.Count then
      Result := UserFunctionRegistry.FunctionLink(i)
   else
      Result := nil;
end;

function TgsExpUserLink.FindFieldVar(const AFieldVar: gsUTFString): TgsUserDefFieldVar;
var
   i: integer;
   s: gsUTFString;
begin
   i := 0;
   while (i < UserFieldVarRegistry.Count) and
         (UserFieldVarRegistry.FieldVarName(i) <> AFieldVar) do
      inc(i);
   if i < UserFieldVarRegistry.Count then
      Result := UserFieldVarRegistry.FieldVarLink(i)
   else
   begin
      s := AFieldVar;
      i := pos('.',s);
      if i > 0 then
      begin
         s := copy(s,i+1,MaxInt);
         i := 0;
         while (i < UserFieldVarRegistry.Count) and
           (UserFieldVarRegistry.FieldVarName(i) <> s) do
           inc(i);
         if i < UserFieldVarRegistry.Count then
            Result := UserFieldVarRegistry.FieldVarLink(i)
         else
            Result := nil;
      end
      else
         Result := nil;
   end;
end;

function TgsExpUserLink.RegisterFunction(AFunction: TgsUserDefFunction): boolean;
begin
   Result := UserFunctionRegistry.RegisterFunction(AFunction);
end;

function TgsExpUserLink.OnNoFunction(const AFunction: gsUTFString): TgsUserDefFunction;
begin
   raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[AFunction]);
end;


function TgsExpUserLink.RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
begin
   Result := UserFieldVarRegistry.RegisterFieldVar(AFieldVar);
end;

{---------------------------------------------------------------------------
                        TgsFunctionReg
----------------------------------------------------------------------------}

destructor TgsFunctionReg.Destroy;
var
   i: integer;
begin
   for i := 0 to Count-1 do
   begin
      TgsUserDefFunction(Items[i]).Free;
   end;
   inherited Destroy;
end;

function TgsFunctionReg.RegisterFunction(AFunction: TgsUserDefFunction): boolean;
begin
   Result := true;
   if AFunction = nil then exit;
   try
      Add(AFunction);
   except
      Result := false;
   end;
end;

function TgsFunctionReg.FunctionName(Index: integer): gsUTFString;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFunction(Items[Index]).FunctionName
   else
      Result := '';
end;

function TgsFunctionReg.FunctionLink(Index: integer): TgsUserDefFunction;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFunction(Items[Index])
   else
      Result := nil;
end;



{---------------------------------------------------------------------------
                        TgsFieldVarReg
----------------------------------------------------------------------------}

destructor TgsFieldVarReg.Destroy;
var
   i: integer;
begin
   for i := 0 to Count-1 do
   begin
      TgsUserDefFieldVar(Items[i]).Free;
   end;
   inherited Destroy;
end;

function TgsFieldVarReg.RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
begin
   Result := true;
   try
      Add(AFieldVar);
   except
      Result := false;
   end;
end;

function TgsFieldVarReg.FieldVarName(Index: integer): gsUTFString;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFieldVar(Items[Index]).FieldVarName
   else
      Result := '';
end;

function TgsFieldVarReg.FieldVarType(Index: integer): integer;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFieldVar(Items[Index]).FieldVarType
   else
      Result := 0;
end;

function TgsFieldVarReg.FieldVarLink(Index: integer): TgsUserDefFieldVar;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFieldVar(Items[Index])
   else
      Result := nil;
end;


{---------------------------------------------------------------------------
                      Abstract TgsUserDefFunction
----------------------------------------------------------------------------}

function TgsUserDefFunction.FunctionName: gsUTFString;
begin
   FunctionName := '';
end;

function TgsUserDefFunction.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
begin
   FunctionResult := false;
end;

{---------------------------------------------------------------------------
                            TgsUserFieldVar
----------------------------------------------------------------------------}

constructor TgsUserDefFieldVar.Create(const AName: gsUTFString);
begin
   Inherited Create;
   FVarLen := 0;
   FDescendents := false;
   FName := AnsiUpperCase(AName);
end;

destructor TgsUserDefFieldVar.Destroy;
begin
   inherited Destroy;
end;

function TgsUserDefFieldVar.FieldVarName: gsUTFString;
begin
   FieldVarName := FName;
end;

function TgsUserDefFieldVar.FieldVarType: integer;
begin
   Result := gsSQLTypeVarStd;
end;

function TgsUserDefFieldVar.FieldVarResult(var BufVar: variant;
                            var ExpResult: TgsExpResultType): boolean;
begin
   FieldVarResult := false;
end;

{---------------------------------------------------------------------------
                             AllTrim() Function
----------------------------------------------------------------------------}

function TgsUDFAllTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'ALLTRIM';
end;

function TgsUDFAllTrim.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   BufVar := Trim(s);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                              ASC() Function
----------------------------------------------------------------------------}

function TgsUDFAsc.FunctionName: gsUTFString;
begin
   FunctionName := 'ASC';
end;

function TgsUDFAsc.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   if length(s) = 0 then s := #0;
   BufVar := ord(s[1]);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             At() Function
----------------------------------------------------------------------------}

function TgsUDFAt.FunctionName: gsUTFString;
begin
   FunctionName := 'AT';
end;

function TgsUDFAt.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   d: integer;
   p: integer;
   t: integer;
   w: floatnum;
   s1: gsUTFString;
   s2: gsUTFString;
begin
   ExpResult := rtFloat;
   d := 1;
   t := 0;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := BufVar;
   Caller.FetchArg(1, BufVar, r, rtText);
   s2 := BufVar;
   Caller.FetchArg(2, BufVar, r, rtAny);
   if r = rtFloat then
   begin
      w := BufVar;
      d := trunc(w);
   end;
   while d > 0 do
   begin
      p := Pos(s1,s2);
      if p > 0 then
      begin
         t := t + p;
         s2 := copy(s2,p+1,length(s2));
         dec(d);
      end
      else
      begin
         d := 0;
      end;
   end;
   BufVar := t;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             AtC() Function
----------------------------------------------------------------------------}

function TgsUDFAtC.FunctionName: gsUTFString;
begin
   FunctionName := 'ATC';
end;

function TgsUDFAtC.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   d: integer;
   p: integer;
   t: integer;
   w: floatnum;
   s1: gsUTFString;
   s2: gsUTFString;
begin
   ExpResult := rtFloat;
   d := 1;
   t := 0;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := BufVar;
   s1 := UpperCase(s1);
   Caller.FetchArg(1, BufVar, r, rtText);
   s2 := BufVar;
   s2 := UpperCase(s2);
   Caller.FetchArg(2, BufVar, r, rtAny);
   if r = rtFloat then
   begin
      w := BufVar;
      d := trunc(w);
   end;
   while d > 0 do
   begin
      p := Pos(s1,s2);
      if p > 0 then
      begin
         t := t + p;
         s2 := copy(s2,p+1,length(s2));
         dec(d);
      end
      else
      begin
         d := 0;
      end;
   end;
   BufVar := t;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Between() Function
----------------------------------------------------------------------------}

function TgsUDFBetween.FunctionName: gsUTFString;
begin
   FunctionName := 'BETWEEN';
end;

function TgsUDFBetween.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   x: TgsExpResultType;
   v1: variant;
   v2: variant;
   v3: variant;
   b: boolean;
begin
   ExpResult := rtBoolean;
   Caller.FetchArg(0, BufVar, x, rtAny);
   v1 := BufVar;
   Caller.FetchArg(1, BufVar, r, x);
   v2 := BufVar;
   Caller.FetchArg(2, BufVar, r, x);
   v3 := BufVar;
   b := (v1 >= v2) and (v1 <= v3);
   BufVar := b;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Ceiling() Function
----------------------------------------------------------------------------}

function TgsUDFCeiling.FunctionName: gsUTFString;
begin
   FunctionName := 'CEILING';
end;

function TgsUDFCeiling.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   f: FloatNum;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   f := ceil(f);
   BufVar := f;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Chr() Function
----------------------------------------------------------------------------}

function TgsUDFChr.FunctionName: gsUTFString;
begin
   FunctionName := 'CHR';
end;

function TgsUDFChr.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   d: integer;
   c: gsUTFChar;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   d := BufVar;
   if (d < 0) or (d > 255) then
      raise EHalcyonExpression.CreateFMT(gsErrArgInvalid,['Byte']);
   c := chr(d);
   BufVar := c;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             CTOD() Function
----------------------------------------------------------------------------}

function TgsUDFCTOD.FunctionName: gsUTFString;
begin
   FunctionName := 'CTOD';
end;

function TgsUDFCTOD.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   s: gsUTFString;
begin
   ExpResult := rtDate;
   rtneeded := rtText;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   s := BufVar;
   if length(s) = 0 then
      f := EmptyDate
   else
   begin
      j := DBFDate.CTOD(s);
      f := j;
   end;
   BufVar := f;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Date() Function
----------------------------------------------------------------------------}

function TgsUDFDate.FunctionName: gsUTFString;
begin
   FunctionName := 'DATE';
end;

function TgsUDFDate.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   d: longint;
begin
   ExpResult := rtDate;
   d := DBFDate.Date;
   BufVar := d;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Descend() Function
----------------------------------------------------------------------------}

function TgsUDFDescend.FunctionName: gsUTFString;
begin
   FunctionName := 'DESCEND';
end;

function TgsUDFDescend.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   s: gsUTFString;
   i: integer;
   b: boolean;
begin
   Caller.FetchArg(0, BufVar, r, rtAny);
   ExpResult := r;
   if r in [rtDate..rtDateTime] then
   begin
      if BufVar <> EmptyDate then
         BufVar := DateDescendMax-BufVar;
   end
   else
      if r in [rtFloat..rtInteger] then
      begin
         if BufVar <> 0.0 then
            BufVar := -BufVar;
      end
      else
         if r = rtText then
         begin
            s := BufVar;
            for i := 1 to length(s) do
            begin
               s[i] := chr(-ord(s[i]));
            end;
         end
         else
            if r = rtBoolean then
            begin
               b := BufVar;
               b := not b;
               BufVar := b;
            end
            else
               BufVar := false;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                              DOW() Function
----------------------------------------------------------------------------}

function TgsUDFDOW.FunctionName: gsUTFString;
begin
   FunctionName := 'DOW';
end;

function TgsUDFDOW.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   d: FloatNum;
   i: integer;
begin
   ExpResult := rtFloat;
   rtneeded := rtDate;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   f := BufVar;
   if f <> EmptyDate then
   begin
      j := trunc(f);
      i := DBFDate.DOW(j);
      d := i;
   end
   else
      d := 0;
   BufVar := d;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             DTOC() Function
----------------------------------------------------------------------------}

function TgsUDFDTOC.FunctionName: gsUTFString;
begin
   FunctionName := 'DTOC';
end;

function TgsUDFDTOC.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   s: gsUTFString;
   l: integer;
begin
   ExpResult := rtText;
   rtneeded := rtDate;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   f := BufVar;
   if f <> EmptyDate then
   begin
      j := trunc(f);
      Caller.FetchArg(1, BufVar, r, rtAny);
      if r = rtFloat then
      begin
         l := BufVar;
      end
      else
      begin
         l := 0;
      end;
      if l = 1 then
         s := DBFDate.DTOS(j)
      else
         s := DBFDate.DTOC(j);
   end
   else
      s := DBFDate.DTOC(0);
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             DTOS() Function
----------------------------------------------------------------------------}

function TgsUDFDTOS.FunctionName: gsUTFString;
begin
   FunctionName := 'DTOS';
end;

function TgsUDFDTOS.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   s: gsUTFString;
begin
   ExpResult := rtText;
   rtneeded := rtDate;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   f := BufVar;
   if f <> EmptyDate then
   begin
      j := trunc(f);
      s := DBFDate.DTOS(j);
   end
   else
      s := '        ';
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Empty() Function
----------------------------------------------------------------------------}

function TgsUDFEmpty.FunctionName: gsUTFString;
begin
   FunctionName := 'EMPTY';
end;

function TgsUDFEmpty.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   s: gsUTFString;
   i: integer;
   rtneeded: TgsExpResultType;
begin
   ExpResult := rtBoolean;
   rtneeded := rtAny;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   if r in [rtDate..rtDateTime] then
   begin
      if (BufVar = EmptyDate) or (BufVar = 0) then
         BufVar := true
      else
         BufVar := false;
   end
   else
      if r in [rtFloat..rtInteger] then
      begin
         if (BufVar = 0.0) then
            BufVar := true
         else
            BufVar := false;
      end
      else
         if r = rtText then
         begin
            s := BufVar;
            i := length(s);
            while (i > 0) and (s[i] = ' ') do dec(i);
            if i = 0 then
               BufVar := true
            else
               BufVar := false;
         end
         else
            if r = rtBoolean then
            begin
               BufVar := not BufVar;
            end
            else
               BufVar := false;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Floor() Function
----------------------------------------------------------------------------}

function TgsUDFFloor.FunctionName: gsUTFString;
begin
   FunctionName := 'FLOOR';
end;

function TgsUDFFloor.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   f: FloatNum;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := floor(BufVar);
   BufVar := f;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             IIF() Function
----------------------------------------------------------------------------}

function TgsUDFIIF.FunctionName: gsUTFString;
begin
   FunctionName := 'IIF';
end;

function TgsUDFIIF.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
begin
   ExpResult := rtEmpty;
   Caller.FetchArg(0, BufVar, r, rtBoolean);
   if BufVar then
      Caller.FetchArg(1,BufVar, ExpResult, rtAny)
   else
      Caller.FetchArg(2,BufVar, ExpResult, rtAny);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Int() Function
----------------------------------------------------------------------------}

function TgsUDFInt.FunctionName: gsUTFString;
begin
   FunctionName := 'INT';
end;

function TgsUDFInt.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   f: FloatNum;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   f := int(f);
   BufVar := f;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Left() Function
----------------------------------------------------------------------------}

function TgsUDFLeft.FunctionName: gsUTFString;
begin
   FunctionName := 'LEFT';
end;

function TgsUDFLeft.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   d: Cardinal;
   s: gsUTFString;
   w: floatnum;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   w := BufVar;
   if w <= 0.01 then
      d := 0
   else
      d := trunc(w);
   BufVar := Copy(s,1,d);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Len() Function
----------------------------------------------------------------------------}

function TgsUDFLen.FunctionName: gsUTFString;
begin
   FunctionName := 'LEN';
end;

function TgsUDFLen.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   i: integer;
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   i := Length(BufVar);
   BufVar := i;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Lower() Function
----------------------------------------------------------------------------}

function TgsUDFLower.FunctionName: gsUTFString;
begin
   FunctionName := 'LOWER';
end;

function TgsUDFLower.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   BufVar := gsStrLowerCase(BufVar);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             LTrim() Function
----------------------------------------------------------------------------}

function TgsUDFLTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'LTRIM';
end;

function TgsUDFLTrim.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   BufVar := TrimLeft(s);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                                Mod() Function
----------------------------------------------------------------------------}

function TgsUDFMod.FunctionName: gsUTFString;
begin
   FunctionName := 'MOD';
end;

function TgsUDFMOD.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   x: FloatNum;
   y: Floatnum;
   z: Floatnum;
   i: integer;
   j: integer;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   x := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   y := BufVar;
   i := trunc(x);
   j := trunc(y);
   z := i mod j;
   BufVar := z;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             PadMain() Function
----------------------------------------------------------------------------}

function TgsUDFPadMain.FunctionName: gsUTFString;
begin
   FunctionName := '';
end;

function TgsUDFPadMain.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   isvalid: boolean;
begin
   ExpResult := rtText;
   Caller.FetchArg(2, BufVar, r, rtAny);
   case r of
      rtEmpty : begin
                   PadChar := ' ';
                   isvalid := true;
                end;
      rtText  : begin
                   PadText := BufVar;
                   if Length(PadText) = 1 then
                   begin
                      PadChar := PadText[1];
                      isvalid := true;
                   end
                      else isvalid := false;
                end;
      else      isvalid := false;
   end;
   if not isvalid then
      raise EHalcyonExpression.CreateFMT(gsErrArgInvalid,['Char']);
   Caller.FetchArg(0, BufVar, r, rtAny);
   if r = rtEmpty then
      raise EHalcyonExpression.CreateFmt(gsErrArgValueNeeded,['Value',1,'Pad']);
   PadText := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   PadSize := BufVar;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             PadC() Function
----------------------------------------------------------------------------}

function TgsUDFPadC.FunctionName: gsUTFString;
begin
   FunctionName := 'PADC';
end;

function TgsUDFPadC.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   i: integer;
   v: integer;
   p: PChar;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := Length(PadText);
   if i < PadSize then
   begin
      p := AllocMem(PadSize+1);
      FillChar(p[0],PadSize,PadChar);
      v := (PadSize - i) div 2;
      Move(PadText[1],p[v], i);
      BufVar := StrPas(p);
      FreeMem(p);
   end
   else
      BufVar := PadText;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             PadL() Function
----------------------------------------------------------------------------}

function TgsUDFPadL.FunctionName: gsUTFString;
begin
   FunctionName := 'PADL';
end;

function TgsUDFPadL.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   i: integer;
   v: integer;
   p: PChar;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := Length(PadText);
   if i < PadSize then
   begin
      p := AllocMem(PadSize+1);
      FillChar(p[0],PadSize,PadChar);
      v := (PadSize - i);
      Move(PadText[1],p[v], i);
      BufVar := StrPas(p);
      FreeMem(p);
   end
   else
      BufVar := PadText;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             PadR() Function
----------------------------------------------------------------------------}

function TgsUDFPadR.FunctionName: gsUTFString;
begin
   FunctionName := 'PADR';
end;

function TgsUDFPadR.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   i: integer;
   p: PChar;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := Length(PadText);
   if i < PadSize then
   begin
      p := AllocMem(PadSize+1);
      FillChar(p[0],PadSize,PadChar);
      Move(PadText[1],p[0], i);
      BufVar := StrPas(p);
      FreeMem(p);
   end
   else
      BufVar := PadText;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Proper() Function
----------------------------------------------------------------------------}

function TgsUDFProper.FunctionName: gsUTFString;
begin
   FunctionName := 'PROPER';
end;

function TgsUDFProper.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   s: gsUTFString;
   i: integer;
   chl: gsUTFChar;
   chc: gsUTFChar;
begin
   chl := #0;
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;

   for i := 1 to Length(s) do
   begin
      chc := s[i];
      if chl in [#0,#$20..#$26,#$28..#$2F,#$3A..#$40,#$5B..#$5F,#$7B..#$7F] then
         gsBufUpperCase(@chc,1)
      else
         gsBufLowerCase(@chc,1);
      s[i] := chc;
      chl := chc;
   end;
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Right() Function
----------------------------------------------------------------------------}

function TgsUDFRight.FunctionName: gsUTFString;
begin
   FunctionName := 'RIGHT';
end;

function TgsUDFRight.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   d: integer;
   l: integer;
   v: integer;
   s: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   d := trunc(BufVar);
   v := Length(s);
   if d < v then
   begin
      if d < 0 then
         d := 0;
      if d > 0 then
      begin
         l := v-d;
         s := copy(s,l+1,d);
      end;
   end;
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             RTrim() Function
----------------------------------------------------------------------------}

function TgsUDFRTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'RTRIM';
end;

{---------------------------------------------------------------------------
                             Soundex() Function
----------------------------------------------------------------------------}

function TgsUDFSoundex.FunctionName: gsUTFString;
begin
   FunctionName := 'SOUNDEX';
end;

function TgsUDFSoundex.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   len: integer;
   C1: integer;
   s: gsUTFString;
   s1: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   len := Length(s);
   if len > 0 then
   begin
      s := UpperCase(s);
      if len > 1 then
      begin
         s1 := s[1];
         for C1 := 2 to len do
         begin
            {Assign a numeric value to each letter, except the first}
            case s[C1] of
               'B','F','P','V'                : s1 := s1 + '1';
               'C','G','J','K','Q','S','X','Z': s1 := s1 + '2';
               'D','T'                        : s1 := s1 + '3';
               'L'                            : s1 := s1 + '4';
               'M','N'                        : s1 := s1 + '5';
               'R'                            : s1 := s1 + '6';
               {All other letters, punctuation and numbers are ignored}
            end;
         end;
         {Go through the result, and remove any consecutive numeric values
          that are duplicates}
         s := s1[1];
         for C1 := 2 to len do
         begin
            if (s1[C1] <> s1[C1-1]) then
               s := s + s1[C1];
         end;
      end;
      {Maximum Soundex Length is 4, pad if less, then truncate}
   end;
   s := s + '0000';
   s := Copy(s,1,4);
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Space() Function
----------------------------------------------------------------------------}

function TgsUDFSpace.FunctionName: gsUTFString;
begin
   FunctionName := 'SPACE';
end;

function TgsUDFSPACE.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   f: FloatNum;
   l: integer;
   s: gsUTFString;
begin
   ExpResult := rtText;          {27 Jul 99}
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   l := trunc(f);
   SetLength(s,l);
   FillChar(s[1],l,' ');
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Str() Function
----------------------------------------------------------------------------}

function TgsUDFStr.FunctionName: gsUTFString;
begin
   FunctionName := 'STR';
end;

function TgsUDFStr.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   f: FloatNum;
   r: TgsExpResultType;
   l: integer;
   d: integer;
   h: integer;
   s: gsUTFString;
   t: TgsExpUserLink;
begin
   ExpResult := rtText;
   d := 0;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   Caller.FetchArg(1, BufVar, r, rtAny);
   if r = rtFloat then
   begin
      l := BufVar;
      Caller.FetchArg(2, BufVar, r, rtAny);
      if r = rtFloat then
      begin
         d := BufVar;
      end;
   end
   else
   begin
      l := DefStrLen;
      t := Caller.FetchUser;
      if t <> nil then
      begin
         h := t.DefaultStrSize;
         if h > 0 then
            l := h;
      end;
   end;
   str(f:l:d,s);
   if Length(s) > l then
   begin
      s := '';
      while length(s) < l do s := s + '*';
   end;
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             StrTran() Function
----------------------------------------------------------------------------}

function TgsUDFStrTran.FunctionName: gsUTFString;
begin
   FunctionName := 'STRTRAN';
end;

function TgsUDFStrTran.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   d: integer;
   v: integer;
   p: integer;
   src: gsUTFString;
   ptn: gsUTFString;
   rpl: gsUTFString;
   rsl: gsUTFString;
begin
   ExpResult := rtText;
   FunctionResult := true;
   Caller.FetchArg(0, BufVar, r, rtText);
   src := BufVar;
   if src = '' then
   begin
      BufVar := '';
      exit;
   end;
   Caller.FetchArg(1, BufVar, r, rtText);
   ptn := BufVar;
   if ptn = '' then
   begin
      BufVar := src;
      exit;
   end;
   Caller.FetchArg(2, BufVar, r, rtAny);
   if r = rtText then
      rpl := BufVar
   else
      rpl := '';
   Caller.FetchArg(3, BufVar, r, rtAny);
   if r = rtFloat then
      v := trunc(BufVar)
   else
      v := 1;
   Caller.FetchArg(4, BufVar, r, rtAny);
   if r = rtFloat then
      d := trunc(BufVar)
   else
      d := MaxInt;
   rsl := '';
   while (src <> '') and (d > 0) do
   begin
      p := AnsiPos(ptn, src);
      if p > 0 then
      begin
         dec(v);
         if v < 1 then
         begin
            dec(d);
            rsl := rsl + copy(src,1,p-1);
            rsl := rsl + rpl;
         end
         else
         begin
            rsl := rsl + copy(src,1,p+Length(ptn)-1);
         end;
         src := copy(src,p+Length(ptn),MaxInt);
      end;
   end;
   rsl := rsl + src;
   BufVar := rsl;
end;

{---------------------------------------------------------------------------
                             StrZero() Function
----------------------------------------------------------------------------}

function TgsUDFStrZero.FunctionName: gsUTFString;
begin
   FunctionName := 'STRZERO';
end;

function TgsUDFStrZero.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   i: integer;
   s: gsUTFString;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := 1;
   s := BufVar;

   while (i <= length(s)) and (s[i] = ' ') do
   begin
      s[i] := '0';
      inc(i);
   end;
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             SubStr() Function
----------------------------------------------------------------------------}

function TgsUDFSubStr.FunctionName: gsUTFString;
begin
   FunctionName := 'SUBSTR';
end;

function TgsUDFSubStr.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   l: integer;
   d: integer;
   v: integer;
   s: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   l := trunc(BufVar);
   v := length(s);
   if (l > v) or (l = 0) then
   begin
      s := '';
   end
   else
   begin
      Caller.FetchArg(2, BufVar, r, rtAny);
      if r = rtFloat then
         d := trunc(BufVar)
      else
         d := v;
      v := (v-l) + 1;
      if d > v then d := v;
      if d = 0 then
         s := ''
      else
         s := copy(s,l,d);
   end;
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Trim() Function
----------------------------------------------------------------------------}

function TgsUDFTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'TRIM';
end;

function TgsUDFTrim.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   s := TrimRight(s);
   BufVar := s;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Upper() Function
----------------------------------------------------------------------------}

function TgsUDFUpper.FunctionName: gsUTFString;
begin
   FunctionName := 'UPPER';
end;

function TgsUDFUpper.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   BufVar := gsStrUpperCase(BufVar);
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                             Val() Function
----------------------------------------------------------------------------}

function TgsUDFVal.FunctionName: gsUTFString;
begin
   FunctionName := 'VAL';
end;

function TgsUDFVal.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType): boolean;
var
   r: TgsExpResultType;
   f: FloatNum;
   s: gsUTFString;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   if length(BufVar) > 0 then
      try
         f := StrToFloat(s);
      except
         f := 0;
      end
   else
      f := 0;
   BufVar := f;
   FunctionResult := true;
end;

{---------------------------------------------------------------------------
                            TgsExpBaseObject
----------------------------------------------------------------------------}

constructor TgsExpBaseObject.Create;
begin
   Inherited Create;
   FResultType := rtUnknown;
   FExpType := etUnknown;
   FExpChg := false;
   FExpLen := 0;
   FExpDec := 0;
   FArgLeft := nil;
   FArgRight := nil;
end;

destructor TgsExpBaseObject.Destroy;
begin
   if FArgLeft <> nil then FArgLeft.Free;
   if FArgRight <> nil then FArgRight.Free;
   inherited Destroy;
end;

function TgsExpBaseObject.ExpObjectContains: gsUTFString;
begin
   ExpObjectContains := '';
end;

function TgsExpBaseObject.ExpObjectType: integer;
begin
   Result := gsSQLTypeNA;
end;

function TgsExpBaseObject.ExpRebuildExpression: gsUTFString;
var
   s: gsUTFString;
begin
   s := '';
   if FArgLeft <> nil then
      s := FArgLeft.ExpRebuildExpression;
   s := s + ExpObjectContains;
   if FArgRight <> nil then
      s := s + FArgRight.ExpRebuildExpression;
   Result := s;
end;

function TgsExpBaseObject.ExpEnumTypes(AType: integer): gsUTFString;
var
   s: gsUTFString;
begin
   s := '';
   if FArgLeft <> nil then
      s := FArgLeft.ExpEnumTypes(AType);
   if ExpObjectType = AType then
      s := s + ExpObjectContains+';';
   if FArgRight <> nil then
      s := s + FArgRight.ExpEnumTypes(AType);
   Result := s;
end;


procedure TgsExpBaseObject.ExpParse(var BufVar: variant;
                                  var ExpResult: TgsExpResultType);
begin
   ExpResult := rtUnknown;
end;

{---------------------------------------------------------------------------
                            TgsExpContainer
----------------------------------------------------------------------------}

constructor TgsExpContainer.Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
var
   ResultStr: gsUTFString;
begin
   Inherited Create;
   ResultStr := AOwner.CompressExpression(AValue);
   FArgRight := AOwner.GenerateObjects(ResultStr);
end;

function TgsExpContainer.ExpRebuildExpression: gsUTFString;
var
   s: gsUTFString;
begin
   s := '(';
   if FArgRight <> nil then
      s := s + FArgRight.ExpRebuildExpression;
   s := s + ')';
   Result := s;
end;

function TgsExpContainer.ExpEnumTypes(AType: integer): gsUTFString;
var
   s: gsUTFString;
begin
   s := '';
   if FArgRight <> nil then
      s := s + FArgRight.ExpEnumTypes(AType);
   Result := s;
end;

procedure TgsExpContainer.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   if FArgRight <> nil then
      FArgRight.ExpParse(BufVar, ExpResult)
   else
      ExpResult := rtEmpty;
end;

{---------------------------------------------------------------------------
                            TgsExpFunction
----------------------------------------------------------------------------}

constructor TgsExpFunction.Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
var
   ExpStr: gsUTFString;
   ElemStr: gsUTFString;
   ResultStr: gsUTFString;
   ixLength: integer;
   ixPosGroup: integer;
   ixPosElemStart: integer;
   ixPosElemEnd: integer;
   i: integer;
begin
   Inherited Create;
   FOwner := AOwner;
   FExpType := etFunction;
   FArgList := TList.Create;
   FUDF := nil;
   ixLength := Length(AValue);
   if ixLength = 0 then exit;
   ixPosGroup := Pos('(',AValue);
   if ixPosGroup = 0 then exit;
   ExpStr := AnsiUpperCase(copy(AValue,1,ixPosGroup-1));
   i := 0;
   while (i < GSFunctionRegistry.Count) and
         (GSFunctionRegistry.FunctionName(i) <> ExpStr) do
      inc(i);
   if i < GSFunctionRegistry.Count then
      FUDF := GSFunctionRegistry.FunctionLink(i);
   if FUDF = nil then
   begin
      if FOwner.UserLink <> nil then
      begin
         FUDF := FOwner.UserLink.FindFunction(ExpStr);
      end;
   end;
   if FUDF = nil then
   begin
      if FOwner.UserLink <> nil then
         FUDF := FOwner.UserLink.OnNoFunction(ExpStr)
      else
         raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[ExpStr]);
   end;
   ixPosElemStart := ixPosGroup;
   ixPosElemEnd := ixPosElemStart+1;
   while ixPosElemEnd < ixLength do
   begin
      ixPosElemEnd := AOwner.ScanFunctionGroup(AValue,ixPosElemStart,true);
      ElemStr := Copy(AValue,ixPosElemStart+1,ixPosElemEnd-ixPosElemStart-1);
      if Length(ElemStr) <> 0 then
      begin
         ResultStr := AOwner.CompressExpression(ElemStr);
         FArgList.Add(AOwner.GenerateObjects(ResultStr));
      end;
      ixPosElemStart := ixPosElemEnd;
      ixPosElemEnd := ixPosElemStart+1;
   end;
end;

destructor TgsExpFunction.Destroy;
var
   i: integer;
begin
   for i := 0 to FArgList.Count-1 do
   begin
     TgsExpBaseObject(FArgList.Items[i]).Free;
   end;
   FArgList.Free;
   inherited Destroy;
end;

function TgsExpFunction.ExpObjectContains: gsUTFString;
begin
   ExpObjectContains := FUDF.FunctionName;
end;

function TgsExpFunction.ExpRebuildExpression: gsUTFString;
var
   s: gsUTFString;
   i: integer;
begin
   s := ExpObjectContains + '(';
   for i := 0 to FArgList.Count-1 do
   begin
      s := s + TgsExpBaseObject(FArgList.Items[i]).ExpRebuildExpression;
      if i < FArgList.Count - 1 then
         s := s + ',';
   end;
   s := s + ')';
   Result := s;
end;

function TgsExpFunction.ExpEnumTypes(AType: integer): gsUTFString;
var
   s: gsUTFString;
   i: integer;
begin
   s := '';
   for i := 0 to FArgList.Count-1 do
   begin
      s := s + TgsExpBaseObject(FArgList.Items[i]).ExpENumTypes(AType);
   end;
   Result := s;
end;

procedure TgsExpFunction.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
var
   b: boolean;
begin
   b := FUDF.FunctionResult(Self,BufVar,ExpResult);
   if not b then
   begin
      ExpResult := rtEmpty;
   end;
end;

procedure TgsExpFunction.FetchArg(Index: integer; var BufVar: variant;
                       var ExpResult: TgsExpResultType;
                       ExpResultNeeded: TgsExpResultType);
var
   s: gsUTFString;
begin
   if Index < FArgList.Count then
   begin
      TgsExpBaseObject(FArgList.Items[Index]).ExpParse(BufVar, ExpResult);
   end
   else
   begin
      ExpResult := rtEmpty;
   end;
   if ((ExpResultNeeded <> rtAny) and (ExpResult <> ExpResultNeeded)) then
   begin
      if (not (ExpResultNeeded in [rtFloat..rtDateTime]) and
              (ExpResult in [rtFloat..rtDateTime])) then
      begin
         case ExpResultNeeded of
            rtDate    : s := 'Date';
            rtFloat   : s := 'Number';
            rtText    : s := 'Text';
            rtBoolean : s := 'Boolean';
            else        s := 'Unknown Value';
         end;
         raise EHalcyonExpression.CreateFmt
                 (gsErrArgValueNeeded,[s,Index+1,FUDF.FunctionName]);
      end;
   end;
end;

function TgsExpFunction.FetchUser: TgsExpUserLink;
begin
   Result := FOwner.UserLink;
end;

{---------------------------------------------------------------------------
                            TgsExpFieldVar
----------------------------------------------------------------------------}

constructor TgsExpFieldVar.Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
begin
   Inherited Create;
   FOwner := AOwner;
   FExpType := etFieldVar;
   FUDF := nil;
   if Length(AValue) <> 0 then
   begin
      if FOwner.UserLink <> nil then
         FUDF := FOwner.UserLink.FindFieldVar(AValue);
   end;
   if FUDF = nil then
   begin
      raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[AValue]);
   end;
   FExpLen := FUDF.FVarLen;
end;

function TgsExpFieldVar.ExpObjectContains: gsUTFString;
begin
   ExpObjectContains := FUDF.FieldVarName;
end;

function TgsExpFieldVar.ExpObjectType: integer;
begin
   Result := FUDF.FieldVarType;
end;

procedure TgsExpFieldVar.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
var
   b: boolean;
begin
   b := FUDF.FieldVarResult(BufVar,ExpResult);
   if not b then
   begin
      ExpResult := rtEmpty;
   end;
end;

function TgsExpFieldVar.FetchUser: TgsExpUserLink;
begin
   Result := FOwner.UserLink;
end;


{---------------------------------------------------------------------------
                            TgsExpOperator
----------------------------------------------------------------------------}

constructor TgsExpOperator.Create(AOperator, APrecedence: char);
begin
   Inherited Create;
   FExpType := etOperator;
   FOperator := AOperator;
   FPrecedence := APrecedence;
   FInsensitive := false;
   FWildCards := true;
   FWildCharAll := WildCardChar1;
   FWildCharOne := WildCardChar3;
end;

function TgsExpOperator.StrWCComp(vStr1, vStr2 : variant): Integer;
var
   Wrk1: PChar;
   Wrk2: PChar;
   WrkKeep: PChar;
   WrkComp: PChar;
   astrbegin: boolean;
   astrend: boolean;
   v: integer;
begin
   v := 0;
   if (vStr1 = null) or (vStr1 = '') then v := 1;
   if (vStr2 = null) or (vStr2 = '') then v := v+2;
   if v > 0 then
   begin
      case v of
         1: Result := -1;
         2: Result := 1;
         else Result := 0;
      end;
      exit;
   end;
   Wrk1 := StrAlloc(length(vStr1)+1);
   WrkKeep := StrAlloc(length(vStr2)+1);
   Wrk2 := WrkKeep;
   StrPCopy(Wrk1, vStr1);
   StrPCopy(Wrk2, vStr2);
   StrTrimR(Wrk1);
   StrTrimR(Wrk2);
   if FWildCards and (StrLen(Wrk2) > 0) and
      ((Wrk2[0] = FWildCharAll) or (Wrk2[pred(StrLen(Wrk2))] = FWildCharAll)) then
   begin
      if StrLen(Wrk2) = 1 then    {string is '*'}
      begin
         Result := 0;
         StrDispose(WrkKeep);
         StrDispose(Wrk1);
         exit;
      end;
      if FInsensitive then
      begin
         gsBufUpperCase(Wrk1,StrLen(Wrk1));
         gsBufUpperCase(Wrk2,StrLen(Wrk2));
      end;
      astrbegin := Wrk2[0] = FWildCharAll;
      if astrbegin then inc(Wrk2);
      astrend := Wrk2[pred(StrLen(Wrk2))] = FWildCharAll;
      if astrend then Wrk2[pred(StrLen(Wrk2))] := #0;
      Result := ComparePChar(Wrk1,Wrk2);
      if (Result <> 0) then
      begin
         WrkComp := StrPos(Wrk1, Wrk2);
         if (not astrbegin) and (WrkComp <> Wrk1) then
            WrkComp := nil;
         if WrkComp <> nil then
         begin
            if not astrend then
               if StrLen(WrkComp) > StrLen(Wrk2) then
                  WrkComp := nil;
         end;
         if WrkComp <> nil then
            Result := 0;
      end;
   end
   else
      if FInsensitive then
         Result := CompareIPChar(Wrk1,Wrk2)
      else
         Result := ComparePChar(Wrk1,Wrk2);
   StrDispose(WrkKeep);
   StrDispose(Wrk1);
end;

function TgsExpOperator.ExpObjectContains: gsUTFString;
begin
   case FOperator of
      opElemEQ        :  ExpObjectContains := '=';
      opElemNE        :  ExpObjectContains := '#';
      opElemGT        :  ExpObjectContains := '>';
      opElemLT        :  ExpObjectContains := '<';
      opElemGE        :  ExpObjectContains := '>=';
      opElemLE        :  ExpObjectContains := '<=';
      opElemPOS       :  ExpObjectContains := 'in string';
      opElemExactEQ   :  ExpObjectContains := 'exactly equal';
      opElemPlus      :  ExpObjectContains := '+';
      opElemMinus     :  ExpObjectContains := '-';
      opElemMultiply  :  ExpObjectContains := '*';
      opElemDivide    :  ExpObjectContains := '/';
      opElemExponent  :  ExpObjectContains := '^';
      opElemAND       :  ExpObjectContains := '.AND.';
      opElemOR        :  ExpObjectContains := '.OR.';
      opElemNOT       :  ExpObjectContains := '.NOT.';
   end;
end;

procedure TgsExpOperator.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
var
   Buf1: variant;
   Buf2: variant;
   ResultTypeLeft: TgsExpResultType;
   ResultTypeRight: TgsExpResultType;
   ExpCnt: longint;
   FloatWork: FloatNum;
   FloatAlso: FloatNum;
   bc: integer;
   s: gsUTFString;
begin
   if ((FArgLeft = nil) and (FOperator <> opElemNOT)) or (FArgRight = nil) then
      raise EHalcyonExpression.CreateFmt(gsErrMissingSide,[ExpObjectContains]);
   try
      ResultTypeLeft := rtEmpty;
      ResultTypeRight := rtEmpty;
      if FArgRight <> nil then
         FArgRight.ExpParse(Buf2, ResultTypeRight);
      ResultTypeLeft := ResultTypeRight;
      if FArgLeft <> nil then
         FArgLeft.ExpParse(Buf1, ResultTypeLeft);

      FResultType := ResultTypeRight;
      if (ResultTypeLeft <> ResultTypeRight) then
      begin
         if not ((ResultTypeLeft in [rtFloat..rtDateTime]) and
                 (ResultTypeRight in [rtFloat..rtDateTime])) then
         begin
            if FOperator <> opElemNOT then
              raise EHalcyonExpression.Create(gsErrOpConflict);
            if ResultTypeRight <> rtBoolean then
               raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['boolean']);
         end;
      end;
      if FResultType = rtBoolean  then
      begin
         case FOperator of
            opElemEQ  :  BufVar := Buf1 = Buf2;
            opElemNE  :  BufVar := Buf1 <> Buf2;
            opElemAND :  BufVar := Buf1 and Buf2;
            opElemOR  :  BufVar := Buf1 or Buf2;
            opElemNOT :  BufVar := not Buf2;
            opElemPlus,
            opElemMinus,
            opElemMultiply,
            opElemDivide,
            opElemExponent : raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['number']);
            else
                raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['assigned']);
         end;
      end
      else
      if FResultType in [rtFloat..rtDateTime] then
      begin
         FloatWork := Buf1 - Buf2;
         case FOperator of
            opElemEQ  :  BufVar := FloatWork = 0.0;
            opElemNE  :  BufVar := FloatWork <> 0.0;
            opElemLE  :  BufVar := FloatWork <= 0.0;
            opElemGT  :  BufVar := FloatWork > 0.0;
            opElemLT  :  BufVar := FloatWork < 0.0;
            opElemGE  :  BufVar := FloatWork >= 0.0;
            opElemPlus : BufVar := Buf1 + Buf2;
            opElemMinus: BufVar := Buf1 - Buf2;
            opElemMultiply  :  BufVar := Buf1 * Buf2;
            opElemDivide    :  BufVar := Buf1 / Buf2;
            opElemExponent  :  begin
                              FloatAlso := Buf1;
                              FloatWork := Buf1;
                              ExpCnt := trunc(Buf2);
                              while ExpCnt > 1 do
                              begin
                                 dec(ExpCnt);
                                 FloatAlso := FloatAlso * FloatWork;
                              end;
                              BufVar := FloatAlso;
                           end;
            else
                raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['assigned']);
         end;
      end
      else
      if FResultType = rtText  then
      begin
         case FOperator of
            opElemEQ,
            opElemNE,
            opElemLE,
            opElemGT,
            opElemLT,
            opElemGE    :  begin
                              bc := StrWCComp(Buf1,Buf2);
                              case FOperator of
                                 opElemEQ  :  BufVar := bc = 0;
                                 opElemNE  :  BufVar := bc <> 0;
                                 opElemLE  :  BufVar := bc <= 0;
                                 opElemGT  :  BufVar := bc > 0;
                                 opElemLT  :  BufVar := bc < 0;
                                 opElemGE  :  BufVar := bc >= 0;
                              end;
                           end;
            opElemPos:     begin
                              BufVar := pos(Buf1,Buf2) > 0;
                           end;
            opElemPlus:    begin
                              s := '';
                              if (Buf1 <> null) and (Buf1 <> '') then
                              begin
                                 s := Buf1;
                              end;
                              if (Buf2 <> null) and (Buf2 <> '') then
                              begin
                                 s := s + Buf2;
                              end;
                              BufVar := s;
                           end;
            opElemMinus:   begin
                              bc := 0;
                              s := '';
                              if (Buf1 <> null) and (Buf1 <> '') then
                              begin
                                 bc := length(Buf1);
                                 s := TrimRight(Buf1);
                              end;
                              if (Buf2 <> null) and (Buf2 <> '') then
                              begin
                                 bc := bc + length(Buf2);
                                 s := s + Buf2;
                              end;
                              while length(s) < bc do s := s + ' ';
                              BufVar := s;
                           end;

            else raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['assigned']);
         end;
      end;
   finally
      case FOperator of
         opElemEQ,
         opElemNE,
         opElemGT,
         opElemLT,
         opElemGE,
         opElemLE,
         opElemPOS,
         opElemExactEQ,
         opElemAND ,
         opElemOR,
         opElemNOT      : FResultType := rtBoolean;
      end;
      ExpResult := FResultType;
   end;
end;


{---------------------------------------------------------------------------
                            TgsExpTextLit
----------------------------------------------------------------------------}

constructor TgsExpTextLit.Create(const AValue: gsUTFString);
begin
   Inherited Create;
   FResultType := rtText;
   FExpType := etTextLit;
   FExpValue := AValue;
   FExpLen := Length(AValue);
end;

destructor TgsExpTextLit.Destroy;
begin
   inherited Destroy;
end;

function TgsExpTextLit.ExpObjectContains: gsUTFString;
begin
      ExpObjectContains := '"'+FExpValue+'"';
end;

Procedure TgsExpTextLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpValue;
end;


{---------------------------------------------------------------------------
                            TgsExpNumLit
----------------------------------------------------------------------------}

constructor TgsExpNumLit.Create(const AValue: gsUTFString);
var
   r: integer;
begin
   Inherited Create;
   FResultType := rtFloat;
   FExpType := etNumLit;
   FExpFloat := 0.0;
   FExpLen := Length(AValue);
   if FExpLen <> 0 then
   begin
      val(AValue, FExpFloat, r);
      if r <> 0 then
         FExpFloat := 0.0;
      FExpDec := StrNumDec(AValue);
   end;
end;

function TgsExpNumLit.ExpObjectContains: gsUTFString;
var
   s: gsUTFString;
begin
   str(FExpFloat:20:FExpDec,s);
   while s[1] = ' ' do delete(s,1,1);
   ExpObjectContains := s;
end;

procedure TgsExpNumLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpFloat;
end;

{---------------------------------------------------------------------------
                            TgsExpDateLit
----------------------------------------------------------------------------}

constructor TgsExpDateLit.Create(const AValue: gsUTFString);
begin
   Inherited Create;
   FResultType := rtDate;
   FExpType := etDateLit;
   FExpDate := DBFDate.CTOD(AValue);
end;

function TgsExpDateLit.ExpObjectContains: gsUTFString;
var
   l: longint;
begin
   l := trunc(FExpDate);
   ExpObjectContains := '{'+DBFDate.DTOC(l)+'}';
end;

procedure TgsExpDateLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpDate;
end;

{---------------------------------------------------------------------------
                            TgsExpBlnLit
----------------------------------------------------------------------------}

constructor TgsExpBlnLit.Create(const AValue: gsUTFString);
begin
   Inherited Create;
   FResultType := rtBoolean;
   FExpType := etBlnLit;
   if AValue = '.T.' then
      FExpLogic := true
   else
      FExpLogic := false;
end;

function TgsExpBlnLit.ExpObjectContains: gsUTFString;
begin
   if FExpLogic then
      ExpObjectContains := '.T.'
   else
      ExpObjectContains := '.F.';
end;

procedure TgsExpBlnLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpLogic;
end;

{---------------------------------------------------------------------------
                            TgsExpHandler
----------------------------------------------------------------------------}

constructor TgsExpHandler.Create(AUser: TgsExpUserLink; const AExpression: gsUTFString; IsSQL: boolean);
var
   ExpString: gsUTFString;
begin
   Inherited Create;
   FExpLen := 0;
   FExpDec := 0;
   FArgCount := 0;
   FInsensitive := false;
   FWildCards := true;
   if IsSQL then
   begin
      FWildCharAll := WildCardChar2;
      FWildCharOne := WildCardChar4;
   end
   else
   begin
      FWildCharAll := WildCardChar1;
      FWildCharOne := WildCardChar3;
   end;
   FUserLink := AUser;
   FExpChg := false;
   if Length(AExpression) = 0 then
   begin
      FParseObj := nil;
      FResultType := rtUnknown;
   end
   else
   begin
      ExpString := CompressExpression(AExpression);
      FParseObj := GenerateObjects(ExpString);
   end;
end;

destructor TgsExpHandler.Destroy;
begin
   if FParseObj <> nil then
      FParseObj.Free;
   inherited Destroy;
end;

function TgsExpHandler.EnumerateType(AType: integer): gsUTFString;
begin
   if FParseObj <> nil then
      Result := FParseObj.ExpEnumTypes(AType)
   else
      Result := '';
end;

function TgsExpHandler.GetExpression: gsUTFString;
begin
   if FParseObj <> nil then
      Result := FParseObj.ExpRebuildExpression
   else
      Result := '';
end;

procedure TgsExpHandler.SetExpression(const AExpression: gsUTFString);
var
   ExpString: gsUTFString;
begin
   if FParseObj <> nil then
      FParseObj.Free;
   FParseObj := nil;
   FExpLen := 0;
   FExpDec := 0;
   FArgCount := 0;
   FResultType := rtUnknown;
   if Length(AExpression) <> 0 then
   begin
      ExpString := CompressExpression(AExpression);
      FParseObj := GenerateObjects(ExpString);
   end;
end;

procedure TgsExpHandler.ExpressionResult(var BufVar: variant);
begin
   FExpChg := false;
   if FParseObj <> nil then
   begin
      FParseObj.ExpParse(BufVar, FResultType);
   end
   else
      FResultType := rtUnknown;
end;

procedure TgsExpHandler.ExpressionAsVariant(var AVar: TgsVariant);
var
   BufVar: variant;
   j: longint;
begin
   FExpChg := false;
   if FParseObj <> nil then
   begin
      FParseObj.ExpParse(BufVar, FResultType);
      if BufVar <> null then
      begin
         case FResultType of
            rtText    : begin
                           AVar.PutString(BufVar);
                         end;
            rtDate    :  begin
                            j := trunc(BufVar);
                            AVar.PutDate(j);
                         end;
            rtFloat,
            rtDateTime:  begin
                            AVar.PutFloat(BufVar);
                         end;
            rtBoolean :  begin
                            AVar.PutBoolean(BufVar);
                         end;
            else         begin
                            FResultType := rtUnknown;
                         end;
         end;
      end;
   end
   else
   begin
      AVar.PutString('');
      FResultType := rtUnknown;
   end;
end;


function TgsExpHandler.ResultType: TgsExpResultType;
begin
   Result := FResultType;
end;













function TgsExpHandler.ScanFunctionGroup(const workStr: gsUTFString; ElemStart: integer;
                                         UseComma: boolean): integer;
var
   ixPosElemEnd: integer;
   ctGroup: integer;
   atEnd: boolean;
   cQuote: gsUTFChar;
begin
   ixPosElemEnd := ElemStart+1;
   ctGroup := 0;
   cQuote := #0;
   atEnd := false;
   repeat
      case workStr[ixPosElemEnd] of
         ',' : if UseComma and (cQuote = #0) then
                  AtEnd := ctGroup = 0;
          '(' : begin
                  if cQuote = #0 then
                      inc(ctGroup);
                end;
         ')' : begin
                  if cQuote = #0 then
                  begin
                     AtEnd := ctGroup = 0;
                     if not AtEnd then dec(ctGroup);
                  end;
               end;
         '''',
         '"' : begin
                  if cQuote = #0 then
                  begin
                     cQuote := workStr[ixPosElemEnd];
                     inc(ctGroup);
                  end
                  else
                  begin
                     if cQuote = workStr[ixPosElemEnd] then
                     begin
                        dec(ctGroup);
                        cQuote := #0;
                     end;
                  end;
               end;
         '[' : begin
                  if cQuote = #0 then
                  begin
                     cQuote := ']';
                     inc(ctGroup);
                  end;
               end;
         ']' : begin
                  if cQuote = ']' then
                  begin
                     dec(ctGroup);
                     cQuote := #0;
                  end;
               end;
         '{' : begin
                  if cQuote = #0 then
                  begin
                     cQuote := '}';
                     inc(ctGroup);
                  end;
               end;
         '}' : begin
                  if cQuote = '}' then
                  begin
                     dec(ctGroup);
                     cQuote := #0;
                  end;
               end;
      end;
      if not AtEnd then
         inc(ixPosElemEnd);
   until AtEnd;
   Result := ixPosElemEnd;
end;


      {Check for operator}
function TgsExpHandler.CheckForOperator(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
   cAction: gsUTFChar;
   ixFind: integer;
   bAction: boolean;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['*','/','=','+','-','<','>','!','#','^'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and (workStr[ixOut] in ['*','=','<','>']) do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := copy(workStr,1,ixOut-1);
         ixFind := LogicValueCount;
         repeat
            bAction :=  ParserValueArray[ixFind] = elemStr;
            if bAction then
            begin
               cAction := ParserActionArray[ixFind];
               case cAction of
                  opElemEQ,
                  opElemNE,
                  opElemGT,
                  opElemLT,
                  opElemGE,
                  opElemLE,
                  opElemPOS,
                  opElemExactEQ     : begin
                                         cWork := opTypeRelat;
                                      end;
                  opElemOR,
                  opElemPlus,
                  opElemMinus       : begin
                                         cWork := opTypeAdd;
                                      end;
                  opElemAND,
                  opElemMultiply,
                  opElemDivide      : begin
                                         cWork := opTypeMult;
                                      end;
                  opElemNOT         : begin
                                         cWork := opTypeRelNot;
                                      end;
                  opElemExponent    : begin
                                         cWork := opTypeUnary;
                                      end;
                  else                cWork := opTypeAdd;
               end;
               Delete(workStr,1,ixOut-1);
               resultStr := resultStr + cAction + cWork + ExpElementEnd;
               Result := true;
            end
            else
               inc(ixFind);
         until (bAction) or (ixFind=ParserValueCount);
      end;
   end;
end;


      {Check for group}
function TgsExpHandler.CheckForGroup(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   ixParend: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;

begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork = '(' then
   begin
      ixOut := 2;
      ixParend := 1;
      while (ixOut <= Length(workStr)) and (ixParend > 0) do
      begin
         if (workStr[ixOut] = '(') then inc(ixParend)
         else
            if (workStr[ixOut] = ')') then dec(ixParend);
         if ixParend > 0 then inc(ixOut);
      end;
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := copy(workStr,2,ixOut-2);
         resultStr := resultStr + opElemGroup + elemStr + ExpElementEnd;
         Delete(workStr,1,ixOut);
         Result := true;
      end
      else
      begin
         raise EHalcyonExpression.Create(gsErrNoEndParend);
      end;
   end;
end;

      {Check for entity}
function TgsExpHandler.CheckForEntity(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   initialStr: gsUTFString;
   pUDF: TgsUserDefFieldVar;
   cWork: gsUTFChar;
   bComplete: boolean;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['A'..'Z','a'..'z','_'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and
            (workStr[ixOut] in ['A'..'Z','a'..'z','0'..'9','_']) do inc(ixOut);
      elemStr := copy(workStr,1,ixOut-1);
      Delete(workStr,1,ixOut-1);
      initialStr := elemStr;
      repeat
         bComplete := true;
         if (Length(workStr) > 0) and (workStr[1] = '(') then
         begin
            ixOut := ScanFunctionGroup(workStr,1,false);
            if (ixOut <= Length(workStr)) then
            begin
               elemStr := elemstr+copy(workStr,1,ixOut);
               resultStr := resultStr + opElemFunction + elemStr + ExpElementEnd;
               Delete(workStr,1,ixOut);
               Result := true;
            end
            else
            begin
               raise EHalcyonExpression.Create(gsErrNoEndParend);
            end;
         end
         else
         begin
            if UserLink <> nil then
               pUDF := UserLink.FindFieldVar(AnsiUpperCase(elemStr))
            else
               pUDF := nil;
            if (pUDF = nil) or (pUDF.Descendents and ((Length(workStr) > 0) and (workStr[1]='.'))) then
            begin
               bComplete := (Length(workStr) = 0) or (workStr[1] <> '.');
               if not bComplete then
               begin
                  ixOut := 2;
                  while (ixOut <= Length(workStr)) and
                        (workStr[ixOut] in ['A'..'Z','a'..'z','0'..'9','_']) do inc(ixOut);
                  elemStr := elemStr+Copy(workStr,1,ixOut-1);
                  Delete(workStr,1,ixOut-1);
               end
               else
                  raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[initialStr]);
            end
            else
            begin
               resultStr := resultStr + opElemVariable + elemStr + ExpElementEnd;
               Result := true;
            end;
         end;
      until bComplete;
   end;
end;

      {Check for text or date literal}
function TgsExpHandler.CheckForLiteral(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   operChar: gsUTFChar;
   cFind   : gsUTFChar;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in [SingleQuote,DoubleQuote,'[','{'] then
   begin
      operChar := opElemText;
      case cWork of
         '{' : begin
                  cFind := '}';
                  operChar := opElemDate;
               end;
         '[' : begin
                  cFind := ']';
               end;
         else  cFind := cWork;
      end;
      ixOut := 2;
      while (ixOut <= Length(workStr)) and (workStr[ixOut] <> cFind) do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := copy(workStr,2,ixOut-2);
         resultStr := resultStr + operChar + elemStr + ExpElementEnd;
         Delete(workStr,1,ixOut);
         Result := true;
      end
      else
      begin
         raise EHalcyonExpression.CreateFmt(gsErrNoEndQuote,[cWork]);
      end;
   end;
end;

      {Check for numeric literal}
function TgsExpHandler.CheckForNumber(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['0'..'9','+','-'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and
            (workStr[ixOut] in ['0'..'9','.']) do inc(ixOut);
      elemStr := copy(workStr,1,ixOut-1);
      resultStr := resultStr + opElemNumber + elemStr + ExpElementEnd;
      Delete(workStr,1,ixOut-1);
      Result := true;
   end;
end;

      {Check for logical literals .T. and .F.}
function TgsExpHandler.CheckForTrueFalse(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork = '.' then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and (workStr[ixOut] <> '.') do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := AnsiUpperCase(copy(workStr,1,ixOut));
         if (elemStr = '.T.') or (elemStr = '.F.') then
         begin
            resultStr := resultStr + opElemBoolean + elemStr + ExpElementEnd;
            Delete(workStr,1,ixOut);
            Result := true;
         end
         else
         begin
            raise EHalcyonExpression.Create(gsErrNoTrueFalse);
         end;
      end
      else
      begin
         raise EHalcyonExpression.Create(gsErrNoEndPeriod);
      end;
   end;
end;

      {Check for logical operators}
function TgsExpHandler.CheckForLogical(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   ixFind: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
   cAction: gsUTFChar;
   bAction: boolean;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['A'..'Z','a'..'z','.'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and
            (workStr[ixOut] in ['A'..'Z','a'..'z']) do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         if workStr[ixOut] = '.' then inc(ixOut);
         elemStr := AnsiUpperCase(copy(workStr,1,ixOut-1));
         if cWork = '.' then elemStr := copy(elemStr,2,ixOut-3);
         ixFind := 0;
         repeat
            bAction :=  ParserValueArray[ixFind] = elemStr;
            if bAction then
            begin
               cAction := ParserActionArray[ixFind];
               case cAction of
                  opElemEQ,
                  opElemNE,
                  opElemGT,
                  opElemLT,
                  opElemGE,
                  opElemLE,
                  opElemPOS,
                  opElemExactEQ     : begin
                                         cWork := opTypeRelat;
                                      end;
                  opElemOR,
                  opElemPlus,
                  opElemMinus       : begin
                                         cWork := opTypeAdd;
                                      end;
                  opElemAND,
                  opElemMultiply,
                  opElemDivide      : begin
                                         cWork := opTypeMult;
                                      end;
                  opElemNOT         : begin
                                         cWork := opTypeRelNot;
                                      end;
                  opElemExponent    : begin
                                         cWork := opTypeUnary;
                                      end;
                  else                cWork := opTypeAdd;
               end;
               Delete(workStr,1,ixOut-1);
               resultStr := resultStr + cAction + cWork + ExpElementEnd;
               Result := true;
            end
            else
               inc(ixFind);
         until (bAction) or (ixFind=LogicValueCount);
      end;
   end;
end;

function TgsExpHandler.CheckForNegation(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['A'..'Z','a'..'z','.','!'] then
   begin
      if cWork <> '!' then
      begin
         ixOut := 2;
         while (ixOut <= Length(workStr)) and
               (workStr[ixOut] in ['A'..'Z','a'..'z']) do inc(ixOut);
      end
      else
         ixOut := 1;
      if (ixOut <= Length(workStr)) then
      begin
         if (workStr[ixOut] = '.') or (cWork = '!') then inc(ixOut);
         elemStr := AnsiUpperCase(copy(workStr,1,ixOut-1));
         if cWork = '.' then elemStr := copy(elemStr,2,ixOut-3);
         if (elemStr = 'NOT') or (elemStr = '!') then
         begin
            Delete(workStr,1,ixOut-1);
            resultStr := resultStr + opElemNot + opTypeRelNot + ExpElementEnd;
            Result := true;
         end;
      end;
   end;
end;

function TgsExpHandler.CompressExpression(const Value: gsUTFString): gsUTFString;
var
   workStr: gsUTFString;
   goodResult: boolean;
   needActor: boolean;
begin
   Result := '';
   workStr := Trim(Value);
   if Length(workStr) = 0 then exit;
   needActor := true;
   while Length(workStr) > 0 do
   begin
      if needActor then
      begin
         if CheckForNegation(workStr, Result) then workStr := TrimLeft(workStr);
         goodResult := (CheckForGroup(workStr,Result) or
                        CheckForTrueFalse(workStr,Result) or
                        CheckForEntity(workStr,Result) or
                        CheckForLiteral(workStr,Result) or
                        CheckForNumber(workStr,Result));
         needActor := not goodResult;
      end
      else
      begin
         goodResult := (CheckForOperator(workStr,Result) or
                        CheckForLogical(workStr,Result));
         needActor := goodResult;
      end;
      if not goodResult then
      begin
         raise EHalcyonExpression.CreateFmt(gsErrSyntax,[Value]);
      end;
      workStr := TrimLeft(workStr);
   end;
end;

function TgsExpHandler.GenerateObjects(const Value: gsUTFString): TgsExpBaseObject;
var
   NuString: gsUTFString;
   WkString: gsUTFString;
   NuType: gsUTFChar;
   NuOperator: gsUTFChar;
   ixPos: integer;
   ExpObject: TgsExpBaseObject;
   ExpResult: TgsExpBaseObject;
   SQLList: TList;
   i: integer;
   j: integer;
   t: gsUTFChar;
begin
   Result := nil;
   if Length(Value) = 0 then exit;
   WkString := Value;
   SQLList := TList.Create;
 try
   while (Length(WkString) > 0) do
   begin
      ixPos := Pos(ExpElementEnd,WkString);
      if ixPos = 0 then ixPos := Length(WkString)+1;
      NuString := copy(WkString,2,ixPos-2);
      NuType := WkString[1];
      Delete(WkString,1,ixPos);
      case NuType of
         opElemGroup          : begin     {grouped characters}
                                   ExpObject := TgsExpContainer.Create(Self,NuString);
                                   SQLList.Add(ExpObject);
                                end;
         opElemUnary,            {unary operators}
         opElemEQ..opElemLike : begin
                                   NuOperator := NuString[1];
                                   ExpObject := TgsExpOperator.Create(NuType,NuOperator);
                                   TgsExpOperator(ExpObject).FInsensitive := FInsensitive;
                                   TgsExpOperator(ExpObject).FWildCards := FWildCards;
                                   TgsExpOperator(ExpObject).FWildCharAll := FWildCharAll;
                                   TgsExpOperator(ExpObject).FWildCharOne := FWildCharOne;
                                   SQLList.Add(ExpObject);
                                end;
         opElemText           : begin     {literal/constant}
                                   ExpObject := TgsExpTextLit.Create(NuString);
                                   SQLList.Add(ExpObject);
                                   inc(FArgCount);
                                 end;
         opElemDate            : begin     {literal/constant}
                                    ExpObject := TgsExpDateLit.Create(NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                 end;
         opElemFunction        : begin     {function}
                                    ExpObject := TgsExpFunction.Create(Self,NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                 end;
         opElemVariable        : begin     {variable/field}
                                    if FUserLink = nil then
                                       ExpObject := nil
                                    else
                                    begin
                                       ExpObject := TgsExpFieldVar.Create(Self,AnsiUpperCase(NuString));
                                    end;
                                    if ExpObject <> nil then
                                       SQLList.Add(ExpObject)
                                    else
                                       raise EHalcyonExpression.CreateFMT
                                                (gsErrFieldInvalid,[NuString]);
                                    inc(FArgCount);
                                    if ExpObject.FExpLen > FExpLen then
                                       FExpLen := ExpObject.FExpLen;
                                    if ExpObject.FExpDec > FExpDec then
                                       FExpDec := ExpObject.FExpDec;
                                 end;
         opElemNumber          : begin     {numeric literal}
                                    ExpObject := TgsExpNumLit.Create(NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                    if ExpObject.FExpLen > FExpLen then
                                       FExpLen := ExpObject.FExpLen;
                                    if ExpObject.FExpDec > FExpDec then
                                       FExpDec := ExpObject.FExpDec;
                                 end;
         opElemBoolean         : begin     {Boolean literal}
                                    ExpObject := TgsExpBlnLit.Create(NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                 end;
      end;
   end;
   t := opTypeUnary;
   while (t <= opTypeRelOr) do
   begin
      ExpResult := nil;
      i := 0;
      while (ExpResult = nil) and (i < SQLList.Count) and
            (SQLList.Count > 1) do
      begin
         ExpObject := SQLList.Items[i];
         if ExpObject <> nil then
         begin
            if ExpObject.FExpType = etOperator then
            begin
               if TgsExpOperator(ExpObject).FPrecedence = t then
               begin
                  ExpResult := ExpObject;
                  j := i+1;
                  if j < SQLList.Count then
                  begin
                     ExpResult.FArgRight := SQLList.Items[j];
                     SQLList.Delete(j);
                  end;
                  if t <> opTypeRelNot then
                  begin
                     j := i-1;
                     if j >= 0 then
                     begin
                        ExpResult.FArgLeft := SQLList.Items[j];
                        SQLList.Delete(j);
                     end;
                  end;
                  ExpResult.FExpType := etContainer;
               end;
            end;
         end;
         inc(i);
      end;
      if ExpResult = nil then inc(t);
   end;
   if SQLList.Count = 1 then
      ExpResult := SQLList.Items[0]
   else
      raise EHalcyonExpression.Create(gsErrConstructBad);
   Result := ExpResult;
 except
   for i := 0 to SQLList.Count-1 do
      TObject(SQLList.Items[i]).Free;
   SQLList.Free;
   raise;
 end;
   SQLList.Free;
end;

{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}
procedure RegisterFunctions;
begin
   GSFunctionRegistry := TgsFunctionReg.Create;
   GSFunctionRegistry.RegisterFunction(TgsUDFAllTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAsc.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAt.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAtC.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFBetween.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFCeiling.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFChr.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFCTOD.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDate.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDescend.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDOW.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDTOC.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDTOS.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFEmpty.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFFloor.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFIIF.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFInt.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLeft.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLen.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLower.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFMod.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPadC.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPadL.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPadR.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFProper.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFRight.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFRTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSoundex.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSpace.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFStr.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFStrTran.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFStrZero.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSubStr.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFUpper.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFVal.Create);
end;


initialization
   RegisterFunctions;

finalization
begin
   GSFunctionRegistry.Free;
end;

end.



