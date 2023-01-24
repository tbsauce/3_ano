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

        void memInit(uint32_t mSize, uint32_t osSize, uint32_t cSize, AllocationPolicy allocPolicy)
        {
            soProbe(401, "%s(0x%x, 0x%x, 0x%x, %s)\n", __func__, mSize, osSize, cSize, memAllocationPolicyAsString(allocPolicy));

            require(mSize > osSize, "memory must be bigger than the one use by OS");
            require((mSize % cSize) == 0, "memory size must be a multiple of chunck size");
            require((osSize % cSize) == 0, "memory size for OS must be a multiple of chunck size");

            mem::memory.mSize = mSize;
            mem::memory.osSize = osSize;
            mem::memory.cSize = cSize;
            mem::memory.allocPolicy = allocPolicy;

            mem::Block aux;
            aux.pid = 0;
            aux.start = (void *)((char *)0 + osSize);
            aux.size = mSize - osSize;
            mem::memory.freeMem.push_back(aux);
            mem::memory.freeMem.sort([](mem::Block const &a, mem::Block const &b){ return a.start < b.start; });
            
        }

        // ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
