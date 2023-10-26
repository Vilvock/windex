import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:windex/res/assets.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';

class FilterAlertDialog extends StatefulWidget {
  FilterAlertDialog({Key? key});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<FilterAlertDialog> createState() => _FilterAlertDialog();
}

class _FilterAlertDialog extends State<FilterAlertDialog> {
  late bool _isLoading = false;

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(2021, 8, 10),
    DateTime(2021, 8, 13),
  ];

  List<DateTime?> _init = [
    DateTime(2021, 8, 13),
  ];

  final postRequest = PostRequest();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    Dimens.paddingApplication),
            child: Padding(
                padding: EdgeInsets.fromLTRB(Dimens.paddingApplication,
                    Dimens.paddingApplication, Dimens.paddingApplication, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Align(
                    //     alignment: AlignmentDirectional.topEnd,
                    //     child: IconButton(
                    //       icon: Icon(
                    //         Icons.close,
                    //         color: Colors.white,
                    //       ),
                    //       onPressed: () {
                    //         Navigator.of(context).pop();
                    //       },
                    //     )),
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child:
                  Container(
                      width: 80,
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
                            Text(
                              "Limpar",
                              textAlign:
                              TextAlign
                                  .start,
                              style: TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: Dimens
                                      .textSize4),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Text(
                      textAlign: TextAlign.center,
                      "Filtro Avançado",
                      style: TextStyle(
                        fontSize: Dimens.textSize6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.2, color: OwnerColors.lightGrey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.minRadiusApplication)),
                        ),
                        child: IntrinsicHeight(
                            child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onTap: () {},
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Selecione a categoria',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: false,
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {},
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.white,
                                )),
                          ],
                        ))),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.2, color: OwnerColors.lightGrey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.minRadiusApplication)),
                        ),
                        child: IntrinsicHeight(
                            child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onTap: () {},
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Selecione a categoria',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: false,
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {},
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.white,
                                )),
                          ],
                        ))),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Styles().div_horizontal,
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                          calendarType: CalendarDatePicker2Type.range,
                          dayTextStyle: TextStyle(color: Colors.white),
                          weekdayLabelTextStyle: TextStyle(
                              color: OwnerColors.colorPrimaryDark,
                              fontWeight: FontWeight.w900),
                          lastMonthIcon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          nextMonthIcon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                      selectedYearTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                      yearTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                      controlsTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900)),
                      value: _init,
                      onValueChanged: (dates) =>
                          _dialogCalendarPickerValue = dates,
                    ),
                    // Styles().div_horizontal,
                    // SizedBox(
                    //   height: Dimens.marginApplication,
                    // ),

                    Image.asset(Assets.putaria),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {
                          Navigator.of(context).pop();

                        },
                        child: (_isLoading)
                            ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                            : Text("Filtrar",
                                style: Styles().styleDefaultTextButton),
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                  ],
                )),
          ),
        ]));
  }
}
