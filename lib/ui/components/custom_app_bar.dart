import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windex/res/assets.dart';

import '../../global/application_constant.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleNotificationsButton;
  bool isNotVisibleLine;
  bool isVisibleIcon;
  bool isChat;
  String counter;

  CustomAppBar(
      {this.title = "",this.counter = "",
      this.isVisibleBackButton = false,
      this.isVisibleNotificationsButton = false,
        this.isNotVisibleLine = false,
      this.isVisibleIcon = false,
        this.isChat = false,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnActions(context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     child: IconButton(
          //       onPressed: () => Navigator.pop(context),
          //       icon: const Icon(Icons.arrow_back_ios, size: 20),
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 5,
            child: Container(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.merge(
                  const TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLines: 2,   // TRY THIS
              ),
            ),
          ),

          if (this.isChat)
            Text(
              "Paloma",

              style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.textSize5
              ),
              maxLines: 2,   // TRY THIS
            ),

          if (this.isChat)
          Container(
            margin: EdgeInsets.only(
                left: Dimens.minMarginApplication,
                right: Dimens.minMarginApplication),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(22),
                // Image radius
                child: Image.network(
                    ApplicationConstant.URL_PRODUCT,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, exception, stackTrack) =>
                        Image.asset(
                          Assets.person,
                        )),
              ),
            ),
          ),
        ],
      ),
      bottom: !this.isNotVisibleLine ? PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Divider(
          thickness: 0.3,
          height: 0,
          color: Colors.white,
        ),
      ) : null,
    );
  }

  Container? _returnBackIcon(bool isVisible, BuildContext context) {
    if (isVisible) {
      return Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                SystemNavigator.pop();
              }
            },
          ));
    }

    return null;
  }

  List<Widget> _returnActions(BuildContext context) {
    List<Widget> _widgetList = <Widget>[];

    if (isVisibleNotificationsButton) {
    }

    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
