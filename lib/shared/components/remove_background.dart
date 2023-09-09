import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoveBackgroud {
  // Future<Uint8List> removeBgApi(String imagePath) async {
  //   var request = http.MultipartRequest(
  //       "POST", Uri.parse("http://api.remove.bg/v1.0/removebg"));
  //   request.files
  //       .add(await http.MultipartFile.fromPath('image_file', imagePath));
  //   request.headers.addAll({"X-API-Key": "2ZoT4wzB1CN8oXdCDXj36yqk"});
  //   final response = await request.send();
  //   if (response.statusCode == 200) {
  //     http.Response imgRes = await http.Response.fromStream(response);
  //     return imgRes.bodyBytes;
  //   } else {
  //     throw Exception("Error occured with response ${response.statusCode}");
  //   }
  // }

 

   static Future<void> removeBackground(String imageUrl) async {
  final apiKey = 'YOUR_API_KEY_HERE'; // Replace with your remove.bg API key
  final apiUrl = 'http://api.remove.bg/v1.0/removebg';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'X-Api-Key': apiKey,
    },
    body: {
      'image_url': imageUrl, // URL of the image you want to process
    },
  );


    if (response.statusCode == 200) {
      // The background has been removed successfully.
      // You can save or display the processed image.
      // For example, you can save it as a file or display it in an Image widget.
      final Map<String, dynamic> data = json.decode(response.body);
      final String processedImageUrl = data['data']['result_url'];

    } else {
      // Handle the error here if the API request fails.
      print('Error: ${response.reasonPhrase}');
    }
  }
}
