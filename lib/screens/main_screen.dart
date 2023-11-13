import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/helper/adHelper.dart';
import 'package:closer/map/location.dart';
import 'package:closer/screens/language/Languages.dart';
import 'package:closer/screens/mainTabScreens/homeScreen.dart';
import 'package:closer/screens/mainTabScreens/order/userOrder.dart';
import 'package:closer/screens/mainTabScreens/order/workerOrder.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';
import 'package:closer/model/transaction.dart';
import 'package:closer/screens/Payment.dart';
import 'package:closer/screens/loading_screen.dart';
import 'package:closer/screens/superVisior/orderID.dart';
import 'package:closer/screens/service/sub_service_screen.dart';
import 'package:closer/screens/worker/taskId.dart';
import 'package:closer/screens/valid_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:closer/MyWidget.dart';
import 'package:closer/boxes.dart';
import 'package:closer/const.dart';
import 'package:closer/localization_service.dart';
import 'package:closer/main.dart';
import 'order/checkout.dart';
import 'edit_profile_screen.dart';
import 'address/manege_address.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:closer/localization_service.dart' as trrrr;
//import 'package:admob_flutter/admob_flutter.dart';

var globalPrice = 0.0;

//var id ;
// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  String token;
  List service = [];

  MainScreen(
      {required this.token,
      required this.service,
      required this.selectedIndex,
      required this.initialOrderTab});

  int selectedIndex = 0;
  int initialOrderTab = 0;

  @override
  _MainScreenState createState() => _MainScreenState(
      this.token, this.service, this.selectedIndex, this.initialOrderTab);
}

class _MainScreenState extends State<MainScreen> {
  String? lng;
  String token;
  List service = [];
  List subservice = [];
  DateTime? pickDate;
  TimeOfDay? time;

