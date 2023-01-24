/*
 *  \author ...
 */

#include "somm22.h"
#include "mem_module.h"

namespace somm22
{

    namespace group 
    {

// ================================================================================== //
        static void internalPrint(FILE* fp) {
            const char* firstLine = "+==============================+\n"
                                    "|  Memory Management busy list |\n"
                                    "+-------+-----------+----------+\n"
                                    "|  PID  |   start   |   size   |\n" 
                                    "+-------+-----------+----------+\n";
            fprintf(fp, "%s", firstLine);

            //list<Block>::iterator it;
            for (auto const& i : mem::memory.busyMem) {
                fprintf(fp,"|  %u  | %9p | %#8x |\n", i.pid, i.start, i.size);
            }

            const char* lastLine = "+==============================+\n\n";
            fprintf(fp, "%s", lastLine);

            const char* firstLine2 ="+==============================+\n"
                                    "|  Memory Management free list |\n"
                                    "+-------+-----------+----------+\n"
                                    "|  PID  |   start   |   size   |\n" 
                                    "+-------+-----------+----------+\n";
            fprintf(fp, "%s", firstLine2);
            for (auto const& i : mem::memory.freeMem) {
                fprintf(fp,"|  %s  | %9p | %#8x |\n", "---", i.start, i.size);
            }
            fprintf(fp, "%s", lastLine);
        }

        void memLog()
        {
            soProbe(402, "%s()\n", __func__);

            FILE* fout = logGetStream();
            internalPrint(fout);
        }

// ================================================================================== //

        void memPrint(const char *fname, PrintMode mode)
        {
            soProbe(402, "%s(\"%s\", %s)\n", __func__, fname, (mode == NEW) ? "NEW" : "APPEND");

            FILE* fpout;
            if(mode == NEW)
                fpout = fopen(fname, "w");
            else if (mode == APPEND)
            {
                fpout = fopen(fname, "a");
            }

            internalPrint(fpout);

            /* ACTION POINT: Replace next instruction with your code */
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
