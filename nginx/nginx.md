# nginx 配置语法
## 各种匹配模式和优先级
### 精准匹配
精准匹配:访问路径与location中必须完全保持一致才能命中
```shell script
# 精准匹配模式 必须完全完全跟$1保持一致才能匹配
# $1
location =/demo {
    rewrite ^ http://jiandan.com;
}
```
### 前缀匹配模式
前缀匹配模式 只需要与$1前缀匹配即可,不区分大小写 不支持正则表达式(即$1无论含有何种字符都当做目标字符进行匹配)
```shell script
# $1
location ^~ /news {
    rewrite ^ http://xiaomi.com;
}
# 例如:
# http://192.168.33.10/news
# http://192.168.33.10/news/today
# http://192.168.33.10/News
# http://192.168.33.10/newskk
# 这些都可以匹配,只要前缀符合即可
```
### 注意
如果有多个都能匹配,默认优先最长匹配
## 匹配优先级
特别注意:1 在同级匹配中,优先最长匹配  2 正则匹配一旦匹配中将不再匹配,不存在最长原则,所以先后顺序十分重要
```shell script
#同级匹配取最长的匹配的
#例1
location /0demo/aa/bb {
    rewrite ^ http://sougou.com;
}

#例2
location /0demo/aa/bb/cc {
    rewrite ^ http://bilibili.com;
}

#全匹配
location / {
    rewrite ^ http://jd.com;
}

#正常匹配
location /0demo/aa{
    rewrite ^ http://sohu.com;
}

# 正则匹配
location ~* /[0-9]demo {
    rewrite ^ http://huawei.com;
}

#前缀匹配
location ^~ /0demo {
    rewrite ^ http://juejin.im;
}

#精确匹配
location =/demo {
    rewrite ^ http://xiaomi.com;
}
```
### 总结
总结 精确匹配 > 前缀匹配 > 正则匹配 > 正常匹配 > 全匹配

## root 和 alias 的区别
### 区别
1. root 往往会和location 中完全路径叠加起来用
2. alias 用于定义别名 会和location 中匹配剩余的叠加使用,方便隐藏文件真实的路径
### root
```shell script
# 在root 情况下 我们访问http:://cat.com/zoom/picture/miao.png 会匹配中$1 最终的访问路径为root D:\laragon\www\case\cat\zoom\picture\miao.png 即为:$2+$1 是最终访问路径
$1
location /zoom {
    #$2
    root D:\laragon\www\case\cat;
}
```

### alias
```shell script
# 而在alias情况下 我们访问http:://cat.com/zoom/picture/miao.png 会匹配中$1,nginx会做以下替换 /zoom/picture/miao.png 会减去/zoom/picture部分,得到/miao.png
# 然后拼接$2 最终得到D:\laragon\www\case\cat\miao.png (404)
$1
location /zoom/picture {
        #$2
        alias D:\laragon\www\case\cat;
}
```
使用别名的好处就是可以隐藏路径
```shell script
# 例如访问http:://cat.com/word/china/picture/miao.png 时 最终/word/china会被匹配去除 留下/picture/miao.png
$1
location /word/china {
        #$2
        alias D:\laragon\www\case\cat\zoom;
}
```
### 总结
总的来说 root做的是匹配然后完整移植,不会去除匹配中的路径 而alias则会将匹配中的进行删除,留下末端与alias拼接,所以这时候要留意/符号,以免拼接错误


## 关于proxy_pass域名
### 正常情况
```shell script
# 正常模式下 访问http://passman.com/zoom/picture/miao.png 直接映射到D:\laragon\www\case\cat\zoom\picture\miao.png 中;
server{
    listen 80;
    server_name passman.com
    index index.html;
    root D:\laragon\www\case\passman;
    # 正则一
    location /zoom/picture {
        root D:\laragon\www\case\cat;
    }

}
```
### 正向代理为单纯的域名
```shell script
#但是在正向代理中若标识一为单纯的域名,则访问的是$2+$1
#即为: 访问http://passman.com/zoom/picture/miao.png 时 相当于访问http://cat.com/zoom/picture/miao.png
server{
    listen 80;
    server_name passman.com
    index index.html;
    root D:\laragon\www\case\passman;
    # $1
    location /zoom/picture {
        # $2
        proxy_pass http://cat.com;
    }

}
```
### 正向代理为域名+路径
```shell script
# 但是 在下列情况中,代理地址包含了地址时,情况会大有不同
server{
        listen 80;
        server_name passman.com
        index index.html;
        root D:\laragon\www\case\passman;
        # $1
        location /zoom/picture {
            # $2(代理地址中包含了路径)
            proxy_pass http://cat.com/data;
        }
}
# 例如访问 http://passman.com/zoom/picture/miao.png 时,/zoom/picture/miao.png中的/zoom/picture与$1 完全匹配
# nginx 会将匹配的部分直接去除,留下/miao.png 随后访问的代理地址即为http://cat.com/data/miao.png
```
### 总结
代理地址是否包含路径对结果影响巨大

## nginx 配置调试技巧
### 利用error.log
为了能看到访问路径,我们可以尝试故意将路径写错,这时会产生404错误,就可以到日志中查看

