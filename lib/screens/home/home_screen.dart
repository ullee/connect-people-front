import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/write_board/write_board_screen.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';

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
    WriteBoardScreen(),
    CartScreen(),
    SignUpScreen(),
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
