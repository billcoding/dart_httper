import 'typedef.dart';

class Empty {
  const Empty();
}

class Model<T> {
  const Model(this.code, this.msg, this.data);
  final int code;
  final String msg;
  final T data;

  factory Model.fromJson(Map<String, dynamic> m, Converter<T> converter) {
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

class PageModel<T> {
  const PageModel(this.total, this.list);
  final int total;
  final List<T> list;

  factory PageModel.fromJson(Map<String, dynamic> m, Converter<T> converter) {
    return PageModel(
        m.containsKey("total") ? m["total"] as int : 0,
        m.containsKey("list") && m["list"] != null
            ? (m["list"] as List<dynamic>)
                .map((e) => e as Map<String, dynamic>)
                .map(converter)
                .toList()
            : []);
  }

  @override
  String toString() {
    return '{total: $total, list: [${list.map((e) => e.toString()).join(",")}]';
  }
}
