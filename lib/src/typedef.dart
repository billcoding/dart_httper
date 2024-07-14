import 'model.dart';
import 'package:http/http.dart' as http;

/// The empth model typedef alias
typedef EmptyModel = Model<Empty>;

/// The model convertor for T
typedef Converter<T> = T Function(Map<String, dynamic> m);

/// The model callback for 200
typedef Callback200<T> = Future<dynamic> Function(T t);

/// The model callback for 400
typedef Callback400<T> = Future<dynamic> Function(T t, String msg);

/// The model callback for 401
typedef Callback401<T> = Future<dynamic> Function(T t, String msg);

/// The model callback for 404
typedef Callback404<T> = Future<dynamic> Function(T t, String msg);

/// The model callback for 500
typedef Callback500<T> = Future<dynamic> Function(T t, String msg);

/// The model callback for others
typedef CallbackOther<T> = Future<dynamic> Function(T t, String msg);

/// The model callback for error
typedef CallbackError<T> = Future<void> Function(Object? error); // for error

/// The ResponseSetter callback
typedef ResponseSetter = void Function(http.Response resp);
