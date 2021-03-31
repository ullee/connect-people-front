import 'package:flutter/material.dart';
import 'package:connect_people/constants.dart';
import 'package:connect_people/size_config.dart';

import 'mobile_certification_form.dart';

class Body extends StatelessWidget {
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
                Text("휴대폰 인증", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                MobileCertificationForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
