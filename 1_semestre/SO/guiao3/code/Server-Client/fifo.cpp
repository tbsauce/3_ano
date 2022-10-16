/*
 *  @brief A simple FIFO, whose elements are pairs of integers,
 *      one being the id of the producer and the other the value produced
 *
 * @remarks safe, non busy waiting version
 *
 *  The following operations are defined:
 *     \li insertion of a value
 *     \li retrieval of a value.
 *
 * \author (2016-2022) Artur Pereira <artur at ua.pt>
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <errno.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <stdint.h>
#include <string.h>

#include "fifo.h"
#include "delays.h"
#include "process.h"

namespace fifo
{
    
/** \brief internal storage size of <em>FIFO memory</em> */
    #define  FIFOSZ         5

    /*
     *  \brief Type of the shared data structure.
     */
    struct BUFFER
    {
        uint32_t id;            ///< id of the consumer
        char* text;             ///< storage memory
        int len;
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

    int FreeBuffersId = -1;
    int PendingRequestsId =  -1;
    int bufferId = -1;
    int semBufId = -1;

    FIFO* FreeBuffers = NULL;
    FIFO* PendingRequests = NULL;

    BUFFER*  pool;          ///< buffer
    uint32_t iBuffer;            ///< point of insertion
    uint32_t rBuffer;            ///< point of retrieval
    uint32_t cntBuffer;          ///< number of items stored

    /* ************************************************* */

    /* index of access, full and empty semaphores */
    #define ACCESS 0
    #define NITEMS 1
    #define NSLOTS 2

    /* ************************************************* */

    static void down(int semid, unsigned short index)
    {
        struct sembuf op = {index, -1, 0};
        psemop(semid, &op, 1);
    }

    /* ************************************************* */

    static void up(int semid, unsigned short index)
    {
        struct sembuf op = {index, 1, 0};
        psemop(semid, &op, 1);
    }


    /* ************************************************* */

    void inicialize_fifo(FIFO * fifo){
        /* init fifo */
        uint32_t i;
        for (i = 0; i < FIFOSZ; i++)
        {
            fifo->slot[i].id = 99;
            fifo->slot[i].text = "NULL";
            fifo->slot[i].len = 0;
            fifo->slot[i].num_letters = 0;
            fifo->slot[i].num_digits = 0;
        }
        fifo->ii = fifo->ri = 0;
        fifo->cnt = 0;

        /* create access, full and empty semaphores */
        fifo->semid = psemget(IPC_PRIVATE, 3, 0600 | IPC_CREAT | IPC_EXCL);

        /* init semaphores */
        for (i = 0; i < FIFOSZ; i++)
        {
            up(fifo->semid, NSLOTS);
        }
        up(fifo->semid, ACCESS);
    }

    /* create a FIFO in shared memory, initialize it, and return its id */
    void create(void)
    {
        /* create the shared memory */
        FreeBuffersId = pshmget(IPC_PRIVATE, sizeof(FIFO), 0600 | IPC_CREAT | IPC_EXCL);

        /*  attach shared memory to process addressing space */
        FreeBuffers = (FIFO*)pshmat(FreeBuffersId, NULL, 0);

        inicialize_fifo(FreeBuffers);

        /* create the shared memory */
        PendingRequestsId = pshmget(IPC_PRIVATE, sizeof(FIFO), 0600 | IPC_CREAT | IPC_EXCL);

        /*  attach shared memory to process addressing space */
        PendingRequests = (FIFO*)pshmat(PendingRequestsId, NULL, 0);

        inicialize_fifo(PendingRequests);

        /* create the shared memory */
        bufferId = pshmget(IPC_PRIVATE, FIFOSZ * sizeof(FIFO), 0600 | IPC_CREAT | IPC_EXCL);

        /*  attach shared memory to process addressing space */
        pool = (BUFFER*)pshmat(bufferId, NULL, 0);

        /* init BUFFER */
        uint32_t i;
        for (i = 0; i < FIFOSZ; i++)
        {
            pool[i].id = 99;
            pool[i].text = "NULL";
            pool[i].len = 0;
            pool[i].num_letters = 0;
            pool[i].num_digits = 0;
        }

        /* create access, full and empty semaphores */
        semBufId = psemget(IPC_PRIVATE, 3, 0600 | IPC_CREAT | IPC_EXCL);

        /* init semaphores */
        for (i = 0; i < FIFOSZ; i++)
        {
            up(semBufId, NSLOTS);
        }
        up(semBufId, ACCESS);

    }

    /* ************************************************* */

    void destroy()
    {
        /* detach shared memory from process addressing space */
        pshmdt(FreeBuffers);
        pshmdt(PendingRequests);

        /* destroy the shared memory */
        pshmctl(FreeBuffersId, IPC_RMID, NULL);
        pshmctl(PendingRequestsId, IPC_RMID, NULL);
    }

    /* ************************************************* */
    uint32_t getFreeBuffer()
    {
        
        down(FreeBuffers->semid, NITEMS);
        down(FreeBuffers->semid, ACCESS);

        uint32_t id = FreeBuffers->slot[FreeBuffers->ri].id;
        FreeBuffers->ri = (FreeBuffers->ri + 1) % FIFOSZ;
        FreeBuffers-> cnt--;
        
        up(FreeBuffers->semid, ACCESS);
        up(FreeBuffers->semid, NSLOTS);

        return id;
    }


    void putRequestData(char * data, uint32_t id)
    {

        down(semBufId, NSLOTS);
        down(semBufId, ACCESS);        

        pool[iBuffer].text = strdup(data);
        pool[iBuffer].id = id;

        iBuffer = iBuffer + 1 % FIFOSZ;
        cntBuffer++;

        up(semBufId, ACCESS);
        up(semBufId, NITEMS);
    }

    


}
