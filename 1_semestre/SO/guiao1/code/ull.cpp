/*
 *
 * \author (2016) Artur Pereira <artur at ua.pt>
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#include <iostream>
#include <fstream> 
using namespace std;
#include "ull.h"

namespace ull
{
    /* ************************************************* */

    /* The information support data structure  */
    struct Register
    {
        uint32_t nmec;       //!< student number
        const char *name;    //!< student name
    };

    /* The linked-list support data structure */
    struct Node 
    {
        Register reg;
        struct Node *next;
    };

    static Node *head = NULL;

    /* ************************************************* */

    void reset()
    {
        Node *n = head;
        while(n != NULL)
        {
            Node *next = n -> next;
            free((void*)n-> reg.name);
            delete n; 
            n = next;
        }

    }

    /* ************************************************* */

    void load(const char *fname)
    {
        
    }

    /* ************************************************* */

    void print()
    {
        Node *n = head;
        while(n != NULL)
        {
            printf("%s -> %d\n", n-> reg.name, n-> reg.nmec);
            n = n -> next;
        }
    }

    /* ************************************************* */

    void insert(uint32_t nmec, const char *name)
    {
        Node *n = new Node();
        n -> reg.nmec = nmec;
        n -> reg.name = strdup(name);
        //(*n).reg.nmec = nmec;

        Node *previous = NULL;
        Node *curr = head;
        while(curr != NULL && curr->reg.nmec < nmec)
        {
            previous = curr;
            curr = curr -> next;
        }

        if(previous == NULL)
        {
            head = n;
        }
        else if(curr == NULL)
        {
            head -> next = n;
        }
        else
        {
            n -> next = curr;
            previous -> next = n;
        }
    }

    /* ************************************************* */

    const char *query(uint32_t nmec)
    {
        Node *n = head;   
        while(n -> reg.nmec != nmec)
        {
            n = n -> next;
        }
        return n-> reg.name;
    }

    /* ************************************************* */

    void remove(uint32_t nmec)
    {
        assert (query(nmec) != NULL);

        Node *previous = NULL;
        Node *curr = head;
        while(curr -> reg.nmec != nmec)
        {
            previous = curr;
            curr = curr -> next;
        }

        previous -> next = curr -> next;

        free((void*)curr-> reg.name);
        delete curr;
    }

    /* ************************************************* */

}
