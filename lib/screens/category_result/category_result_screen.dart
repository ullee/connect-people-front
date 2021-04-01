import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryResultScreen extends StatefulWidget {
  static String routeName = "/category_result";

  const CategoryResultScreen({Key key, @required this.categoryID = null})
      : super(key: key);

  final int categoryID;

  @override
  _CategoryResultScreen createState() => _CategoryResultScreen();
}

class _CategoryResultScreen extends State<CategoryResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(categoryID: widget.categoryID),
    );
  }
}
