//
// Created by xc5 on 13/7/2018.
//

#ifndef CLICKHOUSE_ECHO_H
#define CLICKHOUSE_ECHO_H

extern int set_fd_nonblock(int fd);
extern int create_tcp_sock();
extern void echo(void *arg);
extern int echo_server(int port);
extern int fecho_startserver(int a, char **b);
extern int fstack_set_fd_nonblock(int fd);
extern int fecho_startserver_string(std::vector<std::string> args);
extern bool usingFstack_POCO;
#endif //CLICKHOUSE_ECHO_H
