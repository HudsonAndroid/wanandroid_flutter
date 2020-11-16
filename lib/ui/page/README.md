# 页面配置
## Banner布局见Banner的介绍，此处略

## 首页加载更多实现方案
加载更多主要是根据是否是否滑动到底部，如果滑动到，则触发加载；另一方面用户可以主动点击“加载更多”触发。相关文章见
[检测ListView列表型Widget是否滑动到底部和顶部](https://medium.com/@diegoveloper/flutter-lets-know-the-scrollcontroller-and-scrollnotification-652b2685a4ac)

[加载更多方案](https://karthikponnam.medium.com/flutter-loadmore-in-listview-23820612907d)

### 注意：在后续优化改造中，使用SmartRefresher统一了所有加载页面，因此监听滑动到底部的加载更多方案已经弃用。不过在代码中保留了实现逻辑。

## 侧边栏
见[这篇文章](https://medium.com/@maffan/how-to-create-a-side-menu-in-flutter-a2df7833fdfb)

## 包结构说明
 - search包是与搜索功能相关的page页面
 - tree包是体系tab栏中的page页面
 - tree_tab_page是tree功能tab在APP首页BottomNavigationBar中的一项
 - article_page是所有包含文章列表页面的统一，支持下拉刷新，上拉加载更多，加载指示器（失败重试方案）等逻辑
 - common_tab_page是所有包含顶部tab栏页面的统一
 - home_page是主页， home_page_deprecated是未使用SmartRefresher实现的上拉加载更多的实现方案，未使用
 - login_page和register_page是登录和注册页面