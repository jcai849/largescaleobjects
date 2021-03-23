#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <error.h>

#define SA struct sockaddr
#define MAX_LINE 1024
#define MAX_CHUNKS 1024
#define MAX_DIGITS 4
#define MAX_WORKERS 16
#define OP_LEN 3
#define DEFAULT_UDP_PORT 5140

typedef struct {
	int desc;
	int nChunks;
	int chunks[MAX_CHUNKS];
	char state[OP_LEN+1+MAX_DIGITS+1];
} Worker;
typedef struct {
	int nWorkers;
	Worker workers[MAX_WORKERS];
} Model;

int getulog(int udp_port);
Worker *findWorker(int w);
void fillModel(void);
void getOp(char *op);
void getArgs(int *args);
void addWorker(int w);
void setState(char *action, int w, int c);
void waiting(int w);
void showModel(void);
void save(int w, int c);

static Model model;
static char buf[MAX_LINE+1];

int main(int argc, char **argv)
{
	getulog(DEFAULT_UDP_PORT);

	return 0;
}

int getulog(int udp_port)
{
	int s, i, n, active=1;
	struct sockaddr_in sai, cai;
	SA *ca_ptr;
	int ca_len = 0;

	s = socket(AF_INET, SOCK_DGRAM, 0);
	if (s == -1) { perror("ERROR: failed to open socket"); return 1; };

        int optval = 1;
        setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (const void *)&optval , sizeof(int));
        bzero(&sai, sizeof(sai));
        sai.sin_family = AF_INET;
        sai.sin_addr.s_addr = htonl(INADDR_ANY);
        sai.sin_port = htons(udp_port);
        ca_ptr = (SA*) &cai;
        ca_len = sizeof(cai);
        i = bind(s, (SA*)&sai, sizeof(sai));

	if (i == -1) { perror("ERROR: failed to bind socket"); return 2; };
	while (active) {
		socklen_t len = ca_len;
		n = recvfrom(s, buf, MAX_LINE, 0, ca_ptr, &len);
		if (n > 0) buf[n] = 0;
		fillModel();
	}
	close(s);

	return 0;
}

void fillModel(void)
{
	char op[OP_LEN+1];
	int args[2];

	getOp(op);
	getArgs(args);
	switch(op[0]) {
		case 'C': /* CON X - New worker connected */
			addWorker(args[0]);
			break;
		case 'R': /* RCV X Y - Receiving at worker X, chunk Y */
			setState("RCV", args[0], args[1]);
			break;
		case 'S': /* SVD X Y - Saving at worker X, chunk Y */
			setState("SVD", args[0], args[1]);
			save(args[0], args[1]);
			break;
		case 'W':
			switch(op[1]) {
				case 'R': /* WRK X Y - Working at worker X on chunk Y */
					setState("WRK", args[0], args[1]);
					break;
				case 'T': /* WTQ X - Waiting on queues at worker X */
					waiting(args[0]);
					break;
				default: 
					error(1, 0, "Operation not recognised");
					exit(1);
			}
			break;
		default: 
			error(1, 0, "Operation not recognised");
			exit(1);
	}
	showModel();
}

void getOp(char *op)
{
	char s[MAX_LINE+1];
	char *opLoc;
	int i;

	strcpy(s, buf);
	opLoc = strtok(s, " ");
	for (i = 0; i < 7; i++) {
		opLoc = strtok(NULL, " ");
	}
	strcpy(op, opLoc);
}
void getArgs(int *args)
{
	char *argaLoc, *argbLoc;
	int i;
	char s[MAX_LINE+1];

	strcpy(s, buf);
	argaLoc = strtok(s, " ");
	for (i = 0; i < 8; i++) {
		argaLoc = strtok(NULL, " ");
	}
	args[0] = atoi(argaLoc);

	argbLoc = strtok(NULL, " ");
	if (argbLoc != NULL) {
		args[1] = atoi(argbLoc);
	}
}

void addWorker(int w)
{
	Worker worker;

	worker.desc = w;
	worker.nChunks = 0;
	strcpy(worker.state, "BGN");
	model.workers[model.nWorkers] = worker;
	model.nWorkers++;

}
void setState(char *action, int w, int c)
{
	Worker *worker;
	worker = findWorker(w);
	sprintf(worker->state, "%s %d", action, c);
}
void waiting(int w)
{
	Worker *worker;
	worker = findWorker(w);
	strcpy(worker->state, "WTQ");
}

void save(int w, int c)
{
	Worker *worker;
	worker = findWorker(w);
	worker->chunks[worker->nChunks] = c;
	worker->nChunks++;
}

Worker *findWorker(int w)
{
	int i;
	for (i = 0; i < model.nWorkers; i++) {
		if (model.workers[i].desc == w) {
			return &model.workers[i];
		}
	}
	error(1, 0, "Worker not found");
	exit(1);
}

void showModel(void)
{
	int i, j;

	printf("\e[1;1H\e[2J");
	for (i = 0; i < model.nWorkers; i++) {
		printf("Worker %d\n\tState: %s\n\tChunks held:",
				model.workers[i].desc, model.workers[i].state);
			for (j = 0; j < model.workers[i].nChunks; j++) {
				printf(" %d", model.workers[i].chunks[j]);
			}
		printf("\n");
	}
}
