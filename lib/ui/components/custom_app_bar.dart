import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleNotificationsButton;
  bool isVisibleIcon;
  String counter;

  CustomAppBar(
      {this.title = "",this.counter = "",
      this.isVisibleBackButton = false,
      this.isVisibleNotificationsButton = false,
      this.isVisibleIcon = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnFavoriteIcon(context),
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
        ],
      ),
    );
  }

  Container? _returnBackIcon(bool isVisible, BuildContext context) {
    if (isVisible) {
      return Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: OwnerColors.colorPrimary,
              size: 20,
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

  List<Widget> _returnFavoriteIcon(BuildContext context) {
    List<Widget> _widgetList = <Widget>[];

    if (isVisibleNotificationsButton) {
      _widgetList.add(IconButton(
        icon: Stack(
          children: <Widget>[
             Image.asset('images/cart.png', height: 24, width: 24, color: OwnerColors.colorPrimary,),
            Visibility(visible: counter != "" && counter != "0", child:
            Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(7),
                ),
                constraints: BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  counter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/ui/cart");
        },
      ));
    }

    if (isVisibleNotificationsButton) {
      _widgetList.add(IconButton(
        icon:
        Image.asset('images/bell.png', height: 24, width: 24, color: OwnerColors.colorPrimary,),
        onPressed: () {
          Navigator.pushNamed(context, "/ui/notifications");
        },
      ));
    }

    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
