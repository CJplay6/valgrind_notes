# valgrind_notes

<br/>

## 描述
- 本文档是简单介绍valgrind内存检查工具.
- Valgrind是一个GPL的软件，用于Linux（For x86, amd64 and ppc32）程序的内存调试和代码剖析。你可以在它的环境中运行你的程序来监视内存的使用情况，比如C 语言中的malloc和free或者 C++中的new和 delete。使用Valgrind的工具包，你可以自动的检测许多内存管理和线程的bug，避免花费太多的时间在bug寻找上，使得你的程序更加稳固。
- Valgrind工具包包含多个工具，如Memcheck,Cachegrind,Helgrind, Callgrind，Massif。下面分别介绍个工具的作用

<br/>


## 工具描述

### 1. Memcheck工具主要检查下面的程序错误:

* 使用未初始化的内存 (Use of uninitialised memory)
* 使用已经释放了的内存 (Reading/writing memory after it has been free’d)
* 使用超过 malloc分配的内存空间(Reading/writing off the end of malloc’d blocks)
* 对堆栈的非法访问 (Reading/writing inappropriate areas on the stack)
* 申请的空间是否有释放 (Memory leaks – where pointers to malloc’d blocks are lost forever)
* malloc/free/new/delete申请和释放内存的匹配(Mismatched use of malloc/new/new [] vs free/delete/delete [])
* src和dst的重叠(Ovsrc和dst的重叠(Overlapping src and dst pointers in memcpy() and related functions)erlapping src and dst pointers in memcpy() and related functions)

### 2. Callgrind工具描述:

* Callgrind收集程序运行时的一些数据，函数调用关系等信息，还可以有选择地进行cache模拟。在运行结束时，它会把分析数据写入一个文件。callgrind_annotate可以把这个文件的内容转化成可读的形式。

### 3. Cachegrind工具描述:

* 它模拟 CPU中的一级缓存I1,D1和L2二级缓存，能够精确地指出程序中 cache的丢失和命中。如果需要，它还能够为我们提供cache丢失次数，内存引用次数，以及每行代码，每个函数，每个模块，整个程序产生的指令数。这对优化程序有很大的帮助。

### 4. Helgrind工具描述

* 它主要用来检查多线程程序中出现的竞争问题。Helgrind寻找内存中被多个线程访问，而又没有一贯加锁的区域，这些区域往往是线程之间失去同步的地方，而且会导致难以发掘的错误。Helgrind实现了名为” Eraser” 的竞争检测算法，并做了进一步改进，减少了报告错误的次数。

### 5. Massif工具描述

* 堆栈分析器，它能测量程序在堆栈中使用了多少内存，告诉我们堆块，堆管理块和栈的大小。
* Massif能帮助我们减少内存的使用，在带有虚拟内存的现代系统中，它还能够加速我们程序的运行，减少程序停留在交换区中的几率。

<br/>


## 安装

```
http://valgrind.org/downloads/current.html
源码下载
http://valgrind.org/docs/manual/manual.html
文档

tar jxvf valgrind-3.14.0.tar.bz2

cd valgrind-3.14.0/

./autogen.sh

./configure --prefix=/home/renz/rz/opt/valgrind

make

make install
```

<br/>

## 应用

### 1. 检查内存错误

```
例如我们原来有一个程序sec_infod，这是一个用gcc –g参数编译的程序，运行它需要：

#./a.out

如果我们想用valgrind的内存检测工具，我们就要用如下方法调用：

#valgrind --leak-check=full --show-reachable=yes --trace-children= yes   ./a.out

其中--leak-check=full指的是完全检查内存泄漏，--show-reachable=yes是显示内存泄漏的地点，--trace-children=yes是跟入子进程。

如果您的程序是会正常退出的程序，那么当程序退出的时候valgrind自然会输出内存泄漏的信息。如果您的程序是个守护进程，那么也不要紧，我们 只要在别的终端下杀死memcheck进程（因为valgrind默认使用memcheck工具，就是默认参数—tools=memcheck）：

#killall memcheck

这样我们的程序（./a.out）就被kill了
————————————————
版权声明：本文为CSDN博主「andylauren」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/andylauren/article/details/93189740
```

### 2. 检查代码覆盖和性能瓶颈

