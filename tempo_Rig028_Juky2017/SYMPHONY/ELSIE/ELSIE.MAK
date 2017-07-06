#----------------------
# ELSIE.MAK make file
#----------------------
# Reminder: $@      is complete output file name
#           $(@B)   is base name of output file (NMAKE)
#           $*      is base name of output file (MAKE)
#           $**     is complete list of input files

LINTX=d:\lint\lint-nt.exe -b -iD:\LINT -i..\include D:\LINT\STD_NT.LNT -DISTEMPOW $*.c
COMPILEX=$(CC) /I..\include $(CFLAGSMT) 

SLIB32=..\slib32
GEN=\lib\gen
TEMPODLL=..\include
TEMPO=..\..
BASENAME=$(@B)
LIBMS=..\lib\ms


all:    $(TEMPO)\elsie.exe

elsie.obj:      $(BASENAME).c            \
                $(TEMPODLL)\fio.h        \
                $(TEMPODLL)\fileext.h    \
                $(TEMPODLL)\param.h      \
                $(TEMPODLL)\exceptio.h   \
                $(TEMPODLL)\syserr.h     \
                $(TEMPODLL)\tg.h         \
                $(TEMPODLL)\lc.h
    $(LINTX) >$(BASENAME).err
    $(COMPILEX) $(BASENAME).c >$(BASENAME).err



$(TEMPO)\elsie.exe:   $(BASENAME).lnk    \
                elsie.obj                \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk    >del.me
    echo $(BASENAME) relinked




