# 常量

### 常量的定义

go语言中,常量是编译期间进行赋值的,所以不能修改 可见性遵循大小写原则,常量的特点如下

* 常量是编译的时候就确定好的,不能调用函数赋值
* 常量支持 `bool`,`int`,`complex`,`float32`, `string` 等类型
* 常量可以进行简单的算数运算(可以,但是没必要)

推荐方式 `` const name = "hello"`` (让编译器自动推断)

举例说明一下

```go
// 定义数字常量
const a int = 1
// 也可以不声明类型,编译的时候编译器会自动推断
const a1 = 2
// 定义浮点数
const f1 float32 = 3.14
// 定义字符串
const s string = "hello world"
// 定义bool 
const ok bool = false
// 定义指定类型为常量(前提,这个类型本身就是基本类型)
const d time.Duration  = 1
// 批量定义
const(
    x int = 1
    y = 2
    z = 3
)
// ....

```

### iota 常量生成器

* 只对 `const()`块有意义,单行语句无意义
* 第一个声明常量的行 `iota` 为0,此后的一次递增
* 不同的常量声明块互不干扰
* `_` 可以表示跳过,直接到下一个
* 空行和注释会被忽略
* 对`iota`进行加减会影响后续的
* 可以在同一行赋值多个常量,但他们的 `iota` 值是一样的

废话不多,上代码

```go
const (
	VERBOSE Level = iota // 0
	INFO                 // 1
	// 这里_ 表示跳过
	_       			// 2
	WARNING 			// 3
	ERROR   			// 4

	OVER = iota 		// 5
	// 基准改变了,会影响后续的
	HOT   = iota + 1 	// 7
	BOOM            	 // 8
	// 原理和 `_` 是一样的
	CLASS = "一年级"
	FIRE  				// 10
)

const (
	A int = iota		// 0
	B int = iota		// 1
	C int = iota + 1	// 3
	D 				   // 4
)

const (
    // 同一行赋值多个,但是值都是0
	a1, a2 int = iota, iota // 0,0
    // 后续的常量个数要与上一行保持一致
	b1, c1                  // 1,1
	d1, d2                  // 2,2
)
```

其中一个大坑

```go
const (
	a1, a2 int = iota, iota + 100 // 0,100
	b1, b2                        // 1,101
	c1, c2                        // 2,102
)
```

### 预定义常量

go语言预定义了一下几个常量

* true
* false
* iota

# 数据类型

## 布尔类型:bool

* true
* false



整型 :int

### 带符号的整型

* int8
* int16
* int32
* int64

### 不带符号位的整型(unsigned)

* uint8
* unit16
* unit32
* unit64

### 特殊整型

* int 32或64(根据平台决定)
* uintptr 用于存储指针

## 浮点型:float

* float32
* float64

 注意:浮点数自动推导时是float64

## 复数类型:complex

* complex64
* complex128

## 字符串类型:string

* string

## 字符类型:rune

* rune

ps: rune是int32的别名

## 错误类型:error

* error

## 复合类型

* 指针(pointer)  32位平台占用4个字节 64位占8个字节
* 数组(array)
* 切片(slice)
* 字典(map)
* 通道(chan)
* 结构体(struct)
* 接口(interface)

# 运算符

## 算数运算符

### 运算符如下

* +
* -
* *
* /
* %

### 注意:

1. 不同类型之间不能进行运算 例如`int32+int64`是无法通过编译的
2. `%`只能用于整数运算
3. 支持`+=`,`-=`之类的写法

## 比较运算符

参考php 没有什么特别的

### 注意

1. 不同类型的变量不能直接拿来比较

## 移位运算符

就是将数字转化为二进制,然后根据要求移动的位数去移动`1`

*  `>> n` 向右移动n位,等价于除以2^n
*  `<< n` 向左移动n位,等价于乘以2^n

上代码:

