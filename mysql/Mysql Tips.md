## Mysql 知识小点

### 命令相关

1. `\G` 按列显示
2.  `\c` 取消当前输入的命名
3.  `\s` 查看当前连接状态

### 聚合函数

1. max和min 不需要扫描索引,快
2. count(*) 是经过mysql优化的,速度最快



___
### 关于join

___
##### On 和 Where 的区别(以left join为例)
###### eg: `select * from a left join b on a.id=b.a_id and b.sorce >80;`

   * 执行顺序:on是生成临时表的条件,先on后where
   * on 语句可以对右表进行筛选,但不会对左表产生任何作用
   * 无论on条件是否为真,都会完整返回左表数据
   * where 语句负责对产生的临时表进行过滤,去掉不为真的记录
> 总结:如果明确右表不参与连接的行,可以在on 语句后进行过滤操作
___
##### 多个Join 语句的执行顺序
###### eg: `select * from a left join b on a.id=b.a_id left join c on b.id=c._b_id;`
   1. a和b生成临时表v_ab
   2. v_ab和c生成临时表abc
   3. 可以通过explain 进行验证, id数值越大越优先,数值相同则优先级自上而下

    | id | 优先级 |
    |---:|------:|
    |1|最次|
    |1|最次pro|
    |2|其次|
    |3|最优|
> 总结:多个join 从左到右依次执行
___

### 分析sql语句
#### 慢查询
* 利用 `show variable like '%slow%` 和 `show variable like '%long_query_time%` 查看慢查询配置情况
* 利用 `mysqldumpslow --help` 分析慢查询日志
#### explain 几个关键字段
| id (查询id)| type(访问类型)| key(使用的索引) | ref(匹配条件) | row(读取行数) | filtered(过滤数据百分比) | extra(附加提示信息) |
|---:|-----:|--------------:|----:|----:|----:|---------:|

* explain 只能用于select语句
* type 的值中 all 表示全表扫描,最差 常见的有 ref,eq_ref,range


### 几条管理命令
* 查看当前连接列表
```mysql
show processlist;
```

* 查看当前属性设置
```mysql
show variables;
```

### 关于连表更新删除
#### 连表更新
```mysql
update table a,table b
set a.username = b.name
where a.id = b.id;
```
#### 连表删除
```mysql
delete a
from table a
         left join table b on a.id = b.login_id
where b.id is null;
```
### 统计多个条件
mysql 统计字段是会忽略空值,即(null)
```mysql
select count(id),
       count(if(enter_proportion > 0.5, 1, null)),
       count(if(enter_proportion > 0.8, 1, null))
from ieas_channel_monitor;

```

### 关于修改表结构
大表`ALTER TABLE`非常耗时，MySQL执行大部分修改表结果操作的方法是用新的结构创建一个张空表，从旧表中查出所有的数据插入新表，然后再删除旧表。尤其当内存不足而表又很大，而且还有很大索引的情况下，耗时更久。

### 关于索引覆盖
解释:覆盖索引是select的数据列只用从索引中就能够取得，不必读取数据行，换句话说查询列要被所建的索引覆盖。索引的字段不只包含查询列，还包含查询条件、排序等。
#### 先了解一些概念
1. 聚簇索引 => 主键索引
2. 二级索引 => 非主键索引的其他都是二级索引,例如联合索引,唯一索引
3. 回表查询 => 根据索引中指向的主键id,再次根据主键索引进行查询,称之为回表
一般来说,普通索引中对应了主键id 即 age=12 => id[1,2,3,4],我们使用 ``where age = 12`` 时先得到 id = [1,2,3,4] 然后再依次查询.
#### 使用覆盖索引
解释:select的数据列只用从索引中就能够取得，不必读取数据行，换句话说查询列要被所建的索引覆盖。索引的字段不只包含查询列，还包含查询条件、排序等。

## mysql 中比较冷门的语法
### union/unionall 联合查询
#### 用法和注意事项
1. `union unionall` 用于合并两个查询语句的结构进行输出
2. `union unionall` 联合结果时,字段名称可以不一样,但是字段属性和个数必须保持一致
3. `union` 会对结果进行去重,而 `unionall` 不会,所以`unionall`效率比较高
4. 要注意语句的执行顺序的优先性,最优先子句,然后到全语句,可以利用圆括号来制定优先级
5. 联合查询会产生临时表,看情况选用
6. 性能分析如下

