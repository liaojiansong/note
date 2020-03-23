# shell 基本语法
### 注释
```shell script
<<COMMENT
  这是一行注释
  这是一行注释
COMMENT

:'
 这是一行注释
 这是一行注释
 这是一行注释
'
```
### 变量的定义和使用
#### 变量的定义
```bash
name=jason   # 适用于单个单词的变量
name='jason' # 同php
name="jason" # 同php(推荐使用)
readonly name        # 只读变量
unset name           # 删除变量
```

### 变量的使用
1. 使用变量的前提条件在变量名称前面加 `$` 如 `echo $name`
2. 推荐使用方法 `echo "my name is ${name}""`

#### 命令替换
作用:将命令的输出结果赋值给变量
##### 用法
1. 直接使用反引号
2. 使用 `$(command)`
##### 举例
```bash
info=$(date;ls -l)  # 多个命令之间用 ";" 进行分割
echo $info

list="$(ls -l)"     
echo "$list"        # 命令输出内容包含换行时,可以使用""包裹起来,这样就能原样输出了
```

### 位置参数
#### 给脚本文件传递参数
运行 Shell 脚本文件时我们可以给它传递参数，这些参数在脚本文件内部可以使用$n的形式来接收，例如，$1 表示第一个参数，$2 表示第二个参数，依次类推。
其中$0 表示当前脚本名称
```bash
echo "我收到的第一个参数是:${0} \n" # hello.sh
echo "我收到的第二个参数是:${1} \n" # Jason
echo "我收到的第三个参数是:${2} \n" # liao

./hello.sh Jaon liao
```
#### 给函数传递参数
跟给脚本文件传递参数一样,都是通过$n接收参数
```bash
function test() {
 echo "函数接收到的第一个参数是:${0}" # hello.sh
 echo "函数接收到的第二个参数是:${1}" # jason
 echo "函数接收到的第二个参数是:${2}" # liao
}

test jason liao
```


### 特殊变量
#### 特殊变量列表如下
| 符号 |作用 |
|:---|:---|
| $0 | 表示当前脚本文件名 |
| $* | 传入当前脚本或函数的所有参数,字符串形式 |
| $@ | 传入当前脚本或函数的所有参数,不加"" 时将会是一个数组,可以进行遍历 |
| $# | 传入当前脚本或函数的参数的个数 |
| $$ | 当前脚本运行的进程号 |
| $? | 上一个命令退出状态,0 表示正常退出 1表示异常 |

#### 举些例子
```shell script
function foo() {
    echo "传入当前函数的参数个数为:${#}" #传入当前函数的参数个数为:2
    echo "传入当前函数的参数具体为:${*}" #传入当前函数的参数具体为:hello world
    echo "传入当前函数的参数具体为:${@}" #传入当前函数的参数具体为:hello world
    echo "传入当前函数的运行进程号:${$}" #传入当前函数的运行进程号:31435
}
foo hello world
```

#### 详细解释一下  `$@`
1. 当加上""的时候,得到的就是一个字符串
2. 当不加""的时候,将得到一个参数数组
```shell script
for i in $@ ; do
    echo $i
done
```


#### `$?` 获取函数返回值
```shell script
function foo() {
    return $((1+2))
}
foo
echo $? # 输出3
```


### 字符串拼接和截取

#### 字符串拼接
```shell script
# 很简单,直接放在一起就好了
str1="hello"
str2="world"
echo "${str1}${str2}"
```

#### 字符串截取

##### 按位置截取
```shell script
str="hello world"
# 从第六个字符开始截取到最后
echo ${str:6}

# 从第六个字符开始截取2个 
echo ${str:6:2}

# 从倒数第五个位置开始截取到最后
echo ${str:0-5}

# 从倒数第五个位置截取2个
echo ${str:0-5:2}

```

##### 按字符截取
1. `#` 表示从左向右截取
```shell script
str="I will continuing my coding life forever"

echo "从指定字符开始截取右边所有,不包含ing"
echo ${str#*ing}  #  my coding life forever
echo "从指定字符最后一个开始截取右边所有,不包含ing"
echo ${str##*ing} #  life forever

```
2. `%` 表示从右向左截取
```shell script
str="I will continuing my coding life forever"
echo ${str%*ing}
echo ${str%%*ing}
```


### read
用于读取用户输入并赋值给变量
#### 基本用法
`read [option] variables ...` 例如 `read input`

#### 几个比较重要的参数
1. `-p` 提示语
2. `-t` 限定输入秒数
3. `-e` 对功能键进行转义
4. `-n` 限定用户输入字符数,到达指定字符数量后自动结束
5. `-s` 静默模式,不显示用户输入内容
6. `-a` 将用户输入装入数组
7. `-d` delimiter,指定界定符代替传统的回车
#### 举例
```shell script
read -d "0" -p "请输入一些内容" info
for i in ${info[*]};do
    echo ${i}
done
```

