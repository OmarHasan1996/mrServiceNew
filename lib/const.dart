import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/api/respons/loginData.dart';

import 'boxes.dart';
import 'model/transaction.dart';
//import 'package:admob_flutter/admob_flutter.dart';

late APIService apiService;
final apiDomain = 'https://api.mr-service.co';
List order = [];
String cityId = '1';
List task = [];
List orderAmount = [];
List allSubServices = [];
int orderCounter = 0;
LoginData? userData;
var serviceLocation;
Map<String, dynamic> myOrders = new Map<String, dynamic>();
Map<String, dynamic> NewOrdersSupervisor = new Map<String, dynamic>();
//String myCountry = 'Turkey', myCity = 'Istanbul', myCurrency = 'TL';
String? myCountry , myCity , myCurrency;
var userInfo;
final List country = [];
final List<String> userCountry = [];
final List<String> userCity = [];
final List  city = [];
final List  coupons = [];
final List<String> area = [];
final List<String> adr = [];
// ignore: deprecated_member_use
List<Transaction>? transactions;
var areaa;
var prices = 0.0;
List<double> total = [];
List Address = [];
List groupUsers = [];
List mainService = [];
var groupId = 2;
bool worker = false, isBoss = false;
var timeDiff = new Duration(seconds: 0);

String prettify(double d) => d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

/*
AdmobBannerSize? bannerSize;
late AdmobInterstitial interstitialAd;
late AdmobReward rewardAd;
*/

showInterstitialAdd() async{
/*  final isLoaded = await interstitialAd.isLoaded;
  if (isLoaded ?? false) {
    interstitialAd.show();
    interstitialAd.load();
  } else {
    //showSnackBar('Interstitial ad is still loading...');
    interstitialAd.load();
    print('Interstitial ad is still loading...');
  }*/
}

showRewardAdd() async {
  // Run this before displaying any ad.
/* await Admob.requestTrackingAuthorization();
  if (await rewardAd.isLoaded) {
    rewardAd.show();
    rewardAd.load();
  } else {
    //showSnackBar('Reward ad is still loading...');
    rewardAd.load();
    print('Interstitial ad is still loading...');
  }*/
}




Future addTransaction(service, subService, subServiceDec, userData, myOrders, userInfo, Address, order) async {
  try{
    if(userInfo == null)
      userInfo = [];
    final transaction = Transaction()
      ..service = service
      ..subService = subService
      ..subServiceDec = subServiceDec
    // ..userData = userData
      ..myOrders = myOrders
      ..userInfo = userInfo
      ..Address = Address
      ..order = order
    ;

    final box = Boxes.getTransactions();
    box.add(transaction);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }catch(e){

  }
}

void editTransaction(Transaction transaction, service, subService, subServiceDec, userData, myOrders, userInfo, Address, order) {
  transaction.service = service;
  transaction.subService = subService;
  transaction.subServiceDec = subServiceDec;
  transaction.userData = userData;
  transaction.myOrders = myOrders;
  transaction.userInfo = userInfo;
  transaction.Address = Address;
  transaction.order = order;
  // final box = Boxes.getTransactions();
  // box.put(transaction.key, transaction);
  transaction.save();
}

void editTransactionSubService(Transaction transaction, List _subService, id) {
  //subService.add({"id":id});
  transaction.subService = _subService;
  transaction.subService.add({"id":id});
  transaction.save();
  //subService.removeAt(subService.length-1);
}

void editTransactionService(transaction, service) {
  transaction.service = service;
  transaction.save();
}

void editTransactionServiceDec(Transaction transaction,List subServiceDec,id) {
  //subServiceDec.add({"id":id});
  transaction.subServiceDec = subServiceDec;
  //transaction.subServiceDec.add({"id":id});
  transaction.save();
  //subServiceDec.removeAt(subServiceDec.length-1);
}

void editTransactionUserData(Transaction transaction, userData) {
  try{
    transaction.userData = userData;
    transaction.save();
  }catch(e){
    print(e);
  }
}

void editTransactionMyOrders(Transaction transaction, myOrders) {
  transaction.myOrders = myOrders;
  transaction.save();
}

void editTransactionUserUserInfo(Transaction transaction, userInfo) {
  try{
    transaction.userInfo = userInfo;
    transaction.save();
  }catch(e){
    print(e);
  }
}

void editTransactionUserAddress(Transaction transaction, Address) {
  transaction.Address = Address;
  transaction.save();
}

void editTransactionOrder(Transaction transaction, order) {
  transaction.order = order;
  transaction.save();
}

void deleteTransaction(Transaction transaction) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);
  transaction.delete();
  //setState(() => transactions.remove(transaction));
}
