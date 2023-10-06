import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../res/dimens.dart';

class SucessAlertDialog extends StatefulWidget {
  Container btnConfirm;
  String? content;

  SucessAlertDialog({
    Key? key,
    required this.btnConfirm,
    this.content,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<SucessAlertDialog> createState() => _SucessAlertDialogState();
}

class _SucessAlertDialogState extends State<SucessAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingApplication),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Lottie.network(
                    height: 140,
                    'https://assets1.lottiefiles.com/packages/lf20_o3kwwgtn.json'),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  widget.content!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimens.textSize6,
                      fontFamily: 'Inter',
                      color: Colors.black),
                ),
                widget.btnConfirm,
              ],
            ),
          ),
        ]);
  }
}
