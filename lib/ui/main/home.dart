import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:windex/res/assets.dart';

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
import 'main_menu.dart';
import 'orders.dart';

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
    widgetItems.add(Orders());
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
            children: [
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.all(Dimens.marginApplication),
                      width: 140,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/ui/begin");
                          },
                          style: Styles().styleDefaultButton,
                          child: Container(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: Dimens.minMarginApplication,
                              ),
                              Text("Orçamento",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Dimens.textSize5,
                                      color: Colors.white))
                            ],
                          )))))
            ],
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
      activeIcon: Image.asset('images/home.png', height: 24, width: 24, color: OwnerColors.colorPrimary,),
      icon: Image.asset('images/home.png', height: 24, width: 24, color: OwnerColors.colorPrimaryDark,),
      label: Strings.home,
    ));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
      activeIcon: Image.asset('images/list.png', height: 24, width: 24, color: OwnerColors.colorPrimary,),
      icon: Image.asset('images/list.png', height: 24, width: 24, color: OwnerColors.colorPrimaryDark,),
      label: Strings.orders,
    ));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
      activeIcon: Image.asset('images/menu.png', height: 24, width: 24, color: OwnerColors.colorPrimary,),
      icon: Image.asset('images/menu.png', height: 24, width: 24, color: OwnerColors.colorPrimaryDark,),
      label: Strings.menu,
    ));
    return BottomNavigationBar(
        key: globalKey,
        elevation: Dimens.elevationApplication,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: OwnerColors.colorPrimary,
        unselectedItemColor: OwnerColors.darkGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: bottomNavigationBarItems);
  }
}

class _ContainerHomeState extends State<ContainerHome> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;
  late int? _idCart = null;
  String? _counter = "";

  late Validator validator;
  final postRequest = PostRequest();

  @override
  void initState() {
    validator = Validator(context: context);
    saveFcm();
    openCart();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Início",
          isVisibleIcon: true,
          isVisibleBackButton: false,
          isVisibleNotificationsButton: true,
          counter: _counter.toString(),
          // isVisibleTaskAddButton: true,
        ),
        body: Container(
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: SingleChildScrollView(
                    child: Container(
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: OwnerColors.lightGrey),
                                        borderRadius: BorderRadius.all(Radius.circular(
                                            Dimens.minRadiusApplication)),
                                      ),
                                      margin: EdgeInsets.all(Dimens.marginApplication),
                                      child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Image.asset('images/search.png',
                                                      width: 20, height: 20)),
                                              Expanded(
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Pesquisar...',
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey),
                                                    filled: false,
                                                    border: InputBorder.none,
                                                    fillColor: Colors.white,
                                                    contentPadding: EdgeInsets.all(
                                                        Dimens.textFieldPaddingApplication),
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: Dimens.textSize5,
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(
                                                color: Colors.black12,
                                                width: 2,
                                                thickness: 1.5,
                                                indent: 6,
                                                endIndent: 6,
                                              ),
                                              IconButton(
                                                  onPressed: () async {

                                                  },
                                                  icon: Image.asset('images/filter.png',
                                                      width: 20, height: 20)),
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

                        ])
                    )
                )
            )
        )
    );
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
            gradient: LinearGradient(colors: [
              OwnerColors.lightGrey,
              OwnerColors.lightGrey
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(Dimens.minRadiusApplication)),
        /*width: MediaQuery.of(context).size.width * 0.90,*/
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}