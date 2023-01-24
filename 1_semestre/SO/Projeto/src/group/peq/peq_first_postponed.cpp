/*
 *  \author ...
 */

#include "somm22.h"
#include "peq_module.h"

namespace somm22
{

    namespace group 
    {

// ================================================================================== //

        uint32_t peqGetFirstPostponedProcess() 
        {
            soProbe(306, "%s()\n", __func__);

            std::list<Event>::iterator it;
            for (it = peq::event_queue.begin(); it != peq::event_queue.end(); it++){
                if ((it->eventType & 0b010) != 0) return it->pid;
            }
            
            return 0;
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22

