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

    struct FIFO
    {
        int semid;
        uint32_t ii;            ///< point of insertion
        uint32_t ri;            ///< point of retrieval
        uint32_t cnt;           ///< number of items stored
        uint32_t slot[FIFOSZ];       ///< storage memory                
    };

    struct ITEM
    {
        int semid;
        uint32_t id;            ///< id of the consumer
        char text[129];         ///< storage memory
        int len;
        int num_letters;
        int num_digits;
    };

    struct SharedAll {
        FIFO* fifos[2];
        ITEM* pool[FIFOSZ];   
    };

    uint32_t allId = -1; 
    SharedAll* all = NULL;


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

    /* create a FIFO in shared memory, initialize it, and return its id */
    void create(void)
    {

        allId = pshmget(IPC_PRIVATE, sizeof(SharedAll), 0600 | IPC_CREAT | IPC_EXCL);
        all = (SharedAll*)pshmat(allId, NULL, 0);

        /* init fifo[0]*/
        uint32_t i;
        for (i = 0; i < FIFOSZ; i++)
        {
            all->fifos[0]->slot[i]= i;
        }
        all->fifos[0]->ii = all->fifos[0]->ri = 0;
        all->fifos[0]->cnt = 0;

        /* init fifo[1]*/
        uint32_t i;
        for (i = 0; i < FIFOSZ; i++)
        {
            all->fifos[1]->slot[i]= 99;
        }
        all->fifos[1]->ii = all->fifos[1]->ri = 0;
        all->fifos[1]->cnt = 0;

        /* init BUFFER */
        uint32_t i;
        for (i = 0; i < FIFOSZ; i++)
        {
            all->pool[i]->id = i;
            all->pool[i]->text = "NULL";
            all->pool[i]->len = 0;
            all->pool[i]->num_letters = 0;
            all->pool[i]->num_digits = 0;
        }

        /* create access, full and empty semaphores */
        for (size_t i = 0; i < FIFOSZ; i++)
        {
            all->pool[i]->semid = psemget(IPC_PRIVATE, 1, 0600 | IPC_CREAT | IPC_EXCL);
            up(all->pool[i]->semid, ACCESS);
        }

        for (size_t i = 0; i < 2; i++)
        {
            all->fifos[i]->semid = psemget(IPC_PRIVATE, 3, 0600 | IPC_CREAT | IPC_EXCL);
            for (i = 0; i < FIFOSZ; i++)
            {
                up(all->fifos[i]->semid, NSLOTS);
            }
            up(all->fifos[i]->semid, ACCESS);
        }

    }

    /* ************************************************* */

    void destroy()
    {
        /* detach shared memory from process addressing space */
        pshmdt(all);

        /* destroy the shared memory */
        pshmctl(allId, IPC_RMID, NULL);
    }

    /* ************************************************* */
    uint32_t getFreeBuffer()
    {
        
        down(FreeBuffers->semid, NITEMS);
        down(FreeBuffers->semid, ACCESS);

        uint32_t id = all->fifos[0]->slot[all->fifos[0]->ri].id;
        all->ri = (all->ri + 1) % FIFOSZ;
        all-> cnt--;
        
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