```go
var a int8 = 5
fmt.Printf("%08b\n",a) // 二进制的5是 00000101
// 执行左边移动3位,即(5*2^3)
a = a << 3 // 40
fmt.Printf("%08b\n",a) // 二进制的5是 00101000

var b int8 = 32
fmt.Printf("%08b\n",b) // 二进制的32是 00100000
// 执行右边移动4位,即(32/2^4)
b = b >> 4 // 2
fmt.Printf("%08b\n",b) // 二进制的2是 00000010
```



## 逻辑运算符

### 跟php类似,有以下几个

* `x && y`
* `x || y`
* `!y`

## 优先级



# 基本数据类型

## String(字符串)

### 字符串的本质

1. 官方定义:字符串是一组8位字节的所有字符串的，传统上，但不一定表示UTF-8编码的文本。 一个字符串可能是空的，但不是零。 字符串类型的值是不可改变的

2. string是引用类型,包含两个部分. 一部分是指针,指向底层数组. 一部分是字符串长度. 复制字符串其实是复制了和长度,底层数组么得改变
3. 字符串默认`UTF-8`编码,当字符为ASCII码时占用一个字节,其他字符占据2-4个字节,中文占据3个字节

### 字符串是值类型

字符串是值类型,一旦初始化就不可以改变

```go
str := "小松鼠"
// 尝试改变
str[0] = '大'
// 编译出错 cannot assign to str[0]
```

 注意：获取字符串中某个字节的地址属于非法行为，例如 `&str[9]`

### 字符串的操作

#### 获取字符串字节长度

```go
str := "hello 小松鼠"
println(len(str)) // 输出15

```

#### 获取字符串字符个数

思路:转换为rune切片然后取长度

```go
str := "hello 小松鼠"
fmt.Printf("%s里面有%d字\n",str,len([]rune(str)))
// 利用包的方法
fmt.Printf("%s里面有%d字\n",str,utf8.CountRuneInString(str))
```



#### 字符串连接

go语言中的字符串连接使用`+` 这一点和JavaScript一样

```go
str1 := "小"
str2 := "松"
str3 := str1+str2+"鼠"
```

#### 字符串切片

```go
str := "0123456"
str1 := str[:3] // 012
str2 := str[1:5] //1234
str3 := str[2:] // 23456
```

注意:字符串切片遵循左开右闭原则,即最后一位不包含,相当于`0<=n<6`的意思

*更多api参考string库*

### 字符串的遍历

#### 按照字节遍历(仅对ASCII码有意义)

```go
str := "hello小松鼠"
for i:=0;i<len(str);i++ {
    fmt.Println(str[i])
}
```

#### unicode进行遍历

index 表示这个字符开始于第几个字节,value指向这个字符的首地址

```go
str := "hello小松鼠"
for index,value := range str {
    fmt.Printf("第%d个字节开始,他的值为:%c\n",index,value)
}

	// 第0个字节开始,他的值为:h
	// 第1个字节开始,他的值为:e
	// 第2个字节开始,他的值为:l
	// 第3个字节开始,他的值为:l
	// 第4个字节开始,他的值为:o
	// 第5个字节开始,他的值为:小
	// 第8个字节开始,他的值为:松
	// 第11个字节开始,他的值为:鼠

```

#### 字符串遍历最佳实践(墙裂推荐)

先将字符串转化为rune类型切片再遍历输出

```go
str := "hello 小松鼠"
for index,value := range []rune(str) {
    fmt.Printf("第%d字符为:%c",index,value)
}
	// 第0字符为:h
	// 第1字符为:e
	// 第2字符为:l
	// 第3字符为:l
	// 第4字符为:o
	// 第5字符为:小
	// 第6字符为:松
	// 第7字符为:鼠

```



##  Array(数组)

### 数组的定义

go语言中的数组是固定长度,固定类型的,用[]type 表示

### 数组的声明和比较

1. 数组是由数据类型和长度两个构成
2. 只有数据类型和长度一致的数组才能进行比较

