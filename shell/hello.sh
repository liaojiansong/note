#!/bin/bash
#t1=$(date +%s)
##sleep 10s
##t2=$(date +%s)
##echo $((t2 -t1))

# 命令替换输出问题
#list="$(ls -l)" # 命令输出内容包含换行时,可以使用""包裹起来,这样就能原样输出了
#echo "${list}"

# 位置参数

#echo "我收到的第一个参数是:${0} \n"
#echo "我收到的第二个参数是:${1} \n"
#echo "我收到的第三个参数是:${2} \n"
#
#function test() {
# echo "函数接收到的第一个参数是:${0}"
# echo "函数接收到的第二个参数是:${1}"
# echo "函数接收到的第二个参数是:${2}"
#}
#
#test jason liao


#function foo() {
#    echo "传入当前函数的参数个数为:${#}"
#    echo "传入当前函数的参数具体为:${*}"
#    echo "传入当前函数的参数具体为:${@}"
#    echo "传入当前函数的运行进程号:${$}"
#
#    for i in $@ ; do
#        echo $i
#    done
#}
#foo hello world

#str="hello"
#echo $str
#
#length=${#str}
#echo "字符串长度为:$length"
#
#echo "字符串拼接"
#str2="world"
#echo "$str $str2"
#
#
#echo "字符串截取"
#str3="hello world"
#echo "从左到右截取3个"
#echo ${str3: 1}

#str="hello world"
#
#echo "从指定位置从左到右开始截取到最后"
#echo ${str:6}
#
#echo "从指定位置从左到右开始截取n个"
#echo ${str:6:2}
#
#echo "倒数截取全部"
#echo ${str:0-5}
#
#echo "倒数截取N个"
#
#echo ${str:0-5:2}
#
#str="I will continuing my coding life forever"
#
#echo "从指定字符开始截取右边"
#echo ${str#*ing}
#echo "从指定字符最后一个开始,截取到字符串最后 "
#echo ${str##*ing}
#
#
#echo "从指定字符开始截取左边所有"
#
#echo ${str%*ing}
#
#echo "从指定字符最后一次出现开始截取左边"
#echo ${str%%*ing}

#echo "数组的定义"
#echo 初始化定义
#arr=(1,2,3,4)
#echo 单个赋值
#arr[6]=6
#
#echo "访问单个"
#echo ${arr[8]}
#echo 访问全部
#echo ${arr[*]}
#
#temp[1]=jason
#echo ${temp[1]}
#
#echo 获取数组长度
#echo ${#arr[*]}
#echo 获取数组里面字符串长度
#echo ${#arr[8]}
#
#echo "删除数组元素"
#unset arr[1]
#unset arr[2]
#unset arr[3]
#echo ${arr[*]}


#echo -e "接下来学习:\n"
# -p prompt 弹出提示
#read -p "请输入" name url age
#echo "输入的name为:${name}"
#echo "输入的name为:${url}"
#echo "输入的name为:${age}"

# -n 指定接收字符的个数,达到个数立即停止读取,不用回车
#read -n 2 -p "请输入:\n" char
#echo $char

# -t 指定等待时间
# -s 静默模式,不显示输入内容
#if
#    read -t 20 -sp "输入密码>" pass1 && printf "\n" &&
#    read -t 20 -sp "第二次输入密码" pass2 && printf "\n"
#    [ $pass1==$pass2 ]
#then
#    echo "密码正确"
#else
#    echo "密码不正确"
#fi
#
#echo "read 实践"
#
#read -t 5 -n 2 -p  "说你是大傻逼>"
#printf "\n"
#echo ${?}

#read -d "0" name hello

# 学习if
#read -p "请输入你的小钱钱>" deposit
#if (( $deposit < 100 ));then
#    echo "零花钱"
#  elif (( $deposit > 101 && $deposit < 2000 ));then
#    echo "吃饭钱"
#  else
#    echo "土豪啊"
#fi

#read a
#read b
#(($a == $b))
#echo "退出状态" ${?}


# 学习一下test 命令
#read -p "请输入>" file
# -e 判断文件是否存在
# -f 判断文件是否存在,并且是否为普通文件
# -c 判断文件是否存在,并且是否为字符设备文件
# -d directory exists 判断目录是否存在
# -s 判断文件是否存在,并且是否为空

#if [ -d $file ];then
#  echo "目录存在"
#  else
#    echo "no exists"
#fi

#if [ -s $file ];then
#  echo "empty"
#else
#  echo notempty
#fi

#if [ -r $file ]
#then
#  echo "readable"
#else
#  echo "unreadable"
#fi

#if [ -w $file ]; then
#    echo "writeable"
#    echo 'kkkk' >> $file
#else
#    echo "unwriteable"
#fi

#if [ -x $file ]; then
#    echo "yes"
#fi


#read -p "请输入两个数值" a b
# -gt greater 大于
# -ge greater or equal
# -eq equal 等于
# -lt less 小于
# -le less or equal 小于或等于
# -ne not equal 不等于
#if [ $a -ne $b ]; then
#    echo "not eq"
#else
#  echo "eq"
#fi

# 字符串比较
#read a b
# == 判断字符串是否相等
# -n 判断字符串是否非空
# -z 判断字符串是否空
#if [ "$a" == "$b" ]; then
#    echo "string equal"
#    else
#      echo "string not equal"
#fi

#if [ -z "$a" ]; then
#    echo "empty"
#    else
#      echo "not empty "
#fi

#if [ -n "$a" ]; then
#    echo "notempty"
#fi

# 字符串逻辑运算

#if [ -n "$a" -a -n "$b" ]; then
#    echo "all not empty"
#fi


#if [ -n "$a" -o -n "$b" ]; then
#  echo 'or'
#
#fi
#a='hello'
#b='ta'
#if [[ -n $a && -n $b ]]; then
#    echo "get"
#fi
#read num
#case $num in
#1)
#  echo "php"
#  ;;    # 相当于break
#2)
#  echo "java"
#  ;;
#3)
#  echo "go"
#  ;;
#4)
#  echo "html"
#  ;;
#[5-9])  #正则
#  echo "unknown"
#  ;;
#[a,b,c])#正则
#  echo "database"
#  ;;
#*)      #正则 相当于default
#  echo "shit"
#  ;;
#esac

declare -i count
count=1

while (($count < 50 ))
do
  echo "hello"
  ((count++))
done
























