import 'dart:convert';
import 'dart:developer';
import 'package:httphelper/src/model.dart';

import 'typedef.dart';
import 'package:http/http.dart' as http;

abstract class Http {
  static String _baseUrl = 'http://localhost:8080';

  static Uri _getUrl(String url) =>
      Uri.parse(url.contains("http") ? url : "$_baseUrl$url");

  static setBaseUrl(String url) => _baseUrl = url;

  static _getBody(Object? body) =>
      body != null ? (body is String ? body : jsonEncode(body)) : body;

  static Future<Map<String, dynamic>> sendRequest<T>(
    String method,
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
    ResponseSetter? responseSetter,
    CallbackError? callbackError,
  }) async {
    Map<String, dynamic> m = {};
    var uri = _getUrl(url);
    http.Response? response;
    var reqBody = _getBody(body);

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri);
          break;
        case 'POST':
          response = await http.post(uri, body: reqBody);
          break;
        case 'PUT':
          response = await http.put(uri, body: reqBody);
          break;
        case 'DELETE':
          response = await http.delete(uri, body: reqBody);
          break;
        default:
          throw Exception("Unsupported HTTP method: $method");
      }
      if (responseSetter != null) {
        responseSetter(response);
      }
      var jsonStr = utf8.decode(response.bodyBytes).trim();
      if (jsonStr.isEmpty) {
        jsonStr = "{}";
      } else if (!jsonStr.startsWith("{")) {
        jsonStr = '{"code":${response.statusCode},"msg":"$jsonStr"}';
      }
      m = jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (error) {
      if (callbackError != null) {
        callbackError(error);
      }
      if (error is http.ClientException) {
        log('http error: $error');
      } else {
        // other exception
        log('other error: $error');
      }
    }
    return m;
  }

  static Future<dynamic> _executeCallbacks<T>(
    int statusCode,
    Model<T> model,
    Callback200<T>? callback200,
    Callback400<T>? callback400,
    Callback401<T>? callback401,
    Callback404<T>? callback404,
    Callback500<T>? callback500,
    CallbackOther<T>? callbackOther,
  ) async {
    switch (statusCode) {
      case 200:
        if (callback200 != null) {
          callback200(model.data);
        }
        break;
      case 400:
        if (callback400 != null) {
          callback400(model.data, model.msg);
        } else if (callbackOther != null) {
          callbackOther(model.data, model.msg);
        }
        break;
      case 401:
        if (callback401 != null) {
          callback401(model.data, model.msg);
        } else if (callbackOther != null) {
          callbackOther(model.data, model.msg);
        }
        break;
      case 404:
        if (callback404 != null) {
          callback404(model.data, model.msg);
        } else if (callbackOther != null) {
          callbackOther(model.data, model.msg);
        }
        break;
      case 500:
        if (callback500 != null) {
          callback500(model.data, model.msg);
        } else if (callbackOther != null) {
          callbackOther(model.data, model.msg);
        }
        break;
      default:
        if (callbackOther != null) {
          callbackOther(model.data, model.msg);
        }
        break;
    }
  }

  static Future<Model<T>> get<T>(
    String url,
    Converter<T> converter, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Callback200<T>? callback200,
    Callback400<T>? callback400,
    Callback401<T>? callback401,
    Callback404<T>? callback404,
    Callback500<T>? callback500,
    CallbackOther<T>? callbackOther,
    CallbackError? callbackError,
  }) async {
    http.Response? resp;
    var m = await sendRequest(
      'GET',
      url,
      headers: headers,
      queryParams: queryParams,
      callbackError: callbackError,
      responseSetter: (r) => resp = r,
    );

    var model = Model.fromJson(m, converter);
    _executeCallbacks(
      resp?.statusCode ?? 0,
      model,
      callback200,
      callback400,
      callback401,
      callback404,
      callback500,
      callbackOther,
    );
    return Future<Model<T>>.value(model);
  }

  static Future<Model<T>> post<T>(
    String url,
    Converter<T> converter, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
    Callback200<T>? callback200,
    Callback400<T>? callback400,
    Callback401<T>? callback401,
    Callback404<T>? callback404,
    Callback500<T>? callback500,
    CallbackOther<T>? callbackOther,
    CallbackError? callbackError,
  }) async {
    http.Response? resp;
    var m = await sendRequest(
      'POST',
      url,
      headers: headers,
      queryParams: queryParams,
      body: body,
      callbackError: callbackError,
      responseSetter: (r) => resp = r,
    );
    var model = Model.fromJson(m, converter);
    _executeCallbacks(
      resp?.statusCode ?? 0,
      model,
      callback200,
      callback400,
      callback401,
      callback404,
      callback500,
      callbackOther,
    );
    return Future<Model<T>>.value(model);
  }

  static Future<Model<T>> put<T>(
    String url,
    Converter<T> converter, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
    Callback200<T>? callback200,
    Callback400<T>? callback400,
    Callback401<T>? callback401,
    Callback404<T>? callback404,
    Callback500<T>? callback500,
    CallbackOther<T>? callbackOther,
    CallbackError? callbackError,
  }) async {
    http.Response? resp;
    var m = await sendRequest(
      "PUT",
      url,
      headers: headers,
      queryParams: queryParams,
      body: body,
      callbackError: callbackError,
      responseSetter: (r) => resp = r,
    );
    var model = Model.fromJson(m, converter);
    _executeCallbacks(
      resp?.statusCode ?? 0,
      model,
      callback200,
      callback400,
      callback401,
      callback404,
      callback500,
      callbackOther,
    );
    return Future<Model<T>>.value(model);
  }

  static Future<Model<T>> delete<T>(
    String url,
    Converter<T> converter, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
    Callback200<T>? callback200,
    Callback400<T>? callback400,
    Callback401<T>? callback401,
    Callback404<T>? callback404,
    Callback500<T>? callback500,
    CallbackOther<T>? callbackOther,
    CallbackError? callbackError,
  }) async {
    http.Response? resp;
    var m = await sendRequest(
      'DELETE',
      url,
      headers: headers,
      queryParams: queryParams,
      body: body,
      callbackError: callbackError,
      responseSetter: (r) => resp = r,
    );
    var model = Model.fromJson(m, converter);
    _executeCallbacks(
      resp?.statusCode ?? 0,
      model,
      callback200,
      callback400,
      callback401,
      callback404,
      callback500,
      callbackOther,
    );
    return Future<Model<T>>.value(model);
  }

  static Future<Model<T>> postFile<T>(
    String url,
    Converter<T> converter, {
    String? filePath,
    List<int>? bytes,
    String field = "file",
    String? filename,
    Map<String, String>? formdata,
    Callback200<T>? callback200,
    Callback400<T>? callback400,
    Callback401<T>? callback401,
    Callback404<T>? callback404,
    Callback500<T>? callback500,
    CallbackOther<T>? callbackOther,
    CallbackError? callbackError,
  }) async {
    var req = http.MultipartRequest('POST', _getUrl(url));
    if (formdata != null) {
      req.fields.addAll(formdata);
    }
    late http.MultipartFile file;
    if (filePath != null) {
      file = await http.MultipartFile.fromPath(field, filePath,
          filename: filename);
    } else if (bytes != null) {
      file = http.MultipartFile.fromBytes(field, bytes, filename: filename);
    }
    req.files.add(file);
    var m = <String, dynamic>{};
    http.BaseResponse? rsp;
    await req.send().then((resp) async {
      rsp = resp;
      var jsonStr = await resp.stream.bytesToString();
      if (jsonStr.isEmpty) {
        jsonStr = "{}";
      }
      m = jsonDecode(jsonStr) as Map<String, dynamic>;
    }).onError((error, stackTrace) {
      if (callbackError != null) {
        callbackError.call(error);
      }
      if (error is http.ClientException) {
        log('http error: $error');
      } else {
        // other exception
        log('other error: $error');
      }
    });
    var model = Model.fromJson(m, converter);
    _executeCallbacks(
      rsp?.statusCode ?? 0,
      model,
      callback200,
      callback400,
      callback401,
      callback404,
      callback500,
      callbackOther,
    );
    return Future<Model<T>>.value(model);
  }
}
