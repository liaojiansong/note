## GMP 调度模型

名词解释:

* G 表示goroutine
* M 表示线程(Thread),是操作系统的内核级线程
* P 表示处理器(processor),是沟通G和M的桥梁

### 需要注意的点

* 调度器可以创建10000 个线程,但是最多只会有 `GOMAXPROCS` 个活跃线程能够正常运行