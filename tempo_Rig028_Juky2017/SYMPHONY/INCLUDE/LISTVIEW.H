#include    "tempodll.h"

TEMPODLLAPI void lvSetColumnHeading(HWND hListView, long iColumn, char *fmt, ...);
TEMPODLLAPI void lvInsertRow(HWND hListView, long iRow, char *fmt, ...);
TEMPODLLAPI void lvSetColumn(HWND hListView, long iRow, long iColumn, char *fmt, ...);
TEMPODLLAPI void lvGetColumn(HWND hListView, long iRow, long iColumn, char *buf, long nBuf);
TEMPODLLAPI void lvSetFullRowSelect(HWND hListView);
TEMPODLLAPI void lvSetGrid(HWND hListView);
TEMPODLLAPI long lvGetNextSelectedItem(HWND hListView, long iItem);
TEMPODLLAPI long lvGetColumnCount(HWND hList);
TEMPODLLAPI long lvGetColumnFromCX(HWND hList, long cx);
TEMPODLLAPI long lvGetColumnRect(HWND hList, long iRow, long iCol, RECT *pRect);


//lint -printf(3,lvSetColumnHeading)
//lint -printf(3,lvInsertRow)
//lint -printf(4,lvSetColumn)


#include "tempodlx.h"
