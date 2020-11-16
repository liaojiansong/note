### simple data structure

#### Reverse single list(单链表翻转)

单向链表翻转,关键要点:

1. 要用临时变量保存下一个结点,避免丢失
2. 注意结点交换顺序
3. 循环结束后,更新链表头指针

```go
package main

import (
	"fmt"
)

func main() {
	list := InitList()
	list.Add(1)
	list.Add(2)
	list.Add(3)
	list.Add(4)
	list.Add(5)
	list.Add(6)
	list.Display()
	list.Reverse()
	list.Display()
}

type List struct {
	head *Node
}

type Node struct {
	value int
	next  *Node
}

func InitNode(value int) *Node {
	return &Node{value: value}
}
func InitList() *List {
	return &List{}
}

func (l *List) Add(value int) {
	node := InitNode(value)
	node.next = l.head
	l.head = node
}

func (l *List) Reverse() {
	curr := l.head
	// 创建一个虚节点
	var prev *Node
	for curr != nil {
		// 临时保存当前节点的下一个节点,不然执行后续操作后就丢失了
		temp := curr.next
		curr.next = prev
		prev = curr
		curr = temp
	}
    // 注意替换头结点
	l.head = prev
}

func (l *List) Display() {
	dump(l.head)
}

func dump(node *Node) {
	fmt.Printf("%d->", node.value)
	if node.next != nil {
		dump(node.next)
	} else {
		fmt.Printf("\n")
	}
}
```

#### LRU cache(最近最少缓存)

最近最少使用算法,关键要求

1. 容量确定,末位淘汰
2. 最近访问的靠前
3. 双向链表和哈希表配合使用
4. 链表带有前后哨兵结点,降低难度

以下是代码实现

```go
package main

func main() {
	list := initList(3)
	list.Put("a", 0)
	list.Put("b", 0)
	list.Put("c", 0)
	list.Put("d", 0)
	list.Put("e", 0)
	list.Get("c")
	list.Get("d")

}

type Node struct {
	key  string
	val  int
	prev *Node
	next *Node
}

type List struct {
	len  int
	cap  int
	head *Node
	tail *Node
	box  map[string]*Node
}

func initNode(key string, val int) *Node {
	return &Node{
		key: key,
		val: val,
	}
}

func initList(cap int) *List {
	l := &List{
		cap:  cap,
		len:  0,
		head: initNode("header", 0),
		tail: initNode("tailer", 0),
		box:  make(map[string]*Node, cap),
	}
	l.head.next = l.tail
	l.tail.prev = l.head
	return l
}

func (l *List) addAtHead(node *Node) *Node {
	node.next = l.head.next
	node.prev = l.head
	l.head.next.prev = node
	l.head.next = node
	l.len++
	return node
}

func (l *List) remove(node *Node) *Node {
	node.prev.next = node.next
	node.next.prev = node.prev
	l.len--
	return node
}

func (l *List) removeTail() *Node {
	node := l.remove(l.tail.prev)
	return node
}

func (l *List) moveToHead(node *Node) {
	l.remove(node)
	l.addAtHead(node)
}

func (l *List) Put(key string, val int) {
	node, ok := l.box[key]
	if ok {
		// 有就更新并移到队头
		node.val = val
		l.box[key] = node
		l.moveToHead(node)
	} else {
		// 没有就新增
		node = initNode(key, val)
		l.addAtHead(node)
		l.box[key] = node
		// 超出末位淘汰
		if l.len > l.cap {
			t := l.removeTail()
			delete(l.box, t.key)
		}
	}
}

func (l *List) Get(key string) int {
	node, ok := l.box[key]
	if ok {
		// 移到队头
		l.moveToHead(node)
		return node.val
	} else {
		return 0
	}
}

```

实现要点和需要注意的地方

1. 要有前后哨兵结点,插入操作始终位于头部
2. 初始化链表时,需要头尾结点相互指向,并初始化map
3. 结点前后指针交换时要注意顺序,先后再前,避免丢失指针
4. put的时候需要做容量判断和map更新,删除,移动到头结点

















