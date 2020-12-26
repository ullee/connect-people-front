import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/home/home_screen.dart';
import 'dart:async';
import 'dart:convert';

import '../../../constants.dart';
import '../../../size_config.dart';

class Result {
  final int code;
  final String message;
  Result({this.code, this.message});
  Result.fromJson(Map<String, dynamic> json) :
        code = json['code'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message
  };
}

Future<Result> fetchAll(String brandName, int memberID, String title, String subTitle, String content) async {
  final response = await http.post(
    'http://52.79.191.174/boards',
    body: jsonEncode(
      {
        'brandName': brandName,
        'memberID': memberID,
        'title': title,
        'subTitle': subTitle,
        'content': content
      }
    ),
    headers: {'Content-Type': 'application/json'}
  );
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['result'];
  var result = Result.fromJson(jsonData);
  // var jsons = jsonEncode(result.toJson());
  // print(jsons);

  return result;
}

class WriteBoardForm extends StatefulWidget {
  @override
  _WriteBoardForm createState() => _WriteBoardForm();
}

class _WriteBoardForm extends State<WriteBoardForm> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String subTitle;
  String content;
  String brandName;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildBrandNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildTitleFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildSubTitleFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildContentFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "작성 완료",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                FutureBuilder<Result>(
                  future: fetchAll(brandName, 1, title, subTitle, content),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: new Text("Info"),
                          content: new Text("now loading..."),
                          actions: <Widget>[new FlatButton(
                              onPressed: null, child: new Text("Close"))
                          ],
                        );
                      });
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: new Text("Error"),
                          content: new Text(snapshot.error),
                          actions: <Widget>[new FlatButton(
                              onPressed: null, child: new Text("Close"))
                          ],
                        );
                      });
                      return null;
                    } else {
                      if (snapshot.data.code == 1) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: new Text("Error"),
                            content: new Text(snapshot.data.message),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: null, child: new Text("Close"))
                            ],
                          );
                        });
                      }
                      return null;
                    }
                  },
                );
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: new Text("Success!!"),
                    content: new Text("작성 완료"),
                    actions: <Widget>[new FlatButton(onPressed: () {Navigator.pushNamed(context, HomeScreen.routeName);}, child: new Text("Close"))],
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildBrandNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => content = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        brandName = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "BrandName",
        hintText: "업체명을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildContentFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => content = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        content = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Content",
        hintText: "내용을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildSubTitleFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => subTitle = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        title = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "SubTitle",
        hintText: "부제목을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTitleFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => title = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        title = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "제목을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
