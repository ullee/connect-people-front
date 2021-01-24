import 'package:flutter/material.dart';

import 'package:connect_people/components/default_button.dart';
import 'package:connect_people/screens/home/home_screen.dart';
import 'package:connect_people/screens/forgot_password/forgot_password_screen.dart';
import 'package:connect_people/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class Result {
  int code;
  String message;
  String token;
  Result({this.code, this.message, this.token});
}

class _SignFormState extends State<SignForm> {

  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email;
  String password;

  Result result;

  Future<Result> login(String loginId, String password) async {

      Login login = Login();
      await login.call(loginId, password);
      if (login.code != 1) {
        return Result(
          code: login.code,
          message: login.message,
          token: null
        );
      }

      return Result(
          code: 1,
          message: "ok",
          token: login.token
      );
  }

  _login(String loginId, String password) async {
    try {
      var result = await login(loginId, password);
      if (result.code != 1) {
        return showSnackBar(context, result.message);
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', result.token);
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "환영합니다!",
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "가입하신 이메일과 패스워드를 입력해 주세요",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            buildLoginIdField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                  child: Text("아이디 찾기", style: TextStyle(fontSize: 12)),
                ),
                Text(" | ", style: TextStyle(fontSize: 10),),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                  child: Text("비밀번호 찾기", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            DefaultButton(
              text: "로그인",
              press: () {
                if (loginIdController.text.isEmpty && passwordController.text.isEmpty) {
                  showSnackBar(context, "아이디와 비밀번호를 입력해 주세요");
                } else if (loginIdController.text.isEmpty) {
                  showSnackBar(context, "아이디를 입력해 주세요");
                } else if (passwordController.text.isEmpty) {
                  showSnackBar(context, "비밀번호를 입력해 주세요");

                } else {
                  email = loginIdController.text;
                  password = passwordController.text;
                  _login(email, password);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  TextField buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        // labelText: "비밀번호",
        hintText: "비밀번호",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        // labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextField buildLoginIdField() {
    return TextField(
      controller: loginIdController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        // labelText: "아이디",
        hintText: "아이디(이메일)",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        // labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
            message,
            textAlign: TextAlign.center
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.lightBlue,
      )
  );
}
