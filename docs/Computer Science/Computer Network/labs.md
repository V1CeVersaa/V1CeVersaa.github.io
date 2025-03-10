# CS144 Lab Record

## Lab Checkpoint 0: Warmup

### Section 2.1: Fetch a Web page

```bash
cs144@cs144vm:~$telnet cs144.keithw.org http
Trying 104.196.238.229...
Connected to cs144.keithw.org.
Escape character is '^]'.
GET /lab0/sunetid HTTP/1.1
Host: cs144.keithw.org
Connection: close

HTTP/1.1 200 OK
Date: Thu, 06 Mar 2025 03:48:11 GMT
Server: Apache
X-You-Said-Your-SunetID-Was: sunetid
X-Your-Code-Is: 255202
Content-length: 111
Vary: Accept-Encoding
Connection: close
Content-Type: text/plain

Hello! You told us that your SUNet ID was "sunetid". Please see the HTTP headers (above) for your secret code.
Connection closed by foreign host.
```

### Section 2.2: Send yourself an email

没有 Stanford 的邮箱，不做了。

### Section 2.3: Listening and connecting

Client 端：

```bash 
cs144@cs144vm:~$ telnet localhost 9090
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
asdasd
131231231
Connection closed by foreign host.
```

Server 端：

```bash
cs144@cs144vm:~$ netcat -v -l -p 9090
Listening on 0.0.0.0 9090
Connection received on localhost 51964
asdasd
131231231
^C
```

### Section 3: Writing a network program using an OS stream socket



