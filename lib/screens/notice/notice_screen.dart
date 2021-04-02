import 'package:flutter/material.dart';

import 'components/body.dart';

class NoticeScreen extends StatelessWidget {
  static String routeName = "/notice";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Body(),
    );
  }
}
