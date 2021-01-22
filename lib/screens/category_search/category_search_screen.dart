import 'package:flutter/material.dart';

import 'components/body.dart';

class CategorySearchScreen extends StatelessWidget {
  static String routeName = "/category_search";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('검색')),
          automaticallyImplyLeading: false
      ),
      body: Body(),
    );
  }
}
