#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

#define SA struct sockaddr
#define MAXLINE 1024
#define DEFAULT_UDP_PORT 5140

static char buf[MAXLINE+1];

int main(int argc, char **argv)
{
	int s, i, n, active=1;
	struct sockaddr_in sai, cai;
	SA *ca_ptr;
	int ca_len = 0;
	int udp_port = DEFAULT_UDP_PORT;

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
		n = recvfrom(s, buf, MAXLINE, 0, ca_ptr, &len);
		if (n > 0) buf[n] = 0;
	}
	close(s);

	return 0;
}
