import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryMainScreen extends StatelessWidget {
  static String routeName = "/category_main";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('카테고리')),
          automaticallyImplyLeading: false
      ),
      body: Body(),
    );
  }
}
