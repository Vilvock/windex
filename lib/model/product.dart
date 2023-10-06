
import 'global_ws_model.dart';

class Product extends GlobalWSModel{
  final String url;
  final String nome;
  final String descricao_produto;
  final String nome_produto;
  final String nome_categoria;
  final String codigo_produto;
  final String valor_produto;
  final String valor;
  final String foto;
  final List<dynamic> fotos;

  Product({
    required this.url,
    required this.nome,
    required this.nome_produto,
    required this.descricao_produto,
    required this.codigo_produto,
    required this.nome_categoria,
    required this.valor_produto,
    required this.valor,
    required this.foto,
    required this.fotos, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      url: json['url']?? "",
      nome: json['nome']?? "",
      nome_produto: json['nome_produto']?? "",
      descricao_produto: json['descricao_produto']?? "",
      nome_categoria: json['nome_categoria']?? "",
      codigo_produto: json['codigo_produto']?? "",
      valor_produto: json['valor_produto']?? "",
      valor: json['valor']?? "",
      fotos: json['fotos']?? ['one', 'two', 'three'],
      foto: json['foto']?? "",
      status: json['status']?? "",
      msg: json['msg']?? "",
      id: json['id']?? 0,
      rows: json['rows']?? "",
    );
  }

}