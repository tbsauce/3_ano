/**
 * @file
 *
 * \brief A producer-consumer application, implemented using processes,
 *      and shared memory.
 *
 * \remarks The return status of the processes are ignored
 *
 * \author (2016-2022) Artur Pereira <artur at ua.pt>
 */

#include  <stdio.h>
#include  <stdlib.h>
#include  <libgen.h>
#include  <unistd.h>
#include  <sys/wait.h>
#include  <sys/types.h>
#include  <math.h>
#include <stdint.h>

#include  "fifo.h"
#include  "delays.h"
#include  "process.h"

/* ******************************************************* */

/* The shared memory is created before the producer and consumer processes
 * are launched, so after the forks its id is in all the created processes.
 * But, its address (the fifo variable) must be initialized in every process.
 */

/* ******************************************************* */

/* The producer process */
int producer(uint32_t idp)
{

    id = getPendingRequest();               /*take a buffer out of fifo of pending requests */  
    req = getRequestData(id);               /* take the request */
    resp = produceResponse(req);            /*produce a response */
    putResponseData(resp,id);               /*put response data on buffer */
    signatureResponseIsAvailable(id);       /* so client is waked up */
    //printf("Producer %u is quiting\n", id);
    exit(EXIT_SUCCESS);
}

/* ******************************************************* */

/* The consumer process */
int consumer(uint32_t idc, char * data)
{
    id = getFreeBuffer();                   /*take a buffer out of fifo of free buffers */
    putRequestData(data,id);                /*put request data on buffer */
    addNewPendingRequest(id);               /*add buffer to fifo of pending requests */
    waitForResponse(id);                    /*wait (blocked) until a response is available */
    resp = getResponseData (id);            /*take response out of buffer */
    releaseBuffer(id);                      /*buffer is free, so add it to fifo of free buffers */
    //printf("Consumer %u is quiting\n", id);
    exit(EXIT_SUCCESS);
}

int getFreeBuffer(){
    uint32_t id;
    BUFFER temp;
    fifo::out(fifo_FreeBuffers, &id, temp);
    pool[id] = temp;
    return id;
}

void putRequestData(char * text, uint32_t id ){
    pool[id].text = text;
}

void addNewPendingRequest( uint32_t id){
    fifo::in(fifo_PendingRequests, id);
}

/* ******************************************************* */

/* create FIFO */
    FIFO* fifo_FreeBuffers = fifo::create();

    FIFO* fifo_PendingRequests = fifo::create();

    BUFFER pool[10];

/* main process: it starts the simulation and launches the producer and consumer processes */
int main(int argc, char *argv[])
{
    uint32_t nproducers = 1;   ///< number of consumers and producers
    uint32_t nconsumers = 1;   ///< number of consumers and producers

    /* start random generator */
    srand(getpid());

    /* launching the consumers */
    int cpid[nconsumers];   /* consumers' ids */
    printf("Launching %d consumer processe!\n", nconsumers);
    for (uint32_t id = 0; id < nconsumers; id++)
    {
        if ((cpid[id] = pfork()) == 0)
        {
            consumer(id, data);
            exit(0);
        }
        else
        {
            printf("- Consumer process %d was launched\n", id);
        }
    }

    /* launching the producers */
    int ppid[nproducers];   /* producers' ids */
    printf("Launching %d producer processes, each performing %d iterations\n", nproducers, niter);
    for (uint32_t id = 0; id < nproducers; id++)
    {
        if ((ppid[id] = pfork()) == 0)
        {
            producer(id);
            exit(0);
        }
        else
        {
            printf("- Producer process %d was launched\n", id);
        }
    }

    /* wait for processes to conclude */
    for (uint32_t id = 0; id < nproducers; id++)
    {
        pid_t pid = pwaitpid(ppid[id], NULL, 0);
        printf("Producer %d (process %d) has terminated\n", id, pid);
    }
    for (uint32_t id = 0; id < nconsumers; id++)
    {
        pid_t pid = pwaitpid(cpid[id], NULL, 0);
        printf("Consumer %d (process %d) has terminated\n", id, pid);
    }

    /* destroy the shared memory */
    fifo::destroy();

    return EXIT_SUCCESS;
}

