### https中tls层握手过程

HTTPS 采用非对称和对称混合加密模式,大致流程分为以下两步:

1. 通过tls握手,采用非对称加密方式传递对称加密秘钥
2. 利用对称加密方式加密报文(对称加密秘钥不会在网络中传输)

首先声明,https建立连接的第一步是tcp的三次握手,紧接着才是TLS(transport layer security)握手
#### https 协议栈组成

| HTTP |
| :--: |
| SSL  |
| TCP  |
|  IP  |

**HTTPS的本质就是在通信接口部分用SSL协议代替,披上了一层ssl协议的外壳**

SSL是一种独立的加密传输协议,同样可以应用于其他的应用层协议,例如:websocket

#### TLS 握手过程
![tls握手过程](D:\code\note\tcp\tls_handshake.png)

在整个过程中最为重要的是理解三个随机函数和pre-master secret 和master secret

1. 浏览器先服务发起请求,告诉服务器自己支持的加密协议和方式并携带一个**随机数A**
2. 服务器响应自己支持的加密方式,返回CA证书和**随机数B**
3. 浏览器去验证证书的合法性然后从中取出公钥
4. 浏览器生成一个pre-master-secret 然后用公钥加密后发给服务器
5. 服务端收到加密后的pre-master-secret后,利用私钥解密得到原本的pre-master-secret
6. 浏览器中,会利用之前随机数A,B加上pre-master-secret作为原料,采用DH算法计算出一个master secret,然后推导出hash secret 和 session secret
7. 服务器中,会结合原来的A、B随机数，用DH算法计算出一个`master secret`，紧接着根据这个`master secret`推导出`hash secret`和`session secret`。
8. 双方选用hash secret 对传输的http报文做一次运算的到mac(Message Authentication Code)称为报文摘要，能够查知报文是否遭到篡改，从而保护报文的完整性。然后利用session secret 加密 http+mac,然后发送
9. 接收方则先用`session-secret`解密数据，然后得到`HTTP+MAC`，再用相同的算法计算出自己的`MAC`，如果两个`MAC`相等，证明数据没有被篡改。