import 'dart:async';
import 'dart:convert';

import 'package:closer/constant/apiUrl.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/screens/language/Languages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/localization_service.dart';
import 'package:closer/localizations.dart';
import 'package:closer/model/transaction.dart';
import 'package:closer/screens/main_screen.dart';
import 'package:closer/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyWidget.dart';
import '../boxes.dart';
import 'package:closer/constant/images.dart';

import '../constant/functions.dart';
bool x = true;
List service = [];

// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  String email;
  LoadingScreen({required this.email});
  /*static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_LoadingScreenState>()!.restartApp();
  }*/

  @override
  _LoadingScreenState createState() => _LoadingScreenState(this.email);
}

class _LoadingScreenState extends State<LoadingScreen> {
  //String? lng;
  Key key = UniqueKey();
/*
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }
*/
  String email;
  _LoadingScreenState(this.email);
  //MyFirebase myFirebase = new MyFirebase();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    print(token);
     // ignore: unnecessary_null_comparison
    _addTrans();
    print('We Are Here');
    //startTime();
    apiService = APIService(context: context);
    //lng = LocalizationService().getCurrentLang();
    DateTime date = DateTime.now();
    var duration = date.timeZoneOffset;
    timeDiff = new Duration(hours: -duration.inHours, minutes: -duration.inMinutes %60);
    print(timeDiff);
  }

  //service[] , chLogIn , response and navigate to mainScreen Or SignIn
  //only used in checkLoginMethod
  Future getServiceData(tokenn) async {
    token = tokenn;
    print(tokenn);
    var url = Uri.parse('${ApiUrl.mainServiceRead}cityid=$cityId&filter=Service.ServiceParentId~eq~null');
    http.Response response = await http.get(url, headers: {"Authorization": tokenn!,},);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var item = await json.decode(response.body)["result"]['Data'];
      /*for(int i =0; i<item.length; i++){
        if(item[i]['ServiceParentId']==null){
          item.removeAt(i);
          i--;
        }
      }*/
      setState(() { service.clear();// = item;
      for(var e in item){
        service.add(e['Service']);
      }},);
      editTransactionService(transactions![0], service);
      setState(() => chLogIn = false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: tokenn, service: service,selectedIndex: 0, initialOrderTab: 0,),),);
    } else {
      setState(
        () {
          service = [];
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignIn(),
            ),
          );
        },
      );
    }
  }

  getServiceDataOffline(tokenn, _service){
    token = tokenn;
    setState(() {service = _service;},);
    setState(() => chLogIn = false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: tokenn, service: service,selectedIndex: 0, initialOrderTab: 0,),),);
  }


  //SignIn Or fill UserData and getServiceData
  Future<void> checkLogin() async {
    if(_letsGo)
      return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString('email');
    var password = sharedPreferences.getString('password');
    var facebookEmail = sharedPreferences.getString('facebookEmail');
    var googleEmail = sharedPreferences.getString('googleEmail');
    var _token = sharedPreferences.getString('token');
    var _worker = sharedPreferences.getBool('worker');
    var _isBoss = sharedPreferences.getBool('isBoss');
    var _groupId = sharedPreferences.getInt('groupId');
    if(_worker!=null)
      worker = _worker;
    if(_isBoss!=null)
      isBoss = _isBoss;
    if(_groupId!=null)
      groupId = _groupId;
    //var service = sharedPreferences.getStringList('service');
    _addTrans();
    if(facebookEmail != '' && facebookEmail != null ){
      password = "FB_P@ssw0rd_FB";
    }
    if (_token == null && facebookEmail == null && googleEmail == null) {
      Navigator.pushNamed(context, 'sign_in');
    }
    else if (_token == '' && facebookEmail == '' && googleEmail == '') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn(),),
      );
    }
    else {
      _letsGo = true;
      token = _token!;
      var response = await APIService.login(email, password);
      _letsGo = false;
      if(response == null){
        if(transactions![0].userData.isNotEmpty){
          //userData = transactions![0].userData;
          //getServiceDataOffline(_token, transactions![0].service);
        }
        Navigator.pushNamed(context, 'sign_in');
        return;
      }
      else{
        if (response.errorCode == "") {
          userData = response;
          //editTransactionUserData(transactions![0], userData);
          token = response.content!.token.toString();
          getServiceData(token);
        }
        else{
          Navigator.pushNamed(context, 'sign_in');
        }
      }
    }
  }

  Future<void> checkLastLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString('email');
    var password = sharedPreferences.getString('password');
    var facebookEmail = sharedPreferences.getString('facebookEmail');
    var googleEmail = sharedPreferences.getString('googleEmail');
    var _token = sharedPreferences.getString('token');
    var _worker = sharedPreferences.getBool('worker');
    var _isBoss = sharedPreferences.getBool('isBoss');
    if(_worker!=null)
      worker = _worker;
    if(_isBoss!=null)
      isBoss = _isBoss;
    //var service = sharedPreferences.getStringList('service');
    _addTrans();

    if (_token == null && facebookEmail == null && googleEmail == null) {

    }
    else if (_token == '' && facebookEmail == '' && googleEmail == '') {

    }
    else {
      _letsGo = true;
      token = _token!;
      var response = await APIService.login(email, password);
      _letsGo = false;
      if(response == null){
        if(transactions![0].userData.isNotEmpty){
          //userData = transactions![0].userData;
          //getServiceDataOffline(_token, transactions![0].service);
        }
        Navigator.pushNamed(context, 'sign_in');
        return;
      }
      else{
        if (response.errorDes == "") {
          userData = response;
          //editTransactionUserData(transactions![0], userData);
          token = response.content!.token.toString();
          getServiceData(token);
        }
        else{
          //Navigator.pushNamed(context, 'sign_in');
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.selverBack,
            body: ValueListenableBuilder<Box<Transaction>>(
              valueListenable: Boxes.getTransactions().listenable(),
              builder: (context, box, _) {
                final transactions = box.values.toList().cast<Transaction>();
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagesPath.splash),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 37,
                      horizontal: MediaQuery.of(context).size.width / 22),
                  child: buildPhoneAppVertical(),
                );
              },
            ),
          ),
        ),
    );
  }

  Widget buildPhoneAppVertical() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 37,
          horizontal: MediaQuery.of(context).size.width / 22),
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Expanded(
                  flex: 4,
                  child: SizedBox(),),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Container(
                width: AppWidth.w70,
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('lang'), color: AppColors.white),
                    Text("   "),
                    MyWidget(context).dropDownLang(LocalizationService.langs, () => {setState(() {},)})
                  ],
                ),
              ),
              //start button

              Expanded(
                flex: 1,
                // ignore: deprecated_member_use
                child:MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('start_button'), ()=>checkLogin(), MediaQuery.of(context).size.width / 2, _letsGo, padV: MediaQuery.of(context).size.width/40),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('Already have an account?'), bold: false),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 72,
                    ),
                    GestureDetector(
                      onTap: () {
                        checkLogin();
                      },
                      child: MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('Login'), color:AppColors.yellow, bold: false),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _afterLayout(Duration timeStamp) {
    LocalizationService().changeLocale(LocalizationService().getCurrentLang(),context);
    checkLastLogin();
  }

  startTime() async {
    var duration = new Duration(seconds:100);
     return new Timer(duration, checkLogin);
  }

  bool _letsGo = false;
  _addTrans(){
    var box = Boxes.getTransactions();
    transactions = box.values.toList();
    if(transactions!.isEmpty)
      addTransaction(service, [], [], userData, myOrders, userInfo, Address, order);
    else{
      order = transactions![0].order;
    }
  }
}
