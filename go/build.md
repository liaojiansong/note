#### 交叉编译
##### 编译linux平台
```go
SET CGO_ENABLED=0
SET GOOS=linux
SET GOARCH=amd64
go build main.go -o myself
```

