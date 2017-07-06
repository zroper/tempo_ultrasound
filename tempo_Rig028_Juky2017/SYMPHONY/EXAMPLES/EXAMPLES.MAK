#----------------------
# EXAMPLES.MAK make file
#----------------------
# Reminder: $@      is complete output file name
#           $(@B)   is base name of output file (NMAKE)
#           $*      is base name of output file (MAKE)
#           $**     is complete list of input files

LINTX=d:\lint\lint-nt.exe -b -iD:\LINT -i..\include D:\LINT\STD_NT.LNT $*.c
COMPILEX=$(CC) /I..\include $(CFLAGSMT) 

TEMPODLL=..\include
TEMPO=..\..
LIBMS=..\lib\ms
BASENAME=$(@B)

all:                                \
        example0.obj                \
        example0.exe                \
        $(TEMPO)\example0.exe       \
        example1.obj                \
        example1.exe                \
        $(TEMPO)\example1.exe       \
        example2.obj                \
        example2.exe                \
        $(TEMPO)\example2.exe       \
        example3.obj                \
        example3.exe                \
        $(TEMPO)\example3.exe       \
        example4.obj                \
        example4.exe                \
        $(TEMPO)\example4.exe       \
        exampleT.obj                \
        exampleT.exe                \
        $(TEMPO)\exampleT.exe       \
        ssbridge.obj                \
        ssbridge.exe                \
        $(TEMPO)\ssbridge.exe       \
        rpc.obj                     \
        rpc.exe                     \
        $(TEMPO)\rpc.exe




#-------------------------------------------------
example0.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\tg.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

example0.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk >del.me
    

$(TEMPO)\example0.exe:  example0.exe
    copy $(BASENAME).exe $(TEMPO)

#-------------------------------------------------
example1.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

example1.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk   >del.me             


$(TEMPO)\example1.exe:  example1.exe
    copy $(BASENAME).exe $(TEMPO)

#-------------------------------------------------
# Send a message to ELSIE

example2.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

example2.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk   >del.me             


$(TEMPO)\example2.exe:  example2.exe
    copy $(BASENAME).exe $(TEMPO)


#-------------------------------------------------
example3.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

example3.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk    >del.me


$(TEMPO)\example3.exe:  example3.exe
    copy $(BASENAME).exe $(TEMPO)



#-------------------------------------------------
example4.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

example4.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk   >del.me             


$(TEMPO)\example4.exe:  example4.exe
    copy $(BASENAME).exe $(TEMPO)


#-------------------------------------------------
# Examples of how to communicate with TEMPO

exampleT.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h        \
                $(TEMPODLL)\sstempo.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

exampleT.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk  >del.me              


$(TEMPO)\exampleT.exe:  exampleT.exe
    copy $(BASENAME).exe $(TEMPO)

#-------------------------------------------------
# Examples of how to receive strings from TEMPO protocol

ssbridge.obj:   $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h        \
                $(TEMPODLL)\sstempo.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

ssbridge.exe:   $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk  >del.me              


$(TEMPO)\ssbridge.exe:  ssbridge.exe
    copy $(BASENAME).exe $(TEMPO)


#-------------------------------------------------
# Examples of how to Remote Procedure Calls (RPC) work
# This example shows both client-side and server-side

rpc.obj:        $(BASENAME).c                    \
                $(TEMPODLL)\fio.h       \
                $(TEMPODLL)\tg.h        \
                $(TEMPODLL)\sstempo.h
    $(LINTX)
    $(COMPILEX) $(BASENAME).c

rpc.exe:        $(BASENAME).lnk                  \
                $(BASENAME).obj                  \
                $(LIBMS)\SYMPHONY.lib
    link @$(BASENAME).lnk  >del.me              


$(TEMPO)\rpc.exe:  rpc.exe
    copy $(BASENAME).exe $(TEMPO)



