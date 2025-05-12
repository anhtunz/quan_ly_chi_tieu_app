import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../cache/locale_manager.dart';
import '../constants/app/app_constants.dart';
import '../constants/enums/locale_keys_enum.dart';

class NetworkManager {
  NetworkManager._init();
  static NetworkManager? _instance;
  static NetworkManager? get instance => _instance ??= NetworkManager._init();

  Future<Map<String, String>> getHeaders() async {
    String? token =
        LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Access-Control-Allow-Credentials": "false",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Access-Control-Allow-Origin': "*",
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
      'Authorization': token,
    };
    return headers;
  }

  /// Retrieves data from the server using a GET request.
  ///
  /// [path] is the endpoint for the request. Returns the response body as a
  /// [String] if the request is successful (status code 200), or an empty
  /// string if the request fails
  Future<http.Response> getDataFromServer(String path) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] GET url: $url");
    final headers = await getHeaders();
    final response = await http.get(url, headers: headers);
    return response;
  }

  /// Sends a GET request to the server with the specified parameters.
  ///
  /// This function constructs a URL from the provided [path] and [params],
  /// then sends an HTTP GET request to the server. If the response has a
  /// status code of 200, the function returns the response body.
  /// Otherwise, it returns an empty string.
  ///
  /// [path] is the endpoint on the server.
  /// [params] is a map containing query parameters for the request.
  ///
  /// Returns a [Future<String>] containing the server response body.
  Future<http.Response> getDataFromServerWithParams(
      String path, Map<String, dynamic> params) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path, params);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] GET Params url: $url");
    final headers = await getHeaders();
    final response = await http.get(url, headers: headers);
    return response;
  }

  /// Creates new data on the server using a POST request.
  ///
  /// [path] is the endpoint for the request, and [body] contains the data
  /// to be sent. Returns the HTTP status code of the response.
  Future<http.Response> createDataInServer(
      String path, Map<String, dynamic> body) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] POST url: $url");
    final headers = await getHeaders();
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  /// Updates existing data on the server using a PUT request.
  ///
  /// [path] is the endpoint for the request, and [body] contains the data
  /// to be updated. Returns the HTTP status code of the response.
  Future<http.Response> updateDataInServer(
      String path, Map<String, dynamic> body) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] PUT url: $url");
    final headers = await getHeaders();
    final response =
        await http.put(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  /// Deletes data from the server using a DELETE request.
  ///
  /// [path] is the endpoint for the request. Returns the HTTP status code
  /// of the response, indicating the result of the deletion operation.
  /// A status code of 200 indicates success, while other codes indicate
  /// failure or an error.
  Future<http.Response> deleteDataInServer(
      String path, Map<String, dynamic> parameters) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path, parameters);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}]   DELETE url: $url");
    final headers = await getHeaders();
    final response = await http.delete(url, headers: headers);
    return response;
  }

  Future<http.Response> uploadImageToServer({
    required String path,
    required File imageFile,
  }) async {
    // Kiểm tra file có tồn tại
    if (!imageFile.existsSync()) {
      throw Exception('Image file does not exist: ${imageFile.path}');
    }

    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] POST url: $url");

    // Lấy token
    String? token =
        LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    if (token.isEmpty) {
      throw Exception('Authorization token is missing or invalid');
    }

    // Tạo headers, chỉ giữ header cần thiết
    final headers = {
      'Accept': 'application/json',
      'Authorization': token,
    };

    // Tạo MultipartRequest
    final request = http.MultipartRequest('POST', url)..headers.addAll(headers);

    // Thêm file ảnh
    final fileName = imageFile.path.split('/').last;
    final multipartFile = await http.MultipartFile.fromPath(
      'File',
      imageFile.path,
      filename: fileName,
    );
    request.files.add(multipartFile);

    // Gửi request và nhận response
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] Response status: ${response.statusCode}");
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] Response body: ${response.body}");

    return response;
  }
}
