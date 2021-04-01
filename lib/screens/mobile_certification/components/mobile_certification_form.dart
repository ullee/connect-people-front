import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:connect_people/screens/sign_up/components/send_sms.dart';
import 'package:connect_people/screens/sign_up/sign_up_screen.dart';
import 'package:connect_people/screens/signup_success/signup_success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_people/components/default_button.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'signup.dart';

class Result {
  int code;
  String message;
  Result({this.code, this.message});
}

class MobileCertificationForm extends StatefulWidget {
  @override
  _MobileCertificationFormState createState() =>
      _MobileCertificationFormState();
}

class _MobileCertificationFormState extends State<MobileCertificationForm> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController authNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String phone;
  String authNumber;

  Result result;

  Future<Result> signup(
      String loginId, String password, String name, String phone) async {
    Signup signup = Signup();
    await signup.call(loginId, password, name, phone);
    if (signup.code != 1) {
      return Result(code: signup.code, message: signup.message);
    }

    return Result(code: 1, message: "ok");
  }

  _signup(String loginId, String password, String name, String phone) async {
    try {
      var result = await signup(loginId, password, name, phone);

      if (result.code != 1) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: new Text("Fail"),
                content: new Text(result.message),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Text("OK"))
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: new Text("Success!"),
                content: new Text("회원가입 성공"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, SignUpSuccessScreen.routeName);
                      },
                      child: new Text("OK"))
                ],
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _sendSms(String phone) async {
    try {
      SendSms sms = SendSms();
      await sms.call(phone);

      if (sms.success != null && sms.success) {
        return true;
      } else {
        throw sms.message;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> _sendAuthNumber(String number) async {
    try {
      SendSms sms = SendSms();
      await sms.auth(number);

      if (sms.success != null && sms.success) {
        return true;
      } else {
        throw sms.message;
      }
    } catch (e) {
      throw e;
    }
  }

  void _authSms() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("인증번호를 발송 했습니다.",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            content: buildAuthPhoneField(),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => {Navigator.of(context).pop(null)},
                  child: new Text("인증"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 270,
                child: buildPhoneField(),
              ),
              SizedBox(
                height: 40,
                width: 90,
                child: DefaultButton(
                    text: "발송요청",
                    press: () {
                      if (phoneController.text.isEmpty) {
                        showSnackBar(context, "휴대폰번호를 입력해 주세요");
                        return;
                      }
                      String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(phoneController.text)) {
                        showSnackBar(context, "휴대폰번호가 올바르지 않습니다");
                        return;
                      }
                      _sendSms(phoneController.text);
                      _authSms();
                    }),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "회원정보 입력하기",
            press: () {
              if (phoneController.text.isEmpty) {
                showSnackBar(context, "휴대폰번호를 입력해 주세요");
                return;
              }
              Navigator.pushNamed(context, SignUpScreen.routeName,
                  arguments:
                      SignUpScreenArguments(phone: phoneController.text));
            },
          ),
        ],
      ),
    );
  }

  TextField buildPhoneField() {
    return TextField(
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11)
      ],
      controller: phoneController,
      decoration: InputDecoration(
        labelText: "휴대폰번호",
        hintText: "숫자만 입력",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextField buildAuthPhoneField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: authNumberController,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4)
      ],
      decoration: InputDecoration(
        hintText: "인증번호 숫자 4자리",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message, textAlign: TextAlign.center),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.lightBlue,
  ));
}
