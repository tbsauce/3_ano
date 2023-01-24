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

        void peqInsert(EventType type, uint32_t time, uint32_t pid)
        {
            soProbe(304, "%s(%s, %u, %u)\n", __func__, peqEventTypeAsString(type), time, pid);

            require(pid > 0, "process ID must be non-zero");

            Event newEvent = Event();
            newEvent.eventType = type;
            newEvent.eventTime = time;
            newEvent.pid = pid;

            peq::event_queue.push_back(newEvent);
            peq::event_queue.sort([](Event a, Event b) { return a.eventTime < b.eventTime; });

        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
