# linux-tips :: networking

http://superuser.com/questions/621870/test-if-a-port-on-a-remote-system-is-reachable-without-telnet/622641#622641

Bash has been able to access TCP and UDP ports for a while. From the man page:

```
/dev/tcp/host/port
    If host is a valid hostname or Internet address, and port is an integer port number
    or service name, bash attempts to open a TCP connection to the corresponding socket.
/dev/udp/host/port
    If host is a valid hostname or Internet address, and port is an integer port number
    or service name, bash attempts to open a UDP connection to the corresponding socket.
```

So you could use something like this:
```
xenon-lornix:~> cat < /dev/tcp/127.0.0.1/22
SSH-2.0-OpenSSH_6.2p2 Debian-6
^C pressed here
```
Taa Daa!

OR...

Netcat is a useful tool:
```
nc 127.0.0.1 123 &> /dev/null; echo $?
```
Will output 0 if port 123 is open, and 1 if it's closed.


OR...

Nice and verbose! From the man pages. 
Single port:
```
nc -zv 127.0.0.1 80
```
Multiple ports:
```
nc -zv 127.0.0.1 22 80 8080
```
Range of ports:
```
nc -zv 127.0.0.1 20-30
```