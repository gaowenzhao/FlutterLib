import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
 List tabList = [
    {'text': '业界动态','icon': Icon(Icons.language),'page': FirstPage(title: "首页")},
    {'text': 'WIDGET', 'icon': Icon(Icons.extension), 'page': SecondPage()},
    {'text': '组件收藏', 'icon': Icon(Icons.favorite), 'page': ThirdPage()},
    {'text': '关于手册', 'icon': Icon(Icons.import_contacts), 'page': FourthPage()}
  ];
*/
///切换tab不重置数据
class TabStackPage extends StatefulWidget{
  final List tabList;
  final Function onTap;
  const TabStackPage({Key key, this.tabList,this.onTap}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TabStackState();
  }
}
class _TabStackState extends State<TabStackPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List tabList;
  List<BottomNavigationBarItem> myTabs = [];

  @override
  void initState() {
    super.initState();
    tabList = widget.tabList;
    for (int i = 0; i < tabList.length; i++) {
      myTabs.add(BottomNavigationBarItem(
        icon: tabList[i]['icon'],
        title: Text(
          tabList[i]['text'],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index:_currentIndex,
        children: [
          tabList[0]["page"],
          tabList[1]["page"],
          tabList[2]["page"],
          tabList[3]["page"]
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: myTabs,
//        //高亮  被点击高亮
        currentIndex: _currentIndex,
//        //修改 页面
        onTap: (index)=>_ItemTapped(index),
        //shifting :按钮点击移动效果
        //fixed：固定
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void _ItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      widget.onTap(index);
    });
  }
}