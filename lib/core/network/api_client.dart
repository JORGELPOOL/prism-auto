import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin HTTP client for PRISM AUTO's live backend (Section 4 of the Final
/// Master Spec v2). No auth is wired in server-side yet — every request
/// just needs a userId in its body/query, per the spec's "one honest gap."
/// [authTokenProvider] is the hook for adding a Supabase bearer token
/// later without touching any repository or screen code.
class ApiClient {
  static const String baseUrl =
      'https://prism-production-a1be.up.railway.app/api';

  /// Set this once real auth exists, e.g.
  /// `ApiClient.authTokenProvider = () => supabase.auth.currentSession?.accessToken;`
  static String? Function()? authTokenProvider;

  final http.Client _http;
  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  Map<String, String> get _headers {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = authTokenProvider?.call();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    return _decode(await _http.get(uri, headers: _headers));
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _decode(await _http.post(uri,
        headers: _headers, body: body == null ? null : jsonEncode(body)));
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _decode(await _http.patch(uri,
        headers: _headers, body: body == null ? null : jsonEncode(body)));
  }

  Future<dynamic> put(Uri uri,
      {required List<int> bytes, required String contentType}) async {
    final response = await _http.put(uri,
        headers: {'Content-Type': contentType}, body: bytes);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Upload failed (${response.statusCode})',
          statusCode: response.statusCode);
    }
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    String message = 'Request failed (${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] != null)
        message = decoded['error'].toString();
    } catch (_) {
      // Non-JSON error body — keep the generic message.
    }
    throw ApiException(message, statusCode: response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, {required this.statusCode});
  @override
  String toString() => message;
}