```
我们调用valgrind的工具执行程序：

#valgrind --tool=callgrind ./sec_infod

会在当前路径下生成callgrind.out.pid（当前生产的是callgrind.out.19689），如果我们想结束程序，可以：

#killall callgrind

然后我们看一下结果：

#callgrind_annotate --auto=yes callgrind.out.19689   >log

#vim log
————————————————
版权声明：本文为CSDN博主「andylauren」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/andylauren/article/details/93189740
```

<br/>

## 用法

### 1. 概要用法

        valgrind [[valgrind] [options]] [your-program] [[your-program-options]]

一般像下面这样调用Valgrind:

        valgrind program args

这样将在Valgrind使用Memcheck运行程序program(带有参数args)。内存检查执行一系列的内存检查功能，包括检测访问未初始化的内存，已经分配内存的错误使用(两次释放，释放后再访问，等等)并检查内存泄漏。

可用--tool指定使用其它工具：

valgrind --tool=toolname program args


<br/>

## 可使用的工具如下:

cachegrind是一个缓冲模拟器。它可以用来标出你的程序每一行执行的指令数和导致的缓冲不命中数。

callgrind在cachegrind基础上添加调用追踪。它可以用来得到调用的次数以及每次函数调用的开销。作为对cachegrind的补充，callgrind可以分别标注各个线程，以及程序反汇编输出的每条指令的执行次数以及缓存未命中数。

helgrind能够发现程序中潜在的条件竞争。

lackey是一个示例程序，以其为模版可以创建你自己的工具。在程序结束后，它打印出一些基本的关于程序执行统计数据。

massif是一个堆剖析器，它测量你的程序使用了多少堆内存。

memcheck是一个细粒度的的内存检查器。

none没有任何功能。它一般用于Valgrind的调试和基准测试。

<br/>


## 基本选项：这些选项对所有工具都有效。

-h --help

显示所有选项的帮助，包括内核和选定的工具两者。

--help-debug

和--help相同，并且还能显示通常只有Valgrind的开发人员使用的调试选项。

--version

显示Valgrind内核的版本号。工具可以有他们自已的版本号。这是一种保证工具只在它们可以运行的内核上工作的一种设置。这样可以减少在工具和内核之间版本兼容性导致奇怪问题的概率。

-q --quiet

安静的运行，只打印错误信息。在进行回归测试或者有其它的自动化测试机制时会非常有用。

-v --verbose

显示详细信息。在各个方面显示你的程序的额外信息，例如：共享对象加载，使用的重置，执行引擎和工具的进程，异常行为的警告信息。重复这个标记可以增加详细的级别。

-d

调试Valgrind自身发出的信息。通常只有Valgrind开发人员对此感兴趣。重复这个标记可以产生更详细的输出。如果你希望发送一个bug报告，通过-v -v -d -d生成的输出会使你的报告更加有效。

--tool= [default: memcheck]

运行toolname指定的Valgrind，例如，Memcheck, Addrcheck, Cachegrind,等等。

--trace-children= [default: no]

当这个选项打开时，Valgrind会跟踪到子进程中。这经常会导致困惑，而且通常不是你所期望的，所以默认这个选项是关闭的。

--track-fds= [default: no]

当这个选项打开时，Valgrind会在退出时打印一个打开文件描述符的列表。每个文件描述符都会打印出一个文件是在哪里打开的栈回溯，和任何与此文件描述符相关的详细信息比如文件名或socket信息。

--time-stamp= [default: no]

当这个选项打开时，每条信息之前都有一个从程序开始消逝的时间，用天，小时，分钟，秒和毫秒表示。

--log-fd= [default: 2, stderr]

指定Valgrind把它所有的消息都输出到一个指定的文件描述符中去。默认值2,　是标准错误输出(stderr)。注意这可能会干扰到客户端自身对stderr的使用, Valgrind的输出与客户程序的输出将穿插在一起输出到stderr。

--log-file=

指定Valgrind把它所有的信息输出到指定的文件中。实际上，被创建文件的文件名是由filename、'.'和进程号连接起来的（即.），从而每个进程创建不同的文件。

--log-file-exactly=

类似于--log-file，但是后缀".pid"不会被添加。如果设置了这个选项，使用Valgrind跟踪多个进程，可能会得到一个乱七八糟的文件。

--log-file-qualifier=

当和--log-file一起使用时，日志文件名将通过环境变量$VAR来筛选。这对于MPI程序是有益的。更多的细节，查看手册2.3节 "注解"。

