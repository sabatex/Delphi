unit ntics_const;
interface
const
  AnsiHexDigits      = ['0'..'9', 'A'..'F', 'a'..'f'];
  MaxKey=4;
  UserHashLength=3; //1..6
  UserInformationLength = 1; //1..x
  FChar = 'WERTYUPASDFGHJKLZXCVBNM123456789';
  KeyError = 'Ошибочная длина ключа';
  Unregistred = 'Unregistred';
  RegKey='SOFTWARE\NTICS\8DR3.0.0.0';
  DesKeySignature = 'RSA Encripted Metod';
  MaxSizeKey='1024';
  VersionKey='1';
  Copyrigth ='Copyrigth(c) 2002 Serhiy Lakas';
  SectionKey = 'Key';
  AvtorHTML = 'http://www.elikom.com';
  AvtorEMAIL= 'mailto:sabatex@mail.uzhgorod.ua';
  RsFileUtilsLanguageIndex = 'Illegal language index';
  RsFileUtilsNoVersionInfo = 'File contains no version information';


implementation

end.
