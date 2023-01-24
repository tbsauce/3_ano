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

        uint32_t memGetBiggestHole()
        {
            soProbe(409, "%s()\n", __func__);
            //fazer melhor
            mem::memory.freeMem.sort([](mem::Block a, mem::Block b){return a.size > b.size;});
            uint32_t aux = mem::memory.freeMem.front().size;
            mem::memory.freeMem.sort([](mem::Block a, mem::Block b){return a.size < b.size;});
            return aux;
        }

// ================================================================================== //

        uint32_t memGetMaxAllowableSize()
        {
            soProbe(409, "%s()\n", __func__);
            //is it right???
            return mem::memory.mSize - mem::memory.osSize;    
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
