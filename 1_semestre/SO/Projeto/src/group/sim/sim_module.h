/*
 *  \author ...
 */

#ifndef __SOMM22__MODULE__SIM__GROUP__
#define __SOMM22__MODULE__SIM__GROUP__

#include <stdint.h>

namespace somm22 
{
    namespace group
    {
        namespace sim
        {
            /* ACTION POINT: Declare here your module's data structure as external */
            extern uint32_t currentSimTime;
            extern uint32_t currentSimMask;
            extern uint32_t currentSimStep;
        } // end of namespace sim

    } // end of namespace group

} // end of namespace somm22

#endif /* __SOMM22__MODULE__SIM__GROUP__ */

