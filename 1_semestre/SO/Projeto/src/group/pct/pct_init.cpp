/*
 *  \author ...
 */

#include "somm22.h"
#include "pct_module.h"

#include <stdio.h>
#include <string.h>

namespace somm22
{

    namespace group 
    {

// ================================================================================== //
        
        
        void pctInit(const char *fname) 
        {
            soProbe(201, "%s(\"%s\")\n", __func__, fname);
            FILE *fin;
            fin = fopen(fname, "r");
            uint32_t pid, arrivalTime, duration, addrSpaceSize,dummy;
            char s[5];
            
           
            
            char line[100];
            


            while(fgets(line,100,fin)) {

                int start = 0;
                int end = strlen(line) - 1;
                while (line[start] == ' ' || line[start] == '\t') start++;
                while (line[end] == ' ' || line[end] == '\t' || line[end] == '\n') end--;

                if (line[start] == '#') {
                     continue;
                }

                else {
                // It's a process record, so parse the fields
                    sscanf(line + start, "%u ; %u ; %u ; %s; %u", &pid, &arrivalTime, &duration, s, &dummy);
                    // number of scanned numbers
                    //int n = sscanf(line + start, "%u ; %u ; %u ; %s; %u", &pid, &arrivalTime, &duration, s , &dummy);
                    addrSpaceSize = strtoul(s,NULL,16);
                    pctInsert(pid,arrivalTime,duration,addrSpaceSize);
                    
                    
                    
                }
            }
            
            fclose(fin);
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22

