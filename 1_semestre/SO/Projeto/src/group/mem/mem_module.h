/*
 *  \author ...
 */

#ifndef __SOMM22__MODULE__MEM__GROUP__
#define __SOMM22__MODULE__MEM__GROUP__

#include "somm22.h"
#include <list>

namespace somm22
{
    
    namespace group 
    {

        namespace mem
        {
            /* ACTION POINT: Declare here your module's data structure as external */

            struct Block{   
                uint32_t pid;
                void * start;
                uint32_t size;
            };

            struct Memory{
                uint32_t mSize;
                uint32_t osSize;
                uint32_t cSize;
                AllocationPolicy allocPolicy;
                std::list<Block> freeMem, busyMem;
                uint32_t nextFitIdx;
            };
            
            extern Memory memory;

        } // end of namespace mem

    } // end of namespace group

} // end of namespace somm22

#endif /* __SOMM22__MODULE__MEM__GROUP__ */


