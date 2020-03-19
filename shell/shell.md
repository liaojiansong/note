# shell 基本语法
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