```go
// 普通声明
var num1 [2]int
num1 = [2]int{1,3}
// 声明即赋值(赋值的时候也要指明数组长度)
var num2 [2]int = [2]int{1,3}
var num2 = [2]int{1,2}
// 自推导
num3 := [...]int{1,3}
num4 := [3]{1,3,4}

//进行比较

fmt.Println(num1 == num2)  // true
fmt.Println(num1 == num3)  // false
fmt.Println(num1 == num4)  // 语法错误,长度不一致,不能直接比较


```

### 多维数组

```go
var a1[2][2] int // 二维数组
// 自推导三维数组
a2 := [...][2][2] int{
		{{1, 3}, {1, 3}},
		{{2, 4}, {2, 4}},
		{{3, 6}, {3, 6}},
}
```

### 访问数组元素

```go
a1 := [3]int{1,2,3}
// 下标必须在范围内,越界报错
println(a1[1]) // 输出:2
```

### 数组的遍历

```go
var nums [5]string
nums = [5]string{"a","b","c","d","e"}
// for 遍历法
for i:=0;i<len(nums);i++ {
    println(nums[i])
}
// for range 遍历法
for index,value := range nums {
    fmt.Printf("%d => %v\n",index,value)
}
```

### 修改数组元素

数组是引用传递,修改下标值不会创建新的内存空间

```go
a3 := [3]int{1,2,3}
fmt.Printf("修改前的指针%p\n",&a3) // 0xc00000c3e0
a3[2] = 100
fmt.Printf("%v\n", a3) // [1,2,100]
fmt.Printf("修改后的指针%p\n", &a3) //0xc00000c3e0

```



### 注意的点

* 数组长度定义之后不可修改
* 数组是值类型,传递时是通过值拷贝的形式
* 自推导(编译时推导)长度只能使用于第一维
* 一个数组只能存放一种类型的数据
* 数组长度是数组类型的一部分
* 数组访问越界会painc

## Slice(切片)

### 直接声明切片

```go
// 声明切片(没有分配内存)
var slice1 []int
fmt.Printf("slice1 的内存地址为%p\n",slice1) // slice1 的内存地址为0x0
// 声明并初始化
var slice2 []int = []int{}
fmt.Printf("slice2 的内存地址为%p\n", slice2) // slice2 的内存地址为0x595c18

var slice3 = []int{}
fmt.Printf("slice3 的内存地址为%p\n", slice3) // slice2 的内存地址为0x595c18

var slice4 = []int{}
fmt.Printf("slice3 的内存地址为%p\n", slice4) // slice2 的内存地址为0x595c18
```

注意: 初始化相同类型的空切片,指向的地址相同

### 声明并初始化切片

```go
var slice1 = []int{1,3,5}
slice2 := []int{1,3,5}
```

注意:采用直接创建的方式其实还是会在生成一个底层的匿名数组,只是用户无感知而已

### 切片的动态扩容

### 利用 `make` 创建切片

```go
var slice1 []int
slcie1 = make([]int,3,6) // 创建长度len=3,容量为6的切片
slcie2 = make([]int,3)   // 创建长度len=3,容量为3的切片,不指定容量则容量默认等于长度
fmt.Printf("%+v",slice1) // [0,0,0]
```

注意:make会初始化指定长度的类型零值

### 切片和切片不能直接比较,但可以nil进行比较

```go
var slice1 []int
var slice2 []int
fmt.Println(slice1 ==slice2) // invalid operation: slice1 == slice2 (slice can only be compared to nil)
fmt.Println(slice1 == nil) // true
```



### 创建数组切片的几种方法

#### 基于数组创建切片

```go
// 基于数组的切片
a := [...]int{2,3,4,5,6,7,8}
// 左开右闭原则
s1 := a[0:2] // [2,3]
s2 := a[:4]  // [2,3,4,5]
s3 := a[2:]  // [4,5,6,7,8]
s4 := a[:]   // [2,3,4,5,6,7,8]
```

数组切片底层引用了一个数组，由三个部分构成：指针、长度和容量，指针指向数组起始下标，长度对应切片中元素的个数，容量则是切片起始位置到底层数组结尾的位置，切片长度不能超过容量

