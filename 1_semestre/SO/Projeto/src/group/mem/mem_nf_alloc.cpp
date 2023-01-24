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

        void *memNextFitAlloc(uint32_t pid, uint32_t size)
        {
            soProbe(405, "%s(%u, 0x%x)\n", __func__, pid, size);

            require(pid > 0, "process ID must be non-zero");
            uint32_t auxSize;
            char *auxStart;
            uint32_t j = 0;
            uint32_t k = 0;

            mem::Block aux;
            for(uint32_t i = 0; i<mem::memory.freeMem.size(); i++) {

                if(j < mem::memory.freeMem.size() - mem::memory.nextFitIdx - 1) {
                    k += mem::memory.freeMem.size() - mem::memory.nextFitIdx - 1;
                } else {
                    k -= j;
                }

                auxSize = std::next(mem::memory.freeMem.begin(),k)->size;
                if(auxSize >= size) {
                    aux.start = std::next(mem::memory.freeMem.begin(),k)->start;
                    aux.pid = pid;
                    aux.size = size;

                    if(auxSize - size == 0) {
                        auxStart = (char *)std::next(mem::memory.freeMem.begin(),k+1)->start;
                        mem::memory.freeMem.erase(std::next(mem::memory.freeMem.begin(),k));
                    }
                    else {
                        auxStart = (char *)aux.start;
                        auxStart += size;

                        std::next(mem::memory.freeMem.begin(),k)->start = (void *)(auxStart);
                        std::next(mem::memory.freeMem.begin(),k)->size -= size;                      
                    }
                    mem::memory.nextFitIdx = k;
                    mem::memory.busyMem.push_back(aux);
                    mem::memory.busyMem.sort([](mem::Block const& a, mem::Block const& b) { return a.start < b.start; });
                    break;
                    
                }
                j++;
                
                if (k == mem::memory.nextFitIdx - 1) {
                    break;
                }
            }

            return aux.start;
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
