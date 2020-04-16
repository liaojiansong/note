## 结构体
### 结构体定义方式
```c
// 第一种 基本结构体定义
struct Computer {
    char type[4];
    float price;
    int cores;
    char name[8];
};

// 第二种 定义后初始化
struct Computer {
    char type[4];
    float price;
    int cores;
    char name[8];
} computer1,computer2;

// 第三种 不给结构体命名
struct {
    char name[5];
    int age;
    float money;
} person1;

// 第四种 直接定义新的结构体类型
typedef struct {
    char name[5];
    int age;
    float price;
} Product;
// 声明结构体变量
Product product,products[10];

```

### 结构嵌套
```c
// 结构体嵌套
struct Student {
    char name[8];
    int age;
};
struct Class {
    char name[4];
    int code;
    int count;
    // 必须加struct
    struct Student top;
    // 结构体数组
    struct Student students[30];
};

// 结构体嵌套自己的指针类型
struct Node {
    int value;
    // 结构体不能嵌套自身,但可以嵌套自身的指针类型
//    struct Node node;
    struct Node *node;
};

```

### 结构体定以后初始化
```c
struct Company {
    char name[12];
    char address[32];
    int staff;
// 此处同时定义了三个结构体实例并初始化前两个
} company1 ={"jie-shen","guanzhou",190},company2 ={"lu"},company3;
```

### 结构体赋值与访问
```c
struct Book {
    int page;
    double price;
    char author[80];
    char name[120];
};

void echoBook(struct Book book);

// 地址符放在形式参数的前面
void echoBookLight(struct Book *book);

int main(){
    struct Book book;
    //结构体赋值
    book.page=500;
    book.price=56.8;
    // C语言中没有字符串类型,必须采用特殊函数对串进行赋值
    strcpy(book.author,"Jason");
    strcpy(book.name,"Dream");

    // 结构体访问
    printf("%d\n",book.page);
    printf("%s\n",book.name);
}
```
### 结构体作为函数参数(按值传递)
```c
struct Book {
    int page;
    double price;
    char author[80];
    char name[120];
};

void echoBook(struct Book book);

int main(){
    struct Book book={200,80.99,"Jason","Come Dream"};
    printf("初始化的book指针为=>%p\n", &book); //初始化的book指针为=>000000000061FD40
    echoBook(book);
}

// 结构体作为函数,按值传递
void echoBook(struct Book book){
    printf("函数内部book指针为=>%p\n", &book); //函数内部book指针为=>000000000061FC60
    printf("this book has %d page\n", book.page);
    printf("this book price is %f\n", book.price);
    printf("this book author is %s\n", book.author);
    printf("this book name is %s\n", book.name);
}
```

### 结构指针
```c
struct Book {
    int page;
    double price;
    char author[80];
    char name[120];
};

int main(){
    // 1.结构体
    struct Book book = {200, 80.99, "Jason", "Come Dream"};
    // 2.定义结构体指针
    struct Book *pbook;
    // 3.结构体指针赋值
    pbook = &book;
    // 4.利用指针访问成员

    // 4.1 利用*(按址取值)
    printf("%s",(*pbook).name); // (*pbook)根据地址拿到哪里存放的值
    // 4.2 利用->取值(推荐)
    printf("%s",pbook->name);

}

```
### 结构体指针作为参数
```c
struct Book {
    int page;
    double price;
    char author[80];
    char name[120];
};
// 预先声明 地址符放在形式参数的前面
void printBook(struct Book *book);

int main(){
    // 1.结构体
    struct Book book = {200, 80.99, "Jason", "Come Dream"};
    printBook(&book);
}

void printBook(struct Book *book){
    printf("%s", book->name);
}
```

### 共用体(Union)
1. 共用体指的是多个成员之间只能有一个成员占用内存空间,其他成员的值为垃圾值
2. 共用体最大内存空间为最大成员所占内存
3. 实践变成很少用,但可以用于判断大小端存储模式
```c
void main(){
    union Box {
        float price;
        int age;
        char name[8];
    } u1;
    printf("%llu\n", sizeof(u1));
    printf("%llu\n", sizeof(u1.price));
}
```

### typedef 自定义类型
1.用法
`typedef oldtype newtype` 给指定的数据类型定义别名
2. 举例
```c
// 定义int类型新的名称
typedef int myInt ;
// 定义结构体新的名称
typedef struct{char right;} myStruct;

void main(){
    // 没有类型别名之前我们需要反复写struct
    struct student{
        char name[10];
        float score;
    };
    
    struct student s;
    
    // 有了类型别名之后,我们就可以直接:类型 变量
    typedef struct {
        char name[10];
        float score;
    } myStudent;
    
    myStudent ms1;


}
```


