import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/app/notes/edit.dart';
import 'package:notes_app/components/cardnotes.dart';
import 'package:notes_app/components/crud.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/model/notemodel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Crud _crud = Crud();

  viewNote() async {
    var userId = SharedPref.getString("id");

    if (userId != null) {
      print(
          "User ID-----------------------------------------------: ${SharedPref.getString("id")}");
      var response = await _crud.postRequest(linkViewNote, {"id": userId});
      return response;
    } else {
      print("User ID is null.============================================");

      return null;
    }

    //var response = await _crud
    //   .postRequest(linkViewNote, {"id": SharedPref.getString("id")});

    // return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                SharedPref.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            FutureBuilder(
              future: viewNote(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == 'fail') {
                    return const Center(
                        child: Text(
                      "لا يوجد ملاحظات ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data["data"].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return CardNotes(
                          edit: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditNotes(
                                        notes: snapshot.data['data'][i],
                                      )));
                            },
                            icon: const Icon(Icons.edit, color: Colors.black87),
                          ),
                          delete: IconButton(
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: "حذف الملاحظة",
                                body: const Text("هل  تريد حذف هذه الملاحظة"),
                                btnCancelOnPress: () {},
                                btnCancelText: "الغاء",
                                btnOkText: "نعم",
                                btnOkOnPress: () async {
                                  var response = await _crud.postRequest(
                                      linkDeleteNote, {
                                    "id": snapshot.data['data'][i]['notes_id']
                                        .toString(),
                                    "imagename": snapshot.data['data'][i]['notes_image']
                                        .toString()
                                  });
                                  if (response['status'] == "successful") {
                                    Navigator.of(context)
                                        .pushReplacementNamed("home");
                                  }
                                },
                              ).show();
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          ontap: () {},
                          notemodel: noteModel.fromJson(snapshot.data['data'][i])
                          
                         
                        );
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
