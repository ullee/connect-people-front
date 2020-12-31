import 'package:flutter/material.dart';
import 'package:connect_people/size_config.dart';

import 'write_board_form.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.01), // 4%
                // Text("글 작성하기", style: headingStyle),
                Text(
                  "팔고 싶은 물건 또는 알리고 싶은 내용을\n자유롭게 작성해 보세요",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                WriteBoardForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
