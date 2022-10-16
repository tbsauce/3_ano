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

#include  "fifo.h"
#include "delays.h"
#include "process.h"

namespace fifo
{
    int fifoId = -1;
    FIFO *fifo = NULL;

    /* ************************************************* */

    /* index of access, full and empty semaphores */
    #define ACCESS 0
    #define NITEMS 1
    #define NpoolS 2

    /* ************************************************* */

    /* create a FIFO in shared memory, initialize it, and return its id */
    FIFO* create(void)
    {
        /* create the shared memory */
        fifoId = pshmget(IPC_PRIVATE, sizeof(FIFO), 0600 | IPC_CREAT | IPC_EXCL);

        /*  attach shared memory to process addressing space */
        fifo = (FIFO*)pshmat(fifoId, NULL, 0);

        /* init fifo */
        uint32_t i;
        for (i = 0; i < FIFOSZ; i++)
        {
            fifo->pool[i].id = i;
            fifo->pool[i].text = "";
            fifo->pool[i].num_characters = 99;
            fifo->pool[i].num_digits = 99;
            fifo->pool[i].num_letters = 99;
        }
        fifo->ii = fifo->ri = 0;
        fifo->cnt = 0;

        /* create access, full and empty semaphores */
        fifo->semid = psemget(IPC_PRIVATE, 3, 0600 | IPC_CREAT | IPC_EXCL);

        /* init semaphores */
        for (i = 0; i < FIFOSZ; i++)
        {
            psem_up(fifo->semid, NpoolS);
        }
        psem_up(fifo->semid, ACCESS);

        return fifo;
        
    }

    /* ************************************************* */

    void destroy(FIFO* fifo)
    {
        /* detach shared memory from process addressing space */
        pshmdt(fifo);

        /* destroy the shared memory */
        pshmctl(fifoId, IPC_RMID, NULL);
    }

    /* ************************************************* */

    /* Insertion of a pair <id, value> into the FIFO  */
    void in(FIFO * fifo, uint32_t id)
    {
        /* decrement emptiness, blocking if necessary, and lock access */
        psem_down(fifo->semid, NpoolS);
        psem_down(fifo->semid, ACCESS);

        /* Insert pair */
        fifo->pool[fifo->ii].id = id;
        fifo->ii = (fifo->ii + 1) % FIFOSZ;
        fifo->cnt++;

        /* unlock access and increment fullness */
        psem_up(fifo->semid, ACCESS);
        psem_up(fifo->semid, NITEMS);
    }

    /* ************************************************* */

    /* Retrieval of a pair <id, value> from the FIFO */

    void out (FIFO * fifo, uint32_t * idp, BUFFER buf)
    {
        /* decrement fullness, blocking if necessary, and lock access */
        psem_down(fifo->semid, NITEMS);
        psem_down(fifo->semid, ACCESS);

        /* Retrieve pair */
        buf = fifo->pool[fifo->ri]; 
        fifo->pool[fifo->ri].text = "";
        fifo->pool[fifo->ri].num_characters = 99;
        fifo->pool[fifo->ri].num_digits = 99;
        fifo->pool[fifo->ri].num_letters = 99;
        *idp = fifo->pool[fifo->ri].id;
        fifo->pool[fifo->ri].id = 99;
        fifo->ri = (fifo->ri + 1) % FIFOSZ;
        fifo->cnt--;

        /* unlock access and increment fullness */
        psem_up(fifo->semid, ACCESS);
        psem_up(fifo->semid, NpoolS);
    }

    /* ************************************************* */

}