--log-socket=

指定Valgrind输出所有的消息到指定的IP，指定的端口。当使用1500端口时，端口有可能被忽略。如果不能建立一个到指定端口的连接，Valgrind将输出写到标准错误(stderr)。这个选项经常和一个Valgrind监听程序一起使用。更多的细节，查看手册2.3节 "注解"。

错误相关选项：这些选项适用于所有产生错误的工具，比如Memcheck,　但是Cachegrind不行。

--xml= [default: no]

当这个选项打开时，输出将是XML格式。这是为了使用Valgrind的输出做为输入的工具，例如GUI前端更加容易些。目前这个选项只在Memcheck时生效。

--xml-user-comment=

在XML开头 附加用户注释，仅在指定了--xml=yes时生效，否则忽略。

--demangle= [default: yes]

打开/关闭C++的名字自动解码。默认打开。当打开时，Valgrind将尝试着把编码过的C++名字自动转回初始状态。这个解码器可以处理g++版本为2.X,3.X或4.X生成的符号。

一个关于名字编码解码重要的事实是，禁止文件中的解码函数名仍然使用他们未解码的形式。Valgrind在搜寻可用的禁止条目时不对函数名解码，因为这将使禁止文件内容依赖于Valgrind的名字解码机制状态， 会使速度变慢，且无意义。

--num-callers= [default: 12]

默认情况下，Valgrind显示12层函数调用的函数名有助于确定程序的位置。可以通过这个选项来改变这个数字。这样有助在嵌套调用的层次很深时确定程序的位置。注意错误信息通常只回溯到最顶上的4个函数。(当前函数，和它的3个调用者的位置)。所以这并不影响报告的错误总数。

这个值的最大值是50。注意高的设置会使Valgrind运行得慢，并且使用更多的内存,但是在嵌套调用层次比较高的程序中非常实用。

--error-limit= [default: yes]

当这个选项打开时，在总量达到10,000,000，或者1,000个不同的错误，Valgrind停止报告错误。这是为了避免错误跟踪机制在错误很多的程序下变成一个巨大的性能负担。

--error-exitcode= [default: 0]

指定如果Valgrind在运行过程中报告任何错误时的退出返回值，有两种情况；当设置为默认值(零)时，Valgrind返回的值将是它模拟运行的程序的返回值。当设置为非零值时，如果Valgrind发现任何错误时则返回这个值。

在Valgrind做为一个测试工具套件的部分使用时这将非常有用，因为使测试工具套件只检查Valgrind返回值就可以知道哪些测试用例Valgrind报告了错误。

--show-below-main= [default: no]

默认地，错误时的栈回溯不显示main()之下的任何函数(或者类似的函数像glibc的__libc_start_main()，如果main()没有出现在栈回溯中)；这些大部分都是令人厌倦的C库函数。如果打开这个选项，在main()之下的函数也将会显示。

--suppressions= [default: $PREFIX/lib/valgrind/default.supp]

指定一个额外的文件读取不需要理会的错误；你可以根据需要使用任意多的额外文件。

--gen-suppressions= [default: no]

当设置为yes时，Valgrind将会在每个错误显示之后自动暂停并且打印下面这一行：

                  ---- Print suppression ? --- [Return/N/n/Y/y/C/c] ----

这个提示的行为和--db-attach选项(见下面)相同。

如果选择是，Valgrind会打印出一个错误的禁止条目，你可以把它剪切然后粘帖到一个文件，如果不希望在将来再看到这个错误信息。

当设置为all时，Valgrind会对每一个错误打印一条禁止条目，而不向用户询问。

这个选项对C++程序非常有用，它打印出编译器调整过的名字。

注意打印出来的禁止条目是尽可能的特定的。如果需要把类似的条目归纳起来，比如在函数名中添加通配符。并且，有些时候两个不同的错误也会产生同样的禁止条目，这时Valgrind就会输出禁止条目不止一次，但是在禁止条目的文件中只需要一份拷贝(但是如果多于一份也不会引起什么问题)。并且，禁止条目的名字像<在这儿输入一个禁止条目的名字>;名字并不是很重要，它只是和-v选项一起使用打印出所有使用的禁止条目记录。

--db-attach= [default: no]

当这个选项打开时，Valgrind将会在每次打印错误时暂停并打出如下一行：

                  ---- Attach to debugger ? --- [Return/N/n/Y/y/C/c] ----

