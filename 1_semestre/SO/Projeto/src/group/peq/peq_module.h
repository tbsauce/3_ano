/*
 *  \author ...
 */

#ifndef __SOMM22__MODULE__PEQ__GROUP__
#define __SOMM22__MODULE__PEQ__GROUP__

#include "somm22.h"

#include <list>
#include <stdio.h>
#include <algorithm>

#define FIFO_MAX_SIZE 10

namespace somm22
{

    namespace group 
    {

        namespace peq
        {
            extern std::list<Event> event_queue;
        } // end of namespace peq

    } // end of namespace group

} // end of namespace somm22

#endif /* __SOMM22__MODULE__PEQ__GROUP__ */

