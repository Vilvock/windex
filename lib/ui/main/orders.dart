import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/budget.dart';
import '../../model/detail.dart';
import '../../model/order.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../auth/login/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;

  late Validator validator;
  final postRequest = PostRequest();

  User? _profileResponse;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
  }

  Future<Map<String, dynamic>> listDetailsOrder(String idOrder) async {
    try {
      final body = {"id_pedido": idOrder, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LOAD_ORDER_DETAILS, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Detail.fromJson(parsedResponse);

      final budget =
          Budget.fromJson(response.orcamento[0] as Map<String, dynamic>);

      if (budget.rows != 0) {
        var url = ApplicationConstant.URL_CART + budget.url;
        Navigator.pushNamed(context, "/ui/pdf_viewer", arguments: {
          "url": url,
        });
      }

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listOrders() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_ORDERS, body);
      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(isVisibleIcon: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: Dimens.marginApplication,
                                    left: Dimens.marginApplication,
                                    right: Dimens.marginApplication),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Meus pedidos",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   "Ver mais",
                                    //   style: TextStyle(
                                    //     fontFamily: 'Inter',
                                    //     fontSize: Dimens.textSize5,
                                    //     color: OwnerColors.colorPrimaryDark,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                  future: listOrders(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final responseItem =
                                          Order.fromJson(snapshot.data![0]);

                                      if (responseItem.rows != 0) {
                                        return ListView.builder(
                                          padding: EdgeInsets.only(bottom: 100),
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            final response = Order.fromJson(
                                                snapshot.data![index]);

                                            // Pendente,Aprovado,Rejeitado,Cancelado,Devolvido

                                            var _statusColor;

                                            switch (response.nome_status) {
                                              case "Pendente":
                                                _statusColor =
                                                    Colors.yellow[700];
                                                break;
                                              case "Confirmado":
                                                _statusColor =
                                                    Colors.green[700];
                                                break;
                                              case "Rejeitado":
                                                _statusColor =
                                                    OwnerColors.darkGrey;
                                                break;
                                              case "Cancelado":
                                                _statusColor = Colors.red;
                                                break;
                                              case "Devolvido":
                                                _statusColor =
                                                    OwnerColors.darkGrey;
                                                break;
                                            }

                                            return InkWell(
                                                onTap: () => {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/ui/order_detail",
                                                          arguments: {
                                                            "id": response.id,
                                                          })
                                                    },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Dimens
                                                            .minRadiusApplication),
                                                  ),
                                                  margin: EdgeInsets.all(Dimens
                                                      .minMarginApplication),
                                                  child: Container(
                                                    padding: EdgeInsets.all(Dimens
                                                        .minPaddingApplication),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Container(
                                                        //     margin: EdgeInsets.only(
                                                        //         right: Dimens.minMarginApplication),
                                                        //     child: ClipRRect(
                                                        //         borderRadius: BorderRadius.circular(
                                                        //             Dimens.minRadiusApplication),
                                                        //         child: Image.asset(
                                                        //           'images/person.jpg',
                                                        //           height: 90,
                                                        //           width: 90,
                                                        //         ))),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Cód: #" +
                                                                    response.id
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize: Dimens
                                                                      .textSize5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: Dimens
                                                                      .minMarginApplication),
                                                              Text(
                                                                "Data: " +
                                                                    response
                                                                        .data
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize: Dimens
                                                                      .textSize5,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: Dimens
                                                                      .minMarginApplication),
                                                              Divider(
                                                                color: Colors
                                                                    .black12,
                                                                height: 2,
                                                                thickness: 1.5,
                                                              ),
                                                              SizedBox(
                                                                  height: Dimens
                                                                      .minMarginApplication),
                                                              Row(
                                                                children: [
                                                                  Visibility(
                                                                      visible: response.id_status ==
                                                                              2
                                                                          ? true
                                                                          : false,
                                                                      child: Expanded(
                                                                          child: Container(
                                                                              child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    listDetailsOrder(response.id.toString());
                                                                                  },
                                                                                  style: Styles().styleDefaultButton,
                                                                                  child: Container(width: double.infinity, child: Text("Ver orçamento", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: Dimens.textSize4, color: Colors.white))))))),
                                                                  Visibility(
                                                                      visible: response.id_status ==
                                                                              2
                                                                          ? false
                                                                          : true,
                                                                      child: Expanded(
                                                                          child:
                                                                              Container())),
                                                                  SizedBox(
                                                                    width: 100,
                                                                  ),
                                                                  Expanded(
                                                                      flex: 0,
                                                                      child: Card(
                                                                          color: _statusColor,
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(Dimens.minRadiusApplication),
                                                                          ),
                                                                          child: Container(
                                                                              padding: EdgeInsets.all(Dimens.minPaddingApplication),
                                                                              child: Text(
                                                                                textAlign: TextAlign.center,
                                                                                response.nome_status.toString(),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Inter',
                                                                                  fontSize: Dimens.textSize4,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ))))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        );
                                      } else {
                                        return Container(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Lottie.network(
                                                          height: 160,
                                                          'https://assets3.lottiefiles.com/private_files/lf30_cgfdhxgx.json')),
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
                                      return Styles().defaultErrorRequest;
                                    }
                                    return Styles().defaultLoading;
                                  }),
                            ]))))));
  }
}
