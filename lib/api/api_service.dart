import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:closer/api/respons/loginData.dart';
import 'package:closer/api/respons/registerData.dart';
import 'package:closer/constant/apiUrl.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/main.dart';
import 'package:closer/screens/language/Languages.dart';
import 'package:closer/screens/photoView/photoViewer.dart';
import 'package:closer/screens/valid_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:closer/color/MyColors.dart';
import 'package:closer/firebase/Firebase.dart';
import 'package:closer/localizations.dart';
import 'package:closer/model/transaction.dart';
import 'dart:convert';

//import 'package:mr_service/module/login_module.dart';
import 'package:closer/screens/loading_screen.dart';
import 'package:closer/screens/order/newOrder.dart';
import 'package:closer/screens/signin.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

import '../const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization_service.dart';
import 'package:closer/localizations.dart';
import 'package:closer/localization_service.dart' as trrrr;

class APIService {
  static MyFirebase myFirebase = new MyFirebase();
  BuildContext? context;
  APIService({this.context});

  static Future getCityData(countryId) async {
    print("getCityData is called");
    var url = Uri.parse('$apiDomain/Main/City/City_Read');
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      city.clear();
      print("response.statusCode is 200");
      var item = json.decode(response.body);
      for (int i = 0; i < item["Data"].length; i++) {
        if (item["Data"][i]["CountryId"] == countryId) {
          city.add(item["Data"][i]);
        }
      }
    } else {}
    print("getCityData finished");
  }

  static Future getCouponRead() async {
    var url = Uri.parse('$apiDomain/Main/Coupons/Coupon_Read');
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": token,
      },
    );
    coupons.clear();
    if (response.statusCode == 200) {
      print("response.statusCode is 200");
      var item = json.decode(response.body);
      for (var i in item['Data']) {
        coupons.add(i);
      }
      print(item);
    } else {}
  }

  static Future getCountryData() async {
    var url = Uri.parse('$apiDomain/Main/Country/Country_Read');
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      country.clear();
      var item = json.decode(response.body);
      for (var i in item["Data"]) {
        country.add(i);
        /*if (item["Data"][i]["Name"] == 'C') {
              country.add(item["Data"][i]["Name"]);
            }*/
      }
    } else {}
  }

  static Future getMyOrders(var id) async {
    try {
      var url;
      !worker
          ? url = Uri.parse(
              "$apiDomain/Main/Orders/Orders_Read?filter=CustomerId~eq~'$id'")
          : isBoss
              ? url = Uri.parse("$apiDomain/Main/Orders/Orders_Read?")
              : url = Uri.parse('');
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        print("getOrderders success");
        myOrders = await jsonDecode(response.body);
        editTransactionMyOrders(transactions![0], myOrders);
        //print(myOrders);
        //print("****************************");
        //print(jsonDecode(response.body));
      } else {
        myOrders.clear();
      }
    } catch (e) {
      //myOrders = transactions![0].myOrders;
    }
    print('here');
    if (worker && isBoss) {
      NewOrdersSupervisor = myOrders;
      try {
        var url = Uri.parse(
            "$apiDomain/Main/WorkerTask/WorkerTask_Read?filter=OrderService.GroupId~eq~$groupId");
        http.Response response = await http.get(
          url,
          headers: {
            "Authorization": token,
          },
        );
        print(jsonDecode(response.body));
        if (response.statusCode == 200) {
          print("getOrderders success");
          myOrders = await jsonDecode(response.body);
          editTransactionMyOrders(transactions![0], myOrders);
          print(jsonDecode(response.body));
          //print(myOrders);
          //print("****************************");
          //print(jsonDecode(response.body));
        } else {
          myOrders.clear();
        }
      } catch (e) {
        myOrders.clear();

        //myOrders.clear();
        //myOrders = transactions![0].myOrders;
      }
    } else if (worker && !isBoss) {
      NewOrdersSupervisor.clear();
      try {
        /*filter=UserId~eq~'$id'*/
        var url = Uri.parse(
            "$apiDomain/Main/WorkerTask/WorkerTask_Read?filter=WorkerId~eq~'$id'");
        http.Response response = await http.get(
          url,
          headers: {
            "Authorization": token,
          },
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
      } catch (e) {
        myOrders.clear();
        //myOrders = transactions![0].myOrders;
      }
    }
  }

  static Future<LatLng?> checkLocation(var orderserviceid) async {
    try {
      var url;
      url = Uri.parse(
          "$apiDomain/Main/WorkerTask/WorkerTask_checklocation?orderserviceid=$orderserviceid");
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        print("getOrderders success");
        serviceLocation = await jsonDecode(response.body);
        for (var t in serviceLocation['Data'][0]['WorkerTasks']) {
          if (t['User']['lng'] == null || t['User']['lat'] == null) {
            //flushBar("Can't get driver location");
          } else {
            var lat = t['User']['lat'] ?? 25.55;
            var lng = t['User']['lng'] ?? 55.55;
            return LatLng(lat, lng);
          }
        }

        //editTransactionMyOrders(transactions![0], myOrders);
        //print(myOrders);
        //print("****************************");
        //print(jsonDecode(response.body));
      } else {
        return null;
        //serviceLocation.clear();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static dialogBuilder(text) {
    if (navigatorKey.currentContext != null) {
      return showDialog<void>(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Dialog(
            //title: const CloseButton(),
            backgroundColor: Colors.transparent,
            child: Container(
              height: AppHeight.h40,
              padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p10, vertical: AppPadding.p20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4)),
                color: AppColors.mainColor.withOpacity(0.9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: AppHeight.h10,
                    color: AppColors.white,
                  ),
                  SizedBox(
                    height: AppHeight.h1,
                  ),
                  //MyWidget.bodyText(text, scale: 0.7, maxLine: 7, color: AppColors.white),
                  SizedBox(
                    height: AppHeight.h1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p20),
                    child:
                        SizedBox(), //MyWidget.elevatedButton(text: 'Close'.tr(), press: ()=> Navigator.of(context).pop(), backcolor: AppColors.mainColor2, height: AppHeight.h4 ,fontSize: FontSize.s16),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static flushBarErrorRigester(message) async {
    await Flushbar(
      icon: Icon(
        Icons.error_outline,
        size: AppWidth.w5,
        color: AppColors.white,
      ),
      shouldIconPulse: false,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(AppHeight.h2)),
      backgroundColor: Colors.grey.withOpacity(0.5),
      barBlur: 20,
      message: message,
      messageSize: AppWidth.w4,
      // ignore: deprecated_member_use
      mainButton: ElevatedButton(
        onPressed: () {
          MyApplication.navigateToReplace(
              navigatorKey.currentContext!, SignIn());
        },
        child: Text(
          AppLocalizations.of(navigatorKey.currentContext!)!
              .translate('Log in Now'),
          style: TextStyle(
            fontFamily: 'comfortaa',
            color: AppColors.white,
            fontSize: AppWidth.w4,
          ),
        ),
      ),
    ).show(navigatorKey.currentContext!);
  }

  static Future<RegisterData?> register({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    try {
      var apiUrl = Uri.parse('$apiDomain/Main/SignUp/SignUp_Create');
      Map mapDate = {
        "Name": firstName,
        "LastName": lastName,
        "Mobile": mobile,
        "Email": email,
        "Password": password,
      };
      print(jsonEncode(mapDate));
      http.Response response =
          await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
        "Accept-Language": LocalizationService.getCurrentLocale().languageCode,
        "Accept": "application/json",
        "content-type": "application/json",
      });
      if (response.statusCode == 200) {
        String x = response.body;
        if (jsonDecode(x)["Errors"] == '' || jsonDecode(x)["Errors"] == null) {
          var value = jsonDecode(x)["Data"][0]["Id"].toString();
          RegisterData _model = registerDataFromJson(x);
          //userData = _model.data;
          return _model;
        } else {
          await flushBarErrorRigester(jsonDecode(x)["Errors"]);
        }
      } else if (response.statusCode == 500) {
        await Flushbar(
          icon: Icon(
            Icons.error_outline,
            size: AppWidth.w5,
            color: AppColors.white,
          ),
          duration: Duration(seconds: 5),
          shouldIconPulse: false,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.all(Radius.circular(AppHeight.h2)),
          backgroundColor: Colors.grey.withOpacity(0.5),
          barBlur: 20,
          message: AppLocalizations.of(navigatorKey.currentContext!)!
              .translate('Server is busy try again later'),
          messageSize: AppWidth.w5,
        ).show(navigatorKey.currentContext!);
      } else {
        await flushBarErrorRigester(
            AppLocalizations.of(navigatorKey.currentContext!)!
                .translate('This Email Already Existed'));
      }
    } catch (e) {
      dialogBuilder(e.toString());
    }
    return null;
  }

  static Future<bool> checkCountry() async {
    try{
      final box = GetStorage();
      print(box.read('city'));
      myCity = box.read('city') ?? myCity;
      myCountry = box.read('country') ?? myCountry;
      myCurrency = box.read('currency') ?? myCurrency;
      await APIService.getCountryData();
      var _selectedCountry = 0;
      if (box.read('country') != null) {
        _selectedCountry = country.indexWhere((element) => element['Name'] == myCountry) < 0 ? 0 : country.indexWhere((element) => element['Name'] == myCountry);
      }
      await APIService.getCityData(country[_selectedCountry]['Id']);
      if (box.read('city') == null)
        return true;
      else {
        cityId = city[city.indexWhere((element) => element['Name'] == myCity)]['Id'].toString();
        return false;
      }
    }catch(e){
      return true;
    }

  }

  static Future<LoginData?> login(email, password) async {
    var fcmToken;
    try {
      fcmToken = await myFirebase.getToken();
      print(fcmToken);
    } catch (e) {
      fcmToken = '';
      print(e);
      flushBar(e.toString());
      chLogIn = false;
    }
    try {
      http.Response response = await http.post(
          Uri.parse('$apiDomain/api/Auth/login?'),
          body: jsonEncode({
            "UserName": email,
            "Password": password,
            "FBKey": fcmToken.toString()
          }),
          headers: {
            "Accept-Language":
                trrrr.LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if (response.statusCode == 200) {
        //if(response.body['eroor'])
        var m = loginDataFromJson(response.body);
        if(m.errorCode == 2){
          MyApplication.navigateTo(
              navigatorKey.currentContext!,
              Verification(
                value: m.content!.id,
                email: email,
                password: password,
              ));
          chLogIn = false;
        }
        else if(m.errorDes.isNotEmpty){
          flushBar(m.errorDes);
          chLogIn = false;
        }
        else{
          token = m.content == null ? '' : m.content!.token!;

          chLogIn = false;
          return m;
        }
      }
    } catch (e) {
      flushBar(AppLocalizations.of(navigatorKey.currentContext!)!
          .translate('please! check your network connection'));
      print(e);
      chLogIn = false;
    }
    return null;
  }

  static getAddress(var id) async {
    try {
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

        Address = item;
      } else {
        print(response.statusCode);
        Address = [];
      }
    } catch (e) {
      Address = transactions![0].Address;
    }
  }

  userLang(langNum, id) async {
    try {
      http.Response response = await http.post(
          Uri.parse('$apiDomain/Main/Users/UserLang_Update?'),
          body: jsonEncode(
              {"intParam": langNum.toString(), "guidParam": id.toString()}),
          headers: {
            "Accept-Language":
                trrrr.LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": token,
          });
      print(response.body);
    } catch (e) {
      flushBar(AppLocalizations.of(context!)!
          .translate('please! check your network connection'));
      print(e);
      chLogIn = false;
    }
  }

  static userLatLangUpdate(lat, lang, id) async {
    try {
      http.Response response =
          await http.post(Uri.parse('$apiDomain/Main/Users/Location_Update?'),
              body: jsonEncode({
                "UserId": id.toString(),
                "lat": lat.toString(),
                "lng": lang.toString(),
              }),
              headers: {
            "Accept-Language":
                trrrr.LocalizationService.getCurrentLocale().languageCode,
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": token,
          });
      print(response.body);
    } catch (e) {
      flushBar(AppLocalizations.of(navigatorKey.currentContext!)!
          .translate('please! check your network connection'));
      print(e);
      chLogIn = false;
    }
  }

  static flushBar(text) {
    Flushbar(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.h2 * 1.5,
      ),
      icon: Icon(
        Icons.error_outline,
        size: AppHeight.h2 * 1.5,
        color: AppColors.white,
      ),
      duration: Duration(seconds: 3),
      shouldIconPulse: false,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      backgroundColor: Colors.grey.withOpacity(0.5),
      barBlur: 20,
      message: text,
      messageSize: AppHeight.h2,
    ).show(navigatorKey.currentContext!);
  }

  uploadOrderWithAttach(
      id, insertDateTime, value3, orderDateTime, token) async {
    var apiUrl = Uri.parse('$apiDomain/Main/Orders/Orders_CreateWithAttachs?');
    var request = http.MultipartRequest("POST", apiUrl);
    var amount = 0.0;
    List<Map<String, dynamic>> serviceTmp = [];
    for (int i = 0; i < order.length; i++) {
      var attach;
      List<Map<String, dynamic>> serviceAttach = [];
      try {
        //attach = await MultipartFile.fromFile(order[i][0][0]['Service']['File'].path.toString(), filename: order[i][0][0]['Service']['File'].name);
        attach = await http.MultipartFile.fromPath(
            "File", order[i][0][0]['Service']['File'].path.toString());
        request.files.add(attach);
        for (int j = 0; j < 1; j++) {
          serviceAttach.add({
            "FilePath": attach.filename,
            "AttNotes": "AttNotes",
            "AttId": "$id",
            "AttFile": {"File": attach}
          });
        }
      } catch (e) {
        attach = null;
      }
      amount += (order[i][0][0]['Price']) * int.parse(order[i][1]);
      serviceTmp.add({
        "ServiceId": order[i][0][0]['Id'],
        "Price": order[i][0][0]['Price'],
        "Quantity": int.parse(order[i][1]),
        "ServiceNotes": order[i][0][1]["Notes"],
        "OrderServiceAttatchs": attach == null ? '' : serviceAttach,
        // ignore: equal_keys_in_map
      });
    }

    FormData formdata = FormData.fromMap({
      "CustomerId": "$id",
      "Amount": amount,
      "InsertDate": insertDateTime,
      "Status": 1,
      "PayType": 1,
      "AddressId": value3,
      "OrderDate": orderDateTime,
      /*"Notes": "string",*/
      "OrderServices": serviceTmp
    });
    print(token);
    //print(formdata.fields);
    //print(formdata.files);

    //create multipart request for POST or PATCH method
    //add text fields
    request.fields.addAll(Map.fromEntries(formdata.fields));
    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
    print(request.files);
    print(request.fields);
    //create multipart using filepath, string or bytes
    //var pic = await http.MultipartFile.fromPath("file_field", file.path);
    //add multipart to request
    //request.files.add(pic);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      try {
        if (jsonDecode(responseString)['Errors'] == null ||
            jsonDecode(responseString)['Errors'] == '') {
          print('success');
          return true;
        } else {
          flushBar(jsonDecode(responseString)['Errors']);
          return false;
        }
      } catch (e) {
        return true;
      }
    } else {
      return false;
      print(response.statusCode);
    }
