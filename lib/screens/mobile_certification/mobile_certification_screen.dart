import 'package:flutter/material.dart';

import 'components/body.dart';

class MobileCertificationScreen extends StatelessWidget {
  static String routeName = "/mobile_certification";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("휴대폰 인증"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null)),
      ),
      body: Body(),
    );
  }
}