| id | select\_type | table | partitions | type | possible\_keys | key | key\_len | ref | rows | filtered | Extra |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | PRIMARY | ieas\_bidding | NULL | ref | idx\_name | idx\_name | 514 | const | 1 | 100 | NULL |
| 2 | UNION | ieas\_bidding | NULL | ref | idx\_code | idx\_code | 130 | const | 2 | 100 | NULL |
| NULL | UNION RESULT | &lt;union1,2&gt; | NULL | ALL | NULL | NULL | NULL | NULL | NULL | NULL | Using temporary |


## mysql 语句的优化建议
##### 1. 应尽量避免在where子句中使用or来连接条件
##### 原因
有可能不走索引造成全表扫描
##### 方案
利用 `union` 语句进行代替,用空间换时间
```mysql
explain select * from ieas_bidding where name = 'Floyd Lang' union select * from ieas_bidding where code = '6';
```

##### 2.数据量大时,谨慎分页
##### 原因
* 当偏移量最大的时候，查询效率就会越低，因为Mysql并非是跳过偏移量直接去取后面的数据，而是先把偏移量+要取的条数，然后再把前面偏移量这一段的数据抛弃掉再返回的。

##### 方案
* 利用 ``where id > ?`` 跳过一部分偏移量
* ...

##### 3.正确使用like 语句
##### 原因
不合理使用 like 会导致索引失效,全表扫描
##### 方案
1. 拒绝使用 ``%keyword%`` 语句
2. 使用 `` keyword%`` 还是能利用到索引的

##### 4.避免在索引列上使用函数
##### 原因

这样mysql 会放弃索引,全表扫描

##### 应尽量避免在where子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描

##### 5.使用联合索引时，注意索引列的顺序，一般遵循最左匹配原则。
##### 6.应尽量避免在where子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描
##### 7.可以将浮点数放大为整数进行存储,这样可以避免浮点数计算不准确和DECIMAL精确计算代价高的问题
##### 8.连表查询中,只需要在关联顺序中的第二张表的相应列上创建索引即可

分析:先看看连表查询的原理,先查询左表然后循环左表记录,按条件再去查询右表
```
outer_iterator = SELECT A.xx,A.c FROM A WHERE A.xx IN (5,6);
outer_row = outer_iterator.next;
while(outer_row) {
    inner_iterator = SELECT B.yy FROM B WHERE B.c = outer_row.c;
    inner_row = inner_iterator.next;
    while(inner_row) {
        output[inner_row.yy,outer_row.xx];
        inner_row = inner_iterator.next;
    }
    outer_row = outer_iterator.next;
}
```
* 确保任何的GROUP BY和ORDER BY中的表达式只涉及到一个表中的列，这样MySQL才有可能使用索引来优化
* 必须在右表外键上建立索引

##### 不要用rand随机获取数据

##### 原因

我们先看看`select word from words order by rand() limit 3;`的执行流程

1. 创建一个临时表。这个临时表使用的是 memory 引擎，表里有两个字段，第一个字段是 double 类型，为了后面描述方便，记为字段 R，第二个字段是 varchar(64) 类型，记为字段 W。并且，这个表没有建索引。
2. 从 words 表中，按主键顺序取出所有的 word 值。对于每一个 word 值，调用 rand() 函数生成一个大于 0 小于 1 的随机小数，并把这个随机小数和 word 分别存入临时表的 R 和 W 字段中，到此，扫描行数是 10000。
3. 初始化 sort_buffer。sort_buffer 中有两个字段，一个是 double 类型，另一个是整型。
4. 从内存临时表中一行一行地取出 R 值和位置信息分别存入 sort_buffer 中的两个字段里。这个过程要对内存临时表做全表扫描，此时扫描行数增加 10000，变成了 20000。
5. 在 sort_buffer 中根据 R 的值进行排序。
6. 排序完成后，取出前三个结果的位置信息，依次到内存临时表中取出 word 值，返回给客户端。

小结一下：order by rand() 使用了内存临时表，内存临时表排序的时候使用了 rowid 排序方法。

#####方案

使用随机函数会使用临时表并双倍扫描，效率低下



### 面试题

##### 一条查询语句很慢会是什么原因？

* 等待MDL锁(metedata lock)
* 恰好遇上刷脏页
* 等行锁
* 没加索引
* 索引列上用了函数



