{  Copyright Elikom 2003 }
{  UDF for Firebird 1.5  }


library bglclassicudf;

{$mode objfpc}
{$PACKRECORDS C}

uses bglsys,bglmath,bgldatetime,bglstr,bglblob;


exports
  {System function for Bagel}
  check_numeric   name 'check_numeric',
  check_integer   name 'check_integer',
  check_string    name 'check_string',
  check_date      name 'check_date',
  check_inscheme  name 'check_inscheme',
  {Math function}
  roundfloat name 'roundfloat',
  doubleabs  name 'doubleabs',
  integerabs name 'integerabs',
  truncate   name 'truncate',
  doubleplus name 'doubleplus',
  {Date function}
  day         name 'day',
  month       name 'month',
  year        name 'year',
  isleapyear  name 'isleapyear',
  addmonth    name 'addmonth',
  addyear     name 'addyear',
  ageindays   name 'ageindays',
  ageinmonths name 'ageinmonths',
  ageinweeks  name 'ageinweeks',
  dayofmonth  name 'dayofmonth',
  dayofweek   name 'dayofweek',
  dayofyear   name 'dayofyear',
  quarter     name 'quarter',
  weekofyear  name 'weekofyear',
  {String function}
  rupper       name 'rupper',
  rlower       name 'rlower',
  character    name 'character',
  crlf         name 'crlf',
  findnthword  name 'findnthword',
  findword     name 'findword',
  alltrim      name 'alltrim',
  stringlength name 'stringlength',
  substr       name 'substr',
  copysubstr   name 'copysubstr',
  {blolb function}
  blobaspchar  name 'blobaspchar';

end.
