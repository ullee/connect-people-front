import 'package:flutter/material.dart';

import 'components/body.dart';

class MyBoardScreen extends StatelessWidget {
  static String routeName = "/my_board";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 작성글"),
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Body(),
    );
  }
}
