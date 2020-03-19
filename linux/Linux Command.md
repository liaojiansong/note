### 插播几条win10快捷键
#### `win+D` 快速最小化当前窗口
#### `win+R` 快速运行CMD
#### `win+E` 快速打开我的电脑


### 命令行快捷键
#### ***Ctrl 类***
##### `Ctrl + R` 查找历史命令(多按几次就多查几个)
##### `Ctrl + W` 从光标处往前删除一个单词
##### `Ctrl + K` 从光标处往后删除所有
##### `Ctrl + U` 从光标处往前删除所有
##### `Ctrl + A` 光标移动到行首
##### `Ctrl + E` 光标移动到行尾

#### ***Alt 类***

##### `Alt + F --forward` 光标向前一个单词
##### `Alt + B --back` 光标回退一个单词
##### `Alt + C --capital` 光标所在单词首字母大写
##### `Alt + U --upcase` 光标回所在单词大写
##### `Alt + L --lowcase` 光标回所在单词小写

#### ***其他***
##### `Alt + . `获取最后一个参数
##### `ESC + . `获取最后一个参数


### Crontab
#### Crontab ***(crond table)定时任务表***
#### 示例 `/10 * * * * root echo 'hello' >> /data/log/1.txt` 每十分钟向文件写入hello
##### 格式如下
```shell script
 # Example of job definition:
 # .---------------- minute (0 - 59)
 # |  .------------- hour (0 - 23)
 # |  |  .---------- day of month (1 - 31)
 # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
 # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
 # |  |  |  |  |
 # *  *  *  *  * user-name  command to be executed
 15,16 * * * * root echo "每15,16分钟执行的任务" >> /home/jason/book/test.txt
 19-22 * * * * root echo "19-21分钟执行的任务" >> /home/jason/book/test.txt
 35 15 * * * root echo "15:35执行的任务" >> /home/jason/book/test.txt
 0 2,16 * * * root echo "每天2点和16点0分执行的任务" >> /home/jason/book/test.txt
 * * * * * root echo "每分钟执行的任务" >> /home/jason/book/test.txt


```

##### 特殊符号
* `*` 每个单元的意思
* `-` 在区间内,例如 `1-6` 表示1到6分钟内每一分钟都执行操作
* `,` 在列表内,例如 `1,3,5` 表示在第1和第3和第5分钟时执行操作
* `/` 每多少的,例如 `/10` 表示每隔10分钟就执行操作


### Logrotate
#### Logrotate ***日志切割工具***
##### 随便看看手册 `man logrotate`
##### 配置文件位置
```shell script
/etc/logrotate.d
/etc/logrotate.conf
```

### 同步时间
#### `ntpdate 服务器地址`
##### 可用时间服务器列表
* `ntp.sjtu.edu.cn` 上海交通大学
* `ntp.aliyun.com` 阿里云

### SSH
#### ssh ***加密协议实现安全的远程登录服务器***
#### 使用示例 `ssh -[option] ip`
>##### `-l  --login-name` 指定登入名称  `ssh -l root 192.168.0.0`
>##### `-p  --port` 指定连接的端口 `ssh -l root 192.168.0.0 -p 22`



### Linux 常用命令
### grep
#### grep ***(global search regular expression and print out the line) 全局搜索并打印***
>##### `-o  --only-matching` 仅仅显示匹配中的
>##### `-i  -- ignore-case` 忽略大小写
>##### `-w  -- word-regexp` 匹配整个单词
>##### `-v  -- invert-match` 反选
>##### `-c  -- count`   统计出现次数
>##### `-n  -- line-number` 显示行号
>##### `-r  -- recursive` 递归查找,主要用于查找某个目录下文件内容
>##### `-E  --extended-regexp` 正则匹配
>> ###### 例如: `grep  -r "global" gg/ ` 查找gg目录下所有文件是否包含"global"


### tail
#### tail ***尾巴,尾部的意思 与之相反的是`header`命令***
#### 使用示例 `tail -[option]   file`
>##### `-f  --follow` 持续追踪文件变化,按Ctrl+C 退出跟踪
>##### `-n  --lines` 只显示最后的n 行 默认10 行


### cat
#### cat ***翻译过来是猫的意思 就是瞄一眼这个文件内容***
>##### `-n --number` 显示内容行号
>##### `Ctrl+S` 停止屏幕滚动
>##### `Ctrl+Q` 继续屏幕滚动

### stat
#### stat ***详细显示文件的信息,真的很详细***
#### 示例 `stat file`

### mkdir
#### mkdir ***(make directory 创建目录)***
#### 示例 `mkdir -[option]`
>##### `-m --mode` 建立文件夹的同时设置权限
>##### `-p --parents` 如果父级目录不存在,一并创建

### uptime
#### uptime ***(系统正常运行时间)***

### free
#### free ***(查看系统运行内存)***
#### 示例 `mkdir -[option]`
>##### `-h --human` 给人看的选项

### history | ctrl + r
#### history ***(查看历史命令,有用)***
#### 示例 `history 10`
>##### `history 10` 查看最近十条命令,会列出命令id
>##### `!189` 再次执行id为189的命令
>##### `-c --clear` 清除所有历史命令


### date
#### date ***(当前日期,更多格式用--help查看)***
#### 示例 `date +"%"`
>##### `date +"%s"` 打印时间戳
>##### `date +"%x"` 当前日期


