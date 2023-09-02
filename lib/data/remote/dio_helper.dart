import 'package:dio/dio.dart';
import 'package:store_app/shared/constants/strings.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        );
    dio = Dio(options);
  }

   static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options = BaseOptions(headers: {
      'Content_Type':'application/json',
      "lang": lang,
      "Authorization": token??'',
    });
    return await dio!.get(url, queryParameters: query);
  }

   static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options = BaseOptions(headers: {
      'Content_Type':'application/json',
      "lang": lang,
      "Authorization": token??'',
    });
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
