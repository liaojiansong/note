## Mysql 宏观方面的东西

### 事务的4种隔离级别

事务隔离就是说事务与事务之间的隔离级别.假定现在我们有两个事务 t1 和t2 同时操作user(id,name)表,分别就t1,t2两个事务的相对位置来解释事务

#### Read uncommitted(脏读)

**在一个事务中，读取了其他事务未提交的数据**. 就是说t1分次向user 插入3条数据,但是还没有进行`commit`,这时t2就开始查询user表,得到了3条数据. 所以说造成了脏读

![脏读](https://raw.githubusercontent.com/Draveness/Analyze/master/contents/Database/images/mysql/Read-Uncommited-Dirty-Read.jpg)

#### Read Committed(不可重复读)

**在一个事务中，同一行记录被访问了两次却得到了不同的结果** 就是说重复读取的话,有可能得到不一样的结果

![不可重复读](https://img.draveness.me/mweb/2019-07-16-Read-Commited-Non-Repeatable-Read.jpg)

#### Repeatable Read(幻读)

**在一个事务中，同一个范围内的记录被读取时，其他事务向这个范围添加了新的记录**,就是说t1怎么读都拿不到数据,但是插入数据的时候却说主键重复了,见鬼了. 原因就在于他t1在读取期间,t2插入了数据.

![幻读](https://raw.githubusercontent.com/Draveness/Analyze/master/contents/Database/images/mysql/Repeatable-Read-Phantom-Read.jpg)

## 事务的一致性

#### undo log(回滚日志)

#### redo log(重做日志)

