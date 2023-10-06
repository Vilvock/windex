import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../../../../global/application_constant.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../config/application_messages.dart';
import '../components/custom_app_bar.dart';
import 'home.dart';

class Success2 extends StatefulWidget {
  const Success2({Key? key}) : super(key: key);

  @override
  State<Success2> createState() => _Success2();
}

class _Success2 extends State<Success2> {
  bool _isLoading = false;

  final postRequest = PostRequest();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "",
          isVisibleBackButton: false,
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.all(Dimens.marginApplication),
                  padding: EdgeInsets.only(bottom: 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Lottie.network(
                              height: 140,
                              'https://assets1.lottiefiles.com/packages/lf20_o3kwwgtn.json')),
                      // SizedBox(height: Dimens.marginApplication),
                      // Text(
                      //   "Detalhes do pedido #",
                      //   style: TextStyle(
                      //     fontFamily: 'Inter',
                      //     fontSize: Dimens.textSize6,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.black,
                      //   ),
                      // // ),
                      // SizedBox(height: Dimens.marginApplication),
                      // Styles().div_horizontal,
                      SizedBox(height: Dimens.marginApplication),
                      Text(
                        textAlign: TextAlign.center,
                        "Pedido realizado com sucesso, aguarde aprovação dos administradores.\n\n Você pode verificar o status do seu pedido na aba \''Pedidos\".",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize8,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 100),
                      Styles().div_horizontal,

                      SizedBox(height: Dimens.marginApplication),
                      Container(
                          margin: EdgeInsets.all(Dimens.minMarginApplication),
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                    ModalRoute.withName("/ui/home"));
                              },
                              style: Styles().styleDefaultButton,
                              child: Container(
                                  child: Text("Ok",
                                      textAlign: TextAlign.center,
                                      style: Styles().styleDefaultTextButton))))
                    ],
                  )))
        ]));
  }
}
