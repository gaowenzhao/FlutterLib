import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void OnBannerClickListener(int index, dynamic itemData);
typedef void OnPageChanged(int index);
typedef Widget BuildShowView(int index, dynamic itemData);

const IntegerMax = 0x7fffffff;

class BannerView extends StatefulWidget {
  final OnBannerClickListener onBannerClickListener;

  //延迟多少秒进入下一页
  final int delayTime; //秒
  //滑动需要秒数
  final int scrollTime; //毫秒
  final double height;
  final List data;
  final BuildShowView buildShowView;
  final OnPageChanged onPageChanged;
  BannerView({Key key,
    @required this.data,
    @required this.buildShowView,
    this.onPageChanged,
    this.onBannerClickListener,
    this.delayTime = 3,
    this.scrollTime = 200,
    this.height = 200.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new BannerViewState();
}

class BannerViewState extends State<BannerView> {
  Timer timer;
  int selectIndex;
  PageController pageController;
  @override
  void initState() {
    super.initState();
    var initPage = IntegerMax ~/ 2;
    pageController = new PageController(initialPage: initPage);
    selectIndex =initPage% widget.data.length;
    resetTimer();
  }

  resetTimer() {
    clearTimer();
    timer = new Timer.periodic(
        new Duration(seconds: widget.delayTime), (Timer timer) {
      if (pageController.positions.isNotEmpty) {
        var i = pageController.page.toInt() + 1;
        pageController.animateToPage(i == 3 ? 0 : i,
            duration: new Duration(milliseconds: widget.scrollTime),
            curve: Curves.linear);
      }
    });
  }

  clearTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

   ///下面的小圆点
  Widget _buildCircleIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < widget.data.length; i++) {
      indicators.add(Container(
          width: 6.0,
          height: 6.0,
          margin: EdgeInsets.symmetric(horizontal: 1.5, vertical: 10.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i==selectIndex?Colors.white:Colors.grey)));
    }
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indicators),
    );
  }
  ///banner
  Widget _buildPageView(){
   return PageView.builder(
      onPageChanged: (index){
        setState(() {
          selectIndex = index% widget.data.length;
          print("onPageChanged:selectIndex=$selectIndex");
        });
        widget.onPageChanged(selectIndex);
      },
      controller: pageController,
      physics: const PageScrollPhysics(
          parent: const ClampingScrollPhysics()),
      itemBuilder: (BuildContext context, int index) {
        var realIndex = index % widget.data.length;
        return widget.buildShowView(
            index, widget.data[realIndex]);
      },
      itemCount: IntegerMax,
    );
  }
  //文本指示器
  Widget _buildTextIndicator(){
   return Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 60.0,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 1.0),
        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Text("${selectIndex+1} / ${widget.data.length}",
            style: TextStyle(color: Colors.white, fontSize: 14)),
        decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius:
            BorderRadius.circular(10)
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        height: widget.height,
        child: widget.data.length == 0
            ? null
            :
        new GestureDetector(
          onTap: () {
            widget.onBannerClickListener(
                pageController.page.round() % widget.data.length,
                widget.data[
                pageController.page.round() % widget.data.length]);
          },
          onTapDown: (details) {
//            print('onTapDown');
            clearTimer();
          },
          onTapUp: (details) {
//            print('onTapUp');
            resetTimer();
          },
          onTapCancel: () {
            resetTimer();
          },
          child: Stack(
            children: <Widget>[
              _buildPageView(),
              _buildCircleIndicator(),
              _buildTextIndicator()
            ]),
        ));
  }

  @override
  void dispose() {
    clearTimer();
    super.dispose();
  }
}
