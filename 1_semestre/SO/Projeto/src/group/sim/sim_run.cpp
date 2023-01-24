/*
 *  \author ...
 */

#include "somm22.h"
#include "sim_module.h"
#include <iostream>
#include <queue>
using namespace std;

namespace somm22
{

    namespace group
    {

// ================================================================================== //
        // To get the first pid of the process in POSTPONED
        uint32_t get_pid = 0 ;
        // To get the time of the postponed process
        uint32_t time_postponed = 0 ;
        /*
         * Solution may be based on a state machine with two states, which are related to the
         * type of events that are fetched from the Process Event Queue.
         * The meaningful cases are:
         * - ARRIVAL | TERMINATE
         * - POSTPONED
         */

        // Function to process the POSTPONEDS or ARRIVALS 
        void processing_post_or_arrival(uint32_t pid)
        {
            pctSetProcessState(pid,ProcessState::RUNNING);
            pctSetProcessStartTime(pid,sim::currentSimTime) ;
            pctSetProcessMemAddress(pid,memAlloc(pid,pctGetProcessAddressSpaceSize(pid))) ;
            peqInsert(EventType::TERMINATE, sim::currentSimTime +  pctGetProcessDuration(pid) , pid)  ;
                    
        }

        // Function to process the TERMINATES
        void processing_terminate(Event event)
        {
            memFree(pctGetProcessMemAddress(event.pid)) ;
            pctSetProcessState(event.pid,ProcessState::FINISHED) ;
            time_postponed += pctGetProcessDuration(event.pid) ;
        }

        // Function to decide the states according to the masks or size of the process
        void auxiliar_run(Event event)
        {
            
            uint32_t BiggestBlock = memGetBiggestHole() ;
            sim::currentSimTime = event.eventTime ;
           // If a process requires more than the total existing memory, it should be DISCARDED
            if (pctGetProcessAddressSpaceSize(event.pid) > memGetMaxAllowableSize()) 
            {
                pctSetProcessState(event.pid,ProcessState::DISCARDED) ;
            }
            
            else if (event.eventType == ARRIVAL)
            {
                if ((pctGetProcessAddressSpaceSize(event.pid) <= BiggestBlock) && peqGetFirstPostponedProcess()==0)
                {
                    // If the space exists and there isnt process in POSTPONED run the process normaly
                    processing_post_or_arrival(event.pid);
                }
                else 
                {
                    // IF the biggest block is smaller than the space needed or there are processes in POSTPONED
                    // Update the states
                    peqInsert(EventType::POSTPONED,event.eventTime,event.pid) ;
                    pctSetProcessState(event.pid,ProcessState::SWAPPED);
                }
                
            }
            else if(event.eventType == POSTPONED)
            {
                sim::currentSimTime = time_postponed;
                processing_post_or_arrival(get_pid);
            }
            else if(event.eventType == TERMINATE)
            {
                processing_terminate(event) ;
            }
        }
        // Function to run the process
        void run()
        {
            sim::currentSimStep += 1 ;
            Event event = peqFetchNext(simGetCurrentSimMask()) ;

            auxiliar_run(event);
            sim::currentSimMask = ARRIVAL | TERMINATE;

            get_pid = peqGetFirstPostponedProcess();
            if (get_pid != 0)
            {
                if (pctGetProcessAddressSpaceSize(get_pid) <= memGetBiggestHole() ){
                    sim::currentSimMask = POSTPONED ;
                }
            }
        }

        void simRun(uint32_t cnt)
        {
            soProbe(503, "%s(cnt: %u)\n", __func__, cnt);
            // Number of steps equal to zero , run til the peq is Empty
            if (cnt == 0)
            {
                while(!peqIsEmpty()){
                    run();
                }
            }
            // Number of steps different of zero, run the number of steps
            if (cnt != 0){
                for(uint32_t steps = 0 ; steps < cnt ; steps++){
                     run();
                }
            }
            /* ACTION POINT: Replace next instruction with your code */
            //throw Exception(ENOSYS, __func__);
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
