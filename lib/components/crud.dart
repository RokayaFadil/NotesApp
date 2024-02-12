import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

String _basicAuth = 'Basic ${base64Encode(utf8.encode('roro:roro12345'))}';

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    // من اجل التعامل مع الملف.....
    // اللنث الخاص بالملف
    var length = await file.length();
    // تدفق البيانات
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("file", stream, length,
        filename: basename(file.path));
    //تحميل الملف على الركوست المتجه الى السيرفر
    request.headers.addAll(myheaders);
    request.files.add(multipartFile);
    // لارسال جميع انواع الداتا
    //request.fields['title'] = data['title'] هذا الكويد يصبح هكذا اذا تحول ككود عام وليس خاص بشئ واحد=>
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    //ارسال الريكوست
    var sendRequest = await request.send();
    var response = await http.Response.fromStream(sendRequest);
    if (sendRequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Eror=====================================");
    }
  }
}
