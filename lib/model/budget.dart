
import 'global_ws_model.dart';

class Budget extends GlobalWSModel{
  final String url;


  Budget({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      url: json['url']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}