import 'package:notes_app/constant/massage.dart';

validInput(String val, int min, int max) {
  if (val.isEmpty) {
    return "$massageEmpty";
  }
  if (val.length > max) {
    return "$massageMax $max";
  }
  if (val.length < min) {
    return "$massageMin $min";
  }
}