  /*void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        //showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        //showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        //showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        //showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        /*showDialog(
          context: _key.currentContext!,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return true;
              },
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args!['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
            );
          },
        );*/
        break;
      default:
    }
  }*/

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  /*
Test Id's from:
https://developers.google.com/admob/ios/banner
https://developers.google.com/admob/android/banner

App Id - See README where these Id's go
Android: ca-app-pub-3940256099942544~3347511713
iOS: ca-app-pub-3940256099942544~1458002511

Banner
Android: ca-app-pub-3940256099942544/6300978111
iOS: ca-app-pub-3940256099942544/2934735716

Interstitial
Android: ca-app-pub-3940256099942544/1033173712
iOS: ca-app-pub-3940256099942544/4411468910

Reward Video
Android: ca-app-pub-3940256099942544/5224354917
iOS: ca-app-pub-3940256099942544/1712485313
*/

  _MainScreenState(this.token, this.service, this._selectedIndex, this._initialOrderTab);

  @override
  void dispose() {
    //Hive.close();
    AdHelper.despose();
    //rewardAd.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    updateUserInfo(userData!.content!.id);
    api.getGroupUsers(groupId);
    getMyOrders(userData!.content!.id);
    super.initState();
    AdHelper.loadBanner();
    AdHelper.loadInterstitialAd(() => null);
    getAddress(userData!.content!.id);
    //getWorkersGroup(userData["content"]["Id"]);
    print("************************************************");
    print(userInfo);
    print("Token");
    print(token);
    pickDate = DateTime.now();
    time = TimeOfDay.now();

    //LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        runApp(MyApp());
      }
    });
    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: ListTile(
                    title: Text(message.notification!.title.toString(),style: TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width/25),),
                    subtitle: Text(message.notification!.body.toString(),style: TextStyle(
        fontFamily: 'comfortaa',fontSize: MediaQuery.of(context).size.width/20)),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () => {
                              setState(() {
                                _selectedIndex = 1;
                                _initialOrderTab = 1;
                                new Timer(Duration(seconds:2), ()=>setState(() {}));
                                Navigator.pop(context);
                              }),
                            },
                        child: Icon(
                          Icons.check,
                          color: AppColors.yellow,
                        ))
                  ],
                ));
      }

      //LocalNotificationService.display(message);
    });
    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //final routeFromMessage = message.data["main_screen"];
      if(!worker) {
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1, initialOrderTab: 1,)),
            (Route<dynamic> route) => false,
      );
      } else {
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1, initialOrderTab: 0,)),
            (Route<dynamic> route) => false,
      );
      }
    });
    mainService = service;
    api.userLang(trrrr.LocalizationService.getCurrentLangInt(), userData!.content!.id);

  }

  void _afterLayout(Duration timeStamp) async{
    if (await APIService.checkCountry()) {
      var _selectedCity = 0;
      var _selectedCountry = 0;
      var _selectedLang = 0;
      // ignore: use_build_context_synchronously
      MyApplication.navigateTo(
          navigatorKey.currentContext!,
          Languages(
            main: true,
            selectedCity: _selectedCity,
            selectedCountry: _selectedCountry,
            selectedLang: _selectedLang,
          ));
    }
  }

  /*
  static Future<bool> sendFcmMessage(String title, String message) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=your_server_key",
      };
      var request = {
        'notification': {'title': title, 'body': message},
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'COMMENT'
        },
        'to': 'fcmtoken'
      };
      var client = new Client();
      var response =
      await client.post(url, headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }
  */

  int _selectedIndex = 0;
  int _initialOrderTab = 0;
  APIService api = APIService();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    //api.getGroupUsers(groupId);
    //isBoss = false;
    //getMyOrders(userData["content"]["Id"]);
    //getMyOrders('9cbc8ff2-0bc3-4ed0-f6ce-08d97b89b8984444');
    //showRewardAdd();
    AdHelper.loadBanner();
    api = APIService(context: context);
    if(worker && _selectedIndex == 0) _selectedIndex = 1;
    var barHight = MediaQuery.of(context).size.height / 5.7;
    var profileHieght = MediaQuery.of(context).size.height *0.02;

    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(service: service,),
      //My order
      Container(
        child: !worker?UserOrder(initialOrderTab: _initialOrderTab):
        WorkerOrder(initialOrderTab: _initialOrderTab),
      ),
      //My profile
      DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text(AppLocalizations.of(context)!
                .translate('Tap back again to leave')),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyWidget.topYellowDriver(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                Expanded(
                  flex: 3,
                  child: FutureBuilder(
                    future: updateUserInfo(userData!.content!.id),
                    builder : (BuildContext context, AsyncSnapshot snap){
                      if(snap.connectionState == ConnectionState.waiting){
                        _loading = true;
                        return MyWidget.jumbingDotes(_loading);
                        return SizedBox();
                      }
                      else{
                        //return SizedBox();
                        _loading = false;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: userInfo == null || userInfo.isEmpty || userInfo['ImagePath'] == '$apiDomain/ProfilesFiles/${userInfo["Id"]} '
                                      ? AssetImage('assets/images/profile.jpg') as ImageProvider : NetworkImage(userInfo['ImagePath']),
                                  //https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg
                                  /*image: NetworkImage(
                                  'https://th.bing.com/th/id/OIP.kZO7eZdhGa4hJ_QJAWN7ngAAAA?pid=ImgDet&w=400&h=411&rs=1'),*/
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset:
                                    Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.height / 40)),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              //child: Text(),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyWidget(context).textTitle15('${userInfo == null || userInfo.isEmpty ? "" : userInfo["Name"]}'),
                                MyWidget(context).textTap25('${userInfo == null || userInfo.isEmpty ? "" : userInfo["Email"]}'),
                              ],
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.grey[400],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      userInfo.length==0?APIService.flushBar(AppLocalizations.of(context)!.translate('Error Connection')):
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => new EditProfileScreen(token: token),
                        ),
                      );
                    },
                    child: MyWidget(context).rowIconProfile(Icons.person_outlined, AppLocalizations.of(context)!.translate("Edit Profile")),
                  ),
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => new MagageAddressScreen(token: token),
                        ),
                      );
                    },
                    child: MyWidget(context).rowIconProfile(Icons.pin_drop_outlined, AppLocalizations.of(context)!.translate("Manage Address")),
                  ),
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async{
                      await APIService.getCountryData();
                      var _selectedCountry = country.indexWhere((element) => element['Name']==myCountry)??0;
                      await APIService.getCityData(country[_selectedCountry]['Id']);
                      var _selectedCity = city.indexWhere((element) => element['Name']==myCity)??0;
                      var _selectedLang = LocalizationService.getCurrentLangInt();
                      final box = GetStorage();
                      var lang = box.read('lng')??'English';
                      if(lang == 'English') _selectedLang = 0;
                      if(lang == 'France') _selectedLang = 2;
                      if(lang == 'العربية') _selectedLang = 1;
                      print(_selectedLang.toString());
                      // ignore: use_build_context_synchronously
                      MyApplication.navigateTo(context, Languages(main: false, selectedCity: _selectedCity, selectedCountry: _selectedCountry, selectedLang: _selectedLang,));
                      },// Navigator.pushNamed(context, 'changeLang'),
                    child: MyWidget(context).rowIconProfile(Icons.language_outlined, AppLocalizations.of(context)!.translate("Change Language")),
                  ),
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => _changePassword(userInfo["Email"]),
                    child: MyWidget(context).rowIconProfile(Icons.lock_outline, AppLocalizations.of(context)!.translate("Change Password")),
                  ),
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: MyWidget(context).rowIconProfile(Icons.more_horiz, "FAQs".tr),
                   // onTap: ()=> showRewardAdd(),
                  ),
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: MyWidget(context).rowIconProfile(Icons.mail_outline, AppLocalizations.of(context)!
                        .translate("Contact Us"),),
                   // onTap: _goAbout,
                  ),
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Divider(
                  height: 1,
                  thickness: 2,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: profileHieght,
                  //child: Text(),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => api.logOut(),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Icon(
                              Icons.logout,
                              color: AppColors.black,
                              size: min(MediaQuery.of(context).size.width / 12, MediaQuery.of(context).size.height / 28),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 22),
                            child: Container(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("Log Out"),
                                style: TextStyle(
        fontFamily: 'comfortaa',
                                  fontSize: min(MediaQuery.of(context).size.width / 20, MediaQuery.of(context).size.height / 45),
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //_bottomYellowDriver(),
              ],
            ),
          ),
        ),

    ];

    void _onItemTapped(int index) {
      setState(
        () {
          _selectedIndex = index;
        },
      );
    }
    return Scaffold(
          resizeToAvoidBottomInset: true,
          key: _key,
          appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('Our Services'), isMain: true, key: _key),
          drawer: MyWidget(context).drawer(barHight, MediaQuery.of(context).size.height / 80 * 3, ()=>_setState()),
      backgroundColor: Color(0xffF4F4F9),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                // ignore: deprecated_member_use
                label: AppLocalizations.of(context)!.translate('Home'),

              ),
              BottomNavigationBarItem(
                icon: !worker? Icon(Icons.shopping_cart_outlined) : Icon(Icons.work),
                // ignore: deprecated_member_use
                label: !worker? AppLocalizations.of(context)!.translate('My Order') :isBoss? AppLocalizations.of(context)!.translate('My Order'): AppLocalizations.of(context)!.translate('MY TASK'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                // ignore: deprecated_member_use
                label: AppLocalizations.of(context)!.translate('My profile'),
              ),
            ],
            currentIndex: _selectedIndex,
            //fixedColor: Colors.white,
            selectedItemColor: AppColors.yellow,
            backgroundColor: AppColors.mainColor,
            unselectedItemColor: AppColors.white,
            iconSize: MediaQuery.of(context).size.width / 9,
            onTap: _onItemTapped,
          ),
        )
      ;
  }

  bool chCircle = false;

  _goAbout() {
    Navigator.pushNamed(context, 'about');
  }

  List orderData = [];
  List finishedOrderData = [];
  List superNewOrderData = [];

  Future getMyOrders(var id,) async {
    try{
      var url;
      !worker?
        url = Uri.parse("$apiDomain/Main/Orders/Orders_Read?filter=CustomerId~eq~'$id'")
          :isBoss?
      url = Uri.parse("$apiDomain/Main/Orders/Orders_Read?"):
      url = Uri.parse('');
      http.Response response = await http.get(
        url, headers: {"Authorization": token,},
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        print("getOrderders success");
        myOrders = await jsonDecode(response.body);
        editTransactionMyOrders(transactions![0], myOrders);
        //print(myOrders);
        //print("****************************");
        //print(jsonDecode(response.body));
      }
      else{
        myOrders.clear();
      }
    }catch(e){
      //myOrders = transactions![0].myOrders;
    }
    print('here');
    if(worker && isBoss){
      NewOrdersSupervisor = myOrders;
      try{
        var url = Uri.parse("$apiDomain/Main/WorkerTask/WorkerTask_Read?filter=OrderService.GroupId~eq~$groupId");
        http.Response response = await http.get(
          url, headers: {
          "Authorization": token,
        },);
        print(jsonDecode(response.body));
        if (response.statusCode == 200) {
          print("getOrderders success");
          myOrders = await jsonDecode(response.body);
          editTransactionMyOrders(transactions![0], myOrders);
          print(jsonDecode(response.body));
          //print(myOrders);
          //print("****************************");
          //print(jsonDecode(response.body));
        }
        else{
          myOrders.clear();
        }
      }catch(e){
        myOrders.clear();

        //myOrders.clear();
        //myOrders = transactions![0].myOrders;
      }
    }else if(worker && !isBoss){
      NewOrdersSupervisor.clear();
      try{
        /*filter=UserId~eq~'$id'*/
        var url = Uri.parse("$apiDomain/Main/WorkerTask/WorkerTask_Read?filter=WorkerId~eq~'$id'");
        http.Response response = await http.get(url, headers: {
          "Authorization": token,
        },);
        print(jsonDecode(response.body));
        if (response.statusCode == 200) {
          print("getOrderders success");
          myOrders = await jsonDecode(response.body);
          editTransactionMyOrders(transactions![0], myOrders);
          //print(myOrders);
          //print("****************************");
          //print(jsonDecode(response.body));
        }
      }catch(e){
        myOrders.clear();
        //myOrders = transactions![0].myOrders;
      }
    }
    if(myOrders.length > 0){
      var k = myOrders['Total'];
      orderData.clear();
      for (int i = 0; i < k; i++) {
        orderData.add(myOrders['Data'][i]);
      }
      /*myOrders.forEach((key, value) {
        //if(key == 'Data')
        orderData.add(myOrders[key]);
      });*/
      if(!worker){
        orderData.sort((a, b) {
          var adate = a['OrderDate'/*'InsertDate'*/]; //before -> var adate = a.expiry;
          var bdate = b['OrderDate'/*'InsertDate'*/]; //before -> var bdate = b.expiry;
          return bdate.compareTo(adate);
        });
        finishedOrderData.clear();
        //finishedOrderData.add(orderData[0]);
        for(int i=0; i<orderData.length; i++){
          if(orderData[i]['Status'] == 8){
            finishedOrderData.add(orderData[i]);
            orderData.removeAt(i);
            i--;
          }
        }
      }
      else{
        orderData.sort((a, b) {
          var adate = a['StartDate']; //before -> var adate = a.expiry;
          var bdate = b['StartDate']; //before -> var bdate = b.expiry;
          return adate.compareTo(bdate);
        });
        if(!isBoss){
          finishedOrderData.clear();
          for(int i=0; i<orderData.length; i++){
            if(orderData[i]['Status'] == 2){
              finishedOrderData.add(orderData[i]);
              orderData.removeAt(i);
              i--;
            }
          }
        }
        else{
          for(int i=0; i<orderData.length; i++){
            if(orderData[i]['OrderService']['Order']['Status'] == 8){
              //finishedOrderData.add(orderData[i]);
              orderData.removeAt(i);
              i--;
            }
          }
        }
      }
    }
    else{
      orderData.clear();
    }
    if(NewOrdersSupervisor.length > 0){
      var k = NewOrdersSupervisor['Total'];
      superNewOrderData.clear();
      for (int i = 0; i < k; i++) {
        for(int j = 0; j<NewOrdersSupervisor['Data'][i]['Servicess'].length; j++){
          try{
            if(NewOrdersSupervisor['Data'][i]['Servicess'][j]['GroupId'] == groupId){
              superNewOrderData.add(NewOrdersSupervisor['Data'][i]);
              j = NewOrdersSupervisor['Data'][i]['Servicess'].length;
            }
          }catch(e){

          }
        }
      }
      superNewOrderData.sort((a, b) {
        var adate = a['OrderDate'/*'InsertDate'*/]; //before -> var adate = a.expiry;
        var bdate = b['OrderDate'/*'InsertDate'*/]; //before -> var bdate = b.expiry;
        return bdate.compareTo(adate);
      });
      if(superNewOrderData.length > 0)
        finishedOrderData.clear();
      for(int i=0; i<superNewOrderData.length; i++){
        if(superNewOrderData[i]['Status']== 8){
          finishedOrderData.add(superNewOrderData[i]);
          superNewOrderData.removeAt(i);
          i--;
        }
      }
    }
  }

  Future updateUserInfo(var id) async {
    try{
      print("flag1");
      var url = Uri.parse(
          "$apiDomain/Main/Users/SignUp_Read?filter=Id~eq~'$id'");
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        print("flag2");
        /*setState(
              () {
                print(jsonDecode(response.body)['result']);
            userInfo = jsonDecode(response.body)['result']['Data'][0];
            editTransactionUserUserInfo(transactions![0], userInfo);
          },
        );*/
        print(jsonDecode(response.body)['result']);
        userInfo = jsonDecode(response.body)['result']['Data'][0];
        editTransactionUserUserInfo(transactions![0], userInfo);
        print(jsonDecode(response.body));
        if(userInfo['GroupUsers'].length>0)
          _checkWorkerType(userInfo['Type'], userInfo['GroupUsers'][0]['isBoss']);
        else{
          _checkWorkerType(0, false);
        }
        print("flag3");
      } else {
        print("flag4");
        print(response.statusCode);
      }
      print("flag5");
      //await Future.delayed(Duration(seconds: 1));
    }catch(e){
      userInfo = transactions![0].userInfo;
    }
    try{
      groupId = userInfo['GroupUsers'][0]['GroupId'];
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt('groupId', groupId);
    }catch(e){

    }
  }

  void getAddress(var id) async {
    try{
      var url = Uri.parse(
          "$apiDomain/Main/ProfileAddress/ProfileAddress_Read?filter=UserId~eq~'$id'");
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var item = json.decode(response.body)["result"]['Data'];
        setState(
              () {
            Address = item;
          },
        );
      } else {
        print(response.statusCode);
        setState(
              () {
            Address = [];
          },
        );
      }
    }catch(e){
      Address = transactions![0].Address;
    }
  }

  _changePassword(email) async {
    http.Response response = await http.post(
        Uri.parse(
            '$apiDomain/main/SignUp/RequestResetPassword?UserEmail=$email'),
        headers: {
          "accept": "application/json",
        });
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      print("we're good");
      //userData = jsonDecode(response.body);
      setState(() {
        if (jsonDecode(response.body)['Errors'] == "") {
          //isLogIn = true;
          //token = jsonDecode(response.body)["content"]["Token"].toString();
          //updateUserInfo(userData["content"]["Id"]);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Verification(
              value: 'value',
              email: email,
              password: '',
            ),
          ));
        } else if (jsonDecode(response.body)['data'] ==
            "Wait one hour and retry") {
          //setState(() => chLogIn = false);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Verification(
              value: 'value',
              email: email,
              password: '',
            ),
          ));
        } else {
          //setState(() => chLogIn = false);
          Flushbar(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 30),
            icon: Icon(
              Icons.error_outline,
              size: MediaQuery.of(context).size.height / 30,
              color: AppColors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: jsonDecode(response.body)['Errors'],
            messageSize: MediaQuery.of(context).size.height / 37,
          ).show(context);
        }
      });
    } else {
      print('A network error occurred');
    }
  }

  _setState() {
    setState(() {

    });
  }

  _checkWorkerType(type, bool? _isBoss)async{
    if(type==2){
      isBoss = _isBoss!;
      worker = true;
    }
    else
      worker = false;
    //worker = false;
    //isBoss = false;
    //worker = true;
    //isBoss = true;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('worker', worker);
    sharedPreferences.setBool('isBoss', isBoss);
    print("worker = $worker");
  }

}
