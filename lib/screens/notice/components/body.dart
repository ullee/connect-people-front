import 'package:connect_people/components/WebViewContainer.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: WebViewContainer(
            "http://ec2-3-35-207-154.ap-northeast-2.compute.amazonaws.com:8080/notice/list"),
      ),
    );
  }
}
