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

        void memFree(void *addr)
        {
            soProbe(408, "%s(addr: %p)\n", __func__, addr);

            require(addr != NULL, "addr must be non-null");

            for( uint32_t i =0; i<mem::memory.busyMem.size(); i++)
            {
                //Finds the block to be freed
                if(std::next(mem::memory.busyMem.begin(),i)->start == addr)
                {

                    uint32_t addrSize= std::next(mem::memory.busyMem.begin(),i)->size;

                    if(mem::memory.freeMem.size() == 1)
                    {
                        char *addrU = (char *)addr;
                        
                        void* before = std::next(mem::memory.freeMem.begin(),0)->start;
                        char *beforeStart = (char *)before;
                        if( addrU + addrSize == beforeStart)
                        {
                            std::next(mem::memory.freeMem.begin(),0)->size += addrSize;
                            std::next(mem::memory.freeMem.begin(),0)->start = addr;
                        }
                        else
                        {
                            mem::memory.freeMem.insert(std::next(mem::memory.freeMem.begin(),0),mem::Block{0,addr,addrSize});
                        }
                    }
                    else
                    {
                        for(uint32_t j=0; j<mem::memory.freeMem.size()-1; j++)
                        {

                            char *addrU = (char *)addr;
                            
                            uint32_t beforeSize = std::next(mem::memory.freeMem.begin(),j)->size;
                            void* before = std::next(mem::memory.freeMem.begin(),j)->start;
                            char *beforeStart = (char *)before;
                            
                            uint32_t afterSize = std::next(mem::memory.freeMem.begin(),j+1)->size;
                            void* after = std::next(mem::memory.freeMem.begin(),j+1)->start;
                            char *afterStart = (char *)after;

                            if((beforeStart+beforeSize) == addrU && (addrU+addrSize) == afterStart)
                            {
                                std::next(mem::memory.freeMem.begin(),j)->size += addrSize + afterSize;
                                mem::memory.freeMem.erase(std::next(mem::memory.freeMem.begin(),j+1));
                                break;
                            }
                            else if((beforeStart+beforeSize) == addrU)
                            {
                                std::next(mem::memory.freeMem.begin(),j)->size += addrSize;
                                printf("nada");
                                break;
                            }
                            else if((addrU+addrSize) == afterStart)
                            {
                                std::next(mem::memory.freeMem.begin(),j+1)->size += addrSize;
                                std::next(mem::memory.freeMem.begin(),j+1)->start = addr;
                                break;
                            }
                            else if( addrU + addrSize == beforeStart)
                            {
                                std::next(mem::memory.freeMem.begin(),j)->size += addrSize;
                                std::next(mem::memory.freeMem.begin(),j)->start = addr;
                                break;
                            }
                            else
                            {
                                mem::memory.freeMem.insert(std::next(mem::memory.freeMem.begin(),j),mem::Block{0,addr,addrSize});
                                break;
                            }
                    
                        }

                    }
                    
                    mem::memory.busyMem.erase(std::next(mem::memory.busyMem.begin(),i));
                    break;
                }
            }
        }

        // ================================================================================== //

    } // end of namespace group

} // end of namespace somm22
