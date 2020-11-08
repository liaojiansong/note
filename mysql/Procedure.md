#### 存储过程

快速创建测试数据

###### 创建数据库

```mysql
create database demo if not exists character set utf8mb4;
```

###### 创建表

```mysql
CREATE TABLE `vote_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `vote_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_id` (`user_id`)
) ENGINE = InnoDB DEFAULT charset = utf8mb4;
```

###### 创建函数

* 随机数函数

```mysql
CREATE DEFINER=`root`@`%` FUNCTION `rand_string`(n INT) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE chars_str varchar(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    DECLARE return_str varchar(255) DEFAULT '' ;
    DECLARE i INT DEFAULT 0;
    WHILE i < n DO
        SET return_str = concat(return_str, substring(chars_str, FLOOR(1 + RAND() * 62), 1));
        SET i = i + 1;
    END WHILE;
    RETURN return_str;
END
```

* 过程函数

```mysql
CREATE DEFINER=`root`@`%` PROCEDURE `add_vote`(IN n int)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE (i <= n) DO
        INSERT INTO vote_record (user_id, vote_id, group_id, create_time) VALUES (rand_string(20), FLOOR(RAND() * 1000), FLOOR(RAND() * 100), NOW());
        SET i = i + 1;
    END WHILE;
END
```
* 调用函数

```mysql
CALL add_vote(1000000)
```

  

  