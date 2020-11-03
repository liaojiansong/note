#### 问题一 : linux 怎么去除重复的行?

命令为:`cat demo.txt|sort|uniq`

解析:

> 1. 先用`sort`排好顺序,再用`uniq`去除重复,因为`uniq`只能去除相邻的重复项,太远的不行
> 2. `sort` 也可以用来排月份,反向排序等,加上`-u`参数可以去重,但是没忽略大小写

#### 问题二: go 怎么比较两个map?

用 `reflect.DeepEqual()`

解析:

> 1. 额

#### 问题三 Ctrl+C 的原理是什么?

`Ctrl +C` 会向进程发送`SIGINT` 信号来中断进程,进程接收到信号后可以选择优雅退出或者什么都不做

解析:

> 1. 信号是进程间通信的一种方式,是一种软中断
> 2. 认真了解一下linux 的信号机制

#### 问题四: LRU算法的实现,高并发情况下如何留住热点数据?



#### 问题五: shell下统计Nginx 访问IP前十二

命令为 `awk '{print $1}' access.log |sort|uniq -c|sort -rn -k 1|head -n 10`

解析:

> 1. `awk '{print $1}' access.log` 输出全部IP地址 
> 2. `sort` 排序,让相同的IP靠近,便于`uniq` 处理,因为`uniq`只能处理相邻的
> 3. `uniq -c` 去重,参数`-c`用来统计出现次数
> 4. `sort` 根据上一个结果的次数进行排序,其中:
>
> > `-r,--reverse ` 表示倒序
> >
> > `-n,--numeric-sort` 表示根据字符串的数值进行统计,sort默认会根据ASCII码数值排序,会出现2>11的情况
> >
> > `-k,--key=KEYDEF` 根据关键单词排序,默认以空格分割单词,-t可以指定分隔符
>
> 5. `head -n 10` 取最终结果的前面十条































