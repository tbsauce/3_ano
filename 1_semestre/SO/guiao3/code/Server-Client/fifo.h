/**
 *  @file 
 *
 *  @brief A simple FIFO, whose elements are pairs of integers,
 *      one representing the producer and the other the value produced
 *
 *  The following operations are defined:
 *     \li insertion of a value
 *     \li retrieval of a value.
 *
 * \author (2016-2022) Artur Pereira <artur at ua.pt>
 */

#ifndef __SO_IPC_FIFO_
#define __SO_IPC_FIFO_

#include <stdint.h>

/** \brief internal storage size of <em>FIFO memory</em> */
    #define  FIFOSZ         5

    /*
     *  \brief Type of the shared data structure.
     */
    struct BUFFER
    {
        uint32_t id;            ///< id of the consumer
        char* text;         ///< storage memory
        int num_characters;
        int num_letters;
        int num_digits;
    };

    /* when using shared memory, the size of the data structure must be fixed */
    struct FIFO
    { 
        int semid;              ///< syncronization semaphore array
        uint32_t ii;            ///< point of insertion
        uint32_t ri;            ///< point of retrieval
        uint32_t cnt;           ///< number of items stored
        BUFFER slot[FIFOSZ];    ///< storage memory
    };

    
    

namespace fifo
{
    /** \brief create a FIFO in shared memory, initialize it, and return its id */
    FIFO* create(void);

    /** \brief destroy the shared FIFO given id */
    void destroy(FIFO* fifo);

    /**
     *  \brief Insertion of a value into the FIFO.
     *
     * \param id id of the producer
     * \param value value to be stored
     */
    void in(FIFO* fifo,uint32_t id, uint32_t value);

    /**
     *  \brief Retrieval of a value from the FIFO.
     *
     * \param idp pointer to recipient where to store the producer id
     * \param valuep pointer to recipient where to store the value 
     */
    void out(FIFO* fifo, uint32_t * idp, uint32_t  *valuep);

}
#endif /* __SO_IPC_FIFO_ */
