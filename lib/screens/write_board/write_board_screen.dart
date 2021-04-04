import 'package:flutter/material.dart';

import 'components/body.dart';

class _WriteBoard extends State<WriteBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("글쓰기"),
        ),
        body: Body(categoryIDs: widget.categoryIDs, parentID: widget.parentID));
  }
}

class WriteBoardScreen extends StatefulWidget {
  static String routeName = "/write_board";

  const WriteBoardScreen(
      {Key key, @required this.categoryIDs, @required this.parentID})
      : super(key: key);

  final List<int> categoryIDs;
  final int parentID;

  @override
  _WriteBoard createState() => _WriteBoard();
}
