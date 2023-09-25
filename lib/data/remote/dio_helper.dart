import 'package:dio/dio.dart';
import 'package:store_app/shared/constants/strings.dart';

class DioHelper {
  static final Dio? dio=Dio(BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        ));

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
  static Future<Response> putData({
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
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

   static Future<Response> deleteData({
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
    return await dio!.delete(
      url,
      queryParameters: query,
    );
  }
}
