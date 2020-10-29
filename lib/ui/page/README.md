# 页面配置
## Banner布局见Banner的介绍，此处略

## 首页加载更多实现方案
加载更多主要是根据是否是否滑动到底部，如果滑动到，则触发加载；另一方面用户可以主动点击“加载更多”触发。相关文章见
[检测ListView列表型Widget是否滑动到底部和顶部](https://medium.com/@diegoveloper/flutter-lets-know-the-scrollcontroller-and-scrollnotification-652b2685a4ac)

[加载更多方案](https://karthikponnam.medium.com/flutter-loadmore-in-listview-23820612907d)

### 注意：在后续优化改造中，使用SmartRefresher统一了所有加载页面，因此监听滑动到底部的加载更多方案已经弃用。不过在代码中保留了实现逻辑。

## 侧边栏
见[这篇文章](https://medium.com/@maffan/how-to-create-a-side-menu-in-flutter-a2df7833fdfb)