set sql dialect 3;

set names win1251;

/* удал€ем базу ...  */
connect to database 'c:\developer\progects\bagel 2.0\data\test.gdb'
                user 'sysdba' password 'masterkey';
drop database;
commit;
/* новый экземпл€р  */
create database 'c:\developer\progects\bagel 2.0\data\test.gdb'
user 'sysdba' password 'masterkey'
page_size 8192
default character set win1251;

/******************************************************************************/
/*                                  udf                                       */
/******************************************************************************/
declare external function bgl_roundfloat
  double precision,
  double precision
  returns
  double precision by value
  entry_point 'roundfloat' module_name 'bgludf.dll';

  declare external function bgl_blobaspchar
  blob
  returns cstring(1024) /* free_it */ /* or 32000 or whatever... */
  entry_point 'blobaspchar' module_name 'bgludf';

declare external function bgl_doubleabs
  double precision
  returns
  double precision by value
  entry_point 'doubleabs' module_name 'bgludf';

declare external function bgl_truncate
  double precision
  returns integer by value
  entry_point 'truncate' module_name 'bgludf';

declare external function bgl_sys_checkp1
integer,double precision,double precision
returns integer by value
entry_point 'checkp1' module_name 'bgludf';

declare external function bgl_sys_checkp2
integer,double precision,double precision
returns integer by value
entry_point 'checkp2' module_name 'bgludf';

declare external function bgl_sys_checkp3
integer,integer,integer
returns integer by value
entry_point 'checkp3' module_name 'bgludf';

declare external function bgl_sys_checkp4
integer,cstring(20),cstring(20)
returns integer by value
entry_point 'checkp4' module_name 'bgludf';

declare external function bgl_sys_checkp5
integer,timestamp,timestamp
returns integer by value
entry_point 'checkp5' module_name 'bgludf';

declare external function bgl_month
        date
        returns integer by value
        entry_point 'month' module_name 'bgludf';

/* returns day from a timestamp */ 
declare external function bgl_day
        date
        returns integer by value
        entry_point 'day' module_name 'bgludf';

/* returns year from a timestamp */ 
declare external function bgl_year
        date
        returns integer by value
        entry_point 'year' module_name 'bgludf';


declare external function bgl_addmonth
  date,
  integer
  returns
  date /* free_it */
  entry_point 'addmonth' module_name 'bgludf';

declare external function bgl_addyear
  date,
  integer
  returns
  date /* free_it */
  entry_point 'addyear' module_name 'bgludf';


declare external function bgl_ageindays
  date, date
  returns
  integer by value
  entry_point 'ageindays' module_name 'bgludf';

declare external function bgl_ageinmonths
  date, date
  returns
  integer by value
  entry_point 'ageinmonths' module_name 'bgludf';

declare external function bgl_ageinweeks
  date, date
  returns
  integer by value
  entry_point 'ageinweeks' module_name 'bgludf';


declare external function bgl_dayofmonth
  date
  returns
  integer by value
  entry_point 'dayofmonth' module_name 'bgludf';

declare external function bgl_dayofweek
  date
  returns
  integer by value
  entry_point 'dayofweek' module_name 'bgludf';

declare external function bgl_dayofyear
  date
  returns
  integer by value
  entry_point 'dayofyear' module_name 'bgludf';


declare external function bgl_quarter
  date
  returns
  integer by value
  entry_point 'quarter' module_name 'bgludf';


declare external function bgl_weekofyear
  date
  returns
  integer by value
  entry_point 'weekofyear' module_name 'bgludf';

declare external function bgl_upper
   cstring(255)
   returns cstring(255)
  entry_point 'rupper'  module_name 'bgludf';

declare external function bgl_lower
   cstring(255)
   returns cstring(255)
  entry_point 'rlower'  module_name 'bgludf';


declare external function bgl_character
  integer
  returns cstring(2) /* free_it */
  entry_point 'character' module_name 'bgludf';

declare external function bgl_crlf
  returns cstring(3) /* free_it */
  entry_point 'crlf' module_name 'bgludf';

declare external function bgl_findnthword
  cstring(8196),
  integer
  returns cstring(254) /* free_it */
  entry_point 'findnthword' module_name 'bgludf';

declare external function bgl_findword
  cstring(8196),
  integer
  returns cstring(254) /* free_it */
  entry_point 'findword' module_name 'bgludf';

declare external function bgl_alltrim
  cstring(254)
  returns
  cstring(254) /* free_it */
  entry_point 'alltrim' module_name 'bgludf';

declare external function bgl_stringlength
  cstring(254)
  returns
  integer by value
  entry_point 'stringlength' module_name 'bgludf';

declare external function bgl_substr
  cstring(254),
  cstring(254)
  returns
  integer by value
  entry_point 'substr' module_name 'bgludf';


commit;


