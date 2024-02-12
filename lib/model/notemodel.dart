class noteModel {
  int? notesId;
  String? notesTitile;
  String? notesContent;
  String? notesImage;
  int? notesUsres;

  noteModel(
      {this.notesId,
      this.notesTitile,
      this.notesContent,
      this.notesImage,
      this.notesUsres});

  noteModel.fromJson(Map<String, dynamic> json) {
    notesId = json['notes_id'];
    notesTitile = json['notes_titile'];
    notesContent = json['notes_content'];
    notesImage = json['notes_image'];
    notesUsres = json['notes_usres'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes_id'] = this.notesId;
    data['notes_titile'] = this.notesTitile;
    data['notes_content'] = this.notesContent;
    data['notes_image'] = this.notesImage;
    data['notes_usres'] = this.notesUsres;
    return data;
  }
}