/*
    try{
      Response response = await dio.post(uploadurl, data: formdata,
          options: Options(method: 'POST',) // or ResponseType.JSON
        /*onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          //update the progress
        });
      },*/);
    }catch(e){
      print(e);
    }
    Response response = await dio.post(uploadurl, data: formdata,
       options: Options(method: 'POST', responseType: ResponseType.json) // or ResponseType.JSON
      /*onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          //update the progress
        });
      },*/);
    print(response.data);
    print(response.statusCode);
    return response;
*/
  }

  uploadOrderWithAttachNew(id, insertDateTime, value3, orderDateTime, token,
      couponId, couponValue) async {
    var apiUrl = Uri.parse('$apiDomain/Main/Orders/Orders_CreateWithAttachs?');
    var request = http.MultipartRequest("POST", apiUrl);
    var amount = 0.0;
    List<Map<String, dynamic>> serviceTmp = [];
    for (int i = 0; i < order.length; i++) {
      var attach;
      List<Map<String, dynamic>> serviceAttach = [];
      try {
        var file = order[i][0][0]['Service']['File'];
        String base64Image = base64Encode(file.readAsBytesSync());
        String fileName = file.path.split("/").last;
        attach = 'ok';
        //attach = await http.MultipartFile.fromPath("File", order[i][0][0]['Service']['File'].path.toString());
        for (int j = 0; j < 1; j++) {
          serviceAttach.add({
            "FilePath": fileName,
            "File": base64Image,
            "AttNotes": "AttNotes",
            "AttId": "$id",
          });
        }
      } catch (e) {
        attach = null;
      }
      amount +=
          (order[i][0][0]['Price']) * int.parse(order[i][1]) - couponValue;
      serviceTmp.add({
        "ServiceId": order[i][0][0]['Id'],
        "Price": order[i][0][0]['Price'],
        "Quantity": int.parse(order[i][1]),
        "ServiceNotes": order[i][0][1]["Notes"],
        "OrderServiceAttatchs": attach == null ? '' : serviceAttach,
        // ignore: equal_keys_in_map
      });
    }
    FormData formdata = FormData.fromMap({
      "CustomerId": "$id",
      "Amount": amount,
      "InsertDate": insertDateTime,
      "Status": 2,
      "PayType": 1,
      "AddressId": value3,
      "OrderDate": orderDateTime,
     // "Notes": "string",
      "CouponId": couponId,
      "OrderServices": serviceTmp,
    });
    print(token);
    //create multipart request for POST or PATCH method
    //add text fields
    request.fields.addAll(Map.fromEntries(formdata.fields));
    request.headers.addAll({
      "Accept-Language":
          trrrr.LocalizationService.getCurrentLocale().languageCode,
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
    print(request.files);
    print(request.fields);
    //create multipart using filepath, string or bytes
    //var pic = await http.MultipartFile.fromPath("file_field", file.path);
    //add multipart to request
    //request.files.add(pic);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      try {
        if (jsonDecode(responseString)['Errors'] == null ||
            jsonDecode(responseString)['Errors'] == '') {
          print('success');
          return true;
        } else {
          flushBar(jsonDecode(responseString)['Errors']);
          return false;
        }
      } catch (e) {
        return true;
      }
    } else {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      flushBar(jsonDecode(responseString)['Errors']);
      return false;
      print(response.statusCode);
    }
  }

  //{CustomerId: 90e73cdd-7e7e-4207-9901-08d9a4f69d2a, Amount: 300.0, InsertDate: 2021-12-08T01:29:45.045Z, Status: 1, PayType: 1, AddressId: 66b576f9-d44b-4565-b9e3-08d9a4f82388, OrderDate: 2021-12-08T13:29:00.000Z, Notes: string, OrderServices: [{ServiceId: 18, Price: 300.0, Quantity: 1, ServiceNotes: , OrderServiceAttatchs: }]}
  //{CustomerId: 90e73cdd-7e7e-4207-9901-08d9a4f69d2a, Amount: 300.0, InsertDate: 2021-12-08T01:31:02.002Z, Status: 1, PayType: 1, AddressId: 66b576f9-d44b-4565-b9e3-08d9a4f82388, OrderDate: 2021-12-08T13:29:00.000Z, Notes: string, OrderServices[0][ServiceId]: 18, OrderServices[0][Price]: 300.0, OrderServices[0][Quantity]: 1, OrderServices[0][ServiceNotes]: , OrderServices[0][OrderServiceAttatchs]: }
  uploadOrderWithoutAttach(
      id, insertDateTime, value3, orderDateTime, token) async {
    var apiUrl = Uri.parse('$apiDomain/Main/Orders/Orders_CreateWithAttachs?');
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    var amount = 0.0;
    List<Map<String, dynamic>> serviceTmp = [];

    for (int i = 0; i < order.length; i++) {
      amount += (order[i][0][0]['Price']) * int.parse(order[i][1]);
      serviceTmp.add({
        "ServiceId": order[i][0][0]['Id'],
        "Price": order[i][0][0]['Price'],
        "Quantity": int.parse(order[i][1]),
       // "Notes": "string",
      });
    }

    Map mapDate = {
      "CustomerId": "$id",
      "Amount": amount,
      "InsertDate": insertDateTime,
      "Status": 1,
      "PayType": 1,
      "AddressId": value3,
      "OrderDate": orderDateTime,
     // "Notes": "string",
      "OrderServices": serviceTmp
    };
    print(jsonEncode(jsonEncode(mapDate)));

    http.Response response = await http
        .post(apiUrl, body: jsonEncode(jsonEncode(mapDate)), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
    print(response.body);
    /* Response response = await dio.post('order',
        data: formdata,
        //options: Options(method: 'POST', responseType: ResponseType.json) // or ResponseType.JSON
      onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          //update the progress
        });
      },)*/
    return response;
  }

  uploadOrderWithAttachment(
      id, insertDateTime, value3, orderDateTime, token) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("$apiDomain/Main/Orders/Orders_CreateWithAttachs?"));
    var amount = 0.0;
    List<Map<String, dynamic>> serviceTmp = [];
    for (int i = 0; i < order.length; i++) {
      var attach = await http.MultipartFile.fromPath(
          'file_field', order[i][0][0]['Service']['File'].path.toString(),
          filename: order[i][0][0]['Service']['File'].name);
      List<Map<String, dynamic>> serviceAttach = [];
      for (int j = 0; j < 1; j++) {
        serviceAttach.add({
          "FilePath": attach.filename,
          "AttNotes": "AttNotes",
          "AttId": "new guid",
          "AttFile": {"File": attach}
        });
      }
      amount += (order[i][0][0]['Price']) * int.parse(order[i][1]);
      serviceTmp.add({
        "ServiceId": order[i][0][0]['Id'],
        "Price": order[i][0][0]['Price'],
        "Quantity": int.parse(order[i][1]),
        //"ServiceNotes": "string",
        "OrderServiceAttatchs": serviceAttach
        //"File": await http.MultipartFile.fromPath('file_field', order[i][0][0]['Service']['File'].path.toString(), filename:order[i][0][0]['Service']['File'].name),
      });
    } //add text fields
    request.fields.addAll({
      "CustomerId": "$id",
      "Amount": amount.toString(),
      "InsertDate": insertDateTime,
      "Status": 1.toString(),
      "PayType": 1.toString(),
      "AddressId": value3,
      "OrderDate": orderDateTime,
      //"GroupId": 1,
     // "Notes": "string",
      //"OrderServices": serviceTmp
    });
    request.fields.keys;
    //create multipart using filepath, string or bytes
    //var pic = await http.MultipartFile.fromPath("file_field", file.path);
    //add multipart to request
    //request.files.add(pic);
    var response = await request.send();
    print(request.fields);
    print(response.statusCode);

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }

  updateOrder(
      token, _order, status, payType, selectedDate, selectedTime) async {
    //update
    // ignore: unnecessary_null_comparison
    if (status == null) status = _order['Status'];
    // ignore: unnecessary_null_comparison
    if (payType == null) payType = _order['PayType'];
    // ignore: unnecessary_null_comparison
    String orderDateTime;
    if (selectedDate == null || selectedTime == null)
      orderDateTime = _order['OrderDate'];
    else {
      orderDateTime = DateTime(selectedDate!.year, selectedDate!.month,
                  selectedDate!.day, selectedTime!.hour, selectedTime!.minute)
              .add(timeDiff)
              .toString()
              .replaceAll(" ", "T") +
          "Z";
    }
    var apiUrl = Uri.parse('$apiDomain/Main/Orders/Orders_Update?');
    var amount = 0.0;
    List<Map<String, dynamic>> serviceTmp = [];
    var k = _order['Servicess'].length;
    for (int i = 0; i < k; i++) {
      serviceTmp.add({
        "Id": _order["Servicess"][i]['Id'],
        "OrderId": _order["Servicess"][i]['OrderId'],
        "ServiceId": _order["Servicess"][i]['ServiceId'],
        "Price": _order["Servicess"][i]['Price'],
        "Quantity": _order["Servicess"][i]['Quantity'],
        "Notes": _order["Servicess"][i]['Notes'],
      });
    }
    Map mapDate = {
      "Id": _order['Id'],
      "CustomerId": _order['CustomerId'],
      "Amount": _order['Amount'],
      "InsertDate": _order['InsertDate'],
      "Status": status,
      "PayType": payType,
      "AddressId": _order["AddressId"],
      "OrderDate": orderDateTime,
      "GroupId": _order["GroupId"],
      "Notes": _order["Notes"],
      "OrderServices": serviceTmp
    };
    print(jsonEncode(mapDate));
    print(token);
    http.Response response =
        await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept-Language":
          trrrr.LocalizationService.getCurrentLocale().languageCode,
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });

    if (response.statusCode == 200) {
      print(response.body);
      print('success');
      try {
        if (jsonDecode(response.body)['Errors'] == null ||
            jsonDecode(response.body)['Errors'] == '') {
          if (status == 8) {
            _sendPushMessage(_order['User']['FBKey'],
                'order' + _order['Serial'], 'your order is finished');
          }
          print('success');
          return true;
        } else {
          flushBar(jsonDecode(response.body)['Errors']);
          return false;
        }
      } catch (e) {
        return true;
      }
    } else {
      print(response.body);
      print(response.statusCode);
      return false;
    }
  }

  static rateOrder({orderId, rateNote, rateScore}) async {
    print("tttttttttttttt:   " + token);
    var apiUrl = Uri.parse("$apiDomain/Main/Orders/Orders_Rate?");
    Map mapDate = {
      "OrderId": orderId,
      "RateNote": rateNote,
      "RateScore": rateScore.round(),
    };
    http.Response response =
        await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
    print((response));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['Errors'] == null ||
          jsonDecode(response.body)['Errors'] == '') {
        print('success');
        return true;
      } else {
        flushBar('Fail!\n' + jsonDecode(response.body)['Errors']);
        return false;
      }
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1,),),);
    } else {
      print(response.statusCode);
      print('fail');
      return false;
    }
  }

  destroyOrder(
    id,
  ) async {
    var apiUrl = Uri.parse("$apiDomain/Main/Orders/Orders_Destroy?");
    Map mapDate = {
      "guidParam": id,
    };
    http.Response response =
        await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token,
    });
    print((response));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['Errors'] == null ||
          jsonDecode(response.body)['Errors'] == '') {
        print('success');
        return true;
      } else {
        flushBar('Fail!\n' + jsonDecode(response.body)['Errors']);
        return false;
      }
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1,),),);
    } else {
      print(response.statusCode);
      print('fail');
      return false;
    }
  }

  logOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('token', "");
    sharedPreferences.setString('password', "");
    sharedPreferences.setString('facebookEmail', "");
    sharedPreferences.setString('googleEmail', "");
    sharedPreferences.setBool('worker', false);

    //sharedPreferences.setString('email', "");
    Navigator.of(context!).pushReplacement(
      MaterialPageRoute(
        builder: (context) => new LoadingScreen(email: ""),
      ),
    );
    order.clear();
    editTransactionOrder(transactions![0], order);

    // Navigator.of(context).pushNamed('main_screen');
  }

  createWorkerTask(orderId, workerId, serviceId, supervisorNotes, startDate,
      endDate, workerNotes, token, workerFcmToken, taskName) async {
    var apiUrl = Uri.parse('$apiDomain/Main/WorkerTask/WorkerTask_Create?');
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    Map mapDate = {
      //"Id": orderId.toString(), //orderId
      "WorkerId": workerId.toString(),
      "OrderServicesId": serviceId.toString(), //serviceId
      "Status": 0,
      "Notes": supervisorNotes.toString(), //supervisorNotes
      "StartDate": startDate,
      "Name": taskName,
      //"EndDate": endDate,
      "ResDesc": workerNotes.toString() // workerNotes
    };

    print(jsonEncode(mapDate));

    http.Response response =
        await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept-Language":
          trrrr.LocalizationService.getCurrentLocale().languageCode,
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token, //b53d0e9a-fd32-4798-a600-59e1a9a4fc7f
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Get the response from the server
      var responseString = response.body;
      print(responseString);
      try {
        if (jsonDecode(responseString)['Errors'] == null ||
            jsonDecode(responseString)['Errors'] == '') {
          print('success');
          _sendPushMessage(workerFcmToken, taskName,
              AppLocalizations.of(context!)!.translate('You Have New Task!'));
          return true;
        } else {
          flushBar(jsonDecode(responseString)['Errors']);
          return false;
        }
      } catch (e) {
        _sendPushMessage(workerFcmToken, taskName,
            AppLocalizations.of(context!)!.translate('You Have New Task!'));
        return true;
      }
    } else {
      flushBar(jsonDecode(response.body)['Errors']);
      return false;
      print(response.statusCode);
    }
    //return response;
  }

  updateWorkerTask(taskId, workerId, serviceId, supervisorNotes, startDate,
      endDate, workerNotes, token, taskName, file, fcmToken, _mainOrderId,
      {message, status}) async {
    status ??= 2;
    message ??=
        AppLocalizations.of(context!)!.translate('good luck task is finished');
    var apiUrl = Uri.parse('$apiDomain/Main/WorkerTask/WorkerTask_Update?');
    List<Map<String, dynamic>> serviceTmp = [];
    var attach;
    List<Map<String, dynamic>> serviceAttach = [];
    String base64Image = '', filePath = '';
    try {
      base64Image = base64Encode(file.readAsBytesSync());
      filePath = file.path.split("/").last;
      attach = 'ok';
    } catch (e) {
      attach = null;
    }

    Map mapDate = {
      "Id": taskId.toString(), //orderId
      "WorkerId": workerId.toString(),
      "OrderId": _mainOrderId,
      "OrderServicesId": serviceId.toString(), //serviceId
      "Status": status,
      "Notes": supervisorNotes.toString(), //supervisorNotes
      "StartDate": startDate,
      "Name": taskName,
      "EndDate": endDate,
      "ResDesc": workerNotes.toString(), // workerNotes
      "WorkerTaskAttatchs": attach == null
          ? ''
          : [
              {
                "WorkerTaskId": taskId.toString(),
                "FilePath": filePath,
                "FileDase64": base64Image,
                "Notes": "nnnnn"
              }
            ]
    };

    if (attach == null)
      mapDate = {
        "Id": taskId.toString(), //orderId
        "WorkerId": workerId.toString(),
        "OrderId": _mainOrderId,
        "OrderServicesId": serviceId.toString(), //serviceId
        "Status": status,
        "Notes": supervisorNotes.toString(), //supervisorNotes
        "StartDate": startDate,
        "Name": taskName,
        "EndDate": endDate,
        "ResDesc": workerNotes.toString() // workerNotes
      };

    print(jsonEncode(mapDate));

    http.Response response =
        await http.post(apiUrl, body: jsonEncode(mapDate), headers: {
      "Accept-Language":
          trrrr.LocalizationService.getCurrentLocale().languageCode,
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": token, //b53d0e9a-fd32-4798-a600-59e1a9a4fc7f
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Get the response from the server
      var responseString = response.body;
      //print(responseString);
      try {
        if (jsonDecode(responseString)['Errors'] == null ||
            jsonDecode(responseString)['Errors'] == '') {
          print('success');
          _sendPushMessage(
              fcmToken,
              taskName,
              message ??
                  ''); //AppLocalizations.of(context!)!.translate('good luck task is finished'));
          return true;
        } else {
          flushBar(jsonDecode(responseString)['Errors']);
          return false;
        }
      } catch (e) {
        _sendPushMessage(
            fcmToken,
            taskName,
            message ??
                ''); //AppLocalizations.of(context!)!.translate('good luck task is finished'));
        return true;
      }
    } else {
      flushBar(jsonDecode(response.body)['Errors']);
      return false;
      print(response.statusCode);
    }
    //return response;
  }

  getGroupUsers(var id) async {
    try {
      var url = Uri.parse(
          "$apiDomain/Main/GroupUsers/GroupUsers_Read?filter=GroupId~eq~$id");
      http.Response response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var item = json.decode(response.body)['Data'];
        print(item);
        /*for(int i = 0; i<item.length; i++){
          if(item[i]['UserId'] == id){
            groupId = item[i]['GroupId'];
            i=item.length;
          }
        }
        await item.removeWhere((itm) => itm['GroupId'] != groupId);*/
        groupUsers = item;
      } else {
        print(token);
        print(response.statusCode);
      }
    } catch (e) {
      // Workers = transactions![0].Address;
    }
  }

  Future<void> _sendPushMessage(_token, _taskName, _taskBody) async {
    String constructFCMPayload(String? token, _title, _body) {
      return jsonEncode({
        'to': token,
        'data': {
          //'to': token,
          //"registration_ids" : token,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'COMMENT',
          'via': 'FlutterFire Cloud Messaging!!!',
          //'count': _messageCount.toString(),
        },
        'notification': {
          'title': _title,
          'body': _body,
        },
      });
    }

    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      var _serverKey =
          'AAAA8RmDhKM:APA91bHT6bLM03mWt5dwZy0FoQMW1rTmaEtof0VBCjQO7frhX16DFXWxp3Xyzew-p1j8rhBbXmXwm75VnTX11_pJEle8KW-bBXatTLcGte9LfUJ12MbioDoKlQxAiY6yTSWxcNLpdRhR';
      //var _serverKey = 'AAAAOPv0WzU:APA91bHwvAAe8VSqm2XDxAIQaKw1GSepD65_sIaX0FgUuI34ekkGiYvA-Mt3Bh3lc5jM5KQyi3DD2oWmRhJYGDtCPFYSM1mCkvsaFnPjQ2gylYDvU3lGXTrUG4i4ssYBRgB_vCNInn2P';
      //var _serverKey = 'AAAAOPv0WzU:APA91bH_4SPyvOt7K3n2rGhl1v6DgCAogSL5hO6hiSkqQNV6Yqh77kNlGOc-AUwBgp4Avig-6xQp5vXiyJxPBEyg1SEqKSyXX5HbQJ8qG2cNNn0XHwGxVtOx31fK0OBK6xR_fjoF9ntn';
      //var _serverKey = 'AIzaSyD-b9apuimKiEov1Ah0Aom_mg6wwEv5KWs';
      var response = await http.post(
        //Uri.parse('https://api.rnfirebase.io/messaging/send'),
        //Uri.parse('https://fcm.googleapis.com/v1/projects/mr-services-15410/messages:send'),
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$_serverKey',
          'project_id': '1035515167907',
        },
        body: constructFCMPayload(_token, _taskBody, _taskName),
      );
      print('FCM request for device sent!');
      print(jsonEncode(response.body));
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  showImage(src) {
    Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => PhotoViewer(image: src),));
  }
}
