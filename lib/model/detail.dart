
import 'global_ws_model.dart';

class Detail extends GlobalWSModel {


  final dynamic pedido;
  final List<dynamic> orcamento;

  Detail({
    required this.pedido,
    required this.orcamento,
    required super.status,
    required super.msg,
    required super.id,
    required super.rows,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      pedido: json['pedido'],
      orcamento: json['orcamento']?? ['one', 'two', 'three'],
      status: json['status'] ?? "",
      msg: json['msg'] ?? "",
      id: json['id'] ?? 0,
      rows: json['rows'] ?? "",
    );
  }
}
