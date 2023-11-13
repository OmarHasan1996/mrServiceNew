// ignore_for_file: file_names, prefer_typing_uninitialized_variables

// import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:closer/navigationAnimation/fadeTransaction.dart';
import 'package:closer/navigationAnimation/scalePage.dart';
import 'package:closer/navigationAnimation/sizeTransaction.dart';
import 'package:flutter/material.dart';

class MyApplication {
  // static Future<bool> checkConnection() async {
  //   var connectivityResult;

  //   connectivityResult = await (Connectivity().checkConnectivity());

  //   {
  //     return connectivityResult == ConnectivityResult.none ? false : true;
  //   }
  // }

  static void navigateToReplace(BuildContext context, Widget page) async {
//    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => page));
    Navigator.of(context).pushReplacement(FadeRoute(page: page));// MaterialPageRoute(builder: (context) => page));
  }

  static void navigateTo(BuildContext context, Widget page) async {
    Navigator.of(context).push(FadeRoute(page: page));//MaterialPageRoute(builder: (context) => page));
  }

  static Future<void> navigateTorePlaceUntil(BuildContext context, Widget page) async {
    await Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: page),//MaterialPageRoute(builder: (context) => page),
          (route) => false,
    );
  }

}
