import 'package:flutter/material.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/model/notemodel.dart';

class CardNotes extends StatelessWidget {
  final void Function() ontap;
  final noteModel notemodel;
  final dynamic edit;
  final dynamic delete;

  const CardNotes(
      {super.key,
      required this.ontap,
      this.edit,
      this.delete,
      required this.notemodel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                  "$linkImageRoot/${notemodel.notesImage}",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                )),
            Expanded(
                flex: 4,
                child: ListTile(
                    title: Text("${notemodel.notesTitile}"),
                    subtitle: Text("${notemodel.notesContent}"),
                    trailing: SizedBox(
                      width: 96,
                      height: 96,
                      child: Row(
                        children: [edit, delete],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
