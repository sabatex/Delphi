# ---------------------------------------------------------------------------
!if !$d(BCB)
BCB = $(MAKEDIR)\..
!endif

# ---------------------------------------------------------------------------
# IDE SECTION
# ---------------------------------------------------------------------------
# The following section of the project makefile is managed by the BCB IDE.
# It is recommended to use the IDE to change any of the values in this
# section.
# ---------------------------------------------------------------------------

VERSION = BCB.06.00
# ---------------------------------------------------------------------------
PROJECT = bin\AR1_0.exe
OBJFILES = obj\AR1_0.obj obj\fDM8DR.obj obj\FirmsOptions.obj obj\frameCustomGrid.obj \
    obj\fWokersParams.obj obj\f8DRConst.obj obj\f8DREdit.obj \
    obj\fConfig1c60.obj obj\default_splash.obj obj\FormManager.obj \
    obj\crypto_keys.obj obj\fConfigStorage.obj obj\mainc.obj
RESFILES = AR1_0.res obj\P8DRMain.res
MAINSOURCE = AR1_0.cpp
RESDEPEN = $(RESFILES) SOURCE\fDM8DR.dfm SOURCE\FirmsOptions.dfm \
    SOURCE\frameCustomGrid.dfm SOURCE\fWokersParams.dfm SOURCE\f8DREdit.dfm \
    SOURCE\fConfig1c60.dfm \
    ..\Repository\NTICS_def_Project\source\default_splash.dfm SOURCE\mainc.dfm
LIBFILES = vcl.lib rtl.lib vclx.lib dbrtl.lib vcldb.lib EhLibB60.lib JvCoreC6R.lib \
           CJcl.lib
IDLFILES =
IDLGENFILES =
LIBRARIES =
PACKAGES =
SPARELIBS =
DEFFILE =
OTHERFILES =
# ---------------------------------------------------------------------------
DEBUGLIBPATH = $(BCB)\lib\debug
RELEASELIBPATH = $(BCB)\lib\release
USERDEFINES = _DEBUG
SYSDEFINES = NO_STRICT;_RTLDLL
INCLUDEPATH = "C:\Program Files\Borland\CBuilder6\Projects";..\Repository\NTICS_def_Project\source;SOURCE;$(BCB)\include;$(BCB)\include\vcl;D:\MyDoc\Projects\NTICSLib\include;D:\MyDoc\components\jvcl+jcl\Include;D:\MyDoc\Projects\NTICSLib\source_pas;D:\MyDoc\Projects\NTICSLib\source;D:\MyDoc\components\DBFLib\obj;D:\MyDoc\components\FastReport\obj;D:\MyDoc\components\Ehlib\obj
LIBPATH = "C:\Program Files\Borland\CBuilder6\Projects";..\Repository\NTICS_def_Project\source;SOURCE;obj;$(BCB)\Projects\Lib;$(BCB)\lib\obj;$(BCB)\lib;D:\MyDoc\components\DBFLib\obj;D:\MyDoc\Projects\NTICSLib\obj;D:\MyDoc\components\FastReport\obj;D:\MyDoc\components\Ehlib\obj;"D:\MyDoc\components\jvcl+jcl\jvcl\Resources"
WARNINGS= -w-par
PATHCPP = .;..\Repository\NTICS_def_Project\source;SOURCE
PATHASM = .;
PATHPAS = .;SOURCE
PATHRC = .;SOURCE
PATHOBJ = .;$(LIBPATH)
# ---------------------------------------------------------------------------
CFLAG1 = -Od -Vx -Ve -X- -r- -a8 -b- -k -y -v -vi- -c -tW -tWM
IDLCFLAGS = -I"C:\Program Files\Borland\CBuilder6\Projects" \
    -I..\Repository\NTICS_def_Project\source -ISOURCE -I$(BCB)\include \
    -I$(BCB)\include\vcl -ID:\MyDoc\Projects\NTICSLib\include \
    -ID:\MyDoc\components\jvcl+jcl\Include \
    -ID:\MyDoc\Projects\NTICSLib\source_pas \
    -ID:\MyDoc\Projects\NTICSLib\source -src_suffix cpp -D_DEBUG -boa
