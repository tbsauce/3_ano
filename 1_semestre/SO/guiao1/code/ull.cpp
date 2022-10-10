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
        Node *n;
        while(head != NULL)
        {
            n = head;
            head = head -> next;
            free((void*)n-> reg.name);
            delete n;
        }

    }

    /* ************************************************* */

    void load(const char *fname)
    {
        FILE* ptr;
        char* token;
        char str[129];
        char name[129];
        char* strPtr = str;
        char* namePtr = name;
        char* etpr;
        
        int i;
        int total = 0;
        uint32_t nmec;
        ptr = fopen(fname,"r");    

        if(ptr == NULL) {
            printf("file can't be opened");
            exit(1);
        }

        while(!feof(ptr)) {
            total++;
            i = 0;
            fgets(strPtr,129,ptr);
            //printf("%s\n", strPtr);
            token = strtok(strPtr, ";");
            while(token != NULL) {
                //printf("%s\n", token);
                if(i%2 == 0) {
                    namePtr = token;
                } else {
                    //printf("N MEC: %s\n", token);
                    nmec = strtoul(token, &etpr, 10);
                }
                token = strtok (NULL, ";");
                i++;
            }
            insert(nmec, namePtr);
        }
        printf("Total: %u", total);
        fclose(ptr);
    }

    /* ************************************************* */

    void print()
    {
        Node *n;
        if(head == NULL) {
            printf("List is empty \n");
        } else {
            n = head;
            while(n != NULL)
            {
                printf("%s -> %d\n", n-> reg.name, n-> reg.nmec);
                n = n -> next;
            }
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
            n -> next = head;
            head = n;
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
