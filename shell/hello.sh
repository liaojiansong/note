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

echo "数组的定义"
echo 初始化定义
arr=(1,2,3,4)
echo 单个赋值
arr[6]=6

echo "访问单个"
echo ${arr[8]}
echo 访问全部
echo ${arr[*]}

temp[1]=jason
echo ${temp[1]}

echo 获取数组长度
echo ${#arr[*]}
echo 获取数组里面字符串长度
echo ${#arr[8]}

echo "删除数组元素"
unset arr[1]
unset arr[2]
unset arr[3]
echo ${arr[*]}