#### 基于数组切片创建切片

```go
// 一定清楚切片是基于底层数组的
a := []int{2, 3, 4, 5, 6, 7, 8}
// 左开右闭原则
s_a_1 := a[1:5] 
s_b_1 := s_a_1[2:]
s_b_2 := s_a_1[2:6]
fmt.Printf("值为:%v  长度为:%d  容量为:%d\n", s_a_1, len(s_a_1), cap(s_a_1)) // [3,4,5,6,]  4  6
fmt.Printf("值为:%v  长度为:%d  容量为:%d\n", s_b_1, len(s_b_1), cap(s_b_1)) // [5,6]       2  4
fmt.Printf("值为:%v  长度为:%d  容量为:%d\n", s_b_2, len(s_b_2), cap(s_b_2)) // [5,6,7,8]   4  4
```



### 切片的动态扩容

```go
s1 := make([]int,2,10)
fmt.Printf("值为:%v  长度为:%d  容量为:%d\n", s1, len(s1), cap(s1)) // [0,0]; 2; 10
// 扩容方式一
s1 = append(s1,1,2,3)
fmt.Printf("值为:%v  长度为:%d  容量为:%d\n", s1, len(s1), cap(s1)) // [0,0,1,2,3];5;10
// 扩容方式二
temp := []int{4,5,6}
// 注意末位的展开符
s1 = append(s1,temp...)
fmt.Printf("值为:%v  长度为:%d  容量为:%d\n", s1, len(s1), cap(s1)) // [0,0,1,2,3,4,5,6];8;10
```

### 切片扩容后与底层数组关系

```go
	a1 := [4]int{1,2,3}
	s1 := a1[:3]
	fmt.Printf("第一次打印\n")
	fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1) // a1的值[1 2 3 0] 内存地址:0xc00005c140
	fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)  // s1的值[1 2 3] 内存地址:0xc00005c140
	// 进行扩容
	fmt.Printf("第二次打印（扩容）\n")
	s1 = append(s1,6)
	fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1) // a1的值[1 2 3 6] 内存地址:0xc00005c140
	fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)  // s1的值[1 2 3 6] 内存地址:0xc00005c140
	// 对a1再次进行改变，推测地址变化：S1 不变，a1变
	a1[0] = 100
	fmt.Printf("第三次打印（修改底层数组）\n")
	fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1) // a1的值[100 2 3 6] 内存地址:0xc00005c140
	fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)  // s1的值[100 2 3 6] 内存地址:0xc00005c140

	// 再次扩容 推测：s1的地址改变
	fmt.Printf("第四次打印（扩容）\n")
	s1 = append(s1, 7)
	fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1) //a1的值[100 2 3 6] 内存地址:0xc00005c140
	fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)  //s1的值[100 2 3 6 7] 内存地址:0xc000074100
	// 修改a1值，这是s1无变化，修改s1值，a1无变化
	a1[1]=200
	fmt.Printf("第五次打印（修改a1,s1）\n")
	s1[2] = 300;
	fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1) //a1的值[100 200 3 6] 内存地址:0xc00005c140
	fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)  //s1的值[100 2 300 6 7] 内存地址:0xc000074100

	// TODO 假设底层数组长度为L1，切片长度为L2(从0开始切)，那么在切片再L1-L2范围内的扩容对底层数组都属于引用类型（即切片改变底层数组也会改变）
	// TODO 一旦切片扩容超过了底层数组的长度，那么会开辟一片新的内存保存扩容的切片，对底层数组彻底脱钩
```

总结:

* 假设底层数组长度为L1，切片长度为L2(从0开始切)，那么在切片再L1-L2范围内的扩容对底层数组都属于引用类型（即切片改变底层数组也会改变）
* 一旦切片扩容后的长度L2超过了底层数组的长度L1，那么会开辟一片新的内存保存整个扩容后的切片，此时新的切片底层数组彻底脱钩(即新的切片改变,原底层数组也不会变)

