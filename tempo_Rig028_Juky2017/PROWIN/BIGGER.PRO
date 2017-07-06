/* Test boxes getting bigger to determine if
 * there is a bug using 1024x766 with large boxes
 */
#include    object.pro

size = 100;
count = 0;

process MAIN enabled
    {
    oSetGraph(gLEFT, aRANGE, 0, 1024, 0, 1024);
    while (size < 1000)
        {
        box = oCreate(tBOX, gLEFT, size, size);
        count = count + 1;
        printf("BOX %d OBJECT %d\n", count, box);
        x = 0;
        y = 500;
        while (x + size < 1000)
            {
            if (!(x % 100))
                printf("size %d, (%d,%d)\n", size, x, y);
            oMove(box, x, y);
            wait    100;
            x = x + 100;
            y = y + 10;            
            }
        size = size + 10;
        oSetAttribute(box, aINVISIBLE);
        wait    500;
        oDestroy(box);
        }
    print("End of test.");
    }
