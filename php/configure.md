#### 编译安装php 的拓展

先介绍php编译安装的工具 `phpize`

phpize 是用来准备php拓展库安装用的猛戳[这里](https://www.php.net/manual/zh/install.pecl.phpize.php)查看文档

以下以编译安装predis 拓展为例子

1. 首先下载[predis](https://pecl.php.net/package/redis)到本地,解压它
2. 进入解压后的redis目录
3. 执行`phpize`生成`configure`文件 *补充:可以通过find 命令查找phpize的位置,cofigure文件是用来检查当前环境,为编译做选择*
4. 编译前检查`./configure --with-php-config=/usr/local/php/bin/php-config`,指定php配置位置
5. 经过环境配置检查后会通过`autoconf`工具生成`Makefile`文件,之后执行`make && make install`进行编译安装
6. 编译安装后会生成`redis.so`动态链接库,然后在`php.ini`中添加`extension=redis.so`并重启fpm即可完成安装

