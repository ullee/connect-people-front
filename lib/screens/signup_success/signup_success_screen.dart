import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpSuccessScreen extends StatelessWidget {
  static String routeName = "/signup_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("회원가입 성공"),
      ),
      body: Body(),
    );
  }
}
