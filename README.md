# [PureJoy - Coding! Coding! Coding! (欢愉代码乐园)](https://jitpack.io/#dev.oom-wg/PureJoy-CCC)

> [!TIP]
> 此项目隶属于欢律遗愉系列，是 [SSU](https://ssu.oom-wg.dev) 的衍生项目

欢愉代码乐园是为了提供一些小功能而建立的项目

## 使用方法

确保`repositories`内有<https://jitpack.io>

```groovy
dependencyResolutionManagement {
    repositories {
        maven { url "https://jitpack.io" } // maven("https://jitpack.io")
    }
}
```

添加对应的依赖

```groovy
dependencies {
    implementation("dev.oom-wg.PureJoy-CCC:gendoki:-SNAPSHOT") // GenDoki
    implementation("dev.oom-wg.PureJoy-CCC:moesa:-SNAPSHOT") // MoeSa
}
```

## 功能列表

- `GenDoki`: 用于非常简单地配置用于初始化内容的内容提供器
- `MoeSa`: 用于在不传入任何参数的情况下通过`GenDoki`在软件启动时校验软件真实性
