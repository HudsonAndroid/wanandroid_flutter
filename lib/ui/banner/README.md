# flutter Banner实现
自定义Banner实现，位于banner包下。ui.banner.dart是实现的主体部分，banner_item是banner某个项的抽象实例，负责携带图片和标题信息。

Banner是一个有状态的widget，由BannerState控制。在BannerState中返回了实际的Banner视图，由一个PageView和Align构成布局，外部利用Stack（类似于
android中的FrameLayout布局）并结合Align的alignment属性，将文本标题对齐Stack的底部（也就相当于图片的底部）。


## 宽高比保证
使用AspectRatio实现，见[官方视频](https://www.youtube.com/watch?v=XcnP3_mO_Ms)

## 目前存在问题，部分设备上首次不会自动滚动（排查发现是如果不通过网络获取，直接塞图片地址和内容显示时，红米设备上出现不会自动滑动问题，但是Timer逻辑
## 已经执行到了。后面通过网络获取接入后，该设备上也恢复正常，因此怀疑是Widget初始化机制导致。）