/* .title   DDECLI.H    Definitions for TEMPO'S DDE CLIENT
;+
; SYNOPSIS
;   This file contains definitions for DDECLI, a sample C DDE client
;   for TEMPO/Win.
;
; DISCLAIMER
;   This code is provided without support of any kind.  It is intended
;   to serve as an example for how to access TEMPO's DDE server.  These
;   files may not be freely distributed without written permission from
;   Reflective Computing.  By receiving these files, you agree that they
;   are a "trade secret" and that you will use them strickly for your
;   own research using the TEMPO software.
;
;   This code is subject to change without notice.  If you use these files
;   in your programs, you may need to make changes to your program in
;   subsequent releases due to changes made here.
;
;   Copyright 1999 Reflective Computing.  All Rights Reserved.
;
; EDIT HISTORY
;   05Jun99 sh  Initial edit
;   21Jan00 sh  Add CF_BINARY definition
;-
*/
#define DDE_TIMEOUT      5000

typedef struct
    {
    DWORD           hInst;              // DDEML instance handle
    HCONV           hConv;              // DDEML conversation handle
    HSZ             hItem;              // DDEML item string handle
    PFNCALLBACK     Callback;           // User's callback function
    } ADVISORYLINK;

#define NMAXADV    50                   // Max # of advisory links

// DATA FORMATS SUPPORTED BY TEMPO'S DDE SERVER

//#define CF_TEXT   1                   // TEXT Defined in ..\include\winresrc.h
#define CF_BINARY   20                  // BINARY format (doesn't conflict with other CF_xxx)

// TEMPO'S DATABASE TYPES

#ifndef HFUNC_SUM                       //  SAMPLE PROPERTIES       DB TYPE
    #define HFUNC_SUM   0               //  signed (8 bit) short    Sum
    #define HFUNC_APP   1               //  signed (8 bit) char     Append
    #define HFUNC_USUM  2               //  unsigned short          Sum
    #define HFUNC_UAPP  3               //  unsigned short          Append
    #define HFUNC_ESUM  4               //  unsigned short          Sum
    #define HFUNC_EAPP  5               //  unsigned short          Append
    #define HFUNC_XSUM  6               //  signed (12 bit) short   Sum
    #define HFUNC_XAPP  7               //  signed (12 bit) short   Append
#endif

UINT TempoInit(DWORD *hInst);
UINT TempoUnInit(DWORD hInst);
HCONV TempoOpenConv(DWORD hDDEInst, char *Service, char *Topic);
long TempoAdvise(DWORD hInst, HCONV hConv, char *Item, PFNCALLBACK Callback);
long TempoUnAdvise(long i);
BOOL TempoCloseConv(HCONV hConv);
HDDEDATA TempoGetItem(DWORD hInst, HCONV hConv, char *Item, UINT iFmt, DWORD timeout);
long TempoExecute(DWORD hInst, HCONV hConv, char *Command, DWORD timeout);

//// See note in TEMPODDE.C
//// Use ClientTransaction() instead of DdeClientTransaction().
//
//HDDEDATA ClientTransaction(LPBYTE pData, DWORD cbData, HCONV hConv,
//                  HSZ hszItem, UINT wFmt, UINT wType,
//                  DWORD dwTimeout, LPDWORD pdwResult);

