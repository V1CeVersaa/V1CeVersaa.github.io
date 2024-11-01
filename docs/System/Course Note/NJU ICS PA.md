# NJU ISC PA

## PA0

### 1 

第一个报错：

```shell
src/monitor/sdb/sdb.c:18:10: fatal error: readline/readline.h: No such file or directory
   18 | #include <readline/readline.h>
      |          ^~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make: *** [/home/mosen/ics2023/nemu/scripts/build.mk:34: /home/mosen/ics2023/nemu/build/obj-riscv32-nemu-interpreter/src/monitor/sdb/sdb.o] Error 1
```

解决方法：

```Shell
sudo apt install libreadline-dev
```