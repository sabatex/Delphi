#!/bin/sh

#
# shell script to generate installer units from prototypes
#
# Robert Rossmair, 2004-02-16
#
# $Id: jpp.sh,v 1.8 2004/12/03 17:43:23 rrossmair Exp $

JPP=../../devtools/jpp
CLXOPTIONS="-c -dVisualCLX -dHAS_UNIT_TYPES -uDevelop -uVCL -x../Q"
VCLOPTIONS="-c -dVCL -dMSWINDOWS -uDevelop -uVisualCLX -uHAS_UNIT_LIBC -uUnix -uLinux -uKYLIX -x../"
FILES="ProductFrames.pas JediInstallerMain.pas"

chmod a+x $JPP >/dev/null 2>/dev/null
$JPP $CLXOPTIONS $FILES
$JPP $VCLOPTIONS $FILES