### 切片是引用类型

```go
a1 := [5]int{1, 2, 3, 4, 5}
// 直接复制拷贝
a2 := a1
// 基于数组切片
s1 := a1[:2]

fmt.Printf("第一次打印\n")
fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1)
fmt.Printf(" a2的值%v 内存地址:%p\n", a2, &a2)
fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)
//第一次打印
// a1的值[1 2 3 4 5] 内存地址:0xc000082030
// a2的值[1 2 3 4 5] 内存地址:0xc000082060
// s1的值[1 2]       内存地址:0xc000082030

// 修改数组的一个值，看看其他变量的变化
a1[0] = 600
fmt.Printf("第二次打印\n")
fmt.Printf(" a1的值%v 内存地址:%p\n", a1, &a1)
fmt.Printf(" a2的值%v 内存地址:%p\n", a2, &a2)
fmt.Printf(" s1的值%v 内存地址:%p\n", s1, s1)
//第二次打印
// a1的值[600 2 3 4 5] 内存地址:0xc000082030
// a2的值[1 2 3 4 5]   内存地址:0xc000082060
// s1的值[600 2]       内存地址:0xc000082030

// todo 造成这种情况的原因是 数组是值类型，赋值和传参会复制整个数组。因此改变副本的值，不会改变源头的值。
// todo 数组是值 a2 := a1 这时a2 开辟了一片新的内存空间
// todo 切片是引用类型，可以看到a1和s1都指向同一片内存地址，所以a1改变的时候，s1也会跟着改变
// todo 另外我们注意到，打印数组时要&符号才显示内存地址，而打印切片的时候却不用，侧面的证明了切片是引用类型
```

总结:

* 数组是值类型，赋值和传参会复制整个数组。因此改变副本的值，不会改变源头的值。
* 数组是值类型 ,进行 a2 := a1操作后,这时a2 开辟了一片新的内存空间
* 切片是引用类型，可以看到a1和s1都指向同一片内存地址，所以a1改变的时候，s1也会跟着改变
* 打印数组时要&符号才显示内存地址，而打印切片的时候却不用，侧面的证明了切片是引用类型
* 前提是s1依然基于底层数组a1,容量没有超出a1容量

### 切片的复制

废话不多说,直接上代码

```go
src := []int{1,2,3,4,5,6,7,8,9}
des := make([]int,6)

fmt.Printf("源切片地址%p\n",src) 	//源切片地址0xc0000660f0
fmt.Printf("目标切片地址%p\n",des)   //目标切片地址0xc00008a030

count := copy(des, src)  // 返回复制元素的个数
fmt.Printf("复制元素个数为:%v\n", count) //复制元素个数为:6
fmt.Printf("目标元素:%+v\n",des)   //目标元素:[1 2 3 4 5 6]

des[0] = 999
fmt.Printf("源元素%+v\n", src)  // 源元素 [1 2 3 4 5 6 7 8 9]
fmt.Printf("修改后的目标元素%+v\n", des)  // 修改后的目标元素[999 2 3 4 5 6]
```



### 切片的遍历

切片的遍历与数组基本一致,多说无益

## Map(哈希表)

### 几个需要注意的点

* map 引用类型
* map 的只能和nil进行比较
* map 是无序的(但官方做到了有序输出)
* map 是线程不安全的,并发状态的写会产生竞争

### map 是引用类型

意味着使用和修改时,不需要取值符&和按地址取值*,直接操作即可

```go
m4 := make(map[string]int,10)
m4["小明"] = 10
m4["小红帽"] = 11
m4["小绿帽"] = 12
// 此处没有用取地址符
fmt.Printf("map 是引用类型%p",m4) // map 是引用类型0xc00005a3301
```



### 判断map键存在

```go
var m = map[string]int{"小红":12,"小绿":16}
value,ok := m["小绿"]
if ok {
    fmt.Printf("小绿的年龄为:%v\n",value)
}
```

