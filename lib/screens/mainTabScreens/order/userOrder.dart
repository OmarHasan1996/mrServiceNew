import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:closer/MyWidget.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/localizations.dart';
import 'package:closer/map/orderTrackingPage.dart';
import 'package:closer/screens/Payment.dart';
import 'package:closer/screens/order/checkout.dart';
import 'package:closer/screens/order/orderRecipt.dart';
import 'package:date_format/date_format.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../signin.dart';

class UserOrder extends StatefulWidget {
  UserOrder({Key? key, required this.initialOrderTab}) : super(key: key);
  int initialOrderTab = 0;

  @override
  State<UserOrder> createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      snackBar: SnackBar(
        content: Text(
            AppLocalizations.of(context)!.translate('Tap back again to leave')),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyWidget.topYellowDriver(),
          SizedBox(
            height: AppHeight.h1/3,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  //vertical: MediaQuery.of(context).size.width / 22,
                  horizontal: MediaQuery.of(context).size.width / 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DefaultTabController(
                    length: 3, // length of tabs
                    initialIndex: widget.initialOrderTab,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(MediaQuery.of(context).size.height / 51),
                          topRight: Radius.circular(MediaQuery.of(context).size.height / 51),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.WhiteSelver,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(MediaQuery.of(context).size.height / 51),
                                topRight: Radius.circular(MediaQuery.of(context).size.height / 51),
                              ),
                            ),
                            child: TabBar(
                              indicatorColor: Colors.transparent,
                              labelColor: AppColors.yellow,
                              unselectedLabelColor: Colors.grey,
                              indicator: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              tabs: [
                                _tap(AppLocalizations.of(context)!
                                    .translate('NewOrders')),
                                _tap(AppLocalizations.of(context)!
                                    .translate('CurrentOrders')),
                                _tap(AppLocalizations.of(context)!
                                    .translate('FinishedOrders')),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: AppHeight.h50*1.05, //height of TabBarView
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                ////////// Tab1
                                Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: order.length,
                                        itemBuilder: (context, index) {
                                          //totalPrice =0;s
                                          return GestureDetector(
                                            onTap: () {},
                                            child: MyWidget(context)
                                                .orderlist(order[index], 1,
                                                    () => _setState()),
                                          );
                                        },
                                        addAutomaticKeepAlives: false,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
                                      child: Column(
                                        children: [
                                          MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('TOTAL')),
                                          MyWidget(context).textTitle15("${AppLocalizations.of(context)!.translate('TRY')} ${sumPrice().toStringAsFixed(3)}", color: Colors.blue),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: AppHeight.h1/2,),
                                            child: MyWidget(context)
                                                .raisedButton(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            'Finished Order'),
                                                    () => _finishOrder(),
                                                    AppWidth.w60,
                                                    false, height: AppHeight.h4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ////////// Tab2
                                Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: FutureBuilder(
                                          future: _getMyOrders(
                                              userData!.content!.id),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snap) {
                                            if (snap.connectionState ==
                                                ConnectionState.waiting) {
                                              _loading = true;
                                              return MyWidget.jumbingDotes(
                                                  _loading);
                                            } else {
                                              _loading = false;
                                              return ListView.builder(
                                                itemCount: _orderData != null
                                                    ? _orderData.length
                                                    : 0,
                                                itemBuilder:
                                                    (context, index) {
                                                  //totalPrice =0;
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _showOrderDetails(
                                                          _orderData[index],
                                                          index + 1);
                                                    },
                                                    child:
                                                        MyWidget.myOrderlist(
                                                            _orderData[index],
                                                            index + 1,
                                                            () => _setState(),
                                                            chCircle),
                                                  );
                                                },
                                                addAutomaticKeepAlives: false,
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                ////////// Tab3
                                Column(
                                  children: [
                                    Expanded(
                                      child: FutureBuilder(
                                        future: _getMyOrders(
                                            userData!.content!.id),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snap) {
                                          if (snap.connectionState ==
                                              ConnectionState.waiting) {
                                            _loading = true;
                                            return MyWidget.jumbingDotes(
                                                _loading);
                                            return SizedBox();
                                          } else {
                                            //return SizedBox();
                                            _loading = false;
                                            return ListView.builder(
                                              itemCount:
                                                  _finishedOrderData.length,
                                              itemBuilder: (context, index) {
                                                //totalPrice =0;
                                                return GestureDetector(
                                                  onTap: () {
                                                    //_showOrderDetails(_finishedOrderData[index], index + 1);
                                                       MyApplication.navigateTo(context, OrderRecipt(order: _finishedOrderData[index],));
                                                  },
                                                  child: MyWidget.myOrderlist(
                                                      _finishedOrderData[
                                                          index],
                                                      index + 1,
                                                      () => _setState(),
                                                      chCircle),
                                                );
                                              },
                                              addAutomaticKeepAlives: false,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppHeight.h1/2,),
                  MyWidget.loadBannerAdd(),
                ],
              ),
            ),
          ),
          MyWidget.bottomYellowDriver(),
        ],
      ),
    );
  }

  List _orderData = [];
  List _finishedOrderData = [];
  bool chCircle = false;
  bool _loading = true;
  Future _getMyOrders(id) async {
    await APIService.getMyOrders(id);
    if (myOrders.isNotEmpty) {
      var k = myOrders['Total'];
      _orderData.clear();
      for (int i = 0; i < k; i++) {
        _orderData.add(myOrders['Data'][i]);
      }
      _orderData.sort((a, b) {
        var adate =
            a['OrderDate' /*'InsertDate'*/]; //before -> var adate = a.expiry;
        var bdate =
            b['OrderDate' /*'InsertDate'*/]; //before -> var bdate = b.expiry;
        return bdate.compareTo(adate);
      });
      _finishedOrderData.clear();
      //finishedOrderData.add(orderData[0]);
      for (int i = 0; i < _orderData.length; i++) {
        if (_orderData[i]['Status'] == 8) {
          _finishedOrderData.add(_orderData[i]);
          _orderData.removeAt(i);
          i--;
        }
      }
    } else {
      _orderData.clear();
    }
  }

  double sumPrice() {
    double price = 0.0;
    for (int i = 0; i < order.length; i++) {
      price = price + order[i][0][0]["Price"] * int.parse(order[i][1]);
      print(price);
    }
    return price;
  }

  _tap(String text) {
    return Tab(
      height: FontSize.s16 * 3.5,
      child: Center(
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {});
          },
          child: MyWidget(context).textTap25(text),
        ),
      ),
    );
  }

  _finishOrder() async {
    setState(() {
      adr.clear();
    });
    setState(() {
      APIService.getAddress(userData!.content!.id);
    });
    await Future.delayed(Duration(seconds: 1));
    if (order.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new CheckOutScreen(
          token: token,
          service: service,
        ),
      ));
    }
  }

  _setState() {
    setState(() {});
  }

  ImageProvider? image = null;
  String? path;
  XFile? xFile;

  _openTrackingPage(orderServiceId, LatLng address) {
  //  APIService.checkLocation(orderServiceId);
    MyApplication.navigateTo(
        context,
        OrderTrackingPage(
          orderServiceId: orderServiceId, distination: address,
        ));
  }

  _showOrderDetails(ord, index, {bool? dateIsSelected}) {
    dateIsSelected ??= false;
    var Id;
    Id = ord['Servicess'][0]['OrderId'];
    var serial;
    serial = ord['Serial'];
    var amount;
    amount = ord['Amount'].toString();
    var date;
    var time;
    try {
      ord['OrderDate'] = DateTime.parse(ord['OrderDate'].replaceAll('T', ' '))
          .add(-timeDiff)
          .toString();
      date = ord['OrderDate'].split(" ")[0];
      time = ord['OrderDate'].split(" ")[1];
      ord['OrderDate'] = DateTime.parse(ord['OrderDate'].replaceAll('T', ' '))
          .add(timeDiff)
          .toString();
    } catch (e) {
      ord['OrderDate'] = DateTime.parse(ord['OrderDate'].replaceAll('T', ' '))
          .add(-timeDiff)
          .toString();
      date = ord['OrderDate'].split(" ")[0];
      time = ord['OrderDate'].split(" ")[1];
      ord['OrderDate'] = DateTime.parse(ord['OrderDate'].replaceAll('T', ' '))
          .add(timeDiff)
          .toString();
    }
    //selectedTime = TimeOfDay.now();
    if (!dateIsSelected) {
      selectedTime = TimeOfDay(
          hour: int.parse(time.split(':')[0]),
          minute: int.parse(time.split(':')[1]));
      selectedDate = DateTime.parse(date + " " + time);
      _dateController.text = date;
      _timeController.text = time;
    }
    var addressArea;
    addressArea = ord['Address']['Title'] ?? '';
    var addressNotes;
    addressNotes = ord['Address']['notes'];
    var addressBuilding;
    addressBuilding = ord['Address']['building'];
    var addressFloor;
    addressFloor = ord['Address']['floor'];
    var addressAppartment;
    addressAppartment = ord['Address']['appartment'];
    var statusCode = ord['Status'].toString();
    bool change = false;
    if (statusCode == "3") change = true;
    List service = [];
    service = ord['Servicess'];
    var userName;
    userName = ord['User']['Name'];
    var userLastName;
    userLastName = ord['User']['LastName'];
    var userMobile;
    userMobile = ord['User']['Mobile'];
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 80,
            horizontal: MediaQuery.of(context).size.width / 50,
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('Order Id: ') +
                          serial.toString(),
                      style: TextStyle(
        fontFamily: 'comfortaa',
                        color: AppColors.black,
                        fontSize: MediaQuery.of(context).size.width / 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 160,
                ),
                MyWidget.card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyWidget.textHeader(
                          AppLocalizations.of(context)!.translate("User Name")),
                      MyWidget.text(userName + " " + userLastName),
                    ],
                  ),
                ),
                MyWidget.card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyWidget.textHeader(
                          AppLocalizations.of(context)!.translate("Address")),
                      MyWidget.text(addressArea +
                          " / " +
                          addressNotes +
                          " / " +
                          addressBuilding +
                          " / " +
                          addressFloor +
                          " / " +
                          addressAppartment),
                    ],
                  ),
                ),
                MyWidget.card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyWidget.textHeader(AppLocalizations.of(context)!
                          .translate("Phone Number")),
                      MyWidget.text(userMobile),
                    ],
                  ),
                ),
                _dateCard(change),
                _timeCard(change),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                MyWidget.textHeader(
                    AppLocalizations.of(context)!.translate('Services')),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                  child: ListView.builder(
                    itemCount: service.length,
                    itemBuilder: (context, index) {
                      return MyWidget.card(
                        GestureDetector(
                          onTap: ()=> ord['Status']==7 || ord['Status']==6?
                          _openTrackingPage(service[index]['Id'], LatLng(ord['Address']['lat'], ord['Address']['lng']))
                              :null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: MyWidget.text(service[index]['Service']['Name'])),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 30,
                              ),
                              MyWidget.textHeader(prettify(double.parse(amount)).toString() + AppLocalizations.of(context)!.translate('TRY')/*service[index]['price']*/),

                              ord['Status']==7? Icon(Icons.location_on_outlined, color: AppColors.mainColor,):SizedBox()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                        change
                            ? AppLocalizations.of(context)!.translate('Save')
                            : AppLocalizations.of(context)!.translate('Ok'),
                        () => _save(ord, change, index),
                        MediaQuery.of(context).size.width / 1.7),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _button(text, click(), width) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 100,
      ),
      child: Container(
        width: width,
        // ignore: deprecated_member_use
        child: MyWidget(context)
            .raisedButton(text, () => click(), width, chCircle),
      ),
    );
  }

  _save(ord, bool change, index) async {
    //change = true;
    if (!change) {
      Navigator.pop(context);
      return;
    }
    var date = ord['OrderDate'].split(" ")[0];
    var time = ord['OrderDate'].split(" ")[1];
    if (selectedDate == DateTime.parse(date + " " + time) &&
        selectedTime ==
            TimeOfDay(
                hour: int.parse(time.split(':')[0]),
                minute: int.parse(time.split(':')[1]))) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      chCircle = true;
    });
    Navigator.pop(context);
    _showOrderDetails(ord, index, dateIsSelected: true);
    bool _suc = await APIService(context: context)
        .updateOrder(token, ord, 4, null, selectedDate, selectedTime);
    if (_suc) {
      Navigator.pop(context);
      APIService.flushBar(
          AppLocalizations.of(context)!.translate('Order Saved'));
      new Timer(Duration(seconds: 2), () => setState(() {}));
    }
    setState(() {
      chCircle = false;
    });
  }

  TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate as DateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        print("this is the Date");
        print(selectedDate);
        print("timeZone");
        print(DateTime.now().timeZoneName);
        print(DateTime.now().timeZoneOffset);
        _dateController.text =
            DateFormat.yMd().format(selectedDate as DateTime);
      });
    }
  }

  TimeOfDay? selectedTime;
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime as TimeOfDay,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        print("this is the Time");
        print(selectedTime!.hour);
        var _hour = selectedTime!.hour.toString();
        var _minute = selectedTime!.minute.toString();
        var _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime!.hour, selectedTime!.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  _dateCard(bool change) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 160,
        horizontal: MediaQuery.of(context).size.width / 40,
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: change ? AppColors.blue : Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.height / 80)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 40,
          vertical: MediaQuery.of(context).size.height / 60 * 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.date_range,
              color: change ? AppColors.blue : AppColors.black,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (change) _selectDate(context);
                },
                child: TextFormField(
                  style: TextStyle(
        fontFamily: 'comfortaa',
                      fontSize: min(MediaQuery.of(context).size.width / 20,
                          MediaQuery.of(context).size.height / 45),
                      color: change ? AppColors.blue : AppColors.black),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _dateController,
                  onSaved: (String? val) {
                    _setDate = val;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _setTime, _setDate;

  _timeCard(bool change) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 160,
        horizontal: MediaQuery.of(context).size.width / 40,
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: change ? AppColors.blue : Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.height / 80)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 40,
          vertical: MediaQuery.of(context).size.height / 60 * 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.timer_outlined,
                color: change ? AppColors.blue : AppColors.black),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (change) _selectTime(context);
                },
                child: TextFormField(
                  style: TextStyle(
        fontFamily: 'comfortaa',
                      fontSize: min(MediaQuery.of(context).size.width / 20,
                          MediaQuery.of(context).size.height / 45),
                      color: change ? AppColors.blue : AppColors.black),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _timeController,
                  onSaved: (String? val) {
                    _setTime = val;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