按下回车,或者N、回车，n、回车，Valgrind不会对这个错误启动调试器。

按下Y、回车，或者y、回车，Valgrind会启动调试器并设定在程序运行的这个点。当调试结束时，退出，程序会继续运行。在调试器内部尝试继续运行程序，将不会生效。

按下C、回车，或者c、回车，Valgrind不会启动一个调试器，并且不会再次询问。

注意：--db-attach=yes与--trace-children=yes有冲突。你不能同时使用它们。Valgrind在这种情况下不能启动。

2002.05:这是一个历史的遗留物，如果这个问题影响到你，请发送邮件并投诉这个问题。

2002.11:如果你发送输出到日志文件或者到网络端口，我猜这不会让你有任何感觉。不须理会。

--db-command= [default: gdb -nw %f %p]

通过--db-attach指定如何使用调试器。默认的调试器是gdb.默认的选项是一个运行时扩展Valgrind的模板。 %f会用可执行文件的文件名替换，%p会被可执行文件的进程ID替换。

这指定了Valgrind将怎样调用调试器。默认选项不会因为在构造时是否检测到了GDB而改变,通常是/usr/bin/gdb.使用这个命令，你可以指定一些调用其它的调试器来替换。

给出的这个命令字串可以包括一个或多个%p %f扩展。每一个%p实例都被解释成将调试的进程的PID，每一个%f实例都被解释成要调试的进程的可执行文件路径。            

--input-fd= [default: 0, stdin]

使用--db-attach=yes和--gen-suppressions=yes选项，在发现错误时，Valgrind会停下来去读取键盘输入。默认地，从标准输入读取，所以关闭了标准输入的程序会有问题。这个选项允许你指定一个文件描述符来替代标准输入读取。

--max-stackframe= [default: 2000000]

栈的最大值。如果栈指针的偏移超过这个数量，Valgrind则会认为程序是切换到了另外一个栈执行。

如果在程序中有大量的栈分配的数组，你可能需要使用这个选项。

valgrind保持对程序栈指针的追踪。如果栈指针的偏移超过了这个数量，Valgrind假定你的程序切换到了另外一个栈，并且Memcheck行为与栈指针的偏移没有超出这个数量将会不同。通常这种机制运转得很好。然而，如果你的程序在栈上申请了大的结构，这种机制将会表现得愚蠢，并且Memcheck将会报告大量的非法栈内存访问。这个选项允许把这个阀值设置为其它值。

应该只在Valgrind的调试输出中显示需要这么做时才使用这个选项。在这种情况下，它会告诉你应该指定的新的阀值。

普遍地，在栈中分配大块的内存是一个坏的主意。因为这很容易用光你的栈空间，尤其是在内存受限的系统或者支持大量小堆栈的线程的系统上，因为Memcheck执行的错误检查，对于堆上的数据比对栈上的数据要高效很多。如果你使用这个选项，你可能希望考虑重写代码在堆上分配内存而不是在栈上分配。


<br/>


## 重点参数说明

### 1. --leak-check=full    -- 检查全部的堆栈
### 2. --tool=memcheck      -- 开启内存检查工具
### 3. --log-file=文件名     -- 将记录的日志记录到文件中

<br/>

## 自制脚本

### 1. 从valgrind生成的内存检测日志中提取出未初始化内存的信息

```
#!/bin/bash
version=1.0

if [ $# != 1 ]; then
    echo "need take valgrind log file!"
    echo "exmple:"
    # 这里的话, 后缀不是很重要
    echo "$0 xxx.valgrind"
fi

VALGRIND_STATIS_FILE=valgrind_statis_file
STATIS_UNINITIALISED_FILE=valgrind_uninitiased_statis.txt

DST_FOLDER=$VALGRIND_STATIS_FILE
DST_FOLDER="_"$(date +%Y%m%d%H%M%S)
DST_FILE=$DST_FOLDER/$STATIS_UNINITIALISED_FILE

mkdir $DST_FOLDER

echo 'uninitialised count:' >> $DST_FILE
cat $1 | grep uninitialised | wc -l >> $DST_FILE

echo 'uninitialised depth info:' >> $DST_FILE
cat $1 | grep 15876 | grep -A 10 'uninitialised' >> $DST_FILE
```


<br/>