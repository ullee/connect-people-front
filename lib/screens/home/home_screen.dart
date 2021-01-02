import 'package:flutter/material.dart';
import 'package:connect_people/screens/category/category_screen.dart';
import 'package:connect_people/screens/profile/profile_screen.dart';
import 'package:connect_people/screens/write_board/write_board_screen.dart';
import 'package:connect_people/screens/home/components/body.dart';

import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _selectIndex = 0;
  final List<Widget> _pages = [
    Body(),
    CategoryScreen(),
    CategoryScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("홈")),
          BottomNavigationBarItem(icon: Icon(Icons.app_registration), title: Text("글쓰기")),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), title: Text("카테고리")),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text("내정보")),
        ],
      ),
    );
  }
}
