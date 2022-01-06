---
title: "Java NIO"
date: 2021-11-29T20:11:38+08:00
weight: 999
toc: true
tags:
    - java
categories:
    - lang
---

## 1. 定义

**阻塞IO**：如果服务器线程池中有100个线程，现在有101个用户想要请求服务器的下载功能，那么只有其中的100个用户能够得到及时的服务，剩下一个人只能先等着，即使它只是想下载一个几KB的文件。

**非阻塞IO**：基于Reactor模式的工作方式，核心的Selector，本质是延迟IO操作。

| IO     | NIO            |
| ------ | -------------- |
| 面向流 | 面向缓冲区     |
| 阻塞IO | 非阻塞IO       |
| 无     | Selector选择器 |

1. Channel：与流的不同在于Channel是双向的，而流是单向的
2. Buffer：缓冲区
3. Selector：运行单线程处理多个Channel

## 2. Channel

位于缓冲区与另一侧实体（Socket，文件等）之间。

* 双向的
* 而且可以异步读写
* 通道中的数据总要先读到一个Buffer中，或者总要从一个Buffer中写入

FileChannel（文件）、DatagramChannel（UDP）、SocketChannel（客户端TCP）、ServerSockerChannel（服务器TCP）。

### 1. FileChannel

从文件读取内容，实例用法，如下所示。

```java
package xyz.seekwind.nio_demo;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class Application {
    public static void main(String[] args) throws IOException {
        RandomAccessFile aFile =
                new RandomAccessFile("./demo.txt", "rw");
        FileChannel channel = aFile.getChannel();
        ByteBuffer buf = ByteBuffer.allocate(1024);
        int bytesRead;
        // channel.read()方法读取数据到缓冲区
        while ((bytesRead = channel.read(buf)) != -1) {
            System.out.println("Read Length" + bytesRead);
            // 缓冲区读写方向反转
            buf.flip();
            // 缓冲区读取
            while (buf.hasRemaining()) {
                System.out.print((char) buf.get());
            }
            // 清除缓冲区
            buf.clear();
        }
        channel.close();
        aFile.close();
        System.out.println("\nEnding");
    }
}
```

上面的代码可以归纳为如下要点：

* 从RandomAccessFile、InputStream或者OutputStream打开FileChannel。
* 从FileChannel读取数据。channel.read方法将内容读取到Buffer中。

类似的，将内容写入文件，用法如下。

```java
package xyz.seekwind.nio_demo;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class Application {
    public static void main(String[] args) throws IOException {
        RandomAccessFile aFile =
                new RandomAccessFile("./demo2.txt", "rw");
        FileChannel channel = aFile.getChannel();
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        String newData = "my new Data";
        buffer.clear();
        buffer.put(newData.getBytes());
        // 必须要先反转读写方向，因为一开始默认是写
        buffer.flip();
        while (buffer.hasRemaining()) {
            channel.write(buffer);
        }
        channel.close();
        aFile.close();
    }
}
```

FileChannel还有几个方法：

* channel.postion(int pos)，类似系统调用lseek()，直接设置文件的偏移量。但是pos如果设置的大于文件原来的大小，则会撑大文件，并且文件中间一段是空白的，造成**文件空洞**。
* channel.size()，返回channel所关联的文件的大小。
* channel.truncate(int size)，截取文件的前size个字符，并返回一个新的channel。
* channel.force()，将channel中尚未写入磁盘的数据强制写到硬盘上，类似sync()系统调用。
* channel.transferTo()，channel.transferFrom()。输入输出重定向。

```java
// 一行代码完成文件部分复制，transferTo同理
toChannel.transferFrom(fromChannel, postion, size);
```

### 2. ServerSocketChannel

DategramChannel、SocketChannel、ServerSocketChannel都继承了AbstractSelectableChannel，这意味着我们可以使用一个Selector对象来执行Socket通道的就绪选择。

前两者实现了读写功能的接口，则ServerSocketChannel没有实现，因此它本身不传输数据，只负责监听传入的连接和创建新的SocketChannel对象。

```java
package xyz.seekwind.nio_demo;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;

public class Application {
    public static void main(String[] args) 
            throws IOException, InterruptedException {
        int port = 8888;
        ServerSocketChannel serverSocketChannel 
                        = ServerSocketChannel.open();
        serverSocketChannel.bind(new InetSocketAddress(port));
        // 非阻塞，即accept不会阻塞
        serverSocketChannel.configureBlocking(false);
        ByteBuffer buffer = ByteBuffer
                    .wrap("SeekWind Server"
                        .getBytes(StandardCharsets.UTF_8));
        while (true) {
            System.out.println("Before Accept()");
            // 非阻塞的accept
            SocketChannel socketChannel 
                = serverSocketChannel.accept();
            if (socketChannel == null) {
                System.out.println("No Connection");
                TimeUnit.SECONDS.sleep(2);
            } else {
                System.out.println(
                    "Incomming connection from: " 
                    + socketChannel.getRemoteAddress()
                );
                buffer.rewind();
                socketChannel.write(buffer);
                socketChannel.close();
            }
        }
    }
}
```

