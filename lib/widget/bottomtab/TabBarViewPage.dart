import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../StatusBarUtils.dart';
/*
List tabList = [
  {'text': '业界动态','icon': Icon(Icons.language),'page': FirstPage(title: "首页")},
  {'text': 'WIDGET', 'icon': Icon(Icons.extension), 'page': SecondPage()},
  {'text': '组件收藏', 'icon': Icon(Icons.favorite), 'page': ThirdPage()},
  {'text': '关于手册', 'icon': Icon(Icons.import_contacts), 'page': FourthPage()}
];
*/
///切换tab不重置数据，还可以左右滑动切换tab
class TabBarViewPage extends StatefulWidget{
  final List tabList;
  final Function onTap;
  const TabBarViewPage({Key key, this.tabList,this.onTap}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TabBarViewState();
  }
}

class _TabBarViewState extends State<TabBarViewPage> with SingleTickerProviderStateMixin {
  TabController control;
  List tabList;
  @override
  void initState() {
    super.initState();
    control = TabController(length: 4, vsync: this);
    tabList = widget.tabList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: control, children: [
        tabList[0]["page"],
        tabList[1]["page"],
        tabList[2]["page"],
        tabList[3]["page"]
      ]),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
            tabs: [
              Tab(text: tabList[0]["text"], icon: tabList[0]["icon"]),
              Tab(text: tabList[1]["text"], icon: tabList[1]["icon"]),
              Tab(text: tabList[2]["text"], icon: tabList[2]["icon"]),
              Tab(text: tabList[3]["text"], icon: tabList[3]["icon"])
            ],
            onTap: (index){
              widget.onTap(index);
            },
            controller: control,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicator: const BoxDecoration()),
      ),
    );
  }
}