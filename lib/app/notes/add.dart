import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/main.dart';
import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  File? myfile;
  final Crud _crud = Crud();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoding = false;

  addNote() async {
    if (myfile == null) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "تنبيه",
        body: const Text("يجب اضافة صورة الى الملاحظة"),
        btnOkOnPress: () {},
      )..show();
    }
    if (formstate.currentState!.validate()) {
      isLoding = true;
      setState(() {});
      var response = await _crud.postRequestWithFile(
          linkAddNote,
          {
            "title": title.text,
            "content": content.text,
            "id": SharedPref.getString("id"),
          },
          myfile!);
      isLoding = false;
      setState(() {});
      if (response['status'] == "successful") {
        Navigator.of(context).pushReplacementNamed("home");
      } else
        print("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Note"),
        backgroundColor: Colors.red,
      ),
      body: isLoding == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    CustTextFormsing(
                        hint: "title",
                        mycotroller: title,
                        valid: (val) {
                          return validInput(val!, 1, 20);
                        }),
                    CustTextFormsing(
                        hint: "content note",
                        mycotroller: content,
                        valid: (val) {
                          return validInput(val!, 5, 200);
                        }),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                myfile == null ? Colors.red : Colors.green),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                    height: 140,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Please Choose Image",
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            XFile? xfile = await ImagePicker()
                                                .pickImage(
                                                    source: ImageSource.camera);

                                            Navigator.of(context).pop();
                                            myfile = File(xfile!.path);
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            width: double.infinity,
                                            child: const Row(children: [
                                              Icon(Icons.camera_alt),
                                              Text(
                                                "From Camera",
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ]),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            XFile? xfile = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            Navigator.of(context).pop();
                                            myfile = File(xfile!.path);
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            width: double.infinity,
                                            child: const Row(children: [
                                              Icon(
                                                  Icons.photo_library_outlined),
                                              Text(
                                                "From Gallery",
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        child: const Text("Add Image")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          await addNote();
                        },
                        child: const Text("Add"))
                  ],
                ),
              ),
            ),
    );
  }
}
