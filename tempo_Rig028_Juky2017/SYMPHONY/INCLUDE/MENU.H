#ifndef MENU_H
#define MENU_H

//lint -e537
#pragma pack(push, 1)               // 1 byte packing for data structures
#include    "TEMPODLL.H"


//typedef struct
//    {
//    char    name[64];               // Menu item name string
//    char    submenu[64];            // NULL or submenu
//    UINT    fType;                  // Menu Item Type (one or more):
//                                    //      MFT_MENUBARBREAK
//                                    //      MFT_RADIOCHECK
//                                    //      MFT_RIGHTJUSTIFY
//                                    //      MFT_SEPARATOR
//                                    //      MFT_STRING
//    UINT    fState;                 // Menu Item State (one or more): 
//                                    //      MFS_CHECKED
//                                    //      MFS_UNCHECKED
//                                    //      MFS_DEFAULT
//                                    //      MFS_DIABLED
//                                    //      MFS_ENABLED
//                                    //      MFS_GRAYED
//                                    //      MFS_HILITE
//                                    //      MFS_UNHILITE
//    UINT    wID;                    // Windows ID
//    } MENUPOPUP;


TEMPODLLAPI long menuInsert(HMENU hmenu, UINT fType, UINT fState, UINT wID, void *itemData, char *fmt, ...);
TEMPODLLAPI long getPopup(HMENU hmenu, char *name);
TEMPODLLAPI BOOL setSubMenu(HMENU hmenu, long item, HMENU hSubMenu);
TEMPODLLAPI BOOL getMenuString(HMENU hmenu, long itemID, char *filename, long len);
TEMPODLLAPI BOOL menuGetItemByID(HMENU hmenu, long wID, MENUITEMINFO *item);

//lint -printf(5, menuInsert)

#include "TEMPODLX.H"

#pragma pack(pop)                   // See pragma pack(push,1) above

#endif // ifndef MENU_H

