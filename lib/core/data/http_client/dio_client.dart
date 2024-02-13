import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:polls_front/core/data/http_client/http_client.dart';

@Injectable(as: HttpClient)
class DioClient implements HttpClient {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://polls-api-126y.onrender.com'),
  );

  @override
  Future<HttpResponse> get(String url, {Map<String, String>? query}) async {
    final response = await dio.get(url, queryParameters: query);
    return HttpResponse(
      statusCode: response.statusCode,
      data: response.data,
    );
  }

  @override
  Future<HttpResponse> post(String url, {data}) async {
    final response = await dio.post(url, data: data);
    return HttpResponse(
      statusCode: response.statusCode,
      data: response.data,
    );
  }
}
