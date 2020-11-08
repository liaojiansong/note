###  主从同步配置和注意事项

以下说明严重参考mysql官方文档的 [16章-主从复制](https://dev.mysql.com/doc/refman/5.7/en/replication.html)

#### 用到的命令

下面几个会频繁用到的命令

1. `show master status;` 显示当前使用binglog日志的最新位置
2. `show binary logs;` 显示所有的binlog和大小
3. `show binlog events;` 查看binlog 日志信息
4. `show slave hosts;` 查看主库下连接从库
5. `show slave status;` 从库查看链接状态
6. `start slave;`开启从库同步
7. `stop slave;` 关闭主库同步

#### 主库配置

因为主从复制是基于binlog日志进行的,所以必须开启binlog日志

##### 在my.cnf写入一下内容

```
[mysqld]
log-bin=mysql-bin # 表示开启binlog,并且以'mysql-bin'为文件前缀
server-id=1       # 服务唯一标识,主从之间不能重复,否则失败
```

##### 创建从库专用账户

当然也可以不创建专门的从库账户,只要给出的账户有`Repl_slave_priv: Y Repl_client_priv: Y`的权限即可. 但是最好创建一个专门的账户,因为从库的配置信息会以明文的方式保存在这个文件中`Master_Info_File: /var/lib/mysql/master.info`

```shell
mysql> CREATE USER 'repl'@'%' IDENTIFIED BY '123456'; # 创建任何IP都可以登入的账户
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';  # 赋予同步权限
```

##### 查看当前主库binlog的最新状态

```shell
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000004 |      450 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

从库需要根据`File` 和`Position` 确定同步起点.所以配置从库的时候一定要保持这两个值的稳定,禁止新数据进来而导致位置不对应. 可以考虑锁住全库,只读不写.例如:`mysql> FLUSH TABLES WITH READ LOCK;`

######  查看从库状态

```shell
mysql> show slave hosts;
+-----------+------+------+-----------+--------------------------------------+
| Server_id | Host | Port | Master_id | Slave_UUID                           |
+-----------+------+------+-----------+--------------------------------------+
|         6 |      | 3306 |         1 | e4037442-209e-11eb-b764-0242ac1c0002 |
+-----------+------+------+-----------+--------------------------------------+
1 row in set (0.00 sec)

```



##### 主从要保持原始数据一致

主从同步会有以下两种情况

###### 主库有原始数据

这个时候需要做数据拷贝,保持两边数据一致,才能开始配置同步.可以采用`mysqldump`或数据传输等方式保持主从一致

###### 主库无原始数据

这种情况最简单,直接配置从库跟上主库的binlog位置即可,本文以这种情况展开

#### 从库配置

###### 在my.cnf 添加一下配置

```shell
[mysqld]
server-id=2 # 服务唯一标识
#log-bin=mysql-bin #从库的binlog可开可不开,开了就多一重保障
```

配置好以后,重启服务

###### 连接主库的配置

```shell
change master to master_host='xxxx',master_port=3306,master_user='root',master_password='123456',master_log_file='mysql-bin.000003',master_log_pos=154;
# 这部分数据会被写入 master.info中
# 如果配置错了,可以单独修改某一项
change master to master_host='12.12.34.54';
```
关于更多配置选项,可以参考官方文档[CHANGE MASTER TO Statement](https://dev.mysql.com/doc/refman/5.7/en/change-master-to.html)

###### 通过`show slave status \G;`查看配置信息

```shell
mysql> show slave status\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 39.106.79.246
                  Master_User: root
                  Master_Port: 8082
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000004 # 读取主库的binlog的位置
          Read_Master_Log_Pos: 450
               Relay_Log_File: d5a065d3b8f2-relay-bin.000004
                Relay_Log_Pos: 663
        Relay_Master_Log_File: mysql-bin.000004
             Slave_IO_Running: Yes              # 必须保证为yes
            Slave_SQL_Running: Yes              # 必须保证为yes
              Replicate_Do_DB:                  # 指定同步的库或表
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 814
              Relay_Log_Space: 607266
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0                # 与主库之间的延迟,单位秒
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: 5c527d83-209b-11eb-8328-0242ac1b0002
             Master_Info_File: /var/lib/mysql/master.info # 主库连接配置文件
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates # 从库状态描述
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
1 row in set (0.00 sec)

```

###### 开启/关闭从库同步

1. 开启同步 `start slave;`
2. 停止同步 `stop slave;`
3. 重置同步 `reset slave;`

##### 测试环节

###### 建立测试数据

在主库执行以下命令


```mysql
#建立测试库
create database if not exists demo default character set utf8;
# 建立测试表
CREATE TABLE `paper` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int(255) NOT NULL,
  `sort` int(255) NOT NULL,
  `content` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 插入测试数据
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (1, '李二狗', 0, 4, '没有', '2020-09-19 10:27:24', '2020-09-19 12:13:28');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (4, '李三狗', 0, 0, '没有', '2020-09-19 10:27:24', '2020-09-19 12:14:55');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (5, '张全蛋', 0, 7, '没有', '2020-09-19 10:27:24', '2020-09-19 12:15:18');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (6, '王宝强', 0, 2, '没有', '2020-09-19 10:27:24', '2020-09-19 10:44:39');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (7, '邓超', 0, 1, '没有', '2020-09-19 10:27:24', '2020-09-19 10:43:42');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (8, '马苏', 0, 0, '没有', '2020-09-19 10:27:24', '2020-09-19 12:14:05');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (9, '李小璐', 0, 6, '没有', '2020-09-19 10:27:24', '2020-09-19 12:15:18');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (10, '金爱莲', 0, 3, '没有', '2020-09-19 10:27:24', '2020-09-19 10:44:39');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (11, '武松', 0, 5, '没有', '2020-09-19 10:27:24', '2020-09-19 10:44:07');
INSERT INTO `paper`(`id`, `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES (12, '潘金莲', 0, 0, '没有', '2020-09-19 10:27:24', '2020-09-19 12:13:28');

# 修改一条数据
update paper set content='出轨专业户',sort=666 where id=12;

# 删除一条数据
delete from paper where id=4;

INSERT INTO `paper`( `title`, `parent_id`, `sort`, `content`, `created_at`, `updated_at`) VALUES ('苗人凤', 0, 0, '没有', '2020-09-19 10:27:24', '2020-09-19 12:13:28');



```

###### 观察从库同步情况

可以通过查询表数据或者`show slave status\G;`命令观察

