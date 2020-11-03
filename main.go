package main

import (
	"fmt"
	"log"
)

func main() {

	fmt.Println(f4())
	fmt.Println(f5())
	fmt.Println(f6())
	fmt.Println(f7())


	// 谨记两点原则
	// 原则一 注册defer函数时,用的是值传递
	// 原则二 函数返回不是原子操作,而是分为两步
	// 步骤一 返回值 = xxx
	// 步骤二 调用defer
	// 步骤三 return
	func() {
		defer log.Println("defer.EDDYCJY.")
	}()

	log.Println("main.EDDYCJY.")

}

func f1() {
	for i := 0; i < 5; i++ {
		defer fmt.Println(i) // 4 3 2 1
	}
	fmt.Println("手动换行")

}

func f2() {
	for i := 0; i < 5; i++ {
		// 这是一个闭包,i 具有记忆效应
		defer func() {
			fmt.Println(i) //  4 3 2 1
		}()
	}
	fmt.Println("手动换行")

}

func f3() {
	for i := 0; i < 5; i++ {
		defer func(n int) {
			fmt.Println(n) // 4 3 2 1
		}(i)
	}
	fmt.Println("手动换行")
}

func f4() int {
	t := 5
	defer func() {
		t++
	}()
	return t // 5
}

func f5() (r int) {
	defer func() {
		r++
	}()
	return 0 // 1
}

func f6() (r int) {
	t := 5
	defer func() {
		t = t + 5
	}()

	return t // 5
}

func f7() (r int) {
	defer func(i int) {
		i = i + 5
	}(r)
	return 1 // 1
}
