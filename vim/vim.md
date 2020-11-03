# vim 相关
#### 个性化配置
```shell script
# 文件:/etc/vimrc
"以下为健松私人订制(ps 如果要关闭,在命令前加no即可 如:set nonumber)
syntax on       "开启语法检查
set number      "开启行号显示
set mouse=a     "支持鼠标
set autoindent  "开启自动缩进
```

#### 快捷键
* `A` 行尾插入
* `I`  行首插入
* `ngg 或:n`  快速跳到n行
* `de`  从光标删除到行尾
* `dw`  从光标删除一个单词
* `shit+g`  去到文件底部
* `gg`  去到文件首部

#### 多文件编辑快捷键
|组合键|说明|
|:--|:--|
|diw|delete a word inside,删除一个单词|
|vim list.c map.c|打开多个文件|
|:next|下一个文件|
|:prev|上一个文件|
|:first|第一个文件|
|:last|最后一个文件|

#### 位置移动快捷键
|快捷键|说明|
|:--|:--|
|home或^|光标跳转到行首|
|end或$|光标跳转到行尾|
|gg|光标到页首|
|GG|光标到页尾|

#### 多窗口编辑

主要命令:`split` 缩写`sp`

分隔方式有两种

* 水平分隔(split,默认情况),命令行输入:`sp filename.c`即可
* 垂直分隔,(vertical split)命令行输入:`vs filename.c`即可

1. 首先打开一个文件`main.c`
2. 然后在命令行输入:`vs filename.c`

窗口移动采用鼠标比较方便`set mouse=a`,当然可以`ctrl+w+方向键`



#### 全局搜索替换
格式:`:%s/keyword/target/gc` 对应的形式为:`:{范围}s/{要替换的单词}/{候选单词}/{动作选项}`
解析:
> `%s` 表示搜索的范围是整个文档
> `s` 为`substitute(替换)`的缩写
> `g` 为`global`,为全局替换的意思 
> `c` 为`confirm`确认的意思,询问是否替换