### 3. SocketChannel

位于客户端的TCP SocketChannel。它有两种创建方式，如下。

```java
package xyz.seekwind.nio_demo;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.channels.SocketChannel;

public class Application {
    public static void main(String[] args) 
            throws IOException, InterruptedException {
        String ipAddress = "www.baidu.com";
        int port = 8888;
        // 一步创建
        SocketChannel socketChannel1 
            = SocketChannel
                .open(new InetSocketAddress(ipAddress, port));
        // 两步创建
        SocketChannel socketChannel2 = SocketChannel.open();
        socketChannel2
            .connect(new InetSocketAddress(ipAddress, port));
    }
}
```

常用api如下：

```java
package xyz.seekwind.nio_demo;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.StandardSocketOptions;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class Application {
    public static void main(String[] args) 
            throws IOException, InterruptedException {
        String ipAddress = "www.baidu.com";
        int port = 80;
        SocketChannel socketChannel 
            = SocketChannel
                .open(new InetSocketAddress(ipAddress, port));
        socketChannel.isOpen(); // 测试是否为open状态
        socketChannel.isConnected(); // 测试是否已经被连接
        socketChannel.isConnectionPending(); // 测试是否正在连接
        // 校验正在进行连接的socketChannel是否已经完成连接
        socketChannel.finishConnect(); 
        socketChannel.configureBlocking(true); // 设置非阻塞
        // 设置选项
        socketChannel
            .setOption(StandardSocketOptions.SO_KEEPALIVE, true)
            .setOption(StandardSocketOptions.TCP_NODELAY, true);
        // 查看选项
        socketChannel.getOption(StandardSocketOptions.SO_KEEPALIVE);
        socketChannel.getOption(StandardSocketOptions.TCP_NODELAY);
    }
}
```

### 4. DatagramChannel

面向UDP协议的Channel，与上面的三种一样，关联了一个DatagramSocket。

```java
package xyz.seekwind.nio_demo;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;

public class Application {
    public static void main(String[] args) {
        new Thread(() -> {
            try {
                new Application().receive();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();

        new Thread(() -> {
            try {
                new Application().send();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

	// 发送UDP数据报
    public void send() throws Exception {
        // 这是发送数据报的服务器端口号
        int port = 8888;
        DatagramChannel sendChannel = DatagramChannel.open();
        InetSocketAddress sendAddress = new InetSocketAddress(port);
        sendChannel.bind(sendAddress);
        
        String msg = "SeekWind";
        int i = 0;
        
        while (true) {
            ByteBuffer buffer = ByteBuffer.wrap(msg.getBytes(StandardCharsets.UTF_8));
            // 目标主机的套接字
            sendChannel.send(buffer, new InetSocketAddress("127.0.0.1", 9999));
            System.out.println("已发送" + (++i) + "次");
            
            TimeUnit.SECONDS.sleep(1);
        }
    }
	
    // 接收UDP数据报
    public void receive() throws IOException {
        int port = 9999;
        // 监听来自9999端口的UDP数据报
        DatagramChannel receiveChannel = DatagramChannel.open();
        InetSocketAddress receiveAddress = new InetSocketAddress(port);
        receiveChannel.bind(receiveAddress);
        ByteBuffer receiveBuffer = ByteBuffer.allocate(1024);
        
        while (true) {
            receiveBuffer.clear();
            SocketAddress receiveSocketAddress = receiveChannel.receive(receiveBuffer);
            receiveBuffer.flip();
            
            System.out.print(receiveSocketAddress + ">  ");
            CharBuffer charBuffer = Charset.forName("UTF-8").decode(receiveBuffer);
            
            while (charBuffer.hasRemaining()) {
                System.out.print(charBuffer.get());
            }
            
            System.out.println();
        }
    }
}
```

事实上，客户端使用DatagramChannel也可以使用connect方法，但这并不是真正意义上的连接。我们知道UDP是无连接的，这里的connect指的是只接受来自指定套接字的UDP数据报。

### 5. Channel的分散与聚集

分散Scattering Reads，即把channel中的数据读到多个buffer中去。

聚集Gathering Writes，即把多个buffer中的数据依次写入channel。

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body = ByteBuffer.allocate(1024);
ByteBuffer[] bufferArray = {header, body};
// 依次填满两个buffer，因此不适用于大小动态的消息
channel.read(bufferArray);

// 把bufferArray中的数据依次写入channel中去，能较好处理大小不定的消息
channel.write(bufferArray);
```

## 3. Buffer

