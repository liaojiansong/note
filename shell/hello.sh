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

mkdir php
cd php
touch php.md