### (())
对整数进行算数运算,只能是整数
#### 用法
1. 简单逻辑运算
```shell script
echo $((1+2))
i=10
echo $((i+20)) # 30

j=20
$((j+=20))
echo $j # 40
```
2. 逻辑运算
```shell script
echo $((1>2)) # 0

echo $((3>1 && 5>2)) # 1
```
3. 自增自减
```shell script
# 先执行后自增
a=10
echo $((a++)) # 10 
echo $a #11
#先自增 后执行
b=10
echo $((++b)) # 11 
echo $b       # 11
```
4. 多表达式运算
```shell script
echo $((a=1+2,b=2+3)) # 5 多表达式时候,只返回最后一个表达式的结果
echo $a  # 3
echo $b  # 5
```

### if语句
1. 单纯的 `if`
```shell script
if [1==1];then;
    echo "你好棒棒啊"
fi 
```
2. `if then`
```shell script
read -p "请输入你的存款>" deposit
if (($deposit > 50000));then
  echo "土豪"
else
  echo "穷鬼"
fi
```
3. `if then elif`
```shell script
read -p "请输入你的小钱钱>" deposit
if (( $deposit < 100 ));then
    echo "零花钱"
  elif (( $deposit > 101 && $deposit < 2000 ));then
    echo "吃饭钱"
  else
    echo "土豪啊"
fi

```


### [] 和 test
`[]` 等价于 `test`
#### 用法
```shell script
# "[]" 两边一定要有空格, 变量一定要用""包起来
if [ -f "$file"  ]; then
    echo ""
fi
```
#### 检测文件
1. `[ -f "$file" ] --file exists` 检测文件是否存在
2. `[ -d "$file" ] --directory exists` 检出目录是否存在
3. `[ -e "$file" ] --file exists` 检查文件是否存在
4. `[ -s "$file" ] --file not empty` 文件是否存在,并且不为空
5. `[ -r "$file" ] --file readable` 文件是否可读
6. `[ -w "$file" ] --file writeable` 文件是否可写
7. `[ -x "$file" ] --file not empty` 文件是否可执行

#### 检测数值
```shell script
if [ $a -gt $b ]; then
    echo "greater"
fi
```
1. `[ $a -gt $b] --greater than` 大于
2. `[ $a -ge $b] --greater or equal` 大于等于
3. `[ $a -lt $b] --less than` 小于
4. `[ $a -le $b] --less or equal` 小于等于
5. `[ $a -eq $b] --equal` 等于
6. `[ $a -ne $b] --not equal` 不等于

#### 检测字符串
检测字符串可以用 `[]`的增强版 `[[ ]]`,这个时候就不需要将变量用 `""`包起来了,更加简洁
```shell script
if [[ -n "$string" ]]; then
    echo "string is not empty"
fi
```
1. `[[-n "$string"] -- string not empty` 字符串为不空
2. `[[-z "$string"] -- string  empty` 字符串为空
3. `[[-n $string && -n $string2]] -- all string not empty` 所有字符串都不为空
4. `[[-n $string" || -n $string]] -- one of string are not empty` 其中一个字符串不为空

### case in 语句
```shell script
case $num in
1)
  echo "php"
  ;;    # 相当于break
2)
  echo "java"
  ;;
3)
  echo "go"
  ;;
4)
  echo "html"
  ;;
[5-9])  #正则
  echo "unknown"
  ;;
[a,b,c])#正则
  echo "database"
  ;;
*)      #正则 相当于default
  echo "shit"
  ;;
esac
```


### while 语句
```shell script
declare -i count
count=1
while (($count < 50 ))
do
  echo "hello"
  ((count++))
done
```


### for in 语句
#### 形式一 normal
最为普遍,当然也可以把i 提取到外面
```bash
declare -i a
for ((i=1;i<100;i++))
do
    echo $i
    ((i++))
done

for ((i=1;i<10;i++));do
    echo "hello"
    ((i++))
done
```

#### 形式二 value list
这种会遍历列表,列表元素之间用空格分割
* 指定列表值
```bash
for i in 1 2 3 4 5 6
do 
    echo $i
done
```

* 遍历命令执行结果 注意:利用 `$()` 获取命令执行的结果
```bash
for file in $(ls)
do
    if [[ -d $file ]]; then
        for son in $(ls $file) ; do
            echo $son
        done
    else
        echo $file     
    fi
done
```

* 指定范围 注意:范围格式 `{start..end}`
```bash
for i in {1..9} ; do
    echo $i
done
```

### select in 语句
弹出交互菜单,用户输入数字进行选择
```bash
select lang in php go java c ;
do 
    echo $lang
done

# select in 搭配 case in 实用最使用
echo "Which is the best language in the world?"
select lang in php java c go ;
do
    case $lang in
        "php")
            echo "nice"
            break
            ;;
        ["java","go","c"])
            echo "shit"
            break
            ;;
        *)
            echo "胆小鬼"
            break
            ;;
    esac
done
```

### 函数
```bash
function getsum(){
    local sum=0
    for n in $@
    do
         ((sum+=n))
    done
    echo $sum
    return 0
}
#调用函数并传递参数，最后将结果赋值给一个变量
total=$(getsum 10 20 55 15)
echo $total
#也可以将变量省略
echo $(getsum 10 20 55 15)
```

































































