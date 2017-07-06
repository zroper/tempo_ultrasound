//lint -esym(537, tempodll.h)
#include    "tempodll.h"

//lint -printf(3,MessageBoxf)
//lint -esym(534,MessageBoxf)       return value can be ignored
TEMPODLLAPI int MessageBoxf(HWND hDlg, char *title, char *format, ...);         // = IDOK

//lint -printf(3,MessageBoxfOKCANCEL)
//lint -esym(534,MessageBoxfOKCANCEL)       return value can be ignored
TEMPODLLAPI int
MessageBoxfOKCANCEL(HWND hDlg, char *title, char *format, ...);                 // =IDYES, IDCANCEL

//lint -printf(3,MessageBoxfYESNO)
//lint -esym(534,MessageBoxfYESNO)       return value can be ignored
TEMPODLLAPI int MessageBoxfYESNO(HWND hDlg, char *title, char *format, ...);    // =IDYES, IDNO

//lint -printf(3,MessageBoxfYESNOCANCEL)
//lint -esym(534,MessageBoxfYESNOCANCEL)       return value can be ignored
TEMPODLLAPI int MessageBoxfYESNOCANCEL(HWND hDlg, char *title, char *format, ...);    // =IDYES, IDNO, IDCANCEL

//lint -printf(3,MessageBoxfRETRYCANCEL)
//lint -esym(534,MessageBoxfRETRYCANCEL)       return value can be ignored
TEMPODLLAPI int MessageBoxfRETRYCANCEL(HWND hDlg, char *title, char *format, ...);    // =IDRETRY, IDCANCEL

//lint -printf(3,MessageBoxfABORTRETRYIGNORE)
//lint -esym(534,MessageBoxfABORTRETRYIGNORE)       return value can be ignored
TEMPODLLAPI int MessageBoxfABORTRETRYIGNORE(HWND hDlg, char *title, char *format, ...);    // =IDABORT, IDRETRY or IDCANCEL


#include    "tempodlx.h"

