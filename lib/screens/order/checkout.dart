import 'dart:convert';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/helper/adHelper.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/localizations.dart';
import '../../MyWidget.dart';
import '../service/sub_service_dec.dart';
import '../../const.dart';
import '../main_screen.dart';
import '../address/manege_address.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  TimeOfDay add(Duration time) {
    return this.replacing(
        hour: this.hour + time.inHours,
        minute: this.minute + time.inMinutes.remainder(60));
  }
}

// ignore: must_be_immutable
class CheckOutScreen extends StatefulWidget {
  String token;
  List service = [];

  CheckOutScreen({
    required this.token,
    required this.service,
  });

  @override
  _CheckOutScreenState createState() =>
      _CheckOutScreenState(this.token, this.service);
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String? lng;
  String token;
  List service = [];
  String? value3;
  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;

  TimeOfDay? selectedTime = TimeOfDay.now();
  double? _height;
  double? _width;
  TextEditingController _couponConroller = TextEditingController();
  _CheckOutScreenState(this.token, this.service);

  DateTime? selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate as DateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
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

  TextEditingController _timeController = TextEditingController();
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime as TimeOfDay,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        print("this is the Time");
        print(selectedTime!.hour);
        _hour = selectedTime!.hour.toString();
        _minute = selectedTime!.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime!.hour, selectedTime!.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  bool _getCoupons = false;
  TimeOfDay? _maxStartTime, _minEndTime;

