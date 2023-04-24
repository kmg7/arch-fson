class NetworkRequestOptions {
  String method;
  Map<String, dynamic>? queryParams;
  String? _contentType;
  String? _authorization;
  String? _contentLanguage;
  String? _connection;
  String? _userAgent;
  NetworkRequestOptions(
    this.method, {
    this.queryParams,
    String? contentType,
    String? authorization,
    String? contentLanguage,
    String? connection,
    String? userAgent,
  }) {
    _authorization = authorization;
    _contentType = contentType;
    _contentLanguage = contentLanguage;
    _userAgent = userAgent;
    _connection = connection ??= 'close';
  }

  Map<String, dynamic> get headers {
    Map<String, dynamic> headers = {'Connection': _connection};
    if (_userAgent != null) headers['User-Agent'] = _userAgent;
    if (_contentType != null) headers['Content-Type'] = _contentType;
    if (_authorization != null) headers['Authorization'] = _authorization;
    if (_contentLanguage != null) headers['Content-Language'] = _contentLanguage;
    return headers;
  }
}
