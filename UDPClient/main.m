//
//  main.m
//  UDPClient
//
//  Created by Matthew Lintlop on 12/5/17.
//  Copyright © 2017 Matthew Lintlop. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUFLEN 512
#define NPACK 10
#define PORT 9930

#define SRV_IP "::1"

void diep(char *s) {
    perror(s);
    exit(1);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        struct sockaddr_in6 si_other;
        int s, i, slen=sizeof(si_other);
        char buf[BUFLEN];

        if ((s=socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP))==-1)
            diep("socket");

        memset((char *) &si_other, 0, sizeof(si_other));
        si_other.sin6_family = AF_INET6;
        si_other.sin6_port = htons(PORT);
        if (inet_pton(AF_INET6, SRV_IP, &si_other.sin6_addr)==0) {
            fprintf(stderr, "inet_aton() failed\n");
            exit(1);
        }

        for (i=0; i<NPACK; i++) {
            printf("Sending packet %d\n", i);
            sprintf(buf, "This is packet %d\n", i);
            if (sendto(s, buf, BUFLEN, 0, &si_other, slen)==-1)
                diep("sendto()");
        }

        close(s);
    }
    return 0;
}