### 删除键值对(delete)

删除键值对用delete方法,删除一个不存在的键不会有任何副作用

```go
var m = map[string]int{"小红":12,"小绿":16}
delete(map,"苏打绿")
```

### Map 的遍历

```go
m := map[string]int{"小明":12,"小红红":13,"小绿绿":14}
for key,value := range m {
    fmt.Printf("%s=>%d\n",key,value)
}
```

###  sync.Map (线程安全的Map)

```
var safeM sync.Map
safeM.Store("name","pig")
load, ok := safeM.Load("name")
safeM.Delete("name")
safeM.Range(func(key, value interface{}) bool {
return false
})
```

## List(列表)

在Go语言中，列表使用 container/list 包来实现，内部的实现原理是双链表，列表能够高效地进行任意位置的元素插入和删除操作。

```go
l := list.New()
// 尾部添加
l.PushBack("canon")
// 头部添加
l.PushFront(67)
// 尾部添加后保存元素句柄
element := l.PushBack("fist")
// 在fist之后添加high
l.InsertAfter("high", element)
// 在fist之前添加noon
l.InsertBefore("noon", element)
// 使用
l.Remove(element)
```

## Nil(空)

### nil 不能直接比较

```go
nil == nil //invalid operation: nil == nil (operator == not defined on nil)
```

### nil 既不是保留字也不是关键字

```go
var nil == [2]int{1,3} // 正常编译通过
```

### nil 没有类型

```go
fmt.Printf("%T\n",nil) // <nil>
```

### 不同类型的nil指针都指向空地址

```go
var slice1 []int
var map1 map[string]int
fmt.Printf("%p\n",slice1) // 0x0
fmt.Printf("%p\n",map1)   // 0x0
```

### 以下几种类型的零值是nil

1. slice
2. map
3. func
4. *struct
5. interface
6. chan
7. pointer

# 关键字
### defer

#### 几个关键的要领

* `defer` 后面的函数都是值传递,在`defer` 声明后就已经装载进`_defer`结构体当中
* `defer` 背后是一个栈结构(先进后出),依附于goroutine

#### 为什么我们需要 `defer`

defer 最大的功能是 Panic 后依然有效。如果没有 defer，Panic 后就会导致 unlock 丢失，从而导致死锁了




# 基本数据类型的转换

## 数值类型的转换

### 低位整数转高位

```go
	var n1 int8
	n1  = 120
	fmt.Printf("类型为:%T 值为:%v\n",n1,n1) // 正常
	n2 := int16(n1)
	fmt.Printf("类型为:%T 值为:%v\n", n2, n2) // 正常
	n3 := -688
	n4 := int8(n3)
	fmt.Printf("类型为:%T 值为:%v\n", n4, n4) // 产生截断
	n5 := uint(n3)
	fmt.Printf("类型为:%T 值为:%v\n", n5, n5) // 溢出,unit不支持负数
```

### 浮点数转整数会丢失小数位

```go
v1 := 99.99
v2 := int(v1)  // v2 = 99
```

### 字符串和其他类型转换

#### 整数转字符串,go会根据**Unicode编码10进制** 找到对应的字符

```go
v1 := 65
// 到Unicode表中根据十进制找到A
v2 := string(v1)  // v2 = A

v3 := 30028
v4 := string(v3)  // v4 = 界
```

#### 将字节数组或者 `rune`（Unicode 编码字符）数组转化为字符串：

```go
v1 := []byte{'h', 'e', 'l', 'l', 'o'}
v2 := string(v1)  // v2 = hello

v3 := []rune{0x5b66, 0x9662, 0x541b}
v4 := string(v3)  // v4 = 学院君
```

## 利用[strconv](https://godoc.org/strconv)包

### 字符串和整型之间的转化

