import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:windex/res/assets.dart';
import 'package:windex/ui/components/alert_dialog_disable_account.dart';
import 'package:windex/ui/components/alert_dialog_logout.dart';
import 'package:windex/ui/main/notifications/notifications.dart';
import 'package:windex/ui/main/plans.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/cart.dart';
import '../../model/item.dart';
import '../../model/product.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';
import '../components/dot_indicator.dart';
import '../components/gradient_text.dart';
import 'main_menu.dart';
import 'qr_code_reader.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgetItems = <Widget>[];

    widgetItems.add(ContainerHome());
    widgetItems.add(QrCodeReader());
    widgetItems.add(MainMenu());

    List<Widget> _widgetOptions = widgetItems;

    return Scaffold(
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [],
          )
        ],
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class ContainerHome extends StatefulWidget {
  const ContainerHome({Key? key}) : super(key: key);

  @override
  State<ContainerHome> createState() => _ContainerHomeState();
}

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomNavBar({this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItems = <BottomNavigationBarItem>[];

    bottomNavigationBarItems.add(BottomNavigationBarItem(
        activeIcon: Image.asset(
          Assets.home,
          height: 24,
          width: 24,
          color: Colors.white,
        ),
        icon: Image.asset(
          Assets.home,
          height: 24,
          width: 24,
          color: Colors.grey,
        ),
        label: ""));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
        activeIcon: Image.asset(
          Assets.scan,
          height: 24,
          width: 24,
          color: Colors.white,
        ),
        icon: Image.asset(
          Assets.scan,
          height: 24,
          width: 24,
          color: Colors.grey,
        ),
        label: ""));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
        activeIcon: Image.asset(
          Assets.profile,
          height: 24,
          width: 24,
          color: Colors.white,
        ),
        icon: Image.asset(
          Assets.profile,
          height: 24,
          width: 24,
          color: Colors.grey,
        ),
        label: ""));
    return BottomNavigationBar(
        key: globalKey,
        elevation: Dimens.elevationApplication,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: OwnerColors.colorAccent,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: true,
        items: bottomNavigationBarItems);
  }
}

