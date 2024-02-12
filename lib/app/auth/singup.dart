import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  GlobalKey<FormState> formstate = GlobalKey();
  Crud _crud = Crud();

  bool isLoading = false;

  TextEditingController usrename = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  singUp() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkSingUp, {
        "username": usrename.text,
        "email": email.text,
        "password": password.text
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "successful") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "مرحبا بك",
          body: Text("تم انشاء الحساب بنجاح"),
          btnOkOnPress: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("home", (route) => false);
          },
        )..show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "خطأ في انشاء الحساب",
          body: Text("حدث خطأ ما الرجاء اعادة المحاولة"),
          btnCancelOnPress: () {},
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(10),
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
                                return validInput(val!, 3, 20);
                              },
                              mycotroller: usrename,
                              hint: "Usrename",
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
                                  await singUp();
                                },
                                child: Text("SingUp")),
                            Container(
                              height: 10,
                            ),
                            InkWell(
                              child: Text('Login ->'),
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("login");
                              },
                            )
                          ],
                        ))
                  ],
                ),
              ));
  }
}
