#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

#define DEFAULT_UDP_PORT 5140
#define SA struct sockaddr

typedef struct connection {
	int s;
	struct sockaddr ca_ptr;
	socklen_t *len;
} connection;

int main(int argc, char **argv)
{
	char buf[BUFSIZ];
	connection conn;
	instructions instructs;
	systemstate sysstate;

	setup(conn);
loop:
	n = receive(conn, buf);
	instructs = deparse(buf);
	update(sysstate, instructs);
	display(sysstate);
GOTO loop;
	close(s);

	exit 0;
}

ssize_t receive(connection conn, char *buf) {
	ssize_t n;
	n = recvfrom(conn->s, buf, BUFSIZ, 0, conn->ca_ptr, &conn.len);
	if (n > 0) buf[n] = 0;
	return n;
}

connection setup(connection conn)
{
	int s, i;
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
        sai.sin_port = htons(DEFAULT_UDP_PORT);
        ca_ptr = (SA*) &cai;
        ca_len = sizeof(cai);
        i = bind(s, (SA*)&sai, sizeof(sai));
	socklen_t len = ca_len;

	if (i == -1) { perror("ERROR: failed to bind socket"); return 2; };
}

/* CON X - New worker connected */
/* RCV X Y - Receiving chunk Y at worker X */
/* SVD X Y - Saving chunk Y at worker X */
/* WRK X Y - Working on chunk Y at worker X */
/* WTQ X - Waiting on queues at worker X */
/* EXT X - Process exited at worker X */
/* DEL X Y - Deleting chunk Y at worker X */
