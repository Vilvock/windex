import 'global_ws_model.dart';

class Cart extends GlobalWSModel{
  final dynamic valor_minimo;
  final String total;
  final dynamic carrinho_aberto;
  final List<dynamic> itens;

  Cart({required this.valor_minimo,
    required this.total,
    required this.carrinho_aberto,
    required this.itens, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      total: json['total']?? "",
      valor_minimo: json['valor_minimo']?? 0,
      itens: json['itens']?? ['one', 'two', 'three'],
      carrinho_aberto: json['carrinho_aberto']?? 0,
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? 0,
    );
  }

}