  TimeOfDay _stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    String time = " AM";
    if(tod.contains('12:')) time = " PM";
    return TimeOfDay.fromDateTime(format.parse(tod + time));
  }

  @override
  void initState() {
    // TODO: implement initState
    //_dateController.text = DateFormat.yMd().format(DateTime.now());

    //_timeController.text = formatDate(DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [hh, ':', nn, " ", am]).toString();
    super.initState();
    AdHelper.loadInterstitialAd(() => null);

    for (var o in order) {
      try {
        _maxStartTime ??= _stringToTimeOfDay(o[0][0]['StartServeDate']);
        _minEndTime ??= _stringToTimeOfDay(o[0][0]['EndServeDate']);
      } catch (e) {}
      try {
        if (_stringToTimeOfDay(o[0][0]['StartServeDate'])
                .compareTo(_maxStartTime!) >
            0) {
          _maxStartTime ??= _stringToTimeOfDay(
              o[0][0]['StartServeDate'] /*.replaceAll('T', ' ')*/);
        }
      } catch (e) {}
      try {
        if (_stringToTimeOfDay(o[0][0]['EndServeDate'])
                .compareTo(_minEndTime!) <
            0) {
          _minEndTime ??= _stringToTimeOfDay(
              o[0][0]['EndServeDate'] /*.replaceAll('T', ' ')*/);
        }
      } catch (e) {}
    }
    // print(subservice);
  }

  late var context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    apiService = APIService(context: context);
    var barHight = MediaQuery.of(context).size.height / 5.5;
    //getServiceData();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return SafeArea(
      child: Scaffold(
        appBar: MyWidget.appBar(
            title: AppLocalizations.of(context)!.translate('Checkout'),
            isMain: false,
            withoutCart: true),
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            MyWidget.topYellowDriver(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 300,
            ),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 80,
                    horizontal: AppWidth.w4,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 200,
                              horizontal:
                                  MediaQuery.of(context).size.width / 150),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height /
                                      80 *
                                      0,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 80,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: AppWidth.w1_5,
                                      ),
                                      SingleChildScrollView(
                                        child: MyWidget(context).textGrayk28(
                                          AppLocalizations.of(context)!.translate('Please Confirm The Following Details Of Your Order'),
                                          scale: 0.9,
                                          color: AppColors.black),
                                          scrollDirection: Axis.horizontal
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 80,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                80,
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                80),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        20,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    80),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MyWidget(context).textBlack20(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .translate("Address")),
                                                MyWidget(context).raisedButton(
                                                    AppLocalizations.of(
                                                                context)!
                                                            .translate('add') +
                                                        " " +
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'Address'),
                                                    () => {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      new MagageAddressScreen(
                                                                          token:
                                                                              token))).then((value) => setState(() async{
                                                            await getAddress(userData!.content!.id);

                                                          })),
                                                        },
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3,
                                                    false,
                                                    padV: 0.0,
                                                    textH:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            35),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        40,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    160),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                              vertical: AppHeight.h1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          40)),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                value: value3,
                                                iconSize: 0.0,
                                                hint: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.pin_drop_outlined,
                                                      color: Colors.grey,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "City/Town/Near By Near By something",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'comfortaa',
                                                          fontSize: min(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  30,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  69),
                                                        ),
                                                      ),
                                                    ),
                                                    const Icon(Icons
                                                        .arrow_drop_down_outlined),
                                                  ],
                                                ),
                                                items:
                                                    Address.map(buildMenuItem)
                                                        .toList(),
                                                onChanged: (value3) =>
                                                    setState(() {
                                                  this.value3 = value3;
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ///////////////////////////////////////////////////////////////////
                              ///////////////////////////////////////////////////////////////////
                              ///////////////////////////////////////////////////////////////////
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height /
                                      80 *
                                      0,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                80,
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                1000),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            20,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            100),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    MyWidget(context).textBlack20(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    "Date") +
                                                            '   '),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  20,
                                                          //  vertical: MediaQuery.of(context).size.height / 160,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          50)),
                                                        ),
                                                        child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () {
                                                                _selectDate(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    TextFormField(
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'comfortaa',
                                                                      fontSize: min(
                                                                          MediaQuery.of(context).size.height /
                                                                              45,
                                                                          MediaQuery.of(context).size.width /
                                                                              20)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  enabled:
                                                                      false,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  controller:
                                                                      _dateController,
                                                                  onSaved:
                                                                      (String?
                                                                          val) {
                                                                    _setDate =
                                                                        val;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                                                      // labelText: 'Time',
                                                                      hintText: AppLocalizations.of(context)!.translate('press'),
                                                                      contentPadding: const EdgeInsets.only(top: 0.0)),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            20,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            100),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    MyWidget(context).textBlack20(
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    "Time") +
                                                            '   '),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  20,
                                                          //  vertical: MediaQuery.of(context).size.height / 160,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          50)),
                                                        ),
                                                        child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () {
                                                                _selectTime(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    TextFormField(
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'comfortaa',
                                                                      fontSize: min(
                                                                          MediaQuery.of(context).size.height /
                                                                              45,
                                                                          MediaQuery.of(context).size.width /
                                                                              20)),
                                                                  enabled:
                                                                      false,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  controller:
                                                                      _timeController,
                                                                  onSaved:
                                                                      (String?
                                                                          val) {
                                                                    _setTime =
                                                                        val;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                                                      // labelText: 'Time',
                                                                      hintText: AppLocalizations.of(context)!.translate('press'),
                                                                      contentPadding: const EdgeInsets.all(5)),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ///////////////////////////////////////////////////////////////////
                              ///////////////////////////////////////////////////////////////////
                              ///////////////////////////////////////////////////////////////////
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 80,
                              horizontal: AppWidth.w1),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 80,
                              vertical:
                                  MediaQuery.of(context).size.height / 80),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/images/coupons.svg',
                                height: AppHeight.h6,
                              ),
                              SizedBox(
                                width: AppWidth.w50,
                                child: TextFormField(
                                  controller: _couponConroller,
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .translate('Coupon')),
                                  style: TextStyle(
                                    fontFamily: 'comfortaa',
                                  ),
                                ),
                              ),
                              MyWidget(context).raisedButton(
                                  AppLocalizations.of(context)!
                                      .translate('Apply'),
                                  () => _applyCoupon(),
                                  AppWidth.w20,
                                  _getCoupons,
                                  padV: 0.0,
                                  textH:
                                      MediaQuery.of(context).size.width / 35),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 180,
                            ),
                            child: MyWidget(context).textBlack20(
                                AppLocalizations.of(context)!
                                    .translate('Provider and Service'))),
                        Container(
                          height: FontSize.s16 * 3.5 * order.length,
                          child: ListView.builder(
                            itemCount: order.length,
                            itemBuilder: (context, index) {
                              return _orderlist(order[index], index);
                            },
                            addAutomaticKeepAlives: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: AppWidth.w8),
              child: Column(
                children: [
                  SizedBox(height: AppHeight.h1/2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('TOTAL'), color: Colors.grey, scale: 0.45),
                      SizedBox(width: AppWidth.w4,),
                      MyWidget(context).textTap25(
                          prettify(sumPrice(withoutdiscount: true)) + AppLocalizations.of(context)!.translate('TRY'),
                          color: _couponValue > 0? AppColors.black: AppColors.mainColor,
                          lineTrought: _couponValue > 0?true:false)
                    ],
                  ),
                  _couponValue > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyWidget(context).textHead10(
                                AppLocalizations.of(context)!.translate('TOTAL after discount'),
                                color: Colors.grey, scale: 0.45),
                            SizedBox(
                              width: AppWidth.w4,
                            ),
                            MyWidget(context).textTitle15(
                                prettify(sumPrice()) +
                                    AppLocalizations.of(context)!
                                        .translate('TRY'),
                                color: AppColors.mainColor)
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: AppHeight.h1/2,),
                ],
              ),
            ),
            MyWidget(context).raisedButton(
                AppLocalizations.of(context)!.translate('Confirm'),
                () async => sendOrder(userData!.content!.id),
                MediaQuery.of(context).size.width / 1.2,
                _sendingOrder,
                height: AppHeight.h4),
            SizedBox(
              height: AppHeight.h1,
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(dynamic item) {
    getAddress(userData!.content!.id);
    //var area = item['Area']['Name'];
    //var city = item['Area']['City']['Name'];
    ////var country = item['Area']['City']['Country']['Name'];
    //var building = item['building'];
    //var floor = item['floor'];
    //var appartment = item['appartment'];
    var tmp = {
      'Address': item['Title'], //"$city/$area/$building/$floor/$appartment",
      'AddressId': item['Id']
    };
    return DropdownMenuItem(
      value: item['Id'],
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.pin_drop_outlined),
              Flexible(
                child: Text(
                  tmp['Address'] ?? '',
                  style: const TextStyle(
                    fontFamily: 'comfortaa',
                    color: AppColors.black,
                  ),
                ),
              ),
              //Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Padding _orderlist(ord, index) {
    var name = ord[0][0]['Name'];
    String? startTime, endTime;
    bool outOfTime = false;
    try {
      startTime =
          ord[0][0]['StartServeDate'] /*.replaceAll('T', ' ')*/ .toString();
      endTime = ord[0][0]['EndServeDate'] /*.replaceAll('T', ' ')*/ .toString();
      if (selectedTime != null) {
        if (selectedTime!.compareTo(_stringToTimeOfDay(startTime)) < 0)
          outOfTime = true;
        if (selectedTime!.compareTo(_stringToTimeOfDay(endTime)) > 0)
          outOfTime = true;
      }
    } catch (e) {
      print('AAAA');
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 160,
      ),
      child: Container(
        child: MyWidget(context).textBlack20(
            '${index + 1}' + '- ' + '$name [$startTime - $endTime]',
            color: !outOfTime ? Colors.grey[600] : AppColors.red,
            bold: false,
            scale: 0.9),
      ),
    );
  }

  double sumPrice({withoutdiscount}) {
    withoutdiscount??=false;
    double price = 0.0;
    for (int i = 0; i < order.length; i++) {
      price = price + order[i][0][0]["Price"] * int.parse(order[i][1]);
    }
    var discount = (_couponType != 2 ? _couponValue : _couponValue * price / 100);
    if(withoutdiscount) return price;
    else return price - discount;
  }

  void getMyOrders(var id) async {
    var url = Uri.parse(
        "$apiDomain/Main/Orders/Orders_Read?filter=CustomerId~eq~'$id'");
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      print("getOrderders success");
      myOrders = jsonDecode(response.body);
      editTransactionMyOrders(transactions![0], myOrders);
      print(myOrders);
      print("****************************");
      print(jsonDecode(response.body));
    }
  }

  Future getAddress(var id) async {
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
  }

  bool _sendingOrder = false;

  _refreshSendOrder(value) {
    setState(() {
      _sendingOrder = value;
    });
  }

  void sendOrder(id) async {
    _refreshSendOrder(true);
    if (this.value3 == null) {
      _flushBar(
          AppLocalizations.of(context)!.translate('First! Add your address'));
      _refreshSendOrder(false);
      return;
    }
    if (_dateController.text == '' || _timeController.text == '') {
      _flushBar(
          AppLocalizations.of(context)!.translate('First! Add Time and Date'));
      _refreshSendOrder(false);
      return;
    }
    bool showTimeNote = false;
    try {
      print('time1111:' + _stringToTimeOfDay(_timeController.text).toString());
      if (selectedTime!.compareTo(_maxStartTime!) < 0) showTimeNote = true;
    } catch (e) {}
    try {
      if (selectedTime!.compareTo(_minEndTime!) > 0) showTimeNote = true;
    } catch (e) {}
    if (showTimeNote) {
      _flushBar(
          AppLocalizations.of(context)!.translate('Select time between ') +
              '[ $_maxStartTime - $_minEndTime ]');
      _refreshSendOrder(false);
      return;
    }
    //{CustomerId: 90e73cdd-7e7e-4207-9901-08d9a4f69d2a, Amount: 300.0, InsertDate: 2021-12-08T01:18:43.043Z, Status: 1, PayType: 1, AddressId: 66b576f9-d44b-4565-b9e3-08d9a4f82388, OrderDate: 2021-12-08T13:18:00.000Z, Notes: string, OrderServices[0][ServiceId]: 18, OrderServices[0][Price]: 300.0, OrderServices[0][Quantity]: 1, OrderServices[0][ServiceNotes]: , OrderServices[0][OrderServiceAttatchs]: }

    String orderDateTime = "${DateTime(selectedDate!.year, selectedDate!.month,
                selectedDate!.day, selectedTime!.hour, selectedTime!.minute)
            .add(timeDiff)
            .toString()
            .replaceAll(" ", "T")}Z";
    String insertDateTime = "${DateFormat('yyyy-MM-dd hh:mm:ss.sss')
            .format(DateTime.now().add(timeDiff))
            .replaceAll(" ", "T")}Z";
    /* String insertDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String insertTime = DateFormat('hh:mm:ss.sss').format(DateTime.now());
    var tmp2 = DateTime.now().toUtc().toString().split(":");
    String insertDateTime =
        insertDate.toString() + "T" + insertTime.toString() + "Z";*/
    print("************************************************************");
    print(orderDateTime);
    print(insertDateTime);
    print("************************************************************");

    bool upload = await apiService.uploadOrderWithAttachNew(id, insertDateTime,
        this.value3, orderDateTime, token, _couponId, _couponValue);
    _refreshSendOrder(false);
    if (upload) {
      order.clear();
      // ignore: use_build_context_synchronously
      _flushBar(AppLocalizations.of(context)!.translate('order added'));
      //getMyOrders(userData["content"]["Id"]);
      //setState(() {});
      showInterstitialAdd();
      showRewardAdd();
      print('1');
      if(AdHelper.interstitialAd != null)AdHelper.interstitialAd?.show();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  token: token,
                  service: service,
                  selectedIndex: 1,
                  initialOrderTab: 1,
                )),
        (Route<dynamic> route) => false,
      );
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1, initialOrderTab: 1,),),);
    }
    /*
   bool withAttach= false;
    for(int i=0; i<order.length; i++){
      if(order[i][0][0]['Service']['File']!=null)
        withAttach = true;
    }withAttach=true;
    apiService = APIService(context);
    if(withAttach){
      var response = await apiService.uploadOrderWithAttach(id, insertDateTime, this.value3, orderDateTime,token);
      if (response.statusCode == 200) {
        print(response.data);
        if ((response.data)['Errors'] == null || (response.data)['Errors'] == ''){
          print('success');
          order.clear();
          _flushBar(AppLocalizations.of(context)!.translate('order added'));
          getMyOrders(userData["content"]["Id"]);
          setState(() {});
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1,),),);
        }else{
          _flushBar((response.data)['Errors']);
        }
      } else {
        print(response.data);
        print(response.statusCode);
        print('fail');
      }
    }else{
      var response = await apiService.uploadOrderWithoutAttach(id, insertDateTime, this.value3, orderDateTime,token);
      if (response.statusCode == 200) {
        print(response.body);
        if (jsonDecode(response.body)['Errors'] == null || jsonDecode(response.body)['Errors'] == ''){
          print('success');
          order.clear();
          _flushBar(AppLocalizations.of(context)!.translate('order added'));
          getMyOrders(userData["content"]["Id"]);
          setState(() {});
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(token: token, service: service, selectedIndex: 1,),),);
        }else{
          _flushBar(jsonDecode(response.body)['Errors']);
        }
      } else {
        print(response.data);
        print(response.statusCode);
        print('fail');
      }
    }
    */
  }

  _flushBar(text) async {
    await Flushbar(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 20),
      icon: Icon(
        Icons.error_outline,
        size: MediaQuery.of(context).size.width / 18,
        color: AppColors.white,
      ),
      duration: const Duration(seconds: 3),
      shouldIconPulse: false,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.height / 37)),
      backgroundColor: Colors.grey.withOpacity(0.5),
      barBlur: 20,
      message: text,
      messageSize: MediaQuery.of(context).size.width / 22,
    ).show(context);
  }

  var _couponId = null;
  var _couponValue = 0.0;
  var _couponType = 1;
  _applyCoupon() async {
    setState(() {
      _getCoupons = true;
    });
    await APIService.getCouponRead();
    var exist = false;
    _couponValue = 0.0;
    _couponId = null;
    coupons.forEach((element) {
      if (element['CouponCode'].toString() == _couponConroller.text) {
        _couponType = element['CouponType'];
        _couponValue = element['CouponAmount'];
        _couponId = element['CouponId'];
        exist = true;
      }
    });

    if (!exist) {
      // ignore: use_build_context_synchronously
      APIService.flushBar(AppLocalizations.of(context)!.translate("Coupon code isn't exited"));
    }

    setState(() {
      _getCoupons = false;
    });
  }
}
