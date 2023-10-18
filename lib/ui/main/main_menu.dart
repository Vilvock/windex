import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/assets.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../auth/login/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  final postRequest = PostRequest();
  User? _profileResponse;

  late bool _isLoading = false;

  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cellphoneController.dispose();
    nameController.dispose();

    super.dispose();
  }

  Future<List<Map<String, dynamic>>> loadProfileRequest() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> disableAccount() async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DISABLE_ACCOUNT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.init();
        Preferences.clearUserData();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            ModalRoute.withName("/ui/login"));
      } else {}
      ApplicationMessages(context: context)
          .showMessage(response.msg + "\n\n" + Strings.enable_account);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Meu Perfil", isVisibleBackButton: false),
        resizeToAvoidBottomInset: false,
        body: Container(
                padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                alignment: Alignment.center,
                                height: 94,
                                width: 94,
                                margin: EdgeInsets.only(
                                    right: Dimens.marginApplication),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(47),
                                          // Image radius
                                          child: Image.asset(
                                            Assets.default_image,
                                          ),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: FittedBox(
                                                child:
                                                    FloatingActionButton.small(
                                                  child: Image.asset(
                                                    Assets.edit,
                                                    width: 18,
                                                    height: 18,
                                                  ),
                                                  backgroundColor:
                                                      OwnerColors.colorAccent,
                                                  onPressed: () {},
                                                ),
                                              )))
                                    ]))),
                        SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              bottom: Dimens.minMarginApplication),
                          child: Text(
                            "Dados Cadastrais",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: Dimens.textSize6,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.marginApplication),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              bottom: Dimens.minMarginApplication),
                          child: Text(
                            "Nome Completo",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: Dimens.textSize4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white70, width: 0.8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.4),
                            ),
                            hintText: 'Nome Completo',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimens.radiusApplication),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: OwnerColors.colorAccent,
                            contentPadding: EdgeInsets.all(
                                Dimens.textFieldPaddingApplication),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimens.textSize5,
                          ),
                        ),
                        SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              bottom: Dimens.minMarginApplication),
                          child: Text(
                            "Whatsapp",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: Dimens.textSize4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        TextField(
                          inputFormatters: [Masks().cellphoneMask()],
                          controller: cellphoneController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white70, width: 0.8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.4),
                            ),
                            hintText: '(00) 00000-0000',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimens.radiusApplication),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: OwnerColors.colorAccent,
                            contentPadding: EdgeInsets.all(
                                Dimens.textFieldPaddingApplication),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimens.textSize5,
                          ),
                        ),
                        SizedBox(height: 32),
                        InkWell(
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Editar Paixöes",
                                          style: TextStyle(
                                            fontSize: Dimens.textSize6,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    size: 20,
                                    Icons.arrow_forward_ios,
                                    color: OwnerColors.lightGrey,
                                  )
                                ],
                              ),
                            ),
                            onTap: () {

                              Navigator.pushNamed(context, "/ui/passions");
                            }),
                        SizedBox(height: 32),
                        InkWell(
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Alterar senha",
                                          style: TextStyle(
                                            fontSize: Dimens.textSize6,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    size: 20,
                                    Icons.arrow_forward_ios,
                                    color: OwnerColors.lightGrey,
                                  )
                                ],
                              ),
                            ),
                            onTap: () {

                            }),
                        SizedBox(height: 32),
                        Spacer(),
                        Container(
                          margin:
                              EdgeInsets.only(top: Dimens.marginApplication),
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: Styles().styleDefaultButton,
                            onPressed: () async {},
                            child: (_isLoading)
                                ? const SizedBox(
                                    width: Dimens.buttonIndicatorWidth,
                                    height: Dimens.buttonIndicatorHeight,
                                    child: CircularProgressIndicator(
                                      color: OwnerColors.colorAccent,
                                      strokeWidth:
                                          Dimens.buttonIndicatorStrokes,
                                    ))
                                : Text("Alterar",
                                    style: Styles().styleDefaultTextButton),
                          ),
                        ),
                        SizedBox(height: Dimens.marginApplication),
                      ],
                    ),
                  ),
                ])));
  }
}
