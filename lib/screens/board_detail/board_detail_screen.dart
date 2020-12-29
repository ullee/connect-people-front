import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';


class BoardDetailScreen extends StatelessWidget {
  static String routeName = "/board/detail";

  @override
  Widget build(BuildContext context) {
    final BoardDetailArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: 1.0),
      body: Body(boardID: args.boardID),
    );
  }
}

class BoardDetailArguments {
  final int boardID;
  BoardDetailArguments({@required this.boardID});
}
