/*
 *  \author ...
 */

#include "somm22.h"
#include "peq_module.h"

namespace somm22
{

    namespace group 
    {
        static void internalPrint(FILE* fp) {
            const char* firstLine = "+===============================+\n"
                                    "|      Process Event Queue      |\n"
                                    "+-----------+-----------+-------+\n"
                                    "| eventTime | eventType |  PID  |\n"
                                    "+-----------+-----------+-------+\n";
            fprintf(fp, "%s", firstLine);

            std::list<Event>::iterator it;
            for (it = peq::event_queue.begin(); it != peq::event_queue.end(); it++){
                Event aux = (Event) *it;
                fprintf(fp, "| %9u | %-9s | %5u |\n", aux.eventTime, peqEventTypeAsString(aux.eventType), aux.pid);
            }

            const char* lastLine = "+===============================+\n\n";
            fprintf(fp, "%s",lastLine);
        }
 
// ================================================================================== //

        void peqLog()
        {
            soProbe(302, "%s()\n", __func__);

            FILE* fout = logGetStream();
            internalPrint(fout);
        }

// ================================================================================== //

        void peqLogEvent(Event *e, const char *msg = "Event")
        {
            soProbe(302, "%s(...)\n", __func__);

            logEvent(e->pid, e->eventTime, e->eventType);
            logPrint(msg);
        }

// ================================================================================== //

        void peqPrint(const char *fname, PrintMode mode)
        {
            soProbe(302, "%s(\"%s\", %s)\n", __func__, fname, (mode == NEW) ? "NEW" : "APPEND");

            FILE* fpout;
            if(mode == NEW)
            {
                fpout = fopen(fname, "w");
            }
            else if (mode == APPEND)
            {
                fpout = fopen(fname, "a");
            }

            internalPrint(fpout);
        }

// ================================================================================== //

    } // end of namespace group

} // end of namespace somm22

