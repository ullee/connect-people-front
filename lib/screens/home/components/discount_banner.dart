import 'package:flutter/material.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 90,
        width: double.infinity,
        margin: EdgeInsets.all(getProportionateScreenWidth(0)),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(45),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF4A3298),
          // borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(text: "Connect People\n"),
                TextSpan(
                  text: "내일의 광고 주인공은 당신입니다.",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