PFLAGS = -N2obj -N0obj -$Y+ -$W -$O- -$A8 -v -JPHNE -M
RFLAGS =
AFLAGS = /mx /w2 /zi
LFLAGS = -lobj -Iobj -D"" -aa -Tpe -x -Gn -v
# ---------------------------------------------------------------------------
ALLOBJ = c0w32.obj Memmgr.Lib sysinit.obj $(OBJFILES)
ALLRES = $(RESFILES)
ALLLIB = $(LIBFILES) $(LIBRARIES) import32.lib cp32mti.lib
# ---------------------------------------------------------------------------
!ifdef IDEOPTIONS

[Version Info]
IncludeVerInfo=0
AutoIncBuild=0
MajorVer=1
MinorVer=0
Release=0
Build=0
Debug=0
PreRelease=0
Special=0
Private=0
DLL=0

[Version Info Keys]
CompanyName=
FileDescription=
FileVersion=1.0.0.0
InternalName=
LegalCopyright=
LegalTrademarks=
OriginalFilename=
ProductName=
ProductVersion=1.0.0.0
Comments=

[Debugging]
DebugSourceDirs=$(BCB)\source\vcl

!endif





# ---------------------------------------------------------------------------
# MAKE SECTION
# ---------------------------------------------------------------------------
# This section of the project file is not used by the BCB IDE.  It is for
# the benefit of building from the command-line using the MAKE utility.
# ---------------------------------------------------------------------------

.autodepend
# ---------------------------------------------------------------------------
!if "$(USERDEFINES)" != ""
AUSERDEFINES = -d$(USERDEFINES:;= -d)
!else
AUSERDEFINES =
!endif

!if !$d(BCC32)
BCC32 = bcc32
!endif

!if !$d(CPP32)
CPP32 = cpp32
!endif

!if !$d(DCC32)
DCC32 = dcc32
!endif

!if !$d(TASM32)
TASM32 = tasm32
!endif

!if !$d(LINKER)
LINKER = ilink32
!endif

!if !$d(BRCC32)
BRCC32 = brcc32
!endif


# ---------------------------------------------------------------------------
!if $d(PATHCPP)
.PATH.CPP = $(PATHCPP)
.PATH.C   = $(PATHCPP)
!endif

!if $d(PATHPAS)
.PATH.PAS = $(PATHPAS)
!endif

!if $d(PATHASM)
.PATH.ASM = $(PATHASM)
!endif

!if $d(PATHRC)
.PATH.RC  = $(PATHRC)
!endif

!if $d(PATHOBJ)
.PATH.OBJ  = $(PATHOBJ)
!endif
# ---------------------------------------------------------------------------
$(PROJECT): $(OTHERFILES) $(IDLGENFILES) $(OBJFILES) $(RESDEPEN) $(DEFFILE)
    $(BCB)\BIN\$(LINKER) @&&!
    $(LFLAGS) -L$(LIBPATH) +
    $(ALLOBJ), +
    $(PROJECT),, +
    $(ALLLIB), +
    $(DEFFILE), +
    $(ALLRES)
!
# ---------------------------------------------------------------------------
.pas.hpp:
    $(BCB)\BIN\$(DCC32) $(PFLAGS) -U$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -O$(INCLUDEPATH) --BCB {$< }

.pas.obj:
    $(BCB)\BIN\$(DCC32) $(PFLAGS) -U$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -O$(INCLUDEPATH) --BCB {$< }

.cpp.obj:
    $(BCB)\BIN\$(BCC32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n$(@D) {$< }

.c.obj:
    $(BCB)\BIN\$(BCC32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n$(@D) {$< }

.c.i:
    $(BCB)\BIN\$(CPP32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n. {$< }

.cpp.i:
    $(BCB)\BIN\$(CPP32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n. {$< }

.asm.obj:
    $(BCB)\BIN\$(TASM32) $(AFLAGS) -i$(INCLUDEPATH:;= -i) $(AUSERDEFINES) -d$(SYSDEFINES:;= -d) $<, $@

.rc.res:
    $(BCB)\BIN\$(BRCC32) $(RFLAGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -fo$@ $<



# ---------------------------------------------------------------------------


