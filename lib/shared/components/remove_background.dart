import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class RemoveBackgroud {
  static var apiUrl = Uri.parse('http://api.remove.bg/v1.0/removebg');
  static const apiKey = '2NmfxtkRrkFMGpT9yezw8asN';

  static removeBg(String imagePath) async {
    var req = http.MultipartRequest('POST', apiUrl);
    req.headers.addAll({"X_API_Key": apiKey});
    req.files.add(await http.MultipartFile.fromString("image_url", imagePath));

    final res = await req.send();

    if (res.statusCode == 200) {
      http.Response img = await http.Response.fromStream(res);
      return img.bodyBytes;
    } else {
      print("Failde");
      return null;
    }
  }

  // static Future<void> removeBgApi(String imagePath) async {
  //   print(imagePath);
  //   // var request = http.MultipartRequest(
  //   //     "POST", Uri.parse("http://api.remove.bg/v1.0/removebg"));
  //   final request = await http
  //       .post(
  //         Uri.parse('https://api.picsart.io/tools/1.0/removebg'),
  //         headers: {
  //           'X-Picsart-API-Key': 'brTW5QpO1GGy3BhGHAwd3sTG6dQ1yDGl',
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode({'image_url': 'https://student.valuxapps.com/storage/uploads/products/1615442168bVx52.item_XXL_36581132_143760083.jpeg'}),
  //       )
  //       .timeout(Duration(seconds: 60));
  //   if (request.statusCode == 200) {
  //     final responseData = json.decode(request.body);
  //     imagePath = responseData;
  //     // Check if the API response contains a 'data' field
  //     if (responseData.containsKey('data')) {
  //       final downloadUrl = responseData['data']['segmented_url'];
  //       // You can now display or use the image without the background
  //       print('Background removed. Image URL: $downloadUrl');
  //     } else {
  //       print('Error: Background removal failed.');
  //     }
  //   } else {
  //     print('Error: ${request.statusCode}');
  //   }
  // }

  //  static Future<void> removeBackground(String imageUrl) async {
  // final apiKey = 'YOUR_API_KEY_HERE'; // Replace with your remove.bg API key
  // final apiUrl = 'http://api.remove.bg/v1.0/removebg';

  // final response = await http.post(
  //   Uri.parse(apiUrl),
  //   headers: {
  //     'X-Api-Key': apiKey,
  //   },
  //   body: {
  //     'image_url': imageUrl, // URL of the image you want to process
  //   },
  // );

  //   if (response.statusCode == 200) {
  //     // The background has been removed successfully.
  //     // You can save or display the processed image.
  //     // For example, you can save it as a file or display it in an Image widget.
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     final String processedImageUrl = data['data']['result_url'];

  //   } else {
  //     // Handle the error here if the API request fails.
  //     print('Error: ${response.reasonPhrase}');
  //   }
  // }

  
}
