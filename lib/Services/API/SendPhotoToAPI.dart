import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void SendPhotoToAPI(File photoFile, String userId , String reportId) async {
  String apiUrl = 'http://imnotulysses.pythonanywhere.com/upload';

  // Read the photo file and convert it to Base64 encoding
  List<int> photoBytes = await photoFile.readAsBytes();
  String base64Photo = base64Encode(photoBytes);

  // Create the request payload
  Map<String, String> headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> payload = {'photo': base64Photo , 'string1' : userId , 'string2' : reportId};



  // Send the POST request to the PythonAnywhere API
  Uri apiUri = Uri.parse(apiUrl); // Convert the apiUrl to Uri object
  http.Response response = await http.post(apiUri, headers: headers, body: jsonEncode(payload));


  // Handle the response
  if (response.statusCode == 200) {
    // Photo successfully sent
    //print(response.headers);
    //print(jsonEncode(payload));
    print("Photo successfully sent");


  } else {
    // Error occurred
    print('Error sending photo. Status code: ${response.statusCode}');
  }
}
