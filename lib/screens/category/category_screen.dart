import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryScreen extends StatelessWidget {
  static String routeName = "/category";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('글쓰기')),
          automaticallyImplyLeading: false
      ),
      body: Body(),
    );
  }
}
