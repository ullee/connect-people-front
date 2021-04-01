import 'package:connect_people/screens/mobile_certification/mobile_certification_screen.dart';
import 'package:flutter/material.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("처음이신가요? ", style: TextStyle(fontSize: 14)),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, MobileCertificationScreen.routeName),
          child:
              Text("회원가입", style: TextStyle(fontSize: 14, color: Colors.blue)),
        ),
      ],
    );
  }
}
