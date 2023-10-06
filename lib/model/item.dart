import 'global_ws_model.dart';

class Item extends GlobalWSModel {
  final int qtd;
  final String valor_uni;
  final String valor;
  final String nome_produto;
  final String url_foto;
  final int id_item;
  final List<dynamic> produtos;
  final String url_cliente;
  final String receita_cliente;
  final String subtotal;
  final String nome_cliente;

  Item({
    required this.qtd,
    required this.valor_uni,
    required this.valor,
    required this.nome_produto,
    required this.url_foto,
    required this.id_item,
    required this.produtos,
    required this.url_cliente,
    required this.receita_cliente,
    required this.subtotal,
    required this.nome_cliente,
    required super.status,
    required super.msg,
    required super.id,
    required super.rows,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      qtd: json['qtd']?? 0,
      valor_uni: json['valor_uni']?? "",
      valor: json['valor']?? "",
      nome_produto: json['nome_produto']?? "",
      url_foto: json['url_foto']?? "",
      id_item: json['id_item']?? 0,
      produtos: json['produtos']?? ['one', 'two', 'three'],
      url_cliente: json['url_cliente']?? "",
      receita_cliente: json['receita_cliente']?? "",
      subtotal: json['subtotal']?? "",
      nome_cliente: json['nome_cliente']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}
