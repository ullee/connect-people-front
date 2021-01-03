import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 가입"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null)
        ),
      ),
      body: Body(),
    );
  }
}
