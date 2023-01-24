/*
 *  \author ...
 */

#include "somm22.h"
#include "pct_module.h"
#include <string>


namespace somm22
{

    namespace group 
    {
        static void internalPrint(FILE* fp) {
            const char* firstLine = "+====================================================================================+\n"
                            "|                               Process Control Table                                |\n"
                            "+-------+-------------+----------+---------------+-----------+-----------------------+\n"
                            "|  PID  | arrivalTime | duration | addrSpaceSize |   state   | startTime |  memAddr  |\n"
                            "+-------+-------------+----------+---------------+-----------+-----------------------+\n";
            fprintf(fp, "%s", firstLine);
            for(auto const& x: pct::process_table) {
                if(x.second.state != TO_COME)
                    fprintf(fp,"|   %u | %11u | %8u | %#14x | %s   | %8u |   %p   |\n", x.first, x.second.arrivalTime, x.second.duration, x.second.addrSpaceSize, pctStateAsString(x.second.state), x.second.startTime, x.second.memAddr);
                else
                    fprintf(fp,"|   %u | %11u | %8u | %#14x | %s   |   %s   |   %p   |\n", x.first, x.second.arrivalTime, x.second.duration, x.second.addrSpaceSize, pctStateAsString(x.second.state), "(nil)", x.second.memAddr);
            }

            const char * lastLine = "+====================================================================================+\n\n";
            fprintf(fp,"%s", lastLine);
        }

// ================================================================================== //

        void pctPrint(const char *fname, PrintMode mode)
        {
            soProbe(202, "%s(\"%s\", %s)\n", __func__, fname, (mode == NEW) ? "NEW" : "APPEND");

            FILE* fpout;
            if(mode == NEW)
                fpout = fopen(fname, "w");
            else if (mode == APPEND)
            {
                fpout = fopen(fname, "a");
            }
            
            internalPrint(fpout);
        }

// ================================================================================== //

        void pctLog()
        {
            soProbe(202, "%s()\n", __func__);

            FILE* fout = logGetStream();
            internalPrint(fout);
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
