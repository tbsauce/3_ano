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

        Event peqFetchNext(uint32_t mask)
        {
            const char *maskStr = (mask == 0) ? "ANY" : ((mask == POSTPONED) ? "POSTPONED" : "ARRIVAL | TERMINATE");
            soProbe(305, "%s(%s)\n", __func__, maskStr);
            if (mask == 0)
            {
                mask = 0b111 ;
            }
            std::list<Event>::iterator it;
            for (it = peq::event_queue.begin(); it != peq::event_queue.end(); it++){
                if ((mask & it->eventType) != 0) {
                    peq::event_queue.erase(it);
                    return *it;
                }
            }

            // event not found with given mask -> throw exception
            throw Exception(EINVAL, __func__);

        }

// ================================================================================== //

        Event peqPeekNext(uint32_t mask)
        {
            const char *maskStr = (mask == 0) ? "ANY" : ((mask == POSTPONED) ? "POSTPONED" : "ARRIVAL | TERMINATE");
            soProbe(305, "%s(%s)\n", __func__, maskStr);
            if (mask == 0){
                mask = 0b111 ;
            }
            std::list<Event>::iterator it;
            for (it = peq::event_queue.begin(); it != peq::event_queue.end(); it++){
                if ((mask & it->eventType) != 0) {
                    return *it;
                }
            }
            // event not found with given mask -> throw exception
            throw Exception(EINVAL, __func__);
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
