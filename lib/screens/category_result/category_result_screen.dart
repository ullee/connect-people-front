import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryResultScreen extends StatefulWidget {

  static String routeName = "/category_result";

  const CategoryResultScreen({
    Key key,
    @required this.categoryIDs
  }) : super(key: key);

  final List<int> categoryIDs;


  @override
  _CategoryResultScreen createState() => _CategoryResultScreen();
}

class _CategoryResultScreen extends State<CategoryResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
