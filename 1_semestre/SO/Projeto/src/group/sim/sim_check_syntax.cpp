/*
 *  \author ...
 */

#include "somm22.h"
#include "sim_module.h"
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string.h>
#include <ctype.h>
#include <vector>
#include <stdlib.h>
#include <iostream>
#include <algorithm>

namespace somm22
{

    namespace group
    {

// ================================================================================== //

        // auxiliar functions 

        bool containsDuplicate(int* pids, int size) {
            bool duplicate_pids = false;

            for(int i = 0; i < size; i++) {
                for(int j=i+1;j<size;j++) {
                    // comparing array elements
                    if(pids[i]==pids[j]){
                        duplicate_pids  = true;
                    }
                    else
                    {
                        continue;
                    }
                printf("stop\n");
                }
            }
            if(duplicate_pids==true)
            {
                return true;
            }

            else
            {
                return false;
            }
        }


        //------------------------------main-----------------------------------------------------//

        bool simCheckInputFormat(const char *fname){

            if (fname == NULL){
                printf("File not found!\n");
                exit(1);
            }

            FILE *file_en ;
            int counter = 0 ;
            file_en = fopen(fname,"r") ;
            int pid, arrivalTime, duration, addrSpaceSize, dummy;
            char line[100];
            int pids[200];
            
            for (int i = 0; i < 200; i++) {
                pids[i] = 0;
            }


            while(fgets(line,100,file_en)) {

                int start = 0;
                int end = strlen(line) - 1;
                while (line[start] == ' ' || line[start] == '\t') start++;
                while (line[end] == ' ' || line[end] == '\t' || line[end] == '\n') end--;

                if (line[start] == '#') {
                     continue;
                }

                else {
                // It's a process record, so parse the fields
                sscanf(line + start, "%u ; %u ; %u ; 0x%d; %u", &pid, &arrivalTime, &duration, &addrSpaceSize, &dummy);
                 // number of scanned numbers
                int n = sscanf(line + start, "%u ; %u ; %u ; 0x%d; %u", &pid, &arrivalTime, &duration, &addrSpaceSize, &dummy);

                // para ter o numero de campos apenas necessário
                if (n != 4) {
                    
                    return false;
                }
                
                if ( pid == 0 ||duration == 0 || addrSpaceSize == 0) {
                    return false;
                }
                }

                
                pids[counter] = pid;
                counter++;
            }

            if(containsDuplicate(pids ,counter)){
                 return false;
            }

            else{
                return true;// check if lines are correct form e tratar dos comentários
            }

            fclose(file_en); 
            return 0;

        }

        
// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
