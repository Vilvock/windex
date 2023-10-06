import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../global/application_constant.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../model/cart.dart';
import '../../model/global_ws_model.dart';
import '../../model/item.dart';
import '../../model/order.dart';
import '../../model/product.dart';
import '../components/alert_dialog_change_quantity_item.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class CartShopping extends StatefulWidget {
  const CartShopping({Key? key}) : super(key: key);

  @override
  State<CartShopping> createState() => _CartShopping();
}

class _CartShopping extends State<CartShopping> {
  bool _isLoading = false;
  late int? _idCart = null;
  int _quantity = 1;

  final postRequest = PostRequest();

  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> addOrder() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "id_carrinho": _idCart,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_ORDER, body);
      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = GlobalWSModel.fromJson(_map[0]);

      if (response.status == "01") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/ui/success2",
          (route) => false,
        );
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> updateItemCart(
      String id, String qtd) async {
    try {
      final body = {"id": id, "qtd": qtd, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_ITEM_CART, body);
      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      setState(() {});

      quantityController.text = "";

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> openCart() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.TAKE_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      _idCart = response.carrinho_aberto;

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Cart> listCartItems(String idCart) async {
    try {
      final body = {"id_carrinho": idCart, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_ITEMS_CART, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Cart.fromJson(parsedResponse);

      // setState(() {});

      return response;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> deleteItemCart(String idProduct) async {
    try {
      final body = {"id": idProduct, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DELETE_ITEM_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Carrinho", isVisibleBackButton: true),
        body: Container(
            height: double.infinity,
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: openCart(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final response = Cart.fromJson(snapshot.data![0]);

                        return FutureBuilder<Cart>(
                          future: listCartItems(
                              response.carrinho_aberto.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final response = snapshot.data!;

                              final responseList =
                                  Item.fromJson(snapshot.data!.itens[0]);

                              return Stack(children: [
                                ListView.builder(
                                  padding: EdgeInsets.only(bottom: 300),
                                  itemCount: snapshot.data!.itens.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.hasData) {
                                      final responseList = Item.fromJson(
                                          snapshot.data!.itens[index]);

                                      _quantity = responseList.qtd;

                                      if (responseList.rows != 0) {
                                        return InkWell(
                                            onTap: () => {},
                                            child: Card(
                                              elevation: 0,
                                              color: OwnerColors.lightGrey,
                                              margin: EdgeInsets.all(
                                                  Dimens.minMarginApplication),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(Dimens
                                                        .minRadiusApplication),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(Dimens
                                                    .minPaddingApplication),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .topEnd,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              showModalBottomSheet<
                                                                  dynamic>(
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                shape: Styles()
                                                                    .styleShapeBottomSheet,
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return GenericAlertDialog(
                                                                      title: Strings
                                                                          .attention,
                                                                      content:
                                                                          "Tem certeza que deseja remover este item do seu carrinho?",
                                                                      btnBack: TextButton(
                                                                          child: Text(
                                                                            Strings.no,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Inter',
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          }),
                                                                      btnConfirm: TextButton(
                                                                          child: Text(Strings.yes),
                                                                          onPressed: () async {
                                                                            await deleteItemCart(responseList.id_item.toString());
                                                                            Navigator.of(context).pop();
                                                                          }));
                                                                },
                                                              );
                                                            },
                                                          )),
                                                      ListView.builder(
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        itemCount: responseList
                                                            .produtos.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final response =
                                                              Product.fromJson(
                                                                  responseList
                                                                          .produtos[
                                                                      index]);

                                                          return InkWell(
                                                              onTap: () {},
                                                              child: Card(
                                                                elevation: 0,
                                                                color: OwnerColors
                                                                    .lightGrey,
                                                                margin: EdgeInsets
                                                                    .all(Dimens
                                                                        .minMarginApplication),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimens
                                                                              .minRadiusApplication),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                          .minPaddingApplication),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                Dimens.marginApplication),
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              SizedBox.fromSize(
                                                                            size:
                                                                                Size.fromRadius(36),
                                                                            // Image radius
                                                                            child: Image.network(ApplicationConstant.URL_PRODUCT + response.foto,
                                                                                fit: BoxFit.cover,
                                                                                /*fit: BoxFit.cover*/
                                                                                errorBuilder: (context, exception, stackTrack) => Image.asset(
                                                                                      'images/main_logo_1.png',
                                                                                    )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              response.nome_produto,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                fontFamily: 'Inter',
                                                                                fontSize: Dimens.textSize5,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: Dimens.minMarginApplication),
                                                                            Text(
                                                                              response.nome_categoria + "\nCod: #" + response.codigo_produto,
                                                                              style: TextStyle(
                                                                                fontFamily: 'Inter',
                                                                                fontSize: Dimens.textSize4,
                                                                                color: Colors.black54,
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: Dimens.marginApplication),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  "Valor:",
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Inter',
                                                                                    fontSize: Dimens.textSize3,
                                                                                    color: Colors.black54,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                    child: Text(
                                                                                  response.valor,
                                                                                  style: TextStyle(fontFamily: 'Inter', fontSize: Dimens.textSize4, color: Colors.black87, fontWeight: FontWeight.w500),
                                                                                )),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ));
                                                        },
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Row(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets.only(
                                                                    right: Dimens
                                                                        .marginApplication),
                                                                child: ClipOval(
                                                                    child: SizedBox
                                                                        .fromSize(
                                                                  size: Size
                                                                      .fromRadius(
                                                                          26),
                                                                  // Image radius
                                                                  child: Image.network(
                                                                      ApplicationConstant
                                                                              .URL_CART +
                                                                          responseList
                                                                              .url_cliente
                                                                              .toString(),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                )),
                                                              ),
                                                              Text(
                                                                "Foto do cliente",
                                                                style: TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize4),
                                                              )
                                                            ],
                                                          )),
                                                          Expanded(
                                                              child: Row(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets.only(
                                                                    right: Dimens
                                                                        .marginApplication),
                                                                child: ClipOval(
                                                                    child: SizedBox
                                                                        .fromSize(
                                                                  size: Size
                                                                      .fromRadius(
                                                                          26),
                                                                  // Image radius
                                                                  child: Image.network(
                                                                      ApplicationConstant
                                                                              .URL_CART +
                                                                          responseList
                                                                              .receita_cliente
                                                                              .toString(),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                )),
                                                              ),
                                                              Text(
                                                                "Foto da receita",
                                                                style: TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize4),
                                                              )
                                                            ],
                                                          )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: Dimens
                                                            .marginApplication,
                                                      ),
                                                      Divider(
                                                        color: Colors.black12,
                                                        height: 2,
                                                        thickness: 1.5,
                                                      ),
                                                      SizedBox(
                                                        height: Dimens
                                                            .marginApplication,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "     Quantidade: ",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          Text(
                                                            responseList.qtd
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: Dimens
                                                                  .textSize6,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                                  child:
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            showModalBottomSheet<dynamic>(
                                                                                isScrollControlled: true,
                                                                                context: context,
                                                                                shape: Styles().styleShapeBottomSheet,
                                                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                builder: (BuildContext context) {
                                                                                  return ChangeQuantityAlertDialog(
                                                                                      quantityController: quantityController,
                                                                                      btnConfirm: Container(
                                                                                          margin: EdgeInsets.only(top: Dimens.marginApplication),
                                                                                          width: double.infinity,
                                                                                          child: ElevatedButton(
                                                                                              style: Styles().styleDefaultButton,
                                                                                              onPressed: () async {
                                                                                                if (int.parse(quantityController.text.toString()) <= 0) {
                                                                                                  ApplicationMessages(context: context).showMessage("A quantidade não pode ser menos que 0");
                                                                                                  return;
                                                                                                }

                                                                                                await updateItemCart(responseList.id_item.toString(), quantityController.text.toString());
                                                                                                // updateItem2(responseList.id_item.toString(), quantityController.text.toString());

                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                              child: Text("Alterar quantidade", style: Styles().styleDefaultTextButton))));
                                                                                });
                                                                          },
                                                                          style: Styles()
                                                                              .styleDefaultButton,
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              child: Text("Alterar", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: Dimens.textSize4, color: Colors.white)))))),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "     Valor:",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "" +
                                                                  responseList
                                                                      .subtotal,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize: Dimens
                                                                      .textSize6,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                              ),
                                            ));
                                      } else {
                                        return Container(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Lottie.network(
                                                          height: 160,
                                                          'https://assets3.lottiefiles.com/packages/lf20_fzoupjne.json')),
                                                  SizedBox(
                                                      height: Dimens
                                                          .marginApplication),
                                                  Text(
                                                    Strings.empty_list,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize:
                                                          Dimens.textSize5,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ]));
                                      }
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return Container(
                                        /*width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator())*/);
                                  },
                                ),
                                Visibility(
                                  visible: responseList.rows != 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.minRadiusApplication),
                                          ),
                                          margin: EdgeInsets.all(
                                              Dimens.minMarginApplication),
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                Dimens.paddingApplication),
                                            child: Column(children: [
                                              SizedBox(
                                                  height:
                                                      Dimens.marginApplication),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Valor total:",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize:
                                                            Dimens.textSize6,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    response.total,
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize:
                                                            Dimens.textSize7,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      Dimens.marginApplication),
                                              Divider(
                                                color: Colors.black12,
                                                height: 2,
                                                thickness: 1.5,
                                              ),
                                              SizedBox(
                                                  height:
                                                      Dimens.marginApplication),
                                              Container(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: Styles()
                                                      .styleDefaultButton,
                                                  onPressed: () {
                                                    showModalBottomSheet<
                                                        dynamic>(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      shape: Styles()
                                                          .styleShapeBottomSheet,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      builder: (BuildContext
                                                          context) {
                                                        return GenericAlertDialog(
                                                            title: Strings
                                                                .attention,
                                                            content:
                                                                "Tem certeza que deseja finalizar o orçamento?",
                                                            btnBack: TextButton(
                                                                child: Text(
                                                                  Strings.no,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter',
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }),
                                                            btnConfirm:
                                                                TextButton(
                                                                    child: Text(
                                                                        Strings
                                                                            .yes),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            true;
                                                                      });

                                                                      await addOrder();

                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                    }));
                                                      },
                                                    );
                                                  },
                                                  child: (_isLoading)
                                                      ? const SizedBox(
                                                          width: Dimens
                                                              .buttonIndicatorWidth,
                                                          height: Dimens
                                                              .buttonIndicatorHeight,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: OwnerColors
                                                                .colorAccent,
                                                            strokeWidth: Dimens
                                                                .buttonIndicatorStrokes,
                                                          ))
                                                      : Text(
                                                          "Finalizar Orçamento",
                                                          style: Styles()
                                                              .styleDefaultTextButton),
                                                ),
                                              ),
                                            ]),
                                          ))
                                    ],
                                  ),
                                ),
                              ]);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return Center(child: CircularProgressIndicator());
                    }))));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
