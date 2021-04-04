import 'package:flutter/material.dart';

import 'components/body.dart';

class NoticeDetailScreen extends StatelessWidget {
  static String routeName = "/notice/detail";

  @override
  Widget build(BuildContext context) {
    final NoticeDetailArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: Body(notice_id: args.notice_id),
    );
  }
}

class NoticeDetailArguments {
  final int notice_id;
  NoticeDetailArguments({@required this.notice_id});
}