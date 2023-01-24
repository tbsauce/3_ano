#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "delays.h"
#include "process.h"

int main(void)
{
  printf("Before the fork: PID = %d, PPID = %d\n", getpid(), getppid());

  pid_t ret = pfork();
  if (ret == 0)
  {
    pid_t res = execl("./child","./child", NULL);
    if(res == -1)
    {
    	perror("Error launching child process");
    	exit(1);
    }
    //adicionei isto para apanhar o erro
    printf("why doesn't this message show up?\n");
    return EXIT_FAILURE;
  }
  else
  {
    printf("I'm the parent: PID = %d, PPID = %d\n", getpid(), getppid());
    usleep(20000);
    //esperar pelo filho
    pwait(NULL);
  }

  return EXIT_SUCCESS;
}
