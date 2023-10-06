
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import '../global/application_constant.dart';

class PostRequest {

  PostRequest();

  Future<String> sendPostRequest(String requestEndpoint, dynamic body) async {
    try {
      print(ApplicationConstant.URL_BASE + requestEndpoint);

      final response = await http.post(
        Uri.parse(ApplicationConstant.URL_BASE + requestEndpoint),

        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação POST: $e');
    }
  }

  Future<String> sendPostRequestMultiPartBudget(String requestEndpoint, String idCart, String clientName, String statusPhoto, String qtdProduct, File urlPhoto, File receipt) async {
    try {
      print(ApplicationConstant.URL_BASE + requestEndpoint);

      var request = http.MultipartRequest("POST", Uri.parse(ApplicationConstant.URL_BASE + requestEndpoint));
      request.fields['id_carrinho'] = idCart;
      request.fields['nome_cliente'] = clientName;
      request.fields['status_foto'] = statusPhoto;
      request.fields['qtd_produto'] = qtdProduct;
      request.fields['token'] = ApplicationConstant.TOKEN;

      request.files.add(await http.MultipartFile.fromPath('receita', receipt.path));
      request.files.add(await http.MultipartFile.fromPath('url', urlPhoto.path));

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print(responseString + " " + response.statusCode.toString());

      if (response.statusCode == 200) {
        return responseString;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação POST: $e');
    }
  }

  Future<String> sendPostRequestMultiPart(String requestEndpoint, File file, String idUser) async {
    try {
      print(ApplicationConstant.URL_BASE + requestEndpoint);

      var request = http.MultipartRequest("POST", Uri.parse(ApplicationConstant.URL_BASE + requestEndpoint));
      request.fields['id_usuario'] = idUser;
      request.fields['token'] = ApplicationConstant.TOKEN;

      request.files.add(await http.MultipartFile.fromPath('url', file.path));

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print(responseString + " " + response.statusCode.toString());

      if (response.statusCode == 200) {
        return responseString;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação POST: $e');
    }
  }

  Future<String> getCepRequest(String request) async {
    try {
      print(ApplicationConstant.URL_VIA_CEP + request);

      final response = await http.get(Uri.parse(ApplicationConstant.URL_VIA_CEP + request));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha na solicitação GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação GET: $e');
    }
  }

  static Future<String> loadPDF(String fileUr) async {
    var response = await http.get(Uri.parse(fileUr));

    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }
  static Future<String> loadPDFUrl(String fileUr) async {
    var response = await http.get(Uri.parse(fileUr));

    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }
}
