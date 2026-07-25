# [Flutter SDK](https://app.niggergo.work/nga/flutter)

> NGA SDK - Flutter(Dart) SDK

Flutter SDK 部分主要提供一些 UI 组件

> [Pub 发布页面](https://pub-web.flutter-io.cn/packages/nga_sdk)
>
> [Dart API 文档](https://pub-web.flutter-io.cn/documentation/nga_sdk/latest/nga_sdk/)

主要分为如下功能:

* CU NGA 风格组件: `cu.dart`
* 类型拓展: `ext.dart`
* 开屏过渡动画: `splash.dart`
* 杂项工具: `tool.dart`
* 全屏水印 (可彩虹色): `watermark.dart`
* NGA 风格组件: `widget.dart`

## 引入依赖 [#引入依赖]

> [Pub 参考](https://pub-web.flutter-io.cn/packages/nga_sdk/install)

先添加依赖:

```shell
flutter pub add nga_sdk
```

然后直接 `import` 即可:

```dart
import 'package:nga_sdk/cu.dart'; // CU NGA 风格组件
import 'package:nga_sdk/nga.dart'; // 其他功能，也可单独 import 文件
```

## 使用方法 [#使用方法]

> 仅概述，详细内容请自行通过源码理解

### CU NGA 风格组件 [#cu-nga-风格组件]

* `CUHeadLabel`: CU 风格的文字标签
* `CUCard`: 简易的 CU NGA 风格卡片
* `CUProCard`: 支持更多自定义的 CU NGA 风格卡片
* `CUNavBar`: CU NGA 风格的侧边竖条导航栏
  * `CUNavBarGroup`: 导航栏组
  * `CUNavBarGroupSub`: 具体导航内容
* `CUTxtButton`: CU NGA 风格的文字按钮
* `CUWidget`: 将传入组件限制到合适大小
  * 颜色: CU NGA 风格组件要用到的颜色
  * 数值: CU NGA 风格组件要用到的填充、圆角等数值
  * `lightColorScheme`、`darkColorScheme`: CU NGA 风格的主题色配置

### 类型拓展 [#类型拓展]

* `let`: 类似于 Kotlin 的 `let`
* `ifEmpty`: 类似于 Kotlin 的 `ifEmpty`

### 开屏过渡动画 [#开屏过渡动画]

* `NGASplash.view`: 用于包裹页面
* `NGASplash.remove`: 暂时移除动画
* `NGASplash.removeAll`: 完全移除动画 (会额外清理资源)
* `NGASplash.show`: 再现动画
* `withLoadingView`: `Widget` 的类型拓展，用于简化 `NGASplash.view` 调用

### 杂项工具 [#杂项工具]

* `NGATool.isDesktop`: 通过 getter 判断当前平台是否是桌面平台

### 全屏水印 [#全屏水印]

* `NGAWatermark.add`: 添加全屏水印
* `NGAWatermark.remove`: 移除全屏水印

### NGA 风格组件 [#nga-风格组件]

* `NGAMsg.show`: NGA 风格的提示，从上往下弹出，从下往上收回
  * `NGAMsgType`: 提示类型

---

> [**Page Index**] <https://app.niggergo.work/llms.txt> | [**Full Content**] <https://app.niggergo.work/llms-full.txt>