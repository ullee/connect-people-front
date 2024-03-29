import 'package:flutter/material.dart';

import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Body(),
    );
  }
}
