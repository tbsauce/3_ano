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

        void *memBestFitAlloc(uint32_t pid, uint32_t size)
        {
            soProbe(406, "%s(%u, 0x%x)\n", __func__, pid, size);

            require(pid > 0, "process ID must be non-zero");
            uint32_t auxSize;
            uint32_t idx;
            uint32_t tempSize = 0;
            mem::Block aux;
            for(uint32_t i = 0; i<mem::memory.freeMem.size(); i++) {
                auxSize = std::next(mem::memory.freeMem.begin(),i)->size;
                if((auxSize >= size && auxSize < tempSize) || tempSize == 0) {
                    tempSize = auxSize;
                    idx = i;                    
                }
            }

            aux.start = std::next(mem::memory.freeMem.begin(),idx)->start;
            aux.pid = pid;
            aux.size = size;

            if(auxSize - size == 0) {
                mem::memory.freeMem.erase(std::next(mem::memory.freeMem.begin(),idx));
            }
            else {
                char *auxStart = (char *)aux.start;
                auxStart += size;

                std::next(mem::memory.freeMem.begin(),idx)->start = (void *)(auxStart);
                std::next(mem::memory.freeMem.begin(),idx)->size -= size;                      
            }
            
            mem::memory.busyMem.push_back(aux);
            mem::memory.busyMem.sort([](mem::Block const& a, mem::Block const& b) { return a.start < b.start; });

            return aux.start;
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
