import 'package:connect_people/screens/signup_success/signup_success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_people/components/default_button.dart';

import '../../../size_config.dart';
import 'signup.dart';

class Result {
  int code;
  String message;
  Result({this.code, this.message});
}

class SignUpForm extends StatefulWidget {
  final String phone;
  const SignUpForm({Key key, @required this.phone}) : super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildLoginIdField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordConfirmField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildNameField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "가입하기",
            press: () {
              if (loginIdController.text.isEmpty) {
                showSnackBar(context, "아이디를 입력해 주세요");
                return;
              } else if (!regex.hasMatch(loginIdController.text)) {
                showSnackBar(context, "아이디가 이메일 형식이 아닙니다");
                return;
              } else if (passwordController.text.isEmpty) {
                showSnackBar(context, "패스워드를 입력해 주세요");
                return;
              } else if (passwordConfirmController.text.isEmpty) {
                showSnackBar(context, "패스워드를 재확인해 주세요");
                return;
              } else if (passwordController.text !=
                  passwordConfirmController.text) {
                showSnackBar(context, "패스워드가 불일치 합니다");
                return;
              } else if (nameController.text.isEmpty) {
                showSnackBar(context, "이름를 입력해 주세요");
                return;
              }
              _signup(loginIdController.text, passwordController.text,
                  nameController.text, widget.phone);
            },
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("가입시 ", style: TextStyle(fontSize: 12, color: Colors.grey)),
              GestureDetector(
                // onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
                onTap: () => {},
                child: Text("이용약관",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline)),
              ),
              Text(" 및 ", style: TextStyle(fontSize: 12, color: Colors.grey)),
              GestureDetector(
                onTap: () => {},
                child: Text("개인정보취급방침",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline)),
              ),
              Text(", ", style: TextStyle(fontSize: 12, color: Colors.grey)),
              GestureDetector(
                onTap: () => {},
                child: Text("위치정보제공",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline)),
              ),
              Text("에 동의합니다.",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  TextField buildPasswordConfirmField() {
    return TextField(
      obscureText: true,
      controller: passwordConfirmController,
      decoration: InputDecoration(
        labelText: "비밀번호 확인",
        hintText: "비밀번호 재입력",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextField buildPasswordField() {
    return TextField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: "비밀번호",
        hintText: "영문,숫자,특수문자 포함 6~15자",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextField buildLoginIdField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: loginIdController,
      decoration: InputDecoration(
        labelText: "아이디(이메일)",
        hintText: "이메일 주소 입력",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextField buildNameField() {
    return TextField(
      keyboardType: TextInputType.name,
      controller: nameController,
      decoration: InputDecoration(
        labelText: "이름",
        hintText: "이름 입력",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
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
