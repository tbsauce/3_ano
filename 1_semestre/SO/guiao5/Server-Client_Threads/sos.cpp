/*
 *  \brief SoS: Statistics on Strings, a simple client-server application
 *    that computes some statistics on strings
 *
 * \author (2022) Artur Pereira <artur at ua.pt>
 * \author (2022) Miguel Oliveira e Silva <mos at ua.pt>
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <errno.h>
#include <stdint.h>

#include <new>

#include "sos.h"

#include "dbc.h"
#include "thread.h"

namespace sos
{
    /** \brief Number of transaction buffers */
    #define  NBUFFERS         5

    /** \brief indexes for the fifos of free buffers and pending requests */
    enum { FREE_BUFFER=0, PENDING_REQUEST };

    /** \brief interaction buffer data type */
    struct BUFFER 
    {
        char req[MAX_STRING_LEN+1];
        Response resp;
        pthread_cond_t done_rep;
        pthread_mutex_t access;
        int done = 0;
    };

    /** \brief the fifo data type to store indexes of buffers */
    struct FIFO
    {
        pthread_mutex_t access;
        pthread_cond_t notFull;
        pthread_cond_t notEmpty;
        uint32_t ii;               ///< point of insertion
        uint32_t ri;               ///< point of retrieval
        uint32_t cnt;              ///< number of items stored
        uint32_t tokens[NBUFFERS]; ///< storage memory
    };

    /** \brief the data type representing all the shared area.
     *    Fifo 0 is used to manage tokens of free buffers.
     *    Fifo 1 is used to manage tokens of pending requests.
     */
    struct SharedArea
    {
        /* A fix number of transaction buffers */
        BUFFER pool[NBUFFERS];

        /* A fifo for tokens of free buffers and another for tokens with pending requests */
        FIFO fifo[2];
    };

    /** \brief pointer to shared area dynamically allocated */
    SharedArea *sharedArea = NULL;


    /* -------------------------------------------------------------------- */

    /* Allocate and init the internal supporting data structure,
     *   including all necessary synchronization resources
     */
    void open(void)
    {
#if __DEBUG__
        fprintf(stderr, "%s()\n", __FUNCTION__);
#endif

        require(sharedArea == NULL, "Shared area must not exist");

        sharedArea = (SharedArea*)malloc(sizeof(SharedArea));

        /* init fifo 0 (free buffers) */
        FIFO *fifo = &sharedArea->fifo[FREE_BUFFER];
        for (uint32_t i = 0; i < NBUFFERS; i++)
        {
            fifo->tokens[i] = i;
        }
        fifo->ii = fifo->ri = 0;
        fifo->cnt = NBUFFERS;

        /* init fifo 1 (pending requests) */
        fifo = &sharedArea->fifo[PENDING_REQUEST];
        for (uint32_t i = 0; i < NBUFFERS; i++)
        {
            fifo->tokens[i] = NBUFFERS; // used to check for errors
        }
        fifo->ii = fifo->ri = 0;
        fifo->cnt = 0;

        mutex_init(&sharedArea->fifo[FREE_BUFFER].access, NULL);
        cond_init(&sharedArea->fifo[FREE_BUFFER].notEmpty, NULL);
        cond_init(&sharedArea->fifo[FREE_BUFFER].notFull, NULL);
        mutex_init(&sharedArea->fifo[PENDING_REQUEST].access, NULL);
        cond_init(&sharedArea->fifo[PENDING_REQUEST].notEmpty, NULL);
        cond_init(&sharedArea->fifo[PENDING_REQUEST].notFull, NULL);

        for (uint32_t i = 0; i < NBUFFERS; i++)
        {
                mutex_init(&sharedArea->pool[i].access, NULL);
                cond_init(&sharedArea->pool[i].done_rep, NULL);

        }
        
    }

    /* -------------------------------------------------------------------- */

    /* Free all allocated synchronization resources and data structures */
    void destroy()
    {
        require(sharedArea != NULL, "sharea area must be allocated");

        /* 
         * TODO point
         * Destroy synchronization elements
         */

        /* 
         * TODO point
        *  Destroy the shared memory
        */

        /* nullify */
        sharedArea = NULL;
    }

    /* -------------------------------------------------------------------- */
    /* -------------------------------------------------------------------- */

    /* Insertion a token into a fifo */
    static void fifoIn(uint32_t idx, uint32_t token)
    {
#if __DEBUG__
        fprintf(stderr, "%s(idx: %u, token: %u)\n", __FUNCTION__, idx, token);
#endif

        mutex_lock(&sharedArea->fifo[idx].access);

        require(idx == FREE_BUFFER or idx == PENDING_REQUEST, "idx is not valid");
        require(token < NBUFFERS, "token is not valid");
        while (sharedArea->fifo[idx].cnt == NBUFFERS)
        {
                cond_wait(&sharedArea->fifo[idx].notFull, &sharedArea->fifo[idx].access);
        }

        sharedArea->fifo[idx].tokens[sharedArea->fifo[idx].ii] = token;
        sharedArea->fifo[idx].ii = (sharedArea->fifo[idx].ii + 1) % NBUFFERS;
        sharedArea->fifo[idx].cnt++;

        cond_broadcast(&sharedArea->fifo[idx].notEmpty);
        mutex_unlock(&sharedArea->fifo[idx].access);
    }

    /* -------------------------------------------------------------------- */

    /* Retrieve a token from a fifo  */

    static uint32_t fifoOut(uint32_t idx)
    {
#if __DEBUG__
        fprintf(stderr, "%s(idx: %u)\n", __FUNCTION__, idx);
#endif

        mutex_lock(&sharedArea->fifo[idx].access);

        require(idx == FREE_BUFFER or idx == PENDING_REQUEST, "idx is not valid");
        while (sharedArea->fifo[idx].cnt == 0)
        {
                cond_wait(&sharedArea->fifo[idx].notEmpty, &sharedArea->fifo[idx].access);
        }
        uint32_t token = sharedArea->fifo[idx].tokens[sharedArea->fifo[idx].ri];
        sharedArea->fifo[idx].tokens[sharedArea->fifo[idx].ri] = NBUFFERS;
        sharedArea->fifo[idx].ri = (sharedArea->fifo[idx].ri + 1) % NBUFFERS;
        sharedArea->fifo[idx].cnt--;
        
        cond_broadcast(&sharedArea->fifo[idx].notFull);
        mutex_unlock(&sharedArea->fifo[idx].access);
        return token;
    }

    /* -------------------------------------------------------------------- */
    /* -------------------------------------------------------------------- */

    uint32_t getFreeBuffer()
    {
#if __DEBUG__
        fprintf(stderr, "%s()\n", __FUNCTION__);
#endif

        return fifoOut(FREE_BUFFER);
    }

    /* -------------------------------------------------------------------- */

    void putRequestData(uint32_t token, const char *data)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u, ...)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");
        require(data != NULL, "data pointer can not be NULL");

        *(sharedArea->pool[token].req) = *data;

    }

    /* -------------------------------------------------------------------- */

    void submitRequest(uint32_t token)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");

        fifoIn(PENDING_REQUEST, token);
    }

    /* -------------------------------------------------------------------- */

    void waitForResponse(uint32_t token)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");

        mutex_lock(&sharedArea->pool[token].access);
        while (sharedArea->pool[token].done != 1)
        {
                cond_wait(&sharedArea->pool[token].done_rep,&sharedArea->pool[token].access);
        }
        mutex_unlock(&sharedArea->pool[token].access);
    }

    /* -------------------------------------------------------------------- */

    void getResponseData(uint32_t token, Response *resp)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u, ...)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");
        require(resp != NULL, "resp pointer can not be NULL");

        resp = &sharedArea->pool[token].resp;
    }

    /* -------------------------------------------------------------------- */

    void releaseBuffer(uint32_t token)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");

        fifoIn(FREE_BUFFER, token);
        sharedArea->pool[token].done = 0;
    }

    /* -------------------------------------------------------------------- */
    /* -------------------------------------------------------------------- */

    uint32_t getPendingRequest()
    {
#if __DEBUG__
        fprintf(stderr, "%s()\n", __FUNCTION__);
#endif

        return fifoOut(PENDING_REQUEST);

    }

    /* -------------------------------------------------------------------- */

    void getRequestData(uint32_t token, char *data)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u, ...)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");
        require(data != NULL, "data pointer can not be NULL");

        *data = *sharedArea->pool[token].req;

    }

    /* -------------------------------------------------------------------- */

    void putResponseData(uint32_t token, Response *resp)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u, ...)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");
        require(resp != NULL, "resp pointer can not be NULL");

        sharedArea->pool[token].resp = *resp;

    }

    /* -------------------------------------------------------------------- */

    void notifyClient(uint32_t token)
    {
#if __DEBUG__
        fprintf(stderr, "%s(token: %u)\n", __FUNCTION__, token);
#endif

        require(token < NBUFFERS, "token is not valid");
        mutex_lock(&sharedArea->pool[token].access);
        sharedArea->pool[token].done = 1;
        cond_broadcast(&sharedArea->pool[token].done_rep);
        mutex_unlock(&sharedArea->pool[token].access);
    }

    /* -------------------------------------------------------------------- */

}
