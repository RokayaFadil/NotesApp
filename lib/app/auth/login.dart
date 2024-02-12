import 'package:flutter/material.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:notes_app/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  Crud _crud = Crud();

  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});

      var response = await _crud.postRequest(
          linkLogin, {"email": email.text, "password": password.text});
      isLoading = false;
      setState(() {});
      if (response['status'] == "successful") {
        SharedPref.setString("id", response['data']['id'].toString());
        SharedPref.setString("username", response['data']['username']);
        SharedPref.setString("email", response['data']['email']);

        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "خطأ في تسجيل الدخول",
          body: Text(
              "خطأ في البريد الالكتروني او كلمة المرور او الحساب غير موجود"),
          btnCancelOnPress: () {},
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Form(
                        key: formstate,
                        child: Column(
                          children: [
                            Image.asset(
                              "images/logo.png",
                              width: 200,
                              height: 200,
                            ),
                            CustTextFormsing(
                              valid: (val) {
                                return validInput(val!, 5, 40);
                              },
                              mycotroller: email,
                              hint: "E-mail",
                            ),
                            CustTextFormsing(
                              valid: (val) {
                                return validInput(val!, 4, 10);
                              },
                              mycotroller: password,
                              hint: "Password",
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    textStyle: TextStyle(color: Colors.black),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50)),
                                onPressed: () async {
                                  await login();
                                },
                                child: const Text("Login")),
                            Container(
                              height: 10,
                            ),
                            InkWell(
                              child: const Text('Sing Up ->'),
                              onTap: () {
                                Navigator.of(context).pushNamed("singup");
                              },
                            )
                          ],
                        ))
                  ],
                ),
              ));
  }
}