### wget
#### wget ***(下载资源)***
#### 示例 `wget -[option] url`
>##### `-O --output-document=FILE`重命名下载的文件
>##### `-v --verbose` 显示详细过程
>##### `-b --background` 后台运行

### `>` 和 `>>`
#### 重定向输出到文件
#### 示例 `ls > 1.txt`
>##### `ls > 1.txt`覆盖输出文件,抹除原先内容
>##### `ls >> 1.txt` 追加到输出文件

### find
#### find ***查找系统中的文件***
#### 示例 `find path -[option]`
>##### `-name pattern ` 查找指定名称的文件
>##### `-type .. ` 查找指定类型
>>###### `d --directory ` 类型为目录
>>###### `f --file ` 类型为普通文件

### xargs
#### xargs ***将标准输入转为命令行参数。***
#### 示例 `xargs -[option] command`
>##### `-p, --interactive` (Prompt before running commands) 询问是否执行命令
#### 详解 `echo "apple book cat" |xargs -p mkdir` 执行过程
>1. 系统标准输出"apple book cat"这一个字符串
>2. xargs会捕获输出作为输入,即将"apple book cat"作为输入
>3. xargs会自动以空格或者换行符拆分字符串,然后把每一个拆分结果放到 `mkdir` 后面
>> ```markdown
>> mkdir apple
>> mkdir book
>> mkdir cat
>> ```

### jobs
#### jobs ***查看当前shell挂起的任务(按Ctrl+Z 挂起任务)***
#### 示例 `jobs` 返回结果如下
```shell script
[1]-  Stopped                 vim test.txt
[2]+  Stopped                 vim /etc/crontab
```


### fg
#### fg ***将放到后台执行的进程放回前台***
#### 示例 `fg [job序号]`
>##### `fg 1` 将任务序号为1的job 放回shell


### env
####  `env` 输出当前所有环境变量
####  `$PWD` 使用`$`符号调用环境变量


### scp 很常用
#### scp(secure copy) ***安全的远程拷贝***
#### 示例 `scp local_file remote_username@remote_ip:remote_folder`
>##### `scp 源文件路径  目标用户@目标ip:目标路径`  将本地的local/local.txt复制到远程服务器文件夹
>##### `scp local/local.txt root@192.168.0.1:/root/temp`  将本地的local/local.txt复制到远程服务器文件夹
>##### `scp -r local/dir/ root@192.168.0.1:/root/temp`  将本地的local/dir/ 文件夹复制到远程服务器文件夹
>##### `scp root@192.168.0.1:/root/remote/hello.txt /local/temp/`  将远程的/root/remote/hello.txt复制到本地文件夹

### sftp 比scp 功能更加丰富
#### sftp(secure file transfer program)
>##### `sftp root@192.168.0.1` 开启文件传输服务
>##### `help` 建立连接后输入help 查看更多信息


### type
#### 查看命令种类和归属
`type cd`


### alias 给命令定义别名
#### 使用方式
1. `alias` 列举当前系统正在使用的命令别名
2. `alias timestamp='date +%s'` 自定义时间戳命令;这样的定义方式只对当前的有效
#### 私人订制命令
1. 订制当前用户的私人命令,打开 `~/.bashrc` 编写自己的命令即可
2. 订制整个系统的命令,打开 `/etc/bashrc`


### echo 
#### 输出到标准输出
1. 特殊用法加上 `-e` 将转义 `\n` 为换行符
```shell script
echo -e "hello\nworld"
#hello
#world
```



### ssh(secure shell)登入原理和运用
#### 登入原理
```
  |pub.key|  1.事先将C端的pub.key 放在服务器authorized_key文件中           |        |
  |       |  ------------------------------------------------------>    |        |
  |       |                                                             |        |
  |       |  2.       发起登录请求并携带自己的公钥给服务器                  |         |
  |       |  ------------------------------------------------------>    |        |
  |       |                                                             |        |
  |客户端 |   3. 检验C端公钥是否认证,用该公钥加密字符串R得到token保存并返回    | 服务端  |
  |       |  <---------------------------------------------------       |        |
  |       |                                                             |        |
  |pri.key|  4.用私钥解密token得到R,然后md5(R) 发送至服务器                 |        |
  |       |                                                             |        |
  |       |  5.服务器校验md5(R) 等于自己事先保存的R,则校验通过,建立连接       |        |
  |       |                                                             |        |
  |       |  6.       利用md5(R)作为token建立起正常的通信                  |        |
  |       |                                                             |        |

```

#### ssh 运用
##### 服务端需要做的
1. `ssh-keygen` 会在用户根目录下生成id_ras和id_rsa.pub文件
2. `touch authorized_keys` 建立公钥文件,集中存放给予授权的公钥文件

##### 客户端需要做的
1. `ssh-keygen` 会在用户根目录下生成id_ras和id_rsa.pub文件
2. `ssh-copy-id root@192.168.0.125` 将本机公钥复制到指定服务器的authorized_keys文件中,如果本步走不通直接下一步
3. `scp c:\user\jason\.ssh\id_rsa.pub root@192.168.0.125:/root/.ssh/c.pub` 将本机公钥复制到目标服务器中

##### 一条命令登入服务器
1. `ssh root@192.168.0.125` 前提是公钥已认证,否则要输入密码







































































 