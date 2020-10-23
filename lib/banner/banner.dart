
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wanandroid_flutter/banner/banner_item.dart';

///
/// item点击
///
typedef void OnBannerItemClick(int position, BannerItem entity);

///
/// 自定义Banner主体内容部分，默认展示图片
///
typedef Widget BannerContent(int position, BannerItem entity);

class Banner extends StatefulWidget{
  final List<BannerItem> banners;
  final int duration;
  final double indicatorRadius;
  final Color focusColor;
  final Color normalColor;
  final Color textBgColor;
  final bool isHorizontal;
  final OnBannerItemClick itemClickListener;
  final BannerContent bannerContent;

  // 除了banners外，其他参数均可选
  Banner(this.banners, {
    Key key,
    this.duration = 5000,
    this.indicatorRadius = 3.0,
    this.focusColor = Colors.red,
    this.normalColor = Colors.white,
    this.textBgColor = const Color(0x99000000),
    this.isHorizontal = true,
    this.itemClickListener,
    this.bannerContent
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => BannerState();
}

const INT_MAX_COUNT = 0x7fffffff;

class BannerState extends State<Banner>{
  Timer _timer;
  int currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    int current = (widget.banners.length >0
        ? (INT_MAX_COUNT /2) - ((INT_MAX_COUNT /2) % widget.banners.length)
        : 0).toInt();
    _pageController = PageController(initialPage: current);
    startAutoSwitch();
    super.initState();
  }

  startAutoSwitch() {
    stopAutoSwitch();// cancel the last Timer
    _timer = Timer.periodic(Duration(milliseconds: widget.duration), (timer) {
      if(widget.banners.length > 0 && _pageController.page != null){
        /// 如果直接把地址和标题放入Banner中，在部分设备上需要手点击控件后，才能正常，原因暂时未知
        _pageController.animateToPage(_pageController.page.toInt() + 1,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    });
  }

  stopAutoSwitch() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopAutoSwitch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用AspectRatio保证一定宽高比， 注意前面是宽，后面是高
    // see https://www.youtube.com/watch?v=XcnP3_mO_Ms
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Container(
        color: Colors.black12,
        child: Stack(
          children: <Widget>[
            // banner的图片
            getViewPager(),
            // 空隙
            Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  color: widget.textBgColor,
                  // banner的标题
                  child: getBannerTextInfo(),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  // Banner的图片视图
  Widget getViewPager() {
    return PageView.builder(
        itemCount: widget.banners.length > 0 ? INT_MAX_COUNT : 0,
        controller: _pageController,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              if(widget.itemClickListener != null){
                widget.itemClickListener(currentIndex, widget.banners[currentIndex]);
              }
            },
            child: widget.bannerContent == null
                ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.banners[index % widget.banners.length].imagePath,
                      fit: BoxFit.fill,
                  )
                : widget.bannerContent(index, widget.banners[index % widget.banners.length])
          );
        });
  }

  // Banner的标题视图
  Widget getBannerTextInfo() {
    if(widget.isHorizontal){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // 文本部分
          Expanded(
            flex: 1,
            child: getSelectedText(),
          ),
          // 指示器部分
          Expanded(
            flex: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: indicators(),
            ),
          )
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getSelectedText(),
          IntrinsicWidth(
            child: Row(
              children: indicators(),
            ),
          )
        ],
      );
    }
  }

  List<Widget> indicators(){
    List<Widget> indicators = [];
    for(var i = 0; i < widget.banners.length; i++) {
      indicators.add(Container(
        margin: EdgeInsets.all(2.0),
        width: widget.indicatorRadius * 2,
        height: widget.indicatorRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == i
            ? widget.focusColor
              : widget.normalColor
        ),
      ));
    }
    return indicators;
  }

  Widget getSelectedText() {
    return widget.banners.length > 0 && currentIndex < widget.banners.length
          ? widget.banners[currentIndex].text : Text('');
  }

  onPageChanged(index) {
    currentIndex = index % widget.banners.length;
    setState(() {});
  }

}