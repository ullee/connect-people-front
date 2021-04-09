import 'package:flutter/material.dart';

import 'package:connect_people/size_config.dart';

import 'write_board_form.dart';

class Body extends StatefulWidget {
  const Body({Key key, @required this.categoryIDs, @required this.parentID})
      : super(key: key);

  final List<int> categoryIDs;
  final int parentID;

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
                SizedBox(height: SizeConfig.screenHeight * 0.01), // 4%
                // Text("글 작성하기", style: headingStyle),
                Text(
                  "공유하고싶은 품목 또는 알리고 싶은 내용을 작성해 보세요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "※첫번째 사진은 작성자를 대표하는(회사or로고)사진으로 등록바랍니다.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                WriteBoardForm(categoryIDs: widget.categoryIDs, parentID: widget.parentID),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
