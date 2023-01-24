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

        const char *memAllocationPolicyAsString(AllocationPolicy policy)
        {
            soProbe(490, "%s(\"%u\")\n", __func__, policy);

            switch(policy) {
                case FirstFit:
                    return "FirstFit";
                case NextFit:
                    return "NextFit";
                case BestFit:
                    return "BestFit";
                case WorstFit:
                    return "WorstFit";
                default:
                    return "UNKNOWN";
            }
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22

