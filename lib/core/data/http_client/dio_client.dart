import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:polls_front/core/data/http_client/http_client.dart';

@Injectable(as: HttpClient)
class DioClient implements HttpClient {
  final dio = Dio(
    BaseOptions(baseUrl: 'http://192.168.0.120:3333'),
  );

  @override
  Future<HttpResponse> get(String url, {Map<String, String>? query}) async {
    final response = await dio.get(url, queryParameters: query);
    return HttpResponse(
      statusCode: response.statusCode,
      data: response.data,
    );
  }
}
