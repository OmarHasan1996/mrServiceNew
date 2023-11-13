//import 'dart:convert';
import 'dart:io';

import 'package:closer/screens/order/orderRecipt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:closer/boxes.dart';
import 'package:closer/localization_service.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/Payment.dart';
import 'package:closer/screens/about.dart';
import 'package:closer/screens/superVisior/addTask.dart';
import 'package:closer/screens/language/changeLang.dart';
/*
import 'package:mr_service_2/screens/change_password.dart';
*/
import 'package:closer/screens/loading_screen.dart';
import 'package:closer/screens/main_screen.dart';
import 'package:closer/screens/superVisior/manage_task.dart';
import 'package:closer/screens/superVisior/orderID.dart';
import 'package:closer/screens/register.dart';
import 'package:closer/screens/signin.dart';
import 'package:closer/screens/service/sub_service_screen.dart';
import 'package:closer/screens/valid_code.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:closer/const.dart';
import 'firebase_options.dart';
import 'notification_ontroller.dart';
import 'firebase_options.dart';

import '../model/transaction.dart';
//import '../model/transaction.g.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:closer/screens/signin.dart' as signIn;
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'screens/language/Languages.dart';
///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  //essential for old Android versions
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  await GetStorage.init();

  NotificationController notificationController = Get.put(NotificationController());

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');

  // Initialize without device test ids.
  MobileAds.instance.initialize();
  //Admob.initialize();
  // Or add a list of test ids.
  // Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp();
  List service = [];
  bool toMainScreen= true;

 /* Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }*/

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // These delegates make sure that the localization data for the proper language is loaded
          localizationsDelegates: const [
            // THIS CLASS WILL BE ADDED LATER
            // A class which loads the translations from JSON files0
            AppLocalizations.delegate,
            // Built-in localization of basic text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          /*When you want programmatically to change the current locale in your app, you can do it in the following way:*/
          //AppLocalizations.load(Locale('en', ''));
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('fr', 'FR'),
            Locale('ar', 'AR'),
            Locale('tr', 'TR'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            //should to be in the bottom
            return supportedLocales.first;
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
          },
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          //translations: LocalizationService(),
          //locale: LocalizationService().getCurrentLocale(),
          //fallbackLocale: Locale('en', 'US'),
          navigatorKey: navigatorKey,
          home: /*Verification(value: '', email: '', password: '123456',),*/LoadingScreen(email: '',),
          routes: {
            'about': (context) => about(),
            'changeLang': (context) => ChangeLang(),
            'sign_in': (context) => SignIn(),
            //'payment': (context) => Payment(),
            'register': (context) => Register(false),
            'main_screen': (context) => MainScreen(token: '',service: [], selectedIndex: 0,initialOrderTab: 0,),
            'val_code': (context) => Verification(value: '', email: '', password: '',),
          },
        );
      },
    );

  }
}

//essential for old Android versions
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

//C:\ProgramFiles\Java\jdk1.8.0_301\bin>keytool -export -alias androiddebugkey -keystore "C:\Users\mustafa\.android\debug.keystore" | C:\OpenSSL\bin\openssl.exe sha1 -binary | C:\OpenSSL\bin\openssl.exe enc -a -e

//keytool -exportcert -alias androiddebugkey -keystore "C:\Users\mustafa\.android\debug.keystore" | C:\OpenSSL\bin\openssl.exe sha1 -binary | C:\OpenSSL\bin\openssl.exe enc -a -e

//keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android