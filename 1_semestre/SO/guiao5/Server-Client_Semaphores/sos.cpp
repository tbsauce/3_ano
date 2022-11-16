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
#include "process.h"

namespace sos
{
    /** \brief Number of transaction buffers */
    #define  NBUFFERS         5

    /* index of access, full and empty semaphores */
    #define ACCESS 0
    #define NITEMS 1
    #define NSLOTS 2

    /** \brief indexes for the fifos of free buffers and pending requests */
    enum { FREE_BUFFER=0, PENDING_REQUEST };

    /** \brief interaction buffer data type */
    struct BUFFER 
    {
        int semId;
        char req[MAX_STRING_LEN+1];
        Response resp;
    };

    /** \brief the fifo data type to store indexes of buffers */
    struct FIFO
    {
        int semId;
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
    uint32_t sharedId = -1;


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

        sharedId = pshmget(IPC_PRIVATE, sizeof(sharedArea), 0600| IPC_CREAT | IPC_EXCL);
        sharedArea = (SharedArea *)pshmat(sharedId, NULL, 0);

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

        //Fifo synchronization

            sharedArea->fifo[1].semId =  psemget(IPC_PRIVATE, 3, 0600 | IPC_CREAT | IPC_EXCL);
            sharedArea->fifo[0].semId =  psemget(IPC_PRIVATE, 3, 0600 | IPC_CREAT | IPC_EXCL);

            for (size_t i = 0; i < NBUFFERS; i++)
            {
                    psem_up(sharedArea->fifo[1].semId, NSLOTS);
                    psem_up(sharedArea->fifo[0].semId, NITEMS);
            }

            psem_up(sharedArea->fifo[0].semId, ACCESS);
            psem_up(sharedArea->fifo[1].semId, ACCESS);

        

        //Buffer synchronization
        for (size_t i = 0; i < NBUFFERS; i++)
        {
            sharedArea->pool[i].semId = psemget(IPC_PRIVATE, 1, 0600 | IPC_CREAT | IPC_EXCL);
        }
        
        
        
    }

    /* -------------------------------------------------------------------- */

    /* Free all allocated synchronization resources and data structures */
    void destroy()
    {
        require(sharedArea != NULL, "sharea area must be allocated");

        psemctl(sharedArea->fifo[0].semId, 0, IPC_RMID, NULL);
        psemctl(sharedArea->fifo[1].semId, 0, IPC_RMID, NULL);
        for (size_t i = 0; i < NBUFFERS; i++)
        {
            psemctl(sharedArea->pool[i].semId, 0 , IPC_RMID, NULL);
        }

        pshmdt(sharedArea);
        pshmctl(sharedId, IPC_RMID, NULL);

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

        require(idx == FREE_BUFFER or idx == PENDING_REQUEST, "idx is not valid");
        require(token < NBUFFERS, "token is not valid");


        psem_down(sharedArea->fifo[idx].semId, NSLOTS);
        psem_down(sharedArea->fifo[idx].semId, ACCESS);
        
        sharedArea->fifo[idx].tokens[sharedArea->fifo[idx].ii] = token;
        sharedArea->fifo[idx].ii = (sharedArea->fifo[idx].ii + 1) % NBUFFERS;
        sharedArea->fifo[idx].cnt++;

        psem_up(sharedArea->fifo[idx].semId, ACCESS);
        psem_up(sharedArea->fifo[idx].semId, NITEMS);
    }

    /* -------------------------------------------------------------------- */

    /* Retrieve a token from a fifo  */

    static uint32_t fifoOut(uint32_t idx)
    {
#if __DEBUG__
        fprintf(stderr, "%s(idx: %u)\n", __FUNCTION__, idx);
#endif

        require(idx == FREE_BUFFER or idx == PENDING_REQUEST, "idx is not valid");


        psem_down(sharedArea->fifo[idx].semId, NITEMS);
        psem_down(sharedArea->fifo[idx].semId , ACCESS);

        uint32_t token = sharedArea->fifo[idx].tokens[sharedArea->fifo[idx].ri];
        sharedArea->fifo[idx].tokens[sharedArea->fifo[idx].ri] = NBUFFERS;
        sharedArea->fifo[idx].ri = (sharedArea->fifo[idx].ri + 1) % NBUFFERS;
        sharedArea->fifo[idx].cnt--;

        psem_up(sharedArea->fifo[idx].semId, ACCESS);
        psem_up(sharedArea->fifo[idx].semId, NSLOTS);

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

        psem_down(sharedArea->pool[token].semId, ACCESS);

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


        psem_up(sharedArea->pool[token].semId, ACCESS);
        
    }

    /* -------------------------------------------------------------------- */

}
