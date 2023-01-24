/*
 *  \author ...
 */

#include "somm22.h"
#include "sim_module.h"

namespace somm22 
{

    namespace group
    {

// ================================================================================== //

        /*
         * \brief Init the module's internal data structure
         */
        void simInit()
        {
            soProbe(501, "%s()\n", __func__);

            try{
                sim::currentSimMask = 0;
                sim::currentSimStep = 0;
                sim::currentSimTime = 0;
                }
            catch (const somm22::Exception& e){
                throw Exception(e);
            }
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
