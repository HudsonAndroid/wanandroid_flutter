# wanandroid_flutter

wanandroid flutter version

## [Banner实践](/lib/ui/banner)

## 嵌套滚动型Widget处理方案（首页）
利用Slivers完成，相关信息见[medium的这篇文章](https://medium.com/flutter/slivers-demystified-6ff68ab0296f)

## 国际化
国际化使用了[Flutter Intl](https://plugins.jetbrains.com/plugin/13666-flutter-intl) 插件，详情见插件介绍和使用方法。
注意：

   包结构中，generated是国际化插件生成的文件，不要修改；

   我们需要增加国际化字段的地方在/lib/l10n中；

   增加新语言和其他操作，见插件介绍。

## 性能优化
在Flutter中由于存在大量的嵌套，导致代码可阅读性大大降低，同时增加代码混乱度。为此，我们经常想到的办法是将部分代码抽取出来
作为一个方法或者函数，亦或者抽取成一个单独的类。然而在Flutter中，如果在StatefulWidget中把代码抽取成一个单独的方法，有可能
造成不必要的重复构建，具体原因见[这篇文章](https://iiro.dev/2018/12/11/splitting-widgets-to-methods-performance-antipattern/),
为此，我们需要把有状态的小部件中固定的代码抽取成一个StatelessWidget，并借助[const](https://stackoverflow.com/questions/21744677/how-does-the-const-constructor-actually-work)的构造方法（函数）以避免重复构建。

## 刷新和加载更多组件
系统为我们提供了RefreshIndicator来提供下拉刷新的功能，但一般情况下，我们列表页面还需要支持上拉加载更多的选项，因此选择了SmartRefresher。
（备注：代码中保留了通过监听列表底部来触发加载更多的逻辑代码，见[HomePageDeprecated](/lib/ui/page/home_page_deprecated.dart) ）
SmartRefresher新版本比旧版本优化了很多，例如旧版本中加载的文本提示都是英文的，需要我们重新配置以支持国际化，新版本中已经完全包含了国际化的
处理（具体参考其内部源码的classic_indicator中逻辑包含有RefreshLocalizations）。不过，该库需要我们在APP根widget中配置语言信息，具体见
main.dart和该库的refresh_localizations.dart说明。
使用SmartRefresher后，列表加载到底部后，我们不再需要手动监听滑动到底部的事件了，直接使用SmartRefresher的onLoading来加载更多数据。
代码中的经典示例见[统一加载刷新页面](/lib/ui/common/page_wrapper.dart)和具体实现[HomePage](/lib/ui/page/home_page.dart)。


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
