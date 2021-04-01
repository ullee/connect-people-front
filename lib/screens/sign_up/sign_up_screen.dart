import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    final SignUpScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 가입"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null)),
      ),
      body: Body(phone: args.phone),
    );
  }
}

class SignUpScreenArguments {
  final String phone;
  SignUpScreenArguments({@required this.phone});
}
