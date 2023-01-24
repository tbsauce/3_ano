/*
 *  \author ...
 */

#include "somm22.h"
#include "pct_module.h"

namespace somm22
{

    namespace group 
    {

// ================================================================================== //

        void pctSetProcessMemAddress(uint32_t pid, void *memAddr)
        {
            soProbe(207, "%s(%d, %p)\n", __func__, pid, memAddr);

            require(pid > 0, "process ID must be non-zero");

            pct::process_table[pid].memAddr = memAddr;
        }

// ================================================================================== //

        void pctSetProcessState(uint32_t pid, ProcessState state)
        {
            soProbe(208, "%s(%d, %s)\n", __func__, pid, pctStateAsString(state));

            require(pid > 0, "process ID must be non-zero");

            pct::process_table[pid].state = state;

        }

// ================================================================================== //

        void pctSetProcessStartTime(uint32_t pid, uint32_t time)
        {
             soProbe(209, "%s(%d, %u)\n", __func__, pid, time);

            require(pid > 0, "process ID must be non-zero");

            pct::process_table[pid].startTime = time;
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
