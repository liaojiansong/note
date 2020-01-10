## Mysql 知识小点
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

