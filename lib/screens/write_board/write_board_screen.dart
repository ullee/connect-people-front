import 'package:flutter/material.dart';

import 'components/body.dart';

class _WriteBoard extends State<WriteBoardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("글쓰기"),
      ),
      body: Body()
    );
  }
}

class WriteBoardScreen extends StatefulWidget {
  static String routeName = "/write_board";
  @override
  _WriteBoard createState() => _WriteBoard();
}
