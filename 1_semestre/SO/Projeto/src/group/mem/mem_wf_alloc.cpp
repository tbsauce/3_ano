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

        void *memWorstFitAlloc(uint32_t pid, uint32_t size)
        {
            soProbe(407, "%s(%u, 0x%x)\n", __func__, pid, size);

            require(pid > 0, "process ID must be non-zero");

            mem::Block aux;
            uint32_t auxSize;
            char *auxStart;
            for(uint32_t i = 0; i<mem::memory.freeMem.size(); i++) {
                auxSize = std::next(mem::memory.freeMem.begin(),i)->size;
                if(auxSize >= size && auxSize == memGetBiggestHole()) {
                    aux.start = std::next(mem::memory.freeMem.begin(),i)->start;
                    aux.pid = pid;
                    aux.size = size;

                    if(auxSize - size == 0) {
                        mem::memory.freeMem.erase(std::next(mem::memory.freeMem.begin(),i));
                    }
                    else {
                        auxStart = (char *)aux.start;
                        auxStart += size;

                        std::next(mem::memory.freeMem.begin(),i)->start = (void *)(auxStart);
                        std::next(mem::memory.freeMem.begin(),i)->size -= size;                      
                    }
                    
                    mem::memory.busyMem.push_back(aux);
                    mem::memory.busyMem.sort([](mem::Block const& a, mem::Block const& b) { return a.start < b.start; });
                    break;
                    
                }

                
            }

            return aux.start;
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