class _ContainerHomeState extends State<ContainerHome>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;
  late int? _idCart = null;
  String? _counter = "";

  late Validator validator;
  final postRequest = PostRequest();

  List<Widget> gridItems = [];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    validator = Validator(context: context);
    saveFcm();
    openCart();

    for (var i = 0; i < 4; i++) {
      // final response =
      // Product.fromJson(snapshot.data![i]);

      var source = 'images/cow.png';
      var source2 = 'images/cow.png';

      if (i == 0) {
        source = 'images/cow.png';
        source2 = 'Gado';
      } else if (i == 1) {
        source = 'images/map.png';
        source2 = 'Terras';
      } else {
        source = 'images/gavel.png';
        source2 = 'Outros';
      }

      gridItems.add(InkWell(
          onTap: () => {Navigator.pushNamed(context, "/ui/event_details")},
          child: Container(
              margin: EdgeInsets.all(Dimens.minMarginApplication),
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.white70),
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.minRadiusApplication)),
              ),
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      Container(
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(Dimens.radiusApplication),
                                  topRight: Radius.circular(
                                      Dimens.radiusApplication)),
                              child: Image.network(
                                Assets.generic_party,
                                fit: BoxFit.fitWidth,
                                height: 160,
                                errorBuilder:
                                    (context, exception, stackTrack) =>
                                        Image.asset(
                                  fit: BoxFit.fitWidth,
                                  Assets.generic_party,
                                  height: 160,
                                  width: 140,
                                ),
                              ))),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Quarta, 24 de abril ",
                                style: TextStyle(
                                    fontSize: Dimens.textSize4,
                                    fontWeight: FontWeight.w700,
                                    color: OwnerColors.colorPrimaryDark,
                                    wordSpacing: 0.5),
                              ),
                              TextSpan(
                                text: '19:30',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.textSize4,
                                    fontWeight: FontWeight.w700,
                                    wordSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.marginApplication),
                        Text(
                          "Computaria unificada",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: Dimens.textSize7,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: Dimens.marginApplication),
                        Text(
                          "Moc hall Festas",
                          style: TextStyle(
                              fontSize: Dimens.textSize5,
                              color: Colors.white70,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w100),
                        ),
                        SizedBox(
                          height: Dimens.minMarginApplication,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Distância: ",
                                style: TextStyle(
                                    fontSize: Dimens.textSize4,
                                    fontWeight: FontWeight.w400,
                                    color: OwnerColors.colorPrimaryDark,
                                    wordSpacing: 0.5),
                              ),
                              TextSpan(
                                text: '2 km',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.textSize4,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )))));
    }
    super.initState();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    categoryController.dispose();
    titleController.dispose();
    descController.dispose();
    super.dispose();
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

      listCartItems(_idCart.toString());

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

      final item = Item.fromJson(response.itens[0]);

      if (item.rows != 0) {
        setState(() {
          _counter = response.itens.length.toString();
        });
      }

      return response;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveFcm() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    try {
      await Preferences.init();
      String? savedFcmToken = await Preferences.getInstanceTokenFcm();
      String? currentFcmToken = await _firebaseMessaging.getToken();
      if (savedFcmToken != null && savedFcmToken == currentFcmToken) {
        print('FCM: não salvou');
        return;
      }

      var _type = "";

      if (Platform.isAndroid) {
        _type = ApplicationConstant.FCM_TYPE_ANDROID;
      } else if (Platform.isIOS) {
        _type = ApplicationConstant.FCM_TYPE_IOS;
      } else {
        return;
      }

      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "type": _type,
        "registration_id": currentFcmToken,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_FCM, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.saveInstanceTokenFcm("token", currentFcmToken!);
        setState(() {});
      } else {}
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listProducts() async {
    try {
      final body = {
        // "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(
          Links.LIST_PRODUCTS_HIGHLIGHTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
  }

  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SliderDrawer(
            key: _sliderDrawerKey,
            appBar: null,
            sliderOpenSize: MediaQuery.of(context).size.width * 0.74,
            slider: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimens.radiusApplication),
                    bottomRight: Radius.circular(Dimens.radiusApplication)),
              ),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 54,
                      width: 54,
                      margin: EdgeInsets.all(Dimens.marginApplication),
                      child: ClipOval(
                          child: SizedBox.fromSize(
                        size: Size.fromRadius(27),
                        // Image radius
                        child: Image.asset(
                          Assets.person,
                        ),
                      ))),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: Dimens.marginApplication),
                    child: Text(
                      "Olá, Guilherme!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: Dimens.textSize8,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.marginApplication,
                  ),
                  Container(
                    margin: EdgeInsets.all(Dimens.maxMarginApplication),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                var navigationBar = globalKey.currentWidget as BottomNavigationBar;
                                navigationBar.onTap!(2);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.profile,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Meu Perfil",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.menu_wallet,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Meus Cartões",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/ui/plans");
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.chart,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Meu Plano",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.group,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Parceiros",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.chat,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Suporte",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          InkWell(
                              onTap: () async {
                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: Styles().styleShapeBottomSheet,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return DisableAccountAlertDialog();
                                    });
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.danger,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Desativar Conta",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          InkWell(
                              onTap: () async {
                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: Styles().styleShapeBottomSheet,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return LogoutAlertDialog();
                                    });
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.exit,
                                    height: 24,
                                    width: 24,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Sair",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 36,
                          ),
                          Image.asset(
                            Assets.insta,
                            scale: 1.4,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Image.asset(
                            Assets.upgrade,
                            scale: 1.4,
                          ),
                        ]),
                  )
                ],
              )),
            ),
            child: Container(
                color: OwnerColors.colorAccent,
                child: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: IconButton(
                                  icon: Image.asset(Assets.menu,
                                      height: 24, width: 24),
                                  onPressed: () {
                                    if (_sliderDrawerKey
                                        .currentState!.isDrawerOpen) {
                                      _sliderDrawerKey.currentState!
                                          .closeSlider();
                                    } else {
                                      _sliderDrawerKey.currentState!
                                          .openSlider();
                                    }
                                  },
                                )),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(
                                  "Início",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .merge(
                                        const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                  maxLines: 2, // TRY THIS
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/ui/notifications");
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 18),
                                  child: Image.asset(Assets.bell, scale: 1.8),
                                  decoration: BoxDecoration(
                                    color: OwnerColors.colorAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                      color: Colors.white70,
                                      width: 1,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimens.minMarginApplication),
                            child: Text(
                              "Rua Lorem ipsum, 000 - RT/ 9900 es",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimens.textSize3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.4,
                                            color: OwnerColors.lightGrey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Dimens.minRadiusApplication)),
                                      ),
                                      margin: EdgeInsets.all(
                                          Dimens.maxMarginApplication),
                                      child: IntrinsicHeight(
                                          child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.search,
                                                size: 24,
                                                color: Colors.white,
                                              )),
                                          Expanded(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Nome do Evento...',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                filled: false,
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.all(
                                                    Dimens
                                                        .textFieldPaddingApplication),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Dimens.textSize5,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 34,
                                            height: 34,
                                            child: Image.asset(Assets.filter),
                                            decoration: BoxDecoration(
                                              color: OwnerColors.colorAccent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(18.0)),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 0.3,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimens.marginApplication,
                                          )
                                        ],
                                      )))),
                            ],
                          ),
                          CarouselSlider(
                            items: carouselItems,
                            options: CarouselOptions(
                              height: 100,
                              autoPlay: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _pageIndex = index;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: Dimens.marginApplication),
                          Container(
                            height: 60,
                            child: TabBar(
                              tabs: [
                                Container(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Horário",
                                      style: TextStyle(
                                        fontSize: Dimens.textSize5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                )),
                                Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Icon(
                                        Icons.map_outlined,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Proximidade",
                                          style: TextStyle(
                                            fontSize: Dimens.textSize5,
                                            fontWeight: FontWeight.w900,
                                          ))
                                    ]))
                              ],
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: OwnerColors.colorPrimary,
                              labelColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 1.8,
                              isScrollable: false,
                              controller: _tabController,
                              onTap: (value) {
                                setState(() {
                                  // if (value == 0) {
                                  //   _isChanged = false;
                                  // } else {
                                  //   _isChanged = true;
                                  // }
                                });

                                print(value);
                              },
                            ),
                          ),
                          Container(
                            child: AutoScaleTabBarView(
                                controller: _tabController,
                                children: <Widget>[
                                  Container(
                                      height: 900,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /*    FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getSpecies(widget.idAuction!),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final responseItem = GraphicModel.fromJson(snapshot.data![0]);

                                                if (responseItem.rows != 0) {
                                                  return*/
                                          SizedBox(
                                            height: Dimens.marginApplication,
                                          ),
                                          SizedBox(
                                            height: Dimens.marginApplication,
                                          ),
                                          SizedBox(
                                              height: 48,
                                              child: ListView.builder(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: /*snapshot.data!.length*/
                                                    8,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  // final response =
                                                  // GraphicModel.fromJson(snapshot.data![index]);

                                                  return InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      // width:
                                                      //     MediaQuery.of(context)
                                                      //             .size
                                                      //             .width *
                                                      //         0.40,
                                                      margin: EdgeInsets.only(
                                                          left: Dimens
                                                              .minMarginApplication,
                                                          right: Dimens
                                                              .minMarginApplication),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.2,
                                                            color: OwnerColors
                                                                .lightGrey),
                                                        borderRadius: BorderRadius
                                                            .circular(Dimens
                                                                .radiusApplication),
                                                        // color: CustomColors.greyClean,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width: Dimens
                                                                    .minMarginApplication),
                                                            Icon(
                                                                Icons
                                                                    .music_note,
                                                                color: OwnerColors
                                                                    .colorPrimary),
                                                            SizedBox(
                                                                width: Dimens
                                                                    .marginApplication),
                                                            Text(
                                                              "Categoria " +
                                                                  index
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: Dimens
                                                                      .textSize4),
                                                            ),
                                                            SizedBox(
                                                                width: Dimens
                                                                    .minMarginApplication),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )),

                                          /* } else {
                                                  //
                                                }
                                              } else if (snapshot.hasError) {
                                                return Styles().defaultErrorRequest;
                                              }
                                              return Styles().defaultLoading;
                                            },
                                          ),*/

                                          SizedBox(
                                            height: Dimens.marginApplication,
                                          ),
                                          Container(
                                              margin: EdgeInsets.all(
                                                  Dimens.maxMarginApplication),
                                              width: double.infinity,
                                              child: GradientText(
                                                align: TextAlign.start,
                                                "Lista de Eventos",
                                                style: TextStyle(
                                                    fontSize: Dimens.textSize6,
                                                    color: OwnerColors
                                                        .colorPrimaryDark,
                                                    fontWeight:
                                                        FontWeight.w900),
                                                gradient:
                                                    LinearGradient(colors: [
                                                  OwnerColors
                                                      .gradientFirstColor,
                                                  OwnerColors
                                                      .gradientSecondaryColor,
                                                  OwnerColors.gradientThirdColor
                                                ]),
                                              )),
                                          Container(
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: GridView.count(
                                              childAspectRatio: 0.60,
                                              primary: false,
                                              shrinkWrap: true,
                                              crossAxisCount: 2,
                                              children: gridItems,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    padding: EdgeInsets.all(
                                        Dimens.paddingApplication),
                                    height: /*_hasSchedule ? */
                                        700 /*: 236*/,
                                    child: Column(children: []),
                                  )
                                ]),
                          ),
                        ])))
                      ],
                    )))));
  }
}

final List<Widget> carouselItems = [
  CarouselItemBuilder(image: Assets.generic),
  CarouselItemBuilder(image: Assets.generic),
];

class CarouselItemBuilder extends StatelessWidget {
  final String image;

  const CarouselItemBuilder({Key? key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(23),
        margin: EdgeInsets.only(right: 6, left: 6),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFBDBDBD), Color(0xFFBDBDBD)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(Dimens.minRadiusApplication)),
        /*width: MediaQuery.of(context).size.width * 0.90,*/
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
