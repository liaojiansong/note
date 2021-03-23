# Linux 文件系统

在linux 中一切皆文件,以下是几个重要的概念

### 文件描述表

内核会为每一个**进程**维护一个 **文件描述表(file description)**,表长下面这个样子:

| flags(控制位,就是一个正整数) | file_ptr(打开文件描述指针) |
| ---------------------------- | -------------------------- |
| 4                            | 0X8894                     |
| 7                            | 0X8899                     |

其中控制位一般会从小到大分配

### 打开文件表

内核会对所有打开的文件维护一个系统级的**打开文件描述表(Open file  description table)**

| file_prt | flag/status | inode_ptr |
| -------- | ----------- | --------- |
|          |             |           |



### I-node 表

文件系统会为存储的文件和目录维护一个inode 表,表结构如下:

| inode_ptr | 类型 | 权限 | block | 创建时间 | ...  |
| --------- | ---- | ---- | ----- | -------- | ---- |
|           |      |      |       |          |      |




































