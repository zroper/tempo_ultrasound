#------------------------
# dde.MAK make file
#------------------------

LIB32=..\lib32

ddeerr.obj: $*.c $*.h
    $(CC) $(CFLAGSMT) $*.c

tempodde.obj: $*.h $*.c $(LIB32)\buger.h ddeerr.h
    $(CC) $(CFLAGSMT) $*.c

ddecli.obj : $*.c tempodde.h $(LIB32)\buger.h ddeerr.h
    $(CC) $(CFLAGSMT) $*.c

ddecli.exe : ddecli.obj tempodde.obj $(LIB32)\buger.obj ddeerr.obj
    $(LINKER) $(GUIFLAGS) @ddecli.lnk


getepoch.obj:   $*.c tempodde.h ddeerr.h
    $(CC) $(CFLAGSMT) $*.c

getepoch.exe:   $*.obj $*.lnk tempodde.obj ddeerr.obj
    $(LINKER) @$*.lnk

tempocmd.obj:   $*.c tempodde.h ddeerr.h
    $(CC) $(CFLAGSMT) $*.c

tempocmd.exe:   $*.obj $*.lnk tempodde.obj ddeerr.obj
    $(LINKER) @$*.lnk

tempoexp.obj:   $*.c tempodde.h ddeerr.h
    $(CC) $(CFLAGSMT) $*.c

tempoexp.exe:   $*.obj $*.lnk tempodde.obj ddeerr.obj
    $(LINKER) @$*.lnk
