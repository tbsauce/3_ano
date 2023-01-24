/*
 *  \author ...
 */

#include "somm22.h"
#include "pct_module.h"
#include <map>

namespace somm22
{
    namespace group 
    {
        namespace pct
        {
            /* ACTION POINT: Declare here your module's internal data structure */
            std::map<uint32_t, process> process_table;
            
        } // end of namespace pct

    } // end of namespace group

} // end of namespace somm22

