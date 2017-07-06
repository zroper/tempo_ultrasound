/*  .title  CHANINFO.H  Definitions for channel information tables
;+
; DESCRIPTION
;   This file defines the CHANINFO structure and related structures and
;   functions.
;
;   The CHANINFO structure is included in every SSEPOCH created by TEMPOW
;   and COBALT.  The values are set using the A/C/ECHANINFO command in
;   TEMPOW and the ACHANINFO command in COBALT.
;
;   The channel information includes the following meta-data:
;
;       o the original channel number from TEMPOW/COBALT
;       o the type of data (analog, counter, event)
;       o text strings set by the user/application
;         . channel name            (ie "bicept")
;         . channel data type       (ie "emg");
;         . channel user defined    (ie "from wilbur")
;
;   The channel name is used by applications to label channels in
;   a graph or table.
;
;   The channel data type is used by applications that want to
;   know what kind of data is in the channel.
;
;   The user defined field allows for an application to associate
;   application-specific information with the channel.
;
;   As hyperstream objects such as SSEPOCH and STACUBE are passed
;   from one node to another the channel information is kept with
;   the object so applications such as STAMGR and SORTMGR can
;   use them in its display.
;
;
; WARNING
;   These data structures are not designed for persistent storage (ie in a file).  
;
;   Rather, they are intended to be used by nodes to communicate DB epoch information.
;
;   In future Symphony releases, Reflective Computing may add new members, rearrange
;   existing members or change the size of (increase or decrease) these structures.
;
;   Reflective Computing requires that you recompile all of your custom programs with
;   each new Symphony release.
;
;   If you would like to store this information in a persistent data structure (file
;   or database), we recommend that you create your own data structure then copy the
;   members of these structure to it.  This way, your programs will continue to work
;   if we decide to change these structures (by adding new members, rearranging members
;   or changing the size of a structure).
;   
;
;
; SEE ALSO
;   SSEPOCH.H, STACUBE.H, TEMPOW/COBALT's xCHANINFO command.
;
; EDIT HISTORY
;   25Mar09 sh  Moved from SSEPOCH.H
;   09Jul09 sh  Add lMinData, lMaxData, fMinVoltage, fMaxVoltage
;-
*/

//lint -e537
#pragma     pack(push, 1)                   // 1 byte packing for data structures
#include    "TEMPODLL.H"


#ifndef CHANINFO_H
#define CHANINFO_H


//---------------------------------------------------------------------
// CHANINFO Structure
//
// Some data structures may include a channel information table.
// (see SSEPOCH_HEADER.nPerChannelDataBytes and SSEPOCH_HEADER.nOffsetToPerChannelData).
//
// When channel information is included in a data structure, it consists of
// a table (array) of CHANINFO structures, one for each of the data channels
// (SSEPOCH_HEADER.nChannels).
//
// The order of CHANINFO table is from lowest channel number to highest one.
//
// 22Mar09 See TEMPOW's ACHANINFO, CCHANINFO and ECHANINFO commands or COBALT's ACHANINFO command
// for setting these values in TEMPOW/COBALT.

    
#define CHANINFO_NAME_SIZE  32              // # of bytes allocated for SSEPOCH_CHANINFO.szName[]
#define CHANINFO_TYPE_SIZE  32              // # of bytes allocated for SSEPOCH_CHANINFO.szType[]
#define CHANINFO_USER_SIZE  32              // # of bytes allocated for SSEPOCH_CHANINFO.szUser[]

typedef struct
    {
    short   iChannel;                       //02 1-based TEMPO/COBALT ring channel number
                                            //  TEMPOW: [1..ACHANNELS], [1..CCHANNELS] or [1..ECHANNELS]
                                            //  COBALT: [1..ACHANNELS]
                                            
    short   channelType;                    //02 TEMPOW/COBALT Ring from which the data originated
#define CHANINFO_CHANNELTYPE_ANALOG    1    //  Originated from analog ring (TEMPOW or COBALT)
#define CHANINFO_CHANNELTYPE_COUNTER   2    //  Originated from spike ring  (TEMPOW)
#define CHANINFO_CHANNELTYPE_EVENT     3    //  Originated from event ring  (TEMPOW)

    char    szName[CHANINFO_NAME_SIZE];     //32 user-defined channel name (NULL terminated, case insensitive)
    char    szType[CHANINFO_TYPE_SIZE];     //32 user-defined data type (NULL terminated, case insensitive)
    char    szUser[CHANINFO_USER_SIZE];     //32 user-defined string (NULL terminated)
    
    long    lMinData;                       //04 Minimum data value in channel (0 if unknown)
    long    lMaxData;                       //04 Maximum data value in channel (=lMinData if unknown)
    float   fMinVoltage;                    //04 Voltage associated with lMinData (0 if unknown)
    float   fMaxVoltage;                    //04 Voltage associated iwth lMaxData (=fMinVoltage if unknown)
    
    char    reserved1[48];                  //48 Reserved
    } CHANINFO;                             //sizeof(CHANINFO)=164


//-------------------------------------------------------------------------

#endif // ifndef CHANINFO_H



#include    "TEMPODLX.H"
#pragma     pack(pop)                       // See pragma pack(push,1) above
