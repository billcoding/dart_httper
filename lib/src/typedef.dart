import 'model.dart';
import 'package:http/http.dart' as http;

typedef EmptyModel = Model<Empty>;
typedef Converter<T> = T Function(Map<String, dynamic> m);
typedef Callback200<T> = Future<dynamic> Function(T t);
typedef Callback400<T> = Future<dynamic> Function(T t, String msg);
typedef Callback401<T> = Future<dynamic> Function(T t, String msg);
typedef Callback404<T> = Future<dynamic> Function(T t, String msg);
typedef Callback500<T> = Future<dynamic> Function(T t, String msg);
typedef CallbackOther<T> = Future<dynamic> Function(T t, String msg);
typedef CallbackError<T> = Future<void> Function(Object? error); // for error
typedef ResponseSetter = void Function(http.Response resp);
