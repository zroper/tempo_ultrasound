/*  .title  VERSION.H - Program Version information !!!16 & 32 bit version!!!
;+
; DESCRIPTION
;   /EXEPACK in Link file can screw up this mechanism by packing repeating
;   characters in the vi.note[] field.  One way around this is to define
;   the note field as a sequence of 15 non-repeating characters.
;   
;
; EDIT HISTORY
;   09Jul01 sh  Initial edit
;-
*/

#ifndef VERSION_H
#define VERSION_H


#define VERSIONPREFIX   "~$MTC&KTD"     // Martha The cat & Kasha The Dog
#define VERSIONSUFFIX   "DTK&CTM$~"

typedef struct
    {
    char    prefix[sizeof(VERSIONPREFIX)]; // =VERSIONPREFIX
    char    version[4];                 // NULL terminated version number
    char    subVersion[4];              // NULL terminated subVersion number
    char    set[4];                     // NULL terminated set number
    char    subSet[4];                  // NULL terminated sub Set
    char    note[16];                   // NULL terminated note
    char    date[sizeof(__DATE__)];     // Jun 08 1954
    char    time[sizeof(__TIME__)];     // 12:01:01
    char    suffix[sizeof(VERSIONSUFFIX)]; // =VERSIONSUFFIX
    } VERSIONINFO;
    
short getFileVersion(char *filename, VERSIONINFO *vi);

//char *versionInformation =
//        VERSIONINFOSTRING("10  ",              // version (exactly 4 chars)
//                          "2   ",              // subver  (exactly 4 chars)
//                          "0   ",              // set     (exactly 4 chars)
//                          "0   ",              // subset  (exactly 4 chars)
//                          "KINFO. . . . . ."); // note    (exactly non-repeating 15 chars)

#define VERSIONINFOSTRING(ver, subver, set, subset, note) \
            VERSIONPREFIX " "                             \
            ver subver set subset note                    \
            __DATE__ " "  __TIME__ " "                    \
            VERSIONSUFFIX " "
            
#define VERSIONINFOSTRUCT(ver, subver, set, subset, note) \
            {VERSIONPREFIX, ver, subver, set, subset, note, __DATE__, __TIME__, VERSIONSUFFIX}
    

#endif  /* ifndef VERSION_H */

