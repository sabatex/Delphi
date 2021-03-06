unit gs6_cnst;
{-----------------------------------------------------------------------------
                                 Constant Values

       gs6_cnst Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          14 May 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the constant strings that are used for messages.
       They are placed here for easier internationalization.

   Changes:
------------------------------------------------------------------------------}
interface

resourcestring
   gsErrHalcyonError      = 'Halcyon Error';
   gsErrHalcyonSubCode    = 'Subcode';
   { Kirill}
   gsErrTableIsNil        = '������� �� ��������� ������� �������';
   gsErrTableIsActive     = '���������� ��������� ������ �������� � �������� ��������';
   gsErrOverwriteTable    = '������� ����������. ���������� ������?';
   gsErrInvalidFieldList  = '������ ����� �����������';
   gsErrNoTableName       = '�� ������ (������) ��� �������';
   gsErrCannotFindFile    = '���������� ����� ���� %s';
   gsErrErrorGettingFile  = '������ ������ %s';
   gsErrIndexAlreadyOpen  = '��������� ���� %s ��� ������';
   gsErrRecordOutOfRange  = '������������� ������ ��������� ��� ��������� �������';
   gsErrDeleteRecord      = '���������� ������� ������';
   gsErrUnDeleteRecord    = '���������� ������������ ������';
   gsErrInvalidBookmark   = '������������ �������� ��� ������� ';
   gsErrRecordLockAlready = '������ ������������� ������ �������������';
   gsErrBusyIndexing      = '������� ������ ��������� �������';
   gsErrBusyCopying       = '������� ������ ������������';
   gsErrFilterExpression  = '��������� ������� ������ ���������� ���������� ��������';
   gsErrNotBrowsing       = '������� �� ��������� � ������ ���������';
   gsErrNotEditing        = '������� �� ��������� � ������ �������������� ��� �������';
   gsErrDataSetReadOnly   = '���������� �������������� ������� � ��������� ������ ��� ������';
   gsErrRelationIndex     = '����� �������/����������� �����������, ��� �������� �������� ��� %s';
   gsErrRelationFields    = '����� �������/����������� �����������, ���� �� ������ ��� %s';
   gsErrAliasAssigned     = '����� (���������) %s ��� ��������';
   
   {gsd6file}
   gsErrInvalidFileObject = '����� ��������� ������� ����������� ��� �������';
   gsErrPathNotFound      = '������� %s �� ������';
   gsErrAccessDenied      = '������ � ����� %s ��������';
   gsErrLockViolated      = '���������� ����� %s ��������';
   gsErrFileAlreadyOpen   = '���� %s ������ ������ ��������� (�������������)';

   {gsd6sql}
   gsErrNoSuchFunction   = 'There is no function for %s';
   gsErrArgValueNeeded   = '%s needed for Argument %d of %s';
   gsErrMissingSide      = 'Target value missing for %s operation';
   gsErrOpConflict       = 'The two sides of an operation do not match';
   gsErrArgInvalid       = 'A %s value is required but invalid';
   gsErrFieldInvalid     = 'Field/variable %s is unknown';
   gsErrConstructBad     = 'Expression cannot be evaluated';
   gsErrNoEndParend      = 'Missing closing parentheses';
   gsErrNoEndPeriod      = 'Missing closing period';
   gsErrNoEndQuote       = 'Missing closing "%s" on literal';
   gsErrNoTrueFalse      = 'Expecting ".T." or ".F."';
   gsErrSyntax           = 'Syntax Error in expression "%s"';
   gsErrBadEndParend     = 'Unexpected closing parentheses found';

   {Miscellaneous}
   gsErrVariantAppend    = 'Variant type is not valid for append';
   gsErrVariantTypes     = 'Variant types mismatch for compare';
   gsErrVariantSort      = 'Variant type cannot be sorted';
   gsErrSortSize         = 'Sort key length greater than 240 bytes';
   gsErrSortBegun        = 'Cannot add sort keys after beginning retrieval';
   gsErrCollectionIndex  = 'Collection index out of range';
   gsErrFieldData        = 'Field data is incorrect for %s';
   gsErrFieldDate        = 'Invalid date in field %s';
   gsErrFieldName        = 'There is no field %s';
   gsErrFieldNumber      = 'Invalid number in field %s';
   gsErrFieldPosition    = 'Invalid field number %s in %s';
   gsErrFieldType        = 'Field %s is the incorrect type';
   gsErrBadMemoRecord    = 'Memo mecord is bad in %s';
   gsErrDBFHeader        = 'Table Header for %s is invalid';
   gsErrFileSize         = 'Error %s in FileSize of %s';
   gsErrIndexKeySync     = 'Cannot find key in %s to match current record';
   gsErrIndexOpen        = 'Index file %s had errors on open';
   gsErrIndexTagMissing  = 'Cannot find index tag %s';
   gsErrIndexTagEmpty    = 'Tag field is empty';
   gsErrIndexCollate     = 'General collate is invalid';
   gsErrIndexFind        = '�� ��������� ������ ��� ���������� �������� ������';
   gsErrIndexKey         = 'No index key has been created';
   gsErrFlushError       = 'Error %s in Flush of %s';
   gsErrLockError        = 'Error %s in Lock of %s';
   gsErrNoSuchFile       = '������ %s, ���� %s �� ������';
   gsErrReadError        = '������ %s ������ %s';
   gsErrResetError       = 'Error %s in Reset of %s';
   gsErrRewriteError     = '������ %s ���������� %s';
   gsErrTruncateError    = '������ %s �������� %s';
   gsErrUnlockError      = '������ %s ��������������� %s';
   gsErrWriteError       = '������ %s ������ � %s';
   gsErrUnExpectedPassword = 'A Password is included for unencrypted file %s';
   gsErrNoPassword       = 'No Password for encrypted file %s';
   gsErrBadPassword      = 'Invalid Password for encrypted file s%';

implementation

end.
