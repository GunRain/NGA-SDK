# Go

Go 部分主要提供一些功能与辅助函数

主要分为如下功能:

- 日志记录: `logger.go`
- 文件操作: `io.go`
- 网络文件: `http.go`

## 引入依赖

### 本地依赖

在 `go.mod` 中通过 `replace` 指向本地路径，并通过 `require` 添加依赖

```mod title="示例"
replace app.niggergo.work/sdk/nga => path/nga/src/go

require app.niggergo.work/sdk/nga v0.0.0
```

### 远程依赖

通过命令行添加依赖:

```shell
go get -u app.niggergo.work/sdk/nga@latest
```

### 使用依赖

直接 `import` 即可:

```go
import "app.niggergo.work/sdk/nga"
```

## 使用方法

> 仅概述，详细内容请自行通过源码理解

### 日志记录

> 该功能主要实现与 [CU Logger](https://github.com/chenzyadb/CU-Utils) 类似的功能

:::tip
为确保适配 Android 系统，默认会引入 `time/tzdata`，会略微增加编译后大小
:::

- `Logger`: 记录器类型
  - `LogLevel`: 日志等级
  - `LastLogLevel`: 最后一个日志的日志等级
  - `OutputMode`: 输出模式
  - `TimeLoc`: 时区
  - `TimeFmt`: 时间格式化
  - 函数 `LogX`: 对应类型的日志输出
  - 函数 `Flush`: 等待日志输出完毕
  - 函数 `Close`: 关闭记录器 (会调用 `Flush`)
- `LogLevel`: 日志等级
  - `LOG_NONE`: `?` (正常使用中不应当使用，仅代表最后一次日志的占位符)
  - `LOG_ERROR`: `E`
  - `LOG_WARN`: `W`
  - `LOG_INFO`: `I`
  - `LOG_DEBUG`: `D`
  - `LOG_VERBOSE`: `V`
- `LogMode`: 日志模式
  - `LOG_APPEND`: 追加模式
  - `LOG_TRUNC`: 清空模式
- `LogOutput`: 输出模式
  - `LOG_PRINT`: 仅打印
  - `LOG_FILE`: 仅写入文件
  - `LOG_ALL`: 全部

### 文件操作

- `PathExist`: 判断文件存在
- `MoveFile`: 移动单个文件 (支持跨文件系统，会保持文件时间一致)
- `IsDir`: 判断路径是目录
- `IsEmptyDir`: 判断路径是空目录
- `IsFile`: 判断路径是文件
- `IsEmptyFile`: 判断路径是空文件
- `IsHiddenPath`: 判断路径是隐藏路径 (路径中包含 `.` 开头路径)
- `CopyFile`: 复制单个文件 (会保持文件时间一致)
- `CopyDir`: 复制目录 (会保持文件/目录时间一致)

### 网络文件

该功能实现了一个有 `ReadAt` 函数的 `HttpReader` 类型
