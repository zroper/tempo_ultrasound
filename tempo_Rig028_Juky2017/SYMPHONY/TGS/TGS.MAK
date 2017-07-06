#----------------------
# TGS.MAK make file
#----------------------
# Reminder: $@      is complete output file name
#           $(@B)   is base name of output file (NMAKE)
#           $*      is base name of output file (MAKE)
#           $**     is complete list of input files
BASENAME=$(@B)

LINTX=d:\lint\lint-nt.exe -b -iD:\LINT -i..\include D:\LINT\STD_NT.LNT -DISTEMPOW $*.c
COMPILEX=$(CC) /I..\include $(CFLAGSMT) 

LIBMS=..\lib\ms
SLIB32=..\slib32
GEN=\lib\gen
TEMPODLL=..\include
TEMPO=..\..

all:    tgS.obj                         \
        $(TEMPO)\tgS.exe

tgS.obj:        $(BASENAME).c                     \
                $(TEMPODLL)\exceptio.h   \
                $(TEMPODLL)\fio.h        \
                $(TEMPODLL)\param.h      \
                $(TEMPODLL)\sstempo.h    \
                $(TEMPODLL)\tg.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

$(TEMPO)\tgS.exe:     $(BASENAME).lnk            \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk    >del.me



