import 'package:flutter/material.dart';
import 'package:connect_people/constants.dart';
import 'package:connect_people/size_config.dart';

import 'sign_up_form.dart';

class Body extends StatefulWidget {
  final String phone;
  const Body({Key key, @required this.phone}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("회원 가입", style: headingStyle),
                // Text("휴대폰 인증을 통해\n회원가입을 완료 해주세요", textAlign: TextAlign.center),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                SignUpForm(phone: widget.phone),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
