import 'typedef.dart';

/// The empty model for raw json `{"code": 200, msg: "wow"}`
class Empty {
  const Empty();
}

/// The generics model for T
class Model<T> {
  const Model(this.code, this.msg, this.data);
  final int code;
  final String msg;
  final T data;

  /// A factory method to instancing Model<T> from map
  factory Model.fromMap(Map<String, dynamic> m, Converter<T> converter) {
    return Model(
        m.containsKey("code") ? m["code"] as int : 0,
        m.containsKey("msg") ? m["msg"] as String : "",
        converter(m.containsKey("data") && m["data"] != null
            ? m["data"]
            : <String, dynamic>{}));
  }

  @override
  String toString() {
    return '{code: $code, msg: $msg, data: $data';
  }
}
