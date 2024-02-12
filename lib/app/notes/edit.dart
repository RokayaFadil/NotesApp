import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/components/customtextform.dart';
import 'package:notes_app/components/valid.dart';
import 'package:notes_app/constant/linkapi.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final Crud _crud = Crud();

  File? myfile;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoding = false;

  editNote() async {
    if (formstate.currentState!.validate()) {
      isLoding = true;
      setState(() {});
      var response;

      if (myfile == null) {
        response = await _crud.postRequest(linkEditeNote, {
          "title": title.text,
          "content": content.text,
          "imagename": widget.notes['notes_image'].toString(),
          "id": widget.notes['notes_id'].toString()
        });
      } else {
        response = await _crud.postRequestWithFile(
            linkEditeNote,
            {
              "title": title.text,
              "content": content.text,
              "imagename": widget.notes['notes_image'].toString(),
              "id": widget.notes['notes_id'].toString()
            },
            myfile!);
      }

      isLoding = false;
      setState(() {});
      if (response['status'] == "successful") {
        Navigator.of(context).pushReplacementNamed("home");
      } else
        print("ERROR");
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_titile'];
    content.text = widget.notes['notes_content'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Note"),
        backgroundColor: Colors.red,
      ),
      body: isLoding == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
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
                          await editNote();
                        },
                        child: Text("Save"))
                  ],
                ),
              ),
            ),
    );
  }
}
