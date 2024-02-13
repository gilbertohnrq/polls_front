abstract interface class HttpClient {
  Future<HttpResponse> get(String url, {Map<String, String>? query});
}

class HttpResponse {
  final int? statusCode;
  final dynamic data;
  const HttpResponse({
    this.statusCode,
    this.data,
  });

  HttpResponse copyWith({
    int? statusCode,
    dynamic data,
  }) {
    return HttpResponse(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HttpResponse &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => statusCode.hashCode ^ data.hashCode;
}