```go
// 字符串数字转整型
score := "90"
// a 代表字符串 i代表 int
Iscore,err1 := strconv.Atoi(score)
if err1 == nil {
	fmt.Printf("转换后的类型为%T 值为%v\n",Iscore,Iscore)
	// 返回类型就是字符串,因为任意整型都可以转化为字符串,所以没有错误返回
	Sscore := strconv.Itoa(Iscore)
	fmt.Printf("转换后的类型为%T 值为%v\n", Sscore, Sscore)
}
```

### 字符串转布尔类型

```go
// 字符转布尔类型
l := []string{"1","0","t","f","T","F","true","false","True","False","TRUE","FALSE"}
for _, value := range l {
	b,err := strconv.ParseBool(value)
	if err == nil {
		println(b)
	}
}
```



# 函数

在函数调用时，切片（slice）、字典（map）、接口（interface）、通道（channel）这样的引用类型 默认使用引用传参

### 函数参数传递方式

- 传值：函数调用时会对参数进行拷贝，被调用方和调用方两者持有不相关的两份数据；
- 传引用：函数调用时会传递参数的指针，被调用方和调用方两者持有相同的数据，任意一方做出的修改都会影响另一方。

举例说明

```go
type Person struct {
	name string
}

func main() {
    // 切片=> 传引用
	var books = []string{"TCP/IP", "大话数据结构"}
	fmt.Printf("内存地址:%p\n", books)
	show(books)

    // map => 传引用
	var food = map[string]string{"苹果": "酸的"}
	fmt.Printf("内存地址:%p\n", food)
	eat(food)
	// struct => 传引用
	var p = Person{"马云"}
	fmt.Printf("内存地址:%p\n", &p)
	intuition(p)
    
    // 接口 => 传值
    var desk interface{}
	desk = "大书桌"
	fmt.Printf("内存地址:%p\n", &desk)
	what(desk)
    
    // 其他基本数据类型 => 传值

}

func show(books []string) {
	fmt.Printf("内存地址:%p\n", books)
}

func eat(food map[string]string) {
	fmt.Printf("内存地址:%p\n", food)
}

func intuition(p Person) {
	fmt.Printf("内存地址:%p\n", &p)
}

func what(w interface{}) {
	fmt.Printf("内存地址:%p\n", &w)
}
```



### 函数需要关注的几个点

1. 函数是代码封装复用的一种形式
2. 可以利用return 结束函数,for循环,goroutine

### 函数的几种类型
1. 普通函数
2. 匿名函数
3. 方法

#### 函数也是一种类型
以下示例将函数赋值给一个变量,然后执行他
```go
func add(a int,b int)(int){
    return a+b
}
func main(){
    // 定义一个这种类型
    var f func(a int,b int) (int)
    f = add   
    fmt.Printf(f(1,2)))
}
```
#### 匿名函数
匿名函数是一种没有名字的函数,可以立即定义立即使用,也可以赋值给变量,重复调用

* 立即调用

```go
func main(){
    func(msg string){
        fmt.Println(msg)
    }("小虾米")
}
```

* 赋值给变量

```go
func main(){
    var f func(a,b int)(int)
    f = func(a,b int)(int){
        return a+b
    }
    println(f(1,2))
    println(f(2,3))  
}
```

* 或者直接作为函数参数

```go
func main(){
    var list =  []string{"小明","肖鸿飞","董佳敏"}
    // 当匿名函数作为函数参数时候,一定要符合要求
    show(list,func(value string){
        fmt.Println(value)
    })
    
    
    foods := map[string]string{"苹果":"酸的","冰棍":"真香"}
    eat(foods,func(name,desc string){
        fmt.Printf("我想说%s:%s\n",name,desc)
    })
}
// 声明一个函数,第一个参数是切片,第二个参数是特定的函数类型
func show(list []string,foo func(name string)){
    for _,value :=range list{
        foo(value)
    }
}

func eat(foods map[string]string,action func(name,desc string)){
    for index,desc := range foods{
        action(index,desc)
    }
}
```



# 结构体

## 指针方法

## 值方法



## GMP

名词解释:

* G 代表gorotuine
* M 代表线程
* P 代表调度器











