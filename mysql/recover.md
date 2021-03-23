### Mysql 数据恢复

#### 先罗列一些会用到的命令

| 命令                                    | 作用                                      |
| :-------------------------------------- | ----------------------------------------- |
| show master status;                     | 查看当前主库的状态正在使用哪个binlog      |
| show binary logs;                       | 列举当前存在的binlog 文件                 |
| flush logs;                             | 立即写入日志,随后产生一个新编号的binlog   |
| reset master;                           | 重置主库binlog日志,之前日志全部清空(危险) |
| purge master logs to 'mysql-bin.00010'; | 把mysql-bin.00010 之前的日志清除          |

#### mysqlbinlog 的使用

这是一个常见的使用方式:`mysqlbinlog --no-defaults --database=demo -v --base64-output=decode-rows --start-position=216 --stop-position=1256 -r demo.sql`

解释一下:

> `--no-defaults` 主要解决`mysqlbinlog: [ERROR] unknown variable 'default-character-set=utf8mb4'`的问题
>
> `--database` 指定数据库
>
> `-v` verbose 显示详细信息,`-vv` 多加一个v 会显示更多
>
> `--base-output` 解码后输出,主要是给人看的,真正恢复时切记去掉,不然恢复不了
>
> `--start-position` 起点
>
> `--stop-position` 终点`
>
> `-r` 将输出写入到指定文件中

#### 数据恢复流程指南

##### 第一步-轮转日志

执行`flush logs` 命令,将误删数据的日志锁定在一个文件里面,避免后续日志产生干扰

##### 第二步-找到备份数据

通过某种途径,将数据库恢复到某一个时间节点t1的状态

##### 第三步-解析binlog

找到日志所在的具体binlog,跳过删除数据的语句,导出sql 

##### 第四步-恢复数据

进入cli界面,执行`source /data/recover.sql`





