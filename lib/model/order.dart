
import 'global_ws_model.dart';

class Order extends GlobalWSModel{
  final String url;
  final String nome;
  final String nome_produto;
  final String nome_categoria;
  final String codigo_produto;
  final String valor_produto;
  final String foto;
  final String nome_status;
  final String data;
  final List<dynamic> itens_carrinho;
  final String total;
  final int id_status;


  Order({
    required this.url,
    required this.nome,
    required this.nome_produto,
    required this.codigo_produto,
    required this.nome_categoria,
    required this.valor_produto,
    required this.foto,
    required this.nome_status,
    required this.itens_carrinho,
    required this.total,
    required this.data,
    required this.id_status, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      url: json['url']?? "",
      nome: json['nome']?? "",
      nome_produto: json['nome_produto']?? "",
      nome_categoria: json['nome_categoria']?? "",
      codigo_produto: json['codigo_produto']?? "",
      valor_produto: json['valor_produto']?? "",
      foto: json['foto']?? "",
      nome_status: json['nome_status']?? "",
      id_status: json['id_status']?? 0,
      data: json['data']?? "",
      total: json['total']?? "",
      itens_carrinho: json['itens_carrinho']?? ['one', 'two', 'three'],
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}